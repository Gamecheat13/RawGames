//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
		
// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: AI
// -------------------------------------------------------------------------------------------------
// variables
global short S_maintenance_hall_AI_state										= -1;

global short DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0				= 0;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1				= 1;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2				= 2;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3				= 3;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR					= 4;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_WAITING			= 5;
global short DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK			= 6;

global real R_maintenance_hall_AI_goto_range							= 0.5;
//global real R_maintenance_hall_AI_gate_delay							= 2.5;
global real R_maintenance_hall_AI_gate_delay							= 0.0;
global boolean B_maintenance_hall_AI_suprised							= FALSE;
global long S_maintenance_hall_AI_watch_thread						= 0;
global boolean B_maintenance_hall_AI_test									= FALSE;
global boolean B_maintenance_hall_AI_paused								= FALSE;
global boolean B_maintenance_hall_AI_dive_move						= FALSE;
global short S_maintenance_hall_AI_guard_post							= 0;

// functions
// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: TEST
// -------------------------------------------------------------------------------------------------
/*
script static void debug_maintenance_hall_ai()

	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0 ) then

		// wake up modules that need to be ready
		wake( f_maintenance_hall_block01_init );
		wake( f_maintenance_hall_destruction_init );
		wake( f_maintenance_airlock_door01_init );
	
		// start the init
		wake( f_maintenance_hall_AI_init );
		
		R_maintenance_hall_AI_gate_delay = 0.0;
		B_maintenance_hall_AI_test = TRUE;
		
		// start the ai state
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0;
	else
		S_maintenance_hall_AI_state = S_maintenance_hall_AI_state+1;
		if ( S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK ) then
			S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK;
		end
	end

end
*/
// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: AI
// -------------------------------------------------------------------------------------------------
// === f_maintenance_hall_AI_init::: Initialize
script dormant f_maintenance_hall_AI_init()
	//dprint( "::: f_maintenance_hall_AI_init :::" );

	// place AI
	//ai_place( gr_maintenance_explosionalley );



	// initialize sub modules
	//wake( f_maintenance_hall_AI_trigger );
	//wake( f_maintenance_hall_AI_suprised );
	//wake( f_maintenance_hall_AI_pause );

	// setup cleanup
	wake( f_maintenance_hall_AI_cleanup );

	sleep_until(volume_test_players(tv_explosionalley_prehall_area), 1);
	fx_hall_explosion();
	pup_play_show(elite_alley_crawl);
end

// === f_maintenance_hall_AI_deinit::: Deinitialize
script dormant f_maintenance_hall_AI_deinit()
	//dprint( "::: f_maintenance_hall_AI_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_hall_AI_destruction_dive );
	sleep_forever( f_maintenance_hall_AI_suprised );
	sleep_forever( f_maintenance_hall_AI_trigger );
	sleep_forever( f_maintenance_hall_AI_pause );

	// deinitialize sub modules

end

// === f_maintenance_hall_AI_destruction_dive::: Makes an AI dive from explosion
script dormant f_maintenance_hall_AI_destruction_dive()
	//dprint( "f_maintenance_hall_AI_destruction_dive" );

	if ( volume_test_objects(tv_explosionalley_ai_dive,ai_actors(gr_maintenance_explosionalley)) ) then
		sleep_rand_s( 0.0, 0.25 );
		cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_dive );
		cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_dive );
		cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_dive );
		//cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_dive );
	end

end

// === f_maintenance_hall_AI_suprised::: Makes an AI acti suprised
script dormant f_maintenance_hall_AI_suprised()
	sleep_until( f_ai_is_aggressive(gr_maintenance_explosionalley) or volume_test_players(tv_explosionalley_area), 1 );
	
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR ) then
		static short s_index = 0;
		//dprint( "::: f_maintenance_hall_AI_suprised :::" );

		s_index = objlist_index_nearest_point( ai_actors(gr_maintenance_explosionalley), ps_maintenance_explosionalley.start );
	
		if ( s_index != -1 ) then
			cs_run_command_script( object_get_ai(list_get(ai_actors(gr_maintenance_explosionalley),s_index)), cs_maintenance_hall_AI_suprise );
		end
	end

