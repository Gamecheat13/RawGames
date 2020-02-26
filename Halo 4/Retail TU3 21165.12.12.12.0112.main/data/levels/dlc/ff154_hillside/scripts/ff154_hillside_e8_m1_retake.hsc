//// =============================================================================================================================
//========= HILLSIDE E8_M1 SPOPS SCRIPT ========================================================
// =============================================================================================================================


script startup e8_m1_hillside_retake

	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e8_m1") ) then
		wake( e8_m1_hillside_init );
	end

end

script dormant e8_m1_hillside_init

	//Start initialization

	print ("******************STARTING e8_m1*********************");

	// set standard mission init, the mission ID, the zone set, the ai_ff_all, the initial spawn folder and the initial spawn folder index
	f_spops_mission_setup( "e8_m1", e8_m1, gr_e8_m1_ff_all, e8_m1_spawn_points_0, 90 );
	
	//start all the rest of the event scripts
	f_start_all_events_e8_m1();


//======== OBJECTS ==================================================================

//creates folders at the beginning of the mission automatically and puts their names into an index (unfortunately we never really use the index)

//set crate names
	//f_add_crate_folder(cr_e8_m1_objectives); //UNSC crates and barriers around the main spawn area
	f_add_crate_folder(cr_e8_m1_cov_cover); //UNSC crates and barriers around the main spawn area
	f_add_crate_folder(cr_e8_m1_weapon_racks);
	f_add_crate_folder(cr_e8_m1_fixed_cover);
	f_add_crate_folder(cr_e8_m1_blocking);
	f_add_crate_folder(dm_e8_m1_machines);
	f_add_crate_folder(dc_e8_m1);
	f_add_crate_folder(eq_e8_m1_unsc_ammo);
	f_add_crate_folder(wp_e8_m1_unsc);
	f_add_crate_folder(sc_e8_m1_blockers);
	f_add_crate_folder(v_e8_m1_ghosts);	

// puts spawn point folders into an index that is used to automatically turn on/off spawn points and used by designers to override current spawn folders
//set spawn folder names
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_1, 91);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_2, 92);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_3, 93);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_4, 94);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_5, 95);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_6, 96);
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_7, 97);	
	firefight_mode_set_crate_folder_at(e8_m1_spawn_points_between, 99);
	
//puts certain objects into an index that is used to track objectives set in the player goals in the variant tag
//set objective names
	
	firefight_mode_set_objective_name_at(dc_e8_m1_switch1,	1); //computer terminal in the close side building
	firefight_mode_set_objective_name_at(dc_e8_m1_switch2,	2); //computer terminal in the left side building
	firefight_mode_set_objective_name_at(dc_e8_m1_switch3,	3); //computer terminal in the far right side building
	firefight_mode_set_objective_name_at(dc_e8_m1_mark,			4);
	firefight_mode_set_objective_name_at(dc_e8_m1_mark2,		5);
	firefight_mode_set_objective_name_at(dc_e8_m1_mark3,		6);


//set LZ (location arrival) spots			
	firefight_mode_set_objective_name_at(area_1, 51); //objective in the main spawn area
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


	firefight_mode_set_squad_at(sq_e8_m1_guards_5_sniper, 15);

	//shades
	firefight_mode_set_squad_at(sq_e8_m1_shades_1, 31);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_shades_2, 32);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_ghosts_1, 33);	//left building	
	firefight_mode_set_squad_at(sq_e8_m1_ghosts_2, 34);	//left building	
	firefight_mode_set_squad_at(sq_e8_m1_shades_portal1, 35);	//left building		

	//phantoms
	firefight_mode_set_squad_at(sq_e8_m1_phantom_1, 21); //phantoms 

	//waves (enemies that come from drop pods or phantoms
	firefight_mode_set_squad_at(sq_e8_m1_waves_1, 81);	//left building
	firefight_mode_set_squad_at(sq_e8_m1_waves_2, 82);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_3, 83);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_4, 84);	//front by the main start area
	firefight_mode_set_squad_at(sq_e8_m1_waves_5, 85);	//front by the main start area	
	firefight_mode_set_squad_at(sq_e8_m1_waves_6, 86);	//front by the main start area	
	firefight_mode_set_squad_at(sq_e8_m1_waves_7, 87);	//front by the main start area	
	firefight_mode_set_squad_at(sq_e8_m1_waves_8, 88);	//front by the main start area	
	firefight_mode_set_squad_at(sq_e8_m1_waves_9, 89);	//front by the main start area	

	//set the drop rails
	dm_droppod_4 = dm_e8_m1_rail_4;
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	

end



// ==============================================================================================================
//====== START SCRIPTS ===============================================================================
// ==============================================================================================================


//start all the scripts that get kicked off at the beginning and end of player goals and all scripts that are required to start at the beginning of the mission
script static void f_start_all_events_e8_m1
	
	//start all the event scripts	

