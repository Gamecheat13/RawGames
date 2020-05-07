//=============================================================================================================================
//============================================ CHOPPERBOWL E5_M5 SPARTAN OPS SCRIPT ==================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================

global short e5m5_locations_visited = 0;
global boolean e5m5_errrbodytothehill = FALSE;
global boolean e5m5_rvbeasteregg = FALSE;
global boolean e5m5_stopwiththehammers = FALSE;
global boolean e5m5_stopwiththesplasers = FALSE;
global boolean e5m5_gettoshades = FALSE;
global boolean e5m5_narrativein_done = FALSE;
global boolean e5m5_rvb_is_on = FALSE;
global boolean e5m5_narrativeout_done = FALSE;
global boolean e5m5_phantom05_5_dropload = FALSE;
global boolean e5m5_loc02_over = FALSE;
global boolean e5m5_timetomove = FALSE;
global boolean e5m5_last3_follow = FALSE;
global boolean e5m5_pelican_stopped = FALSE;
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 05: Mission 05																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//


//343++343==343++343==343++343//	E5M5 Variant Startup Script	//343++343==343++343==343++343//

script startup e5m5_chopperbowl_startup
	sleep_until (LevelEventStatus ("e5m5_var_startup"), 1);
	ai_ff_all = e5m5_ff_all;
	dm_droppod_1 = e5m5_drop_01;
	dm_droppod_2 = e5m5_drop_02;
	dm_droppod_3 = e5m5_drop_03;
	dm_droppod_4 = e5m5_drop_04;
	dm_droppod_5 = e5m5_drop_05;
	print ("E5M5 starting up!");
	thread(f_music_e5m5_start());
	switch_zone_set (e5m5_outnumbered);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e5_m5.scenery", "objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	thread (e5m5_destroytowers());
	e5m5_narrativein_done = FALSE;
	e5m5_narrativeout_done = FALSE;
	e5m5_phantom05_5_dropload = FALSE;
	e5m5_rvb_is_on = FALSE;
	e5m5_loc02_over = FALSE;
	e5m5_timetomove = FALSE;
	e5m5_last3_follow = FALSE;
	kill_volume_disable (kill_soft_e3_m1_vip);
	kill_volume_disable (kill_e3_m1_tower_1);
	kill_volume_disable (kill_e3_m1_tower_2);
	//	 Set "Squad Groups"
	firefight_mode_set_squad_at(gr_e5m5_templategroups, 9); 									//	Squad Templates
	//	Add "Crates" Folders	//
	f_add_crate_folder (e5m5_equipment);																			//	Adds Ammo equipment
	f_add_crate_folder (cr_e5m5_unsc_props);																	//	Prop Crates for UNSC small bases around E5M5
	f_add_crate_folder (cr_e5m5_unsc_weaponracks);														//	Weapon Racks for UNSC small bases around E5M5
	f_add_crate_folder (cr_e5m5_cov_props);																		//	Prop Crates for covenant areas around E5M5
	f_add_crate_folder (cr_e5m5_cov_weaponracks);															//	Weapon Racks for covenant areas around E5M5
	//	Add "Vehicles" Folders
	f_add_crate_folder (e5m5_veh_unsc);																				//	UNSC Vehicles for E5M5
	f_add_crate_folder (e5m5_veh_cov);																				//	Cov Vehicles for E5M5
	f_add_crate_folder (e5m5_veh_turret);																			//	Turrets for E5M5
	//	Add "Spawn" Folders
	firefight_mode_set_crate_folder_at(e5m5_spawn_01, 50);										//	Initial Spawn Area for E5M5	
	firefight_mode_set_crate_folder_at(e5m5_spawn_02, 49);										//	Second Spawn Area for E5M5	
	firefight_mode_set_crate_folder_at(e5m5_spawn_03, 48);										//	Third Spawn Area for E5M5	
	firefight_mode_set_crate_folder_at(e5m5_spawn_04, 47);										//	Replacement second Spawn Area for E5M5	
	
	firefight_mode_set_player_spawn_suppressed(TRUE);
	if editor_mode() then
		thread (vo_e5m5_intro());
		thread (e5m5_firstenemies());
		thread(f_music_e5m5_vignette_start());
		e5m5_narrativein_done = TRUE;
		thread(f_music_e5m5_vignette_finish());
		firefight_mode_set_player_spawn_suppressed(FALSE);
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		fade_in (0,0,0,15);
	else
		sleep_until (LevelEventStatus ("loadout_screen_complete"), 1);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m5_vin_sfx_intro', NONE, 1);
		cinematic_start();
		thread (vo_e5m5_intro());
		pup_play_show (e5_m5_intro);
		thread (e5m5_firstenemies());
		thread(f_music_e5m5_vignette_start());
		sleep_until (e5m5_narrativein_done == TRUE);
		cinematic_stop();
		thread(f_music_e5m5_vignette_finish());
		sleep (15);
		firefight_mode_set_player_spawn_suppressed(FALSE);
		sleep_until (b_players_are_alive(), 1);
		print ("player is alive");
		sleep_s (0.5);
		sleep (30 * 1);
		fade_in (0,0,0,15);
	end
end

//343++343==343++343==343++343//	E5M5 Goal 01 Scripts (0. time_passed)	//343++343==343++343==343++343//

script static void e5m5_firstenemies()
	ai_place (sq_e5m5_shade_01);
	ai_place (sq_e5m5_shade_02);
	ai_place (sq_e5m5_shade_03);
	ai_place (sq_e5m5_turret_01);
	ai_place (sq_e5m5_turret_02);
	ai_place (sq_e5m5_1jak_03);
	ai_place (sq_e5m5_3eli_01);
	ai_place (sq_e5m5_2gru_01);
	ai_place (sq_e5m5_3gru_01);
	ai_place (sq_e5m5_wraith_01);
	ai_place (sq_e5m5_1ghost_01);
	ai_place (sq_e5m5_1ghost_02);
	ai_place (sq_e5m5_2eli_03);
	ai_place_in_limbo (sq_e5m5_phantom_02);
	thread (e5m5_snipercallout());
	thread (e5m5_endgoal01());
	thread (e5m5_g1_threads());
	thread (e5m5_rvb_checker());
	sleep_until (e5m5_narrative_is_on == FALSE);
	f_new_objective (e5m5_obj_findthorn);