end

// === f_maintenance_hall_AI_pause_set::: Sets the pause flag
script static void f_maintenance_hall_AI_pause_set( boolean b_pause )

	if ( B_maintenance_hall_AI_paused != b_pause ) then
		B_maintenance_hall_AI_paused = b_pause;
		//dprint_if( b_pause, "f_maintenance_hall_AI_pause_set: TRUE" );
		//dprint_if( not b_pause, "f_maintenance_hall_AI_pause_set: FALSE" );
	end
	
end

// === f_maintenance_hall_AI_pause::: Sets the pause flag under the right condition
script dormant f_maintenance_hall_AI_pause()
	//dprint( "f_maintenance_hall_AI_pause" );
	
	sleep_until( S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1, 1 );
	repeat
		f_maintenance_hall_AI_pause_set( (objects_distance_to_point(Players(),ps_maintenance_explosionalley.door01) <= objects_distance_to_point(ai_actors(gr_maintenance_explosionalley),ps_maintenance_explosionalley.door01)) and (player_count() > 0) );
	until( S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR, 15 );
	
end

script static long ai_dead_count( ai ai_check )
	ai_living_count( ai_check ) - ai_spawn_count( ai_check );
end

// === f_maintenance_hall_AI_trigger::: triggers the AI
script dormant f_maintenance_hall_AI_trigger()
	//dprint( "::: f_maintenance_hall_AI_trigger :::" );

	// start -> gate 0	
	sleep_until( (volume_test_players(tv_explosionalley_ai_force)) or (volume_test_players(tv_explosionalley_area)) or ((volume_test_players(tv_explosionalley_ai_lookat_area)) and (volume_test_players_lookat(tv_explosionalley_ai_lookat_target, 17.5, 5.0))) or (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: GATE 0 :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_home, FALSE );
	//cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_gate0 );
	//cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_gate0 );
	//cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_gate0 );
//	cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_gate0 );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0 ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0;
	end

	// gate 0	-> gate 
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1) or (volume_test_objects(tv_explosionalley_gate0,ai_actors(gr_maintenance_explosionalley))) or (ai_dead_count(gr_maintenance_explosionalley) >= 1), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: GATE 1 :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_gate0, FALSE );
	//cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_gate1 );
	//cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_gate1 );
	//cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_gate1 );
	//cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_gate1 );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1 ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1;
	end

	// gate 1	-> gate 2
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2) or (volume_test_objects(tv_explosionalley_gate1,ai_actors(gr_maintenance_explosionalley))) or (ai_dead_count(gr_maintenance_explosionalley) >= 2), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: GATE 2 :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_gate1, FALSE );
	//cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_gate2 );
	//cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_gate2 );
	//cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_gate2 );
	//cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_gate2 );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2 ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2;
	end

	// gate 2	-> gate 3
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3) or (volume_test_objects(tv_explosionalley_gate2,ai_actors(gr_maintenance_explosionalley))) or (ai_dead_count(gr_maintenance_explosionalley) >= 3), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: GATE 3 :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_gate2, FALSE );
	//cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_gate3 );
	//cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_gate3 );
	//cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_gate3 );
	//cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_gate3 );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3 ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3;
	end

	// gate 3	-> door
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR) or (volume_test_objects(tv_explosionalley_gate3,ai_actors(gr_maintenance_explosionalley))), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: DOOR :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_gate3, FALSE );
	//cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_airlock_open );
	//cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_airlock_open );
	//cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_airlock_open );
	//cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_airlock_open );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR;
	end
	
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_WAITING) or (not(dm_maintenance_hall_door01->check_close())), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: WAITING :::" );
	if ( dm_maintenance_hall_door01->check_close() ) then
		dm_maintenance_hall_door01->open_instant();
	end
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_WAITING ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_WAITING;
	end

	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK) or (dm_maintenance_hall_door01->check_open()), 1 );
	//dprint( "::: f_maintenance_hall_AI_trigger: AIRLOCK :::" );
	//ai_set_task_condition( ai_maintenance_explosionalley.easg_door, FALSE );
	if ( S_maintenance_hall_AI_state < DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK ) then
		S_maintenance_hall_AI_state = DEF_S_MAINTENANCE_HALL_AI_STATE_AIRLOCK;
	end

