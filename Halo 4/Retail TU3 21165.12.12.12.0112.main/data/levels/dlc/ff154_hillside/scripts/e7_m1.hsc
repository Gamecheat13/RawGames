//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** E7M1: MISSION ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
// spawn points
global short DEF_E7M1_INDEX_SPAWN_LOCS_INITIAL = 										90;
global string DEF_E7M1_MISSION_ID = 																"e7m1";

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === e7m1_startup::: Startup
script startup f_e7m1_startup()

	//Wait for start
	if ( f_spops_mission_startup_wait("e7_m1_startup") ) then
	
		//dprint( "f_e7m1_startup" );
		wake( f_e7m1_init );

	else
	
		f_e7m1_tower_cleanup( cr_e7m1_watchtower_4f_base, cr_e7m1_watchtower_4f_top );
//		f_e7m1_tower_cleanup( cr_e7m1_watchtower_5a_base, cr_e7m1_watchtower_5a_top );
		f_e7m1_tower_cleanup( cr_e7m1_watchtower_6a_base, cr_e7m1_watchtower_6a_top );
//		f_e7m1_tower_cleanup( cr_e7m1_watchtower_7b_base, cr_e7m1_watchtower_7b_top );
		f_e7m1_tower_cleanup( cr_e7m1_watchtower_8a_base, cr_e7m1_watchtower_8a_top );
		
	end
	
end

// === e7m1_init::: Init
script dormant f_e7m1_init()
	//dprint( "f_e7m1_init" );

	// disable all auto-blips
	b_wait_for_narrative_hud = TRUE;

	// set standard mission init
	f_spops_mission_setup( DEF_E7M1_MISSION_ID, 'e7_m1_start', gr_e7m1_all, fld_e7m1_spawn_start, DEF_E7M1_INDEX_SPAWN_LOCS_INITIAL );
	
	// setup initial respawn folder
	thread( f_e7m1_respawn_manage(fld_e7m1_respawn_area_00, tv_e7m1_area_00, DEF_E7M1_AI_OBJCON_AREA_START, DEF_E7M1_AI_OBJCON_AREA_1A, scn_e7m1_respawn_area_00, 1, NONE, TRUE, NONE, TRUE) );
	thread( f_e7m1_respawn_manage(fld_e7m1_respawn_area_1A_pre, tv_e7m1_area_1A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_2A, scn_e7m1_respawn_area_1A_pre, 1, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE, TRUE, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE, TRUE) );
	
	// initialize modules
	wake( f_e7m1_ai_init );
	wake( f_e7m1_narrative_init );
	wake( f_e7m1_audio_init );
	wake( f_e7m1_barriers_init );
	wake( f_e7m1_changers_init );
	
	// initialize sub-modules
	wake( f_e7m1_fall_damage_init );
	wake( f_e7m1_portals_init );
	wake( f_e7m1_props_init );
	wake( f_e7m1_objective_init );
	wake( f_e7m1_ordnance_init );
	wake( f_e7m1_tower_init );
	
	// setup is complete
	f_spops_mission_setup_complete( TRUE );
	
	// setup start trigger
	wake( f_e7m1_trigger );
	
	//gmurphy 1/08/2013 -- bug 7904
	thread (f_e7m1_garbage_cleanup());

end

// === f_e7m1_trigger::: Trigger
script dormant f_e7m1_trigger()
	//dprint( "f_e7m1_trigger" );

	// start
	sleep_until( f_spops_mission_start_complete() and volume_test_players(tv_e7m1_portal_start), 1 );
	wake( f_e7m1_dialog_portal_start );
	
	// end
	sleep_until( B_e7m1_phantom_pickup_ready and (objects_distance_to_object(Players(),dm_e7m1_phantom_grav_lift) <= 0.39) and (spops_player_living_cnt() > 0), 1);
	//inspect( objects_distance_to_object(Players(),dm_e7m1_phantom_grav_lift) );
	wake( f_e7m1_narrative_outro_action );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: TOWERS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_tower_init::: Init
script dormant f_e7m1_tower_init()
	//dprint( "f_e7m1_tower_init" );

	wake( f_e7m1_tower_4f_init );
//	wake( f_e7m1_tower_5a_init );
	wake( f_e7m1_tower_6a_init );
//	wake( f_e7m1_tower_7b_init );
	wake( f_e7m1_tower_8a_init );
	
end

// === f_e7m1_tower_init::: Init
script dormant f_e7m1_tower_4f_init()

	object_create_anew( cr_e7m1_watchtower_4f_base );
	object_create_anew( cr_e7m1_watchtower_4f_top );
	sleep( 1 );
	sleep_until( object_active_for_script(cr_e7m1_watchtower_4f_base) and object_valid(cr_e7m1_watchtower_4f_top), 1 );
	cr_e7m1_watchtower_4f_base->top_object( cr_e7m1_watchtower_4f_top );

end

// === f_e7m1_tower_init::: Init
script dormant f_e7m1_tower_6a_init()

	object_create_anew( cr_e7m1_watchtower_6a_base );
	object_create_anew( cr_e7m1_watchtower_6a_top );
	sleep( 1 );
	sleep_until( object_active_for_script(cr_e7m1_watchtower_6a_base) and object_valid(cr_e7m1_watchtower_6a_top), 1 );
	cr_e7m1_watchtower_6a_base->top_object( cr_e7m1_watchtower_6a_top );

end

// === f_e7m1_tower_init::: Init
script dormant f_e7m1_tower_8a_init()

	object_create_anew( cr_e7m1_watchtower_8a_base );
	object_create_anew( cr_e7m1_watchtower_8a_top );
	sleep( 1 );
	sleep_until( object_active_for_script(cr_e7m1_watchtower_8a_base) and object_valid(cr_e7m1_watchtower_8a_top), 1 );
	cr_e7m1_watchtower_8a_base->top_object( cr_e7m1_watchtower_8a_top );

