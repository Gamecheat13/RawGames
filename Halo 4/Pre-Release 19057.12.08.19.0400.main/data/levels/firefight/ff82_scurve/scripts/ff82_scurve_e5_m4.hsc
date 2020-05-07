// =============================================================================================================================
//===============SCURVE e5_m4 FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
//====== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
/// ================================================== GLOBAL ==================================================================
// =============================================================================================================================
// ================================================== TITLES ==================================================================
global boolean mission_is_e5_m4 = false;

script startup scurve_e5_m4
	//Start the intro
	sleep_until (LevelEventStatus("e5_m4"), 1);
	print ("****************** STARTING E5 M4 *********************");
	thread(f_music_e5m4_mission_start()); 
	
	f_e5_m4_zone_set_switch();
	//switch_zone_set (e5_m4);	
	mission_is_e5_m4 = true;
	b_wait_for_narrative = true;
	ai_ff_all = gr_e5_m4_ff_all;
	ai_defend_all = gr_e5_m4_defend_all;
	
	dm_droppod_3 = dm_e5_m4_drop_3;
	thread(f_start_player_intro_e5_m4());
	
	//start the first event script
	thread (f_start_events_e5_m4_1());
	
	//start all the event scripts
	thread (f_start_all_events_e5_m4());

// ================================================== AI ==================================================================

//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;

	
//============= OBJECTS ==================================================================
//set crate names


//	f_add_crate_folder(bi_e5_m4_unsc); //Cov Cover and fluff in the meadow
	f_add_crate_folder(dc_e5_m4_turrets); //Cov Cover and fluff in the meadow	
//	f_add_crate_folder(cr_e1_m5_cov_cover); //cov crates all around the main area	
	f_add_crate_folder(cr_e5_m4_unsc_cover); //Cov Cover and fluff in the meadow		
	f_add_crate_folder(eq_e5_m4_ammo); //Cov Cover and fluff in the meadow	
	f_add_crate_folder(dm_e5_m4_pads); //Cov Cover and fluff in the meadow		
	f_add_crate_folder(wp_e5_m4_weapons); //Cov Cover and fluff in the meadow			
	f_add_crate_folder(v_e5_m4_guns); //Cov Cover and fluff in the meadow		
	f_add_crate_folder(dm_e5_m4_drop_rails); //Cov Cover and fluff in the meadow				

	
	
//set spawn folder names
//	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(sc_e5_m4_spawn_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns in the front building
//	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the back building
	firefight_mode_set_crate_folder_at(sc_e5_m4_defend_spawns, 92); //spawns in the back building
	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the left building
	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //spawns in the right side in the way back
	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //spawns in the back on the hill (facing the back)
	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //spawns in the very back facing down the hill
	firefight_mode_set_crate_folder_at(spawn_points_9, 99); //spawns in the very back facing down the hill	
	
//set objective names
	firefight_mode_set_objective_name_at(e5_m4_core_1, 1); //powercore
	firefight_mode_set_objective_name_at(e5_m4_core_2, 2); //powercore
//	firefight_mode_set_objective_name_at(e5_m4_iff_tag, 3); //IFF tag
	firefight_mode_set_objective_name_at(dc_e5_m4_iff, 3); //IFF tag
	firefight_mode_set_objective_name_at(marker_1, 4); //IFF tag
	firefight_mode_set_objective_name_at(marker_2, 5); //IFF tag
	firefight_mode_set_objective_name_at(e5_m4_roland_location, 6);
	
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
		
