;   Script:		Halo Mission D40
; Synopsis:		It's a big party, and everyone's invited! You vs. Everyone,
;					in the crashed Pillar of Autumn
;	  Notes: 	I use 3 space tabs--if alignment looks off, check this first

;- History ---------------------------------------------------------------------

; 07/10/01 - Initial version (Tyson)


;- Globals ---------------------------------------------------------------------

; Print useful debugging text
(global boolean debug false)

; Is it coop?
(global boolean coop false)

; Spawn wave parameters
(global real spawn_scale 1.0)				; Scales total spawn counts
(global short min_combat_spawn 2)		; Minimum number of combats in a spawn wave
(global short min_carrier_spawn 2)		; Minimum number of carriers in a spawn wave
(global short min_infection_spawn 4)	; Minimum number of infections in a spawn wave

; Magic numbers
(global short testing_fast 5)
(global short testing_very_fast 2)
(global short testing_save 5)
(global short testing_lift 10)
(global short testing_trench 10)
(global short enc5_1_wave_seperator 600)
(global short explosion_seperation 30)
(global short hud_objectives_display_time 90)
(global short trench_safe_save_time 4500)

; The timer
(global short timer_minutes 6)
(global short timer_seconds 0)

; Engine room damage controls
(global short destroyed_count 0)

; Explosion effect strings
(global effect explosion_small "effects\small explosion")
(global effect explosion_grenade "weapons\frag grenade\effects\explosion")

(global effect explosion_medium "effects\explosions\medium explosion")
(global effect explosion_medium_no "effects\explosions\medium explosion no objects")
(global effect explosion_large "effects\explosions\large explosion")
(global effect explosion_large_no "effects\explosions\large explosion no objects")
(global effect explosion_steam "effects\explosions\steam explosion")
(global effect explosion_steam_no "effects\explosions\steam explosion no objects")


;- Chapter Breaks --------------------------------------------------------------

(script static void chapter_d40_1
	; Remove control
;	(show_hud false)
;	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d40_1)
	(sleep 150)

	; Return control
;	(cinematic_show_letterbox false)
;	(show_hud true)
)

(script static void chapter_d40_2
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d40_2)
	(sleep 90)
	(cinematic_set_title chapter_d40_2b)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)

(script static void chapter_d40_3
	; Remove control
	(show_hud false)
	(cinematic_show_letterbox true)

	; Cinematic goes here!
	(sleep 30)
	(cinematic_set_title chapter_d40_3)
	(sleep 150)

	; Return control
	(cinematic_show_letterbox false)
	(show_hud true)
)

;- Mission Objectives ----------------------------------------------------------

(script static void obj_bridge
	(show_hud_help_text true)
	(hud_set_help_text obj_bridge)
	(hud_set_objective_text obj_bridge)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void obj_engineering
	(show_hud_help_text true)
	(hud_set_help_text obj_engineering)
	(hud_set_objective_text obj_engineering)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void obj_retract
	(show_hud_help_text true)
	(hud_set_help_text obj_retract)
	(hud_set_objective_text obj_retract)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void obj_frogblast
	(show_hud_help_text true)
	(hud_set_help_text obj_frogblast)
	(hud_set_objective_text obj_frogblast)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void obj_elevator
	(show_hud_help_text true)
	(hud_set_help_text obj_elevator)
	(hud_set_objective_text obj_elevator)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)

(script static void obj_escape
	(show_hud_help_text true)
	(hud_set_help_text obj_escape)
	(hud_set_objective_text obj_escape)
	(sleep hud_objectives_display_time)
	(show_hud_help_text false)
)


;- Game Save Checks ------------------------------------------------------------

; Save loop
(global boolean save_now false)
(script continuous save_loop
	(sleep_until save_now testing_save)
;	(sleep_until (game_safe_to_save) testing_save)
;	(game_save_totally_unsafe)
	(game_save_no_timeout)
	(set save_now false)
)

; Certain save subroutine
(script static void certain_save
	(set save_now true)
)


;- Vehicles --------------------------------------------------------------------

; Enc 6_5 dropship
(script static void enc6_5_dropship
	; Create, teleport, and run
	(object_create enc6_5_dropship)
	(object_teleport enc6_5_dropship enc6_5_dropship)
	(recording_play (unit enc6_5_dropship) enc6_5_dropship)

	; Sleep until it's finished, then erase it
	(sleep (recording_time enc6_5_dropship))
	(vehicle_hover enc6_5_dropship true)
	(object_set_ranged_attack_inhibited enc6_5_dropship false)
)


;- The Cinematics --------------------------------------------------------------

(global boolean timer_active false)
(script dormant endgame_cinematics
   (if (mcc_mission_segment "cines_final") (sleep 1))
   
	(if (<= (hud_get_timer_ticks) 0)
      ; Failure!
		(begin
			; End the timer
			(show_hud_timer false)
			(set timer_active false)
			(pause_hud_timer true)

         (if (mcc_mission_segment "cine5_ending_you_loose") (sleep 1))
			         
			; Run the failure cinematic
			(cinematic_time_up)
		)
		
		; Success!
		(begin 
			; End the timer
			(show_hud_timer false)
			(set timer_active false)
			(pause_hud_timer true)
			
         (if (= "impossible" (game_difficulty_get_real))
            (begin
               (if (mcc_mission_segment "cine3_legendary_ending") (sleep 1))
            )
            
            (begin
               (if (mcc_mission_segment "cine4_final") (sleep 1))
            )
         )
                  
			; Run the ending cinematic and win
			(cinematic_finale) 
			(game_won)
		)
	)
)


;- The Timer -------------------------------------------------------------------

; Get back in the jeep test
(global short time_out_of_jeep 0)
(global boolean trench_jeep_test_paused false)
(script continuous trench_jeep_test
	; Paused?
	(sleep_until (not trench_jeep_test_paused))

	; Is the player in the jeep?
	(if 
		(or
			(vehicle_test_seat_list trench_jeep1 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep2 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep3 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep4 "W-driver" (players))
			(vehicle_test_seat_list asspain_1 "W-driver" (players))
			(vehicle_test_seat_list asspain_2 "W-driver" (players))
			(vehicle_test_seat_list asspain_3 "W-driver" (players))
		)
		(set time_out_of_jeep 0)
		(set time_out_of_jeep (+ time_out_of_jeep 1))
	)
	
	; Sleep for a second
	(sleep 30)
	
	; If the time is high enough for cortana to complain?
	(if (>= time_out_of_jeep 15)
		(begin
			(set time_out_of_jeep 0)
			(D40_360_Cortana)
		)
	)
)


; Initial timer test
(script dormant timer_begin 
	; Dialog
	(if (= "impossible" (game_difficulty_get))
		(D40_320_Cortana) ; New time estimate: 5:00
		(D40_310_Cortana) ; New time estimate: 6:00	
	)

	; Set up the timer
	(hud_set_timer_position 0 0 bottom_right)
	(hud_set_timer_time timer_minutes timer_seconds)
	(hud_set_timer_warning_time 1 0)
	
	; Display the timer
	(show_hud_timer true)
	(set timer_active true)
	
	; Dialog
	(D40_330_Cortana) ; Here's a timer. 

	; Start the jeep complaint timer
	(wake trench_jeep_test)
		
	; Sleep until the timer ends, then kill shizat
	(sleep_until 
		(and
			timer_active
			(<= (hud_get_timer_ticks) 0)
		)
	)
	
	; If the timer is still active, run the cinematic
	(if timer_active (wake endgame_cinematics))
)


;- Endgame condition -----------------------------------------------------------

(script dormant endgame_cleaner
	(sleep 400)
	(object_destroy_containing "bsp_8_")
)

(script dormant test_for_endgame
	(D40_450_Cortana) ; That's the ship!
	(sleep_until (volume_test_objects grand_finale (players)) testing_trench)
	
	; Remove the endpoint
	(deactivate_team_nav_point_flag player nav_endpoint)
	
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_08")

	; Atomic weapons, scripting style, or
	; How I Learned to Love The Bomb
	(object_destroy_all)
	(object_create_containing "bsp_8_1")
	(object_create_containing "bsp_8_5")
	(object_create_containing "bsp_8_7")
	(object_create_containing "bsp_8_8")
	(wake endgame_cleaner)
	
	; Run ending cinematics
	(wake endgame_cinematics)
)


;- Section 7 -------------------------------------------------------------------

; Trench section 7_7 (hi hamish!)
(script dormant enc7_7
	(sleep_until (volume_test_objects enc7_7 (players)) testing_trench)
;	(if debug (print "enc7_7"))
	
	; Endgame testing
	(wake test_for_endgame)

	; Place the gunners, load them, and point them at the player
	(ai_place enc7_7_cov/left_gunner)
	(ai_place enc7_7_cov/right_gunner)
	(ai_try_to_fight_player enc7_7_cov/left_gunner)
	(ai_try_to_fight_player enc7_7_cov/right_gunner)
	(vehicle_load_magic enc7_7_turret_left "gunner" (ai_actors enc7_7_cov/left_gunner))
	(vehicle_load_magic enc7_7_turret_right "gunner" (ai_actors enc7_7_cov/right_gunner))

	; Run a quickie command list with them
	(ai_command_list enc7_7_cov/right_gunner enc7_7_shooting)
	(ai_command_list enc7_7_cov/left_gunner enc7_7_shooting)
			
	; Bang, sleep, bang, sleep, bang
	(effect_new explosion_large enc7_7_L1) (sleep 2)
	(effect_new explosion_large enc7_7_R1)

	(sleep_until (volume_test_objects enc7_7_2 (players)) testing_very_fast)
	(effect_new explosion_steam enc7_7_L4) (sleep 2)
	(effect_new explosion_large_no enc7_7_R4)
	
	(sleep_until (volume_test_objects enc7_7_3 (players)) testing_very_fast)
	(effect_new explosion_medium_no enc7_7_R5)
	
	(sleep_until (volume_test_objects enc7_7_4 (players)) testing_very_fast)
	(effect_new explosion_steam enc7_7_R6) (sleep 7)
	(effect_new explosion_large_no enc7_7_L6)
	
	(sleep_until (volume_test_objects enc7_7_6 (players)) testing_very_fast)
	(effect_new explosion_large_no enc7_7_L8) (sleep 5)
	(effect_new explosion_large enc7_7_R8)
	
)


; Trench section 7_1
(script dormant enc7_1
	(sleep_until (volume_test_objects enc7_1 (players)) testing_trench)
;	(if debug (print "enc7_1"))
	
	; Wakey
	(wake enc7_7)
	
	; bangbangbangbang
	(effect_new explosion_steam_no enc6_9_blast2) (sleep 18)
	(effect_new explosion_large enc6_9_blast3) (sleep 15)
	(effect_new explosion_small enc6_9_blast4) (sleep 20)
	(effect_new explosion_large_no enc6_9_blast5) (sleep 10)
	(effect_new explosion_small enc6_9_blast6) (sleep 15)
	(effect_new explosion_large enc6_9_blast7) (sleep 13)
	
	; Place the ground level guys, make them fight each other
	(ai_place enc7_7_cov/R3)
	(ai_place enc7_7_cov/R7)
	(ai_place enc7_7_flood)
	(ai_try_to_fight enc7_7_cov/R3 enc7_7_flood)
	(ai_try_to_fight enc7_7_cov/R7 enc7_7_flood)
	
	; Magical sight
	(ai_magically_see_players enc7_7_cov)
	(ai_magically_see_players enc7_7_flood)

)


; Section 7
(script dormant section7
	(sleep_until (volume_test_objects section7 (players)) testing_trench)
;	(if debug (print "section7"))
	
	; Place units
	(ai_place enc7_1_flood)
	
	; bangbangbangbang
;	(effect_new explosion_large enc6_9_blast2)
	(effect_new explosion_large enc6_9_blast8)
	
	; Wake
	(wake enc7_1)
	
	; Kill some shizat
	(ai_kill enc6_9_flood)
)


;- Section 6 -------------------------------------------------------------------
; May god have mercy on us all.

; Trench section 6_10
(script dormant enc6_10
;	(if debug (print "enc6_10"))
	
	; Place the AI
	(ai_place enc6_9_flood/infsB)
)


;--------------

; Trench section 6_9_1
(script dormant enc6_9_1
	(sleep_until (volume_test_objects enc6_9_1 (players)) 1)
;	(if debug (print "enc6_9_1"))

	; Start the music!
	(sound_looping_start "levels\d40\music\d40_09" none 1)
)

; Trench section 6_9
(script dormant enc6_9
;	(if debug (print "enc6_9"))
	
	; Wakey
	(wake enc6_9_1)
	(wake enc6_10)
	
	; Place the AI
	(ai_place enc6_9_flood/infsA)
	(ai_place enc6_9_flood/carriers)
	
	; Bang
	(effect_new explosion_large enc6_9_blast1)
	
	; Dialogue
	(D40_441_Cortana)
)


;--------------

; Ambient explosions
(script continuous enc6_8_ambients
	(begin_random
		(begin (effect_new explosion_small enc6_8_blast12) 		(sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_8_blast13) 		(sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_8_blast14) 	(sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_8_blast15) 		(sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_8_blast16) 		(sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_8_blast17) 	(sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_8_blast18) 		(sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_8_blast19) 	(sleep explosion_seperation))
		(begin (effect_new explosion_medium enc6_8_blast20) 		(sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_8_blast21) 		(sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_8_blast22) 	(sleep explosion_seperation))
		(begin (effect_new explosion_medium enc6_8_blast23) 		(sleep explosion_seperation))
	)
	(sleep 15)
)


; Trench section 6_8_8
(script dormant enc6_8_8
	(sleep_until (volume_test_objects enc6_8_8 (players)) testing_trench)
;	(if debug (print "enc6_8_8"))

	; Bang
	(effect_new explosion_large_no enc6_8_blast10)
	(effect_new explosion_large_no enc6_8_blast11)
)


; Trench section 6_8_7
(script dormant enc6_8_7
	(sleep_until (volume_test_objects enc6_8_7 (players)) testing_trench)
;	(if debug (print "enc6_8_7"))
	(wake enc6_8_8)

	; Bang
	(effect_new explosion_large enc6_8_blast9)
)


; Trench section 6_8_6
(script dormant enc6_8_6
	(sleep_until (volume_test_objects enc6_8_6 (players)) testing_trench)
;	(if debug (print "enc6_8_6"))

	; Bang
	(effect_new explosion_large_no enc6_8_blast7)
	(effect_new explosion_medium_no enc6_8_blast8)
)


; Trench section 6_8_5
(script dormant enc6_8_5
	(sleep_until (volume_test_objects enc6_8_5 (players)) testing_trench)
;	(if debug (print "enc6_8_5"))
	(wake enc6_8_6)

	; Bang
	(effect_new explosion_large_no enc6_8_blast6)
)


; Trench section 6_8_3
(script dormant enc6_8_3
	(sleep_until (volume_test_objects enc6_8_3 (players)) testing_trench)
;	(if debug (print "enc6_8_3"))
	
	; If the player goes backwards...
	(sleep_until (volume_test_objects enc6_8_6 (players)) testing_trench)
	(D40_363_Cortana)
)


; Trench section 6_8_4
(script dormant enc6_8_4
	(sleep_until (volume_test_objects enc6_8_4 (players)) testing_trench)
;	(if debug (print "enc6_8_4"))
	(wake enc6_8_5)
	
	; Bang
	(effect_new explosion_medium_no enc6_8_blast5)
	
	; Sleep 
	(sleep -1 enc6_8_3)
)


; Trench section 6_8_2
(script dormant enc6_8_2
	(sleep_until (volume_test_objects enc6_8_2 (players)) testing_trench)
;	(if debug (print "enc6_8_2"))
	(wake enc6_8_3)
	(wake enc6_8_4)
	(wake enc6_8_7)
	
	; Bang
	(effect_new explosion_medium_no enc6_8_blast3)
	(effect_new explosion_large_no enc6_8_blast4)
)


