//vo_e4m4_secure() 
						// Palmer : Crimson, secure the area. I don't want any surprises. Miller, confirm Roland found 'Mdama. 
						// Miller : Commander, we should secure the-- 
						// Palmer : Yeah, I took Tactics 101, Miller. Secure the area, Spartans.
// f_load_drop_pod (dm_e4_m4_drop_rail_1, sq_e4_m4_waves_1, derpship, false)

// ai_place_in_limbo(sq_e4_m4_switch_guard_60)
// f_load_drop_pod (dm_drop_21, sq_e4_m4_switch_guard_60, derpship, false);
// ai_place_in_limbo(sq_e4_m4_guards_4)
// f_load_drop_pod (dm_drop_13, gr_e4_m4_waves_4, derpship, false);


/// ==============GLOBAL ==================================================================
global short s_e4m4_state = 0;												// tjp - marks progress through scenario
global boolean b_e4m4_conch = FALSE;									// WHOEVER HOLDS THE CONCH GETS TO SPEAK

//===============SCURVE E4_M4 FIREFIGHT SCRIPT ========================================================
script startup scurve_e4_m4
	//Start the intro
	sleep_until (LevelEventStatus("e4_m4"), 1);
	print ("****************** STARTING E4 M4 *********************");
	switch_zone_set (e4_m4);
	mission_is_e4_m4 = true;
	thread(f_music_e4m4_mission_start());
		
	b_wait_for_narrative = true;
	ai_ff_all = gr_e4_m4_ff_all;
	//dm_droppod_1= _droprail_01;
	dm_droppod_1 = dm_drop_junc_1;											// top junc ledge
	dm_droppod_2 = dm_drop_junc_2;											// junc right (elites)
	dm_droppod_3 = dm_drop_junc_3;											// junc left  (grunts)
	dm_droppod_4 = dm_drop_junc_4;											// junc gate high
	dm_droppod_5 = dm_e4_m4_drop_rail_5;								// tjp - changed back later
	
	thread(f_start_player_intro_e4_m4());
	
	//start the first event script
	thread (f_start_events_e4_m4_1());
	
	//start all the event scripts
	thread (f_start_all_events_e4_m4());




//// ================================================== AI ==================================================================
//
////	ai_ff_phantom_01 = sq_ff_phantom_01;
////	ai_ff_phantom_02 = sq_ff_phantom_02;
////	ai_ff_sq_marines = sq_ff_marines_3;
//
//	
////============= OBJECTS ==================================================================
////set crate names

	f_add_crate_folder(cr_cave_shield);
	f_add_crate_folder(cr_e1_m5_base_cov_cover); 												//Cov Cover and fluff on the back bridge	
	f_add_crate_folder(cr_e1_m5_unsc_gun_racks); 												//Cov Cover and fluff on the back bridge
	f_add_crate_folder(eq_e1_m5_unsc_ammo);
	f_add_crate_folder(cr_e1_m5_cov_misc); 															//Cov Cover and fluff on the back bridge
	f_add_crate_folder(cr_e1_m5_unsc_intro_weapons); 										//gun racks by the intro
	f_add_crate_folder(cr_e1_m5_cov_cover_back); 												//Cov crates at the very back on the right	
	f_add_crate_folder(cr_e1_m5_cov_energy_cover); 											//energy barrier shields
	f_add_crate_folder(wp_e1_m5); 																			//long range weapons	
	f_add_crate_folder(cr_e4_m4_objectives); 														//computers
	f_add_crate_folder(dm_e4_m4);
	f_add_crate_folder(dc_e4_m4);
	f_add_crate_folder(cr_e1_m5_cov_cover); 														//cov crates all around the main area	
	f_add_crate_folder(cr_e4_m4_weapon_racks); 													//cov crates all around the main area		
	f_add_crate_folder(dm_e4_m4_drop_rails); 														//cov crates all around the main area		
	f_add_crate_folder(v_e4_m4_shade);
	f_add_crate_folder(dm_e4_m4_doors);
	f_add_crate_folder(cr_e4_m4_crates);																//add'l e4m4 specific cover
	f_add_crate_folder(e4m4_lz);

//set spawn folder names
	//firefight_mode_set_crate_folder_at(spawn_points_0, 90); 					//spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_90, 90);
	//firefight_mode_set_crate_folder_at(spawn_points_1, 91); 					//spawns in the front building
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_91, 91);
	//firefight_mode_set_crate_folder_at(spawn_points_2, 92); 					//spawns in the back building
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_92, 92);
	//firefight_mode_set_crate_folder_at(spawn_points_3, 93); 					//spawns by the left building
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_93, 93);	
	//firefight_mode_set_crate_folder_at(spawn_points_4, 94); 					//spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_94, 94);
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); 						//spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(sc_e4_m4_spawn_96, 96); 					//spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); 						//spawns in the back on the hill (facing the back)
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); 						//spawns in the very back facing down the hill
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); 						//spawns in the very back facing down the hill	
//	
//set objective names
	firefight_mode_set_objective_name_at(e4_m4_door_switch1, 41);	
	firefight_mode_set_objective_name_at(e4_m4_door_switch2, 42); 	
	firefight_mode_set_objective_name_at(e4_m4_gift, 43); 					
	
