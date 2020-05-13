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

global boolean b_wait_for_narrative = false;


script startup e8_m1_hillside_retake

	//dprint( "breach_e6_m5 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m1") ) then
		wake( e8_m1_hillside_init );
	end

end

script dormant e8_m1_hillside_init

	//Start the intro
//	sleep_until (LevelEventStatus("e8_m1"), 1);
	print ("******************STARTING e8_m1*********************");
//	
//	//switch to the appropriate zone set
//	switch_zone_set (e8_m1);
////	mission_is_e3_m2 = true;
////	b_wait_for_narrative = true;
//
////suppress the player from spawning during loadout selection and intro vignette
//	firefight_mode_set_player_spawn_suppressed(true);
//
////set the global "bad guy AI" variable that is used to track wave spawning and auto blips
//	ai_ff_all = gr_e8_m1_ff_all;
//	//b_wait_for_narrative = true;

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e8_m1", e8_m1, gr_e8_m1_ff_all, e8_m1_spawn_points_0, 90 );
	

	thread(f_start_player_intro_e8_m1());

//start the first starting event
	thread (f_start_events_e8_m1_1());
	print ("starting e3_m2_1");

//start all the rest of the event scripts
	thread (f_start_all_events_e8_m1());

//music cue
	


//======== OBJECTS ==================================================================

//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	f_add_crate_folder(cr_e8_m1_objectives); //UNSC crates and barriers around the main spawn area
	f_add_crate_folder(cr_e8_m1_cov_cover); //UNSC crates and barriers around the main spawn area
	f_add_crate_folder(cr_e8_m1_weapon_racks);
	f_add_crate_folder(cr_e8_m1_fixed_cover);
	
	f_add_crate_folder(dc_e8_m1);
	
	f_add_crate_folder(eq_e8_m1_unsc_ammo);

// puts spawn point folders into an index that is used to automatically turn on/off spawn points and used by designers to override current spawn folders
//set spawn folder names
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_3, 93);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_4, 94);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_5, 95);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_6, 96);
	
//puts certain objects into an index that is used to track objectives set in the player goals in the variant tag
//set objective names
	
	firefight_mode_set_objective_name_at(dc_e8_m1_switch1,	1); //computer terminal in the close side building
	firefight_mode_set_objective_name_at(dc_e8_m1_switch2,	2); //computer terminal in the left side building
	firefight_mode_set_objective_name_at(dc_e8_m1_switch3,	3); //computer terminal in the far right side building
	firefight_mode_set_objective_name_at(dc_e8_m1_mark,			4);
	firefight_mode_set_objective_name_at(dc_e8_m1_mark2,		5);
	firefight_mode_set_objective_name_at(dc_e8_m1_mark3,		6);
//	firefight_mode_set_objective_name_at(turret_switch_0, 10); //turret switch
//	firefight_mode_set_objective_name_at(turret_switch_1, 11); //turret switch	

//set LZ (location arrival) spots			
	firefight_mode_set_objective_name_at(area_1, 51); //objective in the main spawn area
//	firefight_mode_set_objective_name_at(e3_m2_lz_1, 51); //objective in the middle front building
	firefight_mode_set_objective_name_at(area_2, 52); //objective in the middle back building
	firefight_mode_set_objective_name_at(area_3, 53); //objective in the left back area
	firefight_mode_set_objective_name_at(area_4, 54); //objective in the right in the way back
	firefight_mode_set_objective_name_at(area_5, 55); //objective in the back on the forerunner structure
	firefight_mode_set_objective_name_at(area_6, 56); //objective in the back on the smooth platform
	firefight_mode_set_objective_name_at(area_7, 57); //objective right by the tunnel entrance
	
//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
//set squad group names
	//guards
	firefight_mode_set_squad_at(sq_e8_m1_guards_1, 1);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(sq_e8_m1_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(sq_e8_m1_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(sq_e8_m1_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(sq_e8_m1_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(sq_e8_m1_guards_8, 8); //on the bridge
//	firefight_mode_set_squad_at(gr_e3_m2_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_e3_m2_allies_2, 10); //back middle building
//	firefight_mode_set_squad_at(sq_e3_m2_hunters_grunts, 11); //back middle building

	//shades
	firefight_mode_set_squad_at(sq_e8_m1_shades_1, 31);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_shades_2, 32);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_ghosts_1, 33);	//left building	
	firefight_mode_set_squad_at(sq_e8_m1_ghosts_2, 34);	//left building		

//	//phantoms
	firefight_mode_set_squad_at(sq_e8_m1_phantom_1, 21); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_02, 22); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_03, 23); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_04, 24); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_1, 31); //phantoms 
