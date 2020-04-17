; ===============================================================================================================================================
; GLOBAL SCRIPTS ================================================================================================================================
; ===============================================================================================================================================
(global boolean b_debug_globals FALSE)

(global short player_00 0)
(global short player_01 1)
(global short player_02 2)
(global short player_03 3)

(global short s_md_play_time 0)

(script static unit player0
	(player_get 0)
)

(script static unit player1
	(player_get 1)
)

(script static unit player2
	(player_get 2)
)

(script static unit player3
	(player_get 3)
)
 
(script static short player_count
  (list_count (players)))

(script static void print_difficulty
	(cond
		((= (game_difficulty_get_real) easy)		(print "easy"))
		((= (game_difficulty_get_real) normal)		(print "normal"))
		((= (game_difficulty_get_real) heroic)		(print "heroic"))
		((= (game_difficulty_get_real) legendary)	(print "legendary"))
	)
)

; Globals 
(global string data_mine_mission_segment "")


; Difficulty level scripts 
(script static boolean difficulty_legendary
	(= (game_difficulty_get_real) legendary)
)

(script static boolean difficulty_heroic
	(= (game_difficulty_get_real) heroic)
)

(script static boolean difficulty_normal
	(<= (game_difficulty_get_real) normal)
)

(script static void replenish_players
	(if b_debug_globals (print "replenish player health..."))
	(unit_set_current_vitality player0 80 80)
	(unit_set_current_vitality player1 80 80)
	(unit_set_current_vitality player2 80 80)
	(unit_set_current_vitality player3 80 80)
)

; coop player booleans 
(script static boolean coop_players_2
	(>= (game_coop_player_count) 2)
)
(script static boolean coop_players_3
	(>= (game_coop_player_count) 3)
)
(script static boolean coop_players_4
	(>= (game_coop_player_count) 4)
)

;returns TRUE if any player is in a vehicle
(script static boolean any_players_in_vehicle
    (or
	     (unit_in_vehicle (unit player0))
	     (unit_in_vehicle (unit player1))
	     (unit_in_vehicle (unit player2))
	     (unit_in_vehicle (unit player3))
    )
)


;fades the vehicle out and then erases it
(script static void (f_vehicle_scale_destroy  (vehicle vehicle_variable))
	(object_set_scale vehicle_variable .01 (* 30 5))
	(sleep (* 30 5))
	(object_destroy vehicle_variable)
)


;for placing pelicans and falcons etc that are critial and cannot die
(script static void (f_ai_place_vehicle_deathless (ai squad))
	(ai_place squad)
	(ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) TRUE)
	(object_cannot_die (ai_vehicle_get_from_squad squad 0) TRUE)
)

(script static void (f_ai_place_vehicle_deathless_no_emp (ai squad))
	(ai_place squad)
	(ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) TRUE)
	(object_cannot_die (ai_vehicle_get_from_squad squad 0) TRUE)
	(object_ignores_emp (ai_vehicle_get_from_squad squad 0) TRUE)
)

;to get the number of ai passengers in a vehicle
(script static short (f_vehicle_rider_number (vehicle v))
	(list_count (vehicle_riders v))
)

;to determine if first squad is riding in vehicle of second squad
(script static boolean (f_all_squad_in_vehicle (ai inf_squad) (ai vehicle_squad))
	(and
		(= (ai_living_count inf_squad) 0)
		(= (ai_living_count vehicle_squad) (f_vehicle_rider_number (ai_vehicle_get_from_squad vehicle_squad 0)))
	)
)

;return the driver of a vehicle assuming only one vehicle in squad
(script static ai (f_ai_get_vehicle_driver (ai squad))
	(object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0)))
)


; call magic sight on ALL players
(script static void (f_ai_magically_see_players (ai squad))
	(ai_magically_see_object squad player0)
	(ai_magically_see_object squad player1)
	(ai_magically_see_object squad player2)
	(ai_magically_see_object squad player3)
)

; ===============================================================================================================================================
; global health script =================================================================================================================================
; ===============================================================================================================================================
(script dormant f_global_health_saves
	(sleep_until (> (player_count) 0))
	(sleep_until
		(begin
			(sleep_until (< (object_get_health player0) 1))
			(sleep (* 30 7))
			(if (< (object_get_health player0) 1)
				(begin
					(sleep_until (= (object_get_health player0) 1))
					(print "global health: health pack aquired")
					(game_save)
				)
				(print "global health: re-gen")
			)
			FALSE
		)
	)
	
)

; ===============================================================================================================================================
; Award Tourist =================================================================================================================================
; ===============================================================================================================================================
;*
(script dormant player0_award_tourist
	(f_award_tourist player_00)
)
(script dormant player1_award_tourist
	(f_award_tourist player_01)
)
(script dormant player2_award_tourist
	(f_award_tourist player_02)
)
(script dormant player3_award_tourist
	(f_award_tourist player_03)
)
*;
;*
(script static void (f_award_tourist
							(short player_short)
				)
	(sleep_until (pda_is_active_deterministic (player_get player_short)) 45)
		(sleep 30)
	
	; award the achievement for accessing the pda 
	(achievement_grant_to_player (player_get player_short) "_achievement_tourist")
)

; ===============================================================================================================================================
; Waypoint Scripts ==============================================================================================================================
; ===============================================================================================================================================
(global short s_waypoint_index 0)
(global short s_waypoint_timer (* 30 10))

(script static void (f_sleep_until_activate_waypoint
									(short player_short)
				)
		(sleep 3)
	(unit_action_test_reset (player_get player_short))
		(sleep 3)
	(sleep_until	(and
					(> (object_get_health (player_get player_short)) 0)
					(or
						(unit_action_test_dpad_up (player_get player_short))
						(unit_action_test_dpad_down (player_get player_short))
					)
				)
	1)
	(f_sfx_a_button player_short)
		(sleep 3)
)

(script static void (f_sleep_deactivate_waypoint
									(short player_short)
				)
	; sleep until dpad pressed or player dies 
		(sleep 3)
	(unit_action_test_reset (player_get player_short))
		(sleep 3)
	(sleep_until	(or
					(<= (unit_get_health (player_get player_short)) 0)
					(unit_action_test_dpad_up (player_get player_short))
					(unit_action_test_dpad_down (player_get player_short))
				)
	1 s_waypoint_timer)
	(if	(or
			(unit_action_test_dpad_up (player_get player_short))
			(unit_action_test_dpad_down (player_get player_short))
		)
		(f_sfx_a_button player_short)
	)
	(sleep 3)
)

