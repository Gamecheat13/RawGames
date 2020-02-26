//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: MISSION ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_spops_mission_startup_defaults( boolean b_allign_humans, short s_ai_lod )
	dprint( "f_spops_mission_startup_defaults" );
	
	// supress player creation
	firefight_mode_set_player_spawn_suppressed( TRUE );

	// defaults
	if ( s_ai_lod < 0 ) then
		s_ai_lod = 20;
	end

	// set human allegiance
	if ( b_allign_humans ) then
		ai_allegiance( human, player );
		ai_allegiance( player, human );
	end
	
	// set ai lod
	if ( s_ai_lod > 0 ) then
		ai_lod_full_detail_actors( s_ai_lod );
	end

end
script static void f_spops_mission_startup_defaults()
	f_spops_mission_startup_defaults( TRUE, -1 );
end

script static void f_spops_mission_flow( boolean b_track_ready, boolean b_track_intro, boolean b_track_start, boolean b_track_end )
	dprint( "f_spops_mission_flow" );

	// wait for events
	if ( b_track_ready ) then
		f_spops_mission_ready_wait();
	end
	if ( b_track_intro ) then
		f_spops_mission_intro_wait();
	end
	if ( b_track_start ) then
		f_spops_mission_start_wait();
	end
	//if ( b_track_end ) then
	//	f_spops_mission_end_wait();
	//end

end
script static void f_spops_mission_flow()
	f_spops_mission_flow( TRUE, TRUE, TRUE, TRUE );
end

script dormant f_spops_mission_waves_start()
	dprint( "f_spops_mission_waves_start" );

	wake( firefight_lost_game );
	wake( firefight_won_game );
	firefight_player_goals();
	dprint( "goals ended" );
	dprint( "game won" );
	//mp_round_end();
	b_game_won = true;

end

script static boolean f_spops_mission_startup_wait( string str_event_startup )
	sleep_until( LevelEventStatus(str_event_startup) or f_spops_mission_identified(), 1 );
	not f_spops_mission_identified();
end


global string STR_spops_mission_id = "";
global boolean B_spops_mission_ready_complete = FALSE;
global boolean B_spops_mission_intro_complete = FALSE;
global boolean B_spops_mission_start_complete = FALSE;
global boolean B_spops_mission_setup_complete = FALSE;

global short 	 s_spops_mission_spawn_init_index = 0;

script static void f_spops_mission_setup( string str_mission_id, zone_set zs_mission, ai ai_mission_all, folder fld_spawn_init, short s_spawn_init_index )
	dprint( "f_spops_mission_setup" );
	dprint( str_mission_id );

	// load the mission zone set
	switch_zone_set( zs_mission );	
	
	// set spawn folder
	firefight_mode_set_crate_folder_at( fld_spawn_init, s_spawn_init_index );
	//set a global short to the initial spawn index so that the spops global script can use it to default spawn folders
	s_spops_mission_spawn_init_index = s_spawn_init_index;

	//set the global "bad guy AI" variable that is used to track wave spawning and auto blips
	ai_ff_all = ai_mission_all;

	// set the mission id
	STR_spops_mission_id = str_mission_id;
	
end

script static boolean f_spops_mission_identified( string str_mission_id )
	STR_spops_mission_id == str_mission_id;
end
script static boolean f_spops_mission_identified()
	STR_spops_mission_id != "";
end

script static void f_spops_mission_ready_wait()
	dprint( "f_spops_mission_ready_wait" );
	
	if ( not editor_mode() ) then
		if (STR_spops_mission_id == "is_e6_m1")then
			local long l_timer = timer_stamp( 2.0 );
			sleep_until( timer_expired(l_timer), 1 );
		else
			local long l_timer = timer_stamp( 8.0 );
			sleep_until( LevelEventStatus("loadout_screen_complete") or timer_expired(l_timer), 1 );
		end
	end
	dprint( "f_spops_mission_ready_wait: GO" );
	f_spops_mission_ready_complete( TRUE );

end

script static void f_spops_mission_setup_complete( boolean b_complete )

	if ( B_spops_mission_setup_complete != b_complete ) then
		dprint( "f_spops_mission_setup_complete" );
		//inspect( b_complete );
		B_spops_mission_setup_complete = b_complete;
	
		//THIS STARTS ALL OF FIREFIGHT SCRIPTS
		if ( b_complete ) then
			wake( f_spops_mission_waves_start );
		end
		
	end

