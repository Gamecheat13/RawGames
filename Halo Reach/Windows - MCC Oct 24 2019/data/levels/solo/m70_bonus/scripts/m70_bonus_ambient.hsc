; =================================================================================================
; MUSIC
; =================================================================================================

(global short s_music_hill -1)
(script dormant music_hill

	(sleep_until (>= s_music_hill 1 ))
	(dprint "music hill start")
	(sound_looping_start levels\solo\m70_bonus\music\m70b_music_01 NONE 1)

)


; =================================================================================================
; RAIN
; =================================================================================================

(global short s_rain_force -1)
(global short s_rain_force_last -1)

(script dormant f_rain

	(branch
		(= s_rain_force 0)
		(f_rain_kill)
	)

	(sleep_until
		(begin

			(if (not (= s_rain_force s_rain_force_last))
				(begin
				
					(dprint "changing rain")
					(set s_rain_force_last s_rain_force)

					(cond
						((= s_rain_force 1)
							(begin
								(dprint "heavy")
								(weather_animate_force heavy_rain 1 (random_range 10 15))		
							)
						)
						((= s_rain_force 2)
							(begin
								(dprint "stop")
								(weather_animate_force no_rain 1 0)		
							)
						)

					)
				)
			)

		FALSE)
	5)

)

(script static void f_rain_kill

	(weather_animate_force off 1 0)	

)


; =================================================================================================
; MISSION OBJECTIVES
; =================================================================================================

(script dormant mo_hill

	(f_hud_obj_new prompt_hill pause_hill)

)

; =================================================================================================
; CHAPTER TITLES
; =================================================================================================

(global boolean b_tit_hill_done FALSE)
(script dormant tit_hill

	(f_hud_chapter ct_hill)
	(dprint "title done")
	(set b_tit_hill_done TRUE)

)

; =================================================================================================
; MISSION DIALOGUE
; =================================================================================================

; Hill  ========================================================

(global boolean g_dialog FALSE)
(script dormant md_hill_line
	(sleep_until (not g_dialog))
	(set g_dialog TRUE)

		(tick)

	(set g_dialog FALSE)
)

; =================================================================================================
; PULSES
; =================================================================================================

;(global boolean g_pulse_kat_transmission 0)
;(script continuous kat_transmission_pulse
	;(if (= g_pulse_kat_transmission 1) (cinematic_set_title ct_incoming_message_kat))
	;(sleep 30)	
;)


; =================================================================================================
; MISSION DIALOGUE: MAIN SCRIPTS
; =================================================================================================
(script static void (md_play_debug (short delay) (string line))
	(if dialogue (print line))
	(sleep delay))

(script static void (md_play (short delay) (sound line))
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line))
	(sleep delay))