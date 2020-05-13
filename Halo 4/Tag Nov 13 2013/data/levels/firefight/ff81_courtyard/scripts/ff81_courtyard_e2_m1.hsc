// =============================================================================================================================
// ========= CATHEDRAL FIREFIGHT SCRIPT ========================================================
// =============================================================================================================================

//========= GLOBAL===================================================================

global short s_e2m1_forward_progress = 0;			// players' physical progress through map
global short s_e2m1_bkp_goal_position = 2;		// determines where backup squad will head, for variety
global short s_e2m1_shade1_done = 0;					// used to spawn replacement cannoneers
global short s_e2m1_shade2_done = 0;					// used to spawn replacement cannoneers
global short s_e2m1_bkp_threshhold = 16;			// will be evaluated "less than"
global short s_e2m1_aa_powerdown_count = 0;		// used to synchronize AA Gun power down
global short s_e2m1_backup_count = 0;					// used to prevent infinite backup spawning
global short s_e2m1_pawn_count = 0;						// used to prevent infinite backup spawning
global boolean b_e2m1_switches_flipped = false;		// prevents switches sequence from firing twice
global boolean b_e2m1_final_enc = false;			// marks the beginning of the final encounter
global boolean s_e2m1_shade_sub = FALSE;			// if true, spawn replacement cannoneer in place of ground reinforcements
global boolean s_e2m1_init = FALSE;						// flipped after first 6 backup spawn
global boolean s_e2m1_stg2_init = FALSE;			// flipped after first stage 2 trigger hit
global boolean s_e2m1_installation_reached = FALSE;	// flipped once installation is reached
global boolean b_e2m1_stop_firing = FALSE;		// flipped once switches flipped
global boolean b_e2m1_knight_bit = FALSE; 		// determines whether a knight rushes or not (aio)
global boolean b_e2m1_vo_all_done = FALSE;		// used to end the scenario
global boolean b_e2m1_conch = FALSE;					// WHOEVER HOLDS THE CONCH GETS TO SPEAK
global boolean b_e2m1_intro_done = FALSE;			// flipped at end of intro puppeteer
global string e2m1_vo_func = "nil";						// test for passing a function name into a function
// =============================================================================================================================

//== startup
script startup courtyard_e2_m1
	//Start the intro
	
	sleep_until (LevelEventStatus("e2_m1_startup"), 1);
	fade_out (0,0,0,1);
	thread(f_music_e2m1_start());

	print ("************************************************STARTING E2 M1*********************");
	switch_zone_set (e2_m1);
	mission_is_e2_m1 = true;
	ai_ff_all = e2m1_all_foes;
	b_wait_for_narrative = true;
	
//	gr_ff_remaining = e2m1_blip_guys; //these guys get blipped but don't count toward bonobo blip limits

//start vignette
	thread(f_start_player_intro_e2_m1());

//== load objects ==================================================================
f_add_crate_folder(e2m1_crates); 
f_add_crate_folder(e2m1_weapon_lockers); 
f_add_crate_folder(e2m1_loose_weapons); 
f_add_crate_folder(e2m1_vehs);
f_add_crate_folder(e2m1_controls);
f_add_crate_folder(e2m1_lzs);
f_add_crate_folder(e2m1_dms);
object_destroy(e3m5_tower_base);															//tjp
object_destroy(e3m5_watchtower_pod);													//tjp
//== set spawn folder names
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_0, 90); //spawns in the main starting area
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_1, 91); // Pinch point, east-west split
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_2, 92); // approach, east-west split
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_3, 93); // WEST approach
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_4, 94); // EAST approach
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_5, 95); // mid-tier, EAST
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_6, 96); // mid-tier, WEST
	firefight_mode_set_crate_folder_at(e2m1_spawn_points_7, 97); // knights wave, various locs
	
//== set objective names
	firefight_mode_set_objective_name_at(dc_e2m1_w_switch, 81); //uplink module on back middle
	firefight_mode_set_objective_name_at(dc_e2m1_e_switch, 82); //uplink module on back middle
	
//== set LZ spots
		firefight_mode_set_objective_name_at(e2m1_lz_1, 50); //objective in the main spawn area
		firefight_mode_set_objective_name_at(e2m1_lz_2, 51); //objective in the main spawn area
		firefight_mode_set_objective_name_at(e2m1_lz_3, 52); //objective in the main spawn area
		
//== set squad group names

	firefight_mode_set_squad_at(e2m1_stg1_w_lane, 1);	//left building
	firefight_mode_set_squad_at(e2m1_stg1_m_lane, 2);	//front by the main start area
	firefight_mode_set_squad_at(e2m1_stg1_e_lane, 3);	//back middle building
//	firefight_mode_set_squad_at(e2m1_stg1_w_alphas, 4); //in the main start area
//	firefight_mode_set_squad_at(e2m1_stg1_m_alphas, 5); //right side in the back
//	firefight_mode_set_squad_at(e2m1_stg1_e_alphas, 6); //right side in the back at the back structure
	firefight_mode_set_squad_at(e2m1_stg1_rocktop, 7); //middle building at the front
	firefight_mode_set_squad_at(e2m1_stg1_cannoneer_a, 8); //on the bridge

//start the first starting event
	thread (f_start_events_e2_m1_1());	

	firefight_mode_set_player_spawn_suppressed(false);
end

script static void f_start_player_intro_e2_m1
	firefight_mode_set_player_spawn_suppressed(true);
	if editor_mode() then
		sleep_s (1);
		b_wait_for_narrative = true;
		firefight_mode_set_player_spawn_suppressed(false);
	else
		sleep_until  (LevelEventStatus("loadout_screen_complete"), 1, 8 * 30); 
		b_wait_for_narrative = true;
		intro_vignette_e2_m1();
	end
	thread(f_e2m1_init_place_all());
	firefight_mode_set_player_spawn_suppressed(false);
	fade_out (0,0,0,1);
	print ("_____________done with vignette---SPAWNING__________________");
	firefight_mode_set_player_spawn_suppressed(false);
	//sleep until the player is alive before fading in to prevent bad camera while spawning
	sleep_until (b_players_are_alive(), 1);
//	print ("player is alive");
	sleep (4);
	fade_in (0,0,0,30);
end

script static void intro_vignette_e2_m1
	//initialize the game for “interruptive” cutscenes (no split screen)
	cinematic_start();
	print ("_____________starting vignette__________________");
	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e2m1_vin_sfx_intro', NONE, 1);
	thread(f_music_e2m1_vignette_start());
	//play the puppeteer
	pup_play_show (e2_m1_intro);
	thread(e2m1_vo(1));
			// Miller : Comms are open, Commander Palmer.  Crimson's online.  The Op is live.
			// Palmer : Thank you, Spartan Miller.
			// Palmer : Crimson your job today is to dig out some nasty Covenant squatters.  They've parked themselves in this hole with anti-air guns and they're proving themselves to be quite the pain in the UNSC's ass.
			// Palmer : Hit 'em fast, hit 'em hard, don't leave anyone standing.
	// wait until the puppeteer is complete		
	sleep_until(b_e2m1_intro_done == true);
	//turn off split screen
	cinematic_stop();
	thread(f_music_e2m1_vignette_finish(), 1);
end



script static void f_start_events_e2_m1_1
//	print ("***********************************STARTING start_e2_m1_1  EVENTS***********************");
//	sound_looping_start (music_start, NONE, 1.0);
//	sound_looping_start (music_mid_beat, NONE, 1.0);
ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e2_m1.scenery",
														"objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");

//==mucho threado
	thread(e2m1_trigcheck_turret_vo());
	thread(e2m1_cleanup_vo_2());
	thread(e2m1_fr_megawave());
	thread(e2m1_wind_down());
	thread(e2m1_all_clear());
	
	thread(e2m1_forward_progress_tracker_1());
	thread(e2m1_stage3_bishop_backup());
	thread(e2m1_silence_the_guns());
	thread(f_e2m1_killvolume());
	thread(f_e2m1_interfaces());
	
	kill_volume_disable(kill_air);
	kill_volume_disable(kill_air_2);
	
	kill_volume_disable(kill_megazon_a);
	kill_volume_disable(kill_megazon_b);
	kill_volume_disable(kill_megazon_c);
	kill_volume_disable(kill_megazon_d);
	kill_volume_disable(kill_megazon_e);
	kill_volume_disable(kill_megazon_f);
	
	//kill_volume_disable(kill_megazon);
	object_destroy_folder(kill_volumes);

	sleep(30*2);
	
	ai_place_in_limbo(e2m1_avt_driver_1);
			//3.075338, -9.926035, 0.199065
			//-59.653194, -0.000000, -0.000000
	
	ai_place_in_limbo(e2m1_avt_driver_2);
			// -3.881309, -9.795074, 0.199065
			// -115.829231, -0.000000, -0.000000
	
	ai_place_in_limbo(e2m1_avt_driver_3);
			//6.381057, -5.064147, 0.217123
			//0.184686, -0.000000, -0.000000
			
	ai_place_in_limbo(e2m1_avt_driver_4);
			//-7.426475, -5.029549, 0.217123
			//178.933762, -0.000000, -0.000000
			
//	print ("everyone spawned");
	sleep(1);
	cs_run_command_script (e2m1_avt_driver_1, cs_e2m1_turret_1);
	cs_run_command_script (e2m1_avt_driver_2, cs_e2m1_turret_2);
	cs_run_command_script (e2m1_avt_driver_3, cs_e2m1_turret_3);
	cs_run_command_script (e2m1_avt_driver_4, cs_e2m1_turret_4);
	sleep (4);
	fade_in (0,0,0,30);
	ai_jump_cost_scale(5.0);
