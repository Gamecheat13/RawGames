//=============================================================================================================================
//============================================ TEMPLE E2_M5 SPARTAN OPS SCRIPT ==================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
global boolean e5m1_startenemies = FALSE;
global boolean e5m1_nottoolong = FALSE;
global boolean e5m2_narrativein_done = FALSE;
global boolean e5m2_youscurred = FALSE;
global boolean e5m2_takecover = FALSE;
global boolean e5m2_obj_destroyed = FALSE;
global boolean e5m2_shell_open = FALSE;
global boolean e5m2_shell_dead = FALSE;
global boolean e5m2_shell_dissolve = FALSE;
global boolean e4m5_shelldestroyed = FALSE;

//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//
//																																													//
//																	Episode 05: Mission 01																	//
//																																													//
//343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==343++343==//


//343++343==343++343==343++343//	E5M1 Variant Startup Script	//343++343==343++343==343++343//

script startup e5m1_temple_startup
	sleep_until (LevelEventStatus ("e5m1_var_startup"), 1);
	thread(f_music_e5m1_start());
	ai_ff_all = e5m1_ff_all;
	print ("e2m5 variant started");
	switch_zone_set (E5M1_shutdown);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);
	kill_volume_disable(kill_e4_m1_kill_players_door);
	kill_volume_disable(kill_v1);												// tjp 8-18-12
	effects_distortion_enabled = 0;
	e5m2_shell_open = FALSE;
	e5m2_shell_dead = FALSE;
	e5m2_narrativein_done = FALSE;
	e5m2_youscurred = FALSE;
	e5m2_takecover = FALSE;
	e5m2_obj_destroyed = FALSE;
	e5m2_shell_dissolve = FALSE;
	e4m5_shelldestroyed = FALSE;
	//	add "Devices" folders
		//f_add_crate_folder (e5m1_spawners);																//	Spawners for E5M1
	//	add "Vehicles" folders
		//f_add_crate_folder (e5m1_veh_unsc);																//	UNSC Vehicles for E5M1
		//f_add_crate_folder (e5m1_turrets);																//	Turrets for E5M1
	//	add "Crates" folders
		//f_add_crate_folder (e5m1_barriers);																//	Barrier Crates for E5M1
		f_add_crate_folder (e5m1_spawner);																	//	Spawner for E5M1
		f_add_crate_folder (e5m1_props);																		//	Prop Crates for E5M1
		f_add_crate_folder (e5m1_weaponracks);															//	Weapon Racks and Crates for E5M1
		f_add_crate_folder (e5m1_barriers);																	//	Weapon Racks and Crates for E5M1
		f_add_crate_folder (e5m1_dm);																				//	Device Machines for E5M1
		f_add_crate_folder (e5m2_equipment);																				//	Device Machines for E5M1
		
		object_create (e5m2_shell);
	//	add "Scenery" folders
		firefight_mode_set_crate_folder_at(e5m1_spawnpoint_01, 50);					//	Initial Spawn Area for E5M1	
		firefight_mode_set_crate_folder_at(e5m1_spawnpoint_02, 51);					//	2nd Spawn Area for E5M1	
		//firefight_mode_set_crate_folder_at(e5m1_spawnpoints_02, 51);			//	2nd Spawn Area for E5M1	
	//	add "Items" folders
	//	add "Enemy Squad" Templates
	//	add "Objectives"
		firefight_mode_set_objective_name_at(e5m1_teleporter_release, 30);	//	Objective Switch in the middle courtyard for E5M1
		firefight_mode_set_objective_name_at(e5m1_teleporter_tech, 31);	//	Objective tech above the bridge for E5M1
	//	add "LZ" areas
	thread (e5m1_enemychecker());
	firefight_mode_set_player_spawn_suppressed(TRUE);
	f_create_new_spawn_folder (50);
	sleep_until (LevelEventStatus ("loadout_screen_complete"), 1);
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e5m2_vin_sfx_intro', NONE, 1);
	pup_play_show (e5m2_shell_anims);
	thread(f_music_e5m1_intro_begin());
	thread(f_music_e5m1_intro_end());
	thread (e5m1_scientist());
	sleep (15);
	firefight_mode_set_player_spawn_suppressed(FALSE);
	sleep_until (b_players_are_alive(), 1);
	print ("player is alive");
	sleep(1);
	if(player_valid(player0))then
		object_set_velocity(player0, 6, 0, 4);
	end
	if(player_valid(player1))then
		object_set_velocity(player1, 6, 0, 4);
	end
	if(player_valid(player2))then
		object_set_velocity(player2, 6, 0, 4);
	end
	if(player_valid(player3))then
		object_set_velocity(player3, 6, 0, 4);
	end
	fade_in (255,255,255,30);
	player_control_fade_in_all_input(1);
	sleep (2);
	thread(f_e5_m2_portal_fx());
	thread (vo_e5m2_intro());
	print ("all ai exiting limbo after the puppeteer");
	NotifyLevel ("e5m1_players_spawned");
	object_cannot_take_damage (e5m1_teleporter_tech);
	thread(f_music_e5m1_playstart_vo());
	f_new_objective (e5m1_obj_rendezous);
