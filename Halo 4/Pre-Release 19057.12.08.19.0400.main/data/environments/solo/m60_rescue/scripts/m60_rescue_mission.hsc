//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue
//	Insertion Points:	start (or icl)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short obj_state = 0;
global short bish_born = 0;
global short cannon_fire = 0;
global short deck_drop = 0;
global short at_infinity = 0;
global short evac_tele = 0;
global short deck_gun_count = 0;
global short deck_gun_1_pos = 0;
global short deck_gun_2_pos = 0;
global short deck_phantom_count = 0;
global short mech_fire_training = 0;

global boolean mech1_fire_on = FALSE;
global boolean mech1_smoke_on = FALSE;
global boolean mech2_fire_on = FALSE;
global boolean mech2_smoke_on = FALSE;
global boolean phantom_deck_mid_b = FALSE;
global boolean phantom_deck_l_b = FALSE;
global boolean phantom_deck_r_b = FALSE;
global boolean vig_knight_aware = FALSE;
global boolean g_shoot_cannon = false;
global boolean m60_achievement_boulders = false;
global boolean m60_achievement_rally = false;
global boolean m60_achievement_berth = false;
global boolean m60_achievement_complete = false;
global boolean m60_tank_rally_debug = false;
global boolean uphill_hack = false;
global boolean cryptum_gone = false;
global boolean bool_trail_a_co_op = false;
global boolean bool_trail_b_co_op = false;
global boolean bool_trail_c_co_op = false;
global boolean bool_boulders_co_op = false;
global boolean bool_ral_14_co_op = false;
global boolean bool_ral_15_co_op = false;

global object g_ics_player = none;
global object g_deck_gun = none;

global long g_cryptum_state = 0;
global long g_pup_cryptum_show = 0;

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

//script startup m60_rescue()
//	
//	if b_debug then 
//		print_difficulty(); 
//	end
//	
//	if b_debug then 
//		print ("::: M60 - RESCUE :::");
//	end
//			
//	// put back in during massout
//	//(f_loadout_set "default")
//	
//	if b_encounters then
//		wake (f_cliff_main);
//		wake (teleport_elevator);
//  	wake (d_start);
//  	wake (fore_shadow);
//  	wake (f_caves_main);
//  	wake (f_thicket_main);
//  	wake (trail_2);
//  	wake (f_trailstwo_main);
//  	wake (knight_preview);
//  	wake (f_plains);
//  	
//  end
//
//// ============================================================================================
//// STARTING THE GAME
//// ============================================================================================
//	
//	if (b_game_emulate or ((b_editor != 1) and (player_count() > 0))) then		
//		start();
//		// else just fade in, we're in edit mode
//	elseif b_debug then
//		print (":::  editor mode  :::");
//	end
//end

script startup mission_startup()
	dprint ("::: M60 - RESCUE :::");

	if ( b_game_emulate or (not editor_mode()) ) then
	
		// in editor mode make sure the players are there to start
		if ( editor_mode() ) then
			f_insertion_playerwait();
		end

		// run start function
		start();

		sleep_until( b_mission_started, 1 );
	//	effect_attached_to_camera_new(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);
	//	effect_new_on_object_marker_loop (	"environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_ambient.effect", intro_cryptum, fx_ambient);
	//	fade_in( 0, 0, 0, (0.50 * 30) );
		
		print (":  : Startup Fade Would Happen Here :  :");
		
		ai_allegiance(player, human);

		effects_distortion_enabled = 0;

	end

	// wait for the game to start
	sleep_until( b_mission_started, 1 );

	objectives_set_string (0, start_obj_1);
	objectives_set_string (1, start_obj_2);
	objectives_set_string (2, start_obj_3);
	objectives_set_string (3, start_obj_4);

//	wake (trail_a_co_op);
	wake (trail_b_co_op);
//	wake (trail_c_co_op);


	
	// display difficulty
	print_difficulty(); 
	
end

// =================================================================================================
// =================================================================================================
// CO-OP KILL VOLUMES
// =================================================================================================
// =================================================================================================

script dormant trail_a_co_op
	
	sleep_until (volume_test_players (trail_a_playspace), 1);
	
	//print (":  : Trail A Teleport Active :  :");
	
		repeat
		
	//	print (":  : Trail A Teleport Active :  :");
		
			if
				volume_test_players (trail_a_playspace) == TRUE
			then
				if
					volume_test_players (trail_a_co_op_teleport) == TRUE
				then
				print (":  : Trails A Teleport :  :");
				volume_teleport_players_not_inside (trail_a_playspace, flag_trail_a_teleport);
				end
			end
			
		until
		
			(bool_trail_a_co_op == TRUE);
		
	print (":  : Trails B Co-Op Done :  :");

end

script dormant trail_b_co_op
	
	sleep_until (volume_test_players (trail_b_playspace), 1);
	
//	print (":  : Trail B Teleport Active :  :");
	
		repeat
		
		//	print (":  : Trail B Teleport Active :  :");
		
			if
				volume_test_players (trail_b_playspace) == TRUE
			then
				if
					volume_test_players (trail_b_co_op_teleport) == TRUE
				then
					print (":  : Trails B Teleport :  :");
					volume_teleport_players_not_inside (trail_b_playspace, flag_trail_b_teleport);
				end
			end
			
		until
		
			(bool_trail_b_co_op == TRUE, 1);
		
	print (":  : Trails B Co-Op Done :  :");

end

script dormant trail_c_co_op
	
	sleep_until (volume_test_players (trail_c_playspace), 1);
	
	//print (":  : Trail C Teleport Active :  :");
	
		repeat
		
	//		print (":  : Trail C Teleport Active :  :");
		
			if
				volume_test_players (trail_c_playspace) == TRUE
			then
				if
					volume_test_players (trail_c_co_op_teleport) == TRUE
				then				
					print (":  : Trails C Teleport :  :");
					volume_teleport_players_not_inside (trail_c_playspace, flag_trail_c_teleport);
				end
			end
			
		until
		
			(bool_trail_c_co_op == TRUE);
		
	print (":  : Trails C Co-Op Done :  :");

end

script dormant boulders_co_op
	
	sleep_until (volume_test_players (boulders_playspace), 1);
	
		repeat
		
			if
				volume_test_players (boulders_playspace) == TRUE
			then
				if
					volume_test_players (boulders_co_op_teleport) == TRUE
				then
					print (":  : Boulders Teleport :  :");
					volume_teleport_players_not_inside (boulders_playspace, flag_boulders_teleport);
				end
			end
			
		until
		
			(bool_boulders_co_op == TRUE);
		
	print (":  : Boulders Co-Op Done :  :");

end

script dormant ral_14_co_op
	
	sleep_until (volume_test_players (ral_14_playspace), 1);
	
		repeat
		
			if
				volume_test_players (ral_14_playspace) == TRUE
			then
				if
					volume_test_players (ral_14_co_op_teleport) == TRUE
				then
					print (":  : Rally 14 Teleport :  :");
					volume_teleport_players_not_inside (ral_14_playspace, flag_ral_14_teleport);
				end
			end
			
		until
		
			(bool_ral_14_co_op == TRUE);
		
	print (":  : Rally 14 Co-Op Done :  :");

end

script dormant ral_15_co_op
	
	sleep_until (volume_test_players (ral_15_playspace), 1);
	
		repeat
		
			if
				volume_test_players (ral_15_playspace) == TRUE
			then
				if
					volume_test_players (ral_15_co_op_teleport) == TRUE
				then
					print (":  : Rally 15 Teleport :  :");
					volume_teleport_players_not_inside (ral_15_playspace, flag_ral_15_teleport);
				end
			end
			
		until
		
			(bool_ral_15_co_op == TRUE);
		
	print (":  : Rally 14 Co-Op Done :  :");

end


// =================================================================================================
// =================================================================================================
// SOFT WALL BACKTRACKING VOLUMES
// =================================================================================================
// =================================================================================================

script dormant peak_a_soft_wall()
	
	sleep_until (volume_test_players (tv_wall_a), 1);
	soft_ceiling_enable ("softwall_blocker_peak_a", TRUE);
	
	print (":  : Peak A Wall On :  :");
	
	volume_teleport_players_not_inside (tv_wall_a, flag_wall_a);

end

script dormant trail_c_soft_wall()
	
	sleep_until (volume_test_players (tv_wall_trail_c), 1);
	soft_ceiling_enable ("softwall_blocker_trail_c", TRUE);
	
	print (":  : Trail C Wall On :  :");
	
	volume_teleport_players_not_inside (tv_wall_trail_c_act, flag_trail_c);

end

// =================================================================================================
// =================================================================================================
// START
// =================================================================================================
// =================================================================================================

script static void start()
	dprint( "::: start :::");

	f_insertion_index_load( game_insertion_point_get() );

end


// =================================================================================================
// =================================================================================================
// PEAK
// =================================================================================================
// =================================================================================================

script dormant f_cliff_main()
	
	sleep_until (b_mission_started == TRUE);
	dprint  ("::: cliff start :::");

	effect_attached_to_camera_new(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);
	
	object_cinematic_visibility (intro_cryptum, TRUE);
	
	print (":  : Intro Cryptum FX :  :");
		
	wake (fore_shadow);
	wake (knight_preview);
	wake (cryptum_fx_peak);
	
	objectives_show (0);
	
	sleep (30);
	
	pup_play_show (air_show);
//	thread (play_temp_bink_cutscene("060_opening", 60));
	
end

script static void e3_phantom_shake()

sleep (30);
camera_shake_player (player0, 0.65, 0.65, 1, 3);
camera_shake_player (player1, 0.65, 0.65, 1, 3);
camera_shake_player (player2, 0.65, 0.65, 1, 3);
camera_shake_player (player3, 0.65, 0.65, 1, 3);

// Shows leaves falling all around due to the shaking
print("***** LEAVES FALLING *****");
effect_new(environments\solo\m60_rescue\fx\plant\fallingleaf_burst.effect, fx_00_fallingleaves);

sleep (30 * 3);

end

script dormant cryptum_fx_peak()
	print (":  : Peak Scanning :  :");
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_scan_loop.effect", intro_cryptum, fx_new_scan_A);
end
// =================================================================================================
// =================================================================================================
// TRAIL
// =================================================================================================
// =================================================================================================

//Spooky Forerunner
script dormant fore_shadow
	sleep_until (volume_test_players (vol_fore1), 1);

	data_mine_set_mission_segment("m60_trails_1");

end

script dormant knight_preview
	sleep_until (volume_test_players (trigger_fog), 1);
	wake (knight_aware);
	ai_cannot_die (sq_xray_vig_kn, TRUE);
	soft_ceiling_enable ("softwall_blocker_peak_a", FALSE);
	unit_doesnt_drop_items (ai_actors (sq_xray_vig_kn));
	pup_play_show (dead_marines);
	
	object_wake_physics (dead_marine_01);
	
	wake (peak_a_soft_wall);
	
	print (": Blah :");
end

script dormant knight_aware
	
	print (":  : Vignette Knights unaware :  :");
	
	sleep_until (ai_combat_status (sq_peak_vig_kn) > 1
		or
	volume_test_players (trig_peak_vig_escape), 1);
	
	print (" :  : Vignette Knights spooked :  :");
	
	vig_knight_aware = TRUE;
	
end

script command_script knight_vig_phase
	
	cs_walk (1);
	sleep_until (vig_knight_aware == TRUE);
	cs_face_player (1);
	sleep (random_range (15, 30));
//	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_phase_to_point (trail1_phase.p0);
	ai_erase (ai_current_actor);

end

script command_script knight_phase_trail
	sleep_until (volume_test_players (vol_fore2), 1);
	sleep (random_range (15, 35));
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_phase_to_point (trail1_phase.p0);
	sleep (30);
	ai_erase (ai_current_actor);
	wake (Peak_Prometheans_appear);
end

script command_script knight_preview_1
	sleep_until (volume_test_players (vol_fore2), 1);
	thread (xray_fx_play(ai_current_actor));
	sleep (30);
	cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	cs_phase_to_point (trail1_phase.p0);
	sleep (30);
	ai_erase (ai_current_actor);
end

script static void phase_knight_vig( object knight )
	print (":  : Phase Out :  :");
//	sleep (random_range (0, 45));
	cs_phase_to_point(object_get_ai(knight),true,trail1_phase.p0);
	ai_erase(object_get_ai(knight));
end


// =================================================================================================
// =================================================================================================
// HOLLOW
// =================================================================================================
// =================================================================================================

//script dormant hollow_fight
//	wake (plant_device);
//end

// =================================================================================================
// =================================================================================================
// TRAILS 2
// =================================================================================================
// =================================================================================================

script dormant trail_2

	ai_place (trail_3_1);
	
	ai_actor_dialogue_enable (sq_trail3_hum, FALSE);
	
	bool_trail_a_co_op = true;
	bool_trail_b_co_op = true;
	bool_trail_c_co_op = true;
	
	device_set_power (door_treehouse_exit, 0);
	
	objectives_show (1);
	
	data_mine_set_mission_segment("m60_trails_3");
	
	game_save_immediate();
	sleep_until (cutscene_over == 1);
	
	game_insertion_point_unlock(3);
	
	print (" :  : Trail 2 :  : ");
	
	ai_place (th_fore);

	print (":  : Placeholder Dialog :  :");

	sleep (30 * 3);

	ai_place (sq_trail3_bishop);	
	
	device_set_power (t2_door, 1);
	
	sleep_until (volume_test_players (objcon_trail3_start), 1);
	
	effect_attached_to_camera_new(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);
	
	//Encounter 3 Music Start
	
	thread (f_mus_m60_e03_begin());
	
	//ai_set_objective (sq_trail3_hum, obj_trail3_hum);
	
	//ai_set_task (sq_trail3_hum, obj_trail3_hum, tasks_1_hum_objcon1);
	
	sleep_until (volume_test_players (objcon_trail3_mid), 1);
	ai_actor_dialogue_enable (sq_trail3_hum, TRUE);
	
	ai_place (sq_trail3_bishop_2);
	ai_place (sq_trail3_fore_p_spawn);
	
	print (" :  : Spawning :  : ");
	
	sleep_until (volume_test_players (objcon_trail3_hill), 1);

	game_save();

	wake (d_start);
	
