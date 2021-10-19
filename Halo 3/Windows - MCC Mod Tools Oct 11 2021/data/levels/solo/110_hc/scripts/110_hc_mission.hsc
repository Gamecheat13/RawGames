;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)

(global boolean debug TRUE)
(global boolean dialogue TRUE)
(global boolean music TRUE)

; insertion point index
(global short g_insertion_index 0)

; objective control global shorts
(global short g_ih_obj_control 0)
(global short g_ph_obj_control 0)
(global short g_hab_obj_control 0)
(global short g_br_obj_control 0)
(global short g_hc_obj_control 0)
(global short g_pr_obj_control 0)
(global short g_hd_obj_control 0)
(global short g_re_obj_control 0)
(global short g_is_obj_control 0)
(global short g_rer_obj_control 0)
(global short g_hcr_obj_control 0)
(global short g_brr_obj_control 0)
(global short g_habr_obj_control 0)
(global short g_phr_obj_control 0)
; Because "TEMPORARY HACK!!!!!!!!!!!!!!", which dates back to Bungie's original scripts
; [VSTS-1107689] This is a workaround, to make the so called 'temporary hack' not cause 'mission_highcharity' and 'enc_pelican_hill' to be stripped in sapien or standalone builds.
; no_000 is defined in 110_hc_010_design.structure_design, and so it won't be auto generated into the scenario's soft ceilings until after the bsp is activated
; which all actually happens during cache building, at the end of which scripts are actually compiled (which is why it is not a problem there).
; Meanwhile, in tags builds scripts are compiled on map load
(script static void TEMPORARY_HACK_no_000
	(soft_ceiling_enable no_000 FALSE)
)


; starting player pitch
(global short g_player_start_pitch -16)

(global boolean g_null FALSE)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== HIGH CHARITY MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out
	(fade_out 0 0 0 0)

	; select insertion point
	(cond
		((= (game_insertion_point_get) 0) (ins_intro_halls))
		((= (game_insertion_point_get) 1) (ins_reactor_return))
	)
)

(script startup mission_highcharity
	(if debug (print "bleh!!!!"))
	(print_difficulty)

	; snap to black
	(fade_out 0 0 0 0)

	; pause metagame timer during cinematic
	(campaign_metagame_time_pause TRUE)

	; set allegiances
	(ai_allegiance player human)
	(ai_allegiance player covenant)
	(ai_allegiance human covenant)

	; wake global scripts
	(wake recycle_volumes)
	(wake hc_award_primary_skull)

	; TEMPORARY HACK!!!!!!!!!!!!!!
	(TEMPORARY_HACK_no_000)

		; disable zone swap volumes for return run
		(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return FALSE)
		(zone_set_trigger_volume_enable zone_set:set_bridge_return FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:set_pelican_hill_return FALSE)
			(zone_set_trigger_volume_enable zone_set:set_pelican_hill_return FALSE)


	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		; if game is allowed to start
		(start)

		; if game is NOT allowed to start
		(fade_in 0 0 0 0)
	)
	; === INSERTION POINT TEST =====================================================

		;==== begin intro_halls encounter (insertion 1) ===========================
			(sleep_until (>= g_insertion_index 1) 1)
			(if (<= g_insertion_index 1) (wake enc_intro_halls))

		;==== begin pelican_hill encounters (insertion 2) =========================
			(sleep_until	(or
							(volume_test_players tv_enc_pelican_hill)
							(>= g_insertion_index 2)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 2) (wake enc_pelican_hill))

		;==== begin halls_a_b encounters (insertion 3) ============================
			(sleep_until	(or
							(volume_test_players tv_enc_halls_a_b)
							(>= g_insertion_index 3)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 3) (wake enc_halls_a_b))

		;==== begin bridge encounters (insertion 4) ===============================
			(sleep_until	(or
							(volume_test_players tv_enc_bridge)
							(>= g_insertion_index 4)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 4) (wake enc_bridge))

		;==== begin hall_c encounters (insertion 5) ===============================
			(sleep_until	(or
							(volume_test_players tv_enc_hall_c)
							(>= g_insertion_index 5)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 5) (wake enc_hall_c))

		;==== begin prisoner encounters (insertion 6) =============================
			(sleep_until	(or
							(volume_test_players tv_enc_prisoner)
							(>= g_insertion_index 6)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 6) (wake enc_prisoner))

		;==== begin hall_d encounters (insertion 7) ===============================
			(sleep_until	(or
							(volume_test_players tv_enc_hall_d)
							(>= g_insertion_index 7)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 7) (wake enc_hall_d))

		;==== begin reactor encounters (insertion 8) ==============================
			(sleep_until	(or
							(volume_test_players tv_enc_reactor)
							(>= g_insertion_index 8)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 8) (wake enc_reactor))

		;==== begin inner_sanctum encounters (insertion 9) ========================
			(sleep_until	(or
							(volume_test_players tv_enc_inner_sanctum)
							(>= g_insertion_index 9)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 9) (wake enc_inner_sanctum))

		;==== begin reactor_return encounters (insertion 10) ======================
			(sleep_until	(or
							(and
								(= g_cortana_rescued TRUE)
								(volume_test_players tv_enc_reactor_return)
							)
							(>= g_insertion_index 10)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 10) (wake enc_reactor_return))

		;==== begin hall_c_return encounters (insertion 11) =======================
			(sleep_until	(or
							(volume_test_players tv_enc_hall_c_return)
							(>= g_insertion_index 11)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 11) (wake enc_hall_c_return))

		;==== begin bridge_return encounters (insertion 12) =======================
			(sleep_until	(or
							(and
								(= reactor_blown TRUE)
								(volume_test_players tv_enc_bridge_return)
							)
							(>= g_insertion_index 12)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 12) (wake enc_bridge_return))

		;==== begin halls_a_b_return encounters (insertion 13) ====================
			(sleep_until	(or
							(and
								(= reactor_blown TRUE)
								(volume_test_players tv_enc_halls_a_b_return)
							)
							(>= g_insertion_index 13)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 13) (wake enc_halls_a_b_return))

		;==== begin pelican_hill_return encounters (insertion 14) =================
			(sleep_until	(or
							(and
								(= reactor_blown TRUE)
								(volume_test_players tv_enc_pelican_hill_return)
							)
							(>= g_insertion_index 14)
						)
			1)
				; wake encounter script
				(if (<= g_insertion_index 14) (wake enc_pelican_hill_return))

)

;====================================================================================================================================================================================================
;==================================== INTRO HALLS ===================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_intro_halls
	(data_mine_set_mission_segment "110_010_intro_halls")
	(if debug (print "enc_intro_halls"))
	(game_save)

		; wake secondary threads
		(wake ih_infection_spawn)
		(wake ih_hull_attract)
		(wake ih_puss_burster)
		(wake ih_flood_disperse)
		(wake ih_cleanup)

		; wake music scripts
		(wake music_010_01)
		(wake music_010_02)
		(wake music_010_03)

		; wake navigation scirpt
		(wake nav_ih)

		; wake channel scripts
		(wake ch_01_gravemind)

		; wake object management script
		(wake ih_object_management)

		; place more bipeds for infection on heroic / legendary / meta-game
		(if	(or
				(>= (game_difficulty_get) heroic)
				(= (campaign_metagame_enabled) TRUE)
			)
			(begin
				(if debug (print "place heroic / legendary bipeds"))
				(object_create_containing ih_elite_leg)
			)
		)


	(sleep_until	(or
					(volume_test_players tv_ih_01a)
					(volume_test_players tv_ih_01b)
				)
	1)
	(if debug (print "set objective control 1"))
	(set g_ih_obj_control 1)

	(sleep_until (volume_test_players tv_ih_02) 1)
	(if debug (print "set objective control 2"))
	(set g_ih_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_ih_03) 1)
	(if debug (print "set objective control 3"))
	(set g_ih_obj_control 3)

	(sleep_until (volume_test_players tv_ih_04) 1)
	(if debug (print "set objective control 4"))
	(set g_ih_obj_control 4)

	(sleep_until (volume_test_players tv_ih_05) 1)
	(if debug (print "set objective control 5"))
	(set g_ih_obj_control 5)
	(game_save)
)

;============================= intro halls secondary scripts ========================================================================================================================================
;Spawns initial infection forms
(script dormant ih_infection_spawn
	(ai_place intro_infection/01)
	(ai_place intro_infection/02)
	(ai_place intro_infection/03)
		(sleep 1)
	(ai_place intro_infection/04)
	(ai_place intro_infection/05)
	(ai_place intro_infection/06)
		(sleep 1)
	(ai_place intro_infection/07)
	(ai_place intro_infection/08)
	(ai_place intro_infection/09)
	(ai_place intro_infection/10)
)

