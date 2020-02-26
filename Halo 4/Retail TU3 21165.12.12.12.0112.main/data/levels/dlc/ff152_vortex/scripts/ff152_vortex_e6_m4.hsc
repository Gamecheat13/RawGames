// 2.458346
// 2.393122 difference: 0.065224
// =====================================================================================
//========= VORTEX E6 M4 SCRIPT ========================================================
// =====================================================================================

global short s_scenario_state = 0;
	// 10 - hilltop reached
	// 20 - hilltop core destroyed
	// 28 - scan complete
	// 30 - camp complete
	// 40 - door reached
	// 50 - second core destroyed
	// 60 - third core destroyed
	// 70 - west structure open
	// 80 - central structure open
	// 90 - all AI dead
	// 100 - nukes found
global short s_cores_destroyed = 0;																												//total number of cores destroyed
global boolean b_core1_dead = false;																											//used in aios
global boolean b_core2_dead = false;																											//used in aios
global boolean b_core3_dead = false;																											//used in aios
global boolean b_pit_spawned = false;																											//gates spawning in sandbox areas
global boolean b_fingers_spawned = false;																									//gates spawning in sandbox areas
global boolean b_third_destroy_active = false;																						//used to parse vo
global object ob_core_actual = none;																											//active destruction target
global boolean b_ooo_vo = false;																													//has the vo been played ooo
global boolean b_vo_exception = false;																										//suppresses systemic vo, used in cases where specific vo exists
global boolean b_east_trench_spawned = false;																							//did the trench squad spawn yet?
global boolean b_scan_reminder = false;																										//?
global boolean b_garage_structure_init = false;																						//gates interior events in the garage structure
global boolean b_rvb_interact = false;																										//rvb easter egg
global boolean b_camp_door_reached = false;																								//	12-18-12: has camp door been reached yet?
//== startup
script startup vortex_e6_m4()

	dprint( "vortex_e6_m4: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	// THFRENCH - Moved your intilization into it's own function and hooked this stuff into here
	// Wait for start
	if ( f_spops_mission_startup_wait("e6_m4_startup") ) then
		wake( vortex_e6_m4_init );
	end
end

script dormant vortex_e6_m4_init()

	firefight_mode_set_player_spawn_suppressed(true);
	print ("************************************************STARTING E6 M4*********************");

	// set standard mission init
	f_spops_mission_setup( "e6_m4", e6_m4, e6m4_all_foes, e6m4_spawn_start, 90 );
	
	
	
	
	//switch_zone_set (e6_m4);		// THFRENCH - Hangled by f_spops_mission_setup
//	mission_is_e6_m4 = true;		// THFRENCH - Hangled by f_spops_mission_setup
//	b_wait_for_narrative = true;
	//ai_ff_all = e6m4_all_foes;		// THFRENCH - Hangled by f_spops_mission_setup
	f_add_crate_folder(lz_e6m4);
	f_add_crate_folder(e6m4_weapons_racks);
	f_add_crate_folder(e6m4_init_vehicles);
	f_add_crate_folder(e6m4_hilltop);
	f_add_crate_folder(e6m4_fingers);
	f_add_crate_folder(e6m4_central_structure);
	f_add_crate_folder(e6m4_cr_doors);
	f_add_crate_folder(e6m4_pit);
	f_add_crate_folder(e6m4_interactivity);
	f_add_crate_folder(e6m4_device_controls);
	f_add_crate_folder(e6m4_ammo);
	f_add_crate_folder(e6m4_camp);
	f_add_crate_folder(vortex_doors);
	f_add_crate_folder(e9_m1_hunter_doors);			// === DLE - Marked door_1 and door_2 as not automatically to ensure navmesh is created correctly.
	
	
	// set spawn folder names
	//firefight_mode_set_crate_folder_at(e6m4_spawn_start, 90);
	firefight_mode_set_crate_folder_at(e6m4_spawn_hillside, 91);
	firefight_mode_set_crate_folder_at(e6m4_spawn_camp, 92);
	firefight_mode_set_crate_folder_at(e6m4_spawn_pit, 93);
	firefight_mode_set_crate_folder_at(e6m4_spawn_fingers, 94);
	firefight_mode_set_crate_folder_at(e6m4_spawn_central, 95);
	firefight_mode_set_crate_folder_at(e6m4_spawn_central2, 96);
//f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy")
	// set objective names
	firefight_mode_set_objective_name_at(c_e6m4_core_1, 80);
	firefight_mode_set_objective_name_at(lz_hilltop, 81);
	firefight_mode_set_objective_name_at(lz_east_door, 83);
	firefight_mode_set_objective_name_at(c_e6m4_core_2, 84);
	firefight_mode_set_objective_name_at(c_e6m4_core_3, 85);
	firefight_mode_set_objective_name_at(dc_e6m4_door_switch, 86);
	
	// set LZ spots
	firefight_mode_set_objective_name_at(lz_0, 50);	
//== set squad group names
	firefight_mode_set_squad_at(sq_e6m4_phantom_outcrop, 4);
	firefight_mode_set_squad_at(sq_e6m4_phantom_reinforce, 5);
	thread (f_start_events_e6_m4());
end

script static void f_e6m4_narrative_in
	//set up, play and clean up the intro
	print ("playing intro");

//ai_enter_limbo (all);
	pup_disable_splitscreen (true);

	local long show = pup_play_show(e6_m4_in);

	sleep(30 * 4);
	thread(vo_e6m4_exterior_vortex());
			// Palmer : Fireteam Switchback, you're on Covenant dig detail. Miller's sending you the coordinates now.
			// Switchback Leader (Female) : Acknowledged, Commander.
			// Palmer : Crimson, your job is to take out this Covie munitions depot. Lots of explosions. Should be good fun.
	sleep_until (not pup_is_playing(show), 1);

	pup_disable_splitscreen (false);
	f_narrative_done();
//	ai_exit_limbo (all);
	print ("all ai exiting limbo after the puppeteer");
	f_spops_mission_intro_complete( TRUE ); //	<---- Moved here by JAYCE, as the Puppeteer is now finished.
end

script static void f_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
end

script static void f_start_events_e6_m4
	sleep_until (f_spops_mission_ready_complete(), 1); //<-----	ADDED BY JAYCE ON 11/14/12. NEEDED FOR LOADOUT SCREEN. 
	b_wait_for_narrative_hud = true;
	print ("***********************************STARTING start_e6_m4_1*************");
	ai_place_in_limbo(sq_e6m4_greeters);
	ai_place(sq_e6m4_allied_phantom);
	thread(f_e6m4_thread_all());
	if editor_mode() then
		firefight_mode_set_player_spawn_suppressed(false);
		fade_in (0,0,0,1);
//		f_e6m4_narrative_in();
		f_spops_mission_intro_complete( TRUE ); //	<---- Moved here by JAYCE, as the Puppeteer is now finished.
	else
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		f_e6m4_narrative_in();
	end	
	f_spops_mission_setup_complete( TRUE );																									//This will now allow everything to start spawning
	sleep_until( f_spops_mission_start_complete(), 1 );
	ai_exit_limbo(sq_e6m4_greeters);
	firefight_mode_set_player_spawn_suppressed(false);
	thread(f_e6m4_hax_launch_pad());
	sleep_until (b_players_are_alive(), 1);
	thread(f_e6m4_music_start());
	player_enable_input(false);
	thread(f_e6m4_gust_hack());
	thread(f_e6m4_spawn_initial_forces());
	print ("player is alive");
	sleep(35);
	if(player_valid(player0))then
		teleport_player_to_flag(player0, flag_00,true);
		object_set_velocity(player0, 5, 0, 4);
	end
	if(player_valid(player1))then
		teleport_player_to_flag(player1, flag_1,true);
		object_set_velocity(player1, 5, 0, 4);
	end
	if(player_valid(player2))then
		teleport_player_to_flag(player2, flag_2,true);
		object_set_velocity(player2, 5, 0, 4);
	end
	if(player_valid(player3))then
		teleport_player_to_flag(player3, flag_3,true);
		object_set_velocity(player3, 5, 0, 4);
	end
	sleep(2);
	thread(f_e6m4_music_geronimo_start());
	sleep (13);
	fade_in (0,0,0,30);
	sleep (10);
	thread(f_e9m3_fade_in_player_input());
	sleep(2);
	ai_object_set_targeting_bias(sq_e6m4_fodder.1, 1);																		// give the allied phantom targets
//	ai_object_set_targeting_bias(sq_e6m4_fodder.2, 1);																	// give the allied phantom targets
	ai_object_set_targeting_bias(sq_e6m4_fodder.3, 1);																		// give the allied phantom targets
	sleep(30 * 8);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_lifts_off();
			// Miller : Murphy, you gonna be okay up there?
			// Murphy : Aw, yeah. I'm having fun here! More than enough flak to go around.
	sleep(30 * 3);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_take_hill_2();
			// Palmer : Crimson, you can take that hill. Get to it.
	cui_hud_set_new_objective (e6m4_take_hill);
			//"Take the Hill"	
	b_wait_for_narrative_hud = false;
	sleep(30 * 5);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_ghost();
			// Miller : Tracking multiple Ghost signatures in your area, Crimson. Keep an eye out.
end
script static void f_e9m3_fade_in_player_input()
	sleep(25);
	player_enable_input(true);;
	vo_glo15_palmer_shoot_02();
			// Palmer : Weapons hot.
end

script static void test_launch_player0
		teleport_player_to_flag(player0, flag_00,true);
		object_set_velocity(player0, 5, 0, 4);
end
script static void f_e6m4_hax_launch_pad
	object_create(cr_hax_1);
	object_create(cr_hax_2);
	object_create(cr_hax_3);
	sleep_until (b_players_are_alive(), 1);
	sleep(50);
	object_destroy(cr_hax_1);
	object_destroy(cr_hax_2);
	object_destroy(cr_hax_3);
end
script static void f_e6m4_thread_all
	sleep(30);
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e5_m5.scenery",
														"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	thread(f_e6m4_rvb_interact());
	thread(f_e6m4_hilltop_reached());
	thread(f_e6m4_destroy_objective_1());
	thread(f_e6m4_destroy_objective_2());
	thread(f_e6m4_destroy_objective_3());
	thread(f_e6m4_core_destruction_listener(c_e6m4_core_1));
	thread(f_e6m4_core_destruction_listener(c_e6m4_core_2));
	thread(f_e6m4_core_destruction_listener(c_e6m4_core_3));
	thread(f_e6m4_hilltop_explosion(true));
	thread(f_e6m4_pit_explosion(true));
	thread(f_e6m4_fingers_explosion(true));
	thread(f_e6m4_hilltop_done());
	thread(f_e6m4_camp());
	thread(f_e6m4_second_destroy_complete());
	thread(f_e6m4_pit_breach());
	thread(f_e6m4_fingers_breach());
	thread(f_e6m4_allcores_blown());
	thread(f_e6m4_terminal_interface_sequence());
	thread(f_e6m4_nukes());
	thread(f_e6m4_set_nukes());
	thread(f_e6m4_nohurtfriendlyvehicles());
end
script static void f_e6m4_puppeteer_cleanup
	ai_erase (elite_ghost);
	ai_erase (jackals);
	ai_erase (grunts);
end

//== hilltop scripts
script static void f_e6m4_spawn_initial_forces
	ai_place(sq_e6m4_ghostrider_1);
	ai_place(sq_e6m4_ghostrider_2);
	ai_place(sq_e6m4_mouth);
	ai_place(sq_e6m4_cannoneers);
	ai_place(sq_e6m4_wraith_cairnside);
	if	(	list_count(players()) >= 2)	then
		ai_place(sq_e6m4_wraith_pitside);
	end
end

script command_script cs_e6m4_cannoneer_1
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.1 ,v_e6m4_shade_1);
end

script command_script cs_e6m4_cannoneer_2
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.2 ,v_e6m4_shade_2);
end

script command_script cs_e6m4_cannoneer_3
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.3 ,v_e6m4_shade_3);
end

script static void f_e6m4_destroy_objective_1																							// 12-18-12: ONLY INSTANCE
	sleep_until(LevelEventStatus(e6m4_destroy_1), 1);
	thread(f_e6m4_initialize_destruction_objective(c_e6m4_core_1));
end

