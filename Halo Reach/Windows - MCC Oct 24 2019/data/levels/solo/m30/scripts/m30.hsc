; =================================================================================================
; GLOBALS
; =================================================================================================

; debug options
(global boolean debug 				true)
(global boolean editor 				false)
(global boolean cinematics 			false)
(global boolean dialogue 			TRUE)
(global boolean skip_intro			false)
(global boolean b_mission_complete 	false)

(global short s_objcon_ovr 	0)
(global short s_objcon_fkv 	0)
(global short s_objcon_slo 	0)
(global short s_objcon_fld 	0)
(global short s_objcon_pmp 	0)
(global short s_objcon_rvr 	0)
(global short s_objcon_set 	0)
(global short s_objcon_clf 	0)

(global boolean b_ovr_started false)
(global boolean b_fkv_started false)
(global boolean b_slo_started false)
(global boolean b_fld_started false)
(global boolean b_pmp_started false)
(global boolean b_rvr_started false)
(global boolean b_set_started false)
(global boolean b_clf_started false)

(global boolean b_ovr_completed false)
(global boolean b_fkv_completed false)
(global boolean b_slo_completed false)
(global boolean b_fld_completed false)
(global boolean b_pmp_completed false)
(global boolean b_rvr_completed false)
(global boolean b_set_completed false)
(global boolean b_clf_completed false)

(global short s_max_living_militia 4)

; Setup
;(global ai jun NONE)


; -------------------------------------------------------------------------------------------------
; RECON STARTUP
; -------------------------------------------------------------------------------------------------
(script startup recon_allegiances
	(ai_allegiance human player)
	(ai_allegiance player human)
)

(script static void ping
	(print "ping!"))

(script startup recon
	(if debug (print "::: M30 - RECON :::"))
	
	(objectives_clear)
	
	(fade_out 0 0 0 0)
	
	; choose the insertion point depending on the mode
	(if (editor_mode)
		(begin
			(if debug (print "editor mode -- snapping fade in..."))
			(fade_in 0 0 0 0)
		)
		
		(start)
	)



; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : START
	; -------------------------------------------------------------------------------------------------
	(sleep_until (>= s_current_insertion_index 0) 1)
	(if (<= s_current_insertion_index 0) (wake ovr_encounter))
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : FIRST KIVA
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_fkv_start)
			(>= s_current_insertion_index s_insertion_index_firstkiva)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_firstkiva) (wake fkv_encounter))

	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : SILO
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_silo_start_a)
			(volume_test_players tv_silo_start_b)
			(volume_test_players tv_silo_start_c)
			(>= s_current_insertion_index s_insertion_index_silo)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_silo) (wake silo_encounter))

	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : FIELDS
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_fields_start)
			(>= s_current_insertion_index s_insertion_index_fields)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_fields) (wake fld_encounter))
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : PUMPSTATION
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_pmp_start)
			(>= s_current_insertion_index s_insertion_index_pumpstation)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_pumpstation) (wake pmp_encounter))
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : RIVER
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_rvr_start)
			(>= s_current_insertion_index s_insertion_index_river)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_river) (wake rvr_encounter))
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : SETTLEMENT
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_set_start)
			(>= s_current_insertion_index s_insertion_index_settlement)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_settlement) (wake set_encounter))	
	
	; -------------------------------------------------------------------------------------------------
	; ENCOUNTER : CLIFFSIDE
	; -------------------------------------------------------------------------------------------------
	(sleep_until	
		(or
			(volume_test_players tv_cliffside_start)
			b_set_completed
			(>= s_current_insertion_index s_insertion_index_cliffside)
		)
	1)
	
	(if (<= s_current_insertion_index s_insertion_index_cliffside) (wake clf_encounter))		
	
	
; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------
; -------------------------------------------------------------------------------------------------

	; mission completed
	(sleep_until (volume_test_players tv_recon_complete) 1)
	(set b_mission_complete true)
	
	; outro cinematic
	;*
	(if (or (not (editor_mode)) cinematics)
		(begin 
			(if debug (print "starting the outro cinematic..."))
			(f_end_mission 030lb_vista cin_end_zone_set "fade_to_black")
		)
	)
	*;
	
	(f_unblip_flag fl_clf_exit)
	
	(if (or (not (editor_mode)) cinematics)
		(begin 
			(if debug (print "starting the outro cinematic..."))
			(zone_set_trigger_volume_enable zone_set:set_cliffside_035_040_045 false)
			(zone_set_trigger_volume_enable begin_zone_set:set_cliffside_035_040_045 false)
			(f_end_mission 030lb_vista set_overlook_040_045_070)
		)
	)
		
	(game_won)
)

(script static void start
	(print "starting from game insertion...")
	
	; Figure out what insertion point to use
	(cond
		((= (game_insertion_point_get) 0) (ins_start))
		((= (game_insertion_point_get) 1) (ins_fields))
		((= (game_insertion_point_get) 2) (ins_settlement))
		;((= (game_insertion_point_get) 3) (ins_set))
		((= (game_insertion_point_get) 5) (fade_in 0 0 0 0))
	)
)


(script startup jun_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count unsc_jun) 0) 1)
			(f_hud_spartan_waypoint unsc_jun jun_name 20)
		)
	)
)

(script startup player_respawn_profile_control
	(sleep_until (> (game_coop_player_count) 0) 1)
	
	(if debug (print "setting up player profiles..."))
	
	(if (game_is_cooperative)
		
		; GAME IS COOP
		; -------------------------------------------------------------------------------------------------
		(begin
			(if (difficulty_is_easy)
				(begin
					(if debug (print "easy coop spawn profile"))
					(force_starting_profile sp_normal_coop_initial)
					(player_set_profile sp_normal_coop_respawn)
				)
			)
				
			(if (difficulty_is_normal)
				(begin
					(if debug (print "normal coop spawn profile"))
					(force_starting_profile sp_normal_coop_initial)
					(player_set_profile sp_normal_coop_respawn)
				)
			)
			
			(if (difficulty_is_heroic)
				(begin
					(if debug (print "heroic coop spawn profile"))
					(force_starting_profile sp_heroic_coop_initial)
					(player_set_profile sp_heroic_coop_respawn)
				)
			)
			
			(if (difficulty_is_legendary)
				(begin
					(if debug (print "legendary coop spawn profile"))
					(force_starting_profile sp_legendary_coop_initial)
					(player_set_profile sp_legendary_coop_respawn)
				)
			)
		)
		
		; GAME IS SINGLEPLAYER
		; -------------------------------------------------------------------------------------------------
		(begin
			(if (difficulty_is_easy)
				(begin
					(if debug (print "easy singleplayer spawn profile"))
					(force_starting_profile sp_normal_initial)
				)
			)
				
			(if (difficulty_is_normal)
				(begin
					(if debug (print "normal singleplayer spawn profile"))
					(force_starting_profile sp_normal_initial)
				)
			)
			
			(if (difficulty_is_heroic)
				(begin
					(if debug (print "heroic singleplayer spawn profile"))
					(force_starting_profile sp_heroic_initial)
				)
			)
			
			(if (difficulty_is_legendary)
				(begin
					(if debug (print "legendary singleplayer spawn profile"))
					(force_starting_profile sp_legendary_initial)
				)
			)
		)
	)
)

(script static void (force_starting_profile (starting_profile sp))
	(unit_add_equipment player0 sp TRUE FALSE)
	(unit_add_equipment player1 sp TRUE FALSE)
	(unit_add_equipment player2 sp TRUE FALSE)
	(unit_add_equipment player3 sp TRUE FALSE)
)

; =================================================================================================
; OVERLOOK
; =================================================================================================
(global boolean b_stealth_training_complete false)
(global boolean b_mule_has_roared false)
; -------------------------------------------------------------------------------------------------
(script dormant ovr_encounter
	(if debug (print "::: insertion encounter start"))
	
	; intro cinematic
	;*
	(if (or (not (editor_mode)) cinematics)
		(begin 
			(if debug (print "starting with intro cinematic..."))
			(f_start_mission 030la_recon  "black")
			(cinematic_exit "fade_from_white" TRUE)
		)
	)
	*;
	
	(if (or (not (editor_mode)) cinematics)
		(begin 
			(if debug (print "starting with intro cinematic..."))
			(f_start_mission 030la_recon)
			(cinematic_exit_into_title 030la_recon TRUE)
		)
	)
	
	; set first mission segment
	(data_mine_set_mission_segment "m30_01_ovr_encounter")
	(garbage_collect_now)
	
	; place ai
	(ai_place sq_cov_ovr_high_grunts0)
	(ai_place sq_cov_ovr_high_elites0)
	(ai_place sq_cov_fkv_ds0)
	(ai_place sq_cov_ovr_low_inf1)
	
	(if 
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		
		(begin
			(ai_place sq_cov_ovr_low_inf2)
		)
	)
	
	(if (= (game_difficulty_get) legendary)
		(ai_place sq_cov_ovr_low_inf0))

	; misc ai setup
	(set ai_to_deafen gr_cov_ovr)
	
	; wake subsequent scripts
	(wake start_banshee_control)
	(wake start_jun_main)
	(wake ovr_elite_shift_control)
	
	(wake save_ovr_defeated)
	
	; misc
	(wake fkv_pose_bodies)
	(wake slo_pose_bodies)
	
	(object_create_folder cr_ovr)
	(object_create_folder dm_ovr)
	
	(object_create_folder cr_fkv)
	(object_create_folder dm_fkv)
	(object_create_folder sc_fkv)
	(object_create_folder wp_fkv)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_ovr_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(game_save)
			(wake chapter_title_start)
			(wake md_start_jun_intro)
			; -------------------------------------------------

	(sleep_until (volume_test_players tv_objcon_ovr_010) 1)
	(if debug (print "::: overlook objective control 010"))
	(set s_objcon_ovr 10)

	(sleep_until (volume_test_players tv_objcon_ovr_020) 1)
	(if debug (print "::: overlook objective control 020"))
	(set s_objcon_ovr 20)
	
	(sleep_until (volume_test_players tv_objcon_ovr_030) 1)
	(if debug (print "::: overlook objective control 030"))
	(set s_objcon_ovr 30)

			; -------------------------------------------------
			(set ai_assassination_target sq_cov_ovr_high_elites0)
			(wake md_start_jun_stealth_kill)
			(game_save)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_ovr_040) 1)
	(if debug (print "::: overlook objective control 040"))
	(set s_objcon_ovr 40)

	(sleep_until (volume_test_players tv_objcon_ovr_050) 1)
	(if debug (print "::: overlook objective control 050"))
	(set s_objcon_ovr 50)

	(sleep_until (volume_test_players tv_objcon_ovr_060) 1)
	(if debug (print "::: overlook objective control 060"))
	(set s_objcon_ovr 60)

	(sleep_until (volume_test_players tv_objcon_ovr_070) 1)
	(if debug (print "::: overlook objective control 070"))
	(set s_objcon_ovr 70)

	(sleep_until (volume_test_players tv_objcon_ovr_080) 1)
	(if debug (print "::: overlook objective control 080"))
	(set s_objcon_ovr 80)

	(sleep_until (volume_test_players tv_objcon_ovr_090) 1)
	(if debug (print "::: overlook objective control 090"))
	(set s_objcon_ovr 90)

	(sleep_until (volume_test_players tv_objcon_ovr_100) 1)
	(if debug (print "::: overlook objective control 0100"))
	(set s_objcon_ovr 100)

	(sleep_until (volume_test_players tv_objcon_ovr_110) 1)
	(if debug (print "::: overlook objective control 0110"))
	(set s_objcon_ovr 110)

	; cleanup
	(sleep_until b_fld_started)
	(ovr_cleanup)
)


(script dormant save_ovr_defeated
	(branch
		(= b_slo_started true) (branch_abort)
	)
	
	(sleep_until (<= (ai_living_count gr_cov_ovr) 0))
	(sleep 60)
	(game_save_no_timeout)
)	

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant start_jun_main
	(if debug (print "::: overlook setting up unsc_jun..."))
	(ai_erase unsc_jun)
	(ai_place unsc_jun/start)

	(sleep 1)
	
	(set ai_jun unsc_jun)
	(ai_disregard (ai_get_object ai_jun) true)
	(ai_cannot_die ai_jun true)
	(ai_set_objective ai_jun obj_unsc_ovr)
	
	(sleep_until (or (>= s_objcon_ovr 50) (>= (ai_combat_status gr_cov_ovr) 5)) 1)
	(ai_disregard (ai_get_object ai_jun) false)
)


; AMBIENT 
; -------------------------------------------------------------------------------------------------
(script command_script cs_insertion_banshees
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 30)
	(cs_fly_by pts_insertion_banshees/flyby0 10.0)
	(cs_fly_by pts_insertion_banshees/flyby1 10.0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 4))
	(cs_fly_by pts_insertion_banshees/erase 10.0)
	(ai_erase ai_current_squad)
)

(script dormant start_banshee_control
	(sleep_until (>= s_objcon_ovr 20) 1)	
	(ai_place sq_cov_ovr_banshees)
	(ai_disregard (ai_actors sq_cov_ovr_banshees) true)
)

(script command_script cs_insertion_kiva_ds0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed 1.0)

	(cs_fly_by pts_insertion_kiva_ds0/p0)
	(cs_fly_by pts_insertion_kiva_ds0/p1)
	(cs_fly_by pts_insertion_kiva_ds0/p2)
	
	(sleep 90)
	(ai_erase ai_current_squad)
)




; PATROLS
; -------------------------------------------------------------------------------------------------
(script dormant ovr_elite_shift_control
	(sleep_until (>= s_objcon_ovr 20))
	(sleep_until
		(or 
			(volume_test_players tv_ovr_elite_shift)
			(>= s_objcon_ovr 30)
		)
	1)
	
	(if (volume_test_players tv_ovr_elite_shift)
		(cs_run_command_script sq_cov_ovr_high_elites0 cs_ovr_elite_shift))
)

(script command_script cs_stand_in_place
	;(cs_enable_looking false)
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	
	(cs_push_stance patrol)
	(sleep_forever)
)

(script command_script cs_ovr_assassination_start
	;(cs_enable_looking false)
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	(cs_look true pts_patrols_insertion/elite_high_look)
	(cs_push_stance patrol)
	(sleep_forever)
)


(script command_script cs_ovr_jackal_stand
	;(cs_enable_looking false)
	;(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	
	;(cs_push_stance patrol)
	(sleep_until (>= (ai_combat_status gr_cov_ovr) 5))
)

(script command_script cs_stand_in_place_fkv
	;(cs_enable_looking false)
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	
	(cs_push_stance patrol)
	(sleep_until (>= (ai_combat_status gr_cov_fkv) 5))
)

(global short s_specops_min_scan_time 90)
(global short s_specops_max_scan_time 300)

(script command_script cs_fkv_specops_patrol_silo_roof
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/silo_roof1)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/silo_roof2)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/silo_roof3)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
			)
		0)
	1)
)

(script command_script cs_fkv_specops_patrol_garage_roof
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/garage_roof0)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/garage_roof1)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/garage_roof2)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/garage_roof3)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
			)
		0)
	1)
)

(script command_script cs_fkv_specops_patrol_shed_roof
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/shed_roof0)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/shed_roof1)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/shed_roof2)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/shed_roof3)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
				
				(begin
					(ai_set_active_camo ai_current_actor 1)
					(camo_delay_before_moving)
					(cs_go_to pts_fkv/shed_roof4)
					(camo_delay_before_uncloaking)
					(if (<= (random_range 0 100) 70)
						(ai_set_active_camo ai_current_actor 0))
					(sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
				)
			)
		0)
	1)
)

(script static void camo_delay_before_moving
	(sleep (random_range 25 40))
)

(script static void camo_delay_before_uncloaking
	(sleep (random_range 30 60))
)	

(global short s_fkv_jetpack_patrol_dest 0) ;0= silo / 1= garage / 2= barracks / 3= shed
(global boolean b_fkv_jetpack_patrol_move false)
(script command_script cs_fkv_jetpack_search
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until b_fkv_jetpack_patrol_move 1)
	
	(sleep_until
		(begin
			(cond
				(
					(= s_fkv_jetpack_patrol_dest 0)
							(begin		
								(if debug (print "jetpacks going to silo"))
								(begin_random_count 1
									(cs_go_to pts_fkv_jetpacks/silo_roof0)
									(cs_go_to pts_fkv_jetpacks/silo_roof1)
									(cs_go_to pts_fkv_jetpacks/silo_roof2))
							)
				)
				
				(
					(= s_fkv_jetpack_patrol_dest 1)
							(begin
								(if debug (print "jetpacks going to garage"))
								(begin_random_count 1
									(cs_go_to pts_fkv_jetpacks/garage_roof0)
									(cs_go_to pts_fkv_jetpacks/garage_roof1)
									(cs_go_to pts_fkv_jetpacks/garage_roof2))
							)
				)
				
				
				(
					(= s_fkv_jetpack_patrol_dest 2)
							(begin
								(if debug (print "jetpacks going to barracks"))
								(begin_random_count 1
									(cs_go_to pts_fkv_jetpacks/barracks_roof0)
									(cs_go_to pts_fkv_jetpacks/barracks_roof1)
									(cs_go_to pts_fkv_jetpacks/barracks_roof2))
							)
				)
				
				(			
					(= s_fkv_jetpack_patrol_dest 3)
							(begin
								(if debug (print "jetpacks going to shed"))
								(begin_random_count 1
									(cs_go_to pts_fkv_jetpacks/shed_roof0)
									(cs_go_to pts_fkv_jetpacks/shed_roof1)
									(cs_go_to pts_fkv_jetpacks/shed_roof2))
							)
				)
			)
			
			(sleep_until b_fkv_jetpack_patrol_move (random_range 30 60))
		0)
	1)
)