end


script static void e5m5_snipercallout()
	sleep_until (volume_test_players (tv_e5m5_snipertrigger), 1);
	if	(ai_living_count (sq_e5m5_1jak_03) == 1)	then
		sleep (30 * 1);
		thread (vo_e5m5_sniper());
		sleep (30 * 1);
		sleep_until (e5m5_narrative_is_on == FALSE);
		f_blip_ai (sq_e5m5_1jak_03, neutralize);
	else
		sleep (30 * 1);
		print ("sniper is dead");
	end
end


script static void e5m5_endgoal01()
	sleep_until (volume_test_players (tv_e5m5_location01), 1);
	thread(f_music_e5m5_endgoal01());
	sleep (30 * 1);
	f_unblip_flag (fl_e5m5_area01);
	thread (vo_e5m5_nothere());
	f_objective_complete();
	sleep (30 * 1);
	sleep_until (e5m5_narrative_is_on == FALSE);
	b_end_player_goal = TRUE;
end


script static void e5m5_rvb_checker()
	print ("start RVB");
	object_create (e5m5_rvb_radio);
	sleep_until (object_get_health (e5m5_rvb_radio) < 1, 1);
	print ("rvb interacted");
	object_cannot_take_damage (e5m5_rvb_radio);
	// f_new_objective (rvb_confirm);
	e5m5_rvb_is_on = TRUE;
	inspect (e5m5_rvb_is_on);
	print ("RVB TIIIIIIIIIIIIIIME!!!!!!!");
	f_achievement_spops_1();
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\redvsblue_maintitletheme'));
end


//343++343==343++343==343++343//	E5M5 Goal 02 Scripts (1. no_more_waves)	//343++343==343++343==343++343//

script static void e5m5_g1_threads()
	thread (e5m5_nmw01_start());
	thread (e5m5_g1_changeobj());
	thread (e5m5_g1_2ndwave());
	thread (e5m5_g1_3rdwave());
	thread (e5m5_g1_4thwave());
	thread (e5m5_g1_5thwave());
	thread (e5m5_g1_6thwave());
	thread (e5m5_g1_areamove());
	thread (e5m5_g1_7thwave());
end

script static void e5m5_nmw01_start()
	sleep_until (LevelEventStatus ("e5m5_nmw01"), 1);
	thread(f_music_e5m5_nmw01_start());
	sleep (30 * 3);
	thread (e5m5_location2_start());
	thread (e5m5_location02_vo_start());
	sleep (30 * 2);
	f_new_objective (e5m5_obj_clearout);
	thread (e5m5_reinforcementsreminder());
end

script static void e5m5_g1_changeobj()
	sleep_until (LevelEventStatus ("e5m5_g1_changeobj"), 1);
	thread(f_music_e5m5_g1_changeobj());
	print ("New Goal, Changing objective");
	e5m5_errrbodytothehill = TRUE;
end

script static void e5m5_reinforcementsreminder()
	sleep (30 * 120);
	thread (vo_e5m5_covenant_reinforcements());
end

script static void e5m5_g1_2ndwave()
	sleep_until (LevelEventStatus ("e5m5_g1_secondwave"), 1);
	thread(f_music_e5m5_g1_2ndwave());
	ai_place_in_limbo (sq_e5m5_phantom_04);
	print ("1st phantom");
	thread (vo_e5m5_covenant_03());
end

script static void e5m5_g1_3rdwave()
	sleep_until (LevelEventStatus ("e5m5_g1_thirdwave"), 1);
	thread(f_music_e5m5_g1_3rdwave());
	ai_place_in_limbo (sq_e5m5_phantom_04_1);
	print ("2nd phantom");
end

script static void e5m5_g1_4thwave()
	sleep_until (LevelEventStatus ("e5m5_g1_fourthwave"), 1);
	thread(f_music_e5m5_g1_4thwave());
	ai_place_in_limbo (sq_e5m5_phantom_04_2);
	print ("3rd phantom");
end

script static void e5m5_g1_5thwave()
	sleep_until (LevelEventStatus ("e5m5_g1_fifthwave"), 1);
	thread(f_music_e5m5_g1_5thwave());
	ai_place (sq_e5m5_wraith_02);
	ai_place (sq_e5m5_phantom_03);
	print ("wraith phantom");
	f_new_objective (e5m5_obj_clearout);
end

script static void e5m5_g1_6thwave()
	sleep_until (LevelEventStatus ("e5m5_g1_sixthwave"), 1);
	thread(f_music_e5m5_g1_6thwave());
	ai_place_in_limbo (sq_e5m5_phantom_04_3);
	print ("4th phantom");
	sleep (30 * 2);
	sleep_until (ai_living_count (e5m5_ff_all) <= 5, 1);
	thread (vo_e5m5_callouts_01());
end

script static void e5m5_g1_areamove()
	sleep_until (LevelEventStatus ("e5m5_movetime"), 1);
	e5m5_timetomove = TRUE;
	print ("time to move!");
end


script static void e5m5_g1_7thwave()
	sleep_until (LevelEventStatus ("e5m5_g1_seventhwave"), 1);
	thread(f_music_e5m5_g1_7thwave());
	ai_place (sq_e5m5_1ghost_03);
	ai_place (sq_e5m5_1ghost_04);
	ai_place_in_limbo (sq_e5m5_phantom_05);
	print ("4th phantom");
end

