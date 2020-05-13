// =====================================================================================
//========= VORTEX E6 M4 SCRIPT ========================================================
// =====================================================================================

global short s_scenario_state = 0;
	// 10 - hilltop reached
	// 20 - hilltop core destroyed
	// 30 - camp complete
	// 40 - door reached
	// 50 - pit [first] core destroyed
	// 60 - fingers [second] core destroyed
	// 70 - west structure open
	// 80 - central structure open
	// 90 - all AI dead
	// 100 - nukes found
global boolean b_east_trench_spawned = false;
global boolean b_core2_init = false;
global boolean b_core3_init = false;

//== startup
script startup vortex_e6_m4()

	dprint( "vortex_e6_m4: TESTING !!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	// THFRENCH - Moved your intilization into it's own function and hooked this stuff into here
	//Wait for start
	if ( f_spops_mission_startup_wait("e6_m4_startup") ) then
		wake( vortex_e6_m4_init );
	end

end

script dormant vortex_e6_m4_init()
	// THFRENCH - Basically inserted the new mission flow stuff into your stuff and removed unnecessary scripting that is automatically handled by the mission flow

	//firefight_mode_set_player_spawn_suppressed(true);
	print ("************************************************STARTING E6 M4*********************");

	fade_out (0,0,0,1);

	// set standard mission init
	f_spops_mission_setup( "e6_m4", DEF_VORTEX_ZONESET_INDEX_E6M4, e6m4_all_foes, e6m4_spawn_start, 90 );
	
	// THFRENCH - Because I don't see an intro hook i'm putting this here to let the mission flow continue.  Eventually if/when you have one you can just set this after the intro is complete
	f_spops_mission_intro_complete( TRUE );
	
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
	f_add_crate_folder(e6m4_doors);
	f_add_crate_folder(e6m4_pit);
	f_add_crate_folder(e6m4_interactivity);
	f_add_crate_folder(e6m4_device_controls);
	
	// set spawn folder names
	//firefight_mode_set_crate_folder_at(e6m4_spawn_start, 90);
	firefight_mode_set_crate_folder_at(e6m4_spawn_hillside, 91);
	firefight_mode_set_crate_folder_at(e6m4_spawn_camp, 92);
	firefight_mode_set_crate_folder_at(e6m4_spawn_pit, 93);
	firefight_mode_set_crate_folder_at(e6m4_spawn_fingers, 94);
//f_blip_object_cui (e5m2_door_barrier, "navpoint_healthbar_destroy")
	// set objective names
	firefight_mode_set_objective_name_at(c_e6m4_core_1, 80);
	firefight_mode_set_objective_name_at(lz_hilltop, 81);
	firefight_mode_set_objective_name_at(dc_e6m4_scan, 82);
	firefight_mode_set_objective_name_at(lz_east_door, 83);
	firefight_mode_set_objective_name_at(c_e6m4_core_2, 84);
	firefight_mode_set_objective_name_at(c_e6m4_core_3, 85);
	firefight_mode_set_objective_name_at(dc_e6m4_door_switch, 86);
	
	// set LZ spots
	firefight_mode_set_objective_name_at(lz_0, 50);	
//== set squad group names
	firefight_mode_set_squad_at(sq_e6m4_mouth, 1);
	firefight_mode_set_squad_at(sq_e6m4_greeters, 2);
		
// THFRENCH - This will now allow everything to start spawning
	f_spops_mission_setup_complete( TRUE );	
	//firefight_mode_set_player_spawn_suppressed(false);	// THFRENCH - Not needed, now managed by above
	
	thread (f_start_events_e6_m4());

end


script static void f_start_events_e6_m4
	print ("***********************************STARTING start_e6_m4_1*************");

	sleep(30);
	thread(f_e6m4_take_that_hill());
	thread(f_e6m4_hilltop_reached());
	thread(f_e6m4_destroy_objective_1());
	thread(f_e6m4_hilltop_explosion());
	thread(f_e6m4_pit_explosion());
	thread(f_e6m4_fingers_explosion());
	thread(f_e6m4_hilltop_done());
//	thread(f_e6m4_wraiths());
	thread(f_e6m4_camp());
	thread(f_e6m4_camp_done());
	thread(f_e6m4_door_reached());
	thread(f_e6m4_second_destroy_complete());
	thread(f_e6m4_pit_breach());
	thread(f_e6m4_prespawn_trench());
	thread(f_e6m4_fingers_breach());
	thread(f_e6m4_allcores_clean_up_stragglers());
	thread(f_e6m4_allcores_blown());
	thread(f_e6m4_terminal_interface_sequence());
	thread(f_e6m4_west_structure_init());
	thread(f_e6m4_directive_investigate_console());
	thread(f_e6m4_structure_cleanup());
	thread(f_e6m4_nukes());
	thread(f_e6m4_splatter_wind_down());
	thread(f_e6m4_central_structure_init());
	ai_place(sq_e6m4_cannoneers);
	ai_place(sq_e6m4_ghostrider_1);
	ai_place(sq_e6m4_ghostrider_2);
	ai_place(squads_40);
	ai_place(squads_41);
	
//	ai_place(sq_e6m4_mouth);
	sleep_until( f_spops_mission_start_complete(), 1 );
	fade_in (0,0,0,30);
//		thread(e6m4_());
//		kill_volume_disable(kill_);
end

//== hilltop scripts
script command_script cs_e6m4_cannoneer_1
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.1 ,v_e6m4_shade_1);
end

