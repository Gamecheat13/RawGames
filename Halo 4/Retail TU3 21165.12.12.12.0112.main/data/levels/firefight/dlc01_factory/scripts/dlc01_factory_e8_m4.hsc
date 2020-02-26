////===========================================================================================================================
//============================================ FORERUNNER STRUCTURE e8_m4 FIREFIGHT SCRIPT ==================================================
//=============================================================================================================================
//startup the mission

  global object g_e8m4_ics_player = none;

  global boolean b_e8_m4_pelican_flyaway = FALSE;
  global boolean b_e8_m4_pelican2_flyaway = FALSE;
  global boolean b_e8_m4_pelican3_flyaway = FALSE;
  global boolean b_e8_m4_pelican2_3_Evac = FALSE;
  global boolean b_e8_m4_pelican2_3_landed = FALSE;
  global boolean b_e8_m4_pelican4_3_suspend = FALSE;
  global boolean b_e8_m4_pelican4_start = FALSE;
  global boolean b_e8_m4_phantom_2_done = FALSE;
  global boolean b_e8_m4_internal_breached = FALSE;
  global boolean b_donut_mid_doors_open  = FALSE;
  global boolean b_mid_jammer_done  = FALSE;
  global boolean b_back_jammer = FALSE;
  global boolean b_front_jammer = FALSE;
  global boolean b_phantom_diamond = FALSE;
  global boolean b_e8_m4_stop_firing = FALSE;
  global boolean b_e8_m4_phantom1_done = FALSE;
  global boolean b_e8_m4_phantom2_done = FALSE;
  global boolean b_e8_m4_phantom3_done = FALSE;
  global boolean b_e8_m4_phantom4_done = FALSE;
  global boolean b_e8_m4_phantom5_done = FALSE;
  global boolean b_e8_m4_phantom_1_started = FALSE;
  global boolean b_e8_m4_phantom_2_started = FALSE;
  global boolean b_e8_m4_phantom_3_started = FALSE;
  global boolean b_e8_m4_phantom_5_started = FALSE;
	//global boolean b_e8_m4_landing_party_left_done = FALSE;  -------------------------xxxxdelete if no errors
  //global boolean b_e8_m4_landing_party_right_done = FALSE; -------------------------xxxxdelete if no errors
  //global boolean b_landing_party_over = FALSE; -------------------------xxxxdelete if no errors
  //global boolean b_e8m4_narrative_is_on = FALSE;
  global boolean b_e8_m4_switch5_done = FALSE;
  global boolean b_e8_m4_switch6_done = FALSE;
  global boolean b_e8_m4_switch7_done = FALSE;
  global boolean b_e8_m4_switch8_done = FALSE;
  global boolean b_e8_m4_phantom6_done = FALSE;
  global boolean b_e8_m4_phantom_6_started = FALSE;
  global boolean b_e8_m4_phantom_1_unloaded  = FALSE;
  global boolean b_e8_m4_phantom_2_unloaded = FALSE;
  global boolean b_e8_m4_phantom_3_unloaded = FALSE;
  global boolean b_e8_m4_phantom_5_unloaded = FALSE;
  global boolean b_e8_m4_phantom_6_unloaded = FALSE;
  global boolean b_drop_pods_deployed = FALSE;
  global boolean b_e8_m4_phantom1_destoyed = FALSE;
  global boolean b_e8_m4_phantom6_destroyed = FALSE;
  global boolean b_e8_m4_phantom_2_destroyed = FALSE;
  global boolean b_e8_m4_zone_swapped = FALSE;
  global boolean b_e8_m4_diamond_open = FALSE;
  global boolean b_e8_m4_jammers_activate = FALSE;
  global boolean b_e8m4_hunters_landed = FALSE;
  
  global real r_e8_m4_jammers_destroyed = 0;
  global real r_e8_m4_switches_on = 0;
  global real r_e8_m4_switches_phantoms = 0;
  global real r_e8_m4_switch_vo_played = 0;

	global short s_e8m4_scenario_state = 0;
	//----- s_e8m4_scenario_state:  ---------------------------
	// 			5 = right flank closing in on player
	// 			10 = init encounter complete

script startup dlc01_factory_e8_m4
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("is_e8_m4") ) then
		wake( dlc01_factory_e8_m4_init );
	end

end

script dormant dlc01_factory_e8_m4_init
print ("******************20/11/2012 11:02:33 AM*******************");

	f_spops_mission_setup( "is_e8_m4", e8_m4_narrative, gr_e8_m4_ff_all, sc_e8_m4_spawn_points_0, 91 );
	dm_droppod_1 = e6_m1_drop_pod_1;				
	dm_droppod_2 = e6_m1_drop_pod_2;
	dm_droppod_3 = e6_m1_drop_pod_3;
	thread(f_start_player_intro_e8_m4());
	thread (f_start_all_events_e8_m4());
	thread (e8m4_start_mission());
	
//================================================== OBJECTS ===================================================================
//set crate names
	
	f_add_crate_folder(e8m4_equip);	
	f_add_crate_folder(e8_m4_drop_rails);	
	f_add_crate_folder(sc_e8_m4_doors);	
	f_add_crate_folder(dc_e8_m4_switches);
	//f_add_crate_folder(we_e8_m4_factory);
	f_add_crate_folder(v_e8_m4_vehicles);
	f_add_crate_folder(e8_m4_cov_crates);
	//f_add_crate_folder(e8_m4_donut_scenery);
	f_add_crate_folder(e8_m4_door_buttons);
	f_add_crate_folder(dm_e8_m4_cover);
	f_add_crate_folder(e8_m4_cov_wep_rack);
//	f_add_crate_folder(sc_e8_m4_beams);
	f_add_crate_folder(dm_doors);
	f_add_crate_folder(sc_e8_m4_lz);
	f_add_crate_folder(dg_e8_m4_switchgrp);
	f_add_crate_folder(sc_e8_m4_pelican);


//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_0, 91);   																//initial player spawns, on pad in internal
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_1, 92);   																//not in use anymore
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_2, 93);   																//spawns by hallway door in internal
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_3, 94);   																//spawns at entry of donut out of hallway
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_4, 95);   																//spawns at beginning of ramp from donut to diamond
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_5, 96);   																//spawns at end of ramp in diamond
	firefight_mode_set_crate_folder_at(sc_e8_m4_spawn_points_6, 97);   																//spawns at top of ramp
//set objective index associations
	firefight_mode_set_objective_name_at(lz_1, 60); 																									//objective escape to the runway	
	firefight_mode_set_objective_name_at(lz_2, 61); 																									//objective escape to the runway	
	firefight_mode_set_objective_name_at(lz_3, 62); 																									//objective escape to the runway	
	firefight_mode_set_objective_name_at(lz_4, 63); 																									//objective escape to the runway	
	firefight_mode_set_objective_name_at(lz_5, 64); 																									//objective escape to the runway	
	firefight_mode_set_objective_name_at(lz_6, 65); 																									//objective escape to the runway	


	firefight_mode_set_objective_name_at(dc_e8_m4_switch1, 67); //objective Lower Fence
	firefight_mode_set_objective_name_at(dc_e8_m4_switch2, 68); //objective escape to runway LZ
	//firefight_mode_set_objective_name_at(dc_e8_m4_switch3, 69); //objective escape to runway LZ
	//firefight_mode_set_objective_name_at(dc_e8_m4_switch4, 40); //objective escape to runway LZ
	firefight_mode_set_objective_name_at(e8_m4_jammer_1, 41); //jammer
	firefight_mode_set_objective_name_at(e8_m4_jammer_2, 42); //jammer
	firefight_mode_set_objective_name_at(e8_m4_jammer_3, 43); //jammer
	//firefight_mode_set_objective_name_at(e8_m4_jammer_4, 44); //jammer
	firefight_mode_set_objective_name_at(dc_e8_m4_switch5, 45); //swith for tractor beam
	firefight_mode_set_objective_name_at(dc_e8_m4_switch6, 46); //swith for tractor beam
	firefight_mode_set_objective_name_at(dc_e8_m4_switch7, 47); //swith for tractor beam
	firefight_mode_set_objective_name_at(dc_e8_m4_switch8, 48); //swith for tractor beam


//guards
	firefight_mode_set_squad_at(sq_e8_m4_marines_1, 101);	
	firefight_mode_set_squad_at(sq_e8_m4_null_pelican_driver, 102);	
	firefight_mode_set_squad_at(sq_e8_m4_factory_ghosts1, 103);	
	firefight_mode_set_squad_at(sq_e8_m4_factory_ghosts2, 104);	
	
	// ==== tjp - these are actually being used in bonobo:
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_5, 55);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_6, 56);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_7, 57);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_9, 59);
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_10, 70);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_14, 74);
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_21, 82);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_22, 83);	
	firefight_mode_set_squad_at(sq_e8_m4_bonobo_35, 84);	
	firefight_mode_set_squad_at(sq_e8_m4_wraith_1, 105);	
	firefight_mode_set_squad_at(sq_e8_m4_wraith_2, 106);	

	firefight_mode_set_squad_at(sq_e8_m4_factory_ghosts3, 107);	
	firefight_mode_set_squad_at(sq_e8_m4_phantom_1, 108);	
	firefight_mode_set_squad_at(sq_e8_m4_phantom_2, 110);	
	//firefight_mode_set_squad_at(sq_e8_m4_null_pelican_driver2, 111);	
	firefight_mode_set_squad_at(sq_e8_m4_tracer, 112);	
	firefight_mode_set_squad_at(sq_e8_m4_phantom_3, 113);	
	firefight_mode_set_squad_at(sq_e8_m4_null_pelican_driver4, 114);	// 115 used
	
	f_add_crate_folder(e8m4_loose_weapons);	
	
	f_spops_mission_setup_complete( TRUE );        
end


//=========== MAIN SCRIPT STARTS - Threads ==================================================================

