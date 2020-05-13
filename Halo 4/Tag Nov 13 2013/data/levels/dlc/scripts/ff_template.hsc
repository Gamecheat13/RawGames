//// =============================================================================================================================
//========= <map_name> FIREFIGHT SCRIPTS ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//===== LEVEL SCRIPTS ==================================================================
// =============================================================================================================================

// =============================================================================================================================
// =================== GLOBALS ==================================================================
// =============================================================================================================================

//this template was taken from e3_m2 complex.  Where the script mentions e3_m2 put in the appropriate episode and mission


script startup e3_m2_<map_name>

	//Start the intro
	sleep_until (LevelEventStatus("e3_m2"), 1);
	print ("******************STARTING e3_m2*********************");
	
	//switch to the appropriate zone set
	switch_zone_set (e3_m2_intro);
//	mission_is_e3_m2 = true;
//	b_wait_for_narrative = true;

//suppress the player from spawning during loadout selection and intro vignette
	firefight_mode_set_player_spawn_suppressed(true);

//set the global "bad guy AI" variable that is used to track wave spawning and auto blips
	ai_ff_all = gr_e3_m2_ff_all;
	//b_wait_for_narrative = true;
	thread(f_start_player_intro_e3_m2());

//start the first starting event
	thread (f_start_events_e3_m2_1());
	print ("starting e3_m2_1");

//start all the rest of the event scripts
	thread (f_start_all_events_e3_m2());

//music cue
	thread (f_music_e3m2_start());


// ==================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_1;

	
//======== OBJECTS ==================================================================

//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	f_add_crate_folder(cr_e3_m2_unsc_cover_1); //UNSC crates and barriers around the main spawn area
//	f_add_crate_folder(cr_e3_m2_power_cores); //crates that blow up at the very back right
//	f_add_crate_folder(cr_e3_m2_unsc_cover_2);  //UNSC barriers in and around the front middle base
////	f_add_crate_folder(sc_e3_m2_unsc_1); //UNSC scenery in the main starting area
//	//f_add_crate_folder(v_e3_m2_unsc); //unsc vehicles
//	f_add_crate_folder(cr_e3_m2_unsc_props_1); //unsc vehicles
//	f_add_crate_folder(cr_e3_m2_unsc_roof_1); //unsc vehicles	
//	f_add_crate_folder(wp_e3_m2_unsc_heavy); //unsc vehicles		
//	f_add_crate_folder(cr_e3_m2_unsc_ammo_crates); //ammo crates	
//	f_add_crate_folder(dm_e3_m2_turret_base); //turret bases
//	
//	
////set ammo crate names
//	f_add_crate_folder(eq_e3_m2_ammo_1); //ammo crates


// puts spawn point folders into an index that is used to automatically turn on/off spawn points and used by designers to override current spawn folders
//set spawn folder names
	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_0, 90); //spawns in the main starting area
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_1, 91); //spawns in the front building
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_2, 92); //spawns in the back building
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_3, 93); //spawns by the left building
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_4, 94); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_5, 95); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_6, 96); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_7, 97); //spawns in the back on the hill (facing the back)
//	firefight_mode_set_crate_folder_at(e3_m2_spawn_points_8, 98); //spawns in the very back facing down the hill
//	firefight_mode_set_crate_folder_at(sc_e3_m2_spawn_points_9, 99); //spawns in the very back facing down the hill
	
//puts certain objects into an index that is used to track objectives set in the player goals in the variant tag
//set objective names
	
	firefight_mode_set_objective_name_at(e3_m2_switch_1, 1); //computer terminal in the close side building
//	firefight_mode_set_objective_name_at(e3_m2_switch_2, 2); //computer terminal in the left side building
//	firefight_mode_set_objective_name_at(e3_m2_switch_3, 3); //computer terminal in the far right side building
//	firefight_mode_set_objective_name_at(turret_switch_0, 10); //turret switch
//	firefight_mode_set_objective_name_at(turret_switch_1, 11); //turret switch	

//set LZ (location arrival) spots			
	firefight_mode_set_objective_name_at(e3_m2_lz_0, 50); //objective in the main spawn area
//	firefight_mode_set_objective_name_at(e3_m2_lz_1, 51); //objective in the middle front building
//	firefight_mode_set_objective_name_at(e3_m2_lz_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(e3_m2_lz_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(e3_m2_lz_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(e3_m2_lz_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(e3_m2_lz_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(e3_m2_lz_7, 57); //objective right by the tunnel entrance
	
//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
//set squad group names
	//guards
	firefight_mode_set_squad_at(gr_e3_m2_guards_1, 1);	//left building
