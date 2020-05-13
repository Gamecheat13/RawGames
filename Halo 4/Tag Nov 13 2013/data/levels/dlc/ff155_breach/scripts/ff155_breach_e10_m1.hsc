////=============================================================================================================================
////============================================ E10_M2 CAVERN KILL SCRIPT ==================================================
////=============================================================================================================================
global boolean b_e10_m1_stop_firing_1 = FALSE;
global boolean b_e10_m1_stop_firing_2 = FALSE;

script startup f_brach_e10_m1
	//Wait for the variant event
	if (f_spops_mission_startup_wait("e10_m1") ) then
		wake(f_breach_e10_m1_placement);
	end
end

script dormant f_breach_e10_m1_placement()
	f_spops_mission_setup( "e10_m1", e10_m1_dz, gr_ff_e10_m1_all, sp_e10_m1_start_pos, 80 );
	print("___________________________________running e10 m1");
	fade_out(0,0,0,15);

//================================================== OBJECTS ==================================================================
//set crate names
	f_add_crate_folder(e10m1_right_side_crates);
	f_add_crate_folder(e10m1_middle_crates);
	f_add_crate_folder(e10m1_left_side_crates);
	f_add_crate_folder(e10m1_digger_crates);
	f_add_crate_folder(e10m1_e_ammo);
//	f_add_crate_folder(e10m1_turrets);
	f_add_crate_folder(e10m1_dcs);
	
	
//set objectives
//	firefight_mode_set_objective_name_at(e10m1_aa_gun_01, 1);
//	firefight_mode_set_objective_name_at(e10m1_aa_gun_02, 2);
//	firefight_mode_set_objective_name_at(e10m1_aa_gun_03, 3);
//	firefight_mode_set_objective_name_at(e10m1_aa_gun_04, 4);
//	firefight_mode_set_objective_name_at(e10m1_aa_gun_05, 5);
	firefight_mode_set_objective_name_at(e10m1_jail_door_control, 6);

//set spawn folder names
	firefight_mode_set_crate_folder_at(sp_e10_m1_start_pos, 80);

//set locations
	firefight_mode_set_objective_name_at(e10_m1_lz_00, 50);
	firefight_mode_set_objective_name_at(e10_m1_lz_01, 51);
	firefight_mode_set_objective_name_at(e10_m1_lz_02, 52);
	firefight_mode_set_objective_name_at(e10_m1_lz_03, 53);
	firefight_mode_set_objective_name_at(e10_m1_lz_04, 54);
	firefight_mode_set_objective_name_at(e10_m1_lz_05, 55);
	firefight_mode_set_objective_name_at(e10_m1_lz_06, 56);
	firefight_mode_set_objective_name_at(e10_m1_lz_07, 57);
	firefight_mode_set_objective_name_at(e10_m1_lz_08, 58);
	firefight_mode_set_objective_name_at(e10_m1_lz_09, 59);
	firefight_mode_set_objective_name_at(e10_m1_lz_10, 60);
	firefight_mode_set_objective_name_at(e10_m1_lz_11, 61);
	firefight_mode_set_objective_name_at(e10_m1_lz_12, 62);
	firefight_mode_set_objective_name_at(e10_m1_lz_13, 63);
		
//set squad group names
	firefight_mode_set_squad_at(sq_e10m1_guard_1, 1);
//	firefight_mode_set_squad_at(gr_ff_e10_m2_guards_2, 2);

//	firefight_mode_set_squad_at(gr_ff_waves, 50);
	
	thread(f_e10_m1_intro());

// Add Crates
//	object_create_anew(e10_m2_base_1);
//	object_create_anew(e10_m2_pod_1);
	
	// Destroy Crates
//  object_destroy(cr_ff153_caverns_bridge_a);
//  object_destroy(cr_ff153_caverns_bridge_b);

	ordnance_set_droppod_object("environments\shared\crates\unsc\unsc_weapons_pod\unsc_weapons_pod_scenery\unsc_weapons_pod_e2_m1.scenery","objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect");
	
	//call the setup complete
	f_spops_mission_setup_complete( TRUE );
end

////----------------------------------------------------------------------------------------------------------------------------	
////-------------------------------------- OBJECTS END -------------------------------------------------------------------------
////----------------------------------------------------------------------------------------------------------------------------	

