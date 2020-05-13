//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// MISSION
// =================================================================================================
// =================================================================================================
// defines

// --- zone indexes
global short DEF_S_ZONESET_INFINITY 																				= 0;
global short DEF_S_ZONESET_INFINITY_EXT 																		= 1;
global short DEF_S_ZONESET_SPIRE_01_EXT 																		= 2;
global short DEF_S_ZONESET_SPIRE_01_INT_A 																	= 3;
global short DEF_S_ZONESET_SPIRE_01_INT_B 																	= 4;
global short DEF_S_ZONESET_SPIRE_02_EXT 																		= 5;
global short DEF_S_ZONESET_SPIRE_02_INT_A 																	= 6;
global short DEF_S_ZONESET_SPIRE_02_INT_B 																	= 7;
global short DEF_S_ZONESET_SPIRE_03_EXT 																		= 8;
global short DEF_S_ZONESET_SPIRE_03_INT_A 																	= 9;
global short DEF_S_ZONESET_SPIRE_03_INT_B 																	= 10;
global short DEF_S_ZONESET_SPIRE_03_INT_C 																	= 11;
global short DEF_S_ZONESET_SPIRE_03_INT_D 																	= 12;
global short DEF_S_ZONESET_SPIRE_03_EXIT 																		= 13;
global short DEF_S_ZONESET_CIN_M070_LIFTOFF																	= 14;
global short DEF_S_ZONESET_CIN_M072_END																			= 15;

// variables
global boolean b_mission_started 					= FALSE;

// --- Debug Options
global boolean b_debug 										= FALSE;
global boolean b_game_emulate							= FALSE;
//global boolean b_encounters 							= TRUE;
//global boolean b_editor 									= editor_mode();

// XXX NOT SURE WHERE THESE GO
global short s_elevator_go = 0;
global short s_mall_hit = 0;
global short s_stores_hit = 0;
global short s_gap_hit = 0;
global short s_arc_hit = 0;
global short s_relay_hit = 0;
global string_id s_id_first_sp01_first = "pm_obj_02";
global string_id s_id_second_sp02 = "pm_obj_03";



// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// variables

// functions
script startup mission_startup()
	dprint( "::: M70 - LIFTOFF :::" );

	if ( b_game_emulate or (not editor_mode()) ) then
		fade_out( 0, 0, 0, 0 );
	end

	if ( b_game_emulate or (not editor_mode()) ) then
	
		// in editor mode make sure the players are there to start
		if ( editor_mode() ) then
			f_insertion_playerwait();
		end

		// run start function
		start();
		
		sleep_until( b_mission_started, 1);
		fade_in( 0, 0, 0, (0.50 * 30) );
	end
	
	// wait for the game to start
	sleep_until( b_mission_started, 1 );
	
	
	
	// display difficulty
	print_difficulty(); 
	
end

script static void f_spire_objectives_set_string()
	sleep_until(S_SPIRE_FIRST != 0, 1);
	
	if f_check_first_spire(DEF_SPIRE_01) then
		objectives_set_string(1, pm_obj_02);
		objectives_set_string(2, pm_obj_03);
	elseif f_check_first_spire(DEF_SPIRE_02) then
		objectives_set_string(1, pm_obj_03);
		objectives_set_string(2, pm_obj_02);
	end
end

//PELICAN
global vehicle g_vehicle_pelican = inf_pelican_gunship;
global object_name v_pelican_active = inf_pelican_gunship;
global player p_pelican_pilot = player0();
global boolean b_pelican_open = TRUE;

script continuous f_pelican_get_active()
	dprint("f_pelican_get_active");
		sleep_until(object_valid(inf_pelican_gunship) or object_valid(flight_pelican_sp01) or object_valid(flight_pelican_sp02), 1);
		//SET VARIABLES
		if object_valid(inf_pelican_gunship) then
			g_vehicle_pelican = inf_pelican_gunship;
			v_pelican_active = inf_pelican_gunship;
			
		elseif object_valid(flight_pelican_sp01) then
			g_vehicle_pelican = flight_pelican_sp01;
			v_pelican_active = flight_pelican_sp01;
			
		elseif object_valid(flight_pelican_sp02) then
			g_vehicle_pelican = flight_pelican_sp02;
			v_pelican_active = flight_pelican_sp02;
			
		end

		//if b_pelican_open then
		//	f_pelican_disable_extra_seats(g_vehicle_pelican);
		//else
		//	vehicle_set_player_interaction(g_vehicle_pelican, "" , FALSE, FALSE);
		//end
		sleep_until(not object_valid(v_pelican_active), 1);