//	firefight_mode_set_squad_at(gr_e3_m2_guards_2, 2);	//front by the main start area
//	firefight_mode_set_squad_at(gr_e3_m2_guards_3, 3);	//back middle building
//	firefight_mode_set_squad_at(gr_e3_m2_guards_4, 4); //in the main start area
//	firefight_mode_set_squad_at(gr_e3_m2_guards_5, 5); //right side in the back
//	firefight_mode_set_squad_at(gr_e3_m2_guards_6, 6); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_e3_m2_guards_7, 7); //middle building at the front
//	firefight_mode_set_squad_at(gr_e3_m2_guards_8, 8); //on the bridge
//	firefight_mode_set_squad_at(gr_e3_m2_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_e3_m2_allies_2, 10); //back middle building
//	firefight_mode_set_squad_at(sq_e3_m2_hunters_grunts, 11); //back middle building
//
//	//phantoms
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_01, 21); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_02, 22); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_03, 23); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_04, 24); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_1, 31); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_2, 32); //phantoms 
//	
//	//waves (enemies that come from drop pods or phantoms
//	firefight_mode_set_squad_at(gr_e3_m2_waves_1, 81);	//left building
//	firefight_mode_set_squad_at(gr_e3_m2_waves_2, 82);	//front by the main start area
//	firefight_mode_set_squad_at(gr_e3_m2_waves_3, 83);	//back middle building
//	firefight_mode_set_squad_at(gr_e3_m2_waves_4, 84); //in the main start area
//	firefight_mode_set_squad_at(gr_e3_m2_waves_5, 85); //right side in the back
//	firefight_mode_set_squad_at(gr_e3_m2_waves_6, 86); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_e3_m2_waves_7, 87); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_e3_m2_waves_8, 88); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_e3_m2_waves_9, 89); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_e3_m2_waves_10,90);

// ================================================== TITLES ==================================================================
	
//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

end



// ==============================================================================================================
//====== START SCRIPTS ===============================================================================
// ==============================================================================================================


//start all the scripts that get kicked off at the beginning and end of player goals and all scripts that are required to start at the beginning of the mission
script static void f_start_all_events_e3_m2
	
//start all the event scripts	
	thread (f_end_events_e3_m2_1());
	print ("ending e3_m2_1");

//	thread (f_e3_m2_switches());
//	print ("starting switches");
//
//	thread (f_start_events_e3_m2_2());
//	print ("starting e3_m2_2");
//	
//	thread (f_end_events_e3_m2_2());
//	print ("ending e3_m2_2");
//	
//	thread (f_start_events_e3_m2_3());
//	print ("starting e3_m2_3");
//	
//	thread (f_end_events_e3_m2_3());
//	print ("ending e3_m2_3");
//	
//	thread (f_e3_m2_objective_vo());
//	print ("starting objective VO");
//	
//	thread (f_e3_m2_subplot_audio());
//	print ("starting subplot_audio");
//	
//	thread (f_misc_spawn_turrets());
//	print ("starting spawn turrets");
		
//	thread (f_start_events_e2_m2_4());
//	print ("starting e2_m2_4");
//	
//	thread (f_end_events_e2_m2_4());
//	print ("ending e2_m2_4");
//		
//	thread (f_start_events_e2_m2_5());
//	print ("starting e2_m2_5");
//	
//	thread (f_end_events_e2_m2_5());
//	print ("ending e2_m2_5");
//		
//	thread (f_start_events_e2_m2_6());
//	print ("starting e2_m2_6");
//	
//	thread (f_end_events_e2_m2_6());
//	print ("ending e2_m2_6");
//		
//	thread (f_start_events_e2_m2_7());
//	print ("starting e2_m2_7");
//	
//	thread (f_end_events_e2_m2_7());
//	print ("ending e2_m2_7");
//		
//	thread (f_start_events_e2_m2_8());
//	print ("starting e2_m2_8");
end

//====== MISC SCRIPTS ===============================================================================

// miscellaneous or helper scripts

