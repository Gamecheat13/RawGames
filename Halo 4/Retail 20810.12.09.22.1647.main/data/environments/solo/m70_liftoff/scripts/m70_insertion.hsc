//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
// NOTE: 	Several of the functions used in m10_crash_insertion use global_insertion.hsc.
//				You can find documentation in that file on how to setup your insertion script
//				so you can use the library of script functions to streamline your insertion script.

// =================================================================================================
// =================================================================================================
// *** INSERTIONS ***
// =================================================================================================
// =================================================================================================
// defines
// --- insertion indexes
global short DEF_INSERTION_INDEX_CINEMATIC_OPEN															= 0;
global short DEF_INSERTION_INDEX_INFINITY																		= 1;
global short DEF_INSERTION_INDEX_FLIGHT																			= 2;
global short DEF_INSERTION_INDEX_SPIRE_01																		= 3;
global short DEF_INSERTION_INDEX_SPIRE_02																		= 4;
global short DEF_INSERTION_INDEX_SPIRE_03																		= 5;
global short DEF_INSERTION_INDEX_LICH																				= 6;
global short DEF_INSERTION_INDEX_CINEMATIC_END															= 7;
global short DEF_INSERTION_INDEX_FLIGHT_2_1																	= 8;
global short DEF_INSERTION_INDEX_FLIGHT_2_2																	= 9;
global short DEF_INSERTION_INDEX_FLIGHT_3_1																	= 10;
global short DEF_INSERTION_INDEX_FLIGHT_3_2																	= 11;
global short DEF_INSERTION_INDEX_FAIL																				= 12;
//xxx
global short DEF_INSERTION_INDEX_FAIL2																			= 13;

// variables

// functions
// -------------------------------------------------------------------------------------------------
// START
// -------------------------------------------------------------------------------------------------
script static void start()
	//dprint( "::: start :::" );

	f_insertion_index_load( game_insertion_point_get() );

end

// -------------------------------------------------------------------------------------------------
// CINEMATIC
// -------------------------------------------------------------------------------------------------
script static void icno()
	f_insertion_reset( DEF_INSERTION_INDEX_CINEMATIC_OPEN );
end

script static void ins_cinematic_open()

	f_insertion_begin( "CINEMATIC OPEN" );
	f_cinematic_open();
	dprint("START INFINITY INSERTION");
	// start the infinity insertion point
	ins_infinity();
	
end


// -------------------------------------------------------------------------------------------------
// INFINITY
// -------------------------------------------------------------------------------------------------
script static void iinf()
	f_insertion_reset( DEF_INSERTION_INDEX_INFINITY );
end

