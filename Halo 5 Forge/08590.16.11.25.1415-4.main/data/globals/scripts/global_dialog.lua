--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- NOTE: All functions with sys_ in front of them are not intendended for use outside of this script
-- NOTE: All variables in this script are not intended for use outside of this script and instead
--			 there are functions you can use to check them instead.
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: SPEAKERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DEFINES -----------------------------------------------------------------------------------------
function def_dialog_speaker_id_none():string
	return "";
end

function def_dialog_speaker_id_chief():string
	return "CHIEF";
end

function def_dialog_speaker_id_cortana():string
	return "CORTANA";
end

function def_dialog_speaker_id_didact():string
	return "DIDACT";
end

function def_dialog_speaker_id_npc():string
	return "[NPC]";
end

function def_dialog_speaker_id_radio():string
	return "[RADIO]";
end

function def_dialog_speaker_id_other():string
	return "[OTHER]";
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: ID
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DEFINES -----------------------------------------------------------------------------------------
function def_dialog_id_none():thread
	return nil;
end

function def_dialog_id_invalid():thread
	return GetInvalidThreadId();
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: START
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_start: Sets up a dialog based on parameters and returns when it is ready to startup.
--			str_name = Name of the dialog.
--				NOTE: You need a dialog name if you want to try to unqueue a dialog
--			l_id = ID of the dialog
--				NOTE: Only really important if the dialog is repeatable and uses the same variable to track it's use.  If you're not you can just pass DEF_DIALOG_ID_NONE().
--			b_condition = Condition to check to start the covnersation
--			r_type = Determines how to react if another dialog is playing.  See "DIALOG: TYPE" for descriptions of each type
--				NOTE: You should only use the defines for these as they may change values.
--			r_style = Determines how to react if another dialog is playing.  See "DIALOG: STYLE" for descriptions of each style
--				NOTE: You should only use the defines for these as they may change values.
--							Dialogs that are SKIPPED will return an ID of DEF_DIALOG_ID_NONE()
--			b_interruptable = Sets if this dialog can be interrupted or not
--				NOTE: This can only work for FOREGROUND dialogs.  Background dialogs can always be interrupted by other background interruptable dialogs.
--			str_notify = Notify message when the dialog start completes (SUCCESS or FAILURE)
--			r_back_pad = If the dialog is a queue or type, and another dialog is active it will pad this time (seconds) before allowing this dialog to start.  Helps make dialogs not feel like they are overly butting into each other.
--				[DEFAULT: r_back_pad < 0.0] = r_back_pad == dialog_back_pad_default_get()
--	RETURN:  [thread] ID of the dialog
function dialog_start( str_name:string, l_id:thread, b_condition:boolean, r_type:number, r_style:number, b_interruptable:boolean, str_notify:string, r_back_pad:number ):thread
	local l_id_new:thread=l_id;
	local b_use_back_pad:boolean=false;
	local l_timer:number=0;
	sys_dialog_debug("dialog_start", "");
	-- make sure the dialog ID is not type invalid
	if  not dialog_id_invalid_check(l_id) and b_condition then
		-- ERROR CHECK
		-- --- str_name
		if  not dialog_name_valid_check(str_name) then
			Breakpoint("dialog_start: INVALID DIALOG NAME");
			Sleep(1);
		end
		-- DEFAULTS
		-- --- r_back_pad
		if r_back_pad < 0.0 then
			r_back_pad = dialog_back_pad_default_get();
		end
		-- check if the dialog needs to use the back pad
		b_use_back_pad = dialog_active_check() and sys_dialog_style_use_back_pad(r_style);
		-- make sure there is no dialog with this ID still active
		--sleep_until( not dialog_id_active_check(l_id) and (not IsThreadValid(dialog_foreground_line_thread_get())), 1 );
		-- perform style actions
		if sys_dialog_style_action(str_name, l_id, r_type, r_style) then
			-- start the new dialog
			l_id_new = sys_dialog_type_start(str_name, r_type, b_interruptable);
			sys_dialog_inspect_l("dialog_start - NEW ID", l_id_new);
			-- apply back pad
			if b_use_back_pad then
				l_timer = game_tick_get() + seconds_to_frames(r_back_pad);
			end
			SleepUntil([| dialog_id_active_check(l_id_new) or l_timer < game_tick_get() ], 1);
		end
	else
		sys_dialog_debug("dialog_start", "FAILED TO START!!!");
		sys_dialog_inspect_b("dialog_start - not dialog_id_invalid_check(l_id)",  not dialog_id_invalid_check(l_id));
		sys_dialog_inspect_b("dialog_start - b_condition", b_condition);
	end
	-- notify complete
	if str_notify ~= "" then
		NotifyLevel(str_notify);
	end
	return l_id_new;
end

-- RETURN
-- Shows the radio transmission HUD with the specified speaker
-- Plays the incoming transmission sound
function start_radio_transmission( speaker_id:string ):void
	cui_hud_show_radio_transmission_hud(speaker_id);
	--sound_impulse_start(TAG('sound\storm\vo\play_1_99_01_in_squelch.sound'), nil, 1);
	Sleep(10);
end

-- Hides the radio transmission HUD
-- Plays the end transmission sound
function end_radio_transmission():void
	cui_hud_hide_radio_transmission_hud();
	Sleep(5);
	--sound_impulse_start(TAG('sound\storm\vo\play_1_99_02_out_squelch.sound'), nil, 1);
end

-- === dialog_start_foreground: Starts a foreground dialog
--			See "dialog_start" for parameters/return
function dialog_start_foreground( str_name:string, l_id:thread, b_condition:boolean, r_style:number, b_interruptable:boolean, str_notify:string, r_back_pad:number ):thread
	sys_dialog_debug("dialog_start_foreground", "");
	return dialog_start(str_name, l_id, b_condition, def_dialog_type_foreground(), r_style, b_interruptable, str_notify, r_back_pad);
end

-- === dialog_start_background: Starts a background dialog
--			See "dialog_start" for parameters/return
function dialog_start_background( str_name:string, l_id:thread, b_condition:boolean, r_style:number, b_interruptable:boolean, str_notify:string, r_back_pad:number ):thread
	sys_dialog_debug("dialog_start_background", "");
	return dialog_start(str_name, l_id, b_condition, def_dialog_type_background(), r_style, b_interruptable, str_notify, r_back_pad);
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_type_start: Starts a specific type of dialog
function sys_dialog_type_start( str_name:string, r_type:number, b_interruptable:boolean ):thread
	local l_id:thread=nil;
	sys_dialog_debug("sys_dialog_type_start", "");
	if sys_dialog_type_foreground(r_type) then
		-- thread the convesation info
		l_id = CreateThread(sys_dialog_foreground_thread, str_name, b_interruptable);
		-- set information hooks
		sys_dialog_foreground_current_set(l_id);
		dialog_foreground_id_interruptable_set(l_id, b_interruptable);
		sys_dialog_foreground_line_index_set(-1);
		sys_dialog_foreground_id_name_set(l_id, str_name);
		-- increment active cnt
		sys_dialog_foreground_active_inc(1);
	end
	if sys_dialog_type_background(r_type) then
		-- thread the convesation info
		l_id = CreateThread(sys_dialog_background_thread, str_name, b_interruptable);
		-- increment active cnt
		sys_dialog_background_active_inc(1);
	end
	return l_id;
end

-- RETURN
-- === sys_dialog_foreground_thread: Thread that is active while the conversation is active
function sys_dialog_foreground_thread( str_name:string, b_interruptable:boolean ):void
	local l_id:thread=GetCurrentThreadId();
	sys_dialog_debug("sys_dialog_foreground_thread", "STARTED");
	-- Keep the function from returning to keep the thread active
	SleepUntil([| dialog_foreground_end_all_check() or f_dialog_end_id_check(l_id) or l_id ~= dialog_foreground_current_get() or (b_interruptable and (l_id == sys_dialog_end_interrupt_get() or dialog_interrupt_foreground_queue_cnt() > 0)) ], 1);
	sys_dialog_debug("sys_dialog_foreground_thread", "ENDED");
	-- if it's still current clean up
	if l_id == dialog_foreground_current_get() then
		dialog_foreground_id_interruptable_set(l_id, true);
		sys_dialog_foreground_current_set(def_dialog_id_none());
	end
	-- deccrement active cnt
	sys_dialog_foreground_active_inc(-1);
end

-- === sys_dialog_background_thread: Thread that is active while the conversation is active
function sys_dialog_background_thread( str_name:string, b_interruptable:boolean ):void
	local l_id:thread=GetCurrentThreadId();
	sys_dialog_debug("sys_dialog_background_thread", "");
	sys_dialog_debug("sys_dialog_background_thread", "STARTED");
	-- Keep the function from returning to keep the thread active
	SleepUntil([| dialog_background_end_all_check() or f_dialog_end_id_check(l_id) or (b_interruptable and (l_id == sys_dialog_end_interrupt_get() or dialog_interrupt_background_queue_cnt() > 0)) ], 1);
	sys_dialog_debug("sys_dialog_background_thread", "ENDED");
	-- deccrement active cnt
	sys_dialog_background_active_inc(-1);
	sys_dialog_foreground_id_name_set(GetCurrentThreadId(), "");
end
global sys_dialog_mute_dialog:boolean=false;

-- mutes any sounds/subtitles from playing through the global dialog system
-- This is intended to be called immedietly before entering a cinematic to prevent
-- global dialog script calls in other threads than where the cinematic is launched from
-- playing during the cinematic
function notify_dialog_muted():void
	sys_dialog_mute_dialog = true;
end

function notify_dialog_unmuted():void
	sys_dialog_mute_dialog = false;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: LINE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line: Plays a line of dialog IF this dialog is active
--			l_dialog_id = Dialog ID that this line belongs to
--			s_line_index = ID for the line that is set when the line starts playing; allows testing if the line is playing
--			str_speaker_id = Speaker id for the line.  This allows for testing of who's speaking as well as special case handling for specific speakers
--			snd_sound = Sound tag file
--			o_object = Object to play the line on
--			r_pad = Seconds to pad on the line
--				NOTE: this number can be - if you want to make lines step on one another
--			str_notify = Notify message that triggers after the line is complete (played successfull or fails)
--			str_debug = Debug string to print when the line plays
--				NOTE: It's good to use this as string of the dialog to make testing in Sapien easier
--	RETURN:		[boolean] TRUE; if the line was played
function dialog_line( l_dialog_id:thread, s_line_index:number, str_speaker_id:string, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_subtitle_only:boolean ):boolean
	return dialog_line_on_group( l_dialog_id, s_line_index, str_speaker_id, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only, nil);
end

function dialog_line_on_group( l_dialog_id:thread, s_line_index:number, str_speaker_id:string, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_subtitle_only:boolean, t_players:table ):boolean
	local b_played:boolean=false;
	local l_line_thread:thread=nil;
	local r_type:number=def_dialog_type_background();
	-- gets the dialog type from the ID
	r_type = sys_dialog_type_id_get(l_dialog_id);
	-- wait for other foreground line to finish
	if sys_dialog_type_foreground(r_type) then
		SleepUntil([|  not IsThreadValid(dialog_foreground_line_thread_get()) ], 1);
	end
	if b_condition and dialog_id_active_check(l_dialog_id) and r_type ~= def_dialog_type_none() and (o_object == nil or ai_get_object(object_get_ai(o_object)) == nil or object_get_health(o_object) > 0.0) then
		-- create the line thread and wait for it to finish
		sys_dialog_line_thread_on_group(l_dialog_id, s_line_index, str_speaker_id, snd_sound, b_line_interruptable, o_object, r_pad, str_debug, b_subtitle_only, t_players);
		-- if dialog type no longer matches, the conversation is probably shutting down so wait for it to finish to avoid a new line being triggered
		if r_type ~= sys_dialog_type_id_get(l_dialog_id) then
			SleepUntil([|  not IsThreadValid(l_dialog_id) ], 1);
		end
		b_played = true;
	end
	-- Notify
	if str_notify ~= "" then
		NotifyLevel(str_notify);
	end
	return b_played;
end

