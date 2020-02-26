// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// CORTANA
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CORTANA: LOCATION
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short DEF_S_CORTANA_LOCATION_CHIEF()															0;																																				end
script static short DEF_S_CORTANA_LOCATION_OBJECT()															1;																																				end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === cortana_location_object_set: Sets the state variable for Cortana
//			xxx = XXX
//			xxx = XXX
//			xxx = XXX
script static void cortana_location_set( short s_state, object obj_object )

	// store the state
	if ( S_cortana_location_state != s_state ) then

		S_cortana_location_state = s_state;

		/*
		// apply global changes
		if ( cortana_location_get() == DEF_S_CORTANA_LOCATION_CHIEF() ) then
			f_fx_hud_full();
		end
		if ( cortana_location_get() != DEF_S_CORTANA_LOCATION_CHIEF() ) then
			f_fx_hud_lite();
		end
		*/

	end
	
	// store the object
	if ( f_cortana_location_object_get() != obj_object ) then

		// scale out old object
		if ( f_cortana_location_object_get() != NONE ) then
			sys_cortana_scale_apply( DEF_S_CORTANA_SCALE_HIDDEN() );
		end

		// force the object to scale down by default so it can scale in
		if ( obj_object != NONE ) then
			object_set_scale( obj_object, DEF_S_CORTANA_SCALE_HIDDEN(), 0 );
		end

		// detach from parent if necessary
		if ( (obj_object == NONE) and (f_cortana_location_object_get() != NONE) and (f_cortana_location_parent_get() != NONE) ) then
			objects_detach( f_cortana_location_parent_get(), f_cortana_location_object_get() );
			sys_cortana_location_parent_set( NONE );
		end

		OBJ_cortana_location_object = obj_object;

		// scale in new object
		if ( f_cortana_location_object_get() != NONE ) then
			sys_cortana_scale_apply( f_cortana_scale_get() );
		end

	end
	
end

// === cortana_location_chief_set: Sets Cortana's location state to be in the Chief's helmet
script static void cortana_location_chief_set()
	cortana_location_set( DEF_S_CORTANA_LOCATION_CHIEF(), NONE );
end

// === cortana_location_object_set: Sets Cortana's location to be an object
//			obj_cortana = XXX
script static void cortana_location_object_set( object obj_cortana )
	cortana_location_set( DEF_S_CORTANA_LOCATION_OBJECT(), obj_cortana );
end

// === cortana_location_object_attach_set: Attaches Cortana to an object
//			obj_parent = XXX
//			m_parent = XXX
//			obj_cortana = XXX
//			m_cortana = XXX
script static void cortana_location_object_attach_set( object obj_parent, string_id m_parent, object obj_cortana, string_id m_cortana )

	if ( obj_parent != OBJ_cortana_location_parent ) then
	
		// handles detaching Cortana from any parent object and default scaling
		cortana_location_set( DEF_S_CORTANA_LOCATION_OBJECT(), NONE );

		// attach
		objects_attach( obj_parent, m_parent, obj_cortana, m_cortana );
		
		// assign the cortana object
		cortana_location_object_set( obj_cortana );

		// store the parent
		sys_cortana_location_parent_set( obj_parent );
		
	end
	
end

// === cortana_location_get: Gets the current Cortana location state
//	RETURN:  [short] XXX
script static short cortana_location_get()
	S_cortana_location_state;
end

// === cortana_location_check_chief: Checks if Cortana is currrently in the Chief's helmet
//	RETURN:  [boolean] XXX
script static boolean cortana_location_check_chief()
	cortana_location_get() == DEF_S_CORTANA_LOCATION_CHIEF();
end

// === cortana_location_check_object: Checks if Cortana's current location is an object
//	RETURN:  [boolean] XXX
script static boolean cortana_location_check_object()
	cortana_location_get() == DEF_S_CORTANA_LOCATION_OBJECT();
end

// === f_cortana_location_object_get: Gets the object that Cortana exists at
//	RETURN:  [object] XXX
script static object f_cortana_location_object_get()
	OBJ_cortana_location_object;
end

// === f_cortana_location_parent_get: Gets the parent object that Cortana is attached to
//	RETURN:  [object] XXX
script static object f_cortana_location_parent_get()
	OBJ_cortana_location_parent;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_cortana_location_state = 																				DEF_S_CORTANA_LOCATION_CHIEF();
