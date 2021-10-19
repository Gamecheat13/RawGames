; =======================================================================================================================================================================
; =======================================================================================================================================================================
; JUMP TRAINING  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 010tr_jump
	; sleep until the player approaches the log 
	(sleep_until (>= g_cc_obj_control 2) 1)
	
		; cast the actors
		(vs_cast gr_johnson_marines TRUE 5 "010MA_100")
			(set johnson (vs_role 1))

	(set g_playing_dialogue TRUE)
	(sleep 1)
	
	; movement properties 
	(vs_enable_pathfinding_failsafe johnson TRUE)
	(sleep 1)
	
	(vs_go_to johnson TRUE ps_cc/jump_tr)
	(vs_aim_player johnson TRUE)
	(if (<= g_cc_obj_control 2) (sleep 30))

	; if the player still hasn't jumped over the log then sleep until the player
	; is standing infront of the log 
	(sleep_until	(or
					(volume_test_players tv_cc_jump_training)
					(>= g_cc_obj_control 3)
				)
	5)

	(if (<= g_cc_obj_control 2)
		(begin
			(if dialogue (print "JOHNSON: Up and over, Chief!"))
			(vs_play_line johnson TRUE 010MA_100)
			(set g_playing_dialogue FALSE)
		)
	)

	(sleep_until (>= g_cc_obj_control 3) 5 (* 30 10))
	(if (<= g_cc_obj_control 2)
		(begin
			(sleep_until (volume_test_players tv_cc_jump_training) 1)
			(player_action_test_reset)
			(sleep 1)
			(player_training_activate_jump)
			(if dialogue (print "JOHNSON: Jump! Stretch those legs, Spartan!"))
			(vs_play_line johnson TRUE 010MA_110)
			(set g_playing_dialogue FALSE)
		)
	)
	(sleep_until (>= g_cc_obj_control 3))
	(set g_playing_dialogue FALSE)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; GRENADE TRAINING  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 010tr_grenades
	(sleep_until (>= g_ss_obj_control 1))
	
	(chud_show_grenades TRUE)

	(if debug (print "010tr : grenades"))

		; cast the actors
		(if (not (game_is_cooperative))
			(begin
				(vs_cast gr_arbiter TRUE 0 "010MF_010")
					(set arbiter (vs_role 1))
			)
			(begin
				(vs_cast gr_marines TRUE 0 "010MF_020")
					(set marine_01 (vs_role 1))
			)
		)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
	(vs_enable_looking gr_arbiter  TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_arbiter TRUE)
	(vs_enable_pathfinding_failsafe gr_marines TRUE)
	(vs_enable_looking gr_marines  TRUE)
	(vs_enable_targeting gr_marines TRUE)
	(vs_enable_moving gr_marines TRUE)

	(vs_set_cleanup_script md_cleanup)

	(sleep 1)

		(if (not (game_is_cooperative))
			(begin
					(set g_playing_dialogue TRUE)
				
				(if dialogue (print "ARBITER: Grenades! Blow them to bits!"))
				(vs_play_line arbiter TRUE 010MF_010)
				
					(set g_playing_dialogue FALSE)

				(sleep_until (>= g_ss_obj_control 2) (* 30 10))
				(if (<= g_ss_obj_control 1)
					(begin
							(set g_playing_dialogue TRUE)

						(if dialogue (print "ARBITER: Use those grenades! Keep them pinned!"))
						(vs_play_line arbiter TRUE 010MF_030)
					)
				)
			)
			(begin
					(set g_playing_dialogue TRUE)

				(if dialogue (print "MARINE: Grenades! Let 'em have it!"))
				(vs_play_line marine_01 TRUE 010MF_020)
				
					(set g_playing_dialogue FALSE)

				(sleep_until (>= g_ss_obj_control 2) (* 30 10))
				(if (<= g_ss_obj_control 1)
					(begin
							(set g_playing_dialogue FALSE)
						
						(if dialogue (print "MARINE: Use those grenades! Frag 'em!"))
						(vs_play_line marine_01 TRUE 010MF_040)
					)
				)
			)
		)
	(set g_playing_dialogue FALSE)
)


; =======================================================================================================================================================================
; =======================================================================================================================================================================
; test scripts ==========================================================================================================================================================
; =======================================================================================================================================================================
; =======================================================================================================================================================================
