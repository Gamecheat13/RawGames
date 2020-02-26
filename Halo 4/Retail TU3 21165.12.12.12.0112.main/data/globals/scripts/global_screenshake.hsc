// =================================================================================================
// =================================================================================================
// =================================================================================================
// SCREEN SHAKES
// =================================================================================================
// =================================================================================================
// =================================================================================================

// XXX: MOVE TO GLOBAL
script static boolean sleep_until_volume_players_change( trigger_volume tv_volume, long l_time_out, short s_rate )
local boolean b_p0 = volume_test_object(tv_volume, player0);
local boolean b_p1 = volume_test_object(tv_volume, player1);
local boolean b_p2 = volume_test_object(tv_volume, player2);
local boolean b_p3 = volume_test_object(tv_volume, player3);

	sleep_until( ((volume_test_object(tv_volume, player0) != b_p0) or (volume_test_object(tv_volume, player1) != b_p1) or (volume_test_object(tv_volume, player2) != b_p2) or (volume_test_object(tv_volume, player3) != b_p3)) or ((l_time_out != -1) and (l_time_out < game_tick_get())), s_rate );

end

script static real DEF_R_SCREENSHAKE_INTENSITY_NONE()
	0.0;
end

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: EVENTS
// -------------------------------------------------------------------------------------------------

// XXX add event triggers with use cnts

// defines
script static real DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_LOW()
	0.375;
end
script static real DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW()
	0.50;
end
script static real DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED()
	0.625;
end
script static real DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH()
	0.75;
end
script static real DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH()
	1.00;
end

// functions
// === f_screenshake_event: Screenshake for a fixed time
//			r_intensity = Intensity of the screenshake
//			r_attack = Durration in seconds to scale to r_intensity
//				[r_attack < 0] = Time will be subtracted from r_duration value
//												 Sound tag will start playing in attack time
//				[r_attack >= 0] = Pad time before screenshake durrection & sound tag starts
//			r_duration = Durration of the screenshake (not including r_attack & r_decay)
//				[r_duration < 0] = Durration time will be pulled from the sound tag
//			r_decay = Durration in seconds to scale from r_intensity
//				[r_decay < 0] = Time will be subtracted from r_duration value
//			snd_sound = sound tag to play
//				[snd_sound = NONE] = no sound
//	RETURNS:  void; when the screenshake is complete
//	EXAMPLE:
//		f_screenshake_event( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), -0.5, -1, -0.5, 'insert sound tag name here' )
//			This will start the screenshake sound tag sound and scale to medium intensity over 0.5s, sustain the medium indensity screenshake for the time of the sound file, and scale intensity back down in the last 0.5s of the sound
script static void f_screenshake_event( real r_intensity, real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( r_intensity, r_attack, r_duration, r_decay, snd_sound );
end
// === f_screenshake_event_very_low: f_screenshake_event with intensity: DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_LOW()
//	SEE: f_screenshake_event
script static void f_screenshake_event_very_low( real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_LOW(), r_attack, r_duration, r_decay, snd_sound );
end
// === f_screenshake_event_low: f_screenshake_event with intensity: DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW()
//	SEE: f_screenshake_event
script static void f_screenshake_event_low( real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), r_attack, r_duration, r_decay, snd_sound );
end
// === f_screenshake_event_med: f_screenshake_event with intensity: DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED()
//	SEE: f_screenshake_event
script static void f_screenshake_event_med( real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED(), r_attack, r_duration, r_decay, snd_sound );
end
// === f_screenshake_event_high: f_screenshake_event with intensity: DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH()
//	SEE: f_screenshake_event
script static void f_screenshake_event_high( real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH(), r_attack, r_duration, r_decay, snd_sound );
end
// === f_screenshake_event_very_high: f_screenshake_event with intensity: DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH()
//	SEE: f_screenshake_event
script static void f_screenshake_event_very_high( real r_attack, real r_duration, real r_decay, sound snd_sound )
	sys_screenshake_global_add( DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), r_attack, r_duration, r_decay, snd_sound );
end


// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: EVENT: TRIGGER
// -------------------------------------------------------------------------------------------------
// functions
// xxx

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_event_volume( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out, real r_attack, real r_duration, real r_decay, sound snd_sound )
// XXX TEMP HACK TO GET SOMETHING WORKING
	if ( volume_test_players(tv_volume) ) then
		dprint( "f_screenshake_event_volume: IN!!!!!!!!!!!!!!!!!!!!!!!!!" );
		f_screenshake_event( r_intensity_in, r_attack, r_duration, r_decay, snd_sound );
	else
		dprint( "f_screenshake_event_volume: OUT!!!!!!!!!!!!!!!!!!!!!!!!!" );
		f_screenshake_event( r_intensity_out, r_attack, r_duration, r_decay, snd_sound );
	end
/*
	sys_screenshake_global_add( r_intensity, r_attack, r_duration, r_decay, snd_sound );
	// increment the screenshake counter
	sys_screenshake_general_increment( 1 );

	if ( snd_sound != NONE ) then
		sound_impulse_start( snd_sound, NONE, 1 );
		if ( r_duration < 0 ) then
			r_duration = frames_to_seconds( sound_impulse_time(snd_sound) ) - r_attack - r_decay;
		end
	end

	// attack globally
	sys_screenshake_global_scale( 0.0, r_intensity, -1, game_tick_get() + seconds_to_frames(r_attack), NONE );
	
	// screenshake vs. trigger
	sys_screenshake_trigger_sustain( tv_volume, r_intensity_in, r_intensity_out, game_tick_get() + seconds_to_frames(r_duration), NONE );

	// reset the plyaer intensity
	thread( sys_screenshake_player_all_intensity_reset() );

	sys_screenshake_global_scale( r_intensity, 0.0, -1, game_tick_get() + seconds_to_frames(r_decay), NONE );
	
	// decrement the system screenshake counter
	sys_screenshake_general_increment( -1 );
*/
end
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_event_volume_mod( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out_mod, real r_attack, real r_duration, real r_decay, sound snd_sound )
// XXX TEMP HACK TO GET SOMETHING WORKING
	f_screenshake_event_volume( tv_volume, r_intensity_in, r_intensity_in * r_intensity_out_mod, r_attack, r_duration, r_decay, snd_sound );