end

// === f_e7m1_tower_cleanup::: Cleans up towers
script static void f_e7m1_tower_cleanup( object_name obj_base, object_name obj_top )

	sleep_until( object_valid(obj_base) and object_valid(obj_top), 1 );
	object_hide( obj_base, TRUE );
	object_set_physics( obj_base, FALSE );
	object_hide( obj_top, TRUE );
	object_set_physics( obj_top, FALSE );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: FALL DAMAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_e7m1_fall_landed = 										FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_fall_damage_init::: Init
script dormant f_e7m1_fall_damage_init()
	//dprint( "f_e7m1_fall_damage_init" );

	//	disable movement
	if ( not editor_mode() ) then
		player_disable_movement( TRUE );
	end
	thread( f_e7m1_fall_damage_distable_start(player0) );
	thread( f_e7m1_fall_damage_distable_start(player1) );
	thread( f_e7m1_fall_damage_distable_start(player2) );
	thread( f_e7m1_fall_damage_distable_start(player3) );

end

// === f_e7m1_fall_damage_distable_start::: xxx
script static void f_e7m1_fall_damage_distable_start( player p_player )

	// disable fall damage
	sleep_until( (object_get_health(p_player) > 0.0) or (R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A), 1 );
	//dprint( "f_e7m1_fall_damage_distable_start: DISABLED" );
	object_cannot_take_damage( p_player );
	
	// start the timer
	sleep_until( (R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A) or volume_test_object(tv_e7m1_area_00, p_player), 1 );
	//dprint( "f_e7m1_fall_damage_distable_start: TIMER/MOVEMENT" );
	local long l_timer = timer_stamp( 2.5 );
	if ( not editor_mode() ) then
		player_disable_movement( FALSE );
	end
	
	// disable fall damage
	sleep_until( (R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A) or timer_expired(l_timer), 1 );
	B_e7m1_fall_landed = TRUE;
	//dprint( "f_e7m1_fall_damage_distable_start: ENABLED" );
	object_can_take_damage( p_player );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_freefall_landed', "play_mus_pve_e07m1_event_freefall_landed" );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: OBJECTIVES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E7M1_OBJECTIVE_NONE = 									0;
global short DEF_E7M1_OBJECTIVE_PORTAL = 								1;
global short DEF_E7M1_OBJECTIVE_ABORT = 								2;
global short DEF_E7M1_OBJECTIVE_EXIT = 									3;
global short DEF_E7M1_OBJECTIVE_EXIT_BLIP = 						4;
global short DEF_E7M1_OBJECTIVE_BARRIER = 							5;
global short DEF_E7M1_OBJECTIVE_BARRIER_BLIP = 					6;
global short DEF_E7M1_OBJECTIVE_LZ = 										7;
global short DEF_E7M1_OBJECTIVE_LZ_BLIP = 							8;
global short DEF_E7M1_OBJECTIVE_LZ_CLEAR = 							9;
global short DEF_E7M1_OBJECTIVE_PHANTOM_HELP = 					10;
global short DEF_E7M1_OBJECTIVE_PICKUP = 								11;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_objective = 												DEF_E7M1_OBJECTIVE_NONE;
global boolean B_e7m1_objective_barrier_blipped = 			FALSE;
global real R_e7m1_objective_mech_drop_distance = 			5.0;
global real R_e7m1_objective_mech_drop_warn_distance = 	2.5;
global boolean B_e7m1_objective_lz_cleared = 						FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_objective_init::: Init
script dormant f_e7m1_objective_init()
	//dprint( "f_e7m1_objective_init" );
	
	// setup trigger
	wake ( f_e7m1_objective_portal_trigger );
	wake ( f_e7m1_objective_abort_trigger );
	wake ( f_e7m1_objective_exit_trigger );
	wake ( f_e7m1_objective_barrier_trigger );
	wake ( f_e7m1_objective_lz_trigger );
	wake ( f_e7m1_objective_lz_clear_trigger );
	wake ( f_e7m1_objective_phantom_help_trigger );
	wake ( f_e7m1_objective_pickup_trigger );

end
		