; ===============================================================================================================================================
(script static void	(f_waypoint_message
									(short			player_short)
									(cutscene_flag		waypoint_01)
									(cutscene_title	display_title)
									(cutscene_title	blank_title)
				)
	; reset player action test 
	(unit_action_test_reset (player_get player_short))
	
	; turn on waypoints 
	(if	(not (pda_is_active_deterministic (player_get player_short)))
		(begin
			(chud_show_cinematic_title (player_get player_short) display_title)
			(sleep 15)
	
				; sleep until dpad pressed or player dies 
				(f_sleep_deactivate_waypoint player_short)
			
			; turn waypoints off 
			(chud_show_cinematic_title (player_get player_short) blank_title)
		)
		(sleep 5)
	)
)
; ===============================================================================================================================================
(script static void	(f_waypoint_activate_1
									(short			player_short)
									(cutscene_flag		waypoint_01)
				)
	; reset player action test 
	(unit_action_test_reset (player_get player_short))
	
	; turn on waypoints 
	(if (not (pda_is_active_deterministic (player_get player_short))) (chud_show_navpoint (player_get player_short) waypoint_01 .55 TRUE))
	(sleep 15)
	
		; sleep until dpad pressed or player dies 
		(f_sleep_deactivate_waypoint player_short)
	
	; turn waypoints off 
	(chud_show_navpoint (player_get player_short) waypoint_01 0 FALSE)
)
; ===============================================================================================================================================
(script static void	(f_waypoint_activate_2
									(short			player_short)
									(cutscene_flag		waypoint_01)
									(cutscene_flag		waypoint_02)
				)
	; reset player action test 
	(unit_action_test_reset (player_get player_short))
	
	; turn on waypoints 
	(if (not (pda_is_active_deterministic (player_get player_short))) 
		(begin
			(chud_show_navpoint (player_get player_short) waypoint_01 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_02 .55 TRUE)
		)
	)
	(sleep 15)
	
		; sleep until dpad pressed or player dies 
		(f_sleep_deactivate_waypoint player_short)
	
	; turn waypoints off 
	(chud_show_navpoint (player_get player_short) waypoint_01 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_02 0 FALSE)
)
; ===============================================================================================================================================
(script static void	(f_waypoint_activate_3
									(short			player_short)
									(cutscene_flag		waypoint_01)
									(cutscene_flag		waypoint_02)
									(cutscene_flag		waypoint_03)
				)
	; reset player action test 
	(unit_action_test_reset (player_get player_short))
	
	; turn on waypoints 
	(if (not (pda_is_active_deterministic (player_get player_short))) 
		(begin
			(chud_show_navpoint (player_get player_short) waypoint_01 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_02 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_03 .55 TRUE)
		)
	)
	(sleep 15)
	
		; sleep until dpad pressed or player dies 
		(f_sleep_deactivate_waypoint player_short)
	
	; turn waypoints off 
	(chud_show_navpoint (player_get player_short) waypoint_01 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_02 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_03 0 FALSE)
)
; ===============================================================================================================================================
(script static void	(f_waypoint_activate_4
									(short			player_short)
									(cutscene_flag		waypoint_01)
									(cutscene_flag		waypoint_02)
									(cutscene_flag		waypoint_03)
									(cutscene_flag		waypoint_04)
				)
	; reset player action test 
	(unit_action_test_reset (player_get player_short))
	
	; turn on waypoints 
	(if (not (pda_is_active_deterministic (player_get player_short))) 
		(begin
			(chud_show_navpoint (player_get player_short) waypoint_01 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_02 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_03 .55 TRUE)
			(chud_show_navpoint (player_get player_short) waypoint_04 .55 TRUE)
		)
	)
	(sleep 15)
	
		; sleep until dpad pressed or player dies 
		(f_sleep_deactivate_waypoint player_short)
	
	; turn waypoints off 
	(chud_show_navpoint (player_get player_short) waypoint_01 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_02 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_03 0 FALSE)
	(chud_show_navpoint (player_get player_short) waypoint_04 0 FALSE)
)
*;
; ===============================================================================================================================================
; COOP RESUME MESSAGING =========================================================================================================================
; ===============================================================================================================================================
(script static void (f_coop_resume_unlocked
									(cutscene_title	resume_title)
									(short			insertion_point)
				)
	(if (game_is_cooperative)
		(begin
			(sound_impulse_start sfx_hud_in NONE 1)
			(cinematic_set_chud_objective resume_title)
			(game_insertion_point_unlock insertion_point)
			;(sleep (* 30 7)) commented this out because it was breaking stuff! dmiller march 28/09
			;(sound_impulse_start sfx_hud_out NONE 1) commented this out temp because it was gonna sound weird!
		)
	)
)

; ===============================================================================================================================================
; NEW INTEL MESSAGING ===========================================================================================================================
; ===============================================================================================================================================
;*
(script static void (f_new_intel
							(cutscene_title	new_intel)
							(cutscene_title	intel_chapter)
							(long			objective_number)
							(cutscene_flag		minimap_flag)
				)
	(sound_impulse_start sfx_objective NONE 1)
	(chud_display_pda_objectives_message "PDA_ACTIVATE_INTEL" 0)
	
	(cinematic_set_chud_objective new_intel)
	(objectives_show objective_number)
		(sleep 60)
	(sound_impulse_start sfx_hud_in NONE 1)
	(cinematic_set_chud_objective intel_chapter)
		(sleep (* 30 3))
	(sound_impulse_start sfx_hud_out NONE 1)
	(chud_display_pda_minimap_message "" minimap_flag)
)
*;
; ===============================================================================================================================================
; Cinematic Skip Scripts ========================================================================================================================
; ===============================================================================================================================================
(script static boolean cinematic_skip_start
	(cinematic_skip_start_internal)		; Listen for the button which reverts (skips) 
	(game_save_cinematic_skip)			; Save the game state 
	(sleep_until (not (game_saving)) 1)	; Sleep until the game is done saving 
	(not (game_reverted))				; Return whether or not the game has been reverted 
)


(script static void (cinematic_skip_stop (string_id cinematic_name))
	(cinematic_skip_stop_internal)		; Stop listening for the button 
	(if (not (game_reverted)) 
		(begin
			(game_revert) ; If the player did not revert, do it for him 
			(sleep 1) ; Sleep so that the game can apply the revert
		)
	)
)

(script static void (cinematic_skip_stop_load_zone (string_id cinematic_name) (zone_set z))
	(cinematic_skip_stop_internal)		; Stop listening for the button 
	(if (not (game_reverted)) 
		(begin
			(game_revert) ; If the player did not revert, do it for him 
			(sleep 1) ; Sleep so that the game can apply the revert
		)
	)
	;(sleep 31)
	(switch_zone_set z)
	(sleep 2)
)

(script static void (cinematic_skip_stop_terminal (string_id cinematic_name))
 	(cinematic_skip_stop_internal)		; Stop listening for the button
	(if (not (game_reverted))
	 	(begin
		 	(game_revert)					; If the player did not revert, do it for him
			(sleep 1) ; We need to sleep to ensure that the game gets reverted
			(if b_debug_globals (print "sleeping forever..."))
			(sleep_forever)						; sleep forever so game_level_advance is not called twice (not sure that this ever gets called)
		)
	)
)

; ===============================================================================================================================================
; Cinematic fade black scripts ==================================================================================================================
; ===============================================================================================================================================

; -------------------------------------------------------------------------------------------------
; TIPUL'S NEW CINEMATIC SCRIPTS
; God help you all.
; -------------------------------------------------------------------------------------------------
(global boolean b_debug_cinematic_scripts true)
(global boolean b_cinematic_entered false)
; -------------------------------------------------------------------------------------------------
(script static void test_cinematic_enter_exit
	;(cinematic_enter default_fade_to_black_transitions TRUE)
	(sleep 30)
	;(cinematic_exit default_fade_to_black_transitions TRUE)
)

(script static void (cinematic_enter (string_id cinematic_name) (boolean lower_weapon))
	; setting this boolean up so that designers can call a cinematic_enter from outside of the f_play_cinematic -dmiller 6-11-2010
	(set b_cinematic_entered true)
	(cinematic_enter_pre lower_weapon)
	(sleep (cinematic_tag_fade_out_from_game cinematic_name))
	(cinematic_enter_post)
)


(script static void (designer_cinematic_enter (boolean lower_weapon))
	(cinematic_enter_pre lower_weapon)
	(sleep (cinematic_transition_fade_out_from_game cinematics\transitions\default_intra.cinematic_transition))
	(cinematic_enter_post)
)


(script static void (cinematic_enter_pre (boolean lower_weapon))
	; ai ignores players
	(ai_disregard (players) TRUE)

	; players cannot take damage 
	(object_cannot_take_damage (players))

	; scale player input to zero 
	; cgirons todo: this was (player_control_fade_out_all_input 0) for snaps check if it is a problem
	(player_control_fade_out_all_input 1)
	
	; lower the player's weapon
	(if (= lower_weapon TRUE)
		(begin 
			(if b_debug_cinematic_scripts (print "lowering weapon slowly..."))
			(unit_lower_weapon player0 30)
			(unit_lower_weapon player1 30)
			(unit_lower_weapon player2 30)
			(unit_lower_weapon player3 30)
		)
	)			
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause TRUE)

	; fade out the chud 
	; cgirons todo: this was (chud_cinematic_fade 0 0) for snaps check if it is a problem
	(chud_cinematic_fade 0 0.5)
)