script command_script cs_e6m4_cannoneer_2
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.2 ,v_e6m4_shade_2);
end

script command_script cs_e6m4_cannoneer_3
	ai_vehicle_enter_immediate (sq_e6m4_cannoneers.3 ,v_e6m4_shade_3);
end

script static void f_e6m4_take_that_hill
	sleep_until(LevelEventStatus(e6m4_hill), 1);
	thread(f_new_objective (e6m4_take_hill));										
													//"Take the Hill"
end

script static void f_e6m4_destroy_objective_1
	sleep_until(LevelEventStatus(e6m4_destroy_1), 1);
	thread(f_new_objective (e6m4_destroy_power_core ));										
																	//"Destroy Volatile Core"
end

script static void f_e6m4_hilltop_reached
	sleep_until	(	volume_test_players (tv_e6m4_hilltop) or
								volume_test_players (tv_e6m4_hilltop_2) or
								volume_test_players (tv_e6m4_hilltop_3), 1);
	s_scenario_state = 10;
	if(ai_living_count(ai_ff_all) <= 16)then
		ai_place(sq_e6m4_hillside);
	end
end

script static void f_e6m4_hilltop_done
	sleep_until(LevelEventStatus(e6m4_hilltop_done), 1);
	s_scenario_state = 20;
	ai_place(sq_e6m4_pit_gunner);																			//temp - will have to spawn w/ population cap later
	sleep(30 * 6);
	thread(f_new_objective (e6m4_investigate_gear));										
												//"Investigate UNSC Gear"
	f_blip_object_cui (lz_camp, "navpoint_goto");
	sleep_until(volume_test_players (tv_camp_storage), 1) ;
	f_blip_object_cui (lz_camp, "");
	sleep(30 * 6);
	thread(f_new_objective (e6m4_scan_gear));										
												//"Scan UNSC Gear"
	sleep(30 * 2);
	b_end_player_goal = TRUE;																					//advance objectives
	device_set_power(dc_e6m4_scan, 1);
end

//== camp & door
script static void f_e6m4_prespawn_trench
	sleep_until(volume_test_players (tv_camp_storage), 1) ;
	if(b_east_trench_spawned == false)then
		thread(f_e6m4_spawn_door_guard());
	end
end


script static void f_e6m4_camp
	sleep_until(LevelEventStatus(e6m4_hilltop_done), 1);
	if (	volume_test_players (tv_camp_entry) == false) then
		ai_place(sq_e6m4_camp.entryway);
	elseif(volume_test_players (tv_camp_closet) == false) then
		ai_place(sq_e6m4_camp.closet);
	end
end

script static void f_e6m4_camp_done
	sleep_until(LevelEventStatus(e6m4_camp_done), 1);
	b_wait_for_narrative_hud = true;
	s_scenario_state = 30;
	sleep(3);
	if(b_east_trench_spawned == false)then
		thread(f_e6m4_spawn_door_guard());
	end
	sleep(30 * 4);
	thread(f_new_objective (e6m4_investigate_structure));										
												//"Investigate Structure"
	sleep(30 * 2);
	b_wait_for_narrative_hud = false;
end

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

