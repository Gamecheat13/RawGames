// =============================================================================================================================
//===============SCURVE FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//================== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
// ================= GLOBAL S ==================================================================

global string_id	title_e1_m5_1 = ch_e1_m5_1;
global string_id	title_e1_m5_2 = ch_e1_m5_2;
global string_id	title_e1_m5_3 = ch_e1_m5_3;
global string_id	title_e1_m5_4 = ch_e1_m5_4;
global string_id	title_e1_m5_5 = ch_e1_m5_5;
global string_id	title_e1_m5_6 = ch_e1_m5_6;
global string_id	title_e1_m5_7 = ch_e1_m5_7;
global string_id	title_e1_m5_8 = ch_e1_m5_8;
global string_id	title_e1_m5_9 = ch_e1_m5_9;

// =============================================================================================================================
// ============= TITLES ==================================================================


script startup scurve_e1_m5
	//Start the intro
	sleep_until (LevelEventStatus("e1_m5"), 1);
	print ("******************STARTING E1 M5*********************");
	switch_zone_set (e1_m5);
	mission_is_e1_m5 = true;
	b_wait_for_narrative = true;
	ai_ff_all = e1_m5_gr_ff_all;
	thread(f_start_player_intro_e1_m5());
	
	//start the first event script
	thread (f_start_events_e1_m5_1());
	
	//start all the event scripts
	thread (f_start_all_events_e1_m5());