//script static void InspectDevice(device object)
//	inspect(object);
//end
//
//
////script static void f_misc_m1_start_turrets
////	sleep_until (LevelEventStatus ("start_turrets"), 1);
////	//NotifyLevel("start_turrets");
////
////	m1_vo_start_turrets();
////end
//
//
//
//global short s_core_exploded = 0;
//
//script static void f_power_core_watch_e3_m2 (device_name switch, object_name core, short spawn_folder)
//	//waits until the switch is flipped then damages the power core 1/3 at a time so the players can see the damage states of the core
//	print ("power core watch thread started");
////	sleep_until (object_valid (switch) and object_valid (core), 1);
//
////	print ("both objects valid in f_power_core_watch_e3_m2");
//	object_cannot_take_damage (core);
//	
//	sleep_until (device_get_position (switch) == 1, 1);
//	print ("core explodes!");
//
////create a new spawn folder at the location of the power core
//	if firefight_mode_goal_get() == 0 then
//		f_create_new_spawn_folder (spawn_folder);
//	end
//
//	sleep_s (2);
//
////prep generators so that they can't be hurt by anybody while script is blowing them up
////	ai_object_set_team (core, spare);
////	ai_allegiance (spare, player);
////	ai_allegiance (spare, covenant);
////	object_set_allegiance (core, player);
////	object_set_allegiance (core, covenant);
////	object_immune_to_friendly_damage (core, true);
//
//	
//	
//	//need to create a variable for the health of the core because there are no functions that return the "true" health of the object just a percentage.
//	local short object_health = object_get_maximum_vitality (core, false);
//	
//	//hackiness to prevent players and cov from damaging the cores and triggering the damage states appropriately
//	object_can_take_damage (core);
//	object_set_health (core, 0.81);
//	damage_object (core, "default", object_health / 10);
//	print ("damage the core a little");
//	
//	//hide the device control in the explosion
//	object_hide (switch, true);
//	
//	object_cannot_take_damage (core);
//	
//	sleep_s (1);
//	object_can_take_damage (core);
//	object_set_health (core, 0.41);
//	damage_object (core, "default", object_health / 10);
//	print ("damage the core a little more");
//	object_cannot_take_damage (core);
//
//	sleep_s (1);
//	object_can_take_damage (core);
//	object_set_health (core, 0.01);
//	damage_object (core, "default", object_health);
//	print ("damage the core to death");
//	object_cannot_take_damage (core);
//	
//	s_core_exploded = s_core_exploded + 1;
//
//end
//
//global boolean b_done_with_core_VO = false;
//
//script static void f_e3_m2_objective_vo
//	print ("objective vo started");
//	
//	//sleep until the first objective is done, then play VO
//	sleep_until (s_core_exploded == 1, 1);
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target1down_vo());
//	e3m2_vo_target1down();
//	
//	//sleep until another core is exploded, if the third one is exploded by the time this hits then skip the second one and only play the third one
//	sleep_until (s_core_exploded > 1, 1);
//	
//	if s_core_exploded == 2 then
//		print ("playing second core exploded");
//		sleep_s (1);
//		thread(f_music_e3m2_objective_target2down_vo());
//		e3m2_vo_target2down();
//	end
//	
//	sleep_until (s_core_exploded == 3, 1);
//	
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target3down_vo());
//	e3m2_vo_target3down();
//	b_done_with_core_VO = true;
//
//end
//
//script static void f_e3_m2_subplot_audio
//	//sleep until a free time, then play the subplot audio
//	print ("starting subplot audio");
//	sleep_until (s_core_exploded > 0, 1);
//	sleep_until (b_dialog_playing == true, 1);
//	sleep_until (b_dialog_playing == false, 1);
//	sleep_s (3);
//	e3m2_vo_subplot1();
//	
//	sleep_until (s_core_exploded > 1, 1);
//	sleep_until (b_dialog_playing == true, 1);
//	sleep_until (b_dialog_playing == false, 1);
//	sleep_s (3);
//	e3m2_vo_subplot2();
//
//end

//========STARTING E3 M2==============================
// here's where the scripts that control the mission go linearly and chronologically

script static void f_start_events_e3_m2_1
	sleep_until (LevelEventStatus("start_e3_m2_1"), 1);
	print ("STARTING start_switch_1");

	thread(f_music_e3m2_start_switch_1_vo());
	//	ai_place (sq_e3_m2_marines_run_around);


//	track the switches
	thread	(f_e3_m2_switches());
	
		
// track the switches and blow up the cores when they are switched plus VO
	sleep_until (object_valid (e3_m2_switch_1) and object_valid (power_core_unsc_1), 1);
		print ("core watch 1 started");
		thread (f_power_core_watch_e3_m2 (e3_m2_switch_1 ,power_core_unsc_1, 99));
	sleep_until (object_valid (e3_m2_switch_2) and object_valid (power_core_unsc_2), 1);	
		print ("core watch 2 started");
		thread (f_power_core_watch_e3_m2 (e3_m2_switch_2 ,power_core_unsc_2, 95));
	sleep_until (object_valid (e3_m2_switch_3) and object_valid (power_core_unsc_3), 1);
		print ("core watch 3 started");
		thread (f_power_core_watch_e3_m2 (e3_m2_switch_3 ,power_core_unsc_3, 98));


	

	b_wait_for_narrative_hud = true;
	
	sleep_until (b_players_are_alive(), 1);
	
	//spawn marines
	ai_place (sq_e3_m2_marines_2);
	
	//start VO/pip/music HUD
//	cinematic_set_title (turn_off_the_power);
	thread(f_music_e3m2_playstart());
	
	e3m2_vo_playstart();
	b_wait_for_narrative_hud = false;
	e3m2_vo_playstart2();
	f_new_objective (ch_e3_m2_1);

	f_create_new_spawn_folder (99);

	//spawn some banshees
	f_e3_m2_banshees();
	
	ai_place_in_limbo (sq_e3_m2_phantom_attack_1);
	print ("phantom attack placed");
//	ai_set_objective (sq_ff_marines_1, obj_marines_run_around);
//	ai_set_objective (sq_ff_marines_2, obj_marine_follow);
end

