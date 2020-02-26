//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			Forts 2
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short aa_fire2 = 5;
global short advance_obj = 0;
global boolean b_forts2_symbols_created = FALSE;
global boolean b_forts2_all_cores_destroyed = FALSE;
global boolean b_forts2_west_generator_dead = FALSE;
global boolean b_forts2_east_generator_dead = FALSE;
global boolean b_forts2_north_generator_dead = FALSE;
global short forts_2_generator_count = 0;
global short forts_2_sequencer = 0;
global boolean b_forts2_has_ended = FALSE;
global boolean b_elevator2_button_hit = FALSE;


// =================================================================================================
// =================================================================================================
// *** FORTS 2 ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_forts_2()	
	sleep_until (volume_test_players (tv_insertion_wake_forts2), 1);
	
	pup_play_show(pyelectric2_02);
	thread(set_cryptum_shield_stage(3, 2, FALSE));
	dprint  ("::: forts2 start :::");
	object_destroy (cruiser_1);
	//object_destroy (pylon_electricity_near_2_1);
	
	thread (forts2_core_creation());
	
	wake (f_elevator_2_mover);

	wake (f_forts2_north_prox_blip);
	wake (f_forts2_east_prox_blip);
	wake (f_forts2_west_prox_blip);
	wake (forts2_initial_spawn);
	wake (f_pylon2_setup);
	
	wake (M30_pylontwo_bridgetoelevator); //narrative scripts
	wake (M30_pylontwo_reveal); //narrative scripts
	wake (m30_pylontwo_top_enter); //narrative scripts
	wake (f_forts2_repeating_gc);
	wake (forts2_core_obj_go);
	data_mine_set_mission_segment ("m30_forts_2");
	
	effects_distortion_enabled = FALSE;
	
	thread (f_mus_m30_e07_start());
//	thread (forts2_looping_save_check());
	wake (forts2_streaming_warp);

end

script dormant forts2_core_obj_go()
	sleep_until (volume_test_players (tv_core_destruction), 1);
	
	wake (m30_objective_5);
	
end

script dormant forts2_streaming_warp
	sleep_until (volume_test_players (tv_forts2_stream), 1);
	
	door_hallway_3_out->close_fast();
	
	sleep_until (device_get_position (door_hallway_3_out) <= 0, 1);
	
	volume_teleport_players_inside_with_vehicles (tv_forts2_hallway_warp, flag_forts2_teleport);
	
	sleep (30);
	
	zone_set_trigger_volume_enable ("zone_set:2_elevator:*", TRUE);
	
end

script static void forts2_core_creation()
	sleep_until (volume_test_players (tv_core_destruction), 1);

	object_create (forts2_core1);
	dprint ("forts2_core1 created");

	sleep (2);
	object_create (forts2_core2);
	dprint ("forts2_core2 created");
	
	sleep (2);
	object_create (forts2_core3);
	dprint ("forts2_core3 created");
	
	sleep (5);
	
	thread (f_forts2_generator_startup());
	
	sleep (30);
	
	thread (f_forts2_north_generator_shutdown());
	thread (f_forts2_west_generator_shutdown());
	thread (f_forts2_east_generator_shutdown());
	
	wake (forts_2_ambient_fires);
	
end

// ====================================================================
// GARBAGE COLLECTION =================================================
// ====================================================================

script dormant f_forts2_repeating_gc()
	sleep_until (volume_test_players (tv_forts2_garbage), 1);
		
		repeat
		
			sleep( 30 * 30 );
			dprint( "Garbage collecting..." );
			add_recycling_volume_by_type (tv_forts2_garbage, 1, 10, 1 + 2 + 1024);
		
		until (not volume_test_players (tv_forts2_garbage), 1);	

end

// ====================================================================
// SAVES ==============================================================
// ====================================================================

script static void forts2_looping_save_check()
	repeat
		dprint ("trying to save the game");
		game_save();
		sleep (30 * 60);
	until (volume_test_players (tv_pylon_2_elevator_start), 1) or (b_forts2_has_ended == TRUE);
end

script dormant forts2_save()
	sleep_until (volume_test_players (tv_forts2_save), 1);
	thread (f_mus_m30_e06_start());
	game_save_no_timeout();
end

// ====================================================================
// FIRE FX ============================================================
// ====================================================================

