// =============================================================================================================================
//========= SCURVE FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish
//NO GENERAL SCRIPTS should be copy and pasted into the map scripts

// =============================================================================================================================
// ===========LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
//========= GLOBALS===================================================================

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
	switch_zone_set (e2_m2_intro);
	mission_is_e2_m2 = true;

	ai_ff_all = e2_m2_gr_ff_all;
	
	thread(f_start_player_intro_e2_m2());

//start the first starting event
	thread (f_start_events_e2_m2_1());
	print ("starting e2_m2_1");

//thread the rest of the event threads
	thread (f_start_all_events_e2_m2());

	thread(f_music_e2m2_start());

// ================================================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;


//======= OBJECTS ==================================================================
//set crate names


	f_add_crate_folder(cr_cave_shield); //Cov Cover and fluff in the meadow
	f_add_crate_folder(cr_e1_m5_unsc_gun_racks); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(eq_e1_m5_unsc_ammo);
	f_add_crate_folder(e2_m2_cr_unsc_base); //the base in the left forerunner area		
//	f_add_crate_folder(e2_m2_cr_scientist); //the base in the 'starting' area
	f_add_crate_folder(e2_m2_wp_unsc_base); //energy barrier shields	
//	f_add_crate_folder(bi_e2_m2_unsc_base); //dead marines
	f_add_crate_folder(cr_e2_m2_cov_cover_1); //more covenant cover through out
	f_add_crate_folder(cr_e2_m2_cov_cover_2); //more covenant cover through out	
//	f_add_crate_folder(dm_e2_m2_barriers); //more covenant cover through out	
	f_add_crate_folder(e2_m2_objective_crates); //more covenant cover through out		
	f_add_crate_folder(dm_e2_m2); //more covenant cover through out	
	f_add_crate_folder(sc_e2_m2_objectives); //more covenant cover through out	
	f_add_crate_folder(e2_m2_eq_unsc);	

	//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
//	f_add_crate_folder(eq_ammo_start); //ammo crates in main spawn area
//	f_add_crate_folder(eq_defend_1_crates); //ammo crates in front middle area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
//	f_add_crate_folder(eq_ammo_back); //ammo crates in the very back right	
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
//	f_add_crate_folder(eq_ammo_middle); //ammo crates in back middle area	
	
	
	
//set spawn folder names
	//firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e2_m2_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns in the front building
	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the back building
//	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the left building
	firefight_mode_set_crate_folder_at(sc_e2_m2_spawn_points_3, 93); //spawns by the left building	
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(sc_e2_m2_spawn_points_6, 96);
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //spawns in the back on the hill (facing the back)
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //spawns in the very back facing down the hill
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //spawns in the very back facing down the hill	
	firefight_mode_set_crate_folder_at(spawn_points_10, 80); //spawns in the very back facing down the hill		
	
//set objective names
	firefight_mode_set_objective_name_at(comm_array_1, 1); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_2, 2); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_3, 3); //uplink module on back middle
	firefight_mode_set_objective_name_at(comm_array_4, 4); //uplink module on back middle
	firefight_mode_set_objective_name_at(dc_e2_m2_iff, 5); //uplink module on back middle
	firefight_mode_set_objective_name_at(dc_e2_m2_shields, 6); //uplink module on back middle
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
	firefight_mode_set_objective_name_at(lz_9, 59); //objective right by the tunnel entrance
	firefight_mode_set_objective_name_at(lz_10, 60); //objective right by the tunnel entrance
		
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
			


	
	firefight_mode_set_squad_at(sq_e2_m2_phantom_1, 21); //phantom 1
	firefight_mode_set_squad_at(sq_ff_phantom_02, 22); //phantom 1




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
		
		//not used currently
//	thread (f_start_events_e2_m2_5());
//	print ("starting e2_m2_5");
//	
//	thread (f_end_events_e2_m2_5());
//	print ("ending e2_m2_5");
		
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
	
//	thread (f_start_events_e2_m2_9());
//	print ("starting e2_m2_9");
	
	thread (e2_m2_set_up_base());
	
	thread (f_e2_m2_shield_effects());
end

//===========STARTING E2 M2==============================