//set squad group names

	firefight_mode_set_squad_at(gr_e5_m4_guards_1, 1);	//left building
	firefight_mode_set_squad_at(gr_e5_m4_guards_2, 2);	//front by the main start area
	firefight_mode_set_squad_at(gr_e5_m4_guards_3, 3);	//back middle building
	firefight_mode_set_squad_at(gr_e5_m4_guards_4, 4); //in the main start area
	firefight_mode_set_squad_at(gr_e5_m4_guards_5, 5); //right side in the back
	firefight_mode_set_squad_at(gr_e5_m4_guards_6, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(gr_e5_m4_guards_7, 7); //middle building at the front
	firefight_mode_set_squad_at(gr_e5_m4_guards_8, 8); //on the bridge
	firefight_mode_set_squad_at(gr_e5_m4_guards_9, 9); //by the tunnel
	
	firefight_mode_set_squad_at(sq_e5_m4_spec_ops, 15);
	
//	firefight_mode_set_squad_at(gr_e5_m4_bridge_guards, 30); //bridge guards
	
	firefight_mode_set_squad_at(gr_e5_m4_marines_1, 	31); //main defense area
	firefight_mode_set_squad_at(gr_e5_m4_marines_2, 	32); //back spawn point
	
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
	firefight_mode_set_squad_at(gr_e5_m4_waves_1, 81);
	firefight_mode_set_squad_at(gr_e5_m4_waves_2, 82);	
	firefight_mode_set_squad_at(gr_e5_m4_waves_3, 83);
	firefight_mode_set_squad_at(gr_e5_m4_waves_4, 84);	
	firefight_mode_set_squad_at(gr_e5_m4_waves_5, 85);	
	firefight_mode_set_squad_at(gr_e5_m4_waves_6, 86);
	firefight_mode_set_squad_at(gr_e5_m4_waves_7, 87);	
	firefight_mode_set_squad_at(gr_e5_m4_waves_8, 88);	
	firefight_mode_set_squad_at(gr_e5_m4_waves_9, 89);				
//	firefight_mode_set_squad_at(gr_e5_m4_allies, 51);		
			
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
//	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
//	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge

	firefight_mode_set_squad_at(sq_e5_m4_phantom_1, 21); //phantom 1
	firefight_mode_set_squad_at(sq_e5_m4_phantom_2, 22); //phantom 1
	firefight_mode_set_squad_at(sq_e5_m4_phantom_5, 25); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//======== MAIN SCRIPT STARTS ==================================================================

end




//========STARTING E4 M4==============================



script static void f_start_all_events_e5_m4

	thread (f_end_events_e5_m4_1());
	print ("ending e5_m4_1");

	thread (f_start_events_e5_m4_2());
	print ("starting e5_m4_2");
	
	thread (f_end_events_e5_m4_2());
	print ("ending e5_m4_2");
	
	thread (f_start_events_e5_m4_3());
	print ("starting e5_m4_3");
	
	thread (f_end_events_e5_m4_3());
	print ("ending e5_m4_3");
	
	thread (f_start_events_e5_m4_4());
	print ("starting e5_m4_4");
	
	thread (f_end_events_e5_m4_4());
	print ("ending e5_m4_4");
	
	thread(f_end_events_e5_m4_5());
	print ("ending e5_m4_5");
	
	thread (f_misc_spawn_turrets());
	print ("starting spawn turrets");
	
	thread (f_e5_m4_turret_vo());
	print ("starting turret vo");
	
	thread ( f_e5_m4_callouts());
	print ("starting callout");
	
	thread (f_e5_m4_phantom_callouts());
	print ("starting phantom callout");
	
	thread (f_e5_m4_heavy_callouts());
	print ("starting heavy callouts");
	
	f_e5_m4_lose_condition();

end

script static void f_start_events_e5_m4_1
	sleep_until (LevelEventStatus("start_e5_m4_1"), 1);
	print ("STARTING start_e5_m4_go_1");
	
	thread(f_music_e5m4_encounter_1_start()); 
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
	ai_place (sq_e5_m4_heavy_marines);
	object_create (e5_m4_iff_tag);
	object_create (e1_m5_doors);
	
	//place mantis if 1-2 players and warthogs if 3-4
	if game_coop_player_count() <= 2 then
		//object_create_folder (bi_e5_m4_unsc);
		print ("coop count 1 or 2 spawning mantis");
		
		thread (f_e5_m4_veh_respawn (e5_m4_mantis1));
		thread (f_e5_m4_veh_respawn (e5_m4_mantis2));
		thread (f_e5_m4_veh_respawn (e5_m4_mantis3));
		thread (f_e5_m4_veh_respawn (e5_m4_mantis4));
		
//		ai_object_set_team (e5_m4_mantis1, player);
//		object_set_allegiance (e5_m4_mantis1, player);
//	
//		ai_object_set_team (e5_m4_mantis2, player);
//		object_set_allegiance (e5_m4_mantis2, player);
	else
		//object_create_folder (v_e5_m4_unsc);
		print ("coop count 3 or 4 spawning warthogs");
		thread (f_e5_m4_veh_respawn (e5_m4_hog_1));
		thread (f_e5_m4_veh_respawn (e5_m4_hog_2));
		thread (f_e5_m4_veh_respawn (e5_m4_hog_3));
		thread (f_e5_m4_veh_respawn (e5_m4_hog_4));

	end
	
	//ai_place (sq_marine_heavy);
	sleep_until (b_players_are_alive(), 1);
	
	//start some initial housekeeping
	
	//controls the warthogs and when the AI are allowed to get in/drive them
	thread (f_reserve_seats());
	
	//turn off the shields at the playspace
	f_e5_m4_powered_cover();
	//set the health of the generators based on difficulty
	f_e5_m4_generator_health();
	//set a VO thread for killing the initial enemies
	thread (f_e5_m4_goal_2_vo());
		
	sleep_s (2);
	
	if game_coop_player_count() <= 2 then
		vo_e5m4_marines();
	else
		vo_e5m4_marines2();
	end
	
	//temp pip
	//hud_play_pip_from_tag (bink\spops\ep5_m4_1_60);
	
	
	f_new_objective (ch_e5_m4_1);
	
	//spawn the phantom_5 when players hit the trigger volume
	//f_e5_m4_first_phantom();
	
end

script static void f_e5_m4_goal_2_vo
	print ("goal 2 vo");
	sleep_until (ai_living_count (ai_ff_all) > 0, 1);
	sleep_until (ai_living_count (ai_ff_all) <= 0 or firefight_mode_goal_get() == 2, 1);
	
	if firefight_mode_goal_get() < 2 then
		vo_e5m4_needhelp();
	end

end

script static void f_e5_m4_powered_cover
	//turn off the powered cover in the forerunner play space
//	device_set_power (dm_bridge_cover_3, 0);
//	device_set_power (dm_bridge_cover_4, 0);
//	device_set_power (dm_bridge_cover_5, 0);
//	device_set_power (dm_bridge_cover_6, 0);
	object_destroy_folder (dm_cover_objects);

end

script static void f_e5_m4_first_phantom
//spawn the phantom_5 when players hit the trigger volume
	sleep_until (volume_test_players (tv_e5_m4_phantom), 1);
	print ("phantom volume hit");
	
	sleep_until (ai_living_count (ai_ff_all) < 11, 1);
	
	if firefight_mode_goal_get() < 2 then
		print ("-- spawning phantom and spec ops");
	
		thread(f_music_e5m4_encounter_1_phantoms_spawn()); 
		ai_place (sq_e5_m4_phantom_5);
		ai_place (sq_e5_m4_spec_ops);
		f_load_dropship (ai_vehicle_get_from_spawn_point(sq_e5_m4_phantom_5.0) ,sq_e5_m4_spec_ops);
	else
		print ("defend mode started, not spawning spec ops phantom");
	end	
	

end

//==GENERATOR HEALTH

script static void f_e5_m4_generator_health
	//change the health of the generators based on game difficulty
		if game_difficulty_get_real() == "easy" then
		print ("game is normal, times 4 generator health");
		f_e5_m4_core_health (4);
	end
	
	
	if game_difficulty_get_real() == "normal" then
		print ("game is normal, times 4 generator health");
		f_e5_m4_core_health (4);
	end
	
	if game_difficulty_get_real() == "heroic" then
		print ("game is heroic, times 8 generator health");
		f_e5_m4_core_health (8);
//		object_set_maximum_vitality (e5_m4_core_1, object_get_maximum_vitality (e5_m4_core_1, false) * 4, 0);
////		unit_set_current_vitality (unit (e5_m4_core_1), object_get_maximum_vitality (e5_m4_core_1, false) * 2, 0);
//		object_set_maximum_vitality (e5_m4_core_2, object_get_maximum_vitality (e5_m4_core_2, false) * 4, 0);
	
	end
	
	if game_difficulty_get_real() == "legendary" then
		print ("game is legendary, times 12 generator health");
		f_e5_m4_core_health (12);
		
//		object_set_maximum_vitality (e5_m4_core_1, object_get_maximum_vitality (e5_m4_core_1, false) * 8, 0);
//		//unit_set_current_vitality (unit (e5_m4_core_1), object_get_maximum_vitality (e5_m4_core_1, false) * 4, 0);
//		object_set_maximum_vitality (e5_m4_core_2, object_get_maximum_vitality (e5_m4_core_2, false) * 8, 0);
	end

end

global real r_player_multiplier = 1;
global real r_core1_vitality 		= 200;
global real r_core2_vitality 		= 200;
global real r_core_health_bump 	= 1.5;

script static short f_e5_m4_player_multiplier
	//print ("player multiplier");
	//set a multiplier to divide the health of the generators based on the number of players
	if game_coop_player_count() == 1 then r_player_multiplier = 1;
	end
	
	if game_coop_player_count() == 2 then r_player_multiplier = 1;
	end
	
	if game_coop_player_count() == 3 then r_player_multiplier = 1.5;
	end

	if game_coop_player_count() == 4 then r_player_multiplier = 1.5;
	end
	
	print ("player multiplier is");
	inspect (r_player_multiplier);
	
	r_player_multiplier;
end

script static void f_e5_m4_core_health (short multiplier)
	//sets the health of the generators based on the difficulty level and number of players
	print ("cores health multiplied by");
	inspect (multiplier);
	
	r_core1_vitality = object_get_maximum_vitality (e5_m4_core_1, false);
	r_core2_vitality = object_get_maximum_vitality (e5_m4_core_2, false);
	object_set_maximum_vitality (e5_m4_core_1, r_core1_vitality * multiplier / f_e5_m4_player_multiplier(), 0);
	object_set_maximum_vitality (e5_m4_core_2, r_core2_vitality * multiplier / f_e5_m4_player_multiplier(), 0);
	
	r_core1_vitality = object_get_maximum_vitality (e5_m4_core_1, false);
	r_core2_vitality = object_get_maximum_vitality (e5_m4_core_2, false);
end

script static void f_e5_m4_lose_condition
	//sleep until one gen is destroyed then play the one down VO
	//lose the game if both the generators are destroyed
	
	print ("lose condition started");
	
//	sleep_until (object_get_health (obj_defend_1) > 0 and object_get_health (obj_defend_2) > 0, 1);
//	
//	//sleep_until one of the generators is destroyed
//	sleep_until (object_get_health (obj_defend_1) <= 0 or object_get_health (obj_defend_2) <= 0, 1);
//	
	sleep_until (s_defend_obj_destroyed == 1, 1);
	thread(f_music_e5m4_one_generator_destroyed()); 
	f_e5_m4_more_health();
	vo_e5m4_1genfail();
	
	//sleep_until (object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0, 1);
	sleep_until (s_defend_obj_destroyed == 2, 1);
	
	//start game lost scripts
	b_game_lost = true;
	thread(f_music_e5m4_game_lost()); 
	print ("both generators were blown up -- game lost");	
	vo_e5m4_allgenfail();
	//insert cui screen here
	cui_load_screen (ui\in_game\pve_outro\mission_failed.cui_screen);
	fade_out (0, 0, 0, 90);
	
end

script static void f_e5_m4_more_health
	print ("1 core destroyed give more health to other core");
	local real r_current_health = 0;
	
	if object_get_health (e5_m4_core_1) > 0 then
		print ("core 1 alive, adjust health of core 1");
		r_current_health = object_get_health (e5_m4_core_1);
		object_set_maximum_vitality (e5_m4_core_1, r_core1_vitality * r_core_health_bump * r_current_health, 0);
		r_core1_vitality = object_get_maximum_vitality (e5_m4_core_1, false);
	elseif object_get_health (e5_m4_core_2) > 0 then
		print ("core 2 alive, adjust health of core 2");
		r_current_health = object_get_health (e5_m4_core_2);
		object_set_maximum_vitality (e5_m4_core_2, r_core2_vitality * r_core_health_bump * r_current_health, 0);
		r_core2_vitality = object_get_maximum_vitality (e5_m4_core_2, false);
	end
	inspect (r_core1_vitality);
	inspect (r_core2_vitality);

end

//==GENERATOR HEALTH

script static void f_end_events_e5_m4_1
	//plays VO and destroys the first marker
	sleep_until (LevelEventStatus("end_e5_m4_1"), 1);
	print ("ENDING start_e5_m4_switch_1");
	
	object_destroy (marker_1);
	
	//ai_set_objective (ai_ff_all, obj_e5_m4_survival);
	
	thread(f_music_e5m4_baddies_vo()); 
	vo_e5m4_nonpip_baddies();
	
	sleep (10);
	
	vo_e5m4_pip_baddies();
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	//sleep (30);
//	//sleep (30 * 7);
//	start_e1_m3_switch_2_vo();
//	cinematic_set_title (title_shut_down_comm);
	
end


script static void f_start_events_e5_m4_2
	
	sleep_until (LevelEventStatus("start_e5_m4_2"), 1);
	print ("STARTING start_e5_m4_2");

//	cinematic_set_title (defend_obj_1);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
	
//	thread(f_music_e5m4_at_base_vo()); 
//	vo_e5m4_atbase();
//	f_new_objective (ch_e5_m4_2);
end

script static void f_end_events_e5_m4_2
	sleep_until (LevelEventStatus("end_e5_m4_2"), 1);
	print ("ENDING start_e5_m4_2");

	//setting the AI to follow after the 2nd marker to prevent them from trying to cross the bridge because of AI pathing bug
	ai_set_objective (ai_ff_all, obj_e5_m4_survival);

	object_destroy (marker_2);
end


//==DEFEND BASE


script static void f_start_events_e5_m4_3
	//defend the generators
	sleep_until (LevelEventStatus("start_e5_m4_3"), 1);
	print ("STARTING start_e5_m4_3");
	
	ai_place (sq_e5_m4_marines_2);

	//turn off distortion effect for performances
	effects_distortion_enabled = 0;

	b_wait_for_narrative_hud = true;
	
	
	thread(f_music_e5m4_defendgens_vo()); 
	vo_e5m4_defendgens();
	f_new_objective (ch_e5_m4_2);
	b_wait_for_narrative_hud = false;

//sleep for a couple of seconds until after the cores are blipped, then blips the enemies
	sleep_s (2);
	thread (f_e5_m4_blip_all_enemies());

	//sleep until the turrets are started through Bonobo
	sleep_until (LevelEventStatus("start_turrets"), 1);
	thread(f_music_e5m4_unscturrets_vo()); 
	vo_e5m4_unscturrets();

end

// can't play this because it references Palmer
//script static void f_e5_m4_vo
//	print ("playing heavy forces");
//	sleep_until (b_dialog_playing == false, 1);
//	b_dialog_playing = true;
//	thread(f_music_e5m4_heavyforces_vo()); 
//	//vo_glo_heavyforces_02();
//	b_dialog_playing = false;
//
//end

script static void f_end_events_e5_m4_3
	sleep_until (LevelEventStatus("end_e5_m4_3"), 1);

	//base is safe
	//earn achievement if on heroic or legendary and both gens are alive
	if game_difficulty_get_real() == heroic or game_difficulty_get_real() == legendary then
		print ("game is heroic or legendary");
		if object_get_health (e5_m4_core_1) > 0 and object_get_health (e5_m4_core_2) > 0 then
			print ("both generators are safe, achievement unlocked");
			f_e5_m4_achievement_watch();
		else
			print ("both generators are NOT alive, no achievement earned");
		end
	else
		print ("game is normal or easy, no achievement");
	end
	
end


//== BASE IS SAFE


script static void f_start_events_e5_m4_4
	sleep_until (LevelEventStatus("start_e5_m4_4"), 1);
	print ("STARTING start_e1_m5_4");
	
	//turn on distortion effect
	effects_distortion_enabled = 1;
	
	//play good job VO and tell player about IFF tag, if the generators are still alive
	if object_get_health (obj_defend_1) > 0 or object_get_health (obj_defend_2) > 0 then
		//go get the IFF tag
		b_wait_for_narrative_hud = true;
		
		//turn off the turret switches if they haven't been activated
		thread (f_e5_m4_power_down_turrets());
		
		sleep_s (3);
		
//		thread(f_music_e5m4_nicework_vo()); 
//		vo_glo_nicework_10();
//			
//		sleep_s (3);
		
		thread(f_music_e5m4_allclear_vo()); 
		vo_e5m4_allclear();
		
		//turn on the IFF device control and mark it
		device_set_power (dc_e5_m4_iff, 1);
		b_wait_for_narrative_hud = false;
	
	else
		
		//don't show anything if the player lost
		b_wait_for_narrative_hud = true;
		print ("ending e5_m4_4 because the player lost");
	end
end

script static void f_e5_m4_power_down_turrets
	//turn off the turret switches and navpoint markers if they haven't been activated

	if device_get_power (turret_switch_0) == 1 then
		device_set_power (turret_switch_0, 0);
		f_unblip_object_cui (turret_switch_0);
	end
	if device_get_power (turret_switch_1) == 1 then
		device_set_power (turret_switch_1, 0);
		f_unblip_object_cui (turret_switch_1);
	end

end

script static void f_end_events_e5_m4_4
	sleep_until (LevelEventStatus("end_e5_m4_4"), 1);
	print ("ENDING start_e5_m4_4");

	if object_get_health (obj_defend_1) > 0 or object_get_health (obj_defend_2) > 0 then
		//got the IFF tag -- maybe interrupt the previous VO
		b_wait_for_narrative_hud = true;
		object_hide (e5_m4_iff_tag, true);
		
		//hud_play_pip_from_tag (bink\spops\ep5_m4_3_60);
		thread(f_music_e5m4_atifftag_vo()); 
		vo_e5m4_atifftag();
		
		b_wait_for_narrative_hud = false;
	else
		print ("ending e5_m4_4 because the player lost");
		
	end
	
end
//
//
//
//script continuous f_start_events_e5_m4_5
//	sleep_until (LevelEventStatus("start_e5_m4_5"), 1);
//	print ("STARTING start_e1_m5_clear_base_2");
//	//sleep (30);
//	
//	//sleep (30);
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
//	
//end
//
script static void f_end_events_e5_m4_5
	sleep_until (LevelEventStatus("end_e5_m4_5"), 1);
	print ("ending e5_m4_5");
	
	//turn on the chapter complete screen_effect_new
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);