; Trench section 6_8_1
(script dormant enc6_8_1
	(sleep_until (volume_test_objects enc6_8_1 (players)) testing_trench)
;	(if debug (print "enc6_8_1"))
	(wake enc6_8_2)
	
	; Bang
	(effect_new explosion_large_no enc6_8_blast2)
)


; Section cleaner
(script static void enc6_8_cleaner
	(sleep -1 enc6_8_ambients)
	(sleep -1 enc6_8_3)
	(sleep -1 enc6_8_4)
	(sleep -1 enc6_8_5)
	(sleep -1 enc6_8_6)
)


; Trench section 6_8
(script dormant enc6_8
;	(if debug (print "enc6_8"))
	(set explosion_seperation 15)
	(wake enc6_8_ambients)
	(wake enc6_8_1)
	
	; Stop jeep warnings
	(sleep -1 trench_jeep_test)
	
	; Bang
	(effect_new explosion_small enc6_8_blast1)
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_9 (players)) testing_trench)
	(enc6_8_cleaner)
	(wake enc6_9)
)


;--------------

; Trench scene continue
(global boolean trench_scene_continued false)
(script stub void trench_scene (print "STUB trench_scene"))
(script stub void kill_trench_scene (print "STUB kill_trench_scene"))
(script static void trench_scene_continue
	; Guard against multiple calls
	(set trench_scene_continued true)

	; Kill the scene
	(kill_trench_scene)
		
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_07")
	(sound_looping_start "levels\d40\music\d40_08" none 1)

	; Dialog
	(D40_440_Cortana)
	(sleep 180)

	; Restart and show the timer!
	(set trench_jeep_test_paused false)
	(set timer_active true)
	(pause_hud_timer false)
	(show_hud_timer true)
	
	; If the player has more than 2:30 remaining, save
	(if (>= (hud_get_timer_ticks) trench_safe_save_time)
		(begin
			(game_save_cancel)	; Cancel any previous game saves
			(game_save) 			; Save game with timeout
		)
	)

	; Nav point
	(activate_team_nav_point_flag "default_red" player nav_endpoint 0)
)

; Trench section 6_7_2
(script dormant enc6_7_2
	(sleep_until (volume_test_objects enc6_7_2 (players)) testing_trench)
;	(if debug (print "enc6_7_2"))

	; Place the runners
	(ai_place enc6_8_cov)
	
	; Make the runners run
	(ai_command_list enc6_8_cov enc6_8_longrun)

	; Blam blam blam 
	(effect_new explosion_large enc6_7_blast2) 		(sleep 30)
	(effect_new explosion_steam_no enc6_7_blast3) 	(sleep 30)
	(effect_new explosion_steam_no enc6_7_blast4) 	(sleep 30)
	(effect_new explosion_medium_no enc6_7_blast5) 	(sleep 30)
	(effect_new explosion_steam enc6_7_blast6)
)


; Trench section 6_7_1
(script dormant enc6_7_1
	(sleep_until (volume_test_objects enc6_7_1 (players)) testing_trench)
;	(if debug (print "enc6_7_1"))
	(wake enc6_7_2)
	
	; Kill the trench_scene, just in case
	(if (not trench_scene_continued)
		(trench_scene_continue)
	)
)


;* Section cleaner
(script static void enc6_7_cleaner
;	(sleep -1 enc6_7_ambients)
) *;


; Trench section 6_7
(script dormant enc6_7
;	(if debug (print "enc6_7"))
	(wake enc6_7_1)
	
	; Bang
	(effect_new explosion_steam enc6_7_blast1)
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_8 (players)) testing_trench)
	(wake enc6_8)
;	(enc6_7_cleaner)
)


;--------------

; Ambient explosions
(script continuous enc6_6_ambients
;	(begin_random
;		(begin (effect_new explosion_large_no enc6_6_blast2) 	(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast3) 	(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast4))
;		(begin (effect_new explosion_large enc6_6_blast5) 		(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast6) 	(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast7))
;		(begin (effect_new explosion_large enc6_6_blast8) 		(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast9) 	(sleep explosion_seperation))
;		(begin (effect_new explosion_large_no enc6_6_blast10))
;		(begin (effect_new explosion_large_no enc6_6_blast11) (sleep explosion_seperation))
;		(begin (effect_new explosion_large enc6_6_blast12) 	(sleep explosion_seperation))
;	)
	(sleep 30) ; Just so this script has something to do, so that it compiles
)


; Trench section 6_6_1
(script dormant enc6_6_1
	(sleep_until (volume_test_objects enc6_6_1 (players)) testing_trench)
;	(if debug (print "enc6_6_1"))

	; Death of Pelican cutscene
	(deactivate_team_nav_point_flag player nav_midpoint)

	; Pause and hide the timer
	(set timer_active false)
	(show_hud_timer false)
	(pause_hud_timer true)

	; MUZAK!
	(sound_looping_set_alternate "levels\d40\music\d40_07" true)

	; Sleep a few seconds
	(set trench_jeep_test_paused true)
	(D40_370_Cortana)
	(trench_scene)
	(sleep 850 enc6_6_ambients)
	(sleep 510)

	; Continue
	(if (not trench_scene_continued)
		(trench_scene_continue)
	)
)


; Section cleaner
(script static void enc6_6_cleaner
;	(sleep -1 enc6_6_1)
	(sleep -1 enc6_6_ambients)
)


; Trench section 6_6
(script dormant enc6_6
	(sleep_until (volume_test_objects enc6_6 (players)) testing_trench)
;	(if debug (print "enc6_6"))
	(wake enc6_6_ambients)
	(wake enc6_6_1)
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_7 (players)) testing_trench)
	(wake enc6_7)
	(enc6_6_cleaner)
)


;--------------

; Ambient explosions
(script continuous enc6_5_ambients
	(begin_random
		(begin (effect_new explosion_steam_no enc6_5_blast3) (sleep 45))
		(begin (effect_new explosion_steam_no enc6_5_blast4) (sleep 45))
		(begin (effect_new explosion_steam_no enc6_5_blast5) (sleep 45))
		(begin (effect_new explosion_steam_no enc6_5_blast6) (sleep 45))
		(begin (effect_new explosion_steam_no enc6_5_blast7) (sleep 45))
		(begin (effect_new explosion_steam_no enc6_5_blast8) (sleep 45))
	)
)


; Trench section 6_5_9
(script dormant enc6_5_9
	(sleep_until (volume_test_objects enc6_5_9 (players)) testing_trench)
;	(if debug (print "enc6_5_9"))
)


; Trench section 6_5_8
(script dormant enc6_5_8
	(sleep_until (volume_test_objects enc6_5_8 (players)) testing_trench)
;	(if debug (print "enc6_5_8"))
	
	; Dialog
	(D40_380_Cortana)
	(sleep 20)
	(D40_390_Pilot)
)


; Trench section 6_5_7
(script dormant enc6_5_7
	(sleep_until (volume_test_objects enc6_5_7 (players)) testing_trench)
;	(if debug (print "enc6_5_7"))
	(wake enc6_5_8)
)


; Trench section 6_5_6
(script dormant enc6_5_6
	(sleep_until (volume_test_objects enc6_5_6 (players)) testing_trench)
;	(if debug (print "enc6_5_6"))
	(wake enc6_5_7)
	
	; Anti-bang
	(sleep -1 enc6_5_ambients)
	
	; Bang
;	(effect_new explosion_large enc6_5_blast9)
;	(effect_new explosion_large enc6_5_blast10)

	; Place em
	(ai_place enc6_5_cov/evacs1)
	(ai_place enc6_5_cov/evacs2)
	(ai_place enc6_5_cov/gunner)
;	(ai_place enc6_5_cov/gunner_grunts)
	(ai_go_to_vehicle enc6_5_cov/gunner enc6_5_turret gunner)
	
	; Dropship
	(enc6_5_dropship)
	
	; Advance
	(ai_defend enc6_5_cov/evacs)
)


; Trench section 6_5_5
(script dormant enc6_5_5
	(sleep_until (volume_test_objects enc6_5_5 (players)) testing_trench)
;	(if debug (print "enc6_5_5"))
)


; Trench section 6_5_4
(script dormant enc6_5_4
	(sleep_until (volume_test_objects enc6_5_4 (players)) testing_trench)
;	(if debug (print "enc6_5_4"))
	(wake enc6_5_5)
	(wake enc6_5_6)
	
	; Manuver
	(ai_maneuver enc6_5_cov/grunts_advance)
	
	; Bang bang.
	(wake enc6_5_ambients)
)


; Trench section 6_5_3
(script dormant enc6_5_3
	(sleep_until (volume_test_objects enc6_5_3 (players)) testing_trench)
;	(if debug (print "enc6_5_3"))
)


; Trench section 6_5_2
(script dormant enc6_5_2
	(sleep_until (volume_test_objects enc6_5_2 (players)) testing_trench)
;	(if debug (print "enc6_5_1"))
	(wake enc6_5_3)
	(wake enc6_5_4)

	; Bang
	(effect_new explosion_large enc6_5_blast2)
)


; Trench section 6_5_1
(script dormant enc6_5_1
	(sleep_until (volume_test_objects enc6_5_1 (players)) testing_trench)
;	(if debug (print "enc6_5_1"))

	; Bang
	(effect_new explosion_large enc6_5_blast1)

	; Place
	(ai_place enc6_5_flood/infsB)
)


; Section cleaner
(script static void enc6_5_cleaner
	(sleep -1 enc6_5_1)
	(sleep -1 enc6_5_3)
	(sleep -1 enc6_5_5)
	(sleep -1 enc6_5_8)
	(sleep -1 enc6_5_ambients)
	(ai_kill enc6_5_flood)
)


; Trench section 6_5
(script dormant enc6_5
;	(if debug (print "enc6_5"))
	(wake enc6_5_1)
	(wake enc6_5_2)
	
	; Turret
	(object_create_anew "enc6_5_turret")
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_6 (players)) testing_trench)
	(wake enc6_6)
	(enc6_5_cleaner)
)


;--------

; Trench section 6_4_8
(script dormant enc6_4_8
	(sleep_until (volume_test_objects enc6_4_8 (players)) testing_trench)
;	(if debug (print "enc6_4_8"))

	; Place units
	(ai_place enc6_5_cov/grunts_advance)
	(ai_place enc6_5_flood/infsA)
	
	; Fuel rod grunts
	(if 
		(or
			coop
			(= "hard" (game_difficulty_get))
			(= "impossible" (game_difficulty_get))
		)
		(begin
			(ai_place enc6_5_cov/fuel_rod_grunts)
			(ai_magically_see_players enc6_5_cov/fuel_rod_grunts)
			(ai_try_to_fight_player enc6_5_cov/fuel_rod_grunts)
		)
	)

	; Prediction
	(objects_predict enc6_5_dropship)
)


; Trench section 6_4_7
(script dormant enc6_4_7
	(sleep_until (volume_test_objects enc6_4_7 (players)) testing_trench)
;	(if debug (print "enc6_4_7"))
	(wake enc6_4_8)
	
	; Bang
	(effect_new explosion_large_no enc6_4_blast8) (sleep 15)
	(effect_new explosion_large enc6_4_blast9)
)


; Trench section 6_4_6
(script dormant enc6_4_6
	(sleep_until (volume_test_objects enc6_4_6 (players)) testing_trench)
;	(if debug (print "enc6_4_6"))
	(wake enc6_4_7)
)


; Trench section 6_4_5
(script dormant enc6_4_5
	(sleep_until (volume_test_objects enc6_4_5 (players)) testing_trench)
;	(if debug (print "enc6_4_5"))
	
	; Blam
	(effect_new explosion_medium_no enc6_4_blast6) (sleep 25)
	(effect_new explosion_large_no enc6_4_blast7)
)


; Trench section 6_4_4
(script dormant enc6_4_4
	(sleep_until (volume_test_objects enc6_4_4 (players)) testing_trench)
;	(if debug (print "enc6_4_4"))
	
	; Bang
	(effect_new explosion_steam enc6_4_blast11) (sleep 15)
	(effect_new explosion_small enc6_4_blast11)
)


; Trench section 6_4_3
(script dormant enc6_4_3
	(sleep_until (volume_test_objects enc6_4_3 (players)) testing_trench)
;	(if debug (print "enc6_4_3"))
	
	; Bang
	(effect_new explosion_steam enc6_4_blast10) (sleep 15)
	(effect_new explosion_small enc6_4_blast10)
)


; Trench section 6_4_2
(script dormant enc6_4_2
	(sleep_until (volume_test_objects enc6_4_2 (players)) testing_trench)
;	(if debug (print "enc6_4_2"))
	
	; Blam
	(effect_new explosion_medium_no enc6_4_blast4) (sleep 25)
	(effect_new explosion_large_no enc6_4_blast5)
)


; Trench section 6_4_1
(script dormant enc6_4_1
	(sleep_until (volume_test_objects enc6_4_1 (players)) testing_trench)
;	(if debug (print "enc6_4_1"))
	(wake enc6_4_2)
	(wake enc6_4_3)
	(wake enc6_4_4)
	(wake enc6_4_5)
	(wake enc6_4_6)
)


; Section cleaner
(script static void enc6_4_cleaner
	(sleep -1 enc6_4_2)
	(sleep -1 enc6_4_3)
	(sleep -1 enc6_4_4)
	(sleep -1 enc6_4_5)
	
	(sleep 150)
	(ai_kill enc6_4_flood)
)


; Trench section 6_4
(script dormant enc6_4
;	(if debug (print "enc6_4"))
	(wake enc6_4_1)

	; Blam
	(effect_new explosion_medium enc6_4_blast1)
	(effect_new explosion_grenade enc6_4_blast2)
	(effect_new explosion_large enc6_4_blast3)

	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_5 (players)) testing_trench)
	(wake enc6_5)
	(enc6_4_cleaner)
)

;------

; Trench section 6_3_4
(script dormant enc6_3_4
	(sleep_until (volume_test_objects enc6_3_4 (players)) testing_trench)
;	(if debug (print "enc6_3_4"))
	
	; Place
	(ai_place enc6_3_sents/squadC)
	(ai_place enc6_4_flood/squadA)
	(ai_place enc6_4_flood/squadB)
	(ai_place enc6_4_flood/squadC)
	(ai_place enc6_4_flood/infs)
	
	; Kill enc6_2 stuff
	(ai_kill enc6_2_sents)
	(ai_kill enc6_2_flood)
)


; Trench section 6_3_2
(script dormant enc6_3_2
	(sleep_until (volume_test_objects enc6_3_2 (players)) testing_trench)
;	(if debug (print "enc6_3_2"))
	
	; Place
	(ai_place enc6_3_flood/infsB)
	
	; Kill
	(ai_kill enc6_3_sents/squadB)
	
	; Blam
	(effect_new explosion_medium enc6_3_2_blast1)
	(effect_new explosion_medium enc6_3_2_blast2)

	; If the player goes backwards...
	(sleep_until (volume_test_objects enc6_3_2b (players)) testing_trench)
	(D40_362_Cortana)
)


; Trench section 6_3_3
(script dormant enc6_3_3
	(sleep_until (volume_test_objects enc6_3_3 (players)) testing_trench)
;	(if debug (print "enc6_3_3"))
	
	; Blam
	(effect_new explosion_large enc6_3_3_blast1)
	(sleep -1 enc6_3_2)
)


; Trench section 6_3_1
(script dormant enc6_3_1
	(sleep_until (volume_test_objects enc6_3_1 (players)) testing_trench)
;	(if debug (print "enc6_3_1"))
	(wake enc6_3_2)
	(wake enc6_3_3)
	(wake enc6_3_4)
	
	; Place
	(ai_place enc6_3_sents/squadB)
)


; Section cleaner
(script static void enc6_3_cleaner
	(sleep -1 enc6_3_2)
	(sleep -1 enc6_3_3)

	(sleep 150)
	(ai_kill enc6_3_flood)
	(ai_kill enc6_3_sents)
)


; Trench section 6_3
(script dormant enc6_3
;	(if debug (print "enc6_3"))
	(wake enc6_3_1)

	; Place
	(ai_place enc6_3_sents/squadA)
	(ai_place enc6_3_flood/combatsA)
	(ai_place enc6_3_flood/infsA)

	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_4 (players)) testing_trench)
	(wake enc6_4)
	(enc6_3_cleaner)
)