//set LZ spots	
	firefight_mode_set_objective_name_at(lz_0, 50); 										//objective in the main spawn area
	firefight_mode_set_objective_name_at(lz_1, 51); 										//objective in the middle front building
	firefight_mode_set_objective_name_at(lz_2, 52); 										//objective in the middle back building
	firefight_mode_set_objective_name_at(lz_3, 53); 										//objective in the left back area
	firefight_mode_set_objective_name_at(lz_4, 54); 										//objective in the right in the way back
	firefight_mode_set_objective_name_at(lz_e4m4_brain, 55); 										//objective in the back on the forerunner structure
	firefight_mode_set_objective_name_at(lz_6, 56); 										//objective in the back on the smooth platform
	firefight_mode_set_objective_name_at(lz_7, 57); 										//objective right by the tunnel entrance
	firefight_mode_set_objective_name_at(lz_8, 58); 										//objective right by the tunnel entrance
	firefight_mode_set_objective_name_at(lz_9, 59); 										//objective right by the tunnel entrance	
//		
////set squad group names
//
	firefight_mode_set_squad_at(gr_e4_m4_guards_1, 1);									//initially spawned, in gravel pit
	firefight_mode_set_squad_at(gr_e4_m4_guards_2, 2);	
	firefight_mode_set_squad_at(gr_e4_m4_guards_3, 3);	
	firefight_mode_set_squad_at(gr_e4_m4_guards_4, 4); 
	firefight_mode_set_squad_at(gr_e4_m4_guards_5, 5); 
	firefight_mode_set_squad_at(gr_e4_m4_guards_6, 6); 
	firefight_mode_set_squad_at(sq_e4_m4_switch_guard_60, 60); 					//grunts & jax, drop pod gravel pit
	firefight_mode_set_squad_at(sq_e4_m4_switch_guard_61, 61); 					//grunts & jax, drop pod side console area

	firefight_mode_set_squad_at(gr_e4_m4_waves_1, 81);									//elites & grunts, drop pod prior to first gate
	firefight_mode_set_squad_at(gr_e4_m4_waves_2, 82);									//elites & grunts, drop pod prior to first gate
	firefight_mode_set_squad_at(gr_e4_m4_waves_3, 83);									//grunts, drop pod above junction
	firefight_mode_set_squad_at(gr_e4_m4_waves_4, 84);									//elites, gravel pit drop squad
	firefight_mode_set_squad_at(gr_e4_m4_waves_5, 85);									//elites & grunts, 
	firefight_mode_set_squad_at(gr_e4_m4_waves_6, 86);									//elites & grunts, gravel pit drop pod
//	firefight_mode_set_squad_at(gr_e4_m4_waves_9, 89);				
//	firefight_mode_set_squad_at(gr_e4_m4_allies, 51);		
//			
////	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
////	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
////	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
////	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
////	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
////	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
////	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge
//
//	firefight_mode_set_squad_at(sq_e4_m4_phantom_1, 21); //phantom 1
//	firefight_mode_set_squad_at(sq_e4_m4_phantom_2, 22); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;
//======== MAIN SCRIPT STARTS ==================================================================
	sleep(30 * 5);
	object_create (e1_m5_spire);
	device_set_position (e1_m5_spire, 1);

	object_set_function_variable(cr_cave_shield1,"shield_on",1,1);
end


//========STARTING E4 M4==============================

script static void f_start_all_events_e4_m4
//	sleep_until (LevelEventStatus("start_e4_m4_1"), 1);
	print ("STARTING all events");
	
	thread (f_end_events_e4_m4_1());
	print ("ending e4_m4_1");

	//thread (f_start_events_e4_m4_2());
	//print ("starting e4_m4_2");
	
	thread (f_end_events_e4_m4_2());
	print ("ending e4_m4_2");
	
	thread (f_start_events_e4_m4_3());
	print ("starting e4_m4_3");
	
	thread (f_end_events_e4_m4_3());
	print ("ending e4_m4_3");
	
	thread (f_start_events_e4_m4_4());
	print ("starting e4_m4_3");
	
	thread (f_end_events_e4_m4_4());
	print ("ending e4_m4_4");
	
	thread (f_start_events_e4_m4_5());
	print ("starting e4_m4_5");
	
	thread (f_e4m4_door_arrival());																														// tjp
	
	thread(f_e4m4_junc_gunner());																															// tjp
	
	thread(f_start_events_end_of_bridge());																										// tjp
	
	thread(f_e4m4_interfaces());
//	thread (f_start_events_e4_m4_6());
//	print ("starting e4_m4_6");
//	object_hide (lz_1, true);

	b_no_pod_blips = true;															// tjp - remove those *unsightly* drop pod blips

	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e4_m4.scenery", 
															"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");

end

script static void f_start_events_e4_m4_1

	sleep_until (LevelEventStatus("start_e4_m4_1"), 1);
	print ("STARTING e4_m4_1");

	b_wait_for_narrative_hud = true;

	sleep_until (b_players_are_alive(), 1);
	
	sleep_s (2);
	
	thread(f_music_e4m4_playstart_vo()); 
	b_e4m4_conch = true;
	vo_e4m4_playstart(); // PIP VO
						// Miller : Roland?  Did you follow them that time?
						// Roland : Yep.  A few more jumps like this and I might be able to extrapolate how the whole system works.
						// Palmer : Extrapolate later.  Give Miller their loc now.  We've got an Op to run.
	
	sleep(15);

	thread (f_e4_m4_blip_1());

	thread(f_music_e4m4_portalin_vo()); 
	vo_e4m4_portalin();
						// Palmer : Miller, get me a marker on 'Mdama.  I want to know what he's got with his Didact's Gift thing, and where he's got it.
						// Roland : I've found him!  There you go.  I tell ya, I don't know why I run a starship when running Ops is so much more fun.
						// Palmer : Roland, clear the line, please.  Let the Spartans talk.
	b_e4m4_conch = false;
	//b_wait_for_narrative_hud = false;
	if(s_e4m4_state < 1)then																			// it's possible for players to have already reached the doors by now
		f_new_objective (ch_e4_m4_1);
									//"FOLLOW 'Mdama"
	end