end
script static void f_e2m1_init_place_all
	// wait until the puppeteer is complete		
	ai_place(e2m1_stg1_w_lane);
//	print ("first guy spawned");
	ai_place(e2m1_stg1_m_lane);
	ai_place(e2m1_stg1_e_lane);
	ai_place(e2m1_stg1_rocktop);
//	print ("laners spawned");
	ai_place(e2m1_stg1_w_alphas);
	ai_place(e2m1_stg1_m_alphas);
	ai_place(e2m1_stg1_e_alphas);
//	print ("alphas spawned");
	ai_place(e2m1_stg1_cannoneer_a);
	ai_place(e2m1_stg1_cannoneer_b);
	ai_place(e2m1_stg1_w_mid);
	ai_place(e2m1_stg1_m_mid);
	ai_place(e2m1_stg1_e_mid);
//	print ("covenant all spawned");
	ai_place(e2m1_stg1_turret);
	ai_place(e2m1_bishop_1);
	ai_place(e2m1_bishop_2);
//	print ("forerunner spawned");
end
script command_script cs_e2m1_turret_1  
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .2, 0);
	cs_shoot_point(true, e2m1_fire_points.p1);
	sleep(14);
	object_cannot_take_damage(ai_get_object(e2m1_avt_driver_1));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)
	cs_shoot_point(true, e2m1_fire_points.p1);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p0);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p2);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p10);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p5);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p10);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p5);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p0);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p10);
	sleep(30 * 5);

  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e2m1_fire_points.p1);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p1);
      	sleep_rand_s(3.0,5);
      	cs_shoot_point(true, e2m1_fire_points.p4);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p4);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p4);
      	sleep_rand_s(3.0,5);
     end
                               
     begin
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_s(2.0);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_rand_s(5.0,7);
      cs_shoot_point(true, e2m1_fire_points.p3);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p3);
      sleep_rand_s(1.0,3);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_rand_s(3.0,5);
     end
                                
     begin
	     cs_shoot_point(true, e2m1_fire_points.p5);
	     sleep_rand_s(3.0,5);
	     cs_shoot_point(true, e2m1_fire_points.p10);
	     sleep_rand_s(3.0,5);
     end
                                                
     begin
     	cs_shoot_point(true, e2m1_fire_points.p2);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p2);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p2);
      sleep_rand_s(3.0,5);
     end
	end
	until( b_e2m1_stop_firing == TRUE);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
end

script command_script cs_e2m1_turret_2
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .2, 0);
	sleep(14);
	object_cannot_take_damage(ai_get_object(e2m1_avt_driver_2));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)
	cs_shoot_point(true, e2m1_fire_points.p6);
	sleep(30 * 4);
	cs_shoot(false);
	sleep(30 * 1.5);
	cs_shoot_point(true, e2m1_fire_points.p8);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p9);
	sleep(30 * 4);
	cs_shoot(false);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p5);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p10);
	sleep(30 * 6);
	cs_shoot_point(true, e2m1_fire_points.p7);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p9);
	sleep(30 * 4);
	
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e2m1_fire_points.p6);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p6);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p6);
      	sleep_rand_s(1.0,3);
      	cs_shoot_point(true, e2m1_fire_points.p8);
      	sleep_s(0.25);
      	cs_shoot_point(true, e2m1_fire_points.p8);
      	sleep_rand_s(1.0,3);
      	cs_shoot_point(true, e2m1_fire_points.p9);
      	sleep_rand_s(3.0,4);
     end
                               
     begin
      cs_shoot_point(true, e2m1_fire_points.p5);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p5);
      sleep_rand_s(3.0,4);
      cs_shoot_point(true, e2m1_fire_points.p9);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p9);
      sleep_rand_s(3.0,4);
     end
                                
     begin
     	cs_shoot_point(true, e2m1_fire_points.p10);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p10);
      sleep_s(0.25);
      cs_shoot_point(true, e2m1_fire_points.p10);
      sleep_s(0.75);
      cs_shoot_point(true, e2m1_fire_points.p10);
			sleep_rand_s(5.0,7);
     end
                                                
     begin
     	cs_shoot_point(true, e2m1_fire_points.p7);
     	sleep_s(0.25);
			cs_shoot_point(true, e2m1_fire_points.p7);
      sleep_rand_s(3.0,4);
      cs_shoot_point(true, e2m1_fire_points.p10);
      sleep_rand_s(3.0,4);
     end
	end
	until( b_e2m1_stop_firing == TRUE);
	sleep(3);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
end

script command_script cs_e2m1_turret_3
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .2, 0);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(14);
	object_cannot_take_damage(ai_get_object(e2m1_avt_driver_3));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
	// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p12);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p0);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p13);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p2);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p12);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p0);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p13);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p2);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p4);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p12);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p11);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p0);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p13);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p2);
	sleep(30 * 2);
	cs_shoot_point(true, e2m1_fire_points.p4);
	
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e2m1_fire_points.p11);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p11);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p11);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p11);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p11);
      	sleep_rand_s(5.0,7);
     end

    	begin
      	cs_shoot_point(true, e2m1_fire_points.p12);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p12);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p12);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p12);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p12);
      	sleep_rand_s(3.0,7);
      	cs_shoot_point(true, e2m1_fire_points.p0);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p0);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p0);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p0);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p0);
      	sleep_rand_s(5.0,7);
     end
                            
    	begin
      	cs_shoot_point(true, e2m1_fire_points.p13);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p13);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p13);
      	sleep_rand_s(3.0,7);
      	cs_shoot_point(true, e2m1_fire_points.p2);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p2);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p2);
      	sleep_rand_s(5.0,7);
     end
    
     begin
      cs_shoot_point(true, e2m1_fire_points.p4);
      sleep_s(1.00);
      cs_shoot_point(true, e2m1_fire_points.p4);
      sleep_rand_s(3.0,4);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_s(1.00);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_s(1.00);
      cs_shoot_point(true, e2m1_fire_points.p0);
      sleep_rand_s(5.0,7);
     end
	end
	until( b_e2m1_stop_firing == TRUE);
	sleep(6);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
end

script command_script cs_e2m1_turret_4
	object_set_scale(ai_vehicle_get ( ai_current_actor ), .2, 0);
	sleep(14);
	object_cannot_take_damage(ai_get_object(e2m1_avt_driver_4));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	ai_exit_limbo(ai_current_actor);
	sleep(4);
// 7-5-12 adding initial deterministic sequence for puppeteer (for audio)
	cs_shoot_point(true, e2m1_fire_points.p14);
	sleep(30 * 5);
	cs_shoot_point(true, e2m1_fire_points.p15);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p14);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p15);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p16);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p7);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p16);
	sleep(30 * 4);
	cs_shoot_point(true, e2m1_fire_points.p9);
	sleep(30);
	cs_shoot_point(true, e2m1_fire_points.p7);
	sleep(30 * 5);
	cs_shoot_point(true, e2m1_fire_points.p9);
	sleep(30 * 5);
	cs_shoot_point(true, e2m1_fire_points.p14);
	sleep(30 * 5);

  repeat
  	begin_random
		begin
      	cs_shoot_point(true, e2m1_fire_points.p14);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p14);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p14);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p14);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p14);
      	sleep_rand_s(5.0,7);
    end                                     
		begin
      	cs_shoot_point(true, e2m1_fire_points.p16);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p16);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p16);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p16);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p16);
      	sleep_rand_s(5.0,7);
     end
    begin
      	cs_shoot_point(true, e2m1_fire_points.p15);
      	sleep_s(2.00);
      	cs_shoot_point(true, e2m1_fire_points.p15);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p15);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p15);
      	sleep_s(3.00);
      	cs_shoot_point(true, e2m1_fire_points.p15);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p15);      	
      	sleep_rand_s(5.0,7);
     end
    begin
      	cs_shoot_point(true, e2m1_fire_points.p7);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p7);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p7);
      	sleep_s(4.00);
      	cs_shoot_point(true, e2m1_fire_points.p9);
      	sleep_s(1.00);
      	cs_shoot_point(true, e2m1_fire_points.p9);
      	sleep_rand_s(5.0,7);
     end
	end
	until( b_e2m1_stop_firing == TRUE);
	sleep(9);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
end
//== VO-related

//script static void e2m1_vo_play(function_name blah) 				//wish this worked!
//	b_e2m1_conch = true;
//	wake(blah);
//end

