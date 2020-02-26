//=============================================================================================================================
//============================================ E10_M2 CAVERN KILL SCRIPT ==================================================
//=============================================================================================================================
global boolean b_e10m2_covenant_all_dead = FALSE;
global boolean b_e10m2_app_1_done = FALSE;
global boolean b_e10m2_app_2_done = FALSE;
global boolean b_e10m2_app_main_done = FALSE;
global boolean b_e10m2_app_switch_done = FALSE;
global boolean b_e10m2_back_up_done = FALSE;
global short e10m2_rumble = 0;
global object g_ics_player_e10_m2 = none;
global long l_e10m2_pawn1 = -1;
global long l_e10m2_pawn2 = -1;
global long l_e10m2_pawn2_5 = -1;
global long l_e10m2_pawn3 = -1;
global long l_e10m2_pawn4 = -1;
global long l_e10m2_pawn6 = -1;
global long l_e10m2_pawn7 = -1;

script startup f_cavern_e10_m2()
	//Wait for the variant event
	if ( f_spops_mission_startup_wait("e10_m2") ) then
		wake( f_cavern_e10_m2_placement );
	end
end

script dormant f_cavern_e10_m2_placement()
	f_spops_mission_setup( "e10_m2", e10_m2_dz_1, gr_ff_e10_m2_all, sp_e10_m2_start_pos, 80 );
	print("___________________________________running e10 m2");
//	fade_out(0,0,0,15);

//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e10_m2_dms);
	f_add_crate_folder(e10m2_outside_crates);
	f_add_crate_folder(e10m2_inside_crates);
	f_add_crate_folder(e10m2_inside_crates_weapons);
	f_add_crate_folder(e10m2_inside_crates_lights);
	f_add_crate_folder(e10_m2_rails);
	f_add_crate_folder(e10m2_dcs);
	f_add_crate_folder(e10_m2_cov_turrets);
	f_add_crate_folder(w_e10_m2_weapons);

	firefight_mode_set_objective_name_at(e10m2_switch_1, 1);
	firefight_mode_set_objective_name_at(e10m2_switch_2, 2);
	firefight_mode_set_objective_name_at(e10m2_switch_3, 3);
	firefight_mode_set_objective_name_at(cavern_fdoor_dc, 4);
	firefight_mode_set_objective_name_at(e10m2_bridge_control, 5);
	firefight_mode_set_objective_name_at(e10m2_switch_back_door, 6);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sp_e10_m2_start_pos, 80);
	firefight_mode_set_crate_folder_at(sp_e10_m2_01, 81);
	firefight_mode_set_crate_folder_at(sp_e10_m2_02, 82);
	firefight_mode_set_crate_folder_at(sp_e10_m2_03, 83);
	firefight_mode_set_crate_folder_at(sp_e10_m2_04, 84);
	firefight_mode_set_crate_folder_at(sp_e10_m2_05, 85);
	firefight_mode_set_crate_folder_at(sp_e10_m2_06, 86);
	firefight_mode_set_crate_folder_at(sp_e10_m2_07, 87);
	firefight_mode_set_crate_folder_at(sp_e10_m2_08, 88);
	
//set objective names
	firefight_mode_set_objective_name_at(e10_m2_lz_00, 50);
	firefight_mode_set_objective_name_at(e10_m2_lz_01, 51);
	firefight_mode_set_objective_name_at(e10_m2_lz_02, 52);
	firefight_mode_set_objective_name_at(e10_m2_lz_03, 53);
	firefight_mode_set_objective_name_at(e10_m2_lz_04, 54);
	firefight_mode_set_objective_name_at(e10_m2_lz_05, 55);
	firefight_mode_set_objective_name_at(e10_m2_lz_06, 56);
		
//set squad group names
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_1, 1);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_2, 2);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_3, 3);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_4, 4);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_5, 5);
	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_6, 6);
	
	thread(f_e10_m2_intro());
	
	sleep_s(0.5);
	
	// Destroy Crates
	sleep_until(object_valid(cr_ff153_caverns_bridge_a), 1);
	object_move_by_offset(cr_ff153_caverns_bridge_a, 0, 0, 0, -10);
	sleep_until(object_valid(cr_ff153_caverns_bridge_b), 1);
	object_move_by_offset(cr_ff153_caverns_bridge_b, 0, 0, 0, -10);

  object_destroy(e8m3_base_1);
  object_destroy(e8m3_pod_1);
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );	
end

//----------------------------------------------------------------------------------------------------------------------------	
//-------------------------------------- OBJECTS END -------------------------------------------------------------------------

//--------- Starting Mission stuff --------------------------------------
//-----------------------------------------------------------------------
script command_script cs_e10m2_pawn_spawn()
	sleep_rand_s (0.1, 0.8);
	ai_exit_limbo(ai_current_actor);
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e10m2_knight_spawn()
	sleep_rand_s (0.1, 0.8);
	cs_phase_in_blocking();
	ai_exit_limbo(ai_current_actor);
end

script command_script cs_e10_m2_bishop_spawn()
	sleep_rand_s (0.1, 0.8);
	object_set_scale(ai_get_object(ai_current_actor), 0.1, 1); 		//Shrink size over time
	sleep(10);
	ai_exit_limbo(ai_current_actor);
	sleep(40);
	object_set_scale(ai_get_object(ai_current_actor), 1, 50);			 //grow size over time
end

script static void f_e10_m2_call_intro_vo()
	thread(vo_e10m2_narr_in());
end

script static void f_e10_m2_intro()
	sleep_until (f_spops_mission_ready_complete(), 1);
	sleep_s(1);
	
	streamer_pin_tag("levels\dlc\shared\textures\cave\mp_cavern\mp_caverns_extrcktile_02_diff.bitmap");
	streamer_pin_tag("levels\dlc\shared\textures\cave\mp_cavern\mp_breach_rock_01_normal.bitmap");
	streamer_pin_tag("levels\dlc\shared\textures\cave\mp_cavern\mp_breach_rock_02_normal.bitmap");
	streamer_pin_tag("levels\dlc\shared\Textures\Cave\mp_cavern\mp_caverns_intrcktile_smooth_01_normal.bitmap");
	
	if editor_mode() then
		print ("editor mode, no intro playing");
	else
		pup_disable_splitscreen(TRUE);
		//sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m1_vin_sfx_intro', NONE, 1);
		ai_enter_limbo(gr_ff_e10_m2_all);
		local long intro_show = pup_play_show(e10m2_in);
		sleep_until(not pup_is_playing(intro_show), 1);
		pup_disable_splitscreen(FALSE);
	end

	f_spops_mission_intro_complete( TRUE );
	sleep_until( f_spops_mission_start_complete(), 1 );
	
	sleep_s(1);
	
	thread(f_e10_m2_music_start());
	object_set_scale(caverns_app_oct, 0.6, 1);
	
	fade_in(0,0,0,30);
	ai_exit_limbo(gr_ff_e10_m2_all);
	
	ai_place(e10m2_pelican_in);
	thread(f_e10_m2_cavern_back_up_door());
	ai_place(e10_m2_tower_1);
	ai_place(e10_m2_tower_2);
	
	thread(f_e10_m2_event0_start());
	
	sleep_s(3);
	vo_e10m2_door_fight();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	b_end_player_goal = TRUE;
	f_new_objective(e10_m2_obj_01);
	thread(f_e10m2_at_door());
	sleep_s(2);
	vo_e10m2_near_door();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_s(2);
	f_e10_m2_kill_towers();
	thread(f_e10_m2_shut_down_tower_1());
	thread(f_e10_m2_shut_down_tower_2());
	thread(f_e10_m2_cov_cavern_fighting());
