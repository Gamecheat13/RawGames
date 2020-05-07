//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_airlocks_two (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AIRLOCKS: TWO: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_airlock_index = 													1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_init::: Initialize
script dormant f_airlocks_two_ai_init()
	//dprint( "::: f_airlocks_two_ai_init :::" );
	
	// init sub modules
	wake( f_airlocks_two_ai_objcon_init );
	wake( f_airlocks_two_ai_music_init );
	wake( f_airlocks_two_ai_initial_init );
	wake( f_airlocks_two_ai_bodies_init );
	//wake( f_airlocks_two_ai_bays_init );

end

// === f_airlocks_two_ai_deinit::: Deinitialize
script dormant f_airlocks_two_ai_deinit()
	//dprint( "::: f_airlocks_two_ai_deinit :::" );
	
	// init sub modules
	wake( f_airlocks_two_ai_objcon_deinit );
	wake( f_airlocks_two_ai_music_deinit );
	wake( f_airlocks_two_ai_initial_deinit );
	wake( f_airlocks_two_ai_bodies_deinit );
	wake( f_airlocks_two_ai_bays_deinit );

	// kill functions
	kill_script( f_airlocks_two_ai_init );
	
	// erase ai
	ai_erase( sg_airlock_two );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_objcon_init::: objconize
script dormant f_airlocks_two_ai_objcon_init()
	//dprint( "::: f_airlocks_two_ai_objcon_init :::" );
	
	// setup trigger
	wake( f_airlocks_two_ai_objcon_trigger );

end

// === f_airlocks_two_ai_objcon_deinit::: Deobjconize
script dormant f_airlocks_two_ai_objcon_deinit()
	//dprint( "::: f_airlocks_two_ai_objcon_deinit :::" );

	// kill functions
	kill_script( f_airlocks_two_ai_objcon_init );

end

// === f_airlocks_two_ai_objcon_trigger::: Trigger
script dormant f_airlocks_two_ai_objcon_trigger()

	// start
	sleep_until( f_airlocks_two_started(), 1 );	
	//dprint( "::: f_airlocks_two_ai_objcon_trigger: STARTED :::" );
	S_airlock_two_spawn_last = random_range( 1, 3 );
	f_hallways_ai_objcon_set( 190 );

	// entered
	sleep_until( f_airlocks_two_entered(), 1 );	
	//dprint( "::: f_airlocks_two_ai_objcon_trigger: ENTERED :::" );
	f_hallways_ai_objcon_set( 200 );

end

script static boolean f_airlocks_two_ai_objectives_upper()
	volume_test_players( tv_airlock_two_upper ) and (volume_test_players(tv_airlock_two_lower) == FALSE);
end
script static boolean f_airlocks_two_ai_objectives_catwalks()
	( volume_test_players(tv_airlock_two_catwalk) or volume_test_players(tv_airlock_two_catwalk_pipe_a) or volume_test_players(tv_airlock_two_catwalk_pipe_b) ) and ( volume_test_players(tv_airlock_two_lower) == FALSE );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: AI: MUSIC
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_music_init::: musicize
script dormant f_airlocks_two_ai_music_init()
	//dprint( "::: f_airlocks_two_ai_music_init :::" );
	
	// setup trigger
	wake( f_airlocks_two_ai_music_trigger );

end

// === f_airlocks_two_ai_music_deinit::: Demusicize
script dormant f_airlocks_two_ai_music_deinit()
	//dprint( "::: f_airlocks_two_ai_music_deinit :::" );

	// kill functions
	kill_script( f_airlocks_two_ai_music_init );

end