//343++343==343++343==343++343//	E5M5 Goal 03 Scripts (2. time_passed)	//343++343==343++343==343++343//

script static void e5m5_location2_start()
	sleep_until (LevelEventStatus ("e5m5_location2"), 1);
	thread(f_music_e5m5_location2_start());
	thread (e5m5_g4_threads());
	sleep_until (ai_living_count (e5m5_ff_all) <= 13, 1);
	ai_place (sq_e5m5_1ghost_05);
	ai_place (sq_e5m5_1ghost_06);
	ai_place_in_limbo (sq_e5m5_phantom_05_1);
	sleep (10);
	sleep_until (ai_living_count (e5m5_ff_all) <= 13, 1);
	if	(e5m5_loc02_over == FALSE)	then
		ai_place (sq_e5m5_1ghost_07);
		ai_place (sq_e5m5_1ghost_08);
		ai_place_in_limbo (sq_e5m5_phantom_05_2);
	end
	sleep (10);
	sleep_until (ai_living_count (e5m5_ff_all) <= 17, 1);
	if	(e5m5_loc02_over == FALSE)	then
		ai_place (sq_e5m5_1ghost_09);
		ai_place_in_limbo (sq_e5m5_phantom_05_3);
	end
end

script static void e5m5_location02_vo_start()
	sleep_until (LevelEventStatus ("e5m5_location2vo"), 1);
	thread(f_music_e5m5_location02_overthere_vo());
	thread (vo_e5m5_overthere());
	sleep (30 * 1);
	sleep_until (e5m5_narrative_is_on == FALSE);
	thread (e5m5_locationarrival02());
	thread(f_music_e5m5_location02_lottabads_vo());
	thread (vo_e5m5_lottabads());
	sleep (30 * 4);
	f_new_objective (e5m5_obj_findthorn02);
	sleep (30 * 60);
	f_create_new_spawn_folder (47);
	print ("new spawn folder created!!!");
end

script static void e5m5_locationarrival02()
	sleep_until (volume_test_players (tv_e5m5_location02), 1);
	sleep (30 * 2);
	f_unblip_flag (fl_e5m5_area02);
	thread(f_music_e5m5_locationarrival_unscgear_vo());
	thread (vo_e5m5_unscgear());
	sleep (30 * 2);
	f_objective_complete();
	sleep_until (e5m5_narrative_is_on == FALSE);
	sleep (30 * 1);
	sleep_until (e5m5_narrative_is_on == FALSE);
	e5m5_loc02_over = TRUE;
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E5M5 Goal 04 Scripts (3. no_more_waves)	//343++343==343++343==343++343//

script static void e5m5_g4_threads()
	sleep_until (LevelEventStatus ("e5m5_g4_start"), 1);
	thread (e5m5_pod01());
	thread (e5m5_pod02());
	thread (e5m5_pod03());
	thread (e5m5_pod04());
	thread (e5m5_droppodelites());
	thread (e5m5_pod05());
	thread (e5m5_pod06());
	thread (e5m5_phantom05_4());
	thread (e5m5_phantom_05_5());
	thread (e5m5_wraithphantoms_start());
	thread (e5m5_locationarrival03_start());
	thread (e5m5_ordnancedrop());
	f_new_objective (e5m5_obj_survive);
end

script static void e5m5_pod01()
	sleep_until (LevelEventStatus ("e5m5_smallpod01"), 1);
	ai_place_in_limbo (gr_e5m5_lrgpod_01);
	thread (f_load_drop_pod (e5m5_drop_01, gr_e5m5_lrgpod_01, e5m5_droppod_01, FALSE));
	thread (vo_e5m5_droppods());
	thread(f_music_e5m5_pod01());
end

script static void e5m5_pod02()
	sleep_until (LevelEventStatus ("e5m5_smallpod02"), 1);
	ai_place_in_limbo (gr_e5m5_lrgpod_02);
	thread (f_load_drop_pod (e5m5_drop_02, gr_e5m5_lrgpod_02, e5m5_droppod_02, FALSE));
	thread(f_music_e5m5_pod02());
end

script static void e5m5_pod03()
	sleep_until (LevelEventStatus ("e5m5_smallpod03"), 1);
	ai_place_in_limbo (gr_e5m5_lrgpod_03);
	thread (f_load_drop_pod (e5m5_drop_05, gr_e5m5_lrgpod_03, e5m5_droppod_03, FALSE));
	thread(f_music_e5m5_pod03());
	object_create (e5m5_wraith01);
	ai_place_in_limbo (sq_e5m5_phantom_wraithdrop);
end

script static void e5m5_pod04()
	sleep_until (LevelEventStatus ("e5m5_smallpod04"), 1);
	ai_place_in_limbo (gr_e5m5_lrgpod_04);
	thread (f_load_drop_pod (e5m5_drop_01, gr_e5m5_lrgpod_04, e5m5_droppod_04, FALSE));
	thread(f_music_e5m5_pod04());
	sleep (15);
	thread (vo_e5m5_callouts_05());
end

script static void e5m5_droppodelites()
	sleep_until (LevelEventStatus ("elitedroppod"), 1);
	thread(f_music_e5m5_droppodelites());
	print ("drop pod 01");
	object_create (e5m5_smallpod_01);
	thread(e5m5_smallpod_01->drop_to_point( sq_e5m5_1eli_03, ps_e5m5_droppods.p2, .85, DEFAULT ));
	sleep (15);
	print ("drop pod 02");
	object_create (e5m5_smallpod_02);
	thread(e5m5_smallpod_02->drop_to_point( sq_e5m5_1eli_04, ps_e5m5_droppods.p3, .85, DEFAULT ));
	sleep (15);
	print ("drop pod 03");
	object_create (e5m5_smallpod_03);
	thread(e5m5_smallpod_03->drop_to_point( sq_e5m5_1eli_05, ps_e5m5_droppods.p4, .85, DEFAULT ));
	sleep (15);
	print ("drop pod 04");
	object_create (e5m5_smallpod_04);
	thread(e5m5_smallpod_04->drop_to_point( sq_e5m5_1eli_06, ps_e5m5_droppods.p5, .85, DEFAULT ));
