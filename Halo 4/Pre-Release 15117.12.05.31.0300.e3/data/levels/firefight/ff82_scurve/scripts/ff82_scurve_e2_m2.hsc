// =============================================================================================================================
//========= SCURVE FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
// ===========LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
//========= GLOBAL===================================================================

global string_id	title_e2_m2_0 = ch_e2_m2_0;
global string_id	title_e2_m2_1 = ch_e2_m2_1;
global string_id	title_e2_m2_2 = ch_e2_m2_2;
global string_id	title_e2_m2_3 = ch_e2_m2_3;
global string_id	title_e2_m2_4 = ch_e2_m2_4;
global string_id	title_e2_m2_5 = ch_e2_m2_5;
global string_id	title_e2_m2_6 = ch_e2_m2_6;
global string_id	title_e2_m2_7 = ch_e2_m2_7;
global string_id	title_e2_m2_8 = ch_e2_m2_8;
//global cutscene_title	title_e2_m2_9 = ch_e2_m2_9;

// =============================================================================================================================
// ================================================== TITLES ==================================================================


script startup scurve_e2_m2
	//Start the intro
	sleep_until (LevelEventStatus("e2_m2"), 1);
	print ("******************STARTING E2 M2*********************");
	switch_zone_set (e2_m2);
	mission_is_e2_m2 = true;
	b_wait_for_narrative = true;
	ai_ff_all = e2_m2_gr_ff_all;
	thread(f_start_player_intro_e2_m2());

//start the first starting event
	thread (f_start_events_e2_m2_1());
	print ("starting e2_m2_1");

	thread (f_start_all_events_e2_m2());

// ================================================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;

	
//======= OBJECTS ==================================================================
//set crate names


	f_add_crate_folder(cr_cave_shield); //Cov Cover and fluff in the meadow
	f_add_crate_folder(cr_e1_m5_unsc_gun_racks); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(e2_m2_cr_unsc_base); //the base in the left forerunner area		
	f_add_crate_folder(e2_m2_cr_scientist); //the base in the 'starting' area
	f_add_crate_folder(e2_m2_w_unsc_base); //energy barrier shields	
	f_add_crate_folder(bi_e2_m2_unsc_base); //dead marines
	f_add_crate_folder(cr_e2_m2_cov_cover_1); //more covenant cover through out
	f_add_crate_folder(cr_e2_m2_cov_cover_2); //more covenant cover through out	
	f_add_crate_folder(dm_e2_m2_barriers); //more covenant cover through out	
	f_add_crate_folder(e2_m2_objective_crates); //more covenant cover through out		

	//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
//	f_add_crate_folder(eq_ammo_start); //ammo crates in main spawn area
//	f_add_crate_folder(eq_defend_1_crates); //ammo crates in front middle area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
//	f_add_crate_folder(eq_ammo_back); //ammo crates in the very back right	
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
//	f_add_crate_folder(eq_ammo_middle); //ammo crates in back middle area	
	
	
	
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
	firefight_mode_set_crate_folder_at(spawn_points_10, 80); //spawns in the very back facing down the hill		
	
//set objective names
	firefight_mode_set_objective_name_at(comm_array_1, 1); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_2, 2); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_3, 3); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_4, 4); //uplink module on back middle
	firefight_mode_set_objective_name_at(e2_m2_power_core, 11); //coil by shield wall
//	firefight_mode_set_objective_name_at(coil_2, 12); //coil by shield wall
//	firefight_mode_set_objective_name_at(coil_3, 13); //coil by shield wall
//	firefight_mode_set_objective_name_at(coil_4, 14); //coil by shield wall	
	
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
		
