//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	horseshoe (or iho)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HORSESHOE: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean 	B_horseshoe_center_dropoffs_complete = 							FALSE;
global boolean  B_horseshoe_center_drop_2_complete =        				FALSE; 
global boolean  B_horseshoe_center_drop_3_complete = 								FALSE;
global boolean  B_horseshoe_center_drop_1_complete = 								FALSE; 
global short 		S_horseshoe_center_oni_behavior = 									0;
global short 		S_horseshoe_right_oni_behavior = 										0;
global boolean 	B_horseshoe_center_break = 													FALSE;
global boolean  B_horseshoe_entered_center_building_normally =			FALSE;
global short    S_hs_aicount = 																			0;
global short    S_hs_difficulty =																			0;
global boolean  B_phantom_active = 																	FALSE;


// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_init::: Initialize
script dormant f_horseshoe_ai_init()
	//dprint( "::: f_horseshoe_ai_init :::" );

	sleep_until( (zoneset_current_active() >= S_ZONESET_TO_HORSESHOE) and (zoneset_current_active() <= S_ZONESET_HORSESHOE), 1 );
	
	// init sub modules
	wake( f_horseshoe_ai_objcon_init );
	wake( f_horseshoe_ai_watchers_init );
	wake( f_horseshoe_ai_start_init );
	wake( f_horseshoe_ai_phantoms_init );
	wake( f_horseshoe_ai_right_init );
	wake( f_horseshoe_ai_left_init );
	wake( f_horseshoe_ai_center_init );

end

// === f_horseshoe_ai_deinit::: Deinitialize
script dormant f_horseshoe_ai_deinit()
	//dprint( "::: f_horseshoe_ai_deinit :::" );
	
	// deinit sub modules
	wake( f_horseshoe_ai_objcon_deinit );
	wake( f_horseshoe_ai_watchers_deinit );
	wake( f_horseshoe_ai_start_deinit );
	wake( f_horseshoe_ai_phantoms_deinit );
	wake( f_horseshoe_ai_right_deinit );
	wake( f_horseshoe_ai_left_deinit );
	wake( f_horseshoe_ai_center_deinit );
	
	// erase ai
	f_ai_garbage_erase( sg_horseshoe );
	
	// garbage collect
	garbage_collect_now();

	// kill functions
	kill_script( f_horseshoe_ai_init );

end




// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_horseshoe_objcon = 					-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_objcon_init::: Initialize
script dormant f_horseshoe_ai_objcon_init()
	//dprint( "::: f_horseshoe_ai_objcon_init :::" );
	
	// init sub modules
	wake( f_horseshoe_ai_objcon_trigger );

end

// === f_horseshoe_ai_objcon_deinit::: Deinitialize
script dormant f_horseshoe_ai_objcon_deinit()
	//dprint( "::: f_horseshoe_ai_objcon_deinit :::" );

	// kill functions
	kill_script( f_horseshoe_ai_objcon_init );
	kill_script( f_horseshoe_ai_objcon_trigger );

end

// === f_horseshoe_ai_objcon_trigger::: Triggers objcon states
script dormant f_horseshoe_ai_objcon_trigger()
	//dprint( "::: f_horseshoe_ai_objcon_trigger :::" );
	
	sleep_until( object_valid(door_horseshoe_enter) and (f_horseshoe_started()), 1 );
	f_horseshoe_ai_objcon_set( 0 );
	
	sleep_until (volume_test_players (tv_hs_objcon_10), 1 );
	f_horseshoe_ai_objcon_set( 10 );

	sleep_until (volume_test_players (tv_hs_objcon_15) or volume_test_players (tv_hs_objcon_16), 1 );
	if( volume_test_players (tv_hs_objcon_15) ) then
		sleep_s( 1.5 );
		f_horseshoe_ai_objcon_set( 15 );
	else
		f_horseshoe_ai_objcon_set( 16 );
	end

	sleep_until( volume_test_players( tv_hs_objcon_20_1 ) or volume_test_players( tv_hs_objcon_20_2 ) or volume_test_players( tv_hs_objcon_20_3 ), 1 );
	f_horseshoe_ai_objcon_set( 20 );

	sleep_until( volume_test_players( tv_hs_objcon_30), 1 );
	f_horseshoe_ai_objcon_set( 30 );
// @todo: PUT THIS IN THE RIGHT PLACE
	ai_place(sg_hs_center_snipers);

end

// === f_horseshoe_ai_objcon_set::: Set objcon
script static void f_horseshoe_ai_objcon_set( short s_objcon )

	if ( s_objcon > S_horseshoe_objcon ) then
		S_horseshoe_objcon = s_objcon;
		//inspect( S_horseshoe_objcon );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: WATCHERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_watchers_init::: Init
script dormant f_horseshoe_ai_watchers_init()
	
	// Keeping track of whether the player bypasses encounters

	// setup trigger
	wake( f_horseshoe_ai_watcher_center_entrance );
	wake( f_horseshoe_ai_watcher_center_bypass );
	
end

// === f_horseshoe_ai_watchers_deinit::: Deinit
script dormant f_horseshoe_ai_watchers_deinit()
	
	// kill functions
	kill_script( f_horseshoe_ai_watchers_init );
	kill_script( f_horseshoe_ai_watcher_center_entrance );
  kill_script( f_horseshoe_ai_watcher_center_bypass );
	
end

// === f_horseshoe_ai_watcher_center_entrance::: XXX
script dormant f_horseshoe_ai_watcher_center_entrance()

	sleep_until( 
		volume_test_players( tv_hs_entered_center_bottom_path ) or 
		volume_test_players( tv_hs_entered_center_ninja_path ) 
	, 1 );
	B_horseshoe_entered_center_building_normally = TRUE;

end

// === f_horseshoe_ai_watcher_center_entrance::: XXX

