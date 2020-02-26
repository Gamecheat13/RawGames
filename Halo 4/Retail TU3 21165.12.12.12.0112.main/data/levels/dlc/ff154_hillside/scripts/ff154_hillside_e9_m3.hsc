//========= E9 M3 FIREFIGHT SCRIPT

// =============================================================================================================================
//=================== GLOBALS ==================================================================
// =============================================================================================================================

global boolean b_objective_complete = false; 																							// set b_objective_complete to true. When it returns false, it's safe to fire next objective
global short s_pelican_sortie = 0;																												// tells pelicans which LZ to drop off to
global short s_e9m3_scenario = 0;
	//  2 - pelican opens fire
	//  4 - almost to landing 1
	//  5 - reached landing 1
	// 10 - landing 1 cleared of prometheans
	// 20 - terrace combat complete, switchback objective initiated
	// 30 - past switchback landing, approaching gateyard
	// 40 - garrison battle initiated
	// 42 - past neck
	// 44 - end of m1
	// 46 - into m2
	// 48 - reached rear
	// 50 - garrison battle complete
	// 60 - zone set b loaded
	// 62 - tv_aerie_ramp
	// 64 - loop pt 1 started
	// 66 - loop pt 2 started
	// 68 - knights started
global short b_e9m3_dance_step = 0;
global object obj_target = none;
global string_id str_objective_text = none;																								// the current objective's text
global short s_tank_count = 0;																														// for tank respawner at end of level
global short s_init_respawn_var = 0;																											// 12-19-12

script startup hillside_e9_m3()
	//dprint( "hillside_e9_m3: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	//Wait for start
	if ( f_spops_mission_startup_wait("e9_m3_startup") ) then
		wake( e9_m3_hillside );
	else
		kill_volume_disable(kill_wtf);
	end
end

script dormant e9_m3_hillside
//	firefight_mode_set_player_spawn_suppressed(true);
//	print ("******************STARTING e9_m3*********************");
	b_wait_for_narrative_hud = true;
	//fade_out (0,0,0,1);
	// set standard mission init
	f_spops_mission_setup( "e9_m3_hillside", e9_m3_a, sg_e9m3_all, e9_m3_spawn_1, 90 );
	

//======== OBJECTS ==================================================================
	f_add_crate_folder(e9m3_crates);
	f_add_crate_folder(e9m3_switchback_crates);
	f_add_crate_folder(e9m3_gateyard_crates);
	f_add_crate_folder(e9m3_garrison_crates);
	f_add_crate_folder(e9m3_shield_barriers);
//	f_add_crate_folder(e9_m3_scenery_gates);
	f_add_crate_folder(e9m3_terrace);
	f_add_crate_folder(e9m3_loose_weapons);
	f_add_crate_folder(e9m3_ammo);
	f_add_crate_folder(sc_e9_m3_lz);
	f_add_crate_folder(e9m3_dcs);
	
// set spawn folders
	firefight_mode_set_crate_folder_at(e9_m3_spawn_1, 90); 																						//spawns in the main starting area
	firefight_mode_set_crate_folder_at(e9_m3_spawn_landing_1, 91); 																		//spawns on landing 1
	firefight_mode_set_crate_folder_at(e9_m3_spawn_terrace, 92); 																			//spawns on terrace
	firefight_mode_set_crate_folder_at(e9_m3_spawn_switchback, 93); 																	//spawns prior to switchback
	firefight_mode_set_crate_folder_at(e9_m3_spawn_gateyard, 94); 																		//spawns prior to gateyard
	firefight_mode_set_crate_folder_at(e9_m3_spawn_garrison_front, 95); 															//spawns at start of garrison
	firefight_mode_set_crate_folder_at(e9_m3_spawn_garrison_rear, 96); 																//spawns in garrison
	firefight_mode_set_crate_folder_at(e9_m3_spawn_garrison_tanks, 97); 															//spawns by garrison scorpions
	firefight_mode_set_crate_folder_at(e9_m3_spawn_aerie, 98); 																				//spawns in gateyard facing aerie
// set objectives
	firefight_mode_set_objective_name_at(dc_e9m3_switch_1,	1); 																			//computer terminal at first gate
	firefight_mode_set_objective_name_at(sc_switchback_landing,	2); 																	//switchback landing
	firefight_mode_set_objective_name_at(sc_gateyard,	3); 																						//gateyard landing
	firefight_mode_set_objective_name_at(sc_garrison,	4); 																						//garrison landing
	firefight_mode_set_objective_name_at(e9m3_barrier_1,	5); 																				//energy barrier at first landing
	firefight_mode_set_objective_name_at(sc_landing_1,	6); 																					//landing
	firefight_mode_set_objective_name_at(dc_e9m3_switch_2,	7); 																			//computer terminal at garrison
	firefight_mode_set_objective_name_at(e9m3_barrier_5,	8); 																				//energy barrier at garrison cave entrance
	firefight_mode_set_objective_name_at(sc_cave_1,	9); 																							//cave midpoint
	firefight_mode_set_objective_name_at(sc_cave_2,	10); 																							//cave end
	firefight_mode_set_objective_name_at(e9m3_barrier_aerie,	11); 																		//energy barrier between gateyard and aerie
	firefight_mode_set_objective_name_at(dc_e9m3_switch_3,	12);
	// This will now allow everything to start spawning
	thread (f_start_events_e9_m3());																																	//start the first starting event
	f_spops_mission_setup_complete( TRUE );
end

//========STARTING E9 M3==============================

script static void f_start_events_e9_m3
//	print("*********************** start_e9_m3_1");
	thread (f_e9_m3_thread_all());
	sleep_until( f_spops_mission_ready_complete(), 1 );
	if editor_mode() then
		fade_in (0,0,0,1);
//		f_e9m3_narrative_in();
		firefight_mode_set_player_spawn_suppressed(false);
	else
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		f_e9m3_narrative_in();
		firefight_mode_set_player_spawn_suppressed(false);
	end
	f_spops_mission_intro_complete( TRUE );
	sleep_until( f_spops_mission_start_complete(), 1 );
	effects_distortion_enabled = 0;
	b_end_player_goal = true;
	object_destroy(sco);
	object_destroy(sco1);
	thread(f_e9m3_place_initial_combatants_and_materials());
	thread(f_e9m3_music_start());
	thread(f_e9m3_objectives_script());
	object_set_function_variable (e9m3_barrier_1, "shield_on", 1, 1);
	object_cannot_take_damage(e9m3_barrier_1);
	fade_in (0,0,0,30);
end

script static void f_e9m3_narrative_in
	pup_disable_splitscreen (true);
	local long show = pup_play_show(e9_m3_intro);
	sleep(30);
	thread(vo_e9m3_narrative_in());
	sleep_until (not pup_is_playing(show), 1);
	pup_disable_splitscreen (false);
end

script static void f_e9_m3_thread_all
	// start all the event scripts	
//	print ("starting e9_m3 events");
	sleep(30);
	kill_volume_disable(kill_wtf);
	thread(f_e9m3_initial_dms());
//	thread(f_e9m3_faux_phantom());
	thread(f_e9m3_pre_landing());
	thread(f_e9m3_encounter_landing_1(true));
/*//1-4-2013================																																				// 1-4-2013
	thread(f_e9m3_garrison_init(true));																																
	thread(f_e9m3_switchback_sequence());
	thread(f_e9m3_gateyard_sequence());
	thread(f_e9m3_end_mission());
	thread(f_e9m3_cap_apertures());
	//1-4-2013================*/
	thread(f_e9m3_nohurtfriendlyvehicles());
	thread(f_e9m3_encounter_1_progress());
	thread(f_e9m3_first_encounter_conversation());
end

script static void f_e9_m3_thread_the_rest																													// 1-4-2013
	thread(f_e9m3_garrison_init(true));																																
	thread(f_e9m3_switchback_sequence());
	thread(f_e9m3_gateyard_sequence());
	thread(f_e9m3_end_mission());
	thread(f_e9m3_cap_apertures());
end
//== -- enc 1
script static void f_e9m3_place_initial_combatants_and_materials																		// 12-19-12
	object_create(e9m3_scorpion_1);
	ai_place(sq_e9m3_pelican_1);
	ai_place(sq_e9m3_pelican_1a);
	object_create(e9m3_scorpion_2);
	thread(f_e9m3_tank_drop_audio(tv_audio_0, e9m3_scorpion_2));
	if(game_coop_player_count() == 1)then
		ai_place(sq_e9m3_marine);
	end
	ai_place(sq_e9m3_phantom_1);
	ai_place(sq_e9m3_landing_cov.init1);
	ai_place(sq_e9m3_landing_cov.init2);
	ai_place(sq_e9m3_landing_cov.init3);
	ai_place(sq_e9m3_init_cov.init1);
	ai_braindead(sq_e9m3_init_cov.init1, true);
	sleep(30 * 3);
	ai_braindead(sq_e9m3_init_cov.init1, false);
end


script static void f_e9m3_encounter_1
	thread(f_e9m3_tank_respawner_1());
	thread(f_e9m3_garbage_recycler_1());
	sleep(60);
	//ai_place_in_limbo(sq_e9m3_intro_pawns_b, 2);																				//v-mageer, 1-7-13, removed pawns and combined the two sleeps into a single sleep, MNDE-3922
	//sleep(20);
	sleep_until(ai_living_count(ai_ff_all) < 9);																					//v-mageer, 1-7-13, lowered number from 12 to 9, MNDE-3922
	
	//ai_place_in_limbo(sq_e9m3_intro_pawns_r, 2);																				//v-mageer, 1-7-13, removed pawns, MNDE-3922
	thread(f_e9m3_first_encounter_respawn());
//	sleep(20);
//	ai_place_in_limbo(sq_e9m3_intro_pawns_l, 2);
//	sleep(30);
//	ai_place_in_limbo(sq_e9m3_intro_pawns_b, 2);
//	thread(f_e9m3_respawn_pawns_1());

end

script static void f_e9m3_first_encounter_respawn																					// 12-19-12
	
	repeat
		sleep_until(ai_living_count(ai_ff_all) <= 8);																					//v-mageer, 1-7-13, lowered this number from 11 to 8, MNDE-3922
		if(s_init_respawn_var < 5)then																												// prior to first trigger
			ai_place(sq_e9m3_init_cov.init2);
			ai_place(sq_e9m3_init_cov.init3);
			s_init_respawn_var = s_init_respawn_var + 2;
		elseif(s_init_respawn_var == 7)then																										// prior to second trigger, second respawn
			ai_place(sq_e9m3_landing_cov.reinf1);
			ai_place(sq_e9m3_landing_cov.reinf2);
			//ai_place_in_limbo(sq_e9m3_intro_pawns_b, 1);																			//v-mageer, 1-7-13, removed pawns, MNDE-3922
			if(s_init_respawn_var < 10)then
				s_init_respawn_var = s_init_respawn_var + 2;
			end
		elseif(s_init_respawn_var < 10)then																										// prior to second trigger, first and third respawn
			ai_place(sq_e9m3_init_cov.reinf1);
			//ai_place_in_limbo(sq_e9m3_intro_pawns_l, 2);																			//v-mageer, 1-7-13, removed pawns, MNDE-3922
			if(s_init_respawn_var < 10)then
				s_init_respawn_var = s_init_respawn_var + 2;
			end
		elseif(s_init_respawn_var < 15)then																										// prior to third trigger
			ai_place(sq_e9m3_landing_cov.reinf1);
			ai_place(sq_e9m3_landing_cov.reinf2);
			if(s_init_respawn_var < 15)then
				s_init_respawn_var = s_init_respawn_var + 2;
			end
		end
		
	until(		(s_init_respawn_var >= 15)
				or	(s_e9m3_scenario >= 4)
				, 1);
end

script static void f_e9m3_encounter_1_progress
	sleep_until(volume_test_players(tv_covspawn_1));
		if(s_init_respawn_var < 5)then
			s_init_respawn_var = 5;
		end
	sleep_until(volume_test_players(tv_covspawn_2));
		if(s_init_respawn_var < 10)then
			s_init_respawn_var = 10;
		end
	sleep_until(volume_test_players(tv_covspawn_3));
		if(s_init_respawn_var < 15)then
			s_init_respawn_var = 15;
		end
	sleep_until(volume_test_players(tv_pre_landing));
	s_init_respawn_var = 20;
end

script static void f_e9m3_first_encounter_conversation
	sleep_until(s_e9m3_scenario >= 2);
	sleep(30);
	if(e9m3_narrative_is_on == false)then
		vo_e9m3_air_support();
			// Dalton : We can offer a bit of air support, Crimson. Try to stay clear of the flak.
	end
end

script static void f_e9m3_initial_dms
	sleep(15);
	f_add_crate_folder(e9m3_dms);
	sleep(10);
	f_terminal_setup(dm_e9m3_panel_1, dc_e9m3_switch_1);
	f_terminal_setup(dm_e9m3_panel_2, dc_e9m3_switch_2);
	f_terminal_setup(dm_e9m3_panel_3, dc_e9m3_switch_3);
end

script static void f_e9m3_respawn_pawns_1
	local short s_respawn_count = 0;
	repeat
		sleep_until	(		(ai_living_count(sg_e9m3_pawns) <= 4)
								and	(ai_living_count(ai_ff_all) <= 16), 10																					// 1-4-2013
								);
		
		if(s_e9m3_scenario < 4)then
			ai_place_in_limbo(sq_e9m3_intro_pawns_b, 2);
			sleep(20);
			ai_place_in_limbo(sq_e9m3_intro_pawns_r, 2);
			sleep(20);
			s_respawn_count = s_respawn_count + 4;
			if(s_respawn_count <= 20)then
				ai_place_in_limbo(sq_e9m3_intro_pawns_l, 2);
				s_respawn_count = s_respawn_count + 2;
			end
		end
//	thread(f_e9m3_garbage_collect_timer(3));
	until	(		(s_respawn_count >= 24)
				or	(s_e9m3_scenario >= 4), 1
				);
end

script static void f_e9m3_pawn_cleanup_hack
	sleep_until(volume_test_players(tv_wtf) == false);
	kill_volume_enable(kill_wtf);
	sleep_until(volume_test_players(tv_wtf), 1, 30 * 1);
	kill_volume_disable(kill_wtf);
end

script static void f_e9m3_faux_phantom
	sleep_until(volume_test_players (tv_landing_approach));
	if(ai_living_count(sg_e9m3_all) <= 16)then
		ai_place(sq_e9m3_phantom_4);
	end
end
script static void f_e9m3_summon_pelican_hunters
	if(ai_living_count(ai_ff_all) <= 14)then
		sleep(30 * 3);
		ai_place(sq_e9m3_pelican_hunters.1);
	elseif(ai_living_count(ai_ff_all) <= 8)then
		sleep(30 * 3);
		ai_place(sq_e9m3_pelican_hunters.1);
		sleep(30 * 3);
		ai_place(sq_e9m3_pelican_hunters.2);
		sleep(30 * 3);
		ai_place(sq_e9m3_pelican_hunters.3);
	end
end

//--landing 1
script static void f_e9m3_pre_landing
	sleep_until(volume_test_players (tv_pre_landing), 1);
	if(s_e9m3_scenario < 5)then
		s_e9m3_scenario = 4;
	end
end

script static void f_e9m3_encounter_landing_1
	thread(sys_e9m3_encounter_landing_1());
end

script static void f_e9m3_encounter_landing_1 (boolean b_bool)
	if(b_bool == true)then
		sleep_until(volume_test_players (tv_landing_1), 1);
	end
	thread(sys_e9m3_encounter_landing_1());
end

script static void sys_e9m3_encounter_landing_1
	s_e9m3_scenario = 5;
	if(		(ai_living_count(ai_ff_all) <= 14)																								// 12-19-12
		)	then
		ai_place(sq_e9m3_init_anti_armor);
	end
	if(ai_living_count(ai_ff_all) <= 14)then
		ai_place(sq_e9m3_bishops_1.1);
		ai_place(sq_e9m3_bishops_1.2);
	end
	if(ai_living_count(ai_ff_all) <= 13)then
		ai_place(sq_e9m3_bishops_1.3);
	end
	if(ai_living_count(ai_ff_all) <= 13)then
		ai_place(sq_e9m3_landing_cov.land1);
		ai_place(sq_e9m3_landing_cov.land2);
	end
	if(ai_living_count(ai_ff_all) <= 13)then
		ai_place(sq_e9m3_landing_cov.land3);
		ai_place(sq_e9m3_landing_cov.land4);
	end
	
	thread(f_e9m3_pawn_cleanup_hack());
	
	f_e9m3_landing_1_phantom_spawner();
	
	thread(f_e9m3_landing_1_bishop_respawn_sequence());																			// 12-19-12
	sleep(4);
	s_e9m3_scenario = 6;
	sleep_until(ai_living_count(ai_ff_all) <= 8);
	
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3, 2, 1));
	
	sleep_until(ai_living_count(ai_ff_all) <= 8);
	
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_4, 2, 1));
	
	sleep_until(ai_living_count(ai_ff_all) <= 8);
	
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_5, 2, 1));
	sleep(5);
	thread(f_e9m3_pawn_cleanup_hack());
	sleep_until(		(ai_living_count(sg_e9m3_bishops) + ai_living_count(sg_e9m3_pawns)) <= 2
							and (ai_living_count(ai_ff_all) <= 17)
							, 2 );
	sleep_until(ai_living_count(sg_e9m3_bishops) == 0 and ai_living_count(sg_e9m3_pawns) <= 0 and ai_living_count(sg_e9m3_cov_ground) == 0 );
	s_e9m3_scenario = 10;
//	ai_erase(sq_e9m3_pelican_hunters);
end

script static void f_e9m3_landing_1_phantom_spawner
	sleep_until(ai_living_count(ai_ff_all) <= 14);
	ai_place(sq_e9m3_phantom_3);
	thread(f_e9m3_door_gunner_advice());
	sleep_until(ai_living_count(ai_ff_all) <= 12);
	ai_place(sq_e9m3_phantom_2);
	
end

script static void f_e9m3_door_gunner_advice
	sleep(30 * 7);
	vo_e9m3_gunners();
			// Roland: Mind a spot of tactical advice, Crimson?
			// Roland: Shoot the door gunner.
			// Roland: They’ll be less likely to, you know, shoot you first.
end

script static void f_e9m3_landing_1_bishop_respawn_sequence
	sleep_until(		(ai_living_count(sg_e9m3_bishops) <= 1)
							and	(ai_living_count(ai_ff_all) <= 12)
							);
	ai_place(sq_e9m3_bishops_1.4);
	sleep_until(		(ai_living_count(sg_e9m3_bishops) <= 1)
						and	(ai_living_count(ai_ff_all) <= 12)
						);
	ai_place(sq_e9m3_bishops_1.5);
	sleep_until(		(ai_living_count(sg_e9m3_bishops) <= 2)
							and	(ai_living_count(ai_ff_all) <= 13)
							);
	ai_place(sq_e9m3_bishops_1.6);