end
// xxx
/*
script static void sys_screenshake_trigger_sustain( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out, long l_time_end, sound snd_sound )

	if ( snd_sound != NONE ) then
		sound_impulse_start( snd_sound, NONE, 1 );
		if ( l_time_end < 0 ) then
			l_time_end = game_tick_get() + sound_impulse_time( snd_sound );
		end
	end

	repeat
		// set the intensity vs. trigger for the players	
		sys_screenshake_player_all_intensity_trigger_set( tv_volume, r_intensity_in, r_intensity_out );
	
		// wait until player vs. trigger status changes
		volume_test_players_change( tv_volume, volume_test_object(tv_volume, player0), volume_test_object(tv_volume, player1), volume_test_object(tv_volume, player2), volume_test_object(tv_volume, player3), l_time_end );
	until ( (l_time_end != -1) and (l_time_end < game_tick_get()), 1 );

end
*/

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: EVENT: OBJECT
// -------------------------------------------------------------------------------------------------
// functions

// XXX TODO

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: EVENT: POINT
// -------------------------------------------------------------------------------------------------
// functions

// XXX TODO
// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: AMBIENT
// -------------------------------------------------------------------------------------------------
// defines
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW()
	0.25;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW()
	0.33;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW_MED()
	0.39;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED()
	0.45;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED_HIGH()
	0.5;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_HIGH()
	0.55;
end
script static real DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_HIGH()
	0.675;
end

// functions
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static long f_screenshake_ambient_add( real r_chance, real r_intensity, real r_attack, real r_duration, real r_decay, sound snd_sound, real r_delay_timer, short s_delay_rounds, string str_notify )

	// increment the count
	S_screenshake_ambient_cnt = S_screenshake_ambient_cnt + 1;
	
	// start the ambient thread and return the thread ID
	thread( sys_screenshake_ambient(r_chance, r_intensity, r_attack, r_duration, r_decay, snd_sound, r_delay_timer, s_delay_rounds, str_notify) );
	
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static long f_screenshake_ambient_remove( long l_ID )
static long l_return = 0;

	l_return = l_ID;
	if ( (S_screenshake_ambient_cnt > 0) and (l_ID != 0) ) then
		sleep_until( not B_screenshake_ambient_playing, 1 );
		kill_thread( l_ID );
		S_screenshake_ambient_cnt = S_screenshake_ambient_cnt - 1;
		l_return = 0;
	end
	
	// return
	l_return;

end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static boolean f_B_screenshake_ambient_playing()
	B_screenshake_ambient_playing;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_ambient_pause( boolean b_pause, boolean b_reset, real r_timer_pad )
	if ( b_reset ) then
		f_screenshake_ambient_timer_reset( r_timer_pad );
	elseif ( r_timer_pad >= 0 ) then
		f_screenshake_ambient_timer_set( r_timer_pad );
	end
	B_screenshake_ambient_paused = b_pause;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static boolean f_B_screenshake_ambient_paused()
	B_screenshake_ambient_paused;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static short f_B_screenshake_ambient_cnt()
	S_screenshake_ambient_cnt;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_ambient_delay_set( real r_delay_min, real r_delay_max )
	S_screenshake_ambient_timer_min = r_delay_min;
	S_screenshake_ambient_timer_max = r_delay_max;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static real f_screenshake_ambient_intensity_mod_set( real r_mod )
	if ( R_screenshake_ambient_intensity_mod != r_mod ) then
		R_screenshake_ambient_intensity_mod = r_mod;
	end
	// return the current mod
	R_screenshake_ambient_intensity_mod;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_ambient_timer_set( real r_time )
	L_screenshake_ambient_timer = game_tick_get() + seconds_to_frames( r_time );
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_ambient_timer_reset( real r_pad )
	f_screenshake_ambient_timer_set( sys_R_screenshake_ambient_timer_roll() + r_pad );
end





// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: RUMBLE
// -------------------------------------------------------------------------------------------------

// functions
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static long f_screenshake_rumble_global_add( real r_intensity, real r_attack, looping_sound snd_sound )
	
	// increment the rumble count
	sys_screenshake_rumble_increment( 1 );
	
	// start the sound
	sys_screenshake_rumble_sound( snd_sound, r_intensity, NONE );

	// attack
	sys_screenshake_rumble_global_scale( 0.0, r_intensity, -1, game_tick_get() + seconds_to_frames(r_attack) );

	// start the general rumble thread
	thread( sys_screenshake_rumble_global_sustain(r_intensity, snd_sound) );

