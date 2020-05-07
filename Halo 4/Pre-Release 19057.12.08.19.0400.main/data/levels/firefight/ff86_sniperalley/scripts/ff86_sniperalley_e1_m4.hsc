// sink by .051349
// cov terminal: 	33.868015, 5.958328, 3.299286
//																			3.247937
// DM_interface: 	34.318394, 5.958058, 3.872942
//																			3.821593
// DC_interface:	

//	thread(f_music_e1m2_vo_e1m2_secondshielddown());			
//	vo_e1m2_2ndshielddown();
//		// Miller : Good job, Crimson.  Covenant's primary power siphon is just ahead.  Let's go shut it down.

//========== SNIPER ALLEY E1 M2========================================================

// =============================================================================================================================
//========= INIT SCRIPT ==================================================================
// =============================================================================================================================


global boolean b_player_in_canyon = false;
global boolean b_e1_m2_shields_down = false;								//tjp- set once both switches are flipped and all shields are down
global boolean b_e1_m2_game_won = false;										//tjp- flipped in pelican command script
global boolean b_e1m2_switch_gj = false;										//tjp- so gj message only plays once (second shield objective)
global short s_e1m2_combat_progress = 0;									//tjp- gates aios


script startup sniper_alley_e1_m2

//Start the intro
	sleep_until (LevelEventStatus("e1_m2"), 1);
	switch_zone_set (e1_m2);
	mission_is_e1_m2 = true;
	b_wait_for_narrative = true;
	ai_ff_all = gr_e1_m2_ff_all;
	b_no_pod_blips = true;																		//tjp- let's be rid of those unsightly drop pod blips
	thread(f_start_player_intro_e1_m2());
	thread(f_music_e1m2_start());

	thread (f_e1_m2_o1());
	print ("threading f_e1_m2_o1");
	
	//start all the event scripts
	thread (f_start_all_events_e1_m2());

	f_add_crate_folder(eq_e1_m2_unsc_ammo);
	f_add_crate_folder(cr_e1_m2_cov_props); 									// Cov Cover and fluff in the meadow
	f_add_crate_folder(cr_e1_m2_cov_props_1); 								// Cov Cover and fluff in the meadow
	f_add_crate_folder(dc_e1_m2); 														// Cov Cover and fluff on the back bridge
//f_add_crate_folder(cr_e1_m2_shield_barriers); 						// shields blocking the bridge 														//tjp - adding one at a time via script to avoid stacking transparencies
  f_add_crate_folder(dm_e1_m2_drop_rails);
  f_add_crate_folder(cr_e1_m2_cov_weapon_racks);
  sleep(2);
  f_add_crate_folder(wp_e1_m2_unsc_weapons);  
  f_add_crate_folder(dm_e1_m2_control_dms);									//tjp - control panels from scurve
  f_add_crate_folder(e1m2_vehs);  													//tjp - final shade

	f_add_crate_folder(cr_e1_m2_ammo);
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); 	//SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); 	//SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); 	//SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(spawn_points_3, 93);		//SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); 	//SA Spawn location: in valley, facing into canyon
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); 	//SA Spawn location: in middle of the canyon, facing towards temple
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); 	//SA Spawn location: back of temple, middle, as a group
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); 	//SA Spawn location: near end of valley to cayon, facing into valley
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); 	//SA Spawn location: middle of the valley, facing towards the canyon
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); 	//SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
	firefight_mode_set_crate_folder_at(spawn_points_10, 100); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple	
	
//set objective names
//firefight_mode_set_objective_name_at(destroy_obj_1, 1); 	//objective behind the dias
//firefight_mode_set_objective_name_at(destroy_obj_2, 2); 	//on the dias
//firefight_mode_set_objective_name_at(destroy_obj_3, 3); 	//in the tunnel
//firefight_mode_set_objective_name_at(defend_obj_1, 	4); 	//objective in the tunnel
//firefight_mode_set_objective_name_at(defend_obj_2, 	5); 	//objective in the tunnel
//firefight_mode_set_objective_name_at(capture_obj_0, 6); 	//objective in the tunnel
//firefight_mode_set_objective_name_at(power_core, 		7); 	//on the dias
//firefight_mode_set_objective_name_at(capture_obj_1,9); 		//objective on the dias
firefight_mode_set_objective_name_at(dc_e1_m2_switch_1,	1); //SA switch location: in the middle, but the bridge
//firefight_mode_set_objective_name_at(defend_obj_3, 11); 	//objective in the back, behind the dias
//firefight_mode_set_objective_name_at(defend_obj_4, 12); 	//objective in the back, behind the dias
//firefight_mode_set_objective_name_at(capture_obj_2,18); 	//objective on the walkway
firefight_mode_set_objective_name_at(dc_e1_m2_switch_2,2); 	//SA switch location: side square open platform, main level
//firefight_mode_set_objective_name_at(capture_obj_3,	20); 	//in the leftside room
firefight_mode_set_objective_name_at(dc_e1_m2_switch_3, 3); //SA switch location: upper front platform
firefight_mode_set_objective_name_at(dc_e1_m2_switch_4, 4); //SA switch location: in the valley
firefight_mode_set_objective_name_at(dc_e1_m2_extraction,5);//SA switch location: upper front platform

	
	firefight_mode_set_objective_name_at(lz_0, 	50); 					//SA objective location: back of temple
	firefight_mode_set_objective_name_at(lz_1, 	51); 					//SA objective location: front pad of temple
	firefight_mode_set_objective_name_at(lz_2, 	52); 					//SA objective location: near middle of temple
	firefight_mode_set_objective_name_at(lz_3, 	53); 					//SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(lz_4, 	54); 					//SA objective location: on lower platform by ramp to upper level, leading to back of canyon
	firefight_mode_set_objective_name_at(lz_5, 	55); 					//SA objective location: entrance to canyon from valley
	firefight_mode_set_objective_name_at(lz_6, 	56); 					//SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(lz_7, 	57); 					//SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(lz_8, 	58); 					//SA objective location: middle of the valley
	firefight_mode_set_objective_name_at(lz_9, 	59); 					//SA objective location: bottom of the ramp, towards the back of the temple
	firefight_mode_set_objective_name_at(lz_10, 60); 					//SA objective location: lower bend in the canyon
	firefight_mode_set_objective_name_at(lz_11, 61); 					//SA objective location: upper bend in the canyon
	firefight_mode_set_objective_name_at(lz_12, 62); 					//SA objective location: upper bend in the canyon

