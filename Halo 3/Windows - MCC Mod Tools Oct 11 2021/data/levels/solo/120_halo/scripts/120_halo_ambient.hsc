;========================================================================================
;======================================== MUSIC =========================================
;========================================================================================

;(print "startup 120_halo_ambient")


;========================================================================================
;==================================== CHAPTER TITLES ====================================
;========================================================================================

;"Full Circle"
(script dormant 120_title1
	(wake obj_ziggurat_set)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
)
;"This is the way the World Ends"
(script dormant 120_title2
	(cinematic_fade_to_title)								
	(cinematic_set_title title_2)
	(cinematic_title_to_gameplay)
)

;	(sound_looping_set_alternate levels\solo\020_halo\music\120_music_04 TRUE)


(global boolean g_music_120_01 FALSE)
(global boolean g_music_120_02 FALSE)
(global boolean g_music_120_03 FALSE)
(global boolean g_music_120_04 FALSE)
(global boolean g_music_120_045 FALSE)
(global boolean g_music_120_05 FALSE)
(global boolean g_music_120_06 FALSE)
(global boolean g_music_120_07 FALSE)
(global boolean g_music_120_08 FALSE)
(global boolean g_music_120_09 FALSE)
(global boolean g_music_120_10 FALSE)
(global boolean g_music_120_11 FALSE)
(global boolean g_music_120_12 FALSE)
(global boolean g_music_120_13 FALSE)
(global boolean g_music_120_14 FALSE)
(global boolean g_music_120_15 FALSE)