;sucks infection forms back down the hall
(script dormant ih_hull_attract
	(vs_reserve intro_infection 1)
	(begin_random
		(begin
			(vs_swarm_from intro_infection/01 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/02 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/03 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/04 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/05 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/06 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/07 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/08 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/09 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_from intro_infection/10 FALSE int_hull_inf_pts/p0 16)
			(sleep (random_range 5 10))
		)
	)

	(sleep_until (>= g_ih_obj_control 1) 30 (* 30 12))
	(begin_random
		(begin
			(vs_swarm_to intro_infection/01 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/02 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/03 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/04 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/05 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/06 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/07 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/08 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/09 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/10 FALSE int_hull_inf_pts/p0 1)
			(sleep (random_range 5 10))
		)
	)

	(sleep_until
		(or
			(= (vs_running_atom_movement intro_infection) FALSE)
			(sleep_until (>= g_ih_obj_control 2) 1)
		)
	1 300)
	(begin_random
		(begin
			(vs_swarm_to intro_infection/01 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/02 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/03 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/04 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/05 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/06 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/07 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/08 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/09 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
		(begin
			(vs_swarm_to intro_infection/10 FALSE int_hull_inf_pts/p1 1)
			(sleep (random_range 5 10))
		)
	)

	(sleep_until
		(or
			(= (vs_running_atom_movement intro_infection) FALSE)
			(>= g_ih_obj_control 3)
		)
	1)
	(vs_release_all)
)

(script command_script ih_disperse_cs
	(cs_swarm_to intro_disperse_pts/p0 1)
	(cs_swarm_to intro_disperse_pts/p1 1)
	(cs_swarm_to intro_disperse_pts/p2 1)
	(cs_swarm_to intro_disperse_pts/p3 1)
	(cs_swarm_to intro_disperse_pts/p4 1)
	(cs_swarm_to intro_disperse_pts/p5 1)
	(cs_swarm_to intro_disperse_pts/p6 1)
	(cs_swarm_to intro_disperse_pts/p7 1)
	(cs_swarm_to intro_disperse_pts/p8 1)
)

(script dormant ih_puss_burster
	(sleep_until (>= g_ih_obj_control 2) 5)

	(begin_random
		(begin
			(object_damage_damage_section int_hull_ball_01 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_02 "body" 1)
			(sleep (random_range 15 30))
		)
;*
		(begin
			(object_damage_damage_section int_hull_ball_03 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_04 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_05 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_06 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_07 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_08 "body" 1)
			(sleep (random_range 15 30))
		)
*;
		(begin
			(object_damage_damage_section int_hull_ball_09 "body" 1)
			(sleep (random_range 15 30))
		)
		(begin
			(object_damage_damage_section int_hull_ball_10 "body" 1)
			(sleep (random_range 15 30))
		)
	)
	(ai_magically_see_object intro_flood (player0))
	(if (= (game_coop_player_count) 2)
		(ai_magically_see_object intro_flood (player1))
	)
	(if (= (game_coop_player_count) 3)
		(ai_magically_see_object intro_flood (player2))
	)
	(if (= (game_coop_player_count) 4)
		(ai_magically_see_object intro_flood (player3))
	)
)

(script dormant ih_flood_disperse
	(sleep_until
		(or
			(>= g_ih_obj_control 4) ; player passes through first door
			(and
				(< (ai_nonswarm_count intro_flood) 2)
				(< (ai_swarm_count intro_flood) 10)
			)
		)
	)
	(print "dispersing")
	(ai_flood_disperse intro_flood intro_disperse_obj/oldskool_flee)
)

;cleanup script for intro space and  hallway 1
(script dormant ih_cleanup
	(sleep_until (>= g_ph_obj_control 1))
	(sleep_forever ih_puss_burster)
	(sleep_forever ih_infection_spawn)
	(sleep_forever ih_hull_attract)
	(ai_disposable intro_infection TRUE)
	(ai_disposable hall1_cf_01 TRUE)
	(ai_disposable intro_inf_spawned TRUE)
	(ai_disposable hall1_inf_spawned TRUE)
)

;====================================================================================================================================================================================================
;==================================== PELICAN HILL ==================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_pelican_hill
	(data_mine_set_mission_segment "110_020_pel_hill")
	(if debug (print "enc_pelican_hill"))
	(game_save)

		; wake channel scripts
		(wake ch_02_cortana)
		(wake ch_03_pelican_hill)

		; wake secondary scripts
		(wake pel_hill_cleanup)
		(wake ai_ph_stalker_retreat)
		(wake ai_ph_combat_02)
		(wake ai_ph_pure_05)

		; wake navigation script
		(wake nav_ph)

		; TEMPORARY HACK!!!!!!!!!!!!!!
		(TEMPORARY_HACK_no_000)

		; place ai
		(ai_place pel_hill_pure_01)
		(ai_place pel_hill_pure_02)

		; wake object management script
		(wake ph_object_management)

	(sleep_until	(or
					(volume_test_players tv_ph_01)
					(volume_test_players tv_ph_02)
				)
	1)
	(if debug (print "set objective control 1"))
	(set g_ph_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_ph_02) 1)
	(if debug (print "set objective control 2"))
	(set g_ph_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_ph_03) 1)
	(if debug (print "set objective control 3"))
	(set g_ph_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_ph_04) 1)
	(if debug (print "set objective control 4"))
	(set g_ph_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_ph_05) 1)
	(if debug (print "set objective control 5"))
	(set g_ph_obj_control 5)
	(game_save)

	(sleep_until (volume_test_players tv_ph_06) 1)
	(if debug (print "set objective control 6"))
	(set g_ph_obj_control 6)
	(game_save)

	(sleep_until (volume_test_players tv_ph_07) 1)
	(if debug (print "set objective control 7"))
	(set g_ph_obj_control 7)
	(game_save)

	(sleep_until (volume_test_players tv_ph_08) 1)
	(if debug (print "set objective control 8"))
	(set g_ph_obj_control 8)
	(game_save)

	(sleep_until (volume_test_players tv_ph_09) 1)
	(if debug (print "set objective control 9"))
	(set g_ph_obj_control 9)
	(game_save)
)

;============================= pelican hill secondary scripts  ======================================================================================================================================
(global boolean g_ph_stalker_retreat FALSE)

(script dormant ai_ph_stalker_retreat
	(sleep_until	(or
					(>= g_ph_obj_control 1)
					(>= (ai_combat_status pelican_hill_obj) 4)
				)
	1 (* 30 15))
	(sleep (random_range 15 45))
	(set g_ph_stalker_retreat TRUE)
)

(script dormant ai_ph_combat_02
	(sleep_until (>= g_ph_obj_control 1))
	(sleep_until (>= g_ph_obj_control 2) 5 (* 30 8))

		; place ai
		(ai_place pel_hill_cf_01)
		(ai_place pel_hill_cf_02)
		(ai_place pel_hill_cf_03)
		(ai_place pel_hill_cf_04)

		(ai_place pel_hill_car_01)
		(ai_place pel_hill_car_02)
		(if (= (game_difficulty_get) heroic) (ai_place pel_hill_car_03))
		(if (= (game_difficulty_get) legendary) (ai_place pel_hill_car_04))

			; unholy flood roar
			(if dialogue (print "FLOOD: (unholy roar!)"))
			(ai_play_line_on_object ph_top_howl01 110mx_300)
			(ai_play_line_on_object ph_top_howl02 110mx_300)
)

(script dormant ai_ph_pure_05
	(sleep_until (>= g_ph_obj_control 5) 5)

		; place ai
		(ai_place pel_hill_pure_03)
		(ai_place pel_hill_pure_04)
		(ai_place pel_hill_pure_05)
		(ai_place pel_hill_pure_06)

			; unholy flood roar
			(if dialogue (print "FLOOD: (unholy roar!)"))
			(ai_play_line_on_object ph_back_howl01 110mx_300)


		(ai_place pel_hill_car_04)
		(ai_place pel_hill_car_05)
		(if (= (game_difficulty_get) heroic) (ai_place pel_hill_car_06))
		(if (= (game_difficulty_get) legendary) (ai_place pel_hill_car_07))
)

(script command_script cs_ph_flood_berserk
	(ai_berserk ai_current_actor TRUE)
	(sleep 1)
)

(script command_script cs_ph_flood_unberserk
	(ai_berserk ai_current_actor FALSE)
	(sleep 1)
)

(script command_script cs_ph_flood_retreat_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_movement_mode 1)
	(ai_berserk ai_current_actor TRUE)

	; sleep until combat form retreats back up the hill
	(sleep_until (volume_test_object tv_ph_04 (ai_get_object ai_current_actor)))
)
(script command_script cs_ph_flood_retreat_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_movement_mode 1)
	(ai_berserk ai_current_actor TRUE)

	; sleep until combat form retreats back up the hill
	(sleep_until (volume_test_object tv_ph_06 (ai_get_object ai_current_actor)))
)

(script command_script cs_ph_flood_disperse
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(ai_berserk ai_current_actor TRUE)
		(sleep (random_range 180 240))

	(if dialogue (print "FLOOD: (unholy roar!)"))
	(cs_play_line 110mx_300)
		(sleep (random_range 15 30))
	(ai_flood_disperse ai_current_actor pelican_hill_obj)
)

;cleanup script for pelican hill
(script dormant pel_hill_cleanup
	(sleep_until (>= g_hab_obj_control 1))
	(ai_disposable pel_hill_pure_01 TRUE)
	(ai_disposable pel_hill_pure_02 TRUE)
	(ai_disposable pel_hill_pure_03 TRUE)
	(ai_disposable pel_hill_pure_04 TRUE)
	(ai_disposable pel_hill_cf_01 TRUE)
	(ai_disposable pel_hill_car_01 TRUE)
	(ai_disposable pel_hill_cf_02 TRUE)
	(ai_disposable pel_hill_car_02 TRUE)
	(ai_disposable pel_hill_cf_03 TRUE)
	(ai_disposable pel_hill_car_03 TRUE)
	(ai_disposable pel_hill_inf_spawned TRUE)
)