////-----------------------------------------------------------------------
////--------- Starting Mission stuff --------------------------------------
////-----------------------------------------------------------------------

//
//script static void f_e10m2_narrative_in_over()
//	b_e10m2_narrative_in_over = TRUE;
//end
//
script static void f_e10_m1_intro()
	sleep_until (f_spops_mission_ready_complete(), 1);
//	if editor_mode() then
//		print ("editor mode, no intro playing");
//		b_e10m2_narrative_in_over = TRUE;
//	else
//		sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m1_vin_sfx_intro', NONE, 1);
//		sleep_until(LevelEventStatus("loadout_screen_complete"), 1);
//		ai_enter_limbo(gr_ff_e10_m2_all);
//		cinematic_start();

		//intro();
	//f_e6_m5_intro_vignette();
//	end
//	sleep_until(b_e10m2_narrative_in_over == TRUE);
//	cinematic_stop();	

	f_spops_mission_intro_complete( TRUE );
	sleep_until( f_spops_mission_start_complete(), 1 );
	
	sleep_s(0.5);
	fade_in(0,0,0,15);
	ai_exit_limbo(gr_ff_e10_m1_all);
	
	
//	print("_______________________ MILLER: coming in hot Crimson");
//	sleep_s(3);
//	print("_______________________ MILLER: lots of dudes");
//	sleep_s(3);
//	vo_glo_ordnance_01();
//	sleep_s(2);
//	ordnance_drop(e10_m2_ord_1, "storm_rocket_launcher");
//	sleep_s(0.5);
//	ordnance_drop(e10_m2_ord_2, "storm_rail_gun_pve");
//	sleep_s(0.25);
//	ordnance_drop(e10_m2_ord_3, "storm_lmg");
//	sleep_s(0.25);
//	ordnance_drop(e10_m2_ord_4, "storm_rocket_launcher");
//	sleep_s(2.5);
//	thread(vo_glo_gotit_02());
//	//sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 16, 1);
//	print("_______________________ MILLER: get to that door!");
//	b_end_player_goal = TRUE;
//	thread(f_e10m2_at_door());
//	thread(f_e10_m2_cov_cavern_fighting());

	thread(f_e10m1_ready_for_pelican());
	thread(f_e10m1_at_blocked_tunnel());
	
	print("_________________________ blah blah");
	b_end_player_goal = TRUE;
end



script static void f_e10m1_at_blocked_tunnel()
	sleep_until(LevelEventStatus ("e10m1_at_blocked_tunnel"), 1);
	sleep_s(3);
	print("_________________________ readings are coming from in there for sure.");
	sleep_s(3);
	print("_________________________ maybe that's what they were after");
	sleep_s(3);
	print("_________________________ ok, lets get in there and finish the job");
	sleep_s(3);
	b_end_player_goal = TRUE;
end

script static void f_e10m1_ready_for_pelican()
	sleep_until(LevelEventStatus ("e10m1_ready_for_pelican"), 1);
	sleep_s(3);
	print("_________________________ door is locked");
	sleep_s(3);
	print("_________________________ we dont have time for this.");
	sleep_s(3);
	print("_________________________ crimson, pelican is on standby, clear those guns and we can clear the way for you");
	sleep_s(3);
	
	print("_________________________________bring in pelican");
	//script the pelican here 
	
	sleep_s(3);
	print("_________________________ can't get in, we are getting fire from the left side.");
	ai_place(e10m1_turret_1);
	ai_place(e10m1_turret_2);
	
	object_create_anew(e10_m1_lz_10);
	navpoint_track_object_named(e10_m1_lz_10, "navpoint_goto");
	
	
	sleep_until(volume_test_players(e10m1_going_to_aa_1), 1);
	f_unblip_object_cui(e10_m1_lz_10);
	object_create_anew(e10_m1_lz_11);
	navpoint_track_object_named(e10_m1_lz_11, "navpoint_goto");
	
	sleep_until(volume_test_players(e10m1_going_to_aa_2), 1);
	f_unblip_object_cui(e10_m1_lz_11);
	sleep_s(3);
	print("_________________________ ok, there they are");
	
	object_can_take_damage(ai_vehicle_get(e10m1_turret_1.turret));
	object_can_take_damage(ai_vehicle_get(e10m1_turret_2.turret));