script static void f_e6m4_door_reached
	sleep_until(LevelEventStatus(e6m4_door_reached), 1);
	s_scenario_state = 40;
	if(b_core2_init == false)then
		thread(f_e6m4_spawn_pit());
	end
	sleep(30 * 6);
	thread(f_new_objective (e6m4_destroy_power_core ));										
																//"Destroy Volatile Core"
	sleep(30 * 2);
	b_end_player_goal = TRUE;																			//advance objectives
end

//== pit
script static void f_e6m4_pit_breach
	sleep_until(volume_test_players (tv_pit), 1);
	if(b_core2_init == false)then
		thread(f_e6m4_spawn_pit());
	end
end

script static void f_e6m4_spawn_pit
	if(ai_living_count(ai_ff_all) <=16)then
			print("ai_living_count of ai_ff_all <= 15");
			if(volume_test_players (tv_pit_east) == false)then
				ai_place(sq_e6m4_pit_core.eastward);
			elseif(volume_test_players (tv_pit_west) == false)then
				ai_place(sq_e6m4_pit_core.westward);
			elseif(volume_test_players (tv_pit_backrock) == false)then
				ai_place(sq_e6m4_pit_core.backrock);
			elseif(volume_test_players (tv_camp_exit) == false)then
				ai_place(sq_e6m4_pit_core.camp);
			end
			b_core2_init = true;
	end
	if(ai_living_count(ai_ff_all) <=17)then
			print("ai_living_count of ai_ff_all <= 17");
			if(volume_test_players (tv_camp_exit) == false)then
				ai_place(sq_e6m4_pit_cave.camp);
			elseif(volume_test_players (tv_pit_backrock) == false)then
				ai_place(sq_e6m4_pit_cave.backrock);
			elseif(volume_test_players (tv_pit_west) == false)then
				ai_place(sq_e6m4_pit_cave.westward);
			elseif(volume_test_players (tv_pit_east) == false)then
				ai_place(sq_e6m4_pit_cave.eastward);
			end
			b_core2_init = true;
	end
	thread(f_e6m4_spawn_fingers_gunner());
end

script static void f_e6m4_second_destroy_complete
	sleep_until(LevelEventStatus(e6m4_core2_destroyed), 1);
	s_scenario_state = 50;
	thread(f_e6m4_spawn_fingers_gunner());
	sleep(30 * 6);
	thread(f_new_objective (e6m4_destroy_power_core ));										
																//"Destroy Volatile Core"
	sleep(30 * 2);
	b_end_player_goal = TRUE;																			//advance objectives
	if(b_core3_init == false)then
		thread(f_e6m4_spawn_fingers());
	end																													
end

//== fingers
script static void f_e6m4_fingers_breach
	sleep_until	(	volume_test_players (tv_fingers), 1);
	if(b_core3_init == false)then
		thread(f_e6m4_spawn_fingers());
	end																																			// polish add check for near or maxed population, then defer spawning til later
end

script static void f_e6m4_spawn_fingers
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
	thread(f_e6m4_spawn_fingers_gunner());
	b_core3_init = true;
end

script static void f_e6m4_spawn_fingers_gunner
	sleep_until(ai_living_count(ai_ff_all) < 22);
	if  (	(ai_living_count			(sq_e6m4_fingers_gunner) 	<= 0		) 			and
				(volume_test_players 	(tv_fingers)  						== false)			)then
		ai_place(sq_e6m4_fingers_gunner);	
	end
end

script command_script cs_e6m4_fingers_gunner
	cs_go_to_vehicle(v_e6m4_fingers_shade);
	ai_vehicle_enter(ai_current_actor, v_e6m4_fingers_shade);
end

//== all cores destroyed
script static void f_e6m4_allcores_blown
	sleep_until(LevelEventStatus(e6m4_all_cores_blown), 1);
	s_scenario_state = 60;
end

script static void f_e6m4_allcores_clean_up_stragglers
	sleep_until(LevelEventStatus(e6m4_all_cores_blown), 1);
	if(ai_living_count(ai_ff_all) >= 3)then
		print("MILLER: MARKING STRAGGLERS");
		sleep(30 * 2);
		thread(f_new_objective (vortex_objective_h));										
																//"Secure the Area"
		//bonobo will wait x seconds then move on to blip sub-objective
	end
end