end


script static void f_e5_m2_portal_fx
	effects_distortion_enabled = 1;
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_e5m2_portal); 
  sleep_s(0.5);
  effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5m2_portal);
  sleep_s(4);
  effect_new (environments\solo\m30_cryptum\fx\portal\teleport_lg_portal_start.effect, fl_e5m2_portal);
  sleep_s(1);
  //	kill effects
  effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5m2_portal);
  effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_e5m2_portal);
  effects_distortion_enabled = 0;
end

//343++343==343++343==343++343//	E2M5 Goal 01 Scripts (0. time_passed)	//343++343==343++343==343++343//

script static void e5m1_scientist()
	ai_place (sq_e5m1_scientists_01);
	
	ai_place (sq_e5m1_marines_01);
	thread (e5m1_startinggoal());
end

script static void e5m1_startinggoal()
	sleep_until (e5m1_startenemies == TRUE);
	thread (e5m1_startingenemies());
	b_end_player_goal = TRUE;
end

script static void e5m1_enemychecker()
	print ("waiting for player to hit volume");
	sleep_until (volume_test_players (tv_e5m1_startenemies), 1);
	print ("volume hit!");
	e5m1_startenemies = TRUE;
	print ("e5m1_startenemies = TRUE");
end	

//343++343==343++343==343++343//	E2M5 Goal 02 Scripts (1. time_passed)	//343++343==343++343==343++343//	

script static void e5m1_startingenemies()
	sleep_until (LevelEventStatus ("e5m1_startingenemies"), 1);
	sleep_until (e5m1_startenemies == TRUE);
	thread(f_music_e5m1_startingenemies());
	thread (e5m1_endgoal02());
	thread (e5m2_millersreturn());
	thread (e5m2_givecover());
	thread (e5m1_pawns01_spawn());
	thread (e5m1_pawns02_spawn());
	thread (e5m1_pawns03_spawn());
	thread (e5m1_1kni03_spawn());
	thread (e5m1_4paw01_spawn());
	thread (e5m1_4paw03_spawn());
	thread (e5m1_2knights_spawn());
	thread (e5m1_switch_start());
	thread (vo_e5m2_playstart());
	ai_place (sq_e5m1_5bish_01);
	ai_place (sq_e5m1_5bish_02);
	ai_place (sq_e5m1_3bish_01);
	ai_place (sq_e5m1_2bish_03);
	ai_place_with_shards (sq_e5m2_turr_01);
	ai_prefer_target_team (gr_e5m2_initialbish, player);
	f_unblip_flag (fl_e5m1_stage_flag01);
	sleep (30 * 2);
	ai_prefer_target_ai (sq_e5m1_2bish_03, sq_e5m1_marines_01, TRUE);
	sleep (30 * 5);
	sleep (30 * 1);
	ai_place_in_limbo (sq_e5m1_1kni_01);
	thread(f_music_e5m1_baddies_vo());
	ai_prefer_target_team (sq_e5m1_1kni_01, player);
	f_new_objective (e5m1_obj_allenemies);