static object OBJ_cortana_location_object = 																		NONE;
static object OBJ_cortana_location_parent = 																		NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === sys_cortana_location_parent_set: Sets Cortana's parent location object
script static void sys_cortana_location_parent_set( object obj_parent )
	OBJ_cortana_location_parent = obj_parent;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CORTANA: RAMPANCY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short DEF_S_CORTANA_RAMPANCY_STATE_NORMAL() 											0;																																				end
script static short DEF_S_CORTANA_RAMPANCY_STATE_RAMPANT() 											1;																																				end

script static short DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_LOOP() 									-3;																																				end		// Locks the random type selected for the durration of the loop
script static short DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_EFFECT() 								-2;																																				end		// Locks the random type selected for the durration of the effect
script static short DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_SINGLE() 								-1;																																				end		// Randomly selects a new effect every time it plays the effect
script static short DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM() 												DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_SINGLE();															end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_NONE() 													0;																																				end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_GLITCH() 												1;																																				end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_JAMMER() 												2;																																				end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_NOISE() 												3;																																				end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_STATIC() 												4;																																				end
script static short DEF_S_CORTANA_RAMPANCY_TYPE_WARP() 													5;																																				end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static short f_cortana_rampancy_state_get()
	S_cortana_rampancy_state;
end

script static boolean f_cortana_rampancy_state_check_normal()
	f_cortana_rampancy_state_get() == DEF_S_CORTANA_RAMPANCY_STATE_NORMAL();
end

script static boolean f_cortana_rampancy_state_check_rampant()
	f_cortana_rampancy_state_get() == DEF_S_CORTANA_RAMPANCY_STATE_RAMPANT();
end

script static boolean f_cortana_rampancy_check_visible()
	cortana_location_check_chief() and f_cortana_rampancy_state_check_rampant();
end

script static void f_cortana_rampancy_set( short s_state, short s_type )
	f_cortana_rampancy_type_set( s_type );
	f_cortana_rampancy_state_set( s_state );
end

script static void f_cortana_rampancy_state_set( short s_state )
static long l_rampancy_loop_thread = 0;
	if ( f_cortana_rampancy_state_get() != s_state ) then
		S_cortana_rampancy_state = s_state;
	
		if ( f_cortana_rampancy_state_get() != DEF_S_CORTANA_RAMPANCY_STATE_NORMAL() ) then
			if ( not isthreadvalid(l_rampancy_loop_thread) ) then
				l_rampancy_loop_thread = thread( sys_cortana_rampancy_loop_add(S_cortana_rampancy_type, R_cortana_rampancy_effect_time_min, R_cortana_rampancy_effect_time_max, R_cortana_rampancy_effect_delay_min, R_cortana_rampancy_effect_delay_max, TRUE) );
			end
		end
	
	end

end

script static void f_cortana_rampancy_state_set_timer( short s_state, real r_time )
	sleep_s( r_time );
	f_cortana_rampancy_state_set( s_state );
end

script static short f_cortana_rampancy_type_get()
	S_cortana_rampancy_type;
end

script static boolean f_cortana_rampancy_type_check_random()
	( f_cortana_rampancy_type_get() >= DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_LOOP() ) and ( f_cortana_rampancy_type_get() <= DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_SINGLE() );
end
script static boolean f_cortana_rampancy_type_check_glitch()
	f_cortana_rampancy_type_get() == DEF_S_CORTANA_RAMPANCY_TYPE_GLITCH();
end
script static boolean f_cortana_rampancy_type_check_jammer()
	f_cortana_rampancy_type_get() == DEF_S_CORTANA_RAMPANCY_TYPE_JAMMER();
end
script static boolean f_cortana_rampancy_type_check_noise()
	f_cortana_rampancy_type_get() == DEF_S_CORTANA_RAMPANCY_TYPE_NOISE();
end
script static boolean f_cortana_rampancy_type_check_static()
	f_cortana_rampancy_type_get() == DEF_S_CORTANA_RAMPANCY_TYPE_STATIC();
end
script static boolean f_cortana_rampancy_type_check_warp()
	f_cortana_rampancy_type_get() == DEF_S_CORTANA_RAMPANCY_TYPE_WARP();