script static void ins_infinity()

	f_insertion_begin( "INFINITY" );
	f_insertion_zoneload( DEF_S_ZONESET_INFINITY, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_infinity.p0, ps_insertion_infinity.p1, ps_insertion_infinity.p2, ps_insertion_infinity.p3 );
	f_insertion_playerprofile( profile_infinity, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( <OBJECTIVE_INDEX>, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	// XXX_TODO
	
	wake( f_dlg_infinity_start );
	
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT STATE START
// -------------------------------------------------------------------------------------------------
script static void iflt()
	f_insertion_reset( DEF_INSERTION_INDEX_FLIGHT );
end

script static void ins_flight()
	b_flight_insertion = TRUE;
	
	f_insertion_begin( "FLIGHT_START" );
	f_insertion_zoneload( DEF_S_ZONESET_INFINITY, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_flight.p0, ps_insertion_flight.p1, ps_insertion_flight.p2, ps_insertion_flight.p3 );
	f_insertion_playerprofile( profile_flight, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	wake( f_infinity_pelican_launch_lower );

	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT STATE SECOND COMPLETED SPIRE 1
// -------------------------------------------------------------------------------------------------
script static void iflt2_1()
	f_insertion_reset( DEF_INSERTION_INDEX_FLIGHT_2_1 );
end

script static void ins_flight_2_1()

	f_insertion_begin( "FLIGHT_SECOND_SPIRE" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_01_EXT, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_flight_spire_01.p0, ps_insertion_flight_spire_01.p1, ps_insertion_flight_spire_01.p2, ps_insertion_flight_spire_01.p3 );
	f_insertion_playerprofile( profile_flight, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	S_SPIRE_FIRST = DEF_SPIRE_01;
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE());
	f_objective_set( DEF_R_OBJECTIVE_FLIGHT_SPIRE_01(), TRUE, TRUE, TRUE, TRUE);
	thread( f_spire01_exit() );

	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT STATE SECOND SPIRE COMPLETED SPIRE 2
// -------------------------------------------------------------------------------------------------
script static void iflt2_2()
	f_insertion_reset( DEF_INSERTION_INDEX_FLIGHT_2_2 );
end

script static void ins_flight_2_2()

	f_insertion_begin( "FLIGHT_SECOND_SPIRE" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_02_EXT, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_flight_spire_02.p0, ps_insertion_flight_spire_02.p1, ps_insertion_flight_spire_02.p2, ps_insertion_flight_spire_02.p3 );
	f_insertion_playerprofile( profile_flight, FALSE );
	f_insertion_end();
	
	
	// forces setup of mission functions to put game into proper state
	S_SPIRE_FIRST = DEF_SPIRE_02;
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE());
	f_objective_set( DEF_R_OBJECTIVE_FLIGHT_SPIRE_02(), TRUE, TRUE, TRUE, TRUE);
	thread( f_spire_02_exit() );
	//wake( f_flight_main );

	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT STATE SPIRE 3 COMPLETED SPIRE 1
// -------------------------------------------------------------------------------------------------
script static void iflt3_1()
	f_insertion_reset( DEF_INSERTION_INDEX_FLIGHT_3_1 );
end

script static void ins_flight_3_1()

	f_insertion_begin( "FLIGHT_THIRD_SPIRE" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_01_EXT, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_flight_spire_01.p0, ps_insertion_flight_spire_01.p1, ps_insertion_flight_spire_01.p2, ps_insertion_flight_spire_01.p3 );
	f_insertion_playerprofile( profile_flight, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	music_start('Play_mus_m70');
	b_m70_music_progression = 10;
	
	S_SPIRE_FIRST = DEF_SPIRE_02;
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE());
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE());
	f_objective_set( DEF_R_OBJECTIVE_FLIGHT_SPIRE_03(), TRUE, TRUE, TRUE, TRUE);
	thread(f_spire01_exit());

	//wake( f_flight_main );
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT STATE SPIRE 3 COMPLETED SPIRE 2
// -------------------------------------------------------------------------------------------------
script static void iflt3_2()
	f_insertion_reset( DEF_INSERTION_INDEX_FLIGHT_3_2 );
end

script static void ins_flight_3_2()
	
	f_insertion_begin( "FLIGHT_THIRD_SPIRE" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_02_EXT, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_flight_spire_02.p0, ps_insertion_flight_spire_02.p1, ps_insertion_flight_spire_02.p2, ps_insertion_flight_spire_02.p3 );
	f_insertion_playerprofile( profile_flight, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	S_SPIRE_FIRST = DEF_SPIRE_01;
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE());
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE());
	f_objective_set( DEF_R_OBJECTIVE_FLIGHT_SPIRE_03(), TRUE, TRUE, TRUE, TRUE);
	thread( f_spire_02_exit() );

	//wake( f_flight_main );
	
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// SPIRE 01
// -------------------------------------------------------------------------------------------------
script static void is01()
	f_insertion_reset( DEF_INSERTION_INDEX_SPIRE_01 );
end