;====================================================================================================================================================================================================
;==================================== HALLS A B =====================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_hallS_a_B
	(data_mine_set_mission_segment "110_030_halls_a_b")
	(if debug (print "enc_halls_a_b"))
	(game_save)

		; wake channel scripts
		(wake ch_04_gravemind)
		(wake ch_05_gravemind)

		; wake secondary threads
		(wake ai_hab_infection)
		(wake halls_2_3_cleanup)

		; wake navigation script
		(wake nav_hab)

		; set navigation variable true
		(set g_nav_hab TRUE)

		; wake object management script
		(wake hab_object_management)

	(sleep_until (volume_test_players tv_hab_01) 1)
	(if debug (print "set objective control 1"))
	(set g_hab_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_hab_02) 1)
	(if debug (print "set objective control 2"))
	(set g_hab_obj_control 2)

	(sleep_until (volume_test_players tv_hab_03) 1)
	(if debug (print "set objective control 3"))
	(set g_hab_obj_control 3)

	(sleep_until (volume_test_players tv_hab_04) 1)
	(if debug (print "set objective control 4"))
	(set g_hab_obj_control 4)
	(game_save)

		; stop music_03
		(set g_music_110_03 FALSE)

	(sleep_until (volume_test_players tv_hab_05) 1)
	(if debug (print "set objective control 5"))
	(set g_hab_obj_control 5)
	(game_save)

	(sleep_until (volume_test_players tv_hab_06) 1)
	(if debug (print "set objective control 6"))
	(set g_hab_obj_control 6)
	(game_save)
)

;============================= halls a b secondary scripts =============================================================================================================================================
;for infection form scenes
(script command_script halls_2_3_attract_01
	(cs_swarm_to cafe_inf_pts/p1 1)
)
(script command_script halls_2_3_attract_02
	(cs_swarm_to cafe_inf_pts/p2 1)
)

(script dormant ai_hab_infection
	(ai_place halls_2_3_infection_01 1)
	(sleep 1)
	(ai_place halls_2_3_infection_01 1)
	(sleep 1)
	(ai_place halls_2_3_infection_01 1)
	(sleep 1)
	(ai_place halls_2_3_infection_01 1)
	(sleep 1)
	(ai_place halls_2_3_infection_01 1)

	(sleep_until (>= g_hab_obj_control 4))
	(ai_place halls_2_3_infection_02 1)
	(sleep 1)
	(ai_place halls_2_3_infection_02 1)
	(sleep 1)
	(ai_place halls_2_3_infection_02 1)
	(sleep 1)
	(ai_place halls_2_3_infection_02 1)
	(sleep 1)
	(ai_place halls_2_3_infection_02 1)
)

;cleanup script for hallways a and  b
(script dormant halls_2_3_cleanup
	(sleep_until (>= g_br_obj_control 1))
	(ai_disposable halls_2_3_infection_01 TRUE)
	(ai_disposable halls_2_3_infection_02 TRUE)
	(ai_disposable halls23_inf_spawned TRUE)
	(ai_disposable halls23_too_inf_spawned TRUE)
)

;====================================================================================================================================================================================================
;==================================== BRIDGE ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_bridge
	(data_mine_set_mission_segment "110_040_bridge")
	(if debug (print "enc_bridge"))
	(game_save)

		; wake channel scripts
		(wake ch_06_cortana)
		(wake ch_07_cortana)

		; wake secondary threads
		(wake ai_br_start)
		(wake ai_br_spawner)
		(wake bridge_cleanup)

		; wake navigation script
		(wake nav_br)

		; wake music scripts
		(wake music_010_04)

		; wake object management script
		(wake br_object_management)

	(sleep_until (volume_test_players tv_br_01) 1)
	(if debug (print "set objective control 1"))
	(set g_br_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_br_02) 1)
	(if debug (print "set objective control 2"))
	(set g_br_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_br_03) 1)
	(if debug (print "set objective control 3"))
	(set g_br_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_br_04) 1)
	(if debug (print "set objective control 4"))
	(set g_br_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_br_05) 1)
	(if debug (print "set objective control 5"))
	(set g_br_obj_control 5)
	(game_save)
)

;============================= bridge secondary scripts =============================================================================================================================================
;repulses infection forms into the main room
(script command_script cafe_repulse
	(cs_swarm_from cafe_inf_pts/p0 3)
)

;attracts infection forms into the main room
(script command_script cafe_swarm_01
	(cs_swarm_to cafe_inf_pts/p3 1)
	(cs_swarm_to cafe_inf_pts/p4 1)
)

;spawns combatforms from above and  behind the screen
(script dormant ai_br_spawner
	(sleep_until (>= g_br_obj_control 1))
	(game_save)
	(if (< (ai_nonswarm_count cafe_oldskool) 5)
		(ai_place bridge_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count cafe_oldskool) 5)
		(ai_place bridge_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count cafe_oldskool) 5)
		(ai_place bridge_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count cafe_oldskool) 5)
		(ai_place bridge_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count cafe_oldskool) 5)
		(ai_place bridge_cf_02 1)
	)
	(sleep 1)
	(ai_migrate bridge_cf_01 bridge_cf_02)

	(sleep_until (>= g_br_obj_control 2))
	(game_save)
)

(script dormant ai_br_start
	(ai_place bridge_cf_01 1)
	(ai_place bridge_cf_01 1)
	(ai_place bridge_cf_01 1)
	(if (>= (game_difficulty_get) heroic)
		(begin
			(ai_place bridge_cf_01 1)
			(ai_place bridge_cf_01 1)
		)
	)
		(sleep 1)
	(ai_place bridge_pure_01)
	(ai_place bridge_pure_02)
	(if (>= (game_difficulty_get) heroic)
		(begin
			(ai_place bridge_pure_03)
			(ai_place bridge_pure_04)
		)
	)

	(sleep_until
		(or
			(>= g_br_obj_control 3)
			(< (ai_nonswarm_count cafe_pureforms) 1)
		)
	5)
	(ai_place bridge_pure_end)
	(object_create bridge_howl_pt)
	(sleep 1)
	(sound_impulse_start "sound\dialog\110_hc\mission\110mx_300_grv" bridge_howl_pt 1)
	(sleep 60)
;*
	(object_create bridge_shatter_pt)
	(sleep 1)
	(object_destroy big_screen)
	(sound_impulse_start "sound\materials\brittle\glass\glass_break_large.sound" bridge_shatter_pt 1)
*;
	; loop until hall c encoutner starts
	(sleep_until
		(begin
			(sleep_until
				(or
					(< (ai_swarm_count bridge_end_infection) 5)
					(>= g_hc_obj_control 1)
				)
			)
			(if (= g_hc_obj_control 0) (ai_place bridge_end_infection 1))
			(>= g_hc_obj_control 1)
		)
	)
	(object_destroy bridge_howl_pt)
	(object_destroy bridge_shatter_pt)
)

;cleanup script for the cafeteria bridge
(script dormant bridge_cleanup
	(sleep_until (>= g_hc_obj_control 1))
	(ai_disposable bridge_cf_01 TRUE)
	(ai_disposable bridge_cf_02 TRUE)
	(ai_disposable bridge_cf_03 TRUE)
	(ai_disposable bridge_pure_01 TRUE)
	(ai_disposable bridge_pure_02 TRUE)
	(ai_disposable bridge_pure_03 TRUE)
	(ai_disposable bridge_pure_04 TRUE)
	(ai_disposable bridge_spew_infection TRUE)
	(ai_disposable bridge_end_infection TRUE)
	(ai_disposable bridge_pure_end TRUE)
	(ai_disposable cafe_inf_spawned TRUE)
)



;====================================================================================================================================================================================================
;==================================== HALL C ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_hall_c
	(data_mine_set_mission_segment "110_050_hall_c")
	(if debug (print "enc_hall_c"))
	(game_save)

		; wake channel scripts
		(wake ch_08_cortana)
		(wake ch_09_gravemind)

		;wake secondary threads
		(wake hall_c_cleanup)
		(wake hall_c_reins)

		; wake navigation script
		(wake nav_hc)

		; wake music scripts
		(wake music_010_05)
		(wake music_010_06)

		; wake object management script
		(wake hc_object_management)

		; place ai
		; place ai
		(ai_place hall_c_car_01)
		(ai_place hall_c_pure_01)
		(ai_place hall_c_pure_02)
		(ai_place hall_c_pure_03)
		(ai_place hall_c_pure_04)
		(ai_place hall_c_pure_05)
		(ai_place hall_c_pure_06)

	(sleep_until (volume_test_players tv_hc_01) 1)
	(if debug (print "set objective control 1"))
	(set g_hc_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_hc_02) 1)
	(if debug (print "set objective control 2"))
	(set g_hc_obj_control 2)
	(game_save)

		; stop music_02
		(set g_music_110_02 FALSE)

		; stop music_04
		(set g_music_110_04 FALSE)

	(sleep_until (volume_test_players tv_hc_03) 1)
	(if debug (print "set objective control 3"))
	(set g_hc_obj_control 3)
	(game_save)

		; place ai
		(ai_place hall_c_cf_01)
		(ai_place hall_c_cf_02)

			; unholy flood roar
			(if dialogue (print "FLOOD: (unholy roar!)"))
			(ai_play_line_on_object hall_c_howl_01 110mx_300)
			(ai_play_line_on_object hall_c_howl_02 110mx_300)

	(sleep_until (volume_test_players tv_hc_04) 1)
	(if debug (print "set objective control 4"))
	(set g_hc_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_hc_05) 1)
	(if debug (print "set objective control 5"))
	(set g_hc_obj_control 5)
	(game_save)

	(sleep_until (volume_test_players tv_hc_06) 1)
	(if debug (print "set objective control 6"))
	(set g_hc_obj_control 6)
	(game_save)

		; start music 05
		(set g_music_110_05 TRUE)
)