script dormant f_horseshoe_ai_watcher_center_bypass()

	sleep_until( 
		volume_test_players( tv_hs_center_platform_left ) or 
		volume_test_players( tv_hs_center_platform_right ) or 
		volume_test_players( tv_hs_center_lower_area ) or 
		volume_test_players( tv_hs_center_upper_area ) or
		volume_test_players( tv_hs_center_bypass )
	, 1 );

	if( not B_horseshoe_entered_center_building_normally ) then
		sleep_forever( f_horseshoe_ai_watcher_center_entrance );
		B_horseshoe_bypassed_side_right = TRUE;
	end
	B_horseshoe_reached_center = TRUE;

end

script dormant f_difficulty_set()

	if game_is_cooperative()then 
		S_hs_difficulty = S_hs_difficulty + 1;
	end
	
	if game_difficulty_get_real() == "legendary" then
		S_hs_difficulty = S_hs_difficulty + 1;
	end

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_start_init::: Initialize
script dormant f_horseshoe_ai_start_init()
	
	// init sub modules
	wake( f_horseshoe_ai_start_trigger );

end

// === f_horseshoe_ai_start_deinit::: Deinitialize
script dormant f_horseshoe_ai_start_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_start_init );
	kill_script( f_horseshoe_ai_start_trigger );
	kill_script( f_horseshoe_ai_start_spawn );
	kill_script( f_horseshoe_ai_start_human_spawn );

end

// === f_horseshoe_ai_start_trigger::: Trigger
script dormant f_horseshoe_ai_start_trigger()
	sleep_until( TRUE, 1 );
	
	// init sub modules
	wake( f_horseshoe_ai_start_spawn );

end

// === f_horseshoe_ai_start_spawn::: Spawn
script dormant f_horseshoe_ai_start_spawn()

	// phantoms
	wake( f_horseshoe_ai_start_human_spawn );

end

// === f_horseshoe_ai_start_human_spawn::: Spawn
script dormant f_horseshoe_ai_start_human_spawn()

	// set allegiance
	//ai_allegiance( player, human );

	// right oni
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_right_oni );
		ai_braindead( humans_hs_right_oni.jackal_attack, TRUE );
		ai_set_blind(  humans_hs_right_oni.jackal_attack, TRUE);
		ai_set_deaf( humans_hs_right_oni.jackal_attack, TRUE);
		ai_disregard( ai_get_object(humans_hs_right_oni.jackal_attack), TRUE );
		object_cannot_take_damage( ai_get_object(humans_hs_right_oni.jackal_attack) );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: PHANTOMS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real G_horseshoe_phantom_approach_speed_initial = 	0.75;
global real G_horseshoe_phantom_approach_speed_final = 		0.5;
global real G_horseshoe_phantom_approach_dist = 					0.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_phantoms_init::: Initialize
script dormant f_horseshoe_ai_phantoms_init()
	
	// init sub modules
	wake( f_horseshoe_ai_phantoms_trigger );

end

// === f_horseshoe_ai_phantoms_deinit::: Deinitialize
script dormant f_horseshoe_ai_phantoms_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_phantoms_init );
	kill_script( f_horseshoe_ai_phantoms_trigger );
	kill_script( f_horseshoe_ai_phantoms_spawn );
//	kill_script( f_horseshoe_ai_phantom_explosion );
	kill_script( f_horseshoe_ai_phantom_gunner_left_target );

end

// === f_horseshoe_ai_phantoms_trigger::: Trigger
script dormant f_horseshoe_ai_phantoms_trigger()
	sleep_until( TRUE, 1 );
	
	// init sub modules
	wake( f_horseshoe_ai_phantoms_spawn );

end

// === f_horseshoe_ai_phantoms_spawn::: Spawn
script dormant f_horseshoe_ai_phantoms_spawn()

	// center run	
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_hs_start_phantom_center_run );

	// left	
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_hs_start_phantom_left );

	// right
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_hs_start_phantom_right );

	f_ai_spawn_delay_wait( TRUE, -1 );

end


// === f_horseshoe_ai_phantom_gunner_left_target::: XXX
script dormant f_horseshoe_ai_phantom_gunner_left_target()

	repeat
	
		object_move_by_offset( hs_phantom_left_gunner_target, 4.0, 0.0, 4.0, 0.0 );
		object_move_by_offset( hs_phantom_left_gunner_target, 2.0, 0.0, 0.0, -2.0 );
		object_move_by_offset( hs_phantom_left_gunner_target, 4.0, 0.0, -4.0, 0.0 );
		object_move_by_offset( hs_phantom_left_gunner_target, 2.0, 0.0, 0.0, 2.0 );
		
	until( FALSE, 1 );

end

// === f_horseshoe_phantom_approach_speed_initial_set::: XXX
script static void f_horseshoe_phantom_approach_speed_initial_set( real r_speed )
	if ( G_horseshoe_phantom_approach_speed_initial != r_speed ) then
		G_horseshoe_phantom_approach_speed_initial = r_speed;
		//inspect( G_horseshoe_phantom_approach_speed_initial );
	end
end

// === f_horseshoe_phantom_approach_speed_final_set::: XXX
script static void f_horseshoe_phantom_approach_speed_final_set( real r_speed )
	if ( G_horseshoe_phantom_approach_speed_final != r_speed ) then
		G_horseshoe_phantom_approach_speed_final = r_speed;
		//inspect( G_horseshoe_phantom_approach_speed_final );
	end
end

// === f_horseshoe_phantom_approach_dist_set::: XXX
script static void f_horseshoe_phantom_approach_dist_set( real r_dist )
	if ( G_horseshoe_phantom_approach_dist != r_dist ) then
		G_horseshoe_phantom_approach_dist = r_dist;
		//inspect( G_horseshoe_phantom_approach_dist );
	end
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: PHANTOMS: COMMAND SCRIPTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_phantom_explosion::: Command AI
script command_script cs_hs_start_phantom_right()
sleep_until( f_horseshoe_started(), 1 );

	// This phantom is spawned in position
	cs_ignore_obstacles( ai_current_actor, TRUE );
	sleep_s( 8.0 );
	cs_fly_to_and_face( ps_hs_phantom_right.p0, ps_hs_phantom_right.p0_face );	
	cs_fly_to( ps_hs_phantom_right.p1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 120 );
	cs_fly_to( ps_hs_phantom_right.p2 );
	sleep_s( 3.0 );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end

