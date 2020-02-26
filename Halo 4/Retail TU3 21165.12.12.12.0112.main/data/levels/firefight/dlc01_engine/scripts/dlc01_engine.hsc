////=============================================================================================================================
//============================================ ENGINE FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
//global cutscene_title title_switch_obj_1 = switch_obj_1;
//global cutscene_title title_swarm_1 = swarm_1;
//global cutscene_title title_lz_end = lz_end;
//global cutscene_title title_lz_go_to = lz_go_to;
//global cutscene_title	title_more_enemies = more_enemies;
//global cutscene_title	title_not_many_left = not_many_left;
//global cutscene_title title_defend_base_safe = defend_base_safe;
//global cutscene_title title_power_cut = power_cut;
//global cutscene_title title_objective_3 = objective_3;
//global cutscene_title title_shut_down_comm = shut_down_comm;
//global cutscene_title title_shut_down_comm_2 = shut_down_comm_2;
//global cutscene_title title_first_tower_down = first_tower_down;
//global cutscene_title title_both_tower_down = both_tower_down;
//global cutscene_title title_drop_shields = drop_shields;
//global cutscene_title title_shields_down = shields_down;
//global cutscene_title title_clear_base = clear_base;
//global cutscene_title title_clear_base_2 = clear_base_2;
//global cutscene_title title_get_artifact = get_artifact;
//global cutscene_title title_got_artifact = got_artifact;
//global cutscene_title title_secure = secure;
//global cutscene_title title_get_shard_1 = get_shard_1;
//global cutscene_title title_get_shard_2 = get_shard_2;
//global cutscene_title title_get_shard_3 = get_shard_3;
//global cutscene_title title_got_shard = got_shard;
//global cutscene_title title_destroy_1 = destroy_1;
//global cutscene_title title_destroy_2 = destroy_2;
//global cutscene_title title_destroy_obj_1 = destroy_obj_1;
//global cutscene_title title_destroy_obj_complete_1 = destroy_obj_complete_1;

//================================================== MAIN SCRIPT STARTS ==================================================================

script startup engine_room
  
	thread(f_init_navmesh_prop());
	// setup defaults
	f_spops_mission_startup_defaults();
                
  // track mission flow
	f_spops_mission_flow();
	thread(disable_kill_volumes());
	/*ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	wake (start_waves);*/

end
/*
script dormant start_waves
	wake (firefight_lost_game);
	wake (firefight_won_game);
	firefight_player_goals();
	print ("goals ended");
	print ("game won");
	//mp_round_end();
	b_game_won = true;
end

script static void setup_destroy
	//set any variables and start the main objective script from the global firefight script
	wake (objective_destroy);
end

script static void setup_defend
	//set any variables and start the main objective script from the global firefight script
	wake (objective_defend);
end

script static void setup_swarm
	//set any variables and start the main objective script from the global firefight script
	wake (objective_swarm);
end

script static void setup_capture
	//set any variables and start the main objective script from the global firefight script
	wake (objective_capture);
end

script static void setup_take
	//set any variables and start the main objective script from the global firefight script
	wake (objective_take);
end

script static void setup_atob
	wake (objective_atob);
end

script static void setup_boss
	wake (objective_kill_boss);
end

script static void setup_wait_for_trigger
	wake(objective_wait_for_trigger);
end
*/
script static void disable_kill_volumes
	// Globally disabling kill volumes 
	kill_volume_disable(kill_tv_e7_m4_engine1);								
	kill_volume_disable(kill_tv_e7_m4_engine2);							
	kill_volume_disable(kill_tv_e7_m4_engine3);	
	kill_volume_disable(kill_tv_e7_m4_engine4);	
	kill_volume_disable(kill_tv_e7_m4_engine5);	
	kill_volume_disable(kill_tv_e7_m4_engine6);	
	kill_volume_disable(playerkill_tv_e7_m4_server2_soft);
	kill_volume_disable(playerkill_tv_e7_m4_server1);
	
end 
script static void f_init_navmesh_prop
	sleep_until(object_valid(hangar_cover1), 1);
	object_destroy(hangar_cover1);
	sleep_until(object_valid(hangar_cover2), 1);
	object_destroy(hangar_cover2);
	sleep_until(object_valid(hangar_cover3), 1);
	object_destroy(hangar_cover3);
	
	sleep_until(object_valid(block_nav1), 1);
	object_hide(block_nav1, TRUE);
	sleep_until(object_valid(block_nav2), 1);
	object_hide(block_nav2, TRUE);