end

script static boolean f_e9m3_landing_encounter_is_complete
	if	(
				(ai_living_count(sg_e9m3_ghosts) <=  0) and
				(ai_living_count(sg_e9m3_pawns) <=  0) and
				(ai_living_count(sg_e9m3_bishops) <=  0) and
				(ai_living_count(sg_e9m3_cov_ground) <=  0) and
				(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) and
				(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0))) and
				(s_e9m3_scenario >= 6)
			)	then
		true;
	else
		false;
	end
end

//== --terrace
script static boolean f_e9m3_begin_terrace
	sleep_until(volume_test_players (tv_terrace), 1);
	thread(f_e9m3_enable_shields());
	thread(f_e9m3_terrace_spawn_sequence());
	thread(f_e9m3_music_ambush_start());
	thread(f_e9m3_terrace_vo());
	b_end_player_goal = true;																																					//advance objectives (to update spawn points)
	sleep_until	(
								(				(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == false)
								and			(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == false)
								and			(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0), false) == false)
								and			(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0), true) == false)
								and			(ai_living_count(ai_ff_all) <= 3)
								) 
							or			(volume_test_players (tv_switchback)), 1
							);
	s_e9m3_scenario = 20;
	true;
end

script static void f_e9m3_terrace_spawn_sequence
	ai_place(sq_e9m3_phantom_2b);
	sleep(30 * 1.5);
	thread(f_e9m3_terrace_promethean_spawn());
	sleep(30);
	thread(spops_blip_flag( fl_garrison, false));
	ai_place(sq_e9m3_phantom_2c);
end

script static void f_e9m3_terrace_vo
	sleep(30 * 2);
	vo_e9m3_ambush();
			// Miller : Ambush!
	sleep(30 * 1.5);
	f_blip_ai_cui(sq_e9m3_phantom_2b.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_2b.3, "navpoint_enemy");
	sleep(30 * 8);
	vo_e9m3_behind_you();
			// Miller : Careful, Spartans! They're boxing you in!
	f_blip_ai_cui(sq_e9m3_phantom_2c.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_2c.3, "navpoint_enemy");
end

script static void f_e9m3_terrace_promethean_spawn
	ai_place(sq_e9m3_bishops_3a.1);
	sleep(10);
	ai_place(sq_e9m3_bishops_3c.1);
	sleep(30);
	ai_place(sq_e9m3_bishops_3b.1);
	thread(f_e9m3_terrace_bishop_respawner());
	sleep(30 * 2);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3a, 2, 1, sq_e9m3_pawns_3a, 14, 2));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3b, 2, 1, sq_e9m3_pawns_3b, 14, 2));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3c, 2, 1, sq_e9m3_pawns_3c, 14, 2));
end

script static void f_e9m3_terrace_bishop_respawner
	sleep_until(ai_living_count(sg_e9m3_bishops) < 3);
	ai_place(sq_e9m3_bishops_3a.2);
	sleep_until(ai_living_count(sg_e9m3_bishops) < 3);
	ai_place(sq_e9m3_bishops_3b.2);
	ai_place(sq_e9m3_bishops_3c.2);
	sleep_until(ai_living_count(sg_e9m3_bishops) < 3);
	ai_place(sq_e9m3_bishops_3c.1);
end

script static void f_e9m3_cant_proceed
	local short s_count = 0;
	repeat
		if(		(volume_test_players(tv_garrison_view) == true)
			and (e9m3_narrative_is_on == false)
			and	(s_e9m3_scenario == 20)
			and	(		player_in_vehicle(e9m3_scorpion_1)
					or	player_in_vehicle(e9m3_scorpion_2)
					or	player_in_vehicle(e9m3_scorpion_3)
					or	player_in_vehicle(e9m3_scorpion_4)
					or	player_in_vehicle(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)) 
					or	player_in_vehicle(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)) 
					or	player_in_vehicle(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)) 
					or	player_in_vehicle(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)) 
					)	
			)			then
			vo_e9m3_cant_fit();
				// Miller : The Scorpions aren't going to fit through there. You'll need to proceed on foot from here.
		end
		sleep(30 * 20);
		s_count = s_count + 1;
	until(	(s_e9m3_scenario > 20)
				or(s_count >= 3)
				);
end

//== --SWITCHBACK

// tv_greg_cave
script static void f_e9m3_switchback_sequence
	
	sleep_until	(LevelEventStatus("e9m3_switchback") or volume_test_players (tv_switchback_approach), 1); 
	ai_place(sq_e9m3_plasma_gunners_1.2);
	if	(	list_count(players()) >= 2)	then
		ai_place(sq_e9m3_plasma_gunners_1.1);
	end
	
	sleep(3);
	
	thread(f_e9m3_plasma_turret_slider());
	thread(f_e9m3_switchback_fuel_rodders());
	
	if(ai_living_count(sg_e9m3_all) <= 18)then
		ai_place(sq_e9m3_switchback_grunts_init);
	end
	
	sleep_until	(volume_test_players (tv_switchback_approach), 1);
	
	if(ai_living_count(sg_e9m3_all) <= 18) and (ai_living_count(sq_e9m3_switchback_grunts_init) == 0) then
		ai_place(sq_e9m3_switchback_grunts_init);
	end
	sleep(2);
		
	if(volume_test_players (tv_greg_cave) == false) and (ai_living_count(sg_e9m3_all) <= 18) then
		ai_place(sq_e9m3_switchback_kamikazes.2);		
		ai_place(sq_e9m3_switchback_kamikazes.3);
	end
	
	if(volume_test_players (tv_gateyard_approach) == false) and (ai_living_count(sg_e9m3_all) <= 19) then
		ai_place(sq_e9m3_switchback_kamikazes.1);
	end
	sleep(2);
	sleep_until(ai_living_count(sq_e9m3_switchback_kamikazes) <= 2) or (ai_living_count(sg_e9m3_switchback) <= 4);
	
	
	if(volume_test_players (tv_gateyard_approach) == false) and (ai_living_count(sg_e9m3_all) <= 19) then
		ai_place(sq_e9m3_switchback_bulk.1);
	end
	
	if		(volume_test_players (tv_gateyard_approach) == false)
		and (volume_test_players (tv_greg_cave) == false)
		and	(ai_living_count(sg_e9m3_all) <= 18) 
		then
		ai_place(sq_e9m3_bishops_switchback.1);
		ai_place(sq_e9m3_bishops_switchback.4);
	end
	
	if(volume_test_players (tv_greg_cave) == false) and (ai_living_count(sg_e9m3_all) <= 16) then
		ai_place(sq_e9m3_switchback_bulk.2);
		ai_place(sq_e9m3_switchback_bulk.3);
		ai_place(sq_e9m3_switchback_bulk.4);
		ai_place(sq_e9m3_switchback_bulk.5);
	end
	
	if		(volume_test_players (tv_gateyard_approach) == false)
		and (volume_test_players (tv_greg_cave) == false)
		and	(ai_living_count(sg_e9m3_all) <= 18) 
		then
		ai_place(sq_e9m3_bishops_switchback.2);
		ai_place(sq_e9m3_bishops_switchback.3);
	end
	
end

script static void f_e9m3_switchback_fuel_rodders
	sleep_until(ai_living_count(sq_e9m3_plasma_gunners_1) <= 1);
	sleep(30 * 2);
	if(volume_test_players (tv_greg_cave) == false) and (ai_living_count(sg_e9m3_all) <= 19) then
		ai_place(sq_e9m3_switchback_fusiliers);
	end
	sleep(30);
	sleep_until(ai_living_count(sg_e9m3_all) <= 5);
	if(s_e9m3_scenario == 20)then
		s_e9m3_scenario = 21;
	end
end

script static void f_e9m3_plasma_turret_slider
	thread(f_e9m3_bob(ai_vehicle_get_from_spawn_point(sq_e9m3_plasma_gunners_1.1)));
	sleep(15);
	thread(f_e9m3_bob(ai_vehicle_get_from_spawn_point(sq_e9m3_plasma_gunners_1.2)));
end

/*
	-46.598743, 8.814449, 12.857832
	-43.195908, 12.718722, 12.564632
 -3.402835 
		-0.19521365 * x
 3.904273
		0.19521365 * x
*/
script static void f_e9m3_bob(object ob_turret)
	local short s_jiggle = 0;
	repeat
		object_move_by_offset(ob_turret, .3, .58564095, 0.58564095, .09);				//<time>, <X offset> <Y offset> <Z offset>
		sleep(2);
		object_move_by_offset(ob_turret, .2, .3904273, 0.3904273, -.09);
		s_jiggle = s_jiggle + 15;
	until(s_jiggle == 60, 1);
	sleep(2);
end

//== --gateyard
script static void f_e9m3_gateyard_sequence
	sleep_until(volume_test_players (tv_gateyard_approach), 1);
	thread(f_e9m3_gateyard_spawning());
	sleep_until(volume_test_players (tv_gateyard), 1);
	thread(f_e9m3_gateyard_spawning());
	f_add_crate_folder(e9m3_vehicles_3);
end

script static void f_e9m3_gateyard_spawning																								// spawn in priority order, as there's room
	if ((ai_living_count(ai_ff_all) <= 18) and (ai_living_count(sq_e9m3_gateyard_plasmas)<= 0))then
		ai_place(sq_e9m3_gateyard_plasmas);
	end
	if ((ai_living_count(ai_ff_all) <= 17) and (ai_living_count(sq_e9m3_gateyard_grunts_1)<= 0))then
		ai_place(sq_e9m3_gateyard_grunts_1);
	end
	sleep(1);
	if ((ai_living_count(ai_ff_all) <= 17) and (ai_living_count(sq_e9m3_gateyard_grunts_1)<= 0))then
		ai_place(sq_e9m3_gateyard_grunts_2);
	end
	if ((ai_living_count(ai_ff_all) <= 17) and (ai_living_count(sq_e9m3_gateyard_reserves)<= 0))then
		ai_place(sq_e9m3_gateyard_reserves);
	end
end



//== --garrison
script static void f_e9m3_garrison_init
	thread(sys_e9m3_garrison_init(false));
end

script static void f_e9m3_garrison_init(boolean wait)
	thread(sys_e9m3_garrison_init(wait));
end

script static void sys_e9m3_garrison_init(boolean wait)
	if(wait == true)then
		sleep_until(volume_test_players (tv_garrison_approach), 1);
	end
	s_e9m3_scenario = 40;
	thread(f_e9m3_garrison_spawn_wave_1());
	thread(f_e9m3_garrison_spawn_wave_2());
	thread(f_e6m4_track_garrison_progress());
end

script static void f_e9m3_garrison_spawn_wave_1
	// left grunts
	if 		(		(ai_living_count(ai_ff_all) <= 17) and
						(ai_living_count(sq_e9m3_garrison_grunts_left) == 0) and
						(volume_test_players(tv_garrison_view)== false)
				)	then
			ai_place(sq_e9m3_garrison_grunts_left.1);
	elseif(		(ai_living_count(ai_ff_all) <= 17) and
						(ai_living_count(sq_e9m3_garrison_grunts_left) == 0) and
						(volume_test_players(tv_garrison_view)== true)
				)	then
			ai_place(sq_e9m3_garrison_grunts_left.2);
	end
	
	// right grunts
	if 		(		(ai_living_count(ai_ff_all) <= 17) and
						(ai_living_count(sq_e9m3_garrison_grunts_right) == 0) and
						(volume_test_players(tv_garrison_channel)== false) and
						(volume_test_players(tv_garrison_view)== false)
				)	then
			ai_place(sq_e9m3_garrison_grunts_right.1);
	elseif 		(		(ai_living_count(ai_ff_all) <= 17) and
						(ai_living_count(sq_e9m3_garrison_grunts_right) == 0) and
						(volume_test_players(tv_garrison_channel)== true) and
						(volume_test_players(tv_garrison_view)== false)
				)	then
			ai_place(sq_e9m3_garrison_grunts_right.2);
	elseif(		(ai_living_count(ai_ff_all) <= 17) and
						(ai_living_count(sq_e9m3_garrison_grunts_right) == 0) and
						(volume_test_players(tv_garrison_view)== true)
				)	then
			ai_place(sq_e9m3_garrison_grunts_right.3);
	end

end

script static void f_e9m3_garrison_spawn_wave_2

// elites 1
	if		(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_elites_a) == 0) and
						(s_e9m3_scenario >= 42)
				)	then
					
					ai_place(sq_e9m3_garrison_elites_a.3);
					
	elseif(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_elites_a) == 0) and
						(volume_test_players(tv_garrison_view)== false)
				)	then
					
					ai_place(sq_e9m3_garrison_elites_a.1);
					
	elseif(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_elites_a) == 0) and
						(volume_test_players(tv_garrison_view)== true)
				)	then
					
					ai_place(sq_e9m3_garrison_elites_a.2);
					
	end
sleep(1);

// left grunts, wave 2
	if 		(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_grunts_left_2) == 0) and
						(s_e9m3_scenario >= 42)
				)	then
	
			ai_place(sq_e9m3_garrison_grunts_left_2.2);
	
	elseif(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_grunts_left_2) == 0)
				)	then
	
				ai_place(sq_e9m3_garrison_grunts_left_2.1);
				
	end

// right grunts, wave 2
	
	if 		(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_grunts_right_2) == 0)
				)	then
			ai_place(sq_e9m3_garrison_grunts_right_2);
	end

// elite + 2 grunts
	if 		(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_mid) == 0)
				)	then
			ai_place(sq_e9m3_garrison_mid);
	end
end

script static void f_e9m3_garrison_spawn_wave_3
// phantom	
	if	(ai_living_count(ai_ff_all) <= 18)	then
			ai_place(sq_e9m3_phantom_boss);
			sleep(30 * 1.5);
			thread(f_e9m3_music_mini_boss_start());
	else
		thread(f_e9m3_place_phantom_boss());
	end

// goal keepers
	if 		(		(ai_living_count(ai_ff_all) <= 18) and
						(ai_living_count(sq_e9m3_garrison_goalkeepers) == 0)
				)	then
			ai_place(sq_e9m3_garrison_goalkeepers);
	end
// bishops


// initialize bishop / pawn respawn

end

script static void f_e9m3_place_phantom_boss
	sleep_until(ai_living_count(ai_ff_all) <= 17);
	if(ai_living_count(sq_e9m3_phantom_boss) == 0)then
		ai_place(sq_e9m3_phantom_boss);
		sleep(30 * 1.5);
		thread(f_e9m3_music_mini_boss_start());
	end
end

script static void f_e6m4_track_garrison_progress
	sleep_until(volume_test_players(tv_42) == true, 1);
	s_e9m3_scenario = 42;
	thread(f_e9m3_garrison_spawn_wave_2());
	sleep_until(volume_test_players(tv_44) == true, 1);
	s_e9m3_scenario = 44;
	thread(f_e9m3_music_on_foot_stop());
	thread(f_e9m3_garrison_spawn_wave_3());
	sleep(5);
	sleep_until(	(volume_test_players(tv_46) == true) or
								(ai_living_count(sg_e9m3_all) < 5), 1
							);
	s_e9m3_scenario = 46;
	
	sleep_until	(	(ai_living_count(sg_e9m3_garrison) == 0) and
								(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_boss, 0)) == true)						
							);
	sleep(30 * 4);
	b_end_player_goal = true;																																				//advance objectives (to console interaction stuff)	
	b_wait_for_narrative_hud = true;	
end

//== --aerie

script static void f_e9m3_initialize_aerie
	sys_e9m3_initialize_aerie(false);
end

script static void f_e9m3_initialize_aerie (boolean cheat)
	sys_e9m3_initialize_aerie(cheat);
end

script static void sys_e9m3_initialize_aerie(boolean cheat)
	prepare_to_switch_to_zone_set (e9_m3_b);
	s_e9m3_scenario = 50;
//	print("-----------------------------------------------starting zone switch");
	thread(f_e9m3_aerie_spawn_init_pawns());
	f_add_crate_folder(e9m3_aerie_crates);
	if(cheat == false)then
		sleep_until(volume_test_players(tv_cave_2) == true, 1);
	else																																										// CHEAT
		thread(f_e9m3_place_scorpions_in_garrison_or_gateyard());															// CHEAT
		object_create_anew(e9m3_barrier_aerie);
		thread(f_e9m3_aerie_barrier_manager());
	end																																											// CHEAT
//	print ("--------------------------------------------sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1); 
	sleep(5);
//	print ("-----------------------------------------------------------switching zone set");
	switch_zone_set (e9_m3_b);
	sleep(5);
	current_zone_set_fully_active(); 
	thread(f_e9m3_aerie_combat_initialize());
	thread(f_e9m3_garbage_recycler_2());
	sleep(3);
	s_e9m3_scenario = 60;
	if(cheat == true) then																																	// CHEAT
		sleep_until(volume_test_players(tv_cave_2) == true, 1);																// CHEAT
		thread(f_e9m3_sequence_aerie());																											// CHEAT
	end																																											// CHEAT
end

script static boolean f_e9m3_aerie_barriers
	b_end_player_goal = true;																																					// advance objectives (to destroy gates 3 / 4)
	b_wait_for_narrative_hud = true;
	if(object_active_for_script (e9m3_barrier_aerie))then
		thread(f_e9m3_marking_your_target_vo());
				// Miller : Marking your target now.
		sleep(30);
		thread(f_e9m3_objective(e9m3_destroy_barrier, false));																									// new objective/tank sub-objective loop
			//Destroy Barrier
		sleep(30);
		b_wait_for_narrative_hud = false;
		sleep_until(object_active_for_script (e9m3_barrier_aerie) == false);
		f_e9m3_objective_complete();																																		// kills objective/tank sub-objective loop
		sleep(16);
	end
	b_wait_for_narrative_hud = false;
	thread(vo_e9m3_locked_down());
			// Miller : Area secured. Dalton, you've got a safe drop spot if you need one.
			// Dalton : Acknowledged, Miller.
	f_create_new_spawn_folder(98);
	sleep(30);
	true;
end

script static boolean f_e9m3_sequence_aerie()																												// called once scenario advances to 60/tv_cave_2 hit
	
	// --cave_2
	sleep(30);
	ai_place_in_limbo(sq_e9m3_knight_commanders.1);
	thread(f_e9m3_music_grand_finale_start());
	sleep(30);
	if(e9m3_narrative_is_on == false)then
		vo_e9m3_battle_chatter_knights();
				// Miller : Promethean Knights on the field. We've seen them tear through Scorpion armor before, so be careful!
	end
	sleep(30);
	thread(f_e9m3_objective_text_display (generic_objective_e));
				//Eliminate Hostiles
	// --init pawns
	if( 	(volume_test_players(tv_aerie_ramp) == false)
		and	(volume_test_players(tv_aerie_plateau) == false)
		and (ai_living_count(ai_ff_all) <= 13)
		) then
		ai_place(sq_e9m3_aerie_pawns_ramp_1);
		sleep(30 * 2);
		ai_place(sq_e9m3_aerie_pawns_ramp_2);
		ai_place(sq_e9m3_aerie_bishop_ramp);