end

script static void e5m2_marines_retreat()
	sleep_until (ai_living_count (sq_e5m1_2bish_03) <= 0, 1);
	e5m2_takecover = TRUE;
end

script static void e5m1_endgoal02
	sleep_until (LevelEventStatus ("e5m1_goal02_end"), 1);
	thread(f_music_e5m1_endgoal02());
	print ("ending the goal 02");
	sleep (30 * 2);
	sleep_until (e5m2_narrative_is_on == FALSE);
	sleep (30 * 1);
	
	b_end_player_goal = TRUE;
end


//343++343==343++343==343++343//	E2M5 Goal 03 Scripts (2. time_passed)	//343++343==343++343==343++343//	

script static void e5m2_millersreturn()
	sleep_until (LevelEventStatus ("e5m2_millersreturn"), 1);
	thread (vo_e5m2_afterstart());
	thread (e5m2_boydsreturn());
	sleep (30 * 2);
	sleep_until (e5m2_narrative_is_on == FALSE);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end




//343++343==343++343==343++343//	E2M5 Goal 05 Scripts (3. time_passed)	//343++343==343++343==343++343//	

script static void e5m2_boydsreturn()
	sleep_until (LevelEventStatus ("e5m2_boydsreturn"), 1);
	sleep (30 * 2);
	thread (vo_e5m2_whatnow());
	thread (e5m2_sittight01());
	thread (e5m2_use_switch());
	thread (e5m2_sittight02());
	thread (e5m2_sittight03());
	thread (e5m2_sittight04());
	thread (e5m2_sittight05());
	thread (e5m2_sittight06());
	sleep (30 * 2);
	sleep_until (e5m2_narrative_is_on == FALSE);
	sleep (30 * 1);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E2M5 Goal 06 Scripts (4. no_more_waves)	//343++343==343++343==343++343//	

script static void e5m2_sittight01()
	sleep_until (LevelEventStatus ("e5m2_sittight"), 1);
	thread (vo_e5m2_sittightdoctor());
end


script static void e5m2_sittight02()
	sleep_until (LevelEventStatus ("e5m2_sittight02"), 1);
	ai_place (sq_e5m1_4paw_04);
	ai_place (sq_e5m1_4paw_05);
	ai_place (sq_e5m1_4paw_06);
end


script static void e5m2_sittight03()
	sleep_until (LevelEventStatus ("e5m2_sittight03"), 1);
	ai_place (sq_e5m1_4paw_07);
end


script static void e5m2_sittight04()
	sleep_until (LevelEventStatus ("e5m2_sittight04"), 1);
	ai_place_in_limbo (sq_e5m1_2kni_02);
	ai_place_with_birth (sq_e5m1_2bish_02);
end

script static void e5m2_sittight05()
	sleep_until (LevelEventStatus ("e5m2_sittight05"), 1);
	ai_place (sq_e5m1_4paw_08);
end

script static void e5m2_sittight06()
	sleep_until (LevelEventStatus ("e5m2_sittight06"), 1);
	ai_place (sq_e5m1_4paw_09);
end

//	Add awesome encounter here, Allan.


//343++343==343++343==343++343//	E2M5 Goal 04 Scripts (5. no_more_waves)	//343++343==343++343==343++343//	

script static void e5m2_givecover()
	sleep_until (LevelEventStatus ("e5m2_givecover"), 1);
	thread (e5m2_covervo());
	print ("Cover VO played");
	sleep_until (e5m2_narrative_is_on == FALSE);
	ai_renew (sq_e5m1_scientists_01);
	f_blip_ai_cui (sq_e5m1_scientists_01, "navpoint_healthbar_defend");
