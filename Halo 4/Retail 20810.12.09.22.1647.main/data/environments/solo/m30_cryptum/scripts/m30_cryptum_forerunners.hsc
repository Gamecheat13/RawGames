//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m30_cryptum
//	Subsection: 			Intro
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global short intro_pawn_check = 5;
global short intro_pawn_fight = 0;
global short caves_knight_2_obj = 0;
global short portal_count = 0;
global short knight_gating = 0;
global boolean gh_bishop_spawned = FALSE;
global boolean b_first_time_through = FALSE;
global boolean b_second_time_through = FALSE;
global boolean b_final_time_through = FALSE;
global boolean puppeteer_done = FALSE;
global boolean b_first_pawn_fight_started = FALSE;
global boolean b_pawn_reveal_go = FALSE;
global boolean b_bridge_button_hit = FALSE;
global boolean b_bridge_gate_check = FALSE;
global boolean b_grassy_hill_encounter_over = FALSE;

// Puppet id for tracking which "Pylon Electricity" puppet is active
global long id_for_pylon_pups = -1;

// =================================================================================================
// =================================================================================================
// *** FORERUNNER INTRO ***
// =================================================================================================
// =================================================================================================

script dormant m30_cryptum_intro_forerunners()	
	sleep_until (b_mission_started == TRUE);

	dprint  ("::: intro forerunners start :::");
	thread (aa_turret_1_float());
	thread (aa_turret_2_float());
	thread (aa_turret_3_float());
	thread (aa_turret_4_float());
	wake (f_bishop_intro);
	wake (f_grassy_hill_spawn);
	thread (observation_deck_setup());
	wake (distant_knight_phasing);
	wake (caves_save_setup);
	wake (first_pawn_setup);
	wake (knight_ambush_pup);
	wake (cryptshield_1_caves);
	data_mine_set_mission_segment ("m30_start/caves");
end

script dormant first_pawn_setup
	sleep_until (volume_test_players (tv_first_pawn_place), 1);
	
	b_pawn_reveal_go = TRUE;
	
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_pawns_appear', NONE, 1 );

	dprint ("first pawn fight placed");
	
	//sleep_until (ai_living_count (sg_intro_pawn) <= 3);
	
	//dprint ("pawn reinforcements incoming!");
	
	//ai_place (sq_caves_pawn_intro_2);
	//ai_place (sq_caves_pawn_intro_3);
	
end

script dormant bridge_button_dissolve()
	dprint ("bridge button dissolving");
	object_dissolve_from_marker(bridge_button, "phase_out", "button_marker");
	//gets rid of collision device machine proxy
	object_destroy(m30_button_fake1);
end

script static void f_phase_to_point( object obj, point_reference point )
	cs_phase_to_point(object_get_ai(obj), TRUE, point);
	
end

script static void f_phase_to_point_and_erase (object obj, point_reference point)
	
	sleep (5);
	
	dprint ("phasing away now weeeeee");
	
	cs_phase_to_point(object_get_ai(obj), TRUE, point);
	
	sleep (40);
	
	dprint ("erase");
	ai_erase (object_get_ai(obj));
end


script dormant caves_save_setup
	sleep_until (volume_test_players (tv_caves_save), 1);

	game_save_no_timeout();
	
	pup_play_show ("pawn_reveal");
		
end

script command_script knight_phase_spawn()
	cs_phase_in();
end

script dormant knight_ambush_pup
	sleep_until (volume_test_players (tv_knight_attack), 1);
	
	if game_is_cooperative() then
	
	dprint ("no show for you");
	
	else
	
	thread (knight_attack());
	
	end
	
end

script static void knight_attack()

	g_ics_player = player0;
	streamer_pin_tag("objects\characters\storm_knight\storm_knight.biped", object_type_get_variant_index("objects\characters\storm_knight\storm_knight.biped", "e3_hero_head"));
	local long show = pup_play_show ("knight_attack");
	sleep_until(not pup_is_playing(show),1);
	show = pup_play_show ("knight_attack2");
	sleep_until(not pup_is_playing(show),1);
	streamer_unpin_tag("objects\characters\storm_knight\storm_knight.biped", object_type_get_variant_index("objects\characters\storm_knight\storm_knight.biped", "e3_hero_head"));