// === f_e7m1_objective_portal_trigger::: Triggers
script dormant f_e7m1_objective_portal_trigger()
local long l_blip_thread = 0;
	//dprint( "f_e7m1_objective_portal_trigger" );
	
	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PORTAL, 6 );
	if ( f_e7m1_objective() == DEF_E7M1_OBJECTIVE_PORTAL ) then
		f_new_objective( ch_8_1_2 );
		l_blip_thread = spops_blip_auto_object_trigger_toggle( dc_e8_m1_switch3, "activate", "default", tv_e7m1_objective_portal );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_portal_start', "play_mus_pve_e07m1_objective_portal_start" );
	end

	//	unblip
	sleep_until( (device_get_position(dc_e8_m1_switch3) > 0.0) or (f_e7m1_objective() > DEF_E7M1_OBJECTIVE_ABORT), 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_objective_portal_end', "play_mus_pve_e07m1_objective_portal_end" );
	kill_thread( l_blip_thread );
	objectives_finish ( DEF_E7M1_OBJECTIVE_PORTAL - 1 );
end


// === f_e7m1_objective_abort_trigger::: Triggers
script dormant f_e7m1_objective_abort_trigger()
	local long l_timer = 0;

	//dprint( "f_e7m1_objective_abort_trigger" );

	// start the abort sequence
	sleep_until( (f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PORTAL) or (S_e7m1_portal_switched_cnt > 0) or (f_ai_killed_cnt(gr_e7m1_pool) > 0) or (f_e7m1_barriers_deactivated_cnt() > 0), 6 );
	l_timer = timer_stamp( 150.0 );
	
	sleep_until( (S_e7m1_portal_switched_cnt > 0) or (f_ai_killed_cnt(gr_e7m1_pool) > 0) or (f_e7m1_barriers_deactivated_cnt() > 0) or (timer_expired(l_timer)) or (f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_ABORT), 6 );
	f_e7m1_objective( DEF_E7M1_OBJECTIVE_ABORT );
	wake( f_e7m1_dialog_abort_start );
	spops_audio_music_event( 'play_mus_pve_e07m1_objective_abort_start', "play_mus_pve_e07m1_objective_abort_start" );

end

// === f_e7m1_objective_continue_trigger::: Triggers
script dormant f_e7m1_objective_exit_trigger()
	//dprint( "f_e7m1_objective_continue_trigger" );

	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_EXIT, 10 );
	if ( (f_e7m1_objective() == DEF_E7M1_OBJECTIVE_EXIT) and (f_e7m1_barriers_deactivated_cnt() == 0) ) then
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_exit_start', "play_mus_pve_e07m1_objective_exit_start" );
	
		wake( f_e7m1_dialog_exit_start );
		sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_EXIT_BLIP, 1 );
		
		if ( f_e7m1_barriers_deactivated_cnt() == 0 ) then
		
			spops_blip_flag( flg_e7m1_objective_exit, TRUE, "default" );
			spops_audio_music_event( 'play_mus_pve_e07m1_objective_exit_blip_start', "play_mus_pve_e07m1_objective_exit_blip_start" );
			sleep_until( volume_test_players(tv_e7m1_objective_exit) or (f_e7m1_barriers_deactivated_cnt() > 0) or (f_e7m1_objective() > DEF_E7M1_OBJECTIVE_EXIT_BLIP), 1 );
			f_e7m1_objective( DEF_E7M1_OBJECTIVE_BARRIER );

			sleep_until( f_e7m1_barriers_deactivated_cnt() > 0, 1 );
			spops_audio_music_event( 'play_mus_pve_e07m1_objective_exit_blip_end', "play_mus_pve_e07m1_objective_exit_blip_end" );
			spops_blip_flag( flg_e7m1_objective_exit, FALSE );
			
		end

		spops_audio_music_event( 'play_mus_pve_e07m1_objective_exit_end', "play_mus_pve_e07m1_objective_exit_end" );
	end
	f_e7m1_objective( DEF_E7M1_OBJECTIVE_BARRIER );



end

// === f_e7m1_objective_barrier_trigger::: Triggers
script dormant f_e7m1_objective_barrier_trigger()
	//dprint( "f_e7m1_objective_barrier_trigger" );
	
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_BARRIER, 1 );
	if ( (f_e7m1_objective() == DEF_E7M1_OBJECTIVE_BARRIER) and (f_e7m1_barriers_deactivated_cnt() == 0) ) then
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_barrier_start', "play_mus_pve_e07m1_objective_barrier_start" );

		wake( f_e7m1_dialog_barrier_start );
		sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_BARRIER_BLIP, 1 );

		if ( f_e7m1_barriers_deactivated_cnt() == 0 ) then
			//local long l_blip_thread = 0;
			B_e7m1_objective_barrier_blipped = TRUE;
			f_new_objective( e7_m1_objective_barrier_deactivate );
			//l_blip_thread = spops_blip_auto_flag_trigger( flg_e7m1_objective_exit, "default", tv_e7m1_objective_exit, FALSE );
			//spops_blip_auto_object_trigger( cr_e7m1_power_1a_to_2a, "neutralize_health", tv_e7m1_objective_exit, TRUE, l_blip_thread );
			//spops_blip_auto_object_trigger( cr_e7m1_power_1a_to_3b, "neutralize_health", tv_e7m1_objective_exit, TRUE, l_blip_thread );
			spops_audio_music_event( 'play_mus_pve_e07m1_objective_barrier_blip_start', "play_mus_pve_e07m1_objective_barrier_blip_start" );

			sleep_until( f_e7m1_barriers_deactivated_cnt() > 0, 1 );
			//kill_thread( l_blip_thread );
			spops_audio_music_event( 'play_mus_pve_e07m1_objective_barrier_blip_end', "play_mus_pve_e07m1_objective_barrier_blip_end" );

		end

		spops_audio_music_event( 'play_mus_pve_e07m1_objective_barrier_end', "play_mus_pve_e07m1_objective_barrier_end" );
	end
	f_e7m1_objective( DEF_E7M1_OBJECTIVE_LZ );

end

// === f_e7m1_objective_lz_trigger::: Triggers
script dormant f_e7m1_objective_lz_trigger()
	//dprint( "f_e7m1_objective_lz_trigger" );

	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_LZ, 1 );
	
	if ( f_e7m1_objective() < DEF_E7M1_OBJECTIVE_PICKUP ) then

		wake( f_e7m1_dialog_lz_start );
		f_new_objective( e7_m1_objective_lz_rendezvous );
		local long l_blip_thread = 0;
		
		l_blip_thread = spops_blip_auto_flag_trigger( flg_e7m1_objective_lz, "default", tv_e7m1_objective_lz, FALSE );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_lz_start', "play_mus_pve_e07m1_objective_lz_start" );
		
		sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PICKUP, 1 );
		kill_thread( l_blip_thread );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_lz_end', "play_mus_pve_e07m1_objective_lz_end" );

	end

end

// === f_e7m1_objective_lz_clear_trigger::: Triggers
script dormant f_e7m1_objective_lz_clear_trigger()
	//dprint( "f_e7m1_objective_lz_clear_trigger" );

	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_LZ_CLEAR, 1 );

	if ( f_e7m1_objective() == DEF_E7M1_OBJECTIVE_LZ_CLEAR ) then
	
		//dprint( "f_e7m1_objective_lz_clear_trigger" );
		f_new_objective( e7_m1_objective_lz_clear );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_lz_clear_start', "play_mus_pve_e07m1_objective_lz_clear_start" );

		sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PICKUP, 1 );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_lz_clear_end', "play_mus_pve_e07m1_objective_lz_clear_end" );

	end