//script static void f_e3_m2_banshees
//	print ("banshees spawning");
//	sleep_rand_s (1, 3);
//	ai_place (gr_e3_m2_banshees);
//	//cinematic_set_title (banshees);
//	e3m2_vo_banshees1();
//	thread(f_music_e3m2_banshees_vo());
//end
//
//script static void f_e3_m2_switches
//	sleep_until (s_all_objectives_count == 1, 1);
//		print ("one switch down");
//		thread (f_music_e3m2_switch_1_down());
//	//	cinematic_set_title (one_down);	
//	sleep_until (s_all_objectives_count == 2, 1);
//		print ("two switches down");
//		thread(f_music_e3m2_switch_2_down());
//	//	cinematic_set_title (two_down);	
//end
//
//script static void f_end_events_e3_m2_1
//	sleep_until (LevelEventStatus("end_e3_m2_1"), 1);
//	print ("all switches down -- end of goal");
//	//cinematic_set_title (power_off);	
//	f_objective_complete();
//	thread(f_music_e3m2_end());
//end
//
//
//script static void f_start_events_e3_m2_2
//	sleep_until (LevelEventStatus("start_e3_m2_2"), 1);
//	print ("STARTING start_e3_m2_turrets");
//	
//	
//	b_wait_for_narrative_hud = true;
//	
//	//sleep until the 3rd gen down VO is done
//	sleep_until (b_done_with_core_VO == true);
//	//sleeping for pace
//	sleep_s (3);
//	
//	thread(f_music_e3m2_turrets_vo());
//	e3m2_vo_turrets();
//	
//	sleep_s (1);
//	
//	b_wait_for_narrative_hud = false;
//	
//	//give power to the turret switches
//	NotifyLevel ("start_turrets");
//	
//	f_new_objective (ch_e3_m2_2);
//	
//	//sleep until one turret is on, call VO, make banshees 1 shot kills, sleep until both turrets on, call VO, then call hunter drop
//	//doing this all here so that the VO is called
//	sleep_until (s_all_objectives_count == 1);
//		print ("one turret turned on");
//	//cinematic_set_title (one_more_turret);
//	
//	sleep_s (3);
//	
//	//if one turret is on then call the VO, wait for the second turret, then call that vo
//	//if both turrets get turned on at this time, then only call the second VO
//	if s_all_objectives_count == 1 then
//		thread(f_music_e3m2_turret_1_on_vo());
//		e3m2_vo_turret1on();
//		
//		thread (f_e3_m2_bias_banshees());
//	
//		sleep_until (s_all_objectives_count == 2);
//		print ("both turrets turned on");
//	
//		sleep_s (3);
//	
//		thread(f_music_e3m2_turret_2_on_vo());
//		e3m2_vo_turret2on();
//	
//	else
//		thread (f_e3_m2_bias_banshees());
//		thread(f_music_e3m2_turret_2_on_vo());
//		e3m2_vo_turret2on();
//	end
//	
//	sleep_s (1);
//	
//	//drop some hunters and grunts
//	f_e3_m2_hunter_drop();
//	
//end
//
//script static void f_e3_m2_bias_banshees
//	print ("target banshees");
//	local object banshee = ai_vehicle_get (sq_e3_m2_banshee_01.driver);
//	local real max_health = object_get_maximum_vitality (banshee, false);
//	local real banshee_health = unit_get_health (ai_vehicle_get (sq_e3_m2_banshee_01.driver));
//	
//	//if banshee 1 is alive target it and then blow it up once it is hit
//	if object_get_health (sq_e3_m2_banshee_01.driver) > 0 then
//
//		print ("targeting first banshee");
//		banshee = ai_vehicle_get (sq_e3_m2_banshee_01.driver);
//		
//		ai_object_set_targeting_bias (banshee, 1);
//		ai_prefer_target_ai (sq_ff_turrets, sq_e3_m2_banshee_01, true);
//		cs_aim_object (sq_ff_turrets, true, ai_vehicle_get (sq_e3_m2_banshee_01.driver));
//		
//		banshee_health = unit_get_health (ai_vehicle_get (sq_e3_m2_banshee_01.driver));
//		
//		//sleep until the banshee is hurt at all then kill it
//		sleep_until (object_get_health (banshee) < banshee_health, 1);
//		unit_kill(ai_vehicle_get (sq_e3_m2_banshee_01.driver));
//		print ("banshee should be dead");
//		thread(f_music_e3m2_banshee_1_dead());
//	end
//	
//	if object_get_health (sq_e3_m2_banshee_01.driver2) > 0 then
//	
//	//first banshee is dead targeting second banshee
//		print ("targeting second banshee");
//		banshee = ai_vehicle_get (sq_e3_m2_banshee_01.driver2);
//		
//		ai_object_set_targeting_bias (banshee, 1);
//		ai_prefer_target_ai (sq_ff_turrets, sq_e3_m2_banshee_01, true);
//		cs_aim_object (sq_ff_turrets, true, ai_vehicle_get (sq_e3_m2_banshee_01.driver2));
//		
//		banshee_health = unit_get_health (ai_vehicle_get (sq_e3_m2_banshee_01.driver2));
//		
//		sleep_until (object_get_health (banshee) < banshee_health, 1);
//		unit_kill(ai_vehicle_get (sq_e3_m2_banshee_01.driver2));
//		print ("banshee2 should be dead");
//		thread(f_music_e3m2_banshee_2_dead());
//	end
//	
//	print ("both banshees dead");
//	
//end
//
//script static void f_end_events_e3_m2_2
//	sleep_until (LevelEventStatus("end_e3_m2_2"), 1);
//	print ("ending e3_m2_2 turrets");
//	//cinematic_set_title (both_turrets_on);
//	
//	//set remaining AI to get the PlayerEventStatus
//	ai_set_objective (ai_ff_all, obj_e3_m3_survival);
//	
//	
//	
//end
//
//
//script static void f_start_events_e3_m2_3
//	sleep_until (LevelEventStatus("start_e3_m2_3"), 1);
//	print ("STARTING e3_m2_3 (no more waves)");
//	//f_e3_m2_hunter_drop();
//
////
////	sleep_until (ai_living_count (e3_m2_sq_wave_08) > 0, 1);
////	//cinematic_set_title (more_enemies);
////	thread(f_music_e3m2_hunters_vo());
////	e3m2_vo_hunters();
////	f_new_objective (ch_e3_m2_3);
////	f_e3_m2_phantom_vo();
//end
//
//script static void f_e3_m2_hunter_drop
//	print ("hunter drop");
//	
//	//wait until the hunters and grunts are alive, then the drop pod is at the bottom then call VO when they're out
//	
//	//making this run through Bonobo to keep our AI count low
//	//sleep_until (ai_living_count (ai_ff_all) < 11, 1);
//	
//	//ai_place_in_limbo (sq_e3_m2_hunters_grunts);
//	//thread (f_load_drop_pod (dm_drop_04, sq_e3_m2_hunters_grunts, obj_drop_pod_4, false));
//
//	sleep_until (object_valid (dm_drop_04), 1);
//
//	sleep_until (device_get_position (device(dm_drop_04)) == 1, 1);
//	thread(f_music_e3m2_hunters_vo());
//	sleep_s (2);
//	
//	e3m2_vo_hunters();
//	f_new_objective (ch_e3_m2_3);
//	
//	sleep_s (2);
//	f_e3_m2_phantom_vo();
//	
//	sleep_until (ai_living_count (gr_e3_m2_waves_10) > 1, 1);
//	sleep_until (ai_living_count (gr_e3_m2_ff_all) < 6, 1);	
//	vo_glo_remainingcov_04();
//	
//	f_blip_ai_cui(gr_e3_m2_ff_all, "navpoint_enemy");
//	
//end
//
//script static void f_end_events_e3_m2_3
//	//make sure our banshees are dead if the turrets didn't kill them
//	unit_kill(ai_vehicle_get(sq_e3_m2_banshee_01.driver));
//	unit_kill(ai_vehicle_get(sq_e3_m2_banshee_01.driver2));
//	
//	sleep_until (LevelEventStatus("end_e3_m2_3"), 1);
//	print ("ENDING no more waves");
//
//	sleep_s (4);
//	
//	thread(f_music_e3m2_alldone_vo());
//	e3m2_vo_alldone();
//	b_end_player_goal = true;
//	
//	//turn on the chapter complete screen_effect_new
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//	
//	thread(f_music_e3m2_finish());
//	
//	sleep_s (1);
//	fade_out (0,0,0,60);
//	
//end
//
//script static void f_e3_m2_phantom_vo
//	print ("start phantom VO");
//	sleep_until (ai_living_count (sq_e3_m2_phantom_01) > 0, 1);
//	thread(f_music_e3m2_phantom_vo());
//	e3m2_vo_phantom1();
//end