;============================= hall c secondary scripts =============================================================================================================================================
;cleanup script for hallway 4
(script dormant hall_c_cleanup
	(sleep_until (>= g_pr_obj_control 1))
	(ai_disposable hall_c_cf_01 TRUE)
	(ai_disposable hall_c_cf_02 TRUE)
	(ai_disposable hall_c_car_01 TRUE)
	(ai_disposable hall_c_car_02 TRUE)
	(ai_disposable hall_c_pure_01 TRUE)
	(ai_disposable hall_c_pure_02 TRUE)
	(ai_disposable hall_c_pure_03 TRUE)
	(ai_disposable hall4_inf_spawned TRUE)
)



(script dormant hall_c_reins
	(sleep_until	(or
					(>= g_hc_obj_control 3)
					(<= (ai_task_count hallway_4_obj/pureform_gate) 4)
				)
	)
	(if (<= g_hc_obj_control 2) (ai_place hall_c_pure_rein_01))
	(sleep 1)

	(sleep_until	(or
					(>= g_hc_obj_control 3)
					(<= (ai_task_count hallway_4_obj/pureform_gate) 2)
				)
	)
	(if (<= g_hc_obj_control 2) (ai_place hall_c_pure_rein_02))
	(sleep 1)
;*
	(sleep_until	(or
					(>= g_hc_obj_control 3)
					(<= (ai_task_count hallway_4_obj/pureform_gate) 2)
				)
	)
	(if (<= g_hc_obj_control 2) (ai_place hall_c_pure_rein_03))
*;
)

(script command_script cs_hc_flood_disperse
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(ai_berserk ai_current_actor TRUE)
		(sleep (random_range 180 240))

	(if dialogue (print "FLOOD: (unholy roar!)"))
	(cs_play_line 110mx_300)
		(sleep (random_range 15 30))
	(ai_flood_disperse ai_current_actor hallway_4_obj)
)


;====================================================================================================================================================================================================
;==================================== PRISONER ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_prisoner
	(data_mine_set_mission_segment "110_060_prisoner")
	(if debug (print "enc_prisoner"))
	(game_save)

		; wake secondary threads
		(wake ai_place_prisoner)

		; wake object management script
		(wake pr_object_management)

	(sleep_until (volume_test_players tv_pr_01) 1)
	(if debug (print "set objective control 1"))
	(set g_pr_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_pr_02) 1)
	(if debug (print "set objective control 2"))
	(set g_pr_obj_control 2)
	(game_save)

		; start music 06
		(set g_music_110_06 TRUE)

	(sleep_until (volume_test_players tv_pr_03) 1)
	(if debug (print "set objective control 3"))
	(set g_pr_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_pr_04) 1)
	(if debug (print "set objective control 4"))
	(set g_hd_obj_control 4)
	(game_save)
)

;============================= prisoner secondary scripts ===========================================================================================================================================
;creates flood blockage behind player to trap him (and  keep him from going backwards)
(global boolean blockage_in_place FALSE)

(script dormant ai_place_prisoner
;	(ai_place prisoner_pure_01)
;	(ai_place prisoner_pure_02)
;	(ai_place prisoner_pure_03)
;	(sleep 5)
	(ai_place prisoner_pure_04)
	(ai_place prisoner_pure_05)
	(ai_place prisoner_pure_06)
	(sleep 5)
	(ai_place prisoner_pure_07)
	(ai_place prisoner_pure_08)
	(ai_place prisoner_pure_09)
	(ai_place prisoner_pure_10)
	(sleep 5)
	(ai_place prisoner_cf_01)
	(ai_place prisoner_cf_02)
)


(script dormant prisoner_cleanup
	(sleep_until (>= g_hd_obj_control 1))
	(ai_disposable prisoner_pure_01 TRUE)
	(ai_disposable prisoner_pure_02 TRUE)
	(ai_disposable prisoner_pure_03 TRUE)
	(ai_disposable prisoner_cf_01 TRUE)
	(ai_disposable prisoner_cf_02 TRUE)
	(ai_disposable prisoner_car_01 TRUE)
	(ai_disposable prisoner_inf_spawned TRUE)
)

;====================================================================================================================================================================================================
;==================================== HALL D ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_hall_d
	(data_mine_set_mission_segment "110_070_hall_d")
	(if debug (print "enc_hall_d"))
	(game_save)

		; wake channel scripts
		(wake ch_10_cortana)

		; wake navigation script
		(wake nav_hd)

		; wake music scripts
		(wake music_010_07)

		; wake object management script
		(wake hd_object_management)

	(sleep_until (volume_test_players tv_hd_01) 1)
	(if debug (print "set objective control 1"))
	(set g_hd_obj_control 1)
	(game_save)
)

;============================= hall d secondary scripts =============================================================================================================================================
(script dormant hall5_cleanup
	(sleep_until (>= g_re_obj_control 1))
	(ai_disposable hall5_inf_spawned TRUE)
)

;====================================================================================================================================================================================================
;==================================== REACTOR =======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_reactor
	(data_mine_set_mission_segment "110_080_reactor")
	(if debug (print "enc_reactor"))
	(game_save)

		; wake secondary threads
		(wake pylon_04_fall)
		(wake p_switch_anim)

		; wake navigation script
		(wake nav_rec)

		; wake ai placement scripts

		; wake music scripts
		(wake music_010_08)

		; wake object management script
		(wake re_object_management)

		; place ai
		(wake ai_re_initial_flood)

	(sleep_until (volume_test_players tv_re_01) 1)
	(if debug (print "set objective control 1"))
	(set g_re_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_re_02) 1)
	(if debug (print "set objective control 2"))
	(set g_re_obj_control 2)
	(game_save)

		; start music 08
		(set g_music_110_08 TRUE)

	(sleep_until	(or
					(volume_test_players tv_re_03)
					(volume_test_players tv_re_04)
				)
	1)
	(if debug (print "set objective control 3"))
	(set g_re_obj_control 3)
	(game_save)


	(sleep_until (volume_test_players tv_re_04) 1)
	(if debug (print "set objective control 4"))
	(set g_re_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_re_05) 1)
	(if debug (print "set objective control 5"))
	(set g_re_obj_control 5)
	(game_save)

	(sleep_until (volume_test_players tv_re_06) 1)
	(if debug (print "set objective control 6"))
	(set g_re_obj_control 6)
	(game_save)
)

;============================= reactor secondary scripts ============================================================================================================================================
(script dormant ai_re_initial_flood
	(ai_place sq_re_infection_01)
	(ai_place sq_re_infection_02)
		(sleep 2)
	(ai_place sq_re_infection_03)
	(ai_place sq_re_infection_04)
	(ai_place sq_re_infection_05)
		(sleep 2)
	(ai_place sq_re_pureform_01)
	(ai_place sq_re_pureform_02)
	(ai_place sq_re_pureform_03)
	(ai_place sq_re_pureform_04)
		(sleep 2)
	(ai_place sq_re_pureform_05)
	(ai_place sq_re_pureform_06)
;	(ai_place sq_re_pureform_07)
;	(ai_place sq_re_pureform_08)
		(sleep 2)
;	(ai_place sq_re_pureform_09)
;	(ai_place sq_re_pureform_10)
)

;causes pylon 4 to fall away as you enter
(script dormant pylon_04_fall
	(object_set_permutation pylon_04x "top" "destroyed")
	(object_set_permutation pylon_04x "middle" "destroyed")
	(object_set_permutation pylon_04x "lower" "destroyed")
		(sleep 1)
	(object_cannot_take_damage pylon_04x)

	(sleep_until
		(or
			(and
				(= (volume_test_players vol_see_pylon_fall) TRUE)
				(= (objects_can_see_flag (players) pylon_04_flag 45) TRUE)
			)
			(and
				(= (volume_test_players vol_see_pylon_fall_rev) TRUE)
				(= (objects_can_see_flag (players) pylon_04_flag 45) TRUE)
			)
			(= (volume_test_players vol_pylon_failsafe_01) TRUE)
			(= (volume_test_players vol_pylon_failsafe_02) TRUE)
		)
	)
	(begin_random
		(begin
			(sleep (random_range 2 6))
			(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\fx\detonation.effect pylon_04x "bam_core_01")
		)
		(begin
			(sleep (random_range 2 6))
			(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\fx\detonation.effect pylon_04x "bam_core_02")
		)
		(begin
			(sleep (random_range 2 6))
			(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\fx\detonation.effect pylon_04x "bam_core_03")
		)
		(begin
			(sleep (random_range 2 6))
			(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\fx\detonation.effect pylon_04x "bam_core_04")
		)
	)
	(sleep (random_range 2 6))
	(effect_new_on_object_marker objects\weapons\grenade\plasma_grenade\fx\detonation.effect pylon_04x "center")
	(sound_looping_start "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping" pylon_04x 1)
	(sleep (- (* 7 30) pylon_total))
	(object_damage_damage_section pylon_04x "core" 1)
	(sound_looping_stop "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping")

	(sleep_until (= (volume_test_object vol_reactor_goo pylon_04x) TRUE) 1 247)
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_01x 1)

		; start music 08
		(set g_music_110_08 TRUE)
)