end

script static void f_pelican_disable_extra_seats( vehicle vehicle_pelican, object_name obj_pelican)
	dprint("f_pelican_disable_extra_seats");
	sleep_until(object_valid(obj_pelican) ,1);
	b_pelican_open = TRUE;
	vehicle_set_player_interaction(vehicle_pelican, "" , TRUE, TRUE);
	if game_is_cooperative() then
		thread(f_pelican_disable_seats_coop(vehicle_pelican));
	else
		thread(f_pelican_disable_seats_single_player(vehicle_pelican));
	end
end

script static void f_pelican_disable_seats_coop(vehicle vehicle_pelican)
		dprint("f_pelican_disable_passenger_seats");
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_l01", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_l02", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_l03", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_l04", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_l05", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r01", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r02", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r03", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r03", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r04", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r05", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_p_r", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_lc", FALSE, TRUE);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_e", FALSE, TRUE);
end		

script static void f_pelican_disable_seats_single_player(vehicle vehicle_pelican)
		dprint("f_pelican_disable_coop_seats");
		vehicle_set_player_interaction(vehicle_pelican, "", FALSE, TRUE);
		sleep(10);
		vehicle_set_player_interaction(vehicle_pelican, "pelican_d", TRUE, TRUE);
end


script static void f_flight_set_pilot(vehicle v_pelican)
dprint("f_flight_set_pilot");
	if vehicle_test_seat_unit(v_pelican, "pelican_d", player0()) then
		p_pelican_pilot = player0();
		dprint("pilot_set player 0");	
	elseif vehicle_test_seat_unit(v_pelican, "pelican_d", player1()) then
		p_pelican_pilot = player1();
		dprint("pilot_set player 1");	
	elseif vehicle_test_seat_unit(v_pelican, "pelican_d", player2()) then
		p_pelican_pilot = player2();
		dprint("pilot_set player 2");	
	elseif vehicle_test_seat_unit(v_pelican, "pelican_d", player3()) then
		p_pelican_pilot = player3();
		dprint("pilot_set player 3");	
	end
end
//vehicle_test_seat(inf_pelican_gunship, "pelican_d")

//===
//camera shakes
//camera_shake_player (player actor, real attack, real intensity, short duration, real deca
script static void shake()
	camera_shake_player	(player0, 0.4, 0.4, 0, 1, m70_camera_shake_medium);
end


script static void f_camera_shake_strong(player p_player)
	camera_shake_player	(p_player, 1, 1, 2, 2, m70_camera_shake_strong);
end

script static void f_camera_shake_weak(player p_player)
	camera_shake_player	(p_player, 1, 1, 1, 1, m70_camera_shake_weak);
end

script static void f_camera_shake_gondola(player p_player)
	camera_shake_player	(p_player, 0.1, 0.1, 0, 1, gondola_camera_shake);

end

script static void test_player()
	dprint("START INFINITE VOLUME TEST LOOP");
	repeat
	//tv_spire01_gondola
	//tv_gondola_player_effect
		if volume_test_object(tv_spire01_gondola, player0) then
			dprint("PLAYER IN VOLUME");
		else
			dprint("PLAYER OUT VOLUME");
		end
	until(1 == 0, 1);
end

script static void f_rumble_gondola(player p_player)
	local boolean b_rumble_valid	 = TRUE;
	local boolean b_rumble_active	 = FALSE;
	local boolean b_rumble_break 	 = FALSE;
	local short rumble_count 			 = 0;
	local short rumble_count_max 	 = 10;
	
	repeat			
		if volume_test_object(tv_gondola_path, p_player) and b_rumble_valid  then
			rumble_count = rumble_count + 1;
			inspect(	rumble_count );
			if rumble_count >= rumble_count_max then
				b_rumble_valid = FALSE;
			end
				
			if not b_rumble_active then
				dprint("RUMBLE ON");
				player_effect_set_max_rumble_for_player(p_player, 0.1, 0.1);
				b_rumble_active = TRUE;
			end
				
		elseif not volume_test_object(tv_gondola_path, p_player) or not b_rumble_valid then
			
			dprint("RUMBLE OFF");
			player_effect_set_max_rumble_for_player(p_player, 0, 0);
			b_rumble_active = FALSE;
			
			if rumble_count >= rumble_count_max then
				sleep_s(1.5);
				rumble_count = 0;
				b_rumble_valid = TRUE;
			end
			
		end
			sleep_s(1);
			
	until(not sp01_gondola_moving, 1);
	player_effect_set_max_rumble_for_player(p_player, 0, 0);