script static void f_e6m4_destroy_objective_2																							// 12-18-12: ONLY INSTANCE
	sleep_until(LevelEventStatus(e6m4_destroy_2), 1);
	thread(f_e6m4_initialize_destruction_objective(c_e6m4_core_2));
end

script static void f_e6m4_destroy_objective_3																							// 12-18-12: ONLY INSTANCE
	sleep_until(LevelEventStatus(e6m4_destroy_3), 1);
	b_third_destroy_active = true;
	thread(f_e6m4_initialize_destruction_objective(c_e6m4_core_3));
end

script static void f_e6m4_hilltop_reached
	sleep_until	(	volume_test_players (tv_e6m4_hilltop) or
								volume_test_players (tv_e6m4_hilltop_2) or
								volume_test_players (tv_e6m4_hilltop_3), 1);
	if(s_scenario_state < 10)then
		s_scenario_state = 10;
	end
	if(ai_living_count(ai_ff_all) <= 16)then
		ai_place(sq_e6m4_hillside);
	end
end

script static void f_e6m4_hilltop_done
	sleep_until(LevelEventStatus(e6m4_hilltop_done), 1);																		// 12-18-12: TWO INSTANCES
	b_wait_for_narrative_hud = true;	
	sleep_until(		(s_scenario_state == 20)
							or	(s_cores_destroyed >= 3)
							);
	thread(f_e6m4_spawn_pit_gunner());
	sleep(30);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_unsc_gear();
			// Miller : Commander, there's UNSC inventory transponders near Crimson's position.
			// Palmer : Really? Let's take a look.
	sleep(30);
	thread(f_e6m4_camp_objective());
end

//== camp & door
script static void f_e6m4_camp_objective
	thread(f_e6m4_music_camp_combat_start());
	b_wait_for_narrative_hud = false;	
// ============ go to
	if(volume_test_players(tv_camp_approach) == false)then
		thread(f_new_objective (e6m4_investigate_gear));
				//"Investigate UNSC Gear"
		f_blip_object_cui (lz_camp, "navpoint_goto");
		sleep_until(volume_test_players(tv_camp_approach));
	end

// ============ clear covies
	if(ai_living_count(sg_e6m4_camp) >= 1)then
		f_blip_object_cui (lz_camp, "");
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_to_cave();
				// Palmer : Crimson, I'd appreciate if you taught the Covies that our toys don't belong to them.
		cui_hud_set_new_objective(vortex_objective_h);
				//"Secure the Area"
		f_blip_ai_cui(sg_e6m4_camp, "navpoint_enemy");
		sleep_until(ai_living_count(sg_e6m4_camp) <= 0);
		sleep_until(b_e6m4_narrative_is_on == false);
		thread(f_e6m4_music_camp_combat_stop());
		b_e6m4_narrative_is_on == true;
		vo_glo15_miller_allclear_01();
				// Miller : All clear.
		b_e6m4_narrative_is_on == false;
	end
	
// ============ scan
	sleep(30);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_hostiles_cleared();
			// Palmer : Let's get a proper inventory, then we'll scuttle this batch.
	cui_hud_set_new_objective(e6m4_scan_gear);
			//"Scan UNSC Gear"
	thread(f_e6m4_music_camp_scan_start());
	sleep(30);
	thread(f_e6m4_camp_player_direction());
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_get_scan();					//PIP
			// Miller : Crimson, stand near the crates so I can use your armor's sensors to collect data.
	sleep_until(volume_test_players (tv_camp_storage), 1) ;
	thread(f_player_scan_check(tv_camp_storage));																											// start effects on players
	sleep(20);
	f_e6m4_crate_scan_sequence();
	f_e6m4_camp_done();
	thread(f_e6m4_east_door_objective());	
	thread(f_remove_loc_fx());
end

script static void f_e6m4_camp_player_direction()
	sleep(30 * 2);
	effect_new(levels\dlc\ff152_vortex\fx\unsc_area_pulse_medium.effect, flag_floor_circle);
	thread(f_e6m4_blip_camp_location());	
end

script static void f_e6m4_blip_camp_location
	b_wait_for_narrative_hud = false;
	repeat
		f_blip_object_cui (lz_camp, "navpoint_generic");
		sleep_until(		(volume_test_players (tv_camp_storage))
								or	(s_scenario_state >= 30), 1
								);
		 ;
		f_blip_object_cui (lz_camp, "");
		sleep_until(		(volume_test_players (tv_camp_storage) == false)
								or	(s_scenario_state >= 30), 1
								);
	until(s_scenario_state >= 30, 1);
	f_blip_object_cui (lz_camp, "");
end

script static void f_remove_loc_fx
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player0, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player1, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player2, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player3, "pedestal");
	sleep_until (b_players_are_alive(), 1);																																	
	//change to check/wait individual players
	// to ensure they're properly stripped of effects
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player0, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player1, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player2, "pedestal");
	effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, player3, "pedestal");
	f_blip_object_cui (lz_camp, "");
end

script static void f_player_scan_check(trigger_volume tv_area)
	sleep(1);
	if player_valid(player0) then
		thread(f_player_scan(player0, tv_area));
	end
	
	if player_valid(player1) then
		thread(f_player_scan(player1, tv_area));
	end
	
	if player_valid(player2) then
		thread(f_player_scan(player2, tv_area));
	end
	
	if player_valid(player3) then
		thread(f_player_scan(player3, tv_area));
	end
end
	
script static void f_player_scan(object o_player, trigger_volume tv_area)
	sleep(1);
	print("scan effect on");
	repeat
		sleep_until(volume_test_object(tv_area, o_player), 1);
		effect_new_on_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, o_player, "pedestal");
		print("player in volume, start effect");
		sleep_until(volume_test_object(tv_area, o_player) == FALSE, 1);
		effect_kill_object_marker(levels\dlc\ff151_mezzanine\fx\body_scan.effect, o_player, "pedestal");
		print("player out of volume, kill effect");
	until(s_scenario_state >= 30, 1);
	print("scan effect off");
end

script static void f_e6m4_camp(boolean b_wait)
	if(b_wait == false)then
		s_scenario_state = 20; 																																					// cheating
	end
	sys_e6m4_camp(b_wait);
end

script static void f_e6m4_camp
	sys_e6m4_camp(true);
end


script static void sys_e6m4_camp(boolean b_wait)
	if(b_wait == true)then
		sleep_until(LevelEventStatus(e6m4_hilltop_done), 1);																	// 12-18-12: TWO INSTANCES
	end
	if (	volume_test_players (tv_camp_entry) == false) then
		ai_place(sq_e6m4_camp_1.entryway1);
		ai_place(sq_e6m4_camp_1.entryway2);
		ai_place(sq_e6m4_camp_3.entryway1);
		ai_place(sq_e6m4_camp_3.entryway2);
		if(volume_test_players (tv_camp_closet) == false) then
			ai_place(sq_e6m4_camp_2.closet1);
			ai_place(sq_e6m4_camp_2.closet2);
			ai_place(sq_e6m4_camp_1.closet1);
		else
			ai_place(sq_e6m4_camp_2.entryway1);
			ai_place(sq_e6m4_camp_2.entryway2);
			ai_place(sq_e6m4_camp_1.entryway1);
		end
	elseif(volume_test_players (tv_camp_closet) == false) then
		ai_place(sq_e6m4_camp_1.closet1);
		ai_place(sq_e6m4_camp_2.closet1);
		ai_place(sq_e6m4_camp_3.closet1);
		ai_place(sq_e6m4_camp_1.closet2);
		ai_place(sq_e6m4_camp_2.closet2);
		ai_place(sq_e6m4_camp_3.closet2);
	end
end

script static void f_e6m4_crate_scan_sequence

	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates1_start_mnde9010', cr_packing_4, 1 ); //AUDIO!
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_4, fx_hud_shield);
	if not object_valid( scan_sfx_2 ) then
		object_create( scan_sfx_2 );
	end
	
	sleep(30 * 1.5);
	thread(f_e6m4_screwing_around_check());
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates2_start_mnde9010', cr_packing_5, 1 ); //AUDIO!
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_5, fx_hud_shield);
	if not object_valid( scan_sfx_1 ) then
		object_create( scan_sfx_1 );
	end
	
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_6, fx_hud_shield);
	if not object_valid( scan_sfx_6 ) then
		object_create( scan_sfx_6 );
	end
	
	sleep(20);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates3_start_mnde9010', cr_packing_7, 1 ); //AUDIO!
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_7, fx_hud_shield);
	if not object_valid( scan_sfx_5 ) then
		object_create( scan_sfx_5 );
	end
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_large_1, fx_hud_shield);
	
	
	sleep(30);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates1_start_mnde9010', cr_packing_1, 1 ); //AUDIO!
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_1, fx_hud_shield);
	if not object_valid( scan_sfx_3 ) then
		object_create( scan_sfx_3 );
	end
	
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_2, fx_hud_shield);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_1, fx_hud_shield);
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates2_start_mnde9010', cr_large_2, 1 ); //AUDIO!
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_large_2, fx_hud_shield);
	if not object_valid( scan_sfx_4 ) then
		object_create( scan_sfx_4 );
	end
	
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_packing_3, fx_hud_shield);
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_rackstack_1, fx_hud_shield);
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_coveredrack_1, fx_hud_shield);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_3, fx_hud_shield);
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_2, fx_hud_shield);
	if not object_valid( scan_sfx_7 ) then
		object_create( scan_sfx_7 );
	end
	
	sleep(5);
	effect_new_on_object_marker( fx\library\shield\hud_scan.effect, cr_large_3, fx_hud_shield);
	
	sleep(30);
	
	effect_kill_from_flag(levels\dlc\ff152_vortex\fx\unsc_area_pulse_medium.effect, flag_floor_circle);
	s_scenario_state = 28;
	f_e6m4_scan_results_vo();
	sleep(30);
	
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_4, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_5, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_6, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_7, fx_hud_shield);
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates1_stop_mnde9010', cr_large_1, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_large_1, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_1, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_2, fx_hud_shield);
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates2_stop_mnde9010', cr_large_1, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_large_2, fx_hud_shield);
	object_destroy ( scan_sfx_4 );
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_packing_3, fx_hud_shield);
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_1, fx_hud_shield);
	object_destroy ( scan_sfx_6 );
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates3_stop_mnde9010', cr_rackstack_1, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_rackstack_1, fx_hud_shield);
	object_destroy ( scan_sfx_2 );
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates1_stop_mnde9010', cr_coveredrack_1, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_coveredrack_1, fx_hud_shield);
	object_destroy ( scan_sfx_1 );
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates2_stop_mnde9010', cr_unsc_rack_3, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_3, fx_hud_shield);
	object_destroy ( scan_sfx_5 );
	sleep(5);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e6m4_scan_crates3_stop_mnde9010', cr_unsc_rack_2, 1 ); //AUDIO!
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_unsc_rack_2, fx_hud_shield);
	object_destroy ( scan_sfx_7 );
	sleep(5);
	effect_kill_object_marker( fx\library\shield\hud_scan.effect, cr_large_3, fx_hud_shield);
	object_destroy ( scan_sfx_3 );
end

script static void f_e6m4_screwing_around_check
	player_action_test_reset();
	sleep_until(		(player_action_test_jump())
							or	(player_action_test_move_relative_all_directions())
							or	(s_scenario_state == 28)
							);
	if(s_scenario_state < 28)then
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_if_player_leaves();
				// Miller : Crimson, stop moving around so much. You're screwing up the scans.
	end
end
script static void f_e6m4_scan_results_vo
	sleep(5);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_to_cave_3();
			// Miller : Yep. That's UNSC gear alright. Stuff down there tagged for distribution to Marines, Army… there's even some Spartan gear.
end
script static void f_e6m4_camp_done
	s_scenario_state = 30;
	if(		(b_pit_spawned == false)
		and	(object_get_health(c_e6m4_core_2) > 0)
		)then
		thread(f_e6m4_spawn_pit());
	end
	sleep_until(b_e6m4_narrative_is_on == false);
	thread(vo_e6m4_ovrride_system());
			// Miller: I’ve traced an override system for the doors to the central structure. Marking it for Crimson.
end