;---------

; Trench section 6_2_8
(script dormant enc6_2_8
	(sleep_until (volume_test_objects enc6_2_8 (players)) testing_trench)
;	(if debug (print "enc6_2_8"))
	
	; Place
	(ai_place enc6_2_sents/squadF)
	
	; Bang
	(effect_new explosion_steam_no enc6_2_blast3)
)


; Trench section 6_2_7
(script dormant enc6_2_7
	(sleep_until (volume_test_objects enc6_2_7 (players)) testing_trench)
;	(if debug (print "enc6_2_7"))
	
	; Place
	(ai_place enc6_2_sents/squadE)

	; Bang
	(effect_new explosion_large enc6_2_blast4)
)


; Trench section 6_2_6
(script dormant enc6_2_6
	(sleep_until (volume_test_objects enc6_2_6 (players)) testing_trench)
;	(if debug (print "enc6_2_6"))
	
	; Bang
	(effect_new explosion_large enc6_2_blast7)
)


; Trench section 6_2_5
(script dormant enc6_2_5
	(sleep_until (volume_test_objects enc6_2_5 (players)) testing_trench)
;	(if debug (print "enc6_2_5"))
	(wake enc6_2_6)
	
	; Place 
	(ai_place enc6_2_flood/infs2)
	
	; Kill
	(ai_kill enc6_2_sents/squadA)
	(ai_kill enc6_2_sents/squadB)
)


; Trench section 6_2_4
(script dormant enc6_2_4
	(sleep_until (volume_test_objects enc6_2_4 (players)) testing_trench)
;	(if debug (print "enc6_2_4"))
	
	; Place
	(ai_place enc6_2_sents/squadE)
)


; Trench section 6_2_3
(script dormant enc6_2_3
	(sleep_until (volume_test_objects enc6_2_3 (players)) testing_trench)
;	(if debug (print "enc6_2_3"))
	
	; Place
	(ai_place enc6_2_sents/squadF)
)


; Trench section 6_2_2
(script dormant enc6_2_2
	(sleep_until (volume_test_objects enc6_2_2 (players)) testing_trench)
;	(if debug (print "enc6_2_2"))
	
	; Place
	(ai_place enc6_2_sents/squadD)

	; Blast
	(effect_new explosion_medium enc6_2_blast5)
	(effect_new explosion_medium enc6_2_blast6)
)


; Trench section 6_2_1
(script dormant enc6_2_1
	(sleep_until (volume_test_objects enc6_2_1 (players)) testing_trench)
;	(if debug (print "enc6_2_1"))
	(wake enc6_2_2)
	(wake enc6_2_3)
	(wake enc6_2_4)
	(wake enc6_2_5)
	(wake enc6_2_7)
	(wake enc6_2_8)
	
	; Place
	(ai_place enc6_2_sents/squadC)
	
	; Blast
	(effect_new explosion_large_no enc6_2_1_blast1)
	(effect_new explosion_medium enc6_2_1_blast2)
)


; Trench section 6_2_0
(script dormant enc6_2_0
	(sleep_until (volume_test_objects enc6_2_0 (players)) testing_trench)
;	(if debug (print "enc6_2_0"))
	(wake enc6_2_1)
)


; Section cleaner
(script static void enc6_2_cleaner
	(sleep -1 enc6_2_2)
	(sleep -1 enc6_2_3)
	(sleep -1 enc6_2_4)
	(sleep -1 enc6_2_7)
	(sleep -1 enc6_2_8)
	
	(sleep 150)
	(ai_kill enc6_2_flood)
	(ai_kill enc6_2_sents)
)


; Trench section 6_2
(script dormant enc6_2
;	(if debug (print "enc6_2"))
	(wake enc6_2_0)
	
	; Place advance units
	(ai_place enc6_2_flood/infs)
	(ai_place enc6_2_flood/combats)
	(ai_place enc6_2_sents/squadA)
	(ai_place enc6_2_sents/squadB)
	
	; Blast
	(sleep 120)
	(effect_new explosion_large enc6_2_blast1)
	(effect_new explosion_medium_no enc6_2_blast2)
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_3 (players)) testing_trench)
	(wake enc6_3)
	(enc6_2_cleaner)
)

;--------

; Trench section 6_1_9
(script dormant enc6_1_9
	(sleep_until (volume_test_objects enc6_1_9 (players)) testing_trench)
;	(if debug (print "enc6_1_9"))
)


; Trench section 6_1_8
(script dormant enc6_1_8
	(sleep_until (volume_test_objects enc6_1_8 (players)) testing_trench)
;	(if debug (print "enc6_1_8"))
	(wake enc6_1_9)
)


; Trench section 6_1_7
(script dormant enc6_1_7
	(sleep_until (volume_test_objects enc6_1_7 (players)) testing_trench)
;	(if debug (print "enc6_1_7"))
	(wake enc6_1_8)
	
	; Boom
	(effect_new explosion_grenade enc6_1_7_blast1)
	(effect_new explosion_medium enc6_1_7_blast2)
	
	; Kill
	(ai_kill enc6_1_flood/fodder5)
)


; Trench section 6_1_6
(script dormant enc6_1_6
	(sleep_until (volume_test_objects enc6_1_6 (players)) testing_trench)
;	(if debug (print "enc6_1_6"))
	
	; Place 'n kill
	(ai_place enc6_1_flood/fodder6)
	(ai_kill enc6_1_flood/fodder1)
	(ai_kill enc6_1_flood/squadA)
	(ai_kill enc6_1_flood/squadB)
	(ai_kill enc6_1_flood/squadC)
	(ai_kill enc6_1_flood/squadD)
	
	; Fodder
	(sleep 30)
	(ai_place enc6_1_flood/fodder4)
)


; Trench section 6_1_5
(script dormant enc6_1_5
	(sleep_until (volume_test_objects enc6_1_5 (players)) testing_trench)
;	(if debug (print "enc6_1_5"))
	(wake enc6_1_6)
	(wake enc6_1_7)
)


; Trench section 6_1_4
(script dormant enc6_1_4
	(sleep_until (volume_test_objects enc6_1_4 (players)) testing_trench)
;	(if debug (print "enc6_1_4"))
	
	; Place units
	(ai_place enc6_1_flood/fodder2)
	
	; Wait, then blast
	(sleep 65)
	(effect_new explosion_medium enc6_1_4_blast1)
)


; Trench section 6_1_3
(script dormant enc6_1_3
	(sleep_until (volume_test_objects enc6_1_3 (players)) testing_trench)
;	(if debug (print "enc6_1_3"))
	(wake enc6_1_4)
	(wake enc6_1_5)
	
	; Place units
	(ai_place enc6_1_flood/fodder3)
)


; Trench section 6_1_2
(script dormant enc6_1_2
	(sleep_until (volume_test_objects enc6_1_2 (players)) testing_trench)
;	(if debug (print "enc6_1_2"))
	(wake enc6_1_3)
	
	; PLace
	(ai_place enc6_1_flood/fodder5)
	
	; Kill
	(ai_kill enc6_0_flood)
)


; Trench section 6_1_1
(script dormant enc6_1_1
	(sleep_until (volume_test_objects enc6_1_1 (players)) testing_trench)
;	(if debug (print "enc6_1_1"))
	
	; Fireworks
	(effect_new explosion_steam_no enc6_1_1_blast3)
	(effect_new explosion_steam_no enc6_1_1_blast4)
	
	; Exchange units
	(sleep 30)
	(effect_new explosion_grenade enc6_1_1_blast1)
	(effect_new explosion_grenade enc6_1_1_blast2)
	(ai_place enc6_1_flood/squadD)
)


; Ambient explosions
(script continuous enc6_1_ambients
	(begin_random
		(begin (effect_new explosion_small enc6_1_amb_blast1) (sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_1_amb_blast2) (sleep explosion_seperation))
		(begin (effect_new explosion_steam_no enc6_1_amb_blast3) (sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_1_amb_blast4) (sleep explosion_seperation))
		(begin (effect_new explosion_grenade enc6_1_amb_blast5) (sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_1_amb_blast6) (sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_1_amb_blast7) (sleep explosion_seperation))
		(begin (effect_new explosion_steam_no enc6_1_amb_blast8) (sleep explosion_seperation))
		(begin (effect_new explosion_grenade enc6_1_amb_blast9) (sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_1_amb_blast10) (sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_1_amb_blast11) (sleep explosion_seperation))
		(begin (effect_new explosion_small enc6_1_amb_blast12) (sleep explosion_seperation))
		(begin (effect_new explosion_grenade enc6_1_amb_blast13) (sleep explosion_seperation))
		(begin (effect_new explosion_medium_no enc6_1_amb_blast14) (sleep explosion_seperation))
	)
)


; Section cleaner
(script static void enc6_1_cleaner
	(sleep -1 enc6_1_1)
	(sleep -1 enc6_1_4)
	(sleep -1 enc6_1_6)
	(sleep -1 enc6_1_ambients)
	
	; Kill 'em all
	(ai_kill enc6_1_flood)
	(ai_kill enc6_0_flood)
	(ai_kill enc6_0_cov)
)


; Trench section 6_1
(script dormant enc6_1
	(sleep_until (volume_test_objects enc6_1 (players)) testing_trench)
;	(if debug (print "enc6_1"))
	
	; Set globals
	(set explosion_seperation 30)
	
	; Wake things
	(wake enc6_1_ambients)
	(wake enc6_1_1)
	(wake enc6_1_2)
	
	; Place units
	(ai_magically_see_players enc6_1_flood)
	(ai_playfight enc6_1_flood true)
	(ai_place enc6_1_flood/squadB)
	(ai_place enc6_1_flood/fodder1)
	
	; Sleep, wake, and kill optional encounters
	(sleep_until (volume_test_objects enc6_2 (players)) testing_trench)
	(wake enc6_2)
	(enc6_1_cleaner)
)

;-------

; Trench section 6_0_1
(script dormant enc6_0_1
	(sleep_until (volume_test_objects enc6_0_1 (players)) testing_trench)
;	(if debug (print "enc6_0_1"))
	(wake enc6_1)

	; Place some advance units
	(ai_place enc6_1_flood/squadA)
	(ai_place enc6_1_flood/squadC)
	
	; Start explosions
	(sleep 90)
	(effect_new explosion_steam_no enc6_0_1_blast1)
	(sleep 90)
	(effect_new explosion_small enc6_0_1_blast2)
	(sleep 15)
	(effect_new explosion_steam_no enc6_0_1_blast3)
	(sleep 45)
	(effect_new explosion_steam_no enc6_0_1_blast4)
	
	; Check if the player is in a jeep
	(if 
		(or
			(vehicle_test_seat_list trench_jeep1 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep2 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep3 "W-driver" (players))
			(vehicle_test_seat_list trench_jeep4 "W-driver" (players))
			(vehicle_test_seat_list asspain_1 "W-driver" (players))
			(vehicle_test_seat_list asspain_2 "W-driver" (players))
			(vehicle_test_seat_list asspain_3 "W-driver" (players))
		)
		(sleep 1)
		(D40_350_Cortana)
	)
)


; Trench section 6_0
(script dormant enc6_0
	(sleep_until (volume_test_objects enc6_0 (players)) testing_trench)
;	(if debug (print "enc6_0"))
	(wake enc6_0_1)
	
	; Explosions
	(effect_new explosion_medium enc6_0_blast1)	
	(effect_new explosion_grenade enc6_0_blast1)	(sleep 15)
	(effect_new explosion_grenade enc6_0_blast4)
	(effect_new explosion_grenade enc6_0_blast2)	(sleep 15)
	(effect_new explosion_grenade enc6_0_blast3)
	
	; Place the covies
	(ai_place enc6_0_cov)
	(ai_force_active enc6_0_cov true)
	
	; Place the flood, form a bond
	(ai_place enc6_0_flood)
	(ai_try_to_fight enc6_0_flood enc6_0_cov)
	(ai_magically_see_encounter enc6_0_flood enc6_0_cov)
)


; Dialog hook
(script dormant enc6_0_dialog
	(sleep_until (volume_test_objects enc6_0_dialog (players)) 1)
;	(D40_340_Cortana)
	
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_06")
	(sound_looping_start "levels\d40\music\d40_07" none 1)

	; Deactivate the lift waypoint (redundant, but catches a bug if the player 
	; runs ahead faster than cortana can finish her dialog)
	(deactivate_team_nav_point_flag player waypoint_lift)

   (mcc_mission_segment "17_escape")

	; Set the waypoint
	(obj_escape)		; Objective
	(activate_team_nav_point_flag "default_red" player nav_midpoint 0)
)


; It begins
(script dormant section6
	; Kill everything
	(sleep -1 trench_jeep_test)
	(sleep -1 enc6_1_ambients)
	(sleep -1 enc6_5_ambients)
	(sleep -1 enc6_6_ambients)
	(sleep -1 enc6_8_ambients)
	
	; Wait till the player arrives
	(sleep_until (volume_test_objects section6 (players)) testing_trench)
;	(if debug (print "section6"))

	; Deactivate the lift waypoint (redundant, but catches a bug if the player 
	; runs ahead faster than cortana can finish her dialog)
	(deactivate_team_nav_point_flag player waypoint_lift)

	(game_save_cancel)	; Cancel any previous game saves
	(game_save) ; Save game with timeout
	
   (mcc_mission_segment "16_section6")
   
	; End the alarm
	(sound_looping_stop sound\sfx\ambience\d40\engine_critical)

	; Begin the trench
	(wake enc6_0)
	(wake enc6_0_dialog)
	
	; Chapter title
	(chapter_d40_3)
)


;- Manifold Controls -----------------------------------------------------------

; Manifold globals
(global boolean manifold_n1_destroyed false)
(global boolean manifold_n3_destroyed false)
(global boolean manifold_s1_destroyed false)
(global boolean manifold_s3_destroyed false)

; Manifold closers
(script static void close_manifold_n1
	; If the manifold is not destroyed
	(if (not manifold_n1_destroyed)
	(begin
		; Close the manifold
		(device_set_position enc5_1_pistonN1 0)
		
		; Sound alarm
		(if (!= (device_get_position enc5_1_pistonn1) 0)
			(print "PLACEHOLDER: Alarm sound CLOSE_N1")
		)
	)
	)
)
(script static void close_manifold_n3
	; If the manifold is not destroyed
	(if (not manifold_n3_destroyed)
	(begin
		; Close the manifold
		(device_set_position enc5_1_pistonN3 0)
		
		; Sound alarm
		(if (!= (device_get_position enc5_1_pistonn3) 0)
			(print "PLACEHOLDER: Alarm sound CLOSE_N3")
		)
	)
	)
)
(script static void close_manifold_s1
	; If the manifold is not destroyed
	(if (not manifold_s1_destroyed)
	(begin
		; Close the manifold
		(device_set_position enc5_1_pistonS1 0)
		
		; Sound alarm
		(if (!= (device_get_position enc5_1_pistons1) 0)
			(print "PLACEHOLDER: Alarm sound CLOSE_S1")
		)
	)
	)
)
(script static void close_manifold_s3
	; If the manifold is not destroyed
	(if (not manifold_s3_destroyed)
	(begin
		; Close the manifold
		(device_set_position enc5_1_pistonS3 0)
		
		; Sound alarm
		(if (!= (device_get_position enc5_1_pistons3) 0)
			(print "PLACEHOLDER: Alarm sound CLOSE_S3")
		)
	)
	)
)