end
//
//
//
//script continuous f_end_events_e5_m4_6
//	sleep_until (LevelEventStatus("end_e5_m4_6"), 1);
//	print ("ENDING start_e5_m4_6");
//	//sleep (30);
//	sound_looping_stop (music_start);
//	
//end
//
//
//script continuous f_start_events_e5_m4_7
//	sleep_until (LevelEventStatus("start_e5_m4_7"), 1);
//	print ("STARTING start_e1_m5_swarm");
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_up_beat, NONE, 1.0);
//	//f_blip_object_cui (lz_5, "navpoint_goto");
//	//sleep (30);
//
//	start_e1_m3_lz_3_vo();
//	cinematic_set_title (title_swarm_1);
//end
//
//script continuous f_end_events_e5_m4_7
//	sleep_until (LevelEventStatus("end_e5_m4_7"), 1);
//	print ("ENDING start_e5_m4_7");
//
//	sound_looping_stop (music_start);
//	
//end

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

//================ENDING E4 M4==============================



////////////////////////////////////////////////////////////////////////////////////////////////////////
//===misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////

script static void f_e5_m4_callouts
	repeat
		sleep_until (LevelEventStatus("more_enemies1"), 1);
		print ("more enemies event");
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
		if editor_mode() then
			cinematic_set_title (title_more_enemies);
		end
		begin_random_count (1)
			vo_glo_incoming_01();
			vo_glo_incoming_02();
			vo_glo_incoming_03();
			vo_glo_incoming_04();
			vo_glo_incoming_05();
			//commenting the last of these because they are Palmer lines (who should not be in ep5)