end

// === f_maintenance_hall_AI_cleanup::: Cleanup
script dormant f_maintenance_hall_AI_cleanup()
	sleep_until( ai_spawn_count(gr_maintenance_explosionalley) > 0, 1 );
	sleep_until( ai_living_count(gr_maintenance_explosionalley) <= 0, 1 );
	//dprint( "::: f_maintenance_hall_AI_cleanup :::" );

	// shut down functions
	wake( f_maintenance_hall_AI_deinit );
	
	sleep_forever( f_maintenance_hall_AI_cleanup );

end

// === f_maintenance_hall_AI_airlock_guard::: AI for grunt at door
script static void f_maintenance_hall_AI_airlock_guard( ai ai_watch )

	//dprint( "::: f_maintenance_hall_AI_airlock_guard: SETUP :::" );
	sleep_until( unit_get_health(ai_get_unit(ai_watch)) <= 0.0, 1 );
	//dprint( "::: f_maintenance_hall_AI_airlock_guard: SWITCH :::" );
	if ( ai_living_count(gr_maintenance_explosionalley) > 0 ) then
		sleep_until( not(B_maintenance_hall_AI_paused) or (S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR), 1 );
		if ( S_maintenance_hall_AI_state <= DEF_S_MAINTENANCE_HALL_AI_STATE_DOOR ) then
			if ( S_maintenance_hall_AI_watch_thread != 0 ) then
				kill_thread( S_maintenance_hall_AI_watch_thread );
				S_maintenance_hall_AI_watch_thread = 0;
			end
			S_maintenance_hall_AI_guard_post = 0;
			cs_run_command_script( sq_mh_explosionalley_grunt01, cs_maintenance_hall_AI_airlock_open );
			cs_run_command_script( sq_mh_explosionalley_grunt02, cs_maintenance_hall_AI_airlock_open );
			cs_run_command_script( sq_mh_explosionalley_grunt03, cs_maintenance_hall_AI_airlock_open );
//			cs_run_command_script( sq_mh_explosionalley_grunt04, cs_maintenance_hall_AI_airlock_open );
		end
	end

end

// === cs_maintenance_hall_AI_dive::: Makes the AI dive from the explosion
script command_script cs_maintenance_hall_AI_dive()
	//dprint( "cs_maintenance_hall_AI_dive" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	if ( volume_test_object(tv_explosionalley_ai_dive, ai_current_actor) ) then
		sleep_rand_s( 0.0, 0.125 );
		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:missile:dive_front", TRUE );
		//sleep_rand_s( 0.0, 0.25 );
		cs_stop_custom_animation();
		B_maintenance_hall_AI_dive_move = TRUE;
		sleep_rand_s( 0.0, 0.25 );
	else
		cs_face( TRUE, ps_maintenance_explosionalley.start );
		sleep_until( B_maintenance_hall_AI_dive_move, 1 );
		sleep_rand_s( 0.0, 0.25 );
	end
	
	cs_run_command_script( ai_current_actor, cs_maintenance_hall_AI_gate0 );
	
end

// === cs_maintenance_hall_AI_suprise::: Makes an AI act suprised
script command_script cs_maintenance_hall_AI_suprise()
	//dprint( "cs_maintenance_hall_AI_suprise" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	// face the player
	cs_face_player( TRUE );
	
	// Act suprised
	cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:surprise_front", TRUE );
	sleep_rand_s( 0.0, 1.0 );
	cs_stop_custom_animation();
	cs_face_player( FALSE );

	cs_run_command_script( ai_current_actor, cs_maintenance_hall_AI_gate0 );
	
end