end

script static void e5m2_covervo()
	if (ai_living_count (sq_e5m1_scientists_01) >= 1)	then 
	thread (vo_e5m2_givecover());
	else (thread(vo_e5m2_crawlers_callout()));
	end
end

script static void e5m1_pawns01_spawn()
	sleep_until (LevelEventStatus ("e5m1_pawns01_spawn"), 1);
	ai_place (sq_e5m1_2paw_01);
	ai_place (sq_e5m1_2paw_02);
	ai_place (sq_e5m1_2paw_03);
	ai_place (sq_e5m1_2paw_04);
	ai_place (sq_e5m1_2paw_05);
	thread(f_music_e5m1_pawns01_spawn());
	sleep (30 * 1);
	f_blip_ai_cui (gr_e5m2_10paw01, "navpoint_enemy");
end

script static void e5m1_pawns02_spawn
	sleep_until (LevelEventStatus ("e5m1_pawns02_spawn"), 1);
	ai_place (sq_e5m1_5paw_01);
	thread(f_music_e5m1_pawns02_spawn());
	sleep (30 * 1);
	f_blip_ai_cui (sq_e5m1_5paw_01, "navpoint_enemy");
end

script static void e5m1_pawns03_spawn
	sleep_until (LevelEventStatus ("e5m1_pawns03_spawn"), 1);
	ai_place (sq_e5m1_5paw_02);
	thread(f_music_e5m1_pawns03_spawn());
	sleep (30 * 1);
	f_blip_ai_cui (sq_e5m1_5paw_02, "navpoint_enemy");
end

script static void e5m1_1kni03_spawn
	sleep_until (LevelEventStatus ("e5m1_1kni03_spawn"), 1);
	thread(f_music_e5m1_1kni03_spawn());
	ai_place_in_limbo (sq_e5m1_1kni_03);
	ai_place_with_birth (sq_e5m1_1bish_01);
	ai_place (sq_e5m1_4paw_02);
	sleep (30 * 2);
	f_blip_ai_cui (sq_e5m1_1bish_01, "navpoint_enemy");
	f_blip_ai_cui (sq_e5m1_1kni_03, "navpoint_enemy");
	f_blip_ai_cui (sq_e5m1_4paw_02, "navpoint_enemy");
end

script static void e5m1_4paw01_spawn
	sleep_until (LevelEventStatus ("e5m1_4pawns01_spawn"), 1);
	ai_place (sq_e5m1_4paw_01);
	thread(f_music_e5m1_4paw01_spawn());
	sleep (30 * 1);
	f_blip_ai_cui (sq_e5m1_4paw_01, "navpoint_enemy");
end

script static void e5m1_4paw03_spawn
	sleep_until (LevelEventStatus ("e5m1_4pawns03_spawn"), 1);
	ai_place (sq_e5m1_4paw_03);
	thread(f_music_e5m1_4paw03_spawn());
	sleep (30 * 1);
	f_blip_ai_cui (sq_e5m1_4paw_03, "navpoint_enemy");
end

script static void e5m1_2knights_spawn
	sleep_until (LevelEventStatus ("e5m1_2knights"), 1);
	ai_place_in_limbo (sq_e5m1_2kni_01);
	thread(f_music_e5m1_2knights_spawn());	
	sleep (30 * 2);
	thread (vo_e5m2_knights_callout01());
	sleep (30 * 2);
	sleep_until (e5m2_narrative_is_on == FALSE);
	f_blip_ai_cui (sq_e5m1_2kni_01, "navpoint_enemy");
end


//343++343==343++343==343++343//	E2M5 Goal 07 Scripts (6. time_passed)	//343++343==343++343==343++343//	