script static void f_start_all_events_e8_m4
	sleep_until (b_players_are_alive(), 1);
	
	thread (f_end_mission_e8_m4());	
	thread(f_e8_m4_obj1_txt());																		
	thread(f_e8_m4_obj2_txt());															
	thread(f_e8_m4_obj3_txt());
	thread(f_e8_m4_obj4_txt());
	thread(f_e8_m4_obj6_txt());	
	thread(f_e8m4_diamond_start());
	//thread(f_door_interior_d_e8_m4_1());	
	//thread(f_door_hallway_a_e8_m4_1());	
	thread(f_door_donut_a_e8_m4_1());	
	thread(f_door_diamond_a_e8_m4_1());	
	thread(f_start_diamond_pelicans_e8_m4());	
	thread(f_door_diamond_b_e8_m4_1());	
	thread(f_attach_buttons_e8_m4());		
	thread(f_vol_ghosts_diamond_e8_m4());	
	thread(f_e8_m4_obj7_txt());	
	thread(f_e8m4_switches_on());	
	thread(f_e8_m4_lzdr_switch_on());	
	thread(f_start_e8_m4_get_to_lz());	
	thread(f_e8_m4_phantoms_inbound());	
	thread(f_e8_m1_jammermid());	
	thread(f_e8_m1_jammerback());	
	thread(f_e8_m1_jammerfront());	
	thread(f_attach_button2_e8_m4());	
	thread(f_e8_m1_jammer_count());	
	thread(f_start_e8_m4_elite_suprise());	
	thread(f_e8_m4_obj5a_txt());
	thread(f_music_e08m4_start());
	thread(f_music_e08m4_narr_in());
	thread(f_e8_m4_switch_vo_counter()); //74vo
	thread(f_e8m4_nohurtfriendlyvehicles());
end



//==============================================================================================================================
//================================================== MISSION START AND END=============================================================
//==============================================================================================================================
/*script static void f_e8_m4_start_level  //START LEVEL
	sleep_until (LevelEventStatus("e8_m4_start_level"), 1);
	print ("START start_mission");
	sleep_until( f_spops_mission_start_complete(), 1 );		
	
end*/
script static void e8m4_start_mission  																										//fired from bonobo
	sleep_until (LevelEventStatus("e8_m4_start_level"), 1);
	print ("START start_mission");
	sleep_until( f_spops_mission_start_complete(), 1 );		
	print ("Players Spawned!");	
	print ("20/11/2012 12:54:30 PM");	
	//sleep_s(1);	
	b_end_player_goal = TRUE;  																															// ends first objective

end

script static void f_start_player_intro_e8_m4  																						//SPOPS LOADING
	
	sleep_until (f_spops_mission_ready_complete(), 1);
	firefight_mode_set_player_spawn_suppressed(true);																				//prevents player spawn untill everything else is loaded
	if editor_mode() then
		sleep_s (1);
//		intro_vignette_e8_m4();														//tjp
	else
		sleep_until (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		intro_vignette_e8_m4();
	end
	f_e8_m4_zone_swap_narrative(); 																													//adding the zone swap at the end of the show	
	sleep(2);
	ai_place(sq_e8m4_init_right);
	ai_place(sq_e8m4_init_left);
	ai_place(sq_e8m4_init_reinf);
	ai_braindead(sq_e8m4_init_reinf, true);
	firefight_mode_set_player_spawn_suppressed(false);
	f_spops_mission_intro_complete( TRUE );
	sleep_until (b_players_are_alive(), 1);
	b_e8_m4_pelican_flyaway = TRUE;
	ai_place("sq_e8_m4_marines_1");
	ai_place(sq_e8_m4_null_pelican_driver);	
	ai_object_set_targeting_bias(sq_e8_m4_null_pelican_driver, 1);
	fade_in (0,0,0,200);
	thread (e8m4_secure_area()); 	//vo_e8m4_onto_platform();
 			// Palmer : Weapons hot.
	print ("========================================HUZZAH222222!!!");
	//f_spops_mission_intro_complete( TRUE );
	sleep_s(4);
	thread(f_e8_m4_landing_party1());	
  thread(f_e8_m4_switches_off());
  sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 3, 1); 
  b_end_player_goal = true;
end


script static void intro_vignette_e8_m4()
	ai_enter_limbo (gr_e8_m4_ff_all);	
	pup_disable_splitscreen (true);														//tjp				
	local long show = pup_play_show(e8_m4_intro);							//tjp
	sleep_until (not pup_is_playing(show), 1);								//tjp
	pup_disable_splitscreen (false);													//tjp
	ai_exit_limbo (gr_e8_m4_ff_all);	
	//thread(e8m4_vo_packagedelivery());
	// DIALOG: MURPHY Infinity, package is delivered.
	// DIALOG:  PALMER:  Clear out that LZ, Crimson. Once you push inside, the last thing you'll want is uglies creeping up on your six.

end

//script static void intro_audio_vignette_e8_m4()  // sleep for 2 then play the audio in the pupshow
	//sleep_s(2);
	//end


script static void f_end_mission_e8_m4   //END MISSION
		sleep_until (LevelEventStatus("e8_m4_mission_end"), 1);
		sleep_until(b_e8_m4_pelican2_3_landed == TRUE, 1);	
		ai_enter_limbo (ai_ff_all);				
		thread(f_music_e08m4_finish());													//tjp
		pup_disable_splitscreen (true);													//tjp
		ai_erase_all();
		object_hide(player0, true);
		object_hide(player1, true);
		object_hide(player2, true);
		object_hide(player3, true);
		player_control_fade_out_all_input (.1);
		chud_show(false);
		hud_show_navpoints (false);
		thread(e8_m4_vo_end_mission());
		
		local long show = pup_play_show(e8_m4_outro);						//tjp
		sleep_until (not pup_is_playing(show), 1);							//tjp
		pup_disable_splitscreen (false);	
	
		fade_out(0, 0, 0, 1); 
		cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);	
		b_end_player_goal = true;	
end


//=====================================ZONE SET SWAPS===========================================