//== west structure
script static void f_e6m4_west_structure_init
	sleep_until(LevelEventStatus(e6m4_open_structure), 1);
	thread(f_e6m4_deres_door(dm_west_structure_door_1));
	ai_place(sq_e6m4_fingers_ghosts.1);
	sleep(30 * 3);
	ai_place(sq_e6m4_fingers_ghosts.2);
	ai_place(sq_e6m4_fingers_structure);
	print("MILLER: Something's changed in the western structure. I think it's opened. Crimson, go check it out.");
	thread(f_e6m4_deres_door(dm_west_structure_door_2));
	thread(f_e6m4_deres_door(dm_west_structure_door_3));
	s_scenario_state = 70;
	thread(f_e6m4_west_structure_arrival_faux_objective());
end

script static void f_e6m4_west_structure_arrival_faux_objective
	if(volume_test_players (tv_west_structure) == false)then
		sleep(30 * 2);
		thread(f_new_objective (e6m4_investigate_structure));
																//"Investigate Structure"
		sleep(30);
		f_blip_object_cui (lz_west_structure, "navpoint_goto");
		sleep_until	(	volume_test_players (tv_west_structure), 1);
		f_blip_object_cui (lz_west_structure, "");
	end
end

script static void  f_e6m4_structure_cleanup
	sleep_until(LevelEventStatus(e6m4_structure_cleanup), 1);
	print("MILLER: Clear that structure of ground forces then let's investigate inside.");
	// bonobo will wait x second then move on to blip sub-objective
	sleep(30 * 2);
	thread(f_new_objective (vortex_objective_h));										
															//"Secure the Area"
end

script static void f_e6m4_directive_investigate_console
	sleep_until(LevelEventStatus(e6m4_console_enable), 1);
	print("ROLAND: Crimson I picked up an interface node inside there. If you head over there I'll get it up and running for you.");
	sleep(30 * 2);
	thread(f_e6m4_interface_faux_objective());
	sleep_until	(	volume_test_players (tv_console), 1);																		// see also f_e6m4_terminal_interface_sequence , below
	sleep(15);
	print("ROLAND: There you go Crimson. Now let's see what it does.");
	thread(f_new_objective (e6m4_deactivate_terminal));
															//"Deactivate Terminal"
end

script static void f_e6m4_interface_faux_objective
	if(volume_test_players (tv_console) == false)then
		f_blip_object_cui (dc_e6m4_door_switch, "navpoint_goto");
		sleep_until	(	volume_test_players (tv_console), 1);
		f_blip_object_cui (dc_e6m4_door_switch, "");
	end
end

script static boolean f_e6m4_deres_door(object_name dm)
	if(object_valid(dm) == true )then
		print("------------------------- dissolving");
		object_dissolve_from_marker(dm, phase_out, "dissolve");
		sleep(30 * 5);
		object_destroy(dm);
		print("------------------------- dissolved");
	end
	object_valid(dm);
end

script static void f_e6m4_terminal_interface_sequence
	//onLevelLoaded, set and hide interface
	sleep(30 * 5);
	device_set_position_track( dm_e6m4_terminal_interface, 'device:position', 0 );
	sleep(10);
	device_animate_position (dm_e6m4_terminal_interface, 1, 2, 1, 0, 0);									// big to little (1 == small)
	sleep(10);
	object_hide(dm_e6m4_terminal_interface, true);
	print("-------------------------------------------------------- switches hidden");
	//later, animate on
	sleep_until(LevelEventStatus(e6m4_console_enable), 1);
	sleep_until (volume_test_players("tv_console"), 1);
	device_animate_position (dm_e6m4_terminal_interface, 0, 2, 1, 0, 0);									// little to big
	object_hide(dm_e6m4_terminal_interface, false);
	//turn on the switch
	sleep(20);
	b_end_player_goal = TRUE;																															//advance objectives
	sleep(2);
	thread(f_e6m4_power_on_dc_switch());
end
script static void f_e6m4_kill_interface
	device_animate_position (dm_e6m4_terminal_interface, 1, 2, 1, 0, 0);									// big to little (1 == small)
	sleep_until(device_get_position(dm_e6m4_terminal_interface) > .95, 1);
	object_destroy(dm_e6m4_terminal_interface);
end
script static void f_e6m4_power_on_dc_switch
	device_set_power(dc_e6m4_door_switch, 1);
end

//== central structure
script static void f_e6m4_central_structure_init
	sleep_until(LevelEventStatus(e6m4_central_structure), 1);
	s_scenario_state = 80;
	thread(f_e6m4_kill_interface());
	thread(f_e6m4_deres_door(dm_central_door_e));
	thread(f_e6m4_deres_door(dm_central_door_w));
	ai_place(sg_e6m4_splatterfest);
	thread(f_e6m4_deres_door(dm_garage_door));
	ai_place(sq_e6m4_garage_wraith);
	sleep(30);
	thread(f_e6m4_splatterfest_intro());
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	sleep(30 * 2);
	thread(f_e6m4_deres_door(dm_garage_door_side));
