//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_<area> (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** MISSION: SHAKES ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_mission_shakes_delay_min = 									0.0;
global real R_mission_shakes_delay_max = 									0.0;
global real R_mission_shakes_intensity_min = 							0.0;
global real R_mission_shakes_intensity_max = 							0.0;

static real DEF_R_MISSION_SHAKE_DELAY_VERY_LONG = 				15.0;
static real DEF_R_MISSION_SHAKE_DELAY_LONG = 							12.5;
static real DEF_R_MISSION_SHAKE_DELAY_MEDIUM = 						10.0;
static real DEF_R_MISSION_SHAKE_DELAY_SHORT = 						07.5;
static real DEF_R_MISSION_SHAKE_DELAY_VERY_SHORT = 				05.0;

/*
DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW()
DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW()
DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED()
DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH()
DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH()
*/
// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_mission_shakes_startup::: Startup
script startup f_mission_shakes_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_mission_shakes_startup :::" );

	// init atrium
	wake( f_mission_shakes_init );

end

// === f_mission_shakes_init::: Initialize
script dormant f_mission_shakes_init()
	//dprint( "::: f_mission_shakes_init :::" );
	
	// init sub modules
	wake( f_mission_shakes_fx_init );
	
	wake( f_mission_shakes_trigger );
	wake( f_mission_shakes_loop );

end

// === f_mission_shakes_deinit::: Deinitialize
script dormant f_mission_shakes_deinit()
	//dprint( "::: f_mission_shakes_deinit :::" );
	
	// deinit sub modules
	wake( f_mission_shakes_fx_deinit );

	// kill functions
	kill_script( f_mission_shakes_init );
	kill_script( f_mission_shakes_trigger );
	kill_script( f_mission_shakes_loop );

end

