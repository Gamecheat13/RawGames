;matt's global scripts

(script static unit player0
  (unit (list_get (players) 0)))

(script static unit player1
  (unit (list_get (players) 1)))

(script static unit player2
  (unit (list_get (players) 2)))

(script static unit player3
  (unit (list_get (players) 3)))
  
(script static short player_count
  (list_count (players)))

(script static void print_difficulty
	; such a horrible place to put this 
	(game_save_immediate)

	(cond
		((= (game_difficulty_get_real) easy) (print "easy"))
		((= (game_difficulty_get_real) normal) (print "normal"))
		((= (game_difficulty_get_real) heroic) (print "heroic"))
		((= (game_difficulty_get_real) legendary) (print "legendary"))
	)
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

; attempts to determine if the player is in combat 
(script static boolean players_not_in_combat
	(player_action_test_reset)
		(sleep 30)
	(if	(and
			(not (player_action_test_primary_trigger))
			(not (player_action_test_grenade_trigger))

			(cond
				((= (game_coop_player_count) 4)	(begin
												(>= (object_get_shield (player0)) 1)
												(>= (object_get_shield (player1)) 1)
												(>= (object_get_shield (player2)) 1)
												(>= (object_get_shield (player3)) 1)
											)
				)
				((= (game_coop_player_count) 3)	(begin
												(>= (object_get_shield (player0)) 1)
												(>= (object_get_shield (player1)) 1)
												(>= (object_get_shield (player2)) 1)
											)
				)
				((= (game_coop_player_count) 2)	(begin
												(>= (object_get_shield (player0)) 1)
												(>= (object_get_shield (player1)) 1)
											)
				)
				(TRUE						(begin
												(>= (object_get_shield (player0)) 1)
											)
				)
			)
		)
	TRUE ; if the player hasn't pulled either trigger and is at full health then return true 
	FALSE ; otherwise return false 
	)
)

; ======================================================================================
; Cinematic Skip Scripts ===============================================================
; ======================================================================================
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

; ======================================================================================
; Cinematic fade black scripts =========================================================
; ======================================================================================
(script static void cinematic_fade_to_black
		; the ai will disregard all players 
		(ai_disregard (players) TRUE)

		; players cannot take damage 
		(object_cannot_take_damage (players))

	; scale player input to zero 
	(player_control_fade_out_all_input 1)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause TRUE)

		; lower weapon 
		(unit_lower_weapon (player0) 30)
		(unit_lower_weapon (player1) 30)
		(unit_lower_weapon (player2) 30)
		(unit_lower_weapon (player3) 30)
			(sleep 10)
		
	; fade out the chud 
	(chud_cinematic_fade 0 0.5)
	
	; bring up letterboxes 
	(cinematic_show_letterbox TRUE)
		(sleep 5)
	
	; fade screen to black 
	(fade_out 0 0 0 30)
		(sleep 30)

		; hide players 
		(object_hide (player0) TRUE)
		(object_hide (player1) TRUE)
		(object_hide (player2) TRUE)
		(object_hide (player3) TRUE)
	
	; cinematic start after fading out because of camera pop 
	(cinematic_start)
	(camera_control ON)

	; disable player input 
	(player_enable_input FALSE)

	; player can now move 
	(player_disable_movement FALSE)
		(sleep 1)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)
)

; ======================================================================================
(script static void cinematic_snap_to_black
		; the ai will disregard all players 
		(ai_disregard (players) TRUE)

		; players cannot take damage 
		(object_cannot_take_damage (players))

	; fade screen to black 
	(fade_out 0 0 0 0)
;		(sleep 1)

	; scale player input to zero 
	(player_control_fade_out_all_input 0)
	
		; lower weapon 
		(unit_lower_weapon (player0) 1)
		(unit_lower_weapon (player1) 1)
		(unit_lower_weapon (player2) 1)
		(unit_lower_weapon (player3) 1)
			(sleep 1)
		
			; hide players 
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
	
	; fade out the chud 
	(chud_cinematic_fade 0 0)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause TRUE)
		(sleep 1)

	; cinematic start after fading out because of camera pop 
	(cinematic_start)
	(camera_control ON)

	; disable player input 
	(player_enable_input FALSE)

	; player can now move 
	(player_disable_movement FALSE)
		(sleep 1)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)
		(sleep 1)
)

