//===================================================================================================
//==== FORERUNNER STRUCTURE E9_m4 FIREFIGHT SCRIPT ==================================================
//===================================================================================================
global boolean b_e9_m4_pelican_flyaway = FALSE;
global boolean b_itsOn = FALSE;
global boolean b_navpointOn = FALSE;
global boolean b_playersTouchedDonut = FALSE;
global boolean b_indonut = FALSE;
global boolean b_ingarden = FALSE;
global boolean b_marinesgardenprep = FALSE;
global boolean b_timetodrive = FALSE;
global long l_wraithcount = 3;
global short s_e9_m4_phantom_6_loadstate = 0;
global short s_e9_m4_phantom_7_loadstate = 0;
global short s_e9_m4_phantom_8_loadstate = 0;
global boolean b_unloaded_hog = FALSE;
global boolean b_donut_clear = FALSE;
global real r_is_destroyed = 0;
global boolean b_players_initial_pos = TRUE;
global boolean b_front_DZ_blocked = FALSE;
global boolean b_rear_DZ_blocked = FALSE;
global boolean b_BattleHalfwayOver = FALSE;
global boolean b_e9_m4_donut_players_inside = FALSE;
global boolean b_turrets_viable = TRUE;
global boolean b_ghost_away = FALSE;
global boolean b_wraith1deployed = FALSE;
global boolean b_wraith1down = FALSE;
global boolean b_wraith2down = FALSE;
global boolean b_donut_roundup = FALSE;
global boolean b_players_past_door = FALSE;
global boolean b_e9m4_narrative_is_on = FALSE;
global boolean b_hog_replacement_is_running = FALSE;
global boolean b_ill_drive_our_car = FALSE;
global real r_countdowns_in_progress = 0;
global boolean b_callout_was_just_called = FALSE;
global boolean b_center_under_attack = FALSE;
global boolean b_location_arrived = FALSE;
global real r_LevelWideHogHealth = 0;
global boolean b_hog4_placed = FALSE;
global boolean b_hog3_placed = FALSE;
global boolean b_wraith2_actually_stayed_on = FALSE;
global boolean b_end_mission = FALSE;
global boolean b_garden_breached = FALSE;
global boolean b_wraith1_stopshooting = FALSE;
global boolean b_wraith2_stopshooting = FALSE;
global boolean b_players_tooclose_wraith1 = FALSE;
global boolean b_players_tooclose_wraith2 = FALSE;
global boolean b_will_never_be_trueb = FALSE;
global boolean b_e9_m4_mission_over = FALSE;
global boolean b_carry_on_scripts = FALSE;
global boolean b_drive_this_car_now_bool1 = FALSE;
global boolean b_drive_this_car_now_bool2 = FALSE;
global boolean b_drive_this_car_now_bool3 = FALSE;
global boolean b_drive_this_car_now_bool4 = FALSE;
global boolean b_drive_this_car_now_bool5 = FALSE;
global boolean b_drive_this_car_now_bool6 = FALSE;
global boolean b_hogbool1 = FALSE;
global boolean b_hogbool2 = FALSE;
global boolean b_hogbool3 = FALSE;
global boolean b_hogbool4 = FALSE;
global boolean b_hogbool5 = FALSE;
global boolean b_hogbool6 = FALSE;
global boolean b_enter_the_garden_garage_now = FALSE;

script startup dlc01_factory_e9_m4
	if ( f_spops_mission_startup_wait("is_e9_m4") ) then
		wake( f_e9_m4_mission_setup );
	end
end

script dormant f_e9_m4_mission_setup
	//b_wait_for_narrative_hud = true;
	//fade_out (0,0,0,1);
	f_spops_mission_setup("is_e9_m4", e9_m4, gr_e9_m4_ai_all, ff_e9_m4_spawn_0, 99);
	dprint ("*********E9_M4 SCRIPT STARTING - LAST UPDATED DATE*********Dec 7, 2012*********");			
	dm_droppod_1 = e9_m4_drop_pod_1;	
	dm_droppod_2 = e9_m4_drop_pod_2;	
	dm_droppod_3 = e9_m4_drop_pod_3;	
	dm_droppod_4 = e9_m4_drop_pod_4;	
	dm_droppod_5 = e9_m4_drop_pod_5;

	//sleep(30, factory);
	
	
	
	//sleep_until(b_carry_on_scripts == true, 1, factory);
	//sleep_until(b_carry_on_scripts == true, 1, objective_swarm);
	thread(f_e9_m4_mission_intro());									
	thread(f_e9_m4_mission_start());													
//==============================================================================================================================
//==== OBJECTS =================================================================================================================
//==============================================================================================================================
	
	f_add_crate_folder(dm_doors);																					//tjp
	
	f_add_crate_folder(cr_e9_m4_diamond_crates);													//spawn/place the crates
//	f_add_crate_folder(dm_e9_m4_diamond_device_machines);								//tjp
	f_add_crate_folder(eq_e9_m4_ammo);
	firefight_mode_set_crate_folder_at(ff_e9_m4_spawn_0, 99);   					//initial player spawns and player respawns, at end of diamond
	firefight_mode_set_crate_folder_at(ff_e9_m4_spawn_1, 91);   					//player respawns, mid-diamond
	firefight_mode_set_crate_folder_at(ff_e9_m4_spawn_2, 92);   					//player respawns, in donut
	firefight_mode_set_crate_folder_at(ff_e9_m4_spawn_3, 93);   					//player respawns, in garden	
	firefight_mode_set_crate_folder_at(ff_e9_m4_spawn_4, 94);   					//player respawns, in donut, near garden door	
	f_spops_mission_setup_complete( TRUE );
end	

//===============================================================================================
//========= INTRO SCRIPTS =======================================================================
//===============================================================================================
script static void f_e9_m4_mission_intro
	sleep_until(f_spops_mission_ready_complete(), 1);
	
	//print ("Waiting for Loadout");
	//sleep_until (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
	//print ("LOAD OUT SCREEN COMPLETE");
	
	if editor_mode() then
		intro_vignette_e9_m4();	
		f_add_crate_folder(v_e9_m4_diamond_vehicles);															
		sleep(1);								
	else
	//	print ("WAITING FOR LOADOUT SCREEN");
	//	sleep_until (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
	//	print ("LOAD OUT SCREEN COMPLETE");
		//firefight_mode_set_player_spawn_suppressed(true);
		intro_vignette_e9_m4();																	
	end														
	f_spops_mission_intro_complete(true);
	thread(f_music_e09m4_start());
end

script static void intro_vignette_e9_m4
	dprint ("_____________starting vignette__________________");
	pup_disable_splitscreen (true);																					//tjp
	//players_unzoom_all(); 								
	local long show = pup_play_show("e9_m4_intro");													//tjp
	thread(vo_e9m4_narrative_in());					 ////////////////////////////////////////////////////////////////
	// Palmer : Miller, I'm in the field, but you've got this?  ---TO--- Palmer : Good hunting, Crimson. Palmer out.
	sleep_until (not pup_is_playing(show), 1);															//tjp
	pup_disable_splitscreen (false);																				//tjp
	f_add_crate_folder(v_e9_m4_diamond_vehicles);	
end

//===================================================================================================
//======== MISSION START ============================================================================
//===================================================================================================
script static void f_e9_m4_mission_start
//	object_create(sc_never_opens1);																			//tjp
//	object_create(sc_never_opens2);																			//tjp
	sleep_until(LevelEventStatus("e9_m4_spawn_diamond"), 1);
	sleep_until(f_spops_mission_start_complete(), 1);
	ai_exit_limbo(gr_e9_m4_ai_all);
	ai_place(sq_e9_m4_null_pelican_driver_1);
	ai_place(sq_e9_m4_null_pelican_driver_2);
	ai_place(gr_e9_m4_marines_1);	
	ai_place(sq_e9_m4_guards_diamond_turrets);
	ai_place(sq_e9_m4_diamond_laststand);
	ai_place(sq_e9_m4_guards_diamond_mixeda);
	ai_place(sq_e9_m4_guards_diamond_mixedb);
	ai_place(sq_e9_m4_guards_diamond_mixedc);	
	object_create(wp_e9_m4_fr1);
	object_create(wp_e9_m4_fr2);
	b_carry_on_scripts = true;
	//dprint ("Players Spawned!");	
	thread(f_e9_m4_obj1_txt());								
	thread(f_end_mission_e9_m4());								
	thread(f_watch_players_in_diamond());
	thread(f_diamond_playerspawn_monitor());
	thread(LevelWideHogHealth_checker());
	
	
		/*
	thread(f_timetodrive_tally());
	dprint("HOG MANAGING");
thread(f_hog_manager(v_e9_m4_warthog1, b_hogbool1));
//thread(f_hog_manager(v_e9_m4_warthog2, b_hogbool2));*/




	sleep(1);
	fade_in(0,0,0,30);
	player_control_fade_in_all_input(1);		
end																															