script static void f_e8_m4_zone_swap_1
	print ("STARTING e8_m4_zone_swap_1");

	//sleep_s (3);
	print ("preparing to switch zone set");  //preparing to switch zone set, look for bad popping
	prepare_to_switch_to_zone_set (e8_m4_1);
	sleep_s (5);
	print ("sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print ("switching zone set");
	switch_zone_set (e8_m4_1);  // here we go!!
	f_add_crate_folder(e8_cov_crates_donut);
	f_add_crate_folder(v_e8_m4_vehicles);
	current_zone_set_fully_active();
	b_e8_m4_zone_swapped = true;	//returning to setup
	f_add_crate_folder(sc_e8_m4_pelican);
	f_add_crate_folder(sc_e8_m4_doors);	
	sleep(20);
	object_cannot_take_damage(e8_m4_capped_pelican);
end

script static void f_e8m4_remove_marines
	sleep_until(	 	(not volume_test_players_lookat (e8_m4_marines_look_vol, 20, 20))
							or	(ai_living_count(sq_e8_m4_marines_1) == 0)
							, 1);
	if	(ai_living_count(sq_e8_m4_marines_1) > 0)	then
		ai_erase(sq_e8_m4_marines_1); 
	end
end

script static void f_e8_m4_zone_swap_narrative
	print ("STARTINGe8_m4_zone_swap_narrative");   
	print ("preparing to switch zone set");  //preparing to switch zone set, look for bad popping
	prepare_to_switch_to_zone_set (e8_m4);
	sleep_s (1);
	print ("sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print ("switching zone set");
	switch_zone_set (e8_m4);  // here we go!!
	current_zone_set_fully_active();
	f_add_crate_folder(sc_e8_m4_doors);	

end
script static void f_e8m4_diamond_start
	sleep_until (LevelEventStatus("e8_m4_switches_off"), 1);
	if	(	list_count(players()) >= 2)	then
		ai_place(sq_e8_m4_wraith_2);
	end
end

script static void f_e8m4_cover
	sleep_until(volume_test_players("vol_lz_3") == true, 1);
	device_set_power(dm_e8m4_door_cover_1,1);
	device_set_power(dm_e8m4_door_cover_2,1);
	sleep_until(volume_test_players(tv_e8m4_cover), 1);
	device_set_power(dm_e8m4_floor_cover_1,1);
	device_set_power(dm_e8m4_floor_cover_2,1);
	device_set_power(dm_e8m4_floor_cover_3,1);
	f_create_new_spawn_folder (97);
	thread(e8_m4_vo_bird());
end

//======================================PELICAN STUFF================================================


script static void f_start_diamond_pelicans_e8_m4
	sleep_until (LevelEventStatus("e8_m4_Evac_Pelicans"),1);
	b_e8_m4_pelican2_flyaway = TRUE;
	b_e8_m4_pelican3_flyaway = TRUE;
	sleep_s(2);
	ai_place(sq_e8_m4_tracer);
	f_unblip_ai_cui(sq_e8_m4_tracer);
	sleep(5);
end


script command_script cs_e8_m4_pelican_drop_1   // FIrst Drop off Pelicans
	sleep_until(b_e8_m4_pelican_flyaway == TRUE, 1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	cs_fly_to_and_face(e8_m4_pelican_1_pts.p0,e8_m4_pelican_1_pts.p1);						//			fly to the following point, then face the next one
	cs_fly_to(e8_m4_pelican_1_pts.p2);	
	//sleep_s(10);																							//			fly to points
	cs_fly_to(e8_m4_pelican_1_pts.p3); 
	//cs_vehicle_speed_instantaneous(ai_current_actor, 2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 500 ); //Shrink size over time
	cs_fly_to(e8_m4_pelican_1_pts.p4); 
	ai_erase(ai_current_actor);																																	//delete the pilot, leaves behind pelican unfortunately
	object_destroy(unit_get_vehicle (sq_e8_m4_null_pelican_driver));		
													
end


/*script command_script cs_e8_m4_pelican_drop_2    // Fly by  pelican - cannot land due to forerunner guns
	sleep_until(b_e8_m4_pelican2_flyaway == TRUE, 1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);
	//cs_fly_to_and_face(e8_m4_pelican_2_pts.p0,e8_m4_pelican_2_pts.p1);						//			fly to the following point, then face the next one
	cs_vehicle_speed_instantaneous(ai_current_actor, 2);
	cs_fly_to(e8_m4_pelican_2_pts.p2);																							//			fly to points
	cs_fly_to(e8_m4_pelican_2_pts.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01,200 ); //Shrink size over time
	cs_fly_to(e8_m4_pelican_2_pts.p4);
	ai_erase(ai_current_actor);																																	//delete the pilot, leaves behind pelican unfortunately
	object_destroy(unit_get_vehicle (sq_e8_m4_null_pelican_driver));			
	end



script command_script cs_e8_m4_pelican_drop_3  // Fly by  pelican - cannot land due to forerunner guns
	sleep_until(b_e8_m4_pelican3_flyaway == TRUE, 1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);															//			fly to the following point, then face the next one
	cs_vehicle_speed_instantaneous(ai_current_actor, 2);
	cs_fly_to(e8_m4_pelican_1_pts.p2);	
	cs_fly_to(e8_m4_pelican_3_pts.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 200 ); //Shrink size over time
	cs_fly_to(e8_m4_pelican_3_pts.p4);
	ai_erase(ai_current_actor);																																	//delete the pilot, leaves behind pelican unfortunately
	object_destroy(unit_get_vehicle (sq_e8_m4_null_pelican_driver));																//delete the pelican so it doesnt look silly (empty pelican falling to ground)
	end*/

script command_script cs_e8_m4_pelican_drop_4     // END PELICAN 1
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	sleep_until(b_e8_m4_pelican2_3_Evac == true, 1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	cs_fly_to(e8_m4_pelican_2_pts.p5);		
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 200 );  //bigger size over time
	cs_vehicle_speed_instantaneous(ai_current_actor, 1);	
	cs_fly_to(e8_m4_pelican_2_pts.p6);
	cs_fly_to(e8_m4_pelican_2_pts.p7);
	b_e8_m4_pelican2_3_landed = TRUE;	
	cs_fly_to(e8_m4_pelican_2_pts.p8);
	end


script command_script cs_e8_m4_pelican_drop_5   // END PELICAN 2
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	sleep_until(b_e8_m4_pelican2_3_Evac == true, 1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);					
	cs_vehicle_speed_instantaneous(ai_current_actor, 1);		
	cs_fly_to(e8_m4_pelican_3_pts.p6);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 200);  //bigger size over time
	cs_fly_to(e8_m4_pelican_3_pts.p7);
	cs_fly_to(e8_m4_pelican_3_pts.p8);
	end

//================= FORERUNNER BEAMS ATTACHED TO STATIONARY PELICAN IN DIAMOND========================================

script static void  f_e8_m4_pelican_captured

	sleep_until(b_e8_m4_pelican4_start == TRUE, 1);
	effect_new(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare01);
	effect_new(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare02);
	effect_new(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare03);
	effect_new(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare04);
	effect_new_between_points(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam01, fx_pelican_beam_impact01 );
	effect_new_between_points(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam02, fx_pelican_beam_impact02 );
	effect_new_between_points(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam03, fx_pelican_beam_impact03 );
	effect_new_between_points(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam04, fx_pelican_beam_impact04 );
	//thread (f_e8_m4_beam1());	
	//thread (f_e8_m4_beam2());	
	//thread (f_e8_m4_beam3());	
	//thread (f_e8_m4_beam4());	

end


// MOVED TO DOOR SWITCH SCRIPT
/*    script static void f_e8_m4_beam1
    sleep_until(device_get_position(dc_e8_m4_switch5) == 1,1);
    sleep(2);
    r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare01);
    effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam01);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', fx_pelican_beam01, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_10, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_e8_m4_switch_10, phase_out, panel);
	b_e8_m4_stop_firing = TRUE;
	sleep_s(4);
	object_destroy(dc_e8_m4_switch5);
	object_destroy(dm_e8_m4_switch_10);
    end
    
    script static void f_e8_m4_beam2
	sleep_until(device_get_position(dc_e8_m4_switch6) == 1,1);
	sleep(2);
	r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare02);
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam02);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', fx_pelican_beam02, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_11, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_e8_m4_switch_11, phase_out, panel);
	object_destroy(dc_e8_m4_switch6);
	object_destroy(dm_e8_m4_switch_11);
	end
	
	script static void f_e8_m4_beam3
	sleep_until(device_get_position(dc_e8_m4_switch7) == 1,1);
	sleep(2);
	r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
	effect_new(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare03);
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam03);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', fx_pelican_beam03, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_12, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_e8_m4_switch_12, phase_out, panel);
	object_destroy(dc_e8_m4_switch7);
	object_destroy(dm_e8_m4_switch_12);
	end
	
	script static void f_e8_m4_beam4
	sleep_until(device_get_position(dc_e8_m4_switch8) == 1,1);
	sleep(2);
	r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare04);
	effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam04);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', fx_pelican_beam04, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_13, 1 ); //AUDIO!
	object_dissolve_from_marker(dm_e8_m4_switch_13, phase_out, panel);
	object_destroy(dc_e8_m4_switch8);
	object_destroy(dm_e8_m4_switch_13);
    end*/





//================Phantoms in order====================================


script command_script cs_e8_m4_phantom_5()  //PHANTOM 5  - First in donut sequence after first jammer is destroyed and after enemies at 8
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	cs_ignore_obstacles (TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_set_shadowless (ai_current_actor, TRUE);
	b_e8_m4_phantom_5_started = true; 
	thread(f_e8_m4_phantom_5_destroyed());
	print ("PHANTOM 1 MOVING TO POSITION!");
	sleep(2);
	ai_place(sq_e8m4_paratroops_j1);
	ai_place(sq_e8m4_paratroops_j2);
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_j1, sq_e8_m4_phantom_5, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_j2, sq_e8_m4_phantom_5, "phantom_p_lf");
	thread(f_e8_m4_vo_phantom_5_call());
	cs_fly_to(ps_e8_m4_phantom_5.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 90 );  //bigger size over time
	cs_fly_to(ps_e8_m4_phantom_5.p2);
	cs_vehicle_speed_instantaneous(ai_current_actor, .5);
	cs_fly_to(ps_e8_m4_phantom_5.p3);
	sleep_until((volume_test_players(player_near_north_jammer_vol) == true) or (volume_test_players(player_near_south_jammer_vol) == true), 1);
	repeat
		if  volume_test_players(player_near_south_jammer_vol) == true then
			cs_vehicle_speed_instantaneous(ai_current_actor, 1);
			cs_fly_to(ps_e8_m4_phantom_5.p4);	
			print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
			sleep_s(1);
			f_unload_phantom (ai_current_actor, "dual");
			sleep_s(2);
			b_e8_m4_phantom_5_unloaded = true;
			cs_fly_to(ps_e8_m4_phantom_5.p5);
			cs_fly_to(ps_e8_m4_phantom_5.p6);
			cs_fly_to(ps_e8_m4_phantom_5.p8);
			cs_fly_to(ps_e8_m4_phantom_5.p9);
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
			cs_fly_to(ps_e8_m4_phantom_5.p7);
			sleep(30);
			ai_erase(sq_e8_m4_phantom_5);
			object_destroy(unit_get_vehicle (sq_e8_m4_phantom_5));
			b_e8_m4_phantom5_done = TRUE;
		elseif volume_test_players(player_near_north_jammer_vol) == true then
			cs_vehicle_speed_instantaneous(ai_current_actor, 1);
			cs_fly_to(ps_e8_m4_phantom_5.p4);	
			cs_fly_to(ps_e8_m4_phantom_5.p5);
			cs_fly_to_and_face(ps_e8_m4_phantom_5.p6, ps_e8_m4_phantom_5.p8);
			print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
			sleep_s(1);
			f_unload_phantom (ai_current_actor, "dual");
			sleep_s(2);
			b_e8_m4_phantom_5_unloaded = true;
			cs_fly_to(ps_e8_m4_phantom_5.p8);
			cs_fly_to(ps_e8_m4_phantom_5.p9);
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
			cs_fly_to(ps_e8_m4_phantom_5.p7);
			sleep(30);
			ai_erase(sq_e8_m4_phantom_5);
			object_destroy(unit_get_vehicle (sq_e8_m4_phantom_5));
			b_e8_m4_phantom5_done = TRUE;
		end	
	until( b_e8_m4_phantom5_done == TRUE);
end

script static void f_e8_m4_phantom_5_destroyed  //  when phantom destroyed do this
	sleep_until (b_e8_m4_phantom_5_started == true, 1);
	print ("PHANTOM 5 STARTED!");
	sleep_s(2);
	sleep_until (ai_living_count (sq_e8_m4_phantom_5) <= 0, 1);
	print ("PHANTOM 5 AT ZERO!");
	b_e8_m4_phantom5_done = true;
	print ("PHANTOM 5 DONE!");
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_5));	
end


script command_script cs_e8_m4_phantom_3()  //PHANTOM 3 - second in donut sequence after first phantom and  after enemies at 8
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	ai_place(sq_e8_m4_wraith_3);
	f_unblip_ai_cui(sq_e8_m4_wraith_3);
	thread(f_e8_m4_phantom_3_destroyed());
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e8_m4_phantom_3.phantom), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e8_m4_wraith_3.spawn_points_1));
	f_load_phantom (sq_e8_m4_phantom_3, "dual", sq_e8_m4_paratroops_x1, sq_e8_m4_paratroops_x2, none,  none);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	print ("PHANTOM 1 MOVING TO POSITION!");
	sleep_until (b_e8_m4_phantom5_done == true, 1);
	b_e8_m4_phantom_3_started = true;
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	cs_fly_to(ps_e8_m4_phantom_3.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 90 );  //bigger size over time
	cs_fly_to(ps_e8_m4_phantom_3.p2);
	thread(f_e8_m4_phantom_3_vo_call());
	cs_vehicle_speed_instantaneous(ai_current_actor, .5);
	cs_fly_to(ps_e8_m4_phantom_3.p3);
	cs_fly_to_and_face(ps_e8_m4_phantom_3.p9, ps_e8_m4_phantom_3.p10);
	sleep_s(1);
	sleep_until(volume_test_object(tv_wraith_lz, ai_vehicle_get_from_spawn_point(sq_e8_m4_wraith_2.spawn_points_1)) == false, 1);
	print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e8_m4_phantom_3.phantom), "phantom_lc" );
	sleep_s(2);
	cs_fly_to_and_face(ps_e8_m4_phantom_3.p7, ps_e8_m4_phantom_3.p8);
	sleep_s(2);
	f_unload_phantom (ai_current_actor, "dual");
	sleep_s(4);
	b_e8_m4_phantom_3_unloaded = true;
	thread(f_e8_m4_blip_last_enemies());
	cs_fly_to(ps_e8_m4_phantom_3.p4);
	cs_fly_to(ps_e8_m4_phantom_3.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
	cs_fly_to(ps_e8_m4_phantom_3.p6);
	b_e8_m4_phantom3_done = true;
	sleep(30);
	ai_erase(sq_e8_m4_phantom_3);
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_3));

end	

script static void f_e8_m4_phantom_3_vo_call
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	e8m4_narrative_is_on = true;
	vo_glo_phantom_10();
	e8m4_narrative_is_on = false;
end

	
script static void f_e8_m4_phantom_3_destroyed  //  when phantom destroyed do this
	sleep_until (b_e8_m4_phantom_3_started == true, 1);
	sleep_s(2);
	sleep_until (ai_living_count (sq_e8_m4_phantom_3) <= 0, 1);
	b_e8_m4_phantom3_done = TRUE;
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_3));	
end