end 
global boolean b_engine_camera_shake = FALSE;
script static void f_camera_shake_random_timer(boolean b_arg_shake)
	// start timer
	if( b_arg_shake) then
		b_engine_camera_shake = TRUE;
		repeat
			local real r_random_delay = random_range (180, 300);
			sleep_s (r_random_delay);
			print("debug dlc01_engine random amb_shake:");
			print(string(r_random_delay));
			//sleep_s (3);
			//local real r_attack = real_random_range(0.1, 0.5); // arg needs to be 0.1 decimal
			//local real r_intensity = real_random_range(0.1, 0.3);
			//local real r_duration = 3.7 - r_intensity * 10;
			//local real r_decay = real_random_range(0.1, 0.5);
			//thread(camera_shake_all_coop_players( 0.1, r_intensity, r_duration, 0.1));
			local real r_intensity = random_range (0, 2);
			if (r_intensity == 0) then
				f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0.5, -1, -3.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 3, "amb_engine_exp_rumble" );
			elseif (r_intensity == 1) then
				f_screenshake_ambient_add( 0.20, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), -0.475, -1, -4.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 1, "amb_engine_exp_rumble" );
			elseif (r_intensity == 1) then
				f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -0.25, -1, -3.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 2, "amb_engine_exp_rumble" );
			end
		until( b_engine_camera_shake == FALSE , 1 );
	else
		b_engine_camera_shake = FALSE;
	end
end

global boolean b_infinity_radio_broadcast = FALSE;
script static void f_infinity_radio_random_timer(boolean b_arg_broadcast)
	// start timer
	if( b_arg_broadcast) then
		b_infinity_radio_broadcast = TRUE;
		repeat
			local real r_random_delay = random_range (180, 300);
			sleep_s (r_random_delay);
			print("debug dlc01_engine random broadcast:");
			print(string(r_random_delay));
			
			local real r_broadcast_variant = random_range (0, 2);
			if (r_broadcast_variant == 0) then
				f_screenshake_ambient_add( 0.25, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), -0.5, -1, -3.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 3, "amb_engine_exp_rumble" );
			elseif (r_broadcast_variant == 1) then
				f_screenshake_ambient_add( 0.20, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), -0.475, -1, -4.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 1, "amb_engine_exp_rumble" );
			elseif (r_broadcast_variant == 1) then
				f_screenshake_ambient_add( 0.15, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), -0.25, -1, -3.0, 'sound\environments\multiplayer\infinityengine\events\amb_engine_exp_rumble_in', 0.0, 2, "amb_engine_exp_rumble" );
			end
		until( b_infinity_radio_broadcast == FALSE , 1 );
	else
		b_infinity_radio_broadcast = FALSE;
	end
end

script static void f_engine_open_door(device dc_switch, device dm_door, device dm_switch)
	print("dlc_engine.hsc: opening door");
	// wait for pup to play
	device_animate_position (dm_switch, 0, 2.5, 1, 0, 0);
		
	sleep_s(1);
	
	device_set_position_track( dm_door, 'any:idle', 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1);
	
	device_animate_position( dm_door, 1, 3.5, 1.0, 1.0, TRUE );
	
	sleep_until( (device_get_position(dm_door) >= 0.6), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	
	//device_set_power(dc_switch, 0);
end

script static void f_engine_open_monster_door(device dm_door)
	print("dlc_engine.hsc: opening monster door");
	sleep_s(1);	
	device_set_position_track( dm_door, 'any:idle', 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_open', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1);
	
	device_animate_position( dm_door, 1, 3.5, 1.0, 1.0, TRUE );
	
	sleep_until( (device_get_position(dm_door) >= 0.6), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_apex', dm_door, 0.5 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
end


script static void f_engine_close_door(device dc_switch, device dm_door, device dm_switch)
	print("dlc_engine.hsc: closing door");
	//device_set_position_track( dm_switch, 'any:idle', 0 );
		
	device_animate_position (dm_switch, 0, 0.25, 1, 0, 0);
			
	sleep_s(0.25);

	//device_set_position_track( dm_door, 'any:idle', 0 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_set', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1 );
	
	device_animate_position (dm_door, 0, 2, 1, 0, 0);
	
	sleep_until( (device_get_position(dm_door) <= 0.0), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_end_set', dm_door, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	
end
script static void f_engine_close_monster_door(device dm_door)
	print("dlc_engine.hsc: closing monster door");

	sleep_s(0.25);
	//device_set_position_track( dm_door, 'any:idle', 0 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_set', dm_door, 1.0 );
	sound_looping_start( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop', dm_door, 1 );
	
	device_animate_position (dm_door, 0, 2, 1, 0, 0);
	
	sleep_until( (device_get_position(dm_door) <= 0.0), 1 );
	
	sound_impulse_start( 'sound\environments\multiplayer\infinityengine\events\engine_door_metal_close_end_set', dm_door, 1.0 );
	sound_looping_stop( 'sound\environments\multiplayer\infinityengine\engine_door_metal_motor_loop');
	
end

script static void f_waypoint_breadcrumbs (real objectdistance, object flag)
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
script static void f_fx_ai_server_start
	dprint("ai effect starting");
//	effect_new ("levels\firefight\dlc01_engine\fx\airoom_steam_01", "fx_mkr_server_rising_steam");
//	effect_new ("levels\firefight\dlc01_engine\fx\airrom_starmap_new", "fx_mkr_server_starmap");
//	effect_new ("levels\firefight\dlc01_engine\fx\airoom_hologram_tech", "fx_mkr_server_hologram_tech");
//	effect_new ("levels\firefight\dlc01_engine\fx\airoom_hologram_panel", "fx_mkr_server_hologram_panel");
end