-- RETURN
--[[
script static boolean dialog_line( thread l_dialog_id, short s_line_index, string str_speaker_id, boolean b_condition, sound snd_sound, boolean b_line_interruptable, object o_object, real r_pad, string str_notify, string str_debug )
	dialog_line( l_dialog_id, s_line_index, str_speaker_id, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, FALSE );
end
]]
function dialog_line_subtitle( l_dialog_id:thread, s_line_index:number, str_speaker_id:string, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line(l_dialog_id, s_line_index, str_speaker_id, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, true);
end

-- Display the subtitle for the specified dialog sound
function dialog_play_subtitle( snd_sound:tag ):void
	local duration:number=sound_max_time(snd_sound);
--	play_sound_subtitle(snd_sound);
	Sleep(duration);
end

-- === dialog_line_chief: Starts a Chief dialog line
--			See "dialog_line" for parameters/return
function dialog_line_chief( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_chief", "");
	SleepUntil([|  not b_speaking_e8dd956d ]);
	b_speaking_e8dd956d = true;
	b_line_spoken = dialog_line(l_dialog_id, s_line_index, def_dialog_speaker_id_chief(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only);
	b_speaking_e8dd956d = false;
	return b_line_spoken;
end
global b_speaking_e8dd956d:boolean=false;

-- RETURN
function dialog_line_chief_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_chief(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, false);
end

function dialog_line_chief_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_chief(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, true);
end

-- === dialog_line_cortana: Starts a Cortana dialog line
--			See "dialog_line" for parameters/return
function dialog_line_cortana( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_cortana", "");
	SleepUntil([|  not b_speaking_8e33c49c ]);
	b_speaking_8e33c49c = true;
	b_line_spoken = dialog_line(l_dialog_id, s_line_index, def_dialog_speaker_id_cortana(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only);
	b_speaking_8e33c49c = false;
	return b_line_spoken;
end
global b_speaking_8e33c49c:boolean=false;

-- RETURN
function dialog_line_cortana_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_cortana(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, false);
end

function dialog_line_cortana_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_cortana(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, true);
end

-- === dialog_line_didact: Starts a Didact dialog line
--			See "dialog_line" for parameters/return
function dialog_line_didact( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_didact", "");
	SleepUntil([|  not b_speaking_8607bbfe ]);
	b_speaking_8607bbfe = true;
	b_line_spoken = dialog_line(l_dialog_id, s_line_index, def_dialog_speaker_id_didact(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only);
	b_speaking_8607bbfe = false;
	return b_line_spoken;
end
global b_speaking_8607bbfe:boolean=false;

-- RETURN
function dialog_line_didact_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_didact(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, false);
end

function dialog_line_didact_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string ):boolean
	return dialog_line_didact(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, true);
end

-- === dialog_line_npc: Starts a generic npc dialog line
--			See "dialog_line" for parameters/return
function dialog_line_npc( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean ):boolean
	return dialog_line_npc_on_group(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only, nil);
end

function dialog_line_npc_on_player( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean, o_player:object ):boolean
	local t_players:table = { o_player, };

	return dialog_line_npc_on_group(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only, t_players);
end

function dialog_line_npc_on_group( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean, t_players:table ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_npc", "");
--	print("ENTER > dialog_line_npc_on_group, line : " .. s_line_index);
--	if b_exclusive then
--		SleepUntil([|  not b_speaking_840bee6 ]);
--		b_speaking_840bee6 = true;
--	end
--	print("PLAY LINE > dialog_line_npc_on_group, line : " .. s_line_index);
	b_line_spoken = dialog_line_on_group(l_dialog_id, s_line_index, def_dialog_speaker_id_npc(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only, t_players);
--	print("DONE > dialog_line_npc_on_group, line : " .. s_line_index);
--	if b_exclusive then
--		b_speaking_840bee6 = false;
--	end
--	print("EXIT > dialog_line_npc_on_group, line : " .. s_line_index);
	return b_line_spoken;
end
global b_speaking_840bee6:boolean=false;

-- RETURN
function dialog_line_npc_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_npc(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, false);
end

function dialog_line_npc_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_npc(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, true);
end

-- === dialog_line_npc_ai: Starts a generic npc ai dialog line
--			See "dialog_line" for parameters/return
function dialog_line_npc_ai( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, ai_speaker:ai, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_npc_ai", "");
	if ai_living_count(ai_speaker) > 0 then
		b_line_spoken = dialog_line_npc(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_get_object(ai_speaker), r_pad, str_notify, str_debug, b_exclusive, b_subtitle_only);
	end
	return b_line_spoken;
end

-- RETURN
function dialog_line_npc_ai_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, ai_speaker:ai, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_npc_ai(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_speaker, r_pad, str_notify, str_debug, b_exclusive, false);
end

function dialog_line_npc_ai_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, ai_speaker:ai, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_npc_ai(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, ai_speaker, r_pad, str_notify, str_debug, b_exclusive, true);
end

-- === dialog_line_radio: Starts a radio dialog line
--			See "dialog_line" for parameters/return
function dialog_line_radio( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_radio", "");
	if b_exclusive then
		SleepUntil([|  not b_speaking_d29bd12c ]);
		b_speaking_d29bd12c = true;
	end
	b_line_spoken = dialog_line(l_dialog_id, s_line_index, def_dialog_speaker_id_radio(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only);
	if b_exclusive then
		b_speaking_d29bd12c = false;
	end
	return b_line_spoken;
end
global b_speaking_d29bd12c:boolean=false;

-- RETURN
function dialog_line_radio_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_radio(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, false);
end

function dialog_line_radio_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_radio(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, true);
end

-- === dialog_line_other: Starts a other dialog line
--			See "dialog_line" for parameters/return
function dialog_line_other( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean, b_subtitle_only:boolean ):boolean
	local b_line_spoken:boolean=false;
	sys_dialog_debug("dialog_line_other", "");
	if b_exclusive then
		SleepUntil([|  not b_speaking_57a90705 ]);
		b_speaking_57a90705 = true;
	end
	b_line_spoken = dialog_line(l_dialog_id, s_line_index, def_dialog_speaker_id_other(), b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_subtitle_only);
	if b_exclusive then
		b_speaking_57a90705 = false;
	end
	return b_line_spoken;
end
global b_speaking_57a90705:boolean=false;

-- RETURN
function dialog_line_other_no_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_other(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, false);
end

function dialog_line_other_subtitle( l_dialog_id:thread, s_line_index:number, b_condition:boolean, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_notify:string, str_debug:string, b_exclusive:boolean ):boolean
	return dialog_line_other(l_dialog_id, s_line_index, b_condition, snd_sound, b_line_interruptable, o_object, r_pad, str_notify, str_debug, b_exclusive, true);
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_line_thread: Thread that manages a dialog line
function sys_dialog_line_thread( l_dialog_id:thread, s_line_index:number, str_speaker_id:string, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_debug:string, b_subtitle_only:boolean ):void
	sys_dialog_line_thread_on_group( l_dialog_id, s_line_index, str_speaker_id, snd_sound, b_line_interruptable, o_object, r_pad, str_debug, b_subtitle_only, nil );
end

function sys_dialog_line_thread_on_group( l_dialog_id:thread, s_line_index:number, str_speaker_id:string, snd_sound:tag, b_line_interruptable:boolean, o_object:object, r_pad:number, str_debug:string, b_subtitle_only:boolean, t_players:table ):void
	local l_timer:number=0;
	local r_type:number=def_dialog_type_background();
	local l_snd_time:number=0;
	local b_dialog_interruptable:boolean=dialog_id_interruptable_check(l_dialog_id);
		
	sys_dialog_debug("sys_dialog_line_thread", "");
	
	-- get the dialog line type
	r_type = sys_dialog_type_id_get(l_dialog_id);

	-- checks to invalidate line
	if (str_speaker_id == def_dialog_speaker_id_chief() or str_speaker_id == def_dialog_speaker_id_cortana()) and player_living_count() == 0 then
		r_type = def_dialog_type_none();
	end
	
	if (o_object ~= nil and object_get_maximum_vitality(o_object, true) > 0.0 and object_get_health(o_object) <= 0.0) then
		r_type = def_dialog_type_none();
	end
	
	-- play the line
	if (r_type ~= def_dialog_type_none() and not sys_dialog_mute_dialog) then
		-- increment the current active line cnt	
		sys_dialog_type_line_active_inc(r_type, 1);
		
		-- store foreground line information
		if dialog_foreground_id_check(l_dialog_id) then
			-- set the foreground thread id
			sys_dialog_foreground_line_thread_set(GetCurrentThreadId());
			
			-- set the foreground line index
			sys_dialog_foreground_line_index_set(s_line_index);
			
			-- set the foreground line speaker
			sys_dialog_foreground_line_speaker_set(str_speaker_id);
			
			-- set the foreground line sound
			sys_dialog_foreground_line_sound_set(snd_sound);
			
			-- set the foreground line timer
			sys_dialog_foreground_line_timer_set(l_timer);
		end
		-- wait for there to be players for Chief to speak
		if (str_speaker_id == def_dialog_speaker_id_chief() and player_living_count() == 0) then
			sys_dialog_debug("sys_dialog_line_thread", "EITHER ALL PLAYERS HAVE DIED OR HAVE NOT SPAWNED YET, WAITING TO PLAY CHIEF LINE!!!");
			SleepUntil([| player_living_count() > 0 ], 1);
		end
		-- play the sound
		local validSound:boolean = false;
		if (snd_sound ~= nil) then
			
			if (not b_subtitle_only) then
				if (GetEngineType(o_object) ~= "ai") then
					if (t_players) then
						for key,o_player in pairs(t_players) do
							if (IsPlayer(o_player)) then
								--print("Playing on specific clients : " .. s_line_index);
								PlayDialogOnSpecificClients(snd_sound, o_object, o_player);
								validSound = true;
							end
						end
					else
						--print("Playing everywhere : " .. s_line_index);
						PlayDialogOnClients(snd_sound, o_object);
						validSound = true;
					end
				else
					print("DIALOG ERROR: Trying to play dialog from an AI. Use ai_get_object(AI.whatever)!");
				end
				
				-- The best we can realistically do is take the max sound and wait that long.
				-- We really can't account for latency or anything from script.
				l_snd_time = sound_max_time(snd_sound);
				
				--Disabling the old way in favor of enabling client dialog
				--sound_impulse_start_dialogue(snd_sound, o_object);				
				--l_snd_time = sound_impulse_time(snd_sound);
				--sound_impulse_time now requires 2 parameters, second being max time in ticks, or the C++ function will call a legacy function (very bad things)
				--l_snd_time = sound_impulse_time(snd_sound, l_snd_time);
			else
				--play_sound_subtitle(snd_sound);
				l_snd_time = sound_max_time(snd_sound);
			end
			r_pad = r_pad + frames_to_seconds(l_snd_time);
			--print("r_pad : " .. r_pad .. " l_snd_time : " .. l_snd_time);
		elseif (l_snd_time == 0) then
			r_pad = r_pad + dialog_line_temp_blurb_pad_get();
		end

		if (validSound) then
			--TEST
			--print("sys_dialog_line_thread", "l_snd_time = " .. l_snd_time);
			--print("sys_dialog_line_thread", "r_pad = " .. r_pad);
		
			-- display story blurb if necessary
			if (str_debug ~= "" and dialog_line_temp_blurb_get() and (snd_sound == nil or dialog_line_temp_blurb_force_get() or editor_mode())) then
				local l_blurb_thread:thread=nil;
			
				-- take 1 frame off the pad because of the thread delay
				r_pad = r_pad - frames_to_seconds(1);
			
				if (str_speaker_id == def_dialog_speaker_id_chief()) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_chief, str_debug, r_pad);
				end
			
				if (str_speaker_id == def_dialog_speaker_id_cortana()) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_cortana, str_debug, r_pad);
				end
			
				if (str_speaker_id == def_dialog_speaker_id_didact()) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_didact, str_debug, r_pad);
				end
	
				if (str_speaker_id == def_dialog_speaker_id_npc()) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_npc, str_debug, r_pad);
				end
	
				if (str_speaker_id == def_dialog_speaker_id_radio()) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_radio, str_debug, r_pad);
				end
	
				if (l_blurb_thread == nil) then
					l_blurb_thread = CreateThread(sys_dialog_blurb_other, str_debug, r_pad);
				end
			end
		
			-- applies auto pad time
			r_pad = r_pad + dialog_line_auto_pad_get();

			--TEST
			--print("sys_dialog_line_thread", "dialog_line_auto_pad_get = " .. dialog_line_auto_pad_get());
		
			-- calculate the timer
			l_timer = timer_stamp(((r_pad < 0.0) and 0.0) or r_pad);	-- This passes 0.0 if the less-than check is false, otherwise it passes r_pad (this is the nature of the 'and' and 'or' functions in Lua)
			--l_timer = game_tick_get() + seconds_to_frames( r_pad );

			--TEST
			--print("sys_dialog_line_thread", "l_timer = " .. l_timer);
			
			
		
			-- store foreground line information
			if (dialog_foreground_id_check(l_dialog_id)) then
				-- set the foreground line timer
				sys_dialog_foreground_line_timer_set(l_timer);
			end
			
			-- wait for the line to finish or be interrupted
			--SleepUntil([| 		--If all players are dead, kill chief and cortana dialog.
			--	timer_expired(l_timer)
			--	or ((str_speaker_id == def_dialog_speaker_id_chief() or str_speaker_id == def_dialog_speaker_id_cortana()) and player_living_count() == 0)
			--	or (o_object ~= nil and object_get_maximum_vitality(o_object, true) > 0.0 and object_get_health(o_object) <= 0.0)
			--	or (b_line_interruptable and  not IsThreadValid(l_dialog_id)) ], 1);
			
			local exitVal:boolean = false;
			local startTime:number = get_total_game_time_seconds_NOT_QUITE_RELEASE();
			local currentTime:number;
			repeat
				currentTime = get_total_game_time_seconds_NOT_QUITE_RELEASE();
				if( currentTime - startTime > r_pad ) then
					exitVal = true;
				end
				if (((str_speaker_id == def_dialog_speaker_id_chief() or str_speaker_id == def_dialog_speaker_id_cortana()) and player_living_count() == 0) or (o_object ~= nil and object_get_maximum_vitality(o_object, true) > 0.0 and object_get_health(o_object) <= 0.0) or (b_line_interruptable and  not IsThreadValid(l_dialog_id))) then
					exitVal = true;
				end
				Sleep(1);
			until (exitVal == true);
			
			-- if the timer is still valid that means the conversation has ended, kill the line
			--if game_tick_get() < l_timer then
			--	sound_impulse_stop(snd_sound);
			--end
			
			if get_total_game_time_seconds_NOT_QUITE_RELEASE() < (startTime + r_pad) then
				--sound_impulse_stop(snd_sound);
			end
			
			-- Holding out if there's no Chief
			if ((str_speaker_id == def_dialog_speaker_id_chief() or str_speaker_id == def_dialog_speaker_id_cortana()) and player_living_count() == 0) then
				sys_dialog_debug("sys_dialog_line_thread", "EITHER ALL PLAYERS HAVE DIED OR HAVE NOT SPAWNED YET, WAITING TO PLAY CHIEF LINE!!!");		
				SleepUntil([| player_living_count() > 0 ], 1);
			end
		end

		-- decrement the current active line cnt	
		sys_dialog_type_line_active_inc(r_type, -1);
	end
	
	sys_dialog_foreground_line_thread_set(nil);
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: INDEX
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_line_index_get: Gets the current foreground line index
--	RETURN:		[short] Current foreground line index
function dialog_foreground_line_index_get():number
	return s_dialog_foreground_line_index_769bb0dd;
end

-- === dialog_foreground_line_index_check_equel: Checks if dialog_foreground_line_index_get() == s_line_index
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() == s_line_index
function dialog_foreground_line_index_check_equel( s_line_index:number ):boolean
	return dialog_foreground_line_index_get() == s_line_index;
end

-- === dialog_foreground_line_index_check_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() == s_line_index
--			l_dialog_id = Dialog ID to test
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() == s_line_index
function dialog_foreground_id_line_index_check_equel( l_dialog_id:thread, s_line_index:number ):boolean
	return dialog_foreground_id_active_check(l_dialog_id) and dialog_foreground_line_index_check_equel(s_line_index);
end

-- === dialog_foreground_line_index_check_less: Checks if dialog_foreground_line_index_get() < s_line_index
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() < s_line_index
function dialog_foreground_line_index_check_less( s_line_index:number ):boolean
	return dialog_foreground_line_index_get() < s_line_index;
end

-- === dialog_foreground_id_line_index_check_less: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() < s_line_index
--			l_dialog_id = Dialog ID to test
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() < s_line_index
function dialog_foreground_id_line_index_check_less( l_dialog_id:thread, s_line_index:number ):boolean
	return dialog_foreground_id_active_check(l_dialog_id) and dialog_foreground_line_index_check_less(s_line_index);
end

-- === dialog_foreground_line_index_check_less_equel: Checks if dialog_foreground_line_index_get() <= s_line_index
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() <= s_line_index
function dialog_foreground_line_index_check_less_equel( s_line_index:number ):boolean
	return dialog_foreground_line_index_get() <= s_line_index;
end

-- === dialog_foreground_id_line_index_check_less_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() <= s_line_index
--			l_dialog_id = Dialog ID to test
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() <= s_line_index
function dialog_foreground_id_line_index_check_less_equel( l_dialog_id:thread, s_line_index:number ):boolean
	return dialog_foreground_id_active_check(l_dialog_id) and dialog_foreground_line_index_check_less_equel(s_line_index);
end

-- === dialog_foreground_line_index_check_greater: Checks if dialog_foreground_line_index_get() > s_line_index
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() > s_line_index
function dialog_foreground_line_index_check_greater( s_line_index:number ):boolean
	return dialog_foreground_line_index_get() > s_line_index;
end

-- === dialog_foreground_id_line_index_check_greater: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() > s_line_index
--			l_dialog_id = Dialog ID to test
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() > s_line_index
function dialog_foreground_id_line_index_check_greater( l_dialog_id:thread, s_line_index:number ):boolean
	return dialog_foreground_id_active_check(l_dialog_id) and dialog_foreground_line_index_check_greater(s_line_index);
end

-- === dialog_foreground_line_index_check_greater_equel: Checks if dialog_foreground_line_index_get() >= s_line_index
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if dialog_foreground_line_index_get() >= s_line_index
function dialog_foreground_line_index_check_greater_equel( s_line_index:number ):boolean
	return dialog_foreground_line_index_get() >= s_line_index;
end

-- === dialog_foreground_id_line_index_check_greater_equel: Checks if the dialog ID is the current FOREGROUND active dialog and dialog_foreground_line_index_get() >= s_line_index
--			l_dialog_id = Dialog ID to test
--			s_line_index = Line index to compare
--	RETURN:		[boolean] TRUE; if the dialog id is the current FOREGROUND active dialog and dialog_foreground_line_index_get() >= s_line_index
function dialog_foreground_id_line_index_check_greater_equel( l_dialog_id:thread, s_line_index:number ):boolean
	return dialog_foreground_id_active_check(l_dialog_id) and dialog_foreground_line_index_check_greater_equel(s_line_index);
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_foreground_line_index_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_line_index_set: Sets the foreground line index
function sys_dialog_foreground_line_index_set( s_index:number ):void
	sys_dialog_debug("sys_dialog_foreground_line_index_set", "");
	s_dialog_foreground_line_index_769bb0dd = s_index;
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: SPEAKER
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_line_speaker_get: Gets the current foreground line speaker
--	RETURN:		[string] Current foreground line speaker 
function dialog_foreground_line_speaker_get():string
	return str_dialog_foreground_line_speaker_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global str_dialog_foreground_line_speaker_769bb0dd:string=def_dialog_speaker_id_none();

-- === sys_dialog_foreground_line_speaker_set: Sets the current foreground line speaker
function sys_dialog_foreground_line_speaker_set( str_speaker_id:string ):void
	sys_dialog_debug("sys_dialog_foreground_line_speaker_set", "");
	str_dialog_foreground_line_speaker_769bb0dd = str_speaker_id;
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: SOUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_line_sound_get: Gets the current foreground line sound file tag
--	RETURN:		[sound] Current foreground line sound 
function dialog_foreground_line_sound_get():tag
	return snd_dialog_foreground_line_sound_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global snd_dialog_foreground_line_sound_769bb0dd:tag=nil;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_line_sound_set: Sets the current foreground line sound
function sys_dialog_foreground_line_sound_set( snd_sound:tag ):void
	sys_dialog_debug("sys_dialog_foreground_line_sound_set", "");
	snd_dialog_foreground_line_sound_769bb0dd = snd_sound;
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: TIMER
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_line_timer_get: Gets the current 
--	RETURN:		[long] game_tick_get() time in which the current foreground line timer will expire
function dialog_foreground_line_timer_get():number
	return l_dialog_foreground_line_timer_769bb0dd;
end

-- === dialog_foreground_line_timer_remaining_seconds: Gets seconds left for current foreground line id 
--	RETURN:		[real] Time (in seconds) remaining for the current foreground line ID
function dialog_foreground_line_timer_remaining_seconds():number
	return frames_to_seconds(dialog_foreground_line_timer_remaining_ticks());
end

-- === dialog_foreground_line_timer_remaining_ticks: Gets ticks left for current foreground line id
--	RETURN:		[long] Time (in ticks) remaining for the current foreground line ID
function dialog_foreground_line_timer_remaining_ticks():number
	return dialog_foreground_line_timer_get() - game_tick_get();
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global l_dialog_foreground_line_timer_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_line_timer_set: Sets the current foreground line timer
function sys_dialog_foreground_line_timer_set( l_timer:number ):void
	sys_dialog_debug("sys_dialog_foreground_line_timer_set", "");
	l_dialog_foreground_line_timer_769bb0dd = l_timer;
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: THREAD
-- =================================================================================================
-- === dialog_foreground_line_thread_get: Gets the thread ID to the current foreground line ID
--	RETURN:		[thread] Thread handle to the current foreground line ID
function dialog_foreground_line_thread_get():thread
	return l_dialog_foreground_line_id_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global l_dialog_foreground_line_id_769bb0dd:thread=nil;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_line_thread_set: Sets the current foreground line id thread index
function sys_dialog_foreground_line_thread_set( l_line_thread:thread ):void
	sys_dialog_debug("sys_dialog_foreground_line_thread_set", "");
	l_dialog_foreground_line_id_769bb0dd = l_line_thread;
end

-- =================================================================================================
-- DIALOG: LINE: ACTIVE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line_active_check: Checks if there are any lines playing at this given time
--	RETURN:		[boolean] TRUE; a line is playing
function dialog_line_active_check():boolean
	return dialog_line_active_cnt() > 0;
end

-- === dialog_line_active_cnt: Gets the total number of active lines active
--	RETURN:		[short] Number of lines currently active
function dialog_line_active_cnt():number
	return dialog_foreground_line_active_cnt() + dialog_background_line_active_cnt();
end

-- =================================================================================================
-- DIALOG: LINE: TYPE: ACTIVE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_type_line_active_check: Checks how many lines are active from a particular type of dialog
--			r_type = Type of dialog to check
--	RETURN:		[boolean] TRUE; that type of dialog has active lines
function dialog_type_line_active_check( r_type:number ):boolean
	return dialog_type_line_active_cnt(r_type) > 0;
end

-- === dialog_type_line_active_cnt: Gets the current active line count for a dialog type
--			r_type = Type of dialog to check
--	RETURN:		[short] Quantity of active lines of the type playing
function dialog_type_line_active_cnt( r_type:number ):number
	local s_cnt:number=0;
	if sys_dialog_type_foreground(r_type) then
		s_cnt = dialog_foreground_line_active_cnt();
	end
	if sys_dialog_type_background(r_type) then
		s_cnt = dialog_background_line_active_cnt();
	end
	return s_cnt;
end

-- RETURN
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_type_line_active_inc: Increments the type active line cnt
--			r_type = Type of dialog to check
--			s_inc = Amount to increment
function sys_dialog_type_line_active_inc( r_type:number, s_inc:number ):void
	sys_dialog_debug("sys_dialog_type_line_active_inc", "");
	if sys_dialog_type_foreground(r_type) then
		sys_dialog_foreground_line_active_inc(s_inc);
	end
	if sys_dialog_type_background(r_type) then
		sys_dialog_background_line_active_inc(s_inc);
	end
end

-- =================================================================================================
-- DIALOG: LINE: FOREGROUND: ACTIVE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_line_active_check: Checks if there are any active foreground lines
--	RETURN:		[boolean] TRUE; there area active foreground lines
function dialog_foreground_line_active_check():boolean
	return dialog_foreground_line_active_cnt() > 0;
end

-- === dialog_foreground_line_active_cnt: Gets the current count of active foreground lines
--	RETURN:		[short] Quanity of active foreground lines
function dialog_foreground_line_active_cnt():number
	return s_dialog_foreground_line_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_foreground_line_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_line_active_inc: Increments the foreground active line cnt
function sys_dialog_foreground_line_active_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_foreground_line_active_inc", "");
	s_dialog_foreground_line_cnt_769bb0dd = s_dialog_foreground_line_cnt_769bb0dd + s_inc;
	if s_dialog_foreground_line_cnt_769bb0dd < 0 then
		s_dialog_foreground_line_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- DIALOG: LINE: BACKGROUND: CNT
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_line_active_check: Checks if there are any active background lines
--	RETURN:		[boolean] TRUE; there area active background lines
function dialog_background_line_active_check():boolean
	return dialog_background_line_active_cnt() > 0;
end

-- === dialog_background_line_active_cnt: Gets the current count of active background lines
--	RETURN:		[short] Quanity of active background lines
function dialog_background_line_active_cnt():number
	return s_dialog_background_line_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_background_line_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_background_line_active_inc: Increments the background active line cnt
function sys_dialog_background_line_active_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_background_line_active_inc", "");
	s_dialog_background_line_cnt_769bb0dd = s_dialog_background_line_cnt_769bb0dd + s_inc;
	if s_dialog_background_line_cnt_769bb0dd < 0 then
		s_dialog_background_line_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- DIALOG: LINE: AUTO PAD
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line_auto_pad_set: This time is always added to any line playing
--			r_pad [real]	= Time (seconds) to add to a line pad
function dialog_line_auto_pad_set( r_pad:number ):void
	sys_dialog_debug("dialog_line_auto_pad_set", "");
	r_pad_line_time_auto = r_pad;
end

-- === dialog_line_auto_pad_get: Gets the current line auto pad time
--	RETURN:		[real] Current dialog auto pad line time (seconds)
function dialog_line_auto_pad_get():number
	return r_pad_line_time_auto;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global r_pad_line_time_auto:number=0.0;

-- =================================================================================================
-- DIALOG: LINE: TEMP BLURB
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line_temp_blurb_set: Sets if a temp line (IE, on a line snd_sound == NONE) should display story blurbs
--			b_blurb [boolean]	= TRUE; displays blurbs
function dialog_line_temp_blurb_set( b_blurb:boolean ):void
	sys_dialog_debug("dialog_line_temp_blurb_set", "");
	b_temp_line_display_blurb = b_blurb;
end

-- === dialog_line_temp_blurb_get: Checks if dialog line temp blurbs are enabled
--	RETURN:		[boolean] TRUE; temp line blurbs are enabled
function dialog_line_temp_blurb_get():boolean
	return b_temp_line_display_blurb;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_temp_line_display_blurb:boolean=true;

-- =================================================================================================
-- DIALOG: LINE: TEMP BLURB: FORCE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line_temp_blurb_force_set: Set the temp blurb to be forced on (needs blurbs to be enabled too)
--			b_blurb [boolean]	= TRUE; force displays blurbs
function dialog_line_temp_blurb_force_set( b_blurb:boolean ):void
	sys_dialog_debug("dialog_line_temp_blurb_force_set", "");
	b_temp_line_display_blurb_force = b_blurb;
end

-- === dialog_line_temp_blurb_force_get: Checks if dialog line temp blurbs are force enabled
--	RETURN:		[boolean] TRUE; temp line blurbs force is enabled
function dialog_line_temp_blurb_force_get():boolean
	return b_temp_line_display_blurb_force;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_temp_line_display_blurb_force:boolean=false;

-- =================================================================================================
-- DIALOG: LINE: TEMP PAD
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_line_temp_blurb_pad_set: Default pad time for temp lines (IE, on a line snd_sound == NONE)
--			r_pad [real]	= Time (seconds) to pad after the line plays
function dialog_line_temp_blurb_pad_set( r_pad:number ):void
	sys_dialog_debug("dialog_line_temp_blurb_pad_set", "");
	r_line_temp_pad_time = r_pad;
end

-- === dialog_line_temp_blurb_pad_get: Gets the temp line blurb pad length
--	RETURN:		[real] Temp line pad length (seconds)
function dialog_line_temp_blurb_pad_get():number
	return r_line_temp_pad_time;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global r_line_temp_pad_time:number=3.25;

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: END
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_end: ends a dialog
--			l_id = ID for the dialog to end
--			b_active_invalidates = If line dialog is active this will return DEF_DIALOG_ID_INVALID() for the ID so if you store that it will not try and play the conversation again if it's called again
--			str_notify = Notify message if the dialog end is fired
--	RETURNS:  Returns TRUE if the dialog was the current dialog and ended
function dialog_end( l_id:thread, b_started_invalidates:boolean, b_active_invalidates:boolean, str_notify:string ):thread
	sys_dialog_debug("dialog_end", "");
	return sys_dialog_end(l_id, b_started_invalidates, b_active_invalidates, str_notify);
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_end: System that ends a conversation
function sys_dialog_end( l_id:thread, b_started_invalidates:boolean, b_active_invalidates:boolean, str_notify:string ):thread
	local r_type:number=def_dialog_type_background();
	sys_dialog_debug("sys_dialog_end", "");
	-- make sure the dialog id is active
	if dialog_id_active_check(l_id) then
		-- Check if this is the current foreground conversation
		if dialog_foreground_id_check(l_id) then
			sys_dialog_debug("sys_dialog_end", "FOREGROUND ----------------------------------------------");
			r_type = def_dialog_type_foreground();
			sys_dialog_foreground_current_set(def_dialog_id_none());
		else
			sys_dialog_debug("sys_dialog_end", "BACKGROUND ----------------------------------------------");
			sys_dialog_end_id_set(l_id);
		end
		sys_dialog_inspect_l("sys_dialog_end - l_id", l_id);
		-- wait for the thread to shut down
		SleepUntil([|  not IsThreadValid(l_id) ], 1);
		-- decrement the conversation counter
		--sys_dialog_type_active_inc( r_type, -1 );
		if b_active_invalidates then
			l_id = def_dialog_id_invalid();
		end
	elseif b_started_invalidates and  not dialog_id_none_check(l_id) then
		l_id = def_dialog_id_invalid();
	end
	if str_notify ~= "" then
		NotifyLevel(str_notify);
	end
	return l_id;
end

-- RETURN
-- =================================================================================================
-- DIALOG: END: ID
-- =================================================================================================
-- === f_dialog_end_id_get: Gets the current end id
function f_dialog_end_id_get():thread
	return l_dialog_end_id_769bb0dd;
end

-- === f_dialog_end_id_check: Checks an ID vs the current end ID
function f_dialog_end_id_check( l_id:thread ):boolean
	return f_dialog_end_id_get() == l_id;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global l_dialog_end_id_769bb0dd:thread=def_dialog_id_none();

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_end_id_set: Sets an ID to end
function sys_dialog_end_id_set( l_id:thread ):void
	sys_dialog_debug("sys_dialog_end_id_set", "WAIT");
	SleepUntil([|  not IsThreadValid(f_dialog_end_id_get()) ], 1);
	sys_dialog_debug("sys_dialog_end_id_set", "SET");
	l_dialog_end_id_769bb0dd = l_id;
end

-- =================================================================================================
-- DIALOG: END: INTERRUPT
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_end_interrupt: Interrupts a dialog ID (if interruptable)
--			l_id = ID for the dialog to interrupt
function dialog_end_interrupt( l_id:thread ):void
	CreateThread(sys_dialog_end_interrupt, l_id);
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global l_dialog_end_interrupt_id_769bb0dd:thread=def_dialog_id_none();

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_end_interrupt: Handles dialog interruption
function sys_dialog_end_interrupt( l_id:thread ):void
	sys_dialog_debug("sys_dialog_end_interrupt", "");
	print(l_id);
	sys_dialog_inspect_l("sys_dialog_end_interrupt - l_id", l_id);
	SleepUntil([| sys_dialog_end_interrupt_get() == def_dialog_id_none() ], 1);
	sys_dialog_end_interrupt_set(l_id);
	SleepUntil([|  not IsThreadValid(l_id) ], 1);
	sys_dialog_end_interrupt_set(def_dialog_id_none());
end

function sys_dialog_end_interrupt_set( l_id:thread ):void
	l_dialog_end_interrupt_id_769bb0dd = l_id;
end

function sys_dialog_end_interrupt_get():thread
	return l_dialog_end_interrupt_id_769bb0dd;
end

-- =================================================================================================
-- DIALOG: END: ALL
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_end_all: Ends all currently FOREGROUND and BACKGROUND running dialogs
function dialog_end_all():void
	local l_foreground_thread:thread=nil;
	local l_background_thread:thread=nil;
	sys_dialog_debug("dialog_end_all", "");
	repeat
		Sleep(1);
		l_foreground_thread = CreateThread(dialog_foreground_end_all);
		l_background_thread = CreateThread(dialog_background_end_all);
		SleepUntil([|  not IsThreadValid(l_foreground_thread) and  not IsThreadValid(l_background_thread) ], 1);
	until  not dialog_active_check();
end

-- =================================================================================================
-- DIALOG: END: ALL: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_end_all: Ends all currently FOREGROUND running dialogs
function dialog_foreground_end_all():void
	sys_dialog_debug("dialog_foreground_end_all", "");
	sys_dialog_foreground_end_all_set(true);
	SleepUntil([| dialog_foreground_active_cnt() == 0 ], 1);
	sys_dialog_foreground_end_all_set(false);
end

-- === dialog_foreground_end_all_check: Checks if all FOREGROUND dialogs are trying to be shut down
--	RETURN:		[boolean] TRUE; dialog FOREGROUND end all is active
function dialog_foreground_end_all_check():boolean
	return b_dialog_foreground_end_all_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_dialog_foreground_end_all_769bb0dd:boolean=false;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_end_all_set: Sets the FOREGROUND dialog end all flag
function sys_dialog_foreground_end_all_set( b_end_all:boolean ):void
	sys_dialog_debug("sys_dialog_foreground_end_all_set", "");
	b_dialog_foreground_end_all_769bb0dd = b_end_all;
end

-- =================================================================================================
-- DIALOG: END: ALL: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_end_all: Ends all currently BACKGROUND running dialogs
function dialog_background_end_all():void
	sys_dialog_debug("dialog_background_end_all", "");
	sys_dialog_background_end_all_set(true);
	SleepUntil([| dialog_background_active_cnt() == 0 ], 1);
	sys_dialog_background_end_all_set(false);
end

-- === dialog_background_end_all_check: Checks if all BACKGROUND dialogs are trying to be shut down
--	RETURN:		[boolean] dialog BACKGROUND end all is active
function dialog_background_end_all_check():boolean
	return b_dialog_background_end_all_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_dialog_background_end_all_769bb0dd:boolean=false;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_background_end_all_set: Sets the BACKGROUND dialog end all flag
function sys_dialog_background_end_all_set( b_end_all:boolean ):void
	sys_dialog_debug("sys_dialog_background_end_all_set", "");
	b_dialog_background_end_all_769bb0dd = b_end_all;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: DISABLE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_disable: Performs every action possible to remove a conversation from existance
--			str_dialog_name = Name of the dialog to remove
--			l_dialog_id = Dialog ID of the conversation to disable
--			r_unqueue_timeout = Time of the timeout for the dialog unqueue
--			b_thread_unque = This will thread the unqueue instead of making script wait
--	RETURN:		[thread] DEF_DIALOG_ID_INVALID();
function dialog_disable( str_dialog_name:string, l_dialog_id:thread, r_unqueue_timeout:number, b_thread:boolean ):thread
	if  not dialog_id_played_check(l_dialog_id) then
		if dialog_id_active_check(l_dialog_id) then
			dialog_end(l_dialog_id, true, true, "");
		elseif b_thread then
			CreateThread(dialog_unqueue_name, str_dialog_name, r_unqueue_timeout);
		else
			dialog_unqueue_name(str_dialog_name, r_unqueue_timeout);
		end
	end
	-- RETURN
	return def_dialog_id_invalid();
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: TYPE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DEFINES -----------------------------------------------------------------------------------------
function def_dialog_type_foreground():number
	return 01.0;
end

function def_dialog_type_background():number
	return 02.0;
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- DEFINES -----------------------------------------------------------------------------------------					
function def_dialog_type_all():number
	return -7.77;
end

function def_dialog_type_none():number
	return 0.0;
end

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_type_foreground: Checks if a dialog type is FOREGROUND
function sys_dialog_type_foreground( r_type:number ):boolean
	return r_type == def_dialog_type_foreground() or r_type == def_dialog_type_all();
end

-- === sys_dialog_type_background: Checks if a dialog type is BACKGROUND
function sys_dialog_type_background( r_type:number ):boolean
	return r_type == def_dialog_type_background() or r_type == def_dialog_type_all();
end

-- === sys_dialog_type_id_get: Gets what type a dialog id is
function sys_dialog_type_id_get( l_dialog_id:thread ):number
	local r_type:number=def_dialog_type_none();
	if dialog_foreground_id_check(l_dialog_id) then
		r_type = def_dialog_type_foreground();
	elseif dialog_background_id_active_check(l_dialog_id) then
		r_type = def_dialog_type_background();
	end
	return r_type;
end

-- RETURN
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: STYLE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DEFINES -----------------------------------------------------------------------------------------
-- --- BACKGROUND ONLY
function def_dialog_style_play():number
	return 0.0;
end

-- --- FOREGROUND ONLY
function def_dialog_style_interrupt():number
	return 1.0;
end

function def_dialog_style_interrupt_foreground():number
	return 1.1;
end

function def_dialog_style_interrupt_background():number
	return 1.2;
end

function def_dialog_style_interrupt_all():number
	return 1.9;
end

-- --- BACKGROUND & FOREGROUND
function def_dialog_style_queue():number
	return 2.0;
end

function def_dialog_style_queue_foreground():number
	return 2.1;
end

function def_dialog_style_queue_background():number
	return 2.2;
end

function def_dialog_style_queue_all():number
	return 2.9;
end

function def_dialog_style_skip():number
	return 3.0;
end

function def_dialog_style_skip_foreground():number
	return 3.1;
end

function def_dialog_style_skip_background():number
	return 3.2;
end

function def_dialog_style_skip_all():number
	return 3.9;
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_style_action: Checks if a dialog style is interrupt
function sys_dialog_style_action( str_name:string, l_id:thread, r_type:number, r_style:number ):boolean
	local b_return:boolean=true;
	local r_check_type:number=def_dialog_type_all();
	sys_dialog_debug("sys_dialog_style_action", "");
	sys_dialog_inspect_str("sys_dialog_style_action - str_name", str_name);
	sys_dialog_inspect_l("sys_dialog_style_action - l_id", l_id);
	sys_dialog_inspect_r("sys_dialog_style_action - r_type", r_type);
	-- PLAY STYLE
	if sys_dialog_style_play(r_style) then
		sys_dialog_debug("sys_dialog_style_action", "PLAY: START");
		if  not sys_dialog_type_background(r_type) then
			--Breakpoint("sys_dialog_style_action: DEF_DIALOG_STYLE_PLAY() style dialogs only work with BACKGROUND types");
			Sleep(1);
		end
		sys_dialog_debug("sys_dialog_style_action", "PLAY: END");
	end
	-- SKIP STYLE
	if sys_dialog_style_skip(r_style) then
		sys_dialog_debug("sys_dialog_style_action", "SKIP: START");
		-- set check type
		if r_style == def_dialog_style_skip() then
			r_check_type = r_type;
		end
		if r_style == def_dialog_style_skip_foreground() then
			r_check_type = def_dialog_type_foreground();
		end
		if r_style == def_dialog_style_skip_background() then
			r_check_type = def_dialog_type_background();
		end
		-- check if that dialog type is not active
		b_return =  not dialog_type_active_check(r_check_type);
		sys_dialog_debug("sys_dialog_style_action", "SKIP: END");
	end
	-- INTERRUPT & QUEUE STYLE
	if sys_dialog_style_interrupt(r_style) or sys_dialog_style_queue(r_style) then
		sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: GET CHECK TYPE");
		-- get the check type
		if r_style == def_dialog_style_interrupt() or r_style == def_dialog_style_queue() then
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = r_type");
			r_check_type = r_type;
		end
		if r_style == def_dialog_style_interrupt_foreground() or r_style == def_dialog_style_queue_foreground() then
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_TYPE_FOREGROUND()");
			r_check_type = def_dialog_type_foreground();
		end
		if r_style == def_dialog_style_interrupt_background() or r_style == def_dialog_style_queue_background() then
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_STYLE_INTERRUPT_BACKGROUND()");
			r_check_type = def_dialog_type_background();
		end
		if r_style == def_dialog_style_interrupt_all() or r_style == def_dialog_style_queue_all() then
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: r_check_type = DEF_DIALOG_TYPE_ALL()");
			r_check_type = def_dialog_type_all();
		end
		-- if a dialog of the checktype is active, it gets put in the queue
		if dialog_type_active_check(r_check_type) then
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: START");
			-- increment counters
			sys_dialog_type_queue_inc(r_type, 1);
			if sys_dialog_style_interrupt(r_style) then
				sys_dialog_interrupt_type_queue_inc(r_check_type, 1);
			end
			-- wait for time to play
			SleepUntil([| ( not dialog_type_active_check(r_check_type) and (sys_dialog_style_interrupt(r_style) or sys_dialog_interrupt_type_queue_cnt(r_type) == 0)) or sys_dialog_type_unqueue_check(r_type, str_name) ], 1);
			b_return =  not sys_dialog_type_unqueue_check(r_type, str_name);
			if dialog_debug_details_get() then
				dprint("-------------------------------------");
				print(str_name);
				dprint("dialog_type_active_check(r_check_type)");
				print(dialog_type_active_check(r_check_type));
				dprint("sys_dialog_style_interrupt(r_style)");
				print(sys_dialog_style_interrupt(r_style));
				dprint("sys_dialog_interrupt_type_queue_cnt(r_type)");
				print(sys_dialog_interrupt_type_queue_cnt(r_type));
				dprint("sys_dialog_type_unqueue_check(r_type, str_name)");
				print(sys_dialog_type_unqueue_check(r_type, str_name));
				dprint("return");
				print(b_return);
				--dprint( "" );
				--inspect( xxx );			
				dprint("-------------------------------------");
			end
			-- decrement counters
			if sys_dialog_style_interrupt(r_style) then
				sys_dialog_interrupt_type_queue_inc(r_check_type, -1);
			end
			sys_dialog_type_queue_inc(r_type, -1);
			-- set any unqueue SUCCESS
			if  not b_return then
				sys_dialog_debug("sys_dialog_style_action", "QUEUE: not b_return");
				sys_dialog_type_unqueue_success_set(r_type, str_name);
			end
			sys_dialog_debug("sys_dialog_style_action", "INTERRUPT/QUEUE: END");
		end
	end
	return b_return;
end

-- RETURN
-- === sys_dialog_style_play: Checks if a dialog style is auto play
function sys_dialog_style_play( r_style:number ):boolean
	return r_style == def_dialog_style_play();
end

-- === sys_dialog_style_interrupt: Checks if a dialog style is interrupt
function sys_dialog_style_interrupt( r_style:number ):boolean
	return r_style == def_dialog_style_interrupt() and r_style <= def_dialog_style_interrupt_all();
end

-- === sys_dialog_style_queue: Checks if a dialog style is queue
function sys_dialog_style_queue( r_style:number ):boolean
	return r_style >= def_dialog_style_queue() and r_style <= def_dialog_style_queue_all();
end

-- === sys_dialog_style_skip: Checks if a dialog style is skip
function sys_dialog_style_skip( r_style:number ):boolean
	return r_style >= def_dialog_style_skip() and r_style <= def_dialog_style_skip_all();
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- =================================================================================================
-- DIALOG: ID: VALID
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; dialog id is valid (active or has played but not invalid)
function dialog_id_valid_check( l_id:thread ):boolean
	return  not dialog_id_invalid_check(l_id) and  not dialog_id_none_check(l_id);
end

-- === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; dialog ID is invalid
function dialog_id_invalid_check( l_id:thread ):boolean
	return l_id == def_dialog_id_invalid();
end

-- === dialog_id_valid_check: Makes sure the ID is not an INVALID ID
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; dialog id == DEF_DIALOG_ID_NONE()
function dialog_id_none_check( l_id:thread ):boolean
	return l_id == def_dialog_id_none();
end

-- === dialog_id_played_check: Checks if a dialog id has played
--			NOTE: This requires that you use the same variable to track a conversation and the standard dialog system.  The dialog ID (really a thread ID) has to not be NONE and the thread is no longer active for this trigger to work properly.
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; Checks if the dialog ID has no longer active (playing)
function dialog_id_played_check( l_id:thread ):boolean
	return l_id ~= def_dialog_id_none() and  not IsThreadValid(l_id);
end

-- =================================================================================================
-- DIALOG: ID: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_id_check: Checks if this is the current foreground ID
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; dialog id is the current active FOREGROUND dialog id
function dialog_foreground_id_check( l_id:thread ):boolean
	return l_id ~= def_dialog_id_none() and l_id == dialog_foreground_current_get();
end

-- === dialog_foreground_current_get: Gets the current FOREGROUND dialog id
--	RETURN:		[thread] Currrent FOREGROUND dialog ID
function dialog_foreground_current_get():thread
	return l_dialog_foreground_id_current_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global l_dialog_foreground_id_current_769bb0dd:thread=def_dialog_id_none();

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_current_set: Sets the current active foreground dialog ID
function sys_dialog_foreground_current_set( l_id:thread ):void
	sys_dialog_debug("sys_dialog_foreground_current_set", "");
	sys_dialog_inspect_l("sys_dialog_foreground_current_set - l_id", l_id);
	l_dialog_foreground_id_current_769bb0dd = l_id;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: ACTIVE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_active_check: Checks if any dialog is active
--	RETURN:		[boolean] TRUE; there is any covnersation active
function dialog_active_check():boolean
	return dialog_active_cnt() > 0;
end

-- =================================================================================================
-- DIALOG: ACTIVE: ID
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_id_active_check: Checks if the dialog ID thread is active
--			l_id = Dialog ID to check if it's active
--	RETURN:		[boolean] TRUE; if it is active
function dialog_id_active_check( l_id:thread ):boolean
	return dialog_foreground_id_active_check(l_id) or dialog_background_id_active_check(l_id);
end

-- =================================================================================================
-- DIALOG: ACTIVE: TYPE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === covnersation: Checks if any dialog of r_type is active
--	RETURN:		[boolean] TRUE; there is any covnersation active
function dialog_type_active_check( r_type:number ):boolean
	return (sys_dialog_type_foreground(r_type) and dialog_foreground_current_active_check()) or (sys_dialog_type_background(r_type) and dialog_background_active_check());
end

-- =================================================================================================
-- DIALOG: ACTIVE: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_id_active_check: Checks if the id is the current and active FOREGROUND dialog
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; dialog ID is active and the current FOREGROUND dialog ID
function dialog_foreground_id_active_check( l_id:thread ):boolean
	return dialog_foreground_id_check(l_id) and IsThreadValid(l_id);
end

-- === dialog_foreground_current_active_check: Checks if the current FOREGROUND dialog id is active
--	RETURN:		[boolean] TRUE; It is active (playing)
function dialog_foreground_current_active_check():boolean
	return dialog_foreground_id_active_check(dialog_foreground_current_get());
end

-- === dialog_foreground_active_check: Checks if there are any FOREGROUND dialogs active
--	RETURN:		[boolean] TRUE; There is at least one FOREGROUND dialog ID active
function dialog_foreground_active_check():boolean
	return dialog_foreground_active_cnt() > 0;
end

-- =================================================================================================
-- DIALOG: ACTIVE: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_id_active_check: Checks if the id is an active BACKGROUND dialog
--			l_id = Dialog ID to check
--	RETURN:		[boolean] TRUE; The dialog id is an active (playing) BACKGROUND dialog
function dialog_background_id_active_check( l_id:thread ):boolean
	return l_id ~= def_dialog_id_none() and l_id ~= dialog_foreground_current_get() and IsThreadValid(l_id);
end

-- === dialog_background_active_check: Checks if there are any BACKGROUND dialogs active
--	RETURN:		[boolean] TRUE; There is at least one BACKGROUND dialog ID active
function dialog_background_active_check():boolean
	return dialog_background_active_cnt() > 0;
end

-- =================================================================================================
-- DIALOG: ACTIVE: CNT
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_active_cnt: Gets the total active dialogs
--	RETURN:		[short] Total active dialogs
function dialog_active_cnt():number
	return dialog_foreground_active_cnt() + dialog_background_active_cnt();
end

-- =================================================================================================
-- DIALOG: ACTIVE: CNT: TYPE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_type_active_cnt: Gets the current count of active dialogs of a type
--			r_type = Dialog type to check
--	RETURN:		[short] Total active dialogs of the type
function dialog_type_active_cnt( r_type:number ):number
	local s_return:number=0;
	if sys_dialog_type_foreground(r_type) then
		s_return = dialog_foreground_active_cnt();
	end
	if sys_dialog_type_background(r_type) then
		s_return = dialog_background_active_cnt();
	end
	return s_return;
end

-- RETURN
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- === sys_dialog_type_active_inc: Increments the count of type active dialogs
function sys_dialog_type_active_inc( r_type:number, s_inc:number ):void
	sys_dialog_debug("sys_dialog_type_active_inc", "");
	if sys_dialog_type_foreground(r_type) then
		sys_dialog_foreground_active_inc(s_inc);
	end
	if sys_dialog_type_background(r_type) then
		sys_dialog_background_active_inc(s_inc);
	end
end

-- =================================================================================================
-- DIALOG: ACTIVE: CNT: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_active_cnt: Gets the total count of FOREGROUND dialogs active
--	RETURN:		[short] Total count of FOREGROUND dialogs active
function dialog_foreground_active_cnt():number
	return s_dialog_foreground_active_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_foreground_active_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_active_inc: Increments the count of foreground active dialogs
function sys_dialog_foreground_active_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_foreground_active_inc", "");
	s_dialog_foreground_active_cnt_769bb0dd = s_dialog_foreground_active_cnt_769bb0dd + s_inc;
	if s_dialog_foreground_active_cnt_769bb0dd < 0 then
		s_dialog_foreground_active_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- DIALOG: ACTIVE: CNT: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_active_cnt: Gets the total count of BACKGROUND dialogs active
--	RETURN:		[short] Total count of BACKGROUND dialogs active
function dialog_background_active_cnt():number
	return s_dialog_background_active_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_background_active_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_background_active_inc: Increments the count of background active dialogs
function sys_dialog_background_active_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_background_active_inc", "");
	s_dialog_background_active_cnt_769bb0dd = s_dialog_background_active_cnt_769bb0dd + s_inc;
	if s_dialog_background_active_cnt_769bb0dd < 0 then
		s_dialog_background_active_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: NAME
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_name_valid_check: Checks if a dialog name is valid to use
--	RETURN:		[boolean] TRUE; if the name is acceptable
function dialog_name_valid_check( str_name:string ):boolean
	return str_name ~= def_str_dialog_name_none() and str_name ~= def_str_dialog_name_all();
end

-- === dialog_foreground_name_get: Gets the name of the current foreground dialog
--	RETURN:		[string] Name of the current foreground dialog
function dialog_foreground_name_get():string
	return str_dialog_foreground_name_current_769bb0dd;
end

-- === dialog_foreground_current_name_check: Checks if the current FOREGROUND dialog is name
--	RETURN:		[boolean] XXX
function dialog_foreground_current_name_check( str_name:string ):boolean
	return dialog_foreground_name_get() == str_name;
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- DEFINES -----------------------------------------------------------------------------------------
function def_str_dialog_name_none():string
	return "";
end

function def_str_dialog_name_all():string
	return "[ALL]";
end
-- VARIABLES ---------------------------------------------------------------------------------------
global str_dialog_foreground_name_current_769bb0dd:string="def_str_dialog_name_none";

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_current_name_set: Sets the current FOREGROUND dialog name value
--		b_name = TRUE; current foreground conversation should be name
function sys_dialog_foreground_current_name_set( str_name:string ):void
	sys_dialog_debug("dialog_foreground_current_name_set", "");
	sys_dialog_foreground_id_name_set(dialog_foreground_current_get(), str_name);
end

-- === dialog_foreground_id_name_set: Sets the dialog id name value if it is the current active FOREGROUND dialog
--		l_dialog_id = Dialog ID to set name
--		str_name = New name for the current foreground dialog
function sys_dialog_foreground_id_name_set( l_dialog_id:thread, str_name:string ):void
	sys_dialog_debug("dialog_foreground_id_name_set", "");
	if dialog_foreground_id_active_check(l_dialog_id) then
		sys_dialog_foreground_name_set(str_name);
	end
end

-- === dialog_foreground_name_get: Gets the name of the current foreground dialog
--	RETURN:		[string] Name of the current foreground dialog
function sys_dialog_foreground_name_set( str_name:string ):void
	str_dialog_foreground_name_current_769bb0dd = str_name;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: BACK PAD
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_back_pad_default_set: Sets the default pad time
--		r_time = Time (seconds) for the default queue pad time
function dialog_back_pad_default_set( r_time:number ):void
	sys_dialog_debug("dialog_back_pad_default_set", "");
	r_dialog_back_pad_default_769bb0dd = r_time;
end

-- === dialog_back_pad_default_get: Gets the default pad time
--	RETURN:		[REAL] Current default queue pad time (seconds)
function dialog_back_pad_default_get():number
	return r_dialog_back_pad_default_769bb0dd;
end
-- RETURN
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- TODO --------------------------------------------------------------------------------------------
-- XXX ADD SEPERATE BACK PAD DEFAULTS FOR EACH TYPE
-- VARIABLES ---------------------------------------------------------------------------------------
global r_dialog_back_pad_default_769bb0dd:number=0.0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_style_use_back_pad: Checks if this style uses back_pad on dialogs
function sys_dialog_style_use_back_pad( r_style:number ):boolean
	return r_style >= def_dialog_style_interrupt() and r_style <= def_dialog_style_queue_background();
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: INTERRUPTABLE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_interruptable_get: XXXX
--	RETURN:		[boolean] XXX
function dialog_foreground_interruptable_get():boolean
	return b_dialog_foreground_interruptable_769bb0dd;
end

-- === dialog_foreground_current_interruptable_check: Checks if the current FOREGROUND dialog is interruptable
--	RETURN:		[boolean] XXX
function dialog_foreground_current_interruptable_check():boolean
	return dialog_foreground_interruptable_get() or  not dialog_foreground_current_active_check();
end

-- === dialog_id_interruptable_check: Checks if this is the current FOREGROUND id and if it's interruptable
--	RETURN:		[boolean] TRUE; it's not the current FOREGROUND id or it's interruptable
function dialog_id_interruptable_check( l_dialog_id:thread ):boolean
	return  not dialog_foreground_id_active_check(l_dialog_id) or dialog_foreground_interruptable_get();
end

-- === dialog_foreground_current_interruptable_set: Sets the current FOREGROUND dialog interruptable value
--		b_interruptable = TRUE; current foreground conversation should be interruptable
--	RETURN:		[boolean] XXX
function dialog_foreground_current_interruptable_set( b_interruptable:boolean ):boolean
	sys_dialog_debug("dialog_foreground_current_interruptable_set", "");
	return dialog_foreground_id_interruptable_set(dialog_foreground_current_get(), b_interruptable);
end

-- === dialog_foreground_id_interruptable_set: Sets the dialog id interruptable value if it is the current active FOREGROUND dialog
--		l_dialog_id = Dialog ID to set interruptable
--		b_interruptable = TRUE; current foreground conversation should be interruptable
--	RETURN:		[boolean] XXX
function dialog_foreground_id_interruptable_set( l_dialog_id:thread, b_interruptable:boolean ):boolean
	local b_return:boolean=false;
	sys_dialog_debug("dialog_foreground_id_interruptable_set", "");
	if dialog_foreground_id_active_check(l_dialog_id) then
		sys_dialog_foreground_interruptable_set(b_interruptable);
		b_return = false;
	end
	return b_return;
end
-- RETURN
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_dialog_foreground_interruptable_769bb0dd:boolean=false;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_interruptable_set: XXXX
--		b_interruptable = XXXX
function sys_dialog_foreground_interruptable_set( b_interruptable:boolean ):void
	sys_dialog_debug("sys_dialog_foreground_interruptable_set", "");
	b_dialog_foreground_interruptable_769bb0dd = b_interruptable;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: QUEUE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_queue_cnt: Gets the total count of FOREGROUND and BACKGROUND dialogs queue'd
--	RETURN:		[short] Total count of FOREGROUND and BACKGROUND dialogs queue'd
function dialog_queue_cnt():number
	return dialog_foreground_queue_cnt() + dialog_background_queue_cnt();
end

-- =================================================================================================
-- DIALOG: QUEUE: TYPE
-- =================================================================================================
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_type_queue_inc: Increments a type que cnt
function sys_dialog_type_queue_inc( r_type:number, s_inc:number ):void
	sys_dialog_debug("sys_dialog_type_queue_inc", "");
	if sys_dialog_type_foreground(r_type) then
		sys_dialog_foreground_queue_inc(s_inc);
	end
	if sys_dialog_type_background(r_type) then
		sys_dialog_background_queue_inc(s_inc);
	end
end

-- =================================================================================================
-- DIALOG: QUEUE: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_queue_cnt: Gets the total count of FOREGROUND dialogs queue'd
--	RETURN:		[short] Total count of FOREGROUND dialogs queue'd
function dialog_foreground_queue_cnt():number
	return s_dialog_foreground_queue_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_foreground_queue_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_queue_inc: Increments the count of foreground queue'd dialogs
function sys_dialog_foreground_queue_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_foreground_queue_inc", "");
	s_dialog_foreground_queue_cnt_769bb0dd = s_dialog_foreground_queue_cnt_769bb0dd + s_inc;
	if s_dialog_foreground_queue_cnt_769bb0dd < 0 then
		s_dialog_foreground_queue_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- DIALOG: QUEUE: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_queue_cnt: Gets the total count of BACKGROUND dialogs queue'd
--	RETURN:		[short] Total count of BACKGROUND dialogs queue'd
function dialog_background_queue_cnt():number
	return s_dialog_background_queue_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_background_queue_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_background_queue_inc: Increments the count of background queue'd dialogs
function sys_dialog_background_queue_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_background_queue_inc", "");
	s_dialog_background_queue_cnt_769bb0dd = s_dialog_background_queue_cnt_769bb0dd + s_inc;
	if s_dialog_background_queue_cnt_769bb0dd < 0 then
		s_dialog_background_queue_cnt_769bb0dd = 0;
	end
end

-- =================================================================================================
-- =================================================================================================
-- DIALOG: QUEUE: INTERRUPT
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_interrupt_queue_cnt: Gets the total count of FOREGROUND and BACKGROUND interrupt dialogs queue'd
--	RETURN:		[short] Total count of FOREGROUND and BACKGROUND dialogs queue'd
function dialog_interrupt_queue_cnt():number
	return dialog_interrupt_foreground_queue_cnt() + dialog_interrupt_background_queue_cnt();
end

-- =================================================================================================
-- DIALOG: QUEUE: INTERRUPT: TYPE
-- =================================================================================================
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_interrupt_type_queue_inc: Increments a type que cnt
function sys_dialog_interrupt_type_queue_inc( r_type:number, s_inc:number ):void
	sys_dialog_debug("sys_dialog_interrupt_type_queue_inc", "");
	if sys_dialog_type_foreground(r_type) then
		sys_dialog_interrupt_foreground_queue_inc(s_inc);
	end
	if sys_dialog_type_background(r_type) then
		sys_dialog_interrupt_background_queue_inc(s_inc);
	end
end

-- === sys_dialog_interrupt_type_queue_cnt: Increments a type que cnt
function sys_dialog_interrupt_type_queue_cnt( r_type:number ):number
	local s_cnt:number=0;
	if sys_dialog_type_foreground(r_type) then
		s_cnt = dialog_interrupt_foreground_queue_cnt();
	end
	if sys_dialog_type_background(r_type) then
		s_cnt = dialog_interrupt_background_queue_cnt();
	end
	return s_cnt;
end

-- returns
-- =================================================================================================
-- DIALOG: QUEUE: INTERRUPT: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_interrupt_foreground_queue_cnt: Gets the total count of FOREGROUND dialogs queue'd
--	RETURN:		[short] Total count of FOREGROUND dialogs queue'd
function dialog_interrupt_foreground_queue_cnt():number
	return s_dialog_interrupt_foreground_queue_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_interrupt_foreground_queue_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_interrupt_foreground_queue_inc: Increments the count of foreground queue'd dialogs
function sys_dialog_interrupt_foreground_queue_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_interrupt_foreground_queue_inc", "");
	s_dialog_interrupt_foreground_queue_cnt_769bb0dd = s_dialog_interrupt_foreground_queue_cnt_769bb0dd + s_inc;
	if s_dialog_interrupt_foreground_queue_cnt_769bb0dd < 0 then
		s_dialog_interrupt_foreground_queue_cnt_769bb0dd = 0;
	end
	sys_dialog_inspect_s("sys_dialog_interrupt_foreground_queue_inc - S_dialog_interrupt_foreground_queue_cnt", s_dialog_interrupt_foreground_queue_cnt_769bb0dd);
end

-- =================================================================================================
-- DIALOG: QUEUE: INTERRUPT: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_interrupt_background_queue_cnt: Gets the total count of BACKGROUND dialogs queue'd
--	RETURN:		[short] Total count of BACKGROUND dialogs queue'd
function dialog_interrupt_background_queue_cnt():number
	return s_dialog_interrupt_background_queue_cnt_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global s_dialog_interrupt_background_queue_cnt_769bb0dd:number=0;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_interrupt_background_queue_inc: Increments the count of background queue'd dialogs
function sys_dialog_interrupt_background_queue_inc( s_inc:number ):void
	sys_dialog_debug("sys_dialog_interrupt_background_queue_inc", "");
	s_dialog_interrupt_background_queue_cnt_769bb0dd = s_dialog_interrupt_background_queue_cnt_769bb0dd + s_inc;
	if s_dialog_interrupt_background_queue_cnt_769bb0dd < 0 then
		s_dialog_interrupt_background_queue_cnt_769bb0dd = 0;
	end
	sys_dialog_inspect_s("sys_dialog_interrupt_background_queue_inc - S_dialog_interrupt_background_queue_cnt", s_dialog_interrupt_background_queue_cnt_769bb0dd);
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: UNQUEUE
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_unqueue_name: Unque's FOREGROUND and BACKGROUND dialogs with the name
--		str_name = Name of the dialog being queue'd to unqueue
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue'd a FOREGROUND and BACKGROUND dialog with this name
function dialog_unqueue_name( str_name:string, r_timeout:number ):boolean
	local l_foreground_thread:thread=nil;
	local l_background_thread:thread=nil;
	sys_dialog_debug("dialog_unqueue_name", "");
	-- setup threads to kill each type of the same name
	l_foreground_thread = CreateThread(dialog_foreground_unqueue_name, str_name, r_timeout);
	l_background_thread = CreateThread(dialog_background_unqueue_name, str_name, r_timeout);
	-- wait for the threads to finish
	SleepUntil([|  not IsThreadValid(l_foreground_thread) and  not IsThreadValid(l_background_thread) ], 1);
	-- RETURN
	return str_name == sys_dialog_foreground_unqueue_success_get() or str_name == sys_dialog_background_unqueue_success_get() or dialog_foreground_queue_cnt() <= 0;
end

-- === dialog_unqueue_all: Unque's all FOREGROUND and BACKGROUND dialogs
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue's all the FOREGROUND and BACKGROUND dialogs
function dialog_unqueue_all( r_timeout:number ):boolean
	sys_dialog_debug("dialog_unqueue_all", "");
	return dialog_unqueue_name("def_str_dialog_name_all", r_timeout);
end

-- === dialog_unqueue_active: Checks if a FOREGROUND or BACKGROUND dialog unqueue is active
--	RETURN:		[boolean] TRUE; FOREGROUND or BACKGROUND dialog unqueue is active
function dialog_unqueue_active():boolean
	return dialog_foreground_unqueue_active() or dialog_background_unqueue_active();
end

-- =================================================================================================
-- DIALOG: UNQUEUE: TYPE
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_type_unqueue_active: Checks if a type of dialog has an unqueue action active
--	RETURN:		[boolean] TRUE; If there is an unqueue queue active of this r_type
function dialog_type_unqueue_active( r_type:number ):boolean
	return (sys_dialog_type_foreground(r_type) and dialog_foreground_unqueue_active()) or (sys_dialog_type_background(r_type) and dialog_background_unqueue_active());
end

-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_type_unqueue_check: Checks if this is a dialog of this type that should be unqueue'd
--	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
function sys_dialog_type_unqueue_check( r_type:number, str_name:string ):boolean
	return (sys_dialog_type_foreground(r_type) and sys_dialog_foreground_unqueue_check(str_name)) or (sys_dialog_type_background(r_type) and sys_dialog_background_unqueue_check(str_name));
end

-- === sys_dialog_type_unqueue_success_set: XXX
function sys_dialog_type_unqueue_success_set( r_type:number, str_name:string ):void
	sys_dialog_debug("sys_dialog_type_unqueue_success_set", "");
	if sys_dialog_type_foreground(r_type) then
		sys_dialog_foreground_unqueue_success_set(str_name);
	end
	if sys_dialog_type_background(r_type) then
		sys_dialog_background_unqueue_success_set(str_name);
	end
end

-- =================================================================================================
-- DIALOG: UNQUEUE: FOREGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_foreground_unqueue_name: Unque's FOREGROUND dialogs with the name
--		str_name = Name of the dialog being queue'd to unqueue
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue'd a FOREGROUND dialog with this name
function dialog_foreground_unqueue_name( str_name:string, r_timeout:number ):boolean
	local b_return:boolean=false;
	local l_timeout:number=0;
	sys_dialog_debug("dialog_foreground_unqueue_name", "");
	if str_name ~= def_str_dialog_name_none() then
		-- start
		l_timeout = game_tick_get() + seconds_to_frames(r_timeout);
		-- wait for other unques to finish or if DEF_STR_DIALOG_NAME_ALL() take over unqueue
		SleepUntil([| dialog_foreground_queue_cnt() <= 0 or  not dialog_foreground_unqueue_active() or game_tick_get() > l_timeout or (str_name == "def_str_dialog_name_all" and sys_dialog_foreground_unqueue_get() ~= "def_str_dialog_name_all") ], 1);
		-- set which dialog name to unqueue
		sys_dialog_foreground_unqueue_set(str_name);
		-- set the success check to none before attempting unqueue
		sys_dialog_foreground_unqueue_success_set(def_str_dialog_name_none());
		-- wait for the unqueue to cycle
		SleepUntil([| dialog_foreground_queue_cnt() <= 0 or  not dialog_foreground_unqueue_active() or game_tick_get() > l_timeout ], 1);
		-- check for success
		b_return = str_name == sys_dialog_foreground_unqueue_success_get() or dialog_foreground_queue_cnt() <= 0;
		-- release the unqueue variable if it's still current
		if str_name == sys_dialog_foreground_unqueue_get() then
			sys_dialog_foreground_unqueue_set(def_str_dialog_name_none());
		end
	else
		Breakpoint("dialog_foreground_unqueue_name: INVALID DIALOG NAME");
		Sleep(1);
	end
	return b_return;
end

-- RETURN
-- === dialog_foreground_unqueue_all: Unque's all FOREGROUND dialogs
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue's all the FOREGROUND dialogs
function dialog_foreground_unqueue_all( r_timeout:number ):boolean
	sys_dialog_debug("dialog_foreground_unqueue_all", "");
	return dialog_foreground_unqueue_name("def_str_dialog_name_all", r_timeout);
end

-- === dialog_foreground_unqueue_active: Checks if a FOREGROUND dialog unqueue is active 
--	RETURN:		[boolean] TRUE; FOREGROUND dialog unqueue is active
function dialog_foreground_unqueue_active():boolean
	return sys_dialog_foreground_unqueue_get() ~= "def_str_dialog_name_none";
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global str_dialog_foreground_unqueue_name_769bb0dd:string="def_str_dialog_name_none";
global str_dialog_foreground_unqueue_success_769bb0dd:string="def_str_dialog_name_none";

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_foreground_unqueue_set: Sets the name of the FOREGROUND dialog to unqueue
function sys_dialog_foreground_unqueue_set( str_name:string ):void
	sys_dialog_debug("sys_dialog_foreground_unqueue_set", "");
	str_dialog_foreground_unqueue_name_769bb0dd = "def_str_dialog_name_none";
end

-- === sys_dialog_foreground_unqueue_get: Gets the name of the FOREGROUND dialog being unqueue'd
--	RETURN:		[string] Name of the FOREGROUND dialog being unqueue'd
function sys_dialog_foreground_unqueue_get():string
	return str_dialog_foreground_unqueue_name_769bb0dd;
end

-- === sys_dialog_foreground_unqueue_check: Checks if this is a FOREGROUND dialog that should be unqueue'd
--	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
function sys_dialog_foreground_unqueue_check( str_name:string ):boolean
	return sys_dialog_foreground_unqueue_get() == str_name or sys_dialog_foreground_unqueue_get() == def_str_dialog_name_all();
end

-- === sys_dialog_foreground_unqueue_success_set: Sets the name of the FOREGROUND dialog that was unqueue'd
function sys_dialog_foreground_unqueue_success_set( str_name:string ):void
	sys_dialog_debug("sys_dialog_foreground_unqueue_success_set", "");
	str_dialog_foreground_unqueue_success_769bb0dd = str_name;
end

-- === sys_dialog_foreground_unqueue_success_get: Gets the name of the FOREGROUND dialog that was unqueue'd
--	RETURN:		[string] Name of the FOREGROUND dialog that was unqueue'd
function sys_dialog_foreground_unqueue_success_get():string
	return str_dialog_foreground_unqueue_success_769bb0dd;
end

-- =================================================================================================
-- DIALOG: UNQUEUE: BACKGROUND
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_background_unqueue_name: Unque's BACKGROUND dialogs with the name
--		str_name = Name of the dialog being queue'd to unqueue
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue'd a BACKGROUND dialog with this name
function dialog_background_unqueue_name( str_name:string, r_timeout:number ):boolean
	local b_return:boolean=false;
	local l_timeout:number=0;
	sys_dialog_debug("dialog_background_unqueue_name", "");
	if str_name ~= def_str_dialog_name_none() then
		-- start
		l_timeout = game_tick_get() + seconds_to_frames(r_timeout);
		-- wait for other unques to finish or if DEF_STR_DIALOG_NAME_ALL() take over unqueue
		SleepUntil([| dialog_background_queue_cnt() <= 0 or  not dialog_background_unqueue_active() or game_tick_get() > l_timeout or (str_name == "def_str_dialog_name_all" and sys_dialog_background_unqueue_get() ~= "def_str_dialog_name_all") ], 1);
		-- set which dialog name to unqueue
		sys_dialog_background_unqueue_set(str_name);
		-- set the success check to none before attempting unqueue
		sys_dialog_background_unqueue_success_set(def_str_dialog_name_none());
		-- wait for the unqueue to cycle
		SleepUntil([| dialog_background_queue_cnt() <= 0 or  not dialog_background_unqueue_active() or game_tick_get() > l_timeout ], 1);
		-- check for success
		b_return = str_name == sys_dialog_background_unqueue_success_get() or dialog_background_queue_cnt() <= 0;
		-- release the unqueue variable if it's still current
		if str_name == sys_dialog_background_unqueue_get() then
			sys_dialog_background_unqueue_set(def_str_dialog_name_none());
		end
	else
		Breakpoint("dialog_background_unqueue_name: INVALID DIALOG NAME");
		Sleep(1);
	end
	return b_return;
end

-- RETURN
-- === dialog_background_unqueue_all: Unque's all BACKGROUND dialogs
--		r_timeout = Time (seconds) it will timeout if it can't properly unqueue the dialog
--	RETURN:		[boolean] TRUE; if it unqueue's all the BACKGROUND dialogs
function dialog_background_unqueue_all( r_timeout:number ):boolean
	sys_dialog_debug("dialog_background_unqueue_all", "");
	-- RETURN
	return dialog_background_unqueue_name("def_str_dialog_name_all", r_timeout);
end

-- === dialog_background_unqueue_active: Checks if a BACKGROUND dialog unqueue is active
--	RETURN:		[boolean] TRUE; BACKGROUND dialog unqueue is active
function dialog_background_unqueue_active():boolean
	return sys_dialog_background_unqueue_get() ~= "def_str_dialog_name_none";
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global str_dialog_background_unqueue_name_769bb0dd:string="def_str_dialog_name_none";
global str_dialog_background_unqueue_success_769bb0dd:string="def_str_dialog_name_none";

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_background_unqueue_set: Sets the name of the BACKGROUND dialog to unqueue
function sys_dialog_background_unqueue_set( str_name:string ):void
	sys_dialog_debug("sys_dialog_background_unqueue_set", "");
	str_dialog_background_unqueue_name_769bb0dd = "def_str_dialog_name_none";
end

-- === sys_dialog_background_unqueue_get: Gets the name of the BACKGROUND dialog being unqueue'd
--	RETURN:		[string] Name of the BACKGROUND dialog being unqueue'd
function sys_dialog_background_unqueue_get():string
	return str_dialog_background_unqueue_name_769bb0dd;
end

-- === sys_dialog_background_unqueue_check: Checks if this is a BACKGROUND dialog that should be unqueue'd
--	RETURN:		[boolean] TRUE; if this dialog should be unqueue'd
function sys_dialog_background_unqueue_check( str_name:string ):boolean
	return sys_dialog_background_unqueue_get() == str_name or sys_dialog_background_unqueue_get() == def_str_dialog_name_all();
end

-- === sys_dialog_background_unqueue_success_set: Sets the name of the BACKGROUND dialog that was unqueue'd
function sys_dialog_background_unqueue_success_set( str_name:string ):void
	sys_dialog_debug("sys_dialog_background_unqueue_success_set", "");
	str_dialog_background_unqueue_success_769bb0dd = str_name;
end

-- === sys_dialog_background_unqueue_success_get: Gets the name of the BACKGROUND dialog that was unqueue'd
--	RETURN:		[string] Name of the BACKGROUND dialog that was unqueue'd
function sys_dialog_background_unqueue_success_get():string
	return str_dialog_background_unqueue_success_769bb0dd;
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: BLURBS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_blurb_defaults: Sets the default dialog blurb values
function sys_dialog_blurb_defaults():void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body, 
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	set_text_color(1, 0.22, 0.77, 0.0);
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.5);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.1);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
end

-- === sys_dialog_blurb: plays the dialog blurb
function sys_dialog_blurb( content:string, r_time:number ):void
	-- display the text!
	set_text_lifespan(seconds_to_frames(r_time));
	show_text(content);
end

-- === sys_dialog_blurb_chief: Blurb
function sys_dialog_blurb_chief( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_chief", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1, 0.2, 1.0, 0.2);
	-- alignments
	set_text_margins(0.05, 0.0, 0.05, 0.175);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- === sys_dialog_blurb_cortana: Blurb
function sys_dialog_blurb_cortana( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_cortana", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1, 0.0, 0.8, 1.0);
	-- alignments
	set_text_margins(0.05, 0.0, 0.05, 0.1);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- === sys_dialog_blurb_didact: Blurb
function sys_dialog_blurb_didact( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_didact", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1, 0.6, 0.0, 0.0);
	-- alignments
	set_text_margins(0.05, 0.0, 0.05, 0.025);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- === sys_dialog_blurb_npc: Blurb
function sys_dialog_blurb_npc( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_npc", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1, 1.0, 1.0, 0.25);
	-- alignments
	set_text_margins(0.05, 0.0, 0.05, 0.025);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- === sys_dialog_blurb_radio: Blurb
function sys_dialog_blurb_radio( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_radio", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1.0, 1.0, 0.5, 0.25);
	-- alignments
	set_text_margins(0.1, 0.1375, 0.1, 0.0);
	-- allign off of top
	set_text_alignment(TEXT_ALIGNMENT.top);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- === sys_dialog_blurb_other: Blurb
function sys_dialog_blurb_other( content:string, r_time:number ):void
	sys_dialog_debug("sys_dialog_blurb_other", "");
	sys_dialog_blurb_defaults();
	-- color, scale, life, font
	set_text_color(1, 1.0, 1.0, 1.0);
	-- alignments
	set_text_margins(0.05, 0.0, 0.05, 0.025);
	-- display the text!
	sys_dialog_blurb(content, r_time);
end

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: DEBUG
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === dialog_debug_set: Enable/disable dialog debugging
--		b_active = Enable/disable dialog debug
function dialog_debug_set( b_active:boolean ):void
	b_dialog_debug_769bb0dd = b_active;
end

-- === dialog_debug_get: Gets enabled/disabled state of dialog debug
--	RETURN:		[boolean] TRUE; dialog debug is active
function dialog_debug_get():boolean
	return b_dialog_debug_769bb0dd;
end

-- === dialog_debug_set: Enable/disable dialog debugging
--		b_active = Enable/disable dialog debug
function dialog_debug_detail_set( b_active:boolean ):void
	b_dialog_debug_details_769bb0dd = b_active;
end

-- === dialog_debug_details_get: Gets enabled/disabled state of dialog debug details
--	RETURN:		[boolean] TRUE; dialog debug details is active
function dialog_debug_details_get():boolean
	return b_dialog_debug_details_769bb0dd;
end
-- SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- VARIABLES ---------------------------------------------------------------------------------------
global b_dialog_debug_769bb0dd:boolean=false;
global b_dialog_debug_details_769bb0dd:boolean=false;

-- FUNCTIONS ---------------------------------------------------------------------------------------
-- === sys_dialog_debug: Displays a dialog debug message
function sys_dialog_debug( s_function:string, s_detail:string ):void
	if dialog_debug_get() and (s_function ~= "" or s_detail ~= "") and (dialog_debug_details_get() or s_detail == "") then
		if s_detail == "" then
			dprint("DIALOG DEBUG >>>>>>>>>>");
		end
		if s_function ~= "" then
			dprint(s_function);
		end
		if s_detail ~= "" then
			dprint(s_detail);
		end
	end
end

function sys_dialog_inspect_r( s_function:string, r_inspect:number ):void
	if dialog_debug_get() then
		dprint("DIALOG INSPECT $>$>$>$>$>");
		if s_function ~= "" then
			dprint(s_function);
		end
		print(r_inspect);
	end
end

function sys_dialog_inspect_s( s_function:string, s_inspect:number ):void
	if dialog_debug_get() then
		dprint("DIALOG INSPECT $>$>$>$>$>");
		if s_function ~= "" then
			dprint(s_function);
		end
		print(s_inspect);
	end
end

function sys_dialog_inspect_l( s_function:string, l_inspect:thread ):void
	if dialog_debug_get() then
		dprint("DIALOG INSPECT $>$>$>$>$>");
		if s_function ~= "" then
			dprint(s_function);
		end
		print(l_inspect);
	end
end

function sys_dialog_inspect_b( s_function:string, b_inspect:boolean ):void
	if dialog_debug_get() then
		dprint("DIALOG INSPECT $>$>$>$>$>");
		if s_function ~= "" then
			dprint(s_function);
		end
		print(b_inspect);
	end
end

function sys_dialog_inspect_str( s_function:string, str_inspect:string ):void
	if dialog_debug_get() then
		dprint("DIALOG INSPECT $>$>$>$>$>");
		if s_function ~= "" then
			dprint(s_function);
		end
		print(str_inspect);
	end
end

--[[
script static void test_dialog_blurbs( real r_time )
local string str_test = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
	sys_dialog_blurb_chief( str_test, r_time );
	sys_dialog_blurb_cortana( str_test, r_time );
	//sys_dialog_blurb_didact( str_test, r_time );
	sys_dialog_blurb_npc( str_test, r_time );
	sys_dialog_blurb_radio( str_test, r_time );
	//sys_dialog_blurb_other( str_test, r_time );
end

]]

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- DIALOG: DEBUG
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
function dormant.f_dialog_global_my_first_domain()
	dprint("f_dialog_global_my_first_domain");
--	local l_dialog_id:thread=def_dialog_id_none();
--	l_dialog_id = dialog_start_foreground("MY_FIRST_DOMAIN", l_dialog_id, true, def_dialog_style_queue(), false, "", 0.25);
--	--dialog_line_cortana(l_dialog_id, 0, true, TAG('sound\dialog\mission\global\m20_domain_00100.sound'), false, nil, 0.0, "", "Cortana : This node is caught in a loop trying to access something it's calling the Domain.", false);
--	--dialog_line_cortana(l_dialog_id, 1, true, TAG('sound\dialog\mission\global\m20_domain_00101.sound'), false, nil, 0.0, "", "Cortana : An offworld data repository of some kind, though I'm only able to extract bits and pieces of the complete exchange.", false);
--	--dialog_line_cortana(l_dialog_id, 2, true, TAG('sound\dialog\mission\global\m20_domain_00102.sound'), false, nil, 0.0, "", "Cortana : I'll log it for investigation later.", false);
--	l_dialog_id = dialog_end(l_dialog_id, true, true, "");
end



-- ==================================================
-- Save file size fixes for Narrative Queue
-- ==================================================

global registeredConversationsData = {};

-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
global debugLinePlayRecord = {};
global debugKeepARecordOfPlayedLines = false;
global debugConvoNilCheckState = {};
global debugConvoNilCheckStates = {
	REGISTERED = "REGISTRED",
	RE_REGISTERED = "RE-REGISTRED",
	COMPLETED = "COMPLETED",
};
-- DEBUG CODE ONLY - v-jamcro

global conversationMetatable = {
	__index = function(t,k)
		local convoEntry = registeredConversationsData[t];
		if (not convoEntry) then
			error("ERROR : attempting to index unregistered conversation", 2);
		end

		if (k == "privateData" and not convoEntry[k]) then
			local convoState:string = (debugConvoNilCheckState[t] or "UNREGISTERED");

			error("ERROR : attempting to get privateData in " .. convoState .. " conversation " .. (t.name or "<NAME WAS NIL>") .. " (nil)", 2);
		end

		return convoEntry[k];
	end,

	__newindex = function(t,k,v)
		local convoEntry = registeredConversationsData[t];
		if (not convoEntry) then
			error("ERROR : attempting to index unregistered conversation", 2);
		end

		if (k == "privateData" or k == "localVariables") then
			if (k == "privateData" and convoEntry[k]) then
				error("ERROR : attempting to set privateData on conversation " .. (t.name or "<NAME WAS NIL>") .. " when it already exists!", 2);
			end

			convoEntry[k] = v;
		else
			rawset(t,k,v);
		end
	end,
};

global conversationLineMetatable = {
	__index = function(t,k)
		if (k == "privateData") then
			return registeredConversationsData[t];
		elseif (k == "moniker") then	-- Hack for at-runtime assigned monikers
			return (registeredConversationsData[t] and registeredConversationsData[t].moniker);
		else
			return nil;
		end
	end,

	__newindex = function(t,k,v)
		if (k == "privateData") then
			if (registeredConversationsData[t]) then
				--if (nil == v) then
				--	print("WARNING : privateData for line " .. registeredConversationsData[t].lineNumber .. " in conversation " .. t.name .. " is being erased!");
				--else
					error("ERROR : attempting to set privateData on line " .. (registeredConversationsData[t].lineNumber or "<LINE NUMBER WAS NIL>") .. " in conversation " .. (t.name or "<NAME WAS NIL>") .. " when it already exists!", 2);
				--end
			end

			registeredConversationsData[t] = v;

			-- DEBUG CODE ONLY - v-jamcro
			-- NOT_QUITE_RELEASE
			if (debugKeepARecordOfPlayedLines) then
				debugLinePlayRecord[t] = debugLinePlayRecord[t] or {};
			end
			-- DEBUG CODE ONLY - v-jamcro
		elseif (k == "moniker") then	-- Hack for at-runtime assigned monikers
			t.privateData.moniker = v;
		else
			rawset(t,k,v);
		end
	end,
};

-- Returns TRUE if table is Convo AND Convo is constant ; Returns FALSE if not Convo, or Convo should be saved
function InitializeTableAsConstantConvo(candidate:table, procedural:boolean):boolean
	local candidateName = rawget(candidate, "name");
	local candidateLines = rawget(candidate, "lines");

	if (candidateName and rawget(candidate, "Priority") and candidateLines) then
		local previouslyRegistered:boolean = (registeredConversationsData[candidate] and true) or false;
		
		-- Check if not procedural and already there (error)
		if (registeredConversationsData[candidateName] == true) then
			error("ERROR : multiple conversations with identical name: " .. candidateName, 1);
		end

		-- Register candiate.name in same bank, as = true if not procedural
		registeredConversationsData[candidateName] = not procedural or nil;

		if (not previouslyRegistered) then
			-- Register candidate in global bank of convos (by ref)
			registeredConversationsData[candidate] = {};

			-- Transplant localVariables
			registeredConversationsData[candidate].localVariables = candidate.localVariables;
			candidate.localVariables = nil;
			candidate.privateData = nil;

			-- Assign metatable to reference transplanted localVariables
			setmetatable(candidate, conversationMetatable);
			debugConvoNilCheckState[candidate] = debugConvoNilCheckStates.REGISTERED;
		end

		-- Do the same for all lines in candidate
		for lineNumber = 1, #candidateLines do
			local line = candidateLines[lineNumber];
			
			line.privateData = nil;
			setmetatable(line, conversationLineMetatable);
		end

		return not (candidate.saveMe or candidate.procedural);
	elseif (candidate._ForceMarkTablePermanent) then
		return true;
	else
		return false;
	end
end

function LateRegisterTableAsConvo(candidate:table):void
	if (not registeredConversationsData[candidate]) then
		InitializeTableAsConstantConvo(candidate, true);
	else
		-- Register candiate.name in same bank, as = true if not procedural
		local candidateName = rawget(candidate, "name");
		registeredConversationsData[candidateName] = nil;

		-- Re-register all lines (lines table could have been altered by user)
		local candidateLines = candidate.lines;
		for lineNumber = 1, #candidateLines do
			local line = candidateLines[lineNumber];

			registeredConversationsData[line] = nil;
			setmetatable(line, conversationLineMetatable);
			debugConvoNilCheckState[candidate] = debugConvoNilCheckStates.RE_REGISTERED;
		end
	end
end

function UnregisterConvo(conversation:table):void
	if (registeredConversationsData[conversation]) then
		for lineNumber = 1, #conversation.lines do
			local line = conversation.lines[lineNumber];
			registeredConversationsData[line] = nil;
		end

		registeredConversationsData[conversation].privateData = nil;
		debugConvoNilCheckState[conversation] = debugConvoNilCheckStates.COMPLETED;
	end
end

function MarkConvoAsCompleted(conversation:table):void
	registeredConversationsData[conversation.name] = {
		completed = conversation.privateData.completed,
		interrupted = conversation.privateData.interrupted,
	};

	UnregisterConvo(conversation);
end

function ConvoHasCompleted(conversation:table):boolean
	return (conversation and type(registeredConversationsData[conversation.name]) == "table" and registeredConversationsData[conversation.name].completed);
end

function ConvoHasPrivateData(conversation:table):boolean
	return (conversation and registeredConversationsData[conversation] and registeredConversationsData[conversation].privateData and true) or false;
end

-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
function DebugPrintConversationPlayRecord(conversation:table):void
	print(conversation.name .. " played - ");
		
	for i = 1, #conversation.lines do
		local str = "[" .. i .. "] : ";

		for _, time in pairs(debugLinePlayRecord[conversation.lines[i]]) do
			str = str .. time .. ", ";
		end

		print(str);
	end
end
-- DEBUG CODE ONLY - v-jamcro


-- ==================================================
-- Character Objects
-- ==================================================

-- Must be evaluated at runtime, not at startup, or they will be 'nil'.
global CHARACTER_SPARTANS = {
	-- BLUE TEAM
	chief = function() return SPARTANS.chief, "Chief"; end,
	fred = function() return SPARTANS.fred, "Fred"; end,
	kelly = function() return SPARTANS.kelly, "Kelly"; end,
	linda = function() return SPARTANS.linda, "Linda"; end,
	-- OSIRIS
	locke = function() return SPARTANS.locke, "Locke"; end,
	buck = function() return SPARTANS.buck, "Buck"; end,
	tanaka = function() return SPARTANS.tanaka, "Tanaka"; end,
	vale = function() return SPARTANS.vale, "Vale"; end,

	-- Mark as 'permanent' to avoid being saved
	-- -- -- -- -- -- --
	_ForceMarkTablePermanent = true;
	-- -- -- -- -- -- --
};

setmetatable(CHARACTER_SPARTANS, { __index = function(t,n) error("Invalid: BLUE_TEAM." .. n); end } );

-- Must be evaluated at runtime, not at startup, or they will be 'nil'.  Too many to define non-procedurally.
global CHARACTER_OBJECTS = {};

setmetatable(CHARACTER_OBJECTS, { 
	__index = function(t,n)
		t[n] = function()
			if (not OBJECTS.HasName(n)) then
				error("Invalid: OBJECTS." .. n);
			else
				return OBJECTS[n];
			end
		end

		return t[n];
	end,
});

-- This table is only meant to be used during declarations (BEFORE startup), so we clear it afterward
-- Bonus side effects: Save active memory (duplicated definitions of functions) and save-game size
function startup.CHARACTER_OBJECTS_CLEAR()
	-- This will now CRASH when we attempt to access it at runtime
	CHARACTER_OBJECTS = nil;
end

global CHARACTER_MonikerMappings = {};

CHARACTER_MonikerMappings[CHARACTER_SPARTANS.locke] = "Locke";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.buck] = "Buck";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.tanaka] = "Tanaka";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.vale] = "Vale";

CHARACTER_MonikerMappings[CHARACTER_SPARTANS.chief] = "Chief";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.fred] = "Fred";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.linda] = "Linda";
CHARACTER_MonikerMappings[CHARACTER_SPARTANS.kelly] = "Kelly";


function CHARACTER_GetMoniker(characterFunction)
	local moniker = nil;

	if (characterFunction and type(characterFunction) == "function") then
		local characterObj,characterStr = characterFunction();

		moniker = characterStr or CHARACTER_MonikerMappings[characterFunction] or nil;
	end

	return moniker;
end



-- ==================================================
-- Extended Table Functionality
-- ==================================================

global NAR_CONVO_FUNCTIONS = {
	PriorityCriticalPath = function (thisConvo, queue)
		return CONVO_PRIORITY.CriticalPath;
	end,

	PriorityMainCharacter = function (thisConvo, queue)
		return CONVO_PRIORITY.MainCharacter;
	end,

	PriorityNpc = function (thisConvo, queue)
		return CONVO_PRIORITY.NPC;
	end,
};

global NAR_LINE_FUNCTIONS = {
	NextLine = function (thisLine, thisConvo, queue, lineNumber, characterWasDead)
		return (lineNumber + 1);
	end,

	EndConvo = function (thisLine, thisConvo, queue, lineNumber, characterWasDead)
		return 0;
	end,

	EndOnDeathElseNextLine = function (thisLine, thisConvo, queue, lineNumber, characterWasDead)
		return (characterWasDead and 0) or (lineNumber + 1);
	end,
};



-- ==================================================
-- Extended Table Functionality
-- ==================================================

global MathematicalSet:table = {
	hasPermanentFunctions = true,
	metatable = {},
};

function MathematicalSet.IndexedTableToSet(indexedTable):table	-- Returns a MathematicalSet containing an entry for each value in the provided table
	local newSet:table = {};
	setmetatable(newSet, MathematicalSet.metatable);
	
	for key, value in pairs(indexedTable) do
		--print("added entry to set");
		newSet[value] = true;
	end
	
	return newSet;
end

function MathematicalSet.Create():table	-- Returns an empty MathematicalSet
	return MathematicalSet.IndexedTableToSet({});
end

function MathematicalSet.SetToTableWithUniqueEntries(set):table	-- Returns indexed table with unique entries from MathematicalSet
	local uniqueTable:table = {};
	
	for key, value in pairs(set) do
		table.insert(uniqueTable, key);
	end
	
	return uniqueTable;
end

function MathematicalSet.AddValueToSet(set, value):void
	set[value] = true;
end

function MathematicalSet.GetIntersection(lhSet, rhSet):table	-- Returns a MatehmaticalSet containing the intersection of elements between l and r (empty set if no overlap)
	local intersection:table = MathematicalSet.Create();
	
	for key, value in pairs(lhSet) do
		intersection[key] = rhSet[key];
	end
	
	return intersection;
end
	
function MathematicalSet.GetUnion(lhSet, rhSet):table	-- Returns a MatehmaticalSet containing the union of elements between l and r
	local union:table = MathematicalSet.Create();
	
	for key, value in pairs(lhSet) do
		union[key] = true;
	end
	
	for key, value in pairs(rhSet) do
		union[key] = true;
	end
	
	return union;
end

MathematicalSet.metatable.__mul = MathematicalSet.GetIntersection;
MathematicalSet.metatable.__add = MathematicalSet.GetUnion;



-- ==================================================
-- Extended Table Functionality
-- ==================================================

global ExtendedTable:table = {
	hasPermanentFunctions = true,
};

function ExtendedTable.TableToString(checkTable):string	-- Returns string representation of a table (recursive)
	local str:string = "{ ";

	for key, value in pairs(checkTable) do
		str = str .. "[";
		str = str .. ExtendedTable.ObjectToString(key);
		str = str .. "] = ";
		str = str .. ExtendedTable.ObjectToString(value);
		str = str .. ", ";
	end

	str = str .. " }";

	return str;
end

function ExtendedTable.ObjectToString(checkObject):string	-- Returns string representation of an object (recursive for tables)
	local str:string = "";	
	local typeString:string = type(checkObject);

	if (checkObject == nil) then
		str = "<nil>";
	elseif (typeString == "table") then
		str = ExtendedTable.TableToString(checkObject);
	elseif (typeString == "boolean") then
		str = (checkObject and "TRUE") or "FALSE";
	elseif (typeString == "number") then
		str = str .. checkObject;
	elseif (typeString == "string") then
		str = checkObject;
	elseif (typeString == "function") then
		str = "<function>";
	else
		str = "<Unknown Object>";
	end

	return str;
end

function ExtendedTable.GetTableSize(checkTable):number	-- Returns the number of elements in a table
	local count:number = table.maxn(checkTable);

	if (count == 0) then
		for key, value in pairs(checkTable) do
			count = count + 1;
		end
	end

	return count;
end

function ExtendedTable.TableIsEmpty(checkTable):boolean
	return (next(checkTable) == nil);
end



-- ==================================================
-- AI Dialog Suppression Management
-- ==================================================

global AIDialogManager:table = {
	hasPermanentFunctions = true,
	disableAIDialogCount = 0,
	disableAISpecifically = nil,	-- Due to engine-side limitations, we can only have a single SPECIFIC ai disabled at a time

	-- Debug
	showPrintMessages = false,
};

function AIDialogManager.DisableAIDialog(targetAi):void
	if (targetAi) then		
		if (not AIDialogManager.disableAISpecifically) then
			AIDialogManager.disableAISpecifically = targetAi;
			ai_actor_dialogue_enable(targetAi, false);
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog Disabled for actor ", targetAi); end
		elseif (AIDialogManager.disableAISpecifically ~= targetAi) then
			-- Re-enable the previously-disabled actor
			ai_actor_dialogue_enable(AIDialogManager.disableAISpecifically, true);
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog automatically Re-Enabled for actor ", targetAi); end

			-- Then disable the specified actor
			AIDialogManager.disableAISpecifically = targetAi;
			ai_actor_dialogue_enable(targetAi, false);
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog Disabled for actor ", targetAi); end
		else
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog was already previously Disabled for actor ", targetAi, ".  Ignoring."); end
		end
	else
		if (AIDialogManager.disableAIDialogCount <= 0) then
			AIDialogManager.disableAIDialogCount = 1;
			ai_dialogue_enable(false);
		else
			AIDialogManager.disableAIDialogCount = AIDialogManager.disableAIDialogCount + 1;
		end

		if (AIDialogManager.showPrintMessages) then print("AI Dialog Disabled (Current disabled level: " .. AIDialogManager.disableAIDialogCount .. ")"); end
	end
end

function AIDialogManager.EnableAIDialog(targetAi):void
	if (targetAi) then
		if (AIDialogManager.disableAISpecifically == targetAi) then
			AIDialogManager.disableAISpecifically = nil;
			ai_actor_dialogue_enable(targetAi, true);
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog Enabled for actor ", targetAi); end
		else
			if (AIDialogManager.showPrintMessages) then print("AI Actor Dialog was already previously Enabled for actor ", targetAi, ".  Ignoring."); end
		end
	else
		AIDialogManager.disableAIDialogCount = AIDialogManager.disableAIDialogCount - 1;
	
		if (AIDialogManager.disableAIDialogCount <= 0) then
			AIDialogManager.disableAIDialogCount = 0;
			ai_dialogue_enable(true);
		end

		if (AIDialogManager.showPrintMessages) then print("AI Dialog Enabled (Current disabled level: " .. AIDialogManager.disableAIDialogCount .. ")"); end
	end
end

function AIDialogManager.ForceEnableAIDialog(targetAi):void
	if (targetAi) then
		if (AIDialogManager.showPrintMessages) then print("AIDialogManager.ForceEnableAIDialog(", targetAi, ")"); end

		AIDialogManager.disableAISpecifically[targetAi] = 0;
		ai_actor_dialogue_enable(targetAi, true);
	else
		if (AIDialogManager.showPrintMessages) then print("AIDialogManager.ForceEnableAIDialog()"); end
	
		AIDialogManager.disableAIDialogCount = 0;
		ai_dialogue_enable(true);
	end
end



-- ==================================================
-- Narrative Queue Enumerations
-- ==================================================

global CONVO_PRIORITY:table = {
	NPC				= 1,
	MainCharacter	= 2,
	CriticalPath	= 3,
	--------------------
	_count			= 3,	-- Remember, Lua is not 0-index
};

global CONVO_RESUME:table = {
	ListenerAsk		= 1,
	SpeakerResume	= 2,
	Automatic		= 3,
	--------------------
	_count			= 3,	-- Remember, Lua is not 0-index
};

global CONVO_STATUS:table = {
	pending = 1,
	playing = 2,
	delayed = 3,
	dead	= 4,
	------------
	_count	= 4,			-- Remember, Lua is not 0-index
};



-- ==================================================
-- Narrative Queue Default Methods
-- ==================================================

global NarrativeQueueDefaults = {};

function NarrativeQueueDefaults.CheckFrequency()
	return 10;
end



-- ==================================================
-- Narrative Queue Private Functionality
-- ==================================================

global NarrativeQueueInstance:table = {
	hasPermanentFunctions = true,
	-- Data
	isActive = false,
	allowResume = false,
	updateFrequency = 1,
	interruptOverlapDuration = 0.75,

	-- Static Values
	NoCharacterValue = -1,
	
	-- Queues
	pendingConversations = {},
	delayedConversations = {},
	playingConversations = {},
	interruptedLines = {},

	conversationParticipantsThisFrame = {},
	
	-- Threading
	threadLocked = false,
	threadPaused = 0,
	pauseUpdateFrequency = 1,
	timeSpentPaused = 0,
	updateIsRunning = false,
	currentRunningId = -1,
	
	-- Debug
	showBlurbs = false,
	showPrintMessages = false,
	callbacksInSeparateThreads = true,
};

-- Methods
function NarrativeQueueInstance:Initialize():void
	if (not self.isActive) then
		self:Kill();

		self.isActive = true;
		
		self.pendingConversations = {};
		self.delayedConversations = {};
		self.playingConversations = {};
	else
		error("ERROR : NarrativeQueueInstance was already initialized and is running.");
	end
end

function NarrativeQueueInstance:IsThreadLocked():boolean	-- Returns TRUE if thread is locked, FALSE if unlocked
	return self.threadLocked;
end

function NarrativeQueueInstance:IsThreadPaused():boolean	-- Returns TRUE if thread is paused, FALSE if unpaused
	if (self.threadPaused > 0) then
		self.timeSpentPaused = self.timeSpentPaused + self.pauseUpdateFrequency;
	end
	
	return self.threadPaused > 0;
end

function NarrativeQueueInstance:Push(conversation, queue):boolean	-- Returns TRUE if Push succeeded, FALSE if failed
	local result:boolean = false;

	if (conversation and queue) then
		if (ConvoHasPrivateData(conversation)) then
			conversation.privateData.DEBUG_CONVO_QUEUED = true;
		end

		result = true;

		for key, convo in pairs(queue) do
			if (convo == conversation) then
				result = false;
				break;
			end
		end

		if (result) then
			table.insert(queue, conversation);
		end
	end

	return result;
end

function NarrativeQueueInstance:Pop(conversation, queue):table	-- Returns conversation reference if popped, nil if not found
	local foundConvoIndex:number = 0;
	local foundConvo:table = {};

	if (conversation and queue) then
		if (ConvoHasPrivateData(conversation)) then
			conversation.privateData.DEBUG_CONVO_QUEUED = false;
		end

		for key, convo in pairs(queue) do
			if (convo == conversation) then
				foundConvoIndex = key;
				break;
			end
		end

		if (foundConvoIndex > 0) then
			table.remove(queue, foundConvoIndex);
			foundConvo = conversation;
		end
	end

	return foundConvo;
end

function NarrativeQueueInstance:CharacterIsDead(line, conversation):boolean	-- Returns TRUE if dead, FALSE if not	
	local isDead:boolean = false;
	
	-- If no character object was supplied, then character is not "dead".  Otherwise...
	if (line.character) then
		local characterObject, checkCharacter = self:EvaluateCharacterExtended(line, conversation);
		
		-- If the convo designer did not conditionally specify "no character"...
		if (checkCharacter ~= self.NoCharacterValue) then
			local objType,objSubType = GetEngineType(characterObject, true);

			-- If the character was a function that returned nil, or the object is <invalid> (has no sub type), or the biped is dead, or the vehicle is destroyed, CHARACTER IS DEAD
			isDead = (not characterObject) or (not objSubType) or (objSubType == "biped" and not biped_is_alive(characterObject) and not IsUnitDowned(characterObject)) or (objSubType == "vehicle" and (object_get_health(characterObject) <= 0));
		end
	end

	return isDead;
end

function NarrativeQueueInstance:CharacterIsDeadOrDowned(character):boolean	-- Returns TRUE if dead, FALSE if not
	local isDeadOrDowned:boolean = false;

	if (character) then
		local objType,objSubType = GetEngineType(character, true);
		isDeadOrDowned = (objSubType == "biped" or objSubType == "vehicle") and (object_get_health(character) <= 0 or IsUnitDowned(character));	-- If the character object is nil, we play the sound, otherwise we play only if the object is not dead
	end

	return isDeadOrDowned;
end

function NarrativeQueueInstance:CharacterCanSpeak(line, conversation):boolean -- Returns TRUE if dead, FALSE if line can play (character might still be dead)
	local isDead:boolean = false;
	
	-- This is a fix to prevent/reduce loss of critical path lines due to characters dying or being dead during the conversation
	if (conversation.privateData.priority == CONVO_PRIORITY.CriticalPath and not line.forcePlayIn3D) then
		-- If the game is single-player, always play non-player crit-path lines in 2D on nil objects
		if (not GameIsDistributed()) then
			-- The player always plays lines on their object.  If they're dead, we'll reload anyway...
			if (line.moniker == "Locke" or line.moniker == "Chief") then
				isDead = self:CharacterIsDead(line, conversation);
			-- Always play non-player lines on nil objects and in 2D
			else
				line.playLineOnNilCharacter = true;
			end
		-- Otherwise, in co-op, always play lines on character objects if the objects are alive, or play on nil objects if dead (prevents "was dead when line started" line loss, does NOT prevent "died while speaking line" line loss)
		else
			line.playLineOnNilCharacter = self:CharacterIsDead(line, conversation);
		end
	else
		isDead = self:CharacterIsDead(line, conversation);
	end
	
	return isDead;
end

function NarrativeQueueInstance:GetNextLine(conversation, line, failed, characterWasDead):number	-- Returns index of next line object in conversation
	--return (failed and line.AfterFailed and line.AfterFailed(line, conversation, self, line.privateData.lineNumber, characterWasDead)) or
	--	   (not failed and line.AfterPlayed and line.AfterPlayed(line, conversation, self, line.privateData.lineNumber)) or
	--	   line.privateData.lineNumber + 1;

	local nextLine:number = 0;
	local lineNumber:number = line.privateData.lineNumber;

	if (line.privateData.started and line.OnFinish) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(line.OnFinish, line, conversation, self, line.privateData.lineNumber);
		else
			line.OnFinish(line, conversation, self, line.privateData.lineNumber);
		end
	end

	local failedLine = (failed and line.AfterFailed and line.AfterFailed(line, conversation, self, lineNumber, characterWasDead));
	local playedLine = (not failed and line.AfterPlayed and line.AfterPlayed(line, conversation, self, lineNumber));

	nextLine = failedLine or playedLine or (lineNumber + 1);

	return nextLine;
end

function NarrativeQueueInstance:EvaluateConversationSleep(sleepVariable, conversation)
	local sleepValue = 0;

	if (type(sleepVariable) == "number") then
		sleepValue = sleepVariable;
	elseif(type(sleepVariable) == "function") then
		sleepValue = sleepVariable(conversation, self);
	end

	return sleepValue;
end

function NarrativeQueueInstance:EvaluateLineSleep(sleepVariable, line, conversation, lineNumber)
	local sleepValue = 0;

	if (type(sleepVariable) == "number") then
		sleepValue = sleepVariable;
	elseif (type(sleepVariable) == "function") then
		sleepValue = sleepVariable(line, conversation, self, lineNumber);
	end

	return sleepValue;
end

function NarrativeQueueInstance:InitializeLine(line, conversation, lineNumber):void
	if (self.showPrintMessages) then print("NarrativeQueueInstance.InitializeLine( " .. lineNumber .. " )"); end

	local lineDuration:number = sound_max_time(line.tag);

	--line.sleepBefore = self:EvaluateLineSleep(line.sleepBefore, line, conversation, lineNumber);
	--line.sleepAfter = self:EvaluateLineSleep(line.sleepAfter, line, conversation, lineNumber);
	
	line.privateData = {
		lineNumber = lineNumber,
		startTime = -1,
		unmodifiedDurationTicks = lineDuration,
		durationTicks = lineDuration * (line.playDurationAdjustment or 1),
		characterPlayed = nil,
		started = false,
		playing = false,
		played = false,
		stopped = false,
		--preDelayDurationTicks = seconds_to_frames(line.sleepBefore),
		--postDelayDurationTicks = seconds_to_frames(line.sleepAfter),		
		--preDelayCompleted = line.sleepBefore == 0,
		--postDelayCompleted = line.sleepAfter == 0,
		playTickOffset = 999,
		previousLine = nil,
	};

	-- Auto-generate the undefined moniker of all Critical Path convos based on the supplied character function
	if (not line.moniker) then
		line.moniker = CHARACTER_GetMoniker(line.character);
	end

	line.privateData.durationTicks = (line.privateData.durationTicks > 0 and line.privateData.durationTicks) or 0;
end

function NarrativeQueueInstance:InitializeConversation(conversation):void	-- BONUS TODO
	if (self.showPrintMessages) then print("NarrativeQueueInstance.InitializeConversation( " .. conversation.name .. " )"); end
	
	--conversation.sleepBefore = self:EvaluateConversationSleep(conversation.sleepBefore, conversation);
	--conversation.sleepAfter = self:EvaluateConversationSleep(conversation.sleepAfter, conversation);
		
	conversation.privateData = {
		timeSinceLastCheck = 0,
		timePending = 0,
		timeElapsed = 0,
		currentLine = (self.lines and self.lines[1]) or nil,

		priority = conversation.Priority(conversation, self),

		--participants = {},
		
-- BONUS TODO : enable pre-evaluation of line paths
--[[
		determinedLines = {},
--]]

		interruptOnPlay = {},
		interrupted = false,
		completed = false,
		nextLine = 1,

		linesCompletedTime = nil,

		--preDelayDurationTicks = seconds_to_frames(conversation.sleepBefore),
		--postDelayDurationTicks = seconds_to_frames(conversation.sleepAfter),		
		preDelayCompleted = false,
		postDelayCompleted = false,

		-- DEBUG
		DEBUG_CONVO_QUEUED = true,
	};

	-- Initilaize all lines in conversation
	if (conversation.lines) then
		for lineNumber, line in pairs(conversation.lines) do
			self:InitializeLine(line, conversation, lineNumber);
		end
	end

	if (not conversation.CheckFrequency) then
		conversation.CheckFrequency = NarrativeQueueDefaults.CheckFrequency;
	end
end

function NarrativeQueueInstance:StartConversation(conversation):void
	--self:InitializeConversation(conversation);
	self:Push(self:Pop(conversation, self.pendingConversations), self.playingConversations);

	if (conversation.PlayOnSpecificPlayer) then
		conversation.privateData.targetPlayer = conversation.PlayOnSpecificPlayer(conversation, self);
	end

	local priority = conversation.privateData.priority;

	if (conversation.disableAIDialog ~= false and (conversation.disableAIDialog or priority == CONVO_PRIORITY.CriticalPath or priority == CONVO_PRIORITY.MainCharacter)) then
		conversation.privateData.disabledAIDialog = true;
		AIDialogManager.DisableAIDialog();
	end

	-- If we end up needing one, put the OnInitialize() call here:
	if (conversation.OnInitialize) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(conversation.OnInitialize, conversation, self);
		else
			conversation.OnInitialize(conversation, self);
		end
	end

	-- Determine the sleeps for the convo at convo start
	conversation.privateData.preDelayDurationTicks = seconds_to_frames(self:EvaluateConversationSleep(conversation.sleepBefore, conversation));
	conversation.privateData.postDelayDurationTicks = seconds_to_frames(self:EvaluateConversationSleep(conversation.sleepAfter, conversation));
end

function NarrativeQueueInstance:StartLine(conversation, lineNumber):void
	if (self.showPrintMessages) then print("_>_>_> Convo: ", conversation.name, " line: ", lineNumber); end

	if (self.showPrintMessages) then print("NarrativeQueueInstance.StartLine()"); end

	if (not conversation) then error("ERROR : NarrativeQueueInstance:StartLine() had 'nil' for conversation"); end
	if (not conversation.lines) then error("ERROR : NarrativeQueueInstance:StartLine() - conversation '", conversation.name,"' has no lines table"); end
	if (not conversation.lines[lineNumber]) then error("ERROR : NarrativeQueueInstance:StartLine() - conversation '", conversation.name,"'s lines table does not contain line [", lineNumber,"]"); end

	local line:table = conversation.lines[lineNumber];	
	if (self.showPrintMessages) then print("NarrativeQueueInstance.StartLine() - Duration: " .. line.privateData.durationTicks); end
	
	line.privateData.startTime = conversation.privateData.timeElapsed;
	line.privateData.started = true;
	line.privateData.previousLine = conversation.privateData.currentLine;	
	conversation.privateData.currentLine = line;
	
	if (line.OnStart) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(line.OnStart, line, conversation, self, lineNumber);
		else
			line.OnStart(line, conversation, self, lineNumber);
		end
	end

	-- Determine the sleeps for the line at line start
	line.privateData.preDelayDurationTicks = seconds_to_frames(self:EvaluateLineSleep(line.sleepBefore, line, conversation, lineNumber));
	line.privateData.preDelayCompleted = line.sleepBefore == 0;
	
	line.privateData.postDelayDurationTicks = seconds_to_frames(self:EvaluateLineSleep(line.sleepAfter, line, conversation, lineNumber));
	line.privateData.postDelayCompleted = line.sleepAfter == 0;
end

function NarrativeQueueInstance:CreateBlurb(text, durationTicks, priority):void
	-- Fonts:
	-- Assign the font to use. Valid options are: terminal, body, title, super_large,
	-- large_body, split_screen_hud, full_screen_hud, English_body, 
	-- hud_number, subtitle, main_menu. Default is “subtitle”
	set_text_defaults();
	-- color, scale, life, font
	if (priority == CONVO_PRIORITY.NPC) then
		set_text_color(1, 0.77, 0.77, 0.0);
		
		set_text_font(FONT_ID.terminal);
		set_text_scale(1.0);
	else
		if (priority == CONVO_PRIORITY.CriticalPath) then
			set_text_color(1, 0.22, 0.77, 0.0);
		else
			set_text_color(1, 0.0, 0.33, 0.77);
		end
		
		set_text_font(FONT_ID.terminal);
		set_text_scale(1.5);
	end
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.1);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
	-- display the text!
	set_text_lifespan(durationTicks);
	show_text(text);
end

function NarrativeQueueInstance:ShowBlurb(conversation, line):void
	-- display story blurb if necessary
	if (self.showBlurbs) then
		NarrativeQueueInstance:CreateBlurb(line.text, line.privateData.durationTicks, conversation.privateData.priority);
	end
end

function NarrativeQueueInstance:EvaluateCharacterExtended(line, conversation)
	local checkCharacter = line.character;
	local characterObject:object = nil;

	if (checkCharacter) then
		if (type(checkCharacter) == "function") then
			checkCharacter = checkCharacter(line, conversation, self, line.privateData.lineNumber);
		end
		
		characterObject = checkCharacter;

		if (checkCharacter and GetEngineType(checkCharacter) == "ai") then
			if (self.showPrintMessages) then print("Character was 'AI'"); end
			characterObject = ai_get_object(checkCharacter);
		end
	end

	if (type(characterObject) == "number") then
		print("ERROR :: !! :: Character for conversation '", conversation.name, "', line [", line.privateData.lineNumber, "] was a NUMBER");
		checkCharacter = self.NoCharacterValue;
	end

	--print("EvaluateCharacterExtended() = ", characterObject);
	--
	--if (characterObject and GetEngineType(characterObject) ~= "object") then
	--	print("ERROR : characterObject (", characterObject, ") was not type:object (", GetEngineType(characterObject), ")");
	--	error("ERROR : characterObject (", characterObject, ") was not type:object (", GetEngineType(characterObject), ")");
	--end

	if (checkCharacter == self.NoCharacterValue) then
		characterObject = nil;
	end

	if (self.showPrintMessages) then print("EvaluateCharacterExtended() = ", characterObject); end
	return characterObject, checkCharacter;
end
-- TODO : Forward update all instances of this function
function NarrativeQueueInstance:EvaluateCharacter(line, conversation):object
	local characterObject, checkCharacter = self:EvaluateCharacterExtended(line, conversation);

	return characterObject;
end

function NarrativeQueueInstance:PlayLine(conversation):void
	local line:table = conversation.privateData.currentLine;
	
	line.privateData.playing = true;

	if (not line.tag) then
		conversation.privateData.currentVO = nil;
		conversation.privateData.nextLine = self:GetNextLine(conversation, line, true, false);
		--error("Line " .. line.privateData.lineNumber .. " of conversation " .. conversation.name .. " missing TAG ID");
		print(":! :! | WARNING | !: !: Line ", line.privateData.lineNumber, " of conversation ", conversation.name, " missing TAG ID !");
	else
		-- Capture the actual object we are playing this sound on
		line.privateData.characterPlayed = ((not line.privateData.playLineOnNilCharacter or line.forcePlayIn3D) and self:EvaluateCharacter(line, conversation)) or nil;

		if (line.marker) then
			--if (self.showPrintMessages) then print("PlayDialogFromMarkerOnSpecificClients( tag: " .. line.tag .. ", character: " .. ExtendedTable.ObjectToString(self:EvaluateCharacter(line, conversation)) .. ", player: ", conversation.privateData.targetPlayer, ", marker: ", line.marker); end
			PlayDialogFromMarkerOnSpecificClients(line.tag, line.privateData.characterPlayed, conversation.privateData.targetPlayer, line.marker);
		else
			--if (self.showPrintMessages) then print("PlayDialogOnSpecificClients( tag: " .. line.tag .. ", character: " .. ExtendedTable.ObjectToString(self:EvaluateCharacter(line, conversation)) .. ", player: ", conversation.privateData.targetPlayer); end
			PlayDialogOnSpecificClients(line.tag, line.privateData.characterPlayed, conversation.privateData.targetPlayer);
		end

		-- If we didn't have an object to play the sound on (play on the air), we'll just use the conversation as the index for delayed interruptions
		line.privateData.characterPlayed = line.privateData.characterPlayed or line.moniker or conversation;
		self.interruptedLines[line.privateData.characterPlayed] = nil;
	end

	self:ShowBlurb(conversation, line);
		
	if (line.OnPlay) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(line.OnPlay, line, conversation, self, line.privateData.lineNumber);
		else
			line.OnPlay(line, conversation, self, line.privateData.lineNumber);
		end
	end
end

function NarrativeQueueInstance:SilenceTag(tagToSilence, objectPlayingTag, targetPlayer):void
	if (tagToSilence) then
		StopDialogOnSpecificClients(tagToSilence, objectPlayingTag, targetPlayer);
	end
end

function NarrativeQueueInstance:SilenceInterruptedLine(interruptedLineDataIndex):void
	local interruptedLineData = self.interruptedLines[interruptedLineDataIndex];

	if (interruptedLineData) then
		self:SilenceTag(interruptedLineData.tag, interruptedLineData.character, interruptedLineData.targetPlayer);
		self.interruptedLines[interruptedLineDataIndex] = nil;
	end
end

function NarrativeQueueInstance:SilenceAllInterruptedLines(linesList):void
	for key, _ in pairs(linesList) do
		self:SilenceInterruptedLine(key);
	end
end

function NarrativeQueueInstance:HaltLine(conversation, interruptOverlapDuration):void
	local line:table = conversation.privateData.currentLine;
	
	if (line and line.privateData) then
		if (line.privateData.playing and not line.privateData.played) then
			local actualObject = (line.privateData.characterPlayed ~= conversation and line.privateData.characterPlayed ~= line.moniker and line.privateData.characterPlayed) or nil;

			if (interruptOverlapDuration) then
				-- Mark the tag for later silencing
				self.interruptedLines[line.privateData.characterPlayed] = {
					tag = line.tag,
					character = actualObject,
					targetPlayer = conversation.privateData.targetPlayer,
					duration = seconds_to_frames(interruptOverlapDuration),
				};
			else
			--	StopDialogOnSpecificClients(line.tag, self:EvaluateCharacter(line, conversation), conversation.privateData.targetPlayer);
				self:SilenceTag(line.tag, actualObject, conversation.privateData.targetPlayer);
			end
		end
	
		line.privateData.stopped = true;
	end
end

function NarrativeQueueInstance:FinishConversation(conversation):void
	if (self.showPrintMessages) then print("Finish Conversation: " .. conversation.name); end

	if (conversation.OnFinish) then
		if (self.callbacksInSeparateThreads) then
			CreateThread(conversation.OnFinish, conversation, self);
		else
			conversation.OnFinish(conversation, self);
		end
	end

	if (conversation.privateData.disabledAIDialog) then
		conversation.privateData.disabledAIDialog = nil;
		AIDialogManager.EnableAIDialog();
	end
	
	conversation.privateData.completed = true;
	MarkConvoAsCompleted(conversation);
	
	self:Pop(conversation, self.playingConversations);
end

function NarrativeQueueInstance:StopAllConversations(stopQueue):void
	local queue = stopQueue or self.playingConversations;

	for key, convo in pairs(queue) do
		if (ConvoHasPrivateData(convo)) then
			convo.privateData.DEBUG_CONVO_QUEUED = false;
		end

		self:HaltLine(convo);
		UnregisterConvo(convo);
	end
end

function NarrativeQueueInstance:Kill():void
	self.isActive = false;
	self.currentRunningId = self.currentRunningId + 1;	-- Invalidate the current running id, in case someone reactivates the queue later this same tick
	
	self:StopAllConversations(self.pendingConversations);
	self.pendingConversations = {};
	
	self:StopAllConversations();
	self.playingConversations = {};

	self:StopAllConversations(self.delayedConversations);
	self.delayedConversations = {};

	local allInterruptedLines = {};
	for key, _ in pairs(self.interruptedLines) do
		allInterruptedLines[key] = true;
	end
	self:SilenceAllInterruptedLines(allInterruptedLines);
end

function NarrativeQueueInstance:StartNextLine(conversation):void
	local checkedLineNumbers:table = {};
	local foundLine:boolean = false;
	local currentLineNumber:number = conversation.privateData.nextLine or 1;
	local previousLine:table = nil;
	conversation.privateData.nextLine = nil;
	
	while (not foundLine and currentLineNumber and currentLineNumber > 0 and currentLineNumber <= #conversation.lines) do
		local line:table = conversation.lines[currentLineNumber];

		-- Guard against infinite looping by simply bad user logic
		if (checkedLineNumbers[currentLineNumber]) then
			local errorprint:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. currentLineNumber .."] has already been checked this tick.  We are looping infinitely!");
			--error("ERROR : Conversation '", conversation.name, "', line [", currentLineNumber, "] has already been checked this tick.  We are looping infinitely!");
			error(errorprint);
		end
		checkedLineNumbers[currentLineNumber] = true;
		
		-- v-jamcro - TODO - DEBUG
		if (not line.privateData) then
			error("privateData for line [" .. currentLineNumber .. "] in convo '" .. conversation.name .. "' was 'nil' (should not happen in the middle of a convo evaluation)");
		end
		-- v-jamcro - TODO - DEBUG

		line.privateData.previousLine = previousLine;

		if (line.privateData.played) then
			-- Guards against infinite looping by complex bad user logic
			if (line.privateData.previousLine) then
				local errorprint2:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. line.privateData.previousLine.privateData.lineNumber .."] started a line that has already been played (line [".. currentLineNumber .."])");
				error(errorprint2);
				print(errorprint2);
				--error("ERROR : Conversation '", conversation.name, "', line [", line.privateData.previousLine.privateData.lineNumber, "] started a line that has already been played (line [", currentLineNumber,"])");
			-- To replay a line at the beginning of a convo, the whole convo should be requeued
			else
				local errorprint3:string = ("ERROR : Starting conversation '".. conversation.name .."', line [".. currentLineNumber .."] has already been played");
				--error("ERROR : Starting conversation '", conversation.name, "', line [", currentLineNumber,"] has already been played");
				error(errorprint3);
			end
		end
	
		-- Check for dead character
		if (self:CharacterCanSpeak(line, conversation)) then
			currentLineNumber = self:GetNextLine(conversation, line, true, true);	-- (conversation, line, if failed to play, if character was dead)
			if (self.showPrintMessages) then print("Line " .. line.privateData.lineNumber .. " failed due to dead character.  Moving on to line " .. currentLineNumber .. "."); end
		-- If we don't have a conditional, or if the "If" conditional yields TRUE
		elseif (not (line.If or line.ElseIf or line.Else) or (line.If and line.If(line, conversation, self, currentLineNumber))) then
			foundLine = true;
		-- If we have an "ElseIf" or "Else" conditional
		elseif ((line.ElseIf and line.ElseIf(line, conversation, self, currentLineNumber)) or line.Else) then
			if (not line.privateData.previousLine) then
				currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
				if (self.showPrintMessages) then print("Line " .. line.privateData.lineNumber .. " had an Else or ElseIf conditional without an If before it.  Moving on to line " .. currentLineNumber .. "."); end
			else
				local isValidConditionalBlock:boolean = true;
				local foundHeadIf:boolean = false;
				local blockAlreadyPlayed:boolean = false;
				
				local checkLine:table = line.privateData.previousLine;
				local checkedCheckLineNumbers:table = {};

				local debugWarningString = "";
											
				while (isValidConditionalBlock and not foundHeadIf and not blockAlreadyPlayed) do
					if (not checkLine or (not checkLine.If and not checkLine.ElseIf)) then
						debugWarningString = "Line " .. line.privateData.lineNumber .. " had an Else or ElseIf conditional without an If before it somewhere in the block.  Moving on to line ";
						isValidConditionalBlock = false;
					else
						if (checkedCheckLineNumbers[checkLine.privateData.lineNumber]) then
							-- Guards against infinite looping by bad user condintionals logic
							error("ERROR : Conversation '", conversation.name, "', line [", checkLine.privateData.lineNumber, "] has already been checked by If/Else block for line [", currentLineNumber,"] this tick.  We are looping infinitely!");
						end
						checkedCheckLineNumbers[checkLine.privateData.lineNumber] = true;
						
						if (checkLine.Else) then
							debugWarningString = "Line " .. line.privateData.lineNumber .. " had an Else or ElseIf conditional with another Else conditional before it.  Moving on to line ";
							isValidConditionalBlock = false;
						else
							blockAlreadyPlayed = checkLine.privateData.played;
							foundHeadIf = (checkLine.If and true);

							if (not blockAlreadyPlayed and not foundHeadIf) then
								checkLine = checkLine.privateData.previousLine;
							end
						end
					end
				end
				
				if (not isValidConditionalBlock) then
					currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
					if (self.showPrintMessages) then print(debugWarningString .. currentLineNumber .. "."); end
				elseif (blockAlreadyPlayed) then
					currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
					if (self.showPrintMessages) then print("Line " .. line.privateData.lineNumber .. " was skipped due to another conditional in the same block playing before it.  Moving on to line " .. currentLineNumber .. "."); end
				else
					foundLine = true;
				end
			end
		-- Conditional simply returned FALSE
		else
			currentLineNumber = self:GetNextLine(conversation, line, true, false);	-- (conversation, line, if failed to play, if character was dead)
			if (self.showPrintMessages) then print("Line " .. line.privateData.lineNumber .. " failed due to conditional returning FALSE.  Moving on to line " .. currentLineNumber .. "."); end
		end

		previousLine = line;
	end
	
	-- Kill convo, nothing played
	if (not foundLine) then
		conversation.privateData.linesCompletedTime = conversation.privateData.timeElapsed;

		if (conversation.OnLinesComplete) then
			CreateThread(conversation.OnLinesComplete, conversation, self);
		end
	-- Found line, start running it
	else
		if (self.showPrintMessages) then print("Conversation '" .. conversation.name .. "' now starting line: " .. currentLineNumber); end
		self:StartLine(conversation, currentLineNumber);
	end
end

function NarrativeQueueInstance:GetElapsedTimeOfLine(conversation):number	-- Returns number of ticks elapsed since this line has started
	local line:table = conversation.privateData.currentLine;
	
	return (conversation.privateData.timeElapsed - line.privateData.startTime);
end

function NarrativeQueueInstance:ProcessCurrentLine(conversation):void
	local line:table = conversation.privateData.currentLine;
	
	--if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Processing line: " .. ExtendedTable.ObjectToString(line)); end
	if (not line.privateData.played and line.privateData.playing
		and (self:GetElapsedTimeOfLine(conversation, line) >= (line.privateData.durationTicks + line.privateData.preDelayDurationTicks + line.privateData.playTickOffset))) then
		
		line.privateData.played = true;

		if (line.OnTagFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineNumber);
			else
				line.OnTagFinish(line, conversation, self, line.privateData.lineNumber);
			end
		end
	end
	
	-- Check for interrupt
	if (conversation.privateData.interrupted) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Line was interrupted"); end

		if (conversation.OnInterrupt) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnInterrupt, conversation, self, false);
			else
				conversation.OnInterrupt(conversation, self, false);
			end
		end
		
		self:HaltLine(conversation, ((type(conversation.privateData.interrupted) == "number" and conversation.privateData.interrupted) or self.interruptOverlapDuration));
		
		if (line.OnTagFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineNumber);
			else
				line.OnTagFinish(line, conversation, self, line.privateData.lineNumber);
			end
		end

		if (self.allowResume) then
			self:Push(self:Pop(conversation, self.playingConversations), self.delayedConversations);
		else
			self:FinishConversation(conversation);
		end
	-- Check character death
	elseif (self:CharacterCanSpeak(line, conversation)) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Character dead"); end

		self:HaltLine(conversation);
		
		if (line.OnTagFinish) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(line.OnTagFinish, line, conversation, self, line.privateData.lineNumber);
			else
				line.OnTagFinish(line, conversation, self, line.privateData.lineNumber);
			end
		end
		
		conversation.privateData.nextLine = self:GetNextLine(conversation, line, true, true);
	-- Check sleepBefore
	elseif (not line.privateData.preDelayCompleted) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Sleep Before"); end
		line.privateData.preDelayCompleted = self:GetElapsedTimeOfLine(conversation) >= line.privateData.preDelayDurationTicks;
	-- Check playing
	elseif (not line.privateData.played) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Playing"); end
		-- Do we need to start?
		if (not line.privateData.playing) then
			local debugString:string = "NarrativeQueueInstance.ProcessCurrentLine( '";
			debugString = debugString .. conversation.name;
			debugString = debugString .. "'.lines[";
			debugString = debugString .. line.privateData.lineNumber;
			debugString = debugString .. "] ) - START PLAYING - Duration: ";
			debugString = debugString .. frames_to_seconds(line.privateData.durationTicks);
			if (self.showPrintMessages) then print(debugString); end
			
			line.privateData.playTickOffset = self:GetElapsedTimeOfLine(conversation) - line.privateData.preDelayDurationTicks;

			-- DEBUG CODE ONLY - v-jamcro
			-- NOT_QUITE_RELEASE
			if (debugKeepARecordOfPlayedLines) then
				table.insert(debugLinePlayRecord[line], get_total_game_time_seconds_NOT_QUITE_RELEASE());
			end
			-- DEBUG CODE ONLY - v-jamcro

			self:PlayLine(conversation);
		end
	-- Check for request to end conversation early
	elseif (conversation.privateData.endEarly) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Conversation was ended early"); end
		
		self:HaltLine(conversation);
		
		if (conversation.OnInterrupt) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnInterrupt, conversation, self, true);
			else
				conversation.OnInterrupt(conversation, self, true);
			end
		end

		if (self.allowResume) then
			self:Push(self:Pop(conversation, self.playingConversations), self.delayedConversations);
		else
			self:FinishConversation(conversation);
		end
	-- Check sleepAfter
	elseif (not line.privateData.postDelayCompleted) then
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Sleep After"); end
		line.privateData.postDelayCompleted = self:GetElapsedTimeOfLine(conversation) >= (line.privateData.durationTicks + line.privateData.preDelayDurationTicks + line.privateData.postDelayDurationTicks);
	-- Set next line to play
	else
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Set Next Line"); end
		conversation.privateData.nextLine = self:GetNextLine(conversation, line, false, false);
		if (self.showPrintMessages) then print("NarrativeQueueInstance.ProcessCurrentLine() - Next Line: " .. conversation.privateData.nextLine); end
	end