//	firefight_mode_set_squad_at(sq_e3_m2_phantom_attack_2, 32); //phantoms 
//	
	//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sq_e8_m1_waves_1, 81);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_waves_2, 82);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_3, 83);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_4, 84);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_5, 85);	//front by the main start area	


	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	

end



// ==============================================================================================================
//====== START SCRIPTS ===============================================================================
// ==============================================================================================================


//start all the scripts that get kicked off at the beginning and end of player goals and all scripts that are required to start at the beginning of the mission
script static void f_start_all_events_e8_m1
	
//start all the event scripts	
	thread (f_end_events_e8_m1_1());
	print ("ending e8_m1_1");
	
	thread (f_start_events_e8_m1_waves());
	print ("starting e3_m2_waves");
	
	thread (f_start_events_e8_m1_mark());
	print ("starting e3_m2_1");
	
	thread (f_start_events_e8_m1_3());
	print ("starting e3_m2_3");
	
	thread (f_end_events_e8_m1_3());
	print ("ending e8_m1_3");
	
	thread (f_start_events_e8_m1_4());
	print ("starting e3_m2_4");
	
	thread (f_end_events_e8_m1_4());
	print ("ending e8_m1_4");
	
	thread (f_start_events_e8_m1_5());
	print ("starting e3_m2_5");
	
	thread (f_end_events_e8_m1_5());
	print ("ending e8_m1_5");
	
	thread (f_start_events_e8_m1_boss());
	print ("ending e8_m1_boss");
	
	thread (f_end_events_e8_m1_boss());
	print ("ending e8_m1_boss");
	
	thread (f_start_events_e8_m1_6());
	print ("starting e8_m1_6");
	
	thread (f_end_events_e8_m1_6());
	print ("end e8_m1_6");
	
	thread (f_start_events_e8_m1_7());
	print ("starting e8_m1_7");
	
	thread (f_end_events_e8_m1_7());
	print ("ending e8_m1_7");

	thread (f_start_events_e8_m1_8());
	print ("starting e8_m1_8");
	
	thread (f_end_events_e8_m1_8());
	print ("ending e8_m1_7");
	
	thread (f_start_events_e8_m1_9());
	print ("starting e8_m1_9");

end

//====== MISC SCRIPTS ===============================================================================

// miscellaneous or helper scripts

script static void f_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

//========STARTING E8 M1==============================
// here's where the scripts that control the mission go linearly and chronologically

script static void f_start_events_e8_m1_1
	sleep_until (LevelEventStatus("start_e8_m1_1"), 1);
	print ("STARTING 1");

	
	b_wait_for_narrative_hud = true;
	
	sleep_until( f_spops_mission_start_complete(), 1 );
//	sleep_until (b_players_are_alive(), 1);
	
	//create some objective props
	thread (f_e8_m1_props());

	sleep_s (0.5);
	fade_in (0,0,0,15);

	f_new_objective (ch_8_1_1);
	cinematic_set_title (ch_8_1_1);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	
end

script static void f_e8_m1_props
	print ("creating props");
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal1);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal2);
	effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal3);

end

//
script static void f_end_events_e8_m1_1
	sleep_until (LevelEventStatus("end_e8_m1_1"), 1);
	print ("goal 1 ended");
	
end

script static void f_start_events_e8_m1_waves
	sleep_until (LevelEventStatus("start_e8_m1_waves"), 1);
	print ("STARTING waves");
	
	vo_glo_cleararea_03();
	f_new_objective (ch_8_1_waves);
	cinematic_set_title (ch_8_1_waves);
end

script static void f_start_events_e8_m1_mark
	sleep_until (LevelEventStatus("start_e8_m1_mark"), 1);
	print ("STARTING mark");
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_8_1_mark);
	cinematic_set_title (ch_8_1_mark);
	//add vo here
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark, 1);