//		thread(f_e9m3_garbage_collect_timer(8));
	end
	
	// --plateau
	sleep_until(volume_test_players(tv_aerie_plateau));
	if(		(ai_living_count(ai_ff_all) <= 14)
		and (ai_living_count(sq_e9m3_aerie_bishops_1) >= 1)
		)		then
		ai_place_with_shards(sq_e9m3_ai_turret_2);
	end
	if(ai_living_count(ai_ff_all) <= 15)then
		ai_place_with_shards(sq_e9m3_ai_turret_6);
	end
	if(		(ai_living_count(ai_ff_all) <= 15)
		and (ai_living_count(sq_e9m3_aerie_bishops_bay_2) >= 1)
		) 	then
		ai_place_with_shards(sq_e9m3_ai_turret_4);
	end
	
	// --ghosts
	sleep_until(ai_living_count(ai_ff_all) <= 12);
	if (volume_test_players(tv_aerie_loop) == false)then
		ai_place(sq_e9m3_aerie_ghostriders_1);
		sleep(30 * 1.5);
		sleep_until(e9m3_narrative_is_on == false);
		e9m3_narrative_is_on = true;
		vo_glo15_miller_ghosts_01();
				// Miller : Ghosts!
		e9m3_narrative_is_on = false;
	end
	
//	thread(f_e9m3_garbage_collect_timer(4));
	
	// --bishops / pawns
	sleep_until(ai_living_count(ai_ff_all) <= 10);
//	thread(f_e9m3_garbage_collect_timer(4));
	if (volume_test_players(tv_aerie_loop) == false)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.1);
		ai_place(sq_e9m3_aerie_bishops_loop_back.2);
		sleep(30);
		ai_place_with_shards(sq_e9m3_aerie_pawns_loop_1);
		if(ai_living_count(ai_ff_all) <= 16)then
			ai_place_with_shards(sq_e9m3_aerie_pawns_loop_2);
		end
	end
	
//	thread(f_e9m3_garbage_collect_timer(10));
	
	// --sneaky bishop 1
	sleep_until(ai_living_count(ai_ff_all) <= 11);
	ai_place(sq_e9m3_aerie_bishops_1.2);
	sleep(30);
	vo_e9m3_covenant_incoming();
			// Miller : Crimson, the whole place is crawling. I can shout out warnings, or you can just cut to the chase and dump ammo in every direction at once.
	
	// --loop:
	s_e9m3_scenario = 64;
	f_e9m3_loop_sequence_part_1();
	f_e9m3_loop_sequence_part_2();
	
	// -- knights
	sleep_until(ai_living_count(ai_ff_all) <= 5);
	f_e9m3_knight_sequence();
	true;
end

script static void f_e9m3_aerie_combat_initialize
	// --ramp
	sleep_until(volume_test_players(tv_aerie_ramp), 1);
	s_e9m3_scenario = 62;
	ai_place_in_limbo(sq_e9m3_knights_1.init, 1);
	ai_allow_resurrect(sq_e9m3_knights_1, false);
	ai_place(sq_e9m3_aerie_bishops_1.1);
	if(ai_living_count(ai_ff_all) <= 17)then
		ai_place(sq_e9m3_bay_2);
	end
	sleep(1);
	if(ai_living_count(ai_ff_all) <= 18)then
		ai_place(sq_e9m3_north_loop);
	end
	if(ai_living_count(ai_ff_all) <= 19)then
		ai_place(sq_e9m3_aerie_bishops_bay_2);
	end
	sleep(1);
	if(ai_living_count(ai_ff_all) <= 19)then
		ai_place(sq_e9m3_aerie_bishops_loop_base);
	end
	if(e9m3_narrative_is_on == false)then
		thread(vo_e9m3_watchers_1());
				// Miller : You've got several Watchers in the area.
	end
end

script static boolean f_e9m3_loop_sequence_part_1

	// -- initial loop population [3 o clock]
		sleep_until(ai_living_count(ai_ff_all) <= 11);
		ai_place_in_limbo(sq_e9m3_knights_3, 1);
		if (volume_test_players(tv_back_of_loop) == false)then
			ai_place(sq_e9m3_aerie_bishops_loop_3o.d);
			ai_place(sq_e9m3_aerie_bishops_loop_3o.e);
			ai_place(sq_e9m3_aerie_bishops_loop_3o.f);
			sleep(30 * 2);
			ai_place_with_shards(sq_e9m3_ai_turret_loop_d);
			ai_place_with_shards(sq_e9m3_ai_turret_loop_e);
			ai_place_with_shards(sq_e9m3_ai_turret_loop_f);
		end
	
//	thread(f_e9m3_garbage_collect_timer(3));
	
	// -- wait, then reinforce
	sleep_until	(		(ai_living_count(ai_ff_all) <= 11)
							or	(volume_test_players(tv_aerie_loop) == true), 1
							);
	if	(volume_test_players(tv_aerie_loop) == true)then
		volume_test_players(tv_aerie_loop);
	elseif(ai_living_count(sq_e9m3_aerie_bishops_loop_3o) >= 1)then
		ai_place_with_shards(sq_e9m3_aerie_pawns_loop_2);
	else
		f_e9m3_loop_random_bishop_and_turret_pair(4, 6);
		sleep(30 * 2);
		f_e9m3_loop_random_bishop_and_turret_pair(4, 6);
	end
	
//	thread(f_e9m3_garbage_collect_timer(3));
	
	// -- central reinf
	sleep_until	(		(ai_living_count(ai_ff_all) <= 9)
							or	(volume_test_players(tv_aerie_loop) == true), 1
							);
	if(ai_living_count(ai_ff_all) <= 9)then
		ai_place_with_shards(sq_e9m3_aerie_pawns_loop_3, 2);
	end
	
//	thread(f_e9m3_garbage_collect_timer(6));
							
	// -- 10 o clock sequence
	sleep_until	(		(ai_living_count(ai_ff_all) <= 8)
							or	(volume_test_players(tv_aerie_loop) == true), 1
							);
	if	(volume_test_players(tv_aerie_loop) == true) then
		volume_test_players(tv_aerie_loop);
	else
		ai_place_in_limbo(sq_e9m3_knights_5, 1);
		if (volume_test_players(tv_back_of_loop) == false)then
			ai_place(sq_e9m3_aerie_bishops_loop_7o.a);
			ai_place(sq_e9m3_aerie_bishops_loop_7o.b);
			ai_place(sq_e9m3_aerie_bishops_loop_7o.c);
			sleep(30 * 2);
			ai_place_with_shards(sq_e9m3_ai_turret_loop_a);
			ai_place_with_shards(sq_e9m3_ai_turret_loop_b);
			ai_place_with_shards(sq_e9m3_aerie_pawns_loop_1);
		end
	end
	
//	thread(f_e9m3_garbage_collect_timer(6));
	
	// -- wait, then reinforce
	sleep_until	(		(ai_living_count(ai_ff_all) <= 10)
							or	(volume_test_players(tv_aerie_loop) == true), 1
							);
	if	(volume_test_players(tv_aerie_loop) == true) then
		volume_test_players(tv_aerie_loop);
	elseif(ai_living_count(sq_e9m3_aerie_bishops_loop_7o) >= 1)then
		ai_place_with_shards(sq_e9m3_aerie_pawns_loop_3);
	else
		f_e9m3_loop_random_bishop_and_turret_pair(1, 3);
		sleep(30 * 2);
		f_e9m3_loop_random_bishop_and_turret_pair(1, 3);
	end

//	thread(f_e9m3_garbage_collect_timer(3));

	sleep_until(		(ai_living_count(ai_ff_all) <= 8)
							or	(volume_test_players(tv_aerie_loop) == true), 1
							);
	sleep(30 * 2);
	true;
	
end

script static boolean f_e9m3_loop_sequence_part_2
	s_e9m3_scenario = 66;
	if(ai_living_count(ai_ff_all) <= 15)then
		ai_place(sq_e9m3_aerie_fusilier_1);
		ai_place(sq_e9m3_aerie_fusilier_2);
	end
	if(ai_living_count(ai_ff_all) <= 15)then
		ai_place(sq_e9m3_aerie_bishops_loop_10o.c);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_c) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_c);
		end
	end
	sleep_until(ai_living_count(ai_ff_all) <= 16);
	ai_place_in_limbo(sq_e9m3_knights_4, 1);
	
//	thread(f_e9m3_garbage_collect_timer(3));
	
	sleep_until(ai_living_count(ai_ff_all) <= 10);
	local short s_count = 0;
	repeat
		if(volume_test_players(tv_back_of_loop) == false)then
			f_e9m3_loop_random_bishop_and_turret_pair(1,6);
			sleep(30 * 2);
		end
		s_count = s_count + 1;
	until	(		(volume_test_players(tv_back_of_loop) == true)
				or	(s_count >= 4), 1
				);
//	thread(f_e9m3_garbage_collect_timer(3));
	sleep(30);
	ai_place_in_limbo(sq_e9m3_knights_3, 1);
	ai_place_in_limbo(sq_e9m3_knights_5, 1);
	ai_place(sq_e9m3_aerie_bishops_1.2);
	true;
end

script static void f_e9m3_loop_random_bishop_and_turret_pair(short s_min, short s_max)
	local short s_num = random_range(s_min, s_max);
	
	if(s_num == 1)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.a);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_a) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_a);
		end
	elseif(s_num == 2)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.b);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_b) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_b);
		end
	elseif(s_num == 3)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.c);
		sleep(30 * 2);
	if (ai_living_count(sq_e9m3_ai_turret_loop_c) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_c);
		end
	elseif(s_num == 4)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.d);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_d) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_d);
		end
	elseif(s_num == 5)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.e);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_e) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_e);
		end
	elseif(s_num == 6)then
		ai_place(sq_e9m3_aerie_bishops_loop_back.f);
		sleep(30 * 2);
		if (ai_living_count(sq_e9m3_ai_turret_loop_f) <= 0) then
			ai_place_with_shards(sq_e9m3_ai_turret_loop_f);
		end
	else
		print("");
	end
end

script static boolean f_e9m3_knight_sequence
	s_e9m3_scenario = 68;
	if	(		(ai_living_count(ai_ff_all) <= 10)
			and	(volume_test_players(tv_cave_1) == false)
			and (volume_test_players(tv_cave_2) == false)
			)then
			
			ai_place(sq_e9m3_aerie_ghostriders_2);
			thread(f_e9m3_ghosts_warning_vo());
	end
	ai_allow_resurrect(sq_e9m3_knights_1, true);
	ai_allow_resurrect(sq_e9m3_knights_2, true);
	local short knight_spawn_instances = 0;
	repeat
		
		if(		(random_range(1, 3) >= 2)
			and	(ai_living_count(sg_e9m3_bishops) <= 2)
			) then
			ai_place_with_birth (sq_e9m3_aerie_bishops_1);
		end
/*
		if(		(knight_spawn_instances == 3)	
			and	(volume_test_players(tv_aerie_loop) == false)
			)	then
			ai_place(sq_e9m3_aerie_fusilier_1);
			ai_place(sq_e9m3_aerie_fusilier_2);
		end
*/	
		if(		(knight_spawn_instances == 2)	
			and	(ai_living_count(sq_e9m3_ai_turret_6) <= 0)
			)	then
			ai_place_with_shards(sq_e9m3_ai_turret_6);
//			thread(f_e9m3_garbage_collect_timer(6));
		end
		
		if	(knight_spawn_instances == 3)	then
			ai_place(sq_e9m3_aerie_bishops_1.2);
		end
		
		sleep_until(ai_living_count(sg_e9m3_knights) <= 1);
		
		if(ai_living_count(sq_e9m3_knights_1) <= 0)then
			ai_place_in_limbo(sq_e9m3_knights_1, 1);
			knight_spawn_instances = knight_spawn_instances + 1;
		elseif(ai_living_count(sq_e9m3_knights_2) <= 0) then
			ai_place_in_limbo(sq_e9m3_knights_2, 1);
			knight_spawn_instances = knight_spawn_instances + 1;
		end
		
	until(knight_spawn_instances == 5, 1);
	
//	thread(f_e9m3_garbage_collect_timer(3));
	
	sleep_until(ai_living_count(sg_e9m3_knights) <= 1);
	
	ai_place_in_limbo(sq_e9m3_knight_commanders.2);
	ai_place_in_limbo(sq_e9m3_knights_1, 1);
	ai_place_in_limbo(sq_e9m3_knights_2, 1);
	ai_place_with_birth (sq_e9m3_aerie_bishops_1);
	b_end_player_goal = true;																																					//advance objectives (to final no more waves)	
	sleep(30 * 2);
	vo_e9m3_almost_there();
		// Miller : You're doing it, Crimson. You've almost got it.
	true;
end
script static void f_e9m3_ghosts_warning_vo
	sleep(30 * 3);
	sleep_until(e9m3_narrative_is_on == false);
	sleep(10);
	vo_e9m3_complications_ghosts();
				// Miller : Keep an eye out for those Ghosts.
end
script static void f_e9m3_aerie_spawn_init_pawns
	sleep_until(volume_test_players(tv_cave_1) == true);
	thread(f_e9m3_place_scorpions_in_garrison_or_gateyard());
	ai_place(sq_e9m3_aerie_pawns_1);
end

//=======ENDING E9 M3==============================

script static void f_e9m3_end_mission
	sleep_until  (LevelEventStatus("e9m3_all_dead"), 1);
	thread(f_e9m3_music_grand_finale_stop());
	sleep(15);
	thread(f_e9m3_music_mop_up_start());
	vo_e9m3_all_clear();
	sleep(15);
	vo_e9m3_terminal_there();
			// Miller : Roland? Can you verify this is the terminal we're looking for?
			// Roland : Sure is.
	sleep(10);
	vo_glo15_miller_waypoint_01();
			// Miller : Setting a waypoint.
	thread(f_e9m3_objective_text_display (generic_objective_b));
			// INVESTIGATE
	b_wait_for_narrative_hud = false;
	f_terminal_run(dm_e9m3_panel_3, dc_e9m3_switch_3, true);																					// waits until terminal is accessed to return
	
	vo_e9m3_end_mission();
			// Roland : Got it. Last bounce Halsey made is to the area the Spartans are calling Lockup.
			// Miller : So we get there and we find her?	
			// Roland : That'd be real neat, yeah.	
			// Dalton, I'm sending you coordinates where I need Crimson delivered. Crimson... get ready. We're in the home stretch.
	fade_out (0,0,0,60);
	thread(f_e9m3_music_mop_up_stop());
	player_control_fade_out_all_input (.1);
	b_end_player_goal = true;																																					//advance objectives to all done
	thread(f_e9m3_music_stop());
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end


//==== objectives handling