// === cs_hs_start_phantom_boom::: Command AI
script command_script cs_hs_start_phantom_boom()
sleep_until( f_horseshoe_started(), 1 );

	cs_ignore_obstacles( ai_current_actor, TRUE );
	cs_fly_to( ps_hs_phantom_boom.destination );
	
end

// === cs_horseshoe_phantom_center_run::: Command AI
script command_script cs_horseshoe_phantom_center_run()
sleep_until( f_horseshoe_started(), 1 );

	f_ai_spawn_delay_wait( TRUE, -1 );

	ai_place( sq_hs_start_platform_run_1 );
	f_load_phantom( sq_hs_start_phantom_center_run, "chute", sq_hs_start_platform_run_1.spawn_points_0, sq_hs_start_platform_run_1.spawn_points_1, sq_hs_start_platform_run_1.spawn_points_2, NONE );
	sleep_s( 10.0 );
	//f_unload_phantom( sq_hs_start_phantom_center_run, "chute" );
	vehicle_unload ( ai_vehicle_get( ai_current_actor ), "phantom_pc_1" );
	sleep_s( 1.5 );
	vehicle_unload ( ai_vehicle_get( ai_current_actor ), "phantom_pc_2" );
	sleep_s( 2.75 );
	vehicle_unload ( ai_vehicle_get( ai_current_actor ), "phantom_pc_3" );
	sleep_s( 4.0 );
	NotifyLevel( "Horseshoe center run phantom finished dropoff" );
	cs_fly_to( ps_hs_phantom_center_02.p1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 120 );
	cs_fly_to( ps_hs_phantom_center_02.p2	 );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end

// === cs_hs_start_phantom_left::: Command AI
script command_script cs_hs_start_phantom_left()
sleep_until( f_horseshoe_started(), 1 );

	vehicle_load_magic( object_at_marker(ai_vehicle_get_from_spawn_point(sq_hs_start_phantom_left.driver), "turret_l"), "", ai_get_object(sq_hs_start_phantom_left.gunner) );
	cs_ignore_obstacles( ai_current_actor, TRUE );
	cs_fly_to_and_face( ps_hs_start_phantom_left.p0, ps_hs_start_phantom_left.p0_face );
	cs_fly_to_and_face( ps_hs_start_phantom_left.p0, ps_hs_start_phantom_left.p0_face );
	NotifyLevel( "hs_start_phantom_left fire!" );
	sleep_s( 10.0 );
	NotifyLevel( "hs_start_phantom_left cease fire!" );
	cs_fly_to( ps_hs_start_phantom_left.p1 );
	object_set_scale( ai_vehicle_get( ai_current_actor ), 0.01, 120 );
	cs_fly_to( ps_hs_start_phantom_left.p2 );
	sleep_s( 3.0 );
	object_destroy( ai_vehicle_get( ai_current_actor ) );
	
end

// === cs_hs_start_phantom_left_gunner::: Command AI
script command_script cs_hs_start_phantom_left_gunner()
sleep_until( f_horseshoe_started(), 1 );

	sleep_until( LevelEventStatus( "hs_start_phantom_left fire!" ), 1 );
	object_create( hs_phantom_left_gunner_target );
	object_hide( hs_phantom_left_gunner_target, TRUE );
	wake( f_horseshoe_ai_phantom_gunner_left_target );
	cs_shoot( TRUE, hs_phantom_left_gunner_target );
	
	sleep_until( LevelEventStatus( "hs_start_phantom_left cease fire!" ), 1 );
	cs_shoot( TRUE, hs_phantom_left_gunner_target );
	sleep_forever( f_horseshoe_ai_phantom_gunner_left_target );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: RIGHT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_right_init::: Initialize
script dormant f_horseshoe_ai_right_init()
	
	// init sub modules
	wake( f_horseshoe_ai_right_trigger );
	
	// setup 
	wake( f_horseshoe_ai_right_oni_control );

end

// === f_horseshoe_ai_right_deinit::: Deinitialize
script dormant f_horseshoe_ai_right_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_right_init );
	kill_script( f_horseshoe_ai_right_trigger );
	kill_script( f_horseshoe_ai_right_garbage );
	
	kill_script( f_horseshoe_ai_right_spawn_first );
	kill_script( f_horseshoe_ai_right_spawn_first_enemy );
	kill_script( f_horseshoe_ai_right_spawn_first_human );
	kill_script( f_horseshoe_ai_right_spawn_first_dead );
	
	kill_script( f_horseshoe_ai_right_spawn_second );

	kill_script( f_horseshoe_ai_right_oni_control );

end

// === f_horseshoe_ai_right_garbage::: Garbage
script dormant f_horseshoe_ai_right_garbage()

	if( not B_horseshoe_bypassed_side_right ) then
//		f_ai_garbage_erase( sq_hs_pier_js, 20.0, -1, -1, -1, FALSE );
		f_ai_garbage_erase( sg_hs_right_start, 20.0 );
		f_ai_garbage_erase( sg_hs_right_second, 20.0 );
	else
		f_ai_garbage_erase( sg_hs_right_start, 10.0 );
		f_ai_garbage_erase( sg_hs_right_second, 10.0 );
	end
	f_ai_garbage_erase( sg_hs_humans_right, 15.0 );

	// garbage collect
	garbage_collect_now();

end

// === f_horseshoe_ai_right_trigger::: Trigger
script dormant f_horseshoe_ai_right_trigger()
	
	// first encounter
	sleep_until( TRUE, 1 );
	wake( f_horseshoe_ai_right_spawn_first );

	// second encounter
	sleep_until( volume_test_players(tv_hs_right_second_fight_start) or B_horseshoe_bypassed_side_right, 1 );
	wake( f_horseshoe_ai_right_spawn_second );