script static void f_e9_m4_obj1_txt												
	b_e9_m4_pelican_flyaway = TRUE;		
	//thread(f_e9_m4_phant_callouts());	
	thread(f_e9_m4_droppod_callouts());	
	thread(f_e9_m4_droppods_callouts());
	thread(f_e9_m4_grats_callouts());		
	ai_vehicle_reserve_seat(v_e9_m4_warthog1, warthog_d, true);   // no ai can drive this hog!
	ai_vehicle_reserve_seat(v_e9_m4_warthog2, warthog_d, true);   // no ai can drive this hog!
	thread(f_ai_vehicleobjective_boolean_checker());
	thread(f_ai_vehicleobjective_manager1(v_e9_m4_warthog1));
	thread(f_ai_vehicleobjective_manager2(v_e9_m4_warthog2));
	
	sleep(1);	
	thread(vo_e9m4_secure_area());        //////////////////////////////////////////////
	//Miller : Unleash hell, Crimson. 
	thread(f_music_e09m4_narr_in());
	sleep_s(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
	//navpoint_track_object_named (ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_1.spawn_points_1), false);
	//navpoint_track_object_named (ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_2.spawn_points_0), false);
	thread(f_new_objective(e9_m4_clear_the_diamond));
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 7, 1);
	ai_place_in_limbo(sq_e9_m4_diamond_drop_pod_1);
	notifylevel("VO_droppod");
	sleep(45);	
	thread (f_dlc_load_drop_pod(e9_m4_drop_pod_1, sq_e9_m4_diamond_drop_pod_1, sq_e9_m4_guards_diamond_backup6, drop_pod_lg_01));
	sleep_s(2);
	notifylevel("droppodinc");
	sleep_s(4);
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 8, 1);
	ai_place(sq_e9_m4_null_phantom_driver_6);
	sleep_until (LevelEventStatus("phantunloaded6") or (ai_living_count(sq_e9_m4_null_phantom_driver_6) <= 0), 1);
	b_BattleHalfwayOver = true;		// flag the battle as half over, so we can start looking at player respawn locations and consider possibly changing them to where the action is
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 8, 1);
	ai_place(sq_e9_m4_null_phantom_driver_7);
	sleep_until (LevelEventStatus("phantunloaded7") or (ai_living_count(sq_e9_m4_null_phantom_driver_7) <= 0), 1);
	thread(f_e9_m4_shoot_callout());
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 9, 1);
	ai_place_in_limbo(sq_e9_m4_diamond_drop_pod_2);
	notifylevel("VO_droppod");
	sleep(45);	
	ai_place_in_limbo(sq_e9_m4_guards_diamond_backupC);
	thread(f_dlc_load_drop_pod(e9_m4_drop_pod_2, sq_e9_m4_diamond_drop_pod_2, sq_e9_m4_guards_diamond_backupC, drop_pod_lg_02));
	sleep_s(2);
	notifylevel("droppodinc2");
	sleep_s(4);
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 6, 1);
	thread(f_e9_m4_keep_it_up_callout());
	sleep(1);
	ai_place(sq_e9_m4_null_phantom_driver_8);  	//HUNTERS------------------------------------------------------
	sleep_until (LevelEventStatus("phantunloaded8") or (ai_living_count(sq_e9_m4_null_phantom_driver_8) <= 0), 1);
	if (ai_living_count(sq_e9_m4_null_phantom_driver_8) > 0) then  // if the hunter dropship didnt blow up, call them out
		thread(f_e9_m4_hunter_callouts());
	end
	thread(f_e9_m4_roundup());	
	sleep_s(2);
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 3, 1);
	sleep(45);
	f_add_crate_folder(cr_e9_m4_donut_crates);   //add in the crates in the donut early, so they can start cutting nav
	f_add_crate_folder(sc_e9_m4_doors_scenery);	 //place the doors in the donut
	//f_add_crate_folder(dm_e9_m4_donut_device_machines); //place the doors in the donut
	f_add_crate_folder(v_e9_m4_donut_vehicles);	 //place the vehicles in the donut	
	//thread(f_e9_m4_roundup());	
	notifylevel ("roundup");
	ai_vehicle_exit(gr_e9_m4_ai_all);            // any turret-guys should bail out now, lest they look silly at other side of diamond, on a turret!
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0, 1);
	thread(f_respawn_hog(sq_e9_m4_null_pelican_driver_4, "pelican4unloaded", b_donut_roundup));
	sleep_s(3);
	notifylevel ("grats");
	sleep(1);
	b_e9m4_narrative_is_on = false;
	sleep_s(4);	
	thread(vo_e9m4_surprise());        //////////////////////////////////////////////
	//Miller : Crimson! Movement! 
	thread(f_music_e09m4_surprise());
	sleep_s(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);	
	///////////////////////////////////////////////////////////////////////////////	
	///////////// START GHOST EVENT      WITH 2 GHOST GUYS ////////////////////////
	///////////////////////////////////////////////////////////////////////////////	
	thread(f_e9_m4_opendoor(dm_diamond_main_gate, 3.5));
	ai_place(sq_e9_m4_guards_diamond_ghosts);//1   //first of 2 rushing ghosts! 
	ai_place(sq_e9_m4_guards_donut_mixeda);//6  (initial runners)
	sleep(39);
	ai_place(sq_e9_m4_guards_diamond_ghosts2);//1   //second of 2 rushing ghosts! 
	ai_place(sq_e9_m4_guards_donut_mixedb);//3
	ai_place(sq_e9_m4_guards_donut_mixedc);//3
	ai_place(sq_e9_m4_guards_donut_mixedd);//3	
	thread(vo_e9m4_ghosts());        //////////////////////////////////////////////
	//Miller : Watch out for the Ghosts, Crimson. 
	sleep_s(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
	f_create_new_spawn_folder (92);	 //spawn at door	
	thread(f_playersTouchedDonutCheck());          //players approaching donut in the narrow ramp area?
	thread(f_donut_inside_watcher());             //players physically inside donut?
	thread(f_itsOn_watcher());										//for 2 ghost guys, wait until ghosts are destroyed, or time elapses, fall back into Donut!
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////    DONUT	   ///////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	sleep_s(3);	
	thread(vo_e9m4_clear_donut());        //////////////////////////////////////////////
	//Miller : We're keeping this march going, Crimson. Secure the area.
	sleep_s(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
	thread(f_new_objective(e9_m4_clear_the_donut));												//"CLEAR THE DONUT"
	sleep_s(1);
	//dprint("TIME TO DO CHECK TO SEE IF WE SHOULD CALL IN NEW HOG, THEN DO RESPAWN HOG CHECKS!!!!!!!!!!!!!!!!!");
	//USAGE - f_respawn_hog(ai hogdropPeli, vehicle dropHog, string hogDroppedString, boolean abortBool1, object_name spawnHog, trigger_volume spawnHogTV, boolean abortBool2)

	/*
thread(f_hog_manager(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0), b_hogbool3));
thread(f_respawn_hog_script_manager1());
	*/
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 6, 1);
	ai_place(sq_e9_m4_null_phantom_driver_0);// Drops 5 dudes, 2 ghosts
	sleep_until (LevelEventStatus("phantunloaded0") or (ai_living_count(gr_e9_m4_ai_all) <= 0), 1, 30 * 30);
	thread(Center_Under_Attack());
	b_donut_roundup = true;
	thread(f_marines_garden_prep());
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 5);
	notifylevel("roundup");
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0);	
	kill_script(f_respawn_hog);
	sleep(1);
	thread(f_respawn_hog(sq_e9_m4_null_pelican_driver_3, "pelican3unloaded", b_ingarden));
	sleep(65);
	notifylevel ("grats");
	sleep(1);
	b_e9m4_narrative_is_on = false;
	notifylevel("marinesprep");
	sleep_s(4);
	notifylevel("e9_m4_donut_cleared");
	b_donut_clear = true;
	thread(f_garden_breached_watcher());
	
	/*
thread(f_hog_manager(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0), b_hogbool4));
thread(f_respawn_hog_script_manager2());
	*/
	sleep(5);
	ai_place (sq_e9_m4_null_phantom_driver_4);
	ai_place (sq_e9_m4_null_phantom_driver_5);			// Fake Phantoms fly over to draw players attn to garden!
	thread(f_music_e09m4_marine_iff());
	prepare_to_switch_to_zone_set (e9_m4_1);                   // starting zone switch
	sleep_s(5);
	thread(vo_e9m4_marine_iff());        //////////////////////////////////////////////
	//DALTON - Miller? --TO-- MILLER - Agreed. Thanks, Dalton. Crimson,
	sleep(15);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep(1);
	sleep_until (not PreparingToSwitchZoneSet(), 1);
	switch_zone_set (e9_m4_1);	
	sleep(1);
	b_wait_for_narrative_hud = false;        // TESTING TO FIX THE HANG
	sleep(1);
	f_add_crate_folder(cr_e9_m4_iff_tags);
	f_add_crate_folder(cr_e9_m4_garden_crates);    // add garden crates early, so they can start cutting nav
	f_add_crate_folder(v_e9_m4_garden_vehicles);    // add garden vehicles early, so they can start cutting nav
	sleep_s(1);	
	f_blip_object_cui(garden_iff_1, "navpoint_goto");
	sleep(8);
	f_blip_object_cui(garden_iff_2, "navpoint_goto");
	sleep(9);
	f_blip_object_cui(garden_iff_3, "navpoint_goto");
	sleep(10);
	f_blip_object_cui(garden_iff_4, "navpoint_goto");
	sleep(11);
	f_blip_object_cui(garden_iff_5, "navpoint_goto");	
	sleep(12);
	f_blip_object_cui(garden_iff_6, "navpoint_goto");
	sleep(1);	
	thread(f_new_objective(e9_m4_open_door_to_garden));	
	f_create_new_spawn_folder (94);	 //spawn in donut near garden door
	sleep_s(1);	
	thread(f_location_arrival(e9_m4_lz_02,14));													// Time passed finished. Move onto Location Arrival for Garden!
	sleep(1);
	//object_create(dm_garden_door);
	sleep(3);
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////    GARDEN    //////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	ai_place_in_limbo(sq_e9_m4_guards_garden_1turretA);		 // turret group left side
	ai_place_in_limbo(sq_e9_m4_guards_garden_1turretB);		 // turret group right side
	ai_place_in_limbo (sq_e9_m4_null_phantom_driver_9);		 // hovering above central structure			
	thread(vo_e9m4_more_ghosts());        //////////////////////////////////////////////
	//Miller : Watch out, Crimson. More Ghosts.
	thread(f_music_e09m4_more_ghosts());
	sleep(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep(2);	
	ai_place(sq_e9_m4_guards_pregarden_ghost);     // 2 ghosts that come into donut to say hi
	sound_impulse_start_marker ( 'sound\environments\multiplayer\factory\dm\spops_factory_dm_center_door01_open_mnde10277', dm_donut_garden_lower, audio_center, 1 ); //AUDIO!
	device_set_position(dm_donut_garden_lower, 1);
	//object_create (sound_door_dissolve_e9m4);
	b_enter_the_garden_garage_now = true;
	sleep_until(volume_test_players (tv_e9_m4_garden_door_trigger));					//	wait until players approach garden door from donut garage	
	ai_exit_limbo(sq_e9_m4_guards_garden_1turretA);		 // turret group left side
	ai_exit_limbo(sq_e9_m4_guards_garden_1turretB);		 // turret group right side
	ai_exit_limbo (sq_e9_m4_null_phantom_driver_9);		 // hovering above central structure			
	sleep(1);
	thread(f_garden_turrets_watcher());
	thread(f_e9_m4_opendoor(dm_garden_door, 4));
	thread(f_e9_m4_heavy_forces_callout());
	sleep_until(volume_test_players (e9_m4_garden_trigger), 1);					//	wait until players enter Garden and hit Trigger
	ai_place(sq_e9_m4_guards_garden_1grunts1);          // GRUNT RUSH AHHHHHHHHHHHGGGGG!!!
	ai_place(sq_e9_m4_guards_garden_1grunts2);          // GRUNT RUSH AHHHHHHHHHHHGGGGG!!!
	ai_place(sq_e9_m4_guards_garden_1top1);          // GRUNT RUSH AHHHHHHHHHHHGGGGG!!!
	f_unblip_object_cui(garden_iff_1);					// UNBLIP GARDEN IFFs,   'ITS A TRAP!!!!' (Hide blips, fight starts)
	f_unblip_object_cui(garden_iff_2);
	f_unblip_object_cui(garden_iff_3);
	f_unblip_object_cui(garden_iff_4);
	f_unblip_object_cui(garden_iff_5);
	f_unblip_object_cui(garden_iff_6);
	b_ingarden = true;											// for Marine allies to follow us into garden
	sleep(75);			
	thread(vo_wraiths());        //////////////////////////////////////////////
	//Miller : There's the IFF tags... but there's no Marines here.
	sleep(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(3);
	thread (f_music_e09m4_wraiths_appear());	
	thread(vo_e9m4_wraiths_appear());        //////////////////////////////////////////////
	//Miller : Dammit! This was a trap! --TO--  Miller : They're working on it. Keep your pelicans
	sleep(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
	thread(f_new_objective(e9_m4_clear_the_garden));         // CLEAR THE LZ
	f_create_new_spawn_folder (93);	 //spawn in garden near donut door	 
	notifylevel("garden_spawning_started");
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 4, 1);
	ai_place(sq_e9_m4_null_phantom_driver_1);// Drops 8 dudes, 2 ghosts
	sleep_until (LevelEventStatus("phantunloaded1") or (ai_living_count(sq_e9_m4_null_phantom_driver_1) <= 0), 1);
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 5, 1);
	kill_script(f_respawn_hog);
	sleep(1);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_1a);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_1b);
	sleep_s(2);
	notifylevel("VO_droppods");
	sleep(45);	
	thread (f_dlc_load_drop_pod(e9_m4_drop_pod_3, sq_e9_m4_garden_drop_pod_1a, sq_e9_m4_garden_drop_pod_1b, drop_pod_lg_03));
	sleep_s(2);	
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 13, 1);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_2a);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_2b);
	//notifylevel("VO_droppod");
	sleep(45);	
	thread (f_dlc_load_drop_pod(e9_m4_drop_pod_4, sq_e9_m4_garden_drop_pod_2a, sq_e9_m4_garden_drop_pod_2b, drop_pod_lg_04));
	sleep_s(3);	 
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 4, 1);
	thread(f_tooclose_wraith("wraith1deployed", e9_m4_players_tooclose_wraith1, b_players_tooclose_wraith1, b_wraith1down));
	thread(f_tooclose_wraith("wraith2deployed", e9_m4_players_tooclose_wraith2, b_players_tooclose_wraith2, b_wraith2down));
	sleep(1);
	ai_place(sq_e9_m4_null_phantom_driver_3);// Drops 2 ghosts, orbit + harass (side gunners x1)  comes in first.
	sleep_until(LevelEventStatus("e9_m4_ghost1away") or (ai_living_count(sq_e9_m4_null_phantom_driver_3) <= 0), 1);  // wait until first ghost is dropped before coming in. no crash plox
	ai_place(sq_e9_m4_null_phantom_driver_2);// Drops 1 WRAITH, orbit + harass (side gunners x1)
	sleep(166);
	sleep(1);
	thread(f_e9_m4_ghost_listener());
	sleep_until (LevelEventStatus("phantunloaded2") or ((ai_living_count(sq_e9_m4_null_phantom_driver_2) <= 0) and (ai_living_count(sq_e9_m4_null_phantom_driver_3) <= 0)), 1);		 	 	
	sleep_until (ai_living_count(sq_e9_m4_ghost_driver_2) <= 0 or ai_living_count(sq_e9_m4_ghost_driver_3) <= 0 or ai_living_count(sq_e9_m4_wraith_driver_1) <= 0 or ai_living_count(gr_e9_m4_ai_all) <= 12, 1);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_3a);
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_3b);
	notifylevel("VO_droppods");
	sleep(45);	
	thread (f_dlc_load_drop_pod(e9_m4_drop_pod_5, sq_e9_m4_garden_drop_pod_3a, sq_e9_m4_garden_drop_pod_3b, drop_pod_lg_05));
	//sleep_s(2);
	sleep_s(1);	 //after some time, last pod to reinforce top, get players back up there
	//sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0, 1);	
	
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////  FINAL FIGHT  /////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	ai_place_in_limbo(sq_e9_m4_garden_drop_pod_4a);
	//notifylevel("VO_droppod");
	sleep(45);	
	thread (f_dlc_load_drop_pod(e9_m4_drop_pod_3, sq_e9_m4_garden_drop_pod_4a, NONE, drop_pod_lg_03));
	sleep_s(4);	
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 3, 1);
	notifylevel ("roundup");
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0, 1);	
	sleep(66);
	notifylevel ("grats");
	sleep(1);
	b_e9m4_narrative_is_on = false;
	sleep_s(7);
	dprint("FINAL PHANTS INCCOMING!!!!!!!!!!!");
	thread(f_music_e09m4_final_fight());
	ai_place(sq_e9_m4_null_phantom_driver_10);// Drops 2 Hunters on final Chevron, then hops back, drops WRAITH#2	
	sleep_s(1);
	ai_place(sq_e9_m4_null_phantom_driver_11);// Does gun run with side gunners. Circles middle, drops 2 hunters up top
	//thread(f_track_wraith2());
	sleep_s(3);
	thread(f_e9_m4_heavy_forces2_callout());   // Miller : They're wheeling in the big guns, Crimson!
	sleep_s(10);
	sleep_until (LevelEventStatus("finalphant2") or ((ai_living_count(sq_e9_m4_null_phantom_driver_10) <= 0) and (ai_living_count(sq_e9_m4_wraith_driver_2) <= 0)), 1);
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 3);
	notifylevel ("roundup");
	sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0);
	sleep_s(3);
	ai_place(sq_e9_m4_null_pelican_driver_6);
	sleep_s(1);
	ai_place(sq_e9_m4_null_pelican_driver_5);
	thread(vo_e9m4_area_secured());
	thread(f_music_e09m4_area_secured());
	notifylevel("e9_m4_mission_end");
	b_e9_m4_mission_over = true;
	kill_script(f_e9_m4_ghost_listener);
	kill_script(f_watch_players_in_diamond);
	kill_script(levelwidehoghealth_checker);
	kill_script(f_e9_m4_lasttargets_callouts);
	//kill_script(f_should_i_drive_our_car);
	kill_script(f_e9_m4_phant_callouts);
	kill_script(f_e9_m4_droppod_callouts);
	kill_script(f_e9_m4_grats_callouts);
	kill_script(f_respawn_hog);
	kill_script(f_tooclose_wraith);
	kill_script(f_tooclose_wraith);
	//kill_script(f_blip_wraith1);
	//kill_script(f_blip_wraith2);
	