script static void e5m2_use_switch()
	sleep_until (LevelEventStatus ("e5m2_useswitch"), 1);
	thread (vo_e5m2_useswitch());
	thread (e5m2_machines_animate());
	sleep (30 * 2);
	sleep_until (e5m2_narrative_is_on == FALSE);
	thread (e5m1_switch_reenforcements());
	thread (e5m1_1kni04_spawn());
	thread (e5m1_teletech_revealed());
	f_unblip_ai_cui (sq_e5m1_scientists_01);
	thread (vo_e5m2_thatswitch());
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E2M5 Goal 08 Scripts (7. object_destruction)	//343++343==343++343==343++343//	

script static void e5m1_switch_start
	sleep_until (LevelEventStatus ("e5m1_hittheswitch"), 1);
	device_set_power (e5m1_teleporter_release, 1);
	thread (e5m1_switch_toolong());
	thread(f_music_e5m1_switch_start());
	f_new_objective (e5m1_obj_switch);
end


script static void e5m1_switch_toolong()
	sleep (30 * 90);
	if	(e5m1_nottoolong == FALSE)	then
		thread(f_music_e5m1_switchnow_vo());
		thread (vo_e5m2_switchnow());
	else
		sleep (30);
	end
end

script static void e5m1_switch_reenforcements
	sleep_until (LevelEventStatus ("e5m1_switchreinforcements"), 1);
	ai_place_in_limbo (sq_e5m1_1kni_02);
	ai_place (sq_e5m1_2bish_01);
	ai_place (sq_e5m1_6paw_01);
	thread(f_music_e5m1_switch_reenforcements());
end

script static void e5m1_1kni04_spawn
	sleep_until (LevelEventStatus ("e5m1_1kni04_spawn"), 1);
	ai_place_in_limbo (sq_e5m1_1kni_04);
	ai_place_with_birth (sq_e5m1_5bish_04);
	sleep (30 * 4);
	thread (vo_e5m2_watchers());
	thread(f_music_e5m1_watchers_vo());
end
//343++343==343++343==343++343//	E2M5 Goal 09 Scripts (8. time_passed)	//343++343==343++343==343++343//	

script static void e5m2_machines_animate()
	sleep_until (LevelEventStatus ("e5m2_machines"), 1);
	thread (e5m1_3knights01());
	thread (e5m1_10paw03());
	thread (e5m1_03bish01());
	thread (e5m1_cleanup());
	thread (e5m1_end());
	e5m1_nottoolong = TRUE;
	b_wait_for_narrative_hud = TRUE;
	thread (vo_e5m2_deactivated());
	thread (f_music_e5m1_deactivated_vo());
	object_destroy (e5m1_teleporter_release);
	device_set_position (e5m1_switch_glowyyellowbits, 1);
	e5m1_switch_glowyyellowbits->SetDerezWhenActivated();
	sleep_until (device_get_position(e5m1_switch_glowyyellowbits) == 1, 1);
	object_dissolve_from_marker(e5m1_fore_terminal, phase_out, dissolve_mkr);
	e5m2_shell_open = TRUE;
	
	device_set_position ( e5m1_topaperture, 1);
	sleep_until (device_get_position(e5m1_topaperture) == 1, 1);
	sound_impulse_start('sound\environments\multiplayer\temple\machines\new_machines\machine_72_temple_aperature01_transform.sound', e5m1_topaperture, 1);
	
	device_set_position ( e5m1_bottomaperture, 1);
	sound_impulse_start('sound\environments\multiplayer\temple\machines\new_machines\machine_72_temple_aperature01_transform.sound', e5m1_bottomaperture, 1);

	sleep_until (device_get_position(e5m1_bottomaperture) == 1, 1);
	
	object_move_to_flag ( e5m1_teleporter_tech, 5, fl_e5m1_tech02);
	sound_impulse_start('sound\environments\multiplayer\temple\machines\new_machines\machine_72_temple_aperature01_energy_ball_exit.sound', e5m1_bottomaperture, 1);
	sleep_until (e5m2_narrative_is_on == FALSE);
	object_destroy (e5m1_switch_glowyyellowbits);
	object_destroy (e5m1_fore_terminal);
	b_end_player_goal = TRUE;