// === f_airlocks_two_ai_music_trigger::: Trigger
script dormant f_airlocks_two_ai_music_trigger()

	sleep_until( f_ai_sees_enemy(sg_airlock_two_units), 1 );
	//dprint( "::: f_airlocks_two_ai_music_trigger: START :::" );
	thread( f_mus_m80_e06_begin() );

	sleep_until( f_airlocks_two_finished() and (ai_living_count(sg_airlock_two_units) <= 0), 1 );
	//dprint( "::: f_airlocks_two_ai_music_trigger: FINISH :::" );
	thread( f_mus_m80_e06_finish() );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: AI: INITIAL
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_initial_init::: Initialize
script dormant f_airlocks_two_ai_initial_init()
	//dprint( "::: f_airlocks_two_ai_initial_init :::" );
	
	// setup trigger
	wake( f_airlocks_two_ai_initial_trigger );

end

// === f_airlocks_two_ai_initial_deinit::: Deinitialize
script dormant f_airlocks_two_ai_initial_deinit()
	//dprint( "::: f_airlocks_two_ai_initial_deinit :::" );

	// kill functions
	kill_script( f_airlocks_two_ai_initial_init );

end

// === f_airlocks_two_ai_initial_trigger::: Trigger
script dormant f_airlocks_two_ai_initial_trigger()
	sleep_until( f_airlocks_two_started(), 1 );
	//dprint( "::: f_airlocks_two_ai_initial_trigger :::" );
	
	// init sub modules
	wake( f_airlocks_two_ai_initial_spawn );

end

// === f_airlocks_two_ai_initial_spawn::: Spawn
script dormant f_airlocks_two_ai_initial_spawn()
	//dprint( "::: f_airlocks_two_ai_initial_spawn :::" );

	// place
	ai_place( sg_airlock_two_initial );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: AI: BODIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_bodies_init::: bodiesize
script dormant f_airlocks_two_ai_bodies_init()
	//dprint( "::: f_airlocks_two_ai_bodies_init :::" );
	
	// setup trigger
	wake( f_airlocks_two_ai_bodies_trigger );

end

// === f_airlocks_two_ai_bodies_deinit::: Debodiesize
script dormant f_airlocks_two_ai_bodies_deinit()
	//dprint( "::: f_airlocks_two_ai_bodies_deinit :::" );

	// kill functions
	kill_script( f_airlocks_two_ai_bodies_init );

end

// === f_airlocks_two_ai_bodies_trigger::: Trigger
script dormant f_airlocks_two_ai_bodies_trigger()
	sleep_until( f_airlocks_two_started(), 1 );
	//dprint( "::: f_airlocks_two_ai_bodies_trigger :::" );
	
	// init sub modules
	wake( f_airlocks_two_ai_bodies_spawn );

end

// === f_airlocks_two_ai_bodies_spawn::: Spawn
script dormant f_airlocks_two_ai_bodies_spawn()
	//dprint( "::: f_airlocks_two_ai_bodies_spawn :::" );

	// place
	ai_place( humans_airlock_two_dead );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: AI: BAYS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_airlock_two_spawn_last	=									0;
static long L_airlock_two_spawn_timer	= 								0;
static real R_airlock_two_spawn_time_min = 							2.0;
static real R_airlock_two_spawn_time_max = 							3.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_bays_init::: Init
//script dormant f_airlocks_two_ai_bays_init()
	//dprint( "::: f_airlocks_two_ai_bays_init :::" );
	
	// init sub modules
	//wake( f_airlocks_two_ai_bay_01_init );
	//wake( f_airlocks_two_ai_bay_02_init );
	//wake( f_airlocks_two_ai_bay_03_init );
	
//end

// === f_airlocks_two_ai_bays_deinit::: Deinit
script dormant f_airlocks_two_ai_bays_deinit()
	dprint( "::: f_airlocks_two_ai_bays_deinit :::" );

	// deinit sub modules
	//wake( f_airlocks_two_ai_bay_01_deinit );
	//wake( f_airlocks_two_ai_bay_02_deinit );
	//wake( f_airlocks_two_ai_bay_03_deinit );
	
	// kill functions
	//kill_script( f_airlocks_two_ai_bays_init );
	
end