script static void f_e9m3_objectives_script
	// players spawn in----------------------------------
	sleep(30 * 1);
	thread(f_e9m3_music_first_battle_start());
	thread(vo_e9m3_science_bases());
			// Miller : Doctor Halsey routed her transmissions through a facility part way up Apex. Only way through is up the middle, Crimson. Have at it.
	sleep(30 * 3);
	
	f_e9m3_tank_objective_til_players_get_one();
								//Secure a Scorpion
	thread(f_e9m3_objective("e9m3_secure_forward_base"));
								//Secure forward base
	sleep(30);
	b_wait_for_narrative_hud = false;

	// landing reached------------------------------------
	sleep_until	(s_e9m3_scenario >= 5, 15);																														// 1-4-2013
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	f_e9m3_watchers_global_vo();
			// Miller: Watchers!
	sleep(30);
	thread(f_e9m3_objective(generic_objective_a, false));																							// new objective/tank sub-objective loop
			//Clear the Area
	// landing combat complete----------------------------
	sleep_until(f_e9m3_landing_encounter_is_complete() == true, 10);
	
	thread(f_e9m3_music_first_battle_stop());
	
	sleep(30 * 1);
	
	thread(f_e9m3_music_first_barrier_start());
	
	thread(f_e9_m3_thread_the_rest());																																// 1-4-2013
	
	vo_e9m3_fallback();
			// Miller : Dalton, Crimson could use a Scorpion refresh
			// Dalton : Got it, Miller. Dropping them in now.
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	ai_place(sq_e9m3_pelican_2);																																			// spawn pelican to deliver backup scorpion
	vo_e9m3_area_secure();
			// Roland : Can't turn the shields off, but I can weaken them enough that Crimson should be able to bring 'em down.
			// Miller : Lighting up the shield controls for you.
	b_end_player_goal = true;																																					//advance objectives 
	thread(f_e9m3_objective_text_display (e9m3_weaken_barrier, false));																// just objective text, no loop or tank sub-objective
			//Weaken Barrier
	sleep(30 * 1.5);
	b_wait_for_narrative_hud = false;
	f_terminal_run(dm_e9m3_panel_1, dc_e9m3_switch_1, false);																					// waits until terminal is accessed to return
	sleep(20);
	f_add_crate_folder(e9m3_vehicles_2);
	vo_e9m3_button_pressed();
			// Miller: The shields should be weak enough to bring down now.
	
	// switch flipped------------------------------------
	sleep(2);
	thread(f_e9m3_make_barrier_vulnerable(e9m3_barrier_1));
	f_e9m3_tank_objective_til_players_get_one();	
			//	Secure Scorpion
	thread(f_e9m3_objective(e9m3_destroy_barrier, false));																						// new objective/tank sub-objective loop
			//	Destroy Barrier
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
	sleep_until(object_get_shield(e9m3_barrier_1) <= 0);
	b_wait_for_narrative_hud = true;
	
	vo_e9m3_shield_down();
			// Miller : Nicely done. Roll forward. Marking the next target for you now.
	
	// Barrier destroyed---------------------------------
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	sleep(30 * 1);
	thread(f_e9m3_objective(e9m3_advance));																														// new objective/tank sub-objective loop
			//	Advance Scorpion
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
	thread(spops_blip_flag( fl_garrison, true, "navpoint_goto"));
	
	thread(f_e9m3_music_first_barrier_stop());
	
	// Terrace-------------------------------------------
	f_e9m3_begin_terrace();																																						// returns after setting s_e9m3_scenario = 20
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	thread(f_e9m3_cant_proceed());
	sleep(30 * 1.5);
	thread(f_e9m3_music_ambush_stop());
	vo_e9m3_shield_control();
			// Miller : Hold on. I'm looking for a way to bring that shield down.
			// Miller : I'm not finding anything on your side. But there does appear to be a side path. Let me mark that for you.
	thread(f_e9m3_objective_text_display (e9m3_advance_on_foot));																			// just objective text, no loop or tank sub-objective
								// Advance on Foot
	thread(f_e9m3_music_on_foot_start());
	// Switchback-------------------------------------------
	NotifyLevel("e9m3_switchback");																																		// will need this here if bonobo objectives condensed into script
	f_e9m3_players_arrived_at_flag(2, 8);
	f_create_new_spawn_folder(93);
	vo_glo15_miller_few_more_04();
			// Miller : Neutralize all targets.
	thread(f_e9m3_objective_text_display (generic_objective_a, false));
								// clear the area
		
	sleep_until	(
								(volume_test_players(tv_gateyard_init) == true) or
								(ai_living_count(sg_e9m3_switchback) <= 0), 1
							);
							
	// Gateyard------------------------------------------
	s_e9m3_scenario = 30;
	f_create_new_spawn_folder(94);
	thread(f_e9m3_tankculler_pre_garrison());
	sleep(30);
	vo_e9m3_traveling_line_2();
			// Miller : Straight up that hill.
	thread(f_e9m3_objective_text_display (generic_objective_h, false));
							// Secure the Area
	sleep(30);
	f_e9m3_players_arrived_at_flag(3, 6);
		
	// Gateyard-Garrison Corridor------------------------
	f_create_new_spawn_folder(95);
	vo_e9m3_traveling_line_1();
			// Miller : Right there, Crimson, through the pass.
	sleep(30 * 2);
	thread(f_e9m3_objective_text_display (generic_objective_h, false));
							// Secure the Area
	f_e9m3_players_arrived_at_flag(4, 6);

	// Garrison------------------------------------------
	f_create_new_spawn_folder(96);
	sleep(30 * 2);
	vo_e9m3_secure_area();
			// Miller : Dalton, how big a space do you need cleared to bring Crimson a new ride?
			// Dalton : Passing you a waypoint now. Secure that space and I'm good.
			// Miller : Get to it, Spartans. Give Dalton's people room to work.
	sleep(30 * 2);
	thread(f_e9m3_objective_text_display (generic_objective_a, false));																// just objective text, no loop or tank sub-objective
								//Clear the Area
	sleep_until	(LevelEventStatus("e9m3_garrison_secured"), 1);			
	thread(f_e9m3_music_mini_boss_stop());
	sleep(30 * 2);
	thread(f_e9m3_music_roll_onward_start());
	vo_e9m3_area_secured();
			// Miller : All clear, Dalton.
			// Dalton : So I see. Scorpions en route.
	thread(f_e9m3_place_scorpions_in_garrison_or_gateyard());																					// place 2 new tanks in garrison
	sleep(30);
	vo_e9m3_additional_shield_controls();
		// Miller: I’ll mark the shield control system for you, Crimson. Roland, can you work your magic?
		// Roland: You know it.
	thread(f_e9m3_objective_text_display (e9m3_weaken_barrier, false));																// just objective text, no loop or tank sub-objective
								//Weaken Barrier
	sleep(30 * 1.5);
	b_wait_for_narrative_hud = false;
	f_terminal_run(dm_e9m3_panel_2, dc_e9m3_switch_2, false);																					// waits until terminal is accessed to return
	vo_e9m3_additional_shield_controls_activated();
		// Roland : Good to go, Spartans.
		// Miller : Take out the shield, Crimson.

	
	thread(f_e9m3_initialize_aerie());
	thread(f_e9m3_tank_respawner_2());
	// switch flipped------------------------------------
	sleep(2);
	thread(f_e9m3_make_barrier_vulnerable(e9m3_barrier_5));
	thread(f_e9m3_make_barrier_vulnerable(e9m3_barrier_2));
	object_create_anew(e9m3_barrier_aerie);
	sleep(1);
	thread(f_e9m3_aerie_barrier_manager());
		
	vo_glo15_miller_waypoint_02();
			// Miller : Marking your target now.
		
	f_e9m3_tank_objective_til_players_get_one();	
								//Secure Scorpion
	thread(f_e9m3_objective(e9m3_destroy_barrier));																										// new objective/tank sub-objective loop
								//Destroy Barrier
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
	sleep_until(object_get_shield(e9m3_barrier_5) <= 0);
	b_wait_for_narrative_hud = true;
	sleep(30);
	vo_e9m3_into_caves();
			// Miller : Into the caves, Crimson. Let's root out anybody hiding inside.
	
	// Barrier destroyed---------------------------------
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	sleep(30 * 2);
	thread(f_e9m3_objective(e9m3_advance));																														// new objective/tank sub-objective loop
								//Advance Scorpion
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
	
	// Caves---------------------------------------------
	f_e9m3_players_arrived_at_flag(9, 6);
	thread(f_e9m3_unload_excess());
	f_e9m3_players_arrived_at_flag(10, 10);
	f_e9m3_objective_complete();																																			// kills objective/tank sub-objective loop
	f_e9m3_tankculler_garrison();
	// Destroy gates 3 and 4-----------------------------
	f_e9m3_aerie_barriers();
	sleep(20);
	thread(vo_e9m3_1sttrace());
			// Miller : The location where Halsey routed her communications is up ahead.
	thread(f_e9m3_music_roll_onward_stop());
	sleep(30);
	// Aerie---------------------------------------------
	thread(f_e9m3_sequence_aerie());
end

script static boolean f_e9m3_players_arrived_at_flag(short flagIndex, short distance)

	flag_0 = firefight_mode_get_objective_name_at(flagIndex);

	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	if objects_distance_to_object ((player0), flag_0) == -1 then
		print ("there is no object set to check the distance");
	end
	
	local short objectDistance = 5;
	if (distance > 0) then
		objectDistance = distance;
	end
	
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ) or
		(b_end_player_goal == true), 1);	
	
	f_unblip_object_cui (flag_0);
	
	true;
end

script static void f_e9m3_enable_shields
	object_create(e9m3_barrier_2);
	object_cannot_take_damage(e9m3_barrier_2);
	object_set_function_variable(e9m3_barrier_2, shield_alpha, 1, 0);
	object_set_function_variable(e9m3_barrier_2, shield_alpha, 0, 1);

	object_cannot_take_damage(e9m3_barrier_2);
	object_cannot_take_damage(e9m3_barrier_3);
	object_cannot_take_damage(e9m3_barrier_4);
	object_cannot_take_damage(e9m3_barrier_5);
	object_cannot_take_damage(sc_blocker_energy_door_01);
	object_cannot_take_damage(sc_blocker_02);
	object_cannot_take_damage(sc_blocker_06);
	object_destroy(e9m3_barrier_aerie);
end

script static void f_e9m3_objective(string_id str_objective, boolean b_update)											// 12-18-12 wrapper - supports new functionality
	sys_e9m3_objective(str_objective, b_update);
end

script static void f_e9m3_objective(string_id str_objective)																				// 12-18-12 wrapper - most older script will call this
	sys_e9m3_objective(str_objective, true);
end

script static void sys_e9m3_objective(string_id str_objective, boolean b_update)										// tracks objective text, and handles tank sub objective 
	// 12-18-12 addendum: late fix to allow tank sub-bjective loop without updating pause menu objective
	thread(f_e9m3_objective_text_display (str_objective, b_update));																	// 12-18-12 addendum
	
	sleep_until((f_e9m3_players_need_scorpion() == true) or (b_objective_complete == true), 1);
	
	if(f_e9m3_players_need_scorpion() == true)then
//		print("--------------------================== NEED AT LEAST 1 PLAYER WITH A SCORPION ================----------------");
		sleep_until(f_e9m3_scorpion_sub_objective() == true);
	end
	
	if(b_objective_complete == true)then
		sleep(3);
		b_objective_complete = false;																																		// let calling function know it's safe to thread new objective text
		kill_thread(GetCurrentThreadId());
	else																																															// in this case, a tank was entered
		thread(f_e9m3_objective(str_objective));																												// restart this loop
	end
end

script static void f_e9m3_objective_text_display(string_id str_objective, boolean b_update)					// 12-18-12 wrapper - supports new functionality
	sys_e9m3_objective_text_display(str_objective, b_update);
end

script static void f_e9m3_objective_text_display(string_id str_objective)														// 12-18-12 wrapper - most older script will call this
	sys_e9m3_objective_text_display(str_objective, true);
end

script static void sys_e9m3_objective_text_display(string_id str_objective, boolean b_update)				// decides whether or not pause menu objective needs to update
	// 12-18-12 addendum: late fix to allow tank sub-bjective loop without updating pause menu objective
	if(b_update == false)then																																					// 12-18-12 addendum
		cui_hud_set_new_objective (str_objective);																											// 12-18-12 addendum
		str_objective_text = str_objective;																															// 12-18-12 addendum
		
	elseif(		(str_objective == "e9m3_get_scorpion")
		or		(str_objective == str_objective_text)
		) then
		cui_hud_set_new_objective (str_objective);																											// update visor objective, but not pause menu
	else
		thread(f_new_objective (str_objective));																												// update visor and pause menu objectives
		str_objective_text = str_objective;
	end
end

script static boolean f_e9m3_scorpion_sub_objective()
	b_wait_for_narrative_hud = true;																																	// hide blips
	cui_hud_set_new_objective (e9m3_get_scorpion);																										// update hud objective but not pause menu
	// to-do
	// change to be player-specific by cannibalizing tom's script
	if(object_active_for_script(e9m3_scorpion_1))then
		thread(f_e9m3_scorpion_blipper(e9m3_scorpion_1));
	end
	if(object_active_for_script(e9m3_scorpion_2))then
		thread(f_e9m3_scorpion_blipper(e9m3_scorpion_2));
	end
	if(object_active_for_script(e9m3_scorpion_3))then
		thread(f_e9m3_scorpion_blipper(e9m3_scorpion_3));
	end
	if(object_active_for_script(e9m3_scorpion_4))then
		thread(f_e9m3_scorpion_blipper(e9m3_scorpion_4));	
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)))then
		thread(f_e9m3_scorpion_blipper(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)));
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)))then
		thread(f_e9m3_scorpion_blipper(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)));
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)))then
		thread(f_e9m3_scorpion_blipper(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)));
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)))	then
		thread(f_e9m3_scorpion_blipper(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)));
	end
	sleep_until(
								(f_e9m3_players_need_scorpion() == false)
						or	(b_objective_complete == true), 1
							)	;
	if(
				(	f_e9m3_players_need_scorpion() == false)
		or	(	b_objective_complete == true)
		)	 then
		b_wait_for_narrative_hud = false;																						// restore blips
		true;																																				// go back to f_e9m3_objective script
	else
		thread(f_e9m3_scorpion_sub_objective());																		// restart scorpion sub objective
	end
end

script static void f_e9m3_scorpion_blipper(vehicle veh_scorpion)

	if(object_active_for_script (veh_scorpion))then															
		thread(f_e9m3_scorpion_blip_relay (veh_scorpion, "navpoint_driver"));
		sleep_until	(		(f_e9m3_players_need_scorpion() == false) 
								or	(b_objective_complete == true), 1
								);
		thread(f_e9m3_scorpion_blip_relay (veh_scorpion, ""));
	end
end

script static void f_e9m3_scorpion_blip_relay(object obj, string_id type)				// so can thread
	navpoint_track_object_named(obj, type);
end

script static boolean f_e9m3_players_need_scorpion()
	sleep(1);
	if(b_players_are_alive())then
		/*
		if (	
			(		f_e9m3_player_in_vehicle_that_exists(e9m3_scorpion_1) 
			or	f_e9m3_player_in_vehicle_that_exists(e9m3_scorpion_2) 
			or	f_e9m3_player_in_vehicle_that_exists(e9m3_scorpion_3) 
			or	f_e9m3_player_in_vehicle_that_exists(e9m3_scorpion_4) 
			or	f_e9m3_player_in_vehicle_that_exists(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)) 
			or	f_e9m3_player_in_vehicle_that_exists(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)) 
			or	f_e9m3_player_in_vehicle_that_exists(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)) 
			or	f_e9m3_player_in_vehicle_that_exists(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)) 
			) == false																																										// if any of the above is true, this won't pass
		)	then
				*/
		if(	(		unit_in_vehicle_type(player_get(0), 19)
				or	unit_in_vehicle_type(player_get(1), 19)
				or	unit_in_vehicle_type(player_get(2), 19)
				or	unit_in_vehicle_type(player_get(3), 19)
				) == false
			)then					
//			print("---------------================== PLAYER NEEDS TANK =========================--------------");
			true;
		else
			false;
		end
	end
end

script static void f_e9m3_nohurtfriendlyvehicles
  print ("player vehicles are immune");
  repeat
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(0)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(1)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(2)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(3)), true);
  until (b_game_ended == true, 30);            
end

//f_e9m3_player_in_vehicle_that_exists (e9m3_scorpion_1)
// object_active_for_script (e9m3_scorpion_1)

script static boolean f_e9m3_player_in_vehicle_that_exists (vehicle v_tank)
	//inspect((object_active_for_script(v_tank) > 0)	and player_in_vehicle(v_tank));
	object_active_for_script(v_tank) and player_in_vehicle(v_tank);
end

script static void f_e9m3_tank_objective_til_players_get_one
	if (f_e9m3_players_need_scorpion() == true) then
		thread(f_e9m3_objective_text_display (e9m3_get_scorpion));
		sleep_until(f_e9m3_players_need_scorpion() == false);
	end
end

script static boolean f_e9m3_objective_complete()
	b_objective_complete = true;																																			// end objective/tank sub-objective loop
	sleep(2);
	sleep_until(b_objective_complete == false, 1);																										// confirm thread ended	
	true;
end

//====ancillary

script static void f_e9m3_make_barrier_vulnerable(object barrier)
	object_can_take_damage(barrier);
	thread(f_e9m3_barrier_color_manager(barrier));
	local boolean b_vo = false;
	repeat
		sleep_until(object_get_shield(barrier) < 1.0, 1);
		if(object_get_shield(barrier) > .8)then
			object_set_shield(barrier, 1.0);
		end
	until(object_get_shield(barrier) <= 0.8, 1);
	
	sleep_until(object_get_shield(barrier) <= 0.05, 1);
	
	thread(f_e9m3_stinger_barrier_destroyed());
	
	object_set_function_variable(barrier, shield_alpha, 1, 1);
	sleep(30);
	object_destroy(barrier);
end

script static void f_e9m3_barrier_color_manager(object barrier)
	repeat
		object_set_function_variable(barrier, shield_color, (1 -(object_get_shield(barrier))), .5);
		sleep(3);
	until(object_get_shield(barrier) <= 0, 3);
end

script static real f_e9m3_aerie_barriers_get_lowest_shield_value
	local real num_barrier_3 = object_get_shield(e9m3_barrier_3);
	local real num_barrier_4 = object_get_shield(e9m3_barrier_4);
	local real num_barrier_a = object_get_shield(e9m3_barrier_aerie);
	
	min(num_barrier_3, num_barrier_4, num_barrier_a);
end

script static void f_e9m3_aerie_barriers_set_shields_to_uniform_value(real num_val)
	object_set_shield(e9m3_barrier_3, num_val);
	object_set_shield(e9m3_barrier_4, num_val);
	object_set_shield(e9m3_barrier_aerie, num_val);
end

script static void f_e9m3_aerie_barrier_manager
	object_can_take_damage(e9m3_barrier_3);
	object_can_take_damage(e9m3_barrier_4);
	object_can_take_damage(e9m3_barrier_aerie);
		
	sleep_until(f_e9m3_aerie_barriers_get_lowest_shield_value() < 1.0, 1);
	repeat
		if(f_e9m3_aerie_barriers_get_lowest_shield_value() > .8)then
			f_e9m3_aerie_barriers_set_shields_to_uniform_value(1.0);
		end
	until(f_e9m3_aerie_barriers_get_lowest_shield_value() <= 0.8, 1);
	repeat
		object_set_function_variable(e9m3_barrier_3, shield_color, (1 - f_e9m3_aerie_barriers_get_lowest_shield_value()), .5);
		object_set_function_variable(e9m3_barrier_4, shield_color, (1 - f_e9m3_aerie_barriers_get_lowest_shield_value()), .5);
		object_set_function_variable(e9m3_barrier_aerie, shield_color, (1 - f_e9m3_aerie_barriers_get_lowest_shield_value()), .5);
		f_e9m3_aerie_barriers_set_shields_to_uniform_value(f_e9m3_aerie_barriers_get_lowest_shield_value());
	until	(		(f_e9m3_aerie_barriers_get_lowest_shield_value() <= 0.05)
				or	(f_e9m3_aerie_barriers_get_lowest_shield_value() == 1.00)
				, 4);
	if	(f_e9m3_aerie_barriers_get_lowest_shield_value() <= 0.05)	then
		thread(f_e9m3_stinger_barrier_destroyed());
		object_set_function_variable(e9m3_barrier_3, shield_alpha, 1, 1);
		object_set_function_variable(e9m3_barrier_4, shield_alpha, 1, 1);
		object_set_function_variable(e9m3_barrier_aerie, shield_alpha, 1, 1);
		sleep(30);
		object_destroy(e9m3_barrier_3);
		object_destroy(e9m3_barrier_4);
		object_destroy(e9m3_barrier_aerie);
	else
		f_e9m3_aerie_barrier_manager();																																	//restart
	end
end

