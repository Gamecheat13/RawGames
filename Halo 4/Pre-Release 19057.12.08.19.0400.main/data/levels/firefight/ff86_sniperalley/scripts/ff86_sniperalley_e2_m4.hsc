//============================================ SNIPER ALLEY FIREFIGHT SCRIPT E2 M4========================================================
//=============================================================================================================================
global boolean b_e2_m4_stop_firing_1 = FALSE;
global boolean b_e2_m4_stop_firing_2 = FALSE;
global boolean b_e2_m4_dont_shoot_middle = FALSE;
global boolean b_e2m4_narrative_in_over = FALSE;
global boolean e2m4_drop_pod1_done = FALSE;
global boolean e2m4_drop_pod2_done = FALSE;

// ai_survival_cleanup(ai ai_index, bool activate, bool erase_inactive);
//	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
//=============================================================================================================================
//============================== MISSION SCRIPT ==================================================================
//=============================================================================================================================
script startup sniper_alley_e2_m4
//Start the intro
	sleep_until(LevelEventStatus("e2_m4_start"), 1);
	ai_ff_all = e2_m4_gr_ff_all;
	switch_zone_set(e2_m4);
	firefight_mode_set_player_spawn_suppressed(TRUE);
	thread(f_music_e2m4_start());
		
	dm_droppod_1 = dm_1_e2_m4_droppod;
	dm_droppod_2 = dm_2_e2_m4_droppod;
	dm_droppod_3 = dm_3_e2_m4_droppod;
	dm_droppod_4 = dm_4_e2_m4_droppod;
	dm_droppod_5 = dm_5_e2_m4_droppod;
	
	obj_drop_pod_1 = drop_pod_lg_01;
	obj_drop_pod_2 = drop_pod_lg_02;
	obj_drop_pod_3 = drop_pod_lg_03;
	obj_drop_pod_4 = drop_pod_lg_04;
	obj_drop_pod_5 = drop_pod_lg_05;	

	f_add_crate_folder(e2_m4_dm_drop_rails);
	f_add_crate_folder(cr_e2_m4_temple_props);
	f_add_crate_folder(cr_e2_m4_cov_props);
	f_add_crate_folder(cr_e2_m4_cov_props2);
	f_add_crate_folder(cr_e2_m4_ammo);
	f_add_crate_folder(w_e2_m4_unsc_weapons);
	f_add_crate_folder(e2_m4_switches);
	f_add_crate_folder(e2_m4_controls);
	f_add_crate_folder(cr_e2_m4_cov_watchtower);
	f_add_crate_folder(e_e2_m4_ammo_refill);
		
//set objective names
	firefight_mode_set_objective_name_at(e2_m4_t_switch_1, 1); //objective behind the dias
	firefight_mode_set_objective_name_at(e2_m4_t_switch_2, 2); //on the dias

	firefight_mode_set_objective_name_at(lz_e2_m4_0, 50); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(lz_e2_m4_2, 52); //SA objective location: back of temple
	firefight_mode_set_objective_name_at(lz_e2_m4_3, 53); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(lz_e2_m4_4, 54); //SA objective location: middle of switchback canyon
	firefight_mode_set_objective_name_at(lz_e2_m4_6, 56); //SA objective location: front of temple, front of canyon
	firefight_mode_set_objective_name_at(lz_e2_m4_7, 57); //SA objective location: front of cayon into valley
	firefight_mode_set_objective_name_at(lz_e2_m4_10, 60); //SA objective location: lower bend in the canyon

//set squad group names
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_1, 1);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_2, 2);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_3, 3);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_4, 4);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_5, 5);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_6, 6);
	firefight_mode_set_squad_at(e2_m4_gr_ff_guards_7, 7);

	firefight_mode_set_squad_at(e2_m4_gr_waves_0, 80);
	firefight_mode_set_squad_at(e2_m4_gr_waves_1, 81);
	
//set spawn folder names
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_0, 90); //SA Spawn location: back of temple, split up 2 per side near doors
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_1, 91); //SA Spawn location: middle of temple, facing out of temple
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_2, 92); //SA Spawn location: front of main level of temple, after ramps from bridge
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_3, 93); //SA Spawn location: front pad of temple before bridge, facing into temple
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_4, 94); //SA Spawn location: in valley, facing into canyon
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_5, 95); //SA Spawn location: in middle of the canyon, facing towards temple
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_6, 96); //SA Spawn location: back of temple, middle, as a group
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_7, 97); //SA Spawn location: near end of valley to cayon, facing into valley
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_8, 98); //SA Spawn location: middle of the valley, facing towards the canyon
	firefight_mode_set_crate_folder_at(e2_m4_spawn_points_9, 99); //SA Spawn location: entry to canyon from valley, facing into canyon, for going up to temple
	thread(f_e2_m4_start_text());
	thread(f_e2_m4_damage_stuff());
	effect_new(levels\firefight\ff86_sniperalley\fx\smoke_column_thickloop_sniperalley.effect, fl_e2_m4_smoke);
	
	//print("_____________________________8/13 2:12");