// ============ AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;

	
//============ OBJECTS ==================================================================
//set crate folder names to create

	
	f_add_crate_folder(cr_e1_m5_base_cov_cover); //Cov Cover and fluff on the back bridge	
	f_add_crate_folder(cr_e1_m5_unsc_gun_racks); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(cr_e1_m5_cov_misc); //Cov Cover and fluff on the back bridge
	f_add_crate_folder(cr_e1_m5_unsc_intro_weapons); //gun racks by the intro
	f_add_crate_folder(cr_e1_m5_cov_cover_back); //Cov crates at the very back on the right	
	f_add_crate_folder(cr_e1_m5_cov_energy_cover); //energy barrier shields
	f_add_crate_folder(wp_e1_m5); //long range weapons	
	f_add_crate_folder(cr_e1_m5_cov_computers); //energy barrier shields	
	f_add_crate_folder(cr_tunnel_shield);
	f_add_crate_folder(cr_e1_m5_cov_cover); //cov crates all around the main area			



	//multi mission folders
	f_add_crate_folder(cr_cave_shield);

	//set ammo crate names
	f_add_crate_folder(eq_e1_m5_unsc_ammo);


	
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

	firefight_mode_set_objective_name_at(power_switch, 20); //touchscreen switch in the front building
	firefight_mode_set_objective_name_at(fore_switch_0, 21); //touchscreen switch in the very back building
	firefight_mode_set_objective_name_at(door_switch_1, 26); //touchscreen switch on the overlooks of the bridge
	firefight_mode_set_objective_name_at(door_switch_2, 27); //touchscreen switch on the overlooks of the bridge
	firefight_mode_set_objective_name_at(shield_switch_1, 28); //touchscreen switch on the overlooks of the bridge
	//firefight_mode_set_objective_name_at(inv_hack_panel, 29); //touchscreen switch on the overlooks of the bridge
	
	
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

	firefight_mode_set_squad_at(gr_e1_m5_guards_1, 1);	//left building
	firefight_mode_set_squad_at(gr_e1_m5_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(gr_e1_m5_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(gr_e1_m5_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(gr_e1_m5_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(gr_e1_m5_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(gr_e1_m5_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(gr_e1_m5_guards_8, 8); //on the bridge
//	firefight_mode_set_squad_at(gr_e1_m5_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
//	firefight_mode_set_squad_at(gr_ff_waves, 11);
	firefight_mode_set_squad_at(gr_e1_m5_phantom_attack, 12); //phantoms -- doesn't seem to work
	firefight_mode_set_squad_at(gr_e1_m5_guards_13, 13); //in the tunnel
	firefight_mode_set_squad_at(gr_e1_m5_guards_14, 14); //bottom of the bridge by the start
	firefight_mode_set_squad_at(gr_e1_m5_tunnel_guards_1, 15); //back of the area by the tunnels
	firefight_mode_set_squad_at(gr_e1_m5_tunnel_guards_2, 16); //back of the area by the tunnels
	firefight_mode_set_squad_at(gr_e1_m5_tunnel_fodder, 17); //back of the area by the tunnels
	firefight_mode_set_squad_at(gr_e1_m5_guards_18, 18); //guarding tightly the back of the bridge
	
	firefight_mode_set_squad_at(gr_e1_m5_guards_5_bishop, 35); //right side in the back
	firefight_mode_set_squad_at(gr_e1_m5_guards_6_bishop, 36); //right side in the back	
	
	firefight_mode_set_squad_at(gr_e1_m5_waves_1, 81);
	firefight_mode_set_squad_at(gr_e1_m5_waves_2, 82);
	firefight_mode_set_squad_at(gr_e1_m5_waves_3, 83);
	firefight_mode_set_squad_at(gr_e1_m5_waves_4, 84);
	firefight_mode_set_squad_at(gr_e1_m5_waves_5, 85);
	firefight_mode_set_squad_at(gr_e1_m5_waves_6, 86);
	
	firefight_mode_set_squad_at(sq_ff_phantom_01, 20); //phantom 1
	firefight_mode_set_squad_at(sq_ff_phantom_02, 21); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;


end


// =========== MAIN SCRIPT STARTS ==================================================================

//threading all the event scripts that are called through the gameenginevarianttag
script static void f_start_all_events_e1_m5
	print ("threading all the event scripts");
	//event tags
	//thread (f_start_events_e1_m5_1());
	//print ("threading f_start_events_e1_m5_1");
	
	
	thread (f_end_events_e1_m5_1());
	print ("threading f_end_events_e1_m5_1");
	
	thread (f_start_events_e1_m5_switch());
	print ("threading e1_m5 switch 1");
	
	thread (f_start_events_e1_m5_1_5());
	print ("threading f_start_events_e1_m5_1_5");
	
	thread (f_end_events_e1_m5_1_5());
	print ("threading f_end_events_e1_m5_1");
	
	thread (f_start_events_e1_m5_2());
	print ("threading f_start_events_e1_m5_2");
	
	thread (f_start_events_e1_m5_3());
	print ("threading f_start_events_e1_m5_2");
	
	thread (f_end_events_e1_m5_3());
	print ("threading f_end_events_e1_m5_3_5");
	
	thread (f_start_events_e1_m5_4());
	print ("threading f_start_events_e1_m5_4");
	
	//thread (f_end_events_e1_m5_4());
	//print ("threading f_end_events_e1_m5_4");
	
//	thread (f_e1_m5_dropship_vo());
//	print ("threading f_e1_m5_dropship_vo");
	
	thread (f_start_events_e1_m5_5());
	print ("threading f_start_events_e1_m5_5");
	
	thread (f_end_events_e1_m5_5());
	print ("threading f_end_events_e1_m5_5");
	
	thread (f_start_events_e1_m5_6());
	print ("threading f_start_events_e1_m5_6");
	
	thread (f_end_events_e1_m5_6());
	print ("threading f_end_events_e1_m5_6");
	
	thread (f_misc_events_m5_weapon_drop_1());
	print ("threading f_misc_events_m5_weapon_drop_1");
	
	//weapon drops
	thread (f_misc_events_m5_weapon_drop_2());
	print ("threading f_misc_events_m5_weapon_drop_2");
	thread (f_misc_events_m5_weapon_drop_3());
	print ("threading f_misc_events_m5_weapon_drop_3");
	thread (f_misc_events_m5_weapon_drop_6());
	print ("threading f_misc_events_m5_weapon_drop_6");
	
	//misc (drop pods, etc)
	
	thread (f_event_blow_shields_bridge());
	//thread (f_wait_for_small_pod_0());
	//print ("threading small pod 0");
	thread (f_surprise_elite());
	print ("threading surprise elite");
	//thread (f_wait_for_small_pod_1());
	//print ("threading small pod 1");
	thread (e1_m5_knight_birth());
	print ("threading knight birth");
	thread (e1_m5_pawn_spawn());
	print ("threading pawn spawn");
	
	thread(f_tunnel_pawns_e1_m5());
	
	thread(f_tunnel_pawnsnipers_e1_m5());
	
end

//===================STARTING E1 M5==============================



script static void f_start_events_e1_m5_1
	sleep_until (LevelEventStatus("start_e1_m5_waves_1"), 1);
	print ("STARTING start_e1_m5_switch_1");
	//switch_zone_set (e1_m5); 
	b_wait_for_narrative_hud = true;
	print ("narrative hud true");
	//sleep (30);
	
	sleep_until (object_get_health(player0) > 0, 1);
	thread (f_attach_panels_e1_m5());
	
	//turning on embers -- delete if there are any bugs!
	//attach_fx_to_cam();
	
	//create some objects and place the turret
	object_create (e1_m5_doors);
	//creating this now so that the lights aren't around for the intro
	object_create_folder (cr_e1_m5_cov_misc);
	print ("created the doors and the misc objects");
	ai_place (sq_turret);
	ai_place (sq_ff_phantom_attack_4);
	
	//start VO and music
	sleep_s (3);
	vo_e1m5_playstart();
	thread (f_music_start_e1_m5_1());
	thread(f_new_objective (title_e1_m5_1));

	thread (f_ranger_drop());
	thread (f_phantom_flyover());
	sleep_until (volume_test_players (e1_m5_source_vo), 1);
	thread (f_music_source_vo_start());

	//tell players about the powersource
//	vo_e1m5_doorspowerup();
//	thread (f_music_source_vo_stop());

	b_wait_for_narrative_hud = false;
	//scaling the doors (replace once we get real geo)

	thread (f_music_turn_on_power_title());

//	cinematic_set_title (turn_on_power);
	
end

script static void f_attach_panels_e1_m5
	print ("attaching the device control panels");
	sleep_until (object_valid (power_switch), 1);
	object_create (dm_power_switch);
	object_create (dm_art_switch);
	object_create (dm_door_switch_1);
	object_create (dm_door_switch_2);
	
	objects_attach (dm_e1_m5_power, "panel", power_switch, "panel");
	objects_attach (dm_e1_m5_art_switch, "panel", fore_switch_0, "panel");
	objects_attach (dm_e1_m5_power, "panel", dm_power_switch, "panel");
	objects_attach (dm_e1_m5_art_switch, "panel", dm_art_switch, "panel");
	//covey switch
	object_create (dm_e1_m5_cov_switch);
	
	//door switch
	objects_attach (door_switch_1, "panel", dm_door_switch_1, "panel");
	objects_attach (door_switch_2, "panel", dm_door_switch_2, "panel");
	
	//objects_attach (dm_e1_m5_cov_switch, "panel", power_switch, "panel");
end

script static void f_raise_cover
	print ("raising cover");

end

script static void f_ranger_drop
	sleep_until (volume_test_players (vol_ranger_drop), 1);
	print ("ranger drop");
	thread (f_music_ranger_drop_start());

	f_create_new_spawn_folder (96);
	ai_place (sq_rangers_bridge);
	vo_e1m5_turret1();
	sleep_s (10);
	//Probably want to wait until here to turn on the NAV marker??

end

//this controls the 3 phantoms that just flyover
script static void f_phantom_flyover
	print ("starting flyover function");
	sleep_until (volume_test_players (tv_e1_m5_flyover), 1);
	sleep_until (ai_living_count (e1_m5_gr_ff_all) < 16, 1);
	print ("players in flyover volume -- phantoms spawned");
	ai_place (sq_ff_phantom_attack_flyover);
	
end

script static void f_start_events_e1_m5_switch
	sleep_until (LevelEventStatus("start_e1_m5_switch_1"), 1);
	print ("starting start_e1_m5_switch_1");
	
	b_wait_for_narrative_hud = true;
	
	//pausing for drama
	sleep_s (2);
	
	//play VO here
	vo_e1m5_doorspowerup();
	thread (f_music_source_vo_stop());
	
	b_wait_for_narrative_hud = false;
	
	device_set_power (power_switch, 1);
	device_set_power (dm_power_switch, 1);
	
	//wait until the control starts to move, then turn on the machine -- 
	//having to manually script this because the device groups are an enygma
	sleep_until (device_get_position (power_switch) > 0, 1);
	device_set_position (dm_power_switch, 1);
	
	//animating -- total hack
	print ("animating device");
	device_set_position_track( dm_power_switch, 'any:active', 1 );
	device_animate_position (dm_power_switch, 1, 2, 1, 0, 0);
	
	sleep_until (device_get_position (dm_power_switch) == 1, 1);
	device_set_power (dm_power_switch, 0);
	
	f_derez_switch (dm_power_switch);
	
	
	
	//object_hide (dm_power_switch, true);
	f_animate_device (dm_e1_m5_power, 5.83);
	
end

script static void f_derez_switch (device switch)
	object_dissolve_from_marker(switch, phase_out, panel);
	//sleep_s (2);
	//object_hide (switch, true);
end

//script continuous f_end_events_e1_m5_1
script static void f_end_events_e1_m5_1
	sleep_until (LevelEventStatus("end_e1_m5_switch_1"), 1);
	print ("ENDING start_e1_m5_switch_1");
	//sleep (30);
	//thread(f_objective_complete());
	b_wait_for_narrative_hud = true;
	switch_move_1();


	
end

script static void switch_move_1
	print ("switch move 1");
//	object_destroy (e1_m5_tower_move_1);
//	b_wait_for_narrative_hud = true;
	
	//spawn the phantom -- move this to bonobo if necessary
	ai_place (sq_ff_phantom_attack_1);
	
	//tower_move_1();

	
	print ("moving the plinth");
	
	//sleep until the animation of pushing the button is over
	object_hide (power_switch, true);
//	f_animate_device (dm_e1_m5_power, 4);
	
	print ("call the elites");
	notifylevel ("surprise");
	
//	sleep_s (2);
	
	thread (vo_e1m5_spire1());
//	waiting until the switch is down to raise the tower
	sleep_s (2);
	print ("animating the power tower");
	//device_set_position (e1_m5_spire, 1);
	pup_play_show(raise_spire1);
//	f_animate_device (e1_m5_spire, 9.5);
	
	sleep_s(1);
	
//	cinematic_set_title (power_restored);
	sleep_s(1);

	
	sleep(100);

	//call VO function here
	vo_e1m5_switchesid();

	
	b_wait_for_narrative_hud = false;
	//power up the controls
	print ("power up the switches and turn on the HUD");
	device_set_power (door_switch_1, 1);
	device_set_power (dm_door_switch_1, 1);
	
	//this waits for the switch to be flipped and derezzed it
	thread (f_derez_door_switch_1());
	
	device_set_power (door_switch_2, 1);
	device_set_power (dm_door_switch_2, 1);
	
	//this waits for the switch to be flipped and derezzed it
	thread (f_derez_door_switch_2());
	sleep_s(2);


end



script static void f_start_events_e1_m5_1_5
	sleep_until (LevelEventStatus("start_e1_m5_switch_2"), 1);
	print ("STARTING start_e1_m5_switch_2");
	//power up the controls
		thread (f_music_e1_m5_1_5_start());

	//device_set_power (door_switch_1, 1);
	//device_set_power (door_switch_2, 1);
	//b_wait_for_narrative_hud = true;
	//sleep (30 * 7);
	//cinematic_set_title (title_drop_shields);
	
	//wait until one of the objectives switches are flipped
	sleep_until (s_all_objectives_count == 1, 1);
	thread (f_music_e1_m5_1_5_switch1());


	vo_e1m5_switch1();
	sleep_until (s_all_objectives_count == 2, 1);
	thread (f_music_e1_m5_1_5_switch2());

	
	//thread(f_objective_complete());
	vo_e1m5_switch2();
	thread(f_new_objective (title_e1_m5_4));
end

script static void f_derez_door_switch_1
	print ("door_switch_1_derezzer");
	
	//wait until the control starts to move, then turn on the machine -- 
	//having to manually script this because the device groups are an enygma
	sleep_until (device_get_position (door_switch_1) > 0, 1);
	device_set_position (dm_door_switch_1, 1);
	
	//animating -- total hack
	print ("animating device");
	device_set_position_track(dm_door_switch_1, 'any:idle', 1 );
	device_animate_position (dm_door_switch_1, 1, 1, 1, 0, 0);
	
	sleep_until (device_get_position (dm_door_switch_1) == 1, 1);
	device_set_power (dm_door_switch_1, 0);
	
	f_derez_switch (dm_door_switch_1);
	print ("derez-ing door_switch_1 ");
end

script static void f_derez_door_switch_2
	print ("door_switch_2_derezzer");
	//wait until the control starts to move, then turn on the machine -- 
	//having to manually script this because the device groups are an enygma
	sleep_until (device_get_position (door_switch_2) > 0, 1);
	device_set_position (dm_door_switch_2, 1);
	
	//animating -- total hack
	print ("animating device");
	device_set_position_track(dm_door_switch_2, 'any:idle', 1 );
	device_animate_position (dm_door_switch_2, 1, 1, 1, 0, 0);
	
	sleep_until (device_get_position (dm_door_switch_2) == 1, 1);
	device_set_power (dm_door_switch_2, 0);
	
	f_derez_switch (dm_door_switch_2);

	print ("derez-ing door_switch_2 ");
end



script static void f_end_events_e1_m5_1_5
	sleep_until (LevelEventStatus("end_e1_m5_switch_2"), 1);
	print ("ENDING start_e1_m5_switch_2");
	//power off the controls if necessary
		//blowing up the shields
	NotifyLevel ("blow_shields_bridge");
	thread (f_music_e1_m5_1_5_end());

end

script static void f_event_blow_shields_bridge
	sleep_until (LevelEventStatus("blow_shields_bridge"), 1);
	print ("_blow shields_bridge_");
	thread(start_camera_shake_loop ("heavy", "short"));
	//cinematic_set_title (doors_are_opening);
	sleep_until (ai_living_count (guards_8) > 0, 1);
	f_move_bridge_doors();

	stop_camera_shake_loop();
	//f_objective_complete();
end

script static void f_move_bridge_doors
	print ("bridge doors moving");
	

	//f_animate_device (e1_m5_doors, 6);
	device_set_position (e1_m5_doors, 1);
	sleep_until (device_get_position (e1_m5_doors) == 1, 1);
	
	//these need to be destroyed so pathfinding works
	print ("doors are fully open, destroying them now");
	object_destroy (e1_m5_doors);
end



script static void f_e1_m5_through_doors
	//wait till in trigger volume then power up bridge cover device machines to make cool moment
	print ("power up cover started");
	sleep_until (volume_test_players (tv_e1_m5_bridge_cover), 1);
	print ("bridge cover powering up");
	device_set_power (dm_bridge_cover_1, 1);
	device_set_power (dm_bridge_cover_2, 1);
	
	//change the spawn point after moving through the doors	
	f_create_new_spawn_folder (99);
	
	ai_place (sq_ff_phantom_attack_2);
	ai_place (sq_ff_phantom_attack_3);
	
end

script static void f_start_events_e1_m5_2
	sleep_until (LevelEventStatus("start_e1_m5_clear_base_1"), 1);
	print ("STARTING start_e1_m5_clear_base_1");

	thread(f_e1_m5_through_doors());

	thread (f_music_e1_m5_2_start());

	ai_place (sq_base_turret);

	thread (f_music_e1_m5_2_clear_base_title());
//	thread(f_new_objective (title_e1_m5_4));
	//cinematic_set_title (title_clear_base);
	
	//hacky way to do the VO -- fix this if the VO is good
	b_wait_for_narrative_hud = true;

	sleep_until (ai_living_count (ai_ff_all) > 7, 1);
	
	sleep_until (ai_living_count (ai_ff_all) <= 7, 1);
		thread (f_music_e1_m5_2_move_on_vo_start());


	vo_e1m5_moveon();
		thread (f_music_e1_m5_2_move_on_vo_end());

	b_wait_for_narrative_hud = false;
	
end

script static void f_end_events_e1_m5_2
	sleep_until (LevelEventStatus("end_e1_m5_base_1"), 1);
	print ("ENDING start_e1_m5_switch_3");
	//f_objective_complete();
end

script static void f_start_events_e1_m5_3
	sleep_until (LevelEventStatus("start_e1_m5_switch_3"), 1);
	print ("STARTING start_e1_m5_switch_3");
		thread (f_music_e1_m5_3_start());


	//preparing to switch zone set, look for bad popping
	print ("preparing to switch zone set");
	prepare_to_switch_to_zone_set (e1_m5_2);


	b_wait_for_narrative_hud = true;
		thread (f_music_e1_m5_3_more_shields_vo_start());

//pausing for drama
	sleep_s (2);

//tell the player about the shields and set objective
	vo_e1m5_moreshields();
	thread (f_music_e1_m5_3_more_shields_vo_end());
	thread(f_new_objective (title_e1_m5_5));
	vo_e1m5_hackcontrols();
		thread (f_music_e1_m5_3_more_shields_vo_end());

	b_wait_for_narrative_hud = false;
	
	//CHANGING THE ZONE SET TO SUPPORT FORERUNNERS!!!
	print ("switching zone set");
	switch_zone_set (e1_m5_2);
	current_zone_set_fully_active();
	
	//power up the controls
	device_set_power (shield_switch_1, 1);
	device_set_power (dm_e1_m5_cov_switch, 1);

	thread (f_music_e1_m5_3_drop_shields_title());

	//wait until the control starts to move, then turn on the machine -- 
	//having to manually script this because the device groups are an enygma
	sleep_until (device_get_position (shield_switch_1) < 1, 1);
	device_set_position (dm_e1_m5_cov_switch, 1);
	
	//animating -- total hack
	print ("animating device");
	device_set_position_track( dm_e1_m5_cov_switch, 'any:idle', 1 );
	device_animate_position (dm_e1_m5_cov_switch, 1, 2, 1, 0, 0);
	
	sleep_until (device_get_position (dm_e1_m5_cov_switch) == 1, 1);
	device_set_power (dm_e1_m5_cov_switch, 0);
	object_hide (dm_e1_m5_cov_switch, true);
	//cinematic_set_title (drop_shields_2);

//removing the hack the shields part :(
//	f_blip_object_cui (inv_hack_panel, "navpoint_activate");
//	f_hack_shields();
end

//====SWITCHED ZONE SETS




script static void f_end_events_e1_m5_3
	sleep_until (LevelEventStatus("end_e1_m5_switch_3"), 1);
	print ("ENDING start_e1_m5_switch_3");
	//notifyLevel ("blow_shields");

	//create the forerunner weapon racks
	object_create_folder (cr_e1_m5_fore_weapons);
	
	thread (f_music_e1_m5_3_blow_up_shields());

	//blowing the shields
	f_event_blow_up_shields_e1_m5();
	
end

script static void f_event_blow_up_shields_e1_m5
	//sleep_until (LevelEventStatus("blow_shields"), 1);
	print ("_blow shields_");
	thread(start_camera_shake_loop ("heavy", "short"));
	b_wait_for_narrative_hud = true;
	//cinematic_set_title (shields_overloading);
	thread(f_objective_complete());
	

	//sleep 3 seconds just for fun
	sleep_s (3);

//	object_destroy_folder (cr_tunnel_shield);
	//damage the shield to destroy it AND play the effect
	object_damage_damage_section (cr_tunnel_shield1, "shield", 100);
	//cinematic_set_title (title_destroy_obj_2);
	//sleep (30 * 5);
	stop_camera_shake_loop();
	//cinematic_set_title (title_shields_down);
	sleep_s (2);
	b_wait_for_narrative_hud = false;
	sleep_s (5);
	//cinematic_set_title (title_clear_base_2);
	f_new_objective (title_e1_m5_6);
	
end

//the tunnel guard bishops will continue to spawn 6 pawns once the other pawns get below 6 4 times or until they die
script static void f_tunnel_spawn
	print ("tunnel spawn script starting");
	
	local short s_spawn_repeater = 0;
	
	repeat
		print ("spawning pawns");
		sleep_until (ai_living_count (e1_m5_gr_ff_all) < 12, 1);
		f_spawn_pawns_tunnel();
		s_spawn_repeater = s_spawn_repeater + 1;
		inspect (s_spawn_repeater);
		sleep_until (ai_living_count (gr_e1_m5_tunnel_fodder) > 5 or ai_living_count (sq_tunnel_guards_2) + ai_living_count (sq_tunnel_guards_1) == 0, 1);
		sleep_until (ai_living_count (gr_e1_m5_tunnel_fodder) <= 5 or ai_living_count (sq_tunnel_guards_2) + ai_living_count (sq_tunnel_guards_1) == 0, 1);
	until (ai_living_count (sq_tunnel_guards_2) + ai_living_count (sq_tunnel_guards_1) == 0 or s_spawn_repeater == 4, 1);

	print ("done with tunnel spawn script");
	
	//spawn more pawns if the players enter the trigger volume and the bishops are still alive
	sleep_until (volume_test_players (tv_tunnel_spawn)
		or ai_living_count (sq_tunnel_guards_2) + ai_living_count (sq_tunnel_guards_1) == 0, 1);
	if (ai_living_count (sq_tunnel_guards_2) + ai_living_count (sq_tunnel_guards_1) > 0) then
		f_spawn_pawns_tunnel();
		print ("spawning more pawns because tunnel guards are alive");
	else
		print ("tunnel guards are dead, don't spawn more guys");
	end
	
end

script static void f_spawn_pawns_tunnel
	print ("spawning pawns with a bishop in the tunnel");
	ai_place_with_shards (sq_pawn_spawns);
	ai_place_with_shards (sq_pawn_spawns_2);
end

script static void f_tunnel_pawns_e1_m5
	print ("starting tunnel pawns");
	repeat
		sleep_until (LevelEventStatus("tunnel_pawns"), 1);
		print ("tunnel pawns spawning");
		ai_place (sq_tunnel_fodder);
	until (b_game_won == true or b_game_lost == true, 1);
end

script static void f_pawn_scream
	print ("pawns screaming spawn");
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_scream_1);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_scream_2);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_scream_3);
	ai_place (sq_pawn_scream);

end

script static void f_tunnel_pawnsnipers_e1_m5
	print ("starting tunnel pawns");

	sleep_until (LevelEventStatus("tunnel_snipers"), 1);
	
	sleep_s (2);
	thread (f_sfx_e1_m5_crawler_first_appearance());
	f_pawn_scream();
	sleep_s (3);
	
	print ("tunnel pawns spawning");
	ai_place (sq_tunnel_fodder_2);
//	ai_place (sq_tunnel_fodder_3);
//	until (b_game_won == true or b_game_lost == true, 1);

	f_tunnel_spawn();

end
//script static void f_start_events_e1_m5_3
//	sleep_until (LevelEventStatus("start_e1_m5_clear_base_2"), 1);
//	print ("STARTING start_e1_m5_clear_base_2");

//end

global boolean b_players_through_tunnel = false;

script static void f_start_events_e1_m5_4
	sleep_until (LevelEventStatus("start_e1_m5_get_artifact"), 1);
	print ("STARTING start_e1_m5_get_artifact");
	//sleep (30);
		thread (f_music_e1_m5_4_start());

	thread (f_knight_phase_e1_m5());
	//ai_place (sq_sniper_left);
	//ai_place (sq_sniper_right);
	
	//set the tunnel guards to follow
	b_players_through_tunnel = true;
		thread (f_music_e1_m5_4_foundcrew_vo_start());

	//f_phantom_surprise_01();
//	thread(f_new_objective (title_e1_m5_7));
	vo_e1m5_foundcrew();
		thread (f_music_e1_m5_4_foundcrew_vo_end());
	thread (f_music_e1_m5_4_get_artifact_title());

	//cinematic_set_title (title_get_artifact);
	
end

script static void f_knight_phase_e1_m5
	//wait until a player is looking
	print ("waiting until players look at tv");
	sleep_until (volume_test_players_lookat (tv_e1_m5_knights, 100, 20), 1);
	print ("a player looked at the volume");
//	ai_place (sq_sniper_left);
	ai_place_in_limbo (sq_sniper_right);
	sleep_s (1);
	ai_place (guards_5_bishop);
	sleep_s (1);
	ai_place_in_limbo (sq_knight_fodder);
	
	//kill the bishop if he isn't birthed
	//sleep_s (10);
	sleep_until (ai_living_count (e1_m5_gr_ff_all) <= 1, 1);
	if ai_in_limbo_count (guards_5_bishop) > 0 then
		ai_erase (guards_5_bishop);
		print ("erasing bishop because he didn't birth");
	end

end

//script static void f_phantom_surprise_01
//	print ("phantom surprise");
//	ai_place (sq_phantom_surprise);
//	cs_run_command_script (sq_phantom_surprise, cs_ff_phantom_surprise_01);
////	ai_place_in_vehicle (sq_phantom_fodder, sq_ff_phantom_01);
//	ai_place (sq_phantom_fodder);
//	f_load_dropship (ai_vehicle_get_from_spawn_point (sq_phantom_surprise.phantom), sq_phantom_fodder);
//end

//turn on the switch
script static void f_start_events_e1_m5_5
	sleep_until (LevelEventStatus("start_e1_m5_5"), 1);
	print ("starting e1_m5_5");
	
	b_wait_for_narrative_hud = true;
	
	//sleeping for drama and hopefully getting more RAM
	sleep_s (2);
	
	vo_e1m5_allclear();
	
	thread (f_music_e1_m5_5_start());
//	f_new_objective (title_e1_m5_8);
	device_set_power (fore_switch_0, 1);
	
	b_wait_for_narrative_hud = false;
		device_set_power (dm_art_switch, 1);
	
	//wait until the control starts to move, then turn on the machine -- 
	//having to manually script this because the device groups are an enygma
	sleep_until (device_get_position (fore_switch_0) > 0, 1);
	device_set_position (dm_art_switch, 1);
	
	//animating -- total hack
	print ("animating device");
	device_set_position_track( dm_art_switch, 'any:active', 1 );
	device_animate_position (dm_art_switch, 1, 2, 1, 0, 0);
	
	sleep_until (device_get_position (dm_art_switch) == 1, 1);
	device_set_power (dm_art_switch, 0);
	
	f_derez_switch (dm_art_switch);
	
	thread (f_animate_device (dm_e1_m5_art_switch, 5.83));
	
end

script static void f_end_events_e1_m5_5
	sleep_until (LevelEventStatus("end_e1_m5_get_artifact"), 1);
	print ("ENDING start_e1_m5_get_artifact");
		thread (f_music_e1_m5_5_animate_device());

	//sleep (30);
	//sound_looping_stop (music_start);
	//sleep (30);
	//sleep (30 * 7);
	//thread (tower_move_2());
//put this vo someplace else	
	//end_e1_m5_get_artifact_vo();
	

	thread (f_objective_complete());
	sleep_s (1);
	//f_animate_device (e1_m5_artifact, 11);
	
	// Play the "raise_artifact" vignette
	//pup_play_show(raise_artifact);
	thread (f_artifact_rumble());
	
	//device_set_position (e1_m5_artifact, 1);
	
	thread (f_music_e1_m5_5_artifact_vo_start());

//	cinematic_set_title (title_got_artifact);
	
	vo_e1m5_artifact();
		thread (f_music_e1_m5_5_artifact_vo_end());
	
	sleep_until (ai_living_count (e1_m5_gr_ff_all) > 0, 1);
//	sleep_s (1);
	
	
//	vo_e1m5_artifact2();
	
	vo_e1m5_moreknights();
	thread (f_new_objective (title_e1_m5_9));
end

script static void f_artifact_rumble
	print ("start artifact rumble");
	
	pup_play_show(raise_artifact);
	camera_shake_all_coop_players (.8, .8, 6, 1.8);
//	repeat
//		player_effect_set_max_rumble (1, .8);
//		player_effect_start (1, 1);
//		sleep_s (1);
//		player_effect_set_max_rumble (.8, 1);
//		sleep_s (1);
//	until (device_get_position (e1_m5_artifact) == 1, 1);
//	player_effect_stop(.1);
	
end


//script continuous f_start_events_e1_m5_5
script static void f_start_events_e1_m5_6
	sleep_until (LevelEventStatus("start_e1_m5_swarm"), 1);
	print ("STARTING start_e1_m5_swarm");
		thread (f_music_e1_m5_6_start());
	//sleep_until (device_get_position (e1_m5_artifact) == 1, 1);

	
	
end

script static void e1_m5_knight_birth
	//spawn knights and bishop
	sleep_until (LevelEventStatus("birth"), 1);
	print ("BIRTH");
	ai_place_in_limbo (guards_5);
	sleep_s (1);
	ai_place (guards_5_bishop);
	
	//failsafe for the bishop
	
	sleep_s (1);
	
	sleep_until (ai_living_count (guards_5_bishop) > 0, 1);
	
	sleep_s (1);
	
	sleep_until (ai_living_count (e1_m5_gr_ff_all) <= 1, 1);
	if ai_in_limbo_count (guards_5_bishop) > 0 then
		ai_erase (guards_5_bishop);
		print ("deleting bishop because he never birthed");
	else
		print ("bishop better be alive, because the failsafe is done");
	end

end

script static void e1_m5_pawn_spawn
	sleep_until (LevelEventStatus("pawn_spawn"), 1);
	print ("pawn spawn");
	
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_1);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_2);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_3);
	ai_place (sq_tunnel_fodder);
	sleep_s (3);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_1);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_2);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_pawn_fodder_3);
	ai_place (sq_tunnel_fodder);
	