script static void f_e6m4_east_door_objective
	thread(f_e6m4_music_camp_scan_stop());
	sleep(30 * 2);
	thread(f_new_objective (e6m4_investigate_structure));
												//"Investigate Structure"
	f_e6m4_blip_east_door_location();
	f_e6m4_door_reached();
end

script static void f_e6m4_blip_east_door_location
	f_blip_object_cui (lz_east_door, "navpoint_goto");
	sleep_until(volume_test_players (tv_east_door), 1) ;
	f_blip_object_cui (lz_east_door, "");
end

script static void f_e6m4_door_reached
	if(s_scenario_state < 40)then
		s_scenario_state = 40;
	end
	b_camp_door_reached = true;
	if(		(b_pit_spawned == false)
		and	(object_get_health(c_e6m4_core_2) > 0)
		)then
		thread(f_e6m4_spawn_pit());
	end
	
	if	(s_cores_destroyed < 3)	then
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_central_structure_2();
				// Miller : Locked up tight, but I've ID'd another munitions pile. Marking it for you now.
		b_vo_exception = true;
	elseif (s_cores_destroyed == 3) then
		vo_glo15_miller_move_03();
				// Miller : Keep moving, Spartans.
	end
	b_end_player_goal = TRUE;																																//advance objectives
	b_wait_for_narrative_hud = true;
	sleep(30 * 2);
	thread(f_e6m4_wraith_warning());
	thread(f_e6m4_hack_objective_advance());
end

/*
script static void f_e6m4_spawn_door_guard
	if(ai_living_count(ai_ff_all) <=16)then
		print("ai_living_count of ai_ff_all <= 16");
//		if((volume_test_players (tv_east_trench) or
//				volume_test_players (tv_east_door_platform) or
//				volume_test_players (tv_east_trench_airspace)) == false) then
		if(	volume_test_players (tv_east_trench) or
				volume_test_players (tv_east_door_platform) or
				volume_test_players (tv_east_trench_airspace) == false) then
			print("spawn in trench");
			b_east_trench_spawned = true;	
			ai_place(sq_e6m4_east_door.trench);
		elseif(volume_test_players (tv_hilltop_tunnel) == false)then
			print("spawn in tunnel");
			ai_place(sq_e6m4_east_door.tunnel);
			b_east_trench_spawned = true;	
		end
	else
		print("ai_living_count of ai_ff_all is greater than 16, exactly:");
		ai_living_count(ai_ff_all);
	end
end
*/
//== pit

script static void f_e6m4_pit_breach
	sleep_until(volume_test_players (tv_pit), 1);
	if(b_pit_spawned == false)then
		thread(f_e6m4_spawn_pit());
	end
end

script static void f_e6m4_spawn_pit
	if	(		(ai_living_count(ai_ff_all) <=16)
			and	(ai_living_count(sq_e6m4_pit_core) <=0)
			)	then
			if(volume_test_players (tv_pit_east) == false)then
				ai_place(sq_e6m4_pit_core.eastward);
			elseif(volume_test_players (tv_pit_west) == false)then
				ai_place(sq_e6m4_pit_core.westward);
			elseif(volume_test_players (tv_pit_backrock) == false)then
				ai_place(sq_e6m4_pit_core.backrock);
			elseif(volume_test_players (tv_camp_exit) == false)then
				ai_place(sq_e6m4_pit_core.camp);
			end
	end
	if	(		(ai_living_count(ai_ff_all) <=17)
			and	(ai_living_count(sq_e6m4_pit_cave) <=0)
			)	then
			if(volume_test_players (tv_camp_exit) == false)then
				ai_place(sq_e6m4_pit_cave.camp);
			elseif(volume_test_players (tv_pit_backrock) == false)then
				ai_place(sq_e6m4_pit_cave.backrock);
			elseif(volume_test_players (tv_pit_west) == false)then
				ai_place(sq_e6m4_pit_cave.westward);
			elseif(volume_test_players (tv_pit_east) == false)then
				ai_place(sq_e6m4_pit_cave.eastward);
			end
	end
	if(ai_living_count(sg_e6m4_pit) >= 5)then
			b_pit_spawned = true;			
			thread(f_e6m4_pitsassin(ai_living_count(sg_e6m4_pit)));
	end
	thread(f_e6m4_spawn_fingers_gunner());
end

script static void f_e6m4_spawn_pit_gunner
	sleep_until	(		(ai_living_count(ai_ff_all) <=20)
							and (volume_test_players(tv_pit_west) == false)
							and	(object_valid(v_e6m4_pit_shade))
							);
	if	(ai_living_count(sq_e6m4_pit_gunner) <=0)	then
		ai_place(sq_e6m4_pit_gunner);
	end
end

script static void f_e6m4_pitsassin (short s_baseline)
	sleep_until (s_scenario_state >= 40);
	sleep_until	(		(s_baseline - ai_living_count(sg_e6m4_pit) <= 4), 1, 30 * 12);
	if	(		(volume_test_players (tv_camp_exit) == false)
			and	(ai_living_count(ai_ff_all) <= 19)
			)	then
		ai_place(sq_e6m4_pitsassin);
	end
	sleep(30 * 2);
	if	(		(volume_test_players (tv_camp_exit) == false)
			and	(ai_living_count(ai_ff_all) <= 18)
			)	then
		ai_place(sq_e6m4_pitsistants);
	end
end

script static void f_e6m4_second_destroy_complete
	sleep_until(LevelEventStatus(e6m4_core2_destroyed), 1);																	// 12-18-12: ONE INSTANCE
	s_scenario_state = 50;
	if(		(b_fingers_spawned == false)
		and	(object_get_health(c_e6m4_core_3) > 0)
		)then
		thread(f_e6m4_spawn_fingers_gunner());
		thread(f_e6m4_spawn_fingers());
	end
end

//== fingers
script static void f_e6m4_fingers_breach
	sleep_until	(	volume_test_players (tv_fingers), 1);
	if(		(b_fingers_spawned == false)
		and	(object_get_health(c_e6m4_core_3) > 0)
		)then
		thread(f_e6m4_spawn_fingers());
	end
end

script static void f_e6m4_spawn_fingers
	if	(ai_living_count(ai_ff_all) >=22)	then
	sleep_until	(		(ai_living_count(ai_ff_all) <=20)
							and	(volume_test_players (tv_fingers)== false)
							);
	end
	if(ai_living_count(ai_ff_all) <=10)then
		ai_place(sq_e6m4_fingers_core);
		ai_place(sq_e6m4_fingers_support);
		elseif(ai_living_count(ai_ff_all) ==11)then
			ai_place(sq_e6m4_fingers_core);
			ai_place(sq_e6m4_fingers_support.1);
			ai_place(sq_e6m4_fingers_support.2);
			ai_place(sq_e6m4_fingers_support.3);
			ai_place(sq_e6m4_fingers_support.4);
			ai_place(sq_e6m4_fingers_support.5);
		elseif(ai_living_count(ai_ff_all) ==12)then
			ai_place(sq_e6m4_fingers_core);
			ai_place(sq_e6m4_fingers_support.1);
			ai_place(sq_e6m4_fingers_support.3);
			ai_place(sq_e6m4_fingers_support.4);
			ai_place(sq_e6m4_fingers_support.5);
		elseif(ai_living_count(ai_ff_all) ==13)then
			ai_place(sq_e6m4_fingers_core);
			ai_place(sq_e6m4_fingers_support.1);
			ai_place(sq_e6m4_fingers_support.4);
			ai_place(sq_e6m4_fingers_support.5);
		elseif(ai_living_count(ai_ff_all) ==14)then
			ai_place(sq_e6m4_fingers_core);
			ai_place(sq_e6m4_fingers_support.4);
			ai_place(sq_e6m4_fingers_support.5);
		elseif(ai_living_count(ai_ff_all) ==15)then
			ai_place(sq_e6m4_fingers_core);
			ai_place(sq_e6m4_fingers_support.1);
		elseif(ai_living_count(ai_ff_all) ==16)then
			ai_place(sq_e6m4_fingers_core);
		elseif(ai_living_count(ai_ff_all) ==17)then
			ai_place(sq_e6m4_fingers_core.1);
			ai_place(sq_e6m4_fingers_core.3);
			ai_place(sq_e6m4_fingers_core.4);
			ai_place(sq_e6m4_fingers_core.5);
			ai_place(sq_e6m4_fingers_core.6);
		elseif(ai_living_count(ai_ff_all) ==18)then
			ai_place(sq_e6m4_fingers_core.1);
			ai_place(sq_e6m4_fingers_core.2);
			ai_place(sq_e6m4_fingers_core.5);
			ai_place(sq_e6m4_fingers_core.6);
		elseif(ai_living_count(ai_ff_all) ==19)then
			ai_place(sq_e6m4_fingers_core.1);
			ai_place(sq_e6m4_fingers_core.4);
			ai_place(sq_e6m4_fingers_core.5);
		elseif(ai_living_count(ai_ff_all) ==20)then
			ai_place(sq_e6m4_fingers_core.1);
			ai_place(sq_e6m4_fingers_core.2);
		elseif(ai_living_count(ai_ff_all) ==21)then
			ai_place(sq_e6m4_fingers_core.1);		
	end
	if(ai_living_count(sg_e6m4_fingers) >= 5)then
			b_fingers_spawned = true;			
	end
	
	thread(f_e6m4_spawn_fingers_gunner());
end

script static void f_e6m4_spawn_fingers_gunner
	sleep_until(ai_living_count(ai_ff_all) < 22);
	if  (		(ai_living_count(sq_e6m4_fingers_gunner)<= 0)
			and	(volume_test_players(tv_fingers) == false)
			and	(object_valid(v_e6m4_fingers_shade))
			)	then
		ai_place(sq_e6m4_fingers_gunner);	
	end
end

//== Destruction Objective Scripts:

script static void f_e6m4_initialize_destruction_objective(object o_prescribed_core)
	if	(f_e6m4_set_ob_core_actual() != missile1)then																				// if there's not any more cores, skip this objective
		if( o_prescribed_core == ob_core_actual ) then
			f_e6m4_destuction_objective_intro_vo();
		else
			sleep_until(b_e6m4_narrative_is_on == false);
			vo_e6m4_objective_complete();
				// Palmer : Alright, since you're all about overachieving, let's see what else is on the menu.
			f_e6m4_destuction_objective_intro_vo();
		end
		sleep(20);
		
		if(s_cores_destroyed == 1)then
			thread(f_e6m4_music_second_plasma_well_start());
			thread(f_new_objective (e6m4_destroy_power_core_02));
								//"Destroy Second Plasma Stockpile"
		elseif(s_cores_destroyed == 2)then
			thread(f_e6m4_music_third_plasma_well_start());
			thread(f_new_objective (e6m4_destroy_power_core_03));
								//"Destroy Third Plasma Stockpile"
		else
			thread(f_new_objective (e6m4_destroy_power_core ));
								//"Destroy Plasma Stockpile"
		end
		b_wait_for_narrative_hud = false;
		sleep(30 * 1.5);
		thread(f_e6m4_blip_relay (ob_core_actual, "navpoint_healthbar_neutralize"));
	
	// objective doesn't care which core is destroyed
	// initialize objective:
	//			? - fallthrough if objective already complete
	// 			X - set core being tracked
	//			X - play appropriate vo
	// 			X - blip core until any core is destroyed
	// update upon the destruction of any core
	//			X - play appropriate vo
	//			X - check to see if current active objective is to destroy a (any) core
	//			X - remove blip
	// 			X - advance objectives
	else
		ob_core_actual = none;																																// reset
		b_end_player_goal = TRUE;																															//advance objectives, since we're out of cores
		b_wait_for_narrative_hud = true;
	end
	
	thread(f_e6m4_hack_objective_advance());
	
end

script static void f_e6m4_hack_objective_advance																					// 12-18-12: hack to handle outlier case where scenario doesn't advance
	
	sleep(30 * 2);
	if(		(object_get_health(c_e6m4_core_1) <= 0)
		and	(object_get_health(c_e6m4_core_2) <= 0)
		and	(object_get_health(c_e6m4_core_3) <= 0)
		and	(b_camp_door_reached == true)
		and	(firefight_mode_goal_get() < 5)
		)	then