end
script static long f_screenshake_rumble_global_add_very_low( real r_attack, looping_sound snd_sound )
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_VERY_LOW(), r_attack, snd_sound );
end
script static long f_screenshake_rumble_global_add_low( real r_attack, looping_sound snd_sound )
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_LOW(), r_attack, snd_sound );
end
script static long f_screenshake_rumble_global_add_med( real r_attack, looping_sound snd_sound )
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_MED(), r_attack, snd_sound );
end
script static long f_screenshake_rumble_global_add_high( real r_attack, looping_sound snd_sound )
	f_screenshake_rumble_global_add( DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_HIGH(), r_attack, snd_sound );
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static long f_screenshake_rumble_global_remove( long l_ID, real r_intensity, real r_decay )

	if ( l_ID != 0 ) then

		if ( IsThreadValid(l_ID) ) then
			// kill the rumble thread
			kill_thread( l_ID );
	
			// scale the rumble back down
			sys_screenshake_rumble_global_scale( r_intensity, 0.0, -1, game_tick_get() + seconds_to_frames(r_decay) );
			
			// decrement the rumble counter
			sys_screenshake_rumble_increment( -1 );
			
			// if rumble is all done
			if ( S_screenshake_rumble_cnt > 0 ) then
				sleep_until( B_screenshake_general_applied, 1 );
				sys_screenshake_rumble_global_intensity_set( 0.0 );
			else
				// force the rumble system to reset intensity
				sys_screenshake_rumble_global_intensity_set( 0.0 );
				
				sys_screenshake_rumble_sound( NONE, -1, NONE );
			end
		end

		// set the id to invalid because it passed all the checks		
		l_ID = 0;
	end

	l_ID;

end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static boolean f_B_screenshake_rumble_active()
	S_screenshake_rumble_cnt > 0;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static real f_screenshake_rumble_intensity_mod_set( real r_mod )

	if ( R_screenshake_rumble_intensity_mod != r_mod ) then
		R_screenshake_rumble_intensity_mod = r_mod;
		
		sys_screenshake_rumble_global_intensity_set( 0.0 );
	end
	// return the current mod
	R_screenshake_rumble_intensity_mod;
	
end



// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: RUMBLE: TRIGGER
// -------------------------------------------------------------------------------------------------
// variables
/*
global short 		S_screenshake_rumble_volume_cnt													= 0;
global short 		S_screenshake_rumble_volume_playing_cnt									= 0;
global long 		S_screenshake_rumble_volume_remove											= 0;
*/

// functions
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void

// XXX also rumble triggers with use cnts that you walk into and it triggers

/*
static long l_screenshake_rumble_volume_remove = 0;

script static long f_screenshake_rumble_volume_add( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out, real r_attack, real r_duration, real r_decay, sound snd_sound )
// XXX TEMP HACK TO GET SOMETHING WORKING
xxx

static long l_p0 = 0;
static long l_p1 = 0;
static long l_p2 = 0;
static long l_p3 = 0;
static long l_ID = 0;

	S_screenshake_rumble_volume_cnt = S_screenshake_rumble_volume_cnt + 1;

	// create the index for the trigger
	l_ID  = l_ID + 1;
	l_p0 = thread( sys_screenshake_player_p0_rumble_volume(l_ID, tv_volume, r_intensity, s_use_cnt, snd_sound) );
	l_p1 = thread( sys_screenshake_player_p1_rumble_volume(l_ID, tv_volume, r_intensity, s_use_cnt, snd_sound) );
	l_p2 = thread( sys_screenshake_player_p2_rumble_volume(l_ID, tv_volume, r_intensity, s_use_cnt, snd_sound) );
	l_p3 = thread( sys_screenshake_player_p3_rumble_volume(l_ID, tv_volume, r_intensity, s_use_cnt, snd_sound) );

	// setup the shutdown manager
	thread( sys_screenshake_rumble_volume_manager(l_ID, l_p0, l_p1, l_p2, l_p3) );
	
	// return the ID
	l_ID;
end
*/
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
/*
script static long f_screenshake_rumble_volume_mod_add( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out_mod, real r_attack, real r_duration, real r_decay, sound snd_sound )
	f_screenshake_rumble_volume_add( tv_volume, r_intensity_in, r_intensity_in * r_intensity_out_mod, r_attack, r_duration, r_decay, s_use_cnt, snd_sound );
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static boolean f_screenshake_rumble_volume_remove( long l_ID )

	sleep_until( not IsThreadValid(l_screenshake_rumble_volume_remove), 1 );
	l_screenshake_rumble_volume_remove = l_ID;
	sleep_until( not IsThreadValid(l_screenshake_rumble_volume_remove), 1 );

static long l_timeout_timer = 0;

	if ( l_ID != 0 ) then
		l_timeout_timer = game_tick_get() + seconds_to_frames( r_timeout );

		// wait for other instances to shut down
		sleep_until( S_screenshake_rumble_volume_remove == 0, 1 );

		S_screenshake_rumble_volume_remove = l_ID;
		sleep( 1 );
		
		sleep_until( (S_screenshake_rumble_volume_remove != l_ID) or (r_timeout < game_tick_get()), 1 );

	end
	sys_screenshake_player0_intensity_set( r_intensity_l, r_intensity_r );
	
	// return if it was destroyed
	S_screenshake_rumble_volume_remove != l_ID;

end

script static long sys_screenshake_rumble_volume_add( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out, real r_attack, real r_decay, sound snd_sound )
local long l_id = 0;
local real r_intensity;

	repeat
		if ( volume_test_players(tv_volume) ) then
			r_intensity = r_intensity_in;
		else
			r_intensity = r_intensity_out;
		end
		
		f_screenshake_rumble_global_add( r_intensity_in, r_attack, snd_sound );
	
	
	r_intensity
	until( l_screenshake_rumble_volume_remove == GetCurrentThreadId(), 1 );

	thread( f_screenshake_rumble_global_remove(l_id, r_intensity, r_decay) );

end
*/

