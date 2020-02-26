//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: BARRIERS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_barrier_total_cnt = 										0;
static short S_e7m1_barrier_active_cnt = 										0;
static short S_e7m1_barrier_generators_destroyed_cnt = 			0;
static long L_e7m1_barrier_timer_first = 										-1;

global object obj_e7m1_pup_barrier_user = 									NONE;
global object obj_e7m1_pup_barrier_terminal = 							NONE;
global object obj_e7m1_pup_barrier_barrier = 								NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_barriers_init::: Init
script dormant f_e7m1_barriers_init()
	//dprint( "f_e7m1_barriers_init" );

	// create the barriers
	object_create_folder( fld_e7m1_scenery_barriers );
	object_create_folder( fld_e7m1_crates_barriers );

	// setup barrier trigger
	wake( f_e7m1_barriers_trigger );

end

// === f_e7m1_barriers_trigger::: Trigger
script dormant f_e7m1_barriers_trigger()
	//dprint( "f_e7m1_barriers_trigger" );

	sleep_until( f_ai_killed_cnt(gr_e7m1_pool) > 0, 1 );
	L_e7m1_barrier_timer_first = timer_stamp( 60.0 );
	
end

// === f_e7m1_barrier_manage::: Manages a barrier
script static void f_e7m1_barrier_manage( object_name obj_barrier, object_name obj_power, object_name obj_terminal_a, object_name obj_terminal_b, trigger_volume tv_blip, real r_auto_objcon, real r_auto_distance_player, real r_auto_distance_ai )
	//dprint( "f_e7m1_barrier_manage" );
	
	// wait for mission to start
	sleep_until( f_spops_mission_identified(), 1 );
	
	if ( f_spops_mission_identified(DEF_E7M1_MISSION_ID) ) then

		// wait for the objects to be valid
		sleep_until( object_valid(obj_barrier) and object_valid(obj_power), 10 );
		//dprint( "f_e7m1_barrier_manage: START" );
		SetObjectLongVariable( obj_barrier, 1, 0 );
		
		// setup barrier blip
		thread( f_e7m1_barriers_blip(GetCurrentThreadID(), tv_blip, obj_power) );
		
		// increment counters
		S_e7m1_barrier_total_cnt = S_e7m1_barrier_total_cnt + 1;
		S_e7m1_barrier_active_cnt = S_e7m1_barrier_active_cnt + 1;
		
		// wait for one to be destroyed
		sleep_until( (not object_valid(obj_barrier)) or (object_get_health(obj_power) <= 0.0) or ((R_e7m1_objcon > r_auto_objcon) and (objects_distance_to_object(players(),obj_barrier) >= r_auto_distance_player) and (objects_distance_to_object(ai_actors(gr_e7m1_pool),obj_barrier) <= r_auto_distance_ai)), 10 );
		spops_audio_music_event( 'play_mus_pve_e07m1_event_barrier_deactivated', "play_mus_pve_e07m1_event_barrier_deactivated" );
		if ( object_valid(obj_barrier) ) then
			//dprint( "f_e7m1_barrier_manage: DESTROY" );
			thread( sys_e7m1_barrier_fade(obj_barrier) );
		end
		if ( object_get_health(obj_power) <= 0.0 ) then
			S_e7m1_barrier_generators_destroyed_cnt = S_e7m1_barrier_generators_destroyed_cnt + 1;
			spops_audio_music_event( 'play_mus_pve_e07m1_event_barrier_generator_destroyed', "play_mus_pve_e07m1_event_barrier_generator_destroyed" );
		end
	
		// decrement counter
		S_e7m1_barrier_active_cnt = S_e7m1_barrier_active_cnt - 1;
		//dprint( "f_e7m1_barrier_manage: END" );

	end
	
end

script static void f_e7m1_barriers_blip( long l_thread_id, trigger_volume tv_blip, object_name obj_power )
local boolean b_blip_p0 = FALSE;
local boolean b_blip_p1 = FALSE;
local boolean b_blip_p2 = FALSE;
local boolean b_blip_p3 = FALSE;

	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_BARRIER_BLIP, 1 );
	
	repeat
	
		b_blip_p0 = sys_e7m1_barriers_blip( l_thread_id, player0, tv_blip, obj_power, b_blip_p0 );
		b_blip_p1 = sys_e7m1_barriers_blip( l_thread_id, player1, tv_blip, obj_power, b_blip_p1 );
		b_blip_p2 = sys_e7m1_barriers_blip( l_thread_id, player2, tv_blip, obj_power, b_blip_p2 );
		b_blip_p3 = sys_e7m1_barriers_blip( l_thread_id, player3, tv_blip, obj_power, b_blip_p3 );
		
	until( (not isthreadvalid(l_thread_id)) and (not b_blip_p0) and (not b_blip_p1) and (not b_blip_p2) and (not b_blip_p3), 5 );

end

script static boolean sys_e7m1_barriers_blip( long l_thread_id, player p_player, trigger_volume tv_blip, object_name obj_power, boolean b_blip )

	if ( (isthreadvalid(l_thread_id) and volume_test_object(tv_blip, p_player)) != b_blip ) then
		b_blip = not b_blip;
		
		if ( b_blip ) then
			navpoint_track_object_for_player_named( p_player, obj_power, "navpoint_healthbar_neutralize" );
		end
		if ( not b_blip ) then
			navpoint_track_object_for_player( p_player, obj_power, FALSE );
		end

	end
	sleep(1);

	// return
	b_blip;
end

script static short f_e7m1_barriers_total_cnt()
	S_e7m1_barrier_total_cnt;