//			vo_glo_incoming_06();
//			vo_glo_incoming_07();
//			vo_glo_incoming_08();
//			vo_glo_incoming_09();
//			vo_glo_incoming_10();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true);
end

script static void f_e5_m4_phantom_callouts
	repeat
		sleep_until (LevelEventStatus("more_phantoms"), 1);
		print ("more enemies event");
		
		begin_random_count (1)
			ai_place (sq_e5_m4_phantom_3);
			ai_place (sq_e5_m4_phantom_4);
		end
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
		if editor_mode() then
			cinematic_set_title (title_more_enemies);
		end
		begin_random_count (1)
			//vo_glo_phantom_01();
			//vo_glo_phantom_02();
			//vo_glo_phantom_03();
//commenting these because they are Palmer lines (who should not be in ep5)			
//			vo_glo_phantom_04();
//			vo_glo_phantom_05();
//			vo_glo_phantom_06();
			vo_glo_phantom_07();
			vo_glo_phantom_08();
			vo_glo_phantom_09();
			vo_glo_phantom_10();
		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true, 1);
end

script static void f_e5_m4_heavy_callouts
	repeat
		sleep_until (LevelEventStatus("more_heavy"), 1);
		print ("more enemies event");
		
		//ai_place (sq_e5_m4_phantom_3);
		
		sleep_until (b_dialog_playing == false, 1);
		b_dialog_playing = true;
		
		if editor_mode() then
			cinematic_set_title (title_more_enemies);
		end
		begin_random_count (1)
			vo_glo_heavyforces_01();
		//	vo_glo_heavyforces_02();
			vo_glo_heavyforces_03();
		//	vo_glo_heavyforces_04();
		//	vo_glo_heavyforces_05();

		
		end
		
		b_dialog_playing = false;
		
	until (b_game_ended == true, 1);