end

script static void f_e10_m2_cavern_back_up_door()
	sleep_until(b_e10m2_back_up_done == TRUE, 1);
	if not volume_test_players(t_e10m2_backup) then
		ai_place(e10_m2_guards_2);
	end
end

script static void f_e10m2_at_door() 
// Crimson gets to door, its locked. Kill enough dudes to open it. Controls become actuve.
	sleep_until(LevelEventStatus ("e10_m2_at_door"), 1);
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	vo_e10m2_button_fail();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_s(1);
	f_new_objective(e10_m2_obj_02);
	sleep_s(2);
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 10, 1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	vo_e10m2_badguys();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 5, 1);
	sleep_s(1.5);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	f_blip_ai_cui(gr_ff_e10_m2_all, "navpoint_enemy");
	vo_e10m2_almost_done();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);

	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 3, 1);
	
	thread(f_e10_m2_event0_stop());
	vo_e10m2_all_done();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	ai_set_task(gr_ff_e10_m2_all, e10_m2_outside_right, guard_door);
	
	//b_end_player_goal = TRUE;   // <-- moved to narrative
	
	thread(f_e10_m2_front_door_open());
	device_set_power(cavern_fdoor_dc, 1);
	device_set_power(cavern_front_door, 1);
	sleep_until(device_get_position(cavern_fdoor_dc) > 0, 1);
	
	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long front_door_show = pup_play_show(pup_e10_m2_front_door);
		sleep_until(not pup_is_playing(front_door_show), 1);    
 	end
 	
 	device_set_power(cavern_fdoor_dc, 0); 
 	
	device_set_position(cavern_front_door_button, 1);
	sleep_until(device_get_position(cavern_front_door_button) == 1, 1);
	sound_impulse_start('sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', cavern_front_door_button, 1); //AUDIO!
	object_dissolve_from_marker(cavern_front_door_button, phase_out, button_marker);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_cavern_door_open_mnde9186', cavern_front_door, 1 ); //AUDIO!
	device_set_position(cavern_front_door, 1);
	
	object_create_anew(e10m2_bridge_panel);
	object_create_anew(e10m2_app_panel_1);
	object_create_anew(e10m2_app_panel_2);
	object_create_anew(e10m2_app_panel_main);
end

script static void f_e10_m2_kill_towers() 
// kill any towers that still exist outside.
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	if object_get_health(cr_e6_m3_pod_top_1) > 0 or object_get_health(cr_e6_m3_pod_top_2) > 0 then
		object_cannot_take_damage(cr_e6_m3_pod_top_1);
		object_cannot_take_damage(cr_e6_m3_pod_top_2);
		vo_e10m2_still_firing();
		sleep_s(1);
		sleep_until(e10m2_narrative_is_on == FALSE, 1);
		sleep_s(2);
		if object_get_health(cr_e6_m3_pod_top_1) > 0 then
			f_e10_m2_explode_gennie(f_e10m2_pod_1_contrail, f_e10m2_pod_1_damage);
			object_can_take_damage(cr_e6_m3_pod_top_1);
			damage_object(cr_e6_m3_pod_top_1, "default", 5000);
			damage_object(e6_m3_cov_base_01, "default", 5000);
			object_set_phantom_power(e6_m3_cov_base_01, FALSE);
		end
		sleep_s(1);
		if object_get_health(cr_e6_m3_pod_top_2) > 0 then
			f_e10_m2_explode_gennie(f_e10m2_pod_2_contrail, f_e10m2_pod_2_damage);
			object_can_take_damage(cr_e6_m3_pod_top_2);
			damage_object(cr_e6_m3_pod_top_2, "default", 5000);
			damage_object(e6_m3_cov_base_02, "default", 5000);
			object_set_phantom_power(e6_m3_cov_base_02, FALSE);
		end
	end
end

script static void f_e10_m2_shut_down_tower_1()
	sleep_until(object_get_health(cr_e6_m3_pod_top_1) <= 0, 1);
	object_set_phantom_power(e6_m3_cov_base_01, FALSE);
end

script static void f_e10_m2_shut_down_tower_2()
	sleep_until(object_get_health(cr_e6_m3_pod_top_2) <= 0, 1);
	object_set_phantom_power(e6_m3_cov_base_02, FALSE);
end