//	navpoint_track_object_named((ai_vehicle_get(e10m1_turrets.spawn_points_0)), "navpoint_neutralize");
//	navpoint_track_object_named((ai_vehicle_get(e10m1_turrets.spawn_points_1)), "navpoint_neutralize");
	f_blip_object_cui(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret), "navpoint_healthbar_neutralize");
	f_blip_object_cui(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret), "navpoint_healthbar_neutralize");
	//navpoint_track_object_named(e10m1_aa_gun_04, "navpoint_neutralize");
	//navpoint_track_object_named(e10m1_aa_gun_05, "navpoint_neutralize");
	
	thread(f_e10m1_turret_1_dead());
	thread(f_e10m1_turret_2_dead());
	
	vo_glo_ordnance_01();
	sleep_s(2);
	ordnance_drop(f_e10_m1_pod_1, "storm_rocket_launcher");
	sleep_s(0.5);
	ordnance_drop(f_e10_m1_pod_2, "storm_rocket_launcher");
	sleep_s(0.25);
	ordnance_drop(f_e10_m1_pod_3, "storm_rocket_launcher");
	sleep_s(2.5);
	thread(vo_glo_gotit_02());
	
	
	sleep_until(ai_living_count(gr_sq_e10m2_aa_turret_1) <= 0 and ai_living_count(gr_sq_e10m2_aa_turret_2) <= 0, 1);
	//sleep_until((object_get_health(e10m1_aa_gun_04) <= 0) and (object_get_health(e10m1_aa_gun_05) <= 0), 1);
	
	sleep_s(3);
	print("_________________________ nice work, now regroup at the digger.");
	sleep_s(3);
	
	object_create_anew(e10_m1_lz_02);
	navpoint_track_object_named(e10_m1_lz_02, "navpoint_goto");
	
	sleep_until(volume_test_players(e10m1_back_at_digger), 1);
	f_unblip_object_cui(e10_m1_lz_02);
	sleep_s(5);
	
	print("_________________________pelican comes in and blows up something");
	
	sleep_s(5);
	b_end_player_goal = TRUE;
	thread(f_e10_m1_inside_digger());
end

script static void f_e10m1_turret_1_dead()
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_1.turret)) <= 0.20, 1);
	b_e10_m1_stop_firing_1 = TRUE;
	object_can_take_damage(ai_vehicle_get(e10m1_turret_1.turret));
	cs_run_command_script(gr_sq_e10m2_aa_turret_1, cs_e10_m1_kill_turret_1);
end

script command_script cs_e10_m1_kill_turret_1()
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_out", "primary_trigger");
	sleep_s(4);
	object_destroy(ai_vehicle_get(ai_current_actor));
end

script static void f_e10m1_turret_2_dead()
	sleep_until(object_get_health(ai_vehicle_get_from_spawn_point(e10m1_turret_2.turret)) <= 0.20, 1);
	b_e10_m1_stop_firing_2 = TRUE;
	object_can_take_damage(ai_vehicle_get(e10m1_turret_2.turret));
	cs_run_command_script(gr_sq_e10m2_aa_turret_2, cs_e10_m1_kill_turret_2);
end

script command_script cs_e10_m1_kill_turret_2()
	object_dissolve_from_marker(ai_vehicle_get(ai_current_actor), "phase_out", "primary_trigger");
	sleep_s(4);
	object_destroy(ai_vehicle_get(ai_current_actor));
end


script static void f_e10_m1_inside_digger
	sleep_until(LevelEventStatus ("e10_m1_inside_digger"), 1);
	
	print("_________________________radio chatter that says hey, scientists here");
	
	sleep_s(5);
	
	object_create_anew(e10_m1_lz_07);
	navpoint_track_object_named(e10_m1_lz_07, "navpoint_goto");
	
	sleep_until(volume_test_players(e10m1_at_hostages), 1);
	f_unblip_object_cui(e10_m1_lz_07);
	sleep_s(3);
	print("___________________________ look hostages");
	sleep_s(3);
	print("___________________________ go hit this button");
	sleep_s(3);

	navpoint_track_object_named(e10m1_jail_door_control, "navpoint_activate");
	thread(f_e10_m1_at_jail_controls());
	device_set_power(e10m1_jail_door_control, 1);
	
	
	
	
	//b_end_player_goal = TRUE;