end
script static boolean f_spops_mission_setup_complete()
	B_spops_mission_setup_complete;
end

script static void f_spops_mission_ready_complete( boolean b_complete )
	if ( B_spops_mission_ready_complete != b_complete ) then
		dprint( "f_spops_mission_ready_complete" );
		//inspect( b_complete );
		B_spops_mission_ready_complete = b_complete;
	end
end
script static boolean f_spops_mission_ready_complete()
	B_spops_mission_ready_complete;
end

script static void f_spops_mission_intro_wait()
	dprint( "f_spops_mission_intro_wait" );

	sleep_until( f_spops_mission_intro_complete(), 1 );
	dprint( "f_spops_mission_intro_wait: GO" );
	
end

script static void f_spops_mission_intro_complete( boolean b_complete )
	if ( B_spops_mission_intro_complete != b_complete ) then
		dprint( "f_spops_mission_intro_complete" );
		//inspect( b_complete );
		B_spops_mission_intro_complete = b_complete;
	end
end
script static boolean f_spops_mission_intro_complete()
	B_spops_mission_intro_complete;
end

script static void f_spops_mission_start_wait()
	dprint( "f_spops_mission_start_wait" );

	firefight_mode_set_player_spawn_suppressed( FALSE );
	sleep_until( b_players_are_alive(), 1 );
	f_spops_mission_start_complete( TRUE );
	
end

script static void f_spops_mission_start_complete( boolean b_complete )
	if ( B_spops_mission_start_complete != b_complete ) then
		dprint( "f_spops_mission_start_complete" );
		//inspect( b_complete );
		B_spops_mission_start_complete = b_complete;
	end
end
script static boolean f_spops_mission_start_complete()
	B_spops_mission_start_complete;
end

script static void f_spops_mission_end_complete( boolean b_won, boolean b_end_default )

	if ( not f_spops_mission_end_complete() ) then
		b_game_won = b_won;
		b_game_lost = not b_won;
	
		if ( b_won ) then
			dprint( "f_spops_mission_end_complete: WON" );
			if ( b_end_default ) then
				f_spops_mission_end_default();
			end
		end
		if ( not b_won ) then
			dprint( "f_spops_mission_end_complete: LOST" );
		end

	
	end
	
end
script static void f_spops_mission_end_complete( boolean b_won )
	f_spops_mission_end_complete( b_won, TRUE );
end
script static boolean f_spops_mission_end_complete()
	( b_game_lost ) or ( b_game_won );
end

script static void f_spops_mission_end_default()

	dprint( "ending the mission with fadeout and chapter complete" );
	fade_out( 0, 0, 0, seconds_to_frames(2.0) );
	player_control_fade_out_all_input( 0.1 );
	cui_load_screen( 'ui\in_game\pve_outro\chapter_complete.cui_screen' );
	sleep_s( 2.0 );

end





// === spops_phantom_hidden_seat_occupied_cnt::: XXX
// XXX document params
script static short spops_phantom_hidden_seat_occupied_cnt( vehicle vh_phantom )
local short s_cnt = 0;

	// left front
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_main") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_1") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_2") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lf_small_3") ) then				s_cnt = s_cnt + 1;			end

	// right front
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_main") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_1") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_2") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rf_small_3") ) then				s_cnt = s_cnt + 1;			end

	// left back
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_main") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_1") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_2") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_lb_small_3") ) then				s_cnt = s_cnt + 1;			end

	// right back
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_main") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_1") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_2") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_rb_small_3") ) then				s_cnt = s_cnt + 1;			end

	// left mid
	if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_main") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_1") ) then			s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_2") ) then			s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_ml_f_small_3") ) then			s_cnt = s_cnt + 1;			end

	// right mid
	if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_main") ) then				s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_1") ) then			s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_2") ) then			s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_p_mr_f_small_3") ) then			s_cnt = s_cnt + 1;			end

	// chute
	if ( vehicle_test_seat(vh_phantom, "phantom_pc_1") ) then								s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_pc_2") ) then								s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_pc_3") ) then								s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_phantom, "phantom_pc_4") ) then								s_cnt = s_cnt + 1;			end

	// return
	s_cnt;

end