//=======ENDING E3 M2==============================




// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//ai command scripts

// PHANTOM 01 =================================================================================================== 
//script command_script cs_ff_phantom_01()
//	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
//	sleep (1);
////	object_cannot_die (v_ff_phantom_01, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
////	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (ai_current_actor, TRUE);
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_enable_targeting (true);
//	cs_fly_by (ps_ff_phantom_01.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_ff_phantom_01.p1);
////		(print "flew by point 1")
//	cs_fly_to_and_face (ps_ff_phantom_01.p2,ps_ff_phantom_01.p0);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 3);
//
//		// ======== DROP DUDES HERE ======================
//			
//	f_unload_phantom (ai_current_actor, "dual");
//	
//			
//		// ======== DROP DUDES HERE ======================
//		
//	print ("ff_phantom_01 unloaded");
//	sleep (30 * 5);
//	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_ff_phantom_01.p1);
//	cs_fly_to (ps_ff_phantom_01.p3);
////	(cs_fly_by ps_ff_phantom_01/erase 10)
//// erase squad 
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	sleep_s (3);
//	ai_erase (ai_current_squad);
//end
//
//// PHANTOM 02 =================================================================================================== 
//script command_script cs_ff_phantom_02()
////	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
////	sleep(30);
////	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
////	sleep (1);
////	object_cannot_die (v_ff_phantom_02, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
////	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (ai_current_actor, TRUE);
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_02.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_ff_phantom_02.p1);
////		(print "flew by point 1")
//	cs_fly_to_and_face (ps_ff_phantom_02.p2,ps_ff_phantom_01.p0);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 1);
//
//		// ======== DROP DUDES HERE ======================
//			
//	f_unload_phantom (ai_current_actor, "dual");
//	
//			
//		// ======== DROP DUDES HERE ======================
//		
//	print ("ff_phantom_02 unloaded");
//	sleep (30 * 5);
//	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_ff_phantom_02.p3);
//	cs_fly_to (ps_ff_phantom_02.erase);
//// erase squad 
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	sleep (30 * 3);
//	ai_erase (ai_current_squad);
//end
//
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_e3_m2_phantom_attack_1()
////	cs_ignore_obstacles (false);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
//	sleep(30);
//	
//	ai_exit_limbo (ai_current_squad);
//	
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
//	sleep (1);
//	
//	cs_enable_pathfinding_failsafe (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_enable_targeting (true);
//	cs_fly_by (ps_e3_m2_phantom_attack_1.p0);
////	cs_fly_by (ps_ff_phantom_02.p3);
//	cs_fly_by (ps_e3_m2_phantom_attack_1.p1);
////	cs_fly_to (ps_ff_phantom_02.p4);
//	//cs_shoot (true, v_mac_cannon_1);
//	//sleep until the players are dead
//	cs_force_combat_status (3);
////	sleep_until (
////		object_get_health (player0) <= 0 and
////		object_get_health (player1) <= 0 and
////		object_get_health (player2) <= 0 and
////		object_get_health (player3) <= 0);
////	
//	sleep_s (10);
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_e3_m2_phantom_attack_1.p2);
//	cs_fly_to (ps_e3_m2_phantom_attack_1.erase);
//	
//	//erase
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	sleep_s (3);
//	ai_erase (ai_current_squad);
//	
//end
//
//// PHANTOM ATTACK 1 =================================================================================================== 
//script command_script cs_e3_m2_phantom_attack_2()
//	cs_ignore_obstacles (TRUE);
////	ai_set_blind (ai_current_squad, FALSE);
//	cs_fly_by (ps_ff_phantom_01.p0);
//	cs_fly_by (ps_ff_phantom_01.p1);
//	cs_fly_to (ps_ff_phantom_01.p4);
//	//cs_shoot (true, v_mac_cannon_1);
//		//sleep until the players are dead
//	cs_force_combat_status (3);
////	sleep_until (
////		object_get_health (player0) <= 0 and
////		object_get_health (player1) <= 0 and
////		object_get_health (player2) <= 0 and
////		object_get_health (player3) <= 0);
//	sleep_until (b_game_ended == TRUE);	
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_fly_by (ps_ff_phantom_01.p5);
//	cs_fly_to (ps_ff_phantom_01.erase);
//	ai_erase (ai_current_squad);
//	
//end

