//========= E9 M3 FIREFIGHT SCRIPT

// =============================================================================================================================
//=================== GLOBALS ==================================================================
// =============================================================================================================================

global boolean b_suppress_blips = false;
global short s_e9m3_scenario = 0;
	// 10 - landing 1 cleared of prometheans
	// 20 - transect combat complete, switchback objective initiated
	// 30 - past switchback landing, approaching gateyard
	// 40 - garrison battle initiated
	// 50 - garrison battle complete
global short b_e9m3_dance_step = 0;
global short s_e9m3_dogfight = 0;
global object obj_target = none;

script startup hillside_e9_m3()
	dprint( "hillside_e9_m3: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	//Wait for start
	if ( f_spops_mission_startup_wait("e9_m3_startup") ) then
		wake( e9_m3_hillside );
	end
end

script dormant e9_m3_hillside
	print ("******************STARTING e9_m3*********************");
	fade_out (0,0,0,1);
	// set standard mission init
	f_spops_mission_setup( "e9_m3_hillside", DEF_HILLSIDE_ZONESET_INDEX_E9M3, sg_e9m3_all, e9_m3_spawn_1, 90 );
	// putting this here to let the mission flow continue.  When we get cine_in can just set this after the intro is complete
	f_spops_mission_intro_complete( TRUE );

	//Start the intro
	firefight_mode_set_player_spawn_suppressed(true);																									//suppress the player from spawning during intro																												//start all the rest of the event scripts
//======== OBJECTS ==================================================================
	f_add_crate_folder(e9m3_blockers); 																																// blocks access
	f_add_crate_folder(e9m3_crates);
	f_add_crate_folder(e9_m3_spawn_1);
	
// set spawn folders
	firefight_mode_set_crate_folder_at(e9_m3_spawn_1, 90); 																						//spawns in the main starting area
	firefight_mode_set_crate_folder_at(e9_m3_spawn_landing_1, 91); 																		//spawns on landing 1
	firefight_mode_set_crate_folder_at(e9_m3_spawn_switchback, 92); 																	//spawns on switchback
	firefight_mode_set_crate_folder_at(e9_m3_spawn_garrison, 93); 																		//spawns at start of garrison
// set objectives
	firefight_mode_set_objective_name_at(dc_e9m3_switch_1,	1); 																			//computer terminal at first gate
	firefight_mode_set_objective_name_at(sc_switchback_landing,	2); 																	//switchback landing
	firefight_mode_set_objective_name_at(sc_gateyard,	3); 																						//gateyard landing
	firefight_mode_set_objective_name_at(sc_garrison,	4); 																						//garrison landing

// set squad groups
	firefight_mode_set_squad_at(sq_e9m3_shade_1, 21);																									// transect after landing 1
	firefight_mode_set_squad_at(sq_e9m3_bishops_switchback, 22);																			// switchback
	firefight_mode_set_squad_at(sq_e9m3_switchback_rangers, 23);																			// switchback
	firefight_mode_set_squad_at(sq_e9m3_phantom_3, 24);																								// gateyard

	// This will now allow everything to start spawning
	f_spops_mission_setup_complete( TRUE );	
	ai_allegiance(human, player);
	thread (f_start_all_events_e9_m3());			
	thread (f_start_events_e9_m3_1());																																//start the first starting event
end

script static void f_start_all_events_e9_m3
//start all the event scripts	
	print ("starting e9_m3 events");
	thread (f_e9m3_initial_dms());
	thread(f_e9m3_encounter_landing_1());
	thread(f_e9m3_begin_terrace());
	thread(f_e9m3_garrison_init());
	thread(f_e9m3_switchback_landing());
end

script static void f_e9m3_initial_dms
	sleep(15);
	f_add_crate_folder(e9m3_dms);
	sleep(10);
	f_terminal_setup(dm_e9m3_panel_1, dc_e9m3_switch_1);
	device_set_power(e9m3_dm1, 0);
	device_set_power(e9m3_dm2, 0);
	device_set_power(e9m3_dm3, 0);
	device_set_power(e9m3_dm4, 0);
end

//========STARTING E9 M3==============================


script static void f_start_events_e9_m3_1
	fade_out (0,0,0,1);
	//print("*********************** waiting for start_e9_m3_1");
	//sleep_until (LevelEventStatus("start_e9_m3_1"), 1);
	//print("*********************** start_e9_m3_1");
	
	if editor_mode() then
		firefight_mode_set_player_spawn_suppressed(false);
		sleep (2);
		fade_in (0,0,0,1);
		//f_e1_m2_intro_vignette();
		//b_wait_for_narrative = false;
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		f_blah_blah_intro_vignette();
		firefight_mode_set_player_spawn_suppressed(false);
		sleep_until (b_players_are_alive(), 1);	
		fade_in (0,0,0,30);
	end
	ai_place(sq_e9m3_pelican_1);
	f_add_crate_folder(e9m3_vehicles_init);
	ai_place(sq_e9m3_phantom_1);
end

script static void f_e9m3_encounter_1
	sleep(30);
	ai_place_in_limbo(sq_e9m3_pawns_1);
	ai_place_in_limbo(sq_e9m3_pawns_2);
	thread(f_e9m3_respawn_ghosts_1());
	thread(f_e9m3_respawn_pawns_1());
end

script static void f_e9m3_respawn_ghosts_1
	sleep_until(ai_living_count(sg_e9m3_ghosts) == 0);
	ai_place(sq_e9m3_ghost_3);
	ai_place(sq_e9m3_ghost_4);
end

script static void f_e9m3_respawn_pawns_1
	sleep_until(ai_living_count(sg_e9m3_pawns) <= 2);
	ai_place_in_limbo(sq_e9m3_pawns_1);
	ai_place_in_limbo(sq_e9m3_pawns_2);
end

script static void f_e9m3_encounter_landing_1
	sleep_until(volume_test_players (tv_landing_1), 1);
	ai_place(sq_e9m3_bishops_1);
	sleep(4);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_4, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_5, 3, 1));
	sleep_until((ai_living_count(sg_e9m3_bishops) + ai_living_count(sg_e9m3_pawns)) <= 1);
	ai_place(sq_e9m3_phantom_2);
	sleep_until(ai_living_count(sg_e9m3_bishops) == 0 and ai_living_count(sg_e9m3_pawns) <= 0);
	s_e9m3_scenario = 10;
	thread(f_e9m3_open_gate_1());