end

script dormant f_bishop_intro()
	sleep_until (volume_test_players (tv_intro_pawn_fight), 1);

	thread (f_mus_m30_e01_start());
	
	ai_place (sq_barking_pawn);
	local long show = pup_play_show(barking_pawn);
		
	//sleep (30);
	ai_place (sq_caves_pawn_intro);
	sleep (10);
	ai_place (sq_caves_pawn_intro_2);
	sleep (20);
	ai_place (sq_caves_pawn_intro_3);
	dprint ("here come the pawns on de floor");
	wake (bridge_gating);
	wake (bridge_failsafe);
	wake (m30_prepawn);

	intro_pawn_fight = 0;

	wake (canyon_bridge_create);

	device_group_set_immediate (bridge_group, 1);

end

script command_script start_pawn_waiting()
	cs_pause (0.25);
end	

script dormant bridge_gating()
	sleep_until (ai_living_count (sg_intro_pawn) == 0) and (b_bridge_gate_check == FALSE);
	
	wake (M30_plyon_1_lightbridge);
	f_blip_flag (bridge_button_flag, "activate");
	thread (f_mus_m30_e01_finish());
	//sleep_forever (bridge_failsafe);
end

script dormant bridge_failsafe()
	sleep_until (volume_test_players (tv_bridge_failsafe_check), 1);
	 //and (b_bridge_gate_check == FALSE)
	b_bridge_gate_check = TRUE;
	f_unblip_flag (bridge_button_flag);
	thread (f_mus_m30_e01_finish());
	sleep_forever (bridge_gating);
	dprint ("you made it across the bridge before all them pawns were dead, sleeping blip forever");
	
end

script command_script intro_bishop_fly()
	cs_pause (1.0);
	cs_fly_to (ps_intro_bishop.p0);
	cs_fly_to (ps_intro_bishop.p1);
	cs_fly_to (ps_intro_bishop.p2);
	ai_erase (sq_caves_bishop_1);
end

script static void f_activator_get( object trigger, unit activator )
	g_ics_player = activator;

	if ( trigger == domain_terminal_button ) then
		f_narrative_domain_terminal_interact( 1, domain_terminal, domain_terminal_button, activator, 'pup_domain_terminal' );
	end
	
end


script dormant canyon_bridge_create()
	sleep_until (device_get_position (bridge_button) != 0);

	device_group_set_immediate (bridge_group, 0);
	
	sleep_forever (bridge_failsafe);
	sleep_forever (bridge_gating);
	
	f_unblip_flag (bridge_button_flag);

	local long show = pup_play_show ("canyon_bridge");
	sleep (60);
	object_create (m30_caves_lightbridge);
	sound_impulse_start ( 'sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_spawn_forerunner_bridge', m30_caves_lightbridge, 1 ); //AUDIO!
	dprint ("canyon bridge is created.  if you're in sapien, it's time for a leap of faith.");
	
	sleep_until(not pup_is_playing(show),1);
	
	game_save_no_timeout();
	
	sleep_until ((ai_living_count (sg_intro_pawn) == 0) or (volume_test_players (tv_bridge_failsafe_check)), 1);
	
	wake (M30_plyon_1_lightbridge);
	thread (f_mus_m30_e01_finish());

end

script command_script surprise_bishop1()
	cs_fly_to (ps_bishop_surprise1.p0);
	cs_fly_to (ps_bishop_surprise1.p1);
	cs_fly_to (ps_bishop_surprise1.p2);
	ai_erase (bishop_surprise.sp0);
end

script command_script surprise_bishop2()
	cs_fly_to (ps_bishop_surprise1.p3);
	cs_fly_to (ps_bishop_surprise1.p1);
	cs_fly_to (ps_bishop_surprise1.p2);
	ai_erase (bishop_surprise.sp1);
end

script command_script surprise_bishop3()
	cs_fly_to (ps_bishop_surprise1.p4);
	cs_fly_to (ps_bishop_surprise1.p6);
	cs_fly_to (ps_bishop_surprise1.p7);
	ai_erase (bishop_surprise.sp2);
end