/*		print("=========================");
		print("HITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITIT");
		print("HITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITIT");
		print("HITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITITHITIT");
		print("=========================");*/
		b_end_player_goal = TRUE;																															//advance objectives
	else
/*		print("SHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOOD === Should be 5:");
		inspect(firefight_mode_goal_get());
		print("SHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOOD === Should be 5:");
		inspect(firefight_mode_goal_get());
		print("SHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOODSHOULDBEGOOD === Should be 5:");
		inspect(firefight_mode_goal_get());*/
		print("=========================");
	end
	
	if(		(object_get_health(c_e6m4_core_1) <= 0)
		and	(object_get_health(c_e6m4_core_2) <= 0)
		and	(object_get_health(c_e6m4_core_3) <= 0)
		and	(b_camp_door_reached == true)
		and	(firefight_mode_goal_get() < 5)
		)	then
		thread(f_e6m4_hack_objective_advance());																							//repeat if necessary
	end
	
end

script static object f_e6m4_set_ob_core_actual()
	if	(object_get_health(c_e6m4_core_1) > 0) then
		ob_core_actual = c_e6m4_core_1;
	elseif	(object_get_health(c_e6m4_core_2) > 0) then
		ob_core_actual = c_e6m4_core_2;
		if(b_pit_spawned == false)then
			thread(f_e6m4_spawn_pit());
		end
	elseif	(object_get_health(c_e6m4_core_3) > 0) then
		ob_core_actual = c_e6m4_core_3;
		if(b_fingers_spawned == false)then
			thread(f_e6m4_spawn_fingers());
		end
	else
		ob_core_actual = missile1;
	end
	ob_core_actual;
end

script static void f_e6m4_destuction_objective_intro_vo()
	if			(s_cores_destroyed == 0) then
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_take_hill();
				// Miller : First munitions depot located and marked.
		thread(f_e6m4_destruction_objective_intro_vo_tag());
	elseif	(		(b_vo_exception == false)
					and	(s_cores_destroyed == 1) 
					)then
		sleep(30 * 1.5);
		sleep_until	(b_e6m4_narrative_is_on == false);
		vo_e6m4_destroy_thing_2();
				// Miller : Marking the next munitions pile for you.
	elseif	(		(b_vo_exception == false)
					and	(s_cores_destroyed == 2) 
					)then
		sleep(30 * 1.5);
		sleep_until	(b_e6m4_narrative_is_on == false);
		vo_e6m4_destroy_thing_3();
				// Miller : There's the last of the munitions, Crimson. Light it up.
	end
	b_vo_exception = false;																																						// reset
end

script static void f_e6m4_destruction_objective_intro_vo_tag()
		sleep(30 * 2);
		sleep_until(object_get_health(ob_core_actual) <= .9);
		sleep_until(b_e6m4_narrative_is_on == false);
		if(object_get_health(ob_core_actual) > 0) then
			vo_e6m4_destroy_thing();
					// Miller : Be advised, Crimson, the plasma in those caches is volatile stuff. Give it a nudge, and it'll blow.
		end
end

script static void f_e6m4_core_destruction_listener(object o_core)
	sleep_until	(	object_get_health(o_core) <= 0, 1);
	s_cores_destroyed = s_cores_destroyed + 1;
	if(ob_core_actual != none)then
		thread(f_e6m4_blip_relay (ob_core_actual, ""));
	end
	sleep(2);
	if		(s_cores_destroyed == 3) then
		thread(f_e6m4_music_third_plasma_well_stop());
		thread(f_e6m4_stinger_plasma_3());
		thread(f_e6m4_vo_last_core_destroyed());
	elseif(		
						(	(o_core == c_e6m4_core_1)
				and 	(s_cores_destroyed == 1)	)
				
				or
						(	(o_core == c_e6m4_core_2)
				and 	(s_cores_destroyed == 2)	)
				
				)	then
		thread(f_e6m4_vo_core_destroyed());
	else
		thread(f_e6m4_vo_core_destroyed_out_of_sequence());
	end
	if(ob_core_actual != none)then
		ob_core_actual = none;
		b_end_player_goal = TRUE;																															//advance objectives
		b_wait_for_narrative_hud = true;
	end
	if(o_core == c_e6m4_core_1)then																													//for aios
		b_core1_dead = true;
	elseif(o_core == c_e6m4_core_2)then
		b_core2_dead = true;
	elseif(o_core == c_e6m4_core_3)then
		b_core3_dead = true;
	end
end

script static void f_e6m4_vo_core_destroyed()
	if(s_cores_destroyed == 1)then
			thread(f_e6m4_music_geronimo_stop());
			thread(f_e6m4_stinger_plasma_1());
			sleep(30 * 2);
			sleep_until(b_e6m4_narrative_is_on == false);
			thread(vo_e6m4_pat_on_head());
				// Palmer : Not exactly subtle, Crimson, but you get the job done. Now let's do it a few more times.
			s_scenario_state = 20;
	elseif(s_cores_destroyed == 2)then
			thread(f_e6m4_music_second_plasma_well_stop());
			thread(f_e6m4_stinger_plasma_2());
			sleep(30 * 1.5);
			sleep_until(b_e6m4_narrative_is_on == false);
/*			if(b_third_destroy_active == true)then
				thread(vo_e6m4_thing_destroyed_2());						
						// Miller : Perfect. There's one more pile in the open. I'll mark the waypoint now.
			else
*/
				b_e6m4_narrative_is_on = true;
				vo_glo15_palmer_attaboy_06();
						// Palmer : That's what I like to see.
				b_e6m4_narrative_is_on = false;
/*			end
*/
	elseif(s_cores_destroyed == 3)then																											// shouldn't get triggered (see f_e6m4_core_destruction_listener)
			thread(f_e6m4_vo_last_core_destroyed());
	else																																										// shouldn't get triggered (see f_e6m4_core_destruction_listener)
		print("ERROR IN f_e6m4_vo_core_destroyed-----------------<><><><><>-------------------");
	end
end

script static void f_e6m4_vo_core_destroyed_out_of_sequence()
	if(b_ooo_vo == false)then
		b_ooo_vo = true;
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_special_acknowledgement();
				// Palmer : No extra credit for getting ahead of yourself. Just make sure you get ALL of the targets.
		f_e6m4_vo_core_destroyed();
	else
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_special_acknowledgement_2();
				// Palmer : Apparently you've got it all figured out down there. I suppose you can find your own way home too?	
		f_e6m4_vo_core_destroyed();
	end
end

script static void f_e6m4_vo_last_core_destroyed()
	sleep(30);
	sleep_until(b_e6m4_narrative_is_on == false);
	thread(vo_e6m4_thing_destroyed_3());
				// Miller : That's all of the munitions caches. At least, out in the open.
				// Palmer : Excellent job, everyone.	
end

script static void f_e6m4_blip_relay(object obj, string_id type)													// so can thread
	navpoint_track_object_named(obj, type);
end

script static void f_e6m4_allcores_blown
	sys_e6m4_allcores_blown(false);
end

script static void f_e6m4_allcores_blown(boolean b_cheat)
	sys_e6m4_allcores_blown(b_cheat);
	//sys_e6m4_allcores_blown(true);
end

script static void sys_e6m4_allcores_blown(boolean b_cheat)
	if(b_cheat == false)then
		sleep_until(LevelEventStatus(e6m4_all_cores_blown), 1);																// 12-18-12: ONLY INSTANCE
		b_third_destroy_active = false;
	end
	b_wait_for_narrative_hud = true;
	s_scenario_state = 60;
	sleep(30 * 1.5);
	thread(f_e6m4_post_cores_combat_sequence());
end


//== post-core
script static void f_e6m4_post_cores_combat_sequence
	if		(		(ai_living_count(sq_e6m4_wraith_cairnside) >= 1)
				and	(ai_living_count(sq_e6m4_wraith_pitside) >= 1)
				) then
			sleep(10);
			sleep_until(b_e6m4_narrative_is_on == false);
			vo_e6m4_harder_end();
					// Miller : Those Wraiths are trouble, Crimson. Best if you neutralize them before moving on.	
			thread(f_e6m4_wraith_optional_objective());
	
	elseif(		(ai_living_count(sq_e6m4_wraith_cairnside) >= 1)
				or	(ai_living_count(sq_e6m4_wraith_pitside) >= 1)
				) then
			sleep(10);
			sleep_until(b_e6m4_narrative_is_on == false);
			vo_e6m4_harder_end();
					// Miller : Those Wraiths are trouble, Crimson. Best if you neutralize them before moving on.	
			vo_glo15_miller_few_more_07();
					// Miller : Mop up the last of them.
			thread(f_e6m4_wraith_optional_objective());
	end
	
	sleep_until (		(ai_living_count(ai_ff_all) <= 10)
							and	(ai_living_count(sq_e6m4_wraith_cairnside) <= 0)
							and	(ai_living_count(sq_e6m4_wraith_pitside) <= 0)
							);
	sleep(30);
	thread(f_e6m4_sniper_spawn());
	sleep_until(ai_living_count(sq_e6m4_snipers_1) >= 3);
	sleep_until(ai_living_count(sq_e6m4_snipers_1) <= 2);
	thread(f_e6m4_garage_door_open());
end

script static void f_e6m4_wraith_optional_objective
	thread(f_e6m4_music_destroy_wraiths_start());
	sleep(20);
	thread(f_new_objective (vortex_objective_i));
						// ""Destroy""
	sleep(30);
	if	(ai_living_count(sq_e6m4_wraith_cairnside) >= 1) then
		f_blip_ai_cui(sq_e6m4_wraith_cairnside.1, "navpoint_enemy");
	end
	
	if	(ai_living_count(sq_e6m4_wraith_pitside) >= 1) then
		f_blip_ai_cui(sq_e6m4_wraith_pitside.1, "navpoint_enemy");
	end

	sleep_until (			(ai_living_count(sq_e6m4_wraith_cairnside) <= 0)
							and		(ai_living_count(sq_e6m4_wraith_pitside) <= 0)
							);
	thread(f_e6m4_music_destroy_wraiths_stop());
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_glo15_palmer_attaboy_02();
			// Palmer : Nice work, Crimson.
end

script static void f_e6m4_sniper_spawn
	// flat top				b4
	// garage pinky		a1
	// hellhorn				c5	d5
	// central ledge	c6	d6
	// ground					a2	a3	d7
	// ramp						a8	c8	d8
	
	if(volume_test_players (tv_snipe_pocket) == false)then																						// pinky
		ai_place(sq_e6m4_snipers_1.a1);
	end
	
	if(volume_test_players (tv_snipe_trench) == false)then																						// hellhorn
		ai_place(sq_e6m4_snipers_1.d5);
	elseif(volume_test_players (tv_snipe_chute) == false)then
		ai_place(sq_e6m4_snipers_1.c5);
	end
	
	sleep(2);
	
	if(volume_test_players (tv_snipe_pocket) == false)then																						// ground
		ai_place(sq_e6m4_snipers_1.a2);
	elseif(volume_test_players (tv_snipe_trench) == false)then
		ai_place(sq_e6m4_snipers_1.d7);
	end

	if(volume_test_players (tv_snipe_pocket) == false)then																	
		ai_place(sq_e6m4_snipers_1.a8);
	elseif(volume_test_players (tv_snipe_trench) == false)then																				// ramp
		ai_place(sq_e6m4_snipers_1.d8);
	elseif(volume_test_players (tv_snipe_chute) == false)then
		ai_place(sq_e6m4_snipers_1.c8);
	end