end

script static void f_e9m3_open_gate_1
	sleep_until(f_am_i_dead_yet(sq_e9m3_phantom_2));
	ai_place(sq_e9m3_pelican_2);																																			// spawn pelican to deliver backup scorpion
	f_terminal_run(dm_e9m3_panel_1, dc_e9m3_switch_1, true);																					// waits until terminal is accessed to return
	device_set_power(e9m3_dm1, 1);
//set new spawn points
end

script static void f_e9m3_begin_terrace
	sleep_until(LevelEventStatus("e9m3_gate1_open"), 1);
	ai_place(sq_e9m3_bishops_3a);
	ai_place(sq_e9m3_bishops_3b);
	ai_place(sq_e9m3_bishops_3c);
	ai_place(sq_e9m3_bishops_3d);
	sleep(4);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3a, 2, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3b, 2, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3c, 2, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_3d, 2, 1));
	sleep_until(	(ai_living_count(sg_e9m3_bishops) <= 0 or ai_living_count(sg_e9m3_ghosts) <= 0) and
								(ai_living_count(ai_ff_all) <= 15)
							);
	ai_place(sq_e9m3_phantom_2b);																																			// Pilot, 2xGunner, 2xGhosts
	sleep_until(	(ai_living_count(sq_e9m3_phantom_2b) <= 0 ) and
								(ai_living_count(ai_ff_all) <= 6)
							);
	s_e9m3_scenario = 20;
	b_end_player_goal = true;																																					//advance objectives (to switchback location arrival)
end

script static void f_e9m3_switchback_landing
	sleep_until(LevelEventStatus("e9m3_switchback"), 1);
	sleep(30);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_a, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_b, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_c, 3, 1));
	thread(f_e9m3_gateyard_approach());
end

script static void f_e9m3_gateyard_approach
	sleep_until(volume_test_players (tv_gateyard_approach), 1);
	s_e9m3_scenario = 30;
	ai_place(sq_e9m3_pelican_2a);
	ai_place(sq_e9m3_gateyard_elites);
	ai_place(sq_e9m3_shade_2);
end