script static void f_e10_m2_explode_gennie (cutscene_flag flag, cutscene_flag contrail)  //props tp TJ
	ordnance_drop (flag, "default");
	sleep(38);
	thread (f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.8, 2, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' ));
	effect_new (objects\vehicles\human\storm_pelican\fx\running\pelican_explosion.effect, flag);
	damage_new( 'objects\weapons\pistol\storm_target_laser\projectiles\damage_effects\airstrike_turret_round.damage_effect', flag);
end

script static void f_e10_m2_cov_cavern_fighting()
	sleep_until(volume_test_players(t_e10_m2_spawn_cov_cavern), 1);
	ai_place(e10_m2_int_gunners_1);
	ai_place(e10_m2_int_gunners_2);
	thread(f_e10_m2_spawn_back_door());
end

script command_script cs_e10m2_turret_1()
	ai_vehicle_enter(e10_m2_int_gunners_1, e10m2_t_1);
end

script command_script cs_e10m2_turret_2()
	ai_vehicle_enter(e10_m2_int_gunners_2, e10m2_t_2);
end
	
script static void f_e10_m2_front_door_open() 
//Crimson gets inside, gets to back door. Door is locked. Switch derezes out.
// Crimson kills guys until Roland tells them what to do.
	sleep_until(LevelEventStatus ("e10_m2_front_door_open"), 1);
	sleep_until((device_get_position(cavern_front_door) >= 0.5), 1);
	ai_set_objective(gr_ff_e10_m2_outside, e10_m2_survival_inside);
	ai_set_objective(gr_ff_e10_m2_guards_1, e10_m2_survival_inside);
	ai_set_objective(gr_ff_e10_m2_guards_2, e10_m2_survival_inside);
	ai_set_objective(gr_ff_e10_m2_guards_3, e10_m2_survival_inside);
	
	thread(f_e10_m2_start_beams());
	thread(f_e10_m2_move_cores());
  
  object_destroy(e10_m2_core_shell_1);
  object_destroy(e10_m2_core_shell_2);
  object_destroy(e10_m2_core_shell_main);  
	
	thread(f_e10_m2_armory());
	
	sleep_s(1);
	thread(f_e10_m2_event1_start());
	f_new_objective(e10_m2_obj_03);
	//b_end_player_goal = TRUE;
	object_create_anew(e10_m2_lz_01);
	navpoint_track_object_named(e10_m2_lz_01, "navpoint_goto");
	ordnance_show_nav_markers(FALSE);
	
	sleep_until(volume_test_players(t_e10_m2_loc_1), 1);
	f_unblip_object_cui(e10_m2_lz_01);
	vo_e10m2_enter_cavern();
	
	//move spawn folder to mouth of cave, on inside
	f_create_new_spawn_folder(81);
	
	sleep_s(25);
	vo_e10m2_back_switch();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	f_new_objective(e10_m2_obj_04);
	
	object_create_anew(e10_m2_lz_02);
	navpoint_track_object_named(e10_m2_lz_02, "navpoint_goto");
	
	thread(f_e10_m2_break_gunners_int());
		
	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
	f_unblip_object_cui(e10_m2_lz_02);
	sleep_s(2);
	thread(f_e10_m2_event1_stop());
	vo_e10m2_door_shut();
	sleep_s(1);
	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 5, 1);
	f_blip_ai_cui(gr_ff_e10_m2_all, "navpoint_enemy");
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_s(2);
	vo_e10m2_crimson_fights();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	//sleep_s(1);
	
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 0, 1);
	b_e10m2_covenant_all_dead = TRUE;
	kill_script(f_e10_m2_spawn_back_door);
	kill_script(f_e10_m2_armory);
	sleep_s(2);
	vo_e10m2_crimson_fights_more();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	f_new_objective(e10_m2_obj_05);
	prepare_to_switch_to_zone_set(e10_m2_dz_2);
end

script static void f_e10_m2_move_cores()
	object_create_anew(cavern_energycore_1);
	sleep(1);
	object_cannot_take_damage(cavern_energycore_1);
	sleep(1);
	object_move_to_flag(cavern_energycore_1, 2, f_app_1_core_out);
	sleep(1);
	object_create_anew(cavern_energycore_2);
	sleep(1);
  object_cannot_take_damage(cavern_energycore_2);
  sleep(1);
  object_move_to_flag(cavern_energycore_2, 2, f_app_2_core_out);
  sleep(1);
  object_create_anew(cavern_energycore_main);
  sleep(1);
  object_cannot_take_damage(cavern_energycore_main);
  sleep(1);
  object_move_to_flag(cavern_energycore_main, 2, f_app_main_core_out);
end

script static void f_e10_m2_start_beams()
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_bottom_fx_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_bottom_fx_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_2_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_2_cap);
	//sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_main_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg_on.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg_on.effect, f_app_main_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup_on.effect, f_app_main_top_fx_cap);
	sleep(5);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_bottom_fx_cap);
	if not object_valid( f_app_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_1_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_bottom_fx_cap);
	if not object_valid( f_app_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_2_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_2_cap);
	if not object_valid( f_app_switch_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_1_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_2_cap);
	if not object_valid( f_app_switch_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_2_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_app_main_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup.effect, f_app_main_top_fx_cap);
	
	if not object_valid( f_app_main_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_main_sfx_loop );
	end

	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_1_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_2_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_1_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_2_hardlight);
	
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx_lg.area_screen_effect, f_obj_main_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_1_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_2_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_1_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_2_glare);
end

script static void f_e10_m2_derez_that_switch()
	sleep_until(volume_test_players(t_e10_m2_derez_switch), 1);
	navpoint_track_object(e10m2_switch_back_door, FALSE);
	
	sound_impulse_start('sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', cavern_back_door_button, 1); //AUDIO!
	object_dissolve_from_marker(cavern_back_door_button, phase_out, button_marker);
	thread(f_e10_m2_stinger_derezzed_switch());
	sleep_s(2);
	
	// moves cores down, turns off FX, closes apps
	thread(f_e10_m2_close_app_1());
	thread(f_e10_m2_close_app_2());
	thread(f_e10_m2_close_app_main());
	thread(f_e10_m2_close_app_switch());
	thread(f_e10_m2_at_bridge_controls());
	
	//move spawn folder to back locked door
	f_create_new_spawn_folder(82);
	
	//sleep_s(1);
	vo_e10m2_switch_derez();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	object_hide(cavern_back_door_button, TRUE);
	sleep_s(1);
	
	//++++ zone set switch ++++++++++++++++++++
	print ("switching zone set");
	switch_zone_set(e10_m2_dz_2);
	//+++++++++++++++++++++++++++++++++++++++++
	
	object_create_anew(e10m2_bridge_panel);
	object_create_anew(e10m2_app_panel_1);
	object_create_anew(e10m2_app_panel_2);
	object_create_anew(e10m2_app_panel_main);

	object_hide(cavern_back_door_button, TRUE);
	object_hide(cavern_app_main_bottom, TRUE);

	sleep_s(0.5);
		
	vo_e10m2_forerunners_first_arrive();
	thread(f_e10_m2_knight_1_scream());
	thread(f_e10_m2_knight_2_scream());
	
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 3, 1);
	sleep_s(1);
	vo_e10m2_figured_it_out();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_s(1);
	vo_e10m2_light_bridge();
	thread(f_e10_m2_event2_start());
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	sleep_s(1);

	thread(f_e10_m2_bishop_switch());
	
	b_end_player_goal = TRUE;
	f_new_objective(e10_m2_obj_06);
	object_create_anew(e10m2_bridge_panel);
	device_set_power(e10m2_bridge_control, 1);
	object_create_anew(f_lightbridge_flag);
	navpoint_track_object_named(f_lightbridge_flag, "navpoint_activate");
	
	thread(f_e10_m2_at_security_office());
	
