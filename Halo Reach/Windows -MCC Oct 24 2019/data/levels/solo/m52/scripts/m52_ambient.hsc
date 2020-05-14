; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION MUSIC
; ===================================================================================================================================================
; ===================================================================================================================================================

(global short g_music_m52_01 0)
(global short g_music_m52_02 0)
(global short g_music_m52_03 0)
(global short g_music_m52_04 0)
(global short g_music_m52_05 0)
(global short g_music_m52_06 0)
(global short g_music_m52_07 0)
(global short g_music_m52_08 0)
(global short g_music_m52_09 0)



(script dormant m52_music_01
	(sleep_until (= g_music_m52_01 1))
	; (if debug ;(print "start music m52_01"))	
	(sound_looping_start levels\solo\m52\music\m52_music_01 NONE 1)

	(sleep_until (= g_music_m52_01 2))
	; (if debug ;(print "stop music m52_01"))
	(sound_looping_stop levels\solo\m52\music\m52_music_01)
)

(script dormant m52_music_02
	(sleep_until (= g_music_m52_02 1))
	; (if debug ;(print "start music m52_02"))
	(sound_looping_start levels\solo\m52\music\m52_music_02 NONE 1)

	(sleep_until (= g_music_m52_02 2))
	; (if debug ;(print "stop music m52_02"))
	(sound_looping_stop levels\solo\m52\music\m52_music_02)
)

(script dormant m52_music_03
	(sleep_until
		(begin
			(sleep_until (!= g_music_m52_03 -1)5)
			(if (= g_music_m52_03 1)
				(begin
					(print "STARTING ELEVATOR MUSIC")
					(sound_looping_start levels\solo\m52\music\m52_music_03 NONE 1)
					(set g_music_m52_03 -1)
				)
			)
			(if (= g_music_m52_03 2)
				(begin
					(print "STOPPING ELEVATOR MUSIC")
					(sound_looping_stop levels\solo\m52\music\m52_music_03)
					(set g_music_m52_03 -1)
				)
			)
	(= g_music_m52_03 3))
	5)

)

(script static void m52_really_stop
	; (if debug ;(print "REALLY stop music m52_03"))
	(sound_looping_stop levels\solo\m52\music\m52_music_03)	
	(set g_music_m52_03 3)
)
(script dormant m52_music_04
	(sleep_until (= g_music_m52_04 1))
	; (if debug ;(print "start music m52_04"))
	(sound_looping_start levels\solo\m52\music\m52_music_04 NONE 1)

	(sleep_until (= g_music_m52_04 2))
	; (if debug ;(print "stop music m52_04"))
	(sound_looping_stop levels\solo\m52\music\m52_music_04)
)

(script dormant m52_music_05
	(sleep_until (= g_music_m52_05 1))
	; (if debug ;(print "start music m52_05"))
	(sound_looping_start levels\solo\m52\music\m52_music_05 NONE 1)

	(sleep_until (= g_music_m52_05 2))
	; (if debug ;(print "stop music m52_05"))
	(sound_looping_stop levels\solo\m52\music\m52_music_05)
)

(script dormant m52_music_06
	(sleep_until (= g_music_m52_06 1))
	; (if debug ;(print "start music m52_06"))
	(sound_looping_start levels\solo\m52\music\m52_music_06 NONE 1)

	(sleep_until (= g_music_m52_06 2))
	; (if debug ;(print "start music m52_06"))
	(sound_looping_activate_layer levels\solo\m52\music\m52_music_06 1)

	(sleep_until (= g_music_m52_06 3))
	; (if debug ;(print "stop music m52_06"))
	(sound_looping_stop levels\solo\m52\music\m52_music_06)
	(sound_looping_deactivate_layer levels\solo\m52\music\m52_music_06 1)
)

(script dormant m52_music_07
	(sleep_until (= g_music_m52_07 1))
	; (if debug ;(print "start music m52_07"))
	(sound_looping_start levels\solo\m52\music\m52_music_07 NONE 1)

	(sleep_until (= g_music_m52_07 2))
	; (if debug ;(print "stop music m52_07"))
	(sound_looping_stop levels\solo\m52\music\m52_music_07)
)

(script dormant m52_music_08
	(sleep_until (= g_music_m52_08 1))
	; (if debug ;(print "start music m52_08"))
	(sound_looping_start levels\solo\m52\music\m52_music_08 NONE 1)

	(sleep_until (= g_music_m52_08 2))
	; (if debug ;(print "stop music m52_08"))
	(sound_looping_stop levels\solo\m52\music\m52_music_08)
)
(script dormant m52_music_09
	(sleep_until (= g_music_m52_09 1))
	; (if debug ;(print "start music m52_09"))
	(sound_looping_start levels\solo\m52\music\m52_music_09 NONE 1)

	(sleep_until (= g_music_m52_09 2))
	; (if debug ;(print "stop music m52_09"))
	(sound_looping_stop levels\solo\m52\music\m52_music_09)
)

(script static void kill_music
	(sound_looping_stop levels\solo\m52\music\m52_music_01)
	(sound_looping_stop levels\solo\m52\music\m52_music_02)
	(sound_looping_stop levels\solo\m52\music\m52_music_03)
	(sound_looping_stop levels\solo\m52\music\m52_music_04)
	(sound_looping_stop levels\solo\m52\music\m52_music_05)
	(sound_looping_stop levels\solo\m52\music\m52_music_06)
	(sound_looping_stop levels\solo\m52\music\m52_music_07)
	(sound_looping_stop levels\solo\m52\music\m52_music_08)
	(sound_looping_stop levels\solo\m52\music\m52_music_09)
)									
;====================================================================================================================================================================================================
;================================== CINEMATICS ================================================================================================================================================
;====================================================================================================================================================================================================


(script static void m52_cin_intro
	;(print "m52 intro cinematic")
	(weather_animate_force cine_rain 1 0)
	(f_start_mission 052la_airlift)
	
)
							
(script dormant m52_cin_end
	;(print "m52 end cinematic")
	(cinematic_enter 052lb_reflection false)
	(sleep_forever weather_lightning)
	(zone_set_trigger_volume_enable zone_set:m52_040_oni FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)
	(sleep_forever banshee_spawn)	
	(sleep_forever f_ground_fx_ambient)
	(sleep_forever f_ground_fx_ambient_2)
	(sleep_forever player0_evac_nanny)
	(sleep_forever player1_evac_nanny)
	(sleep_forever player2_evac_nanny)
	(sleep_forever player3_evac_nanny)			
	(sleep_forever low_flying_volume_player0)	
	(sleep_forever low_flying_volume_player1)
	(sleep_forever low_flying_volume_player2)
	(sleep_forever low_flying_volume_player3)
	(sleep_forever m52_building_fall)
	(sleep_forever level_checkpoint)
	(sleep_forever m52_covenant_cruiser_vignette)	
	(sleep_forever player0_evac_reminder)
	(sleep_forever player1_evac_reminder)
	(sleep_forever player2_evac_reminder)
	(sleep_forever player3_evac_reminder)	
	(sleep_forever falcon_patrol)
	(sleep_forever pelican_patrol)		
	(sleep_forever phantom_patrol)
	(sleep_forever sec_obj_alpha)		
	(sleep_forever sec_obj_beta)
	(sleep_forever sec_obj_gamma)	
	(sleep_forever sec_obj_delta)
	(sleep_forever building_c_elev01)
	(sleep_forever building_c_elev02)		
	(sleep_forever disco_fever)
	(sleep_forever aj_mode)
	(sleep_forever vehicle_reserve00)
	(sleep_forever vehicle_reserve01)	
	(sleep_forever vehicle_reserve02)	
	(sleep_forever vehicle_reserve03)
  (sleep_forever hud_object_bldg_oni_pad)
  (sleep_forever banshee_cleanup)
  ;(sleep_forever elevator_no_spawn)	 
  (sleep_forever player_training00)
	(sleep_forever player_training01)
	(sleep_forever player_training02)
	(sleep_forever player_training03)
	(sleep_forever falcon_start1_nanny)
	(sleep_forever falcon_start2_nanny)	
	(sleep_forever falcon_a1_nanny)
	(sleep_forever falcon_a2_nanny)
	(sleep_forever falcon_b1_nanny)
	(sleep_forever falcon_b2_nanny)
	(sleep_forever falcon_c1_nanny)
	(sleep_forever falcon_c2_nanny)	
	(sleep_forever f_player0_flying)
	(sleep_forever f_player1_flying)
	(sleep_forever f_player2_flying)
	(sleep_forever f_player3_flying)
	(sleep_forever building_c_horrible_kill01)
	(wake teleport_players)	
	(weather_animate_force off 1 0)	
	(flock_stop banshees_1)
	(flock_stop banshees_2)
	(flock_stop banshees_3)
	(flock_stop falcons_1)
	(flock_stop falcons_2)
	(flock_stop falcons_3)
	(flock_destroy banshees_1)
	(flock_destroy banshees_2)
	(flock_destroy banshees_3)
	(flock_destroy falcons_1)
	(flock_destroy falcons_2)
	(flock_destroy falcons_3)				
	(set g_prev_mission 10)
	(object_removal)
	(f_end_mission
			052lb_reflection
			m52_end_cinematic
	)
	;(print "GAME")
	(game_won)
	;(print "WON")
)