(script dormant p_switch_anim
	(scenery_animation_start_loop p_switch objects\levels\solo\110_hc\cov_reactor_console\cov_reactor_console "spin")

	(sleep_until (= (device_group_get pylons) 1))
	(scenery_animation_start_loop p_switch objects\levels\solo\110_hc\cov_reactor_console\cov_reactor_console "spin_faster")
)





;====================================================================================================================================================================================================
;==================================== INNER SANCTUM =================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_inner_sanctum
	(data_mine_set_mission_segment "110_100_inner_sanctum")
	(if debug (print "enc_inner_sanctum"))
	(game_save)

		; wake channel scripts
		(wake ch_11_gravemind)
		(wake ch_12_gravemind)
		(wake ch_13a_cortana)

		; wake secondary threads
		(wake 110_highcharity_cortana)

		; stop music 07
		(set g_music_110_07 FALSE)

		; stop music 08
		(set g_music_110_08 FALSE)

		; start music 09
		(set g_music_110_09 TRUE)

		; wake music scripts
		(wake music_010_09)
		(wake music_010_10)

	(sleep_until (volume_test_players tv_is_01) 1)
	(if debug (print "set objective control 1"))
	(set g_is_obj_control 1)
	(game_save)

		; start music 10
		(set g_music_110_10 TRUE)

)

;============================= inner sanctum secondary scripts ======================================================================================================================================
(script dormant hall6_cleanup
	(sleep_until (= (device_group_get corty_cinematic) 1))
	(sleep 1)
	(chud_cortana_suck cortyflag_end "marker" FALSE)
	(sleep 1)
	(object_destroy cortyflag_end)
)

(global boolean g_cortana_rescued FALSE)
(global short torture_scale 0)

(script dormant inner_sanctum_cleanup
	(sleep_until
		(and
			(= g_cortana_rescued TRUE)
			(= (volume_test_players vol_cortana_clear) FALSE)
		)
	)
	(ai_disposable sanctum_inf_spawned TRUE)
)

;====================================================================================================================================================================================================
;==================================== REACTOR (RETURN) ==============================================================================================================================================
;====================================================================================================================================================================================================
(global boolean reactor_blown FALSE)

(script dormant enc_reactor_return
	(data_mine_set_mission_segment "110_120_reactor_rev")
	(if debug (print "enc_reactor_return"))
	(game_save)

		; wake channel scripts
		(wake ch_14_gravemind)
		(wake ch_15_cortana)

		; wake secondary threads
		(wake gs_return_doors)
		(wake gs_hc_exit_nav)
		(wake gs_hc_nav_progression)
		(if (>= (game_insertion_point_get) 1) (wake pylon_04_fall))

		; wake music scripts
		(wake music_010_11)
		(wake music_010_12)
		(wake music_010_13)

		; wake ambient audio scripts
		(wake ambient_audio_rumble)

		; place pure forms
		(ai_place sq_re_pureform_01)
		(ai_place sq_re_pureform_02)
		(ai_place sq_re_pureform_03)
		(ai_place sq_re_pureform_04)
			(sleep 2)
		(ai_place sq_re_pureform_05)
;		(ai_place sq_re_pureform_06)
			(sleep 2)

		; put pure forms in the proper objective
		(ai_set_objective reactor_pureforms reactor_rev_obj)

	(ai_disposable reactor_inf_spawned FALSE)
	(object_create_anew blockage_01)
	(object_create_anew blockage_02)
	(device_set_power pylon_switch_01 1)
	(wake reactor_rev_spawning)

	(sleep_until (= (device_group_get pylons) 1))
	(device_set_power pylon_switch_01 0)

		; start music 12
		(set g_music_110_12 TRUE)

	(sleep_until
		(and
			(= (device_get_position pylon_01) 1)
			(= (device_get_position pylon_02) 1)
			(= (device_get_position pylon_03) 1)
		)
	)
	(hud_activate_team_nav_point_flag player pylon_01_flag 0)
	(hud_activate_team_nav_point_flag player pylon_02_flag 0)
	(hud_activate_team_nav_point_flag player pylon_03_flag 0)
	(wake pylon_01_mon)
	(wake pylon_02_mon)
	(wake pylon_03_mon)
	(object_destroy pylon_01)
	(object_create pylon_01x)
	(object_destroy pylon_02)
	(object_create pylon_02x)
	(object_destroy pylon_03)
	(object_create pylon_03x)

	(cond
		((difficulty_heroic)
							(begin
								(object_set_shield pylon_01x 120)
								(object_set_shield pylon_02x 120)
								(object_set_shield pylon_03x 120)
							))
		((difficulty_legendary)
							(begin
								(object_set_shield pylon_01x 180)
								(object_set_shield pylon_02x 180)
								(object_set_shield pylon_03x 180)
							))
	)

	(sleep_until
		(and
			(<= (object_get_health pylon_01x) 0)
			(<= (object_get_health pylon_02x) 0)
			(<= (object_get_health pylon_03x) 0)
		)
	)
	(set reactor_blown TRUE)

	; start ambient audio
	(set g_amb_audio_01 TRUE)

	(sleep 210)
	(wake alarm_loop)
	(wake random_distant_booms)
	(wake random_near_booms)
	(wake invisible_timer)
	(wake objective_2_clear)
	(wake objective_3_set)
	(game_save)

	(ai_place reactor_rev_cf_04 1)
	(sleep 1)

	(device_set_power door_reactor_escape 1)
	(device_set_position door_reactor_escape 1)

	(sleep_until (= (device_get_position door_reactor_escape) 1) 1)
	(device_set_power door_reactor_escape 0)
)

;============================= reactor (return) secondary scripts ===================================================================================================================================
(script dormant gs_return_doors
	; close and lock doors in hall_c, prisoner, and hall_d
	(device_set_position_immediate reactor_sphincter 0)
	(device_set_position_immediate hall_5_sphincter 0)
	(device_set_position_immediate prisoner_sphincter 0)
		(sleep 1)
	(device_set_power reactor_sphincter 0)
	(device_set_power hall_5_sphincter 0)
	(device_set_power prisoner_sphincter 0)

	; destroy the big_screen in the bridge
	; zone_set cd
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	(object_destroy big_screen)

	; zone_set bc_end
	(sleep_until (= (current_zone_set_fully_active) 6) 1)

	; close and lock doors in intro_halls / pelican_hill / halls_a_b
	(device_set_position_immediate horizontal_sphincter 0)
		(sleep 1)
	(device_set_power horizontal_sphincter 0)
)

;	a = .4
;	b = -3.8
;	c = 10

;escalates frequency of explosions over five minutes
(global real elapsed_time 0)
(global real boom_delay 0)
(script dormant invisible_timer
	(sleep_until
		(begin
			(set elapsed_time (+ elapsed_time .0167))
			(set boom_delay (+ (* .4 elapsed_time elapsed_time) (* -3.8 elapsed_time) 10))
			(or
				(> elapsed_time 5)
				(< boom_delay 1)
			)
		)
	30)
	(set elapsed_time 5)
	(set boom_delay 1)
)

;additional camera shake and  rumble for explosions you can't see/feel
(script dormant random_distant_booms
	(sleep_until
		(begin
			(player_effect_set_max_rotation (real_random_range 0 1) (real_random_range 0 1) (real_random_range 0 1))
			(player_effect_set_max_rumble (real_random_range .5 1) (real_random_range .5 1))
			(player_effect_start (real_random_range 0.1 .35) (real_random_range 0.5 1))
			(player_effect_stop (real_random_range 2 3))
			(sleep (random_range (* 10 boom_delay) (* 60 boom_delay)))
			FALSE
		)
	)
)

;function for random explosion type
(global short random_boom 0)
(script static void (random_near_boom (point_reference boom_set))
	(sleep (random_range (* 1 boom_delay) (* 6 boom_delay)))
	(set random_boom (random_range 1 5))
	(if (= random_boom 1)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_medium\high_charity_explosion_medium.effect boom_set)
	)
	(if (= random_boom 2)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_medium\high_charity_explosion_medium.effect boom_set)
	)
	(if (= random_boom 3)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_large\high_charity_explosion_large.effect boom_set)
	)
	(if (= random_boom 4)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_large\high_charity_explosion_large.effect boom_set)
	)
)