; Manifold openers
(script static void open_manifold_n1
	; Disable the control
	(device_set_power enc5_1_controln1 0)
	
	; Sound alarm
	(sound_impulse_start sound\sfx\ambience\d40\oven_door_alarm enc5_1_controln1 1)
	
	; Set the signal lights
	(device_set_power enc5_1_siglight_n11 1)
	(device_set_power enc5_1_siglight_n12 1)
	(device_set_position_immediate enc5_1_siglight_n11 1) ; Yellow
	(device_set_position_immediate enc5_1_siglight_n12 1)	; Yellow
	
	; Close all other manifolds
	(close_manifold_n3)
	(close_manifold_s1)
	(close_manifold_s3)
)
(script static void open_manifold_n3
	; Disable the control
	(device_set_power enc5_1_controln3 0)
	
	; Sound alarm
	(sound_impulse_start sound\sfx\ambience\d40\oven_door_alarm enc5_1_controln3 1)
	
	; Set the signal lights
	(device_set_power enc5_1_siglight_n31 1)
	(device_set_power enc5_1_siglight_n32 1)
	(device_set_position_immediate enc5_1_siglight_n31 1) ; Yellow
	(device_set_position_immediate enc5_1_siglight_n32 1)	; Yellow
	
	; Close all other manifolds
	(close_manifold_n1)
	(close_manifold_s1)
	(close_manifold_s3)
)
(script static void open_manifold_s1
	; Disable the control
	(device_set_power enc5_1_controls1 0)
	
	; Sound alarm
	(sound_impulse_start sound\sfx\ambience\d40\oven_door_alarm enc5_1_controls1 1)
	
	; Set the signal lights
	(device_set_power enc5_1_siglight_s11 1)
	(device_set_power enc5_1_siglight_s12 1)
	(device_set_position_immediate enc5_1_siglight_s11 1) ; Yellow
	(device_set_position_immediate enc5_1_siglight_s12 1)	; Yellow
	
	; Close all other manifolds
	(close_manifold_n3)
	(close_manifold_n1)
	(close_manifold_s3)
)
(script static void open_manifold_s3
	; Disable the control
	(device_set_power enc5_1_controls3 0)
	
	; Sound alarm
	(sound_impulse_start sound\sfx\ambience\d40\oven_door_alarm enc5_1_controls3 1)
	
	; Set the signal lights
	(device_set_power enc5_1_siglight_s31 1)
	(device_set_power enc5_1_siglight_s32 1)
	(device_set_position_immediate enc5_1_siglight_s31 1) ; Yellow
	(device_set_position_immediate enc5_1_siglight_s32 1)	; Yellow
	
	; Close all other manifolds
	(close_manifold_n1)
	(close_manifold_s1)
	(close_manifold_n3)
)

; Place waypoints on the engine manifolds
(script static void enc5_1_mark_manifolds
	; Hide any control waypoints
	(deactivate_team_nav_point_flag player nav_cntrl_n1)
	(deactivate_team_nav_point_flag player nav_cntrl_n3)
	(deactivate_team_nav_point_flag player nav_cntrl_s1)
	(deactivate_team_nav_point_flag player nav_cntrl_s3)
	
	; Reveal any valid manifold waypoints
	(if 
		(and
			(not manifold_n1_destroyed)
			(> (device_get_position enc5_1_pistonn1) 0)
		)
		(activate_team_nav_point_flag "default_red" player enc5_1_manifold_n1 0)
		(deactivate_team_nav_point_flag player enc5_1_manifold_n1)
	)
	(if 
		(and
			(not manifold_n3_destroyed)
			(> (device_get_position enc5_1_pistonn3) 0)
		)
		(activate_team_nav_point_flag "default_red" player enc5_1_manifold_n3 0)
		(deactivate_team_nav_point_flag player enc5_1_manifold_n3)
	)
	(if 
		(and
			(not manifold_s1_destroyed)
			(> (device_get_position enc5_1_pistons1) 0)
		)
		(activate_team_nav_point_flag "default_red" player enc5_1_manifold_s1 0)
		(deactivate_team_nav_point_flag player enc5_1_manifold_s1)
	)
	(if 
		(and
			(not manifold_s3_destroyed)
			(> (device_get_position enc5_1_pistons3) 0)
		)
		(activate_team_nav_point_flag "default_red" player enc5_1_manifold_s3 0)
		(deactivate_team_nav_point_flag player enc5_1_manifold_s3)
	)
)

; Mark valid control panels
(script static void enc5_1_mark_controls
	; Hide any manifold waypoints
	(deactivate_team_nav_point_flag player enc5_1_manifold_n1)
	(deactivate_team_nav_point_flag player enc5_1_manifold_n3)
	(deactivate_team_nav_point_flag player enc5_1_manifold_s1)
	(deactivate_team_nav_point_flag player enc5_1_manifold_s3)

	; If the device has power, mark it
	(if (= (device_get_power enc5_1_controln1) 1)
		(activate_team_nav_point_flag "default_red" player nav_cntrl_n1 .4)
		(deactivate_team_nav_point_flag player nav_cntrl_n1)	
	)
	(if (= (device_get_power enc5_1_controln3) 1)
		(activate_team_nav_point_flag "default_red" player nav_cntrl_n3 .4)
		(deactivate_team_nav_point_flag player nav_cntrl_n3)	
	)
	(if (= (device_get_power enc5_1_controls1) 1)
		(activate_team_nav_point_flag "default_red" player nav_cntrl_s1 .4)
		(deactivate_team_nav_point_flag player nav_cntrl_s1)	
	)
	(if (= (device_get_power enc5_1_controls3) 1)
		(activate_team_nav_point_flag "default_red" player nav_cntrl_s3 .4)
		(deactivate_team_nav_point_flag player nav_cntrl_s3)	
	)
)

; Waypoint control
(global boolean controls_marked false)
(script static void enc5_1_waypoint_control
	; Are any of the manifolds open?
	(if 
		(or
			(> (device_get_position enc5_1_pistonn1) 0)
			(> (device_get_position enc5_1_pistonn3) 0)
			(> (device_get_position enc5_1_pistons1) 0)
			(> (device_get_position enc5_1_pistons3) 0)
			(> (device_get_position enc5_1_pistonn2) 0) ; This piston causes the process to halt--take note!
		)
		; Switch waypoints to it. Otherwise, mark the control panels
		(begin
			(if controls_marked (obj_frogblast))
			(enc5_1_mark_manifolds)
			(set controls_marked false)
		)
		(begin
			(if (not controls_marked) (obj_retract))
			(enc5_1_mark_controls)
			(set controls_marked true)
		)
	)
)


; Control polling script
(script static void enc5_1_control_poll
	; North 1
	(if 
		(and 
			(not manifold_n1_destroyed)
			(= (device_get_position enc5_1_pistonn1) 0) 
		)
		; If the manifold is closed and not destroyed, enable the control, turn off lights
		(begin
			(device_set_power enc5_1_controln1 1) 

			; Set the signal lights
			(device_set_power enc5_1_siglight_n11 0)
			(device_set_power enc5_1_siglight_n12 0)
			(device_set_position_immediate enc5_1_siglight_n11 1) ; Yellow
			(device_set_position_immediate enc5_1_siglight_n12 1)	; Yellow
		)
		; Otherwise, if the manifold is not destroyed and not closed, trigger 
		; scripts to correspond with the manifold being open
		(if 
			(and 
				(not manifold_n1_destroyed)
				(= (device_get_power enc5_1_controln1) 1)
			)
			; Set the power to 1 and do opening stuff
			(open_manifold_n1)
		)
	)

	; North 3
	(if 
		(and 
			(not manifold_n3_destroyed)
			(= (device_get_position enc5_1_pistonn3) 0) 
		)
		; If the manifold is closed and not destroyed, enable the control, turn off lights
		(begin
			(device_set_power enc5_1_controln3 1) 

			; Set the signal lights
			(device_set_power enc5_1_siglight_n31 0)
			(device_set_power enc5_1_siglight_n32 0)
			(device_set_position_immediate enc5_1_siglight_n31 1) ; Yellow
			(device_set_position_immediate enc5_1_siglight_n32 1)	; Yellow
		)
		; Otherwise, if the manifold is not destroyed and not closed, trigger 
		; scripts to correspond with the manifold being open
		(if 
			(and 
				(not manifold_n3_destroyed)
				(= (device_get_power enc5_1_controln3) 1)
			)
			; Set the power to 1 and do opening stuff
			(open_manifold_n3)
		)
	)

	; South 1
	(if 
		(and 
			(not manifold_s1_destroyed)
			(= (device_get_position enc5_1_pistons1) 0) 
		)
		; If the manifold is closed and not destroyed, enable the control, turn off lights
		(begin
			(device_set_power enc5_1_controls1 1) 

			; Set the signal lights
			(device_set_power enc5_1_siglight_s11 0)
			(device_set_power enc5_1_siglight_s12 0)
			(device_set_position_immediate enc5_1_siglight_s11 1) ; Yellow
			(device_set_position_immediate enc5_1_siglight_s12 1)	; Yellow
		)
		; Otherwise, if the manifold is not destroyed and not closed, trigger 
		; scripts to correspond with the manifold being open
		(if 
			(and 
				(not manifold_s1_destroyed)
				(= (device_get_power enc5_1_controls1) 1)
			)
			; Set the power to 1 and do opening stuff
			(open_manifold_s1)
		)
	)

	; South 3
	(if 
		(and 
			(not manifold_s3_destroyed)
			(= (device_get_position enc5_1_pistons3) 0) 
		)
		; If the manifold is closed and not destroyed, enable the control, turn off lights
		(begin
			(device_set_power enc5_1_controls3 1) 

			; Set the signal lights
			(device_set_power enc5_1_siglight_s31 0)
			(device_set_power enc5_1_siglight_s32 0)
			(device_set_position_immediate enc5_1_siglight_s31 1) ; Yellow
			(device_set_position_immediate enc5_1_siglight_s32 1)	; Yellow
		)
		; Otherwise, if the manifold is not destroyed and not closed, trigger 
		; scripts to correspond with the manifold being open
		(if 
			(and 
				(not manifold_s3_destroyed)
				(= (device_get_power enc5_1_controls3) 1)
			)
			; Set the power to 1 and do opening stuff
			(open_manifold_s3)
		)
	)
)

; Side saving threads
(script dormant manifold_n1_save
	(sleep_until 
		(and
			(<= (device_get_position enc5_1_pistonN1) 0)
			(not (volume_test_objects enc5_1_oven_n1 (players)))
		)
	)
	(certain_save)
)
(script dormant manifold_n3_save
	(sleep_until 
		(and
			(<= (device_get_position enc5_1_pistonN3) 0)
			(not (volume_test_objects enc5_1_oven_n3 (players)))
		)
	)
	(certain_save)
)
(script dormant manifold_s1_save
	(sleep_until 
		(and
			(<= (device_get_position enc5_1_pistonS1) 0)
			(not (volume_test_objects enc5_1_oven_s1 (players)))
		)
	)
	(certain_save)
)
(script dormant manifold_s3_save
	(sleep_until 
		(and
			(<= (device_get_position enc5_1_pistonS3) 0)
			(not (volume_test_objects enc5_1_oven_s3 (players)))
		)
	)
	(certain_save)
)


; N1 Destroyed
(script static void destroy_manifold_n1
	; Save, debug
	(game_save_cancel)
	(wake manifold_n1_save)
	(sound_impulse_start sound\sfx\ambience\d40\reactor_destroyed enc5_1_controln1 1)

	; Set the signal lights
	(device_set_power enc5_1_siglight_n11 1)
	(device_set_power enc5_1_siglight_n12 1)
	(device_set_position_immediate enc5_1_siglight_n11 0) ; Red
	(device_set_position_immediate enc5_1_siglight_n12 0)	; Red

	(set manifold_n1_destroyed true)
	(set destroyed_count (+ 1 destroyed_count))
;	(device_set_position enc5_1_louvre_n1 0)
	(device_set_position enc5_1_pistonN1 0)
	(effect_new explosion_large enc5_1_manifold_n1)
	(object_create enc5_1_fire_n2)
)
; N3 Destroyed
(script static void destroy_manifold_n3
	; Save, debug
	(game_save_cancel)
	(wake manifold_n3_save)
	(sound_impulse_start sound\sfx\ambience\d40\reactor_destroyed enc5_1_controln3 1)

	; Set the signal lights
	(device_set_power enc5_1_siglight_n31 1)
	(device_set_power enc5_1_siglight_n32 1)
	(device_set_position_immediate enc5_1_siglight_n31 0) ; Red
	(device_set_position_immediate enc5_1_siglight_n32 0)	; Red

	(set manifold_n3_destroyed true)
	(set destroyed_count (+ 1 destroyed_count))
;	(device_set_position enc5_1_louvre_n3 0)
	(device_set_position enc5_1_pistonN3 0)
	(effect_new explosion_large enc5_1_manifold_n3)
	(object_create enc5_1_damage_flame1)
	(object_create enc5_1_damage_flame2)
	(object_create enc5_1_damage_flame3)
)
; S1 Destroyed
(script static void destroy_manifold_s1
	; Save, debug
	(game_save_cancel)
	(wake manifold_s1_save)
	(sound_impulse_start sound\sfx\ambience\d40\reactor_destroyed enc5_1_controls1 1)

	; Set the signal lights
	(device_set_power enc5_1_siglight_s11 1)
	(device_set_power enc5_1_siglight_s12 1)
	(device_set_position_immediate enc5_1_siglight_s11 0) ; Red
	(device_set_position_immediate enc5_1_siglight_s12 0)	; Red

	(set manifold_s1_destroyed true)
	(set destroyed_count (+ 1 destroyed_count))
;	(device_set_position enc5_1_louvre_s1 0)
	(device_set_position enc5_1_pistonS1 0)
	(effect_new explosion_large enc5_1_manifold_s1)
	(object_create enc5_1_damage_flame4)
	(object_create enc5_1_fire_s1)
)
; S3 Destroyed
(script static void destroy_manifold_s3
	; Save, debug
	(game_save_cancel)
	(wake manifold_s3_save)
	(sound_impulse_start sound\sfx\ambience\d40\reactor_destroyed enc5_1_controls3 1)

	; Set the signal lights
	(device_set_power enc5_1_siglight_s31 1)
	(device_set_power enc5_1_siglight_s32 1)
	(device_set_position_immediate enc5_1_siglight_s31 0) ; Red
	(device_set_position_immediate enc5_1_siglight_s32 0)	; Red

	(set manifold_s3_destroyed true)
	(set destroyed_count (+ 1 destroyed_count))
;	(device_set_position enc5_1_louvre_s3 0)
	(device_set_position enc5_1_pistonS3 0)
	(effect_new explosion_large enc5_1_manifold_s3)
)
; All destroyed
(global boolean manifold_all_destroyed false)
(script static void all_manifolds_destroyed
	; Alarm sound
	(sound_looping_start sound\sfx\ambience\d40\engine_critical invisible_alarm 1)
	
	; Do dat thang
	(set manifold_all_destroyed true)	
	(device_set_position enc5_1_pistonN2 .75)
	(device_set_position enc5_1_pistonS2 .75)
	(object_create enc5_1_louv_fire_s2)
	(object_create enc5_1_louv_fire_n2)
	(object_create enc5_1_damage_flame5)
	
	; Snap backtracking door shut, clean up anything that can be cleaned
	(device_set_position_immediate bsp4_cutoff .5)
)


; Damage polling script
(script static void enc5_1_destroyed_poll
	; North 1
	(if 
		(and
			(not manifold_n1_destroyed)
			(or
				(<= (unit_get_health enc5_1_detector_n1) .1)
				(<= (unit_get_health enc5_1_detector_n1b) .1)
			)
		)
		; Destroyed
		(destroy_manifold_n1)
	)

	; North 3
	(if 
		(and
			(not manifold_n3_destroyed)
			(or
				(<= (unit_get_health enc5_1_detector_n3) .1)
				(<= (unit_get_health enc5_1_detector_n3b) .1)
			)
		)
		; Destroyed
		(destroy_manifold_n3)
	)

	; South 1
	(if 
		(and
			(not manifold_s1_destroyed)
			(or
				(<= (unit_get_health enc5_1_detector_s1) .1)
				(<= (unit_get_health enc5_1_detector_s1b) .1)
			)
		)
		; Destroyed
		(destroy_manifold_s1)
	)

	; South 3
	(if 
		(and
			(not manifold_s3_destroyed)
			(or
				(<= (unit_get_health enc5_1_detector_s3) .1)
				(<= (unit_get_health enc5_1_detector_s3b) .1)
			)
		)
		; Destroyed
		(destroy_manifold_s3)
	)
	
	; All destroyed?
	(if
		(and
			manifold_n1_destroyed
			manifold_n3_destroyed
			manifold_s1_destroyed
			manifold_s3_destroyed
			(not manifold_all_destroyed)
		)
		; Fin!
		(all_manifolds_destroyed)
	)
)


