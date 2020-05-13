//// =============================================================================================================================
//========= BREACH SPARTAN OPS SCRIPTS ========================================================
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

global boolean b_e6_m5_wait_for_narrative = false;


script startup e6_m5_breach_destroy

	//dprint( "breach_e6_m5 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e6_m5") ) then
		wake( breach_e6_m5_init );
	end

end

script dormant breach_e6_m5_init()

	print ("************STARTING E6 M5*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e6_m5", e6_m5, gr_e6_m5_ff_all, sc_e6_m5_spawn_points_0, 90 );
	
	//start the intro thread
	thread(f_start_player_intro_e6_m5());

	//start the first starting event
	thread (f_start_events_e6_m5_1());
	print ("starting e6_m5_1");

	//start all the rest of the event scripts
	thread (f_start_all_events_e6_m5());
	print ("starting e6_m5 all events thread");

//======== OBJECTS ==================================================================

//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	f_add_crate_folder(sc_e6_m5_objectives); //IFF tags
	f_add_crate_folder(cr_e6_m5_cov_cover); //IFF tags
	f_add_crate_folder(cr_e6_m5_other); //IFF tags
	f_add_crate_folder(eq_e6_m5_unsc_ammo); //IFF tags
	f_add_crate_folder(wp_e6_m5_unsc); //IFF tags
	f_add_crate_folder(cr_e6_m5_cov_ammo); //IFF tags
	f_add_crate_folder(cr_e6_m5_unsc_ammo); //IFF tags
//	f_add_crate_folder(cr_e8_m1_cov_cover); //UNSC crates and barriers around the main spawn area
//	f_add_crate_folder(cr_e8_m1_weapon_racks);
//	f_add_crate_folder(cr_e8_m1_fixed_cover);
//	
//	f_add_crate_folder(dc_e8_m1);
//	
//	f_add_crate_folder(eq_e8_m1_unsc_ammo);

// puts spawn point folders into an index that is used to automatically turn on/off spawn points and used by designers to override current spawn folders
//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_3, 93);
	firefight_mode_set_crate_folder_at(sc_e6_m5_spawn_points_4, 94);
	
//puts certain objects into an index that is used to track objectives set in the player goals in the variant tag
//set objective names
	
	firefight_mode_set_objective_name_at(dc_e6_m5_iff1,			1); //iff tag 1
	firefight_mode_set_objective_name_at(dc_e6_m5_iff2,			2); //iff tag 2
	firefight_mode_set_objective_name_at(dc_e6_m5_iff3,			3); //iff tag 3
	firefight_mode_set_objective_name_at(dc_e6_m5_iff4,			4); //iff tag 4
	firefight_mode_set_objective_name_at(dc_e6_m5_comp,			5); //computer
	firefight_mode_set_objective_name_at(dc_e6_m5_dig,			6); //computer
	firefight_mode_set_objective_name_at(sc_e6_m5_lz,				7);
	
//	firefight_mode_set_objective_name_at(dc_e8_m1_mark2,		5);
//	firefight_mode_set_objective_name_at(dc_e8_m1_mark3,		6);
//	firefight_mode_set_objective_name_at(turret_switch_0, 10); //turret switch
//	firefight_mode_set_objective_name_at(turret_switch_1, 11); //turret switch	

//set LZ (location arrival) spots			
//	firefight_mode_set_objective_name_at(area_1, 51); //objective in the main spawn area

//	firefight_mode_set_objective_name_at(area_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(area_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(area_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(area_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(area_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(area_7, 57); //objective right by the tunnel entrance
	