(script static void cinematic_enter_post
	; hide players 
	(if b_debug_cinematic_scripts (print "hiding players..."))
	(object_hide player0 TRUE)
	(object_hide player1 TRUE)
	(object_hide player2 TRUE)
	(object_hide player3 TRUE)

	; disable player input 
	(player_enable_input FALSE)

	; player can now move 
	(player_disable_movement TRUE)
		(sleep 1)	
	
	; go time
	(if b_debug_cinematic_scripts (print "camera control on"))
	(camera_control ON)
	(cinematic_start)
)

(script static void (cinematic_exit (string_id cinematic_name) (boolean weapon_starts_lowered))
	(cinematic_exit_pre weapon_starts_lowered)
	(sleep (cinematic_tag_fade_in_to_game cinematic_name))
	(cinematic_exit_post weapon_starts_lowered)
)

(script static void (designer_cinematic_exit (boolean weapon_starts_lowered))
	(cinematic_exit_pre weapon_starts_lowered)
	(sleep (cinematic_transition_fade_in_to_game cinematics\transitions\default_intra.cinematic_transition))
	(cinematic_exit_post weapon_starts_lowered)
)

(script static void (cinematic_exit_into_title (string_id cinematic_name) (boolean weapon_starts_lowered))
	(cinematic_exit_pre weapon_starts_lowered)
	(chud_cinematic_fade 0 0)
	(sleep (cinematic_tag_fade_in_to_game cinematic_name))
	(cinematic_exit_post_title weapon_starts_lowered)
)


(script static void (cinematic_exit_pre (boolean weapon_starts_lowered))
	(cinematic_stop)
	(camera_control OFF)

	; unhide players 
	(object_hide player0 FALSE)
	(object_hide player1 FALSE)
	(object_hide player2 FALSE)
	(object_hide player3 FALSE)
	
	; raise weapon 
	(if (= weapon_starts_lowered TRUE)
		(begin
			(if b_debug_cinematic_scripts (print "snapping weapon to lowered state..."))
			(unit_lower_weapon player0 1)
			(unit_lower_weapon player1 1)
			(unit_lower_weapon player2 1)
			(unit_lower_weapon player3 1)
			(sleep 1)
		)
		
		(begin
			(unit_raise_weapon player0 1)
			(unit_raise_weapon player1 1)
			(unit_raise_weapon player2 1)
			(unit_raise_weapon player3 1)
			(sleep 1)
		)
	)
	
	; unlock the players gaze 
	(player_control_unlock_gaze player0)
	(player_control_unlock_gaze player1)
	(player_control_unlock_gaze player2)
	(player_control_unlock_gaze player3)
	(sleep 1)
)

(script static void (cinematic_exit_post (boolean weapon_starts_lowered))
	(cinematic_show_letterbox 0)
	
	; raise weapon 
	(if (= weapon_starts_lowered TRUE)
		(begin
			(if b_debug_cinematic_scripts (print "raising player weapons slowly..."))
			(unit_raise_weapon player0 30)
			(unit_raise_weapon player1 30)
			(unit_raise_weapon player2 30)
			(unit_raise_weapon player3 30)
			(sleep 10)
		)
	)
	
	; fade in the chud 
	(chud_cinematic_fade 1 1)
	(sleep 1)
		
	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) FALSE)

	; players can now take damage 
	(object_can_take_damage (players))

	; player can now move 
	(player_disable_movement FALSE)	
)

(script static void (cinematic_exit_post_title (boolean weapon_starts_lowered))
	(cinematic_show_letterbox 0)
	
	; raise weapon 
	(if (= weapon_starts_lowered TRUE)
		(begin
			(if b_debug_cinematic_scripts (print "raising player weapons slowly..."))
			(unit_raise_weapon player0 30)
			(unit_raise_weapon player1 30)
			(unit_raise_weapon player2 30)
			(unit_raise_weapon player3 30)
			(sleep 10)
		)
	)
	
	; fade in the chud 
	;(chud_cinematic_fade 1 1)
	(sleep 1)
		
	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) FALSE)

	; players can now take damage 
	(object_can_take_damage (players))

	; player can now move 
	(player_disable_movement FALSE)	
)

(script static void insertion_snap_to_black
	(fade_out 0 0 0 0)
	
	; ai ignores players
	(ai_disregard (players) TRUE)

	; players cannot take damage 
	(object_cannot_take_damage (players))

	; scale player input to zero 
	; cgirons todo: this was (player_control_fade_out_all_input 0) for snaps check if it is a problem
	(player_control_fade_out_all_input 1)
	
	; lower the player's weapon
	(unit_lower_weapon player0 0)
	(unit_lower_weapon player1 0)
	(unit_lower_weapon player2 0)
	(unit_lower_weapon player3 0)

	; pause the meta-game timer 
	(campaign_metagame_time_pause TRUE)

	; fade out the chud 
	; cgirons todo: this was (chud_cinematic_fade 0 0) for snaps check if it is a problem
	(chud_cinematic_fade 0 0)
	
	; hide players 
	(if b_debug_cinematic_scripts (print "hiding players..."))
	(object_hide player0 TRUE)
	(object_hide player1 TRUE)
	(object_hide player2 TRUE)
	(object_hide player3 TRUE)

	; disable player input 
	(player_enable_input FALSE)

	; player can now move 
	(player_disable_movement TRUE)
		(sleep 1)	
	
	; go time
	(if b_debug_cinematic_scripts (print "camera control on"))
)

(script static void insertion_fade_to_gameplay
	(designer_fade_in "fade_from_black" true))

(script static void (designer_fade_in (string fade_type) (boolean weapon_starts_lowered))
	(cinematic_stop)
	(camera_control OFF)

	; unhide players 
	(object_hide player0 FALSE)
	(object_hide player1 FALSE)
	(object_hide player2 FALSE)
	(object_hide player3 FALSE)
	
	; raise weapon 
	(if (= weapon_starts_lowered TRUE)
		(begin
			(if b_debug_cinematic_scripts (print "snapping weapon to lowered state..."))
			(unit_lower_weapon player0 1)
			(unit_lower_weapon player1 1)
			(unit_lower_weapon player2 1)
			(unit_lower_weapon player3 1)
			(sleep 1)
		)
	)
	
	; unlock the players gaze 
	(player_control_unlock_gaze player0)
	(player_control_unlock_gaze player1)
	(player_control_unlock_gaze player2)
	(player_control_unlock_gaze player3)
		(sleep 1)

	; fade or snap screen back
	(cond
		((= fade_type "fade_from_black") 	
			(begin 
				(if b_debug_cinematic_scripts (print "fading from black..."))
				(fade_in 0 0 0 30)
				(sleep 20)
			)
		)
		((= fade_type "fade_from_white") 
			(begin
				(if b_debug_cinematic_scripts (print "fading from white..."))
				(fade_in 1 1 1 30)
				(sleep 20)
			)
		)
		((= fade_type "snap_from_black") 
			
			(begin 
				(if b_debug_cinematic_scripts (print "snapping from black..."))
				(fade_in 0 0 0 5)
				(sleep 5)
			)
		)
		((= fade_type "snap_from_white") 
			(begin
				(if b_debug_cinematic_scripts (print "snapping from white..."))
				(fade_in 1 1 1 5)
				(sleep 5)
			)
		)
		((= fade_type "no_fade") 
			(begin
				(fade_in 1 1 1 0)
				(sleep 5)
			)
		)
	)


	(cinematic_show_letterbox 0)
	
	; raise weapon 
	(if (= weapon_starts_lowered TRUE)
		(begin
			(if b_debug_cinematic_scripts (print "raising player weapons slowly..."))
			(unit_raise_weapon player0 30)
			(unit_raise_weapon player1 30)
			(unit_raise_weapon player2 30)
			(unit_raise_weapon player3 30)
			(sleep 10)
		)
	)
	
	; fade in the chud 
	(chud_cinematic_fade 1 1)
	(sleep 1)
		
	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)
	
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) FALSE)

	; players can now take damage 
	(object_can_take_damage (players))

	; player can now move 
	(player_disable_movement FALSE)
)