script command_script cs_e8_m4_phantom_1  // PHANTOM 1 - First phantom of the diamond  sequence 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	print ("PHANTOM 1 MOVING TO POSITION!");
	thread(f_e8_m4_phantom_1_destroyed());
	b_e8_m4_phantom_1_started = true;
	//thread(f_e8_m4_f_drop());
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);;
	print ("PHANTOM 1 MOVING TO POSITION!");
	sleep(2);
	ai_place(sq_e8m4_paratroops_t1);
	ai_place(sq_e8m4_paratroops_t2);
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_t1, sq_e8_m4_phantom_1, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_t2, sq_e8_m4_phantom_1, "phantom_p_lf");
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 200 );  //bigger size over time
	cs_fly_to(ps_e8_m4_phantom_1.p4);
	cs_vehicle_speed_instantaneous(ai_current_actor, .5);
	cs_fly_to(ps_e8_m4_phantom_1.p14);
	cs_fly_to(ps_e8_m4_phantom_1.p5);
	print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
	sleep_s(3);
	print ("PHANTOM 1 I SLEEPED!!!!!!");
	f_unload_phantom (ai_current_actor, "dual");
	print ("PHANTOM 1 I UNLOADED!!!!!!");
	sleep_s(3);
	b_e8_m4_phantom_1_unloaded = true;
	print ("PHANTOM 1 I SLEEPED!!!!!!");
	cs_vehicle_speed_instantaneous(ai_current_actor, 1);
	cs_fly_to(ps_e8_m4_phantom_1.p6);
	cs_fly_to(ps_e8_m4_phantom_1.p16);
	cs_fly_to(ps_e8_m4_phantom_1.p8);
	//cs_vehicle_speed_instantaneous(ai_current_actor, 2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 500 ); //Shrink size over time
	cs_fly_to(ps_e8_m4_phantom_1.p9);	
	b_e8_m4_phantom1_done = TRUE;
	ai_erase(sq_e8_m4_phantom_1);
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_1));
	sleep_s(2);
	r_e8_m4_switches_phantoms = r_e8_m4_switches_phantoms + 1;

end


script static void f_e8_m4_phantom_1_destroyed  //  when phantom destroyed do this
	sleep_until (b_e8_m4_phantom_1_started == true, 1);
	sleep_until (ai_living_count (sq_e8_m4_phantom_1) <= 0, 1);
	sleep(2);
	r_e8_m4_switches_phantoms = r_e8_m4_switches_phantoms + 1;
	b_e8_m4_phantom1_done = TRUE;
	b_e8_m4_phantom1_destoyed = true;
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_1));	
	sleep(2);
	r_e8_m4_switches_phantoms = r_e8_m4_switches_phantoms + 1;
end



script static void f_e8_m4_Droppods  // DROP POD after phantom 1 done  and after 5-8 guys left
	print("DROP POD INCCOMING!!!!!!!!!!!");
	ai_place_in_limbo(sq_e8_m4_factory_dp1);
	ai_place_in_limbo(sq_e8_m4_factory_dp2);
	thread (f_dlc_load_drop_pod(e8_m4_drop_pod_2, sq_e8_m4_factory_dp1, sq_e8_m4_factory_dp2, drop_pod_lg_01));
	f_unblip_object_cui (e8_m4_drop_pod_2);
	b_drop_pods_deployed = true;
end

script command_script cs_e8_m4_phantom_6  // Phantom 6 - second in diamond sequence
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	ai_place(sq_e8_m4_factory_ghosts1);
	ai_place(sq_e8_m4_factory_ghosts4);
	b_e8_m4_phantom_6_started = true ;
	thread(f_e8_m4_phantom_6_destroyed());
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e8_m4_phantom_6.spawn_points_0), "phantom_sc01", ai_vehicle_get_from_spawn_point(sq_e8_m4_factory_ghosts1.spawn_points_0));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e8_m4_phantom_6.spawn_points_0), "phantom_sc02", ai_vehicle_get_from_spawn_point(sq_e8_m4_factory_ghosts4.spawn_points_0));
	cs_ignore_obstacles (TRUE);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_set_shadowless (ai_current_actor, TRUE);;
	print ("PHANTOM 6 MOVING TO POSITION!");
	sleep(2);
	ai_place(sq_e8m4_paratroops_p1);
	ai_place(sq_e8m4_paratroops_p2);
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_p1, sq_e8_m4_phantom_6, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e8m4_paratroops_p2, sq_e8_m4_phantom_6, "phantom_p_lf");
	print("should be loaded with dude");
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 200 );  //bigger size over time
	cs_fly_to(ps_e8_m4_phantom_1.p7);
	sleep_until (ai_living_count (gr_e8_m4_droppods) <= 4, 1);
	cs_fly_to(ps_e8_m4_phantom_1.p10);
	cs_fly_to(ps_e8_m4_phantom_1.p17);
	cs_fly_to_and_face(ps_e8_m4_phantom_1.p6, ps_e8_m4_phantom_1.p1);
	print ("PHANTOM 6 TIME TO UNLOAD!!!!!!");
	sleep_s(3);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e8_m4_phantom_6.spawn_points_0), "phantom_sc01" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e8_m4_phantom_6.spawn_points_0), "phantom_sc02" );
	print ("PHANTOM 6 I SLEEPED!!!!!!");
	f_unload_phantom (ai_current_actor, "dual");
	print ("PHANTOM 6 I UNLOADED!!!!!!");
	sleep_s(3);
	b_e8_m4_phantom_6_unloaded = true;
	print ("PHANTOM 6 I SLEEPED!!!!!!");
	cs_fly_to(ps_e8_m4_phantom_1.p5);
	cs_fly_to(ps_e8_m4_phantom_1.p14);
	//cs_vehicle_speed_instantaneous(ai_current_actor, 2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 500 ); //Shrink size over time
	cs_fly_to(ps_e8_m4_phantom_1.p15);
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_6));
	b_phantom_diamond = true ;
	b_e8_m4_phantom6_done = TRUE;
end

script static void f_e8_m4_phantom_6_destroyed
	sleep_until (b_e8_m4_phantom_6_started == true, 1);
	sleep_until (ai_living_count (sq_e8_m4_phantom_6) <= 0, 1);
	b_e8_m4_phantom6_done = TRUE;
	b_e8_m4_phantom6_destroyed = true;
	b_phantom_diamond = true ;
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_6));	
	sleep(2);
	r_e8_m4_switches_phantoms = r_e8_m4_switches_phantoms + 1;
	
end




script command_script cs_e8_m4_phantom_2  // PHANTOM 2  - last phantom with the hunters 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.1, 0 ); //start_small
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);;
	b_e8_m4_phantom_2_started = true;
	thread(f_e8_m4_phantom_2_destroyed());
	print ("PHANTOM 1 MOVING TO POSITION!");
	print ("PHANTOM 2 MOVING TO POSITION!");
	ai_place(sq_e8m4_hunter_rf);
	ai_place(sq_e8m4_hunter_lb);
	
	ai_place(sq_e8m4_hunter_lf);
	ai_place(sq_e8m4_hunter_rb);
	
	ai_vehicle_enter_immediate(sq_e8m4_hunter_rf, sq_e8_m4_phantom_2, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e8m4_hunter_lb, sq_e8_m4_phantom_2, "phantom_p_lb");
	
	ai_vehicle_enter_immediate(sq_e8m4_hunter_lf, sq_e8_m4_phantom_2, "phantom_p_lf");
	ai_vehicle_enter_immediate(sq_e8m4_hunter_rb, sq_e8_m4_phantom_2, "phantom_p_rb");
	
	cs_fly_to(ps_e8_m4_phantom_2.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 90 );  //bigger size over time
	cs_fly_to(ps_e8_m4_phantom_2.p4);
	thread(f_music_e08m4_phantoms_inbound());
	sleep_until(volume_test_players(phantoms_inbound_vol), 1);
	cs_fly_to_and_face(ps_e8_m4_phantom_2.p5,ps_e8_m4_phantom_2.p6);
	print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
	sleep_s(1);
	thread(f_unload_phantom (ai_current_actor, "right"));
	sleep(2 * 30);
	thread(f_e8m4_hunter_vo());
	sleep(3 * 30);
	cs_fly_to_and_face(ps_e8_m4_phantom_2.p6, ps_e8_m4_phantom_2.p0);
	sleep(1);
	b_e8m4_hunters_landed = true;
	print ("PHANTOM 1 TIME TO UNLOAD!!!!!!");
	sleep_s(1);
	f_unload_phantom (ai_current_actor, "left");
	sleep_s(4);
	b_e8_m4_phantom_2_unloaded = true;
	b_e8_m4_phantom_2_done = TRUE;
	cs_fly_to(ps_e8_m4_phantom_2.p7);
	cs_fly_to(ps_e8_m4_phantom_2.p8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
	cs_fly_to(ps_e8_m4_phantom_2.p9); 
	sleep (2);
	ai_erase(sq_e8_m4_phantom_2);
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_2));
end

script static void f_e8m4_hunter_vo
	sleep_until(e8m4_narrative_is_on == false);
	vo_e8m4_hunters();
end



script static void f_e8_m4_phantom_2_destroyed //  when phantom destroyed do this
	sleep_until (b_e8_m4_phantom_2_started == true, 1);
	sleep_until (ai_living_count (sq_e8_m4_phantom_2) <= 0, 1);;
	b_e8_m4_phantom_2_unloaded = true;
	b_e8_m4_phantom_2_done = TRUE;
	b_e8_m4_phantom_2_destroyed = true;
	object_destroy(unit_get_vehicle (sq_e8_m4_phantom_2));	
end


//=========================OTHER STUFF=======================================
script command_script cs_e8_m4_mount_weapon()
	cs_go_to(ps_e8_m4_ai.p11);
	cs_go_to_vehicle(veh_e8_m4_internal_plasma);
	end
	