end

script static void e5m5_pod05()
	sleep_until (LevelEventStatus ("e5m5_smallpod05"), 1);
	thread(f_music_e5m5_pod05());
	ai_place_in_limbo (gr_e5m5_lrgpod_05);
	thread (f_load_drop_pod (e5m5_drop_03, gr_e5m5_lrgpod_05, e5m5_droppod_05, FALSE));
	sleep (15);
	thread (vo_e5m5_callouts_06());
end

script static void e5m5_pod06()
	sleep_until (LevelEventStatus ("e5m5_smallpod06"), 1);
	thread(f_music_e5m5_pod06());
	ai_place_in_limbo (gr_e5m5_lrgpod_06);
	thread (f_load_drop_pod (e5m5_drop_04, gr_e5m5_lrgpod_06, e5m5_droppod_06, FALSE));
	sleep (30 * 10);
	ai_set_task ( sq_e5m5_1ghost_03, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_04, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_05, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_06, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_07, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_08, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_1ghost_09, obj_e5m5_vehfollow, followplayer_defend );
	ai_set_task ( sq_e5m5_4eli_04, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( sq_e5m5_4eli_02, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( gr_e5m5_lrgpod_01, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( gr_e5m5_lrgpod_02, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( gr_e5m5_lrgpod_03, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( gr_e5m5_lrgpod_04, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( sq_e5m5_1eli_03, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( sq_e5m5_1eli_04, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( sq_e5m5_1eli_05, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( sq_e5m5_1eli_06, obj_e5m5_followplayer, followplayer_defend );
	ai_set_task ( gr_e5m5_lrgpod_05, obj_e5m5_followplayer, followplayer_defend );
	print ("everyone is trying to follow the player now.");
end

script static void e5m5_phantom05_4()
	sleep_until (LevelEventStatus ("e5m5_phantom05_4"), 1);
	thread(f_music_e5m5_phantom05_4());
	ai_place_in_limbo (sq_e5m5_phantom_05_4);
	sleep (30 * 3);
	thread (vo_e5m5_callouts_07());
	
	
end


script static void e5m5_phantom_05_5()
	sleep_until (LevelEventStatus ("e5m5_phantom05_5"), 1);
	ai_place_in_limbo (sq_e5m5_phantom_05_5);
	sleep (30 * 5);
	sleep_until (ai_living_count (e5m5_ff_all) <= 6, 1);
	f_blip_ai_cui (e5m5_ff_all, "navpoint_enemy");
	e5m5_phantom05_5_dropload = TRUE;
	print ("Suicide Grunts are coming!!!");
	sleep (30 * 7);
	thread (vo_e5m5_callouts_02());
	f_blip_ai_cui (e5m5_ff_all, "navpoint_enemy");
end

script static void e5m5_gruntkamikaze()
	print ("Grunts will now go super Kamikaze on you");
	repeat
		ai_grunt_kamikaze (sq_e5m5_4gru_03);
		ai_grunt_kamikaze (sq_e5m5_4gru_04);
		ai_grunt_kamikaze (sq_e5m5_4gru_05);
		ai_grunt_kamikaze (sq_e5m5_4gru_06);
		sleep (30 * 5);
	until (ai_living_count (gr_e5m5_kamikazegrunts) <= 0, 1);
end


//343++343==343++343==343++343//	E5M5 Goal 05 Scripts (4. no_more_waves)	//343++343==343++343==343++343//

script static void e5m5_wraithphantoms_start()
	sleep_until (LevelEventStatus ("e5m5_wraithphantoms"), 1);
	thread(f_music_e5m5_wraithphantoms_start());
	ai_place (sq_e5m5_wraith_03);
	ai_place_in_limbo (sq_e5m5_phantom_06);
	ai_place (sq_e5m5_wraith_04);
	ai_place_in_limbo (sq_e5m5_phantom_07);
	ai_place (sq_e5m5_wraith_05);
	ai_place_in_limbo (sq_e5m5_phantom_08);
	sleep_until (ai_living_count (e5m5_ff_all) <= 14, 1);
	print ("Final Wraith and Hunters on the way");
	ai_place (sq_e5m5_wraith_06);
	ai_place_in_limbo (sq_e5m5_phantom_09);
	sleep_until (ai_living_count (e5m5_ff_all) <= 6, 1);
	thread (vo_e5m5_callouts_03());
	f_blip_ai_cui (e5m5_ff_all, "navpoint_enemy");
	sleep_until (ai_living_count (e5m5_ff_all) <= 3, 1);
	f_unblip_ai_cui (e5m5_ff_all);
	sleep (2);
	f_blip_ai (e5m5_ff_all, neutralize);
	e5m5_last3_follow = TRUE;
	if (object_valid (e5m5_wraith01))	then
		f_unblip_object_cui (e5m5_wraith01);
	end
end

script static void e5m5_ordnancedrop()
	sleep_until (LevelEventStatus ("e5m5_ordnance"), 1);
	thread(f_music_e5m5_ordnancedrop());
	sleep (30 * 4);
	if	(e5m5_rvb_is_on == TRUE)	then
		thread (vo_e5m5_rvb_01());
		sleep (30 * 2);
		sleep_until (e5m5_narrative_is_on == FALSE);
		ordnance_drop(e5m5_drop_01, "storm_gravity_hammer");
		sleep (15);
		ordnance_drop(e5m5_drop_02, "storm_gravity_hammer");
		sleep (30 * 1);
		ordnance_drop(e5m5_drop_03, "storm_gravity_hammer");
		sleep (15);
		//ordnance_drop(e5m5_drop_04, "storm_gravity_hammer");
		//sleep (15);
		//ordnance_drop(e5m5_drop_05, "storm_gravity_hammer");
		//sleep (15);
		ordnance_drop(e5m5_drop_06, "storm_gravity_hammer");
		sleep (30 * 1);
		ordnance_drop(e5m5_drop_07, "storm_gravity_hammer");
		sleep (15);
		ordnance_drop(e5m5_drop_08, "storm_gravity_hammer");
		thread (e5m5_respawnhammers());
		print ("Hammers have dropped");
		sleep (30 * 1);
		navpoint_track_flag_named (fl_e5m5_droparea01, "navpoint_sports_equipment");
		navpoint_track_flag_named (fl_e5m5_droparea02, "navpoint_sports_equipment");
		navpoint_track_flag_named (fl_e5m5_droparea03, "navpoint_sports_equipment");
		sleep (30 * 2);
		thread (vo_e5m5_rvb_02());
		f_blip_object_cui (e5m5_wraith01, "navpoint_driver");
	else
		sleep (30 * 4);
		thread (vo_e5m5_someguns());
		object_cannot_take_damage (e5m5_rvb_radio);
		sleep (30 * 3);
		sleep_until (e5m5_narrative_is_on == FALSE);
		sleep (30 * 1);
		ordnance_drop(e5m5_drop_01, "storm_spartan_laser");
		sleep (30 * 1);
		ordnance_drop(e5m5_drop_02, "storm_spartan_laser");
		sleep (30 * 2);
		ordnance_drop(e5m5_drop_03, "storm_spartan_laser");
		sleep (30 * 1);
		//ordnance_drop(e5m5_drop_04, "storm_spartan_laser");
		//sleep (30 * 1);
		//ordnance_drop(e5m5_drop_05, "storm_spartan_laser");
		//sleep (30 * 1);
		ordnance_drop(e5m5_drop_06, "storm_spartan_laser");
		sleep (30 * 2);
		ordnance_drop(e5m5_drop_07, "storm_spartan_laser");
		sleep (30 * 1);
		ordnance_drop(e5m5_drop_08, "storm_spartan_laser");
		sleep (15);
		print ("SpLasers have dropped");
		thread (e5m5_respawnsplasers());
		sleep (30 * 1);
		navpoint_track_flag_named (fl_e5m5_droparea01, "navpoint_ordnance_drop");
		navpoint_track_flag_named (fl_e5m5_droparea02, "navpoint_ordnance_drop");
		navpoint_track_flag_named (fl_e5m5_droparea03, "navpoint_ordnance_drop");
		f_blip_object_cui (e5m5_wraith01, "navpoint_driver");
	end
end

script static void e5m5_respawnhammers()
	repeat
		object_create_folder_anew (e5m5_weapons_hammer);
		sleep (30 * 60);
	until (e5m5_stopwiththehammers == TRUE);
end

script static void e5m5_respawnsplasers()
	repeat
		object_create_folder_anew (e5m5_weapons_splaser);
		sleep (30 * 60);
	until (e5m5_stopwiththesplasers == TRUE);
end


script static void ordtest()
	ordnance_drop (e5m5_drop_01, "storm_gravity_hammer");
	print ("ordnance test");
end

//343++343==343++343==343++343//	E5M5 Goal 06 Scripts (5. time_passed)	//343++343==343++343==343++343//

script static void e5m5_locationarrival03_start()
	sleep_until (LevelEventStatus ("e5m5_switchstart"), 1);
	thread(f_music_e5m5_locationarrival03_pelican_vo());
	sleep ( 30 * 5);
	navpoint_track_flag_named (fl_e5m5_droparea01, FALSE);
	navpoint_track_flag_named (fl_e5m5_droparea02, FALSE);
	navpoint_track_flag_named (fl_e5m5_droparea03, FALSE);
	ordnance_show_nav_markers (FALSE);
	thread (vo_e5m5_pelican());
	sleep (30 * 1);
	sleep_until (e5m5_narrative_is_on == FALSE);
	navpoint_track_flag_named (fl_e5m5_area01, "navpoint_goto");
	f_new_objective (e5m5_obj_gettolz);
	sleep_until (volume_test_players (tv_e5m5_location01), 1);
	sleep (30 * 1);
	navpoint_track_flag_named (fl_e5m5_area01, FALSE);
	ai_place_in_limbo (sq_e5m5_pelican);
	thread(f_music_e5m5_locationarrival03_arrives_vo());
	sleep (30 * 1);
	object_immune_to_friendly_damage (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), TRUE);
	thread (vo_e5m5_arrives());
	sleep_until (e5m5_narrative_is_on == FALSE);
	f_blip_ai (sq_e5m5_pelican, default);
	sleep (30 * 5);
	sleep_until (e5m5_pelican_stopped == TRUE);
	object_create (e5m5_smallkillerpod);
	sleep (10);
	object_move_to_flag (e5m5_smallkillerpod, .5, fl_e5m5_killpod);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e5m5_killpod);
	object_destroy (e5m5_smallkillerpod);
	thread(f_music_e5m5_locationarrival03_pelican_boom_title());
	object_immune_to_friendly_damage (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), FALSE);
	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), "cockpit_nose");
	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), "fx_r_wing");
	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), "fx_l_wing");
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), hull, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), engine_lb, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), engine_lf, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), engine_rb, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), engine_rf, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), stands, 10000);
	damage_object (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver), turrets, 10000);
	fade_out (255, 255, 255, 1);
	camera_shake_all_coop_players ( 1, 1, 1, 1);
	sleep (5);
	object_destroy (ai_vehicle_get_from_spawn_point (sq_e5m5_pelican.driver));
	object_create_folder (cr_e5m5_pelicandebris);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e5m5_killpod);
	damage_new (objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect, fl_e5m5_killpod);
	fade_in (255, 255, 255, 5);
	sleep (30 * 1);
	thread(f_music_e5m5_locationarrival03_pelican_boom_vo());
	thread (vo_e5m5_pelicanboom());
	sleep (30 * 3);
	e5m5_hide_players_outro();
	cinematic_start();
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m5_vin_sfx_outro', NONE, 1);
	pup_play_show (e5_m5_out_vin);
	print ("Pup playing");
	sleep_until (e5m5_narrativeout_done == TRUE, 1);
	sleep_until (e5m5_narrative_is_on == FALSE);
	cinematic_stop();
	cui_load_screen (ui\in_game\pve_outro\episode_complete.cui_screen);
	sleep (30 * 2);
	print ("Mission Done!");
	b_end_player_goal = true;