script command_script surprise_bishop4()
	cs_fly_to (ps_bishop_surprise1.p5);
	cs_fly_to (ps_bishop_surprise1.p6);
	cs_fly_to (ps_bishop_surprise1.p7);
	ai_erase (bishop_surprise.sp3);
end
	

script command_script f_bridgepawns_run()
	cs_abort_on_damage (TRUE);
	cs_abort_on_alert (TRUE);
	cs_shoot (TRUE);
	cs_move_towards_point (ps_bridge_pawns.p0, 1);
	cs_move_towards_point (ps_bridge_pawns.p1, 1);
end

// Spawn the knights in the distance that will teleport away
script dormant distant_knight_phasing()
	sleep_until (volume_test_players (tv_start_obj), 1);
	
	ai_place (sq_caves_knight_2);
	ai_place (sq_caves_flavor_knight2);
	ai_place (sq_caves_flavor_knight1);
end

script command_script bishop_2_flyaway()
	cs_pause (1.5);
	cs_fly_to (ps_bishop2_flyaway.p0);
	cs_fly_to (ps_bishop2_flyaway.p1);
	cs_fly_to (ps_bishop2_flyaway.p2);
	cs_fly_to (ps_bishop2_flyaway.p3);
	cs_fly_to (ps_bishop2_flyaway.p4);
	ai_erase (sq_caves_bishop_2);
end	

script command_script knight_intro_move()
	cs_pause (3.0);
	cs_move_towards_point (ps_knight_move.p0, 1);
end

script command_script knight_phase_intro()
	sleep_until ((unit_get_shield (ai_current_actor) < 0.90) or (volume_test_players (tv_phase1)), 1);
	cs_pause (0.5);
//	cs_phase_to_point (ps_knight_phasing.p4);
//	cs_pause (1.0);

	// The first knight teleports away
	sound_impulse_start('sound\environments\solo\m030\ambience\events\amb_m30_knights_phasing', NONE, 1 );
	
	cs_phase_to_point (ps_knight_phasing.p0);
	ai_erase (sq_caves_knight_2);
end

script command_script knight_flavor_phase1()
	sleep_until ((unit_get_shield (ai_current_actor) < 0.90) or (volume_test_players (tv_phase2)), 1);
	cs_pause (1.25);
//	cs_phase_to_point (ps_knight_phasing.p5);
//	cs_pause (1.5);
	cs_phase_to_point (ps_knight_phasing.p1);
	ai_erase (sq_caves_flavor_knight2);
end

script command_script knight_flavor_phase2()
	sleep_until ((unit_get_shield (ai_current_actor) < 0.90) or (volume_test_players (tv_phase2)), 1);
//	cs_phase_to_point (ps_knight_phasing.p6);
	cs_pause (0.75);
	wake (M30_grassy_hills_start);
	cs_phase_to_point (ps_knight_phasing.p2);
	ai_erase (sq_caves_flavor_knight1);
end

script dormant f_grassy_hill_spawn()
	sleep_until (volume_test_players (tv_grassy_hill_spawn), 1);
	thread (f_mus_m30_e02_start());
	game_save_no_timeout();
	knight_gating = 0;
	thread (gh_bishop_tower_left());
	thread (gh_bishop_tower_right());

	ai_place (sq_caves_bishop_3);
//	ai_place (sq_bishop_watchers);
	//ai_place (sq_caves_knight_watchers);
	
	thread (place_voyeur_knights());
	
	ai_disregard (ai_actors(sq_caves_knight_watchers), TRUE);

	thread (f_door_hallway_1_in_open());
	ai_place (sq_grassy_hill_pawns);
	sleep (5);
	ai_place (sq_grassy_hill_pawns_2);
	sleep (5);
	ai_place (sq_grassy_hill_pawns_3);
	local long show = pup_play_show ("knight_intro");
	//wake (f_grassy_hill_step_1);
	
	//sleep (30 * 2);
	wake (f_grassy_hill_end);
	
	sleep_until (not pup_is_playing (show), 1);
	
	puppeteer_done = TRUE;
	//ai_reset_objective (before_bishop_spawn);
	
end