end

script static void f_e4_m4_blip_1
	//this is to time the blip just right for the middle of a VO line
	print ("blip 1");
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00100'));

	sleep_s (2);
	sleep_s (2.5);
	
	b_wait_for_narrative_hud = false;																
	ai_place(sq_e4_m4_jul);
end

script static void f_e4m4_door_arrival																				//tjp - once players see closed door
	sleep_until (volume_test_players (tv_e4_m4_door));
	sleep(10);
	if(ai_living_count(sq_e4_m4_jul) > 0)then
		thread(f_blip_ai_cui (sq_e4_m4_jul, ""));
		ai_erase(sq_e4_m4_jul);
	end
	s_e4m4_state = 1;																														// scenariostate -  door reached
	thread(f_e4m4_door_reached_convo());
	thread(f_e4m4_stalling());																									// thread stalling vo sequence
	thread(f_e4m4_start_nmw());																									// enable trigger that will advance objectives to nmw
	thread (f_blip_object_cui (lz_2, ""));
end
// dm_e4_m4_switch1 -2.101612, -26.090677, 2.280033

script static void f_end_events_e4_m4_1
	sleep_until (LevelEventStatus("end_e4_m4_1"), 1);
	print ("ENDING e4_m4_1");
	thread(f_music_e4m4_encounter_1_start()); 
	
	//object_hide (lz_2, true);
	//tell players to kill the remaining enemies, then mark them once there are 5 left
	//vo_glo_remainingcov_03();
	//cinematic_set_title (swarm);
	b_wait_for_narrative_hud = true;
	
	sleep_until (ai_living_count (gr_e4_m4_ff_all) <= 5, 1);
	thread(f_music_e4m4_mark_stragglers()); 
	print ("marking last few guys");
	b_wait_for_narrative_hud = false;
end

script static void f_e4m4_door_reached_convo
	sleep_until(b_e4m4_conch == false);
	b_e4m4_conch = true;
	vo_e4m4_encounterdoor();
					// Miller : Mdama's through there.
					// Palmer : Miller, find Crimson a way through those doors.
	b_e4m4_conch = false;
end

script static void f_e4m4_markingcontrols_vo
	sleep_until(b_e4m4_conch == false);
	b_e4m4_conch = true;
	vo_e4m4_markingcontrols();
					// Miller: Just a second…okay.  Found the controls for the door.  Marking them now.
	b_e4m4_conch = false;
end

script static void f_e4m4_stalling
	sleep_until (LevelEventStatus("e4m4o1_stall"), 1);
	sleep_until(b_e4m4_conch == false);
	b_e4m4_conch = true;
	sleep(30);
	dm_droppod_2 = dm_drop_05;																									// gravel pit
	vo_glo_stalling_10();
						// Miller : Ah! Here we go, Crimson-- No. Wait.That's not right.
						// Palmer : What are you even doing?
	b_e4m4_conch = false;
end

script static void f_e4m4_start_nmw
	sleep_until (volume_test_players ("tv_e4_m4_big_central"), 1);
	b_end_player_goal = true;																										// advance objectives to nmw
	device_set_power(dm_bridge_cover_1,1);
	device_set_power(dm_bridge_cover_2,1);
	sleep_forever();																
end
script static void f_e4m4_junc_gunner
	sleep_until ((volume_test_players (tv_e4_m4_door)) or 
							(volume_test_players (tv_e4_m4_junc_plat)));
	ai_place(sq_e4_m4_junc_gunner);
end

script command_script cs_e4m4_junc_gunner
	cs_go_to_vehicle(e4m4_junc_shade, "");
end

//==flip the switches
script static void f_e4m4_interfaces
	//onLevelLoaded, set and hide interface
	sleep(30 * 5);
	device_set_position_track( dm_e4_m4_switch1, 'device:position', 0 );
	device_set_position_track( dm_e4_m4_switch2, 'device:position', 0 );
	sleep(10);
	device_animate_position (dm_e4_m4_switch1, 1, 2, 1, 0, 0);									// big to little (1 == small)
	device_animate_position (dm_e4_m4_switch2, 1, 2, 1, 0, 0);									// big to little (1 == small)
	sleep(10);
	object_hide(dm_e4_m4_switch1, true);
	object_hide(dm_e4_m4_switch2, true);
	print("-------------------------------------------------------- switches hidden.. ?");
	//later, animate on
	sleep_until (LevelEventStatus("start_e4_m4_2"), 1);													
	s_e4m4_state = 2;																														// scenariostate - marking consoles

	print ("STARTING start_e4_m4_2");
	thread(f_music_e4m4_encounter_2_start()); 
	
	sleep_s (2);																																
	thread(f_music_e4m4_encounter_door_vo()); 
	f_e4m4_markingcontrols_vo();
					// Miller : Just a second…okay.  Found the controls for the door.  Marking them now. 
	device_animate_position (dm_e4_m4_switch1, 0, 2, 1, 0, 0);									// little to big
	device_animate_position (dm_e4_m4_switch2, 0, 2, 1, 0, 0);									// little to big
	object_hide(dm_e4_m4_switch1, false);
	object_hide(dm_e4_m4_switch2, false);
	sleep(2);
	//turn on the switches
	thread (f_e4_m4_animate_switches (e4_m4_door_switch1, dm_e4_m4_switch1));
	thread (f_e4_m4_animate_switches (e4_m4_door_switch2, dm_e4_m4_switch2));
	sleep(18);
	b_end_player_goal = true;																										//advance objectives (blip consoles)
	f_new_objective (ch_e4_m4_2);
					// "OPEN THE DOORS"
	sleep_until (s_all_objectives_count == 1);
	print ("one switch down");
	//f_e4_m4_animate_switches (dm_e4_m4_switch2);
	thread(f_music_e4m4_switch_1_pressed()); 
	vo_e4m4_oneswitch();
						// Miller : That's one switch.  Hit the other to open the door.
	sleep_until (s_all_objectives_count == 2);
	object_hide (lz_2, false);
	thread(f_music_e4m4_switch_2_pressed()); 
	print ("two switches down");
	
	//pausing for drama
	sleep_s (3);
	s_e4m4_state = 3;																														// scenariostate - doors open
	f_objective_complete();
	b_wait_for_narrative_hud = true;
	thread(f_music_e4m4_doorisopen_vo()); 
	vo_e4m4_doorisopen();
						// Miller : Door's open.
						// Palmer : Move it, Crimson!  Do not let 'Mdama get away! 
	b_wait_for_narrative_hud = false;
	f_new_objective (ch_e4_m4_3);
						// "FOLLOW 'Mdama"