end
	
script static void f_end_mission_e9_m4
	sleep_until (LevelEventStatus("e9_m4_mission_end"), 1);
	//pup_play_show(ppt_hanger_door_main);
	sleep_s(1);
	//Miller : Well done. --TO--  Miller : Prepare to resist invasion!
	sleep(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
	fade_out(0, 0, 0, 45); 
	player_control_fade_out_all_input (.1);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	//ai_erase_all();																						//tjp
	b_end_player_goal = true;
	sleep(1);
  b_end_player_goal = true;
  //thread(f_goal_enderb());
end
	/*  
script static void f_goal_enderb
	local real times = 0;
	repeat
		b_end_player_goal = true;
		sleep_s(1);
		times = times + 1;
	until (b_will_never_be_trueb == true or times == 10, 1);
	dprint("==========================================================  I TRIED 10 TIMES TO END THE PLAYER GOAL  =========================");
end
*/
//===================================================================================================
//======== MISC SCRIPTS =============================================================================
//===================================================================================================
script static void f_e9_m4_opendoor(device_name doorx,real openingspeedx)
	device_set_power(doorx, 1.0);
	sleep(1);
	device_set_position_track( doorx, "device:position", 1 );                     // Use this line if the device machine has an animation (looping?) we want to manipulate
	device_animate_position( doorx, 1, openingspeedx, 1.0, 1.0, TRUE );
end



script static void f_e9_m4_dissolve_out(object doorzz)
	sound_impulse_start ( 'sound\environments\multiplayer\factory\ambience\objects\factory_door_dissolve_01_in', doorzz, 1 );
	object_dissolve_from_marker(doorzz, phase_out, "dissolve_mkr");
	sleep_s(4);
	object_destroy(doorzz);
end


script static void f_garden_breached_watcher
	sleep_until(LevelEventStatus("garden_spawning_started"), 1);
	b_garden_breached = true;
	kill_script(LevelWideHogHealth_checker);
	kill_script(f_respawn_hog);
end

script static void f_valid_plyr_loc_check(unit player, object lz, short objectDistance)	
	if(player_valid(player))then
		sleep_until((objects_distance_to_object ((player), lz) <= objectDistance and objects_distance_to_object ((player), lz) > 0 ) or (LevelEventStatus("locationarrived")), 1);
		b_location_arrived = true;
	end
end

script static void f_location_arrival(object_name loc, short dist)
	object_create(loc);
	sleep(1);
	thread (f_blip_object_cui (loc, "navpoint_goto"));
	thread(f_valid_plyr_loc_check(player0, loc, dist));
	thread(f_valid_plyr_loc_check(player1, loc, dist));
	thread(f_valid_plyr_loc_check(player2, loc, dist));
	thread(f_valid_plyr_loc_check(player3, loc, dist));
	sleep_until(b_location_arrived == true, 1);
	f_unblip_object_cui (loc);
	object_destroy(loc);
	notifylevel("locationarrived");
	sleep(3);
	b_location_arrived = false;   //reset the counter to 0 for the next Location Arrival
end

script static void f_e9_m4_veh_respawn (object_name veh, trigger_volume tv, boolean abortBool)
	dprint ("veh respawn");
	b_hog_replacement_is_running = true;
	sleep_until (not volume_test_players_lookat (tv, 20, 20), 1);
	object_create (veh);
	ai_object_set_team (veh, player);
	object_set_allegiance (veh, player);
	repeat
		sleep_s(random_range(1,2));
		sleep_until (object_get_health (veh) <= 0, 1);
			if abortBool != true then
				dprint ("veh dead, respawning when players aren't looking");
				sleep_until (not volume_test_players_lookat (tv, 20, 20) and not volume_test_players(tv), 1);
				if abortBool != true then
					object_create_anew (veh);
					dprint ("players aren't looking repsawning veh");
					ai_object_set_team (veh, player);
					object_set_allegiance (veh, player);
				end
			end
	until (b_e9_m4_mission_over == true or abortBool, 1);
end

script static void LevelWideHogHealth_checker
	repeat
		if b_hog4_placed == false and b_hog3_placed == false then   // no additional hogs placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1));
		elseif b_hog4_placed == false and b_hog3_placed == true then    // only hog 3 placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0)));
		elseif b_hog4_placed == true and b_hog3_placed == false then   // only hog 4 placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0)));
		elseif b_hog4_placed == true and b_hog3_placed == true then // both hogs placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0)) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0)));
		end
		sleep(1);
	until (b_e9_m4_mission_over == true or b_garden_breached == true, 1);
end

/*script static void LevelWideHogHealth_checker
	repeat
		if b_hog4_placed == false and b_hog3_placed == false then   // no additional hogs placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1));
		elseif b_hog4_placed == false and b_hog3_placed == true then    // only hog 3 placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0)));
		elseif b_hog4_placed == true and b_hog3_placed == false then   // only hog 4 placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0)));
		elseif b_hog4_placed == true and b_hog3_placed == true then // both hogs placed
			r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0)) + object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0)));
		end
		sleep(1);
	until (b_e9_m4_mission_over == true or b_garden_breached == true, 1);
end*/
			
//script static void f_respawn_hog(ai hogdropPeli, vehicle dropHog, string hogDroppedString, boolean abortBool1, object_name spawnHog, trigger_volume spawnHogTV, boolean abortBool2)
script static void f_respawn_hog(ai hogdropPeli, string hogDroppedString, boolean abortBool1)
	local boolean b_hogDropped = false;
	repeat //PART ONE - THE PELICAN DROP
		if r_LevelWideHogHealth <= 1.0 and abortBool1 != true then
			sleep(1);
			ai_place(hogdropPeli);
			sleep_until(LevelEventStatus(hogDroppedString), 1);
			//thread(vo_pelican_dropping_reinforcements());
			b_hogDropped = true;
		elseif abortBool1 == true then		
			sleep(1);
			dprint("ABORTED, WE SHOULDNT DROP A HOG BACK THERE ANYMORE!!!");
		else
			sleep(1);
			dprint("I GUESS THE PLAYER DOESNT NEED A HOG RIGHT NOW!!");
			sleep_s(1);
		end
	until (b_hogDropped or abortBool1, 1);
end

	/*repeat	//PART TWO - THE INSTANT RESPAWN LOGIC
		if (abortBool1 != true and abortBool2 != true) then
			sleep_until(r_LevelWideHogHealth <= 0.5, 1);
			if object_get_health(dropHog) > 0 then
				dprint("Not creating new Hog, existing respawnHog still alive!");
				sleep(1);
			elseif abortBool1 == true or abortBool2 == true then		
				sleep(1);
				dprint("ABORTED, WE SHOULDNT DROP A HOG BACK THERE ANYMORE!!!");
			else
				if (abortBool1 != true and abortBool2 != true) then
					dprint(" HOG RESPAWNING HAS BEGUN!!!!!!!!!!!");
					thread (f_e9_m4_veh_respawn (spawnHog, spawnHogTV, abortBool2));
				end
			end
		end
	until(b_e9_m4_mission_over == true or abortBool1 or abortBool2 or b_hog_replacement_is_running, 1);*/


script static void center_under_attack
	sleep_until(ai_living_count(gr_e9_m4_ai_all) <= 6, 1);
	b_center_under_attack = true;
end

	
script static void f_tooclose_wraith(string eventz, trigger_volume tvz, boolean playerstooclosebooleanz, boolean wraithdestroyedbooleanz)
	sleep_until(LevelEventStatus(eventz) or b_e9_m4_mission_over == true,1);
	if b_e9_m4_mission_over == true then
		sleep(1);
	else
		repeat
			sleep_until(volume_test_players (tvz), 1);
			playerstooclosebooleanz = true;
			sleep_until(not volume_test_players(tvz), 1);
			sleep_s(5);
			playerstooclosebooleanz = false;
		until (b_e9_m4_mission_over == true or wraithdestroyedbooleanz, 1);	
	end
end



script static void f_handle_wraiths                   // threads the scripts that make Lonely enemies check to see if they can man the Upper gun on the wraiths
	sleep_until(LevelEventStatus("wraith1deployed"));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1turretA, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1turretB, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1grunts1, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_ghost_driver_0, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_ghost_driver_1, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1phant1, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1phant2, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1phant3, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_guards_garden_1phant4, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_1a, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_1b, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_2a, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_2b, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_ghost_driver_2, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_ghost_driver_3, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_3a, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_3b, sq_e9_m4_wraith_driver_1));
	thread(f_wraith_gunner_volunteers(sq_e9_m4_garden_drop_pod_4a, sq_e9_m4_wraith_driver_1));
end

script static void f_garden_turrets_watcher
	sleep_until (ai_task_count(obj_e9_m4_garden_1.turret_a) == 0 or ai_task_count(obj_e9_m4_garden_1.turret_b) == 0);  // wait until one turret is overrun!
	b_turrets_viable = false;
end

script static void f_unblip_squads_vehicle(ai squad, real timeTilUnblip)
	sleep_until(player_in_vehicle(unit_get_vehicle(squad)), 1, 30 * timeTilUnblip);
	//navpoint_track_object_named (unit_get_vehicle(squad), false);
end

script static void f_unblip_vehicle(vehicle vehk, real timeTilUnblip)
	sleep_until(player_in_vehicle(vehk), 1, 30 * timeTilUnblip);
	//navpoint_track_object_named(vehk, false);
end

script static short f_is_destroyed(ai squad)
	r_is_destroyed = 0;
	if object_get_health(unit_get_vehicle(squad))<= 0 then r_is_destroyed = 1;
	end
	r_is_destroyed;																																								
end

script static void f_itsOn_watcher
	sleep_until (((ai_living_count(sq_e9_m4_guards_diamond_ghosts) == 0) and (ai_living_count(sq_e9_m4_guards_diamond_ghosts2) == 0)) or	(volume_test_players (e9_m4_donut_trigger_startbattle) == true), 1, 30 * 5);							//  wait until area is cleared, or wait 5 seconds
		object_create(e9_m4_lz_01);
	b_itsOn = true;																												//criteria used in Sapien, in the 2 ghost guys condition, 'move to donut?' (objectives)
	b_indonut = true;
	if b_playersTouchedDonut == false then
		navpoint_track_object_named (e9_m4_lz_01, navpoint_goto);
		b_navpointOn = true;
	end
	sleep_until(volume_test_players (e9_m4_donut_trigger) == true, 1);				//	wait until players enter Donut and hit Trigger to disable blip
	if b_navpointOn == true then
		navpoint_track_object (e9_m4_lz_01, false);
	end
	object_destroy(e9_m4_lz_01);
end

script static void f_playersTouchedDonutCheck
	sleep_until(volume_test_players (e9_m4_donut_trigger) == true, 1);
	b_playersTouchedDonut = true;
end

script static void f_donut_inside_watcher
	sleep_until(volume_test_players(e9_m4_donut_player_enter), 1);
	b_e9_m4_donut_players_inside = true;
	if (ai_living_count(gr_e9_m4_ai_all) <= 9) then
		ai_place(sq_e9_m4_guards_donut_ghosts2);//1
	end
	//ai_place(sq_e9_m4_guards_donut_center);//2
end

script static void f_watch_players_in_diamond
	repeat
		sleep_until(volume_test_players (players_pushing) != b_players_initial_pos, 1);
		b_players_initial_pos = not b_players_initial_pos;
	until(LevelEventStatus("roundup"), 1);
end

script static void f_diamond_playerspawn_monitor					// watch player and enemy movements, keep players respawning with the action.
	sleep_until(b_BattleHalfwayOver == true);						// only start watching once the battle is halfway over, to ensure they are probably familiar with the area by now, committed.
	local boolean b_player_initial_spawner = true;
	repeat
		local real r_diamond_task_sum = ai_task_count(obj_e9_m4_guards_diamond_1.tasks_1) + ai_task_count(obj_e9_m4_guards_diamond_1.tasks_2) + ai_task_count(obj_e9_m4_guards_diamond_1.tasks_4);
		if r_diamond_task_sum < 1 and b_player_initial_spawner == true then
			f_create_new_spawn_folder (91);	 //spawn at rear
			b_player_initial_spawner = false;
			sleep(1);
		elseif r_diamond_task_sum > 1 and b_player_initial_spawner == false then
			f_create_new_spawn_folder (99); //spawn at	start - front
			b_player_initial_spawner = true;
			sleep(1);
		else
			sleep(1);
		end
	until(LevelEventStatus("roundup"), 1);
end

