//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_<area> (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS: TWO: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_two_ai_init::: Initialize
script dormant f_hallways_two_ai_init()
	//dprint( "::: f_hallways_two_ai_init :::" );
	
	// init sub modules
	wake( f_hallways_two_ai_humans_init );
	wake( f_hallways_two_ai_enemies_init );
	wake( f_hallways_two_ai_dead_init );

	// setup trigger
	wake( f_hallways_two_ai_trigger );

end

// === f_hallways_two_ai_deinit::: Deinitialize
script dormant f_hallways_two_ai_deinit()
	//dprint( "::: f_hallways_two_ai_deinit :::" );

	// deinit sub modules
	wake( f_hallways_two_ai_humans_deinit );
	wake( f_hallways_two_ai_enemies_deinit );
	wake( f_hallways_two_ai_dead_deinit );

	// kill functions
	kill_script( f_hallways_two_ai_init );
	kill_script( f_hallways_two_ai_trigger );
	
	// erase ai
	f_ai_garbage_erase( sg_hallways_one );

end


// === f_hallways_two_ai_trigger::: Deinitialize
script dormant f_hallways_two_ai_trigger()
	//dprint( "::: f_hallways_two_ai_trigger :::" );

	// start combat music
	sleep_until( f_ai_sees_enemy(sg_to_airlock_two_enemies), 1 );
	thread( f_mus_m80_e05_begin() );
	
	// stop combat music
	sleep_until( f_ai_is_defeated(sg_to_airlock_two_initial) and f_ai_is_defeated(sg_to_airlock_two_backup) and f_ai_is_defeated(sg_to_airlock_two_final), 1 );
	thread( f_mus_m80_e05_finish() );

end

	

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: AI: HUMANS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_two_ai_humans_init::: Initialize
script dormant f_hallways_two_ai_humans_init()
	//dprint( "::: f_hallways_two_ai_humans_init :::" );
	
	// setup trigger
	wake( f_hallways_two_ai_humans_trigger );

end

// === f_hallways_two_ai_humans_deinit::: Deinitialize
script dormant f_hallways_two_ai_humans_deinit()
	//dprint( "::: f_hallways_two_ai_humans_deinit :::" );

	// kill functions
	kill_script( f_hallways_two_ai_humans_init );
	kill_script( f_hallways_two_ai_humans_trigger );
	kill_script( f_hallways_two_ai_humans_spawn );

end

// === f_hallways_two_ai_humans_trigger::: Trigger
script dormant f_hallways_two_ai_humans_trigger()
	//dprint( "::: f_hallways_two_ai_humans_trigger :::" );

	// trigger action
	wake( f_hallways_two_ai_humans_spawn );

	// disable human playfight
	sleep_until( volume_test_players(tv_hallway_two_ai_can_take_damage), 1 );
	ai_cannot_die( sg_to_airlock_two_humans, FALSE );
	ai_renew( sg_to_airlock_two_humans );
	ai_kill_silent( humans_to_airlock_two_scene2.male1 );

end

// === f_hallways_two_ai_humans_spawn::: Spawn
script dormant f_hallways_two_ai_humans_spawn()
	//dprint( "::: f_hallways_two_ai_humans_spawn :::" );

	// set allegiance
	//ai_allegiance( player, human );

	// setup parameters
	ai_place( sg_to_airlock_two_humans );
	cs_push_stance( sg_to_airlock_two_humans, panic );
	
	units_set_maximum_vitality( ai_actors(humans_to_airlock_two_scene2), object_get_maximum_vitality(humans_to_airlock_two_scene2.male1, FALSE) * 0.75, 0.0 );
	units_set_current_vitality( ai_actors(humans_to_airlock_two_scene2), object_get_maximum_vitality(humans_to_airlock_two_scene2.male1, FALSE) * 0.75, 0.0 );
	
	units_set_maximum_vitality( ai_actors(humans_to_airlock_two_scene3), object_get_maximum_vitality(humans_to_airlock_two_scene3.male2, FALSE) * 0.75, 0.0 );
	units_set_current_vitality( ai_actors(humans_to_airlock_two_scene3), object_get_maximum_vitality(humans_to_airlock_two_scene3.male2, FALSE) * 0.75, 0.0 );
	
	units_set_maximum_vitality( ai_actors(humans_to_airlock_two_scene1), object_get_maximum_vitality(humans_to_airlock_two_scene1.marine, FALSE) * 1.0, 0.0 );
	units_set_current_vitality( ai_actors(humans_to_airlock_two_scene1), object_get_maximum_vitality(humans_to_airlock_two_scene1.marine, FALSE) * 0.75, 0.0 );
	
	ai_cannot_die( sg_to_airlock_two_humans, TRUE );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: AI: ENEMIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_two_ai_enemies_init::: Initialize