//	ai_place (th_fore);
	
	sleep_until (volume_test_players (th_spawn_kn_1), 1);
	
	ai_place_in_limbo (sq_th_fore_k1);
	
	/*sleep_until (
		ai_living_count (sq_th_fore_k1) < 1
			OR
		volume_test_players (th_int)
							);
							
	ai_place (sq_th_fore_k2);
	
	*/
	
	sleep_until (volume_test_players (trig_th_end), 1);

	obj_state = 0;
	
	sleep_until (volume_test_objects (trig_th_end, (ai_actors (sq_trail3_hum))), 1);
	
	print (":  : Moving to Boulders objective :  :");
	
	ai_set_objective (sq_trail3_hum, obj_bou_hum);
	
end



script command_script trail_2_phase
	sleep_until (volume_test_players (objcon_trail3_end)
	or
	ai_living_count (sq_trail3_fore_kn_1) < 1);
	cs_phase_to_point (trail3_kn_phase.p0);
end

script command_script th_phase
	sleep_until (volume_test_players (th_int)
	or
	ai_living_count (sq_th_fore_k1) < 1);
	cs_phase_to_point (th_kn_phase.p0);
end

script command_script trail_2_phase_1
	sleep (30 * 5);
	cs_phase_to_point (trail3_kn_phase.p1);
	sleep (30);
end

script command_script treehouse_phase
	cs_phase_in();
	sleep (30 * 2);
	cs_phase_to_point (th_kn_phase.p0);
end

// =================================================================================================
// =================================================================================================
// BOULDERS
// =================================================================================================
// =================================================================================================

// Boulders

script static void f_activator_get( object obj_control, unit u_activator )
	g_ics_player = u_activator;
		
		if ( obj_control == domain_terminal_button ) then
		
    f_narrative_domain_terminal_interact( 2, domain_terminal, domain_terminal_button, u_activator, 'pup_domain_terminal' );
    
    end
	
end

script dormant d_start
	data_mine_set_mission_segment("m60_boulders");
	sleep_until (volume_test_players (trigger_d_start), 1);
	
	object_wake_physics (boulders_officer);
	object_wake_physics (bouldertop_dead);
	object_wake_physics (bouldertop_dead_2);
	object_wake_physics (boulders_dead_2);
	
	wake(cortana_plinth_appear);
	game_save();
	obj_state = 0;
	thread (boulderobj());
	print (":  : Headed to D :  :");
	ai_place (sq_marine_bou_a_1);
	ai_place (bou_1);
	
	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_fore_bou_turret_1.turret1)), FALSE);
	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_fore_bou_turret_2.turret1)), FALSE);
	
	sleep_until (volume_test_players (trig_bou_mid), 1);

	print (" :  : Objective State 1 :  : ");
	obj_state = 1;
	ai_place_with_shards (sq_fore_bou_turret_1);
	
	ai_place_with_shards (sq_fore_bou_turret_2);
	game_save_no_timeout();
	garbage_collect_now();	
	
	ai_place (bou_2);
	
	wake (f_dialog_m60_turrets_callout);
	print (" :  : Cortana : Turrets! :  :");
	
	wake (f_dialog_m60_find_some_cover);
	print (":  : Cortana : Find some cover! :  :");
	
	ai_place (sq_fore_bou_rear_f);
	
	ai_place_in_limbo (sq_fore_bou_rear_kn_r);
	
	sleep_until (volume_test_players (trig_bou_up)
	
	OR
	
							ai_living_count (bou_2) < 1);
	
	sleep (30 * 2);
	
	ai_place_in_limbo (sq_fore_bou_rear_kn_l);
	
	sleep_until (ai_living_count (bou_2_fore) < 1
	
		AND
							ai_living_count (bou_2) < 1);
	
	garbage_collect_now();	
	
	print ("Uphill Wave = Done");

	//Encounter 3 Music End

	ai_set_objective (sq_marine_bou_a_1, obj_boulder_b_hum);
	
	ai_set_objective (sq_trail3_hum, obj_boulder_b_hum);
	
	thread (f_mus_m60_e03_finish());

	sleep (30 * 3);
	
	wake (Cortana_plinth_callout);

	sleep (30 * 5);

//	sleep_until(dialog_id_played_check(l_dlg_m60_plinth_call), 1);

	wake (uphill);
	
end

script dormant uphill
	
	object_create (lightbridge_active);
	
	sleep (30 * 2);
	
	f_blip_object (lightbridge_active, "activate");
		
	ai_lod_full_detail_actors (50);
	
	sleep_until (device_get_position (lightbridge_active) != 0);
	
	pup_play_show (boulder_button_insert);
	uphill_hack = true;	
	
	f_unblip_object (lightbridge_active);
	
	sleep (55);
	
	effect_new_on_object_marker ("objects\characters\storm_cortana\fx\orb\orb_spawn.effect", boulders_plinth, "m_top_stand");
	
	sleep (6);
	
	effect_new_on_object_marker_loop ("objects\characters\storm_cortana\fx\orb\cor_orb_persistant.effect", boulders_plinth, "m_top_stand");
	
//	sleep (30* 3);
	
//	pup_play_show (cortana_plinth_on);
	
	object_destroy (lightbridge_active);
	
	game_save_no_timeout();
	
	ai_vehicle_enter (sq_marine_bou_a_1, boulder_t1);
	
	ai_vehicle_enter (sq_marine_bou_a_1, boulder_t2);
	
	ai_vehicle_enter (sq_marine_bou_a_1, boulder_t3);
	
	thread (f_mus_m60_e04_begin());
	
	//Encounter 4 Music Start
	
	ai_place_in_limbo (sq_bou_fore_b_p1);
	
	sleep (30 * 6);
	
	thread (boulderdefstring());
	garbage_collect_now();

	sleep (30 * 4);
	
	ai_place_in_limbo (sq_bou_fore_kn_b1.p0);
	
	sleep (random_range (15, 30));
	
	ai_place_in_limbo (sq_bou_fore_kn_b1.p1);
	
	sleep (30 * 3);
	
	wake (Cortana_plinth_rampant_01);

	sleep_until (ai_living_count (sg_bou_kn) < 1);

	garbage_collect_now();

	sleep_until (ai_living_count (sg_bou_pawn) < 3);

	sleep (30 * 3);

	ai_place (sq_bou_fore_bi_b2); //Bishop One
	ai_place (sq_bou_fore_kn_b4); //Hidden Knight

	print (" :  : Wave 1 :  : ");

	ai_place_in_limbo (sq_bou_fore_b_p3);
	
	ai_place (sg_bou_pawn_sp);
	ai_place (sq_bou_fore_b_p2);
	
	wake (Cortana_plinth_rampant_02);	
	
	garbage_collect_now();
	
	print (" :  : Wave 2 :  : ");
	
	sleep (30 * 3);
	
	ai_place_in_limbo (sq_bou_fore_b_p4);

	sleep_until (ai_living_count (sg_bou_pawn) < 3);

	sleep_until (ai_living_count (sg_bou_kn) < 1);

	sleep (30 * 3);

	ai_place_in_limbo (sq_bou_fore_kn_b5);
	
	ai_place_in_limbo (sq_bou_fore_b_p5);
	
	sleep (30 * 3);
	
	sleep_until (ai_living_count (sg_bou_pawn) < 3);
	
	ai_place (sq_bou_fore_b_sharder); //Bishop Three
	ai_place_with_shards (sq_bou_fore_b_shard_1);
	
	print (" :  : Wave 4 :  : ");
	
	wake (f_dialog_m60_callout_additional_forerunners);
	print (" :  : Cortana : Additional Forerunners inbound! :  : ");
	
	wake (f_dialog_m60_callout_on_top_of_us);
	print (" :  : Cortana : They’re almost on top of us! :  : ");
	
	garbage_collect_now();
	
	sleep_until (ai_living_count (sg_bou_pawn) < 2);
	
	sleep_until (ai_living_count (sg_bou_kn) < 1);
	
	sleep (30 * 4);
	
	ai_place (sq_bou_fore_bi_b2); // Bishop Two

	ai_place_in_limbo (sq_bou_fore_kn_b2);
	
	sleep_until (ai_living_count (sq_bou_fore_kn_b2) < 1);
	
	print (" :  : Wave 5 :  : ");
	
	sleep_until (ai_living_count (sg_bou_kn) < 1);
	
	sleep (30 * 4);
	
	ai_place_in_limbo (sq_bou_fore_kn_b3);
	
	wake (Cortana_plinth_rampant_03);

	sleep_until (ai_strength (sq_bou_fore_kn_b3) < .5);
	
	sleep (30 * 5);

	ai_place_in_limbo (sq_bou_fore_b_p4);
	
	obj_state = 2;
	
	sleep_until (ai_living_count (sg_bou_kn) < 1);

	sleep (30 * 4);

	object_create (lightbridge_active_2);

	wake (Boulders_plinth_finished);		
	
	f_blip_flag (cave_entrance, "activate");
	
	sleep_until (device_get_position (lightbridge_active_2) != 0);
	
	pup_play_show (boulder_button_pull);

	sleep (27);

	effect_new_on_object_marker ("objects\characters\storm_cortana\fx\orb\orb_spawn.effect", boulders_plinth, "m_top_stand");
	
	sleep (6);
	
	effect_stop_object_marker ("objects\characters\storm_cortana\fx\orb\cor_orb_persistant.effect", boulders_plinth, "m_top_stand");

	object_destroy (lightbridge_active_2);

	f_unblip_flag (cave_entrance);

	wake (cavestrings);

	sleep (30 * 4);

	thread (lightbridge_active());
	
	wake (f_caves_main);
	
	wake (boulders_co_op);
	
end

script static void boulderdefstring

	cui_hud_set_new_objective (chtitledefendhilltop);
	sleep (30 * 3);
			
end

script static void lightbridge_active()
	
	device_set_power (boulders_door, 1);
	thread (f_m60_music_nothing()); // end swamp02 music
	
	sleep (30 * 3);	
	
	sleep_until (volume_test_players (trig_cave_ent), 1);
	
	garbage_collect_now();
	
	sleep_until (volume_test_players (tv_cave_lb), 1);
	
	device_set_power (boulders_door, 0);
	
	sleep (30 * 2);
	
	volume_teleport_players_not_inside (tv_cave_lb, flag_cave_teleport);
	
end

//Boulders Turret Activation

script command_script cs_boulder_turret_spawn
	RequestAutomatedTurretActivation(ai_vehicle_get_from_spawn_point (sq_fore_bou_turret_1.turret1));
	RequestAutomatedTurretActivation(ai_vehicle_get_from_spawn_point (sq_fore_bou_turret_2.turret1));
end

script command_script cs_pawn_spawn
	print("pawn sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn2, 1.5);
end

script static void OnCompleteProtoSpawn2
	print ("PAWN DE FLOOR");
end

script command_script boulder_phase_1
	cs_phase_to_point (boulder_phase.p0);
end

script command_script boulder_phase_2
	cs_phase_to_point (boulder_phase.p1);
end

script command_script boulder_phase_3
	sleep_until (volume_test_players (trigger_phase)
	or
	ai_living_count (bou_1) < 10);
	sleep (random_range (30, 60));
	cs_phase_to_point (boulder_phase.p2);
end

script command_script boulder_phase_4
	sleep_until (volume_test_players (trigger_phase)
	or
	ai_living_count (bou_1) < 10);
	sleep (random_range (30, 60));
	cs_phase_to_point (boulder_phase.p3);
end

script command_script boulder_phase_b1
	cs_phase_to_point (boulder_phase.p4);
end

script command_script boulder_phase_b2
	cs_phase_to_point (boulder_phase.p5);
end

script command_script boulder_phase_b3
	cs_phase_to_point (boulder_phase.p6);
end

script command_script boulder_b_intro_1
	cs_abort_on_damage (FALSE);
//	cs_phase_in();
	cs_phase_in_blocking();
	sleep (random_range (30, 90));
	cs_phase_to_point (boulder_b_intro_phase.p0);
	sleep (random_range (0, 10));
	cs_phase_to_point (boulder_b_intro_phase.p3);
	sleep (random_range (0, 10));
	cs_phase_to_point (boulder_b_intro_phase.p4);
end

script command_script boulder_b_intro_2
	cs_abort_on_damage (FALSE);
	//cs_phase_in();
	cs_phase_in_blocking();
	sleep (random_range (30, 90));
	cs_phase_to_point (boulder_b_intro_phase.p1);
	sleep (random_range (0, 10));
	cs_phase_to_point (boulder_b_intro_phase.p2);
	sleep (random_range (0, 10));
	cs_phase_to_point (boulder_b_intro_phase.p5);
end

script static void boulderobj()

	cui_hud_set_objective_complete (obj_complete);
	sleep (30 * 5);
	
	cui_hud_set_new_objective (chtitleboulder1);
		
end

script dormant cavestrings
	
	game_save();
	
	cui_hud_set_objective_complete (obj_complete);
	
	sleep (30 * 6);
	
	cui_hud_set_new_objective (chtitlemarsh2);
	
	
end

// =================================================================================================
// =================================================================================================
// RALLY POINT TELEPORT (TEMP)
// =================================================================================================
// =================================================================================================


script command_script cs_evac

	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", 0, 0);	
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l02", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l03", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l04", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l05", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r01", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r02", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r03", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r04", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r05", 0, 0);

	cs_vehicle_speed (.7);
	cs_fly_by (ps_cave_evac.p0);
	cs_fly_by (ps_cave_evac.p1);
	cs_fly_by (ps_cave_evac.p2);
	cs_fly_by (ps_cave_evac.p5);
	cs_vehicle_speed (.3);
	cs_fly_to_and_face (ps_cave_evac.p4, ps_cave_evac.p3);
	sleep (30 * 2);
	cs_vehicle_speed (.1);
	cs_fly_to_and_face (ps_cave_evac.p6, ps_cave_evac.p7);

	cs_vehicle_speed_instantaneous(0);

	f_blip_object (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "recon");
//	vehicle_hover (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), TRUE);
//	object_set_physics (object_at_marker (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "interior_attach"), FALSE);
	
	thread (pelican_door_anim());

	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", 1, 0);	
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l02", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l03", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l04", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l05", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r01", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r02", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r03", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r04", 1, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r05", 1, 0);

	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver)), 1);

	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", 0, 0);	
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l02", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l03", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l04", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l05", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r01", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r02", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r03", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r04", 0, 0);
	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_r05", 0, 0);

