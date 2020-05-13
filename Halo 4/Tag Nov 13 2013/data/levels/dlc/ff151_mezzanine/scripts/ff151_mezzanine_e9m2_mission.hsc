// =============================================================================================================================
// ============================================ E9M2 MEZZANINE MISISON SCRIPT ==================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

// ============================================	STARTUP SCRIPT	========================================================

script startup e9m2_mezzanine_startup

	print( "mezzanine_e9_m2 startup" );
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e9_m2") ) then
		wake( mezzanine_e9_m2_init );
	end

end

script dormant mezzanine_e9_m2_init
//	sleep_until (LevelEventStatus ("e9m2_var_startup"), 1);

	print ("************STARTING E9 M2*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e9_m2", e9m2_main, gr_e9m2_ff_all, sc_e9_m2_spawnpoints_0, 90 );
	
	//start the intro thread
	thread(f_start_player_intro_e9_m2());
	print ("starting player intro");

	//start the first starting event
	thread (f_start_events_e9_m2_1());
	print ("starting e9_m2_1");

	//start all the rest of the event scripts
	thread (f_start_all_events_e9_m2());
	print ("starting e9_m2 all events thread");

//======== OBJECTS ==================================================================


//	//	//	//	FOLDER SPAWNING	\\	\\	\\
//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	//f_add_crate_folder(sc_e9_m2_objectives); 
	f_add_crate_folder(cr_e9_m2_cov_cover); 
	f_add_crate_folder(cr_e9_m2_objectives); 
	f_add_crate_folder(eq_e9_m2_unsc_ammo); 
	f_add_crate_folder(cr_e9_m2_cov_ammo); 
	f_add_crate_folder(cr_e9_m2_unsc_ammo); 
	f_add_crate_folder(cr_e9_m2_oni);
	
	//set spawn folder names
	firefight_mode_set_crate_folder_at(sc_e9_m2_spawnpoints_0, 90); //spawns in the main starting area


//set objective names
	
	firefight_mode_set_objective_name_at(dc_e9_m2_map1,			1); //iff tag 1
	firefight_mode_set_objective_name_at(dc_e9_m2_map2,			2); //iff tag 2
	firefight_mode_set_objective_name_at(dc_e9_m2_map3,			3); //iff tag 3

	firefight_mode_set_objective_name_at(sc_e9_m2_lz1,			11); //iff tag 3	
	


//==== DECLARE AI ====
//puts AI squads and groups into an index used by the variant tag to spawn in AI automatically
//set squad group names
//guards
	firefight_mode_set_squad_at(sq_e9_m2_guards1, 1);	//left building
	firefight_mode_set_squad_at(sq_e9_m2_guards2, 2);	//front by the main start area
	firefight_mode_set_squad_at(sq_e9_m2_guards3, 3);	//back middle building
//	firefight_mode_set_squad_at(sq_e9_m2_guards4, 4); //in the main start area
//	firefight_mode_set_squad_at(sq_e9_m2_guards5, 5); //right side in the back
//	firefight_mode_set_squad_at(sq_e9_m2_guards6, 6); //right side in the back at the back structure
//	firefight_mode_set_squad_at(sq_e9_m2_guards7, 7); //middle building at the front
//	firefight_mode_set_squad_at(sq_e9_m2_guards8, 8); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_hunters, 30);	//back middle building

		
	//forerunner guards
	firefight_mode_set_squad_at(sq_e9_m2_fore_guards1, 31); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_fore_guards2, 32); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_fore_guards2, 32); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_fore_guards3, 33); //on the bridge
	firefight_mode_set_squad_at(sq_e9_m2_fore_guards4, 34); //on the bridge

//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sq_e9_m2_waves1, 81);
	firefight_mode_set_squad_at(sq_e9_m2_waves2, 82);
	firefight_mode_set_squad_at(sq_e9_m2_waves3, 83);
	firefight_mode_set_squad_at(sq_e9_m2_waves4, 84);	
	
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );
	
end

//thread out all the start and end event watchers
script static void f_start_all_events_e9_m2
	
//start all the event scripts	
	print ("starting all events");

	thread (f_start_events_e9_m2_2());
	print ("starting e9_m2_2");
	
	thread (f_start_events_e9_m2_3());
	print ("starting e9_m2_3");

	thread (f_start_events_e9_m2_4());
	print ("starting e9_m2_4");
	
	thread (f_start_events_e9_m2_5());
	print ("starting e9_m2_5");
	
	thread (f_start_events_e9_m2_6());
	print ("starting e9_m2_6");

	thread (f_start_events_e9_m2_7());
	print ("starting e9_m2_7");
	
//	thread (f_end_events_e9_m2_6());
//	print ("ending e9_m2_6");

	thread (f_start_events_e9_m2_8());
	print ("starting e9_m2_8");
	
	thread (f_start_events_e9_m2_9());
	print ("starting e9_m2_9");
		