script command_script cs_e8_m4_donut_elite()
	sleep_until(volume_test_players (vol_pelican_cap), 1);
	cs_go_to_and_face(e8_m4_fire_points.p12, e8_m4_fire_points.p11 );
	cs_jump( 65, 5);
	cs_go_to_and_face(e8_m4_fire_points.p13, e8_m4_fire_points.p14 );
	cs_custom_animation (objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:rifle:shakefist", TRUE);
	unit_stop_custom_animation (ai_current_actor);
	//sound_impulse_start('sound\storm\characters\knight\foley\npc_storm_knight_foley_qbr_surprise', NONE, 1);
end

script command_script cs_e8_m4_internal_elite_left()
	//sleep_s(1);
	cs_vehicle_speed_instantaneous(ai_current_actor, 1.5);
	cs_go_to_and_face(ps_e8_m4_ai.p0, ps_e8_m4_ai.p1 );
	cs_leap_to_point( ps_e8_m4_ai.p1);
	cs_vehicle_speed_instantaneous(ai_current_actor, 1);
	cs_custom_animation (objects\characters\storm_elite_ai\storm_elite_ai.model_animation_graph, "combat:rifle:shakefist", TRUE);
	unit_stop_custom_animation (ai_current_actor);//sound_impulse_start('sound\storm\characters\knight\foley\npc_storm_knight_foley_qbr_surprise', NONE, 1);
	cs_jump( 10, 3);
	cs_leap_to_point( ps_e8_m4_ai.p2);
end


script static void f_lz_1_e8_m4_1
	f_blip_object_cui (lz_1, "navpoint_goto");
	sleep_until (volume_test_players (vol_lz_1), 1);
	f_unblip_object_cui (lz_1);
end
	
script static void f_e8_m4_switches_off  // removal of cookie crumb in interior hallway	
	
	object_dissolve_from_marker(dm_e8_m4_switch_10, phase_out, panel);
	object_dissolve_from_marker(dm_e8_m4_switch_11, phase_out, panel);
	object_dissolve_from_marker(dm_e8_m4_switch_12, phase_out, panel);
	object_dissolve_from_marker(dm_e8_m4_switch_13, phase_out, panel);
	object_dissolve_from_marker(e8_m4_internal_button, phase_out, button_marker);
	object_dissolve_from_marker(e8_m4_internal_button_1, phase_out, button_marker);

end

script static void e8_m4_enemy_count_blip
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 5, 1); 
	f_blip_ai_cui(gr_e8_m4_ff_all, "navpoint_enemy");	
	end



//=======================JAMMERS=========================================
	
			
script static void f_e8_m1_jammermid	  // jammer counter for middle of donut
	sleep_until(object_valid (e8_m4_jammer_2), 1);
	sleep_until(object_get_health (e8_m4_jammer_2) <= 0, 1);
	print("------jammer 2 desroyed======");
	sleep(2);
	r_e8_m4_jammers_destroyed = r_e8_m4_jammers_destroyed + 1; 
	b_mid_jammer_done  = TRUE;
end
	
	    
	    
script static void f_e8_m1_jammerback	// jammer counter for back of donut
 	sleep_until(object_valid (e8_m4_jammer_3), 1);
	sleep_until(object_get_health (e8_m4_jammer_3) <= 0, 1);
    print("---------- Jammer 3 Destroyed----------");
    sleep(2);
    r_e8_m4_jammers_destroyed = r_e8_m4_jammers_destroyed + 1;
	b_back_jammer = TRUE;	
end
		
script static void f_e8_m1_jammerfront	// jammer counter for front of donut
	sleep_until(object_valid (e8_m4_jammer_1), 1);
	sleep_until(object_get_health (e8_m4_jammer_1) <= 0);
	print("---------- Jammer 1 Destroyed----------");
	sleep(2);
	r_e8_m4_jammers_destroyed = r_e8_m4_jammers_destroyed + 1;
	b_front_jammer  = TRUE;
end
	
	script static void f_e8_m1_jammer_count  // when one jammer is destroyed spawn phantoms
		sleep_until(r_e8_m4_jammers_destroyed == 1, 1);
		thread(f_e8_m1_jammer_count_vo());  //74 vo
		print("---------- Jammer phantom time 1----------");
		thread(f_e8m4_donut_combat());
//		sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 10, 1); 
//		ai_place(sq_e8_m4_phantom_5);
//		notifylevel ("e8_m1_donut_dr_a_done"); 
//		sleep_until (b_e8_m4_phantom5_done == true, 1); 
//		sleep_until(	 	(ai_living_count (gr_e8_m4_ff_all) <= 8)
//								and (ai_living_count (gr_e8_m4_wraiths) <= 2)
//								,1 );
//		print("---------- spawn phantom 3 now----------");
//		ai_place(sq_e8_m4_phantom_3);
//		sleep_until(b_e8_m4_phantom3_done == true, 1);
		sleep_until(r_e8_m4_jammers_destroyed >= 3, 1);
		sleep_s(2);
		thread(e8_m4_vo_donut_dr_a_done());	

		sleep_until(b_e8_m4_phantom3_done == true, 1);
		sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 0, 1); 
		sleep_s(1);
		print("---------- Jammers compete----------");
		b_end_player_goal = TRUE;
	end
	
	script static void f_e8m4_donut_combat
		sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 10, 1); 
		ai_place(sq_e8_m4_phantom_5);
		notifylevel ("e8_m1_donut_dr_a_done"); 
		sleep_until (b_e8_m4_phantom5_done == true, 1); 
		sleep_until(	 	(ai_living_count (gr_e8_m4_ff_all) <= 8)
								and (ai_living_count (gr_e8_m4_wraiths) <= 2)
								,1 );
		print("---------- spawn phantom 3 now----------");
		ai_place(sq_e8_m4_phantom_3);
	end
	
	
	script static void f_e8_m1_jammer_count_vo	 //74 vo
		sleep_until(r_e8_m4_jammers_destroyed >= 1, 1);
		sleep_s(1);
		sleep_until(e8m4_narrative_is_on == FALSE, 1);
		vo_e8m4_1stjammer();
		sleep_until(r_e8_m4_jammers_destroyed >= 2, 1);
		sleep_until(e8m4_narrative_is_on == FALSE, 1);
		vo_e8m4_1morejammer();
	end
	
	// ===============================Doors and Switches==========================================================
/*		script static void f_e8_m4_pup_door_1
		sleep_until (LevelEventStatus("interior_d_e8_m4_1"), 1);
		thread(f_door_interior_d_e8_m4_1());
		end*/


script static void f_e8m4_open_first_door
	device_set_power(dm_wedge_ramp_door, 1);
	device_set_position( dm_wedge_ramp_door, 1 );
//	sleep_until(device_get_position(dm_wedge_ramp_door) >= 1);
//	object_destroy(dm_wedge_ramp_door);
end

script static void f_e8m4_open_second_door
	device_set_power(dm_donut_ramp_door, 1);
	device_set_position( dm_donut_ramp_door, 1 );
//	sleep_until(device_get_position(dm_donut_ramp_door) >= 1);
//	object_destroy(dm_donut_ramp_door);
end
		
		
script static void f_door_interior_d_e8_m4_1 (object control, unit player)
		g_e8m4_ics_player = player;
	
	if control == dc_e8_m4_switch2 then	
		pup_play_show (pup_e8_m4_doorswitch1);
		sleep_s(2);
		device_set_position( e8_m4_internal_button, 1 );
		device_animate_position( e8_m4_internal_button, 1, 2, 1.0, 1.0, TRUE );
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dc_e8_m4_switch2, 1 ); //AUDIO!
		object_dissolve_from_marker(e8_m4_internal_button, phase_out, button_marker);
		object_set_physics (e8_m4_internal_button, false);
		sleep_s(1);
		thread(f_e8m4_open_first_door());
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', dm_wedge_ramp_door, 1);
		sleep_s(1.5);
		thread(f_lz_1_e8_m4_1());
		object_set_physics (dm_wedge_ramp_door, false);
		sleep_s(6.5);
		thread(f_e8_m4_zone_swap_1());
		object_destroy(dc_e8_m4_switch2);
		object_destroy(e8_m4_internal_button);
		sleep_s(1);
		sleep_until(e8m4_narrative_is_on == FALSE, 1);
		notifylevel("e8_m4_breach_the_prision");

	elseif control == dc_e8_m4_switch1 then

		pup_play_show (pup_e8_m4_doorswitch2);
		sleep_s(2);
		device_set_position( e8_m4_internal_button_1, 1 );
		device_animate_position( e8_m4_internal_button_1, 1, 2, 1.0, 1.0, TRUE );
		sleep_s(1);
		object_dissolve_from_marker(e8_m4_internal_button_1, phase_out, button_marker);
		object_set_physics (e8_m4_internal_button_1, false);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dc_e8_m4_switch1, 1 ); //AUDIO!
		sleep_s(1);
		thread(f_e8m4_open_second_door());
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', dm_donut_ramp_door, 1);
		sleep_s(1.5);
		object_set_physics (dm_donut_ramp_door, false);
		sleep_s(6.5);
		object_destroy(dc_e8_m4_switch1);
		object_destroy(e8_m4_internal_button_1);
		b_e8_m4_pelican4_start = TRUE;  //setting peilican Cap guys to hover
		thread(f_e8_m4_pelican_captured());
		thread(f_e8_m4_obj4a_txt());
		sleep_until(b_e8_m4_jammers_activate == true, 1);
		f_blip_object_cui(e8_m4_jammer_2, "navpoint_healthbar_neutralize"); //f_blip_object_cui (objective_obj, "navpoint_healthbar_destroy"
		f_blip_object_cui(e8_m4_jammer_1, "navpoint_healthbar_neutralize");
		f_blip_object_cui(e8_m4_jammer_3, "navpoint_healthbar_neutralize");
		notifylevel ("e8_m1_jammermid"); 
		sleep(10);
		notifylevel ("e8_m1_jammerback"); 
		sleep(20);
		notifylevel ("e8_m1_jammerfront"); 
	
	elseif control == dc_e8_m4_switch6 then  //  Forerunner Beam 1
		if(b_e8m4_hunters_landed == false)then
 			pup_play_show (pup_e8_m4_beamswitch2);
 			sleep_s(1.5);
 		end
		sleep(20);
		device_set_position( dm_e8_m4_switch_10, 1 );
		device_animate_position( dm_e8_m4_switch_10, 1, 3.5, 1.0, 1.0, TRUE );
	   	sleep_s(3.5);
	    r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare04);
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam04);
	  	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', e8_m4_capped_pelican, 1); //AUDIO!
		object_dissolve_from_marker(dm_e8_m4_switch_10, phase_out, panel);
		object_set_physics (dm_e8_m4_switch_10, false);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_10, 1 );
		sleep_s(3.5);
		object_destroy(dc_e8_m4_switch6);
		object_destroy(dm_e8_m4_switch_10);
		
		
	elseif control == dc_e8_m4_switch5 then  //  Forerunner Beam 2   
		if(b_e8m4_hunters_landed == false)then
 			pup_play_show (pup_e8_m4_beamswitch1);
 			sleep_s(1.5);
 		end
		sleep(20);
		device_set_position( dm_e8_m4_switch_11, 1 );
		device_animate_position( dm_e8_m4_switch_11,  1, 3.5, 1.0, 1.0, TRUE );
		sleep_s(3.5);
		r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare02);
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam02);
	 	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', e8_m4_capped_pelican, 1); //AUDIO!
		object_dissolve_from_marker(dm_e8_m4_switch_11, phase_out, panel);
		object_set_physics (dm_e8_m4_switch_11, false);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_11, 1 );
		sleep_s(3.5);
		object_destroy(dc_e8_m4_switch5);
		object_destroy(dm_e8_m4_switch_11);
		
	elseif control == dc_e8_m4_switch8 then  //  Forerunner Beam 3	
		if(b_e8m4_hunters_landed == false)then
 			pup_play_show (pup_e8_m4_beamswitch3);
 			sleep_s(1.5);
 		end
		sleep(20);
		device_set_position( dm_e8_m4_switch_13, 1 );
		;device_animate_position( dm_e8_m4_switch_13,  1, 3.5, 1.0, 1.0, TRUE );
		sleep_s(3.5);
		r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare01);
	    effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam01);
	  sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', e8_m4_capped_pelican, 1); //AUDIO!
		object_dissolve_from_marker(dm_e8_m4_switch_13, phase_out, panel);
		object_set_physics (dm_e8_m4_switch_13, false);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_13, 1 );
		sleep_s(3.5);
		object_destroy(dc_e8_m4_switch8);
		object_destroy(dm_e8_m4_switch_13);	
		
	elseif control == dc_e8_m4_switch7 then  //  Forerunner Beam 4   
		if(b_e8m4_hunters_landed == false)then
 			pup_play_show (pup_e8_m4_beamswitch4);
 			sleep_s(1.5);
 		end
		sleep(20);
		device_set_position( dm_e8_m4_switch_12, 1 );
		device_animate_position( dm_e8_m4_switch_12, 1, 3.5, 1.0, 1.0, TRUE );
		sleep_s(3.5);
		r_e8_m4_switches_on = r_e8_m4_switches_on + 1;
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\dlc_energybeam_flare.effect, fx_pelican_flare03);
		effect_kill_from_flag(levels\firefight\dlc01_factory\fx\factory_energycore_beam.effect, fx_pelican_beam03);
	  sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\fx\factory_fx_energy_core_beam_deactivate_in', e8_m4_capped_pelican, 1); //AUDIO!
		object_dissolve_from_marker(dm_e8_m4_switch_12, phase_out, panel);
		object_set_physics (dm_e8_m4_switch_12, false);
		sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_derez_in', dm_e8_m4_switch_12, 1 );
		sleep_s(3.5);
		object_destroy(dc_e8_m4_switch7);
		object_destroy(dm_e8_m4_switch_12);
		end	
	end
	
	script static void f_door_donut_a_e8_m4_1	
		sleep_until (LevelEventStatus("e8_m1_donut_dr_a_done"), 1);