//	object_create (m60_pelican_control);
//	object_hide (m60_pelican_control, TRUE);
	
	//sleep_until (device_get_position (m60_pelican_control) == 0);
	
	//print (" :  : In the Pelican :  :");
	
		if
			
			player_valid (player1)
		
		OR
		
			player_valid (player2)
			
		OR
		
			player_valid (player3)
		
		then
			teleport_players_into_vehicle (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver));
			print (":  : Co-Op players are all up in :  :");
		else
			print (":  : Flying solo :  :");
		end
	
	
	f_unblip_object (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver));

//	cs_vehicle_speed (.5);
//	cs_fly_by (ps_cave_evac.p2);
//	cs_fly_by (ps_cave_evac.p1);
	
		evac_tele = 1;

end

script static void pelican_door_anim()
	custom_animation_hold_last_frame (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", false);
//	sleep_until (volume_test_players (tv_rally_tele_temp), 1);
	sleep (30 * 1);
//	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", player0);
	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver)), 1);
	print (":  : Teleporting into seat :  :");
	sleep (30 * 5);
	unit_stop_custom_animation (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver));
end

script dormant rally_teleport
	sleep (30 * 4);

	local long pup_show_id = 0;

	pup_show_id = pup_play_show (cave_pelican);

	vehicle_set_player_interaction (pelepupp, "pelican_p_l01", 1, 0);	
	vehicle_set_player_interaction (pelepupp, "pelican_p_l02", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l03", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l04", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l05", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r01", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r02", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r03", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r04", 1, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r05", 1, 0);

//	ai_place (sq_cave_evac);
//	ai_cannot_die (sq_cave_evac, TRUE);
//	object_cannot_take_damage ((ai_vehicle_get_from_spawn_point (sq_cave_evac.driver)));
	print (":  : Temp Pelican Teleport :  :");
//	sleep_until (volume_test_players (tv_rally_tele_temp), 1);
//	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver)), 1);
	sleep_until (player_in_vehicle (pelepupp), 1);
	music_set_state('Play_mus_m60_v08_board_pelican');
	
	vehicle_set_player_interaction (pelepupp, "pelican_p_l01", 0, 0);	
	vehicle_set_player_interaction (pelepupp, "pelican_p_l02", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l03", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l04", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_l05", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r01", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r02", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r03", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r04", 0, 0);
	vehicle_set_player_interaction (pelepupp, "pelican_p_r05", 0, 0);
	
	unit_lower_weapon (player0, 45);
	unit_lower_weapon (player1, 45);
	unit_lower_weapon (player2, 45);
	unit_lower_weapon (player3, 45);
	
	sleep (30 * 2);
	wake (pelican_chief_welcome);
	//sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_marine_evac.driver)), 1);
	
	chud_cinematic_fade (0, 60);
	fade_out (0, 0, 0, 60);
	
	//pup_stop_show (pup_show_id);
	
	sleep (30 * 6);

	unit_exit_vehicle (player0, 0);
	unit_exit_vehicle (player0, 1);	
	unit_exit_vehicle (player0, 2);	
	unit_exit_vehicle (player0, 3);	
	
	//render_atmosphere_fog (FALSE);
	
	garbage_collect_unsafe();
	//ai_erase_all();
	
	object_teleport_to_ai_point (player0, ps_pelican_pupp_out.p0);
	object_teleport_to_ai_point (player1, ps_pelican_pupp_out.p0);
	object_teleport_to_ai_point (player2, ps_pelican_pupp_out.p0);
	object_teleport_to_ai_point (player3, ps_pelican_pupp_out.p0);
	
	switch_zone_set ("caves_rally");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (caves_rally) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == zs_caves_rally, 1);
	
	print (" :  : ZONE SET LOADED :  :");
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (caves_rally)");
	end
	
	//vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_cave_evac.driver), "pelican_p_l01", 0, 1);
	
	sleep (1);
	
	object_teleport_to_ai_point (player0, ps_insertion_rally.p0);
	object_teleport_to_ai_point (player1, ps_insertion_rally.p1);
	object_teleport_to_ai_point (player2, ps_insertion_rally.p2);
	object_teleport_to_ai_point (player3, ps_insertion_rally.p3);

	print (":  : TELEPORTED :  :");

	f_insertion_playerprofile( rally_profile, FALSE );
	
	wake (f_rally_main);
	
	wake (m60_on_pelican_vo);
	
end

// =================================================================================================
// =================================================================================================
// INFINITY BERTH
// =================================================================================================
// =================================================================================================

script dormant inf_berth()
	zone_set_trigger_volume_enable("zone_set:infinity_berth_infinity_causeway:*", FALSE);
	zone_set_trigger_volume_enable("begin_zone_set:infinity_berth_infinity_causeway:*", FALSE);
	zone_set_trigger_volume_enable("zone_set:infinity_airlock:*", FALSE);
	data_mine_set_mission_segment("m60_infinty_causeway");
	garbage_collect_now();
	game_save_no_timeout();
	ai_lod_full_detail_actors (30);
	
	sleep_until (current_zone_set_fully_active() == zs_infinity_berth, 1);
	
	// Ensure we immediately load the mech airlock when able.
	wake(inf_berth_load_airlock);
	
	ai_vehicle_reserve (veh_demo, TRUE);
	ai_vehicle_reserve (ve_rally_scorpion, TRUE);
	ai_vehicle_reserve (berth_goose_1, TRUE);
	ai_vehicle_reserve (berth_goose_2, TRUE);
		
	ai_place (inf_berth);
	print (":  : Berth Squad Placed :  :");
	
	ai_set_objective (sq_hum_rally_infantry, obj_inf_berth_hum);
	ai_set_objective (sq_hum_rally_warthog_1, obj_inf_berth_hum);
	
	//thread (inf_berth_string());
	//thread (inf_door_1());
	//thread (inf_door_2());
	//thread (inf_door_3());
	//thread (inf_door_4());
	
	effect_attached_to_camera_stop ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );

	//render_atmosphere_fog (FALSE);

	obj_state = 1;
	print (" :  : Player is inside Berth :  :");
	game_save_no_timeout();
	print (":  : Infinity Berth :  :");
	
	sleep (30 * 4);
	
	ai_vehicle_reserve (veh_demo, FALSE);
	ai_vehicle_reserve (ve_rally_scorpion, FALSE);
	
	sleep_until
	
		(ai_living_count (inf_berth_cov) < 1);
	
	garbage_collect_now();
	
	game_save();
	
	thread (f_m60_music_nothing()); // end tank music
	
	sleep (30 * 3);
	
	thread (inf_berth_string());
	
	// Encounter 6 Music End
	
	thread (f_mus_m60_e06_finish());
	
//	sleep_until(dialog_id_played_check(l_dlg_m60_infinityberth_tocauseway), 1);
	
	//wake (Infinityberth_tocauseway);
	
	thread (inifinityberth_tocauseway());

	sleep (30 * 16);

	infinity_airlock_door_entry->open_default();
	
	f_blip_flag (flag_airlock, "recon");
	
	wake (inf_cause);
	
	object_cannot_take_damage (inf_inner_door_temp);
	
end

script dormant inf_berth_load_airlock()
	sleep_until(current_zone_set() == zs_inf_airlock and not PreparingToSwitchZoneSet(), 1);
	zone_set_trigger_volume_enable("zone_set:infinity_airlock:*", TRUE);
end

script static void inf_berth_string()
	
	cui_hud_set_objective_complete (obj_complete);
//	f_blip_object (infinity_airlock_door, "recon");
	sleep (30 * 3);
	
end

script static void mech_reveal
	thread (mech_fx_wait());
	music_set_state('Play_mus_m60_v07_mech_reveal');
	ai_erase_all();
	object_create(mech_platform);
	object_create(mechsuit_1);
	objects_attach(mech_platform,mech,mechsuit_1,"");
	device_animate_position(mech_platform,0,0,0,0,false);
	device_set_position_track(mech_platform,"vin:m60:reveal:platform",0);
	device_animate_position(mech_platform,1,12,0,0,false);
	SetObjectRealVariable(mechsuit_1,VAR_OBJ_LOCAL_A,0.0001);
	sleep(15);
	objects_detach(mech_platform,mechsuit_1);
	sleep(345);
	SetObjectRealVariable(mechsuit_1,VAR_OBJ_LOCAL_A,1);
	sleep(45);
	dprint("Mech hatch opening effects.");
	effect_new_on_object_marker(environments\solo\m60_rescue\fx\steam\steam_quick_burst_mech_opening.effect, mechsuit_1, top_hatch);
	sleep(55);
	SetObjectRealVariable(mechsuit_1,VAR_OBJ_LOCAL_A,0);
	unit_set_enterable_by_player (mechsuit_1, TRUE);
//	damage_new ("globals\damage_effects\phys_impulse_damage_effect.damage_effect", mech_door_boom_2);
end

script command_script sc_mech_reveal
      repeat
            cs_aim_object(true,invisible_crate);
      until (device_get_position(mech_platform)== 1, 1);
end

script static void mech_fx_wait()

	sleep (46);
	thread (mech_reveal_effects());
	sleep (120);
	damage_new ("globals\damage_effects\phys_impulse_damage_effect.damage_effect", mech_door_boom);
	
end

// =================================================================================================
// =================================================================================================
// UTILITY CAUSEWAY
// =================================================================================================
// =================================================================================================

//Mech Damage (Temp)

 script dormant damage_watcher_mech1()
 
 	repeat
 
	if (unit_get_shield (mechsuit_1) <= 0.5) then
  if (mech1_smoke_on == FALSE) then
  effect_new_on_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect", mechsuit_1, "package");                              
  mech1_smoke_on = TRUE;
  end
  else
  effect_stop_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect", mechsuit_1, "package");
  mech1_smoke_on = FALSE;
  end
                                
  if (unit_get_shield (mechsuit_1) <= 0.25) then
  	if (mech1_fire_on == FALSE) then
  	effect_new_on_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire.effect", mechsuit_1, "package");                                       
  	mech1_fire_on = TRUE;
  end
  else
  	effect_stop_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire.effect", mechsuit_1, "package");                           
		mech1_fire_on = FALSE;
  end
  until( 1 == 0, 1 );
 end
 
 script dormant damage_watcher_mech2()
 
 repeat
 
	if (unit_get_shield (mechsuit_2) <= 0.5) then
  if (mech2_smoke_on == FALSE) then
  effect_new_on_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect", mechsuit_2, "package");                              
  mech2_smoke_on = TRUE;
  end
  else
  effect_stop_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect", mechsuit_2, "package");
  mech2_smoke_on = FALSE;
  end
                                
  if (unit_get_shield (mechsuit_2) <= 0.25) then
  	if (mech2_fire_on == FALSE) then
  	effect_new_on_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire.effect", mechsuit_2, "package");                                       
  	mech2_fire_on = TRUE;
  end
  else
  	effect_stop_object_marker ("fx\library\fire\fire_and_smoke_mech\firesmoke_fire.effect", mechsuit_2, "package");                           
		mech2_fire_on = FALSE;
  end
  until( 1 == 0, 1 );                           
end

script dormant inf_cause

	objectives_finish (3);
	
	objectives_show (4);

	if
		(ai_living_count (sq_marine_inf_berth_l) == 2)
	AND
		(ai_living_count (sq_marine_inf_berth_r) == 2)
	THEN
		print (":  : Berth Marines Alive :  :");
		m60_achievement_berth = true;
	ELSE
		print (":  : Berth Marines Dead! You Monster! :  :");
	end

		if
			m60_achievement_berth			== true
		AND
			m60_achievement_rally			== true
		AND
			m60_achievement_boulders	== true
		AND
			game_difficulty_get_real() >= heroic
		then
		print (":  : Achievement Get! :  :");
		m60_achievement_complete = true;
		submit_incident_with_cause_player ("m60_special", player0);
		submit_incident_with_cause_player ("m60_special", player1);
		submit_incident_with_cause_player ("m60_special", player2);
		submit_incident_with_cause_player ("m60_special", player3);
		
	else
		print (":  : You didn't save the Marines, or your difficulty is too low. :  :");
	end
	
	sleep (5);
	
	if
		m60_achievement_complete == true
	then
		print (":  : You got the M60 achievement! You did it! You're so great I can't believe it! :  :");
	else
		print (":  : You suck! Try harder and get the damn achievement, jerk! What are you, some kind of bum? :  :");
	end
	
// Mech Raise

	object_cannot_take_damage (inf_inner_door_temp);

	sleep_until (volume_test_players (trig_inf_cause), 1);
	//f_unblip_object (berth_door_1);

	f_unblip_flag (flag_airlock);

	if
		player_valid (player1)
	then
		volume_teleport_players_not_inside_with_vehicles (trig_airlock_teleport, flag_airlock_teleport);
	else
		print (":  : Flying Solo :  :");
	end

	// Close door and begin streaming as soon as it's fully closed.
	infinity_airlock_door_entry->close_fast();	
	sleep_until(infinity_airlock_door_entry->check_close(),1);
	zone_set_trigger_volume_enable("begin_zone_set:infinity_berth_infinity_causeway:*", TRUE);

	//wake (damage_watcher_mech2);
	
	sleep (30 * 4);
	
	object_create (mech_switch);
	
	f_blip_object (mech_switch, "activate");
	
	ai_erase_all();
	
	sleep_until (device_get_position (mech_switch) != 0);
	
	pup_play_show (mech_lift_button);
	
	f_unblip_object (mech_switch);
	
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	
	zone_set_trigger_volume_enable ("zone_set:infinity_berth_infinity_causeway:*", TRUE);
	
	//switch_zone_set (infinity_berth_infinity_causeway);

	//sleep_until (current_zone_set_fully_active() == zs_inf_airlock, 1);

	object_cannot_take_damage (inf_inner_door_temp);

	sleep (30);

	thread (mech_reveal());

	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (mechletterbox);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);     
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
	
	print (" :  : Here comes mech suits :  : ");
	
	//wake (damage_watcher_mech1);
	
	print (":  : Infinity Causeway :  :");
	
	sleep_until (vehicle_test_seat (mechsuit_1, mantis_d) == 1);
	thread (inifinitycauseway_broadswordassault());
	
	// Encounter 7 Music Start
	
	thread (f_mus_m60_e07_begin());

	game_save();
	
	sleep (30 * 1);

	thread (doorraise());
	print (" :  : In the vehicle :  : ");
	
	if
	
		game_difficulty_get() <= normal
	
		AND
		
		game_coop_player_count() == 1
	
	then
	
		wake (training_mech_1);
	
	else
	
		print (":  : Too cool for tutorials :  :");
	
	end
	
	sleep (30 * 3);

	wake (cause_1);
	