end

script static void e5m5_hide_players_outro
	print ("hiding the players");
	//	player_enable_input (false);
	player_control_fade_out_all_input (.1);
	hud_show (false);
	if game_coop_player_count() == 4 then
		object_hide (player0, true);
		object_hide (player1, true);
		object_hide (player2, true);
		object_hide (player3, true);
	elseif game_coop_player_count() == 3 then
		object_hide (player0, true);
		object_hide (player1, true);
		object_hide (player2, true);
	elseif game_coop_player_count() == 2 then
		object_hide (player0, true);
		object_hide (player1, true);
	else
		object_hide (player0, true);
	end
end


script static void testing()
	object_create (e5m5_smallkillerpod);
	sleep (10);
	object_move_to_flag (e5m5_smallkillerpod, .5, fl_e5m5_killpod);
	sleep (15);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e5m5_killpod);
	object_destroy (e5m5_smallkillerpod);
end

//343++343==343++343==343++343//	E5M5 Placement Scripts	//343++343==343++343==343++343//	

script command_script e5m5_1gru01
	sleep (30 * 3);
	ai_vehicle_enter (ai_current_actor, e5m5_shade_01);
end

script command_script cs_e5m5_phantom01
	f_load_phantom (sq_e5m5_phantom_01, right, sq_e5m5_2eli_03, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_01.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_01.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	print ("everything is ready for phantom. moving out now");
	cs_fly_to_and_face (ps_e5m5_phantom01.p0, ps_e5m5_phantom01.p0);
	cs_fly_to_and_face (ps_e5m5_phantom01.p1, ps_e5m5_phantom01.p1);
	sleep (30 * 2);
	f_unload_phantom (sq_e5m5_phantom_01, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_phantom01.p4, ps_e5m5_phantom01.p4);
	cs_fly_to_and_face (ps_e5m5_phantom01.p2, ps_e5m5_phantom01.p2);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_01.driver ), "phantom_lc" );
	sleep (30 * 2);
	cs_fly_to_and_face (ps_e5m5_phantom01.p3, ps_e5m5_phantom01.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_01);
