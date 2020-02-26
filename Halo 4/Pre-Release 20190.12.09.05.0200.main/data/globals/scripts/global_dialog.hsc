// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG
// =================================================================================================
// =================================================================================================
// =================================================================================================
// NOTE: All functions with sys_ in front of them are not intendended for use outside of this script
// NOTE: All variables in this script are not intended for use outside of this script and instead
//			 there are functions you can use to check them instead.

// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: START
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_start: Sets up a dialog based on parameters and returns when it is ready to startup.
//			str_name = Name of the dialog.
//				NOTE: You need a dialog name if you want to try to unqueue a dialog
//			l_id = ID of the dialog
//				NOTE: Only really important if the dialog is repeatable and uses the same variable to track it's use.  If you're not you can just pass DEF_DIALOG_ID_NONE().
//			b_condition = Condition to check to start the covnersation
//			r_type = Determines how to react if another dialog is playing.  See "DIALOG: TYPE" for descriptions of each type
//				NOTE: You should only use the defines for these as they may change values.
//			r_style = Determines how to react if another dialog is playing.  See "DIALOG: STYLE" for descriptions of each style
//				NOTE: You should only use the defines for these as they may change values.
//							Dialogs that are SKIPPED will return an ID of DEF_DIALOG_ID_NONE()
//			b_interruptable = Sets if this dialog can be interrupted or not
//				NOTE: This can only work for FOREGROUND dialogs.  Background dialogs can always be interrupted by other background interruptable dialogs.
//			str_notify = Notify message when the dialog start completes (SUCCESS or FAILURE)
//			r_back_pad = If the dialog is a queue or type, and another dialog is active it will pad this time (seconds) before allowing this dialog to start.  Helps make dialogs not feel like they are overly butting into each other.
//				[DEFAULT: r_back_pad < 0.0] = r_back_pad == dialog_back_pad_default_get()
//	RETURN:  [long] ID of the dialog
script static long dialog_start( string str_name, long l_id, boolean b_condition, real r_type, real r_style, boolean b_interruptable, string str_notify, real r_back_pad )
local long l_id_new = l_id;
local boolean b_use_back_pad = FALSE;
local long l_timer = 0;
sys_dialog_debug( "dialog_start", "" );

	// make sure the dialog ID is not type invalid
	if ( (not dialog_id_invalid_check(l_id)) and b_condition ) then
	
		// ERROR CHECK
		// --- str_name
		if ( not dialog_name_valid_check(str_name) ) then
			breakpoint( "dialog_start: INVALID DIALOG NAME" );
			sleep( 1 );
		end
		
		// DEFAULTS
		// --- r_back_pad
		if ( r_back_pad < 0.0 ) then
			r_back_pad = dialog_back_pad_default_get();
		end

		// check if the dialog needs to use the back pad
		b_use_back_pad = dialog_active_check() and sys_dialog_style_use_back_pad( r_style );
	
		// make sure there is no dialog with this ID still active
		//sleep_until( not dialog_id_active_check(l_id) and (not IsThreadValid(dialog_foreground_line_thread_get())), 1 );

		// perform style actions
		if ( sys_dialog_style_action(str_name, l_id, r_type, r_style) ) then

			// start the new dialog
			l_id_new = sys_dialog_type_start( str_name, r_type, b_interruptable );
			sys_dialog_inspect_l( "dialog_start - NEW ID", l_id_new );

			// apply back pad
			if ( b_use_back_pad ) then
				l_timer = game_tick_get() + seconds_to_frames( r_back_pad );
			end
			sleep_until( (dialog_id_active_check(l_id_new)) or (l_timer > game_tick_get()), 1 );

		end

	else
		sys_dialog_debug( "dialog_start", "FAILED TO START!!!" );
		sys_dialog_inspect_b( "dialog_start - not dialog_id_invalid_check(l_id)", not dialog_id_invalid_check(l_id) );
		sys_dialog_inspect_b( "dialog_start - b_condition", b_condition );
	end

	// notify complete
	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	l_id_new;
end

// Shows the radio transmission HUD with the specified speaker
// Plays the incoming transmission sound
script static void start_radio_transmission( string_id speaker_id )
	cui_hud_show_radio_transmission_hud( speaker_id );     
	sound_impulse_start( 'sound\storm\vo\play_1_99_01_in_squelch', NONE, 1 );
	sleep (10);
end

// Hides the radio transmission HUD
// Plays the end transmission sound
script static void end_radio_transmission()
	cui_hud_hide_radio_transmission_hud();
	sleep (5);
	sound_impulse_start( 'sound\storm\vo\play_1_99_02_out_squelch', NONE, 1 );
end

// === dialog_start_foreground: Starts a foreground dialog
//			See "dialog_start" for parameters/return
script static long dialog_start_foreground( string str_name, long l_id, boolean b_condition, real r_style, boolean b_interruptable, string str_notify, real r_back_pad )
sys_dialog_debug( "dialog_start_foreground", "" );
	dialog_start( str_name, l_id, b_condition, DEF_DIALOG_TYPE_FOREGROUND(), r_style, b_interruptable, str_notify, r_back_pad );
end

// === dialog_start_background: Starts a background dialog
//			See "dialog_start" for parameters/return
script static long dialog_start_background( string str_name, long l_id, boolean b_condition, real r_style, boolean b_interruptable, string str_notify, real r_back_pad )
sys_dialog_debug( "dialog_start_background", "" );
	dialog_start( str_name, l_id, b_condition, DEF_DIALOG_TYPE_BACKGROUND(), r_style, b_interruptable, str_notify, r_back_pad );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_start: Starts a specific type of dialog
