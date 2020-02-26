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
// === f_e7m1_ai_init::: Init
script dormant f_e7m1_ai_init()
	//dprint( "f_e7m1_ai_init" );

	// initial allignments
	ai_allegiance( covenant, forerunner );
	ai_allegiance( forerunner, covenant );
	
	// init garbage
	spops_ai_garbage_distance_conditional_default( 15.0 );
	spops_ai_garbage_distance_force_default( 32.5 );
	spops_ai_garbage_combat_status_max_default( ai_combat_status_active );
	//spops_ai_garbage_debug_blip( "enemy" );

	// initialize modules
	wake( f_e7m1_ai_areas_init );
	
	// initialize sub-modules
	wake( f_e7m1_ai_portal_init );
	sleep(1);
	wake( f_e7m1_ai_objcon_init );
	sleep(1);
	wake( f_e7m1_ai_body_count_init );
	sleep(1);
	wake( f_e7m1_ai_phantoms_init );
	sleep(1);
	wake( f_e7m1_ai_turrets_init );
	
	// setup trigger
	sleep(1);
	wake ( f_e7m1_ai_trigger );
	
end

// === f_e7m1_ai_trigger::: Trigger
script dormant f_e7m1_ai_trigger()
	//dprint( "f_e7m1_ai_trigger" );

	sleep_until( f_spops_mission_start_complete(), 6 );
	//dprint( "f_e7m1_ai_trigger: START COMPLETE" );
	ai_exit_limbo( ai_ff_all );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: PORTAL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_portal_init::: Init
script dormant f_e7m1_ai_portal_init()
	//dprint( "f_e7m1_ai_portal_init" );
	
	// place portal ai
	ai_place( gr_e7m1_portal );

end

// === f_e7m1_ai_portal_trigger::: Init
script dormant f_e7m1_ai_portal_trigger()
	//dprint( "f_e7m1_ai_portal_trigger" );

	sleep_until( ai_task_count(objectives_e7m1_portal.enemy_combat_gate) > 0, 6 );
	spops_audio_music_event( 'play_mus_pve_e07m1_encounter_area_portal_start', "play_mus_pve_e07m1_encounter_area_portal_start" );

	sleep_until( ai_task_count(objectives_e7m1_portal.enemy_gate) <= 0, 10 );
	spops_audio_music_event( 'play_mus_pve_e07m1_encounter_area_portal_end', "play_mus_pve_e07m1_encounter_area_portal_end" );

end

script static boolean f_e7m1_ai_portal_advance_to_1a_check()
	( ai_task_count('objectives_e7m1_area_1a.enemy_combat_gate') > 0 ) or ( ai_body_count('objectives_e7m1_area_1a.enemy_gate') > 0 );
end

script command_script cs_e7m1_ai_portal_advance_to_1A_action()
	f_e7m1_ai_area_advance_to( ai_current_actor, 'objectives_e7m1_area_1a' );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: TURRETS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_turrets_init::: Init
script dormant f_e7m1_ai_turrets_init()
	//dprint( "f_e7m1_ai_turrets_init" );

	wake( f_e7m1_ai_turrets_trigger );

end

// === f_e7m1_ai_turrets_trigger::: Trigger
script dormant f_e7m1_ai_turrets_trigger()
	//dprint( "f_e7m1_ai_turrets_trigger" );

	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A );
	wake( f_e7m1_ai_turrets_1a_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A );
	wake( f_e7m1_ai_turrets_2a_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B );
	wake( f_e7m1_ai_turrets_3b_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A );
	wake( f_e7m1_ai_turrets_4a_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F );
	wake( f_e7m1_ai_turrets_4f_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A );
	wake( f_e7m1_ai_turrets_5a_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C );
	wake( f_e7m1_ai_turrets_5c_cleanup );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A );
	wake( f_e7m1_ai_turrets_6a_cleanup );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_1a_cleanup()

	sleep_until( f_e7m1_ai_area_1a_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_01a_a );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_2a_cleanup()

	sleep_until( f_e7m1_ai_area_2a_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_02a_b );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_3b_cleanup()

	sleep_until( f_e7m1_ai_area_3b_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_03b_a );
	f_e7m1_ai_turrets_disable( tr_area_03b_b );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_4a_cleanup()

	sleep_until( f_e7m1_ai_area_4a_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_04a_a );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_4f_cleanup()

	sleep_until( f_e7m1_ai_area_4f_retreat_check(), 10 );
	f_e7m1_ai_turrets_tower_disable( cr_e7m1_watchtower_4f_top );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_5a_cleanup()

	sleep_until( f_e7m1_ai_area_5a_retreat_check(), 10 );
	f_e7m1_ai_turrets_tower_disable( cr_e7m1_watchtower_5a_top );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_5c_cleanup()

	sleep_until( f_e7m1_ai_area_5c_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_05c_a );

end

// === xxx::: Cleans up an areas turrets
script dormant f_e7m1_ai_turrets_6a_cleanup()

	sleep_until( f_e7m1_ai_area_6a_retreat_check(), 10 );
	f_e7m1_ai_turrets_disable( tr_area_06a_a );
	f_e7m1_ai_turrets_tower_disable( cr_e7m1_watchtower_6a_top );

end

// === xxx::: Disables a turret
script static void f_e7m1_ai_turrets_disable( vehicle vh_turret )

	if ( unit_get_health(vh_turret) > 0.0 ) then
	
		ai_vehicle_reserve( vh_turret, TRUE );
		vehicle_unload( vh_turret, "" );
		
	end

end

// === xxx::: Cleans up an areas turrets
script static void f_e7m1_ai_turrets_tower_disable( object obj_top )

	if ( object_get_health(obj_top) > 0.0 ) then
	
		f_e7m1_ai_turrets_disable( vehicle(object_at_marker(obj_top, 'plasma_turret_01')) );
		f_e7m1_ai_turrets_disable( vehicle(object_at_marker(obj_top, 'plasma_turret_02')) );
		f_e7m1_ai_turrets_disable( vehicle(object_at_marker(obj_top, 'plasma_turret_03')) );
		
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: BODY COUNT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e7m1_ai_body_cnt = 						0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_body_count::: Gets the total body count 
script dormant f_e7m1_ai_body_count_init()
local real tmpBodyCount = 0;
S_e7m1_ai_body_cnt = 0;
	repeat
		tmpBodyCount = 	ai_body_count( DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE ) ;
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE ) ;
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE ) ;
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE ) ; 
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE ) ; 
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE ) ; 
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE ) ; 
        sleep(1);
		tmpBodyCount = tmpBodyCount +
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE ) + 
													ai_body_count( DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE );
		S_e7m1_ai_body_cnt = tmpBodyCount;
	until( FALSE, 1 );
end

// === f_e7m1_ai_body_count::: Gets the total body count 
script static short f_e7m1_ai_body_count()
	S_e7m1_ai_body_cnt;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: PHANTOMS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global vehicle vh_e7m1_phantom_ally = 								NONE;
global object obj_e7m1_phantom_ally_turret = 					NONE;
global vehicle vh_e7m1_phantom_enemy = 								NONE;
global object obj_e7m1_phantom_enemy_turret = 				NONE;

global boolean B_e7m1_phantom_ally_drop_in_position = FALSE;
global boolean B_e7m1_phantom_ally_drop_in_ready = 		FALSE;
global boolean B_e7m1_phantom_ally_drop_complete = 		FALSE;

global boolean B_e7m1_phantom_enemy_arrived = 				FALSE;
global boolean B_e7m1_phantom_fight_start = 					FALSE;
global boolean B_e7m1_phantom_fight_complete = 				FALSE;
global boolean B_e7m1_phantom_pickup_ready = 					FALSE;

global boolean B_e7m1_phantom_chase = 								FALSE;

global short S_e7m1_phantom_combat_area =							0;
global short S_e7m1_phantom_combat_height =						0;
global short S_e7m1_phantom_combat_follow =						0;

global real R_e7m1_phantom_ally_abort_health =				0.001;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_phantoms_init::: Init
script dormant f_e7m1_ai_phantoms_init()
	//dprint( "f_e7m1_ai_phantoms_init" );

	// setup trigger
	wake( f_e7m1_ai_phantoms_trigger );

end

// === f_e7m1_ai_phantoms_trigger::: Trigger
script dormant f_e7m1_ai_phantoms_trigger()

	// place starting ally phantom
	//dprint( "f_e7m1_ai_phantoms_trigger: ALLY 01" );
	ai_place( sq_e7m1_phantom_ally_01 );
	sleep_s( 1.0 );

	// place pickup phantom
	sleep_until( (R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A) or (not object_valid(scn_e7m1_barrier_5c_to_6a)) or (ai_living_count(sq_e7m1_phantom_ally_02) > 0), 10 );
	sleep_s( 0.5, 2.5 );
	//dprint( "f_e7m1_ai_phantoms_trigger: ALLY 02" );
	if ( ai_living_count(sq_e7m1_phantom_ally_02) <= 0 ) then
		ai_place( sq_e7m1_phantom_ally_02 );
	end
	f_e7m1_ai_place_loc_max( S_e7m1_ai_place_loc_max - 1 );
	wake( f_e7m1_ai_phantoms_trigger_ally );
	
	// wait to trigger enemy phantom
	sleep_until( B_e7m1_phantom_ally_drop_complete, 6 );
	//dprint( "f_e7m1_ai_phantoms_trigger: DROP COMPLETE" );
	local long l_timer = timer_stamp( 1.0 );