// LOAD PAYLOAD: load 1 or 2 vehicles onto a Phantom
script static void f_e9_m3_load_playload (ai dropship, ai squad1)
	ai_place_in_limbo  (squad1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_lc", ai_vehicle_get_from_spawn_point(squad1));
	ai_exit_limbo (squad1);
end

script static void f_e9_m3_load_playload (ai dropship, ai squad1, ai squad2)
	ai_place_in_limbo  (squad1);
	ai_place_in_limbo  (squad2);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc01", ai_vehicle_get_from_spawn_point(squad1));
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc02", ai_vehicle_get_from_spawn_point(squad2));
	ai_exit_limbo (squad1);
	ai_exit_limbo (squad2);
end

script static vehicle f_load_pelican	(ai pelican)

	local vehicle veh_veh = none;
	
	if(		(game_coop_player_count() >= 2)
		or	(ai_living_count(sg_marines) >= 1) 																													// multiplayer || player has marine ai buddy
		) then
		print("spawning empty tank");
		if (object_active_for_script (e9m3_scorpion_3) == false) then
			print("choplifting scorpion 3");
			f_load_pelican_with_unmanned_tank(pelican, e9m3_scorpion_3);
			print("returning 		e9m3_scorpion_3;");
			veh_veh = vehicle(e9m3_scorpion_3);
		elseif (object_active_for_script (e9m3_scorpion_4) == false) then
			print("choplifting scorpion 4");
			f_load_pelican_with_unmanned_tank(pelican, e9m3_scorpion_4);
			print("returning 		e9m3_scorpion_4;");
			veh_veh = vehicle(e9m3_scorpion_4);
		elseif (object_active_for_script (e9m3_scorpion_1) == false) then
			print("choplifting scorpion 1");
			f_load_pelican_with_unmanned_tank(pelican, e9m3_scorpion_1);
			print("returning 		e9m3_scorpion_1;");
			veh_veh = vehicle(e9m3_scorpion_1);
		elseif (object_active_for_script (e9m3_scorpion_2) == false) then
			print("choplifting scorpion 2");
			f_load_pelican_with_unmanned_tank(pelican, e9m3_scorpion_2);
			print("returning 		e9m3_scorpion_2;");
			veh_veh = vehicle(e9m3_scorpion_2);
		end
	else																																															// single player && no marines
		print("spawning tank and marine");
		if (	ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1) == none	) then
			print("spawning tank and marine SQUAD 1");
			ai_place_in_limbo  (sq_e9m3_scorpion_1.1);
			sleep_until (ai_living_count (pelican) > 0);
			vehicle_load_magic(ai_vehicle_get_from_squad(pelican, 0), "pelican_lc", ai_vehicle_get_from_squad(sq_e9m3_scorpion_1, 0));
			ai_exit_limbo (sq_e9m3_scorpion_1);
			print("returning 		ai_vehicle_get_from_squad(sq_e9m3_scorpion_1, 0);");
			veh_veh = ai_vehicle_get_from_squad(sq_e9m3_scorpion_1, 0);
		elseif (	ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1) == none	) then
			print("spawning tank and marine SQUAD 2");
			ai_place_in_limbo  (sq_e9m3_scorpion_2.1);
			sleep_until (ai_living_count (pelican) > 0);
			vehicle_load_magic(ai_vehicle_get_from_squad(pelican, 0), "pelican_lc", ai_vehicle_get_from_squad(sq_e9m3_scorpion_2, 0));
			ai_exit_limbo (sq_e9m3_scorpion_2);
			print("returning 		ai_vehicle_get_from_squad(sq_e9m3_scorpion_2, 0);");
			veh_veh = ai_vehicle_get_from_squad(sq_e9m3_scorpion_2, 0);
		elseif (	ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1) == none	) then
			print("spawning tank and marine SQUAD 3");
			ai_place_in_limbo  (sq_e9m3_scorpion_3.1);
			sleep_until (ai_living_count (pelican) > 0);
			vehicle_load_magic(ai_vehicle_get_from_squad(pelican, 0), "pelican_lc", ai_vehicle_get_from_squad(sq_e9m3_scorpion_3, 0));
			ai_exit_limbo (sq_e9m3_scorpion_3);
			print("returning 		ai_vehicle_get_from_squad(sq_e9m3_scorpion_3, 0);");
			veh_veh = ai_vehicle_get_from_squad(sq_e9m3_scorpion_3, 0);
		end
	end
	print("OOPS");
	veh_veh;
end



script static boolean f_load_pelican_with_unmanned_tank (ai pelican, object_name tank)
	print("making tank");
	object_create_anew(tank);
	inspect(object_active_for_script(tank));
	sleep_until (ai_living_count (pelican) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(pelican, 0), "pelican_lc", tank);
	true;
end

//-- shard spawning + respawning - calls shard spawning for a group, then sets conditions to re-enable shard spawning on that same group
// 			pawns 											== squad to shard spawn 																				(required)
//			population 									== number of pawns to spawn																			(blank == default == # specified in squad definition)
//			squad_population_theshold 	== wait until ai_living_count is <= before re-shard spawning		(blank == default == 20);
//			squad_group									== squad_group to evaluate squad_population_threshold against. 	(blank == default == use 'pawns' group.)
//			population_cap							== wait until total ai is <= before initiating re-shardspawn  	(blank == default == 20)
//			number_of_respawns					== number of times to repeat the respawn sequence 							(blank == default == only once)

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold, ai squad_group, short population_cap, short number_of_respawns)
	if(squad_group == none)then
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, pawns, population_cap, number_of_respawns));
	else
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, squad_group, population_cap, number_of_respawns));
	end
end

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold, ai squad_group, short population_cap)
	if(squad_group == none)then
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, pawns, population_cap, 1));
	else
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, squad_group, population_cap, 1));
	end
end

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold, ai squad_group)
	if(squad_group == none)then
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, pawns, 20, 1));
	else
		thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, squad_group, 20, 1));
	end
end

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold)
	thread(sys_shard_spawn_and_thread_respawner(pawns, population, population_threshold, pawns, 20, 1));
end

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population)
	thread(sys_shard_spawn_and_thread_respawner(pawns, population, 20, pawns, 20, 1));
end

script static void f_shard_spawn_and_thread_respawner(ai pawns)
	thread(sys_shard_spawn_and_thread_respawner(pawns, 22, 20, pawns, 20, 1));
end

script static void sys_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold, ai squad_group, short population_cap, short number_of_respawns)
	if(population == 22)then
		ai_place_with_shards (pawns);
	else
		ai_place_with_shards (pawns, population);
	end
	sleep_until(f_am_i_alive_yet(pawns));
	thread(f_shard_respawner(pawns, population, population_threshold, squad_group, population_cap, number_of_respawns));
end

script static void f_shard_respawner(ai pawns, short population, short population_threshold, ai squad_group, short population_cap, short number_of_respawns)
	repeat
		sleep_until(ai_living_count(squad_group) <= population_threshold);
		sleep_until(ai_living_count(ai_ff_all) <= population_cap);
		if(population == 22)then
			ai_place_with_shards (pawns);
		else
			ai_place_with_shards (pawns, population);
		end
		sleep_until(f_am_i_alive_yet(pawns));
		number_of_respawns = number_of_respawns - 1;
	until(number_of_respawns == 0);
end

script static boolean f_am_i_alive_yet(ai me)
	sleep_until(ai_living_count(me) >= 1);
	true;
end

script static boolean f_am_i_dead_yet(ai me)
	sleep_until(ai_living_count(me) <= 0);
	true;
end


// -------------------------------- 

script static void f_e9m3_shoot_me(object target)
	obj_target = target;
	ai_object_set_targeting_bias( obj_target, 1); 
end
script command_script cs_e9m3_shoot_me
	thread(f_e9m3_marine_magnet(ai_current_actor));
end
script static void f_e9m3_marine_magnet(object target)
	ai_object_set_targeting_bias( obj_target, 1); 
end

script static void f_e9m3_dont_shoot_me()
	ai_object_set_targeting_bias( obj_target, 0);
end

script static void f_terminal_setup (device dm, device dc)
	//onLevelLoaded, set and hide interface
	sleep(30 * 5);
	device_set_position_track( dm, 'device:position', 0 );
	sleep(10);
	device_animate_position (dm, 1, 2, 1, 0, 0);								// big to little (1 == small)
	sleep(10);
	object_hide(dm, true);
end

script static boolean f_terminal_run (device dm, device dc, boolean b_blip)																					// assumes previous function was run
	object_hide(dm, false);
	sleep(2);
	device_animate_position (dm, 0, 2, 1, 0, 0);								// unfurl interface
	sleep_until(device_get_position(dm) <= .10);								// 0 = dm in full bloom, 1 = max shrinkage
	device_set_power(dc, 1);
	if(b_blip == true)then
		thread(f_blip_object_cui (dc, "navpoint_activate"));
	end

	sleep_until(device_get_position(dc) > 0, 1);								// switch flipped
	
	if(b_blip == true)then
		thread(f_blip_object_cui (dc, ""));
	end
	b_wait_for_narrative_hud = true;
	sleep(30);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm, 1 ); //AUDIO!
	device_animate_position (dm, 1, 2, 1, 0, 0);								// roll up interface
	device_set_power(dc, 0);
	object_destroy(dc);
	sleep_until(device_get_position(dm) >= .9, 1);
	object_hide (dm, true);
	true;
end
script static void f_e9m3_shield_switch(object control, unit player)
// script static void f_push_fore_switch (unit player)
	print ("pushing the switch");
	
	g_ics_player = player;
	if control == dc_e9m3_switch_1 then
		print ("play button 1 puppetshow");
		pup_play_show (pup_button1);
	elseif control == dc_e9m3_switch_2 then
		print ("play button 2 puppetshow");
		pup_play_show (pup_button2);
	end
end

script static void f_e9_m1_switch_activate (object control, unit player)
	g_ics_player = player;
	pup_play_show (pup_button3);
end

 script static void f_e9m3_dissolve_relay(device dm)
 	object_dissolve_from_marker(dm, phase_out, panel);
 end

script static void f_aircraft_scale_in(ai ai_actor, point_reference p_point)
	object_set_scale ( ai_vehicle_get (ai_actor), 0.01, 01 );
	sleep (2);
	ai_teleport(ai_actor, p_point);
	object_set_scale ( ai_vehicle_get ( ai_actor ), 1.0, 180 ); //Grow over time
end

script static void f_aircraft_scale_out(ai ai_actor)
	object_set_scale ( ai_vehicle_get ( ai_actor ), 0.01, 180 ); //Grow over time
	f_despawn_hack( ai_actor );
end

script static void f_despawn_hack(ai phantom)
	sleep(3);
//	print("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
//		print("----=-=-=-=-----phantom alive, trying to erase");
		ai_erase (ai_get_squad(phantom));
//		print("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		f_despawn_hack(phantom);
	else
//		print("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end
 
script static void f_e9m3_unload_excess
 	if(volume_test_players(tv_landing_1) == false) then
 		object_dispose(e9m3_cr_1);
 		object_dispose(e9m3_cr_2);
 		object_dispose(cr_e9m3_landing_terminal);
 	end	
 	if(volume_test_players(tv_garrison_view) == false) then
 		object_dispose(e9m3_cr_3);
 		object_dispose(e9m3_cr_4);
 		object_dispose(e9m3_cr_5);
 		object_dispose(e9m3_cr_7);
	end
	if(volume_test_players(tv_greg_cave) == false) then
		object_dispose(e9m3_cr_8);
		object_dispose(e9m3_cr_9);
		object_dispose(e9m3_cr_10);
		object_dispose(e9m3_cr_11);
	end
	garbage_collect_unsafe();
	sleep(10);
 	if(	(object_get_health(e9m3_ghost_1) >= 1.0)
		and	(vehicle_driver(e9m3_ghost_1) == none)
		and	(volume_test_object(tv_garrison_view, e9m3_ghost_1))
		and (volume_test_players(tv_garrison_view) == false)
		)then
		object_dispose(e9m3_ghost_1);
	end
 	if(	(object_get_health(e9m3_ghost_2) >= 1.0)
		and	(vehicle_driver(e9m3_ghost_2) == none)
		and	(volume_test_object(tv_greg_cave, e9m3_ghost_2))
		and (volume_test_players(tv_greg_cave) == false)
		)then
		object_dispose(e9m3_ghost_2);
	end
	if(		(volume_test_object(tv_terrace_valley, e9m3_plasma_1))
		and	(vehicle_driver(e9m3_plasma_1) == none)
		and (volume_test_players(tv_terrace_valley) == false)
		)then
		object_dispose(e9m3_plasma_1);
	end
	if (volume_test_players(tv_terrace_valley) == false)then
		object_dispose(e9m3_cr_15);
	end
	if(		(volume_test_object(tv_switchback_approach, e9m3_plasma_2))
		and	(vehicle_driver(e9m3_plasma_2) == none)
		and (volume_test_players(tv_switchback_approach) == false)
		)then
		object_dispose(e9m3_plasma_2);
	end
	if(		(volume_test_object(tv_gateyard_approach, e9m3_plasma_3))
		and	(vehicle_driver(e9m3_plasma_3) == none)
		and (volume_test_players(tv_gateyard_approach) == false)
		and (volume_test_players(tv_gateyard) == false)
		)then
		object_dispose(e9m3_plasma_3);
	end
	if(volume_test_players(tv_switchback_approach) == false)then
		object_dispose(e9m3_cr_12);
		object_dispose(e9m3_cr_13);
		object_dispose(e9m3_cr_14);
	end
	if(		(volume_test_object(tv_switchback_approach, ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.1)))
		and	(vehicle_driver(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.1)) == none)
		and (volume_test_players(tv_switchback_approach) == false)
		)then
		object_dispose(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.1));
	end
	if(		(volume_test_object(tv_switchback_approach, ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.2)))
		and	(vehicle_driver(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.2)) == none)
		and (volume_test_players(tv_switchback_approach) == false)
		)then
		object_dispose(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.2));
	end	
	if(		(volume_test_object(tv_gateyard, ai_vehicle_get_from_spawn_point (sq_e9m3_gateyard_plasmas.1)))
		and	(vehicle_driver(ai_vehicle_get_from_spawn_point (sq_e9m3_gateyard_plasmas.1)) == none)
		and (volume_test_players(tv_gateyard) == false)
		)then
		object_dispose(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.1));
	end	
	if(		(volume_test_object(tv_gateyard, ai_vehicle_get_from_spawn_point (sq_e9m3_gateyard_plasmas.2)))
		and	(vehicle_driver(ai_vehicle_get_from_spawn_point (sq_e9m3_gateyard_plasmas.2)) == none)
		and (volume_test_players(tv_gateyard) == false)
		)then
		object_dispose(ai_vehicle_get_from_spawn_point (sq_e9m3_plasma_gunners_1.2));
	end		
 	garbage_collect_unsafe();
 	
 	if	(vehicle_driver(e9m3_plasma_4) == none)	then
 		object_dispose(e9m3_plasma_4);
 	end
 	if	(vehicle_driver(e9m3_plasma_5) == none)	then
 		object_dispose(e9m3_plasma_5);
 	end
 	if	(vehicle_driver(e9m3_plasma_6) == none)	then
 		object_dispose(e9m3_plasma_6);
 	end
end
 
// example: f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0), true);
script static boolean f_test_door_gunner_is_alive(vehicle vh_phantom, boolean is_left)

	if(is_left == true)then
		(object_at_marker(vh_phantom,"turret_l") != NONE) and (vehicle_test_seat(vehicle(object_at_marker(vh_phantom,"turret_l")),"") );
	else
		(object_at_marker(vh_phantom,"turret_r") != NONE) and (vehicle_test_seat(vehicle(object_at_marker(vh_phantom,"turret_r")),"") );
	end
end


script static void f_e9m3_cap_apertures
object_create(dm_e8_m1_aperature1);
object_create(dm_e8_m1_aperature2);
object_create(dm_e8_m1_aperature3);
device_set_position(dm_e8_m1_aperature1, 1);
device_set_position(dm_e8_m1_aperature2, 1);
device_set_position(dm_e8_m1_aperature3, 1);
kill_volume_disable(kill_portal_1);
kill_volume_disable(kill_portal_2);
kill_volume_disable(kill_portal_3);
end

script static void f_e9m3_watchers_global_vo()
	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = true;
	vo_glo15_miller_watchers_01();
	e9m3_narrative_is_on = false;
end

script static void f_e9m3_marking_your_target_vo()
	sleep_until(e9m3_narrative_is_on == false);
	e9m3_narrative_is_on = true;
	vo_glo15_miller_waypoint_02();
			// Miller : Marking your target now.
	e9m3_narrative_is_on = false;
end

script static void f_e9m3_garbage_collect_timer(short s_secs)
	sleep(30 * s_secs);
	garbage_collect_unsafe();
end

script static boolean f_e9m3_garbage_recycle_volume(trigger_volume tv_trigger, long l_remainder, long l_seconds, real num_wait)
	add_recycling_volume(tv_trigger, l_remainder, l_seconds);
	sleep(30 * num_wait);
	true;
end

script static void f_e9m3_garbage_recycler_1
	repeat
		f_e9m3_garbage_recycle_volume(tv_tank_pre_garrison, 18, 1, 3.5);
	until(s_e9m3_scenario >= 20, 1);
end

script static void f_e9m3_garbage_recycler_2
	repeat
		f_e9m3_garbage_recycle_volume(tv_recyclotron, 18, 1, 3.5);
	until(s_e9m3_scenario >= 100, 1);
end

//====PHANTOM SCRIPTS 

script command_script cs_e9m3_phantom1
//	f_e9m3_kill_the_turrets(ai_vehicle_get(ai_current_actor));
	ai_set_blind (ai_current_squad, false);
	
	
	////////////////////////////////////////////////////
	//// 12-19-12:
	//thread(f_e9_m3_load_playload(sq_e9m3_phantom_1, sq_e9m3_ghost_1.1, sq_e9m3_ghost_2.1));
	ai_place_in_limbo  (sq_e9m3_init_anti_armor.1);
	ai_place_in_limbo  (sq_e9m3_init_anti_armor.2);
	
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), "phantom_pc_1", ai_actors(sq_e9m3_init_anti_armor.1));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), "phantom_pc_3", ai_actors(sq_e9m3_init_anti_armor.2));
	
	ai_exit_limbo (sq_e9m3_init_anti_armor.1);
	ai_exit_limbo (sq_e9m3_init_anti_armor.2);
	//////
	///////////////////////////////////////
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	sleep(30 * 3.5);
	cs_ignore_obstacles (TRUE);
	
	
	// ========= path in
	cs_fly_to_and_face(phantom1.p0, phantom1.face1);
	cs_fly_to_and_face(phantom1.p1, phantom1.face2);
	cs_fly_to_and_face(phantom1.p2, phantom1.face3);
	cs_fly_to_and_face(phantom1.p3, phantom1.face2);
	cs_fly_to_and_face(phantom1.p3, phantom1.face1);
	sleep(30);
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_pc_1");
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_pc_3");
//	vehicle_unload(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), "");
	sleep(30 * 5);

