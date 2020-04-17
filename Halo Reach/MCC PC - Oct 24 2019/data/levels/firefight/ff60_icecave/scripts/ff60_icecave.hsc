; ================================================================================================================
; ====== M60 ICE CAVE FIREFIGHT SCIRPTS =========================================================================
; ================================================================================================================
(global short s_round -1)
(global boolean g_timer_var FALSE)

(script startup ff60_icecave

		;(game_force_survival_immediate)
	
		; set allegiances 
		(ai_allegiance human player)
		(ai_allegiance player human)
;		(ai_allegiance covenant prophet)
;		(ai_allegiance prophet covenant)
		
	
		; snap to black 
		(if (> (player_count) 0) (cinematic_snap_to_black))
		(sleep 5)
		
		; switch to the proper zone set 
		(switch_zone_set set_firefight)

		(wake sur_kill_vol_disable)
		
		;set time between waves
		(set k_sur_wave_timer 90)
		
		
	;FIRETEAM SETUP
	(set ai_sur_fireteam_squad0 sur_fireteam_01)
	(set ai_sur_fireteam_squad1 sur_fireteam_02)
	(set ai_sur_fireteam_squad2 sur_fireteam_03)
	(set ai_sur_fireteam_squad3 sur_fireteam_04)
	(set ai_sur_fireteam_squad4 sur_fireteam_05)
	(set ai_sur_fireteam_squad5 sur_fireteam_06)
	
	; ===================================================================
	; wave parameters ===================================================
	; ===================================================================

	; define survival objective name 
	(set ai_obj_survival obj_survival)
	

	;turning on sandbox objects for cover
	;(object_create_folder cr_sandbox_items)
	
	; ===================================================================
	; phantom parameters ================================================
	; ===================================================================
	
	
		; assign phantom squads to global ai variables 
			(set ai_sur_phantom_01 sq_sur_phantom_01)
			(set ai_sur_phantom_02 sq_sur_phantom_02)
			(set ai_sur_phantom_03 sq_sur_phantom_03)
			(set ai_sur_phantom_04 sq_sur_phantom_04)
	
			; set phantom load parameters 
				(set s_sur_drop_side_01 "dual")
				(set s_sur_drop_side_02 "dual")
				(set s_sur_drop_side_03 "dual")
				(set s_sur_drop_side_04 "dual")
				;(set b_sur_dropship_r1_initial TRUE)
				;(set b_sur_dropship_r2_initial TRUE)
				;(set b_sur_dropship_r3_initial TRUE)
				;(set b_sur_dropship_r1_primary TRUE)
				;(set b_sur_dropship_r2_primary TRUE)
				;(set b_sur_dropship_r3_primary TRUE)
				;(set b_sur_dropship_r1_boss TRUE)
				;(set b_sur_dropship_r2_boss TRUE)
				;(set b_sur_dropship_r3_boss TRUE)

	;setting wave spawn group
	(set ai_sur_wave_spawns gr_survival_waves)
	
	;controls how many squads are spawned
	(set s_sur_wave_squad_count 6)
	
	; How many generators are active. 3 max, 0 disables generator defense
	;(set s_sur_generator_count 0)

	; Game over if ANY generators die if true
	;(set b_sur_generator_defend_all true)

	; Randomly selects the generators if true
	;(set b_sur_generator_order_random false)

	; Set these three to named objects in your scenario
	; Recommend using tags/objects/temp/tysongr/unsc_shield_generator_anvil
	(set obj_sur_generator0 generator0)
	(set obj_sur_generator1 generator1)
	(set obj_sur_generator2 generator2)
	(set obj_sur_generator_switch0 generator_switch0)
	(set obj_sur_generator_switch1 generator_switch1)
	(set obj_sur_generator_switch2 generator_switch2)
	(set obj_sur_generator_switch_cool0 generator_switch_cool0)
	(set obj_sur_generator_switch_cool1 generator_switch_cool1)
	(set obj_sur_generator_switch_cool2 generator_switch_cool2)
	(set obj_sur_generator_switch_dis0 generator_switch_disabled0)
	(set obj_sur_generator_switch_dis1 generator_switch_disabled1)
	(set obj_sur_generator_switch_dis2 generator_switch_disabled2)

	
	(set ai_sur_remaining sq_sur_remaining)

	; ==============================================================
	; bonus round parameters =======================================
	; ==============================================================
		
	;BONUS SQUAD SETUP
	(set ai_sur_bonus_wave sq_ff_bonus)
           
     ;BONUS PHANTOM SETUP
     (set ai_sur_bonus_phantom sq_sur_bonus_phantom)
			

	; begin survival mode  ============================================

	; wake the survival mode global scirpt 
	(wake survival_mode)
	(wake weapon_drop_control)		
;	(wake ordnance_waypoint_control)
	(sleep 5)
	
)