//	local long l_timer = timer_stamp( 10.0 );
	local short s_body_count = ai_body_count( DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE );
	
	// place enemy phantom
	sleep_until( timer_expired(l_timer) or (ai_body_count(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE) > s_body_count), 10 );
	//dprint( "f_e7m1_ai_phantoms_trigger: ENEMY 01" );
	ai_place( sq_e7m1_phantom_enemy_01 );
	f_e7m1_ai_place_loc_max( S_e7m1_ai_place_loc_max - 2 );
	
	// setup triggers for phantoms logic
	wake( f_e7m1_ai_phantoms_trigger_enemy );
	
	// start phantom fight
	sleep_until( B_e7m1_phantom_fight_start, 1 );
	f_e7m1_ai_objcon( DEF_E7M1_AI_OBJCON_AREA_6A );
	wake( f_e7m1_ai_phantom_combat_start );
	
	// area complete
	sleep_until( B_e7m1_objective_lz_cleared and B_e7m1_phantom_fight_complete, 1 );
	wake( f_e7m1_dialog_lz_pickup_01 );
	
	// when pickup objective is set, move the phantom in
	sleep_until( f_e7m1_objective() >= DEF_E7M1_OBJECTIVE_PICKUP, 1 );
	cs_run_command_script( sq_e7m1_phantom_ally_02.pilot, cs_e7m1_ai_phantom_ally_pickup );

end

// === f_e7m1_ai_phantoms_trigger_ally::: Trigger
script dormant f_e7m1_ai_phantoms_trigger_ally()
local long l_blip_thread = 0;
local boolean b_help = FALSE;
local long l_timer = 0;
	//dprint( "f_e7m1_ai_phantoms_trigger_ally" );

	// wait for vehicle to be ready
	sleep_until( vh_e7m1_phantom_ally != NONE, 1 );

	// blip with recent damage defend
	l_blip_thread = spops_blip_auto_object_recent_damage( vh_e7m1_phantom_ally, "defend_health" );

	// wait for the fight to start
	sleep_until( B_e7m1_phantom_fight_start, 1 );
	l_timer = timer_stamp( 120.0 );

	// help
	sleep_until( (object_get_health(vh_e7m1_phantom_ally) <= 0.75) or (R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_8A) or B_e7m1_phantom_fight_complete or (not f_e7m1_ai_phantom_ally_turrets_active()) or B_e7m1_objective_lz_cleared or timer_expired(l_timer), 10 );
	if ( (not f_e7m1_ai_phantom_ally_abort()) and (not B_e7m1_phantom_fight_complete) ) then
		wake( f_e7m1_dialog_phantom_help );
		kill_thread( l_blip_thread );
		sleep( 1 );
		b_help = TRUE;
		spops_blip_object( vh_e7m1_phantom_ally, TRUE, "defend_health" );
	end
	
	// unblip
	sleep_until( B_e7m1_phantom_fight_complete or f_e7m1_ai_phantom_ally_abort(), 6 );
	if ( b_help ) then
		spops_unblip_object( vh_e7m1_phantom_ally );
		sleep( 1 );
		l_blip_thread = spops_blip_auto_object_recent_damage( vh_e7m1_phantom_ally, "defend_health" );
	end
	
	// fail
	sleep_until( f_e7m1_ai_phantom_ally_abort(), 6 );
	if ( (not B_e7m1_objective_lz_cleared) or (not B_e7m1_phantom_fight_complete) ) then
		wake( f_e7m1_dialog_phantom_ally_abort );
		cs_run_command_script( sq_e7m1_phantom_ally_02.pilot, cs_e7m1_ai_phantom_ally_abort );
	end

end

// === f_e7m1_ai_phantoms_trigger_enemy::: Trigger
script dormant f_e7m1_ai_phantoms_trigger_enemy()
	//dprint( "f_e7m1_ai_phantoms_trigger_enemy" );

	// wait for vehicle to be ready
	sleep_until( vh_e7m1_phantom_enemy != NONE, 6 );

	sleep_until( not f_e7m1_ai_phantom_enemy_turrets_active(), 10 );
	if ( not f_e7m1_ai_phantom_ally_abort() ) then
		B_e7m1_phantom_fight_complete = TRUE;
		wake( f_e7m1_dialog_phantom_enemy_complete );
		if ( object_get_health(vh_e7m1_phantom_enemy) > 0.0 ) then
			cs_run_command_script( sq_e7m1_phantom_enemy_01.pilot, cs_e7m1_ai_phantom_enemy_abort );
		end
		
	end

	// wait for phantom to be destroyed
	sleep_until( object_get_health(vh_e7m1_phantom_enemy) <= 0.0, 6 );
	f_e7m1_ai_place_loc_max( S_e7m1_ai_place_loc_max + 3 );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_enemy_phantom_destroyed', "play_mus_pve_e07m1_event_enemy_phantom_destroyed" );

end

// === f_e7m1_ai_phantom_combat_start::: Starts combat
script dormant f_e7m1_ai_phantom_combat_start()
local long l_timer = 0;
	//dprint( "f_e7m1_ai_phantom_combat_start" );
	
	// set starting height
	S_e7m1_phantom_combat_height = 1;

	repeat

		sleep_until( f_e7m1_ai_phantom_ally_abort() and (object_get_health(vh_e7m1_phantom_enemy) > 0.0), 10 );
		// change area
		S_e7m1_phantom_combat_area = random_range( 1, 4 );
		// change height
		if ( not B_e7m1_objective_lz_cleared ) then
			if ( f_chance(25.0) or (S_e7m1_phantom_combat_follow != 0) ) then
				S_e7m1_phantom_combat_follow = random_range( 0, 2 );
			end
			if ( f_chance(50.0) or (S_e7m1_phantom_combat_height == 0) or (S_e7m1_phantom_combat_follow != 0) ) then
				S_e7m1_phantom_combat_height = random_range( 0, 1 );
			end
		else
			S_e7m1_phantom_combat_follow = 2;
			S_e7m1_phantom_combat_height = 0;
		end
		l_timer = timer_stamp( 2.5, 10.0 );
		sleep_until( timer_expired(l_timer), 1 );

	until( f_e7m1_ai_phantom_ally_abort() or (object_get_health(vh_e7m1_phantom_enemy) <= 0.0), 1 );
	
	// reset values
	S_e7m1_phantom_combat_follow = 0;
	S_e7m1_phantom_combat_height = 0;
	S_e7m1_phantom_combat_area = 0;
	
end

script static boolean f_e7m1_ai_phantom_combat_low()
	( (S_e7m1_phantom_combat_height == 0) or (f_e7m1_objective() == DEF_E7M1_OBJECTIVE_PHANTOM_HELP) ) or ( (object_get_health(vh_e7m1_phantom_enemy) <= 0.0) and f_e7m1_ai_phantom_ally_turrets_active() );
end

script static boolean f_e7m1_ai_phantom_ally_turrets_active()
	object_get_health(obj_e7m1_phantom_ally_turret) > 0.0;
end

script static boolean f_e7m1_ai_phantom_enemy_turrets_active()
	(object_get_health(vh_e7m1_phantom_enemy) > 0.0) and ( (object_get_health(obj_e7m1_phantom_enemy_turret) > 0.0) or (ai_living_count(sq_e7m1_phantom_enemy_01.gunner_01) > 0) or (ai_living_count(sq_e7m1_phantom_enemy_01.gunner_02) > 0) );
end

script static boolean f_e7m1_ai_phantom_ally_abort()
	object_get_health(vh_e7m1_phantom_ally) <= R_e7m1_phantom_ally_abort_health;
end

script command_script cs_e7m1_ai_phantom_ally_01()
local vehicle v_phantom = unit_get_vehicle( ai_current_actor );
local long l_timer = 0;

	// open the doors so it feels like the players jumped out
	unit_open( v_phantom );

	// fly to the intial point
	sleep_until( spops_player_living_cnt() > 0, 1 );
	//dprint( "cs_e7m1_ai_phantom_ally_01: START" );
	unit_close( v_phantom );
	sleep_s( 0.25 );
	cs_fly_by( pr_e7m1_phantom_ally_01.p0, 2.5 );

	// fly out
	//dprint( "cs_e7m1_ai_phantom_ally_01: FLY OUT" );
	l_timer = timer_stamp( 10.0 );
	object_set_scale( v_phantom, 0.0001, seconds_to_frames(10.0) );
	cs_fly_to( ai_current_actor, FALSE, pr_e7m1_phantom_ally_01.p1 );
	
	// cleanup
	sleep_until( timer_expired(l_timer), 1 );
	//dprint( "cs_e7m1_ai_phantom_ally_01: CLEANUP" );
	object_destroy( v_phantom );
	ai_erase( ai_current_actor );
	
end