end

script static void door_destroy_blip()

	sleep (30 * 120);
	if
		object_get_health (inf_inner_door_temp) > 0
	then
		f_blip_flag (flag_destroy_door, "neutralize");
	end

	sleep_until (object_get_health (inf_inner_door_temp) == 0);
	
	f_unblip_flag (flag_destroy_door);
	
end	


// =================================================================================================
// =================================================================================================
// UTILITY CAUSEWAY 1
// =================================================================================================
// =================================================================================================

script dormant cause_1

	sleep_until (object_get_health (inf_inner_door_temp) < 1);

	object_create_folder (cause_1);

	if
		player_valid (player1)
	then
		thread (infinity_airlock_door_tall_right->open_default());
		thread (infinity_airlock_door_tall_left->open_default());
	else
		print (":  : SP so no door opening for you :  :");
	end

	ai_flee_target (sq_inf_cause_1, player0);
	ai_flee_target (sq_inf_cause_1, player1);
	ai_flee_target (sq_inf_cause_1, player2);
	ai_flee_target (sq_inf_cause_1, player3);

	sleep_until (volume_test_players (cause_objcon_1), 1);
	ai_place_in_limbo (sq_inf_cause_3);
	
	wake (cause_2);
	
end	

//	object_wake_physics (ai_vehicle_get_from_spawn_point (sq_inf_cause_t_1.t2));

script dormant cause_2

	wake (damage_cause_1_r);
	wake (damage_cause_2_r);
	
	sleep_until (volume_test_players (trig_cause_spawn), 1);
	garbage_collect_now();
	sleep (60);
	ai_place (cause_2);
	obj_state = 1;
	thread (didact_fx());

	wake (cause_3);
	
end

//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_cause_fore_ramp_t2)), FALSE);


// =================================================================================================
// =================================================================================================
// UTILITY CAUSEWAY 2
// =================================================================================================
// =================================================================================================

script dormant cause_3

	sleep_until (volume_test_players (trig_cause_spawn_2), 1);
	
	object_create_folder (cause_2);
	
	if
		ai_living_count (cause_1) >= 7
	then
		ai_kill (cause_1);
	end
	
	garbage_collect_now();
	game_save();

	sleep (60);
	print (":  : Placing cause_3 :  :");

	obj_state = 2;
	ai_place (cause_3);

	ai_place_in_limbo (sq_inf_cause_c_1);
	print (":  : Placing cause_2 Knight :  :");

//	sleep_until (volume_test_players (cause_objcon_6), 1);

	print (":  : CAUSE 2 SPAWN :  :");

	ai_flee_target (sq_inf_cause_c_1, player0);
	ai_flee_target (sq_inf_cause_c_1, player1);
	ai_flee_target (sq_inf_cause_c_1, player2);
	ai_flee_target (sq_inf_cause_c_1, player3);

	thread (inifinitycauseway_broadswordassault_end());

	print (":  : Placing Bridge Knights :  :");

	ai_place_in_limbo (sq_inf_cause_c_3);
	ai_place (sq_inf_cause_c_4);

	sleep (30 * 3);

	wake (cause_4);
	
end

// =================================================================================================
// =================================================================================================
// UTILITY CAUSEWAY 3
// =================================================================================================
// =================================================================================================

script dormant cause_4

	sleep_until (volume_test_players (trig_cause_spawn_3), 1);

	print (":  : CAUSE 3 SPAWN :  :");

	if
		ai_living_count (cause_1) >= 1
	then
		ai_kill (cause_1);
	end

	if
		ai_living_count (cause_2) >= 10
	then
		ai_kill (cause_2);
	end

	garbage_collect_now();
	
	sleep_until (volume_test_players (trig_cause_spawn_4), 1);
	
	print (":  : CAUSE 4 SPAWN :  :");
	
	ai_place_in_limbo (sq_inf_cause_c_6);
	ai_place (sq_inf_cause_c_7);

	obj_state = 3;

	sleep (60);
	ai_place (cause_4);

	sleep_until (volume_test_players (trig_cause_spawn_5), 1);

	if
		ai_living_count (cause_2) >= 1
	then
		ai_erase (cause_2);
	end

	if
		ai_living_count (cause_3) >= 5
	then
		ai_erase (cause_3);
	end

	ai_place_in_limbo (sq_inf_cause_d_2);

	sleep_until (volume_test_players (trig_cause_spawn_6), 1);

	ai_place (sq_inf_cause_d_3);
	ai_place (sq_inf_cause_d_4);

	sleep_until (volume_test_players (trig_cause_spawn_7)
	
	OR
	
	ai_living_count (sg_cause_end) < 3);

	sleep_until (current_zone_set_fully_active() == zs_infinity_ele, 1);

	ai_place (inf_cause_gr_kami);
	sleep (60);

	ai_grunt_kamikaze (inf_cause_gr_kami);

	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_open', infinity_elevator_door_entry, 1 ); //AUDIO!
	infinity_elevator_door_entry->open_fast();

	wake (teleport_elevator);

end

// =================================================================================================
// =================================================================================================
// CAUSEWAY THREADS
// =================================================================================================
// =================================================================================================

script static void mechraise1()
		object_move_by_offset (mechsuit_1, 10, 0, 0, 2);
end

script static void mechraise2()
		object_move_by_offset (mechsuit_2, 10, 0, 0, 2);
end

script static void doorraise()
	object_can_take_damage (inf_inner_door_temp);
	sleep_until (object_get_health (inf_inner_door_temp) < 1);
	ai_place (cause_1);
	print (":  : Door destroyed :  :");
	f_unblip_flag (flag_destroy_door);
	//object_move_by_offset (inf_inner_door_temp, 6, 0, 0, 3);
end

script static void didact_fx
	sleep_until (volume_test_players (trig_didact_fx), 1);
	print (":  : Didact Scan :  :");
	effect_new (environments\solo\m60_rescue\fx\scans\didact_scan_infinity_cw.effect, fx_didact_scan); 
end

script static void causeobj

	//f_blip_flag (flag_destroy_door, "destroy");	
	
	cui_hud_set_new_objective (chtitleinfcause);

end

script dormant training_mech_1

	thread (door_destroy_blip());

	sleep (30 * 3);

	sleep_until (vehicle_test_seat (mechsuit_1, mantis_d) == 1);

	sleep (30 * 3);

	chud_show_screen_training (player0, mech_training_primary_fire);

	player_action_test_reset();
	
	sleep_until (player_action_test_primary_trigger()
	
			OR
			
			vehicle_test_seat (mechsuit_1, mantis_d) == 0);
			
	chud_show_screen_training (player0, "");

	sleep (30 * 3);
	
	mech_fire_training = 1;
	
	wake (training_mech_2);
	
end

script dormant training_mech_2

	sleep_until (mech_fire_training == 1);

	if
		vehicle_test_seat (mechsuit_1, mantis_d) == 1
	then
	
	sleep_until (vehicle_test_seat (mechsuit_1, mantis_d) == 1);
	
	sleep (30 * 2);
	
	chud_show_screen_training (player0, mech_training_secondary_fire);
	
	sleep_until (player_action_test_grenade_trigger()
			OR
			vehicle_test_seat (mechsuit_1, mantis_d) == 0);
			
	player_action_test_reset();
	sleep (30 * 3);		
	chud_show_screen_training (player0, "");
	
	else
	
		print (" :  : Player not in Mantis :  :");

	end
	
	sleep (30 * 3);
	
	mech_fire_training = 2;
	
	wake (training_mech_3);
		
end

script dormant training_mech_3

	sleep_until (mech_fire_training == 2);

	if
		vehicle_test_seat (mechsuit_1, mantis_d) == 1
	then
	
	sleep_until (vehicle_test_seat (mechsuit_1, mantis_d) == 1);
	
	chud_show_screen_training (player0, mech_training_secondary_chamber);
	
	sleep_until (
			player_action_test_grenade_trigger()
		OR
			vehicle_test_seat (mechsuit_1, mantis_d) == 0);
	
	player_action_test_reset();
	sleep (30 * 3);		
	chud_show_screen_training (player0, "");
	
	sleep (30 * 4);
	
	player_action_test_reset();
	sleep (5);

	else
	
		print (" :  : Player not in Mantis :  :");

	end

	mech_fire_training = 3;

	wake (melee_training);

end

script dormant melee_training

	sleep_until (mech_fire_training == 3);

	if
		vehicle_test_seat (mechsuit_1, mantis_d) == 1
	then
	
	sleep_until (vehicle_test_seat (mechsuit_1, mantis_d) == 1);
	
chud_show_screen_training (player0, mech_training_melee);
	
	sleep_until (
				player_action_test_melee()
		OR
				vehicle_test_seat (mechsuit_1, mantis_d) == 0);
	
	player_action_test_reset();
	sleep (30 * 3);		
	chud_show_screen_training (player0, "");

	end

end

script command_script cause_phase_1
	sleep_until (volume_test_players (cause_objcon_1), 1);
	cs_phase_to_point (cause_phase.p0);
end

script command_script cause_phase_2
	sleep_until (volume_test_players (cause_objcon_4), 1);
	sleep (random_range (10, 60));
	cs_phase_to_point (cause_phase.p1);
end

script command_script cause_phase_3
	sleep_until (volume_test_players (cause_objcon_4), 1);
	sleep (random_range (10, 60));
	cs_phase_to_point (cause_phase.p2);
end

script command_script cause_phase_4
	sleep_until (volume_test_players (cause_objcon_4), 1);
	sleep (random_range (10, 60));
	cs_phase_to_point (cause_phase.p3);
end

script command_script cause_phase_6
	sleep_until (volume_test_players (cause_objcon_4), 1);
	sleep (random_range (10, 60));
	cs_phase_to_point (cause_phase.p5);
end

script command_script dumb_turret_1
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_inf_cause_t_1.t3));
	ai_braindead (ai_current_actor, TRUE);
	sleep_until (volume_test_players (trig_cause_spawn_2)
		OR
	ai_living_count (sq_inf_cause_t_1.t2) < 1);
	ai_braindead (ai_current_actor, FALSE);
end

script command_script dumb_turret_2
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get_from_spawn_point (sq_inf_cause_c_t_2.t1));
	ai_braindead (ai_current_actor, TRUE);
	sleep_until (volume_test_players (trig_cause_spawn_3), 1);
	ai_braindead (ai_current_actor, FALSE);
end

//CAUSEWAY TURRETS
script command_script cause_t_1
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_t_1.t1));
end

script command_script cause_t_2
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_t_1.t2));
end

script command_script cause_t_3
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_c_t_2.t1));
end

script command_script cause_t_4
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get(sq_inf_cause_c_t_2.t2));
end

script command_script cause_t_5
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_c_t_2.t3));
end

script command_script cause_t_7
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_tur_2.t1));
end

script command_script cause_t_8
	sleep (5);
	AutomatedTurretActivate(ai_vehicle_get (sq_inf_cause_tur_2.t2));
end

script dormant damage_cause_1_r()

	sleep_until (object_get_health (cause_bridge_1_r) == 0);
	print (":  : Bridge 1-R destroyed :  :");
	damage_new ("objects\weapons\support_high\storm_rocket_launcher\projectiles\damage_effects\storm_rocket_launcher_rocket_explosion.damage_effect", cause_1_r);
	
end

script dormant damage_cause_2_r()

	sleep_until (object_get_health (cause_bridge_2_r) == 0);
	print (":  : Bridge 2-R destroyed :  :");
	damage_new ("objects\weapons\support_high\storm_rocket_launcher\projectiles\damage_effects\storm_rocket_launcher_rocket_explosion.damage_effect", cause_2_r);
	
end

// =================================================================================================
// =================================================================================================
// FACILITIES
// =================================================================================================
// =================================================================================================



// =================================================================================================
// =================================================================================================
// FACILITIES ELEVATOR
// =================================================================================================
// =================================================================================================

// Fake the elevator ride
script dormant teleport_elevator
	
	zone_set_trigger_volume_enable ("zone_set:infinity_outer_deck:*", FALSE);
	zone_set_trigger_volume_enable ("begin_zone_set:infinity_outer_deck", FALSE);
	
	//object_set_physics (temp_elevator, FALSE);
	sleep_until (volume_test_players (trigger_teleport), 1);
	
	// Encounter 7 Music End
	
	thread (f_mus_m60_e07_finish());
	
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_close', infinity_elevator_door_entry, 1 ); //AUDIO!
	infinity_elevator_door_entry->close_fast();
	
	sleep (30 * 4);

	volume_teleport_players_not_inside_with_vehicles (trigger_teleport, flag_teleport_elevator_2);
	
	thread (inifinitycauseway_defendthedeck());
	
	//thread (temp_ele());
	
	//device_set_position_track (infinity_elevator, "any:lift", 30);
	thread (infinity_elevator->f_animate());

	dprint ("elevator gooooo");
	
	garbage_collect_now();
	ai_erase_all();

	thread (f_m60_music_nothing()); // fade out mech music
	sleep (30 * 1); // give fade out some time before vo plays
	
	sleep (30 * 15);

	wake (outer_deck);

	sleep_until (volume_test_players (trig_elevator_top), 1);
	
	sleep (30);
	
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_open', infinity_elevator_door_exit, 1 ); //AUDIO!
	thread (infinity_elevator_door_exit->open_default());
	
	thread (elevatorobj());

end

script static void deckobj1

	cui_hud_set_new_objective (chtitleinfdeck1);

end

script static void elevatorobj

	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (deckletterbox);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);     
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);

end

script static void cryptum_delete()

		sleep_until (object_valid (intro_cryptum) == TRUE);
	
		object_destroy (intro_cryptum);
	
		sleep (5);
		
	end
	
// =================================================================================================
// =================================================================================================
// INFINITY OUTER DECK
// =================================================================================================
// =================================================================================================

