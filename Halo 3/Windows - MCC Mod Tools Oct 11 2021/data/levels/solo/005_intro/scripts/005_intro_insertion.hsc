;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 24)

;=========================================================================================
;================================== CHIEF CRATER =========================================
;=========================================================================================
(script static void ins_intro
	(if debug (print "insertion point : chief crater"))
	
	; snap to black 
	(cinematic_snap_to_black)
		(sleep 5)
	
		; play opening cinematic 
		(if g_play_cinematics
			(begin
				; switch to correct zone set unless "set_all" is loaded 
				(if (!= (current_zone_set) g_set_all)
					(begin
						(if debug (print "switching zone sets..."))
						(switch_zone_set set_cin_intro)
					)
				)
			
				; wake opening cinematic 
				(if	(or
						(= (game_is_cooperative) TRUE)
						(>= (game_difficulty_get) heroic)
						(= (campaign_metagame_enabled) TRUE)
					)
					(005_intro_insertion_full)
					(005_intro_insertion)
				)
			)
		)
	; turn off all game sounds 
	(sound_class_set_gain "" 0 0)

	; fade_out
	(fade_out 0 0 0 0)

	; cinematic commands 
	(cinematic_stop)
	(camera_control OFF)
		(sleep 1)

	; clean up all the cinematic bullshit!!!!!! 
	(sleep_forever recenter_view)
)
