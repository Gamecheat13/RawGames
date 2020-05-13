//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			Forts 1
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short forts_south_advance = 0;
global short forts_east_advance = 0;
global short forts_west_advance = 0;
global short forts_1_generator_south_dead = 0;
global short forts_1_generator_east_dead = 0;
global short forts_1_generator_west_dead = 0;
global short forts_1_generator_count = 0;
global short forts_1_sequencer = 0;
global short DEF_CURRENT_POSITION = 0;
global boolean south_fort_bishop_spawned = FALSE;
global boolean east_fort_bishop_spawned = FALSE;
global boolean west_fort_bishop_spawned = FALSE;
global boolean doorway_bishop1_spawned = FALSE;
global boolean doorway_bishop2_spawned = FALSE;
global boolean b_symbols_created = FALSE;
global boolean gooby_pls = TRUE;
global boolean b_all_cores_destroyed = FALSE;
global long VAR_SYMBOL_COLOR = VAR_OBJ_LOCAL_A;
global boolean b_west_generator_dead = FALSE;
global boolean b_east_generator_dead = FALSE;
global boolean b_south_generator_dead = FALSE;
global boolean b_forts1_has_ended = FALSE;
global boolean b_elevator1_button_hit = FALSE;
global boolean VAR_OBJ_TRACKER_1 = FALSE;
global boolean VAR_OBJ_TRACKER_2 = FALSE;
global boolean VAR_OBJ_TRACKER_3 = FALSE;


// =================================================================================================
// =================================================================================================
// *** FORTS 1 ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_forts_1()	

	sleep_until (b_mission_started == TRUE);
	//	Waits until the insertion point trigger has been hit, inside m30_design scenario layer. 
	sleep_until (volume_test_players (tv_insertion_wake_py1_forts), 1); 
	
	// huge encounter, we need effects perf
	effects_perf_armageddon = 1;

	game_save_no_timeout();
	
	dprint ("Stopping puppet pyelectric_03");
	pup_stop_show(id_for_pylon_pups);
	
	dprint ("Starting puppet pyelectric_04");
	id_for_pylon_pups = pup_play_show(pyelectric_04);
	
	//object_destroy (pylon_near_canyons2);
	//object_destroy (pylon_far_canyons2);
	//pup_play_show ("pylon_electricity_forts1");
	
	dprint  ("::: forts1 start :::");

	wake (f_elevator_1_mover);
	wake (f_save_generators_one);
	wake (f_save_generators_three);
	wake (f_save_main_fort_entrance);
	wake (f_forts1_shields_deactivate);
	wake (f_generator_blip_prox_01);
	wake (f_generator_blip_prox_02);
	wake (f_generator_blip_prox_03);
	wake (f_forts1_mainfort_blip);
	wake (f_forts_initial_spawn);
	wake (f_forts_eastfort_spawn);
	wake (f_forts_westfort_spawn);
	wake (f_forts_rearpawns_spawn);
	wake (final_forts1_doorway_fight);
	thread (device_machine_attaching());
	wake (f_forts1_start);
	wake (f_pylon1_setup);
	thread (M30_pylonone_bridgetoelevator()); //Narrative Scripting
	wake (M30_pylonone_top_enter); //Narrative Scripting
	//thread (f_orderly_shield_deactivation());
	
	wake (f_forts1_repeating_gc);
	wake (forts1_objective_go);
	
	//f_color_change_go();
	data_mine_set_mission_segment ("m30_forts_1");
	effects_distortion_enabled = FALSE;

	if game_difficulty_get_real() == "legendary" then		
		thread (recycle_volume_start());
	else	
		sleep (1);
	end
	
end


script dormant forts1_objective_go()
	sleep_until (volume_test_players (tv_player_in_space), 1);
	
	wake (m30_objective_2);
	
	wake (south_fort_defeated_save);
	wake (west_fort_defeated_save);
	wake (east_fort_defeated_save);
	
end


// INITIAL SETUP ===================================================================================

script dormant f_forts1_start()
	
	sleep_until (volume_test_players (tv_save_fort_entry_top), 1);
	
	//game_save();
	
	object_create (generator_01_core);
	//sleep (5);
	object_create (generator_02_core);
	//sleep (5);
	object_create (generator_03_core);
	dprint ("cores created");
	
	sleep (30 * 2);
	//Fort Gates Activation
	thread (f_generator_startup());
	thread (f_generator_switch_01());
	thread (f_generator_switch_02());
	thread (f_generator_switch_03());	
	
	//ai_place (sq_main_turret1);
	//ai_place (sq_main_turret2);
	sleep (30);
	//AutomatedTurretActivate (ai_vehicle_get(sq_main_turret1.sp_main_turret1));
	//AutomatedTurretActivate (ai_vehicle_get(sq_main_turret2.sp_main_turret2));
	//dprint ("turrets spawned");

