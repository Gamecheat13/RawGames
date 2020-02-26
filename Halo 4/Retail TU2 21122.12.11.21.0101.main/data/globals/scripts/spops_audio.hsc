//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AUDIO
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AUDIO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AUDIO: DEBUG ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_spops_audio_debug_music = TRUE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void spops_audio_debug_music( string str_debug )
	if ( B_spops_audio_debug_music ) then
		print( str_debug );
	end
end
script static void spops_audio_debug_music_only( boolean b_debug )

	// enable/disable dprints
	dprint_enable( not b_debug );

	// enable/disable audio debugging
	B_spops_audio_debug_music = b_debug;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: AUDIO: MUSIC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void spops_audio_music_start( sound_event se_music, string str_debug )
	spops_audio_debug_music( str_debug );
	music_start( se_music );
end

script static void spops_audio_music_event( sound_event se_music, string str_debug )
	spops_audio_debug_music( str_debug );
	music_set_state( se_music );
end

script static void spops_audio_music_finish( sound_event se_music, string str_debug )
	spops_audio_debug_music( str_debug );
	music_stop( se_music );
end

script static void spops_audio_music_event_notifed( sound_event se_music, string str_debug, string str_notify_event, short s_cnt )
	
	repeat
	
		// trigger
		sleep_until( LevelEventStatus(str_notify_event), 1 );
		spops_audio_music_event( se_music, str_debug );
		
		// decrement count
		s_cnt = s_cnt -1;
	
		// wait for untrigger	
		if ( s_cnt != 0 ) then
			sleep_until( not LevelEventStatus(str_notify_event), 1 );
		end
		
	until( s_cnt == 0, 1 );

end
script static void spops_audio_music_event_notifed( sound_event se_music, string str_debug, string str_notify_event )
	spops_audio_music_event_notifed( se_music, str_debug, str_notify_event, -1 );
end

/*
script static void spops_audio_music_ai_attacking( sound_event se_music, string str_debug, ai ai_attacker, short s_cnt )
	
	repeat
	
		// trigger
		sleep_until( ai_is_attacking(ai_attacker) or (ai_living_count(ai_attacker) <= 0), 1 );
		
		if ( ai_living_count(ai_attacker) > 0 ) then

			spops_audio_music_event( se_music, str_debug );
			
			// decrement count
			s_cnt = s_cnt -1;
		
			// wait for untrigger	
			if ( s_cnt != 0 ) then
				sleep_until( not ai_is_attacking(ai_attacker), 1 );
			end

		else
			s_cnt = 0;
		end
		
	until( s_cnt == 0, 1 );

end	
script static void spops_audio_music_ai_attacking( sound_event se_music, string str_debug, ai ai_attacker )
	spops_audio_music_ai_attacking( se_music, str_debug, ai_attacker, -1 );
end
*/

script static void spops_audio_music_ai_shooting( sound_event se_music, string str_debug, ai ai_attacker, short s_cnt )
	
	repeat
	
		// trigger
		sleep_until( ai_is_shooting(ai_attacker) or (ai_living_count(ai_attacker) <= 0), 1 );
		
		if ( ai_living_count(ai_attacker) > 0 ) then

			spops_audio_music_event( se_music, str_debug );
			
			// decrement count
			s_cnt = s_cnt -1;
		
			// wait for untrigger	
			if ( s_cnt != 0 ) then
				sleep_until( not ai_is_shooting(ai_attacker), 1 );
			end

		else
			s_cnt = 0;
		end
		
	until( s_cnt == 0, 1 );

end	
script static void spops_audio_music_ai_shooting( sound_event se_music, string str_debug, ai ai_attacker )
	spops_audio_music_ai_shooting( se_music, str_debug, ai_attacker, -1 );
end