script static void f_e9m3_garrison_init
	sleep_until(volume_test_players (tv_garrison_approach), 1);
	s_e9m3_scenario = 40;
	ai_place(sq_e9m3_shade_3);
	ai_place(sq_e9m3_garrison_elites_b);
	ai_place(sq_e9m3_garrison_grunts);
	sleep_until(ai_living_count(sg_e9m3_all) < 14);
	ai_place(sq_e9m3_garrison_elites_a);
	sleep_until(ai_living_count(sg_e9m3_all) < 8);
	ai_place(sq_e9m3_bishops_garrison_a);
	ai_place(sq_e9m3_bishops_garrison_b);
	sleep_until(ai_living_count(sg_e9m3_all) < 7);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_garrison_a, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_garrison_b, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_garrison_c, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_garrison_d, 3, 1));
	sleep(30 * 8);
	sleep_until(ai_living_count(sg_e9m3_all) < 3);
	thread(f_e9m3_aerie_init());
	s_e9m3_scenario = 50;
end

script static void f_e9m3_aerie_init
	ai_place(sq_e9m3_pelican_3);
	ai_place(sq_e9m3_pelican_4);
	ai_place(sq_e9m3_phantom_wraith_1);
	ai_place(sq_e9m3_phantom_wraith_2);
end

//=======ENDING E9 M3==============================

script static void f_e9m3_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end
//======= test fucntions

script static void set_switchback
	s_e9m3_scenario = 20;
	local short ff_mode = (5 - firefight_mode_goal_get());
	repeat
		b_end_player_goal = true;																																				//advance objectives (to switchback location arrival)
		ff_mode = ff_mode - 1;
		sleep(6);
		ai_erase(sg_e9m3_all);
	until(ff_mode == 0);
	sleep(5);
	ai_place(sq_e9m3_switchback_rangers);
	ai_place(sq_e9m3_bishops_switchback);
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_a, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_b, 3, 1));
	thread(f_shard_spawn_and_thread_respawner(sq_e9m3_pawns_switchback_c, 3, 1));
	thread(f_e9m3_gateyard_approach());
end

script static void set_gateyard
	s_e9m3_scenario = 30;
	local short ff_mode = (6 - firefight_mode_goal_get());
	repeat
		b_end_player_goal = true;																																				//advance objectives (to switchback location arrival)
		ff_mode = ff_mode - 1;
		sleep(6);
		ai_erase(sg_e9m3_all);
	until(ff_mode == 0);
	sleep(5);
	ai_place(sq_e9m3_gateyard_elites);
	ai_place(sq_e9m3_shade_2);
	ai_place(sq_e9m3_bishops_gateyard);
end

//====ancillary
// LOAD PAYLOAD: load 1 or 2 vehicles onto a Phantom