end

//explosion, shake and destruction of rock blockers by the cave
script static void f_explode_rock
	print ("shake start");
	
	cinematic_set_title (ch_8_1_run);
	
	sleep_s (3);
	
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	
	sleep(38);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e8_m1_rock);
	//effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', fl_e8_m1_rock);
	print ("EXPLOSION");
	object_destroy (cr_e8_m1_rock1);
	object_destroy (cr_e8_m1_rock2);
	print ("rocks destroyed");
end


script static void f_start_events_e8_m1_3
	sleep_until (LevelEventStatus("start_e8_m1_3"), 1);
	print ("STARTING 3");
	
	b_wait_for_narrative_hud = true;
	
	//turn off switch power
	device_set_power (dc_e8_m1_mark, 0);
	
	//explode the rock barrier and shake
	f_explode_rock();
	
	f_new_objective (ch_8_1_2);
	cinematic_set_title (ch_8_1_2);
	
	//add vo here
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_switch1, 1);
	
end

script static void f_end_events_e8_m1_3
	sleep_until (LevelEventStatus("end_e8_m1_3"), 1);
	print ("goal 3 ended");
	
	device_set_power (dc_e8_m1_switch1, 0);
	
	//turn off the portal
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	
	
	f_e8_m1_camo_portal();
	
	sleep(38);
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal1);
	
end

script static void f_e8_m1_camo_portal
	print ("camo portal enemies spawn");
	ai_place (sq_e8_m1_portal);
	sleep_until (ai_living_count (sq_e8_m1_portal) > 0, 1);
	ai_set_active_camo (sq_e8_m1_portal.camo, true);
end

script static void f_start_events_e8_m1_4
	sleep_until (LevelEventStatus("start_e8_m1_4"), 1);
	print ("STARTING 4");
	
	//start the jumper logic
	thread (f_e8_m1_jumpers());
	
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_8_1_3);
	cinematic_set_title (ch_8_1_3);
	
	//add vo here
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_switch2, 1);

	//make this obvious to the player
	f_e8_m1_portal_jump (sq_e8_m1_portal2.1, fl_e8_m1_portal2);
end

script static void f_end_events_e8_m1_4
	sleep_until (LevelEventStatus("end_e8_m1_4"), 1);
	print ("goal 4 ended");
	
	device_set_power (dc_e8_m1_switch2, 0);
	
	//turn off the portal
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	
	sleep(38);
	
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal2);
	
end

script static void f_start_events_e8_m1_5
	sleep_until (LevelEventStatus("start_e8_m1_5"), 1);
	print ("STARTING 5");
		
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_8_1_4);
	cinematic_set_title (ch_8_1_4);
	
	//add vo here
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_switch3, 1);

	//make this obvious to the player
	f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
end

script static void f_end_events_e8_m1_5
	sleep_until (LevelEventStatus("end_e8_m1_5"), 1);
	print ("goal 5 ended");
	
	device_set_power (dc_e8_m1_switch3, 0);
	
	//turn off the portal
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	
	sleep(38);
	
	effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e8_m1_portal3);
	
end

global ai ai_e8_m1_boss = none;

script static void f_start_events_e8_m1_boss
	sleep_until (LevelEventStatus("start_e8_m1_boss"), 1);
	print ("STARTING BOSS");
	
	ai_e8_m1_boss = sq_e8_m1_wraith;
	
	sleep_until (ai_living_count (ai_e8_m1_boss) > 0, 1);
	
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_8_1_boss);
	cinematic_set_title (ch_8_1_boss);
	
	//add vo here
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	//vo about boss goes here
	f_blip_ai_cui (ai_e8_m1_boss, "navpoint_enemy");
	
	sleep_until (ai_living_count (ai_e8_m1_boss) == 0, 1);
	
	//cinematic_set_title (ch_8_1_good);
	
	b_end_player_goal = true;
	
end

script static void f_end_events_e8_m1_boss
	sleep_until (LevelEventStatus("end_e8_m1_boss"), 1);
	print ("ENDING BOSS");

end