end

// === f_horseshoe_ai_right_spawn_first::: Action
script dormant f_horseshoe_ai_right_spawn_first()

	// spawn
	wake( f_horseshoe_ai_right_spawn_first_enemy );
	wake( f_horseshoe_ai_right_spawn_first_human );
	wake( f_horseshoe_ai_right_spawn_first_dead );

end

// === f_horseshoe_ai_right_spawn_first_human::: Spawn
script dormant f_horseshoe_ai_right_spawn_first_human()

	// set allegiance
	//ai_allegiance( player, human );
	
	// flee
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_right_sci_flee );
//		units_set_maximum_vitality( ai_actors(humans_hs_right_sci_flee), 0.10, 0.0 );
//		units_set_current_f( ai_actors(humans_hs_right_sci_flee), 0.10, 0.0 );
		object_cannot_take_damage( ai_actors(humans_hs_right_sci_flee) );

	// undo cannot take damage
	sleep_until( f_horseshoe_started(), 1 );
	object_can_take_damage( ai_actors(humans_hs_right_sci_flee) );

end



// === f_horseshoe_ai_right_spawn_first_enemy::: Spawn
script dormant f_horseshoe_ai_right_spawn_first_enemy()

	// right
//	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_hs_right_start );
		object_cannot_take_damage( ai_actors(sg_hs_right_start) );
	wake(f_kill_right);

	// setup special jackal 
	sleep_until( ai_living_count(sq_hs_right_jackal_attack.jackal_01) > 0, 1 );
		ai_braindead( sq_hs_right_jackal_attack.jackal_01, TRUE );
		ai_disregard( ai_get_object(sq_hs_right_jackal_attack.jackal_01), TRUE );

	// snipers
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_hs_right_second_snipers );
		object_cannot_take_damage( ai_actors(sg_hs_right_second_snipers) );
//	ai_place( sg_hs_sniper );
//	object_cannot_take_damage( ai_actors(sg_hs_sniper) );
	
	// undo cannot take damage
	sleep_until( f_horseshoe_started(), 1 );
	object_can_take_damage( ai_actors(sg_hs_right_start) );
	ai_renew( sg_hs_right_start );
//	ai_renew( sg_hs_sniper );
	object_can_take_damage( ai_actors(sg_hs_right_second_snipers) );
//	object_can_take_damage( ai_actors(sg_hs_sniper) );

end

// === f_horseshoe_ai_right_spawn_first_dead::: Spawn
script dormant f_horseshoe_ai_right_spawn_first_dead()
	
	// dead
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_right_sci_dead );
		ai_kill_silent( humans_hs_right_sci_dead );

end

// === f_horseshoe_ai_right_spawn_second::: Spawn
script dormant f_horseshoe_ai_right_spawn_second()

	if( not B_horseshoe_bypassed_side_right ) then
		f_ai_spawn_delay_wait( TRUE, -1 );
		ai_place( sg_hs_right_second_non_sniper );
	end

end

// === f_horseshoe_ai_right_oni_control::: Right ONI controller
script dormant f_horseshoe_ai_right_oni_control()

	S_horseshoe_right_oni_behavior = 0;
	sleep_until( ai_living_count( sg_hs_right_start ) <= 6 );	//dprint( "ONI Security: cautious advance" );
	S_horseshoe_right_oni_behavior = 1;
	// Jackal Sniper in second fight area + however many we want left alive in the first fight
	sleep_until( ai_living_count( sg_hs_right_start ) <= 2 );
	S_horseshoe_right_oni_behavior = 2;
	sleep_until( ai_living_count( sg_hs_right_second ) <= 5 );
	S_horseshoe_right_oni_behavior = 3;
	sleep_until( ai_living_count( sg_hs_right ) <= 0 );
	S_horseshoe_right_oni_behavior = 4;
		
end

script dormant f_kill_right()
	sleep_until( volume_test_players(tv_hs_center_start) and not volume_test_players(tv_hs_noplayersinright), 1);
	sleep_s(5);
	ai_kill(sg_hs_right);
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: CENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_center_init::: Initialize
script dormant f_horseshoe_ai_center_init()
	
	// init sub modules
	wake( f_horseshoe_ai_center_trigger );

end

// === f_horseshoe_ai_center_deinit::: Deinitialize
script dormant f_horseshoe_ai_center_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_center_init );
	kill_script( f_horseshoe_ai_center_trigger );
	kill_script( f_horseshoe_ai_center_action );
	
	kill_script( f_horseshoe_ai_center_spawn );
	kill_script( f_horseshoe_ai_center_human_spawn );
	kill_script( f_horseshoe_ai_center_enemy_spawn );

	kill_script( f_horseshoe_ai_center_check_berserk );
	kill_script( f_horseshoe_ai_center_check_break );
	kill_script( f_horseshoe_ai_center_check_balcony );

end

// === f_horseshoe_ai_center_trigger::: Trigger
script dormant f_horseshoe_ai_center_trigger()

	sleep_until( B_horseshoe_bypassed_side_right or volume_test_players(tv_hs_right_second_fight_start) or volume_test_players(tv_hs_top_center_bypass), 1 );
	//dprint( "::: f_horseshoe_ai_center_trigger: MAIN :::" );
	wake( f_horseshoe_ai_center_spawn );

	sleep_until( B_horseshoe_bypassed_side_right or volume_test_players(tv_hs_center_start) or volume_test_players(tv_hs_top_center_bypass), 1 );
	wake( f_horseshoe_ai_center_action );
	ai_kill( sg_hs_humans_right);

end

// === f_horseshoe_ai_center_spawn::: Spawn
script dormant f_horseshoe_ai_center_spawn()

	// spawn
	wake( f_horseshoe_ai_center_human_spawn );
	wake( f_horseshoe_ai_center_enemy_spawn );

end

