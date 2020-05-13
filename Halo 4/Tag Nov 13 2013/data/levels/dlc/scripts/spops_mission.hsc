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

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_spops_mission_startup_defaults( boolean b_allign_humans, short s_ai_lod )
	dprint( "f_spops_mission_startup_defaults" );

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
global boolean B_spops_mission_end_complete = 	FALSE;

global short 	 s_spops_mission_spawn_init_index = 0;

script static void f_spops_mission_setup( string str_mission_id, zone_set zs_mission, ai ai_mission_all, folder fld_spawn_init, short s_spawn_init_index )
	dprint( "f_spops_mission_setup" );
	dprint( str_mission_id );

	// load the mission zone set
	switch_zone_set( zs_mission );	
	
	// supress player creation
	firefight_mode_set_player_spawn_suppressed( TRUE );
	
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
		local long l_timer = timer_stamp( 8.0 );
		sleep_until( LevelEventStatus("loadout_screen_complete") or timer_expired(l_timer), 1 );
	end
	dprint( "f_spops_mission_ready_wait: GO" );
	f_spops_mission_ready_complete( TRUE );
	
end

script static void f_spops_mission_setup_complete( boolean b_complete )

	if ( B_spops_mission_setup_complete != b_complete ) then
		dprint( "f_spops_mission_setup_complete" );
		inspect( b_complete );
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
		inspect( b_complete );
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
		inspect( b_complete );
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
		inspect( b_complete );
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




// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: LEVELEVENT: QUEUE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static string STR_levelevent_queue_event = "";
static short S_levelevent_queue_cnt = 0;
static short S_levelevent_queue_use_cnt = 0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void levelevent_queue_add( string str_level_event, real r_time_out, short s_use_cnt )
local long l_timer = timer_stamp( r_time_out );

	if ( levelevent_queue_event() != "" ) then
		sleep_until( levelevent_queue_event() == "", 1 );
	end
	
	// set event to watch
	STR_levelevent_queue_event = str_level_event;
	S_levelevent_queue_cnt = s_use_cnt;
	S_levelevent_queue_use_cnt = 0;
	
	if ( S_levelevent_queue_cnt != 0 ) then
	
		// notify until done
		repeat
			NotifyLevel( str_level_event );
		until( (levelevent_queue_event() != str_level_event) or (S_levelevent_queue_cnt == 0) or ((r_time_out >= 0.0) and timer_expired(l_timer)), 1 );
	
		// reset level event
		levelevent_queue_reset( str_level_event );
		
	end

end
script static void levelevent_queue_add( string str_level_event, real r_time_out )
	levelevent_queue_add( str_level_event, r_time_out, -1 );
end
script static void levelevent_queue_add( string str_level_event )
	levelevent_queue_add( str_level_event, -1.0, -1 );
end

script static boolean levelevent_queue_receive( string str_level_event )
local boolean b_received = FALSE;

	if ( (STR_levelevent_queue_event == str_level_event) and (S_levelevent_queue_cnt != 0) ) then
		S_levelevent_queue_cnt = S_levelevent_queue_cnt - 1;
		S_levelevent_queue_use_cnt = S_levelevent_queue_use_cnt + 1;
		b_received = TRUE;
	end
	
	// return
	b_received;
end

script static boolean levelevent_queue_wait( string str_level_event, real r_time_out )
local long l_timer = timer_stamp( r_time_out );
	sleep_until( levelevent_queue_receive(str_level_event) or ((r_time_out >= 0) and timer_expired(l_timer)), 1 );
end
script static boolean levelevent_queue_wait( string str_level_event )
	levelevent_queue_wait( str_level_event, -1.0 );
end

script static void levelevent_queue_reset( string str_level_event )
	if ( STR_levelevent_queue_event == str_level_event ) then
		STR_levelevent_queue_event = "";
	end
end
script static void levelevent_queue_reset()
	levelevent_queue_reset( STR_levelevent_queue_event );
end

script static string levelevent_queue_event()
	STR_levelevent_queue_event;
end

script static short levelevent_queue_cnt()
	S_levelevent_queue_cnt;
end

script static short levelevent_queue_use_cnt()
	S_levelevent_queue_use_cnt;
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** POTENTIAL GLOBAL ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
script static real objects_distance_to_players( object_list obj_list )
local real r_distance = -1.0;

	// find nearest player distance
	if ( (unit_get_health(player0) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player0) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player0 );
	end
	if ( (unit_get_health(player1) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player1) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player1 );
	end
	if ( (unit_get_health(player2) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player2) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player2 );
	end
	if ( (unit_get_health(player3) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player3) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player3 );
	end

	r_distance;
end