//start the intro scripts
	thread(f_start_player_intro_e8_m1());

	//start the first starting event
	thread (f_start_events_e8_m1_1());
	print ("starting e8_m1_1");

	thread (f_end_events_e8_m1_1());
	print ("ending e8_m1_1");
	
	thread (f_start_events_e8_m1_2());
	print ("starting e8_m1_2");
	
	thread (f_start_events_e8_m1_waves());
	print ("starting e8_m1_waves");
	
	thread (f_start_events_e8_m1_mark());
	print ("starting e8_m1_1");
	
	thread (f_start_events_e8_m1_3());
	print ("starting e8_m1_3");
	
	thread (f_end_events_e8_m1_3());
	print ("ending e8_m1_3");
	
	thread (f_start_events_e8_m1_4());
	print ("starting e3_m2_4");
	
	thread (f_end_events_e8_m1_4());
	print ("ending e8_m1_4");
	
	thread (f_start_events_e8_m1_5());
	print ("starting e8_m1_5");
	
	thread (f_end_events_e8_m1_5());
	print ("ending e8_m1_5");
	
	thread (f_start_events_e8_m1_boss());
	print ("starting e8_m1_boss");
	
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

	thread (f_e8_m1_drop_all_pods());
	print ("starting drop all pods script");
	
	thread (f_e8_m1_drop_pod_call_out());
	print ("drop pod VO callouts");
	//object_create (dm_e10_m3_main_door);
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
	
	//sleep until the player spawns
	sleep_until( f_spops_mission_start_complete(), 1 );

	print ("intro complete and the player is spawned");

	//music start
	thread (f_e8_m1_music_start());
	thread (f_e8_m1_event0_start());

	//player has spawned fade in
	sleep_s (0.5);
	fade_in (0,0,0,15);

	f_e8_m1_avoid_turret (sq_e8_m1_shades_1.spawn_points_0);
	//play VO 
	vo_e8m1_portal_problems();

	f_new_objective (ch_8_1_0);
	//cinematic_set_title (ch_8_1_1);

	//sleep_s (3);
	b_wait_for_narrative_hud = false;
	
end

//turns on the portals for narrative -- so they can iterate the intro
script static void f_e8_m1_props
	print ("creating props");
	effect_new_on_object_marker (levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect , dm_e8_m1_portal1, "portal");
	
	//turn on the vignette effect for portal2
	effect_new_on_object_marker (levels\dlc\ff154_hillside\effects\teleport_lg_portal_preroll.effect , dm_e8_m1_portal2, "portal");
	effect_new_on_object_marker (levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect , dm_e8_m1_portal3, "portal");
	//turn on the barrier by the beginning
	object_create (sn_e10_m3_start_door);
	object_create (sn_e10_m3_start_door0);
	
	sleep_until (b_players_are_alive(), 1);
	//turn on real effects for portal2
	effect_new_on_object_marker (levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect , dm_e8_m1_portal2, "portal");

end

//
script static void f_end_events_e8_m1_1
	sleep_until (LevelEventStatus("end_e8_m1_1"), 1);
	print ("goal 1 ended");
	
end

script static void f_start_events_e8_m1_2
	sleep_until (LevelEventStatus("start_e8_m1_2"), 1);
	print ("STARTING event 2");
	//delete the marker because it has collision_log_enable
	object_destroy (area_1);
	//vo_e8m1_defeat_camp();
end

//==KILL ALL ENEMIES before cave switch

script static void f_start_events_e8_m1_waves
	sleep_until (LevelEventStatus("start_e8_m1_waves"), 1);
	print ("STARTING waves");
	
	//delete the marker because it has collision_log_enable
	object_destroy (area_2);
	
	if ai_living_count (ai_ff_all) > 0 then
		print ("enemies alive playing VO and adding objective");
		
		vo_e8m1_defeat_camp();
		f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
		//f_new_objective (ch_8_1_waves);
		//cinematic_set_title (ch_8_1_waves);
	else
		print ("no enemies alive, skipping vo and objective");
	end
end

//==SWITCH at cave entrance is marked

script static void f_start_events_e8_m1_mark
	sleep_until (LevelEventStatus("start_e8_m1_mark"), 1);
	print ("STARTING mark");
	b_wait_for_narrative_hud = true;
	
	thread (f_e8_m1_event0_stop());
	thread (f_e8_m1_event1_start());
	
	//pausing for drama
	sleep_s (2);
	
	//add vo here
	vo_e8m1_blow_cave();
	f_new_objective (ch_8_1_1);
	//cinematic_set_title (ch_8_1_mark);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark, 1);

end

//explosion, shake and destruction of rock blockers by the cave
script static void f_explode_rock
	print ("shake start");
	
	//cinematic_set_title (ch_8_1_run);
	
	//sleep until the device switch has animated
	sleep_until (device_get_position (dm_e8_m1_barrier) >= 1, 1);
	
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	vo_e8m1_run_away();
	
	sleep(15);
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, fl_e8_m1_rock);
	//effect_new (fx\library\explosion\explosion_crate_destruction_major.effect, flag);
	//damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', fl_e8_m1_rock);
	print ("EXPLOSION");

	//add effect removal scripts here
	object_destroy (sc_e8_m1_cave_blocker1);
	//object_destroy (cr_e8_m1_rock2);
	print ("barrier destroyed");
	sleep(15);
	vo_e8m1_shield_down();
end

//==CAVE ENTRANCE switch is activated, big explosion, then cave opens to reveal portal 1