script static void f_start_events_e2_m2_1
	sleep_until (LevelEventStatus("start_e2_m2_1"), 1);
	thread(f_music_e2m2_start_events_1());
	print ("STARTING start_e2_m2_go_1");

	sleep_until (b_players_are_alive(), 1);

	thread(f_music_e2m2_clearhill_vo());
	
	sleep_s (2);
		
	vo_e2m2_clearhill();
//	cinematic_set_title (title_shut_down_comm);
	
	f_new_objective (title_e2_m2_0);

	object_create (e1_m5_doors);
end

script static void e2_m2_set_up_base
//	sleep_until (object_valid (unsc_base_obj_2) and object_valid (unsc_base_obj_3), 1);
//	thread(f_music_e2m2_set_up_base());
//	print ("objects are valid -- damage the base objects");
//	sleep(30);
//	//damage_object(unsc_base_obj_1, default, 1000);
//	damage_object(unsc_base_obj_2, default, 20);
//	damage_object(unsc_base_obj_3, default, 200);
	
	//sleep until the powercore is valid
	sleep_until (object_valid (e2_m2_power_core), 1);
	object_cannot_take_damage (e2_m2_power_core);
	print ("powercore cannot take damage");
	
	//create the marker used later
	object_create (lz_6);
	
	//turn off the powered cover in the forerunner play space
	//device_set_power (dm_bridge_cover_3, 0);
	//device_set_power (dm_bridge_cover_4, 0);
	device_set_power (dm_bridge_cover_5, 0);
	device_set_power (dm_bridge_cover_6, 0);


//	object_create (explodable_container);
end


script static void f_end_events_e2_m2_1
	sleep_until (LevelEventStatus("end_e2_m2_1"), 1);
	thread(f_music_e2m2_end_events_1());
	print ("ENDING start_e2_m2_1");

	//destroy the marker so that it has no collision
	object_destroy (lz_7);

	if ai_living_count (e2_m2_guards_5) >= 0 then
		ai_set_objective (e2_m2_guards_5, obj_e2_m2_bridge_guards);
		print ("guards 5 still alive -- setting to survival");
	else
		print ("guards 5 are all dead doing nothing");
	end

end


script static void f_start_events_e2_m2_2
	sleep_until (LevelEventStatus("start_e2_m2_2"), 1);
	thread(f_music_e2m2_start_2());
	print ("STARTING start_e2_m2_switch_2");

	b_wait_for_narrative_hud = true;
	
//place the sniper and turrets
	ai_place (e2_m2_tunnel_turret_1);

	sleep_until (ai_living_count (e2_m2_bridge_guards) > 0, 1);

	if ai_living_count (ai_ff_all) < 18 then
		ai_place (sq_e2_m2_turret);
		print ("turrets spawned");
		sleep_until (ai_living_count (sq_e2_m2_turret) > 0, 1);
	end
	
	if ai_living_count (ai_ff_all) < 19 then
		ai_place (sq_e2_m2_turret_2);
		print ("turrets2 spawned");
		sleep_until (ai_living_count (sq_e2_m2_turret_2) > 0, 1);
	end
	
	if ai_living_count (ai_ff_all) < 20 then
		ai_place (e2_m2_sniper);
		print ("ai less than 20 spawning sniper");
	end
	
	//thread (f_e2_m2_ordnance_1());
	
	
	thread(f_music_e2m2_hillcleared_vo());
	vo_e2m2_hillcleared();

	sleep_s (2);
	thread(f_music_e2m2_hitcomms_vo());
	vo_e2m2_hitcomms();
	b_wait_for_narrative_hud = false;
	
//	cinematic_set_title (title_shut_down_comm);
	f_new_objective (title_e2_m2_1);

end


script static void f_end_events_e2_m2_2
	sleep_until (LevelEventStatus("end_e2_m2_2"), 1);
	thread(f_music_e2m2_end_events_2());
	print ("ENDING start_e2_m2_switch_2");
	
	thread(start_camera_shake_loop ("heavy", "short"));
	

//	vo_e2m2_commsdown();
	sleep (30 * 2);
	stop_camera_shake_loop();

//	f_new_objective (title_e2_m2_2);

end