script static void e2m1_vo(short vo)													//we'll do this instead
	sleep_until(b_e2m1_conch == false);
	b_e2m1_conch = true;
	if(vo == 1)then
		wake(e2m1_vo_intro);
		thread(f_music_e2m1_intro_vo());
		// Miller : Comms are open, Commander Palmer.  Crimson's online.  The Op is live.
		// Palmer : Thank you, Spartan Miller.
		// Palmer : Crimson your job today is to dig out some nasty Covenant squatters.  They've parked themselves in this hole with anti-air guns and they're proving themselves to be quite the pain in the UNSC's ass.
		// Palmer : Hit 'em fast, hit 'em hard, don't leave anyone standing.
	elseif(vo == 2)then								
		wake(e2m1_vo_targetguns);
		thread(f_music_e2m1_targetguns_vo());
		// Miller : I've got a lock on the control systems for those guns, Commander.
		// Palmer : Show Crimson where to go.
	elseif(vo == 3)then									// on early trigger or timer
		wake(e2m1_vo_turrets1);
		thread(f_music_e2m1_turrets1_vo());
		// Miller : Whoa!  Mounted turrets.
		// Palmer : Take it slow, Crimson.  No need to rush.
	elseif(vo == 4)then									// x time after the above?
		wake(e2m1_vo_watchers);
		thread(f_music_e2m1_watchers_vo());				
		// Miller : Commander, there's a few Watchers in the air.
		// Palmer : So not just Covenant, but Prometheans too.  Noted.
	elseif(vo == 5)then
		wake(e2m1_vo_daltonaa);							// shortly after first prom objective enabled
		thread(f_music_e2m1_daltonaa_vo());
		// Dalton : Commander Palmer, how long until those guns are offline?  I can't get a bird within ten klicks of that location.
		// Palmer : Settle down, Dalton, we're working on it.
	elseif(vo == 6)then
		wake(e2m1_vo_fewmorecov);						// on Stage3 almost complete
		thread(f_music_e2m1_fewmorecov_vo());
		// Miller : Almost done.  Just a few to go.
	elseif(vo == 7)then									// on Stage3 complete
		wake(e2m1_vo_areaclear);
		thread(f_music_e2m1_areaclear_vo());
		// Miller : Area's clear, Commander.
	elseif(vo == 8)then									// intro to pylon objective
		wake(e2m1_vo_targetpylons);
		thread(f_music_e2m1_targetpylons_vo());
		// Palmer : Let's get those AA guns offline.
		// Miller : Marking the power conduit pylons now.  There you go, Crimson.
	elseif(vo == 9)then									// first pylon down
		wake(e2m1_vo_pylon1down);
		thread(f_music_e2m1_pylon1down_vo());
		// Miller : One pylon offline.
	elseif(vo == 10)then								// both pylons down
		print ("vo10 started");
		wake(e2m1_vo_bothpylonsdown);
		print ("vo10 waked");
		thread(f_music_e2m1_bothpylonsdown_vo());
		// Miller : That's both pylons, Comman--Whoa.  A slipspace signature just blipped near Crimson.
		// Palmer : Point the way, Miller.  Let's have a look.
	elseif(vo == 11)then								// when top reinf spawned
		wake(e2m1_vo_lotsabaddies);
		thread(f_music_e2m1_lotsabaddies_vo());
		// Miller : Prometheans!  Multiple targets!  All directions!
		// Palmer : Stay focused, Crimson.  Take them down.
	elseif(vo == 12)then								// on blips
		wake(e2m1_vo_fewtogo);
		thread(f_music_e2m1_fewtogo_vo());
		// Miller : You're almost there!  Hell, yeah!
		// Palmer : Miller.  A bit of decorum, yeah?
	elseif(vo == 13)then								// all prom dead
		wake(e2m1_vo_alldead);
		thread(f_music_e2m1_alldead_vo());
		// Miller : That's the last of them, Commander.
	elseif(vo == 14)then								// immediately following previous
		wake(e2m1_vo_ridehome);
		thread(f_music_e2m1_ridehome_vo());
		// Palmer : Dalton, a ride home for Crimson, please.
		// Dalton : You got it, Commander.
	elseif(vo == 15)then								// immediately following previous
		// Miller : Commander Palmer, distress call coming in.  It's the science team investigating where Crimson recovered that Forerunner artifact.
		// Palmer : Distress?
		// Miller : Heavy Covenant forces bearing on their position.  They've taken refuge, but they need extraction.
		
		// PLAY PIP
		wake(e2m1_vo_outro);
		thread(f_music_e2m1_outro_vo());
		// Palmer : Tell them help's on the way, Miller.
		// Palmer : Dalton, change of plans.  Crimson's going to rescue some eggheads.
	
	else
		b_e2m1_conch = false;
	end
end

script static void e2m1_trigcheck_turret_vo 
	sleep_until (volume_test_players (trigger_turret_vo), 1);
	sleep(30);
	e2m1_vo(3);
			// Miller : Whoa!  Mounted turrets.
			// Palmer : Take it slow, Crimson.  No need to rush.
end

script static void e2m1_cleanup_vo_2 
	sleep_until (LevelEventStatus("e2m1_cleared1"), 1);
	sleep(30);
	prepare_to_switch_to_zone_set (e2_m1_b);
	print("-----------------------------------------------starting zone switch");
	//CHANGING THE ZONE SET TO SUPPORT FORERUNNERS!!!
	e2m1_vo(7);
		// Miller : Area's clear, Commander.
end

//script static void e2m1_switch_hit 
//	sleep(35);
//	if(b_e2m1_stop_firing == false)then
//		thread(e2m1_vo(9));																		
//				// Miller : One pylon offline.
//	elseif (b_e2m1_stop_firing == true) then
//		thread(e2m1_activate_portal());
//		sleep(30 * 2);
//		thread(e2m1_vo(10));
//				// Miller : That's both pylons, Comman--Whoa.  A slipspace signature just blipped near Crimson.
//				// Palmer : Point the way, Miller.  Let's have a look.
//		sleep(10);
//		thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
//	end
//end

script static void e2m1_switch_hit 
	sleep(35);
	if(b_e2m1_stop_firing == false)then
		print("first_switch_subroutine----------------------------****");
		thread(e2m1_vo(9));																		
				// Miller : One pylon offline.
	elseif (b_e2m1_stop_firing == true) then
			print("second_switch_subroutine called----------------------------****");
		thread(e2m1_both_switches_flipped() );
	end
end

script static void e2m1_both_switches_flipped
	if(b_e2m1_switches_flipped == false)then
		print("second switch subroutine executed----------------------------****");
		b_e2m1_switches_flipped = true;
		thread(e2m1_activate_portal());
		sleep(30 * 2);
		thread(e2m1_vo(10));
					// Miller : That's both pylons, Comman--Whoa.  A slipspace signature just blipped near Crimson.
					// Palmer : Point the way, Miller.  Let's have a look.
		sleep(10);
		thread(camera_shake_all_coop_players (.4, .4, 3, 1.8));
	else
		print("second switch extra ignored----------------------------****");
	end
end

script static void e2m1_activate_portal
	effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_blackhole);
  sleep(30);
  effect_new (levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_blackhole);
	sleep(30 * 2);
	thread(e2m1_deactivate_portal());
end

script static void e2m1_deactivate_portal
	sleep_until (volume_test_players (trigger_top_tier), 1);
//	object_destroy(e2m1_portal_fx);
	sleep(30);
  effect_new (levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect, fl_blackhole);
  sleep(20);
  effect_kill_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_blackhole);
  effect_delete_from_flag(levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect, fl_blackhole);
end

script static void e2m1_fr_megawave 
	sleep_until (LevelEventStatus("e2m1_fr_mega"), 1);
	sleep(30 * 6);
	thread(e2m1_vo(11));
				// Miller : Prometheans!  Multiple targets!  All directions!
				// Palmer : Stay focused, Crimson.  Take them down.
	sleep(30 * 5);
	if(ai_living_count(e2m1_knight_wave) > 1)then
		thread(f_new_objective(e2m1_objective_05)); 
								// "Eliminate the Prometheans"
	end
	thread(f_music_e2m1_survive_the_promethian_retaliation_objective());
end

script static void e2m1_wind_down 
	sleep_until (LevelEventStatus("e2m1_clear3"), 1);
	thread(e2m1_vo(12));
			// Miller : You're almost there!  Hell, yeah!
			// Palmer : Miller.  A bit of decorum, yeah?
	sleep(30 * 3);
	thread(f_new_objective(e2m1_objective_02)); 
								// "Clear All Remaining Hostiles"
	thread(f_music_e2m1_clear_all_remaining_hostiles_objective_2());
end
	
script static void e2m1_all_clear
	sleep_until (LevelEventStatus("e2m1_end"), 1);
	sleep(30);
	e2m1_vo(13);
			// Miller : That's the last of them, Commander.
end

//==callbacks
script static void e2m1_vo_callback
	sleep(30);
	b_e2m1_conch = false;
end

script static void e2m1_vo_callback_intro
	sleep_until (b_players_are_alive(), 1);
	sleep(30);
	f_new_objective(e2m1_objective_01); // "Eliminate the Covenant Presence"
	thread(f_music_e2m1_eliminate_the_covenant_presence_objective());
	sleep(30);
	b_e2m1_conch = false;
end
script static void e2m1_vo_callback_turrets
	sleep(30);
	b_e2m1_conch = false;
	sleep(30 * 10);
	e2m1_vo(4);
			// Miller : Commander, there's a few Watchers in the air.
			// Palmer : So not just Covenant, but Prometheans too.  Noted.
end

script static void e2m1_vo_callback_areaclear
	sleep(5);
	b_e2m1_conch = false;
	e2m1_vo(8); // (targetpylons)
			// Palmer : Let's get those AA guns offline.
			// Miller : Marking the power conduit pylons now.  There you go, Crimson.
end

script static void e2m1_vo_targetpylons_mid_vo_advance_objective
	sleep(30 * 2);
	b_end_player_goal = TRUE;																											// advance objectives
end

script static void e2m1_vo_callback_targetpylons
	f_new_objective(e2m1_objective_03); 	
				// "Deactivate the Pylons"
	thread(f_music_e2m1_deactivate_the_pylons_objective());
	sleep(30);
	thread(e2m1_forerunner_west_squad());
	thread(e2m1_forerunner_east_squad());
	b_e2m1_conch = false;
	sleep(30 * 15);
	if(b_e2m1_stop_firing == false)then																						// if guns haven't been knocked offline
		e2m1_vo(5);
				// Dalton : Commander Palmer, how long until those guns are offline?  I can't get a bird within ten klicks of that location.
				// Palmer : Settle down, Dalton, we're working on it.
	end
end