/*		sleep_s(15);
		object_move_to_point (e8_m4_donut_dr_a, 3, ps_e8_m4_doorpoints.p10);   // Open hallway to donut Door	
		object_move_to_point (e8_m4_donut_dr_b, 3, ps_e8_m4_doorpoints.p11);   // Open hallway to donut Door	*/
		b_donut_mid_doors_open  = TRUE;

	end	
	
/*script static void f_e8_m4_donut_veh_done	
		sleep_until(r_e8_m4_wraiths_done == 2);
		print("garage door opens here");
		object_move_to_point (e8_m4_donut_veh_dr, 3, ps_e8_m4_doorpoints.p13);   // Garden Attack Crew
		object_move_to_point (e8_m4_donut_dr_c, 3, ps_e8_m4_doorpoints.p15);
	end*/
	
	
script static void f_door_diamond_a_e8_m4_1	// Animates and opens the main center door between donut and diamond
	sleep_until (LevelEventStatus("e6_diamond_dr_a_done"), 1);
	f_add_crate_folder(e8_m4_cov_crates_diamond);	
	sleep(20);
	f_e8m4_vo_tansponder();
	//sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_middle_door_open', dm_diamond_main_gate, 1);
	device_set_position_track( dm_diamond_main_gate, 'any:idle', 1 );
	device_animate_position( dm_diamond_main_gate, 1, 3.5, 1.0, 1.0, TRUE );
	thread(f_e8m4_cover());
	sleep(30 * 2);
	thread(f_e8m4_powersource_vo());
	sleep_until(volume_test_players("vol_lz_3") == true, 1);
	f_create_new_spawn_folder (95);	 //spawn at door to diamond
	b_e8_m4_diamond_open = true; 
end	
	
script static void f_e8m4_powersource_vo
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	e8m4_narrative_is_on = true;
	vo_glo_powersource_03();
	e8m4_narrative_is_on = false;
end
	
script static void f_door_diamond_b_e8_m4_1	 // was a door open script, now only shuts down forerunner guns
	sleep_until (LevelEventStatus("e6_diamond_dr_b_done"), 1);
	b_e8_m4_stop_firing = true;
	
end
  
script static void f_attach_buttons_e8_m4  //  turn on 1st hallway door

	sleep_until (LevelEventStatus("e8_m4_internal_button_1"), 1);
	print(" event internal button 1.......");
	
	//sleep_s(2);
	object_dissolve_from_marker(e8_m4_internal_button, phase_in, button_marker);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dc_e8_m4_switch2, 1 );
	sleep_s(2);	
	print("set da powwwwer");
	device_set_power(dc_e8_m4_switch2, 1);
	sleep_s(2);	
	thread(e8_m4_vo_door_interior_d());  // Vo

end  
	
script static void f_attach_button2_e8_m4	  //   turn on second hallway door  but wait for zone swap first
	sleep_until (LevelEventStatus("e8_m4_internal_button_2"), 1);
	b_wait_for_narrative_hud = true;
	sleep_until (b_e8_m4_zone_swapped == true, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_button_derez_in', dc_e8_m4_switch1, 1 );
	object_dissolve_from_marker(e8_m4_internal_button_1, phase_in, button_marker);
	sleep(30 * 0.75);
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(vo_e8m4_show_button());
			// Miller : Tagging the door controls for you now.
	sleep(30);
	device_set_power(dc_e8_m4_switch1, 1);
	b_wait_for_narrative_hud = false;
end  

script static void f_vol_ghosts_diamond_e8_m4
	sleep_until (volume_test_players (vol_ghosts_diamond), 1); //place diamond ghosts based on  volume
	ai_place (sq_e8_m4_factory_ghosts2);
	sleep(2);	
end

script static void  f_e8m4_switches_on()  // sequence of phantoms when entering diamond prior to activating switches
	sleep_until(LevelEventStatus("e8_m4_switches_on"), 1);
	ai_place(sq_e8_m4_phantom_1);  
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_glo15_palmer_phantom_01(); // Palmer : Phantom on approach.
	sleep_until (b_e8_m4_phantom1_done == true, 1);
	sleep_until ((ai_living_count (gr_e8_m4_ff_all) <= 6) or (b_e8_m4_phantom1_destoyed == true), 1);
	print("phantom1 is done, now spawn droppods");
	thread(f_e8_m4_Droppods());
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_glo_droppod_01();  //miller; droppods incoming
	sleep_until(b_drop_pods_deployed == true, 1);
	print("drop pods deployed");
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 5, 1); 
	print("Now phantom 6 time");
	ai_place(sq_e8_m4_phantom_6);
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_glo_incoming_08();  //palmer; more target practice coming your way!	
	print("more target practice finished");
	sleep_until(b_e8_m4_phantom6_done == true, 1);
	print("phantom 6 sleep until done");
	thread(f_e8_m4_blip_last_enemies());
	print("blip  last enemies done");
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 0, 1);
	print("no more enemies");
	sleep_s(2);
	print("slept for two");
	e8_m4_vo_lz_3();  // those energy tethers are tied into the pelican's 
	b_end_player_goal = true;  //activate the switches
	device_set_power(dc_e8_m4_switch5, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dc_e8_m4_switch5, 1);
	object_dissolve_from_marker(dm_e8_m4_switch_10, phase_in, panel);
	device_set_power(dc_e8_m4_switch6, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dc_e8_m4_switch6, 1);
	object_dissolve_from_marker(dm_e8_m4_switch_11, phase_in, panel);
	device_set_power(dc_e8_m4_switch7, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dc_e8_m4_switch7, 1);
	object_dissolve_from_marker(dm_e8_m4_switch_12, phase_in, panel);
	device_set_power(dc_e8_m4_switch8, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\events\factory_terminal_core_derez_in', dm_e8_m4_switch_13, 1);
	object_dissolve_from_marker(dm_e8_m4_switch_13, phase_in, panel);
	sleep_until( r_e8_m4_switches_on >= 1, 1);
	ai_place(sq_e8_m4_phantom_2);
	thread(f_e8_m4_vo_hunter_phantom());
	sleep_until( r_e8_m4_switches_on == 4, 1);
	notifylevel ("e8_m4_get_to_lz");
end	

script static void  f_e8_m4_switch_vo_counter() //74 vo
	repeat
		if  r_e8_m4_switches_on == 1 and r_e8_m4_switch_vo_played == 0 then
			sleep_s(1);
			//sleep_until(e8m4_narrative_is_on == FALSE, 1);
			//vo_e8m4_onarollswitchl();
			r_e8_m4_switch_vo_played = r_e8_m4_switch_vo_played + 1;
		elseif r_e8_m4_switches_on == 2 and r_e8_m4_switch_vo_played == 1 then
			sleep_s(1);
			sleep_until(e8m4_narrative_is_on == FALSE, 1);
			vo_e8m4_2ndswitch();
			r_e8_m4_switch_vo_played = r_e8_m4_switch_vo_played + 1;
		elseif r_e8_m4_switches_on == 3 and r_e8_m4_switch_vo_played == 2 then
			sleep_s(1);
			sleep_until(e8m4_narrative_is_on == FALSE, 1);
			vo_e8m4_onemoreswitch();
			r_e8_m4_switch_vo_played = r_e8_m4_switch_vo_played + 1;
		end
	until ((r_e8_m4_switches_on == 4), 1);
	end


script static void  f_e8_m4_lzdr_switch_on()
	sleep_until(LevelEventStatus("e8_m4_lzdr_switch_on"), 1);
	sleep_until (b_e8_m4_phantom6_done == true, 1);
	sleep_until ((ai_living_count (gr_e8_m4_phantom_6_dudes) <= 2) or (b_e8_m4_phantom6_destroyed == true), 1); 
	sleep_s(3);
	b_end_player_goal = true;
	b_e8_m4_stop_firing = TRUE;
	//f_blip_object_cui (dc_e8_m4_switch4, "navpoint_activate");
	//device_set_power(dc_e8_m4_switch4, 1);
	//b_end_player_goal = true;
	end
	
 	script static void f_e8_m4_phantoms_inbound
	sleep_until (LevelEventStatus("e8_m4_phantoms_inbound"), 1);	
	e8_m4_vo_lzdr_switch_on();	
	sleep (1);
	sleep_until (b_e8_m4_phantom_2_done == TRUE, 1);
	thread(f_e8_m4_blip_last_enemies());
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 0, 1); 
	b_end_player_goal = true;
 	end

	
 	script static void f_start_e8_m4_get_to_lz
		sleep_until (LevelEventStatus("start_e8_m4_get_to_lz"), 1);
		print("yup");
		print("its");
		sleep_s(3);
		print("working");
		thread(e8_m4_vo_get_to_lz());  // areas clear get to the pad
		b_e8_m4_pelican2_3_Evac = TRUE;
		ai_place(sq_e8_m4_null_pelican_driver4);