script command_script cs_e7m1_ai_phantom_ally_02()
	sleep_until( unit_get_health(unit_get_vehicle(ai_current_actor)) > 0.0, 1 );
	local vehicle v_phantom = unit_get_vehicle( ai_current_actor );

	// initialize
	//dprint( "cs_e7m1_ai_phantom_ally_02: INIT" );
	object_hide( v_phantom, TRUE );
	object_set_scale( v_phantom, 0.0001, 0 );
	object_move_to_point( v_phantom, 0.0, pr_e7m1_phantom_ally_02.start );
	object_cannot_die( v_phantom, TRUE );
	
	// load mantis
	//dprint( "cs_e7m1_ai_phantom_ally_02: LOAD MANTIS" );
	object_create( bpd_e7m1_mantis_01 );
//gmurphy - 7904 - losing mantis for perf//	object_create( bpd_e7m1_mantis_02 );
//gmurphy - 7904 - losing mantis for perf//	sleep_until( object_valid(bpd_e7m1_mantis_01) and object_valid(bpd_e7m1_mantis_02), 1 );
	sleep_until( object_valid(bpd_e7m1_mantis_01), 1);
	
	object_hide( bpd_e7m1_mantis_01, TRUE );
//gmurphy - 7904 - losing mantis for perf//	object_hide( bpd_e7m1_mantis_02, TRUE );
	object_set_scale( bpd_e7m1_mantis_01, 0.0001, 0 );
//gmurphy - 7904 - losing mantis for perf//	object_set_scale( bpd_e7m1_mantis_02, 0.0001, 0 );
	objects_attach( v_phantom, "small_cargo01", bpd_e7m1_mantis_01, "" );
//gmurphy - 7904 - losing mantis for perf//	objects_attach( v_phantom, "small_cargo02", bpd_e7m1_mantis_02, "" );
	
	// fly in
	sleep_until( not dialog_foreground_active_check(), 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_ally_phantom_start', "play_mus_pve_e07m1_event_ally_phantom_start" );
	//dprint( "cs_e7m1_ai_phantom_ally_02: FLY IN" );
	object_hide( v_phantom, FALSE );
	object_hide( bpd_e7m1_mantis_01, FALSE );
//gmurphy - 7904 - losing mantis for perf//	object_hide( bpd_e7m1_mantis_02, FALSE );
	object_set_scale( v_phantom, 1.0, seconds_to_frames(7.5) );
	object_set_scale( bpd_e7m1_mantis_01, 1.0, seconds_to_frames(7.5) );
//gmurphy - 7904 - losing mantis for perf//	object_set_scale( bpd_e7m1_mantis_02, 1.0, seconds_to_frames(7.5) );
	vh_e7m1_phantom_ally = v_phantom;
	obj_e7m1_phantom_ally_turret = object_at_marker( v_phantom, "chin_gun" );
	
	// dialog
	wake( f_e7m1_dialog_phantom );
	
	cs_fly_to( pr_e7m1_phantom_ally_02.drop_1 );
	ai_object_set_team( vh_e7m1_phantom_ally, human );
	cs_vehicle_speed( 0.25 );
	sleep_s( 1.0 );
	cs_fly_to_and_dock( pr_e7m1_phantom_ally_02.drop_1, pr_e7m1_phantom_ally_02.drop_1_face, 1.0 );
	
	B_e7m1_phantom_ally_drop_in_position = TRUE;
	
	sleep_until( B_e7m1_phantom_ally_drop_in_ready, 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_mech_drop_ready', "play_mus_pve_e07m1_event_mech_drop_ready" );
	
	//dprint( "cs_e7m1_ai_phantom_ally_02: DROP" );
	sleep_s( 1.0 );
	thread( f_e7m1_ai_phantom_mantis_drop(v_phantom, bpd_e7m1_mantis_01) );
	sleep_s( 0.25 );
//gmurphy - 7904 - losing mantis for perf//	thread( f_e7m1_ai_phantom_mantis_drop(v_phantom, bpd_e7m1_mantis_02) );
	
	sleep_s( 1.0 );
	B_e7m1_phantom_ally_drop_complete = TRUE;
	spops_audio_music_event( 'play_mus_pve_e07m1_event_mech_drop_released', "play_mus_pve_e07m1_event_mech_drop_released" );
	cs_fly_to_and_dock( pr_e7m1_phantom_ally_02.drop_2, pr_e7m1_phantom_ally_02.drop_2_face, 1.0 );
	
	// wait to start
	cs_vehicle_speed( 0.75 );
	sleep_until( B_e7m1_phantom_fight_start or (S_e7m1_phantom_combat_height != 0) or (object_recent_damage(vh_e7m1_phantom_ally) >= 0.075), 1 );
	
	// start the final wave
	wake( f_e7m1_finale_place );

end

script command_script cs_e7m1_ai_phantom_ally_pickup()
	local vehicle v_phantom = unit_get_vehicle( ai_current_actor );
 
	vehicle_ignore_damage_knockback (v_phantom, true);
    object_immune_to_friendly_damage (ai_current_actor, true);


	cs_vehicle_speed( 0.75 );
	cs_fly_to( pr_e7m1_phantom_ally_02.pickup );
	cs_vehicle_speed( 0.25 );
	sleep_s( 1.0 );
	cs_fly_to_and_dock( pr_e7m1_phantom_ally_02.pickup, pr_e7m1_phantom_ally_02.pickup_face, 1.0 );
	B_e7m1_phantom_pickup_ready = TRUE;

	// setup pickup lift	
	effect_new_on_object_marker( 'objects\vehicles\covenant\storm_lich\fx\lich_gravlift\lich_gravlift.effect', v_phantom, "lift_direction" );
  object_create( dm_e7m1_phantom_grav_lift );
  sound_impulse_start_marker ( 'sound\environments\multiplayer\dlc1_mezzanine\dm\spops_dm_e6m2_green_beam_init_mnde8298', dm_e7m1_phantom_grav_lift, m_sound, 1 ); //AUDIO!
  sleep_until(object_valid(dm_e7m1_phantom_grav_lift),1);
	sleep(2);
	objects_attach( v_phantom, "lift_direction", dm_e7m1_phantom_grav_lift, "m_end" );
	
	// stay here forever
	sleep_until( FALSE, 1 );

end

script command_script cs_e7m1_ai_phantom_ally_abort()
	local vehicle v_phantom = unit_get_vehicle( ai_current_actor );
	local long l_timer = 0;

	spops_audio_music_event( 'play_mus_pve_e07m1_event_ally_phantom_abort', "play_mus_pve_e07m1_event_ally_phantom_abort" );
	cs_vehicle_speed( 1.0 );
	cs_fly_by( pr_e7m1_phantom_ally_02.abort, 25.0 );
	l_timer = timer_stamp( 7.5 );
	object_set_scale( v_phantom, 0.0001, seconds_to_frames(7.5) );
	cs_fly_to( pr_e7m1_phantom_ally_02.abort );
	
	// cleanup
	sleep_until( timer_expired(l_timer), 1 );
	object_destroy( v_phantom );
	ai_erase( ai_current_actor );

end

script command_script cs_e7m1_ai_phantom_enemy_01()
	sleep_until( unit_get_health(unit_get_vehicle(ai_current_actor)) > 0.0, 1 );
	local vehicle v_phantom = unit_get_vehicle( ai_current_actor );
	//dprint( "cs_e7m1_ai_phantom_enemy_01" );
	
	// initialize
	//dprint( "cs_e7m1_ai_phantom_enemy_01: INIT" );
	object_hide( v_phantom, TRUE );
	object_set_scale( v_phantom, 0.0001, 0 );
	object_move_to_point( v_phantom, 0.0, pr_e7m1_phantom_enemy_01.start );

	//dprint( "cs_e7m1_ai_phantom_enemy_01: FLY IN" );
	object_hide( v_phantom, FALSE );
	object_set_scale( v_phantom, 1.0, seconds_to_frames(10.0) );
	vh_e7m1_phantom_enemy = v_phantom;
	obj_e7m1_phantom_enemy_turret = object_at_marker( v_phantom, "chin_gun" );
	
	cs_vehicle_speed( 0.75 );
	cs_fly_by( ai_current_actor, FALSE, pr_e7m1_phantom_enemy_01.lz_loc, 15.0 );

	// wait for arrival
	sleep_until( (objects_distance_to_object(vh_e7m1_phantom_enemy, vh_e7m1_phantom_ally) <= 60.0) or ((objects_distance_to_object(Players(), vh_e7m1_phantom_enemy) <= 85.0) and (objects_can_see_object(Players(), vh_e7m1_phantom_enemy, 30.0))) or (objects_distance_to_point(vh_e7m1_phantom_enemy, pr_e7m1_phantom_enemy_01.lz_loc) <= 50.0) or (object_recent_damage(vh_e7m1_phantom_enemy) > 0.0), 1 );
	spops_audio_music_event( 'play_mus_pve_e07m1_event_enemy_phantom_start', "play_mus_pve_e07m1_event_enemy_phantom_start" );
	B_e7m1_phantom_enemy_arrived = TRUE;
	wake( f_e7m1_dialog_phantom_02 );
	cs_vehicle_speed( 0.75 );
	
end

script command_script cs_e7m1_ai_phantom_enemy_abort()
	local vehicle v_phantom = unit_get_vehicle( ai_current_actor );
	local long l_timer = 0;

	spops_audio_music_event( 'play_mus_pve_e07m1_event_enemy_phantom_abort', "play_mus_pve_e07m1_event_enemy_phantom_abort" );
	cs_vehicle_speed( 1.0 );
	cs_fly_by( pr_e7m1_phantom_enemy_01.abort, 25.0 );
	l_timer = timer_stamp( 7.5 );
	object_set_scale( v_phantom, 0.0001, seconds_to_frames(7.5) );
	cs_fly_to( pr_e7m1_phantom_enemy_01.abort );
	
	// cleanup
	sleep_until( timer_expired(l_timer), 1 );
	object_destroy( v_phantom );
	ai_erase( ai_current_actor );

end

script static void f_e7m1_ai_phantom_mantis_drop( object obj_phantom, object obj_mantis )
	
	object_cannot_take_damage( obj_mantis );
	objects_detach( obj_phantom, obj_mantis );
	sleep_s( 2.5 );
	object_can_take_damage( obj_mantis );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: LEVEL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e7m1_ai_level = 						0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_level::: xxx
script static void f_e7m1_ai_level( short s_val )

	if ( s_val > S_e7m1_ai_level ) then
		//dprint( "f_e7m1_ai_level" );
		//inspect( s_val );
		S_e7m1_ai_level = s_val;
	end
	
end
script static short f_e7m1_ai_level()
	S_e7m1_ai_level;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: OBJCON ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global real DEF_E7M1_AI_OBJCON_AREA_ALL =						-1.0;
global real DEF_E7M1_AI_OBJCON_AREA_NONE =					999.999;
global real DEF_E7M1_AI_OBJCON_AREA_START =					000.0;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e7m1_objcon = 										DEF_E7M1_AI_OBJCON_AREA_START;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_ai_objcon_init::: Init
script dormant f_e7m1_ai_objcon_init()
	//dprint( "f_e7m1_ai_objcon_init" );
	
	// setup triggers
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_1A, DEF_E7M1_AI_OBJCON_AREA_1A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_2A, DEF_E7M1_AI_OBJCON_AREA_2A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_2B, DEF_E7M1_AI_OBJCON_AREA_2B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_2C, DEF_E7M1_AI_OBJCON_AREA_2C) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_2D, DEF_E7M1_AI_OBJCON_AREA_2D) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_2E, DEF_E7M1_AI_OBJCON_AREA_2E) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_3A, DEF_E7M1_AI_OBJCON_AREA_3A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_3B, DEF_E7M1_AI_OBJCON_AREA_3B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_3C, DEF_E7M1_AI_OBJCON_AREA_3C) );

	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B, 1 );
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4A, DEF_E7M1_AI_OBJCON_AREA_4A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4B, DEF_E7M1_AI_OBJCON_AREA_4B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4C, DEF_E7M1_AI_OBJCON_AREA_4C) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4D, DEF_E7M1_AI_OBJCON_AREA_4D) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4E, DEF_E7M1_AI_OBJCON_AREA_4E) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_4F, DEF_E7M1_AI_OBJCON_AREA_4F) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_5A, DEF_E7M1_AI_OBJCON_AREA_5A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_5B, DEF_E7M1_AI_OBJCON_AREA_5B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_5C, DEF_E7M1_AI_OBJCON_AREA_5C) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_6A, DEF_E7M1_AI_OBJCON_AREA_6A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_6B, DEF_E7M1_AI_OBJCON_AREA_6B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_6C, DEF_E7M1_AI_OBJCON_AREA_6C) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_7A, DEF_E7M1_AI_OBJCON_AREA_7A) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_7B, DEF_E7M1_AI_OBJCON_AREA_7B) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_7C, DEF_E7M1_AI_OBJCON_AREA_7C) );
	sleep(1);
	thread( f_e7m1_ai_objcon_trigger(tv_e7m1_area_8A, DEF_E7M1_AI_OBJCON_AREA_8A) );
	
