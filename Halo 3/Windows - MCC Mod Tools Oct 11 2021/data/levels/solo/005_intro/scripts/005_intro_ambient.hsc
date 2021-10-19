; =======================================================================================================================================================================
; =======================================================================================================================================================================
; opening cinematic  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script static void 005_intro_insertion
	; set current mission segment 
	(data_mine_set_mission_segment "010la_jungle_intro")

		; start intro cinematic (part one) 
		(if (cinematic_skip_start)
			(begin
				(if debug (print "010la_jungle_intro_01"))
				(010la_jungle_intro_01)
			)
		)
		(cinematic_skip_stop)
		
		; cleanup cinematic 
		(010la_jungle_intro_01_cleanup)
				
			; =================================================== 
			; ========= LOOK TRAINING =========================== 
			; =================================================== 
				(if g_player_training
					(begin
						(object_create_anew light_training)
						(005tr_look)
						(object_destroy light_training)
					)
				)
			; =================================================== 
			; ========= LOOK TRAINING =========================== 
			; =================================================== 

	; snap to black 
	(cinematic_snap_to_black)

		; finish intro cinematic (part two) 
		(if (cinematic_skip_start)
			(begin

				(if debug (print "010la_jungle_intro_02"))
				(010la_jungle_intro_02)
			)
		)
		(cinematic_skip_stop)
		
		; clenaup cinematic 
		(010la_jungle_intro_02_cleanup)
)

(script static void 005_intro_insertion_full
	; set current mission segment 
	(data_mine_set_mission_segment "010la_jungle_intro")

		; start intro cinematic (part one) 
		(if (cinematic_skip_start)
			(begin
				
				(if debug (print "010la_jungle_intro_01"))
				(010la_jungle_intro_01)

				; cleanup cinematic 
				(010la_jungle_intro_01_cleanup)
				
				; snap to black 
				(cinematic_snap_to_black)
				
					(if (cinematic_skip_start)
						(begin
							(if debug (print "010la_jungle_intro_02"))
							(010la_jungle_intro_02)
						)
					)
			)
		)
		(cinematic_skip_stop)
		
		; cleanup cinematic 
		(010la_jungle_intro_01_cleanup)
		(010la_jungle_intro_02_cleanup)
				
)