; ==============================================================================================================
; ====== SECONDARY SCIRPTS =====================================================================================
; ==============================================================================================================
(script static void survival_refresh_follow
	(survival_refresh_sleep)
	(ai_reset_objective obj_survival/main_follow)
)

(script static void survival_refresh_generator
	(survival_refresh_sleep)
	(ai_reset_objective obj_survival/generator)
)

(script static void survival_hero_refresh_follow
	(survival_refresh_sleep)
	(survival_refresh_sleep)
	(ai_reset_objective obj_survival/hero_follow)
)

(script static void (survival_set_hold_task (ai squad))
       (ai_set_task squad obj_survival hold_task)
)

;===============================================================================================================
;====== WRAITH FIRING BEHAVIOR =================================================================================
;===============================================================================================================
(global boolean b_phantomw_01_1 TRUE)
(global boolean b_phantomw_01_2 TRUE)
(global boolean b_phantomw_02_1 TRUE)
(global boolean b_phantomw_02_2 TRUE)
(global boolean b_phantomw_03_1 TRUE)
(global boolean b_phantomw_03_2 TRUE)
(global boolean b_phantomw_04_1 TRUE)
(global boolean b_phantomw_04_2 TRUE)

(script command_script abort_cs
	(sleep 1)
)

(script command_script cs_wraith_shoot
  	(cs_run_command_script sq_sur_wraith_01/gunner abort_cs) 
     (cs_run_command_script sq_sur_wraith_02/gunner abort_cs) 
     (cs_enable_moving TRUE)
     (ai_suppress_combat ai_current_actor FALSE)
     (sleep (* 30 5))
     (sleep_until
   		(begin
         		(begin_random
                   (begin
                         (sleep (random_range 60 150))
                         (cs_shoot_point TRUE ps_wraith/p0)
                   )
                   (begin
                         (sleep (random_range 60 150))
                         (cs_shoot_point TRUE ps_wraith/p1)
                   )
                   (begin
                         (sleep (random_range 60 150))
                         (cs_shoot_point TRUE ps_wraith/p2)
                   )
                   (begin
                         (sleep (random_range 60 150))
                         (cs_shoot_point TRUE ps_wraith/p3)
                   )
          	)
       	FALSE)
 	)
)

(script command_script cs_wraith_lock
      (cs_run_command_script sq_sur_wraith_01/gunner abort_cs) 
      (cs_run_command_script sq_sur_wraith_02/gunner abort_cs) 
      (cs_enable_moving TRUE)
       	(sleep 5)
      (sleep_until (volume_test_players tv_null))
)



; ==============================================================================================================
; ====== PHANTOM COMMAND SCRIPTS ===============================================================================
; ==============================================================================================================