; ======================================================================================
(script static void cinematic_fade_to_title
		(sleep 15)
	; cinematic stop and camera control off 
	(cinematic_stop)
	(camera_control OFF)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)

		; unhide players 
		(object_hide (player0) FALSE)
		(object_hide (player1) FALSE)
		(object_hide (player2) FALSE)
		(object_hide (player3) FALSE)
		
			; unlock the players gaze 
			(player_control_unlock_gaze (player0))
			(player_control_unlock_gaze (player1))
			(player_control_unlock_gaze (player2))
			(player_control_unlock_gaze (player3))
				(sleep 1)

			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)

	; fade screen from black 
		(sleep 1)
	(fade_in 0 0 0 15)
		(sleep 15)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))
)

; ======================================================================================
(script static void cinematic_fade_to_title_slow
	; cinematic stop and camera control off 
	(cinematic_stop)
	(camera_control OFF)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)

		; unhide players 
		(object_hide (player0) FALSE)
		(object_hide (player1) FALSE)
		(object_hide (player2) FALSE)
		(object_hide (player3) FALSE)
		
			; unlock the players gaze 
			(player_control_unlock_gaze (player0))
			(player_control_unlock_gaze (player1))
			(player_control_unlock_gaze (player2))
			(player_control_unlock_gaze (player3))
				(sleep 1)

			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)

	; fade screen from black 
		(sleep 1)
	(fade_in 0 0 0 150)
		(sleep 15)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))
)

; ======================================================================================
(script static void cinematic_title_to_gameplay
		(sleep 30)
		
		; unlock the players gaze 
		(player_control_unlock_gaze (player0))
		(player_control_unlock_gaze (player1))
		(player_control_unlock_gaze (player2))
		(player_control_unlock_gaze (player3))
			(sleep 1)

			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)
				(sleep 1)
				
		; raise weapons 
		(unit_raise_weapon (player0) 30)
		(unit_raise_weapon (player1) 30)
		(unit_raise_weapon (player2) 30)
		(unit_raise_weapon (player3) 30)
		(sleep 10)

	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)

	; player can now move 
	(player_disable_movement FALSE)
		(sleep 110)

	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
		(sleep 15)

	; fade in the HUD 
	(chud_cinematic_fade 1 1)
		
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))
	
	; game save 
	(game_save)
)

; ======================================================================================
(script static void cinematic_fade_to_gameplay
	; cinematic stop and camera control off 
	(cinematic_stop)
	(camera_control OFF)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)

		; unhide players 
		(object_hide (player0) FALSE)
		(object_hide (player1) FALSE)
		(object_hide (player2) FALSE)
		(object_hide (player3) FALSE)
	
			; unlock the players gaze 
			(player_control_unlock_gaze (player0))
			(player_control_unlock_gaze (player1))
			(player_control_unlock_gaze (player2))
			(player_control_unlock_gaze (player3))
				(sleep 1)

			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)

	; fade screen from black 
		(sleep 1)
	(fade_in 0 0 0 15)
		(sleep 15)

	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
	
	; fade in the chud 
	(chud_cinematic_fade 1 1)

		; raise weapon 
		(unit_raise_weapon (player0) 30)
		(unit_raise_weapon (player1) 30)
		(unit_raise_weapon (player2) 30)
		(unit_raise_weapon (player3) 30)
		(sleep 10)
		
	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))

	; player can now move 
	(player_disable_movement FALSE)
	
	; game save 
	(game_save)
)

; ======================================================================================
; CHAPTER TITLE SCRIPTS ================================================================
; ======================================================================================