script static void f_start_events_e8_m1_3
	sleep_until (LevelEventStatus("start_e8_m1_3"), 1);
	print ("STARTING 3");
	
	b_wait_for_narrative_hud = true;
	
	//stopping the music
	thread (f_e8_m1_event1_stop());
	
	//explode the rock barrier and shake
	f_explode_rock();
	
	//add a nice work or take cover or something here
	
	//changing the music
	thread (f_e8_m1_event2_start());
	
	//pausing for drama
	sleep_s (2);
	
	//add vo here
	vo_e8m1_go_through();
	f_new_objective (ch_8_1_2);
	//cinematic_set_title (ch_8_1_2);
	
	//this is dangerous blipping, then waiting for trigger volume before turning on the power
	//maybe manually blip, wait for trigger volume, play VO, unblip manual, then turn on real blip
	
	b_wait_for_narrative_hud = false;
	
	sleep_until (volume_test_players_lookat (tv_e8_m1_portal1, 45, 45), 1);
	
	vo_e8m1_turn_off_first();
	device_set_power (dc_e8_m1_switch1, 1);
	
end


script static void f_end_events_e8_m1_3
	sleep_until (LevelEventStatus("end_e8_m1_3"), 1);
	print ("goal 3 ended");
		
end

//this places and turns on the active camo of the zealot that attacks player after the first portal is shut down
script static void f_e8_m1_camo_portal
	print ("camo portal enemies spawn");
	ai_place (sq_e8_m1_portal);
	sleep_until (ai_living_count (sq_e8_m1_portal) > 0, 1);
	ai_set_active_camo (sq_e8_m1_portal.camo, true);
	ai_berserk (sq_e8_m1_portal, true);
end

//==2ND PORTAL

script static void f_start_events_e8_m1_4
	sleep_until (LevelEventStatus("start_e8_m1_4"), 1);
	print ("STARTING 4");
	
	b_wait_for_narrative_hud = true;
	
	//stop music
	thread (f_e8_m1_event2_stop());
	
	//start change respawn points once players get to the bottom of the first hill
	thread (f_e8_m1_respawn1());
	
	//start hud logic
	thread (f_e8_m1_start_navpoint_2());
	
	//turn on avoidance for the turrets
	f_e8_m1_avoid_turret (sq_e8_m1_shades_2.spawn_points_0);
	
	//thread off the derezzing the device machine function because it can't be cast into a function
	//thread (f_e8_m1_derez1());
	
	//animate the switches and portal machine
	thread (f_e8_m1_portal_switch (dm_e8_m1_switch1, dm_e8_m1_portal1, dm_e8_m1_aperature1, kill_portal_1));
	
	sleep_until (device_get_position (dm_e8_m1_switch1) > 0.5, 1);
	
	//destroy the objects blocking the cave			
	//object_destroy_folder (cr_e8_m1_blocking);
	//add effect removal scripts here
	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, sc_e8_m1_cave_blocker2, fx_01);
	object_destroy (sc_e8_m1_cave_blocker2);
	effect_new_on_object_marker (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, sc_e8_m1_cave_blocker3, fx_01);
	object_destroy (sc_e8_m1_cave_blocker3);
	
	//spawn the camo elite 
	thread (f_e8_m1_camo_portal());
	
	//change the music
	thread (f_e8_m1_event3_start());
	
	//tell players good job
	vo_glo15_palmer_attaboy_01();
	sleep_s (2);
	
	//tell players to go to next portal
	vo_e8m1_other_portal();
	
	f_new_objective (ch_8_1_3);
	//cinematic_set_title (ch_8_1_3);
			
	//start the jumper logic
	thread (f_e8_m1_jumper_repeat2());
	
	//start the navpoint logic
	b_wait_for_narrative_hud = false;
	
	
	//turn on portal 2
	device_set_power (dc_e8_m1_switch2, 1);
end

//controls derezzing the "switch" device machine
//script static void f_e8_m1_derez1
//	//derezzing
//	print ("derezzing");
//	sleep_until (device_get_position (dm_e8_m1_switch1) == 1, 1);
//	dm_e8_m1_switch1->SetDerezWhenActivated();
//
//end

//kicks off the scripts that controls the navpoint blips around the 2nd portal
script static void f_e8_m1_start_navpoint_2
	//f_unblip_object_cui (dc_e8_m1_switch2);
	object_create (area_3);
	if player_valid (player0) then
		//thread (f_e8_m1_navpoint_player0());
		thread (f_e8_m1_navpoint_player (tv_e8_m1_portal2, player0, dc_e8_m1_switch2, area_3));
	end
	if player_valid (player1) then
		//thread (f_e8_m1_navpoint_player1());
		thread (f_e8_m1_navpoint_player (tv_e8_m1_portal2, player1, dc_e8_m1_switch2, area_3));
	end
	if player_valid (player2) then
		//thread (f_e8_m1_navpoint_player2());
		thread (f_e8_m1_navpoint_player (tv_e8_m1_portal2, player2, dc_e8_m1_switch2, area_3));
	end
	if player_valid (player3) then
		//thread (f_e8_m1_navpoint_player3());
		thread (f_e8_m1_navpoint_player (tv_e8_m1_portal2, player3, dc_e8_m1_switch2, area_3));
	end
	
end



script static void f_end_events_e8_m1_4
	sleep_until (LevelEventStatus("end_e8_m1_4"), 1);
	print ("goal 4 ended");
	
	//device_set_power (dc_e8_m1_switch2, 0);
	
	