;scripting explosions as you run out of the ship
(script dormant random_near_booms
	(sleep_until
		(begin
			(if (< (objects_distance_to_flag (players) near_reactor_01) 25)
				(begin_random
					(random_near_boom escape_reactor_01)
					(random_near_boom escape_reactor_02)
					(random_near_boom escape_reactor_03)
					(random_near_boom escape_reactor_04)
					(random_near_boom escape_reactor_07)
					(random_near_boom escape_hall4_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_reactor_02) 25)
				(begin_random
					(random_near_boom escape_reactor_01)
					(random_near_boom escape_reactor_02)
					(random_near_boom escape_reactor_03)
					(random_near_boom escape_reactor_04)
					(random_near_boom escape_reactor_05)
					(random_near_boom escape_reactor_06)
					(random_near_boom escape_reactor_07)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_01) 25)
				(begin_random
					(random_near_boom escape_reactor_07)
					(random_near_boom escape_hall4_01)
					(random_near_boom escape_hall4_02)
					(random_near_boom escape_hall4_03)
					(random_near_boom escape_hall4_04)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_02) 25)
				(begin_random
					(random_near_boom escape_hall4_01)
					(random_near_boom escape_hall4_02)
					(random_near_boom escape_hall4_03)
					(random_near_boom escape_hall4_04)
					(random_near_boom escape_hall4_05)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_03) 25)
				(begin_random
					(random_near_boom escape_hall4_04)
					(random_near_boom escape_hall4_05)
					(random_near_boom escape_hall4_06)
					(random_near_boom escape_cafe_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_01) 25)
				(begin_random
					(random_near_boom escape_hall4_06)
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_02)
					(random_near_boom escape_cafe_03)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_11)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_02) 25)
				(begin_random
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_02)
					(random_near_boom escape_cafe_03)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_cafe_11)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_03) 25)
				(begin_random
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_halls23_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_04) 25)
				(begin_random
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_halls23_01)
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_01) 25)
				(begin_random
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_02) 25)
				(begin_random
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_03) 25)
				(begin_random
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_04) 25)
				(begin_random
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_05) 25)
				(begin_random
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
					(random_near_boom escape_pel_hill_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_pel_hill_01) 25)
				(begin_random
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
					(random_near_boom escape_pel_hill_01)
					(random_near_boom escape_pel_hill_02)
					(random_near_boom escape_pel_hill_03)
					(random_near_boom escape_pel_hill_04)
					(random_near_boom escape_pel_hill_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_pel_hill_01) 25)
				(begin_random
					(random_near_boom escape_pel_hill_01)
					(random_near_boom escape_pel_hill_02)
					(random_near_boom escape_pel_hill_03)
					(random_near_boom escape_pel_hill_04)
					(random_near_boom escape_pel_hill_05)
					(random_near_boom escape_pel_hill_06)
					(random_near_boom escape_pel_hill_07)
					(random_near_boom escape_pel_hill_08)
				)
			)
			FALSE
		)
	1)
)

;placeholder alarm loop sound using scarab alarm
(script dormant alarm_loop
	(sleep_until
		(AND
			(= (volume_test_object vol_reactor_goo pylon_01x) TRUE)
			(= (volume_test_object vol_reactor_goo pylon_02x) TRUE)
			(= (volume_test_object vol_reactor_goo pylon_03x) TRUE)
		)
	30 180)
	(sleep_until
		(begin
			(sound_impulse_start sound\device_machines\hc_reactor_pylons\hc_alarm.sound NONE 1)
			(sleep 60)
			FALSE
		)
	)
)

;hactacular scripts for destroying the pylons
(global effect babam objects\weapons\grenade\plasma_grenade\fx\detonation.effect)
(global effect kasploosh fx\scenery_fx\explosions\covenant_explosion_large\covenant_explosion_large.effect)
(global effect kaboom objects\vehicles\wraith\fx\destruction\trans_hull_destroyed.effect)
(global effect kablooie objects\vehicles\wraith\fx\destruction\trans_mortar_destroyed.effect)
(global short pylon_countdown 5)
(global short pylon_delay 0)
(global short pylon_total 0)
(global boolean pylon_bam FALSE)
(script static void (blow_pylon_x (object which_pylon))
	(sound_looping_start "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping" which_pylon 1)
	(sleep (- (* 7 30) pylon_total))
	(object_damage_damage_section which_pylon "core" 1)
	(set pylon_countdown 5)
	(set pylon_delay 0)
	(set pylon_total 0)
	(set pylon_bam FALSE)
	(sound_looping_stop "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping")
)

(global short pylon_count 3)
(script dormant pylon_01_mon
	(sleep_until (<= (object_get_health pylon_01x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_01_flag)
	(objects_detach pylon_01x bubble_01)
	(sleep 1)
	(object_destroy bubble_01)
	(blow_pylon_x pylon_01x)
;	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_01x 1)

	(sleep_until (= (volume_test_object vol_reactor_goo pylon_01x) TRUE) 1 180)
;	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_01x 1)
;	(effect_new_on_object_marker kasploosh pylon_01x "center")
	(set pylon_count (- pylon_count 1))

	(sleep_until (= (volume_test_players vol_pylon_01) FALSE))
	(game_save)
)
(script dormant pylon_02_mon
	(sleep_until (<= (object_get_health pylon_02x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_02_flag)
	(objects_detach pylon_02x bubble_02)
	(sleep 1)
	(object_destroy bubble_02)
	(blow_pylon_x pylon_02x)
;	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_02x 1)

	(sleep_until (= (volume_test_object vol_reactor_goo pylon_02x) TRUE) 1 180)
;	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_02x 1)
;	(effect_new_on_object_marker kasploosh pylon_02x "center")
	(set pylon_count (- pylon_count 1))

	(sleep_until (= (volume_test_players vol_pylon_02) FALSE))
	(game_save)
)
(script dormant pylon_03_mon
	(sleep_until (<= (object_get_health pylon_03x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_03_flag)
	(objects_detach pylon_03x bubble_03)
	(sleep 1)
	(object_destroy bubble_03)
	(blow_pylon_x pylon_03x)
;	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_03x 1)

	(sleep_until (= (volume_test_object vol_reactor_goo pylon_03x) TRUE) 1 180)
;	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_03x 1)
;	(effect_new_on_object_marker kasploosh pylon_03x "center")
	(set pylon_count (- pylon_count 1))

	(sleep_until (= (volume_test_players vol_pylon_03) FALSE))
	(game_save)
)

(script dormant reactor_rev_spawning
	(ai_place reactor_rev_cf_01)
	(ai_place reactor_rev_cf_02)
	(ai_place reactor_rev_cf_03)
	(sleep 1)

	(sleep_until
		(or
			(< (ai_nonswarm_count reactor_rev_oldskool) 8)
			(< (objects_distance_to_object (ai_actors reactor_rev_oldskool) (player0)) 5)
			(and
				(< (objects_distance_to_object (ai_actors reactor_rev_oldskool) (player1)) 5)
				(= (game_coop_player_count) 2)
			)
			(and
				(< (objects_distance_to_object (ai_actors reactor_rev_oldskool) (player2)) 5)
				(= (game_coop_player_count) 3)
			)
			(and
				(< (objects_distance_to_object (ai_actors reactor_rev_oldskool) (player3)) 5)
				(= (game_coop_player_count) 4)
			)
		)
	)

	(sleep_until
		(or
			(= (device_group_get pylons) 1)
			(< (ai_nonswarm_count reactor_rev_oldskool) 4)
			(= (volume_test_players vol_reactor_rev_center) TRUE)
		)
	)
	(ai_place reactor_rev_pure_01 1)
	(sleep 1)
	(ai_place reactor_rev_pure_01 1)
	(sleep 1)
	(ai_place reactor_rev_pure_01 1)

	(sleep_until (< pylon_count 3) 5 150)
	(ai_place reactor_rev_pure_02 1)
	(sleep 1)
	(ai_place reactor_rev_pure_02 1)
	(sleep 1)
	(ai_place reactor_rev_pure_02 1)

	(sleep_until (< pylon_count 3))
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_03 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_03 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_03 1)
	)
	(sleep 1)

	(sleep_until (< pylon_count 2))
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_04 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_04 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_04 1)
	)

	(sleep_until (< pylon_count 1) 5 150)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_05 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_05 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count reactor_rev_pureforms) 3)
		(ai_place reactor_rev_pure_05 1)
	)
)

(script command_script reactor_rev_pure_down_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p5)
	(cs_go_to reactor_rev_pts/p6)
	(cs_go_to reactor_rev_pts/p7)
)
(script command_script reactor_rev_pure_down_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p2)
)
(script command_script reactor_rev_pure_down_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p3)
)
(script command_script reactor_rev_pure_down_04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p4)
)
(script command_script reactor_rev_pure_down_05
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p0)
;	(cs_go_to reactor_rev_pts/p1)
)
(script command_script reactor_rev_pure_down_06
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p8)
;	(cs_go_to reactor_rev_pts/p9)
)
(script command_script reactor_rev_pure_down_07
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to_and_face reactor_rev_pts/p13 reactor_rev_pts/p12)
	(cs_go_to reactor_rev_pts/p10)
)
(script command_script reactor_rev_pure_down_08
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to reactor_rev_pts/p11)
)
(script command_script reactor_rev_pure_down_09
	(sleep 90)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to_and_face reactor_rev_pts/p13 reactor_rev_pts/p12)
	(cs_go_to reactor_rev_pts/p12)
)
(script command_script reactor_rev_end_poke
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to hall4_rev_pts/p0)
)