end

script static void device_machine_attaching()
	objects_attach (south_device_2, locator, south_device_1, locator);
	objects_attach (east_device_2, locator, east_device_1, locator);
	objects_attach (west_device_2, locator, west_device_1, locator);
end

script command_script cs_knight_phase_spawn()
	cs_phase_in();
end

script static void recycle_volume_start()
	repeat
		sleep_until (volume_test_players (tv_recycle_debris), 1);
	
		sleep (30 * 5);
		
		if
			volume_test_players (tv_recycle_debris)
		then
			thread (obj_tracker_0());
			sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
		end

	until (object_valid (debug_button_0) or volume_test_players (tv_pylon_elevator_start), 1);

end

script static void obj_tracker_0()
	object_create (debug_button_0);
	device_group_set_immediate (dg_debug_button0, 1);
	
	sleep_until (device_get_position (debug_button_0) != 0);
	
	sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
	device_group_set_immediate (dg_debug_button0, 0);
	object_create (debug_button_1);
	thread (obj_tracker_1());
	
end

script static void obj_tracker_1()
	device_group_set_immediate (dg_debug_button1, 1);
	
	sleep_until (device_get_position (debug_button_1) != 0);
	
	sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
	device_group_set_immediate (dg_debug_button1, 0);
	object_create (debug_button_2);
	VAR_OBJ_TRACKER_1 = TRUE;
	
	thread (obj_tracker_2());
	
end

script static void obj_tracker_2()
	device_group_set_immediate (dg_debug_button2, 1);
	
	sleep_until (device_get_position (debug_button_2) != 0);
	
	sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
	device_group_set_immediate (dg_debug_button2, 0);
	object_create (debug_button_3);
	VAR_OBJ_TRACKER_2 = TRUE;
	thread (obj_tracker_3());
	
end
	
script static void obj_tracker_3()
	device_group_set_immediate (dg_debug_button3, 1);
	
	sleep_until (device_get_position (debug_button_3) != 0);
	
	sound_impulse_start(sound\game_sfx\ui\button_based_ui_sounds\start_menu_open, NONE, 1 );
	device_group_set_immediate (dg_debug_button3, 0);
	object_create (debug_weapon_1);
	object_create (debug_weapon_2);
	object_create (debug_weapon_3);
	object_create (debug_weapon_4);
	object_create (debug_weapon_5);
	object_create (debug_weapon_6);
	object_create (debug_weapon_7);
	object_create (debug_weapon_8);
	VAR_OBJ_TRACKER_3 = TRUE;
	
end

// ====================================================================
// GARBAGE COLLECTION =================================================
// ====================================================================

script dormant f_forts1_repeating_gc()
	sleep_until (volume_test_players (tv_forts1_garbage), 1);
		
		repeat
		
			sleep( 30 * 30 );
			dprint( "Garbage collecting..." );
			add_recycling_volume_by_type (tv_forts1_garbage, 1, 10, 1 + 2 + 1024);
		
		until (not volume_test_players (tv_forts1_garbage), 1);	

end

// =================================================================================================
// =================================================================================================
// *** FORTS 1 SAVE CONTROL ***
// =================================================================================================
// =================================================================================================

script dormant f_save_generators_one()
	//	saves game after 1st generator destroyed.
	sleep_until ((forts_1_generator_count == 1), 1);
	//game_save();
	dprint ("generator destroyed!");
end

script dormant f_save_generators_three()
	//	saves game after 3rd generator destroyed.
	sleep_until ((forts_1_generator_count == 3), 1);
	//game_save();
	dprint ("generator destroyed!");
end

script dormant f_save_main_fort_entrance()
	//	saves game as player starts running up back ramp entrance of Main Fort. *** May need to redo this, so happens after solving gate puzzle! ***
	sleep_until (volume_test_players (tv_mainfort_entrance), 1);
	//game_save();
	dprint ("generator destroyed!");
end

script static void forts1_looping_save_check()
	repeat
		dprint ("trying to save the game");
		game_save();
		sleep (30 * 10);
	until (b_forts1_has_ended == TRUE);
end

