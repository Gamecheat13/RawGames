// =============================================================================================================================
//===============SCURVE E4_M4 FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//====== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
/// ================================================== GLOBAL ==================================================================
// =============================================================================================================================
// ================================================== TITLES ==================================================================


script startup scurve_e4_m4
	//Start the intro
	sleep_until (LevelEventStatus("e4_m4"), 1);
	print ("****************** STARTING E4 M4 *********************");
	switch_zone_set (e4_m4);
	mission_is_e4_m4 = true;
	b_wait_for_narrative = true;
	ai_ff_all = gr_e4_m4_ff_all;
	thread(f_start_player_intro_e4_m4());


// ================================================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;

	
//============= OBJECTS ==================================================================
//set crate names

	f_add_crate_folder(cr_forerunner_cover); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_forerunner_cover_2); //Cov Cover and fluff in the meadow
	f_add_crate_folder(v_e4_m4_unsc); //Cov Cover and fluff in the meadow
	f_add_crate_folder(dc_e4_m4_turrets); //Cov Cover and fluff in the meadow	
//	f_add_crate_folder(cr_destroy_cov_cover); //Cov Cover and fluff in the meadow	
	f_add_crate_folder(cr_e1_m5_cov_cover); //cov crates all around the main area	
	f_add_crate_folder(cr_e4_m4_unsc_cover); //Cov Cover and fluff in the meadow		
//	f_add_crate_folder(dm_cave_shields); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(dm_bridge_shields); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_bridge_cov_cover); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_defend_junk); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(cr_e1_m5_unsc_gun_racks); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(eq_defend_junk); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(eq_e1_m5_unsc_ammo); //Cov Cover and fluff on the back bridge	
//	f_add_crate_folder(v_ff_unsc_vehicles); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_bridge_cov_cover_2); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(dm_destroy_1); //prop objects like covenant computers
//	f_add_crate_folder(cr_unsc_intro_weapons); //gun racks by the intro
//	f_add_crate_folder(sc_cov_cover); //energy barrier shields
//	f_add_crate_folder(e2_m2_objective_crates); //energy barrier shields	
//	f_add_crate_folder(e2_m2_cr_unsc_base); //the base in the left forerunner area		
//	f_add_crate_folder(e2_m2_cr_scientist); //the base in the 'starting' area
////	f_add_crate_folder(e2_m2_w_unsc_base); //energy barrier shields	
//	f_add_crate_folder(bi_e2_m2_unsc_base); //dead marines
//	f_add_crate_folder(cr_e2_m2_cov_cover_1); //more covenant cover through out
//	f_add_crate_folder(cr_e2_m2_cov_cover_2); //more covenant cover through out	
//	f_add_crate_folder(dm_e2_m2_barriers); //more covenant cover through out	
//	

	//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
	f_add_crate_folder(eq_ammo_start); //ammo crates in main spawn area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
	f_add_crate_folder(eq_ammo_back); //ammo crates in the very back right	
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
	f_add_crate_folder(eq_ammo_middle); //ammo crates in back middle area	
	
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns in the front building
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the back building
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the left building
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //spawns in the back on the hill (facing the back)
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //spawns in the very back facing down the hill
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //spawns in the very back facing down the hill	
	
//set objective names
	firefight_mode_set_objective_name_at(e4_m4_core_1, 1); //uplink module on back middle
	firefight_mode_set_objective_name_at(e4_m4_core_2, 2); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_3, 3); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_4, 4); //uplink module on back middle
	firefight_mode_set_objective_name_at(coil_1, 11); //coil by shield wall
	firefight_mode_set_objective_name_at(coil_2, 12); //coil by shield wall
	firefight_mode_set_objective_name_at(coil_3, 13); //coil by shield wall
	firefight_mode_set_objective_name_at(coil_4, 14); //coil by shield wall	
	