//==== DECLARE AI ====
//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
//set squad group names
//guards
	firefight_mode_set_squad_at(sq_e6_m5_guards_1, 1);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(sq_e6_m5_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(sq_e6_m5_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(sq_e6_m5_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(sq_e6_m5_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(sq_e6_m5_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(sq_e6_m5_guards_8, 8); //on the bridge
	
	
	firefight_mode_set_squad_at(sq_e6_m5_other_1, 11);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_other_2, 12);	//left building	
	firefight_mode_set_squad_at(sq_e6_m5_other_3, 13);	//left building	
	firefight_mode_set_squad_at(sq_e6_m5_other_4, 14);	//left building
		
	//digger guards
	firefight_mode_set_squad_at(sq_e6_m5_dig_1, 31); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_2, 32); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_3, 33); //on the bridge
	firefight_mode_set_squad_at(sq_e6_m5_dig_4, 34); //on the bridge

//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sq_e6_m5_waves_1, 81);	//left building
	firefight_mode_set_squad_at(sq_e6_m5_waves_2, 82);	//front by the main start area
//	firefight_mode_set_squad_at(sq_e8_m1_waves_3, 83);	//front by the main start area
//	firefight_mode_set_squad_at(sq_e8_m1_waves_4, 84);	//front by the main start area
//	firefight_mode_set_squad_at(sq_e8_m1_waves_5, 85);	//front by the main start area	

	//shades
//	firefight_mode_set_squad_at(sq_e8_m1_shades_1, 31);	//left building
//	firefight_mode_set_squad_at(sq_e8_m1_shades_2, 32);	//left building
//	firefight_mode_set_squad_at(sq_e8_m1_ghosts_1, 33);	//left building	
//	firefight_mode_set_squad_at(sq_e8_m1_ghosts_2, 34);	//left building		

//	//phantoms
	firefight_mode_set_squad_at(sq_ph, 21); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_02, 22); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_03, 23); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_04, 24); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_1, 31); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_2, 32); //phantoms 
//	

	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	

end



// ==============================================================================================================
//====== START SCRIPTS ===============================================================================
// ==============================================================================================================


//start all the scripts that get kicked off at the beginning and end of player goals and all scripts that are required to start at the beginning of the mission
script static void f_start_all_events_e6_m5
	
//start all the event scripts	
	print ("starting all events");

	thread (f_start_events_e6_m5_2());
	print ("starting e6_m5_2");
	
	thread (f_start_events_e6_m5_3());
	print ("starting e6_m5_3");

	thread (f_start_events_e6_m5_4());
	print ("starting e6_m5_4");
	
	thread (f_start_events_e6_m5_5());
	print ("starting e6_m5_5");
	
	thread (f_start_events_e6_m5_6());
	print ("starting e6_m5_6");

//	thread (f_end_events_e6_m5_6());
//	print ("ending e6_m5_6");

	thread (f_start_events_e6_m5_7());
	print ("starting e6_m5_7");
	
	
end



//========STARTING E6 M5==============================
// here's where the scripts that control the mission go linearly and chronologically


//===== GET THE IFF tags
//players spawn and must get the IFF tags, prometheans spawn around the tags as players get close
script static void f_start_events_e6_m5_1
	sleep_until (LevelEventStatus("start_e6_m5_1"), 1);
	print ("starting e6_m5_1");

	
	b_wait_for_narrative_hud = true;
	
	//sleep until mission complete
	sleep_until( f_spops_mission_start_complete(), 1 );
	//sleep_until (b_players_are_alive(), 1);
	
	thread (f_e6_m5_start_guards());
	thread (f_e6_m5_start_other());
	thread (f_e6_m5_vo_tracker());
	//create some objective props
	//thread (f_e8_m1_props());
	
	sleep_s (0.5);
	fade_in (0,0,0,15);

	f_new_objective (ch_6_5_1);
	cinematic_set_title (ch_6_5_1);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	
	//power on the switches
	thread (f_e6_m5_tag_track());
	
end


script static void f_e6_m5_start_guards
	print ("start guards thread");
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards1, sq_e6_m5_guards_1, sq_e6_m5_bishops_1));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards2, sq_e6_m5_guards_2, sq_e6_m5_bishops_2));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards3, sq_e6_m5_guards_3, sq_e6_m5_bishops_3));
	thread (f_e6_m5_guards_ai (tv_e6_m5_guards4, sq_e6_m5_guards_4, sq_e6_m5_bishops_4));
	
end

script static void f_e6_m5_start_other
	print ("start guards thread");
	thread (f_e6_m5_other_ai (tv_e6_m5_other1, sq_e6_m5_other_1));
	thread (f_e6_m5_other_ai (tv_e6_m5_other2, sq_e6_m5_other_2));
	thread (f_e6_m5_other_ai (tv_e6_m5_other3, sq_e6_m5_other_3));
	thread (f_e6_m5_other_ai (tv_e6_m5_other4, sq_e6_m5_other_4));
	
end


script static void f_e6_m5_tag_track
	print ("tag track");
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff1, sc_e6_m5_iff1));
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff2, sc_e6_m5_iff2));	
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff3, sc_e6_m5_iff3));
	thread(f_e6_m5_tag_tracker (dc_e6_m5_iff4, sc_e6_m5_iff4));
end

//===== ALL IFF TAGS ACTIVATED -- start no more waves -- kill all the ai