//	vo_e10m2_forerunners_first_arrive();  // replace with new lines.
//	sleep_s(1);
//	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	sleep_s(4);
	sleep_until(ai_living_count(gr_e10m2_fr_brg_ctr_g) <= 2, 1);
	sleep_s(1);
		
	//effects_perf_armageddon = 0;
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_1); 
	sleep_s(0.5);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_1);
	sleep_s(2);
	ai_place_in_limbo(e10_m2_1st_bishops);
	sleep_s(3);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_1);
	sleep_s(1.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_1);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_1);
	//effects_perf_armageddon = 1;
	
	sleep_s(16);
	l_e10m2_pawn1 = ai_place_with_shards(e10_m2_pawns_1);
	l_e10m2_pawn2 = ai_place_with_shards(e10_m2_pawns_2);
end

script static void f_e10_m2_break_gunners_int()
	sleep_until(volume_test_players(t_e10_m2_loc_4), 1);
	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
end

script static void f_e10_m2_bishop_switch()
	//effects_perf_armageddon = 0;
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_ctrl); 
	sleep_s(0.5);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_ctrl);
	sleep_s(2);
	ai_place_in_limbo(e10m2_int_fr_ctrl_b);
	sleep_s(3);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_ctrl);
	sleep_s(1.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_ctrl);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_ctrl);
	//effects_perf_armageddon = 1;
	vo_glo15_miller_watchers_01();
end
  
script static void f_e10_m2_armory()
	sleep_until(volume_test_players(t_e10_m2_arms), 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 13 and b_e10m2_covenant_all_dead == FALSE then
		ai_place(e10_m2_armory_guards);
	end
end	

script static void f_e10_m2_at_bridge_controls()
// Crimson turns on bridge
// Roland tells them to go to the main structure.
// Crimson gets there, switch activates
	sleep_until(LevelEventStatus ("e10_m2_at_bridge_controls"), 1);
	navpoint_track_object(f_lightbridge_flag, FALSE);
	
	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long light_bridge_show = pup_play_show(pup_e10_m2_light_bridge);
		sleep_until(not pup_is_playing(light_bridge_show), 1);
	end  
	
	device_set_power(e10m2_bridge_control, 0);
 	
 	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_switchforlightbridge_mnde861', e10m2_bridge_panel, 1 ); //AUDIO!
	device_set_position(e10m2_bridge_panel, 1);
	sleep_until(device_get_position(e10m2_bridge_panel) == 1, 1);
	//e10m2_bridge_panel->SetDerezWhenActivated();
	object_dissolve_from_marker(e10m2_bridge_panel, phase_out, panel);
	thread(f_e10m2_switch3_1_guards());
	thread(f_e10m2_switch3_2_guards());

	thread(f_e10m2_bridge_a());
	sleep_s(1);
	thread(f_e10m2_bridge_b());
	thread(f_e10_m2_rumble_2());
	
	sleep_s(2);
	vo_e10m2_security_room();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	f_new_objective(e10_m2_obj_07);
	
	thread(f_e10m2_pawn5());
	
	object_create_anew(e10_m2_lz_06);
	navpoint_track_object_named(e10_m2_lz_06, "navpoint_goto");
	
	sleep_s(3);
	
	thread(f_e10m2_bishops_3());
		
	sleep_until(volume_test_players(t_e10_m2_switch_3_2), 1);
	object_destroy(e10_m2_lz_06);
	sleep_s(1);
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 12, 1);
	sleep_s(1);
	vo_e10m2_inside_room();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	f_new_objective(e10_m2_obj_08);
	kill_script(f_e10m2_pawn5);
	
	object_create_anew(e10m2_app_panel_main);
	b_end_player_goal = TRUE;
	device_set_power(e10m2_switch_3, 1);
	object_create_anew(f_switch_main);
	navpoint_track_object_named(f_switch_main, "navpoint_activate");
end

script static void f_e10m2_bridge_a()
	object_hide(cr_ff153_caverns_bridge_a, TRUE);
	sleep_s(0.25);
	object_move_by_offset(cr_ff153_caverns_bridge_a, 0, 0, 0, 10);
	sleep_s(0.25);
	object_create_anew(cr_ff153_caverns_bridge_a);
	if not object_valid( light_bridge_audio_a ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_hardlight_bridge_on_mnde861', cr_ff153_caverns_bridge_a, 1 ); //AUDIO!
		object_create( light_bridge_audio_a );
	end
end

script static void f_e10m2_bridge_b()
	object_hide(cr_ff153_caverns_bridge_b, TRUE);
	sleep_s(0.25);
	object_move_by_offset(cr_ff153_caverns_bridge_b, 0, 0, 0, 10);
	sleep_s(0.25);
	object_create_anew(cr_ff153_caverns_bridge_b);
	if not object_valid( light_bridge_audio_b ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BRIDGE AUDIO!
		sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_hardlight_bridge_on_mnde861', cr_ff153_caverns_bridge_b, 1 ); //AUDIO!
		object_create( light_bridge_audio_b );
	end
end

script static void f_e10m2_pawn5()
	sleep_until(ai_living_count(gr_ff_e10_m2_pawns_1) == 0, 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 13 then
		ai_place_in_limbo(e10_m2_pawns_5);
	end
	sleep_s(5);
	
	sleep_until(ai_living_count(gr_ff_e10_m2_pawns_2) == 0, 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 13 then
		ai_place_in_limbo(e10_m2_pawns_7);
	end
end

script static void f_e10m2_bishops_3()
	sleep_until(volume_test_players(t_e10_m2_bishop_3), 1);
	DestroyDynamicTask(l_e10m2_pawn1);
	DestroyDynamicTask(l_e10m2_pawn2);
	ai_set_task(e10m2_int_fr_ctrl_b, e10_m2_obj_bishop_1, guard_general);
	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 10, 1);
	
	//effects_perf_armageddon = 0;
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_3); 
	sleep_s(0.5);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_3);
	sleep_s(2);
	ai_place_in_limbo(e10_m2_3rd_bishops);
	sleep_s(3);
	effect_new (levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_3);
	sleep_s(1.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_3);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_3);
	//effects_perf_armageddon = 1;
	
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	vo_glo15_miller_watchers_02();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	if ai_living_count(gr_ff_e10_m2_all) <= 13 then
		l_e10m2_pawn6 = ai_place_with_shards(e10_m2_pawns_6);
	end
	sleep_s(5);
	if ai_living_count(gr_ff_e10_m2_all) <= 13 then
		l_e10m2_pawn7 = ai_place_with_shards(e10_m2_pawns_7);
		DestroyDynamicTask(l_e10m2_pawn6);
	end
	sleep_s(5);
	if ai_living_count(gr_ff_e10_m2_all) <= 13 then
		l_e10m2_pawn3 = ai_place_with_shards(e10_m2_pawns_3);
		DestroyDynamicTask(l_e10m2_pawn6);
		DestroyDynamicTask(l_e10m2_pawn7);
	end