script dormant outer_deck
	data_mine_set_mission_segment("m60_infinity_deck");
	//ai_lod_full_detail_actors (50);
	game_save_no_timeout();
	flock_create ("flocks_outer_deck_banshee");
	flock_create ("flocks_outer_deck_pelican");
	flock_create ("flocks_outer_deck_phantom");
	sleep (30);
	
	thread (cryptum_delete());
	
	object_create_folder (deck_ships);
	object_create_folder (deck_guns);	
	
	sleep (5);
	
		if
				game_difficulty_get_real() <= normal
		then
				object_create (backup_mech_1);
				object_create (backup_mech_2);
		else
				print (":  : Heroic or Legendary :  :");				
		end
	
	thread (amb_move_group());
	object_cinematic_visibility (cruiser_deck, TRUE);
	object_cinematic_visibility (deck_cruiser_1, TRUE);
	object_cinematic_visibility (deck_cruiser_2, TRUE);
	object_cinematic_visibility (deck_cruiser_3, TRUE);
	object_cinematic_visibility (deck_cruiser_4, TRUE);
	object_cinematic_visibility (deck_cruiser_5, TRUE);
	object_cinematic_visibility (deck_cruiser_6, TRUE);
	object_cinematic_visibility (deck_cruiser_7, TRUE);
	object_cinematic_visibility (deck_cruiser_8, TRUE);
	obj_state = 0;
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_flak_deck.t1)), FALSE);
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_flak_deck.t2)), FALSE);
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_flak_deck.t3)), FALSE);
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_flak_deck.t4)), FALSE);
	ai_place (sq_aa_gun_1);
	ai_place (sq_aa_gun_2);
	ai_place (sq_aa_gun_3);
	unit_enter_vehicle_immediate ((ai_get_unit(sq_aa_gun_1.g1)), deck_gun_r, turret_seat);
	unit_enter_vehicle_immediate ((ai_get_unit(sq_aa_gun_1.g2)), deck_gun_m, turret_seat);
	unit_enter_vehicle_immediate ((ai_get_unit(sq_aa_gun_1.g3)), deck_gun_l, turret_seat);
	unit_enter_vehicle_immediate ((ai_get_unit(sq_aa_gun_3.g1)), deck_gun_mac, mac_d);
	object_set_physics (deck_gun_r, FALSE);
	object_set_physics (deck_gun_l, FALSE);
	object_set_physics (deck_gun_m, FALSE);
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g1)), FALSE);
	//object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g2)), FALSE);
	ai_place (sq_deck_vig_1);
	ai_place (sq_deck_vig_2);
	ai_disregard (ai_actors (sq_flak_deck), TRUE);
	ai_disregard (ai_actors (sq_aa_gun_1), TRUE);
	ai_disregard (ai_actors (sq_aa_gun_3), TRUE);
	ai_disregard (ai_actors (sg_deck_init), TRUE);
	ai_braindead (sq_aa_gun_1, TRUE);
	object_set_scale (deck_gun_l, 1.5, 0);
	object_set_scale (deck_gun_m, 1.5, 0);
	object_set_scale (deck_gun_r, 1.5, 0);
//	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_1.g1)), 1.5, 0);
//	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_1.g2)), 1.5, 0);
//	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_1.g3)), 1.5, 0);
//	object_set_physics (deck_gun_l, FALSE);
//	object_set_physics (deck_gun_m, FALSE);
//	object_set_physics (deck_gun_r, FALSE);
	ai_cannot_die (sq_aa_gun_1, TRUE);
	ai_cannot_die (sq_aa_gun_2, TRUE);
	ai_cannot_die (sq_aa_gun_3, TRUE);
	object_cannot_die (deck_gun_l, TRUE);
	object_cannot_die (deck_gun_m, TRUE);
	object_cannot_die (deck_gun_r, TRUE);
	object_cannot_die ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g1)), TRUE);
	object_cannot_die ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g2)), TRUE);
	object_cannot_die (deck_gun_mac, TRUE);
	ai_disregard (ai_actors (sq_aa_gun_2.g2), TRUE);
	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g2)), 3, 0);
	ai_disregard (ai_actors (sq_aa_gun_2.g1), TRUE);
	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g1)), 3, 0);
//	object_set_scale ((ai_vehicle_get_from_spawn_point (sq_aa_gun_3.g1)), 3, 0);
	object_set_scale (deck_gun_mac, 3, 0);
	sleep_until (volume_test_players (outer_door_trigger), 1);

	zone_set_trigger_volume_enable ("begin_zone_set:infinity_outer_deck", TRUE);

	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_close', infinity_elevator_door_exit, 1 ); //AUDIO!
	infinity_elevator_door_exit->close_fast();
	
	zone_set_trigger_volume_enable ("zone_set:infinity_outer_deck:*", TRUE);

//	switch_zone_set ("infinity_outer_deck");
	object_destroy (intro_cryptum);
	sleep (5);
	object_create (cruiser_deck);
	effect_new_on_object_marker_loop (	"environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_ambient.effect", cruiser_deck, fx_ambient);
	ai_place (deck_1);

	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_open', outer_deck_door_entry, 1 ); //AUDIO!
	outer_deck_door_entry->open_slow();

	thread (f_m60_music_deck());

	sleep_until (volume_test_players (trig_deck_vig), 1);
	
	//effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );
	
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_close', infinity_elevator_door_exit, 1 ); //AUDIO!
	infinity_elevator_door_exit->close_slow();
	
	// Encounter 8 Music Start
	
	thread (deck_door_close());
	
	//effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_scan.effect", cruiser_deck, fx_new_scan_A);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);
	
	g_pup_cryptum_show = pup_play_show(cryptum_fight);
	
	thread (f_mus_m60_e08_begin());
	
	wake (infinityouterdeck_start);
	thread (deckobj1());
	sleep (30 * 3);
	//ai_place (sq_deck_vig_banshee);
	
	//ai_disregard (ai_actors(sq_deck_drop_1_a), TRUE);
	//ai_disregard (ai_actors(sq_deck_drop_1_b), TRUE);
	
	game_save_no_timeout();
	
	//WAVE ONE
	
	thread (gunraise_1_1());
	thread (gunraise_1_2());
	thread (gunraise_1_3());
	
	sleep_until (deck_gun_count == 1);
	
	wake (m60_infinityouterdeck_first_jammer);
	
	sleep (30 * 2);
	
	wake (banshee_deck_flood);
	
	wake (f_dialog_m60_callout_banshees);
	
	if deck_gun_1_pos == 1
	then
		ai_place (sq_deck_phantom_r_2);
	else
		ai_place (sq_deck_phantom_l_2);
	end
	
	// Phantom Deck Count == 1
	
	sleep_until (deck_gun_count == 2);
	
	wake (m60_infinityouterdeck_second_jammer);
	
	sleep_until (deck_gun_count == 3);
	
	wake (m60_infinityouterdeck_third_jammer);
	
	sleep (30 * 5);
	
	//wake (m60_infinityouterdeck_first_gun_online);
	
	thread (chtitledeck2());
	
	wake (deck_wave_2);
	
end

	//GUNS RAISE
	
	//WAVE TWO
	
script dormant deck_wave_2

//	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_scan.effect", cruiser_deck, fx_new_scan_A);

	g_cryptum_state = 1;
	
	obj_state = 1;
	
		if
			(volume_test_players (trig_drop_l))
		then
			ai_place (sq_deck_phantom_r);
			print (":  : Placing Right Phantom :  :");
			phantom_deck_r_b = TRUE;
		elseif
			(volume_test_players (trig_drop_r))
		then
			ai_place (sq_deck_phantom_l);
			print (":  : Placing Left Phantom :  :");
			phantom_deck_l_b = TRUE;
		end

//Phantom Deck Count == 2

sleep (30 * 10);
	
		if
			(phantom_deck_r_b == TRUE)
		then
			ai_place (sq_deck_phantom_l);
			print (":  : Placing Left Phantom - 2 :  :");
	//		sleep (30 * 15);
	//		ai_place (sq_deck_phantom_back_mid);
	//		print (":  : Back Mid - 2 :  :");
			phantom_deck_l_b = TRUE;
		elseif
			(phantom_deck_l_b == TRUE)
		then
			ai_place (sq_deck_phantom_r);
			print (":  : Placing Right Phantom - 2 :  :");
	//		sleep (30 * 15);
	//		ai_place (sq_deck_phantom_back_mid);
	//		print (":  : Back Mid - 2 :  :");
			phantom_deck_r_b = TRUE;
		end

//Phantom Deck Count == 3

	wake (banshee_deck_flood_2);
	
	wake (deck_wave_3);
	
	game_save_no_timeout();

end

	//WAVE THREE
	
script dormant deck_wave_3

	sleep_until (deck_phantom_count == 3
	
		OR
							
							ai_living_count (sg_phantom) < 2);

	print (":  : Wave 3 :  :");

//	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_scan.effect", cruiser_deck, fx_new_scan_A);

	g_cryptum_state = 2;

	wake (m60_infinityouterdeck_guns_begin);

	if
		(volume_test_players (trig_deck_u_l))
		then
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_r_2);
			print (":  : Phantom Lower Right :  :");
			thread (missile_l());
		//	wake (m60_infinityouterdeck_second_gun_online);
//			ai_place (sq_deck_phantom_l);
//			print (":  : Phantom Upper Left :  :");
		elseif
			(volume_test_players (trig_deck_u_r))
		then
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_l_2);
			print (":  : Phantom Lower Left :  :");
			thread (missile_l());
		//	wake (m60_infinityouterdeck_second_gun_online);
//			ai_place (sq_deck_phantom_r);
//			print (":  : Phantom Upper Right :  :");
		elseif
			(volume_test_players (trig_deck_l_l))
		then
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_l);
			print (":  : Phantom Upper Right :  :");
			thread (missile_l());
//			wake (m60_infinityouterdeck_second_gun_online);
//			ai_place (sq_deck_phantom_r_2);
//			print (":  : Phantom Lower Left :  :");
		elseif
			(volume_test_players (trig_deck_l_r))
		then
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_r);
			print (":  : Phantom Upper Left :  :");
			thread (missile_l());
//			wake (m60_infinityouterdeck_second_gun_online);
//			ai_place (sq_deck_phantom_l_2);
//			print (":  : Phantom Lower Right :  :");
	end
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);
	
	sleep_until (ai_living_count (sg_phantom) < 2
	
							AND
							
							ai_living_count (sg_deck_drop) < 3);

	wake (f_dialog_m60_callout_hold_them_off);
	print (":  : Cortana : Hold them off! :  :");
	
	wake (f_dialog_m60_callout_more_time);
	print (":  : Cortana : Just a few more minutes! :  :");

	if
		(volume_test_players (trig_deck_u_l))
		then
			ai_place (sq_deck_phantom_r_2);
			print (":  : Phantom Lower Right :  :");
			thread (missile_r());
			sleep (30 * 4);
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_r);
			print (":  : Phantom Upper Right :  :");
		elseif
			(volume_test_players (trig_deck_u_r))
		then
			ai_place (sq_deck_phantom_l_2);
			print (":  : Phantom Lower Right :  :");
			thread (missile_r());
			sleep (30 * 4);
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_r_2);
			print (":  : Phantom Lower Left :  :");
		elseif
			(volume_test_players (trig_deck_l_l))
		then
			ai_place (sq_deck_phantom_l);
			print (":  : Phantom Upper Right :  :");
			sleep (30 * 4);
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			thread (missile_r());
			ai_place (sq_deck_phantom_r);
			print (":  : Phantom Upper Left :  :");
		elseif
			(volume_test_players (trig_deck_l_r))
		then
			ai_place (sq_deck_phantom_r);
			print (":  : Phantom Upper Left :  :");
			thread (missile_r());
			sleep (30 * 4);
			sleep_until (ai_living_count (sg_deck_drop) < 3);
			ai_place (sq_deck_phantom_l);
			print (":  : Phantom Upper Right :  :");
	end

	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);

	//Phantom Deck Count == 6

	sleep_until (deck_gun_count >= 4);
	
	print (":  : Gun Count = 4 :  :");
	
	sleep_until (deck_gun_count == 5);

	sleep_until (ai_living_count (sg_phantom) < 1);

	sleep (30 * 5);
	
	deck_gun_count = (deck_gun_count + 1);
	
	//wake (m60_infinityouterdeck_final_wave);
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);
	
	print (":  : MAC active, Phantoms SHOULDN'T SPAWN ANYMORE :  : ");

	sleep_until (ai_living_count (sg_phantom) < 1);

	cui_hud_set_objective_complete (obj_complete);
	
	//effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cin_m60_cryptum_scan.effect", cruiser_deck, fx_new_scan_A);

	// Encounter 8 Music End
	
	thread (f_mus_m60_e08_finish());

	//sleep_until(dialog_id_played_check(l_dlg_infinityouterdeck_mac_ready), 1);

	//sleep (30 * 16);

	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);

	if
		ai_living_count (sg_deck_drop) > 1
	then
		wake (f_dialog_m60_still_seeing_targets);
		print (":  : Cortana : I'm still seeing targets. :  :");
		wake (f_dialog_m60_callout_finish_them_off);
		print (":  : Cortana : Finish them off. :  :");
	else
		print (":  : All dead, no prompt needed :  :");
	end
	
	sleep_until (ai_living_count (sg_deck_drop) < 1);

	wake (f_dialog_m60_callout_last_of_them);
	print (" :  : Cortana : That's the last of them. :  :");
	
	wake (f_dialog_m60_callout_how_its_done);
	print (" :  : Cortana : That’s how it’s done. :  :");
	
	sleep_forever (banshee_deck_flood_2);

	wake (m60_infinityouterdeck_firing_controls);

	thread (chtitledeck3());

	object_create (rg_c_1);
	
	sleep (30);

	f_blip_object (rg_c_1, "activate");
	sleep_until (device_get_position (rg_c_1) != 0);
	
	pup_play_show (mac_gun_button);

	f_unblip_object (rg_c_1);

	//thread (missile_l_down());
	//thread (missile_r_down());
	
	//sleep (30 * 6);
	
	//ai_place (amb_deck_flak);
	
	flock_destroy ("flocks_outer_deck_banshee");
	flock_destroy ("flocks_outer_deck_phantom");
	
	thread (inifinityouterdeck_gun2());

	sleep (30 * 6);

	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\didact\cryptum_scan_with_straight_edge.effect", cruiser_deck, fx_new_scan_A);

	wake (deck_wave_4);
	
end