end

script static void f_e6m4_splatterfest_intro
	print("MILLER: Hm.");
	print("ROLAND: Change in the central structure, looks like it's opening up.");
	sleep(30 * 2);
	print("ROLAND: And uh, looks like there was a lot of covenant in there.");
	sleep(30 * 2);
	print("MILLER: Ready up Crimson.");
	sleep(30 * 3);
	thread(f_new_objective (vortex_objective_e));
														//"Eliminate Hostiles"
end

script static void f_e6m4_splatter_wind_down
	sleep_until(LevelEventStatus(e6m4_splatter_wind_down), 1);
	print("MILLER: Just a few left. Clean em up.");
	//bonobo will wait x seconds then move on to blip sub-objective
	thread(f_new_objective (vortex_objective_h));
														//"Secure the Area"
end

//== find nukes
script static void f_e6m4_nukes
	sleep_until(LevelEventStatus(e6m4_all_dead), 1);
	s_scenario_state = 90;
	sleep(30 * 2);
	print("MILLER: Looks like we got the place all to ourselves, Crimson. Now let's see what they have in that central structure.");
	sleep(30);
	thread(f_new_objective (e6m4_investigate_structure));										
											//"Investigate Structure"
	sleep(30);
	f_blip_object_cui (lz_central, "navpoint_goto");
	sleep(30);
	sleep_until	(	volume_test_players (tv_central_entrance), 1);
	f_blip_object_cui (lz_central, "");
	print("ROLAND: High radiological readings. Take a- whoa- Crimson- Go here");
	sleep(30 * 2);
	f_blip_object_cui (lz_nukes, "navpoint_goto");
	sleep(30);
	sleep_until	(	volume_test_players (tv_nukes), 1);
	print("MILLER: Those are Havoc class tactical nukes... good god.");
	f_blip_object_cui (lz_nukes, "");
	sleep(30 * 2);
	print("ROLAND: Spartan Miller, we should evac Crimson-");
	sleep(30);
	print("MILLER: Immediately. Head out Crimson. We'll get a bomb squad there to take care of reaquiring those nukes.");
	ai_place(sq_e6m4_phantom);
	sleep(30 * 2);
	thread(f_new_objective (vortex_objective_c));
																		//"Evac"
	sleep(30 * 2);
	f_blip_object_cui (lz_evac, "navpoint_goto");
	f_add_crate_folder(e6m4_gravlift);
	sleep_until	(	volume_test_players (tv_evac), 1);
		object_cannot_take_damage(ai_get_object(sq_e6m4_phantom));
  	print ("ending the mission with fadeout and chapter complete");
    fade_out (0,0,0,25);
    player_control_fade_out_all_input (.1);
    cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

//== vehicles
script command_script cs_e6m4_hijacked_ghost
	sleep(30);
	ai_set_task(ai_current_actor, aio_ghostriders, inner_8);
end

script command_script cs_e6m4_ghostrider_1
	print("k;lagjs;kjsdgjswgpswgjeewgjp;swegjpg;ewjawge");
	cs_go_to(ghosts.p0);
	cs_go_to(ghosts.p1);
	cs_go_to(ghosts.p2);
	cs_go_to(ghosts.p3);
	cs_go_to(ghosts.p4);
	cs_go_to(ghosts.p5);
end

script command_script cs_e6m4_fingers_wraith_1
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_fingers_wraith, wraith_d);
end

script command_script cs_e6m4_fingers_wraith_2
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_fingers_wraith, wraith_g);
end

script command_script cs_e6m4_pit_wraith_1
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_pit_wraith, wraith_d);
end

script command_script cs_e6m4_pit_wraith_2
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_pit_wraith, wraith_g);
end

script command_script cs_e6m4_garage_wraith_1
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_garage_wraith, wraith_d);
end

script command_script cs_e6m4_garage_wraith_2
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_garage_wraith, wraith_g);
end

script command_script cs_e6m4_pit_gunner
	sleep(2);
	ai_vehicle_enter_immediate (ai_current_actor, v_e6m4_pit_shade);
end