script static void f_track_wraith1
	sleep_until(LevelEventStatus("wraith1deployed") or (object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_1.sp))<= 0) or (object_get_health(unit_get_vehicle(sq_e9_m4_null_phantom_driver_2.sp))),1);
	sleep_until(object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_1.sp))<= 0, 1);
	b_wraith1down = true;
	sleep(40);
	thread(vo_glo15_miller_attaboy_08());        //////////////////////////////////////////////
	//Miller : Impressive, Crimson.
	sleep(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep(2);
end

/*script static void f_blip_wraith1
	sleep_until(LevelEventStatus("wraith1deployed"),1);
	repeat
		sleep_s(15);
		navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_wraith_driver_1), "navpoint_enemy_vehicle");
	until (object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_1.sp))<= 0, 1);
end

script static void f_blip_wraith2
	sleep_until(LevelEventStatus("wraith2deployed"),1);
	repeat
		sleep_s(15);
		navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_wraith_driver_2), "navpoint_enemy_vehicle");
	until (object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_2.sp))<= 0, 1);
end*/
 
script static void f_track_wraith2
	sleep_until(LevelEventStatus("wraith2deployed") or (object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_2.sp))<= 0) or (object_get_health(unit_get_vehicle(sq_e9_m4_null_phantom_driver_10.sp))),1);
	sleep_until(object_get_health(unit_get_vehicle(sq_e9_m4_wraith_driver_2.sp))<= 0, 1);
	b_wraith2down = true;
	sleep(45);
	thread(vo_e9m4_another_down());        //////////////////////////////////////////////
	//Miller : Great! Keep it up, Crimson!
	sleep_s(1);
	sleep_until(b_e9m4_narrative_is_on == false, 1);
	sleep_s(2);
end

script static void e9_m4_phantom_despawn_hack(ai phantom)
	sleep(30);
	//dprint("----=-=-=-=-----trying to ai_kill phantom");
	if(ai_living_count(phantom) > 0) then
		//dprint("----=-=-=-=-----phantom alive, trying to erase");
		ai_erase (phantom);
		//dprint("----=-=-=-=-----tried to erase, ==--=-=-=-=-=-=-=-=---=====");
		sleep(2);
		e9_m4_phantom_despawn_hack(phantom);
	else
		//dprint("----=-=-=-=-----phantom presumed dead, sleeping forever");
		sleep_forever();
	end
end

script static void f_marines_garden_prep
	sleep_until (LevelEventStatus("marinesprep"), 1);
	b_marinesgardenprep = true;
end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////// CLEAN THIS UP  VVVVV//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// MAKES AI NOT DRIVE FIRST 2 HOGS AWAY AT START. MAKES THEM WAIT TIL PLAYERS ARE INSIDE
// VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

script static void f_ai_vehicleobjective_boolean_checker
	repeat
		sleep_until((b_hogbool1 == true) or (b_hogbool2 == true) or (b_hogbool3 == true) or (b_hogbool4 == true), 1);
		dprint("zb_hogbool1");
		inspect(b_hogbool1);
		dprint("zb_hogbool2");
		inspect(b_hogbool2);
		dprint("zb_hogbool3");
		inspect(b_hogbool3);
		dprint("zb_hogbool4");
		inspect(b_hogbool4);
		b_timetodrive = true;
		dprint("VEHICLE OBJECTIVE IS GO!");
		sleep_until((b_hogbool1 == false) and (b_hogbool2 == false) and (b_hogbool3 == false) and (b_hogbool4 == false), 1);
		dprint("zb_hogbool1");
		inspect(b_hogbool1);
		dprint("zb_hogbool2");
		inspect(b_hogbool2);
		dprint("zb_hogbool3");
		inspect(b_hogbool3);
		dprint("zb_hogbool4");
		inspect(b_hogbool4);
		b_timetodrive = false;
		dprint("NO MORE VEHICLE OBJECTIVE!!!");
	until (b_e9_m4_mission_over == true, 1);
end
// put this somewhere better
//	ai_vehicle_reserve_seat(car, warthog_d, true);   // no ai can drive this hog!
	
script static void f_ai_vehicleobjective_manager1(vehicle car)
	repeat
		sleep_until(player_in_vehicle(car), 1);
		if not vehicle_test_seat(car, warthog_d) then
			 ai_vehicle_reserve_seat(car, warthog_d, false);   // ai can drive this hog!
		end
			 b_hogbool1 = true;
			 dprint("zdrivebool1");
			 inspect(b_hogbool1);
			 dprint("DRIVE FOR ME!");
		sleep_until(player_in_vehicle(car) == false or (object_get_health(car) <= 0), 1);
		ai_vehicle_reserve_seat(car, warthog_d, true);   // ai cant drive this hog!
		ai_vehicle_exit(gr_e9_m4_marines_1,warthog_d);
		b_hogbool1 = false;
		dprint("zdrivebool1");
		inspect(b_hogbool1);
			 dprint("STOP DRIVING FOR ME!");
	until ((b_e9_m4_mission_over == true) or (object_get_health(car) <= 0), 1);
end

script static void f_ai_vehicleobjective_manager2(vehicle car)
	repeat
		sleep_until(player_in_vehicle(car), 1);
		if not vehicle_test_seat(car, warthog_d) then
			 ai_vehicle_reserve_seat(car, warthog_d, false);   // ai can drive this hog!
		end
			 b_hogbool2 = true;
			 dprint("zdrivebool2");
			 inspect(b_hogbool2);
			 dprint("DRIVE FOR ME!");
		sleep_until(player_in_vehicle(car) == false or (object_get_health(car) <= 0), 1);
		ai_vehicle_reserve_seat(car, warthog_d, true);   // ai cant drive this hog!
		ai_vehicle_exit(gr_e9_m4_marines_1,warthog_d);
		b_hogbool2 = false;
		dprint("zdrivebool2");
		inspect(b_hogbool2);
			 dprint("STOP DRIVING FOR ME!");
	until ((b_e9_m4_mission_over == true) or (object_get_health(car) <= 0), 1);
end

script static void f_ai_vehicleobjective_manager3(vehicle car)
	repeat
		sleep_until(player_in_vehicle(car), 1);
		if not vehicle_test_seat(car, warthog_d) then
			 ai_vehicle_reserve_seat(car, warthog_d, false);   // ai can drive this hog!
		end
			 b_hogbool3 = true;
			 dprint("zdrivebool3");
			 inspect(b_hogbool3);
			 dprint("DRIVE FOR ME!");
		sleep_until(player_in_vehicle(car) == false or (object_get_health(car) <= 0), 1);
		ai_vehicle_reserve_seat(car, warthog_d, true);   // ai cant drive this hog!
		b_hogbool3 = false;
		dprint("zdrivebool3");
		inspect(b_hogbool3);
			 dprint("STOP DRIVING FOR ME!");
	until ((b_e9_m4_mission_over == true) or (object_get_health(car) <= 0), 1);
end

script static void f_ai_vehicleobjective_manager4(vehicle car)
	repeat
		sleep_until(player_in_vehicle(car), 1);
		if not vehicle_test_seat(car, warthog_d) then
			 ai_vehicle_reserve_seat(car, warthog_d, false);   // ai can drive this hog!
		end
			 b_hogbool4 = true;
			 dprint("zdrivebool4");
			 inspect(b_hogbool4);
			 dprint("DRIVE FOR ME!");
		sleep_until(player_in_vehicle(car) == false or (object_get_health(car) <= 0), 1);
		ai_vehicle_reserve_seat(car, warthog_d, true);   // ai cant drive this hog!
		b_hogbool4 = false;
		dprint("zdrivebool4");
		inspect(b_hogbool4);
			 dprint("STOP DRIVING FOR ME!");
	until ((b_e9_m4_mission_over == true) or (object_get_health(car) <= 0), 1);
end



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////// CLEAN THIS UP  ^^^^^//////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*script static void f_e9_m4_reserve_players_passengerseat_if_valid(unit player)
	sleep_until(player_valid(player), 1);
	ai_vehicle_reserve_seat (unit_get_vehicle(player), "warthog_p", true);
end*/

// BLIP SCRIPTS FOR DROPPED HOGS. DO NOT USE THESE ON INITIAL HOGS.
//  VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
			
script static void e9_m4_blip_hog(vehicle hog, ai aiDroppedWithHog)
	if not (player_in_vehicle(hog)) then
		ai_vehicle_reserve_seat (hog, "warthog_d", true); // disallow ai driver
	end
	sleep(30 * 5);
	if not (player_in_vehicle(hog)) then
		ai_vehicle_enter (aiDroppedWithHog, hog, "warthog_g");// get an ai in the gunner seat
		sleep(30 * 7);
		dprint("HEY! VEHICLE HERE, READY WHEN YOU ARE, SPARTAN!");
		sleep(45);		
		f_blip_object_cui (hog, "navpoint_generic");																 
	end
	thread(f_e9_m4_if_players_getin_hog(hog));
	thread(f_e9_m4_wait_then_ai_drive_hog_back(hog, aiDroppedWithHog));
end

script static void f_e9_m4_if_players_getin_hog(vehicle hog)
	sleep_until (player_in_vehicle (hog), 1);            // wait until players are in the hog
	f_unblip_object_cui (hog);
	kill_script(f_e9_m4_wait_then_ai_drive_hog_back);
	ai_vehicle_reserve_seat (hog, "warthog_g", false);   // allow ai gunner
	ai_vehicle_reserve_seat (hog, "warthog_p", false);   // allow ai rider
	ai_vehicle_reserve_seat (hog, "warthog_d", false);   // allow ai driver
end

script static void f_e9_m4_wait_then_ai_drive_hog_back(vehicle hog, ai aiDroppedWithHog)
	sleep (30 * 40);
	ai_vehicle_reserve_seat (hog, "warthog_g", true);    // disallow ai gunner
	ai_vehicle_reserve_seat (hog, "warthog_p", true);    // disallow ai passenger
	ai_vehicle_reserve_seat (hog, "warthog_d", false);   // allow ai driver
	ai_vehicle_enter(aiDroppedWithHog, hog, "warthog_d");
	f_unblip_object_cui (hog);
	sleep_until (player_in_vehicle (hog));
	ai_vehicle_reserve_seat (hog, "warthog_g", false);   // allow ai gunner
	ai_vehicle_reserve_seat (hog, "warthog_p", false);   // allow ai rider
end

		//	r_LevelWideHogHealth = (object_get_health(v_e9_m4_warthog2) + object_get_health(v_e9_m4_warthog1));
			
			
/*script static void f_e9_m4_hog_occupancy_checker(ai carAi, vehicle car, ai me, boolean b_drive_this_car_now_bool)
	if carAi == "none" then // no car AI, meaning this is NOT a spawnpoint-dropped car, but it is a world-placed vehicle-type car
		if object_get_health(car)> 0 then  // if the car is placed, lets check its health
				dprint("I SEE THAT YOUR GROUND PLACED VEHICLE IS ALIVE AND VALID!!!------------ LETS SEE IF PLAYERS NEED A LIFT IN IT");
			if player_in_vehicle(car) and (vehicle_driver(car) == me) then
				b_drive_this_car_now_bool = true;
				dprint("YES, DRIVE MY CAR BRO!!!-------ONE VEHICLE WITH PROPER AI-DRIVE CRITERIA FOUND!!!------");
			else b_drive_this_car_now_bool = false;
			end
		else
			dprint("CAR HASNT BEEN PLACED YET OR IS BLOWN UP");
		end
	elseif carAi == sq_e9_m4_marines_hog_3 then        // lets check hog3's hog
		if object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0)) > 0 then
			dprint("I SEE THAT YOUR AI-PLACED CAR IS ALIVE AND VALID!!!-------HOG 3----- LETS SEE IF PLAYERS NEED A LIFT IN IT");
			if player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_3)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_3)) == me) then
				b_drive_this_car_now_bool = true;
				dprint("YES, DRIVE MY CAR BRO!!!-------VEHICLE WITH PROPER AI-DRIVE CRITERIA FOUND!!!----CAR3 - B---");
			else b_drive_this_car_now_bool = false;
			end
		else
			dprint("CAR HASNT BEEN PLACED YET OR IS BLOWN UP");
		end
	elseif carAi == sq_e9_m4_marines_hog_4 then   // lets check hog4's hog
		if object_get_health(ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0)) > 0 then
				dprint("I SEE THAT YOUR AI-PLACED CAR IS ALIVE AND VALID!!!----HOG 4-------- LETS SEE IF PLAYERS NEED A LIFT IN IT");
			if player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_4)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_4)) == me) then
				b_drive_this_car_now_bool = true;
				dprint("YES, DRIVE MY CAR BRO!!!-------VEHICLE WITH PROPER AI-DRIVE CRITERIA FOUND!!!---CAR4 - C---");
			else b_drive_this_car_now_bool = false;
			end
		else
			dprint("CAR HASNT BEEN PLACED YET OR IS BLOWN UP");
		end
	end
end
*/

/*

script static void f_should_i_drive_our_car
	repeat
	 if ((player_in_vehicle(v_e9_m4_warthog1) and (vehicle_driver(v_e9_m4_warthog1) != sq_e9_m4_marines_hog_2)) or
		 	 (player_in_vehicle(v_e9_m4_warthog1) and (vehicle_driver(v_e9_m4_warthog1) == sq_e9_m4_marines_hog_3)) or
			 (player_in_vehicle(v_e9_m4_warthog1) and (vehicle_driver(v_e9_m4_warthog1) == sq_e9_m4_marines_hog_4)) or
		 	 (player_in_vehicle(v_e9_m4_warthog2) and (vehicle_driver(v_e9_m4_warthog2) == sq_e9_m4_marines_hog_2)) or
		 	 (player_in_vehicle(v_e9_m4_warthog2) and (vehicle_driver(v_e9_m4_warthog2) == sq_e9_m4_marines_hog_3)) or
		 	 (player_in_vehicle(v_e9_m4_warthog2) and (vehicle_driver(v_e9_m4_warthog2) == sq_e9_m4_marines_hog_4)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) == sq_e9_m4_marines_hog_2)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) == sq_e9_m4_marines_hog_3)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_3.spawn_points_0)) == sq_e9_m4_marines_hog_4)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) == sq_e9_m4_marines_hog_2)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) == sq_e9_m4_marines_hog_3)) or
		 	 (player_in_vehicle(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) and (vehicle_driver(ai_vehicle_get(sq_e9_m4_marines_hog_4.spawn_points_0)) == sq_e9_m4_marines_hog_4))) then
			 b_ill_drive_our_car = true;
			 dprint("------------DRIVE THE CAR, PEON!-----------");
		else 
			 b_ill_drive_our_car = false;
			 dprint("------------PLAYER IN CAR, AI NOT IN CAR!!!-----------");
		end
		sleep_s(3);
	until (b_e9_m4_mission_over == true, 1);
end*/