script static void place_voyeur_knights()

	local long voyeur_1 = pup_play_show ("knight_voyeur_1");
	sleep (15);
	local long voyeur_2 = pup_play_show ("knight_voyeur_2");
	sleep (10);
	local long voyeur_3 = pup_play_show ("knight_voyeur_3");
	sleep (10);
	local long voyeur_4 = pup_play_show ("knight_voyeur_4");
	sleep (15);
	local long voyeur_5 = pup_play_show ("knight_voyeur_5");

	sleep_until (knight_gating == 15, 1);
	
	pup_stop_show (voyeur_1);

	pup_stop_show (voyeur_2);

	pup_stop_show (voyeur_3);

	pup_stop_show (voyeur_4);

	pup_stop_show (voyeur_5);

end

script command_script knight_watcher_1()
	cs_phase_to_point (ps_knight_move.p7);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_2()
	cs_phase_to_point (ps_knight_move.p8);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_3()
	cs_phase_to_point (ps_knight_move.p9);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_4()
	cs_phase_to_point (ps_knight_move.p12);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_5()
	cs_phase_to_point (ps_knight_move.p11);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_6()
	cs_phase_to_point (ps_knight_move.p3);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script command_script knight_watcher_7()
	cs_phase_to_point (ps_knight_move.p4);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.75) or (knight_gating == 15), 1);
	dprint ("you scared him away!");
	cs_phase_to_point (ps_knight_move.p13);
	ai_erase (ai_current_actor);
	
end

script static void gh_bishop_tower_left()
	gh_bishop_tower_1->start_animating();
end

script static void gh_bishop_tower_right()
	gh_bishop_tower_2->start_animating();
end

script dormant f_grassy_hill_end()
	dprint ("f_grassy_hill_end was woken");
	sleep_until (ai_living_count (sq_caves_knight_3) == 0 and ai_living_count (sg_gh_pawns) == 0 and (ai_living_count(sq_caves_bishop_3) - ai_in_limbo_count(sq_caves_bishop_3)) == 0, 1);
	
	knight_gating = 15;

	thread (f_mus_m30_e02_finish());
	dprint ("knight_gating is set to 15, blip appearing");
	f_blip_flag (grassy_hill_end_flag, "default");
	game_save();
	b_grassy_hill_encounter_over = TRUE;	
	wake (grassy_hill_end_blip_gone);
end

script command_script gh_knight_phase_2()
	cs_phase_to_point (ps_knight_move.p3);

	//cs_pause (1);
	
	//cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
		
	sleep_until ((unit_get_shield (ai_current_actor) < 0.5) or (knight_gating == 5), 1);
	
	dprint ("knight was threatened - phase into combat now");
	
	sleep (15);
	
	cs_phase_to_point (ps_knight_move.p5);

end

script command_script gh_knight_phase_3()
	cs_phase_to_point (ps_knight_move.p4);
	
	//cs_pause (0.5);
	
	//cs_custom_animation (objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	
	sleep_until ((unit_get_shield (ai_current_actor) < 0.5) or (knight_gating == 10), 1);

	dprint ("knight was threatened - phase into combat now");

	sleep (15);

	cs_phase_to_point (ps_knight_move.p5);
	
end

script command_script cs_bishop_spawn()
	print("bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn, 0);
  cs_pause (1.0);
end

script command_script cs_bishop_spawn_gh()
	print("gh bishop sleeping");
  ai_enter_limbo (ai_current_actor);
  CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), OnCompleteProtoSpawn_gh, 0);
  cs_pause (1.0);
end

script static void OnCompleteProtoSpawn_gh()
	dprint ("bishop is spawned");
	gh_bishop_spawned = TRUE;
	//thread (knight_leap());
end

script static void knight_leap()
	sleep_until (gh_bishop_spawned == TRUE);
	sleep (30);
	pup_play_show ("knight_leap");
	dprint ("knight leaping");
end

script static void OnCompleteProtoSpawn()
	print ("BLARSH");
end

script command_script gh_first_knight_rush()
	//cs_go_to (ps_knight_move.p2, 0.5);
	cs_phase_to_point (ps_knight_move.p2);
end

script dormant grassy_hill_end_blip_gone()
	sleep_until (volume_test_players (tv_grassy_hill_end_flag), 1);
	//sleep_forever (grassy_hill_end_blip);
	f_unblip_flag (grassy_hill_end_flag);
	thread (f_door_hallway_1_out_open());