end

//==3RD PORTAL

script static void f_start_events_e8_m1_5
	sleep_until (LevelEventStatus("start_e8_m1_5"), 1);
	print ("STARTING 5");
		
	b_wait_for_narrative_hud = true;

	//thread off the derezzing function because it can't be cast into a function
	//thread (f_e8_m1_derez2());
	
	//stop music
	thread (f_e8_m1_event3_stop());
	
	//animate the switches and portal machine
	thread (f_e8_m1_portal_switch (dm_e8_m1_switch2, dm_e8_m1_portal2, dm_e8_m1_aperature2, kill_portal_2));
	
	//start new music
	thread (f_e8_m1_event4_start());
	
	sleep_until (device_get_position (dm_e8_m1_switch2) > 0.5, 1);
	
	//tell players good job
	vo_glo15_miller_attaboy_07();
	sleep_s (2);
	
	//VO
	vo_e8m1_second_portal_shut_down();
	
	f_new_objective (ch_8_1_4);
	//cinematic_set_title (ch_8_1_4);
	
	b_wait_for_narrative_hud = false;
	
	//turn on 3rd switch
	device_set_power (dc_e8_m1_switch3, 1);

	//make this obvious to the player
	//f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
	f_e8_m1_jumper_repeat3();
end

//script static void f_e8_m1_derez2
//	//derezzing
//	print ("derezzing");
//	sleep_until (device_get_position (dm_e8_m1_switch2) == 1, 1);
//	dm_e8_m1_switch2->SetDerezWhenActivated();
//
//end

script static void f_end_events_e8_m1_5
	sleep_until (LevelEventStatus("end_e8_m1_5"), 1);
	print ("goal 5 ended");
	
	//device_set_power (dc_e8_m1_switch3, 0);
	
end


//==WRAITH FIGHT
global ai ai_e8_m1_boss = none;

script static void f_start_events_e8_m1_boss
	sleep_until (LevelEventStatus("start_e8_m1_boss"), 1);
	print ("STARTING BOSS");
	
	ai_e8_m1_boss = sq_e8_m1_wraith;
			
	b_wait_for_narrative_hud = true;
	
	//stop music
	thread (f_e8_m1_event4_stop());
	
	//thread off the derezzing function because it can't be cast into a function
	//thread (f_e8_m1_derez3());
	
	//animate the switches and portal machine
	thread (f_e8_m1_portal_switch (dm_e8_m1_switch3, dm_e8_m1_portal3, dm_e8_m1_aperature3, kill_portal_3));
	
	//start music
	thread (f_e8_m1_event5_start());
	
	sleep_until (device_get_position (dm_e8_m1_switch3) > 0.5, 1);
	
	//tell players good job
	vo_glo15_miller_attaboy_07();
	sleep_s (2);
	
	//add vo here
	vo_e8m1_third_portal();
	
	f_new_objective (ch_8_1_boss);
	//cinematic_set_title (ch_8_1_boss);
	
	b_wait_for_narrative_hud = false;
	//vo about boss goes here
	
	//sleep_until (ai_living_count (sq_e8_m1_wraith) > 0, 1);
	//print ("wraith squad is alive");
	//sleep_s (1);
	
	//f_blip_ai_cui (ai_e8_m1_boss, "navpoint_enemy");
	
	sleep_until (ai_living_count (sq_e8_m1_wraith) == 0, 1);
	print ("wraith squad is dead");
	//cinematic_set_title (ch_8_1_good);
	
	b_end_player_goal = true;
	
end

//script static void f_e8_m1_derez3
//	//derezzing
//	print ("derezzing");
//	sleep_until (device_get_position (dm_e8_m1_switch3) == 1, 1);
//	dm_e8_m1_switch3->SetDerezWhenActivated();
//
//end

script static void f_end_events_e8_m1_boss
	sleep_until (LevelEventStatus("end_e8_m1_boss"), 1);
	print ("ENDING BOSS");

end

//==MARK THE INTERESTING FORERUNNER SPOT

script static void f_start_events_e8_m1_6
	sleep_until (LevelEventStatus("start_e8_m1_6"), 1);
	print ("STARTING 6");
	
	b_wait_for_narrative_hud = true;
	
	//stop music
	thread (f_e8_m1_event5_stop());
	//start music
	thread (f_e8_m1_event6_start());
	
	//pausing for drama
	sleep_s (2);
	
	//good work VO
	vo_glo15_palmer_attaboy_04();
	
	sleep_s (1);
	
	//vo
	vo_e8m1_mark_forerunner();
	
	f_new_objective (ch_8_1_mark3);
	//cinematic_set_title (ch_8_1_mark3);
	
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark2, 1);
	
end

script static void f_end_events_e8_m1_6
	sleep_until (LevelEventStatus("end_e8_m1_6"), 1);
	print ("goal 6 ended");
	
	//device_set_power (dc_e8_m1_mark2, 0);
	
end