;- Section 5 Encounters --------------------------------------------------------

;* 	Area:		Section 5
  	 Begins:		At fourth BSP transition
  	   Ends:		At fifth BSP transition

  Synopsis:		- 

	 Issues:		- Framerates. Big environment + lots of units = BLAM
	 				- Units getting stuck moving from section to section

 Hierarchy:		-> MISSION START
 						-> section2 (immediate)
 							-> enc2_1 (trigger volume)
 								-> enc2_2 (trigger volume)
 									-> enc2_4 (trigger volume + unit count)
 									-> enc2_5 (trigger volume)
 										-> enc2_6 (trigger volume)
 											-> enc2_7 (trigger volume)							
*;

; Scripty  thingie
(script static void hack_thingie_for_jason
	(switch_bsp 5)
	(volume_teleport_players_not_inside null_volume s6)
	(wake enc6_0)
)

; Enc 5_3 dialog hooks
(script dormant enc5_3_dialog
	(sleep_until (>= (device_get_position elevator) 0.1) testing_lift)
	(D40_230_Cortana) ; Foehammer, you there?
	(D40_240_Pilot)	; Wazzup?
	(D40_250_Cortana) ; We need a lift
	(D40_260_Pilot) 	; Word, yo.

	(sleep_until (>= (device_get_position elevator) 0.6) testing_lift)
	(D40_270_Pilot)	; Yo homeboy, what was that?
	(D40_280_Cortana)	; Bad shiznat.

	; Wake the timer
	(wake timer_begin)
)


; Enc 5_3
(script dormant enc5_3
	; Sleep
	(sleep_until (volume_test_objects_all enc5_3 (players)))
	
	; Close the door, and sleep until it's fully closed
	(device_set_position elevator_door 0)
	
	; Slip the biped blocker in
	(object_create elevator_blocker)
	
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_05")
	(sound_looping_start "levels\d40\music\d40_06" none 1)

	; Begin the ride up
	(sleep_until (<= (device_get_position elevator_door) 0.45))
	
	; Trigger some nasty explosions in the room
	(effect_new explosion_large_no prelift1) 	(sleep 5)
	(effect_new explosion_medium_no prelift2)	(sleep 5)
	(effect_new explosion_medium_no prelift3)	
	(effect_new explosion_large_no prelift4)	(sleep 5)
	(effect_new explosion_large_no prelift5)	(sleep 5)
	(effect_new explosion_large_no waypoint_lift)

	; Test for players not on the lift. Kill teh fukrz
	(if (volume_test_objects prelift_slayer (list_get (players) 0))
		(damage_object "effects\damage effects\guaranteed explosion of doom" (list_get (players) 0))
	)
	; Kill player two if necessary
	(if (and coop (volume_test_objects enc5_1_oven_n1 (list_get (players) 1)))
		(damage_object "effects\damage effects\guaranteed explosion of doom" (list_get (players) 1))
	)
	
	; Start the elevator moving
	(sleep 30)
	(device_set_position elevator 1)

	; Start the timer
	(wake enc5_3_dialog)
	
	; Hey, do some object prediction while we're at it
	(objects_predict trench_jeep1)
	
	; Sleep for checkpoints
	(sleep_until (>= (device_get_position elevator) 0.1) testing_lift)
	(effect_new explosion_large_no enc5_3_000) (sleep 15)
	(effect_new explosion_large_no enc5_3_380)
	(sleep_until (>= (device_get_position elevator) 0.2) testing_lift)
	(effect_new explosion_large_no enc5_3_120) (sleep 15)
	(effect_new explosion_large_no enc5_3_505)
	(sleep_until (>= (device_get_position elevator) 0.3) testing_lift)
	(effect_new explosion_large_no enc5_3_295) (sleep 15)
	(effect_new explosion_large_no enc5_3_605)
	(sleep_until (>= (device_get_position elevator) 0.4) testing_lift)
	(effect_new explosion_large_no enc5_3_385) (sleep 15)
	(effect_new explosion_large_no enc5_3_380)
	(sleep_until (>= (device_get_position elevator) 0.5) testing_lift)
	(effect_new explosion_large_no enc5_3_605) (sleep 15)
	(effect_new explosion_large_no enc5_3_930)
	(sleep_until (>= (device_get_position elevator) 0.6) testing_lift)
	(effect_new explosion_large_no enc5_3_930) (sleep 15)
	(effect_new explosion_large_no enc5_3_1200)
	(sleep_until (>= (device_get_position elevator) 0.7) testing_lift)
	(effect_new explosion_steam_no enc5_3_1200) (sleep 15)
	(effect_new explosion_large enc5_3_1630)
	(sleep_until (>= (device_get_position elevator) 0.8) testing_lift)
	(effect_new explosion_large_no enc5_3_1480) (sleep 15)
	(effect_new explosion_large_no enc5_3_1812)
	(sleep_until (>= (device_get_position elevator) 0.9) testing_lift)
	(effect_new explosion_large_no enc5_3_1740) (sleep 15)
	(effect_new explosion_large_no enc5_3_2090)
	(sleep_until (>= (device_get_position elevator) 1.0) testing_lift)
	(effect_new explosion_large_no enc5_3_2180) (sleep 15)
	(effect_new explosion_large enc5_3_2350)
;	(hack_thingie_for_jason)
)


; Enc 5_2
(script dormant enc5_2
	; Sleep
	(sleep_until manifold_all_destroyed)
	(sleep_until (volume_test_objects enc5_2 (players)))
	(certain_save)
	
	; Wakey!
	(wake enc5_3)
	
	; Sleep for a moment, then bang
	(sleep 30)
	(effect_new explosion_large enc5_2_door)
	(object_create enc5_2_fire1)
	(object_create enc5_2_fire2)
	
	; Open the door
	(sleep 10)
	(device_set_position_immediate enc5_2_door 1)
	
	; Deactivate the lift waypoint
	(deactivate_team_nav_point_flag player waypoint_lift)
	
	; Position the lift, place the covies, lower the lift
	(ai_place enc5_2_cov/elevator_squad)
	(device_set_position_immediate elevator .1)
	(sleep 30)
	(device_set_position elevator 0)
)


; Damage players inside the manifolds
(script static void enc5_1_manifold_ovens
	; Is the manifold closed?
	(if (= 0 (device_get_position enc5_1_pistonN1))
		; Are either players inside?
		(begin
			; Cook player one if necessary
			(if (volume_test_objects enc5_1_oven_n1 (list_get (players) 0))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 0))
			)
			; Cook player two if necessary
			(if (and coop (volume_test_objects enc5_1_oven_n1 (list_get (players) 1)))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 1))
			)
		)
	)

	; Is the manifold closed?
	(if (= 0 (device_get_position enc5_1_pistonN3))
		; Are either players inside?
		(begin
			; Cook player one if necessary
			(if (volume_test_objects enc5_1_oven_n3 (list_get (players) 0))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 0))
			)
			; Cook player two if necessary
			(if (and coop (volume_test_objects enc5_1_oven_n3 (list_get (players) 1)))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 1))
			)
		)
	)

	; Is the manifold closed?
	(if (= 0 (device_get_position enc5_1_pistonS1))
		; Are either players inside?
		(begin
			; Cook player one if necessary
			(if (volume_test_objects enc5_1_oven_s1 (list_get (players) 0))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 0))
			)
			; Cook player two if necessary
			(if (and coop (volume_test_objects enc5_1_oven_s1 (list_get (players) 1)))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 1))
			)
		)
	)

	; Is the manifold closed?
	(if (= 0 (device_get_position enc5_1_pistonS3))
		; Are either players inside?
		(begin
			; Cook player one if necessary
			(if (volume_test_objects enc5_1_oven_s3 (list_get (players) 0))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 0))
			)
			; Cook player two if necessary
			(if (and coop (volume_test_objects enc5_1_oven_s3 (list_get (players) 1)))
				(damage_object "effects\damage effects\oven heat" (list_get (players) 1))
			)
		)
	)
)


; Player location control
(global short player_is_on_floor 0)
(script static void enc5_1_floor_control
	; Are any players in the main area
	(if (not (volume_test_objects enc5_1_main (players)))
		(begin
			(ai_kill enc5_1_sents/north)
			(ai_kill enc5_1_sents/south)
		)
	)

	; Floor 0?
	(if (and
		(!= player_is_on_floor 0)
		(volume_test_objects enc5_1_floor0 (players))
	) 	(begin
			(set player_is_on_floor 0) 
		)
	)
	
	; Floor 1?
	(if (and
		(!= player_is_on_floor 1)
		(volume_test_objects enc5_1_floor1 (players))
	) 	(begin
			(set player_is_on_floor 1) 
		)
	)
	
	; Floor 2?
	(if (and
		(!= player_is_on_floor 2)
		(volume_test_objects enc5_1_floor2 (players))
	) 	(begin
			(set player_is_on_floor 2) 
		)
	)
	
	; Floor 3?
	(if (and
		(!= player_is_on_floor 3)
		(volume_test_objects enc5_1_floor3 (players))
	) 	(begin
			(set player_is_on_floor 3) 
		)
	)
)


; Monitor control
(script static void enc5_1_monitor_control
	; If he's not running a list...
	(if (!= 3 (ai_command_list_status (ai_actors enc5_1_monitor)))
		(begin
			; If the monitor is in the North, run an N1, then an N2
			(if (volume_test_objects enc5_1_north (ai_actors enc5_1_monitor))
				; Is the player on the top floor?
				(if (>= player_is_on_floor 2)
					(ai_command_list enc5_1_monitor monitor_N2)
					(ai_command_list enc5_1_monitor monitor_N1)
				)
			)
	
			; If the monitor is in the South, run an S1, then an S2
			(if (volume_test_objects enc5_1_south (ai_actors enc5_1_monitor))
				; Is the player on the top floor?
				(if (>= player_is_on_floor 2)
					(ai_command_list enc5_1_monitor monitor_S2)
					(ai_command_list enc5_1_monitor monitor_S1)
				)
			)
	
			; If the players are in the south and the monitor is in the north, move
			(if
				(and
					(volume_test_objects_all enc5_1_north (players))
					(volume_test_objects enc5_1_south (ai_actors enc5_1_monitor))
				)
				(ai_command_list enc5_1_monitor monitor_StoN)
			)
			(if
				(and
					(volume_test_objects_all enc5_1_south (players))
					(volume_test_objects enc5_1_north (ai_actors enc5_1_monitor))
				)
				(ai_command_list enc5_1_monitor monitor_NtoS)
			)
		)		
	)
)


; Ambient explosions
; Damage control
(global short current_damage_level destroyed_count)
(global short current_explosion_seperation 150)
(global effect current_explosion explosion_small)
(script static void enc5_1_explosion
	; Is the damage level above 0?
	(if 
		(and
			(> current_damage_level 0)
			(volume_test_objects enc5_1_main (players))
		)
		(begin
			; Is the player on the north side? Else, is he's on the south side?
			(if (volume_test_objects enc5_1_north (players))
				(if (>= player_is_on_floor 2)
					; Upper level explosions
					(begin_random
						(begin (effect_new current_explosion enc5_1_ceiling_n1) (sleep current_explosion_seperation))
						(begin (effect_new current_explosion enc5_1_ceiling_n2) (sleep current_explosion_seperation))
						(begin (effect_new current_explosion enc5_1_ceiling_n3) (sleep current_explosion_seperation))
					) ; Lower Level explosions
					(begin_random
						(begin (effect_new current_explosion enc5_1_stub_n1) (sleep current_explosion_seperation))
						(begin (effect_new current_explosion enc5_1_stub_n2) (sleep current_explosion_seperation))
						(begin (effect_new current_explosion enc5_1_stub_n3) (sleep current_explosion_seperation))
						(begin (effect_new current_explosion enc5_1_stub_n4) (sleep current_explosion_seperation))
					)
				)
				
				; Elseif
				(if (volume_test_objects enc5_1_south (players))
					(if (>= player_is_on_floor 2)
						; Upper level explosions
						(begin_random
							(begin (effect_new current_explosion enc5_1_ceiling_s1) (sleep current_explosion_seperation))
							(begin (effect_new current_explosion enc5_1_ceiling_s2) (sleep current_explosion_seperation))
							(begin (effect_new current_explosion enc5_1_ceiling_s3) (sleep current_explosion_seperation))
						) ; Lower Level explosions
						(begin_random
							(begin (effect_new current_explosion enc5_1_stub_s1) (sleep current_explosion_seperation))
							(begin (effect_new current_explosion enc5_1_stub_s2) (sleep current_explosion_seperation))
							(begin (effect_new current_explosion enc5_1_stub_s3) (sleep current_explosion_seperation))
						)
					)
				)
			)
		)
	)
	
	; Manifold explosions
	(if 
		(and
			(>= current_damage_level 4)
			(volume_test_objects enc5_1_main (players))
		)
		; Blast from manifolds
		(begin
			; Is the player on the north side? Else, is he's on the south side?
			(if (volume_test_objects enc5_1_north (players))
				(effect_new current_explosion enc5_1_manifold_n2)
				
				; Elseif
				(if (volume_test_objects enc5_1_south (players))
					(effect_new current_explosion enc5_1_manifold_s2)
				)
			)
		)
	)

)

(script continuous enc5_1_explosions
	; Sleep until someone is inside the main area
	(sleep_until (volume_test_objects enc5_1_main (players)))

	; If the current damage is less than the damage count
	(if (< current_damage_level destroyed_count)
		; Increment it
		(begin
			(set current_damage_level (+ 1 current_damage_level))
			; Move to the next most violent explosion
			(if (= 2 current_damage_level) 
				(begin
					(set current_explosion explosion_medium_no)
					(set current_explosion_seperation (- current_explosion_seperation 20))					
				)
			)
			(if (= 3 current_damage_level) 
				(begin
					(set current_explosion explosion_large_no)
					(set current_explosion_seperation (- current_explosion_seperation 20))	
					; Turn on the lights now
					(device_group_set_immediate engine_destroyed_lights 1)				
				)
			)
			(if (= 4 current_damage_level) 
				(begin
					(set current_explosion explosion_large_no)
					(set current_explosion_seperation (- current_explosion_seperation 20))					
				)
			)
		)
	)
	
	; Cause an explosion
	(enc5_1_explosion)
)


; Stairway encounters, South Floor 1 to Floor 2
(script dormant enc5_1_s12
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc5_1_s12 (players)))

	; Debug
;	(if debug (print "Encounter 5.1 - South 1 to 2..."))
	
	; Place the foos
	(ai_place enc5_1_sents/s12)
)


; Side corridor spawn wave limiters
(global short enc5_1_s12_limiter 0)
(global short enc5_1_s23_limiter 0)
(global short enc5_1_n12_limiter 0)
(global short enc5_1_n23_limiter 0)