end

script command_script cs_e5m5_phantom02
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_02.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_01.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_02.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_02);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom02.p0, ps_e5m5_phantom02.p0);
	cs_fly_to_and_face (ps_e5m5_phantom02.p1, ps_e5m5_phantom02.p1);
	cs_fly_to_and_face (ps_e5m5_phantom02.p2, ps_e5m5_phantom02.p2);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_02.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_02.driver ), "phantom_sc" );
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom02.p4, ps_e5m5_phantom02.p4);
	cs_fly_to_and_face (ps_e5m5_phantom02.p3, ps_e5m5_phantom02.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_02);
end

script command_script cs_e5m5_phantom03
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_03.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_02.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_03);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom03.p0, ps_e5m5_phantom03.p0);
	cs_fly_to_and_face (ps_e5m5_phantom03.p1, ps_e5m5_phantom03.p1);
	sleep (30 * 1);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_03.driver ), "phantom_lc" );
	sleep (30 * 2);
	cs_fly_to_and_face (ps_e5m5_phantom03.p2, ps_e5m5_phantom03.p2);
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_03);
end

script command_script cs_e5m5_phantom04
	f_load_phantom (sq_e5m5_phantom_04, dual, sq_e5m5_4eli_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e5m5_phantom04.p4, ps_e5m5_phantom04.p4);
	cs_fly_to_and_face (ps_e5m5_phantom04.p0, ps_e5m5_phantom04.p0);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_04, left);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04.driver));
	cs_fly_to_and_face (ps_e5m5_phantom04.p1, ps_e5m5_phantom04.p1);
	cs_fly_to_and_face (ps_e5m5_phantom04.p2, ps_e5m5_phantom04.p2);
	cs_fly_to_and_face (ps_e5m5_phantom04.p3, ps_e5m5_phantom04.p3);
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_04);
end

script command_script cs_e5m5_phantom04_1
	f_load_phantom (sq_e5m5_phantom_04_1, left, sq_e5m5_4jak_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_04_1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_1.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e5m5_phantom04_1.p0, ps_e5m5_phantom04_1.p0);
	cs_fly_to_and_face (ps_e5m5_phantom04_1.p1, ps_e5m5_phantom04_1.p1);
	cs_fly_to_and_face (ps_e5m5_phantom04_1.p2, ps_e5m5_phantom04_1.p2);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_04_1, left);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_1.driver));
	cs_fly_to_and_face (ps_e5m5_phantom04_1.p3, ps_e5m5_phantom04_1.p4);
	cs_fly_to_and_face (ps_e5m5_phantom04_1.p4, ps_e5m5_phantom04_1.p4);
	object_set_scale (ai_vehicle_get (ai_current_actor), 0.01, 180); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_04_1);
end