/*
script static void f_e9_m4_hog_occupancy_checker_wrapper(vehicle car1, vehicle car2, vehicle car3, vehicle car4, ai carAi1, ai carAi2, ai me)
		thread(f_e9_m4_hog_occupancy_checker(none, car1, me, b_drive_this_car_now_bool1));
		thread(f_e9_m4_hog_occupancy_checker(none, car2, me, b_drive_this_car_now_bool2));
		thread(f_e9_m4_hog_occupancy_checker(none, car3, me, b_drive_this_car_now_bool3));
		thread(f_e9_m4_hog_occupancy_checker(none, car4, me, b_drive_this_car_now_bool4));
		thread(f_e9_m4_hog_occupancy_checker(carAi1, none, me, b_drive_this_car_now_bool5));
		thread(f_e9_m4_hog_occupancy_checker(carAi2, none, me, b_drive_this_car_now_bool6));
end*/
/*
script static void f_should_i_drive_our_car(vehicle car1, vehicle car2, vehicle car3, vehicle car4, ai carAi1, ai carAi2, ai me)
	repeat
		sleep_s(1);
		f_e9_m4_hog_occupancy_checker_wrapper(car1, car2, car3, car4, carAi1, carAi2, sq_e9_m4_marines_hog_3)
		f_e9_m4_hog_occupancy_checker_wrapper(car1, car2, car3, car4, carAi1, carAi2, sq_e9_m4_marines_hog_3)
		dprint("checking cars for occupancy criteria");
		sleep_s(1);
		if (b_drive_this_car_now_bool1) or
			 (b_drive_this_car_now_bool2) or
			 (b_drive_this_car_now_bool3) or
			 (b_drive_this_car_now_bool4) or
			 (b_drive_this_car_now_bool5) or
			 (b_drive_this_car_now_bool6) then		
			b_ill_drive_our_car = true;
			dprint("YES, DRIVE MY CAR BRO!!!-------All Vehicle Objectives Enabled------");
		end
	until (b_e9_m4_mission_over == true, 1);
end*/

script static void f_players_past_door
	sleep_until(volume_test_players (e9_m4_donut_trigger_startbattle));
	b_players_past_door = true;
end


script static void f_e9_m4_roundup
	dprint("roundup SCRIPT LOADED ---- LISTENING FOR ROUNDUP CALL!----------------------------------");	
//	local real r_times_roundedup = 0;	
	thread(f_e9_m4_lasttargets_callouts());
	repeat
		sleep_until (LevelEventStatus("roundup"),1);
		dprint("SOMEONE WANTED ME TO ROUND UP THE ENEMIES AGAIN-------------------------------------------------------------------");
		b_rounding_up = true;
		sleep(5);
		if (ai_living_count(gr_e9_m4_ai_all) <= 0) then
			sleep(1);
			dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
		else
			if b_e9m4_narrative_is_on == FALSE then		
				if (ai_living_count(gr_e9_m4_ai_all) <= 0) then
					dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
					sleep(1);
				else
					sleep(1);
					notifylevel("lasttargets");	
					sleep(1);
					dprint("-----------I JUST TOLD THE VO SCRIPT TO GIVE US SOME BLIPPIN VO, BEFORE I MARK THE TARGETS IN 1 SECOND----------");
					sleep_s(2);
					f_blip_ai_cui(gr_e9_m4_ai_all, "navpoint_enemy");
					sleep_until (ai_living_count(gr_e9_m4_ai_all) <= 0, 1);
					f_unblip_ai_cui(gr_e9_m4_ai_all);
				end
			else
				dprint("-----------SOMEONE ELSE IS TALKING STILL!, I WILL WAIT BEFORE BLIPPING LAST GUYS!");
				sleep_until(b_e9m4_narrative_is_on == false, 1);
				if (ai_living_count(gr_e9_m4_ai_all) <= 0) then
					dprint("------------NO ENEMIES LEFT ALIVE, SO I WONT DO THE BLIP THING!");
					sleep(1);
				else				
					notifylevel("lasttargets");	
					sleep_s(2);
					f_blip_ai_cui(gr_e9_m4_ai_all, "navpoint_enemy");
					sleep_until (ai_living_count(gr_e9_m4_ai_all) == 0, 1);
					f_unblip_ai_cui(gr_e9_m4_ai_all);	
				end
			end
		end
		notifylevel("allclear");
		b_rounding_up = false;
		//r_times_roundedup = r_times_roundedup + 1;
		//sleep(1);
		//sleep_until (LevelEventStatus("roundup"),1);
		sleep(1);
	until (b_e9_m4_mission_over == true, 1);
	//until (r_times_roundedup == 4 or b_e9_m4_mission_over == true, 1);
	//dprint("THAT WAS THE FINAL ROUNDUP CALL, WHERE WE BLIP RED ARROWS OVER DUDES FOR THE LAST TIME!");
end
  
script static void dafaq_is_going_on_wraith_fail_recovery_procedure	
	repeat
		if (ai_living_count(sq_e9_m4_wraith_driver_2) <= 0) then 
			dprint("WRAITH FAILED TO LOAD INTO PHANTOM FOR SOME REASON! TRYING TO FIX IT!!!");
			ai_place(sq_e9_m4_wraith_driver_2);	
			vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_10.sp), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_2.sp));
		else
			sleep_s(2);
			if (ai_living_count(sq_e9_m4_wraith_driver_2) >= 1) then
				dprint("------------OMG WRAITH STAYED ON?????????---------------------IF YOU SEE THIS, FIX THE PROBLEM ALREADY-----");
				b_wraith2_actually_stayed_on = true;
			end
		end
	until (b_e9_m4_mission_over == true or LevelEventStatus("wraith2deployed") or b_wraith2_actually_stayed_on, 1);
end



/*
script static void f_rotateship(vehicle shipp)
	object_rotate_by_offset(shipp,30,30,30,0,0,33);
end

script static void f_wobbleship(vehicle ship)	
	//dprint("STARTING RANDOM WOBBLES AND STUFF!!!!!!!!!---------------------------");
	repeat
		local real yaw = random_range(-0,0);
		local real pitch = random_range(-0,0);
		dprint("RANDOM ROTATE OFFSET!!!!!!!!!---------------------------");	
		thread(f_rotateship(ship));
		object_set_angular_velocity(ship, -1, pitch, yaw);
		object_set_angular_velocity(ship, -2.5, pitch, yaw);
		object_set_angular_velocity(ship, -5, pitch, yaw);
		object_set_angular_velocity(ship, -7.5, pitch, yaw);
		object_set_angular_velocity(ship, -10, pitch, yaw);
		object_set_angular_velocity(ship, -7.5, pitch, yaw);
		object_set_angular_velocity(ship, -5, pitch, yaw);
		object_set_angular_velocity(ship, -2.5, pitch, yaw);
		object_set_angular_velocity(ship, -1, pitch, yaw);
		object_set_angular_velocity(ship, 0, pitch, yaw);
		object_set_angular_velocity(ship, 1, pitch, yaw);
		object_set_angular_velocity(ship, 2.5, pitch, yaw);
		object_set_angular_velocity(ship, 5, pitch, yaw);
		object_set_angular_velocity(ship, 7.5, pitch, yaw);
		object_set_angular_velocity(ship, 10, pitch, yaw);
		object_set_angular_velocity(ship, 7.5, pitch, yaw);
		object_set_angular_velocity(ship, 5, pitch, yaw);
		object_set_angular_velocity(ship, 2.5, pitch, yaw);
		object_set_angular_velocity(ship, 1, pitch, yaw);
		object_set_angular_velocity(ship, 0, pitch, yaw);
		dprint("ROTATED!!!!!!!!!!!---------------------------");
	until (b_e9_m4_mission_over == true, 1);
end*/

//script static void f_phantom_congratulations_watcher(ai phantomsquad)
//	repeat
	//	sleep_until(object_get_health(ai_vehicle_get(phantomsquad)))
		
		
		
		
		
		

//===================================================================================================
//======== COMMAND SCRIPTS ==========================================================================
//===================================================================================================
script command_script cs_e9_m4_donutdoor_fallbackguys
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (false);
	cs_enable_looking (true);
	sleep_until(b_players_past_door == true, 1, 3 * 30);  //wait until players walk towards them, or 3 seconds elapses, inwhich case they are visible to all
	cs_enable_moving (true);
end

script command_script cs_e9_m4_huntershoot
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	sleep_until(LevelEventStatus("finalphant2"), 1);
	thread(cs_hunter_seek());
end

script static void cs_hunter_seek
	//repeat
		cs_approach_player(sq_e9_m4_guards_garden_3hunterB, true, 1, 1000, 1000);
		thread(f_cs_shoot_if_possible(player0));
		thread(f_cs_shoot_if_possible(player1));
		thread(f_cs_shoot_if_possible(player2));
		thread(f_cs_shoot_if_possible(player3));
		sleep_s(1);
		dprint("IM GONNA FIND YOU, PLAYER!!!");
		/*
		sleep_until(unit_get_health(player0) <= 0 or
								unit_get_health(player1) <= 0 or
								unit_get_health(player2) <= 0 or
								unit_get_health(player3) <= 0, 1);
		sleep_until(unit_get_health(player0) > 0, 1);		
	until (b_e9_m4_mission_over == true, 1);*/
end
	
script static void f_cs_shoot_if_possible(unit player)
	sleep_until(player_valid(player));
	cs_shoot(sq_e9_m4_guards_garden_3hunterB, true, player);
end

script command_script cs_e9_m4_pelican_drop_1
	ai_object_set_targeting_bias(obj_target,1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_fly_to(e9_m4_pelican_1_pts.p0);						
//	sleep_until(b_e9_m4_pelican_flyaway == true);
	//vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_pelican_driver_1.sp ), "" );
	sleep(1);
	cs_vehicle_speed (0.25);	
	cs_fly_to(e9_m4_pelican_1_pts.p5);
	sleep(1);
	cs_fly_to(e9_m4_pelican_1_pts.p0);		
	sleep(1);	
	cs_fly_by(e9_m4_pelican_1_pts.p6);			
	sleep(15);
	cs_fly_to_and_face(e9_m4_pelican_1_pts.p7,e9_m4_pelican_1_pts.p2);	
	cs_vehicle_speed (1);	
	cs_fly_by(e9_m4_pelican_1_pts.p2);																
	cs_fly_by(e9_m4_pelican_1_pts.p3);
	cs_fly_by(e9_m4_pelican_1_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);																												
end

script command_script cs_e9_m4_pelican_drop_2
	ai_object_set_targeting_bias(obj_target,1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
//	cs_fly_to_and_face(e9_m4_pelican_2_pts.p0,e9_m4_pelican_2_pts.p1);						
//	sleep_until(b_e9_m4_pelican_flyaway == true);
	cs_vehicle_speed (0.25);	
	//vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_pelican_driver_2.sp ), "" );
	cs_fly_to(e9_m4_pelican_2_pts.p0);
	sleep(1);
	cs_fly_to(e9_m4_pelican_2_pts.p5);
	sleep(15);
	cs_fly_to(e9_m4_pelican_2_pts.p8);			
	sleep(1);
	cs_fly_to(e9_m4_pelican_2_pts.p6);
	sleep(25);		
	cs_vehicle_speed (1);	
	cs_fly_by(e9_m4_pelican_2_pts.p2);																								
	cs_fly_by(e9_m4_pelican_2_pts.p3);
	cs_fly_by(e9_m4_pelican_2_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);																												
end

script command_script cs_e9_m4_pelican_drop_3
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	ai_place(sq_e9_m4_marines_hog_3);
	b_hog3_placed = true;
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_pelican_driver_3.sp), "pelican_lc", ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_3.spawn_points_0));
	//cs_fly_to_and_face(e9_m4_pelican_3_pts.p0,e9_m4_pelican_3_pts.p1);					
	object_set_velocity(unit_get_vehicle(ai_current_actor), 45, 0, 0);
	cs_fly_to(e9_m4_pelican_3_pts.p2);	
	cs_fly_to_and_face(e9_m4_pelican_3_pts.p3,e9_m4_pelican_3_pts.p4);	
	sleep(2);
	cs_fly_to_and_face(e9_m4_pelican_3_pts.p5,e9_m4_pelican_3_pts.p8);	
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_pelican_driver_3.sp ), "" );
	notifylevel("pelican3unloaded");
	
	thread(e9_m4_blip_hog(unit_get_vehicle(sq_e9_m4_marines_hog_3.spawn_points_0), sq_e9_m4_marines_hog_3));
	thread(f_ai_vehicleobjective_manager3(unit_get_vehicle(sq_e9_m4_marines_hog_3.spawn_points_0)));
	//f_blip_object_cui (unit_get_vehicle(sq_e9_m4_marines_hog_3.spawn_points_0), "navpoint_ally_vehicle");
	sleep_s(2);
	cs_fly_to_and_face(e9_m4_pelican_3_pts.p3,e9_m4_pelican_3_pts.p4);	
	sleep(1);
	cs_fly_to_and_face(e9_m4_pelican_3_pts.p10,e9_m4_pelican_3_pts.p9);	
	sleep(1);
	cs_fly_to(e9_m4_pelican_3_pts.p2);	
	sleep(1);
	cs_fly_to(e9_m4_pelican_3_pts.p6);			
	object_set_velocity(unit_get_vehicle(ai_current_actor), 13, 0, 0);
	cs_fly_to(e9_m4_pelican_3_pts.p0);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);																												