end

// === f_e7m1_ai_objcon_trigger::: Trigger
script static void f_e7m1_ai_objcon_trigger( trigger_volume tv_objcon, real r_objcon )

	// wait for trigger
	sleep_until( volume_test_players(tv_objcon) or (R_e7m1_objcon >= r_objcon), 10 );
	//dprint( "f_e7m1_ai_objcon_trigger" );
	f_e7m1_ai_objcon( r_objcon );

end

// === f_e7m1_ai_objcon_wait::: Trigger
script static void f_e7m1_ai_objcon_wait( real r_objcon )
	sleep_until( R_e7m1_objcon >= r_objcon, 5 );
end

// === f_e7m1_ai_objcon::: Sets the objcon
script static void f_e7m1_ai_objcon( real r_value )

	if ( r_value > R_e7m1_objcon ) then
		//dprint( "f_e7m1_ai_objcon: SET" );
		//inspect( r_value );
		R_e7m1_objcon = r_value;
	end
	
end
script static real f_e7m1_ai_objcon()
	R_e7m1_objcon;
end

// === f_e7m1_ai_objcon_range_check::: Checks objcon range
script static boolean f_e7m1_ai_objcon_range_check( real r_min, real r_max )
	(
		( r_min < 0.0 )
		or
		( r_min <= R_e7m1_objcon )
	)
	and
	(
		( r_max < 0.0 )
		or
		( r_max >= R_e7m1_objcon )
	);
end

// === f_e7m1_ai_objcon_trigger_player_furthest::: Gets the furthest objcon a player is standing in
script static real f_e7m1_ai_objcon_trigger_player_furthest()
local real r_objcon = DEF_E7M1_AI_OBJCON_AREA_START;

	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_8A, DEF_E7M1_AI_OBJCON_AREA_8A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_7C, DEF_E7M1_AI_OBJCON_AREA_7C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_7B, DEF_E7M1_AI_OBJCON_AREA_7B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_7A, DEF_E7M1_AI_OBJCON_AREA_7A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_6C, DEF_E7M1_AI_OBJCON_AREA_6C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_6B, DEF_E7M1_AI_OBJCON_AREA_6B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_6A, DEF_E7M1_AI_OBJCON_AREA_6A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_5C, DEF_E7M1_AI_OBJCON_AREA_5C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_5B, DEF_E7M1_AI_OBJCON_AREA_5B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_5A, DEF_E7M1_AI_OBJCON_AREA_5A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4F, DEF_E7M1_AI_OBJCON_AREA_4F );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4E, DEF_E7M1_AI_OBJCON_AREA_4E );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4D, DEF_E7M1_AI_OBJCON_AREA_4D );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4C, DEF_E7M1_AI_OBJCON_AREA_4C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4B, DEF_E7M1_AI_OBJCON_AREA_4B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_4A, DEF_E7M1_AI_OBJCON_AREA_4A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_3C, DEF_E7M1_AI_OBJCON_AREA_3C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_3B, DEF_E7M1_AI_OBJCON_AREA_3B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_3A, DEF_E7M1_AI_OBJCON_AREA_3A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_2E, DEF_E7M1_AI_OBJCON_AREA_2E );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_2D, DEF_E7M1_AI_OBJCON_AREA_2D );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_2C, DEF_E7M1_AI_OBJCON_AREA_2C );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_2B, DEF_E7M1_AI_OBJCON_AREA_2B );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_2A, DEF_E7M1_AI_OBJCON_AREA_2A );
	r_objcon = sys_e7m1_ai_objcon_trigger_player_furthest( r_objcon, tv_e7m1_area_1A, DEF_E7M1_AI_OBJCON_AREA_1A );
	
	// return
	r_objcon;
end

// === sys_e7m1_ai_objcon_trigger_player_furthest::: Checks an objcon volume
script static real sys_e7m1_ai_objcon_trigger_player_furthest( real r_objcon_current, trigger_volume tv_objcon, real r_objcon )
	if ( (r_objcon > r_objcon_current) and volume_test_players(tv_objcon) ) then
		r_objcon_current = r_objcon;
	end
	
	r_objcon_current;
end

// makes an ai brainded until an objcon
script static void f_e7m1_ai_objcon_braindead_wait( ai ai_actor, real r_objcon )

	if ( R_e7m1_objcon < r_objcon ) then
		local object obj_ai = ai_get_object( ai_actor );

		// braindead
//		ai_braindead( ai_actor, TRUE );
		ai_set_blind( ai_actor, TRUE );
		ai_set_deaf( ai_actor, TRUE );
	
		// wait
		sleep_until( (R_e7m1_objcon >= r_objcon) or (object_recent_damage(obj_ai) > 0.0), 1 );

		// restore
		ai_braindead( ai_actor, FALSE );
		ai_set_blind( ai_actor, FALSE );
		ai_set_deaf( ai_actor, FALSE );
	
	end

end

script dormant f_e7m1_ai_objcon_accelerate()
	//dprint( "f_e7m1_ai_objcon_accelerate" );
	
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_1A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_2A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_2B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_2C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_2D );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_2E );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_3A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_3B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_3C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4D );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4E );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_4F );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_5A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_5B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_5C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_6A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_6B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_6C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_7A );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_7B );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_7C );
	f_e7m1_ai_objcon_accelerate_step( DEF_E7M1_AI_OBJCON_AREA_8A );
	
end