;cleanup scripts for the return trip through reactor
(script dormant reactor_rev_cleanup
	(sleep_until
		(and
			(= g_cortana_rescued TRUE)
			(= (volume_test_players vol_reactor_rev_clear) FALSE)
		)
	)
	(sleep_forever pylon_04_fall)
	(sleep_forever reactor_rev_spawning)
	(sleep_forever pylon_01_mon)
	(sleep_forever pylon_02_mon)
	(sleep_forever pylon_03_mon)
	(sleep_forever GM_pylon_reactions)
	(sleep_forever GM_pylon_reaction_control)
	(ai_disposable reactor_rev_cf_01 TRUE)
	(ai_disposable reactor_rev_cf_02 TRUE)
	(ai_disposable reactor_rev_cf_03 TRUE)
	(ai_disposable reactor_rev_cf_04 TRUE)
	(ai_disposable reactor_rev_pure_01 TRUE)
	(ai_disposable reactor_rev_pure_02 TRUE)
	(ai_disposable reactor_rev_pure_03 TRUE)
	(ai_disposable reactor_rev_pure_04 TRUE)
	(ai_disposable reactor_rev_pure_05 TRUE)
	(ai_disposable reactor_rev_pure_ender TRUE)
	(ai_disposable reactor_inf_spawned TRUE)
)




;====================================================================================================================================================================================================
;==================================== HALL C (RETURN) ===============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_hall_c_return
	(sleep 1)

;	(ai_place hall4_rev_cf_01)
	(ai_place hall4_rev_cf_02)
	(ai_place hall4_rev_cf_03)
	(ai_place hall4_rev_car_01)
	(ai_place hall4_rev_car_02)

	(sleep_until (volume_test_players tv_hc_03) 1)
	(if debug (print "set objective control 1"))
	(set g_hcr_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_hc_02) 1)
	(if debug (print "set objective control 2"))
	(set g_hcr_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_hc_01) 1)
	(if debug (print "set objective control 3"))
	(set g_hcr_obj_control 3)
	(game_save)

)

;============================= hall c (return) secondary scripts ====================================================================================================================================



;====================================================================================================================================================================================================
;==================================== BRIDGE (RETURN) ===============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_bridge_return
	(data_mine_set_mission_segment "110_140_bridge_rev")
	(if debug (print "enc_bridge_return"))
	(game_save)

		; wake background threads
		(wake brr_back_door)

		(ai_disposable cafe_inf_spawned FALSE)
		(object_destroy big_screen)
		(object_create_anew blockage_03)
		(ai_place bridge_rev_cf_01)

	(sleep_until (volume_test_players tv_br_return_01) 1)
	(if debug (print "set objective control 1"))
	(set g_brr_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_br_return_02) 1)
	(if debug (print "set objective control 2"))
	(set g_brr_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_br_return_03) 1)
	(if debug (print "set objective control 3"))
	(set g_brr_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_br_return_04) 1)
	(if debug (print "set objective control 4"))
	(set g_brr_obj_control 4)
	(game_save)

		(object_set_velocity cafe_panel_03 100 0 0)
		(effect_new objects\vehicles\wraith\fx\weapon\mortar\impact bridge_panel_boom_flag)
		(sound_impulse_start "sound\visual_fx\cinematic_panels" bridge_panel_boom_anchor 1)
		(sleep 5)
		(ai_place cafe_rev_tank 1)
)

;============================= bridge (return) secondary scripts ====================================================================================================================================
(script command_script jumper_jumps
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_jump 26 2.75)
)

(script dormant bridge_rev_cleanup
	(sleep_until
		(and
			(= g_cortana_rescued TRUE)
			(= (volume_test_players tv_enc_bridge_return) FALSE)
		)
	)
	(ai_disposable bridge_rev_cf_01 TRUE)
	(ai_disposable bridge_rev_cf_02 TRUE)
	(ai_disposable bridge_rev_cf_03 TRUE)
	(ai_disposable cafe_rev_tank TRUE)
	(ai_disposable cafe_inf_spawned TRUE)
)

(script dormant brr_back_door
	(sleep_until (>= g_brr_obj_control 3))
	(device_set_power door_bridge_escape 1)
	(device_set_position door_bridge_escape 1)
	(ai_place bridge_rev_cf_02)

	(sleep_until (= (device_get_position door_bridge_escape) 1) 1)
	(device_set_power door_bridge_escape 0)
)

;====================================================================================================================================================================================================
;==================================== HALLS_A_B (RETURN) ===============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_halls_a_b_return
	(data_mine_set_mission_segment "110_150_halls_a_b_rev")
	(if debug (print "enc_halls_a_b_return"))
	(game_save)

	(ai_disposable halls23_inf_spawned FALSE)
	(ai_disposable halls23_too_inf_spawned FALSE)
	(ai_place halls23_rev_cf_01 3)

	(sleep_until
		(or
			(< (ai_nonswarm_count halls23_rev_oldskool) 2)
			(= (volume_test_players vol_hallway_2_rev_start) TRUE)
		)
	)
	(game_save)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count halls23_rev_oldskool) 3)
		(ai_place halls23_rev_cf_02 1)
	)
	(sleep 1)
	(ai_place halls23_rev_car_01 1)
	(sleep 1)
	(ai_place halls23_rev_car_01 1)

	(sleep_until
		(or
			(< (ai_nonswarm_count halls23_rev_oldskool) 3)
			(= (volume_test_players vol_hallway_2_rev_start) TRUE)
		)
	)
	(game_save)
	(ai_place halls23_rev_cf_03 1)
	(sleep 1)
	(ai_place halls23_rev_cf_03 1)
	(sleep 1)
	(ai_place halls23_rev_cf_03 1)
)

;============================= hall_a_b (return) secondary scripts ====================================================================================================================================


(script dormant halls23_rev_cleanup
	(sleep_until
		(and
			(= g_cortana_rescued TRUE)
			(= (volume_test_players tv_enc_halls_a_b_return) FALSE)
		)
	)
	(ai_disposable halls23_rev_cf_01 TRUE)
	(ai_disposable halls23_rev_cf_02 TRUE)
	(ai_disposable halls23_rev_cf_03 TRUE)
	(ai_disposable halls23_rev_car_01 TRUE)
	(ai_disposable halls23_inf_spawned TRUE)
	(ai_disposable halls23_too_inf_spawned TRUE)
)




;====================================================================================================================================================================================================
;==================================== PELICAN HILL (RETURN) =========================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_pelican_hill_return
	(data_mine_set_mission_segment "110_160_pel_hill_rev")
	(if debug (print "enc_pelican_hill_return"))
	(game_save)

		; wake secondary threads
		(wake 110_hc_mission_won)

		(if (= (game_is_cooperative) FALSE)
			(begin
				; wake channel threads
				(wake ch_16_cortana)
				(wake ch_17_cortana)
			)
		)

		; wake object management script
		(wake phr_object_management)

		; place arbiter
		(if (= (game_is_cooperative) FALSE)
			(begin
				(ai_place sq_phr_arbiter)
				(object_create_anew arb_banshee)
			)
		)

		; place pureforms
		(ai_place pel_hill_rev_pure_01 1)
			(sleep 1)
;		(ai_place pel_hill_rev_pure_01 1)
			(sleep 1)
		(ai_place pel_hill_rev_pure_02 1)
			(sleep 1)
;		(ai_place pel_hill_rev_pure_02 1)
			(sleep 1)
		(ai_place pel_hill_rev_pure_03 1)
			(sleep 1)
;		(ai_place pel_hill_rev_pure_03 1)
			(sleep 1)
		(ai_place pel_hill_rev_pure_04 1)
			(sleep 1)
;		(ai_place pel_hill_rev_pure_04 1)
			(sleep 1)
		(ai_place pel_hill_rev_car_01 1)
			(sleep 1)
;		(ai_place pel_hill_rev_car_01 1)

	(sleep_until
		(or
			(< (ai_nonswarm_count pel_hill_rev_pureforms) 3)
			(= (volume_test_players vol_pel_hill_rev_top) TRUE)
		)
	)

	(ai_migrate pel_hill_rev_pure_01 pel_hill_rev_pure_03)
	(ai_migrate pel_hill_rev_pure_02 pel_hill_rev_pure_04)
	(sleep 1)

	(if (< (ai_nonswarm_count pel_hill_rev_pure_03) 2)
		(ai_place pel_hill_rev_pure_05 1)
	)
;	(sleep 1)
;	(if (< (ai_nonswarm_count pel_hill_rev_pure_03) 2)
;		(ai_place pel_hill_rev_pure_05 1)
;	)
	(sleep 1)
	(if (< (ai_nonswarm_count pel_hill_rev_pure_04) 2)
		(ai_place pel_hill_rev_pure_06 1)
	)
;	(sleep 1)
;	(if (< (ai_nonswarm_count pel_hill_rev_pure_04) 2)
;		(ai_place pel_hill_rev_pure_06 1)
;	)
	(sleep 1)
	(if (< (ai_nonswarm_count pel_hill_rev_car_01) 2)
		(ai_place pel_hill_rev_car_02 1)
	)
	(sleep 1)
	(if (< (ai_nonswarm_count pel_hill_rev_car_01) 2)
		(ai_place pel_hill_rev_car_02 1)
	)
)

;============================= pelican hill (return) secondary scripts ==============================================================================================================================


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;===================================== general scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script static void gs_lower_weapon
	(unit_lower_weapon (player0) 30)
	(unit_lower_weapon (player1) 30)
	(unit_lower_weapon (player2) 30)
	(unit_lower_weapon (player3) 30)
)

;Used to abort an AI out of a command  script manually
(script command_script abort
	(sleep 1)
)

;Used to make a guy do nothing
(script command_script pause_forever
	(sleep_forever)
)