/* //alternate order
	if		(volume_test_players (tv_snipe_trench) == false)then																				// ramp
		ai_place(sq_e6m4_snipers_1.d8);
	elseif(volume_test_players (tv_snipe_chute) == false)then
		ai_place(sq_e6m4_snipers_1.c8);
	elseif(volume_test_players (tv_snipe_pocket) == false)then																	
		ai_place(sq_e6m4_snipers_1.a8);
	end
*/

	thread(f_e6m4_sniper_vo_and_objective());

	sleep_until(ai_living_count(sq_e6m4_snipers_1) <= 3);
	
	sleep(30);

	if		(			(	ai_living_count(sq_e6m4_snipers_1.d5) + ai_living_count(sq_e6m4_snipers_1.c5) <= 0)	// hellhorn
					and (volume_test_players (tv_snipe_trench) == false)
				)then
			ai_place(sq_e6m4_snipers_1.d5);
	elseif(			(	ai_living_count(sq_e6m4_snipers_1.d5) + ai_living_count(sq_e6m4_snipers_1.c5) <= 0)
					and (volume_test_players (tv_snipe_chute) == false)
				)then
			ai_place(sq_e6m4_snipers_1.c5);
	end

	sleep(2);

	if(volume_test_players (tv_snipe_pocket) == false)then																						// ground
		ai_place(sq_e6m4_snipers_1.a3);
	elseif(volume_test_players (tv_snipe_trench) == false)then
		ai_place(sq_e6m4_snipers_1.d7);
	end
	
	sleep(2);
	
	if(volume_test_players (tv_snipe_trench) == false)then																						// central
		ai_place(sq_e6m4_snipers_1.c6);
	elseif(volume_test_players (tv_snipe_chute) == false)then
		ai_place(sq_e6m4_snipers_1.d6);
	end

	sleep_until(ai_living_count(sq_e6m4_snipers_1) <= 3);

	if(					(	ai_living_count			(sq_e6m4_snipers_1.a1) <= 0)																		// pinky
					and (	volume_test_players (tv_snipe_pocket) == false)
				)then
			ai_place(sq_e6m4_snipers_1.a1);
	elseif(volume_test_players (tv_snipe_pocket) == false)then																				// else ground
		ai_place(sq_e6m4_snipers_1.a3);
	elseif(volume_test_players (tv_snipe_trench) == false)then
		ai_place(sq_e6m4_snipers_1.d7);
	end

end

script static void f_e6m4_sniper_vo_and_objective
	sleep_until(ai_living_count(sq_e6m4_snipers_1) >= 2);
	sleep(30 * 2);
	sleep_until(b_e6m4_narrative_is_on == false);
	thread(f_e6m4_music_snipers_battle_start());
	vo_e6m4_snipers();
			// Miller : Snipers!
			// Miller : Find some cover!
			// Palmer : Neutralize all targets.
	cui_hud_set_new_objective(vortex_objective_e);
			// "Eliminate Hostiles"
end

script static void f_e6m4_garage_door_open
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e9m1_tower_wall_door_med_derez_mnde943', cr_garage_door, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_garage_door));
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_left_01', cr_garage_door_2, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_garage_door_2));
	thread(f_e6m4_garage_interior_sequence());
	s_scenario_state = 62;
	object_create(dm_e6m4_gravlift);
	object_create(dc_e6m4_gravlift);
	sleep(20);
	ai_place(sq_e6m4_fingers_ghost_1);
	ai_place(sq_e6m4_fingers_ghost_2);
	ai_place(sq_e6m4_garage_grunts);
//	object_create(v_garage_ghost_2);
	object_create(v_garage_ghost_3);
	b_end_player_goal = TRUE;																																//advance objectives to NMW
	thread(f_e6m4_garage_few_left());
	sleep(30 * 3);
	thread(f_e6m4_jumper());
	if(b_e6m4_narrative_is_on == false)then
		vo_glo15_palmer_ghosts_01();
				// Palmer : Ghosts!
	end
	thread(f_e6m4_garage_contingent_objective());
end
script static void f_e6m4_garage_few_left
	sleep_until(LevelEventStatus(e6m4_few_left), 1);
	sleep(30 * 1.25);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_bad_guys_remaining();
				// Palmer : Miller, dust up the last of the ground forces, then let's see if they've hidden anything inside that central structure.
				// Miller : You got it, Commander.		
		s_scenario_state = 70;		
	b_wait_for_narrative_hud = false;																														//causes mobs in fingers aio to seek player with magic player sight
end

script static void f_e6m4_garage_contingent_objective (boolean b_wait)
	sys_e6m4_garage_contingent_objective(b_wait);
end
script static void f_e6m4_garage_contingent_objective
	sys_e6m4_garage_contingent_objective(true);
end

script static void sys_e6m4_garage_contingent_objective(boolean b_wait)
	if	(b_wait == true) then
		sleep_until(LevelEventStatus(e6m4_garage_clear), 1);
		thread(f_e6m4_music_snipers_battle_stop());
	end
	sleep(30 * 1.25);
	
	if(volume_test_players(tv_upstairs) == false) then
		sleep_until(b_e6m4_narrative_is_on == false, 2);		
		vo_e6m4_interface();
				// Palmer : Have a look around. There has to be some way to open this tin can up.
		if(volume_test_players(tv_upstairs) == false)then
			sleep_until(b_e6m4_narrative_is_on == false, 2);		
			vo_e6m4_activity_in_structure_1();
					// Miller : Looks like a lot of activity deeper in the structure.
		end
	end
	
	
	if(volume_test_players(tv_upstairs) == false)then
		if(b_garage_structure_init == false)then
			vo_glo15_palmer_waypoint_01();
					// Palmer : Setting a waypoint.
			thread(f_new_objective (e6m4_investigate_structure));
					// "Investigate Structure"
		end
	end
	thread(f_e6m4_garage_contingent_blip());
end

script static void f_e6m4_garage_contingent_blip()
	sleep(30);
	b_wait_for_narrative_hud = false;
	sleep(1);
	repeat
		sleep_until	(		(volume_test_players(tv_upstairs) == false)
								or	(s_scenario_state >= 80), 1
								);
		if					(		(volume_test_players(tv_upstairs) == false)
								and (s_scenario_state < 80)
								)then
			f_blip_object_cui (dc_e6m4_gravlift, "navpoint_activate");
		end
		sleep_until(		(volume_test_players(tv_upstairs) == true)
										or	(s_scenario_state >= 80), 1
								);
		f_blip_object_cui (dc_e6m4_gravlift, "");
	until(s_scenario_state >= 80);	
	sleep(2);
	f_blip_object_cui (dc_e6m4_gravlift, "");
end

script static void f_e6m4_gravlift																												// called from dc

	thread(f_e6m4_blue_cloudy());

	if(volume_test_object(tv_gravlift_v, player0) == true)then
//	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_man_cannon_blast', player0, 1 ); //AUDIO!
		thread(f_e6m4_levitate(player0));
	end
	if(volume_test_object(tv_gravlift_v, player1) == true)then
//	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_man_cannon_blast', player1, 1 ); //AUDIO!
		thread(f_e6m4_levitate(player1));
	end
	if(volume_test_object(tv_gravlift_v, player2) == true)then
//	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_man_cannon_blast', player2, 1 ); //AUDIO!
		thread(f_e6m4_levitate(player2));
	end
	if(volume_test_object(tv_gravlift_v, player3) == true)then
//	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_man_cannon_blast', player3, 1 ); //AUDIO!
		thread(f_e6m4_levitate(player3));
	end
end

script static void f_e6m4_blue_cloudy
	effect_new (levels\dlc\ff152_vortex\fx\energy\gravlift_blue_cloudy.effect, fx_gravlift_1);
	sleep(30 * 3);
	effect_kill_from_flag( levels\dlc\ff152_vortex\fx\energy\gravlift_blue_cloudy.effect, fx_gravlift_1);
end

script static void f_e6m4_levitate(object o_player)
	local boolean b_rotated = false;
	sleep(15);
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_man_cannon_blast', o_player, body, 1 ); //AUDIO!
	if (b_garage_structure_init == false) then	
		repeat
			object_set_velocity(o_player, 0, 0, 2);
			if(volume_test_object(tv_gravlift_h, o_player) == true)then
				object_set_velocity(o_player, 3, 0, 0);
				if (b_rotated == false) then
					player_disable_movement (o_player, TRUE);
	//				camera_control (o_player, FALSE);
					player_control_lock_gaze(o_player, foot.p29, 180);
					b_rotated = true;
				end
			end
		until	(		(volume_test_object(tv_gravlift_v, o_player) == false)
					and	(volume_test_object(tv_gravlift_h, o_player) == false), 1
					);
		sleep(25);
		player_control_unlock_gaze (o_player);
	//	camera_control (o_player, TRUE);
		player_disable_movement (o_player, FALSE);
	else
		repeat
			object_set_velocity(o_player, 0, 0, 2);
			if(volume_test_object(tv_gravlift_h, o_player) == true)then
				object_set_velocity(o_player, 3, 0, 0);
			end
		until	(		(volume_test_object(tv_gravlift_v, o_player) == false)
					and	(volume_test_object(tv_gravlift_h, o_player) == false), 1
					);
	end
end

script static void f_e6m4_jumper
	sleep_until(volume_test_players (tv_garage) == true, 1);
	ai_place(sq_e6m4_garage_grunt_jumper);
end

script static void f_e6m4_garage_interior_sequence
	sleep_until(volume_test_players(tv_upstairs) == true, 1);
	ai_place_in_limbo(sq_e6m4_geist);
	if(b_e6m4_narrative_is_on == false)then
	thread(vo_e6m4_structure_opening());
			// Miller : There's movement.
			// Palmer : Be ready, Crimson.
	end
	b_garage_structure_init = true;
	sleep_until(ai_living_count(sq_e6m4_geist) <= 0);
	sleep(30);
	if(ai_living_count(ai_ff_all) >= 1)then
		sleep_until(b_e6m4_narrative_is_on == false);
		b_e6m4_narrative_is_on = true;
		vo_glo15_palmer_fewmore_01();
				// Palmer : You've still got some stragglers out there.
		b_e6m4_narrative_is_on = false;
		if(ai_living_count(ai_ff_all) >= 1)then
				cui_hud_set_new_objective(vortex_objective_e);
						// "Eliminate Hostiles"		
		end
	end
	sleep_until(ai_living_count(ai_ff_all) <= 0);
	sleep(30);
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_open_structure();
			// Miller : That's all of them.
			// Palmer : Roll on, Crimson.
			// Miller : Setting a waypoint.
	thread(f_e6m4_central_structure_init());
	b_wait_for_narrative_hud = false;
	b_end_player_goal = TRUE;																																//advance objectives
	thread(f_e6m4_blip_toggler());
	sleep(3);
	device_set_power(dc_e6m4_door_switch, 1);
	cui_hud_set_new_objective(vortex_objective_b);
					// "Investigate"
end


script static void f_e6m4_blip_toggler
	if(volume_test_players(tv_upstairs) == true) then
		f_blip_object_cui (dc_e6m4_door_switch, "navpoint_activate");
	end
	repeat
		sleep_until(		(volume_test_players(tv_upstairs) == false)
								or	(s_scenario_state >= 80), 1
								);
		if (s_scenario_state < 80) then
			f_blip_object_cui (dc_e6m4_door_switch, "");
			f_blip_object_cui (dc_e6m4_gravlift, "navpoint_activate");
		end
		sleep_until(		(volume_test_players(tv_upstairs) == true)
								or	(s_scenario_state >= 80), 1
								);
		if (s_scenario_state < 80) then
			f_blip_object_cui (dc_e6m4_gravlift, "");
			f_blip_object_cui (dc_e6m4_door_switch, "navpoint_activate");
		end
	until(s_scenario_state >= 80, 1);
	sleep(2);
	f_blip_object_cui (dc_e6m4_gravlift, "");
	f_blip_object_cui (dc_e6m4_door_switch, "");	
end
/*
		thread(f_new_objective (e6m4_investigate_structure));
																//"Investigate Structure"
		sleep(30);
		f_blip_object_cui (lz_west_structure, "navpoint_goto");
		sleep_until	(	volume_test_players (tv_west_structure), 1);
		f_blip_object_cui (lz_west_structure, "");
*/

//== west structure


script static void f_e6m4_terminal_interface_sequence
	sleep(30 * 5);
	device_set_position_track( dm_e6m4_terminal_interface, 'device:position', 0 );
	sleep(10);
	device_animate_position (dm_e6m4_terminal_interface, 0, 2, 1, 0, 0);									// little to big
end