//	cs_enable_targeting(true);
	
	//start checking for chin gun loss
	//f_e9m3_chin_gun_is_gone(unit_get_vehicle(ai_current_actor));
	
	local boolean b_evac = false;


	// ======== skulk behind rocks
	if(		(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		)	then
		cs_fly_to_and_face(phantom1.p3, phantom1.face6);
		sleep_until(f_e9m3_chin_gun_is_gone(ai_vehicle_get(ai_current_actor)) == true, 1, 30 * 3);
	end
	
	if(		(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		) then
		cs_fly_to_and_face(phantom1.p4, phantom1.face6);
		sleep(30);
	end
	
	
	// ======== engage pelican	
	cs_face_object(true, ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1));
	
	if(		(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		)	then
		cs_shoot(true, sq_e9m3_pelican_1);
		cs_fly_to_and_face(phantom1.p5, phantom1.face6);
	end
	
	ai_object_set_targeting_bias(ai_current_actor, 1);
	
	if(		(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		)	then
		sleep_until(b_e9m3_dance_step == 1, 1);
		b_e9m3_dance_step = 2;
		cs_fly_to(phantom1.p6);																			//beside rock formation, above beach
	end
	
	
	
	thread(vo_e9m3_phantom_trouble());
			// Dalton : Miller, that Phantom's not leaving the area. Can Crimson convince it to bug out?
			// Miller : Could do that, sure. Crimson, take care of Dalton's problem Phantom?
	thread(f_e9m3_blip_first_phantom());
	
	if(		(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		) then	
		cs_fly_to(phantom1.p7);																			//beside rock formation, above path
		sleep_until	(		(b_e9m3_dance_step == 3)
								or	(s_e9m3_scenario < 4)
								or	(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
								);
	end
	
	if( 	(	f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)) == false )
		and	(s_e9m3_scenario < 4)
		) then
		cs_fly_to(phantom1.p8);
	else
		b_evac = true;
	end
	
	cs_face_object(false, ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1));
	
	// ========== hover above landing
	repeat
	
		if (		(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)))
				or	(s_e9m3_scenario >= 4)
				) then
			b_evac = true;
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == true) then
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p9, phantom1.face7);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == false, 1, 30 * (random_range(3, 5)));
		else
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p9, phantom1.face8);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)), 1, 30 * (random_range(3, 5)));
		end
						
		if (		(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)))
				or	(s_e9m3_scenario >= 4)
				) then
			b_evac = true;
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == true) then
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p10, phantom1.face7);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == false, 1, 30 * (random_range(3, 5)));
		else
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p10, phantom1.face8);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)), 1, 30 * (random_range(3, 5)));
		end
		
		if (		(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)))
				or	(s_e9m3_scenario >= 4)
				) then
			b_evac = true;
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == true) then
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p8, phantom1.face3);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false) == false, 1, 30 * (random_range(3, 5)));
		else
			cs_vehicle_speed(.1 * random_range(1, 8));
			cs_fly_to_and_face(phantom1.p8, phantom1.face1);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)), 1, 30 * (random_range(3, 5)));
		end
		
	until(		(b_evac == true)
				or	(s_e9m3_scenario >= 4)
				, 1	);
	
	ai_object_set_targeting_bias(ai_current_actor, 0);
	
	// === evac
	cs_vehicle_speed(1);
	cs_face_player(true);
	cs_fly_by(phantom_excess.p0, 2);
	cs_fly_by(phantom_excess.p1, 2);
	cs_face(true, phantom_excess.p3);
	cs_fly_by(phantom_excess.p2, 2);
	cs_fly_by(phantom_excess.p3, 2);
	cs_face(true, phantom_excess.p4);
	cs_fly_by(phantom_excess.p4, 2);
	thread(f_aircraft_scale_out(ai_current_actor));
	
end

script command_script cs_e9m3_faux_phantom_1
	sleep(2);
	f_e9m3_kill_the_turrets(ai_vehicle_get(ai_current_actor));
	f_e9m3_kill_chin_gun(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	ai_set_blind (ai_current_squad, true);
	cs_fly_to_and_face(phantom1.f0, phantom1.fface0, 3);
	cs_fly_to_and_face(phantom1.f0, phantom1.face2, 3);
	cs_fly_to_and_face(phantom1.f1, phantom1.p2, 3);
	cs_fly_to_and_face(phantom1.f2, phantom1.fface1, 3);
	f_despawn_hack(ai_current_actor);
end

script command_script cs_e9m3_faux_phantom_2
	sleep(2);
	f_e9m3_kill_the_turrets(ai_vehicle_get(ai_current_actor));
	f_e9m3_kill_chin_gun(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	ai_set_blind (ai_current_squad, true);
	cs_fly_to_and_face(phantom1.f3, phantom1.fface2, 3);
	cs_fly_to_and_face(phantom1.f4, phantom1.fface2, 3);
	cs_fly_to_and_face(phantom1.f5, phantom1.fface2, 3);
	f_despawn_hack(ai_current_actor);
end

script command_script cs_e9m3_phantom_2
	ai_set_blind (ai_current_squad, false);
	sleep_until(b_e9m3_dance_step >= 5);
	f_aircraft_scale_in(ai_current_actor, phantom2.teleport);
	cs_ignore_obstacles (TRUE);
	
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	cs_fly_to_and_face(phantom2.p0, phantom2.face1);
	
	local boolean b_evac = false;
	cs_fly_to_and_face(phantom2.p1, phantom2.face1);
//	cs_fly_to_and_face(phantom2.p6, phantom2.face3);
	cs_fly_to_and_face(phantom2.p7, phantom2.face2);
	
	thread(f_e9m3_blip_landing_phantom_2());

	repeat
		
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == true) then
			cs_fly_to_and_face(phantom4.fire_0, phantom4.0_face_r);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == false, 1, 30 * (random_range(0, 5)));		//
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) then
				b_evac = true;
		else
			cs_fly_to_and_face(phantom4.fire_0, phantom4.0_face_l);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 5)));	//
		end

		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == true) then
			cs_fly_to_and_face(phantom4.fire_1, phantom4.1_face_r);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == false, 1, 30 * (random_range(0, 5)));		//
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) then
				b_evac = true;
		else
			cs_fly_to_and_face(phantom4.fire_1, phantom4.1_face_l);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 5)));	//
		end
	
		if(random_range(0, 2) == 2)then
		
			if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == true) then
				cs_fly_to_and_face(phantom4.fire_0, phantom4.0_face_r);
				sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == false, 1, 30 * (random_range(0, 5)));		//
			elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) then
					b_evac = true;
			else
				cs_fly_to_and_face(phantom4.fire_0, phantom4.0_face_l);
				sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 5)));	//
			end
	
			if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == true) then
				cs_fly_to_and_face(phantom4.fire_1, phantom4.1_face_r);
				sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == false, 1, 30 * (random_range(0, 5)));		//
			elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) then
					b_evac = true;
			else
				cs_fly_to_and_face(phantom4.fire_1, phantom4.1_face_l);
				sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 5)));	//
			end
		
		end
		
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == true) then
			cs_fly_to_and_face(phantom4.fire_2, phantom4.0_face_r);																				// sic
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false) == false, 1, 30 * (random_range(0, 5)));		//
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0))) then
				b_evac = true;
		else
			cs_fly_to_and_face(phantom4.fire_2, phantom4.2_face_l);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 5)));	//
		end
		
		if (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)) == true) then
			b_evac = true;
		else
			cs_fly_to_and_face(phantom2.p4, phantom2.face2);
			cs_fly_to_and_face(phantom2.p5, phantom2.face3);
			cs_fly_to_and_face(phantom2.p6, phantom2.face3);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)), 1, 30 * (random_range(0, 3)));
			if	(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)) == false) then
				cs_fly_to_and_face(phantom2.p7, phantom2.face2);
			end
		end
	until(b_evac == true, 1);
	
	// === evac
	cs_face_player(true);
	cs_fly_by(phantom_excess.p5, 2);
	cs_fly_by(phantom_excess.p2, 2);
	cs_face(true, phantom_excess.p3);
	cs_fly_by(phantom_excess.p3, 2);
	thread(f_aircraft_scale_out(ai_current_actor));
	cs_face(true, phantom_excess.p4);
	cs_fly_by(phantom_excess.p4, 2);
end

script command_script cs_e9m3_phantom_2b
	//f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0))
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	cs_fly_to_and_face(phantom2.p9, phantom2.face5);
	cs_fly_to_and_face(phantom2.p10, phantom2.face6);
	ai_set_blind (ai_current_squad, false);
	
	sleep_until(	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0), false) == false)
						or	(object_get_health(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0)) <= .6)
						, 1, 30 * 20);
	
	cs_fly_to_and_face(phantom2.p9, phantom2.face9);
	cs_fly_to_and_face(phantom2.p9, phantom2.face7);
	cs_fly_to_and_face(phantom2.p9, phantom2.face7);
	cs_fly_to_and_face(phantom2.p10, phantom2.face8);
	
	sleep_until(	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0), true) == false)
						or	(object_get_health(ai_vehicle_get_from_squad(sq_e9m3_phantom_2b, 0)) <= .2)
						, 1, 30 * 20);

	cs_face(true, phantom2.face5);
	cs_fly_by(phantom2.p11);
	cs_fly_by(phantom2.p12);

	sleep(30);
	ai_set_blind (ai_current_squad, false);
	
	f_despawn_hack(ai_current_actor);
//	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_sc01");
//	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_sc02");
end

script command_script cs_e9m3_phantom_2c
	ai_set_blind (ai_current_actor, false);
	f_aircraft_scale_in(ai_current_actor, phantom2.teleport2);
	
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	cs_ignore_obstacles (TRUE);
////////////////////////////////////	
	cs_fly_to_and_face(phantom2.p13, phantom2.face8);
	cs_fly_to_and_face(phantom2.p14, phantom2.p15);
	cs_fly_to_and_face(phantom2.p15, phantom2.face4);
////////////////////////////////////
	sleep(15);
//	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_lc");
//	sleep(15);
//	ai_set_blind (ai_current_actor, false);
	repeat
		local boolean b_evac = false;
		
		//p16
		if		(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == true) then		// test left door gunner
			cs_fly_to_and_face(phantom2.p16, phantom2.p6);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == false, 1, 30 * 5);
		elseif(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == true) then		// test right door gunner
			cs_fly_to_and_face(phantom2.p16, phantom2.face11);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_spawn_point(sq_e9m3_phantom_2c.1), false) == false, 1, 30 * 5);
		else
			b_evac = true;
		end
		
		//p17
		if		(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == true) then		// test left door gunner
			cs_fly_to_and_face(phantom2.p17, phantom2.face10);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == false, 1, 30 * 5);
			cs_fly_to_and_face(phantom2.p16, phantom2.p6);
		elseif(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == true) then		// test right door gunner
			cs_fly_to_and_face(phantom2.p17, phantom2.face2);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == false, 1, 30 * 5);
			cs_fly_to_and_face(phantom2.p16, phantom2.face11);
		else
			b_evac = true;
		end
		
		//p15
		if		(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == true) then		// test left door gunner
			cs_fly_to_and_face(phantom2.p15, phantom2.p14);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), true) == false, 1, 30 * 5);
		elseif(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == true) then		// test right door gunner
			cs_fly_to_and_face(phantom2.p15, phantom2.face2);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2c, 0), false) == false, 1, 30 * 5);
		else
			b_evac = true;
		end
		
		if(s_e9m3_scenario >= 30)then
			b_evac = true;
		end
		
	until(b_evac == true);
	cs_fly_to_and_face(phantom_excess.p6, phantom2.face7);
	
	cs_fly_to_and_face(phantom2.p11, phantom2.face5);
	cs_fly_by(phantom2.p12);

	sleep(30);
	ai_set_blind (ai_current_squad, false);
	
	f_despawn_hack(ai_current_actor);

end

script command_script cs_e9m3_phantom_3
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	sleep_until(b_e9m3_dance_step >= 5);
	
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	cs_fly_to(phantom3.p0);
	cs_fly_to_and_face(phantom3.p1, phantom3.face1);
	cs_fly_to_and_face(phantom3.p2, phantom3.face2);
	ai_set_blind (ai_current_squad, false);
	
	thread(f_e9m3_blip_landing_phantom_3());
	
	local boolean b_guns = true;
	
	repeat
		
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == true) then
			cs_fly_to_and_face(phantom3.fire1, phantom3.broad1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == false, 1, 30 * (random_range(0, 5)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0))) then
				b_guns = false;
		else
			cs_fly_to_and_face(phantom3.fire1, phantom3.broad2);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)), 1, 30 * (random_range(0, 5)));
		end

		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == true) then
			cs_fly_to_and_face(phantom3.fire2, phantom3.broad5);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == false, 1, 30 * (random_range(0, 5)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0))) then
				b_guns = false;
		else
			cs_fly_to_and_face(phantom3.fire2, phantom3.broad4);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)), 1, 30 * (random_range(0, 5)));
		end		

		if (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)) == false) then
			cs_fly_to_and_face(phantom3.transition1, phantom3.face4);
			cs_fly_to_and_face(phantom3.fire4, phantom3.face5);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)), 1, 30 * (random_range(0, 5)));
			if(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)))then
				cs_fly_to_and_face(phantom3.fire3, phantom3.transition2);
			end
		else 
				b_guns = false;
		end		


		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == true) then
			cs_fly_to_and_face(phantom3.fire3, phantom3.broad3);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == false, 1, 30 * (random_range(0, 5)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0))) then
				b_guns = false;
		else
			cs_fly_to_and_face(phantom3.fire3, phantom3.broad1);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)), 1, 30 * (random_range(0, 5)));
		end		

		// transition back to beginning of loop		
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false) == true) then
			cs_fly_to_and_face(phantom3.fire3, phantom3.transition2);
			cs_fly_to_and_face(phantom3.transition2, phantom3.broad4); 													// from right gunner back to right gunner
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0))) then
				b_guns = false;
		else
			cs_fly_to_and_face(phantom3.transition2, phantom3.fire3); 													// from left gunner back to left gunner
		end
		
	until(b_guns == false);

	ai_set_blind (ai_current_squad, true);
	// ============= evac	
	cs_fly_to_and_face(phantom3.transition2, phantom3.broad2);
	cs_fly_to_and_face(phantom3.p2, phantom3.face6);
	cs_fly_to_and_face(phantom3.p1, phantom3.p0);
	cs_fly_to_and_face(phantom3.p0, phantom3.p0);
		
	f_despawn_hack(ai_current_actor);
end

script command_script cs_e9m3_phantom_boss																								// garrison
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	
	unit_open(ai_vehicle_get_from_squad (sq_e9m3_phantom_boss, 0));
	
	thread(f_e9m3_phantom_stinger(unit_get_vehicle(ai_current_actor)));
	
	f_e9m3_boss_phantom_load_in();
	sleep(1);
	
	if(ai_living_count(ai_ff_all) <= 19)then
		thread(f_e9_m3_load_playload(sq_e9m3_phantom_boss, sq_e9m3_ghost_1.1, sq_e9m3_ghost_2.1));
	end
	
	cs_vehicle_speed(2);																										
	cs_face(true, phantom_boss.face0);
	cs_vehicle_speed(2);																										
	cs_fly_by(phantom_boss.p0, 1);
	cs_vehicle_speed(2);																										
	cs_face(true, phantom_boss.face1);
	cs_vehicle_speed(2);																										
	cs_fly_by(phantom_boss.p1, 1);
	cs_vehicle_speed(2);																										
	cs_face(true, phantom_boss.face2);
	cs_vehicle_speed(2);																										
	
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	thread(cs_e9m3_unload_boss_phantom_with_delay());
	
	cs_fly_by(phantom_boss.p2, 1);
	
	sleep(20);
	
	vehicle_unload(ai_vehicle_get_from_squad (sq_e9m3_phantom_boss, 0), "phantom_sc01");
	vehicle_unload(ai_vehicle_get_from_squad (sq_e9m3_phantom_boss, 0), "phantom_sc02");
	
	sleep(30);
	thread(f_e9m3_blip_boss_door_gunners());
		local short s_evac = 0;
	
	repeat
	
	local short s_pos = random_range(1, 2);
	
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == true)then
			cs_face(true, phantom_boss.face2);
			cs_fly_by(phantom_boss.p3, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == false, 1, 30 * (random_range(0, 7)));
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == true)then
			cs_face(true, phantom_boss.face2l);
			cs_fly_by(phantom_boss.p3, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == false, 1, 30 * (random_range(0, 8)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == false)then
			cs_face(true, phantom_boss.face_forward);
			cs_fly_by(phantom_boss.p3, 1);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == true, 1, 30 * (random_range(0, 3)));
			s_evac = s_evac + 2;
		else
			s_evac = 5;
		end

	if(s_pos == 1)then
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == true)then
			cs_face(true, phantom_boss.face1);
			cs_fly_by(phantom_boss.p4, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == false, 1, 30 * (random_range(0, 8)));
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == true)then
			cs_face(true, phantom_boss.face1l);
			cs_fly_by(phantom_boss.p4, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == false, 1, 30 * (random_range(0, 8)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == false)then
			cs_face(true, phantom_boss.face_forward);
			cs_fly_by(phantom_boss.p4, 1);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == true, 1, 30 * (random_range(0, 2)));
			s_evac = s_evac + 2;
		else
			s_evac = 5;
		end
	else
		if (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == true)then
			cs_face(true, phantom_boss.face5);
			cs_fly_by(phantom_boss.p5, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), false) == false, 1, 30 * (random_range(0, 8)));
		elseif (f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == true)then
			cs_face(true, phantom_boss.face5l);
			cs_fly_by(phantom_boss.p5, 1);
			sleep_until(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(ai_current_squad, 0), true) == false, 1, 30 * (random_range(0, 8)));
		elseif (f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == false)then
			cs_face(true, phantom_boss.face_forward);
			cs_fly_by(phantom_boss.p5, 1);
			sleep_until(f_e9m3_phantom_has_no_guns(ai_vehicle_get_from_squad(ai_current_squad, 0)) == true, 1, 30 * (random_range(0, 2)));
			s_evac = s_evac + 2;
		else
			s_evac = 5;
		end
	end

	until(s_evac >= 2, 1);
	
	sleep (3);

	cs_face(true, pelicans.face6);
	f_blip_ai_cui(sq_e9m3_phantom_boss.1, "");
	cs_fly_by(pelicans.p0, 1);
	cs_face(true, pelicans.face4);
	cs_fly_by(pelicans.p4, 1);
	cs_face(true, pelicans.face5);
	cs_fly_by(pelicans.p5, 1);
	
	f_despawn_hack(ai_current_actor);
	
end

script static void cs_e9m3_unload_boss_phantom_with_delay
	sleep(30);
	vehicle_unload(ai_vehicle_get_from_squad (sq_e9m3_phantom_boss, 0), "phantom_p_rf_main");
	vehicle_unload(ai_vehicle_get_from_squad (sq_e9m3_phantom_boss, 0), "phantom_p_rb_main");
end

script static boolean f_e9m3_boss_phantom_load_in
	ai_place_in_limbo(sq_e9m3_garrison_swordsmen.1);
	ai_place_in_limbo(sq_e9m3_garrison_swordsmen.2);
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e9m3_phantom_boss, 0), "phantom_p_rf_main", ai_actors(sq_e9m3_garrison_swordsmen.1));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e9m3_phantom_boss, 0), "phantom_p_rb_main", ai_actors(sq_e9m3_garrison_swordsmen.2));
	ai_exit_limbo(sq_e9m3_garrison_swordsmen.1);
	ai_exit_limbo(sq_e9m3_garrison_swordsmen.2);

	true;
end

script static void f_e9m3_blip_landing_phantom_2
	f_blip_ai_cui(sq_e9m3_phantom_2.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_2.3, "navpoint_enemy");
	sleep_until	(		(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), true)== false)
							and	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0), false)== false)
							, 1 );
	thread(f_e9m3_blip_until_chin_gun_is_gone(sq_e9m3_phantom_2.1, ai_vehicle_get_from_squad(sq_e9m3_phantom_2, 0)));