end

script static void f_e10m2_switch3_1_guards()
	sleep_until(volume_test_players(t_e10_m2_switch_3_1), 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 17 then
		ai_place_in_limbo(e10_m2_int_fr_switch_3_1_k);
	end
	
	sleep_s(1);
	
	if ai_living_count(gr_ff_e10_m2_all) <= 15 then
		ai_place_in_limbo(e10_m2_int_fr_switch_3_1_b);
	end
	
	sleep_s(1);
	
	if ai_living_count(gr_ff_e10_m2_all) <= 11 then
		ai_place_with_shards(e10_m2_int_fr_switch_3_1_p);
	end
		
	if ai_living_count(gr_e10m2_fr_stch_3_1_k) >= 1 then
		cs_custom_animation(e10_m2_int_fr_switch_3_1_k.knight, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
	end
end

script static void f_e10m2_switch3_2_guards()
	sleep_until(volume_test_players(t_e10_m2_switch_3_2), 1);
	DestroyDynamicTask(l_e10m2_pawn6);
	DestroyDynamicTask(l_e10m2_pawn7);
	DestroyDynamicTask(l_e10m2_pawn3);
	thread(f_e10_m2_event2_stop());
	ai_set_task(gr_e10m2_fr_stch_3_2, e10_m2_obj_switches, guard_2);
	ai_set_task(gr_e10m2_fr_stch_3_2_b, e10_m2_obj_bishop_2, guard);
	ai_place_in_limbo(e10_m2_int_fr_stch_3_2_p);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_int_fr_stch_3_2_k);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_int_fr_switch_3_2_b);
	f_create_new_spawn_folder(85);	
end

script static void f_e10_m2_at_security_office()
// Crimson turns it on to start power back up. Roland directs them to terminal 1. Crimson activates terminal 1
// Roland directs them to terminal 2. Crimson activates terminal 2. Back door switch activates
	sleep_until(LevelEventStatus ("e10_m2_at_security_office"), 1);
	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
	sleep_s(1);
	
	if ai_living_count(gr_e10m2_fr_stch_3_1_b) > 0 then
		ai_set_objective(gr_e10m2_fr_stch_3_1_b, e10_m2_survival_bishop);
	end
	if ai_living_count(gr_e10m2_fr_stch_3_2_b) > 0 then
		ai_set_objective(gr_e10m2_fr_stch_3_2_b, e10_m2_survival_bishop);
	end
	if ai_living_count(e10_m2_1st_bishops) > 0 then
		ai_set_objective(e10_m2_1st_bishops, e10_m2_survival_bishop);
	end
	if ai_living_count(e10_m2_3rd_bishops) > 0 then
		ai_set_objective(e10_m2_3rd_bishops, e10_m2_survival_bishop);
	end

	thread(f_e10_m2_event3_start());
	navpoint_track_object(f_switch_main, FALSE);
	
	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long main_switch_show = pup_play_show(pup_e10_m2_switch_main);
		sleep_until(not pup_is_playing(main_switch_show), 1);
	end
	 
	device_set_power(e10m2_switch_3, 0);

 	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_switchforlightbridge_mnde861', e10m2_app_panel_main, 1 ); //AUDIO!		
	device_set_position(e10m2_app_panel_main, 1);
	object_dissolve_from_marker(e10m2_app_panel_main, phase_out, panel);
	sleep_s(1);
	
	// opens main app
	thread(f_e10_m2_open_app_main());	
	sleep_until(b_e10m2_app_main_done == TRUE, 1);
	
	sleep_s(2);
	vo_e10m2_activate_ball_1();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	object_create_anew(e10_m2_lz_04);
	navpoint_track_object_named(e10_m2_lz_04, "navpoint_goto");
	
	thread(f_e10m2_power_switch_1());
	thread(f_e10m2_power_switch_2());
	
	if ai_living_count(gr_ff_e10_m2_all) <= 8 then
		thread(f_e10_m2_bishops_after_main());
	end
	
	sleep_until(volume_test_players(t_e10_m2_switch_2), 1);
	thread(f_e10_m2_event3_stop());
	f_create_new_spawn_folder(86);
	thread(f_e10_m2_event4_start());
	DestroyDynamicTask(l_e10m2_pawn4);
	DestroyDynamicTask(l_e10m2_pawn2_5);
	ai_place_in_limbo(e10_m2_int_fr_stch_2_p);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_int_fr_stch_2_k);
	ai_place_with_birth(e10_m2_int_fr_switch_2_b);
	
	sleep_s(1);
	vo_glo_incoming_03();
	sleep_s(1);
	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_2) <= 0, 1);
	sleep_s(2);
	object_destroy(e10_m2_lz_04);
	object_create_anew(e10m2_app_panel_2);
	object_create_anew(f_switch_2);
	navpoint_track_object_named(f_switch_2, "navpoint_activate");
	device_set_power(e10m2_switch_2, 1);
	f_new_objective(e10_m2_obj_09);
	thread(f_e10m2_at_power_2());
end	

script static void f_e10_m2_bishops_after_main()
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_2); 
	sleep_s(0.5);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_2);
	sleep_s(2);
	ai_place_in_limbo(e10_m2_2nd_bishops);
	sleep_s(3);
	effect_new(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect, f_e10m2_bishop_2);
	sleep_s(1.5);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_2);
	effect_delete_from_flag(levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect, f_e10m2_bishop_2);
	sleep_s(2);
	if ai_living_count(gr_ff_e10_m2_all) <= 8 then
		thread(f_e10_m2_pawns_to_station2());
	end
end

script static void f_e10_m2_pawns_to_station2()
	if ai_living_count(gr_ff_e10_m2_all) <= 8 then
		l_e10m2_pawn4 = ai_place_with_shards(e10_m2_pawns_4);
	end
	sleep_s(2);
	if ai_living_count(gr_ff_e10_m2_all) <= 8 then
		l_e10m2_pawn2_5 = ai_place_with_shards(e10_m2_pawns_2);
	end
end
	
