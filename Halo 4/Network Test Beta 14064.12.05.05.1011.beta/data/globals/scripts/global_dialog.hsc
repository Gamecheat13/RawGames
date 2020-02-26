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

		// perform style actions
		if ( sys_dialog_style_action(str_name, l_id, r_type, r_style) ) then
		
			// make sure there is no dialog with this ID still active
			sleep_until( not dialog_id_active_check(l_id) and (not IsThreadValid(dialog_foreground_line_thread_get())), 1 );

			// start the new dialog
			l_id_new = sys_dialog_type_start( str_name, r_type, b_interruptable );

			// apply back pad
			if ( b_use_back_pad ) then
				l_timer = game_tick_get() + seconds_to_frames( r_back_pad );
			end
			sleep_until( (dialog_id_active_check(l_id_new)) or (l_timer > game_tick_get()), 1 );

		end

	else
		sys_dialog_debug( "dialog_start", "FAILED TO START!!!" );
		inspect( not dialog_id_invalid_check(l_id) );
		inspect( b_condition );
	end

	// notify complete
	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	l_id_new;
end
// === dialog_start_foreground: Starts a foreground dialog
//			See "dialog_start" for parameters/return
script static long dialog_start_foreground( string str_name, long l_id, boolean b_condition, real r_style, boolean b_interruptable, string str_notify, real r_back_pad )
sys_dialog_debug( "dialog_start_foreground", "" );
	dialog_start( str_name, l_id, b_condition, DEF_DIALOG_TYPE_FOREGROUND(), r_style, b_interruptable, str_notify, r_back_pad );
end
// === dialog_start_background: Starts a background dialog
//			See "dialog_start" for parameters/return
script static long dialog_start_background( string str_name, long l_id, boolean b_condition, real r_style, string str_notify, real r_back_pad )
sys_dialog_debug( "dialog_start_background", "" );
	dialog_start( str_name, l_id, b_condition, DEF_DIALOG_TYPE_BACKGROUND(), r_style, TRUE, str_notify, r_back_pad );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_type_start: Starts a specific type of dialog
script static long sys_dialog_type_start( string str_name, real r_type, boolean b_interruptable )
local long l_thread = 0;
sys_dialog_debug( "sys_dialog_type_start", "" );

	if ( sys_dialog_type_foreground(r_type) ) then
		// thread the convesation info
		l_thread = thread( sys_dialog_foreground_thread(str_name, b_interruptable) );
	end
	if ( sys_dialog_type_background(r_type) ) then
		// thread the convesation info
		l_thread = thread( sys_dialog_background_thread(str_name) );
	end

	// RETURN
	l_thread;
end

// === sys_dialog_foreground_thread: Thread that is active while the conversation is active
script static void sys_dialog_foreground_thread( string str_name, boolean b_interruptable )
local long l_id = GetCurrentThreadId();
	
	// set information hooks
	sys_dialog_foreground_current_set( l_id );
	dialog_foreground_id_interruptable_set( l_id, b_interruptable );
	sys_dialog_foreground_line_index_set( -1 );
	sys_dialog_foreground_id_name_set( l_id, str_name );

	sys_dialog_debug( "sys_dialog_foreground_thread", "" );
	if ( dialog_debug_get() ) then
		dprint( str_name );
		inspect( GetCurrentThreadId() );
		inspect( b_interruptable );
	end
	
	// increment active cnt
	sys_dialog_foreground_active_inc( 1 );

	// Keep the function from returning to keep the thread active
	sleep_until( dialog_foreground_end_all_check() or (l_id != dialog_foreground_current_get()) or ((b_interruptable) and (l_id == sys_dialog_end_interrupt_get())), 1 );
	
	// if it's still current clean up
	if ( l_id != dialog_foreground_current_get() ) then
		dialog_foreground_id_interruptable_set( l_id, TRUE );
		sys_dialog_foreground_current_set( DEF_DIALOG_ID_NONE() );	
	end

	// deccrement active cnt
	sys_dialog_foreground_active_inc( -1 );
	