// RALLY POINT BRAVO
script static void ins_spire01()

	f_insertion_begin( "SPIRE 01" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_01_INT_B, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_spire_01.p0, ps_insertion_spire_01.p1, ps_insertion_spire_01.p2, ps_insertion_spire_01.p3 );
	f_insertion_playerprofile( profile_spire_01, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( <OBJECTIVE_INDEX>, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	music_start('Play_mus_m70');
	b_m70_music_progression = 40;
	//f_spire_01_state_set( DEF_SPIRE_STATE_INTERIOR_OBJECTIVE );
	
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_INTERIOR_START());
	// XXX_TODO
	device_set_power(dm_sp01_int_door_01, 0);
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// SPIRE 02
// -------------------------------------------------------------------------------------------------
script static void is02()
	f_insertion_reset( DEF_INSERTION_INDEX_SPIRE_02 );
end

// RALLY POINT CHARLIE
script static void ins_spire02()
	zone_set_trigger_volume_enable("begin_zone_set:spire_1_exterior", FALSE);
	zone_set_trigger_volume_enable("zone_set:spire_1_exterior", FALSE);
	f_insertion_begin( "SPIRE 02" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_02_INT_B, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_spire_02.p0, ps_insertion_spire_02.p1, ps_insertion_spire_02.p2, ps_insertion_spire_02.p3 );
	f_insertion_playerprofile( profile_spire_02, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( <OBJECTIVE_INDEX>, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	music_start('Play_mus_m70');
	b_m70_music_progression = 60;
	//f_spire_02_state_set( DEF_SPIRE_STATE_INTERIOR_OBJECTIVE );
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE());
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_INTERIOR_START());
	// XXX_TODO
	device_set_power(dm_sp02_int_door_01, 0);
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// SPIRE 03
// -------------------------------------------------------------------------------------------------
script static void is03()
	f_insertion_reset( DEF_INSERTION_INDEX_SPIRE_03 );
end

// RALLY POINT DELTA
script static void ins_spire03()

	f_insertion_begin( "SPIRE 03" );
	f_insertion_zoneload( DEF_S_ZONESET_SPIRE_03_INT_A, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_spire_03.p0, ps_insertion_spire_03.p1, ps_insertion_spire_03.p2, ps_insertion_spire_03.p3 );
	f_insertion_playerprofile( profile_spire_03, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( <OBJECTIVE_INDEX>, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	music_start('Play_mus_m70');
	b_m70_music_progression = 80;
	f_spire_state_set ( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set ( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set ( DEF_SPIRE_03, DEF_SPIRE_STATE_OPEN() );
	device_set_power(dm_sp03_int_door_01, 0);
	dprint("::: INSERTION: COMPLETE" );
	
end
//=============================================================
script static void ifail()
	f_insertion_reset( DEF_INSERTION_INDEX_FAIL );
end

script static void ins_fail()

	f_insertion_begin( "FAIL" );
		f_insertion_zoneload( DEF_S_ZONESET_SPIRE_03_INT_D, FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lich.p0, ps_insertion_lich.p1, ps_insertion_lich.p2, ps_insertion_lich.p3 );
		f_insertion_playerprofile( profile_lich, FALSE );

	// setup any states before b_mission_started is set	

	f_insertion_end();

	// forces setup of mission functions to put game into proper state
	f_spire_state_set( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE() );
	
	//f_spire_state_set( DEF_SPIRE_03, DEF_SPIRE_STATE_COMPLETE() );
	
	// start the floor
	wake( f_spire_03_INT_control_room_init);
	
	dprint("::: INSERTION: COMPLETE" );
	
end

//==============================================================
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
script static void ifail2()
	f_insertion_reset( DEF_INSERTION_INDEX_FAIL2 );
end

script static void ins_fail2()

		f_insertion_begin( "FAIL" );
		f_insertion_zoneload( DEF_S_ZONESET_SPIRE_03_INT_D, FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lich.p0, ps_insertion_lich.p1, ps_insertion_lich.p2, ps_insertion_lich.p3 );
		f_insertion_playerprofile( profile_lich, FALSE );

	// setup any states before b_mission_started is set	

	f_insertion_end();

	// forces setup of mission functions to put game into proper state
	f_spire_state_set( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE() );
	
	//f_spire_state_set( DEF_SPIRE_03, DEF_SPIRE_STATE_COMPLETE() );

	
	dprint("::: INSERTION: COMPLETE" );
	
end
//================================================================
// -------------------------------------------------------------------------------------------------
// LICH
// -------------------------------------------------------------------------------------------------
script static void ilch()
	f_insertion_reset( DEF_INSERTION_INDEX_LICH );
end

script static void ins_lich()

	f_insertion_begin( "LICH" );
		f_insertion_zoneload( DEF_S_ZONESET_SPIRE_03_INT_D, FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lich.p0, ps_insertion_lich.p1, ps_insertion_lich.p2, ps_insertion_lich.p3 );
		f_insertion_playerprofile( profile_lich, FALSE );

	// setup any states before b_mission_started is set	

	f_insertion_end();

	// forces setup of mission functions to put game into proper state
	f_spire_state_set( DEF_SPIRE_01, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set( DEF_SPIRE_02, DEF_SPIRE_STATE_COMPLETE() );
	f_spire_state_set( DEF_SPIRE_03, DEF_SPIRE_STATE_COMPLETE() );
	
	// start the floor
	wake( f_spire_03_INT_control_room_floor_init );
	wake( f_dlg_spire_03_outro_01 );
	
	dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// CINEMATIC END
// -------------------------------------------------------------------------------------------------
script static void icne()
	f_insertion_reset( DEF_INSERTION_INDEX_CINEMATIC_END );
end

script static void ins_cinematic_end()

	f_insertion_begin( "CINEMATIC CLOSE" );
	f_cinematic_close();
	
end



// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================
// -------------------------------------------------------------------------------------------------
// INSERTION LOAD INDEX
// -------------------------------------------------------------------------------------------------
script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	//dprint( "::: f_insertion_index_load :::" );
	inspect( game_insertion_point_get() );
	
	if (s_insertion == DEF_INSERTION_INDEX_CINEMATIC_OPEN) then
		b_started = TRUE;
		ins_cinematic_open();
	end
	if (s_insertion == DEF_INSERTION_INDEX_INFINITY) then
		b_started = TRUE;
		ins_infinity();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLIGHT) then
		b_started = TRUE;
		ins_flight();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLIGHT_2_1) then
		b_started = TRUE;
		ins_flight_2_1();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLIGHT_2_2) then
		b_started = TRUE;
		ins_flight_2_2();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLIGHT_3_1) then
		b_started = TRUE;
		ins_flight_3_1();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLIGHT_3_2) then
		b_started = TRUE;
		ins_flight_3_2();
	end
	if (s_insertion == DEF_INSERTION_INDEX_SPIRE_01) then
		b_started = TRUE;
		ins_spire01();
	end
	if (s_insertion == DEF_INSERTION_INDEX_SPIRE_02) then
		b_started = TRUE;
		ins_spire02();
	end
	if (s_insertion == DEF_INSERTION_INDEX_SPIRE_03) then
		b_started = TRUE;
		ins_spire03();
	end
	if (s_insertion == DEF_INSERTION_INDEX_LICH) then
		b_started = TRUE;
		ins_lich();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FAIL) then
		b_started = TRUE;
		ins_fail();
	end
	//xxx
	if (s_insertion == DEF_INSERTION_INDEX_FAIL2) then
		b_started = TRUE;
		ins_fail2();
	end
	
	if (s_insertion == DEF_INSERTION_INDEX_CINEMATIC_END) then
		b_started = TRUE;
		ins_cinematic_end();
	end

	if ( not b_started ) then
		dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		inspect( s_insertion );
	end