//set LZ spots	
	firefight_mode_set_objective_name_at(lz_0, 50); //objective in the main spawn area
	firefight_mode_set_objective_name_at(lz_1, 51); //objective in the middle front building
	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the middle back building
	firefight_mode_set_objective_name_at(lz_3, 53); //objective in the left back area
	firefight_mode_set_objective_name_at(lz_4, 54); //objective in the right in the way back
	firefight_mode_set_objective_name_at(lz_5, 55); //objective in the back on the forerunner structure
	firefight_mode_set_objective_name_at(lz_6, 56); //objective in the back on the smooth platform
	firefight_mode_set_objective_name_at(lz_7, 57); //objective right by the tunnel entrance
	firefight_mode_set_objective_name_at(lz_8, 58); //objective right by the tunnel entrance
	firefight_mode_set_objective_name_at(lz_9, 59); //objective right by the tunnel entrance	
		
//set squad group names

	firefight_mode_set_squad_at(gr_e4_m4_guards_1, 1);	//left building
	firefight_mode_set_squad_at(gr_e4_m4_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(gr_e4_m4_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(gr_e4_m4_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(gr_e4_m4_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(gr_e4_m4_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(gr_e4_m4_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(gr_e4_m4_guards_8, 8); //on the bridge
	firefight_mode_set_squad_at(gr_e4_m4_guards_9, 9); //by the tunnel
	
//	firefight_mode_set_squad_at(gr_e4_m4_bridge_guards, 30); //bridge guards
	
	firefight_mode_set_squad_at(gr_e4_m4_marines_1, 	31); //main defense area
	firefight_mode_set_squad_at(gr_e4_m4_marines_2, 	32); //back spawn point
	
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
	firefight_mode_set_squad_at(gr_e4_m4_waves_1, 81);
	firefight_mode_set_squad_at(gr_e4_m4_waves_2, 82);	
	firefight_mode_set_squad_at(gr_e4_m4_waves_3, 83);
	firefight_mode_set_squad_at(gr_e4_m4_waves_4, 84);	
	firefight_mode_set_squad_at(gr_e4_m4_waves_5, 85);	
	firefight_mode_set_squad_at(gr_e4_m4_waves_6, 86);
	firefight_mode_set_squad_at(gr_e4_m4_waves_7, 87);	
	firefight_mode_set_squad_at(gr_e4_m4_waves_8, 88);	
	firefight_mode_set_squad_at(gr_e4_m4_waves_9, 89);				
//	firefight_mode_set_squad_at(gr_e4_m4_allies, 51);		
			
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
//	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
//	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge

	firefight_mode_set_squad_at(sq_e4_m4_phantom_1, 21); //phantom 1
	firefight_mode_set_squad_at(sq_e4_m4_phantom_2, 22); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//======== MAIN SCRIPT STARTS ==================================================================

end




//========STARTING E4 M4==============================

script command_script cs_stay_in_turret
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (FALSE);
	cs_abort_on_alert (FALSE);
	//(sleep_until (<= (ai_living_count ai_current_actor) 0))
end

script static void f_turret_place (ai turret_spawn, device dm_switch)
	ai_place (turret_spawn);
	print ("placing turret");
	//set up the turret so it waits until it's ready to be activated

	ai_cannot_die (turret_spawn, true);
	ai_disregard (ai_actors (turret_spawn), true);
	ai_braindead (turret_spawn, TRUE);
	
	sleep_until (LevelEventStatus("start_turrets"), 1);
	//turret is now ready to be turned powered on by the player flipping the switch
	print ("powering up turrets");
	//sleep(1);
	inspect (dm_switch);
	device_set_power (dm_switch, 1);
	inspect (device_get_power (dm_switch));
//	device_get_power (dm_switch);
	//chud_track_object_with_priority (ai_vehicle_get (turret_spawn), hud_marker);
	//f_blip_object (ai_vehicle_get (turret_spawn), hud_marker);
	f_blip_object_cui (ai_get_object (turret_spawn), "navpoint_ally_vehicle");
	sleep_until (device_get_position (dm_switch) > 0, 1);
	//the switch is flipped and is now activing shooting at fools
	f_turret_ai (turret_spawn, dm_switch);
end

script static void f_turret_ai (ai turret, device switch)
	repeat
		print ("turret online!");
		//turn off power to the switch			
		device_set_power (switch, 0);
		ai_object_set_team (turret, player);
		
		
		//turn off the HUD marker
		f_unblip_object_cui (ai_get_object (turret));

		
		//activate the turret - make it fight, make it take damage
		unit_open (ai_vehicle_get_from_spawn_point (turret));
		object_can_take_damage (ai_vehicle_get_from_spawn_point (turret));
		ai_braindead (turret, false);
		ai_disregard (ai_actors (turret), false);
		//sleep until the turret has no health
		sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (turret)) <= 0, 1);
		//turn off the turret and make the enemies disregard it
		object_cannot_take_damage (ai_vehicle_get_from_spawn_point (turret));
		print ("turret is damaged -- closing");
		ai_braindead (turret, TRUE);
		ai_disregard (ai_actors (turret), true);
		unit_close (ai_vehicle_get_from_spawn_point (turret));
		sleep (300);
		//reset the switch, give the turret health, turn the switch back on
		device_set_position_immediate (switch, 0);
		unit_set_current_vitality (ai_vehicle_get_from_spawn_point (turret), 400, 0);
		device_set_power (switch, 1);
		//blip the correct switch
		
		f_blip_object_cui (ai_get_object (turret), "navpoint_ally_vehicle");

		//wait until the switch it flipped by the player
		sleep_until (device_get_position (switch) > 0, 1);
	until (b_game_won == 1 or b_game_lost == 1);	
end


script continuous f_misc_e4_m4_spawn_turrets
	sleep_until (LevelEventStatus ("spawn_turrets"), 1);
	print ("::TURRETS::");
	//object_create_anew (turret_switch_0);
	sleep_until (object_valid (turret_switch_0));
	thread (f_turret_place (sq_e4_m4_turrets.pilot_0, turret_switch_0));
	sleep (1);
	sleep_until (object_valid (turret_switch_1));
	//object_create_anew (turret_switch_1);
	thread (f_turret_place (sq_e4_m4_turrets.pilot_1, turret_switch_1));
	//NotifyLevel ("start_turrets");
end

script continuous f_misc_e4_m4_start_turrets
	sleep_until (LevelEventStatus ("start_turrets"), 1);
	//NotifyLevel("start_turrets");
	//cinematic_set_title (turret_active);
	//m1_vo_start_turrets();
	
	//tell and remind players about using turrets
	repeat
		if device_get_power (turret_switch_0) == 1 or device_get_power (turret_switch_1) == 1 then
			print ("reminding players about the turrets");
			//vo about using the turrets
			cinematic_set_title (turret_active);
		else
			print ("NOT reminding players about the turrets because they are on");
		end
	until (b_goal_ended == true, 20 * 60);
end

script continuous f_start_events_e4_m4_1
	sleep_until (LevelEventStatus("start_e4_m4_1"), 1);
	print ("STARTING start_e4_m4_go_1");
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
	ai_place (sq_e4_m4_heavy_marines);
	//ai_place (sq_marine_heavy);
	sleep_until (object_get_health(player0) > 0, 1);

	//sleep_until (ai_living_count (sq_e4_m4_marines_1) > 0);
	//ai_set_objective (sq_ff_marines_1, obj_marine_follow);
	object_create (e1_m5_doors);
	sleep (30 * 8);
	cinematic_set_title (protect_brain);
//	sleep_until (device_get_power (objective_switch_2) == 1);
//	device_set_power (objective_switch_2, 0);


end





script continuous f_end_events_e4_m4_1
	sleep_until (LevelEventStatus("end_e4_m4_switch_1"), 1);
	print ("ENDING start_e4_m4_switch_1");
	
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_2_vo();
//	cinematic_set_title (title_shut_down_comm);
	
end


script continuous f_start_events_e4_m4_2
	sleep_until (LevelEventStatus("start_e4_m4_2"), 1);
	print ("STARTING start_e4_m4_2");
	cinematic_set_title (defend_obj_1);
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_up_beat, NONE, 1.0);
	
// if the generators are blown up then end the mission, if the goal has simply ended then restart the script
	sleep_until (object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0 or b_goal_ended == true, 1);
	if object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0 then
		b_game_lost = false;
		print ("both generators were blown up -- game lost");	
	end
end



script continuous f_end_events_e4_m4_2
	sleep_until (LevelEventStatus("end_e4_m4_2"), 1);
	print ("ENDING start_e4_m4_2");
	sound_looping_stop (music_start);
	cinematic_set_title (defend_base_safe);
	m1_vo_end_defend_1();

	sound_looping_stop (music_start);
end




script continuous f_start_events_e4_m4_3
	sleep_until (LevelEventStatus("start_e4_m4_3"), 1);
	print ("STARTING start_e4_m4_3");

	//sleep (30);
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);

	sleep (30 * 7);
	cinematic_set_title (lz_go_to);

end

script continuous f_end_events_e4_m4_3
	sleep_until (LevelEventStatus("end_e4_m4_3"), 1);
	//sleep (30);
	sound_looping_stop (music_start);
	

	cinematic_set_title (lz_end);


end

//script continuous f_start_events_e4_m4_4
//	sleep_until (LevelEventStatus("start_e4_m4_4"), 1);
//	print ("STARTING start_e1_m5_switch_3");
//	
//end
//
//
//
//script continuous f_end_events_e4_m4_4
//	sleep_until (LevelEventStatus("end_e4_m4_4"), 1);
//	print ("ENDING start_e4_m4_4");
//
//	
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sound_looping_start (music_up_beat, NONE, 1.0);
//	thread(start_camera_shake_loop ("heavy", "short"));
//	b_wait_for_narrative_hud = true;
//
//	b_wait_for_narrative_hud = false;
//
//	
//end
//
//
//
//script continuous f_start_events_e4_m4_5
//	sleep_until (LevelEventStatus("start_e4_m4_5"), 1);
//	print ("STARTING start_e1_m5_clear_base_2");
//	//sleep (30);
//	
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	
//end
//
//script continuous f_start_events_e4_m4_6
//	sleep_until (LevelEventStatus("start_e4_m4_6"), 1);
//	print ("STARTING start_e4_m4_6");
//
//
//
//end
//
//
//
//script continuous f_end_events_e4_m4_6
//	sleep_until (LevelEventStatus("end_e4_m4_6"), 1);
//	print ("ENDING start_e4_m4_6");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	
//end
//
//
//script continuous f_start_events_e4_m4_7
//	sleep_until (LevelEventStatus("start_e4_m4_7"), 1);
//	print ("STARTING start_e1_m5_swarm");
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//f_blip_object_cui (lz_5, "navpoint_goto");
//	//sleep (30);
//
//	start_e1_m3_lz_3_vo();
//	cinematic_set_title (title_swarm_1);
//end
//
//script continuous f_end_events_e4_m4_7
//	sleep_until (LevelEventStatus("end_e4_m4_7"), 1);
//	print ("ENDING start_e4_m4_7");
//
//	sound_looping_stop (music_start);
//	
//end

//script static boolean f_ready_to_end
//	sleep_until (b_pelican_done == true);
//		print ("pelican is parked");
//	object_create (dc_pelican_parked);
//
//	device_set_power(dc_pelican_parked, 1);
//	f_blip_object_cui (dc_pelican_parked, "navpoint_goto");
//	navpoint_object_set_on_radar (dc_pelican_parked, true, true);
//	sleep_until (device_get_position (dc_pelican_parked) == 1,1);
//
//end

//================ENDING E4 M4==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//===misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////





//
//script continuous f_misc_events_m5_weapon_drop_1
//	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 1");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_02, sc_resupply_02);
//	ordnance_drop(weapon_drop_1, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_2
//	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 2");
//	m2_vo_weapon_drop_2();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_01, sc_resupply_01);
//	ordnance_drop(weapon_drop_2, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_3
//	sleep_until (LevelEventStatus("m5_weapon_drop_3"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 3");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
//	ordnance_drop(weapon_drop_3, "storm_rocket_launcher");
//end
//
//script continuous f_misc_events_m5_weapon_drop_6
//	sleep_until (LevelEventStatus("m5_weapon_drop_6"), 1);
////	cinematic_set_title (weapon_drop);
//	print ("weapon drop 3");
//	m2_vo_weapon_drop_1();
//	//f_weapon_drop();
//	//calling this directly instead of using the WAVE weapon drop functionality
//	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
//	ordnance_drop(weapon_drop_6, "storm_rocket_launcher");
//end



// ==============================================================================================================
// ====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================


//script static void f_small_drop_pod_0
//	print ("drop pod 0");
//	object_create (small_pod_0);
//	thread(small_pod_0->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p0, .85, DEFUALT ));
//end
//
//script static void f_small_drop_pod_1
//	print ("drop pod 1");
//	object_create (small_pod_1);
//	thread(small_pod_1->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p1, .85, DEFUALT ));
//end



// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//======PHANTOM SCRIPTS============
// == PHANTOM 01 =================================================================================================== 
script command_script cs_e4_m4_phantom_01()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e4_m4_phantom_1.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_e4_m4_phantom_1.p1);
//		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_01.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_e4_m4_phantom_1.p1);
	cs_fly_to (ps_e4_m4_phantom_1.p3);
//	(cs_fly_by ps_e4_m4_phantom_1/erase 10)
// erase squad 
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end


// == PHANTOM 02 =================================================================================================== 
script command_script cs_e4_m4_phantom_02()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e4_m4_phantom_2.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_e4_m4_phantom_2.p1);
//		(print "flew by point 1")
	cs_fly_by (ps_e4_m4_phantom_2.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("ff_phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_e4_m4_phantom_2.p1);
	cs_fly_to (ps_e4_m4_phantom_2.p3);
//	(cs_fly_by ps_ff_phantom_01/erase 10)
// erase squad 
	sleep (30 * 5);
	ai_erase (ai_current_squad);
end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================

// ==============================================================================================================
//====== INTRO ===============================================================================
// =====================

script static void f_start_player_intro_e4_m4
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		//firefight_mode_set_player_spawn_suppressed(false);
		sleep_s (1);
		//intro_vignette_e4_m4();
		b_wait_for_narrative = false;
		//firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_s (8);
		//intro_vignette_e4_m4();
	end
	//intro();
	firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e4_m4
	print ("_____________starting vignette__________________");
	//sleep_s (8);
	//ex3();
	//b_wait_for_narrative = false;
	print ("_____________done with vignette---SPAWNING__________________");
	//firefight_mode_set_player_spawn_suppressed(false);
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
end

script static void f_narrative_done_e4_m4
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end


//script static void f_device_move (device_name device)
//	print ("device move");
//	device_set_position_track( device, 'any:idle', 1 );
////	device_set_position_immediate (bishop_tower_2, 0);
//	device_animate_position( device, 1, 5, 1, 0, 0 );
////	objects_attach (bishop_tower_2, "", objective_switch_2, "");
////	device_animate_position( bishop_tower_2, 1, 5, 1, 0, 0 );
//
//end
//
//
//script static void f_animate_device (device_name device, real time)
//	print ("animate small spire");
//	//device_set_position_transition_time (e1_m5_spire, 1);
//		device_set_position_track( device, 'any:idle', 1 );
//	device_animate_position (device, 1, time, 1, 0, 0);
//end