script dormant deck_wave_4
	
	thread (deckobjcomplete());

	g_deck_gun=deck_gun_mac;
	
	g_cryptum_state = 3;
	
	sleep_until(not pup_is_playing(g_pup_cryptum_show),1);
	
	print (":  : Cryptum State = 3 :  :");
	
	pup_play_show(deck_fire);

	print (":  : Deck Show Playing :  :");

	thread (deck_gun_lower());

	thread (inifinityouterdeck_gun3());

	cs_run_command_script (sq_aa_gun_1.g1, cs_shoot_didact);
	cs_run_command_script (sq_aa_gun_1.g2, cs_shoot_didact);
	cs_run_command_script (sq_aa_gun_1.g3, cs_shoot_didact);
	cs_run_command_script (sq_aa_gun_2.g1, cs_shoot_didact);
	cs_run_command_script (sq_aa_gun_2.g2, cs_shoot_didact);
	
	objectives_finish (4);
	
	thread (deck_amb_crash_3());
	thread (deck_amb_crash_4());
	thread (deck_amb_crash_5());
	thread (deck_amb_crash_6());
	
	//cs_shoot (sq_aa_gun_2, TRUE, cruiser_deck);
	
end

// =================================================================================================
// =================================================================================================
// DECK THREADED SCRIPTS
// =================================================================================================
// =================================================================================================

script static void gunraise_1_1()

	print (":  : Waiting on AA_1 :  :");
	
	f_blip_object (comm_l, "neutralize");
	
	//sleep_until (device_get_position (aa_c_1) != 0);

	sleep_until (
		object_get_health (comm_l_1) == 0
		OR
		object_get_health (comm_l_2) == 0
		OR
		object_get_health (comm_l_3) == 0
		OR
		object_get_health (comm_l_4) == 0
		OR
		object_get_health (comm_l) == 0
							);

	sleep (30);

	deck_gun_count = (deck_gun_count + 1);
	
	deck_gun_1_pos = 1;

	f_unblip_object (comm_l);

	sleep (30);

	thread (plat_l());
	thread (gun_l());
	
	sleep (30 * 2);
	
	ai_braindead (sq_aa_gun_1.g3, FALSE);
	print ("GUN BARRELLS SPINNING!");

	ai_disregard (ai_actors(sq_deck_drop_1_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_1_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_b), TRUE);
	
//	ai_place (sq_deck_amb_a_left);
	
	sleep (30 * 3);
	
	wake (deck_flak_fx_l);
	
	thread (flak_gun_1_a());
	
	sleep (30 * 3);
	
	thread (flak_gun_1_b());
	
end

script static void gunraise_1_2()
	
	f_blip_object (comm_r, "neutralize");
	
	//sleep_until (device_get_position (aa_c_3) != 0);
	
		sleep_until (
		object_get_health (comm_r_1) == 0
		OR
		object_get_health (comm_r_2) == 0
		OR
		object_get_health (comm_r_3) == 0
		OR
		object_get_health (comm_r_4) == 0
		OR
		object_get_health (comm_r) == 0
							);
	
	sleep (30);
	
	deck_gun_count = (deck_gun_count + 1);
	
	sleep (30);
	
	f_unblip_object (comm_r);
	
	thread (plat_r());
	thread (gun_r());
	
	sleep (30 * 2);
	
	ai_braindead (sq_aa_gun_1.g1, FALSE);
	print ("GUN BARRELLS SPINNING!");

	ai_disregard (ai_actors(sq_deck_drop_1_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_1_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_b), TRUE);

//	ai_place (sq_deck_amb_a_right);
	
	sleep (30 * 3);
	
	wake (deck_flak_fx_r);
	
	thread (flak_gun_2_a());
	
	sleep (30 * 3);
	
	thread (flak_gun_2_b());
	
end

script static void gunraise_1_3()
	
	f_blip_object (comm_m, "neutralize");
	
	//sleep_until (device_get_position (aa_c_2) != 0);
	
		sleep_until (
		object_get_health (comm_m_1) == 0
		OR
		object_get_health (comm_m_2) == 0
		OR
		object_get_health (comm_m_3) == 0
		OR
		object_get_health (comm_m_4) == 0
		OR
		object_get_health (comm_m) == 0
							);
	
	sleep (30);
	
	deck_gun_count = (deck_gun_count + 1);
	
	sleep (30);
	
	f_unblip_object (comm_m);
	
	thread (plat_m());
	thread (gun_m());
	
	sleep (30 * 2);
	
	ai_braindead (sq_aa_gun_1.g2, FALSE);
	print ("GUN BARRELLS SPINNING!");

	ai_disregard (ai_actors(sq_deck_drop_1_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_1_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_b), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_b), TRUE);

//	ai_place (sq_deck_amb_a_mid);

	sleep (30 * 3);
	
	wake (deck_flak_fx_m);

	thread (flak_gun_3_a());
	
	sleep (30 * 3);
	
	thread (flak_gun_3_b());
	
	sleep (30);
	
	thread (flak_gun_3_c());


end

script static void deck_door_close()
	sleep_until (volume_test_players (trig_deck_exit), 1);
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_infinity_elevator_door_close', outer_deck_door_entry, 1 ); //AUDIO!
	outer_deck_door_entry->close_fast();
	
	if
		player_valid (player1)
	then
		volume_teleport_players_not_inside_with_vehicles (trig_deck_exit, flag_teleport_deck);
	else
		print (":  : Going Solo :  :");
	end
	
end

script static void missile_l
	
	ai_braindead (sq_aa_gun_2.g2, FALSE);
	print ("MISSILES!");

	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_battery_power_on', (ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g2)), 1 ); 

	deck_gun_2_pos = (deck_gun_2_pos + 1);
	
	deck_gun_count = (deck_gun_count + 1);
	
	sleep (30 * 3);
	
	ai_place (sq_aa_gun_amb_1);
	
end

script static void missile_r
	
	ai_braindead (sq_aa_gun_2.g1, FALSE);
	print ("MISSILES!");
	
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_battery_power_on', (ai_vehicle_get_from_spawn_point (sq_aa_gun_2.g1)), 1 ); 
	
	deck_gun_count = (deck_gun_count + 1);
	
	sleep (30 * 5);
	
	ai_place (sq_aa_gun_amb_2);
	
end

script dormant banshee_deck_flood
	repeat
			begin_random_count(2)
				
				begin
					sleep_until (ai_living_count (sg_banshee) < 1);
					print (":  : Banshee Flood R :  :");
					ai_place (sq_deck_ban_f_r);
					sleep_until (ai_living_count (sq_deck_ban_f_r) < 1);
					unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point(sq_deck_ban_f_r.p1), FALSE);
					sleep (random_range (150, 210));
				end
				
				begin
					sleep_until (ai_living_count (sg_banshee) < 1);
					ai_place (sq_deck_ban_f_l);
					print (":  : Banshee Flood L :  :");
					sleep_until (ai_living_count (sq_deck_ban_f_l) < 1);
					unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point(sq_deck_ban_f_l.p1), FALSE);
					sleep (random_range (150, 210));
				end
		end
					
	until (deck_gun_count == 3);
	
print (":  : Done! :  :");

end

script dormant banshee_deck_flood_2

	sleep_forever (banshee_deck_flood);

	sleep_until (ai_living_count (sg_banshee) < 1);

	ai_place (sq_deck_ban_f_l_2);
	ai_place (sq_deck_ban_f_r_2);

	repeat
			begin_random_count(2)
				
				begin
					sleep_until (deck_gun_count < 6);
					sleep_until (ai_living_count (sg_banshee) < 1);
					ai_place (sq_deck_ban_f_r_2);
					print (":  : Banshee Flood R - 2 :  :");
					unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point(sq_deck_ban_f_r_2.p1), FALSE);
					sleep (random_range (120, 240));
				end
				
				begin
					sleep_until (deck_gun_count < 6);
					sleep_until (ai_living_count (sg_banshee) < 1);
					ai_place (sq_deck_ban_f_l_2);
					print (":  : Banshee Flood L - 2 :  :");
					unit_set_enterable_by_player (ai_vehicle_get_from_spawn_point(sq_deck_ban_f_l_2.p1), FALSE);
					sleep (random_range (120, 240));
				end
		end
					
	until (deck_gun_count == 6);
	
print (":  : Banshee Flood Done! :  :");

end

script static void banshee_deck_flood_3
	repeat
			sleep_until (ai_living_count (sg_banshee) < 1);
			print (":  : Banshee Flood All :  :");
			ai_place (sq_deck_ban_f_r);
			sleep_until (ai_strength (sg_banshee) < .6);
			sleep (random_range (90, 120));
			print (":  : Banshee Flood All :  :");
			ai_place (sq_deck_ban_f_l);
			sleep_until (ai_strength (sg_banshee) < .4);
			sleep (random_range (30, 90));
			print (":  : Banshee Flood All :  :");
			ai_place (sq_deck_ban_r_mid);
	until (deck_gun_count == 6);
end

script dormant phantom_deck_flood

	repeat
	
		begin_random_count(3)
		
			begin
				sleep_until (deck_gun_count < 5);
				
				print (":  : Phantom Flood 1 :  :");

				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
				
				ai_place (sq_deck_phantom_fodder_l_1);
				
				sleep (30);
				
				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
										
				sleep (random_range (60, 120));
				
			end
			
			begin
				sleep_until (deck_gun_count < 5);
				
				print (":  : Phantom Flood 1 :  :");

				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
				
				ai_place (sq_deck_phantom_fodder_l_2);
				
				sleep (30);
				
				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
										
				sleep (random_range (60, 120));
			end
			
			begin
				sleep_until (deck_gun_count < 5);
				
				print (":  : Phantom Flood 1 :  :");

				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
				
				ai_place (sq_deck_phantom_fodder_l_3);
				
				sleep (30);
				
				sleep_until (ai_living_count (sg_phantom_fodder) < 1);
										
				sleep (random_range (60, 120));
			end
	
		end
	
	until (deck_gun_count == 6);

	print (":  : Phantom Flood 1 Done! :  :");
	
	sleep_forever (phantom_deck_flood);
	
end

script dormant phantom_deck_flood_2

	repeat
	
		begin_random_count(2)
		
			begin
				sleep_until (deck_gun_count < 6);
				print (":  : Phantom Flood 2 - 1 :  :");
				ai_place (sq_deck_phantom_r_2);
				sleep (30 * 10);
					if
						(ai_living_count (sq_deck_phantom_back_mid) < 1)
					then
						ai_place (sq_deck_phantom_back_mid);
						print (":  : Phantom Flood 2 - 1 :  :");
					else
						ai_place (sq_deck_phantom_l);
						print (":  : Phantom Flood 2 - 1 :  :");
					end
				sleep_until (ai_living_count (sg_phantom) < 2
				AND ai_living_count (sg_deck_drop) < 13);
				sleep (random_range (90, 120));
			end
			
			begin
				sleep_until (deck_gun_count < 6);
				print (":  : Phantom Flood 2 :  :");
				ai_place (sq_deck_phantom_l_2);
				sleep (30 * 10);
					if
						(ai_living_count (sq_deck_phantom_back_mid) < 1)
					then
						ai_place (sq_deck_phantom_back_mid);
						print (":  : Phantom Flood 2 - 2 :  :");
					else
						ai_place (sq_deck_phantom_r);
						print (":  : Phantom Flood 2 - 2 :  :");
					end
				sleep_until (ai_living_count (sg_phantom) < 2
				AND ai_living_count (sg_deck_drop) < 13);
				sleep (random_range (90, 120));
			end
			
		end
	
	until (deck_gun_count == 6);

	print (":  : Phantom Flood 2 Done! :  :");
	
	sleep_forever (phantom_deck_flood_2);
	
end

script static void plat_l()
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_gun_turret_small_platform_rise', gun_plat_l, 1 ); //AUDIO!
	object_move_by_offset (gun_plat_l, 3, 0, 0, 4);
end

script static void plat_m()
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_gun_turret_small_platform_rise', gun_plat_m, 1 ); //AUDIO!
	object_move_by_offset (gun_plat_m, 2, 0, 0, 2);
end

script static void plat_r()
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_gun_turret_small_platform_rise', gun_plat_r, 1 ); //AUDIO!
	object_move_by_offset (gun_plat_r, 3, 0, 0, 4);
end

script static void gun_l()
	object_move_by_offset (deck_gun_l, 3, 0, 0, 4);
end

script static void gun_r()
	object_move_by_offset (deck_gun_r, 3, 0, 0, 4);
end

script static void gun_m()
	object_move_by_offset (deck_gun_m, 2, 0, 0, 2);
end

script static void plat_l_lower()
	object_move_by_offset (gun_plat_l, 2, 0, 0, -4);
end

script static void plat_m_lower()
	object_move_by_offset (gun_plat_m, 2, 0, 0, -2);
end

script static void plat_r_lower()
	object_move_by_offset (gun_plat_r, 2, 0, 0, -4);
end

script static void gun_l_lower()
	object_move_by_offset (deck_gun_l, 2, 0, 0, -4);
end

script static void gun_r_lower()
	object_move_by_offset (deck_gun_r, 2, 0, 0, -4);
end

script static void gun_m_lower()
	object_move_by_offset (deck_gun_m, 2, 0, 0, -2);
end

script static void deck_gun_lower()
	thread (plat_l_lower());
	thread (plat_m_lower());
	thread (plat_r_lower());
	thread (gun_l_lower());
	thread (gun_r_lower());
	thread (gun_m_lower());
end

script static void mac_raise()

	sleep_until (ai_living_count (sg_phantom) < 1);

	//thread(mac_plat());
	thread(mac_gun());
//	thread(mac_door());
end

script static void mac_gun()
//	ai_place (sq_aa_gun_3);
//	object_move_by_offset ((ai_vehicle_get_from_spawn_point (sq_aa_gun_3.g1)), 14, 0, 0, 17);
	cannon_fire = 2;
end

script static void deck_amb_move_1()
	object_move_to_point (deck_cruiser_1, 100, deck_ps_travel.p0);
end

script static void deck_amb_move_2()
	object_move_to_point (deck_cruiser_2, 125, deck_ps_travel.p2);
end

script static void deck_amb_move_3()
	object_move_to_point (deck_cruiser_3, 60, deck_ps_travel.p4);
end

script static void deck_amb_move_4()
	object_move_to_point (deck_cruiser_5, 80, deck_ps_travel.p1);
end

script static void deck_amb_move_5()
	object_move_to_point (deck_cruiser_6, 100, deck_ps_travel.p3);
end

script static void deck_amb_move_6()
	object_move_to_point (deck_cruiser_7, 150, deck_ps_travel.p5);
end

script static void deck_amb_move_7()
	object_move_to_point (deck_cruiser_8, 125, deck_ps_travel.p6);
end