script static void f_e10m2_at_power_2()
	sleep_until((device_get_position(e10m2_switch_2) > 0), 1);
	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long switch2_show = pup_play_show(pup_e10_m2_switch_2);
		sleep_until(not pup_is_playing(switch2_show), 1);
	end
	   
	device_set_power(e10m2_switch_2, 0);
	navpoint_track_object(f_switch_2, FALSE);

 	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_switchforlightbridge_mnde861', e10m2_app_panel_2, 1 ); //AUDIO!
	device_set_position(e10m2_app_panel_2, 1);
	sleep_until(device_get_position(e10m2_app_panel_2) > 0.2, 1);
	// opens 2nd app
	thread(f_e10_m2_open_app_2());
	
	//e10m2_app_panel_2->SetDerezWhenActivated();
	object_dissolve_from_marker(e10m2_app_panel_2, phase_out, panel);
	

	sleep_until(b_e10m2_app_2_done == TRUE, 1);
	sleep_s(4);
	thread(f_e10m2_going_to_power_1());
end

script static void f_e10m2_going_to_power_1()
	vo_e10m2_approach_ball_2();
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	
	sleep_until(volume_test_players(t_e10_m2_switch_1), 1);
	thread(f_e10_m2_event4_stop());
	f_create_new_spawn_folder(84);
	thread(f_e10_m2_event5_start());
	ai_place_in_limbo(e10_m2_int_fr_stch_1_p);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_int_fr_stch_1_k);
	ai_place_with_birth(e10_m2_int_fr_switch_1_b);
	sleep_s(1);
	vo_glo15_miller_prometheans_01();
	
	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_1) <= 0, 1);
	f_create_new_spawn_folder(87);
	sleep_s(1);
	object_destroy(e10_m2_lz_03);
	object_create_anew(e10m2_app_panel_1);
	object_create_anew(f_switch_1);
	navpoint_track_object_named(f_switch_1, "navpoint_activate");
	device_set_power(e10m2_switch_1, 1);
	f_new_objective(e10_m2_obj_10);
	sleep_until((device_get_position(e10m2_switch_1) > 0), 1);
	
	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long switch1_show = pup_play_show(pup_e10_m2_switch_1);
		sleep_until(not pup_is_playing(switch1_show), 1);
	end   
	device_set_power(e10m2_switch_1, 0);
	navpoint_track_object(f_switch_1, FALSE);

 	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_switchforlightbridge_mnde861', e10m2_app_panel_1, 1 ); //AUDIO!
	device_set_position(e10m2_app_panel_1, 1);
	sleep_until(device_get_position(e10m2_app_panel_1) > 0.2, 1);
	// opens up app 1
	thread(f_e10_m2_open_app_1());
	
	//e10m2_app_panel_1->SetDerezWhenActivated();
	object_dissolve_from_marker(e10m2_app_panel_1, phase_out, panel);
	
	sleep_until(b_e10m2_app_1_done == TRUE, 1);
	thread(f_e10m2_spawn_final_fr());
	sleep_s(2);
	vo_e10m2_button_rez();
	thread(f_e10_m2_event5_stop());
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	thread(f_e10_m2_at_back_door_controls_2());
	b_end_player_goal = TRUE;
	f_new_objective(e10_m2_obj_11);
	thread(f_e10_m2_event6_start());
		
	//opens switch app
	thread(f_e10_m2_open_app_switch());	
	sleep_until(b_e10m2_app_switch_done == TRUE, 1);
	
	sleep_s(2);
	
	object_create_anew(cavern_back_door_button);
	effect_new_at_ai_point(objects\characters\storm_pawn\fx\pawn_phase_in.effect, e10_m2_effects.p_e10m2_button_fx);
	object_create_anew(e10m2_switch_back_door);
	navpoint_track_object_named(e10m2_switch_back_door, "navpoint_activate");
	device_set_power(e10m2_switch_back_door, 1);
end

script static void f_e10m2_spawn_final_fr()
	sleep_until(volume_test_players(t_e10_m2_spawn_back_door), 1);
	ai_place_in_limbo(e10_m2_int_fr_final_p);
	sleep_s(1);
	ai_place_in_limbo(e10_m2_int_fr_final_k);
	sleep_s(3);
	ai_place_in_limbo(e10_m2_int_fr_final_k_2);
	sleep_s(5);
	ai_place_in_limbo(e10_m2_int_fr_final_p_2);
end

script static void f_e10_m2_at_back_door_controls_2()
	sleep_until(LevelEventStatus ("e10_m2_at_back_door_controls_2"), 1);
	 	
 	if ai_living_count(gr_ff_e10_m2_all) == 0 then
		local long back_door_show = pup_play_show(pup_e10_m2_back_door);
		sleep_until(not pup_is_playing(back_door_show), 1);  
	end 
	
	device_set_power(e10m2_switch_back_door, 0);
	navpoint_track_object(e10m2_switch_back_door, FALSE);
 	
	thread(f_e10_m2_event6_stop());
	
	sound_impulse_start ( 'sound\storm\multiplayer\pve\events\amb_forts_dm_spire_base_terminal_derez', cavern_back_door_button, 1 ); //AUDIO!
	object_dissolve_from_marker(cavern_back_door_button, phase_out, button_marker);
	device_set_power(cavern_back_door, 1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e10m3_retexturedtempledoor_open_mnde845', cavern_back_door, 1 ); //AUDIO!
	device_set_position(cavern_back_door, 1);
	sleep_until(device_get_position(cavern_back_door) >= 0.1, 1);
	thread(f_e10_m2_event7_start());
	vo_e10m2_button_door();
	sleep_s(1);
	object_create_anew(e10_m2_lz_07);
	object_destroy(cavern_back_door_button);
	navpoint_track_object_named(e10_m2_lz_07, "navpoint_goto");
	f_new_objective(e10_m2_obj_12);
	
	sleep_until(volume_test_players(t_e10_m2_end), 1);
	thread(f_e10_m2_event7_stop());
	thread(f_e10_m2_music_stop());
	f_end_mission();
	object_destroy(e10_m2_lz_07);
	b_end_player_goal = TRUE;
end

script static void f_e10m2_power_switch_1()
	sleep_until(device_get_position(e10m2_switch_1) > 0, 1);
	device_set_power(e10m2_switch_1, 0);
end

script static void f_e10m2_power_switch_2()
	sleep_until(device_get_position(e10m2_switch_2) > 0, 1);
	device_set_power(e10m2_switch_2, 0);
end

script static void f_e10_m2_spawn_back_door()
	sleep_until(volume_test_players(t_e10_m2_spawn_back_door), 1);
	if ai_living_count(gr_ff_e10_m2_all) <= 15 and b_e10m2_covenant_all_dead == FALSE then
		ai_place(e10_m2_int_back_door2);
	end
	thread(f_e10_m2_rumble_1());
	sleep_s(2);
	if ai_living_count(gr_ff_e10_m2_all) <= 15 and b_e10m2_covenant_all_dead == FALSE then
		ai_place(e10_m2_int_back_door);
	end
end

script static void f_e10_m2_close_app_1()
	object_move_to_flag(cavern_energycore_1, 2, f_app_1_core_hidden);
	sleep_s(2);
	sound_impulse_start('sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_1_bottom_fx, f_app_1_top_fx_cap);
	sleep(2);
	object_destroy ( f_app_1_sfx_loop ); //KILL AUDIO!
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_1_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_bottom_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_1_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_1_glare);
	interpolator_start(beam_front_off);
	interpolator_stop(beam_front_off);
end

script static void f_e10_m2_open_app_1()
	thread(f_e10_m2_stinger_power_core_1());	
	thread(f_app_1_fx_on());

	object_move_to_flag(cavern_energycore_1, 3, f_app_1_core_out);
	b_e10m2_app_1_done = TRUE;
	sleep_s(3);
	object_create_anew(e10_m2_core_shell_1);
	
	//thread (f_e10_m2_open_app_1_2());

	object_hide(e10_m2_core_shell_1, TRUE);
	object_move_to_point(e10_m2_core_shell_1, 0, e10_m2_effects.sphere_1);
	sleep(1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunnerbeam_powercore_appear_mnde870', cavern_energycore_1, 1 ); //AUDIO!
	object_dissolve_from_marker(e10_m2_core_shell_1, resurrect, inner_pos);
	object_hide(e10_m2_core_shell_1, FALSE);
	
	thread(f_app_1_shell_fx_on());
	
	object_cannot_take_damage(e10_m2_core_shell_1);
end

script static void f_e10_m2_open_app_1_2()
	object_create_anew(e10_m2_core_shell_1);
	dprint ( "THERE SHOULD BE A POWERCORE HERE!" );
end

script static void f_app_1_fx_on()
	interpolator_start(beam_front_off);	
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_1_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_1_bottom_fx_cap);
	sleep(5);
	
	if not object_valid( f_app_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_1_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_1_bottom_fx, f_app_1_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_1_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_1_hardlight);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_1_glare);