script static void f_e7m1_ai_objcon_accelerate_step( real r_objcon )

	if ( R_e7m1_objcon < r_objcon ) then
		local short s_cnt = 0;
		local long l_timer = 0;
		local short s_living = 0;
		
		repeat
		
			sleep_until( ai_living_count(gr_e7m1_all) < S_e7m1_ai_place_loc_max, 1 );
			s_cnt = ai_living_count( gr_e7m1_all );
			l_timer = timer_stamp( 0.25 );
			sleep_until( (R_e7m1_objcon >= r_objcon) or timer_expired(l_timer) or (s_cnt != ai_living_count(gr_e7m1_all)), 1 );
			s_living = ai_living_count( gr_e7m1_all );
			
		until( (R_e7m1_objcon >= r_objcon) or ((s_living < S_e7m1_ai_place_loc_max) and ((s_living == s_cnt) or (s_living == 0))), 1 );

		//dprint( "f_e7m1_ai_objcon_accelerate_step: FORCE" );
		//inspect( r_objcon );
		f_e7m1_ai_objcon( r_objcon );

	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: PLACE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
static short DEF_E7M1_AI_PLACE_MAX_GRUNT = 											8;
static short DEF_E7M1_AI_PLACE_MAX_JACKAL = 										6;
static short DEF_E7M1_AI_PLACE_MAX_ELITE = 											4;
static short DEF_E7M1_AI_PLACE_MAX_CRAWLER = 										8;
//gmurphy - 7904 - losing max watchers (from 5 to 3) for perf//
static short DEF_E7M1_AI_PLACE_MAX_WATCHER = 										3;
static short DEF_E7M1_AI_PLACE_MAX_KNIGHT = 										4;
static short DEF_E7M1_AI_PLACE_MAX_GHOST = 											4;
//gmurphy - 7904 - losing max wraith (from 4 to 1) for perf//
static short DEF_E7M1_AI_PLACE_MAX_WRAITH = 										1;

global short DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT = 						20;
global real DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT = 			30.0;

global real DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_CRAWLER = 		2.5;
global real DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_CRAWLER = 			-30.0;
global real DEF_E7M1_AI_PLACE_FORCE_DISTANCE_CRAWLER = 					7.5;

global real DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_WATCHER = 		2.5;
global real DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_WATCHER = 			-30.0;
global real DEF_E7M1_AI_PLACE_FORCE_DISTANCE_WATCHER = 					7.5;

global real DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_KNIGHT = 		7.5;
global real DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_KNIGHT = 				-30.0;
global real DEF_E7M1_AI_PLACE_FORCE_DISTANCE_KNIGHT = 					15.0;

static real DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT = 							0.125;
static real DEF_E7M1_AI_PLACE_POST_DELAY_WATCHER = 							5.0;

global short S_e7m1_ai_place_loc_wait_cnt =											0;
global short S_e7m1_ai_place_loc_wait_max =											0;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e7m1_ai_place_loc_max = 													15;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static void f_e7m1_ai_place_loc_max( short s_max )

	S_e7m1_ai_place_loc_max = s_max;
	
	if ( (effects_perf_armageddon == 0) and (ai_living_count(gr_e7m1_all) > S_e7m1_ai_place_loc_max) ) then
		effects_perf_armageddon = 1;
		thread( f_e7m1_ai_place_loc_perf_helper() );
	end
	
end
script static void f_e7m1_ai_place_loc_perf_helper()
	sleep_until( ai_living_count(gr_e7m1_all) <= S_e7m1_ai_place_loc_max, 10 );
	effects_perf_armageddon = 0;
end