end

//script static void f_e1_m5_dropship_vo
//	sleep_until (LevelEventStatus("m5_dropship_vo"), 1);
//		thread (f_music_e1_m5_4_dropship_vo_start());
//
//	vo_e1m5_morebads();
//		thread (f_music_e1_m5_4_dropship_vo_end());
//
//end

//script continuous f_end_events_e1_m5_5
script static void f_end_events_e1_m5_6
	sleep_until (LevelEventStatus("end_e1_m5_swarm"), 1);
	print ("ENDING start_e1_m5_swarm");
	//sleep (30);
		thread (f_music_e1_m5_6_start());

//	sound_looping_stop (music_start);
	//sleep (30);
	//sleep (30 * 7);
	//place the pelican
	ai_place (squads_1);
	
	//music
	thread (f_music_e1_m5_6_lz_clear_title());
	thread (f_sfx_e1_m5_pelican_land(ai_get_object(squads_1)));

	thread(f_objective_complete());
	//cinematic_set_title (lz_clear);
	thread (f_music_e1_m5_6_pelican_vo_start());

//pausing for drama
	sleep_s (2);
	vo_e1m5_aircraftinbound();
	vo_e1m5_pelican();
		thread (f_music_e1_m5_6_pelican_vo_end());

	//f_phantom_outro_2();
	//ex2();
	print ("wait until the pelican is parked");
	
	//sleep until the switch is flipped after the pelican is parked
	sleep_until (f_ready_to_end(), 1);
	
	//f_unblip_object_cui (dc_pelican_parked);
	//navpoint_object_set_on_radar (dc_pelican_parked, false, false);
	navpoint_cutscene_flag_set_on_radar (fl_pelican_parked, false, false);
	navpoint_track_flag (fl_pelican_parked, false);
	
	//music and audio
	thread (f_music_e1_m5_6_takeoff());
	thread (f_sfx_e1_m5_pelican_takeoff(ai_get_object(squads_1)));

	thread (vo_e1m5_takeoff());
	
	device_set_position_immediate (e1_m5_artifact, 0);
	
	//hide the players for the outro
	f_hide_players_outro();
	
	//turn on the chapter complete screen_effect_new
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);

	//start the outro
	scene_narrative_out();
	//cinematic_set_title (title_secure);
		print ("DONE!");
	b_end_player_goal = true;
	
