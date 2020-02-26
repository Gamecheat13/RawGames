//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: NARRATIVE: LINE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean spops_narrative_line( string_id sid_speaker, short s_delay_pre, short s_delay_post, string str_debug, sound snd_sound )

	spops_radio_transmission_start( sid_speaker );
	sleep( s_delay_pre );
	dprint( str_debug );
	sound_impulse_start( snd_sound, NONE, 1 );
	sleep( sound_max_time(snd_sound) + s_delay_post );
	thread( spops_radio_transmission_end() );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: NARRATIVE: TRANSMISSIONS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global string_id DEF_SPOPS_RADIO_TRANSMISSION_GENERAL = 				"incoming_transmission";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_DALTON = 					"dalton_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO = 				"demarco_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_MILLER = 					"miller_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_PALMER = 					"palmer_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_ROLAND = 					"roland_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_THORNE = 					"thorne_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_MURPHY = 					"murphy_transmission_name";
global string_id DEF_SPOPS_RADIO_TRANSMISSION_ESPOSITO = 					"e10_m3_spartan_male";

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_spops_radio_transmission_cnt = 									0;
static real S_spops_radio_transmission_delay_start_default = 		0.0;
static real S_spops_radio_transmission_delay_end_default = 			0.0;

global string_id SID_spops_radio_transmission_active = 					NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_radio_transmission_start::: XXX
script static boolean spops_radio_transmission_start( string_id sid_name, boolean b_condition, real r_delay, boolean b_sound_force )
local boolean b_started = FALSE;

	if ( b_condition and (sid_name != SID_spops_radio_transmission_active) ) then
		local long l_timer = 0;
	
		// inc counter	
		sys_spops_radio_transmission_inc( 1 );
		SID_spops_radio_transmission_active = sid_name;
		
		// default
		if ( r_delay < 0.0 ) then
			r_delay = spops_radio_transmission_delay_start_default();
		end
		
		// start the timer
		l_timer = timer_stamp( r_delay );

		// show hud
		cui_hud_show_radio_transmission_hud( sid_name );

		// play sound		
		if ( b_sound_force or (spops_radio_transmission_cnt() == 1) ) then
			sound_impulse_start( 'sound\storm\vo\play_1_99_01_in_squelch', NONE, 1 );
			sleep( 10 );
		end
		
		// wait for timer to expire
		if ( r_delay > 0.0 ) then
			sleep_until( timer_expired(l_timer), 1 );
		end
		
		b_started = TRUE;
		
	end

	// return
	b_started;
end
script static boolean spops_radio_transmission_start( string_id sid_name, boolean b_condition, real r_delay )
	spops_radio_transmission_start( sid_name, b_condition, r_delay, FALSE );
end
script static boolean spops_radio_transmission_start( string_id sid_name, boolean b_condition )
	spops_radio_transmission_start( sid_name, b_condition, -1.0, FALSE );
end
script static boolean spops_radio_transmission_start( string_id sid_name )
	spops_radio_transmission_start( sid_name, TRUE, -1.0, FALSE );
end