end

script static void f_e9m3_blip_landing_phantom_3
	f_blip_ai_cui(sq_e9m3_phantom_3.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_3.3, "navpoint_enemy");
	sleep_until	(		(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), true)== false)
							and	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0), false)== false)
							, 1 );
	thread(f_e9m3_blip_until_chin_gun_is_gone(sq_e9m3_phantom_3.1, ai_vehicle_get_from_squad(sq_e9m3_phantom_3, 0)));
end

script static void f_e9m3_blip_first_phantom		
	sleep(30 * 3);
	f_blip_ai_cui(sq_e9m3_phantom_1.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_1.3, "navpoint_enemy");
	sleep_until	(		(s_e9m3_scenario >= 4)
							or
								(	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), true)== false)
							and	(f_test_door_gunner_is_alive(ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0), false)== false)
								)	, 1 );
	f_blip_ai_cui(sq_e9m3_phantom_1.2, "");
	f_blip_ai_cui(sq_e9m3_phantom_1.3, "");
	if	(s_e9m3_scenario < 4)	then
		thread(f_e9m3_blip_until_chin_gun_is_gone(sq_e9m3_phantom_1.1, ai_vehicle_get_from_squad(sq_e9m3_phantom_1, 0)));
		sleep_until(s_e9m3_scenario >= 4);
		f_blip_ai_cui(sq_e9m3_phantom_1.1, "");
	end
end

script static void f_e9m3_blip_boss_door_gunners
	sleep(30 * 5);
	f_blip_ai_cui(sq_e9m3_phantom_boss.2, "navpoint_enemy");
	f_blip_ai_cui(sq_e9m3_phantom_boss.3, "navpoint_enemy");
	sleep_until	(		(f_test_door_gunner_is_alive(ai_vehicle_get_from_spawn_point(sq_e9m3_phantom_boss.1), true)== false)
							and	(f_test_door_gunner_is_alive(ai_vehicle_get_from_spawn_point(sq_e9m3_phantom_boss.1), false)== false)
							, 1 );
	thread(f_e9m3_blip_until_chin_gun_is_gone(sq_e9m3_phantom_boss.1, ai_vehicle_get_from_spawn_point(sq_e9m3_phantom_boss.1)));
end

script static void f_e9m3_blip_until_chin_gun_is_gone (ai ai_blipee, vehicle vh_phantom)
	f_blip_ai_cui(ai_blipee, "navpoint_enemy");
	sleep_until(f_e9m3_chin_gun_is_gone(vh_phantom), 1);
	f_blip_ai_cui(ai_blipee, "");
end

script static boolean f_e9m3_chin_gun_is_gone (vehicle vh_phantom)
	if(object_at_marker(vh_phantom, "chin_gun") == none)then
		true;
	else
		false;
	end
end

script static boolean f_e9m3_phantom_has_no_guns (vehicle vh_phantom)
	if	(		(f_e9m3_chin_gun_is_gone(vh_phantom) == true) and 
					(f_test_door_gunner_is_alive(vh_phantom, true)== false) and
					(f_test_door_gunner_is_alive(vh_phantom, false)== false)
			)then
		//print("!!!!!!!!!!!!!!!!!!!!!!!!!!!========================== ALL GUNS GONE ===========================!!!!!!!!!!!!!!!!!!!!!!!!!!");
		true;
	else
		//print("!!!!!!====== at least 1 gun intact =======!!!!!!");
		false;
	end
end

script static void f_e9m3_phantom_stinger (vehicle vh_phantom)
	sleep_until(f_e9m3_phantom_has_no_guns (vh_phantom), 5);
	thread(f_e9m3_stinger_phantom_stripped());
end

script static void f_e9m3_kill_the_turrets (vehicle vh_phantom)
	object_destroy(object_at_marker(vh_phantom,"turret_l"));
	object_destroy(object_at_marker(vh_phantom,"turret_r"));
end

script static void f_e9m3_kill_chin_gun (vehicle vh_phantom)
	object_destroy(object_at_marker(vh_phantom, "chin_gun"));
end


//==== PELICANS AND SCORPIONS
script command_script cs_e9m3_pelican_gunner
	ai_set_blind (ai_current_squad, false);
	cs_enable_looking(true);
	cs_enable_targeting(true);
	cs_shoot(true);
end

script command_script cs_e9m3_pelican1																										//pelican
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	ai_place(sq_e9m3_pelican1_gunners);
	cs_vehicle_speed(1);																										
	thread(f_e9m3_pelican_damage_but_not_die(ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1)));
		
	
	sleep(30 * 1);
	
	thread(f_e9m3_encounter_1());
	
	sleep(30 * .5);
	
	cs_face(true, pelican1.face1);
	cs_fly_by(pelican1.p0, 1);																															//pelican
	
	cs_face(true, pelican1.face4);
	cs_fly_by(pelican1.p1, 1);
	
	sleep(30 * 1.5);
	
	ai_set_blind (ai_current_squad, false);
	if(s_e9m3_scenario == 0)then
		s_e9m3_scenario = 2;
	end
	
	cs_vehicle_speed(.5);
	cs_face(true, pelican1.face4);
	cs_vehicle_speed(.5);
	cs_fly_by(pelican1.p2, 1);
	
	
	
	if	(s_e9m3_scenario < 4)	then
		cs_vehicle_speed(.5);
		cs_face(true, pelican1.face5);
		cs_vehicle_speed(.5);
		cs_fly_by(pelican1.p2, 1);
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 1);
	end
	
	thread(f_e9m3_shoot_me(ai_current_actor));
	
	if	(s_e9m3_scenario < 4)	then
		cs_vehicle_speed(.2);
		cs_face(true, pelican1.face6);
		cs_vehicle_speed(.2);
		cs_fly_by(pelican1.p4, 1);
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 4);
	end
	
	if	(s_e9m3_scenario < 4)	then
		cs_vehicle_speed(1);
		cs_fly_by(pelican1.p5, 1);
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 1);
	end
	
	if (s_e9m3_scenario < 4)	then
		cs_face(true, pelican1.face5);
		cs_fly_by(pelican1.p5, 1);																															//pelican
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 4);
		cs_fly_by(pelican1.p4, 1);
	end
	
	thread(f_e9m3_dont_shoot_me());
	
	if (s_e9m3_scenario < 4)	then
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 3);
		cs_face_object(true, ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_1.1));
		cs_fly_by(pelican1.p6, 1);																															// above the rock formation
	end
	
	b_e9m3_dance_step = 1;
	
	if (s_e9m3_scenario < 4)	then
		sleep_until(	(s_e9m3_scenario >= 4)
								or	(b_e9m3_dance_step == 2)
								, 1, 30 * 6
								);
		sleep(10);
		cs_fly_by(pelican1.p7, 1);
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * 1);
		cs_fly_by(pelican1.p8, 1);
	end
	
	b_e9m3_dance_step = 3;
	// thread(f_e9m3_summon_pelican_hunters());																							// 1-4-2013
	//
	// dogfight sequence
	//
	
	repeat																																									//pelican
		local short s_pos = random_range(1, 2);
		
		if(s_e9m3_scenario > 4) then
			print("do nothing");
		elseif(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == false)then
			cs_vehicle_speed(.1 * random_range(2, 10));
			cs_fly_by(pelican1.p10, 1);
			cs_vehicle_speed(.1 * random_range(2, 10));
			cs_face(true, pelican1.face6);
			sleep_until (s_e9m3_scenario >= 4, 1, 30 * random_range(1, 4));
		end
		
		if(s_e9m3_scenario > 4) then
			print("do nothing");
		elseif(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == false)then
			cs_vehicle_speed(.1 * random_range(2, 10));
			cs_fly_by(pelican1.p9, 1);
			cs_vehicle_speed(.1 * random_range(2, 10));
			cs_face(true, pelican1.p10);
		end
		
		if(s_e9m3_scenario > 4) then
			print("do nothing");
		elseif(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == false)then
			if(s_pos == 1)then
				cs_fly_by(pelican1.p8);
				cs_vehicle_speed(.1 * random_range(2, 10));
				cs_face(true, pelican1.p12);
				sleep_until (s_e9m3_scenario >= 4, 1, 30 * random_range(1, 4));
				cs_fly_by(pelican1.p9);
			else
				cs_fly_by(pelican1.p10);
			end
		end
	
	until(	(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == true) or
					(s_e9m3_scenario >= 4), 1
				);
	
	//
	//		faux retreat
	//
	if (s_e9m3_scenario < 4)	then
		cs_vehicle_speed(.3);
		cs_face(true, pelican1.face3);
		cs_fly_by(pelican1.p11);
	end
	
	b_e9m3_dance_step = 4;																																						// gunners will shoot randomly
	
	
	repeat
		if(s_e9m3_scenario < 4)then
			sleep_until (s_e9m3_scenario >= 4, 1, 30 * random_range(1, 4));
			cs_vehicle_speed(.1 * random_range(1, 4));
			cs_fly_by(pelican1.p17, 1);
		end
		
		sleep_until (s_e9m3_scenario >= 4, 1, 30 * random_range(1, 4));
		
		if(s_e9m3_scenario < 4)then
			cs_vehicle_speed(.1 * random_range(1, 4));
			cs_fly_by(pelican1.p11, 1);
		end
		
	until(	(volume_test_players(tv_landing_1) == true)																								// wait til players arrive
				or (s_e9m3_scenario >= 4)
				, 15);																																											// 1-4-2013
	
	cs_vehicle_speed(1);
	sleep(30);
	cs_fly_by(pelican1.p12);
	b_e9m3_dance_step = 5;
	cs_face(true, pelican1.face5);
	cs_fly_by(pelican1.p12);
	cs_face(true, pelican1.face7);
	cs_fly_by(pelican1.p12);
	cs_face(true, pelican1.face8);
	cs_fly_by(pelican1.p13);
	cs_face(true, pelican1.face9);
	cs_fly_by(pelican1.p14);
	cs_fly_by(pelican1.p15);
	cs_fly_by(pelican1.p16);
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1));
	ai_erase(ai_current_actor);
	
end																																																	//pelican /end

script command_script cs_e9m3_pelican1_left_gunner
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rl")));
	ai_set_blind (ai_current_actor, true);

	sleep_until(s_e9m3_scenario >= 2);
	ai_set_blind (ai_current_actor, false);
	cs_enable_targeting(ai_current_actor, true);
//	cs_enable_looking(ai_current_actor, true);
//	cs_shoot(true);
	
	sleep_until(b_e9m3_dance_step == 1);
	
	cs_shoot_point(true, pelican1.shoot_lip);
	f_wait(2);
	cs_shoot_point(true, pelican1.shoot_cliff);
	f_wait(1);
	cs_shoot_point(true, pelican1.shoot_lip);
	f_wait(2);
	if(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == false)then
		repeat
			cs_shoot(true, sq_e9m3_phantom_1);
//			sleep(30 * random_range(1, 4));
//			cs_shoot(false);
//			sleep(30 * random_range(0, 2));
		until(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == true);
			f_wait(1);
			cs_shoot(true);
	end
	
	sleep_until(b_e9m3_dance_step == 4);
	cs_shoot(false);																																									// 1-4-2013
	ai_set_blind (ai_current_actor, true);																														// 1-4-2013
/*	repeat																																													// 1-4-2013
		if(b_e9m3_dance_step <= 4)then
			f_wait(2);
			cs_shoot_point(true, pelican1.shoot_lip);
			f_wait(4);
		end
		cs_shoot_point(true, pelican1.shoot_cliff);
		f_wait(1);
		if(b_e9m3_dance_step <= 4)then
			cs_shoot(false); 
			f_wait(2);
			cs_shoot(true);
			cs_shoot_point(true, pelican1.shoot_cliff);
			f_wait(1);
		end
		cs_shoot(false); 
		f_wait(1);
		cs_shoot(true);
		if(b_e9m3_dance_step <= 4)then
			cs_shoot_point(true, pelican1.shoot_wide);
			f_wait(2);
		end
	until(b_e9m3_dance_step == 5);
	cs_shoot_point(true, pelican1.shoot_cliff);
	f_wait(2);
	cs_shoot_point(true, pelican1.shoot_wide);
	f_wait(2);
	cs_shoot(false); */
end

script command_script cs_e9m3_pelican1_right_gunner
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")));
	ai_set_blind (ai_current_actor, true);

	sleep_until(s_e9m3_scenario >= 2);
	ai_set_blind (ai_current_actor, false);
	cs_enable_targeting(ai_current_actor, true);
//	cs_enable_looking(ai_current_actor, true);
//	cs_shoot(true);
	
	sleep_until(b_e9m3_dance_step == 1);
	cs_shoot_point(true, pelican1.shoot_wide);
	f_wait(4);
	if(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == false)then
		repeat
			cs_shoot(true, ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_1.1));
		until(f_e9m3_phantom_has_no_guns(unit_get_vehicle(sq_e9m3_phantom_1)) == true);
		f_wait(1);
		cs_shoot(true);
	end
	
	sleep_until(b_e9m3_dance_step == 4);
	cs_shoot(false);																																									// 1-4-2013
	ai_set_blind (ai_current_actor, true);																														// 1-4-2013
/*	repeat
		if(b_e9m3_dance_step <= 4)then
			f_wait(3);
			cs_shoot_point(true, pelican1.shoot_switchback);
			f_wait(3);
		else
			f_wait(0);
		end
		cs_shoot_point(true, pelican1.shoot_trough);
		f_wait(1);
		if(b_e9m3_dance_step <= 4)then
			cs_shoot(false); 
			f_wait(2);
			cs_shoot(true);
			cs_shoot_point(true, pelican1.p10);
			f_wait(2);
		else
			f_wait(0);
		end
		cs_shoot(false); 
		f_wait(1.5);
		cs_shoot(true);
		if(b_e9m3_dance_step <= 4)then
			cs_shoot_point(true, pelican1.shoot_switchback);
			f_wait(4);
		else
			f_wait(0);
		end
	until(b_e9m3_dance_step == 5);
	sleep(20);
	cs_shoot_point(true, pelican1.p10);
	f_wait(1);
	cs_shoot_point(true, pelican1.shoot_switchback);
	f_wait(2);
	cs_shoot(false); */
end

script static void f_wait (real seconds)
	sleep(30 * seconds);
end

script static void f_e9m3_pelican_damage_but_not_die (vehicle v_pelican)
	object_cannot_die(v_pelican, true);
	object_immune_to_friendly_damage(v_pelican, true);
	sleep_until(object_get_health(v_pelican) <= .25);
	object_cannot_take_damage(v_pelican);
end

script command_script cs_e9m3_pelican_1a
	ai_set_blind (ai_current_squad, false);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	cs_face(true, pelican2.face6);
	cs_fly_by(pelican2.p8, 1);	
	cs_face(true, pelican2.face2);
	cs_fly_by(pelican2.p9, 1);	
	// retreat
	cs_fly_to_and_face(pelican2.p1, pelican2.face5, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p0, pelican2.face5, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p4, pelican2.face5, 1);																								//pelican2
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1a.1));
	ai_erase(ai_current_actor);
end


script command_script cs_e9m3_pelican2
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	thread(f_e9m3_pelican_damage_but_not_die(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2.1)));
	sleep(15);
	
	local vehicle veh_tank = f_load_pelican (sq_e9m3_pelican_2);
	
	thread(f_e9m3_tank_drop_audio(tv_audio_1, veh_tank));
	cs_fly_to_and_face(pelican2.p0, pelican2.face1, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p1, pelican2.face2, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p2, pelican2.face3, 1);																								//pelican2
	thread(f_e9m3_scorpion_squish());
	sleep_until(volume_test_players(tv_landing_lz) == false, 1);
	cs_fly_to_and_face(pelican2.p3, pelican2.face3, 1);																								//pelican2
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2.1), "pelican_lc");
	sleep(30);
	cs_fly_to_and_face(pelican2.p2, pelican2.face3, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p1, pelican2.face4, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p1, pelican2.face5, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p0, pelican2.face5, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p4, pelican2.face5, 1);																								//pelican2
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2.1));
	ai_erase(sq_e9m3_pelican_2.2);
	ai_erase(sq_e9m3_pelican_2.3);
	ai_erase(sq_e9m3_pelican_2.4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican3
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	sleep(15);
	thread(f_e9m3_pelican_damage_but_not_die(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1)));
	
	local vehicle veh_tank = f_load_pelican (sq_e9m3_pelican_3);
	
	if	(s_pelican_sortie == 0)	then																												// garrison dropoff
		thread(f_e9m3_tank_drop_audio(tv_audio_3, veh_tank));
	else																																										// gateyard dropoff
		thread(f_e9m3_tank_drop_audio(tv_audio_5, veh_tank));
	end
	
	f_aircraft_scale_in(ai_current_actor, pelicans.p14);

	cs_face(true, pelicans.face9);
	cs_fly_by(pelicans.p16, 3);
	cs_fly_by(pelicans.p2, 1);
	
	
	if	(s_pelican_sortie == 0)	then																												// garrison dropoff
		thread(f_e9m3_scorpion_squish());
		sleep_until(volume_test_players(tv_garrison_rear_lz) == false, 1);
		
		cs_fly_to_and_face(pelicans.p3, pelicans.face9, 1);
		sleep(30 * 2);
		vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1), "pelican_lc");
		sleep(30);
		
	else																																										// gateyard dropoff
		cs_face(true, pelican2.g_face1);
		cs_fly_by(pelican2.g1, 1);
		cs_fly_by(pelican2.g2, 1);
		
		if(object_active_for_script(e9m3_barrier_4)) then
			sleep_until(object_get_shield(e9m3_barrier_4) <= 0);
		end
		
		cs_fly_by(pelican2.g3, 1);
		sleep(30 * 2);
		vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1), "pelican_lc");
		sleep(30);
		cs_fly_to_and_face(pelican2.p5, pelican2.g1, 1);
		cs_face(true, pelicans.face6);
		cs_fly_by(pelican2.g1, 1);
		
		s_pelican_sortie = 2;
		
	end
	
	// retreat
	cs_fly_by(pelicans.p2, 1);
	sleep(30 * 2);
	cs_face(true, pelicans.face6);
	cs_fly_by(pelicans.p0, 1);
	cs_face(true, pelicans.face4);
	cs_fly_by(pelicans.p4, 1);
	cs_face(true, pelicans.face5);
	cs_fly_by(pelicans.p5, 1);
	
	if(s_pelican_sortie == 0)then
		s_pelican_sortie = 1;
	end
	
	sleep(5);
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1));
	sleep(2);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican4
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	sleep(15);
	thread(f_e9m3_pelican_damage_but_not_die(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1)));
	
	local vehicle veh_tank = f_load_pelican (sq_e9m3_pelican_4);
	
	if	(s_pelican_sortie == 0)	then																												// garrison dropoff
		thread(f_e9m3_tank_drop_audio(tv_audio_2, veh_tank));
	else																																										// gateyard dropoff
		thread(f_e9m3_tank_drop_audio(tv_audio_4, veh_tank));
	end
	
	f_aircraft_scale_in(ai_current_actor, pelicans.p15);

	cs_face(true, pelicans.face2);
	cs_fly_by(pelicans.p17, 3);
	if	(s_pelican_sortie == 0)	then																												// garrison dropoff
		cs_fly_by(pelicans.p8, 1);
		sleep(30 * 2);
		thread(f_e9m3_scorpion_squish());
		sleep_until(volume_test_players(tv_garrison_front_lz) == false, 1);
		cs_fly_to_and_face(pelicans.p9, pelicans.face2, 1);
		sleep(30 * 2);
		vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1), "pelican_lc");
		sleep(30);
		cs_vehicle_speed(.2);
	else																																										// gateyard dropoff
		sleep(30 * 4);
		cs_face(true, pelican2.g_face1);
		cs_fly_by(pelican2.g4, 1);	
		cs_fly_by(pelican2.g5, 1);
		sleep_until (s_pelican_sortie >= 2);
		cs_fly_by(pelican2.g7, 1);
		cs_face(true, pelican2.g_face2);
		
		thread(f_e9m3_scorpion_squish());
		sleep_until(volume_test_players(tv_gateyard_front_lz) == false, 1);
		cs_fly_by(pelican2.g6, 1);
		sleep(30 * 2);
		vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1), "pelican_lc");
		sleep(30);
		cs_fly_by(pelican2.g7, 1);
		cs_face(true, pelicans.face6);
		cs_fly_by(pelican2.g1, 1);
		
	end
	cs_fly_by(pelicans.p10, 1);
	cs_face(true, pelicans.face6);
	cs_vehicle_speed(1);
	cs_fly_by(pelicans.p11, 1);
	cs_face(true, pelicans.face4);
	cs_fly_by(pelicans.p12, 1);
	cs_face(true, pelicans.face5);
	cs_fly_by(pelicans.p13, 1);
	
	sleep(5);
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1));
	sleep(2);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_scorpion1
	sleep_until(		volume_test_object(tv_landing_lz, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_switchback, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_garrison_front_lz, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_garrison_rear_lz, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_gateyard_front_lz, ai_get_object(ai_current_actor)) 
							);
	sleep(30 * 2);
	ai_vehicle_exit(ai_current_actor);