end

// ==============================================================================================================
// ====== E2_M4_Sniperalley_Destroy==============================================================================
// ==============================================================================================================
script static void f_e2_m4_damage_stuff
	sleep_s(1);
	damage_object(d1, left, 50000);
	damage_object(d2, left, 50000);
	damage_object(d4, left, 50000);
	damage_object(d5, left, 50000);
	damage_object(d6, left, 50000);
	damage_object(d8, left, 50000);
	damage_object(d9, left, 50000);
	damage_object(d10, left, 50000);
	damage_object(d11, left, 50000);
	damage_object(d1, middle, 50000);
	damage_object(d2, middle, 50000);
	damage_object(d4, middle, 50000);
	damage_object(d5, middle, 50000);
	damage_object(d6, middle, 50000);
	damage_object(d8, middle, 50000);
	damage_object(d9, middle, 50000);
	damage_object(d10, middle, 50000);
	damage_object(d11, middle, 50000);
	damage_object(d1, right, 50000);
	damage_object(d2, right, 50000);
	damage_object(d4, right, 50000);
	damage_object(d5, right, 50000);
	damage_object(d6, right, 50000);
	damage_object(d8, right, 50000);
	damage_object(d9, right, 50000);
	damage_object(d10, right, 50000);
	damage_object(d11, right, 50000);
	damage_object(e2m4_base1, default, 50000);
	object_destroy(e1m4_base1);
	object_destroy(e1m4_pod1);
	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e2_m4.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	object_set_phantom_power(e2m4_base1, FALSE);
end

script static void f_e2m4_narrative_in_over
	b_e2m4_narrative_in_over = TRUE;
end

script command_script f_e2_m4_drop_pod_obj
	sleep_s(1);
	ai_set_objective(ai_current_actor, obj_e2_m4_survival);
end

script static void f_e2_m4_start_text  // intro text
	if editor_mode() then
		print("editor mode, not playing intro");
		b_e2m4_narrative_in_over = TRUE;
	else
		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
		ai_enter_limbo(e2_m4_gr_ff_all);
		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m4_vin_sfx_intro', NONE, 1);
		cinematic_start();
		pup_play_show(e2m4_narrative_in);
	end
	sleep_s(1);
	sleep_until(b_e2m4_narrative_in_over == TRUE);
	cinematic_stop();
	firefight_mode_set_player_spawn_suppressed(FALSE);
	sleep_until((e2m4_narrative_is_on == FALSE), 1);
	sleep_until (b_players_are_alive(), 1);
	ai_place(sq_e2_m4_phantom_03);
	
	thread(f_e2_m4_sniper_line());
	thread(f_e2_m4_break_ridge_snipers());
	thread(f_e2_m4_1st_pod_ramp());
	thread(f_e2_m4_dropping_jackals());
	thread(f_e2_m4_crazy_grunt());
	thread(f_e2_m4_1_gun_down());
	thread(f_e2_m4_1st_gun());
	thread(f_e2_m4_derez_turret_1());
	thread(f_e2_m4_2nd_gun());
	thread(f_e2_m4_derez_turret_2());
	
	ai_place(sq_e2_m4_for_turret_1);
	ai_place(sq_e2_m4_for_turret_2);
	sleep_s(1);
	fade_in(0,0,0,15);
	ai_exit_limbo(e2_m4_gr_ff_all);

	thread(f_music_e2m4_start_text());
	sleep_s(1);
	wake(vo_e2m4_playstart);
	sleep_s(2);
	sleep_until((e2m4_narrative_is_on == FALSE), 1);
	ai_place(sq_e2_m4_ridge_snipers);
	f_new_objective(e2m4_objective_1);
	
	//b_end_player_goal = TRUE; <--moved to narrative
	
	object_create_anew(lz_e2_m4_7);
	navpoint_track_object_named(lz_e2_m4_7, "navpoint_goto");
	sleep_until(volume_test_players(t_e2_m4_trig_ridge_snipers), 1);
	object_destroy(lz_e2_m4_7);
	sleep_s(2);
	if ai_living_count(e2_m4_gr_ff_all) <= 13 then
		ai_place(sq_e2_m4_grunts1);
	end
	object_create_anew(lz_e2_m4_10);
	navpoint_track_object_named(lz_e2_m4_10, "navpoint_goto");

	sleep_until(volume_test_players(t_loc_ar_1), 1);
	ai_set_objective(e2_m4_gr_ff_guards_1, e2_m4_obj_guard_4);
	ai_set_objective(e2_m4_gr_ff_guards_2, e2_m4_obj_guard_4);
	ai_set_objective(e2_m4_gr_waves_0, e2_m4_obj_guard_4);