end


script static void f_camera_shake_emp_hit(player p_player ) 
	camera_shake_player	(p_player, 0.2, 0.2, 0, 1.5, emp_hit_camera_shake);
	player_effect_set_max_rumble_for_player(p_player, 0.8, 0.8);
	sleep_s(0.25);
	player_effect_set_max_rumble_for_player(p_player, 0, 0);
end

script static void f_camera_shake_emp_pop(player p_player ) 
	camera_shake_player	(p_player, 0.7, 0.7, 0, 1, emp_pop_camera_shake);
	player_effect_set_max_rumble_for_player(p_player, 1, 1);
	sleep_s(1);
	player_effect_set_max_rumble_for_player(p_player, 0, 0);
end

//continuous
//static void


script static boolean f_pelican_on_landing_pad(object_name obj_pelican)
	not volume_test_object( tv_flight_spire_01_pilot_valid, obj_pelican) and
	not volume_test_object(tv_flight_spire_02_pilot_valid , obj_pelican) and
	not volume_test_object( tv_flight_spire_03_pilot_valid, obj_pelican);
end


//f_test_pelican_teleport(flight_pelican_sp01, flight_pelican_sp01)
script static void f_test_pelican_teleport(object_name obj_pelican, vehicle v_pelican)
		dprint("f_test_pelican_teleport");
		if object_valid(obj_pelican) and not f_pelican_on_landing_pad(obj_pelican) then
		dprint("check pelican not in seat");
			if player_in_vehicle(v_pelican) and not vehicle_test_seat_unit_list(v_pelican, "pelican_d", players()) then
				fade_out(0, 0, 0, 1);
				object_cannot_take_damage(obj_pelican);
				object_cannot_take_damage(players()); 
				player_control_fade_out_all_input(1);
				vehicle_load_magic(v_pelican, "pelican_d", player_get_first_valid());
				sleep_s(1);
				player_control_fade_in_all_input(1.5);
				fade_in(0, 0, 0, 2);
				sleep_s(1);
				object_can_take_damage(obj_pelican);
				object_can_take_damage(players()); 
			end
		end
end

//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
global short s_player_count = 0;
global long s_drop_protection_thread = 0;

script static void f_pelican_drop_protection() 
	repeat
		s_player_count = game_coop_player_count();
	
		repeat
		sleep(5);
		until(s_player_count > game_coop_player_count(), 1);
	
	//	sleep_until( s_player_count > game_coop_player_count(), 1);
	
		if f_Flight_Zone_current_zoneset() then
			f_test_pelican_teleport(inf_pelican_gunship, inf_pelican_gunship);
			f_test_pelican_teleport(flight_pelican_sp01, flight_pelican_sp01);
			f_test_pelican_teleport(flight_pelican_sp02, flight_pelican_sp02);
		end
	
	until(not f_Flight_Zone_current_zoneset(), 1);
end



script static void f_flight_eject_players()

	if unit_in_vehicle(player0()) then
		unit_exit_vehicle(player0(), 0);
	end
	
	if unit_in_vehicle(player1()) then
		unit_exit_vehicle(player1(), 0);
	end
	
	if unit_in_vehicle(player2()) then
		unit_exit_vehicle(player2(), 0);
	end
	
	if unit_in_vehicle(player3()) then
		unit_exit_vehicle(player3(), 0);
	end
	
	if object_valid(inf_pelican_gunship) then
		vehicle_set_player_interaction(inf_pelican_gunship, "" , FALSE, FALSE);
	end
	
	if object_valid(flight_pelican_sp01) then
		vehicle_set_player_interaction(flight_pelican_sp01, "" , FALSE, FALSE);
	end
	
	if object_valid(flight_pelican_sp02) then
		vehicle_set_player_interaction(flight_pelican_sp02, "" , FALSE, FALSE);
	end
	
end