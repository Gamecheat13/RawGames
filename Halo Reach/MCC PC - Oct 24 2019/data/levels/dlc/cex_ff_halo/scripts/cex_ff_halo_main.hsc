; =======================================================================================================
; ====== HALO FIREFIGHT SCRIPTS =========================================================================
; =======================================================================================================

(global short s_round -1)
(global boolean g_timer_var FALSE)
(global boolean b_sur_resupply_waypoint_01 FALSE)
(global boolean b_sur_resupply_waypoint_02 FALSE)
(global boolean b_sur_resupply_waypoint_03 FALSE)
(global boolean b_sur_resupply_waypoint_04 FALSE)
(global boolean b_sur_resupply_waypoint_05 FALSE)

; global vehicles 
(global vehicle v_sur_drop_01 NONE)
(global vehicle v_sur_drop_02 NONE)
(global vehicle v_sur_drop_03 NONE)
(global vehicle v_sur_drop_04 NONE)
(global vehicle v_sur_pelican NONE)

(script startup cex_ff_halo	
	
		; set allegiances 
		(ai_allegiance human player)
		(ai_allegiance player human)
	
		; Snap to black 
		(if (> (player_count) 0) (cinematic_snap_to_black))
		(sleep 5)
		
		; switch to the proper zone set 
		(switch_zone_set set_firefight)
		
		; sets kill trigger
;		(tv_kbtg_kill)
		
	; FIRETEAM SETUP 
	(set ai_sur_fireteam_squad0 sq_elite_fireteam_01)
	(set ai_sur_fireteam_squad1 sq_elite_fireteam_02)
	(set ai_sur_fireteam_squad2 sq_elite_fireteam_03)
	(set ai_sur_fireteam_squad3 sq_elite_fireteam_04)
	(set ai_sur_fireteam_squad4 sq_elite_fireteam_05)
	(set ai_sur_fireteam_squad5 sq_elite_fireteam_06)
	
	
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
			(set ai_sur_bonus_phantom sq_ff_bonus)
	
		; set phantom load parameters 
			(set s_sur_dropship_type 2)	; Use Spirits instead of Phantoms
			(set s_sur_drop_side_01 "dual")
			(set s_sur_drop_side_02 "dual")
			(set s_sur_drop_side_03 "dual")
			(set s_sur_drop_side_04 "dual")
			(set s_sur_drop_side_bonus "dual")
			
		; set wave timer 
			(set k_sur_wave_timer 0)
		
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
		
		;(set b_sur_bonus_phantom TRUE)
		;(set b_sur_bonus_ground FALSE)
		
		;BONUS SQUAD SETUP
		(set ai_sur_bonus_wave sq_ff_bonus)
		;BONUS PHANTOM SETUP
		(set ai_sur_bonus_phantom sq_sur_bonus_phantom)
	

	;============ begin survival mode ==============================

	; wake the survival mode global scirpt
	(if (survival_mode_scenario_extras_enable)
		(begin
			(wake survival_drop_spawn)
		)
	)
	
	(wake survival_banshee_spawn)
	(wake survival_mode)
	(wake survival_resupply_pod_spawn)
	
	;============= Spawn in Marines =================================
	
	(if (survival_mode_scenario_extras_enable)
		(begin
			(ai_place sq_marines_01)
			(ai_place sq_marines_02)
			(ai_place sq_gs343)
		)
	)
	
	(ai_vehicle_reserve_seat warthog01 "warthog_d" TRUE)
	
	(sleep 5)	
)

;=============== erase ai and kill scripts =======================

(script static void halo_kill
	(ai_erase_all)
	(kill_active_scripts)
)

;=============== killed by the guardians script =======================
;*
(script static void tv_kbtg_kill
	; stays in this loop forever 
		(sleep_until
			(begin
				(volume_return_objects tv_kbtg)
				(if (volume_test_object tv_kbtg player0)
					(print "Player0 is in the tv_kbtg trigger")
				)
				(if (volume_test_object tv_kbtg player1)
					(print "Player0 is in the tv_kbtg trigger")
				)
				(if (volume_test_object tv_kbtg player2)
					(print "Player0 is in the tv_kbtg trigger")
				)
				(if (volume_test_object tv_kbtg player3)
					(print "Player0 is in the tv_kbtg trigger")
				)
				(sleep 1)
			FALSE)
		)
)
*;
; ==============================================================================================================
; ====== SECONDARY SCRIPTS =====================================================================================
; ==============================================================================================================
(script static void survival_refresh_follow
	(survival_refresh_sleep)
	(ai_reset_objective obj_survival/main_follow)
)