//set squad group names

	firefight_mode_set_squad_at(gr_e2_m2_guards_1, 1);	//left building
	firefight_mode_set_squad_at(gr_e2_m2_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(gr_e2_m2_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(gr_e2_m2_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(gr_e2_m2_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(gr_e2_m2_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(gr_e2_m2_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(gr_e2_m2_guards_8, 8); //on the bridge
	firefight_mode_set_squad_at(gr_e2_m2_guards_9, 9); //by the tunnel
	
	firefight_mode_set_squad_at(gr_e2_m2_bridge_guards, 30); //bridge guards
	
//	firefight_mode_set_squad_at(gr_ff_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
	firefight_mode_set_squad_at(gr_e2_m2_waves_1, 81);
	firefight_mode_set_squad_at(gr_e2_m2_waves_2, 82);	
	firefight_mode_set_squad_at(gr_e2_m2_waves_3, 83);
	firefight_mode_set_squad_at(gr_e2_m2_waves_4, 84);	
	firefight_mode_set_squad_at(gr_e2_m2_waves_5, 85);	
	firefight_mode_set_squad_at(gr_e2_m2_waves_6, 86);
	firefight_mode_set_squad_at(gr_e2_m2_waves_7, 87);	
			
	firefight_mode_set_squad_at(gr_e2_m2_allies, 51);		
			
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
//	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
//	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge

	
	firefight_mode_set_squad_at(sq_ff_phantom_01, 20); //phantom 1
	firefight_mode_set_squad_at(sq_ff_phantom_02, 21); //phantom 1




//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//==== MAIN SCRIPT STARTS ==================================================================

end

//threading all the event scripts that are called through the gameenginevarianttag
script static void f_start_all_events_e2_m2
	print ("threading all the event scripts");
	//event tags
	
	//thread (f_start_events_e2_m2_1();
	//print ("starting e2_m2_1");

	thread (f_end_events_e2_m2_1());
	print ("ending e2_m2_1");

	thread (f_start_events_e2_m2_2());
	print ("starting e2_m2_2");
	
	thread (f_end_events_e2_m2_2());
	print ("ending e2_m2_2");
	
	thread (f_start_events_e2_m2_3());
	print ("starting e2_m2_3");
	
	thread (f_end_events_e2_m2_3());
	print ("ending e2_m2_3");
		
	thread (f_start_events_e2_m2_4());
	print ("starting e2_m2_4");
	
	thread (f_end_events_e2_m2_4());
	print ("ending e2_m2_4");
		
	thread (f_start_events_e2_m2_5());
	print ("starting e2_m2_5");
	
	thread (f_end_events_e2_m2_5());
	print ("ending e2_m2_5");
		
	thread (f_start_events_e2_m2_6());
	print ("starting e2_m2_6");
	
	thread (f_end_events_e2_m2_6());
	print ("ending e2_m2_6");
		
	thread (f_start_events_e2_m2_7());
	print ("starting e2_m2_7");
	
	thread (f_end_events_e2_m2_7());
	print ("ending e2_m2_7");
		
	thread (f_start_events_e2_m2_8());
	print ("starting e2_m2_8");
end

//===========STARTING E2 M2==============================



script static void f_start_events_e2_m2_1
	sleep_until (LevelEventStatus("start_e2_m2_1"), 1);
	print ("STARTING start_e2_m2_go_1");
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
//	thread (e2_m2_set_up_base());

	//sleep (30);
	//sleep (30 * 7);
	//start_e1_m3_switch_1_vo();
	//vo_e2m2_clearhill();
	sleep_until (object_get_health(player0) > 0, 1);
	//start_e1_m3_switch_1_vo();
	//sleep_s (2);
	vo_e2m2_clearhill();
//	cinematic_set_title (title_shut_down_comm);
	
	f_new_objective (title_e2_m2_0);
//	sleep_until (device_get_power (objective_switch_2) == 1);
//	device_set_power (objective_switch_2, 0);
	ai_place (sq_turret_2);
	object_create (e1_m5_doors);
end

script static void e2_m2_set_up_base
	sleep_until (object_valid (unsc_base_obj_1), 1);
	print ("objects are valid -- damage the base objects");
	sleep(30);
	damage_object(unsc_base_obj_1, default, 1000);
	damage_object(unsc_base_obj_2, default, 20);
	damage_object(unsc_base_obj_3, default, 200);
//	object_create (explodable_container);
end

//script static void f_lava_damage
//
//end

//script static void f_ranger_drop
//	sleep_until (volume_test_players (vol_ranger_drop));
//	print ("ranger drop");
//	f_create_new_spawn_folder (96);
//	ai_place (sq_rangers_bridge);
//	
//
//end

script static void f_end_events_e2_m2_1
	sleep_until (LevelEventStatus("end_e2_m2_1"), 1);
	print ("ENDING start_e2_m2_1");
//	sleep_until (ai_living_count (e2_m2_guards_5) == 0, 1);
	ai_place (e2_m2_sniper);
	
	thread (f_e2_m2_ordnance_1());
	
	b_wait_for_narrative_hud = true;
	vo_e2m2_hillcleared();

	//sleep until the previous VO is complete (put in dialog system)
	sleep_s (2);
	vo_e2m2_hitcomms();
	b_wait_for_narrative_hud = false;
	
//	cinematic_set_title (title_shut_down_comm);
	f_new_objective (title_e2_m2_1);

//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_2_vo();
//	cinematic_set_title (title_shut_down_comm);
	
end



script static void f_start_events_e2_m2_2
	sleep_until (LevelEventStatus("start_e2_m2_2"), 1);
	print ("STARTING start_e2_m2_switch_2");
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
	if ai_living_count (e2_m2_guards_5) >= 0 then
		ai_set_objective (e2_m2_guards_5, obj_survival);
		print ("guards 5 still alive -- setting to survival");
	else
		print ("guards 5 are all dead doing nothing");
	end
	ai_place (e2_m2_tunnel_turret_1);
	//sleep (30);
	//sleep (30 * 7);

//	cinematic_set_title (title_shut_down_comm);
	f_new_objective (title_e2_m2_1);
end



//script static void f_move_crates_1 (object_name crate)
//	object_move_by_offset (crate, 3, 1, 0, 0);
//end
//
//script static void f_move_crates_2 (object_name crate)
//	object_move_by_offset (crate, 3, 0, 0, 1);
//end

script static void f_end_events_e2_m2_2
	sleep_until (LevelEventStatus("end_e2_m2_2"), 1);
	print ("ENDING start_e2_m2_switch_2");
	sound_looping_stop (music_start);
	
	thread(start_camera_shake_loop ("heavy", "short"));
	
	//effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0))));
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
	
	//sleep (30);
	//sleep (30 * 7);
	vo_e2m2_commsdown();
	sleep (30 * 2);
	stop_camera_shake_loop();
	//cinematic_set_title (comm_tower_down);
//	f_new_objective (title_e2_m2_2);

end




script static void f_start_events_e2_m2_3
	sleep_until (LevelEventStatus("start_e2_m2_3"), 1);
	print ("STARTING start_e2_m2_clear_base_1");

	//sleep (30);
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
	//sleep (30);
	b_wait_for_narrative_hud = true;
	//sleep (30 * 7);
	//sleep until the player sees some gear
	//cinematic_set_title (get_to_base);

	f_new_objective (title_e2_m2_3);

	vo_e2m2_seeunscgear();
	b_wait_for_narrative_hud = false;
	
	vo_e2m2_baddies();


//	device_set_power (objective_switch_2, 1);
end

script static void f_end_events_e2_m2_3
	sleep_until (LevelEventStatus("end_e2_m2_3"), 1);
	//sleep (30);
	sound_looping_stop (music_start);
	
//	thread(start_camera_shake_loop ("heavy", "short"));
//
//	//sleep (30 * 2);
//	
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0))));
//	object_destroy (firefight_mode_get_objective_name_at(firefight_mode_get_objective(firefight_mode_goal_get() - 1 , 0)));
	//sleep (30);
	//sleep (30 * 7);
//	cinematic_set_title (keep_searching_1);
	
//	f_new_objective (title_e2_m2_4);
	
	b_wait_for_narrative_hud = true;
	vo_e2m2_nothere();
	sleep_s (1);
	vo_e2m2_ifftag();
	//end_e1_m3_switch_3_vo();
	sleep_s (1);	
	vo_e2m2_overthere();
	b_wait_for_narrative_hud = false;

//	vo_e2m2_shieldsblock();
//	sleep (30 * 2);
//	stop_camera_shake_loop();
end

script static void f_start_events_e2_m2_4
	sleep_until (LevelEventStatus("start_e2_m2_4"), 1);
	print ("STARTING start_e2_m2_4");
	//print ("blow the shields");
	
//	sleep_until (volume_test_players (tv_e2_m2_coils), 1);
	thread (vo_e2m2_shieldsblock());
	print ("players hit the coil volume");

//	cinematic_set_title (blow_up_coils);
	
	f_new_objective (title_e2_m2_5);
	
//	sleep_until (object_get_health (coil_1) <= 0 or object_get_health (coil_2) <= 0 or object_get_health (coil_3) <= 0 or object_get_health (coil_4) <= 0 or object_get_health (e2_m2_power_core) <= 0, 1);
//	damage_object(coil_1, default, 10000);
//	damage_object(coil_2, default, 10000);
//	damage_object(coil_3, default, 10000);
//	damage_object(coil_4, default, 10000);

	sleep_until (object_get_health (e2_m2_power_core) <= 0, 1);
	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, explodable_container);
	object_destroy (explodable_container);
	print ("blow the shields, destroy the rest of the coils");
		//power up the controls
//	device_set_power (shield_switch_1, 1);
//	cinematic_set_title (drop_shields_2);
//	f_blip_object_cui (inv_hack_panel, "navpoint_activate");
//	f_hack_shields();
end

//script static void f_hack_shields
//	print ("hack shields started");
//	sleep_until (device_get_position (shield_switch_1) == 1);
//	device_set_power (inv_hack_panel, 1);
//	cinematic_set_title (give_it_a_whack);
//	//add VO here
//	sleep_until (volume_test_players (vol_hack) and player_action_test_melee(),1);
//	print ("shields hacked");
//	device_set_power (inv_hack_panel, 0);
//	b_end_player_goal = true;
//	f_unblip_object_cui (inv_hack_panel);
//end

script static void f_end_events_e2_m2_4
	sleep_until (LevelEventStatus("end_e2_m2_4"), 1);
	print ("ENDING start_e2_m2_4");

	//notifyLevel ("blow_shields");
	//blow_cave_shields();
	
	
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
	//sound_looping_start (music_up_beat, NONE, 1.0);
	thread(start_camera_shake_loop ("heavy", "short"));
	b_wait_for_narrative_hud = true;
	//cinematic_set_title (shields_overloading);
	//put this in the tag
	//ai_place (sq_tunnel_fodder_2);
	//spawning a drop pod -- replace this once the new firefight script gets checked in
	//thread (f_load_drop_pod (dm_drop_05, sq_tunnel_fodder_2, drop_pod_lg_05));
	
	
	//sleep until the last enemy is spawned
	//sleep_until (ai_living_count (sq_tunnel_guards_2) > 0);
	//sleep 3 seconds just for fun
	sleep_s (3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_2);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_4);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_5);
	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, cave_shield_6);
	