end

//343++343==343++343==343++343//	E2M5 Goal 10 Scripts (9. object_destruction)	//343++343==343++343==343++343//	

script static void e5m1_teletech_revealed
	sleep_until (LevelEventStatus ("e5m1_teleportertech"), 1);
	b_wait_for_narrative_hud = FALSE;
	object_can_take_damage (e5m1_teleporter_tech);
	thread (vo_e5m2_blowitup());
	thread (f_music_e5m1_blowitup_vo());
	sleep (30 * 3);
	f_new_objective (e5m1_obj_destroy);
end

script static void e5m1_3knights01()
	sleep_until (LevelEventStatus ("e5m1_teleporterdestroy"), 1);
	ai_place_in_limbo (sq_e5m1_3kni_01);
	thread(f_music_e5m1_3knights01());
end

script static void e5m1_10paw03()
	sleep_until (LevelEventStatus ("e5m1_10paw03"), 1);
	ai_place (sq_e5m1_2paw_06);
	ai_place (sq_e5m1_2paw_07);
	ai_place (sq_e5m1_2paw_08);
	ai_place (sq_e5m1_2paw_09);
	ai_place (sq_e5m1_2paw_10);
	thread(f_music_e5m1_10paw03());
end

script static void e5m1_03bish01()
	sleep_until (LevelEventStatus ("e5m1_03bish01"), 1);
	ai_place_with_birth (sq_e5m1_3bish_02);
	thread(f_music_e5m1_03bish01());
end

script static void e5m1_1bish_02()
	sleep_until (LevelEventStatus ("e5m1_1bish02"), 1);
	if (ai_living_count (sq_e5m1_3kni_01) <= 0)	then
		ai_place_with_birth (sq_e5m1_1bish_02);
	else (sleep (30 * 2));
	end
end

//343++343==343++343==343++343//	E2M5 Goal 11 Scripts	(10. no_more_waves) //343++343==343++343==343++343//	

script static void e5m1_cleanup
	sleep_until (LevelEventStatus ("e5m1_cleanup"), 1);
	e5m2_obj_destroyed = TRUE;
	thread (e5m2_dissolve_shell());
	if (ai_living_count (e5m1_ff_all) > 0)	then
		f_objective_complete();
		sleep(30 * 4);
		thread (f_music_e5m1_ifstillbaddies_vo());
		thread (vo_e5m2_ifstillbaddies());
		f_new_objective (e5m1_obj_remaining);
		sleep_until (ai_living_count (e5m1_ff_all) == 0);
		sleep (30 * 1);
	end
end

script static void e5m2_dissolve_shell()
	e5m2_shell_dead = TRUE;
	sleep (30 * 2);
	print ("waiting for spinning animation to complete");
	sleep_until (e5m2_shell_dissolve == TRUE);
	print ("spinning animation complete. dissolving now.");
	object_dissolve_from_marker(e5m2_shell, phase_out, dissolve_mkr);
	sound_impulse_start('sound\environments\multiplayer\temple\machines\new_machines\machine_72_temple_temple_energy_core_derez.sound', e5m2_shell, 1);
	sleep (30 * 10);
	object_destroy (e5m2_shell);
	e4m5_shelldestroyed = TRUE;
	print ("object should be destroyed now");
end
	

//343++343==343++343==343++343//	E2M5 Goal 12 Scripts	(11. time_passed) //343++343==343++343==343++343//	