// === f_horseshoe_ai_center_human_spawn::: Spawn
script dormant f_horseshoe_ai_center_human_spawn()
	sleep_until( volume_test_players(tv_hs_place_center_humans1) or volume_test_players(tv_hs_place_center_humans2) , 1 );

	// set allegiance
	//ai_allegiance( player, human );

	// spawn
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_center_oni_1 );

	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_center_oni_2 );	

	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( humans_hs_center_oni_civ );
		
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place(humans_hs_center_oni_dead);
	ai_kill_silent(humans_hs_center_oni_dead );
	
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place(	sq_hs_elite_killed);
	ai_kill_silent(	sq_hs_elite_killed );
	
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place(	sq_hs_center_initial_2);
	
end

// === f_horseshoe_ai_center_enemy_spawn::: Spawn
script dormant f_horseshoe_ai_center_enemy_spawn()

	f_ai_spawn_delay_wait( TRUE, -1 );

end

// === F_Horseshoe_Ai_Center_Action::: Action
script dormant f_horseshoe_ai_center_action()

	// kill center human placement
	kill_script( f_horseshoe_ai_center_human_spawn );

	// setup checks
	wake( f_horseshoe_ai_center_check_berserk );
	wake( f_horseshoe_ai_center_check_break );
	wake( f_horseshoe_ai_center_check_balcony );

	cs_run_command_script( sq_hs_start_platform_run_1.spawn_points_0, cs_hs_center_run_enemy_cancel );
	cs_run_command_script( sq_hs_start_platform_run_1.spawn_points_1, cs_hs_center_run_enemy_cancel );
	cs_run_command_script( sq_hs_start_platform_run_1.spawn_points_2, cs_hs_center_run_enemy_cancel );

	// Place center phantom 1
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( phantom_center_drop_1 );
	
	S_hs_aicount = ai_living_count (sg_center_count) + ai_living_count (sg_hs_center) + ai_living_count (sg_hs_humans_center); 
	
	sleep_until( LevelEventStatus("m80 hs center phantom drop 1 unload") or ai_living_count(phantom_center_drop_1) <= 0, 1 );
	ai_prefer_target_ai( sg_hs_humans_center, sg_hs_center_initial_core, FALSE );
	ai_prefer_target_ai( sg_hs_humans_center, sg_hs_center_drop, TRUE );
	
	// Setup Center Cleanup
	
	wake( f_horseshoe_ai_center_cleanup );
	
	// Place center phantom 2
	sleep_s( 2.0 );
	sleep_until(B_horseshoe_center_drop_1_complete and 
				ai_living_count (sg_center_count) + ai_living_count (sg_hs_center) + ai_living_count (sg_hs_humans_center) <= 12 ,1);
	if  f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD())then
		f_ai_spawn_delay_wait( TRUE, -1 );
		ai_place( phantom_center_drop_2 );
	end
	
	
	// Place center phantom 3
sleep_until(B_horseshoe_center_drop_2_complete and 
				ai_living_count (sg_center_count) + ai_living_count (sg_hs_center) + ai_living_count (sg_hs_humans_center) <= 12 ,1);
	if f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()) then
		f_ai_spawn_delay_wait( TRUE, -1 );
		ai_place( phantom_center_drop_3 );
	end

	// Place center phantom 4
sleep_until(B_horseshoe_center_drop_3_complete and 
				ai_living_count (sg_center_count) + ai_living_count (sg_hs_center) + ai_living_count (sg_hs_humans_center) <= 12 ,1);
	if f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()) then
		f_ai_spawn_delay_wait( TRUE, -1 );
		ai_place( phantom_center_drop_4 );
	end
		
end

// === f_horseshoe_ai_center_check_break::: Check

script dormant f_horseshoe_ai_center_check_break()

	sleep_until( 
		B_horseshoe_center_dropoffs_complete and 
			ai_living_count( sg_hs_center_initial_core ) + ai_living_count( sg_center_count ) - ai_living_count( sg_hs_center_pier_guard ) <= 3
			, 1 );
	B_horseshoe_center_break = TRUE;

end


// === f_horseshoe_ai_center_check_berserk::: Check
script dormant f_horseshoe_ai_center_check_berserk()

	sleep_until( volume_test_players(tv_hs_go_berserk) or f_ai_is_partially_defeated(sg_hs_center_pier_guard, 2), 1 );
	sleep_s( 1.5 );
	ai_berserk( sq_hs_center_initial_zealot, TRUE );
	
end

// === f_horseshoe_ai_center_check_balcony::: Check
script dormant f_horseshoe_ai_center_check_balcony()

	sleep_until (volume_test_players(tv_hs_center_balcony_center), 1 );
	B_horseshoe_on_balcony = true;
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: CENTER: COMMAND SCRIPTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_hs_center_run_enemy_1()
sleep_until( f_horseshoe_started(), 1 );


	sleep_until( objects_distance_to_object( ai_vehicle_get(sq_hs_start_phantom_center_run.driver), ai_get_object(ai_current_actor) ) >= 2.0, 1 );
	cs_stationary_face( TRUE, ps_hs_center_run.p0 );
	// In case he needs to wait for the Grunts
	//sleep_s( 0.50 );
	// To get him moving the same speed as the Grunts
	cs_throttle_set( TRUE, 0.40 );
	cs_go_to( ps_hs_center_run.p0 );
	ai_erase( ai_current_actor );

end

script command_script cs_hs_center_run_enemy_2()
sleep_until( f_horseshoe_started(), 1 );

	sleep_until( objects_distance_to_object( ai_vehicle_get(sq_hs_start_phantom_center_run.driver), ai_get_object(ai_current_actor) ) >= 2.0, 1 );
	cs_go_to( ps_hs_center_run.p1 );
	ai_erase( ai_current_actor );
	
end

script command_script cs_hs_center_run_enemy_3()
sleep_until( f_horseshoe_started(), 1 );

	sleep_until( objects_distance_to_object( ai_vehicle_get(sq_hs_start_phantom_center_run.driver), ai_get_object(ai_current_actor) ) >= 2.0, 1 );
	cs_go_to( ps_hs_center_run.p2 );
	ai_erase( ai_current_actor );
	