(script command_script cs_sur_phantom_01
	(set v_sur_phantom_01 (ai_vehicle_get_from_starting_location sq_sur_phantom_01/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_01 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE) 		
	(object_set_shadowless sq_sur_phantom_01/phantom TRUE)
	
			; ======== LOAD GHOST ==================
			(if	(survival_mode_scenario_extras_enable)	
				(if 	
					(and 
						(= (random_range 0 2) 0)
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sur_ghost_01/ghost)) 0)
					)
					(f_load_phantom_cargo
										v_sur_phantom_01
										"single"
										sq_sur_ghost_01
										none
					)
				)
			)
			; ======== /LOAD GHOST  ==================
	
	;=========== APPROACH ==============
	(cs_vehicle_boost TRUE)		
	(cs_fly_by ps_sur_phantom_01/p0_new)
	(cs_fly_by ps_sur_phantom_01/p1_new)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_sur_phantom_01/p2)
	;Lock Wraith 01
	(set b_phantomw_01_1 FALSE)
	(cs_vehicle_speed 0.50)
	(cs_fly_to_and_face ps_sur_phantom_01/p3 ps_sur_phantom_01/face 1)
	(unit_open v_sur_phantom_01)
	(wake phantom_01_blip)
	;(cs_vehicle_speed 0.50)
		(sleep 15)

				
	;=========== SELECT ONE-STOP OR TWO-STOP DROP =============
	(begin
		(if (= (random_range 1 3) 1)
			;======= ONE-STOP ==========
			(begin
				(vehicle_unload v_sur_phantom_01 "phantom_lc")
				
				(f_unload_phantom
								v_sur_phantom_01
								"dual"
				)
			)
			;======= TWO-STOP ==========
			(begin
				;====== DROP GHOST AND LEFT PAYLOAD =======
				(vehicle_unload v_sur_phantom_01 "phantom_lc")
				
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_P_lb") 1)
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lf") 1)
					)

					(begin
						(f_unload_phantom
										v_sur_phantom_01
										"left"
						)
					)

					(begin
						(sleep 150)
					)	

				)
				; ======== FLY TO NEXT POINT ======================
			
				(cs_fly_to_and_face ps_sur_phantom_01/p4 ps_sur_phantom_01/face 1)
			
				;======== DROP RIGHT PAYLOAD ======================
				
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rb") 1)
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rf") 1)
					)
					
					(begin
						(f_unload_phantom
										v_sur_phantom_01
										"right"
						)
					)
					
					(begin
						(sleep 150)
					)
				)
			
			
			
			)
		
		)
	)
	
	;=========== RETREAT ROUTE ====================	

		(sleep 15)
	(unit_close v_sur_phantom_01)
	(cs_fly_by ps_sur_phantom_01/p2)
	;Unlock wraith 01
	(set b_phantomw_01_1 TRUE)
	(set b_phantomw_01_2 TRUE)
	(cs_vehicle_speed 1.00)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_01/p1_new)
	(cs_fly_by ps_sur_phantom_01/p0_new)
	(cs_fly_by ps_sur_phantom_01/erase_new 5)
	(cs_vehicle_boost FALSE)
	; erase squad 
	(ai_erase ai_current_squad)
	;(ai_erase sq_sur_phantom_01)
)

(script continuous phantom_01_blip
	(sleep_forever)
	(print "blipping phantom_01...")
	(f_survival_callout_dropship v_sur_phantom_01)
)