// === f_airlocks_two_ai_bay_timer_reset::: XXX
script static void f_airlocks_two_ai_bay_timer_reset()
	//dprint( "::: f_airlocks_two_ai_bay_timer_reset :::" );
	
	if ( timer_expired(L_airlock_two_spawn_timer) ) then
		L_airlock_two_spawn_timer = timer_stamp();
	end
	L_airlock_two_spawn_timer = L_airlock_two_spawn_timer + seconds_to_frames( real_random_range(R_airlock_two_spawn_time_min,R_airlock_two_spawn_time_max) );
	
end

// === f_airlocks_two_ai_bay_check_spawn::: XXX
script static boolean f_airlocks_two_ai_bay_check_spawn( short s_bay )
	( (S_airlock_two_spawn_last != s_bay) or (S_airlock_two_complete_cnt >= 1) ) and timer_expired(L_airlock_two_spawn_timer) and ( (ai_living_count(sg_airlock_two_outside) < 5) or (ai_living_count(sg_airlock_two_units) < 7) );
end

// === f_airlocks_two_ai_squad_get::: XXX
script static ai f_airlocks_two_ai_squad_get( short s_bay_id, boolean b_randomize, ai ai_squad_01, string_id sid_squad_01_pup, ai ai_squad_02, string_id sid_squad_02_pup )
local ai ai_squad = 				NONE;
local string_id sid_pup =		'NONE';

	//dprint( "::: f_airlocks_two_ai_squad_get :::" );
	if ( (ai_spawn_count(ai_squad_01) <= 0) or (ai_spawn_count(ai_squad_02) <= 0) ) then
		//dprint( "::: f_airlocks_two_ai_squad_get: START :::" );
		
		// reset the timer
		f_airlocks_two_ai_bay_timer_reset();
		
		// store which bay spawned last
		S_airlock_two_spawn_last = s_bay_id;

		// select a squad
		if ( b_randomize ) then
			//dprint( "::: f_airlocks_two_ai_squad_get: RANDOMIZE :::" );

			repeat
			
				begin_random_count( 1 )
					begin
						ai_squad = ai_squad_01;
						sid_pup = sid_squad_01_pup;
					end
					begin
						ai_squad = ai_squad_02;
						sid_pup = sid_squad_02_pup;
					end
				end
				
			until ( ai_spawn_count(ai_squad) <= 0, 1 );

		end

		// check squad 01		
		if ( (ai_squad == NONE) and (ai_spawn_count(ai_squad_01) <= 0) ) then
			//dprint( "::: f_airlocks_two_ai_squad_get: SET SQUAD 01 :::" );
			ai_squad = ai_squad_01;
			sid_pup = sid_squad_01_pup;
		end

		// check squad 02
		if ( (ai_squad == NONE) and (ai_spawn_count(ai_squad_02) <= 0) ) then
			//dprint( "::: f_airlocks_two_ai_squad_get: SET SQUAD 02 :::" );
			ai_squad = ai_squad_02;
			sid_pup = sid_squad_02_pup;
		end

		if ( ai_squad != NONE ) then
			thread( f_airlocks_two_ai_squad_spawn(s_bay_id, ai_squad, sid_pup) );
		end

	end
	//dprint( "::: f_airlocks_two_ai_squad_get: COMPLETE :::" );
	
	// return
	ai_squad;

end

// === f_airlocks_two_ai_squad_spawn::: XXX
script static ai f_airlocks_two_ai_squad_spawn( short s_bay_id, ai ai_squad, string_id sid_pup )

	sleep_until( f_airlocks_two_ai_bay_check_spawn(s_bay_id), 1 );

	// place the squad
	//dprint( "::: f_airlocks_two_ai_squad_spawn: PLACE :::" );
	ai_place( ai_squad );
	
	// wait for ai to have spawned
	//dprint( "::: f_airlocks_two_ai_squad_spawn: WAIT :::" );
	sleep_until( ai_spawn_count(ai_squad) > 0, 1 );

	// play the pup show
	//dprint( "::: f_airlocks_two_ai_squad_spawn: PUP :::" );
	pup_play_show( sid_pup );

end