// === cs_maintenance_hall_AI_gate0::: AI for grunt going to gate 0
script command_script cs_maintenance_hall_AI_gate0()
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0) or (f_maintenance_hall_destruction_active()), 1 );
	//dprint( "cs_maintenance_hall_AI_gate0" );
	
	if ( S_maintenance_hall_AI_state == DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_0 ) then
		cs_abort_on_combat_status( ai_combat_status_dangerous );
		cs_abort_on_damage( volume_test_players(tv_explosionalley_area) or f_ai_is_aggressive(ai_get_squad(ai_current_actor)) );

		sleep_rand_s( 0.0, 1.0 );
		// move to gate
		cs_push_stance( "FLEE" );
		cs_move_towards_point( ps_maintenance_explosionalley.gate0, R_maintenance_hall_AI_goto_range );
	end	
	
end

// === cs_maintenance_hall_AI_gate1::: AI for grunt going to gate 1
script command_script cs_maintenance_hall_AI_gate1()
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1) or (f_maintenance_hall_destruction_active()), 1 );
	//dprint( "cs_maintenance_hall_AI_gate1" );

	sleep_until( not(B_maintenance_hall_AI_paused) or (S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1) or (f_maintenance_hall_destruction_active()), 1 );
	if ( S_maintenance_hall_AI_state == DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_1 ) then
		static long l_timer 	= 0;

		// artificial delay to allow player to catch up		
		if ( l_timer == 0 ) then
			l_timer = game_tick_get() + seconds_to_frames( R_maintenance_hall_AI_gate_delay );
		end
		sleep_until( (l_timer < game_tick_get()) or (volume_test_players(tv_explosionalley_area)) or (volume_test_players(tv_explosionalley_start)) or (f_ai_is_aggressive(ai_get_squad(ai_current_actor))) or (f_maintenance_hall_destruction_active()), 1 );
		
		// set aborts
		cs_abort_on_combat_status( ai_combat_status_dangerous );
		cs_abort_on_damage( volume_test_players(tv_explosionalley_area) or f_ai_is_aggressive(ai_get_squad(ai_current_actor)) );
		
		// move to gate
		cs_push_stance( "FLEE" );
		cs_move_towards_point( ps_maintenance_explosionalley.gate1, R_maintenance_hall_AI_goto_range );
	end
	
end

// === cs_maintenance_hall_AI_gate2::: AI for grunt going to gate 2
script command_script cs_maintenance_hall_AI_gate2()
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2) or (f_maintenance_hall_destruction_active()), 1 );
	//dprint( "cs_maintenance_hall_AI_gate2" );

	sleep_until( not(B_maintenance_hall_AI_paused) or (S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2) or (f_maintenance_hall_destruction_active()), 1 );
	if ( S_maintenance_hall_AI_state == DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_2 ) then
		static long l_timer 	= 0;

		// artificial delay to allow player to catch up		
		if ( l_timer == 0 ) then
			l_timer = game_tick_get() + seconds_to_frames( R_maintenance_hall_AI_gate_delay );
		end
		sleep_until( (l_timer < game_tick_get()) or (volume_test_players(tv_explosionalley_area)) or (volume_test_players(tv_explosionalley_start)) or (f_ai_is_aggressive(ai_get_squad(ai_current_actor))) or (f_maintenance_hall_destruction_active()), 1 );

		// set aborts
		cs_abort_on_combat_status( ai_combat_status_dangerous );
		cs_abort_on_damage( volume_test_players(tv_explosionalley_area) or f_ai_is_aggressive(ai_get_squad(ai_current_actor)) );
		
		// move to gate
		cs_push_stance( "FLEE" );
		cs_move_towards_point( ps_maintenance_explosionalley.gate2, R_maintenance_hall_AI_goto_range );
	end
	
end