end

script static void f_cortana_rampancy_type_set( short s_type )

	if ( f_cortana_rampancy_type_get() != s_type ) then
		S_cortana_rampancy_type = s_type;
	end

end

script static void f_cortana_rampancy_type_set_timer( short s_type, real r_time )
	sleep_s( r_time );
	f_cortana_rampancy_type_set( s_type );
end

script static void f_cortana_rampancy_effect_time_set( real r_min, real r_max )

	// defaults
	if ( r_min < 0.0 ) then
		r_min = DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MIN_DEFAULT();
	end
	if ( r_max < 0.0 ) then
		r_min = DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MAX_DEFAULT();
	end
	
	if ( r_min <= r_max ) then
		R_cortana_rampancy_effect_time_min = r_min;
		R_cortana_rampancy_effect_time_max = r_max;
	else
		R_cortana_rampancy_effect_time_min = r_max;
		R_cortana_rampancy_effect_time_max = r_min;
	end

end
script static void f_cortana_rampancy_random_delay_set( real r_min, real r_max )

	// defaults
	if ( r_min < 0.0 ) then
		r_min = DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MIN_DEFAULT();
	end
	if ( r_max < 0.0 ) then
		r_min = DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MAX_DEFAULT();
	end
	
	if ( r_min <= r_max ) then
		R_cortana_rampancy_effect_delay_min = r_min;
		R_cortana_rampancy_effect_delay_max = r_max;
	else
		R_cortana_rampancy_effect_delay_min = r_max;
		R_cortana_rampancy_effect_delay_max = r_min;
	end

end

script static long f_cortana_rampancy_loop_add( short s_type, real r_time_min, real r_time_max, real r_delay_min, real r_delay_max )
	thread( sys_cortana_rampancy_loop_add(s_type, r_time_min, r_time_max, r_delay_min, r_delay_max, FALSE) );
end

script static long f_cortana_rampancy_effect_add( short s_type, real r_time_min, real r_time_max )
	thread( sys_cortana_rampancy_effect_add(s_type, r_time_min, r_time_max, FALSE) );
end

script static short f_cortana_rampancy_type_random_roll()
	random_range( DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_MIN(), DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_MAX() );
end

script static boolean f_cortana_rampancy_loop_active()
	f_cortana_rampancy_loop_cnt() > 0;
end
script static short f_cortana_rampancy_loop_cnt()
	S_cortana_rampancy_loop_cnt;
end

script static boolean f_cortana_rampancy_effect_active()
	f_cortana_rampancy_effect_cnt() > 0;
end
script static short f_cortana_rampancy_effect_cnt()
	S_cortana_rampancy_effect_cnt;
end

script static void f_cortana_rampancy_loop_reset()
local short s_state = f_cortana_rampancy_state_get();

	repeat
	
		if ( f_cortana_rampancy_state_get() != DEF_S_CORTANA_RAMPANCY_STATE_NORMAL() ) then
			s_state = f_cortana_rampancy_state_get();
			f_cortana_rampancy_state_set( DEF_S_CORTANA_RAMPANCY_STATE_NORMAL() );
		end
		
		sleep_until( (not f_cortana_rampancy_loop_active()) or (f_cortana_rampancy_state_get() != DEF_S_CORTANA_RAMPANCY_STATE_NORMAL()), 1 );
	until( not f_cortana_rampancy_loop_active(), 1 );

	f_cortana_rampancy_state_set( s_state );

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MIN_DEFAULT() 						2.5;																																			end
script static real DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MAX_DEFAULT() 						5.0;																																			end

script static real DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MIN_DEFAULT() 						0.20;																																			end
script static real DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MAX_DEFAULT() 						0.75;																																			end

script static real DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_MIN() 										DEF_S_CORTANA_RAMPANCY_TYPE_GLITCH();																			end
script static real DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_MAX() 										DEF_S_CORTANA_RAMPANCY_TYPE_WARP();																				end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_cortana_rampancy_state = 																				DEF_S_CORTANA_RAMPANCY_STATE_NORMAL();

static short S_cortana_rampancy_type = 																					DEF_S_CORTANA_RAMPANCY_TYPE_NONE();