end

script static void f_app_1_shell_fx_on()
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_1_b);
end

script static void f_e10_m2_close_app_2()
	object_move_to_flag(cavern_energycore_2, 2, f_app_2_core_hidden);
	sleep_s(2);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_2_bottom_fx_cap);
	sleep(2);
	object_destroy ( f_app_2_sfx_loop ); //KILL AUDIO!
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_2_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_bottom_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_2_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_2_glare);
	interpolator_start(beam_middle_off);
	interpolator_stop(beam_middle_off);
end

script static void f_e10_m2_open_app_2()
	thread(f_e10_m2_stinger_power_core_2());
	thread(f_app_2_fx_on());
	
	object_move_to_flag(cavern_energycore_2, 3, f_app_2_core_out);
	b_e10m2_app_2_done = TRUE;
	sleep_s(3);

	object_create_anew(e10_m2_core_shell_2);
	//thread ( f_e10_m2_open_app_2_2() );

	object_hide(e10_m2_core_shell_2, TRUE);
	object_move_to_point(e10_m2_core_shell_2, 0, e10_m2_effects.sphere_2);
	sleep(1);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunnerbeam_powercore_appear_mnde870', cavern_energycore_2, 1 ); //AUDIO!
	object_dissolve_from_marker(e10_m2_core_shell_2, resurrect, inner_pos);
	object_hide(e10_m2_core_shell_2, FALSE);

	thread(f_app_2_shell_fx_on());
	
	object_cannot_take_damage(e10_m2_core_shell_2);
end

script static void f_e10_m2_open_app_2_2()
	object_create_anew(e10_m2_core_shell_2);
	dprint ( "THERE SHOULD BE A POWERCORE HERE!" );
end

script static void f_app_2_fx_on()
	interpolator_start(beam_middle_off);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_2_bottom_fx_cap);
	sleep(5);
	
	if not object_valid( f_app_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_2_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_2_bottom_fx, f_app_2_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_2_bottom_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_obj_2_hardlight);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_obj_2_glare);
end

script static void f_app_2_shell_fx_on()
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_e10m2_shell_2_b);
end

script static void f_e10_m2_close_app_main()
	object_move_to_flag(cavern_energycore_main, 2, f_app_main_core_hidden);
	sleep_s(2);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_main_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg_off.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup_off.effect, f_app_main_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg_off.effect, f_app_main_bottom_fx_cap);
	sleep(2);
	object_destroy ( f_app_main_sfx_loop ); //KILL AUDIO!
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg.effect, f_app_main_bottom_fx );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup.effect, f_app_main_top_fx_cap );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_app_main_bottom_fx_cap );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx_lg.area_screen_effect, f_obj_main_glare);
end

script static void f_e10_m2_open_app_main()
	thread(f_e10_m2_stinger_power_core_main());
	object_create_anew(cavern_app_main_bottom);
	object_hide(cavern_app_main_bottom, TRUE);
	object_set_scale(caverns_app_oct, 0.6, 1);
	object_dissolve_from_marker(cavern_app_main_bottom, phase_in, fx_eye);
	object_hide(cavern_app_main_bottom, FALSE);
	if not object_valid ( towercore_beam_main_sfx ) then
		object_create ( towercore_beam_main_sfx ); //TURN ON AUDIO FOR TOWERCORE MAIN!
	end
	
	pup_play_show(pup_e10_m2_main_app);
 	sleep_s(3);
	thread(f_e10_m2_main_shell_beam_on());
	sleep_s(1);
	object_move_to_flag(cavern_energycore_main, 3, f_app_main_core_out);
	sleep_s(3);
	
	object_create_anew(e10_m2_core_shell_main);	
	//thread (f_e10_m2_open_app_main_2());
	
	object_hide(e10_m2_core_shell_main, TRUE);
	object_move_to_point(e10_m2_core_shell_main, 0, e10_m2_effects.sphere_main);
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunnerbeam_powercore_appear_mnde870', cavern_energycore_main, 1 ); //AUDIO!
	sleep(1);
	object_dissolve_from_marker(e10_m2_core_shell_main, resurrect, inner_pos);
	object_hide(e10_m2_core_shell_main, FALSE);
	object_cannot_take_damage(e10_m2_core_shell_main);
	sleep_s(1);
	thread(f_e10_m2_main_shell_top_fx());
	b_e10m2_app_main_done = TRUE;
end

script static void f_e10_m2_open_app_main_2()
	object_create_anew(e10_m2_core_shell_main);
	dprint ( "THERE SHOULD BE A POWERCORE HERE!" );
end