//	ai_set_objective(e2_m4_gr_ff_guards_3, e2_m4_obj_guard_4);
	
	b_end_player_goal = TRUE;
	f_unblip_object_cui(lz_e2_m4_10);
	object_create_anew(lz_e2_m4_3);
	navpoint_track_object_named(lz_e2_m4_3, "navpoint_goto");
	
	sleep_until(volume_test_players(t_loc_ar_2), 1);
	ai_set_objective(e2_m4_gr_waves_1, e2_m4_obj_guard_4);
	ai_set_objective(e2_m4_gr_ff_guards_4, e2_m4_obj_guard_4);
	f_unblip_object_cui(lz_e2_m4_3);
	thread(f_music_e2m4_guns_are_located());
	wake(vo_e2m4_aaguns);
	sleep_s(1);
	sleep_until((e2m4_narrative_is_on == FALSE), 1);
	f_new_objective(e2m4_objective_2);
end

script static void f_e2_m4_sniper_line
	sleep_until(volume_test_players(t_e2_m4_sniper_line), 1);
	f_e2_m4_sniper_global_vo();
end

script static void f_e2_m4_break_ridge_snipers
	sleep_until(volume_test_players(t_e2_m4_break_snipers), 1);
	ai_set_task(sq_e2_m4_ridge_snipers, e2_m4_obj_guard_3, guard2);
	thread(f_music_e2m4_break_ridge_snipers());
end

script static void f_e2_m4_crazy_grunt()
	sleep_until(volume_test_players(t_e2_m4_kamikaze), 1);
	ai_grunt_kamikaze(sq_e2_m4_aa_grunts.trololo);
	ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
end

script static void f_e2_m4_1st_gun()
	sleep_until(LevelEventStatus("e2_m4_at_1st_gun"), 1);
	wake(vo_e2m4_gun01arrive);
	sleep_s(2);
	sleep_until((e2m4_narrative_is_on == FALSE), 1);
	thread(f_music_e2m4_1st_gun());
	sleep_s(1);
	b_end_player_goal = TRUE;
	device_set_power(e2_m4_t_switch_1, 1);
end

script static void f_e2_m4_2nd_gun()
	sleep_until(LevelEventStatus("e2_m4_at_2nd_gun"), 1);
	wake(vo_e2m4_gun02arrive);
	thread(f_e2_m4_bring_in_phantom());
	ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	thread(f_music_e2m4_2nd_gun());
	sleep_s(5);
	b_end_player_goal = TRUE;
	device_set_power(e2_m4_t_switch_2, 1);
end

script static void f_e2_m4_bring_in_phantom
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 6, 1);
	ai_place(sq_e2_m4_phantom_01);
end

script command_script cs_e2_m4_turret_1
	object_set_scale(ai_vehicle_get(ai_current_actor ), .15, 0);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e2_m4_fake_ships_1.p0);
        sleep_rand_s(1,4);
        cs_shoot_point(true, e2_m4_fake_ships_1.p0);
        sleep_rand_s(1,5);
        cs_shoot_point(false, e2_m4_fake_ships_1.p0);
        sleep_rand_s(5,8);
     end
                               
     begin
       cs_shoot_point(true, e2_m4_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e2_m4_fake_ships_1.p1);
       sleep_rand_s(5,8);
     end
                                
		begin
     	if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_1.p2);
				sleep_rand_s(1,4);
      end
      if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_1.p2);
       	sleep_rand_s(1,5);
      end
      if b_e2_m4_dont_shoot_middle == FALSE then
      	cs_shoot_point(false, e2_m4_fake_ships_1.p2);
       	sleep_rand_s(5,8);
			end
		end
                                                
		begin
			if b_e2_m4_dont_shoot_middle == FALSE then
      	cs_shoot_point(true, e2_m4_fake_ships_1.p3);
     		sleep_rand_s(1,3);
     	end
     	if b_e2_m4_dont_shoot_middle == FALSE then
     		cs_shoot_point(true, e2_m4_fake_ships_1.p3);
     		sleep_rand_s(1,3);
     	end
     	if b_e2_m4_dont_shoot_middle == FALSE then
     		cs_shoot_point(true, e2_m4_fake_ships_1.p3);
     		sleep_rand_s(1,3);
     	end
     	if b_e2_m4_dont_shoot_middle == FALSE then
     		cs_shoot_point(false, e2_m4_fake_ships_1.p3);
  			sleep_rand_s(5,8);
  		end
		end
                                                
     begin
       cs_shoot_point(true, e2_m4_fake_ships_1.p4);
       sleep_rand_s(1,4);
       cs_shoot_point(true, e2_m4_fake_ships_1.p4);
       sleep_rand_s(1,5);
       cs_shoot_point(false, e2_m4_fake_ships_1.p4);
       sleep_rand_s(5,8);
     end
                                                
     begin
       cs_shoot_point(true, e2_m4_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e2_m4_fake_ships_1.p5);
       sleep_rand_s(5,8);
     end                                        
	end
	until( b_e2_m4_stop_firing_1 == TRUE);