; Side corridor spawners
(script static void enc5_1_s12_spawn
	; Combat/carrier forms
	(if (<= (ai_living_count enc5_1_flood/s12) min_combat_spawn)
		(begin
			(ai_spawn_actor enc5_1_flood/s12)
			(set enc5_1_s12_limiter (+ enc5_1_s12_limiter 1))
		)
	)
	
	; Infs
	(if (<= (ai_living_count enc5_1_infs/s12) min_infection_spawn)
		(ai_place enc5_1_infs/s12)
	)
)
(script static void enc5_1_s23_spawn
	; Combat/carrier forms
	(if (<= (ai_living_count enc5_1_flood/s23) min_combat_spawn)
		(begin
			(ai_spawn_actor enc5_1_flood/s23)
			(set enc5_1_s23_limiter (+ enc5_1_s23_limiter 1))
		)
	)
	
	; Infs
	(if (<= (ai_living_count enc5_1_infs/s23) min_infection_spawn)
		(ai_place enc5_1_infs/s23)
	)
)
(script static void enc5_1_n12_spawn
	; Combat/carrier forms
	(if (<= (ai_living_count enc5_1_flood/n12) min_combat_spawn)
		(begin
			(ai_spawn_actor enc5_1_flood/n12)
			(set enc5_1_n12_limiter (+ enc5_1_n12_limiter 1))
		)
	)
	
	; Infs
	(if (<= (ai_living_count enc5_1_infs/n12) min_infection_spawn)
		(ai_place enc5_1_infs/n12)
	)
)
(script static void enc5_1_n23_spawn
	; Combat/carrier forms
	(if (<= (ai_living_count enc5_1_flood/n23) min_combat_spawn)
		(begin
			(ai_spawn_actor enc5_1_flood/n23)
			(set enc5_1_n23_limiter (+ enc5_1_n23_limiter 1))
		)
	)
	
	; Infs
	(if (<= (ai_living_count enc5_1_infs/n23) min_infection_spawn)
		(ai_place enc5_1_infs/n23)
	)
)
; Side corridor spawn wave control
(global boolean inside_n12 false)
(global boolean inside_n23 false)
(global boolean inside_s12 false)
(global boolean inside_s23 false)
(script static void enc5_1_side_corridors
	; S12 Corridor spawn
	(if
		(and
			(or
				(> current_damage_level 0)
				(= "impossible" (game_difficulty_get))
			)
			(volume_test_objects_all enc5_1_s12_upper (players))
			(<= enc5_1_s12_limiter (* 30 spawn_scale))
			(<= player_is_on_floor 1)
		)
		; S12 Spawn
		(begin
			(enc5_1_s12_spawn)
			(set inside_s12 true)
		)
		(set inside_s12 false)
	)
	
	; S23 Corridor spawn
	(if
		(and
			(or
				(< current_damage_level 1)
				(= "impossible" (game_difficulty_get))
			)
			(volume_test_objects_all enc5_1_s23_upper (players))
			(<= enc5_1_s23_limiter (* 20 spawn_scale))
			(<= player_is_on_floor 2)
		)
		; S23 Spawn
		(begin
			(enc5_1_s23_spawn)
			(set inside_s23 true)
		)
		(set inside_s23 false)
	)
	
	; N12 Corridor spawn
	(if
		(and
			(or
				(> current_damage_level 0)
				(= "impossible" (game_difficulty_get))
			)
			(volume_test_objects_all enc5_1_n12_upper (players))
			(<= enc5_1_n12_limiter (* 20 spawn_scale))
			(<= player_is_on_floor 1)
		)
		; N12 Spawn
		(begin
			(enc5_1_n12_spawn)
			(set inside_n12 true)
		)
		(set inside_n12 false)
	)
	
	; N23 Corridor spawn
	(if
		(and
			(or
				(< current_damage_level 1)
				(= "impossible" (game_difficulty_get))
			)
			(volume_test_objects_all enc5_1_n23_upper (players))
			(<= enc5_1_n23_limiter (* 30 spawn_scale))
			(<= player_is_on_floor 2)
		)
		; N23 Spawn
		(begin
			(enc5_1_n23_spawn)
			(set inside_n23 true)
		)
		(set inside_n23 false)
	)
)


; Flood Fun!
; Infs, floor 0
(script static void enc5_1_infs_floor0
	; North or south?
	(if (volume_test_objects enc5_1_north (players))
		; North, place flood on north floor 2
		(ai_place enc5_1_infs/n2)
		
		; South, place flood on south floor 2
		(if (volume_test_objects enc5_1_south (players)) (ai_place enc5_1_infs/s2))
	)
)
; Infs, floor 1
(script static void enc5_1_infs_floor1
	; Same as floor 0
	(enc5_1_infs_floor0)
)
; Infs, floor 2
(script static void enc5_1_infs_floor2
	; North or south?
	(if (volume_test_objects enc5_1_north (players))
		; North, place flood on north floor 0
		(ai_place enc5_1_infs/n0)
		
		; South, place flood on south floor 0
		(if (volume_test_objects enc5_1_south (players))(ai_place enc5_1_infs/s0))
	)
)
; Infs, floor 3
(script static void enc5_1_infs_floor3
	; North or south?
	(if (volume_test_objects enc5_1_north (players))
		; North, place flood on north floor 1
		(ai_place enc5_1_infs/n1)
		
		; South, place flood on south floor 1
		(if (volume_test_objects enc5_1_south (players))(ai_place enc5_1_infs/s1))
	)
)
; Inf spawner
(script static void enc5_1_infs_spawn
	; Sleep until the count is low enough
	(if (< (ai_living_count enc5_1_infs) min_infection_spawn)
	(begin
		; Depending on the floor, spawn
		(if (= player_is_on_floor 0) (enc5_1_infs_floor0))
		(if (= player_is_on_floor 1) (enc5_1_infs_floor1))
;		(if (= player_is_on_floor 2) (enc5_1_infs_floor2))
;		(if (= player_is_on_floor 3) (enc5_1_infs_floor3))
	)
	)
)


; Flood control
; Flood North and South
(script static void enc5_1_flood_north
	; Sleep until clear, and the cov count is < critical mass, spawn
	(if (not (volume_test_objects enc5_1_cov_north (players)))
		(ai_place enc5_1_flood/north)
	)
)
(script static void enc5_1_flood_south
	; Sleep until clear, and the cov count is < critical mass, spawn
	(if (not (volume_test_objects enc5_1_cov_south (players)))
		(ai_place enc5_1_flood/south)
	)
)


; Flood spawner
(script static void enc5_1_flood_spawn
	; If the count is low enough
	(if (<= (ai_living_count enc5_1_flood) 2)
		; If the player is in the north, spawn there
		(if (volume_test_objects_all enc5_1_north (players))
			(enc5_1_flood_north)
			(if (volume_test_objects_all enc5_1_south (players))
				(enc5_1_flood_south)
			)
		)
	)
	
	; Top floor flood
	(if 
		(and
			(<= (+ (ai_living_count enc5_1_flood/upper_south) (ai_living_count enc5_1_flood/upper_north)) 1)
			(volume_test_objects_all enc5_1_main (players))
		)
		; If the player is in the north, spawn in the south, vice versa
		(if (volume_test_objects_all enc5_1_north (players))
			(ai_place enc5_1_flood/upper_south)
			(ai_place enc5_1_flood/upper_north)
		)
	)
)


(script static void enc5_1_elevator_spawn
	(if (volume_test_objects_all enc5_1_main (players))
		(ai_place enc5_1_cov/elevator_squad)
	)
)


; Sentinel spawn
(script static void enc5_1_sents_spawn
	; Is the player in the north, or south?
	(if (volume_test_objects_all enc5_1_north (players))
		; He's in the north! Great White North!
		(begin
			(ai_kill enc5_1_sents/south)
			(if 		
				(and
					(<= (ai_living_count enc5_1_sents) 1)
					(volume_test_objects enc5_1_main (players))
				)
				(begin 
					; Pause 
					(sleep 150)
					
					; Have the monitor speak
					(if (>= player_is_on_floor 2)
						(sound_impulse_start "sound\dialog\d40\d40_monitor_player" (list_get (ai_actors enc5_1_monitor) 0) 1)
						(sound_impulse_start "sound\dialog\d40\d40_monitor_self" (list_get (ai_actors enc5_1_monitor) 0) 1)
					)
				
					; Wait a moment, and place the sentinels
					(sleep 300)
					(ai_place enc5_1_sents/north)
				)
			)
		)
	)
		
	(if (volume_test_objects_all enc5_1_south (players))
		; He's in the south! Great Devil South!
		(begin
			(ai_kill enc5_1_sents/north)
			(if 		
				(and
					(<= (ai_living_count enc5_1_sents) 1)
					(volume_test_objects enc5_1_main (players))
				)
				(begin 
					; Pause 
					(sleep 150)
					
					; Have the monitor speak
					(if (>= player_is_on_floor 2)
						(sound_impulse_start "sound\dialog\d40\d40_monitor_player" (list_get (ai_actors enc5_1_monitor) 0) 1)
						(sound_impulse_start "sound\dialog\d40\d40_monitor_self" (list_get (ai_actors enc5_1_monitor) 0) 1)
					)
				
					; Wait a moment, and place the sentinels
					(sleep 300)
					(ai_place enc5_1_sents/south)
				)
			)
		)		
	)
)


; Enc5_1 Spawners
(script continuous enc5_1_spawner
	; Side passageway pausers
	(sleep_until (volume_test_objects enc5_1_main (players)))

	; Spawnzors
	(enc5_1_flood_spawn)
	(enc5_1_infs_spawn)
	
	; Sleep
	(sleep 300)
)

(script continuous enc5_1_spawner_sents
	; Side passageway pausers
	(sleep_until (volume_test_objects enc5_1_main (players)))

	; Spawnzors
	(enc5_1_sents_spawn)
)


; Engine damage control
(script static void enc5_1_damage_detector_control
	(if (<= (device_get_position enc5_1_pistonN1) 0)
		(object_cannot_take_damage enc5_1_detector_n1)
		(object_can_take_damage enc5_1_detector_n1)
	)
	(if (<= (device_get_position enc5_1_pistonN3) 0)
		(object_cannot_take_damage enc5_1_detector_n3)
		(object_can_take_damage enc5_1_detector_n3)
	)
	(if (<= (device_get_position enc5_1_pistonS1) 0)
		(object_cannot_take_damage enc5_1_detector_s1)
		(object_can_take_damage enc5_1_detector_s1)
	)
	(if (<= (device_get_position enc5_1_pistonS3) 0)
		(object_cannot_take_damage enc5_1_detector_s3)
		(object_can_take_damage enc5_1_detector_s3)
	)
)

; Enc5_1 Manager
(global boolean enc5_1_active false)
(script continuous enc5_1_manager
	; Sleep
	(sleep_until enc5_1_active)

	; Trigger handlers
	(enc5_1_damage_detector_control)
	(enc5_1_floor_control)
	(enc5_1_control_poll)
	(enc5_1_destroyed_poll)
	(enc5_1_waypoint_control)
	(enc5_1_side_corridors)
	(enc5_1_manifold_ovens)
	(enc5_1_monitor_control)

	; MUZAK!
	(if
		(or
			inside_n12
			inside_n23
			inside_s12
			inside_s23
		)
		(sound_looping_set_alternate "levels\d40\music\d40_03" true)
		(sound_looping_set_alternate "levels\d40\music\d40_03" false)
	)
)


; Music hook for Marty
(script dormant enc5_1_music_hook
	; Wait till all the manifolds are closed
	(sleep_until 
		(and
			(< (device_get_position enc5_1_pistonn1) .1)
			(< (device_get_position enc5_1_pistonn3) .1)
			(< (device_get_position enc5_1_pistons1) .1)
			(< (device_get_position enc5_1_pistons3) .1)
		)
		30
		1800
	)

	; Wait till a manifold is open
	(sleep_until 
		(or
			(> (device_get_position enc5_1_pistonn1) .1)
			(> (device_get_position enc5_1_pistonn3) .1)
			(> (device_get_position enc5_1_pistons1) .1)
			(> (device_get_position enc5_1_pistons3) .1)
		)
	)

	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_04")
	(sound_looping_start "levels\d40\music\d40_05" none 1)
)


; Encounter 5_1, triggered by Section 5
(script dormant enc5_1
	; Sleep until the trigger
;	(sleep_until (volume_test_objects enc5_1 (players)))
	(certain_save)
   (mcc_mission_segment "09_enc5_1")

	; Debug
;	(if debug (print "Encounter 5.1..."))
	
	; Wake the floor controls, explosions, and ovens
	(wake enc5_1_manager)
	(wake enc5_1_explosions)
	
	; Wake the stair encounters
	(wake enc5_1_s12)
	
	; Fire up dem sentinel thangs! Yee haw!
	(ai_magically_see_players enc5_1_sents)
	(ai_magically_see_players enc5_1_flood)
	
	; Fire up dose monitor doohickeys! YEEE HAAW!
	(ai_place enc5_1_monitor)
	(object_cannot_take_damage (ai_actors enc5_1_monitor))
	(ai_magically_see_players enc5_1_monitor)
	(ai_disregard (ai_actors enc5_1_monitor) true)
	
	; Set up targetting preferences
	(ai_try_to_fight enc5_1_cov enc5_1_flood)
	(ai_try_to_fight enc5_1_cov enc5_1_infs)
	(ai_try_to_fight enc5_1_sents enc5_1_flood)
	(ai_try_to_fight enc5_1_sents enc5_1_infs)

	; Wake the spawners
	(wake enc5_1_spawner)
	
	; Preferential treatment
	(ai_magically_see_players enc5_1_flood/n12)
	(ai_magically_see_players enc5_1_infs/n12)
	(ai_try_to_fight_player enc5_1_flood/n12)
	(ai_try_to_fight_player enc5_1_infs/n12)
	(ai_magically_see_players enc5_1_flood/n23)
	(ai_magically_see_players enc5_1_infs/n23)
	(ai_try_to_fight_player enc5_1_flood/n23)
	(ai_try_to_fight_player enc5_1_infs/n23)
	(ai_magically_see_players enc5_1_flood/s12)
	(ai_magically_see_players enc5_1_infs/s12)
	(ai_try_to_fight_player enc5_1_flood/s12)
	(ai_try_to_fight_player enc5_1_infs/s12)
	
	; Dialogue
	(sleep_until (volume_test_objects enc5_1_main (players)))
   (mcc_mission_segment "10_engine_room")
   
	(D40_110_Cortana)	; The engine room!
	(sleep 60)
	(D40_120_Cortana)	; Monitor has locked terminals
	(D40_130_Cortana) ; Must do it the hard way... here's how
	(set enc5_1_active true) ; Activates encounter control
	(D40_140_Cortana) ; Must uncouple exhausts

	; More spawning
	(wake enc5_1_spawner_sents)

	; Wait for a manifold to open
	(sleep_until 
		(or
			(> (device_get_position enc5_1_pistonn1) .1)
			(> (device_get_position enc5_1_pistonn3) .1)
			(> (device_get_position enc5_1_pistons1) .1)
			(> (device_get_position enc5_1_pistons3) .1)
		)
		5
	)

	; Continue
	(D40_150_Cortana) ; Great, now we can fire into the core

	; MUZAK
	(sound_looping_stop "levels\d40\music\d40_03")
	(sound_looping_start "levels\d40\music\d40_04" none 1)

	; Continue
	(D40_160_Cortana) ; We need a catalyst explosion
	(D40_170_Cortana) ; Use a rocket... if you need more, they're in the armory
	(sleep_until (>= current_damage_level 1))
	
   (mcc_mission_segment "11_destroyed1")
	; MUZAK
	(sound_looping_set_alternate "levels\d40\music\d40_04" true)
	(D40_180_Cortana) ; It's working!

	; Wait for damage level 2, the fire the hook
	(sleep_until (>= current_damage_level 2))
	(wake enc5_1_music_hook)
   (mcc_mission_segment "12_destroyed2")

	; Continue
	(sleep_until (>= current_damage_level 3))
	
   (mcc_mission_segment "13_destroyed3")
	; Continue
	(D40_200_Cortana) ; One more to go!
	(sleep_until (>= current_damage_level 4))

   (mcc_mission_segment "14_destroyed4")
	; MUZAK!
	(sound_looping_set_alternate "levels\d40\music\d40_05" true)
	
	; Continue
	(D40_210_Cortana) ; It's gone critical!
	(D40_220_Cortana) ; We need to get outside!
	
	; Set waypoint
	(activate_team_nav_point_flag "default_red" player waypoint_lift 0)
   
   (mcc_mission_segment "15_elevator")
	(obj_elevator)		; Objective
)


; Section 5 cleaner
(script static void section5_cleaner
	; Kill the unnecessary continuous scripts
	(sleep -1 enc5_1_infs_spawn)
	(sleep -1 enc5_1_manager)
	(sleep -1 enc5_1_spawner)
	(sleep -1 enc5_1_spawner_sents)
)