static short R_cortana_rampancy_effect_time_min	=																DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MIN_DEFAULT();
static short R_cortana_rampancy_effect_time_max	=																DEF_S_CORTANA_RAMPANCY_EFFECT_TIME_MAX_DEFAULT();

static short R_cortana_rampancy_effect_delay_min =															DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MIN_DEFAULT();
static short R_cortana_rampancy_effect_delay_max =															DEF_S_CORTANA_RAMPANCY_EFFECT_DELAY_MAX_DEFAULT();

static short S_cortana_rampancy_loop_cnt =																			0;
static short S_cortana_rampancy_effect_cnt =																		0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static void sys_cortana_rampancy_loop_add( short s_type, real r_time_min, real r_time_max, real r_delay_min, real r_delay_max, boolean b_main_loop )
local short s_type_play = s_type;
local long l_timer = 0;
local long l_fx_thread = 0;

	// increment loop cnt
	S_cortana_rampancy_loop_cnt = S_cortana_rampancy_loop_cnt + 1;

	repeat

		// if this is a main loop, make sure
		if ( b_main_loop ) then
		
			// see if the current type has changed
			if ( s_type != S_cortana_rampancy_type ) then
				s_type = S_cortana_rampancy_type;
				s_type_play = s_type;
			end
			
			r_time_min = R_cortana_rampancy_effect_time_min;
			r_time_max = R_cortana_rampancy_effect_time_max;
			r_delay_min = R_cortana_rampancy_effect_delay_min;
			r_delay_max = R_cortana_rampancy_effect_delay_max;

		end

		if ( s_type_play != DEF_S_CORTANA_RAMPANCY_TYPE_NONE() ) then

			// if it's loop type, lock it so it doesn't change
			if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_LOOP() ) then
				s_type_play = f_cortana_rampancy_type_random_roll();
			end

			// play the effect
			l_fx_thread = thread( sys_cortana_rampancy_effect_add(f_cortana_rampancy_type_get(), r_time_min, r_time_max, b_main_loop) );
			sleep_until( not isthreadvalid(l_fx_thread), 1 );
			
		end

		// set the delay timer
		l_timer = game_tick_get() + seconds_to_frames( real_random_range(r_delay_min, r_delay_max) );
		
		// wait if the effect isn't visible
		sleep_until( (f_cortana_rampancy_check_visible() and (game_tick_get() >= l_timer)) or (b_main_loop and (s_type != f_cortana_rampancy_type_get())) or (not f_cortana_rampancy_state_check_rampant()), 1 );
		
	until( not f_cortana_rampancy_state_check_rampant(), 1 );

	// deccrement loop cnt
	S_cortana_rampancy_loop_cnt = S_cortana_rampancy_loop_cnt - 1;

end