end

script command_script cs_hs_center_run_enemy_4()
sleep_until( f_horseshoe_started(), 1 );

	cs_go_to( ps_hs_center_run.p3 );
	ai_erase( ai_current_actor );
	
end

script command_script cs_hs_center_run_enemy_5()
sleep_until( f_horseshoe_started(), 1 );

	cs_go_to( ps_hs_center_run.p4 );
	ai_erase( ai_current_actor );
	
end

script command_script cs_hs_center_run_enemy_6()
sleep_until( f_horseshoe_started(), 1 );

	cs_go_to( ps_hs_center_run.p5 );
	ai_erase( ai_current_actor );
	
end	

script command_script cs_hs_center_run_enemy_cancel()
sleep_until( f_horseshoe_started(), 1 );

	sleep( 1 );
	
end

// === The Phantom Drop Wave
// === Tom, don't give me any shit - if I had the time I'd turn these all into one function :P <3

// === cs_hs_phantom_drop_1::: AI
script command_script cs_hs_phantom_drop_1()
  if B_horseshoe_bypassed_side_right then
    B_phantom_active = TRUE;
		object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
		object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(9.0) );
		f_load_phantom( phantom_center_drop_1, right, sq_pdrop_0_1, sq_pdrop_0_2, sq_pdrop_0_1, sq_pdrop_0_4 );
		cs_vehicle_speed( G_horseshoe_phantom_approach_speed_initial );
		cs_fly_to( phantom_center_drop_4.p0 );
		cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
		cs_fly_to_and_face( phantom_center_drop_4.p1, phantom_center_drop_4.p1_face );
		cs_fly_to_and_dock( phantom_center_drop_4.p1, phantom_center_drop_4.p1_face ,G_horseshoe_phantom_approach_dist );
		cs_vehicle_speed( 1.0 );
		f_unload_phantom( phantom_center_drop_1, right );
		sleep_s( 0.25, 0.75 );
		notifylevel( "m80 hs center phantom drop 1 unload" );
		cs_fly_to( phantom_center_drop_4.p2 );
		cs_run_command_script( phantom_center_drop_1.gunner1, cs_hs_side_turret_cease_fire );
		cs_run_command_script( phantom_center_drop_1.gunner2, cs_hs_side_turret_cease_fire );
		object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );
		B_phantom_active = FALSE;
		cs_fly_to( phantom_center_drop_4.p3 );
		B_horseshoe_center_drop_1_complete = TRUE;
		sleep_s( 3.0 );
		ai_erase( phantom_center_drop_1 );
	else
		B_phantom_active = TRUE;
		object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
		object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(9.0) );
		f_load_phantom( phantom_center_drop_1, right, sq_pdrop_1_3, sq_pdrop_1_2, sq_pdrop_1_1, sq_pdrop_1_4 );
		cs_vehicle_speed( 0.9375 );
		cs_fly_to( phantom_center_drop_1.p0 );
		cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
		cs_fly_to_and_face( phantom_center_drop_1.p1, phantom_center_drop_1.p1_face );
		cs_fly_to_and_dock( phantom_center_drop_1.p1, phantom_center_drop_1.p1_face,G_horseshoe_phantom_approach_dist );
		cs_vehicle_speed( 1.0 );
		f_unload_phantom( phantom_center_drop_1, right );
		sleep_s( 0.25, 0.75 );
		notifylevel( "m80 hs center phantom drop 1 unload" );
		cs_fly_to( phantom_center_drop_1.p2 );
		cs_run_command_script( phantom_center_drop_1.gunner1, cs_hs_side_turret_cease_fire );
		cs_run_command_script( phantom_center_drop_1.gunner2, cs_hs_side_turret_cease_fire );
		object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );
		B_phantom_active = FALSE;
		cs_fly_to( phantom_center_drop_1.p3 );
		B_horseshoe_center_drop_1_complete = TRUE;
		sleep_s( 3.0 );
		ai_erase( phantom_center_drop_1 );
	end
		
end

// === cs_hs_phantom_drop_2::: AI
script command_script cs_hs_phantom_drop_2()

	B_phantom_active = TRUE;
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
	object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(9.0) );

	f_load_phantom( phantom_center_drop_2, right, sq_pdrop_2_1, sq_pdrop_2_2, sq_pdrop_2_3, sq_pdrop_2_4 );
	
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_initial );
	cs_fly_to( phantom_center_drop_2.p0 );
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
	cs_fly_to_and_face( phantom_center_drop_2.p1, phantom_center_drop_2.p1_face );
	cs_fly_to_and_dock( phantom_center_drop_2.p1, phantom_center_drop_2.p1_face ,G_horseshoe_phantom_approach_dist );
	cs_vehicle_speed( 1.0 );
	
	f_unload_phantom( phantom_center_drop_2, right );
	notifylevel( "m80 hs center phantom drop 2 unload" );
	
	cs_fly_to( phantom_center_drop_2.p2 );
	
	cs_run_command_script( phantom_center_drop_2.gunner1, cs_hs_side_turret_cease_fire );	
	cs_run_command_script( phantom_center_drop_2.gunner1, cs_hs_side_turret_cease_fire );	
	
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );

	B_phantom_active = FALSE;
	
	cs_fly_to( phantom_center_drop_2.p3 );

	B_horseshoe_center_drop_2_complete = TRUE;

	sleep_s( 3.0 );	
	ai_erase( phantom_center_drop_2 );
	
end

// === Third Center Phantom Drop