(script static void gs_return_zone_sets

	; disable zone swap volumes for return run
	(zone_set_trigger_volume_enable begin_zone_set:set_pelican_hill FALSE)
	(zone_set_trigger_volume_enable zone_set:set_pelican_hill FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
		(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_prisoner FALSE)
	(zone_set_trigger_volume_enable zone_set:set_prisoner FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_reactor FALSE)
		(zone_set_trigger_volume_enable zone_set:set_reactor FALSE)

	; enable zone swap volumes for return run
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
		(zone_set_trigger_volume_enable begin_zone_set:set_pelican_hill_return TRUE)
		(zone_set_trigger_volume_enable zone_set:set_pelican_hill_return TRUE)
)
;=====================================================================;
;Kill Volumes
;=====================================================================;

;garbage collection
(script dormant recycle_volumes
	(sleep_until (>= g_ph_obj_control 1))
	(add_recycling_volume tv_rec_ih_01 30 30)

	(sleep_until (= (volume_test_players vol_garbage_pel_hill) TRUE))
	(add_recycling_volume tv_rec_ih_01 0 30)
	(add_recycling_volume tv_rec_ih_02 30 30)

	(sleep_until (= (volume_test_players vol_garbage_hallway_2_3) TRUE))
	(add_recycling_volume tv_rec_ih_02 0 30)
	(add_recycling_volume vol_garbage_pel_hill 30 30)

	(sleep_until (= (volume_test_players vol_garbage_bridge) TRUE))
	(add_recycling_volume vol_garbage_pel_hill 0 30)
	(add_recycling_volume vol_garbage_hallway_2_3 30 30)

	(sleep_until (= (volume_test_players vol_garbage_hallway_4) TRUE))
	(add_recycling_volume vol_garbage_hallway_2_3 0 30)
	(add_recycling_volume vol_garbage_bridge 30 30)

	(sleep_until (= (volume_test_players vol_garbage_prisoner) TRUE))
	(add_recycling_volume vol_garbage_bridge 0 30)
	(add_recycling_volume vol_garbage_hallway_4 30 30)

	(sleep_until (= (volume_test_players vol_garbage_hallway_5) TRUE))
	(add_recycling_volume vol_garbage_hallway_4 0 30)
	(add_recycling_volume vol_garbage_prisoner 30 30)

	(sleep_until (= (volume_test_players vol_garbage_reactor) TRUE))
	(add_recycling_volume vol_garbage_prisoner 0 30)
	(add_recycling_volume vol_garbage_hallway_5 30 30)

	(sleep_until (= reactor_blown TRUE))
	(sleep_until (= (volume_test_players vol_garbage_hallway_4) TRUE))
	(add_recycling_volume vol_garbage_reactor 30 30)

	(sleep_until (= (volume_test_players vol_garbage_bridge) TRUE))
	(add_recycling_volume vol_garbage_reactor 0 30)
	(add_recycling_volume vol_garbage_hallway_4 30 30)

	(sleep_until (= (volume_test_players vol_garbage_hallway_2_3) TRUE))
	(add_recycling_volume vol_garbage_hallway_4 0 30)
	(add_recycling_volume vol_garbage_bridge 30 30)

	(sleep_until (= (volume_test_players vol_garbage_pel_hill) TRUE))
	(add_recycling_volume vol_garbage_bridge 0 30)
	(add_recycling_volume vol_garbage_hallway_2_3 30 30)
)
(script dormant recycle_volumes_ins
	(sleep_until (= reactor_blown TRUE))
	(sleep_until (= (volume_test_players vol_garbage_hallway_4) TRUE))
	(add_recycling_volume vol_garbage_reactor 30 30)

	(sleep_until (= (volume_test_players vol_garbage_bridge) TRUE))
	(add_recycling_volume vol_garbage_reactor 0 30)
	(add_recycling_volume vol_garbage_hallway_4 30 30)

	(sleep_until (= (volume_test_players vol_garbage_hallway_2_3) TRUE))
	(add_recycling_volume vol_garbage_hallway_4 0 30)
	(add_recycling_volume vol_garbage_bridge 30 30)

	(sleep_until (= (volume_test_players vol_garbage_pel_hill) TRUE))
	(add_recycling_volume vol_garbage_bridge 0 30)
	(add_recycling_volume vol_garbage_hallway_2_3 30 30)
)

(script dormant reactor_recycle_bottom
	; turns off once hall_c_return encounter starts
	(sleep_until
		(begin
			(sleep 300)
			(add_recycling_volume tv_rec_reactor_bot 0 0)
		(>= g_hcr_obj_control 1))
	)
)

;====================================================================================================================================================================================================
;============================== AWARD SKULLS ========================================================================================================================================================
;====================================================================================================================================================================================================

;Tilt Skull
(script dormant hc_award_primary_skull
	(if (award_skull)
		(begin
			(object_create skull_tilt)
			(sleep_until
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)

;				(if debug (print "award tilt skull"))
			(campaign_metagame_award_primary_skull (player0) 7)
			(campaign_metagame_award_primary_skull (player1) 7)
			(campaign_metagame_award_primary_skull (player2) 7)
			(campaign_metagame_award_primary_skull (player3) 7)
		)
	)
)
;*
;Blind Skull
(script dormant hc_award_secondary_skull
	(if
		(and
			(>= (game_difficulty_get_real) normal)
			(or
				(= (campaign_is_finished_normal) TRUE)
				(= (campaign_is_finished_heroic) TRUE)
				(= (campaign_is_finished_legendary) TRUE)
			)
		)
			(begin
				(object_create skull_blind)

				(sleep_until
					(or
						(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
						(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
						(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
						(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
					)
				5)

;				(if debug (print "award blind skull"))
				(campaign_metagame_award_secondary_skull (player0) 1)
				(campaign_metagame_award_secondary_skull (player1) 1)
				(campaign_metagame_award_secondary_skull (player2) 1)
				(campaign_metagame_award_secondary_skull (player3) 1)
			)
	)
)
*;
;=====================================================================;
;TEMP
;=====================================================================;

;*
===== ZONE SETS ==========

0: set_intro_halls
1: set_pelican_hill
2: set_bridge
3: set_prisoner
4: set_reactor
5: set_bridge_return
6: set_reactor_return

===== ZONE SETS ==========

*;


(script dormant ih_object_management
	(object_create_folder eq_intro_halls)
	(object_create_folder wp_intro_halls)
	(object_create_folder bp_intro_halls)

	(sleep_until (>= g_hab_obj_control 1))
	(object_destroy_folder eq_intro_halls)
	(object_destroy_folder wp_intro_halls)
	(object_destroy_folder bp_intro_halls)
)

(script dormant ph_object_management
	(object_create_folder eq_pelican_hill)
	(object_create_folder wp_pelican_hill)
	(object_create_folder bp_pelican_hill)

	(sleep_until (>= g_br_obj_control 1))
	(object_destroy_folder eq_pelican_hill)
	(object_destroy_folder wp_pelican_hill)
	(object_destroy_folder bp_pelican_hill)
)

(script dormant hab_object_management
	(object_create_folder eq_halls_a_b)
	(object_create_folder wp_halls_a_b)
	(object_create_folder bp_halls_a_b)

	(sleep_until (>= g_hc_obj_control 1))
	(object_destroy_folder eq_halls_a_b)
	(object_destroy_folder wp_halls_a_b)
	(object_destroy_folder bp_halls_a_b)
)

(script dormant br_object_management
	(object_create_folder eq_bridge)
	(object_create_folder wp_bridge)
	(object_create_folder bp_bridge)

	(sleep_until (>= g_pr_obj_control 1))
	(object_destroy_folder eq_bridge)
	(object_destroy_folder wp_bridge)
	(object_destroy_folder bp_bridge)
)

(script dormant hc_object_management
	(object_create_folder eq_hall_c)
	(object_create_folder wp_hall_c)
	(object_create_folder bp_hall_c)
	(object_create_folder cr_hall_c)

	(sleep_until (>= g_re_obj_control 1))
	(object_destroy_folder eq_hall_c)
	(object_destroy_folder wp_hall_c)
	(object_destroy_folder bp_hall_c)
	(object_destroy_folder cr_hall_c)
)

(script dormant pr_object_management
	(object_create_folder eq_prisoner)
	(object_create_folder wp_prisoner)
	(object_create_folder bp_prisoner)
	(object_create_folder cr_prisoner)

	(sleep_until (>= g_is_obj_control 1))
	(object_destroy_folder eq_prisoner)
	(object_destroy_folder wp_prisoner)
	(object_destroy_folder bp_prisoner)
	(object_destroy_folder cr_prisoner)
)

(script dormant hd_object_management
	(object_create_folder cr_hall_d)

	(sleep_until (>= g_is_obj_control 1))
	(object_destroy_folder cr_hall_d)
)

(script dormant re_object_management
	(object_create_folder eq_reactor)
	(object_create_folder wp_reactor)
	(object_create_folder bp_reactor_01)
		(sleep 15)
	(object_create_folder bp_reactor_02)

	(sleep_until (>= g_brr_obj_control 1))
	(object_destroy_folder eq_reactor)
	(object_destroy_folder wp_reactor)
	(object_destroy_folder bp_reactor_01)
	(object_destroy_folder bp_reactor_02)
)

(script dormant phr_object_management
	(object_create_folder wp_pelican_hill_return)
)
