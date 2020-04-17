; ================================================================================================================
; ====== FF60 AIRVIEW FIREFIGHT SCIRPTS =========================================================================
; ================================================================================================================
(global short s_round -1)
(global boolean g_timer_var FALSE)
(global boolean b_sur_resupply_waypoint_01 FALSE)
(global boolean b_sur_resupply_waypoint_02 FALSE)
(global boolean b_sur_resupply_waypoint_03 FALSE)
(global boolean b_sur_resupply_waypoint_04 FALSE)
(global boolean b_sur_resupply_waypoint_05 FALSE)
(global boolean b_sur_resupply_waypoint_06 FALSE)
(global boolean b_sur_resupply_waypoint_07 FALSE)
(global boolean b_sur_resupply_waypoint_08 FALSE)
(global boolean b_sur_resupply_waypoint_09 FALSE)

(script startup ff60_airview

		; don't allow the BFG to take damage
		(object_cannot_take_damage sc_bfg_default)
		(object_cannot_take_damage sc_bfg_destroyed)

		;(game_force_survival_immediate)
		
		; set allegiances 
		(ai_allegiance human player)
		(ai_allegiance player human)
	
		; snap to black 
		(if (> (player_count) 0) (cinematic_snap_to_black))
		(sleep 5)
		
		; switch to the proper zone set 
		(switch_zone_set set_firefight)

		(wake sur_kill_vol_disable)
		
	;TIME BETWEEN WAVES
	(set k_sur_wave_timer 0)
	
	;FIRETEAM SETUPw
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
			(set s_sur_drop_side_02 "right")
			(set s_sur_drop_side_03 "left")
			(set s_sur_drop_side_04 "right")

	;setting wave spawn group
	(set ai_sur_wave_spawns gr_survival_waves)
	
	;controls how many squads are spawned
	(set s_sur_wave_squad_count 6)

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

		
		; !!!! phantom / ground parameters WTF ???? 
		;(set b_sur_bonus_phantom TRUE)
		;(set b_sur_bonus_ground FALSE)
		
		;BONUS SQUAD SETUP
		(set ai_sur_bonus_wave sq_ff_bonus)
		;BONUS PHANTOM SETUP
		(set ai_sur_bonus_phantom sq_sur_bonus_phantom)		
	

	

	; begin survival mode  ============================================

		; wake the survival mode global scirpt for Extras
;	(if (survival_mode_scenario_extras_enable)
;		(wake survival_jackal_spawn)
;	)

	; wake the survival mode global scirpt 
	(wake survival_mode)
	(wake survival_resupply_pod_spawn)
	;(wake survival_kill_player)
	(sleep 5)
	
)

; ==============================================================================================================
; ====== SECONDARY SCRIPTS =====================================================================================
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
       (ai_set_task squad obj_survival hold)
)


; ==============================================================================================================
; ====== PHANTOM COMMAND SCIRPTS ===============================================================================
; ==============================================================================================================