script dormant forts_2_ambient_fires

	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_drop_pods.p2);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_drop_pods.p3);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_drop_pods.p4);
	effect_new_at_ai_point (environments\solo\m30_cryptum\fx\fire\covenant_fire_cheap_med.effect, ps_crashed_drop_pods.p5);
	
end

// =================================================================================================
// *** GENERATOR SETUP ***
// =================================================================================================

script static void f_forts2_generator_startup()

	sleep (10);
	object_create (forts2_shield1);
	SetObjectRealVariable(shield_01, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort2_lights_north);
	SetObjectRealVariable(fort2_lights_north, VAR_SYMBOL_COLOR, 1.0);

	sleep (10); 
	object_create (forts2_shield2);
	SetObjectRealVariable(shield_02, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort2_lights_west);
	SetObjectRealVariable(fort2_lights_west, VAR_SYMBOL_COLOR, 1.0);

	sleep (10); 
	object_create (forts2_shield3);
	SetObjectRealVariable(shield_03, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort2_lights_east);
	SetObjectRealVariable(fort2_lights_east, VAR_SYMBOL_COLOR, 1.0);
	
	sleep (30 * 1);

	b_symbols_created = TRUE;
	
	forts_2_sequencer = 1;
	
end

script static void forts2_orderly_shield_deactivation()
	//Always deactivates bridge shields from front to back, now matter the generator order. 
	
	if (forts_2_generator_count == 1) then 
		object_destroy (forts2_shield1);
		music_forts2_destroy1();
		wake (M30_pylontwo_core_one);
	end

	if (forts_2_generator_count == 2) then 
		object_destroy (forts2_shield1);
		object_destroy (forts2_shield2);
		music_forts2_destroy2();
		wake (M30_pylontwo_core_two);
	end

	if (forts_2_generator_count == 3) then 
		object_destroy (forts2_shield1);
		object_destroy (forts2_shield2);
		object_destroy (forts2_shield3);
		music_forts2_destroy3();
		
		thread (destroy_all_banshees (player0));
		thread (destroy_all_banshees (player1));
		thread (destroy_all_banshees (player2));
		thread (destroy_all_banshees (player3));
		
		forts_2_generator_count = 4; 
		wake (M30_pylontwo_core_three);
	end

end


// =================================================================================================
// *** NORTH GENERATOR - #1 ***
// =================================================================================================

script static void f_forts2_north_generator_shutdown()

	//Waits until core is destroyed...
	sleep_until (object_get_health (forts2_core1) <= 0, 1); 
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts2_tempfx.p0);
	sound_impulse_start ('sound\weapons\plasma_grenade\plasma_expl.sound', NONE, 1);
	object_destroy (forts2_core1);
	f_unblip_object (forts2_core1);
	//object_destroy (forts2_symbol1);
	
	object_destroy (fort2_lights_north);

	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(north_machine_1);
	thread (forts2_north_machine_retract());

	dprint ("Forts2 - North Fort Deactivated");
	
	//Bumps up the Generator Count, so we can track how many generators are down. Important because player can do in any order.  
	forts_2_generator_count = (forts_2_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_2_generator_count);
	
	//Tells the level this particular generator is dead. 
	b_forts2_north_generator_dead = TRUE;

	thread (forts2_orderly_shield_deactivation());
end

script static void forts2_north_machine_retract()
	north_machine_2->f_animate();
end

script dormant f_forts2_north_prox_blip
	// Checks to see if player is close to Fort, using a trigger volume, then activates a blip to remind the player what to do. 
	sleep_until (volume_test_players (tv_forts2_north_prox), 1) and (object_get_health (forts2_core1) != 0);
	f_blip_object (forts2_core1, "destroy");
end

// =================================================================================================
// *** WEST GENERATOR - #2 ***
// =================================================================================================

script static void f_forts2_west_generator_shutdown()

	//Waits until core is destroyed...
	sleep_until (object_get_health (forts2_core2) <= 0, 1); 
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts2_tempfx.p1);
	sound_impulse_start ('sound\weapons\plasma_grenade\plasma_expl.sound', NONE, 1);

	f_unblip_object (forts2_core2);
	//object_destroy (forts2_symbol2);
	//object_destroy (forts2_shield2);
	object_destroy (fort2_lights_west);
	//game_save_no_timeout();
	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(west_machine_1);
	thread (forts2_west_machine_retract());

	dprint ("Forts2 - West Fort Deactivated");
	
	//Bumps up the Generator Count, so we can track how many generators are down. Important because player can do in any order.  
	forts_2_generator_count = (forts_2_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_2_generator_count);
	
	//Tells the level this particular generator is dead. 
	b_forts2_west_generator_dead = TRUE;

	thread (forts2_orderly_shield_deactivation());
