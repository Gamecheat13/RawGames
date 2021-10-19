;matt's global scripts

(script static unit player0
  (unit (list_get (players) 0)))

(script static unit player1
  (unit (list_get (players) 1)))
  
(script static short player_count
  (list_count (players)))

(script static void end_segment
	(camera_control TRUE)
	(cinematic_start)
	(fade_out 0 0 0 15)
	(sleep 30)
	(print "End gameplay segment!  Thank you for playing!")
	(sleep 15)
	(print "Grab Jaime or Paul to give feedback!")
	(player_action_test_reset)
	(sleep 15)
	(print "Press the “A” button to reset!")
	(sleep_until (player_action_test_accept))
	(print "Reloading map...")
	(sleep 15)
	(map_reset)
)

; Globals
(global string data_mine_mission_segment "")


; Difficulty level scripts
(script static boolean difficulty_legendary
	(= (game_difficulty_get) legendary)
)

(script static boolean difficulty_heroic
	(= (game_difficulty_get) heroic)
)

(script static boolean difficulty_normal
	(= (game_difficulty_get) normal)
)


; Cutscene skip hacks live again
; Yuck... at least I understand it now
(script static boolean cinematic_skip_start
	(cinematic_skip_start_internal)		; Listen for the button which reverts (skips)
	(game_save_cinematic_skip)			; Save the game state
	(sleep_until (not (game_saving)) 1)	; Sleep until the game is done saving
	(not (game_reverted))				; Return whether or not the game has been reverted
)


(script static void cinematic_skip_stop
	(cinematic_skip_stop_internal)		; Stop listening for the button
	(if (not (game_reverted)) (game_revert))	; If the player did not revert, do it for him
)


; Cinematic fade scripts
(script static void cinematic_fade_to_white
	; Kill player control
	(player_enable_input false)
	(player_camera_control false)

	; Fade out
	(hud_cinematic_fade 0 0.5) ; pbertone 9/23 
	(cinematic_start) ; pbertone 9/23 
	(fade_out 1 1 1 30) ; pbertone - changed from 15 to 30 (9/23) 
	(sleep 30) ; pbertone - changed from 15 to 30 (9/23) 
	; Edit sound channels, other stuff here
;	(cinematic_start)
	(camera_control on)
)

(script static void cinematic_fade_from_white
	(hud_cinematic_fade 1 0.5)
	(cinematic_stop)
	; Edit sound channels, other stuff here
	(camera_control off)
	(fade_in 1 1 1 15)
	(sleep 15)

	; Restore player control
	(player_enable_input true)
	(player_camera_control true)
)

(script static void cinematic_fade_from_white_bars
	(cinematic_stop)
	(cinematic_show_letterbox_immediate true) ; But keep the letterbox up
	; Edit sound channels, other stuff here
	(camera_control off)
	(fade_in 1 1 1 15)
	(sleep 15)

	; Restore player control
	(player_enable_input true)
	(player_camera_control true)
)

(script static void cinematic_fade_from_black_bars
	(cinematic_stop)
	(cinematic_show_letterbox_immediate true) ; But keep the letterbox up
	; Edit sound channels, other stuff here
	(camera_control off)
	(fade_in 0 0 0 15)
	(sleep 15)

	; Restore player control
	(player_enable_input true)
	(player_camera_control true)
)

(script static void cinematic_fade_to_black
	; Kill player control
	(player_enable_input false)
	(player_camera_control false)

	; Fade out
	(hud_cinematic_fade 0 0.5) ; pbertone 9/23 
	(cinematic_start) ; pbertone 9/23 
	(fade_out 0 0 0 30) ; pbertone - changed from 15 to 30 (9/23) 
	(sleep 30) ; pbertone - changed from 15 to 30 (9/23) 
	; Edit sound channels, other stuff here
;	(hud_cinematic_fade 0 0.5)
;	(cinematic_start)
	(camera_control on)
)

(script static void cinematic_fade_from_black
	(hud_cinematic_fade 1 0.5)
	(cinematic_stop)
	; Edit sound channels, other stuff here
	(camera_control off)
	(fade_in 0 0 0 15)
	(sleep 15)

	; Restore player control
	(player_enable_input true)
	(player_camera_control true)
)

(script static void cinematic_snap_to_black
	; Kill player control
	(player_enable_input false)
	(player_camera_control false)

	(fade_out 0 0 0 0)
	; Edit sound channels, other stuff here
	(hud_cinematic_fade 0 0)
	(cinematic_start)
	(cinematic_show_letterbox_immediate true)
	(camera_control on)
)