//set squad group names
	firefight_mode_set_squad_at(gr_e1_m2_guards_1, 				1);	//SA: back of temple
	firefight_mode_set_squad_at(gr_e1_m2_guards_2, 				2);	//SA: mid level back of temple
	firefight_mode_set_squad_at(gr_e1_m2_guards_3, 				3);	//SA: back of main level of temple
	firefight_mode_set_squad_at(gr_e1_m2_guards_4, 				4); //SA: Side square platform										//2shield
	firefight_mode_set_squad_at(gr_e1_m2_guards_5, 				5); //SA: Upper level, front of platform					//2shield
	firefight_mode_set_squad_at(gr_e1_m2_guards_6, 				6); //SA: front of temple
	firefight_mode_set_squad_at(gr_e1_m2_guards_7, 				7);	//SA: front entrance of temple before bridge	//3landing
	firefight_mode_set_squad_at(gr_e1_m2_guards_8, 				8);	//SA: Top of canyon														//3landing
	firefight_mode_set_squad_at(gr_e1_m2_guards_9, 				9); //SA: Middle of canyon
	firefight_mode_set_squad_at(gr_e1_m2_guards_10, 			10);//SA: Bottom of temple

//	firefight_mode_set_squad_at(gr_e1_m2_guards_17, 			17);//SA: canyon
	firefight_mode_set_squad_at(gr_e1_m2_guards_18_tank, 	18);//SA: canyon, near tank, for destroy
	firefight_mode_set_squad_at(gr_e1_m2_guards_19_tower, 19);//SA: canyon, near tower 1, for destroy
	firefight_mode_set_squad_at(gr_e1_m2_guards_20_tower,	20);//SA: canyon, near tower 2, for destroy
	firefight_mode_set_squad_at(sq_e1_m2_valley_droppod,	21);//SA: canyon, middle
	firefight_mode_set_squad_at(gr_e1_m2_guards_22, 			22);//SA: middle of mid level, near back of temple
	
	firefight_mode_set_squad_at(gr_e1_m2_guards_snipers_1,30);//SA: middle of mid level, near front of temple
	
//	firefight_mode_set_squad_at(gr_waves_1, 						51);//SA: middle of mid level, near front of temple

	firefight_mode_set_squad_at(gr_e1_m2_waves_0, 		80);		// 2shield
	firefight_mode_set_squad_at(gr_e1_m2_waves_1, 		81);		// ranger drops from pod at end of first fight, prior to shield lowering
	firefight_mode_set_squad_at(gr_e1_m2_waves_2, 		82);		// 2shield
	firefight_mode_set_squad_at(gr_e1_m2_waves_3, 		83);
	firefight_mode_set_squad_at(gr_e1_m2_waves_4, 		84);
	firefight_mode_set_squad_at(gr_e1_m2_waves_5, 		85);
	firefight_mode_set_squad_at(gr_e1_m2_waves_6, 		86);
	firefight_mode_set_squad_at(gr_e1_m2_waves_7, 		87);

	firefight_mode_set_squad_at(sq_phantom_attack_1, 	70);		//tjp
	firefight_mode_set_squad_at(sq_ff_phantom_03, 		71);		//tjp
	firefight_mode_set_squad_at(sq_phantom_attack_2, 	72);		//tjp

end

// ==============================================================================================================
//====== E1_M2_Sniperalley_Destroy==============================================================================
// ==============================================================================================================