(script static void survival_refresh_additional_follow
	(survival_refresh_sleep)
	(ai_reset_objective obj_survival/additional_follow)
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

(script command_script cs_gen0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_go_to ps_gen/gen0)
)

(script command_script cs_gen1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_go_to ps_gen/gen1)
)

(script command_script cs_gen2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_go_to ps_gen/gen2)
)

;==========================================================================================================
;=============================== Marines===================================================================
(script static void refresh_gate_marines
	(sleep 5)
	(ai_reset_objective obj_marines/gate_marines)
)

(script static void refresh_gate_marines_followers
	(sleep 5)
	(ai_reset_objective obj_marines/gate_marines_followers)
)

(script static void refresh_gate_marines_defenders
	(sleep 5)
	(ai_reset_objective obj_marines/gate_marines_defenders)
)

(script static void refresh_gate_marines_north_overlook
	(sleep 5)
	(ai_reset_objective obj_marines/gate_north_overlook)
)

(script static void refresh_gate_marines_south_overlook
	(sleep 5)
	(ai_reset_objective obj_marines/gate_south_overlook)
)

(script static vehicle players_vehicle
	(if (player_in_vehicle warthog01)
		(vehicle warthog01)
	)
	
	none
)

(script static boolean players_vehicle_has_player
	(not (= (players_vehicle) none))
)

;==========================================================================================================
;=============================== PHANTOM 01 ===============================================================
(global vehicle g_callout_phantom none)

