//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_init::: Init
script dormant f_e7_m1_ai_init()
	dprint( "f_e7_m1_ai_init" );

	// initial allignments
	ai_allegiance( covenant, forerunner );
	ai_allegiance( forerunner, covenant );

	// initialize modules
	wake( f_e7_m1_ai_areas_init );
	
	// initialize sub-modules
	wake( f_e7_m1_ai_objcon_init );
	wake( f_e7_m1_ai_turrets_init );
	
	// setup trigger
	wake ( f_e7_m1_ai_trigger );
	
end

// === f_e7_m1_ai_trigger::: Trigger
script dormant f_e7_m1_ai_trigger()
	dprint( "f_e7_m1_ai_trigger" );

	sleep_until( f_spops_mission_start_complete(), 1 );
	dprint( "f_e7_m1_ai_trigger: START COMPLETE" );
	ai_exit_limbo( ai_ff_all );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: OBJCON ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_E7_M1_AI_OBJCON_ALL()						-1.0; end
script static real DEF_E7_M1_AI_OBJCON_NONE()						999.999; end

script static real DEF_E7_M1_AI_OBJCON_START()					000.0; end

script static real DEF_E7_M1_AI_OBJCON_01()							100.0; end
script static real DEF_E7_M1_AI_OBJCON_01_A()						100.0; end

script static real DEF_E7_M1_AI_OBJCON_02()							200.0; end
script static real DEF_E7_M1_AI_OBJCON_02_A()						200.0; end
script static real DEF_E7_M1_AI_OBJCON_02_B()						225.0; end
script static real DEF_E7_M1_AI_OBJCON_02_C()						250.0; end

script static real DEF_E7_M1_AI_OBJCON_03()							300.0; end
script static real DEF_E7_M1_AI_OBJCON_03_A()						300.0; end
script static real DEF_E7_M1_AI_OBJCON_03_B()						350.0; end
script static real DEF_E7_M1_AI_OBJCON_03_C()						325.0; end

script static real DEF_E7_M1_AI_OBJCON_04()							400.0; end
script static real DEF_E7_M1_AI_OBJCON_04_A()						400.0; end
script static real DEF_E7_M1_AI_OBJCON_04_B()						425.0; end
script static real DEF_E7_M1_AI_OBJCON_04_C()						450.0; end

script static real DEF_E7_M1_AI_OBJCON_05()							500.0; end
script static real DEF_E7_M1_AI_OBJCON_05_A()						525.0; end
script static real DEF_E7_M1_AI_OBJCON_05_B()						500.0; end
script static real DEF_E7_M1_AI_OBJCON_05_C()						550.0; end

script static real DEF_E7_M1_AI_OBJCON_06()							600.0; end
script static real DEF_E7_M1_AI_OBJCON_06_A()						600.0; end

script static real DEF_E7_M1_AI_OBJCON_07()							700.0; end
script static real DEF_E7_M1_AI_OBJCON_07_A()						700.0; end

script static real DEF_E7_M1_AI_OBJCON_08()							800.0; end
script static real DEF_E7_M1_AI_OBJCON_08_A()						800.0; end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_e7_m7_objcon = 														DEF_E7_M1_AI_OBJCON_START();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_objcon_init::: Init
script dormant f_e7_m1_ai_objcon_init()
	dprint( "f_e7_m1_ai_objcon_init" );
	
	// setup triggers
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_01_a, DEF_E7_M1_AI_OBJCON_01_A()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_02_a, DEF_E7_M1_AI_OBJCON_02_A()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_02_b, DEF_E7_M1_AI_OBJCON_02_B()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_02_c, DEF_E7_M1_AI_OBJCON_02_C()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_03_a, DEF_E7_M1_AI_OBJCON_03_A()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_03_b, DEF_E7_M1_AI_OBJCON_03_B()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_03_c, DEF_E7_M1_AI_OBJCON_03_C()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_04_a, DEF_E7_M1_AI_OBJCON_04_A()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_04_b, DEF_E7_M1_AI_OBJCON_04_B()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_04_c, DEF_E7_M1_AI_OBJCON_04_C()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_05_a, DEF_E7_M1_AI_OBJCON_05_A()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_05_b, DEF_E7_M1_AI_OBJCON_05_B()) );
	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_05_c, DEF_E7_M1_AI_OBJCON_05_C()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_06_a, DEF_E7_M1_AI_OBJCON_06_A()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_07_a, DEF_E7_M1_AI_OBJCON_07_A()) );

	thread( f_e7_m1_ai_objcon_trigger(tv_e7_m1_area_08_a, DEF_E7_M1_AI_OBJCON_08_A()) );
	