script static void e2m1_vo_callback_bothpylonsdown
	print ("vo10 callback");
	sleep(30);
	b_e2m1_conch = false;
	b_end_player_goal = TRUE;																											// advance objectives from time passed to loc arrival
	thread(f_new_objective(e2m1_objective_04)); 
				// "Invesitgate the Slipspace Disruption"
	print ("f_new_objective threaded");
	thread(f_music_e2m1_investigate_the_slipspace_disruption());
end

script static void e2m1_vo_callback_alldead
	sleep(20);
	b_e2m1_conch = false;
	e2m1_vo(14);
			// Palmer : Dalton, a ride home for Crimson, please.
			// Dalton : You got it, Commander.
	sleep(30 * 6);
	ai_place(e2m1_pelican);
	sleep(30);
	thread(f_blip_object_cui (e2m1_pelican, "navpoint_goto"));
	f_new_objective(cath_objective_c);	
					 // "Evac"
end
	
script static void e2m1_vo_callback_ridehome
	sleep(30);
	b_e2m1_conch = false;
	e2m1_vo(15);
			// Miller : Commander Palmer, distress call coming in.  It's the science team investigating where Crimson recovered that Forerunner artifact.
			// Palmer : Distress?
			// Miller : Heavy Covenant forces bearing on their position.  They've taken refuge, but they need extraction.
			// Palmer : Tell them help's on the way, Miller.
			// Palmer : Dalton, change of plans.  Crimson's going to rescue some eggheads.
end

script static void e2m1_vo_callback_outro
	b_e2m1_conch = false;
	print("* * * * * * * * * * * * * * * * * * all_done_outro called");
	b_e2m1_vo_all_done = true;
	thread(e2m1_end_scenario());
end

//== Stage 1
//						                                                                            
//						 ad88888ba  888888888888    db         ,ad8888ba,   88888888888         88  
//						d8"     "8b      88        d88b       d8"'    `"8b  88                ,d88  
//						Y8,              88       d8'`8b     d8'            88              888888  
//						`Y8aaaaa,        88      d8'  `8b    88             88aaaaa             88  
//						  `"""""8b,      88     d8YaaaaY8b   88      88888  88"""""             88  
//						        `8b      88    d8""""""""8b  Y8,        88  88                  88  
//						Y8a     a8P      88   d8'        `8b  Y8a.    .a88  88                  88  
//						 "Y88888P"       88  d8'          `8b  `"Y88888P"   88888888888         88  
//						                                                                            
//						



script continuous e2m1_backer_upper
	sleep_until (ai_living_count (e2m1_bishop_2) == 1);											// TEMP HACK: WON'T WORK IF BISHOP GETS KILLED
	sleep_until (ai_living_count (e2m1_all_foes) < s_e2m1_bkp_threshhold);		
	thread(f_music_e2m1_backer_upper());
//	print(" ");
//	print("| /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\ /\");
//	print("|                                 BACKUP SPAWNING");
	
	// determine backup goal position
	if(s_e2m1_shade_sub == TRUE) then																				// cannoneer time? 
//		print("| cannoneer requested");
		print(" ");
	elseif(s_e2m1_bkp_goal_position == 2) then
		s_e2m1_bkp_goal_position = 0;
	else
		s_e2m1_bkp_goal_position = s_e2m1_bkp_goal_position + 1;
		if((s_e2m1_bkp_goal_position == 2) and (s_e2m1_init == FALSE)) then		//after the first 6 backup spawn, lower threshhold
			s_e2m1_bkp_threshhold = 10;																					// new threshhold
			s_e2m1_init = TRUE;
		end
	end

	
	// determine backup spawn point
	if(	(s_e2m1_shade_sub == TRUE) and
			(s_e2m1_forward_progress < 2)
		)	then																																// cannoneer time? if so, spawn cannoneer instead of ground force
//		print("| spawning cannoneer");
		
		if(s_e2m1_shade1_done == 1)then
//			print("| spawning cannoneer --A--");
			e2m1_respawn_cannoneer_a();
			s_e2m1_shade1_done = 2; 																						// increment so no more A replacements spawn
		elseif(s_e2m1_shade2_done == 1)then
//			print("| spawning cannoneer --B--");
			e2m1_respawn_cannoneer_b();
			s_e2m1_shade2_done = 2;																							// increment so no more B replacements spawn
		else
//			print("| something's wrong with cannoneer backup spawning");
			print(" ");
		end
		
	elseif(s_e2m1_forward_progress == 0) then
//		print("| spawning from position 1");
		e2m1_spawn_position_1_backup();
	elseif(s_e2m1_forward_progress == 1) then
//		print("| spawning from position 2");
		e2m1_spawn_position_2_backup();
//	elseif(s_e2m1_forward_progress == 2) then															// mothballing... stopping spawning bkp sooner sooo...
//		print("| spawning from position 3");
//		e2m1_spawn_position_3_backup();
	else
//		print("|nevermind, s_e2m1_forward_progress > 1, not spawning");
//		print("| BACKUP SPAWNING CLOSED");
//		print("| \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/");
//		print(" ");
		sleep_forever();
	end
//	print("| \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/ \/");
//	print(" ");
end

script continuous e2m1_cannoneer_a_ondeath 
	sleep_until (ai_living_count (e2m1_bishop_2) == 1);							// TEMP HACK: WON'T WORK IF BISHOP GETS KILLED
	sleep_until(	(ai_living_count(e2m1_stg1_cannoneer_a) == 0) and	// driver dead
								(s_e2m1_shade1_done == 0) and											// shade 1 reinforcement cycle incomplete
								(s_e2m1_shade_sub == false)												// reinf func checks if this is true (if==1, spawn cannoneer instead of ground forces)
							);
//	print(" ");
//	print(".......................................................................");
//	print("...                         Cannoneer A onDeath Called");

//	print(" ");
//	if(game_difficulty_get_real() == "legendary") then
//		print("... 														sleeping for 26 secs");
//		print(".......................................................................");
//		sleep(30 * 26);
//	else
//		print("... 														sleeping for 16 secs");
//		print(".......................................................................");
		sleep(30 * 16);																									// wait a beat, give players a gap to advance freely

//	end
	thread(f_music_e2m1_cannoneer_a_ondeath());
	s_e2m1_shade1_done = 1;
	s_e2m1_shade_sub = true;																				// the backerupper function checks to see if this is true (if==1, spawn cannoneer)
//	print(" ");
//	print(".......................................................................");
//	print("... 16 secs passed, Flipping Cannoneer bit");	
//	print("...       and incrementing Cannoneer A var");
//	print(".......................................................................");
//	print(" ");
	sleep_forever();
end
	
script continuous e2m1_cannoneer_b_ondeath 
	sleep_until (ai_living_count (e2m1_bishop_2) == 1);							// TEMP HACK: WON'T WORK IF BISHOP GETS KILLED
	sleep_until(	(ai_living_count(e2m1_stg1_cannoneer_b) == 0) and
								(s_e2m1_shade2_done == 0) and
								(s_e2m1_shade_sub == false)
							);
//	print(" ");
//	print(".......................................................................");
//	print("...                         Cannoneer B onDeath Called");
//	print("... 														sleeping for 16 secs");
//	print(".......................................................................");
//	print(" ");
	sleep(30 * 16);																									// wait a beat, give players a gap to advance freely
	thread(f_music_e2m1_cannoneer_b_ondeath());
	s_e2m1_shade2_done = 1;
	s_e2m1_shade_sub = true;																				// the backerupper function checks to see if this is true (if==1, spawn cannoneer)
//	print(" ");
//	print(".......................................................................");
//	print("... 16 secs passed, Flipping Cannoneer bit");	
//	print("...       and incrementing Cannoneer B var");
//	print(".......................................................................");
//	print(" ");
	sleep_forever();
end


//	s_e2m1_shade_counter = s_e2m1_shade_counter + 1;									// increment cannoneer index
//	print("... s_e2m1_shade_counter ==");
//	inspect(s_e2m1_shade_counter);
//	if ((s_e2m1_shade_counter > 2) or (s_e2m1_stg2_init == TRUE))then	// conditions to end cannoneer spawning
//		print("...                             end condition met");
//		print("...                   shutting down cannoneer ondeath func");
//		print(".......................................................................");
//		print(" ");
//		sleep_forever();
//	else
//		print("... sleeping for 16 secs");
//		print(".......................................................................");
//		print(" ");
//		sleep(30 * 16);																									// wait a beat, give players a gap to advance freely
//		print(" ");
//		print(".......................................................................");
//		print("... 16 secs passed, Flipping Cannoneer bit");
//		s_e2m1_shade_sub = TRUE;																				// the backerupper function checks to see if this is true (if==1, spawn cannoneer)
//	end
//	
//	print(".......................................................................");
//	print(" ");
//end

// == get in shade turrets, for initial spawns and backups == 
// not happy that I have to do this with so many ifs & functions, 
// but none of the means of detecting if a vehicle was occupied
// such as "vehicle_test_seat" "vehicle_gunner" "unit_in_vehicle", etc would work.
// Nor would functions such as "unit_board_vehicle" accept "ai_current_actor". Perhaps its beause I'm using old shade.
// Anyhow, have to do this all longhand and ugly

script static void e2m1_respawn_cannoneer_a
//	print("|   ....................................................");
//	print("|   ... cannoneer A backup func called.....");
	ai_place(e2m1_stg1_cnnr_bkp_1);
	s_e2m1_shade_sub = false;														// backup function checks to see if this is true (if==1, spawn cannoneer)
//	print("|   ... A backup placed, bit reset to false");
//	print("|   ....................................................");
end

script static void e2m1_respawn_cannoneer_b
//	print("|   ....................................................");
//	print("|   ... cannoneer B backup func called.....");
	ai_place(e2m1_stg1_cnnr_bkp_2);
	s_e2m1_shade_sub = false;														// backup function checks to see if this is true (if==1, spawn cannoneer)