(script dormant teleport_players
	(sleep 90)
	(f_player_teleport player0 ins_start_player_00 false)		
	(f_player_teleport player1 ins_start_player_01 false)
	(f_player_teleport player2 ins_start_player_02 false)		
	(f_player_teleport player3 ins_start_player_03 false)			
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================
(global boolean g_intro_dialog_played FALSE)
(script dormant md_000_initial
	(if (!= m_progression 0) ; for insertion reasons
		(begin
			(sleep 120)
			;(print "KAT: Put your wings back on, Lieutenant. You're flying this Falcon.")	
				(f_md_object_play 5 none m52_0010)	
				(set g_music_m52_01 1)						
			(sleep 120)
			(if 
					(= (f_players_flying) false)
				(begin				
					;(print "KAT: Here's the situation: Covenant have deployed multiple, long-range comm-jammers in hi-rises across the city.")
						(f_md_object_play 5 none m52_0020)
						
					;(print "KAT: We can't hear Holland and he can't hear us.  We're totally cut off.")
						(f_md_object_play 5 none m52_0030)
		
					;(print "KAT: Trooper squads have been trying to take the jammers out, but the Coveys are dug in tight.")
						(f_md_object_play 5 none m52_0040)
		
					;(print "KAT: When I confirm targets, I need you to hit ‘em.  Hard..")
						(f_md_object_play 5 none m52_0050)
				)
				(begin
					;(print "KAT: Covenant have deployed comm-jammers in hi-rises across the city. When I find them, you hit 'em. Hard.")	
						(f_md_object_play 5 none m52_0060)
				)				
			)	
			(sleep 90)
						
			(set g_intro_dialog_played TRUE)

			(branch 		
				(= (f_players_flying) true)
				(f_md_abort)
			)
			(sleep 600)
			
			;(print "KAT: Falcon's all yours, Six. Jump in.")
				(f_md_object_play 5 none m52_0070)
			(sleep 900)
			
			;(print "KAT: Six, you're flying the Falcon! Go!")
				(f_md_object_play 5 none m52_0080)
								
		)
	)
)

(global short s_player0_training_progress 0)
(global short s_player1_training_progress 0)
(global short s_player2_training_progress 0)
(global short s_player3_training_progress 0)


(script static void (f_falcon_flight_training (player player_num))
	(if
		(and
			(or
				(unit_action_test_grenade_trigger player_num)
				(unit_action_test_melee player_num)
			)
			(= (unit_in_vehicle_type player_num g_falcon_type) TRUE)	
			(f_vehicle_pilot_seat player_num)
		)
		(begin
			;(print "PLAYER HAS LEARNED TO FLY")
			(if (= player_num player0)(set s_player0_training_progress 1))
			(if (= player_num player1)(set s_player1_training_progress 1))
			(if (= player_num player2)(set s_player2_training_progress 1))
			(if (= player_num player3)(set s_player3_training_progress 1))
			(f_hud_training_clear player_num)
		)
		(if (f_vehicle_pilot_seat player_num)
			(begin
				(unit_action_test_reset player_num)	
				(f_hud_training_forever player_num ct_falcon_training_fly)
			)
			(f_hud_training_clear player_num)
		)
	)
)


(script static void (f_falcon_flight_attack (player player_num))	
	(if
		(and
			(unit_action_test_primary_trigger player_num)
			(= (unit_in_vehicle_type player_num g_falcon_type) TRUE)
			(f_vehicle_pilot_seat player_num)
		)
		(begin
			;(print "PLAYER HAS LEARNED TO SHOOT")
			(if (= player_num player0)(set s_player0_training_progress 2))
			(if (= player_num player1)(set s_player1_training_progress 2))
			(if (= player_num player2)(set s_player2_training_progress 2))
			(if (= player_num player3)(set s_player3_training_progress 2))
			(f_hud_training_clear player_num)
		)
		(if (f_vehicle_pilot_seat player_num)
			(begin
				(unit_action_test_reset player_num)	
				(f_hud_training_forever player_num ct_falcon_training_attack)
			)
			(f_hud_training_clear player_num)
		)
	)
)
(script static void (f_falcon_flight_hold (player player_num))
	(if
		(and
			(unit_action_test_vehicle_trick_primary player_num)
			(f_vehicle_pilot_seat player_num)
			(= (unit_in_vehicle_type player_num g_falcon_type) TRUE)
		)
		(begin
			;(print "PLAYER HAS LEARNED TO HOLD")
			(if (= player_num player0)(set s_player0_training_progress 3))
			(if (= player_num player1)(set s_player1_training_progress 3))
			(if (= player_num player2)(set s_player2_training_progress 3))
			(if (= player_num player3)(set s_player3_training_progress 3))
			(f_hud_training_clear player_num)
		)
		(if (f_vehicle_pilot_seat player_num)
			(begin	
				(unit_action_test_reset player_num)			
				(f_hud_training_forever player_num ct_falcon_training_lock)
			)
			(f_hud_training_clear player_num)
		)
	)
)


(script dormant player_training00			
	(sleep_until
		(begin
			(if (= (f_vehicle_pilot_seat player0) false)
				(f_hud_training_clear player0)
				(begin
					(cond
						((= s_player0_training_progress 0)
							(begin		
								(f_falcon_flight_training player0)
								;(print "PLAYER0 LEARNING TO FLY")
							)
						)
						((= s_player0_training_progress 1)
							(begin
								(sleep 30)
								(f_falcon_flight_attack player0)
								;(print "PLAYER0 LEARNING TO SHOOT")
							)
						)
						((= s_player0_training_progress 2)
							(begin
								(sleep 30)
								(f_falcon_flight_hold player0)
								;(print "PLAYER0 LEARNING TO HOLD")
							)
						)
						((= (f_vehicle_pilot_seat player0) false)
							(f_hud_training_clear player0)
						)
					)
				)
			)
		(= s_player0_training_progress 3))
	5)
	;(print "player0 training complete")
)
(script dormant player_training01				
	(sleep_until
		(begin
			(if (= (f_vehicle_pilot_seat player1) false)
				(f_hud_training_clear player1)
				(begin
					(cond
						((= s_player1_training_progress 0)
							(begin
								(sleep 30)			
								(f_falcon_flight_training player1)
								;(print "player1 LEARNING TO FLY")
							)
						)
						((= s_player1_training_progress 1)
							(begin
								(sleep 30)
								(f_falcon_flight_attack player1)
								;(print "player1 LEARNING TO SHOOT")
							)
						)
						((= s_player1_training_progress 2)
							(begin
								(sleep 30)
								(f_falcon_flight_hold player1)
								;(print "player1 LEARNING TO HOLD")
							)
						)
						((= (f_vehicle_pilot_seat player1) false)
							(f_hud_training_clear player1)
						)
					)
				)
			)
		(= s_player1_training_progress 3))
	5)
	;(print "player1 training complete")
)
(script dormant player_training02				
	(sleep_until
		(begin
			(if (= (f_vehicle_pilot_seat player2) false)
				(f_hud_training_clear player2)
				(begin
					(cond
						((= s_player2_training_progress 0)
							(begin
								(sleep 30)			
								(f_falcon_flight_training player2)
								;(print "player2 LEARNING TO FLY")
							)
						)
						((= s_player2_training_progress 1)
							(begin
								(sleep 30)
								(f_falcon_flight_attack player2)
								;(print "player2 LEARNING TO SHOOT")
							)
						)
						((= s_player2_training_progress 2)
							(begin
								(sleep 30)
								(f_falcon_flight_hold player2)
								;(print "player2 LEARNING TO HOLD")
							)
						)
						((= (f_vehicle_pilot_seat player2) false)
							(f_hud_training_clear player2)
						)					
					)
				)
			)
		(= s_player2_training_progress 3))
	5)
	;(print "player2 training complete")
)
(script dormant player_training03
	(sleep_until
		(begin
			(if (= (f_vehicle_pilot_seat player3) false)
				(f_hud_training_clear player3)
				(begin
					(cond
						((= s_player3_training_progress 0)
							(begin
								(sleep 30)			
								(f_falcon_flight_training player3)
								;(print "player3 LEARNING TO FLY")
							)
						)
						((= s_player3_training_progress 1)
							(begin
								(sleep 30)
								(f_falcon_flight_attack player3)
								;(print "player3 LEARNING TO SHOOT")
							)
						)
						((= s_player3_training_progress 2)
							(begin
								(sleep 30)
								(f_falcon_flight_hold player3)
								;(print "player3 LEARNING TO HOLD")
							)
						)
						((= (f_vehicle_pilot_seat player3) false)
							(f_hud_training_clear player3)
						)				
					)
				)
			)
		(= s_player3_training_progress 3))
	5)
	;(print "player3 training complete")
)


(script dormant hud_object_bldg_a
	; enables the mission objective blip
	(f_blip_flag cf_pri_bldg_a_reminder 21)

	(f_hud_obj_new ct_objective_bldg_a PRIMARY_OBJECTIVE_1)
	
	(sleep_until 
		(or
			(objects_can_see_flag player0 cf_pri_bldg_a_reminder 20)
			(objects_can_see_flag player1 cf_pri_bldg_a_reminder 20)
			(objects_can_see_flag player2 cf_pri_bldg_a_reminder 20)
			(objects_can_see_flag player3 cf_pri_bldg_a_reminder 20)
		 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 cf_pri_bldg_a_reminder) 50)
				(= (objects_distance_to_flag player0 cf_pri_bldg_a_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player1 cf_pri_bldg_a_reminder) 50)
				(= (objects_distance_to_flag player1 cf_pri_bldg_a_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player2 cf_pri_bldg_a_reminder) 50)
				(= (objects_distance_to_flag player2 cf_pri_bldg_a_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player3 cf_pri_bldg_a_reminder) 50)
				(= (objects_distance_to_flag player3 cf_pri_bldg_a_reminder) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_bldg_a_highlight)
			(f_blip_title sc_bldg_a_box "WP_CALLOUT_M52_HOSPITAL")
		)
	)
)

(script dormant md_010_bldg_a
	(sleep_until 
		(and
			(= g_intro_dialog_played TRUE)
			(= b_is_dialogue_playing false)
		)
 5)
	;(print "KAT: Stand by, Six... One of our trooper squads went silent after the hospital got hit. I'll mark the location.")				
		(f_md_object_play 5 none m52_0440)
	;(print "KAT: Complete their mission, and take out the jammer.")				
		(f_md_object_play 5 none m52_0450)			

	(if (= m_progression 1)
		(begin
			;(print "KAT: This is the last jammer, Six. You're almost there!")		
			(f_md_object_play 5 none m52_0790)
		)
	)		

	(wake hud_object_bldg_a)	
	; opens the doors to the mission
	(set g_mission_unlock 1)
	

		(wake md_010_bldg_a_land)
)
		
(script dormant md_010_bldg_a_land
	(sleep_until 
		(and 
			(= b_is_dialogue_playing false)
			(>= obj_control_bldg_a 13)
		)
	5)
		
		;(print "FEM02: Contacts!  Two and ten o’clock!  I’ll hold them off until you can get to the other side!")	
			(f_md_object_play 5 none m52_0460)

		;(print "TROOPER1: Through that doorway!  Move, move, move!")	
			(f_md_object_play 5 none m52_0470)


	(sleep_until (>= obj_control_bldg_a 20)5)

		;(print "FEM02: More Brutes!  Stay back, you bastards!")	
			(f_md_object_play 5 none m52_0480)
			(set g_music_m52_02 1)
;		;(print "TROOPER1: Engage!  Engage!  We gotta fight through to that jammer!")	
;			(f_md_object_play 5 none m52_0490)

)

(script dormant md_010_bldg_a_troopers
	(sleep_until 
		(and
			(>= obj_control_bldg_a 50)
			(= b_is_dialogue_playing false)
		)
	5)

		;(print "FEM02:I said BACK OFF, ya nasty son of a bitch!")	
			(f_md_ai_play 5 ai_bldga_fem02 m52_0500)
			;(f_md_object_play 5 none m52_0500)		

		;(print "BRUTE1:RAHR")	
			(f_md_ai_play 5 sq_bldg_a_actor02 m52_0510)	
			;(f_md_object_play 5 none m52_0510)	
		;(print "TROOPER1:Go ahead and try it!")	
			(f_md_ai_play 5 ai_bldga_trooper01 m52_0520)
			;(f_md_object_play 5 none m52_0520)	
	
	; sleep until brutes are dead, mission dialog is not playing and the player is in a trigger volume
	(sleep_until
		(and
			(<= (ai_living_count sq_bldg_a_07) 0)
			(<= (ai_living_count sq_bldg_a_08) 0)
			(<= (ai_living_count sq_bldg_a_actor01) 0)
			(= b_is_dialogue_playing false)
			(volume_test_players tv_bldg_a_troopers)
		)
	5)
	(if (> (ai_living_count ai_bldga_fem02) 0)
		(begin
			;(print "FEM02: Thanks for the assist, Spartan!")	
				(f_md_ai_play 5 ai_bldga_fem02 m52_0530)
				;(f_md_object_play 5 none m52_0530)		
		)
		(begin
			;(print "FEM02: Thanks for the assist, Spartan!")			
				(f_md_ai_play 5 ai_bldga_trooper01 m52_0540)
				;(f_md_object_play 5 none m52_0540)
		)
	)
)

(script dormant hud_object_bldg_a_obj


	(sleep 30)
	;sleep until player can see the object within an FOV of 20
	(sleep_until
			(or
				(objects_can_see_object player0 sc_bldg_a_high_obj 20)
				(objects_can_see_object player1 sc_bldg_a_high_obj 20)
				(objects_can_see_object player2 sc_bldg_a_high_obj 20)
				(objects_can_see_object player3 sc_bldg_a_high_obj 20)
			 )
	5)
	(if 
			(and
				(> (objects_distance_to_object player0 sc_bldg_a_high_obj) 5)
				(> (objects_distance_to_object player1 sc_bldg_a_high_obj) 5) 
				(> (objects_distance_to_object player2 sc_bldg_a_high_obj) 5) 
				(> (objects_distance_to_object player3 sc_bldg_a_high_obj) 5) 
			)	
	(f_hud_flash_object sc_bldg_a_high_obj)
	
	)
)

(script dormant md_010_bldg_a_end
	
	(branch 		
		(= (f_objective_complete dm_building_a_objective dc_objective_a_switch) TRUE)
		(f_md_abort)
	)

	(sleep_until
		(and
			(>= obj_control_bldg_a 60)
			(<= (ai_living_count sq_bldg_a_actor01) 0)
			(= b_is_dialogue_playing false)
			(volume_test_players tv_bldg_a_troopers)
		)
	5)
	;(print "OBJECTIVE REMINDER")
	; if the shields are not down, play dialog

	(sleep 150)
	(if (> (ai_living_count ai_bldga_fem02) 0)
		(begin	
			;(print "FEM02:Jammer’s right over here!")	
				(f_md_ai_play 5 ai_bldga_fem02 m52_0550)
				;(f_md_object_play 5 none m52_0550)
		)
		(if (> (ai_living_count ai_bldga_trooper01) 0)
			(begin
				;(print "TROOPER01:Jammer’s right over here!")	
					(f_md_ai_play 5 ai_bldga_trooper01 m52_0560)
					;(f_md_object_play 5 none m52_0560)
			)
			(if 
				(and
					(<= (ai_living_count ai_bldga_trooper01) 0)
					(<= (ai_living_count ai_bldga_fem02) 0)
				)
				(begin
					;(print "KAT: Eyes peeled, Six. Jammer should be in your immediate vicinity.")	
					(f_md_object_play 5 none m52_0570)
				)
			)
		)
	)
)