end

script static void f_e10_m1_at_jail_controls
	sleep_until((device_get_position(e10m1_jail_door_control) == 1), 1);
	device_set_power(e10m1_jail_door_control, 0);
	navpoint_track_object(e10m1_jail_door_control, FALSE);
	print("___________________________ jail door down");
	sleep_s(3);
	print("___________________________ scientists say they dont have power.");
	sleep_s(3);
	print("___________________________ go look");
	sleep_s(3);
	b_end_player_goal = TRUE;
	thread(f_e10_m1_at_power_source());
end

script static void f_e10_m1_at_power_source
	sleep_until(LevelEventStatus ("e10_m1_at_power_source"), 1);
	print("___________________________ look no power");
	sleep_s(3);
	print("___________________________ alright, bug out, we need to go find power");
	sleep_s(3);
	b_end_player_goal = TRUE;
	thread(f_e10_m1_at_end());
end

script static void f_e10_m1_at_end
	sleep_until(LevelEventStatus ("e10_m1_at_end"), 1);
	sleep_s(3);
	print("___________________________ bring in a pelican here.");
	sleep_s(3);
	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
	fade_out(0, 0, 0, 90);
	b_end_player_goal = TRUE;
end



script command_script cs_e10_m1_turret_1
	object_set_scale(ai_vehicle_get(ai_current_actor ), .15, 0);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e10_m1_fake_ships_1.p0);
        sleep_rand_s(1,4);
        cs_shoot_point(true, e10_m1_fake_ships_1.p0);
        sleep_rand_s(1,5);
        cs_shoot_point(false, e10_m1_fake_ships_1.p0);
        sleep_rand_s(5,8);
     end
                               
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e10_m1_fake_ships_1.p1);
       sleep_rand_s(5,8);
     end
                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
			sleep_rand_s(1,4);
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
      sleep_rand_s(1,5);
      cs_shoot_point(false, e10_m1_fake_ships_1.p2);
      sleep_rand_s(5,8);
		end
                                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(false, e10_m1_fake_ships_1.p3);
  		sleep_rand_s(5,8);
		end
                                                
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p4);
       sleep_rand_s(1,4);
       cs_shoot_point(true, e10_m1_fake_ships_1.p4);
       sleep_rand_s(1,5);
       cs_shoot_point(false, e10_m1_fake_ships_1.p4);
       sleep_rand_s(5,8);
     end
                                                
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e10_m1_fake_ships_1.p5);
       sleep_rand_s(5,8);
     end                                        
	end
	until( b_e10_m1_stop_firing_1 == TRUE);
end

script command_script cs_e10_m1_turret_2
	object_set_scale(ai_vehicle_get(ai_current_actor ), .15, 0);
	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
	sleep_s(1);
  repeat
  	begin_random
    	begin
      	cs_shoot_point(true, e10_m1_fake_ships_1.p0);
        sleep_rand_s(1,4);
        cs_shoot_point(true, e10_m1_fake_ships_1.p0);
        sleep_rand_s(1,5);
        cs_shoot_point(false, e10_m1_fake_ships_1.p0);
        sleep_rand_s(5,8);
     end
                               
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p1);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e10_m1_fake_ships_1.p1);
       sleep_rand_s(5,8);
     end
                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
			sleep_rand_s(1,4);
      cs_shoot_point(true, e10_m1_fake_ships_1.p2);
      sleep_rand_s(1,5);
      cs_shoot_point(false, e10_m1_fake_ships_1.p2);
      sleep_rand_s(5,8);
		end
                                                
		begin
      cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(true, e10_m1_fake_ships_1.p3);
     	sleep_rand_s(1,3);
     	cs_shoot_point(false, e10_m1_fake_ships_1.p3);
  		sleep_rand_s(5,8);
		end
                                                
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p4);
       sleep_rand_s(1,4);
       cs_shoot_point(true, e10_m1_fake_ships_1.p4);
       sleep_rand_s(1,5);
       cs_shoot_point(false, e10_m1_fake_ships_1.p4);
       sleep_rand_s(5,8);
     end
                                                
     begin
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(true, e10_m1_fake_ships_1.p5);
       sleep_rand_s(1,3);
       cs_shoot_point(false, e10_m1_fake_ships_1.p5);
       sleep_rand_s(5,8);
     end                                        
	end
	until( b_e10_m1_stop_firing_2 == TRUE);