// ==============================================================================================================
//====== DROP POD SCRIPTS ===============================================================================
// ==============================================================================================================


//script static void f_small_drop_pod_0
//	print ("drop pod 0");
//	object_create (small_pod_0);
//	thread(small_pod_0->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p0, .85, DEFUALT ));
//end
//
//script static void f_small_drop_pod_1
//	print ("drop pod 0");
//	object_create (small_pod_1);
//	thread(small_pod_1->drop_to_point( sq_ff_drop_0, ps_ff_drop_pods.p1, .85, DEFUALT ));
//end

//script command_script cs_drop_pod
//	sleep_s (5);
//	ai_set_objective (ai_current_squad, obj_e3_m2_survival);
//end

// ==============================================================================================================
//====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//script command_script cs_ff_pelican_marines
//	cs_ignore_obstacles (TRUE);
//	ai_cannot_die (ai_current_squad, TRUE);
//	sleep (1);
//	object_create_anew (pelican_ammo);
//  sleep (1);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point(sq_ff_pelican.pilot), "pelican_lc", pelican_ammo);
//	sleep (1);
//	//cs_fly_to (ps_ff_pelican.p0);
//	//cs_fly_to (ps_ff_pelican.p1);
//	
//	//cs_fly_to_and_face (ps_ff_pelican.p2, ps_ff_pelican.p3);
//	//sleep (30 * 5);
//	cs_fly_to (ps_ff_pelican_outro.p0);
//	cs_fly_to (ps_ff_pelican_outro.p1);
//	cs_fly_to (ps_ff_pelican_outro.p2);
//	cs_fly_to (ps_ff_pelican_outro.p3);
//	
//	ai_vehicle_exit (sq_e3_m2_marines_1);
//	cs_pause(5);
//	ai_set_objective (sq_e3_m2_marines_1, obj_survival);
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_ff_pelican.pilot), "pelican_lc");
////	sleep (30 * 5);
//	cs_pause(5);
//	//cs_fly_to (ps_ff_pelican.p3);
//	//cs_fly_to (ps_ff_pelican.p4);
////	sleep (30 * 20);
//	cs_fly_to (ps_ff_pelican_outro.p1);
//	cs_fly_to (ps_ff_pelican_outro.p0);
//	//cs_fly_to (ps_ff_pelican_outro.p2);
//	
//	ai_erase (ai_current_squad);
//end
//
//// ==OUTRO PELICAN 1
//script command_script cs_outro_pelican
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican_outro.p0);
//	cs_fly_to (ps_ff_pelican_outro.p1);
//	cs_fly_to (ps_ff_pelican_outro.p2);
//
//end
//
//script static void f_pelican_outro
//	//start the pelican mini-vignette
//	print ("pelican outro");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro.p1, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro.p1, 60);
//	sleep (30 * 12);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end
//
//// ==OUTRO PELICAN 2
//
//script command_script cs_outro_pelican_2
//	ai_cannot_die (ai_current_squad, TRUE);
//	cs_ignore_obstacles (TRUE);
//	cs_fly_to (ps_ff_pelican_outro_2.p0);
//	cs_fly_to (ps_ff_pelican_outro_2.p1);
////	cs_fly_to (ps_ff_pelican_outro_2.p2);
//end
//
//script static void f_pelican_outro_2
//	//start the pelican mini-vignette
//	print ("pelican outro_2");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	player_control_lock_gaze (player0, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player1, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player2, ps_ff_pelican_outro_2.p2, 60);
//	player_control_lock_gaze (player3, ps_ff_pelican_outro_2.p2, 60);
//	sleep (30 * 12);
//	player_control_unlock_gaze (player0);
//	player_control_unlock_gaze (player1);
//	player_control_unlock_gaze (player2);
//	player_control_unlock_gaze (player3);
//	object_can_take_damage (players());
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end