script command_script cs_hs_phantom_drop_3()

	B_phantom_active = TRUE;
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
	object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(9.0) );

	f_load_phantom( phantom_center_drop_3, right, sq_pdrop_3_1, sq_pdrop_3_2, sq_pdrop_3_3, sq_pdrop_3_4);
	
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_initial );
	cs_fly_to( phantom_center_drop_3.p0 );
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
	cs_fly_to_and_face( phantom_center_drop_3.p1, phantom_center_drop_3.p1_face );
	cs_fly_to_and_dock( phantom_center_drop_3.p1, phantom_center_drop_3.p1_face ,G_horseshoe_phantom_approach_dist );
	cs_vehicle_speed( 1.0 );
	
	f_unload_phantom( phantom_center_drop_3, right );
	notifylevel( "m80 hs center phantom drop 3 unload" );
	
	cs_fly_to( phantom_center_drop_3.p2 );
	
	cs_run_command_script( phantom_center_drop_3.gunner1, cs_hs_side_turret_cease_fire );	
	cs_run_command_script( phantom_center_drop_3.gunner1, cs_hs_side_turret_cease_fire );	
	
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );
	
	B_phantom_active = FALSE;
	
	cs_fly_to( phantom_center_drop_3.p3 );
	
	B_horseshoe_center_drop_3_complete = TRUE;

	sleep_s( 3.0 );	
	ai_erase( phantom_center_drop_3 );
	
end

// === Fourth Center Phantom Drop

script command_script cs_hs_phantom_drop_4()

	B_phantom_active = TRUE;
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
	object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(9.0) );

	f_load_phantom( phantom_center_drop_4, right, sq_pdrop_4_1, sq_pdrop_4_2, sq_pdrop_4_3, sq_pdrop_4_4 );
	
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_initial );
	cs_fly_to( phantom_center_drop_4.p0 );
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
	cs_fly_to_and_face( phantom_center_drop_4.p1, phantom_center_drop_4.p1_face );
	cs_fly_to_and_dock( phantom_center_drop_4.p1, phantom_center_drop_4.p1_face ,G_horseshoe_phantom_approach_dist );
	cs_vehicle_speed( 1.0 );
	
	f_unload_phantom( phantom_center_drop_4, right );
	notifylevel( "m80 hs center phantom drop 4 unload" );
	
	B_horseshoe_center_dropoffs_complete = TRUE;

	
	cs_fly_to( phantom_center_drop_4.p2 );
	
	cs_run_command_script( phantom_center_drop_4.gunner1, cs_hs_side_turret_cease_fire );	
	cs_run_command_script( phantom_center_drop_4.gunner1, cs_hs_side_turret_cease_fire );	
	
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );
	
	B_phantom_active = FALSE;
	
	cs_fly_to( phantom_center_drop_4.p3 );

	sleep_s( 3.0 );	
	
	ai_erase( phantom_center_drop_4 );
	
end

// === cs_hs_phantom_hits_shield::: AI
script command_script cs_hs_phantom_hits_shield()

	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, 0 );
	object_cannot_take_damage( ai_vehicle_get(ai_current_actor) );
	object_set_scale( ai_vehicle_get(ai_current_actor), 1.0, seconds_to_frames(8.0) );
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
	cs_fly_to( phantom_center_drop_1.p0 );
	cs_vehicle_speed( G_horseshoe_phantom_approach_speed_final );
	cs_fly_to_and_face( phantom_center_drop_1.p1, phantom_center_drop_1.p1_face );
	cs_fly_to( phantom_center_drop_1.p2 );
	cs_vehicle_speed( 1.0 );
	
	sleep_s( 10.0 );
	
	cs_fly_to( phantom_center_drop_2.p2 );
	
	cs_run_command_script( phantom_center_drop_1.gunner1, cs_hs_side_turret_cease_fire );
	cs_run_command_script( phantom_center_drop_1.gunner2, cs_hs_side_turret_cease_fire );
	
	object_set_scale( ai_vehicle_get(ai_current_actor), 0.01, seconds_to_frames(9.0) );
	cs_fly_to( phantom_center_drop_1.p3 );
	
	sleep_s( 3.0 );
	ai_erase( phantom_hits_shield );		
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: LEFT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_left_init::: Initialize
script dormant f_horseshoe_ai_left_init()
	
	// init sub modules
	wake( f_horseshoe_ai_left_door_init );
//	wake( f_horseshoe_ai_left_sniper_init );
	wake( f_horseshoe_ai_left_building_init );

end

// === f_horseshoe_ai_left_deinit::: Deinitialize
script dormant f_horseshoe_ai_left_deinit()

	// init sub modules
	wake( f_horseshoe_ai_left_door_deinit );
	wake( f_horseshoe_ai_left_sniper_deinit );
	wake( f_horseshoe_ai_left_building_deinit );

	// kill functions
	kill_script( f_horseshoe_ai_left_init );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: LEFT: COMMAND SCRIPTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_hs_side_turret_cease_fire::: AI
script command_script cs_hs_side_turret_cease_fire()
sleep_until( f_horseshoe_started(), 1 );

	sleep_forever();

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: LEFT: DOOR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_left_door_init::: Initialize
script dormant f_horseshoe_ai_left_door_init()

		sleep_until(door_horseshoe_center_maya->check_close(), 1) and f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_CENTER());
		
	// init sub modules
	wake( f_horseshoe_ai_left_door_trigger );
//	wake( f_horseshoe_ai_left_sniper_trigger );

		sleep_until(door_horseshoe_center_maya->check_open(), 1) and f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_CENTER());
		
		wake( f_horseshoe_ai_left_sniper_trigger );



end

// === f_horseshoe_ai_left_door_deinit::: Deinitialize
script dormant f_horseshoe_ai_left_door_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_left_door_init );
	
	kill_script( f_horseshoe_ai_left_door_trigger );
	kill_script( f_horseshoe_ai_left_door_spawn );
	kill_script( f_horseshoe_ai_left_door_enemy_spawn );
	kill_script( f_horseshoe_ai_left_door_dead_spawn );

end

// === f_horseshoe_ai_left_door_trigger::: Trigger
script dormant f_horseshoe_ai_left_door_trigger()
		
	// init sub modules
	sleep_until( not door_horseshoe_center_maya->position_close_check(), 1 );
	wake( f_horseshoe_ai_left_door_spawn );

end