end

script static void f_e9m3_scorpion_squish
	
	if(		(	e9m3_narrative_is_on == false) 
		and
			(		volume_test_players(tv_landing_lz)
			or	volume_test_players(tv_switchback)
			or	volume_test_players(tv_garrison_front_lz)
			or	volume_test_players(tv_garrison_rear_lz)
			or	volume_test_players(tv_gateyard_front_lz)
			)
		)		then
	
		vo_e9m3_get_squished();
			// Dalton : Miller, my people can't give Crimson their new toy if they're going to stand in the way.
			// Miller : Stop screwing around, Crimson. Move.
	end
end

script static void f_e9m3_place_scorpions_in_garrison_or_gateyard
	ai_place(sq_e9m3_pelican_3);
	sleep(30);
	if(game_coop_player_count() >= 2)then
		ai_place(sq_e9m3_pelican_4);
	end
end

script static void f_e9m3_tankculler_pre_garrison
	if(object_active_for_script(e9m3_scorpion_1))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_1, tv_tank_pre_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_2))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_2, tv_tank_pre_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_3))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_3, tv_tank_pre_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_4))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_4, tv_tank_pre_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1), tv_tank_pre_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1), tv_tank_pre_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1), tv_tank_pre_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1), tv_tank_pre_garrison);
	end
end

script static void f_e9m3_tankculler_garrison
	if(object_active_for_script(e9m3_scorpion_1))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_1, tv_tank_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_2))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_2, tv_tank_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_3))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_3, tv_tank_garrison);
	end
	if(object_active_for_script(e9m3_scorpion_4))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(e9m3_scorpion_4, tv_tank_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1), tv_tank_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1), tv_tank_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1), tv_tank_garrison);
	end
	if(object_active_for_script(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)))then
		f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1), tv_tank_garrison);
	end
end

script static void f_e9m3_garbage_collect_this_vehicle_if_abandoned_in_this_volume(object o_veh, trigger_volume tv_trigger)
	if(		(volume_test_object(tv_trigger, o_veh))
		and (vehicle_driver(vehicle(o_veh)) == none)
		)	then	
		object_dispose(o_veh);
	end
end

script static boolean f_e9m3_vehicle_is_abandoned_in_volume(trigger_volume tv_trigger, object o_veh)
	inspect(	volume_test_object(tv_trigger, o_veh) and vehicle_driver(vehicle(o_veh)) == none);
	if(object_active_for_script(o_veh))then
		volume_test_object(tv_trigger, o_veh) and vehicle_driver(vehicle(o_veh)) == none;	
	end
end

script static void f_e9m3_tank_respawner_1
	repeat
			if	(		(object_get_health(e9m3_scorpion_1) <= 0)
					and	(object_get_health(e9m3_scorpion_2) <= 0)
					and	(object_get_health(e9m3_scorpion_3) <= 0)
					and	(object_get_health(e9m3_scorpion_4) <= 0)
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)) <= 0) 
					)	then
					object_create_anew(e9m3_scorpion_1);
					if(s_e9m3_scenario >= 10)then
						object_teleport(e9m3_scorpion_1, fl_landing_tank);
					end
			end
	until(s_e9m3_scenario >= 20, 60);																																	// 1-8-2013
end

script static void f_e9m3_tank_respawner_2
	repeat
	
		s_tank_count = 0;
		
		f_e9m3_tank_tally(e9m3_scorpion_1);
		f_e9m3_tank_tally(e9m3_scorpion_2);
		f_e9m3_tank_tally(e9m3_scorpion_3);
		f_e9m3_tank_tally(e9m3_scorpion_4);
		f_e9m3_tank_tally(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1));
		f_e9m3_tank_tally(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1));
		f_e9m3_tank_tally(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1));
		f_e9m3_tank_tally(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1));
	
			// 50 - garrison battle complete
			// 62 - zone set b loaded, aerie combat initialized
		////////////////////	1-8-2013
		if	(s_e9m3_scenario < 62)	then
		
			if	(s_tank_count == 0)	then
				object_create_anew(e9m3_scorpion_1);
				sleep(1);
				object_teleport(e9m3_scorpion_1, fl_garrison_tank);
			end		
			
		elseif	(s_e9m3_scenario >= 62)	then
		///////////////////////
			if		(		(s_tank_count == 1)
						and (f_e9m3_tank_tally(e9m3_scorpion_1) > 0)
						) then
					object_create_anew(e9m3_scorpion_2);
					sleep(1);
					object_teleport(e9m3_scorpion_2, fl_tank2);
			elseif(		(		(s_tank_count == 1)
								and (f_e9m3_tank_tally(e9m3_scorpion_2) > 0)
								)
								or
								(s_tank_count == 0)
						) then
					object_create_anew(e9m3_scorpion_1);
					sleep(1);
					object_teleport(e9m3_scorpion_1, fl_tank);
			end		

	end	
	/*
			if	(		(object_get_health(e9m3_scorpion_1) <= 0)
					and	(object_get_health(e9m3_scorpion_2) <= 0)
					and	(object_get_health(e9m3_scorpion_3) <= 0)
					and	(object_get_health(e9m3_scorpion_4) <= 0)
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_1.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_2.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_3.1)) <= 0) 
					and	(object_get_health(ai_vehicle_get_from_spawn_point(sq_e9m3_scorpion_4.1)) <= 0) 
					)	then
			
					object_create_anew(e9m3_scorpion_1);
					sleep(1);
					object_teleport(e9m3_scorpion_1, fl_tank);
			end
			*/	
		print("===");
		inspect(s_tank_count);	
	until (b_game_ended == true, 60);
end

script static real f_e9m3_tank_tally(vehicle v_tank) 
	if	(object_get_health(v_tank) > 0) then
		s_tank_count = s_tank_count + 1;
	end
	object_get_health(v_tank);
end

script static void f_e9m3_tank_drop_audio(trigger_volume tv_volume, vehicle veh_tank)
	sleep_until(volume_test_object(tv_volume, veh_tank), 1);
	sleep(3);
	print("*****************************************************************");
	print("*****************************************************************");
	print("*****************************************************************");
	print("***************                                      ************");
	print("***************                                      ************");
	print("***************               P O W                  ************");
	print("***************                                      ************");
	print("***************                                      ************");
	print("*****************************************************************");
	print("*****************************************************************");
	print("*****************************************************************");
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e9m3_scorpion_drop_mnde2836', veh_tank, 1 );
end

//====ai command scripts
script command_script cs_e9m3_phase_in
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep(20);
	ai_exit_limbo(ai_current_actor);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end
script command_script cs_e9m3_knight_phase_in
	cs_phase_in();
end

script command_script cs_e9m3_kamikaze
	ai_grunt_kamikaze(ai_current_actor);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_gunners_gonna_gun
	ai_set_blind(ai_current_actor, false);
	cs_enable_targeting (TRUE);
end

script command_script cs_e9m3_backup_ghost_2
	object_cannot_die(unit_get_vehicle(ai_current_actor), true);
	cs_abort_on_damage(true);
	cs_go_by(ghosts.p0, test.p0, 100);
	cs_go_by(ghosts.p1, test.p0, 100);
	object_cannot_die(unit_get_vehicle(ai_current_actor), false);
	cs_go_by(ghosts.p2, test.p0, 100);
end

script command_script cs_e9m3_backup_ghost_1
	object_cannot_die(unit_get_vehicle(ai_current_actor), true);
	cs_abort_on_damage(true);
	cs_go_by(ghosts.p3, test.p0);
	cs_go_by(ghosts.p4, test.p0);
	cs_go_by(ghosts.p5, test.p0);
	object_cannot_die(unit_get_vehicle(ai_current_actor), false);
	cs_go_by(ghosts.p6, test.p0);
	cs_go_by(ghosts.p7, test.p0);
end

script command_script cs_e9m3_pelican_hunter_1
	cs_go_to(pelican_hunters.p0);
	
	repeat
  	begin_random
    	begin
				cs_shoot(true, ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1));
			end
			begin
				cs_shoot_point(true, pelican_hunters.p1);
			end
			begin
				cs_shoot_point(true, pelican_hunters.p2);
			end
			begin
				cs_shoot_point(true, pelican_hunters.p3);
			end
		end
	until(b_e9m3_dance_step >= 5) or (ai_living_count(sq_e9m3_pelican_1) <= 0);
	ai_set_blind(ai_current_actor, true);
	cs_go_to(pelican_hunters.p4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican_hunter_2
	
	repeat
  	begin_random
    	begin
				cs_shoot(true, ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1));
			end
			begin
				cs_shoot_point(true, pelican_hunters.p5);
			end
			begin
				cs_shoot_point(true, pelican_hunters.p6);
			end
		end
	until(b_e9m3_dance_step >= 5) or (ai_living_count(sq_e9m3_pelican_1) <= 0);
	ai_set_blind(ai_current_actor, true);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican_hunter_3
  	
  repeat
  	begin_random
    	begin
				cs_shoot(true, ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1));
			end
			begin
				cs_shoot_point(true, pelican_hunters.p7);
			end
			begin
				cs_shoot_point(true, pelican_hunters.p2);
			end
			begin
				cs_shoot_point(true, pelican_hunters.p8);
			end
		end
	until(b_e9m3_dance_step == 5) or (ai_living_count(sq_e9m3_pelican_1) <= 0);
	ai_set_blind(ai_current_actor, true);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_marine1
	sleep(2);
	ai_vehicle_enter_immediate(ai_current_actor, ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1), "");
end

script command_script cs_e9m3_bishop_1
	cs_fly_to(bishops1.p0);
end

script command_script cs_e9m3_bishop_2
	cs_fly_to(bishops1.p1);
	cs_fly_to(bishops1.p2);
	cs_fly_to(bishops1.p3);
end

script command_script cs_e9m3_bishop_3
	cs_fly_to(bishops1.p4);
	cs_fly_to(bishops1.p5);
end

script command_script cs_e9m3_bishop_4
	cs_fly_to(bishops1.p6);
	cs_fly_to(bishops1.p7);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_e9m3_bishop_5
	cs_fly_to(bishops1.p8);
	cs_fly_to(bishops1.p23);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_e9m3_bishop_6
	cs_fly_to(bishops1.p9);
	cs_fly_to(bishops1.p4);
	cs_fly_to(bishops1.p5);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_e9m3_bishop_3a
	cs_fly_to(bishops1.p12);
	cs_fly_to(bishops1.p13);
end

script command_script cs_e9m3_bishop_3b
	cs_fly_to(bishops1.p11);
	cs_fly_to(bishops1.p14);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_e9m3_bishop_3b2
	cs_fly_to(bishops1.p10);
	cs_fly_to(bishops1.p16);
	cs_fly_to(bishops1.p17);
end

script command_script cs_e9m3_bishop_3c
	cs_fly_to(bishops1.p10);
	cs_fly_to(bishops1.p15);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_e9m3_bishop_3c2
	cs_fly_to(bishops1.p18);
	cs_fly_to(bishops1.p19);
	cs_fly_to(bishops1.p20);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_switchback_bishop_1
	cs_fly_to(bishops2.p0);
	cs_fly_to(bishops2.p1);
	cs_fly_to(bishops2.p2);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_switchback_bishop_2
	cs_fly_to(bishops2.p0);
	cs_fly_to(bishops2.p1);
end

script command_script cs_switchback_bishop_3
	cs_fly_to(bishops2.p3);
	cs_fly_to(bishops2.p4);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_switchback_bishop_4
	cs_fly_to(bishops2.p2);
end

script command_script cs_aerie_pawn_init
	cs_go_by(aerie.p0, aerie.p1, 4);
	cs_go_by(aerie.p1, aerie.p2, 4);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_aerie_pawn_init_2
	cs_go_by(aerie.p3, aerie.p1, 4);
	cs_go_by(aerie.p4, aerie.p2, 4);
	thread(f_e9m3_marine_magnet(ai_current_actor));
end

script command_script cs_aerie_bishop_1
	cs_fly_to(aerie.p5);
	ai_place_with_shards(sq_e9m3_ai_turret_5);
end

script command_script cs_bishop_ramp_1
	cs_fly_to(aerie.p6);
	cs_fly_to(aerie.p7);
end

script command_script cs_aerie_ghost_1
	cs_go_by(aerie.p8, aerie.p9, 3);
	cs_go_by(aerie.p10, aerie.p11, 3);
end

script command_script cs_aerie_ghost_2
	cs_go_by(aerie.p12, aerie.p13, 3);
	cs_go_by(aerie.p14, aerie.p6, 3);
	cs_go_by(aerie.p15, aerie.p5, 3);
end

script command_script cs_aerie_ghost_3
	cs_go_by(aerie.p16, aerie.p13, 3);
	cs_go_by(aerie.p13, aerie.p17, 3);
	cs_go_by(aerie.p18, aerie.p5, 3);
	cs_go_to(aerie.p19);
end

script command_script cs_aerie_bishop_loop_1
	cs_fly_to(aerie.p20);
end

script command_script cs_aerie_bishop_loop_2
	cs_fly_to(aerie.p21);
end

script command_script cs_aerie_bishop_loop_a
	cs_fly_to(aerie.p24);
	cs_fly_to(aerie.a);
end
script command_script cs_aerie_bishop_loop_b
	cs_fly_to(aerie.b);
end
script command_script cs_aerie_bishop_loop_c
	cs_fly_to(aerie.p24);
	cs_fly_to(aerie.c);
end
script command_script cs_aerie_bishop_loop_d
	cs_fly_to(aerie.p24);
	cs_fly_to(aerie.d);
end
script command_script cs_aerie_bishop_loop_e
	cs_fly_to(aerie.p24);
	cs_fly_to(aerie.p20);
	cs_fly_to(aerie.e);
end
script command_script cs_aerie_bishop_loop_f
	cs_fly_to(aerie.p24);
	cs_fly_to(aerie.f);
end

script command_script cs_aerie_bishop_2
	cs_fly_to(aerie.p22);
	cs_fly_to(aerie.p23);
	cs_fly_to(aerie.p5);
	if(ai_living_count(sq_e9m3_ai_turret_5) <= 0)then
		ai_place_with_shards(sq_e9m3_ai_turret_5);
		sleep(30);
	end
	if(ai_living_count(sq_e9m3_ai_turret_1) <= 0)then
		ai_place_with_shards(sq_e9m3_ai_turret_1);
		sleep(30);
	end
	if(ai_living_count(sq_e9m3_ai_turret_3) <= 0)then
		ai_place_with_shards(sq_e9m3_ai_turret_3);
	end
end

script command_script cs_e6m4_switchback_jumper_1
	cs_go_to_and_face(covenant.p0, covenant.p2);
	cs_jump(15, 4.0);
end

script command_script cs_e6m4_switchback_jumper_2
	cs_go_to_and_face(covenant.p1, covenant.p3);
	cs_jump(15, 3.5);
end

// 12-19-12
script command_script cs_e9m3_landing_cov
	cs_enable_targeting(true);
	cs_enable_looking(true);
	if(		(s_e9m3_scenario < 4)
		and (random_range(1, 3) == 2)
		)then
		cs_go_to(covenant.p4);																																// randomize so they don't all hug sides
	end
end

script command_script cs_e9m3_antitank_1
	if(s_e9m3_scenario >= 4)then
		cs_enable_targeting(true);
		cs_enable_looking(true);
		cs_jump(45, 7.5);
	end
end
/*
	vehicle_test_seat(vehicle(),"")
	
	object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")																	//works
	vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr"))												//works
	vehicle_test_seat(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")),"") 	//works
	vehicle_driver(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")))				//works
	unit_kill(vehicle_driver(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")))); //works
	
	
	
	ai_erase(object_get_ai(vehicle_driver(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr"))))) //works!!
	ai_erase(object_get_ai(vehicle_driver(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rl"))))) //works!!
	object_get_ai(vehicle_driver(vehicle(object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1), "pelican_g_rr")))) //works!!!
	
	// ai_vehicle_get_driver
	
	object_at_marker(ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_1.1), "chin_gun")
	
		if(	game_difficulty_get() == legendary)then
		ai_place_with_shards(e2m1_west_back_turret);
	end
	
*/


//		vo_glo15_miller_attaboy_04();
			// Miller : Nicely done.
			
//DestroyDynamicTask(l_shard_spawn_2); //at start of script, declare long // then below set  l_shard_spawn_2 = ai_place_with_shards(sq_e9m3_ai_turret_loop_c);

//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e9m3_scorpion_drop_mnde2836', ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1), 1 );