end

// =================================================================================================
// =================================================================================================
// *** OBSERVATORY ***
// =================================================================================================

// =================================================================================================
// =================================================================================================
// 
//	portal_count = 0; this is at the very start of the level
// 	portal_count = 5; this is after the first button has been activated
// 	portal_count = 10; this is after the first pylon has been activated
//  portal_count = 15; this is after the second button has been activated
//  portal_count = 20; this is after the second pylon has been activated
//  portal_count = 25; this is after the final button has been activated
//
// =================================================================================================
// =================================================================================================

script static void observation_deck_setup()
	wake (first_time_through);
	wake (second_time_through);
	wake (final_time_through);
	wake (left_portal_activate);
	wake (first_time_through_sky);
	wake (second_time_through_sky);
	wake (second_time_through_cryptshield);
	wake (final_time_through_sky);
end

script dormant first_time_through()
	sleep_until (volume_test_players (tv_portal_1) and (portal_count == 0), 1);
		
	zone_set_trigger_volume_enable ("begin_zone_set:2_start", FALSE);
	zone_set_trigger_volume_enable ("zone_set:2_start", FALSE);
	
	zone_set_trigger_volume_enable ("begin_zone_set:3_donut", FALSE);
	zone_set_trigger_volume_enable ("zone_set:3_donut", FALSE);
	device_set_power (deck_button, 0); // turn the power off until the converation is finished
	
	pup_play_show(pyelectric_hide);
	
	sleep_until (volume_test_players (tv_didact_portal_open), 1);
	
	// audio stinger when player enters the observatory for the first time
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_30_observation_deck_stinger_1', NONE, 1);
		
	sleep_until (b_first_time_dialog_over == TRUE);
	device_group_set_immediate (deck_switch_group, 1);
	
	if b_relay_cine_done == FALSE then
		f_blip_flag (deck_switch_blip, "activate");

	else
	
		dprint ("you already hit it, no need to blip");
		
	end

end

script static void aa_turret_1_float()
	object_set_physics (pve_turret_1, FALSE);
	
	repeat
    object_move_by_offset(pve_turret_1, 2, 0.0, 0.0, -0.05);
    sleep (20);
    object_move_by_offset(pve_turret_1, 2, 0.0, 0.0, 0.05);
  until (object_get_parent (pve_turret_1) != none);

	dprint ("aa picked up, looping anim cancelled");

end

script static void aa_turret_2_float()
	object_set_physics (pve_turret_2, FALSE);
	
	repeat
    object_move_by_offset(pve_turret_2, 2, 0.0, 0.0, -0.05);
    sleep (20);
    object_move_by_offset(pve_turret_2, 2, 0.0, 0.0, 0.05);
  until (object_get_parent (pve_turret_2) != none);

	dprint ("aa picked up, looping anim cancelled");

end

script static void aa_turret_3_float()
	object_set_physics (pve_turret_3, FALSE);
	
	repeat
    object_move_by_offset(pve_turret_3, 2, 0.0, 0.0, -0.05);
    sleep (20);
    object_move_by_offset(pve_turret_3, 2, 0.0, 0.0, 0.05);
  until (object_get_parent (pve_turret_3) != none);

	dprint ("aa picked up, looping anim cancelled");
end

script static void aa_turret_4_float()
	object_set_physics (pve_turret_4, FALSE);
	
	repeat
    object_move_by_offset(pve_turret_4, 2, 0.0, 0.0, -0.05);
    sleep (20);
    object_move_by_offset(pve_turret_4, 2, 0.0, 0.0, 0.05);
  until (object_get_parent (pve_turret_4) != none);

	dprint ("aa picked up, looping anim cancelled");
end

script dormant first_time_through_sky()
	sleep_until (volume_test_players (tv_od_sky_change) and (portal_count == 0), 1);
	
	dprint ("setting sky to default");
	SetSkyObjectOverride("");

	dprint ("Starting puppet pyelectric_01");
	id_for_pylon_pups = pup_play_show(pyelectric_01);

end