//	print("|   ... B backup placed, bit reset to false");
//	print("|   ....................................................");
end

//== cannoneer backup funcs
script command_script e2m1_man_first_shade
		//	e2m1_shade_1 position/rotation:
		//	1.656546, -9.200142, -2.490475
		//	-87.418304, -0.000000, -0.000000
		sleep(3);
//		print("");
//		print("[]=========================================================[]");
//		print("[]           placing cannoneer in first shade");
		cs_go_to_vehicle(e2m1_shade_1);
//		print("[]=========================================================[]");
//		print("");
end

script command_script e2m1_man_second_shade
		//	e2m1_shade_2 position/rotation:
		//	-2.588369, -9.192392, -2.488140
		//	-99.412186, -0.000000, -0.000000
		sleep(6);
//		print("");
//		print("[]=========================================================[]");
//		print("[]           placing cannoneer in second shade");
		cs_go_to_vehicle(e2m1_shade_2);
//		print("[]=========================================================[]");
//		print("");
end

//== ground force backup funcs
script static void e2m1_spawn_position_1_backup
	s_e2m1_backup_count = s_e2m1_backup_count + 1;
	if(s_e2m1_backup_count > 7)then
		print("respawn capped, no reinforcements");
	elseif(s_e2m1_bkp_goal_position == 0) then
		ai_place(e2m1_bkp1_pos1_w);
//		print("| position 1, west lane");
	elseif(s_e2m1_bkp_goal_position == 1) then
		ai_place(e2m1_bkp1_pos1_m);
//		print("| position 1, mid lane");
	elseif(s_e2m1_bkp_goal_position == 2) then
		ai_place(e2m1_bkp1_pos1_e);
//		print("| position 1, east lane");
	end
end

script static void e2m1_spawn_position_2_backup
	s_e2m1_backup_count = s_e2m1_backup_count + 1;
	if(s_e2m1_backup_count > 7)then
		print("respawn capped, no reinforcements");
	elseif(s_e2m1_bkp_goal_position == 0) then
		ai_place(e2m1_bkp1_pos2_w);		
//		print("| position 2, west lane");
	elseif(s_e2m1_bkp_goal_position == 1) then
		ai_place(e2m1_bkp1_pos2_m);
//		print("| position 2, mid lane");
	elseif(s_e2m1_bkp_goal_position == 2) then
		ai_place(e2m1_bkp1_pos2_e);
//		print("| position 2, east lane");
	end
end

script static void e2m1_spawn_position_3_backup
	s_e2m1_backup_count = s_e2m1_backup_count + 1;
	if(s_e2m1_backup_count > 7)then
		print("respawn capped, no reinforcements");
	elseif(s_e2m1_bkp_goal_position == 0) then
		ai_place(e2m1_bkp1_pos3_w);		
//		print("| position 2, west lane");
	elseif(s_e2m1_bkp_goal_position == 1) then
		ai_place(e2m1_bkp1_pos3_m);
//		print("| position 3, mid lane");
	elseif(s_e2m1_bkp_goal_position == 2) then
		ai_place(e2m1_bkp1_pos3_e);
//		print("| position 3, east lane");
	end

end

script static void e2m1_forward_progress_tracker_1 
	sleep_until (volume_test_players (trigger_volume_1), 1);
		thread(f_music_e2m1_forward_progress_tracker_1());
		s_e2m1_forward_progress = 1;
		s_e2m1_backup_count = 0;																					// reset respawn counter
		thread(e2m1_forward_progress_tracker_2());
		thread(e2m1_spawn_stage2_e());
		thread(e2m1_spawn_stage2_w());
		thread(e2m1_installation_reached());
		thread(e2m1_forerunner_start());
//		print(" ");
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < TRIGGER 1 HIT <><<><><><><><><<><><>>");
//		print("s_e2m1_forward_progress ==");
//		inspect (s_e2m1_forward_progress);
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < <>< <>< ><><> <><><< ><><>><>><><><><>");
//		print(" ");
	sleep_forever();
end

script static void e2m1_forward_progress_tracker_2 
	sleep_until (volume_test_players (trigger_volume_2), 1);
		thread(f_music_e2m1_forward_progress_tracker_2());
		s_e2m1_forward_progress = 2	;
		
	ai_braindead(e2m1_bishops_init, false);
	ai_set_deaf(e2m1_bishops_init, false);
	ai_set_blind(e2m1_bishops_init, false);
//		print(" ");
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < TRIGGER 2 HIT <><<><><><><><><<><><>>");
//		print("s_e2m1_forward_progress ==");
//		inspect (s_e2m1_forward_progress);
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < <>< <>< ><><> <><><< ><><>><>><><><><>");
//		print(" ");
	sleep_forever();
end
	
//script continuous e2m1_forward_progress_tracker_3							//mothballing for now
//	sleep_until (volume_test_players (trigger_volume_3), 1);	
//		s_e2m1_forward_progress = 3	;
//		print(" ");
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < TRIGGER 3 HIT <><<><><><><><><<><><>>");
//		print("s_e2m1_forward_progress ==");
//		inspect (s_e2m1_forward_progress);
//		print(" <> <> <> <> <> > <> <> <> <> <> < >< >< >< >< >< > < <>< <>< ><><> <><><< ><><>><>><><><><>");
//		print(" ");
//	sleep_forever();
//end

//== Stage 2
//					
//					 .d8888b. 88888888888     d8888  .d8888b.  8888888888       .d8888b.  
//					d88P  Y88b    888        d88888 d88P  Y88b 888             d88P  Y88b 
//					Y88b.         888       d88P888 888    888 888                    888 
//					 "Y888b.      888      d88P 888 888        8888888              .d88P 
//					    "Y88b.    888     d88P  888 888  88888 888              .od888P"  
//					      "888    888    d88P   888 888    888 888             d88P"      
//					Y88b  d88P    888   d8888888888 Y88b  d88P 888             888"       
//					 "Y8888P"     888  d88P     888  "Y8888P88 8888888888      888888888  
//					                                                                      

script static void e2m1_spawn_stage2_e 
	sleep_until (volume_test_players (trigger_volume_stage2e), 1);	
	thread(f_music_e2m1_spawn_stage2_e());
//	print(" ");
//	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//	print("!");
//	print("!                      SPAWNING STAGE 2 EAST");
//	print("!");
	if(s_e2m1_installation_reached == true) then
//		print("!                 forerunner installation already reached, ");
//		print("!                       no further stage 2 spawning ");
//		print("!");
//		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//		print(" ");
//		print(" ");
		sleep_forever();
	end
// ============== strong side
	if (s_e2m1_stg2_init == false) then																	//has stage 2 started yet? If not, this becomes strong side
//		print("!  s_e2m1_stg2_init = FALSE, east side becomes strong side");
		f_create_new_spawn_folder (94); 
//		thread(e2m1_stage1_swarm());																		//REPLACED: added new tasks to aio instead
		s_e2m1_stg2_init = true;
		s_e2m1_bkp_threshhold = 7;
		if(ai_living_count (e2m1_all_foes) < 18) then
			ai_place(e2m1_stg2e_cannoneer);
			ai_place(e2m1_stg2e_f_ranger);
			ai_place(e2m1_stg2e_b_ranger);
//		print("!  spawning strong side base compliment of 3");
			if (ai_living_count (e2m1_all_foes) < 18) then
				ai_place(e2m1_stg2e_mtier_jackal1);
				ai_place(e2m1_stg2e_fodder_a);
				if (ai_living_count (e2m1_all_foes) < 18) then
					ai_place(e2m1_stg2e_mtier_jackal2);
					ai_place(e2m1_stg2e_fodder_b);
					if (ai_living_count (e2m1_all_foes) < 20) then
							ai_place(e2m1_stg2e_ttier_jackal);
	
					end
				end
			end
		end
	// =================== weak side
	else
//		print("!  s_e2m1_stg2_init = TRUE, east side becomes WEAK side                         !");
		if (ai_living_count (e2m1_all_foes) < 19) then		
			ai_place(e2m1_stg2e_cannoneer);
			ai_place(e2m1_stg2e_b_ranger);
			if (ai_living_count (e2m1_all_foes) < 19) then
				ai_place(e2m1_stg2e_mtier_jackal1);
				if (ai_living_count (e2m1_all_foes) < 18) then
					ai_place(e2m1_stg2e_mtier_jackal2);
					ai_place(e2m1_stg2e_fodder_a);
					if (ai_living_count (e2m1_all_foes) < 19) then
						ai_place(e2m1_stg2e_fodder_a);
					end
				end
			end
		end
	end
//	print("DERBERG: passed weak side logic");
//	print("!");
//	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//	print(" ");
	sleep_forever();
end

script static void e2m1_spawn_stage2_w 
	sleep_until (volume_test_players (trigger_volume_stage2w), 1);	
	thread(f_music_e2m1_spawn_stage2_w());
//	print(" ");
//	print(" ");
//	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//	print("!");
//	print("!                      SPAWNING STAGE 2 WEST");
//	print("!");
	if(s_e2m1_installation_reached == true) then
//		print("!                 forerunner installation already reached, ");
//		print("!                       no further stage 2 spawning ");
//		print("!");
//		print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//		print(" ");
//	print(" ");
		sleep_forever();
	end
	// ================= strong side
	if (s_e2m1_stg2_init == false) then		//has stage 2 started yet? If not, this becomes strong side