end

function NarrativeQueueInstance:GetConversationParticipants(conversation):table	-- Returns a table containing all participants in the conversation	-- BONUS TODO
	-- If we haven't already resolved the participants of this conversation this frame...
	if (not self.conversationParticipantsThisFrame[conversation]) then
		local participants:table = {
			indexedTable = {},
			set = {},
		};

		-- BONUS TODO : Figure out who would participate in the convo right now, instead of all characters
		--if (self.showPrintMessages) then print("Get Participants - type(conversation): " .. type(conversation) .. " type(conversation.lines): " .. type(conversation.lines)); end
		--if (self.showPrintMessages) then print("name: " .. conversation.name); end
		for key, line in pairs(conversation.lines) do
			--if (self.showPrintMessages) then print("Get Participants - convo: " .. conversation.name .. " - type(line): " .. type(line)); end
			--if (self.showPrintMessages) then print("line.character: " .. ExtendedTable.ObjectToString(self:EvaluateCharacter(line, conversation))); end
			if (self:EvaluateCharacter(line, conversation)) then
				--if (self.showPrintMessages) then print("Insert character into indexedTable"); end
				table.insert(participants.indexedTable, self:EvaluateCharacter(line, conversation));
			end

			if (line.moniker) then
				table.insert(participants.indexedTable, line.moniker);
			end
		end
	
		participants.set = MathematicalSet.IndexedTableToSet(participants.indexedTable);
		--participants.indexedTable = MathematicalSet.SetToTableWithUniqueEntries(participants.set);
		participants.indexedTable = nil;
		
		--conversation.privateData.participants = participants;
	
		--if (self.showPrintMessages) then
		--	print("Participants:");
		--	for participant, _ in pairs(participants.set) do
		--		print("- " .. ExtendedTable.ObjectToString(participant));
		--	end
		--	print("/Participants");
		--end

		self.conversationParticipantsThisFrame[conversation] = participants;
	end

	return self.conversationParticipantsThisFrame[conversation];
