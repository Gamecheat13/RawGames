;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean debug TRUE)
(global boolean editor FALSE)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== EPILOGUE MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script startup mission_epilogue
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		; if game is allowed to start 
		(start)
		
		; if game is NOT allowed to start fade in 
		(fade_in 0 0 0 0)
	)
)


(script static void start
	; fade out 
	(fade_out 0 0 0 0)

	(if debug (print "epilogue"))
	
	; switch zone sets 
	(switch_zone_set epilogue_voi)
		(sleep 1)
	
	; snap to black 
	(cinematic_snap_to_black)
	(sleep 1)

		(if (cinematic_skip_start)
			(begin
				(if debug (print "130lb_earth"))
				(130lb_earth)
			)
		)
		(cinematic_skip_stop)

	; remove letterboxes 
	(cinematic_show_letterbox_immediate FALSE)
	(camera_control on)
		

		(if (cinematic_skip_start)
			(begin
				(if (is_ace_build)
					(begin
						(sleep 90)
					)
					;else
					(begin
						; END CREDITS =======================================
					
							; 300 ticks of black 
							(sleep 30)
						
							; wake camera script
							(wake epilogue_camera)
							(sleep 1)

							; start end credits
							(sound_impulse_start "sound\music\end_credits\credits_music" none 0)
							(fade_in 0 0 0 15)
								(sleep 30)
						
							; play end credits 
							(play_credits_unskippable)
						
							; sleep bink movie time (+ 45 ticks) 
							(sleep (+ 10538 15))
					
							; stop bink movie 
							(stop_bink_movie)
						
							; kill camera script 
							(sleep_forever epilogue_camera)
						
							; fade out 
							(fade_out 0 0 0 60)
							(sleep 60)
						
						; END CREDITS =======================================
					)
				)

				; switch zone sets 
				(switch_zone_set epilogue_space)
				(sleep 1)
				
				(if (cinematic_skip_start)
					(begin
						; 180 ticks of black 
						(sleep 30)
						
						; snap to black 
						(cinematic_snap_to_black)
					
						(if debug (print "130lc_epilogue"))
						(130lc_epilogue)
						
							(if (>= (game_difficulty_get) legendary)
								(begin
									(if debug (print "130ld_legendary"))
									(130ld_legendary)
								)
							)
					)
				)
			)
		)	
		(cinematic_skip_stop)



	;turning fog back on 
	(render_atmosphere_fog 1)

	; end the mission 
	(end_mission)

	; the fight is now finished 
)

(script dormant epilogue_camera
	; start camera animation
	(camera_control on)
				
	; set the first camera point 
	(camera_set credits_background 0)

	(sleep_until
		(begin_random
			(begin
				(camera_set credits_background 1000)
				(sleep 1000)
				FALSE
			)
			(begin
				(camera_set credits_background2 1000)
				(sleep 1000)
				FALSE
			)
			(begin
				(camera_set credits_background3 1000)
				(sleep 1000)
				FALSE
			)
			(begin
				(camera_set credits_background4 1000)
				(sleep 1000)
				FALSE
			)
		FALSE)
	)
)