end

script static void f_e2_m4_derez_turret_1
	sleep_until((device_get_position(e2_m4_t_switch_1) == 1), 1);
	thread(f_music_e2m4_switch_1_power_down());
	sleep_s(1.5);
	object_dissolve_from_marker(e2m4_switch_glow_1, phase_out, button_marker);
	object_dissolve_from_marker(e2_m4_switch_wall_1, phase_out, default);
	sleep_s(1);
	cs_run_command_script(sq_e2_m4_for_turret_1, cs_e2_m4_kill_turret_1);
	sleep_s(4);
	object_destroy(e2_m4_t_switch_1);
	object_destroy(e2m4_switch_glow_1);
	object_destroy(e2_m4_switch_wall_1);
	thread(f_e2_m4_get_out_now());
	thread(f_e2_m4_bring_in_phantoms());
end

script command_script cs_e2_m4_kill_turret_1
	b_e2_m4_stop_firing_1 = TRUE;
	thread(f_music_e2m4_derez_turret_1());
	//sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machine_36b_turret_disappear', ai_vehicle_get(ai_current_actor), 1 ); //AUDIO!
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_out", "primary_trigger");
	sleep_s(4);
	object_destroy(ai_vehicle_get(ai_current_actor));
end

script command_script cs_e2_m4_turret_2
	object_set_scale(ai_vehicle_get(ai_current_actor ), .15, 0);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e2_m4_fake_ships_2.p0);
        sleep_rand_s(1,3);
        cs_shoot_point(true, e2_m4_fake_ships_2.p0);
        sleep_rand_s(1,3);
        cs_shoot_point(true, e2_m4_fake_ships_2.p0);
        sleep_rand_s(1,3);
        cs_shoot_point(false, e2_m4_fake_ships_2.p0);
        sleep_rand_s(5,8);
     end
                               
		begin
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p1);
       	sleep_rand_s(1,4);
       	cs_shoot_point(true, e2_m4_fake_ships_2.p1);
       	sleep_rand_s(1,5);
       	cs_shoot_point(false, e2_m4_fake_ships_2.p1);
       	sleep_rand_s(5,8);
       end
		end
                                
		begin
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p2);
       	sleep_rand_s(1,3);
			end
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p2);
       	sleep_rand_s(1,3);
			end
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p2);
       	sleep_rand_s(1,3);
			end
			if b_e2_m4_dont_shoot_middle == FALSE then
				cs_shoot_point(false, e2_m4_fake_ships_2.p2);
       	sleep_rand_s(5,8);
			end
		end
                                                
		begin
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p3);
       	sleep_rand_s(1,4);
			end
			if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(true, e2_m4_fake_ships_2.p3);
       	sleep_rand_s(1,5);
      end
      if b_e2_m4_dont_shoot_middle == FALSE then
       	cs_shoot_point(false, e2_m4_fake_ships_2.p3);
      	sleep_rand_s(5,8);
      end
		end
                                                
     begin
       cs_shoot_point(true, e2_m4_fake_ships_2.p4);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_2.p4);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e2_m4_fake_ships_2.p4);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e2_m4_fake_ships_2.p4);
       sleep_rand_s(5,8);
     end
                                                
     begin
       cs_shoot_point(true, e2_m4_fake_ships_2.p5);
       sleep_rand_s(1,4);
       cs_shoot_point(true, e2_m4_fake_ships_2.p5);
       sleep_rand_s(1,5);
       cs_shoot_point(false, e2_m4_fake_ships_2.p5);
       sleep_rand_s(5,8);;
     end                                        
	end
	until(b_e2_m4_stop_firing_2 == TRUE);
end