end

script command_script cs_e9_m4_pelican_drop_4
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	ai_set_blind(ai_current_actor, true);	
	cs_vehicle_speed (1);	
	ai_place(sq_e9_m4_marines_hog_4);
	b_hog4_placed = true;
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_pelican_driver_4.sp), "pelican_lc", ai_vehicle_get_from_spawn_point(sq_e9_m4_marines_hog_4.spawn_points_0));
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 0);	
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_null_pelican_driver_4), "navpoint_ally_vehicle");
	cs_fly_to(e9_m4_pelican_4_pts.p1);	
	cs_fly_to_and_face(e9_m4_pelican_4_pts.p10,e9_m4_pelican_4_pts.p9);	
	cs_vehicle_speed (1.0);	
	cs_fly_to_and_face(e9_m4_pelican_4_pts.p3,e9_m4_pelican_4_pts.p4);	
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_pelican_driver_4.sp ), "" );	
	notifylevel("pelican4unloaded");
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_null_pelican_driver_4), false);
	thread(e9_m4_blip_hog(unit_get_vehicle(sq_e9_m4_marines_hog_4.spawn_points_0), sq_e9_m4_marines_hog_4));
	thread(f_ai_vehicleobjective_manager4(unit_get_vehicle(sq_e9_m4_marines_hog_4.spawn_points_0)));	
	sleep_s(5);
	cs_fly_to_and_face(e9_m4_pelican_4_pts.p5,e9_m4_pelican_4_pts.p8);	
	sleep_s(1);
	cs_fly_to(e9_m4_pelican_4_pts.p6);
	cs_fly_to(e9_m4_pelican_4_pts.p7);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);																														
end

script command_script cs_e9_m4_pelican_5
	object_create(outro_hog_1);
	sleep(1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_pelican_driver_5.sp), "pelican_lc", outro_hog_1);
	sleep(1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep(1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 120 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 30, 0, -1);
	cs_fly_by(e9_m4_pelican_5_pts.p0);						
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_null_pelican_driver_5), "navpoint_ally_vehicle");
//	sleep_until(b_e9_m4_pelican_flyaway == true);
	//vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_pelican_driver_1.sp ), "" );
	sleep(1);
	cs_vehicle_speed (0.7);
	cs_fly_by(e9_m4_pelican_5_pts.p1);																										
end

script command_script cs_e9_m4_pelican_6
	object_create(outro_hog_2);
	sleep(1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_pelican_driver_6.sp), "pelican_lc", outro_hog_2);
	sleep(1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	sleep(1);
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 120 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 33, 0, -4);
	cs_fly_by(e9_m4_pelican_6_pts.p4);						
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_null_pelican_driver_5), "navpoint_ally_vehicle");
	sleep(1);
	cs_vehicle_speed (0.7);	
	cs_fly_to_and_face(e9_m4_pelican_6_pts.p2,e9_m4_pelican_6_pts.p3);							
end

script command_script cs_e9_m4_wraith1
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	cs_vehicle_speed (2);	
	//sleep_until(LevelEventStatus("wraith1deployed"), 1);
	//repeat
	//	cs_shoot(true);
	//until (b_e9_m4_mission_over == true or b_wraith1_stopshooting, 1);
end
	

script command_script cs_e9_m4_wraith2
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_looking (true);
	cs_abort_on_damage (false);
	cs_abort_on_alert (false);
	cs_vehicle_speed (2);	
	//sleep_until(LevelEventStatus("wraith2deployed"), 1);
	//repeat
	//	cs_shoot(true);
	//until (b_e9_m4_mission_over == true or b_wraith2_stopshooting, 1);
end

script static void f_wraith_gunner_volunteers(ai squad, ai wraithsquad)
	sleep_until(ai_in_vehicle_count(wraithsquad) == 1);
	//dprint("VEHICLE LOST ONE OF ITS OCCUPANTS!!!!");
	repeat
		//dprint("ANY VEHICLES NEED ME?");
		if(ai_living_count(squad) == 1) and (ai_in_vehicle_count(wraithsquad) == 1) then
			//dprint("I AM ON MY WAY TO JUMP IN THE GUNNER SEAT OF THAT VEHICLE!");
			ai_vehicle_enter(squad, wraithsquad, "wraith_g");
		end
		sleep_s(7);
	until (ai_in_vehicle_count(wraithsquad) == 0, 1);
end
	
script command_script cs_e9_m4_donut_end_fake_phantom_4	
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	object_set_velocity(unit_get_vehicle(ai_current_actor), 90, 0, -10);
	cs_vehicle_speed (0.7);	
	cs_fly_by(e9_m4_phantom_4_pts.p0);
	cs_fly_by(e9_m4_phantom_4_pts.p5);
	cs_fly_to_and_face(e9_m4_phantom_4_pts.p2,e9_m4_phantom_4_pts.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 110, 0, 01);
	cs_fly_to(e9_m4_phantom_4_pts.p3);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_donut_end_fake_phantom_5	
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
  cs_force_combat_status (3);
	cs_vehicle_speed (0.7);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 90, 0, 0);
	cs_fly_by(e9_m4_phantom_5_pts.p5);
	cs_fly_by(e9_m4_phantom_5_pts.p0);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 110, 0, 01);
	cs_fly_to(e9_m4_phantom_5_pts.p7);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_phantom_drop_0       // PHANTOM IN THE DONUT, brings in jackals, then does a Lap around the donut
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	ai_place(sq_e9_m4_guards_donut_ghosts);
	sleep(1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_0.sp), "phantom_sc01", ai_vehicle_get_from_spawn_point(sq_e9_m4_guards_donut_ghosts.spawn_points_0));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_0.sp), "phantom_sc02", ai_vehicle_get_from_spawn_point(sq_e9_m4_guards_donut_ghosts.spawn_points_1));
	cs_vehicle_speed (3.15);	
	cs_fly_to(e9_m4_phantom_0_pts.p0);
	ai_place(sq_e9_m4_donut_phantomdropped_1);	
	ai_vehicle_enter_immediate(sq_e9_m4_donut_phantomdropped_1, sq_e9_m4_null_phantom_driver_0, "phantom_p");	
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");
	notifylevel("VO_Phantom");
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p1,e9_m4_phantom_0_pts.p2);
	cs_fly_to(e9_m4_phantom_0_pts.p3);
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p4,e9_m4_phantom_0_pts.p9);
	sleep_s(1);
	f_unload_phantom (ai_current_squad, "dual");
	notifylevel("phantunloaded0");
	sleep_s(1);
	cs_fly_to(e9_m4_phantom_0_pts.p5);
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_0.sp ), "phantom_sc01" );
	sleep_s(2);
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p6,e9_m4_phantom_0_pts.p10);
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_0.sp ), "phantom_sc02" );
	sleep_s(2);
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p11,e9_m4_phantom_0_pts.p12);
	sleep(1);
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p13,e9_m4_phantom_0_pts.p14);
	sleep_s(4);
	sleep(2);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	cs_vehicle_speed(3.15);
	cs_fly_to_and_face(e9_m4_phantom_0_pts.p15,e9_m4_phantom_0_pts.p16);
	cs_fly_to(e9_m4_phantom_0_pts.p7);
	cs_fly_to(e9_m4_phantom_0_pts.p8);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_phantom_drop_1            // GARDEN - Drops 2 ghosts, then a bunch of dudes, in the Garden, on side B
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	ai_place(sq_e9_m4_ghost_driver_0);
	ai_place(sq_e9_m4_ghost_driver_1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_1.sp), "phantom_sc01", ai_vehicle_get_from_spawn_point(sq_e9_m4_ghost_driver_0.sp));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_1.sp), "phantom_sc02", ai_vehicle_get_from_spawn_point(sq_e9_m4_ghost_driver_1.sp));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	cs_vehicle_speed (2.15);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.00, 90 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 70, 0, 0);
	cs_fly_to(e9_m4_phantom_1_pts.p13);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");
	notifylevel("VO_Phantom");
	ai_place(sq_e9_m4_guards_garden_1phant1);
	ai_place(sq_e9_m4_guards_garden_1phant2);
	ai_place(sq_e9_m4_guards_garden_1phant3);
	ai_place(sq_e9_m4_guards_garden_1phant4);
	ai_vehicle_enter_immediate(sq_e9_m4_guards_garden_1phant1, sq_e9_m4_null_phantom_driver_1, "phantom_p_lf");	
	ai_vehicle_enter_immediate(sq_e9_m4_guards_garden_1phant2, sq_e9_m4_null_phantom_driver_1, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e9_m4_guards_garden_1phant3, sq_e9_m4_null_phantom_driver_1, "phantom_p_rb");	
	ai_vehicle_enter_immediate(sq_e9_m4_guards_garden_1phant4, sq_e9_m4_null_phantom_driver_1, "phantom_p_lb");
	cs_fly_to_and_face(e9_m4_phantom_1_pts.p0,e9_m4_phantom_1_pts.p5);
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_1.sp ), "phantom_sc01" );
	sleep_s(1);
	cs_fly_to(e9_m4_phantom_1_pts.p1);
	sleep_s(1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_1.sp ), "phantom_sc02" );
	sleep_s(1);
	cs_vehicle_speed(0.85);
	cs_fly_to_and_face(e9_m4_phantom_1_pts.p6,e9_m4_phantom_1_pts.p7);
	f_unload_phantom (ai_current_squad, "dual");
	notifylevel("phantunloaded1");
	sleep_s(5);	
	cs_fly_to(e9_m4_phantom_1_pts.p8);
	sleep(1);
	cs_fly_to_and_face(e9_m4_phantom_1_pts.p10,e9_m4_phantom_1_pts.p9);
	sleep_s(3);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	cs_vehicle_speed(3.75);
	cs_fly_to_and_face(e9_m4_phantom_1_pts.p11,e9_m4_phantom_1_pts.p12);
	sleep(1);
	cs_fly_to(e9_m4_phantom_1_pts.p2);
	cs_fly_to(e9_m4_phantom_1_pts.p3);
	cs_fly_to(e9_m4_phantom_1_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script static void f_e9_m4_ghost_listener
	sleep_until(LevelEventStatus("e9_m4_ghost1away"),1);
	b_ghost_away = true;
end

script command_script cs_e9_m4_phantom_drop_2             // WRAITH DROPPER 1    Drops in a Wraith
	vehicle_ignore_damage_knockback(ai_current_actor,true);
	cs_force_combat_status (3); 	 
	ai_place(sq_e9_m4_wraith_driver_1);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_2.sp), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_1.sp));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	object_set_scale ( ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_1.sp), 0.01, 0 ); //Shrink size over time
	cs_vehicle_speed (1);	
	thread(f_track_wraith1());
	//thread(f_blip_wraith1());
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.00, 295 ); //Shrink size over time
	object_set_scale ( ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_1.sp), 1.00, 295 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 20, 0, 5);	
	cs_fly_to(e9_m4_phantom_2_pts.p8);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");
	//sleep(1);
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p8,e9_m4_phantom_2_pts.p9);
	cs_fly_to(e9_m4_phantom_2_pts.p0);
	sleep(33);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_2.sp ), "phantom_lc" );
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_wraith_driver_1), "navpoint_enemy_vehicle");
	notifylevel ("wraith1deployed");
	//sleep(1);
	cs_vehicle_speed (0.33);
	cs_fly_to(e9_m4_phantom_2_pts.p1);
	sleep(4);
	cs_fly_to(e9_m4_phantom_2_pts.p10);
	notifylevel("phantunloaded2");
	sleep_s(3);
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p5,e9_m4_phantom_2_pts.p11);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p11,e9_m4_phantom_2_pts.p5);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p12,e9_m4_phantom_2_pts.p13);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p13,e9_m4_phantom_2_pts.p12);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p14,e9_m4_phantom_2_pts.p15);
	sleep_s(5);	
	cs_fly_to_and_face(e9_m4_phantom_2_pts.p14,e9_m4_phantom_2_pts.p10);
	sleep_s(5);	
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	cs_vehicle_speed(0.75);
	cs_fly_to(e9_m4_phantom_2_pts.p2);
	cs_fly_to(e9_m4_phantom_2_pts.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 290 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 01);
	cs_fly_to(e9_m4_phantom_2_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end

script command_script cs_e9_m4_phantom_drop_3    // GARDEN - Precedes first Wraith, drops 2 ghosts, then does a gun-run of middle then leaves
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	b_wraith1deployed = true;
	ai_place(sq_e9_m4_ghost_driver_2);
	ai_place(sq_e9_m4_ghost_driver_3);
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_3.sp), "phantom_sc01", ai_vehicle_get_from_spawn_point(sq_e9_m4_ghost_driver_2.sp));
	vehicle_load_magic(ai_vehicle_get_from_spawn_point(sq_e9_m4_null_phantom_driver_3.sp), "phantom_sc02", ai_vehicle_get_from_spawn_point(sq_e9_m4_ghost_driver_3.sp));
	cs_vehicle_speed (4.15);	
	object_set_velocity(unit_get_vehicle(ai_current_actor), 15, 0, 12);
	cs_fly_to(e9_m4_phantom_3_pts.p6);
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p8,e9_m4_phantom_3_pts.p14);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");
	notifylevel("VO_Phantom2");
	cs_vehicle_speed (1);	
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p7,e9_m4_phantom_3_pts.p13);
	cs_vehicle_speed (1);	
	sleep(33);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_3.sp ), "phantom_sc01" );
	notifylevel("e9_m4_ghost1away");
	//sleep_s(1);
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p0,e9_m4_phantom_3_pts.p1);
	sleep(33);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e9_m4_null_phantom_driver_3.sp ), "phantom_sc02" );
	sleep_s(3);
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p7,e9_m4_phantom_3_pts.p13);
	sleep_s(5);
	cs_vehicle_speed (0.4);	
	cs_fly_to(e9_m4_phantom_3_pts.p15);
	sleep_s(5);
	cs_fly_to(e9_m4_phantom_3_pts.p2);
	sleep_s(6);
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p16,e9_m4_phantom_3_pts.p3);
	cs_vehicle_speed (1.15);	
	cs_vehicle_speed(1.85);
	cs_fly_to(e9_m4_phantom_3_pts.p9);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	sleep(10);
	cs_fly_to_and_face(e9_m4_phantom_3_pts.p9,e9_m4_phantom_3_pts.p10);	
	sleep_s(2);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 299 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 5, 0, 01);
	cs_fly_to(e9_m4_phantom_3_pts.p11);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);	