end

// -------------------------------------------------------------------------------------------------
// ZONE SET GET
// -------------------------------------------------------------------------------------------------
script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "00_infinity";

	if ( s_index == DEF_S_ZONESET_INFINITY ) then
	 zs_return = "00_infinity";
	end
	if ( s_index == DEF_S_ZONESET_INFINITY_EXT ) then
	 zs_return = "00_infinity_exterior";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_01_EXT ) then
	 zs_return = "spire_1_exterior";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_01_INT_A ) then
	 zs_return = "spire_1_interior_a";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_01_INT_B ) then
	 zs_return = "spire_1_interior_b";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_02_EXT ) then
	 zs_return = "spire_2_exterior";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_02_INT_A ) then
	 zs_return = "spire_2_interior_a";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_02_INT_B ) then
	 zs_return = "spire_2_interior_b";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_EXT ) then
	 zs_return = "spire_3_exterior";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_INT_A ) then
	 zs_return = "spire_3_interior_a";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_INT_B ) then
	 zs_return = "spire_3_interior_b";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_INT_C ) then
	 zs_return = "spire_3_interior_c";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_INT_D ) then
	 zs_return = "spire_3_interior_d";
	end
	if ( s_index == DEF_S_ZONESET_SPIRE_03_EXIT ) then
	 	zs_return = "spire_3_exit";
	end
	if ( s_index == DEF_S_ZONESET_CIN_M070_LIFTOFF ) then
	 	zs_return = "cin_m070_liftoff";
	end
	if ( s_index == DEF_S_ZONESET_CIN_M072_END ) then
	 	zs_return = "cin_m072_end";
	end

	// return
	zs_return;
end