/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: BAY: 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_bay_01_init::: Init
//script dormant f_airlocks_two_ai_bay_01_init()
	//dprint( "::: f_airlocks_two_ai_bay_01_init :::" );
	
//end

// === f_airlocks_two_ai_bay_01_deinit::: Deinit
script dormant f_airlocks_two_ai_bay_01_deinit()
	//dprint( "::: f_airlocks_two_ai_bay_01_deinit :::" );
	
	// kill functions
	//kill_script( f_airlocks_two_ai_bay_01_init );
	kill_script( f_airlocks_two_ai_bay_01_trigger_wave_01 );
	kill_script( f_airlocks_two_ai_bay_01_trigger_wave_02 );
	kill_script( f_airlocks_two_ai_bay_01_spawn_wave_02 );
	kill_script( f_airlocks_two_ai_bay_01_spawn_wave_02 );
	
end

// === f_airlocks_two_ai_bay_01_trigger_wave_01::: Trigger
script dormant f_airlocks_two_ai_bay_01_trigger_wave_01()

	// Wave 1
	sleep_until( (S_airlock_two_spawn_last != 0) and f_airlocks_two_ai_bay_check_spawn(01), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_01_trigger_wave_01 :::" );
	S_airlock_two_spawn_last = 01;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_01_spawn_wave_01 );
	
end

// === f_airlocks_two_ai_bay_01_trigger_wave_02::: Trigger
script dormant f_airlocks_two_ai_bay_01_trigger_wave_02()

	// Wave 2
	sleep_until( f_airlocks_two_ai_bay_check_spawn(01), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_01_trigger_wave_02 :::" );
	S_airlock_two_spawn_last = 01;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_01_spawn_wave_02 );
	