script dormant f_hallways_two_ai_enemies_init()
	//dprint( "::: f_hallways_two_ai_enemies_init :::" );
	
	// setup trigger
	wake( f_hallways_two_ai_enemies_trigger );

end

// === f_hallways_two_ai_enemies_deinit::: Deinitialize
script dormant f_hallways_two_ai_enemies_deinit()
	//dprint( "::: f_hallways_two_ai_enemies_deinit :::" );

	// kill functions
	kill_script( f_hallways_two_ai_enemies_init );
	kill_script( f_hallways_two_ai_enemies_trigger );
	kill_script( f_hallways_two_ai_enemies_spawn_first );
	kill_script( f_hallways_two_ai_enemies_spawn_second );
	kill_script( f_hallways_two_ai_enemies_spawn_third );

end

// === f_hallways_two_ai_enemies_trigger::: Trigger
script dormant f_hallways_two_ai_enemies_trigger()
	//dprint( "::: f_hallways_two_ai_enemies_trigger :::" );

	// Spawn First
	wake( f_hallways_two_ai_enemies_spawn_first );
	
	// disable human playfight
	sleep_until( volume_test_players(tv_hallway_two_ai_can_take_damage), 1 );
	ai_renew( sg_to_airlock_two_initial );
	ai_cannot_die( sg_to_airlock_two_initial, FALSE );

	// Spawn Second
	sleep_until( f_ai_is_defeated(sq_hallway_2_execute_elite) or f_ai_is_partially_defeated(sg_to_airlock_two_initial, 2) or volume_test_players(tv_reached_hallway_2_halfway), 1 );
	wake( f_hallways_two_ai_enemies_spawn_second );

	// Spawn Third
	sleep_until( zoneset_current_active() == S_ZONESET_AIRLOCK_TWO, 1 );
	wake( f_hallways_two_ai_enemies_spawn_third );

end

// === f_hallways_two_ai_enemies_spawn_first::: Spawn
script dormant f_hallways_two_ai_enemies_spawn_first()
	//dprint( "::: f_hallways_two_ai_enemies_spawn_first :::" );

	// place
	ai_place( sg_to_airlock_two_initial );
	
	// settings
	ai_cannot_die( sg_to_airlock_two_initial, TRUE );
	ai_disregard( ai_get_object(sq_hallway_2_execute_elite), TRUE );

end

// === f_hallways_two_ai_enemies_spawn_second::: Spawn
script dormant f_hallways_two_ai_enemies_spawn_second()
	//dprint( "::: f_hallways_two_ai_enemies_spawn_second :::" );

	// place
	sleep_s( 1.0 );
	ai_place( sg_to_airlock_two_backup );

end

// === f_hallways_two_ai_enemies_spawn_third::: Spawn
script dormant f_hallways_two_ai_enemies_spawn_third()
	//dprint( "::: f_hallways_two_ai_enemies_spawn_third :::" );

	// place
	ai_place( sg_to_airlock_two_final );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: TWO: AI: DEAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_two_ai_dead_init::: Initialize
script dormant f_hallways_two_ai_dead_init()
	//dprint( "::: f_hallways_two_ai_dead_init :::" );
	
	// setup trigger
	wake( f_hallways_two_ai_dead_trigger );

end

// === f_hallways_two_ai_dead_deinit::: Deinitialize
script dormant f_hallways_two_ai_dead_deinit()
	//dprint( "::: f_hallways_two_ai_dead_deinit :::" );

	// kill functions
	kill_script( f_hallways_two_ai_dead_init );
	kill_script( f_hallways_two_ai_dead_trigger );
	//kill_script( f_hallways_two_ai_dead_action );
	
end

// === f_hallways_two_ai_dead_trigger::: Trigger
script dormant f_hallways_two_ai_dead_trigger()
	sleep_until(zoneset_current_active() >= S_ZONESET_TO_AIRLOCK_TWO,1);
	//dprint( "::: f_hallways_two_ai_dead_trigger :::" );

	// Spawn First
//	wake( f_hallways_two_ai_dead_action );

	// place
	ai_place( sq_hallways_two_dead );
	ai_kill( sq_hallways_two_dead );

	object_create( bi_hallway_two_marine_dead_01 );
	pup_play_show( pup_hallways_two_dead_01 );
	
	object_create( bi_hallway_two_marine_dead_02 );
	pup_play_show( pup_hallways_two_dead_02 );
	
	object_create( bi_hallway_two_marine_dead_03 );
	pup_play_show( pup_hallways_two_dead_03 );

end