(script command_script cs_fkv_jetpack_search_silo
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(jetpack_delay_before_moving)
	
	(begin_random_count 1
		(cs_go_to pts_fkv_jetpacks/silo_roof0)
		(cs_go_to pts_fkv_jetpacks/silo_roof1)
		(cs_go_to pts_fkv_jetpacks/silo_roof2))
		
	(sleep_forever)
)

(script command_script cs_fkv_jetpack_search_barracks
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(jetpack_delay_before_moving)
	
	(begin_random_count 1
		(cs_go_to pts_fkv_jetpacks/barracks_roof0)
		(cs_go_to pts_fkv_jetpacks/barracks_roof1)
		(cs_go_to pts_fkv_jetpacks/barracks_roof2))
		
	(sleep_forever)
)

(script command_script cs_fkv_jetpack_search_shed
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(jetpack_delay_before_moving)
	
	(begin_random_count 1
		(cs_go_to pts_fkv_jetpacks/shed_roof0)
		(cs_go_to pts_fkv_jetpacks/shed_roof1)
		(cs_go_to pts_fkv_jetpacks/shed_roof2))
		
	(sleep_forever)
)

(script command_script cs_fkv_jetpack_search_garage
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_enable_moving false)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(jetpack_delay_before_moving)
	
	(begin_random_count 1
		(cs_go_to pts_fkv_jetpacks/garage_roof0)
		(cs_go_to pts_fkv_jetpacks/garage_roof1)
		(cs_go_to pts_fkv_jetpacks/garage_roof2))
		
	(sleep_forever)
)

(script dormant fkv_jetpack_search_control
	(branch
		(>= (ai_combat_status gr_cov_fkv) 3) (branch_abort)
	)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(if debug (print "jetpacks to silo"))
					(cs_run_command_script gr_cov_fkv_jetpacks cs_fkv_jetpack_search_silo) 
					(jetpack_search_delay)
					
				)
				
				(begin
					(if debug (print "jetpacks to garage"))
					(cs_run_command_script gr_cov_fkv_jetpacks cs_fkv_jetpack_search_garage) 
					(jetpack_search_delay)
					
				)
				
				(begin
					(if debug (print "jetpacks to shed"))
					(cs_run_command_script gr_cov_fkv_jetpacks cs_fkv_jetpack_search_shed) 
					(jetpack_search_delay)
					
				)
				
				;*
				(begin
					(if debug (print "jetpacks to barracks"))
					(cs_run_command_script gr_cov_fkv_jetpacks cs_fkv_jetpack_search_barracks) 
					(jetpack_search_delay)
					
				)
				*;
			)
			
		0)
	1)
)

(script static void jetpack_search_delay
	(sleep (random_range (* 30 30) (* 30 90)))
)

(script static void jetpack_delay_before_moving
	(sleep (random_range 30 90))
)

(script command_script cs_fkv_highvalue_patrol
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to pts_fkv/cliff0)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/cliff1)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/courtyard0)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/courtyard1)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/courtyard2)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/barracks0)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/barracks1)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/shed_path0)
					(highvalue_delay_before_shift))
					
				(begin
					(cs_go_to pts_fkv/garage0)
					(highvalue_delay_before_shift))
					
			)
			
		0)
	1)
)

(script static void highvalue_delay_before_shift
	(sleep (random_range 120 400))
)

(script command_script cs_ovr_elite_shift
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	
	(cs_walk true)
	(cs_go_by pts_patrols_insertion/elite_shift0_left pts_patrols_insertion/elite_shift0_right)
	(cs_go_by pts_patrols_insertion/elite_shift1_left pts_patrols_insertion/elite_shift1_right)
	(cs_go_to pts_patrols_insertion/elite_shift2)
	;(ai_activity_set ai_current_actor "stand")
	(cs_posture_set "patrol" true)
)

(script command_script cs_insertion_elite0_look
	;(cs_enable_looking false)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	;(cs_look true pts_insertion_patrols/elite0_look)
	(cs_aim true pts_insertion_patrols/elite0_look)
	
	(sleep_until (volume_test_players tv_ovr_elite_vision_cone) 1)
)


; OVERLOOK CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void ovr_cleanup
	(if debug (print "::: overlook cleaning up the encounter..."))
	(ai_disposable gr_cov_ovr true)
	(object_destroy_folder cr_ovr)
	(sleep_forever ovr_encounter)
	(object_destroy_folder dm_ovr)
	
)



; =================================================================================================
; FIRST KIVA
; =================================================================================================
(global boolean b_fkv_infantry_delivered false)
(global boolean b_fkv_ds0_delivery_started false)
(global boolean b_fkv_phantom_exit false)
; -------------------------------------------------------------------------------------------------
(script dormant fkv_encounter
	(if debug (print "::: firstkiva ::: encounter start"))
	(game_save)
	
	(recycle_010)
	(set ai_to_deafen gr_cov_fkv)
	
	; scripts
	(wake fkv_jun_main)
	(wake fkv_jun_stealth)
	;(wake fkv_cov_shed1_spawn_control)

	; music
	(wake fkv_combat_control)
	(wake fkv_stealth_control)
	(wake fkv_retreat_control)
	(wake fkv_jetpack_search_control)
	
	(wake fkv_mus02_stop)
	
	(wake save_fkv_garage)
	(wake save_fkv_jetpacks)
	(wake save_fkv_courtyard)
	(wake save_fkv_encounter)
	

	
	(if 
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		
		(begin
			(print "heroic")
			;(ai_place sq_cov_fkv_hill_grunts0)
		)
	)
	
	;(ai_place sq_cov_fkv_jackals1)
	;(ai_place sq_cov_fkv_elites0)
	;(ai_place sq_cov_fkv_roof_shade0)
	;(ai_place sq_cov_fkv_hill_elites0)
	;(ai_place sq_cov_fkv_hill_grunts0)
	;(ai_place sq_cov_fkv_catwalk_elites0)
	;(ai_place sq_cov_fkv_balcony_shade0)
	(soft_ceiling_enable camera_blocker_01 0)
	
	;*
	(if (<= (ai_living_count sq_cov_fkv_ds0) 0)
		(begin
			(ai_place sq_cov_fkv_ds0)
			(object_teleport_to_ai_point (ai_vehicle_get sq_cov_fkv_ds0/pilot) pts_fkv_ds0/hover0)
			(cs_run_command_script sq_cov_fkv_ds0/pilot cs_fkv_ds0_hover)
		)
	)
	*;
	
	; misc ai setup
	(ai_disregard (ai_get_object sq_cov_fkv_ds0) true)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_fkv_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(game_save)
			(wake md_fkv_jun_sitrep)
			
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fkv_005) 1)
	(if debug (print "::: firstkiva objective control 005"))
	(set s_objcon_fkv 5)
			
	(sleep_until (volume_test_players tv_objcon_fkv_010) 1)
	(if debug (print "::: firstkiva objective control 010"))
	(set s_objcon_fkv 10)
			
	(sleep_until (volume_test_players tv_objcon_fkv_020) 1)
	(if debug (print "::: firstkiva objective control 020"))
	(set s_objcon_fkv 20)
	
			; -------------------------------------------------
			(bring_jun_forward 15)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fkv_030) 1)
	(if debug (print "::: firstkiva objective control 030"))
	(set s_objcon_fkv 30)
	
			; -------------------------------------------------
			(ai_suppress_combat unsc_jun true)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fkv_040) 1)
	(if debug (print "::: firstkiva objective control 040"))
	(set s_objcon_fkv 40)
	
	(sleep_until (volume_test_players tv_objcon_fkv_050) 1)
	(if debug (print "::: firstkiva objective control 050"))
	(set s_objcon_fkv 50)
	
	(sleep_until (volume_test_players tv_objcon_fkv_060) 1)
	(if debug (print "::: firstkiva objective control 060"))
	(set s_objcon_fkv 60)
	
	(sleep_until (volume_test_players tv_objcon_fkv_070) 1)
	(if debug (print "::: firstkiva objective control 070"))
	(set s_objcon_fkv 70)
	
	(sleep_until (volume_test_players tv_objcon_fkv_080) 1)
	(if debug (print "::: firstkiva objective control 080"))
	(set s_objcon_fkv 80)
	
	(sleep_until (volume_test_players tv_objcon_fkv_090) 1)
	(if debug (print "::: firstkiva objective control 090"))
	(set s_objcon_fkv 90)
	
	(sleep_until (volume_test_players tv_objcon_fkv_100) 1)
	(if debug (print "::: firstkiva objective control 100"))
	(set s_objcon_fkv 100)
	
			; -------------------------------------------------
			(bring_jun_forward 10)
			; -------------------------------------------------
	
	; cleanup
	(sleep_until (>= s_objcon_pmp 30))
	(fkv_cleanup)
)



; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant fkv_jun_main
	(if debug (print "::: firstkiva ::: setting up unsc_jun..."))
	;(ai_erase unsc_jun)
	;(ai_place unsc_jun/fk)
	
	(sleep 1)
	
	(set ai_jun unsc_jun)
	;(ai_disregard (ai_get_object unsc_jun) true)
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_fkv)
)

(script dormant fkv_jun_stealth
	(ai_disregard (ai_get_object ai_jun) true)
	(if debug (print "jun is invisible"))
	(sleep_until
		(or 
			b_slo_started
			(>= (ai_combat_status gr_cov_ovr) 5)
			(>= (ai_combat_status gr_cov_fkv) 5)
		)
	)
		
	;(if (>= (ai_combat_status gr_cov_fkv) 5)
		;(
			(if debug (print "jun is visible"))
			(ai_suppress_combat ai_jun false)
			(ai_disregard (ai_get_object ai_jun) false)
		;)
	
)


; SAVES
; -------------------------------------------------------------------------------------------------
(script dormant save_fkv_hill
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until (<= (ai_living_count sq_cov_fkv_hill_elites0) 0))

	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_fkv_center
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			(<= (ai_living_count sq_cov_fkv_grunts0) 0)
			(<= (ai_living_count sq_cov_fkv_jackals0) 0)
		)
	)
	
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_fkv_jetpacks
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until
		(and 
			(> (ai_spawn_count gr_cov_fkv_jetpacks) 0)
			(<= (ai_living_count gr_cov_fkv_jetpacks) 0)
		)
	)
	
	(game_save_no_timeout)
)

(script dormant save_fkv_garage
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until
		(and 
			(> (ai_spawn_count gr_cov_fkv_reinforce_garage) 0)
			(<= (ai_living_count gr_cov_fkv_reinforce_garage) 0)
		)
	)
	
	(game_save_no_timeout)
)


(script dormant save_fkv_courtyard
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until
		(and 
			(> (ai_spawn_count gr_cov_fkv_reinforce_courtyard) 0)
			(<= (ai_living_count gr_cov_fkv_reinforce_courtyard) 0)
		)
	)
	
	(game_save_no_timeout)
)

(script dormant save_fkv_encounter
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			(> (ai_spawn_count gr_cov_fkv_reinforce) 0)
			(f_ai_is_defeated gr_cov_fkv_reinforce)
			(<= (ai_living_count gr_cov_fkv) 0)
			
		)
	)
	
	(sleep 90)
	(game_save_no_timeout)
)

(script dormant save_fkv_buildings
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			(<= (ai_living_count sq_cov_fkv_silo) 0)
			(<= (ai_living_count sq_cov_fkv_barracks) 0)
		)
	)
	
	(sleep 30)
	(game_save_no_timeout)
)


(script dormant save_fkv_objcon_050
	(sleep_until 
		(>= s_objcon_fkv 50)
	)
	
	(sleep 30)
	(game_save_no_timeout)
)




; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant fkv_music_control
	(sleep_until
		(or (ai_is_alert gr_cov_fkv) (ai_is_alert gr_cov_slo)))
	
	(sleep_until
		(or
			(and (f_ai_is_defeated gr_cov_fkv) (f_ai_is_defeated gr_cov_slo))
			(= b_fld_started true)))
	
)

(script dormant fkv_mus02_stop
	(sleep_until (> (ai_task_count obj_cov_fkv/gate_reinforce) 0))
	(sleep_until
		(or 
			b_slo_started
			(and
				(> (ai_spawn_count gr_cov_fkv_reinforce) 0)
				(<= (ai_task_count obj_cov_fkv/gate_main) 0))
		)
	)
	
	(if debug (print "stopping mus_02"))
	(mus_stop mus_02)
	
	(if debug (print "starting exit timer"))
)

(script dormant fkv_exit_helper
	(branch
		(= b_slo_started true) (branch_fkv_exit_helper)
	)
	
	(sleep (* 30 120))
	(f_blip_flag fl_fkv_exit 21)
)

(script static void branch_fkv_exit_helper
	(f_unblip_flag fl_fkv_exit)
)


; COMBAT SCRIPTS
; -------------------------------------------------------------------------------------------------
(script dormant fkv_stealth_control
	;(ai_disregard (ai_get_object ai_jun) true)
	(sleep_until (>= (ai_combat_status gr_cov_fkv) 3))
	(cs_force_combat_status gr_cov_fkv 5)
	;(ai_disregard (ai_get_object ai_jun) false)
)



(script dormant fkv_combat_control
	(ai_place sq_cov_fkv_grunts0)
	(ai_place sq_cov_fkv_jpe2_fkv0)
	
	(if (difficulty_is_heroic_or_higher)
		(ai_place sq_cov_fkv_jpe2_fkv1)
		(ai_place sq_cov_fkv_elites0 2))
		
	(if (difficulty_is_heroic_or_higher)
		(ai_place sq_cov_fkv_e1g3_highvalue0))
	
	(if (difficulty_is_legendary)
		(if (game_is_cooperative)
			(ai_place sq_cov_fkv_specops_snipers0)
			(ai_place sq_cov_fkv_specops_snipers0 1)
		)
	)
	;(ai_place sq_cov_fkv_minion0)
	
	(sleep_until 
		(and
			;(or
				(<= (ai_strength gr_cov_fkv) 0.55)
				;(volume_test_players tv_fkv_approach_00)
			;)
			(>= (ai_combat_status gr_cov_fkv) 3)
		)
	)
	
	(sleep (random_range (* 30 5) (* 30 10)))
	(ai_place sq_cov_fkv_phantom_reinforce)
	
	(sleep 300)
	(wake md_jun_really_pissed_them_off)
)

(script dormant fkv_retreat_control
	(branch
		(= b_slo_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			;(> (ai_living_count gr_cov_fkv_highvalue) 0)
			(> (ai_spawn_count gr_cov_fkv_reinforce) 0)
			(<= (ai_strength gr_cov_fkv) 0.2)
			;(>= s_objcon_fkv 80)
		)
	)
	
	(sleep_until (volume_test_players tv_fkv_approach_02))
	
	(if debug (print "fkv is getting ready to retreat"))
	(sleep (random_range (* 30 5) (* 30 12)))
	(if debug (print "fkv is retreating!"))
	(ai_set_objective gr_cov_fkv obj_cov_slo)
)

(script static void test_new_fkv
	(ai_place unsc_jun/fkv)
	(sleep 1)
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_fkv)
	(set ai_jun unsc_jun)
	
	;(ai_place sq_cov_fkv_reinforce0)
	;(ai_place sq_cov_fkv_reinforce1)
	;(ai_place sq_cov_fkv_reinforce2)
)

(script command_script cs_cov_fkv_highvalue_dropship
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_fkv_e1g3_highvalue0 none none none)
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	
	(sleep 90)
	(ai_erase ai_current_squad)
)