//==CLEAR THE LZ AREA
//clear the LZ area
script static void f_start_events_e8_m1_8
	sleep_until (LevelEventStatus("start_e8_m1_8"), 1);
	print ("STARTING 8");
	
	//b_wait_for_narrative_hud = true;
	//blips the area the player should go, then unblips when the player gets close
	thread (f_e8_m1_blip_battle());
		
	//stop music
	thread (f_e8_m1_event6_stop());
	//the music starts after the small and med drop pods fall
	
	//starting respawn script
	thread (f_e8_m1_respawn2());
	
	sleep_s (1);
	
	//VO
	vo_glo15_palmer_attaboy_02();
	
	//might need to add some logic if there are tons of AI still around when the player(s) mark the spot
	if ai_living_count (ai_ff_all) > 10 then
		vo_glo15_miller_few_more_01();
	end
	
	//sleep until the drop pods are done
	sleep_until (ai_living_count (sq_e8_m1_med2) > 0, 1);
	
	sleep_s (1);
	vo_e8m1_clean_up();
	
	f_new_objective (ch_8_1_6);
	//cinematic_set_title (ch_8_1_6);
		
	b_wait_for_narrative_hud = false;

	//call the SOS VO to fill the void in walking
	//sleep_s (2);
	sleep_until (ai_living_count (ai_ff_all) < 9, 1);
	print ("ai living count low enough, calling SOS VO");
	vo_e8m1_sos();

	//ai_set_objective (ai_ff_all, obj_e8_m1_survival);
end


script static void f_end_events_e8_m1_8
	sleep_until (LevelEventStatus("end_e8_m1_8"), 1);
	print ("e8_m1_8 no more waves ended");
//	

	
end


//==MARK THE LZ
script static void f_start_events_e8_m1_7
	sleep_until (LevelEventStatus("start_e8_m1_7"), 1);
	print ("STARTING 7");
	
	b_wait_for_narrative_hud = true;
	
	//stop music
	thread (f_e8_m1_event7_stop());
	thread (f_e8_m1_event8_start());
	
	//pausing for drama
	sleep_s (2);
	
	vo_e8m1_to_lz(); //tell player to mark the LZ
	f_new_objective (ch_8_1_5);
	//cinematic_set_title (ch_8_1_5);
		
	b_wait_for_narrative_hud = false;
	device_set_power (dc_e8_m1_mark3, 1);
end

script static void f_end_events_e8_m1_7
	sleep_until (LevelEventStatus("end_e8_m1_7"), 1);
	print ("e8_m1_7");

	
end


//==FADE OUT (MAYBE PELICAN)
script static void f_start_events_e8_m1_9
	sleep_until (LevelEventStatus("start_e8_m1_9"), 1);
	
	//pausing for drama
	sleep_s (2);
	ai_place(sq_e8_m1_pelican);
	//cinematic_set_title (ch_8_1_good);
	//hud_play_pip_from_tag(levels\dlc\shared\binks\ep8_m1_1_60);
	//sleep until the pip is done playing -- change when we know what VO line is playing from pip
	//sleep (270);
	
	vo_e8m1_off_back();
	vo_e8m1_help_majestic();
	thread (f_e8_m1_music_stop());
	
	print ("mission ended");
	
	b_end_player_goal = true;
	
	f_end_mission();

		
end



//end of last player goal

//=======ENDING E8 M1==============================




// ==============================================================================================================
//====== PHANTOM COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================

//Pelican Command Script

script command_script cs_e8_m1_pelican
	ai_cannot_die(ai_current_actor, TRUE);
	cs_fly_by(ps_e8_m1_pelican.p0);
	cs_fly_by(ps_e8_m1_pelican.p1);
	cs_fly_to(ps_e8_m1_pelican.p2);
end

//ai command scripts

script command_script cs_e8_m1_drop_pod
	print ("drop pod command script started");
	sleep_s (2);
	ai_set_objective (ai_current_squad, obj_e8_m1_survival);
end


// PHANTOM 01 =================================================================================================== 
script command_script cs_e8_m1_phantom_01()
	sleep (1);

	print ("spawn wraith");
//	ai_place_in_limbo  (sq_e8_m1_wraith);
	ai_place (sq_e8_m1_wraith);
	ai_braindead (sq_e8_m1_wraith, true);

	vehicle_load_magic(ai_vehicle_get (sq_e8_m1_phantom_1.driver ), "phantom_lc", ai_vehicle_get_from_squad(sq_e8_m1_wraith, 0));

	object_set_shadowless (ai_current_actor, TRUE);
	cs_enable_targeting (true);
	cs_fly_by (ps_phantom_1.p0);
	cs_fly_by (ps_phantom_1.p1);
	cs_fly_to (ps_phantom_1.p2);

	sleep (30 * 3);

		// ======== DROP DUDES HERE ======================
	
	vehicle_unload (ai_vehicle_get_from_spawn_point (sq_e8_m1_phantom_1.driver ), "phantom_lc");
//	ai_set_objective (sq_e8_m1_phantom_1, obj_e8_m1_wraith);
	ai_braindead (sq_e8_m1_wraith, false);
	f_unload_phantom (ai_current_actor, "dual");
	
	navpoint_track_object_named (sq_e8_m1_wraith.driver, "navpoint_neutralize");			// changed per https://trochia:8443/browse/MNDE-7501