script static long sys_dialog_type_start( string str_name, real r_type, boolean b_interruptable )
local long l_id = 0;
sys_dialog_debug( "sys_dialog_type_start", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		// thread the convesation info
		l_id = thread( sys_dialog_foreground_thread(str_name, b_interruptable) );
		
		// set information hooks
		sys_dialog_foreground_current_set( l_id );
		dialog_foreground_id_interruptable_set( l_id, b_interruptable );
		sys_dialog_foreground_line_index_set( -1 );
		sys_dialog_foreground_id_name_set( l_id, str_name );
		
		// increment active cnt
		sys_dialog_foreground_active_inc( 1 );
		
	end
	if ( sys_dialog_type_background(r_type) ) then
		// thread the convesation info
		l_id = thread( sys_dialog_background_thread(str_name, b_interruptable) );

		// increment active cnt
		sys_dialog_background_active_inc( 1 );

	end

	// RETURN
	l_id;
end

// === sys_dialog_foreground_thread: Thread that is active while the conversation is active
script static void sys_dialog_foreground_thread( string str_name, boolean b_interruptable )
local long l_id = GetCurrentThreadId();
	
	sys_dialog_debug( "sys_dialog_foreground_thread", "STARTED" );
	// Keep the function from returning to keep the thread active
	sleep_until( dialog_foreground_end_all_check() or (f_dialog_end_id_check(l_id)) or (l_id != dialog_foreground_current_get()) or ((b_interruptable) and ((l_id == sys_dialog_end_interrupt_get()) or (dialog_interrupt_foreground_queue_cnt() > 0))), 1 );
	sys_dialog_debug( "sys_dialog_foreground_thread", "ENDED" );
	
	// if it's still current clean up
	if ( l_id == dialog_foreground_current_get() ) then
		dialog_foreground_id_interruptable_set( l_id, TRUE );
		sys_dialog_foreground_current_set( DEF_DIALOG_ID_NONE() );	
	end

	// deccrement active cnt
	sys_dialog_foreground_active_inc( -1 );
	
end

// === sys_dialog_background_thread: Thread that is active while the conversation is active
script static void sys_dialog_background_thread( string str_name, boolean b_interruptable )
local long l_id = GetCurrentThreadId();
sys_dialog_debug( "sys_dialog_background_thread", "" );

	sys_dialog_debug( "sys_dialog_background_thread", "STARTED" );
	// Keep the function from returning to keep the thread active
	sleep_until( dialog_background_end_all_check() or (f_dialog_end_id_check(l_id)) or ((b_interruptable) and ((l_id == sys_dialog_end_interrupt_get()) or (dialog_interrupt_background_queue_cnt() > 0))), 1 );
	sys_dialog_debug( "sys_dialog_background_thread", "ENDED" );
	
	// deccrement active cnt
	sys_dialog_background_active_inc( -1 );
	sys_dialog_foreground_id_name_set( GetCurrentThreadId(), "" );
	
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: LINE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line: Plays a line of dialog IF this dialog is active
//			l_dialog_id = Dialog ID that this line belongs to
//			s_line_index = ID for the line that is set when the line starts playing; allows testing if the line is playing
//			str_speaker_id = Speaker id for the line.  This allows for testing of who's speaking as well as special case handling for specific speakers
//			snd_sound = Sound tag file
//			o_object = Object to play the line on
//			r_pad = Seconds to pad on the line
//				NOTE: this number can be - if you want to make lines step on one another
//			str_notify = Notify message that triggers after the line is complete (played successfull or fails)
//			str_debug = Debug string to print when the line plays
//				NOTE: It's good to use this as string of the dialog to make testing in Sapien easier
//	RETURN:		[boolean] TRUE; if the line was played
script static boolean dialog_line( long l_dialog_id, short s_line_index, string str_speaker_id, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_subtitle_only )
local boolean b_played 				= FALSE;
local long 		l_line_thread 	= 0;
local real 		r_type 					= DEF_DIALOG_TYPE_BACKGROUND();

	// gets the dialog type from the ID
	r_type = sys_dialog_type_id_get( l_dialog_id );

	// wait for other foreground line to finish
	if ( sys_dialog_type_foreground(r_type) ) then
		sleep_until( not IsThreadValid(dialog_foreground_line_thread_get()), 1 );
	end

	if ( b_condition and dialog_id_active_check(l_dialog_id) and (r_type != DEF_DIALOG_TYPE_NONE()) and ((o_object == NONE) or (ai_get_object(object_get_ai(o_object)) == NONE) or (object_get_health(o_object) > 0.0)) ) then
		
		// create the line thread and wait for it to finish
		sys_dialog_line_thread( l_dialog_id, s_line_index, str_speaker_id, snd_sound, b_line_interruptable, o_object, r_pad, str_debug, b_subtitle_only );

		// if dialog type no longer matches, the conversation is probably shutting down so wait for it to finish to avoid a new line being triggered
		if ( r_type != sys_dialog_type_id_get(l_dialog_id) ) then
			sleep_until( not IsThreadValid(l_dialog_id), 1 );
		end
		
		b_played = TRUE;
		
	end

	// Notify
	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	b_played;

end

script static boolean dialog_line( long l_dialog_id, short s_line_index, string str_speaker_id, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line( l_dialog_id, s_line_index, str_speaker_id, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, FALSE );
end

script static boolean dialog_line_subtitle( long l_dialog_id, short s_line_index, string str_speaker_id, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line( l_dialog_id, s_line_index, str_speaker_id, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE );
end

// Display the subtitle for the specified dialog sound
script static void dialog_play_subtitle(sound snd_sound)
	local real duration = sound_max_time( snd_sound ); // this is in frames
	play_sound_subtitle(snd_sound);
	sleep(duration); 
end

// === dialog_line_chief: Starts a Chief dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_chief( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_chief", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_CHIEF(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_chief( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_chief( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, FALSE );
end
script static boolean dialog_line_chief_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_chief( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE );
end

// === dialog_line_cortana: Starts a Cortana dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_cortana( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_cortana", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_CORTANA(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_cortana( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_cortana( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, FALSE );
end
script static boolean dialog_line_cortana_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_cortana( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE );
end

// === dialog_line_didact: Starts a Didact dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_didact( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_didact", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_DIDACT(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_didact( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_didact( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, FALSE );
end
script static boolean dialog_line_didact_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line_didact( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, TRUE );
end

// === dialog_line_npc: Starts a generic npc dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_npc( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_npc", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_NPC(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_npc( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_npc( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static boolean dialog_line_npc_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_npc( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, TRUE );
end

// === dialog_line_npc_ai: Starts a generic npc ai dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_npc_ai( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, ai ai_speaker, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_npc_ai", "" );

	if ( ai_living_count(ai_speaker) > 0 ) then
		b_line_spoken = dialog_line_npc( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_get_object(ai_speaker), r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only );
	end
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_npc_ai( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, ai ai_speaker, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_npc_ai( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_speaker, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static boolean dialog_line_npc_ai_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, ai ai_speaker, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_npc_ai( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_speaker, r_pad, str_notify, str_debug, b_exclusive, TRUE );
end

// === dialog_line_radio: Starts a radio dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_radio( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_radio", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_RADIO(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end
script static boolean dialog_line_radio( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_radio( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end
script static boolean dialog_line_radio_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_radio( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, TRUE );
end

// === dialog_line_other: Starts a other dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_other( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive, boolean b_subtitle_only )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_other", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_OTHER(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end 
script static boolean dialog_line_other( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_other( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, FALSE );
end 
script static boolean dialog_line_other_subtitle( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
	dialog_line_other( l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, TRUE );
end 

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_line_thread: Thread that manages a dialog line
script static void sys_dialog_line_thread( long l_dialog_id, short s_line_index, string str_speaker_id, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_debug, boolean b_subtitle_only )
local long 		l_timer 								= 0; 
local real 		r_type 									= DEF_DIALOG_TYPE_BACKGROUND();
local long 		l_snd_time 							= 0;
local boolean b_dialog_interruptable 	= dialog_id_interruptable_check( l_dialog_id );

sys_dialog_debug( "sys_dialog_line_thread", "" );
 
	// get the dialog line type
	r_type = sys_dialog_type_id_get( l_dialog_id );

	// checks to invalidate line
	if ( (str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF() or str_speaker_id == DEF_DIALOG_SPEAKER_ID_CORTANA()) and (player_living_count() == 0) ) then
		r_type = DEF_DIALOG_TYPE_NONE();
	end
	if ( (o_object != NONE) and (object_get_maximum_vitality(o_object,TRUE) > 0.0) and (object_get_health(o_object) <= 0.0) ) then
		r_type = DEF_DIALOG_TYPE_NONE();
	end

	// play the line
	if ( r_type != DEF_DIALOG_TYPE_NONE() ) then
	
		// increment the current active line cnt	
		sys_dialog_type_line_active_inc( r_type, 1 );

		// store foreground line information
		if ( dialog_foreground_id_check(l_dialog_id) ) then
			// set the foreground thread id
			sys_dialog_foreground_line_thread_set( GetCurrentThreadId() );
			// set the foreground line index
			sys_dialog_foreground_line_index_set( s_line_index );
			// set the foreground line speaker
			sys_dialog_foreground_line_speaker_set( str_speaker_id );
			// set the foreground line sound
			sys_dialog_foreground_line_sound_set( snd_sound );
			// set the foreground line timer
			sys_dialog_foreground_line_timer_set( l_timer );
		end
	
		// wait for there to be players for Chief to speak
		if ( (str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF()) and (player_living_count() == 0) ) then
			sys_dialog_debug( "sys_dialog_line_thread", "EITHER ALL PLAYERS HAVE DIED OR HAVE NOT SPAWNED YET, WAITING TO PLAY CHIEF LINE!!!" );
			sleep_until( player_living_count() > 0, 1 );
		end	
	
		// play the sound
		if ( snd_sound != NONE ) then
			if ( not b_subtitle_only ) then
				sound_impulse_start( snd_sound, o_object, 1 );
				l_snd_time = sound_impulse_time( snd_sound );
			else
				play_sound_subtitle( snd_sound );
				l_snd_time = sound_max_time( snd_sound );
			end
			r_pad = r_pad + frames_to_seconds( l_snd_time );
		elseif ( l_snd_time == 0 ) then
			r_pad = r_pad + dialog_line_temp_blurb_pad_get();
		end

		// display story blurb if necessary
		if ( (str_debug != "") and dialog_line_temp_blurb_get() and ((snd_sound == NONE) or dialog_line_temp_blurb_force_get() or editor_mode())) then
			local long l_blurb_thread = 0;
			
			// take 1 frame off the pad because of the thread delay
			r_pad = r_pad - frames_to_seconds( 1 );
		
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF() ) then
				l_blurb_thread = thread( sys_dialog_blurb_chief(str_debug, r_pad) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_CORTANA() ) then
				l_blurb_thread = thread( sys_dialog_blurb_cortana(str_debug, r_pad) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_DIDACT() ) then
				l_blurb_thread = thread( sys_dialog_blurb_didact(str_debug, r_pad) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_NPC() ) then
				l_blurb_thread = thread( sys_dialog_blurb_npc(str_debug, r_pad) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_RADIO() ) then
				l_blurb_thread = thread( sys_dialog_blurb_radio(str_debug, r_pad) );
			end
			if ( l_blurb_thread == 0 ) then
				l_blurb_thread = thread( sys_dialog_blurb_other(str_debug, r_pad) );
			end
			
		end
	
		// applies auto pad time
		r_pad = r_pad + dialog_line_auto_pad_get();
	
		// calculate the timer
		l_timer = timer_stamp( r_pad );
		//l_timer = game_tick_get() + seconds_to_frames( r_pad );
	
		// store foreground line information
		if ( dialog_foreground_id_check(l_dialog_id) ) then
			// set the foreground line timer
			sys_dialog_foreground_line_timer_set( l_timer );
		end
	
		// wait for the line to finish or be interrupted
		sleep_until( 
			( timer_expired(l_timer) )
			or
			(
				//If all players are dead, kill chief and cortana dialog.
				( str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF() or str_speaker_id == DEF_DIALOG_SPEAKER_ID_CORTANA())
				and
				( player_living_count() == 0 )
			)
			or
			(
				( o_object != NONE )
				and
				( object_get_maximum_vitality(o_object,TRUE) > 0.0 )
				and
				( object_get_health(o_object) <= 0.0 )
			)
			or
			(
				b_line_interruptable
				and
				( not IsThreadValid(l_dialog_id) ) 
			)
		, 1 );
	
		// if the timer is still valid that means the conversation has ended, kill the line
		if ( game_tick_get() < l_timer ) then
			sound_impulse_stop( snd_sound );
		end

		// Holding out if there's no Chief
		if ( (str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF() or str_speaker_id == DEF_DIALOG_SPEAKER_ID_CORTANA()) and (player_living_count() == 0) ) then
			sys_dialog_debug( "sys_dialog_line_thread", "EITHER ALL PLAYERS HAVE DIED OR HAVE NOT SPAWNED YET, WAITING TO PLAY CHIEF LINE!!!" );
			sleep_until( player_living_count() > 0, 1 );
		end	
	
		// decrement the current active line cnt	
		sys_dialog_type_line_active_inc( r_type, -1 );

	end

	sys_dialog_foreground_line_thread_set( 0 );
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: INDEX
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_line_index_get: Gets the current foreground line index
//	RETURN:		[short] Current foreground line index
script static short dialog_foreground_line_index_get()
	S_dialog_foreground_line_index;
end

// === dialog_foreground_line_index_check_equel: Checks if dialog_foreground_line_index_get() == s_line_index
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() == s_line_index
script static boolean dialog_foreground_line_index_check_equel( short s_line_index )
	( dialog_foreground_line_index_get() == s_line_index );
end
// === dialog_foreground_line_index_check_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() == s_line_index
//			l_dialog_id = Dialog ID to test
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() == s_line_index
script static boolean dialog_foreground_id_line_index_check_equel( long l_dialog_id, short s_line_index )
	dialog_foreground_id_active_check( l_dialog_id ) and dialog_foreground_line_index_check_equel( s_line_index );
end

// === dialog_foreground_line_index_check_less: Checks if dialog_foreground_line_index_get() < s_line_index
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() < s_line_index
script static boolean dialog_foreground_line_index_check_less( short s_line_index )
	( dialog_foreground_line_index_get() < s_line_index );
end
// === dialog_foreground_id_line_index_check_less: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() < s_line_index
//			l_dialog_id = Dialog ID to test
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() < s_line_index
script static boolean dialog_foreground_id_line_index_check_less( long l_dialog_id, short s_line_index )
	dialog_foreground_id_active_check( l_dialog_id ) and dialog_foreground_line_index_check_less( s_line_index );
end

// === dialog_foreground_line_index_check_less_equel: Checks if dialog_foreground_line_index_get() <= s_line_index
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() <= s_line_index
script static boolean dialog_foreground_line_index_check_less_equel( short s_line_index )
	( dialog_foreground_line_index_get() <= s_line_index );
end
// === dialog_foreground_id_line_index_check_less_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() <= s_line_index
//			l_dialog_id = Dialog ID to test
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() <= s_line_index
script static boolean dialog_foreground_id_line_index_check_less_equel( long l_dialog_id, short s_line_index )
	dialog_foreground_id_active_check( l_dialog_id ) and dialog_foreground_line_index_check_less_equel( s_line_index );
end

// === dialog_foreground_line_index_check_greater: Checks if dialog_foreground_line_index_get() > s_line_index
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() > s_line_index
script static boolean dialog_foreground_line_index_check_greater( short s_line_index )	
	( dialog_foreground_line_index_get() > s_line_index );
end
// === dialog_foreground_id_line_index_check_greater: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() > s_line_index
//			l_dialog_id = Dialog ID to test
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() > s_line_index
script static boolean dialog_foreground_id_line_index_check_greater( long l_dialog_id, short s_line_index )
	dialog_foreground_id_active_check( l_dialog_id ) and dialog_foreground_line_index_check_greater( s_line_index );
end

// === dialog_foreground_line_index_check_greater_equel: Checks if dialog_foreground_line_index_get() >= s_line_index
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() >= s_line_index
script static boolean dialog_foreground_line_index_check_greater_equel( short s_line_index )
	( dialog_foreground_line_index_get() >= s_line_index );
end
// === dialog_foreground_id_line_index_check_greater_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() >= s_line_index
//			l_dialog_id = Dialog ID to test
//			s_line_index = Line index to compare
//	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() >= s_line_index
script static boolean dialog_foreground_id_line_index_check_greater_equel( long l_dialog_id, short s_line_index )
	dialog_foreground_id_active_check( l_dialog_id ) and dialog_foreground_line_index_check_greater_equel( s_line_index );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_foreground_line_index				= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_line_index_set: Sets the foreground line index
script static void sys_dialog_foreground_line_index_set( short s_index )
sys_dialog_debug( "sys_dialog_foreground_line_index_set", "" );
	S_dialog_foreground_line_index = s_index;
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: SPEAKER
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_line_speaker_get: Gets the current foreground line speaker
//	RETURN:		[string] Current foreground line speaker 
script static string dialog_foreground_line_speaker_get()
	STR_dialog_foreground_line_speaker;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static string 	STR_dialog_foreground_line_speaker			= DEF_DIALOG_SPEAKER_ID_NONE();

// === sys_dialog_foreground_line_speaker_set: Sets the current foreground line speaker
script static void sys_dialog_foreground_line_speaker_set( string str_speaker_id )
sys_dialog_debug( "sys_dialog_foreground_line_speaker_set", "" );
	STR_dialog_foreground_line_speaker = str_speaker_id;
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: SOUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_line_sound_get: Gets the current foreground line sound file tag
//	RETURN:		[sound] Current foreground line sound 
script static sound dialog_foreground_line_sound_get()
	SND_dialog_foreground_line_sound;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static sound 	SND_dialog_foreground_line_sound			= NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_line_sound_set: Sets the current foreground line sound
script static void sys_dialog_foreground_line_sound_set( sound snd_sound )
sys_dialog_debug( "sys_dialog_foreground_line_sound_set", "" );
	SND_dialog_foreground_line_sound = snd_sound;
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: TIMER
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_line_timer_get: Gets the current 
//	RETURN:		[long] game_tick_get() time in which the current foreground line timer will expire
script static long dialog_foreground_line_timer_get()
	L_dialog_foreground_line_timer;
end
// === dialog_foreground_line_timer_remaining_seconds: Gets seconds left for current foreground line id 
//	RETURN:		[real] Time (in seconds) remaining for the current foreground line ID
script static real dialog_foreground_line_timer_remaining_seconds()
	frames_to_seconds( dialog_foreground_line_timer_remaining_ticks() );
end
// === dialog_foreground_line_timer_remaining_ticks: Gets ticks left for current foreground line id
//	RETURN:		[long] Time (in ticks) remaining for the current foreground line ID
script static long dialog_foreground_line_timer_remaining_ticks()
	dialog_foreground_line_timer_get() - game_tick_get();
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static long 	L_dialog_foreground_line_timer				= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_line_timer_set: Sets the current foreground line timer
script static void sys_dialog_foreground_line_timer_set( long l_timer )
sys_dialog_debug( "sys_dialog_foreground_line_timer_set", "" );
	L_dialog_foreground_line_timer = l_timer;
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: THREAD
// =================================================================================================
// === dialog_foreground_line_thread_get: Gets the thread ID to the current foreground line ID
//	RETURN:		[long] Thread handle to the current foreground line ID
script static long dialog_foreground_line_thread_get()
	L_dialog_foreground_line_id;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static long 	L_dialog_foreground_line_id						= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_line_thread_set: Sets the current foreground line id thread index
script static void sys_dialog_foreground_line_thread_set( long l_line_thread )
sys_dialog_debug( "sys_dialog_foreground_line_thread_set", "" );
	L_dialog_foreground_line_id = l_line_thread;
end

// =================================================================================================
// DIALOG: LINE: ACTIVE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line_active_check: Checks if there are any lines playing at this given time
//	RETURN:		[boolean] TRUE; a line is playing
script static boolean dialog_line_active_check()
	dialog_line_active_cnt() > 0;
end

// === dialog_line_active_cnt: Gets the total number of active lines active
//	RETURN:		[short] Number of lines currently active
script static short dialog_line_active_cnt()
	dialog_foreground_line_active_cnt() + dialog_background_line_active_cnt();
end

// =================================================================================================
// DIALOG: LINE: TYPE: ACTIVE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_type_line_active_check: Checks how many lines are active from a particular type of dialog
//			r_type = Type of dialog to check
//	RETURN:		[boolean] TRUE; that type of dialog has active lines
script static boolean dialog_type_line_active_check( real r_type )
	dialog_type_line_active_cnt( r_type ) > 0;
end

// === dialog_type_line_active_cnt: Gets the current active line count for a dialog type
//			r_type = Type of dialog to check
//	RETURN:		[short] Quantity of active lines of the type playing
script static short dialog_type_line_active_cnt( real r_type )
local short s_cnt = 0;

	if ( sys_dialog_type_foreground(r_type) ) then
		s_cnt = dialog_foreground_line_active_cnt();
	end
	if ( sys_dialog_type_background(r_type) ) then
		s_cnt = dialog_background_line_active_cnt();
	end

	// RETURN
	s_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_line_active_inc: Increments the type active line cnt
//			r_type = Type of dialog to check
//			s_inc = Amount to increment
script static void sys_dialog_type_line_active_inc( real r_type, short s_inc )
sys_dialog_debug( "sys_dialog_type_line_active_inc", "" );
	if ( sys_dialog_type_foreground(r_type) ) then
		sys_dialog_foreground_line_active_inc( s_inc );
	end
	if ( sys_dialog_type_background(r_type) ) then
		sys_dialog_background_line_active_inc( s_inc );
	end
end

// =================================================================================================
// DIALOG: LINE: FOREGROUND: ACTIVE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_line_active_check: Checks if there are any active foreground lines
//	RETURN:		[boolean] TRUE; there area active foreground lines
script static boolean dialog_foreground_line_active_check()
	dialog_foreground_line_active_cnt() > 0;
end
// === dialog_foreground_line_active_cnt: Gets the current count of active foreground lines
//	RETURN:		[short] Quanity of active foreground lines
script static short dialog_foreground_line_active_cnt()
	S_dialog_foreground_line_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_foreground_line_cnt					= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_line_active_inc: Increments the foreground active line cnt
script static void sys_dialog_foreground_line_active_inc( short s_inc )
sys_dialog_debug( "sys_dialog_foreground_line_active_inc", "" );
	S_dialog_foreground_line_cnt = S_dialog_foreground_line_cnt + s_inc;
	if ( S_dialog_foreground_line_cnt < 0 ) then
		S_dialog_foreground_line_cnt = 0;
	end
end

// =================================================================================================
// DIALOG: LINE: BACKGROUND: CNT
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_line_active_check: Checks if there are any active background lines
//	RETURN:		[boolean] TRUE; there area active background lines
script static boolean dialog_background_line_active_check()
	dialog_background_line_active_cnt() > 0;
end
// === dialog_background_line_active_cnt: Gets the current count of active background lines
//	RETURN:		[short] Quanity of active background lines
script static short dialog_background_line_active_cnt()
	S_dialog_background_line_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_background_line_cnt					= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_background_line_active_inc: Increments the background active line cnt
script static void sys_dialog_background_line_active_inc( short s_inc )
sys_dialog_debug( "sys_dialog_background_line_active_inc", "" );
	S_dialog_background_line_cnt = S_dialog_background_line_cnt + s_inc;
	if ( S_dialog_background_line_cnt < 0 ) then
		S_dialog_background_line_cnt = 0;
	end
end

// =================================================================================================
// DIALOG: LINE: AUTO PAD
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line_auto_pad_set: This time is always added to any line playing
//			r_pad [real]	= Time (seconds) to add to a line pad
script static void dialog_line_auto_pad_set( real r_pad )
sys_dialog_debug( "dialog_line_auto_pad_set", "" );
	R_pad_line_time_auto = r_pad;
end

// === dialog_line_auto_pad_get: Gets the current line auto pad time
//	RETURN:		[real] Current dialog auto pad line time (seconds)
script static real dialog_line_auto_pad_get()
	R_pad_line_time_auto;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
global real 		R_pad_line_time_auto									= 0.0;

// =================================================================================================
// DIALOG: LINE: TEMP BLURB
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line_temp_blurb_set: Sets if a temp line (IE, on a line snd_sound == NONE) should display story blurbs
//			b_blurb [boolean]	= TRUE; displays blurbs
script static void dialog_line_temp_blurb_set( boolean b_blurb )
sys_dialog_debug( "dialog_line_temp_blurb_set", "" );
	b_temp_line_display_blurb = b_blurb;
end

// === dialog_line_temp_blurb_get: Checks if dialog line temp blurbs are enabled
//	RETURN:		[boolean] TRUE; temp line blurbs are enabled
script static boolean dialog_line_temp_blurb_get()
	b_temp_line_display_blurb;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
global boolean 	b_temp_line_display_blurb							= TRUE;

// =================================================================================================
// DIALOG: LINE: TEMP BLURB: FORCE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line_temp_blurb_force_set: Set the temp blurb to be forced on (needs blurbs to be enabled too)
//			b_blurb [boolean]	= TRUE; force displays blurbs
script static void dialog_line_temp_blurb_force_set( boolean b_blurb )
sys_dialog_debug( "dialog_line_temp_blurb_force_set", "" );
	b_temp_line_display_blurb_force = b_blurb;
end

// === dialog_line_temp_blurb_force_get: Checks if dialog line temp blurbs are force enabled
//	RETURN:		[boolean] TRUE; temp line blurbs force is enabled
script static boolean dialog_line_temp_blurb_force_get()
	b_temp_line_display_blurb_force;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
global boolean 	b_temp_line_display_blurb_force				= FALSE;

// =================================================================================================
// DIALOG: LINE: TEMP PAD
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_line_temp_blurb_pad_set: Default pad time for temp lines (IE, on a line snd_sound == NONE)
//			r_pad [real]	= Time (seconds) to pad after the line plays
script static void dialog_line_temp_blurb_pad_set( real r_pad )
sys_dialog_debug( "dialog_line_temp_blurb_pad_set", "" );
	r_line_temp_pad_time = r_pad;
end

// === dialog_line_temp_blurb_pad_get: Gets the temp line blurb pad length
//	RETURN:		[real] Temp line pad length (seconds)
script static real dialog_line_temp_blurb_pad_get()
	r_line_temp_pad_time;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
global real 		r_line_temp_pad_time 									= 3.25;



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: END
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_end: ends a dialog
//			l_id = ID for the dialog to end
//			b_active_invalidates = If line dialog is active this will return DEF_DIALOG_ID_INVALID() for the ID so if you store that it will not try and play the conversation again if it's called again
//			str_notify = Notify message if the dialog end is fired
//	RETURNS:  Returns TRUE if the dialog was the current dialog and ended
script static long dialog_end( long l_id, boolean b_started_invalidates, boolean b_active_invalidates, string str_notify )
sys_dialog_debug( "dialog_end", "" );
	sys_dialog_end( l_id, b_started_invalidates, b_active_invalidates, str_notify );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_end: System that ends a conversation
script static long sys_dialog_end( long l_id, boolean b_started_invalidates, boolean b_active_invalidates, string str_notify )
local real r_type = DEF_DIALOG_TYPE_BACKGROUND();
sys_dialog_debug( "sys_dialog_end", "" );

	// make sure the dialog id is active
	if ( dialog_id_active_check(l_id) ) then
		// Check if this is the current foreground conversation
		if ( dialog_foreground_id_check(l_id) ) then
			sys_dialog_debug( "sys_dialog_end", "FOREGROUND ----------------------------------------------" );
			r_type = DEF_DIALOG_TYPE_FOREGROUND();
			sys_dialog_foreground_current_set( DEF_DIALOG_ID_NONE() );
		else
			sys_dialog_debug( "sys_dialog_end", "BACKGROUND ----------------------------------------------" );
			sys_dialog_end_id_set( l_id );
		end

		sys_dialog_inspect_l( "sys_dialog_end - l_id", l_id );
		
		// wait for the thread to shut down
		sleep_until( not IsThreadValid(l_id), 1 );

		// decrement the conversation counter
		//sys_dialog_type_active_inc( r_type, -1 );
		
		if ( b_active_invalidates ) then
			l_id = DEF_DIALOG_ID_INVALID();
		end
	elseif ( b_started_invalidates and (not dialog_id_none_check(l_id)) ) then
		l_id = DEF_DIALOG_ID_INVALID();
	end

	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	l_id;
end

// =================================================================================================
// DIALOG: END: ID
// =================================================================================================

// === f_dialog_end_id_get: Gets the current end id
script static long f_dialog_end_id_get()
	L_dialog_end_ID;
end

// === f_dialog_end_id_check: Checks an ID vs the current end ID
script static boolean f_dialog_end_id_check( long l_id )
	( f_dialog_end_id_get() == l_id );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static long L_dialog_end_ID																	= DEF_DIALOG_ID_NONE();

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_end_id_set: Sets an ID to end
script static void sys_dialog_end_id_set( long l_id )

	sys_dialog_debug( "sys_dialog_end_id_set", "WAIT" );
	sleep_until( not isthreadvalid(f_dialog_end_id_get()), 1 );
	sys_dialog_debug( "sys_dialog_end_id_set", "SET" );
	L_dialog_end_ID = l_id;

end

// =================================================================================================
// DIALOG: END: INTERRUPT
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_end_interrupt: Interrupts a dialog ID (if interruptable)
//			l_id = ID for the dialog to interrupt
script static void dialog_end_interrupt( long l_id )
	thread( sys_dialog_end_interrupt(l_id) );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static long L_dialog_end_interrupt_id 											= DEF_DIALOG_ID_NONE();

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_end_interrupt: Handles dialog interruption
script static void sys_dialog_end_interrupt( long l_id )
sys_dialog_debug( "sys_dialog_end_interrupt", "" );
inspect( l_id );
sys_dialog_inspect_l( "sys_dialog_end_interrupt - l_id", l_id );

	sleep_until( sys_dialog_end_interrupt_get() == DEF_DIALOG_ID_NONE(), 1 );
	sys_dialog_end_interrupt_set( l_id );

	sleep_until( not IsThreadValid(l_id), 1 );
	sys_dialog_end_interrupt_set( DEF_DIALOG_ID_NONE() );

end
script static void sys_dialog_end_interrupt_set( long l_id )
	L_dialog_end_interrupt_id = l_id;
end
script static long sys_dialog_end_interrupt_get()
	L_dialog_end_interrupt_id;
end



// =================================================================================================
// DIALOG: END: ALL
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_end_all: Ends all currently FOREGROUND and BACKGROUND running dialogs
script static void dialog_end_all()
local long l_foreground_thread = 0;
local long l_background_thread = 0;
sys_dialog_debug( "dialog_end_all", "" );

	repeat
		l_foreground_thread = thread( dialog_foreground_end_all() );
		l_background_thread = thread( dialog_background_end_all() );
		
		sleep_until( (not IsThreadValid(l_foreground_thread)) and (not IsThreadValid(l_background_thread)), 1 );
	until( not dialog_active_check(), 1 );
	
end

// =================================================================================================
// DIALOG: END: ALL: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_end_all: Ends all currently FOREGROUND running dialogs
script static void dialog_foreground_end_all()
sys_dialog_debug( "dialog_foreground_end_all", "" );

	sys_dialog_foreground_end_all_set( TRUE );
	sleep_until( dialog_foreground_active_cnt() == 0, 1 );
	sys_dialog_foreground_end_all_set( FALSE );

end
// === dialog_foreground_end_all_check: Checks if all FOREGROUND dialogs are trying to be shut down
//	RETURN:		[boolean] TRUE; dialog FOREGROUND end all is active
script static boolean dialog_foreground_end_all_check()
	B_dialog_foreground_end_all;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static boolean B_dialog_foreground_end_all					= FALSE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_end_all_set: Sets the FOREGROUND dialog end all flag
script static void sys_dialog_foreground_end_all_set( boolean b_end_all )
sys_dialog_debug( "sys_dialog_foreground_end_all_set", "" );
	B_dialog_foreground_end_all = b_end_all;
end

// =================================================================================================
// DIALOG: END: ALL: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_end_all: Ends all currently BACKGROUND running dialogs
script static void dialog_background_end_all()
sys_dialog_debug( "dialog_background_end_all", "" );

	sys_dialog_background_end_all_set( TRUE );
	sleep_until( dialog_background_active_cnt() == 0, 1 );
	sys_dialog_background_end_all_set( FALSE );

end
// === dialog_background_end_all_check: Checks if all BACKGROUND dialogs are trying to be shut down
//	RETURN:		[boolean] dialog BACKGROUND end all is active
script static boolean dialog_background_end_all_check()
	B_dialog_background_end_all;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static boolean B_dialog_background_end_all				= FALSE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_background_end_all_set: Sets the BACKGROUND dialog end all flag
script static void sys_dialog_background_end_all_set( boolean b_end_all )
sys_dialog_debug( "sys_dialog_background_end_all_set", "" );
	B_dialog_background_end_all = b_end_all;
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: DISABLE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_disable: Performs every action possible to remove a conversation from existance
//			str_dialog_name = Name of the dialog to remove
//			l_dialog_id = Dialog ID of the conversation to disable
//			r_unqueue_timeout = Time of the timeout for the dialog unqueue
//			b_thread_unque = This will thread the unqueue instead of making script wait
//	RETURN:		[long] DEF_DIALOG_ID_INVALID();
script static long dialog_disable( string str_dialog_name, long l_dialog_id, real r_unqueue_timeout, boolean b_thread )

	if ( not dialog_id_played_check(l_dialog_id) ) then
		if ( dialog_id_active_check(l_dialog_id) ) then
			dialog_end( l_dialog_id, TRUE, TRUE, "" );
		elseif ( b_thread ) then
			thread( dialog_unqueue_name(str_dialog_name, r_unqueue_timeout) );
		else
			dialog_unqueue_name( str_dialog_name, r_unqueue_timeout );
		end
	end

	// RETURN
	DEF_DIALOG_ID_INVALID();
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: TYPE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// DEFINES -----------------------------------------------------------------------------------------
script static real DEF_DIALOG_TYPE_FOREGROUND()				01.0;		end					// There can only be one foreground conversation running at a time
script static real DEF_DIALOG_TYPE_BACKGROUND()				02.0;		end					// There can be any number of background conversations running at a time

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// DEFINES -----------------------------------------------------------------------------------------					
script static real DEF_DIALOG_TYPE_ALL()							-7.77;	end					// Checks test against all dialog types
script static real DEF_DIALOG_TYPE_NONE()							 0.0;		end					// Invalid dialog type

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_foreground: Checks if a dialog type is FOREGROUND
script static boolean sys_dialog_type_foreground( real r_type )
	( (r_type == DEF_DIALOG_TYPE_FOREGROUND()) or (r_type == DEF_DIALOG_TYPE_ALL()) );
end
// === sys_dialog_type_background: Checks if a dialog type is BACKGROUND
script static boolean sys_dialog_type_background( real r_type )
	( (r_type == DEF_DIALOG_TYPE_BACKGROUND()) or (r_type == DEF_DIALOG_TYPE_ALL()) );
end

// === sys_dialog_type_id_get: Gets what type a dialog id is
script static real sys_dialog_type_id_get( long l_dialog_id )
local real r_type = DEF_DIALOG_TYPE_NONE();

	if ( dialog_foreground_id_check(l_dialog_id) ) then
		r_type = DEF_DIALOG_TYPE_FOREGROUND();
	elseif ( dialog_background_id_active_check(l_dialog_id) ) then
		r_type = DEF_DIALOG_TYPE_BACKGROUND();
	end

	// RETURN
	r_type;
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: STYLE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// DEFINES -----------------------------------------------------------------------------------------
// --- BACKGROUND ONLY
script static real DEF_DIALOG_STYLE_PLAY()										0.0; 	end					//	Dialog will automatically just play.  NOTE: Only works for BACKGROUND type dialogs.
// --- FOREGROUND ONLY
script static real DEF_DIALOG_STYLE_INTERRUPT()								1.0;	end					//	Dialog will interrupt the current dialog of the same typebut still let the current line finish playing. NOTE: If it cannot intterupt the current line it will queue until it can interrupt
script static real DEF_DIALOG_STYLE_INTERRUPT_FOREGROUND()		1.1;	end					//	Dialog will interrupt the current foreground dialog but still let the current line finish playing. NOTE: If it cannot intterupt the current line it will queue until it can interrupt
script static real DEF_DIALOG_STYLE_INTERRUPT_BACKGROUND()		1.2;	end					//	Dialog will interrupt the current foreground dialog but still let the current line finish playing. NOTE: If it cannot intterupt the current line it will queue until it can interrupt
script static real DEF_DIALOG_STYLE_INTERRUPT_ALL()						1.9;	end					//	Dialog will interrupt the current foreground dialog but still let the current line finish playing. NOTE: If it cannot intterupt the current line it will queue until it can interrupt
// --- BACKGROUND & FOREGROUND
script static real DEF_DIALOG_STYLE_QUEUE()										2.0;	end					//	Dialog will queue if a dialog is active of the same type and play when they are complete.
script static real DEF_DIALOG_STYLE_QUEUE_FOREGROUND()				2.1;	end					//	Dialog will queue if a FOREGROUND dialog is active and play when there are no FOREGROUND dialogs active.
script static real DEF_DIALOG_STYLE_QUEUE_BACKGROUND()				2.2;	end					//	Dialog will queue if a BACKGROUND dialog is active and play when there are no BACKGROUND dialogs active.
script static real DEF_DIALOG_STYLE_QUEUE_ALL()								2.9;	end					//	Dialog will queue if a FOREGROUND or BACKGROUND dialog is active and play when they are complete.
script static real DEF_DIALOG_STYLE_SKIP()										3.0;	end					//	Dialog will skip if a dialog is active of the same type
script static real DEF_DIALOG_STYLE_SKIP_FOREGROUND()					3.1;	end					//	Dialog will skip if a FOREGROUND dialog is active.
script static real DEF_DIALOG_STYLE_SKIP_BACKGROUND()					3.2;	end					//	Dialog will skip if a BACKGROUND dialog is active.
script static real DEF_DIALOG_STYLE_SKIP_ALL()								3.9;	end					//	Dialog will skip if a FOREGROUND or BACKGROUND dialog is active.

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_style_action: Checks if a dialog style is interrupt
script static boolean sys_dialog_style_action( string str_name, long l_id, real r_type, real r_style )
local boolean b_return = TRUE;
local real r_check_type = DEF_DIALOG_TYPE_ALL();
sys_dialog_debug( "sys_dialog_style_action", "" );
sys_dialog_inspect_str( "sys_dialog_style_action - str_name", str_name );
sys_dialog_inspect_l( "sys_dialog_style_action - l_id", l_id );
sys_dialog_inspect_r( "sys_dialog_style_action - r_type", r_type );

	// PLAY STYLE
	if ( sys_dialog_style_play(r_style) ) then
		sys_dialog_debug( "sys_dialog_style_action", "PLAY: START" );
		if ( not sys_dialog_type_background(r_type) ) then
			breakpoint( "sys_dialog_style_action: DEF_DIALOG_STYLE_PLAY() style dialogs only work with BACKGROUND types" );
			sleep( 1 );
		end
		sys_dialog_debug( "sys_dialog_style_action", "PLAY: END" );
	end

	// SKIP STYLE
	if ( sys_dialog_style_skip(r_style) ) then
		sys_dialog_debug( "sys_dialog_style_action", "SKIP: START" );

		// set check type
		if ( r_style == DEF_DIALOG_STYLE_SKIP() ) then
			r_check_type = r_type;
		end
		if ( r_style == DEF_DIALOG_STYLE_SKIP_FOREGROUND() ) then
			r_check_type = DEF_DIALOG_TYPE_FOREGROUND();
		end
		if ( r_style == DEF_DIALOG_STYLE_SKIP_BACKGROUND() ) then
			r_check_type = DEF_DIALOG_TYPE_BACKGROUND();
		end

		// check if that dialog type is not active
		b_return = not dialog_type_active_check( r_check_type );

		sys_dialog_debug( "sys_dialog_style_action", "SKIP: END" );
	end

	// INTERRUPT & QUEUE STYLE
	if ( sys_dialog_style_interrupt(r_style) or sys_dialog_style_queue(r_style) ) then
		sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: GET CHECK TYPE" );

		// get the check type
		if ( (r_style == DEF_DIALOG_STYLE_INTERRUPT()) or (r_style == DEF_DIALOG_STYLE_QUEUE()) ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = r_type" );
			r_check_type = r_type;
		end
		if ( (r_style == DEF_DIALOG_STYLE_INTERRUPT_FOREGROUND()) or (r_style == DEF_DIALOG_STYLE_QUEUE_FOREGROUND()) ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_TYPE_FOREGROUND()" );
			r_check_type = DEF_DIALOG_TYPE_FOREGROUND();
		end
		if ( (r_style == DEF_DIALOG_STYLE_INTERRUPT_BACKGROUND()) or (r_style == DEF_DIALOG_STYLE_QUEUE_BACKGROUND()) ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_STYLE_INTERRUPT_BACKGROUND()" );
			r_check_type = DEF_DIALOG_TYPE_BACKGROUND();
		end
		if ( (r_style == DEF_DIALOG_STYLE_INTERRUPT_ALL()) or (r_style == DEF_DIALOG_STYLE_QUEUE_ALL()) ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_TYPE_ALL()" );
			r_check_type = DEF_DIALOG_TYPE_ALL();
		end

		// if a dialog of the checktype is active, it gets put in the queue
		if ( dialog_type_active_check(r_check_type) ) then

			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: START" );
		
			// increment counters
			sys_dialog_type_queue_inc( r_type, 1 );
			if ( sys_dialog_style_interrupt(r_style) ) then
				sys_dialog_interrupt_type_queue_inc( r_check_type, 1 );
			end

			// wait for time to play
			sleep_until( ((not dialog_type_active_check(r_check_type)) and (sys_dialog_style_interrupt(r_style) or (sys_dialog_interrupt_type_queue_cnt(r_type) == 0))) or sys_dialog_type_unqueue_check(r_type, str_name), 1 );
			b_return = not sys_dialog_type_unqueue_check( r_type, str_name );
			
			if ( dialog_debug_details_get() ) then
				dprint( "-------------------------------------" );
				inspect( str_name );
				dprint( "dialog_type_active_check(r_check_type)" );
				inspect( dialog_type_active_check(r_check_type) );
				dprint( "sys_dialog_style_interrupt(r_style)" );
				inspect( sys_dialog_style_interrupt(r_style) );			
				dprint( "sys_dialog_interrupt_type_queue_cnt(r_type)" ); 
				inspect( sys_dialog_interrupt_type_queue_cnt(r_type) );			
				dprint( "sys_dialog_type_unqueue_check(r_type, str_name)" );
				inspect( sys_dialog_type_unqueue_check(r_type, str_name) );			
				dprint( "return" );
				inspect( b_return );			
				//dprint( "" );
				//inspect( xxx );			
				dprint( "-------------------------------------" );
			end

			// decrement counters
			if ( sys_dialog_style_interrupt(r_style) ) then
				sys_dialog_interrupt_type_queue_inc( r_check_type, -1 );
			end
			sys_dialog_type_queue_inc( r_type, -1 );

			// set any unqueue SUCCESS
			if ( not b_return ) then
				sys_dialog_debug( "sys_dialog_style_action", "QUEUE: not b_return" );
				sys_dialog_type_unqueue_success_set( r_type, str_name );
			end

			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT/QUEUE: END" );
		
		end

	end
	
	// RETURN
	b_return;
end

// === sys_dialog_style_play: Checks if a dialog style is auto play
script static boolean sys_dialog_style_play( real r_style )
	( r_style == DEF_DIALOG_STYLE_PLAY() );
end
// === sys_dialog_style_interrupt: Checks if a dialog style is interrupt
script static boolean sys_dialog_style_interrupt( real r_style )
	( r_style == DEF_DIALOG_STYLE_INTERRUPT() ) and ( r_style <= DEF_DIALOG_STYLE_INTERRUPT_ALL() );
end
// === sys_dialog_style_queue: Checks if a dialog style is queue
script static boolean sys_dialog_style_queue( real r_style )
	( r_style >= DEF_DIALOG_STYLE_QUEUE() ) and ( r_style <= DEF_DIALOG_STYLE_QUEUE_ALL() );
end
// === sys_dialog_style_skip: Checks if a dialog style is skip
script static boolean sys_dialog_style_skip( real r_style )
	( r_style >= DEF_DIALOG_STYLE_SKIP() ) and ( r_style <= DEF_DIALOG_STYLE_SKIP_ALL() );
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: SPEAKERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// DEFINES -----------------------------------------------------------------------------------------
script static string DEF_DIALOG_SPEAKER_ID_NONE()				"";						end				// NONE
script static string DEF_DIALOG_SPEAKER_ID_CHIEF()			"CHIEF";			end				// CHIEF
script static string DEF_DIALOG_SPEAKER_ID_CORTANA()		"CORTANA";		end				// CORTANA
script static string DEF_DIALOG_SPEAKER_ID_DIDACT()			"DIDACT";			end				// DIDACT
script static string DEF_DIALOG_SPEAKER_ID_NPC()				"[NPC]";			end				// NPC (GENERIC)
script static string DEF_DIALOG_SPEAKER_ID_RADIO()			"[RADIO]";		end				// RADIO
script static string DEF_DIALOG_SPEAKER_ID_OTHER()			"[OTHER]";		end				// OTHER

// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: ID
// =================================================================================================
// =================================================================================================
// =================================================================================================
// DEFINES -----------------------------------------------------------------------------------------
script static long DEF_DIALOG_ID_NONE()								 0;		end					// Blank dialog id; uninitialized
script static long DEF_DIALOG_ID_INVALID()					-666;		end					// Invalid dialog ID, will disable a dialog from triggering again

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// =================================================================================================
// DIALOG: ID: VALID
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; dialog id is valid (active or has played but not invalid)
script static boolean dialog_id_valid_check( long l_id )
	( not dialog_id_invalid_check(l_id) ) and ( not dialog_id_none_check(l_id) );
end
// === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; dialog ID is invalid
script static boolean dialog_id_invalid_check( long l_id )
	( l_id == DEF_DIALOG_ID_INVALID() );
end
// === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; dialog id == DEF_DIALOG_ID_NONE()
script static boolean dialog_id_none_check( long l_id )
	( l_id == DEF_DIALOG_ID_NONE() );
end

// === dialog_id_played_check: Checks if a dialog id has played
//			NOTE: This requires that you use the same variable to track a conversation and the standard dialog system.  The dialog ID (really a thread ID) has to not be NONE and the thread is no longer active for this trigger to work properly.
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; Checks if the dialog ID has no longer active (playing)
script static boolean dialog_id_played_check( long l_id )
	( l_id != DEF_DIALOG_ID_NONE() ) and ( not IsThreadValid(l_id) );
end

// =================================================================================================
// DIALOG: ID: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_id_check: Checks if this is the current foreground ID
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; dialog id is the current active FOREGROUND dialog id
script static boolean dialog_foreground_id_check( long l_id )
	( l_id != DEF_DIALOG_ID_NONE() ) and ( l_id == dialog_foreground_current_get() );
end

// === dialog_foreground_current_get: Gets the current FOREGROUND dialog id
//	RETURN:		[long] Currrent FOREGROUND dialog ID
script static long dialog_foreground_current_get()
	L_dialog_foreground_id_current;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static long 	L_dialog_foreground_id_current									= DEF_DIALOG_ID_NONE();

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_current_set: Sets the current active foreground dialog ID
script static void sys_dialog_foreground_current_set( long l_id )
sys_dialog_debug( "sys_dialog_foreground_current_set", "" );
sys_dialog_inspect_l( "sys_dialog_foreground_current_set - l_id", l_id );
	L_dialog_foreground_id_current = l_id;
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: ACTIVE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_active_check: Checks if any dialog is active
//	RETURN:		[boolean] TRUE; there is any covnersation active
script static boolean dialog_active_check()
	dialog_active_cnt() > 0;
end

// =================================================================================================
// DIALOG: ACTIVE: ID
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_id_active_check: Checks if the dialog ID thread is active
//			l_id = Dialog ID to check if it's active
//	RETURN:		[boolean] TRUE; if it is active
script static boolean dialog_id_active_check( long l_id )
	dialog_foreground_id_active_check( l_id ) or dialog_background_id_active_check( l_id );
end

// =================================================================================================
// DIALOG: ACTIVE: TYPE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === covnersation: Checks if any dialog of r_type is active
//	RETURN:		[boolean] TRUE; there is any covnersation active
script static boolean dialog_type_active_check( real r_type )
	( sys_dialog_type_foreground(r_type) and dialog_foreground_current_active_check() ) or ( sys_dialog_type_background(r_type) and dialog_background_active_check() );	
end

// =================================================================================================
// DIALOG: ACTIVE: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_id_active_check: Checks if the id is the current and active FOREGROUND dialog
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; dialog ID is active and the current FOREGROUND dialog ID
script static boolean dialog_foreground_id_active_check( long l_id )
	dialog_foreground_id_check( l_id ) and IsThreadValid( l_id );
end

// === dialog_foreground_current_active_check: Checks if the current FOREGROUND dialog id is active
//	RETURN:		[boolean] TRUE; It is active (playing)
script static boolean dialog_foreground_current_active_check()
	dialog_foreground_id_active_check( dialog_foreground_current_get() );
end

// === dialog_foreground_active_check: Checks if there are any FOREGROUND dialogs active
//	RETURN:		[boolean] TRUE; There is at least one FOREGROUND dialog ID active
script static boolean dialog_foreground_active_check()
	dialog_foreground_active_cnt() > 0;
end

// =================================================================================================
// DIALOG: ACTIVE: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_id_active_check: Checks if the id is an active BACKGROUND dialog
//			l_id = Dialog ID to check
//	RETURN:		[boolean] TRUE; The dialog id is an active (playing) BACKGROUND dialog
script static boolean dialog_background_id_active_check( long l_id )
	( l_id != DEF_DIALOG_ID_NONE() ) and ( l_id != dialog_foreground_current_get() ) and IsThreadValid(l_id);
end

// === dialog_background_active_check: Checks if there are any BACKGROUND dialogs active
//	RETURN:		[boolean] TRUE; There is at least one BACKGROUND dialog ID active
script static boolean dialog_background_active_check()
	dialog_background_active_cnt() > 0;
end

// =================================================================================================
// DIALOG: ACTIVE: CNT
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_active_cnt: Gets the total active dialogs
//	RETURN:		[short] Total active dialogs
script static short dialog_active_cnt()
	dialog_foreground_active_cnt() + dialog_background_active_cnt();
end

// =================================================================================================
// DIALOG: ACTIVE: CNT: TYPE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_type_active_cnt: Gets the current count of active dialogs of a type
//			r_type = Dialog type to check
//	RETURN:		[short] Total active dialogs of the type
script static short dialog_type_active_cnt( real r_type )
local short s_return = 0;

	if ( sys_dialog_type_foreground(r_type) ) then
		s_return = dialog_foreground_active_cnt();
	end
	if ( sys_dialog_type_background(r_type) ) then
		s_return = dialog_background_active_cnt();
	end

	// RETURN
	s_return;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_dialog_type_active_inc: Increments the count of type active dialogs
script static void sys_dialog_type_active_inc( real r_type, short s_inc )
sys_dialog_debug( "sys_dialog_type_active_inc", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		sys_dialog_foreground_active_inc( s_inc );
	end
	if ( sys_dialog_type_background(r_type) ) then
		sys_dialog_background_active_inc( s_inc );
	end
	
end

// =================================================================================================
// DIALOG: ACTIVE: CNT: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_active_cnt: Gets the total count of FOREGROUND dialogs active
//	RETURN:		[short] Total count of FOREGROUND dialogs active
script static short dialog_foreground_active_cnt()
	S_dialog_foreground_active_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_foreground_active_cnt								= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_active_inc: Increments the count of foreground active dialogs
script static void sys_dialog_foreground_active_inc( short s_inc )
sys_dialog_debug( "sys_dialog_foreground_active_inc", "" );

	S_dialog_foreground_active_cnt = S_dialog_foreground_active_cnt + s_inc;
	if ( S_dialog_foreground_active_cnt < 0 ) then
		S_dialog_foreground_active_cnt = 0;
	end

end

// =================================================================================================
// DIALOG: ACTIVE: CNT: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_active_cnt: Gets the total count of BACKGROUND dialogs active
//	RETURN:		[short] Total count of BACKGROUND dialogs active
script static short dialog_background_active_cnt()
	S_dialog_background_active_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_background_active_cnt								= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_background_active_inc: Increments the count of background active dialogs
script static void sys_dialog_background_active_inc( short s_inc )
sys_dialog_debug( "sys_dialog_background_active_inc", "" );

	S_dialog_background_active_cnt = S_dialog_background_active_cnt + s_inc;
	if ( S_dialog_background_active_cnt < 0 ) then
		S_dialog_background_active_cnt = 0;
	end

end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: NAME
// =================================================================================================
// =================================================================================================
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_name_valid_check: Checks if a dialog name is valid to use
//	RETURN:		[boolean] TRUE; if the name is acceptable
script static boolean dialog_name_valid_check( string str_name )
	( str_name != DEF_STR_DIALOG_NAME_NONE() ) and ( str_name != DEF_STR_DIALOG_NAME_ALL() );
end

// === dialog_foreground_name_get: Gets the name of the current foreground dialog
//	RETURN:		[string] Name of the current foreground dialog
script static string dialog_foreground_name_get()
	STR_dialog_foreground_name_current;
end

// === dialog_foreground_current_name_check: Checks if the current FOREGROUND dialog is name
//	RETURN:		[boolean] XXX
script static boolean dialog_foreground_current_name_check( string str_name )
	dialog_foreground_name_get() == str_name;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// DEFINES -----------------------------------------------------------------------------------------
script static string DEF_STR_DIALOG_NAME_NONE()			"";						end		// blank dialog name
script static string DEF_STR_DIALOG_NAME_ALL()			"[ALL]";			end		// dialog name all, mainly for unqueuing dialogs

// VARIABLES ---------------------------------------------------------------------------------------
static string 	STR_dialog_foreground_name_current						= DEF_STR_DIALOG_NAME_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_current_name_set: Sets the current FOREGROUND dialog name value
//		b_name = TRUE; current foreground conversation should be name
script static void sys_dialog_foreground_current_name_set( string str_name )
sys_dialog_debug( "dialog_foreground_current_name_set", "" );
	sys_dialog_foreground_id_name_set( dialog_foreground_current_get(), str_name );
end

// === dialog_foreground_id_name_set: Sets the dialog id name value if it is the current active FOREGROUND dialog
//		l_dialog_id = Dialog ID to set name
//		str_name = New name for the current foreground dialog
script static void sys_dialog_foreground_id_name_set( long l_dialog_id, string str_name )
sys_dialog_debug( "dialog_foreground_id_name_set", "" );

	if ( dialog_foreground_id_active_check(l_dialog_id) ) then
		sys_dialog_foreground_name_set( str_name );
	end
end

// === dialog_foreground_name_get: Gets the name of the current foreground dialog
//	RETURN:		[string] Name of the current foreground dialog
script static void sys_dialog_foreground_name_set( string str_name )
	STR_dialog_foreground_name_current = str_name;
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: BACK PAD
// =================================================================================================
// =================================================================================================
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_back_pad_default_set: Sets the default pad time
//		r_time = Time (seconds) for the default queue pad time
script static void dialog_back_pad_default_set( real r_time )
sys_dialog_debug( "dialog_back_pad_default_set", "" );
	r_dialog_back_pad_default = r_time;
end
// === dialog_back_pad_default_get: Gets the default pad time
//	RETURN:		[REAL] Current default queue pad time (seconds)
script static real dialog_back_pad_default_get()
	// RETURN
	r_dialog_back_pad_default;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// TODO --------------------------------------------------------------------------------------------
// XXX ADD SEPERATE BACK PAD DEFAULTS FOR EACH TYPE

// VARIABLES ---------------------------------------------------------------------------------------
static real 	r_dialog_back_pad_default										= 0.0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_style_use_back_pad: Checks if this style uses back_pad on dialogs
script static boolean sys_dialog_style_use_back_pad( real r_style )
	( (r_style >= DEF_DIALOG_STYLE_INTERRUPT()) and (r_style <= DEF_DIALOG_STYLE_QUEUE_BACKGROUND()) );
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: INTERRUPTABLE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_interruptable_get: XXXX
//	RETURN:		[boolean] XXX
script static boolean dialog_foreground_interruptable_get()
	b_dialog_foreground_interruptable;
end

// === dialog_foreground_current_interruptable_check: Checks if the current FOREGROUND dialog is interruptable
//	RETURN:		[boolean] XXX
script static boolean dialog_foreground_current_interruptable_check()
	dialog_foreground_interruptable_get() or  ( not dialog_foreground_current_active_check() );  
end

// === dialog_id_interruptable_check: Checks if this is the current FOREGROUND id and if it's interruptable
//	RETURN:		[boolean] TRUE; it's not the current FOREGROUND id or it's interruptable
script static boolean dialog_id_interruptable_check( long l_dialog_id )
	not dialog_foreground_id_active_check(l_dialog_id) or dialog_foreground_interruptable_get();
end

// === dialog_foreground_current_interruptable_set: Sets the current FOREGROUND dialog interruptable value
//		b_interruptable = TRUE; current foreground conversation should be interruptable
//	RETURN:		[boolean] XXX
script static boolean dialog_foreground_current_interruptable_set( boolean b_interruptable )
sys_dialog_debug( "dialog_foreground_current_interruptable_set", "" );
	dialog_foreground_id_interruptable_set( dialog_foreground_current_get(), b_interruptable );
end

// === dialog_foreground_id_interruptable_set: Sets the dialog id interruptable value if it is the current active FOREGROUND dialog
//		l_dialog_id = Dialog ID to set interruptable
//		b_interruptable = TRUE; current foreground conversation should be interruptable
//	RETURN:		[boolean] XXX
script static boolean dialog_foreground_id_interruptable_set( long l_dialog_id, boolean b_interruptable )
local boolean b_return = FALSE;
sys_dialog_debug( "dialog_foreground_id_interruptable_set", "" );

	if ( dialog_foreground_id_active_check(l_dialog_id) ) then
		sys_dialog_foreground_interruptable_set( b_interruptable );
		b_return = FALSE;
	end

	// RETURN
	b_return;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static boolean 	b_dialog_foreground_interruptable										= FALSE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_interruptable_set: XXXX
//		b_interruptable = XXXX
script static void sys_dialog_foreground_interruptable_set( boolean b_interruptable )
sys_dialog_debug( "sys_dialog_foreground_interruptable_set", "" );
	b_dialog_foreground_interruptable = b_interruptable;
end




// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: QUEUE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_queue_cnt: Gets the total count of FOREGROUND and BACKGROUND dialogs queue'd
//	RETURN:		[short] Total count of FOREGROUND and BACKGROUND dialogs queue'd
script static short dialog_queue_cnt()
	dialog_foreground_queue_cnt() + dialog_background_queue_cnt();
end

// =================================================================================================
// DIALOG: QUEUE: TYPE
// =================================================================================================

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_queue_inc: Increments a type que cnt
script static void sys_dialog_type_queue_inc( real r_type, short s_inc )
sys_dialog_debug( "sys_dialog_type_queue_inc", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		sys_dialog_foreground_queue_inc( s_inc );
	end
	if ( sys_dialog_type_background(r_type) ) then
		sys_dialog_background_queue_inc( s_inc );
	end

end

// =================================================================================================
// DIALOG: QUEUE: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_queue_cnt: Gets the total count of FOREGROUND dialogs queue'd
//	RETURN:		[short] Total count of FOREGROUND dialogs queue'd
script static short dialog_foreground_queue_cnt()
	S_dialog_foreground_queue_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_foreground_queue_cnt								= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_queue_inc: Increments the count of foreground queue'd dialogs
script static void sys_dialog_foreground_queue_inc( short s_inc )
sys_dialog_debug( "sys_dialog_foreground_queue_inc", "" );

	S_dialog_foreground_queue_cnt = S_dialog_foreground_queue_cnt + s_inc;
	if ( S_dialog_foreground_queue_cnt < 0 ) then
		S_dialog_foreground_queue_cnt = 0;
	end

end

// =================================================================================================
// DIALOG: QUEUE: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_queue_cnt: Gets the total count of BACKGROUND dialogs queue'd
//	RETURN:		[short] Total count of BACKGROUND dialogs queue'd
script static short dialog_background_queue_cnt()
	S_dialog_background_queue_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_background_queue_cnt							= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_background_queue_inc: Increments the count of background queue'd dialogs
script static void sys_dialog_background_queue_inc( short s_inc )
sys_dialog_debug( "sys_dialog_background_queue_inc", "" );

	S_dialog_background_queue_cnt = S_dialog_background_queue_cnt + s_inc;
	if ( S_dialog_background_queue_cnt < 0 ) then
		S_dialog_background_queue_cnt = 0;
	end

end


// =================================================================================================
// =================================================================================================
// DIALOG: QUEUE: INTERRUPT
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_interrupt_queue_cnt: Gets the total count of FOREGROUND and BACKGROUND interrupt dialogs queue'd
//	RETURN:		[short] Total count of FOREGROUND and BACKGROUND dialogs queue'd
script static short dialog_interrupt_queue_cnt()
	dialog_interrupt_foreground_queue_cnt() + dialog_interrupt_background_queue_cnt();
end

// =================================================================================================
// DIALOG: QUEUE: INTERRUPT: TYPE
// =================================================================================================

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_interrupt_type_queue_inc: Increments a type que cnt
script static void sys_dialog_interrupt_type_queue_inc( real r_type, short s_inc )
sys_dialog_debug( "sys_dialog_interrupt_type_queue_inc", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		sys_dialog_interrupt_foreground_queue_inc( s_inc );
	end
	if ( sys_dialog_type_background(r_type) ) then
		sys_dialog_interrupt_background_queue_inc( s_inc );
	end

end

// === sys_dialog_interrupt_type_queue_cnt: Increments a type que cnt
script static short sys_dialog_interrupt_type_queue_cnt( real r_type )
local short s_cnt = 0;
	if ( sys_dialog_type_foreground(r_type) ) then
		s_cnt = dialog_interrupt_foreground_queue_cnt();
	end
	if ( sys_dialog_type_background(r_type) ) then
		s_cnt = dialog_interrupt_background_queue_cnt();
	end
	
	// returns
	s_cnt;
end

// =================================================================================================
// DIALOG: QUEUE: INTERRUPT: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_interrupt_foreground_queue_cnt: Gets the total count of FOREGROUND dialogs queue'd
//	RETURN:		[short] Total count of FOREGROUND dialogs queue'd
script static short dialog_interrupt_foreground_queue_cnt()
	S_dialog_interrupt_foreground_queue_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_interrupt_foreground_queue_cnt								= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_interrupt_foreground_queue_inc: Increments the count of foreground queue'd dialogs
script static void sys_dialog_interrupt_foreground_queue_inc( short s_inc )
sys_dialog_debug( "sys_dialog_interrupt_foreground_queue_inc", "" );

	S_dialog_interrupt_foreground_queue_cnt = S_dialog_interrupt_foreground_queue_cnt + s_inc;
	if ( S_dialog_interrupt_foreground_queue_cnt < 0 ) then
		S_dialog_interrupt_foreground_queue_cnt = 0;
	end

	sys_dialog_inspect_s( "sys_dialog_interrupt_foreground_queue_inc - S_dialog_interrupt_foreground_queue_cnt", S_dialog_interrupt_foreground_queue_cnt );
end

// =================================================================================================
// DIALOG: QUEUE: INTERRUPT: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_interrupt_background_queue_cnt: Gets the total count of BACKGROUND dialogs queue'd
//	RETURN:		[short] Total count of BACKGROUND dialogs queue'd
script static short dialog_interrupt_background_queue_cnt()
	S_dialog_interrupt_background_queue_cnt;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static short 	S_dialog_interrupt_background_queue_cnt							= 0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_interrupt_background_queue_inc: Increments the count of background queue'd dialogs
script static void sys_dialog_interrupt_background_queue_inc( short s_inc )
sys_dialog_debug( "sys_dialog_interrupt_background_queue_inc", "" );

	S_dialog_interrupt_background_queue_cnt = S_dialog_interrupt_background_queue_cnt + s_inc;
	if ( S_dialog_interrupt_background_queue_cnt < 0 ) then
		S_dialog_interrupt_background_queue_cnt = 0;
	end

	sys_dialog_inspect_s( "sys_dialog_interrupt_background_queue_inc - S_dialog_interrupt_background_queue_cnt", S_dialog_interrupt_background_queue_cnt );
end


// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: UNQUEUE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_unqueue_name: Unque's FOREGROUND and BACKGROUND dialogs with the name
//		str_name = Name of the dialog being queue'd to unqueue
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue'd a FOREGROUND and BACKGROUND dialog with this name
script static boolean dialog_unqueue_name( string str_name, real r_timeout )
local long l_foreground_thread = 0;
local long l_background_thread = 0;
sys_dialog_debug( "dialog_unqueue_name", "" );

	// setup threads to kill each type of the same name
	l_foreground_thread = thread( dialog_foreground_unqueue_name(str_name, r_timeout) );
	l_background_thread = thread( dialog_background_unqueue_name(str_name, r_timeout) );

	// wait for the threads to finish
	sleep_until( (not IsThreadValid(l_foreground_thread)) and (not IsThreadValid(l_background_thread)), 1 );

	// RETURN
	( str_name == sys_dialog_foreground_unqueue_success_get() ) or ( str_name == sys_dialog_background_unqueue_success_get() ) or ( dialog_foreground_queue_cnt() <= 0 );

end

// === dialog_unqueue_all: Unque's all FOREGROUND and BACKGROUND dialogs
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue's all the FOREGROUND and BACKGROUND dialogs
script static boolean dialog_unqueue_all( real r_timeout )
sys_dialog_debug( "dialog_unqueue_all", "" );
	dialog_unqueue_name( DEF_STR_DIALOG_NAME_ALL, r_timeout );
end

// === dialog_unqueue_active: Checks if a FOREGROUND or BACKGROUND dialog unqueue is active
//	RETURN:		[boolean] TRUE; FOREGROUND or BACKGROUND dialog unqueue is active
script static boolean dialog_unqueue_active()
	dialog_foreground_unqueue_active() or dialog_background_unqueue_active();
end

// =================================================================================================
// DIALOG: UNQUEUE: TYPE
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_type_unqueue_active: Checks if a type of dialog has an unqueue action active
//	RETURN:		[boolean] TRUE; If there is an unqueue queue active of this r_type
script static boolean dialog_type_unqueue_active( real r_type )
	( sys_dialog_type_foreground(r_type) and dialog_foreground_unqueue_active() ) or ( sys_dialog_type_background(r_type) and dialog_background_unqueue_active() );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_unqueue_check: Checks if this is a dialog of this type that should be unqueue'd
//	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
script static boolean sys_dialog_type_unqueue_check( real r_type, string str_name )
	( sys_dialog_type_foreground(r_type) and sys_dialog_foreground_unqueue_check(str_name) ) or ( sys_dialog_type_background(r_type) and sys_dialog_background_unqueue_check(str_name) );
end

// === sys_dialog_type_unqueue_success_set: XXX
script static void sys_dialog_type_unqueue_success_set( real r_type, string str_name )
sys_dialog_debug( "sys_dialog_type_unqueue_success_set", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		sys_dialog_foreground_unqueue_success_set( str_name );
	end
	if ( sys_dialog_type_background(r_type) ) then
		sys_dialog_background_unqueue_success_set( str_name );
	end
	
end

// =================================================================================================
// DIALOG: UNQUEUE: FOREGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_foreground_unqueue_name: Unque's FOREGROUND dialogs with the name
//		str_name = Name of the dialog being queue'd to unqueue
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue'd a FOREGROUND dialog with this name
script static boolean dialog_foreground_unqueue_name( string str_name, real r_timeout )
local boolean b_return = FALSE;
local long l_timeout = 0;
sys_dialog_debug( "dialog_foreground_unqueue_name", "" );

	if ( str_name != DEF_STR_DIALOG_NAME_NONE() ) then
		// start
		l_timeout = game_tick_get() + seconds_to_frames( r_timeout );
	
		// wait for other unques to finish or if DEF_STR_DIALOG_NAME_ALL() take over unqueue
		sleep_until( (dialog_foreground_queue_cnt() <= 0) or (not dialog_foreground_unqueue_active()) or (game_tick_get() > l_timeout) or ((str_name == DEF_STR_DIALOG_NAME_ALL) and (sys_dialog_foreground_unqueue_get() != DEF_STR_DIALOG_NAME_ALL)), 1 );
		
		// set which dialog name to unqueue
		sys_dialog_foreground_unqueue_set( str_name );
		
		// set the success check to none before attempting unqueue
		sys_dialog_foreground_unqueue_success_set( DEF_STR_DIALOG_NAME_NONE() );
	
		// wait for the unqueue to cycle
		sleep_until( (dialog_foreground_queue_cnt() <= 0) or (not dialog_foreground_unqueue_active()) or (game_tick_get() > l_timeout), 1 );
	
		// check for success
		b_return = ( str_name == sys_dialog_foreground_unqueue_success_get() ) or ( dialog_foreground_queue_cnt() <= 0 );
		
		// release the unqueue variable if it's still current
		if ( str_name == sys_dialog_foreground_unqueue_get() ) then
			sys_dialog_foreground_unqueue_set( DEF_STR_DIALOG_NAME_NONE() );
		end
	else
		breakpoint( "dialog_foreground_unqueue_name: INVALID DIALOG NAME" );
		sleep( 1 );
	end

	// RETURN
	b_return;

end

// === dialog_foreground_unqueue_all: Unque's all FOREGROUND dialogs
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue's all the FOREGROUND dialogs
script static boolean dialog_foreground_unqueue_all( real r_timeout )
sys_dialog_debug( "dialog_foreground_unqueue_all", "" );
	dialog_foreground_unqueue_name( DEF_STR_DIALOG_NAME_ALL, r_timeout );
end

// === dialog_foreground_unqueue_active: Checks if a FOREGROUND dialog unqueue is active 
//	RETURN:		[boolean] TRUE; FOREGROUND dialog unqueue is active
script static boolean dialog_foreground_unqueue_active()
	sys_dialog_foreground_unqueue_get() != DEF_STR_DIALOG_NAME_NONE;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static string	STR_dialog_foreground_unqueue_name					= DEF_STR_DIALOG_NAME_NONE;
static string	STR_dialog_foreground_unqueue_success				= DEF_STR_DIALOG_NAME_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_foreground_unqueue_set: Sets the name of the FOREGROUND dialog to unqueue
script static void sys_dialog_foreground_unqueue_set( string str_name )
sys_dialog_debug( "sys_dialog_foreground_unqueue_set", "" );
	STR_dialog_foreground_unqueue_name != DEF_STR_DIALOG_NAME_NONE;
end
// === sys_dialog_foreground_unqueue_get: Gets the name of the FOREGROUND dialog being unqueue'd
//	RETURN:		[string] Name of the FOREGROUND dialog being unqueue'd
script static string sys_dialog_foreground_unqueue_get()
	STR_dialog_foreground_unqueue_name;
end
// === sys_dialog_foreground_unqueue_check: Checks if this is a FOREGROUND dialog that should be unqueue'd
//	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
script static boolean sys_dialog_foreground_unqueue_check( string str_name )
	( sys_dialog_foreground_unqueue_get() == str_name ) or ( sys_dialog_foreground_unqueue_get() == DEF_STR_DIALOG_NAME_ALL() );
end

// === sys_dialog_foreground_unqueue_success_set: Sets the name of the FOREGROUND dialog that was unqueue'd
script static void sys_dialog_foreground_unqueue_success_set( string str_name )
sys_dialog_debug( "sys_dialog_foreground_unqueue_success_set", "" );
	str_dialog_foreground_unqueue_success = str_name;
end
// === sys_dialog_foreground_unqueue_success_get: Gets the name of the FOREGROUND dialog that was unqueue'd
//	RETURN:		[string] Name of the FOREGROUND dialog that was unqueue'd
script static string sys_dialog_foreground_unqueue_success_get()
	str_dialog_foreground_unqueue_success;
end

// =================================================================================================
// DIALOG: UNQUEUE: BACKGROUND
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_background_unqueue_name: Unque's BACKGROUND dialogs with the name
//		str_name = Name of the dialog being queue'd to unqueue
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue'd a BACKGROUND dialog with this name
script static boolean dialog_background_unqueue_name( string str_name, real r_timeout )
local boolean b_return = FALSE;
local long l_timeout = 0;
sys_dialog_debug( "dialog_background_unqueue_name", "" );

	if ( str_name != DEF_STR_DIALOG_NAME_NONE() ) then
		// start
		l_timeout = game_tick_get() + seconds_to_frames( r_timeout );
	
		// wait for other unques to finish or if DEF_STR_DIALOG_NAME_ALL() take over unqueue
		sleep_until( (dialog_background_queue_cnt() <= 0) or (not dialog_background_unqueue_active()) or (game_tick_get() > l_timeout) or ((str_name == DEF_STR_DIALOG_NAME_ALL) and (sys_dialog_background_unqueue_get() != DEF_STR_DIALOG_NAME_ALL)), 1 );
		
		// set which dialog name to unqueue
		sys_dialog_background_unqueue_set( str_name );
		
		// set the success check to none before attempting unqueue
		sys_dialog_background_unqueue_success_set( DEF_STR_DIALOG_NAME_NONE() );
	
		// wait for the unqueue to cycle
		sleep_until( (dialog_background_queue_cnt() <= 0) or (not dialog_background_unqueue_active()) or (game_tick_get() > l_timeout), 1 );
	
		// check for success
		b_return = ( str_name == sys_dialog_background_unqueue_success_get() ) or ( dialog_background_queue_cnt() <= 0 );
		
		// release the unqueue variable if it's still current
		if ( str_name == sys_dialog_background_unqueue_get() ) then
			sys_dialog_background_unqueue_set( DEF_STR_DIALOG_NAME_NONE() );
		end
	else
		breakpoint( "dialog_background_unqueue_name: INVALID DIALOG NAME" );
		sleep( 1 );
	end

	// RETURN
	b_return;

end

// === dialog_background_unqueue_all: Unque's all BACKGROUND dialogs
//		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
//	RETURN:		[boolean] TRUE; if it unqueue's all the BACKGROUND dialogs
script static boolean dialog_background_unqueue_all( real r_timeout )
sys_dialog_debug( "dialog_background_unqueue_all", "" );
	// RETURN
	dialog_background_unqueue_name( DEF_STR_DIALOG_NAME_ALL, r_timeout );
end

// === dialog_background_unqueue_active: Checks if a BACKGROUND dialog unqueue is active
//	RETURN:		[boolean] TRUE; BACKGROUND dialog unqueue is active
script static boolean dialog_background_unqueue_active()
	sys_dialog_background_unqueue_get() != DEF_STR_DIALOG_NAME_NONE;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static string	STR_dialog_background_unqueue_name				= DEF_STR_DIALOG_NAME_NONE;
static string	STR_dialog_background_unqueue_success			= DEF_STR_DIALOG_NAME_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_background_unqueue_set: Sets the name of the BACKGROUND dialog to unqueue
script static void sys_dialog_background_unqueue_set( string str_name )
sys_dialog_debug( "sys_dialog_background_unqueue_set", "" );
	STR_dialog_background_unqueue_name != DEF_STR_DIALOG_NAME_NONE;
end
// === sys_dialog_background_unqueue_get: Gets the name of the BACKGROUND dialog being unqueue'd
//	RETURN:		[string] Name of the BACKGROUND dialog being unqueue'd
script static string sys_dialog_background_unqueue_get()
	STR_dialog_background_unqueue_name;
end
// === sys_dialog_background_unqueue_check: Checks if this is a BACKGROUND dialog that should be unqueue'd
//	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
script static boolean sys_dialog_background_unqueue_check( string str_name )
	( sys_dialog_background_unqueue_get() == str_name ) or ( sys_dialog_background_unqueue_get() == DEF_STR_DIALOG_NAME_ALL() );
end

// === sys_dialog_background_unqueue_success_set: Sets the name of the BACKGROUND dialog that was unqueue'd
script static void sys_dialog_background_unqueue_success_set( string str_name )
sys_dialog_debug( "sys_dialog_background_unqueue_success_set", "" );
	str_dialog_background_unqueue_success = str_name;
end
// === sys_dialog_background_unqueue_success_get: Gets the name of the BACKGROUND dialog that was unqueue'd
//	RETURN:		[string] Name of the BACKGROUND dialog that was unqueue'd
script static string sys_dialog_background_unqueue_success_get()
	str_dialog_background_unqueue_success;
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: BLURBS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_blurb_defaults: Sets the default dialog blurb values
script static void sys_dialog_blurb_defaults()
 	// Fonts:
 	// Assign the font to use. Valid options are: terminal, body, title, super_large,
	// large_body, split_screen_hud, full_screen_hud, English_body, 
	// hud_number, subtitle, main_menu. Default is “subtitle”

	set_text_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 0.22, 0.77, 0.0 );
	set_text_font( arame_regular_16 );                                                                  
	set_text_scale( 1.5 );
	
	// alignments
	set_text_alignment( bottom );
	set_text_margins( 0.05, 0.0, 0.05, 0.1 );	// l,t,r,b        
	set_text_indents( 0,0 ); 
	set_text_justification( center );
	set_text_wrap( 1, 1 );
			
	// shadow
	set_text_shadow_style( drop );							// Sets the drop shadow type. Options are drop, outline, none.
	set_text_shadow_color( 1, 0, 0, 0 );
end
// === sys_dialog_blurb: plays the dialog blurb
script static void sys_dialog_blurb( string content, real r_time )
	// display the text!
  set_text_lifespan( seconds_to_frames(r_time) );
	show_text( content );
end

// === sys_dialog_blurb_chief: Blurb
script static void sys_dialog_blurb_chief( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_chief", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 0.2, 1.0, 0.2 );
	
	// alignments
	set_text_margins( 0.05, 0.0, 0.05, 0.175 );	// l,t,r,b        

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end

// === sys_dialog_blurb_cortana: Blurb
script static void sys_dialog_blurb_cortana( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_cortana", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 0.0, 0.8, 1.0 );
	
	// alignments
	set_text_margins( 0.05, 0.0, 0.05, 0.1 );	// l,r,t,b        

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end

// === sys_dialog_blurb_didact: Blurb
script static void sys_dialog_blurb_didact( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_didact", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 0.6, 0.0, 0.0 );
	
	// alignments
	set_text_margins( 0.05, 0.0, 0.05, 0.025 );	// l,t,r,b        

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end

// === sys_dialog_blurb_npc: Blurb
script static void sys_dialog_blurb_npc( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_npc", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 1.0, 1.0, 0.25 );
	
	// alignments
	set_text_margins( 0.05, 0.0, 0.05, 0.025 );	// l,t,r,b        

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end

// === sys_dialog_blurb_radio: Blurb
script static void sys_dialog_blurb_radio( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_radio", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1.0, 1.0, 0.5, 0.25 );
	
	// alignments
	set_text_margins( 0.1, 0.1375, 0.1, 0.0 );	// l,t,r,b        

	// allign off of top
	set_text_alignment( top );

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end

// === sys_dialog_blurb_other: Blurb
script static void sys_dialog_blurb_other( string content, real r_time )
sys_dialog_debug( "sys_dialog_blurb_other", "" );

	sys_dialog_blurb_defaults();
	
	// color, scale, life, font
	set_text_color( 1, 1.0, 1.0, 1.0 );
	
	// alignments
	set_text_margins( 0.05, 0.0, 0.05, 0.025 );	// l,t,r,b        

	// display the text!
	sys_dialog_blurb( content, r_time );
	
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: DEBUG
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === dialog_debug_set: Enable/disable dialog debugging
//		b_active = Enable/disable dialog debug
script static void dialog_debug_set( boolean b_active )
	b_dialog_debug = b_active;
end

// === dialog_debug_get: Gets enabled/disabled state of dialog debug
//	RETURN:		[boolean] TRUE; dialog debug is active
script static boolean dialog_debug_get()
	b_dialog_debug;
end

// === dialog_debug_set: Enable/disable dialog debugging
//		b_active = Enable/disable dialog debug
script static void dialog_debug_detail_set( boolean b_active )
	b_dialog_debug_details = b_active;
end

// === dialog_debug_details_get: Gets enabled/disabled state of dialog debug details
//	RETURN:		[boolean] TRUE; dialog debug details is active
script static boolean dialog_debug_details_get()
	b_dialog_debug_details;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
static boolean 	b_dialog_debug								= FALSE;
static boolean 	b_dialog_debug_details				= FALSE;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_debug: Displays a dialog debug message
script static void sys_dialog_debug( string s_function, string s_detail )
	if ( dialog_debug_get() and ((s_function != "") or (s_detail != "")) and (dialog_debug_details_get() or (s_detail == "")) ) then
		if ( s_detail == "" ) then
			dprint( "DIALOG DEBUG >>>>>>>>>>" );
		end
		if ( s_function != "" ) then
			dprint( s_function );
		end
		if ( s_detail != "" ) then
			dprint( s_detail );
		end
	end
end

script static void sys_dialog_inspect_r( string s_function, real r_inspect )
	if ( dialog_debug_get() ) then
		dprint( "DIALOG INSPECT $>$>$>$>$>" );
		if ( s_function != "" ) then
			dprint( s_function );
		end
		inspect( r_inspect );
	end
end

script static void sys_dialog_inspect_s( string s_function, short s_inspect )
	if ( dialog_debug_get() ) then
		dprint( "DIALOG INSPECT $>$>$>$>$>" );
		if ( s_function != "" ) then
			dprint( s_function );
		end
		inspect( s_inspect );
	end
end

script static void sys_dialog_inspect_l( string s_function, long l_inspect )
	if ( dialog_debug_get() ) then
		dprint( "DIALOG INSPECT $>$>$>$>$>" );
		if ( s_function != "" ) then
			dprint( s_function );
		end
		inspect( l_inspect );
	end
end

script static void sys_dialog_inspect_b( string s_function, boolean b_inspect )
	if ( dialog_debug_get() ) then
		dprint( "DIALOG INSPECT $>$>$>$>$>" );
		if ( s_function != "" ) then
			dprint( s_function );
		end
		inspect( b_inspect );
	end
end

script static void sys_dialog_inspect_str( string s_function, string str_inspect )
	if ( dialog_debug_get() ) then
		dprint( "DIALOG INSPECT $>$>$>$>$>" );
		if ( s_function != "" ) then
			dprint( s_function );
		end
		inspect( str_inspect );
	end
end

/*
script static void test_dialog_blurbs( real r_time )
local string str_test = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
	sys_dialog_blurb_chief( str_test, r_time );
	sys_dialog_blurb_cortana( str_test, r_time );
	//sys_dialog_blurb_didact( str_test, r_time );
	sys_dialog_blurb_npc( str_test, r_time );
	sys_dialog_blurb_radio( str_test, r_time );
	//sys_dialog_blurb_other( str_test, r_time );
end

*/



// =================================================================================================
// =================================================================================================
// =================================================================================================
// DIALOG: DEBUG
// =================================================================================================
// =================================================================================================
// =================================================================================================

script dormant f_dialog_global_my_first_domain()
dprint("f_dialog_global_my_first_domain");
					
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MY_FIRST_DOMAIN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\m20_domain_00100', FALSE, NONE, 0.0, "", "Cortana : This node is caught in a loop trying to access something it's calling the Domain.", FALSE );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\m20_domain_00101', FALSE, NONE, 0.0, "", "Cortana : An offworld data repository of some kind, though I'm only able to extract bits and pieces of the complete exchange.", FALSE );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\global\m20_domain_00102', FALSE, NONE, 0.0, "", "Cortana : I'll log it for investigation later.", FALSE );						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


/*script dormant f_dialog_callout_phantom_on_approach()
dprint("f_dialog_callout_phantom_on_approach");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PHANTOM_ON_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00107', FALSE, NONE, 0.0, "", "Cortana : Phantom on approach!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_wrong_way()
dprint("f_dialog_callout_wrong_way");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WRONG_WAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00102', FALSE, NONE, 0.0, "", "Cortana : Wrong way, Master Chief. Turn us around." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_so()
dprint("f_dialog_callout_so");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00188', FALSE, NONE, 0.0, "", "Cortana : So." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_here_they_come()
dprint("f_dialog_callout_here_they_come");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HERE_THEY_COME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00190', FALSE, NONE, 0.0, "", "Cortana : Here they come!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_get_ready()
dprint("f_dialog_callout_get_ready");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GET_READY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00189', FALSE, NONE, 0.0, "", "Cortana : Get ready!!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_hold_up()
dprint("f_dialog_callout_hold_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOLD_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00187', FALSE, NONE, 0.0, "", "Cortana : Hold up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_hold_on()
dprint("f_dialog_callout_hold_on");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOLD_ON", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00186', FALSE, NONE, 0.0, "", "Cortana : Hold on." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_wait()
dprint("f_dialog_callout_wait");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WAIT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00186', FALSE, NONE, 0.0, "", "Cortana : Wait." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_behind_you()
dprint("f_dialog_callout_behind_you");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BEHIND_YOU", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00179', FALSE, NONE, 0.0, "", "Cortana : Behind you!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_taking_fire()
dprint("f_dialog_callout_taking_fire");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TAKING_FIRE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00180', FALSE, NONE, 0.0, "", "Cortana : Taking fire." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_ok_clear()
dprint("f_dialog_callout_ok_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "OK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00183', FALSE, NONE, 0.0, "", "Cortana : OK, we're clear." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_last_of_them()
dprint("f_dialog_callout_last_of_them");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LAST_OF_THEM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00182', FALSE, NONE, 0.0, "", "Cortana : That's the last of them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_pull_up()
dprint("f_dialog_callout_pull_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PULL_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00181', FALSE, NONE, 0.0, "", "Cortana : Pull up!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_turrets()
dprint("f_dialog_callout_turrets");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00177', FALSE, NONE, 0.0, "", "Cortana : Turrets!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_go_to_the_right()
dprint("f_dialog_callout_go_to_the_right");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GO_TO_THE_RIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00141', FALSE, NONE, 0.0, "", "Cortana : Go! To the right!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_left()
dprint("f_dialog_callout_left");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GO_TO_THE_LEFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00142', FALSE, NONE, 0.0, "", "Cortana : Move left!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_additional_turrets()
dprint("f_dialog_callout_additional_turrets");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ADDITIONAL_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00178', FALSE, NONE, 0.0, "", "Cortana : They're spawning additional turrets." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_watch_out_ravine()
dprint("f_dialog_callout_watch_out_ravine");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WATCH_OUT_RAVINE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00104', FALSE, NONE, 0.0, "", "Cortana : Chief, watch out! Ravine!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_closer_to_building()
dprint("f_dialog_callout_closer_to_building");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CLOSER_TO_BUILDING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00105', FALSE, NONE, 0.0, "", "Cortana : Chief, that structure–over the next rise.  I need to get a closer look." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_opening_in_rocks()
dprint("f_callout_dialog_opening_in_rocks");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "OPENING_IN_ROCKS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00106', FALSE, NONE, 0.0, "", "Cortana : There's a crevice we can use to get through the rocks over there." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_forerunner_architecture()
dprint("f_dialog_callout_forerunner_architecture");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FORERUNNER_ARCHITECTURE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00108', FALSE, NONE, 0.0, "", "Cortana : Seems we're not the only ones with an interest in early Forerunner architecture." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_covenant_scouts()
dprint("f_dialog_callout_covenant_scouts");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COVENANT_SCOUTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00109', FALSE, NONE, 0.0, "", "Cortana : Covenant scouts!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_reinforcements_inbound()
dprint("f_dialog_callout_reinforcements_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "REINFORCEMENTS_INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00110', FALSE, NONE, 0.0, "", "Cortana : Reinforcements, Chief. And something tells me they won’t be the last." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_fortifying_structure()
dprint("f_dialog_callout_fortifying_structure");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FORTIFYING_STRUCTURE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00111', FALSE, NONE, 0.0, "", "Cortana : Covenant are fortifying the structure already.  Not wasting time, are they?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_console_in_back()
dprint("f_dialog_callout_console_in_back");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CONSOLE_IN_BACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00112', FALSE, NONE, 0.0, "", "Cortana : There, Chief–a console, in the back." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_battlenet_lighting_up()
dprint("f_dialog_callout_battlenet_lighting_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BATTLENET_LIGHTING_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00113', FALSE, NONE, 0.0, "", "Cortana : Chief, the battlenet's lighting up!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_found_something()
dprint("f_dialog_callout_found_something");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BATTLENET_LIGHTING_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00113a', FALSE, NONE, 0.0, "", "Cortana : I think they've found something-hurry!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_covenant_inbound()
dprint("f_dialog_callout_covenant_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COVENANT_INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00114', FALSE, NONE, 0.0, "", "Cortana : Look out! Covenant inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_heads_up()
dprint("f_dialog_callout_heads_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HEADS_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00115', FALSE, NONE, 0.0, "", "Cortana : Heads up!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_setting_a_waypoint()
dprint("f_dialog_callout_setting_a_waypoint");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SETTING_A_WAYPOINT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00116', FALSE, NONE, 0.0, "", "Cortana : Setting a waypoint for you." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_setting_a_waypoint_now()
dprint("f_dialog_callout_setting_a_waypoint_now");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SETTING_A_WAYPOINT_NOW", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00117', FALSE, NONE, 0.0, "", "Cortana : Setting a waypoint for you now." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_setting_a_waypoint_hud()
dprint("f_dialog_callout_setting_a_waypoint_hud");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SETTING_A_WAYPOINT_HUD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00118', FALSE, NONE, 0.0, "", "Cortana : See the waypoint on your HUD." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_hostiles()
dprint("f_dialog_callout_hostiles");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOSTILES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00119', FALSE, NONE, 0.0, "", "Cortana : Hostiles!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_covenant()
dprint("f_dialog_callout_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00120', FALSE, NONE, 0.0, "", "Cortana : Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_more_covenant()
dprint("f_dialog_callout_more_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00121', FALSE, NONE, 0.0, "", "Cortana : More Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_hunters()
dprint("f_dialog_callout_hunters");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HUNTERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00175', FALSE, NONE, 0.0, "", "Cortana : Hunters!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_banshees_fast_low()
dprint("f_dialog_callout_banshees_fast_low");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES_FAST_LOW", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00176', FALSE, NONE, 0.0, "", "Cortana : Banshees. Fast and low." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_callout_grunts()
dprint("f_dialog_callout_callout_grunts");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GRUNTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00122', FALSE, NONE, 0.0, "", "Cortana : Grunts!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_jackals()
dprint("f_dialog_callout_jackals");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "JACKALS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00123', FALSE, NONE, 0.0, "", "Cortana : Jackals!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_elites()
dprint("f_dialog_callout_elites");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ELITES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00124', FALSE, NONE, 0.0, "", "Cortana : Elites!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_wraith()
dprint("f_dialog_callout_wraith");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WRAITH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00125', FALSE, NONE, 0.0, "", "Cortana : Wraith!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_banshees()
dprint("f_dialog_callout_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00126', FALSE, NONE, 0.0, "", "Cortana : Banshees!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_ghosts()
dprint("f_dialog_callout_ghosts");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GHOSTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00127', FALSE, NONE, 0.0, "", "Cortana : Ghosts!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_inbound()
dprint("f_dialog_callout_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00128', FALSE, NONE, 0.0, "", "Cortana : Inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_cmon_chief()
dprint("f_dialog_callout_cmon_chief");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CMON_CHIEF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00129', FALSE, NONE, 0.0, "", "Cortana : C'mon, Chief." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_lets_go()
dprint("f_dialog_callout_lets_go");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LETS_GO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00130', FALSE, NONE, 0.0, "", "Cortana : Let's go." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_move()
dprint("f_dialog_callout_move");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MOVE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00131', FALSE, NONE, 0.0, "", "Cortana : Move!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_find_some_cover()
dprint("f_dialog_callout_find_some_cover");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FIND_SOME_COVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00132', FALSE, NONE, 0.0, "", "Cortana : Find some cover!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_reload()
dprint("f_dialog_callout_reload");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "RELOAD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00133', FALSE, NONE, 0.0, "", "Cortana : Reload." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_nicely_done()
dprint("f_dialog_callout_nicely_done");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "RELOAD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00134', FALSE, NONE, 0.0, "", "Cortana : Nicely done, Chief!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_well_done()
dprint("f_dialog_callout_well_done");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WELL_DONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00135', FALSE, NONE, 0.0, "", "Cortana : Well done." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_good_job()
dprint("f_dialog_callout_good_job");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GOOD_JOB", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00136', FALSE, NONE, 0.0, "", "Cortana : Good job." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_look_out()
dprint("f_dialog_callout_look_out");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GOOD_JOB", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00137', FALSE, NONE, 0.0, "", "Cortana : Look out!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_right()
dprint("f_dialog_callout_right");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "RIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00138', FALSE, NONE, 0.0, "", "Cortana : Right!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_move_right()
dprint("f_dialog_callout_move_right");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MOVE_RIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00140', FALSE, NONE, 0.0, "", "Cortana : Move right!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_go_left()
dprint("f_dialog_callout_go_left");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GO_LEFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00141a', FALSE, NONE, 0.0, "", "Cortana : Go! To the left!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_come_in_handy()
dprint("f_dialog_callout_move_left");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MOVE_LEFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00143', FALSE, NONE, 0.0, "", "Cortana : That could come in handy." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_man_who_has_everything()
dprint("f_dialog_callout_man_who_has_everything");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MAN_WHO_HAS_EVERYTHING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00144', FALSE, NONE, 0.0, "", "Cortana : What to get for the man who has everything." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_chief_this_way()
dprint("f_dialog_callout_chief_this_way");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CHIEF_THIS_WAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00146', FALSE, NONE, 0.0, "", "Cortana : Chief, this way." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_more_time()
dprint("f_dialog_callout_more_time");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_TIME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00148', FALSE, NONE, 0.0, "", "Cortana : Just a few more minutes!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_hold_them_off()
dprint("f_dialog_callout_hold_them_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOLD_THEM_OFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00147', FALSE, NONE, 0.0, "", "Cortana : Hold them off!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_head_that_way()
dprint("f_dialog_callout_head_that_way");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HEAD_THAT_WAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00145', FALSE, NONE, 0.0, "", "Cortana : We might want to head that way." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_reinforcements()
dprint("f_dialog_callout_reinforcements");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "REINFORCEMENTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00149', FALSE, NONE, 0.0, "", "Cortana : Reinforcements!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_almost_there()
dprint("f_dialog_callout_almost_there");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ALMOST_THERE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00152', FALSE, NONE, 0.0, "", "Cortana : Almost there!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_were_almost_there()
dprint("f_dialog_callout_were_almost_there");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WERE_ALMOST_THERE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00151', FALSE, NONE, 0.0, "", "Cortana : We're almost there!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_little_bit_further()
dprint("f_dialog_callout_little_bit_further");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LITTLE_BIT_FURTHER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00150', FALSE, NONE, 0.0, "", "Cortana : Just a little bit further." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_sent_reinforcements()
dprint("f_dialog_callout_sent_reinforcements");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SENT_REINFORCEMENTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00173', FALSE, NONE, 0.0, "", "Cortana : The Didact sent reinforcements!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_combined_squads()
dprint("f_dialog_callout_combined_squads");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COMBINED_SQUADS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00172', FALSE, NONE, 0.0, "", "Cortana : Combined squads!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_didact_ai()
dprint("f_dialog_callout_didact_ai");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "DIDACT_AI", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00171', FALSE, NONE, 0.0, "", "Cortana : More of the Didact's AI's!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_additional_forerunners()
dprint("f_dialog_callout_additional_forerunners");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ADDITIONAL_FORERUNNERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00170', FALSE, NONE, 0.0, "", "Cortana : Additional Forerunners inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_more_forerunners()
dprint("f_dialog_callout_more_forerunners");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_FORERUNNERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00169', FALSE, NONE, 0.0, "", "Cortana : More Forerunners!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_forerunners()
dprint("f_dialog_callout_forerunners");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FORERUNNERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00168', FALSE, NONE, 0.0, "", "Cortana : Forerunners!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_promethean_squads()
dprint("f_dialog_callout_promethean_squads");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PROMETHEAN_SQUADS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00167', FALSE, NONE, 0.0, "", "Cortana : Promethean squads!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_more_prometheans()
dprint("f_dialog_callout_more_prometheans");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_PROMETHEANS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00166', FALSE, NONE, 0.0, "", "Cortana : More Prometheans!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_prometheans()
dprint("f_dialog_callout_prometheans");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PROMETHEANS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00165', FALSE, NONE, 0.0, "", "Cortana : Prometheans!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_knight()
dprint("f_dialog_callout_knight");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "KNIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00164', FALSE, NONE, 0.0, "", "Cortana : Knight!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_more_watchers()
dprint("f_dialog_callout_more_watchers");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_WATCHERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00163', FALSE, NONE, 0.0, "", "Cortana : More watchers!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_watchers()
dprint("f_dialog_callout_watchers");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WATCHERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00162', FALSE, NONE, 0.0, "", "Cortana : Watchers!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_watcher()
dprint("f_dialog_callout_watcher");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WATCHER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00161', FALSE, NONE, 0.0, "", "Cortana : Watcher!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_crawling_things()
dprint("f_dialog_callout_crawling_things");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CRAWLING_THINGS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00160', FALSE, NONE, 0.0, "", "Cortana : More of those crawling things!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_more_crawlers()
dprint("f_dialog_callout_more_crawlers");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_CRAWLERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00159', FALSE, NONE, 0.0, "", "Cortana : More crawlers!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_crawlers()
dprint("f_dialog_callout_crawlers");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CRAWLERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00158', FALSE, NONE, 0.0, "", "Cortana : Crawlers!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_crawler()
dprint("f_dialog_callout_crawler");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CRAWLER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00158a', FALSE, NONE, 0.0, "", "Cortana : Crawler!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_more_knights()
dprint("f_dialog_callout_more_knights");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_KNIGHTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00157', FALSE, NONE, 0.0, "", "Cortana : More knights!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_knights()
dprint("f_dialog_callout_knights");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "KNIGHTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00156', FALSE, NONE, 0.0, "", "Cortana : Knights!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_john()
dprint("f_dialog_callout_john");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "JOHN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00155', FALSE, NONE, 0.0, "", "Cortana : John!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_chief()
dprint("f_dialog_callout_chief");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CHIEF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00154', FALSE, NONE, 0.0, "", "Cortana : Chief!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_top_of_us()
dprint("f_dialog_callout_top_of_us");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TOP_OF_US", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00153', FALSE, NONE, 0.0, "", "Cortana : They're almost on top of us!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_callout_flipping_things_over()
dprint("f_dialog_callout_flipping_things_over");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FLIPPING_THINGS_OVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00174', FALSE, NONE, 0.0, "", "Cortana : Are you done flipping things over now?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_callout_i_was_saying()
dprint("f_dialog_callout_i_was_saying");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "i_WAS_SAYING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00100', FALSE, NONE, 0.0, "", "Cortana : So like I was saying..." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
*/