(script command_script cs_cov_fkv_reinforce_dropship
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(cs_ignore_obstacles 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_fkv_reinforce/entry1)
	
			; -------------------------------------------------
			(ai_place sq_cov_fkv_e1j4_reinforce0)
			(ai_place sq_cov_fkv_e1g6_reinforce0)
		
			(ai_vehicle_enter_immediate sq_cov_fkv_e1g6_reinforce0 (ai_vehicle_get ai_current_actor) "phantom_p_r")
			(ai_vehicle_enter_immediate sq_cov_fkv_e1j4_reinforce0 (ai_vehicle_get ai_current_actor) "phantom_p_l")
			; -------------------------------------------------
	
	(cs_vehicle_boost 0)
	(cs_vehicle_speed 0.7)
	
	(cs_fly_by ps_fkv_reinforce/entry0)
	
	
	(cs_vehicle_speed 0.3)
	
		
	(cs_fly_to_and_face ps_fkv_reinforce/hover ps_fkv_reinforce/land_facing 0.7)
	
	(sleep 30)
	
	(cs_vehicle_speed 0.2)
	(cs_fly_to_and_face ps_fkv_reinforce/land ps_fkv_reinforce/land_facing 0.2)

	

	;(f_load_phantom (ai_vehicle_get ai_current_actor) "dual"  sq_cov_fkv_e1j4_reinforce0 sq_cov_fkv_e1g6_reinforce0 none  none)
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")

	(sleep 90)
	(if (= b_slo_started true)
		(ai_set_objective gr_cov_fkv_reinforce obj_cov_slo))
	
	(cs_fly_to_and_face ps_fkv_reinforce/hover ps_fkv_reinforce/land_facing)
	(sleep 20)
	
	(cs_vehicle_speed 0.7)
	(cs_fly_by ps_fkv_reinforce/exit0)
	
	(cs_vehicle_speed 1)
	(cs_fly_by ps_fkv_reinforce/exit1)
	(cs_vehicle_boost 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	(cs_fly_by ps_fkv_reinforce/erase)
	(ai_erase ai_current_squad)
)

(script command_script cs_cov_fkv_reinforce_left
	(cs_enable_looking 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	
	(cs_go_by ps_fkv_reinforce/left_dest0 ps_fkv_reinforce/left_dest0)
)

(script command_script cs_cov_fkv_highvalue_report
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	(cs_push_stance patrol)
	
	
	(cs_go_to ps_fkv_highvalue/highvalue_dest)
	(sleep_forever)
)

(script dormant fkv_pose_bodies
	(pose_body sc_fkv_body_00 pose_against_wall_var2)
	(pose_body sc_fkv_body_01 pose_against_wall_var2)
	(pose_body sc_fkv_body_02 pose_on_side_var5)
	(pose_body sc_fkv_body_03 pose_face_down_var3)
	(pose_body sc_fkv_body_04 pose_against_wall_var1)
	(pose_body sc_fkv_body_05 pose_on_back_var3)
	(pose_body sc_fkv_body_06 pose_on_side_var1)
	(pose_body sc_fkv_body_07 pose_on_side_var2)
	(pose_body sc_fkv_body_08 pose_against_wall_var3)
	(pose_body sc_fkv_body_09 pose_face_down_var1)
	(pose_body sc_fkv_body_10 pose_face_down_var2)
	
	(sleep_until b_pmp_started)
	
	(object_destroy_folder sc_fkv_bodies)
)

(script static void branch_abort_fkv_bodies
	(object_destroy_folder sc_fkv_bodies)
)	


(script dormant fkv_cov_shed1_spawn_control
	(sleep_until 
		(and
			(< (ai_strength gr_cov_fk) 0.15)
			(>= s_objcon_fkv 50)))
			
	(ai_place sq_cov_fkv_shed1)	
)


(script static boolean fkv_ds0_turret_is_alive
	(> (unit_get_health (ai_get_turret_ai sq_cov_fkv_ds0/pilot 0)) 0)
)



; PATROLS
; -------------------------------------------------------------------------------------------------


(script command_script cs_fkv_hill_elite_idle
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	
	(unit_set_stance ai_current_actor "patrol")
	
	;(cs_go_to pts_fkv_hill_patrols/p0)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_look true pts_fkv_hill_patrols/elite_look0)
					(sleep (random_range 90 210)))
					
				(begin
					(cs_look true pts_fkv_hill_patrols/elite_look1)
					(sleep (random_range 90 210)))
					
				(begin
					(cs_look true pts_fkv_hill_patrols/elite_look2)
					(sleep (random_range 90 210)))
			)
		0)
	1)
)


; DROPSHIP 0
; -------------------------------------------------------------------------------------------------
(script command_script cs_fk_ds0_gunner_auto
	(if debug (print "ds0 turret control disabled..."))
)

(script command_script cs_fkv_ds0_approach
	(cs_vehicle_speed 0.75)
	
	(cs_fly_by pts_fkv_ds0/p0)
	(cs_fly_by pts_fkv_ds0/p1)
	(cs_fly_by pts_fkv_ds0/p2)
	(cs_fly_by pts_fkv_ds0/p3)
	(cs_fly_by pts_fkv_ds0/p4)
	(cs_fly_by pts_fkv_ds0/p5)
	
	;(ai_erase ai_current_squad)
	(cs_queue_command_script ai_current_actor cs_fkv_ds0_exit)
)


; FIRST KIVA DROPSHIP SEARCHES COURTYARD
; Idle state for this guy.
; -------------------------------------------------------------------------------------------------
(script command_script cs_fkv_ds0_hover
	(cs_vehicle_speed 0.4)
	(cs_fly_to_and_face pts_fkv_ds0/hover0 pts_fkv_ds0/facing 0.25)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fkv_ds0_gunner_search_courtyard)
	(cs_vehicle_speed 0.1)
	(sleep_until
		(begin
			(cs_fly_to_and_face pts_fkv_ds0/hover0 pts_fkv_ds0/facing 0.25)
			(sleep (random_range 90 150))
			(cs_fly_to_and_face pts_fkv_ds0/hover1 pts_fkv_ds0/facing 0.25)
			(sleep (random_range 90 150))
			(cs_fly_to_and_face pts_fkv_ds0/hover1 pts_fkv_ds0/facing 0.25)
			(sleep (random_range 90 150))
		0)
	1)
)

(script command_script cs_fkv_ds0_gunner_search_courtyard
	(if debug (print "ds0 gunner searching center..."))
	(sleep_until
		(begin
			(cs_aim TRUE pts_fk_ds0_search_courtyard/target0)
			(if debug (print "courtyard target0"))
			(sleep 150)
			(cs_aim TRUE pts_fk_ds0_search_courtyard/target1)
			(if debug (print "courtyard target1"))
			(sleep 150)	
			(cs_aim TRUE pts_fk_ds0_search_courtyard/target2)
			(if debug (print "courtyard target2"))
			(sleep 150)	
			(cs_aim TRUE pts_fk_ds0_search_courtyard/target3)
			(if debug (print "courtyard target3"))
			(sleep 150)										
		
			false
		)
	)
)


; FIRST KIVA DROPSHIP EXITS SPACE
; Light is shot out or encounter times out
; -------------------------------------------------------------------------------------------------
(script static void fkv_ds0_exit
	(cs_run_command_script sq_cov_fkv_ds0/pilot cs_fkv_ds0_exit)
)

(script command_script cs_fkv_ds0_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 0.8)	
	(cs_fly_by pts_fk_ds_exit/exit0)
	(cs_fly_by pts_fk_ds_exit/exit1)
	(cs_fly_by pts_fk_ds_exit/exit2)
	(cs_vehicle_speed 1.0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by pts_fk_ds_exit/erase)
	(ai_erase ai_current_squad)
)


; FIRST KIVA DROPSHIP ATTACKS PLAYER
; Backs off to the kiva center and puts pressure on the player
; -------------------------------------------------------------------------------------------------
(script static void fkv_ds0_attack_hill
	(cs_run_command_script sq_cov_fkv_ds0/pilot cs_fkv_ds0_attack))
	
(script command_script cs_fkv_ds0_attack
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fk_ds0_gunner_auto)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.4)
	
	;(cs_fly_by pts_fk_ds0_search_courtyard/entry0)
	
	(cs_fly_to pts_fk_ds0_search_courtyard/hover_hill 0.5)
	;(cs_fly_to_and_face pts_fk_ds0_search_courtyard/hover_hill pts_fk_ds0_search_courtyard/hill 0.25)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fk_ds0_gunner_auto)
)

; FIRST KIVA DROPSHIP PUTS PEOPLE ON THE HILL
; -------------------------------------------------------------------------------------------------
(script static void fkv_ds0_dropoff_hill
	(cs_run_command_script sq_cov_fkv_ds0/pilot cs_fkv_ds0_dropoff_hill))
	
(script command_script cs_fkv_ds0_dropoff_hill
	(cs_vehicle_speed 0.4)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_fkv_reinforce_elites0 sq_cov_fkv_reinforce_grunts0 NONE NONE)
	(cs_fly_to_and_face pts_fk_ds0_search_courtyard/land pts_fk_ds0_search_courtyard/land_facing 0.25)
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	(sleep 30)
	;(ai_erase ai_current_squad)
	(cs_run_command_script ai_current_actor cs_fkv_ds0_exit)
)


; FIRST KIVA CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void fkv_cleanup
	(if debug (print "::: firstkiva ::: cleaning up encounter..."))
	(ai_disposable gr_cov_fkv true)
	(object_destroy_folder cr_fkv)
	(object_destroy_folder wp_fkv)
	(object_destroy_folder sc_fkv)
	
	(object_destroy_folder cr_ovr)
	(object_destroy_folder dm_ovr)
	
	(object_destroy_folder cr_fkv)
	(object_destroy_folder dm_fkv)
	(object_destroy_folder sc_fkv)
	(object_destroy_folder wp_fkv)
	
	(sleep_forever fkv_encounter)
)

; =================================================================================================
; SILO
; =================================================================================================
; -------------------------------------------------------------------------------------------------
(script dormant silo_encounter
	(if debug (print "::: silo ::: encounter start"))
	
	; set second mission segment
	(data_mine_set_mission_segment "m30_02_silo_encounter")
	(garbage_collect_now)
	
	; object management
	;(object_create_folder cr_slo)
	(object_create_folder wp_slo)
	(object_create_folder sc_slo)
	
	; place ai
	(ai_place gr_cov_slo)
	(soft_ceiling_enable camera_blocker_02 0)
	
	; wake subsequent scripts
	(wake slo_jun_main)
	(wake slo_backup_control)
	
	;(wake save_slo_move)
	(wake save_slo_grind)
	
	(ai_set_objective gr_cov_fkv obj_cov_slo)
	
	; music
	(mus_stop mus_02)
	(mus_stop mus_01)
	
	(wake slo_save_start)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_slo_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(wake show_tutorial_nightvision)
			(f_unblip_flag fl_fkv_exit)
			(ai_disregard (ai_get_object ai_jun) false)
			; -------------------------------------------------
	
	(sleep_until (or
		(volume_test_players tv_objcon_slo_010a)
		(volume_test_players tv_objcon_slo_010b)
		(volume_test_players tv_objcon_slo_010c)
		(volume_test_players tv_objcon_slo_010d)) 1)
	(if debug (print "::: silo ::: objective control 010"))
	(set s_objcon_slo 10)
	
			; -------------------------------------------------
			;(game_save)
			(bring_jun_forward 10)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_slo_020) 1)
	(if debug (print "::: silo ::: objective control 020"))
	(set s_objcon_slo 20)
	
			; -------------------------------------------------
			(wake save_slo_move)
			;(wake md_slo_jun_use_gate)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_slo_030) 1)
	(if debug (print "::: silo ::: objective control 030"))
	(set s_objcon_slo 30)
	
	
			(game_save)
			
			
	; cleanup
	(sleep_until (>= s_objcon_pmp 5))
	(silo_cleanup)
)

(script dormant slo_save_start
	(sleep_until (>= (current_zone_set_fully_active) s_zone_index_fields))
	(sleep 90)
	(if debug (print "save silo start"))
	(game_save_no_timeout)
)

(script dormant save_slo_move
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	
	(game_save_no_timeout)
)

(script dormant save_slo_grind
	(branch
		(= b_fld_started true) (branch_abort)
	)
	
	(sleep_until (<= (ai_strength gr_cov_slo) 0.5))
	
	(if debug (print "save silo grind"))
	(game_save_no_timeout)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant slo_jun_main
	(if debug (print "::: silo ::: setting up unsc_jun..."))
	;(ai_erase unsc_jun)
	;(ai_place unsc_jun/silo)
	;(tick)
	;(ai_disregard (ai_get_object unsc_jun) true)
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_slo)
)


; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant slo_pose_bodies
	(pose_body sc_slo_body_00 pose_against_wall_var1)
	(pose_body sc_slo_body_01 pose_against_wall_var3)
	(pose_body sc_slo_body_02 pose_on_side_var3)
	
	(sleep_until b_pmp_started)
	(object_destroy_folder sc_slo_bodies)
)


; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void silo_cleanup
	(if debug (print "::: silo ::: cleaning up encounter..."))
	(ai_disposable gr_cov_slo true)
	
	; object managemant
	(object_destroy_folder wp_slo)
	(object_destroy_folder sc_slo)
	
	(sleep_forever silo_encounter)
)

; ENCOUNTER
; -------------------------------------------------------------------------------------------------
(script dormant slo_backup_control
	(sleep_until (> s_objcon_slo 10))
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_slo) 2)
			(>= s_objcon_slo 30)
		)
	)
	(game_save)
	(ai_place sq_cov_slo_backup0)
)


; =================================================================================================
; FIELDS
; =================================================================================================
(global boolean b_fld_mule_intro_complete false)
; -------------------------------------------------------------------------------------------------

(script dormant fld_encounter
	;(sleep_until (volume_test_players tv_fields_start) 1)
	(if debug (print "::: fields ::: encounter start"))
	(recycle_020)
	
	; object management
	(object_create_folder cr_fld)
	(object_create_folder wp_fld)
	;(object_create_folder bp_fld)
	(object_create_folder eq_fld)
	(object_create_folder cr_fld_flares)
	
	; wake subsequent scripts
	(wake fld_jun_main)
	(wake fld_mule_main)
	(wake fld_mule_safezone_control)
	; ai
	(ai_place sq_cov_fld_ph0)
	
	(wake fld_mus05_stop)
	
	(mus_start mus_03)
	(mus_stop mus_02)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_fld_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(game_save)			
			(game_insertion_point_unlock 1)
			(ai_erase gr_cov_ovr)
			; -------------------------------------------------

	(sleep_until (volume_test_players tv_objcon_fld_010) 1)
	(if debug (print "::: fields ::: objective control 010"))
	(set s_objcon_fld 10)
	
			; -------------------------------------------------
			(garbage_collect_now)
			
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fld_020) 1)
	(if debug (print "::: fields ::: objective control 020"))
	(set s_objcon_fld 20)
	
			; -------------------------------------------------
			(wake chapter_title_mule)
			(game_save)
			;(ai_place gr_cov_fld)
			;(ai_place sq_cov_fld_vignette0)
			(ai_place sq_cov_fld_inf1)
			;(ai_place sq_mule_fld)
			
			(wake fld_mule_vitality_control)
			(wake fld_infantry_low_control)

			;
			(wake md_post_mule_convo)
			(soft_ceiling_enable camera_blocker_03 0)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fld_030) 1)
	(if debug (print "::: fields ::: objective control 030"))
	(set s_objcon_fld 30)
	
			; -------------------------------------------------
			(fld_jun_failsafe)
			(wake md_fld_jun_mule_intro)
			;(wake md_fld_jun_stay_outta_sight)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_fld_040) 1)
	(if debug (print "::: fields ::: objective control 040"))
	(set s_objcon_fld 40)
	
			; -------------------------------------------------
			(mus_start mus_05)
			(bring_jun_forward 10)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_fld_050) 1)
	(if debug (print "::: fields ::: objective control 050"))
	(set s_objcon_fld 50)
	
	(sleep_until (volume_test_players tv_objcon_fld_060) 1)
	(if debug (print "::: fields ::: objective control 060"))
	(set s_objcon_fld 60)
	
	; cleanup
	(sleep_until (>= s_objcon_pmp 20))
	(fld_cleanup)
)


; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant fld_jun_main
	(if debug (print "::: pumpstation ::: setting up unsc_jun..."))
	;(ai_erase unsc_jun)
	;(ai_place unsc_jun/fld)
	
	(sleep 1)
	
	(set ai_jun unsc_jun)
	(ai_set_objective unsc_jun obj_unsc_fld)
	;(set jun unsc_jun/fld)
	(ai_cannot_die unsc_jun true)
)

(script dormant fld_mus05_stop
	(sleep_until 
		(and
			(> (ai_spawn_count gr_cov_fld) 0)
			(> (ai_spawn_count sq_mule_fld) 0)))
			
	(sleep_until
		(and
			(<= (ai_living_count gr_cov_fld) 0)
			(<= (ai_living_count sq_mule_fld) 0)))
			
	(mus_stop mus_05)
)

(script static void fld_jun_failsafe
	(if 
		(or
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_020)
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_025)
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_028)
		)
		
		(if debug (print "jun is in a safe bsp, won't teleport him"))
		
		(object_teleport (ai_get_object ai_jun) fl_jun_failsafe_fld)
	)
)

; COMBAT
; -------------------------------------------------------------------------------------------------
(script dormant fld_mule_vitality_control
	(sleep_until
		(begin
			(if debug (print "fld: pegging mule vitality..."))
			(unit_set_current_vitality (ai_get_unit sq_mule_fld/low) 250 0)
			(unit_set_current_vitality (ai_get_unit sq_mule_fld/high) 250 0)
			(sleep (* 30 10))
		
		; exit condition
		; -------------------------------------------------
		(or
		(<= (ai_living_count sq_mule_fld) 0)
		(= b_pmp_started true)
		(<= (ai_living_count gr_cov_fld) 0))
		; -------------------------------------------------
		)
	1 
	(* 30 90))
	
	(if debug (print "fld: done pegging mule vitality..."))
)

(script dormant fld_mule_main
	(ai_disregard (ai_actors sq_cov_fld_ph0) true)
	(sleep_until (>= s_objcon_fld 20) 1)
	(ai_place sq_mule_fld)
	(sleep 5)
	
	(ai_disregard (ai_actors sq_cov_fld_ph0) true)
	(ai_disregard (ai_get_object unsc_jun) true)
	; commented out for petar
	(thespian_performance_setup_and_begin p070_mule "" 0)
	
	(ai_cannot_die sq_mule_fld true)
	(sleep_until (>= s_objcon_fld 40) 30 (* 30 20))
	(ai_cannot_die sq_mule_fld false)
)