(script dormant 120_music_01
	(sleep_until g_music_120_01)
	(sleep 750)
	(if debug (print "start music 120_01"))
	(sound_looping_start levels\solo\120_halo\music\120_music_01 NONE 1)

	(sleep_until (not g_music_120_01))
	(if debug (print "stop music 120_01"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_01)
)
(script dormant 120_music_02
	(sleep_until g_music_120_02)
	(if debug (print "start music 120_02"))
	(sound_looping_start levels\solo\120_halo\music\120_music_02 NONE 1)

	(sleep_until (not g_music_120_02))
	(if debug (print "stop music 120_02"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_02)
)
(script dormant 120_music_03
	(sleep_until g_music_120_03)
	(if debug (print "start music 120_03"))
	(sound_looping_start levels\solo\120_halo\music\120_music_03 NONE 1)

	(sleep_until (not g_music_120_03))
	(if debug (print "stop music 120_03"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_03)
)
(script dormant 120_music_04
	(sleep_until g_music_120_04)
	(if debug (print "start music 120_04"))
	(sound_looping_start levels\solo\120_halo\music\120_music_04 NONE 1)

	(sleep_until (not g_music_120_04))
	(if debug (print "stop music 120_04"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_04)
)
(script dormant 120_music_045
	(sleep_until g_music_120_045)
	(if debug (print "start music 120_045"))
	(sound_looping_start levels\solo\120_halo\music\120_music_045 NONE 1)

	(sleep_until (not g_music_120_045))
	(if debug (print "stop music 120_045"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_045)
)
(script dormant 120_music_05
	(sleep_until g_music_120_05)
	(if debug (print "start music 120_05"))
	(sound_looping_start levels\solo\120_halo\music\120_music_05 NONE 1)

	(sleep_until (not g_music_120_05))
	(if debug (print "stop music 120_05"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_05)
)
(script dormant 120_music_06
	(sleep_until g_music_120_06)
	(if debug (print "start music 120_06"))
	(sound_looping_start levels\solo\120_halo\music\120_music_06 NONE 1)

	(sleep_until (not g_music_120_06))
	(if debug (print "stop music 120_06"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_06)
)
(script dormant 120_music_07
	(sleep_until g_music_120_07)
	(if debug (print "start music 120_07"))
	(sound_looping_start levels\solo\120_halo\music\120_music_07 NONE 1)

	(sleep_until (not g_music_120_07))
	(if debug (print "stop music 120_07"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_07)
)
(script dormant 120_music_08
	(sleep_until g_music_120_08)
	(if debug (print "start music 120_08"))
	(sound_looping_start levels\solo\120_halo\music\120_music_08 NONE 1)

	(sleep_until (not g_music_120_08))
	(if debug (print "stop music 120_08"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_08)
)
(script dormant 120_music_09
	(sleep_until g_music_120_09)
	(if debug (print "start music 120_09"))
	(sound_looping_start levels\solo\120_halo\music\120_music_09 NONE 1)

	(sleep_until (not g_music_120_09))
	(if debug (print "stop music 120_09"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_09)
)
(script dormant 120_music_10
	(sleep_until g_music_120_10)
	(if debug (print "start music 120_10"))
	(sound_looping_start levels\solo\120_halo\music\120_music_10 NONE 1)

	(sleep_until (not g_music_120_10))
	(if debug (print "stop music 120_10"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_10)
)
(script dormant 120_music_11
	(sleep_until g_music_120_11)
	(if debug (print "start music 120_11"))
	(sound_looping_start levels\solo\120_halo\music\120_music_11 NONE 1)

	(sleep_until (not g_music_120_11))
	(if debug (print "stop music 120_11"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_11)
)
(script dormant 120_music_13
	(sleep_until g_music_120_13)
	
	(if debug (print "start music 120_13"))
	(sound_looping_start levels\solo\120_halo\music\120_music_13 NONE 1)

	(sleep_until (not g_music_120_13))
	(if debug (print "stop music 120_13"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_13)
)
(script dormant 120_music_14
	(sleep_until g_music_120_14)
	(if debug (print "start music 120_14"))
	(sound_looping_start levels\solo\120_halo\music\120_music_14 NONE 1)

	(sleep_until (not g_music_120_14))
	(if debug (print "stop music 120_14"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_14)
)
(script dormant 120_music_15
	(sleep_until g_music_120_15)
	(if debug (print "start music 120_15"))
	(sound_looping_start levels\solo\120_halo\music\120_music_15 NONE 1)

	(sleep_until (not g_music_120_15))
	(if debug (print "stop music 120_15"))
	(sound_looping_stop levels\solo\120_halo\music\120_music_15)
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================

;*
+++++++++++++++++++++++
 DIALOGUE INDEX 
+++++++++++++++++++++++


+++++++++++++++++++++++
*;

(global boolean dialogue TRUE)
(global boolean good_guys_talking FALSE)
(global boolean gravemind_talking FALSE)

(global object obj_arbiter none)
(global ai johnson_actor NONE)
(global ai arbiter_actor NONE)
(global ai spark_343_actor NONE)
(global ai pure_form_actor NONE)
(global ai cortana_actor NONE)

(script dormant cin_halo_intro
	; disable combat dialogue
	(data_mine_set_mission_segment "120la_halo_arrival")
	(ai_dialogue_enable FALSE)
	(cinematic_snap_to_black)
	
			; start intro cinematic (part one) 
	(if (cinematic_skip_start)
		(begin
			(if debug (print "120la_halo"))
			(120la_halo_arrival)							
		)
	)
	(cinematic_skip_stop)
	(120la_halo_arrival_cleanup)

	(if (not (game_is_cooperative))
		(begin
			(ai_place arbiter)
			(set obj_arbiter (ai_get_object arbiter/actor01))
		)
	)

	(object_create_anew pelican_sparks)
	
	; teleport players to the proper locations 
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)
	(object_teleport (player2) player2_start)
	(object_teleport (player3) player3_start)
	
 	; wake chapter title 
 	(wake 120_title1)
 	
 	; turn on fog and snow 
	(render_atmosphere_fog 1)
	(render_weather 1)

	; fade to title 
	(cinematic_fade_to_title)								
)

(script dormant cin_halo_johnson
	; disable combat dialogue

	(data_mine_set_mission_segment "120lb_johnson")
	(cinematic_snap_to_black)
	(ai_erase johnson)
	(ai_erase arbiter)
	(ai_erase sentinels)
		
	(if (cinematic_skip_start)
		(begin
			(if debug (print "120lb_halo"))
			(120lb_johnson)
		)
	)
	(cinematic_skip_stop)
	(120lb_johnson_cleanup)
	(fade_out 0 0 0 0)
	(device_set_position_immediate 120_halo_large_door03 0)
	(device_set_power 120_halo_large_door03 0)	
	; teleport players to the proper locations 
	(object_teleport (player0) control_room_player0)
	(object_teleport (player1) control_room_player1)
	(object_teleport (player2) control_room_player2)
	(object_teleport (player3) control_room_player3)
	(print "TELEPORT PLAYER CINEMATIC")	
; 	(unit_add_equipment (player0) spark_fight TRUE TRUE)					
)

(script dormant cin_halo_activation
	(data_mine_set_mission_segment "120lc_activation")	
	; disable combat dialogue 
;	(device_set_position_immediate control_room_door 1)
	
	(if (= (game_insertion_point_get) 0)
		(cinematic_fade_to_black)
		(cinematic_snap_to_black)
	)
	(sleep 1)
	
		(if (cinematic_skip_start)
			(begin
											
				(if debug (print "120lc_halo"))
				(120lc_activation)
				
			)
		)
		(cinematic_skip_stop)
		(120lc_activation_cleanup)

	; fade_out
	(fade_out 0 0 0 0)
	(sleep 1)

	; cinematic commands 
	(cinematic_stop)
	(camera_control OFF)
	(sleep 1)

		; teleport players 
		(object_teleport (player0) exit_run_player0)
		(object_teleport (player1) exit_run_player1)
		(object_teleport (player2) exit_run_player2)
		(object_teleport (player3) exit_run_player3)	
		
		(if (= (game_insertion_point_get) 0)
			(begin
			 	; add equipment 
			 	(unit_add_equipment (player0) post_spark_fight TRUE TRUE)
			 	(unit_add_equipment (player1) post_spark_fight TRUE TRUE)
			 	(unit_add_equipment (player2) post_spark_fight TRUE TRUE)
			 	(unit_add_equipment (player3) post_spark_fight TRUE TRUE)
			)
			(begin
				(unit_add_equipment (player0) teleport_profile TRUE TRUE)
				(unit_add_equipment (player1) teleport_profile TRUE TRUE)
				(unit_add_equipment (player2) teleport_profile TRUE TRUE)
				(unit_add_equipment (player3) teleport_profile TRUE TRUE)
			)
		)
 		(sleep 1)

		; raise weapon 
		(unit_raise_weapon (player0) -1)
		(unit_raise_weapon (player1) -1)
		(unit_raise_weapon (player2) -1)
		(unit_raise_weapon (player3) -1)
			(sleep 1)
			
			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)
				(sleep 1)
				
		; break allegiances (to prevent the game from being stuck in a "betrayed" state) 
		(ai_allegiance_remove covenant player)
		(ai_allegiance_remove player covenant)
		(ai_allegiance_remove human player)
		(ai_allegiance_remove player human)
		(ai_allegiance_remove covenant human)
		(ai_allegiance_remove human covenant)
			(sleep 1)
		
		; reform allegiances for humans / players / covenant 
		(ai_allegiance covenant player)
		(ai_allegiance player covenant)
		(ai_allegiance human player)
		(ai_allegiance player human)
		(ai_allegiance covenant human)
		(ai_allegiance human covenant)
			(sleep 1)

	(device_set_position_immediate control_room_door 0)
	
	(if (not (game_is_cooperative))
		(begin
			(ai_place arbiter_trench/actor)
			(set obj_arbiter (ai_get_object arbiter_trench/actor))
			(ai_cannot_die arbiter_trench/actor TRUE)
			(ai_force_active arbiter_trench/actor TRUE)
		)
		; set the power to true to open the door (if game is coop) 
		(device_set_power 120_halo_large_door03 1)
	)

	; keep the screen at black for... 
	(sleep 120)

	; wake chapter title 
	(wake 120_title2)		
	(set g_music_120_13 true)

	; wake arbiter dialogue scripts 
	(wake 120VC_ARBITER_REVIVES)
	
	; allows things to happen (maybe)?
	(set cin_johnson_dead true)
)

(script dormant cin_halo_outro
	(data_mine_set_mission_segment "130la_escape")		
;	(object_hide trench_frigate TRUE)
	
	(cinematic_snap_to_black)							
;	(object_destroy trench_frigate)			
	
	(if debug (print "130a_escape"))
	(sleep_forever big_explosions_ambient)

	(game_award_level_complete_achievements)

	(object_teleport (player0) end_game_teleport_flag00)
	(object_teleport (player1) end_game_teleport_flag01)
	(object_teleport (player2) end_game_teleport_flag02)
	(object_teleport (player3) end_game_teleport_flag03)

	(object_hide trench_frigate TRUE)	
	(sleep 1)								

		(if (cinematic_skip_start)
			(begin
				(if debug (print "130la_escape"))
				(130la_escape)
			)
		)
		(cinematic_skip_stop)
	(sound_class_set_gain "" 0 0)
	; cleanup cinematic shit 
	(130la_escape_cleanup)
	(sleep 5)
	(end_mission)
)
(global short rumble_random 0)
(global short rumble_ambient 0)

(script dormant 120_07_ambient_background
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start 0.15 5)
	(sleep 150)
		(sleep_until
			(begin
				(set rumble_random (random_range 1 5))
				(print "start ambient")
				(cond
					((and (= rumble_random 1) (!= rumble_ambient 1))
						(begin
							(player_effect_set_max_rotation 0 1 0.25)
							(player_effect_start 0.10 0)						
							(print "changing to low rumble")								
							(set rumble_ambient 1)
						)
					)
					((and (= rumble_random 2) (!= rumble_ambient 2))
						(begin
							(player_effect_set_max_rotation 0 1 0.25)
							(player_effect_start 0.15 0)
							(print "changing to mid rumble")								
							(set rumble_ambient 2)					
						)
					)
					((and (= rumble_random 3) (!= rumble_ambient 3))
						(begin
							(player_effect_set_max_rotation 0 1 0.25)
							(player_effect_start 0.20 0)
							(print "changing to high rumble")								
							(set rumble_ambient 3)						
						)
					)
					((and (= rumble_random 4) (!= rumble_ambient 4))
						(begin
							(player_effect_set_max_rotation 0 1 0.25)
							(player_effect_start 0.25 0)
							(print "changing to highest rumble")								
							(set rumble_ambient 4)						
						)
					)
				)
		FALSE)
	(* (random_range 7 10) 30))										
)

(global point_reference control_point01 exterior02/p0)

(script dormant 120_07_destruction01
	(sleep_until (= (device_get_position 120_halo_large_door03)1) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel03)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel03)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel04)
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel01)
	(sleep (random_range 5 15))
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel02)
	(sleep (random_range 5 15))
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel01)
	(sleep (random_range 5 15))
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel02)		

)


(script dormant 120_07_destruction02
	(sleep_until (volume_test_players 120_07_hall_explosion02) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel04)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel04)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel05)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel05)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel03)
	(sleep (random_range 5 15))
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel03)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel02)
	(sleep (random_range 5 15))
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel02)
)