// === spops_pelican_hidden_seat_occupied_cnt::: XXX
// XXX document params
script static short spops_pelican_hidden_seat_occupied_cnt( vehicle vh_pelican )
local short s_cnt = 0;

	// left front
	if ( vehicle_test_seat(vh_pelican, "pelican_p_l01") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_l02") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_l03") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_l04") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_l05") ) then					s_cnt = s_cnt + 1;			end

	if ( vehicle_test_seat(vh_pelican, "pelican_p_r01") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_r02") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_r03") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_r04") ) then					s_cnt = s_cnt + 1;			end
	if ( vehicle_test_seat(vh_pelican, "pelican_p_r05") ) then					s_cnt = s_cnt + 1;			end

	// return
	s_cnt;
end

// === spops_ai_population_extra_cnt_phantom::: Manages a phantom's seats as part of the population
// XXX document params
script static void spops_ai_population_extra_cnt_phantom( vehicle vh_phantom )
local short s_cnt = 0;
local short s_cnt_tmp = 0;

	//dprint( "spops_ai_population_extra_cnt_phantom: START" );
	repeat
		
		s_cnt_tmp = spops_phantom_hidden_seat_occupied_cnt( vh_phantom );
		if ( s_cnt != s_cnt_tmp ) then
			spops_ai_population_extra_cnt_inc( s_cnt_tmp - s_cnt );
			s_cnt = s_cnt_tmp;
		end
	
	until( object_get_health(vh_phantom) <= 0.0, 1 );
	//dprint( "spops_ai_population_extra_cnt_phantom: END" );
	
	// decrement the cnt
	spops_ai_population_extra_cnt_inc( -s_cnt );

end

// === spops_ai_population_extra_cnt_pelican::: Manages a pelican's seats as part of the population
// XXX document params
script static void spops_ai_population_extra_cnt_pelican( vehicle vh_pelican )
local short s_cnt = 0;
local short s_cnt_tmp = 0;

	//dprint( "spops_ai_population_extra_cnt_pelican: START" );
	repeat
		
		s_cnt_tmp = spops_pelican_hidden_seat_occupied_cnt( vh_pelican );
		if ( s_cnt != s_cnt_tmp ) then
			spops_ai_population_extra_cnt_inc( s_cnt_tmp - s_cnt );
			s_cnt = s_cnt_tmp;
		end
	
	until( object_get_health(vh_pelican) <= 0.0, 1 );
	//dprint( "spops_ai_population_extra_cnt_pelican: END" );
	
	// decrement the cnt
	spops_ai_population_extra_cnt_inc( -s_cnt );

end

script startup spops_nodeath_challenge()
local short s_player_min = 5;

	// activate
	sleep_until( LevelEventStatus("spops_nodeath_challenge_2") or LevelEventStatus("spops_nodeath_challenge_3") or LevelEventStatus("spops_nodeath_challenge_4"), 1 );
	dprint( "spops_nodeath_challenge: ACTIVATED" );
	// get min player cnt
	if ( LevelEventStatus("spops_nodeath_challenge_2") ) then
		s_player_min = 2;
	end
	if ( LevelEventStatus("spops_nodeath_challenge_3") ) then
		s_player_min = 3;
	end
	if ( LevelEventStatus("spops_nodeath_challenge_4") ) then
		s_player_min = 4;
	end

	sleep( 1 );

	// wait for living players
	sleep_until( b_players_are_alive(), 1 );
	sleep( 1 );
	

	
	repeat
	
		// watch for all dead event
		sleep_until( spops_player_living_cnt() == 0, 1 );
		
		// all dead event		
		if ( (game_coop_player_count() >= s_player_min) and (not b_game_won) and (not b_game_lost) ) then
		
			dprint( "spops_nodeath_challenge: ALL DEAD" );
		  firefight_mode_set_player_spawn_suppressed( TRUE );
		  sleep_s( 4.0 );
		  fade_out( 0, 0, 0, seconds_to_frames(1.0) );
		  cui_load_screen( 'ui\in_game\pve_outro\mission_failed.cui_screen' );
		  sleep_s( 1.0 );
		  b_game_lost = TRUE;
		  sleep( 1 );
		 
		else

			dprint( "spops_nodeath_challenge: IGNORED" );

		end
	
	until( (game_coop_player_count() < s_player_min) or b_game_won or b_game_lost, 1 );
	dprint( "spops_nodeath_challenge: DEACTIVATED" );

end