end

function NarrativeQueueInstance:CheckPendingCanPlay(conversation):boolean	-- Returns TRUE if conversation can play, FALSE if not
	local result:boolean = false;
	local conversationPriority:number = conversation.privateData.priority;

	--if (self.showPrintMessages) then print("NarrativeQueueInstance:CheckPendingCanPlay( " .. conversation.name .. " )"); end
	-- Check conditional check frequency
	if (not conversation.privateData.interrupted and
	    (not conversation.CheckFrequency or (conversation.CheckFrequency(conversation, self) <= conversation.privateData.timeSinceLastCheck))) then
		
		conversation.privateData.timeSinceLastCheck = 0;

		--if (self.showPrintMessages) then print("Check Frequency passed"); end				
		-- Check conditional
		if (conversation.privateData.canStart or not conversation.CanStart or conversation.CanStart(conversation, self)) then
			result = true;
			conversation.privateData.canStart = conversation.canStartOnce or nil;

			--if (self.showPrintMessages) then print("Check Conditional passed"); end
			-- Check each currently-playing convo for collisions
			for playingKey, playingConvo in pairs(self.playingConversations) do
				local participantIntersection:table = self:GetConversationParticipants(conversation).set * self:GetConversationParticipants(playingConvo).set;
				
				-- Check participant and CriticalPath collisions
				if (conversationPriority == CONVO_PRIORITY.CriticalPath or not ExtendedTable.TableIsEmpty(participantIntersection)) then
					--if (self.showPrintMessages) then print("Conversation '" .. conversation.name .. "' failed to start because of PARTICIPANT collision with '" .. convo.name .. "'"); end
					local playingPriority = playingConvo.privateData.priority;

					-- Check for priority to interrupt or to play CriticalPath
					result = result and (conversationPriority > playingPriority);

					-- Collect playing lower-pri convos up, as they will be interrupted by our new convo, but ignore NPC convos
					if (result and playingPriority ~= CONVO_PRIORITY.NPC) then
						table.insert(conversation.privateData.interruptOnPlay, playingConvo);
					end
				end
			end
		end

		if (not result) then
			conversation.privateData.interruptOnPlay = {};
		end
	else
		result = nil;	-- Ignore convos we aren't checking due to frequency
	end
	
	--if (self.showPrintMessages) then print("Result: ", result); end
	return result;
