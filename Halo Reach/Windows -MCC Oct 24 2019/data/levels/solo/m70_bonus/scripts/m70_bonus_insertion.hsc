; =================================================================================================
; TRANSITION
; =================================================================================================
(script static void itr (ins_transition))
(script static void ins_transition
	(if b_debug (print "::: insertion point: transition"))
	(set g_insertion_index s_insert_idx_transition)
				
	; Play the intro cinematic	
	(if 
		(or
			(and cinematics (not editor))
			editor_cinematics
		)
			(begin
				(cinematic_enter 070lb_re_intro TRUE)
				(f_play_cinematic_advanced 070lb_re_intro set_hill set_hill)
				(sleep 1)
			)
	)

	(switch_zone_set set_hill)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (set_hill) to fully load..."))
	;(sleep_until (= (current_zone_set_fully_active) s_set_hill) 1)
	(if b_debug (print "::: INSERTION: Finished loading (set_hill)"))
	(sleep 1)


	; Teleport
	(object_teleport_to_ai_point (player0) ps_hill_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_hill_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_hill_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_hill_spawn/player3)

)

; =================================================================================================
; HILL
; =================================================================================================
(script static void ihi (ins_hill))
(script static void ins_hill
	(if b_debug (print "::: insertion point: hill"))
	(set g_insertion_index s_insert_idx_hill)
				
	; Play the intro cinematic	
	(if 
		(or
			(and cinematics (not editor))
			editor_cinematics
		)
			(begin
				(cinematic_enter 070lb_re_intro TRUE)
				(f_play_cinematic_advanced 070lb_re_intro set_hill set_hill)
				(sleep 1)
			)
	)

	(switch_zone_set set_hill)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (set_hill) to fully load..."))
	;(sleep_until (= (current_zone_set_fully_active) s_set_hill) 1)
	(if b_debug (print "::: INSERTION: Finished loading (set_hill)"))
	(sleep 1)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_hill_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_hill_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_hill_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_hill_spawn/player3)

)

; =================================================================================================
; CREDITS (replacing with hill insertion since we're moving credits to m70_a per bug 55876 -timwil
; =================================================================================================

(script static void icr (ins_credits))
(script static void ins_credits
	(if b_debug (print "::: insertion point: hill"))
	(set g_insertion_index s_insert_idx_hill)
				
	; Play the intro cinematic	
	(if 
		(or
			(and cinematics (not editor))
			editor_cinematics
		)
			(begin
				(cinematic_enter 070lb_re_intro TRUE)
				(f_play_cinematic_advanced 070lb_re_intro set_hill set_hill)
				(sleep 1)
			)
	)

	(switch_zone_set set_hill)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (set_hill) to fully load..."))
	;(sleep_until (= (current_zone_set_fully_active) s_set_hill) 1)
	(if b_debug (print "::: INSERTION: Finished loading (set_hill)"))
	(sleep 1)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_hill_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_hill_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_hill_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_hill_spawn/player3)
)