script static void amb_move_group()
	
	thread (deck_amb_move_1());
	thread (deck_amb_move_2());
	thread (deck_amb_move_3());
	thread (deck_amb_move_4());
	thread (deck_amb_move_5());
	thread (deck_amb_move_6());
	thread (deck_amb_move_7());

end

//CRUISER CRASH ONE

script static void deck_amb_rotate_1()
	object_rotate_to_point (deck_cruiser_1, 30, 30, 30, deck_ps_travel.r1);
end

script static void deck_amb_fall_1()
	thread (deck_amb_fall_1_fx());
	sleep (30 * 2);
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_railgun_hit_cruiser_1', deck_cruiser_1, 1);
	object_move_to_point (deck_cruiser_1, 0, deck_ps_travel.p0);
//	effect_new_at_ai_point ("environments\solo\m10_crash\fx\explosions\explosion_cov_cruiser.effect", deck_ps_travel.p0);
	object_move_to_point (deck_cruiser_1, 30, deck_ps_travel.f1);
//	effect_new_at_ai_point ("environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect", deck_ps_travel.f1);
	object_move_to_point (deck_cruiser_1, 120, deck_ps_travel.f15);
end

script static void deck_amb_crash_1
	thread (deck_amb_rotate_1());
	thread (deck_amb_fall_1());
end

script static void deck_amb_fall_1_fx()
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", deck_cruiser_1, fx_damage_02);
	print (":  : Boom Cruiser 1-1 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", deck_cruiser_1, fx_smoke_02);
	print (":  : Boom Cruiser 1-2 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_1, cruiser_turret_f);
	print (":  : Boom Cruiser 1-3 :  :");
	sleep (30);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_1, cruiser_turret_e);
	print (":  : Boom Cruiser 1-4 :  :");
	sleep (15);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_1, cruiser_turret_d);
	print (":  : Boom Cruiser 1-5 :  :");
	sleep (5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_1, cruiser_turret_c);
	print (":  : Boom Cruiser 1-6 :  :");
	sleep (30 * 5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", deck_cruiser_1, fx_damage_01);
	print (":  : Boom Cruiser 1-7 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", deck_cruiser_1, fx_smoke_01);
	
end

//CRUISER CRASH TWO

script static void deck_amb_rotate_2()
	object_rotate_to_point (deck_cruiser_2, 40, 40, 40, deck_ps_travel.r2);
end

script static void deck_amb_fall_2()
	thread (deck_amb_fall_2_fx());
	
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_railgun_hit_cruiser_2', deck_cruiser_2, 1);
	object_move_to_point (deck_cruiser_2, 0, deck_ps_travel.p2);
	sleep (30 * 3);
	object_move_to_point (deck_cruiser_2, 20, deck_ps_travel.f2);
	object_move_to_point (deck_cruiser_2, 90, deck_ps_travel.f25);
end

script static void deck_amb_crash_2
	thread (deck_amb_rotate_2());
	thread (deck_amb_fall_2());
end

script static void deck_amb_fall_2_fx()

	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", deck_cruiser_2, fx_damage_02);
	print (":  : Boom Cruiser 2-1 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", deck_cruiser_2, fx_smoke_02);
	print (":  : Boom Cruiser 2-2 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_2, cruiser_turret_h);
	print (":  : Boom Cruiser 2-3 :  :");
	sleep (30);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_2, cruiser_turret_l);
	print (":  : Boom Cruiser 2-4 :  :");
	sleep (15);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_2, cruiser_turret_k);
	print (":  : Boom Cruiser 2-5 :  :");
	sleep (5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini_covenant.effect", deck_cruiser_2, cruiser_turret_j);
	print (":  : Boom Cruiser 2-6 :  :");
	sleep (30 * 5);
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explode_lg_02.effect", deck_cruiser_2, fx_damage_01);
	print (":  : Boom Cruiser 2-7 :  :");
	sleep (30 * 3);
	effect_new_on_object_marker_loop ("environments\solo\m60_rescue\fx\explosion\cruiser_damage_smoke.effect", deck_cruiser_2, fx_smoke_01);
	

end

//CRUISER CRASH THREE

script static void deck_amb_fall_3
	object_move_to_point (deck_cruiser_3, 120, deck_ps_travel.f3);
end

script static void deck_amb_rotate_3()
	object_rotate_to_point (deck_cruiser_3, 60, 60, 60, deck_ps_travel.r3);
end

script static void deck_amb_crash_3()
	thread (deck_amb_rotate_3());
	thread (deck_amb_fall_3());
end

//CRUISER CRASH FOUR

script static void deck_amb_fall_4
	object_move_to_point (deck_cruiser_4, 60, deck_ps_travel.f4);
end

script static void deck_amb_rotate_4()
	object_rotate_to_point (deck_cruiser_4, 20, 20, 20, deck_ps_travel.r4);
end

script static void deck_amb_crash_4()
	thread (deck_amb_rotate_4());
	thread (deck_amb_fall_4());
end

//CRUISER CRASH FIVE

script static void deck_amb_fall_5
	object_move_to_point (deck_cruiser_5, 30, deck_ps_travel.f5);
end

script static void deck_amb_rotate_5()
	object_rotate_to_point (deck_cruiser_5, 20, 20, 20, deck_ps_travel.r5);
end

script static void deck_amb_crash_5()
	thread (deck_amb_rotate_5());
	thread (deck_amb_fall_5());
end

//CRUISER CRASH SIX

script static void deck_amb_fall_6
	object_move_to_point (deck_cruiser_6, 30, deck_ps_travel.f6);
end

script static void deck_amb_rotate_6()
	object_rotate_to_point (deck_cruiser_6, 20, 20, 20, deck_ps_travel.r6);
end

script static void deck_amb_crash_6()
	thread (deck_amb_rotate_6());
	thread (deck_amb_fall_6());
end

script static void chtitledeck2

	cui_hud_set_objective_complete (obj_complete);
	
	sleep (30 * 5);
	
	cui_hud_set_new_objective  (chtitleinfdeck2);
		
end

script static void chtitledeck3

	cui_hud_set_new_objective (chtitleinfdeck3);
		
end

script static void deckobjcomplete
	
	cui_hud_set_objective_complete (obj_complete);
	sleep (30 * 3);

end

// =================================================================================================
// =================================================================================================
// DECK COMMAND SCRIPTS
// =================================================================================================
// =================================================================================================

script command_script deck_drop_1_r
	print (":  : Deck Phantom 1 Right :  :");
	//vehicle_ignore_damage_knockback (ai_vehicle_get(ai_current_actor),true);
	//	cs_vehicle_speed (.75);
	f_load_phantom (sq_deck_phantom_r, "dual", sq_deck_drop_1_a, sq_deck_drop_1_b, none, none);
//	ai_disregard ((ai_current_actor), TRUE);
	cs_fly_by (deck_drop_1_r.p0);
	cs_fly_by (deck_drop_1_r.p1);
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_phantom_swoop_right', sq_deck_phantom_r, 1);
	cs_fly_to_and_face (deck_drop_1_r.p2, deck_drop_1_r.p3);
	sleep (30 * 3);
	f_unload_phantom (sq_deck_phantom_r, "dual");
	sleep_until (unit_in_vehicle (ai_get_unit (sq_deck_drop_1_a)) == FALSE
								AND
							unit_in_vehicle (ai_get_unit (sq_deck_drop_1_b)) == FALSE);
	print (":  : Units Out Of Phantom :  :");
	ai_disregard (ai_actors(sq_deck_drop_1_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_1_b), TRUE);
	sleep (30 * 5);
	if
		deck_gun_count >= 5
	then
		sleep (30 * 5);
		//sleep_until ((object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_r.driver))) < .5);
		cs_vehicle_speed (.3);
		cs_fly_to (deck_drop_1_r.p4);
		deck_phantom_count = (deck_phantom_count + 1);
		cs_fly_to (deck_drop_1_r.p5);
		cs_fly_to (deck_drop_1_r.p6);
		ai_erase (sq_deck_phantom_r);
	else
//	ai_disregard ((ai_current_actor), FALSE);
		cs_fly_to (deck_drop_1_r.p4);
		deck_phantom_count = (deck_phantom_count + 1);
		cs_fly_to (deck_drop_1_r.p5);
		cs_fly_to (deck_drop_1_r.p6);
		ai_erase (sq_deck_phantom_r);
	end
end

script command_script deck_drop_1_l
	print (":  : Deck Phantom 1 Left :  :");
//	vehicle_ignore_damage_knockback(ai_vehicle_get(ai_current_actor),true);
	//	cs_vehicle_speed (.75);
	f_load_phantom (sq_deck_phantom_l, "dual", sq_deck_drop_2_a, sq_deck_drop_2_b, none, none);
//	ai_disregard ((ai_current_actor), TRUE);
	cs_fly_by (deck_drop_1_l.p0);
	cs_fly_by (deck_drop_1_l.p1);
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_phantom_swoop_left', sq_deck_phantom_l, 1);
 	cs_fly_to_and_face (deck_drop_1_l.p3, deck_drop_1_l.p2);
	f_unload_phantom (sq_deck_phantom_l, "dual");
	sleep_until (unit_in_vehicle (ai_get_unit (sq_deck_drop_2_a)) == FALSE
								AND
							unit_in_vehicle (ai_get_unit (sq_deck_drop_2_b)) == FALSE);
	print (":  : Units Out Of Phantom :  :");
	ai_disregard (ai_actors(sq_deck_drop_2_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_2_b), TRUE);
	if
		deck_gun_count >= 5
	then
		sleep (30 * 5);
	//	sleep_until ((object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_l.driver))) < .75);
		cs_vehicle_speed (.3);
		sleep (30 * 3);
		cs_fly_by (deck_drop_1_l.p4);
		deck_phantom_count = (deck_phantom_count + 1);
		cs_fly_by (deck_drop_1_l.p5);
		ai_erase (sq_deck_phantom_l);
	//	cs_fly_by (deck_drop_1_l.p6);
//	ai_disregard ((ai_current_actor), FALSE);
	else
		sleep (30 * 3);
		cs_fly_by (deck_drop_1_l.p4);
		deck_phantom_count = (deck_phantom_count + 1);
		cs_fly_by (deck_drop_1_l.p5);
		cs_fly_by (deck_drop_1_l.p6);
//	ai_disregard ((ai_current_actor), FALSE);
		ai_erase (sq_deck_phantom_l);
	end
end

script command_script deck_drop_2_l
//	vehicle_ignore_damage_knockback(ai_vehicle_get(ai_current_actor),true); 
	f_load_phantom (sq_deck_phantom_l_2, "dual", sq_deck_drop_3_a, sq_deck_drop_3_b, none, none);
	//cs_vehicle_speed (.75);
//	ai_disregard ((ai_current_actor), TRUE);
	//cs_fly_by (deck_drop_2_l.p0);
	//cs_fly_by (deck_drop_2_l.p1);
	//cs_fly_by (deck_drop_2_l.p2);
	cs_fly_by (deck_drop_2_l.p3);
	cs_fly_by (deck_drop_2_l.p4);
	deck_phantom_count = (deck_phantom_count + 1);
	cs_fly_by (deck_drop_2_l.p5);
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_phantom_swoop_left', sq_deck_phantom_l_2, 1);
	cs_fly_to_and_face (deck_drop_2_l.p6, deck_drop_2_l.p7);
	sleep (30 * 3);
	f_unload_phantom (sq_deck_phantom_l_2, "dual");
	sleep_until (unit_in_vehicle (ai_get_unit (sq_deck_drop_3_a)) == FALSE
								AND
							unit_in_vehicle (ai_get_unit (sq_deck_drop_3_b)) == FALSE);
	print (":  : Units Out Of Phantom :  :");
	ai_disregard (ai_actors(sq_deck_drop_3_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_3_b), TRUE);
//	ai_disregard ((ai_current_actor), FALSE);
	sleep (30 * 5);
		if
			deck_gun_count >= 5
		then
			sleep (30 * 5);
	//		sleep_until ((object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_l_2.driver))) < .75);
			cs_vehicle_speed (.3);
			cs_fly_by (deck_drop_2_l.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_2_l.p3);
			cs_fly_by (deck_drop_2_l.p2);
			ai_erase (sq_deck_phantom_l_2);
		//	cs_fly_by (deck_drop_2_l.p1);
		//	cs_fly_by (deck_drop_2_l.p0);
		else
			cs_fly_by (deck_drop_2_l.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_2_l.p3);
			cs_fly_by (deck_drop_2_l.p2);
			cs_fly_by (deck_drop_2_l.p1);
			cs_fly_by (deck_drop_2_l.p0);
			ai_erase (sq_deck_phantom_l_2);
		end
end

script command_script deck_drop_2_r
//	vehicle_ignore_damage_knockback(ai_vehicle_get(ai_current_actor),true); 
	f_load_phantom (sq_deck_phantom_r_2, "dual", sq_deck_drop_4_a, sq_deck_drop_4_b, none, none);
	//cs_vehicle_speed (.75);
//	ai_disregard ((ai_current_actor), TRUE);
	//cs_fly_by (deck_drop_2_r.p0);
	//cs_fly_by (deck_drop_2_r.p1);
	//cs_fly_by (deck_drop_2_r.p2);
	cs_fly_by (deck_drop_2_r.p3);
	cs_fly_by (deck_drop_2_r.p4);
	cs_fly_by (deck_drop_2_r.p5);
	
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_phantom_swoop_right', sq_deck_phantom_r_2, 1);
	cs_fly_to_and_face (deck_drop_2_r.p6, deck_drop_2_r.p7);
	sleep (30 * 3);
	f_unload_phantom (sq_deck_phantom_r_2, "dual");
	sleep_until (unit_in_vehicle (ai_get_unit (sq_deck_drop_4_a)) == FALSE
								AND
							unit_in_vehicle (ai_get_unit (sq_deck_drop_4_b)) == FALSE);
	print (":  : Units Out Of Phantom :  :");
	ai_disregard (ai_actors(sq_deck_drop_4_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_4_b), TRUE);
//	ai_disregard ((ai_current_actor), FALSE);
	sleep (30 * 5);
		if
			deck_gun_count >= 5
		then
			sleep (30 * 5);
		//	sleep_until ((object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_r_2.driver))) < .75);
			cs_vehicle_speed (.3);
			cs_fly_by (deck_drop_2_r.p5);
			cs_fly_by (deck_drop_2_r.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_2_r.p3);
			cs_fly_by (deck_drop_2_r.p2);
			ai_erase (sq_deck_phantom_r_2);
			//cs_fly_by (deck_drop_2_r.p1);
			//cs_fly_by (deck_drop_2_r.p0);
		else
			cs_fly_by (deck_drop_2_r.p5);
			cs_fly_by (deck_drop_2_r.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_2_r.p3);
			cs_fly_by (deck_drop_2_r.p2);
			cs_fly_by (deck_drop_2_r.p1);
			cs_fly_by (deck_drop_2_r.p0);
			ai_erase (sq_deck_phantom_r_2);
		end
end

script command_script deck_drop_mid
//	vehicle_ignore_damage_knockback(ai_vehicle_get(ai_current_actor),true); 
	cs_vehicle_speed (1.5);
	f_load_phantom (sq_deck_phantom_back_mid, "dual", sq_deck_drop_5_a, sq_deck_drop_5_b, none, none);
//	ai_disregard ((ai_current_actor), TRUE);
	cs_fly_by (deck_drop_mid.p0);
	//cs_fly_by (deck_drop_mid.p1);
	//cs_fly_by (deck_drop_mid.p8);
	sound_impulse_start('sound\environments\solo\m060\events\amb_m60_phantom_swoop_middle', sq_deck_phantom_back_mid, 1);
	
		if (volume_test_players (trig_deck_mid_drop))
					then
				cs_fly_to_and_face (deck_drop_mid.p1, deck_drop_mid.p9);
					else
				cs_fly_to_and_face (deck_drop_mid.p3, deck_drop_mid.p2);
		end
	sleep (30 * 3);
	f_unload_phantom (sq_deck_phantom_back_mid, "dual");
	sleep_until (unit_in_vehicle (ai_get_unit (sq_deck_drop_5_a)) == FALSE
								AND
							unit_in_vehicle (ai_get_unit (sq_deck_drop_5_b)) == FALSE);
	print (":  : Units Out Of Phantom :  :");
	ai_disregard (ai_actors(sq_deck_drop_5_a), TRUE);
	ai_disregard (ai_actors(sq_deck_drop_5_b), TRUE);
	sleep (30 * 5);
		if
			deck_gun_count >= 5
		then
			sleep (30 * 5);
			//sleep_until ((object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_back_mid.driver))) < .75);
			cs_vehicle_speed (.3);
//	ai_disregard ((ai_current_actor), FALSE);
			cs_fly_by (deck_drop_mid.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_mid.p5);
			ai_erase (sq_deck_phantom_back_mid);
			//cs_fly_by (deck_drop_mid.p6);
			//cs_fly_by (deck_drop_mid.p7);
		else
			cs_fly_by (deck_drop_mid.p4);
			deck_phantom_count = (deck_phantom_count + 1);
			cs_fly_by (deck_drop_mid.p5);
			cs_fly_by (deck_drop_mid.p6);
			cs_fly_by (deck_drop_mid.p7);
			ai_erase (sq_deck_phantom_back_mid);
		end
end

script command_script deck_drop_fodder_r_1
//	cs_vehicle_speed (.75);
	object_cannot_take_damage (ai_actors(ai_current_actor));
	cs_fly_by (deck_drop_fodder_r_1.p3);
	cs_fly_by (deck_drop_fodder_r_1.p4);
	object_can_take_damage (ai_actors(ai_current_actor));
	cs_shoot (sq_aa_gun_2.g1, TRUE, (ai_current_actor));
	cs_fly_by (deck_drop_fodder_r_1.p5);
	cs_fly_by (deck_drop_fodder_r_1.p6);
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_r_1.driver)) < 1);
	damage_object (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_r_1.driver), hull, 4000);