script static void f_start_events_e6_m5_2
	sleep_until (LevelEventStatus("start_e6_m5_2"), 1);
	print ("STARTING e6_m5_2 swarm");

	b_wait_for_narrative_hud = true;
	
	sleep_s (4);
	
	f_new_objective (ch_6_5_2);
	cinematic_set_title (ch_6_5_2);
	sleep_s (3);
	b_wait_for_narrative_hud = false;
	
end

//-- START COVENANT COMPUTER GOAL ======

script static void f_start_events_e6_m5_3
	sleep_until (LevelEventStatus("start_e6_m5_3"), 1);
	print ("STARTING e6_m5_3 (cov computer)");
	
	sleep_s (3);
	print ("preparing to switch zone set");
	//switch zone set during VO
	prepare_to_switch_to_zone_set(e6_m5_digger);
	
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_6_5_3);
	cinematic_set_title (ch_6_5_3);

	sleep_s (3);
	
	//sleep until there's no pause
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e6_m5_digger);
	
	b_wait_for_narrative_hud = false;
	
	//turn on the switch
	device_set_power (dc_e6_m5_comp, 1);
	
end

//== THE DIGGER IS OPEN ==
//the door to the digger is opening, the goal is to go inside

script static void f_start_events_e6_m5_4
	sleep_until (LevelEventStatus("start_e6_m5_4"), 1);
	print ("STARTING e6_m5_4");

	//shake the camera for opening the door
	camera_shake_all_coop_players (.8, .8, 6, 1.8);

	b_wait_for_narrative_hud = true;
	f_new_objective (ch_6_5_5);
	cinematic_set_title (ch_6_5_5);
	sleep_s (3);
	b_wait_for_narrative_hud = false;
	object_destroy (cr_e6_m5_dig_block1);
	object_destroy (cr_e6_m5_dig_block2);
	
end

//== ALL AI ARE DEAD ==
//the players have killed all the AI in the digger and are about to be told to ensure the digger is disabled

script static void f_start_events_e6_m5_5
	sleep_until (LevelEventStatus("start_e6_m5_5"), 1);
	print ("STARTING e6_m5_5");

	b_wait_for_narrative_hud = true;
	//switch zone set during VO
	prepare_to_switch_to_zone_set(e6_m5);
	f_new_objective (ch_6_5_4);
	cinematic_set_title (ch_6_5_4);
	sleep_s (3);
	
	//sleep until there's no pause
	sleep_until(not PreparingToSwitchZoneSet(), 1);
	switch_zone_set(e6_m5);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e6_m5_dig, 1);
end

//== KILL THE NEWLY SPAWNED PROMETHEANS ==
//with the digger disabled, some prometheans spawn (mainly through the bonobo tags), the player must kill them all to proceed

script static void f_start_events_e6_m5_6
	sleep_until (LevelEventStatus("start_e6_m5_6"), 1);
	print ("STARTING e6_m5_6");
	
	ai_place_with_birth (sq_e6_m5_bishops_1);
	ai_place_with_birth (sq_e6_m5_bishops_2);
	ai_place_with_birth (sq_e6_m5_bishops_3);
	ai_place_with_birth (sq_e6_m5_bishops_4);	
	
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_6_5_6);
	cinematic_set_title (ch_6_5_6);
	sleep_s (3);
	b_wait_for_narrative_hud = false;
	
end

//== END OF MISSION ==
//the player has killed all the prometheans and the mission ends

script static void f_start_events_e6_m5_7
	sleep_until (LevelEventStatus("start_e6_m5_7"), 1);
	cinematic_set_title (ch_6_5_7);
	sleep_s (3);
		
	b_end_player_goal = true;
	
	f_e6_m5_end_mission();

end
//script static void f_e8_m1_props
//	print ("creating props");
//	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal1);
//	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal2);
//	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal3);
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
//	sleep_until (LevelEventStatus("start_e6_m5_2"), 1);
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

//end of last player goal




//=======ENDING E6 M5==============================

script static void f_e6_m5_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

end

//====== MISC SCRIPTS ===============================================================================

// miscellaneous or helper scripts

global boolean b_done_with_iff_VO = false;
global short s_iff_activated = 0;

script static void f_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