end

script static void forts2_west_machine_retract()
	west_machine_2->f_animate();
end

script dormant f_forts2_west_prox_blip
	// Checks to see if player is close to Fort, using a trigger volume, then activates a blip to remind the player what to do. 
	sleep_until (volume_test_players (tv_forts2_west_prox), 1) and (object_get_health (forts2_core2) != 0);
	f_blip_object (forts2_core2, "destroy");
end

// =================================================================================================
// *** EAST GENERATOR - #3 ***
// =================================================================================================

script static void f_forts2_east_generator_shutdown()

	//Waits until core is destroyed...
	sleep_until (object_get_health (forts2_core3) <= 0, 1); 
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts2_tempfx.p2);
	sound_impulse_start ('sound\weapons\plasma_grenade\plasma_expl.sound', NONE, 1);

	f_unblip_object (forts2_core3);
	//object_destroy (forts2_symbol3);
	//object_destroy (forts2_shield3);
	object_destroy (fort2_lights_east);
	//game_save_no_timeout();
	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(east_machine_1);	
	sleep (5);
	thread (forts2_east_machine_retract());

	dprint ("Forts2 - East Fort Deactivated");
	
	//Bumps up the Generator Count, so we can track how many generators are down.  
	forts_2_generator_count = (forts_2_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_2_generator_count);
	
	//Tells the level this particular generator is dead. 
	b_forts2_east_generator_dead = TRUE;

	thread (forts2_orderly_shield_deactivation());
end

script static void forts2_east_machine_retract()
	dprint ("east machine retracting");
	east_machine_2->f_animate();
end

script dormant f_forts2_east_prox_blip
	// Checks to see if player is close to Fort, using a trigger volume, then activates a blip to remind the player what to do. 
	sleep_until (volume_test_players (tv_forts2_east_prox), 1) and (object_get_health (forts2_core3) != 0);
	f_blip_object (forts2_core3, "destroy");
end

//==================================================================================================
// COMBAT SCRIPTING ================================================================================
//==================================================================================================

script dormant forts2_initial_spawn()

	sleep_until (volume_test_players (tv_forts_2_start), 1);

	object_hide (drop_pod_prop_2, FALSE);
	object_wake_physics (drop_pod_prop_2);
	//unit_open (drop_pod_prop_2);
	object_hide (drop_pod_prop_3, FALSE);
	object_wake_physics (drop_pod_prop_3);
	//unit_open (drop_pod_prop_3);
	object_hide (drop_pod_prop_4, FALSE);
	object_wake_physics (drop_pod_prop_4);
	//unit_open (drop_pod_prop_4);
	object_hide (drop_pod_prop_5, FALSE);
	object_wake_physics (drop_pod_prop_5);
	//unit_open (drop_pod_prop_5);
	object_hide (drop_pod_prop_6, FALSE);
	object_wake_physics (drop_pod_prop_6);
	//unit_open (drop_pod_prop_6);

	unit_open (forts2_elite_banshee);
	unit_open (forts2_banshee_2);

	object_wake_physics (forts2_grunt_1);
	object_wake_physics (forts2_grunt_2);
	object_wake_physics (forts2_grunt_3);

	sleep (10);
	
	ai_place (sq_forts2_elite_banshee);
	
	ai_place (sq_forts2_banshees_1);
	ai_place (sq_forts2_banshees_2);
	//wake (m30_pylontwo_banshees); 
	
	ai_place (sq_forts2_ghost_1);
	ai_place (sq_forts2_ghost_2);
	
	ai_place (sq_forts2_mainfort_elite1);
	ai_place (sq_forts2_mainfort_elite2);
	
	thread (forts2_east_fort_spawn());
	thread (forts2_west_fort_spawn());
	thread (forts2_north_fort_spawn());
	thread (forts2_loose_grunts_spawn());
	thread (forts2_device_machine_attaching());
	
end

script static void forts2_device_machine_attaching()
	objects_attach (east_machine_2, locator, east_machine_1, locator);
	objects_attach (west_machine_2, locator, west_machine_1, locator);
	objects_attach (north_machine_2, locator, north_machine_1, locator);
end

script static void forts2_east_fort_spawn()
	ai_place (sq_forts2_east_elites);
	//ai_place (sq_forts2_east_jackals);
	ai_place (sq_forts2_east_grunts);
	dprint ("east fort covenant are spawned");