//	object_destroy_folder (dm_cave_shields);

	object_destroy_folder (cr_cave_shield);

	//cinematic_set_title (title_destroy_obj_2);
	//sleep (30 * 5);
	stop_camera_shake_loop();
	//cinematic_set_title (title_shields_down);
	sleep_s (2);
	b_wait_for_narrative_hud = false;
	sleep_s (5);
	//cinematic_set_title (keep_searching_2);
	
	f_new_objective (title_e2_m2_6);
	
	//sleep (30);
	//sleep (30 * 7);
	vo_e2m2_closer();

	sleep_s (8);
	
end



script static void f_start_events_e2_m2_5
	sleep_until (LevelEventStatus("start_e2_m2_5"), 1);
	print ("STARTING start_e2_m2_clear_base_2");
	//sleep (30);
	
	//sleep (30);
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_mid_beat, NONE, 1.0);
	//sleep (30);
	sleep (30 * 7);
	start_e1_m3_lz_1_vo();
//	cinematic_set_title (title_lz_go_to);
end

script static void f_end_events_e2_m2_5
	sleep_until (LevelEventStatus("end_e2_m2_5"), 1);
	print ("ENDING start_e2_m2_5");
	//sleep (30);
	sound_looping_stop (music_start);
	//sleep (30);