/*
script static long sys_screenshake_rumble_volume_manager( long l_ID, long l_p0, long l_p1, long l_p2, long l_p3 )

	sleep_until( S_screenshake_rumble_volume_remove == l_ID, 1 );
	sleep_until( S_screenshake_rumble_volume_playing_cnt == 0, 1 );
	if ( l_p0 != 0 ) then
		kill_thread( l_p0 );
	end
	if ( l_p1 != 0 ) then
		kill_thread( l_p1 );
	end
	if ( l_p2 != 0 ) then
		kill_thread( l_p2 );
	end
	if ( l_p3 != 0 ) then
		kill_thread( l_p3 );
	end
	
	sys_screenshake_player_all_intensity_reset();
	
	S_screenshake_rumble_volume_cnt = S_screenshake_rumble_volume_cnt - 1;
	S_screenshake_rumble_volume_remove = 0;

end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void sys_screenshake_player_p0_rumble_volume( long l_ID, trigger_volume tv_volume, real r_intensity, short s_use_cnt, sound snd_sound )

	repeat
		// watch for the trigger even conditions
		sys_screenshake_player_any_rumble_volume_enable( player0, l_ID, tv_volume, r_intensity, snd_sound );
		// set trigger intensity
		if ( S_screenshake_rumble_volume_remove != l_ID ) then
			sys_screenshake_player0_intensity_set( r_intensity, r_intensity );

			// triggered, drop the use count
			s_use_cnt = s_use_cnt - 1;
		end
		
		// increment the playing count
		S_screenshake_rumble_volume_playing_cnt = S_screenshake_rumble_volume_playing_cnt + 1;

		// reset
		sleep_until( (not volume_test_object(tv_volume, p_player)) or (S_screenshake_rumble_volume_remove == l_ID) or (R_screenshake_intensity_p0_l < r_intensity) or (R_screenshake_intensity_p0_r < r_intensity), 1 );
		sys_screenshake_player_any_rumble_volume_reset( p_player, l_ID, tv_volume, snd_sound );
		if ( (not volume_test_object(tv_volume, p_player)) or (S_screenshake_rumble_volume_remove == l_ID) ) then
			sys_screenshake_player0_intensity_set( 0.0, 0.0 );
		end

		// decrement the playing count
		S_screenshake_rumble_volume_playing_cnt = S_screenshake_rumble_volume_playing_cnt - 1;
	
	until ( (s_use_cnt == 0) or (S_screenshake_rumble_volume_remove == l_ID), 1 );
	
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void sys_screenshake_player_any_rumble_volume_enable( player p_player, long l_ID, trigger_volume tv_volume, real r_intensity, sound snd_sound )
	
	if ( not volume_test_object(tv_volume, p_player) and (S_screenshake_rumble_volume_remove != l_ID) ) then
		sleep_until( volume_test_object(tv_volume, p_player) or (S_screenshake_rumble_volume_remove == l_ID), 1 );
		
		if ( volume_test_object(tv_volume, p_player) ) then
	
			if ( snd_sound != NONE ) then
				sound_looping_start( snd_sound, p_player, 1);
			end		
	
		end
	end

end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void sys_screenshake_player_any_rumble_volume_reset( player p_player, long l_ID, trigger_volume tv_volume, sound snd_sound )

	if ( (not volume_test_object(tv_volume, p_player)) or (S_screenshake_rumble_volume_remove == l_ID)
		sound_looping_stop( snd_sound );
	end	

end
*/


// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: RUMBLE: OBJECT
// -------------------------------------------------------------------------------------------------
// variables

// functions
// XXX


// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: RUMBLE: DEVICE
// -------------------------------------------------------------------------------------------------
// variables

// functions
// XXX



// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: GENERAL
// -------------------------------------------------------------------------------------------------
// functions
// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static boolean f_B_screenshake_global_playing()
	S_screenshake_global_cnt > 0;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static real f_R_screenshake_intensity_global_get()
	if ( S_screenshake_global_cnt > 0 ) then
		R_screenshake_global_intensity;
	else
		0.0;
	end
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_intensity_mod_set( real r_mod, real r_time )
	R_screenshake_general_mod = r_mod;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static real f_screenshake_intensity_mod_get()
	R_screenshake_general_mod;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_intensity_mod_screen_set( real r_mod, real r_time )
	R_screenshake_general_mod_screen = r_mod;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_intensity_mod_control_set( real r_mod )
	R_screenshake_general_mod_control = r_mod;
end

// === AAA: yyy
//			xxx = yyy
//				[xxx < 0] = yyy
//	RETURNS:  void
script static void f_screenshake_intensity_mod_camera_set( real r_yaw, real r_pitch, real r_roll )
	if ( r_yaw >= 0 ) then
		R_screenshake_general_mod_yaw		= r_yaw;
	end
	if ( r_pitch >= 0 ) then
		R_screenshake_general_mod_pitch	= r_pitch;
	end
	if ( r_roll >= 0 ) then
		R_screenshake_general_mod_roll	= r_roll;
	end
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM
//	WARNING: THESE SYSTEM ARE FUNCTIONS NOT INTENDED FOR USE DIRECTLY BY ANYONE BUT THE FUNCTIONS ABOVE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM: GLOBAL
// -------------------------------------------------------------------------------------------------
// variables
global short 		S_screenshake_global_cnt													= 0;
global real 		R_screenshake_global_intensity										= 0.0;

// functions
// xxx
script static void sys_screenshake_global_add( real r_intensity, real r_attack, real r_duration, real r_decay, sound snd_sound )
	
	// increment the screenshake counter
	sys_screenshake_general_increment( 1 );

	// attack scale
	if ( r_attack < 0 ) then
		sys_screenshake_global_scale( 0.0, r_intensity, -1, game_tick_get() + seconds_to_frames(-r_attack), snd_sound );
		snd_sound = NONE;
	else
		sys_screenshake_global_scale( 0.0, r_intensity, -1, game_tick_get() + seconds_to_frames(abs_r(r_attack)), NONE );
	end

	// get sustain time
	if ( snd_sound != NONE ) then
		sound_impulse_start( snd_sound, NONE, 1 );
		if ( r_duration < 0 ) then
			r_duration = frames_to_seconds( sound_impulse_time(snd_sound) );
		end
	end
	
	// remove attack and decay times if necessary
	if ( r_attack < 0 ) then
		r_duration = r_duration + seconds_to_frames(r_attack);
	end
	if ( r_decay < 0 ) then
		r_duration = r_duration + seconds_to_frames(r_decay);
	end
	
	// play sustain shake
	sys_screenshake_global_sustain( r_intensity, game_tick_get() + seconds_to_frames(r_duration), snd_sound );

	// decay scale
	sys_screenshake_global_scale( r_intensity, 0.0, -1, game_tick_get() + seconds_to_frames(abs_r(r_decay)), NONE );

	// decrement the system screenshake counter
	sys_screenshake_general_increment( -1 );
	