end

// === f_e7m1_objective_phantom_help_trigger::: Triggers
script dormant f_e7m1_objective_phantom_help_trigger()
local long l_blip_thread = 0;
	//dprint( "f_e7m1_objective_phantom_help_trigger" );

	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PHANTOM_HELP, 1 );
	
	if ( f_e7m1_ai_phantom_enemy_turrets_active() ) then
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_phantom_help_start', "play_mus_pve_e07m1_objective_phantom_help_start" );

		// set objective
		f_new_objective( e7_m1_objective_phantom_defend );
	//	f_new_objective( e7_m1_objective_phantom_turrets );

		// get a thread to hold onto
		l_blip_thread = thread( sys_spops_blip_auto_thread() );

		// blip main phantom
		spops_blip_object( vh_e7m1_phantom_enemy, TRUE, "neutralize_health" );
		
		if ( object_get_health(obj_e7m1_phantom_enemy_turret) > 0.0 ) then
			sys_spops_blip_auto_phantom_help( obj_e7m1_phantom_enemy_turret, l_blip_thread );
		end
		if ( ai_living_count(sq_e7m1_phantom_enemy_01.gunner_01) > 0 ) then
			sys_spops_blip_auto_phantom_help( ai_get_object(sq_e7m1_phantom_enemy_01.gunner_01), l_blip_thread );
		end
		if ( ai_living_count(sq_e7m1_phantom_enemy_01.gunner_02) > 0 ) then
			sys_spops_blip_auto_phantom_help( ai_get_object(sq_e7m1_phantom_enemy_01.gunner_02), l_blip_thread );
		end
		
		sleep_until( B_e7m1_phantom_fight_complete, 1 );
		kill_thread( l_blip_thread );
		spops_unblip_object( vh_e7m1_phantom_enemy );
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_phantom_help_end', "play_mus_pve_e07m1_objective_phantom_help_end" );
		
		// re-establish lz objective
		if ( not B_e7m1_objective_lz_cleared ) then
			f_new_objective( e7_m1_objective_lz_clear );
		end

	end
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_phantom_help( object obj_target, long l_thread )
	thread( sys_spops_blip_auto_phantom_help(player0, obj_target, l_thread) );
	thread( sys_spops_blip_auto_phantom_help(player1, obj_target, l_thread) );
	thread( sys_spops_blip_auto_phantom_help(player2, obj_target, l_thread) );
	thread( sys_spops_blip_auto_phantom_help(player3, obj_target, l_thread) );
end
script static void sys_spops_blip_auto_phantom_help( player p_player, object obj_target, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_phantom_help_blip(p_player, obj_target, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
			// store blip condition
			b_blip = sys_spops_blip_auto_phantom_help_blip( p_player, obj_target, l_thread );
			
			// blip
			sys_spops_blip_auto_object( p_player, obj_target, "neutralize_health", "", b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)) or (object_get_health(obj_target) <= 0.0)) and (not b_blip), 1 );
	
	end