script command_script cs_e6m4_finger_ghost_2
	sleep(30 * 3);
	cs_go_to(ghosts.p6);
	cs_go_to(ghosts.p8);
end

script static void f_e6m4_wraiths
	sleep_until	(	volume_test_players (tv_midline), 1);
	ai_place	(sq_e6m4_fingers_wraith);
	ai_place	(sq_e6m4_pit_wraith);
end


//== sundry

script static void f_e6m4_hilltop_explosion
	sleep_until(object_get_health(c_e6m4_core_1) == 0, 1);
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	f_e6m4_spark_explosion(flag_hilltop_0);
	sleep(6);
	f_e6m4_spark_explosion(flag_hilltop_1a);
	f_e6m4_spark_explosion(flag_hilltop_1b);
	f_e6m4_spark_explosion(flag_hilltop_1c);
	f_e6m4_spark_explosion(flag_hilltop_1d);
	f_e6m4_spark_explosion(flag_hilltop_1e);
	f_e6m4_spark_explosion(flag_hilltop_1f);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_hilltop_1b);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_hilltop_1d);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_hilltop_1c);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_destroyed.effect, flag_hilltop_1a);
	sleep(6);
	f_e6m4_plasma_explosion(flag_hilltop_0);
	f_e6m4_plasma_explosion(flag_hilltop_2a);
	f_e6m4_plasma_explosion(flag_hilltop_2b);
	f_e6m4_plasma_explosion(flag_hilltop_2c);
	f_e6m4_plasma_explosion(flag_hilltop_2d);
	f_e6m4_plasma_explosion(flag_hilltop_2e);
	f_e6m4_plasma_explosion(flag_hilltop_2f);
	f_e6m4_plasma_explosion(flag_hilltop_2g);
end

script static void f_e6m4_pit_explosion
	sleep_until(object_get_health(c_e6m4_core_2) == 0, 1);
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	f_e6m4_spark_explosion(flag_pit_0);
	sleep(6);
	f_e6m4_spark_explosion(flag_pit_1a);
	f_e6m4_spark_explosion(flag_pit_1b);
	f_e6m4_spark_explosion(flag_pit_1c);
	f_e6m4_spark_explosion(flag_pit_1d);
	f_e6m4_spark_explosion(flag_pit_1e);
	f_e6m4_spark_explosion(flag_pit_1f);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_pit_1b);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_pit_1d);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_pit_1c);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_destroyed.effect, flag_pit_1a);
	sleep(6);
	f_e6m4_plasma_explosion(flag_pit_0);
	f_e6m4_plasma_explosion(flag_pit_2a);
	f_e6m4_plasma_explosion(flag_pit_2b);
	f_e6m4_plasma_explosion(flag_pit_2c);
	f_e6m4_plasma_explosion(flag_pit_2d);
	f_e6m4_plasma_explosion(flag_pit_2e);
	f_e6m4_plasma_explosion(flag_pit_2f);
	f_e6m4_plasma_explosion(flag_pit_2g);
end

script static void f_e6m4_fingers_explosion
	sleep_until(object_get_health(c_e6m4_core_3) == 0, 1);
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	f_e6m4_spark_explosion(flag_fingers_0);
	sleep(6);
	f_e6m4_spark_explosion(flag_fingers_1a);
	f_e6m4_spark_explosion(flag_fingers_1b);
	f_e6m4_spark_explosion(flag_fingers_1c);
	f_e6m4_spark_explosion(flag_fingers_1d);
	f_e6m4_spark_explosion(flag_fingers_1e);
	f_e6m4_spark_explosion(flag_fingers_1f);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_fingers_1e);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_fingers_1c);
	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_constant_major.effect, flag_fingers_1a);
//	effect_new (objects\vehicles\covenant\storm_wraith\fx\destruction\body_destroyed.effect, flag_fingers_);
	sleep(6);
	f_e6m4_plasma_explosion(flag_fingers_0);
	f_e6m4_plasma_explosion(flag_fingers_2a);
	f_e6m4_plasma_explosion(flag_fingers_2b);
	f_e6m4_plasma_explosion(flag_fingers_2c);
	f_e6m4_plasma_explosion(flag_fingers_2d);
	f_e6m4_plasma_explosion(flag_fingers_2e);
	f_e6m4_plasma_explosion(flag_fingers_2f);
	f_e6m4_plasma_explosion(flag_fingers_2g);
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



///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// NARRATIVE COMMAND SCRIPTS //////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