end

script static void forts2_west_fort_spawn()
	ai_place (sq_forts2_west_elites);
	//ai_place (sq_forts2_west_jackals);
	ai_place (sq_forts2_west_grunts);
	dprint ("west fort covenant are spawned");
end

script static void forts2_north_fort_spawn()
	ai_place (sq_forts2_north_elites);
	//ai_place (sq_forts2_north_jackals);
	ai_place (sq_forts2_north_grunts);
	dprint ("north fort covenant are spawned");
end

script static void forts2_loose_grunts_spawn()
	ai_place (sq_forts2_loose_grunts_1);
	ai_place (sq_forts2_loose_grunts_2);
	dprint ("loose grunts are spawned");
end



script command_script forts2_elite_banshee_entrance
	sleep_until (device_get_position (door_hallway_3_out) >= 0.3);
	dprint ("RUN FOR THE BANSHEE, ELITE!");
	cs_look (TRUE, ps_command_scripts.p1);
	cs_shoot (TRUE);
	//cs_look (FALSE, ps_command_scripts.p1);
	//cs_go_to (ps_command_scripts.p2);
	cs_go_to_vehicle (forts2_elite_banshee);
	//ai_vehicle_enter (sq_forts2_elite_banshee, forts2_elite_banshee);
end

//==================================================================================================
// ELEVATOR CONTROL ================================================================================
//==================================================================================================

script dormant f_elevator_2_mover
// Moves the elevator from the end of Forts 2 up into the Pylon 2 Rooftop. 

	sleep_until (volume_test_players (tv_pylon_2_elevator_start), 1);
	
	
	b_forts2_has_ended = TRUE;
	//wake (M30_pylontwo_elevator_ride);
	f_blip_flag (forts2_elevator_flag, "activate");
	device_group_set_immediate (dg_elevator_button_forts2, 1);
	sleep_until (device_get_position(elevator_button02) != 0);
	device_group_set_immediate (dg_elevator_button_forts2, 0);
	f_unblip_flag (forts2_elevator_flag);
	pup_play_show ("pylon2_elevator");
	
	sleep (30);
	
	object_create (elevator_door_2);
	volume_teleport_players_not_inside (tv_pylon_2_elevator_start, elevator02_teleport);
	
	sleep (90);
	
	//game_save_no_timeout();
	pup_play_show(pyelectric2_03);
	thread(set_cryptum_shield_stage(3, 2, FALSE));
	pylon2_elevator->f_animate();
	
end


script dormant f_pylon2_setup
	sleep_until (volume_test_players (tv_pylon2_entrance) or volume_test_players (tv_pylon_2_setup), 1);
	
	thread (beam_2_rumblor());
	
	pup_play_show ("pylon2_mechanism");
	
	thread (f_mus_m30_e07_finish());
	
	thread (pylon2_beam_disintigration (player0));
	thread (pylon2_beam_disintigration (player1));
	thread (pylon2_beam_disintigration (player2));
	thread (pylon2_beam_disintigration (player3));
	
end

	global real r_rumble_pylon2 = 0;
	global boolean b_pylon2_rumble_done = FALSE;

script static void beam_2_rumblor()

	thread(beam_2_rumble_set(player0));
	thread(beam_2_rumble_set(player1));
	thread(beam_2_rumble_set(player2));
	thread(beam_2_rumble_set(player3));

end

script static void beam_2_rumble_1()
	player_effect_set_max_rumble_for_player(player0, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player1, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player2, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player3, 0.4, 0.4);
end

script static void beam_2_rumble_2()
	player_effect_set_max_rumble_for_player(player0, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player1, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player2, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player3, 0.5, 0.5);
end

script static void beam_2_rumble_3()
	player_effect_set_max_rumble_for_player(player0, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player1, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player2, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player3, 0.6, 0.6);
end

script static void beam_2_rumble_4()
	player_effect_set_max_rumble_for_player(player0, 1, 1);
	player_effect_set_max_rumble_for_player(player1, 1, 1);
	player_effect_set_max_rumble_for_player(player2, 1, 1);
	player_effect_set_max_rumble_for_player(player3, 1, 1);
end

script static void beam_2_rumble_stop()
	player_effect_set_max_rumble_for_player(player0, 0, 0);
	player_effect_set_max_rumble_for_player(player1, 0, 0);
	player_effect_set_max_rumble_for_player(player2, 0, 0);
	player_effect_set_max_rumble_for_player(player3, 0, 0);