//== central structure
script static void f_e6m4_central_structure_init
	//sleep_until(device_get_position(dc_e6m4_door_switch) >= 0.1, 1);
	//sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e6m4_terminal_interface, 1 ); //AUDIO!
	sleep_until(device_get_position(dc_e6m4_door_switch) >= 1, 1);
	s_scenario_state = 80;
	thread(f_e6m4_kill_interface());
	sleep(30 * 1.25);
	thread(f_e6m4_stinger_central_structure_open());
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_right_02', cr_west_1, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_west_1));
	object_set_physics (cr_west_1, false);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_left_01', cr_west_2, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_west_2));
	object_set_physics (cr_west_2, false);
	
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_04', cr_central_door_1, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_central_door_1));
	object_set_physics (cr_central_door_1, false);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_left_01', cr_lower_door, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_lower_door));
	object_set_physics (cr_lower_door, false);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_05', cr_big_wall, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_big_wall));
	object_set_physics (cr_big_wall, false);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_05', cr_floor_2, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_floor_2));	
	object_set_physics (cr_floor_2, false);
	
	//ai_place(sg_e6m4_splatterfest);
	ai_place(sg_e6m4_central_wave_1);
	sleep(30);
	thread(f_e6m4_splatterfest_intro());
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread(camera_shake_all_coop_players( .1, .7, 1, 0.1));
	thread(f_e6m4_central_combat_sequence());
	sleep(30 * 2);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_03', cr_west_3, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_west_3));
	object_set_physics (cr_west_3, false);
end

script static void f_e6m4_kill_interface
	sleep(30 * 1);
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e6m4_terminal_interface, 1 ); //AUDIO!
	device_animate_position (dm_e6m4_terminal_interface, 1, 2, 1, 0, 0);									// big to little (1 == small)
	device_set_power(dc_e6m4_door_switch, 0);
	sleep_until(device_get_position(dm_e6m4_terminal_interface) > .95, 1);
	object_destroy(dm_e6m4_terminal_interface);
	object_destroy(dc_e6m4_door_switch);
end

script static void f_e6m4_central_stucture_deres_far_doors
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_04', cr_central_door_2, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_central_door_2));
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_04', cr_central_door_2b, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_central_door_2b));
end

script static void f_e6m4_central_structure_deres_final
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_05', cr_interior_door, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_interior_door));
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_05', cr_interior_door_2, 1 ); //AUDIO!
	thread(f_e6m4_deres_door(cr_interior_door_2));
end

script static void f_e6m4_splatterfest_intro
	thread(f_e6m4_music_central_battle_start());
	vo_e6m4_terminal_accessed();
			// Miller : That did it! Structure's open.
			// Miller : That's weird. When the structure opened, Crimson's sensors…
			// Palmer : Spit it out.
			// Miller : Everything's fine now. I'll keep an eye on it.
	sleep(30 * 1);
	thread(f_new_objective (vortex_objective_e));
			// "Eliminate Hostiles"
	sleep_until(b_e6m4_narrative_is_on == false);
	vo_e6m4_ordnance();
			// Miller : Hunters!
			// Palmer : Dalton.		
			// Dalton : Ordinance inbound on Crimson's position now.
			// Palmer : Roger that.
	sleep(30 * 2);
	thread(f_e6m4_ordnance());
end

script static void f_e6m4_ordnance
	
	ordnance_drop (fl_weapon_drop_1, "storm_spartan_laser");
	print("Adfasdfasdf");
	sleep(20);
	ordnance_drop (fl_weapon_drop_2, "storm_spartan_laser");
	sleep(30 * 1.5);
//	ordnance_drop (fl_weapon_drop_3, "storm_spartan_laser");
	sleep(30 * 5);
	sleep_until(ai_living_count(sg_e6m4_hunters_west) <= 0, 1, 30 * 300);
	ordnance_show_nav_markers(false);
end

script static void f_e6m4_central_combat_sequence
	local short s_baseline = ai_living_count(sg_e6m4_central_wave_1);
	sleep_until	(	s_baseline - (ai_living_count(sg_e6m4_central_wave_1)) >= 8, 3);
	
	thread(f_e6m4_phantom_reinforce());
	ai_place_in_limbo(sq_e6m4_central_geist);
	
	sleep_until	(	s_baseline - (ai_living_count(sg_e6m4_central_wave_1)) >= 10, 3);
	
	if(volume_test_players (tv_central_sword) == false)then
		ai_place(sq_e6m4_sword_seeker);
	end

	sleep_until	(		(s_scenario_state >= 82)
							and (	ai_living_count(ai_ff_all) <= 16 ), 1
							);
	
	ai_place(sq_e6m4_interior_camo);
	thread(f_e6m4_deres_remaining());
	thread(f_e6m4_end_of_central_encounter());
end

script static void f_e6m4_deres_remaining
	sleep_until(volume_test_players(tv_central_entrance));
	thread(f_e6m4_central_structure_deres_final());
	thread(f_e6m4_central_stucture_deres_far_doors());	
	if(s_scenario_state < 84) then
		s_scenario_state = 84;
	end
	f_create_new_spawn_folder(96);
end

script static void f_e6m4_phantom_reinforce
	sleep_until	(		(ai_living_count(sg_e6m4_hunters_west) <= 2)
							and	(ai_living_count(ai_ff_all) <= 8), 1	
							);
	s_scenario_state = 82;
	ai_place(sq_e6m4_phantom_reinforce);
	sleep(30 * 3);
	sleep_until(b_e6m4_narrative_is_on == false);
	b_e6m4_narrative_is_on = true;
	vo_glo15_miller_phantom_01();
			// Miller : Phantom on approach.
	b_e6m4_narrative_is_on = false;
end

script static boolean f_e6m4_load_in_reinforcements
	ai_place_in_limbo(sq_e6m4_reinf_east_elite);
	ai_place_in_limbo(sq_e6m4_reinf_east_grunt);
	ai_place_in_limbo(sq_e6m4_reinf_west_grunt);
	ai_place_in_limbo(sq_e6m4_reinf_lower_jackal_1);
	ai_place_in_limbo(sq_e6m4_reinf_lower_jackal_2);
	ai_place_in_limbo(sq_e6m4_reinf_upper_elite);
	ai_place_in_limbo(sq_e6m4_reinf_upper_grunt);
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_rf_main", ai_actors(sq_e6m4_reinf_east_elite));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_rf_small_1", ai_actors(sq_e6m4_reinf_east_grunt));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_lf_small_1", ai_actors(sq_e6m4_reinf_west_grunt));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_pc_1", ai_actors(sq_e6m4_reinf_lower_jackal_1));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_rf_small_2", ai_actors(sq_e6m4_reinf_lower_jackal_2));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_lf_main", ai_actors(sq_e6m4_reinf_upper_elite));
	vehicle_load_magic(ai_vehicle_get_from_squad(sq_e6m4_phantom_reinforce, 0), "phantom_p_lf_small_2", ai_actors(sq_e6m4_reinf_upper_grunt));
	ai_exit_limbo(sq_e6m4_reinf_east_elite);
	ai_exit_limbo(sq_e6m4_reinf_east_grunt);
	ai_exit_limbo(sq_e6m4_reinf_west_grunt);
	ai_exit_limbo(sq_e6m4_reinf_lower_jackal_1);
	ai_exit_limbo(sq_e6m4_reinf_lower_jackal_2);
	ai_exit_limbo(sq_e6m4_reinf_upper_elite);
	ai_exit_limbo(sq_e6m4_reinf_upper_grunt);
	true;
end

script static void f_e6m4_end_of_central_encounter
	sleep_until(ai_living_count(ai_ff_all) <= 5);
	sleep (30);

// == divergent objectives:
// ==
// == option A: investigate structure objective
	if(ai_living_count(sg_e6m4_central_cloaked) >= 5)then
		sleep_until(b_e6m4_narrative_is_on == false);		
		vo_e6m4_no_bad_guys();
				// Palmer : Miller, let's see if they've hidden anything inside that central structure.
				// Miller : You got it, Commander.
		thread(f_new_objective (e6m4_investigate_structure));										
				//"Investigate Structure"
		f_blip_object_cui (lz_central, "navpoint_goto");
		sleep_until	(		(	volume_test_players (tv_central_entrance))
							or	(	volume_test_players (tv_central_sword))
							or	(	volume_test_players (tv_nukes)), 1
							);
		f_blip_object_cui (lz_central, "");		
		sleep_until(b_e6m4_narrative_is_on == false);
		if(ai_living_count(sg_e6m4_central_cloaked) >= 5)then																						// all cloakers alive
			b_e6m4_narrative_is_on = true;
			vo_glo15_miller_covenant_02();
					// Miller : More Covenant!
			sleep(10);
			vo_glo15_palmer_fewmore_09();
					// Palmer : Check your corners, folks.
			b_e6m4_narrative_is_on = false;
			cui_hud_set_new_objective(vortex_objective_e);
					// "Eliminate Hostiles"
		elseif(ai_living_count(sg_e6m4_central_cloaked) >= 2)then																				// some cloakers alive
			b_e6m4_narrative_is_on = true;
			vo_glo15_palmer_fewmore_07();
					// Palmer : Mop up the last of them.	
			b_e6m4_narrative_is_on = false;
			cui_hud_set_new_objective(vortex_objective_e);
					// "Eliminate Hostiles"
		end
		
		sleep_until(ai_living_count(sg_e6m4_central_cloaked) <= 1);
		sleep_until(b_e6m4_narrative_is_on == false);
		if(ai_living_count(sg_e6m4_central_cloaked) == 1)then																					// down to last
			vo_glo15_miller_one_more_02();
					// MILLER: One to go.
			f_blip_ai_cui(sg_e6m4_central_cloaked, "navpoint_enemy");
		end

// == option B: blip remaining
	else
		s_scenario_state = 86;
		sleep(30);
		sleep_until(b_e6m4_narrative_is_on == false);
		vo_e6m4_compliment_player();
				// Palmer : Glad I don't have to clean up after you, Crimson. Messy but effective.
		f_blip_ai_cui(ai_ff_all, "navpoint_enemy");
		cui_hud_set_new_objective(vortex_objective_h);
				//"Secure the Area"
	end
	
	sleep_until(ai_living_count(ai_ff_all) <= 0);
	sleep(30);
	b_end_player_goal = TRUE;																																//advance objectives
end



//== find nukes 
script static void f_e6m4_nukes
	sleep_until(LevelEventStatus(e6m4_all_dead), 1);
	b_wait_for_narrative_hud = true;
	s_scenario_state = 90;
	sleep(30 * 2);
	vo_e6m4_investigate_central_structure();
			// Miller : Commander, I've found the location of that mysterious reading. Placing a waypoint for Crimson.
	
	sleep(30);
	thread(f_new_objective (e6m4_investigate_structure));										
											//"Investigate Structure"
	b_wait_for_narrative_hud = false;
	sleep(10);
/*	f_blip_object_cui (lz_central, "navpoint_goto");
	sleep_until	(		(	volume_test_players (tv_central_entrance))
							or	(	volume_test_players (tv_nukes)), 1
							);
	f_blip_object_cui (lz_central, "");
*/
	f_blip_object_cui (lz_nukes, "navpoint_goto");
	sleep(30);
	sleep_until	(	volume_test_players (tv_nukes), 1);
	f_blip_object_cui (lz_nukes, "");
	thread(f_e6m4_stinger_nukes_discovered());
	vo_e6m4_nukes();
			// Palmer : Tell me that's not what I think it is.
			// Miller : A stockpile of stolen UNSC nukes?
	sleep(20);
	ai_place_in_limbo(sq_e6m4_allied_phantom_2);
	vo_e6m4_immediate_evac();
			// Palmer : Miller, send down a disposal team -
			// Miller : Commader, that won't be necessary. Those nukes have all had their warheads stripped. The Covies took them somewhere else.
	sleep(20);
	if	(b_rvb_interact == true) then
		vo_e6m4_switchback_RVBALT();
				// rvb easter egg alternate of the switchback line
	else
		vo_e6m4_switchback();
			// Switchback Leader (Female) : Switchback to Infinity!
			// Palmer : Go ahead, Switchback.
			// Switchback Leader (Female) : Covies have a Harvester down here! Encountering massive resistance. Request backup!
			// Palmer : Crimson, you're the closest responder. Fall out and help Switchback.
			//pip ^
	end
	sleep(20);
	thread(f_new_objective (vortex_objective_c));
																		//"Evac"
	f_blip_object_cui (lz_evac, "navpoint_goto");
	sleep_until	(	volume_test_players (tv_evac), 1);
		thread(f_e6m4_music_stop());
  	print ("ending the mission with fadeout and chapter complete");
    fade_out (0,0,0,14);
    player_control_fade_out_all_input (.1);
    cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
    s_scenario_state = 100;
    b_end_player_goal = true;