end
// === f_airlocks_two_ai_bay_01_spawn_wave_01::: Action
script dormant f_airlocks_two_ai_bay_01_spawn_wave_01()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_01_spawn_wave_01: START :::" );
	ai_place( sq_airlock_two_bay_01_01 );
	sleep_until( ai_living_count(sq_airlock_two_bay_01_01) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_01_01' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_01_spawn_wave_01: END :::" );
	
end

// === f_airlocks_two_ai_bay_01_spawn_wave_02::: Action
script dormant f_airlocks_two_ai_bay_01_spawn_wave_02()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_01_spawn_wave_02: START :::" );
	ai_place( sq_airlock_two_bay_01_02 );
	sleep_until( ai_living_count(sq_airlock_two_bay_01_02) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_01_02' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_01_spawn_wave_02: END :::" );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: BAY: 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_bay_02_init::: Init
//script dormant f_airlocks_two_ai_bay_02_init()
	//dprint( "::: f_airlocks_two_ai_bay_02_init :::" );
	
//end

// === f_airlocks_two_ai_bay_02_deinit::: Deinit
script dormant f_airlocks_two_ai_bay_02_deinit()
	//dprint( "::: f_airlocks_two_ai_bay_02_deinit :::" );
	
	// kill functions
	//kill_script( f_airlocks_two_ai_bay_02_init );
	kill_script( f_airlocks_two_ai_bay_02_trigger_wave_01 );
	kill_script( f_airlocks_two_ai_bay_02_trigger_wave_02 );
	kill_script( f_airlocks_two_ai_bay_02_spawn_wave_02 );
	kill_script( f_airlocks_two_ai_bay_02_spawn_wave_02 );
	
end

// === f_airlocks_two_ai_bay_02_trigger_wave_01::: Trigger
script dormant f_airlocks_two_ai_bay_02_trigger_wave_01()

	// Wave 1
	sleep_until( (S_airlock_two_spawn_last != 0) and f_airlocks_two_ai_bay_check_spawn(02), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_02_trigger_wave_01 :::" );
	S_airlock_two_spawn_last = 02;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_02_spawn_wave_01 );
	
end

// === f_airlocks_two_ai_bay_02_trigger_wave_02::: Trigger
script dormant f_airlocks_two_ai_bay_02_trigger_wave_02()

	// Wave 2
	sleep_until( f_airlocks_two_ai_bay_check_spawn(02), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_02_trigger_wave_02 :::" );
	S_airlock_two_spawn_last = 02;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_02_spawn_wave_02 );
	
end

// === f_airlocks_two_ai_bay_02_spawn_wave_01::: Action
script dormant f_airlocks_two_ai_bay_02_spawn_wave_01()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_02_spawn_wave_01: START :::" );
	ai_place( sq_airlock_two_bay_02_01 );
	sleep_until( ai_living_count(sq_airlock_two_bay_02_01) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_02_01' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_02_spawn_wave_01: END :::" );
	
end

// === f_airlocks_two_ai_bay_02_spawn_wave_02::: Action
script dormant f_airlocks_two_ai_bay_02_spawn_wave_02()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_02_spawn_wave_02: START :::" );
	ai_place( sq_airlock_two_bay_02_02 );
	sleep_until( ai_living_count(sq_airlock_two_bay_02_02) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_02_02' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_02_spawn_wave_02: END :::" );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: BAY: 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_ai_bay_03_init::: Init
//script dormant f_airlocks_two_ai_bay_03_init()
	//dprint( "::: f_airlocks_two_ai_bay_03_init :::" );
	
//end

// === f_airlocks_two_ai_bay_03_deinit::: Deinit
script dormant f_airlocks_two_ai_bay_03_deinit()
	//dprint( "::: f_airlocks_two_ai_bay_03_deinit :::" );
	
	// kill functions
	//kill_script( f_airlocks_two_ai_bay_03_init );
	kill_script( f_airlocks_two_ai_bay_03_trigger_wave_01 );
	kill_script( f_airlocks_two_ai_bay_03_trigger_wave_02 );
	kill_script( f_airlocks_two_ai_bay_03_spawn_wave_02 );
	kill_script( f_airlocks_two_ai_bay_03_spawn_wave_02 );
	
end

// === f_airlocks_two_ai_bay_03_trigger_wave_01::: Trigger
script dormant f_airlocks_two_ai_bay_03_trigger_wave_01()

	// Wave 1
	sleep_until( (S_airlock_two_spawn_last != 0) and f_airlocks_two_ai_bay_check_spawn(03), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_03_trigger_wave_01 :::" );
	S_airlock_two_spawn_last = 03;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_03_spawn_wave_01 );
	
end

// === f_airlocks_two_ai_bay_03_trigger_wave_02::: Trigger
script dormant f_airlocks_two_ai_bay_03_trigger_wave_02()

	// Wave 2
	sleep_until( f_airlocks_two_ai_bay_check_spawn(03), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_03_trigger_wave_02 :::" );
	S_airlock_two_spawn_last = 03;
	f_airlocks_two_ai_bay_timer_reset();
	wake( f_airlocks_two_ai_bay_03_spawn_wave_02 );
	
end
// === f_airlocks_two_ai_bay_03_spawn_wave_01::: Action
script dormant f_airlocks_two_ai_bay_03_spawn_wave_01()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_03_spawn_wave_01: START :::" );
	ai_place( sq_airlock_two_bay_03_01 );
	sleep_until( ai_living_count(sq_airlock_two_bay_03_01) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_03_01' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_03_spawn_wave_01: END :::" );
	
end

// === f_airlocks_two_ai_bay_03_spawn_wave_02::: Action
script dormant f_airlocks_two_ai_bay_03_spawn_wave_02()
local long l_pup_id = 0;
	
	// play show
	//dprint( "::: f_airlocks_two_ai_bay_03_spawn_wave_02: START :::" );
	ai_place( sq_airlock_two_bay_03_02 );
	sleep_until( ai_living_count(sq_airlock_two_bay_03_02) > 0, 1 );
	l_pup_id = pup_play_show( 'pup_airlock_two_bay_03_02' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	//dprint( "::: f_airlocks_two_ai_bay_03_spawn_wave_02: END :::" );
	
end
*/