end

script static void f_e4_m4_animate_switches (device control, device devic)
	device_set_power (control, 1);
	sleep_until (device_get_position (control) > 0, 1);
	
	print ("animating device");
	//device_set_position (device, 1);

//animating -- total hack, delete when animation name is device position
	device_set_position_track( devic, 'device:position', 1 );
	device_animate_position ( devic, 1, 2, 1, 0, 0);
	
	sleep_until (device_get_position (devic) > .9, 1);
//	device_set_power (device, 0);
	object_hide (devic, true);
	print ("device hid");
end

script static void f_end_events_e4_m4_2
	sleep_until (LevelEventStatus("end_e4_m4_2"), 1);
	print ("ENDING e4_m4_2");
	thread(f_e4_m4_marker2());
	thread(f_music_e4m4_encounter_2_end()); 
end

script static void f_e4_m4_marker2
	sleep_until (LevelEventStatus("e4_m4_hide_marker2"), 1);
	print ("hide marker 2");
	object_destroy (lz_2);
end

//== through the doors
script static void f_start_events_e4_m4_3																	// LOCATION ARRIVAL start
	sleep_until (LevelEventStatus("start_e4_m4_3"), 1);
	print ("STARTING start_e4_m4_3 - Bridge");
	print ("STARTING start_e4_m4_3");
	print ("STARTING start_e4_m4_3 - Bridge");
	print ("STARTING start_e4_m4_3");
	print ("STARTING start_e4_m4_3 - Bridge");
	print ("STARTING start_e4_m4_3");
	print ("STARTING start_e4_m4_3 - Bridge");
	print ("STARTING start_e4_m4_3");
	
	s_e4m4_state = 4;																												// scenariostate - start bridge
	
	dm_droppod_4 = dm_drop_04;																							// tjp
	dm_droppod_3 = dm_drop_13;																							// tjp
	
	thread(f_music_e4m4_encounter_3_start()); 
	
	ai_place (sq_e4_m4_shades);
	ai_place (sq_e4_m4_bridge_bishops);
	//ai_place_with_shards (sq_e4_m4_bridge_turrets);
	
	thread (f_e4_m4_failsafe());

	sleep_s (2);
	
	device_set_position (e4_m4_doors, 1);
	thread (camera_shake_all_coop_players( .1, .3, 3, 0.1));
	print ("opening doors");
	//doors are open now
	//place the shades and the bishops/fore turrets
	
	sleep_until (volume_test_players (tv_e4_m4_turrets), 1);
	
	//sleep_s (1);
	thread(f_e4_m4_spawn_turret_1());																				// ai_place_with_shards (sq_e4_m4_bridge_turret_1)
	thread(f_e4_m4_spawn_turret_2());																				// ai_place_with_shards (sq_e4_m4_bridge_turret_2)

	if(ai_living_count(ai_ff_all) < 12)then
		ai_place(sq_e4_m4_shade_bros);
	end

	sleep(30 * 2);
	thread(f_music_e4m4_turret_vo()); 
	thread(f_e4_m4_turret_vo());
	sleep_until (volume_test_players (tv_e4_m4_knights), 1);
	print ("surprise knights spawning in");
	thread(f_music_e4m4_suprise_knights_spawn()); 
	ai_place_in_limbo (sq_e4_m4_knight_surprise.1);
	
	thread(f_e4_m4_rolling_encounter_keeper());
	thread(f_e4_m4_state_7());
end

script static void f_e4_m4_spawn_turret_1
	ai_place_with_shards (sq_e4_m4_bridge_turret_1);
	print("_____________________________________trying to shard spawn turret 1");
end
script static void f_e4_m4_spawn_turret_2
	ai_place_with_shards (sq_e4_m4_bridge_turret_2);
	print("_____________________________________trying to shard spawn turret 2");
end

script static void f_e4_m4_state_7
	sleep_until (volume_test_players (tv_e4_m4_state_7), 1);
	f_e4m4_tunnel_spawn();
	s_e4m4_state = 7;																												// scenariostate - upper and lower yard cleared
	if(ai_living_count (sg_e4m4_junction) > 0) then
		ai_kill(sg_e4m4_junction);
	end
end