end


//========STARTING E9 M2==============================
// here's where the scripts that control the mission go linearly and chronologically


//===== DODGE HUNTERS, CLEAR THEM OUT
//players spawn and must dodge the hunters and take out the initial guards
script static void f_start_events_e9_m2_1
	sleep_until (LevelEventStatus("start_e9_m2_1"), 1);
	print ("starting e9_m2_1");

	
	b_wait_for_narrative_hud = true;
	
	//sleep until intro is done
	sleep_until( f_spops_mission_start_complete(), 1 );
	//sleep_until (b_players_are_alive(), 1);
	
	thread (f_map_watch_e9_m2 (dc_e9_m2_map1, cr_e9_m2_map1, fl_e9_m2_map1, 90));
	thread (f_map_watch_e9_m2 (dc_e9_m2_map2, cr_e9_m2_map2, fl_e9_m2_map2, 90));
	//thread (f_e9_m2_start_guards());
	
	sleep_s (0.5);
	fade_in (0,0,0,15);

	f_new_objective (ch_9_2_1);
	cinematic_set_title (ch_9_2_1);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

	
end


//========= TAKE DOWN THE 1st AND 2nd TERMINAL=========
script static void f_start_events_e9_m2_2
	sleep_until (LevelEventStatus("start_e9_m2_2"), 1);
	print ("starting e9_m2_2");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_2);
	cinematic_set_title (ch_9_2_2);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e9_m2_map1, 1);
	device_set_power (dc_e9_m2_map2, 2);

end


//========= GET TO THE THIRD TERMINAL =========
script static void f_start_events_e9_m2_3
	sleep_until (LevelEventStatus("start_e9_m2_3"), 1);
	print ("starting e9_m2_3");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_3);
	cinematic_set_title (ch_9_2_3);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

	
end


//======= KILL THE REMAINING COVENANT =========
script static void f_start_events_e9_m2_4
	sleep_until (LevelEventStatus("start_e9_m2_4"), 1);
	print ("starting e9_m2_4");

	
	b_wait_for_narrative_hud = true;
	
	if ai_living_count (ai_ff_all) > 0 then
		print ("some enemies are alive, blipping them and telling player to kill them");
		f_new_objective (ch_9_2_defeat);
		cinematic_set_title (ch_9_2_defeat);

		sleep_s (3);
		b_wait_for_narrative_hud = false;
	else
		print ("all the enemies are dead, moving to next goal");
	end

end


//======= KILL THE SURPRISE FORERUNNERS =========
//switch zone sets
script static void f_start_events_e9_m2_5
	sleep_until (LevelEventStatus("start_e9_m2_5"), 1);
	print ("starting e9_m2_5");

	//preparing to switch zone set, look for bad popping
	print ("preparing to switch zone set");
	prepare_to_switch_to_zone_set (e9m2_fore);
	
	//CHANGING THE ZONE SET TO SUPPORT FORERUNNERS
	print ("sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	print ("switching zone set");
	switch_zone_set (e9m2_fore);
	current_zone_set_fully_active();

	b_end_player_goal = true;

end

//defeat the forerunners
script static void f_start_events_e9_m2_6
	sleep_until (LevelEventStatus("start_e9_m2_6"), 1);
	print ("starting e9_m2_6");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_4);
	cinematic_set_title (ch_9_2_4);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

end

//blow the last map terminal
script static void f_start_events_e9_m2_7
	sleep_until (LevelEventStatus("start_e9_m2_7"), 1);
	print ("starting e9_m2_7");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_5);
	cinematic_set_title (ch_9_2_5);

	sleep_s (3);
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e9_m2_map3, 3);

end

//get to the rally point -- BIG EXPLOSIONS
script static void f_start_events_e9_m2_8
	sleep_until (LevelEventStatus("start_e9_m2_8"), 1);
	print ("starting e9_m2_8");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_6);
	cinematic_set_title (ch_9_2_run);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

	sleep_s (3);
	//tell players to get OUT of the WAY!!
	cinematic_set_title (ch_9_2_6);
	
	//sleep for a bit then call the explosions
	sleep_s (5);

	//explosions
	f_e9_m2_final_explosions();
end

//end of mission
script static void f_start_events_e9_m2_9
	sleep_until (LevelEventStatus("start_e9_m2_9"), 1);
	print ("starting e9_m2_9");

	
	b_wait_for_narrative_hud = true;
	
	f_new_objective (ch_9_2_7);
	cinematic_set_title (ch_9_2_7);

	sleep_s (3);
	b_wait_for_narrative_hud = false;

	b_end_player_goal = true;
end

script static void f_end_events_e9_m2_9
	sleep_until (LevelEventStatus("end_e9_m2_9"), 1);
	print ("end e9_m2_9");
	f_end_mission();