end

// ===================================================================================
//===========VEHICLE SCRIPTS=======================================
// ==================
// these scripts prevent the marines from getting in warthogs when they aren't supposed to

script static void f_reserve_seats
	print ("reserve seats on warthogs");
	
	if object_valid (e5_m4_hog_1) then
		print ("warthog 1 valid");
		thread (f_e5_m4_seat_reserve_on (e5_m4_hog_1));
	end
	
	if object_valid (e5_m4_hog_2) then
		print ("warthog 2 valid");
		thread (f_e5_m4_seat_reserve_on (e5_m4_hog_2));
	end
	
	if object_valid (e5_m4_hog_3) then
		print ("warthog 3 valid");
		thread (f_e5_m4_seat_reserve_on (e5_m4_hog_3));
	end
	
	if object_valid (e5_m4_hog_4) then
		print ("warthog 4 valid");
		thread (f_e5_m4_seat_reserve_on (e5_m4_hog_4));
	end
	
end


script static void f_e5_m4_seat_reserve_on (vehicle hog)
	print ("reserve seats");
	inspect (hog);
	
	thread (f_e5_m4_seat_control(hog));
	thread (f_e5_m4_ai_driver_control(hog));
	
	repeat
		//sleep until the warthogs are in the 3 off limits trigger volumes, then make the driver and passenger seats unavailable
		sleep_until (volume_test_object (tv_e5_m4_no_driver1, hog) or volume_test_object (tv_e5_m4_no_driver2, hog) or volume_test_object (tv_e5_m4_no_driver3, hog), 1);
		print ("hog in volume, reserving seats");
		
		//if the AI is driving kick the AI out of the driver and passenger seats
		if vehicle_test_seat_unit_list (hog, warthog_d, ai_actors (gr_e5_m4_marines_2)) then
			print ("ai in drivers seat, kicking them out");
			vehicle_unload (hog , warthog_d);
			vehicle_unload (hog , warthog_p);
		else
			print ("player in drivers seat, don't kick out driver");
		end
		
		//sleep until the warthog is outside of the trigger volumes, then make the driver and passenger seats available
		sleep_until (not volume_test_object (tv_e5_m4_no_driver1, hog) and not volume_test_object (tv_e5_m4_no_driver2, hog) and not volume_test_object (tv_e5_m4_no_driver3, hog), 1);
		print ("hog NOT in volume, don't reserve seats");
		
	until (b_game_ended == true, 1);
end