(script dormant 120_07_destruction03
	(sleep_until (volume_test_players 120_07_hall_explosion03) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel05)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel05)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel06)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel06)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel04)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel03)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel04)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel03)			
)
(script dormant 120_07_destruction04
	(sleep_until (volume_test_players 120_07_hall_explosion05) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel06)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel06)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel07)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel07)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel05)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel04)
	(sleep (random_range 5 15))		
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel05)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel04)
)
(script dormant 120_07_destruction05
	(sleep_until (volume_test_players 120_07_hall_explosion07) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel07)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel07)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel08)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel08)
	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel05)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel06)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel05)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel06)													
)
(script dormant 120_07_destruction06
	(sleep_until (volume_test_players 120_07_hall_explosion09) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel09)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel09)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel10)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel10)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel07)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel08)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel07)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel08)													
)
(script dormant 120_07_destruction07
	(sleep_until (volume_test_players 120_07_hall_explosion10) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel11)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel11)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel09)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel08)
	(sleep (random_range 5 15))		
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel09)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel08)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel10)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel10)
(sleep_until (volume_test_players 120_07_hall_explosion11) 5)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel11)
;	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel11)	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel11)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel10)
	(sleep (random_range 5 15))		
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel11)
	(sleep (random_range 5 15))	
	(effect_new_random  "fx\scenery_fx\explosions\halo_hallway_explosion_medium\halo_hallway_explosion_medium" control_room_hallway_panel10)
														
)
(script dormant 120_07_c_hallway_explosions
	(sleep_until (volume_test_players 120_07_c_hall01) 5)
	(c_shape_blowout c_pillar01 c_pillar02)
	(game_save)
	(sleep_until (volume_test_players 120_07_c_hall02) 5)
	(c_shape_blowout c_pillar03 c_pillar04)
	(sleep_until (volume_test_players 120_07_c_hall03) 5)
	(c_shape_blowout c_pillar05 c_pillar06)
	(sleep_until (volume_test_players 120_07_c_hw_section_04) 5)
	(c_shape_blowout c_pillar07 c_pillar08)
	(sleep_until (volume_test_players 120_07_c_hall04) 5)
;	(c_shape_blowout ceiling01 ceiling02)
	(sleep_until (volume_test_players 120_07_c_hall05) 5)
;	(pillar_blowout ceiling03 ceiling04 ceiling05)	
)

;
(script static void test_explosion
	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces" control_room_hallway_panel04)
	(effect_new_random  "levels\solo\120_halo\fx\control_hallway\hallway_pieces02" control_room_hallway_panel04)
)

(global short rand_pillar 0)
(global short rand_loop 0)
(script static void (pillar_blowout (object pillar01) (object pillar02) (object pillar03))
	(set rand_loop (random_range 1 4))
	(sleep_until
		(begin
			(set rand_pillar (random_range 1 4))
			(cond
				((= rand_pillar 1) (object_damage_damage_section pillar01 "main" 1))
				((= rand_pillar 2) (object_damage_damage_section pillar02 "main" 1))
				((= rand_pillar 3) (object_damage_damage_section pillar03 "main" 1))
			)
			(set rand_loop (- rand_loop 1))
		(<= rand_loop 0))
	(* (random_range 1 4) 30))
)

(script static void (c_shape_blowout (object pillar01)(object pillar02))
	(set rand_pillar (random_range 0 2))
	(if (= rand_pillar 0)
		(begin
			(sleep (random_range 5 10))
			(object_damage_damage_section pillar01 "main" 1)
			(sleep (random_range 5 10))
			(object_damage_damage_section pillar02 "main" 1)		
		)
		(begin
			(sleep (random_range 5 10))
			(object_damage_damage_section pillar02 "main" 1)
			(sleep (random_range 5 10))
			(object_damage_damage_section pillar01 "main" 1)		
		)
	)		
)
; ===================================================================================================================================================

(script dormant md_01_crash_site_cortana
    (ai_dialogue_enable FALSE)
;	(sleep 15)	
;	(if dialogue (print "CORTANA: I got us as close to the control room as I could."))
;	(ai_play_line_on_object NONE 120MA_010)
;	(sleep (ai_play_line_on_object NONE 120MA_010))
;	(sleep 10)
;	(if dialogue (print "CORTANA: Shouldn't be hard to find our way."))
;	(ai_play_line_on_object NONE 120MA_030)	
;	(sleep (ai_play_line_on_object NONE 120MA_030))
;	(sleep_until (>= halo_obj_control 10))
	(sleep 1200)
	(if (< halo_obj_control 14)
		(begin
			(set good_guys_talking TRUE)
			(sleep (ai_play_line_on_object NONE 120MA_090))
			(sleep 15)
			(set good_guys_talking FALSE)
		)
	)

;	(ai_play_line_on_object NONE 120MA_040)	
;	(sleep (ai_play_line_on_object NONE 120MA_040))
	(sleep_until (>= halo_obj_control 14))
	(sleep 1200)
	(set good_guys_talking TRUE)	
	(sleep (ai_play_line_on_object NONE 120MA_080))
	(set good_guys_talking FALSE)
	
;	(if dialogue (print "CORTANA: Seems like a lifetime ago."))
;	(ai_play_line_on_object NONE 120MA_050)	
;	(sleep (ai_play_line_on_object NONE 120MA_050))
;	(sleep_until (>= halo_obj_control 18))
;	(if dialogue (print "CORTANA: It all looks so new. Unfinished…"))
;	(ai_play_line_on_object NONE 120MA_060)	
;	(sleep (ai_play_line_on_object NONE 120MA_060))
;	(set good_guys_talking FALSE)	
;	(if dialogue (print "CORTANA: Careful. Mind the gap."))
;	(ai_play_line_on_object NONE 120MA_0470)
;	(sleep (ai_play_line_on_object NONE 120MA_070))
;	(sleep_until (>= halo_obj_control 20))
;	(sleep 300)
;	(sleep 300)
;	(sleep_until (volume_test_players cor_dialog_trig02_5))
;	(set good_guys_talking TRUE)
;	(sleep 15)
;	(sleep_until (>= halo_obj_control 20))				
;	(if dialogue (print "CORTANA: Go on. Jump. You'll make it."))

;	(set good_guys_talking FALSE)				
;	(sleep 300)
;	(sleep 15)
	(sleep_until (>= halo_obj_control 20))
	(sleep 1200)
	(set good_guys_talking TRUE)				
	(if dialogue (print "CORTANA: Time is a factor, Chief. Let's find the control room."))
	(sleep (ai_play_line_on_object NONE 120MA_100))
	(set good_guys_talking FALSE)	
	(ai_dialogue_enable TRUE)			
)