end
script static boolean sys_spops_blip_auto_phantom_help_blip( player p_player, object obj_target, long l_thread )
	( object_get_health(vh_e7m1_phantom_enemy) > 0.0 ) and ( objects_can_see_object(p_player, vh_e7m1_phantom_enemy, 30.0) ) and ( object_get_health(obj_target) > 0.0 ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// === f_e7m1_objective_pickup_trigger::: Triggers
script dormant f_e7m1_objective_pickup_trigger()
local long l_blip_thread = 0;
	//dprint( "f_e7m1_objective_pickup_trigger" );

	// start objective
	//	blip
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PICKUP, 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_objective_pickup_start', "play_mus_pve_e07m1_objective_pickup_start" );
	
	sleep_until( B_e7m1_phantom_pickup_ready, 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_objective_pickup_ready', "play_mus_pve_e07m1_objective_pickup_ready" );
	f_new_objective( e7_m1_objective_phantom_rendezvous );
	spops_blip_object( vh_e7m1_phantom_ally, TRUE, "default" );

end

// === f_e7m1_objective::: xxx
script static void f_e7m1_objective( short s_val, real r_delay )

	// delay
	if ( (s_val > S_e7m1_objective) and (r_delay > 0.0) ) then
		sleep_s( r_delay );
	end
	
	// set
	if ( s_val > S_e7m1_objective ) then
		//dprint( "f_e7m1_objective" );
		//inspect( s_val );
		S_e7m1_objective = s_val;
	end
	
end
script static void f_e7m1_objective( short s_val )
	f_e7m1_objective( s_val, 0.0 );
end
script static short f_e7m1_objective()
	S_e7m1_objective;
end

// === f_e7m1_objective::: xxx
script static void f_e7m1_objective_wait( short s_objective, boolean b_condition )
	sleep_until( (s_objective == f_e7m1_objective()) == b_condition, 1 );
end
script static void f_e7m1_objective_wait( short s_objective )
	f_e7m1_objective_wait( s_objective, TRUE );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: RESPAWN***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_respawn_cnt = 		0;
static short S_e7m1_respawn_max = 		3;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_respawn_manage::: Manages a respawn folder
script static void f_e7m1_respawn_manage( folder fld_respawn, trigger_volume tv_volume, real r_objcon_min, real r_objcon_max, object_name obj_reference, short s_respawn_max, ai ai_enemy_task, boolean b_enemy_task_ignore, ai ai_enemy_combat_task, boolean b_combat_task_ignore )
static real r_distance = 0.0;
local real r_distance_ref = 0.0;

	// wait for mission to start
	sleep_until( f_spops_mission_identified(), 1 );
	
	if ( f_spops_mission_identified(DEF_E7M1_MISSION_ID) ) then

		// wait for basic triggers
		sleep_until( ((R_e7m1_objcon >= r_objcon_min) and (volume_test_players(tv_volume))) or (R_e7m1_objcon >= r_objcon_max), 10 );
		
		// wait for area to clear
		sleep_until( ((b_enemy_task_ignore or (ai_task_count(ai_enemy_task) <= 0)) and (b_combat_task_ignore or (ai_task_count(ai_enemy_combat_task) <= 0))) or (R_e7m1_objcon >= r_objcon_max), 10 );
		
		if ( (R_e7m1_objcon < r_objcon_max) or (r_objcon_max < 0) ) then
			//dprint( "f_e7m1_respawn_manage: CREATE" );
			//inspect( r_objcon_min );
			//inspect( b_enemy_task_ignore );
			//inspect( ai_task_count(ai_enemy_task) );
			//inspect( b_combat_task_ignore );
			//inspect( ai_task_count(ai_enemy_combat_task) );
			
			// set max
			if ( s_respawn_max > 0 ) then
				sys_e7m1_respawn_max( s_respawn_max );
			end
			
			// increment counter
			sys_e7m1_respawn_inc( 1 );
			
			// create folder
			object_create_folder_anew( fld_respawn );	
			
			if ( r_objcon_max > 0 ) then
	
				repeat
				
					// wait for set to become invalid
					sleep_until( ((R_e7m1_objcon >= r_objcon_max) or (sys_e7m1_respawn_cnt() > sys_e7m1_respawn_max())) and (sys_e7m1_respawn_cnt() > 1) and (spops_player_living_cnt() > 0) and (objects_distance_to_flag(obj_reference, flg_e7m1_objective_lz) > r_distance), 10 );
					
					// get the farthest distance set
					r_distance = objects_distance_to_flag( obj_reference, flg_e7m1_objective_lz );
					r_distance_ref = r_distance;
					sleep( 1 );
					
					// if this set is farthest
					if ( r_distance == r_distance_ref ) then
						//dprint( "f_e7m1_respawn_manage: DESTROY" );
						//inspect( r_objcon_min );
						// decrement counter
						sys_e7m1_respawn_inc( -1 );
						
						// reset distance
						r_distance = 0.0;
		
						// distroy the folder
						object_destroy_folder( fld_respawn );
						sleep_until( not object_valid(obj_reference), 1 );
					end
				
				until( not object_valid(obj_reference), 1 );
	
			end
			
		end
		
		//dprint( "f_e7m1_respawn_manage: EXIT" );
		//inspect( r_objcon_min );	
	
	end
	
end

// === f_e7m1_respawn_manage::: Gets the respawn cnt
script static short sys_e7m1_respawn_cnt()
	S_e7m1_respawn_cnt;
end

// === sys_e7m1_respawn_max::: Set/get the respawn max
script static void sys_e7m1_respawn_max( short s_max )

	if ( S_e7m1_respawn_max != s_max ) then
		//dprint( "sys_e7m1_respawn_max:" );
		//inspect( s_max );
		S_e7m1_respawn_max = s_max;
	end

end
script static short sys_e7m1_respawn_max()
	S_e7m1_respawn_max;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_e7m1_respawn_cnt( short s_cnt )

	if ( S_e7m1_respawn_cnt != s_cnt ) then
		//dprint( "sys_e7m1_respawn_cnt:" );
		//inspect( s_cnt );
		S_e7m1_respawn_cnt = s_cnt;
	end

end
script static void sys_e7m1_respawn_inc( short s_inc )
	//dprint( "sys_e7m1_respawn_inc:" );
	//inspect( s_inc );
	sys_e7m1_respawn_cnt( S_e7m1_respawn_cnt + s_inc );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: PORTALS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_portal_switched_cnt = 		0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_portals_init::: Init
script dormant f_e7m1_portals_init()
	//dprint( "f_e7m1_portals_init" );

	//thread( f_e7m1_portal_setup(dc_e8_m1_switch1, dm_e8_m1_portal1, dm_e8_m1_switch1, dm_e8_m1_aperature1, kill_portal_1) );
	thread( f_e7m1_portal_setup(dc_e8_m1_switch2, dm_e8_m1_portal2, dm_e8_m1_switch2, dm_e8_m1_aperature2, kill_portal_2) );
	thread( f_e7m1_portal_setup(dc_e8_m1_switch3, dm_e8_m1_portal3, dm_e8_m1_switch3, dm_e8_m1_aperature3, kill_portal_3) );

end
script static void f_e7m1_portal_setup( object_name dc_switch, object_name dm_portal, object_name dm_switch, object_name dm_aperature, trigger_volume tv_kill )
	//dprint( "f_e7m1_portal_setup" );
	
	// create objects
	object_create( dm_portal );
	object_create( dm_switch );
	object_create( dm_aperature );
	object_create( dc_switch );
	//kill_volume_disable( tv_kill );

	// start portal fx
	sleep_until( object_valid(dm_portal), 1 );
	effect_new_on_object_marker( 'levels\dlc\ff154_hillside\effects\teleport_lg_portal_no_shake_hillside.effect', dm_portal, "portal" );

	// switch the aperature to the same position as Greg's mission
	//sleep_until( object_valid(dm_aperature), 1 );
	//device_set_position( device(dm_aperature), 1.0 );

	sleep_until( object_valid(dc_switch), 1 );
	device_set_power( device(dc_switch), 1.0 );

	// wait for device control trigger
	sleep_until( device_get_position(device(dc_switch)) > 0.0, 1 );
	device_set_power( device(dc_switch), 0.0 );

	// switch the portal	
	f_e8_m1_portal_switch( device(dm_switch), dm_portal, device(dm_aperature), tv_kill );
	S_e7m1_portal_switched_cnt = S_e7m1_portal_switched_cnt + 1;
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: PROPS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_props_init::: Init
script dormant f_e7m1_props_init()
	//dprint( "f_e7m1_props_init" );

	// create blockers
	object_create( sn_e10_m3_start_door );
	object_create( sn_e10_m3_start_door0 );
	object_create( sn_e10_m3_skylight );
	object_create( sn_e10_m3_west_tun_blocker );
	object_create( sc_e8_m1_cave_blocker3 );
	object_create( sn_e10_m3_west_tun_blocker0 );

	// crates & scenery
	object_create_folder( fld_e7m1_scenery_base );
	object_create_folder( fld_e7m1_crates_base );
	object_create_folder( fld_e7m1_crates_barriers_energy );
	object_create_folder( fld_e7m1_crates_barriers_cov );
	object_create_folder( fld_e7m1_crates_racks );
	
	// vehicles
	object_create_folder( fld_e7m1_vehicles_base );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: ORDNANCE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_e7m1_ornance_distance_player_min = 												0.75;
static real R_e7m1_ornance_distance_ai_min = 														0.25;
static short S_e7m1_ornance_active_cnt = 																0;
static real R_e7m1_ornance_marker_time = 																60.0;
static boolean B_e7m1_ornance_dropping = 																FALSE;
static short S_e7m1_ornance_cnt = 																			0;
static short S_e7m1_ornance_basic_cnt = 																0;
static short S_e7m1_ornance_grenade_cnt = 															0;
static short S_e7m1_ornance_heavy_cnt = 																0;
static short S_e7m1_ornance_armor_cnt = 																0;
static short S_e7m1_ornance_level_min = 																1;
static short S_e7m1_ornance_level_max = 																3;
static real R_e7m1_ordnance_drop_post_delay = 													0.25;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_e7m1_ordnance_init::: Init
script dormant f_e7m1_ordnance_init()
	//dprint( "f_e7m1_ordnance_init" );
	
	// set the drop pod object
	ordnance_set_droppod_object( 'levels\dlc\ff154_hillside\props\e7m1\spops_ordnance_e7m1\unsc_weapons_pod_e7m1.scenery', 'objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect' );
	
	// setup Trigger
	wake( f_e7m1_ordnance_trigger );
	
end

// === f_e7m1_ordnance_trigger::: General trigger for ordnance
script dormant f_e7m1_ordnance_trigger()
local long l_timer_min = 0;
local long l_timer_max = 0;
local real r_obj_con_min = 0.0;
	//dprint( "f_e7m1_ordnance_trigger" );

	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C, 10 );
	//dprint( "f_e7m1_ordnance_trigger: 4C" );
	sleep_s( 0.25, 1.0 );
	r_obj_con_min = f_e7m1_ordnance_drop( 1 );
	r_obj_con_min = bound_r( r_obj_con_min + 0.5, r_obj_con_min, DEF_E7M1_AI_OBJCON_AREA_8A );
	l_timer_min = timer_stamp( 45.0 );
	l_timer_max = timer_stamp( 90.0 );

	sleep_until( (R_e7m1_objcon >= r_obj_con_min) or timer_expired(l_timer_max), 1 );
	sleep_until( B_e7m1_phantom_fight_start and timer_expired(l_timer_min), 1 );
	sleep_s( 0.25, 1.0 );
	r_obj_con_min = f_e7m1_ordnance_drop( 2 );
	r_obj_con_min = bound_r( r_obj_con_min + 0.5, r_obj_con_min, DEF_E7M1_AI_OBJCON_AREA_8A );
	l_timer_min = timer_stamp( 60.0 );
	l_timer_max = timer_stamp( 120.0 );

	sleep_until( (R_e7m1_objcon >= r_obj_con_min) or timer_expired(l_timer_max), 1 );
	sleep_until( (f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PHANTOM_HELP) and timer_expired(l_timer_min), 10 );
	sleep_s( 0.25, 1.0 );
	f_e7m1_ordnance_drop( 3 );

end

// === f_e7m1_ordnance_drop::: Manages dropping ordnance
script static real f_e7m1_ordnance_drop( short s_level )
local long l_thread = 0;
local real r_objcon = DEF_E7M1_AI_OBJCON_AREA_START;
static boolean b_placed_4c = FALSE;
static boolean b_placed_4e = FALSE;
static boolean b_placed_4f = FALSE;
static boolean b_placed_5a = FALSE;
static boolean b_placed_5b = FALSE;
static boolean b_placed_5c = FALSE;
static boolean b_placed_6a = FALSE;
static boolean b_placed_6c = FALSE;
static boolean b_placed_7a = FALSE;
static boolean b_placed_7b = FALSE;
static boolean b_placed_8a_a = FALSE;
static boolean b_placed_8a_b = FALSE;
local boolean b_placed = FALSE;

	// wait for no other areas to be dropping
	sleep_until( not B_e7m1_ornance_dropping, 1 );
	B_e7m1_ornance_dropping = TRUE;
	S_e7m1_ornance_active_cnt = S_e7m1_ornance_active_cnt + 1;
	//dprint( "f_e7m1_ordnance_drop: START" );
	//inspect( s_level );
	
	// make sure players are alive
	sleep_until( spops_player_living_cnt() > 0, 1 );
	if ( (not B_e7m1_objective_lz_cleared) or (not B_e7m1_phantom_fight_complete) ) then
		l_thread = thread( f_e7m1_dialog_ordnance(s_level) );
	end
	
	// set the counts
	//dprint( "f_e7m1_ordnance_drop: COUNTS" );
	if ( s_level == 1 ) then
		S_e7m1_ornance_basic_cnt = bound_s( game_coop_player_count() * 2.0, 1, 2 );
		S_e7m1_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_heavy_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 2 );
	end
	if ( s_level == 2 ) then
		S_e7m1_ornance_basic_cnt = bound_s( game_coop_player_count(), 2, 3 );
		S_e7m1_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_heavy_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 1 );
	end
	if ( s_level == 3 ) then
		S_e7m1_ornance_basic_cnt = bound_s( game_coop_player_count(), 2, 3 );
		S_e7m1_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_heavy_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e7m1_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 1 );
	end
	S_e7m1_ornance_cnt = S_e7m1_ornance_basic_cnt + S_e7m1_ornance_grenade_cnt + S_e7m1_ornance_heavy_cnt + S_e7m1_ornance_armor_cnt;
	//inspect( S_e7m1_ornance_cnt );
	
	// wait for dialog to finish
	//dprint( "f_e7m1_ordnance_drop: WAITING" );
	sleep_until( not isthreadvalid(l_thread), 1 );
	//dprint( "f_e7m1_ordnance_drop: DROPPING" );

	// get player furthest along area
	r_objcon = f_e7m1_ai_objcon_trigger_player_furthest();
	
	// if furthest is not far enough, drop at objcon
	if ( r_objcon < DEF_E7M1_AI_OBJCON_AREA_4C ) then
		r_objcon = R_e7m1_objcon;
	end

		// start dropping
	//dprint( "f_e7m1_ordnance_drop: DROPPING" );
	//inspect( r_objcon );
	
	// setup marker blips
	if ( S_e7m1_ornance_active_cnt == 1 ) then
		ordnance_show_nav_markers( TRUE );
	end
	
	// drop
	if ( (not b_placed) and (not b_placed_4c) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_4D) ) then
		b_placed_4c = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_4D;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4c_13 );
		end
	end
	if ( (not b_placed) and (not b_placed_4e) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_4E) ) then
		b_placed_4e = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_4E;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_13 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_14 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_15 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_16 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4e_17 );
		end
	end
	if ( (not b_placed) and (not b_placed_4f) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_4F) ) then
		b_placed_4f = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_4F;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_13 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_4f_14 );
		end
	end
	if ( (not b_placed) and (not b_placed_5a) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_5A) ) then
		b_placed_5a = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_5A;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5a_12 );
		end
	end
	if ( (not b_placed) and (not b_placed_5b) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_5B) ) then
		b_placed_5b = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_5B;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_13 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5b_14 );
		end
	end
	if ( (not b_placed) and (not b_placed_5c) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_5C) ) then
		b_placed_5c = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_5C;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_5c_13 );
		end
	end
	if ( (not b_placed) and (not b_placed_6a) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_6B) ) then
		b_placed_6a = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_6B;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6a_12 );
		end
	end
	if ( (not b_placed) and (not b_placed_6c) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_6C) ) then
		b_placed_6c = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_6C;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_6c_11 );
		end
	end
	if ( (not b_placed) and (not b_placed_7a) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_7A) ) then
		b_placed_7a = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_7A;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7a_13 );
		end
	end
	if ( (not b_placed) and (not b_placed_7b) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_7C) ) then
		b_placed_7b = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_7C;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_13 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_14 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_15 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_7b_16 );
		end
	end
	if ( (not b_placed) and (not b_placed_8a_a) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_8A) ) then
		b_placed_8a_a = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_8A;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_a_13 );
		end
	end
	if ( (not b_placed) and (not b_placed_8a_b) and (r_objcon <= DEF_E7M1_AI_OBJCON_AREA_8A) ) then
		b_placed_8a_b = TRUE;
		b_placed = TRUE;
		r_objcon = DEF_E7M1_AI_OBJCON_AREA_8A;
		begin_random
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_01 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_02 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_03 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_04 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_05 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_06 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_07 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_08 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_09 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_10 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_11 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_12 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_13 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_14 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_15 );
			sys_e7m1_ordnance_drop_send( s_level, flg_e7m1_ordnance_8a_b_16 );
		end
	end

	B_e7m1_ornance_dropping = FALSE;
	
	//dprint( "f_e7m1_ordnance_drop: POST" );
	sleep_s( R_e7m1_ornance_marker_time );

	S_e7m1_ornance_active_cnt = S_e7m1_ornance_active_cnt - 1;
	if ( S_e7m1_ornance_active_cnt == 0 ) then
		if ( r_objcon < DEF_E7M1_AI_OBJCON_AREA_8A ) then
			//dprint( "f_e7m1_ordnance_drop: SHUTDOWN WAIT" );
			sleep_until( R_e7m1_objcon > r_objcon, 1 );
		end
		//dprint( "f_e7m1_ordnance_drop: SHUTDOWN" );
		ordnance_show_nav_markers( FALSE );
	end

	r_objcon;