; ============================================================================================================================
(script command_script cs_sur_phantom_02
	(set v_sur_phantom_02 (ai_vehicle_get_from_starting_location sq_sur_phantom_02/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_02 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(object_set_shadowless sq_sur_phantom_02/phantom TRUE)
	
			; ======== LOAD WRAITH  ==================
			(if (survival_mode_scenario_extras_enable)
				(if 	
					(and 
						(= (random_range 0 3) 0)
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sur_wraith_01/driver)) 0)
					)
					(f_load_phantom_cargo
										v_sur_phantom_02
										"single"
										sq_sur_wraith_01
										none
					)
				)
			)
			; ======== /LOAD WRAITH  ==================	
	
	;========== APPROACH =================		
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_02/p0_new)
	(cs_fly_by ps_sur_phantom_02/p1_new)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_phantom_02/p2)
	(cs_vehicle_speed 0.50)
	(cs_fly_to_and_face ps_sur_phantom_02/p3 ps_sur_phantom_02/face 1)
	(unit_open v_sur_phantom_02)
	(wake phantom_02_blip)
		(sleep 15)

	; ============ SELECT ONE-STOP OR THREE-STOP DROP ===============

	(if
		(= (random_range 0 2) 0)
		; ===== ONE-STOP ==========
		(begin
			(f_unload_phantom
								v_sur_phantom_02
								"dual"
			)
				
			; drop wraith if present 
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_lc") 1)
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p4 ps_sur_phantom_02/face 1)
					(vehicle_unload v_sur_phantom_02 "phantom_lc")
					)
			)
		)
		; ====== THREE-STOP =========
		(begin
			(unit_open v_sur_phantom_02)
			(sleep 30)
			; === Drop half of payload ====
			(if
				(or
					(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rf") 1)
					(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_lb") 1)
				)
				
				;troops present, conduct drop
				(begin
					(vehicle_unload v_sur_phantom_02 "phantom_p_rf")
					(vehicle_unload v_sur_phantom_02 "phantom_p_lb")
					(sleep_until
						(and
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rf") 0)
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_lb") 0)
						)
					)
					(sleep 150)
				)
				;no troops, just wait at point
				(begin
					(sleep 300)
				)
			
			
			)
			
			; drop wraith if present and fly to next point 
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_lc") 1)
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p4 ps_sur_phantom_02/face 1)
					(vehicle_unload v_sur_phantom_02 "phantom_lc")
					)
			)
			;Lock Wraith 01
			(set b_phantomw_02_1 FALSE)			
			
			; ===== Drop 1/4 of payload =====
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rb") 1)
				
				; troops present, conduct drop and fly to next point
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p5_1 ps_sur_phantom_02/face2 1)
					(cs_fly_to_and_face ps_sur_phantom_02/p5 ps_sur_phantom_02/face2 1)
					;Lock Wraith 02
					(set b_phantomw_02_2 FALSE)
					(vehicle_unload v_sur_phantom_02 "phantom_p_rb")
					(sleep_until 
						(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rb") 0)
					)

					(sleep 60)
				)
				; Just wait point, no drop, then fly to next point
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p5_1 ps_sur_phantom_02/face2 1)
					(cs_fly_to_and_face ps_sur_phantom_02/p5 ps_sur_phantom_02/face2 1)
					;Lock Wraith 02
					(set b_phantomw_02_2 FALSE)
					(sleep 250)
				)
			)
			; ===== Drop 1/4 of payload =====
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_lf") 1)
				
				;troops present, conduct drop
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p6 ps_sur_phantom_02/face3 1)
					(vehicle_unload v_sur_phantom_02 "phantom_p_lf")
					(sleep_until 
						(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_lf") 0)
					)
					(sleep 30)
				)
				; Just wait at next point, no drop
				(begin
					(cs_fly_to_and_face ps_sur_phantom_02/p6 ps_sur_phantom_02/face3 1)
					(vehicle_unload v_sur_phantom_02 "phantom_p_lf")
					(sleep 180)
				)
			)
			; ====== Begin Retreat Route ==========
			(cs_vehicle_speed 0.5)
			(cs_fly_by ps_sur_phantom_02/p10)
			;Unlock Wraiths 
			(set b_phantomw_02_1 TRUE)
			(set b_phantomw_02_2 TRUE)
		
		)
	)
	
	; ============ RETREAT ROUTE =================	
	(set b_phantomw_02_1 TRUE)
	(set b_phantomw_02_2 TRUE)
	(unit_close v_sur_phantom_02)
	(cs_vehicle_speed 0.5)
	;(cs_fly_by ps_sur_phantom_02/p2)
	(cs_fly_by ps_sur_phantom_02/p1_new)
	(cs_vehicle_speed 1.0)
	(sleep 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_02/p0_new)
	(cs_fly_by ps_sur_phantom_02/erase_pre)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_sur_phantom_02/erase_new 10)
	; erase squad 
	(ai_erase ai_current_squad)
	;(ai_erase sq_sur_phantom_02)
)

(script continuous phantom_02_blip
	(sleep_forever)
	(print "blipping phantom_02...")
	(f_survival_callout_dropship v_sur_phantom_02)
)