// === place grunt::: XXX
script static void f_e7m1_ai_place_loc_grunt( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 8 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_cov_grunt, sys_e7m1_ai_place_loc_grunt_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_grunt( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_jackal( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 8 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_cov_jackal, sys_e7m1_ai_place_loc_jackal_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_jackal( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_elite( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_cov_elite, sys_e7m1_ai_place_loc_elite_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_elite( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_cov_basic( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_cov_basic, sys_e7m1_ai_place_loc_grunt_max() + sys_e7m1_ai_place_loc_jackal_max(), ai_enemy_task, s_enemy_task_max );
	
		if ( isthreadvalid(l_thread) ) then
			ai_placed = NONE;

			begin_random
			
				begin
					if ( ai_placed == NONE ) then
						ai_placed = sys_e7m1_ai_place_loc_grunt( flg_loc, sid_objective );
					end
				end
				begin
					if ( ai_placed == NONE ) then
						ai_placed = sys_e7m1_ai_place_loc_jackal( flg_loc, sid_objective );
					end
				end
				
			end
		
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end

		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_cov( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_cov, sys_e7m1_ai_place_loc_grunt_max() + sys_e7m1_ai_place_loc_jackal_max(), ai_enemy_task, s_enemy_task_max );
	
		if ( isthreadvalid(l_thread) ) then
			ai_placed = NONE;

			begin_random
			
				begin
					if ( ai_placed == NONE ) then
						ai_placed = sys_e7m1_ai_place_loc_grunt( flg_loc, sid_objective );
					end
				end
				begin
					if ( ai_placed == NONE ) then
						ai_placed = sys_e7m1_ai_place_loc_jackal( flg_loc, sid_objective );
					end
				end
				begin
					if ( ai_placed == NONE ) then
						ai_placed = sys_e7m1_ai_place_loc_elite( flg_loc, sid_objective );
					end
				end
				
			end
		
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_crawler( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_CRAWLER, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_CRAWLER, DEF_E7M1_AI_PLACE_FORCE_DISTANCE_CRAWLER, gr_e7m1_pool_fore_crawler, sys_e7m1_ai_place_loc_crawler_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_crawler( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_watcher( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_WATCHER;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_WATCHER, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_WATCHER, DEF_E7M1_AI_PLACE_FORCE_DISTANCE_WATCHER, gr_e7m1_pool_fore_watcher, sys_e7m1_ai_place_loc_watcher_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_watcher( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_knight( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, DEF_E7M1_AI_PLACE_CONDITIONAL_DISTANCE_KNIGHT, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_KNIGHT, DEF_E7M1_AI_PLACE_FORCE_DISTANCE_KNIGHT, gr_e7m1_pool_fore_knight, sys_e7m1_ai_place_loc_knight_max(), ai_enemy_task, s_enemy_task_max );
		
		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_knight( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end

	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_ghost( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;

	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_veh_ghost, sys_e7m1_ai_place_loc_ghost_max(), ai_enemy_task, s_enemy_task_max );

		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_ghost( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// === xxx::: XXX
script static void f_e7m1_ai_place_loc_wraith( long l_thread, string_id sid_objective, short s_cnt, cutscene_flag flg_loc, real r_priority, real r_priority_mod, real r_conditional_distance, real r_force_distance, real r_post_delay, ai ai_enemy_task, short s_enemy_task_max, real r_objcon_min )
local ai ai_placed = NONE;

	// defaults
	if ( r_post_delay < 0.0 ) then
		r_post_delay = DEF_E7M1_AI_PLACE_POST_DELAY_DEFAULT;
	end

	r_priority = r_priority * r_priority_mod;
	
	if ( isthreadvalid(l_thread) and (R_e7m1_objcon < r_objcon_min) ) then
		sleep_until( (R_e7m1_objcon >= r_objcon_min) or (not isthreadvalid(l_thread)), 10 );
	end
	repeat
	
		// wait for it to be time to place
		sys_e7m1_ai_place_loc_wait( l_thread, flg_loc, r_priority * r_priority_mod, r_conditional_distance, DEF_E7M1_AI_PLACE_CONDITIONAL_ANGLE_DEFAULT, r_force_distance, gr_e7m1_pool_veh_wraith, sys_e7m1_ai_place_loc_wraith_max(), ai_enemy_task, s_enemy_task_max );

		if ( isthreadvalid(l_thread) ) then
		
			ai_placed = sys_e7m1_ai_place_loc_wraith( flg_loc, sid_objective );
			if ( ai_placed != NONE ) then
				s_cnt = s_cnt - 1;
				sys_e7m1_ai_place_loc_post_delay( flg_loc, object_get_ai(ai_placed), r_post_delay, s_cnt, l_thread );
			end
			
		end
	
	until( (s_cnt == 0) or (not isthreadvalid(l_thread)), 10 );

end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e7m1_ai_pool_grunt()
	//dprint( "cs_e7m1_ai_pool_grunt" );
	
	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_grunt', "play_mus_pve_e07m1_spawn_enemy_grunt" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_jackal()
	//dprint( "cs_e7m1_ai_pool_jackal" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_jackal', "play_mus_pve_e07m1_spawn_enemy_jackal" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_elite()
	//dprint( "cs_e7m1_ai_pool_elite" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_elite', "play_mus_pve_e07m1_spawn_enemy_elite" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_crawler()
	//dprint( "cs_e7m1_ai_pool_crawler" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_crawler', "play_mus_pve_e07m1_spawn_enemy_crawler" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_watcher()
local object obj_ai = ai_get_object( ai_current_actor );
	//dprint( "cs_e7m1_ai_pool_watcher" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_watcher', "play_mus_pve_e07m1_spawn_enemy_watcher" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_knight()
	//dprint( "cs_e7m1_ai_pool_knight" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_knight', "play_mus_pve_e07m1_spawn_enemy_knight" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_ghost()
	//dprint( "cs_e7m1_ai_pool_ghost" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_ghost', "play_mus_pve_e07m1_spawn_enemy_ghost" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

script command_script cs_e7m1_ai_pool_wraith()
	//dprint( "cs_e7m1_ai_pool_wraith" );

	spops_audio_music_event( 'play_mus_pve_e07m1_spawn_enemy_wraith', "play_mus_pve_e07m1_spawn_enemy_wraith" );
	f_e7m1_ai_objcon_braindead_wait( ai_current_actor, DEF_E7M1_AI_OBJCON_AREA_1A );

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_e7m1_ai_place_loc_wait( long l_thread, cutscene_flag flg_loc, real r_priority, real r_conditional_distance, real r_conditional_angle, real r_force_distance, ai ai_parent_squad, short s_parent_max, ai ai_enemy_task, short s_enemy_task_max )
static real l_place_priority = 99999.99999;
static short s_place_cnt = 0;
local boolean b_conditional_angle_check = ( r_conditional_angle < 0.0 );

	//dprint( "sys_e7m1_ai_place_loc_wait: START" );
	if ( r_conditional_angle < 0.0 ) then
		r_conditional_angle = -r_conditional_angle;
	end

	// inc counts
	S_e7m1_ai_place_loc_wait_cnt = S_e7m1_ai_place_loc_wait_cnt + 1;
	if ( S_e7m1_ai_place_loc_wait_cnt > S_e7m1_ai_place_loc_wait_max ) then
		S_e7m1_ai_place_loc_wait_max = S_e7m1_ai_place_loc_wait_cnt;
	end
	
	repeat
		
		// update the place variables
		if ( r_priority == l_place_priority ) then
		
			s_place_cnt = s_place_cnt - 1;
			if ( s_place_cnt <= 0 ) then
				s_place_cnt = 0;
				l_place_priority = 99999.99999;
			end
			
		end

		// wait until valid to spawn
		sleep_until( 
			( not isthreadvalid(l_thread) )
			or
			(
				( r_priority <= l_place_priority )
				and
				( ai_living_count(gr_e7m1_all) < S_e7m1_ai_place_loc_max )
				and
				( ai_task_count(ai_enemy_task) < s_enemy_task_max )
				and
				( ai_living_count(ai_parent_squad) < s_parent_max )
				and
				sys_e7m1_ai_place_loc_check( flg_loc, r_conditional_distance, r_conditional_angle, b_conditional_angle_check, r_force_distance )
			)
		, 10 );
		
		if ( isthreadvalid(l_thread) ) then
		
			// set priority variables
			if ( r_priority < l_place_priority ) then
				l_place_priority = r_priority;
				s_place_cnt = 0;
			end
			s_place_cnt = s_place_cnt + 1;
			
			// wait
			sleep( 1 );

		end
	
	until( ((r_priority == l_place_priority) and (ai_living_count(gr_e7m1_all) < S_e7m1_ai_place_loc_max) and (ai_task_count(ai_enemy_task) < s_enemy_task_max) and (ai_living_count(ai_parent_squad) < s_parent_max)) or (not isthreadvalid(l_thread)), 10 );

	// update the place variables
	if ( r_priority == l_place_priority ) then
	
		s_place_cnt = s_place_cnt - 1;
		if ( s_place_cnt <= 0 ) then
			s_place_cnt = 0;
			l_place_priority = 99999.99999;
		end
		
	end

	// dec counts
	S_e7m1_ai_place_loc_wait_cnt = S_e7m1_ai_place_loc_wait_cnt - 1;

	//dprint( "sys_e7m1_ai_place_loc_wait: END" );

end

script static boolean sys_e7m1_ai_place_loc_check( cutscene_flag flg_loc, real r_conditional_distance, real r_conditional_angle, boolean b_conditional_angle_check, real r_force_distance )
static real r_distance = 0.0;

	// get distance
	r_distance = objects_distance_to_flag( Players(), flg_loc );
	
	// return
	(r_distance >= r_force_distance) or ((r_distance >= r_conditional_distance) and (objects_can_see_flag(Players(), flg_loc, r_conditional_angle) == b_conditional_angle_check));
end

script static short sys_e7m1_ai_place_loc_grunt_max()
	DEF_E7M1_AI_PLACE_MAX_GRUNT;
end

script static ai sys_e7m1_ai_place_loc_grunt( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_grunt: START" );

	if ( ai_living_count(sq_e7m1_pool_grunt_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_grunt_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_04;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_05) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_05;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_06) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_06;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_07) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_07;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_08) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_08;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_09) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_09;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_grunt_10) <= 0) ) then
		ai_placed = sq_e7m1_pool_grunt_10;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_grunt: PLACE" );
		ai_place_in_limbo( ai_placed );
		local object obj_placed = ai_get_object( ai_placed );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_set_scale( obj_placed, 1.0, DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT );
		ai_exit_limbo( ai_placed );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_jackal_max()
	bound_s( game_coop_player_count() + 2, 4, DEF_E7M1_AI_PLACE_MAX_JACKAL );
end

script static ai sys_e7m1_ai_place_loc_jackal( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_jackal: START" );

	if ( ai_living_count(sq_e7m1_pool_jackal_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_jackal_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_jackal_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_jackal_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_jackal_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_jackal_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_jackal_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_jackal_04;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_jackal_05) <= 0) ) then
		ai_placed = sq_e7m1_pool_jackal_05;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_jackal_06) <= 0) ) then
		ai_placed = sq_e7m1_pool_jackal_06;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_jackal: PLACE" );
		ai_place_in_limbo( ai_placed );
		local object obj_placed = ai_get_object( ai_placed );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_set_scale( obj_placed, 1.0, DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT );
		ai_exit_limbo( ai_placed );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_elite_max()
	bound_s( game_coop_player_count() * 2, 2, DEF_E7M1_AI_PLACE_MAX_ELITE );
end

script static ai sys_e7m1_ai_place_loc_elite( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_elite: START" );

	if ( ai_living_count(sq_e7m1_pool_elite_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_elite_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_elite_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_elite_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_elite_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_elite_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_elite_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_elite_04;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_elite: PLACE" );
		ai_place_in_limbo( ai_placed );
		local object obj_placed = ai_get_object( ai_placed );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_set_scale( obj_placed, 1.0, DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT );
		ai_exit_limbo( ai_placed );
		spops_ai_active_camo_manager( ai_placed );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_crawler_max()
	bound_s( game_coop_player_count() * 5, 0, DEF_E7M1_AI_PLACE_MAX_CRAWLER );
end

script static ai sys_e7m1_ai_place_loc_crawler( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_crawler: START" );

	if ( ai_living_count(sq_e7m1_pool_crawler_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_crawler_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_04;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_05) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_05;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_06) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_06;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_07) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_07;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_08) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_08;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_09) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_09;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_10) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_10;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_11) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_11;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_12) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_12;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_13) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_13;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_14) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_14;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_crawler_15) <= 0) ) then
		ai_placed = sq_e7m1_pool_crawler_15;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_crawler: PLACE" );
		ai_place_in_limbo( ai_placed );
		object_move_to_flag( ai_get_object(ai_placed), 0, flg_loc );
		sleep( 1 );
		ai_exit_limbo( ai_placed );
		object_dissolve_from_marker( ai_get_unit(ai_placed), 'resurrect', 'phase_in' );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_watcher_max()
	//bound_s( game_coop_player_count() * 2, 3, DEF_E7M1_AI_PLACE_MAX_WATCHER );
	//gmurphy - 7904 - losing max watchers (from 5 to 3) for perf//
	DEF_E7M1_AI_PLACE_MAX_WATCHER;
end

script static ai sys_e7m1_ai_place_loc_watcher( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_watcher: START" );

	if ( ai_living_count(sq_e7m1_pool_watcher_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_watcher_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_watcher_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_watcher_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_watcher_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_watcher_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_watcher_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_watcher_04;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_watcher_05) <= 0) ) then
		ai_placed = sq_e7m1_pool_watcher_05;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_watcher: PLACE" );
		ai_place_in_limbo( ai_placed );
		local object obj_placed = ai_get_object( ai_placed );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_move_by_offset( obj_placed, 0, 0.0, 0.0, 0.20 );
		thread( sys_e7m1_ai_place_loc_watcher_post(flg_loc, ai_placed, sid_objective) );
	end

	// return
	ai_placed;
end
script static void sys_e7m1_ai_place_loc_watcher_post( cutscene_flag flg_loc, ai ai_placed, string_id sid_objective )

	// portal fx
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect', flg_loc );
	sleep_s( 0.50 );
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	sleep_s( 0.25 );
	
	// scale in
	object_set_scale( ai_get_object(ai_placed), 1.0, 50 );
	
	// exit limbo
	ai_exit_limbo( ai_placed );
	
	// set objective
	ai_set_objective( ai_placed, sid_objective );
	
	// kill fx
	sleep_s( 0.50 );
	effect_kill_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	effect_delete_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );

end

script static short sys_e7m1_ai_place_loc_knight_max()
	bound_s( game_coop_player_count() * 2, 2, DEF_E7M1_AI_PLACE_MAX_KNIGHT );
end