script static void f_e9_m3_load_playload (ai dropship, ai squad1)
	print ("spawning payload");
	ai_place_in_limbo  (squad1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_lc", ai_vehicle_get_from_squad(squad1, 0));
	print ("payload attached");
	ai_exit_limbo (squad1);
end
script static void f_e9_m3_load_playload (ai dropship, ai squad1, ai squad2)
	print ("spawning payload");
	ai_place_in_limbo  (squad1);
	ai_place_in_limbo  (squad2);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc01", ai_vehicle_get_from_squad(squad1, 0));
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_sc02", ai_vehicle_get_from_squad(squad2, 0));
	print ("payload attached");
	ai_exit_limbo (squad1);
	ai_exit_limbo (squad2);
end

script static boolean f_load_pelican (ai pelican, ai tank)
	print ("spawning payload");
	ai_place_in_limbo  (tank);
	sleep_until (ai_living_count (pelican) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(pelican, 0), "pelican_lc", ai_vehicle_get_from_squad(tank, 0));
	print ("payload attached");
	ai_exit_limbo (tank);
	true;
end

script static void f_shard_spawn_and_thread_respawner(ai pawns, short population, short population_threshold)
	ai_place_with_shards (pawns, population);
	sleep_until(f_am_i_alive_yet(pawns));
	thread(f_shard_respawner(pawns, population_threshold));
end

script static void f_shard_respawner(ai pawns, short population_threshold)
	sleep_until(ai_living_count(pawns) <= population_threshold);
	ai_place_with_shards(pawns);
end

script static void f_e9m3_shoot_me(object target)
	obj_target = target;
	ai_object_set_targeting_bias( obj_target, 1); 
end

script static void f_e9m3_dont_shoot_me()
	ai_object_set_targeting_bias( obj_target, 1); 
end

script static void f_terminal_setup (device dm, device dc)
	//onLevelLoaded, set and hide interface
	sleep(30 * 5);
	device_set_position_track( dm, 'device:position', 0 );
	sleep(10);
	device_animate_position (dm, 1, 2, 1, 0, 0);								// roll up
	sleep(10);
	object_hide(dm, true);
end

script static boolean f_terminal_run (device dm, device dc, boolean advance_player_goal)																					// assumes previous function was run
	object_hide(dm, false);
	sleep(2);
	device_animate_position (dm, 0, 2, 1, 0, 0);								// unfurl
	sleep_until(device_get_position(dm) <= .10);
	device_set_power(dc, 1);
	b_end_player_goal = advance_player_goal;																																					//advance objectives
	sleep_until(device_get_position(dc) == 1);									// switch flipped
	device_animate_position (dm, 1, 2, 1, 0, 0);								// roll up
	sleep_until(device_get_position(dm) == 1, 1);
	sleep(30 * 2);
	object_dissolve_from_marker(dm, phase_out, panel);
	true;
end

script static boolean f_am_i_dead_yet(ai me)
	sleep_until(ai_living_count(me) <= 0);
	true;
end

script static boolean f_am_i_alive_yet(ai me)
	sleep_until(ai_living_count(me) >= 1);
	true;
end

//====PHANTOM COMMAND SCRIPTS 

script command_script cs_e9m3_phantom1
	ai_set_blind (ai_current_squad, true);
	thread(f_e9_m3_load_playload(sq_e9m3_phantom_1, sq_e9m3_ghost_1, sq_e9m3_ghost_2));
	sleep(30 * 8);
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face(phantom1.p1, phantom1.face1);
	cs_fly_to_and_face(phantom1.p2, phantom1.face1);
	cs_fly_to_and_face(phantom1.p3, phantom1.face1);
	sleep(30);
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_1.1), "");
	sleep(30);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	cs_fly_to_and_face(phantom1.p0, phantom1.face1);
	cs_fly_to_and_face(phantom1.p4, phantom1.face1);
	cs_face_object(true, ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1));
	cs_shoot(true, sq_e9m3_pelican_1);
	sleep_until(b_e9m3_dance_step == 1, 1);
	cs_fly_to(phantom1.p3);
	b_e9m3_dance_step = 2;
	sleep_until(b_e9m3_dance_step == 3, 1);
	cs_fly_to(phantom1.p5);
	// hover til dead
end

script command_script cs_e9m3_phantom_2
	ai_set_blind (ai_current_squad, true);
	thread(f_e9_m3_load_playload(sq_e9m3_phantom_2, sq_e9m3_ghost_1, sq_e9m3_ghost_2));
	sleep(30 * 8);
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face(phantom2.p0, phantom2.face1);
	cs_fly_to_and_face(phantom2.p1, phantom2.face1);
	cs_fly_to_and_face(phantom2.p2, phantom2.face1);
	sleep(30);
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_2.1), "");
	sleep(30);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	repeat
		cs_fly_to_and_face(phantom2.p3, phantom2.face1);
		cs_fly_to_and_face(phantom2.p4, phantom2.face1);
	until(ai_living_count(sq_e9m3_phantom_2) == 0, 1);
	// hover til dead - will replace with "hover til gun is gone"
end

script command_script cs_e9m3_phantom_2b
	ai_set_blind (ai_current_squad, true);
	thread(f_e9_m3_load_playload(sq_e9m3_phantom_2b, sq_e9m3_ghost_3, sq_e9m3_ghost_4));
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face(phantom2.p0, phantom2.face1);
	cs_fly_to_and_face(phantom2.p1, phantom2.face1);
	cs_fly_to_and_face(phantom2.p5, phantom2.face1);
	sleep(30);
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_sc01");
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_sc02");
	sleep(30);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	repeat
		cs_fly_to_and_face(phantom2.p6, phantom2.face1);
		cs_fly_to_and_face(phantom2.p7, phantom2.face1);
	until(ai_living_count(sq_e9m3_phantom_2b) == 0, 1);
	// hover til dead - will replace with "hover til gun is gone"