script dormant south_fort_defeated_save()

	sleep_until (south_fort_bishop_spawned) == TRUE;
	
	dprint ("south fort is spawned, waiting until depleted to save");

	sleep_until 
	(
	ai_living_count (sq_south_pawns_1) == 0 and
	ai_living_count (sq_south_pawns_2) == 0 and
	ai_living_count (sq_south_knight_1) == 0 and
	ai_living_count (sq_south_bishop_1) == 0
	);
	
	game_save();
	
end

script dormant west_fort_defeated_save()

	sleep_until (west_fort_bishop_spawned) == TRUE;

	dprint ("west fort is spawned, waiting until depleted to save");

	sleep_until 
	(
	ai_living_count (sq_west_pawns_1) == 0 and
	ai_living_count (sq_west_pawns_2) == 0 and
	ai_living_count (sq_west_knight_1) == 0 and
	ai_living_count (sq_west_bishop_1) == 0
	);
	
	game_save();
	
end

script dormant east_fort_defeated_save()

	sleep_until (east_fort_bishop_spawned) == TRUE;

	dprint ("east fort is spawned, waiting until depleted to save");

	sleep_until 
	(
	ai_living_count (sq_east_pawns_1) == 0 and
	ai_living_count (sq_east_pawns_2) == 0 and
	ai_living_count (sq_east_knight_1) == 0 and
	ai_living_count (sq_east_bishop_1) == 0
	);
	
	game_save();
	
end

script dormant rear_fight_defeated_save()

	dprint ("rear fight is spawned, waiting until depleted to save");

	sleep_until 
	(
	ai_living_count (sq_doorway_knight1) == 0 and
	ai_living_count (sq_doorway_knight2) == 0 and
	ai_living_count (sq_doorway_bishop1) == 0 and
	ai_living_count (sq_doorway_bishop2) == 0
	);
	
	game_save();
	
end

// =================================================================================================
// *** FORTS 1 ELEVATOR CONTROL ***
// =================================================================================================

script dormant f_elevator_1_mover
// Moves the elevator from the end of Forts up into the Pylon Rooftop. 

	sleep_until (volume_test_players (tv_pylon_elevator_start), 1);
	
	// we now resume you to your regularly scheduled effects
	effects_perf_armageddon = 0;

	b_forts1_has_ended = TRUE;
	wake (M30_plyonone_elevator_ride);	
	f_blip_flag (forts1_elevator_flag, "activate");
	device_group_set_immediate (dg_elevator_button_forts1, 1);
	sleep_until (device_get_position(elevator_button01) != 0);
	device_group_set_immediate (dg_elevator_button_forts1, 0);
	f_unblip_flag (forts1_elevator_flag);
	pup_play_show ("pylon1_elevator");

	sleep (30);
	object_create (elevator_door_1);
	volume_teleport_players_not_inside (tv_pylon_elevator_start, elevator01_teleport);
	sleep (90);
	
	//game_save_no_timeout();
	dprint ("Stopping puppet pyelectric_04");
	pup_stop_show(id_for_pylon_pups);
	
	dprint ("Starting puppet pyelectric_05");
	id_for_pylon_pups = pup_play_show(pyelectric_05);
	
	pylon1_elevator->f_animate();
	
end

script dormant f_pylon1_setup
	sleep_until (volume_test_players (tv_pylon1_entrance) or volume_test_players (tv_pylon_1_setup), 1);
	
	thread (beam_1_rumblor());
	
	pup_play_show ("pylon1_mechanism");
	
	thread (pylon1_beam_disintigration (player0));
	thread (pylon1_beam_disintigration (player1));
	thread (pylon1_beam_disintigration (player2));
	thread (pylon1_beam_disintigration (player3));
	
end


	global real r_rumble_pylon = 0;
	global boolean b_pylon_rumble_done = FALSE;

script static void beam_1_rumblor()

	thread(beam_1_rumble_set(player0));
	thread(beam_1_rumble_set(player1));
	thread(beam_1_rumble_set(player2));
	thread(beam_1_rumble_set(player3));
	
end

script static void beam_1_rumble_1()
	player_effect_set_max_rumble_for_player(player0, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player1, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player2, 0.4, 0.4);
	player_effect_set_max_rumble_for_player(player3, 0.4, 0.4);
end

script static void beam_1_rumble_2()
	player_effect_set_max_rumble_for_player(player0, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player1, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player2, 0.5, 0.5);
	player_effect_set_max_rumble_for_player(player3, 0.5, 0.5);