//		print("!  s_e2m1_stg2_init = FALSE, WEST side becomes strong side");
		f_create_new_spawn_folder (93); 
		s_e2m1_stg2_init = true;
		s_e2m1_bkp_threshhold = 7;
		if (ai_living_count (e2m1_all_foes) < 18) then
			ai_place(e2m1_stg2w_cannoneer);
			ai_place(e2m1_stg2w_f_ranger);
			ai_place(e2m1_stg2w_b_ranger);
			if (ai_living_count (e2m1_all_foes) < 18) then
				ai_place(e2m1_stg2w_mtier_jackal1);
				ai_place(e2m1_stg2w_fodder_a);
				if (ai_living_count (e2m1_all_foes) < 18) then
					ai_place(e2m1_stg2w_mtier_jackal2);
					ai_place(e2m1_stg2w_fodder_b);
					if (ai_living_count (e2m1_all_foes) < 20) then
						ai_place(e2m1_stg2w_ttier_jackal);
					end
				end
			end
		end
	// ================= weak side
	else
//		print("!  s_e2m1_stg2_init = TRUE, west side becomes WEAK side                         !");
		if (ai_living_count (e2m1_all_foes) < 19) then
			ai_place(e2m1_stg2w_cannoneer);
			ai_place(e2m1_stg2w_b_ranger);
			if (ai_living_count (e2m1_all_foes) < 19) then
				ai_place(e2m1_stg2w_mtier_jackal1);
				if (ai_living_count (e2m1_all_foes) < 18) then
					ai_place(e2m1_stg2w_mtier_jackal2);
					ai_place(e2m1_stg2w_fodder_a);
					if (ai_living_count (e2m1_all_foes) < 19) then
						ai_place(e2m1_stg2w_fodder_a);
					end
				end
			end
		end
	end
//	print("!");
//	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//	print(" ");
	sleep_forever();
end
//== Stage 3
//							 _______________________ _______ _______    ______  
//							(  ____ \__   __/  ___  )  ____ \  ____ \  / ___  \ 
//							| (    \/  ) (  | (   ) | (    \/ (    \/  \/   \  \
//							| (_____   | |  | (___) | |     | (__         ___) /
//							(_____  )  | |  |  ___  | | ____|  __)       (___ ( 
//							      ) |  | |  | (   ) | | \_  ) (              ) \
//							/\____) |  | |  | )   ( | (___) | (____/\  /\___/  /
//							\_______)  )_(  |/     \|_______)_______/  \______/ 
//							                                                    

script static void e2m1_installation_reached 
	sleep_until (volume_test_players (trigger_volume_stage3), 1);
	thread(f_music_e2m1_installation_reached());
//	print(" ");
//	print("**************************************************************************************");
//	print("**                      INSTALLATION REACHED");
//	print("**");
	s_e2m1_installation_reached = true;																	// prevents certain spawn events
	f_create_new_spawn_folder (92);
//	thread(e2m1_stage2_swarm());																			//REPLACED gave stage2 mobs new tasks in aio instead
//	thread(e2m1_stage1_swarm());																			//REPLACED gave stage1 mobs new tasks in aio instead
//	print("** - waking bishops and turret");
	ai_braindead(e2m1_stg1_turret, false);
	ai_braindead(e2m1_bishops_init, false);
	ai_set_deaf(e2m1_bishops_init, false);
	ai_set_blind(e2m1_bishops_init, false);
//	print("** - spawning general");
	if (ai_living_count (e2m1_all_foes) < 20) then
		ai_place(e2m1_stg3_general);
		if (ai_living_count (e2m1_all_foes) < 20) then
	//		print("** -- count < 20");	
	//		print("** -- spawning second elite");
			ai_place(e2m1_stg3_elite_1);
			if (ai_living_count (e2m1_all_foes) < 20) then
	//		print("** ---- count < 20");	
	//		print("** ---- spawning west room grunt");
			ai_place(e2m1_stg3_room_grunt1);
				if (ai_living_count (e2m1_all_foes) < 20) then
	//			print("** ------ count < 20");	
	//			print("** ------ spawning east room grunt");
				ai_place(e2m1_stg3_room_grunt2);
					if (ai_living_count (e2m1_all_foes) < 20) then
	//				print("** -------- count < 20");	
	//				print("** -------- spawning top tier rear grunt");
					ai_place(e2m1_stg3_elite_2);
						if (ai_living_count (e2m1_all_foes) < 20) then
	//					print("** ---------- count < 20");	
	//					print("** ---------- spawning top tier jackal");
						ai_place(e2m1_stg3_room_jack);
							if (ai_living_count (e2m1_all_foes) < 20) then
	//						print("** ------------ count < 20");	
	//						print("** ------------ spawning room jackal");
							ai_place(e2m1_stg3_top_jack);
								if (ai_living_count (e2m1_all_foes) < 20) then
	//							print("** -------------- count < 20");	
	//							print("** -------------- spawning top tier front grunt");
								ai_place(e2m1_stg3_top_grunt1);
									if (ai_living_count (e2m1_all_foes) < 20) then
	//								print("** ---------------- count < 20");	
	//								print("** ---------------- spawning top tier front grunt #2");
									ai_place(e2m1_stg3_top_grunt2);
									end
								end
							end
						end
					end
				end
			end
		end
	end
	thread(general_death_check());
	thread(set_spawn_folder_installation_west());
	thread(set_spawn_folder_installation_east());
	thread(set_spawn_folder_west_approach());
	thread(set_spawn_folder_east_approach());
//		print("**  ");
//		print("**  total foes:");
//		inspect(ai_living_count (e2m1_all_foes));
	
//	print("**************************************************************************************");
//	print(" ");
	sleep_forever();
end 

script static void e2m1_stage1_swarm
//		print("DERBERG: e2m1_stage1_swarm");
		sleep(30 * 7);
		thread(f_music_e2m1_stage1_swarm());
		ai_set_objective(e2m1_stage1,"aio_seek_player");									// set stage 1 guys to seek player
//		print("!  Stage 1 foes switched to seek player objective");
end

script static void e2m1_stage2_swarm
		sleep(30 * 7);
		ai_set_objective(e2m1_stage2,"aio_seek_player");									// set stage 1 guys to seek player
		thread(f_music_e2m1_stage2_swarm());
//		print("!  Stage 2 foes switched to seek player objective");
end

script static void e2m1_stage3_bishop_backup 
	sleep_until (volume_test_players (trigger_volume_stage3), 1);
	sleep (30 * 1);
	sleep_until (ai_living_count (e2m1_all_foes) < 15);

	thread(f_music_e2m1_stage3_bishop_backup());
	ai_place(e2m1_bishop_3);
	ai_place(e2m1_bishop_4);
end
// ========================== pawns

script static void general_death_check
	sleep_until	(ai_living_count (e2m1_stg3_general) == 0) or
							(ai_living_count (e2m1_all_foes) < 6);
	sleep (30*1);
	thread(e2m1_bishop_butterflies());
end

script static void e2m1_bishop_butterflies
	sleep_until(ai_living_count(e2m1_all_foes) < 10);
		
		ai_place(e2m1_bish_west_orbit);
		ai_place(e2m1_bish_west_rampring);
		ai_place(e2m1_bish_west_pylon);
		ai_place(e2m1_bish_west_walkway);
		
		sleep(30 * 2.5);
		thread(vo_glo_watchers_03());
					// MILLER : Watchers!
		sleep(30 * 1.5);
		thread(vo_glo_watchout_01()	);
					// PALMER : Heads up!
	sleep_until(ai_living_count(e2m1_stg3_bishop_wave) < 3);					

		ai_place(e2m1_bish_east_orbit);
		ai_place(e2m1_bish_east_rampring);
		ai_place(e2m1_bish_east_pylon);
		ai_place(e2m1_bish_east_walkway);

	thread(e2m1_end_of_stage_3());																			//enable end of stage 3
	sleep_until(ai_living_count(e2m1_stg3_bishop_wave) < 4);
	ai_set_objective(e2m1_stg3_bishop_wave, "bish_aio_installation_midtier");	
end

script static void e2m1_end_of_stage_3
	sleep_until(ai_living_count(e2m1_all_foes) < 6);
	sleep(20);
	thread(e2m1_vo(6));
						// Miller : Almost done.  Just a few to go.
	sleep(30 * 1);
	b_end_player_goal = true;																						//advance objectives - advance first objective to second.
	sleep(30 * 1);
	f_new_objective(e2m1_objective_02);	
					 // "Clear All Remaining Hostiles"
	
	//music folks- I consolidated some functions and changed some things and ended up with these two together: (sorry)
	thread(f_music_e2m1_clear_all_remaining_hostiles_objective());		
	thread(f_music_e2m1_clear1());
end

//==player spawn points
script static void set_spawn_folder_west_approach
	sleep_until (volume_test_players (trigger_volume_stage2w), 1);
	f_create_new_spawn_folder (93);
end

script static void set_spawn_folder_east_approach
	sleep_until (volume_test_players (trigger_volume_stage2e), 1);
	f_create_new_spawn_folder (94);
end

script static void set_spawn_folder_installation_west 
	sleep_until (volume_test_players (trigger_volume_fr_west), 1);
	f_create_new_spawn_folder (96);
end

script static void set_spawn_folder_installation_east
	sleep_until (volume_test_players (trigger_volume_fr_east), 1);
	f_create_new_spawn_folder (95);