script static void f_e5_m4_seat_control (vehicle warthog)
	print ("seat control start");
	repeat
		ai_vehicle_reserve_seat (warthog, warthog_d, true);
		ai_vehicle_reserve_seat (warthog, warthog_p, true);
		sleep_until (player_in_vehicle (warthog), 1);
		print ("player got in a warthog");
		if volume_test_object (tv_e5_m4_no_driver1, warthog) or volume_test_object (tv_e5_m4_no_driver2, warthog) or volume_test_object (tv_e5_m4_no_driver3, warthog) then
			print ("hog in forbidden trigger volumes, reserving seats");
			//ai_vehicle_reserve_seat (warthog, warthog_d, true);
			//ai_vehicle_reserve_seat (warthog, warthog_p, true);
		else
			print ("hog NOT in forbidden volumes, don't reserve seats");
			ai_vehicle_reserve_seat (warthog, warthog_d, false);
			ai_vehicle_reserve_seat (warthog, warthog_p, false);
		end
		
		sleep_until (not player_in_vehicle (warthog), 1);
		//ai_vehicle_reserve_seat (warthog, warthog_d, true);
		//ai_vehicle_reserve_seat (warthog, warthog_p, true);
		print ("player got out of vehicle, kick out AI");
		vehicle_unload (warthog, "");
		
	until (b_game_ended == true, 1);
end

script static void f_e5_m4_ai_driver_control (vehicle warthog2)
	print ("start driver control");
	repeat
		sleep_until (vehicle_test_seat_unit_list (warthog2, "", ai_actors (gr_e5_m4_marines_2)), 1);
		if not player_in_vehicle (warthog2) then
			print ("ai in warthog without player, kicking out ai");
			vehicle_unload (warthog2, "");
		end	
		
		sleep_until (not player_in_vehicle (warthog2), 1);
	
	until (b_game_ended == true);

end
//test script
//	sleep_until (volume_test_object (tv_res, e5_m4_hog_1), 1);
//	print ("test reserving seat");
//	ai_vehicle_reserve_seat (e5_m4_hog_1, warthog_d, true);
//	if vehicle_test_seat_unit_list (e5_m4_hog_1, warthog_d, ai_actors (gr_e5_m4_marines_2)) then
//		print ("ai in drivers seat, kicking them out");
//		vehicle_unload (e5_m4_hog_1, warthog_d);
//	else
//		print ("player in drivers seat, don't kick out driver");
//	end
//	sleep_until (not volume_test_object (tv_res, e5_m4_hog_1), 1);
//	print ("test you can get back in the seat");
//	ai_vehicle_reserve_seat (e5_m4_hog_1, warthog_d, false);

// ===================================================================================
//===========TURRETS=======================================
// ===================================================================================

script static void InspectDevice(device object)
	inspect(object);
end

script static void f_e5_m4_turret_vo
//remind players about turrets
	print ("turret reminders");
//	vo_e5m4_turretremind();

//sleep_until both turrets online
	sleep_until (object_valid (turret_switch_0) and object_valid (turret_switch_1), 1);
	sleep_until (device_get_position (turret_switch_0) == 1 and device_get_position (turret_switch_1) == 1, 1);
	thread(f_music_e5m4_turrets_online_vo()); 
	vo_e5m4_turretsonline();
end

//currently when called turrets will be around forever
script command_script cs_stay_in_turret
	cs_shoot (true);
	cs_enable_targeting (true);
	cs_enable_moving (true);
	cs_enable_looking (true);
	cs_abort_on_damage (FALSE);
	cs_abort_on_alert (FALSE);
	//(sleep_until (<= (ai_living_count ai_current_actor) 0))
end

//script static void f_create_turret_1
//	object_create_anew (turret_switch_1);
////	f_turret_place (sq_ff_turrets.pilot_1, turret_switch_1, "b");
//end

script static void f_misc_spawn_turrets
//	sleep_until (LevelEventStatus ("spawn_turrets"), 1);
	print ("::TURRETS::");
	sleep_until (object_valid (turret_switch_0));
	object_set_scale (turret_switch_0, 2, 1);
//		print("Turret Status");
	InspectDevice(turret_switch_0);
//	InspectObject(turret_switch_1);

	thread (f_turret_place (sq_e5_m4_turrets.pilot_0, turret_switch_0));
//	object_create (turret_switch_1);
	sleep_until (object_valid (turret_switch_1));
	object_set_scale (turret_switch_1, 2, 1);
	InspectDevice(turret_switch_1);
	thread (f_turret_place (sq_e5_m4_turrets.pilot_1, turret_switch_1));
//	NotifyLevel ("start_turrets");
end



script static void f_turret_place (ai turret_spawn, device dm_switch)
	ai_place (turret_spawn);
	print ("placing turret");
	//set up the turret so it waits until it's ready to be activated

	local unit turret_object = ai_vehicle_get(turret_spawn);

	ai_cannot_die (turret_spawn, true);
	object_cannot_take_damage (turret_spawn);

	object_immune_to_friendly_damage (turret_object, true);

	ai_disregard (ai_actors (turret_spawn), true);
	ai_braindead (turret_spawn, TRUE);
	sentry_deactivate(turret_object);
	sentry_deactivate_barrel(turret_object, 0);
	sentry_deactivate_barrel(turret_object, 1);
	
	
	//the turrets are ready to be turned on
	sleep_until (LevelEventStatus("start_turrets"), 1);
	//turret is now ready to be turned powered on by the player flipping the switch
	print ("powering up turrets");
	//sleep(1);
	inspect (dm_switch);
	device_set_power (dm_switch, 1);
	inspect (device_get_power (dm_switch));
//	device_get_power (dm_switch);
	//chud_track_object_with_priority (ai_vehicle_get (turret_spawn), hud_marker);
	f_blip_object_cui (dm_switch, "navpoint_activate");
//	f_blip_object_cui (ai_get_object (turret_spawn), "navpoint_ally_vehicle");
	sleep_until (device_get_position (dm_switch) > 0, 1);
	thread(f_music_e5m4_player_activated_turret()); 
	
	//the switch is flipped and is now activing shooting at fools
	print ("turret activated and should be shooting");
	f_turret_ai (turret_spawn, dm_switch);