end

script static void beam_1_rumble_3()
	player_effect_set_max_rumble_for_player(player0, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player1, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player2, 0.6, 0.6);
	player_effect_set_max_rumble_for_player(player3, 0.6, 0.6);
end

script static void beam_1_rumble_4()
	player_effect_set_max_rumble_for_player(player0, 1, 1);
	player_effect_set_max_rumble_for_player(player1, 1, 1);
	player_effect_set_max_rumble_for_player(player2, 1, 1);
	player_effect_set_max_rumble_for_player(player3, 1, 1);
end

script static void beam_1_rumble_stop()
	player_effect_set_max_rumble_for_player(player0, 0, 0);
	player_effect_set_max_rumble_for_player(player1, 0, 0);
	player_effect_set_max_rumble_for_player(player2, 0, 0);
	player_effect_set_max_rumble_for_player(player3, 0, 0);
end

script static void beam_1_rumble_set(player p_player)

	sleep_until (volume_test_players (tv_pylon_elevator_rumble), 1);

	repeat
	
	inspect (r_rumble_pylon);
	
		if objects_distance_to_flag (p_player, flag_beam_1) >= 0.1 and objects_distance_to_flag (p_player, flag_beam_1) < 8.0 then
		
			player_effect_set_max_rumble_for_player(p_player, 0.3, 0.3);
			
		elseif objects_distance_to_flag (p_player, flag_beam_1) >= 8.0 and objects_distance_to_flag (p_player, flag_beam_1) < 15.0 then
		
			player_effect_set_max_rumble_for_player(p_player, 0.2, 0.2);
			
		elseif objects_distance_to_flag (p_player, flag_beam_1) >= 15.0 and objects_distance_to_flag (p_player, flag_beam_1) < 40.0 then
		
			player_effect_set_max_rumble_for_player(p_player, 0.1, 0.1);
			
		elseif objects_distance_to_flag (p_player, flag_beam_1) > 40.0 then
		
			player_effect_set_max_rumble_for_player(p_player, 0, 0);
			
		end
		
	until (b_pylon_rumble_done == TRUE, 1);
	
	dprint ("rumblin' stopped");

end

script dormant elevator01_button_dissolve()
	dprint ("elevator button dissolving");
	object_dissolve_from_marker(elevator_button01, "phase_out", "button_marker");
end

script static void pylon1_fx_shutoff()
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts1_tempfx.p21);
	effect_new_on_object_marker (environments\solo\m30_cryptum\fx\electricity\pylon_burst_shutoff.effect, pylon1_beam_core, "fx_18_pylon_off_burst");
end

script dormant pylon1_reclaimer_appear()

	sleep (30);
	dprint ("reclaimer symbol appearing");
	//object_dissolve_from_marker(forts1_reclaimer, "phase_from_ground", "reclaimer_pivot");
	
end

global boolean b_beam_1_active = TRUE;

script static void pylon1_beam_disintigration (player p_player)
	
	repeat
	
	sleep_until (volume_test_object (tv_pylon1beam, p_player), 1);
	
	if (b_beam_1_active == TRUE) then
	
		repeat
	
			damage_object_effect (objects\weapons\rifle\storm_spread_gun\projectiles\damage_effects\storm_spread_gun_shard_super_detonation.damage_effect, p_player);
			add_recycling_volume (tv_pylon1beam, 0, 1);
			damage_object_effect (objects\weapons\rifle\storm_spread_gun\projectiles\damage_effects\storm_spread_gun_shard_super_detonation.damage_effect, p_player);
		
		until (object_get_health (p_player) <= 0 or b_beam_1_active == FALSE, 1);
		
	end
	
	until (b_beam_1_active == FALSE);
	
end

// =================================================================================================
// =================================================================================================
// *** FORTS 1 BLIP CONTROL ***
// =================================================================================================
// =================================================================================================
// Showing the player where to go next. 

// BASIC EVENT CONTROL. Event blips after the Shield Generator Puzzle has been completed.

script dormant f_forts1_mainfort_blip()
	// After the player has unlocked the path by deactivating enough generators, we blip the player to go to the top of the Fort. 
	sleep_until ((forts_1_generator_count == 3), 1);
	f_blip_flag (flag_waypoint_ramp, "default");
	wake (forts1_pylon_blip);
	wake (m30_objective_3); 
end

script dormant forts1_pylon_blip()
	// The bridge/ elevator blip remains on, until the player reaches the bridge.
	sleep_until (volume_test_players (tv_mainfort_entrance), 1);
	f_unblip_flag (flag_waypoint_ramp);