//		ai_place(sq_e8_m4_null_pelican_driver5);
		sleep(30);
		thread(f_e8_m4_obj5_txt());
		sleep(30);
		sleep_until(e8m4_narrative_is_on == false, 1);
		f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e8_m4_null_pelican_driver4.sp), "navpoint_goto");
		notifylevel("e8_m4_escape_on_pelican");
		print ("Safety Pushed");
		sleep_until(b_e8_m4_pelican2_3_landed == TRUE, 1);		
		sleep_until(e8m4_narrative_is_on == FALSE, 1);
		f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e8_m4_null_pelican_driver4.sp));
		print("pelican landed");	
		f_blip_object_cui (lz_2, "navpoint_goto");
		sleep_until(volume_test_players(landing_pad_vol), 1);
		f_blip_object_cui (lz_2, "");
		notifylevel("e8_m4_mission_end");
		//b_end_player_goal = true;
		
//DIALOG:  PALMER (CONT'D)  Palmer to Dalton. We've got a Pri-One target at Crimson's location that needs to be erased.
//DIALOG:  DALTON  Roger that, Commander. Target locked.
//DIALOG:  PALMER  Crimson. You're gonna want to clear town because the rain is on its way.
/*		ai_erase_all();
		cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
		fade_out(0, 0, 0, 90); 
		print("should have faded out by now");*/
end





 script static void f_start_e8_m4_elite_suprise
 	
	sleep_until(volume_test_players(elite_suprise_vol), 1);
	
	ai_place(sq_e8m4_elite_surprise);
	sleep_until(e8m4_narrative_is_on == false, 1);
	vo_glo_watchout_08();
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 0, 1); 
	sleep(30);
	b_end_player_goal = true;
end

script command_script cs_e8m4_marines
	//units_set_current_vitality(sq_e8_m4_marines_1, 10, 0);
	//ai_playfight(sq_e8_m4_marines_1, true);
	//sleep_s(10);
	units_set_current_vitality(ai_current_actor, 0, 0);
end
	


//================================TURRETS+++++++++++++++++++++++++++++++++++

script command_script cs_e8m4_turret_1  
	ai_set_blind (sq_e8_m4_tracer.sp0 , true);
	//ai_disregard (sq_e8_m4_tracer , true);
	f_unblip_object_cui(sq_e8_m4_tracer);
	//object_hide(ai_vehicle_get ( ai_current_actor ), true);
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .5, 1);
	//object_cannot_take_damage(ai_get_object(sq_e8_m4_null_pelican_driver2));
	//object_cannot_take_damage(ai_get_object(sq_e8_m4_null_pelican_driver3));
	//object_cannot_take_damage(ai_get_object(sq_e8_m4_phantom_4));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)   
	cs_shoot_point(true, e8_m4_fire_points.p1);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p0);
	sleep_s(1);;
	cs_shoot_point(true, e8_m4_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p2);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p10);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p5);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p10);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p5);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p0);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points.p10);
	sleep_s(1);
	
	repeat
	  	begin_random
	    	begin
	      	cs_shoot_point(true, e8_m4_fire_points.p1);
	    	sleep_s(1);
	     	cs_shoot_point(true, e8_m4_fire_points.p1);
	     	sleep_s(1);
	     	cs_shoot_point(true, e8_m4_fire_points.p3);
	      	sleep_s(0.25);
	     	cs_shoot_point(true, e8_m4_fire_points.p4);
	     	sleep_s(0.25);
	     	cs_shoot_point(true, e8_m4_fire_points.p4);
	     	sleep_rand_s(3.0,5);
	     end
                                                
    	begin
    	cs_shoot_point(true, e8_m4_fire_points.p2);
     	sleep_s(0.25);
     	cs_shoot_point(true, e8_m4_fire_points.p1);
     	sleep_s(0.25);
    	 cs_shoot_point(true, e8_m4_fire_points.p4);
     	 sleep_rand_s(3.0,5);
    	 end
	end
		until( b_e8_m4_stop_firing == TRUE);
	 ai_erase(sq_e8_m4_tracer.sp0);
end

script command_script cs_e8m4_turret_2  
	ai_set_blind ( sq_e8_m4_tracer.sp1 , true);
	f_unblip_object_cui(sq_e8_m4_tracer);
	//object_hide(ai_vehicle_get ( ai_current_actor ), true);
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .5, 1);
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	cs_shoot_point(true, e8_m4_fire_points2.p1);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p0);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p1);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p2);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p10);
	sleep(30 * 4);
	cs_shoot_point(true, e8_m4_fire_points2.p5);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p2);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p5);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p4);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p0);
	sleep_s(1);
	cs_shoot_point(true, e8_m4_fire_points2.p4);
	sleep(30 * 4);
	cs_shoot_point(true, e8_m4_fire_points2.p10);
	sleep_s(1);
	
	 repeat
	 	begin_random
	  	begin
	     	cs_shoot_point(true, e8_m4_fire_points2.p1);
	      	sleep_s(1);
	     	sleep_rand_s(3.0,5);
	     	cs_shoot_point(true, e8_m4_fire_points2.p2);
	    	sleep_s(0.25);
	     	cs_shoot_point(true, e8_m4_fire_points2.p4);
	    	sleep_s(0.25);
	   	cs_shoot_point(true, e8_m4_fire_points2.p5);
	   	sleep_rand_s(3.0,5);
	  end
	                                               
     begin
	   	cs_shoot_point(true, e8_m4_fire_points2.p2);
	    sleep_s(0.25);
        cs_shoot_point(true, e8_m4_fire_points2.p1);
	   sleep_s(1);
	    cs_shoot_point(true, e8_m4_fire_points2.p5);
	    sleep_rand_s(3.0,5);
	   end
	end
	until( b_e8_m4_stop_firing == TRUE);
//	//s_e6_m1_aa_powerdown_count = s_e6_m1_aa_powerdown_count + 1;
	 ai_erase(sq_e8_m4_tracer.sp1);
	//object_destroy(unit_get_vehicle (sq_e8_m4_null_pelican_driver4));
end

//=======================INTERNAL SETUP LOGIC===================================	   

script static void f_e8_m4_landing_party1
	//sleep_until (LevelEventStatus("e8_m4_landing_party"), 1);
	//print("checking internal dudes1");
	sleep_until(	(ai_living_count(gr_e8m4_init_left))
						 +	(ai_living_count(gr_e8m4_init_right))
						 <= 10);
	
	ai_braindead(sq_e8m4_init_reinf, false);
	
	sleep_until(	(ai_living_count(gr_e8m4_init_left))
						 +	(ai_living_count(gr_e8m4_init_right))
						 <= 7);
	s_e8m4_scenario_state = 5;																																				// change aio behaviors
	
	sleep_until(	(ai_living_count(gr_e8m4_init_left))
						 +	(ai_living_count(gr_e8m4_init_right))
						 <= 5);
	s_e8m4_scenario_state = 8;
	
	thread(f_e8_m4_right_door_internal());
	
	sleep_until(	(ai_living_count(gr_e8m4_init_left))
						 +	(ai_living_count(gr_e8m4_init_right))
						 <= 1);
	
	s_e8m4_scenario_state = 10;																																				// change aio behaviors
end	


script static void f_e8_m4_track_internal_enemies
	print("track enemies on");
	sleep_until((volume_test_players(Marines_open_right_door_vol) == true) or (volume_test_players(Marines_open_left_door_vol) == true), 1);
	f_unblip_object_cui(lz_10);
	f_unblip_object_cui(lz_9);
	f_create_new_spawn_folder (92);
	sleep_until(e8m4_narrative_is_on  == false, 1);
	e8m4_narrative_is_on = TRUE;
	vo_glo15_palmer_fewmore_04();
	e8m4_narrative_is_on = FALSE;
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 3, 1);
	sleep_until(e8m4_narrative_is_on  == false, 1);
	e8m4_narrative_is_on = TRUE;
	vo_glo_remainingcov_02();
	e8m4_narrative_is_on = FALSE;
	print("blip enemies on");
	sleep_until(e8m4_narrative_is_on  == false, 1);
	f_blip_ai_cui(gr_e8_m4_ff_all, "navpoint_enemy");
	print("blip enemies complete");
end

script static void f_e8_m4_blip_last_enemies
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 3, 1);
	sleep(30 * 1.5);
	sleep_until(e8m4_narrative_is_on  == false, 1);
	e8m4_narrative_is_on = true;
	if(ai_living_count (gr_e8_m4_ff_all) >= 1)then
		begin_random_count (1)
			//vo_glo_remainingcov_01();
			//vo_glo_remainingcov_02();
			vo_glo_remainingcov_03();
			vo_glo_remainingcov_04();
			//vo_glo_remainingcov_05();
		end
		print("blip enemies on");
		f_blip_ai_cui(gr_e8_m4_ff_all, "navpoint_enemy");	
	end
	e8m4_narrative_is_on = false;
end

script static void f_e8_m4_right_door_internal
	//sleep_until (LevelEventStatus("e8_m4_right_door_internal"), 1);
	print("-----SO YEAH THE DOORS SHOULD OPEN------");	   
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 2, 1); 
	sleep(30 * 1.2);
	print("-----starting right door------");	 
  
  thread(e8_m4_vo_interior_a());
  		//DIALOG: Miller : Movement from the structure! More bad guys inbound, Spartans.
  ai_place(sq_e8m4_hangar_scrubs_1);
  ai_place(sq_e8m4_hangar_scrubs_2);
  ai_place(sq_e8m4_hangar_elite_1);
  ai_place(sq_e8m4_hangar_elite_2);
	
	thread(f_e8_m4_track_internal_enemies());
	thread(f_e8m4_blip_goto_until_trigger_or_timer(lz_9, marines_open_right_door_vol, 10)); 																									// blipping enemies to show what door opened
	//f_blip_object_cui(lz_9, "navpoint_goto");	// blipping enemies to show what door opened ------------------------------xxx delete if no errors
	device_set_position_track( dm_hangar_door_2, 'any:idle', 1 );
	//sound_impulse_start( 'sound\environments\multiplayer\factory\ambience\objects\factory_large_int_door_open_in', dm_hangar_door_2, 1);
	device_animate_position( dm_hangar_door_2, 1, 3.5, 1.0, 1.0, TRUE );
  sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 8, 1);
	b_e8_m4_internal_breached = TRUE; 
	sleep_until(volume_test_players(Marines_open_left_door_vol) == true, 1);													// players inside, door to exterior (and switch) opens
	//cs_go_to_nearest(sq_e8_m4_marines_1, true, ps_e8_m4_marines.p6);
	//sleep(3);
	print("open the doooooooor");
	thread(f_e8m4_remove_marines());
	device_set_position_track( dm_hangar_door_1, 'any:idle', 1 );
	//sound_impulse_start( 'sound\environments\multiplayer\factory\ambience\objects\factory_large_int_door_open_in', dm_hangar_door_1, 1);
	device_animate_position( dm_hangar_door_1, 1, 3.5, 1.0, 1.0, TRUE );;
	print("helllooo");
	sleep_until (ai_living_count (gr_e8_m4_ff_all) <= 0, 1);
	print("all dead");
	sleep_s(2);
	print("slept");
	e8_m4_vo_internal_button_1();
	print("internal one should have played");
	sleep(30 * 0.6);
	b_end_player_goal = true;