script static void f_start_all_events_e1_m2
	print ("threading all the event scripts");
	//event tags
	//thread (f_start_events_e1_m5_1());
	//print ("threading f_start_events_e1_m5_1");
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e1_m2.scenery", 
															"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	
	thread (f_e1_m2_cleanup1());															//tjp- cleanup message at end of objective 1
	print ("threading f_e1_m2_cleanup1");
	
	
	thread (f_small_drop_pod_1());														//tjp- small pod drop for first ranger elite
	print ("threading f_small_drop_pod_1");
	
	thread(f_e1_m2_spawn_bridge_snipers());										//tjp- bridge snipers after second shield
	print ("threading f_e1_m2_spawn_bridge_snipers");
	
	thread (f_e1_m2_o2());
	print ("threading f_e1_m2_o2");

	thread (f_e1_m2_o2end());
	print ("threading f_e1_m2_o2end");
	
	thread (f_e1_m2_o3());
	print ("threading f_e1_m2_o3");

	thread (f_e1_m2_o3end());
	print ("threading f_e1_m2_o3end");
	
	thread (f_e1_m2_o4());
	print ("threading f_e1_m2_o4");
	
	thread (f_e1_m2_change_drop_pods());
	print ("threading f_e1_m2_change drop pods");
	
	thread (f_e1_m2_o8());
	print ("threading f_e1_m2_o8");
	
	thread	(f_e1_m2_valley_init());													//tjp- sets up final encounter
	print ("f_e1_m2_valley_init");
	
	thread (f_e1_m2_o9());
	print ("threading f_e1_m2_o9");
	
	thread (f_e1_m2_blow_up_gennie());
	print ("threading f_e1_m2_blow up gennie");
	
	thread (f_e1_m2_o10());
	print ("threading f_e1_m2_10");
	
	thread(f_e1m2_jackal_snipers_little_buddy());							//tjp
	print("f_e1m2_jackal_snipers_little_buddy");
	
	thread(f_e1_m2_valley_waypoint());
	
	thread(f_e1_m2_4_man_drop_pod_1());												//tjp
	thread(f_e1_m2_4_man_drop_pod_2());												//tjp
	
	thread(e1_m2_game_over());																//tjp
	
	
	sleep(30 * 5);
	thread(e1_m2_dm_panel_1());																//tjp- for the shutting off of the panels, yes?
	
	thread(e1_m2_dm_panel_2());																//tjp
	
	thread(e1_m2_dm_panel_3());																//tjp 
	object_destroy(e2m4_base1);
	
	thread(f_e1_m2_end_bridge());
	
	ai_jump_cost_scale(3.0);
end


script static void f_start_player_intro_e1_m2
	firefight_mode_set_player_spawn_suppressed(true);
	
	if editor_mode() then
		//firefight_mode_set_player_spawn_suppressed(false);
		sleep (2);
		//f_e1_m2_intro_vignette();
		//b_wait_for_narrative = false;
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		f_e1_m2_intro_vignette();
	end
	//intro();
	fade_out (0,0,0,1);
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (b_players_are_alive(), 1);
//	print ("player is alive");
	sleep (4);
	fade_in (0,0,0,30);
end

script static void f_e1_m2_intro_vignette
	//initialize the game for “interruptive” cutscenes (no split screen)
	cinematic_start();

	print ("_____________starting vignette__________________");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e1m2_vin_sfx_intro', NONE, 1);
	thread(f_music_e1m2_intro_vignette_start());
	//sleep_s (8);

	ex1();
	sleep_until (b_wait_for_narrative == false);
	
	print ("_____________done with vignette---SPAWNING__________________");
	thread(f_music_e1m2_intro_vignette_finish());
	
	//turn off split screen
	cinematic_stop();
	
	ai_erase (squads_1);
	ai_erase (squads_2);
	ai_erase (squads_3);
	//firefight_mode_set_player_spawn_suppressed(false);
end

script static void f_e1_m2_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end