end

// xxx
script static void sys_screenshake_global_scale( real r_intensity_start, real r_intensity_end, long l_time_start, long l_time_end, sound snd_sound )

	if ( l_time_start < 0 ) then
		l_time_start = game_tick_get();
	end

	if ( snd_sound != NONE ) then
		sound_impulse_start( snd_sound, NONE, 1 );
		if ( l_time_end < 0 ) then
			l_time_end = l_time_start + sound_impulse_time( snd_sound );
		end
	end

	if ( abs_l(l_time_end - l_time_start) > 0 ) then
		repeat
			// set gravity to the current % of time progress
			sys_screenshake_global_intensity_set( r_intensity_start + ((r_intensity_end-r_intensity_start) * ((game_tick_get()-l_time_start)/(l_time_end-l_time_start))), game_tick_get() + 1 );
		until ( game_tick_get() >= l_time_end, 1 );
	end
	sys_screenshake_global_intensity_set( r_intensity_end, 0 );

end

// xxx
script static void sys_screenshake_global_sustain( real r_intensity, long l_time_end, sound snd_sound )

	if ( snd_sound != NONE ) then
		sound_impulse_start( snd_sound, NONE, 1 );
		if ( l_time_end < 0 ) then
			l_time_end = game_tick_get() + sound_impulse_time( snd_sound );
		end
	end

	repeat
		sys_screenshake_global_intensity_set( r_intensity, l_time_end );
		sleep_until( (R_screenshake_global_intensity < r_intensity) or ((l_time_end != -1) and (l_time_end < game_tick_get())), 1 );
	until ( (l_time_end != -1) and (l_time_end < game_tick_get()), 1 );

end

// xxx
script static boolean sys_screenshake_global_intensity_set( real r_intensity, real r_time_end )
static boolean b_return = FALSE;
// XXX use time end to blend the transition 
// XXX also needs to take in account

	b_return = FALSE;
	if ( (R_screenshake_global_intensity != r_intensity) and ((B_screenshake_general_applied) or (r_intensity > R_screenshake_global_intensity))) then
		R_screenshake_global_intensity = r_intensity;
		B_screenshake_general_applied = FALSE;
		b_return = TRUE;
	end
	
	// return
	b_return;
	
end

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM: AMBIENT
// -------------------------------------------------------------------------------------------------
// variables
global short 		S_screenshake_ambient_cnt												= 0;

global long			L_screenshake_ambient_timer											= 0;
global real			S_screenshake_ambient_timer_min									= 0.0;
global real			S_screenshake_ambient_timer_max									= 0.0;
global boolean	B_screenshake_ambient_playing										= FALSE;
global boolean	B_screenshake_ambient_paused										= FALSE;

global real 		R_screenshake_ambient_intensity_mod							= 1.0;

// functions
// xxx
script static real sys_R_screenshake_ambient_timer_roll()
	real_random_range(S_screenshake_ambient_timer_min,S_screenshake_ambient_timer_max);
end

// xxx
script static void sys_screenshake_ambient( real r_chance, real r_intensity, real r_attack, real r_duration, real r_decay, sound snd_sound, real r_delay_timer, short s_delay_rounds, string str_notify )
	
	repeat
		sleep_until( (L_screenshake_ambient_timer <= game_tick_get()) and (not f_B_screenshake_ambient_paused()) and (not B_screenshake_ambient_playing), 1 );
		
		if ( real_random_range(0.0,100.0) <= (r_chance * 100.0) ) then
			// set playing variable
			B_screenshake_ambient_playing = TRUE;
			dprint( str_notify );
	
			// play screenshake
			sys_screenshake_global_add( r_intensity*R_screenshake_ambient_intensity_mod, r_attack, r_duration, r_decay, snd_sound );
			
			// reset the timer
			f_screenshake_ambient_timer_reset( 0.0 );
	
			// cancel playing variable
			B_screenshake_ambient_playing = FALSE;
			
			// delay ambient for rounds and time
			// XXX needs to be fixed
			sys_screenshake_ambient_delay( seconds_to_frames(r_delay_timer), s_delay_rounds );
		end
		
	until ( FALSE, 1 );

end

// xxx
script static void sys_screenshake_ambient_delay( long l_delay_timer, short s_delay_rounds )

	// make sure the delay rounds happen first
	if ( s_delay_rounds > 0 ) then
		repeat
			sleep_until( B_screenshake_ambient_playing, 1 );
			sleep_until( not B_screenshake_ambient_playing, 1 );
			//inspect( s_delay_rounds );
			s_delay_rounds = s_delay_rounds - 1;
		until( s_delay_rounds <= 0, 1 );
	end

	// make sure the timer has expired
	sleep_until( l_delay_timer <= game_tick_get(), 1 );

end



// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM: RUMBLE
// -------------------------------------------------------------------------------------------------
// defines
script static real DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_VERY_LOW()
	0.175;
end
script static real DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_LOW()
	0.25;
end
script static real DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_MED()
	0.35;
end
script static real DEF_R_SCREENSHAKE_RUMBLE_INTENSITY_HIGH()
	0.45;
end

// variables
global short					S_screenshake_rumble_cnt												= 0;

global real 					R_screenshake_rumble_intensity_mod							= 1.0;

global looping_sound	R_screenshake_rumble_snd												= NONE;				