end

script static void beam_2_rumble_set(player p_player)
	
	sleep_until (volume_test_players (tv_pylon2_elevator_rumble), 1);
	
	repeat
	inspect (r_rumble_pylon2);
	
		if objects_distance_to_flag (p_player, flag_beam_2) >= 0.1 and objects_distance_to_flag (p_player, flag_beam_2) < 8.0 then
			
			player_effect_set_max_rumble_for_player(p_player, 0.3, 0.3);
			
		elseif objects_distance_to_flag (p_player, flag_beam_2) >= 8.0 and objects_distance_to_flag (p_player, flag_beam_2) < 15.0 then
			
			player_effect_set_max_rumble_for_player(p_player, 0.2, 0.2);
			
		elseif objects_distance_to_flag (p_player, flag_beam_2) >= 15.0 and objects_distance_to_flag (p_player, flag_beam_2) < 40.0 then
			
			player_effect_set_max_rumble_for_player(p_player, 0.1, 0.1);
			
		elseif objects_distance_to_flag (p_player, flag_beam_2) > 40.0 then
			
			player_effect_set_max_rumble_for_player(p_player, 0, 0);
			
		end
		
	until (b_pylon2_rumble_done == TRUE, 1);

	dprint ("rumblin' done");

end

script dormant elevator02_button_dissolve()
	dprint ("elevator button dissolving");
	object_dissolve_from_marker(elevator_button02, "phase_out", "button_marker");
end

script static void pylon2_fx_shutoff()
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts2_tempfx.p3);
	effect_new_on_object_marker (environments\solo\m30_cryptum\fx\electricity\pylon_burst_shutoff.effect, pylon1_beam_core, "fx_26_pylon_off_burst");
end

script dormant pylon2_reclaimer_appear()

	sleep (30);
	dprint ("reclaimer symbol appearing");
	//object_dissolve_from_marker(forts2_reclaimer, "phase_from_ground", "reclaimer_pivot");
	
end

global boolean b_beam_2_active = TRUE;

script static void pylon2_beam_disintigration (player p_player)
	
	repeat
	
	sleep_until (volume_test_object (tv_pylon2beam, p_player), 1);
	
	if (b_beam_2_active == TRUE) then
	
		repeat
	
			damage_object_effect (objects\weapons\rifle\storm_spread_gun\projectiles\damage_effects\storm_spread_gun_shard_super_detonation.damage_effect, p_player);
			add_recycling_volume (tv_pylon2beam, 0, 1);
			damage_object_effect (objects\weapons\rifle\storm_spread_gun\projectiles\damage_effects\storm_spread_gun_shard_super_detonation.damage_effect, p_player);
		
		until (object_get_health (p_player) <= 0 or b_beam_2_active == FALSE, 1);
		
	end
	
	until (b_beam_2_active == FALSE);
	
end

//BLOW UP ANY BANSHEES IN HALLWAY
script static void destroy_all_banshees(player p_player)
	
	repeat
	
	sleep_until (volume_test_object (tv_banshee_destroy, p_player), 1); 
	
	dprint ("player in volume");
	
	if
		unit_in_vehicle_type (p_player, 30)
	then
		unit_exit_vehicle (p_player);
	end
	
	dprint ("ejecting player");
		
	sleep_until (not (unit_in_vehicle_type (p_player, 30)), 1);

	dprint ("player ejected, destroying");

	sleep (30);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 0), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 0), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 0), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 0), "wing_left", 10000);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 1), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 1), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 1), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 1), "wing_left", 10000);

	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 2), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 2), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 2), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 2), "wing_left", 10000);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 3), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 3), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 3), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 3), "wing_left", 10000);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 4), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 4), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 4), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 4), "wing_left", 10000);
	
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 5), "hull", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 5), "canopy", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 5), "wing_right", 10000);
	object_damage_damage_section (list_get(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30), 5), "wing_left", 10000);
	
	print ("Banshee destroyed, cleaning up");
	
	add_recycling_volume (tv_banshee_destroy, 0, 1);

	until (1 == 0);
	//until (list_count(volume_return_objects_by_campaign_type (tv_banshee_destroy, 30)) == 0, 1);

	//print ("ALL BANSHEES DESTROYED, CLEANING UP");
	
	//add_recycling_volume (tv_banshee_destroy, 0, 5);
	
end