script static void f_start_events_e8_m1_6
	sleep_until (LevelEventStatus("start_e8_m1_6"), 1);
	print ("STARTING 6");
	
	b_wait_for_narrative_hud = true;
	f_new_objective (ch_8_1_mark3);
	cinematic_set_title (ch_8_1_mark3);
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark2, 1);
end

script static void f_end_events_e8_m1_6
	sleep_until (LevelEventStatus("end_e8_m1_6"), 1);
	print ("goal 6 ended");
	
	device_set_power (dc_e8_m1_mark2, 0);
	
	
	
end

script static void f_start_events_e8_m1_7
	sleep_until (LevelEventStatus("start_e8_m1_7"), 1);
	print ("STARTING 7");
	
	b_wait_for_narrative_hud = true;
	
	cinematic_set_title (ch_8_1_5);
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark3, 1);
end

script static void f_end_events_e8_m1_7
	sleep_until (LevelEventStatus("end_e8_m1_7"), 1);
	print ("e8_m1_7");
//	
//	b_end_player_goal = true;
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//
//	sleep_s (1);
//	fade_out (0,0,0,60);
	
end



script static void f_start_events_e8_m1_8
	sleep_until (LevelEventStatus("start_e8_m1_8"), 1);
	print ("STARTING 8");
	
	b_wait_for_narrative_hud = true;
	
	vo_glo_cleararea_03();
	
	f_new_objective (ch_8_1_6);
	cinematic_set_title (ch_8_1_6);
	sleep_s (4);
	
	b_wait_for_narrative_hud = false;

end


script static void f_end_events_e8_m1_8
	sleep_until (LevelEventStatus("end_e8_m1_8"), 1);
	print ("e8_m1_8 no more waves ended");
//	
//	b_end_player_goal = true;
//	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
//
//	sleep_s (1);
//	fade_out (0,0,0,60);
	
end

script static void f_start_events_e8_m1_9
	sleep_until (LevelEventStatus("start_e8_m1_9"), 1);
	
	cinematic_set_title (ch_8_1_good);
	
	sleep_s (5);
	
	print ("mission ended");
	
	b_end_player_goal = true;
	
	f_end_mission();

		
end

//
//
//script static void f_start_events_e3_m2_2
//	sleep_until (LevelEventStatus("start_e3_m2_2"), 1);
//	print ("STARTING start_e3_m2_turrets");

//	
//end
//

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




//=======ENDING E8 M1==============================




// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//ai command scripts

script static void f_e8_m1_wraith
	print ("spawn wraith");
	ai_place_in_limbo  (sq_e8_m1_wraith);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e8_m1_wraith.driver));
	ai_exit_limbo (sq_e8_m1_wraith);
end

// PHANTOM 01 =================================================================================================== 
script command_script cs_e8_m1_phantom_01()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	sleep (1);
	
	//sleep_s (2);
	
	//f_e8_m1_wraith();
	
	print ("spawn wraith");
//	ai_place_in_limbo  (sq_e8_m1_wraith);
	ai_place (sq_e8_m1_wraith);
	ai_braindead (sq_e8_m1_wraith, true);
//	sleep (2);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e8_m1_wraith.driver));
	
//	sleep (2);
//	
//	ai_exit_limbo (sq_e8_m1_wraith);
	
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	//ai_set_blind (ai_current_squad, TRUE);
	cs_enable_targeting (true);
	cs_fly_by (ps_phantom_1.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_phantom_1.p1);
//		(print "flew by point 1")
	cs_fly_to (ps_phantom_1.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 3);

		// ======== DROP DUDES HERE ======================
	
	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc");