script static void f_start_events_e2_m2_3
	sleep_until (LevelEventStatus("start_e2_m2_3"), 1);
	thread(f_music_e2m2_start_events_3());
	print ("STARTING start_e2_m2_clear_base_1");

	//remaining AI go to the next objective area
	ai_set_objective (e2_m2_guards_1, obj_e2_m2_guards_1);
	ai_set_objective (e2_m2_guards_5, obj_e2_m2_guards_1);
	//ai_set_objective (e2_m2_guards_9, obj_e2_m2_guards_1);
	ai_set_objective (e2_m2_bridge_guards, obj_e2_m2_guards_1);
	ai_set_objective (sq_e2_m2_turret, obj_e2_m2_guards_1);
	

	b_wait_for_narrative_hud = true;

	//cinematic_set_title (get_to_base);
	thread(f_music_e2m2_commsdown_vo());
	
	//tell player to get to the scientists, IFF tag
	sleep_s (2);
	vo_glo_nicework_04();
	
	sleep_s (2);
	
	vo_e2m2_commsdown();
	f_new_objective (title_e2_m2_3);

	//track distance to IFF and call VO based on distance
	f_e2_m2_track_iff();
	//f_e2_m2_track_object (sc_e2_m2_iff, 20);

	//when they are right in the area call this VO
	thread(f_music_e2m2_baddies_vo());
	//vo_e2m2_baddies();
	//nobody is here!
	vo_e2m2_nobodyhere();
	
//	sleep_s (1);
	
//	//if there are enemies then secure the area!
//	if ai_living_count (e2_m2_gr_ff_all) > 0 then
//		//vo_e2m2_secure();
//		//replacing with a generic line because Josh didn't like e2m2_secure
//		vo_glo_cleararea_05();
//	end
//	
//	//sleep until less baddies
//	sleep_until (ai_living_count (e2_m2_gr_ff_all) < 8, 1);
//	
//	//if there are still enemies around, then blip them
//	if ai_living_count (e2_m2_gr_ff_all) > 1 then
//		sleep_s (1);
//		vo_glo_cleararea_01();
//		sleep_s (1);
//		f_blip_ai_cui (e2_m2_gr_ff_all, "navpoint_enemy");
//	end
//	
//	sleep_until (ai_living_count (e2_m2_gr_ff_all) < 1, 1);
//	sleep_until (ai_living_count (e2_m2_guards_1) < 1 and
//							 ai_living_count (e2_m2_guards_3) < 1 and
//							 ai_living_count (e2_m2_guards_5) < 1 and
//							 ai_living_count (e2_m2_guards_9) < 1 and
//							 ai_living_count (e2_m2_waves_1) < 1 and
//							 ai_living_count (e2_m2_waves_7) < 1 and
//							 ai_living_count (gr_e2_m2_bridge_guards) < 1
//	, 1);
	
	sleep_s (2);
	//nice work crimson
//	vo_glo_nicework_09();
//	
//	sleep_s (1);
	
	thread(f_music_e2m2_nothere_vo());
	//collect the IFF
	vo_e2m2_collectiff();
	//vo_e2m2_nothere();
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e2_m2_iff, 1);


end


script static void f_e2_m2_track_iff
	//track distance to IFF and call VO based on distance
	print ("track iff tag");

	//paint the area by the IFF tag
	navpoint_track_object_named (sc_e2_m2_iff, "navpoint_generic");
	
	//when the players are close to the tag call more VO
	local short objectDistance = 20;
	
	sleep_until (
		(objects_distance_to_object ((player0), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player0), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player1), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player1), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player2), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player2), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player3), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player3), sc_e2_m2_iff) > 0 ), 1);	
	
	navpoint_track_object (sc_e2_m2_iff, false);

	thread(f_music_e2m2_seeunscgear_vo());
	vo_e2m2_seeunscgear();
	
	
	navpoint_track_object_named (sc_e2_m2_iff,"navpoint_goto");
	
	objectDistance = 5;
	
	sleep_until (
		(objects_distance_to_object ((player0), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player0), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player1), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player1), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player2), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player2), sc_e2_m2_iff) > 0 ) or
		(objects_distance_to_object ((player3), sc_e2_m2_iff) <= objectDistance and objects_distance_to_object ((player3), sc_e2_m2_iff) > 0 ), 1);	
		
	navpoint_track_object (sc_e2_m2_iff, false);
	
end

