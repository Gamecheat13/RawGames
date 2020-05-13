	

//global vehicle v_sur_drop_01 = NONE;
//global boolean do_the_anim = FALSE;
//global boolean cryptum_complete = FALSE;
//
//global boolean 	first_time_charged = FALSE;
//global ai the_guy = NONE;

;;global boolean toggle_drops = FALSE;


//global short max_distance = 250;
//global short min_distance = 230;

global boolean target_designator_disabled = FALSE;
global boolean first_time_charged = true;
global boolean rail_gun_prompt_bool = false;

script startup jesse_playground_main()
	ai_place (flying_phantoms);

                thread (m40_target_designator_main());
                sleep(1);
                thread (target_designator_unlock());


//	local long thread_id = thread(pelican_flyto_random_points());
//	sleep_s(5);
//	kill_thread(thread_id);
	
	//thread (turret_prototype());


	//thread (warthog_fx_setup(hog));
	//cui_hud_set_new_objective (chtitlee3obj);
//	print ("stuff");
//	objects_attach (sq1.sp1, "", thingy, "");
//	
//	thread (get_pos(sq1.sp1));
//	
//	sleep_until (object_get_health(sq1.sp1) <= 0, 1);
//	
//	print ("do et");
//	//object_teleport_to_object(thingy, equipmenty);
//	
//	
//	object_move_by_offset (equipmenty,0, my_x- object_get_x (equipmenty), my_y - object_get_y (equipmenty), (my_z - object_get_z (equipmenty)) + 0.5);
//	
//	sleep (1);
//	if (not volume_test_object (the_trig, equipmenty)) then
//		object_move_to_flag (equipmenty, 0, the_flag);
//	end
//	
//	f_blip_object (equipmenty, "default");
//		
//	object_wake_physics (equipmenty);
//	
//	sleep_until (	unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
//		or 					unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
//		or 					unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
//		or 					unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
//	, 1);
//	
//	
//		f_unblip_object (equipmenty);
//	
//	
//end
//
//global real my_x = 0;
//global real my_y = 0;
//global real my_z = 0;
//
//script static void get_pos(object guy)
//	repeat
//		my_x = object_get_x (guy);
//		my_y = object_get_y (guy);
//		my_z = object_get_z (guy);
//	until (object_get_health(guy) <= 0, 1);
end

//
//global real health_threshold = 0.1;
//	
//script static void warthog_fx_setup(object the_vehicle)
//
//	local real health_threshold = 0.1;
//	local long thread_id = -1;
//	
//	repeat
//	
//		sleep_until (object_get_health(the_vehicle) <= health_threshold and player_in_vehicle(vehicle(the_vehicle)), 1);
//		
//		print ("play damage effects");
//		
//		effect_new_on_object_marker( 'fx\library\light\light_red\light_red.effect', the_vehicle, "fx_dashboard_light" );
//		effect_new_on_object_marker( 'fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect', the_vehicle, "fx_body_burning_hood" );
//		sound_looping_start ('sound\storm\vehicles\warthog\veh_warthog_damage_loop.sound_looping', the_vehicle, 1);
//		//thread_id = thread(near_death_warning_sound(the_vehicle));
//		
//		sleep_until (object_get_health(the_vehicle) > health_threshold or not player_in_vehicle(vehicle(the_vehicle)), 1);
//		
//		print ("stop damage effects");
//		
//		effect_stop_object_marker( 'fx\library\light\light_red\light_red.effect', the_vehicle, "fx_dashboard_light" );
//		effect_stop_object_marker( 'fx\library\fire\fire_and_smoke_mech\firesmoke_fire_smokeonly.effect', the_vehicle, "fx_body_burning_hood" );
//		//kill_thread (thread_id);
//		sound_looping_stop ('sound\storm\vehicles\warthog\veh_warthog_damage_loop.sound_looping');
//		
//	until (object_get_health(the_vehicle) < 0, 1);		
//end
//
//script static void near_death_warning_sound(object the_vehicle)
//	repeat
//		sound_impulse_start ('sound\game_sfx\ui\transition_beeps.sound', the_vehicle, 1);
//	until (1 == 0 and object_get_health(the_vehicle) <= health_threshold, 5);
//end