//====== LEVEL SCRIPTS=======
script static void f_e1_m2_o1
	sleep_until (LevelEventStatus("e1_m2_o1"), 1);
	ai_place (sq_e1_m2_shades);
	print ("placing turret");
	
	sleep_until (object_get_health(player0) > 0, 1);
	print ("player alive");
	object_cannot_take_damage (obj_powercore);
	//start the VO
	thread(f_music_e1m2_vo_e1m2_playstarts());
	object_create(shield_barrier_01);
	object_set_function_variable (shield_barrier_01, "shield_on", 1, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machines_10_sniper_alley_shield_up', shield_barrier_01, 1 ); //AUDIO!
	sleep(15);
	object_cannot_take_damage(shield_barrier_01);
	vo_e1m2_playstarts();
				// Miller : Where's that shield coming from?
				// Miller : One moment.
				// Miller : There's a lot of power being pulled from the planet.
				// Miller : Weird.
				// Palmer : Crimson doesn't need a Science Team report, Miller.  They just need a target to shoot.
				// *pip*
				// Miller : Right, Commander.
				// Miller : Have a look in this area, Crimson.  See what you can find.
	thread(f_new_objective (sniper_objective_h));
				//"Secure the Area"
end

script static void f_e1_m2_o2
	sleep_until (LevelEventStatus("e1_m2_o2"), 1);
	print ("e1_m2_02");
	
	b_wait_for_narrative_hud = true;
	
	sleep (20 * 1.5);
	
	vo_glo_powersource_01();
					// Miller : Commander, there's a power source nearby. Might want to have Crimson take a look.
					// Palmer : Give them a waypoint, Miller.
	sleep(20);
	device_set_power (dc_e1_m2_switch_1, 1);
	b_wait_for_narrative_hud = false;
	thread(f_new_objective (e1_m2_objective_2));
				// "Disable Shields"
end

script static void f_e1_m2_cleanup1															//tjp - gives players mop-up vo and objective
	sleep_until (LevelEventStatus("e1m2_cleanup1"), 1);
	print("---------------------------=-=-=-=-=-=-=- mop - up time, objective 1");
	thread(vo_glo_lasttargets_01());
				// Miller : Painting the last targets for you now.
	sleep(30);
	thread(f_new_objective (e1_m2_objective_4));
				// "Clear Area"
end

////do stuff after the first object_destruction
script static void f_e1_m2_o2end
	sleep_until (LevelEventStatus ("e1_m2_o2end"), 1);

	thread(f_music_e1m2_first_object_destruction());
end

script static void f_e1_m2_o3
	sleep_until (LevelEventStatus ("e1_m2_o3"), 1);
	print ("e1_m2_o3");
	b_wait_for_narrative_hud = true;
	
	thread(f_music_e1m2_blowing_shields1());
	sleep(30 * 1);
		
	thread(start_camera_shake_loop ("heavy", "short"));
		
	sleep(30 * 2);
	thread(e1m2_shield_swap());
	thread(start_camera_shake_loop ("heavy", "short"));

	sleep (30 * 2.5);
	stop_camera_shake_loop();
	sleep (30 * 2);
	object_dissolve_from_marker(dm_e1_m2_panel_1, phase_out, panel);
	//VO
	thread(f_music_e1m2_vo_e1m2_shielddown());
	vo_e1m2_shielddown();
				// Miller : There we go.  Shield's down.
	sleep(30 * 1.5);
	thread(f_music_e1m2_vo_e1m2_secondshield());
	vo_e1m2_secondshield();
					// Miller : Same as before, Crimson.  Find a way through that shield
	b_wait_for_narrative_hud = false;
	
	device_set_power (dc_e1_m2_switch_2, 1); 
	device_set_power (dc_e1_m2_switch_3, 1);
	sleep(4);
	// get switches ready
	thread(f_e1_m2_switch_gj_a());
	thread(f_e1_m2_switch_gj_b());
end

script static void e1m2_shield_swap
	object_can_take_damage(shield_barrier_01);
	sleep(10);
	object_set_function_variable (shield_barrier_01, "shield_on", 0, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machines_10_sniper_alley_shield_down', shield_barrier_01, 1 ); //AUDIO!
	sleep(45);
	object_destroy(shield_barrier_01);
	sleep(10);
	object_create(shield_barrier_02);
	sleep(30);
	object_set_function_variable (shield_barrier_02, "shield_on", 1, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machines_10_sniper_alley_shield_up', shield_barrier_02, 1 ); //AUDIO!
	sleep(2);
	object_cannot_take_damage(shield_barrier_02);
	print("---------------------------------------=======shield damage===========---------------------------------");
//		damage_object(shield_barrier_01, "energy_shield", 5);
//		inspect(object_get_shield(shield_barrier_01));
//		sleep(2);
end

script static void e1m2_kill_shield_2
	object_can_take_damage(shield_barrier_02);
	sleep(10);
	object_set_function_variable (shield_barrier_02, "shield_on", 0, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machines_10_sniper_alley_shield_down', shield_barrier_02, 1 ); //AUDIO!
	sleep(30 * 2);
	object_destroy(shield_barrier_02);
//		damage_object(shield_barrier_01, "energy_shield", 5);
end

script static void e1_m2_vo_secondshield_callback														//tjp- callback from narrative script
	thread(f_new_objective (e1_m2_objective_2));															
					//"Disable Shields"
end

script static void f_e1_m2_switch_gj_a																			//tjp 
	sleep_until 		((device_get_power(dc_e1_m2_switch_2)) == 0);							//TJP - was an OR evaluation, but that gave unreliable results for some reason
	print("--------------------------------------------=-=-=-=-=-=- POWER ON DC_SWITCH2 IS OFF");
	if(b_e1m2_switch_gj == false)then
	b_e1m2_switch_gj = true;
	vo_glo_nicework_01();
						// PALMER : Nice work.
	end
end

script static void f_e1_m2_switch_gj_b																			//tjp 
	sleep_until 		((device_get_power(dc_e1_m2_switch_3)) == 0);							//TJP - was an OR evaluation, but that gave unreliable results for some reason
	print("--------------------------------------------=-=-=-=-=-=- POWER ON DC_SWITCH IS OFF");
	if(b_e1m2_switch_gj == false)then
	b_e1m2_switch_gj = true;
	vo_glo_nicework_01();
						// PALMER : Nice work.
	end
end

script static void e1_m2_dm_panel_1
	
	device_set_power(dm_e1_m2_panel_1, 1);
	
	sleep_until(device_get_position(dm_e1_m2_panel_1) > .95, 1);
	object_hide(dm_e1_m2_panel_1, true);
	sleep(2);
	object_destroy(dm_e1_m2_panel_1);
end

script static void e1_m2_dm_panel_2

	device_set_power(dm_e1_m2_panel_2, 1);
	
	sleep_until(device_get_position(dm_e1_m2_panel_2) > .95, 1);
	object_hide(dm_e1_m2_panel_2, true);
	sleep(2);
	object_destroy(dm_e1_m2_panel_2);
end

script static void e1_m2_dm_panel_3

	device_set_power(dm_e1_m2_panel_3, 1);

	sleep_until(device_get_position(dm_e1_m2_panel_3) > .95, 1);
	object_hide(dm_e1_m2_panel_3, true);
	sleep(2);
	object_destroy(dm_e1_m2_panel_3);
end
////blow the shields after the second object_destruction
script static void f_e1_m2_o3end
	sleep_until (LevelEventStatus ("e1_m2_o3end"), 1);
	thread(start_camera_shake_loop ("heavy", "short"));
	thread(f_music_e1m2_blowing_shields2());
	b_e1_m2_shields_down = true;
	//b_wait_for_narrative_hud = true;
	print ("blowing shields2");
	sleep (30 * 2);
	thread(e1m2_kill_shield_2());
	sleep (30 * 3);
	stop_camera_shake_loop();
	thread(f_music_e1m2_vo_e1m2_whataretheydoing());
	vo_e1m2_whataretheydoing();
				// Palmer : What the hell are the Covenant doing?
				// Miller : They've got some gear…it…
				// Palmer : Spit it out, Miller
				// Miller : They're siphoning power from the structures.
				// Miller : Give me a minute.
				// Palmer : While Miller's working his science, Crimson, you continue clearing the area.

	thread(f_new_objective (e1_m2_objective_4));
					// "Clear Area"
	f_e1_m2_small_drop_pod();
end

script static void f_e1_m2_spawn_bridge_snipers 							//tjp
	sleep_until(LevelEventStatus ("e1_m2_jax1"), 1);
	ai_place (e1_m2_br_snipers);
end
script static void f_e1_m2_end_bridge
	sleep_until (volume_test_players (tv_end_bridge), 1);
	s_e1m2_combat_progress = 3;
	ai_set_objective(gr_e1_m2_second_shield, "obj_survival");
end
script static void f_e1_m2_small_drop_pod
	print ("small drop script");
	//sleep until a player enters the trigger volume then drop the small drop pod
	sleep_until (volume_test_players (tv_e1_m2_drop_pod), 1);
	//print ("players in the trigger volume spawning small drop pod");
	f_small_drop_pod_0();
	thread(f_music_e1m2_small_drop_pod());
	// kill 2shield mobs if still alive:
	ai_kill(gr_e1_m2_guards_4);
	sleep(20);
	ai_kill(gr_e1_m2_guards_5);
	sleep(45);
	ai_kill(gr_e1_m2_waves_0);
	sleep(10);
	ai_kill(gr_e1_m2_waves_2);
end

script static void f_e1_m2_4_man_drop_pod_1
	print("------------------------------------===-=-=-=-=-=-=-=- 4xdp ready");
	sleep_until (LevelEventStatus ("e2m1_4xdp_1"), 1);
	print("------------------------------------===-=-=-=-=-=-=-=- DROP 4xdp ");
	object_create (v_e1_m2_pod_3);
	thread(v_e1_m2_pod_3->drop_to_point( sq_e1_m2_wave_04, ps_e1_m2_drop_pods.p2, .65, DEFAULT ));
end

script static void f_e1_m2_4_man_drop_pod_2
	print("------------------------------------===-=-=-=-=-=-=-=- 4xdp ready");
	sleep_until (LevelEventStatus ("e2m1_4xdp_2"), 1);
	print("------------------------------------===-=-=-=-=-=-=-=- DROP 4xdp ");
	object_create (v_e1_m2_pod_5);
	thread(v_e1_m2_pod_5->drop_to_point( sq_4man, ps_e1_m2_drop_pods.p4, 1, DEFAULT ));
	sleep(15);
	object_create (v_e1_m2_pod_4);
	thread(v_e1_m2_pod_4->drop_to_point( sq_4man_2, ps_e1_m2_drop_pods.p3, 1, DEFAULT ));
end

script static void f_e1_m2_o4
	sleep_until (LevelEventStatus ("e1_m2_o4"), 1);
	print ("e1_m2_od4");
end

script static void f_e1m2_jackal_snipers_little_buddy						//tjp
	sleep_until (LevelEventStatus ("e1m2_jackal_snipes"), 1);
	s_e1m2_combat_progress = 5;								
	ai_place(e1m2_little_buddy);
	ai_place(sq_e1_m2_guards_10);																	//tjp- resorted to this... bonobo spawning of these same guys was unreliable for reasons I couldn't pin down
	thread(f_e1m2_sniper_vo());
	sleep(30 * 2);
end
script static void f_e1m2_sniper_vo
	sleep_until (volume_test_players (tv_snipers), 1);			
	sleep(30);
	vo_glo_incoming_06();
						// Palmer : Hostiles inbound Crimson. Give them a proper welcome, yeah?
end
////turn the drop pods to new drop pods
script static void f_e1_m2_change_drop_pods
	sleep_until (LevelEventStatus ("e1_m2_o7"), 1);
	thread(f_music_e1m2_change_drop_pods());
	print ("changing drop pod marker locations");
	dm_droppod_1 = dm_e1_m2_drop_1;
		inspect (dm_droppod_1);
	dm_droppod_4 = dm_e1_m2_drop_4;
		inspect (dm_droppod_4);
	dm_droppod_5 = dm_e1_m2_drop_5;
		inspect (dm_droppod_5);
end

script static void f_e1_m2_valley_waypoint
	sleep_until (LevelEventStatus ("e1_m2_o7"), 1);
	object_create(lz_7);
	sleep(4);
	thread (f_blip_object_cui (lz_7, "navpoint_goto"));
	sleep_until (volume_test_players (tv_valley_enter), 1);
	b_end_player_goal = TRUE;																			//advance objectives
	thread (f_blip_object_cui (lz_7, ""));
	//f_unblip_object_cui (flag_0);
end

script static void f_e1_m2_valley_init													//tjp- set up valley based on pop count
	thread(e1m2_watchtower());
	sleep_until (LevelEventStatus ("e1_m2_o8"), 1);
	ai_kill(gr_e1_m2_third_landing);															// kill old mobs if they're still around (players probably trying to break shit)
	sleep(2);
	local long foes = ai_living_count(gr_e1_m2_ff_all);

	ai_place (sq_e1_m2_snipers_1);																//	2 jackal snipers, in tower
	
	if 			(foes > 21) then
		print("full up");
	elseif	(foes > 19)	then
		ai_place (sq_e1_m2_snipers_2);															//	1 [grunt/elite] gunner, in shade on hill
		//ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
		//ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
		//ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
		//ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
		//ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	elseif(foes > 17) then
			ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
			ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
		//ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
		//ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
		//ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
		//ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	elseif(foes > 15) then
			ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
		//ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
			ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
		//ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
			ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
		//ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	elseif(foes > 14) then
			ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
		//ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
			ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
			ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
			ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
		//ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	elseif(foes > 13) then
		//ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
		//ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
			ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
			ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
			ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
			ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	elseif(foes > 12) then
			ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
		//ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
			ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
			ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
			ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
			ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	else
			ai_place (sq_e1_m2_snipers_2);														//	1 [grunt/elite] gunner, in shade on hill
			ai_place (sq_e1_m2_snipers_1b);														//	2 [grunt_jackal], on shade hill
			ai_place (sq_e1_m2_guards_18_tank);												//	2 jackals, front
			ai_place (sq_e1_m2_guards_18_tankb);											//	2 jackals, frontish
			ai_place (sq_e1_m2_guards_20_tower);											// 	2 jackals, by tower
			ai_place (sq_e1_m2_guards_20_towerb);											// 	2 jackals, by tower
	end
end

script static void f_e1_m2_o8
	sleep_until (LevelEventStatus ("e1_m2_o8"), 1);
	print ("e1_m2_o8");
	thread(f_music_e1m2_drop_heavy_weapons());
	
	//tjp- global vo for ordnance drop
	vo_glo_ordnance_01();
	sleep(30 * 2);
	//set enemies to follow the players, etc.
	b_player_in_canyon = true;

	ordnance_drop (fl_weapon_drop_3, "storm_rail_gun");
	sleep_s (1);
	ordnance_drop (fl_weapon_drop_1, "storm_sniper_rifle");
	sleep(10);
	ordnance_drop (fl_weapon_drop_5, "storm_sniper_rifle");
	sleep(30);
	ordnance_drop (fl_weapon_drop_4, "storm_rocket_launcher");
	sleep_s (2);
	ordnance_drop (fl_weapon_drop_2, "storm_rocket_launcher");
	
	sleep(30 * 5);
//goal vo
	thread(f_music_e1m2_vo_secure_generator());
	vo_e1m2_securegenerator();
	thread(f_new_objective (e1_m2_objective_4)); 										//"CLEAR THE AREA"
	thread(e1_m2_mop_up_2());																				//tjp
end

script static void e1_m2_mop_up_2																	//tjp
	sleep_until (LevelEventStatus("e1_m2_mop_up_2"), 1);
	print("---------------------------=-=-=-=-=-=-=- mop - up time, objective 8");
	sleep(20);
	thread(vo_glo_lasttargets_05());
								// Palmer : Miller, light up the last few targets.
	sleep(30 * 2);
	thread(f_new_objective (e1_m2_objective_4));										//"CLEAR THE AREA"
end

script static void f_e1_m2_o9
	sleep_until (LevelEventStatus("e1_m2_o8a"), 1);
	print ("e1_m2_09");
		
	//turn off HUD, play VO, turn on the HUD
	b_wait_for_narrative_hud = true;
	
	sleep_s (2);
	ordnance_show_nav_markers(false);
	thread(f_music_e1m2_vo_mark_target());
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e4_m4.scenery", 
															"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	vo_e1m2_marktarget();
						// Miller : Crimson's got the area secure, Commander.
						// Palmer : Would you be so kind as to paint a target on the generator for Spartan Dalton?
	b_wait_for_narrative_hud = false;
	sleep(15);
	b_end_player_goal = TRUE;																				//advance objectives
	device_set_power (dc_e1_m2_switch_4, 1);
	print ("gennie marked and active");
end

//blow up the gennie
script static void f_e1_m2_blow_up_gennie
	sleep_until (LevelEventStatus("blow_gennie"), 1);
//	cinematic_set_title (e1_m2_d_28);

	print("_______________________________game over");
//	stop_camera_shake_loop();
end

script static void f_explode_gennie (cutscene_flag flag, cutscene_flag contrail)
	print ("shake start");
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	//ordnance_drop (contrail, "default");
	ordnance_drop (flag, "default");
	sleep(38);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	//effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
	print ("EXPLOSION");
	sleep (10);
	print ("stop");
end

script static void f_damage_at_explosion
	print ("damaging players at powercore");
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', fl_core_damage_3);

end

script static void f_e1m2_paint_target_audio //This is for audio to trigger right when player targets power core.
	
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machine_14_sniper_alley_mark_switch_activate', dc_e1_m2_switch_4, 1 ); //AUDIO!
	sound_looping_start ( 'sound\environments\multiplayer\sniperalley\new_machines\ambience\machine_14_sniper_alley_mark_switch_alert_loop', NONE, 1); //AUDIO!

end

script static void f_e1_m2_o10
	sleep_until (LevelEventStatus("e1_m2_o10"), 1);
	print ("e1_m2_010");
	sleep(25);
	thread(f_e1m2_paint_target_audio());
	b_wait_for_narrative_hud = true;
	thread(f_music_e1m2_vo_targetpainted());
	sleep(30 * 3);
	vo_e1m2_targetpainted();
	sleep(30 * 4);
	sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machine_14_sniper_alley_mark_switch_rumble', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .4, .4, 3, 1));
	
	thread(f_music_e1m2_vo_getsafe());
	vo_e1m2_getsafe();
	
	//stop_camera_shake_loop();
	//sleep_s (1);
//	cinematic_set_title (e1_m2_d_29);
	// set some timer
	print("_______________________________about to damage gennie");
	// set the gennie to blow up
	//begin_random																									//tjp - removing random, adding more booms
		thread(f_explode_gennie (fl_core_damage_1, fl_contrail_target_1));
		sleep(10);
		thread(f_explode_gennie (fl_core_damage_2, fl_contrail_target_2));
		sleep(5);
		thread(f_explode_gennie (fl_core_damage_10, fl_contrail_target_10));
		sleep(20);
		thread(f_explode_gennie (fl_core_damage_3, fl_contrail_target_3));
		sleep(2);
		object_can_take_damage (obj_powercore);
		damage_object(obj_powercore, default, 10000);
		sleep(5);
		thread(f_explode_gennie (fl_core_damage_11, fl_contrail_target_11));
		sleep(15);
		thread(f_explode_gennie (fl_core_damage_4, fl_contrail_target_4));
		thread(f_explode_gennie (fl_core_damage_12, fl_contrail_target_12));
		sleep(5);
		thread(f_explode_gennie (fl_core_damage_1, fl_contrail_target_1));
		thread(f_explode_gennie (fl_core_damage_11, fl_contrail_target_11));
		sleep(5);
		thread(f_explode_gennie (fl_core_damage_2, fl_contrail_target_2));
		thread(f_explode_gennie (fl_core_damage_10, fl_contrail_target_10));
	sound_looping_stop ( 'sound\environments\multiplayer\sniperalley\new_machines\ambience\machine_14_sniper_alley_mark_switch_alert_loop' ); //AUDIO!
	print ("EXPLOSION CORE 1");
	
	sleep_s (3);

	thread(f_music_e1m2_vo_targethit());
	thread(vo_e1m2_targethit());
								// Dalton : Impact on target, Commander.
								// Miller : Confirming..., all power to the area is gone.
								// Palmer : Well done, everyone.  Crimson, head to the extraction point and come on home.
	sleep(30 * 5);
	b_wait_for_narrative_hud = false;
	ai_place(sq_e1_m2_pelican);
	sleep(30 * 7);
	thread(f_new_objective (e1_m2_objective_5));										//"EVAC"
	b_end_player_goal = TRUE;																				//advance objectives
	
	thread(f_blip_object_cui (sq_e1_m2_pelican, "navpoint_goto"));
	sound_impulse_start ('sound\environments\multiplayer\pve\ep_01_mission_02\pelican_spawn', sq_e1_m2_pelican, 1);


end

//==============ENDING E1 M4==============================
	
script static void e1_m2_game_over																//tjp
	sleep_until (b_e1_m2_game_won == true);
	sleep_until (volume_test_players (tv_pelican), 1);
	fade_out (0,0,0,30);
	thread(f_blip_object_cui (sq_e1_m2_pelican, ""));
	b_wait_for_narrative_hud = false;
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	sleep(30 * 1.5);
	player_control_fade_out_all_input (.1);
	b_end_player_goal = true;
	thread(f_music_e1m2_stop());
end

////////////////////////////////////////////////////////////////////////////////////////////////////////
//=============misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////

script static void e1m2_watchtower
	sleep_until(object_valid(e1m4_pod1) == false);
	//sleep_until(object_get_health(e1m4_pod1) <= 0);
	object_set_phantom_power(e1m4_base1, false);
	// 3.641773, 65.395210, -9.107613
end

script static void f_small_drop_pod_0
	print ("drop pod 0");
	object_create (v_e1_m2_pod_1);
	thread(v_e1_m2_pod_1->drop_to_point( sq_e1_m2_drop_01, ps_e1_m2_drop_pods.p0, .70, DEFAULT ));
end

script static void f_small_drop_pod_1 														//tjp - first drop pod of the scenario (replaced single-occupant jumbo pod)
	sleep_until(LevelEventStatus(e1m2_smallpod1), 1);
	print ("drop pod 1");
//	ai_place_in_limbo(sq_e1_m2_wave_01);
	object_create (v_e1_m2_pod_2);
	thread(v_e1_m2_pod_2->drop_to_point(sq_e1_m2_wave_01, ps_e1_m2_drop_pods.p1, .65, DEFAULT ));
//	ai_exit_limbo(sq_e1_m2_wave_01);
end


//============= command_script

script command_script cs_e1m2_get_in_shade
	sleep(5);
	ai_vehicle_enter_immediate (sq_e1_m2_snipers_2, v_e1_m2_shade_3);
end

script command_script cs_drop_pod_dont_die_hack										//tjp- once the bug is fixed, switch affected npcs' initial objective back to obj_drop_pod
	ai_cannot_die (ai_current_actor, true);
	sleep(30 * 1.4);
	ai_set_objective (ai_current_squad, obj_survival);
	ai_cannot_die (ai_current_actor, false);
end

script command_script cs_drop_pod
	sleep (15);
	ai_set_objective (ai_current_squad, obj_survival);
end

script command_script cs_e1_m2_phantom_01													//tjp- making this phatnom dual-purpose, transport and attack
	ai_enter_limbo(ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 );
	sleep_s (1);
	ai_exit_limbo (ai_current_actor);
		sleep_s (1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 60 ); //grow size over time
	
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (false);
	
	//drop-off sequence
	cs_fly_to_and_face (ps_phantom_attack_1.first, ps_phantom_attack_1.face3);									//tjp
	cs_fly_to_and_face (ps_phantom_attack_1.p0, ps_phantom_attack_1.face2);											//tjp
	sleep (30 * 1);

	f_unload_phantom (ai_current_squad, "dual");
	
	sleep (30 * 3.5);
	
	//hide until player advances
	if(b_e1_m2_shields_down == false)then
		cs_fly_to_and_face (ps_phantom_attack_1.p6, ps_phantom_attack_1.face4);										//tjp
	end
	
	sleep_until(b_e1_m2_shields_down == true);

	cs_fly_to_and_face (ps_phantom_attack_1.p0, ps_phantom_attack_1.face3);											//tjp
	//firing sequence
	
	cs_enable_targeting (true);
	
	cs_fly_to_and_face (ps_phantom_attack_1.p1, ps_phantom_attack_1.face);
	sleep_s (3);
	cs_fly_to_and_face (ps_phantom_attack_1.hover_low, ps_phantom_attack_1.face);
	sleep_s (2);
	cs_fly_to_and_face (ps_phantom_attack_1.hover_right, ps_phantom_attack_1.p1);
	sleep_s (2);
	cs_fly_to_and_face (ps_phantom_attack_1.hover_low, ps_phantom_attack_1.p2);
	sleep_s (1);
	
	cs_enable_targeting (false);
	cs_fly_to_and_face (ps_phantom_attack_1.hover_high, ps_phantom_attack_1.p3);
	cs_fly_to_and_face (ps_phantom_attack_1.p2, ps_phantom_attack_1.p3);
	cs_fly_to_and_face (ps_phantom_attack_1.p3, ps_phantom_attack_1.erase);
	cs_fly_to (ps_phantom_attack_1.erase);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); 												//Shrink over time
	sleep_s (7);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
end

script command_script cs_e1_m2_phantom_02
	ai_enter_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); 													//Shrink over time
	ai_exit_limbo (ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 60 ); 														//grow over time
	
	ai_place (sq_e1_m2_valley_dropship_grunts);
	f_load_dropship(ai_vehicle_get (ai_current_actor), sq_e1_m2_valley_dropship_grunts);
	
	
	cs_ignore_obstacles (TRUE);
	cs_fly_by (ps_phantom_attack_2.p0);
	
	cs_enable_targeting (true);
	
	cs_fly_by (ps_phantom_attack_2.p1);
	
	cs_fly_to_and_face (ps_phantom_attack_2.p2, ps_phantom_attack_2.face2);
		sleep_s (1);
			f_unload_phantom (ai_current_actor, "dual");
	print ("unloading cargo");

	sleep_s (1);
	cs_fly_to (ps_phantom_attack_2.p3);
	sleep_s (1);
	cs_fly_to_and_face (ps_phantom_attack_2.p6, ps_phantom_attack_2.face);
	cs_fly_to_and_face (ps_phantom_attack_2.p2, ps_phantom_attack_2.face);
	sleep_s (3);
	cs_enable_targeting (false);
	
	cs_fly_to (ps_phantom_attack_2.p4);
	cs_fly_to (ps_phantom_attack_2.erase);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); 		
	sleep_s (3);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
end

script command_script cs_e1_m2_phantom_03																											//tjp- drops off scrubs in canyon
	ai_enter_limbo(ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); 			
	sleep_s (1);
	ai_exit_limbo (ai_current_actor);
	sleep_s (1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 60 ); 				
	
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	
	//drop-off sequence
	cs_fly_to_and_face (ps_phantom_attack_1.p6, ps_phantom_attack_1.face5);	
	cs_fly_to_and_face (ps_phantom_attack_1.p7, ps_phantom_attack_1.p0);	
	f_unload_phantom (ai_current_squad, "dual");		
	cs_fly_to_and_face (ps_phantom_attack_1.first, ps_phantom_attack_1.face3);
	cs_fly_to_and_face (ps_phantom_attack_1.p0, ps_phantom_attack_1.face3);
	cs_enable_targeting (false);
	cs_fly_to_and_face (ps_phantom_attack_1.hover_high, ps_phantom_attack_1.p2);
	cs_fly_to_and_face (ps_phantom_attack_1.p2, ps_phantom_attack_1.p3);
	cs_fly_to (ps_phantom_attack_1.p3);
	cs_fly_to (ps_phantom_attack_1.erase);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); 		
	sleep_s (7);
	e1_m2_phantom_despawn_hack(ai_current_actor);
	sleep(2);
	ai_erase (ai_get_squad(ai_current_actor));
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