end

script command_script cs_e9m3_phantom_3																															// gateyard
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face(phantom2.p8, phantom2.face2);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	cs_fly_to_and_face(phantom2.p9, phantom2.face3);
	cs_fly_to_and_face(phantom2.p10, phantom2.face2);
	cs_fly_to_and_face(phantom2.p11, phantom2.face4);
	cs_fly_to_and_face(phantom2.p12, phantom2.face2);
	cs_fly_to_and_face(phantom2.p10, phantom2.face5);
	repeat
		cs_fly_to_and_face(phantom2.p12, phantom2.face5);
		cs_fly_to_and_face(phantom2.p10, phantom2.face5);
		cs_fly_to_and_face(phantom2.p13, phantom2.face5);
		cs_fly_to_and_face(phantom2.p10, phantom2.face5);
		cs_fly_to_and_face(phantom2.p11, phantom2.face5);
	until(ai_living_count(sq_e9m3_phantom_3) == 0, 1);
	// hover til dead - will replace with "hover til gun is gone"
end

script command_script cs_e9m3_phantom_wraith_1																															// post-garrison
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	f_e9_m3_load_playload( sq_e9m3_phantom_wraith_1, sq_e9m3_wraith_1 );
	cs_fly_to_and_face(phantom2.p8, phantom2.face2);
	cs_fly_to_and_face(phantom2.p9, phantom2.face3);
	cs_fly_to_and_face(phantom2.p10, phantom2.face2);
	cs_fly_to_and_face(phantom2.p11, phantom2.face4);
	sleep(30);
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_lc");
	sleep(30);
	cs_fly_to_and_face(phantom2.p11, phantom2.face6);
	cs_fly_to_and_face(phantom2.p11, phantom2.face5);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	cs_fly_to_and_face(phantom2.p14, phantom2.face7);
	//dogfight
	cs_fly_to_and_face(dogfight.p0, dogfight.face1, 1);																							
	sleep_until(s_e9m3_dogfight == 1);
	cs_fly_to_and_face(dogfight.p2, dogfight.face1, 1);
end

script command_script cs_e9m3_phantom_wraith_2																															// post-garrison
	ai_set_blind (ai_current_squad, true);
	cs_ignore_obstacles (TRUE);
	f_e9_m3_load_playload( sq_e9m3_phantom_wraith_2, sq_e9m3_wraith_2 );
	cs_fly_to_and_face(phantom2.p16, phantom2.face10);
	cs_fly_to_and_face(phantom2.p17, phantom2.face10);
	cs_fly_to_and_face(phantom2.p17, phantom2.face4);
	cs_fly_to_and_face(phantom2.p18, phantom2.face4);
	sleep(30);
	vehicle_unload(unit_get_vehicle(ai_current_actor), "phantom_lc");
	sleep(30);
	cs_fly_to_and_face(phantom2.p17, phantom2.face7);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	cs_fly_to_and_face(phantom2.p11, phantom2.face5);
	cs_fly_to_and_face(phantom2.p14, phantom2.face7);
	cs_fly_to_and_face(phantom2.p15, phantom2.face8);
end