(script command_script cs_sur_phantom_01
	(set v_sur_phantom_01 (ai_vehicle_get_from_starting_location sq_sur_phantom_01/phantom))
		(sleep 1)
	;(object_cannot_die v_sur_phantom_01 FALSE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)

	; ======= PHANTOM ENTERS HERE ===================

	(cs_fly_by ps_sur_phantom_01/run_01)
	(cs_fly_by ps_sur_phantom_01/run_02)	
	(cs_fly_by ps_sur_phantom_01/run_02b)	
	(cs_fly_by ps_sur_phantom_01/run_02c)	
	(cs_fly_by ps_sur_phantom_01/run_03)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_sur_phantom_01/run_04 ps_sur_phantom_01/face_01 1)
	(wake phantom_01_blip)

	; ========= DROPOFF AI HERE =====================	

	(f_unload_fork_cargo v_sur_phantom_01 "large")
	(unit_open v_sur_phantom_01)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_01)
	(sleep 120)
	(unit_close v_sur_phantom_01)

	; ========= PHANTOM LEAVES HERE ================
	
	(sleep 15)
	(cs_vehicle_speed 0.5)	
	(cs_fly_to_and_face ps_sur_phantom_01/run_03 ps_sur_phantom_01/face_02 1)
	(cs_vehicle_speed 1.0)		
	(cs_fly_by ps_sur_phantom_01/run_02c)	
	(cs_fly_by ps_sur_phantom_01/run_02b)
	(cs_fly_by ps_sur_phantom_01/run_02)
	(cs_fly_by ps_sur_phantom_01/run_01)
	(cs_fly_by ps_sur_phantom_01/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

; adding hud marker on the phantom 
(script continuous phantom_01_blip
	(sleep_forever)
	(print "blipping phantom_01...")
	(f_survival_callout_dropship v_sur_phantom_01)

)

;=============================== PHANTOM 02 ===============================================================================================================

(script command_script cs_sur_phantom_02
	(set v_sur_phantom_02 (ai_vehicle_get_from_starting_location sq_sur_phantom_02/phantom))
		(sleep 1)
	;(object_cannot_die v_sur_phantom_02 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	
	; ======= PHANTOM ENTERS HERE ===================
	
	;(cs_fly_by ps_sur_phantom_02/run_01)
	(cs_fly_by ps_sur_phantom_02/run_02)	
	(cs_vehicle_speed 0.5)	
	(cs_fly_to_and_face ps_sur_phantom_02/run_03 ps_sur_phantom_02/face_01 1)
	(wake phantom_02_blip)

	; ========= DROPOFF AI HERE =====================
	
	(f_unload_fork_cargo v_sur_phantom_02 "large")
	(unit_open v_sur_phantom_02)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_02)
	(sleep 120)
	(unit_close v_sur_phantom_02)
	
	; ========= PHANTOM LEAVES HERE ================

	(sleep 15)
	(cs_vehicle_speed 0.5)	
	(cs_fly_to_and_face ps_sur_phantom_02/run_02 ps_sur_phantom_02/face_02 1)
	(cs_vehicle_speed 1.0)	
	;(cs_fly_by ps_sur_phantom_02/run_01)
	(cs_fly_by ps_sur_phantom_02/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

; adding hud marker on the phantom 
(script continuous phantom_02_blip
	(sleep_forever)
	(print "blipping phantom_02...")
	(f_survival_callout_dropship v_sur_phantom_02)

)

;=============================== PHANTOM 03 ===============================================================================================================

(script command_script cs_sur_phantom_03
	(set v_sur_phantom_03 (ai_vehicle_get_from_starting_location sq_sur_phantom_03/phantom))
	(sleep 1)
	;(object_cannot_die v_sur_phantom_03 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	
	; ======= PHANTOM ENTERS HERE ===================
	
	;(cs_fly_by ps_sur_phantom_03/run_01)
	;(cs_fly_by ps_sur_phantom_03/run_02)	
	(cs_fly_by ps_sur_phantom_03/run_03)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_sur_phantom_03/run_04 ps_sur_phantom_03/face_01 1)
	(wake phantom_03_blip)

	; ========= DROPOFF AI HERE =====================
	
	(f_unload_fork_cargo v_sur_phantom_03 "large")
	(unit_open v_sur_phantom_03)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_03)
	(sleep 120)
	(unit_close v_sur_phantom_03)
	
	; ========= PHANTOM LEAVES HERE ================

	(sleep 15)
	(cs_vehicle_speed 0.5)	
	(cs_fly_to_and_face ps_sur_phantom_03/run_03 ps_sur_phantom_03/face_02 1)
	;(cs_fly_by ps_sur_phantom_03/run_02)
	(cs_fly_by ps_sur_phantom_03/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

; adding hud marker on the phantom 
(script continuous phantom_03_blip
	(sleep_forever)
	(print "blipping phantom_03...")
	(f_survival_callout_dropship v_sur_phantom_03)

)

;=============================== PHANTOM 04 ===============================================================================================================

(script command_script cs_sur_phantom_04
	(set v_sur_phantom_04 (ai_vehicle_get_from_starting_location sq_sur_phantom_04/phantom))
	(sleep 1)
	;(object_cannot_die v_sur_phantom_04 TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	
	; ======= PHANTOM ENTERS HERE ===================

	(cs_vehicle_speed 0.75)
	(cs_fly_by ps_sur_phantom_04/run_01)
	(cs_fly_by ps_sur_phantom_04/run_01b)
	(cs_fly_by ps_sur_phantom_04/run_01c)
	(cs_fly_by ps_sur_phantom_04/run_01d)
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_sur_phantom_04/run_02)
	(cs_fly_to_and_face ps_sur_phantom_04/run_03 ps_sur_phantom_04/face_01 1)
	(wake phantom_04_blip)

	; ========= DROPOFF AI HERE =====================	

	(f_unload_fork_cargo v_sur_phantom_04 "large")
	(unit_open v_sur_phantom_04)
	(sleep 30)
	(f_unload_fork_all v_sur_phantom_04)
	(sleep 120)
	(unit_close v_sur_phantom_04)

	; ========= PHANTOM LEAVES HERE ================

	(sleep 15)
	(cs_vehicle_speed 0.5)	
	(cs_fly_to_and_face ps_sur_phantom_04/run_02 ps_sur_phantom_04/face_02 1)
	(cs_vehicle_speed 1.0)	
	(cs_fly_by ps_sur_phantom_04/run_01d)
	(cs_fly_by ps_sur_phantom_04/run_01c)
	(cs_fly_by ps_sur_phantom_04/run_01b)
	(cs_fly_by ps_sur_phantom_04/run_01)
	(cs_fly_by ps_sur_phantom_04/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

; adding hud marker on the phantom 
(script continuous phantom_04_blip
	(sleep_forever)
	(print "blipping phantom_04...")
	(f_survival_callout_dropship v_sur_phantom_04)

)

;=============================== PHANTOM BONUS ===============================================================================================================

(script command_script cs_sur_bonus_phantom
	(set v_sur_bonus_phantom (ai_vehicle_get_from_spawn_point sq_sur_bonus_phantom/phantom))
		(sleep 1)
	(object_cannot_die v_sur_bonus_phantom TRUE)	
	(object_set_shadowless v_sur_bonus_phantom TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)	
	
	(cs_fly_by ps_sur_bonus_phantom/run_02)
	(cs_fly_by ps_sur_bonus_phantom/run_03)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_sur_bonus_phantom/run_04 ps_sur_bonus_phantom/face_01 1)
		(sleep 15)
		(wake phantom_bonus_blip)

		; ======== DROPOFF ======================
			
			(set b_sur_bonus_phantom_ready TRUE)

		; ======== DROPOFF ======================

		; sleep until BONUS ROUND is over 
		(sleep_until b_sur_bonus_end)
			(sleep 45)
		
	; fly away 
		(sleep 15)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_sur_bonus_phantom/run_03 ps_sur_bonus_phantom/face_02 1)	
	(cs_fly_by ps_sur_bonus_phantom/run_02)
	(cs_fly_by ps_sur_bonus_phantom/erase 10)
	; erase squad 
	(ai_erase ai_current_squad)
)

; adding hud marker on the phantom 
(script continuous phantom_bonus_blip
	(sleep_forever)
	(print "blipping bonus phantom...")
	(f_survival_callout_dropship v_sur_bonus_phantom)
)

; ==============================================================================================================
; ====== BANSHEE SCRIPTS =======================================================================================
; ==============================================================================================================
(global boolean b_phantom_01 TRUE)
(global boolean b_phantom_02 TRUE)
(global boolean b_phantom_03 TRUE)
(global boolean b_phantom_04 TRUE)
(global boolean b_banshee_flying TRUE)

(script dormant survival_banshee_spawn
	(wake banshee_emp_kill)
	(sleep_until
		(begin
			(sleep (random_range (* (* 30 60) 2) (* (* 30 60) 3)))
			(if
				(< (ai_living_count gr_survival_banshee) 1)
				(begin
					(sleep_until 
						(and
							(= b_phantom_01 TRUE) 
							(= b_phantom_02 TRUE)
							(= b_phantom_03 TRUE)
							(= b_phantom_04 TRUE)
							(<= (ai_task_count obj_survival/main_wave_gate) 10)
						)	
					5)
					(begin
						(set b_banshee_flying TRUE)
						(sleep 1)
						(begin_random_count 1	
							(ai_place sq_sur_banshee_01)
							(ai_place sq_sur_banshee_02)
							(print "spawning banshees")
						)	
					)		
				)
			)
	FALSE)	
	)
)
(script dormant banshee_emp_kill 
	(sleep_until
		(begin
			(if 
				(unit_is_emp_stunned (ai_vehicle_get_from_starting_location sq_sur_banshee_01/driver))
				(begin
					(units_set_current_vitality (ai_actors sq_sur_banshee_01) .1 0)
					(units_set_maximum_vitality (ai_actors sq_sur_banshee_01) .1 0)
				)	
			)
				
			(if 
				(unit_is_emp_stunned (ai_vehicle_get_from_starting_location sq_sur_banshee_02/driver))
				(begin
					(units_set_current_vitality (ai_actors sq_sur_banshee_02) .1 0)
					(units_set_maximum_vitality (ai_actors sq_sur_banshee_02) .1 0)
				)	
			)
	FALSE)
	1)
)

(script command_script cs_banshee_01
	(if
		(= b_banshee_flying TRUE)
		(begin	
			(cs_enable_targeting TRUE)
			(cs_enable_looking TRUE)
			
				(cs_vehicle_boost TRUE)
			(cs_fly_by ps_banshee_01/run_01)
			(cs_fly_by ps_banshee_01/run_02)
			(cs_fly_by ps_banshee_01/run_03)
			(cs_fly_by ps_banshee_01/run_04)
			(cs_fly_by ps_banshee_01/run_05)
			
				(cs_vehicle_boost FALSE)
				(cs_vehicle_speed 1.0)
				(set b_banshee_flying FALSE)
				(print "Banshee is free")
		)
		(sleep 1)
	)	
)

(script command_script cs_banshee_02
	(if
		(= b_banshee_flying TRUE)
		(begin
			(cs_enable_targeting TRUE)
			(cs_enable_looking TRUE)
			(cs_ignore_obstacles TRUE)
			
				(cs_vehicle_boost TRUE)
			(cs_fly_by ps_banshee_02/run_01)
			(cs_fly_by ps_banshee_02/run_02)
			(cs_fly_by ps_banshee_02/run_03)
			(cs_fly_by ps_banshee_02/run_04)

				
			(cs_ignore_obstacles FALSE)	
				(cs_vehicle_boost FALSE)
				(cs_vehicle_speed 1.0)
				(set b_banshee_flying FALSE)		
				(print "Banshee is free")
		)
		(sleep 1)
	)			   
)

; ==============================================================================================================
; ====== GS343 SCRIPTS =========================================================================================
; ==============================================================================================================

(script command_script cs_gs343_01
	; stays in this loop forever 
	(sleep_until
		(begin
			(cs_pause 30)
			(cs_fly_to ps_guilty_spark_343/run_01)
			(cs_fly_to ps_guilty_spark_343/run_02)
			(cs_fly_to ps_guilty_spark_343/run_03)
			(cs_pause 3)
			(cs_face TRUE ps_guilty_spark_343/face_01)
			(cs_pause 3)
			(cs_face TRUE ps_guilty_spark_343/face_02)
			(cs_pause 3)
			(cs_face TRUE ps_guilty_spark_343/face_03)
			(cs_pause 10)
			(cs_face TRUE ps_guilty_spark_343/face_04)
			(cs_fly_by ps_guilty_spark_343/run_03)
			(cs_fly_by ps_guilty_spark_343/run_02)
			(cs_fly_by ps_guilty_spark_343/run_01)
		FALSE)
	)
)

; ==============================================================================================================
; ====== COVENANT SQUAD DROP CONTROL ===========================================================================
; ==============================================================================================================

(global boolean g_sur_drop_spawn TRUE)
(global short g_sur_drop_limit 0)
(global short g_sur_drop_count 0)
(global short g_sur_drop_number 0)

(script dormant survival_drop_spawn
	; set the max number of drop pods at any one time 
	(cond
		((<= (game_coop_player_count) 4)		(set g_sur_drop_limit 1))
		((>= (game_coop_player_count) 5)		(set g_sur_drop_limit 2))
	)
	(sleep (* (* 30 60) 2))

	; stays in this loop forever 
	(sleep_until
		(begin
			(sleep (random_range (* (* 30 60) 2) (* (* 30 60) 3)))
			(sleep_until 
				(and
					(<= (ai_living_count gr_survival_waves) 10)
					(<= (ai_living_count gr_survival_extras) 0)					
					(= (survival_mode_current_wave_is_boss) FALSE)
					(= (survival_mode_current_wave_is_initial) FALSE)
				)
			)
			
			(print "cleaning up drop pods...")
			(sleep 30)
			(ai_erase sq_sur_drop_01)
			(ai_erase sq_sur_drop_02)
			(ai_erase sq_sur_drop_03)
			(ai_erase sq_sur_drop_04)
				
			(begin_random_count g_sur_drop_limit
				(if g_sur_drop_spawn (wake drop_pod_01))
				(if g_sur_drop_spawn (wake drop_pod_02))
				(if g_sur_drop_spawn (wake drop_pod_03))
				(if g_sur_drop_spawn (wake drop_pod_04))
			)
			(sleep 1)
			(sleep_until 
				(and
					(<= (ai_task_count obj_survival/extras_follow) 0)
					(<= (ai_task_count obj_survival/extras_backup) 0)
				)
			)
			(sleep 1)
			(set g_sur_drop_count 0)
			(set g_sur_drop_spawn TRUE)
			(sleep 1)
		FALSE)
	)
)

;=============== Covenant Squad Drop 01 =======================================
(script continuous drop_pod_01
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "squad pod 01...")
	(object_create dm_drop_01)
	(ai_place sq_sur_drop_01)
	(sleep 1)
	(set v_sur_drop_01 (ai_vehicle_get_from_spawn_point sq_sur_drop_01/driver))
	(sleep 1)
	(objects_attach dm_drop_01 "" v_sur_drop_01 "")
	(sleep 1)
	(device_set_position dm_drop_01 1)
	(sleep_until (>= (device_get_position dm_drop_01) 0.85) 1)
	(wake drop_blip_01)
	(unit_open v_sur_drop_01)
	(sleep 30)
	(print "kicking ai out of pod 01...")
	(vehicle_unload v_sur_drop_01 "")
		(sleep_until (>= (device_get_position dm_drop_01) 0.98) 1)
		(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_large.effect dm_drop_01 "fx_impact")	
	(sleep_until (>= (device_get_position dm_drop_01) 1) 1)
	(sleep 1)
	(objects_detach dm_drop_01 v_sur_drop_01)
	(object_destroy dm_drop_01)
	(sleep 1)
	(set g_sur_drop_count (+ g_sur_drop_count 1))
	(if (>= g_sur_drop_count g_sur_drop_limit) (set g_sur_drop_spawn FALSE))
)

(script continuous drop_blip_01
	(sleep_forever)
	(print "blipping drop pod 01...")
	(f_survival_callout_dropship v_sur_drop_01)
)

;=============== Covenant Squad Drop 02 =======================================
(script continuous drop_pod_02
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "squad pod 02...")
	(object_create dm_drop_02)
	(ai_place sq_sur_drop_02)
	(sleep 1)
	(set v_sur_drop_02 (ai_vehicle_get_from_spawn_point sq_sur_drop_02/driver))
	(sleep 1)
	(objects_attach dm_drop_02 "" v_sur_drop_02 "")
	(sleep 1)
	(device_set_position dm_drop_02 1)
	(sleep_until (>= (device_get_position dm_drop_02) 0.85) 1)
	(wake drop_blip_02)
	(unit_open v_sur_drop_02)
	(sleep 30)
	(print "kicking ai out of pod 02...")
	(vehicle_unload v_sur_drop_02 "")
		(sleep_until (>= (device_get_position dm_drop_02) 0.98) 1)
		(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_large.effect dm_drop_02 "fx_impact")	
	(sleep_until (>= (device_get_position dm_drop_02) 1) 1)
	(sleep 1)
	(objects_detach dm_drop_02 v_sur_drop_02)
	(object_destroy dm_drop_02)
	(sleep 1)
	(set g_sur_drop_count (+ g_sur_drop_count 1))
	(if (>= g_sur_drop_count g_sur_drop_limit) (set g_sur_drop_spawn FALSE))
)

(script continuous drop_blip_02
	(sleep_forever)
	(print "blipping drop pod 02...")
	(f_survival_callout_dropship v_sur_drop_02)
)

;=============== Covenant Squad Drop 03 =======================================
(script continuous drop_pod_03
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "squad pod 03...")
	(object_create dm_drop_03)
	(ai_place sq_sur_drop_03)
	(sleep 1)
	(set v_sur_drop_03 (ai_vehicle_get_from_spawn_point sq_sur_drop_03/driver))
	(sleep 1)
	(objects_attach dm_drop_03 "" v_sur_drop_03 "")
	(sleep 1)
	(device_set_position dm_drop_03 1)
	(sleep_until (>= (device_get_position dm_drop_03) 0.85) 1)
	(wake drop_blip_03)
	(unit_open v_sur_drop_03)
	(sleep 30)
	(print "kicking ai out of pod 03...")
	(vehicle_unload v_sur_drop_03 "")
		(sleep_until (>= (device_get_position dm_drop_03) 0.98) 1)
		(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_large.effect dm_drop_03 "fx_impact")	
	(sleep_until (>= (device_get_position dm_drop_03) 1) 1)
	(sleep 1)
	(objects_detach dm_drop_03 v_sur_drop_03)
	(object_destroy dm_drop_03)
	(sleep 1)
	(set g_sur_drop_count (+ g_sur_drop_count 1))
	(if (>= g_sur_drop_count g_sur_drop_limit) (set g_sur_drop_spawn FALSE))
)

(script continuous drop_blip_03
	(sleep_forever)
	(print "blipping drop pod 03...")
	(f_survival_callout_dropship v_sur_drop_03)
)

;=============== Covenant Squad Drop 04 =======================================
(script continuous drop_pod_04
	(sleep_forever)
	(sleep (random_range 5 15))
	(print "squad pod 04...")
	(object_create dm_drop_04)
	(ai_place sq_sur_drop_04)
	(sleep 1)
	(set v_sur_drop_04 (ai_vehicle_get_from_spawn_point sq_sur_drop_04/driver))
	(sleep 1)
	(objects_attach dm_drop_04 "" v_sur_drop_04 "")
	(sleep 1)
	(device_set_position dm_drop_04 1)
	(sleep_until (>= (device_get_position dm_drop_04) 0.85) 1)
	(wake drop_blip_04)
	(unit_open v_sur_drop_04)
	(sleep 30)
	(print "kicking ai out of pod 04...")
	(vehicle_unload v_sur_drop_04 "")
		(sleep_until (>= (device_get_position dm_drop_04) 0.98) 1)
		(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_large.effect dm_drop_04 "fx_impact")	
	(sleep_until (>= (device_get_position dm_drop_04) 1) 1)
	(sleep 1)
	(objects_detach dm_drop_04 v_sur_drop_04)
	(object_destroy dm_drop_04)
	(sleep 1)
	(set g_sur_drop_count (+ g_sur_drop_count 1))
	(if (>= g_sur_drop_count g_sur_drop_limit) (set g_sur_drop_spawn FALSE))
)

(script continuous drop_blip_04
	(sleep_forever)
	(print "blipping drop pod 04...")
	(f_survival_callout_dropship v_sur_drop_04)
)

;====================================== PELICAN DROP WARTHOG CONTROL ============================================================

(script static void ff_halo_respawn_warthog
	(if (= (vehicle_test_seat warthog01 "") FALSE)
		(begin
			(object_destroy warthog01)
			(ai_place sq_sur_pelican)
		)
	)
)


(script command_script cs_ff_halo_pelican
	
	(set v_sur_pelican (ai_vehicle_get_from_starting_location sq_sur_pelican/driver))
	(sleep 1)
	(print "spawn pelican...")
	(object_cannot_die v_sur_pelican TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
		
	; ======= LOAD PELICAN HERE ===================
	
	(object_create_anew warthog01)
	(ai_place sq_marines_player_followers)
	(unit_enter_vehicle_immediate sq_marines_player_followers warthog01 "warthog_g")
	(vehicle_load_magic
		(ai_vehicle_get ai_current_actor) "pelican_lc"
		warthog01
	)
	
	(print "pelican pathing...")
	(cs_vehicle_boost TRUE)	
	
	(cs_fly_by ps_sur_pelican/run_01)
	(cs_fly_by ps_sur_pelican/run_02)	
	(cs_fly_by ps_sur_pelican/run_03)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_sur_pelican/run_04 ps_sur_pelican/face_01 1)
	(wake pelican_blip)
	(cs_vehicle_speed 1)		
	
	; ========= DROPOFF WARTHOG HERE =====================	

	(print "dropoff pelican...")
	
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(ai_vehicle_reserve_seat warthog01 "warthog_d" TRUE)
	(sleep 100)
	
	; ========= PELICAN LEAVES HERE ================

	(print "pelican leaves...")
	(sleep 15)
	(cs_vehicle_boost TRUE)	
	(cs_fly_by ps_sur_pelican/run_05)
	(cs_vehicle_speed 3)
	;(cs_fly_by ps_sur_pelican/run_06)
	(cs_fly_by ps_sur_pelican/erase 10)
	; erase squad 
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(ai_erase ai_current_squad)
)

; adding hud marker on the pelican
(script continuous pelican_blip
	(sleep_forever)
	(print "blipping pelican_01...")
	(f_blip_object_offset v_sur_pelican blip_default 1)
	(sleep 200)
	(f_unblip_object v_sur_pelican)
	
	; this was using the red hostile dropship blip which is wrong
	; (f_survival_callout_dropship v_sur_pelican)
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
			)
			(if (> (survival_mode_wave_get) 0)
				(ff_halo_respawn_warthog)

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
		(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_small.effect sc_target_03 "fx_impact")	
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