;=============================== phantom_01 ===============================================================================================================

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
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sur_ghost_01/driver)) 0)
					)
					(f_load_phantom_cargo
										v_sur_phantom_01
										"single"
										sq_sur_ghost_01
										none
					)
				)
			)
			; ======== LOAD GHOST  ==================
		(cs_vehicle_speed 0.75)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_01/run_01)

		; ======== DROPOFF ======================
		(cs_vehicle_boost FALSE)
		(cs_vehicle_speed 0.75)
		(cs_fly_to ps_sur_phantom_01/run_02)
		(cs_vehicle_speed 0.5)
		(cs_fly_to_and_face ps_sur_phantom_01/hover_01 ps_sur_phantom_01/face_01 1)
		(unit_open v_sur_phantom_01)
		(wake phantom_01_blip)
		(sleep 30)
		
			;======== POINT 1 ==========
			(cs_fly_to_and_face ps_sur_phantom_01/drop_01 ps_sur_phantom_01/face_01 1)
			(vehicle_unload v_sur_phantom_01 "phantom_lc")
			(if
				(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lb") 1)
				(begin
					(vehicle_unload v_sur_phantom_01 "phantom_p_lb")
					(sleep_until
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lb") 0)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			
			;========== POINT 2 =========
			(cs_vehicle_speed 0.25)
			(cs_fly_to_and_face ps_sur_phantom_01/drop_02a ps_sur_phantom_01/face_02 1)
			(if
				(or
					(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rf") 1)
					(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rb") 1)
				)
				(begin
					(vehicle_unload v_sur_phantom_01 "phantom_p_rf")
					(vehicle_unload v_sur_phantom_01 "phantom_p_rb")
					(sleep_until
						(and
							(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rf") 0)
							(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_rb") 0)
						)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			
			;========= POINT 3 =========
			(cs_fly_to_and_face ps_sur_phantom_01/drop_02b ps_sur_phantom_01/face_02 1)
			(if
				(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lf") 1)
				(begin
					(vehicle_unload v_sur_phantom_01 "phantom_p_lf")
					(sleep_until
						(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lf") 0)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				) 
			)
			
	
			; ======== OLD DROPOFF ========== 		
			; drop ghost
			;(if
			;	(= (vehicle_test_seat v_sur_phantom_01 "phantom_lc") 1)
			;	(begin
			;		(cs_fly_by ps_sur_phantom_01/run_02)
			;		(cs_vehicle_boost FALSE)
			;		(cs_vehicle_speed 0.5)
			;		(cs_fly_to_and_face ps_sur_phantom_01/hover_01 ps_sur_phantom_01/face_01 1)
			;		(wake phantom_01_blip)
			;		(cs_fly_to_and_face ps_sur_phantom_01/drop_01 ps_sur_phantom_01/face_01 1)					
			;		(vehicle_unload v_sur_phantom_01 "phantom_lc")
			;	)	
			;	(begin
			;		(cs_fly_by ps_sur_phantom_01/run_03)
			;		(cs_vehicle_boost FALSE)
			;		(cs_vehicle_speed 0.5)
			;		(cs_fly_to_and_face ps_sur_phantom_01/hover_02 ps_sur_phantom_01/face_02 1)		
			;		(wake phantom_01_blip)
			;	)
			;)				
			;
			;(unit_open v_sur_phantom_01)
			;(cs_fly_to_and_face ps_sur_phantom_01/drop_02a ps_sur_phantom_01/face_02 1)
			;(vehicle_unload v_sur_phantom_01 "phantom_p_lf")
			;(sleep 15)
			;(vehicle_unload v_sur_phantom_01 "phantom_p_lb")
			;(sleep_until 
			;	(and
			;		(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lf") 0)
			;		(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_lb") 0)
			;	)
			;10)
			;(sleep 15)
			;
			;(cs_fly_to_and_face ps_sur_phantom_01/drop_02b ps_sur_phantom_01/face_02 1)
			;(vehicle_unload v_sur_phantom_01 "phantom_p_ml_f")
			;(sleep 15)
			;(vehicle_unload v_sur_phantom_01 "phantom_p_ml_b")
			;(sleep_until 
			;	(and
			;		(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_ml_f") 0)
			;		(= (vehicle_test_seat v_sur_phantom_01 "phantom_p_ml_b") 0)
			;	)
			;10)
			; ======== /OLD DROPOFF
			
		; ======== /DROPOFF ======================
		(sleep 15)	
	(unit_close v_sur_phantom_01)
		(cs_vehicle_speed 1.0)
	(cs_fly_by ps_sur_phantom_01/run_04)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_01/run_01)
	(cs_fly_by ps_sur_phantom_01/erase 10)
	(cs_vehicle_boost FALSE)
	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_01_blip
	(sleep_forever)
	(print "blipping phantom_01...")
	(f_survival_callout_dropship v_sur_phantom_01)
)


;=============================== phantom_02 ===============================================================================================================

(script command_script cs_sur_phantom_02
	(set v_sur_phantom_02 (ai_vehicle_get_from_starting_location sq_sur_phantom_02/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_02 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(object_set_shadowless sq_sur_phantom_02/phantom TRUE)
	
			; ======== LOAD GHOST ==================
			(if	(survival_mode_scenario_extras_enable)
				(if 	
					(and 
						(= (random_range 0 2) 0)
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sur_ghost_02/driver)) 0)
					)
					(f_load_phantom_cargo
										v_sur_phantom_02
										"single"
										sq_sur_ghost_02
										none
					)
				)
			)
			; ======== LOAD GHOST  ==================
	
	(cs_vehicle_boost TRUE)			
	(cs_fly_by ps_sur_phantom_02/run_01)
	(cs_fly_by ps_sur_phantom_02/run_01a)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_sur_phantom_02/run_02)	
	
	(cs_vehicle_speed 0.7)
	
			; drop ghost
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_lc") 1)
				(begin
					(cs_fly_by ps_sur_phantom_02/run_03)
					(cs_fly_to_and_face ps_sur_phantom_02/hover_01 ps_sur_phantom_02/face_01 1)
					(cs_vehicle_speed 0.5)
					(wake phantom_02_blip)
					(cs_fly_to_and_face ps_sur_phantom_02/drop_01 ps_sur_phantom_02/face_01 1)					
					(vehicle_unload v_sur_phantom_02 "phantom_lc")
				)	
				(begin
					(cs_fly_by ps_sur_phantom_02/run_04)
					(cs_fly_to_and_face ps_sur_phantom_02/hover_02 ps_sur_phantom_02/face_02 1)		
					(cs_vehicle_speed 0.5)
					(wake phantom_02_blip)
				)
			)

		; ======== DROPOFF ======================
			
			(unit_open v_sur_phantom_02)
			
			;========== POINT 1 ==============
			(cs_vehicle_speed 0.25)
			(cs_fly_to_and_face ps_sur_phantom_02/drop_02a ps_sur_phantom_02/face_02 1)
			(if
				(or
					(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rf") 1)
					(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rb") 1)
				)
				(begin
					(vehicle_unload v_sur_phantom_02 "phantom_p_rf")
					(sleep 15)
					(vehicle_unload v_sur_phantom_02 "phantom_p_rb")
					(sleep_until 
						(and
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rf") 0)
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_rb") 0)
						)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			
			;========== POINT 2 ==============
			(cs_fly_to_and_face ps_sur_phantom_02/drop_02c ps_sur_phantom_02/face_02 1)
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_mr_b") 1)
				(begin
					(vehicle_unload v_sur_phantom_02 "phantom_p_mr_b")
					(sleep_until 
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_mr_b") 0)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			;========== POINT 3 ===============
			(cs_fly_to_and_face ps_sur_phantom_02/drop_02b ps_sur_phantom_02/face_02 1)
			(if
				(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_mr_f") 1)
				(begin
					(vehicle_unload v_sur_phantom_02 "phantom_p_mr_f")
					(sleep_until 
							(= (vehicle_test_seat v_sur_phantom_02 "phantom_p_mr_f") 0)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			
		; ======== /DROPOFF ======================

		(sleep 15)	
	(unit_close v_sur_phantom_02)
		(cs_vehicle_speed 0.5)
	(cs_fly_by ps_sur_phantom_02/run_05)
		(cs_vehicle_speed 0.75)		
	(cs_fly_by ps_sur_phantom_02/run_06)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_sur_phantom_02/run_02)
	(cs_fly_by ps_sur_phantom_02/run_01)
	(cs_fly_by ps_sur_phantom_02/erase 10)
	(cs_vehicle_boost FALSE)
	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_02_blip
	(sleep_forever)
	(print "blipping phantom_02...")
	(f_survival_callout_dropship v_sur_phantom_02)
)


;=============================== phantom_03 ===============================================================================================================

(script command_script cs_sur_phantom_03
	(set v_sur_phantom_03 (ai_vehicle_get_from_starting_location sq_sur_phantom_03/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_03 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)		
	
	(cs_vehicle_boost TRUE)	
	(cs_fly_by ps_sur_phantom_03/run_01)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_sur_phantom_03/run_01a)

	; ============== DROPOFF ===========
	(cs_vehicle_speed 0.7)
	(cs_fly_to_and_face ps_sur_phantom_03/hover_01 ps_sur_phantom_03/face_01 1)
		(unit_open v_sur_phantom_03)
		(sleep 15)
		(cs_vehicle_speed 0.5)
		
		; ============== POINT 1 ===========
		
		(cs_fly_to_and_face ps_sur_phantom_03/drop_01 ps_sur_phantom_03/face_01 1)		
			(wake phantom_03_blip)
		
		(if	
			(or
				(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lf") 1)
				(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lb") 1)
			)
			(begin	
				(vehicle_unload v_sur_phantom_03 "phantom_p_lf")
				(sleep 15)
				(vehicle_unload v_sur_phantom_03 "phantom_p_lb")
				(sleep_until 
					(and
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lf") 0)
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_lb") 0)
					)
				10)
				(sleep 15)
			)
			(begin
				(sleep 15)
			)
		)
		
		;========== POINT 2 ===============			
		(cs_fly_by ps_sur_phantom_03/run_02)
		(cs_fly_to_and_face ps_sur_phantom_03/hover_02 ps_sur_phantom_03/face_02 1)
		(sleep 15)			
		(cs_fly_to_and_face ps_sur_phantom_03/drop_02 ps_sur_phantom_03/face_02 1)
		(sleep 15)
		(if
			(or
				(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_ml_f") 1)
				(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_ml_b") 1)
			)
			(begin
				(vehicle_unload v_sur_phantom_03 "phantom_p_ml_f")
				(sleep 15)
				(vehicle_unload v_sur_phantom_03 "phantom_p_ml_b")
				(sleep_until 
					(and
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_ml_f") 0)
						(= (vehicle_test_seat v_sur_phantom_03 "phantom_p_ml_b") 0)
					)
				10)
				(sleep 15)
			)
			(begin
				(sleep 15)
			)
		)
	; ========= /DROPOFF =============================
	
		(sleep 15)
	(cs_fly_to_and_face ps_sur_phantom_03/hover_02 ps_sur_phantom_03/face_02 1)		
	(unit_close v_sur_phantom_03)
	(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_phantom_03/run_03)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_sur_phantom_03/run_03a)
	(cs_vehicle_boost TRUE)	
	(cs_fly_by ps_sur_phantom_03/run_04)
;	(cs_fly_by ps_sur_phantom_03/run_05)
	(cs_fly_by ps_sur_phantom_03/run_01)
	(cs_fly_by ps_sur_phantom_03/erase 10)
	(cs_vehicle_boost FALSE)
	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_03_blip
	(sleep_forever)
	(print "blipping phantom_03...")
	(f_survival_callout_dropship v_sur_phantom_03)
)

;=============================== phantom_04 ===============================================================================================================

(script command_script cs_sur_phantom_04
	(set v_sur_phantom_04 (ai_vehicle_get_from_starting_location sq_sur_phantom_04/phantom))
		(sleep 1)
	(object_cannot_die v_sur_phantom_04 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)		
	
	(cs_fly_to_and_face ps_sur_phantom_04/run_00 ps_sur_phantom_04/face_01 5)
	(cs_vehicle_boost TRUE)	
	(cs_fly_by ps_sur_phantom_04/run_01)
	(cs_fly_by ps_sur_phantom_04/run_02)
	(cs_vehicle_boost FALSE)
	
	(cs_fly_to_and_face ps_sur_phantom_04/hover_00 ps_sur_phantom_04/face_01 1)
		(sleep 60)
		(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_sur_phantom_04/hover_01 ps_sur_phantom_04/face_01 1)
		(unit_open v_sur_phantom_04)
		(sleep 15)
		(cs_vehicle_speed 0.5)
		
	; =========== DROPOFF ================
	(cs_fly_to_and_face ps_sur_phantom_04/drop_01 ps_sur_phantom_04/face_01 1)		
		(wake phantom_04_blip)

			; ========= POINT 1 =============================
			
			(if
				(or
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 1)
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 1)
				)
				(begin
					(vehicle_unload v_sur_phantom_04 "phantom_p_rf")
					(sleep 15)
					(vehicle_unload v_sur_phantom_04 "phantom_p_rb")
					(sleep_until 
						(and
							(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rf") 0)
							(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_rb") 0)
						)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)
			(cs_vehicle_speed 0.7)
			
			; ========= POINT 2 ==============================
			(cs_fly_to_and_face ps_sur_phantom_04/hover_02 ps_sur_phantom_04/face_03 1)
			(cs_fly_to_and_face ps_sur_phantom_04/hover_03 ps_sur_phantom_04/face_03 1)
				(sleep 15)
				(cs_vehicle_speed 0.25)
			(cs_fly_to_and_face ps_sur_phantom_04/drop_02 ps_sur_phantom_04/face_03 1)
			(sleep 15)
				(cs_vehicle_speed 1.0)
				
			(if
				(or
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_mr_f") 1)
					(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_mr_b") 1)
				)
				(begin
					(vehicle_unload v_sur_phantom_04 "phantom_p_mr_f")
					(sleep 15)
					(vehicle_unload v_sur_phantom_04 "phantom_p_mr_b")
					(sleep_until 
						(and
							(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_mr_f") 0)
							(= (vehicle_test_seat v_sur_phantom_04 "phantom_p_mr_b") 0)
						)
					10)
					(sleep 15)
				)
				(begin
					(sleep 15)
				)
			)

	; ========= /DROPOFF =============================
	
		(sleep 15)
	(unit_close v_sur_phantom_04)
	(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_phantom_04/run_03)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_sur_phantom_04/run_03a)		
	(cs_vehicle_boost TRUE)
;	(cs_fly_by ps_sur_phantom_04/run_04)
;	(cs_fly_by ps_sur_phantom_04/run_05)	
;	(cs_fly_by ps_sur_phantom_04/run_06)
;	(cs_vehicle_boost TRUE)
;	(cs_fly_by ps_sur_phantom_04/run_01)
	(cs_fly_by ps_sur_phantom_04/run_00)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_sur_phantom_04/erase 1)

	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_04_blip
	(sleep_forever)
	(print "blipping phantom_04...")
	(f_survival_callout_dropship v_sur_phantom_04)
)

;=============================== phantom_bonus ===============================================================================================================

(global boolean b_load_in_phantom FALSE)

(script command_script cs_sur_bonus_phantom
	(set v_sur_bonus_phantom (ai_vehicle_get_from_spawn_point sq_sur_bonus_phantom/phantom))
	(set b_load_in_phantom TRUE)
		(sleep 1)
	(object_cannot_die v_sur_bonus_phantom TRUE)
	(object_set_shadowless v_sur_bonus_phantom TRUE)
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_fly_by ps_sur_bonus_phantom/run_01)
	(cs_fly_by ps_sur_bonus_phantom/run_02)
	(cs_fly_by ps_sur_bonus_phantom/run_03)
	(cs_vehicle_speed 0.35)
	(cs_fly_to_and_face ps_sur_bonus_phantom/drop ps_sur_bonus_phantom/face 1)
		(sleep 15)
		(unit_open v_sur_bonus_phantom)
		(wake phantom_bonus_blip)

		; ======== DROPOFF ======================
			
			(set b_sur_bonus_phantom_ready TRUE)

		; ======== DROPOFF ======================
		; sleep until BONUS ROUND is over 
		(sleep_until b_sur_bonus_end)
			(sleep 45)
		
	; fly away 
		(sleep 15)
		(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_bonus_phantom/run_03)
		(cs_vehicle_speed 1.00)
	(cs_fly_by ps_sur_bonus_phantom/run_02)
	(cs_fly_by ps_sur_bonus_phantom/run_01)
	(cs_fly_by ps_sur_bonus_phantom/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

(script continuous phantom_bonus_blip
	(sleep_forever)
	(print "blipping bonus phantom...")
	(f_survival_callout_dropship v_sur_bonus_phantom)
)

; ==============================================================================================================
; ====== JACKAL SNIPER SCIRPTS =================================================================================
; ==============================================================================================================

(global boolean g_sur_sniper_spawn TRUE)
(global short g_sur_sniper_limit 0)
(global short g_sur_sniper_count 0)

(script dormant survival_jackal_spawn
	; set the max number of snipers at any one time 
	(cond
		((<= (game_coop_player_count) 3)	(set g_sur_sniper_limit 1))
		((> (game_coop_player_count) 3)		(set g_sur_sniper_limit 2))
	)
	(sleep (* 30 60 1))

	; stays in this loop forever 
	(sleep_until
		(begin
			(sleep (* 30 180 1))
							
			(begin_random
				(if g_sur_sniper_spawn (ai_sur_sniper_spawn sq_sur_sniper_01))
				(if g_sur_sniper_spawn (ai_sur_sniper_spawn sq_sur_sniper_02))
				(if g_sur_sniper_spawn (ai_sur_sniper_spawn sq_sur_sniper_03))
				(if g_sur_sniper_spawn (ai_sur_sniper_spawn sq_sur_sniper_04))
			)
			
			(sleep 1)
			(sleep_until (< (ai_living_count gr_survival_snipers) g_sur_sniper_limit))
			(sleep 1)
			(set g_sur_sniper_count (ai_living_count gr_survival_snipers))
			(set g_sur_sniper_spawn TRUE)
			
		FALSE)
	)
)

(script static void (ai_sur_sniper_spawn (ai spawned_squad))
	(ai_place spawned_squad)
	(set g_sur_sniper_count (+ g_sur_sniper_count 1))
	(if (>= g_sur_sniper_count g_sur_sniper_limit) (set g_sur_sniper_spawn FALSE))
)




;================================================ WEAPON DROP CONTROL ============================================================

(global short g_sur_resupply_limit 0)

;checking if the weapon is in the supply pod still
(script static boolean (resupply_pod_test_weapon (object pod))
	(or
		(!= (object_at_marker pod "gun_high") NONE)
		(!= (object_at_marker pod "gun_mid") NONE)
		(!= (object_at_marker pod "gun_lower") NONE)
	)	
)


;main resupply thread
(script dormant survival_resupply_pod_spawn
	; set the max number of resupply pods at any one time 
	(cond
		((<= (game_coop_player_count) 2)		(set g_sur_resupply_limit 1))
		((= (game_coop_player_count) 3)		(set g_sur_resupply_limit 1))
		((= (game_coop_player_count) 4)		(set g_sur_resupply_limit 2))
		((>= (game_coop_player_count) 5)		(set g_sur_resupply_limit 2))
	)

	(sleep 1)
	
	; stays in this loop forever 
	(sleep_until
		(begin
			(sleep_until (survival_mode_should_drop_weapon) 5)
			
			(sleep 1)
			
			(print "cleaning up old resupply pods...")
			(sleep 1)
			(object_destroy sc_resupply_01)
			(object_destroy sc_resupply_02)
			(object_destroy sc_resupply_03)
			(object_destroy sc_resupply_04)
			(object_destroy sc_resupply_05)
			(object_destroy sc_resupply_06)
			(object_destroy sc_resupply_07)
			(object_destroy sc_resupply_08)
			(object_destroy sc_resupply_09)
			(object_destroy sc_target_01)
			(object_destroy sc_target_02)
			(object_destroy sc_target_03)
			
			(sleep 1)
			(print "bringing in longsword...")
			(object_create dm_longsword_01)
			(print "spawning in grenades...")
			(object_create_folder_anew cr_grenades)
			(sleep 1)
			(device_set_position_track dm_longsword_01 "ff10" 0)
			(device_animate_position dm_longsword_01 1 10.0 3 3 FALSE)
			(sleep_until (>= (device_get_position dm_longsword_01) 0.4) 1)
			(print "dropping off weapons...")
			(begin_random_count 1
				(wake resupply_target_01)
				(wake resupply_target_02)
				(wake resupply_target_03)
			)
			(begin_random_count g_sur_resupply_limit
				(wake resupply_pod_01)
				(wake resupply_pod_02)
				(wake resupply_pod_03)
				(wake resupply_pod_04)
				(wake resupply_pod_05)
				(wake resupply_pod_06)
				(wake resupply_pod_07)
				(wake resupply_pod_08)
				(wake resupply_pod_09)
			)
			
			(sleep 120)
			(object_destroy dm_longsword_01)
			
		FALSE)
	)
)

;=============== Target 01 =======================================
(script continuous resupply_target_01
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "target 01...")
	(object_create dm_target_01)
	(begin
		(if (= (airstrike_weapons_exist) FALSE)
			(begin
				(airstrike_set_launches 2)
				(sleep 1)
				(object_create_variant sc_target_01 "target_laser")
			)
			(begin
				(airstrike_set_launches 2)
				(submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
				(sleep 1)
				(begin_random_count 1
					(object_create_variant sc_target_01 "laser")
					(object_create_variant sc_target_01 "rocket")
					(object_create_variant sc_target_01 "sniper")
				)
			)
		)
	)
	(sleep 1)
	(objects_attach dm_target_01 "" sc_target_01 "")
	(sleep 1)
	(device_set_position dm_target_01 1)
	(sleep_until (>= (device_get_position dm_target_01) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_target_01 "fx_impact")
	(sleep_until (>= (device_get_position dm_target_01) 1) 1)
	(sleep 1)
	(objects_detach dm_target_01 sc_target_01)
	(object_destroy dm_target_01)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_target_01 "panel" 100)
	(wake target_waypoint_01)
)

(script continuous target_waypoint_01
	(sleep_forever)
	(print "placing waypoint on target 01...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_target_01 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_target_01)) 5)
	(f_unblip_object sc_target_01)
)


;=============== Target 02 =======================================
(script continuous resupply_target_02
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "target 02...")
	(object_create dm_target_02)
	(begin
		(if (= (airstrike_weapons_exist) FALSE)
			(begin
				(airstrike_set_launches 2)
				(sleep 1)
				(object_create_variant sc_target_02 "target_laser")
			)
			
			(begin
				(airstrike_set_launches 2)
				(submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
				(sleep 1)
				(begin_random_count 1
					(object_create_variant sc_target_02 "laser")
					(object_create_variant sc_target_02 "rocket")
					(object_create_variant sc_target_02 "sniper")
				)
			)
		)
	)
	(sleep 1)
	(objects_attach dm_target_02 "" sc_target_02 "")
	(sleep 1)
	(device_set_position dm_target_02 1)
	(sleep_until (>= (device_get_position dm_target_02) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_target_02 "fx_impact")
	(sleep_until (>= (device_get_position dm_target_02) 1) 1)
	(sleep 1)
	(objects_detach dm_target_02 sc_target_02)
	(object_destroy dm_target_02)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_target_02 "panel" 100)
	(wake target_waypoint_02)
)

(script continuous target_waypoint_02
	(sleep_forever)
	(print "placing waypoint on target 02...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_target_02 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_target_02)) 5)
	(f_unblip_object sc_target_02)
)


;=============== Target 03 =======================================
(script continuous resupply_target_03
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "target 03...")
	(object_create dm_target_03)
	(begin
		(if (= (airstrike_weapons_exist) FALSE)
			(begin
				(airstrike_set_launches 2)
				(sleep 1)
				(object_create_variant sc_target_03 "target_laser")
			)
		
			(begin
				(airstrike_set_launches 2)
				(submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
				(sleep 1)
				(begin_random_count 1
					(object_create_variant sc_target_03 "laser")
					(object_create_variant sc_target_03 "rocket")
					(object_create_variant sc_target_03 "sniper")
				)
			)
		)
	)
	(sleep 1)
	(objects_attach dm_target_03 "" sc_target_03 "")
	(sleep 1)
	(device_set_position dm_target_03 1)
	(sleep_until (>= (device_get_position dm_target_03) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\water\pod_impact_water_small.effect sc_target_03 "fx_impact")
	(sleep_until (>= (device_get_position dm_target_03) 1) 1)
	(sleep 1)
	(objects_detach dm_target_03 sc_target_03)
	(object_destroy dm_target_03)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_target_03 "panel" 100)
	(wake target_waypoint_03)
)

(script continuous target_waypoint_03
	(sleep_forever)
	(print "placing waypoint on target 03...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_target_03 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_target_03)) 5)
	(f_unblip_object sc_target_03)
)

;=============== Resupply 01 =======================================
(script continuous resupply_pod_01
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 01...")
	(object_create dm_resupply_01)
	(begin_random_count 1
		(object_create_variant sc_resupply_01 "laser")
		(object_create_variant sc_resupply_01 "rocket")
		(object_create_variant sc_resupply_01 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_01 "" sc_resupply_01 "")
	(sleep 1)
	(device_set_position dm_resupply_01 1)
	(sleep_until (>= (device_get_position dm_resupply_01) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_01 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_01) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_01 sc_resupply_01)
	(object_destroy dm_resupply_01)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_01 "panel" 100)
	(wake resupply_waypoint_01)
)

(script continuous resupply_waypoint_01
	(sleep_forever)
	(print "placing waypoint on resupply 01...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_01 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_01)) 5)
	(f_unblip_object sc_resupply_01)
)
					
										
;=============== Resupply 02 =======================================
(script continuous resupply_pod_02
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 02...")
	(object_create dm_resupply_02)
	(begin_random_count 1
		(object_create_variant sc_resupply_02 "laser")
		(object_create_variant sc_resupply_02 "rocket")
		(object_create_variant sc_resupply_02 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_02 "" sc_resupply_02 "")
	(sleep 1)
	(device_set_position dm_resupply_02 1)
	(sleep_until (>= (device_get_position dm_resupply_02) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_02 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_02) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_02 sc_resupply_02)
	(object_destroy dm_resupply_02)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_02 "panel" 100)
	(wake resupply_waypoint_02)
)

(script continuous resupply_waypoint_02
	(sleep_forever)
	(print "placing waypoint on resupply 02...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_02 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_02)) 5)
	(f_unblip_object sc_resupply_02)
)

;=============== Resupply 03 =======================================
(script continuous resupply_pod_03
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 03...")
	(object_create dm_resupply_03)
	(begin_random_count 1
		(object_create_variant sc_resupply_03 "laser")
		(object_create_variant sc_resupply_03 "rocket")
		(object_create_variant sc_resupply_03 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_03 "" sc_resupply_03 "")
	(sleep 1)
	(device_set_position dm_resupply_03 1)
	(sleep_until (>= (device_get_position dm_resupply_03) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_03 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_03) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_03 sc_resupply_03)
	(object_destroy dm_resupply_03)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_03 "panel" 100)
	(wake resupply_waypoint_03)
)

(script continuous resupply_waypoint_03
	(sleep_forever)
	(print "placing waypoint on resupply 03...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_03 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_03)) 5)
	(f_unblip_object sc_resupply_03)
)

;=============== Resupply 04 =======================================
(script continuous resupply_pod_04
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 04...")
	(object_create dm_resupply_04)
	(begin_random_count 1
		(object_create_variant sc_resupply_04 "laser")
		(object_create_variant sc_resupply_04 "rocket")
		(object_create_variant sc_resupply_04 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_04 "" sc_resupply_04 "")
	(sleep 1)
	(device_set_position dm_resupply_04 1)
	(sleep_until (>= (device_get_position dm_resupply_04) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_04 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_04) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_04 sc_resupply_04)
	(object_destroy dm_resupply_04)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_04 "panel" 100)
	(wake resupply_waypoint_04)
)

(script continuous resupply_waypoint_04
	(sleep_forever)
	(print "placing waypoint on resupply 04...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_04 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_04)) 5)
	(f_unblip_object sc_resupply_04)
)


;=============== Resupply 05 =======================================
(script continuous resupply_pod_05
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 05...")
	(object_create dm_resupply_05)
	(begin_random_count 1
		(object_create_variant sc_resupply_05 "laser")
		(object_create_variant sc_resupply_05 "rocket")
		(object_create_variant sc_resupply_05 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_05 "" sc_resupply_05 "")
	(sleep 1)
	(device_set_position dm_resupply_05 1)
	(sleep_until (>= (device_get_position dm_resupply_05) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_05 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_05) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_05 sc_resupply_05)
	(object_destroy dm_resupply_05)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_05 "panel" 100)
	(wake resupply_waypoint_05)
)

(script continuous resupply_waypoint_05
	(sleep_forever)
	(print "placing waypoint on resupply 05...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_05 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_05)) 5)
	(f_unblip_object sc_resupply_05)
)


;=============== Resupply 06 =======================================
(script continuous resupply_pod_06
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 06...")
	(object_create dm_resupply_06)
	(begin_random_count 1
		(object_create_variant sc_resupply_06 "laser")
		(object_create_variant sc_resupply_06 "rocket")
		(object_create_variant sc_resupply_06 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_06 "" sc_resupply_06 "")
	(sleep 1)
	(device_set_position dm_resupply_06 1)
	(sleep_until (>= (device_get_position dm_resupply_06) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_06 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_06) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_06 sc_resupply_06)
	(object_destroy dm_resupply_06)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_06 "panel" 100)
	(wake resupply_waypoint_06)
)

(script continuous resupply_waypoint_06
	(sleep_forever)
	(print "placing waypoint on resupply 06...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_06 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_06)) 5)
	(f_unblip_object sc_resupply_06)
)


;=============== Resupply 07 =======================================
(script continuous resupply_pod_07
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 07...")
	(object_create dm_resupply_07)
	(begin_random_count 1
		(object_create_variant sc_resupply_07 "laser")
		(object_create_variant sc_resupply_07 "rocket")
		(object_create_variant sc_resupply_07 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_07 "" sc_resupply_07 "")
	(sleep 1)
	(device_set_position dm_resupply_07 1)
	(sleep_until (>= (device_get_position dm_resupply_07) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_07 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_07) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_07 sc_resupply_07)
	(object_destroy dm_resupply_07)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_07 "panel" 100)
	(wake resupply_waypoint_07)
)

(script continuous resupply_waypoint_07
	(sleep_forever)
	(print "placing waypoint on resupply 07...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_07 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_07)) 5)
	(f_unblip_object sc_resupply_07)
)


;=============== Resupply 08 =======================================
(script continuous resupply_pod_08
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 08...")
	(object_create dm_resupply_08)
	(begin_random_count 1
		(object_create_variant sc_resupply_08 "laser")
		(object_create_variant sc_resupply_08 "rocket")
		(object_create_variant sc_resupply_08 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_08 "" sc_resupply_08 "")
	(sleep 1)
	(device_set_position dm_resupply_08 1)
	(sleep_until (>= (device_get_position dm_resupply_08) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_resupply_08 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_08) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_08 sc_resupply_08)
	(object_destroy dm_resupply_08)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_08 "panel" 100)
	(wake resupply_waypoint_08)
)

(script continuous resupply_waypoint_08
	(sleep_forever)
	(print "placing waypoint on resupply 08...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_08 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_08)) 5)
	(f_unblip_object sc_resupply_08)
)


;=============== Resupply 09 =======================================
(script continuous resupply_pod_09
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "resupply pod 09...")
	(object_create dm_resupply_09)
	(begin_random_count 1
		(object_create_variant sc_resupply_09 "laser")
		(object_create_variant sc_resupply_09 "rocket")
		(object_create_variant sc_resupply_09 "sniper")
	)
	(sleep 1)
	(objects_attach dm_resupply_09 "" sc_resupply_09 "")
	(sleep 1)
	(device_set_position dm_resupply_09 1)
	(sleep_until (>= (device_get_position dm_resupply_09) 0.98) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\water\pod_impact_water_small.effect sc_resupply_09 "fx_impact")
	(sleep_until (>= (device_get_position dm_resupply_09) 1) 1)
	(sleep 1)
	(objects_detach dm_resupply_09 sc_resupply_09)
	(object_destroy dm_resupply_09)
	(sleep (random_range 8 17))
	(object_damage_damage_section sc_resupply_09 "panel" 100)
	(wake resupply_waypoint_09)
)

(script continuous resupply_waypoint_09
	(sleep_forever)
	(print "placing waypoint on resupply 09...")
	(sound_impulse_start sfx_blip NONE 1)
	(f_blip_object sc_resupply_09 blip_ordnance)
	(sleep_until (not (resupply_pod_test_weapon sc_resupply_09)) 5)
	(f_unblip_object sc_resupply_09)
)



;============================================= RECYCLE ====================================================================

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