(script dormant md_010_bldg_a_complete	

	; sleep_until the player destroys the device
	(sleep_until (= (f_objective_complete dm_building_a_objective dc_objective_a_switch) TRUE))
	(sleep 90)
	;(print "KAT: Noble Two to Noble Six: I'm showing the hospital jammer offline.  Nice work.  Soon as you can, I need you back in your Falcon.")
		(f_md_object_play 5 none m52_0700)

		(branch 		
			(= (f_bsp_all_player 2) false)
			(f_md_abort)
		)
				
	(sleep_until (> (ai_living_count gr_bldg_a_jetpack) 0)5)
	
	(sleep 15)
	;(print "KAT: Noble Two to Noble Six: you've got incoming tangos!")	
		(f_md_object_play 5 none m52_0710)
	
	(sleep_until
		(and 		
			(objects_can_see_object (player0) (ai_get_object gr_bldg_a_jetpack) 15) 
			(<= (objects_distance_to_object (player0) (ai_get_object gr_bldg_a_jetpack)) 40) 
		)
	5 300)
	(if (> (ai_living_count gr_bldg_a_jetpack) 0)
		(begin
			;(print "FEM02:We got jumpers!")	
				(f_md_ai_play 5 ai_bldga_fem02 m52_0720)
				;(f_md_object_play 5 none m52_0720)
			(sleep 150)
		)
	)
	(sleep_until
		(and 		
			(objects_can_see_object (player0) (ai_get_object gr_bldg_a_jetpack) 15) 
			(<= (objects_distance_to_object (player0) (ai_get_object gr_bldg_a_jetpack)) 40) 
		)
	5 300)
	(if (> (ai_living_count gr_bldg_a_jetpack) 0)
		(begin					
			;(print "TROOPER01:Damn!  Look at them move!")	
				(f_md_ai_play 5 ai_bldga_trooper01 m52_0730)
				;(f_md_object_play 5 none m52_0730)
		)
	)
				
	(sleep_until (< (ai_living_count gr_bldg_a_return) 1)5)
		(sleep 150)
		(if (> (ai_living_count ai_bldga_fem02) 0)		
			(if (not (player_has_female_voice player0))	
				(begin		
					;(print "FEM02:We're good here, sir! You can head back to your bird!!")	
						(f_md_ai_play 5 ai_bldga_fem02 m52_0660)
						;(f_md_object_play 5 none m52_0660)
				)
				(begin
					;(print "FEM02: We're good here, ma'am! You can head back to your bird!")
						(f_md_ai_play 5 ai_bldga_fem02 m52_0670)
						;(f_md_object_play 5 none m52_0670)
				)
			)
			(if (not (player_has_female_voice player0))	
				(begin		
					;(print "TROOPER01:We're good here, sir! You can head back to your bird!!")	
						(f_md_ai_play 5 ai_bldga_trooper01 m52_0680)
						;(f_md_object_play 5 none m52_0680)	
				)
				(begin
					;(print "TROOPER01: We're good here, ma'am! You can head back to your bird!")
						(f_md_ai_play 5 ai_bldga_trooper01 m52_0690)
						;(f_md_object_play 5 none m52_0690)		
				)
			)										
		)
										
)


(script dormant md_020_bldg_b
	(sleep_until 
		(and
			(= g_intro_dialog_played TRUE)
			(= b_is_dialogue_playing false)
		)
	5)
	;(print "TROOPER(RADIO): Four Charlie Two Seven to Command!  Request immediate assistance!")	
		(f_md_object_play 5 none m52_0130)
	
	;(print "KAT: Go ahead, Two Seven.")		
		(f_md_object_play 5 none m52_0140)
	
	;(print "We're at the Vyrant Telecom Tower!  Got Hunters between us and the jammer!")			
		(f_md_object_play 5 none m52_0150)

	;(print "KAT(RADIO): Copy, Two Seven; help is on the way.  Noble Six, I'm sending you coordinates for the Vyrant Tower.  Go get those troopers unstuck.")		
		(f_md_object_play 5 none m52_0160)	
 	; if this is the first mission and if anyone is not in the mission space
 	(if 
 		(and 
 			(= m_progression 3)
 			(= (f_bsp_any_player 3) false)
 		)
		(begin
			(sleep 60)		
			;(print "KAT: Oh, and don't fall in love with my voice -- the closer you get to a jammer, the worse our reception's gonna get.  Kat out.")		
			 (f_md_object_play 5 none m52_0170)	
		)
	)
	(if (= m_progression 1)
		(begin
			;(print "KAT: This is the last jammer, Six. You're almost there!")		
			(f_md_object_play 5 none m52_0790)
		)
	)

	 (wake hud_object_bldg_b)

	; unlocks the doors to the mission
 	(set g_mission_unlock 2)
 	(wake md_020_bldg_b_land)			
	
)

(script dormant hud_object_bldg_b
	(f_blip_flag cf_pri_bldg_b_reminder 21)
 	
	(f_hud_obj_new ct_objective_bldg_b PRIMARY_OBJECTIVE_2)	
	(sleep_until 
		(or
			(objects_can_see_flag player0 cf_pri_bldg_b_reminder 20)
			(objects_can_see_flag player1 cf_pri_bldg_b_reminder 20)
			(objects_can_see_flag player2 cf_pri_bldg_b_reminder 20)
			(objects_can_see_flag player3 cf_pri_bldg_b_reminder 20)
		 )
	)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 cf_pri_bldg_b_reminder) 50)
				(= (objects_distance_to_flag player0 cf_pri_bldg_b_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player1 cf_pri_bldg_b_reminder) 50)
				(= (objects_distance_to_flag player1 cf_pri_bldg_b_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player2 cf_pri_bldg_b_reminder) 50)
				(= (objects_distance_to_flag player2 cf_pri_bldg_b_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player3 cf_pri_bldg_b_reminder) 50)
				(= (objects_distance_to_flag player3 cf_pri_bldg_b_reminder) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_bldg_b_highlight)
			(f_blip_title sc_bldg_b_box "WP_CALLOUT_M52_NIGHT_CLUB")
		)
	)
)

(script dormant md_020_bldg_b_land

	(sleep_until (volume_test_players tv_bldg_b_interior_start)5)		
	(sleep_until (= b_is_dialogue_playing false)5)
  ;(print "MARINE: Fall back, Four Delta!  Fall back!  Defensive positions!")	
	(f_md_ai_play 5 ai_bldgb_trooper02 m52_0180)	
	
  ;(print "MARINE: Go!  We'll cover you!")	
	(f_md_ai_play 5 ai_bldgb_trooper04 m52_0190)
	(set g_music_m52_06 2)
	; if the player is in the front area, but not in the space itself for pacing
	(sleep (random_range 120 240))
		;(print "TROOPER: Stay down! We just gotta hold out a little longer!")	
		;(f_md_object_play 5 none m52_0200)
		(f_md_ai_play 5 ai_bldgb_trooper04 m52_0200)
)
	
(script dormant hud_object_bldg_b_obj
	(sleep_until
			(or
				(objects_can_see_object player0 sc_bldg_b_high_obj 20)
				(objects_can_see_object player1 sc_bldg_b_high_obj 20)
				(objects_can_see_object player2 sc_bldg_b_high_obj 20)
				(objects_can_see_object player3 sc_bldg_b_high_obj 20)
			 )
	5)
	(if 
			(and
				(> (objects_distance_to_object player0 sc_bldg_b_high_obj) 5)
				(> (objects_distance_to_object player1 sc_bldg_b_high_obj) 5) 
				(> (objects_distance_to_object player2 sc_bldg_b_high_obj) 5) 
				(> (objects_distance_to_object player3 sc_bldg_b_high_obj) 5) 
			)	
	(f_hud_flash_object sc_bldg_b_high_obj)
	)
)
(script dormant md_020_bldg_b_troopers
	(branch 		
		(f_objective_complete dm_building_b_objective dc_objective_b_switch)
		(f_md_abort)
	)

	; sleeping when the player kills the hunters
	(sleep_until (< (ai_living_count gr_bldg_b) 1)5)

	; sleep until the dialog is not playing and the player is still in the bsp
		(sleep_until 
			(and 
				(= b_is_dialogue_playing false)
				(= (f_bsp_any_player 3) true)	
			)
		5)
		(sleep 30)	
		(if (> (ai_living_count ai_bldgb_trooper02) 0)
			(begin
				;(print "TROOPER4: That got 'em!  Over here, Spartan!")
					(f_md_ai_play 5 ai_bldgb_trooper02 m52_0210)
					;(f_md_object_play 5 none m52_0210)			
			)
			(if (> (ai_living_count ai_bldgb_trooper04) 0)
				(begin
					;(print "TROOPER2ALT: That got 'em!  Over here, Spartan!")
						(f_md_ai_play 5 ai_bldgb_trooper04 m52_0220)
						;(f_md_object_play 5 none m52_0220)	
				)
				(if 
					(and
						(<= (ai_living_count ai_bldgb_trooper02) 0)
						(<= (ai_living_count ai_bldgb_trooper04) 0)
					)		
					(begin
						;(print "KAT: Six?  EM activity suggests the jamming device is close to your position, up high.")	
							(f_md_object_play 5 none m52_0230)
						
					)
				)
			)
		)		

	
	; check to see if the shields are not down
	(if	(= (f_objective_complete dm_building_b_objective dc_objective_b_switch) FALSE)
		(begin
		; sleep until the dialog is not playing and the player is still in the bsp
			(sleep_until
				(and 
					(= b_is_dialogue_playing false)
					(= (f_bsp_any_player 3) true)
				)
			5)
		(if (> (ai_living_count ai_bldgb_trooper02) 0)
			(begin			
				;(print "TROOPER4: Thanks for the hand -- almost outta ammo.  Jammer's on the upper level!")	
					(f_md_ai_play 5 ai_bldgb_trooper02 m52_0240)
					;(f_md_object_play 5 none m52_0240)
			)
			(if (> (ai_living_count ai_bldgb_trooper04) 0)
				(begin
					;(print "TROOPER2ALT: Thanks for the hand -- almost outta ammo.  Jammer's on the upper level!")		
						(f_md_ai_play 5 ai_bldgb_trooper04 m52_0250)
						;(f_md_object_play 5 none m52_0250)
				)
			)
		)
	
			(sleep 300)
					
			;(print "TROOPER4: After you, Lieutenant.")	
				(f_md_ai_play 5 ai_bldgb_trooper02 m52_0260)
				;(f_md_object_play 5 none m52_0260)
				
			; reminder from the trooper part 2
			(sleep 300)	

			;(print "TROOPER2: Right behind you, Spartan.")	
				(f_md_ai_play 5 ai_bldgb_trooper04 m52_0270)	
				;(f_md_object_play 5 none m52_0270)
		)
	)	
	; player dallies for a long time
	; sleep 150 ticks or until the shields are down
	(sleep 150)
	
	; check to see if the shields are not down
	(if	(= (f_objective_complete dm_building_b_objective dc_objective_b_switch) FALSE)
		(begin
			(cond 
				((> (ai_living_count ai_bldgb_trooper02) 0)
					(if (not (player_has_female_voice player0))
						(begin
							;(print "TROOPER1: Jammer's above you, Sir!")	
								(f_md_ai_play 5 ai_bldgb_trooper02 m52_0280)
								;(f_md_object_play 5 none m52_0280)
						)
						(begin
							;(print "TROOPER1: Jammer's above you, Sir!")	
								(f_md_ai_play 5 ai_bldgb_trooper02 m52_0290)
								;(f_md_object_play 5 none m52_0290)
									;(print "TROOPER1: Jammer's above you, Maam!")	
						)
					)
				)
				((> (ai_living_count ai_bldgb_trooper04) 0)
					(if (not (player_has_female_voice player0))
						(begin
							;(print "TROOPER2: Jammer's above you, Sir!")	
								(f_md_ai_play 5 ai_bldgb_trooper04 m52_0300)
								;(f_md_object_play 5 none m52_0300)
						)
						(begin
							;(print "TROOPER2: Jammer's above you, Maam!")			
								(f_md_ai_play 5 ai_bldgb_trooper04 m52_0310)
								;(f_md_object_play 5 none m52_0310)
						)
					)
				)
				((and
						(<= (ai_living_count ai_bldgb_trooper02) 0)
						(<= (ai_living_count ai_bldgb_trooper04) 0)
					)
					(begin
						;(print "KAT: Scans indicate the jamming device is nearby.  Neutralize its shields and destroy it.")	
							(f_md_object_play 5 none m52_0330)
					)
				)
			)
		)
	)						
)