// === f_horseshoe_ai_left_door_spawn::: Spawn
script dormant f_horseshoe_ai_left_door_spawn()

	// spawn
	wake( f_horseshoe_ai_left_door_enemy_spawn );
	wake( f_horseshoe_ai_left_door_dead_spawn );

end

// === f_horseshoe_ai_left_door_enemy_spawn::: Spawn
script dormant f_horseshoe_ai_left_door_enemy_spawn()

	// place enemy ai
	ai_place( sg_center_door );

end

// === f_horseshoe_ai_left_door_dead_spawn::: Spawn
script dormant f_horseshoe_ai_left_door_dead_spawn()

	// place dead humans
	ai_place( humans_hs_left_oni_dead );
	ai_kill( humans_hs_left_oni_dead );
	ai_place( humans_hs_left_sci_dead );
	ai_kill( humans_hs_left_sci_dead );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: LEFT: SNIPER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_left_sniper_init::: Initialize
script dormant f_horseshoe_ai_left_sniper_init()
	
	// init sub modules
	wake( f_horseshoe_ai_left_sniper_trigger );

end

// === f_horseshoe_ai_left_sniper_deinit::: Deinitialize
script dormant f_horseshoe_ai_left_sniper_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_left_sniper_init );
	
	kill_script( f_horseshoe_ai_left_sniper_trigger );
	kill_script( f_horseshoe_ai_left_sniper_spawn );
	kill_script( f_horseshoe_ai_left_sniper_enemy_spawn );
	kill_script( f_horseshoe_ai_left_sniper_human_spawn );

end

// === f_horseshoe_ai_left_sniper_trigger::: Trigger
script dormant f_horseshoe_ai_left_sniper_trigger()
//	sleep_until( volume_test_players(tv_hs_sniper_start), 1 );	

	// spawn
	wake( f_horseshoe_ai_left_sniper_spawn );

//	sleep_until( ai_living_count(sq_hs_left_3) > 0, 1 );
//	ai_vehicle_enter( sq_hs_left_3, horseshoe_sniper_turret_1 );

end

// === f_horseshoe_ai_left_sniper_spawn::: Spawn
script dormant f_horseshoe_ai_left_sniper_spawn()

	// spawn
	wake( f_horseshoe_ai_left_sniper_enemy_spawn );
	wake( f_horseshoe_ai_left_sniper_human_spawn );

	// start some garbage collection
	f_ai_garbage_erase( sg_hs_right, 15.0 );
	f_ai_garbage_erase( sg_hs_sniper, 15.0 );

end

// === f_horseshoe_ai_left_sniper_enemy_spawn::: Spawn
script dormant f_horseshoe_ai_left_sniper_enemy_spawn()

	// place
	ai_place( sg_hs_sniper );

end

// === f_horseshoe_ai_left_sniper_human_spawn::: Spawn
script dormant f_horseshoe_ai_left_sniper_human_spawn()

	ai_place( sq_hs_left_ally_1 );
	ai_place( sq_hs_left_ally_2 );
		units_set_maximum_vitality( ai_actors(sg_hs_humans_left), 50.00, 0.0 );
		units_set_current_vitality( ai_actors(sg_hs_humans_left), 50.00, 0.0 );
		object_cannot_take_damage( ai_actors(sg_hs_humans_left) );	
		object_cannot_take_damage( ai_actors(sg_hs_sniper) );	

	sleep_until( volume_test_players(tv_hs_entered_sniper_fight), 1 );
		wake ( f_horseshoe_sg_hs_building_underneath_spawn);
		sleep_s( 3.0 );
		object_can_take_damage( ai_actors(sg_hs_humans_left) );	
		object_can_take_damage( ai_actors(sg_hs_sniper) );	
		

end

script dormant f_horseshoe_sg_hs_building_underneath_spawn()

	ai_place(sg_hs_building_underneath);

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HORSESHOE: AI: LEFT: building
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_horseshoe_ai_left_building_init::: Initialize
script dormant f_horseshoe_ai_left_building_init()
	
	// init sub modules
	wake( f_horseshoe_ai_left_building_trigger );

end

// === f_horseshoe_ai_left_building_deinit::: Deinitialize
script dormant f_horseshoe_ai_left_building_deinit()

	// kill functions
	kill_script( f_horseshoe_ai_left_building_init );
	
	kill_script( f_horseshoe_ai_left_building_trigger );
	kill_script( f_horseshoe_ai_left_building_spawn );
	kill_script( f_horseshoe_ai_left_building_enemy_spawn );
	kill_script( f_horseshoe_ai_left_building_human_spawn );

end

// === f_horseshoe_ai_left_building_trigger::: Trigger
script dormant f_horseshoe_ai_left_building_trigger()
	sleep_until( volume_test_players(tv_hs_left_building_start), 1 );

	// spawn
	wake( f_horseshoe_ai_left_building_spawn );
	
	// wait for the end
	sleep_until( f_ai_is_defeated(sg_hs_building_roof), 1 );
	sleep_s( 2.0 );
	thread( f_mus_m80_e01_finish() );

end

// === f_horseshoe_ai_left_building_spawn::: Spawn
script dormant f_horseshoe_ai_left_building_spawn()

	// spawn
	wake( f_horseshoe_ai_left_building_enemy_spawn );
	wake (f_horseshoe_ai_left_building_human_spawn );

end

// === f_horseshoe_ai_left_building_enemy_spawn::: Spawn
script dormant f_horseshoe_ai_left_building_enemy_spawn()

	// place
	ai_place( sg_hs_building_inside );
	ai_place( sg_hs_building_roof );

end

// === f_horseshoe_ai_left_building_human_spawn::: Spawn
script dormant f_horseshoe_ai_left_building_human_spawn()

	// place
	ai_place( sq_hs_building_ally_1 );
	
end

script dormant f_horseshoe_ai_center_cleanup()
	sleep_until( (door_horseshoe_center_maya->position_close_check()) and (volume_test_players (tv_hs_inside_left)),1 );

	ai_kill( sg_hs_center);
	ai_kill( sg_center_count);
end