end

script static void f_e6m4_faux_gravlift
	if not object_valid( lz_evac ) then
		object_create( lz_evac );
	end
	
	effect_new_on_object_marker(objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect, ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom_2.1), "lift_direction" );
	sound_looping_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\loops\spops_dm_e6m2_green_beam_loop_mnde8298', lz_evac, 1 ); //LOOPING AUDIO!
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_init_mnde8298', ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom_2.1), 1 ); //AUDIO!
	repeat
		if(volume_test_object(tv_gravlift, player0) == true)then
			thread(f_e6m4_faux_levitate(player0));
		end
		if(volume_test_object(tv_gravlift, player1) == true)then
			thread(f_e6m4_faux_levitate(player1));
		end
		if(volume_test_object(tv_gravlift, player2) == true)then
			thread(f_e6m4_faux_levitate(player2));
		end
		if(volume_test_object(tv_gravlift, player3) == true)then
			thread(f_e6m4_faux_levitate(player3));
		end
	until(s_scenario_state >= 100, 4);
end

script static void f_e6m4_faux_levitate(object o_player)
	sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_lift_in_mnde8298', o_player, body, 1 ); //AUDIO!
	repeat
		object_set_velocity(o_player, 0, 0, 2);
	until(s_scenario_state >= 100, 1);
end
script static void f_e6m4_rotate(object o_player)
	repeat
		object_rotate_by_offset(o_player, 20, 0, 0, 180, 0, 0);
	until(s_scenario_state >= 100, 20);
end
//== vehicles
script static void test_garage_exit
	if(object_valid(cr_garage_door))then
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_vortex\dm\spops_dm_e06m4_structuredoors_derez_mnde944_05', cr_garage_door, 1 ); //AUDIO!
		thread(f_e6m4_deres_door(cr_garage_door));
	end
	sleep(10);
	ai_place(sq_e6m4_fingers_ghost_1);
	sleep(30 * 2);
	ai_place(sq_e6m4_fingers_ghost_2);
end

script static void f_e6m4_blip_all_available_ghosts
	thread(f_blip_ghost(v_pit_ghost_1));
	thread(f_blip_ghost(v_pit_ghost_2));
	thread(f_blip_ghost(v_pit_ghost_3));
	thread(f_blip_ghost(v_garage_ghost_1));
	thread(f_blip_ghost(v_garage_ghost_2));
	thread(f_blip_ghost(v_garage_ghost_3));
	thread(f_e6m4_unblip_ghosts());
end

script static void f_e6m4_unblip_ghosts												//switch to •	spops_blip_auto_[flag/object]_[trigger/distance] – 
	sleep_until(LevelEventStatus(e6m4_unblip_ghosts), 1);				//switch to •	spops_blip_auto_[flag/object]_[trigger/distance] – 
	sleep(10);																									//switch to •	spops_blip_auto_[flag/object]_[trigger/distance] – 
	navpoint_track_object_named(v_pit_ghost_1, "");							//switch to •	spops_blip_auto_[flag/object]_[trigger/distance] – 
	navpoint_track_object_named(v_pit_ghost_2, "");							//switch to •	spops_blip_auto_[flag/object]_[trigger/distance] – 
	navpoint_track_object_named(v_pit_ghost_3, "");
	navpoint_track_object_named(v_garage_ghost_1, "");
	navpoint_track_object_named(v_garage_ghost_2, "");
	navpoint_track_object_named(v_garage_ghost_3, "");
end

script static void f_blip_ghost (vehicle ghost)
	navpoint_track_object_named(ghost, "navpoint_generic");
	sleep_until(player_in_vehicle(ghost));
	navpoint_track_object_named(ghost, "");
end


// LOAD PAYLOAD: load 1 or 2 vehicles onto a Phantom

script static void f_e6m4_load_payload (ai dropship, ai squad1)
	print ("spawning payload");
	ai_place_in_limbo  (squad1);
	sleep_until (ai_living_count (dropship) > 0);
	vehicle_load_magic(ai_vehicle_get_from_squad(dropship, 0), "phantom_lc", ai_vehicle_get_from_squad(squad1, 0));
	print ("payload attached");
	ai_exit_limbo (squad1);
end
script static void f_e6m4_load_payload (ai dropship, ai squad1, ai squad2)
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

script static void f_e6m4_despawn_hack(ai phantom)
	sleep(30);
	print("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
		print("----=-=-=-=-----phantom alive, trying to erase");
		ai_erase (ai_get_squad(phantom));
		print("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		f_e6m4_despawn_hack(phantom);
	else
		print("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end

script static void f_e6m4_wraith_warning
	if(list_count(players()) >= 2)then
		sleep_until(			(		(ai_fighting_count(sq_e6m4_wraith_cairnside))
											+		(ai_fighting_count(sq_e6m4_wraith_pitside))
											>= 1
											)
									and
											(		(objects_distance_to_object(player0, ai_vehicle_get(sq_e6m4_wraith_cairnside.1)) <= 30)
											or	(objects_distance_to_object(player0, ai_vehicle_get(sq_e6m4_wraith_pitside.1)) <= 30)
											), 1
								);
	else
			sleep_until(		(		(ai_fighting_count(sq_e6m4_wraith_cairnside)>= 1)
											and	(objects_distance_to_object(player0, ai_vehicle_get(sq_e6m4_wraith_cairnside.1)) <= 30)
											), 1
									);
	end
	sleep(30 * 2);
	sleep_until(b_e6m4_narrative_is_on == false);
	if((				(list_count(players()) >= 2)	
				and		(object_get_health(ai_vehicle_get_from_spawn_point(sq_e6m4_wraith_cairnside.1)) == 1)
				and		(object_get_health(ai_vehicle_get_from_spawn_point(sq_e6m4_wraith_pitside.1)) == 1) 				 
			)	
			or
			(				(list_count(players()) <= 1)	
				and		(object_get_health(ai_vehicle_get_from_spawn_point(sq_e6m4_wraith_cairnside.1)) == 1) 				 
			)
		)then
		vo_e6m4_wraith();
				// Miller : Wraith, closing on your position!
	end
end


//== command script

script command_script cs_greeter_grunt_0
	cs_abort_on_damage(true);
	cs_walk(true);
	sleep_until (b_players_are_alive(), 1);
	thread(f_e6m4_greeter_wake_on_alert(ai_current_actor));
	cs_go_to(foot.p3);
	cs_face_player(true);
end

script command_script cs_greeter_grunt_1
	cs_abort_on_damage(true);
	cs_walk(true);
	sleep_until (b_players_are_alive(), 1);
	thread(f_e6m4_greeter_wake_on_alert(ai_current_actor));
	cs_go_to(foot.p4);
	cs_go_to(foot.p5);
	cs_face_player(true);
end

script command_script cs_greeter_jackal_commander
	cs_abort_on_damage(true);
	cs_walk(true);
	sleep_until (b_players_are_alive(), 1);
	thread(f_e6m4_greeter_wake_on_alert(ai_current_actor));
	cs_go_to(foot.p1);
end

script command_script cs_greeter_jackal
	cs_abort_on_damage(true);
	cs_walk(true);
	sleep_until (b_players_are_alive(), 1);
	thread(f_e6m4_greeter_wake_on_alert(ai_current_actor));
	cs_go_to(foot.p2);
	cs_face_player(true);
end

script static void f_e6m4_greeter_wake_on_alert(ai ai_dis_guy)
	sleep(30 * real_random_range(1.2, 2.5));
	cs_abort_on_alert(ai_dis_guy, true);
end

script command_script cs_e6m4_allied_phantom
	ai_set_blind (ai_current_squad, true);
	unit_open(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom.1));
	object_cannot_take_damage(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom.1));
	object_hide(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom.1), true);
	sleep_until (b_players_are_alive(), 1);	
	print("--------phantom-----------------------------players spawned-------------------");
	sleep(30);
	object_hide(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom.1), false);
	cs_fly_to_and_face(ally.p0, ally.face0);
	sleep(30);
	
	cs_ignore_obstacles (TRUE);
	cs_enable_targeting (true);
	ai_set_blind (ai_current_squad, false);
	cs_vehicle_speed(1);
	unit_close(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom.1));
	cs_fly_to_and_face(ally.p1, ally.face1);
	sleep(30 * 7);
	cs_fly_to_and_face(ally.p2, ally.face2);
	sleep(30 * 7);
	cs_fly_to_and_face(ally.p3, ally.face2);
	cs_fly_to_and_face(ally.p4, ally.face4);
	cs_fly_to_and_face(ally.p5, ally.face5);
	f_e6m4_despawn_hack(ai_current_actor);

end

script command_script cs_e6m4_allied_phantom_2
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 01 );
	ai_set_blind (ai_current_squad, true);
	sleep (2);
	ai_exit_limbo(ai_current_actor);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 210 ); 
	
	object_cannot_take_damage(ai_vehicle_get_from_spawn_point(sq_e6m4_allied_phantom_2.1));
	
	cs_fly_to_and_face(ally.p6, ally.face6);
		
	cs_vehicle_speed(.75);
	
	cs_fly_to_and_face(ally.p7, ally.face7);
	cs_vehicle_speed(.75);
	cs_fly_to_and_face(ally.p8, ally.face8);
	cs_vehicle_speed(.75);
//	f_blip_object_cui (ai_vehicle_get (ai_current_actor), "navpoint_goto");
	cs_fly_to_and_face(ally.p9, ally.face9);
	cs_vehicle_speed(.75);
	cs_fly_to_and_face(ally.p10, ally.face10);
	cs_vehicle_speed(.75);
	cs_fly_to_and_face(ally.p11, ally.face11);
	cs_vehicle_speed(.75);
//	f_blip_object_cui (ai_vehicle_get (ai_current_actor), "");
	sleep(2);
	thread(f_e6m4_faux_gravlift());
	cs_face(true, ally.face11);
end


script command_script cs_e6m4_hijacked_ghost
	sleep(30);
	ai_set_task(ai_current_actor, aio_ghostriders, inner_8);
end

script command_script cs_e6m4_ghostrider_1
	cs_go_to(ghosts.p0);
	cs_go_to(ghosts.p1);
	cs_go_to(ghosts.p2);
	cs_go_to(ghosts.p3);
	cs_go_to(ghosts.p4);
	cs_go_to(ghosts.p5);
end

script command_script cs_e6m4_ghostrider_fingers_1
	print("----------------------------------- cs_fingers_1_ghostrider ------------------------------");
	cs_go_to(ghosts.p6);
	cs_go_to(ghosts.p7);
end

script command_script cs_e6m4_ghostrider_fingers_2
	print("----------------------------------- cs_fingers_222_ghostrider ------------------------------");
	sleep(30 * 2);
	cs_go_to(ghosts.p6);
end

script command_script cs_e6m4_phantom_outcrop
	ai_set_blind (ai_current_squad, true);
	thread(f_e6m4_load_payload(sq_e6m4_phantom_outcrop, sq_e6m4_wraith_outcrop));
	sleep(10);
	cs_ignore_obstacles (TRUE);
	sleep(10);
	cs_fly_to_and_face(phantom.p0, phantom.face1);
	cs_fly_to_and_face(phantom.p1, phantom.face2);
	cs_fly_to_and_face(phantom.p2, phantom.face3);
	cs_fly_to_and_face(phantom.p3, phantom.face4);
	cs_fly_to_and_face(phantom.p4, phantom.face4);
	sleep(30);
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e6m4_phantom_outcrop.1), "");
	sleep(30);
	cs_fly_to_and_face(phantom.p3, phantom.face5);
	cs_fly_to_and_face(phantom.p5, phantom.face5);
	cs_fly_to_and_face(phantom.p6, phantom.face6);
	cs_fly_to_and_face(phantom.p7, phantom.face7);
	cs_fly_to_and_face(phantom.p8, phantom.face8);
	f_e6m4_despawn_hack(ai_current_actor);
end

//object_destroy(list_get (object_list_children (vin_e6_m4_phantom, objects\vehicles\covenant\storm_phantom\turrets\phantom_chin_gun\storm_phantom_chin_gun.vehicle),0));
//ai_set_blind (ai_get_unit(vehicle_driver(vin_e6_m4_phantom)), true);
//