end




//script static void f_e10m2_at_door
//	sleep_until(LevelEventStatus ("e10_m2_at_door"), 1);
//	sleep_s(3);
//	print("___________________________ MILLER: Its blocked. hold on, we are hacking the door controls!");
//	sleep_until(ai_living_count(gr_ff_e10_m2_all) <= 3, 1);
//	ai_set_objective(gr_ff_e10_m2_all, e10_m2_survival_inside);
//	print("___________________________ ROLAND: Got it!");
//	sleep_s(3);
//	b_end_player_goal = TRUE;
//	thread(f_e10_m2_front_door_open());
//	device_set_power(e10m2_door_control, 1);
//	device_set_power(cavern_front_door, 1);
//	sleep_until(device_get_position(e10m2_door_control) == 1, 1);
//	device_set_power(e10m2_door_control, 0);
//	device_set_position(cavern_front_door, 1);
//end
//
//script static void f_e10_m2_at_bridge_controls
//	sleep_until(LevelEventStatus ("e10_m2_at_bridge_controls"), 1);
//	thread(f_e10m2_switch3_1_guards());
//	thread(f_e10m2_switch3_2_guards());
////	sleep_s(3);
////	print("___________________________ turn on the bridge");
//	sleep_s(3);
//	object_create_anew(cr_ff153_caverns_bridge_a);
//	object_create_anew(cr_ff153_caverns_bridge_b);
//	print("___________________________ now go here");
//	sleep_s(1);
//	//b_end_player_goal = TRUE;
//	
//	object_create_anew(e10_m2_lz_06);
//	navpoint_track_object_named(e10_m2_lz_06, "navpoint_goto");
//	sleep_until(volume_test_players(t_e10_m2_security_office), 1);
//	object_destroy(e10_m2_lz_06);
//	sleep_s(1);
//	print("___________________________ Miller: What are they looking for?");
//	sleep_s(3);
//	print("___________________________ ROLAND: Marking it now");
//	sleep_s(3);
//	b_end_player_goal = TRUE;
//	device_set_power(e10m2_switch_3, 1);
//end
//
//script static void f_e10_m2_at_security_office
//	sleep_until(LevelEventStatus ("e10_m2_at_security_office"), 1);
//	device_set_power(e10m2_switch_3, 0);
//	sleep_s(3);
//	print("___________________________ MILLER: Ok, so now what did that do.");
//	sleep_s(3);
//	print("___________________________ ROLAND: I believe Crimson has activated the backup generator.");
//	sleep_s(3);
//	print("___________________________ ROLAND: Getting a read on its location now. There. Marking it.");
//	object_create_anew(e10_m2_lz_04);
//	navpoint_track_object_named(e10_m2_lz_04, "navpoint_goto");
//	//thread(f_e10m2_switch2_guards());
//	
//	thread(f_e10m2_power_switch_1());
//	thread(f_e10m2_power_switch_2());
//	
//	sleep_until(volume_test_players(t_e10_m2_switch_2), 1);
//	object_destroy(e10_m2_lz_04);
//	ai_place_in_limbo(e10_m2_int_fr_switch_2);
//	ai_place_with_birth(e10_m2_int_fr_switch_2_b);
//	sleep_s(2);
//	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_2) <= 0, 1);
//	sleep_s(3);
//	print("___________________________ ROLAND: Activate that device. It should route power to the switch.");
//	navpoint_track_object_named(e10m2_switch_2, "navpoint_activate");
//	device_set_power(e10m2_switch_2, 1);
//	sleep_until((device_get_position(e10m2_switch_2) == 1), 1);
//	navpoint_track_object(e10m2_switch_2, FALSE);
//	device_set_power(e10m2_switch_2, 0);
//	object_destroy(e10m2_shell_2);
//	print("___________________________ eventually, this will spin on and dissolve out.");
//	sleep_s(3);
//	print("___________________________ ROLAND: thats only hald the curcuit. go here now.");
//	
//	object_create_anew(e10_m2_lz_03);
//	navpoint_track_object_named(e10_m2_lz_03, "navpoint_goto");
//	//thread(f_e10m2_switch1_guards());
//	
//	sleep_until(volume_test_players(t_e10_m2_switch_1), 1);
//	object_destroy(e10_m2_lz_03);
//	ai_place_in_limbo(e10_m2_int_fr_switch_1);
//	ai_place_with_birth(e10_m2_int_fr_switch_1_b);
//	sleep_s(2);
//	sleep_until(ai_living_count(gr_ff_e10_m2_fr_switch_1) <= 0, 1);
//	navpoint_track_object_named(e10m2_switch_1, "navpoint_activate");
//	device_set_power(e10m2_switch_1, 1);
//	sleep_until((device_get_position(e10m2_switch_1) == 1), 1);
//	navpoint_track_object(e10m2_switch_1, FALSE);
//	device_set_power(e10m2_switch_1, 0);
//	object_destroy(e10m2_shell_1);
//	
//	print("___________________________ ROLAND: that should do it. terminal should be back up.");
//	thread(f_e10_m2_at_back_door_controls_2());
//	b_end_player_goal = TRUE;
//	object_create_anew(e10m2_back_door_console);
//	object_create_anew(e10m2_switch_back_door);
//	device_set_power(e10m2_switch_back_door, 1);
//end
//
//script static void f_e10_m2_at_back_door_controls_2
//	sleep_until(LevelEventStatus ("e10_m2_at_back_door_controls_2"), 1);
//	device_set_power(e10m2_switch_back_door, 0);
//	device_set_power(cavern_back_door, 1);
//	device_set_position(cavern_back_door, 1);
//	object_create_anew(e10_m2_lz_02);
//	navpoint_track_object_named(e10_m2_lz_02, "navpoint_goto");
//	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
//	
//	object_destroy(e10_m2_lz_06);
//	object_create_anew(e10_m2_lz_07);
//	navpoint_track_object_named(e10_m2_lz_07, "navpoint_goto");
//	sleep_until(volume_test_players(t_e10_m2_end), 1);
//	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//	b_end_player_goal = TRUE;
//end
//
//script static void f_e10m2_power_switch_1()
//	sleep_until(device_get_position(e10m2_switch_1) == 1, 1);
//	device_set_power(e10m2_switch_1, 0);
//end
//
//script static void f_e10m2_power_switch_2()
//	sleep_until(device_get_position(e10m2_switch_2) == 1, 1);
//	device_set_power(e10m2_switch_2, 0);
//end
//
////script static void f_e10_m2_at_1st_control
////	sleep_until(LevelEventStatus ("e10_m2_at_1st_control"), 1);
//////	sleep_s(3);
//////	print("___________________________ hit some switches");
////	sleep_s(3);
////	print("___________________________ now go here");
////	sleep_s(1);
////	b_end_player_goal = TRUE;
////	thread(f_e10_m2_at_back_door_1st_time());
////end
//
//
////script static void f_e10_m2_at_3rd_control
////	sleep_until(LevelEventStatus ("e10_m2_at_3rd_control"), 1);
////	sleep_s(3);
////	print("___________________________ hit even more switches");
////	sleep_s(3);
////	print("___________________________ door is open");
////	device_set_power(cavern_back_door, 1);
////	device_set_position(cavern_back_door, 1);
////	sleep_s(3);
////	print("___________________________ now go here");
////	sleep_s(1);
////	b_end_player_goal = TRUE;
////end
//
//script static void f_e10_m2_at_back_door
//	sleep_until(LevelEventStatus ("e10_m2_at_3rd_control"), 1);
//	object_create_anew(e10_m2_lz_06);
//	navpoint_track_object_named(e10_m2_lz_06, "navpoint_goto");
//	sleep_until(volume_test_players(t_e10_m2_loc_2), 1);
//	
//	object_destroy(e10_m2_lz_06);
//	object_create_anew(e10_m2_lz_07);
//	navpoint_track_object_named(e10_m2_lz_07, "navpoint_goto");
//	sleep_until(volume_test_players(t_e10_m2_end), 1);
//	cui_load_screen(ui\in_game\pve_outro\chapter_complete.cui_screen);
//	fade_out(0, 0, 0, 90);
//	b_end_player_goal = TRUE;
//end
//
//
//script static void f_e10_m2_spawn_back_door
//	sleep_until(volume_test_players(t_e10_m2_spawn_back_door), 1);
//	if ai_living_count(gr_ff_e10_m2_all) <= 15 then
//		ai_place(e10_m2_int_back_door);
//	end
//end
//
//script command_script cs_e10m2_pelican_in
//	cs_ignore_obstacles (TRUE);
//	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
//	sleep_s(5);
//	cs_fly_to_and_face (e10m2_pelican_in.p0, e10m2_pelican_in.p4);
//	sleep_s(5);
//	cs_fly_to_and_face (e10m2_pelican_in.p1, e10m2_pelican_in.p2);
//	cs_fly_to_and_face (e10m2_pelican_in.p2, e10m2_pelican_in.p3);
//	cs_fly_to_and_face (e10m2_pelican_in.p3, e10m2_pelican_in.p3);
//	ai_erase(e10m2_pelican_in);
//end