//	repeat
//		if ((ai_living_count(vehicle_turret) == 0) and objects_distance_to_point (players(), ext_turrets.spawn_00) < min_distance and (ai_body_count (turrets.turret1) == 0)) then
//			ai_place(vehicle_turret);
//			//object_hide(ai_vehicle_get(vehicle_turret.turret1));
//			object_dissolve_from_marker(ai_vehicle_get(vehicle_turret.turret1), "phase_in", "primary_trigger");
//			
//			effect_new_on_object_marker ("objects\vehicles\forerunner\turrets\storm_anti_vehicle_turret\fx\spr_gravity_lift", ai_vehicle_get(vehicle_turret.turret1), "primary_trigger");
//			
//			sleep_s(2);
//			effect_stop_object_marker ("objects\vehicles\forerunner\turrets\storm_anti_vehicle_turret\fx\spr_gravity_lift", ai_vehicle_get(vehicle_turret.turret1), "primary_trigger");
//
//		end
//		
//		if ((ai_living_count(vehicle_turret) == 1) and objects_distance_to_point (players(), ext_turrets.spawn_00) > max_distance) then
//			object_dissolve_from_marker(ai_vehicle_get(vehicle_turret.turret1), "phase_out", "primary_trigger");
//			sleep_s(2);
//			object_destroy (ai_vehicle_get(vehicle_turret.turret1));
//		end
//		
//	until (1 == 0, 30*5); 
//
//script static void pelican_flyto_random_points()
//	repeat 
//		begin_random_count(1)
//			print ("1");	// replace with fly_to commands
//			print ("2");
//			print ("3");
//		end
//	until (1 == 0, 15);	// set the time here to be whatever instead of 1/2 a second
//end
//
//script static void turret_prototype()
//
//	AutomatedTurretActivate(sq1.sp1);
//	thread(turret_firing_cycle());
//end
//
//global boolean turret_can_shoot = 0;
//script command_script turret_firing_control()
//
//	repeat
//		if (turret_can_shoot) then
//			cs_aim_player (1);
//			cs_shoot(1);
//		else
//			cs_shoot(0);
//			cs_aim_player (1);
//		end
//	until (1 == 0, 1); 
//end
//
//
//script static void turret_firing_cycle()
//	repeat
//		sleep_s(3);
//		effect_new_on_object_marker ("objects\vehicles\covenant\cov_drop_pod_001_mp\fx\cg_dp_thruster.effect", sq1.sp1, "root");
//		object_can_take_damage( ai_vehicle_get( sq1.sp1 ) );
//		print ("can take damage");
//		sleep_s(1);
//		effect_new_on_object_marker ("objects\vehicles\covenant\cov_drop_pod_001_mp\fx\cg_dp_thruster.effect", sq1.sp1, "root");
//		sleep_s(1);
//		effect_new_on_object_marker ("objects\vehicles\covenant\cov_drop_pod_001_mp\fx\cg_dp_thruster.effect", sq1.sp1, "root");
//		sleep_s(1);
//		effect_new_on_object_marker ("objects\vehicles\covenant\cov_drop_pod_001_mp\fx\cg_dp_thruster.effect", sq1.sp1, "root");
//		sleep_s(1);
//		effect_new_on_object_marker ("objects\vehicles\covenant\cov_drop_pod_001_mp\fx\cg_dp_thruster.effect", sq1.sp1, "root");
//		sleep_s(1);
//		turret_can_shoot = 1;
//		sleep_s(1);
//		turret_can_shoot = 0;
//		object_cannot_take_damage (ai_vehicle_get (sq1.sp1));
//		print ("cant take damage");
//	until (1 == 0, 1); 
//
//end