script static void sys_cortana_rampancy_effect_add( short s_type, real r_time_min, real r_time_max, boolean b_main_loop )
local short s_type_play = s_type;
local long l_timer = game_tick_get() + seconds_to_frames( real_random_range(r_time_min, r_time_max) );
local long l_timer_play = 0;
local long l_timer_effect = 14;
local effect fx_player0 = NONE;
local effect fx_player1 = NONE;
local effect fx_player2 = NONE;
local effect fx_player3 = NONE;

	// increment effect cnt
	S_cortana_rampancy_effect_cnt = S_cortana_rampancy_effect_cnt + 1;

	// if type random effect, lock the type for the durration of the effect
	if ( s_type == DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_EFFECT() ) then
		s_type = f_cortana_rampancy_type_random_roll();
	end

	// set the play type
	s_type_play = s_type;

	repeat
	
		// check if it's random single type then roll for a random effect
		if ( s_type == DEF_S_CORTANA_RAMPANCY_TYPE_RANDOM_SINGLE() ) then
			s_type_play = f_cortana_rampancy_type_random_roll();
		end
	
		// set the fx to play
		if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_GLITCH() ) then
			fx_player0 = "fx\library\characters\cortana\rampancy\rampancy_glitch.effect";
		end
		if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_JAMMER() ) then
			fx_player0 = "fx\library\characters\cortana\rampancy\rampancy_jammer_static.effect";
		end
		if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_NOISE() ) then
			fx_player0 = "fx\library\characters\cortana\rampancy\rampancy_noise.effect";
		end
		if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_STATIC() ) then
			fx_player0 = "fx\library\characters\cortana\rampancy\rampancy_static.effect";
		end
		if ( s_type_play == DEF_S_CORTANA_RAMPANCY_TYPE_WARP() ) then
			fx_player0 = "fx\library\characters\cortana\rampancy\rampancy_warp_static.effect";
		end
		fx_player1 = fx_player0;
		fx_player2 = fx_player0;
		fx_player3 = fx_player0;
		
		// clear the fx that shouldn't be playing because players are dead
		if ( unit_get_health(Player0()) < 0 ) then
			fx_player0 = NONE;
		end
		if ( unit_get_health(Player1()) < 0 ) then
			fx_player1 = NONE;
		end
		if ( unit_get_health(Player2()) < 0 ) then
			fx_player2 = NONE;
		end
		if ( unit_get_health(Player3()) < 0 ) then
			fx_player3 = NONE;
		end

		// play the fx on each player
		if ( fx_player0 != NONE ) then
			effect_new_on_object_marker( fx_player0, player0, "" );
		end
		if ( fx_player1 != NONE ) then
			effect_new_on_object_marker( fx_player1, player1, "" );
		end
		if ( fx_player2 != NONE ) then
			effect_new_on_object_marker( fx_player2, player2, "" );
		end
		if ( fx_player3 != NONE ) then
			effect_new_on_object_marker( fx_player3, player3, "" );
		end
	
		// wait for the fx to play
		l_timer_play = game_tick_get() + l_timer_effect;
		sleep_until( (f_cortana_rampancy_check_visible() and ((game_tick_get() >= l_timer_play) or (game_tick_get() >= l_timer))) or (not f_cortana_rampancy_state_check_rampant()), 1 );
		
		// remove the fx from each player
		if ( fx_player0 != NONE ) then
			effect_stop_object_marker( fx_player0, player0, "" );
		end
		if ( fx_player1 != NONE ) then
			effect_stop_object_marker( fx_player1, player1, "" );
		end
		if ( fx_player2 != NONE ) then
			effect_stop_object_marker( fx_player2, player2, "" );
		end
		if ( fx_player3 != NONE ) then
			effect_stop_object_marker( fx_player3, player3, "" );
		end

	until( (not f_cortana_rampancy_check_visible()) or (game_tick_get() >= l_timer) or not f_cortana_rampancy_state_check_rampant(), 1 );

	// decrement effect cnt
	S_cortana_rampancy_effect_cnt = S_cortana_rampancy_effect_cnt - 1;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CORTANA: SCALE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static real DEF_S_CORTANA_SCALE_DEFAULT()																1.0;																																			end
script static real DEF_S_CORTANA_SCALE_HIDDEN()																	0.001;																																		end

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static void f_cortana_scale_set( real r_scale )
	R_cortana_scale = r_scale;
	// apply the scale
	sys_cortana_scale_apply( r_scale );
end

script static real f_cortana_scale_get()
	R_cortana_scale;
end

script static void f_cortana_scale_time_set( real r_time )
	R_cortana_scale_time = r_time;
end

script static real f_cortana_scale_time_get()
	R_cortana_scale_time;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_cortana_scale = 																									DEF_S_CORTANA_SCALE_DEFAULT();
static real R_cortana_scale_time = 																							1.0;
static real R_cortana_scale_current = 																					DEF_S_CORTANA_SCALE_DEFAULT();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void sys_cortana_scale_apply( real r_scale )
	
	if ( f_cortana_location_object_get() != NONE ) then
		object_set_scale( f_cortana_location_object_get(), f_cortana_scale_get(), f_cortana_scale_time_get() * abs_r(r_scale - R_cortana_scale_current) );
	end

	// store the old scale 
	R_cortana_scale_current = r_scale;
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CORTANA: HIDE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static boolean f_cortana_hidden()
	f_cortana_hide_force_get() or B_cortana_hide_auto_state;
end

script static void f_cortana_hide_force_set( boolean b_hide_force )
	B_cortana_hide_force = b_hide_force;
	// apply hide system
	sys_cortana_hide();
end

script static boolean f_cortana_hide_force_get()
	B_cortana_hide_force;
end

script static void f_cortana_hide_auto_set( boolean b_hide_auto )
	B_cortana_hide_auto = b_hide_auto;