end

script static void sys_e7m1_ordnance_drop_send( short s_level, cutscene_flag flg_loc )
local string_id sid_drop = NONE;

	if ( (S_e7m1_ornance_cnt > 0) and ((not B_e7m1_objective_lz_cleared) or (not B_e7m1_phantom_fight_complete)) and ((spops_player_living_cnt() <= 0) or (objects_distance_to_flag(Players(),flg_loc) > R_e7m1_ornance_distance_player_min)) and ((objects_distance_to_flag(ai_actors(ai_ff_all),flg_loc) > R_e7m1_ornance_distance_ai_min) or (ai_living_count(ai_ff_all) <= 0)) ) then

		if ( (sid_drop == NONE) and (S_e7m1_ornance_heavy_cnt > 0) ) then
			sid_drop = sys_e7m1_ordnance_drop_heavy( s_level );
			if ( sid_drop != NONE ) then
				S_e7m1_ornance_heavy_cnt = S_e7m1_ornance_heavy_cnt - 1;
			end
		end

		// get an ordnance to drop
		if ( sid_drop == NONE ) then

			begin_random
		
				begin
					if ( (sid_drop == NONE) and (S_e7m1_ornance_grenade_cnt > 0) ) then
						sid_drop = sys_e7m1_ordnance_drop_grenade( s_level );
						if ( sid_drop != NONE ) then
							S_e7m1_ornance_grenade_cnt = S_e7m1_ornance_grenade_cnt - 1;
						end
					end
				end
				begin
					if ( (sid_drop == NONE) and (S_e7m1_ornance_basic_cnt > 0) ) then
						sid_drop = sys_e7m1_ordnance_drop_basic( s_level );
						if ( sid_drop != NONE ) then
							S_e7m1_ornance_basic_cnt = S_e7m1_ornance_basic_cnt - 1;
						end
					end
				end
				begin
					if ( (sid_drop == NONE) and (S_e7m1_ornance_armor_cnt > 0) ) then
						sid_drop = sys_e7m1_ordnance_drop_armor( s_level );
						if ( sid_drop != NONE ) then
							S_e7m1_ornance_armor_cnt = S_e7m1_ornance_armor_cnt - 1;
						end
					end
				end
		
			end

		end

		// do the drop	
		if ( sid_drop != NONE ) then
			ordnance_drop( flg_loc, sid_drop );
			S_e7m1_ornance_cnt = S_e7m1_ornance_cnt - 1;
			if ( S_e7m1_ornance_cnt != 0 ) then
				sleep_s( R_e7m1_ordnance_drop_post_delay );
			end
		end
	
	end