(script dormant md_020_bldg_b_end
	(sleep_until 
		(and
			(<= (object_get_health dm_building_b_objective) 0)
			(= b_is_dialogue_playing false)
		)
	5)	
	(sleep 90)
	 ;(print "KAT: Jammer offline. Well done, Noble Six. Head back to your Falcon.")
		(f_md_object_play 5 none m52_0370)

	
	(sleep 150)
		
	(if (> (ai_living_count ai_bldgb_trooper02) 0)
		(begin
	  	;(print "TROOPER: We got things under control, Lieutenant. Head on out!.")
			 (f_md_ai_play 5 ai_bldgb_trooper02 m52_0420)	
			 ;(f_md_object_play 5 none m52_0420)
		)
		(if (> (ai_living_count ai_bldgb_trooper02) 0)	
			(begin
		  	;(print "TROOPER: We got things under control, Lieutenant. Head on out!.")
				 (f_md_ai_play 5 ai_bldgb_trooper04 m52_0430)	
				 ;(f_md_object_play 5 none m52_0430)
			)
		)		
	)			
)


(script dormant hud_object_bldg_c
	(f_blip_flag cf_pri_bldg_c_reminder 21)
	(f_hud_obj_new ct_objective_bldg_c PRIMARY_OBJECTIVE_3)	
	
	(sleep_until
			(or
			(objects_can_see_flag player0 cf_pri_bldg_c_reminder 20)
			(objects_can_see_flag player1 cf_pri_bldg_c_reminder 20)
			(objects_can_see_flag player2 cf_pri_bldg_c_reminder 20)
			(objects_can_see_flag player3 cf_pri_bldg_c_reminder 20)
			 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 cf_pri_bldg_c_reminder) 50)
				(= (objects_distance_to_flag player0 cf_pri_bldg_c_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player1 cf_pri_bldg_c_reminder) 50)
				(= (objects_distance_to_flag player1 cf_pri_bldg_c_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player2 cf_pri_bldg_c_reminder) 50)
				(= (objects_distance_to_flag player2 cf_pri_bldg_c_reminder) -1)
			)
			(or
				(> (objects_distance_to_flag player3 cf_pri_bldg_c_reminder) 50)
				(= (objects_distance_to_flag player3 cf_pri_bldg_c_reminder) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_bldg_c_highlight)
			(f_blip_title sc_bldg_c_box "WP_CALLOUT_M52_SINOVIET")
		)
	)
)

(script dormant md_030_bldg_c
	(sleep_until (= g_intro_dialog_played TRUE)5)
		;(print "TROOPER 5(RADIO): Mayday, mayday!  Seven Delta One Niner to all UNSC forces!")		
			(f_md_object_play 5 none m52_0740)
		;(print "KAT(RADIO):  What's your status, One Niner?")	
			(f_md_object_play 5 none m52_0750)
		;(print "MARINE(RADIO):  We found the jammer -- but we're getting hit!  Request immediate assistance! Sinoviet Center -- AARRGGHH!")
			(f_md_object_play 5 none m52_0760)
	(sleep 60)
		;(print "KAT(RADIO): You still with me, One Niner?... Seven Delta One Niner, do you copy?...")	
			(f_md_object_play 5 none m52_0770)

	; is this the first mission?
	(if (= m_progression 3)
		(begin
			;(print "KAT: Six, I'm uploading coordinates now; get to Sinoviet Center!  Help those troopers if you can, but get that jammer offline either way!")
			(f_md_object_play 5 none m52_0800)
		)
		(begin
			;(print "KAT: Six, help those troopers if you can, but get that jammer offline either way!.")		
			(f_md_object_play 5 none m52_0780)
		)
	)
	(if (= m_progression 1)
		(begin
			;(print "KAT: This is the last jammer, Six. You're almost there!")		
			(f_md_object_play 5 none m52_0790)
		)
	)
	(sleep 60)

	(wake hud_object_bldg_c)	
	(set g_mission_unlock 3)
	
	(wake md_030_bldg_c_near)
	(wake md_030_bldg_c_land)
	(wake md_030_bldg_c_interior)
	(wake md_030_bldg_c_lost)
)

(script dormant md_030_bldg_c_near
	(if 
		(or
			(not (volume_test_players tv_near_bldg_c))
			(not (volume_test_players tv_loc_building_c))
		)
		(begin
			(sleep_until (volume_test_players tv_near_bldg_c) 5)
			(begin
				;(print "KAT: Approaching the objective, Six.  Watch for hostile fire.")		
					(f_md_object_play 5 none m52_0810)		
			)
		)
	)
)

(script dormant md_030_bldg_c_land

	(sleep_until 
		(and
			(= b_is_dialogue_playing false)
			(>= obj_control_bldg_c 30)
		)
	5)
	(if (= g_bldg_c_elev_active FALSE)
		(begin
			;(print "KAT: Noble Two to Noble Six: I’m still getting nothing from those troopers. You may have to take care of this jammer yourself.")		
				(f_md_object_play 5 none m52_0820)
		)
	)

	(sleep_until 
		(or
			(>= (device_get_position dc_bldg_c_switch02a) 1)
			(>= (device_get_position dc_bldg_c_switch01a) 1)
			(>= obj_control_bldg_c 60)
		)
	30 900)
	(if
		(or
			(>= (device_get_position dc_bldg_c_switch02a) 0)
			(>= (device_get_position dc_bldg_c_switch01a) 0)
			(>= obj_control_bldg_c 60)
		)
		(begin
			;(print "KAT: Six, I'm accessing building schematics... There's an elevator on the north landing.")		
				(f_md_object_play 5 none m52_0830)
			
		)
	)	
)
(script dormant hud_object_bldg_c_obj
	;sleep until player can see the object within an FOV of 20
	(f_hud_flash_object sc_bldg_c_high_obj)
)
(script dormant md_030_bldg_c_interior
	(sleep_until (f_bsp_and_volume_check 4 tv_bldg_c_int_start) 1)
	(branch 		
		(= (f_objective_complete dm_building_c_objective dc_objective_c_switch) TRUE)
		(f_md_abort)
	)
	
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)
			(volume_test_players tv_bldg_c_int_end)
		)
	5)

	(if	(= (f_objective_complete dm_building_c_objective dc_objective_c_switch) FALSE)
		(begin
			;(print "KAT: You're close to the jammer.  Neutralize its shields and destroy it.")		
				(f_md_object_play 5 none m52_0850)
				;(wake hud_object_bldg_c_obj)
		)
	)
	;*
	(sleep_until (= (f_objective_shields_down dm_building_c_objective dc_objective_c_switch) TRUE)5)
	;(print "KAT: Shields down.  Take it out.")		
		(f_md_object_play 5 none m52_0860)
	*;
)

(script dormant md_030_bldg_c_lost
	(sleep_until (f_bsp_and_volume_check 4 tv_bldg_c_int_start) 1)
	(branch 		
		(= (f_objective_complete dm_building_c_objective dc_objective_c_switch) TRUE)
		(f_md_abort)
	)
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)
			(volume_test_players tv_bldg_c_int_lost)
		)
	5)

		;(print "KAT: Schematics show alternate routes to either side, Six.")		
		 (f_md_object_play 5 none m52_0840)
)

(script dormant md_030_bldg_c_end
	(branch 		
		(= (f_bsp_all_player 4) FALSE)
		(f_md_abort)
	)	
	;*
	;(print "KAT(RADIO): Got a solid signal, Six.  Nice work.")	
		(f_md_object_play 5 none m52_0870)
		
	*;
	;(print "KAT: It's a trap!  Get the hell out of there!")	
		(f_md_object_play 5 none m52_0890)


)

(script dormant md_030_bldg_c_exit	
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_elevator)
			(volume_test_players tv_bldg_c_elevator_all)
			(= (f_bsp_any_player 4) false)
		)
	5)
	(sleep 90)
	(if
		(or
			(volume_test_players tv_bldg_c_elevator)
			(volume_test_players tv_bldg_c_elevator_all)
		)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)			
			;(print "KAT: Thermal looks clear for now, Six.  Return to your Falcon and stand by for  instructions.")	
				(f_md_object_play 5 none m52_0900)

		)
	)

)

(script dormant hud_object_bldg_oni
	(sleep_until (= (f_players_flying) true)5)
	(sleep_until (script_finished title_final)5 300)
	(f_blip_flag cf_bldg_oni 21)
	(sleep 30)		
	(f_hud_obj_new ct_objective_oni PRIMARY_OBJECTIVE_4)
	(sleep_until 
		(or
			(objects_can_see_flag player0 cf_bldg_oni 20)
			(objects_can_see_flag player1 cf_bldg_oni 20)
			(objects_can_see_flag player2 cf_bldg_oni 20)
			(objects_can_see_flag player3 cf_bldg_oni 20)
		 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 cf_bldg_oni) 50)
				(= (objects_distance_to_flag player0 cf_bldg_oni) -1)
			)
			(or
				(> (objects_distance_to_flag player1 cf_bldg_oni) 50)
				(= (objects_distance_to_flag player1 cf_bldg_oni) -1)
			)
			(or
				(> (objects_distance_to_flag player2 cf_bldg_oni) 50)
				(= (objects_distance_to_flag player2 cf_bldg_oni) -1)
			)
			(or
				(> (objects_distance_to_flag player3 cf_bldg_oni) 50)
				(= (objects_distance_to_flag player3 cf_bldg_oni) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_bldg_oni_highlight)
			(f_blip_title sc_bldg_oni_box "WP_CALLOUT_M52_ONI")
		)
	)
)

(script dormant md_040_bldg_oni
	(branch 		
		(b_oni_end)
		(f_md_abort)
	)	
	(sleep_until (= b_is_dialogue_playing false)5)	
	;(print "KAT(RADIO): Noble Two to Noble Leader: All  jammers are down.")
		(f_md_object_play 5 none m52_0910)

	;(print "CARTER: Solid copy, Noble Two.  New orders: all personnel are to be evacuated from ONI HQ.  Say confirm.")
		(f_md_object_play 5 none m52_0920)

	;(print "KAT(RADIO): Confirm ONI tower evac --")
		(f_md_object_play 5 none m52_0930)
	
	;(print "CARTER: Noble Two...!  Noble Two, sit rep!")
		(f_md_object_play 5 none m52_0940)	
	
	;(print "KAT(RADIO): Coveys are hitting the HQ in force!  They must have zeroed my signal!")
		(f_md_object_play 5 none m52_0950)

	;(print "CARTER: Get that evac started!")
		(f_md_object_play 5 none m52_0960)
	
	;(print "KAT(RADIO): Roger that!  Noble Six, get over here and cover our evac Pelicans!  I need you overhead NOW!")
		(f_md_object_play 5 none m52_0970)

	(f_hud_obj_new ct_objective_oni_aa PRIMARY_OBJECTIVE_5)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)		
	(sleep_until (volume_test_players	tv_oni_start) 5)

	(sleep_until (= b_is_dialogue_playing false)5)	
	;(print "PELICAN PILOT01(RADIO): Command, this is Whiskey Three Five.  I've got eyes on six long-range shade turrets in range of the ONI tower.  Making life pretty tough on our  evac birds…")
		(f_md_object_play 5 none m52_0980)
		
	;(print "KAT(RADIO): Copy, Whiskey Three Five.  Noble Six, take out those Heavy shades!")
		(f_md_object_play 5 none m52_0990)

	(sleep 1200)

	(sleep_until (= b_is_dialogue_playing false)5)			
	;(print "PELICAN PILOT01(RADIO): Whiskey Three Five to Command!  We need those Shade turrets gone!")
		(f_md_object_play 5 none m52_1000)
			
	;(print "KAT: Copy, Three Five.  Go, Lieutenant!  Shade turrets are Priority One!")
		(f_md_object_play 5 none m52_1010)

	(sleep 1200)

	(sleep_until (= b_is_dialogue_playing false)5)			
	;(print "PELICAN PILOT01(RADIO): Whiskey Three Five to Command!  We can't hold out much longer!")
		(f_md_object_play 5 none m52_1020)
	
	;(print "KAT: Understood, Three Five!  Noble Six, you HAVE to take out those turrets!")
		(f_md_object_play 5 none m52_1030)

)