; ======================================================================================
(script static void cinematic_snap_to_black
	(sleep 0)
	;(cinematic_enter default_snap_to_black_transitions FALSE)
)

(script static void cinematic_snap_to_white
	(sleep 0)
	;(cinematic_enter "default_snap_to_white_transitions" FALSE)
)
	
; ======================================================================================
(script static void cinematic_snap_from_black
	(sleep 0)
	;(cinematic_exit default_snap_to_black_transitions FALSE)
)

(script static void cinematic_snap_from_white
	(sleep 0)
	;(cinematic_exit default_snap_to_white_transitions FALSE)
)

; ======================================================================================
(script static void cinematic_fade_to_black
	(sleep 0)
	;(cinematic_enter default_fade_to_black_transitions TRUE)
)

(script static void cinematic_fade_to_white
	(sleep 0)
	;(cinematic_enter default_fade_to_white_transitions TRUE)
)

(script static void (cinematic_fade_to_gameplay)
	(designer_fade_in "fade_from_black" true)
)

; ===============================================================================================================================================
; CINEMATIC HUD =================================================================================================================================
; ===============================================================================================================================================
(script static void cinematic_hud_on
	(chud_cinematic_fade 1 0)
	;(chud_show_compass FALSE)
	(chud_show_crosshair FALSE)
)

(script static void cinematic_hud_off
	(chud_cinematic_fade 0 0)
	;(chud_show_compass TRUE)
	(chud_show_crosshair TRUE)
)

; ===============================================================================================================================================
; PERFORMANCES ==================================================================================================================================
; ===============================================================================================================================================

; This script is called from a thread spawned by a performance.
; Therefore all of the "performance_..." functions known which performance the function calls are intended for
; and thus we don't have to pass in a performance index.
; The default script function simply plays through all of the lines in the script, one after the other.

(script static void performance_default_script
	(sleep_until
		(begin
			(performance_play_line_by_id (+ (performance_get_last_played_line_index) 1))
		(>= (+ (performance_get_last_played_line_index) 1) (performance_get_line_count))) 0)
)


; ===============================================================================================================================================
; PDA SCRIPTS ===================================================================================================================================
; ===============================================================================================================================================

;*
(global short g_pda_breadcrumb_fade (* 30 45))
(global short g_pda_breadcrumb_timer (* 30 1.5))


(script dormant pda_breadcrumbs
	(pda_set_footprint_dead_zone 5)
	
	(sleep_until
		(begin
			(player_add_footprint player0 g_pda_breadcrumb_fade)
			(player_add_footprint player1 g_pda_breadcrumb_fade)
			(player_add_footprint player2 g_pda_breadcrumb_fade)
			(player_add_footprint player3 g_pda_breadcrumb_fade)
		FALSE)
	g_pda_breadcrumb_timer)
)
*;
		
; ===============================================================================================================================================
; END MISSION ===================================================================================================================================
; ===============================================================================================================================================
(script static void end_mission
	(game_won))

(script static void (f_start_mission
						(string_id cinematic_name)
					)
	(if (= b_cinematic_entered false) (cinematic_enter cinematic_name TRUE))
	(set b_cinematic_entered false)
	(sleep 1)
	(if (cinematic_skip_start)
		(begin
			(if b_debug_cinematic_scripts (print "f_start_mission: cinematic_skip_start is true... starting cinematic..."))
			(cinematic_show_letterbox_immediate true)
			(cinematic_run_script_by_name cinematic_name)
		)
	)	
	
	(cinematic_skip_stop cinematic_name)
)


; used for mid-mission cinematics
(script static void (f_play_cinematic_advanced
						(string_id cinematic_name)
						(zone_set cinematic_zone_set)
						(zone_set zone_to_load_when_done)
					)
	
	(if b_debug_cinematic_scripts (print "f_play_cinematic: calling cinematic_enter"))
	
	(set b_cinematic_entered false)
	
	; switch zone sets 
	(switch_zone_set cinematic_zone_set)
	(sleep 1)
		
	(if (cinematic_skip_start)
		(begin
			(if b_debug_globals (print "f_play_cinematic: playing cinematic..."))
			(cinematic_show_letterbox_immediate true)
			(cinematic_run_script_by_name cinematic_name)
		)
	)
	(cinematic_skip_stop_load_zone cinematic_name zone_to_load_when_done)	
	;(switch_zone_set zone_to_load_when_done)
		
	(if b_debug_cinematic_scripts (print "f_play_cinematic: done with cinematic. resetting audio levels..."))
)

; used for mid-mission cinematics
(script static void (f_play_cinematic_unskippable
						(string_id cinematic_name)
						(zone_set cinematic_zone_set)
					)
	
	(if b_debug_cinematic_scripts (print "f_play_cinematic: calling cinematic_enter"))

	(if (= b_cinematic_entered false) (cinematic_enter cinematic_name FALSE))
	(set b_cinematic_entered false)	
	(sleep 1)

	; switch zone sets 
	(switch_zone_set cinematic_zone_set)
	(sleep 1)
		
	(sound_suppress_ambience_update_on_revert)
	(sleep 1)

	;(if (cinematic_skip_start)
		(begin
			(if b_debug_globals (print "f_play_cinematic: playing cinematic..."))

				(cinematic_show_letterbox true)
				(sleep 30)
				(cinematic_show_letterbox_immediate true)
			
			(cinematic_run_script_by_name cinematic_name)
		)
	;)
	;(cinematic_skip_stop cinematic_name)		
)
; used for mid-mission cinematics- BACK WITH A VENGEANCE
(script static void (f_play_cinematic
						(string_id cinematic_name)
						(zone_set cinematic_zone_set)
					)
	
	(if b_debug_cinematic_scripts (print "f_play_cinematic: calling cinematic_enter"))

	(if (= b_cinematic_entered false) (cinematic_enter cinematic_name FALSE))
	(set b_cinematic_entered false)	
	(sleep 1)

	; switch zone sets 
	(switch_zone_set cinematic_zone_set)
	(sleep 1)
		
	(sound_suppress_ambience_update_on_revert)
	(sleep 1)

	(if (cinematic_skip_start)
		(begin
			(if b_debug_globals (print "f_play_cinematic: playing cinematic..."))

				(cinematic_show_letterbox true)
				(sleep 30)
				(cinematic_show_letterbox_immediate true)
			
			(cinematic_run_script_by_name cinematic_name)
		)
	)
	(cinematic_skip_stop cinematic_name)		
)

(script static void (f_end_mission
						(string_id cinematic_name)
						(zone_set cinematic_zone_set)
					)
		
	(if (= b_cinematic_entered false) (cinematic_enter cinematic_name FALSE))
	(set b_cinematic_entered false)	
	(sleep 1)
	
	(ai_erase_all)
	(garbage_collect_now)
	(switch_zone_set cinematic_zone_set)
	(sleep 1)

	; the magic
	(if (cinematic_skip_start)
		(begin
			(if b_debug_globals (print "play outro cinematic..."))

			(cinematic_show_letterbox true)
			(sleep 30)
			(cinematic_show_letterbox_immediate true)
			
			(cinematic_run_script_by_name cinematic_name)
		)
	)
	(cinematic_skip_stop_internal)
	(fade_out 0 0 0 0)
	(sleep 1)
)

(script static void (f_end_mission_ai
						(string_id cinematic_name)
						(zone_set cinematic_zone_set)
					)
		
	(if (= b_cinematic_entered false) (cinematic_enter cinematic_name FALSE))
	(set b_cinematic_entered false)	
	(sleep 1)
	
	;(ai_erase_all) in case we want to end the cinematic and manually erase ai
	(ai_disregard player0 true)
	(ai_disregard player1 true)
	(ai_disregard player2 true)
	(ai_disregard player3 true)			
	(garbage_collect_now)
	(switch_zone_set cinematic_zone_set)
	(sleep 1)

	; the magic
	(if (cinematic_skip_start)
		(begin
			(if b_debug_globals (print "play outro cinematic..."))

			(cinematic_show_letterbox true)
			(sleep 30)
			(cinematic_show_letterbox_immediate true)
			
			(cinematic_run_script_by_name cinematic_name)
		)
	)
	(cinematic_skip_stop_internal)
	(fade_out 0 0 0 0)
	(sleep 1)
)