end

script static boolean f_ready_to_end
	sleep_until (b_pelican_done == true, 1);
		print ("pelican is parked");
	object_create (dc_pelican_parked);

	device_set_power(dc_pelican_parked, 1);
	//f_blip_object_cui (dc_pelican_parked, "navpoint_goto");
	//navpoint_object_set_on_radar (dc_pelican_parked, true, true);
	navpoint_cutscene_flag_set_on_radar (fl_pelican_parked, true, true);
	navpoint_track_flag_named (fl_pelican_parked, "navpoint_goto");
	
//	cinematic_set_title (lz_go_to);
	sleep_until (device_get_position (dc_pelican_parked) == 1,1);

end

//hide all HUD and remove player input for the outro
script static void f_hide_players_outro
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
		object_hide (player1, true)	;
	else
		object_hide (player0, true);
	end
end


////return all HUD and remove player input for the outro
//script static void f_unhide_players_outro
//	print ("un-hiding the players");
////	player_enable_input (false);
////	player_control_fade_in_all_input (.1);
//	hud_show (true);
////	if game_coop_player_count() == 4 then
////		object_hide (player0, true);
////		object_hide (player1, true);
////		object_hide (player2, true);
////		object_hide (player3, true);
////	elseif game_coop_player_count() == 3 then
////		object_hide (player0, true);
////		object_hide (player1, true);
////		object_hide (player2, true);
////	elseif game_coop_player_count() == 2 then
////		object_hide (player0, true);
////		object_hide (player1, true)	;
////	else
////		object_hide (player0, true);
////	end
//end