end	

script static void f_e8m4_blip_goto_until_trigger_or_timer(scenery sc_point, trigger_volume tv_volume, real num_time)
	f_blip_object_cui(sc_point, "navpoint_goto");	
	sleep_until(volume_test_players(tv_volume), 1, 30 * num_time);
	f_unblip_object_cui(sc_point);
end

//======================================OBJECTIVES===================================================
//obj 1
script static void f_e8_m4_obj1_txt		
    sleep_until (LevelEventStatus("e8_m4_clear_the_prision"), 1);		//assault lz												
		sleep_s(3);
		thread(f_new_objective(e8_m4_clear_the_prision));  
		sleep_s(3);
end

//obj2
script static void f_e8_m4_obj2_txt		
		sleep_until (LevelEventStatus("e8_m4_open_the_forerunner_gate"), 1);	//open the door													
		sleep_s(3);
		//cinematic_set_title_delayed(ch_8_4_2, 3);
		//sleep_s(5);
		thread(f_new_objective(e8_m4_open_the_forerunner_gate));
end

script static void f_e8_m4_obj3_txt																	
		sleep_until (LevelEventStatus("e8_m4_breach_the_prision"), 1);		//enter the structure
		thread(f_new_objective(e8_m4_breach_the_prision));
		sleep_s(3);
end


script static void f_e8_m4_obj4a_txt														 		
		//sleep_until(volume_test_players (vol_pelican_cap), 1);
		thread(f_new_objective(e8_m4_disable_the_locks));  // disable the jammers
		sleep_s(1);
		thread(e8_m4_vo_breach_the_prision());
		sleep_s(3);
	end
	
script static void f_e8_m4_obj4b_txt
		thread(f_new_objective(e8_m4_move_to_transponder));  // move to the bird
		sleep_s(1);
		f_blip_object_cui (e8_m4_capped_pelican , "navpoint_goto");
		sleep_s(1);
	end
		
		
script static void f_e8_m4_obj5a_txt	
		sleep_until (LevelEventStatus("e8_m4_clear_the_area"), 1);	//clear area
		sleep_until(volume_test_players(player_in_diamond) == true, 1);		
		thread(e8_m4_vo_nobody_standing());	
		thread(f_new_objective(e8_m4_clear_the_area));
	end
	
script static void f_e8_m4_obj4_txt		
												 		
		sleep_until (LevelEventStatus("e8_m4_search_for_life"), 1);		//break tethers
		thread(f_new_objective(e8_m4_search_for_life));
		//thread(e8_m4_vo_lz_3());

end

//obj5
script static void f_e8_m4_obj5_txt															 		
		sleep_s(2);
		thread(f_new_objective(e8_m4_get_to_lz));
end

//obj6
script static void f_e8_m4_obj6_txt																
		sleep_until (LevelEventStatus("e8_m4_escape_on_pelican"), 1);		//board pelican
		sleep_s(3);
		thread(f_new_objective(e8_m4_escape_on_pelican));
		sleep_s(3);
end

script static void f_e8_m4_obj7_txt														//get to the pad		
		sleep_until (LevelEventStatus("e8_m4_Get_to_pad"), 1);	
		sleep_s(3);
end



// =============================================================================
// ====== COUNTER VO'S ===========================================================
// =============================================================================


script static void e8_m4_vo_call_temp() 

e8m4_narrative_is_on = TRUE;  
dprint ("Narrative Fill"); 

//start_radio_transmission("miller_transmission_name"); 
sleep_s(5); 

e8m4_narrative_is_on = FALSE; 

//end_radio_transmission(); 
end


script static void e8m4_vo_internal
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	//thread(f_music_e08m4_narr_in());
	vo_e8m4_narrative_in();
	print("e8m4_vo_internal played");
	//PALMER:  Alright, Crimson, A captured Elite offered up the crystal ball they've been using to track us, and it’s is in there somewhere.
/*	e8_m4_vo_call_temp();
	dprint("PALMER:  Alright, Crimson, A captured Elite offered up the crystal ball they've been using to track us, and it’s is in there somewhere.");	*/
	
end

script static void e8m4_secure_area
	//e8m4_vo_secure_area();								//tjp - moved into puppeteer
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	e8m4_narrative_is_on = TRUE;
	vo_glo15_palmer_shoot_02();
			// Palmer : Weapons hot.
	//	vo_e8m4_onto_platform();
			// Palmer : Secure the area.
	e8m4_narrative_is_on = FALSE;
end


script static void e8_m4_vo_interior_a
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_movement_structure();
	//DIALOG: Miller : Movement from the structure! More bad guys inbound, Spartans.
	print("e8_m4_vo_interior_a played");
end

script static void e8_m4_vo_internal_button_1
	print("e8_m4_vo_internal_button_1 play");
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_once_cleared();
	print("e8_m4_vo_internal_button_1 played");
	//vo_e8m4_show_button ();
end

script static void e8_m4_vo_bread_box
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_give_waypoint();

/*	e8_m4_vo_call_temp();
	dprint("Miller : Area's clear, Commander.");*/
	print("e8_m4_vo_bread_box played");
end

script static void e8_m4_vo_door_interior_d
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_prison_area());
	vo_e8m4_prison_area();
	//DIALOG: MILLER  Commander, getting some interference around Crimson's uplink. Could explain why we haven't been able to get drones or scans into that location.
	//DIALOG: PALMER  Might be looking at jammers, Crimson. And you know I don't like jammers.
	print("e8_m4_vo_door_interior_d played");
end

script static void e8_m4_vo_breach_the_prision
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_jammers_destroy());
	vo_e8m4_jammers_destroy();
	b_e8_m4_jammers_activate = true;
// Miller : There we go. I've got three energy signatures matching known Covenant signal jammers.
// Palmer : Good work, Miller. Mark 'em for Crimson.
	print("e8_m4_vo_breach_the_prision played");
end

script static void e8_m4_vo_nobody_standing
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_clear_area();
	//DIALOG: // Palmer : Nobody left standing, got it Crimson?
	print("e8_m4_vo_nobody_standing played");
end

script static void e8_m4_vo_donut_dr_a_done
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_jammers_destroy_02());
	vo_e8m4_jammers_destroy_02();
			// Miller : That did it!
	print("e8_m4_vo_donut_dr_a_done played");
end

script static void f_e8m4_vo_tansponder
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_jammers_destroy_03();
			// Miller : UNSC transponder, in the chamber adjacent to Crimson's position. Marking it now.
	print("e8_m4_vo_donut_dr_a_done played");
	thread(f_e8_m4_obj4b_txt());
end

script static void e8_m4_vo_bird
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_e8m4_unblip_bird());
	vo_e8m4_covenant_intelligence();
			//DIALOG:  PALMER (CONT'D)  Who the hell gave the Covenant one of our birds?!? Miller, ID!
			// etc
	print("e8_m4_vo_lz_3 played");	
end

script static void f_e8m4_unblip_bird
	sleep(30 * 2);
	f_unblip_object_cui (e8_m4_capped_pelican);
end

script static void e8_m4_vo_lz_3
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_covenant_intelligence());
	vo_e8m4_covenant_intelligence_2();
			// Miller : Those energy tethers are tied into the Pelican's comm systems. Break them.
	print("e8_m4_vo_lz_3 played");	
end

script static void e8_m4_vo_lzdr_switch_on
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_clear_area_02());
	vo_e8m4_clear_area_02();
		// Miller : Area's clear.
		// Miller : Dalton, Crimson needs a ride, and I could use some explosives to erase a problem.
		// Dalton : Happy to oblige on both counts. Inbound on Crimson’s position now.
	print("e8_m4_vo_lzdr_switch_on played");	

end




script static void e8_m4_vo_phantoms_inbound
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	
	vo_e8m4_board_pelican();
	//DIALOG:  "Dalton: Phantom's in position."
	print("e8_m4_vo_phantoms_inbound played");	

end

		
script static void e8_m4_vo_get_to_lz
	sleep_until(e8m4_narrative_is_on == FALSE, 1);
	vo_e8m4_board_pelican_02();
	//DIALOG:  Miller : Dalton, ground’s clear and Crimson’s ready for evac.
	print("e8_m4_vo_get_to_lz played");	

end


script static void e8_m4_vo_end_mission
	//sleep_until(e8m4_narrative_is_on == FALSE, 1);
	thread(f_music_e08m4_dusts_off());  // TURNED OFF FOR NOW TO TEST IF ITS BLOCKING vo
	vo_e8m4_board_dusts_off();
	//DIALOG:  Miller : Spartans are clear.
	print("e8_m4_vo_end_mission played");	

end


script static void f_e8_m4_vo_phantom_5_call
	sleep_s(3);
	sleep_until(e8m4_narrative_is_on == false, 1);
	e8m4_narrative_is_on = true;
	vo_glo_phantom_04();     // DALTON : Phantom inbound
//	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G04_60" );
	e8m4_narrative_is_on = false;
	//thread(f_music_e08m4_finish());
	
end

script static void f_e8_m4_vo_hunter_phantom
	sleep_s(1);
	sleep_until(e8m4_narrative_is_on == false, 1);
	e8m4_narrative_is_on = true;
	thread(vo_glo_phantom_09());     // MILLER : Uh-oh. Phantom inbound!
	sleep(15);
	hud_play_pip_from_tag( "levels\dlc\shared\binks\SP_G04_60" );
	sleep_s(1);
	e8m4_narrative_is_on = false;
end

script static void f_e8m4_nohurtfriendlyvehicles
  print ("player vehicles are immune");
  repeat
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(0)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(1)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(2)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(3)), true);
  until (b_game_ended == true, 1);            
end