(script static void cinematic_snap_to_white
	; Kill player control
	(player_enable_input false)
	(player_camera_control false)

	(fade_out 1 1 1 0)
	; Edit sound channels, other stuff here
	(hud_cinematic_fade 0 0)
	(cinematic_start)
	(cinematic_show_letterbox_immediate true)
	(camera_control on)
)

; Stashing mockups
(script static void cinematic_stash_players
	(object_hide (player0) true)
	(object_hide (player1) true)
	(object_cannot_take_damage (players))
)

(script static void cinematic_unstash_players
	(object_hide (player0) false)
	(object_hide (player1) false)
	(object_can_take_damage (players))
)


;- STEALTH
; Whee, horrible horrible. I can't wait to remove this

(script dormant _stealth_toggle_monitor
	(sleep_until
		(begin
			; Sleep until the button has been pressed, and there is full shield
			(sleep_until
				(if
					(and
						(>= (unit_get_shield (player0)) 1.0)
						(player_action_test_vision_trigger)
					)
					
					; Condition met, return true 
					(= 1 1)
					
					; Condition not met, reset player actions and return false
					(begin
						(player_action_test_reset)
						(= 1 0)
					)
				)
				1
			)
			
			; Activate stealth
			(cheat_active_camouflage_by_player 0 true)
			(print "stealth engaged")
			
			; Drain health
			(unit_set_maximum_vitality (player0) 50 0)
			(unit_set_current_vitality (player0) 50 0)
			(object_set_shield (player0) 0.0)
			
			; Sleep for a second
			(sleep 30)
			
			; Reset the test
			(player_action_test_reset)
			
			; Sleep until the player has disengaged, or been damaged
			(sleep_until
				(or
					(< (object_get_health (player0)) 1.0)
					(player_action_test_vision_trigger)
				)
				1
;				600
			)
			
			; Disengage
			(cheat_active_camouflage_by_player 0 false)
			(print "stealth disengaged")
			
			; Drain health
			(unit_set_maximum_vitality (player0) 30 70)
			(object_set_shield (player0) 0.0)
		
			; Sleep for a second
			(sleep 30)
			
			; Reset the test
			(player_action_test_reset)
			
			; Return false to continue looping
			false
		)
		1
	)
)

(script dormant _stealth_timer_monitor
	(sleep_until
		(begin
			; Sleep until the button has been pressed
			(sleep_until
				(if
;					(and
;						(>= (unit_get_shield (player0)) 1.0)
						(player_action_test_vision_trigger)
;					)
					
					; Condition met, return true 
					(= 1 1)
					
					; Condition not met, reset player actions and return false
					(begin
						(player_action_test_reset)
						(= 1 0)
					)
				)
				1
			)
			
			; Activate stealth
			(cheat_active_camouflage_by_player 0 true)
			(print "stealth engaged")
			
			; Drain health
;			(unit_set_maximum_vitality (player0) 50 0)
;			(unit_set_current_vitality (player0) 50 0)
;			(object_set_shield (player0) 0.0)
			
			; Sleep until fully stealthed (right now, it's 3-4 seconds)
			(sleep 15)
			
			; Reset the test
			(player_action_test_reset)
			
			; Sleep until the player has disengaged, attacks, or been damaged
			(sleep_until
				(or
					(player_action_test_vision_trigger)
					(player_action_test_primary_trigger)
					(player_action_test_grenade_trigger)
					(player_action_test_melee)
				)
				1
				(* 9 30)
			)

			; Disengage
			(cheat_active_camouflage_by_player 0 false)
			(print "stealth disengaged")
			
			; Drain health
;			(unit_set_maximum_vitality (player0) 30 70)
;			(object_set_shield (player0) 0.0)
		
			; Sleep for a second
			(sleep 30)
			
			; Reset the test
			(player_action_test_reset)
			
			; cooldown for 15 seconds 
			(sleep_until
				(begin
					(print "+")
					false
				)
				30
				(* 5 30) 
			)
			
			; Return false to continue looping
			false
		)
		1
	)
)


(script static void activate_stealth_toggle_monitor
	(sleep 1)
;	(wake _stealth_toggle_monitor)
)

(script static void activate_stealth_timer_monitor
	(sleep 1)
;	(wake _stealth_timer_monitor)
)

;========== PLAYTEST SCRIPTS ==========;Delete this before shipping
(script static void playtest_mission
	(if
		(game_is_playtest)
		(begin
			(sleep 30)
			(hud_set_training_text playtest_raisehand)
			(hud_show_training_text 1)
			(player_action_test_reset)
			(sleep_until (player_action_test_accept) 1)
			(hud_show_training_text 0)
			(sleep 30)
		)
	)
)