script static void f_e10_m2_main_shell_beam_on()
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_main_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg_on.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup_on.effect, f_app_main_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg_on.effect, f_app_main_bottom_fx_cap);
	sleep(5);
	if not object_valid( f_app_main_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_main_sfx_loop );
	end

	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_lg.effect, f_app_main_bottom_fx, f_app_main_top_fx);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lgup.effect, f_app_main_top_fx_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_app_main_bottom_fx_cap);
end

script static void f_e10_m2_main_shell_top_fx()
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_t);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_e10m2_shell_m_b);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx_lg.area_screen_effect, f_obj_main_glare);
end

script static void f_e10_m2_close_app_switch()
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_switch_1_sfx, 1 ); //AUDIO!
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_off_mnde862', f_app_switch_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_off.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_off.effect, f_app_switch_bottom_fx_2_2_cap);
	sleep(2);
	object_destroy ( f_app_switch_1_sfx_loop ); //KILL AUDIO!
	object_destroy ( f_app_switch_2_sfx_loop ); //KILL AUDIO!
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_1);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_2);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_2_cap);
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_1_hardlight );
	effect_kill_from_flag(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_2_hardlight );
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_1_glare);
	screen_effect_delete(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_2_glare);
end

script static void f_e10_m2_open_app_switch()	
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_1_sfx, 1 ); //AUDIO!
	sound_impulse_start ( 'sound\environments\multiplayer\dlc1_caverns\dm\spops_dm_e10m2_forerunner_beam_turn_on_mnde862', f_app_switch_2_sfx, 1 ); //AUDIO!
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam_on.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_on.effect, f_app_switch_bottom_fx_2_2_cap);
	sleep(5);
	
	if not object_valid( f_app_switch_1_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_1_sfx_loop );
	end
	if not object_valid( f_app_switch_2_sfx_loop ) then //CREATE SOUND SCENERY OBJECT FOR LIGHT BEAM!
		object_create( f_app_switch_2_sfx_loop );
	end
	
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_1, f_app_switch_bottom_fx_1_2);
	effect_new_between_points(levels\dlc\ff153_caverns\fx\beams\dlc_beam.effect, f_app_switch_bottom_fx_2, f_app_switch_bottom_fx_2_2);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_1_2_cap);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap.effect, f_app_switch_bottom_fx_2_2_cap);
	
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_1_hardlight);
	effect_new(levels\dlc\ff153_caverns\fx\beams\dlc_beam_endcap_lg.effect, f_side_2_hardlight);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_1_glare);
	screen_effect_new(levels\dlc\ff153_caverns\fx\beams\parts\beam_screenfx.area_screen_effect, f_side_2_glare);
	
	b_e10m2_app_switch_done = TRUE;
end

script command_script cs_e10_m2_jumping_knight()
	cs_phase_in_blocking();
	sleep_s(1);
	cs_move_towards_point(e10_m2_effects.p0, 1);
	cs_jump(40, 12);
end

script static void f_end_mission()
	fade_out (0,0,0,60);
	player_control_fade_out_all_input (.1);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
end

script static void f_e10m2_random_rumble()
	repeat
		begin_random_count (1)
			sleep (120 * 30);
			sleep (180 * 30);
			sleep (60 * 30);
			sleep (90 * 30);
			sleep (150 * 30);
			sleep (150 * 30);
			sleep (30 * 30);
		end
	if e10m2_rumble == 0 then
		begin_random_count (1)
			f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.8, 2, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_med.sound' );
			f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), -0.3, .75, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_low.sound' );
			f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), -0.2, .8, -2, 'sound\storm\multiplayer\pve\events\spops_rumble_high.sound' );
			f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -0.3, 1, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
			f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -1, 1, -1, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
		end 
	elseif e10m2_rumble == 1 then
		print ("no rumble needed");
	end
	print ("rumble ended");
	until (e10m2_rumble == 1);
end

script static void f_e10_m2_rumble_1()
	f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -1, 1, -1, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	vo_e10m2_ppm1();
end

script static void f_e10_m2_rumble_2()
	sleep_until(volume_test_players(t_e10_m2_rumble2), 1);
	f_create_new_spawn_folder(88);
	f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), -0.3, 1, -4, 'sound\storm\multiplayer\pve\events\spops_rumble_very_high.sound' );
	sleep_s(1);
	sleep_until(e10m2_narrative_is_on == FALSE, 1);
	vo_e10m2_ppm2();
	sleep_s(20);
	f_e10m2_random_rumble();
end

script static void f_e10_m2_dc_activator_get( object trigger, unit activator )
	g_ics_player_e10_m2 = activator;
end

script static void f_e10_m2_knight_1_scream()
	sleep_until(ai_living_count(e10_m2_1st_knights_1) >= 1, 1);
	sleep_until(ai_not_in_limbo_count(e10_m2_1st_knights_1) == 0, 1);
	cs_custom_animation(e10_m2_1st_knights_1.knight_1, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
end

script static void f_e10_m2_knight_2_scream()
	sleep_until(ai_living_count(e10_m2_1st_knights_2) >= 1, 1);
	sleep_until(ai_not_in_limbo_count(e10_m2_1st_knights_2) == 0, 1);
	cs_custom_animation(e10_m2_1st_knights_2.knight_2, TRUE, objects\characters\storm_knight\storm_knight.model_animation_graph, "combat:any:go_berserk", TRUE);
end

script command_script cs_e10m2_pelican_in()
// Pelican at the  beginning of the level, drops Crimson off.
	cs_ignore_obstacles (TRUE);
	cs_vehicle_speed(.5);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(5);
	cs_fly_to_and_face (e10m2_pelican_in.p0, e10m2_pelican_in.p4, 1);
	cs_fly_to_and_face (e10m2_pelican_in.p5, e10m2_pelican_in.p4, 1);
	sleep_s(3.5);	
	cs_vehicle_speed(1);
	object_can_take_damage(cr_e6_m3_pod_top_1);
	object_can_take_damage(cr_e6_m3_pod_top_2);
	cs_fly_to_and_face (e10m2_pelican_in.p7, e10m2_pelican_in.p1);
	cs_fly_to_and_face (e10m2_pelican_in.p1, e10m2_pelican_in.p2);
	b_e10m2_back_up_done = TRUE;
	cs_fly_to_and_face (e10m2_pelican_in.p2, e10m2_pelican_in.p3);
	cs_fly_to_and_face (e10m2_pelican_in.p3, e10m2_pelican_in.p3);
	ai_erase(e10m2_pelican_in);
end

script command_script cs_e10m2_braindead_spartans()
	ai_braindead(ai_current_actor, TRUE);
	sleep_until(e10m2_spartan_start_shooting == TRUE, 1);
	ai_braindead(ai_current_actor, FALSE);
end