script command_script cs_e5m5_phantom04_2
	f_load_phantom (sq_e5m5_phantom_04_2, left, sq_e5m5_4gru_01,  none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_04_2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_2.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p0, ps_e5m5_phantom04_2.p0);
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p1, ps_e5m5_phantom04_2.p1);
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p2, ps_e5m5_phantom04_2.p2);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_04_2, left);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_2.driver));
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p5, ps_e5m5_phantom04_2.p5);
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p3, ps_e5m5_phantom04_2.p3);
	cs_fly_to_and_face (ps_e5m5_phantom04_2.p4, ps_e5m5_phantom04_2.p4);
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_04_2);
end

script command_script cs_e5m5_phantom04_3
	f_load_phantom (sq_e5m5_phantom_04_3, dual, sq_e5m5_2eli_01, none, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_04_3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_3.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e5m5_phantom04_3.p4, ps_e5m5_phantom04_3.p4);
	cs_fly_to_and_face (ps_e5m5_phantom04_3.p0, ps_e5m5_phantom04_3.p0);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_04_3, left);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_04_3.driver));
	cs_fly_to_and_face (ps_e5m5_phantom04_3.p5, ps_e5m5_phantom04_3.p5);
	cs_fly_to_and_face (ps_e5m5_phantom04_3.p2, ps_e5m5_phantom04_3.p2);
	cs_fly_to_and_face (ps_e5m5_phantom04_3.p3, ps_e5m5_phantom04_3.p3);
	object_set_scale ( ai_vehicle_get (ai_current_actor), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_04_3);
end

script command_script cs_e5m5_phantom05
	f_load_phantom (sq_e5m5_phantom_05, dual, sq_e5m5_1eli_01, sq_e5m5_1eli_02, sq_e5m5_1jak_04, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_03.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_04.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05.p0, ps_e5m5_phantom05.p0);
	cs_fly_to_and_face (ps_e5m5_phantom05.p1, ps_e5m5_phantom05.p1);
	cs_fly_to_and_face (ps_e5m5_phantom05.p2, ps_e5m5_phantom05.p2);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05.driver ), "phantom_sc" );
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_05, dual);
	sleep (30 * 5);
	e5m5_gettoshades = TRUE;
	cs_fly_to_and_face (ps_e5m5_phantom05.p3, ps_e5m5_phantom05.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05);
end

script command_script cs_e5m5_phantom05_1
	f_load_phantom (sq_e5m5_phantom_05_1, left, sq_e5m5_4eli_04, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05_1.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_05.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05_1.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_06.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05_1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05_1.p0, ps_e5m5_phantom05_1.p0, 1);
	cs_fly_to_and_face (ps_e5m5_phantom05_1.p1, ps_e5m5_phantom05_1.p1, 1);
	cs_fly_to_and_face (ps_e5m5_phantom05_1.p2, ps_e5m5_phantom05_1.p2, 1);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05_1.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05_1.driver ), "phantom_sc" );
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_05_1, left);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_phantom05_1.p1, ps_e5m5_phantom05_1.p1, 1);
	cs_fly_to_and_face (ps_e5m5_phantom05_1.p3, ps_e5m5_phantom05_1.p3, 1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05_1);
end

script command_script cs_e5m5_phantom05_2
	f_load_phantom (sq_e5m5_phantom_05_2, right, sq_e5m5_4eli_02, none, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05_2.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_07.driver ) );
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05_2.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_08.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05_2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05_2.p0, ps_e5m5_phantom05_2.p0);
	cs_fly_to_and_face (ps_e5m5_phantom05_2.p1, ps_e5m5_phantom05_2.p1);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05_2.driver ), "phantom_lc" );
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05_2.driver ), "phantom_sc" );
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_05_2, right);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_phantom05_2.p2, ps_e5m5_phantom05_2.p2);
	cs_fly_to_and_face (ps_e5m5_phantom05_2.p3, ps_e5m5_phantom05_2.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05_2);
end

script command_script cs_e5m5_phantom05_3
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_05_3.driver ), "phantom_sc", ai_vehicle_get_from_spawn_point( sq_e5m5_1ghost_09.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05_3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p0, ps_e5m5_phantom05_3.p0);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p1, ps_e5m5_phantom05_3.p1);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p2, ps_e5m5_phantom05_3.p2);
	sleep (30 * 2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_05_3.driver ), "phantom_sc" );
	sleep (30 * 1);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p1, ps_e5m5_phantom05_3.p1);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p3, ps_e5m5_phantom05_3.p3);
	cs_fly_to_and_face (ps_e5m5_phantom05_3.p4, ps_e5m5_phantom05_3.p4);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05_3);
end

script command_script cs_e5m5_phantom05_4
	f_load_phantom (sq_e5m5_phantom_05_4, left, sq_e5m5_4eli_03, sq_e5m5_4gru_02, sq_e5m5_4jak_03, sq_e5m5_4jak_04);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05_4);
	object_set_scale ( ai_vehicle_get (ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05_4.p1, ps_e5m5_phantom05_4.p1);
	f_blip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_05_4.driver), "navpoint_enemy_vehicle");
	cs_fly_to_and_face (ps_e5m5_phantom05_4.p2, ps_e5m5_phantom05_4.p2);
	cs_fly_to_and_face (ps_e5m5_phantom05_4.p3, ps_e5m5_phantom05_4.p3);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_05_4, left);
	sleep (30 * 5);
	f_unblip_object_cui (ai_vehicle_get_from_spawn_point (sq_e5m5_phantom_05_4.driver));
	cs_fly_to_and_face (ps_e5m5_phantom05_4.p4, ps_e5m5_phantom05_4.p4);
	cs_fly_to_and_face (ps_e5m5_phantom05_4.p5, ps_e5m5_phantom05_4.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05_4);
end