(script dormant md_02_drop_path_cortana
    (ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep 15)				
	(if dialogue (print "CORTANA: Halo was never meant to be fired under these conditions."))
	(sleep (ai_play_line_on_object NONE 120MB_010))	
	(if dialogue (print "CORTANA: It'll have catastrophic results for the ring and the "))
	(sleep (ai_play_line_on_object NONE 120MB_020))
	(if dialogue (print "CORTANA: It all looks so new. Unfinished…"))
	(sleep (ai_play_line_on_object NONE 120MB_030))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)				
)
(script dormant md_02_terminal_cortana
	(sleep 15)
	(sleep_until (volume_test_players cor_dialog_trig04)5)
	(sleep_forever md_01_crash_site_cortana)
	(ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)					
	(if dialogue (print "CORTANA: Where are you going?."))
	(sleep (ai_play_line_on_object NONE 120MX_010))
	(sleep 15)	
;	(if dialogue (print "CORTANA: Careful! Remember what happened last --"))
;	(sleep (ai_play_line_on_object NONE 120MX_020))
	(sleep_until (volume_test_players cor_dialog_trig05)5)
	(if dialogue (print "CORTANA: Wait. What's that?"))
	(sleep (ai_play_line_on_object NONE 120MX_030))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
	(sleep_until (and (not (terminal_is_being_read)) 
					(terminal_was_accessed fp_terminal)
		    (not (terminal_was_completed fp_terminal)))5)
	    
	(ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep (random_range 30 60))									
	(if dialogue (print "CORTANA: How many of these have you found?"))
	(sleep (ai_play_line_on_object NONE 120MX_040))
	(sleep (random_range 30 60))
;	(if dialogue (print "CORTANA: I hope you stored all the data."))
;	(sleep (ai_play_line_on_object NONE 120MX_050))
;	(sleep 15)	
;	(sleep_until (volume_test_players cor_dialog_trig05)5)
;	(if dialogue (print "CORTANA: If we make it out of here, I'll need something to read on the way back to Earth."))
;	(sleep (ai_play_line_on_object NONE 120MX_060))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
	
	(sleep 300)
	(if (volume_test_players cor_dialog_trig05)
		(begin
			(ai_dialogue_enable FALSE)				
			(set good_guys_talking TRUE)										
			(if dialogue (print "CORTANA: C'mon Chief lets get back on track."))
			(sleep (ai_play_line_on_object NONE 120MX_070))
			(sleep 15)
			(if dialogue (print "CORTANA: The Control Room is outside."))
			(sleep (ai_play_line_on_object NONE 120MX_080))
			(set good_guys_talking FALSE)		
			(ai_dialogue_enable TRUE)
		)
	)
)