script static void f_e6_m5_vo_tracker
	print ("starting VO tracker");
	
	local short vo_played = 0;
	//sleep until a tag is picked up, don't play them all in order, skip VO if the players pick up multiple tags during running VO
	repeat
		sleep_until (s_iff_activated > vo_played, 1);
		
		if s_iff_activated == 1 then
			//play VO here
			sleep_s (1);
			cinematic_set_title (ch_6_5_a);
			sleep_s (2);
		elseif s_iff_activated == 2 then
			print ("playing second tag activated");
				//play VO here
			sleep_s (1);
			cinematic_set_title (ch_6_5_b);
			sleep_s (2);
		elseif s_iff_activated == 3 then
			print ("playing third tag activated");
			//play VO here
			sleep_s (1);
			cinematic_set_title (ch_6_5_c);
			sleep_s (2);
		elseif s_iff_activated == 4 then
			print ("playing fourth tag activated");
				//play VO here
			sleep_s (1);
			cinematic_set_title (ch_6_5_d);
			sleep_s (2);
		end
		
		vo_played = vo_played + 1;
		
	until (s_iff_activated == 4, 1);
	

	b_done_with_iff_VO = true;

end

script static void f_e6_m5_tag_tracker (device tag_dev, object tag_obj)
	print ("start tag tracker");
	device_set_power (tag_dev, 1);
	sleep_until (device_get_position (tag_dev) > 0, 1);
	print ("iff tag control activated, destroying appropriate iff scenery object");
	object_destroy (tag_obj);
	s_iff_activated = s_iff_activated + 1;

end


// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//ai command scripts

//script static void f_e8_m1_wraith
//	print ("spawn wraith");
//	ai_place_in_limbo  (sq_e8_m1_wraith);
//	vehicle_load_magic(ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e8_m1_wraith.driver));
//	ai_exit_limbo (sq_e8_m1_wraith);
//end

// PHANTOM 01 =================================================================================================== 
//script command_script cs_e8_m1_phantom_01()
//	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
//	sleep (1);
//	
//	//sleep_s (2);
//	
//	//f_e8_m1_wraith();
//	
//	print ("spawn wraith");
////	ai_place_in_limbo  (sq_e8_m1_wraith);
//	ai_place (sq_e8_m1_wraith);
//	ai_braindead (sq_e8_m1_wraith, true);
////	sleep (2);
//	vehicle_load_magic(ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e8_m1_wraith.driver));
//	
////	sleep (2);
////	
////	ai_exit_limbo (sq_e8_m1_wraith);
//	
////	object_cannot_die (v_ff_phantom_01, TRUE);
////	cs_enable_pathfinding_failsafe (TRUE);
////	cs_ignore_obstacles (TRUE);
//	object_set_shadowless (ai_current_actor, TRUE);
//	//ai_set_blind (ai_current_squad, TRUE);
//	cs_enable_targeting (true);
//	cs_fly_by (ps_phantom_1.p0);
////		(print "flew by point 0")
//	cs_fly_by (ps_phantom_1.p1);
////		(print "flew by point 1")
//	cs_fly_to (ps_phantom_1.p2);
////	(cs_fly_to ps_ff_phantom_01/p3)
////		(print "flew to point 2")
////	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
////	(cs_vehicle_speed 0.50)
//	sleep (30 * 3);
//
//		// ======== DROP DUDES HERE ======================
//	
//	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc");
////	ai_set_objective (sq_e8_m1_phantom_1, obj_e8_m1_wraith);
//	ai_braindead (sq_e8_m1_wraith, false);
//	f_unload_phantom (ai_current_actor, "dual");
//	
//			
//		// ======== DROP DUDES HERE ======================
//		
//	print ("phantom_01 unloaded");
//	sleep (30 * 5);
//	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_phantom_1.p3);
//	cs_fly_to (ps_phantom_1.p4);
//	cs_fly_to (ps_phantom_1.erase);
//// erase squad 
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
//	sleep_s (3);
//	ai_erase (ai_current_squad);
//end
////
//// PHANTOM 02 =================================================================================================== 
script command_script cs_test_phantom_02()
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
//	sleep(30);
//	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
//	sleep (1);
//	object_cannot_die (v_ff_phantom_02, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	//ai_set_blind (ai_current_squad, TRUE);
	cs_fly_by (ps_ff_phantom_02.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_ff_phantom_02.p1);