end
script static short f_e7m1_barriers_active_cnt()
	S_e7m1_barrier_active_cnt;
end
script static short f_e7m1_barriers_deactivated_cnt()
	S_e7m1_barrier_total_cnt - S_e7m1_barrier_active_cnt;
end
script static short f_e7m1_barriers_generators_destroyed_cnt()
	S_e7m1_barrier_total_cnt - S_e7m1_barrier_active_cnt;
end

script static boolean f_e7m1_barrier_terminal_interact_check( boolean b_interact )

	b_interact and (timer_expired(L_e7m1_barrier_timer_first) or (f_ai_killed_cnt(gr_e7m1_pool) > 1) or (f_e7m1_barriers_deactivated_cnt() > 0));

end

// === f_e7m1_barrier_terminal_interact::: Makes an AI interact with the terminal
script static void f_e7m1_barrier_terminal_interact( ai ai_user, object_name obj_barrier, object_name obj_terminal, string_id pup_show )
local long l_pup_id = 0;
	//dprint( "f_e7m1_barrier_terminal_interact" );
	
	// set the variables
	obj_e7m1_pup_barrier_user = ai_get_object( ai_user );
	obj_e7m1_pup_barrier_terminal = obj_terminal;
	obj_e7m1_pup_barrier_barrier = obj_barrier;
	
	// Play pup show
	l_pup_id = pup_play_show( pup_show );
	//dprint( "f_e7m1_barrier_terminal_interact: SHOW" );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_barrier_enemy_goto', "play_mus_pve_e07m1_event_barrier_enemy_goto" );
	
	// wait for show to finish or become invalid
	//dprint( "f_e7m1_barrier_terminal_interact: WAIT" );
	sleep_until( (not pup_is_playing(l_pup_id)) or (ai_living_count(ai_user) <= 0) or ((obj_barrier == NONE) or (GetObjectLongVariable(obj_barrier, 1) != 0)) or (obj_terminal == NONE), 1 );
	//dprint( "f_e7m1_barrier_terminal_interact: DONE" );
	if ( pup_is_playing(l_pup_id) ) then
		//dprint( "f_e7m1_barrier_terminal_interact: KILL" );
		pup_stop_show( l_pup_id );
	end
	
end
script static void f_e7m1_barrier_terminal_interact_grunt( ai ai_user, object_name obj_barrier, object_name obj_terminal )
	f_e7m1_barrier_terminal_interact( ai_user, obj_barrier, obj_terminal, 'pup_e7m1_terminal_interact_grunt' );
end
script static void f_e7m1_barrier_terminal_interact_jackal( ai ai_user, object_name obj_barrier, object_name obj_terminal )
	f_e7m1_barrier_terminal_interact( ai_user, obj_barrier, obj_terminal, 'pup_e7m1_terminal_interact_jackal' );
end
script static void f_e7m1_barrier_terminal_interact_elite( ai ai_user, object_name obj_barrier, object_name obj_terminal )
	f_e7m1_barrier_terminal_interact( ai_user, obj_barrier, obj_terminal, 'pup_e7m1_terminal_interact_elite' );
end

// === f_e7m1_barrier_terminal_interact_complete::: When the terminal interaction is complete what happens
script static void f_e7m1_barrier_terminal_interact_complete( object obj_user, object obj_terminal )
	//dprint( "f_e7m1_barrier_terminal_interact_complete" );
	
	if ( (obj_terminal == cr_e7m1_terminal_1A_to_2A) or (obj_terminal == cr_e7m1_terminal_2A_to_1A) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_1A_to_2A) );
	end
	if ( obj_terminal == cr_e7m1_terminal_3B_to_1A ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_1A_to_3B) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_2E_to_3A) or (obj_terminal == cr_e7m1_terminal_3A_to_2E) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_2E_to_3A) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_3B_to_4A) or (obj_terminal == cr_e7m1_terminal_4A_to_3B) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_3B_to_4A) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_3C_to_4B) or (obj_terminal == cr_e7m1_terminal_4B_to_3C) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_3C_to_4B) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_4C_to_5A) or (obj_terminal == cr_e7m1_terminal_5A_to_4C) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_4C_to_5A) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_5C_to_6A) or (obj_terminal == cr_e7m1_terminal_6A_to_5C) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_5C_to_6A) );
	end
	if ( (obj_terminal == cr_e7m1_terminal_6C_to_7A) or (obj_terminal == cr_e7m1_terminal_7A_to_6C) ) then
		thread( sys_e7m1_barrier_fade(scn_e7m1_barrier_6C_to_7A) );
	end
	
end

// === sys_e7m1_barrier_terminal_interact_complete::: Performs the barier shut down action
script static void sys_e7m1_barrier_fade( object obj_barrier )
	//dprint( "sys_e7m1_barrier_terminal_interact_complete" );
	
	if ( (obj_barrier != NONE) and (GetObjectLongVariable(obj_barrier, 1) == 0) ) then

		SetObjectLongVariable( obj_barrier, 1, 1 );
		spops_audio_music_event( 'play_mus_pve_e07m1_event_barrier_enemy_open', "play_mus_pve_e07m1_event_barrier_enemy_open" );
		object_set_function_variable( obj_barrier, 'shield_alpha', 1, 3.0 );
		sound_impulse_start( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e7m1_cov_barrier_down', obj_barrier, 1 ); 
		sleep_s( 2.0 );
		object_set_physics( obj_barrier, FALSE );
		sleep_s( 1.0 );
		object_destroy( obj_barrier );
		
	end

end