(script dormant fld_infantry_low_control
	(ai_place sq_cov_fld_inf0)
	(ai_set_blind sq_cov_fld_inf0 true)
	
	(sleep_until b_fld_mule_intro_complete 1 (* 30 15))
	(ai_set_blind sq_cov_fld_inf0 false)
)

(script command_script cs_fld_stand_in_place
	(cs_enable_targeting false)
	(sleep_forever)
)

(script dormant fld_mule_safezone_control
	(branch 
		(>= s_objcon_pmp 20) (branch_abort)
	)
	
	(sleep_until
		(begin
			(sleep_until (not (volume_test_players tv_fld_mule_safezone)))

				(if debug (print "fld ::: player has left the safezone..."))
				
				(if (<= (ai_living_count gr_cov_fld) 0)
					(begin
						(cs_run_command_script sq_mule_fld cs_fld_mule_backoff))
					
					(begin
						(ai_set_targeting_group gr_cov_fld 10 true)
						(ai_set_targeting_group sq_mule_fld 10 false)
					)
				)
						
			
			(sleep_until (volume_test_players tv_fld_mule_safezone))
			
				(if debug (print "fld ::: player has re-entered the safezone..."))
				
				(cs_run_command_script sq_mule_fld cs_exit)
				(ai_set_targeting_group gr_cov_fld -1 true)
				(ai_set_targeting_group sq_mule_fld -1 true)
		0)
	1)
)

(script command_script cs_fld_mule_backoff
	(begin_random_count 1
		(cs_go_to_and_face pts_fields_mule/hide0 pts_fields_mule/center)
		(cs_go_to_and_face pts_fields_mule/hide1 pts_fields_mule/center)
		(cs_go_to_and_face pts_fields_mule/hide2 pts_fields_mule/center)
	)
)

; DROPSHIP
; -------------------------------------------------------------------------------------------------
(script command_script cs_fields_ds0_main
	(cs_enable_pathfinding_failsafe true)
	(if debug (print "::: fields phantom ::: holding..."))
	(cs_vehicle_speed 0.3)
	(cs_fly_by pts_fields_ds0/entry0)
	;(sleep_until (volume_test_object tv_fields_mule_on_ground (ai_get_object fields_mule)) 1)
	(sleep 10)
	(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_fields_ds0_turret_intro)
	(if debug (print "::: fields phantom ::: hovering..."))
	(cs_vehicle_speed 0.2)
	(cs_fly_to_and_face pts_fields_ds0/hover pts_fields_ds0/facing 0.25)
	(sleep_until (> (ai_living_count sq_mule_fld) 0) 1)
	(sleep 1)
	(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_fields_ds0_turret)
	
	(sleep_until 
		(or
			(and
				 (<= (ai_living_count gr_cov_fld) 0)
				  (<= (ai_living_count sq_mule_fld) 0))
			b_pmp_started
			(<= (unit_get_health (ai_get_turret_ai ai_current_actor 0)) 0)
		)
	)
				
	(if debug (print "::: fields phantom ::: exiting..."))
	(cs_fly_by pts_fields_ds0/exit0)
	(cs_vehicle_speed 0.8)
	(cs_fly_by pts_fields_ds0/erase)
	
	(ai_erase ai_current_squad)
)

(script command_script cs_fields_ds0_turret_intro
	(sleep_until
		(begin
			(if debug (print "aiming at light_target0"))
			(cs_aim true pts_fields_mule/light_target0)
			(sleep (random_range 150 300))
			(if debug (print "aiming at light_target1"))
			(cs_aim true pts_fields_mule/light_target1)
			(sleep (random_range 150 300))
		false)
	)
)

(script command_script cs_fields_ds0_turret
	(print "turret active and tracking mules...")
	(sleep_until
		(begin
			(if (> (object_get_health (ai_get_object sq_mule_fld/low)) 0)
				(begin
					(if debug (print "aiming at fields_mule/low"))
					(cs_aim_object TRUE (ai_get_object sq_mule_fld/low))
					(sleep (random_range 150 300))
				)
			)
			
			(if (> (object_get_health (ai_get_object sq_mule_fld/high)) 0)
				(begin
				
					(if debug (print "aiming at fields_mule/high"))
					(cs_aim_object TRUE (ai_get_object sq_mule_fld/high))
					(sleep (random_range 150 300))
				)
			)
		(= (ai_living_count sq_mule_fld) 0))
		
	)
	
	(sleep_forever)
)

(script dormant md_post_mule_convo
	
	(sleep_until
		(or
			(>= s_objcon_pmp 5)
			(and
				(<= (ai_living_count gr_cov_fld) 0)
				(<= (ai_living_count sq_mule_fld) 0)
			)
		)
	1)
	
	(if 
		(and
				(<= (ai_living_count gr_cov_fld) 0)
				(<= (ai_living_count sq_mule_fld) 0)
		)
				(wake md_fld_jun_asks_kat_about_mule)
	)
			

)


; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void fld_cleanup
	(if debug (print "::: fields ::: cleaning up the encounter..."))
	(ai_disposable gr_cov_fld true)
	(object_destroy_folder cr_fld)
	(object_destroy_folder wp_fld)
	;(object_destroy_folder bp_fld)
	(sleep_forever fld_encounter)
	(sleep_forever fld_mule_safezone_control)
)



; =================================================================================================
; PUMPSTATION
; =================================================================================================
(global boolean b_pmp_assault_started false)
(global boolean b_pmp_assault_complete false)
(global boolean b_pmp_cache_discussed false)
(global boolean b_pmp_cache_deployed false)
(global short s_pmp_assault_wave -1) 			; 1 - alpha, 2 - bravo, 3 - charlie, etc
(global boolean b_pmp_go_to_gate false)
(global boolean b_pmp_move_to_river false)
(global boolean b_pmp_alpha_enroute false)
(global boolean b_pmp_bravo_enroute false)
(global boolean b_pmp_charlie_enroute false)
(global boolean b_pmp_alpha_delivered false)
(global boolean b_pmp_bravo_delivered false)
(global boolean b_pmp_charlie_delivered false)
(global boolean b_pmp_firefight_start false)
(global boolean b_pmp_player_skips_encounter false)
(global boolean b_pmp_charlie_should_spawn false)
(global boolean b_pmp_assault_start_dropships false)


; dropship alpha
(global ai ai_pmp_creek_00 sq_cov_pmp_creek_inf0)
(global ai ai_pmp_creek_01 sq_cov_pmp_creek_inf1)
(global ai ai_pmp_creek_02 NONE)
(global ai ai_pmp_creek_03 NONE)

; dropship bravo
(global ai ai_pmp_road_00 sq_cov_pmp_road_grunts0)
(global ai ai_pmp_road_01 sq_cov_pmp_road_elites0)
(global ai ai_pmp_road_02 sq_cov_pmp_road_grunts1)
(global ai ai_pmp_road_03 NONE)

; dropship (yuh hafta' die) charlie
(global ai ai_pmp_lake_00 sq_cov_pmp_lake_elites0)
(global ai ai_pmp_lake_01 NONE)
(global ai ai_pmp_lake_02 sq_cov_pmp_lake_jackals0)
(global ai ai_pmp_lake_03 NONE)

; -------------------------------------------------------------------------------------------------
(script dormant pmp_encounter
	;(sleep_until (volume_test_players tv_pmp_start) 1)
	(if debug (print "::: pumpstation ::: encounter start"))
	
	; set third mission segment
	(data_mine_set_mission_segment "m30_03_pmp_encounter")
	(game_save)
	(recycle_025)
	
	; object management
	
	
	; wake scripts
	(wake pmp_jun_main)
	(wake pmp_assault_main)
	(wake pmp_unsc_militia_spawn)
	;(wake pmp_player_stealth_control)	
	(wake pmp_moa_spawn)
	(wake pmp_bird_control)
	(wake pmp_sniper_control)
	
	(wake md_pmp_jun_sees_militia)
	
	; music control
	;(wake music_control_03_start)
	;(wake music_control_03_alt)
	;(wake music_control_03_stop)
	;(wake music_control_04_start)
	
	(wake save_pmp_intro_collapse)
	; place ai
	;(ai_place sq_cov_pmp_ds0_intro)

	(mus_stop mus_05)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_pmp_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(ai_disregard (ai_actors ai_jun) false)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_pmp_005) 1)
	(if debug (print "::: pumpstation ::: objective control 005"))
	(set s_objcon_pmp 5)
	
			; -------------------------------------------------
			(bring_jun_forward 22)
			; -------------------------------------------------
	
	
	(sleep_until (volume_test_players tv_objcon_pmp_010) 1)
	(if debug (print "::: pumpstation ::: objective control 10"))
	(set s_objcon_pmp 10)

			; -------------------------------------------------
			(garbage_collect_now)
			(game_save)
			(wake md_pmp_jun_magnums)
			
			(ai_place sq_cov_pmp_phantom_start)
			(ai_place sq_cov_pmp_inf0)
			(ai_place sq_cov_pmp_inf1)
			(ai_place sq_cov_pmp_inf2)
			
			(object_create_folder cr_pmp)
			(object_create_folder wp_pmp)
			;(object_create_folder bp_pmp)
			(object_create_folder dm_pmp)
			(object_create_folder sc_pmp)
			(wake pmp_pose_bodies)
			; -------------------------------------------------
			(soft_ceiling_enable camera_blocker_04 0)
			
	(sleep_until (volume_test_players tv_objcon_pmp_020) 1)
	(if debug (print "::: pumpstation ::: objective control 20"))
	(set s_objcon_pmp 20)	
	
			; -------------------------------------------------
			(ai_erase gr_cov_fld)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_pmp_030) 1)
	(if debug (print "::: pumpstation ::: objective control 30"))
	(set s_objcon_pmp 30)	
	
			; -------------------------------------------------
			(object_create_folder cr_rvr_flares)
			(ai_bring_forward ai_jun 15)
			
			(ai_erase gr_cov_slo)
			(ai_erase gr_cov_fkv)
			(ai_erase gr_cov_ovr)
			; -------------------------------------------------
			
	; cleanup
	(sleep_until b_set_started)
	
	(pmp_cleanup)
)


; SAVES
; -------------------------------------------------------------------------------------------------
(script dormant save_pmp_intro_collapse
	(sleep_until 
		(and
			(<= (ai_task_count obj_cov_pmp/gate_initial_forward) 0)
			(>= s_objcon_pmp 30)
		)
	)
	(game_save_no_timeout)
)

; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant pmp_bird_control
	(sleep_until 
		(or
			(<= (objects_distance_to_flag (ai_actors ai_jun) fl_pmp_birds0) 5)
			(<= (objects_distance_to_flag player0 fl_pmp_birds0) 5)
		)
	)
	
	(if debug (print "birds!"))
	(flock_create birds_pmp_01)
	(sleep (random_range 5 15))
	(flock_create birds_pmp_02)
	(sleep (random_range 10 25))
	(flock_create birds_pmp_03)
)

(script static void pmp_bird_kill
	(flock_delete birds_pmp_01)
	(flock_delete birds_pmp_02)
	(flock_create birds_pmp_03)
)

(script dormant pmp_pose_bodies
	(pose_body sc_pmp_body_00 pose_face_down_var3)
	(pose_body sc_pmp_body_01 pose_against_wall_var2)
	(pose_body sc_pmp_body_02 pose_on_side_var2)
	(pose_body sc_pmp_body_03 pose_face_down_var1)
	(pose_body sc_pmp_body_04 pose_face_down_var1)
	(pose_body sc_pmp_body_05 pose_against_wall_var1)
	(pose_body sc_pmp_body_06 pose_against_wall_var3)
	(pose_body sc_pmp_body_07 pose_against_wall_var2)
	
	(sleep_until b_set_started)
	(object_destroy_folder sc_pmp_bodies)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant pmp_jun_main
	(if debug (print "::: pumpstation ::: setting up unsc_jun..."))
	
	;(ai_bring_forward (ai_get_object ai_jun) 5)
	(sleep 10)
	
	(set ai_jun unsc_jun)
	(ai_set_objective unsc_jun obj_unsc_pmp)
	;(set jun unsc_jun/pumpstation)
	(ai_cannot_die unsc_jun true)
	

)

(script dormant pmp_moa_spawn
	(ai_place sq_amb_pmp_moas0)
	(sleep 10)
	(if debug (print "(ai_disregard (ai_actors sq_amb_pmp_moas0) true)"))
	(ai_disregard (ai_actors sq_amb_pmp_moas0) true)
)

(script dormant pmp_unsc_militia_spawn
	(sleep_until (>= s_objcon_pmp 10) 1)
	(if debug (print "::: pumpstation ::: spawning unsc security force..."))
	
	(ai_place sq_unsc_pmp_militia0)
	(ai_place sq_unsc_pmp_militia1)
	(wake pmp_militia_renew)
	
	(ai_magically_see sq_unsc_pmp_militia0 gr_cov_pmp)
	(ai_magically_see gr_cov_pmp sq_unsc_pmp_militia0)
	;(ai_place sq_unsc_pmp_militia2)
	
	;(ai_cannot_die sq_unsc_pmp_militia0 true)
	;(ai_cannot_die sq_unsc_pmp_militia1 true)
	;(ai_cannot_die sq_unsc_pmp_militia2 true)
	
	;(sleep_until (>= s_objcon_pmp 20) 1)
	
			; -------------------------------------------------
			
			
			
			
			;(md_pmp_jun_sees_militia)
		
			
			; -------------------------------------------------
		
	(sleep_until (= b_pmp_assault_complete true))
	
			; -------------------------------------------------
			(f_unblip_ai sq_unsc_pmp_militia0)
			(f_unblip_ai sq_unsc_pmp_militia1)
			(f_unblip_ai sq_unsc_pmp_militia2)
			; -------------------------------------------------
)

(script dormant pmp_militia_renew
	(sleep_until
		(begin
			(ai_renew gr_militia)
			(sleep (* 30 5))
		b_rvr_started)
	1)
)

(script static void pmp_jun_failsafe
	(if 
		(or
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_028)
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_030)
			(= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_035)
		)
		
		(if debug (print "jun is in a safe bsp, won't teleport him"))
		
		(object_teleport (ai_get_object ai_jun) fl_jun_failsafe_pmp)
	)
)


; COMBAT
; -------------------------------------------------------------------------------------------------
(script static void pmp_player_skips_encounter
	(if debug (print "pmp: player has skipped this encounter. killing a script..."))
	(ai_kill_silent gr_militia)
	(f_unblip_ai gr_militia)
	(mus_stop mus_06)
	(mus_stop mus_07)
)

(script dormant pmp_sniper_control
	(if 
		(and
			(difficulty_is_legendary)
			(>= (game_coop_player_count) 3)
		)
		
		; we're on legendary 3+ player coop
		(begin
			(if debug (print "placing legendary 3+ sniper"))
			(sleep_until (= b_pmp_alpha_enroute true))
			(ai_place sq_cov_pmp_creek_snipers0)
		)
	)
)

(script command_script cs_pmp_snipers
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	
	(sleep_until (<= (ai_living_count gr_cov_pmp) 1))
	(sleep (random_range 90 210))
	
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(cs_shoot 0)
	
	(cs_go_to ps_pmp_snipers/erase)
	(ai_erase ai_current_actor)
)

(script dormant pmp_player_stealth_control
	(sleep_until (>= s_objcon_pmp 10) 1)
	(ai_disregard (players) true)
	(ai_disregard (ai_get_object unsc_jun) true)
	
	(sleep_until (>= s_objcon_pmp 30) 30 (* 30 25))
	(ai_disregard (players) false)
	(ai_disregard (ai_get_object unsc_jun) false)
)

(global ai ai_stash_militia none)
(script dormant pmp_assault_main
	; exit out if the player ignores the combat encounter
	(branch
		(= b_pmp_player_skips_encounter true) (pmp_player_skips_encounter))
		
	(sleep_until (>= s_objcon_pmp 20) 1)
	(sleep_until 
		(and
			(<= (ai_task_count obj_cov_pmp/gate_initial) 0)
			(= b_pmp_start_dropship_delivered true)
		)
	 30 
	 (* 30 600))

	
			; initial wave is down
			; -------------------------------------------------
			;(ai_cannot_die sq_unsc_pmp_militia0 false)
			;(ai_cannot_die sq_unsc_pmp_militia1 false)
			;(ai_cannot_die sq_unsc_pmp_militia2 false)
			(game_save)
			
			(wake pmp_counterattack_control)
			
			; start the convo
			(if (> (ai_living_count gr_militia) 0)
				(begin
					;(thespian_performance_setup_and_begin thespian_pmp_stash "" 0)
					(cs_run_command_script ai_jun cs_pmp_stash_convo_jun)
					(cs_run_command_script sq_unsc_pmp_militia0/militia0 cs_pmp_stash_convo_mil0)
					(cs_run_command_script sq_unsc_pmp_militia0/militia1 cs_pmp_stash_convo_mil1)
					(cs_run_command_script sq_unsc_pmp_militia1/militia0 cs_pmp_stash_convo_mil2)
					(cs_run_command_script sq_unsc_pmp_militia1/militia1 cs_pmp_stash_convo_mil3)
					
					(sleep (random_range (* 30 6) (* 30 8)))
	
					(wake md_pmp_stash_convo)
					
					(sleep_until (= b_pmp_stash_convo_completed true) 30 (* 30 30))
				)
				
				(begin
					(set b_pmp_assault_start_dropships true)
					(sleep 30)
					(set b_pmp_stash_convo_completed true)
				)
			)
			
			(set b_pmp_assault_start_dropships true)
			
			;(md_pmp_jun_another_dropship)
			;(thespian_performance_kill_by_name thespian_pmp_stash)
			(game_save)
			(sleep 30)
			
			
			;(ai_place sq_cov_pmp_charlie_ds)
			; -------------------------------------------------
	
	;*
	(sleep_until (> (ai_living_count gr_cov_pmp_lake) 0))
	(sleep_until
		(or
			(< (ai_strength gr_cov_pmp_lake) 0.5)
			(< (ai_strength gr_cov_pmp_assault) 0.27)
			(f_ai_is_defeated sq_cov_pmp_lake_elites0)
		)
	)
			; -------------------------------------------------
			(wake pmp_save_wave2_complete)
			(ai_place sq_cov_pmp_alpha_ds)
			; -------------------------------------------------

	(sleep_until (> (ai_living_count gr_cov_pmp_road) 0))
	(sleep_until
		(or
			(< (ai_strength gr_cov_pmp_road) 0.65)
			(f_ai_is_defeated sq_cov_pmp_road_elites0)
		)
	)
	
			; -------------------------------------------------
			(wake pmp_save_wave1_complete)
			(ai_place sq_cov_pmp_charlie_ds)
			;(ai_place sq_cov_pmp_alpha_ds)
			; -------------------------------------------------
	
	*;
	
	(sleep_until (= b_pmp_assault_complete true))
	
	
			; -------------------------------------------------
			(if debug (print "::: pumpstation ::: assault complete..."))
			(ai_kill_silent gr_cov_pmp_assault)
			
			(mus_stop mus_07)
			(pmp_postcombat_control)
			
			
			; -------------------------------------------------
)