; ==========================================================================================================================
(script command_script cs_sur_phantom_03
	(set v_sur_phantom_03 (ai_vehicle_get_from_starting_location sq_sur_phantom_03/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_03 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)		
	
	(cs_vehicle_boost TRUE)
	(sleep 30)
	(cs_fly_by ps_sur_phantom_03/p0_pre_new)		
	(cs_fly_to_and_face ps_sur_phantom_03/p1_new ps_sur_phantom_03/face3 1)
	(cs_vehicle_boost FALSE)
	


				
	;=========== SELECT ONE-STOP OR TWO-STOP DROP =============
	(begin
		(if (= (random_range 1 3) 1)
			;======= ONE-STOP ==========
			(begin

				(set b_phantomw_03_2 FALSE)
				(cs_fly_to_and_face ps_sur_phantom_03/p2 ps_sur_phantom_03/face4 1)
				(cs_vehicle_speed 0.5)
				(cs_fly_to_and_face ps_sur_phantom_03/p3 ps_sur_phantom_03/face 1)
				(unit_open v_sur_phantom_03)
				(wake phantom_03_blip)
					(sleep 15)
				
				(f_unload_phantom
								v_sur_phantom_03
								"dual"
				)
				(set b_phantomw_03_2 TRUE)
			)
			;======= TWO-STOP ==========
			(begin
				;====== DROP RIGHT PAYLOAD =======

				(cs_vehicle_speed 0.5)
				(cs_fly_by ps_sur_phantom_03/p4)
				(cs_fly_to_and_face ps_sur_phantom_03/p5 ps_sur_phantom_03/face_5 1)
				(unit_open v_sur_phantom_03)
				(wake phantom_03_blip)
					(sleep 15)
				
				;check for troops on right side of phantom
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_rb") 1)
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_rf") 1)
					)
					
					;troops present on right side, conduct drop
					(begin
						(f_unload_phantom
										v_sur_phantom_03
										"right"
						)
					)
					
					;no troops present, just wait at point
					(begin
						(sleep 150)
					)
				)
				
				
				; ======== FLY TO NEXT POINT ======================
				
				(cs_vehicle_speed 0.5)
				(cs_fly_to_and_face ps_sur_phantom_03/p6 ps_sur_phantom_03/face_2 1)
				(cs_fly_by ps_sur_phantom_03/p2)
				(set b_phantomw_03_2 FALSE)
				(cs_fly_to_and_face ps_sur_phantom_03/p3 ps_sur_phantom_03/face 1)

			
				;======== DROP LEFT PAYLOAD ======================
				
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lb") 1)
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lf") 1)
					)
					;troops present on left side, conduct drop
					(begin
						(f_unload_phantom
										v_sur_phantom_03
										"left"
						)
					)
					;no troops, just wait at point
					(begin
						(sleep 150)
					)
				)
							
			)
		
		)
	)

		
	; ========= RETREAT ROUTE ========================
	
		(sleep 15)
	(unit_close v_sur_phantom_03)
	(set b_phantomw_03_1 TRUE)
	(set b_phantomw_03_2 TRUE)
	(cs_vehicle_speed 0.75)
	(cs_fly_to_and_face ps_sur_phantom_03/p2 ps_sur_phantom_03/p0_pre_new 1)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_03/p0_pre_new)
	(cs_fly_by ps_sur_phantom_03/erase_pre)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_sur_phantom_03/erase 5)
	; erase squad 
	(ai_erase ai_current_squad)
	;(ai_erase sq_sur_phantom_03)
)

(script continuous phantom_03_blip
	(sleep_forever)
	(print "blipping phantom_03...")
	(f_survival_callout_dropship v_sur_phantom_03)
)


; ================================================================================================================================
(script command_script cs_sur_phantom_04
	(set v_sur_phantom_04 (ai_vehicle_get_from_starting_location sq_sur_phantom_04/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_04 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_ignore_obstacles TRUE)	
	
			; ======== LOAD WRAITH  ==================
			(if (survival_mode_scenario_extras_enable)
				(if 	
					(and 
						(= (random_range 0 3) 0)
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sur_wraith_02/driver)) 0)
					)
					(f_load_phantom_cargo
										v_sur_phantom_04
										"single"
										sq_sur_wraith_02
										none
					)
				)
			)
			; ======== LOAD WRAITH  ==================
	(cs_vehicle_boost TRUE)