script static void e5m1_end()
	sleep_until (LevelEventStatus ("e5m1_end"), 1);
	thread (f_music_e5m1_ifallclear_vo());
	thread (vo_e5m2_ifallclear());
	sleep (30 * 2);
	f_objective_complete();
	sleep_until (e5m2_narrative_is_on == FALSE);
	sleep (30 * 1);
	if (ai_living_count (gr_e5m2_scientists) == 3)	then
		thread (vo_e5m2_ifnonedead());
		print ("5 left alive");
	elseif (ai_living_count (gr_e5m2_scientists) >= 1) and (ai_living_count (gr_e5m2_scientists) <= 2)	then
		thread (vo_e5m2_ifsomedead());
		print ("less than 5 left alive");
	elseif ((ai_living_count (gr_e5m2_scientists) == 0))	then
		thread (vo_e5m2_ifalldead());
		print ("World's worst superhero.");
	end
	
	sleep (30 * 3);
	sleep_until (e5m2_narrative_is_on == FALSE);
	thread(f_music_e5m1_finish());
	sleep_until (e4m5_shelldestroyed == TRUE);
	sleep (30 * 2);
	e5m2_hide_players_outro();
	fade_out (0, 0, 0, 15);
	cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
	print ("DONE!");
	sleep (30 * 1);
	b_end_player_goal = true;
end

script static void e5m2_hide_players_outro
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
		object_hide (player1, true);
	else
		object_hide (player0, true);
	end
end

//343++343==343++343==343++343//	E2M5 Placement Scripts	//343++343==343++343==343++343//	

//	Forerunner Spawn Scripts

script command_script cs_e5m1_knights_phasein
	cs_phase_in();
end

script command_script cs_e5m1_knights01_phasein
	cs_phase_in();
	sleep (30 * 1);
	cs_phase_to_point (sq_e5m1_1kni_01, TRUE, ps_e5m1_knight_spawns.p0);
end

script command_script cs_e5m1_knights05_phasein
	cs_phase_in();
	sleep (30 * 1);
	cs_phase_to_point (sq_e5m1_1kni_05, TRUE, ps_e5m1_knight_spawns.p1);
end

script command_script cs_e5m1_knights06_phasein
	cs_phase_in();
	sleep (30 * 1);
	cs_phase_to_point (sq_e5m1_1kni_06, TRUE, ps_e5m1_knight_spawns.p2);
end

script command_script cs_e5m1_pawn_spawn
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script command_script cs_e5m1_pawn_scream_spawn
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
	sleep_rand_s (0.5, 3);
	cs_custom_animation (objects\characters\storm_pawn\storm_pawn.model_animation_graph, "combat:any:taunt", FALSE);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_e5m2_pawn_scream_01);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_e5m2_pawn_scream_02);
	effect_new (objects\characters\storm_pawn\fx\pawn_phase_in.effect, fl_e5m2_pawn_scream_03);
end

script command_script cs_e5m1_bishop_spawn()
	ai_enter_limbo (ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_BIRTHER, ai_get_object(ai_current_actor), e5m1_OnCompleteBishopBirth, 0);
	sleep (30 * 30);
	if (ai_in_limbo_count (ai_current_actor) > 0)	then
		ai_erase (ai_current_actor);
		else (sleep (30 * 1));
	end
end 

script static void e5m1_OnCompleteBishopBirth()
	print ("Bishop spawned");
end

script command_script cs_e5m1_pawn_birth
	print("pawn sleeping");
	ai_enter_limbo(ai_current_actor);
	CreateDynamicTask(TT_SPAWN, FT_SPAWNER, ai_get_object(ai_current_actor), e5m1_OnCompleteProtoSpawn, 1.5);
	if (ai_in_limbo_count (ai_current_actor) > 0)	then
		ai_erase (ai_current_actor);
		else (sleep (30 * 1));
	end
end

script static void e5m1_OnCompleteProtoSpawn()
	print ("Pawn Birthed");
end

//343++343==343++343==343++343//	E2M5 Misc Script	//343++343==343++343==343++343//	



//	Mission Chapter Titles