; Section 5, Begin
(script dormant section5
	; Sleep managers
	(sleep -1 enc5_1_manager)
	(sleep -1 enc5_1_spawner)
	(sleep -1 enc5_1_spawner_sents)
	(sleep -1 enc5_1_explosions)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section5 (players)))
	
	; Debug
;	(if debug (print "Section 5..."))
	
	; Wake next
	(wake enc5_1)
	(wake enc5_2)

	; Snap backtracking door shut, clean up anything that can be cleaned
	(device_set_position_immediate bsp3_cutoff .5)
	
	; MUZAK!
	(sound_looping_start "levels\d40\music\d40_03" none 1)

	; Chapter title
	(chapter_d40_2)
	
	; Sleep, the clean
	(sleep_until
		(and
			manifold_n1_destroyed
			manifold_n3_destroyed
			manifold_s1_destroyed
			manifold_s3_destroyed
			(volume_test_objects enc5_2 (players))
		)
	)
	(section5_cleaner)
)


;- Section 4 Encounters --------------------------------------------------------

;* 	Area:		Section 4
  	 Begins:		At third BSP transition
  	   Ends:		At fourth BSP transition

  Synopsis:		- 

	 Issues:		- Isssssuuuuuueees.... nothing more than issssuueessss....

 Hierarchy:		-> MISSION START
 						-> section2 (immediate)
 							-> enc2_1 (trigger volume)
 								-> enc2_2 (trigger volume)
 									-> enc2_4 (trigger volume + unit count)
 									-> enc2_5 (trigger volume)
 										-> enc2_6 (trigger volume)
 											-> enc2_7 (trigger volume)							
*;

; Encounter 4_3, triggered by Section 4
(script dormant enc4_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_3 (players)))
	(certain_save)
	
	; MUZAK!
	(sound_looping_start "levels\d40\music\d40_02" none 1)

	; Debug
;	(if debug (print "Encounter 4.3..."))
	
	; Sleep for a few seconds, then wait for the player to not look at the doors
	(sleep 150)

	; Wait for no looky at doorsy
	(sleep_until 
		(and
			(not (objects_can_see_flag (players) enc4_3_door 10))
			(not (volume_test_objects enc4_3b (players)))
		)
	)
	(sleep 60)
	
	; Place the Flood stealth elite
	(ai_place enc4_3_flood/stealth_combats)
	
	; Sleep until he's finished running his list, then branch accordingly
	(sleep_until (= 1 (ai_command_list_status (ai_actors enc4_3_flood/stealth_combats))))
	(if (volume_test_objects enc4_3_left (players))
		(ai_command_list enc4_3_flood/stealth_combats enc4_3_right)
		(ai_command_list enc4_3_flood/stealth_combats enc4_3_left)
	)
	
	; Wait until he's dead, or the player has run
	(sleep_until (= 0 (ai_living_count enc4_3_flood)))
	
	; Place the second batch
	(ai_place enc4_3_flood/second_wave)

	; Wait until they're at 70% strength or the player has run
	(sleep_until 
		(or
			(< (ai_strength enc4_3_flood/second_wave) .70)
			(volume_test_objects enc4_3_flight (players))
		)
		5
	)

	; MUZAK!
	(sound_looping_set_alternate "levels\d40\music\d40_02" true)

	; Wait until he's dead, or the player has run
	(sleep_until 
		(or
			(= 0 (ai_living_count enc4_3_flood))
			(volume_test_objects enc4_3_flight (players))
		)
		5
	)

	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_02")
)


; Encounter 4_2 loop manager
(global short enc4_2_limiter 0)
(script continuous enc4_2_manager
	; Sleep until the conditions are right
	(sleep_until (<= enc4_2_limiter (* 45 spawn_scale)))
	(sleep_until 
		(not
			(volume_test_objects enc4_2c (players))
		)
	)
	
	; If the count is lower than 7, spawn sentinels
	(if (<= enc4_2_limiter 7)
		; Spawn sentinels
		(if (< (ai_living_count enc4_2_sents/sents) (* 1.5 min_combat_spawn)) (begin 
			(ai_spawn_actor enc4_2_sents/sents)
			(set enc4_2_limiter (+ enc4_2_limiter 1))
			(sleep 45)
		))

		; Else, spawn flood
		(begin
			; Spawn actors if the counts are too low
			(if (< (ai_living_count enc4_2_flood/combats) (* 1.5 min_combat_spawn)) (begin 
				(ai_spawn_actor enc4_2_flood/combats)
				(set enc4_2_limiter (+ enc4_2_limiter 1))
			))
			(if (< (ai_living_count enc4_2_flood/carriers) min_carrier_spawn) (begin 
				(ai_spawn_actor enc4_2_flood/carriers)
				(set enc4_2_limiter (+ enc4_2_limiter 1))
			))
			(if (< (ai_living_count enc4_2_flood/infs) min_infection_spawn) (begin 
				(ai_place enc4_2_flood/infs)
			))
		)
	)
		
	; Sleep a moment
	(sleep 15)
)


; Encounter 4_2, triggered by Encounter 4_1
(script dormant enc4_2
	; Debug
;	(if debug (print "Encounter 4.2..."))
	(certain_save)
	
	; Wakey wakey
	(wake enc4_3)

	; Place the covies
	(ai_place enc4_2_cov)
	(ai_try_to_fight enc4_2_cov enc4_2_sents)
	(ai_try_to_fight enc4_2_cov enc4_2_flood)

	; Make sure everything is awake
	(ai_link_activation enc4_2_cov enc4_2_sents)
	(ai_link_activation enc4_2_sents enc4_2_cov)
	(ai_link_activation enc4_2_cov enc4_2_flood)
	(ai_link_activation enc4_2_flood enc4_2_cov)
	
	; Magical sight!
	(ai_magically_see_encounter enc4_2_sents enc4_2_cov)
	(ai_magically_see_encounter enc4_2_cov enc4_2_sents)
	(ai_magically_see_encounter enc4_2_flood enc4_2_cov)
	(ai_magically_see_players enc4_2_flood)

	; Fire up the manager
	(wake enc4_2_manager)

	; Sleep until the player is past
	(sleep_until (>= enc4_2_limiter (* 45 spawn_scale)))
	(sleep -1 enc4_2_manager)
)


; Encounter 4_1, triggered by Section 4
(script dormant enc4_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc4_1 (players)) testing_fast)
	(certain_save)
   (mcc_mission_segment "08_enc4_1")
	
	; Debug
;	(if debug (print "Encounter 4.1..."))
	
	; Force active
	(ai_link_activation enc4_1_cov enc4_1_flood)
	(ai_link_activation enc4_1_flood enc4_1_cov)
	(ai_magically_see_encounter enc4_1_flood enc4_1_cov)

	; Wait a few seconds
	(ai_place enc4_1_cov)
	(ai_place enc4_1_flood)
	(ai_try_to_fight enc4_1_flood enc4_1_cov)
	
	; Wakey wakey
	(wake enc4_2)
)


; Section 4, Begin
(script dormant section4
	; Sleep managers
	(sleep -1 enc4_2_manager)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section4 (players)))
	
	; Debug
;	(if debug (print "Section 4..."))
	
	; Wake next
	(wake enc4_1)
)


;- Section 3 Encounters --------------------------------------------------------

;* 	Area:		Section 3
  	 Begins:		At second BSP transition
  	   Ends:		At third BSP transition

  Synopsis:		- Player is caught in crossfire between sents and infs
  					- Player faces sents in several small hallway encounters
  					- Player arrives in cryo bay, where a firefight between Flood
  					  and Sents is occuring. In the confusion, the Monitor appears,
  					  but fails to notice the player
  					- Player encounters D20-esque corridor press, no Monitor in sight
  					- Lull... quiet...
  					- And another big corridor press!

	 Issues:		- Issues? take you pick, we've got em

 Hierarchy:		-> MISSION START
 						-> section3 (immediate)
 							-> enc3_1 (trigger volume)
*;

; Encounter 3_6 loop manager
(global short enc3_6_limiter 0)
(script continuous enc3_6_manager
	; Sleep until the conditions are right
	(sleep_until (<= enc3_6_limiter (* 30 spawn_scale)))
	(sleep_until (volume_test_objects_all enc3_6 (players)))
	
	; Spawn actors if the counts are too low
	(if (< (ai_living_count enc3_6_flood/combats) min_combat_spawn) (begin 
		(ai_spawn_actor enc3_6_flood/combats)
		(set enc3_6_limiter (+ enc3_6_limiter 1))
	))
	(if (< (ai_living_count enc3_6_flood/carriers) min_carrier_spawn) (begin 
		(ai_spawn_actor enc3_6_flood/carriers)
		(set enc3_6_limiter (+ enc3_6_limiter 1))
	))
	(if (< (ai_living_count enc3_6_flood/infs) min_infection_spawn) (begin 
		(ai_place enc3_6_flood/infs)
	))
		
	; Sleep a moment
	(sleep 15)
)


; Encounter 3_6, triggered by Encounter 3_5
(script dormant enc3_6
	; Sleepy
	(sleep -1 enc3_6_manager)
	(sleep_until (volume_test_objects enc3_6 (players)))
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 3.6..."))
		
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_013")

	; Wakey wakey
;	(wake enc3_6)
		
	; Place the units, make them see
	(ai_place enc3_6_flood/stalling_infs)
	(ai_magically_see_players enc3_6_flood)
	(ai_force_active enc3_6_flood true)
	
	; Wake the manager and the next script
	(wake enc3_6_manager)
	
	; Sleep until it's time to stop it
	(sleep_until (volume_test_objects section4 (players)) testing_fast)
	(sleep -1 enc3_6_manager)
	(ai_force_active enc3_6_flood false)

	; Save when safe
	(certain_save)
)


; Encounter 3_5 loop manager
(global short enc3_5_limiter 0)
(script continuous enc3_5_manager
	; Sleep until the conditions are right
	(sleep_until (<= enc3_5_limiter (* 30 spawn_scale)))
	
	; Spawn actors if the counts are too low
	(if (< (ai_living_count enc3_5_flood/combats) min_combat_spawn) (begin 
		(ai_spawn_actor enc3_5_flood/combats)
		(set enc3_5_limiter (+ enc3_5_limiter 1))
	))
	(if (< (ai_living_count enc3_5_flood/carriers) min_carrier_spawn) (begin 
		(ai_spawn_actor enc3_5_flood/carriers)
		(set enc3_5_limiter (+ enc3_5_limiter 1))
	))
	(if (< (ai_living_count enc3_5_flood/infs) min_infection_spawn) (begin 
		(ai_place enc3_5_flood/infs)
	))
		
	; Sleep a moment
	(sleep 15)
)


; Encounter 3_5, triggered by Encounter 3_2
(script dormant enc3_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_5 (players)))
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 3.5..."))
		
	; Wakey wakey
	(wake enc3_6)
		
	; Place the units, make them see
	(ai_place enc3_5_flood/sacrifices)
	(ai_magically_see_players enc3_5_flood)
	(ai_force_active enc3_5_flood true)
	
	; Wake the manager and the next script
	(wake enc3_5_manager)
	
	; Sleep until it's time to stop it
	(sleep_until (volume_test_objects enc3_5b (players)) testing_fast)
	(sleep -1 enc3_5_manager)
	(ai_force_active enc3_5_flood false)

	; Save when safe
	(certain_save)
)


; Encounter 3_4, triggered by Encounter 3_2
(script dormant enc3_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_4 (players)))
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 3.4..."))
		
	; MUZAK!
	(sound_looping_start "levels\d40\music\d40_013" none 1)
	
	; Place the units
	(ai_place enc3_4_monitor/monitor)
	(sleep 60)
	(ai_place enc3_4_monitor/sents)

	; Save when safe
	(certain_save)
)


; Encounter 3_3, triggered by Encounter 3_2
(script dormant enc3_3
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_3 (players)))
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 3.3..."))
	
	; Place the units, make them love the player!
	(ai_place enc3_3_flood/combats)
	(ai_place enc3_3_flood/infs)
	(ai_place enc3_3_sents)
	(ai_try_to_fight enc3_3_sents enc3_3_flood)
	(ai_try_to_fight enc3_3_flood enc3_3_sents)
	
	; Sleep until a door opens
	(sleep_until
		(or
			(>= (device_get_position enc3_3_door1) 0.9)
			(>= (device_get_position enc3_3_door2) 0.9)
		)
		testing_fast
		300
	)
	
	; If a door is open, spawn infs above it
	(if (>= (device_get_position enc3_3_door1) 0.9)
		(ai_place enc3_3_flood/door_infs1)
		; Elseif
		(if (>= (device_get_position enc3_3_door2) 0.9)
			(ai_place enc3_3_flood/door_infs2)
		)
	)

	; Second wave
	(sleep_until 
		(and 
			(volume_test_objects_all enc3_3b (players))
			(<= (ai_living_count enc3_3_sents) 0)
		)
	)
	(ai_place enc3_3_flood/combats2)
)


; Encounter 3_2, triggered by Section 3
(script dormant enc3_2
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_2 (players)))
	(certain_save)
   (mcc_mission_segment "07_enc3_2")
	
	; Debug
;	(if debug (print "Encounter 3.2..."))
	
	; Wakey wakey
	(wake enc3_3)
	(wake enc3_4)
	(wake enc3_5)
	
	; Place the units
	(ai_place enc3_2_sents)

	; Save when safe
	(sleep_until (= 0 (ai_living_count enc3_2_sents)))
	(certain_save)
)


; Encounter 3_1, triggered by Section 3
(script dormant enc3_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc3_1 (players)))
	(certain_save)
   (mcc_mission_segment "06_enc3_1")
	
	; Debug
;	(if debug (print "Encounter 3.1..."))
	
	; Place the units, make them love!
	(ai_place enc3_1_flood)
	(ai_place enc3_1_sents)
	(ai_try_to_fight enc3_1_sents enc3_1_flood)
	(ai_try_to_fight enc3_1_flood enc3_1_sents)
	(ai_force_active enc3_1_flood true)
	(ai_force_active enc3_1_sents true)
	
	; Wait for it...
	(sleep_until
		(or
			(volume_test_objects enc3_1b (players))
			(<= (ai_strength enc3_1_sents) .5)
		)
	)
	(ai_place enc3_1_flood/infs2)
)


; Section 3, Begin
(script dormant section3
	; Sleep managers
	(sleep -1 enc3_5_manager)

	; Sleep until the trigger
	(sleep_until (volume_test_objects section3 (players)))
	
	; Debug
;	(if debug (print "Section 3..."))
	
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_012")
	
	; Wake next
	(wake enc3_1)
	(wake enc3_2)
)




;- Section 2 Encounters --------------------------------------------------------

;* 	Area:		Section 2
  	 Begins:		At first BSP transition
  	   Ends:		At second BSP transition

  Synopsis:		- Player is swarmed by infection forms 
  					- Player finds himself behind Flood lines, who are fighting Covs
  					- Player encounters spec ops Cov in cafeteria, proceeds to BLAM
  					- A second wave of Covs show up if the first wave is sufficiently
  					  depleted and a trigger volume is tripped
  					- Player finds himself behind Cov lines, who are fighing Flood
  					- Player encounters a spec ops squad in the bridge
  					- Player proceeds to armory, encounters Flood combats arming up
  					- Player leaves armory, encounters a pair of cornered hunters
  					  which he can kill or avoid (avoiding might be a good idea here)

	 Issues:		- Oh yes, we have issues

 Hierarchy:		-> MISSION START
 						-> section2 (immediate)
 							-> enc2_1 (trigger volume)
 								-> enc2_2 (trigger volume)
 									-> enc2_4 (trigger volume + unit count)
 									-> enc2_5 (trigger volume)
 										-> enc2_6 (trigger volume after cinematic)
 											-> enc2_7 (trigger volume)							
*;


; Encounter 2_7, triggered by Encounter 2_6
(script dormant enc2_7
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_7 (players)) testing_fast)
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 2.7..."))
	
	; Place the units, make them love!
	(ai_place enc2_7_cov)
	(ai_place enc2_7_flood)
)