end	

script command_script cs_e9_m4_phantom_drop_6
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_vehicle_speed (4.0);	
	cs_fly_to_and_face(e9_m4_phantom_6_pts.p0,e9_m4_phantom_6_pts.p1);
	sleep_s(1);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");   // BLIP PHANT
	thread(f_e9_m4_phant_callouts());
	//notifylevel("VO_Phantom");
	cs_fly_to(e9_m4_phantom_6_pts.p2);	
	sleep_s(4);
	ai_place(sq_e9_m4_guards_diamond_backup1);
	sleep(1);
	ai_place(sq_e9_m4_guards_diamond_backup2);
	sleep(1);
	ai_place(sq_e9_m4_guards_diamond_backupA);
	sleep(1);
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backup1, sq_e9_m4_null_phantom_driver_6, "phantom_p_lf");
	sleep(1);
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backup2, sq_e9_m4_null_phantom_driver_6, "phantom_p_rf");
	sleep(1);
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backupA, sq_e9_m4_null_phantom_driver_6, "phantom_p_rb");
	sleep(1);
	cs_fly_to(e9_m4_phantom_6_pts.p11);	
	if b_players_initial_pos == false then  //players not in initial area, so spawn enemies at initial area
		sleep_until (b_rear_DZ_blocked == false, 1); //anyone in the way?
		b_rear_DZ_blocked = true;												// if not, then I AM!
		cs_fly_to_and_face(e9_m4_phantom_6_pts.p9,e9_m4_phantom_6_pts.p10);
		sleep(1);
		cs_fly_to(e9_m4_phantom_6_pts.p3);
		sleep(1);
		f_unload_phantom (ai_current_squad, "dual");	
		notifylevel("phantunloaded6");
		cs_vehicle_speed(1);
		sleep_s(1);
		cs_fly_to_and_face(e9_m4_phantom_6_pts.p9,e9_m4_phantom_6_pts.p10);
		sleep_s(5);
		b_rear_DZ_blocked = false;											// im no longer in the way
	else																		//players in initial area, so spawn enemies at back (door) area
		sleep_until (b_front_DZ_blocked == false, 1);    //anyone in the way?
		b_front_DZ_blocked = true;												// if not, then I AM!
		cs_fly_to(e9_m4_phantom_6_pts.p12);	
		sleep(1);
		cs_fly_to_and_face(e9_m4_phantom_6_pts.p13,e9_m4_phantom_6_pts.p14);
		sleep(1);
		f_unload_phantom (ai_current_squad, "dual");	
		notifylevel("phantunloaded6");
		cs_vehicle_speed(1);
		sleep_s(1);	
		cs_fly_to(e9_m4_phantom_6_pts.p12);
		sleep_s(5);
		b_front_DZ_blocked = false;											// im no longer in the way
	end
	cs_vehicle_speed(4.0);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);     // UNBLIP PHANT
	cs_fly_to_and_face(e9_m4_phantom_6_pts.p4,e9_m4_phantom_6_pts.p5);	
	cs_fly_to_and_face(e9_m4_phantom_6_pts.p6,e9_m4_phantom_6_pts.p7);
	cs_fly_to(e9_m4_phantom_6_pts.p8);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	
 
script command_script cs_e9_m4_phantom_drop_7
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_vehicle_speed (4.0);	
	cs_fly_by(e9_m4_phantom_7_pts.p0);
	cs_fly_by(e9_m4_phantom_7_pts.p2);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");   // BLIP PHANT
	notifylevel("VO_Phantom");
	cs_fly_by(e9_m4_phantom_7_pts.p3);
	cs_fly_to_and_face(e9_m4_phantom_7_pts.p4,e9_m4_phantom_7_pts.p5);
	sleep(1);
	ai_place(sq_e9_m4_guards_diamond_backup3);
	ai_place(sq_e9_m4_guards_diamond_backup4);
	ai_place(sq_e9_m4_guards_diamond_backupB);
	sleep(1);
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backup3, sq_e9_m4_null_phantom_driver_7, "phantom_p_lf");
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backup4, sq_e9_m4_null_phantom_driver_7, "phantom_p_rf");
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backupB, sq_e9_m4_null_phantom_driver_7, "phantom_p_rb");
	if b_players_initial_pos == false then  //players not in initial area, so spawn enemies at initial area
		sleep_until (b_rear_DZ_blocked == false or (ai_living_count(sq_e9_m4_null_phantom_driver_6) <= 0), 1);    //anyone in the way?
		b_rear_DZ_blocked = true;												// if not, then I AM!
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p14,e9_m4_phantom_7_pts.p15);
		sleep(1);
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p8,e9_m4_phantom_7_pts.p9);
		sleep(1);
		f_unload_phantom (ai_current_squad, "dual");	
		notifylevel("phantunloaded7");
		cs_vehicle_speed(0.62);
		sleep_s(1);
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p14,e9_m4_phantom_7_pts.p15);
		sleep_s(2.5);
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p15,e9_m4_phantom_7_pts.p14);
		sleep_s(3.5);
		b_rear_DZ_blocked = false;														// im no longer in the way	
	else																		//players in initial area, so spawn enemies at back (door) area	
		sleep_until (b_front_DZ_blocked == false or (ai_living_count(sq_e9_m4_null_phantom_driver_6) <= 0), 1);    //anyone in the way?
		b_front_DZ_blocked = true;												// if not, then I AM!
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p6,e9_m4_phantom_7_pts.p7);
		sleep(1);
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p10,e9_m4_phantom_7_pts.p11);
		sleep(1);
		f_unload_phantom (ai_current_squad, "dual");	
		notifylevel("phantunloaded7");
		cs_vehicle_speed(0.62);
		sleep_s(1);	
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p6,e9_m4_phantom_7_pts.p7);
		sleep_s(2.5);
		cs_fly_to_and_face(e9_m4_phantom_7_pts.p7,e9_m4_phantom_7_pts.p6);
		sleep_s(3.5);
		b_front_DZ_blocked = false;														// im no longer in the way	
	end
	cs_vehicle_speed(0.8);
	cs_fly_to(e9_m4_phantom_7_pts.p12); 
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);  // UNBLIP PHANT
	cs_fly_to(e9_m4_phantom_7_pts.p13);
	sleep_s(1);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_phantom_drop_8
	vehicle_ignore_damage_knockback(ai_current_actor,true);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	cs_force_combat_status (3);
	cs_vehicle_speed (4.0);	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 70 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 49, 0, 0);
	cs_fly_by(e9_m4_phantom_8_pts.p0);
	cs_fly_by(e9_m4_phantom_8_pts.p2);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");      // BLIP PHANT
	notifylevel("VO_Phantom");
	cs_fly_to_and_face(e9_m4_phantom_8_pts.p4,e9_m4_phantom_8_pts.p5);
	sleep(1);
	cs_fly_to_and_face(e9_m4_phantom_8_pts.p6,e9_m4_phantom_8_pts.p7);
	sleep(1);	
	ai_place(sq_e9_m4_guards_diamond_backup5);
	ai_place(sq_e9_m4_diamond_drop_pod_3); //hunters
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp), "phantom_pc_1", ai_get_unit (sq_e9_m4_diamond_drop_pod_3.spawn_points_0));
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp), "phantom_pc_4", ai_get_unit (sq_e9_m4_diamond_drop_pod_3.spawn_points_1));	
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp), "phantom_pc_2", ai_get_unit (sq_e9_m4_guards_diamond_backup5.spawn_points_0));
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp), "phantom_pc_3", ai_get_unit (sq_e9_m4_guards_diamond_backup5.spawn_points_1));
	ai_vehicle_enter_immediate(sq_e9_m4_guards_diamond_backup5, sq_e9_m4_null_phantom_driver_8, "phantom_p_rf");
	if b_players_initial_pos == false then  //players not in initial area, so spawn enemies at initial area
		sleep_until (b_rear_DZ_blocked == false or (ai_living_count(sq_e9_m4_null_phantom_driver_6) + ai_living_count(sq_e9_m4_null_phantom_driver_7) <= 0), 1);    //anyone in the way?
		b_rear_DZ_blocked = true;												// if not, then I AM!
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p14,e9_m4_phantom_8_pts.p15);
		sleep(1);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p10,e9_m4_phantom_8_pts.p11);
		sleep(1);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_2");
		sleep(55);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_3");
		f_unload_phantom (ai_current_squad, "right");	
		sleep(105);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p11,e9_m4_phantom_8_pts.p10);
		sleep(75);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_1");
		sleep(55);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_4");	
		notifylevel("phantunloaded8");
		sleep(75);		
		cs_vehicle_speed(0.62);
		sleep_s(1);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p14,e9_m4_phantom_8_pts.p15);
		sleep_s(5);	
		b_rear_DZ_blocked = false;											// im no longer in the way
	else																		//players in initial area, so spawn enemies at back (door) area
		sleep_until (b_front_DZ_blocked == false or (ai_living_count(sq_e9_m4_null_phantom_driver_6) + ai_living_count(sq_e9_m4_null_phantom_driver_7) <= 0), 1);    //anyone in the way?
		b_front_DZ_blocked = true;                        // if not, then I AM!
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p19,e9_m4_phantom_8_pts.p18);
		sleep_s(1);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p16,e9_m4_phantom_8_pts.p17);
		sleep(1);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_2");
		sleep(55);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_3");
		f_unload_phantom (ai_current_squad, "right");	
		sleep(105);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p17,e9_m4_phantom_8_pts.p16);
		sleep(75);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_1");
		sleep(55);
		vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_8.sp)), "phantom_pc_4");
		notifylevel("phantunloaded8");
		sleep(75);		
		cs_vehicle_speed(0.62);
		sleep_s(1);
		cs_fly_to_and_face(e9_m4_phantom_8_pts.p19,e9_m4_phantom_8_pts.p18);
		sleep_s(5);	
		b_front_DZ_blocked = false;											// im no longer in the way
	end
	cs_vehicle_speed(0.8);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);    // UNBLIP PHANT
	cs_fly_to(e9_m4_phantom_8_pts.p12);
	cs_vehicle_speed(4);
	cs_fly_to(e9_m4_phantom_8_pts.p13);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_phantom_drop_10     // DROPS 2 HUNTERS THEN FINAL WRAITH (#2)
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	ai_place(sq_e9_m4_wraith_driver_2);
	ai_place(sq_e9_m4_guards_garden_3hunterA);
	vehicle_load_magic(ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp), "phantom_lc", ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_2.sp));
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp), "phantom_pc_1", ai_get_unit (sq_e9_m4_guards_garden_3hunterA.spawn_points_0));
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp), "phantom_pc_4", ai_get_unit (sq_e9_m4_guards_garden_3hunterA.spawn_points_1));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	object_set_scale ( (ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_2.sp)), 0.01, 0 ); //grow size over time
	sleep(1);
	thread(dafaq_is_going_on_wraith_fail_recovery_procedure());
	cs_vehicle_speed (4.0);	
	sleep(1);	
	sleep(3);	
	thread(f_track_wraith2());
	//thread(f_blip_wraith2());
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 250 ); //Shrink size over time
	object_set_scale (( ai_vehicle_get_from_spawn_point(sq_e9_m4_wraith_driver_2.sp) ), 1.0, 250 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 25, 0, -14);
	sleep(1);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");
	notifylevel("VO_Phantom2");
	cs_vehicle_speed (1.2);	
	cs_vehicle_speed(1);
	sleep(4);
	cs_fly_by(e9_m4_phantom_10_pts.p8);
	sleep(40);
	notifylevel("HuntersInc");
	vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp)), "phantom_pc_1");
	sleep(55);
	vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp)), "phantom_pc_4");
	sleep_s(1);	
	cs_fly_to_and_face(e9_m4_phantom_10_pts.p2,e9_m4_phantom_10_pts.p3);
	vehicle_unload(ai_vehicle_get (sq_e9_m4_null_phantom_driver_10.sp), "phantom_lc" );
	sleep_s(1);	
	notifylevel ("wraith2deployed");
	//navpoint_track_object_named (unit_get_vehicle(sq_e9_m4_wraith_driver_2), "navpoint_enemy_vehicle");
	thread(vo_glo15_miller_wraith_01());  // Miller : Wraith!());
	sleep(4);
	cs_fly_by(e9_m4_phantom_10_pts.p9);
	sleep(199);
	cs_fly_to_and_face(e9_m4_phantom_10_pts.p12,e9_m4_phantom_10_pts.p14);
	sleep(199);
	cs_fly_to_and_face(e9_m4_phantom_10_pts.p14,e9_m4_phantom_10_pts.p12);
	sleep(199);
	cs_fly_by(e9_m4_phantom_10_pts.p9);
	sleep(199);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	cs_vehicle_speed(2.85);
	cs_fly_by(e9_m4_phantom_10_pts.p5);	
	sleep(1);
	cs_vehicle_speed(4.0);
	cs_fly_to_and_face(e9_m4_phantom_10_pts.p6,e9_m4_phantom_10_pts.p7);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 490 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 3, 0, 0);
	cs_fly_to(e9_m4_phantom_10_pts.p7);
	sleep(1);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	
	