end

// === f_e7_m1_ai_objcon_trigger::: Trigger
script static void  f_e7_m1_ai_objcon_trigger( trigger_volume tv_objcon, real r_objcon )

	// wait for trigger
	sleep_until( volume_test_players(tv_objcon) or (f_e7_m1_ai_objcon() >= r_objcon), 1 );
	dprint( "f_e7_m1_ai_objcon_trigger" );
	f_e7_m1_ai_objcon( r_objcon );

end

// === f_e7_m1_ai_objcon::: xxx
script static void f_e7_m1_ai_objcon( real r_value )

	if ( r_value > R_e7_m7_objcon ) then
		dprint( "f_e7_m1_ai_objcon: SET" );
		inspect( r_value );
		R_e7_m7_objcon = r_value;
	end
	
end
script static real f_e7_m1_ai_objcon()
	R_e7_m7_objcon;
end

// === f_e7_m1_ai_objcon_range_check::: xxx
script static boolean f_e7_m1_ai_objcon_range_check( real r_min, real r_max )
	(
		( r_min < 0.0 )
		or
		( r_min <= f_e7_m1_ai_objcon() )
	)
	and
	(
		( r_max < 0.0 )
		or
		( r_max >= f_e7_m1_ai_objcon() )
	);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: TURRETS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
static real DEF_E7_M1_AI_TURRETS_RANGE = 							25.0;
static real DEF_E7_M1_AI_TURRETS_USE_ENGAGE = 				0.75;
static real DEF_E7_M1_AI_TURRETS_USE_DISENGAGE = 			3.0;
static real DEF_E7_M1_AI_TURRETS_ACTIVE_MIN = 				7.5;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7_m1_ai_turrets_active_players = 			0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_ai_turrets_init::: Init
script dormant f_e7_m1_ai_turrets_init()
	dprint( "f_e7_m1_ai_turrets_init" );

	ai_place_in_limbo( gr_e7_m1_turrets );
	
	// setup player watches
	thread( f_e7_m1_ai_turrets_player_watch(Player0) );
	thread( f_e7_m1_ai_turrets_player_watch(Player1) );
	thread( f_e7_m1_ai_turrets_player_watch(Player2) );
	thread( f_e7_m1_ai_turrets_player_watch(Player3) );
	
end

script static void f_e7_m1_ai_turrets_player_watch( player p_player )
local long l_timer = 0;
	dprint( "f_e7_m1_ai_turrets_player_watch" );
	
	repeat
	
		// wait for a active jetpack
		sleep_until( f_e7_m1_ai_turrets_player_jetpacking(p_player), 1 );
		l_timer = timer_stamp( DEF_E7_M1_AI_TURRETS_USE_ENGAGE );
		dprint( "f_e7_m1_ai_turrets_player_watch: WATCHING" );
		
		// make sure they jetpack for the min time
		sleep_until( timer_expired(l_timer) or (not f_e7_m1_ai_turrets_player_jetpacking(p_player)), 1 );
		if ( f_e7_m1_ai_turrets_player_jetpacking(p_player) ) then
			
			// inc active player cnt
			S_e7_m1_ai_turrets_active_players = S_e7_m1_ai_turrets_active_players + 1;
			dprint( "f_e7_m1_ai_turrets_player_watch: ENGAGED" );
			
			repeat
			
				// wait for the player to stop loop
				sleep_until( not f_e7_m1_ai_turrets_player_jetpacking(p_player), 1 );
				
				// start the disengage timer
				l_timer = timer_stamp( DEF_E7_M1_AI_TURRETS_USE_DISENGAGE );
				
				// wait for disengage timer or player to engage their jetpack again
				sleep_until( timer_expired(l_timer) or f_e7_m1_ai_turrets_player_jetpacking(p_player), 1 );
			
			until( not f_e7_m1_ai_turrets_player_jetpacking(p_player), 1 );
			
			// inc active player cnt
			S_e7_m1_ai_turrets_active_players = S_e7_m1_ai_turrets_active_players - 1;
			dprint( "f_e7_m1_ai_turrets_player_watch: DISENGAGED" );
			
		end
	
	until( FALSE, 1 );
	