(script dormant md_03_valley_floor
	(sleep_until (volume_test_players 120_03_flood_attack)1)
	(wake crash00)	
	(sleep_forever md_01_crash_site_cortana)		
	(wake md_gravemind01)
	(sleep 30)
	(sleep_until (script_finished md_gravemind01))			
	(sleep_until (volume_test_players valley_floor_cortana_dialog01)5)
	(ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(if dialogue (print "CORTANA: There should be ramps that lead to the top!"))
	(sleep (ai_play_line_on_object NONE 120MX_090))
	(if dialogue (print "CORTANA: Check the other side!"))
	(sleep (ai_play_line_on_object NONE 120MX_100))	
	(set good_guys_talking FALSE)	
	(ai_dialogue_enable TRUE)
)

(script static void 120_PA_Johnson_FlyBy

	(sound_impulse_stop "sound\dialog\120_halo\mission\120MB_010_cor.sound")
	(sound_impulse_stop "sound\dialog\120_halo\mission\120MB_020_cor.sound")	
	(sound_impulse_stop "sound\dialog\120_halo\mission\120MB_030_cor.sound")
	(sleep_forever md_02_drop_path_cortana)
	(wake 120_MD_Johnson_FlyBy)

	(if (= (campaign_metagame_enabled) FALSE)
		(begin
		;	(player_control_lock_gaze (player0) intro_vignette/p7 20)
			(player_control_scale_all_input 0.25 1)			
			(perspective_start)
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			; camera animation
			(120pa_ziggurat_reveal)
	
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
			(object_teleport (player0) ziggurat_player0_teleport)
			(object_teleport (player1) ziggurat_player1_teleport)
			(object_teleport (player2) ziggurat_player2_teleport)
			(object_teleport (player3) ziggurat_player3_teleport)
;			(player0_set_pitch g_player_start_pitch 0)
;			(player1_set_pitch g_player_start_pitch 0)
;			(player2_set_pitch g_player_start_pitch 0)
;			(player3_set_pitch g_player_start_pitch 0)		
			(perspective_stop)
;			(object_teleport (list_get (ai_actors arbiter) 0) ziggurat_arbiter_teleport)			
		;	(player_control_unlock_gaze (player0))					
		)
	)		
)
					

(script dormant 120_MD_Johnson_FlyBy
    (ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(if dialogue (print "CORTANA: Johnson?!"))
	(sleep (ai_play_line_on_object NONE 120VA_010))
	(if dialogue (print "JOHNSON: Elites just retreated through the Portal, Cortana!"))
	(sleep (ai_play_line_on_object NONE 120VA_020))
	(if dialogue (print "CORTANA: And you were supposed to go with them!"))
	(sleep (ai_play_line_on_object NONE 120VA_030))
	(if dialogue (print "JOHNSON: Sorry, ma'am. But this time? We all go home.."))
	(sleep (ai_play_line_on_object NONE 120VA_040))
	(if dialogue (print "CORTANA: (sighs) Just set that frigate down somewhere safe!"))
	(sleep (ai_play_line_on_object NONE 120VA_050))
	(if dialogue (print "JOHNSON: Roger that!"))
	(sleep (ai_play_line_on_object NONE 120VA_060))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
)
;*
(script dormant md_04_ziggurat_exterior
    (ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep 15)				
	(if dialogue (print "CORTANA: The Flood have triggered Halo's defenses! Those Sentinels?"))
	(sleep (ai_play_line_on_object NONE 120MD_010))


	(if dialogue (print "CORTANA: They'll try and stop everything from entering the control-room! Even you!"))
	(ai_play_line_on_object NONE 120MD_020)				
	(sleep (ai_play_line_on_object NONE 120MD_020))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
			
)
*;
(script dormant c_hallway_door_close
	(device_set_position c_hallway_door 0)
	(sleep_until (= (device_get_position c_hallway_door) 0)5)
	(device_set_power c_hallway_door 0)
)

(script dormant 120PA_JOHNSON_INTRO
	(if debug (print "mission dialogue:01:johnson:intro"))
	(device_set_power c_hallway_door 1)
	(device_set_position c_hallway_door 1)
	(sleep 1)
	(ai_place johnson)
	(vs_cast johnson TRUE 0 "")
	(set johnson_actor (vs_role 1))
	(vs_enable_pathfinding_failsafe johnson_actor TRUE)
	(vs_enable_looking johnson_actor TRUE)
	(vs_enable_targeting johnson_actor TRUE)
;	(vs_movement_mode johnson_actor 2)
	(ai_disregard (ai_actors johnson) true)
;	(vs_enable_pathfinding_failsafe arbiter_actor TRUE)
;	(vs_enable_looking arbiter_actor TRUE)
;	(vs_movement_mode arbiter_actor 2)
;	(vs_go_to arbiter_actor FALSE intro_vignette/p1)
	(vs_go_to johnson_actor TRUE intro_vignette/p0)
	(wake c_hallway_door_close)
	(sleep_until (or (volume_test_players johnson_intro_trig02) (volume_test_players johnson_intro_trig))1)
	(ai_place pure_form_tank)
	(wake tank_vignette)
	(sleep_until (or (volume_test_players johnson_intro_trig) (volume_test_players johnson_intro_trig02)) 1)
	(set g_music_120_05 true)	
	(if (volume_test_players johnson_intro_trig02)
		(begin
			(sleep_until (< (ai_living_count pure_form_tank) 1)5 150)
				(set good_guys_talking TRUE)
				(sleep 15)				
				(if dialogue (print "JOHNSON: I got you covered, Chief!"))
				(sleep (ai_play_line_on_object NONE 120PA_030))
					
				(if dialogue (print "JOHNSON: Meet you at the top of that tower!"))
				(sleep (ai_play_line_on_object NONE 120PA_040))
				(set good_guys_talking FALSE)
				(ai_set_objective pure_form_tank ziggurat_obj)					

		)
	)
	(sleep 60)
	(wake md_05_johnson_exterior01)
;	(wake md_05_cortana_exterior)
	(vs_go_to johnson_actor FALSE intro_vignette/p2)
	(sleep_until (or (>= wave_num 1)(volume_test_players 120_05_arbiter_enters))5)
	(unit_add_equipment arbiter_actor arbiter_sword TRUE TRUE)
	(ai_set_objective johnson ziggurat_obj)

)

(script dormant tank_vignette
	(vs_cast pure_form_tank TRUE 0 "")
	(set pure_form_actor (vs_role 1))
	(vs_enable_pathfinding_failsafe pure_form_actor TRUE)
	(vs_shoot johnson_actor false pure_form_actor)			
	(vs_go_to pure_form_actor TRUE intro_vignette/p5)
	(vs_face pure_form_actor TRUE intro_vignette/p6)
	(sleep 60)
)

(script dormant md_05_cortana_exterior
    (ai_dialogue_enable FALSE)
	(if dialogue (print "CORTANA: What drives all the men in my life to such ill-advised heroics?"))
	(sleep (ai_play_line_on_object NONE 120PA_050))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
)

(script dormant md_05_johnson_exterior01
	(sleep 600)			
    (ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep 15)						
	(if dialogue (print "JOHNSON: Keep moving, Chief! I got your back!"))
	(sleep (ai_play_line_on_object NONE 120MD_140))
	(set good_guys_talking FALSE)						

	(sleep 600)
	(if (or 	
			(volume_test_players second_right_trig)
			(volume_test_players third_right_trig)
		)
		(begin
			(set good_guys_talking TRUE)
			(sleep 15)						
			(if dialogue (print "JOHNSON: Careful! I can't cover you on the far side!"))
			(sleep (ai_play_line_on_object NONE 120MD_160))
			(set good_guys_talking FALSE)						
		)
		(begin
			(set good_guys_talking TRUE)
			(sleep 15)							
			(if dialogue (print "JOHNSON: Flood are crawling all over that tower! Watch yourself."))
			(sleep (ai_play_line_on_object NONE 120MD_150))
			(set good_guys_talking FALSE)						
		)
	)
	(ai_dialogue_enable TRUE)
;*	(sleep_until (volume_test_players first_center_trig))

		(set good_guys_talking TRUE)
		(sleep 15)							
		(if dialogue (print "JOHNSON: You're almost to the top, Chief…"))
		(ai_play_line_on_object NONE 120MD_170)
		(sleep (ai_play_line_on_object NONE 120MD_170))
		(set good_guys_talking FALSE)							
		(sleep 60)
		(sleep_until (= (vs_running_atom_movement arbiter_actor) FALSE)1)
		(set good_guys_talking TRUE)
		(sleep 15)					
		(if dialogue (print "JOHNSON: Watch out! There's one hell of a welcome party!"))
		(ai_play_line_on_object NONE 120MD_180)
		(sleep (ai_play_line_on_object NONE 120MD_180))
		(set good_guys_talking FALSE)
*;		
)

(script static void johnson_movement_test
	(ai_place johnson)
	(object_teleport (list_get (ai_actors johnson) 0) cliff01); temp
	(sleep 30)
	(wake 120VB_DOOR_OPENS)
	;(cs_run_command_script johnson johnson_movement)
)
(script command_script johnson_movement
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_enable_looking FALSE)
	(cs_movement_mode 2)
	(cs_draw)
	(cs_go_to_and_face intro_vignette/p12 intro_vignette/p10)
	(cs_go_to intro_vignette/p4)
;	(custom_animation_relative johnson objects\characters\marine\cinematics\vignettes\120vb_door_opens\120vb_door_opens "johnson:120_halo_jump" TRUE arbiter_temp_jump)
;	(ai_teleport johnson intro_vignette/p9)
;	(cs_custom_animation objects\characters\marine\cinematics\vignettes\120vb_door_opens\120vb_door_opens "johnson:120_halo_jump" FALSE intro_vignette/p9)
	
)
(script command_script arbiter_movement
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_movement_mode 2)
	(cs_go_to intro_vignette/p1)
	(sleep_forever)
)	
(script static void md_06_spark_door
		(sleep_forever md_05_johnson_exterior01)
		(sleep_forever md_05_cortana_exterior)
		(sleep 60)
		(sleep_until (= good_guys_talking TRUE)5 60)
		(ai_dialogue_enable FALSE)
		(set good_guys_talking TRUE)
		(sleep 15)					
		(if dialogue (print "JOHNSON: Spark! You in there?!"))
		(sleep (ai_play_line_on_object NONE 120MD_190))
		(sleep 15)
		(if dialogue (print "JOHNSON: Open the damn door!"))
		(sleep (ai_play_line_on_object NONE 120MD_200))
		(sleep 15)		
		(if dialogue (print "GUILTY SPARK: Of course, Reclaimer..."))
		(sleep (ai_play_line_on_object NONE 120MD_210))
		(sleep 15)
		
		(if dialogue (print "GUILTY SPARK: Just as soon as you dispose of proximate Flood threats."))
		(sleep (ai_play_line_on_object NONE 120MD_220))
		(sleep 15)
		
		(if dialogue (print "GUILTY SPARK: I'm afraid contaimination protocols do not allow for..."))
		(ai_play_line_on_object NONE 120MD_230)
		(sleep (- (ai_play_line_on_object NONE 120MD_230) 10 ))
		(if dialogue (print "JOHNSON: Yeah, yeah! I hear you!"))
		(sleep (ai_play_line_on_object NONE 120MD_240))
		(sleep 90)							
		(if dialogue (print "CORTANA: Was that the Monitor? You didn't tell me he was here…"))
		(sleep (ai_play_line_on_object NONE 120MX_110))
		(sleep 120)									
		(if dialogue (print "CORTANA: Well, we are finally doing what he wanted."))
		(sleep (ai_play_line_on_object NONE 120MX_120))
		(set good_guys_talking FALSE)
		(set g_music_120_01 false)
		(set g_music_120_05 false)
		(set g_music_120_07 true)
		
		(ai_dialogue_enable TRUE)

		(game_save)

)