//	navpoint_track_object_named (sq_e8_m1_wraith.driver, "navpoint_enemy");
			
		// ======== DROP DUDES HERE ======================
		
	print ("phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_phantom_1.p3);
	
	cs_enable_targeting (false);
	
	cs_fly_to (ps_phantom_1.p4);
	cs_fly_to (ps_phantom_1.erase);
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
end

script command_script cs_e8_m1_wraith
	print ("wraith command script started");
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_e8_m1_wraith);
end

script command_script cs_e8_m1_berserk
	print ("berzerk command script started");
	ai_berserk (ai_current_actor, true);
end

// ==============================================================================================================
//====== DROP POD AND TELEPORT SCRIPTS ===============================================================================
// ==============================================================================================================

script static void f_e8_m1_avoid_turret (ai turret)
	print ("avoid the turret");
	ObjectOverrideNavMeshObstacle (ai_vehicle_get_from_spawn_point (turret), true);
end


script static void test
	print ("test");
	f_e8_m1_portal_jump (sq_e8_m1_portal2.1, fl_e8_m1_portal2);
	f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
end

global short s_e8_m1_jumper2 = 0;
global short s_e8_m1_jumper3 = 0;

//spawn elites out of the portals 3 times or the portal is turned off
script static void f_e8_m1_jumper_repeat2
	print ("jumper repeat 2 started");
	repeat
		
		sleep_until (ai_living_count (ai_ff_all) < 19, 1);
		f_e8_m1_portal_jump (sq_e8_m1_portal2.1, fl_e8_m1_portal2);
		print ("portal 2 jumper spawned");
		s_e8_m1_jumper2 = s_e8_m1_jumper2 + 1;
		sleep_until (ai_living_count (sq_e8_m1_portal2.1) < 1, 1);
		
	until (device_get_position (dc_e8_m1_switch2) > 0 or s_e8_m1_jumper2 == 3, 1);
end

script static void f_e8_m1_jumper_repeat3
	print ("jumper repeat 3 started");
	repeat
		
		sleep_until (ai_living_count (ai_ff_all) < 19, 1);
		f_e8_m1_portal_jump (sq_e8_m1_portal2.2, fl_e8_m1_portal3);
		print ("portal 3 jumper spawned");
		s_e8_m1_jumper3 = s_e8_m1_jumper3 + 1;
		sleep_until (ai_living_count (sq_e8_m1_portal2.2) < 1 , 1);
		
	until (device_get_position (dc_e8_m1_switch3) > 0 or s_e8_m1_jumper3 == 3, 1);
end



//spawn a small elite that gets bigger as it jumps through the portal
script static void f_e8_m1_portal_jump (ai jumper, cutscene_flag portal)
	print ("AI teleporting from portal");
	ai_place_in_limbo (jumper);
	
	//ai_braindead (jumper, true);
	object_teleport (jumper, portal);
	object_set_scale (jumper, 0.1, 1);
	
	ai_exit_limbo (jumper);
	
	sleep (10);
	
	object_set_velocity (jumper, 5, 0, 3);
	
	object_set_scale (jumper, 1.0, 60);

end


script static void f_e8_m1_drop_all_pods
	print ("drop all pods started");
	
	//sleep_until (ai_living_count (ai_ff_all) < 10, 1);
	sleep_until (LevelEventStatus("e8_m1_drop_pods"), 1);
	sleep_until (ai_living_count (ai_ff_all) < 10, 1);
	
	f_e8_m1_med_drop_pod_1();
	sleep_s (.5);
	f_e8_m1_med_drop_pod_2();
	sleep_s (.4);
	f_e8_m1_sm_drop_pod_1();
	sleep_s (.3);
	f_e8_m1_sm_drop_pod_2();

	thread (f_e8_m1_event7_start());

end

script static void f_e8_m1_med_drop_pod_1
	print ("med drop pod 1");
	object_create (v_e8_m1_med1);
	thread(v_e8_m1_med1->drop_to_point( sq_e8_m1_med1, ps_drop_pods.p2, .85, DEFAULT ));
end

script static void f_e8_m1_med_drop_pod_2
	print ("med drop pod 2");
	object_create (v_e8_m1_med2);
	thread(v_e8_m1_med2->drop_to_point( sq_e8_m1_med2, ps_drop_pods.p3, .85, DEFAULT ));
end

script static void f_e8_m1_sm_drop_pod_1
	print ("small drop pod 1");
	object_create (v_e8_m1_sm1);
	thread(v_e8_m1_sm1->drop_to_point( sq_e8_m1_sm1, ps_drop_pods.p0, .85, DEFAULT ));
end

script static void f_e8_m1_sm_drop_pod_2
	print ("small drop pod 2");
	object_create (v_e8_m1_sm2);
	thread(v_e8_m1_sm2->drop_to_point( sq_e8_m1_sm2, ps_drop_pods.p1, .85, DEFAULT ));
end


// ===================================================================================
//===========MISC=======================================
// ===================================================================================

//==DROP POD CALL OUT SCRIPTS
script static void f_e8_m1_drop_pod_call_out
	sleep_until (LevelEventStatus("e8_m1_drop_pod_1") or LevelEventStatus("e8_m1_drop_pod_2"), 1);
		
	if e8m1_narrative_is_on == false then
		e8m1_narrative_is_on = true;
		print ("drop pod VO playing");
		vo_glo15_dalton_droppods_02();
		e8m1_narrative_is_on = false;
	end
	
	sleep_until (LevelEventStatus("e8_m1_drop_pod_1") or LevelEventStatus("e8_m1_drop_pod_2"), 1);
	
	if e8m1_narrative_is_on == false then
		e8m1_narrative_is_on = true;
		print ("drop pod VO playing");
		vo_glo15_dalton_droppods_01();
		e8m1_narrative_is_on = false;
	end