//script static void pelican_intro
//	fade_out (0, 0, 0, 1);
//	sleep (30);
//	object_create (test);
//	object_move_by_offset (test, 1, 0, 0, 500);
//	teleport_players_into_vehicle (test);
//	unit_open (test);
//	fade_in (0, 0, 0, 3);
//	player_effect_set_max_rotation (5, 5, 5);
//	player_effect_set_max_rumble(5, .5);
//	player_effect_start (5, 3);
//	object_move_by_offset (test, 5, 0, 0, -500);
//	fade_out (255, 255, 255, 1);
//	player_effect_stop (1);
//	sleep (30 * 1);
//	object_destroy (test);
//	object_teleport_to_object (player0, spartan_respawn_0);
//	fade_in (255, 255, 255, 90);
//
//end

// ===================================================================================
//===========TURRETS=======================================
// ===================================================================================

//currently when called turrets will be around forever
//script command_script cs_stay_in_turret
//	cs_shoot (true);
//	cs_enable_targeting (true);
//	cs_enable_moving (true);
//	cs_enable_looking (true);
//	cs_abort_on_damage (FALSE);
//	cs_abort_on_alert (FALSE);
//	//(sleep_until (<= (ai_living_count ai_current_actor) 0))
//end
//
//script static void f_create_turret_1
//	object_create_anew (turret_switch_1);
////	f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b");
//end
//
//script static void f_misc_spawn_turrets
////	sleep_until (LevelEventStatus ("spawn_turrets"), 1);
//	print ("::TURRETS::");
//	sleep_until (object_valid (turret_switch_0));
////		print("Turret Status");
//	object_set_scale (turret_switch_0, 2, 1);
//	InspectDevice(turret_switch_0);
////	InspectObject(turret_switch_1);
//
//	thread (f_turret_place (sq_ff_turrets.pilot_0, turret_switch_0));
////	object_create (turret_switch_1);
//	sleep_until (object_valid (turret_switch_1));
//	object_set_scale (turret_switch_1, 2, 1);
//	InspectDevice(turret_switch_1);
//	thread (f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1));
////	NotifyLevel ("start_turrets");
//end
//
//
//
//script static void f_turret_place (ai turret_spawn, device dm_switch)
//	ai_place (turret_spawn);
//	print ("placing turret");
//	//set up the turret so it waits until it's ready to be activated
//
//	local unit turret_object = ai_vehicle_get(turret_spawn);
//
//	ai_cannot_die (turret_spawn, true);
//	object_cannot_take_damage (turret_spawn);
//
//	object_immune_to_friendly_damage (turret_object, true);
//	
//	ai_disregard (ai_actors (turret_spawn), true);
//	ai_braindead (turret_spawn, TRUE);
//	sentry_deactivate(turret_object);
//	sentry_deactivate_barrel(turret_object, 0);
//	sentry_deactivate_barrel(turret_object, 1);
//	
//	sleep_until (LevelEventStatus("start_turrets"), 1);
//	//turret is now ready to be turned powered on by the player flipping the switch
//	print ("powering up turrets");
//	//sleep(1);
//	inspect (dm_switch);
//	device_set_power (dm_switch, 1);
//	inspect (device_get_power (dm_switch));
////	device_get_power (dm_switch);
//	//chud_track_object_with_priority (ai_vehicle_get (turret_spawn), hud_marker);
//	//f_blip_object (ai_vehicle_get (turret_spawn), hud_marker);
////	f_blip_object_cui (ai_get_object (turret_spawn), "navpoint_ally_vehicle");
//	sleep_until (device_get_position (dm_switch) > 0, 1);
//	//the switch is flipped and is now activing shooting at fools
//	f_turret_ai (turret_spawn, dm_switch);
//end
//
//script static void f_turret_ai (ai turret_ai, device switch)
////	repeat
//		print ("turret online!");
//		
//		//turn off the switch that turns it on
//		device_set_power (switch, 0);
//		// Associate the turret AI with the player.
//		ai_object_set_team (turret_ai, player);
//
//		// Turn of the navpoint marker.
//		f_unblip_object_cui (ai_get_object (turret_ai));
//
//		// Get the actual turret object.
//		local unit turret_object = ai_vehicle_get(turret_ai);
//
//		ai_object_set_team (turret_object, player);
//
//		// Activate the sentry and its barrels.
//		sentry_activate(turret_object);
//		sentry_activate_barrel(turret_object, 0);
//		sentry_activate_barrel(turret_object, 1);
//
//		ai_cannot_die(turret_ai, false);                              
//		object_can_take_damage(turret_object);
//
//
//		// Sleep until the turret is destroyed.
//		sleep_until(object_get_health(turret_object) == 0);
//		print ("turret is destroyed");
//
//
//end


// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