//	sound_looping_stop (music_start);
	//sleep (30);
	//sleep (30 * 7);
//	vo_e2m2_keepbarrier();
//	cinematic_set_title (scientist_rescued);
end

script static void f_start_events_e2_m2_6
	sleep_until (LevelEventStatus("start_e2_m2_6"), 1);
	print ("STARTING start_e2_m2_6");
	//sleep (30);
	//sound_looping_start (music_start, NONE, 1.0);
	//sound_looping_start (music_mid_beat, NONE, 1.0);
	//sleep (30);
	//sleep (30 * 7);
	//cinematic_set_title (at_scientists);
	
	f_new_objective (title_e2_m2_7);
	
	sleep (30 * 7);
	vo_e2m2_lava();

end



script static void f_end_events_e2_m2_6
	sleep_until (LevelEventStatus("end_e2_m2_6"), 1);
	print ("ENDING start_e2_m2_6");
	//sleep (30);
	sound_looping_stop (music_start);
	//sleep (30);
//	sound_looping_stop (music_start);
	//sleep (30);
	//sleep (30 * 7);
	vo_e2m2_keepbarrier();
//	cinematic_set_title (scientist_rescued);
end

//script static void tower_move_2
//	print ("tower move 2");
////	object_destroy (e1_m5_tower_move_1);
//	object_create (e1_m5_tower_move_2);
//	object_create (e1_m5_floor_move_1);
//	object_create (e1_m5_floor_move_2);
////	sleep(5);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_floor_move_1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_floor_move_2);
//	object_move_by_offset (e1_m5_floor_move_1, 3, 1, 0, 0);
//	object_move_by_offset (e1_m5_floor_move_2, 3, -1, 0, 0);
//	//thread (tower_rotate_2());
//	object_move_by_offset (e1_m5_tower_move_2, 5, 0, 0, 1);
//	tower_rotate_2();
//	//sleep_s(3);
//	//object_move_by_offset (e1_m5_tower_move_1, 5, 0.1, 0.1, -3);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e1_m5_tower_move_2);
//	print ("effect on tower move 2");
//end
//
//script static void tower_rotate_2
//	print ("start tower rotate 2");
//	object_rotate_by_offset (e1_m5_tower_move_2, 3, 0, 0, 180, 0, 0);
//end