(script dormant test_top
	(ai_place johnson)
	(ai_place arbiter)	
	(object_teleport (list_get (ai_actors johnson) 0) cliff01)
	(object_teleport (list_get (ai_actors arbiter) 0) arbiter_test_top)		
	(sleep_until (volume_test_players 120_05_arbiter_enters))
	(switch_zone_set 120_01_02_03)
	(sleep_until (>= (current_zone_set) 1) 1) ;120_01_02_03
	(wake 120_05_ziggurat_top)
	(wake 120VB_Johnson_movement)
	(sleep_forever ziggurat_top_encounter)
	(set wave_num 7)

)

(script dormant 120VB_DOOR_OPENS
	(vs_set_cleanup_script 120VB_DOOR_OPENS_CLEANUP)
	(sleep_until (volume_test_players ziggurat_final_trig)5)
		;(vs_go_to_and_face johnson_actor TRUE intro_vignette/p12 intro_vignette/p10)
		;(vs_go_to johnson_actor TRUE intro_vignette/p4)
		(ai_disregard (ai_actors johnson) false)	
		(vs_enable_pathfinding_failsafe johnson_actor TRUE)
		(vs_enable_pathfinding_failsafe arbiter_actor TRUE)		
		(wake johnson_failsafe)		
		(vs_go_to johnson_actor TRUE upper_ziggurat_vignettes/p2)
		(sleep_forever johnson_failsafe)
		;(object_teleport (list_get (ai_actors johnson) 0) johnson_teleport); temp
		(sleep 30)
		(vs_go_to_and_face johnson_actor TRUE upper_ziggurat_vignettes/p3 upper_ziggurat_vignettes/p4)
		(ai_dialogue_enable FALSE)
		(set good_guys_talking TRUE)
		(sleep 15)						
		(if dialogue (print "JOHNSON: Open up! Coast is clear! "))
		(vs_play_line johnson_actor TRUE 120VB_010)
		(sleep 10)
		(device_set_position 120_halo_large_door01 1)		
		(if dialogue (print "CORTANA: Not for long. I'm tracking additional dispersal pods…"))
		(sleep (ai_play_line_on_object NONE 120VB_020))		
		(sleep 10)
		(if dialogue (print "CORTANA: They'll be hitting any minute!"))
		(sleep (ai_play_line_on_object NONE 120VB_030))				
		(set good_guys_talking FALSE)													
		(if dialogue (print "JOHNSON: Then I guess we'd better hurry."))
		(sleep (ai_play_line johnson_actor 120VB_070))
		(ai_dialogue_enable TRUE)
)
(script dormant johnson_failsafe
	(sleep 600)
	(ai_bring_forward (ai_get_object johnson) 10)	

)

(script dormant 120_Gravemind_moment01
	(ai_dialogue_enable FALSE)
	
	(wake 120ga_victim)
	(sleep 270)
   	(if dialogue (print "CORTANA: It's trying to rebuild itself on this ring!"))
	(sleep (ai_play_line_on_object NONE 120MX_150))
	(sleep 10)
	(if dialogue (print "JOHNSON: Hurry! Control room's close!"))
	(sleep (ai_play_line johnson_actor 120MX_160))
        (sleep 30)
	(ai_dialogue_enable TRUE)
)

(global short joh_hw 0)

(script dormant 120VB_Johnson_movement
	(sleep_until (= (device_get_position 120_halo_large_door01) 1))
	(vs_enable_pathfinding_failsafe johnson_actor TRUE)
	(ai_set_objective johnson halloftearjerking_obj)
	(ai_set_objective arbiter halloftearjerking_obj)
	(set g_music_120_07 false)
	(set g_music_120_08 true)
	(set g_music_120_09 true)	
	(sleep_until (volume_test_players 120_07_hall_explosion09) 1)
	(set joh_hw 1)
	(sleep_until (volume_test_players 120_07_hall_explosion07) 1)
	(set joh_hw 2)
	(wake 120_Gravemind_moment01)
	(sleep_until (volume_test_players 120_07_hall_explosion06) 1)
	(set joh_hw 3)	
	(sleep_until (volume_test_players 120_07_hall_explosion05) 1)
	(set joh_hw 4)
	(sleep_until (volume_test_players 120_07_hall_explosion04) 1)
	(set joh_hw 5)
	(sleep_until (volume_test_players 120_07_hall_explosion03) 1)
	(set joh_hw 6)
;	(wake arbiter_stays)
)

;(script command_script )
(script dormant arbiter_stays
	(vs_cast arbiter TRUE 0 "")
	(set arbiter_actor (vs_role 1))
	(vs_go_to arbiter_actor TRUE exit_arbiter/p0)
	(vs_face_player arbiter_actor TRUE)
	
	(if dialogue (print "ARBITER: I shall remain here…"))
	(sleep (ai_play_line arbiter_actor 120VB_040))

	(if dialogue (print "ARBITER: And will let nothing past!"))
	(sleep (ai_play_line arbiter_actor 120VB_050))
	
	(sleep_forever)		
)
(script dormant 120VB_DOOR_OPENS_CLEANUP
	(device_set_position 120_halo_large_door01 1)
	(ai_dialogue_enable TRUE)
)