; ===== DO NOT DELETE THIS EVER ===================
(script startup beginning_mission_segment
	(data_mine_set_mission_segment mission_start)
)





; =============================================================================================================================================== 
; MESSAGE CONFIRMATION SCRIPTS ================================================================================================================== 
; =============================================================================================================================================== 

(global sound sfx_a_button	"sound\game_sfx\ui\hud_ui\b_button")
(global sound sfx_b_button	"sound\game_sfx\ui\hud_ui\a_button")
(global sound sfx_hud_in	"sound\game_sfx\ui\hud_ui\hud_in")
(global sound sfx_hud_out	"sound\game_sfx\ui\hud_ui\hud_out")
(global sound sfx_objective	"sound\game_sfx\ui\hud_ui\mission_objective")
(global sound sfx_tutorial_complete "sound\game_sfx\ui\pda_transition.sound")


(script static void (f_sfx_a_button
								(short player_short)
				)			
	(sound_impulse_start sfx_a_button (player_get player_short) 1)
)
(script static void (f_sfx_b_button
								(short player_short)
				)			
	(sound_impulse_start sfx_b_button (player_get player_short) 1)
)
(script static void (f_sfx_hud_in
								(short player_short)
				)			
	(sound_impulse_start sfx_hud_in (player_get player_short) 1)
)
(script static void (f_sfx_hud_out
								(short player_short)
				)			
	(sound_impulse_start sfx_hud_out (player_get player_short) 1)
)
(script static void (f_sfx_hud_tutorial_complete
								(player player_to_train)
				)			
	(sound_impulse_start sfx_tutorial_complete player_to_train 1)
)