(script dormant pmp_counterattack_control
	(sleep_until b_pmp_assault_start_dropships)
			(sleep 120)
			; -------------------------------------------------
			(wake md_pmp_jun_dropship_control)
			
			(set b_pmp_assault_started true)
			(pmp_wave_lake)
			(game_save)
			; -------------------------------------------------
			
	(sleep_until (pmp_wave_road_should_spawn))
	
			; -------------------------------------------------
			(if debug (print "spawning road"))
			(pmp_wave_road)
			(game_save)
			; -------------------------------------------------
			
	(sleep_until (pmp_wave_creek_should_spawn))
	
			; -------------------------------------------------
			(if debug (print "spawning creek"))
			(pmp_wave_creek)
			(game_save)
			; -------------------------------------------------
			
	(sleep_until (<= (ai_task_count obj_cov_pmp/gate_main) 0) 30 (* 30 600))
	(set b_pmp_assault_complete true)
	
)


; LAKE
; -------------------------------------------------------------------------------------------------
(script static void pmp_wave_lake
	(ai_place sq_cov_pmp_charlie_ds)
	(sleep_until (> (ai_living_count gr_cov_pmp_lake) 0))
)

(script static boolean pmp_wave_lake_should_spawn
	(= 1 1)
)

; ROAD
; -------------------------------------------------------------------------------------------------
(script static void pmp_wave_road
	(ai_place sq_cov_pmp_bravo_ds)
	(sleep_until (> (ai_living_count gr_cov_pmp_road) 0))
)

(script static boolean pmp_wave_road_should_spawn
	(and
		(> (ai_spawn_count gr_cov_pmp_lake) 0)
		(= b_pmp_charlie_delivered true)
		(or
			(and
				(< (ai_strength gr_cov_pmp_lake) 0.60)
				(<= (ai_living_count sq_cov_pmp_lake_elites0) 1)
			)
			
			(< (ai_strength gr_cov_pmp_lake) 0.35)
		)
			
	)
)

; CREEK
; -------------------------------------------------------------------------------------------------
(script static void pmp_wave_creek
	(ai_place sq_cov_pmp_alpha_ds)
	(sleep_until (> (ai_living_count gr_cov_pmp_creek) 0))
)


(script static boolean pmp_wave_creek_should_spawn
	(or
		(and
			(> (ai_spawn_count gr_cov_pmp_road) 0)
			(> (ai_spawn_count gr_cov_pmp_lake) 0)
			(< (ai_strength gr_cov_pmp_road) 0.50)
			(< (ai_strength gr_cov_pmp_lake) 0.50)
			(= b_pmp_bravo_delivered true)
		)
		(= 1 3) ; lol
	)
)




(script static void pmp_postcombat_control
	(branch
		(= b_rvr_started true) (pmp_postcombat_abort))
		
	(if (> (ai_living_count gr_militia) 0)
				
		; militia alive
		; -------------------------------------------------
		(begin
			(if debug (print "::: beginning postencounter convo WITH militia..."))
			
				(cs_run_command_script ai_jun cs_pmp_post_convo_jun)
				(cs_run_command_script sq_unsc_pmp_militia0/militia0 cs_pmp_post_convo_mil0)
				(cs_run_command_script sq_unsc_pmp_militia0/militia1 cs_pmp_post_convo_mil1)
				(cs_run_command_script sq_unsc_pmp_militia1/militia0 cs_pmp_post_convo_mil2)
				(cs_run_command_script sq_unsc_pmp_militia1/militia1 cs_pmp_post_convo_mil3)
	
			;(thespian_performance_setup_and_begin thespian_pmp_post "" 0)
			;(sleep_until b_pmp_post_convo_active 15 (* 30 20))
			(sleep (random_range (* 30 8) (* 30 10)))
			(wake md_pmp_jun_hydro_civs_alive)
			(sleep_until b_pmp_post_convo_completed (* 30 12))
			(wake pmp_exit_reminder)
			(print "post")
		)
		; -------------------------------------------------
		
		
		; militia dead
		; -------------------------------------------------
		(begin
			(if debug (print "::: beginning postencounter convo WITHOUT militia..."))
			(cs_run_command_script ai_jun cs_pmp_post_convo_jun_nomilitia)
			(sleep (random_range (* 30 3) (* 30 5)))
			(md_pmp_jun_hydro_civs_dead)
		)
		; -------------------------------------------------
	)
	
	(set b_pmp_post_convo_completed true)
	(set b_pmp_post_convo_active false)
			
	(wake show_objective_5)
	(mus_start mus_08)
	(game_save)
)

(script static void pmp_postcombat_abort
	(if debug (print "player has aborted the postcombat convo..."))
	(thespian_performance_kill_by_name thespian_pmp_post)
	(set b_pmp_post_convo_completed true)
	(set b_pmp_post_convo_active false)
	(md_stop)
	; bring ai forward
)

(script static boolean pmp_militia_should_hold_center
	(or
		(<= (ai_task_count obj_unsc_pmp/gate_defense_low) 2)
		
		(and
			(> (ai_task_count obj_cov_pmp/gate_lake) 0)
			(> (ai_task_count obj_cov_pmp/gate_road) 0))
	)
)

(script command_script cs_pmp_jun_canyon
	(cs_go_by pts_jun_pumpstation/p0_l pts_jun_pumpstation/p0_r)
	(cs_go_by pts_jun_pumpstation/p1_l pts_jun_pumpstation/p1_r)
	(cs_go_by pts_jun_pumpstation/p2_l pts_jun_pumpstation/p2_r)
	(cs_go_by pts_jun_pumpstation/p3_l pts_jun_pumpstation/p3_r)
	(cs_go_by pts_jun_pumpstation/p4_l pts_jun_pumpstation/p4_r)
	(cs_go_by pts_jun_pumpstation/p5_l pts_jun_pumpstation/p5_r)
	(cs_go_by pts_jun_pumpstation/p6_l pts_jun_pumpstation/p6_r)
	(cs_go_by pts_jun_pumpstation/p7_l pts_jun_pumpstation/p7_r)
)
			
(script static boolean pmp_militia_alive
	(> (ai_living_count sq_unsc_pmp_militia0) 0)
)


(global boolean b_pmp_start_dropship_delivered false)
(script command_script cs_pmp_phantom_start
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)
	
	(cs_fly_by pts_pmp_phantom_start/entry1)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_pmp_inf3 sq_cov_pmp_inf4 none none)
	
	(cs_fly_by pts_pmp_phantom_start/entry0)
	
	(cs_vehicle_speed 0.6)
	(cs_vehicle_boost 0)
	
	(cs_fly_to pts_pmp_phantom_start/hover)
	(sleep 45)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_pmp_phantom_start/land pts_pmp_phantom_start/land_facing 0.25)
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	(set b_pmp_start_dropship_delivered true)
	(sleep 30)
	
	(cs_fly_to_and_face pts_pmp_phantom_start/land pts_pmp_phantom_start/hover 0.25)
	(sleep 30)
	
	(cs_vehicle_speed 0.7)
	(cs_fly_by pts_pmp_phantom_start/exit0)
	(cs_fly_by pts_pmp_phantom_start/exit1)
	(cs_fly_by pts_pmp_phantom_start/erase)
	
	(ai_erase ai_current_squad)
	
)

; DROPSHIP ALPHA
; -------------------------------------------------------------------------------------------------
(script command_script cs_pmp_ds_alpha
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	
	(f_load_phantom (ai_vehicle_get ai_current_actor) "dual" ai_pmp_creek_00 ai_pmp_creek_01 ai_pmp_creek_02 ai_pmp_creek_03)
	
	(add_recycling_volume tv_030_recycle 30 60)
	(cs_fly_by pts_pmp_ds_alpha/entry2)
	(set b_pmp_alpha_enroute true)
	(cs_fly_by pts_pmp_ds_alpha/entry1)
	(set b_pmp_alpha_enroute true)
	(cs_fly_by pts_pmp_ds_alpha/entry0)
	(set s_pmp_assault_wave 1)
	(cs_vehicle_speed 0.4)
	(cs_vehicle_boost FALSE)
	(cs_fly_to pts_pmp_ds_alpha/hover)
	(cs_fly_to_and_face pts_pmp_ds_alpha/land pts_pmp_ds_alpha/land_facing 0.5)
	(sleep 30)
	
	
	;(ai_place pmp_cov_assault_inf3)
	;(ai_place pmp_cov_assault_inf4)
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
	(set b_pmp_alpha_delivered true)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_pmp_ds_alpha/hover pts_pmp_ds_alpha/exit0 1.0)
	(sleep 45)
	(cs_vehicle_speed 0.8)
	(cs_fly_by pts_pmp_ds_alpha/exit0)
	(cs_fly_by pts_pmp_ds_alpha/exit1)
	(cs_fly_by pts_pmp_ds_alpha/exit2)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_pmp_ds_alpha/erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

; bravo dropship
; -------------------------------------------------------------------------------------------------
(script command_script cs_pmp_ds_bravo
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)
	;(f_load_phantom (ai_vehicle_get ai_current_actor) "dual" ai_pmp_bravo_01 ai_pmp_bravo_02 ai_pmp_bravo_03 ai_pmp_bravo_04)
	(add_recycling_volume tv_030_recycle 30 60)
	(cs_fly_by pts_pmp_ds_bravo/entry2)
	(set b_pmp_bravo_enroute true)
	(cs_fly_by pts_pmp_ds_bravo/entry1)
	(cs_vehicle_speed 0.6)
	(cs_vehicle_boost FALSE)
	(cs_fly_by pts_pmp_ds_bravo/entry0)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "dual" ai_pmp_road_00 ai_pmp_road_01 ai_pmp_road_02 ai_pmp_road_03)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_pmp_ds_bravo/land pts_pmp_ds_bravo/land_facing 0.5)
	(sleep 30)
	
	;(ai_place pmp_cov_assault_inf2)
	;(ai_place pmp_cov_assault_inf0)
	;(ai_place pmp_cov_assault_inf1)
	
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
	;(ai_place sq_cov_pmp_road_grunts0)
	;(ai_place sq_cov_pmp_road_grunts1)
	;(ai_place sq_cov_pmp_road_elites0)
	
	(set b_pmp_bravo_delivered true)
	
	(cs_vehicle_speed 0.5)
	(cs_fly_to pts_pmp_ds_bravo/hover 1.0)
	(set s_pmp_assault_wave 2)
	(sleep 30)
	(cs_vehicle_speed 0.7)
	(cs_fly_by pts_pmp_ds_bravo/exit0)
	(cs_fly_by pts_pmp_ds_bravo/exit1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_pmp_ds_bravo/erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

; charlie dropship
; -------------------------------------------------------------------------------------------------
(script command_script cs_pmp_ds_charlie
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" ai_pmp_lake_00 ai_pmp_lake_01 ai_pmp_lake_02 ai_pmp_lake_03)

	(add_recycling_volume tv_030_recycle 30 60)
	(cs_fly_by pts_pmp_ds_charlie/entry3)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed 0.8)
	(cs_fly_by pts_pmp_ds_charlie/entry2)
	(set b_pmp_charlie_enroute true)
	(cs_fly_by pts_pmp_ds_charlie/entry1)
	(cs_vehicle_speed 0.6)
	(cs_vehicle_boost FALSE)
	
	;(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_pmp_lake_elites0 sq_cov_pmp_lake_specops0 sq_cov_pmp_lake_jackals0 none)
	
	
	(cs_fly_by pts_pmp_ds_charlie/entry0)
	(cs_vehicle_speed 0.3)
	(set s_pmp_assault_wave 3)
	(cs_fly_to_and_face pts_pmp_ds_charlie/land pts_pmp_ds_charlie/land_facing 0.2)
	(game_save)
	(sleep 30)
	
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	(set b_pmp_charlie_delivered true)

	(cs_vehicle_speed 0.2)
	(cs_fly_to_and_face pts_pmp_ds_charlie/hover pts_pmp_ds_charlie/exit0 0.25)
	(sleep 10)
	(cs_vehicle_speed 0.5)
	(cs_fly_by pts_pmp_ds_charlie/exit0)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_pmp_ds_charlie/exit1)
	(cs_fly_by pts_pmp_ds_charlie/erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)


; MISC & TESTING
; -------------------------------------------------------------------------------------------------
(script static void pmp_ai_test
	(garbage_collect_unsafe)
	(object_create_folder sc_pmp)
	(object_create_folder cr_pmp)
	
	(wake pmp_militia_renew)
	
	(ai_place sq_cov_pmp_bravo_ds)
	(ai_place sq_unsc_pmp_militia0)
	(ai_place sq_unsc_pmp_militia1)
	(ai_place sq_unsc_pmp_militia2)
	
	(sleep_until (> (ai_living_count gr_cov_pmp_road) 0))
	(sleep_until (< (ai_strength gr_cov_pmp_road) 0.3))
	
	(wake pmp_save_wave1_complete)
	(ai_place sq_cov_pmp_charlie_ds)
	
	(sleep_until (> (ai_living_count gr_cov_pmp_lake) 0))
	(sleep_until (< (ai_strength gr_cov_pmp) 0.3))
	
	(wake pmp_save_wave2_complete)
	(ai_place sq_cov_pmp_alpha_ds)
	
)

(script dormant pmp_save_wave1_complete
	(game_save_no_timeout))
	
(script dormant pmp_save_wave2_complete
	(game_save_no_timeout))
	
(script dormant pmp_save_wave3_complete
	(game_save_no_timeout))
	
(script static void pmp_props
	(object_create_folder sc_pmp)
	(object_create_folder cr_pmp)
)

(script dormant pmp_exit_reminder
	(branch 
		(= b_rvr_started true) (branch_abort_pmp_exit_reminder)
	)
	
	(sleep (* 30 120))
	
	(if (not b_rvr_started) 
		(f_blip_flag fl_rvr_entrance 21))
)

(script static void branch_abort_pmp_exit_reminder
	(f_unblip_flag fl_rvr_entrance)
)

; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void pmp_cleanup
	(if debug (print "cleaning up the pumpstation encounter..."))
	(ai_erase gr_cov_pmp)
	(object_destroy_folder wp_pmp)
	(object_destroy_folder cr_pmp)
	(object_destroy_folder dm_pmp)
	(object_destroy_folder c_pmp)
	(object_destroy_folder sc_pmp)
	(sleep_forever pmp_encounter)
	
	(pmp_bird_kill)
	(f_unblip_object dm_pmp_stash0)
	(f_unblip_object dm_pmp_stash1)
)


