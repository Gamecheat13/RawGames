//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_airlocks_one (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AIRLOCKS: ONE: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_airlock_index = 													1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_init::: Initialize
script dormant f_airlocks_one_ai_init()
	//dprint( "::: f_airlocks_one_ai_init :::" );
	
	// init sub modules
	wake( f_airlocks_one_ai_objcon_init );
	wake( f_airlocks_one_ai_music_init );
	wake( f_airlocks_one_ai_initial_init );
	wake( f_airlocks_one_ai_bodies_init );
	//wake( f_airlocks_one_ai_bays_init );

end

// === f_airlocks_one_ai_deinit::: Deinitialize
script dormant f_airlocks_one_ai_deinit()
	//dprint( "::: f_airlocks_one_ai_deinit :::" );
	
	// init sub modules
	wake( f_airlocks_one_ai_objcon_deinit );
	wake( f_airlocks_one_ai_music_deinit );
	wake( f_airlocks_one_ai_initial_deinit );
	wake( f_airlocks_one_ai_bodies_deinit );
	wake( f_airlocks_one_ai_bays_deinit );

	// kill functions
	kill_script( f_airlocks_one_ai_init );
	
	// erase ai
	f_ai_garbage_erase( sg_airlock_one );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_objcon_init::: objconize
script dormant f_airlocks_one_ai_objcon_init()
	//dprint( "::: f_airlocks_one_ai_objcon_init :::" );
	
	// setup trigger
	wake( f_airlocks_one_ai_objcon_trigger );

end

// === f_airlocks_one_ai_objcon_deinit::: Deobjconize
script dormant f_airlocks_one_ai_objcon_deinit()
	//dprint( "::: f_airlocks_one_ai_objcon_deinit :::" );

	// kill functions
	kill_script( f_airlocks_one_ai_objcon_init );

end