script static void f_start_events_e2_m2_7
	sleep_until (LevelEventStatus("start_e2_m2_7"), 1);
	print ("STARTING start_e2_m2_swarm");
	sound_looping_start (music_start, NONE, 1.0);
	sound_looping_start (music_up_beat, NONE, 1.0);
	//f_blip_object_cui (lz_5, "navpoint_goto");
	//sleep (30);

	sleep (30 * 7);
	start_e1_m3_lz_3_vo();
	cinematic_set_title (title_swarm_1);
end

script static void f_end_events_e2_m2_7
	sleep_until (LevelEventStatus("end_e2_m2_7"), 1);
	print ("ENDING start_e2_m2_7");
	//f_unblip_object_cui (lz_5);

	sound_looping_stop (music_start);
	//sleep (30);
	//sleep (30 * 7);

	
	//watch the pelican fly down
	ai_place (sq_ff_outro_pelican);
	//f_pelican_outro();
end

script static void f_start_events_e2_m2_8
	sleep_until (LevelEventStatus("start_e2_m2_8"), 1);
	print ("STARTING start_e2_m2_8");
	vo_e2m2_allclear();
	
	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, e2_m2_science_barrier);
	object_destroy (e2_m2_science_barrier);
	
	//cinematic_set_title (scientist_rescued);
	
//	cinematic_set_title (title_e2_m2_8);

	b_end_player_goal = true;

end
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

//===========ENDING E2 M2==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//===========misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_e2_m2_ordnance_1
	print ("start ordnance 1");
	sleep_until (s_all_objectives_count > 0);
	print ("ordnance 1");
	ordnance_drop(fl_e2_m2_ord, "storm_rocket_launcher");
	cinematic_set_title (weapon_drop);

end



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

//script static void f_phantom_surprise_01
//	print ("phantom surprise");
//	ai_place (sq_phantom_surprise);
//	cs_run_command_script (sq_phantom_surprise, cs_ff_phantom_surprise_01);
////	ai_place_in_vehicle (sq_phantom_fodder, sq_ff_phantom_01);
//	ai_place (sq_phantom_fodder);
//	f_load_dropship (ai_vehicle_get_from_spawn_point (sq_phantom_surprise.phantom), sq_phantom_fodder);
//end


// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

script static void f_start_player_intro_e2_m2
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		//firefight_mode_set_player_spawn_suppressed(false);
		sleep_s (1);
		//intro_vignette_e2_m2();
		b_wait_for_narrative = false;
		firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_s (8);
		intro_vignette_e2_m2();
	end
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e2_m2
	print ("_____________starting vignette__________________");
	//sleep_s (8);
	thread (vo_e2m2_intro());
	ex3();
	
	b_wait_for_narrative = false;
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
end

script static void f_narrative_done_e2_m2
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================


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