end

// GENERATOR PROXIMITY CONTROL. Having so many blips on screen can be detrimental to exploration. This keeps them off the screen until the player gets close to a generator.

script dormant f_generator_blip_prox_01
	// Checks to see if player is close to Fort, using a trigger volume, then activates a blip to remind the player what to do. 
	sleep_until (volume_test_players (tv_core_prox_01), 1)
	and (object_get_health (generator_01_core) != 0);
	
	f_blip_object (generator_01_core, "destroy");


end

script dormant f_generator_blip_prox_02
	sleep_until (volume_test_players (tv_core_prox_02), 1)
	and (object_get_health (generator_02_core) != 0);
	
	f_blip_object (generator_02_core, "destroy");

end

script dormant f_generator_blip_prox_03
	sleep_until (volume_test_players (tv_core_prox_03), 1)
	and (object_get_health (generator_03_core) != 0);
		
	f_blip_object (generator_03_core, "destroy");

end

// GENERATOR ELIMINATION CONTROL. Having so many blips on screen can be detrimental to exploration. This reminds the player of remaining generator locations, after destroying one.  

// =================================================================================================
// =================================================================================================
// *** FORTS 1 COMBAT CONTROL ***
// =================================================================================================
// =================================================================================================

script dormant f_forts_initial_spawn()
	sleep_until (volume_test_players (tv_save_fort_entry_top), 1);
	
	sleep (5);
	
	//patrolling pawns spawn
	ai_place (sq_loose_pawns_1);
	ai_place (sq_loose_pawns_2);
	ai_place (sq_loose_pawns_4);
	ai_place (sq_south_pawns_1);
	ai_place (sq_west_pawns_1);
	ai_place (sq_east_pawns_1);
	ai_place (sq_south_bishop_1);
	

	
	unit_doesnt_drop_items (ai_actors (sq_south_bishop_1));
	
	dprint ("initial forts spawn triggered");

	sleep (30);

	ai_place (sq_south_knight_1);
	ai_allow_resurrect(sq_south_knight_1, FALSE);
	dprint ("knight should be spawned");
	
	sleep_until (volume_test_players (tv_player_in_space), 1);
	
	thread (f_mus_m30_e04_start());
	
	
	
end

// =================================================================================================
// *** LOOSE PAWNS ***
// =================================================================================================

script static void f_loose_pawn1_spawn()

	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_loose_pawns_fx.p0);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_loose_pawns_fx.p1);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_loose_pawns_fx.p2);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_loose_pawns_fx.p3);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_loose_pawns_fx.p4);

	ai_place (sq_loose_pawns_1);

end

script command_script cs_bishop_spawner_1()
	
	cs_fly_to (ps_bishop_spawner_1.p0);
	cs_pause (1.5);
	thread (f_loose_pawn1_spawn());
	cs_pause (1.0);
	cs_fly_to (ps_bishop_spawner_1.p1);
	cs_fly_to (ps_bishop_spawner_1.p2);
	cs_fly_to (ps_bishop_spawner_1.p3);
	ai_erase (sq_bishop_spawner_1);
		
end 

script dormant f_forts_rearpawns_spawn()
	sleep_until (volume_test_players (tv_east_progress) or (volume_test_players (tv_west_progress)), 1);
	
	print ("spawning loose_pawns_3");
	
	ai_place (sq_loose_pawns_3);
	
end

// =================================================================================================
// *** SOUTH FORT ***
// =================================================================================================

script command_script cs_bishop_spawn_southfort()
	print("south fort bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_southfort, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_southfort()

	sleep (5);
	cs_run_command_script (sq_south_bishop_1, cs_south_bishop_pawn_spawn);
	
end

script command_script cs_south_bishop_pawn_spawn()

	south_fort_bishop_spawned = TRUE;
	cs_pause (0.5);

end

script static void f_south_fort_pawn_spawn()

	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_south_fort_fx.p0);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_south_fort_fx.p1);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_south_fort_fx.p2);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_south_fort_fx.p3);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_south_fort_fx.p4);
	
	ai_place (sq_south_pawns_1);

end

// =================================================================================================
// *** WEST FORT ***
// =================================================================================================