script static ai sys_e7m1_ai_place_loc_knight( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_knight: START" );

	if ( ai_living_count(sq_e7m1_pool_knight_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_knight_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_knight_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_knight_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_knight_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_knight_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_knight_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_knight_04;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_knight: PLACE" );
		ai_place_in_limbo( ai_placed );
		sleep(1);
		local object obj_placed = ai_get_object( ai_placed );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 3 ); // Sleep long enough to allow tick to recover after place_in_limbo hit.  
		cs_phase_in( ai_placed, FALSE );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_ghost_max()
	bound_s( game_coop_player_count() * 2, 2, DEF_E7M1_AI_PLACE_MAX_GHOST );
end

script static ai sys_e7m1_ai_place_loc_ghost( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_ghost: START" );

	if ( ai_living_count(sq_e7m1_pool_ghost_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_ghost_01;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_ghost_02) <= 0) ) then
		ai_placed = sq_e7m1_pool_ghost_02;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_ghost_03) <= 0) ) then
		ai_placed = sq_e7m1_pool_ghost_03;
	end
	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_ghost_04) <= 0) ) then
		ai_placed = sq_e7m1_pool_ghost_04;
	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_ghost: PLACE" );
		ai_place( ai_placed );
		local object obj_placed = ai_vehicle_get_from_squad( ai_placed, 0 );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_set_scale( obj_placed, 1.0, DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static short sys_e7m1_ai_place_loc_wraith_max()
	//bound_s( game_coop_player_count() * 2, 2, DEF_E7M1_AI_PLACE_MAX_WRAITH );
	//gmurphy - 7904 - losing max wraith (from 4 to 1) for perf//
	DEF_E7M1_AI_PLACE_MAX_WRAITH;
end

script static ai sys_e7m1_ai_place_loc_wraith( cutscene_flag flg_loc, string_id sid_objective )
local ai ai_placed = NONE;
	//dprint( "sys_e7m1_ai_place_loc_wraith: START" );

	if ( ai_living_count(sq_e7m1_pool_wraith_01) <= 0 ) then
		ai_placed = sq_e7m1_pool_wraith_01;
	end

//gmurphy - 7904 - losing wraith for perf//
//	if ( (ai_placed == NONE) and (ai_living_count(sq_e7m1_pool_wraith_02) <= 0) ) then
//		ai_placed = sq_e7m1_pool_wraith_02;
//	end

	// place
	if ( ai_placed != NONE ) then
		//dprint( "sys_e7m1_ai_place_loc_wraith: PLACE" );
		ai_place( ai_placed );
		local object obj_placed = ai_vehicle_get_from_squad( ai_placed, 0 );
		object_set_scale( obj_placed, 0.0001, 0 );
		object_move_to_flag( obj_placed, 0, flg_loc );
		sleep( 1 );
		object_set_scale( obj_placed, 1.0, DEF_E7M1_AI_PLACE_SCALE_TIME_DEFAULT );
		ai_set_objective( ai_placed, sid_objective );
	end

	// return
	ai_placed;
end

script static boolean sys_e7m1_ai_place_loc_post_delay( cutscene_flag flg_loc, object obj_placed, real r_post_delay, short s_cnt, long l_thread )

	if ( s_cnt != 0 ) then
		local long l_timer = timer_stamp( r_post_delay );
		sleep_until( (not isthreadvalid(l_thread)) or (objects_distance_to_flag(obj_placed, flg_loc) >= 1.0) or (object_get_health(obj_placed) <= 0.0), 10 );
		sleep_until( timer_expired(l_timer) or (not isthreadvalid(l_thread)), 1 );
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AI: PLACE: AREAS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
static real DEF_E7M1_AI_POOL_PRIORITY_LOW = 										9.999;
static real DEF_E7M1_AI_POOL_PRIORITY_MED = 										6.666;
static real DEF_E7M1_AI_POOL_PRIORITY_HIGH = 										3.333;
static real DEF_E7M1_AI_POOL_PRIORITY_VERY_HIGH = 							0.5;
static real DEF_E7M1_AI_POOL_PRIORITY_CRITICAL = 								0.0;

static real DEF_E7M1_AI_POOL_PRIORITY_GRUNT = 									DEF_E7M1_AI_POOL_PRIORITY_LOW;
static real DEF_E7M1_AI_POOL_PRIORITY_JACKAL = 									DEF_E7M1_AI_POOL_PRIORITY_LOW;
static real DEF_E7M1_AI_POOL_PRIORITY_ELITE = 									DEF_E7M1_AI_POOL_PRIORITY_LOW;
static real DEF_E7M1_AI_POOL_PRIORITY_CRAWLER = 								DEF_E7M1_AI_POOL_PRIORITY_LOW;
static real DEF_E7M1_AI_POOL_PRIORITY_WATCHER = 								DEF_E7M1_AI_POOL_PRIORITY_LOW;
static real DEF_E7M1_AI_POOL_PRIORITY_KNIGHT = 									DEF_E7M1_AI_POOL_PRIORITY_HIGH;
static real DEF_E7M1_AI_POOL_PRIORITY_GHOST = 									DEF_E7M1_AI_POOL_PRIORITY_MED;
static real DEF_E7M1_AI_POOL_PRIORITY_WRAITH = 									DEF_E7M1_AI_POOL_PRIORITY_CRITICAL;

static real DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW = 								1.00;
static real DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED = 						0.95;
static real DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED = 								0.90;
static real DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH = 					0.85;
static real DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH = 							0.75;

static real DEF_E7M1_FINALE_CONDITIONAL_DISTANCE = 							12.5;
static real DEF_E7M1_FINALE_FORCE_DISTANCE = 										30.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_e7m1_area_1A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_1A_place_action" );
 //ai_place( gr_e7m1_area_01a_enemy );
 thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_1a_elite_01, DEF_E7M1_AI_POOL_PRIORITY_CRITICAL, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 0.0, 0.0, 0.0, ai_enemy_task, s_enemy_task_max, 0.0) );
 thread( f_e7m1_ai_place_loc_grunt(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_1a_grunt_01, DEF_E7M1_AI_POOL_PRIORITY_CRITICAL, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 0.0, 0.0, 0.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_2A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );

 //dprint( "f_e7m1_area_2A_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_2a_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_2a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_2a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_2a_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_2B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_2B_place_action" );
 
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_2b_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_2b_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_2C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_2C_place_action" );

	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(4,6), flg_e7m1_area_2c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(4,6), flg_e7m1_area_2c_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_2D_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_2D_place_action" );

	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_2d_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_2d_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_2d_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_2E_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_2E_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_2e_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_2e_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_2e_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_3A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_3A_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_3a_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3a_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_3B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_veh_thread = sys_e7m1_area_place_thread( r_objcon_veh_max, s_body_count );
 //dprint( "f_e7m1_area_3B_place_action" );

	thread( f_e7m1_ai_place_loc_ghost(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_3b_ghost_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_ghost(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_3b_ghost_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_3b_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3b_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3b_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3b_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_3C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_3C_place_action" );

	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_3c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_3c_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_3c_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_4A_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_4a_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 1, flg_e7m1_area_4a_elite_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_4B_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_4b_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4b_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4b_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4b_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_4C_place_action" );

	thread( f_e7m1_ai_place_loc_elite(l_objcon_cov_thread, sid_objective, 2, flg_e7m1_area_4c_elite_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4c_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4D_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_veh_thread = sys_e7m1_area_place_thread( r_objcon_veh_max, s_body_count );
 //dprint( "f_e7m1_area_4D_place_action" );

	thread( f_e7m1_ai_place_loc_wraith(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_4d_wraith_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(3,4), flg_e7m1_area_4d_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(3,4), flg_e7m1_area_4d_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4d_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4d_unit_04, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4E_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_4E_place_action" );

	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4e_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4e_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4e_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_4e_unit_04, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_4F_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
 //dprint( "f_e7m1_area_4F_place_action" );

	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4f_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4f_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4f_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_4f_unit_04, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	
end

script static void f_e7m1_area_5A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_veh_thread = sys_e7m1_area_place_thread( r_objcon_veh_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_5A_place_action" );

	thread( f_e7m1_ai_place_loc_ghost(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_5a_ghost_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_5a_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_5a_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_5a_crawler_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_5a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_5a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_5B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_5B_place_action" );

	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_5b_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_5b_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_5b_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_5b_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_5C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_veh_thread = sys_e7m1_area_place_thread( r_objcon_veh_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_5C_place_action" );

	thread( f_e7m1_ai_place_loc_ghost(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_5c_ghost_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_5c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_5c_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_5c_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(5,7), flg_e7m1_area_5c_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(5,7), flg_e7m1_area_5c_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_6A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_6A_place_action" );

	f_e7m1_ai_place_loc_max( S_e7m1_ai_place_loc_max - 1 );
	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6A_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6A_watcher_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6A_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6A_knight_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_6A_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,5), flg_e7m1_area_6A_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(3,4), flg_e7m1_area_6a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(3,4), flg_e7m1_area_6a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_6B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_veh_thread = sys_e7m1_area_place_thread( r_objcon_veh_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 	//dprint( "f_e7m1_area_6B_place_action" );
//gmurphy - 7904 - losing max wraith (from 2 to 1) for perf//
//	thread( f_e7m1_ai_place_loc_wraith(l_objcon_veh_thread, sid_objective, 1, flg_e7m1_area_6b_wraith_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6b_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6b_knight_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 2, flg_e7m1_area_6b_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,6), flg_e7m1_area_6b_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,6), flg_e7m1_area_6b_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_6C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_6C_place_action" );

	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6c_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6c_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_6c_knight_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,6), flg_e7m1_area_6c_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,6), flg_e7m1_area_6c_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_6c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_7A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_7A_place_action" );

	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,6), flg_e7m1_area_7a_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(6,9), flg_e7m1_area_7a_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_7a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_7a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_7B_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 	//dprint( "f_e7m1_area_7B_place_action" );

	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_7b_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_7b_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,2), flg_e7m1_area_7b_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_7b_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static void f_e7m1_area_7C_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
	//dprint( "f_e7m1_area_7C_place_action" );

	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 2, flg_e7m1_area_7c_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_7c_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,9), flg_e7m1_area_7c_crawler_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_objcon_fore_thread, sid_objective, random_range(3,9), flg_e7m1_area_7c_crawler_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(2,3), flg_e7m1_area_7c_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_objcon_cov_thread, sid_objective, random_range(3,4), flg_e7m1_area_7c_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
 
end

script static void f_e7m1_area_8A_place_action( real r_objcon_cov_max, real r_objcon_veh_max, real r_objcon_fore_max, short s_body_count, short s_level, string_id sid_objective, ai ai_enemy_task, short s_enemy_task_max, real r_priority, real r_conditional_distance, real r_force_distance )
local long l_objcon_cov_thread = sys_e7m1_area_place_thread( r_objcon_cov_max, s_body_count );
local long l_objcon_fore_thread = sys_e7m1_area_place_thread( r_objcon_fore_max, s_body_count );
 //dprint( "f_e7m1_area_8A_place_action" );

	thread( f_e7m1_ai_place_loc_knight(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_8a_knight_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_objcon_fore_thread, sid_objective, 1, flg_e7m1_area_8a_watcher_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,3), flg_e7m1_area_8a_unit_01, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,3), flg_e7m1_area_8a_unit_02, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED_HIGH, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_objcon_cov_thread, sid_objective, random_range(1,3), flg_e7m1_area_8a_unit_03, r_priority, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, r_conditional_distance, r_force_distance, -1.0, ai_enemy_task, s_enemy_task_max, 0.0) );

end

script static long sys_e7m1_area_place_thread( real r_objcon, short s_body_count )
	thread( f_e7m1_area_place_thread(r_objcon, s_body_count) );
end
script static void f_e7m1_area_place_thread( real r_objcon, short s_body_count )
	sleep_until( (R_e7m1_objcon >= r_objcon) or (S_e7m1_ai_body_cnt >= s_body_count), 1 );
end

script dormant f_e7m1_finale_place()

	// start waves
	wake( f_e7m1_finale_wave_01 );

	// wake up objcon acceleration
	wake( f_e7m1_ai_objcon_accelerate );

	// start aggressive garbage collect
	spops_ai_garbage_combat_status_max_default( ai_combat_status_dangerous );
	spops_ai_garbage_distance_conditional_default( 25.0 );
	spops_ai_garbage_distance_force_default( 40.0 );

end

script dormant f_e7m1_finale_wave_01()
	//dprint( "f_e7m1_finale_wave_01" );

	f_e7m1_finale_wave_grunt( GetCurrentThreadID() );
	//f_e7m1_finale_wave_crawler( GetCurrentThreadID() );
	
	// wait for next wave
	f_e7m1_finale_wait( 15, 45.0 );
	wake( f_e7m1_finale_wave_02 );

end

script dormant f_e7m1_finale_wave_02()
	//dprint( "f_e7m1_finale_wave_02" );

	f_e7m1_finale_wave_cov_basic( GetCurrentThreadID() );
	//f_e7m1_finale_wave_crawler( GetCurrentThreadID() );
	
	// wait for next wave
	f_e7m1_finale_wait( 20, 60.0 );
	wake( f_e7m1_finale_wave_03 );

end

script dormant f_e7m1_finale_wave_03()
	//dprint( "f_e7m1_finale_wave_03" );

	f_e7m1_finale_wave_cov( GetCurrentThreadID() );
	f_e7m1_finale_wave_watcher( GetCurrentThreadID() );
	//f_e7m1_finale_wave_crawler( GetCurrentThreadID() );
	
	// wait for next wave
	f_e7m1_finale_wait( 15, 45.0 );
	wake( f_e7m1_finale_wave_04 );

end

script dormant f_e7m1_finale_wave_04()
	//dprint( "f_e7m1_finale_wave_04" );

	f_e7m1_finale_wave_knight( GetCurrentThreadID() );
	f_e7m1_finale_wave_cov( GetCurrentThreadID() );
	f_e7m1_finale_wave_watcher( GetCurrentThreadID() );
	//f_e7m1_finale_wave_crawler( GetCurrentThreadID() );
	
	// wait for mop up
	f_e7m1_finale_wait( 30, 60.0 );
	wake( f_e7m1_finale_wave_mopup );

end

script dormant f_e7m1_finale_wave_mopup()
	//dprint( "f_e7m1_finale_wave_mopup" );

	// wait for mop up
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A, 1 );
	local long l_garbage_thread_01 = thread( sys_spops_ai_garbage_objlist(volume_return_objects_by_type(tv_e7m1_finale_garbage_a, s_objtype_biped), DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, 20.0, 35.0, 30.0, 0.0, ai_combat_status_asleep, ai_combat_status_dangerous, 5, 5) );
	sleep(1);
	local long l_garbage_thread_02 = thread( sys_spops_ai_garbage_objlist(volume_return_objects_by_type(tv_e7m1_finale_garbage_b, s_objtype_biped), DEF_SPOPS_AI_GARBAGE_TYPE_ERASE, 20.0, 35.0, 30.0, 0.0, ai_combat_status_asleep, ai_combat_status_dangerous, 5, 5) );
	sleep_until( (not isthreadvalid(l_garbage_thread_01)) and (not isthreadvalid(l_garbage_thread_02)), 10 );
	
	//dprint( "f_e7m1_finale_wave_mopup: MOP UP" );
	sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_8A, 10 );
	sleep_until( ai_living_count(gr_e7m1_pool) <= spops_ai_mop_up_cnt(), 10 );
	if ( ai_living_count(gr_e7m1_pool) > 0 ) then
		spops_audio_music_event( 'play_mus_pve_e07m1_objective_lz_clear_mop_up', "play_mus_pve_e07m1_objective_lz_clear_mop_up" );
		spops_blip_ai( gr_e7m1_pool, TRUE, "enemy" );
	end

	sleep_until( ai_living_count(gr_e7m1_pool) <= 0, 1 );
	B_e7m1_objective_lz_cleared = TRUE;

end

script static void f_e7m1_finale_wave_grunt( long l_thread )

	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_05, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_06, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_04, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );
	thread( f_e7m1_ai_place_loc_grunt(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );

end

script static void f_e7m1_finale_wave_cov_basic( long l_thread )

	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_05, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_06, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_04, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );
	thread( f_e7m1_ai_place_loc_cov_basic(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );

end

script static void f_e7m1_finale_wave_cov( long l_thread )

	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_05, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_6A, -1, flg_e7m1_finale_unit_06, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_unit_04, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );
	thread( f_e7m1_ai_place_loc_cov(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_unit_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, DEF_E7M1_FINALE_CONDITIONAL_DISTANCE, DEF_E7M1_FINALE_FORCE_DISTANCE, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_7A) );

end

script static void f_e7m1_finale_wave_crawler( long l_thread )

	thread( f_e7m1_ai_place_loc_crawler(l_thread, DEF_E8M2_OBJECTIVE_AREA_6C, -1, flg_e7m1_finale_crawler_04, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_crawler(l_thread, DEF_E8M2_OBJECTIVE_AREA_7A, -1, flg_e7m1_finale_crawler_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_6C) );
	thread( f_e7m1_ai_place_loc_crawler(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_crawler_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_6C) );
	thread( f_e7m1_ai_place_loc_crawler(l_thread, DEF_E8M2_OBJECTIVE_AREA_7C, -1, flg_e7m1_finale_crawler_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_LOW_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_6C) );
	thread( f_e7m1_ai_place_loc_crawler(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_crawler_05, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, DEF_E7M1_AI_OBJCON_AREA_6C) );

end

script static void f_e7m1_finale_wave_watcher( long l_thread )

	thread( f_e7m1_ai_place_loc_watcher(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_watcher_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_watcher_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_watcher(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_watcher_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_MED, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );

end

script static void f_e7m1_finale_wave_knight( long l_thread )

	thread( f_e7m1_ai_place_loc_knight(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_knight_01, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_knight_02, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_knight_03, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_knight_04, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );
	thread( f_e7m1_ai_place_loc_knight(l_thread, DEF_E8M2_OBJECTIVE_AREA_8A, -1, flg_e7m1_finale_knight_05, 1.0, DEF_E7M1_AI_PLACE_PRIORITY_MOD_HIGH, 1.0, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, S_e7m1_ai_place_loc_max, 0.0) );

end

script static void f_e7m1_finale_wait( short s_body_cnt, real r_timer )
local short s_body_count = S_e7m1_ai_body_cnt + s_body_cnt;
local long l_timer = timer_stamp( r_timer );
local real r_objcon_min = bound_r( R_e7m1_objcon + 0.1, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_7A );

	sleep_until( (timer_expired(l_timer) and (R_e7m1_objcon >= r_objcon_min)) or (S_e7m1_ai_body_cnt >= s_body_count), 1 );

end