// === f_mission_shakes_trigger::: Trigger
script dormant f_mission_shakes_trigger()
local short s_zoneset_current = -1;

	repeat
		
		// wait for a zone set switch
		sleep_until( zoneset_current() != s_zoneset_current, 1 );
		s_zoneset_current = zoneset_current();
		//dprint( "::: f_mission_shakes_trigger :::" );
		
		if ( (s_zoneset_current == S_ZONESET_CIN_M80) or (s_zoneset_current == S_ZONESET_CIN_M82) or (s_zoneset_current == S_ZONESET_CIN_M83) or (s_zoneset_current == S_ZONESET_COMPOSER_REMOVAL_EXIT) ) then
			f_mission_shakes_intensity_set( 0.0, 0.0 );
		end

		if ( s_zoneset_current == S_ZONESET_CRASH or s_zoneset_current == S_ZONESET_CRASH_TRANSITION ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_VERY_LONG );
		end
		
		if ( s_zoneset_current == S_ZONESET_TO_HORSESHOE ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_HORSESHOE ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		
		if ( s_zoneset_current == S_ZONESET_TO_LAB ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( (s_zoneset_current == S_ZONESET_LAB) or (s_zoneset_current == S_ZONESET_LAB_EXIT) ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		
		if ( s_zoneset_current == S_ZONESET_ATRIUM ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_ATRIUM_HUB ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

		if ( (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE) or (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE_B) ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_AIRLOCK_ONE ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

		if ( s_zoneset_current == S_ZONESET_TO_AIRLOCK_TWO ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_AIRLOCK_TWO ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

		if ( s_zoneset_current == S_ZONESET_TO_LOOKOUT ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( (s_zoneset_current == S_ZONESET_LOOKOUT) or ((s_zoneset_current == S_ZONESET_LOOKOUT_EXIT)) ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

		if ( s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_A ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_B ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		if ( s_zoneset_current == S_ZONESET_ATRIUM_RETURNING ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end
		
		if ( (s_zoneset_current == S_ZONESET_ATRIUM_LOOKOUT) or (s_zoneset_current == S_ZONESET_ATRIUM_DAMAGED) ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

		if ( (s_zoneset_current == S_ZONESET_MECHROOM_RETURN) or (s_zoneset_current == S_ZONESET_COMPOSER_REMOVAL) ) then
			f_mission_shakes_intensity_set( DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH() );
			f_mission_shakes_delay_set( DEF_R_MISSION_SHAKE_DELAY_MEDIUM, DEF_R_MISSION_SHAKE_DELAY_LONG );
		end

	until( FALSE, 1 );

end

// === f_mission_shakes_loop::: Loop
script dormant f_mission_shakes_loop()
local short s_played_id = 0;
local short s_played_last = 0;
local real r_intensity = 0.0;

	repeat
	
		sleep_until( R_mission_shakes_intensity_max >= DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), 1 ); 
	
		// wait
		sleep_rand_s( R_mission_shakes_delay_min, R_mission_shakes_delay_max );;
		
		// roll intensity
		r_intensity = real_random_range( R_mission_shakes_intensity_min, R_mission_shakes_intensity_max );
		
		// play shake
		if ( r_intensity >= DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW() ) then
			s_played_id = 0;
			repeat
				
				begin_random_count( 1 )

					s_played_id = f_mission_shakes_play( 11, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), r_intensity, -0.025, -1, -1.250, f_sfx_mission_shake_low_01() );
					s_played_id = f_mission_shakes_play( 12, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), r_intensity, -0.025, -1, -1.125, f_sfx_mission_shake_low_02() );
					s_played_id = f_mission_shakes_play( 13, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), r_intensity, -0.125, -1, -1.375, f_sfx_mission_shake_low_03() );
					s_played_id = f_mission_shakes_play( 14, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), r_intensity, -0.025, -1, -2.375, f_sfx_mission_shake_low_04() );
					s_played_id = f_mission_shakes_play( 15, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), r_intensity, -0.025, -1, -3.375, f_sfx_mission_shake_low_05() );
					
					s_played_id = f_mission_shakes_play( 21, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), r_intensity, -0.025, -1, -3.125, f_sfx_mission_shake_medium_01() );
					s_played_id = f_mission_shakes_play( 22, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), r_intensity, -0.025, -1, -1.500, f_sfx_mission_shake_medium_02() );
					s_played_id = f_mission_shakes_play( 23, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), r_intensity, -0.025, -1, -0.750, f_sfx_mission_shake_medium_03() );
					s_played_id = f_mission_shakes_play( 24, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), r_intensity, -0.025, -1, -0.925, f_sfx_mission_shake_medium_04() );
					
					s_played_id = f_mission_shakes_play( 31, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH(), r_intensity, -0.025, -1, -1.000, f_sfx_mission_shake_high_01() );
					s_played_id = f_mission_shakes_play( 32, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH(), r_intensity, -0.125, -1, -1.875, f_sfx_mission_shake_high_02());
					s_played_id = f_mission_shakes_play( 33, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH(), r_intensity, -0.375, -1, -2.000, f_sfx_mission_shake_high_03() );
					s_played_id = f_mission_shakes_play( 34, s_played_last, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH(), DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH(), r_intensity, -0.500, -1, -1.750, f_sfx_mission_shake_high_04() );

				end
			
			until ( s_played_id > 0, 1 );
		end
		
		// store last played id
		s_played_last = s_played_id;
	until( FALSE, 1 );
end

// === xxx::: xxx
script static void f_mission_shakes_mod_set( real r_mod, real r_time )
static real r_mod_stored = f_screenshake_intensity_mod_get();
static real l_thread = 0;
	//dprint( "::: f_mission_shakes_mod_set :::" );
	
	// restore stored value
	if ( r_mod == 0.0 ) then
		r_mod_stored = f_screenshake_intensity_mod_get();
	elseif ( r_mod < 0.0 ) then
		r_mod = r_mod_stored;
	end
	
	// default time
	if ( r_time < 0.0 ) then
		r_time = 0.5;
	end
	
	// kill the old thread
	kill_thread( l_thread );
	
	// transition mod
	l_thread = thread( f_screenshake_intensity_mod_set(r_mod, r_time) );
	
end

// === xxx::: xxx
script static void f_mission_shakes_delay_set( real r_min, real r_max )
	//dprint( "::: f_mission_shakes_delay_set :::" );
	R_mission_shakes_delay_min = r_min;
	R_mission_shakes_delay_max = r_max;
end

// === xxx::: xxx
script static void f_mission_shakes_intensity_set( real r_min, real r_max )
	//dprint( "::: f_mission_shakes_intensity_set :::" );
	R_mission_shakes_intensity_min = r_min;
	R_mission_shakes_intensity_max = r_max;
end

// === xxx::: xxx
script static short f_mission_shakes_play( short s_id, short s_id_last, real r_intensity_min, real r_intensity_max, real r_intensity, real r_attack, real r_duration, real r_decay, sound snd_sound )

	if ( (r_intensity_min <= r_intensity) and (r_intensity <= r_intensity_max) and (s_id != s_id_last) ) then
		//dprint( "::: f_mission_shakes_play: PLAYED :::" );
		//inspect( r_intensity );
		f_screenshake_event( r_intensity, r_attack, r_duration, r_decay, snd_sound );
	else
		//dprint( "::: f_mission_shakes_play: INVALID :::" );
		//inspect( s_id );
		//inspect( r_intensity_min );
		//inspect( r_intensity );
		s_id = 0;
	end

	// return
	s_id;
end