end

script static string_id sys_e7m1_ordnance_drop_basic( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	if ( not B_e7m1_objective_lz_cleared ) then

		begin_random
			sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_assault_rifle', sid_drop, sid_drop_last );
			sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_battle_rifle', sid_drop, sid_drop_last );
			sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_dmr', sid_drop, sid_drop_last );
		end

	end

	// store last drop
	sid_drop_last = sid_drop;

	// return
	sid_drop;
end

script static string_id sys_e7m1_ordnance_drop_grenade( short s_level )
	// return
	if ( not B_e7m1_objective_lz_cleared ) then
		'grenade_doublefrag';
	else
		NONE;
	end
end

script static string_id sys_e7m1_ordnance_drop_heavy( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	begin_random
		sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_sniper_rifle', sid_drop, sid_drop_last, s_level, S_e7m1_ornance_level_min, 2, TRUE, B_e7m1_objective_lz_cleared, FALSE );
		sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_rail_gun', sid_drop, sid_drop_last, s_level, 2, S_e7m1_ornance_level_max, TRUE, ai_living_count(sq_e7m1_phantom_enemy_01) > 0, TRUE  );
		sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_lmg', sid_drop, sid_drop_last, s_level, S_e7m1_ornance_level_min, S_e7m1_ornance_level_max, TRUE, B_e7m1_objective_lz_cleared, FALSE );
	end

	// store last drop
	sid_drop_last = sid_drop;

	// return
	sid_drop;
end

script static string_id sys_e7m1_ordnance_drop_armor( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	begin_random
		sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_active_shield', sid_drop, sid_drop_last, s_level, S_e7m1_ornance_level_min, S_e7m1_ornance_level_max, TRUE, B_e7m1_objective_lz_cleared, FALSE );
		//sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_forerunner_vision', sid_drop, sid_drop_last, s_level, S_e7m1_ornance_level_min, S_e7m1_ornance_level_max, TRUE, (not B_e7m1_objective_lz_cleared) and (f_e7m1_changer_cnt() > 0), TRUE );
		sid_drop = sys_e7m1_ordnance_drop_obj_check( 'storm_auto_turret', sid_drop, sid_drop_last, s_level, 2, S_e7m1_ornance_level_max, TRUE, B_e7m1_objective_lz_cleared, FALSE );
	end

	// store last drop
	sid_drop_last = sid_drop;

	// return
	sid_drop;
end

script static string_id sys_e7m1_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last, short s_level, short s_level_min, short s_level_max, boolean b_level_test, boolean b_condition, boolean b_condition_test )

	if ( (sid_current == NONE) and ((sid_object != sid_last) or (sid_last == NONE)) and (b_condition == b_condition_test) and (((s_level_min <= s_level) and (s_level <= s_level_max)) == b_level_test) ) then
		sid_current = sid_object;
	end
	
	sid_current;
end
script static string_id sys_e7m1_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last, short s_level, short s_level_min, short s_level_max, boolean b_level_test )
	sys_e7m1_ordnance_drop_obj_check( sid_object, sid_current, sid_last, s_level, s_level_min, s_level_max, b_level_test, TRUE, TRUE );
end
script static string_id sys_e7m1_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last )
	sys_e7m1_ordnance_drop_obj_check( sid_object, sid_current, sid_last, -1, S_e7m1_ornance_level_min, S_e7m1_ornance_level_max, FALSE, TRUE, TRUE );
end



//gmurphy 1/08/2013 -- bug 7904
global short s_garbage_cleanup_sec = 0;

script static void f_e7m1_garbage_cleanup
	print ("garbage cleanup every 2 seconds starting");
	
	s_garbage_cleanup_sec = firefight_mode_get_user_data (0);
	
	if s_garbage_cleanup_sec > 0 then
	
		repeat
			sleep_until (ai_living_count (gr_e7m1_pool_fore_crawler) > 0 or ai_living_count (gr_e7m1_pool_fore_watcher) > 0, 30 * s_garbage_cleanup_sec);
			print ("garbage cleanup unsafe starting now");
			garbage_collect_unsafe();
			
		until (false, 1);
	
	end
	
	print ("garbage cleanup stop");

end