//===============ENDING E1 M5==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//===================misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////






//script continuous f_misc_events_m5_weapon_drop_1
script static void f_misc_events_m5_weapon_drop_1
	sleep_until (LevelEventStatus("m5_weapon_drop_1"), 1);
//	cinematic_set_title (weapon_drop);
	print ("weapon drop 1");
	m2_vo_weapon_drop_1();
	//f_weapon_drop();
	//calling this directly instead of using the WAVE weapon drop functionality
	//f_resupply_pod (dm_resupply_02, sc_resupply_02);
	ordnance_drop(weapon_drop_1, "storm_rocket_launcher");
end

//script continuous f_misc_events_m5_weapon_drop_2
script static void f_misc_events_m5_weapon_drop_2
	sleep_until (LevelEventStatus("m5_weapon_drop_2"), 1);
//	cinematic_set_title (weapon_drop);
	print ("weapon drop 2");
	m2_vo_weapon_drop_2();
	//f_weapon_drop();
	//calling this directly instead of using the WAVE weapon drop functionality
	//f_resupply_pod (dm_resupply_01, sc_resupply_01);
	ordnance_drop(weapon_drop_2, "storm_rocket_launcher");
end

//script continuous f_misc_events_m5_weapon_drop_3
script static void f_misc_events_m5_weapon_drop_3
	sleep_until (LevelEventStatus("m5_weapon_drop_3"), 1);