end
//== Forerunners
//		 _______   ______   .______       _______ .______       __    __  .__   __. .__   __.  _______ .______           _______.
//		|   ____| /  __  \  |   _  \     |   ____||   _  \     |  |  |  | |  \ |  | |  \ |  | |   ____||   _  \         /       |
//		|  |__   |  |  |  | |  |_)  |    |  |__   |  |_)  |    |  |  |  | |   \|  | |   \|  | |  |__   |  |_)  |       |   (----`
//		|   __|  |  |  |  | |      /     |   __|  |      /     |  |  |  | |  . `  | |  . `  | |   __|  |      /         \   \    
//		|  |     |  `--'  | |  |\  \----.|  |____ |  |\  \----.|  `--'  | |  |\   | |  |\   | |  |____ |  |\  \----..----)   |   
//		|__|      \______/  | _| `._____||_______|| _| `._____| \______/  |__| \__| |__| \__| |_______|| _| `._____||_______/    
//		                                                                                                                         

script static void e2m1_forerunner_start 
	sleep_until (LevelEventStatus("e2m1_switches_1"), 1);
	s_e2m1_pawn_count = 0;																								// reset respawn counter
	thread(f_music_e2m1_forerunner_start());
	sleep(10);

	thread(e2m1_forerunner_prep_final_encounter());
	thread(e2m1_power_console_1());
	thread(e2m1_power_console_2());
end

script static void e2m1_forerunner_west_squad
	sleep_until (volume_test_players (trigger_volume_fr_west), 1);
	thread(f_music_e2m1_forerunner_west_squad());
	ai_place(e2m1_fr_west_p_lo );
	sleep(30);
	ai_place(e2m1_fr_west_bishops);
	sleep(20);
	if(	game_difficulty_get() == legendary)then
		ai_place_with_shards(e2m1_west_back_turret);
	end
	sleep(30 * 3);
	ai_place(e2m1_fr_west_p_hi);
end


script static void e2m1_forerunner_east_squad
	sleep_until (volume_test_players (trigger_volume_fr_east), 1);
	thread(f_music_e2m1_forerunner_east_squad());
	ai_place(e2m1_fr_east_p_lo);
	sleep(30);
	ai_place(e2m1_fr_east_bishops);
	sleep(20);
	if(	game_difficulty_get() == legendary)then
		ai_place_with_shards(e2m1_east_back_turret);
	end
	sleep(30 * 3);
	ai_place(e2m1_fr_east_p_hi);
end

script static void e2m1_forerunner_prep_final_encounter
	sleep_until (LevelEventStatus("e2m1_fr_switches_hit"), 1);
	
	thread(f_music_e2m1_forerunner_prep_final_encounter());
	b_e2m1_stop_firing = true;
	sleep(15);
	thread(e2m1_forerunner_top_encounter());
	thread(e2m1_knights_presage());
end

script static void e2m1_forerunner_top_encounter
	sleep_until (LevelEventStatus("e2m1_fr_slipspace"), 1);
	thread(f_music_e2m1_forerunner_top_encounter());
	sleep(20);
	if(ai_living_count(e2m1_all_foes) <= 10)then
		ai_place(e2m1_fr_top_pawns);																					// 5 pawns
		ai_place(e2m1_fr_top_bishops);																				// 3 bishops
	elseif(ai_living_count(e2m1_all_foes) <= 15)then
		ai_place(e2m1_fr_top_bishops);																				// 3 bishops
	elseif(ai_living_count(e2m1_all_foes) <= 19)then
		ai_place(e2m1_top_bishop);																						// 1 bish
	else
		sleep_until(ai_living_count(e2m1_all_foes) <= 15);
		ai_place(e2m1_fr_top_bishops);																				// 3 bishops
	end
	sleep(20);
	ai_place_with_shards(e2m1_top_west_turret);															// 1 turret
	sleep(10);
	ai_place_with_shards(e2m1_top_east_turret);															// 1 turret
	sleep(30);
end

script static void e2m1_knights_presage
	sleep_until(LevelEventStatus("e2m1_resupply_obj"), 1);
	sleep_until (ai_living_count (e2m1_fr_top_all) < 7);

	thread(e2m1_knights_wave_pt1());																				// get ready for knight wave spawn

	sleep(20);
	vo_glo_heavyforces_03();
					// MILLER : Lots of activity nearby. Be ready for anything, Crimson.
	sleep(20);
	vo_glo_ordnance_05();
					// Palmer : Dalton, Crimson could use some resupply.
					// Dalton : Headed their way now, Commander.
	sleep(15);

	print ("--------------------------------------------sleeping until the zone is loaded");
	sleep_until (not PreparingToSwitchZoneSet(), 1); 
	sleep(5);
	print ("-----------------------------------------------------------switching zone set");
	switch_zone_set (e2_m1_b);
	sleep(5);
	current_zone_set_fully_active(); 

	sleep(25);
	
	ordnance_drop (fl_weapon_drop_4, "storm_rocket_launcher");
	sleep(20);
	
	ordnance_drop (fl_weapon_drop_3, "storm_rail_gun");
	sleep(30 * 1.5);
	
	ordnance_drop (fl_weapon_drop_1, "storm_rocket_launcher");
	sleep(15);
	
	ordnance_drop (fl_weapon_drop_2, "storm_lmg");
	sleep(20);
	
	// fail-safe for bug https://trochia:8443/browse/MN-94151
	if(not (current_zone_set_fully_active() == 6)) then												// 6 is the index of e2_m1_b
		print("****************************** bad zone set, attempting to switch *****************");
		print("****************************** bad zone set, attempting to switch *****************");
		print("****************************** bad zone set, attempting to switch *****************");
		print("****************************** bad zone set, attempting to switch *****************");
		print("****************************** bad zone set, attempting to switch *****************");
		print("****************************** bad zone set, attempting to switch *****************");
		switch_zone_set (e2_m1_b);
		sleep(30);	
	end
	
	// TEXT OBJECTIVE UPDATE
	thread(f_new_objective(e2m1_objective_05a)); 												
							// "Collect Ordnance"
	sleep(20);
	// LOCATION OBJECTIVE - move from 7- Time Passed to 8 - Loc Arrival
	b_end_player_goal = true;																								//advance objectives
																																					 
	effects_distortion_enabled = 0;
	
end

script static void e2m1_knights_wave_pt1
	sleep_until(LevelEventStatus("e2m1_knights_start"), 1);
	sleep(10);
	ai_place_in_limbo(e2m1_kni_knight_a);																		// 1 knights, all diff
	ai_place_in_limbo(e2m1_kni_knight_b);																		// 1 knights, all diff
	thread(f_e2m1_oh_man_knights());
	if (	game_difficulty_get() == legendary or game_difficulty_get() == heroic) then
		ai_place_with_birth (e2m1_kni_bish_s_orbit);													// 1 bishop, only on hero and legend
	end
	sleep_until(ai_living_count(e2m1_knight_knights) <= 1);
	ai_place_with_birth (e2m1_kni_bish_w_orbit);														// 1 bishop
	sleep(30 * 2);
	ai_place_in_limbo(e2m1_kni_knight_c);																		// 1 knights, only on hero and legend
	thread(f_e2m1_knights_wave_pawn_spawner());															// 2 pups
	sleep_until(ai_living_count(e2m1_knight_knights) <= 0);
	thread(e2m1_knights_wave_pt2());
end

script static void e2m1_knights_wave_pt2
	ai_place_in_limbo(e2m1_kni_knight2_a);																	// 1 knights, all diff
	ai_place_in_limbo(e2m1_kni_knight2_b);																	// 1 knights, all diff
	if(ai_living_count(e2m1_knight_bishops) <= 0)then
		ai_place_with_birth (e2m1_kni_bish_w_orbit);													// 1 bishop
		ai_place_with_birth (e2m1_kni_bish_e_orbit);													// 1 bishop
	end
	thread(f_e2m1_knights_wave_pawn_spawner());															// spawn 2 pups
	if (	game_difficulty_get() == legendary or game_difficulty_get() == heroic) then
		if(ai_living_count(e2m1_knight_bishops) <= 3)then											// nested because I can't crack the f'ing magic syntax code to get this to work in a compound statement
			ai_place_with_birth (e2m1_kni_bish_s_orbit);												// 1 bishop, only on hero and legend
		end
	end
	if(ai_living_count(e2m1_knight_pawns) <= 2)then
		thread(f_e2m1_knights_wave_pawn_spawner());														// spawn 2 pups
	end
	thread(e2m1_knights_wave_pt2_optional());
	sleep_until(ai_living_count(e2m1_knight_knights) < 3);
	sleep(30 * 3);
	ai_place_in_limbo(e2m1_kni_knight2_c);																	// 1 knights, only on hero and legend
	thread(f_e2m1_final_encounter());
end

script static void e2m1_knights_wave_pt2_optional
	sleep(30 * 3);
	NotifyLevel("e2m1_fr_mega");																						// more vo and objective info
	sleep(30 * 2);
	if(ai_living_count(e2m1_knight_bishops) <= 0)then
		ai_place_with_birth (e2m1_kni_bish_w_orbit);													// 1 bishop
		ai_place_with_birth (e2m1_kni_bish_e_orbit);													// 1 bishop
	end
	if(ai_living_count(e2m1_knight_pawns) <= 2)then
		thread(f_e2m1_knights_wave_pawn_spawner());														// spawn 2 pups
		sleep(30);
		thread(f_e2m1_knights_wave_pawn_spawner());														// spawn 2 pups
	end
	thread(f_e2m1_knights_wave_kicker_pawns());															// wait 15 seconds, check status, maybe respawn
end

script static void f_e2m1_oh_man_knights
	sleep(30 * 3);
	vo_glo_knights_02();
			// MILLER : Oh, man! Knights! 
end