end

script static boolean f_cortana_hide_auto_get()
	B_cortana_hide_auto;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_cortana_hide_force = 																					FALSE;
static boolean B_cortana_hide_auto = 																						FALSE;
static boolean B_cortana_hide_auto_state = 																			FALSE;

script static void sys_cortana_hide()
	if ( f_cortana_hidden() ) then
		sys_cortana_scale_apply( DEF_S_CORTANA_SCALE_HIDDEN() );
	end
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CORTANA: FACE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
















// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££
// LEGACY £££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££££

// =================================================================================================
// =================================================================================================
// Cortana Rampancy
// =================================================================================================
// =================================================================================================
script static void cortana_hud_rampancy_loop_begin(string rampancy_type, real rampancy_frequency, real delay )

	static long thread_id = 0;
	thread_id = thread (cortana_hud_rampancy_loop_main(rampancy_type, rampancy_frequency, delay ));
	
	sleep_until( LevelEventStatus( "stop cortana hud rampancy" ), 1);
	
	kill_thread(thread_id);
end

script static void cortana_hud_rampancy_loop_end( )
 notifylevel( "stop cortana hud rampancy" );
end


script static void cortana_hud_rampancy_loop_main(string rampancy_type, real rampancy_frequency, real delay )
	static real max_sleep_time = 30 * 0.75;		
	static real min_sleep_time = 30 * 0.2;			
	
	// delay so it doesn't start right on some trigger
	sleep (30 * delay);
	
	repeat
			cortana_hud_rampancy(rampancy_type, real_random_range (0.5, 3.0));
			
			sleep (real_random_range (max_sleep_time / rampancy_frequency, min_sleep_time / rampancy_frequency));
	until (1 == 0, 1);
end

script static void cortana_hud_rampancy(string rampancy_type, real rampancy_time)
	static real loop_ticks = 0;
	static real rampancy_ticks = 0;
	
	rampancy_ticks = 30 * rampancy_time;
	
	if (rampancy_type == "glitch") then
		repeat
			effect_new_on_object_marker ("fx\library\characters\cortana\rampancy\rampancy_glitch.effect", player0,"");
			sleep(14);
			effect_stop_object_marker ("fx\library\characters\cortana\rampancy\rampancy_glitch.effect", player0,"");
			loop_ticks = loop_ticks + 14;
		until (loop_ticks >= rampancy_ticks, 1);
	end

	if (rampancy_type == "jammer") then
		repeat
			effect_new_on_object_marker ("fx\library\characters\cortana\rampancy\rampancy_jammer_static.effect", player0,"");
			sleep(14);
			effect_stop_object_marker ("fx\library\characters\cortana\rampancy\rampancy_jammer_static.effect", player0,"");
			loop_ticks = loop_ticks + 14;
		until (loop_ticks >= rampancy_ticks, 1);
	end

	if (rampancy_type == "noise") then
		repeat
			effect_new_on_object_marker ("fx\library\characters\cortana\rampancy\rampancy_noise.effect", player0,"");
			sleep(14);
			effect_stop_object_marker ("fx\library\characters\cortana\rampancy\rampancy_noise.effect", player0,"");
			loop_ticks = loop_ticks + 14;
		until (loop_ticks >= rampancy_ticks, 1);
	end
	
	if (rampancy_type == "static") then
		repeat
			effect_new_on_object_marker ("fx\library\characters\cortana\rampancy\rampancy_static.effect", player0,"");
			sleep(14);
			effect_stop_object_marker ("fx\library\characters\cortana\rampancy\rampancy_static.effect", player0,"");
			loop_ticks = loop_ticks + 14;
		until (loop_ticks >= rampancy_ticks, 1);
	end
	
	if (rampancy_type == "warp") then
		repeat
			effect_new_on_object_marker ("fx\library\characters\cortana\rampancy\rampancy_warp_static.effect", player0,"");
			sleep(14);
			effect_stop_object_marker ("fx\library\characters\cortana\rampancy\rampancy_warp_static.effect", player0,"");
			loop_ticks = loop_ticks + 14;
		until (loop_ticks >= rampancy_ticks, 1);
	end
	
	loop_ticks = 0;
	rampancy_ticks = 0;
	
end