// functions
// xxx
script static void sys_screenshake_rumble_global_sustain( real r_intensity, looping_sound snd_sound )
	sys_screenshake_global_sustain( r_intensity * R_screenshake_rumble_intensity_mod, -1, NONE );
end

// xxx
script static void sys_screenshake_rumble_global_scale( real r_intensity_start, real r_intensity_end, long l_time_start, long l_time_end )
	if ( r_intensity_start > 0 ) then
		r_intensity_start = r_intensity_start * R_screenshake_rumble_intensity_mod;
	end
	if ( r_intensity_end > 0 ) then
		r_intensity_end = r_intensity_end * R_screenshake_rumble_intensity_mod;
	end

	sys_screenshake_global_scale( r_intensity_start, r_intensity_end, l_time_start, l_time_end, NONE );
end

// xxx
script static void sys_screenshake_rumble_global_intensity_set( real r_intensity )
	sys_screenshake_global_intensity_set(r_intensity * R_screenshake_rumble_intensity_mod, -1);
end

// xxx
script static void sys_screenshake_rumble_increment( short s_increment )

	S_screenshake_rumble_cnt = S_screenshake_rumble_cnt + s_increment;
	sys_screenshake_general_increment( s_increment );
	
	if ( S_screenshake_rumble_cnt < 0 ) then
		S_screenshake_rumble_cnt = 0;
	end

end

script static void sys_screenshake_rumble_sound( looping_sound snd_sound, real r_intensity, object obj_object )
static real r_intensity_snd = 0.0;

// XXX work out real logic for how it would work shutting down the sound on an object
	if ( ((snd_sound != R_screenshake_rumble_snd) and ((r_intensity >= r_intensity_snd) or ((r_intensity < 0)))) ) then
		// start the new sound
		if ( snd_sound != NONE ) then
			sound_looping_start( snd_sound, obj_object, 1);
		end

		// kill the old sound
		if ( R_screenshake_rumble_snd != NONE ) then
			sound_looping_stop( R_screenshake_rumble_snd );
		end
	
		// store the new sound
		R_screenshake_rumble_snd = snd_sound;
		
		// store the sound intensity
		r_intensity_snd = r_intensity;
	end

end



// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM: GENERAL
// -------------------------------------------------------------------------------------------------
// defines
script static real DEF_R_SCREENSHAKE_GENERAL_MOD_YAW_DEFAULT()
	3.0;
end
script static real DEF_R_SCREENSHAKE_GENERAL_MOD_PITCH_DEFAULT()
	3.0;
end
script static real DEF_R_SCREENSHAKE_GENERAL_MOD_ROLL_DEFAULT()
	2.0;
end

// variables
global boolean 	B_screenshake_general_applied											= FALSE;

global real 		R_screenshake_general_mod													= 1.0;
global real 		R_screenshake_general_mod_screen									= 1.0;
global real 		R_screenshake_general_mod_control									= 1.0;
global real 		R_screenshake_general_mod_yaw											= DEF_R_SCREENSHAKE_GENERAL_MOD_YAW_DEFAULT();
global real 		R_screenshake_general_mod_pitch										= DEF_R_SCREENSHAKE_GENERAL_MOD_PITCH_DEFAULT();
global real 		R_screenshake_general_mod_roll										= DEF_R_SCREENSHAKE_GENERAL_MOD_ROLL_DEFAULT();

// functions
// xxx
script static void sys_screenshake_general_increment( short l_increment )
static long l_thread = 0;

	S_screenshake_global_cnt = S_screenshake_global_cnt + l_increment;

	if ( (f_B_screenshake_global_playing()) and (l_thread == 0) ) then
		l_thread = thread( sys_screenshake_general_thread() );
	end
	
	if ( not f_B_screenshake_global_playing() ) then
		// run cleanup to make sure the screenshakes are reduced back to 0
		sys_screenshake_player_all_apply( 0.0 );
	end	
	
	if ( (not f_B_screenshake_global_playing()) and (l_thread != 0) ) then
		kill_thread( l_thread );
		l_thread = 0;
		S_screenshake_global_cnt = 0;
	end

end

// xxx
script static void sys_screenshake_general_thread()

	repeat
		// wait for the screenshake intensity to not be applied	
		sleep_until( not B_screenshake_general_applied, 1 );
		
		// sleep to give all the other threads a chance to change the mod
		sleep( 1 );
	
		// apply the screenshake intensity to the players
		sys_screenshake_player_all_apply( R_screenshake_global_intensity );
		
		B_screenshake_general_applied = TRUE;
	until( S_screenshake_global_cnt <= 0, 1 );
	
end

// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: SYSTEM: PLAYERS
// -------------------------------------------------------------------------------------------------
// variables
global real R_screenshake_intensity_p0_l											= 0.0;
global real R_screenshake_intensity_p0_r											= 0.0;

global real R_screenshake_intensity_p1_l											= 0.0;
global real R_screenshake_intensity_p1_r											= 0.0;

global real R_screenshake_intensity_p2_l											= 0.0;
global real R_screenshake_intensity_p2_r											= 0.0;

global real R_screenshake_intensity_p3_l											= 0.0;
global real R_screenshake_intensity_p3_r											= 0.0;

// functions

// xxx
script static void sys_screenshake_player_all_intensity_reset()
	sys_screenshake_player_all_intensity_set( 0.0, 0.0 );
end

// xxx
script static void sys_screenshake_player_all_intensity_set( real r_intensity_l, real r_intensity_r )
	sys_screenshake_player0_intensity_set( r_intensity_l, r_intensity_r );
	sys_screenshake_player1_intensity_set( r_intensity_l, r_intensity_r );
	sys_screenshake_player2_intensity_set( r_intensity_l, r_intensity_r );
	sys_screenshake_player3_intensity_set( r_intensity_l, r_intensity_r );