//track players distance to object
//script static void f_e2_m2_track_object (object obj, short objectDistance)
//	navpoint_track_object_named (obj, "navpoint_generic");
//	
//	//when the players are close to the tag call more VO
//	//local short objectDistance = 20;
//	
//	sleep_until (
//		(objects_distance_to_object ((player0), obj) <= objectDistance and objects_distance_to_object ((player0), obj) > 0 ) or
//		(objects_distance_to_object ((player1), obj) <= objectDistance and objects_distance_to_object ((player1), obj) > 0 ) or
//		(objects_distance_to_object ((player2), obj) <= objectDistance and objects_distance_to_object ((player2), obj) > 0 ) or
//		(objects_distance_to_object ((player3), obj) <= objectDistance and objects_distance_to_object ((player3), obj) > 0 ), 1);	
//	
//	navpoint_track_object (obj, false);
//
//end

script static void f_end_events_e2_m2_3
	sleep_until (LevelEventStatus("end_e2_m2_3"), 1);
	print ("ending e2_m2_m3");
	thread(f_music_e2m2_end_3());
	object_hide (sc_e2_m2_iff, true);
	
	//set remaining AI to area by the shield
	ai_set_objective (e2_m2_guards_1, obj_e2_m2_guards_9);
	ai_set_objective (e2_m2_guards_5, obj_e2_m2_guards_9);
	ai_set_objective (e2_m2_guards_9, obj_e2_m2_guards_9);
	ai_set_objective (e2_m2_bridge_guards, obj_e2_m2_guards_9);
	ai_set_objective (sq_e2_m2_turret, obj_e2_m2_guards_9);
	ai_set_objective (sq_e2_m2_turret_2, obj_e2_m2_guards_9);
	
end

script static void f_start_events_e2_m2_4
	sleep_until (LevelEventStatus("start_e2_m2_4"), 1);
	thread(f_music_e2m2_start_events_4());
	print ("STARTING start_e2_m2_4");
	//print ("blow the shields");
	
	b_wait_for_narrative_hud = true;
	
	sleep_s (1);
	thread(f_music_e2m2_ifftag_vo());
	vo_e2m2_ifftag();
	//end_e1_m3_switch_3_vo();
	
	//sleep_until (LevelEventStatus("e2_m2_elites_incoming"), 1);
	sleep_until (ai_living_count (e2_m2_waves_2) > 1, 1);
	vo_glo_heavyforces_01();
	
	//sleep_until (ai_living_count (e2_m2_waves_2) < 1, 1);
	
	//maybe add a 'nice work' in here
	sleep_s (2);	
	
	thread(f_music_e2m2_overthere_vo());
	vo_e2m2_overthere();
	


	thread (f_e2_m2_breadcrumbs(5, lz_6));	
	
	//when the players get close to the powercore, turn on VO, set AI to survival
	sleep_until (volume_test_players (tv_e2_m2_coils), 1);
	print ("players hit the coil volume");
	//ai_set_objective (e2_m2_gr_ff_all, obj_survival);
	
	//if there are enemies then secure the area!
	if ai_living_count (e2_m2_gr_ff_all) > 0 then
		//vo_e2m2_secure();
		//replacing with a generic line because Josh didn't like e2m2_secure
		vo_glo_cleararea_03();
		f_blip_ai_cui (e2_m2_gr_ff_all, "navpoint_enemy");
		sleep_until (ai_living_count (e2_m2_gr_ff_all) < 1, 1);
		vo_glo_nicework_01();
	end	
	
	sleep_s (1);
	
	thread(f_music_e2m2_shieldsblock_vo());
	vo_e2m2_shieldsblock();
	b_wait_for_narrative_hud = false;
	

//	cinematic_set_title (blow_up_coils);
	
	f_new_objective (title_e2_m2_5);
	
	device_set_power (dc_e2_m2_shields, 1);
	
	//object_can_take_damage (e2_m2_power_core);
	//print ("powercore can now take damage");
	
//	sleep_until (object_get_health (coil_1) <= 0 or object_get_health (coil_2) <= 0 or object_get_health (coil_3) <= 0 or object_get_health (coil_4) <= 0 or object_get_health (e2_m2_power_core) <= 0, 1);
//	damage_object(coil_1, default, 10000);
//	damage_object(coil_2, default, 10000);
//	damage_object(coil_3, default, 10000);
//	damage_object(coil_4, default, 10000);