end

script command_script deck_drop_fodder_l_1
//	cs_vehicle_speed (.75);
	object_cannot_take_damage (ai_actors(ai_current_actor));
	cs_fly_by (deck_drop_fodder_l_1.p3);
	cs_fly_by (deck_drop_fodder_l_1.p4);
	cs_fly_by (deck_drop_fodder_l_1.p5);
	cs_fly_by (deck_drop_fodder_l_1.p6);
	object_can_take_damage (ai_actors(ai_current_actor));
	cs_shoot (sq_aa_gun_2.g2, TRUE, ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_1.driver));
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_1.driver)) < 1);
	damage_object (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_1.driver), hull, 4000);
end

script command_script deck_drop_fodder_l_2
//	cs_vehicle_speed (.75);
	object_cannot_take_damage (ai_actors(ai_current_actor));
	cs_fly_by (deck_drop_fodder_l_1.p3);
	cs_fly_by (deck_drop_fodder_l_1.p1);
	cs_fly_by (deck_drop_fodder_l_1.p2);
	cs_fly_by (deck_drop_fodder_l_1.p8);
	object_can_take_damage (ai_actors(ai_current_actor));
	cs_shoot (sq_aa_gun_2.g2, TRUE, ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_2.driver));
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_2.driver)) < 1);
	damage_object (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_2.driver), hull, 4000);
end

script command_script deck_drop_fodder_l_3
//	cs_vehicle_speed (.75);
	object_cannot_take_damage (ai_actors(ai_current_actor));
	cs_fly_by (deck_drop_fodder_l_1.p3);
	cs_fly_by (deck_drop_fodder_l_1.p9);
	cs_fly_by (deck_drop_fodder_l_1.p10);
	object_can_take_damage (ai_actors(ai_current_actor));
	cs_shoot (sq_aa_gun_2.g2, TRUE, ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_3.driver));
	sleep_until (object_get_health (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_3.driver)) < 1);
	damage_object (ai_vehicle_get_from_spawn_point (sq_deck_phantom_fodder_l_3.driver), hull, 4000);
end

script static void flak_gun_1_a()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.a1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.a3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.a2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.a4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_1_b()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.b1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.b3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.b2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_left_a.b4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_2_a()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.a1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.a3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.a2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.a4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_2_b()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.b1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.b3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.b2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_right_a.b4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_3_a()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.a1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.a3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.a2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.a4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_3_b()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.b1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.b3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.b2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.b4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script static void flak_gun_3_c()

	sleep (random_range (90, 150));

	repeat
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.c1);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.c3);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.c2);
		sleep (random_range (90, 150));
		effect_new_at_ai_point ("environments\solo\m60_rescue\fx\turrets\dummy_firing_unsc.effect", deck_effect_mid_a.c4);
		sleep (random_range (90, 150));
	until (1 == 0);
end

script command_script deck_vig_1
	cs_vehicle_speed (.5);
	sleep_until (volume_test_players (trig_deck_vig), 1);
	cs_fly_by (deck_drop_1.p6);
	cs_fly_by (deck_drop_1.p7);
	cs_fly_by (deck_drop_1.p8);
	cs_fly_by (deck_drop_1.p9);
	ai_erase (sq_deck_vig_2);
end

script command_script deck_vig_2
	cs_vehicle_speed (.5);
	sleep_until (volume_test_players (trig_deck_vig), 1);
	cs_fly_by (deck_drop_2.p6);
	cs_fly_by (deck_drop_2.p7);
	cs_fly_by (deck_drop_2.p8);
	cs_fly_by (deck_drop_2.p9);
	ai_erase (sq_deck_vig_1);
end

script command_script mac_fire
	ai_set_blind (ai_current_actor, TRUE);
	cs_aim (TRUE, mac_aim.p0);
	sleep_until(g_shoot_cannon==true,1);
	ai_braindead (sq_aa_gun_3, FALSE);
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_battery_power_on', deck_gun_mac, 1 ); 
	sleep(1);
	cs_shoot (TRUE, cruiser_deck);
	sleep (90);
	ai_braindead (sq_aa_gun_3, TRUE);
	print (":  : BIG BADDA BOOM :  :");
	thread (f_m60_music_nothing()); // end deck music
	sleep (30 * 7);
	wake (end_cutscene);
	// M65_atinfinity Cutscene

end

script static void cryptum_impacts()
	
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p0);
	print (" :  : Cryptum Impact 1 :  : ");
	sleep (30 * 2);
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p1);
	print (" :  : Cryptum Impact 2 :  : ");
	sleep (30 * 1);
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p2);
	print (" :  : Cryptum Impact 3 :  : ");
	sleep (30);
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p3);
	print (" :  : Cryptum Impact 4 :  : ");
	sleep (10);
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p4);
	print (" :  : Cryptum Impact 5 :  : ");
	sleep (5);
	effect_new_at_ai_point ("environments\solo\m60_rescue\fx\weapon\cryptum_impact.effect", cryptum_impact.p5);
	print (" :  : Cryptum Impact 6 :  : ");

end
	

script command_script cs_amb_gun_1

	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_amb_1.p0)), FALSE);

	print (":  : Shoot the damn thing :  :");
	ai_braindead (sq_aa_gun_amb_1, FALSE);
	sleep(1);
	cs_shoot (TRUE, deck_cruiser_1);
	sleep (30 * 10);
	print (":  : Effect Played? :  :");
//	ai_braindead (sq_aa_gun_amb_1, TRUE);
	sleep (30 * 10);
	thread (deck_amb_crash_1());
	cs_shoot (TRUE, deck_cruiser_1);
	sleep (30 * 10);
	sound_impulse_start ( 'sound\environments\solo\m060\amb_m60_final\amb_m60_mach\mach_m60_battery_power_on', deck_cruiser_1, 1 ); 
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_1, fx_damage_01);
	
	sleep (random_range (15, 30));
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_1, fx_damage_01);
	
	ai_erase (ai_current_actor);
	
end

script command_script cs_amb_gun_1_a

	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_amb_1.p1)), FALSE);

	sleep(1);
	cs_shoot (TRUE, deck_cruiser_1);
	sleep (30 * 20);

	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_1, fx_damage_01);
	
	sleep (random_range (15, 30));
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_1, fx_damage_01);

	ai_erase (ai_current_actor);

end

script command_script cs_amb_gun_2

	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_amb_2.p0)), FALSE);

	print (":  : Shoot the damn thing :  :");
	ai_braindead (sq_aa_gun_amb_2, FALSE);
	sleep(1);
	cs_shoot (TRUE, deck_cruiser_2);
	sleep (30 * 10);
	print (":  : Effect Played? :  :");
//	ai_braindead (sq_aa_gun_amb_2, TRUE);
	sleep (30 * 10);
	thread (deck_amb_crash_2());
	cs_shoot (TRUE, deck_cruiser_2);
	sleep (30 * 10);

effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_2, fx_damage_01);
	
	sleep (random_range (15, 30));
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_2, fx_damage_01);

	ai_erase (ai_current_actor);

end

script command_script cs_amb_gun_2_a

	object_set_physics ((ai_vehicle_get_from_spawn_point (sq_aa_gun_amb_2.p1)), FALSE);

	sleep(1);
	cs_shoot (TRUE, deck_cruiser_2);
	sleep (30 * 20);

	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_2, fx_damage_01);
	
	sleep (random_range (15, 30));
	
	effect_new_on_object_marker ("environments\solo\m60_rescue\fx\explosion\cruiser_explosion_mini.effect", deck_cruiser_2, fx_damage_01);

	ai_erase (ai_current_actor);

end

script command_script cs_amb_miss_1_a

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_1.a, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_1);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_1.a, TRUE);

	until (1 == 0);

end

script command_script cs_amb_miss_1_b

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_1.b, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_1);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_1.b, TRUE);

	until (1 == 0);

end

script command_script cs_amb_miss_2_a

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_2.a, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_2);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_2.a, TRUE);

	until (1 == 0);

end

script command_script cs_amb_miss_2_b

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_2.b, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_2);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_2.b, TRUE);

	until (1 == 0);

end

script command_script cs_amb_miss_3_a

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_3.a, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_1);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_3.a, TRUE);

	until (1 == 0);

end

script command_script cs_amb_miss_3_b

	sleep (random_range (90, 150));

	repeat

		print (":  : Shoot the damn thing :  :");
		ai_braindead (sq_aa_miss_amb_3.b, FALSE);
		sleep(1);
		cs_shoot (TRUE, deck_cruiser_2);
		sleep (random_range (300, 450));
		ai_braindead (sq_aa_miss_amb_3.b, TRUE);

	until (1 == 0);

end

script command_script cs_shoot_didact

	sleep (random_range (90, 150));
	
	cs_aim_object (TRUE, cruiser_deck);
	
	repeat
		cs_shoot (TRUE, cruiser_deck);
		sleep (random_range (90, 150));
	until (cryptum_gone == TRUE);

end

script dormant deck_flak_fx_l

	repeat

		begin_random_count(8)
	
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p0);
			sleep (random_range (15, 30));
		end

		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p1);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p2);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p3);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p4);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p5);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p6);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_l.p7);
			sleep (random_range (15, 30));
		end
	
	end
	
	until (1 == 0);

end

script dormant deck_flak_fx_r

repeat

	begin_random_count(8)
	
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p0);
			sleep (random_range (15, 30));
		end

		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p1);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p2);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p3);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p4);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p5);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p6);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_r.p7);
			sleep (random_range (15, 30));
		end
	
	end
	
until (1 == 0);

end

script dormant deck_flak_fx_m

repeat

	begin_random_count(8)
	
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p0);
			sleep (random_range (15, 30));
		end

		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p1);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p2);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p3);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p4);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p5);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p6);
			sleep (random_range (15, 30));
		end
		
		begin
			effect_new_at_ai_point ("environments\solo\m60_rescue\fx\explosion\flak_det.effect", flak_point_m.p7);
			sleep (random_range (15, 30));
		end
	
	end
	
until (1 == 0);

end

script dormant end_cutscene

	sleep (30 * 4);

	//effect_attached_to_camera_stop ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );

	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
		
		cinematic_enter ("cin_m065_atinfinity", TRUE);
		
		switch_zone_set (cin_m065_atinfinity);
		sleep ( 1 );
		sleep_until (current_zone_set_fully_active() == zs_cin_m065, 1);

		cinematic_suppress_bsp_object_creation(TRUE);

		f_start_mission ("cin_m065_atinfinity");
		
		cinematic_suppress_bsp_object_creation(FALSE);
		
		cinematic_exit_no_fade ("cin_m065_atinfinity", TRUE); 
		
		print ("Cinematic exited!"); 
		
	end
	
	game_won();

end

// =================================================================================================
// =================================================================================================
// DEBUG
// =================================================================================================
// =================================================================================================

script static void dprint (string s)
	if b_debug then
		print (s);
	end
end

; =================================================================================================
; =================================================================================================
; COMMAND SCRIPTS
; =================================================================================================
; =================================================================================================