script command_script cs_bishop_spawn_westfort()
	print("west fort bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_westfort, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_westfort()

	sleep (5);
	
	cs_run_command_script (sq_west_bishop_1, cs_west_bishop_pawn_spawn);
	
end

script dormant f_forts_westfort_spawn()
	sleep_until (volume_test_players (tv_west_progress) or (volume_test_players (tv_west_progress2)),1 );
	
	dprint ("west forts spawn triggered");
	
	ai_place (sq_west_knight_1);
	ai_allow_resurrect(sq_west_knight_1, FALSE);
	ai_place (sq_west_bishop_1);
	
	sleep_until (west_fort_bishop_spawned == TRUE);
	
end

script static void f_west_fort_pawn_spawn()

	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p16);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p17);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p18);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p19);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p20);
	
	ai_place (sq_west_pawns_1);

end

script command_script cs_west_bishop_pawn_spawn()

	west_fort_bishop_spawned = TRUE;
	cs_pause (0.5);

end


// =================================================================================================
// *** EAST FORT ***
// =================================================================================================

script command_script cs_bishop_spawn_eastfort()
	print("east fort bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_eastfort, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_eastfort()

	sleep (5);
	cs_run_command_script (sq_east_bishop_1, cs_east_bishop_pawn_spawn);
	
end

script command_script cs_east_bishop_pawn_spawn()

	east_fort_bishop_spawned = TRUE;
	cs_pause (0.5);

end

script dormant f_forts_eastfort_spawn()
	sleep_until (volume_test_players (tv_east_progress) or (volume_test_players (tv_east_progress2)),1 );
	
	dprint ("east forts spawn triggered");
	
	ai_place (sq_east_knight_1);
	ai_allow_resurrect(sq_east_knight_1, FALSE);
	ai_place (sq_east_bishop_1);

	sleep_until (east_fort_bishop_spawned == TRUE);

end

script static void f_east_fort_pawn_spawn()

	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p6);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p7);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p8);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p9);
	effect_new_at_ai_point (objects\characters\storm_pawn\fx\pawn_phase_in.effect, ps_forts1_tempfx.p10);
	
	ai_place (sq_east_pawns_1);

end

// =================================================================================================
// *** DOORWAY FIGHT ***
// =================================================================================================

script dormant final_forts1_doorway_fight()
	sleep_until ((b_all_cores_destroyed == TRUE) and (volume_test_players (tv_doorway_fight_turf)), 1);
	
	dprint ("spawning doorway encounter");
	
	sleep (30);
	
	ai_place (sq_doorway_bishop1);
	ai_place (sq_doorway_bishop2);
	ai_place (sq_doorway_knight1);
	ai_place (sq_doorway_knight2);
	ai_place (marty_the_battlewagon);
	
	wake (rear_fight_defeated_save);
	
	sleep (5);

	sleep_until (ai_living_count (marty_the_battlewagon) == 0 and volume_test_players (m30_fort1_infinity), 1);
	
	thread(m30_forts1_ifinity()); 
	
end

script command_script cs_bishop_spawn_doorway1()
	print("doorway bishop 1 sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_doorway1, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_doorway1()

	sleep (5);
	doorway_bishop1_spawned = TRUE;
	
end

script command_script cs_bishop_spawn_doorway2()
	print("doorway bishop 2 sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_doorway2, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_doorway2()

	sleep (5);
	doorway_bishop2_spawned = TRUE;
	
end

script command_script cs_doorway_bishop1_pawn_spawn()

	cs_fly_to (ps_bishop_spawner_1.p7);
	doorway_bishop1_spawned = TRUE;
	cs_pause (0.5);

end

script command_script cs_doorway_bishop2_pawn_spawn()

	cs_fly_to (ps_bishop_spawner_1.p8);
	doorway_bishop2_spawned = TRUE;
	cs_pause (0.5);

end

// *** Knight Spawns Bishop *** ====================================================================
// Place as Placement Script into each appropriate Bishop Spawn Point. 

script command_script cs_bishop_south_spawn
	print("bishop sleeping");
	ai_enter_limbo(sq_south_bishop_1);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(sq_south_bishop_1), OnCompleteProtoSpawn, 0);
end

script command_script cs_bishop_west_spawn
	print("bishop sleeping");
	ai_enter_limbo(sq_west_bishop_1);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(sq_west_bishop_1), OnCompleteProtoSpawn, 0);
end

script command_script cs_bishop_east_spawn
	print("bishop sleeping");
	ai_enter_limbo(sq_east_bishop_1);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(sq_east_bishop_1), OnCompleteProtoSpawn, 0);
end