end

// xxx
script static void sys_screenshake_player0_intensity_set( real r_intensity_l, real r_intensity_r )
static boolean b_was_applied = B_screenshake_general_applied;

	b_was_applied = B_screenshake_general_applied;
	
	if ( (R_screenshake_intensity_p0_l != r_intensity_l) and ((b_was_applied) or (r_intensity_l > R_screenshake_intensity_p0_l)) ) then
		R_screenshake_intensity_p0_l = r_intensity_l;
		B_screenshake_general_applied = FALSE;
	end
	
	if ( (R_screenshake_intensity_p0_r != r_intensity_r) and ((b_was_applied) or (r_intensity_r > R_screenshake_intensity_p0_r)) ) then
		R_screenshake_intensity_p0_r = r_intensity_r;
		B_screenshake_general_applied = FALSE;
	end
	
end

// xxx
script static void sys_screenshake_player1_intensity_set( real r_intensity_l, real r_intensity_r )
static boolean b_was_applied = B_screenshake_general_applied;

	b_was_applied = B_screenshake_general_applied;
	
	if ( (R_screenshake_intensity_p1_l != r_intensity_l) and ((b_was_applied) or (r_intensity_l > R_screenshake_intensity_p1_l)) ) then
		R_screenshake_intensity_p1_l = r_intensity_l;
		B_screenshake_general_applied = FALSE;
	end
	
	if ( (R_screenshake_intensity_p1_r != r_intensity_r) and ((b_was_applied) or (r_intensity_r > R_screenshake_intensity_p1_r)) ) then
		R_screenshake_intensity_p1_r = r_intensity_r;
		B_screenshake_general_applied = FALSE;
	end
	
end

// xxx
script static void sys_screenshake_player2_intensity_set( real r_intensity_l, real r_intensity_r )
static boolean b_was_applied = B_screenshake_general_applied;

	b_was_applied = B_screenshake_general_applied;
	
	if ( (R_screenshake_intensity_p2_l != r_intensity_l) and ((b_was_applied) or (r_intensity_l > R_screenshake_intensity_p2_l)) ) then
		R_screenshake_intensity_p2_l = r_intensity_l;
		B_screenshake_general_applied = FALSE;
	end
	
	if ( (R_screenshake_intensity_p2_r != r_intensity_r) and ((b_was_applied) or (r_intensity_r > R_screenshake_intensity_p2_r)) ) then
		R_screenshake_intensity_p2_r = r_intensity_r;
		B_screenshake_general_applied = FALSE;
	end
	
end

// xxx
script static void sys_screenshake_player3_intensity_set( real r_intensity_l, real r_intensity_r )
static boolean b_was_applied = B_screenshake_general_applied;

	b_was_applied = B_screenshake_general_applied;
	
	if ( (R_screenshake_intensity_p3_l != r_intensity_l) and ((b_was_applied) or (r_intensity_l > R_screenshake_intensity_p3_l)) ) then
		R_screenshake_intensity_p3_l = r_intensity_l;
		B_screenshake_general_applied = FALSE;
	end
	
	if ( (R_screenshake_intensity_p3_r != r_intensity_r) and ((b_was_applied) or (r_intensity_r > R_screenshake_intensity_p3_r)) ) then
		R_screenshake_intensity_p3_r = r_intensity_r;
		B_screenshake_general_applied = FALSE;
	end
	
end

// xxx
script static void sys_screenshake_player_all_intensity_trigger_set( trigger_volume tv_volume, real r_intensity_in, real r_intensity_out )
static real r_trigger_intensity = 0.0;

	r_trigger_intensity = if_else_r( volume_test_object(tv_volume, player0), r_intensity_in, r_intensity_out );
	sys_screenshake_player0_intensity_set( r_trigger_intensity, r_trigger_intensity );
	
	r_trigger_intensity = if_else_r( volume_test_object(tv_volume, player1), r_intensity_in, r_intensity_out );
	sys_screenshake_player1_intensity_set( r_trigger_intensity, r_trigger_intensity );
	
	r_trigger_intensity = if_else_r( volume_test_object(tv_volume, player2), r_intensity_in, r_intensity_out );
	sys_screenshake_player2_intensity_set( r_trigger_intensity, r_trigger_intensity );
	
	r_trigger_intensity = if_else_r( volume_test_object(tv_volume, player3), r_intensity_in, r_intensity_out );
	sys_screenshake_player3_intensity_set( r_trigger_intensity, r_trigger_intensity );
	
end

// xxx
script static void sys_screenshake_player_all_apply( real r_general_intensity )

	sys_screenshake_player_any_apply( player0, r_general_intensity, R_screenshake_intensity_p0_l, R_screenshake_intensity_p0_r );
	sys_screenshake_player_any_apply( player1, r_general_intensity, R_screenshake_intensity_p1_l, R_screenshake_intensity_p1_r );
	sys_screenshake_player_any_apply( player2, r_general_intensity, R_screenshake_intensity_p2_l, R_screenshake_intensity_p2_r );
	sys_screenshake_player_any_apply( player3, r_general_intensity, R_screenshake_intensity_p3_l, R_screenshake_intensity_p3_r );

end

// xxx
script static void sys_screenshake_player0_apply( real r_general_intensity )
	sys_screenshake_player_any_apply( player0, r_general_intensity, R_screenshake_intensity_p0_l, R_screenshake_intensity_p0_r );
end

// xxx
script static void sys_screenshake_player1_apply( real r_general_intensity )
	sys_screenshake_player_any_apply( player1, r_general_intensity, R_screenshake_intensity_p1_l, R_screenshake_intensity_p1_r );
end

// xxx
script static void sys_screenshake_player2_apply( real r_general_intensity )
	sys_screenshake_player_any_apply( player2, r_general_intensity, R_screenshake_intensity_p2_l, R_screenshake_intensity_p2_r );