(script static void md_040_oni_pelican_progress
	(if (= pelican_status 1)
		(begin
			;(print "KAT(RADIO): Noble Six, lose those other Shade turrets so the Pelicans can get out of here.")
		(f_md_object_play 5 none m52_1100)
		)
	)
	(if (= pelican_status 2) 
		(begin
			;(print "KAT(RADIO): Noble Six, you’ve got to neutralize the remaining shades for our evac birds!")
		(f_md_object_play 5 none m52_1110)
		)
	)
)

(script dormant md_040_oni_pelican01
	(sleep_until
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_01/gunner)) 0)
				(<= (ai_living_count sq_oni_s_01) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_02/gunner)) 0)
				(<= (ai_living_count sq_oni_s_02) 0)
			)
			(= b_is_dialogue_playing false)
		)
	)
	(sleep_until (= b_is_dialogue_playing false)5)	
	(sleep 60)
	;(print "KAT(RADIO): Whiskey Three Five, you’re clear to proceed with evac!")
		(f_md_object_play 5 none m52_1120)
	;(print "PELICAN PILOT01(RADIO): Copy, Command!  Much obliged!")
		(f_md_object_play 5 none m52_1130)

	(md_040_oni_pelican_progress)
				
)
(script dormant md_040_oni_pelican02
	(sleep_until
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_04/gunner)) 0)
				(<= (ai_living_count sq_oni_s_04) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_05/gunner)) 0)
				(<= (ai_living_count sq_oni_s_05) 0)
			)
			(= b_is_dialogue_playing false)
		)
	)
	(sleep_until (= b_is_dialogue_playing false)5)	
	(sleep 60)
	;(print "KAT(RADIO): Whiskey Three Six, proceed with evac!")
		(f_md_object_play 5 none m52_1140)
	;(print "PELICAN PILOT08(RADIO): I copy, Command!  Thanks!")
		(f_md_object_play 5 none m52_1150)
	
	(md_040_oni_pelican_progress)	
)

(script dormant md_040_oni_pelican03
	(sleep_until
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_03/gunner)) 0)
				(<= (ai_living_count sq_oni_s_03) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_06/gunner)) 0)
				(<= (ai_living_count sq_oni_s_06) 0)
			)
			(= b_is_dialogue_playing false)
		)
	)
	(sleep_until (= b_is_dialogue_playing false)5)	
	(sleep 60)
	;(print "KAT(RADIO): Whiskey Three Seven, you may proceed with evac!!")
		(f_md_object_play 5 none m52_1160)
	;(print "PELICAN PILOT08(RADIO): Solid copy, Command!  Appreciate the help!")
		(f_md_object_play 5 none m52_1170)
	
	(md_040_oni_pelican_progress)		
)


(script dormant hud_object_bldg_oni_pad

	(sleep_until (= (f_players_flying) true)5)
		(f_blip_flag cf_bldg_oni_end 21)
		(f_hud_obj_new ct_objective_oni_end PRIMARY_OBJECTIVE_6)	

	(sleep_until 
		(or
			(objects_can_see_flag player0 cf_bldg_oni_end 20)
			(objects_can_see_flag player1 cf_bldg_oni_end 20)
			(objects_can_see_flag player2 cf_bldg_oni_end 20)
			(objects_can_see_flag player3 cf_bldg_oni_end 20)
		 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 cf_bldg_oni_end) 50)
				(= (objects_distance_to_flag player0 cf_bldg_oni_end) -1)
			)
			(or
				(> (objects_distance_to_flag player1 cf_bldg_oni_end) 50)
				(= (objects_distance_to_flag player1 cf_bldg_oni_end) -1)
			)
			(or
				(> (objects_distance_to_flag player2 cf_bldg_oni_end) 50)
				(= (objects_distance_to_flag player2 cf_bldg_oni_end) -1)
			)
			(or
				(> (objects_distance_to_flag player3 cf_bldg_oni_end) 50)
				(= (objects_distance_to_flag player3 cf_bldg_oni_end) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_oni_obj_high)
			(f_blip_title sc_bldg_oni_pad_box "WP_CALLOUT_M52_ONI_PAD")
		)
	)
)

(script dormant md_040_oni_end
	(sleep 60)
	(sleep_until 
		(and
			(script_finished md_040_oni_pelican01)
			(script_finished md_040_oni_pelican02)
			(script_finished md_040_oni_pelican03)
		)
	5)
	(sleep_until (= b_is_dialogue_playing false)5)	
	(sleep 120)
	;(print "KAT(RADIO): Noble Six, you are one steely-eyed Spartan... I'm extending the landing pad now.  Come on home, Lieutenant.")
		(f_md_object_play 5 none m52_1430)
		(wake hud_object_bldg_oni_pad)

)

(script dormant md_040_oni_aa01
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_01/gunner)) 0)
			(<= (ai_living_count sq_oni_s_01) 0)
		)
	5)
	(if (= (b_oni_end) FALSE)(aa_counter))
)
(script dormant md_040_oni_aa02
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_02/gunner)) 0)
			(<= (ai_living_count sq_oni_s_02) 0)
		)
	5)
	(if (= (b_oni_end) FALSE)(aa_counter))
)
(script dormant md_040_oni_aa03
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_03/gunner)) 0)
			(<= (ai_living_count sq_oni_s_03) 0)
		)
	5)
	(if (= (b_oni_end) FALSE)(aa_counter))
)
(script dormant md_040_oni_aa04
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_04/gunner)) 0)
			(<= (ai_living_count sq_oni_s_04) 0)
		)
	5)
	(if (= (b_oni_end) FALSE)(aa_counter))
)
(script dormant md_040_oni_aa05
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_05/gunner)) 0)
			(<= (ai_living_count  sq_oni_s_05) 0)
		)
	5)
	(if (= (b_oni_end) FALSE) (aa_counter))
)
(script dormant md_040_oni_aa06
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location sq_oni_s_06/gunner)) 0)
			(<= (ai_living_count sq_oni_s_06) 0)
		)
	5)
	(if (= (b_oni_end) FALSE)(aa_counter))
)

(script static void aa_counter
	(set g_music_m52_08 1)
	(cond
		(
			(and
				(= b_is_dialogue_playing false)
				(= (ai_living_count gr_oni_01_turrets) 5)
			)
			(begin
				(sleep 15)
				;(print "KAT: That's one!")
					(f_md_object_play 5 none m52_1040)
			)
		)
		(
			(and
				(= b_is_dialogue_playing false)
				(= (ai_living_count gr_oni_01_turrets) 4)
			)		
			(begin
				(sleep 15)
				;(print "KAT: Another shade turret down!")
					(f_md_object_play 5 none m52_1050)
			)
		)
		(
			(and
				(= b_is_dialogue_playing false)
				(= (ai_living_count gr_oni_01_turrets) 3)
			)		
			(begin
				(sleep 15)
				;(print "KAT: Third turret is down!")
					(f_md_object_play 5 none m52_1060)
			)
		)
		(
			(and
				(= b_is_dialogue_playing false)
				(= (ai_living_count gr_oni_01_turrets) 2)
			)
			(begin
				(sleep 15)
				;(print "KAT: That’s the fourth Shade!")
					(f_md_object_play 5 none m52_1070)
			)
		)
		(
			(and
				(= b_is_dialogue_playing false)
				(= (ai_living_count gr_oni_01_turrets) 1)
			)	
			(begin
				(sleep 15)
				;(print "KAT: Five down, one to go!")
					(f_md_object_play 5 none m52_1080)
			)
		)
		((= (ai_living_count gr_oni_01_turrets) 0) 		
			(begin
				(sleep_until 
					(and 
						(script_finished md_040_oni_pelican01) 
						(script_finished md_040_oni_pelican02) 
						(script_finished md_040_oni_pelican03) 
						(= b_is_dialogue_playing false)
					)
				5)
				(sleep 60)
				;(print "KAT(RADIO): That’s the last one, Lieutenant!")
					(f_md_object_play 5 none m52_1090)
			)
		)
	)
)										

(script static void coop_objective_start_check
	; this script only is for four player cooperative, since we have two secondary objectives firing off at once, we need to make sure their dialog and objective doesn't trample over the other
	(if (g_3coop_mode) 
		(if (= m_coop_1st_dialog true) ; is this the first secondary objective dialog for coop?
			(begin
				(set m_coop_1st_dialog false) ; this is the first dialog, make it false for the other objective
				(set m_coop_1st_dialog_done false) ; make it so that the other objective doesn't speak over this line 
			)
			(begin
				(sleep_until (= m_coop_1st_dialog_done true) 5) ;if this is not the first dialog, sleep until the dialog is true, then wait an extra 5 to 7 seconds
				(sleep (* 30 (random_range 5 7)))
			)
		)
	)
)

(script dormant md_050_sec_alpha1
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "MARINE(RADIO): One Alpha Three to Command.  Coveys got us pinned down on a rooftop.  We need help PRONTO.  Uploading waypoint now, over.")
		(f_md_object_play 5 none m52_1440)
	;(print "KAT(RADIO): Copy, Six Alpha One Three.  Noble Six, proceed to waypoint and give those troopers a hand.")
		(f_md_object_play 5 none m52_1450)

	(f_blip_flag cf_sec_alpha_1 1)
	(f_hud_obj_new ct_objective_alpha_1 PRIMARY_OBJECTIVE_7)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)				
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
)
(script static void md_050_sec_success_alpha1
	(sleep_until (= b_is_dialogue_playing false))
	;(print "MARINE(RADIO): We're clear.  Thanks for the help, Sierra!")
		(f_md_object_play 5 none m52_1460)
)
(script static void md_050_sec_fail_alpha1
	(sleep_until (= b_is_dialogue_playing false))
	;(print "KAT(RADIO): They didn't make it, Lieutenant. Standby…")
		(f_md_object_play 5 none m52_1470)
	
)
(script dormant md_050_sec_alpha2
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "MARINE(RADIO): Seven Charlie Four Zero to HQ.  We got incoming hostiles on top of the Mainz Trager building.  Requesting immediate assistance.")
		(f_md_object_play 5 none m52_1480)
	;(print "KATT(RADIO): Copy, Four Zero.  Noble Six, you're not far from Mainz Trager.  Go see what you can do for those troopers.")
		(f_md_object_play 5 none m52_1490)

	(f_blip_flag cf_sec_alpha_2 1)

	(f_hud_obj_new ct_objective_alpha_2 PRIMARY_OBJECTIVE_8)	
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)			
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
	
)
(script static void md_050_sec_success_alpha2
	(sleep_until (= b_is_dialogue_playing false))
	;(print "MARINE(RADIO): That should do it.  You got here just in time, Spartan!")
		(f_md_object_play 5 none m52_1500)
	
)
(script static void md_050_sec_fail_alpha2
	(sleep_until (= b_is_dialogue_playing false))
	;(print "KATT(RADIO): Nothing you could do, Six. Move on…")
		(f_md_object_play 5 none m52_1510)
		
)
(script dormant md_050_sec_alpha3
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "MARINE(RADIO): This is Foxtrot two one, on the DMBM Financial Tower.  Anybody out there?")
		(f_md_object_play 5 none m52_1520)
  ;(print "KATT(RADIO): Copy, Two One.  Go ahead.")
		(f_md_object_play 5 none m52_1530)
  ;(print "MARINE(RADIO): We got Hunters tearing us a new one!")
		(f_md_object_play 5 none m52_1540)
  ;(print "KATT(RADIO): Hang on! Noble Six, uploading coordinates...")
		(f_md_object_play 5 none m52_1550)

	(f_blip_flag cf_sec_alpha_3 1)

	(f_hud_obj_new ct_objective_alpha_3 PRIMARY_OBJECTIVE_9)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)						
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
	 
)
(script static void md_050_sec_success_alpha3
	(sleep_until (= b_is_dialogue_playing false))
	;(print "MARINE(RADIO): Thanks a million, Sierra.  Thought we were dead for sure.")
		(f_md_object_play 5 none m52_1560)
			
)
(script static void md_050_sec_fail_alpha3
	(sleep_until (= b_is_dialogue_playing false))
	;(print "KATT (RADIO): They're gone, Noble Six.  Shake it off.")
		(f_md_object_play 5 none m52_1570)
)