end

function NarrativeQueueInstance:HandlePendingTimeout(conversation):void
	local timeoutDuration:number = (conversation.Timeout and conversation.Timeout(conversation, self)) or -1;
	
	-- Check for timeout
	if (conversation.privateData.interrupted or
		(timeoutDuration > -1 and conversation.privateData.timePending > seconds_to_frames(timeoutDuration))) then

		if (not conversation.privateData.interrupted and conversation.OnTimeout) then
			if (self.callbacksInSeparateThreads) then
				CreateThread(conversation.OnTimeout, conversation, self);
			else
				conversation.OnTimeout(conversation, self);
			end
		end

		--if (self.showPrintMessages) then print("Conversation '", conversation.name, "' Timed out after ", timeoutDuration, " seconds (", seconds_to_frames(timeoutDuration), " ticks)."); end
		print("Conversation '", conversation.name, ((conversation.privateData.interrupted and "' was interrupted while pending for ") or "' Timed out after "), timeoutDuration, " seconds (", seconds_to_frames(timeoutDuration), " ticks).");

		self:Pop(conversation, self.pendingConversations);
		UnregisterConvo(conversation);
	end
end

function HasPriorityConflict(testPriority, checkAgainstPriority):boolean
	return (checkAgainstPriority == CONVO_PRIORITY.CriticalPath) and (testPriority > CONVO_PRIORITY.NPC);