end
	
// ======= END OF MISSION SCRIPTS =========


//====== MISC SCRIPTS =====================

script static void f_end_mission
	print ("ending the mission with fadeout and chapter complete");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

//	sleep_until (object_valid (switch) and object_valid (map), 1);
//	print ("both objects valid in f_power_map_watch_e3_m2");

global short s_map_exploded = 0;

script static void f_map_watch_e9_m2 (device_name switch, object_name map, cutscene_flag flag, short spawn_folder)
	//waits until the switch is flipped then damages the map 1/3 at a time so the players can see the damage states of the map
	print ("map watch thread started");

	object_cannot_take_damage (map);
	
	sleep_until (device_get_position (switch) > 0, 1);
	print ("map explodes in 3 seconds!");

//create a new spawn folder at the location of the map
	if firefight_mode_goal_get() == 1 then
		f_create_new_spawn_folder (spawn_folder);
	end
	
	//start beeping countdown
	sleep_s (3);

	//call effects
	effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag); 

	object_destroy (map);
	
	s_map_exploded = s_map_exploded + 1;

end

//global boolean b_done_with_map_VO = false;
//
//script static void f_e3_m2_objective_vo
//	print ("objective vo started");
//	
//	//sleep until the first objective is done, then play VO
//	sleep_until (s_map_exploded == 1, 1);
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target1down_vo());
//	e3m2_vo_target1down();
//	
//	//sleep until another map is exploded, if the third one is exploded by the time this hits then skip the second one and only play the third one
//	sleep_until (s_map_exploded > 1, 1);
//	
//	if s_map_exploded == 2 then
//		print ("playing second map exploded");
//		sleep_s (1);
//		thread(f_music_e3m2_objective_target2down_vo());
//		e3m2_vo_target2down();
//	end
//	
//	sleep_until (s_map_exploded == 3, 1);
//	
//	sleep_s (1);
//	thread(f_music_e3m2_objective_target3down_vo());
//	e3m2_vo_target3down();
//	b_done_with_map_VO = true;
//
//end

//final explosions are called randomly
script static void f_e9_m2_final_explosions
	print ("final explosions!");
	begin_random
		f_e9_m2_explosion (fl_e9_m2_exp1);
		f_e9_m2_explosion (fl_e9_m2_exp2);
		f_e9_m2_explosion (fl_e9_m2_exp3);
		f_e9_m2_explosion (fl_e9_m2_exp4);
		f_e9_m2_explosion (fl_e9_m2_exp5);
		f_e9_m2_explosion (fl_e9_m2_exp6);
		f_e9_m2_explosion (fl_e9_m2_exp7);
		f_e9_m2_explosion (fl_e9_m2_exp8);
		f_e9_m2_explosion (fl_e9_m2_exp9);
		f_e9_m2_explosion (fl_e9_m2_exp10);
	end
end

script static void f_e9_m2_explosion (cutscene_flag flag)
	//pause for a random time then call bif explosion FX and Damage
	inspect (flag);
	sleep_s (real_random_range (0.2, 0.6));
	print ("explosion");
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag); 
end
// ==============================================================================================================
//====== COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

script command_script cs_e9_m2_hunters
	print ("hunter command script started");
	
	//this will probably need to be a puppeteer
	//shoot at point for 3 seconds, then jump down and fight normal
	//cs_aim (true, ps_e9_m2_hunter.p0);
	//sleep_s (3);
	//cs_aim (false, ps_e9_m2_hunter.p0);
	//cs_approach_player (2, 20, 200);
	//sleep_s (10);
	//cs_approach_stop ();
end

// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

global boolean b_e9_m2_wait_for_narrative = false;

script static void f_start_player_intro_e9_m2
	
	sleep_until (f_spops_mission_ready_complete(), 1);
		//intro();
	f_e9_m2_intro_vignette();
	
	f_spops_mission_intro_complete( TRUE );
	

	
end

script static void f_e9_m2_intro_vignette
	//set up, play the intro and clean up
	print ("playing intro");
		
	ai_enter_limbo (gr_e9m2_ff_all);
	pup_disable_splitscreen (true);
	
	b_e9_m2_wait_for_narrative = true;
	
	//replace this with the narrative puppet show
	// pup_play_show(pup_e3_m2_in);
	// e3m2_vo_intro();
		
	f_e9_m2_narrative_done();
	sleep_until (b_e9_m2_wait_for_narrative == false);
	
	pup_disable_splitscreen (false);
	ai_exit_limbo (gr_e9m2_ff_all);
	print ("all ai exiting limbo after the puppeteer");
end

//tells the script when the narrative is done -- called from within puppeteer
script static void f_e9_m2_narrative_done
	print ("narrative done");
	b_e9_m2_wait_for_narrative = false;

end