end

// === f_e7_m1_ai_turrets_player_jetpacking::: Checks if a player is jetpacking
script static boolean f_e7_m1_ai_turrets_player_jetpacking( player p_player )
	// reset action test
	unit_action_test_reset( p_player );
	
	// check
	( unit_get_health(p_player) > 0.0 )
	and
	unit_has_equipment( p_player, 'objects\equipment\storm_jet_pack\storm_jet_pack.equipment' )
	and
	unit_action_test_equipment( p_player );
end

// === f_e7_m1_ai_turrets_init::: xxx
script static void f_e7_m1_ai_turret_manage( ai ai_turret, vehicle vh_turret )
local long l_timer = 0;
	dprint( "f_e7_m1_ai_turret_manage" );

	// basic setup
	ai_cannot_die( ai_turret, TRUE );
	object_cannot_die( vh_turret, TRUE );
	ai_magically_see_object( ai_turret, player0 );
	ai_magically_see_object( ai_turret, player1 );
	ai_magically_see_object( ai_turret, player2 );
	ai_magically_see_object( ai_turret, player3 );
	
	repeat

		// deactivate
		object_set_physics( vh_turret, FALSE );
		object_hide( vh_turret, TRUE );
		ai_braindead( ai_turret, TRUE );
	
		// check to activate
		sleep_until(
			( S_e7_m1_ai_turrets_active_players > 0 )
			and
			timer_expired( l_timer )
			and
			(
				(
					f_e7_m1_ai_turrets_player_jetpacking( Player0 )
					and
					( objects_distance_to_object(vh_turret,Player0) <= DEF_E7_M1_AI_TURRETS_RANGE )
				)
				or
				(
					f_e7_m1_ai_turrets_player_jetpacking( Player1 )
					and
					( objects_distance_to_object(vh_turret,Player1) <= DEF_E7_M1_AI_TURRETS_RANGE )
				)
				or
				(
					f_e7_m1_ai_turrets_player_jetpacking( Player2 )
					and
					( objects_distance_to_object(vh_turret,Player2) <= DEF_E7_M1_AI_TURRETS_RANGE )
				)
				or
				(
					f_e7_m1_ai_turrets_player_jetpacking( Player3 )
					and
					( objects_distance_to_object(vh_turret,Player3) <= DEF_E7_M1_AI_TURRETS_RANGE )
				)
			)
		, 1 );
		l_timer = timer_stamp( DEF_E7_M1_AI_TURRETS_ACTIVE_MIN );

		// activate
		object_set_physics( vh_turret, TRUE );
		object_hide( vh_turret, FALSE );
		ai_braindead( ai_turret, FALSE );
		cs_stationary_face_player( ai_turret, TRUE );
		
		// wait to deactivate
		sleep_until(
			(
				timer_expired( l_timer )
				and
				( S_e7_m1_ai_turrets_active_players <= 0 )
			)
//			or
//			( unit_get_health(vh_turret) <= 0.01 )
		, 1 );
	
	//unit_get_health <unit>
	// if health is set timer so it takes longer to come back
	
	until( FALSE, 1 );
	
	
//S_e7_m1_ai_turrets_active_players
	//object_dissolve_from_marker( vh_turret, 'soft_kill', 'control_marker' );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_e7_m1_ai_turret::: xxx
script command_script cs_e7_m1_ai_turret()
	dprint( "cs_e7_m1_ai_turret" );
	
	thread( f_e7_m1_ai_turret_manage(ai_current_actor, ai_vehicle_get(ai_current_actor)) );

end