end

// xxx
script static void sys_screenshake_player3_apply( real r_general_intensity )
	sys_screenshake_player_any_apply( player3, r_general_intensity, R_screenshake_intensity_p3_l, R_screenshake_intensity_p3_r );
end

// xxx
script static void sys_screenshake_player_any_apply( player p_player, real r_general_intensity, real r_intensity_l, real r_intensity_r )
static real r_intensity_max = 0.0;

	if ( object_get_health(p_player) > 0 ) then
	
		// apply global intensity
		r_general_intensity = r_general_intensity * R_screenshake_general_mod;
		r_intensity_l = greater_r( r_intensity_l * R_screenshake_general_mod, r_general_intensity );
		r_intensity_r = greater_r( r_intensity_r * R_screenshake_general_mod, r_general_intensity );
	
		// get the max intensity
		r_intensity_max = greater_r( r_intensity_l, r_intensity_r );

		if ( r_intensity_max > 0 ) then
			// set the rotations maxiumum
			player_effect_set_max_rotation_for_player( p_player, r_intensity_max*R_screenshake_general_mod_yaw*R_screenshake_general_mod_screen, r_intensity_max*R_screenshake_general_mod_pitch*R_screenshake_general_mod_screen, r_intensity_max*R_screenshake_general_mod_roll*R_screenshake_general_mod_screen );
			player_effect_start_for_player( p_player, r_intensity_max, 0 );
			player_effect_set_max_rumble_for_player( p_player, r_intensity_l*R_screenshake_general_mod_control, r_intensity_r*R_screenshake_general_mod_control );
		else
			// shut down the shake
			player_effect_stop_for_player( p_player, 0 );
			player_effect_set_max_rumble_for_player( p_player, 0, 0 );
		end
	end

end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SCREEN SHAKES: TEST
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
/*
script static void test_screenshake_event()

	thread( f_screenshake_event_med( 1.0, 10.0, 10.0, NONE ) );
	sleep_s( 2.5 );
	thread( f_screenshake_event_low( 1.0, 10.0, 10.0, NONE ) );
	sleep_s( 2.5 );
	thread( f_screenshake_event_very_high( 1.0, 10.0, 10.0, NONE ) );
	sleep_s( 10 );
	f_screenshake_event_med( 1.0, 10.0, 10.0, NONE  );

end

script static void test_screenshake_rumble()
static long l_rumble_id_l = 0;
static long l_rumble_id_m = 0;
static long l_rumble_id_h = 0;

	dprint( "test_screenshake_event: A" );
	l_rumble_id_l = f_screenshake_rumble_global_add_low( 1.0, NONE );
	sleep_s( 3.333 );
	dprint( "test_screenshake_event: B" );
	l_rumble_id_m = f_screenshake_rumble_global_add_med( 1.0, NONE );
	sleep_s( 3.333 );
	dprint( "test_screenshake_event: C" );
	l_rumble_id_m = f_screenshake_rumble_global_remove( l_rumble_id_m, -1, 1.0 );
	sleep_s( 3.333 );
	dprint( "test_screenshake_event: D" );
	l_rumble_id_h = f_screenshake_rumble_global_add_high( 1.0, NONE );
	sleep_s( 3.333 );
	dprint( "test_screenshake_event: E" );
	l_rumble_id_l = f_screenshake_rumble_global_remove( l_rumble_id_l, -1, 1.0 );
	sleep_s( 3.333 );
	dprint( "test_screenshake_event: F" );
	l_rumble_id_h = f_screenshake_rumble_global_remove( l_rumble_id_h, -1, 1.0 );
	dprint( "test_screenshake_event: G" );
	inspect( l_rumble_id_l );
	inspect( l_rumble_id_m );
	inspect( l_rumble_id_h );

end

script static void test_screenshake_combo( short s_cnt )
static long l_rumble_id = 0;
static short s_event_cnt = 0;

	if ( s_event_cnt <= 0 ) then
		s_event_cnt = s_cnt;
		
		dprint( "test_screenshake_combo: A" );
		l_rumble_id = f_screenshake_rumble_global_add_low( 1.0, 'sound\environments\solo\m010\placeholder\rumble\m_m10_placeholder_low_rumble' );
		dprint( "test_screenshake_combo: B" );
		
		repeat
			dprint( "test_screenshake_combo: C" );
			sleep_s( 2.5 );
		
			begin_random_count(1)
				begin
					dprint( "test_screenshake_combo: f_screenshake_event_low" );
					f_screenshake_event_low( 0.5, -1, 0.5, amb_m10_explosions_large_01 );
				end
				begin
					dprint( "test_screenshake_combo: f_screenshake_event_med" );
					f_screenshake_event_med( 0.5, -1, 0.5, amb_m10_explosions_large_02 );
				end
				begin
					dprint( "test_screenshake_combo: f_screenshake_event_high" );
					f_screenshake_event_high( 0.5, -1, 0.5, amb_m10_explosions_large_03 );
				end
				begin
					dprint( "test_screenshake_combo: f_screenshake_event_very_high" );
					f_screenshake_event_very_high( 0.5, -1, 0.5, amb_m10_explosions_large_04 );
				end
			end
			dprint( "test_screenshake_combo: D" );
			s_event_cnt = s_event_cnt - 1;
		until ( s_event_cnt <= 0, 1 );
	
		dprint( "test_screenshake_combo: E" );
		sleep_s( 2.5 );
		dprint( "test_screenshake_combo: F" );
		l_rumble_id = f_screenshake_rumble_global_remove( l_rumble_id, -1, 1.0 );
		dprint( "test_screenshake_combo: DONE" );
	else
		dprint( "ALREADY RUNNING!!!!" );
	end

end
*/