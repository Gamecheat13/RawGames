//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_<area> (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS: ONE: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_ai_init::: Initialize
script dormant f_hallways_one_ai_init()
	//dprint( "::: f_hallways_one_ai_init :::" );
	
	// init sub modules
	wake( f_hallways_one_ai_humans_init );
	wake( f_hallways_one_ai_enemies_init );
	wake( f_hallways_one_ai_dead_init );

	// setup trigger
	wake( f_hallways_one_ai_trigger );

end

// === f_hallways_one_ai_deinit::: Deinitialize
script dormant f_hallways_one_ai_deinit()
	//dprint( "::: f_hallways_one_ai_deinit :::" );

	// deinit sub modules
	wake( f_hallways_one_ai_humans_deinit );
	wake( f_hallways_one_ai_enemies_deinit );
	wake( f_hallways_one_ai_dead_deinit );

	// kill functions
	kill_script( f_hallways_one_ai_init );
	kill_script( f_hallways_one_ai_trigger );
	
	// erase ai
	f_ai_garbage_erase( sg_hallways_one );

end


// === f_hallways_one_ai_trigger::: Deinitialize
script dormant f_hallways_one_ai_trigger()
	//dprint( "::: f_hallways_one_ai_trigger :::" );

	// start combat music
	sleep_until( f_ai_sees_enemy(sg_hallways_one_enemies), 1 );
	thread( f_mus_m80_e03_begin() );
	
	// stop combat music
	sleep_until( f_ai_is_defeated(sg_hallways_one_enemies) and (ai_spawn_count(sg_hallways_one_enemies_third) > 0), 1 );
	thread( f_mus_m80_e03_finish() );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: AI: HUB
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_hallways_one_hub_marine_01()
	//dprint( "$$$ cs_hallways_one_hub_marine_01 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_hallway_one_hub_marine.p0, ps_hallway_one_hub_marine.p1, ps_hallway_one_hub_marine.p2, ps_hallway_one_hub_marine.p3 );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: AI: HUMANS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_ai_humans_init::: Initialize
script dormant f_hallways_one_ai_humans_init()
	//dprint( "::: f_hallways_one_ai_humans_init :::" );
	
	// setup trigger
	wake( f_hallways_one_ai_humans_trigger );

end

// === f_hallways_one_ai_humans_deinit::: Deinitialize
script dormant f_hallways_one_ai_humans_deinit()
	//dprint( "::: f_hallways_one_ai_humans_deinit :::" );

	// kill functions
	kill_script( f_hallways_one_ai_humans_init );
	kill_script( f_hallways_one_ai_humans_trigger );
	//kill_script( f_hallways_one_ai_humans_spawn );

	// erase
	ai_erase( sg_hallways_one_humans ); 

end

// === f_hallways_one_ai_humans_trigger::: Trigger
script dormant f_hallways_one_ai_humans_trigger()
	sleep_until( (zoneset_current_active() == S_ZONESET_ATRIUM_HUB) or (zoneset_current() == S_ZONESET_TO_AIRLOCK_ONE), 1 ); 
	//dprint( "::: f_hallways_one_ai_humans_trigger :::" );

	// trigger action
	//wake( f_hallways_one_ai_humans_spawn );
	ai_place( sg_hallways_one_humans ); 