//====PELICAN
script command_script cs_e9m3_pelican1																															//pelican
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	sleep(15);
	cs_fly_to_and_face(pelican1.p0, pelican1.face1, 1);																								//pelican
	thread(f_e9m3_encounter_1());
	cs_fly_to_and_face(pelican1.p1, pelican1.face1, 1);
	cs_vehicle_speed(.5);
	sleep(13);
	cs_fly_to_and_face(pelican1.p2, pelican1.face1, 1);
	object_cannot_take_damage(ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1));
	ai_set_blind (ai_current_squad, false);
	cs_enable_looking(true);
	cs_enable_targeting(true);
	cs_shoot(true);
	cs_fly_to_and_face(pelican1.p2, pelican1.face4, 1);
	sleep(30);
	thread(f_e9m3_shoot_me(ai_current_actor));
	cs_fly_to_and_face(pelican1.p4, pelican1.face4, 1);
	cs_vehicle_speed(1);
	cs_fly_to_and_face(pelican1.p5, pelican1.face6, 1);
	sleep(30);
	cs_fly_to_and_face(pelican1.p5, pelican1.face3, 1);																								//pelican
	sleep(30);
	cs_fly_to_and_face(pelican1.p4, pelican1.face3, 1);
	sleep(30 * 2);
	cs_face_object(true, ai_vehicle_get_from_spawn_point (sq_e9m3_phantom_1.1));
	cs_fly_to(pelican1.p6);
	thread(f_e9m3_dont_shoot_me());
	cs_fly_to(pelican1.p7);
	b_e9m3_dance_step = 1;
	cs_fly_to(pelican1.p8);
	sleep_until(b_e9m3_dance_step == 2, 1, 30 * 8);
	cs_fly_to(pelican1.p9);
	b_e9m3_dance_step = 3;
	repeat																																														//pelican
		
		local short s_pos = random_range(1, 2);
		
		cs_fly_to(pelican1.p10);
		cs_vehicle_speed(.1 * random_range(2, 10));
		sleep(30 * (random_range(1, 4)));
		cs_vehicle_speed(.1 * random_range(2, 10));
		cs_fly_to(pelican1.p9);
		if(s_pos == 1)then
			cs_fly_to(pelican1.p8);
			sleep(30 * (random_range(1, 4)));																															//pelican
			cs_fly_to(pelican1.p9);
		else
			cs_fly_to(pelican1.p10);
		end
	until(ai_living_count(sq_e9m3_phantom_1) == 0, 1);
	
	cs_vehicle_speed(1);
	cs_fly_to_and_face(pelican1.p11, pelican1.face3, 1);
	cs_fly_to_and_face(pelican1.p12, pelican1.look7, 1);																							//pelican
	cs_fly_to_and_face(pelican1.p13, pelican1.look8, 1);
	cs_fly_to_and_face(pelican1.p14, pelican1.look8, 1);
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_1.1));
	ai_erase(sq_e9m3_pelican_1.2);
	ai_erase(sq_e9m3_pelican_1.3);
	ai_erase(sq_e9m3_pelican_1.4);
	ai_erase(ai_current_actor);
	
end																																																	//pelican /end