end

// === sys_dialog_background_thread: Thread that is active while the conversation is active
script static void sys_dialog_background_thread( string str_name )
sys_dialog_debug( "sys_dialog_background_thread", "" );

	// increment active cnt
	sys_dialog_background_active_inc( 1 );

	// Keep the function from returning to keep the thread active
	sleep_until( dialog_background_end_all_check(), 1 );
	
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
script static boolean dialog_line( long l_dialog_id, short s_line_index, string str_speaker_id, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
local boolean b_played 				= FALSE;
local long 		l_line_thread 	= 0;
local real 		r_type 					= DEF_DIALOG_TYPE_BACKGROUND();

	// gets the dialog type from the ID
	r_type = sys_dialog_type_id_get( l_dialog_id );

	// wait for other foreground line to finish
	if ( sys_dialog_type_foreground(r_type) ) then
		sleep_until( not IsThreadValid(dialog_foreground_line_thread_get()), 1 );
	end

	if ( b_condition and dialog_id_active_check(l_dialog_id) ) then
		
		if ( r_type != DEF_DIALOG_TYPE_NONE() ) then
			// create the line thread and wait for it to finish
			l_line_thread = thread( sys_dialog_line_thread(l_dialog_id, s_line_index, str_speaker_id, snd_sound, b_line_interruptable, o_object, r_pad, str_debug) );
			sleep_until( not IsThreadValid(l_line_thread), 1 );
	
			// if dialog type no longer matches, the conversation is probably shutting down so wait for it to finish to avoid a new line being triggered
			if ( r_type != sys_dialog_type_id_get(l_dialog_id) ) then
				sleep_until( not IsThreadValid(l_dialog_id), 1 );
			end
			
			b_played = TRUE;
		end
		
	end

	// Notify
	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	b_played;

end

// === dialog_line_chief: Starts a Chief dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_chief( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_chief", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_CHIEF(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
// === dialog_line_cortana: Starts a Cortana dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_cortana( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_cortana", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_CORTANA(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
// === dialog_line_didact: Starts a Didact dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_didact( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_didact", "" );

	sleep_until( not b_speaking );
	b_speaking = TRUE;
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_DIDACT(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	b_speaking = FALSE;
	
	// RETURN
	b_line_spoken;
end
// === dialog_line_npc: Starts a generic npc dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_npc( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_npc", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_NPC(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end
// === dialog_line_radio: Starts a radio dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_radio( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_radio", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_RADIO(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end
// === dialog_line_other: Starts a other dialog line
//			See "dialog_line" for parameters/return
script static boolean dialog_line_other( long l_dialog_id, short s_line_index, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug, boolean b_exclusive )
static boolean b_speaking = FALSE;
local boolean b_line_spoken = FALSE;
sys_dialog_debug( "dialog_line_other", "" );

	if ( b_exclusive ) then
		sleep_until( not b_speaking );
		b_speaking = TRUE;
	end
	b_line_spoken = dialog_line( l_dialog_id, s_line_index, DEF_DIALOG_SPEAKER_ID_OTHER(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug );
	if ( b_exclusive ) then
		b_speaking = FALSE;
	end
	
	// RETURN
	b_line_spoken;
end 

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
// === sys_dialog_line_thread: Thread that manages a dialog line
script static void sys_dialog_line_thread( long l_dialog_id, short s_line_index, string str_speaker_id, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_debug )
local long 		l_timer 								= 0; 
local real 		r_type 									= DEF_DIALOG_TYPE_BACKGROUND();
local long 		l_snd_time 							= 0;
local boolean b_dialog_interruptable 	= dialog_id_interruptable_check( l_dialog_id );

sys_dialog_debug( "sys_dialog_line_thread", "" );
 
	// get the dialog line type
	r_type = sys_dialog_type_id_get( l_dialog_id );

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
	
		// play the sound
		// XXX special tricks for when it's on the CHIEF?  Other characters?
		if ( snd_sound != NONE ) then
			sound_impulse_start( snd_sound, o_object, 1 );
			l_snd_time = sound_impulse_time( snd_sound );
			r_pad = r_pad + frames_to_seconds( l_snd_time );
		end
		
		// if there is no sound, apply temp pad
		if ( (snd_sound == NONE) or (l_snd_time == 0) ) then
			r_pad = r_pad + dialog_line_temp_blurb_pad_get();
		end

		// display story blurb if necessary
		if ( (str_debug != "") and dialog_line_temp_blurb_get() and ((snd_sound == NONE) or editor_mode())) then
			local long l_blurb_thread = 0;
		
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_CHIEF() ) then
				l_blurb_thread = thread( sys_dialog_blurb_chief(str_debug, r_pad - 0.01) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_CORTANA() ) then
				l_blurb_thread = thread( sys_dialog_blurb_cortana(str_debug, r_pad - 0.01) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_DIDACT() ) then
				l_blurb_thread = thread( sys_dialog_blurb_didact(str_debug, r_pad - 0.01) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_NPC() ) then
				l_blurb_thread = thread( sys_dialog_blurb_npc(str_debug, r_pad - 0.01) );
			end
			if ( str_speaker_id == DEF_DIALOG_SPEAKER_ID_RADIO() ) then
				l_blurb_thread = thread( sys_dialog_blurb_radio(str_debug, r_pad - 0.01) );
			end
			if ( l_blurb_thread == 0 ) then
				l_blurb_thread = thread( sys_dialog_blurb_other(str_debug, r_pad - 0.01) );
			end
			
		end
	
		// applies auto pad time
		r_pad = r_pad + dialog_line_auto_pad_get();
	
		// calculate the timer
		l_timer = game_tick_get() + seconds_to_frames( r_pad );
	
		// store foreground line information
		if ( dialog_foreground_id_check(l_dialog_id) ) then
			// set the foreground line timer
			sys_dialog_foreground_line_timer_set( l_timer );
		end
	
		// wait for the line to finish
		sleep_until( (game_tick_get() > l_timer) or ((not IsThreadValid(l_dialog_id)) and b_dialog_interruptable and b_line_interruptable), 1 );
	
		// if the timer is still valid that means the conversation has ended, kill the line
		if ( game_tick_get() < l_timer ) then
			sound_impulse_stop( snd_sound );
		end
	
		// decrement the current active line cnt	
		sys_dialog_type_line_active_inc( r_type, -1 );

	end

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
			r_type = DEF_DIALOG_TYPE_FOREGROUND();
			sys_dialog_foreground_current_set( DEF_DIALOG_ID_NONE() );			
		end

		// wait for the thread to shut down
		sleep_until( not IsThreadValid(l_id), 1 );

		// decrement the conversation counter
		sys_dialog_type_active_inc( r_type, -1 );
		
		if ( b_active_invalidates ) then
			l_id = DEF_DIALOG_ID_INVALID();
		end
	elseif ( (b_started_invalidates) and dialog_id_none_check(l_id) ) then
		l_id = DEF_DIALOG_ID_INVALID();
	end

	if ( str_notify != "" ) then
		NotifyLevel( str_notify );
	end

	// RETURN
	l_id;
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
inspect( str_name );
inspect( l_id );
inspect( r_type );

	// PLAY STYLE
	if ( sys_dialog_style_play(r_style) ) then
		sys_dialog_debug( "sys_dialog_style_action", "PLAY: START" );
		if ( not sys_dialog_type_background(r_type) ) then
			breakpoint( "sys_dialog_style_action: DEF_DIALOG_STYLE_PLAY() style dialogs only work with BACKGROUND types" );
			sleep( 1 );
		end
		sys_dialog_debug( "sys_dialog_style_action", "PLAY: END" );
	end

	// INTERRUPT STYLE
	if ( sys_dialog_style_interrupt(r_style) and dialog_foreground_current_active_check() ) then
		sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT: START" );
		local long l_id_interrupt = DEF_DIALOG_ID_NONE();
		
		// set check type
		if ( r_style == DEF_DIALOG_STYLE_INTERRUPT() ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT: r_check_type = r_type" );
			r_check_type = r_type;
		end
		if ( r_style == DEF_DIALOG_STYLE_INTERRUPT_FOREGROUND() ) then
			sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT: r_check_type = DEF_DIALOG_TYPE_FOREGROUND()" );
			r_check_type = DEF_DIALOG_TYPE_FOREGROUND();
		end

		if ( not sys_dialog_type_foreground(r_check_type) ) then
			breakpoint( "sys_dialog_style_action: DEF_DIALOG_STYLE_INTERRUPT() style dialogs only work with FOREGROUND types" );
			sleep( 1 );
		end
		
		// repeat until there is no dialog active
		repeat
		
			// get the id to interrupt
			l_id_interrupt = dialog_foreground_current_get();

			// tell the dialog to interrupt (if it will)
			sys_dialog_end_interrupt( l_id_interrupt );
	
			// wait for thread to shutdown
			sleep_until( not IsThreadValid(l_id_interrupt), 1 );

		until( not dialog_foreground_current_active_check(), 1 );
	
		sys_dialog_debug( "sys_dialog_style_action", "INTERRUPT: END" );
	end

	// QUEUE STYLE
	if ( sys_dialog_style_queue(r_style) ) then
		sys_dialog_debug( "sys_dialog_style_action", "QUEUE: START" );
	
		// increment queue cnt
		sys_dialog_type_queue_inc( r_type, 1 );
	
		// set check type
		if ( r_style == DEF_DIALOG_STYLE_QUEUE() ) then
			sys_dialog_debug( "sys_dialog_style_action", "QUEUE: r_style == DEF_DIALOG_STYLE_QUEUE" );
			r_check_type = r_type;
		end
		if ( r_style == DEF_DIALOG_STYLE_QUEUE_FOREGROUND()) then
			sys_dialog_debug( "sys_dialog_style_action", "QUEUE: r_style == DEF_DIALOG_STYLE_QUEUE_FOREGROUND" );
			r_check_type = DEF_DIALOG_TYPE_FOREGROUND();
		end
		if ( r_style == DEF_DIALOG_TYPE_BACKGROUND() ) then
			sys_dialog_debug( "sys_dialog_style_action", "QUEUE: r_style == DEF_DIALOG_TYPE_BACKGROUND()" );
			r_check_type = DEF_DIALOG_TYPE_BACKGROUND();
		end

		// repeat until the queue is open	
		repeat
		
			sleep_until( ((not dialog_type_active_check(r_check_type)) and (not dialog_type_unqueue_active(r_type))) or sys_dialog_type_unqueue_check(r_type, str_name), 1 );
			b_return = not sys_dialog_type_unqueue_check(r_type, str_name);
			
		until( ((not dialog_type_active_check(r_check_type)) and (not dialog_type_unqueue_active(r_type))) or (not b_return), 1 );

		// dec queue cnt
		sys_dialog_type_queue_inc( r_type, -1 );

		// set any unqueue SUCCESS
		if ( not b_return ) then
			sys_dialog_debug( "sys_dialog_style_action", "QUEUE: not b_return" );
			sys_dialog_type_unqueue_success_set( r_type, str_name );
		end
	
		sys_dialog_debug( "sys_dialog_style_action", "QUEUE: END" );
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
	
	// RETURN
	b_return;
end

// === sys_dialog_style_play: Checks if a dialog style is auto play
script static boolean sys_dialog_style_play( real r_style )
	( r_style == DEF_DIALOG_STYLE_PLAY() );
end
// === sys_dialog_style_interrupt: Checks if a dialog style is interrupt
script static boolean sys_dialog_style_interrupt( real r_style )
	( r_style == DEF_DIALOG_STYLE_INTERRUPT() ) and ( r_style <= DEF_DIALOG_STYLE_INTERRUPT_FOREGROUND() );
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
inspect( l_id );
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
	set_text_font( english_body );                                                                  
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
static boolean 	b_dialog_debug_details				= TRUE;

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