// === cs_maintenance_hall_AI_gate3::: AI for grunt going to gate 3
script command_script cs_maintenance_hall_AI_gate3()
	sleep_until( (S_maintenance_hall_AI_state >= DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3) or (f_maintenance_hall_destruction_active()), 1 );
	//dprint( "cs_maintenance_hall_AI_gate3" );

	sleep_until( not(B_maintenance_hall_AI_paused) or (S_maintenance_hall_AI_state > DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3) or (f_maintenance_hall_destruction_active()), 1 );
	//dprint( "cs_maintenance_hall_AI_gate3-b" );
	if ( S_maintenance_hall_AI_state == DEF_S_MAINTENANCE_HALL_AI_STATE_GATE_3 ) then
		static long l_timer 	= 0;

		// artificial delay to allow player to catch up		
		if ( l_timer == 0 ) then
			//dprint( "cs_maintenance_hall_AI_gate3-c" );
			l_timer = game_tick_get() + seconds_to_frames( R_maintenance_hall_AI_gate_delay );
		end
		sleep_until( (l_timer < game_tick_get()) or (volume_test_players(tv_explosionalley_area)) or (volume_test_players(tv_explosionalley_start)) or (f_ai_is_aggressive(ai_get_squad(ai_current_actor))) or (f_maintenance_hall_destruction_active()), 1 );
		
		// set aborts
		cs_abort_on_combat_status( ai_combat_status_dangerous );
		cs_abort_on_damage( volume_test_players(tv_explosionalley_area) or f_ai_is_aggressive(ai_get_squad(ai_current_actor)) );
		
		// move to gate
		cs_push_stance( "FLEE" );
		cs_move_towards_point( ps_maintenance_explosionalley.gate3, R_maintenance_hall_AI_goto_range );
	end
	
end

// === cs_maintenance_hall_AI_airlock_open::: AI for grunt at door
script command_script cs_maintenance_hall_AI_airlock_open()
	//dprint( "cs_maintenance_hall_AI_airlock_open" );

	if ( S_maintenance_hall_AI_watch_thread == 0 ) then
		//dprint( "cs_maintenance_hall_AI_airlock_open: OPEN" );
		S_maintenance_hall_AI_watch_thread = thread( f_maintenance_hall_AI_airlock_guard(ai_current_actor) );
		cs_abort_on_alert( FALSE );
		cs_abort_on_damage( FALSE );
		cs_go_to( ps_maintenance_explosionalley.door01 );
		if ( dm_maintenance_hall_door01->check_close() ) then
			static short s_door_tries = 1;
//			static short s_door_tries = random_range( 2, 3 );
			
			repeat
				if ( not(B_maintenance_hall_AI_paused) ) then
					// XXX change to beat on door or try to lift
					cs_face( TRUE, ps_maintenance_explosionalley.door02 );
					//cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:taunt:var1", TRUE );
					cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "m10_grunt_door_pound_v01", TRUE );
					cs_stop_custom_animation();
					s_door_tries = s_door_tries - 1;
					if ( s_door_tries > 0 ) then
						sleep_rand_s( 0.75, 1.25 );
					end
				else
					sleep_s( 1.0 );
				end
			until ( (s_door_tries <= 0) or not(dm_maintenance_hall_door01->check_close()), 1 );

			// win, open
			if ( dm_maintenance_hall_door01->check_close() ) then
				thread( dm_maintenance_hall_door01->open() );
				sleep_until ( not(dm_maintenance_hall_door01->check_close()), 1 );

				cs_abort_on_alert( FALSE );
				cs_abort_on_damage( FALSE );
				if ( not f_ai_is_aggressive(gr_maintenance_explosionalley) ) then
					// shocked he opened it			
					cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:surprise_front", TRUE );
					cs_stop_custom_animation();
					sleep_s( 0.125 );
				end
			end

			// victory!			
			if ( not f_ai_is_aggressive(gr_maintenance_explosionalley) ) then
				cs_face( TRUE, ps_maintenance_explosionalley.door02 );
				cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:pistol:taunt:var2", TRUE );
			end
		end

		cs_abort_on_alert( FALSE );
		cs_abort_on_damage( FALSE );
		cs_face( TRUE, ps_maintenance_explosionalley.start );

		cs_run_command_script( ai_current_actor, cs_maintenance_hall_AI_airlock );

	else
		//dprint( "f_maintenance_hall_AI_door: GUARD" );
		cs_run_command_script( ai_current_actor, cs_maintenance_hall_AI_airlock_guard );
	end