script command_script cs_e1_m2_pelican
ai_enter_limbo(ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); 			
	sleep_s (1);
	ai_exit_limbo (ai_current_actor);
	sleep_s (1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 60 ); 				
	object_cannot_take_damage(ai_get_object(sq_e1_m2_pelican));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face (ps_pelican.p0, ps_pelican.p1);	
	cs_fly_to_and_face (ps_pelican.p1, ps_pelican.p2);	
	cs_fly_to_and_face (ps_pelican.p2, ps_pelican.p3);	
	sleep(30);
	cs_fly_to_and_face (ps_pelican.p3, ps_pelican.p1);	
	sleep(30 * 2);
	unit_open (vehicle(ai_current_actor));
	cs_fly_to_and_face (ps_pelican.p4, ps_pelican.p1);	
	
	b_e1_m2_game_won = true;
	
end

script static void f_mark_target (object control, unit player)						// fired from mark_target device control
	print("play pup");
	g_ics_player = player;
	pup_play_show (ppt_mark_target);
end

script static void f_cov_switch_activate (object control, unit player)
	g_ics_player = player;

	if control == dc_e1_m2_switch_1 then
			print ("play button 1 puppetshow");
			pup_play_show (ppt_e1m2_button1);
	end

	if(ai_living_count(gr_e1_m2_second_shield) == 0)then
		if control == dc_e1_m2_switch_2 then
			print ("play button 2 puppetshow");
			pup_play_show (ppt_e1m2_button2);
		elseif control == dc_e1_m2_switch_3 then
			print ("play button 3 puppetshow");
			pup_play_show (ppt_e1m2_button3);
		end
	end
end