//	ai_set_objective (sq_e8_m1_phantom_1, obj_e8_m1_wraith);
	ai_braindead (sq_e8_m1_wraith, false);
	f_unload_phantom (ai_current_actor, "dual");
	
			
		// ======== DROP DUDES HERE ======================
		
	print ("phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_phantom_1.p3);
	cs_fly_to (ps_phantom_1.p4);
	cs_fly_to (ps_phantom_1.erase);
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
end
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
//====== DROP POD AND TELEPORT SCRIPTS ===============================================================================
// ==============================================================================================================

script static void test
	print ("test");
	f_e8_m1_portal_jump (sq_e8_m1_portal2.1, fl_e8_m1_portal2);
	f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
end

//this script controls the when the elites jump out of the portals
script static void f_e8_m1_jumpers
	print ("Starting jumpers script");
	
	//might want to start this script early so would need better logic
	
	//sleep until the ai are low enough then spawn the elite to jump out of the portal, if the switch is flipped first, don't spawn the elite.
	sleep_until (ai_living_count (sq_e8_m1_guards_6) > 3);
	sleep_until (ai_living_count (sq_e8_m1_guards_6) < 3 or device_get_position (dc_e8_m1_switch2) > 0, 1);
	print ("jumper 1 ready to be spawned, waiting until less 19 enemies");
	
	sleep_until (ai_living_count (ai_ff_all) < 19, 1);
	print ("less than 19 enemies, spawn jumped unless portal 2 is shut down");
	
	if device_get_position (dc_e8_m1_switch2) > 0 then
		print ("portal2 is turned off before the jumper is ready to spawn, don't spawn the elite jumper");
	else
		f_e8_m1_portal_jump (sq_e8_m1_portal2.1, fl_e8_m1_portal2);
	end
	
	//sleep until the ai are low enough then spawn the elite to jump out of the portal, if the switch is flipped first, don't spawn the elite.
	sleep_until (ai_living_count (sq_e8_m1_guards_8) > 3);
	sleep_until (ai_living_count (sq_e8_m1_guards_8) < 3 or device_get_position (dc_e8_m1_switch3) > 0, 1);
	print ("jumper 2 ready to be spawned, waiting until less 19 enemies");
	
	sleep_until (ai_living_count (ai_ff_all) < 19, 1);
	print ("less than 19 enemies, spawn jumped unless portal 3 is shut down");
	
	if device_get_position (dc_e8_m1_switch2) > 0 then
		print ("portal3 is turned off before the jumper is ready to spawn, don't spawn the elite jumper");
	else
		f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
	end

end

script static void f_e8_m1_portal_jump (ai jumper, cutscene_flag portal)
	print ("AI teleporting from portal");
	ai_place_in_limbo (jumper);
	
	//ai_place (sq_e8_m1_portal2.1);
	
	//sleep_s (1);
	
	//ai_braindead (jumper, true);
	object_teleport (jumper, portal);
	object_set_scale (jumper, 0.1, 1);
	
	ai_exit_limbo (jumper);
	
	sleep (10);
	
	object_set_velocity (jumper, 5, 0, 3);
	
	object_set_scale (jumper, 1.0, 60);

end


script command_script cs_e8_m1_drop_pod
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_8_m1_survival);
end

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

script static void f_start_player_intro_e8_m1
	
	sleep_until (f_spops_mission_ready_complete(), 1);
		//intro();
	f_e8_m1_intro_vignette();
	
	f_spops_mission_intro_complete( TRUE );
	//firefight_mode_set_player_spawn_suppressed(true);
//	if editor_mode() then
//		print ("editor mode, no intro playing");
//		sleep_s(1);
//				
//		//f_e3_m2_intro_vignette();
//		
//	else
//		print ("NOT editor mode play the intro");
//		//wait for pick your loadout screen to be done
//		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
//		
//		//intro();
//		f_e8_m1_intro_vignette();
//				
//	end
//	
//	//when the intro is done switch zone sets and spawn the player
//	//switch_zone_set (e3_m2);
//	//print ("zone set switched");
//	firefight_mode_set_player_spawn_suppressed(false);
//	
//
//	sleep_until (b_players_are_alive(), 1);
//	print ("player is alive");
	


	
end

script static void f_e8_m1_intro_vignette
	//set up, play and clean up the intro
	print ("playing intro");
	//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1);
	
	ai_enter_limbo (gr_e8_m1_ff_all);
	pup_disable_splitscreen (true);
	
	b_wait_for_narrative = true;
 // pup_play_show(pup_e3_m2_in);
 // e3m2_vo_intro();
	
	//replace this with the narrative puppet show
	f_narrative_done();
//	sleep_until (b_wait_for_narrative == false);
	
	pup_disable_splitscreen (false);
	ai_exit_limbo (gr_e8_m1_ff_all);
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