script command_script cs_e5m5_phantom05_5
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_05_5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantom05_5.p0, ps_e5m5_phantom05_5.p0);
	cs_fly_to_and_face (ps_e5m5_phantom05_5.p1, ps_e5m5_phantom05_5.p1);
	cs_fly_to_and_face (ps_e5m5_phantom05_5.p2, ps_e5m5_phantom05_5.p2);
	sleep (30 * 1);
	sleep_until (e5m5_phantom05_5_dropload == TRUE);
	sleep (15);
	f_load_phantom (sq_e5m5_phantom_05_5, right, sq_e5m5_4gru_03, sq_e5m5_4gru_04, sq_e5m5_4gru_05, sq_e5m5_4gru_06);
	sleep (30 * 1);
	f_unload_phantom (sq_e5m5_phantom_05_5, right);
	sleep (30 * 5);
	thread (e5m5_gruntkamikaze());
	cs_fly_to_and_face (ps_e5m5_phantom05_5.p1, ps_e5m5_phantom05_5.p1);
	cs_fly_to_and_face (ps_e5m5_phantom05_5.p3, ps_e5m5_phantom05_5.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 180 ); //Shrink size over time
	sleep (30 * 6);
	ai_erase (sq_e5m5_phantom_05_5);
end

//	phantoms only dropping wraiths in 4.no_more_waves

script command_script cs_e5m5_phantom06
	f_load_phantom (sq_e5m5_phantom_06, left, sq_e5m5_1hun_03, sq_e5m5_1hun_04, none, none);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_06.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_03.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_06);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p0, ps_e5m5_wraithphantoms.p0);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_06.driver ), "phantom_lc" );
	f_unload_phantom (sq_e5m5_phantom_06, left);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p1, ps_e5m5_wraithphantoms.p1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e5m5_phantom_06);
end

script command_script cs_e5m5_phantom07
	f_load_phantom (sq_e5m5_phantom_07, left, sq_e5m5_1hun_05, sq_e5m5_1hun_06, sq_e5m5_1hun_07, sq_e5m5_1hun_08);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_07.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_04.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_07);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p2, ps_e5m5_wraithphantoms.p2);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_07.driver ), "phantom_lc" );
	f_unload_phantom (sq_e5m5_phantom_07, left);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p3, ps_e5m5_wraithphantoms.p3);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e5m5_phantom_07);
end

script command_script cs_e5m5_phantom08
	f_load_phantom (sq_e5m5_phantom_08, left, sq_e5m5_1hun_09, sq_e5m5_1hun_10, sq_e5m5_1hun_11, sq_e5m5_1hun_12);
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_08.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_05.driver ) );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_08);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p4, ps_e5m5_wraithphantoms.p4);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_08.driver ), "phantom_lc" );
	f_unload_phantom (sq_e5m5_phantom_08, left);
	sleep (30 * 5);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p5, ps_e5m5_wraithphantoms.p5);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e5m5_phantom_08);
end

script command_script cs_e5m5_phantom09
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_09.driver ), "phantom_lc", ai_vehicle_get_from_spawn_point( sq_e5m5_wraith_06.driver ) );
	f_load_phantom (sq_e5m5_phantom_09, left, sq_e5m5_1hun_13, sq_e5m5_1hun_14, none, none);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_09);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p6, ps_e5m5_wraithphantoms.p6);
	f_unload_phantom (sq_e5m5_phantom_09, left);
	sleep (30 * 5);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_09.driver ), "phantom_lc" );
	cs_fly_to_and_face (ps_e5m5_wraithphantoms.p7, ps_e5m5_wraithphantoms.p7);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e5m5_phantom_09);
end


script command_script cs_e5m5_phantomwraithdropoff()
	vehicle_load_magic( ai_vehicle_get_from_spawn_point ( sq_e5m5_phantom_wraithdrop.driver ), "phantom_lc", e5m5_wraith01);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_phantom_wraithdrop);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_phantomwraithdropoff.p0, ps_e5m5_phantomwraithdropoff.p0);
	cs_fly_to_and_face (ps_e5m5_phantomwraithdropoff.p1, ps_e5m5_phantomwraithdropoff.p1);
	sleep (30 * 3);
	vehicle_unload( ai_vehicle_get_from_spawn_point( sq_e5m5_phantom_wraithdrop.driver ), "phantom_lc" );
	cs_fly_to_and_face (ps_e5m5_phantomwraithdropoff.p2, ps_e5m5_phantomwraithdropoff.p2);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 4);
	ai_erase (sq_e5m5_phantom_wraithdrop);
end

script command_script cs_e5m5_pelican01
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 01 ); //Shrink size over time
	sleep (30 * 1);
	ai_exit_limbo (sq_e5m5_pelican);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 90 ); //Shrink size over time
	sleep (30 * 3);
	cs_fly_to_and_face (ps_e5m5_pelican01.p0, ps_e5m5_pelican01.p0);
	e5m5_pelican_stopped = TRUE;
	print ("Pelican has stopped. Commence the killing.");
	sleep_forever();
end
//	squad command scripts

script command_script cs_e5m5_1eli01
	ai_enter_squad_vehicles (sq_e5m5_1eli_01);
	//cs_go_to_vehicle (sq_e5m5_1eli_01, TRUE, e5m5_shade_01);
	ai_vehicle_enter (sq_e5m5_1eli_01, e5m5_shade_01);
end
//
script command_script cs_e5m5_1eli02
	//sleep_until (e5m5_gettoshades == TRUE);
	ai_enter_squad_vehicles (sq_e5m5_1eli_02);
	//cs_go_to_vehicle (sq_e5m5_1eli_02, TRUE, e5m5_shade_02);
	ai_vehicle_enter (sq_e5m5_1eli_02, e5m5_shade_02);
end

//343++343==343++343==343++343//	E5M5 Misc Script	//343++343==343++343==343++343//	//	locations visited counter

script static void e5m5_destroytowers()
	sleep_until (object_valid (e1m1_towerbase_07));
	object_destroy_folder (e1m1_towers);
	sleep_until (object_valid (e3_m1_base1));
	object_destroy_folder (cr_e3_m1_stay_on);
end