script static void f_e4_m4_rolling_encounter_keeper				// manages populatation ahead of player (since no gates from here onward)
	// s_e4m4_state guide: 
	// 4 == on bridge
	// 5 == end of bridge
	// 6 == landing / failsafe zone
	// 7 == tunnels
	// 8 == promeths
	sleep_until(ai_living_count(ai_ff_all) < 17);
	thread(f_e4_m4_bridge_elites());
	
	sleep_until(ai_living_count(ai_ff_all) < 15);
	if(s_e4m4_state < 6)then
		ai_place(sq_e4_m4_lower_yard_rabble.near);
	elseif(s_e4m4_state == 6)then
		ai_place(sq_e4_m4_lower_yard_rabble.far);
	elseif(s_e4m4_state > 6)then
		thread(f_e4_m4_lower_yard_elites());
		sleep_forever();
	end

	sleep_until(ai_living_count(ai_ff_all) < 17);
	if(s_e4m4_state < 7)then
		ai_place(sg_e4m4_lower_stoppers);
	else
		thread(f_e4_m4_lower_yard_elites());
		sleep_forever();
	end

	sleep_until(ai_living_count(ai_ff_all) < 15);
	if(s_e4m4_state < 6)then
		ai_place(sq_e4_m4_lower_yard_rabble_2.near);
	elseif(s_e4m4_state == 6)then
		ai_place(sq_e4_m4_lower_yard_rabble_2.far);
	elseif(s_e4m4_state > 6)then
		thread(f_e4_m4_lower_yard_elites());
		sleep_forever();
	end
	
	sleep_until(ai_living_count(ai_ff_all) < 12);
	thread(f_e4_m4_lower_yard_elites());

	sleep_until(ai_living_count(ai_ff_all) < 9);
	f_e4m4_tunnel_spawn();
end

script static void f_e4_m4_bridge_elites
 	ai_place_in_limbo (sq_e4_m4_bridge_elites);
 	sleep(3);
	f_load_drop_pod (dm_drop_13, sq_e4_m4_bridge_elites, derpship, false);
end
script static void f_e4_m4_lower_yard_elites
 	if(ai_living_count(sq_e4_m4_lower_yard_elites) <= 0)then
	 	ai_place_in_limbo (sq_e4_m4_lower_yard_elites);
	 	sleep(3);
		f_load_drop_pod (dm_drop_04, sq_e4_m4_lower_yard_elites, hms_derpship, false);
	end
end
script static void f_e4_m4_turret_vo
	sleep_until (ai_living_count (sq_e4_m4_bridge_bishops) > 0, 1, 30 * 15);
		print ("turret VO triggered");
		vo_e4m4_watcherturrets();
						// Miller : Watchers deploying turrets!
						// Palmer : Dammit!  Do not let them slow you down! 
end

script static void f_end_events_e4_m4_3
	sleep_until (LevelEventStatus("end_e4_m4_3"), 1);
	//sleep (30);
	object_destroy (lz_1);
	thread(f_music_e4m4_encounter_3_end()); 
end

script static void f_start_events_end_of_bridge																	// LOCATION ARRIVAL start
	sleep_until (LevelEventStatus("e4m4_state_5"), 1);
	s_e4m4_state = 5;																															// scenariostate - end bridge
end

script static void f_e4_m4_failsafe
// gmu -- when players hit the trigger they will automatically end 'location arrival'
	sleep_until (volume_test_players (tv_e4_m4_failsafe));
	s_e4m4_state = 6;																															// scenariostate - lower yard
	if firefight_mode_goal_get() == 4 then
		print ("failsafe enabled--- killing a to b thread");
		b_end_player_goal = true;																										//advance objectives
	else
		print ("no need to fail safe, ending");
	end
end

//==go get Jul
script static void f_start_events_e4_m4_4
	sleep_until (LevelEventStatus("start_e4_m4_4"), 1);
	print ("STARTING start_e4_m4_4");
	thread(f_music_e4m4_encounter4_start()); 
	//might have to bypass this if players run too far
	
	//don't blip the next objective to encourage players to stay and fight the forerunners, but if they move on there is a failsafe
	b_wait_for_narrative_hud = true;
	thread (f_e4_m4_blip_failsafe());
	thread (f_e4_m4_hide_marker());
	thread (f_e4_m4_through_tunnels());
	thread(f_e4_m4_fore_end());
	vo_e4m4_almostgothim();
						// Miller : We've almost got him, Commander! 
	
	vo_e4m4_tunnels();
						// Palmer : Dalton!
						// Dalton : Commander?
						// Palmer : I need some targeted air strikes, preferably that I can fire at will.
						// Dalton : That can be arranged.  Suppressive Fire Drone 10-56 is all yours. 
end

script static void f_e4_m4_blip_failsafe
	//if players move on before killing all the forerunner guards or kill all the guards, turn on the blip for the location arrival
	print ("blip failsafe");
	sleep_until (ai_living_count (ai_ff_all) == 0 or volume_test_players (tv_e4_m4_explosions2), 1);
	s_e4m4_state = 8;																												// almost prometheans
	print ("setting blips active because of failsafe or all enemies dead");
	b_wait_for_narrative_hud = false;
end

script static void f_e4m4_tunnel_spawn
	if(ai_living_count(sg_tube) == 0)then
		if(ai_living_count(gr_e4_m4_ff_all) < 4)then
			ai_place(sq_e4_m4_tube_alpha);
			ai_place(sq_e4_m4_tube_beta);
			ai_place(sq_e4_m4_tube_scrubs);
		elseif(ai_living_count(gr_e4_m4_ff_all) < 12)then
			ai_place(sq_e4_m4_tube_alpha);
			ai_place(sq_e4_m4_tube_beta);
		elseif(ai_living_count(gr_e4_m4_ff_all) < 16)then
			ai_place(sq_e4_m4_tube_alpha);
		end
	end
end

script command_script cs_e4m4_tube_zealot
	cs_abort_on_damage(true);
	cs_go_to(tube.p0);
	cs_go_to(tube.p1);
	cs_go_to(tube.p2);
	cs_go_to(tube.p3);
end