end

//==NAVPOINT PLAYER SCRIPTS
//After the player dies their index changes


script static void f_e8_m1_navpoint_player (trigger_volume tv, player p_player, device dc, object target)
	print ("navpoint to portal 2 started");
	
	//if players are in the cave then put up a goto waypoint to the end of the cave, else tell the players to go to the switch
	repeat
		sleep_until (volume_test_object (tv, p_player) or device_get_position (dc) > 0, 1);
		print ("player in the trigger volume");
		navpoint_track_object_for_player (p_player, dc, false);
		if device_get_position (dc) == 0 then
			sleep_until (b_wait_for_narrative_hud == false, 1);
			navpoint_track_object_for_player_named (p_player, target, "navpoint_goto");
		end
		sleep_until (not volume_test_object (tv, p_player) or device_get_position (dc) > 0, 1);
		print ("player NOT in the trigger volume");
		navpoint_track_object_for_player (p_player, target, false);
		if device_get_position (dc) == 0 then
			sleep_until (b_wait_for_narrative_hud == false, 1);
			navpoint_track_object_for_player_named (p_player, dc, "navpoint_deactivate");
		end
	until (device_get_position (dc) > 0, 1);
	//clear the navpoints no matter what
	print ("navpoint thread done");
	//navpoint_track_object_for_player (player, area_3, false);
	navpoint_track_object_for_player (p_player, dc, false);
end



//==RESPAWN SCRIPTS
//look at using 1 function for these, especially if we need more respawn points
script static void f_e8_m1_respawn1
	print ("respawn1 started");
	
	sleep_until (volume_test_players (tv_e8_m1_respawn1), 1);
	print ("respawn1 trigger volume hit, changing spawn points");
	f_create_new_spawn_folder (99);
end

script static void f_e8_m1_respawn2
	print ("respawn2 started");
	
	sleep_until (volume_test_players (tv_e8_m1_respawn2), 1);
	print ("respawn2 trigger volume hit, changing spawn points");
	f_create_new_spawn_folder (97);
end

//==PUPPETEER SCRIPTS

global object g_ics_player = none;

//puppeteer for pushing the barrier button
script static void f_e8_m1_barrier_switch (object dev, unit player)
	print ("barrier switch puppeteer");
	g_ics_player = player;
	
	local long show = pup_play_show(pup_e8_m1_barrier);
	sleep_until (not pup_is_playing(show), 1);
 	
 	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_scurve_dm_covenant_switch_activation', dm_e8_m1_barrier, 1 ); //AUDIO!
 	device_set_position (dm_e8_m1_barrier, 1);
 	sleep_until (device_get_position (dm_e8_m1_barrier) == 1, 1);
 	object_hide (dm_e8_m1_barrier, true);

end


//script for both the marine marker and the LZ marker
script static void f_e8_m1_mark_pup (object dev, unit player)
	print ("mark area puppeteer start");
	g_ics_player = player;
	
	//only play pup if no enemies are around
	if ai_living_count (ai_ff_all) <= 0 then
	
		//play mark2 puppeteer if the control is mark2 elseif play mark3 if the control is mark3
		if dev == dc_e8_m1_mark2 then
			local long show = pup_play_show(pup_e8_m1_mark2);
			print ("playing mark2 puppetshow");
			sleep_until (not pup_is_playing(show), 1);
		elseif dev == dc_e8_m1_mark3 then
			//local long show = pup_play_show(pup_e8_m1_mark3);
			print ("playing mark3 puppetshow");
			//sleep_until (not pup_is_playing(show), 1);
		end
				
		print ("done with puppetshow");
	
	else
		print ("too many enemies not playing the puppetshow");
	
	end
	
end

//==VIGNETTE PORTAL SCRIPT
script static void f_e8_m1_portals_on
	print ("portals on script started");
	thread (f_e8_m1_props());
end


script static void f_e8_m1_derez (device switch)
	//derezzing
	print ("derezzing");
	sleep_until (device_get_position (switch) == 1, 1);
	if switch == dm_e8_m1_switch1 then
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', dm_e8_m1_switch1, 1 ); //DEREZ AUDIO!
		dm_e8_m1_switch1->SetDerezWhenActivated();
		print ("derez switch 1");
	elseif switch == dm_e8_m1_switch2 then
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', dm_e8_m1_switch2, 1 ); //DEREZ AUDIO!
		dm_e8_m1_switch2->SetDerezWhenActivated();
		print ("derez switch 2");
	elseif switch == dm_e8_m1_switch3 then
		sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', dm_e8_m1_switch3, 1 ); //DEREZ AUDIO!
		dm_e8_m1_switch3->SetDerezWhenActivated();
		print ("derez switch 3");
	end
end