// =================================================================================================
// =================================================================================================
// *** FORTS 1 CORES GATING PUZZLE ***
// =================================================================================================
// =================================================================================================

// This is Forts_1's gating puzzle. Deactivate 3 generators, which deactivates 3 shields, which lets the player enter the Pylon.  

// *** Setup *** ===================================================================================

script static void f_generator_startup()
	//Turns on shields as player enters space, and syncs up with Cortana dialogue explaining what's going on. A visual aid to draw attention to the shield gating. 

	sleep (10);
	object_create (shield_01);
	SetObjectRealVariable(shield_01, VAR_SYMBOL_COLOR, 1.0);
	//object_create (forts1_symbol_1);
	//SetObjectRealVariable(forts1_symbol_1, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort_lights_south);
	SetObjectRealVariable(fort_lights_south, VAR_SYMBOL_COLOR, 1.0);
	sleep (10); 
	object_create (shield_02);
	SetObjectRealVariable(shield_02, VAR_SYMBOL_COLOR, 1.0);
	//object_create (forts1_symbol_2);
	//SetObjectRealVariable(forts1_symbol_2, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort_lights_west);
	SetObjectRealVariable(fort_lights_west, VAR_SYMBOL_COLOR, 1.0);
	sleep (10); 
	object_create (shield_03);
	SetObjectRealVariable(shield_03, VAR_SYMBOL_COLOR, 1.0);
	//object_create (forts1_symbol_3);
	//SetObjectRealVariable(forts1_symbol_3, VAR_SYMBOL_COLOR, 1.0);
	object_create (fort_lights_east);
	SetObjectRealVariable(fort_lights_east, VAR_SYMBOL_COLOR, 1.0);
	
	sleep (30 * 1);
	dprint ("CORTANA: Those generators seem to be powering the shields...");

	b_symbols_created = TRUE;

	forts_1_sequencer = 1;
	
	sleep (30 * 10);
	
end


script static void f_stop_powercore_machine(device d_machine)
	sleep_until (f_check_device_position (d_machine, 2, 100), 1);
	//sleep (5);
	//sleep_until (f_check_device_position (d_machine, 2, 100), 1);
	device_set_power (d_machine, 0);
	sleep_until(device_get_power (d_machine) == 0, 1);
	DEF_CURRENT_POSITION = device_get_position (d_machine);
	device_set_position (d_machine, DEF_CURRENT_POSITION);
end

script static boolean f_check_device_position(device d_machine, short S_FRAME_CHECK, short S_TOTAL_FRAMES) 

  device_get_position(d_machine) <= (S_FRAME_CHECK / S_TOTAL_FRAMES);
  
end



// *** Generator 1 - SOUTH *** =============================================================================

script static void f_generator_switch_01()
	//Sets blip on Generator 1 until player deactivates, then triggers shield deactivation. 

	//Waits until core is destroyed...
	sleep_until (object_get_health (generator_01_core) <= 0, 1); 
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts1_tempfx.p3);
	dprint ("core_01 destroyed");
	object_destroy (generator_01_core);
	f_unblip_object (generator_01_core);
	dprint ("core_01 destroyed part 2");
	//object_destroy (forts1_symbol_1);

	object_destroy (fort_lights_south);
	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(south_device_1);
	thread (south_machine_retract());
	//Now go do stuff. 
	print ("Shield 1 Deactivated");
	//Bumps up the Generator Count, so we can track how many generators are down. Important because player can do in any order.  
	forts_1_generator_count = (forts_1_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_1_generator_count); // prints value of variable. 
	
	//Tells the level this particular generator is dead. 
	forts_1_generator_south_dead = 1;
	b_south_generator_dead = TRUE;
	print ("South Generator dead!");

	sound_impulse_start ('sound\weapons\plasma_grenade\plasma_expl.sound', NONE, 1);
	print ("sound played");

	thread (f_orderly_shield_deactivation());

end

script static void south_machine_retract()
	south_device_2->f_animate();
end



// *** Generator 2 - WEST *** =============================================================================

script static void f_generator_switch_02()
	//Sets blip on Generator 2 until player deactivates, then triggers shield deactivation. 
	
	sleep_until (object_get_health (generator_02_core) <= 0, 1); 
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts1_tempfx.p4);
	object_destroy (generator_02_core);
	f_unblip_object (generator_02_core);
	//object_destroy (forts1_symbol_2);

	object_destroy (fort_lights_west);
	//game_save_no_timeout();
	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(west_device_1);
	thread (west_machine_retract());

	print ("Shield 2 Deactivated");
	forts_1_generator_count = (forts_1_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_1_generator_count); 
	
	//Tells the level this particular generator is dead. 
	forts_1_generator_west_dead = 1;
	b_west_generator_dead = TRUE;
	print ("West Generator dead!");
	
	thread (f_orderly_shield_deactivation());