//	cinematic_set_title (weapon_drop);
	print ("weapon drop 3");
	m2_vo_weapon_drop_1();
	//f_weapon_drop();
	//calling this directly instead of using the WAVE weapon drop functionality
	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
	ordnance_drop(weapon_drop_3, "storm_rocket_launcher");
end

//script continuous f_misc_events_m5_weapon_drop_6
script static void f_misc_events_m5_weapon_drop_6
	sleep_until (LevelEventStatus("m5_weapon_drop_6"), 1);
//	cinematic_set_title (weapon_drop);
	print ("weapon drop 3");
	m2_vo_weapon_drop_1();
	//f_weapon_drop();
	//calling this directly instead of using the WAVE weapon drop functionality
	//f_resupply_pod (dm_resupply_03, sc_resupply_03);
	ordnance_drop(weapon_drop_6, "storm_rocket_launcher");
end




//script continuous f_wait_for_small_pod_0
script static void f_surprise_elite
	sleep_until (LevelEventStatus("surprise"), 1);
	print ("surprise elite");
	//cinematic_set_title (incoming);
	//m1_vo_enemy_drop_pod();
	sleep_s (2);
	ai_place (sq_surprise);
	//f_small_drop_pod_0();
end

//script continuous f_wait_for_small_pod_1
//script static void f_wait_for_small_pod_1
//	sleep_until (LevelEventStatus("pod_1"), 1);
//	print ("pod_1 launching");
//	cinematic_set_title (incoming);
//	//sound_impulse_start (vo_misc_incoming, none, 1.0);
//	m2_vo_pod_1();
//	f_small_drop_pod_1();
//end