; TIMEOUT 
(script static void (f_display_message
								(short			player_short)
								(cutscene_title	display_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
)

(script static void (f_tutorial_begin
								(player 	player_to_train)
								(string_id display_title))
								
	;(chud_show_cinematic_title (player_get player_short) display_title)
	(f_hud_training_forever player_to_train display_title)
		(sleep 5)
	(unit_action_test_reset player_to_train)
		(sleep 5)
)

(script static void (f_tutorial_end
								(player player_to_train)
								)
	
	(f_sfx_hud_tutorial_complete player_to_train)
	;(chud_show_cinematic_title (player_get player_short) blank_title)
	(f_hud_training_clear player_to_train)
		(sleep 30)
)

; BOOST
(script static void (f_tutorial_boost
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep_until (unit_action_test_secondary_trigger player_variable) 1)
	(f_tutorial_end player_variable)
)

; SWITCH WEAPONS
(script static void (f_tutorial_rotate_weapons
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep_until (unit_action_test_rotate_weapons player_variable) 1)
	(f_tutorial_end player_variable)
)

; SWITCH WEAPONS
(script static void (f_tutorial_fire_weapon
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep_until (unit_action_test_primary_trigger player_variable) 1)
	(f_tutorial_end player_variable)
)


(script static void (f_tutorial_turn
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep 20)
	(sleep_until (unit_action_test_look_relative_all_directions player_variable) 1)
	(f_tutorial_end player_variable)
)

(script static void (f_tutorial_throttle
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep 20)
	(sleep_until (unit_action_test_move_relative_all_directions player_variable) 1)
	(f_tutorial_end player_variable)
)

(script static void (f_tutorial_tricks
								(player		player_variable)
								(string_id	display_title)
				)
	(f_tutorial_begin player_variable display_title)
	(sleep_until (unit_action_test_vehicle_trick_secondary player_variable) 1)
	(f_tutorial_end player_variable)
)


;*
; Accept Button 
(script static void (f_display_message_accept
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(unit_confirm_message (player_get player_short))
	(sleep_until (unit_action_test_accept (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Cancel Button 
(script static void (f_display_message_cancel
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(unit_confirm_cancel_message (player_get player_short))
	(sleep_until (unit_action_test_cancel (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Accept / Cancel Button 
(script static void (f_display_message_confirm
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(unit_confirm_message (player_get player_short))
	(unit_confirm_cancel_message (player_get player_short))
	(sleep_until	(or
					(unit_action_test_accept (player_get player_short))
					(unit_action_test_cancel (player_get player_short))
				)
	1)
	(cond
		((unit_action_test_accept (player_get player_short)) (f_sfx_a_button player_short))
		((unit_action_test_cancel (player_get player_short)) (f_sfx_b_button player_short))
	)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)
; REPEAT Training  
(script static void (f_display_repeat_training
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
								(trigger_volume	volume_01)
								(trigger_volume	volume_02)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(unit_confirm_y_button (player_get player_short))
	(unit_confirm_cancel_message (player_get player_short))
	(sleep_until	(or
					(unit_action_test_y (player_get player_short))
					(unit_action_test_cancel (player_get player_short))
					(and
						(not (volume_test_object volume_01 (player_get player_short)))
						(not (volume_test_object volume_02 (player_get player_short)))
					)
				)
	1)

	(if	(or
			(volume_test_object volume_01 (player_get player_short))
			(volume_test_object volume_02 (player_get player_short))
		)
		(begin
			(cond
				((unit_action_test_y	 (player_get player_short)) (f_sfx_a_button player_short))
				((unit_action_test_cancel (player_get player_short)) (f_sfx_b_button player_short))
			)
			(chud_show_cinematic_title (player_get player_short) blank_title)
				(sleep 5)
		)
	)
)
; Vision Button 
(script static void (f_display_message_vision
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
								(trigger_volume	volume_01)
								(trigger_volume	volume_02)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until	(or
					(unit_action_test_vision_trigger (player_get player_short))
					(and
						(not (volume_test_object volume_01 (player_get player_short)))
						(not (volume_test_object volume_02 (player_get player_short)))
					)
				)
	1)
	(if	(or
			(volume_test_object volume_01 (player_get player_short))
			(volume_test_object volume_02 (player_get player_short))
		)
		(begin
			(f_sfx_a_button player_short)
			(chud_show_cinematic_title (player_get player_short) blank_title)
				(sleep 5)
		)
	)
)


; Accept Button w/ trigger timeout 
(script static void (f_display_message_accept_volume
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
								(trigger_volume	volume_01)
								(trigger_volume	volume_02)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(unit_confirm_message (player_get player_short))
	(sleep_until	(or
					(unit_action_test_accept (player_get player_short))
					(and
						(not (volume_test_object volume_01 (player_get player_short)))
						(not (volume_test_object volume_02 (player_get player_short)))
					)
				)
	1)
	(if	(or
			(volume_test_object volume_01 (player_get player_short))
			(volume_test_object volume_02 (player_get player_short))
		)
		(begin
			(f_sfx_a_button player_short)
			(chud_show_cinematic_title (player_get player_short) blank_title)
				(sleep 5)
		)
	)
)


; A Button 
(script static void (f_display_message_a
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_accept (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; B Button 
(script static void (f_display_message_b
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_cancel (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)
; X Button 
(script static void (f_display_message_x
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_x (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Y Button 
(script static void (f_display_message_y
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_y (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; BACK Button 
(script static void (f_display_message_back
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_back (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; BACK Button 
(script static void (f_display_message_back_b
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until	(or
					(unit_action_test_back (player_get player_short))
					(unit_action_test_cancel (player_get player_short))
				)
	1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Left Bumper Button 
(script static void (f_display_message_left_bumper
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_left_shoulder (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Right Bumper Button 
(script static void (f_display_message_right_bumper
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_right_shoulder (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)
; Either Bumper Button 
(script static void (f_display_message_bumpers
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until	(or
					(unit_action_test_left_shoulder (player_get player_short))
					(unit_action_test_right_shoulder (player_get player_short))
				)
	1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Rotate Grenades Button 
(script static void (f_display_message_rotate_gren
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_rotate_grenades (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; Action Button 
(script static void (f_display_message_action
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_action (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; D-Pad UP 
(script static void (f_display_message_dpad_up
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_dpad_up (player_get player_short)) 1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; D-Pad UP -or- D-Pad DOWN 
(script static void (f_display_message_dpad_up_down
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until	(or
					(unit_action_test_dpad_up (player_get player_short))
					(unit_action_test_dpad_down (player_get player_short))
				)
	1)
	(f_sfx_a_button player_short)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; MOVE Stick 
(script static void (f_display_message_move_stick
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until (unit_action_test_move_relative_all_directions (player_get player_short)) 1)
	(f_sfx_a_button player_short)
		(sleep 150)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)

; LOOK Stick 
(script static void (f_display_message_look_stick
								(short			player_short)
								(cutscene_title	display_title)
								(cutscene_title	blank_title)
				)
	(chud_show_cinematic_title (player_get player_short) display_title)
		(sleep 5)
	(unit_action_test_reset (player_get player_short))
		(sleep 5)
	(sleep_until	(or
					(unit_action_test_look_relative_up (player_get player_short))
					(unit_action_test_look_relative_down (player_get player_short))
					(unit_action_test_look_relative_left (player_get player_short))
					(unit_action_test_look_relative_right (player_get player_short))
				)
	1)
	(f_sfx_a_button player_short)
		(sleep 150)
	(chud_show_cinematic_title (player_get player_short) blank_title)
		(sleep 5)
)
*;

; =================================================================================================
; TRAINING
; =================================================================================================
(script static void (f_hud_training (player player_num) (string_id string_hud))
	(chud_show_screen_training player_num string_hud)
	(sleep 120)
	(chud_show_screen_training player_num "")
)

(script static void (f_hud_training_forever (player player_num) (string_id string_hud))
	(chud_show_screen_training player_num string_hud)
)

(script static void (f_hud_training_clear (player player_num))
	(chud_show_screen_training player_num "")
)

(script static void f_hud_training_new_weapon
	(chud_set_static_hs_variable player0 0 1)
	(chud_set_static_hs_variable player1 0 1)
	(chud_set_static_hs_variable player2 0 1)
	(chud_set_static_hs_variable player3 0 1)
	(sleep 200)
	(chud_clear_hs_variable player0 0)
	(chud_clear_hs_variable player1 0)
	(chud_clear_hs_variable player2 0)
	(chud_clear_hs_variable player3 0)
)

(script static void (f_hud_training_new_weapon_player (player p))
	(chud_set_static_hs_variable p 0 1)
	(sleep 200)
	(chud_clear_hs_variable p 0)
)

(script static void (f_hud_training_new_weapon_player_clear (player p))
	(chud_clear_hs_variable p 0)
)

(script static void (f_hud_training_confirm (player player_num) (string_id string_hud) (string button_press))
	;kill script if there is no player
	(if (= (player_is_in_game player_num) FALSE)
		(sleep_forever)
	)
	
	(chud_show_screen_training player_num string_hud)
	(sleep 10)
	
	(player_action_test_reset)
	(sleep_until
		(cond
			((= button_press "primary_trigger") (sleep_until (unit_action_test_primary_trigger player_num)))
			((= button_press "grenade_trigger") (sleep_until (unit_action_test_grenade_trigger  player_num)))
			((= button_press "equipment") (sleep_until (unit_action_test_equipment player_num)))
			((= button_press "melee") (sleep_until (unit_action_test_melee player_num)))
			((= button_press "jump") (sleep_until (unit_action_test_jump player_num)))
			((= button_press "rotate_grenades") (sleep_until (unit_action_test_rotate_grenades player_num)))
			((= button_press "rotate_weapons") (sleep_until (unit_action_test_rotate_weapons player_num)))
			((= button_press "context_primary") (sleep_until (unit_action_test_context_primary player_num)))
			((= button_press "vision_trigger") (sleep_until (or (unit_action_test_vision_trigger player_num) (player_night_vision_on))))
			((= button_press "back") (sleep_until (unit_action_test_back player_num)))
			((= button_press "vehicle_trick") (sleep_until (unit_action_test_vehicle_trick_primary player_num)))
		)
	1 (* 30 10))
	
	(chud_show_screen_training player_num "")
)

;example:
;(f_hud_training_confirm player0 ct_training_melee "melee")




; =================================================================================================
; OBJECTIVES
; =================================================================================================
(script static void (f_hud_obj_new (string_id string_hud) (string_id string_start))
	(f_hud_start_menu_obj string_start)
	(chud_show_screen_objective string_hud)
	(sleep 160)
	(chud_show_screen_objective "")
)

(script static void (f_hud_obj_repeat (string_id string_hud))
	(chud_show_screen_objective string_hud)
	(sleep 160)
	(chud_show_screen_objective "")
)

(script static void (f_hud_start_menu_obj (string_id reference))
	(objectives_clear)
	(objectives_set_string 0 reference)
	(objectives_show_string reference) 
)


; =================================================================================================
; CHAPTER TITTES
; =================================================================================================
(script static void (f_hud_chapter (string_id string_hud))
	(chud_cinematic_fade 0 30)
	(sleep 10)
	(chud_show_screen_chapter_title string_hud)
	(chud_fade_chapter_title_for_player player0 1 30)
	(chud_fade_chapter_title_for_player player1 1 30)
	(chud_fade_chapter_title_for_player player2 1 30)
	(chud_fade_chapter_title_for_player player3 1 30)
	
	(sleep 120)
	(chud_fade_chapter_title_for_player player0 0 30)
	(chud_fade_chapter_title_for_player player1 0 30)
	(chud_fade_chapter_title_for_player player2 0 30)
	(chud_fade_chapter_title_for_player player3 0 30)
	(chud_show_screen_chapter_title "")
	
	(sleep 10)
	(chud_cinematic_fade 1 30)
)



; =================================================================================================
; Flash object
; =================================================================================================
(script static void (f_hud_flash_object_fov (object_name hud_object_highlight))
	(sleep_until
		(or
			(objects_can_see_object player0 hud_object_highlight 25)
			(objects_can_see_object player1 hud_object_highlight 25)
			(objects_can_see_object player2 hud_object_highlight 25)
			(objects_can_see_object player3 hud_object_highlight 25)
		)
	1)
	(object_create hud_object_highlight)
	(set chud_debug_highlight_object_color_red 1)
	(set chud_debug_highlight_object_color_green 1)
	(set chud_debug_highlight_object_color_blue 0)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_object (object_name hud_object_highlight))
	(object_create hud_object_highlight)
	(set chud_debug_highlight_object_color_red 1)
	(set chud_debug_highlight_object_color_green 1)
	(set chud_debug_highlight_object_color_blue 0)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(f_hud_flash_single hud_object_highlight)
	(object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_single (object_name hud_object_highlight))
	(object_hide hud_object_highlight FALSE)
	(set chud_debug_highlight_object hud_object_highlight)
	;(sound_impulse_start sound\game_sfx\ui\transition_beeps NONE 1)
	(sleep 4)
	(object_hide hud_object_highlight TRUE)
	(sleep 5)
)

(script static void (f_hud_flash_single_nodestroy (object_name hud_object_highlight))
	(set chud_debug_highlight_object hud_object_highlight)
	;(sound_impulse_start sound\game_sfx\ui\transition_beeps NONE 1)
	(sleep 4)
	(set chud_debug_highlight_object none)
	(sleep 5)
)



; =================================================================================================
; TEMP
; =================================================================================================
(global sound sfx_blip "sound\game_sfx\ui\transition_beeps")
(global object_list l_blip_list (players))
(global boolean b_blip_list_locked FALSE)
(global short s_blip_list_index 0)

; =================================================================================================
; low-level blip functions -- do not call directly!
(script static void (f_blip_internal (object obj) (short icon_disappear_time) (short final_delay))
	(chud_track_object obj true)
	(sound_impulse_start sfx_blip NONE 1)
	(sleep icon_disappear_time)
	(chud_track_object obj false)
	(sleep final_delay)
)

(script static void (f_blip_flag_internal (cutscene_flag f) (short icon_disappear_time) (short final_delay))
	(chud_track_flag f true)
	(sound_impulse_start sfx_blip NONE 1)
	(sleep icon_disappear_time)
	(chud_track_flag f false)
	(sleep final_delay)
)

; -------------------------------------------------------------------------------------------------
; BLIPS
; -------------------------------------------------------------------------------------------------
;*
0.	Neutralize
1.	Defend
2.	Ordnance
3.	Interface
4.	Recon
5.	Recover
6.	Hostile enemy
7.	Neutralize ALPHA
8.	Neutralize BRAVO
9.	Neutralize CHARLIE
*;

(global short blip_neutralize 			0)
(global short blip_defend 				1)
(global short blip_ordnance 			2)
(global short blip_interface 			3)
(global short blip_recon 				4)
(global short blip_recover 				5)
(global short blip_structure			6)
(global short blip_neutralize_alpha 	7)
(global short blip_neutralize_bravo 	8)
(global short blip_neutralize_charlie 	9)
(global short blip_ammo 				13)
(global short blip_hostile_vehicle		14)
(global short blip_hostile 				15)
(global short blip_default_a 			17)
(global short blip_default_b 			18)
(global short blip_default_c 			19)
(global short blip_default_d 			20)
(global short blip_default 				21)
(global short blip_destination			21)


; blip a cinematic flag temporarily
(script static void (f_blip_flag (cutscene_flag f) (short type))
	(chud_track_flag_with_priority f type))

; blip a cinenamtic flag forever
(script static void (f_blip_flag_forever (cutscene_flag f))
	(print "f_blip_flag_forever is going away. please use f_blip_flag")
	(f_blip_flag f blip_neutralize))

; unblip a cinematic flag
(script static void (f_unblip_flag (cutscene_flag f))
	(chud_track_flag f false))

; blip an object temporarily
(script static void (f_blip_object (object obj) (short type))
	(chud_track_object_with_priority obj type))
	
	; blip an object temporarily
(script static void (f_blip_object_offset (object obj) (short type) (short offset))
	(chud_track_object_with_priority obj type)
	(chud_track_object_set_vertical_offset obj offset))

; blip an object until you say so
(script static void (f_blip_object_forever (object obj))
	(print "f_blip_object_forever is going away. please use f_blip_object")
	(chud_track_object obj true))

; turn off a blip on an object that was blipped forever
(script static void (f_unblip_object (object obj))
	(chud_track_object obj false))

; put a blip over an object's head until dead	
(script static void (f_blip_object_until_dead (object obj))
	(chud_track_object obj true)
	(sleep_until (<= (object_get_health obj) 0))
	(chud_track_object obj false))

; blip ai actors (single or multiple)
; TODO: use local list variables when they come online
(script static void (f_blip_ai (ai group) (short blip_type))
	(sleep_until (= b_blip_list_locked FALSE) 1)
	(set b_blip_list_locked TRUE)
	(set s_blip_list_index 0)
	
	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_blip_object (list_get l_blip_list s_blip_list_index) blip_type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked FALSE)
)

; blip ai offset (single or multiple)
; TODO: use local list variables when they come online
(script static void (f_blip_ai_offset (ai group) (short blip_type) (short offset))
	(sleep_until (= b_blip_list_locked FALSE) 1)
	(set b_blip_list_locked TRUE)
	(set s_blip_list_index 0)
	
	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_blip_object_offset (list_get l_blip_list s_blip_list_index) blip_type offset))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)

	(set b_blip_list_locked FALSE)
)

; blip ai actors forever (single or multiple)
; TODO: use local list variables when they come online
(script static void (f_blip_ai_forever (ai group))
	(print "f_blip_ai_forever is going away. please use f_blip_ai")
	(f_blip_ai group 0)
)

; put a blip over someone's head until dead	
(script static void (f_blip_ai_until_dead (ai char))
	(print "f_blip_ai_until_dead will be rolled into the new f_blip_ai command. consider using that instead.")
	(f_blip_ai_forever char)
	(sleep_until (<= (object_get_health (ai_get_object char)) 0))
	(f_unblip_ai char))

(script static void (f_unblip_ai (ai group))
	(sleep_until (= b_blip_list_locked FALSE) 1)
	(set b_blip_list_locked TRUE)
	(set s_blip_list_index 0)
	
	(set l_blip_list (ai_actors group))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_unblip_object (list_get l_blip_list s_blip_list_index)))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)
	
	(set b_blip_list_locked FALSE)
)

(script static void (f_blip_title (object obj) (string_id title))
	(chud_track_object_with_priority obj 6 title)
	(sleep 120)
	(chud_track_object obj FALSE)
)

;(f_blip_weapon w_plasma_launcher_01 2 5)
(script static void (f_blip_weapon (object gun) (short dist) (short dist2))
	(sleep_until 
		(or
			(and (<= (objects_distance_to_object player0 gun) dist) (>= (objects_distance_to_object player0 gun) .1))
			(and (<= (objects_distance_to_object player1 gun) dist) (>= (objects_distance_to_object player1 gun) .1))
			(and (<= (objects_distance_to_object player2 gun) dist) (>= (objects_distance_to_object player2 gun) .1))
			(and (<= (objects_distance_to_object player3 gun) dist) (>= (objects_distance_to_object player3 gun) .1))
		)	
	1)
	(print "blip on")
	(f_blip_object gun blip_ordnance)
	(sleep_until
		(or
			(not (object_get_at_rest gun))
			 (and
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 	(>= (objects_distance_to_object player0 gun) dist2)
			 )
		)
	1)
	(print "blip off")
	(f_unblip_object gun)
)

; =================================================================================================
; SPARTAN WAYPOINT SCRIPTS
; =================================================================================================
(script static void (f_hud_spartan_waypoint (ai spartan) (string_id spartan_hud) (short max_dist))
	(sleep_until
		(begin
			(cond
				((< (objects_distance_to_object (ai_get_object spartan) player0) .95)
					(begin
						(chud_track_object spartan FALSE)
						(sleep 60)
					)
				)
				
				((> (objects_distance_to_object (ai_get_object spartan) player0) max_dist)
					(begin
						(chud_track_object spartan FALSE)
						(sleep 60)
					)
				)
				
				((< (objects_distance_to_object (ai_get_object spartan) player0) 3)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)
				
				((objects_can_see_object player0 (ai_get_object spartan) 10)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)
				
				(TRUE
					(begin
						(chud_track_object_with_priority spartan 5 "")
						;(sleep 30)
					)
				)
			)
		0)
	30)
	
)

; =================================================================================================
; CALLOUT SCRIPTS
; =================================================================================================
(script static void (f_callout_atom (object obj) (short type) (short time) (short postdelay))
	(chud_track_object_with_priority obj type)
	(sound_impulse_start sfx_blip NONE 1)
	(sleep time)
	(chud_track_object obj false)
	(sleep postdelay)
)

(script static void (f_callout_flag_atom (cutscene_flag f) (short type) (short time) (short postdelay))
	(chud_track_flag_with_priority f type)
	(sound_impulse_start sfx_blip NONE 1)
	(sleep time)
	(chud_track_flag f false)
	(sleep postdelay)
)

(script static void (f_callout_object (object obj) (short type))
	;(f_callout_atom obj type 10 2)
	;(f_callout_atom obj type 10 2)
	;(f_callout_atom obj type 10 2)
	(f_callout_atom obj type 120 2)
)

(script static void (f_callout_object_fast (object obj) (short type))
	;(f_callout_atom obj type 2 2)
	;(f_callout_atom obj type 2 2)
	(f_callout_atom obj type 20 5)
)

(script static void (f_callout_ai (ai actors) (short type))
	(sleep_until (= b_blip_list_locked FALSE) 1)
	(set b_blip_list_locked TRUE)
	
	(set l_blip_list (ai_actors actors))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_callout_object (list_get l_blip_list s_blip_list_index) type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)
	
	(set s_blip_list_index 0)
	(set b_blip_list_locked FALSE)	
)

(script static void (f_callout_ai_fast (ai actors) (short type))
	(sleep_until (= b_blip_list_locked FALSE) 1)
	(set b_blip_list_locked TRUE)
	
	(set l_blip_list (ai_actors actors))
	(sleep_until
		(begin
			(if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
				(f_callout_object_fast (list_get l_blip_list s_blip_list_index) type))
			(set s_blip_list_index (+ s_blip_list_index 1))
		(>= s_blip_list_index (list_count l_blip_list))) 1)
	
	(set s_blip_list_index 0)
	(set b_blip_list_locked FALSE)	
)


(script static void (f_callout_and_hold_flag (cutscene_flag f) (short type))
	;(f_callout_flag_atom f type 2 2)
	;(f_callout_flag_atom f type 2 2)
	(chud_track_flag_with_priority f type)
	(sound_impulse_start sfx_blip NONE 1)
	(sleep 10)
)
	
; MISSION DIALOGUE
; =================================================================================================
; Play the specified line, then delay afterwards for a specified amount of time.
; added if statement to check if character exists so we don't get into bad situations- dmiller 5/25
(script static void (f_md_ai_play (short delay) (ai character) (ai_line line))
	(set b_is_dialogue_playing TRUE)
	(if (>= (ai_living_count character) 1)
		(begin
			(set s_md_play_time (ai_play_line character line))
			(sleep s_md_play_time)
			(sleep delay)
		)
		(print "THIS ACTOR DOES NOT EXIST TO PLAY F_MD_AI_PLAY")
	)
	(set b_is_dialogue_playing FALSE)
)

; Play the specified line, then delay afterwards for a specified amount of time.
(script static void (f_md_object_play (short delay) (object obj) (ai_line line))
	(set b_is_dialogue_playing TRUE)
	(set s_md_play_time (ai_play_line_on_object obj line))
	(sleep s_md_play_time)
	(sleep delay)
	(set b_is_dialogue_playing FALSE)
)

; Play the specified line, then cutoff afterwards for a specified amount of time.
(script static void (f_md_ai_play_cutoff (short cutoff_time) (ai character) (ai_line line))
	(set b_is_dialogue_playing TRUE)
	(set s_md_play_time (- (ai_play_line character line) cutoff_time))
	(sleep s_md_play_time)
	(set b_is_dialogue_playing FALSE)
)

; Play the specified line, then cutoff afterwards for a specified amount of time.
(script static void (f_md_object_play_cutoff (short cutoff_time) (object obj) (ai_line line))
	(set b_is_dialogue_playing TRUE)
	(set s_md_play_time (- (ai_play_line_on_object obj line) cutoff_time))
	(sleep s_md_play_time)
	(set b_is_dialogue_playing FALSE)
)

; For branching scipts in dialog
(script static void f_md_abort
	(sleep s_md_play_time)
	(print "DIALOG SCRIPT ABORTED!")
	(set b_is_dialogue_playing FALSE)
	(ai_dialogue_enable TRUE)
)

(script static void (f_md_abort_no_combat_dialog)
	(f_md_abort)
	(sleep 1)
	(ai_dialogue_enable FALSE)
)


; Play the specified line, then delay afterwards for a specified amount of time.
(global boolean b_is_dialogue_playing false)
(script static void (f_md_play (short delay) (sound line))
	; (sleep_until (not b_is_dialogue_playing) 1) 			; DMiller does not want this functionality! 1.04.10
	(set b_is_dialogue_playing true)
	(set s_md_play_time (sound_impulse_language_time line)) ; DMiller added this so he can reference a time in mission scripts
	(sound_impulse_start line NONE 1)
	(sleep (sound_impulse_language_time line))
	(sleep delay)
	(set s_md_play_time 0) ; Dmiller adds this to reset the current line time, indicating the line is finished.		
	(set b_is_dialogue_playing false))

	
(script static boolean f_is_dialogue_playing
	b_is_dialogue_playing)
	
; LONGSWORDS
; =================================================================================================
; Make a longsword device activate. 
; Device Tag: sound\device_machines\040vc_longsword\start
; Flyby Sound Tag: sound\device_machines\040vc_longsword\start
; =================================================================================================
; Example: 	(f_ls_flyby my_longsword_device_machine)
;			(sound_impulse_start sound\device_machines\040vc_longsword\start NONE 1)
; =================================================================================================
;*
(script static void (f_ls_flyby (device d))
	(device_animate_position d 0 0.0 0.0 0.0 TRUE)
	(device_set_position_immediate d 0)
	(device_set_power d 0)
	(sleep 1)
	(device_set_position_track d device:position 0)
	(device_animate_position d 0.5 7.0 0.1 0.1 TRUE))
*;
; CARPETBOMBS
; =================================================================================================
; Spawn a trail of bombs across a point set.
; Effect Tag: fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large
; Count: How many points are in the set?
; Delay: Time (in ticks) between the detonation of each bomb effect
; =================================================================================================
; Example: 	(f_ls_carpetbomb pts_030 fx\my_explosion_fx 6 10)
; =================================================================================================
;*
(global short global_s_current_bomb 0)
(script static void (f_ls_carpetbomb (point_reference p) (effect e) (short count) (short delay))
	(set global_s_current_bomb 0)
	(sleep_until
		(begin
			(if b_debug_globals (print "boom..."))
			(effect_new_at_point_set_point e p global_s_current_bomb)
			(set global_s_current_bomb (+ global_s_current_bomb 1))
			(sleep delay)
		(>= global_s_current_bomb count)) 1)	
)
*;

; =================================================================================================
; HELPERS
; =================================================================================================
; Macro to see if a squad or group has ever spawned
(script static boolean (f_ai_has_spawned (ai actors))
	(> (ai_spawn_count actors) 0))
	
; Macro to see if a squad or group has ever spawned AND has no living members left
(script static boolean (f_ai_is_defeated (ai actors))
	(and
		(> (ai_spawn_count actors) 0)
		(<= (ai_living_count actors) 0)))
		
; Macro to see if a squad or group has ever spawned AND has a specified number of living members
(script static boolean (f_ai_is_partially_defeated (ai actors) (short count))
	(and
		(>= (ai_spawn_count actors) count)
		(<= (ai_living_count actors) count)))

; Macro to see if a task is empty or not
(script static boolean (f_task_is_empty (ai task))
	(<= (ai_task_count task) 0))

; Macro to see if a task has anyone in it
(script static boolean (f_task_has_actors (ai task))
	(> (ai_task_count task) 0))
	
; Macro so we can get ahold of our AI
(script static ai (f_object_get_squad (object ai_obj))
	(ai_get_squad (object_get_ai ai_obj)))


; =================================================================================================
; DEBUG RENDERING OF PATHFINDING STUFF
; =================================================================================================

(script static void debug_toggle_cookie_cutters
	(if (= debug_instanced_geometry 0)
		(begin
			(set debug_objects_collision_models 0)
			(set debug_objects_physics_models 0)
			(set debug_objects_bounding_spheres 0)
			(set debug_objects_cookie_cutters 1)
			(set debug_objects 1)

			(set debug_instanced_geometry_collision_geometry 0)
			(set debug_instanced_geometry_cookie_cutters 1)
			(set debug_instanced_geometry 1)
		)
		(begin
			(set debug_objects_cookie_cutters 0)
			(set debug_objects 0)

			(set debug_instanced_geometry_cookie_cutters 0)
			(set debug_instanced_geometry 0)
		)
	)
)

(script static void debug_toggle_pathfinding_collisions
	(if (= collision_debug 0)
		(begin
			(set collision_debug 1)
			(set collision_debug_flag_ignore_invisible_surfaces 0)
		)
		(begin
			(set collision_debug 0)
			(set collision_debug_flag_ignore_invisible_surfaces 1)
		)
	)
)

; =================================================================================================
; THESPIAN SCRIPTS
; =================================================================================================

(script static void f_branch_empty01
	(print "branch exit")
)

(script static void f_branch_empty02
	(print "branch exit")
)

(script static void f_branch_empty03
	(print "branch exit")
)