script static void f_e2m1_final_encounter
	sleep_until(ai_living_count(e2m1_knight_knights) == 0);
	
	ordnance_show_nav_markers(false);
	b_e2m1_final_enc = true;																								// used in aios
	ai_place_in_limbo(e2m1_kni_knight_commander);
	sleep_until(ai_living_count(e2m1_all_foes) < 10);
	thread(f_music_e2m1_forerunner_final_swarm());										
	ai_place(e2m1_last_west_pawns);
	ai_place(e2m1_last_east_pawns);
	// turrets:
	ai_place(e2m1_last_bishops);
	sleep(30 * 2);
	ai_place_with_shards(e2m1_west_ramp_turret);														// 1 turret
	sleep(2);
	ai_place_with_shards(e2m1_east_ramp_turret);														// 1 turret
	sleep(3);
	b_end_player_goal = true;																								//advance objectives, from 8. time passed to 9. no more waves	
	sleep_until(ai_living_count(e2m1_last_bishops) <= 0);
	ai_place_with_birth(e2m1_bish_front);
end

script static void f_e2m1_knights_wave_kicker_pawns
	sleep(30 * 15);
	if(ai_living_count(e2m1_knight_pawns) <= 0 and ai_living_count(e2m1_knight_bishops) >= 1) then
			thread(f_e2m1_knights_wave_pawn_spawner());													// spawn 2 pups
			sleep(30 * 5);
			thread(f_e2m1_knights_wave_pawn_spawner());													// spawn 2 pups
	end
end

script static void f_e2m1_knights_wave_pawn_spawner												// cycles pawn spawn locations
	if(s_e2m1_pawn_count == 0)then
				ai_place_with_shards (e2m1_kni_shard_w, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	elseif(s_e2m1_pawn_count == 1)then
				ai_place_with_shards (e2m1_kni_shard_e, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	elseif(s_e2m1_pawn_count == 2)then
				ai_place_with_shards (e2m1_kni_shard_s, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	elseif(s_e2m1_pawn_count == 3)then
				ai_place_with_shards (e2m1_kni_shard_w, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	elseif(s_e2m1_pawn_count == 4)then
				ai_place_with_shards (e2m1_kni_shard_e, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	elseif(s_e2m1_pawn_count == 5)then
				ai_place_with_shards (e2m1_kni_shard_s, 2);												// 2 pawns
				s_e2m1_pawn_count = s_e2m1_pawn_count + 1;
	else
			print("no more dogs");
	end
end

script static void f_e2m1_knight_rushing_timer														// wait x seconds, then rush players one at a time (see aio)
	sleep_s(20);
	b_e2m1_knight_bit = true;
end

script command_script cs_e2m1_knight_phasein
	cs_phase_in();
end

//== cs and sundry scripts

script static void e2m1_power_console_1
	sleep_until ((device_get_position(dm_e2m1_e_control_panel) > 0), 1 );
	sleep(4);
	device_set_position(dm_e2m1_e_tower, 1);
	thread(e2m1_switch_hit());
	thread(f_music_e2m1_power_console_1());
	sleep(30 * 3);
	dm_e2m1_e_control_panel->SetDerezWhenActivated();
end

script static void e2m1_power_console_2
	sleep_until ((device_get_position(dm_e2m1_w_control_panel) > 0), 1 );
	sleep(4);
	device_set_position(dm_e2m1_w_tower, 1);
	thread(e2m1_switch_hit());
	thread(f_music_e2m1_power_console_2());
	sleep(30 * 3);
	dm_e2m1_w_control_panel->SetDerezWhenActivated();
end

script static void f_e2m1_interfaces
	//onLevelLoaded, set and hide interface
	sleep(10);
	object_hide(dm_e2m1_e_control_panel, true);
	object_hide(dm_e2m1_w_control_panel, true);
	print("-------------------------------------------------------- switches hidden");
	//later, animate on
	sleep_until (LevelEventStatus("e2m1_switches_1"), 1);
	object_hide(dm_e2m1_e_control_panel, false);
	object_hide(dm_e2m1_w_control_panel, false);
	sleep(2);
	device_set_power(dc_e2m1_w_switch, 1);
	device_set_power(dc_e2m1_e_switch, 1);
end

script static void f_e2m1_killvolume																			// kill wayward bishops
	sleep_until (LevelEventStatus("e2m1_killvolume"), 1);
		kill_volume_enable(kill_megazon_a);
		kill_volume_enable(kill_megazon_b);
		kill_volume_enable(kill_megazon_c);
		kill_volume_enable(kill_megazon_d);
		kill_volume_enable(kill_megazon_e);
		kill_volume_enable(kill_megazon_f);
	sleep_until (LevelEventStatus("e2m1_killvolume_off"), 1);
		kill_volume_disable(kill_megazon_a);
		kill_volume_disable(kill_megazon_b);
		kill_volume_disable(kill_megazon_c);
		kill_volume_disable(kill_megazon_d);
		kill_volume_disable(kill_megazon_e);
		kill_volume_disable(kill_megazon_f);
end

script command_script cs_forerunner_spawn_e2m1
	object_dissolve_from_marker(ai_get_unit(ai_current_actor), "resurrect", "phase_in");
end

script static void e2m1_silence_the_guns
	sleep_until ((b_e2m1_stop_firing == true ), 1);
	cs_run_command_script (e2m1_avt_driver_1, cs_power_down_turret_1);
	cs_run_command_script (e2m1_avt_driver_2, cs_power_down_turret_2);
	cs_run_command_script (e2m1_avt_driver_3, cs_power_down_turret_3);
	cs_run_command_script (e2m1_avt_driver_4, cs_power_down_turret_4);
	sleep_forever();
end

script command_script cs_power_down_turret_1
	sleep_s(1);
	cs_aim(true, e2m1_sleep_points.p1);
	object_set_custom_animation_speed(ai_get_object(e2m1_avt_driver_1), 0.1);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
	sleep_until ((	s_e2m1_aa_powerdown_count > 3), 1);
	sleep_s(1.25);
	cs_aim(true, e2m1_sleep_points.p5);
	sleep_forever();
end

// -6.351825, -14.395374, 0.199065
// -6.351825, -14.395374, -3.260886
script command_script cs_power_down_turret_2
	sleep_s(1);
	cs_aim(true, e2m1_sleep_points.p2);
	cs_vehicle_speed(0.4);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
	sleep_until ((	s_e2m1_aa_powerdown_count > 3), 1);
	sleep_s(1.25);
	cs_aim(true, e2m1_sleep_points.p6);
	sleep_forever();
end

script command_script cs_power_down_turret_3
	sleep_s(1);
	cs_aim(true, e2m1_sleep_points.p3);
	cs_vehicle_speed(.4);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
	sleep_until ((	s_e2m1_aa_powerdown_count > 3), 1);
	sleep_s(1.25);
	cs_aim(true, e2m1_sleep_points.p7);
	sleep_forever();
end

script command_script cs_power_down_turret_4
	sleep_s(1);
	cs_aim(true, e2m1_sleep_points.p4);
	cs_vehicle_speed(.4);
	s_e2m1_aa_powerdown_count = s_e2m1_aa_powerdown_count + 1;
	sleep_until ((	s_e2m1_aa_powerdown_count > 3), 1);
	sleep_s(1.25);
	cs_aim(true, e2m1_sleep_points.p8);
	sleep_forever();
end

script command_script cs_e2m1_bishop_spawn
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 1 ); 		//Shrink size over time
	sleep(8);
	ai_exit_limbo (ai_current_actor);
	sleep(8);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1, 40 );			//grow size over time
end

script static void e2m1_end_scenario
	sleep_until (b_e2m1_vo_all_done == true);
	sleep_until (volume_test_players (tv_pelican), 1);
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	// mission accomplished stinger
	
	thread(f_music_e2m1_finish());
	sleep(30);
	thread(f_blip_object_cui (e2m1_pelican, ""));
	sleep(3);
	fade_out (0,0,0,30);
	sleep(30 * 1.5);
  cui_load_screen (ui\in_game\pve_outro\chapter_complete.cui_screen);
  b_wait_for_narrative_hud = false;
	player_control_fade_out_all_input (.1);
	b_end_player_goal = true;																							//advance objectives, ends scenario in this case	
end

script command_script cs_e2m1_pelican
	sleep(10);
	object_cannot_take_damage(ai_get_object(e2m1_pelican));
	object_cannot_take_damage(ai_vehicle_get ( ai_current_actor ));
	cs_fly_to_and_face (e2m1_pelican_pts.p0, e2m1_pelican_pts.look2);
	cs_fly_to_and_face (e2m1_pelican_pts.p1, e2m1_pelican_pts.look2);
	cs_fly_to_and_face (e2m1_pelican_pts.p2, e2m1_pelican_pts.look2);
	cs_fly_to_and_face (e2m1_pelican_pts.p3, e2m1_pelican_pts.look3);
	sleep(30);
	cs_fly_to_and_face (e2m1_pelican_pts.p4, e2m1_pelican_pts.look0);
	sleep(30);
	cs_fly_to_and_face (e2m1_pelican_pts.p5, e2m1_pelican_pts.look0);
end

//AutomatedTurretActivate(object turret)
//-	Used to activate (spawn in) an inactive turret without using a bishop.
//
//AutomatedTurretSwitchTeams(object turret, object newTeamObj)
//-	Used to switch a turret’s team without bishop interaction.
//-	
//RequestAutomatedTurretActivation(object turret)
//-	Requests that a bishop fly to and activate the turret.
//
//RequestAutomatedTurretSwitchTeams(object turret)
//-	Requests that a bishop fly to and switch the turret’s team back to the bishop’s.


	//ai_place(bishops);																	
	//ai_place(turret);
	//sleep(30);
	//RequestAutomatedTurretActivation(turret);
	
script static void double_switch_hit
	thread(e2m1_both_switches_flipped());
	thread(e2m1_both_switches_flipped());
end