(script dormant md_050_sec_beta1
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "MARINE(RADIO): Oscar One Eight reporting! Just took out a jammer and we're waiting for evac -- but taking sniper fire!")
		(f_md_object_play 5 none m52_1580)
 	;(print "KATT (RADIO): Understood, One Eight.  Lieutenant, proceed to these coordinates and clear that LZ.")
		(f_md_object_play 5 none m52_1590)

	(f_blip_flag cf_sec_beta_1 1)	

	(f_hud_obj_new ct_objective_beta_1 PRIMARY_OBJECTIVE_10)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)				
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
	 	
)
(script static void md_050_sec_success_beta1
	(sleep_until (= b_is_dialogue_playing false))	
	;(print "(RADIO): Thanks, Spartan!  Those snipers had our number!")
		(f_md_object_play 5 none m52_1600)	
)
(script static void md_050_sec_fail_beta1
	(sleep_until (= b_is_dialogue_playing false))		
 	;(print "KATT (RADIO): Troopers down! Nothing you could do")
		(f_md_object_play 5 none m52_1610)	
)
(script dormant md_050_sec_beta2
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "PILOT(RADIO): Whiskey Three Niner requesting immediate assistance!")
		(f_md_object_play 5 none m52_1620)
 	;(print "KATT (RADIO): Copy, Three Niner.  Go ahead.")
		(f_md_object_play 5 none m52_1630)
	;(print "PILOT(RADIO): Just picked up some evacuees -- but we're surrounded by Long-Range Shade turrets!")
		(f_md_object_play 5 none m52_1640)
 	;(print "KATT (RADIO): Solid copy, Three Niner. Lieutenant, proceed to the waypoint and eliminate those Shade turrets.")
		(f_md_object_play 5 none m52_1650)		

	(f_blip_ai sq_sec_beta_p02/pilot 1)

	(f_hud_obj_new ct_objective_beta_2 PRIMARY_OBJECTIVE_11)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)						
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
)

(script static void md_050_sec_success_beta2
	(sleep_until (= b_is_dialogue_playing false))		
	;(print "PILOT(RADIO): Path looks clear, Spartan.  Much obliged.")
		(f_md_object_play 5 none m52_1660)
)

(script static void md_050_sec_fail_beta2
	(sleep_until (= b_is_dialogue_playing false))
	;(print "KATT (RADIO): Six. Thermal on those troopers is cold… They're gone.")
		(f_md_object_play 5 none m52_1670)
			
)

(script dormant md_050_sec_beta3
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "RADIO): Golf Two Seven to HQ!  We're up on the Jotun building -- and we got Banshees all over us!")
		(f_md_object_play 5 none m52_1680)
	;(print "KATT (RADIO): Lieutenant, I'm sending you Jotun's coordinates; neutralize those Banshees.")
		(f_md_object_play 5 none m52_1690)	

	(f_blip_flag cf_sec_beta_3 1)

	(f_hud_obj_new ct_objective_beta_3 PRIMARY_OBJECTIVE_12)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)				
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
)

(script static void md_050_sec_success_beta3
	(sleep_until (= b_is_dialogue_playing false))		
	;(print "MARINE(RADIO): Banshees down! Appreciate the hand, Spartan!")
		(f_md_object_play 5 none m52_1700)	
)

(script static void md_050_sec_fail_beta3
	(sleep_until (= b_is_dialogue_playing false))
	;(print "KATT (RADIO): They didn't make it, Noble Six…")
		(f_md_object_play 5 none m52_1710)	
)

(script dormant md_050_sec_delta1
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	(if 
		(or
			(> (ai_living_count gr_delta_cov) 0)
			(> (object_get_health delta_comm_01) 0)
		)
		(begin
		  ;(print "KATT(RADIO): Six: Coveys brought out a mobile jammer to mess with our short-range.  Sending you the waypoint; go deal with it.")
				(f_md_object_play 5 none m52_1720)	
		
			(f_blip_flag cf_sec_delta_1 0)
		
			(f_hud_obj_new ct_objective_delta_1 PRIMARY_OBJECTIVE_16)
			(if (= g_music_m52_05 1)	
				(set g_music_m52_05 2)
			)
			(if (= g_music_m52_07 1)	
				(set g_music_m52_07 2)
			)			
		)	
	)
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true)) 	  	
)

(script static void md_050_sec_success_delta1
	(sleep_until (= b_is_dialogue_playing false))	
  ;(print "KATT(RADIO): Good work, Six.")
		(f_md_object_play 5 none m52_1730)
	(f_unblip_flag cf_sec_delta_1)				 
)

(script dormant md_050_sec_delta2
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
  ;(print "KATT(RADIO): Noble Six, we're getting reports of Elites and Engineers trying to break in to the Misriah Complex.  I want them taken out.")
	(f_md_object_play 5 none m52_1740)	 
	(f_hud_obj_new ct_objective_delta_2 PRIMARY_OBJECTIVE_17)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)	
	(f_blip_flag cf_sec_delta_2 0)	
	(sleep_until (<= (ai_living_count gr_delta_cov) 3) 5)	
	(f_blip_ai sq_sec_delta_c02a 15)
	(f_blip_ai sq_sec_delta_c02b 15)
	(f_blip_ai sq_sec_delta_c02c 15)
	(f_blip_ai sq_sec_delta_c02d 15)
	(f_blip_ai sq_sec_delta_c02e 15)	
	
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
)

(script static void md_050_sec_success_delta2
	(sleep_until (= b_is_dialogue_playing false))	
  ;(print "KATT(RADIO): Way to shoot, Lieutenant.")
		(f_md_object_play 5 none m52_1750)	
)

(script dormant md_050_sec_delta3
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
  ;(print "KATT(RADIO): Noble Six, we've got an evac op being harassed by a Covenant Shade turret.  Neutralize it so we can get those people out of there. ")
		(f_md_object_play 5 none m52_1760)
	(f_blip_flag cf_sec_delta_3 0)

	(f_hud_obj_new ct_objective_delta_3 PRIMARY_OBJECTIVE_18)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)			
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
)

(script static void md_050_sec_success_delta3
	(sleep_until (= b_is_dialogue_playing false))	
	;(print "KATT(RADIO): Evac clear.  Well done, Spartan.")
		(f_md_object_play 5 none m52_1770)
)

(script dormant md_050_sec_gamma1
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	;(print "BUCK(RADIO): Command, this is Gunnery Sergeant Buck with the Eleventh ODST, over!")	
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1780)
		(f_md_object_play 5 none m52_1780)
	)
	;(print "KAT: Copy, Gunnery Sergeant.  Go ahead.")	
		(f_md_object_play 5 none m52_1790)
	;(print "BUCK: Need escort on a classified op. Send someone who knows how to fly a tight formation.")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1800)
		(f_md_object_play 5 none m52_1800)
	)			
	(f_blip_flag cf_sec_gamma_1a 1)

	(f_hud_obj_new ct_objective_gamma_1 PRIMARY_OBJECTIVE_13)
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)			
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))	
	(set g_music_m52_09 1)		
)

(script static void md_050_sec_success_gamma1
	(sleep_until (= b_is_dialogue_playing false))
	;(print "BUCK: I owe you one, Spartan.  See ya in hell.")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1810)
		(f_md_object_play 5 none m52_1810)
	)
	(set g_music_m52_09 2)	
)

(script dormant md_050_sec_gamma2
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
  ;(print "BUCK(RADIO): Command, this is Gunnery Sergeant Buck with the Eleventh ODST, over!")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1780)
		(f_md_object_play 5 none m52_1780)
	)  
  ;(print "KATT(RADIO): Copy, Gunnery Sergeant.  Go ahead.")
		(f_md_object_play 5 none m52_1840)
  ;(print "BUCK(RADIO): My guys got caught in a firefight on the Nomolos tower. Roof collapsed.  I gotta get over there and get 'em out!")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1850)
		(f_md_object_play 5 none m52_1850)
	)   
  ;(print "KATT(RADIO): Solid copy. Noble Six will escort your Falcon to the tower.")
		(f_md_object_play 5 none m52_1860)
	
	(f_blip_flag cf_sec_gamma_2a 1)

	(f_hud_obj_new ct_objective_gamma_2 PRIMARY_OBJECTIVE_14)	
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)			
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
	(set g_music_m52_09 1)		
)

(script static void md_050_sec_success_gamma2
	(sleep_until (= b_is_dialogue_playing false))	
  ;(print "BUCK(RADIO): I owe you one, Spartan.  See ya in hell.")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1810)
		(f_md_object_play 5 none m52_1810)
	) 
	(set g_music_m52_09 2)	    
)

(script dormant md_050_sec_gamma3
	(coop_objective_start_check)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
  ;(print "BUCK(RADIO): Command, this is Gunnery Sergeant Buck with the Eleventh ODST, over!")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1780)
		(f_md_object_play 5 none m52_1780)
	)    
  ;(print "KATT(RADIO): Copy, Gunnery Sergeant.  Go ahead.")
		(f_md_object_play 5 none m52_1900)
  ;(print "BUCK(RADIO): Phantom's got one of my squads pinned. I need to take it out, and evac my troopers.")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1910)
		(f_md_object_play 5 none m52_1910)
	)			 	

	(f_blip_ai sq_sec_gamma_m03a/pilot 1)

	(f_hud_obj_new ct_objective_gamma_3 PRIMARY_OBJECTIVE_15)		
	(if (= g_music_m52_05 1)	
		(set g_music_m52_05 2)
	)
	(if (= g_music_m52_07 1)	
		(set g_music_m52_07 2)
	)		
	(if (g_3coop_mode) (set m_coop_1st_dialog_done true))
	(set g_music_m52_09 1)	
)

(script static void md_050_sec_success_gamma3
	(sleep_until (= b_is_dialogue_playing false))
  ;(print "BUCK(RADIO): I owe you one, Spartan.  See ya in hell.")
	(if (> (ai_living_count ai_buck) 0)
		(f_md_ai_play 5 ai_buck m52_1810)
		(f_md_object_play 5 none m52_1810)
	)	
(set g_music_m52_09 2)	  	 
)

(global boolean b_falcon_evac_dialog false)
(script dormant md_001_falcon_evac
	(sleep_until (= b_falcon_evac_dialog true)1)
	(set b_falcon_evac_dialog false)
	(sleep_until (and (= g_main_dialog_playing false) (= b_is_dialogue_playing false)))
	(begin_random_count 1
		(begin
			;(print "KATT(RADIO): Sit tight, Lieutenant; Falcon on the way.")
				(f_md_object_play 5 none m52_1970)	
		)
		(begin
			;(print "KATT(RADIO): Noble Six -- I'm sending you a Falcon.")
				(f_md_object_play 5 none m52_1980)	
		)
		(begin
			;(print "KATT(RADIO): Sit tight, Lieutenant; already got evac transport on the way.")
				(f_md_object_play 5 none m52_1950)	
		)
		(begin
			;(print "KATT(RADIO): Noble Six -- I'm sending you evac transport.")
				(f_md_object_play 5 none m52_1960)	
		)		
	)
)
;======================================================================
;=======================VIGNETTE AMBIENT SCRIPTS=======================
;======================================================================