script static void f_e2_m4_derez_turret_2
	sleep_until((device_get_position(e2_m4_t_switch_2) == 1), 1);
	thread(f_music_e2m4_switch_2_power_down());
	sleep_s(1.5);
	object_dissolve_from_marker(e2m4_switch_glow_2, phase_out, button_marker);
	object_dissolve_from_marker(e2_m4_switch_wall_2, phase_out, default);
	sleep_s(1);
	cs_run_command_script(sq_e2_m4_for_turret_2, cs_e2_m4_kill_turret_2);
	sleep_s(4);
	object_destroy(e2_m4_t_switch_2);
	object_destroy(e2m4_switch_glow_2);
	object_destroy(e2_m4_switch_wall_2);
end

script command_script cs_e2_m4_kill_turret_2
	b_e2_m4_stop_firing_2 = TRUE;
	thread(f_music_e2m4_derez_turret_2());
	//sound_impulse_start ( 'sound\environments\multiplayer\sniperalley\new_machines\machine_36b_turret_disappear', ai_vehicle_get(ai_current_actor), 1 ); //AUDIO!
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_out", "primary_trigger");
	sleep_s(4);
	object_destroy(ai_vehicle_get(ai_current_actor));
	sleep_s(4);
	wake(vo_e2m4_gun02down);
	thread(f_music_e2m4_both_guns_down());
end

script static void f_e2_m4_1_gun_down //1st gun is down, move on to next objective
	sleep_until(LevelEventStatus("e2_m4_1_gun_down"), 1);
	thread(f_music_e2m4_1st_gun_down());
	sleep_s(4);
	wake(vo_e2m4_gun01down);
	sleep_s(1);
	sleep_until (e2m4_narrative_is_on == FALSE);
	thread(f_e2_m4_hunter_pod_1());
	sleep_s(5);
	wake(vo_e2m4_gun02target);
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	
	// moving this call to the narrative to time it just right.
	//b_end_player_goal = TRUE;
	// moving this call to the narrative to time it just right.
	
	thread(f_e2_m4_back_pods_down());
end

script static void f_e2_m4_back_pods_down
	sleep_until(volume_test_players(t_e2_m4_back_pods), 1);
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 16, 1);
	object_create(e2_m4_pod_4);
	thread(e2_m4_pod_4->drop_to_point(e2_m4_pod_4, e2_m4_drop_pod_hunter.p4, .85, DEFAULT ));
//	sleep_s(1);
//	ai_set_objective (e2_m4_pod_4, obj_e2_m4_survival);
	sleep_rand_s(1,3);
	object_create(e2_m4_pod_6);
	thread(e2_m4_pod_6->drop_to_point(e2_m4_pod_6, e2_m4_drop_pod_hunter.p6, .85, DEFAULT ));
	sleep_s(1);
	ai_set_active_camo(e2_m4_pod_6, TRUE);
	sleep_rand_s(5,7);
	object_create(e2_m4_pod_5);
	thread(e2_m4_pod_5->drop_to_point(e2_m4_pod_5, e2_m4_drop_pod_hunter.p5, .85, DEFAULT ));
//	sleep_s(1);
//	ai_set_objective (e2_m4_pod_5, obj_e2_m4_survival);
	sleep_rand_s(1,3);
	object_create(e2_m4_pod_7);
	thread(e2_m4_pod_7->drop_to_point(e2_m4_pod_7, e2_m4_drop_pod_hunter.p7, .85, DEFAULT ));
//	sleep_s(1);
//	ai_set_objective(e2_m4_pod_7, obj_e2_m4_survival);
end

script static void f_e2_m4_hunter_pod_1
	if ai_living_count(e2_m4_gr_ff_all) <= 15 then
		ai_place(sq_e2_m4_mid_guards);
	else
		ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	end
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 18, 1);
	object_create(e2_m4_pod_1);
	thread(e2_m4_pod_1->drop_to_point(e2_m4_pod_1, e2_m4_drop_pod_hunter.p1, .85, DEFAULT ));
	sleep_s(1);
	ai_set_active_camo(e2_m4_pod_1, TRUE);
//	ai_set_objective (e2_m4_pod_1, obj_e2_m4_survival);
	object_create(e2_m4_pod_3);
	thread(e2_m4_pod_3->drop_to_point(e2_m4_pod_3, e2_m4_drop_pod_hunter.p3, .85, DEFAULT ));
//	sleep_s(1);
//	ai_set_objective (e2_m4_pod_3, obj_e2_m4_survival);
end