(script dormant 120VC_ARBITER_REVIVES
	(set joh_hw 7)

	(vs_cast arbiter_trench TRUE 0 "")
	(set arbiter_actor (vs_role 1))

	(ai_dialogue_enable FALSE)
		(sleep 120)

			(if dialogue (print "ARBITER: I'm sorry.."))
			(sleep (ai_play_line arbiter_actor 120VC_030))
			(sleep 10)
				
			(if dialogue (print "ARBITER: Come spartan etc."))
			(sleep (ai_play_line arbiter_actor 120VC_040))
			(sleep 10)
			
		; set the power to true to open the door 
		(device_set_power 120_halo_large_door03 1)		

	(ai_dialogue_enable TRUE)
			
	(sleep_until (= (device_get_position 120_halo_large_door03) 1))				
	(vs_enable_moving arbiter_actor TRUE)
	(vs_enable_targeting arbiter_actor TRUE)
	(ai_set_objective arbiter_trench halloftearjerking_obj)

;	(sleep_until (volume_test_players 120_07_outside_trig) 1)
	(sleep_until (volume_test_objects 120_07_hall_explosion06 obj_arbiter) 1)
	(ai_set_objective arbiter_trench cliff_exit_obj)

	(sleep_until (volume_test_players 120_07_outside_trig) 1)
	(sound_looping_set_alternate levels\solo\120_halo\music\120_music_13 TRUE)
	
	(ai_dialogue_enable FALSE)
	(if dialogue (print "ARBITER: Even in death, your Sergeant guides us home!."))
	(sleep (ai_play_line arbiter_actor 120VC_050))
	(sleep 60)
	(if dialogue (print "CORTANA: The frigate! We still have a chance!"))
	(sleep (ai_play_line_on_object NONE 120ME_240))
	(sleep 10)	
	(if dialogue (print "CORTANA: The frigate! We still have a chance!"))
	(sleep (ai_play_line_on_object NONE 120ME_250))
	(sleep 10)		
	(ai_dialogue_enable TRUE)
)