//	sleep_until (object_get_health (e2_m2_power_core) <= 0, 1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, explodable_container);
	
	sleep_until (device_get_position (dm_e2_m2_shield) == 1, 1);
	object_hide (dm_e2_m2_shield, true);
	
	
end


script static void f_e2_m2_breadcrumbs (real objectdistance, object flag)
	navpoint_track_object_named (flag, "navpoint_goto");
	
	print ("The radius of the marker is...");
	inspect (objectDistance);
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag) <= objectDistance and objects_distance_to_object ((player0), flag) > 0 ) or
		(objects_distance_to_object ((player1), flag) <= objectDistance and objects_distance_to_object ((player1), flag) > 0 ) or
		(objects_distance_to_object ((player2), flag) <= objectDistance and objects_distance_to_object ((player2), flag) > 0 ) or
		(objects_distance_to_object ((player3), flag) <= objectDistance and objects_distance_to_object ((player3), flag) > 0 ), 1);	
	print ("------player(s) made it to the location------");

	navpoint_track_object (flag, false);
	object_destroy (flag);

end


script static void f_end_events_e2_m2_4
	sleep_until (LevelEventStatus("end_e2_m2_4"), 1);
	thread(f_music_e2m2_end_events_4());
	print ("ENDING start_e2_m2_4");

	//notifyLevel ("blow_shields");
	//blow_cave_shields();

	thread(start_camera_shake_loop ("heavy", "short"));
	b_wait_for_narrative_hud = true;
	//cinematic_set_title (shields_overloading);
	
	//sleep until the last enemy is spawned
	//sleep_until (ai_living_count (sq_tunnel_guards_2) > 0);
	
	//sleep 3 seconds just for fun
	sleep_s (3);

	print ("blow the shields");
//	object_damage_damage_section (cr_cave_shield1, "shield", 100);
	//turn off the shield effect, then destroy the shields
	object_set_function_variable (cr_cave_shield1, "shield_on", 0, 0.5);
	object_destroy (cr_cave_shield1);
	
	//object_destroy (explodable_container);
	
	thread (f_e2_m2_drop_pod_timing());
		
	stop_camera_shake_loop();
	//cinematic_set_title (title_shields_down);
	sleep_s (2);
	
	//destroyed through another thread
	sleep_until (object_valid (lz_6) == false, 1);
	//cinematic_set_title (keep_searching_2);
	
	thread(f_music_e2m2_closer_vo());
	vo_e2m2_closer();
	
	b_wait_for_narrative_hud = false;
	
	thread(f_music_e2m2_title_6());
	f_new_objective (title_e2_m2_6);
	
	//create the objects by the scientists
	object_create_folder (e2_m2_cr_scientist);
	
	//get any remaining AI to get through the cave
	ai_set_objective (e2_m2_guards_1, obj_e2_m2_guards_2);
	ai_set_objective (e2_m2_guards_5, obj_e2_m2_guards_2);
	ai_set_objective (e2_m2_guards_9, obj_e2_m2_guards_2);
	ai_set_objective (e2_m2_bridge_guards, obj_e2_m2_guards_2);
	ai_set_objective (e2_m2_tunnel_turret_1, obj_e2_m2_guards_2);
	ai_set_objective (sq_e2_m2_turret, obj_e2_m2_guards_2);
	ai_set_objective (sq_e2_m2_turret_2, obj_e2_m2_guards_2);
	
end

script static void f_e2_m2_drop_pod_timing
//spawn some medium drop pods at the right time
	print ("drop pod timing");
	sleep_until (ai_living_count (e2_m2_gr_ff_all) <= 7, 1);
	f_e2_m2_med_drop_pod_1();
	
	//sleep_until (ai_living_count (e2_m2_gr_ff_all) > 5, 1);
	sleep_s (8);
	//sleep_until (ai_living_count (e2_m2_gr_ff_all) <= 12, 1);
	f_e2_m2_med_drop_pod_2();
end


//not using these currently
//script static void f_start_events_e2_m2_5
//	sleep_until (LevelEventStatus("start_e2_m2_5"), 1);
//	thread(f_music_e2m2_start_events_5());
//	print ("STARTING start_e2_m2_clear_base_2");
//	
//	thread(f_music_e2m2_lz_vo());
////	cinematic_set_title (title_lz_go_to);
//end
//
//script static void f_end_events_e2_m2_5
//	sleep_until (LevelEventStatus("end_e2_m2_5"), 1);
//	thread(f_music_e2m2_end_events_5());
//	print ("ENDING start_e2_m2_5");
//
//end