end

function NarrativeQueueInstance:ResolveReadyToPlay(readyList, notReadyList):void
	local sortTables:table = {};
	local trulyReady:table = {};
	local emptyConvo:table = {};
	
	for priority = 1, CONVO_PRIORITY._count do
		sortTables[priority] = {};
	end
	
	for index, convo in pairs(readyList) do
		table.insert(sortTables[convo.privateData.priority], convo);
	end

	local playingCritPath = false;

	-- Starting with highest-pri, check all convos for conflict
	for priority = CONVO_PRIORITY._count, 1, -1 do
		local priXConvos:table = sortTables[priority];
		local currentTrulyReadyIndex = #trulyReady;

		-- Check each convo in the current priority for conflicts (Searched in reverse for FIFO behavior)
		for key = #priXConvos, 1, -1 do
			local convo:table = priXConvos[key];
			-- Only a single CritPath can play, and MainCharacter can play only if CritPath does not
			local convoTrulyReady = (priority == CONVO_PRIORITY.NPC) or (not playingCritPath);

			-- Check against each previous convo in the same priority (following ones have already checked against us)
			if (convoTrulyReady) then
				for nextKey = (key - 1), 1, -1 do
					local nextConvo:table = priXConvos[nextKey];
					local participantIntersection:table = self:GetConversationParticipants(convo).set * self:GetConversationParticipants(nextConvo).set;

					-- If a conflict is detected
					if (not ExtendedTable.TableIsEmpty(participantIntersection)) then
						convoTrulyReady = false;
						break;
					end
				end
			end

			-- Check against each already checked truly ready convo
			if (convoTrulyReady) then
				for readyKey = currentTrulyReadyIndex, 1, -1 do
					local readyConvo = trulyReady[readyKey];
					local participantIntersection:table = self:GetConversationParticipants(convo).set * self:GetConversationParticipants(readyConvo).set;

					if (not ExtendedTable.TableIsEmpty(participantIntersection)) then
						convoTrulyReady = false;
						break;
					end
				end			
			end
			
			if (convoTrulyReady) then
				table.insert(trulyReady, convo);

				if (priority == CONVO_PRIORITY.CriticalPath) then
					playingCritPath = true;
				end
			else
				convo.privateData.interruptOnPlay = {};
				table.insert(notReadyList, convo);
			end
		end
	end

	-- Walk the truly ready list and start all convos (interrupt conflicting playing convos with lower priorities)
	for key, convo in pairs(trulyReady) do
		for interruptKey, interruptConvo in pairs(convo.privateData.interruptOnPlay) do
			interruptConvo.privateData.interrupted = true;
		end

		convo.privateData.interruptOnPlay = {};
		self:StartConversation(convo);
	end