(script static void chapter_start
	(chud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
		(sleep 30)
)
(script static void chapter_stop
	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
		(sleep 15)
	
	; fade in HUD 
	(chud_cinematic_fade 1 0.5)
	
	; game save 
	(game_save)
)

; ======================================================================================
; PERSPECTIVE SCRIPTS ==================================================================
; ======================================================================================

;For use with perspective scripts
(global boolean perspective_running FALSE)
(global boolean perspective_finished FALSE)

(script static void perspective_start
	; cancel any pending game saves 
	(game_save_cancel)
	
	; allow perspective to be skipped 
	(cinematic_skip_start_internal)

		; the ai will disregard all players 
		(ai_disregard (player0) 	TRUE)
		(ai_disregard (player1) 	TRUE)
		(ai_disregard (player2) 	TRUE)
		(ai_disregard (player3) 	TRUE)

			; players cannot take damage 
			(object_cannot_take_damage (player0))
			(object_cannot_take_damage (player1))
			(object_cannot_take_damage (player2))
			(object_cannot_take_damage (player3))

	; scale player input to zero 
	(player_control_fade_out_all_input 2)
	
		; lower weapon 
		(unit_lower_weapon (player0) 30)
		(unit_lower_weapon (player1) 30)
		(unit_lower_weapon (player2) 30)
		(unit_lower_weapon (player3) 30)
		
	; fade out the chud 
	(chud_cinematic_fade 0 0.5)
		(sleep 15)

	; bring up letterboxes 
	(cinematic_show_letterbox TRUE)
		(sleep 5)
	
	(fade_out 0 0 0 10)
		(sleep 10)
	(camera_control TRUE)
	(cinematic_start)
		(sleep 15)
)

(script static void perspective_stop
	; cinematic stop and camera control off 
	(cinematic_stop)
	(camera_control OFF)
		(sleep 1)

	; bring up letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)

		; unlock the players gaze 
		(player_control_unlock_gaze (player0))
		(player_control_unlock_gaze (player1))
		(player_control_unlock_gaze (player2))
		(player_control_unlock_gaze (player3))
	
	; scale player input to one 
	(player_control_fade_in_all_input 0.5)
	
	; fade screen from black 
	(fade_in 0 0 0 10)
		(sleep 5)

	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
	
		; raise weapon 
		(unit_raise_weapon (player0) 30)
		(unit_raise_weapon (player1) 30)
		(unit_raise_weapon (player2) 30)
		(unit_raise_weapon (player3) 30)
			(sleep 10)
	
	; fade in the chud 
	(chud_cinematic_fade 1 0.5)

	; pause the meta-game timer 
	; the ai will disregard all players 
	(ai_disregard (player0) 	FALSE)
	(ai_disregard (player1) 	FALSE)
	(ai_disregard (player2) 	FALSE)
	(ai_disregard (player3) 	FALSE)

		; players cannot take damage 
		(object_can_take_damage (player0))
		(object_can_take_damage (player1))
		(object_can_take_damage (player2))
		(object_can_take_damage (player3))
		
	; game save 
	(game_save)
)

(script static void perspective_skipped
	(cinematic_stop)
	(camera_control OFF)
	
		; the ai will disregard all players 
		(ai_disregard (player0) 	FALSE)
		(ai_disregard (player1) 	FALSE)
		(ai_disregard (player2) 	FALSE)
		(ai_disregard (player3) 	FALSE)
	
			; players cannot take damage 
			(object_can_take_damage (player0))
			(object_can_take_damage (player1))
			(object_can_take_damage (player2))
			(object_can_take_damage (player3))
	
		; unlock the players gaze 
		(player_control_unlock_gaze (player0))
		(player_control_unlock_gaze (player1))
		(player_control_unlock_gaze (player2))
		(player_control_unlock_gaze (player3))
			(sleep 5)

	; fade in player input 
	(player_control_fade_in_all_input 1)
	
	; fade in 
	(fade_in 0 0 0 15)
		(sleep 15)

		; raise weapon 
		(unit_raise_weapon (player0) 15)
		(unit_raise_weapon (player1) 15)
		(unit_raise_weapon (player2) 15)
		(unit_raise_weapon (player3) 15)

	
	; game save 
	(game_save)
)

(script static boolean perspective_skip_start
	(player_action_test_reset)
	; skip perspective 
	(sleep_until
		(or 
			(not perspective_running)
			(player_action_test_cinematic_skip)
		)
	1)
	
	perspective_running
)

; ======================================================================================
; INSERTION SCRIPTS ====================================================================
; ======================================================================================

(script static void insertion_start
	; fade out 
	(fade_out 0 0 0 0)
	
	; turn OFF all object sounds 
	(sound_class_set_gain "object" 0 0)
	(sound_class_set_gain "vehicle" 0 0)

	; show letterboxes immediately 
	(cinematic_show_letterbox_immediate TRUE)
	
	; snap out the HUD 
	(chud_cinematic_fade 0 0)
	
	; disable player movement 
	(player_disable_movement TRUE)

	; disable player input 
	(player_enable_input FALSE)

	; pause metagame timer   
	(campaign_metagame_time_pause TRUE)

		; lower players weapons 
		(unit_lower_weapon (player0) 1)
		(unit_lower_weapon (player1) 1)
		(unit_lower_weapon (player2) 1)
		(unit_lower_weapon (player3) 1)
		(sleep 1)
		
	; turn ON all object sounds 
	(sound_class_set_gain "object" 1 30)
	(sound_class_set_gain "vehicle" 1 30)
)