//
//script static void fx_test()
//	repeat		
//			print ("play fx");
//			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", mag, "left_sparks");
//			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", mag, "right_sparks");
//			
//			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", player0, "left_foot");
//			effect_new_on_object_marker ("environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect", player0, "right_foot");
//			sleep (10);
//	until (1==0, 1);
//end
//
//script static void friend_vs_foe()
//	static unit ghost_of_a_man = unit(player1);
//	
//	ai_place (sq);
//	player_possess_ai (1, sq.guy);
//	
//	sleep_until (unit_get_health (player1) <= 0, 1);
//
//	game_force_respawn_for_player (player1);
//			
//	sleep_until (unit_get_health (player1) != 0, 1);
//
//	if (unit_get_health (unit(sq.guy2)) > 0) then
//		sleep(1);
//		player_possess_ai (1, sq.guy2);
//	end
//
//	inspect (ghost_of_a_man);
//	unit_kill_silent (unit(ghost_of_a_man));
//end
//
//
//
//
//script static void cool_mover_stuff()
//	// device machine stop test
//	static short ts = 0;			// time start
//	static short te = 0;			// time end
//	static short td = 0;			// time delta
//	static real datt = 17;		// device animatation time total
//	static real satt = 0;			// static device animatation time total
//	static real dsp = 0;			// device stop percentage
//	
//	satt = datt;
//	
//	thread (moving());		
//	thread (not_moving());
//	thread (attach_player());
//	
//	sleep (1);
//
//	device_set_position_track( thing, 'any:idle', 0 );
//	
//	repeat
//		// faked input / interrupt
//		sleep_until (do_the_anim, 1);
//		
//		// end time
//		te = game_tick_get();
//		
//		// get delta after first time though to rewind
//		if (ts != 0) then
//			td = te - ts;												// all in frames
//			datt = ((datt * 30) + (td)) / 30;		// convert to seconds
//			
//			// set this back to default if over
//			if (datt > satt) then
//				datt = satt;
//			end
//		end
//			
//		// begin time
//		ts = game_tick_get();
//	
//		device_animate_position( thing, 1, datt, 1, 0.1, 0 );
//		
//		sleep_until (not(do_the_anim), 1);
//		
//		// end time
//		te = game_tick_get();
//	
//		// get delta
//		td = te - ts;												// all in frames
//		datt = ((datt * 30) - (td)) / 30;		// convert to seconds
//		
//		// check value
//		print ("td:");
//		inspect (td);
//		// check value
//		print ("datt:");
//		inspect (datt);		
//
//		dsp = device_get_position (thing);
//				
//		// check the percentage
//		print ("dsp:");
//		inspect (dsp);
//		
//		if (dsp >= 1.0) then
//			cryptum_complete = true;
//		end
//		
//		// stop the aniamtion where ever it is, instantly.
//		device_animate_position( thing, dsp, 0, 0, 0, 1 );
//		print ("anim stopped");
//		
//		// begin time
//		if (dsp != 1.0) then
//			ts = game_tick_get();
//			device_animate_position( thing, 0, satt - datt, 1, 0.1, 0 );
//		end
//	until (cryptum_complete == true, 1);
//	
//end
//
//script static void cryptum_state_watcher()
//
//	static real dsp = 0;			// device stop percentage
//	repeat
//		dsp = device_get_position (thing);
//	
//		// begin time
//		if (dsp > 0.28 and dsp < 0.30) then
//			thread (camera_shake_player (player0, 0.3, 0.3, 1, 1));
//			effect_new_on_object_marker ("fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\04\space_battle_explosion.effect", thing, "outer_piece");
//			sleep_s (0.5);
//		end
//		
//		if (dsp > 0.54 and dsp < 0.56) then
//			thread (camera_shake_player (player0, 0.3, 0.3, 1, 1));
//			effect_new_on_object_marker ("fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\04\space_battle_explosion.effect", thing, "lock_in2");
//			camera_set (home_camera, 60);
//			sleep_s (0.5);
//		end
//		
//		if (dsp > 0.80 and dsp < 0.82) then
//			thread (camera_shake_player (player0, 0.3, 0.3, 1, 1));
//			effect_new_on_object_marker ("fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\04\space_battle_explosion.effect", thing, "lock_in");
//			sleep_s (0.5);
//		end
//		
//		if (dsp > 0.97 and dsp < 0.99) then
//			thread (camera_shake_player (player0, 0.5, 0.5, 1, 1));
//			effect_new_on_object_marker ("fx\reach\fx_library\cinematics\boneyard\040lb_cov_flee\02\shot_1\longsword_attack_explosion.effect", thing, "center");
//			effect_new_on_object_marker ("fx\reach\fx_library\cinematics\boneyard\110lc_leave_hc\shot_7\explosion_huge.effect", thing, "center");
//			sleep_s (0.5);
//		end
//	until (cryptum_complete == true, 1);
//end
//
//
//script static void attach_player()
//	repeat 
//		sleep_until(do_the_anim == true, 1);
//		sleep (10);
//		objects_attach (thing, "player_attach", player0,"");
//		camera_control (true);
//		camera_set (camera_1, 60);
//		//camera_set_relative (camera_1, 60, player0);
//		sleep (30);
//		sleep_until(do_the_anim == false, 1);
//		camera_set (home_camera, 60);
//		sleep_s (2);
//		objects_detach (thing, player0);
//		camera_control (false);
//	until (cryptum_complete == true, 1);
//end
//
////script continuous hax2()
////print ("sdfsdF");
////		inspect (player_action_test_move_relative_all_directions());
////		player_action_test_reset();
////end
//
//script static void moving()	
//	repeat
//			sleep_until (player_action_test_context_primary() == TRUE, 1);
//			do_the_anim = true;
//			player_action_test_reset();
//	until (cryptum_complete == true,1);
//end
//
//script static void not_moving()	
//	repeat
//			sleep_until (player_action_test_context_primary() == FALSE, 1);
//			do_the_anim = false;
//			player_action_test_reset();
//	until (cryptum_complete == true,1);
//end
//
//script static void drop_toggle_mode()	
//	repeat
//		sleep_until (player_action_test_dpad_down() == TRUE, 1);
//			
//		print ("D-pad down: Object Mode Toggled");
//		
//		if (toggle_drops == TRUE) then
//			toggle_drops_set(FALSE);
//		else
//			toggle_drops_set(TRUE);
//		end
//		
//		notifylevel( "change drop state" );
////		inspect(toggle_drops);
//				
//		sleep (15);					
//		player_action_test_reset();
//		sleep (15);
//
//	until (1 == 0,1);
//end
//
//
//script static void start_cryo_clock()
//	static short ms_init_10 = 5;
//	static short sec_init_1 = 5;
//	static short sec_init_10 = 5;
//	static short min_init_1 = 9;
//	static short min_init_10 = 5;
//	static short hour_init_1 = 3;
//	static short hour_init_10 = 2;
//	static short day_init_1 = 3;
//	static short day_init_10 = 4;
//	static short day_init_100 = 3;
//	static short year_init_1 = 3;
//	static short year_init_10 = 0;
//	static short year_init_100 = 0;
//	
//	thread (set_cryo_clock_init_num(ms_10, ms_init_10));
//	thread (set_cryo_clock_init_num(sec_1, sec_init_1));
//	thread (set_cryo_clock_init_num(sec_10, sec_init_10));
//	thread (set_cryo_clock_init_num(min_1, min_init_1));
//	thread (set_cryo_clock_init_num(min_10, min_init_10));
//	thread (set_cryo_clock_init_num(hour_1, hour_init_1));
//	thread (set_cryo_clock_init_num(hour_10, hour_init_10));
//	thread (set_cryo_clock_init_num(day_1, day_init_1));
//	thread (set_cryo_clock_init_num(day_10, day_init_10));
//	thread (set_cryo_clock_init_num(day_100, day_init_100));
//	thread (set_cryo_clock_init_num(year_1, year_init_1));
//	thread (set_cryo_clock_init_num(year_10, year_init_10));
//	thread (set_cryo_clock_init_num(year_100, year_init_100));
//	
//	// ms
//	thread (set_cryo_clock_num_ms_1(ms_1));
//	thread (set_cryo_clock_num_ms_10(ms_10, sec_init_1));
//		
//	// seconds
//	thread (set_cryo_clock_num_sec_1(sec_1, 1, sec_init_1));
//	thread (set_cryo_clock_num_sec_10(sec_10, 10, sec_init_10));
//	
//	// minutes
//	thread (set_cryo_clock_num_min_1(min_1, 60, min_init_1));
//	thread (set_cryo_clock_num_min_10(min_10, 600, min_init_10));
//		
//	// hours
//	thread (set_cryo_clock_num_hour_1(hour_1, 3600, hour_init_1, hour_init_10));
//	thread (set_cryo_clock_num_hour_10(hour_10, 36000, hour_init_10));
//	
//	// days
//	thread (set_cryo_clock_num_day_1(day_1, 86400, day_init_1));
//	thread (set_cryo_clock_num_day_10(day_10, 864000, day_init_10, 34));	// careful with this one
//	thread (set_cryo_clock_num_day_100(day_100, 8640000, day_init_100));	
//	
//end
//
//script static void set_cryo_clock_init_num(object num, short init)
//		if (init == 0) then
//				object_set_permutation (num, "","0");
//		end
//		
//		if (init == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (init == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (init == 3) then
//				object_set_permutation (num, "","3");
//		end
//
//		if (init == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (init == 5) then
//				object_set_permutation (num, "","5");
//		end
//		
//		if (init == 6) then
//				object_set_permutation (num, "","6");
//		end
//		
//		if (init == 7) then
//				object_set_permutation (num, "","7");
//		end
//		
//		if (init == 8) then
//				object_set_permutation (num, "","8");
//		end
//
//		if (init == 9) then
//				object_set_permutation (num, "","9");
//		end		
//end
//
//script static void set_cryo_clock_num_ms_1(object num)
//				
//	repeat 
//		begin_random 
//			object_set_permutation (num, "","0"); 
//			object_set_permutation (num, "","1");
//			object_set_permutation (num, "","2"); 
//			object_set_permutation (num, "","3");
//			object_set_permutation (num, "","4"); 
//			object_set_permutation (num, "","5");
//			object_set_permutation (num, "","6"); 
//			object_set_permutation (num, "","7");
//			object_set_permutation (num, "","8"); 
//			object_set_permutation (num, "","9");
//		end
//	until (1 == 0, 1);
//
//end
//
//script static void set_cryo_clock_num_ms_10(object num, short init)
//	
//	static short current_time = 0;
//	current_time = init;
//
//	// set up the first time through	
//	current_time = current_time + 1;
//
//	if (current_time == 0 or current_time >= 10) then
//			object_set_permutation (num, "","0");
//			current_time = 0;		
//			NotifyLevel( "start seconds one" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end		
//
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end		
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end		
//	
//		if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end		
//	
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end			
//				
//	// clock loop				
//	repeat 	
//		current_time = current_time + 1;
//		
//		if (current_time == 0 or current_time >= 10) then
//				object_set_permutation (num, "","0");
//				current_time = 0;		
//				NotifyLevel( "start seconds one" );
//		end
//		
//		if (current_time == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (current_time == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (current_time == 3) then
//				object_set_permutation (num, "","3");
//		end
//	
//		if (current_time == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (current_time == 5) then
//				object_set_permutation (num, "","5");
//		end		
//	
//		if (current_time == 6) then
//				object_set_permutation (num, "","6");
//		end		
//		
//		if (current_time == 7) then
//				object_set_permutation (num, "","7");
//		end		
//		
//			if (current_time == 8) then
//				object_set_permutation (num, "","8");
//		end		
//		
//		if (current_time == 9) then
//				object_set_permutation (num, "","9");
//		end			
//
//	until (1 == 0, 3);
//
//end
//
//script static void set_cryo_clock_num_sec_1(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	current_time = init;
//		
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start seconds one" ), 1 );
//	current_time = current_time + 1;
//	
//	if (current_time == 0 or current_time == 10) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			NotifyLevel( "start seconds tens" );		
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end
//	
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end
//	
//	if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end
//
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end		
//			
//	repeat 
//		current_time = current_time + 1;
//			
//		if (current_time == 0 or current_time == 10) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				NotifyLevel( "start seconds tens" );		
//		end
//		
//		if (current_time == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (current_time == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (current_time == 3) then
//				object_set_permutation (num, "","3");
//		end
//
//		if (current_time == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (current_time == 5) then
//				object_set_permutation (num, "","5");
//		end
//		
//		if (current_time == 6) then
//				object_set_permutation (num, "","6");
//		end
//		
//		if (current_time == 7) then
//				object_set_permutation (num, "","7");
//		end
//		
//		if (current_time == 8) then
//				object_set_permutation (num, "","8");
//		end
//
//		if (current_time == 9) then
//				object_set_permutation (num, "","9");
//		end		
//		
//	until (1 == 0, 30 * loop_time);
//
//end
//
//script static void set_cryo_clock_num_sec_10(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	current_time = init;
//
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start seconds tens" ), 1 );
//	current_time = current_time + 1;
//
//	if (current_time == 0 or current_time == 6) then
//			object_set_permutation (num, "","0");
//			current_time = 0;		
//			NotifyLevel( "start minutes one" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end		
//				
//	// clock loop				
//	repeat 	
//		current_time = current_time + 1;
//		
//		if (current_time == 0 or current_time == 6) then
//				object_set_permutation (num, "","0");
//				current_time = 0;		
//				NotifyLevel( "start minutes one" );
//		end
//		
//		if (current_time == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (current_time == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (current_time == 3) then
//				object_set_permutation (num, "","3");
//		end
//
//		if (current_time == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (current_time == 5) then
//				object_set_permutation (num, "","5");
//		end
//
//
//	until (1 == 0, 30 * loop_time);
//
//end
//
//script static void set_cryo_clock_num_min_1(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	current_time = init;
//	
//	// first time through
//
//	sleep_until( LevelEventStatus( "start minutes one" ), 1 );
//	current_time = current_time + 1;
//		
//	if (current_time == 0 or current_time == 10) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				NotifyLevel( "start minutes tens" );
//
//	end
//		
//	if (current_time == 1) then
//				object_set_permutation (num, "","1");
//	end
//		
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end
//	
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end
//	
//	if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end
//
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end		
//	
//	// clock loop	
//	repeat 
//		current_time = current_time + 1;
//	
//		if (current_time == 0 or current_time == 10) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				NotifyLevel( "start minutes tens" );
//		end
//		
//		if (current_time == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (current_time == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (current_time == 3) then
//				object_set_permutation (num, "","3");
//		end
//
//		if (current_time == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (current_time == 5) then
//				object_set_permutation (num, "","5");
//		end
//		
//		if (current_time == 6) then
//				object_set_permutation (num, "","6");
//		end
//		
//		if (current_time == 7) then
//				object_set_permutation (num, "","7");
//		end
//		
//		if (current_time == 8) then
//				object_set_permutation (num, "","8");
//		end
//
//		if (current_time == 9) then
//				object_set_permutation (num, "","9");
//		end		
//		
//	until (1 == 0, 30 * loop_time);
//
//end
//
//script static void set_cryo_clock_num_min_10(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	current_time = init;
//	
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start minutes tens" ), 1 );
//	current_time = current_time + 1;
//	
//	if (current_time == 0 or current_time == 6) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			NotifyLevel( "start hours ones" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end
//	
//	// clock loop
//	repeat 
//		current_time = current_time + 1;
//
//		if (current_time == 0 or current_time == 6) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				NotifyLevel( "start hours ones" );
//		end
//		
//		if (current_time == 1) then
//				object_set_permutation (num, "","1");
//		end
//		
//		if (current_time == 2) then
//				object_set_permutation (num, "","2");
//		end
//		
//		if (current_time == 3) then
//				object_set_permutation (num, "","3");
//		end
//
//		if (current_time == 4) then
//				object_set_permutation (num, "","4");
//		end
//		
//		if (current_time == 5) then
//				object_set_permutation (num, "","5");
//		end
//			
//	until (1 == 0, 30 * loop_time);
//
//end
//
//script static void set_cryo_clock_num_hour_1(object num, long loop_time, short init, short ten_accum_init)
//	
//	static short current_time = 0;
//	static short ten_accum = 0;
//	static short loop_accum = 0;
//		
//	current_time = init;
//	ten_accum = ten_accum_init;
//
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start hours ones" ), 1 );
//	current_time = current_time + 1;
//	
//	if (current_time == 0 or current_time == 10) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			ten_accum = ten_accum + 1;
//			NotifyLevel( "start hours tens" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			if (ten_accum == 2) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				ten_accum = 0;
//				NotifyLevel( "start hours tens" );
//			else
//				object_set_permutation (num, "","4");
//			end		
//	end
//	
//	if (current_time == 5 ) then
//			object_set_permutation (num, "","5");
//	end
//	
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end
//	
//	if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end
//
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end		
//			
//	// clock loop
//	repeat 
//		loop_accum = loop_accum + 1;
//		
//		if (loop_accum == loop_time) then
//			loop_accum = 0;
//			current_time = current_time + 1;
//		
//			if (current_time == 0 or current_time == 10) then
//					object_set_permutation (num, "","0");
//					current_time = 0;
//					ten_accum = ten_accum + 1;
//					NotifyLevel( "start hours tens" );
//			end
//			
//			if (current_time == 1) then
//					object_set_permutation (num, "","1");
//			end
//			
//			if (current_time == 2) then
//					object_set_permutation (num, "","2");
//			end
//			
//			if (current_time == 3) then
//					object_set_permutation (num, "","3");
//			end
//	
//			if (current_time == 4) then
//					if (ten_accum == 2) then
//						object_set_permutation (num, "","0");
//						current_time = 0;
//						ten_accum = 0;
//						NotifyLevel( "start hours tens" );
//					else
//						object_set_permutation (num, "","4");
//					end		
//			end
//			
//			if (current_time == 5 ) then
//					object_set_permutation (num, "","5");
//			end
//			
//			if (current_time == 6) then
//					object_set_permutation (num, "","6");
//			end
//			
//			if (current_time == 7) then
//					object_set_permutation (num, "","7");
//			end
//			
//			if (current_time == 8) then
//					object_set_permutation (num, "","8");
//			end
//	
//			if (current_time == 9) then
//					object_set_permutation (num, "","9");
//			end			
//		end	
//	until (1 == 0, 30);
//
//end
//
//script static void set_cryo_clock_num_hour_10(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	static short loop_accum = 0;
//	current_time = init;
//
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start hours tens" ), 1 );
//	current_time = current_time + 1;
//	
//	if (current_time == 0 or current_time == 3) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			NotifyLevel( "start days ones" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//			
//	// clock loop
//	repeat 
//		loop_accum = loop_accum + 1;
//
//		if (loop_accum == loop_time) then
//			loop_accum = 0;			
//			current_time = current_time + 1;
//	
//			if (current_time == 0 or current_time == 3) then
//					object_set_permutation (num, "","0");
//					current_time = 0;
//					NotifyLevel( "start days ones" );
//			end
//			
//			if (current_time == 1) then
//					object_set_permutation (num, "","1");
//			end
//			
//			if (current_time == 2) then
//					object_set_permutation (num, "","2");
//			end
//		end
//	until (1 == 0, 30);
//
//end
//
//script static void set_cryo_clock_num_day_1(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	static short loop_accum = 0;
//	current_time = init;
//
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start days ones" ), 1 );
//	current_time = current_time + 1;
//	
//	if (current_time == 0 or current_time == 10) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			NotifyLevel( "start days tens" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","4");
//	end
//	
//	if (current_time == 5) then
//			object_set_permutation (num, "","5");
//	end
//	
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end
//	
//	if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end
//
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end		
//	// clock loop
//	repeat 
//		loop_accum = loop_accum + 1;
//		
//		if (loop_accum == loop_time) then
//			loop_accum = 0;
//			current_time = current_time + 1;
//	
//			if (current_time == 0 or current_time == 10) then
//					object_set_permutation (num, "","0");
//					current_time = 0;
//					NotifyLevel( "start days tens" );
//			end
//			
//			if (current_time == 1) then
//					object_set_permutation (num, "","1");
//			end
//			
//			if (current_time == 2) then
//					object_set_permutation (num, "","2");
//			end
//			
//			if (current_time == 3) then
//					object_set_permutation (num, "","3");
//			end
//	
//			if (current_time == 4) then
//					object_set_permutation (num, "","4");
//			end
//			
//			if (current_time == 5) then
//					object_set_permutation (num, "","5");
//			end
//			
//			if (current_time == 6) then
//					object_set_permutation (num, "","6");
//			end
//			
//			if (current_time == 7) then
//					object_set_permutation (num, "","7");
//			end
//			
//			if (current_time == 8) then
//					object_set_permutation (num, "","8");
//			end
//	
//			if (current_time == 9) then
//					object_set_permutation (num, "","9");
//			end
//		end	
//	until (1 == 0, 30);
//
//end
//
//script static void set_cryo_clock_num_day_10(object num, long loop_time, short init, short ten_accum_init)
//	
//	static short current_time = 0;
//	static short loop_accum = 0;
//	current_time = init;
//	
//	static short ten_accum = 0;
//	ten_accum = ten_accum_init;
//	
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start days tens" ), 1 );
//	current_time = current_time + 1;
//
//	if (current_time == 0 or current_time == 10) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//			ten_accum = ten_accum + 1;
//			NotifyLevel( "start days hundreds" );
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//	
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//
//	if (current_time == 4) then
//			object_set_permutation (num, "","0");
//	end
//	
//	if (current_time == 5 ) then
//			if (ten_accum == 36) then
//				object_set_permutation (num, "","0");
//				current_time = 0;
//				ten_accum = 0;
//				NotifyLevel( "start days hundreds" );
//			else
//				object_set_permutation (num, "","5");
//			end		
//	end
//	
//	if (current_time == 6) then
//			object_set_permutation (num, "","6");
//	end
//	
//	if (current_time == 7) then
//			object_set_permutation (num, "","7");
//	end
//	
//	if (current_time == 8) then
//			object_set_permutation (num, "","8");
//	end
//
//	if (current_time == 9) then
//			object_set_permutation (num, "","9");
//	end		
//
//	// clock loop
//	repeat 
//		loop_accum = loop_accum + 1;
//
//		if (loop_accum == loop_time) then
//				loop_accum = 0;		
//				current_time = current_time + 1;
//		
//				if (current_time == 0 or current_time == 10) then
//						object_set_permutation (num, "","0");
//						current_time = 0;
//						ten_accum = ten_accum + 1;
//						NotifyLevel( "start days hundreds" );
//				end
//				
//				if (current_time == 1) then
//						object_set_permutation (num, "","1");
//				end
//				
//				if (current_time == 2) then
//						object_set_permutation (num, "","2");
//				end
//				
//				if (current_time == 3) then
//						object_set_permutation (num, "","3");
//				end
//		
//				if (current_time == 4) then
//						object_set_permutation (num, "","0");
//				end
//				
//				if (current_time == 5 ) then
//						if (ten_accum == 36) then
//							object_set_permutation (num, "","0");
//							current_time = 0;
//							ten_accum = 0;
//							NotifyLevel( "start days hundreds" );
//						else
//							object_set_permutation (num, "","5");
//						end		
//				end
//				
//				if (current_time == 6) then
//						object_set_permutation (num, "","6");
//				end
//				
//				if (current_time == 7) then
//						object_set_permutation (num, "","7");
//				end
//				
//				if (current_time == 8) then
//						object_set_permutation (num, "","8");
//				end
//		
//				if (current_time == 9) then
//						object_set_permutation (num, "","9");
//				end		
//			end
//	until (1 == 0, 30);
//
//end
//
//script static void set_cryo_clock_num_day_100(object num, long loop_time, short init)
//	
//	static short current_time = 0;
//	static short loop_accum = 0;
//
//	current_time = init;
//
//	// set up the first time through	
//	sleep_until( LevelEventStatus( "start days hundreds" ), 1 );
//	current_time = current_time + 1;
//
//	if (current_time == 0 or current_time == 3) then
//			object_set_permutation (num, "","0");
//			current_time = 0;
//	end
//	
//	if (current_time == 1) then
//			object_set_permutation (num, "","1");
//	end
//	
//	if (current_time == 2) then
//			object_set_permutation (num, "","2");
//	end
//
//	if (current_time == 3) then
//			object_set_permutation (num, "","3");
//	end
//					
//	repeat 
//		loop_accum = loop_accum + 1;
//		
//		if (loop_accum == loop_time) then
//			loop_accum = 0;
//			current_time = current_time + 1;
//	
//			if (current_time == 0 or current_time == 3) then
//					object_set_permutation (num, "","0");
//					current_time = 0;
//			end
//			
//			if (current_time == 1) then
//					object_set_permutation (num, "","1");
//			end
//			
//			if (current_time == 2) then
//					object_set_permutation (num, "","2");
//			end
//	
//			if (current_time == 3) then
//					object_set_permutation (num, "","3");
//			end		
//		end	
//	until (1 == 0, 30);
//
//end