(script dormant rock_fall01
	(sleep_until
		(begin
			(print "begin phase 1 rocks")		
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall01" cliff01)
			(sleep (random_range 15 60))
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall01" cliff01)
			(sleep (random_range 15 60))
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall01" cliff01)
		FALSE)
	(random_range 60 90))
)
(script dormant rock_fall02
	(sleep_until (volume_test_players 120_07_cliff_section_start)5)
	(sleep_until
		(begin
			(print "begin phase 2 rocks")
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall02" cliff02)
			(sleep (random_range 0 30))
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall02" cliff02)
			(sleep (random_range 0 30))
			(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall02" cliff02)
		FALSE)
	)
)

(script dormant rock_fall03
	(sleep_until (volume_test_players 120_07_cliff_section01)5)
	(sleep_until
		(begin
			(if (volume_test_players_all 120_07_cliff_section02)
				(begin
					(print "begin phase 3 rocks")
					(effect_new_random  "levels\solo\120_halo\fx\exit_run_rocks\rock_fall03" cliff03)
					(sleep (random_range 0 30))
					(sleep (random_range 0 30))
					(sleep (random_range 0 30))
				)
			)			
		FALSE)
	(random_range 30 90))
)


(script dormant md_07_3_cortana_hints
	(sleep_until (volume_test_players 120_07_cliff_section01)5 900)

	(ai_dialogue_enable FALSE)	
	(set good_guys_talking TRUE)
	(sleep 15)							
	(if dialogue (print "CORTANA: Find the doorway in the cliffs, Chief! The Dawn is on the other side!"))
	(sleep (ai_play_line_on_object NONE 120ME_280))
	(set good_guys_talking FALSE)	
	(sleep 10)
	(ai_dialogue_enable TRUE)
	
	(sleep 900)
	
	(ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep 15)					
	(if dialogue (print "CORTANA: See that doorway further on? Get to it!"))
	(sleep (ai_play_line_on_object NONE 120ME_270))
	(set good_guys_talking FALSE)	
	(ai_dialogue_enable TRUE)
				
)

(script dormant md_08_cortana_hints
	(sleep_until (volume_test_players 120_07_c_hall02))
	(ai_dialogue_enable FALSE)

;*	(set good_guys_talking TRUE)
	(sleep 15)		
	(if dialogue (print "CORTANA: Keep moving, Chief! There's no time!"))
	(sleep (ai_play_line_on_object NONE 120MF_090))
	(set good_guys_talking FALSE)		
	(sleep 600)
	(set good_guys_talking TRUE)
	(sleep 15)		
	(if dialogue (print "CORTANA: Chief! We have to move! Now!"))
	(sleep (ai_play_line_on_object NONE 120MF_100))
	(set good_guys_talking FALSE)		
	(sleep 600)
	(set good_guys_talking TRUE)
*;
	(sleep 15)		
	(if dialogue (print "CORTANA: Don't let this ring be the end of us, Chief!!"))
	(sleep (ai_play_line_on_object NONE 120MF_110))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
)

(script dormant md_09_cortana_hints
    (sleep_until (volume_test_players 120_07_c_hall_end) 5)
	(set good_guys_talking TRUE)
	
	(ai_dialogue_enable FALSE)
	(sleep 15)		
	(if dialogue (print "CORTANA: There!  Johnson's Warthog!"))
	(sleep (ai_play_line_on_object NONE 120MG_010))
;	(sleep 10)		
;	(if dialogue (print "CORTANA: He may save us yet…"))
;	(sleep (ai_play_line_on_object NONE 120MG_020))
	(sleep_until (volume_test_players 120_08_trench_encounter_100)5 600)
	(if (not (volume_test_players 120_08_trench_encounter_100))
		(begin
			(set good_guys_talking TRUE)
			(sleep 15)
			(if dialogue (print "CORTANA: Drive, Chief! Head for the frigate!"))
			(set good_guys_talking FALSE)					
		)
	)
	(sleep_until (volume_test_players 120_08_trench_encounter_100))	
	(sleep (ai_play_line_on_object NONE 120MG_030))
	(set good_guys_talking FALSE)
	(sleep 900)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: The Dawn is close! We can make it!"))
	(sleep (ai_play_line_on_object NONE 120MG_040))
	(if dialogue (print "CORTANA: As long as the ground doesn't fall out beneath us!"))
	(sleep (ai_play_line_on_object NONE 120MG_050))	
	(set good_guys_talking FALSE)
	(sleep 900)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: The charging sequence -- it's too much for the ring to take!!"))
	(sleep (ai_play_line_on_object NONE 120MG_060))
	(set good_guys_talking FALSE)
	(sleep 900)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Halo's ripping itself apart!"))
	(sleep (ai_play_line_on_object NONE 120MG_070))
	(set good_guys_talking FALSE)
	(sleep 900)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Hurry, Chief! Don't stop!"))
	(sleep (ai_play_line_on_object NONE 120MG_080))
	(set good_guys_talking FALSE)
	(sleep 900)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Keep going! Faster!"))
	(sleep (ai_play_line_on_object NONE 120MG_090))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
)

(script dormant md_cortana_countdown
	(sleep_until (volume_test_players trench_run_110_trig09)5)
	(sleep_forever md_09_cortana_hints)
	(ai_dialogue_enable FALSE)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Charging sequence at 30 percent!"))
	(sleep (ai_play_line_on_object NONE 120MG_100))
	(set good_guys_talking FALSE)
	
	(sleep_until (volume_test_players trench_run_110_island_trig02)5)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: 50 percent, Chief!"))
	(sleep (ai_play_line_on_object NONE 120MG_110))
	(set good_guys_talking FALSE)

	(sleep_until (volume_test_players 120_08_trench_encounter_120)5)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: 70 percent!"))
	(sleep (ai_play_line_on_object NONE 120MG_120))
	(set good_guys_talking FALSE)

	(sleep_until (volume_test_players trench_run_120_trig02)5)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: 80 percent charged!"))
	(sleep (ai_play_line_on_object NONE 120MG_130))
	(set good_guys_talking FALSE)

	(sleep_until (volume_test_players trench_run_120_trig10)5)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: 90 percent! Firing sequence initiated!"))
	(sleep (ai_play_line_on_object NONE 120MG_140))
	(set good_guys_talking FALSE)

	(sleep_until (volume_test_players trench_run_120_trig14)5)
	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Gun it, Chief! Jump!"))
	(sleep (ai_play_line_on_object NONE 120MG_150))

	(if dialogue (print "CORTANA: Floor it! Right into the hangar!"))
	(sleep (ai_play_line_on_object NONE 120MG_160))
	(set good_guys_talking FALSE)
	(ai_dialogue_enable TRUE)
			
)	

(script dormant md_gravemind01
	(ai_dialogue_enable FALSE)
	(sleep 60)
	
		(if dialogue (print "GRAVEMIND: (lengthy roar)"))
			(ai_play_line_on_object gr_01_spkr_01 120MC_010)	        
			(ai_play_line_on_object gr_01_spkr_02 120MC_010)	        
		(sleep (ai_play_line_on_object gr_01_spkr_03 120MC_010))
		(sleep 15)
		
		(if dialogue (print "GRAVEMIND: Did you think me defeated?!"))				        
			(ai_play_line_on_object gr_01_spkr_01 120MC_020)	        
			(ai_play_line_on_object gr_01_spkr_02 120MC_020)	        
		(sleep (ai_play_line_on_object gr_01_spkr_03 120MC_020))
		(sleep 30)
		
		(if dialogue (print "CORTANA: Flood dispersal pods."))
		(sleep (ai_play_line_on_object NONE 120MC_030))
		(sleep 15)

		(if dialogue (print "CORTANA: Control room's at the top of that tower, Chief! Go!"))
		(sleep (ai_play_line_on_object NONE 120MC_040))
		(sleep 30)
		(set g_music_120_03 true) ; the other cortana dialog was cut, so here we are.
		(set g_music_120_02 false) ; the other cortana dialog was cut, so here we are.

	(ai_dialogue_enable TRUE)
)

(script dormant md_gravemind02
	(ai_dialogue_enable FALSE)
	(sleep 60)
	
		(if dialogue (print "GRAVEMIND: I have beaten fleets of thousands."))
			(ai_play_line_on_object gr_02_spkr_01 120MC_050)	        
		(sleep (ai_play_line_on_object gr_02_spkr_02 120MC_050))
		(sleep 15)
		
		(if dialogue (print "GRAVEMIND: Consumed a galaxy of flesh and mind and boners."))				        
			(ai_play_line_on_object gr_02_spkr_01 120MC_060)	        
		(sleep (ai_play_line_on_object gr_02_spkr_02 120MC_060))
		(sleep 30)
		
	(ai_dialogue_enable TRUE)
)

(script dormant md_gravemind03
	(sleep_until (volume_test_players 120_07_c_gravemind_03) 5)
	(ai_dialogue_enable FALSE)
	(sleep (random_range 30 60))
	
		(if dialogue (print "GRAVEMIND: Resignation is my virtue."))
			(ai_play_line_on_object gr_03_spkr_01 120MD_090)	        
			(ai_play_line_on_object gr_03_spkr_02 120MD_090)	        
		(sleep (ai_play_line_on_object gr_03_spkr_03 120MD_090))
		(sleep 15)
		
		(if dialogue (print "GRAVEMIND: Like water I ebb and flow."))				        
			(ai_play_line_on_object gr_03_spkr_01 120MD_100)	        
			(ai_play_line_on_object gr_03_spkr_02 120MD_100)	        
		(sleep (ai_play_line_on_object gr_03_spkr_03 120MD_100))
		(sleep 15)

		(if dialogue (print "GRAVEMIND: Defeat is simply the addition of time to a sentence I never deserved, but you imposed."))
			(ai_play_line_on_object gr_03_spkr_01 120MD_110)	        
			(ai_play_line_on_object gr_03_spkr_02 120MD_110)	        
		(sleep (ai_play_line_on_object gr_03_spkr_03 120MD_110))
		(sleep 30)
		
	(ai_dialogue_enable TRUE)
)

;*		
(script dormant md_gravemind02
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_030_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: She baited me with lies!"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_030_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_030))
			(sleep (random_range 120 240))		
	        (ai_dialogue_enable TRUE)
	        
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_040_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Brought me here to seal my doom?!"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_040_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_040))
			(sleep (random_range 120 240))
			(ai_dialogue_enable TRUE)
)
		
(script dormant md_gravemind03
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_060_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: I have spent eons waiting, watching, planning…"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_060_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_060))
			(sleep (random_range 120 240))		
			(ai_dialogue_enable TRUE)
			
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_070_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Will not again be torn asunder!"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_070_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_070))
			(sleep (random_range 120 240))		
			(ai_dialogue_enable TRUE)
			
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_080_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Not now that I am free -- not now that I am whole!"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_080_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_080))								
			(ai_dialogue_enable TRUE)
)

(script dormant md_gravemind04
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_090_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Resignation is my virtue…"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_090_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_090))
			(ai_dialogue_enable TRUE)
			
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_100_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Like water I ebb and flow."))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_100_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_100))
			(ai_dialogue_enable TRUE)
			
	(sleep_until (and (> (ai_nonswarm_count all) 0)(= good_guys_talking FALSE)))
	        (ai_dialogue_enable FALSE)
	        (sleep 30)
			(sound_impulse_start "sound\dialog\120_halo\mission\120MD_110_grv.sound" NONE 1)
			(if dialogue (print "GRAVEMIND: Defeat is simply the addition of time… To a sentence I never deserved but you imposed!"))
			(sleep (sound_impulse_time "sound\dialog\120_halo\mission\120MD_110_grv.sound"))	        
;			(sleep (ai_play_line all 120MD_110))
			(ai_dialogue_enable TRUE)
)
*;
(script dormant md_grunty_love
	(sleep_until (volume_test_players tv_grunty_love))
		(sleep 15)
	(if debug (print "play grunt love sound file"))
	(sound_impulse_start "sound\levels\120_halo\sound_scenery\grunty_love_story" grunty_love 1)
    (achievement_grant_to_player 0 _achievement_ace_final_grunt)
	(achievement_grant_to_player 1 _achievement_ace_final_grunt)
	(achievement_grant_to_player 2 _achievement_ace_final_grunt)
	(achievement_grant_to_player 3 _achievement_ace_final_grunt)
)

;*

in bowl 
-------
120mc_010 
120mc_020 
120mc_050 
120mc_060 


up zigg 
-------
md_030 
md_040 


further up the zigg 
-------------------
md_060 
md_070 
md_080 


afer johnson's dead, when player is on the ridgeline
md_090 
md_100 
md_110 

*;