(script static boolean (branch_m52 (ai my_actor)) 
	(or
    (> (object_get_recent_shield_damage (ai_get_object my_actor)) 0)
    (> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
    (<= (object_get_health (ai_get_object my_actor)) 0)
    (>= (ai_combat_status my_actor) 3)
	)
)

(script static void m52_a_marine01_vignette_kill
	(set b_marine01_vignette_end true)
)

(script static void m52_a_marine02_vignette_kill
	(set b_marine02_vignette_end true)
)

(script static void m52_a_marine03_vignette_kill
	(set b_marine03_vignette_end true)
)

(global long bldg_a_vig01 -1)
(global long bldg_a_vig01_exit -1)
(global long bldg_a_vig02 -1)
(global long bldg_a_vig02_exit -1)
(global long bldg_a_vig03 -1)
(global long bldg_a_vig03_exit -1)

(script static void m52_a_vignette01
	
	(ai_place sq_bldg_a_trooper_01)
	(ai_place sq_bldg_a_actor01)	
	(ai_disregard (ai_actors sq_bldg_a_trooper_01) true)
	(ai_disregard (ai_actors sq_bldg_a_actor01) true)	
	(sleep 1)
	(unit_set_stance (ai_get_unit sq_bldg_a_trooper_01/01) "m52_vig_marine01")
	(set bldg_a_vig01 (performance_new thsp_marine01 false))
	(cast_squad_in_performance bldg_a_vig01 sq_bldg_a_actor01)
	(cast_squad_in_performance bldg_a_vig01 sq_bldg_a_trooper_01)
	(performance_begin bldg_a_vig01)	
	(wake m52_a_vignette_end01)
									
)

(script static void m52_a_vignette02
	(ai_place sq_bldg_a_trooper_02)
	(ai_place sq_bldg_a_actor02)
	(set ai_bldga_trooper01 sq_bldg_a_trooper_02)			
	(ai_disregard (ai_actors sq_bldg_a_trooper_02) true)
	(ai_disregard (ai_actors sq_bldg_a_actor02) true)	
	(sleep 1)
	(unit_set_stance (ai_get_unit sq_bldg_a_trooper_02/02) "m52_vig_marine02")
	(set bldg_a_vig02 (performance_new thsp_marine02 false))
	(cast_squad_in_performance bldg_a_vig02 sq_bldg_a_actor02)
	(cast_squad_in_performance bldg_a_vig02 sq_bldg_a_trooper_02)
	(performance_begin bldg_a_vig02)	
	(wake m52_a_vignette_end02)
)

(script static void m52_a_vignette03
	(ai_place sq_bldg_a_trooper_03)
	(ai_place sq_bldg_a_actor03)	
	(ai_disregard (ai_actors sq_bldg_a_trooper_03) true)
	(ai_disregard (ai_actors sq_bldg_a_actor03) true)	
	(sleep 1)
	(unit_set_stance (ai_get_unit sq_bldg_a_trooper_03/03) "m52_vig_marine01")
	(set bldg_a_vig03 (performance_new thsp_marine03 false))
	(cast_squad_in_performance bldg_a_vig03 sq_bldg_a_actor03)
	(cast_squad_in_performance bldg_a_vig03 sq_bldg_a_trooper_03)
	(performance_begin bldg_a_vig03)	
	(wake m52_a_vignette_end03)
)

(script dormant m52_a_vignette_end01
   
  (sleep_until b_marine01_vignette_end 1) 
  
  (set bldg_a_vig01_exit (performance_new thsp_marine01_exit false))			
	(cast_squad_in_performance bldg_a_vig01_exit sq_bldg_a_trooper_01)
	(performance_begin bldg_a_vig01_exit)		
)

(script dormant m52_a_vignette_end02
	
  (sleep_until b_marine02_vignette_end 1) 
	
	(set bldg_a_vig02_exit (performance_new thsp_marine02_exit false))			
	(cast_squad_in_performance bldg_a_vig02_exit sq_bldg_a_trooper_02)
	(performance_begin bldg_a_vig02_exit)	
)

(script dormant m52_a_vignette_end03
	
  (sleep_until b_marine03_vignette_end 1) 

	(set bldg_a_vig03_exit (performance_new thsp_marine03_exit false))			
	(cast_squad_in_performance bldg_a_vig03_exit sq_bldg_a_trooper_03)
	(performance_begin bldg_a_vig03_exit)	
)
(script static void m52_a_vignette_finish01
	;(print "OMG THIS MARINE FINISHED")
	(ai_disregard (ai_get_object sq_bldg_a_trooper_01) FALSE)
	(ai_set_objective sq_bldg_a_trooper_01 obj_bldg_a)
)
(script static void m52_a_vignette_finish02
	;(print "OMG THIS MARINE FINISHED")
	(ai_disregard (ai_get_object sq_bldg_a_trooper_02) FALSE)	
	(ai_set_objective sq_bldg_a_trooper_02 obj_bldg_a)
)
(script static void m52_a_vignette_finish03
	;(print "OMG THIS MARINE FINISHED")
	(ai_disregard (ai_get_object sq_bldg_a_trooper_03) FALSE)		
	(ai_set_objective sq_bldg_a_trooper_03 obj_bldg_a)
)

(global boolean b_marine01_vignette_end false)
(global boolean b_marine02_vignette_end false)
(global boolean b_marine03_vignette_end false)

(script dormant m52_a_vignette_cancel
	
	(sleep_until 
		(or
			(= b_marine01_vignette_end true)
			(= b_marine02_vignette_end true)
			(= b_marine03_vignette_end true)
		)
	5)
	
	;(print "aborted")
	(thespian_performance_kill_by_name thsp_marine01)
	(sleep 1)
	(thespian_performance_kill_by_name thsp_marine02)	
	(sleep 1)		
	(thespian_performance_kill_by_name thsp_marine03)
	(sleep 1)		
	(ai_set_objective sq_bldg_a_actor01 obj_bldg_a)
	(ai_set_objective sq_bldg_a_actor02 obj_bldg_a)
	(ai_set_objective sq_bldg_a_actor03 obj_bldg_a)		
)

(script dormant m52_a_vignette04
	(ai_place sq_bldg_a_trooper_04)	
	(ai_disregard (ai_actors sq_bldg_a_trooper_04) true)
	(set ai_bldga_fem02 sq_bldg_a_trooper_04)	
	(sleep 1)
	(thespian_performance_setup_and_begin thsp_marine04 "" 0)
	(sleep_until 
		(and 
			(< (ai_living_count sq_bldg_a_actor01) 1)
			(< (ai_living_count sq_bldg_a_actor02) 1)
			(< (ai_living_count sq_bldg_a_actor03) 1)
		)5)
	(thespian_performance_kill_by_name thsp_marine04)
	(ai_disregard (ai_actors sq_bldg_a_trooper_04) false)
	(ai_set_objective sq_bldg_a_trooper_04 obj_bldg_a)
)

(global ai ai_crazy none)

(script command_script cs_crazy_marine
	(wake crazy_marine_dialog)
  (unit_set_current_vitality (ai_get_unit sq_bldg_c_scared_marine/actor) 10 10)
  (ai_vitality_pinned sq_bldg_c_scared_marine/actor)	
	(begin_random_count 1
		(begin
			(cs_custom_animation_loop objects\characters\marine\marine "m52:gun_crazy" true)
			(sleep_forever)
		)
		(begin
			(cs_custom_animation_loop objects\characters\marine\marine "m52:suicidal" true)
			(sleep_forever)
		)
	)
)
(script dormant crazy_marine_dialog
	;(vs_cast sq_bldg_c_scared_marine/actor TRUE 10 "m50_1570")
  ;(set ai_crazy (vs_role 1))
	(branch
		(< (ai_living_count sq_bldg_c_scared_marine) 1)
		(f_md_abort)
	)
	(sleep_until (volume_test_players tv_scaredy_marine)5)
	
			(f_md_ai_play 5 ai_crazy m50_1570)
			;(f_md_object_play 5 none m50_1570)
			;(print "PI1: GIBBERISH1")
		
			(f_md_ai_play 5 ai_crazy m50_1580)
			;(f_md_object_play 5 none m50_1580)
			;(print "PI1: GIBBERISH2")	
		
			(f_md_ai_play 5 ai_crazy m50_1590)
			;(f_md_object_play 5 none m50_1590)
			;(print "PI1: GIBBERISH3")	
		
			(f_md_ai_play 5 ai_crazy m50_1600)
			;(f_md_object_play 5 none m50_1600)
			;(print "PI1: GIBBERISH4")	
		
			(f_md_ai_play 5 ai_crazy m50_1610)
			;(f_md_object_play 5 none m50_1610)
			;(print "PI1: GIBBERISH5")	
		
			(f_md_ai_play 5 ai_crazy m50_1620)
			;(f_md_object_play 5 none m50_1620)
			;(print "PI1: GIBBERISH6")							
		 
		 	(f_md_ai_play 5 ai_crazy m50_1630)
			;(f_md_object_play 5 none m50_1630)
			;(print "PI1: GIBBERISH7") 

	(sleep_until
		(begin
			(f_md_ai_play 5 ai_crazy m50_1640)
			;(f_md_object_play 5 none m50_1640)
			;(print "PI1: GIBBERISH8")
		(= g_prev_mission 3))
	60)
)


(script dormant m52_bldg_a_dead_marines
	(scenery_animation_start sc_bldg_a_marine01 objects\characters\marine\marine deadbody_01)
	(scenery_animation_start sc_bldg_a_marine02 objects\characters\marine\marine deadbody_03)	
	(scenery_animation_start sc_bldg_a_marine03 objects\characters\marine\marine deadbody_05)	
)
(script dormant m52_bldg_c_dead_marines
	(scenery_animation_start sc_bldg_c_marine01 objects\characters\marine\marine deadbody_01)
	(scenery_animation_start sc_bldg_c_marine02 objects\characters\marine\marine deadbody_06)	
)
(script dormant m52_covenant_cruiser_vignette
	(sleep_until 
		(and 
			(f_any_hub_check)
			(= m_progression 2)
			(f_players_flying)
		)
	5)
	;(print "cruiser 1 event")
	(wake m52_vig_cruiser01_progress)
	(object_create vig_cruiser01)
	(device_set_position_track vig_cruiser01 m52_initial_start 0)
	(device_animate_position vig_cruiser01 0 -1 0 0 FALSE)				
	(device_animate_position vig_cruiser01 0.81 30 5 5 FALSE)		
	(sleep_until (>= (device_get_position vig_cruiser01) 0.81)5)
	(interpolator_start glassing_glow_01)	
	(sleep_until 
		(and 
			(f_any_hub_check)
			(= m_progression 1)
			(f_players_flying)
		)
	5)
	;(print "cruiser 2 event")
	(object_create vig_cruiser02)
	(device_set_position_track vig_cruiser02 m52_mid 0)
	(wake m52_vig_cruiser02_progress)		
	(device_animate_position vig_cruiser02 0.81 30 5 5 TRUE)
	(sleep_until (>= (device_get_position vig_cruiser02) 0.81)5)
	(interpolator_start glassing_glow_02)
	(sleep_until 
		(and 
			(f_any_hub_check)
			(= m_progression 0)
			(f_players_flying)
		)
	5)
	;(print "cruiser 3 event")
	(device_animate_position vig_cruiser01 1 30 0 0 TRUE)		
	(device_animate_position vig_cruiser02 1 30 0 0 TRUE)	
	(cam_shake 5 0.05 7 10)
)

(script dormant m52_vig_cruiser01_progress
	(sleep_until (>= (device_get_position vig_cruiser01) 0.25)1)
	(cam_shake 3 0.20 7 4)
)
(script dormant m52_vig_cruiser02_progress
	(sleep_until (>= (device_get_position vig_cruiser02) 0.25)1)
	(cam_shake 3 0.20 7 4)
)

(script static void (cam_shake_player (player actor)(real attack) (real intensity) (short duration) (real decay))
                (player_effect_set_max_rotation_for_player actor 3 3 3)
                (player_effect_set_max_rumble_for_player actor 1 1)
                (player_effect_start_for_player actor intensity attack)
                 (sleep (* duration 30))
                (player_effect_stop_for_player actor decay))
                
 (script static void (cam_shake (real attack) (real intensity) (short duration) (real decay))
                (player_effect_set_max_rotation 2 2 2)
               	(player_effect_set_max_rumble 1 1)
                (player_effect_start intensity attack)
                (sleep (* duration 30))
                (player_effect_stop decay))
               


(script dormant m52_building_fall
	(sleep_until 
		(or
			(f_vehicle_pilot_seat player0)
			(f_vehicle_pilot_seat player1)
			(f_vehicle_pilot_seat player2)
			(f_vehicle_pilot_seat player3)
		)
	5)
	(sleep 60)
	(sleep_until 
		(or 
			(= m_progression 2)
			(volume_test_players tv_building_fall)
			(objects_can_see_flag player0 cf_building_fall 10)
			(objects_can_see_flag player1 cf_building_fall 10)
			(objects_can_see_flag player2 cf_building_fall 10)
			(objects_can_see_flag player3 cf_building_fall 10)
		)
	5)
	(if 
		(and
			(not (volume_test_players tv_building_fall))
				(or
					(objects_can_see_flag player0 cf_building_fall 10)
					(objects_can_see_flag player1 cf_building_fall 10)
					(objects_can_see_flag player2 cf_building_fall 10)
					(objects_can_see_flag player3 cf_building_fall 10)
				)
		)
		(sleep (* 30 (random_range 0 4))))
	;(wake m52_building_shake_player0)
	;(wake m52_building_shake_player1)
	;(wake m52_building_shake_player2)
	;(wake m52_building_shake_player3)			
	(device_set_position dm_building_fall 1)
	(sleep_until (>= (device_get_position dm_building_fall) 1))
	(object_destroy dm_building_fall)
)

(script dormant m52_building_shake_player0
	(if (<= (objects_distance_to_object player0 dm_building_fall) 100)(cam_shake_player player0 1 0.20 5 7))
)
(script dormant m52_building_shake_player1
	(if (<= (objects_distance_to_object player1 dm_building_fall) 100)(cam_shake_player player1 1 0.20 5 7))
)
(script dormant m52_building_shake_player2
	(if (<= (objects_distance_to_object player2 dm_building_fall) 100)(cam_shake_player player2 1 0.20 5 7))
)
(script dormant m52_building_shake_player3
	(if (<= (objects_distance_to_object player3 dm_building_fall) 100)(cam_shake_player player3 1 0.20 5 7))
)

;======================================================================
;===========================FX AMBIENT SCRIPTS=========================
;======================================================================

(global point_reference l_point sd_fx_master/p0)
(global point_reference n_point sd_fx_master/p1)
(global point_reference o_point sd_fx_master/p2)



(script dormant f_ground_fx_ambient
	(sleep_until
		(begin
			(set l_point (ai_random_smart_point sd_fx_master 0 2000 90))
				(cond
					((= l_point sd_fx_master/p0) 
						(begin
							(set n_point sd_fx_0)			
								(begin_random_count 1
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p1) 
						(begin			
							(set n_point sd_fx_1)												
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p2) 
						(begin
							(set n_point sd_fx_2)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p3) 
						(begin
							(set n_point sd_fx_3)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p4) 
						(begin
							(set n_point sd_fx_4)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p5) 
						(begin
							(set n_point sd_fx_5)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p6) 
						(begin
							(set n_point sd_fx_6)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p7) 
						(begin
							(set n_point sd_fx_7)																				
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p8) 
						(begin
							(set n_point sd_fx_8)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p9) 
						(begin
							(set n_point sd_fx_9)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p10) 
						(begin
							(set n_point sd_fx_10)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p11) 
						(begin
							(set n_point sd_fx_11)																				
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p12) 
						(begin
							(set n_point sd_fx_12)																				
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p13) 
						(begin
							(set n_point sd_fx_13)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p14) 
						(begin
							(set n_point sd_fx_14)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)																								
				)
		FALSE)
	(random_range 15 30))
)
(script dormant f_ground_fx_ambient_2
	(sleep_until
		(begin
			(set l_point (ai_random_smart_point sd_fx_master 0 2000 90))
				(cond
					((= l_point sd_fx_master/p0) 
						(begin
							(set n_point sd_fx_0)			
								(begin_random_count 1
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p1) 
						(begin			
							(set n_point sd_fx_1)													
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p2) 
						(begin
							(set n_point sd_fx_2)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p3) 
						(begin
							(set n_point sd_fx_3)																	
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p4) 
						(begin
							(set n_point sd_fx_4)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p5) 
						(begin
							(set n_point sd_fx_5)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p6) 
						(begin
							(set n_point sd_fx_6)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p7) 
						(begin
							(set n_point sd_fx_7)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p8) 
						(begin
							(set n_point sd_fx_8)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p9) 
						(begin
							(set n_point sd_fx_9)																		
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p10) 
						(begin
							(set n_point sd_fx_10)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p11) 
						(begin
							(set n_point sd_fx_11)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p12) 
						(begin
							(set n_point sd_fx_12)																				
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point sd_fx_master/p13) 
						(begin
							(set n_point sd_fx_13)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point sd_fx_master/p14) 
						(begin
							(set n_point sd_fx_14)																			
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)																								
				)
		FALSE)
	(random_range 15 30))
)
(script static void (f_ground_fx_ambient_test (short l_point))
	(sleep_until
		(begin
				(cond
					((= l_point 0) 
						(begin
							(set n_point sd_fx_0)
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 1) 
						(begin
							(set n_point sd_fx_1)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point 2) 
						(begin
							(set n_point sd_fx_2)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 3) 
						(begin
							(set n_point sd_fx_3)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)

						)
					)

					((= l_point 4) 
						(begin
							(set n_point sd_fx_4)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 5) 
						(begin
							(set n_point sd_fx_5)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point 6) 
						(begin
							(set n_point sd_fx_6)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)

						)
					)
					((= l_point 7) 
						(begin
							(set n_point sd_fx_7)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point 8) 
						(begin
							(set n_point sd_fx_8)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 9) 
						(begin
							(set n_point sd_fx_9)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point 10) 
						(begin
							(set n_point sd_fx_10)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 11) 
						(begin
							(set n_point sd_fx_11)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)

					((= l_point 12) 
						(begin
							(set n_point sd_fx_12)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 13) 
						(begin
							(set n_point sd_fx_13)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
					((= l_point 14) 
						(begin
							(set n_point sd_fx_14)						
								(begin_random_count 1						
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_1.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_2.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_3.effect" n_point)
									(effect_new_random "levels\solo\m52\fx\street_battle_fx\street_battle_4.effect" n_point)
								)
						)
					)
				)
			;(print "BOOMTEST ELOL!")
		FALSE)
	30)
)

(script dormant title_start
	(f_hud_chapter ct_start)
)

(script dormant title_final
	(sleep_until (and (= (f_all_hub_check) true) (= (f_players_flying) true))5)
	(f_hud_chapter ct_final)
)

; -------------------------------------------------------------------------------------------------
; WEATHER
; -------------------------------------------------------------------------------------------------
(global boolean b_rain_is_active                true)
(global boolean b_rain_always_thunderclap       true)
(global short s_rain_min_on_time                60)
(global short s_rain_max_on_time                180)
(global short s_rain_min_off_time               30)
(global short s_rain_max_off_time               45)
(global short s_rain_min_ramp_up_time           2)
(global short s_rain_max_ramp_up_time           10)
(global short s_rain_min_ramp_down_time 6)
(global short s_rain_max_ramp_down_time 12)
(global short s_rain_min_lightning_delay        5)
(global short s_rain_max_lightning_delay        20)
(global short s_rain_min_thunder_delay          1)
(global short s_rain_max_thunder_delay          3)

; -------------------------------------------------------------------------------------------------

(script dormant weather_lightning
			(weather_animate_force light_rain 1 0)
       ;(weather_lightning_flash)
       (sleep_until
              (begin
                     (sleep_range_seconds s_rain_min_lightning_delay s_rain_max_lightning_delay)
                     (weather_lightning_flash)
                     (if b_rain_is_active
                           (sleep_range_seconds s_rain_min_thunder_delay s_rain_max_thunder_delay)
                           (sleep_range_seconds (* 3 s_rain_min_thunder_delay) (* 3 s_rain_max_thunder_delay)))
                     (weather_thunder_clap)
              0)
       60)
)

(script static void weather_lightning_flash
       ;(print "weather: flash!")
       (interpolator_start lightning ))

(script static void cinematic_lightning_flash
 (weather_lightning_flash)
 (sleep_range_seconds s_rain_min_thunder_delay s_rain_max_thunder_delay)
 (sleep_range_seconds (* 3 s_rain_min_thunder_delay) (* 3 s_rain_max_thunder_delay))
 (weather_thunder_clap)
)   
(script static void weather_thunder_clap
       (if (and (not (f_any_hub_check)) b_rain_is_active b_rain_always_thunderclap) 
              (begin
                     ; (if debug ;(print "weather: thunder clap!"))
                     (sound_impulse_start sound\levels\solo\weather\thunder_claps.sound NONE 1)
                     (sleep (* 30 2.5))
              )      
              (begin
                     ; (if debug ;(print "weather: rolling thunder..."))              
                     (sound_impulse_start sound\levels\solo\weather\rain\details\thunder.sound NONE 1)
              )
       )
)


(script static void (sleep_range_seconds (short minsleep) (short maxsleep))
       (sleep (random_range (* 30 minsleep) (* 30 maxsleep))))


;*
ct_objective_new			= ">>> NEW OBJECTIVE:"
ct_objective_end			= ">>> OBJECTIVE COMPLETE"
0		= "Destroy Covenant Jammer at the Hospital"
1		= "Destroy Covenant Jammer at the Tower"
2 	= "Destroy Covenant Jammer in Sinoviet Industries"
3		= "Fly to the Oni Building"
4		= "Help the Pelicans Evac by destroying all nearby Anti-Air"
5		= "Dock at the Oni Hangar"
6		= "Rescue marines from Brutes"
7		= "Rescue marines from Skirmishers"
8		= "Rescue marines from Hunters"
9		= "Protect the Marines and Kill the Jackal Snipers"
10	= "Help the Pelican and destroy the Anti-Air Turrets"
11	= "Take down the Banshees to assist the Marines"
12	= "Protect the ODST in a Falcon"
13	= "Help Buck rescue his squadmates"
14	= "Assist the ODST in rescuing some troopers"
15	= "Destroy a Jammer and eliminate the covenant"
16	= "Kill the elites and engineers"
17	= "Take out the covenant infantry and anti-air turrets"
ct_objective_bldg_a 			= "DESTROY COVENANT JAMMER AT THE HOSPITAL"
ct_objective_bldg_b			= "DESTROY COVENANT JAMMER AT THE TOWER"
ct_objective_bldg_c			= "DESTROY COVENANT JAMMER AT SINOVIET INDUSTRIES"
ct_objective_oni			= "GO TO ONI BUILDING"
ct_objective_oni_aa			= "DESTROY ALL ANTI-AIR TURRETS"
ct_objective_oni_end			= "LAND AT ONI"
ct_objective_alpha_1			= "DEFEND MARINES AGAINST BRUTES"
ct_objective_alpha_2 			= "DEFEND MARINES AGAINST JACKALS"
ct_objective_alpha_3 			= "DEFEND MARINES AGAINST HUNTERS"
ct_objective_beta_1 			= "KILL JACKAL SNIPERS"
ct_objective_beta_2			= "ASSIST THE PELICAN"
ct_objective_beta_3 			= "DESTROY THE BANSHEES"
ct_objective_gamma_1 			= "ESCORT THE FALCON"
ct_objective_gamma_2			= "ESCORT THE FALCON"
ct_objective_gamma_3 			= "ESCORT THE FALCON"
ct_objective_delta_1 			= "DESTROY THE JAMMER AND INFANTRY"
ct_objective_delta_2 			= "KILL ELITES AND ENGINEERS"
ct_objective_delta_3			= "DESTROY THE ANTI-AIR AND INFANTRY"
ct_emergency_evac			= "PREPARE FOR EMERGENCY EVAC"
ct_too_low				= "TOO LOW!! PULL UP!!!"
*;