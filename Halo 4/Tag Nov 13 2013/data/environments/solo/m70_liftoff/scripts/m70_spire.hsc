//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
// =================================================================================================
// =================================================================================================
// spire
// =================================================================================================
// =================================================================================================

//================================
// SPIRE_VARIABLES
//================================

global real R_spire_01_state = DEF_SPIRE_STATE_DORMANT();
global real R_spire_02_state = DEF_SPIRE_STATE_DORMANT();
global real R_spire_03_state = DEF_SPIRE_STATE_DORMANT();
global short S_SPIRE_FIRST 	 = 0;
global short DEF_SPIRE_01    = 1;
global short DEF_SPIRE_02    = 2;
global short DEF_SPIRE_03    = 3;

// :: DEFINES
script static real DEF_SPIRE_STATE_DORMANT() 						0.0; end
script static real DEF_SPIRE_STATE_START() 							1.0; end
script static real DEF_SPIRE_STATE_OPEN() 							2.0; end
script static real DEF_SPIRE_STATE_INTERIOR_START()		  3.0; end
script static real DEF_SPIRE_STATE_INTERIOR_COMPLETE() 	4.0; end
script static real DEF_SPIRE_STATE_COMPLETE() 					5.0; end

//================================
// SPIRE_FUNCTIONS
//================================
script startup f_spire_startup()
	sleep_until( b_mission_started, 1 );
	dprint("f_spire_startup");
	wake( f_spire_init );
end

script dormant f_spire_init()
	sleep_until( (current_zone_set_fully_active() >= DEF_S_ZONESET_INFINITY_EXT) and (current_zone_set_fully_active() <= DEF_S_ZONESET_SPIRE_03_EXIT), 1 );
	
	// initialize modules
	wake( f_spire_01_init );
	wake( f_spire_02_init );
	wake( f_spire_03_init );
end

//================================
//SPIRE_CLOSE
//================================

script static void f_spires_exit_clear_pelican()
	dprint("f_spires_exit_clear_pelicans");
	if object_valid(inf_pelican_gunship) then
		object_destroy(inf_pelican_gunship);
	end
	
	if object_valid(flight_pelican_sp01) then
		object_destroy(flight_pelican_sp01);
	end
	
	if object_valid(flight_pelican_sp02) then
		object_destroy(flight_pelican_sp02);
	end
end

script static void f_spire_exit_respawn_pelican( object_name obj_pelican, vehicle v_pelican, trigger_volume tv_pelican )
	repeat
		if not object_valid(obj_pelican) then
			object_create(obj_pelican);
			if (object_valid(obj_pelican)) then
				thread(f_pelican_disable_extra_seats( v_pelican, obj_pelican));
			end
		else
			if (object_get_health(obj_pelican) <= 0) and not volume_test_players(tv_pelican) and not volume_test_players_lookat(tv_pelican, 15, 15) then
				object_destroy(obj_pelican);
				sleep_s(1);
				object_create_anew(obj_pelican);
				thread(f_pelican_disable_extra_seats( v_pelican, obj_pelican));
				sleep_s(1);
			end
		end
	until(not volume_test_players(tv_pelican) and vehicle_test_players(), 1);
end

script static boolean vehicle_test_players()
	unit_in_vehicle(player0()) or unit_in_vehicle(player1()) or unit_in_vehicle(player2()) or unit_in_vehicle(player3());
end

script static boolean vehicle_test_players_all_old()
	unit_in_vehicle(player0) and unit_in_vehicle(player1) and unit_in_vehicle(player2) and unit_in_vehicle(player3);
end
script static boolean vehicle_test_players_all()

	( (unit_get_health(player0) <= 0.0) or unit_in_vehicle(player0) )
	and
	( (unit_get_health(player1) <= 0.0) or unit_in_vehicle(player1) )
	and
	( (unit_get_health(player2) <= 0.0) or unit_in_vehicle(player2) )
	and
	( (unit_get_health(player3) <= 0.0) or unit_in_vehicle(player3) );

end
/*
script static boolean vehicle_test_players_all()

	( (not player_valid(0)) or (unit_get_health(player0) <= 0.0) or unit_in_vehicle(player0) )
	and
	( (not player_valid(1)) or (unit_get_health(player1) <= 0.0) or unit_in_vehicle(player1) )
	and
	( (not player_valid(2)) or (unit_get_health(player2) <= 0.0) or unit_in_vehicle(player2) )
	and
	( (not player_valid(3)) or (unit_get_health(player3) <= 0.0) or unit_in_vehicle(player3) );

end
*/
//xxx 
//second test if first does not work
/*
global boolean b_vehicle_check = FALSE;
script dormant check_bool()

	repeat
		sleep_until( b_vehicle_check != test_Bool(), 1 );
		b_vehicle_check = not b_vehicle_check;
	until( FALSE, 1 );
	
end
*/
//SPIRE_STATE_CHECKS

// :: SPIRE_STATE_GET
script static real f_spire_state_get(short spire_number)
	if spire_number == 1 then
		R_spire_01_state;
	elseif spire_number == 2 then
		R_spire_02_state;
	elseif spire_number == 3 then
		R_spire_03_state;
	end
end