script static void f_start_events_e2_m2_6
	sleep_until (LevelEventStatus("start_e2_m2_6"), 1);
	thread(f_music_e2m2_start_events_6());
	print ("STARTING start_e2_m2_6");
//add 'watch out drop pods' VO here
	
	//sleep (30 * 7);
	thread(f_music_e2m2_lava_vo());
	
	//get any remaining AI to get through the cave
	ai_set_objective (e2_m2_guards_1, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_guards_2, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_guards_4, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_guards_5, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_guards_9, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_bridge_guards, obj_e2_m2_guards_4);
	ai_set_objective (e2_m2_tunnel_turret_1, obj_e2_m2_guards_4);
	ai_set_objective (sq_e2_m2_turret, obj_e2_m2_guards_4);
	ai_set_objective (sq_e2_m2_turret_2, obj_e2_m2_guards_4);
	ai_set_objective (gr_e2_m2_waves_all, obj_e2_m2_guards_4);
	
end



script static void f_end_events_e2_m2_6
	sleep_until (LevelEventStatus("end_e2_m2_6"), 1);
	thread(f_music_e2m2_end_events_6());
	print ("ENDING start_e2_m2_6");

	object_destroy (lz_0);
	
end



script static void f_start_events_e2_m2_7
	sleep_until (LevelEventStatus("start_e2_m2_7"), 1);
	thread(f_music_e2m2_start_events_7());
	print ("STARTING start_e2_m2_swarm");
	
	thread(f_music_e2m2_keepbarrier_vo());
	
	//removing scientists because we need the memory :(
	//ai_place (sq_e2_m2_allies_scientists);
	
	//make scientists invulnerable
	
	//object_immune_to_friendly_damage (ai_actors(sq_e2_m2_allies_scientists), true);
	
	vo_e2m2_keepbarrier();
	f_new_objective (title_e2_m2_7);
	
	//blip the enemies once 5 enemies are left
	//sleep_until (ai_living_count (e2_m2_waves_7) > 0, 1);
	sleep_until (b_phantom_done == true, 1);
	sleep_until (ai_living_count (ai_ff_all) < 6, 1);
	
	vo_glo_lasttargets_05();
	f_blip_ai_cui (e2_m2_gr_ff_all, "navpoint_enemy");
	
//	cinematic_set_title (scientist_rescued);
	

	//cinematic_set_title (title_swarm_1);
end

script static void f_end_events_e2_m2_7
	sleep_until (LevelEventStatus("end_e2_m2_7"), 1);
	thread(f_music_e2m2_end_events_7());
	print ("ENDING start_e2_m2_7");

	
	//watch the pelican fly down
	//ai_place (sq_ff_outro_pelican);
	//f_pelican_outro();
end

script static void f_start_events_e2_m2_8
	sleep_until (LevelEventStatus("start_e2_m2_8"), 1);
	thread(f_music_e2m2_end_events_8());
	print ("STARTING start_e2_m2_8");
	//b_wait_for_narrative_hud = true;
	sleep_s (3);
	
	vo_e2m2_allclear();
	
	sleep_s (2);
	
//	fade_out (0,0,0,30);
//	player_control_fade_out_all_input (30);
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	thread(f_music_e2m2_finish());
	b_end_player_goal = true;
	
	f_e2_m2_end_mission();
	
	//no longer taking down the barrier because the scientist does not fit in memory
//	object_damage_damage_section (e2_m2_barrier, "shield", 100);
//	object_set_function_variable (e2_m2_barrier, "shield_on", 0, 0.5);
//	object_destroy (e2_m2_barrier);
//	
//	//b_wait_for_narrative_hud = FALSE;
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	thread(f_music_e2m2_finish());
//	b_end_player_goal = true;
//	cinematic_set_title (scientist_rescued);
//	cinematic_set_title (title_e2_m2_8);
end