script static void f_e2_m4_1st_pod_ramp()
	sleep_until(volume_test_players(t_e2_m4_first_pod), 1);
	ai_set_objective(e2_m4_gr_ff_guards_3, e2_m4_obj_guard_4);
	if ai_living_count(e2_m4_gr_ff_all) <= 19 then
		ai_place(sq_e2_m4_turret_grunt);
	end
	thread(f_music_e2m4_1st_pod_ramp());
	if ai_living_count(e2_m4_gr_ff_all) <= 19 then
		object_create(e2_m4_pod_2);
		thread(e2_m4_pod_2->drop_to_point(e2_m4_pod_2, e2_m4_drop_pod_hunter.p2, .85, DEFAULT ));
		sleep_s(2);
		ai_set_active_camo(e2_m4_pod_2, TRUE);
	end
	thread(f_e2_m4_call_in_mid_level_grunts());
	sleep_s(1);
	thread(f_e2_m4_bridge_grunts_snipers());
	sleep_s(5);
	if ai_living_count(e2_m4_gr_ff_all) <= 18 then
		ai_place(sq_e2_m4_bridge_snipers_left);
	end
	sleep_s(1);
	if ai_living_count(e2_m4_gr_ff_all) <= 18 then
		ai_place(sq_e2_m4_bridge_snipers_right);
	end
	//ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	sleep_s(3);
	thread(f_music_e2m4_extra_jackals());
	if ai_living_count(e2_m4_gr_ff_all) <= 16 then
		ai_place(sq_e2_m4_jackal_bridge);
	end
	//ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
end

script static void f_e2_m4_call_in_mid_level_grunts
	sleep_until(volume_test_players(t_e2_m4_mide_level_grunts), 1);
	if ai_living_count(e2_m4_gr_ff_all) <= 14 then
		ai_place(sq_e2_m4_elites_grunts);
	else
		ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	end
	sleep_s(2);
	if ai_living_count(e2_m4_gr_ff_all) <= 14 then
		ai_place(sq_e2_m4_aa_grunts);
	else
		ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	end
end

script static void f_e2_m4_bridge_grunts_snipers
	sleep_until(volume_test_players(t_e2_m4_grunts_snipers), 1);
	if ai_living_count(e2_m4_gr_ff_all) <= 16 then
		ai_place(sq_e2_m4_j_bridgesnipers_1);
		ai_place(sq_e2_m4_j_bridgesnipers_2);
		ai_place(sq_e2_m4_j_bridgesnipers_3);
		ai_place(sq_e2_m4_j_bridgesnipers_4);
//	else
//		ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	end
	if ai_living_count(e2_m4_gr_ff_all) <= 10 then
		ai_place(sq_e2_m4_bridge_backup_grunts);
	end
//	ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	sleep_until(e2m4_narrative_is_on == FALSE);
	f_e2_m4_sniper_global_vo();
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	f_e2_m4_ordnance_global_vo();
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	thread(f_music_e2m4_turret_grunt());
	sleep_s(1);
	ordnance_drop(e2_m4_sniper_drop, "storm_sniper_rifle");
	sleep_s(1);
	e2m4_narrative_is_on = TRUE;
	vo_glo_gotit_02();
	e2m4_narrative_is_on = FALSE;
end

script static void f_e2_m4_get_out_now // tell the player to exit, drop more dudes, wait, drop more dudes, blip, then tell them where to go.
	sleep_until(LevelEventStatus("e2_m4_get_out"), 1);
	kill_script(f_e2_m4_hunter_pod_1);
	kill_script(f_e2_m4_back_pods_down);
	thread(f_music_e2m4_get_out_now());
	ai_set_objective(e2_m4_gr_ff_all, e2_m4_back_area);
	wake(vo_e2m4_gun02down);
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	wake(vo_e2m4_hunters02);
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	ai_set_task(sq_e2_m4_phan2_4.hunter_right, e2_m4_obj_guard_9, guard_right);
	ai_set_task(sq_e2_m4_phan2_4.hunter_left, e2_m4_obj_guard_9, guard_left);
	sleep_s(3);
	f_new_objective(e2m4_objective_3);
	//f_blip_ai_cui(e2_m4_gr_ff_all, "navpoint_enemy");
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 8, 1);
	thread(f_e2_m4_drop_pod_1());
	sleep_until(e2m4_drop_pod1_done == TRUE);
	//f_blip_ai_cui(e2_m4_gr_ff_all, "navpoint_enemy");
	sleep_s(5);
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 5, 1);
	sleep_s(5);
	thread(f_e2_m4_drop_pod_2());
	sleep_until(e2m4_drop_pod2_done == TRUE);
	sleep_s(1);
	wake(vo_e2_m4_clean_up_baddies);
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	f_blip_ai_cui(e2_m4_gr_ff_all, "navpoint_enemy");
	ai_survival_cleanup(e2_m4_gr_ff_all, TRUE, TRUE);
	sleep_until(ai_living_count(e2_m4_gr_ff_all) <= 0, 1);
	sleep_s(4);
	wake(vo_e2m4_allclear);
	sleep_s(1);
	sleep_until(e2m4_narrative_is_on == FALSE);
	f_new_objective(e2m4_objective_4);
	b_end_player_goal = TRUE;
	thread(f_e2_m4_end_mission());