script command_script cs_e4m4_tube_fuel_rod
	cs_abort_on_damage(true);
	sleep(15);
	cs_go_to(tube.p0);
	cs_go_to(tube.p1);
	cs_go_to(tube.p2);
end

script command_script cs_e4m4_tube_skirmisher
	cs_abort_on_damage(true);
	cs_go_to(tube.p4);
	cs_go_to(tube.p5);
	cs_go_to(tube.p6);
end

script static void f_e4_m4_through_tunnels
	print ("through tunnels script started");
	sleep_until (volume_test_players (tv_e4_m4_explosions), 1);
	
	thread(f_music_e4m4_from_above_vo()); 
	vo_e4m4_fromabove();
						// Palmer : Crimson, keep up pursuit.  I'm going to encourage our hinge head to slow his pace a bit. 
	
	//call a few explosions here
	f_e4_m4_elite_deaths();

	
	sleep_until (ai_living_count (sq_e4_m4_elite_deaths) > 0,1);
	print ("elite death squad spawned");
	sleep(30 * 4);
	print ("elite death squad dead");
	thread(f_e4_m4_explosion (fl_e4_m4_4));
	sleep(5);
	thread(f_e4_m4_explosion (fl_e4_m4_2));
	sleep(15);
	thread(f_e4_m4_explosion (fl_e4_m4_14));
	
	sleep(40);
	thread(f_e4_m4_explosion (fl_e4_m4_5));
	sleep(40);
	thread(f_e4_m4_explosion (fl_e4_m4_15));
	
	sleep(20);
	thread(f_e4_m4_explosion (fl_e4_m4_6));
	sleep(10);
	thread(f_e4_m4_explosion (fl_e4_m4_16));
	sleep(10);
	thread(f_e4_m4_explosion (fl_e4_m4_15));
	sleep(15);
	thread(f_e4_m4_explosion (fl_e4_m4_17));
	
	sleep(5);
	thread(f_e4_m4_explosion (fl_e4_m4_7));
	sleep(10);
	thread(f_e4_m4_explosion (fl_e4_m4_18));
	sleep_s (2);

	thread(f_music_e4m4_explosions_vo()); 	
	thread (vo_e4m4_explosions1());
						// Palmer : How the hell did he survive that? 

//	ai_place_in_limbo (sq_e4_m4_knights_end);
//	ai_place_with_birth (sq_e4_m4_bishops_end);
	sleep_s (2);
	thread(f_e4m4_portal_open());
	vo_e4m4_explosions2();
						// Palmer : Slippery son of a-- 
						// Miller : Slipspace signature!  He's opening a portal, Commander! 
	
	//device_set_position (e4_m4_spire, 1);
end

script static void f_e4_m4_elite_deaths
	print ("elite deaths starting now");
	thread(f_music_e4m4_elite_deathsquad_spawn()); 	
	ai_place (sq_e4_m4_elite_deaths);
end

script static void f_e4_m4_explosion (cutscene_flag flag)
	
	print ("EXPLOSION");

	thread (camera_shake_all_coop_players( .1, .3, 1, 0.1));

	ordnance_drop (flag, "default");
	sleep(28);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);

	effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	//effect_new (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
end

script static void f_e4_m4_fore_end
	sleep_until (LevelEventStatus("e4m4_start_prom"), 1);
	volume_test_players (tv_e4_m4_explosions2);
	s_e4m4_state = 9;																												// prometheans
	print ("spawning end forerunners");
	thread(f_music_e4m4_end_forerunners_spawn()); 	
	
	// Initial: 2 to 3
	ai_place_in_limbo (sq_e4_m4_knights_1a);
	sleep(20);
	ai_allow_resurrect(sq_e4_m4_knights_1a, false);													// to thin knights
	ai_place_in_limbo (sq_e4_m4_knights_1);
	sleep(30 * 2);
	thread(vo_glo_knights_09());
					// Palmer : Knights! Take them down.
	ai_place_with_birth (sq_e4_m4_bishops_end);
	
	// Second (Peak Population): 3 add'l
	sleep_until (ai_living_count (sg_e4m4_knights) <= 0);
	sleep(20);
	ai_place_in_limbo (sq_e4_m4_knights_2);
	sleep(30 * 2);
	if(ai_living_count(sq_e4_m4_bishops_end) < 2)then
		ai_place_with_birth (sq_e4_m4_bishops_end);
	end
	// commander
	sleep_until (ai_living_count (sg_e4m4_knights) < 2);
	sleep(30 * 2);
	ai_place_in_limbo (sq_e4_m4_knights_3_commander);
	ai_allow_resurrect(sq_e4_m4_knights_3_commander, false);
	
	// Keep Pressure Up: 2 add'l 
	sleep_until (ai_living_count (sg_e4m4_knights) == 0);
	sleep(20);
	ai_place_in_limbo (sq_e4_m4_knights_3);
	ai_allow_resurrect(sq_e4_m4_knights_3, false);
	sleep(30);
	if(ai_living_count(sq_e4_m4_bishops_end) < 2)then
		ai_place_with_birth (sq_e4_m4_bishops_end);
	end
	
	// Wind Down: 2 add'l
	sleep_until (ai_living_count (sg_e4m4_knights) < 2);
	sleep(20);
	ai_place_in_limbo (sq_e4_m4_knights_4);

	sleep_until(ai_living_count (gr_e4_m4_ff_all) <= 0);
	b_end_player_goal = true;																										// advance objectives
end

script static void f_e4_m4_hide_marker
	print ("hide marker started");
	sleep_until (LevelEventStatus("e4_m4_hide_marker"), 1);
	object_destroy (lz_0);
	print ("marker 50 destroyed");
end