end
/*
// === f_hallways_one_ai_humans_spawn::: Spawn
script dormant f_hallways_one_ai_humans_spawn()
	//dprint( "::: f_hallways_one_ai_humans_spawn :::" );

	// set allegiance
	//ai_allegiance( player, human );

	// place
	ai_place( sg_hallways_one_humans ); 

end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: AI: ENEMIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_ai_enemies_init::: Initialize
script dormant f_hallways_one_ai_enemies_init()
	//dprint( "::: f_hallways_one_ai_enemies_init :::" );
	
	// setup trigger
	wake( f_hallways_one_ai_enemies_trigger );

end

// === f_hallways_one_ai_enemies_deinit::: Deinitialize
script dormant f_hallways_one_ai_enemies_deinit()
	//dprint( "::: f_hallways_one_ai_enemies_deinit :::" );

	// kill functions
	kill_script( f_hallways_one_ai_enemies_init );
	kill_script( f_hallways_one_ai_enemies_trigger );
	kill_script( f_hallways_one_ai_enemies_spawn_first );
	kill_script( f_hallways_one_ai_enemies_spawn_second );
	kill_script( f_hallways_one_ai_enemies_spawn_third );

end

// === f_hallways_one_ai_enemies_trigger::: Trigger
script dormant f_hallways_one_ai_enemies_trigger()
	//dprint( "::: f_hallways_one_ai_enemies_trigger :::" );

	// trigger spawn first
	sleep_until( zoneset_current_active() == S_ZONESET_TO_AIRLOCK_ONE, 1 );
	wake( f_hallways_one_ai_enemies_spawn_first );

	// trigger spawn second
	sleep_until( object_valid(door_to_airlock_one_exit) and object_active_for_script(door_to_airlock_one_exit) and (door_to_airlock_one_exit->position_not_close_check()), 1 );	
	wake( f_hallways_one_ai_enemies_spawn_second );

	// trigger spawn third
	sleep_until( volume_test_players(tv_hallway_one_halfway), 1 );
	wake( f_hallways_one_ai_enemies_spawn_third );

end

// === f_hallways_one_ai_enemies_spawn_first::: Spawn
script dormant f_hallways_one_ai_enemies_spawn_first()
	//dprint( "::: f_hallways_one_ai_enemies_spawn_first :::" );

	// place
	ai_place( sg_hallways_one_enemies_first );
	ai_place( sq_to_airlock_one_dead );

end

// === f_hallways_one_ai_enemies_spawn_second::: Spawn
script dormant f_hallways_one_ai_enemies_spawn_second()
	//dprint( "::: f_hallways_one_ai_enemies_spawn_second :::" );

	// place
	ai_place( sg_hallways_one_enemies_second );

end

// === f_hallways_one_ai_enemies_spawn_third::: Spawn
script dormant f_hallways_one_ai_enemies_spawn_third()
	//dprint( "::: f_hallways_one_ai_enemies_spawn_third :::" );

	// place
	ai_place( sg_hallways_one_enemies_third );

end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_hallways_one_turret()
	//dprint( "$$$ cs_hallways_one_turret $$$" );
	
	sleep_until( object_valid(to_airlock_one_turret) or f_ai_sees_enemy(ai_current_actor), 1 );
	
	//dprint( "$$$ cs_hallways_one_turret: READY $$$" );
	if ( object_valid(to_airlock_one_turret) and (object_get_health(to_airlock_one_turret) > 0.0) and (not vehicle_test_seat(to_airlock_one_turret,"")) ) then
		//dprint( "$$$ cs_hallways_one_turret: LOAD $$$" );
		ai_vehicle_enter( ai_current_actor, to_airlock_one_turret );
	end
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: AI: DEAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_ai_dead_init::: Initialize
script dormant f_hallways_one_ai_dead_init()
	//dprint( "::: f_hallways_one_ai_dead_init :::" );
	
	// setup trigger
	wake( f_hallways_one_ai_dead_trigger );

end

// === f_hallways_one_ai_dead_deinit::: Deinitialize
script dormant f_hallways_one_ai_dead_deinit()
	//dprint( "::: f_hallways_one_ai_dead_deinit :::" );

	// kill functions
	kill_script( f_hallways_one_ai_dead_init );
	kill_script( f_hallways_one_ai_dead_trigger );
	//kill_script( f_hallways_one_ai_dead_action );
	
end

// === f_hallways_one_ai_dead_trigger::: Trigger
script dormant f_hallways_one_ai_dead_trigger()
	sleep_until(zoneset_current_active() >= S_ZONESET_TO_AIRLOCK_ONE,1);
	dprint( "::: f_hallways_one_ai_dead_trigger :::" );
	sleep( 1 );

	// Spawn First
	//wake( f_hallways_one_ai_dead_action );
	pup_play_show( pup_hallways_one_dead_01 );
	pup_play_show( pup_hallways_one_dead_02 );

end
/*
// === f_hallways_one_ai_dead_action::: Spawn
script dormant f_hallways_one_ai_dead_action()
	//dprint( "::: f_hallways_one_ai_dead_action :::" );

	pup_play_show( pup_hallways_one_dead_01 );
	pup_play_show( pup_hallways_one_dead_02 );

end
*/