;	(sleep 30)		
	(cs_fly_to_and_face ps_sur_phantom_04/p0_new ps_sur_phantom_04/p1_new 5)
	(cs_fly_by ps_sur_phantom_04/p1_new)
	(cs_vehicle_boost FALSE)
	
	;======== SELECT LEFT TO RIGHT, OR RIGHT TO LEFT DROPOFF ===========
	;======== NOTE: RIGHT TO LEFT DROPOFF IS INACTIVE, AND IS NO LONGER USED ===========
	(if
		(= (random_range 0 1) 0)
			; ========== BEGIN DROPOFF, LEFT TO RIGHT =============
			
			(begin
				(cs_fly_by ps_sur_phantom_04/p2)
				(unit_open v_sur_phantom_04)
				(cs_vehicle_speed 0.6)
				(cs_fly_to_and_face ps_sur_phantom_04/p3 ps_sur_phantom_04/face 1)
				(wake phantom_04_blip)
				(sleep 15)
				
				(cs_vehicle_speed 0.3)
				
				; Point L1
				(if
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lb") 1)
				
					(begin						
						(vehicle_unload v_sur_phantom_04 "phantom_p_lb")
						(sleep_until (= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lb") 0))
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
		
				)
				
				; Point L2
				(cs_fly_to_and_face ps_sur_phantom_04/p4 ps_sur_phantom_04/face2 1)
				
				(if
				
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lf") 1)
					
					(begin
						(vehicle_unload v_sur_phantom_04 "phantom_p_lf")
						(sleep_until (= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lf") 0))
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
				)
				
				(cs_fly_to_and_face ps_sur_phantom_04/p4_2 ps_sur_phantom_04/face2 1)
				(cs_fly_to_and_face ps_sur_phantom_04/p4_3 ps_sur_phantom_04/face2 1)
				
				;Point Center - drop Wraith (if present) during this flyby 
				(cs_fly_to_and_face ps_sur_phantom_04/p4_1 ps_sur_phantom_04/face3 1)
				(set b_phantomw_04_2 FALSE)
				(vehicle_unload v_sur_phantom_04 "phantom_lc")
				
				; Point L3/R2
				(cs_fly_to_and_face ps_sur_phantom_04/p5 ps_sur_phantom_04/face4 1)
				
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 1)
						(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 1)
					)
					(begin
						(f_unload_phantom
										v_sur_phantom_04
										"right"
						)
;						(vehicle_unload v_sur_phantom_04 "phantom_p_rf")
						(sleep_until 
							(and
								(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 0)
								(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 0)
							)
						)
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
				)
				
			)
			; =========== END DROPOFF, LEFT TO RIGHT ================

			; ========== BEGIN DROPOFF, RIGHT TO LEFT =============
			; ========== INACTIVE, DO NOT USE ==============
			
			(begin
				(cs_fly_by ps_sur_phantom_04/p8)
				(sleep 75)	
				(cs_fly_by ps_sur_phantom_04/p7)
				(cs_vehicle_speed 0.4)
				(sleep 150)
				(cs_vehicle_speed 0.3)
				(cs_fly_to_and_face ps_sur_phantom_04/p6 ps_sur_phantom_04/face5 1)
				(unit_open v_sur_phantom_04)
				(wake phantom_04_blip)
				(sleep 15)
				
				(cs_vehicle_speed 0.3)
				
				; Point R1/L4
;				(sleep 30)
;				(if
;					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 1)
;				
;					(begin
;						(vehicle_unload v_sur_phantom_04 "phantom_p_rb")
;						(sleep_until (= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 0))
;						(sleep 30)
;					)
;					
;					(begin
;						(sleep 30)
;					)
;				)
				
				; Point R2/L3
				
				(cs_fly_to_and_face ps_sur_phantom_04/p5 ps_sur_phantom_04/face4 1)
				
				(if
					(or
						(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 1)
						(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 1)
					)
					
					(begin
						(f_unload_phantom
										v_sur_phantom_04
										"right"
						)
;						(vehicle_unload v_sur_phantom_04 "phantom_p_rf")
						(sleep_until 
							(and
								(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 0)
								(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 0)
							)
						)
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
				)
				;Dropoff Wraith at Point C if present
				(cs_fly_to_and_face ps_sur_phantom_04/p4_1 ps_sur_phantom_04/face3 1)
				(set b_phantomw_04_2 FALSE)
				(vehicle_unload v_sur_phantom_04 "phantom_lc")
							
				(cs_fly_to_and_face ps_sur_phantom_04/p4_3 ps_sur_phantom_04/face2 1)
				(cs_fly_to_and_face ps_sur_phantom_04/p4_2 ps_sur_phantom_04/face2 1)
				
				; Point R3/L2
				(cs_fly_to_and_face ps_sur_phantom_04/p4 ps_sur_phantom_04/face2 1)
				
				(if
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lf") 1)
				
					(begin
						(vehicle_unload v_sur_phantom_04 "phantom_p_lf")
						(sleep_until (= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lf") 0))
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
				)
				
				; Point R4/L1
				(cs_fly_to_and_face ps_sur_phantom_04/p3 ps_sur_phantom_04/face 1)
				
				(if
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lb") 1)
				
					(begin
						(vehicle_unload v_sur_phantom_04 "phantom_p_lb")
						(sleep_until (= (vehicle_test_seat v_sur_phantom_04 "phantom_p_lb") 0))
						(sleep 30)
					)
					
					(begin
						(sleep 30)
					)
				)
			)
			; =========== END DROPOFF, RIGHT TO LEFT ================

	)
			
	;============== RETREAT ROUTE =============================
	(sleep 15)
	(cs_vehicle_speed 0.75)
	(unit_close v_sur_phantom_04)
	(cs_fly_by ps_sur_phantom_04/p2)
	(set b_phantomw_04_1 TRUE)
	(set b_phantomw_04_2 TRUE)
	(cs_vehicle_speed 1.00)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_04/p1_new)
	(cs_fly_by ps_sur_phantom_04/p0_new)
	(cs_fly_by ps_sur_phantom_04/erase 1)
	(cs_vehicle_boost FALSE)
	; erase squad 
	(ai_erase ai_current_squad)
	;(ai_erase sq_sur_phantom_04)
)

(script continuous phantom_04_blip
	(sleep_forever)
	(print "blipping phantom_04...")
	(f_survival_callout_dropship v_sur_phantom_04)
)


;====================================================================================================================================


(script command_script cs_sur_bonus_phantom
	(set v_sur_bonus_phantom (ai_vehicle_get_from_spawn_point sq_sur_bonus_phantom/phantom))
		(sleep 1)
	(object_cannot_die v_sur_bonus_phantom TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)	
	(cs_fly_by ps_sur_bonus_phantom/p0)
	(cs_fly_by ps_sur_bonus_phantom/p1)
	(cs_fly_by ps_sur_bonus_phantom/p2)
	(cs_vehicle_boost FALSE)
	;(cs_vehicle_speed 0.35)
	(cs_fly_to_and_face ps_sur_bonus_phantom/p3 ps_sur_bonus_phantom/face 1)
	(wake phantom_bonus_blip)
		(sleep 15)

		; ======== DROP DUDES HERE ======================
			
			(set b_sur_bonus_phantom_ready TRUE)

		; ======== DROP DUDES HERE ======================
		
		; sleep until BONUS ROUND is over 
		(sleep_until b_sur_bonus_end)
			(sleep 45)
		
	; fly away 
		(sleep 15)
		;(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_bonus_phantom/p2)
		;(cs_vehicle_speed 1.00)
	(cs_fly_by ps_sur_bonus_phantom/p1)
	(cs_fly_by ps_sur_bonus_phantom/p0)
	(cs_fly_by ps_sur_bonus_phantom/erase 5)
	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_bonus_blip
	(sleep_forever)
	(print "blipping bonus phantom...")
	(f_survival_callout_dropship v_sur_bonus_phantom)
)

;======================================================= WEAPON BOX WAYPOINTS =================================================

;globals
(global boolean b_sur_resupply_waypoint_01 FALSE)
(global boolean b_sur_resupply_waypoint_02 FALSE)
(global boolean b_sur_resupply_waypoint_03 FALSE)



;checking if the weapon is in the weapon box still
(script static boolean (resupply_pod_test_weapon (object pod))
	(or
		(!= (object_at_marker pod "laser01") NONE)
		(!= (object_at_marker pod "rock01") NONE)
		(!= (object_at_marker pod "sniper01") NONE)
	)	
)

;turning on the waypoints
;(script continuous ordnance_waypoint_control
;	(sleep_until (survival_mode_should_drop_weapon) 5)
;	(wake weapon_waypoint_01)
;	(wake weapon_waypoint_02)
;	(wake weapon_waypoint_03)
;)


;turning on the waypoint for weapon box 1
(script continuous weapon_waypoint_01
	(sleep_forever)
	(print "placing waypoint on target 01...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_weapon_01 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_weapon_01)) 5)
	(f_unblip_object sc_weapon_01)
)

;(script continuous weapon_waypoint_01
;	(sleep_forever)
;	(print "placing waypoint on weapon box 01...")
;	(f_callout_object sc_weapon_01 blip_ordnance)
;	(sleep 60)
;	(f_blip_object sc_weapon_01 blip_ordnance)
;	(sleep_until (not (resupply_pod_test_weapon sc_weapon_01)) 5)
;	(f_unblip_object sc_weapon_01)
;)



;turning on the waypoint for weapon box 2
(script continuous weapon_waypoint_02
	(sleep_forever)
	(print "placing waypoint on target 02...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_weapon_02 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_weapon_02)) 5)
	(f_unblip_object sc_weapon_02)
)
;(script continuous weapon_waypoint_02
;	(sleep_forever)
;	(print "placing waypoint on weapon box 02...")
;	(f_callout_object sc_weapon_02 blip_ordnance)
;	(sleep 60)
;	(f_blip_object sc_weapon_02 blip_ordnance)
;	(sleep_until (not (resupply_pod_test_weapon sc_weapon_02)) 5)
;	(f_unblip_object sc_weapon_02)
;)


;turning on the waypoint for weapon box 3
(script continuous weapon_waypoint_03
	(sleep_forever)
	(print "placing waypoint on target 03...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_weapon_03 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_weapon_03)) 5)
	(f_unblip_object sc_weapon_03)
)
;(script continuous weapon_waypoint_03
;	(sleep_forever)
;	(print "placing waypoint on weapon box 03...")
;	(f_callout_object sc_weapon_03 blip_ordnance)
;	(sleep 60)
;	(f_blip_object sc_weapon_03 blip_ordnance)
;	(sleep_until (not (resupply_pod_test_weapon sc_weapon_03)) 5)
;	(f_unblip_object sc_weapon_03)
;)

;======================================================= WEAPON REPLENISH =====================================================

(script dormant weapon_drop_control
	(sleep_until
			(begin
				(sleep_until (survival_mode_should_drop_weapon) 5)
				
				(sleep 1)
				
				(print "refreshing weapon racks...")
					(object_create_folder_anew sc_weapons)
				(print "spawning in grenades...")
				(object_create_folder_anew cr_grenades)
				(wake weapon_waypoint_01)
				(wake weapon_waypoint_02)
				(wake weapon_waypoint_03)
			FALSE)
	)
)


;==============================================================================================================================

(script dormant sur_kill_vol_disable
	(kill_volume_disable kill_sur_room_01)
	(kill_volume_disable kill_sur_room_02)
	(kill_volume_disable kill_sur_room_03)
	(kill_volume_disable kill_sur_room_04)
	(kill_volume_disable kill_sur_room_05)
	(kill_volume_disable kill_sur_room_06)
	(kill_volume_disable kill_sur_room_07)
	(kill_volume_disable kill_sur_room_08)
	
	(print "disabling kill_volumes")
)

(script static void survival_kill_volumes_on 
	(kill_volume_enable kill_sur_room_01)
	(kill_volume_enable kill_sur_room_02)
	(kill_volume_enable kill_sur_room_03)
	(kill_volume_enable kill_sur_room_04)
	(kill_volume_enable kill_sur_room_05)
	(kill_volume_enable kill_sur_room_06)
	(kill_volume_enable kill_sur_room_07)
	(kill_volume_enable kill_sur_room_08)
)

(script static void survival_kill_volumes_off 
	(kill_volume_disable kill_sur_room_01)
	(kill_volume_disable kill_sur_room_02)
	(kill_volume_disable kill_sur_room_03)
	(kill_volume_disable kill_sur_room_04)
	(kill_volume_disable kill_sur_room_05)
	(kill_volume_disable kill_sur_room_06)
	(kill_volume_disable kill_sur_room_07)
	(kill_volume_disable kill_sur_room_08)
)


;Follow task scripts

;hero follow
;(<= (ai_task_count obj_survival/remaining) 3)

;main follow
;(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3))