end

script static void f_turret_ai (ai turret_ai, device switch)
//	repeat
		print ("turret online!");
		
		//turn off the switch that turns it on
		device_set_power (switch, 0);
		// Associate the turret AI with the player.
		//ai_object_set_team (turret_ai, player);

		// Turn off the navpoint marker.
		f_unblip_object_cui (switch);

		// Get the actual turret object.
		local unit turret_object = ai_vehicle_get(turret_ai);
		// Associate the turret AI with the player.
		ai_object_set_team (turret_object, player);

		// Activate the sentry and its barrels.
		sentry_activate(turret_object);
		sentry_activate_barrel(turret_object, 0);
		sentry_activate_barrel(turret_object, 1);

		// Restore the sentry turrets health.
//		object_set_health (turret_object, 0.2);
//
//		// Prevent the turret from being destroyed.
		ai_cannot_die(turret_ai, false);                              
		object_can_take_damage(turret_object);
//		// Wake up the turret AI so that it can be attacked.
//		ai_braindead_by_unit (turret_object, false);
//		ai_disregard (ai_actors (turret_ai), false);
//		ai_disregard(turret_object, false);

		// Sleep until the turret is destroyed.
		sleep_until(object_get_health(turret_object) == 0);
		thread(f_music_e5m4_turret_destroyed()); 
		print ("turret is destroyed");

//		// Prevent AI from targeting the turret.
//		ai_braindead_by_unit (turret_object, true);
//		ai_disregard (ai_actors (turret_ai), true);
//		ai_disregard(turret_object, true);
//
//		// Deactivate the turret.
//		sentry_deactivate(turret_object);
//		
//		// Sleep until the turret is available again.
//		sleep (300);        
//
//		// Prevent more damage on the turret.
//		object_cannot_take_damage (turret_object);                  
//
//		// Reset the turret switch so it can be reactivated.
//		//device_set_position_immediate (switch, 0);
//	
//	until (b_game_won == 1 or b_game_lost == 1); 
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

//======PHANTOM SCRIPTS============
// == PHANTOM 01 =================================================================================================== 
script command_script cs_e5_m4_phantom_01()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	//sleep (1);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e5_m4_phantom_1.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_e5_m4_phantom_1.p1);
//		(print "flew by point 1")
//	cs_fly_by (ps_ff_phantom_01.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("phantom_01 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
//	cs_fly_to (ps_e5_m4_phantom_1.p1);
	cs_fly_to (ps_e5_m4_phantom_1.p3);
//	(cs_fly_by ps_e5_m4_phantom_1/erase 10)
// erase squad 
//	sleep (30 * 5);

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end


// == PHANTOM 02 =================================================================================================== 
script command_script cs_e5_m4_phantom_02()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
//	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	cs_enable_targeting (false);
	//ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e5_m4_phantom_2.p0);
//		(print "flew by point 0")
	cs_fly_by (ps_e5_m4_phantom_2.p1);
//		(print "flew by point 1")
	cs_fly_by (ps_e5_m4_phantom_2.p2);
//	(cs_fly_to ps_ff_phantom_01/p3)
//		(print "flew to point 2")
//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("phantom_02 unloaded");
	sleep (30 * 5);
	//(cs_vehicle_speed 0.50)
	cs_fly_to (ps_e5_m4_phantom_2.p1);
	cs_fly_to (ps_e5_m4_phantom_2.p3);
//	(cs_fly_by ps_ff_phantom_01/erase 10)
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end

// == PHANTOM 03 =================================================================================================== 
script command_script cs_e5_m4_phantom_03()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
	
	
	cs_fly_by (ps_e5_m4_phantom_3.p0);
	
	cs_enable_targeting (true);
	
	cs_fly_by (ps_e5_m4_phantom_3.p1);
	cs_fly_to (ps_e5_m4_phantom_3.p2);
	
	sleep_s (5);
	
	cs_fly_to (ps_e5_m4_phantom_3.p3);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);

end

script command_script cs_e5_m4_phantom_04()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
	
	
	cs_fly_by (ps_e5_m4_phantom_3.p0);
	
	cs_enable_targeting (true);
	
	cs_fly_by (ps_e5_m4_phantom_3.p1);
	cs_fly_to (ps_e5_m4_phantom_3.p2);
	
	sleep_s (5);
	
	cs_fly_to (ps_e5_m4_phantom_3.p4);
	
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);

end

script command_script cs_e5_m4_phantom_05()
	//v_ff_phantom_01 = ai_vehicle_get_from_starting_location (sq_ff_phantom_01.phantom);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); //Shrink size over time
	sleep(30);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	sleep (1);
//	object_cannot_die (v_ff_phantom_01, TRUE);
//	cs_enable_pathfinding_failsafe (TRUE);
	cs_ignore_obstacles (TRUE);
	object_set_shadowless (ai_current_actor, TRUE);
	cs_enable_targeting (false);
	//ai_set_blind (ai_current_squad, TRUE);

	cs_fly_by (ps_e5_m4_phantom_5.p0);
	cs_fly_by (ps_e5_m4_phantom_5.p1);

//	(cs_fly_to_and_face ps_ff_phantom_01/p3 ps_ff_phantom_01/face)
//	(cs_vehicle_speed 0.50)
	sleep (30 * 1);

		//======== DROP DUDES HERE ======================
			
	f_unload_phantom (ai_current_actor, "dual");
	
			
		//======== DROP DUDES HERE ======================
		
	print ("phantom_5 unloaded");
	cs_enable_targeting (true);
	sleep (30 * 10);
	//(cs_vehicle_speed 0.50)
	cs_fly_by (ps_e5_m4_phantom_5.p2);
	cs_fly_to (ps_e5_m4_phantom_5.p3);
//	(cs_fly_by ps_ff_phantom_01/erase 10)
// erase squad 
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	sleep (30 * 3);
	ai_erase (ai_current_squad);