script command_script cs_e9_m4_phantom_drop_11     // HUNTER DROPPER -- FINAL PHANTOM IN GARDEN. Does gunrun of middle, then drops em into center up top
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	cs_ignore_obstacles(true);
	ai_place(sq_e9_m4_guards_garden_3hunterB);
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_11.sp), "phantom_pc_1", ai_get_unit (sq_e9_m4_guards_garden_3hunterB.spawn_points_0));
	vehicle_load_magic (ai_vehicle_get (sq_e9_m4_null_phantom_driver_11.sp), "phantom_pc_4", ai_get_unit (sq_e9_m4_guards_garden_3hunterB.spawn_points_1));
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 ); //Shrink size over time
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 300 ); //grow size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 15, 0, -5);
	cs_vehicle_speed (2.0);	
	cs_fly_by(e9_m4_phantom_11_pts.p1);
	cs_vehicle_speed (1.1);	
	cs_fly_by(e9_m4_phantom_11_pts.p12);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), "navpoint_enemy_vehicle");         // BLIP PHANT
	//notifylevel("VO_Phantom");
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p4,e9_m4_phantom_11_pts.p5);
	cs_vehicle_speed(0.50);
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p2,e9_m4_phantom_11_pts.p3);
	sleep(45);
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p10,e9_m4_phantom_11_pts.p7);
	sleep(135);
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p9,e9_m4_phantom_11_pts.p6);
	sleep(135);
	cs_fly_to(e9_m4_phantom_11_pts.p11);
	vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_11.sp)), "phantom_pc_1");
	sleep(55);
	vehicle_unload ((ai_vehicle_get (sq_e9_m4_null_phantom_driver_11.sp)), "phantom_pc_4");
	sleep(55);
	notifylevel ("finalphant2");
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p14,e9_m4_phantom_11_pts.p6);
	sleep_s(3);
	cs_fly_to_and_face(e9_m4_phantom_11_pts.p6,e9_m4_phantom_11_pts.p14);
	sleep_s(3);
	cs_fly_by(e9_m4_phantom_11_pts.p15);
	cs_vehicle_speed(1.55);
	sleep(1);
	//navpoint_track_object_named (unit_get_vehicle(ai_current_actor), false);
	cs_fly_by(e9_m4_phantom_11_pts.p16);
	sleep(1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 490 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 3, 0, 0);
	cs_fly_by(e9_m4_phantom_11_pts.p17);
	sleep(1);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

script command_script cs_e9_m4_donut_end_fake_phantom_9
	vehicle_ignore_damage_knockback(ai_current_actor,true); 
	cs_force_combat_status (3);
	sleep_until(volume_test_players (e9_m4_garden_trigger));
	sleep_s(2);
	cs_fly_to_and_face(e9_m4_phantom_9_pts.p0,e9_m4_phantom_9_pts.p1);
	sleep_s(6);
	cs_fly_to_and_face(e9_m4_phantom_9_pts.p1,e9_m4_phantom_9_pts.p0);
	sleep_s(6);
	cs_fly_to_and_face(e9_m4_phantom_9_pts.p2,e9_m4_phantom_9_pts.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 90 ); //Shrink size over time
	object_set_velocity(unit_get_vehicle(ai_current_actor), 170, 0, 0);
	cs_fly_to(e9_m4_phantom_9_pts.p4);
	object_destroy(ai_vehicle_get ( ai_current_actor ));
	sleep(5);
	e9_m4_phantom_despawn_hack(ai_current_squad);
end	

//===================================================================================================
//======== GLOBAL VO CALLOUT FUNCTIONS ==============================================================
//===================================================================================================

script static void vo_miller_heavy_01()
global_narrative_is_on = TRUE;
// Miller : They're wheeling in the big guns, Crimson.
dprint ("Miller: They're wheeling in the big guns, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_heavy_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_heavy_01'));	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_shoot_03a()
global_narrative_is_on = TRUE;
// Miller : Light 'em up.
dprint ("Miller: Light 'em up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03'));	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_keepitup_02a()
global_narrative_is_on = TRUE;
// Miller : Keep it up.
dprint ("Miller: Keep it up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_miller_contacts_05()
global_narrative_is_on = true;
// Miller : Covenant inbound!
dprint ("Miller: Covenant inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_05'));
end_radio_transmission();
global_narrative_is_on = false;
end

script static void vo_miller_contacts_06()
global_narrative_is_on = TRUE;
// Miller : Heads up!
dprint ("Miller: Heads up!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06'));
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void f_e9_m4_heavy_forces2_callout
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
					dprint("THEYRE WHEELING IN THE BIG GUNS CRIMSON!!");
				end
				thread(vo_miller_heavy_01());
				sleep_s(2);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
end

script static void f_e9_m4_heavy_forces_callout
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
					dprint("HEAVY FORCES IN THE AREA!");
				end
				thread(vo_glo_heavyforces_03());
				sleep_s(2);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
end

script static void f_e9_m4_keep_it_up_callout
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
					dprint("KEEP IT UP!");
				end
				thread(vo_miller_keepitup_02a());
				sleep_s(1);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
end

script static void f_e9_m4_shoot_callout
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
					dprint("Light em up!");
				end
				thread(vo_miller_shoot_03a());
				sleep_s(1);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
end



script static void f_e9_m4_hunter_callouts
	repeat		
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
				end
				thread(vo_glo15_miller_hunters_01());
				sleep_s(1);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
		sleep_until (LevelEventStatus("Hunters") or b_e9_m4_mission_over == true, 1);
	until (b_e9_m4_mission_over == true, 1);
end


script static void f_e9_m4_phant_callouts
	local real times = 0;
	repeat		
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(1));
				if editor_mode() then
					sleep(1);
				end
				if times == 0 then
					thread(vo_glo_phantom_09());   	// Miller : Uh oh. Phantom inbound!
				elseif times == 1 then
					thread(vo_glo_phantom_07());   	// Miller : Look out, there's a Phantom headed your way!
				elseif times == 2 then
					thread(vo_glo15_dalton_phantom_02());    // Dalton : Phantom inbound on Crimson's position.
				elseif times == 3 then
					thread(vo_glo15_miller_phantom_01()); // Miller: Phantom on Approach
				elseif times == 4 then
					thread(vo_glo_phantom_10());    // Miller : Oh boy, Crimson, Phantom!
				end
				sleep_s(2);		
				b_e9m4_narrative_is_on = false;
			else
				dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
				sleep(1);
			end
			sleep(1);
		end
		times = times + 1;
		sleep_until (LevelEventStatus("VO_Phantom") or b_e9_m4_mission_over == true, 1);
	until (b_e9_m4_mission_over == true, 1);
end

script static void f_e9_m4_phant2_callouts
	local real r_phant2_times = 0;
	repeat
		sleep_until (LevelEventStatus("VO_Phantom2") or b_e9_m4_mission_over == true, 1);		
		if b_e9_m4_mission_over == true then
			sleep(1);
		else
			if b_callout_was_just_called == false then
				sleep_until (b_e9m4_narrative_is_on == false, 1);
				b_e9m4_narrative_is_on = true;
				thread(calloutcooldowntimer(3));
				if editor_mode() then
					sleep(1);
				end
				if r_phant2_times == 0 then
					thread(vo_miller_contacts_05());  // Miller : Covenant inbound!
				elseif r_phant2_times == 1 then
					thread(vo_glo15_miller_reinforcements_03());  // Miller : Additional targets inbound!
				end
				sleep_s(2);		
				b_e9m4_narrative_is_on = false;
			else
				sleep(1);
			end
			r_phant2_times = r_phant2_times + 1;
			sleep(1);
		end
	until (b_e9_m4_mission_over == true, 1);
end



script static void f_e9_m4_droppod_callouts
	local real times = 0;
	repeat
		sleep_until (LevelEventStatus("VO_droppod"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m4_narrative_is_on == false, 1);
			b_e9m4_narrative_is_on = true;
			thread(calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
			end	
			if times == 0 then
				thread(vo_glo_droppod_01());     // Miller : Drop pod incoming!
			elseif times == 1 then
				thread(vo_miller_contacts_06()); // Miller : Heads Up!
			end
			sleep_s(1);		
			b_e9m4_narrative_is_on = false;
		else
			sleep(1);
		end
		times = times + 1;
	until (b_e9_m4_mission_over == true, 1);
end

script static void f_e9_m4_droppods_callouts
	local real times = 0;
	repeat
		sleep_until (LevelEventStatus("VO_droppods"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m4_narrative_is_on == false, 1);
			b_e9m4_narrative_is_on = true;
			thread(calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
			end	
			if times == 0 then
				thread(vo_glo15_dalton_droppods_01());    // Dalton : This is Dalton, drop pods inbound.
			elseif times == 1 then
				thread(vo_glo_droppod_05()); 	 // Miller : Drop pods coming down near your position, Crimson!
			end
			sleep_s(1);		
			b_e9m4_narrative_is_on = false;
		else
			sleep(1);
		end
	until (b_e9_m4_mission_over == true, 1);
end

script static void f_e9_m4_lasttargets_callouts		
	local real callout = 0;
	repeat
	sleep(3);
	sleep_until(LevelEventStatus("lasttargets"), 1);
	dprint("MESSAGE RECEIVED TO BLIP TARGETS, LETS DECIDE WHAT TO DO");
	if b_callout_was_just_called == false then
		sleep_until (b_e9m4_narrative_is_on == false, 1);
		if (ai_living_count(gr_e9_m4_ai_all) > 0) then
			dprint("BLIPPING LAST ENEMIES NOW!!!! ---------- VO FOR BLIPPIN");
			b_e9m4_narrative_is_on = true;
			thread(calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
			end
			if callout == 0 then
				vo_glo_lasttargets_03();  // Miller : Crimson, got a few left.
			elseif callout == 1 then
				vo_glo_lasttargets_04();  // Miller : Here's the last of them.
			elseif callout == 2 then
				vo_glo_remainingcov_01();  // Miller : Just a few Covies left. I'll get markers on them. 
			elseif callout == 3 then
				vo_glo_remainingcov_04();  // Miller : Just a few Covenant remaining. Marking them for you. 
			elseif callout == 4 then
				vo_glo_lasttargets_01();  // Miller : Painting the last targets for you now.
			elseif callout == 5 then
				vo_glo_lasttargets_02();  // Miller : Just a few stragglers, Crimson.
			elseif callout == 6 then
				vo_glo_lasttargets_03();  // Miller : Crimson, got a few left.
			else
				vo_glo_lasttargets_04();  // Miller : Here's the last of them.
			end	
			sleep(67);  // sleep for just over 2 secs cos longest vo callout is like 1.735 secs long
			b_e9m4_narrative_is_on = false;	
		else
			dprint ("OH SNAP NO BADGUYS LEFT TO BLIP!!! (ABORTING BLIP CALL)!!");
			sleep(1);
		end			
	else
	 dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
	 sleep(1);
	end		
	callout = callout + 1;
	//until (b_e9_m4_mission_over == true or (times == 3), 1);
	until (b_e9_m4_mission_over == true, 1);
end

script static void f_e9_m4_watchout_callouts
		if b_callout_was_just_called == false then
			sleep_until (b_e9m4_narrative_is_on == false, 1);
			b_e9m4_narrative_is_on = true;
			thread(calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
				//dprint("WATCH OUT!");
			else
				thread(vo_glo_watchout_07());
			end
			sleep_s(1);
			b_e9m4_narrative_is_on = false;	
		else
			sleep(1);
			//dprint ("CALLOUT WAS JUST CALLED SO IM NOT GONNA CALL EM OUT FOR A WHILE!!!");
		end
end

script static void f_e9_m4_grats_callouts
	local real times = 0;
	repeat
		sleep_until (LevelEventStatus("grats"), 1);
		if b_callout_was_just_called == false then
			sleep_until (b_e9m4_narrative_is_on == false, 1);
			b_e9m4_narrative_is_on = true;
			thread(calloutcooldowntimer(1));
			if editor_mode() then
				sleep(1);
			end	
			if times == 0 then
				vo_glo15_miller_attaboy_01();
			elseif times == 1 then
				vo_glo15_miller_allclear_02();
			elseif times == 2 then
				vo_glo15_miller_attaboy_03();
			elseif times == 3 then
				vo_glo15_miller_attaboy_04();
			end
			//sleep_s(8);		
			b_e9m4_narrative_is_on = false;
		else
			sleep(1);
		end
		times = times + 1;
	until (b_e9_m4_mission_over == true, 1);
end



script static void calloutcooldowntimer(real countdown)
	r_countdowns_in_progress = r_countdowns_in_progress + 1;
	if r_countdowns_in_progress == 1 then
		b_callout_was_just_called = true;
		sleep_s(countdown);
		b_callout_was_just_called = false;
	end
	r_countdowns_in_progress = r_countdowns_in_progress - 1;
end

script static void calloutHuntersCheck
	sleep_until(LevelEventStatus("HuntersInc"));
	if volume_test_players (e9_m4_garden_hunter_squish_trigger) == true then
		thread(f_e9_m4_watchout_callouts());
	end
end