script command_script cs_small_drop_pod
	sleep_s (5);
	ai_set_objective (ai_current_squad, obj_survival);
end

// PHANTOM ATTACK 1 =================================================================================================== 
script command_script cs_ff_phantom_attack_1()
	cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (sq_ff_phantom_attack_1.phantom, true);
	cs_fly_by (ps_ff_phantom_attack_1.p0);
	cs_enable_targeting (true);

	cs_fly_by (ps_ff_phantom_attack_1.p1);
	cs_fly_by (ps_ff_phantom_attack_1.p2);
	cs_fly_by (ps_ff_phantom_attack_1.p3);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

// PHANTOM ATTACK 2 =================================================================================================== 
script command_script cs_ff_phantom_attack_2()
	cs_ignore_obstacles (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	cs_fly_to_and_face (ps_ff_phantom_attack_2.p0, ps_ff_phantom_attack_2.face);
	
	cs_enable_targeting (true);
	
	sleep_s (1);
	
	cs_fly_to_and_face (ps_ff_phantom_attack_2.fight, ps_ff_phantom_attack_2.face);
	
	sleep_s (3);
	
	cs_fly_to (ps_ff_phantom_attack_2.p1);
	cs_enable_targeting (false);
	
	cs_fly_to (ps_ff_phantom_attack_2.p2);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

// PHANTOM ATTACK 3 =================================================================================================== 
script command_script cs_ff_phantom_attack_3()
	cs_ignore_obstacles (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	cs_fly_to_and_face (ps_ff_phantom_attack_3.p0, ps_ff_phantom_attack_3.face);
	
	cs_enable_targeting (true);
	
	sleep_s (1.5);
	
	cs_fly_to_and_face (ps_ff_phantom_attack_3.fight, ps_ff_phantom_attack_3.face);
	
	sleep_s (4);
	
	cs_fly_to (ps_ff_phantom_attack_3.p1);
	cs_enable_targeting (false);
	
	cs_fly_to (ps_ff_phantom_attack_3.p2);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

// PHANTOM ATTACK 4 =================================================================================================== 
script command_script cs_ff_phantom_attack_4()
	sleep_until (volume_test_players (tv_phantom_attack_4), 1);
	
	cs_ignore_obstacles (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	cs_fly_to_and_face (ps_ff_phantom_attack_4.p0, ps_ff_phantom_attack_4.face);
	
	cs_enable_targeting (true);
	
	//sleep_s (1.5);
	
	//cs_fly_to_and_face (ps_ff_phantom_attack_4.fight, ps_ff_phantom_attack_4.face);
	
	//sleep_s (4);
	
	cs_fly_to (ps_ff_phantom_attack_4.p1);
	cs_enable_targeting (false);
	
	cs_fly_to (ps_ff_phantom_attack_4.p2);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

// PHANTOM ATTACK flyovers =================================================================================================== 

script command_script cs_ff_phantom_flyover_1()
	cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
	sleep_s (1);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (ai_current_actor, true);
	cs_fly_by (ps_ff_phantom_flyover.p0);
//	cs_enable_targeting (true);

	cs_fly_by (ps_ff_phantom_flyover.p3);
	cs_fly_by (ps_ff_phantom_flyover.p6);
		
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

script command_script cs_ff_phantom_flyover_2()
	cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
	sleep_s (2);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (ai_current_actor, true);
	cs_fly_by (ps_ff_phantom_flyover.p1);
//	cs_enable_targeting (true);

	cs_fly_by (ps_ff_phantom_flyover.p4);
	cs_fly_by (ps_ff_phantom_flyover.p7);
		
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end

script command_script cs_ff_phantom_flyover_3()
	cs_ignore_obstacles (false);
	cs_enable_pathfinding_failsafe (TRUE);
//	ai_set_blind (ai_current_squad, FALSE);
	ai_cannot_die (ai_current_actor, true);
	cs_fly_by (ps_ff_phantom_flyover.p2);
//	cs_enable_targeting (true);

	cs_fly_by (ps_ff_phantom_flyover.p5);
	cs_fly_by (ps_ff_phantom_flyover.p8);
		
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep_s (3);
	ai_erase (ai_current_squad);
	
end


script command_script cs_ff_phantom_surprise_01()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (sq_phantom_surprise.phantom, TRUE);
//	ai_set_blind (ai_current_squad, TRUE);
	cs_enable_targeting (true);
	cs_fly_by (ps_phantom_surprise.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_phantom_surprise.p1);
//		(print "flew by point 1")
	cs_fly_to (ps_phantom_surprise.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 3);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (sq_phantom_surprise.phantom, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("ff_phantom_01 unloaded");
	sleep (30 * 2);
	//(cs_vehicle_speed 0.50)
	//cs_fly_to (ps_phantom_surprise.p1);
	cs_fly_to (ps_phantom_surprise.p3);
	cs_fly_to (ps_phantom_surprise.erase);
//	(cs_fly_by ps_ff_phantom_01/erase 10)
// erase squad 
	sleep (30 * 15);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end


// ==============================================================================================================
//====== FORERUNNER SPAWNING SCRIPTS SCRIPTS ===============================================================================
// ==============================================================================================================
//move these to the main script if forerunners are on other missions

script command_script cs_bishop_spawn()
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteBishopBirth, 0);
  cs_pause (1.0);
end

script static void OnCompleteBishopBirth()
	print ("Bishop spawned"); // you can do something more here if you want
end

//phase in for pawns
script command_script cs_pawn_spawn_e1m5
	print ("pawn phase in");
	
//	sleep_until (ai_not_in_limbo_count (ai_current_squad) > 0);
//	
//	print ("no actors in limbo, calling effect");
	
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

//pawn screaming
script command_script cs_pawn_scream
	print ("pawn phase in, scream");
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep_rand_s (0.5, 3);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
//	sleep_s (2.5);
	ai_set_objective (ai_current_actor, obj_survival);

end

//Phase in for Knights
script command_script cs_knight_phase
	print ("knight phase in");
//	print_cs();
	cs_phase_in();
end

script static void print_cs
	print ("knight phase in");

end


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
//	thread(small_pod_1->drop_to_point( sq_ff_drop_1, ps_ff_drop_pods.p1, .85, DEFUALT ));
//end



// ==============================================================================================================
// ====== PELICAN COMMAND SCRIPTS ===============================================================================
// ==============================================================================================================



// ==============================================================================================================
//====== INTRO ===============================================================================
// ==============================================================================================================



script static void f_start_player_intro_e1_m5
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		//firefight_mode_set_player_spawn_suppressed(false);
		sleep_s (1);
//		intro_vignette_e1_m5();
		//b_wait_for_narrative_hud = false;
		
		firefight_mode_set_player_spawn_suppressed(false);
	else
	//	sleep_s (8);
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		intro_vignette_e1_m5();
	end
	//intro();
	//firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
end

script static void intro_vignette_e1_m5
	print ("_____________starting vignette__________________");
	//sleep_s (8);
	
		//placing the spawned AI in limbo so they don't show up in the puppeteer
	ai_enter_limbo (e1_m5_gr_ff_all);
	print ("all ai placed in limbo for the puppeteer");
	
	thread (f_music_start_e1_m5_vignette());
	
	//play the puppeteer
	ex1();
	
	// start VO
	thread (vo_e1m5_intro());
	
// wait until the puppeteer is complete
	sleep_until (b_wait_for_narrative == false, 1);
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	
	//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (object_get_health (player0) > 0, 1);
	print ("player is alive");
	
	sleep_s (0.5);
	fade_in (0,0,0,15);
	
	ai_erase (squads_elite);
	ai_erase (squads_jackal);
	
	//placing the spawned AI out of limbo after the puppeteer
	ai_exit_limbo (e1_m5_gr_ff_all);
	print ("all ai exiting limbo after the puppeteer");
	
end

script static void f_narrative_done
	print ("narrative done");
	b_wait_for_narrative = false;
//	sleep_until (object_get_health (player0) > 0, 1);
//	print ("player is alive");
//	fade_in (0,0,0,1);
end

//==TEST

global object g_ics_player = none;

script static void f_push_fore_switch (object dev, unit player)
//script static void f_push_fore_switch (unit player)
	print ("pushing the forerunner switch");
	g_ics_player = player;
//	g_ics_player = player0;
	if dev == power_switch then
		pup_play_show (e1_m5_push_power_button);
//	elseif dev == power_switch_temp then
//		pup_play_show (e1_m5_push_power_button);
	
	else
		pup_play_show (e1_m5_push_art_button);
	end
end

script static void e3_zone
	print ("switching e3 zone set");
	switch_zone_set (e3_scene);
	
end

script static void f_temp_pip
	print ("pip playing");
	hud_play_pip ("TEMP_PIP");
	sleep_s (10);
	hud_play_pip ("");	
end