end

function NarrativeQueueInstance:Update():void	-- BONUS TODO
	--if (self.showPrintMessages) then print("Entering NarrativeQueueInstance.Update()."); end

	if (self.updateIsRunning) then
		error("ERROR - NarrativeQueueInstance:Update() is already running.  Attempted to start a second Update thread.");
	else
		self.updateIsRunning = true;
	end
	
	-- Only one queue update should ever run.  Make sure it's the most recent one.
	self.currentRunningId = self.currentRunningId + 1;
	local runningId = self.currentRunningId;

	self.TimeElapsed = 0;

	local lastTimestamp:number = game_tick_get();
	local thisTimestamp:number = lastTimestamp;

	local frameDelta:number = 0;	--self.updateFrequency;
	
	local currentFrameNumber:number = 0;
	local needFrameErrorReported:boolean = true;

	while (self.isActive and runningId == self.currentRunningId) do
		local readyToStartConvos:table = {};
		local notReadyConvos:table = {};
				
		--SleepUntil ([| not self:IsThreadPaused() ], self.pauseUpdateFrequency);
		
		self.threadLocked = true;

		-- Guard against outsider Sleep's >:(
		currentFrameNumber = game_tick_get();
		needFrameErrorReported = true;

		-- Check Playing
		for key, convo in pairs(self.playingConversations) do
			convo.privateData.timeElapsed = convo.privateData.timeElapsed + frameDelta;

			-- Check convo preDelay (sleepBefore)
			if (not convo.privateData.preDelayCompleted) then
				convo.privateData.preDelayCompleted = convo.privateData.timeElapsed >= convo.privateData.preDelayDurationTicks;
				
				if (convo.privateData.preDelayCompleted and convo.OnStart) then
					if (self.callbacksInSeparateThreads) then
						CreateThread(convo.OnStart, convo, self);
					else
						convo.OnStart(convo, self);
					end
				end
			-- If we're past the preDelay and haven't yet played all lines
			elseif (not convo.privateData.linesCompletedTime) then
				-- If we need to start a new line
				if (not convo.privateData.currentLine or convo.privateData.nextLine) then
					self:StartNextLine(convo);
				-- If we need to update a currently-playing line
				else
					self:ProcessCurrentLine(convo);
				end
			-- Check convo postDelay (sleepAfter)
			elseif (not convo.privateData.postDelayCompleted) then
				convo.privateData.postDelayCompleted = (convo.privateData.timeElapsed - convo.privateData.linesCompletedTime) >= convo.privateData.postDelayDurationTicks;

				if (convo.privateData.postDelayCompleted) then
					--if (self.showPrintMessages) then print("Conversation '" .. convo.name .. "' FINISHED"); end
					self:FinishConversation(convo);
				end
			end

			-- Check to see if someone has slept during our thread...
			if (needFrameErrorReported and currentFrameNumber ~= game_tick_get()) then
				needFrameErrorReported = false;
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				print("ERROR : An unexpected 'sleep' occurred PLAYING conversation ", convo.name);
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				--error("ERROR : An unexpected 'sleep' occurred PLAYING conversation " .. convo.name);
			end
		end

		-- Check Pending
		for key, convo in pairs(self.pendingConversations) do
			convo.privateData.timePending = convo.privateData.timePending + frameDelta;
			convo.privateData.timeSinceLastCheck = convo.privateData.timeSinceLastCheck + frameDelta;
			
			-- A result of 'nil' tells us to ignore the convo this tick due to its check frequency
			local result = self:CheckPendingCanPlay(convo);
			if (result == false) then
				table.insert(notReadyConvos, convo);
			elseif (result) then
				table.insert(readyToStartConvos, convo);
			end

			-- Check to see if someone has slept during our thread...
			if (needFrameErrorReported and currentFrameNumber ~= game_tick_get()) then
				needFrameErrorReported = false;
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				print("ERROR : An unexpected 'sleep' occurred CHECKING conversation ", convo.name);
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				--error("ERROR : An unexpected 'sleep' occurred CHECKING conversation " .. convo.name);
			end
		end