//==  Jul has gotten through the portal
script static void f_end_events_e4_m4_4
	sleep_until (LevelEventStatus("end_e4_m4_4"), 1);
	print ("ENDING start_e4_m4_4");
	
	thread(f_music_e4m4_encounter_4_end()); 	
end

script static void f_e4m4_portal_open
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_portal_end); 
  sleep_s(0.5);
  effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_end);
  //sound_looping_start('sound\environments\multiplayer\scurve\scurve_machines\new_machines\ambience\machine_59_fore_portal_pve_loop.sound_looping', fl_portal_end, 1);
  
  sleep_until (volume_test_players (tv_e4_m4_portal), 1);
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_portal_end);
  sleep(20);
  
  effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_end);
  effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_end);
  
  sound_looping_stop('sound\environments\multiplayer\scurve\scurve_machines\new_machines\ambience\machine_59_fore_portal_pve_loop.sound_looping');
  if (ai_living_count(sg_e4m4_landing) > 0) then														//piggybacking this here cuz I write bad script 
			ai_kill(sg_e4m4_landing);
	end
end


//  2.280033 1.695198
// .584835
// 5.270621

script static void f_start_events_e4_m4_5
	sleep_until (LevelEventStatus("start_e4_m4_5"), 1);
	print ("STARTING start_e4_m4_5");
	sleep(30);
	thread(vo_glo_nicework_06());
						// Palmer : Well done.
	thread(f_music_e4m4_encounter_5_start());
	
	b_wait_for_narrative_hud = true;
	
	sleep_s (3);
	
	thread(f_music_e4m4_escaped_vo()); 	
	vo_e4m4_escaped();
						// Miller : He got through the portal. 
						// Palmer : In one piece? 
						// Miller : Unclear.  But he dropped something… 
						// Palmer : Crimson, have a look. 
	b_wait_for_narrative_hud = false;
	
	
	navpoint_track_object_named (lz_e4m4_brain, "navpoint_goto");
	//sleep_until (you get to the brain)
	sleep_until (volume_test_players (tv_e4_m4_brain), 1);
	thread(f_music_e4m4_end_navpoint_reached()); 
	
	sleep_s (1);
	
	vo_e4m4_brain();
						// Miller : Is that it?  Is that the Didact's gift? 
	device_set_power(e4_m4_gift, 1);
	
	sleep_until (device_get_position (e4_m4_gift) > 0, 1);
	
	vo_e4m4_touchit();
						// Palmer : Don't touch it! 
	navpoint_track_object (lz_e4m4_brain, false);
	device_set_power(e4_m4_gift, 0);
	// first bit of lockdown vo has no PIP
	sleep(30 * 1.5);
	thread(f_music_e4m4_lockdown_vo()); 	
	vo_e4m4_lockdown(); // pip vo
						// Palmer : Commander Palmer to Galileo Base. 
						// Doctor Owen : Owen here.  Go ahead, Commander. 
						// Palmer : Crimson's bringing a package your way.  Prep your labs.  I want a good look at it before I let it onboard Infinity. 
						// Doctor Owen : Um…okay? 
						// Palmer : Good work, Crimson.  Hang tight.  We'll have you a ride to Galileo Base shortly. 

	thread(f_music_e4m4_mission_end());
	
	fade_out (0,0,0,30);
	player_control_fade_out_all_input (30);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	b_end_player_goal = true;
end

script static void f_reach_for_artifact
	print("touched the hiney");
end

////
////
////
////script continuous f_start_events_e4_m4_5
////	sleep_until (LevelEventStatus("start_e4_m4_5"), 1);
////	print ("STARTING start_e1_m5_clear_base_2");
////	//sleep (30);
////	
////	//sleep (30);
////	sound_looping_start (music_start, NONE, 1.0);
////	sound_looping_start (music_mid_beat, NONE, 1.0);
////	
////end
////
//script static void f_start_events_e4_m4_6
//	sleep_until (LevelEventStatus("start_e4_m4_6"), 1);
//	print ("STARTING start_e4_m4_6");
//		vo_e4m4_lockdown();
//						// Palmer : Commander Palmer to Galileo Base. 
//						// Doctor Owen : Owen here.  Go ahead, Commander. 
//						// Palmer : Crimson's bringing a package your way.  Prep your labs.  I want a good look at it before I let it onboard Infinity. 
//						// Doctor Owen : Um…okay? 
//						// Palmer : Good work, Crimson.  Hang tight.  We'll have you a ride to Galileo Base shortly. 
//
//	b_end_player_goal = true;
//
//
//end
////
////
////
////script continuous f_end_events_e4_m4_6
////	sleep_until (LevelEventStatus("end_e4_m4_6"), 1);
////	print ("ENDING start_e4_m4_6");
////	//sleep (30);
////	sound_looping_stop (music_start);
////	
////end
////
////
////script continuous f_start_events_e4_m4_7
////	sleep_until (LevelEventStatus("start_e4_m4_7"), 1);
////	print ("STARTING start_e1_m5_swarm");
////	sound_looping_start (music_start, NONE, 1.0);
////	sound_looping_start (music_up_beat, NONE, 1.0);
////	//f_blip_object_cui (lz_5, "navpoint_goto");
////	//sleep (30);
////
////	start_e1_m3_lz_3_vo();
////	cinematic_set_title (title_swarm_1);
////end
////
////script continuous f_end_events_e4_m4_7
////	sleep_until (LevelEventStatus("end_e4_m4_7"), 1);
////	print ("ENDING start_e4_m4_7");
////
////	sound_looping_stop (music_start);
////	
////end
//
////script static boolean f_ready_to_end
////	sleep_until (b_pelican_done == true);
////		print ("pelican is parked");
////	object_create (dc_pelican_parked);
////
////	device_set_power(dc_pelican_parked, 1);
////	f_blip_object_cui (dc_pelican_parked, "navpoint_goto");
////	navpoint_object_set_on_radar (dc_pelican_parked, true, true);
////	sleep_until (device_get_position (dc_pelican_parked) == 1,1);
////
////end
//
////================ENDING E4 M4==============================
//