script dormant second_time_through_sky()
	sleep_until (volume_test_players (tv_od_sky_change) and (portal_count == 10), 1);
	
	dprint ("setting sky to 5 - m30_sky_obdeck_02");
	SetSkyObjectOverride("m30_sky_obdeck_02");

end

script dormant second_time_through_cryptshield()
	sleep_until (volume_test_players ("begin_zone_set:2_start") and (portal_count == 10), 1);
	dprint ("second_time_through_cryptshield");
	thread(set_cryptum_shield_stage(1, 2, FALSE));
end

script dormant final_time_through_sky()
	sleep_until (volume_test_players (tv_od_sky_change) and (portal_count == 20), 1);
	
	dprint ("setting sky to 6 - m30_sky_obdeck_03");
	SetSkyObjectOverride("m30_sky_obdeck_03");

	thread(set_cryptum_shield_stage(1, 3, FALSE));
end


script dormant second_time_through()
	sleep_until (volume_test_players (tv_portal_1) and (portal_count == 10), 1);
	
	zone_set_trigger_volume_enable ("begin_zone_set:2_start", TRUE);
	zone_set_trigger_volume_enable ("zone_set:2_start", TRUE);
	
	zone_set_trigger_volume_enable ("begin_zone_set:3_donut", FALSE);
	zone_set_trigger_volume_enable ("zone_set:3_donut", FALSE);
		
	sleep_until (volume_test_players (tv_didact_portal_open) and (portal_count == 10), 1);

	// audio stinger when player enters the observatory for the second time
	sound_impulse_start('sound\environments\solo\m030\amb_m30_beta\amb_30_observation_deck_stinger_2', NONE, 1);
	
	dprint ("incoming covvie fleet");
	
	// covenant ship shows
	pup_play_show ("obs_fleet1"); // ships
	pup_play_show(obs_fleet1_portals); // portal fx
	
	wake (right_portal_activate);
end

script dormant final_time_through()
	sleep_until (volume_test_players (tv_portal_1) and (portal_count == 20), 1);
	
	zone_set_trigger_volume_enable ("begin_zone_set:2_start", FALSE);
	zone_set_trigger_volume_enable ("zone_set:2_start", FALSE);
	
	zone_set_trigger_volume_enable ("begin_zone_set:3_donut", TRUE);
	zone_set_trigger_volume_enable ("zone_set:3_donut", TRUE);
		
	sleep_until (b_final_time_through == TRUE and volume_test_players (tv_didact_portal_open), 1);
	
	wake (center_portal_activate);
	
	pup_play_show ("obs_fleet2");

end

script dormant left_portal_activate()
	sleep_until (device_get_position (deck_button) != 0);

	device_group_set_immediate (deck_switch_group, 0);

	f_unblip_flag (deck_switch_blip);
	
	local long relay_cin_intro = pup_play_show (relay_cin_intro);
	
	sleep_until (not pup_is_playing(relay_cin_intro) , 1);
	
	wake (M30_Console_Button_one);
	
	sleep_until (b_didact_portal_open == TRUE);
	
	sleep_until (device_get_position (observation_portal_01) >= 0.90) and (b_didact_portal_open == TRUE);

	portal_count = 5;
	//f_blip_flag (left_portal_loc, "default");
	print ("portal count set to 5");
	print ("portal to first pylon is open!");
	thread (left_portal_teleport());
	
	f_unblip_flag (deck_switch_blip);
	
end

script dormant right_portal_activate()
//	sleep_until (device_get_position (right_button) != 0);
	device_group_set_immediate (deck_switch_group, 0);

	observation_portal_02->f_animate();
	
	sleep_until (device_get_position (observation_portal_02) >= 0.90);
	
	portal_count = 15;
	//f_blip_flag (right_portal_loc, "default");
	wake (M30_Console_Button_two);
	print ("portal count set to 15");
	print ("portal to second pylon is open!");
	thread (right_portal_teleport());

end

script dormant center_portal_activate()
//	sleep_until (device_get_position (center_button) != 0);
	device_group_set_immediate (deck_switch_group, 0);

	pup_play_show ("obs_donut_portal");
	thread (observation_stairs_go());
	
	sleep (30);
	
	thread (observation_platform_go());
	thread (observation_supports_go());
	