//		(print "flew by point 1")
	cs_fly_to_and_face (ps_ff_phantom_02.p2,ps_ff_phantom_01.p0);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		// ======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		// ======== DROP DUDES HERE ======================
		
	print ("ff_phantom_02 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_ff_phantom_02.p3);
	cs_fly_to (ps_ff_phantom_02.erase);
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end
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
//====== DROP POD AND TELEPORT SCRIPTS ===============================================================================
// ==============================================================================================================

//THIS SPAWNS IN THE GUARDS TO THE IFF TAGS ONCE THE PLAYER GETS CLOSE
script static void f_e6_m5_guards_ai (trigger_volume tv, ai guards, ai bishop)
	print ("starting guards ai");
	sleep_until (volume_test_players (tv), 1);
	print ("trigger volume hit, spawning knights");
	ai_place_in_limbo (guards);
	sleep_until (ai_living_count (guards) > 0, 1);
	print ("guards spawned");
	ai_place_with_birth (bishop);
	sleep_until (ai_living_count (bishop) > 0, 1);
	print ("bishop spawned");
end

//THIS SPAWNS IN THE OTHER AI ONCE THE PLAYER GETS CLOSE
script static void f_e6_m5_other_ai (trigger_volume tv, ai other,)
	print ("starting other ai");
	
	repeat
		//sleep until a player hits the trigger volume
		sleep_until (volume_test_players (tv), 1);
		print ("trigger volume hit");	
	
		//if the mission is at the digger then sleep this script
		if firefight_mode_goal_get() > 1 then
			sleep_forever();
			print ("mission is past the point to spawn others, killing the script");
		end
	
		//spawn others if AI count is low enough, else don't spawn :(
		if ai_living_count (ai_ff_all) <= 6 then
			print ("ai living count low enough, spawning other");	
			ai_place_in_limbo (other);
			sleep_until (ai_living_count (other) > 0, 1);
			print ("other spawned");
			sleep_forever();
		else
			print ("AI count too high, don't spawn");
		end	
	until (firefight_mode_goal_get() > 1, 1);
	
end

script static void f_e6_m5_waves_2_bishop_spawn
	sleep_until (LevelEventStatus("waves_2_bishops"), 1);
	print ("waves 2 bishops spawning");
	ai_place_with_birth (sq_e6_m5_waves_2_bishops);
end

script command_script cs_e6_m5_knight_phase
	print ("knight phase in");
//	print_cs();
	sleep_rand_s (0.1, .5);
	cs_phase_in();
end

script command_script cs_e6_m5_pawn_spawn
	print ("pawns phase in");
	sleep_rand_s (0.1, 0.5);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end


//script command_script cs_e8_m1_drop_pod
//	sleep_s (5);
//	ai_set_objective (ai_current_squad, obj_8_m1_survival);
//end

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

// ===================================================================================
//===========TURRETS=======================================
// ===================================================================================




// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

script static void f_start_player_intro_e6_m5
	//firefight_mode_set_player_spawn_suppressed(true);
//	if editor_mode() then
//		print ("editor mode, no intro playing");
//		//sleep_s(1);
//				
//		//f_e3_m2_intro_vignette();
//		
//	else
//		print ("NOT editor mode play the intro");
//		//wait for pick your loadout screen to be done
//		//sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		sleep_until (f_spops_mission_ready_complete, 1);
//		//intro();
//		f_e6_m5_intro_vignette();
//				
//	end
	
	sleep_until (f_spops_mission_ready_complete(), 1);
		//intro();
	f_e6_m5_intro_vignette();
	
	f_spops_mission_intro_complete( TRUE );
	
	//when the intro is done switch zone sets and spawn the player
	//switch_zone_set (e3_m2);
	//print ("zone set switched");
	//firefight_mode_set_player_spawn_suppressed(false);
	

	//sleep_until (b_players_are_alive(), 1);
	//print ("player is alive");
	
//	sleep_s (0.5);
//	fade_in (0,0,0,15);

	
end

script static void f_e6_m5_intro_vignette
	//set up, play and clean up the intro
	print ("playing intro");
	//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1);
	
	ai_enter_limbo (gr_e6_m5_ff_all);
	pup_disable_splitscreen (true);
	
	b_e6_m5_wait_for_narrative = true;
 // pup_play_show(pup_e3_m2_in);
 // e3m2_vo_intro();
	
	//replace this with the narrative puppet show
	f_e6_m5_narrative_done();
	sleep_until (b_e6_m5_wait_for_narrative == false);
	
	pup_disable_splitscreen (false);
	ai_exit_limbo (gr_e6_m5_ff_all);
	print ("all ai exiting limbo after the puppeteer");
end

//tells the script when the narrative is done -- called from within puppeteer
script static void f_e6_m5_narrative_done
	print ("narrative done");
	b_e6_m5_wait_for_narrative = false;

end

// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================