// === f_airlocks_one_ai_objcon_trigger::: Trigger
script dormant f_airlocks_one_ai_objcon_trigger()

	// start
	sleep_until( f_airlocks_one_started(), 1 );	
	//dprint( "::: f_airlocks_one_ai_objcon_trigger: STARTED :::" );
	f_hallways_ai_objcon_set( 090 );

	// entered
	sleep_until( f_airlocks_one_entered(), 1 );	
	//dprint( "::: f_airlocks_one_ai_objcon_trigger: ENTERED :::" );
	f_hallways_ai_objcon_set( 100 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: AI: MUSIC
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_music_init::: musicize
script dormant f_airlocks_one_ai_music_init()
	//dprint( "::: f_airlocks_one_ai_music_init :::" );
	
	// setup trigger
	wake( f_airlocks_one_ai_music_trigger );

end

// === f_airlocks_one_ai_music_deinit::: Demusicize
script dormant f_airlocks_one_ai_music_deinit()
	//dprint( "::: f_airlocks_one_ai_music_deinit :::" );

	// kill functions
	kill_script( f_airlocks_one_ai_music_init );

end

// === f_airlocks_one_ai_music_trigger::: Trigger
script dormant f_airlocks_one_ai_music_trigger()

	sleep_until( f_ai_sees_enemy(sg_airlock_one), 1 );
	//dprint( "::: f_airlocks_one_ai_music_trigger: START :::" );
	thread( f_mus_m80_e04_begin() );

	sleep_until( f_airlocks_one_finished() and (ai_living_count(sg_airlock_one) <= 0), 1 );
	//dprint( "::: f_airlocks_one_ai_music_trigger: FINISH :::" );
	thread( f_mus_m80_e04_finish() );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: AI: INITIAL
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_initial_init::: Initialize
script dormant f_airlocks_one_ai_initial_init()
	//dprint( "::: f_airlocks_one_ai_initial_init :::" );
	
	// setup trigger
	wake( f_airlocks_one_ai_initial_trigger );

end

// === f_airlocks_one_ai_initial_deinit::: Deinitialize
script dormant f_airlocks_one_ai_initial_deinit()
	//dprint( "::: f_airlocks_one_ai_initial_deinit :::" );

	// kill functions
	kill_script( f_airlocks_one_ai_initial_init );

end

// === f_airlocks_one_ai_initial_trigger::: Trigger
script dormant f_airlocks_one_ai_initial_trigger()
	sleep_until( f_airlocks_one_started(), 1 );
	//dprint( "::: f_airlocks_one_ai_initial_trigger :::" );
	
	// init sub modules
	wake( f_airlocks_one_ai_initial_spawn );

end

// === f_airlocks_one_ai_initial_spawn::: Spawn
script dormant f_airlocks_one_ai_initial_spawn()
	//dprint( "::: f_airlocks_one_ai_initial_spawn :::" );

	// place
	ai_place( sg_airlock_one_initial );	
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: AI: BODIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_bodies_init::: bodiesize
script dormant f_airlocks_one_ai_bodies_init()
	//dprint( "::: f_airlocks_one_ai_bodies_init :::" );
	
	// setup trigger
	wake( f_airlocks_one_ai_bodies_trigger );

end

// === f_airlocks_one_ai_bodies_deinit::: Debodiesize
script dormant f_airlocks_one_ai_bodies_deinit()
	//dprint( "::: f_airlocks_one_ai_bodies_deinit :::" );

	// kill functions
	kill_script( f_airlocks_one_ai_bodies_init );

end

// === f_airlocks_one_ai_bodies_trigger::: Trigger
script dormant f_airlocks_one_ai_bodies_trigger()
	sleep_until( f_airlocks_one_started(), 1 );
	//dprint( "::: f_airlocks_one_ai_bodies_trigger :::" );
	
	// init sub modules
	wake( f_airlocks_one_ai_bodies_spawn );

end

// === f_airlocks_one_ai_bodies_spawn::: Spawn
script dormant f_airlocks_one_ai_bodies_spawn()
	//dprint( "::: f_airlocks_one_ai_bodies_spawn :::" );

	// place
	ai_place( humans_airlock_one_dead );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: AI: BAYS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_bays_init::: Init
//script dormant f_airlocks_one_ai_bays_init()
	//dprint( "::: f_airlocks_one_ai_bays_init :::" );
	
	// init sub modules
	//wake( f_airlocks_one_ai_bay_02_init );
	//wake( f_airlocks_one_ai_bay_03_init );
	
//end

// === f_airlocks_one_ai_bays_deinit::: Deinit
script dormant f_airlocks_one_ai_bays_deinit()
	//dprint( "::: f_airlocks_one_ai_bays_deinit :::" );

	// deinit sub modules
	wake( f_airlocks_one_ai_bay_02_deinit );
	wake( f_airlocks_one_ai_bay_03_deinit );
	
	// kill functions
	//kill_script( f_airlocks_one_ai_bays_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: BAY: 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_bay_02_init::: Init
//script dormant f_airlocks_one_ai_bay_02_init()
	//dprint( "::: f_airlocks_one_ai_bay_02_init :::" );
	
//end

// === f_airlocks_one_ai_bay_02_deinit::: Deinit
script dormant f_airlocks_one_ai_bay_02_deinit()
	//dprint( "::: f_airlocks_one_ai_bay_02_deinit :::" );
	
	// kill functions
	//kill_script( f_airlocks_one_ai_bay_02_init );
	kill_script( f_airlocks_one_ai_bay_02_trigger );
	kill_script( f_airlocks_one_ai_bay_02_spawn );
	
end

// === f_airlocks_one_ai_bay_02_trigger::: Trigger
script dormant f_airlocks_one_ai_bay_02_trigger()
	
	// action
	sleep_until( f_airlocks_one_started(), 1 );	
	//dprint( "::: f_airlocks_one_ai_bay_02_trigger :::" );
	wake( f_airlocks_one_ai_bay_02_spawn );

end

// === f_airlocks_one_ai_bay_02_spawn::: Action
script dormant f_airlocks_one_ai_bay_02_spawn()
local long l_pup_id = 0;

	// play show
	//dprint( "::: f_airlocks_one_ai_bay_02_spawn: START :::" );
	l_pup_id = pup_play_show( 'pup_airlock_one_bay_02' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_one_ai_bay_02_spawn: END :::" );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: ONE: BAY: 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_one_ai_bay_03_init::: Init
//script dormant f_airlocks_one_ai_bay_03_init()
	//dprint( "::: f_airlocks_one_ai_bay_03_init :::" );
	
//end

// === f_airlocks_one_ai_bay_03_deinit::: Deinit
script dormant f_airlocks_one_ai_bay_03_deinit()
	//dprint( "::: f_airlocks_one_ai_bay_03_deinit :::" );
	
	// kill functions
	//kill_script( f_airlocks_one_ai_bay_03_init );
	kill_script( f_airlocks_one_ai_bay_03_trigger );
	//kill_script( f_airlocks_one_ai_bay_03_spawn );
	
end

// === f_airlocks_one_ai_bay_03_trigger::: Trigger
script dormant f_airlocks_one_ai_bay_03_trigger()
local long l_pup_id = 0;
	
	// action
	sleep_until( (f_airlocks_one_state_get(2) >= DEF_S_AIRLOCK_STATE_OUTER_CLOSE) and f_airlocks_one_entered() and (ai_living_count(sg_airlock_one) <= 8), 1 );	
	//dprint( "::: f_airlocks_one_ai_bay_03_trigger :::" );
	l_pup_id = pup_play_show( 'pup_airlock_one_bay_03' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
end

/*
// === f_airlocks_one_ai_bay_03_spawn::: Action
script dormant f_airlocks_one_ai_bay_03_spawn()
local long l_pup_id = 0;
	
	// dialog
	//dprint( "::: f_airlocks_one_ai_bay_03_spawn: START :::" );
	// play show

	//dprint( "::: f_airlocks_one_ai_bay_03_spawn: END :::" );
	
end
*/