; Encounter 2_6, triggered by Encounter 2_5
(script dormant enc2_6
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_6 (players)))
	(certain_save)
	
	; Wakey wakey
	(wake enc2_7)
	
	; Debug, dialogue
;	(if debug (print "Encounter 2.6..."))
	
	; MUZAK!
	(sound_looping_start "levels\d40\music\d40_012" none 1)
	
	; Place the units, make them love the player!
	(device_set_position_immediate enc2_6_door 1)
	(sleep_until (volume_test_objects enc2_6b (players)))
	(ai_place enc2_6_flood)

	; Save when safe
	(sleep_until (= 0 (ai_living_count enc2_6_flood)))
	(certain_save)
)


; Music side thread
(script dormant enc2_5_music
	; Sleep till the cafeteria units are dead
	(sleep_until 
		(and
			(<= (ai_living_count enc2_2_cov) 0)
			(<= (ai_living_count enc2_4_cov) 0)
		)
	)

	; MUZAK!
	(sound_looping_start "levels\d40\music\d40_011" none 1)
	
	; Sleep until the elite has noticed you
;	(sleep_until (= (ai_status enc2_5_cov/elite) 4))
	
	; MUZAK!
;	(sound_looping_set_alternate "levels\d40\music\d40_011" true)
)


; Encounter 2_5, triggered by Encounter 2_2
(script dormant enc2_5
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_6 (players)) testing_fast)
	(certain_save)
		
	; Debug
;	(if debug (print "Encounter 2.5..."))

	; Place the units, make them love the player!
	(ai_place enc2_5_cov)
	(ai_place enc2_5_flood)
	(sleep 30)
	(D40_020_Cortana)
	
	; SLeep until dewdz iz ded
	(sleep_until (<= (ai_living_count enc2_5_cov) 0))
	(sleep 30)
	(D40_030_Cortana)
	
	; Cinematic stuffs
	(sleep_until 
		(and
			(volume_test_objects_all cinematic_bridge (players))
			(game_safe_to_save)
		)
	)

	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_011")

   (if (mcc_mission_segment "cine2_bridge") (sleep 1))
   
	; Cinematic
	(if (cinematic_skip_start) (cinematic_bridge))
	(cinematic_skip_stop)
	
	; Slap the door shut
	(device_set_position_immediate cafeteria_door 0)
	
	; Wakey wakey
	(wake enc2_6)
	
	; Bring in the sents!
	(ai_place enc2_5_sents)
	(sleep 30)
	
	; Dialog
	(sleep_until (volume_test_objects enc2_5_retreat2 (players)))
	(D40_100_Cortana)
	(obj_engineering)
)


; Encounter 2_4, triggered by Encounter 2_2
(script dormant enc2_4
	; Sleep until there's an opportunity to wake 2_4
	(sleep_until 
		(and
			(volume_test_objects enc2_4 (players))
			(<= (ai_living_count enc2_2_cov) 2)
		)
	)
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 2.4..."))
	
	; Place the units, make them see and love!
	(ai_place enc2_4_cov)
	(ai_magically_see_players enc2_2_cov)

	; Save when safe
	(sleep_until (= 0 (ai_living_count enc2_4_cov)))
	(certain_save)
)


; Open doors, place hunters
(script static void enc2_2_hunter1
	(ai_place enc2_2_cov/hunter1)
	(device_set_position enc2_1_door2 1)
)
(script static void enc2_2_hunter2
	(ai_place enc2_2_cov/hunter2)
	(device_set_position enc2_1_door1 1)
)


; Encounter 2_2, triggered by Encounter 2_1
(script dormant enc2_2
	; Debug
;	(if debug (print "Encounter 2.2..."))
	(certain_save)
	
	; Wakey wakey
	(wake enc2_4)
	(wake enc2_5)

	; Place the flood, make them see and love!
	(ai_place enc2_2_flood/sacrifices)
	(ai_place enc2_2_flood/combats)
	
	; Sleep, then place the Cov
	(sleep_until (volume_test_objects enc2_2 (players)))
	(ai_place enc2_2_cov/squad1)
	(ai_place enc2_2_cov/squad2)
	
	; Start the music subscript
	(wake enc2_5_music)

	; If it's easy
	(if (= (game_difficulty_get_real) "easy")
		(begin
			(device_set_position enc2_1_door2 1)
			(device_set_position enc2_1_door1 1)			
		)
		(begin
			; Place the first hunter, bash the door in
			(enc2_2_hunter1)
			(sleep 120)
			(enc2_2_hunter2)
		)
	)

	; Place the infs
	(ai_place enc2_2_flood/infs)
	
	; Save when safe
	(sleep_until (= 0 (+ (ai_living_count enc2_2_cov/hunter1) (ai_living_count enc2_2_cov/hunter2))))
	(certain_save)
	(sleep 90)
	
	; MUZAK!
	(sound_looping_stop "levels\d40\music\d40_01")
)


; Encounter 2_1, triggered by Section 2
(script dormant enc2_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc2_1 (players)) testing_fast)
	(certain_save)
	
	; Debug
;	(if debug (print "Encounter 2.1..."))
	
	; Wakey wakey
	(wake enc2_2)
	
	; Place the units, make them love the player!
	(ai_place enc2_1_flood)
	(ai_magically_see_players enc2_1_flood)
)


; Scenery stuff
(script static void section2_scenery
	; Place the AR's for a moment, tear up the marines, hide them
;	(if debug (print "section2_scenery"))
	(effect_new "effects\bursts\ar burst" ar_burst_4) (sleep 15)
	(effect_new "effects\bursts\ar burst" ar_burst_3) (sleep 15)
	(effect_new "effects\bursts\ar burst" ar_burst_2) (sleep 15)
	(effect_new "effects\bursts\ar burst" ar_burst_1)
)


; Section 2, Begin
(script dormant section2
	; Sleep scripts
;	(sleep -1 enc1_4_manager)
	
	; Sleep until the trigger, then save
	(sleep_until (volume_test_objects section2 (players)))
	
	; Debug
;	(if debug (print "Section 2..."))
	
	; MUZAK!
	(sound_looping_set_alternate "levels\d40\music\d40_01" false)
	
	; Snap backtracking door shut, clean up anything that can be cleaned
	(device_set_position_immediate bsp0_cutoff 0)
	
	; Wake next
	(wake enc2_1)
	
	; Certain save
	(certain_save)
   (mcc_mission_segment "05_enc2_1")
	
	; Scenery hacks
	(section2_scenery)
)


;- Section 1 Encounters --------------------------------------------------------

;* 	Area:		Section 1
  	 Begins:		Inside of airlock at beginning of level
  	   Ends:		At first BSP transition

  Synopsis:		- Player begins inside of a shuttle lock
  					- Player heads into narrow service corridor, is surprised by
  					  infection forms leaping from a hole in the ground
  					- Player descends ladder, encounters carrier forms and sentinels
  					- Player rounds corner, and sees two sentinels being mobbed by 
  					  infection forms, and then by combat forms
  					- Player is caught between spawning combat forms and sentinels

	 Issues:		- AI has difficulty moving in this environment... watch for stuck
	  				  units on doorjams and corridor struts

 Hierarchy:		-> MISSION START
 						-> section1 (immediate)
 							-> enc1_1 (trigger volume)
 							-> enc1_2 (trigger volume)
 							-> enc1_3 (trigger volume)
 							-> enc1_4 (trigger volume)
 								-> enc1_4_manager (continuous)
*;


; Encounter 1_4 loop manager
(global short enc1_4_limiter 0)
(script continuous enc1_4_manager
	; Sleep until the conditions are right
	(sleep_until (<= enc1_4_limiter (* 20 spawn_scale)))
	
	; Spawn actors if the counts are too low
	(if (< (ai_living_count enc1_4_flood/combats) min_combat_spawn) (begin 
		(ai_spawn_actor enc1_4_flood/combats)
		(set enc1_4_limiter (+ enc1_4_limiter 1))
	))
	(if (< (ai_living_count enc1_4_flood/infs) min_infection_spawn) (begin 
		(ai_place enc1_4_flood/infs)
	))
)


; Encounter 1_4, triggered by Section 1
(script dormant enc1_4
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_4 (players)))
	(certain_save)
   (mcc_mission_segment "04_enc1_4")

	; Debug
;	(if debug (print "Encounter 1.4..."))
	
	; Place the inits, and open the door
	(ai_place enc1_4_flood/init_combats)
	(ai_place enc1_4_flood/init_infs)
	(device_set_position enc1_4_door 1)
	
	; Grant divine awareness...
	(ai_magically_see_players enc1_4_sents)
	
	; ... And force eternal labor!
	(ai_force_active enc1_4_flood true)
	(ai_force_active enc1_4_sents true)
	
	; Fire up the manager and place some initial fodder
	(ai_place enc1_4_flood)
	(ai_magically_see_players enc1_4_flood)
	(wake enc1_4_manager)
	
	; Wait until the player has ended it, and end the music
	(sleep_until (volume_test_objects enc1_5 (players)) testing_fast)
	(sleep -1 enc1_4_manager)
)


; Encounter 1_3, triggered by Section 1
(script dormant enc1_3
	; Sleep until the trigger, then save
	(sleep_until (volume_test_objects enc1_3 (players)))
	
	; Debug
;	(if debug (print "Encounter 1.3..."))
	
	; MUZAK!
	(sound_looping_set_alternate "levels\d40\music\d40_01" true)
	
	; Place the units, make them love each other!
;	(ai_place enc1_3_flood)
;	(ai_magically_see_players enc1_3_flood)
)


; Encounter 1_2, triggered by Section 1
(script dormant enc1_2
	; Sleep until the trigger, then save
	(sleep_until (volume_test_objects enc1_2 (players)))
	(certain_save)
   (mcc_mission_segment "03_enc1_2")
	
	; Debug
;	(if debug (print "Encounter 1.2..."))
	
	; Place the infection forms
	(ai_place enc1_2_flood)
	
	; Place the sentinels
	(ai_place enc1_2_sents)
)


; Encounter 1_1, triggered by Section 1
(script dormant enc1_1
	; Sleep until the trigger
	(sleep_until (volume_test_objects enc1_1 (players)) testing_fast)
	(certain_save)
   (mcc_mission_segment "02_enc1_1")
	
	; Debug
;	(if debug (print "Encounter 1.1..."))
	
	; Place the units, make them love each other!
	(ai_place enc1_1_sents)
	(ai_place enc1_1_flood)
	(ai_try_to_fight enc1_1_sents enc1_1_flood)
	(ai_try_to_fight enc1_1_flood enc1_1_sents)
)


; Encounter 1_0, triggered by Section 1
(script dormant enc1_0
	; Dialogue, music
	(D40_010_Cortana)

	; Initial objective
	(obj_bridge)

	; Save
	(certain_save)

	; Sleep until the trigger
	(sleep 300)
	
	; Debug
;	(if debug (print "Encounter 1.0..."))
	
	; Place the units, twice for quantity
	(ai_place enc1_0_sents)
	(sleep 60)
	(ai_place enc1_0_sents)	
)


; Section 1, Begin
(script dormant section1
	; Sleep scripts
	(sleep -1 enc1_4_manager)
	
	; Sleep until the trigger
	(sleep_until (volume_test_objects section1 (players)))
	
	; Debug
;	(if debug (print "Section 1..."))
	
	; Wake next
	(wake enc1_0)
	(wake enc1_1)
	(wake enc1_2)
	(wake enc1_3)
	(wake enc1_4)
)


;- Cheats ----------------------------------------------------------------------
;*
(script static void test1
	(ai_command_list enc7_7_cov/right_gunner enc7_7_shooting)
	(ai_command_list enc7_7_cov/left_gunner enc7_7_shooting)
)

(script static void test3
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume test3)
	
	(wake enc5_3)
) 

(script static void test6
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume test6)
	
	(set manifold_all_destroyed true)
	(wake enc5_2)
) 

(script static void test4
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume test4)
	
	(device_set_position_immediate enc5_1_pistonS1 0)
	(sleep 30)
	(device_set_position enc5_1_pistonS1 1)
) 

(script static void s2
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s2)
)

(script static void s3
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s3)
)

(script static void s4
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume s4)
)

(script static void s5
	(switch_bsp 4)
	(volume_teleport_players_not_inside null_volume s5)
)

(script static void s6
	(switch_bsp 5)
	(volume_teleport_players_not_inside null_volume s6)
	(wake enc6_0)
)

(script static void s7
	(switch_bsp 6)
	(volume_teleport_players_not_inside null_volume s7)
	(wake enc6_6)
)

(script static void s8
	(switch_bsp 7)
	(volume_teleport_players_not_inside null_volume s8)
)

(script static void go
	(s6)
	
	; Set up the timer
	(hud_set_timer_position 0 0 bottom_right)
	(hud_set_timer_time 10 0)
	(hud_set_timer_warning_time 1 0)
	
	; Display the timer
	(show_hud_timer true)
	
	; Sleep
	(sleep_until (volume_test_objects grand_finale (players)))
	(pause_hud_timer true)
)
*;

;- Vehicles --------------------------------------------------------------------


;- Variant control -------------------------------------------------------------

; Test for coop, and if it is coop, adjust some globals
(script static void coop_control
	; Is it coop?
	(if (< (list_count (players)) 1)
		; It's coop
		(begin
		;	(if debug (print "Difficulty Adjusted for Coop"))
			(set coop true)
			(set spawn_scale (* spawn_scale 1.2))
			(set min_combat_spawn (+ min_combat_spawn 1))
		)
	)
)


; Test for difficulty, adjust some globals
(script static void diff_control
	; Is it hard?
	(if (= "hard" (game_difficulty_get))
		; It's hard
		(begin
		;	(if debug (print "Difficulty Adjusted for Hard"))
			(set spawn_scale (* spawn_scale 1.1))
			(set min_combat_spawn (+ min_combat_spawn 1))
			(set min_carrier_spawn (+ min_carrier_spawn 1))
			(set min_infection_spawn (+ min_infection_spawn 1))
		)
	)
	
	; Is it impossible?
	(if (= "impossible" (game_difficulty_get))
		; It's hard
		(begin
		;	(if debug (print "Difficulty Adjusted for Impossible"))
			(set spawn_scale (* spawn_scale 1.25))
			(set min_combat_spawn (+ min_combat_spawn 1))
			(set min_carrier_spawn (+ min_carrier_spawn 1))
			(set min_infection_spawn (+ min_infection_spawn 2))
			(set timer_minutes (- timer_minutes 1))
		)
	)
)


;- Cutscene Side Threads -------------------------------------------------------

; Intro
(script dormant intro_cutscene_aux
	(sleep 90)
	(chapter_d40_1)
)


;- Main ------------------------------------------------------------------------

(global boolean cinematic_ran false)
(script startup mission
	; Fade to black
	(fade_out 0 0 0 0)

	; Initialize scripts
	(coop_control)
	(diff_control)

   (if (mcc_mission_segment "cine1_intro") (sleep 1))
   
	; Wake section tests
	(wake section1)
	(wake section2)
	(wake section3)	
	(wake section4)	
	(wake section5)	
	(wake section6)	
	(wake section7)	

	; Run opening cinematics
	(if (cinematic_skip_start) 
		(begin
			(set cinematic_ran true)
			(wake intro_cutscene_aux)
			(cinematic_intro)
		)
	)
	(cinematic_skip_stop)
	  
	; Start music
	(sound_looping_start "levels\d40\music\d40_01" none 1)
	
	; Fade in
	(if (not cinematic_ran)
		(begin
			(fade_in 0 0 0 0)

			; Lines for Joe
			(breakable_surfaces_reset)
			(breakable_surfaces_enable false)		
		)
	)
	
	; Create the asspain objects
	(object_create_containing "asspain")
	(object_create_containing "trench_jeep")
   
   (mcc_mission_segment "01_start")
)


;- Instamatic Garbage Collector ------------------------------------------------

;(script continuous garbage_collector
;	(sleep 90)
;	(garbage_collect_now)
;)