script command_script cs_e6m4_phantom_reinf
	ai_set_blind (ai_current_squad, true);
	thread(f_e6m4_load_payload(sq_e6m4_phantom_reinforce, sq_e6m4_reinf_ghostrider_1));
	f_e6m4_load_in_reinforcements();
	sleep(10);
	cs_ignore_obstacles (TRUE);
	sleep(10);
	cs_fly_to_and_face(phantom.p0, phantom.face1);
	cs_fly_to_and_face(phantom.p1, phantom.face2);
	cs_fly_to_and_face(phantom.p2, phantom.face3);
	cs_fly_to_and_face(phantom.p3, phantom.face4);
	cs_fly_to_and_face(phantom.p4, phantom.face4);
	sleep(30);
	vehicle_unload(ai_vehicle_get_from_spawn_point (sq_e6m4_phantom_reinforce.1), "");
	sleep(30 * 3);
	cs_fly_to_and_face(phantom.p3, phantom.face5);
	cs_fly_to_and_face(phantom.p5, phantom.face5);
	cs_fly_to_and_face(phantom.p6, phantom.face6);
	cs_fly_to_and_face(phantom.p7, phantom.face7);
	cs_fly_to_and_face(phantom.p8, phantom.face8);
	f_e6m4_despawn_hack(ai_current_actor);
end

script command_script cs_e6m4_pit_gunner
	cs_go_to_vehicle(v_e6m4_pit_shade);
	ai_vehicle_enter(ai_current_actor, v_e6m4_pit_shade);
end

script command_script cs_e6m4_fingers_gunner
//	cs_go_to_vehicle(v_e6m4_fingers_shade);
	ai_vehicle_enter(ai_current_actor, v_e6m4_fingers_shade);
end

script command_script cs_e6m4_snipers_1
	cs_jump(60, 7.65);
end

script command_script cs_e6m4_snipers_2
	cs_go_to_and_face(foot.p6, foot.p7);
end

script command_script cs_e6m4_snipers_3
	cs_go_to_and_face(foot.p8, foot.p9);
end

script command_script cs_e6m4_snipers_4
	cs_go_to_and_face(foot.p14, foot.p15);
	cs_jump(45, 6.95);
end

script command_script cs_e6m4_snipers_5
	cs_go_to_and_face(foot.p16, foot.p17);
	cs_jump(75, 7.4);
end

script command_script cs_e6m4_snipers_6
	cs_jump(65, 6.9);
end

script command_script cs_e6m4_snipers_7
	cs_go_to_and_face(foot.p18, foot.p19);
	cs_jump(45, 5.9);
end

script command_script cs_e6m4_snipers_8
	cs_go_to_and_face(foot.p20, foot.p28);
	cs_jump(60, 6.9);
end

script command_script cs_e6m4_snipers_9
	cs_go_to_and_face(foot.p26, foot.p27);
	cs_jump(70, 5.4);
end

script command_script cs_e6m4_snipers_10
	cs_go_to_and_face(foot.p24, foot.p25);
	cs_jump(65, 7.25);
end

script command_script cs_e6m4_camp_1
	cs_go_to(foot.p30, 1);
end

script command_script cs_e6m4_camp_2
	cs_go_to(foot.p31, 1);
end

script command_script cs_e6m4_pitsassin
	cs_walk(false);
	cs_go_to(foot.p10, 1);
	cs_walk(false);
	cs_go_to(foot.p11, 1);
	cs_walk(false);
	cs_go_to(foot.p12, 1);
	cs_face_player(true);
end
script command_script cs_e6m4_pitsassin_alt
	cs_walk(false);
	cs_go_to(foot.p10, 1);
	cs_walk(false);
	cs_go_to(foot.p11, 1);
	cs_walk(false);
	cs_face_player(true);
end

script command_script cs_e6m4_geist
	cs_abort_on_damage(true);
	ai_set_active_camo(ai_current_actor, true);
	ai_exit_limbo(ai_current_actor);
	
	sleep_until(volume_test_players(tv_gravlift_h) == true, 1);
	sleep(1);
	cs_walk(false);
	cs_go_to(foot.p21, 1);
end

script command_script cs_e6m4_central_geist
	cs_abort_on_damage(true);
	ai_set_active_camo(ai_current_actor, true);
	ai_exit_limbo(ai_current_actor);
	sleep_until(volume_test_players(tv_central_sword) == true, 1);
	sleep(1);
	cs_go_to(foot.p22, 1);
end

script command_script cs_e6m4_central_geist_2
	cs_abort_on_damage(true);
	ai_set_active_camo(ai_current_actor, true);
	ai_exit_limbo(ai_current_actor);
	sleep_until(volume_test_players(tv_central_sword) == true, 1);
	sleep(1);
	cs_go_to(foot.p23, 1);
end

script command_script cs_e6m4_central_commandos
	ai_set_active_camo(ai_current_actor, true);
	sleep_until(s_scenario_state >= 84);
	sleep(30);
	ai_set_task(ai_current_actor, "aio_central", "camo_interior");
end
//== sundry

script static void f_e6m4_hilltop_explosion()
	thread(sys_e6m4_hilltop_explosion());
end

script static void f_e6m4_hilltop_explosion(boolean b_wait)
	if (b_wait == true)then
		sleep_until(object_get_health(c_e6m4_core_1) <= 0, 1);
	end
	thread(sys_e6m4_hilltop_explosion());
end

script static void sys_e6m4_hilltop_explosion
	print("-----init hilltop explosion");
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	thread(f_e6m4_puoci_explosion(flag_hilltop_0));
	sleep(3);
	thread(f_e6m4_ongoing_plasma_fires(flag_hilltop_1b, flag_hilltop_1d, flag_hilltop_1c));
end

script static void f_e6m4_pit_explosion()
	thread(sys_e6m4_pit_explosion());
end

script static void f_e6m4_pit_explosion(boolean b_wait)
	if (b_wait == true)then
		sleep_until(object_get_health(c_e6m4_core_2) == 0, 1);
	end
	thread(sys_e6m4_pit_explosion());
end

script static void sys_e6m4_pit_explosion
	print("-----init pit explosion");
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	thread(f_e6m4_puoci_explosion(flag_pit_0));
	sleep(3);
	thread(f_e6m4_ongoing_plasma_fires(flag_pit_1b, flag_pit_1d, flag_pit_1c));
end

script static void f_e6m4_fingers_explosion()
	thread(sys_e6m4_fingers_explosion());
end

script static void f_e6m4_fingers_explosion(boolean b_wait)
	if (b_wait == true)then
		sleep_until(object_get_health(c_e6m4_core_3) == 0, 1);
	end
	thread(sys_e6m4_fingers_explosion());
end

script static void sys_e6m4_fingers_explosion
	print("-----init fingers explosion");
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	thread(f_e6m4_puoci_explosion(flag_fingers_0));
	sleep(3);
	thread(f_e6m4_ongoing_plasma_fires(flag_fingers_1e, flag_fingers_1c, flag_fingers_1a));
end

script static void f_e6m4_spark_explosion ( cutscene_flag flag )
	//thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	//ordnance_drop (flag, "default");
	//effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	//effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	//effect_new (fx\reach\fx_library\explosions\covenant_explosion_large\covenant_explosion_large.effect , flag);
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_huge\covenant_explosion_huge.effect , flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
end

script static void f_e6m4_plasma_explosion ( cutscene_flag flag )
	effect_new (fx\reach\fx_library\explosions\covenant_explosion_artillery_huge\covenant_explosion_artillery_huge.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
end

script static void f_e6m4_puoci_explosion ( cutscene_flag flag )
	effect_new (levels\dlc\ff152_vortex\fx\destruction\covenant_explosion_huge.effect, flag);
	damage_new( 'levels\dlc\ff152_vortex\damage_effects\plasma_well_explosion_player_kill.damage_effect', flag);
	damage_new( 'levels\dlc\ff152_vortex\damage_effects\plasma_well_explosion.damage_effect', flag);
	damage_new( 'levels\dlc\ff152_vortex\damage_effects\plasma_well_explosion_players.damage_effect', flag);
end

script static void f_e6m4_ongoing_plasma_fires ( cutscene_flag flag1, cutscene_flag flag2, cutscene_flag flag3)
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag1);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag2);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag3);

	sleep(30 * 18);
	thread(f_e6m4_remove_ongoing_plasma_fire_effect(flag1));
	sleep(30);
	thread(f_e6m4_remove_ongoing_plasma_fire_effect(flag2));
	sleep(30 * 2);
	thread(f_e6m4_remove_ongoing_plasma_fire_effect(flag3));
end

script static void f_e6m4_remove_ongoing_plasma_fire_effect( cutscene_flag flag)
	effect_kill_from_flag(objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag);
  effect_delete_from_flag(objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag);
end

script static boolean f_e6m4_deres_door(object_name dm)
	if(object_valid(dm) == true )then
		object_dissolve_from_marker(dm, "phase_out", "fx_derez");
		sleep(30 * 5);
		object_destroy(dm);
	end
	object_valid(dm);
end

global object g_ics_player = none;

script static void f_e6m4_switch_hit (object dev, unit player)
	
	g_ics_player = player;
	
	local long show = pup_play_show(pup_e6m4_switch);
	sleep_until (not pup_is_playing(show), 1);
 	/*
 	device_set_position (dm_e8_m1_barrier, 1);
 	sleep_until (device_get_position (dm_e8_m1_barrier) == 1, 1);
 	object_hide (dm_e8_m1_barrier, true);
	*/
end

script static void f_e6m4_set_nukes
	object_cannot_take_damage(missile1);
	object_cannot_take_damage(missile2);
	object_cannot_take_damage(missile3);
end



script static void f_e6m4_rvb_interact
	object_create (cr_rvb);
	sleep_until (object_get_health (cr_rvb) < 1, 1);
                
	object_cannot_take_damage (cr_rvb);
                
	//play stinger
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
  
  b_rvb_interact = true;
  inspect (b_rvb_interact);
//  f_achievement_spops_1();
end



script static void f_e6m4_gust_hack
	repeat
		if(volume_test_object(tv_gust, player0) == true)then
			object_set_velocity(player0, 5, 0, 4);
		end
		if(volume_test_object(tv_gust, player1) == true)then
			object_set_velocity(player1, 5, 0, 4);
		end
		if(volume_test_object(tv_gust, player2) == true)then
			object_set_velocity(player2, 5, 0, 4);
		end
		if(volume_test_object(tv_gust, player3) == true)then
			object_set_velocity(player3, 5, 0, 4);
		end
	until(s_scenario_state >= 10, 1, 30 * 5);
end


script static void f_e6m4_nohurtfriendlyvehicles
  print ("player vehicles are immune");
  repeat
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(0)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(1)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(2)), true);
  	object_immune_to_friendly_damage (unit_get_vehicle (player_get(3)), true);
  until (b_game_ended == true, 1);            
end


///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// NARRATIVE COMMAND SCRIPTS //////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////


//vo_e6m4_activity_in_structure()
// Miller : Looks like a lot of activity deeper in the structure.
// Palmer : Anything else on the armor sensors?
// Miller : Not yet. Keeping an eye on it.

	// specials:
	
	//vo_e6m4_thing_destroyed_1();
			// Dalton : Commander? Dalton here. There's a lot of air traffic near Crimson's location. But it's headed away.
			// Palmer : I see we've put the fear of Spartans into them. Keep it up, Crimson.
			
		//vo_e6m4_no_bad_guys()
			// Palmer : Miller, let's see if they've hidden anything inside that central structure.
			// Miller : You got it, Commander.
			
		//vo_e6m4_clear_structure();
			// Palmer : Clear antying in your way, Spartans.
		//vo_glo15_palmer_reinforcements_01()
		// Palmer : Reinforcements!
		
			
/*			
	vo_e6m4_vehicle_callout();
			// Miller : There’s a lot of Covie vehicles around. Grab a ride.
	thread(f_e6m4_blip_all_available_ghosts());
	sleep(30 * 3);
	
		sleep(30 * 8);
	vo_e6m4_eliminate_hostiles();
		// Miller : Considerable resistence.
		// Palmer : Well, now I'm just curious as hell about what's so important in there.
	
	
*/