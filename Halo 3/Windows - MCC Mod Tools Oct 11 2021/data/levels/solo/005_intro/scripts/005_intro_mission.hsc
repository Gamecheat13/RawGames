;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)
(global boolean g_player_training TRUE)

(global boolean debug FALSE)
(global boolean dialogue TRUE)
(global boolean music TRUE)

; starting player pitch 
(global short g_player_start_pitch -16)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== INTRO MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
		; award mission achievement 
		(game_award_level_complete_achievements)
			(sleep 1)
		
	; select insertion point 
	(ins_intro)
	
	; turn off all game sounds 
	(sound_class_set_gain "" 0 0)

		; sleep... bleh 
		(sleep 5)
			
	; end mission 
	(end_mission)
)

(script startup mission_intro
	(if debug (print "intro cinematic"))
	(print_difficulty)
	
	; snap to black 
	(fade_out 0 0 0 0)
	
	; pause metagame timer during cinematic  
	(campaign_metagame_time_pause TRUE)
	
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)


		(if	(and
				(not editor)
				(> (player_count) 0)
			)
			; if game is allowed to start 
			(start)
			
			; if game is NOT allowed to start
			(fade_in 0 0 0 0)
		)
)