// === spops_radio_transmission_start_general::: XXX
script static boolean spops_radio_transmission_start_general( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_general( boolean b_condition )
	spops_radio_transmission_start_general( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_general()
	spops_radio_transmission_start_general( TRUE, -1.0 );
end

// === spops_radio_transmission_start_esposito::: XXX
script static boolean spops_radio_transmission_start_esposito( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_ESPOSITO, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_esposito( boolean b_condition )
	spops_radio_transmission_start_esposito( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_esposito()
	spops_radio_transmission_start_esposito( TRUE, -1.0 );
end

// === spops_radio_transmission_start_dalton::: XXX
script static boolean spops_radio_transmission_start_dalton( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_dalton( boolean b_condition )
	spops_radio_transmission_start_dalton( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_dalton()
	spops_radio_transmission_start_dalton( TRUE, -1.0 );
end

// === spops_radio_transmission_start_demarco::: XXX
script static boolean spops_radio_transmission_start_demarco( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_demarco( boolean b_condition )
	spops_radio_transmission_start_demarco( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_demarco()
	spops_radio_transmission_start_demarco( TRUE, -1.0 );
end

// === spops_radio_transmission_start_miller::: XXX
script static boolean spops_radio_transmission_start_miller( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_miller( boolean b_condition )
	spops_radio_transmission_start_miller( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_miller()
	spops_radio_transmission_start_miller( TRUE, -1.0 );
end

// === spops_radio_transmission_start_palmer::: XXX
script static boolean spops_radio_transmission_start_palmer( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_palmer( boolean b_condition )
	spops_radio_transmission_start_palmer( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_palmer()
	spops_radio_transmission_start_palmer( TRUE, -1.0 );
end

// === spops_radio_transmission_start_roland::: XXX
script static boolean spops_radio_transmission_start_roland( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_roland( boolean b_condition )
	spops_radio_transmission_start_roland( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_roland()
	spops_radio_transmission_start_roland( TRUE, -1.0 );
end

// === spops_radio_transmission_start_thorne::: XXX
script static boolean spops_radio_transmission_start_thorne( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_THORNE, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_thorne( boolean b_condition )
	spops_radio_transmission_start_thorne( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_thorne()
	spops_radio_transmission_start_thorne( TRUE, -1.0 );
end

// === spops_radio_transmission_start_murphy::: XXX
script static boolean spops_radio_transmission_start_murphy( boolean b_condition, real r_delay )
	spops_radio_transmission_start( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, b_condition, r_delay );
end
script static boolean spops_radio_transmission_start_murphy( boolean b_condition )
	spops_radio_transmission_start_murphy( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_start_murphy()
	spops_radio_transmission_start_murphy( TRUE, -1.0 );
end

// === spops_radio_transmission_end::: XXX
script static boolean spops_radio_transmission_end( boolean b_condition, real r_delay )
local boolean b_ended = FALSE;

	if ( (spops_radio_transmission_cnt() > 0) and b_condition ) then
	
		sys_spops_radio_transmission_inc( -1 );
		
		if ( spops_radio_transmission_cnt() == 0 ) then
			
			// kill the hud
			cui_hud_hide_radio_transmission_hud();

			// clear active transmission
			SID_spops_radio_transmission_active = NONE;

			// play the squelch out sound
			if ( spops_radio_transmission_cnt() == 0 ) then
				static long l_thread = 0;
				if ( IsThreadValid(l_thread) ) then
					kill_thread( l_thread );
				end
				l_thread = thread( sys_spops_radio_transmission_end_snd() );
			end
		
			// default
			if ( r_delay < 0.0 ) then
				r_delay = spops_radio_transmission_delay_end_default();
			end
		
			b_ended = TRUE;

			// delay
			if ( r_delay > 0.0 ) then
				sleep_s( r_delay );
			end

		end
		
	end

	// return
	b_ended;
end
script static boolean spops_radio_transmission_end( boolean b_condition )
	spops_radio_transmission_end( b_condition, -1.0 );
end
script static boolean spops_radio_transmission_end()
	spops_radio_transmission_end( TRUE, -1.0 );
end

// === spops_radio_transmission_end_all::: Ends all radio transmissions
script static boolean spops_radio_transmission_end_all()
	if ( spops_radio_transmission_cnt() > 0 ) then
		sys_spops_radio_transmission_cnt( 1 );
		spops_radio_transmission_end( TRUE, -1.0 );
	end
end

// === spops_radio_transmission_delay_start_default::: Sets/gets default start delay
script static void spops_radio_transmission_delay_start_default( real r_delay )
	if ( r_delay < 0.0 ) then
		r_delay = 0.0;
	end
	S_spops_radio_transmission_delay_start_default = r_delay;
end
script static real spops_radio_transmission_delay_start_default()
	S_spops_radio_transmission_delay_start_default;
end

// === spops_radio_transmission_delay_end_default::: Sets/gets default end delay
script static void spops_radio_transmission_delay_end_default( real r_delay )
	if ( r_delay < 0.0 ) then
		r_delay = 0.0;
	end
	S_spops_radio_transmission_delay_end_default = r_delay;
end
script static real spops_radio_transmission_delay_end_default()
	S_spops_radio_transmission_delay_end_default;
end

// === spops_radio_transmission_cnt::: XXX
script static short spops_radio_transmission_cnt()
	S_spops_radio_transmission_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_radio_transmission_cnt( short s_cnt )

	S_spops_radio_transmission_cnt = s_cnt;
	
	if ( S_spops_radio_transmission_cnt < 0 ) then
		S_spops_radio_transmission_cnt = 0;
	end
	
end
script static void sys_spops_radio_transmission_inc( short s_cnt )

	sys_spops_radio_transmission_cnt( S_spops_radio_transmission_cnt + s_cnt );
	
end
script static void sys_spops_radio_transmission_end_snd()

	if ( spops_radio_transmission_cnt() == 0 ) then

		sleep( 5 );
		if ( spops_radio_transmission_cnt() == 0 ) then
			sound_impulse_start( 'sound\storm\vo\play_1_99_02_out_squelch', NONE, 1 );
		end

	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: NARRATIVE: DIALOG ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_dialog_line_radio::: XXX
script static void spops_dialog_line_radio( string_id sid_name, long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	
	if ( b_condition and dialog_id_active_check(l_dialog_id) ) then
		
	
		spops_radio_transmission_start( sid_name );
		local long l_thread = thread( dialog_line_radio(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only) );
		sleep_until( not IsThreadValid(l_thread), 1 );
		thread( spops_radio_transmission_end() );
	
	end
	
end
script static void spops_dialog_line_radio( string_id sid_name, long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( sid_name, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio( string_id sid_name, long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( sid_name, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: NARRATIVE: SUBTITLE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_dialog_line_radio::: XXX
script static void spops_dialog_line_subtitle( string_id sid_name, long l_dialog_id, boolean b_condition, sound snd_sound, string str_debug )
	
	if ( b_condition and dialog_id_active_check(l_dialog_id) ) then
	
		spops_radio_transmission_start( sid_name );
		if ( editor_mode() ) then
			thread( sys_dialog_blurb_radio(str_debug, frames_to_seconds(sound_max_time(snd_sound))) );
		end
		dialog_play_subtitle( snd_sound );
		thread( spops_radio_transmission_end() );
	
	end

end

// === spops_dialog_line_radio_<name>::: XXX
script static void spops_dialog_line_radio_general( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_general( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_general( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_GENERAL, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_dalton( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_dalton( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_dalton( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DALTON, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_demarco( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_demarco( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_demarco( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_DEMARCO, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_miller( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_miller( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_miller( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MILLER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_palmer( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_palmer( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_palmer( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_PALMER, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_roland( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_roland( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_roland( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_ROLAND, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_thorne( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_THORNE, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_thorne( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_THORNE, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_thorne( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_THORNE, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end

script static void spops_dialog_line_radio_murphy( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
end
script static void spops_dialog_line_radio_murphy( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static void spops_dialog_line_radio_murphy( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	spops_dialog_line_radio( DEF_SPOPS_RADIO_TRANSMISSION_MURPHY, l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE, FALSE );
end