script static void f_start_player_intro_e3_m2
	//firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s(1);
				
		//f_e3_m2_intro_vignette();
		
	else
		print ("NOT editor mode play the intro");
		//wait for pick your loadout screen to be done
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		
		//intro();
		f_e3_m2_intro_vignette();
				
	end
	
	//when the intro is done switch zone sets and spawn the player
	switch_zone_set (e3_m2);
	print ("zone set switched");
	firefight_mode_set_player_spawn_suppressed(false);
	

	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	
	sleep_s (0.5);
	fade_in (0,0,0,15);

	
end

script static void f_e3_m2_intro_vignette
	//set up, play and clean up the intro
	print ("playing intro");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1);
	
	ai_enter_limbo (gr_e3_m2_ff_all);
	cinematic_start();
	
	ai_place (sq_e3m2_intro_marines);
  
	thread(f_music_e3m2_vignette_start());
 
	b_wait_for_narrative = true;
  pup_play_show(pup_e3_m2_in);
  e3m2_vo_intro();
	sleep_until (b_wait_for_narrative == false);
	thread(f_music_e3m2_vignette_finish());
	//ai_erase (sq_e3m2_intro_marines);
	//ai_erase (sq_e3m2_intro_pelican);
	
	cinematic_stop();
	ai_exit_limbo (gr_e3_m2_ff_all);
	print ("all ai exiting limbo after the puppeteer");
end

//tells the script when the narrative is done -- called from within puppeteer
script static void f_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;

end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================

//script static void f_turret_ai (ai turret, device switch)
//	repeat
//		print ("turret online!");
//		//turn off power to the switch			
//		device_set_power (switch, 0);
//		ai_object_set_team (turret, player);
//		
//		
//		//turn off the HUD marker
//		f_unblip_object_cui (ai_get_object (turret));
////		if turret == sq_ff_turrets.pilot_0 then
////			//f_unblip_object (ai_vehicle_get (sq_ff_turrets.pilot_0));
////			f_unblip_object_cui (ai_get_object (sq_ff_turrets.pilot_0));
////		elseif turret == sq_ff_turrets.pilot_1 then
////			//f_unblip_object (ai_vehicle_get (sq_ff_turrets.pilot_1));
////			f_unblip_object_cui (ai_get_object (sq_ff_turrets.pilot_1));
////		elseif turret == sq_ff_turrets.pilot_2 then
////			//f_unblip_object (ai_vehicle_get (sq_ff_turrets.pilot_2));
////			f_unblip_object_cui (ai_get_object (sq_ff_turrets.pilot_2));
////		elseif turret == sq_ff_turrets.pilot_3 then
////			//f_unblip_object (ai_vehicle_get (sq_ff_turrets.pilot_3));
////			f_unblip_object_cui (ai_get_object (sq_ff_turrets.pilot_3));
////		end
//		
//		//activate the turret - make it fight, make it take damage
//		unit_open (ai_vehicle_get_from_spawn_point (turret));
//		object_can_take_damage (ai_vehicle_get_from_spawn_point (turret));
//		ai_braindead (turret, false);
//		ai_disregard (ai_actors (turret), false);
//		//sleep until the turret has no health
//		sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (turret)) <= 0, 1);
//		//turn off the turret and make the enemies disregard it
//		object_cannot_take_damage (ai_vehicle_get_from_spawn_point (turret));
//		print ("turret is damaged -- closing");
//		ai_braindead (turret, TRUE);
//		ai_disregard (ai_actors (turret), true);
//		unit_close (ai_vehicle_get_from_spawn_point (turret));
//		sleep (300);
//		//reset the switch, give the turret health, turn the switch back on
//		device_set_position_immediate (switch, 0);
//		unit_set_current_vitality (ai_vehicle_get_from_spawn_point (turret), 400, 0);
//		device_set_power (switch, 1);
//		//blip the correct switch
//		
//		f_blip_object_cui (ai_get_object (turret), "navpoint_ally_vehicle");
////		if (switch == turret_switch_0) then
////			//f_blip_object (ai_vehicle_get (sq_ff_turrets.pilot_0), "a");
////			f_blip_object_cui (ai_get_object (sq_ff_turrets.pilot_0), "navpoint_ally_vehicle");
////		elseif (switch == turret_switch_1) then
////			//f_blip_object (ai_vehicle_get (sq_ff_turrets.pilot_1), "b");
////			f_blip_object_cui (ai_get_object (sq_ff_turrets.pilot_1), "navpoint_ally_vehicle");
////		elseif (switch == turret_switch_2) then
////			//f_blip_object (ai_vehicle_get (sq_ff_turrets.pilot_2), "a");
////			f_blip_object_cui (ai_get_object (sq_ff_turrets.pilot_2), "navpoint_ally_vehicle");
////		elseif (switch == turret_switch_3) then
////			//f_blip_object (ai_vehicle_get (sq_ff_turrets.pilot_3), "b");
////			f_blip_object_cui (ai_get_object (sq_ff_turrets.pilot_3), "navpoint_ally_vehicle");
////		end
//		//wait until the switch it flipped by the player
//		sleep_until (device_get_position (switch) > 0, 1);
//	until (b_game_won == 1 or b_game_lost == 1);	
//end