script command_script cs_e9m3_pelican2
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	sleep(15);
	f_load_pelican (sq_e9m3_pelican_2, sq_e9m3_scorpion_1);
	cs_fly_to_and_face(pelican2.p0, pelican2.face1, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p1, pelican2.face2, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p2, pelican2.face2, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p3, pelican2.face3, 1);																								//pelican2
	sleep_until(volume_test_players(tv_landing_lz) == false, 1);
	cs_fly_to_and_face(pelican2.p4, pelican2.face3, 1);																								//pelican2
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2.1), "pelican_lc");
	sleep(30);
	cs_fly_to_and_face(pelican2.p3, pelican2.face3, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p2, pelican2.face4, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p1, pelican2.face4, 1);																								//pelican2
	cs_fly_to_and_face(pelican2.p0, pelican2.face5, 1);																								//pelican2
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2.1));
	ai_erase(sq_e9m3_pelican_2.2);
	ai_erase(sq_e9m3_pelican_2.3);
	ai_erase(sq_e9m3_pelican_2.4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican2a
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	sleep(15);
	f_load_pelican (sq_e9m3_pelican_2a, sq_e9m3_scorpion_2);
	cs_fly_to_and_face(pelican2.p0, pelican2.face1, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p1, pelican2.face2, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p2, pelican2.face2, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p5, pelican2.face3, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p6, pelican2.face3, 1);																								//pelican2a
	sleep_until(volume_test_players(tv_switchback) == false, 1);
	cs_fly_to_and_face(pelican2.p7, pelican2.face3, 1);																								//pelican2a
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2a.1), "pelican_lc");
	sleep(30);
	cs_fly_to_and_face(pelican2.p6, pelican2.face3, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p5, pelican2.face4, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p2, pelican2.face4, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p1, pelican2.face4, 1);																								//pelican2a
	cs_fly_to_and_face(pelican2.p0, pelican2.face5, 1);																								//pelican2a
	
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_2a.1));
	ai_erase(sq_e9m3_pelican_2a.2);
	ai_erase(sq_e9m3_pelican_2a.3);
	ai_erase(sq_e9m3_pelican_2a.4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican3
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	sleep(15);
	f_load_pelican (sq_e9m3_pelican_3, sq_e9m3_scorpion_3);
	cs_fly_to_and_face(pelicans.p0, pelicans.face1, 1);																								//pelican3
	cs_fly_to_and_face(pelicans.p1, pelicans.face1, 1);																								//pelican3
	cs_fly_to_and_face(pelicans.p2, pelicans.face1, 1);																								//pelican3
	cs_fly_to_and_face(pelicans.p3, pelicans.face3, 1);																								//pelican3
	sleep(30 * 5);
	cs_fly_to_and_face(pelicans.p9, pelicans.face2, 1);																								//pelican3
	sleep_until(volume_test_players(tv_garrison_rear_lz) == false, 1);
	cs_fly_to_and_face(pelicans.p10, pelicans.face3, 1);																							//pelican3
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1), "pelican_lc");
	sleep(30);



	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);

	sleep(30 * 5);
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_3.1));
	ai_erase(sq_e9m3_pelican_3.2);
	ai_erase(sq_e9m3_pelican_3.3);
	ai_erase(sq_e9m3_pelican_3.4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_pelican4
	ai_set_blind (ai_current_squad, TRUE);
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(1);																																							
	
	sleep(15);
	f_load_pelican (sq_e9m3_pelican_4, sq_e9m3_scorpion_4);
	cs_fly_to_and_face(pelicans.p4, pelicans.face1, 1);																								//pelican4
	cs_fly_to_and_face(pelicans.p5, pelicans.face1, 1);																								//pelican4
	cs_fly_to_and_face(pelicans.p6, pelicans.face2, 1);																								//pelican4
	cs_fly_to_and_face(pelicans.p7, pelicans.face2, 1);																								//pelican4
	sleep_until(volume_test_players(tv_garrison_front_lz) == false, 1);
	cs_fly_to_and_face(pelicans.p8, pelicans.face2, 1);																								//pelican4
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1), "pelican_lc");
	sleep(30);
	ai_set_blind (ai_current_squad, false);
	cs_enable_targeting(true);
	cs_fly_to_and_face(pelicans.p11, pelicans.face3, 1);																							//pelican4
	cs_fly_to_and_face(pelicans.p11, pelicans.face4, 1);																							//pelican4
	sleep(30 * 5);
	cs_fly_to_and_face(pelicans.p12, pelicans.face4, 1);																							//pelican4
	//dogfight
	cs_fly_to_and_face(dogfight.p1, dogfight.face1, 1);																							//pelican4
	s_e9m3_dogfight = 1;
	sleep(30 * 1.5);
	cs_fly_to_and_face(dogfight.p3, dogfight.face2, 1);																							//pelican4
	sleep(30 * 5);
	
	
	sleep(30 * 5);
	object_destroy(	ai_vehicle_get_from_spawn_point (sq_e9m3_pelican_4.1));
	ai_erase(sq_e9m3_pelican_4.2);
	ai_erase(sq_e9m3_pelican_4.3);
	ai_erase(sq_e9m3_pelican_4.4);
	ai_erase(ai_current_actor);
end

script command_script cs_e9m3_scorpion1
	sleep_until(		volume_test_object(tv_landing_lz, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_switchback, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_garrison_front_lz, ai_get_object(ai_current_actor)) or
									volume_test_object(tv_garrison_rear_lz, ai_get_object(ai_current_actor)) 
							);
	sleep(30 * 2);
	ai_vehicle_exit(ai_current_actor);
end


//====ai command scripts
script command_script cs_e9m3_phase_in
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep(20);
	ai_exit_limbo(ai_current_actor);
end

script command_script cs_e9m3_marine1
	sleep(2);
	ai_vehicle_enter_immediate(ai_current_actor, ai_vehicle_get_from_spawn_point(sq_e9m3_pelican_1.1), "");
end

script command_script cs_e9m3_bishop_1
	cs_fly_to(bishops1.p0);
	cs_fly_to(bishops1.p1);
end

script command_script cs_e9m3_bishop_2
	cs_fly_to(bishops1.p2);
	cs_fly_to(bishops1.p3);
end

script command_script cs_e9m3_bishop_3
	cs_fly_to(bishops1.p4);
	cs_fly_to(bishops1.p5);
	sleep(30 * 2);
	cs_fly_to(bishops1.p6);
end