//	sleep_until (device_get_position (observation_portal_03) >= 0.85);
	
	portal_count = 25;
	//f_blip_flag (center_portal_loc, "default");
//	wake (M30_Console_Button_three);
	print ("portal count set to 25");
	print ("portal to the cryptum platform is open!");
	thread (center_portal_teleport());

end

script static void observation_stairs_go
	observation_stairs->f_animate();
end

script static void observation_platform_go
	//observation_deck_01->f_animate();
	dprint ("old script, no use no more");
end

script static void observation_supports_go
	//observation_deck_support_01->f_animate();
	dprint ("old script, no use no more");
end

script static void left_portal_teleport()
	sleep_until (volume_test_players (tv_left_portal_teleport) and (portal_count == 5), 1);
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleports.p0);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);
	
	f_unblip_flag (deck_switch_blip);
	dprint ("setting sky to default");
	SetSkyObjectOverride("");

	object_teleport (player0, caves_teleport_flag_1);
	object_teleport (player1, caves_teleport_flag_2);
	object_teleport (player2, caves_teleport_flag_3);
	object_teleport (player3, caves_teleport_flag_4);
	
	print ("TELEPORT!");
	pup_play_show ("start_1_portal");
	
	dprint ("Starting puppet pyelectric_02");
	id_for_pylon_pups = pup_play_show(pyelectric_02);

	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	
	game_save();
	
end

script static void right_portal_teleport()
	sleep_until (volume_test_players (tv_right_portal_teleport) and (portal_count == 15), 1);
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleports.p2);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);
	
	dprint ("setting sky to default");
	SetSkyObjectOverride("");

	object_teleport (player0, flag_2_start_1);
	object_teleport (player1, flag_2_start_2);
	object_teleport (player2, flag_2_start_3);
	object_teleport (player3, flag_2_start_4);
	
	print ("TELEPORT!");
	pup_play_show ("start_2_portal");
	
	pup_play_show(pyelectric2_01);
	
	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	
	game_save();
	
	sleep (5);
	
	object_destroy (obs_octopus1);
	object_destroy (obs_octopus2);
	
	
end

script static void center_portal_teleport()
	sleep_until (volume_test_players (tv_center_portal_teleport) and (portal_count == 25), 1);
	
	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleports.p1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	fade_out_for_player (player0);
	fade_out_for_player (player1);
	fade_out_for_player (player2);
	fade_out_for_player (player3);
	
	dprint ("setting sky to default");
	SetSkyObjectOverride("");

	object_teleport (player0, flag_donut_1);
	object_teleport (player1, flag_donut_2);
	object_teleport (player2, flag_donut_3);
	object_teleport (player3, flag_donut_4);
	print ("TELEPORT!");
	pup_play_show ("donut_portal");
	
	fade_in_for_player (player0);
	fade_in_for_player (player1);
	fade_in_for_player (player2);
	fade_in_for_player (player3);
	
	object_destroy (obs_octopus3);
	
end
	
script static void prepare_obs_fleet1( object_name cruiser, object_name phantom1, object_name phantom2 )
  object_create(cruiser);
  object_create(phantom1);
  object_create(phantom2);

	// NOTE: temporarily disable imposters to see the phantoms
	object_cinematic_visibility(cruiser,true);
	object_cinematic_visibility(phantom1,true);
	object_cinematic_visibility(phantom2,true);
	object_cinematic_lod(phantom1,true);
	object_cinematic_lod(phantom2,true);
	
	// Turn on the shield fx for the cruiser and phantoms
	obs_fleet_shields_on(cruiser, phantom1, phantom2);	
end

script static void prepare_obs_fleet2()
	object_create_folder(sc_obs_fleet2);

	// NOTE: temporarily disable imposters to see the phantoms
	object_cinematic_visibility(obs_phantom3_4,true);
	object_cinematic_visibility(obs_phantom3_5,true);
	object_cinematic_visibility(obs_phantom3_6,true);
	object_cinematic_visibility(obs_phantom3_7,true);
	object_cinematic_lod(obs_phantom3_4,true);
	object_cinematic_lod(obs_phantom3_5,true);
	object_cinematic_lod(obs_phantom3_6,true);
	object_cinematic_lod(obs_phantom3_7,true);
end