//script command_script cs_e3_m1_escape_phantom()
//	cs_ignore_obstacles (TRUE);
//	object_cannot_take_damage(ai_vehicle_get(ai_current_actor));
//	sleep_until(LevelEventStatus("start_e3_m1_escape_phantom"), 1);
//	navpoint_track_object_named((ai_vehicle_get(ai_current_actor)), "navpoint_enemy_vehicle");
//	cs_fly_to_and_face (e3_m1_escape_phantom.p0, e3_m1_escape_phantom.p1);
//	cs_fly_to_and_face (e3_m1_escape_phantom.p2, e3_m1_escape_phantom.p1);
//	f_unblip_object_cui(ai_vehicle_get(ai_current_actor));
//	cs_fly_to_and_face (e3_m1_escape_phantom.p9, e3_m1_escape_phantom.p10);
//	cs_fly_to_and_face (e3_m1_escape_phantom.p10, e3_m1_escape_phantom.p11);
//	//sleep_s(5);
//	object_set_scale(ai_vehicle_get(ai_current_actor), 0.01, 120); //Shrink size over time
//	ai_erase(fw_e3_m1_escape_phantom);
//end

//script static void f_set_up_1st_wave()
//	ai_suppress_combat(fw_e3_m1_escape_phantom, TRUE);
//	ai_set_blind(fw_e3_m1_escape_phantom, TRUE);
//	ai_set_deaf(fw_e3_m1_escape_phantom, TRUE);
//	thread(f_music_e3m1_targetid_vo());
//	sleep_s(3);
//	wake(e3m1_vo_targetid);
//	sleep_s(1);
//	sleep_until((e3m1_narrative_is_on == FALSE), 1);
//	thread(f_music_e3m1_objective_1());
//	sleep_s(1);
//	b_end_player_goal = TRUE;
//	sleep_s(1);
//	f_new_objective(e3_m1_objective_1);
//end
//
//script static void f_e3_m1_move_up_chokepoint()
//	sleep_until(ai_living_count(chokepoint_guards) <= 5, 1);
//	ai_set_task(chokepoint_guards, obj_chokepoint, guard_front);
//	ai_grunt_kamikaze(chokepoint_guards.g_g_1);
//end
//
//script static void f_1st_grunts_to_ghosts()
//	sleep_until(volume_test_players(first_grunts_to_ghosts), 1);
//	thread(f_e3_m1_camp_grunt_kamikaze());
//	ai_set_objective(camp_guards_elite, obj_e3_m1_survival);
//	ai_set_objective(camp_guards_grunts, obj_e3_m1_survival);
//	thread(f_music_e3m1_first_grunts_to_ghosts());
//	thread(f_e3_m1_cliff_snipers2());
//	thread(f_target_vip());
//	f_e3_m1_sniper_global_vo();
//	sleep_until((e3m1_narrative_is_on == FALSE), 1);
//	vo_glo_ordnance_01();
//	ordnance_drop(f_e3m1_d2, "storm_sniper_rifle");
//end