end

script static void west_machine_retract()
	west_device_2->f_animate();
end

// *** Generator 3 - EAST *** =============================================================================

script static void f_generator_switch_03()
	//Sets blip on Generator 3 until player deactivates, then triggers shield deactivation. 
	
	sleep_until (object_get_health (generator_03_core) <= 0, 1); 
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_forts1_tempfx.p5);
	object_destroy (generator_03_core);
	f_unblip_object (generator_03_core);
	//object_destroy (forts1_symbol_3);

	object_destroy (fort_lights_east);
	//object_set_shield (player0, 1);
	sleep (5);
	game_save_no_timeout();
	f_stop_powercore_machine(east_device_1);
	thread (east_machine_retract());

	print ("Shield 3 Deactivated");
	forts_1_generator_count = (forts_1_generator_count + 1);
	print ("Generator Count is now ...");
	inspect (forts_1_generator_count); 
	
	//Tells the level this particular generator is dead. 
	forts_1_generator_east_dead = 1;
	b_east_generator_dead = TRUE;
	print ("East Generator dead!");
	
	thread (f_orderly_shield_deactivation());
	
end

script static void east_machine_retract()
	east_device_2->f_animate();
end


// *** All Generators Down *** =====================================================================


script static void f_orderly_shield_deactivation()
	//Always deactivates bridge shields from front to back, now matter the generator order. 
	
	if (forts_1_generator_count == 1) then 
		print ("CORTANA: Look Chief! That did it! One down!");
		object_destroy (shield_01);
		music_forts1_destroy1();
		wake (M30_plyonone_core_one);	
	end

	if (forts_1_generator_count == 2) then 
		print ("CORTANA: One more to go, Chief!");
		object_destroy (shield_01);
		object_destroy (shield_02);
		music_forts1_destroy2();
		wake (M30_plyonone_core_two);
	end

	if (forts_1_generator_count == 3) then 
		// Last one! Time to trigger final shields down, bridge up sequence. 
		object_destroy (shield_01);
		object_destroy (shield_02);
		object_destroy (shield_03);
		music_forts1_destroy3();
		forts_1_generator_count = 4; 
		b_all_cores_destroyed = TRUE;
		wake (M30_plyonone_core_three);
	end

end


script dormant f_forts1_shields_deactivate
	//All 3 Generators Deactivated. All Shields Down. Bridge Activated. 

	//	Generator counter check. 
	sleep_until ((forts_1_generator_count == 4), 1);
	sleep (30);
	print ("CORTANA: That should do it! Let's get up into the Pylon!");
	// Turn on Blip. 
	wake (f_forts1_mainfort_blip);
	
	//	Get rid of shields, switch off facade icon. 
	sleep (30);

	// Turn on triggers for hardlight bridge activation. 
	wake (f_forts1_bridge_activate);
	print ("*** Bridge Activated ***");
	
end


// *** Hardlight Bridge Activation *** =============================================================
// After the shields are deactivated, hardlight bridges activate on proximity. 

script dormant f_forts1_bridge_activate
// Gets woken up in f_forts1_shields_deactivate, after all shields down. 
	
	sleep_until (volume_test_players (tv_pylon1_entrance), 1);

	thread (f_mus_m30_e04_finish());
	f_unblip_flag (flag_waypoint_ramp);

end

// *** Synced Color Changing *** ==================================================================

script static void f_synced_color_changing (object core_ID, object shield_ID, object lights_ID)
	repeat
		
		sleep (1);
		
		SetObjectRealVariable(shield_ID, VAR_OBJ_LOCAL_A, (object_get_health(core_ID)));
		SetObjectRealVariable(lights_ID, VAR_OBJ_LOCAL_A, (object_get_health(core_ID)));
		
	until (object_get_health(core_ID) <= 0);
	

end
/*
script static void f_color_change_go()
	sleep_until (b_symbols_created == TRUE);
		thread (f_synced_color_changing (generator_01_core, shield_01, fort_lights_south));
		thread (f_synced_color_changing (generator_02_core, shield_02, fort_lights_west));
		thread (f_synced_color_changing (generator_03_core, shield_03, fort_lights_east));
end
*/