(script dormant insertion_end
		(sleep 30)
	(fade_in 0 0 0 15)
		(sleep 15)

	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
	
	; scale player input to one 
	(player_control_fade_in_all_input 1)
		(sleep 15)

	; fade in the HUD 
	(chud_cinematic_fade 1 1)
		
		; raise weapons 
		(unit_raise_weapon (player0) 30)
		(unit_raise_weapon (player1) 30)
		(unit_raise_weapon (player2) 30)
		(unit_raise_weapon (player3) 30)

	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))

	; enable player input 
	(player_enable_input TRUE)

	; player can now move 
	(player_disable_movement FALSE)
	
	; game save 
	(game_save)
)


;***** FIRST HALO 3 GLOBAL SCRIPT BELONGS TO ME!!! *****;

;This function will return the ai of a vehicle squad, irregardless of who may have gotten into the vehicle
(script static ai (ai_get_driver (ai vehicle_starting_location))
	(object_get_ai (vehicle_driver (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

(script static ai (ai_get_gunner (ai vehicle_starting_location))
	(object_get_ai (vehicle_gunner (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

;Returns TRUE if any player is in a vehicle
(script static boolean any_players_in_vehicle
	(or
		 (unit_in_vehicle (unit (player0)))
		 (unit_in_vehicle (unit (player1)))
		 (unit_in_vehicle (unit (player2)))
		 (unit_in_vehicle (unit (player3)))
	)
)

;global door script that will shut the given door and never allow it to open again
(script static void (shut_door_forever (device machine_door))
	(device_operates_automatically_set machine_door 0)
	(device_set_position machine_door 0)
	
	(sleep_until (<= (device_get_position machine_door) 0) 30 300)
	(if (> (device_get_position machine_door) 0)
		(device_set_position_immediate machine_door 0)
	)
	(sleep 1)
	(device_set_power machine_door 0)
)

;global door script that will shut the given door and never allow it to open again
;this version is immediate
(script static void (shut_door_forever_immediate (device machine_door))
	(device_operates_automatically_set machine_door 0)
	(device_set_position_immediate machine_door 0)
	(device_set_power machine_door 0)
)


;=========================================;
;==========   PLAYTEST SCRIPTS  ==========;
;==========  Delete Before Ship ==========;
;=========================================;

(script dormant reset_map_reminder
	(sleep_until
		(begin
			(print "Press A to play again!")
		FALSE)
	90)
)

(script static void end_segment
	(print "End gameplay segment!  Thank you for playing!")
	(sleep 15)
	(print "Grab Paul or Rob to give feedback!")
	(sleep 15)
	(player_action_test_reset)

	(sleep_until
		(begin
			(print "Press the “A” button to reset!")
			(sleep_until (player_action_test_accept) 1 90)
			(player_action_test_accept)
		)
	1)

	(print "Reloading map...")
	(sleep 15)
	(chud_cinematic_fade 1 0)
	(fade_in 0 0 0 0) 
	(map_reset)
)

(script static void end_mission
; 06.11.2007 - pbertone: commented this out at the end of H3 
	(if global_playtest_mode
		(begin
			(data_mine_set_mission_segment questionaire)
			(cinematic_fade_to_gameplay)
			(sleep 1) 
		
			(print "End mission!")
			(sleep 15)
			(hud_set_training_text playtest_raisehand)
			(hud_show_training_text 1)
			(sleep 90)
		
			(player_action_test_reset)
		
			(sleep_until
				(begin
					(sleep_until (player_action_test_accept) 1 90)
					(player_action_test_accept)
				)
			1)
		
			(hud_show_training_text 0)
			(print "loading next mission...")
			(sleep 15)
		)
		(begin
			; fade out 
			(fade_out 0 0 0 0)

			; cinematic stop and camera control off 
			(cinematic_stop)
			(camera_control OFF)
		)
	)
	
	; call game won 
	(game_won)
)

(script startup beginning_mission_segment
	(data_mine_set_mission_segment mission_start)
)

; ======================================================================================
; Cortana / Gravemind Channel Scripts ==================================================
; ======================================================================================
(global boolean g_cortana_header FALSE)
(global boolean g_cortana_footer FALSE)
(global boolean g_gravemind_header FALSE)
(global boolean g_gravemind_footer FALSE)

; ======================================================================================
; ======================================================================================
(script continuous gs_cortana_header
	(sleep_until g_cortana_header 1)
	(print "cortana header")
		
		; cancel any pending game saves 
		(game_save_cancel)
		
		; do not allow respawn coop players 
		(game_safe_to_respawn FALSE)
		
		; scale player input down 
		(player_control_scale_all_input 0.15 0.5)

		; turn comabat dialogue off  
		(ai_dialogue_enable FALSE)

		; the ai will disregard all players 
		(ai_disregard (players) TRUE)

		; players cannot take damage 
		(object_cannot_take_damage (players))
		
		; call damage effect on all players 
		(damage_players "cinematics\cortana_channel\cortana_effect")
		
		; flicker out the HUD 
		(gs_hud_flicker_out)
		
	(set g_cortana_header FALSE)
)

(script continuous gs_cortana_footer
	(sleep_until g_cortana_footer 1)
	(print "cortana footer")
		(sleep 1)
	
		; ALLOW  respawn coop players 
		(game_safe_to_respawn TRUE)
		
		; scale player input up 
		(player_control_scale_all_input 1.0 0.5)
	
		; turn comabat dialogue on 
		(ai_dialogue_enable TRUE)

		; the ai will disregard all players 
		(ai_disregard (players) 	FALSE)
	
		; players can take damage 
		(object_can_take_damage (players))
			(sleep 1)
		
		; game save 
		(game_save)
		
		; fade back in the HUD 
		(chud_cinematic_fade 1 1.5)
		
		; cortana out sound 
		(sound_impulse_start "sound\visual_fx\cortana_hud_on" NONE 1)

	(set g_cortana_footer FALSE)
)
; ======================================================================================
; ======================================================================================

(script continuous gs_gravemind_header
	(sleep_until g_gravemind_header 1)
	(print "gravemind header")

		; cancel any pending game saves 
		(game_save_cancel)
		
		; do not allow respawn coop players 
		(game_safe_to_respawn FALSE)
		
		; scale player input down 
		(player_control_scale_all_input 0.15 2)

		; turn comabat dialogue off  
		(ai_dialogue_enable FALSE)

		; the ai will disregard all players 
		(ai_disregard (players) TRUE)

		; players cannot take damage 
		(object_cannot_take_damage (players))
			(sleep 1)
	
	(set g_gravemind_header FALSE)
)

(script continuous gs_gravemind_footer
	(sleep_until g_gravemind_footer 1)
	(print "gravemind footer")

		; ALLOW  respawn coop players 
		(game_safe_to_respawn TRUE)
		
		; scale player input up 
		(player_control_scale_all_input 1.0 1)
	
		; turn comabat dialogue on 
		(ai_dialogue_enable TRUE)

		; the ai will disregard all players 
		(ai_disregard (players) 	FALSE)
	
		; players can take damage 
		(object_can_take_damage (players))
			(sleep 1)

	(set g_gravemind_footer FALSE)
		(sleep 30)

		; game save 
		(game_save)
	
)

(script static void gs_hud_flicker_out
	(chud_cinematic_fade 0 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.035))
	(sound_impulse_start "sound\visual_fx\sparks_medium" NONE 1)
		(sleep (random_range 2 5))

	(chud_cinematic_fade 0 (real_random_range 0 0.035))
)

; ======================================================================================
; TEST TO AWARD SKULLS =================================================================
; ======================================================================================
(script static boolean award_skull
	(if	
		(and
			(>= (game_difficulty_get_real) normal)
			(= (game_insertion_point_get) 0)
;*
			(or
				(= (campaign_is_finished_normal) TRUE)
				(= (campaign_is_finished_heroic) TRUE)
				(= (campaign_is_finished_legendary) TRUE)
			)
*;
		)
	TRUE
	FALSE
	)
)

; ======================================================================================
; TEST SCRIPTS =========================================================================
; ======================================================================================