// :: SPIRE_STATE_CHECK_FOR_STATE
script static boolean f_spire_state_check(short spire_number, real spire_state)
	if spire_number == 1 then
		R_spire_01_state >= spire_state;
	elseif spire_number == 2 then
		R_spire_02_state >= spire_state;
	elseif spire_number == 3 then
		R_spire_03_state >= spire_state;
	end
end


// :: SPIRE_STATE_SET
script static real f_spire_state_set ( short spire_number, real r_spire_state_new)
	if spire_number == 1 then
		if ( r_spire_state_new < R_spire_01_state ) then
			r_spire_state_new = R_spire_01_state;
		end
		R_spire_01_state = r_spire_state_new;
	
	elseif spire_number == 2 then
		if ( r_spire_state_new < R_spire_02_state ) then
			r_spire_state_new = R_spire_02_state;
		end
		R_spire_02_state = r_spire_state_new;

	elseif spire_number == 3 then
		if ( r_spire_state_new < R_spire_03_state ) then
			r_spire_state_new = R_spire_03_state;
		end
		R_spire_03_state = r_spire_state_new;
	end
	r_spire_state_new;
end

// :: SPIRE_CHECK_SPIRE_STATE_ACTIVE
script static boolean f_spire_state_active(short spire_number)
	if spire_number == 1 then
		( R_spire_01_state > DEF_SPIRE_STATE_DORMANT() ) and ( R_spire_01_state < DEF_SPIRE_STATE_COMPLETE() );
	elseif spire_number == 2 then
		( R_spire_02_state > DEF_SPIRE_STATE_DORMANT() and ( R_spire_02_state < DEF_SPIRE_STATE_COMPLETE() ) );
	elseif spire_number == 3 then
		( R_spire_02_state > DEF_SPIRE_STATE_DORMANT() and ( R_spire_03_state < DEF_SPIRE_STATE_COMPLETE() ) );
	end
end

// :: SPIRE_CHECK_SPIRE_STATE_ACTIVE_ANY_SPIRES
script static boolean f_spires_state_active()
	f_spire_state_active(DEF_SPIRE_01) or f_spire_state_active(DEF_SPIRE_02) or f_spire_state_complete(DEF_SPIRE_03);
end

// :: SPIRE_CHECK_FOR_START_VALID
script static boolean f_spire_start_valid(short spire_number)
	if spire_number == DEF_SPIRE_01 then
		not f_spire_state_complete(DEF_SPIRE_01) and not f_spire_state_active(DEF_SPIRE_02);
	elseif spire_number == DEF_SPIRE_02 then
		not f_spire_state_complete(DEF_SPIRE_02) and not f_spire_state_active(DEF_SPIRE_01);
	elseif spire_number == DEF_SPIRE_03 then
		f_spire_state_complete(DEF_SPIRE_01) and f_spire_state_complete(DEF_SPIRE_02);
	end
end

// :: SPIRE_CHECK_STATE_COMPLETE
script static boolean f_spire_state_complete(short spire_number)
	if spire_number == 1 then
		( R_spire_01_state >= DEF_SPIRE_STATE_COMPLETE() );
	elseif spire_number == 2 then
		( R_spire_02_state >= DEF_SPIRE_STATE_COMPLETE() );
	elseif spire_number == 3 then
		( R_spire_03_state >= DEF_SPIRE_STATE_COMPLETE() );
	end
end

// :: SPIRE_CHECK_STATE_ANY_OPEN
script static boolean f_spires_state_open()
	f_spire_state_open(DEF_SPIRE_01) or
	f_spire_state_open(DEF_SPIRE_02) or
	f_spire_state_open(DEF_SPIRE_03);
end

// :: SPIRE_CHECK_STATE_OPEN
script static boolean f_spire_state_open(short spire_number)
	if spire_number == 1 then
		R_spire_01_state == 2;
	elseif spire_number == 2 then
		R_spire_02_state == 2;
	elseif spire_number == 3 then
		R_spire_03_state == 2;
	end
end
// :: SPIRE_GET_FIRST
script static short f_get_first_spire()
	//if 0 set first spire if not 0 then return first
	if S_SPIRE_FIRST == 0 then
		if f_spire_state_active(DEF_SPIRE_01) and not f_spire_state_complete(DEF_SPIRE_02) then 
			S_SPIRE_FIRST = DEF_SPIRE_01;
		elseif f_spire_state_active(DEF_SPIRE_02) and not f_spire_state_complete(DEF_SPIRE_01) then
			S_SPIRE_FIRST = DEF_SPIRE_02;
		end
	end
	S_SPIRE_FIRST;
end


// :: SPIRE_CHECK_FIRST
script static boolean f_check_first_spire(short spire_number)
	f_get_first_spire();
	f_get_first_spire() == spire_number;
end

// :: SPIRE_CHECK_FIRST_COMPLETE
script static boolean f_check_first_spire_complete()
	f_spire_state_complete(DEF_SPIRE_01) or f_spire_state_complete(DEF_SPIRE_02);
end

// :: SPIRE_CHECK_FIRST_AND_SECOND_COMPLETE
script static boolean f_check_both_spire_complete()
	f_spire_state_complete(DEF_SPIRE_01) and f_spire_state_complete(DEF_SPIRE_02);
end