end

script static void f_e2_m4_end_mission //watches trigger to fade to black
	sleep_until(LevelEventStatus("e2_m4_end_mission"), 1);
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	b_end_player_goal = TRUE;
end

script static void f_e2_m4_dropping_jackals
	sleep_until(LevelEventStatus("e2_m4_dropping_jackals"), 1);
	f_e2_m4_droppod_global_vo();
end

// ==============================================================================================================
// ====== E2_M4_Drop_pod stuff ==================================================================================
// ==============================================================================================================
script static void f_e2_m4_drop_pod_1
	ai_place_in_limbo(sq_e2m4_big_pod_1);
	f_load_drop_pod(dm_4_e2_m4_droppod, sq_e2m4_big_pod_1, e2_m4_big_pod_1, FALSE);
	sleep_s(5);
	e2m4_drop_pod1_done = TRUE;
end

script static void f_e2_m4_drop_pod_2
	ai_place_in_limbo(sq_e2m4_big_pod_2);
	f_load_drop_pod(dm_5_e2_m4_droppod, sq_e2m4_big_pod_2, e2_m4_big_pod_2, FALSE);
	sleep_s(5);
	e2m4_drop_pod2_done = TRUE;
end

script static void f_e2_m4_bring_in_phantoms
	sleep_until(volume_test_players(t_e2_m4_phantoms_in), 1);
	thread(f_music_e2m4_bring_in_phantoms());
	//ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	sleep_s(1);
	if ai_living_count(e2_m4_gr_ff_all) <= 6 then
		ai_place(sq_e2_m4_phantom_02);
		wake(vo_e2m4_hunters01);
	else
		ai_set_objective(e2_m4_gr_ff_all, obj_e2_m4_survival);
	end
	f_create_new_spawn_folder (97);
end