-- BONUS TODO : v-jamcro : Implement RESUME functionality
--[[
		if (self.showPrintMessages) then print("Update() - Delayed"); end
		-- Check Delayed
		for key, convo in pairs(self.delayedConversations) do
			--if (self.showPrintMessages) then print("Delayed - key: " .. ExtendedTable.ObjectToString(key) .. " convo: " .. ExtendedTable.ObjectToString(convo)); end
			
			convo.privateData.timePending = convo.privateData.timePending + frameDelta;
			convo.privateData.timeSinceLastCheck = convo.privateData.timeSinceLastCheck + frameDelta;
			
			-- TODO : integrate "delayed" convos into the "pending ready to starts", with resume behavior instead of start behavior
		end
		-- TODO
--]]
		-- Check and start all ready-to-start Pending conversations that survived pre-screening
		self:ResolveReadyToPlay(readyToStartConvos, notReadyConvos);
		readyToStartConvos = {};

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentFrameNumber ~= game_tick_get()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred while starting a new conversation");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred while starting a new conversation");
		end
		
		--if (self.showPrintMessages) then print("Update() - Resolve Still Pending[" .. table.maxn(notReadyConvos) .. "]"); end
		-- Check all still-pending conversations for timeout
		for key, convo in pairs(notReadyConvos) do
			self:HandlePendingTimeout(convo);

			-- Check to see if someone has slept during our thread...
			if (needFrameErrorReported and currentFrameNumber ~= game_tick_get()) then
				needFrameErrorReported = false;
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				print("ERROR : An unexpected 'sleep' occurred CHECKING TIMEOUT conversation ", convo.name);
				print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
				--error("ERROR : An unexpected 'sleep' occurred CHECKING TIMEOUT conversation " .. convo.name);
			end
		end

		-- Check all previously-interrupted, lingering sound tags to see if they're ready to be silenced
		local expiredTags = {};
		for key, lineData in pairs(self.interruptedLines) do
			lineData.duration = lineData.duration - frameDelta;

			if (lineData.duration <= 0) then
				expiredTags[key] = true;
			end
		end
		self:SilenceAllInterruptedLines(expiredTags);

		-- Reset the frame-record for conversation participants (before the sleep so we don't save it)
		self.conversationParticipantsThisFrame = {};
				
		-- Wait until next desired updated tick
		self.threadLocked = false;

		-- Check to see if someone has slept during our thread...
		if (needFrameErrorReported and currentFrameNumber ~= game_tick_get()) then
			needFrameErrorReported = false;
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			print("ERROR : An unexpected 'sleep' occurred during a single tick of NarrativeQueueInstance.Update()");
			print("!! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !! == !! -- !!");
			--error("ERROR : An unexpected 'sleep' occurred during a single tick of NarrativeQueueInstance.Update()");
		end

		Sleep(self.updateFrequency);

		local tempTimestamp:number = game_tick_get();
		lastTimestamp = thisTimestamp;
		thisTimestamp = tempTimestamp;

		frameDelta = (thisTimestamp - lastTimestamp);

		--print("Frame Delta : ", frameDelta);

		-- Update 'time elapsed' since initializing the queue (timing)
		self.TimeElapsed = self.TimeElapsed + frameDelta + self.timeSpentPaused;
		self.timeSpentPaused = 0;
	end

	self.updateIsRunning = false;

	--if (self.showPrintMessages) then print("Exiting NarrativeQueueInstance.Update()."); end
end

function NarrativeQueueInstance:AsyncThreadSafeQueueConversation(conversation):void
	self:InitializeConversation(conversation);
	self:Push(conversation, self.pendingConversations);
end

function NarrativeQueueInstance:QueueConversation(conversation):void
	if (self.isActive) then
		CreateThread(self.AsyncThreadSafeQueueConversation, self, conversation);
	else
		error("Attempted to queue dialog conversation while Narrative Queue was not initialized.");
	end
end

--[[function NarrativeQueueInstance:AsyncThreadSafeResumeConversation(conversation):void	-- BONUS TODO
	SleepUntil ([| not self:IsThreadLocked() ], 1);
	self.threadPaused = self.threadPaused + 1;
	
	-- BONUNS TODO : Resume interrupted conversation
	
	self.threadPaused = self.threadPaused - 1;
end
--]]

--[[function NarrativeQueueInstance:ResumeConversation(conversation):void
	CreateThread(self.AsyncThreadSafeResumeConversation, self, conversation);
end
--]]

function NarrativeQueueInstance:AsyncThreadSafeEndConversationEarly(conversation):void
	if (conversation and ConvoHasPrivateData(conversation)) then
		conversation.privateData.endEarly = true;
	end
end

function NarrativeQueueInstance:EndConversationEarly(conversation):void
	if (self.isActive) then
		CreateThread(self.AsyncThreadSafeEndConversationEarly, self, conversation);
	end
end

function NarrativeQueueInstance:AsyncThreadSafeInterruptConversation(conversation, interruptOverlapDuration):void
	if (conversation and ConvoHasPrivateData(conversation)) then
		conversation.privateData.interrupted = interruptOverlapDuration or true;
	end
end

function NarrativeQueueInstance:InterruptConversation(conversation, interruptOverlapDuration):void
	if (self.isActive) then
		CreateThread(self.AsyncThreadSafeInterruptConversation, self, conversation, interruptOverlapDuration);
	end
end

function NarrativeQueueInstance:AsyncThreadSafeKillConversation(conversation):void
	if (not ConvoHasPrivateData(conversation)) then
		print("WARNING :: Attempted to KillConversation() on a convo that is not currently running [convo.name: '", conversation.name, "']");
		return;
	end

	local isPending = 1;
	local isPlaying = 2;
	local isDelayed = 3;

	local queueIndex = 0;

	-- Check Pending
	for key, convo in pairs(self.pendingConversations) do
		if (convo == conversation) then
			queueIndex = isPending;
			break;
		end
	end

	-- Check Playing
	if (queueIndex == 0) then
		for key, convo in pairs(self.playingConversations) do
			if (convo == conversation) then
				queueIndex = isPlaying;
				break;
			end
		end
	end

	-- Check Delayed
	if (queueIndex == 0) then
		for key, convo in pairs(self.delayedConversations) do
			if (convo == conversation) then
				queueIndex = isDelayed;
				break;
			end
		end
	end

	if (queueIndex == isPending) then
		self:Pop(conversation, self.pendingConversations);
		UnregisterConvo(conversation);
	elseif (queueIndex == isPlaying) then
		self:HaltLine(conversation);
		self:FinishConversation(conversation);
	elseif (queueIndex == isDelayed) then
		self:Pop(conversation, self.delayedConversations);
		UnregisterConvo(conversation);
	else
		print("WARNING :: Attempted to KillConversation() on a convo that is not currently in any queue [convo.name: '", conversation.name, "']");
		print("WARNING :: Convo '", conversation.name, "' is not in the queue, yet somehow has valid privateData");
	end
end

function NarrativeQueueInstance:KillConversation(conversation):void
	if (self.isActive) then
		CreateThread(self.AsyncThreadSafeKillConversation, self, conversation);
	end
end



-- ==================================================
-- Narrative Queue Public Accessors
-- ==================================================

global NarrativeQueue:table = {
	hasPermanentFunctions = true,
	-- Data
	instance = NarrativeQueueInstance,

	-- User Macros
	NoCharacter = NarrativeQueueInstance.NoCharacterValue,
};

-- Methods
function NarrativeQueue.Initialize():table	-- Returns handle to the NarrativeQueueInstance
	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.Initialize()"); end

	if (NarrativeQueue.instance.updateIsRunning) then
		error("ERROR - NarrativeQueueInstance:Update() is already running.  Attempted to double-initialize the queue.");
	end

	NarrativeQueue.instance:Initialize();
	CreateThread(NarrativeQueue.instance.Update, NarrativeQueue.instance);

	return NarrativeQueue.instance;
end

function NarrativeQueue.AutoInitialize():void
	if (not NarrativeQueue.instance.isActive) then
		print("Narrative Queue was not yet initialized.");
		NarrativeQueue.Initialize();
	end
end

function NarrativeQueue.Kill():void
	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.Kill()"); end

	NarrativeQueue.instance:Kill();
end

function NarrativeQueue.QueueConversation(conversation):void
	if (NarrativeQueue.instance.showPrintMessages) then print("Attempt ::: NarrativeQueue.QueueConversation( " .. conversation.name .. " )"); end
	NarrativeQueue.AutoInitialize();

	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.QueueConversation( " .. conversation.name .. " )"); end
	
	if (ConvoHasPrivateData(conversation) and conversation.privateData.DEBUG_CONVO_QUEUED) then
		error("ERROR : attempting to queue conversation " .. (conversation.name or "<NAME WAS NIL>") .. " when it is already marked as 'queued'!");
	end

	LateRegisterTableAsConvo(conversation);
	NarrativeQueue.instance:QueueConversation(conversation);
end

function NarrativeQueue.EndConversationEarly(conversation):void
	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.EndConversationEarly( " .. conversation.name .. " )"); end

	NarrativeQueue.instance:EndConversationEarly(conversation);
end

function NarrativeQueue.InterruptConversation(conversation, interruptOverlapDuration):void
	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.InterruptConversation( " .. conversation.name .. " )"); end

	NarrativeQueue.instance:InterruptConversation(conversation, interruptOverlapDuration);
end

function NarrativeQueue.KillConversation(conversation):void
	if (NarrativeQueue.instance.showPrintMessages) then print("NarrativeQueue.KillConversation( " .. conversation.name .. " )"); end

	NarrativeQueue.instance:KillConversation(conversation);
end

function NarrativeQueue.HasConversationFinished(conversation):boolean
	return ConvoHasCompleted(conversation);
end

function NarrativeQueue.IsConversationQueued(conversation):boolean
	return ConvoHasPrivateData(conversation);
end

function NarrativeQueue.ResolveLineCharacter(thisLine, thisConvo, queue, lineNumber)
	return (type(thisLine.character) == "function" and thisLine.character(thisLine, thisConvo, queue, lineNumber)) or thisLine.character;
end

function NarrativeQueue.ConversationsPlayingCount():number
	return (not NarrativeQueue.instance.isActive and 0) or #NarrativeQueue.instance.playingConversations;
end

function NarrativeQueue.SetInterruptOverlapDuration(duration:number):void
	NarrativeQueue.instance.interruptOverlapDuration = duration;
end

function NarrativeQueue.GetInterruptOverlapDuration():number
	return NarrativeQueue.instance.interruptOverlapDuration;
end

-- ==================================================
-- Send To Client
-- ==================================================

-- DEBUG : Switch to enable Client MiniQueue behavior
global useNarrativeMiniQueue = false;

function PlayDialogFromMarkerOnSpecificClients(snd_sound:tag, o_object:object, o_player:object, s_markerName:string):void
	if(o_object ~= nil) then
		if (o_player) then
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialogPlayerAtMarker", snd_sound, o_object, o_player, s_markerName);
		else
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialogAtMarker", snd_sound, o_object, s_markerName);
		end
	else
		print("Invalid object passed to PlayDialogFromMarkerOnSpecificClients");
	end
end

function PlayDialogOnSpecificClients(snd_sound:tag, o_object:object, o_player:object):void
	if(o_object ~= nil) then
		if (o_player) then
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialogPlayer", snd_sound, o_object, o_player, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		else
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialog", snd_sound, o_object, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		end
	else
		if (o_player) then
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialogNilPlayer", snd_sound, o_player, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		else
			-- NOT_QUITE_RELEASE
			RunClientScript("ClientPlayDialogNil", snd_sound, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		end
	end
end

function StopDialogOnSpecificClients(snd_sound:tag, o_object:object, o_player:object):void
	if(o_object ~= nil) then
		if (o_player) then
			-- NOT_QUITE_RELEASE
			print("-<|>- -<|>- ClientStopDialogPlayer()");
			RunClientScript("ClientStopDialogPlayer", snd_sound, o_object, o_player, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		else
			-- NOT_QUITE_RELEASE
			print("-<|>- -<|>- ClientStopDialog()");
			RunClientScript("ClientStopDialog", snd_sound, o_object, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		end
	else
		if (o_player) then
			-- NOT_QUITE_RELEASE
			print("-<|>- -<|>- ClientStopDialogNilPlayer()");
			RunClientScript("ClientStopDialogNilPlayer", snd_sound, o_player, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		else
			-- NOT_QUITE_RELEASE
			print("-<|>- -<|>- ClientStopDialogNil()");
			RunClientScript("ClientStopDialogNil", snd_sound, (useNarrativeMiniQueue and (frames_to_seconds(60) * game_tick_get()) or nil));
		end
	end
end


function PlayDialogFromMarkerOnClients(snd_sound:tag, o_object:object, s_markerName:string):void
	PlayDialogFromMarkerOnSpecificClients(snd_sound, o_object, nil, s_markerName);
end


function PlayDialogOnClients(snd_sound:tag, o_object:object):void
	PlayDialogOnSpecificClients(snd_sound, o_object, nil);
end

function StopDialogOnClients(snd_sound:tag, o_object:object):void
	print("-<|>- -<|>- StopDialogOnClients()");
	StopDialogOnSpecificClients(snd_sound, o_object, nil);
end

-- ==================================================
-- Run On Client
-- ==================================================

--## CLIENT
-- DEBUG CODE ONLY - v-jamcro
-- NOT_QUITE_RELEASE
global recordOfLinesPlayed = {};
global debugKeepARecordOfPlayedLines = false;

function RegisterSoundRequestReceived(snd:tag)
	if (debugKeepARecordOfPlayedLines and snd) then
		recordOfLinesPlayed[snd] = recordOfLinesPlayed[snd] or {};
		table.insert(recordOfLinesPlayed[snd], game_tick_get());
	end
end

function DebugPrintRegisteredSoundRequests(snd:tag, prefix)
	if (snd) then
		if (not prefix) then
			print(snd, " played - ");
		end
		
		local str = prefix or "";

		for _, time in pairs(recordOfLinesPlayed[snd]) do
			str = str .. time .. ", ";
		end

		print(str);
	end
end

function DebugPrintTestConvo()
	local line = 1;

	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Tanaka_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_elevatorpa_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Buck_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_VO_SCR_W1HubMeridian_UN_Tanaka_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_07400.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_vale_03200.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_tanaka_00400.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_01000.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00400.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_00300.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00100.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_04607.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_sloan_00700.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_buck_03600.sound'), "[" .. line .. "] : "); line = line + 1;
	DebugPrintRegisteredSoundRequests(TAG('sound\001_vo\001_vo_scripted\001_vo_scr_w1hubmeridian\001_vo_scr_w1hubmeridian_un_locke_02000.sound'), "[" .. line .. "] : "); line = line + 1;
end
-- -- DEBUG CODE ONLY - v-jamcro



-- NOT_QUITE_RELEASE
-- v-jamcro : TEMP FIX FOR [ OSR-104675 : VO OVerlapping & Perf: Mini Queue Fix ]
global NarrativeMiniQueue:table = {
	ACTION_START = "start",
	ACTION_STOP = "stop",

	pendingVO = {},
	firstVOTimestamp = -1,

	tickCompareEpsilon = 5,
};

function NarrativeMiniQueue:QueueVO(vo:tag, character:object, timestamp:number, action:string)
	if (self.firstVOTimestamp < 0) then
		self.firstVOTimestamp = timestamp;

		print("MiniQueue : NOTE : This is the first tracked VO played.  There may have been significant lag (due to performance hitch) before it was received from the Server.");

		CreateThread(self.Update, self);
	end

	table.insert(self.pendingVO, { vo = vo, character = character, timestamp = timestamp, action = action, });
end

function NarrativeMiniQueue:Update()
	local startTimestamp = game_tick_get();

	while (true) do
		local evaluated = {};
		local ticksSoFar = game_tick_get() - startTimestamp;

		local lastTimePlayed = get_total_game_time_seconds_NOT_QUITE_RELEASE();
		local lastTickPlayed = -1;
		
		-- Play/Stop all VO ready to play/stop (overlaps assumed 'by design', as scripter can do so intentionally)
		--for index,voData in pairs(self.pendingVO) do
		for index = 1, #self.pendingVO do
			local voData = self.pendingVO[index];
			local ticksUntilPlay = voData.timestamp - self.firstVOTimestamp;
			local currentTime = get_total_game_time_seconds_NOT_QUITE_RELEASE();

			-- If we've been running for more ticks than a VO was supposed to wait, process it
			if (ticksUntilPlay <= ticksSoFar) then
				if (lastTimePlayed < currentTime) then
					if (seconds_to_frames(currentTime - lastTimePlayed) > ((ticksSoFar - lastTickPlayed) + self.tickCompareEpsilon)) then
						local detectedTimeLost = (currentTime - lastTimePlayed) - frames_to_seconds(ticksSoFar - lastTickPlayed);
						print(":: WARNING :: - Performance hitch detected!  We lost about ", detectedTimeLost, " seconds, and as a result VO TIMING WAS DELAYED.");
					end

					lastTimePlayed = currentTime;
					lastTickPlayed = ticksSoFar;
				end

				if (voData.action == self.ACTION_START) then
					sound_impulse_start_dialogue(voData.vo, voData.character);
				elseif (voData.action == self.ACTION_STOP) then
					sound_impulse_stop_object(voData.vo, voData.character);
				end

				table.insert(evaluated, 1, index);
			end
		end

		-- Clean up VO we've processed
		--for _,voIndex in pairs(evaluated) do
		for i = 1, #evaluated do
			table.remove(self.pendingVO, evaluated[i]);
		end

		evaluated = nil;

		Sleep(1);
	end

	self.firstVOTimestamp = -1;
end
-- -- v-jamcro : TEMP FIX FOR [ OSR-104675 : VO OVerlapping & Perf: Mini Queue Fix ]
-- -- NOT_QUITE_RELEASE


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialogPlayer(snd_sound:tag, o_object:object, o_player:object, timestamp:number):void
	if (player_get_unit(PLAYERS.local0) == o_player) then

		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(snd_sound);
		-- DEBUG CODE ONLY - v-jamcro
		
		if (timestamp) then
			NarrativeMiniQueue:QueueVO(snd_sound, o_object, timestamp, NarrativeMiniQueue.ACTION_START);
		else
			sound_impulse_start_dialogue(snd_sound, o_object);
		end
	end
end

-- NOT_QUITE_RELEASE
function remoteClient.ClientStopDialogPlayer(snd_sound:tag, o_object:object, o_player:object, timestamp:number):void
	if (player_get_unit(PLAYERS.local0) == o_player) then
		if (timestamp) then
			NarrativeMiniQueue:QueueVO(snd_sound, o_object, timestamp, NarrativeMiniQueue.ACTION_STOP);
		else
			sound_impulse_stop_object(snd_sound, o_object);
		end
	end
end


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialog(snd_sound:tag, o_object:object, timestamp:number):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(snd_sound);
	-- DEBUG CODE ONLY - v-jamcro
	
	if (timestamp) then
		NarrativeMiniQueue:QueueVO(snd_sound, o_object, timestamp, NarrativeMiniQueue.ACTION_START);
	else
		sound_impulse_start_dialogue(snd_sound, o_object);
	end
end

-- NOT_QUITE_RELEASE
function remoteClient.ClientStopDialog(snd_sound:tag, o_object:object, timestamp:number):void
	if (timestamp) then
		NarrativeMiniQueue:QueueVO(snd_sound, o_object, timestamp, NarrativeMiniQueue.ACTION_STOP);
	else
		sound_impulse_stop_object(snd_sound, o_object);
	end
end


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialogNilPlayer(snd_sound:tag, o_player:object, timestamp:number):void
	if (player_get_unit(PLAYERS.local0) == o_player) then
		
		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(snd_sound);
		-- DEBUG CODE ONLY - v-jamcro

		
		if (timestamp) then
			NarrativeMiniQueue:QueueVO(snd_sound, nil, timestamp, NarrativeMiniQueue.ACTION_START);
		else
			sound_impulse_start_dialogue(snd_sound, nil);
		end
	end
end

-- NOT_QUITE_RELEASE
function remoteClient.ClientStopDialogNilPlayer(snd_sound:tag, o_player:object, timestamp:number):void
	if (player_get_unit(PLAYERS.local0) == o_player) then
		if (timestamp) then
			NarrativeMiniQueue:QueueVO(snd_sound, nil, timestamp, NarrativeMiniQueue.ACTION_STOP);
		else
			sound_impulse_stop_object(snd_sound, nil);
		end
	end
end


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialogNil(snd_sound:tag, timestamp:number):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(snd_sound);
	-- DEBUG CODE ONLY - v-jamcro

	if (timestamp) then
		NarrativeMiniQueue:QueueVO(snd_sound, nil, timestamp, NarrativeMiniQueue.ACTION_START);
	else
		sound_impulse_start_dialogue(snd_sound, nil);
	end
end

-- NOT_QUITE_RELEASE
function remoteClient.ClientStopDialogNil(snd_sound:tag, timestamp:number):void
	if (timestamp) then
		NarrativeMiniQueue:QueueVO(snd_sound, nil, timestamp, NarrativeMiniQueue.ACTION_STOP);
	else
		sound_impulse_stop_object(snd_sound, nil);
	end
end


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialogPlayerAtMarker(snd_sound:tag, o_object:object, o_player:object, s_markerName:string):void
	if (player_get_unit(PLAYERS.local0) == o_player) then
	
		-- DEBUG CODE ONLY - v-jamcro
		-- NOT_QUITE_RELEASE
		RegisterSoundRequestReceived(snd_sound);
		-- DEBUG CODE ONLY - v-jamcro

		sound_impulse_start_marker(snd_sound, o_object, s_markerName, 1.0);
	end
end


-- NOT_QUITE_RELEASE
function remoteClient.ClientPlayDialogAtMarker(snd_sound:tag, o_object:object, s_markerName:string):void

	-- DEBUG CODE ONLY - v-jamcro
	-- NOT_QUITE_RELEASE
	RegisterSoundRequestReceived(snd_sound);
	-- DEBUG CODE ONLY - v-jamcro

	sound_impulse_start_marker(snd_sound, o_object, s_markerName, 1.0);
end