//script static void f_start_events_e2_m2_9
//	sleep_until (LevelEventStatus("start_e2_m2_9"), 1);
//	//thread(f_music_e2m2_end_events_8());
//	print ("STARTING start_e2_m2_9");
//	
//	object_destroy (lz_10);
//	
//	vo_e2m2_allclear2();
//	
//	b_end_player_goal = true;
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	thread(f_music_e2m2_finish());
//	
//end



//===========ENDING E2 M2==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//===========misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_e2_m2_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	sleep (60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end


script static void f_e2_m2_shield_effects
	print ("shield effects on");
	//turn on the shield effects
	sleep_until (object_valid (cr_cave_shield1), 1);
	object_set_function_variable (cr_cave_shield1, "shield_on", 1, 0.5);
	sleep_until (object_valid (e2_m2_barrier), 1);
	object_set_function_variable (e2_m2_barrier, "shield_on", 1, 0.5);
	

end

script command_script cs_e2_m2_scientists
	//have the scientists look at and then approach the player
	
	print ("scientists looking at players");
	
	cs_face_player (true);
	cs_lower_weapon (true);
	
	sleep_until (object_valid (lz_10) == false, 1);
	
	cs_approach_player (2, 10, 100);
	
	sleep_until (b_game_ended == true);

end

script static void f_e2_m2_ordnance_1
	print ("start ordnance 1");
	sleep_until (s_all_objectives_count > 0);
	print ("ordnance 1");
	vo_glo_ordnance_02();
	//ordnance_drop(fl_e2_m2_ord, "storm_rocket_launcher");
	if editor_mode() then
		cinematic_set_title (weapon_drop);
	end
	thread(f_music_e2m2_ordnance_1());
end




// ==============================================================================================================
//====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================


script static void f_e2_m2_med_drop_pod_1
	print ("med drop pod 1");
	object_create (v_e2_m2_med_pod_1);
	thread(v_e2_m2_med_pod_1->drop_to_point( sq_e2_m2_med_drop_pod_1, ps_e2_m2_drop_pod.p1, .85, DEFAULT ));
end

script static void f_e2_m2_med_drop_pod_2
	print ("med drop pod 2");
	object_create (v_e2_m2_med_pod_2);
	thread(v_e2_m2_med_pod_2->drop_to_point( sq_e2_m2_med_drop_pod_2, ps_e2_m2_drop_pod.p2, .85, DEFAULT ));
end
//
//script static void f_small_drop_pod_1
//	print ("drop pod 1");
//	object_create (small_pod_1);
//	thread(small_pod_1->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p1, .85, DEFUALT ));
//end

script command_script cs_e2_m2_drop_pod
	print ("cs drop pod");
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_e2_m2_survival);

end

// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

global boolean b_phantom_done = false;

script command_script cs_e2_m2_phantom_1()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	//sleep (1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e2_m2_phantom_1.p0);
//		(print "flew by point 0")
	cs_fly_to_and_face (ps_e2_m2_phantom_1.p1, ps_e2_m2_phantom_1.p4);
//		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_01.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	b_phantom_done = true;
			
		//======== DROP DUDES HERE ======================
		
	print ("phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_e2_m2_phantom_1.p2);
	cs_fly_to (ps_e2_m2_phantom_1.p3);
//	(cs_fly_by ps_e2_m2_phantom_1/erase 10)
// erase squad 
//	sleep (30 * 5);

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end


// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

script static void f_start_player_intro_e2_m2
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then

		sleep_s (1);
		//intro_vignette_e2_m2();

	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m2_vin_sfx_intro', NONE, 1);
		intro_vignette_e2_m2();
	end
		
	switch_zone_set (e2_m2);
		
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	
	//sleep_until (goal_finished == true);
	
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	
	sleep (15);
	fade_in (0,0,0,15);
end

script static void intro_vignette_e2_m2
	print ("_____________starting vignette__________________");
	//sleep_s (8);
	
	cinematic_start();
	
	ai_enter_limbo (e2_m2_gr_ff_all);
	
	thread (f_music_e2m2_vignette_start());
	b_wait_for_narrative = true;
	
	pup_play_show(e2_m2_intro);
	vo_e2m2_intro();
	thread (f_music_e2m2_vignette_finish());
	
	sleep_until (b_wait_for_narrative == false);

	ai_exit_limbo (e2_m2_gr_ff_all);

	cinematic_stop();

end

script static void f_narrative_done_e2_m2
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================