//==PORTAL SCRIPTS
script static void f_e8_m1_portal_switch (device switch, object dm_portal, device aperature, trigger_volume tv)
	print ("starting portal animation script");
	
	//animating the portal switch
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_hillside_panel_hologram_mnde842', switch, 1 ); //AUDIO!
	device_set_position (switch, 1);
	print ("animating device");
	
	//sleep until the portal switch is fully animated
	sleep_until (device_get_position (switch) >= 0.3, 1);
	
	//derezzing
	thread (f_e8_m1_derez (switch));
	print ("derezzing");
	//switch->SetDerezWhenActivated();
	
		//kill the portal effect on the machine
	//sleep(38);
	//effect_kill_object_marker(levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect, dm_portal, "portal");
	f_e8_m1_portal_effect (dm_portal);
	
	//shake the camera
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\spops_rumble_med', NONE, 1 ); //AUDIO!
	thread (camera_shake_all_coop_players( .1, .7, 1, 0.1));
	
	//animate the portal device
	device_set_position (device(dm_portal), 1);
	
	//wait until the portal device is down
	sleep_until (device_get_position (device(dm_portal)) >= 0.6);
	
	//close the aperature
	device_set_position (aperature, 1);
	
	//disable the kill volume around the aperature
	sleep_until (device_get_position (aperature) == 1, 1);
	kill_volume_disable (tv);

end

global short s_portal_effect = 15;
global short s_portal_sleep = 2;

script static void f_e8_m1_portal_effect (object dev_portal)
	print ("portal effect started, killing looping effect and start deactivate effect");
	effect_new_on_object_marker (levels\dlc\ff154_hillside\effects\teleport_lg_portal_off.effect, dev_portal, "portal");
	sleep (s_portal_effect);
	effect_kill_object_marker(levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect, dev_portal, "portal");
	sleep_s (s_portal_sleep);
end

//script static void f_test_fx
//	print ("test fx");
//	thread (f_e8_m1_portal_effect (dm_e8_m1_portal2));
//	device_set_position (dm_e8_m1_portal2, 1);
//end
//==BLIPS ON DISTANCE

global short s_blip_distance = 20;

script static void f_e8_m1_blip_battle
	print ("blip battle started");
	if player_valid (player0) then
		thread (f_e8_m1_player_blip_distance (player0, dc_e8_m1_mark3, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player1) then
		thread (f_e8_m1_player_blip_distance (player1, dc_e8_m1_mark3, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player2) then
		thread (f_e8_m1_player_blip_distance (player2, dc_e8_m1_mark3, s_blip_distance, "navpoint_generic"));
	end
	
	if player_valid (player3) then
		thread (f_e8_m1_player_blip_distance (player3, dc_e8_m1_mark3, s_blip_distance, "navpoint_generic"));
	end

end

//blip tracking
script static void f_e8_m1_player_blip_distance (player p_player, object target, short distance, string_id blip_type)
	print ("start blip distance");
	
	sleep_until (b_wait_for_narrative_hud == false, 1);
	
	//sleep_until (ai_living_count (ai_ff_all) >= 1, 1);
	//replacing ai living count with "b_all_waves_ended"
	repeat
		//turn on the navpoint tracker per player and sleep until the player gets close
		sleep_until (objects_distance_to_object (p_player, target) >= distance or b_all_waves_ended, 1);
		if b_all_waves_ended == false then
			navpoint_track_object_for_player_named(p_player, target, blip_type);
			print ("blipping target");
		end
		sleep_until ((objects_distance_to_object (p_player, target) <= distance and objects_distance_to_object (p_player, target) > 0) or b_all_waves_ended, 1);
		print ("player within distance target, unblipping");
				
		//unblip the target because the player is close or all waves completed
		//if navpoint_is_tracking_object_for_player (player, target) then //commenting this out because it crashes unless it's the absolute index
		navpoint_track_object_for_player (p_player, target, false);
		//end
	//until (ai_living_count (ai_ff_all) < 1, 1);
	until (b_all_waves_ended, 1);

end

// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================

//called immediately when starting the mission, these scripts control the vignettes and scripts that start after the player spawns

script static void f_start_player_intro_e8_m1
	//sleep until the player picks the loadout
	sleep_until (f_spops_mission_ready_complete(), 1);
	
	//turn on the effects and Chris French barriers -- putting this here because all of the crates are created by now
	f_e8_m1_portals_on();
	
	if editor_mode() then
		print ("editor mode, no intro playing");
		sleep_s(1);
		//f_e8_m1_portals_on();
		//f_e8_m1_intro_vignette();
		
	else
		print ("NOT editor mode play the intro");
		
		//intro();
		f_e8_m1_intro_vignette();
				
	end

	//intro is done	
	f_spops_mission_intro_complete( TRUE );
	
end

global boolean b_puppeteer_end = false;

script static void f_e8_m1_intro_vignette
	//set up, play and clean up the intro
	print ("playing intro");
	//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1);
	
	ai_enter_limbo (gr_e8_m1_ff_all);
	pup_disable_splitscreen (true);
	
//play the puppeteer intro, sleep until it's done	
	local long e8_m1_show = pup_play_show(vin_e8_m1_in);
	thread (vo_e8m1_secure_area());
	sleep_until (not pup_is_playing(e8_m1_show), 1);
	
	print ("intro puppetshow complete");
	
	pup_disable_splitscreen (false);
	ai_exit_limbo (gr_e8_m1_ff_all);
	print ("all ai exiting limbo after the puppeteer");
end