end


// ==============================================================================================================
// ====== TEST ===============================================================================
// ==============================================================================================================

// ==============================================================================================================
//====== INTRO ===============================================================================
// =====================

script static void f_start_player_intro_e5_m4
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
		//intro_vignette_e5_m4();
		//b_wait_for_narrative = false;
		
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30);
		intro_vignette_e5_m4();
	end
	//intro();
	firefight_mode_set_player_spawn_suppressed(false);
	//sleep_until (goal_finished == true);
	
	//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	
	sleep (15);
	fade_in (0,0,0,15);

	ai_exit_limbo (gr_e5_m4_ff_all);
	print ("all ai exiting limbo after the puppeteer");
	
end

script static void intro_vignette_e5_m4
	print ("_____________starting vignette__________________");
	thread(f_music_e5m4_intro_vignette_start()); 
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m4_vin_sfx_intro', NONE, 1);
	cinematic_start();
	
	ai_enter_limbo (gr_e5_m4_ff_all);
	print ("all ai placed in limbo for the puppeteer");
	
	//play pup show
	pup_play_show (e5_m4_intro);
	
	vo_e5m4_intro();
	//temp
	//b_wait_for_narrative = false;
	
	sleep_until (b_wait_for_narrative == false, 1);
	thread(f_music_e5m4_intro_vignette_end()); 
	print ("_____________done with vignette---SPAWNING__________________");

	cinematic_stop();
	
end

script static void f_narrative_done_e5_m4
	print ("narrative done");
	b_wait_for_narrative = false;
	print ("huh");
end

script static void f_e5_m4_zone_set_switch
	print ("changing zone set");
	if game_coop_player_count() <= 2 then
		switch_zone_set (e5_m4);
		print ("2 or less players zone set is e5_m4");
	else
		switch_zone_set (e5_m4_3pl);
		print ("3 or more players zone set is e5_m4_3pl");
	end
end

// ================================================================================================================
//========== ACHIEVEMENT SCRIPTS ====================================
// ================================================================================================================

script static void f_e5_m4_achievement_watch
	print ("achievement earned");
	f_achievement_spops_4();

end

//========== TEST SCRIPTS ====================================

script static void f_pause_text
	print ("pause text test");
	objectives_clear();
	objectives_show_string (ch_e1_m5_1);
	objectives_secondary_show_string (ch_e1_m5_2);


end

script static void f_num_enemies_test
	print ("num enemies test");
	
	local short livCount = 0;
	
	repeat
		sleep_until (ai_living_count (ai_ff_all) > 18, 1);
		print ("*************************AI TOO HIGH************************");
		livCount = ai_living_count (ai_ff_all);
		sleep_until (ai_living_count (ai_ff_all) <= 18, 1);
	
	until (b_game_won, 1);
	
end

script static void f_e5_m4_blip_all_enemies
	//blipping enemies with this function, not the automatic one
	
	print ("***e5_m4 blipping all enemies***");
	b_dont_blip_enemies = true;
	
	local short aiCount = 0;
	
	sleep_until (ai_living_count (ai_ff_all) > 0, 1);
	
	repeat
		
	//	aiCount = ai_living_count (ai_ff_all);

//		//sleep_until ( ai_living_count (ai_ff_all) > aiCount, 1);
//		print ("more enemies spawned, blipping enemies");
//			//f_blip_ai_cui (ai_ff_all, "navpoint_enemy");
//			//sleep (2);
//			
//		thread (f_e5_m4_blip_ai_cui (ai_ff_all, "navpoint_enemy"));
//			
//		//end
//		aiCount = ai_living_count (ai_ff_all);
	
		if ai_living_count (ai_ff_all) <= aiCount then
			aiCount = ai_living_count (ai_ff_all);
		else
			thread (f_e5_m4_blip_ai_cui (ai_ff_all, "navpoint_enemy"));
			aiCount = ai_living_count (ai_ff_all);
		end
		
		//sleep_until (ai_living_count (ai_ff_all) > aiCount, 1);
	until (b_goal_ended == true, 1);

end

script static void f_e5_m4_blip_ai_cui (ai group, string_id blip_type)
	//sleep_until( (b_blip_list_locked == false), 1);
	print ("blipping ai");
	//b_blip_list_locked = true;
	//s_blip_list_index = 0;
	//l_blip_list = ai_actors (group);
	
	local short s_listIndex = 0;
	local object_list l_blipList = ai_actors (group);
	
	repeat
		print ("repeating BLIPPING finding the health of the actors");
			if ( object_get_health (list_get (l_blipList, s_listIndex) )> 0) then
				//f_blip_object_cui (list_get (l_blip_list, s_blip_list_index), blip_type);
				navpoint_track_object_named (list_get (l_blipList, s_listIndex), blip_type);
			end	
			
			s_listIndex = (s_listIndex + 1);
		until ( s_listIndex >= list_count (l_blipList), 1);
	print ("done blipping ai");
	//b_blip_list_locked = false;
end

script static void f_e5_m4_veh_respawn (object_name veh)
	print ("veh respawn");
	
	object_create (veh);
	//print ("players aren't looking repsawning veh");
	//ai_object_set_team (veh, player);
	//object_set_allegiance (veh, player);
	
	repeat
		sleep_until (object_get_health (veh) <= 0, 1);
		print ("veh dead, respawning when players aren't looking");
		
		sleep_until (not volume_test_players_lookat (tv_veh_respawn, 20, 20) and not volume_test_players_lookat (tv_veh_respawn2, 10, 10), 1);
		object_create_anew (veh);
		print ("players aren't looking repsawning veh");
		ai_object_set_team (veh, player);
		object_set_allegiance (veh, player);
	until (b_game_ended, 1);
	
end

//ch_e1_m5_1 = "CLEAR THE AREA"

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