; =================================================================================================
; RIVER
; =================================================================================================
(script dormant rvr_encounter
	;(sleep_until (volume_test_players tv_alley_start) 1)
	(if debug (print "::: river ::: encounter start"))
	
	; set fourth mission segment
	(data_mine_set_mission_segment "m30_04_rvr_encounter")
	(soft_ceiling_enable camera_blocker_05 0)
	
	(game_save)
	(recycle_030)
	
	(if (difficulty_is_legendary)
		(object_create loki))
	
	; place ai
	;(ai_place gr_cov_rvr)
	
	; wake subsequent scripts
	(wake rvr_jun_main)
	(wake rvr_militia_main)
	(wake rvr_phantom_control)
	
	(ai_place sq_amb_rvr_moas)
	(sleep 1)
	(ai_disregard (ai_actors sq_amb_rvr_moas) true)
	
	;(wake rvr_save_after_specops)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_rvr_started true)
	; -------------------------------------------------------------------------------------------------
			
			; -------------------------------------------------
			;(ai_kill_silent sq_unsc_pmp_militia0)
			(ai_disposable sq_amb_pmp_moas0 true)
			(f_unblip_ai sq_unsc_pmp_militia0)
			(f_unblip_ai sq_unsc_pmp_militia1)
			(f_unblip_flag fl_rvr_entrance)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_rvr_010) 1)
	(if debug (print "::: river objective control 010"))
	(set s_objcon_rvr 10)
	
			; -------------------------------------------------
			(f_unblip_flag fl_rvr_entrance) ; only way to be sure
			(wake md_rvr_jun_settlement_history)
			; -------------------------------------------------
		
	(sleep_until (volume_test_players tv_objcon_rvr_020) 1)
	(if debug (print "::: river objective control 020"))
	(set s_objcon_rvr 20)
	
			; -------------------------------------------------
			(garbage_collect_now)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_rvr_030) 1)
	(if debug (print "::: river objective control 030"))
	(set s_objcon_rvr 30)
	
			; -------------------------------------------------
			
			(if (not b_pmp_assault_complete)
				(begin
					(set b_pmp_player_skips_encounter true)
					(object_teleport (ai_get_object ai_jun) fl_rvr_jun_teleport)
					(f_unblip_ai gr_militia)
				)
			)
			(ai_bring_forward (ai_get_object ai_jun) 15)	
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_rvr_040) 1)
	(if debug (print "::: river objective control 040"))
	(set s_objcon_rvr 40)
	
	(sleep_until (volume_test_players tv_objcon_rvr_050) 1)
	(if debug (print "::: river objective control 050"))
	(set s_objcon_rvr 50)
	
			; -------------------------------------------------
			
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_rvr_060) 1)
	(if debug (print "::: river objective control 060"))
	(set s_objcon_rvr 60)
	
			; -------------------------------------------------
			(ai_bring_forward (ai_get_object gr_militia) 10)
			(ai_bring_forward (ai_get_object ai_jun) 6)
			(game_save)
			; -------------------------------------------------
		
	; cleanup
	(sleep_until b_set_completed)
	(rvr_cleanup)
)


; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant rvr_jun_main
	(if debug (print "::: river ::: setting up unsc_jun..."))

	(set ai_jun unsc_jun)
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_rvr)
)

(script dormant rvr_militia_main
	; only bring the militia forward if they complete the encounter
	(if b_pmp_assault_complete
		(begin
			(if debug (print "::: river ::: setting up unsc_militia..."))
			(ai_set_objective gr_militia obj_unsc_rvr)
			(ai_set_objective fireteam_player0 obj_unsc_rvr)		
		)
	)
)


; MISC & TESTING
; -------------------------------------------------------------------------------------------------
(script dormant rvr_save_after_specops
	(sleep_until (f_ai_is_defeated sq_cov_rvr_specops0))
	(game_save)
)

(script command_script cs_rvr_moas_flee
	(begin_random_count 1
		(cs_go_by pts_rvr_moas/p0_a pts_rvr_moas/p0_a)
		(cs_go_by pts_rvr_moas/p0_b pts_rvr_moas/p0_b)
		(cs_go_by pts_rvr_moas/p0_c pts_rvr_moas/p0_c))
		
	(begin_random_count 1
		(cs_go_by pts_rvr_moas/p1_a pts_rvr_moas/p1_a)
		(cs_go_by pts_rvr_moas/p1_b pts_rvr_moas/p1_b)
		(cs_go_by pts_rvr_moas/p1_c pts_rvr_moas/p1_c))
		
	(begin_random_count 1
		(cs_go_by pts_rvr_moas/p2_a pts_rvr_moas/p2_a)
		(cs_go_by pts_rvr_moas/p2_b pts_rvr_moas/p2_b)
		(cs_go_by pts_rvr_moas/p2_c pts_rvr_moas/p2_c))
)

(script command_script cs_rvr_phantom
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_rvr_phantom0/p1)
	(cs_fly_by ps_rvr_phantom0/p2)
	(cs_fly_by ps_rvr_phantom0/p3)
	(cs_fly_by ps_rvr_phantom0/p4)
	
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	(cs_fly_by ps_rvr_phantom0/erase)
	
	(ai_erase ai_current_squad)
)

(script dormant rvr_phantom_control
	(sleep_until (>= s_objcon_rvr 30))
	(ai_place sq_cov_rvr_phantom0)
	(wake md_jun_dropship_overhead_1)
	
	(sleep 30)
	

)

; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void rvr_cleanup
	(if debug (print "::: river ::: cleaning up the encounter..."))
	
	(ai_disposable gr_cov_river true)
	(ai_disposable sq_amb_pmp_moas0 true)
	(sleep_forever rvr_encounter)
)


; =================================================================================================
; SETTLEMENT
; =================================================================================================
(global boolean b_set_defense_start false)
(global boolean b_set_gate_convo_started false)
(global boolean b_set_gate_open false)
(global boolean b_set_gate_convo_over false)
(global boolean b_set_unsc_advance false)
(global boolean b_set_bridge_should_flank false)
(global boolean b_set_player_front false)
(global short s_set_wave 0)
; -------------------------------------------------------------------------------------------------
(script dormant set_encounter
	;(sleep_until (volume_test_players tv_settlement_start) 1)
	(if debug (print "::: settlement ::: encounter start"))
	
	; set fifth mission segment
	(data_mine_set_mission_segment "m30_05_set_encounter")
	(garbage_collect_now)

	; object management
	(object_create_folder cr_set)
	(object_create_folder wp_set)
	(object_create_folder sc_set)
	;(object_create_folder bp_set)
	(object_create_folder v_set)
	(object_create_folder eq_set)
	
	(set ai_to_deafen gr_cov_set)

	; wake scripts
	(wake set_militia_main)
	(wake set_unsc_jun)
	(wake set_assault)
	(wake set_defense)
	(wake set_bridge_flank_control)
	
	;(wake zone_setup_post_settlement)
	
	(wake md_set_jun_kat_you_seeing)
	
	(wake set_save_bridge)
	(wake set_save_hill_dead)
	(wake set_save_initial_dead)
	(wake set_save_left)
		
	(set_pose_bodies)
	; music control
	;(wake music_control_05_start)
	;(wake music_control_05_stop)
	;(wake music_control_06_start)
	
	; place ai
	(sleep_until (= (current_zone_set_fully_active) 5))
	
	(ai_place sq_cov_set_pylon_gunners0)
	(ai_place sq_cov_set_officer0)
	(ai_place sq_cov_set_left_grunts0)
	(ai_place sq_cov_set_left_grunts1)
	(ai_place sq_cov_set_skirmishers0)
	(ai_place sq_cov_set_bridge_elite0)
	(ai_place sq_cov_set_bridge_grunts0)
	(ai_place sq_cov_set_hill0)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_set_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			;(game_save)
			(game_insertion_point_unlock 2)
			(ai_disposable sq_amb_rvr_moas true)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_set_005) 1)
	(if debug (print "::: settlement ::: objective control 005"))
	(set s_objcon_set 5)	
	(soft_ceiling_enable camera_blocker_06 0)
	
			; -------------------------------------------------
			(wake chapter_title_settlement)
			
			(bring_jun_forward 15)
			; -------------------------------------------------
		
	(sleep_until (volume_test_players tv_objcon_set_010) 1)
	(if debug (print "::: settlement ::: objective control 010"))
	(set s_objcon_set 10)	
	
			; -------------------------------------------------
			(if (not (difficulty_is_legendary))
				(thespian_performance_setup_and_begin thespian_set_elites "" 0))
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_set_012) 1)
	(if debug (print "::: settlement ::: objective control 012"))
	(set s_objcon_set 12)	
	
			
	
	(sleep_until (volume_test_players tv_objcon_set_015) 1)
	(if debug (print "::: settlement ::: objective control 015"))
	(set s_objcon_set 15)	
	
	(sleep_until (volume_test_players tv_objcon_set_018) 1)
	(if debug (print "::: settlement ::: objective control 018"))
	(set s_objcon_set 18)	
	
	(sleep_until (volume_test_players tv_objcon_set_020) 1)
	(if debug (print "::: settlement ::: objective control 020"))
	(set s_objcon_set 20)	
	
	(sleep_until (volume_test_players tv_objcon_set_030) 1)
	(if debug (print "::: settlement ::: objective control 030"))
	(set s_objcon_set 30)	
	
	(sleep_until (volume_test_players tv_objcon_set_040) 1)
	(if debug (print "::: settlement ::: objective control 040"))
	(set s_objcon_set 40)	
	
	; cleanup
	(sleep_until b_clf_started)
	(set_cleanup)
)

; SAVES
; -------------------------------------------------------------------------------------------------
(script dormant set_save_bridge
	(branch
		(= b_clf_started true) (branch_abort)
	)
	
	(sleep_until (>= s_objcon_set 40))
	
	(if debug (print "saving crossing bridge"))
	(game_save_no_timeout)
)

(script dormant set_save_hill_dead
	(branch
		(= b_clf_started true) (branch_abort)
	)
	
	(sleep_until (> (ai_spawn_count sq_cov_set_hill0) 0))
	(sleep_until (<= (ai_living_count sq_cov_set_hill0) 0))
	
	(if debug (print "saving hill"))
	(game_save_no_timeout)
)

(script dormant set_save_initial_dead
	(branch
		(= b_clf_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			(<= (ai_living_count sq_cov_set_hill0) 0)
			(<= (ai_living_count sq_cov_set_pylon_gunners0) 0)
			(<= (ai_living_count sq_cov_set_officer0) 0)
			(<= (ai_living_count sq_cov_set_left_grunts0) 0)
			(<= (ai_living_count sq_cov_set_left_grunts1) 0)
			(<= (ai_living_count sq_cov_set_skirmishers0) 0)
			(<= (ai_living_count sq_cov_set_bridge_elite0) 0)
			(<= (ai_living_count sq_cov_set_bridge_grunts0) 0)
			(<= (ai_living_count sq_cov_set_hill0) 0)	
		)
	)
	
	(if debug (print "saving initial_dead"))
	(game_save_no_timeout)
)

(script dormant set_save_left
	(branch
		(= b_clf_started true) (branch_abort)
	)
	
	(sleep_until 
		(and
			(<= (ai_living_count sq_cov_set_officer0) 0)
			(<= (ai_living_count sq_cov_set_left_grunts0) 0)
			(<= (ai_living_count sq_cov_set_left_grunts1) 0)
		)
	)
	
	(if debug (print "saving left dead"))
	(game_save_no_timeout)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant set_militia_main
	(if debug (print "::: settlement ::: setting up unsc_militia..."))

	(ai_set_objective gr_militia obj_unsc_set)
	(ai_set_objective fireteam_player0 obj_unsc_set)
	
)

(script dormant set_unsc_jun
	(if debug (print "::: settlement ::: setting up unsc_jun"))

	(set ai_jun unsc_jun)
	(ai_set_objective unsc_jun obj_unsc_set)
	(ai_cannot_die unsc_jun true)
)


; AMBIENT
; -------------------------------------------------------------------------------------------------


(script static void set_pose_bodies
	(pose_body sc_set_body_00 pose_against_wall_var1)
	(pose_body sc_set_body_01 pose_face_down_var1)
	(pose_body sc_set_body_02 pose_on_back_var3)
	(pose_body sc_set_body_03 pose_against_wall_var3)
	(pose_body sc_set_body_04 pose_on_side_var3)
	(pose_body sc_set_body_05 pose_on_side_var5)
	(pose_body sc_set_body_06 pose_against_wall_var2)
	(pose_body sc_set_body_07 pose_face_down_var2)
	(pose_body sc_set_body_08 pose_on_side_var2)
	(pose_body sc_set_body_09 pose_on_back_var1)
	(pose_body sc_set_body_10 pose_against_wall_var4)
	(pose_body sc_set_body_11 pose_face_down_var3)
)

(script command_script cs_set_bridge_patrol
	(cs_push_stance patrol)
	(cs_abort_on_alert 1)
	(cs_abort_on_damage 1)
	(cs_walk 1)
	(cs_stow true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to pts_settlement_patrols/p15)
					(sleep (random_range 160 450))
				)
				(begin
					(cs_go_to pts_settlement_patrols/p16)
					(sleep (random_range 160 450))
				)
				(begin
					(cs_go_to pts_settlement_patrols/p17)
					(sleep (random_range 160 450))
				)
			)
		0)
	1)
)


; COMBAT
; -------------------------------------------------------------------------------------------------
(script dormant set_bridge_flank_control
	(sleep_until (> (ai_combat_status gr_cov_set) 3) 1)
	(sleep_until (>= s_objcon_set 20) 30 (* 30 25))
	
	(if (>= (ai_living_count gr_cov_set_bridge) 2)
		(set b_set_bridge_should_flank true))
)

(script dormant set_assault
	(if debug (print "::: settlement ::: starting assault..."))	
	(sleep_until (> (ai_task_count obj_cov_set/gate_main) 0))
	
	(sleep_until (< (ai_strength gr_cov_set) 0.35))
		
			(game_save)
			(set b_set_player_front true)
	
	(sleep_until (< (ai_strength gr_cov_set) 0.1))
	;(sleep_until (and (< (ai_task_count obj_cov_set/gate_main) 3) (f_ai_is_defeated sq_cov_set_hunters)))
	;(sleep_until (< (ai_task_count obj_cov_set/gate_main) 3))
	;(sleep_until (= (ai_task_count obj_cov_set/gate_main) 0) 30 (* 30 60))
	
	;(ai_disposable gr_cov_set_bridge true)
	;(ai_disposable gr_cov_set_front true)
	;(ai_disposable gr_cov_set_reargunners true)
	;(ai_disposable gr_cov_set_ring true)
	
	
	
	(set b_set_defense_start true)
	
	(add_recycling_volume_by_type tv_040_recycle 4 45 1)
)

(global boolean b_set_second_dropship false)
(script dormant set_defense
	(sleep_until b_set_defense_start)
	(if debug (print "::: settlement ::: starting defense..."))
	
	
	;(set_teleport_jun)
	
	(md_set_jun_cover_me)
	(game_save)
	(sleep 30)

	
	(f_blip_flag fl_set_defend blip_defend)
	
	;*
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_set)
	
	(ai_place sq_cov_set_phantom0)
	*;
	(cs_run_command_script ai_jun cs_set_jun_go_to_plant)
	(thespian_performance_setup_and_begin p120_set_jun_plant "" 0)
	(sleep (random_range 150 300))
	(ai_place sq_cov_set_phantom0)
	
	(if 
		(or
			(game_is_cooperative)
			(difficulty_is_heroic_or_higher)
		)
			(begin
				(set b_set_second_dropship true)
				(ai_place sq_cov_set_ds1)
			)
	)
	
	;(sleep_until (> (ai_living_count gr_cov_set_reinforce) 0))
	(sleep 1)
	;(sleep_until (<= (ai_living_count gr_cov_set) 3))
	
	; wait for the hunters
	(sleep_until b_set_hunters_delivered)
	
	; if the second dropship is inbound, wait for the specops to spawn
	(if b_set_second_dropship
		(sleep_until (> (ai_spawn_count gr_cov_set_specops) 0)))
	
	
	(sleep 60)
	;(sleep_until (<= (ai_living_count sq_cov_set_hunters0) 0))
	
	
	(sleep_until (<= (ai_living_count gr_cov_set) 0) 30 (* 30 360))
	
	(f_unblip_flag fl_set_defend)
	(thespian_performance_kill_by_name p120_set_jun_plant)
	
	
	
	(sleep 120)
	(md_set_jun_charge_placed)
	
	(set b_set_completed true)
	(set b_set_gate_open true)
	
)

(script command_script cs_set_jun_go_to_plant
	(cs_go_to pts_p120/plant_start)
)

; DROPSHIP
; -------------------------------------------------------------------------------------------------
(global boolean b_set_hunters_delivered false)
(script command_script cs_cov_set_ds0
	(cs_ignore_obstacles 1)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(cs_vehicle_boost true)
	(cs_vehicle_speed 1)
	
		(cs_fly_by pts_set_ds0/entry1)
		
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.8)
	
		(cs_fly_by pts_set_ds0/entry0)
	
	(cs_vehicle_speed 0.4)
	
	(f_load_phantom (ai_vehicle_get ai_current_actor) "left" sq_cov_set_hunters0/hunter0 sq_cov_set_hunters1/hunter0 NONE NONE)
	
	
		;(cs_fly_to_and_face pts_set_ds0/hover pts_set_ds0/land_facing 0.25)
		(cs_fly_to pts_set_ds0/hover 0.25)
		
	(sleep 30)
	(cs_vehicle_speed 0.25)
	
		(cs_fly_to_and_face pts_set_ds0/land pts_set_ds0/land_facing 0.25)
		
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "left")
	(set b_set_hunters_delivered true)
	(sleep 60)
	(cs_vehicle_speed 0.4)
	
		(cs_fly_to_and_face pts_set_ds0/hover pts_set_ds0/exit0 0.25)
	
	(sleep 30)
	(cs_vehicle_speed 0.6)
	
		(cs_fly_by pts_set_ds0/exit0)
		
	(cs_vehicle_speed 1)
	
		(cs_fly_by pts_set_ds0/exit1)
		
		(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 7))
		(cs_fly_by pts_set_ds0/erase)
		
	(ai_erase ai_current_squad)
	
)