end

// === cs_maintenance_hall_AI_airlock_guard::: AI for grunt at door to guard
script command_script cs_maintenance_hall_AI_airlock_guard()
	//dprint( "cs_maintenance_hall_AI_airlock_guard" );
	
	if ( S_maintenance_hall_AI_guard_post >= 4 ) then
		S_maintenance_hall_AI_guard_post = 0;
	end
	
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_stop_custom_animation();
	if (S_maintenance_hall_AI_guard_post == 0 ) then
		S_maintenance_hall_AI_guard_post = S_maintenance_hall_AI_guard_post + 1;
		cs_go_to_and_face( ps_maintenance_explosionalley.guard0, ps_maintenance_explosionalley.start );
	end
	if (S_maintenance_hall_AI_guard_post == 1 ) then
		S_maintenance_hall_AI_guard_post = S_maintenance_hall_AI_guard_post + 1;
		cs_go_to_and_face( ps_maintenance_explosionalley.guard1, ps_maintenance_explosionalley.start );
	end
	if (S_maintenance_hall_AI_guard_post == 2 ) then
		S_maintenance_hall_AI_guard_post = S_maintenance_hall_AI_guard_post + 1;
		cs_go_to_and_face( ps_maintenance_explosionalley.guard2, ps_maintenance_explosionalley.start );
	end
	if (S_maintenance_hall_AI_guard_post == 3 ) then
		S_maintenance_hall_AI_guard_post = S_maintenance_hall_AI_guard_post + 1;
		cs_go_to_and_face( ps_maintenance_explosionalley.guard3, ps_maintenance_explosionalley.start );
	end
	cs_abort_on_alert( TRUE );
	cs_abort_on_damage( TRUE );
	cs_aim( TRUE, ps_maintenance_explosionalley.start );

end

// === cs_maintenance_hall_AI_airlock::: AI for airlock guy
script command_script cs_maintenance_hall_AI_airlock()
static real r_health = 0.0;
	//dprint( "cs_maintenance_hall_AI_airlock" );
	
	//dprint( "cs_maintenance_hall_AI_airlock: GOTO" );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	cs_stop_custom_animation();
	cs_go_to( ps_maintenance_explosionalley.door02 );

	// stop anyone else from coming in here
	//dprint( "cs_maintenance_hall_AI_airlock: KILL THREAD" );
	if ( S_maintenance_hall_AI_watch_thread != 0 ) then
		kill_thread( S_maintenance_hall_AI_watch_thread );
		S_maintenance_hall_AI_watch_thread = 0;
	end

	// get current health
	r_health = object_get_health( ai_get_object(ai_current_actor) );

	// try to open the door; sorry grunty, no door open for you this time
	//dprint( "cs_maintenance_hall_AI_airlock: ANIMATE - START" );
	cs_face( TRUE, ps_maintenance_explosionalley.door02 );
	cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "m10_grunt_door_pound_v01", TRUE );
	cs_stop_custom_animation();
	//dprint( "cs_maintenance_hall_AI_airlock: ANIMATE - DONE" );

	if ( f_ai_is_aggressive(ai_get_squad(ai_current_actor)) ) then
		//dprint( "cs_maintenance_hall_AI_airlock: SUPRISED" );
		cs_abort_on_alert( FALSE );
		cs_abort_on_damage( FALSE );
		cs_custom_animation( 'objects\characters\storm_grunt\storm_grunt.model_animation_graph', "combat:unarmed:surprise_back", TRUE );
		cs_stop_custom_animation();
	else
		//dprint( "cs_maintenance_hall_AI_airlock: FACE" );
		cs_abort_on_alert( TRUE );
		cs_abort_on_damage( TRUE );
		cs_face( TRUE, ps_maintenance_explosionalley.door01 );
	end

	// for honor
	sleep_until( f_ai_is_aggressive(ai_get_squad(ai_current_actor)), 1 );
	//dprint( "cs_maintenance_hall_AI_airlock: KAMIKAZE" );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	ai_grunt_kamikaze( ai_current_actor );

end