script command_script cs_e2_m4_phantom_01()
	cs_ignore_obstacles (TRUE);
	f_load_phantom(sq_e2_m4_phantom_01, dual, sq_e2_m4_phan2_1, sq_e2_m4_phan2_2, sq_e2_m4_phan2_3, sq_e2_m4_phan2_4);
	cs_fly_to_and_face (e2_m4_phan1.p0, e2_m4_phan1.p10);
	cs_fly_to_and_face (e2_m4_phan1.p1, e2_m4_phan1.p10);
	cs_fly_to_and_face (e2_m4_phan1.p2, e2_m4_phan1.p10);
	cs_fly_to_and_face (e2_m4_phan1.p3, e2_m4_phan1.p10);
	cs_fly_to_and_face (e2_m4_phan1.p4, e2_m4_phan1.p10);
	sleep_s(3);
	f_unload_phantom (sq_e2_m4_phantom_01, dual);
	sleep_s(3);	
	ai_set_objective (sq_e2_m4_phan2_1, e2_m4_obj_guard_8);
	ai_set_objective (sq_e2_m4_phan2_2, e2_m4_obj_guard_8);
	ai_set_objective (sq_e2_m4_phan2_3, e2_m4_obj_guard_9);
	ai_set_objective (sq_e2_m4_phan2_4, e2_m4_obj_guard_9);
	cs_fly_to_and_face (e2_m4_phan1.p5, e2_m4_phan1.p10);
	cs_fly_to_and_face (e2_m4_phan1.p6, e2_m4_phan1.p8);
	cs_fly_to_and_face (e2_m4_phan1.p7, e2_m4_phan1.p8);
	cs_fly_to_and_face (e2_m4_phan1.p8, e2_m4_phan1.p8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	ai_erase (sq_e2_m4_phantom_01);
end

script command_script cs_e2_m4_phantom_02()
	cs_ignore_obstacles (TRUE);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	f_load_phantom(sq_e2_m4_phantom_02, dual, sq_e2_m4_phan1_1, sq_e2_m4_phan1_2, sq_e2_m4_phan1_3, sq_e2_m4_phan1_4);
	cs_fly_to_and_face (e2_m4_phan2.p0, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p1, e2_m4_phan2.p9);
	b_e2_m4_dont_shoot_middle = TRUE;
	cs_fly_to_and_face (e2_m4_phan2.p2, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p3, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p4, e2_m4_phan2.p9);
	sleep_s(3);
	f_unload_phantom (sq_e2_m4_phantom_02, dual);
	sleep_s(3);
	ai_set_objective (sq_e2_m4_phan1_1, e2_m4_obj_guard_10);
	ai_set_objective (sq_e2_m4_phan1_2, e2_m4_obj_guard_11);
	ai_set_objective (sq_e2_m4_phan1_3, e2_m4_obj_guard_11);
	ai_set_objective (sq_e2_m4_phan1_4, e2_m4_obj_guard_12);
	cs_fly_to_and_face (e2_m4_phan2.p5, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p6, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p7, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p8, e2_m4_phan2.p9);
	cs_fly_to_and_face (e2_m4_phan2.p9, e2_m4_phan2.p9);
	b_e2_m4_stop_firing_1 = FALSE;
	b_e2_m4_stop_firing_2 = FALSE;
	b_e2_m4_dont_shoot_middle = FALSE;
	object_set_scale (ai_vehicle_get(ai_current_actor), 0.01, 120); //Shrink size over time
	ai_erase (sq_e2_m4_phantom_02);
	cs_run_command_script(sq_e2_m4_for_turret_1, cs_e2_m4_turret_1);
	cs_run_command_script(sq_e2_m4_for_turret_2, cs_e2_m4_turret_2);
end

script command_script cs_e2_m4_phantom_03()
	cs_ignore_obstacles (TRUE);
	cs_fly_to_and_face (e2_m4_phan3.p0, e2_m4_phan3.p10);
	cs_fly_to_and_face (e2_m4_phan3.p1, e2_m4_phan3.p10);
	cs_fly_to_and_face (e2_m4_phan3.p2, e2_m4_phan3.p10);
	cs_fly_to_and_face (e2_m4_phan3.p3, e2_m4_phan3.p10);
	sleep_s(3);
	cs_fly_to_and_face (e2_m4_phan3.p4, e2_m4_phan3.p5);
	cs_fly_to_and_face (e2_m4_phan3.p5, e2_m4_phan3.p6);
	cs_fly_to_and_face (e2_m4_phan3.p6, e2_m4_phan3.p7);
	cs_fly_to_and_face (e2_m4_phan3.p7, e2_m4_phan3.p8);
	cs_fly_to_and_face (e2_m4_phan3.p8, e2_m4_phan3.p9);
	cs_fly_to_and_face (e2_m4_phan3.p9, e2_m4_phan3.p9);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 120 ); //Shrink size over time
	ai_erase (sq_e2_m4_phantom_03);
end

////////////////////////////////////////////////////////////////////////////////////////////////////////
//===========================misc event scripts
////////////////////////////////////////////////////////////////////////////////////////////////////////
script static void f_e2_m4_sniper_global_vo
	sleep_until (e2m4_narrative_is_on == FALSE, 1);
	e2m4_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_snipers_01();
		vo_glo_snipers_02();
		vo_glo_snipers_03();
		vo_glo_snipers_04();
		vo_glo_snipers_05();
	end
	e2m4_narrative_is_on = FALSE;
end

script static void f_e2_m4_ordnance_global_vo
	sleep_until (e2m4_narrative_is_on == FALSE, 1);
	e2m4_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_ordnance_01();
		vo_glo_ordnance_02();
		vo_glo_ordnance_04();
		vo_glo_ordnance_05();
	end
	e2m4_narrative_is_on = FALSE;
end

script static void f_e2_m4_droppod_global_vo
	sleep_until (e2m4_narrative_is_on == FALSE, 1);
	e2m4_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_droppod_01();
		vo_glo_droppod_02();
		vo_glo_droppod_03();
		vo_glo_droppod_04();
		vo_glo_droppod_05();
		vo_glo_droppod_08();
		vo_glo_droppod_09();
		vo_glo_droppod_10();
	end
	e2m4_narrative_is_on = FALSE;
end

script static void f_e2_m4_last_targets_global_vo
	sleep_until (e2m4_narrative_is_on == FALSE, 1);
	e2m4_narrative_is_on = TRUE;
	begin_random_count (1)
		vo_glo_lasttargets_01();
		vo_glo_lasttargets_02();
		vo_glo_lasttargets_03();
		vo_glo_lasttargets_04();
		vo_glo_lasttargets_05();
		vo_glo_lasttargets_06();
		vo_glo_lasttargets_07();
		vo_glo_lasttargets_08();
		vo_glo_lasttargets_09();
		vo_glo_lasttargets_10();
	end
	e2m4_narrative_is_on = FALSE;
end