//======COMMAND SCRIPTS============

script command_script cs_e4m4_jul_init
	sleep(2);
	thread(f_blip_ai_cui (sq_e4_m4_jul, "navpoint_goto"));
	cs_go_to(jul.p0);
	cs_go_to(jul.p1);
	cs_go_to(jul.p2);
	thread(f_blip_ai_cui (sq_e4_m4_jul, ""));
	sleep(2);
	thread (f_blip_object_cui (lz_2, "navpoint_goto"));
	sleep(2);
	ai_erase(ai_current_actor);
	
end

script command_script cs_e4_m4_elite1
	print ("elite1");
	cs_go_to_and_face (ps_e4_m4_elite.p0, ps_e4_m4_elite.p4);
	thread(f_e4_m4_explosion (fl_e4_m4_1));
	sleep(25);
	ai_kill(ai_current_actor);
	sleep (30 * 2.5);
	thread(f_e4_m4_explosion (fl_e4_m4_11));
end

script command_script cs_e4_m4_elite2
	print ("elite2");
	cs_go_to_and_face (ps_e4_m4_elite.p1, ps_e4_m4_elite.p4);
	thread(f_e4_m4_explosion (fl_e4_m4_2));
	sleep(25);
	ai_kill(ai_current_actor);
	sleep (30 * 2.5);
	thread(f_e4_m4_explosion (fl_e4_m4_12));
end

script command_script cs_e4_m4_elite3
	print ("elite3");
	cs_go_to_and_face (ps_e4_m4_elite.p2, ps_e4_m4_elite.p4);
	sleep(20);
	thread(f_e4_m4_explosion (fl_e4_m4_3));
	sleep(25);
	ai_kill(ai_current_actor);
	sleep (30 * 1.5);
	thread(f_e4_m4_explosion (fl_e4_m4_13));
end

script command_script cs_knight_phase_pause
	print ("knight phase in with 2 second pause");
	sleep_s (2);
	cs_phase_in();
end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================
script command_script cs_drop_pod_e4_m4
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_e4_m4_sur);
end
// ==============================================================================================================
//====== INTRO ===============================================================================
// =====================

script static void f_start_player_intro_e4_m4
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
		//intro_vignette_e4_m4();
		//b_wait_for_narrative = false;
		
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		intro_vignette_e4_m4();
	end

	thread(f_music_e4m4_intro_vignette_end()); 	
	print ("_____________done with vignette---SPAWNING__________________");
	fade_out (255,255,255,01);
	sleep (30 * 1);
	firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
	
//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	sleep(1);
	if(player_valid(player0))then
		object_set_velocity(player0, 6, 0, 4);
	end
	if(player_valid(player1))then
		object_set_velocity(player1, 6, 0, 4);
	end
	if(player_valid(player2))then
		object_set_velocity(player2, 6, 0, 4);
	end
	if(player_valid(player3))then
		object_set_velocity(player3, 6, 0, 4);
	end
	sleep (2);
	fade_in (255,255,255,30);
	player_control_fade_in_all_input(1);
	thread(f_e4_m4_portal_fx());
	print ("all ai exiting limbo after the puppeteer");
	sleep(30 * 5);
end

script static void f_e4_m4_portal_fx
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_portal_1a); 
  sleep_s(0.5);
  //effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal.effect, fl_portal_1a);
  effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_1a);
  sleep_s(4);
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_portal_1a);
  sleep_s(1);
  
  
  effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_1a);
  effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_portal_1a);
//  effect_kill_from_flag(environments\solo\m30_cryptum\fx\portal\teleport_lg_portal.effect, fl_portal_1a);
//  effect_delete_from_flag(environments\solo\m30_cryptum\fx\portal\teleport_lg_portal.effect, fl_portal_1a);
end

script static void intro_vignette_e4_m4
	print ("_____________starting vignette__________________");
	
	thread(f_music_e4m4_intro_vignette_start()); 	
	ai_enter_limbo (gr_e4_m4_ff_all);
	print ("all ai placed in limbo for the puppeteer");
	//ex3();
	
	fade_out (255,255,255,1);
	
	//temp
	b_wait_for_narrative = false;
	
	sleep_until (b_wait_for_narrative == false, 1);
	
	ai_exit_limbo (gr_e4_m4_ff_all);
	
end

script static void f_narrative_done_e4_m4
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end


script static void tst_o
	print ("tst open");
	device_set_power (tst, 1);
	device_set_position (tst, 1);
	print ("opened");
end

script static void tst_c
	print ("tst close");
	device_set_power (tst, 1);
	device_set_position (tst, 0);
	print ("closed");
end

script static void f_cov_switch_activate (object control, unit player)
//script static void f_push_fore_switch (unit player)
	print ("pushing the forerunner switch");
	
	g_ics_player = player;
//	g_ics_player = player0;
	if(ai_living_count(gr_e4_m4_ff_all) == 0)then
		if control == e4_m4_door_switch1 then
			print ("play button 1 puppetshow");
			pup_play_show (pup_e4_m4_button1);
	//	elseif dev == power_switch_temp then
	//		pup_play_show (e1_m5_push_power_button);
		elseif control == e4_m4_door_switch2 then
			print ("play button 2 puppetshow");
			pup_play_show (pup_e4_m4_button2);
		end
	end
end