(script command_script cs_cov_set_ds1
	(if debug (print "phantom2 payload en route..."))
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles 1)
	
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(if (game_is_cooperative)
		(begin
			(if debug (print "dropping full squad of specops"))
			(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_set_specops0 sq_cov_set_specops1 NONE NONE)
		)
	
		(begin
			(if debug (print "dropping half squad of specops"))
			(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_cov_set_specops0 NONE NONE NONE)
		)
	)
	
	
	
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.8)
	(cs_fly_by ps_set_ds1/entry2)
	(cs_vehicle_speed 0.6)
	(cs_fly_by ps_set_ds1/entry1)
	(cs_vehicle_speed 0.5)
	(cs_fly_by ps_set_ds1/entry0)
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.4)
	
	
	;(cs_fly_to_and_face ps_set_ds1/harass ps_set_ds1/tower 0.1)
	
	;(wake md_set_jun_dropship_callout_3)
	
	;(sleep_until (volume_test_players tv_set_ds1_land) 30 (* 30 60))
	;(ai_place sq_cov_set_hunters0)
	;(sleep (random_range 30 90))
	
	(cs_fly_to ps_set_ds1/hover 0.25)
	(sleep 30)
	
	(cs_fly_to_and_face ps_set_ds1/land ps_set_ds1/land_facing 0.25)
			
	;(sleep 90)
	
			; -------------------------------------------------
			;(wake md_set_jun_still_working_3)
			; -------------------------------------------------
			
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	;(ai_place sq_cov_set_reinforce_skirm0)
	(sleep 30)
	
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_set_ds1/hover ps_set_ds1/land_facing 0.25)
	(sleep 30)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_set_ds1/exit0)
	(cs_fly_by ps_set_ds1/exit1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	(cs_fly_by ps_set_ds1/erase)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)	


; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void set_cleanup
	(if debug (print "::: settlement ::: cleaning up the encounter..."))
	(ai_disposable gr_cov_set true)
	(sleep_forever set_encounter)
)

(script static void set_teleport_jun
	(ai_teleport unsc_jun pts_settlement_teleports/jun)
	;(ai_teleport unsc_militia pts_settlement_teleports/marine0)
)



; =================================================================================================
; CLIFFSIDE
; =================================================================================================
(global boolean b_clf_gate_opened false)
(global boolean b_cliffside_road_dropoff false)
(global boolean b_cliffside_banshees_overhead false)
; -------------------------------------------------------------------------------------------------
(script dormant clf_encounter
	;(sleep_until (volume_test_players tv_cliffside_start) 1)
	(if debug (print "::: cliffside encounter :::"))
	
	; set sixth mission segment
	(data_mine_set_mission_segment "m30_06_clf_encounter")
	
	(game_save)
	(garbage_collect_now)
	
	
	; object management
	(object_create_folder cr_clf)
	(object_create_folder sc_clf)
	(object_create_folder wp_clf)
	;(object_create_folder bp_clf)
	(object_create_folder c_clf)
	(object_create_folder dm_clf)
	(object_create_folder eq_clf)
	
	(object_destroy_folder cr_rvr_flares)
	
	; place ai
	;(sleep_until (= (current_zone_set_fully_active) 6))
	
	
	
	; flocks
	;(flock_create staging_banshees_large_a)
	;(flock_create staging_banshees_large_b)
	;(flock_create staging_phantoms_landing_a)
	(object_create_folder sc_staging)
	
	; wake subsequent scripts
	(wake clf_jun_main)
	(wake clf_militia_main)
	(wake clf_banshee_flock_control)
	(wake clf_gate_sequence)
		
	; music control
	(wake clf_music_control)
	
	(wake save_clf_road_defeated)
	(wake save_clf_center_defeated)
	(wake save_clf_nest_defeated)
	(wake save_clf_final_defeated)
	(wake save_clf_objcon_050)
	
	(wake clf_garbage_loop)

	(clf_pose_bodies)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_clf_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(ai_place sq_cov_clf_road_ds0)
			(ai_set_objective gr_militia obj_unsc_clf)
			(ai_set_objective unsc_jun obj_unsc_clf)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_clf_010) 1)
	(if debug (print "::: cliffside ::: objective control 010"))
	(set s_objcon_clf 10)
	
			; -------------------------------------------------
			;(game_save_no_timeout)
			; -------------------------------------------------

	(sleep_until (volume_test_players tv_objcon_clf_020) 1)
	(if debug (print "::: cliffside ::: objective control 020"))
	(set s_objcon_clf 20)
	
			; -------------------------------------------------
			(garbage_collect_now)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_030) 1)
	(if debug (print "::: cliffside ::: objective control 030"))
	(set s_objcon_clf 30)
			
			; -------------------------------------------------
			(ai_place sq_cov_clf_center_rocks0)
			(ai_place sq_cov_clf_center_shade0)
			(ai_place sq_cov_clf_center_inf0)
			; -------------------------------------------------
			
		(soft_ceiling_enable camera_blocker_07 0)			
	
	(sleep_until (volume_test_players tv_objcon_clf_040) 1)
	(if debug (print "::: cliffside ::: objective control 040"))
	(set s_objcon_clf 40)
	
	(sleep_until (volume_test_players tv_objcon_clf_050) 1)
	(if debug (print "::: cliffside ::: objective control 050"))
	(set s_objcon_clf 50)
			
			; -------------------------------------------------
			;(game_save_no_timeout)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_060) 1)
	(if debug (print "::: cliffside ::: objective control 060"))
	(set s_objcon_clf 60)
	
	(sleep_until (volume_test_players tv_objcon_clf_070) 1)
	(if debug (print "::: cliffside ::: objective control 070"))
	(set s_objcon_clf 70)
	
	(sleep_until (volume_test_players tv_objcon_clf_080) 1)
	(if debug (print "::: cliffside ::: objective control 080"))
	(set s_objcon_clf 80)
	
			; -------------------------------------------------
			(wake md_clf_jun_shade)
			; -------------------------------------------------
		
	(sleep_until (volume_test_players tv_objcon_clf_090) 1)
	(if debug (print "::: cliffside ::: objective control 090"))
	(set s_objcon_clf 90)
	
			; -------------------------------------------------
			(add_recycling_volume_by_type tv_045_recycle 5 15 1)
			(wake md_clf_jun_lotta_air_traffic)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_100) 1)
	(if debug (print "::: cliffside ::: objective control 100"))
	(set s_objcon_clf 100)
			
			; -------------------------------------------------
			(wake clf_mus11_stop)
			(ai_place gr_cov_clf_final)
			(ai_place sq_cov_clf_nest_elite0)
			(ai_place sq_cov_clf_nest_elite1)
			(ai_place sq_cov_clf_nest_jackals0)
			(ai_place sq_cov_clf_nest_shade0)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_110) 1)
	(if debug (print "::: cliffside ::: objective control 110"))
	(set s_objcon_clf 110)
	
			; -------------------------------------------------
			(if (game_is_cooperative)
				(begin
					(ai_place sq_cov_clf_jetpacks0)
				)
				
				(begin
					(if (difficulty_is_heroic)
						(ai_place sq_cov_clf_jetpacks0 1))
						
					(if (difficulty_is_legendary)
						(ai_place sq_cov_clf_jetpacks0 2))
				)
			)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_120) 1)
	(if debug (print "::: cliffside ::: objective control 120"))
	(set s_objcon_clf 120)
	
	(sleep_until (volume_test_players tv_objcon_clf_130) 1)
	(if debug (print "::: cliffside ::: objective control 130"))
	(set s_objcon_clf 130)
	
			; -------------------------------------------------
			
			(ai_place sq_cov_clf_overlook_inf0)
			(ai_place sq_cov_clf_overlook_inf1)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_clf_140) 1)
	(if debug (print "::: cliffside ::: objective control 140"))
	(set s_objcon_clf 140)
	
			; -------------------------------------------------
			(mus_stop mus_11)
			(wake md_clf_jun_eyes_on_capital_ship)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_clf_145) 1)
	(if debug (print "::: cliffside ::: objective control 145"))
	(set s_objcon_clf 145)
	
			; -------------------------------------------------
			;(mus_stop mus_11)
			(mus_start mus_12)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_clf_150) 1)
	(if debug (print "::: cliffside ::: objective control 150"))
	(set s_objcon_clf 150)
	
			; -------------------------------------------------
			(wake clf_exit_helper)
			; -------------------------------------------------
	
	; cleanup
	(sleep_until b_mission_complete)
	(clf_cleanup)
)

(script dormant clf_garbage_loop
	
	(sleep_until
		(begin
			(add_recycling_volume tv_045_recycle 10 45)
			(sleep (* 30 60))
		0)
	1)
)

(script dormant clf_mus11_stop

	(sleep_until (> (ai_spawn_count gr_cov_clf_final) 0))
	(sleep 30)
	
	(sleep_until (<= (ai_strength gr_cov_clf_final) 0.35))
	(if debug (print "stopping mus 11"))
	(mus_stop mus_11)
)
; SAVE
; -------------------------------------------------------------------------------------------------
(script dormant save_clf_center_defeated
	(sleep_until (> (ai_spawn_count gr_cov_clf_center) 0))
	(sleep_until (<= (ai_living_count gr_cov_clf_center) 0))
	
	(game_save_no_timeout)
)

(script dormant save_clf_road_defeated
	(sleep_until (> (ai_spawn_count sq_cov_clf_road_inf0) 0))
	(sleep_until (<= (ai_living_count sq_cov_clf_road_inf0) 0))
	
	(game_save_no_timeout)
)

(script dormant save_clf_nest_defeated
	(sleep_until (> (ai_spawn_count gr_cov_clf_nest) 0))
	(sleep_until (<= (ai_living_count gr_cov_clf_nest) 0))
	
	(game_save_no_timeout)
)

(script dormant save_clf_final_defeated
	(sleep_until (> (ai_spawn_count gr_cov_clf_final) 0))
	(sleep_until (<= (ai_living_count gr_cov_clf_final) 0))
	
	(game_save_no_timeout)
)

(script dormant save_clf_objcon_050
	(sleep_until (>= s_objcon_clf 50))
	(game_save_no_timeout)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant clf_jun_main
	(if debug (print "::: cliffside ::: setting up unsc_jun..."))

	(set ai_jun unsc_jun)
	(ai_cannot_die unsc_jun true)
	(ai_set_objective unsc_jun obj_unsc_clf)
)

(script dormant clf_militia_main
	(if debug (print "::: cliffside ::: setting up unsc_militia..."))

	(ai_set_objective gr_militia obj_unsc_clf)
	(ai_set_objective fireteam_player0 obj_unsc_clf)
)


; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant clf_gate_sequence
	(if debug (print "clf: opening gate..."))
	
	(md_clf_jun_gate)
	
	;(wake clf_gate_timeout)

	(sleep_until b_clf_gate_opened 30 (* 30 40))
	(f_unblip_flag fl_clf_gate)
	(switch_zone_set set_cliffside_035_040_045)

	(device_set_power gate 1)
	(device_set_position gate 1)
	
	(sleep_until (>= (current_zone_set_fully_active) s_zone_index_cliffside))
	(sleep 90)
	(game_save_no_timeout)
	

)

(script dormant clf_music_control
	(sleep_until (>= s_objcon_clf 130))
	(sleep_until (<= (ai_living_count gr_cov_clf) 0))
	
	(mus_stop mus_11)
)

(script static void clf_pose_bodies
	(pose_body sc_clf_body_00 pose_against_wall_var1)
	(pose_body sc_clf_body_01 pose_face_down_var1)
	(pose_body sc_clf_body_02 pose_against_wall_var4)
	(pose_body sc_clf_body_03 pose_on_side_var3)
	(pose_body sc_clf_body_04 pose_on_side_var3)
	(pose_body sc_clf_body_05 pose_on_side_var5)
	(pose_body sc_clf_body_06 pose_against_wall_var2)
	(pose_body sc_clf_body_07 pose_on_side_var1)
	(pose_body sc_clf_body_08 pose_on_side_var2)
	(pose_body sc_clf_body_09 pose_on_back_var1)
	(pose_body sc_clf_body_10 pose_against_wall_var4)
	(pose_body sc_clf_body_11 pose_face_down_var3)
	(pose_body sc_clf_body_12 pose_face_down_var3)

)

(script static void branch_kill_vignette
	(if debug (print "killing vignette..."))
)


(script dormant clf_banshee_flock_control
	(sleep_until (>= s_objcon_clf 70))
	;(flock_create cliffside_banshees_flyby)
	(set b_cliffside_banshees_overhead true)
)

(script dormant clf_exit_helper
	(sleep_until (not (volume_test_players tv_clf_exit_helper)))
	
	(md_clf_jun_cave_ahead)
	
	(f_blip_flag fl_clf_exit blip_destination)
)

(script dormant clf_airtraffic_control
	(branch	
		(= b_mission_complete true) (branch_abort)
	)
	
	(sleep_until
		(begin
			(if (<= (ai_living_count sq_cov_clf_airtraffic0) 6)
				(ai_place sq_cov_clf_airtraffic0)
			)
			(sleep (random_range 60 90))
		0)
	1)
)

(script command_script cs_fkv_airtraffic0
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	(object_ignores_emp (ai_vehicle_get ai_current_actor) true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_clf_airtraffic/air0_0)
	(cs_fly_by ps_clf_airtraffic/air0_1)
	(cs_fly_by ps_clf_airtraffic/air0_erase)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_fkv_airtraffic1
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	(object_ignores_emp (ai_vehicle_get ai_current_actor) true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_clf_airtraffic/air1_0)
	(cs_fly_by ps_clf_airtraffic/air1_1)
	(cs_fly_by ps_clf_airtraffic/air1_erase)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_fkv_airtraffic2
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	(object_ignores_emp (ai_vehicle_get ai_current_actor) true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_clf_airtraffic/air2_0)
	(cs_fly_by ps_clf_airtraffic/air2_1)
	(cs_fly_by ps_clf_airtraffic/air2_erase)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)


(script command_script cs_fkv_airtraffic3
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	(object_ignores_emp (ai_vehicle_get ai_current_actor) true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_clf_airtraffic/air3_0)
	(cs_fly_by ps_clf_airtraffic/air3_1)
	(cs_fly_by ps_clf_airtraffic/air3_erase)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_fkv_airtraffic4
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	(object_ignores_emp (ai_vehicle_get ai_current_actor) true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
	
	(cs_fly_by ps_clf_airtraffic/air4_0)
	(cs_fly_by ps_clf_airtraffic/air4_1)
	(cs_fly_by ps_clf_airtraffic/air4_erase)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)


; COMBAT
; -------------------------------------------------------------------------------------------------
(script dormant clf_overlook_spawn 
	(sleep_until (>= s_objcon_clf 130))
	(if debug (print "spawning overlook crew..."))
	(ai_place sq_cov_clf_overlook_inf0)
	(ai_place sq_cov_clf_overlook_inf1)
)

(script dormant clf_skirmishers_spawn
	(sleep_until
		(or
			(and
				(f_ai_is_partially_defeated gr_cov_clf_mid 3)
				(<= s_objcon_clf 120)
			)
			(>= s_objcon_clf 130)
			(f_ai_is_partially_defeated gr_cov_clf_mid 1)
		)
	)
	
	(if debug (print "spawning skirmishers..."))	
	(ai_place sq_cov_clf_skirmishers)
	(sleep_until (f_ai_is_defeated sq_cov_clf_skirmishers))
	(game_save)
)


; DROPSHIP
; -------------------------------------------------------------------------------------------------
(script command_script cs_cliffside_road_ds0
	(cs_enable_pathfinding_failsafe TRUE)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(cs_vehicle_speed 0.5)
	(cs_ignore_obstacles 1)
	(cs_vehicle_boost FALSE)
	
	(f_load_phantom (ai_vehicle_get_from_starting_location sq_cov_clf_road_ds0/pilot) "left" sq_cov_clf_road_inf0 NONE NONE NONE)
	
	(sleep_until (> (device_get_position gate) 0))
	
			; -------------------------------------------------
			(cs_fly_to_and_face pts_cliffside_road_ds0/land pts_cliffside_road_ds0/land_facing 0.35)
			(wake md_clf_jun_phantom_too_close)
			
			(sleep 30)
			(f_unload_phantom (ai_vehicle_get_from_starting_location sq_cov_clf_road_ds0/pilot) "left")
			(set b_cliffside_road_dropoff true)
			
			(cs_fly_to_and_face pts_cliffside_road_ds0/hover pts_cliffside_road_ds0/land_facing)
			
			(sleep 60)
			
			(cs_fly_by pts_cliffside_road_ds0/exit0)
			(cs_fly_by pts_cliffside_road_ds0/exit1)
			(cs_vehicle_speed 1)
			(cs_vehicle_boost TRUE)
			(cs_fly_by pts_cliffside_road_ds0/erase)
			; -------------------------------------------------
	
	; Dropship is out of sight, now erase it
	(ai_erase ai_current_squad)
)

(script command_script cs_cliffside_overlook_ds0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 0.9)
	(cs_vehicle_boost FALSE)
	(f_load_phantom (ai_vehicle_get_from_starting_location sq_cov_clf_overlook_ds0/pilot) "left" sq_cov_clf_overlook_ds0_inf0 NONE NONE sq_cov_clf_overlook_ds0_inf1)
	(cs_fly_by pts_cliffside_overlook_ds0/entry1)
	(cs_fly_by pts_cliffside_overlook_ds0/entry0)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_cliffside_overlook_ds0/land pts_cliffside_overlook_ds0/land_facing 0.3)
	(sleep 30)
	(f_unload_phantom (ai_vehicle_get_from_starting_location sq_cov_clf_overlook_ds0/pilot) "left")
	(cs_fly_to_and_face pts_cliffside_overlook_ds0/hover pts_cliffside_overlook_ds0/land_facing)
	(sleep 60)
	
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	
	; Dropship is out of sight, now erase it
	(ai_erase ai_current_squad)
)


; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void clf_cleanup
	(if debug (print "cleaning up the cliffside encounter..."))
	(ai_erase gr_cov_clf)
	(sleep_forever clf_encounter)
)


; =================================================================================================
; HELPER SCRIPTS
; =================================================================================================
(script static void countdown
	(sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep"	NONE 1)
	(if debug (print "::: 3 :::"))
	(sleep 30)
	(sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep"	NONE 1)
	(if debug (print "::: 2 :::"))
	(sleep 30)
	(sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep"	NONE 1)
	(if debug (print "::: 1 :::"))
	(sleep 30)
	(sound_impulse_start "sound\game_sfx\multiplayer\countdown_timer"	NONE 1)
	(if debug (print "::: 0 :::")))

(script static void kill_script
	(if debug (print "*** SCRIPT HAS BEEN KILLED VIA BRANCH CONDITION ***")))
	
(script static void fireteam_setup
	;(sleep_until (> (player_count) 0))
		(if debug (print "::: global ::: setting up fireteams..."))
		(ai_player_add_fireteam_squad player0 fireteam_player0)
		(ai_player_set_fireteam_max player0 4)
		(ai_player_set_fireteam_max_squad_absorb_distance player0 6.0)
)

(script static boolean difficulty_is_heroic_or_higher
	(or
		(= (game_difficulty_get) heroic)
		(= (game_difficulty_get) legendary)
	)
)

(script static boolean difficulty_is_easy
	(=  (game_difficulty_get) easy)
)

(script static boolean difficulty_is_normal
	(= (game_difficulty_get) normal)
)

(script static boolean difficulty_is_heroic
	(= (game_difficulty_get) heroic)
)

(script static boolean difficulty_is_legendary
	(= (game_difficulty_get) legendary)
)

(script static boolean difficulty_is_easy_or_normal
	(or
		(= (game_difficulty_get) easy)
		(= (game_difficulty_get) normal)
	)
)

(script static void (bring_jun_forward (real dist))
	(ai_bring_forward (ai_get_object ai_jun) dist)
)

(script static void branch_abort 
	(if debug (print "branch aborting")))
	
(script static void show_staging
	(if debug (print "showing all staging area props..."))
	(object_create_folder sc_staging)
	;(object_create_folder v_staging)
	;(object_create_folder cr_staging)
)

(script static boolean player_has_sniper_rifle
	(unit_has_weapon (player0) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon"))

(script command_script cs_exit
	(if debug (print "cs_exit")))

(script command_script cs_disable_movement
	(cs_enable_moving FALSE))

(script command_script cs_drawweapon
	(cs_stow false))
	
(script command_script cs_abortactivity
	(ai_activity_abort ai_current_actor))
	
(script static boolean (ai_exists (ai group))
	(> (ai_living_count group) 0))
	
(script command_script cs_kill_silent
 	(ai_kill_silent ai_current_actor))

(script static void set_jun_invisible
	(if debug (print "jun is now invisible to AI"))
	(ai_disregard (ai_actors unsc_jun) TRUE)
	(ai_suppress_combat unsc_jun TRUE))

(script static void set_jun_visible
	(if debug (print "jun is now visible to AI"))
	(ai_disregard (ai_actors unsc_jun) FALSE)
	(ai_suppress_combat unsc_jun FALSE))

(script static boolean (ai_is_alert (ai actors))
	(> (ai_combat_status actors) 3))

(script static boolean angry_halo
	(ai_allegiance_broken human player))
	
(script static void tick
	(sleep 1))
	
(global boolean b_evaluate false)
(script static void eval
	(if (= b_evaluate 0)
    	(begin
			(set ai_render_evaluations 1)
			(set ai_render_evaluations_detailed 1)
			(set ai_render_evaluations_text 1)
			(set ai_render_firing_position_statistics 1)
			(set ai_render_decisions 1)
			(set ai_render_behavior_stack 1)
			(set b_evaluate 1)
		)
        (begin
			(set ai_render_evaluations 0)
			(set ai_render_evaluations_detailed 0)
			(set ai_render_evaluations_text 0)
			(set ai_render_firing_position_statistics 0)
			(set ai_render_decisions 0)
			(set ai_render_behavior_stack 0)
			(set b_evaluate 0)
        )                              
	)
)

;*
(script startup jun_failsafe
	(sleep 30)
	
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count unsc_jun) 0))
			
			(cond
				; CLIFFSIDE			
				; -------------------------------------------------------------------------------------------------
				(
					(= b_clf_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to cliffside"))
								(ai_place unsc_jun/clf_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_clf)
							)
							; -------------------------------------------------
				)
				
				; SETTLEMENT
				; -------------------------------------------------------------------------------------------------
				(
					(= b_set_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to settlement"))
								(ai_place unsc_jun/set_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_set)
							)
							; -------------------------------------------------
				)
				
				; RIVER
				; -------------------------------------------------------------------------------------------------
				(
					(= b_rvr_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to river"))
								(ai_place unsc_jun/river)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_rvr)
							)
							; -------------------------------------------------
				)
				
				; PUMPSTATION
				; -------------------------------------------------------------------------------------------------
				(
					(= b_pmp_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to pumpstation"))
								(ai_place unsc_jun/pmp_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_pmp)
							)
							; -------------------------------------------------
				)
				
				; FIELDS
				; -------------------------------------------------------------------------------------------------
				(
					(= b_fld_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to fields"))
								(ai_place unsc_jun/fld_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_fld)
							)
							; -------------------------------------------------
				)
				
				; SILO
				; -------------------------------------------------------------------------------------------------
				(
					(= b_slo_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to silo"))
								(ai_place unsc_jun/slo_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_slo)
							)
							; -------------------------------------------------
				)
				
				; PUMPSTATION
				; -------------------------------------------------------------------------------------------------
				(
					(= b_pmp_started true)
							; -------------------------------------------------
							(begin
								(if debug (print "jun got unloaded, bringing him to pumpstation"))
								(ai_place unsc_jun/fkv_respawn)
								(sleep 1)
								(ai_set_objective unsc_jun obj_unsc_fkv)
							)
							; -------------------------------------------------
				)
			)
			
			; setup and invulnerability
			(set ai_jun unsc_jun)
			(ai_cannot_die ai_jun 1)
			
			; give him some breathing room
			(sleep 90)
		0)
	1)
)
*;

; =================================================================================================
; ZONE STATE MANAGEMENT
; =================================================================================================
(global short s_current_blocker_zone 0)
;*
(script continuous zone_blocker_control
	(sleep_until (!= s_current_blocker_zone (current_zone_set)) 1)
	
	(cond
		((= (current_zone_set) s_zone_index_river)
				(begin
					(object_create_folder sc_blockers_fields)
				)
		)
		
		((= (current_zone_set) s_zone_index_settlement)
				(begin
					(object_create_folder sc_blockers_pumpstation)
				)
		)
		
	)			
	(set s_current_blocker_zone (current_zone_set))

	
)
*;

(global short s_current_teleport_zone 0)
(script startup zone_control
	
	(if (not (> (game_coop_player_count) 1))
		(sleep_forever))
	
	; player has at least passed the first kiva and heads toward the fields encounter
	;*
	(sleep_until (>= (current_zone_set) s_zone_index_firstkiva) 1)
	(if (= (current_zone_set) s_zone_index_firstkiva)
		(begin
			(sleep_until (volume_test_players tv_teleport_fld) 1)
			(if debug (print "zone_teleport_control: bringing players forward to BSP 025..."))
			(volume_teleport_players_not_inside tv_teleport_fld_safezone fl_teleport_fld)
			(sleep 5)
			(object_create_folder sc_blockers_firstkiva)
		)
	)
	*;
	
	; player has at least reached the canyon
	(sleep_until (>= (current_zone_set) s_zone_index_canyon) 1)
	(if (= (current_zone_set) s_zone_index_canyon)
		(begin
			(wake zone_slo_regression_blocker)
			(zone_set_trigger_volume_enable zone_set:set_fields_010_020_025 false)
			(zone_set_trigger_volume_enable begin_zone_set:set_fields_010_020_025 false)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) s_zone_index_canyon) 1)
	(if (= (current_zone_set_fully_active) s_zone_index_canyon)
		(begin
			(if debug (print "zone_teleport_control: turning off canyon triggers..."))
			(zone_set_trigger_volume_enable begin_zone_set:set_canyon_020_025_028 false)
			(zone_set_trigger_volume_enable zone_set:set_canyon_020_025_028 false)
			
					; wait until players cross entrance to canyon
			(sleep_until (volume_test_players tv_teleport_can) 1)
			
				; -------------------------------------------------
				(if debug (print "zone_teleport_control: bringing players forward to canyon entrance..."))
				(volume_teleport_players_not_inside tv_teleport_can_safezone fl_teleport_can)	
				(sleep 1)		
				(object_create_folder sc_blockers_fld_entrance)
				; -------------------------------------------------
		)
	)
	
	
	
	; player has at least reached the canyon
	(sleep_until (>= (current_zone_set) s_zone_index_river) 1)
	(if (= (current_zone_set) s_zone_index_river)
		(begin
			(sleep_until (volume_test_players tv_teleport_rvr) 1)
			(if debug (print "zone_teleport_control: bringing players forward to pumpstation..."))
			(volume_teleport_players_not_inside tv_teleport_rvr_safezone fl_teleport_rvr)
			(sleep 5)
			
			(object_create_folder sc_blockers_can_entrance)
			
			(zone_set_trigger_volume_enable begin_zone_set:set_canyon_020_025_028 false)
			(zone_set_trigger_volume_enable zone_set:set_canyon_020_025_028 false)
			(zone_set_trigger_volume_enable begin_zone_set:set_pumpstation_025_028_030 false)
			(zone_set_trigger_volume_enable zone_set:set_pumpstation_025_028_030 false)
		)
	)
	
	; player has at least passed the pumpstation and entered the river
	(sleep_until (>= (current_zone_set) s_zone_index_settlement) 1)
	(if (= (current_zone_set) s_zone_index_settlement)
		(begin
			;(sleep_until (volume_test_players tv_teleport_set) 1)
			(if debug (print "zone_teleport_control: bringing players forward to river..."))
			
			(zone_set_trigger_volume_enable begin_zone_set:set_canyon_020_025_028 false)
			(zone_set_trigger_volume_enable zone_set:set_canyon_020_025_028 false)
			(zone_set_trigger_volume_enable begin_zone_set:set_pumpstation_025_028_030 false)
			(zone_set_trigger_volume_enable zone_set:set_pumpstation_025_028_030 false)
			(zone_set_trigger_volume_enable begin_zone_set:set_river_028_030_035 false)
			(zone_set_trigger_volume_enable zone_set:set_river_028_030_035 false)
			(sleep 1)
			
			(volume_teleport_players_not_inside tv_teleport_set_safezone fl_teleport_set)
			(sleep 3)
			
			(if (volume_test_object tv_rvr_blockers (ai_get_object ai_jun))
				(object_teleport (ai_get_object ai_jun) fl_rvr_jun_teleport))
				
			(object_create_folder sc_blockers_rvr_entrance)
			
			
		)
	)
)

(script startup zone_setup_post_settlement
	(zone_set_trigger_volume_enable begin_zone_set:set_cliffside_035_040_045 false)
	
	(sleep_until (= b_set_completed true) 1)
		(if debug (print "zone control: blocking player regression back to pumpstation..."))
		
		; teleport players
		(volume_teleport_players_not_inside tv_teleport_clf_safezone fl_teleport_clf)
		(sleep 5)
		
		; block the river with a boxsa' rocks
		(object_create_folder sc_blockers_rvr_entrance)
		
		; disable zone triggers that let you go back
		(zone_set_trigger_volume_enable begin_zone_set:set_settlement_035_040 false)
		(zone_set_trigger_volume_enable zone_set:set_settlement_035_040 false)
		(zone_set_trigger_volume_enable begin_zone_set:set_river_028_030_035 false)
		(zone_set_trigger_volume_enable zone_set:set_river_028_030_035 false)
		(sleep 1)
		
		; re-enable the trigger to cliffside
		(zone_set_trigger_volume_enable begin_zone_set:set_cliffside_035_040_045 true)
)

(script dormant zone_slo_regression_blocker
	(sleep_until
		(begin
			(cond
				((volume_test_object tv_slo_coop_regression_blocker player0)
						(object_teleport player0 fields_spawn_player0))
						
				((volume_test_object tv_slo_coop_regression_blocker player1)
						(object_teleport player1 fields_spawn_player1))
						
				((volume_test_object tv_slo_coop_regression_blocker player2)
						(object_teleport player2 fields_spawn_player2))
						
				((volume_test_object tv_slo_coop_regression_blocker player3)
						(object_teleport player3 fields_spawn_player3))
			)
			
		0)
	10)
)

(script static void zone_setup_firstkiva
	(if debug (print "::: zone manager: first kiva setup"))
)


; RECYCLING
; =================================================================================================
(script static void recycle_010
	(add_recycling_volume tv_010_recycle 5 30))

(script static void recycle_020
	(add_recycling_volume tv_020_recycle 5 30))

(script static void recycle_025
	(add_recycling_volume tv_025_recycle 5 30))

(script static void recycle_030
	(add_recycling_volume tv_030_recycle 5 30))

(script static void recycle_040
	(add_recycling_volume tv_040_recycle 5 30))

(script static void recycle_045
	(add_recycling_volume tv_045_recycle 5 30))
	

; SPECIAL
; -------------------------------------------------------------------------------------------------
(script startup zeta_control
	(begin_random_count 1
		(wake zeta_fkv)
		(wake zeta_pumpstation)
		(wake zeta_settlement)
		;(wake rampancy_cliffside)
	)
)

; FIRST KIVA
; -------------------------------------------------------------------------------------------------
(global boolean b_zeta_escape false)
(script dormant zeta_fkv
	(if debug (print "zeta detected at first kiva"))
	(sleep_until b_fkv_started)
	
		; -------------------------------------------------
		(ai_place sq_cov_zeta_fkv)
		(sleep 5)
		; -------------------------------------------------
		
	(sleep_until (>= (ai_combat_status gr_cov_fkv) 5) 1)
	
		; -------------------------------------------------
		(sleep 30)
		(cs_run_command_script sq_cov_zeta_fkv cs_zeta_fkv_active)
		; -------------------------------------------------
		
)

(script command_script cs_zeta_fkv_patrol
	(cs_push_stance patrol)
	(cs_abort_on_alert 1)
	(cs_abort_on_damage 1)
	(cs_walk 1)
	(cs_stow true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to pts_zeta_fkv/p0)
					(sleep (random_range 120 300))
				)
				(begin
					(cs_go_to pts_zeta_fkv/p1)
					(sleep (random_range 120 300))
				)
				(begin
					(cs_go_to pts_zeta_fkv/p2)
					(sleep (random_range 120 300))
				)
			)
		0)
	1)
)

(script command_script cs_zeta_fkv_active
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	
	(if debug (print "zeta fkv active."))
	(sleep (random_range (* 30 30) (* 30 30)))
	
	(set b_zeta_escape true)
	
	(sleep (random_range (* 30 6) (* 30 10)))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
)


; PUMPSTATION
; -------------------------------------------------------------------------------------------------
(script dormant zeta_pumpstation
	(if debug (print "rampancy detected at pumpstation"))
	(sleep_until (>= s_objcon_pmp 10) 1)
	(ai_place sq_cov_zeta_pmp)
)

(script command_script cs_zeta_pmp_active
	(ai_disregard ai_current_actor true)
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	
	(if debug (print "zeta set active."))
	(sleep (random_range (* 30 30) (* 30 30)))
	
	(set b_zeta_escape true)
	
	(sleep_until 
		(< (unit_get_shield ai_current_actor) 0.5)
		30
		(random_range (* 30 6) (* 30 10)))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
)

; SETTLEMENT
; -------------------------------------------------------------------------------------------------
(script dormant zeta_settlement
	(if debug (print "rampancy detected at settlement"))
	
	(sleep_until b_set_started)
	
		; -------------------------------------------------
		(ai_place sq_cov_zeta_set)
		(sleep 5)
		; -------------------------------------------------
		
	(sleep_until (>= (ai_combat_status gr_cov_set) 5) 1)
	
		; -------------------------------------------------
		(sleep 30)
		(cs_run_command_script sq_cov_zeta_set cs_zeta_set_active)
		; -------------------------------------------------
)	

(script command_script cs_zeta_set_patrol
	(cs_push_stance patrol)
	(cs_abort_on_alert 1)
	(cs_abort_on_damage 1)
	(cs_walk 1)
	(cs_stow true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to pts_zeta_set/p0)
					(sleep (random_range 120 300))
				)
				(begin
					(cs_go_to pts_zeta_set/p1)
					(sleep (random_range 120 300))
				)
				(begin
					(cs_go_to pts_zeta_set/p2)
					(sleep (random_range 120 300))
				)
			)
		0)
	1)
)

(script command_script cs_zeta_set_active
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	
	(if debug (print "zeta set active."))
	(sleep (random_range (* 30 30) (* 30 30)))
	
	(set b_zeta_escape true)
	
	(sleep (random_range (* 30 6) (* 30 10)))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
)