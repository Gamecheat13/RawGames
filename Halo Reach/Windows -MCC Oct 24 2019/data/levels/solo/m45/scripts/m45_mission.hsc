; -------------------------------------------------------------------------------------------------
; GLOBAL VARIABLES
; -------------------------------------------------------------------------------------------------
(global boolean debug 			true)
(global boolean dialogue 		true)
(global boolean playmusic		true)
(global boolean cinematics 		false)
(global boolean training 		true)
(global boolean autostart		true)
(global boolean ambient_battle	true)

; OBJECTIVE CONTROL
(global short s_objcon_max	10000)
(global short s_objcon_bch 	0)
(global short s_objcon_fac 	0)
(global short s_objcon_slo	0)
(global short s_objcon_lnc 	0)
(global short s_objcon_waf 	0)
(global short s_objcon_crv 	0)
(global short s_objcon_brd 	0)
(global short s_objcon_com	0)
(global short s_objcon_hgr	0)
(global short s_objcon_grm	0)
(global short s_objcon_brg 	0)
(global short s_objcon_esc	0)
(global short s_objcon_fin 	0)

; ENCOUNTER START
(global boolean b_bch_started false)
(global boolean b_fac_started false)
(global boolean b_slo_started false)
(global boolean b_lnc_started false)
(global boolean b_waf_started false)
(global boolean b_wrp_started false)
(global boolean b_crv_started false)
(global boolean b_brd_started false)
(global boolean b_com_started false)
(global boolean b_hgr_started false)
(global boolean b_grm_started false)
(global boolean b_brg_started false)
(global boolean b_esc_started false)
(global boolean b_fin_started false)

; ENCOUNTER COMPLETION
(global boolean b_bch_completed false)
(global boolean b_fac_completed false)
(global boolean b_slo_completed	false)
(global boolean b_lnc_completed false)
(global boolean b_waf_completed false)
(global boolean b_wrp_completed false)
(global boolean b_crv_completed false)
(global boolean b_brd_completed	false)
(global boolean b_com_completed false)
(global boolean b_hgr_completed false)
(global boolean b_grm_completed false)
(global boolean b_brg_completed false)
(global boolean b_esc_completed false)
(global boolean b_fin_completed false)

; PROGRESSION
(global short	s_current_encounter 		-1)
(global boolean b_fac_scanner_activated		false)
(global boolean b_com_beam_deactivated 		false)
(global boolean b_hgr_opened 				false)
(global boolean b_brg_refuel_activated 		false)


; DAILY CHALLENGES
(global boolean b_dc_pods_10 false)
(global boolean b_dc_pods_25 false)
(global boolean b_dc_pods_50 false)

; starting player pitch 
(global real r_deserter_warn_distance 420)
(global short g_player_start_pitch -16)
(global boolean g_null FALSE)
(global real g_nav_offset 0.55)

; targeting groups
(global short s_tg_ambient_battle 100)


; clumps
(global short CLUMP_CORVETTE_AA		19)
(global short CLUMP_SERAPHS			18)
(global short CLUMP_SABRES			17)
(global short CLUMP_SAVANNAH_AA		16)
(global short CLUMP_BANSHEES		15)
(global short CLUMP_GROUND_FLAVOR   14)
(global short CLUMP_GROUND_AA		19)



; -------------------------------------------------------------------------------------------------
; SPACE STARTUP
; -------------------------------------------------------------------------------------------------
(script startup space
	(if debug (print "::: m45 - space :::"))

	(fade_out 0 0 0 0)
	
	
	; === PLAYER IN WORLD TEST =====================================================
	(if
		(or
			(not autostart)
			(editor_mode)
			(<= (player_count) 0)
		)
	
	; if game is allowed to start 
	
		(begin 
			;(fade_out 0 0 0 0)
			(fade_in 0 0 0 0)
		)	
		(start)
	)
	
	; fade out 

	; turns off player disable
	(player_disable_movement 0)

	;setup allegiance
	(ai_allegiance human player)
	(ai_allegiance player human)
	
	; kill volume management	
	(kill_volume_disable kill_soft_bch_burglar)
	(kill_volume_disable kill_crv_01)
	(kill_volume_disable kill_soft_comms_00)
	(kill_volume_disable kill_soft_comms_01)
	(kill_volume_disable kill_soft_comms_02)
	(kill_volume_disable kill_soft_comms_03)
	(kill_volume_disable kill_silo)
	
	; zone set management
	(if debug (print "-=-=-=- disabling zone sets -=-=-=-"))
	(zone_set_trigger_volume_enable zone_set:set_facility_001_005_010 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_facility_001_005_010 	false)
	(zone_set_trigger_volume_enable begin_zone_set:set_silo_005_010_015 		false)
	(zone_set_trigger_volume_enable zone_set:set_silo_005_010_015 				false)
	
	; corvette
	(zone_set_trigger_volume_enable begin_zone_set:set_hangar_050_070_060		false)
	(zone_set_trigger_volume_enable zone_set:set_hangar_050_070_060				false)
	(zone_set_trigger_volume_enable zone_set:set_gunroom_050_060_065			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		false)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_escape_050_065_060 		false)
	(zone_set_trigger_volume_enable zone_set:set_escape_050_065_060 			false)

	(soft_ceiling_enable soft_ceiling_ship_01 0)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------

			; BEACH
			; -------------------------------------------------------------------------------------------------
			(sleep_until (>= s_insertion_index s_bch_encounter_index) 1)
			(if (<= s_insertion_index s_bch_encounter_index) (wake bch_encounter))
			
			; COMMAND
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_bch_completed true)
							(>= s_insertion_index s_fac_encounter_index)) 1)

			(if (<= s_insertion_index s_fac_encounter_index) (wake fac_encounter))	
			
			; LAUNCH
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							;(= b_fac_completed true)
							(volume_test_players tv_lnc_start)
							(>= s_insertion_index s_lnc_encounter_index)) 1)
			
			(if (<= s_insertion_index s_lnc_encounter_index) (wake lnc_encounter))

			; WAFER
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_lnc_completed TRUE)
							(>= s_insertion_index s_waf_encounter_index)) 1)
			
			(if (<= s_insertion_index s_waf_encounter_index) (wake waf_encounter))
			
			; WARP
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_waf_completed TRUE)
							(>= s_insertion_index s_wrp_encounter_index)) 1)
			
			(if (<= s_insertion_index s_wrp_encounter_index) (wake wrp_encounter))			

			; CORVETTE
			; ------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_wrp_completed TRUE)	
							(>= s_insertion_index s_crv_encounter_index)) 1)
			
			(if (<= s_insertion_index s_crv_encounter_index) (wake crv_encounter))
			
			; LANDING
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_crv_completed TRUE)	
							(>= s_insertion_index s_brd_encounter_index)) 1)
			
			(if (<= s_insertion_index s_brd_encounter_index) (wake brd_encounter))

			; COMMUNICATIONS CENTER
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_brd_completed TRUE)	
							(>= s_insertion_index s_com_encounter_index)) 1)
			
			(if (<= s_insertion_index s_com_encounter_index) (wake com_encounter))
			
			; HANGAR
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_com_completed TRUE)	
							(>= s_insertion_index s_hgr_encounter_index)) 1)
			
			(if (<= s_insertion_index s_hgr_encounter_index) (wake hgr_encounter))
			
			; GUN ROOM
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_hgr_completed TRUE)
							(>= s_insertion_index s_grm_encounter_index)) 1)
			
			(if (<= s_insertion_index s_grm_encounter_index) (wake grm_encounter))
			
			; BRIDGE
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(volume_test_players tv_bridge_start)
							(>= s_insertion_index s_brg_encounter_index)) 1)
			
			(if (<= s_insertion_index s_brg_encounter_index) (wake brg_encounter))
			
			; ESCAPE
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(= b_brg_completed TRUE)
							(>= s_insertion_index s_esc_encounter_index)) 1)
			
			(if (<= s_insertion_index s_esc_encounter_index) (wake esc_encounter))
			
			; FINAL
			; -------------------------------------------------------------------------------------------------
			(sleep_until	(or
							(volume_test_players tv_final_start)
							(>= s_insertion_index s_fin_encounter_index))	1)
			
			(if (<= s_insertion_index s_fin_encounter_index) (wake fin_encounter))
			
			; OUTRO
			(sleep_until (= b_fin_completed true))
			(if debug (print "starting outro cinematic"))
			
			(f_end_mission 045lf_jorge set_outrostart_050_060)
			(game_won)
)

(script static void start
	(if debug (print "game mode. choosing insertion point..."))
	
	(cond
		((= (game_insertion_point_get) 0) (ins_beach))
		((= (game_insertion_point_get) 1) (ins_wafer))
		((= (game_insertion_point_get) 2) (ins_comms))
		((= (game_insertion_point_get) 5) (print "::: loading in debug mode :::"))
		;((= (game_insertion_point_get) 11) (ins_fx_frigate_destruction))
		;((= (game_insertion_point_get) 2) (ins_launch))
		;((= (game_insertion_point_get) 3) (ins_wafer))
		;((= (game_insertion_point_get) 4) (ins_corvette))
		;((= (game_insertion_point_get) 5) (ins_frigate))
		;((= (game_insertion_point_get) 6) (ins_bridge))	
		;((= (game_insertion_point_get) 7) (ins_final))						
	)
)

(script dormant carter_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count ai_carter) 0) 1)
			(f_hud_spartan_waypoint ai_carter carter_name 20)
		)
	)
)

(script dormant kat_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count ai_kat) 0) 1)
			(f_hud_spartan_waypoint ai_kat kat_name 20)
		)
	)
)

(script dormant jorge_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count ai_jorge) 0) 1)
			(f_hud_spartan_waypoint ai_jorge jorge_name 20)
		)
	)
)

(script dormant jorge_gunroom_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count sq_jorge) 0) 1)
			(f_hud_spartan_waypoint sq_jorge jorge_name 20)
		)
	)
)

(script dormant jorge_final_marker_control
	(if (not (game_is_cooperative))
		(begin
			(sleep_until (> (ai_living_count sq_jorge) 0) 1)
			(f_hud_spartan_waypoint sq_jorge jorge_name 20)
		)
	)
)

; =================================================================================================
; BEACH
; =================================================================================================
(global boolean b_bch_counterattack_started false)
; -------------------------------------------------------------------------------------------------
(script dormant bch_encounter
	(if debug (print "encounter: beach"))
	(set s_current_encounter s_bch_encounter_index)
	; set first segment for competitive time.
	(data_mine_set_mission_segment "m45_01_bch_encounter")
	
	(if (or (not (editor_mode)) cinematics)
		(begin 
			(if debug (print "starting with intro cinematic..."))
			(f_start_mission 045la_katsplan)
			(f_play_cinematic_advanced 045la_katsplan_v2 set_beach_001_005 set_beach_001_005)	; immediately start the falcon section
			(unit_raise_weapon player0 1)
			(unit_raise_weapon player1 1)
			(unit_raise_weapon player2 1)
			(unit_raise_weapon player3 1)
		)
	)
	(switch_zone_set set_beach_001_005)
	(sleep_until (= (current_zone_set_fully_active) s_zoneindex_beach) 1)
	
	;(prepare_to_switch_to_zone_set set_facility_001_005_010)
		;(sleep 1)
	
	; object management
	
	; kill volumes
	(kill_volume_enable kill_soft_bch_burglar)
	
	; zone sets
	(zone_set_trigger_volume_enable zone_set:set_facility_001_005_010 			true)
	(zone_set_trigger_volume_enable begin_zone_set:set_facility_001_005_010 	true)
	
	; wake subsequent scripts
	(wake bch_completion_control)
	(wake bch_spartan_main)
	(wake bch_object_creation_control)
	(wake bch_pod_control)
	(wake bch_seraph_crash_control)
	(wake bch_cov_cove_elite_pod_control)
	(wake bch_wraith1_control)
	(wake bch_fork_control)
	(wake bch_burglar_control)
	
	; saves
	(wake save_bch_jetpacks)
	(wake save_bch_rocks)
	
	; markers
	(wake carter_marker_control)
	(wake kat_marker_control)
	(wake jorge_marker_control)
	
	; place ai
	(ai_place sq_cov_bch_ds0)
	;(ai_place gr_cov_bch_rocks_infantry)
	
	
	;OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_bch_started true)
	; -------------------------------------------------------------------------------------------------
	
			; -------------------------------------------------
			
			(if (or (not (editor_mode)) cinematics)
				(cinematic_exit 045la_katsplan_v2 false))
			
			
			(wake save_bch_start)
			(wake show_chapter_title_beach)
			;(mus_play mus_perc3)
			;(wake md_bch_jor_intro)
			
			;*
			(if (difficulty_is_legendary)
				(begin
					(wake bch_pod_drop_start0)
					(wake bch_pod_drop_start1)
				)
			)
			*;
			
			(bch_setup_aa)
			(wake bch_seraphs_start)
			; -------------------------------------------------

	(sleep_until (or
	(volume_test_players tv_objcon_bch_010)
	(>= s_objcon_bch 10)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 10)
				(begin 
					(if debug (print " ::: bch ::: objective control 010"))
					(set s_objcon_bch 10)
					
					
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_020)
	(>= s_objcon_bch 20)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 20)
				(begin 
					(if debug (print " ::: bch ::: objective control 020"))
					(set s_objcon_bch 20)
					
					
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_025a)
	(volume_test_players tv_objcon_bch_025b)
	(>= s_objcon_bch 25)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 25)
				(begin 
					(if debug (print " ::: bch ::: objective control 025"))
					(set s_objcon_bch 25)
					
					(mus_stop mus_01)
					(mus_start mus_02)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_028a)
	(volume_test_players tv_objcon_bch_028b)
	(>= s_objcon_bch 28)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 28)
				(begin 
					(if debug (print " ::: bch ::: objective control 028"))
					(set s_objcon_bch 28)
					
					;(ai_place sq_cov_bch_ds1)
					
				)
			)
			
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_030)
	(>= s_objcon_bch 30)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 30)
				(begin 
					(if debug (print " ::: bch ::: objective control 030"))
					(set s_objcon_bch 30)
					(soft_ceiling_enable beach_blocker_01 0)
					
					(wake md_bch_kat_launch_ahead)
					;(wake bch_pod_drop_jetpack0)
					;(wake bch_pod_drop_jetpack1)
					;(wake bch_pod_drop_jetpack2)
					(wake save_bch_facility_zoneset)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_040)
	(>= s_objcon_bch 40)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 40)
				(begin 
					(if debug (print " ::: bch ::: objective control 040"))
					(set s_objcon_bch 40)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_050)
	(>= s_objcon_bch 50)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 50)
				(begin 
					(if debug (print " ::: bch ::: objective control 050"))
					(set s_objcon_bch 50)
					
					(ai_place sq_cov_bch_ds3)
					;(ai_place sq_cov_bch_ds2)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_060)
	(>= s_objcon_bch 60)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 60)
				(begin 
					(if debug (print " ::: bch ::: objective control 060"))
					(set s_objcon_bch 60)
					
					
					;(ai_place gr_cov_bch_door)
					;(ai_place gr_unsc_bch_door)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_065)
	(>= s_objcon_bch 65)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 65)
				(begin 
					(if debug (print " ::: bch ::: objective control 065"))
					(set s_objcon_bch 65)
					
					(game_save)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_070)
	(>= s_objcon_bch 70)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 70)
				(begin 
					(if debug (print " ::: bch ::: objective control 070"))
					(set s_objcon_bch 70)
					
					(game_save)
					(add_recycling_volume tv_bch_recycle 7 15)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_080)
	(>= s_objcon_bch 80)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 80)
				(begin 
					(if debug (print " ::: bch ::: objective control 080"))
					(set s_objcon_bch 80)
					
					(wake md_bch_jor_hostile_rocks_south)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_090)
	(>= s_objcon_bch 90)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 90)
				(begin 
					(if debug (print " ::: bch ::: objective control 090"))
					(set s_objcon_bch 90)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_100)
	(>= s_objcon_bch 100)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 100)
				(begin 
					(if debug (print " ::: bch ::: objective control 100"))
					(set s_objcon_bch 100)
					
					;(wake md_bch_trf_spartans_coming)
					(game_save)
					(add_recycling_volume tv_bch_recycle 7 15)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_110)
	(>= s_objcon_bch 110)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 110)
				(begin 
					(if debug (print " ::: bch ::: objective control 110"))
					(set s_objcon_bch 110)
					
					
					(set b_bch_counterattack_started true)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_bch_120)
	(>= s_objcon_bch 120)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_bch 120)
				(begin 
					(if debug (print " ::: bch ::: objective control 120"))
					(set s_objcon_bch 120)
				)
			)
			; -------------------------------------------------


	(sleep_until b_bch_completed 1)
	
			; -------------------------------------------------
			;(mus_stop mus_perc3)
			;(object_destroy_folder dm_ambient_pods)
			(game_save)
			; -------------------------------------------------
)

(script dormant bch_object_creation_control
	(sleep_until (= (current_zone_set_fully_active) s_zoneindex_facility) 1)
		
		(object_create_folder cr_beach)
		(object_create_folder sc_bch)	
		
	
)

(script dormant bch_burglar_control
	(branch
		(= b_fac_started true) (branch_abort)
		
	)
	
	(sleep_until
		(begin
			(if (volume_test_object kill_soft_bch_burglar player0)
				(object_teleport player0 fl_bch_burglar))
				
			(if (volume_test_object kill_soft_bch_burglar player1)
				(object_teleport player1 fl_bch_burglar))
				
			(if (volume_test_object kill_soft_bch_burglar player2)
				(object_teleport player2 fl_bch_burglar))
				
			(if (volume_test_object kill_soft_bch_burglar player3)
				(object_teleport player3 fl_bch_burglar))
				
			(sleep 30)
				
		0)
	1)
)

(global boolean b_bch_rocks_pods_complete false)
(script dormant bch_pod_control
	(sleep_until (>= s_objcon_bch 25))
			
			; -------------------------------------------------
			(sleep 35)
			(bch_skybox_pod_trail)
			(sleep 95)
			(drop_pod dm_bch_rocks_pod0 sq_cov_bch_rocks_pods/elite0)
			(open_pod dm_bch_rocks_pod0 sq_cov_bch_rocks_pods/elite0)
			; -------------------------------------------------
	
	(sleep (random_range 90 210))
	
			; -------------------------------------------------
			(drop_pod dm_bch_rocks_pod1 sq_cov_bch_rocks_pods/elite1)
			(open_pod dm_bch_rocks_pod1 sq_cov_bch_rocks_pods/elite1)
			; -------------------------------------------------
			
	(sleep_until
		(or
			(<= (ai_living_count sq_cov_bch_rocks_pods) 1)
			(>= s_objcon_bch 50)
		)
	)
	
			; -------------------------------------------------
			(drop_pod dm_bch_rocks_pod2 sq_cov_bch_rocks_pods/elite2)
			(open_pod dm_bch_rocks_pod2 sq_cov_bch_rocks_pods/elite2)
			; -------------------------------------------------
			
	(sleep_until
		(or
			(<= (ai_living_count sq_cov_bch_rocks_pods) 1)
			(>= s_objcon_bch 60)
		)
	)
	
			; -------------------------------------------------
			(drop_pod dm_bch_rocks_pod3 sq_cov_bch_rocks_pods/elite3)
			(open_pod dm_bch_rocks_pod3 sq_cov_bch_rocks_pods/elite3)
			(set b_bch_rocks_pods_complete true)
			; -------------------------------------------------
			
)

(script dormant save_bch_start
	(sleep 120)
	(game_save_no_timeout)
)

(script dormant save_bch_facility_zoneset
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_facility))
	(sleep 60)
	(game_save_no_timeout)
)

(script dormant save_bch_jetpacks
	(branch
		(= b_fac_started true) (branch_abort)
	)
	
	(sleep_until (> (ai_spawn_count sq_cov_bch_rocks_jetpacks0) 0))
	(sleep_until (<= (ai_spawn_count sq_cov_bch_rocks_jetpacks0) 0))
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_bch_rocks
	(branch
		(= b_fac_started true) (branch_abort)
	)
	
	(sleep_until (>= s_objcon_bch 60))
	(sleep_until (<= (ai_living_count gr_cov_bch_rocks) 0))
	(sleep 30)
	(game_save_no_timeout)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant bch_spartan_main
	(ai_place sq_carter/bch)
	(ai_place sq_jorge/bch)
	(ai_place sq_kat/bch)
	(sleep 1)
	(set ai_carter sq_carter)
	(set ai_kat sq_kat)
	(set ai_jorge sq_jorge)
	
	
	(set ai_kat sq_kat)
	(set ai_jorge sq_jorge)
	(set ai_carter sq_carter)
	
	(ai_set_objective gr_unsc_spartans obj_unsc_bch)
	(ai_cannot_die gr_unsc_spartans true)
)


; COMBAT
; -------------------------------------------------------------------------------------------------
(script dormant bch_completion_control
	(sleep_until 
		(and
			(> (ai_spawn_count gr_cov_bch_cove) 0)
			(> (ai_spawn_count sq_cov_bch_cove_elite0) 0)
		)
	)
	
	(sleep_until (<= (ai_living_count gr_cov_bch_cove) 0))
	(bch_start_infinite_encounter)
	
	(sleep (random_range 30 90))
	;(sleep_until (<= (ai_living_count gr_cov_bch_counter) 0) 30 (* 30 240))
	(if debug (print "beach: encounter complete. enemies defeated or sleep timed out..."))
	(set b_bch_completed true)
)

(script command_script cs_bch_jetpackelite0
	(cs_enable_moving 0)
	;(cs_abort_on_damage 1)
	
	(sleep_until (or
		(< (object_get_shield (ai_get_object ai_current_actor)) 1)
		(>= s_objcon_bch 50)
		(<= (ai_strength gr_cov_bch_rocks) 0.50)))
	
	(sleep (random_range 10 60))
	(cs_run_command_script sq_cov_bch_rocks_jetpacks0 cs_abort)
)

(script dormant bch_wraith1_control
	(sleep_until (>= s_objcon_bch 80))
	(ai_place sq_cov_bch_ds4)
	(wake bch_wraith_water_kill)
	(sleep (* 30 10))
	
	(sleep_until 
		(or
			(volume_test_players tv_bch_wraith1_proximity)
			(= b_bch_completed true)
		)
	)
	
	(if debug (print "aborting wraith firing script"))
	(cs_run_command_script sq_cov_bch_wraith1 cs_abort)
)

(script command_script cs_bch_trooper_female_door
	;(cs_enable_looking 1)
	(cs_abort_on_damage 1)
	;(cs_enable_targeting 1)
	;(cs_shoot 1)
	
	(cs_aim true ps_fac_door/trf_target)
	(sleep_until (>= s_objcon_fac 20))
	(sleep (random_range 60 90))
)

(script command_script cs_bch_trooper_lead_door
	;(cs_enable_looking 1)
	;(cs_enable_targeting 1)
	;(cs_shoot 1)
	(cs_abort_on_damage 1)
	(cs_aim true ps_fac_door/trlead_target)
	(sleep_until (>= s_objcon_fac 20))
)


; DROPSHIPS
; -------------------------------------------------------------------------------------------------
; Delivers landing and rocks squad groups on the beach.
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_cov_ds0
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_vehicle_get ai_current_actor))
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "left" sq_cov_bch_rocks_grunts0 sq_cov_bch_rocks_jackals0 none none)
	;(cs_vehicle_speed 1.0)
	;(cs_fly_by ps_bch_cov_ds0/entry2)
	;(cs_fly_by ps_bch_cov_ds0/entry1)
	;(cs_fly_by ps_bch_cov_ds0/entry0)
	
	;(cs_vehicle_speed 0.4)
	;(cs_fly_to ps_bch_cov_ds0/hover 0.25)
	;(sleep 30)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face ps_bch_cov_ds0/land ps_bch_cov_ds0/land_facing 0.25)
	
	(sleep 30)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "left")
	(sleep 30)
	
	(cs_fly_to_and_face ps_bch_cov_ds0/hover ps_bch_cov_ds0/land_facing 0.25)
	(sleep 30)
	
	(cs_vehicle_speed 0.9)
	(cs_fly_by ps_bch_cov_ds0/exit0)
	(cs_vehicle_boost 1)
	(cs_vehicle_speed 1)
	
	(cs_fly_by ps_bch_cov_ds0/exit1)
	
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_cov_ds0/erase)
	(ai_erase ai_current_squad)
)

; DROPSHIP 1
; -------------------------------------------------------------------------------------------------
; Delivers covenant infantry to the cove area. Drops off jackal snipers to cover the ridge of the
; rock area encounter.
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_cov_ds1
	(cs_enable_pathfinding_failsafe true)
	(ai_disregard (ai_actors ai_current_squad) true)
	(f_load_fork_cargo (ai_vehicle_get ai_current_actor) "large" sq_cov_bch_wraith0 NONE NONE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(object_cannot_take_damage (ai_vehicle_get ai_current_actor))
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_bch_cov_ds1/entry2)
	
	
	
	(cs_fly_by ps_bch_cov_ds1/entry1)
	(cs_fly_by ps_bch_cov_ds1/entry0)
	
	(cs_vehicle_speed 0.4)
	;(cs_fly_to ps_bch_cov_ds1/hover 0.25)
	;(sleep 30)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face ps_bch_cov_ds1/land ps_bch_cov_ds1/land_facing 0.5)
	(sleep 30)
	(f_unload_fork_cargo (ai_vehicle_get ai_current_actor) "large")
	(sleep 30)
	
	(cs_fly_to_and_face ps_bch_cov_ds1/hover ps_bch_cov_ds1/land_facing 1.0)
	;(sleep 30)
	
	(sleep 30)
	
	(cs_vehicle_speed 0.8)
	;(cs_fly_by ps_bch_cov_ds1/entry2)
	
	(cs_fly_by ps_bch_cov_ds1/exit0)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_cov_ds1/exit1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_cov_ds1/erase)
	;(cs_fly_by ps_bch_cov_ds0/erase)
	
	(ai_erase ai_current_squad)
)

; DROPSHIP 2
; -------------------------------------------------------------------------------------------------
; Delivers Covenant infantry to the entrance of the launch facility.
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_cov_ds2
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_vehicle_get ai_current_actor))
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_bch_cov_ds2/entry2)
	(cs_fly_by ps_bch_cov_ds2/entry1)
	(cs_fly_by ps_bch_cov_ds2/entry0)
	
	(cs_vehicle_speed 0.4)
	;(cs_fly_to ps_bch_cov_ds2/hover 0.25)
	;(sleep 30)
	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face ps_bch_cov_ds2/land ps_bch_cov_ds2/land_facing 2.0)
	(sleep 90)
	
	(cs_fly_to_and_face ps_bch_cov_ds2/hover ps_bch_cov_ds2/land_facing 1.0)
	(sleep 30)
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_bch_cov_ds2/entry2)
	
	(ai_erase ai_current_squad)
)

(global object o_bch_wraith none)
(script command_script cs_bch_cov_ds4
	(cs_enable_pathfinding_failsafe true)
	(f_load_fork_cargo (ai_vehicle_get ai_current_actor) "large" sq_cov_bch_wraith1 NONE NONE)
	(set o_bch_wraith (ai_vehicle_get sq_cov_bch_wraith1/pilot))
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	(object_cannot_take_damage (ai_vehicle_get ai_current_actor))
	
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)

	(cs_fly_by ps_bch_cov_ds4/entry2)
	(cs_fly_by ps_bch_cov_ds4/entry1)
	(cs_vehicle_boost 0)
	(cs_fly_by ps_bch_cov_ds4/entry0)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face ps_bch_cov_ds4/hover ps_bch_cov_ds4/land_facing 1)
	(sleep 30)
	(cs_vehicle_speed 0.3)
	(cs_ignore_obstacles 1)
	(cs_fly_to_and_face ps_bch_cov_ds4/land ps_bch_cov_ds4/land_facing 0.25)
	(f_unload_fork_cargo (ai_vehicle_get ai_current_actor) "large")
	(sleep 60)
	(cs_fly_to_and_face ps_bch_cov_ds4/hover ps_bch_cov_ds4/land_facing 1)
	(cs_ignore_obstacles 0)
	(sleep 30)
	(cs_fly_by ps_bch_cov_ds4/exit0)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_bch_cov_ds4/exit1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
	(cs_fly_by ps_bch_cov_ds4/erase)
	(ai_erase ai_current_squad)
)



; DROPSHIP 3
; -------------------------------------------------------------------------------------------------
; Delivers the counterattack.
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_cov_ds3
	(cs_enable_pathfinding_failsafe true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	(object_cannot_take_damage (ai_vehicle_get ai_current_actor))
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_bch_cov_ds3/entry0)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" sq_cov_bch_cove_grunts0 sq_cov_bch_cove_grunts1 sq_cov_bch_cove_snipers0 sq_cov_bch_cove_jackals0)
	
	(cs_vehicle_speed 0.6)
	(cs_fly_to ps_bch_cov_ds3/hover 2.0)
	(cs_vehicle_speed 0.3)
	;(wake bch_pod_drop_counter0)
	
		(sleep 30)
	
	
	(cs_fly_to_and_face ps_bch_cov_ds3/land ps_bch_cov_ds3/land_facing 0.4)
	
		(sleep 30)
	
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(cs_fly_to_and_face ps_bch_cov_ds3/hover ps_bch_cov_ds3/land_facing 0.5)
	
		(sleep 30)
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_bch_cov_ds3/erase)
	(ai_erase ai_current_squad)
)

(script dormant bch_cov_cove_elite_pod_control
	(sleep_until (>= s_objcon_bch 100))
	(drop_pod dm_bch_cove_pod0 sq_cov_bch_cove_elite0/elite0)
	(open_pod dm_bch_cove_pod0 sq_cov_bch_cove_elite0/elite0)
)


; FORKS
; -------------------------------------------------------------------------------------------------
(script dormant bch_fork_control
	(sleep_until (>= s_objcon_bch 10) 30 (* 30 7))
	(ai_place sq_cov_bch_amb_forks0)
	(ai_disregard (ai_actors sq_cov_bch_amb_forks0) true)
	(ai_force_low_lod sq_cov_bch_amb_forks0)
)

(script command_script cs_bch_fork0
	(ai_disregard ai_current_actor true)
	(ai_erase (ai_get_turret_ai ai_current_actor 0))
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork0_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork0_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork1
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork1_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork1_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork2
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork2_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork2_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork3
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork3_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork3_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork4
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork4_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork4_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork5
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork5_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork5_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork6
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork6_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork6_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork7
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork7_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork7_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	
(script command_script cs_bch_fork8
	(ai_disregard ai_current_actor true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 180)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_forks/fork8_0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_bch_forks/fork8_erase)
	(object_destroy (ai_vehicle_get ai_current_actor)))
	


; =================================================================================================
; FACILITY
; =================================================================================================
(global boolean b_fac_shutter_activated false)
(global boolean b_fac_deadman_kat_waiting false)
(global boolean b_fac_deadman_carter_waiting false)
(global boolean b_fac_deadman_jorge_waiting false)
; -------------------------------------------------------------------------------------------------
(script dormant fac_encounter
	(if debug (print "encounter: facility"))
	(set s_current_encounter s_fac_encounter_index)
	; set second mission segment
	(data_mine_set_mission_segment "m45_02_fac_encounter")
	
	; object management
	(object_create_folder sc_fac)
	;(object_create_folder cr_fac)
	
	; zone sets
	(zone_set_trigger_volume_enable begin_zone_set:set_silo_005_010_015 		true)
	(zone_set_trigger_volume_enable zone_set:set_silo_005_010_015 				true)
	
	; kill volumes 
	(kill_volume_disable kill_soft_bch_burglar)
	
	; ai
	(ai_place sq_unsc_fac_tr_lead)
	(ai_place sq_unsc_bch_tf0)

	; wake subsequent scripts
	;(wake fac_weapon_control)
	(wake fac_spartans_main)
	(wake fac_door_lock_return_to_breach)
	(wake fac_deadman_control)
	(wake fac_hallway_trooper_control)
	(wake md_bch_trf_spartans_coming)
	(wake fac_window_failsafe)
	
	(if
		(or
			(difficulty_is_normal)
			(difficulty_is_heroic)
			(difficulty_is_legendary)
		)
		
		(object_create elite_shield0)
	)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_fac_started true)
	; -------------------------------------------------------------------------------------------------
	
			; -------------------------------------------------
			(fac_setup_bodies)
			
			;(mus_stop mus_beach)
			(wake md_fac_tr_everybody_inside)
			(f_blip_flag fl_fac_interior blip_recon)
			(device_set_power dm_fac_entrance 1)
			(device_set_position dm_fac_entrance 1)
			; -------------------------------------------------

	(sleep_until (or
	(volume_test_players tv_objcon_fac_010)
	(>= s_objcon_fac 10)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 10)
				(begin 
					(if debug (print " ::: fac ::: objective control 010"))
					(set s_objcon_fac 10)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_020)
	(>= s_objcon_fac 20)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 20)
				(begin 
					(if debug (print " ::: fac ::: objective control 020"))
					(set s_objcon_fac 20)
					
					(wake md_fac_tr_flight_control)
					(f_unblip_flag fl_fac_interior)
					
					(ai_place sq_unsc_fac_tr_rocketcrew)
					
					
					(wake fac_trigger_bombing_00)
					
					(ai_migrate sq_unsc_bch_tf0 sq_unsc_bch_reinforce_holding0)
					
					(mus_stop mus_02)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_030)
	(>= s_objcon_fac 30)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 30)
				(begin 
					(if debug (print " ::: fac ::: objective control 030"))
					(set s_objcon_fac 30)
					
					(wake md_fac_jor_holland_said_yes)
					;(ai_place sq_cov_fac_fork)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_040)
	(>= s_objcon_fac 40)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 40)
				(begin 
					(if debug (print " ::: fac ::: objective control 040"))
					(set s_objcon_fac 40)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_050)
	(>= s_objcon_fac 50)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 50)
				(begin 
					(if debug (print " ::: fac ::: objective control 050"))
					(set s_objcon_fac 50)
					
					
					
					;(game_save)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_060)
	(>= s_objcon_fac 60)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 60)
				(begin 
					(if debug (print " ::: fac ::: objective control 060"))
					(set s_objcon_fac 60)
					
					
					(wake md_fac_tr_calls_wraith)
					
					(thespian_performance_activate thespian_deadman_kat)
					(thespian_performance_activate thespian_deadman_carter)
					(thespian_performance_activate thespian_deadman_jorge)
					
					;(bring_spartans_forward 10)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_070)
	(>= s_objcon_fac 70)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 70)
				(begin 
					(if debug (print " ::: fac ::: objective control 070"))
					(set s_objcon_fac 70)
					
					(wake md_fac_tr_through_door)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_080)
	(>= s_objcon_fac 80)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 80)
				(begin 
					(if debug (print " ::: fac ::: objective control 080"))
					(set s_objcon_fac 80)
					
					;(ai_place sq_unsc_fac_tr_hallgunners)
					;(bring_spartans_forward 10)
					(garbage_collect_now)
				)
			)
			
			; -------------------------------------------------
			;(object_create_anew c_scanner)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_090)
	(>= s_objcon_fac 90)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 90)
				(begin 
					(if debug (print " ::: fac ::: objective control 090"))
					(set s_objcon_fac 90)
					
					; -------------------------------------------------
					
					;(wake md_fac_kat_orbit)
					; -------------------------------------------------
				)
			)
			
			; -------------------------------------------------
			(object_create dm_slo_shutter)
			;(object_cinematic_visibility dm_slo_shutter true)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_100)
	(>= s_objcon_fac 100)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 100)
				(begin 
					(if debug (print " ::: fac ::: objective control 100"))
					(set s_objcon_fac 100)
					
					(wake fac_trigger_bombing_01)
					(wake md_fac_spkr_warning1)
					(mus_start mus_03)
				)
			)
			
			
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_110)
	(>= s_objcon_fac 110)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 110)
				(begin 
					(if debug (print " ::: fac ::: objective control 110"))
					(set s_objcon_fac 110)
					
					(thespian_performance_kill_by_name thespian_deadman_carter)
					(thespian_performance_kill_by_name thespian_deadman_kat)
					(thespian_performance_kill_by_name thespian_deadman_jorge)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_120)
	(>= s_objcon_fac 120)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 120)
				(begin 
					(if debug (print " ::: fac ::: objective control 120"))
					(set s_objcon_fac 120)
					
					(thespian_performance_activate thespian_controlroom_kat)
					(thespian_performance_activate thespian_controlroom_jorge)
					(thespian_performance_activate thespian_controlroom_carter)
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_130)
	(>= s_objcon_fac 130)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 130)
				(begin 
					(if debug (print " ::: fac ::: objective control 130"))
					(set s_objcon_fac 130)
					
					;(wake md_fac_tr_clear_los)
					(bring_spartans_forward 13)
				
				)
			)
			; -------------------------------------------------
	
	(sleep_until (or
	(volume_test_players tv_objcon_fac_140)
	(>= s_objcon_fac 140)) 1)
	
			; -------------------------------------------------
			(if (<= s_objcon_fac 140)
				(begin 
					(if debug (print " ::: fac ::: objective control 140"))
					(set s_objcon_fac 140)
					
					
					
				)
			)
			; -------------------------------------------------

	
	;(sleep_until (= b_fac_shutter_activated true) 1)
	(set b_fac_completed true)
)

(script dormant fac_window_failsafe
	(branch
		(>= s_objcon_fac 70) (branch_abort)
	)
	
	(if debug (print "player went through the window"))
	
	(sleep_until (volume_test_players tv_objcon_fac_070) 1)
	
	(sleep_forever fac_hallway_trooper_control)
	(wake show_objective_flight_control)
	(f_unblip_flag fl_fac_interior)
					
	(ai_migrate sq_unsc_bch_tf0 sq_unsc_bch_reinforce_holding0)
					
	(mus_stop mus_02)
	
	(set s_objcon_fac 70)
	
	
	
	
)

(script dormant fac_door_lock_return_to_breach
	(sleep_until (>= (current_zone_set) s_zoneindex_silo) 1)
	(if debug (print "player is loading silo zone"))
	(set b_bch_infinite_kill true)
	(device_set_position_immediate dm_fac_breach_exit 0)
	(device_set_power dm_fac_breach_exit 0)
	
	(zone_set_trigger_volume_enable zone_set:set_facility_001_005_010 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_facility_001_005_010 	false)
	
	(game_save_no_timeout)
)


; ALLIES
; -------------------------------------------------------------------------------------------------
(script dormant fac_spartans_main
	(ai_set_objective gr_unsc_spartans obj_unsc_fac)
)

(script command_script cs_fac_bch_post_reinforcements
	(cs_go_by ps_fac_hall_troopers/p0 ps_fac_hall_troopers/p0)
	(cs_go_by ps_fac_hall_troopers/p1 ps_fac_hall_troopers/p1)
	(cs_go_by ps_fac_hall_troopers/p2 ps_fac_hall_troopers/p2)
	(cs_go_by ps_fac_hall_troopers/p3 ps_fac_hall_troopers/p3)
	(cs_go_by ps_fac_hall_troopers/p4 ps_fac_hall_troopers/p4)
	(cs_go_by ps_fac_hall_troopers/p5 ps_fac_hall_troopers/p5)
)

(script dormant fac_hallway_trooper_control
	(sleep_until (>= s_objcon_fac 10) 1)
	(ai_place sq_unsc_fac_posthallway)
	;(wake md_fac_tr_clear_los)
)



; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant fac_shutter_control
	(sleep_until b_fac_shutter_activated 1 (* 30 20))
	(set b_fac_shutter_activated true)
)

(script static void fac_setup_bodies
	(object_create_folder sc_fac_bodies)
	(scenery_animation_start body2 objects\characters\marine\marine e3_deadbody_02)
	;(scenery_animation_start body3 objects\characters\marine\marine e3_deadbody_03)
	(scenery_animation_start body4 objects\characters\marine\marine e3_deadbody_04)
	(scenery_animation_start body5 objects\characters\marine\marine e3_deadbody_05)
	(scenery_animation_start body6 objects\characters\marine\marine e3_deadbody_06)
	(scenery_animation_start body7 objects\characters\marine\marine e3_deadbody_07)
	(scenery_animation_start body8 objects\characters\marine\marine e3_deadbody_08)
	(scenery_animation_start body9 objects\characters\marine\marine e3_deadbody_09)
	(scenery_animation_start body10 objects\characters\marine\marine e3_deadbody_10)
	(scenery_animation_start body11 objects\characters\marine\marine e3_deadbody_11)
	(scenery_animation_start body12 objects\characters\marine\marine e3_deadbody_12)
	(scenery_animation_start body13 objects\characters\marine\marine e3_deadbody_13)
	(scenery_animation_start body14 objects\characters\marine\marine e3_deadbody_14)
	(scenery_animation_start body15 objects\characters\marine\marine e3_deadbody_15)
	(scenery_animation_start body16 objects\characters\marine\marine e3_deadbody_16)
	(scenery_animation_start body17 objects\characters\marine\marine e3_deadbody_17)
	(scenery_animation_start body18 objects\characters\marine\marine e3_deadbody_18)
	(scenery_animation_start body19 objects\characters\marine\marine e3_deadbody_19)
	(scenery_animation_start body20 objects\characters\marine\marine e3_deadbody_20)
	
	;(object_create_folder wp_fac)
)

(script static void fac_test_deadman
	(garbage_collect_unsafe)
	(fac_deadman_spawn)
)

(script dormant fac_deadman_control
	(sleep_until (>= s_objcon_fac 90) 1)
	(fac_deadman_spawn)

)
(script static void fac_deadman_spawn
	(ai_place sq_unsc_fac_deadman0)
	(sleep 1)
	(damage_new levels\solo\m45\fx\facility_deadman_impulse.damage_effect fl_fac_damage)
	(sleep 5)
	
	; place his killer and play the vignette
	(ai_place sq_cov_fac_deadman0)
	(sleep 1)
	;(thespian_performance_activate thespian_deadman_elite)
	;(thespian_performance_setup_and_begin thespian_deadman_elite "" 0)
	;(ai_set_targeting_group sq_cov_fac_hall_elite0 4 false)
	;(ai_set_targeting_group sq_unsc_fac_deadman0 4 false)	
)

; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------
(script command_script cs_fac_wraith_shelling
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_fac_wraith/target0)
				(cs_shoot_point true ps_fac_wraith/target1)
				(cs_shoot_point true ps_fac_wraith/target2))
			(sleep 180)
		0)
	1)
)

(script command_script cs_fac_fork
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 1)
	(f_load_fork_cargo (ai_vehicle_get ai_current_actor) "large" sq_cov_fac_wraith NONE NONE)
	(cs_fly_by ps_fac_fork/entry2)
	(cs_fly_by ps_fac_fork/entry1)
	(cs_fly_by ps_fac_fork/entry0)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face ps_fac_fork/hover ps_fac_fork/land_facing 1)
	(sleep 30)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face ps_fac_fork/land ps_fac_fork/land_facing 1)
	(f_unload_fork_cargo (ai_vehicle_get ai_current_actor) "large")
	(sleep 60)
	(cs_fly_to_and_face ps_fac_fork/hover ps_fac_fork/land_facing 1)
	(sleep 30)
	(cs_fly_by ps_fac_fork/exit0)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_fac_fork/exit1)
	(cs_fly_by ps_fac_fork/erase)
	(ai_erase ai_current_squad)
)



; =================================================================================================
; LAUNCH
; =================================================================================================
(global boolean b_lnc_player_in_sabre false)
(global boolean b_lnc_start_cleanup false)
; -------------------------------------------------------------------------------------------------
(script dormant lnc_encounter
	(if debug (print "encounter: launch"))
	(set s_current_encounter s_lnc_encounter_index)
	; (data_mine_set_mission_segment "launch")
	
	(kill_volume_enable kill_silo)
	; object management
	
	
	(if (difficulty_is_legendary)
		(object_create elite_shield1))
		
	; scripts
	(wake lnc_boarding_control)
	(wake lnc_shutter_control)
	(wake lnc_bombingrun_control)
	(wake lnc_zoneset_control)
	(wake lnc_light_control)
	(wake lnc_trooper_salute_control)
	(wake lnc_trooper_control)
	;(wake lnc_trooper_catwalk_control)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_lnc_started true)
	; -------------------------------------------------------------------------------------------------
			
			; -------------------------------------------------
			;(thespian_performance_setup_and_begin thespian_controlroom_kat "" 0)
			;(thespian_performance_setup_and_begin thespian_controlroom_jorge "" 0)
			;(thespian_performance_setup_and_begin thespian_controlroom_carter "" 0)
			
			
			(wake md_lnc_car_get_to_sabre)
			;(device_set_power dm_fac_cc_exit 1)
			;(device_set_position dm_fac_cc_exit 1)
			;(ai_place sq_unsc_lnc_tr_exit)
			;(thespian_performance_kill_by_ai sq_jorge)
			;(ai_set_objective sq_jorge obj_unsc_lnc)
			;(wake md_slo_car_get_to_sabre)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_lnc_010) 1)
	(if debug (print "lnc: objective control 010"))
	(set s_objcon_lnc 10)
	
			; -------------------------------------------------
			(bring_spartans_forward 6)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_lnc_020) 1)
	(if debug (print "lnc: objective control 020"))
	(set s_objcon_lnc 20)	
	
	(sleep_until (volume_test_players tv_objcon_lnc_030) 1)
	(if debug (print "lnc: objective control 030"))
	(set s_objcon_lnc 30)
	
	(sleep_until (volume_test_players tv_objcon_lnc_040) 1)
	(if debug (print "lnc: objective control 040"))
	(set s_objcon_lnc 40)
	
	(sleep_until (volume_test_players tv_objcon_lnc_050) 1)
	(if debug (print "lnc: objective control 050"))
	(set s_objcon_lnc 50)
	
	
)

(script dormant lnc_zoneset_control
	(sleep_until (>= (current_zone_set) s_zoneindex_silo) 1)
	(sleep 1)
	
	(if debug (print "shutting off set_facility_001_005_010 triggers"))
	(zone_set_trigger_volume_enable zone_set:set_facility_001_005_010 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_facility_001_005_010 	false)
	
)

(script dormant lnc_bombingrun_control
	(sleep_until (> (device_get_position dm_slo_shutter) 0.47) 1)
	(if debug (print "silo bombing run..."))
	;(set b_bch_bombingrun_complete false)
	(start_lnc_bombingrun)
)

(script static void lnc_setup_silo
	(object_create sc_slo_sabre)
	(object_cannot_take_damage sc_slo_sabre)
	(object_create_folder sc_lnc)
)

(script dormant lnc_trooper_salute_control
	(sleep_until (> (device_get_position dm_slo_shutter) 0) 1)
	
	(ai_place sq_unsc_lnc_salute0)
	
	(thespian_performance_activate thespian_lnc_salute0)
	(thespian_performance_activate thespian_lnc_salute1)
)

(script dormant lnc_trooper_catwalk_control
	(sleep_until (> (device_get_position dm_slo_shutter) 0) 1)
	
	(ai_place sq_unsc_lnc_catwalk0)
	
	(thespian_performance_activate thespian_lnc_catwalk0)
)

(script dormant lnc_boarding_control
	(sleep_until (volume_test_players tv_lnc_platform) 1)
	(if debug (print "launch: player has entered sabre"))
			
			; -------------------------------------------------
			(set b_lnc_player_in_sabre true)
			(device_set_power c_launch 0)
			(f_unblip_flag fl_launch)
			
			(mus_stop mus_04)
			
			(cinematic_enter 045la_blastoff true)
			
			(sleep 31)
			
			
			(set b_lnc_start_cleanup true)
			
			(lnc_bombingrun_kill)
			(ai_erase_all)
			
			(teleport_players
				fl_lnc_cinematic0
				fl_lnc_cinematic1
				fl_lnc_cinematic2
				fl_lnc_cinematic3
			)
			
			
			(kill_volume_disable kill_silo)
			
			(object_destroy sc_slo_sabre)
			(object_destroy_folder sc_lnc_lights)
			(object_destroy sc_slo_sabre)
			(object_destroy_folder dm_bch_pods)
			;(object_destroy_folder dm_ambient_pods)
			(object_destroy_folder sc_bch)
			(object_destroy_folder cr_beach)
			(object_destroy_folder sc_lnc)
			(object_destroy murderer)
			(object_destroy_folder wp_fac)
			(object_destroy_folder sc_fac)
			;(object_destroy_folder wp_fac)
			;(object_destroy murderer)
			(object_destroy_folder seraph_impact)
			
			
			; ai removal 
			(ai_erase gr_unsc_spartans)
			(ai_erase gr_unsc_bch)
			(ai_erase gr_cov_bch)
			(ai_erase gr_command_allies)
			(ai_erase gr_command_cov)
			(ai_erase gr_launch_allies)
			(ai_erase gr_launch_cov)	
			
			(garbage_collect_unsafe)
		
			(f_play_cinematic_advanced "045la_blastoff" "set_launch_010_015_019" "set_wafercombat_030")
			(sleep 5)

			;(switch_zone_set set_wafer)

			;(object_create savannah_wafer)		
			; -------------------------------------------------
	
	(set b_lnc_completed true)
)

(script command_script cs_lnc_carter_post
	(cs_enable_looking 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(cs_walk 1)
	(cs_push_stance alert)
	(sleep 60)
	(cs_enable_moving 1)
	
	(sleep_until
		(begin
			(sleep_until (> (objects_distance_to_flag (ai_actors ai_carter) fl_lnc_carter) 2))
			(cs_go_to ps_thespian_slo_control/carter_dest)
			(cs_face true ps_thespian_slo_control/sabre)
			(sleep 60)
			(cs_face false ps_thespian_slo_control/sabre)
		0)
	1)
)


(script command_script cs_lnc_kat_post
	(cs_enable_looking 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(cs_walk 1)
	(cs_push_stance alert)
	(sleep 60)
	(cs_enable_moving 1)
	
	(sleep_until
		(begin
			(sleep_until (> (objects_distance_to_flag (ai_actors ai_kat) fl_lnc_kat) 2))
			(cs_go_to ps_thespian_slo_control/kat_dest)
			(cs_face true ps_thespian_slo_control/sabre)
			(sleep 60)
			(cs_face false ps_thespian_slo_control/sabre)
		0)
	1)
)

(script dormant lnc_shutter_control
	(sleep_until (>= s_objcon_lnc 20))
	(sleep (random_range 30 90))
	
	(lnc_setup_silo)
	(sleep 1)
	
	(mus_stop mus_03)
	(mus_start mus_04)
	
	(device_set_position dm_slo_shutter 1)
	(sleep (random_range (* 30 6) (* 30 9)))
	(device_set_power dm_fac_cc_exit 1)
	(device_set_position dm_fac_cc_exit 1)
)

; ALLIES
; -------------------------------------------------------------------------------------------------
(script static void lnc_spartan_spawn
	(if debug (print "::: spawning control room spartans"))
	(ai_erase gr_unsc_spartans)
	(ai_place sq_carter/fac_cc)
	(ai_place sq_jorge/fac_cc)
	(ai_place sq_kat/fac_cc)
	(sleep 1)
	
	(set ai_carter sq_carter)
	(set ai_jorge sq_jorge)
	(set ai_kat sq_kat)
	
	(ai_cannot_die ai_carter true)
	(ai_cannot_die ai_jorge true)
	(ai_cannot_die ai_kat true)
)


(script static void lnc_spartan_setup
	(if debug (print "::: spartans now in obj_unsc_lnc"))
	(ai_set_objective gr_unsc_spartans obj_unsc_lnc)
)

(script dormant lnc_trooper_control
	(sleep_until (> (device_get_position dm_slo_shutter) 0) 1)
	
	(if debug (print "spawning catwalk troopers"))
	
	(ai_place sq_unsc_lnc_pelican0)
	(ai_place sq_unsc_lnc_catwalk0)
	
	(object_create murderer)
	(ai_place sq_unsc_lnc_trophyhunter0)
	
	(ai_place sq_unsc_lnc_evac0)
)

(script command_script cs_lnc_catwalk_trooper0
	(cs_push_stance alert)
	(sleep_until (>= (device_get_position dm_slo_shutter) 0.3) 1)
	
		; -------------------------------------------------
		(cs_custom_animation objects\characters\marine\marine "global_alert:rifle:survey_environment" true)
		(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		; -------------------------------------------------
		
	(sleep_until b_lnc_bombing_started 1)
	
		; -------------------------------------------------
		(sleep (random_range 3 10))
		(cs_custom_animation objects\characters\marine\marine "global_alert:rifle:off_balance:var2" true)
		(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		(unit_stop_custom_animation (ai_get_unit ai_current_actor))
		(sleep (random_range 5 10))
		
		(cs_push_stance none)
		(cs_force_combat_status 3)
		
		;(cs_go_by ps_thespian_slo/catwalk_left_exit0 ps_thespian_slo/catwalk_left_exit0)
		(cs_go_by ps_thespian_slo/catwalk_left_exit1 ps_thespian_slo/catwalk_left_exit1 1)
		(cs_go_by ps_thespian_slo/catwalk_left_erase ps_thespian_slo/catwalk_left_erase 1)
		;(ai_erase ai_current_actor)
		(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p_l")
		; -------------------------------------------------
)

(script command_script cs_lnc_catwalk_trooper1
	(cs_push_stance alert)
	
	
	(sleep_until (>= (device_get_position dm_slo_shutter) 0.4) 1)
	
		; -------------------------------------------------
		(cs_custom_animation objects\characters\marine\marine "alert:rifle:posing_var1" true)
		(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		; -------------------------------------------------
		
	(sleep_until b_lnc_bombing_started 1)
	
		; -------------------------------------------------
		(sleep (random_range 3 10))
		(cs_custom_animation objects\characters\marine\marine "global_alert:rifle:off_balance:var1" true)
		(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		(unit_stop_custom_animation (ai_get_unit ai_current_actor))
		(sleep (random_range 5 10))
		
		(cs_push_stance none)
		(cs_force_combat_status 3)
		
		(cs_go_by ps_thespian_slo/catwalk_left_exit1 ps_thespian_slo/catwalk_left_exit1)
		(cs_go_by ps_thespian_slo/catwalk_left_erase ps_thespian_slo/catwalk_left_erase)
		;(ai_erase ai_current_actor)
		(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p_l")
		; -------------------------------------------------
		
)



(script command_script cs_lnc_catwalk_trooper2
	(cs_push_stance alert)
	
	(sleep_until (>= (device_get_position dm_slo_shutter) 0.6) 1)
	
		; -------------------------------------------------
		(cs_walk 1)
		(cs_go_to ps_thespian_slo/catwalk_trooper2)
		; -------------------------------------------------
		
	(sleep_until b_lnc_bombing_started 1)
		
		; -------------------------------------------------
		(sleep (random_range 3 10))
		(cs_custom_animation objects\characters\marine\marine "global_alert:rifle:off_balance:var1" true)
		(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		(unit_stop_custom_animation (ai_get_unit ai_current_actor))
		(sleep (random_range 5 10))
		
		(cs_push_stance none)
		(cs_force_combat_status 3)
		
		(cs_go_by ps_thespian_slo/catwalk_right_exit1 ps_thespian_slo/catwalk_right_exit1)
		(cs_go_by ps_thespian_slo/catwalk_right_erase ps_thespian_slo/catwalk_right_erase)
		;(ai_erase ai_current_actor)
		(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p_r")
		; -------------------------------------------------
)

(script command_script cs_lnc_trooper_evac_left
	(sleep 120)
	(cs_go_by ps_thespian_slo/catwalk_left_erase ps_thespian_slo/catwalk_left_erase)
	;(ai_erase ai_current_actor)
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p_l")
)


(script command_script cs_lnc_trooper_evac_right
	(cs_go_by ps_thespian_slo/catwalk_right_erase ps_thespian_slo/catwalk_right_erase)
	;(ai_erase ai_current_actor)
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p_r")
)

(script command_script cs_lnc_trooper_trophyhunter
	(cs_push_stance alert)
	(cs_enable_moving false)
	(cs_enable_looking false)
	(sleep_until 
		(and
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 5.5)
			(> (device_get_position dm_fac_cc_exit) 0.5)
		)		
	1)
	(sleep (random_range 10 15))
	(cs_custom_animation objects\characters\marine\marine "global_alert:rifle:kick_enemybody" true)
	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
	(unit_stop_custom_animation (ai_get_unit ai_current_actor))
	
	
)

(script command_script cs_lnc_trooper_evac_test
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_spawn_point sq_unsc_lnc_pelican0/pilot) "pelican_p")
)

(script command_script cs_lnc_pelican
	(cs_ignore_obstacles 1)
	(vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) "" false false)
	(vehicle_hover (ai_vehicle_get ai_current_actor) 1)
	(unit_open (ai_vehicle_get ai_current_actor))
	
	(sleep (* 30 47))
	;(sleep 30)
	(vehicle_hover (ai_vehicle_get ai_current_actor) 0)
	(cs_fly_by ps_lnc_pelican/exit0)
	(unit_close (ai_vehicle_get ai_current_actor))
	(cs_fly_by ps_lnc_pelican/exit1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 180)
	(cs_fly_by ps_lnc_pelican/erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
	
)


; EXIT TROOPERS
; -------------------------------------------------------------------------------------------------
(script command_script cs_lnc_tr_exit0
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to ps_lnc_troopers/exit0)
	(sleep_forever)
)

(script command_script cs_lnc_tr_exit1
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to ps_lnc_troopers/exit1)
	(sleep_forever)
)

; JORGE
; -------------------------------------------------------------------------------------------------
(script command_script cs_lnc_jorge_p0
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to ps_lnc_jorge/p0)
	(cs_face_player true)
	(sleep_forever)
)

(script command_script cs_lnc_jorge_p1
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to ps_lnc_jorge/p1)
	(cs_face_player true)
	(sleep_forever)
)

(script command_script cs_lnc_jorge_p2
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to ps_lnc_jorge/p2)
	(cs_face_player true)
	(sleep_forever)
)

; =================================================================================================
; WAFER
; =================================================================================================
(global boolean b_waf_sabre_tut_complete false)
(global boolean b_waf_sabre_tut_skipped false)
(global short s_waf_min_sabres 4)
; -------------------------------------------------------------------------------------------------

(script dormant waf_encounter
	(if debug (print "encounter: wafer"))
	(set s_current_encounter s_waf_encounter_index)
	; set third mission segment
	(data_mine_set_mission_segment "m45_03_waf_encounter")
	(game_insertion_point_unlock 1)
	
	; sound scripting
	(sound_disable_acoustic_palette m45_ext_int)
	(sound_disable_acoustic_palette m45_base_controlroom)
	(sound_looping_start sound\levels\solo\m45\space_loop\space_loop NONE 1) ; do this for corvette too	
	(sound_disable_acoustic_palette space_filter_loop)

	(physics_set_gravity 0)
	
	; zone sets
	(zone_set_trigger_volume_enable zone_set:set_facility_001_005_010 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_facility_001_005_010 	false)
	(zone_set_trigger_volume_enable begin_zone_set:set_silo_005_010_015 		false)
	(zone_set_trigger_volume_enable zone_set:set_silo_005_010_015 				false)
	
	; object management
	(soft_ceiling_enable corvette false)
	(object_create_folder sc_waf_bays)
	(object_create_folder cr_waf)
	
	; scene setup
	(waf_savannah_dock)
	(sfx_attach_chatter)
	
	; slam player into driver seat 
	(create_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)	
	(load_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)	
		
	(set_sabre_respawns true)
	(set player_respawn_check_airborne 0)
	
	(wake waf_ejection_killer)
	
	; ai
	(ai_place sq_unsc_waf_sbr_start)
	(ai_set_clump sq_unsc_waf_sbr_start CLUMP_SABRES)
	(ai_place sq_unsc_waf_aa)
	(ai_set_clump sq_unsc_waf_aa CLUMP_SAVANNAH_AA)
	
	; scripts
	(wake waf_garbage_collector)
	(wake waf_savannah_engine_control)
	(wake sabre_seat_exit_control)
	(wake waf_save_loop)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_waf_started true)
	; -------------------------------------------------------------------------------------------------
	
			; Intro & Tutorial
			; -------------------------------------------------
			;(mus_play mus_f_low)			
			(replenish_players)
			(sleep 30)
			(cinematic_exit 045la_blastoff true)	
			(sleep 60)
			(game_save_immediate)
			(wake show_chapter_title_wafer)
			(md_waf_hol_intro)
			
			(md_sabre_tutorial_start)
			; tutorial
			(if 
				(or
					(difficulty_is_heroic_or_higher)
					(= (game_insertion_point_get) 1))
					
				; difficulty is heroic or legendary -- skip it
				(begin
					(if debug (print "-=-=- skipping sabre tutorial -=-=-"))
					(set b_saber_tutorial_complete true)
					(set b_waf_sabre_tut_skipped true)
				)
				
				; difficulty is easy or normal - do the tutorial
				(wake sabre_tutorial)
			)
			; -------------------------------------------------
			
	(sleep_until b_saber_tutorial_complete)
	
	(if (= b_waf_sabre_tut_skipped true)
		(sleep_until (>= (device_get_position dm_savannah_wafer) 0.75))	; player has skipped, speed this up
		(sleep_until (>= (device_get_position dm_savannah_wafer) 0.95))	; player has not skipped, wait
	)
	
			; WAVE #1: Banshees
			; -------------------------------------------------
			;(mus_stop mus_f_low)
			;(mus_play mus_new1b_hi)
			(waf_replenish_sabres)
			
			; jorge calls out contacts, then show the player's objective
			; contacts? it's the damned covenant
			(md_waf_jor_contacts)
			(wake show_objective_wafer_defense)
			(set b_waf_attempt_save true)
				(sleep (* 30 2))
			
			(f_blip_flag fl_wafer_signatures blip_recon)
			(show_fighter_warning)
				(sleep (* 30 5))
			
			(garbage_collect_now)
			(waf_banshee_spawn_immediate 15)
				(sleep (* 30 2))
			
			(f_unblip_flag fl_wafer_signatures)
			(clear_fighter_warning)
			(wake md_waf_an9_batteries_at_56)
			; -------------------------------------------------
	
	(sleep_until (<= (ai_living_count gr_cov_waf) 3))
	(waf_blip_living_covenant)
	(sleep_until (<= (ai_living_count gr_cov_waf) 0))
	
			; -------------------------------------------------
			(set b_waf_attempt_save true)
			(sleep (random_range 60 90))
			
			(waf_replenish_sabres)
			(wake md_waf_an9_warning_fighter)
			
			; set fourth mission segment
			(data_mine_set_mission_segment "m45_04_waf_wave2")
			
			(f_blip_flag fl_wafer_signatures blip_recon)
			(show_fighter_warning)
			(sleep (* 30 5))
			(garbage_collect_now)
			(waf_seraph_spawn_immediate 4)
			(sleep (* 30 2))
			(f_unblip_flag fl_wafer_signatures)
			(clear_fighter_warning)
			(wake show_tutorial_seraph_shields)
			(wake md_waf_an9_batteries_at_79)
			; -------------------------------------------------
	
	(sleep_until (<= (ai_living_count gr_cov_waf) 3))
	(waf_blip_living_covenant)	
	(sleep_until (<= (ai_living_count gr_cov_waf) 0))
	
			; -------------------------------------------------
			(sleep (random_range 30 95))
			;(new_mission_objective 6 ct_obj_wafer_online)
			(wake show_objective_wafer_guns_online)
			(wake md_waf_sav_skies_clear)
			(waf_replenish_sabres)
			
			
			(set b_waf_attempt_save true)
			;(mus_alt mus_wafer)
			
			(wake md_waf_an9_station_defenses_online)
			(sleep (* 30 13))
			
			(if debug (print "waf: mega wave 1 incoming..."))
			(f_blip_flag fl_wafer_signatures blip_recon)
			(show_fighter_warning)
			
			(sleep (* 30 5))
	
	;*
			(garbage_collect_now)
			(waf_banshee_spawn_immediate 12)
			
			(sleep (* 30 2))
			
			(f_unblip_flag fl_wafer_signatures)
			(clear_fighter_warning)
			; -------------------------------------------------
	
	(sleep_until (<= (ai_living_count gr_cov_waf) 3))
	(waf_blip_living_covenant)	
	(sleep_until (<= (ai_living_count gr_cov_waf) 0))	
	
			; -------------------------------------------------
			(if debug (print "waf: mega wave 2 incoming..."))
			(md_waf_an9_warning_warning_bogeys)
			(game_save)
			(waf_replenish_sabres)
			(f_blip_flag fl_wafer_signatures blip_recon)
			(show_fighter_warning)
			(sleep (* 30 5))
			(garbage_collect_now)
			
	*;
			(if
				(or
					(difficulty_is_heroic_or_higher)
					(>= (game_coop_player_count) 2)
				)
			
				; game is heroic+ or coop
				; -------------------------------------------------
				(begin
					(if (difficulty_is_legendary)
					
						; game is legendary and/or coop legendary
						; -------------------------------------------------
						(begin
							(if debug (print "spawning legendary wave"))
							(waf_seraph_spawn_immediate 8)
							(waf_banshee_spawn_immediate 18)
						)
						
						; game is heroic
						(begin
							(if debug (print "spawning heroic or coop wave"))
							(waf_seraph_spawn_immediate 6)
							(waf_banshee_spawn_immediate 20)
						)
					)
				)
				
				; game is normal- and not coop
				; -------------------------------------------------
				(begin
					(if debug (print "spawning normal wave"))
					(waf_seraph_spawn_immediate 4)
					(waf_banshee_spawn_immediate 22)
				)
			)
			(sleep (* 30 2))
			(f_unblip_flag fl_wafer_signatures)
			(clear_fighter_warning)
			; -------------------------------------------------
	
	(sleep_until (<= (ai_living_count gr_cov_waf) 6))
	;(waf_blip_living_covenant)		
	;(sleep_until (<= (ai_living_count gr_cov_waf) 0))	
	;*
			; -------------------------------------------------
			(if debug (print "waf: mega wave 3 incoming..."))
			
			(game_save)
			(waf_replenish_sabres)
			(f_blip_flag fl_wafer_signatures blip_recon)
			(show_fighter_warning)
			;(show_warning ct_warning_fighters)
			(sleep (* 30 5))
			(garbage_collect_now)
			(waf_seraph_spawn_immediate 8)
			(waf_banshee_spawn_immediate 16)
			(garbage_collect_now)
			
			(sleep (* 30 2))
			(f_unblip_flag fl_wafer_signatures)
			(clear_fighter_warning)
			; -------------------------------------------------
	
	*;
	(sleep_until (<= (ai_living_count gr_cov_waf) 4))
	
			; -------------------------------------------------
			(if debug (print "waf: bringing in phantoms..."))
			(wake waf_phantom_wave_control)	
			; set fifth mission segment
			(data_mine_set_mission_segment "m45_05_waf_wave3")
			(wake waf_final_fighter_wave_control)	
			(wake waf_phantom_wave_save)
			; -------------------------------------------------
		
	(sleep_until 
		(and
			(<= (ai_living_count gr_cov_waf_phantom) 0) 
			(> (ai_spawn_count gr_cov_waf_phantom) 0)
			(= b_waf_final_fighters_spawned true)
		)
	30 (* 30 300))
	
			; -------------------------------------------------
			(if (> (ai_living_count gr_cov_waf) 0)
				(cs_run_command_script gr_cov_waf cs_waf_warpout)
				
				;(begin
					;(sleep (random_range 60 120))
					;(ai_kill gr_cov_waf)
				;)
			)
			(if debug (print "waf: waves complete..."))
			
			; -------------------------------------------------
	(sleep_until (<= (ai_living_count gr_cov_waf) 0) 30 (* 30 30))
	(ai_erase gr_cov_waf)
	
	;;(mus_stop mus_new1b_hi)
	(sleep 90)
	(set b_waf_completed true)
)	

(global boolean b_waf_attempt_save false)
(script dormant waf_save_loop
	(branch
		(= b_waf_completed true) (branch_abort)
	)
	
	(sleep_until
		(begin
			(sleep_until (= b_waf_attempt_save true))
			(game_save_no_timeout)
			(set b_waf_attempt_save false)
		0)
	1)
)

(script dormant waf_ejection_killer
	(sleep 30)
	(sleep_until
		(begin
		
			(ejection_kill_player player0)
			(ejection_kill_player player1)
			(ejection_kill_player player2)
			(ejection_kill_player player3)
				
			(sleep 30)
		0)
	1)
)

(script static void (ejection_kill_player (player p))
	(if 
		(and
			(player_is_in_game p)
			(not (unit_in_vehicle p))
		)
				
		(begin
			(if debug (print "trying to kill a player... delaying in case it's actually ok"))
			(sleep 5)
			(if 
				(and
					(player_is_in_game p)
					(not (unit_in_vehicle p))
				)
					
				(unit_kill p)
			)
		)
	)
)

(script dormant waf_phantom_wave_save
	(sleep_until (>= (ai_spawn_count gr_cov_waf_phantom) 5))
	(sleep_until (<= (ai_living_count gr_cov_waf_phantom) 3))
	(game_save_no_timeout)
)

(script command_script cs_waf_aa_hold
	(cs_enable_targeting 0)
	(cs_enable_looking 0)
	(cs_shoot 0)
	(sleep_forever)
)

(script dormant waf_savannah_engine_control
	(object_function_set 0 0.2)
	;(object_set_function_variable dm_savannah_wafer "frigate_engines" 0.5 1)
	(sleep_until (>= (device_get_position dm_savannah_wafer) 0.8))
	;(object_set_function_variable dm_savannah_wafer "frigate_engines" 0.05 60)
	(object_function_set 0 0.01)
	; throttle fx
)

(global boolean b_waf_final_fighters_spawned false)
(script dormant waf_final_fighter_wave_control
	(sleep (random_range (* 30 20) (* 30 30)))
	(if (or (difficulty_is_heroic_or_higher) (game_is_cooperative))
		(begin
			(waf_banshee_spawn_immediate 7)
			(waf_seraph_spawn_immediate 3)
		)
		
		(begin
			(waf_banshee_spawn_immediate 6)
			(waf_seraph_spawn_immediate 1)
		)
	)
	(set b_waf_final_fighters_spawned true)
)

; PHANTOM WAVE CONTROL
; -------------------------------------------------------------------------------------------------
(global boolean b_waf_phantoms_in_position false)
(global boolean b_waf_phantom_torpedoes_away false)
(global boolean b_waf_phantoms_defeated false)
; -------------------------------------------------------------------------------------------------
(script dormant waf_phantom_wave_control

	; wake mission dialogue scripts
	(wake md_waf_an9_gunboats_in_position)
	(wake md_waf_phantom_torpedoes_away)
	
	; notify player waves are incoming and mark the inbound vectors
	(wake waf_phantom_blip)
	(set b_waf_attempt_save true)
	(md_waf_incoming_phantoms_inbound)
	
	; spawn the phantoms
	(sleep (random_range 100 150))
	(wake waf_phantom_spawn_control)
	(sleep_until (script_finished waf_phantom_spawn_control))
	
	; mark the phantoms
	(sleep (random_range 30 60))
	(md_waf_an9_phantoms_arrived)
	(f_blip_object (ai_vehicle_get sq_cov_waf_ph_top_left/pilot) 14)
	(f_blip_object (ai_vehicle_get sq_cov_waf_ph_top_mid/pilot) 14)
	(f_blip_object (ai_vehicle_get sq_cov_waf_ph_top_right/pilot) 14)
	(f_blip_object (ai_vehicle_get sq_cov_waf_ph_bottom_right/pilot) 14)
	(f_blip_object (ai_vehicle_get sq_cov_waf_ph_bottom_left/pilot) 14)
	(set b_waf_attempt_save true)
	
	(sleep_until 
		(and 
			(f_ai_is_defeated sq_cov_waf_ph_top_left) 
			(f_ai_is_defeated sq_cov_waf_ph_top_right)
			(f_ai_is_defeated sq_cov_waf_ph_top_mid)
			(f_ai_is_defeated sq_cov_waf_ph_bottom_right)
			(f_ai_is_defeated sq_cov_waf_ph_bottom_left)
		)
	)
	
	(set b_waf_phantoms_defeated true)
	
	; cleanup
	;(sleep_forever md_waf_an9_gunboats_in_position)
	;(sleep_forever md_waf_phantom_torpedoes_away)
	
)

(script dormant waf_phantom_spawn_control
	(begin_random
		(begin
			(ai_place sq_cov_waf_ph_top_left)
			(ai_set_clump sq_cov_waf_ph_top_left CLUMP_SERAPHS)
			(sleep (random_range 20 45)))
			
		(begin
			(ai_place sq_cov_waf_ph_top_right)
			(ai_set_clump sq_cov_waf_ph_top_right CLUMP_SERAPHS)
			(sleep (random_range 20 45)))
			
		(begin
			(ai_place sq_cov_waf_ph_top_mid)
			(ai_set_clump sq_cov_waf_ph_top_mid CLUMP_SERAPHS)
			(sleep (random_range 20 45)))
			
		(begin
			(ai_place sq_cov_waf_ph_bottom_left)
			(ai_set_clump sq_cov_waf_ph_bottom_left CLUMP_SERAPHS)
			(sleep (random_range 20 45)))
			
		(begin
			(ai_place sq_cov_waf_ph_bottom_right)
			(ai_set_clump sq_cov_waf_ph_bottom_right CLUMP_SERAPHS)
			(sleep (random_range 20 45)))
	)
	
	
)

(script dormant waf_phantom_blip
	(sleep 60)
	(begin_random
		(f_callout_and_hold_flag fl_wafer_phantom_top_left 		blip_hostile_vehicle)
		(f_callout_and_hold_flag fl_wafer_phantom_top_mid 		blip_hostile_vehicle)
		(f_callout_and_hold_flag fl_wafer_phantom_top_right		blip_hostile_vehicle)
		(f_callout_and_hold_flag fl_wafer_phantom_bottom_right 	blip_hostile_vehicle)
		(f_callout_and_hold_flag fl_wafer_phantom_bottom_left	blip_hostile_vehicle)
	)
)


; PHANTOM WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global real r_waf_ph_firingpos_threshold 3.0)
(global boolean b_waf_ph_missile_armageddon false)
; -------------------------------------------------------------------------------------------------

; TOP LEFT
; -------------------------------------------------
(script command_script cs_waf_ph_top_left
	(cs_stack_command_script ai_current_actor cs_phantom_warp)
	(sleep 1)
	
	(if (not b_waf_ph_missile_armageddon)
		(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_hold))
	
	(f_unblip_flag fl_wafer_phantom_top_left)
	
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed r_phantom_approach_speed)
	(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_left ps_waf_phantoms/target_top_left_1 r_waf_ph_firingpos_threshold)
	
	(if debug (print "waf: top left phantom has reached its firing position..."))
	(set b_waf_phantoms_in_position true)
	(sleep (random_range 120 150))
	
	(if (not b_waf_ph_missile_armageddon)
		(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_attack_top_left))
	
	
	(sleep_until
		(begin
			(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_left ps_waf_phantoms/aim_mid_left r_waf_ph_firingpos_threshold)
			(sleep (random_range 300 400))
		0)
	1)
)

(script command_script cs_waf_phg_attack_top_left
	(if debug (print "waf: phantom torpodoes incoming to top left aa gun..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(set b_waf_phantom_torpedoes_away true)
	(cs_shoot_point true ps_waf_phantoms/target_top_left_1)
	(sleep_forever)
)


; TOP MID
; -------------------------------------------------
(script command_script cs_waf_ph_top_mid
	(cs_stack_command_script ai_current_actor cs_phantom_warp)
	(sleep 1)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_hold)

	(f_unblip_flag fl_wafer_phantom_top_mid)

	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed r_phantom_approach_speed)
	(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_mid ps_waf_phantoms/target_top_mid_1 r_waf_ph_firingpos_threshold)
	
	(if debug (print "waf: top mid phantom has reached its firing position..."))
	(set b_waf_phantoms_in_position true)
	(sleep (random_range 120 150))
	
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_attack_top_mid)
	
	
	(sleep_until
		(begin
			(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_mid ps_waf_phantoms/aim_mid r_waf_ph_firingpos_threshold)
			(sleep (random_range 300 400))
		0)
	1)
)

(script command_script cs_waf_phg_attack_top_mid
	(if debug (print "waf: phantom torpodoes incoming to top mid aa gun..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(set b_waf_phantom_torpedoes_away true)
	(cs_shoot_point true ps_waf_phantoms/target_top_mid_1)
	(sleep_forever)
)


; TOP RIGHT
; -------------------------------------------------
(script command_script cs_waf_ph_top_right
	(cs_stack_command_script ai_current_actor cs_phantom_warp)
	(sleep 1)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_hold)

	(f_unblip_flag fl_wafer_phantom_top_right)

	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed r_phantom_approach_speed)
	(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_right ps_waf_phantoms/target_top_right_1 r_waf_ph_firingpos_threshold)
	
	(if debug (print "waf: top right phantom has reached its firing position..."))
	(set b_waf_phantoms_in_position true)
	(sleep (random_range 120 150))
	
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_attack_top_right)
	
	(sleep_until
		(begin
			(cs_fly_to_and_face ps_waf_phantoms/firingpos_top_right ps_waf_phantoms/aim_mid r_waf_ph_firingpos_threshold)
			(sleep (random_range 300 400))
		0)
	1)
)

(script command_script cs_waf_phg_hold
	(cs_aim true ps_waf_phantoms/aim_mid)
	(sleep_forever)
)

(script command_script cs_waf_phg_attack_top_right
	(if debug (print "waf: phantom torpodoes incoming to top right aa gun..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(set b_waf_phantom_torpedoes_away true)
	(cs_shoot_point true ps_waf_phantoms/target_top_right_1)
	(sleep_forever)
)


; BOTTOM LEFT
; -------------------------------------------------
(script command_script cs_waf_ph_bottom_left
	(cs_stack_command_script ai_current_actor cs_phantom_warp)
	(sleep 1)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_hold)

	(f_unblip_flag fl_wafer_phantom_bottom_left)
	
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed r_phantom_approach_speed)
	(cs_fly_to_and_face ps_waf_phantoms/firingpos_bottom_left ps_waf_phantoms/target_bottom_left_1 r_waf_ph_firingpos_threshold)
	
	(if debug (print "waf: bottom left phantom has reached its firing position..."))
	(set b_waf_phantoms_in_position true)
	(sleep (random_range 120 150))
	
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_attack_bottom_left)
	(sleep_forever)
)


(script command_script cs_waf_phg_attack_bottom_left
	(if debug (print "waf: phantom torpodoes incoming to bottom left aa gun..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(set b_waf_phantom_torpedoes_away true)
	(cs_shoot_point true ps_waf_phantoms/target_bottom_left_1)
	(sleep_forever)
)


; BOTTOM RIGHT
; -------------------------------------------------
(script command_script cs_waf_ph_bottom_right
	(cs_stack_command_script ai_current_actor cs_phantom_warp)
	(sleep 1)
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_hold)

	(f_unblip_flag fl_wafer_phantom_bottom_right)
	
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed r_phantom_approach_speed)
	(cs_fly_to_and_face ps_waf_phantoms/firingpos_bottom_right ps_waf_phantoms/target_bottom_right_1 r_waf_ph_firingpos_threshold)
	
	(if debug (print "waf: bottom right phantom has reached its firing position..."))
	(set b_waf_phantoms_in_position true)
	(sleep (random_range 120 150))
	
	(cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_waf_phg_attack_bottom_right)
	
	(sleep_until
		(begin
			(cs_fly_to_and_face ps_waf_phantoms/firingpos_bottom_right ps_waf_phantoms/target_bottom_right_1 r_waf_ph_firingpos_threshold)
			(sleep (random_range 300 400))
		0)
	1)
)


(script command_script cs_waf_phg_attack_bottom_right
	(if debug (print "waf: phantom torpodoes incoming to bottom right aa gun..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(set b_waf_phantom_torpedoes_away true)
	(cs_shoot_point true ps_waf_phantoms/target_bottom_right_1)
	(sleep_forever)
)




; UTIL
; -------------------------------------------------
(script command_script cs_phantom_gunner_hold
	(if debug (print "waf: phantom chin gunner holding..."))
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(sleep_forever)
)

(script command_script cs_waf_warpout
	(cs_vehicle_speed 1.0)
	
	(begin_random_count 1
		(begin
			(cs_fly_by ps_waf_warpout/warpout0_0)
			(cs_fly_by ps_waf_warpout/warpout0_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout1_0)
			(cs_fly_by ps_waf_warpout/warpout1_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout2_0)
			(cs_fly_by ps_waf_warpout/warpout2_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout3_0)
			(cs_fly_by ps_waf_warpout/warpout3_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout4_0)
			(cs_fly_by ps_waf_warpout/warpout4_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout5_0)
			(cs_fly_by ps_waf_warpout/warpout5_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout6_0)
			(cs_fly_by ps_waf_warpout/warpout6_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout7_0)
			(cs_fly_by ps_waf_warpout/warpout7_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout8_0)
			(cs_fly_by ps_waf_warpout/warpout8_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout9_0)
			(cs_fly_by ps_waf_warpout/warpout9_1)
		)
		
		(begin
			(cs_fly_by ps_waf_warpout/warpout10_0)
			(cs_fly_by ps_waf_warpout/warpout10_1)
		)
	)
	
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1000)	
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 20)
	(sleep 20)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

	
(script static void waf_replenish_sabres
	(waf_sabre_spawn_immediate (- s_waf_min_sabres (ai_living_count gr_unsc_waf_sabres))))

; BANSHEE WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global short s_waf_banshee_spawn_remaining 0)
; -------------------------------------------------------------------------------------------------
(script static void (waf_banshee_spawn_immediate (short count))
	(ai_designer_clump_perception_range 600)
	(sleep_until (<= s_waf_banshee_spawn_remaining 0) 1)
	(set s_waf_banshee_spawn_remaining count)
	(sleep_until
		(begin
			; -------------------------------------------------
			; 7 or more banshees are supposed to spawn
			(if (>= s_waf_banshee_spawn_remaining 7)
				(begin
					(waf_spawn_banshee_center_7)
					(set s_waf_banshee_spawn_remaining (- s_waf_banshee_spawn_remaining 7))))
					
			; 5 or more banshees are supposed to spawn
			(if (>= s_waf_banshee_spawn_remaining 5)
				(begin
					(waf_spawn_banshee_center_5)
					(set s_waf_banshee_spawn_remaining (- s_waf_banshee_spawn_remaining 5))))		
					
			; 3 or more banshees are supposed to spawn
			(if (>= s_waf_banshee_spawn_remaining 3)
				(begin
					(waf_spawn_banshee_center_3)
					(set s_waf_banshee_spawn_remaining (- s_waf_banshee_spawn_remaining 3))))	
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_banshee_spawn_remaining 2)
				(begin
					(waf_spawn_banshee_center_2)
					(set s_waf_banshee_spawn_remaining (- s_waf_banshee_spawn_remaining 2))))
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_banshee_spawn_remaining 1)
				(begin
					(waf_spawn_banshee_center_1)
					(set s_waf_banshee_spawn_remaining (- s_waf_banshee_spawn_remaining 1))))
			; -------------------------------------------------
			
		(<= s_waf_banshee_spawn_remaining 0))
	1)
)
	
(script static void waf_spawn_banshee_center_7
	(if debug (print "waf: spawning center banshees (count 7)..."))
	(ai_place sq_cov_waf_bsh_center7/banshee0)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee1)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee2)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee3)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee4)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee5)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center7/banshee6)
	
	(ai_set_clump sq_cov_waf_bsh_center7 CLUMP_BANSHEES)
)

(script static void waf_spawn_banshee_center_5
	(if debug (print "waf: spawning center banshees (count 5)..."))
	(ai_place sq_cov_waf_bsh_center5/banshee0)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center5/banshee1)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center5/banshee2)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center5/banshee3)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center5/banshee4)
	
	(ai_set_clump sq_cov_waf_bsh_center5 CLUMP_BANSHEES)
)

(script static void waf_spawn_banshee_center_3
	(if debug (print "waf: spawning center banshees (count 3)..."))
	(ai_place sq_cov_waf_bsh_center3/banshee0)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center3/banshee1)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center3/banshee2)
	
	(ai_set_clump sq_cov_waf_bsh_center3 CLUMP_BANSHEES)
)

(script static void waf_spawn_banshee_center_2
	(if debug (print "waf: spawning center banshees (count 2)..."))
	(ai_place sq_cov_waf_bsh_center2/banshee0)
	(banshee_warp_stagger)
	(ai_place sq_cov_waf_bsh_center2/banshee1)
	
	(ai_set_clump sq_cov_waf_bsh_center2 CLUMP_BANSHEES)
)

(script static void waf_spawn_banshee_center_1
	(if debug (print "waf: spawning center banshees (count 1)..."))
	(ai_place sq_cov_waf_bsh_center1/banshee0)
	
	(ai_set_clump sq_cov_waf_bsh_center2 CLUMP_BANSHEES)
)


; SERAPH WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global short s_waf_seraph_spawn_remaining 0)
(global real r_phantom_approach_speed 0.75)
; -------------------------------------------------------------------------------------------------
(script static void (waf_seraph_spawn_immediate (short count))
	(ai_designer_clump_perception_range 600)
	(sleep_until (<= s_waf_seraph_spawn_remaining 0) 1)
	(set s_waf_seraph_spawn_remaining count)
	(sleep_until
		(begin
			; -------------------------------------------------
			; 3 or more seraphs are supposed to spawn
			(if (>= s_waf_seraph_spawn_remaining 3)
				(begin
					(waf_spawn_seraph_center_3)
					(set s_waf_seraph_spawn_remaining (- s_waf_seraph_spawn_remaining 3))))	
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_seraph_spawn_remaining 2)
				(begin
					(waf_spawn_seraph_center_2)
					(set s_waf_seraph_spawn_remaining (- s_waf_seraph_spawn_remaining 2))))
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_seraph_spawn_remaining 1)
				(begin
					(waf_spawn_seraph_center_1)
					(set s_waf_seraph_spawn_remaining (- s_waf_seraph_spawn_remaining 1))))
			; -------------------------------------------------
			
		(<= s_waf_seraph_spawn_remaining 0))
	1)
)

(script static void waf_spawn_seraph_center_3
	(if debug (print "waf: spawning center seraphs (count 3)..."))
	(ai_place sq_cov_waf_sph_center3/seraph0)
	(seraph_warp_stagger)
	(ai_place sq_cov_waf_sph_center3/seraph1)
	(seraph_warp_stagger)
	(ai_place sq_cov_waf_sph_center3/seraph2)
	
	(ai_set_clump sq_cov_waf_sph_center3 CLUMP_SERAPHS)
)

(script static void waf_spawn_seraph_center_2
	(if debug (print "waf: spawning center seraphs (count 2)..."))
	(ai_place sq_cov_waf_sph_center2/seraph0)
	(seraph_warp_stagger)
	(ai_place sq_cov_waf_sph_center2/seraph1)
	
	(ai_set_clump sq_cov_waf_sph_center2 CLUMP_SERAPHS)
)

(script static void waf_spawn_seraph_center_1
	(if debug (print "waf: spawning center seraphs (count 1)..."))
	(ai_place sq_cov_waf_sph_center1/seraph0)

	(ai_set_clump sq_cov_waf_sph_center1 CLUMP_SERAPHS)
)





; SABRE WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global short s_waf_sabre_spawn_remaining 0)
; -------------------------------------------------------------------------------------------------
(script static void (waf_sabre_spawn_immediate (short count))
	(ai_designer_clump_perception_range 600)
	(sleep_until (<= s_waf_sabre_spawn_remaining 0) 1)
	(set s_waf_sabre_spawn_remaining count)
	(sleep_until
		(begin
			; -------------------------------------------------
			; 3 or more seraphs are supposed to spawn
			(if (>= s_waf_sabre_spawn_remaining 3)
				(begin
					(waf_spawn_sabre_center_3)
					(set s_waf_sabre_spawn_remaining (- s_waf_sabre_spawn_remaining 3))))	
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_sabre_spawn_remaining 2)
				(begin
					(waf_spawn_sabre_center_2)
					(set s_waf_sabre_spawn_remaining (- s_waf_sabre_spawn_remaining 2))))
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_waf_sabre_spawn_remaining 1)
				(begin
					(waf_spawn_sabre_center_1)
					(set s_waf_sabre_spawn_remaining (- s_waf_sabre_spawn_remaining 1))))
			; -------------------------------------------------
			
		(<= s_waf_sabre_spawn_remaining 0))
	1)
)
	
(script static void waf_spawn_sabre_center_3
	(if debug (print "waf: spawning station sabres (count 3)..."))
	(ai_place sq_unsc_waf_sbr_station3/sabre0)
	(sabre_station_stagger)
	(ai_place sq_unsc_waf_sbr_station3/sabre1)
	(sabre_station_stagger)
	(ai_place sq_unsc_waf_sbr_station3/sabre2)
	(sabre_station_stagger)
	
	(ai_set_clump sq_unsc_waf_sbr_station3 CLUMP_SABRES)
)

(script static void waf_spawn_sabre_center_2
	(if debug (print "waf: spawning station sabres (count 2)..."))
	(ai_place sq_unsc_waf_sbr_station2/sabre0)
	(sabre_station_stagger)
	(ai_place sq_unsc_waf_sbr_station2/sabre1)
	(sabre_station_stagger)
	
	(ai_set_clump sq_unsc_waf_sbr_station2 CLUMP_SABRES)
)

(script static void waf_spawn_sabre_center_1
	(if debug (print "waf: spawning station sabres (count 1)..."))
	(ai_place sq_unsc_waf_sbr_station1/sabre0)
	(sabre_station_stagger)
	
	(ai_set_clump sq_unsc_waf_sbr_station1 CLUMP_SABRES)
)

(script static void waf_blip_living_covenant
	(if debug (print "blipping final covenant..."))
	(blip_ai_object sq_cov_waf_bsh_center7/banshee0)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee1)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee2)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee3)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee4)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee5)
	(blip_ai_object sq_cov_waf_bsh_center7/banshee6)
	
	(blip_ai_object sq_cov_waf_bsh_center5/banshee0)
	(blip_ai_object sq_cov_waf_bsh_center5/banshee1)
	(blip_ai_object sq_cov_waf_bsh_center5/banshee2)
	(blip_ai_object sq_cov_waf_bsh_center5/banshee3)
	(blip_ai_object sq_cov_waf_bsh_center5/banshee4)
	
	(blip_ai_object sq_cov_waf_bsh_center3/banshee0)
	(blip_ai_object sq_cov_waf_bsh_center3/banshee1)
	(blip_ai_object sq_cov_waf_bsh_center3/banshee2)
	
	(blip_ai_object sq_cov_waf_bsh_center2/banshee0)
	(blip_ai_object sq_cov_waf_bsh_center2/banshee1)
	
	(blip_ai_object sq_cov_waf_bsh_center1/banshee0)
	
	; -------------------------------------------------
	
	(blip_ai_object sq_cov_waf_sph_center3/seraph0)
	(blip_ai_object sq_cov_waf_sph_center3/seraph1)
	(blip_ai_object sq_cov_waf_sph_center3/seraph2)
	
	(blip_ai_object sq_cov_waf_sph_center2/seraph0)
	(blip_ai_object sq_cov_waf_sph_center2/seraph1)
	
	(blip_ai_object sq_cov_waf_sph_center1/seraph0)
)

(script dormant waf_garbage_collector
	(sleep_until
		(begin
			(add_recycling_volume tv_recycle_waf 10 10)
		b_crv_started)
	300)
)




; =================================================================================================
; WARP
; =================================================================================================
(global boolean b_wrp_player_docks false)
(global unit u_wrp_player_sabre0 none)
(global unit u_wrp_player_sabre1 none)
(global unit u_wrp_player_sabre2 none)
(global unit u_wrp_player_sabre3 none)
; -------------------------------------------------------------------------------------------------

(script dormant wrp_encounter
	(if debug (print "encounter: warp from wafer to corvette"))
	(set s_current_encounter s_wrp_encounter_index)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_wrp_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(md_wrp_an9_ships_neutralized)
			
			;(new_mission_objective 7 ct_obj_wafer_dock)
			(wake show_objective_wafer_dock)
			(sleep 45)
			(f_blip_flag fl_wafer_land 21)
			; -------------------------------------------------

	(sleep_until (volume_test_players tv_wafer_land) 1)
	(if debug (print "warp: player is now docking with the wafer..."))
	
			; -------------------------------------------------
			(set b_wrp_player_docks true)
			(f_unblip_flag fl_wafer_land)
			(chud_show_screen_objective "")
			
			; players can't slam into the docking bay
			(object_cannot_take_damage v_wafer_sabre_player0)
			(object_cannot_take_damage v_wafer_sabre_player1)
			(object_cannot_take_damage v_wafer_sabre_player2)
			(object_cannot_take_damage v_wafer_sabre_player3)
			
			(object_cannot_take_damage v_warp_sabre_player0)
			(object_cannot_take_damage v_warp_sabre_player1)
			(object_cannot_take_damage v_warp_sabre_player2)
			(object_cannot_take_damage v_warp_sabre_player3)
			
			(cinematic_enter 045lb_pitstop true)
			
			; sound scripting
			(sfx_detach_chatter)
			(sound_looping_stop sound\levels\solo\m45\space_loop\space_loop.sound_looping)
			
			(replenish_players)
			;(mus_play mus_warp)
			
			(set u_wrp_player_sabre0 (unit_get_vehicle player0))
			(set u_wrp_player_sabre1 (unit_get_vehicle player1))
			(set u_wrp_player_sabre2 (unit_get_vehicle player2))
			(set u_wrp_player_sabre3 (unit_get_vehicle player3))
			
			(sleep_forever waf_ejection_killer)
			(teleport_players
				fl_warp_teleport0
				fl_warp_teleport1
				fl_warp_teleport2
				fl_warp_teleport3)
			
			(object_destroy dm_savannah_wafer)
			(object_destroy_folder v_warp_sabres)
			(object_destroy_folder v_wafer_sabres)
			
			(sleep 1)
			(object_destroy u_wrp_player_sabre0)
			(object_destroy u_wrp_player_sabre1)
			(object_destroy u_wrp_player_sabre2)
			(object_destroy u_wrp_player_sabre3)
			
			;(wake md_wrp_jor_my_stop)
			;(object_destroy_folder cr_waf_asteroids)
			;(cinematic_skip_stop_internal)
			(ai_erase_all)
			
			; (cinematic_show_letterbox_immediate true)
			; (cinematic_run_script_by_name 045lb_pitstop)
			
			(f_play_cinematic_advanced 045lb_pitstop set_warp_030_040 set_corvettecombat_050_070)
			
			; (cinematic_exit 045lb_pitstop true)

			; -------------------------------------------------	
	
	(set b_wrp_completed TRUE)
	
)



; =================================================================================================
; CORVETTE
; =================================================================================================
(global short s_crv_min_sabres 4)
(global short s_crv_min_seraphs 4)
(global short s_crv_engines_damaged 0)
(global boolean b_crv_all_engines_damaged false)
; -------------------------------------------------
(script dormant crv_encounter
	(if debug (print "encounter: corvette assault"))
	(set s_current_encounter s_crv_encounter_index)
	; set sixth mission segment
	(data_mine_set_mission_segment "m45_06_crv_encounter")
	
	;(fade_out 1 1 1 0)
	(soft_ceiling_enable corvette true)
	
	; sound scripting
	(sound_looping_start sound\levels\solo\m45\space_loop\space_loop NONE 1) ; do this for corvette too	
	
	
	(sleep 1)
	(object_create_folder sc_crv)
	(object_create_folder dm_crv_engines)
	
	(lnos_setup)
	(setup_corvette_cannons)
	
	(create_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	(load_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	
	(sleep 1)
	(set_sabre_respawns true)
	
	(wake crv_ejection_killer)
	
	(ai_lod_full_detail_actors 50)
	
	; objectives
	(chud_show_screen_objective "")
	(f_hud_start_menu_obj PRIMARY_OBJECTIVE_9)
	
	; make the roof invulnerable
	(object_create sc_aft_top)
	(object_cannot_take_damage sc_aft_top)
	
	; sabre spawning
	; -------------------------------------------------
	(ai_place sq_unsc_crv_sbr_start0)
	(ai_set_clump gr_unsc_crv_sabres CLUMP_SABRES)
	(ai_designer_clump_perception_range 600)
	
	; seraph spawning
	; -------------------------------------------------
	(ai_place sq_cov_crv_sph_start0)
	
	(if 
		(or
			(difficulty_is_heroic_or_higher)
			(>= (game_coop_player_count) 2)
		)
		(ai_place sq_cov_crv_sph_start1)
	)
		
	(ai_set_clump gr_cov_crv_seraphs CLUMP_SERAPHS)
	
	; banshee spawning
	; -------------------------------------------------
	(if 
		(or
			(difficulty_is_heroic_or_higher)
			(>= (game_coop_player_count) 2)
		)
		(begin
			(if debug (print "placing all banshees"))
			(ai_place sq_cov_crv_bsh_start0)
			(ai_place sq_cov_crv_bsh_start1)
		)
		
		(begin
			(if debug (print "placing 10 banshees"))
			(ai_place sq_cov_crv_bsh_start0/banshee0)
			(ai_place sq_cov_crv_bsh_start0/banshee1)
			(ai_place sq_cov_crv_bsh_start0/banshee2)
			(ai_place sq_cov_crv_bsh_start0/banshee3)
			(ai_place sq_cov_crv_bsh_start0/banshee4)
			
			(ai_place sq_cov_crv_bsh_start1/banshee0)
			(ai_place sq_cov_crv_bsh_start1/banshee1)
			(ai_place sq_cov_crv_bsh_start1/banshee2)
			(ai_place sq_cov_crv_bsh_start1/banshee3)
			(ai_place sq_cov_crv_bsh_start1/banshee4)
		)
	)

	(ai_set_clump sq_cov_crv_bsh_start0 CLUMP_BANSHEES)
	(ai_set_clump sq_cov_crv_bsh_start1 CLUMP_BANSHEES)
	
	; aa spawning
	; -------------------------------------------------
	(if (difficulty_is_heroic_or_higher)
		(begin
			(if debug (print "placing all aa on corvette"))
			(ai_place sq_cov_crv_aa)
		)
		
		(begin
			(if debug (print "placing half the aa on the corvette"))
			(ai_place sq_cov_crv_aa/front_left0)
			(ai_place sq_cov_crv_aa/rear_left0)
			(ai_place sq_cov_crv_aa/front_right0)
			(ai_place sq_cov_crv_aa/rear_right0)
		)
	)
	
	(sleep 1)
	(ai_disregard (ai_actors sq_cov_crv_aa) true)
	(ai_set_clump sq_cov_crv_aa CLUMP_CORVETTE_AA)
	
	(if (difficulty_is_legendary)
		(begin
			(ai_place sq_cov_crv_aa_legendary)
			(ai_disregard (ai_actors sq_cov_crv_aa_legendary) true)
			(ai_set_clump sq_cov_crv_aa_legendary CLUMP_CORVETTE_AA)
		)
	)
	
	
	
	; scripts
	(wake crv_garbage_collector)
	(wake crv_save_loop)
	(wake crv_pod_drop_left_control)
	(wake crv_pod_drop_right_control)
	;(wake crv_debris_control)
	(wake crv_banshee_control)
	
	; engines
	(wake crv_engine0_control)
	(wake crv_engine1_control)
	(wake crv_engine2_control)
	(wake crv_engine3_control)
	
	(wake md_crv_dot_flares)
	(wake achievement_corvette_killer)
	
	(wake save_crv_all_engines_damaged)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_crv_started TRUE)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------	
			;(prepare_to_switch_to_zone_set set_aftship_050_070)
			(wake crv_savannah_setup_and_start)
			(sleep 30)

			(cinematic_exit 045lb_pitstop true)	
			(sleep 60)
			(game_save_immediate)
			
			(wake md_crv_sav_intro)
			;(wake crv_hud_flash)
			; -------------------------------------------------
	
	(sleep_until b_crv_all_engines_damaged)
	
			; -------------------------------------------------
			
	
			(crv_seraph_spawn_immediate 5)
				
			(md_crv_ec2_reinforcements)
			(set b_crv_attempt_save true)
			; -------------------------------------------------
	
	(if (> (ai_living_count gr_cov_crv) 0)
		(begin
			(sleep_until (<= (ai_living_count gr_cov_crv) 5))
			(f_blip_ai gr_cov_crv 14)
			(sleep_until (<= (ai_living_count gr_cov_crv) 0))
		)
	)
	
	
			
			
			; -------------------------------------------------
	
	(sleep_until b_crv_all_engines_damaged)
		
	(set b_crv_completed true)	
	(sleep_forever crv_save_loop)
)

(script dormant crv_engine_control
	(if (< s_crv_engines_damaged 4)
		(begin
			;(md_crv_sav_clip_engines)
			(f_hud_start_menu_obj PRIMARY_OBJECTIVE_10)
			(wake crv_engine_blip)
			(wake crv_engine_objective_update)
			(wake crv_engine_hud_flash)
		)
				
		(set b_crv_all_engines_damaged true)
	)
)

(script dormant save_crv_all_engines_damaged
	(sleep_until b_crv_all_engines_damaged)
	(sleep 60)
	(game_save_no_timeout)
)


(script dormant crv_ejection_killer
	(sleep 30)
	(sleep_until
		(begin
			(ejection_kill_player player0)
			(ejection_kill_player player1)
			(ejection_kill_player player2)
			(ejection_kill_player player3)
			
			(sleep 30)
		0)
	1)
)

; AMBIENT
; -------------------------------------------------------------------------------------------------
(script dormant crv_hud_flash
	(sleep 60)
	(f_hud_flash_object sc_highlight_crv_engines)
)

(script dormant crv_engine_hud_flash
	(f_hud_flash_object sc_hud_corvette_engines)
)

; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------
(script dormant crv_cov_engine_reinforcements
	(if debug (print "crv: starting reinforcement loop..."))
	(sleep 300)
	(sleep_until
		(begin
			(sleep_until
				(or 
					b_brd_started
					(<= (ai_living_count gr_cov_crv_seraphs) 0)))
			(sleep 600)
			(if (not b_brd_started) (crv_replenish_seraphs))
		b_brd_started)
	1)
)

(script dormant crv_banshee_control
	(sleep_until
		(or
			(volume_test_players tv_crv_bsh_launch)
			(<= (ai_strength gr_cov_crv_banshees) 0.9)
			(<= (ai_strength gr_cov_crv_seraphs) 0.5)
			(>= s_crv_engines_damaged 2)
		)
	)
	
	(set b_crv_banshee_launch true)
)

(script static void test_corvette_phantom
	(ai_erase sq_cov_crv_ph_engine_left)
	(ai_erase sq_cov_crv_ph_engine_right)
	(ai_place sq_cov_crv_ph_engine_left)
	(ai_place sq_cov_crv_ph_engine_right)
	(sleep 1)
	(crv_ph_attack_frigate sq_cov_crv_ph_engine_left)
	(crv_ph_attack_frigate sq_cov_crv_ph_engine_right)
)

(script static void (crv_ph_attack_frigate (ai pilot))
	(cs_run_command_script (ai_get_turret_ai pilot 0) cs_crv_phg_attack_frigate))

(script command_script cs_crv_phg_attack_frigate
	(if debug (print "corvette phantom firing on the frigate..."))
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(cs_shoot true (object_at_marker dm_savannah_corvette "turret_rear_top01"))
	(sleep_forever)
)

(script command_script cs_crv_seraph_start
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(cs_vehicle_speed 0)
	(cs_vehicle_boost 0)
	(sleep 90)
	(if debug (print "crv: seraphs now free to attack..."))
	
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
)

(global boolean b_crv_banshee_launch false)
(script command_script cs_crv_banshee_launch
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(sleep_until b_crv_banshee_launch (random_range 10 60))

	(if debug (print "launching banshee..."))
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)
	(ai_disregard (ai_get_object ai_current_actor) false)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 30)	
)


; UTILITY
; -------------------------------------------------------------------------------------------------
(global boolean b_crv_attempt_save false)

(script dormant crv_save_loop
	(branch
		(= b_brd_started true) (branch_abort_crv_save)
	)
	
	(wake save_crv_50percent)
	
	(sleep_until
		(begin
			(sleep_until (= b_crv_attempt_save true) 1)
			(sleep 20)
			(ai_disregard (players) true)
			(sleep_until (game_safe_to_save) 1)
			(if debug (print "crv: game should be safe to save now!"))
			(game_save_immediate)
			(sleep 45)
			(ai_disregard (players) false)
			(set b_crv_attempt_save false)
		b_crv_completed)
	60)
)

(script dormant save_crv_50percent
	(sleep 180)
	(sleep_until (< (ai_strength gr_cov_crv) 0.5))
	(if debug (print "50 percent save"))
	(set b_crv_attempt_save true)
)

(script static void branch_abort_crv_save
	(ai_disregard (players) false)
)

(script dormant crv_garbage_collector
	(sleep_until
		(begin
			(add_recycling_volume tv_recycle_crv 10 10)
		b_hgr_completed)
	300)
)

(script static void crv_blip_capital_ships
	(f_blip_flag fl_crv_marker blip_recon)
)

(script dormant crv_boundary_control
	(sleep_until (< (objects_distance_to_flag (players) fl_crv_deserter_center) r_deserter_warn_distance))
	(sleep_until
		(begin
			(if (>= (objects_distance_to_flag (players) fl_crv_deserter_center) r_deserter_warn_distance)
				(begin
					(cinematic_set_title ct_deserter_footer)
					(cinematic_set_title ct_deserter_warning)
					(f_blip_flag fl_crv_marker blip_neutralize)
					(sound_impulse_start sound\game_sfx\fireteam\issue_directive.sound NONE 1)
				)
				
				(begin
					(f_unblip_flag fl_crv_marker)
				)
			)
		0)
	10)
)



; ENGINES
; -------------------------------------------------------------------------------------------------
(script dormant crv_engine_objective_update
	;(show_update ct_obj_engines0)
	 (chud_show_screen_objective ct_obj_engines0)
	
	(sleep_until (>= s_crv_engines_damaged 1) 1)
		(if (<= s_crv_engines_damaged 1)
			(chud_show_screen_objective ct_obj_engines1))
	
	(sleep_until (>= s_crv_engines_damaged 2) 1)
		(if (<= s_crv_engines_damaged 2)
			(chud_show_screen_objective ct_obj_engines2))
	
	(sleep_until (>= s_crv_engines_damaged 3) 1)
		(if (<= s_crv_engines_damaged 3)	
			(chud_show_screen_objective ct_obj_engines3))
	
	(sleep_until (>= s_crv_engines_damaged 4) 1)
	(chud_show_screen_objective ct_obj_engines_complete)
	
	(sleep (* 30 5))
	
	(chud_show_screen_objective "")
	
	(set b_crv_all_engines_damaged true)
)

(script dormant crv_kill_cannons_sequentially
	(if debug (print "-=-=- killing the corvette's anti-capital guns since it lost engine power -=-=-"))
	(begin_random
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_left0)
			(sleep (random_range 4 12)))
			
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_left1)
			(sleep (random_range 4 12)))
			
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_left2)
			(sleep (random_range 4 12)))
			
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_right0)
			(sleep (random_range 4 12)))
			
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_right1)
			(sleep (random_range 4 12)))
			
		(begin
			(ai_erase sq_cov_crv_cannon_gunners/gunner_right2)
			(sleep (random_range 4 12)))
	)
	
	(sleep_forever corvette_cannon_control)
)



(script dormant crv_engine0_control
	(object_can_take_damage dm_crv_engine_large_left)
	;(f_blip_object sc_crv_engine_large_left blip_neutralize)
	(sleep_until (<= (object_get_health dm_crv_engine_large_left) 0) 1)
	(set s_crv_engines_damaged (+ s_crv_engines_damaged 1))
	(set b_crv_attempt_save true)
)

(script dormant crv_engine1_control
	(object_can_take_damage dm_crv_engine_small_left)
	;(f_blip_object sc_crv_engine_small_left blip_neutralize)
	(sleep_until (<= (object_get_health dm_crv_engine_small_left) 0) 1)
	(set s_crv_engines_damaged (+ s_crv_engines_damaged 1))
	(set b_crv_attempt_save true)
)

(script dormant crv_engine2_control
	(object_can_take_damage dm_crv_engine_small_right)
	;(f_blip_object sc_crv_engine_small_right blip_neutralize)
	(sleep_until (<= (object_get_health dm_crv_engine_small_right) 0) 1)
	(set s_crv_engines_damaged (+ s_crv_engines_damaged 1))
	(set b_crv_attempt_save true)
)

(script dormant crv_engine3_control
	(object_can_take_damage dm_crv_engine_large_right)
	;(f_blip_object sc_crv_engine_large_right blip_neutralize)
	(sleep_until (<= (object_get_health dm_crv_engine_large_right) 0) 1)
	(set s_crv_engines_damaged (+ s_crv_engines_damaged 1))
	(set b_crv_attempt_save true)
)

(script dormant crv_engine_blip
	(if debug (print "blipping corvette engines..."))
	
	(if (> (object_get_health dm_crv_engine_large_right) 0)
		(f_blip_object dm_crv_engine_large_left blip_neutralize))
		
	(if (> (object_get_health dm_crv_engine_large_right) 0)
		(f_blip_object dm_crv_engine_small_left blip_neutralize))
		
	(if (> (object_get_health dm_crv_engine_large_right) 0)
		(f_blip_object dm_crv_engine_small_right blip_neutralize))
		
	(if (> (object_get_health dm_crv_engine_large_right) 0)
		(f_blip_object dm_crv_engine_large_right blip_neutralize))		
)


(global short s_achievement_timer (* 30 180))
(script dormant achievement_corvette_killer
	(if (difficulty_is_heroic_or_higher)
		(begin
			(sleep_until 
				(and 
					b_crv_all_engines_damaged
					(<= (ai_living_count gr_cov_crv) 0)
				)
			1 s_achievement_timer)
			
			(if 
				(and 
					b_crv_all_engines_damaged
					(<= (ai_living_count gr_cov_crv) 0)
				)
					(begin
						(submit_incident_with_cause_player "cruiser_fast_achieve" player0)
						(submit_incident_with_cause_player "cruiser_fast_achieve" player1)
						(submit_incident_with_cause_player "cruiser_fast_achieve" player2)
						(submit_incident_with_cause_player "cruiser_fast_achieve" player3)
						(if debug (print "-=-=-=- <<< ACHIEVEMENT UNLOCKED: CORVETTE_FAST_ACHIEVE >>> -=-=-=-"))
					)
			)
		)
	)
)

; SERAPH WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global short s_crv_seraph_spawn_remaining 0)
; -------------------------------------------------------------------------------------------------
(script static void (crv_seraph_spawn_immediate (short count))
	(ai_designer_clump_perception_range 600)
	(sleep_until (<= s_crv_seraph_spawn_remaining 0) 1)
	(set s_crv_seraph_spawn_remaining count)
	(sleep_until
		(begin
			; -------------------------------------------------
			; 3 or more seraphs are supposed to spawn
			(if (>= s_crv_seraph_spawn_remaining 3)
				(begin
					(crv_spawn_seraph_center_3)
					(set s_crv_seraph_spawn_remaining (- s_crv_seraph_spawn_remaining 3))))	
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_crv_seraph_spawn_remaining 2)
				(begin
					(crv_spawn_seraph_center_2)
					(set s_crv_seraph_spawn_remaining (- s_crv_seraph_spawn_remaining 2))))
					
			; 2 or more banshees are supposed to spawn
			(if (>= s_crv_seraph_spawn_remaining 1)
				(begin
					(crv_spawn_seraph_center_1)
					(set s_crv_seraph_spawn_remaining (- s_crv_seraph_spawn_remaining 1))))
			; -------------------------------------------------
			
		(<= s_crv_seraph_spawn_remaining 0))
	1)
)

(script static void crv_spawn_seraph_center_3
	(if debug (print "waf: spawning center seraphs (count 3)..."))
	(ai_place sq_cov_crv_sph_center3/seraph0)
	(seraph_warp_stagger)
	(ai_place sq_cov_crv_sph_center3/seraph1)
	(seraph_warp_stagger)
	(ai_place sq_cov_crv_sph_center3/seraph2)
	
	(ai_set_clump sq_cov_crv_sph_center3 CLUMP_SERAPHS)
)

(script static void crv_spawn_seraph_center_2
	(if debug (print "waf: spawning center seraphs (count 2)..."))
	(ai_place sq_cov_crv_sph_center2/seraph0)
	(seraph_warp_stagger)
	(ai_place sq_cov_crv_sph_center2/seraph1)
	
	(ai_set_clump sq_cov_crv_sph_center2 CLUMP_SERAPHS)
)

(script static void crv_spawn_seraph_center_1
	(if debug (print "waf: spawning center seraphs (count 1)..."))
	(ai_place sq_cov_crv_sph_center1/seraph0)

	(ai_set_clump sq_cov_crv_sph_center1 CLUMP_SERAPHS)
)

(script static void crv_replenish_seraphs
	(crv_seraph_spawn_immediate (- s_crv_min_seraphs (ai_living_count gr_cov_crv_seraphs))))
	

; SABRE WAVE SPAWNING
; -------------------------------------------------------------------------------------------------
(global short s_crv_sabre_spawn_remaining 0)
; -------------------------------------------------------------------------------------------------
(script static void (crv_sabre_spawn_immediate (short count))
	(ai_designer_clump_perception_range 600)
	(sleep_until (<= s_crv_sabre_spawn_remaining 0) 1)
	(set s_crv_sabre_spawn_remaining count)
	(sleep_until
		(begin
			; -------------------------------------------------
			; 3 or more sabres are supposed to spawn
			(if (>= s_crv_sabre_spawn_remaining 3)
				(begin
					(crv_spawn_sabre_center_3)
					(set s_crv_sabre_spawn_remaining (- s_crv_sabre_spawn_remaining 3))))	
					
			; 2 or more sabres are supposed to spawn
			(if (>= s_crv_sabre_spawn_remaining 2)
				(begin
					(crv_spawn_sabre_center_2)
					(set s_crv_sabre_spawn_remaining (- s_crv_sabre_spawn_remaining 2))))
					
			; 2 or more sabres are supposed to spawn
			(if (>= s_crv_sabre_spawn_remaining 1)
				(begin
					(crv_spawn_sabre_center_1)
					(set s_crv_sabre_spawn_remaining (- s_crv_sabre_spawn_remaining 1))))
			; -------------------------------------------------
			
		(<= s_crv_sabre_spawn_remaining 0))
	1)
)
	
(script static void crv_spawn_sabre_center_3
	(if debug (print "crv: spawning sabres (count 3)..."))
	(ai_place sq_unsc_crv_sbr_center3/sabre0)
	(sabre_warp_stagger)
	(ai_place sq_unsc_crv_sbr_center3/sabre1)
	(sabre_warp_stagger)
	(ai_place sq_unsc_crv_sbr_center3/sabre2)
	(sabre_warp_stagger)
	
	(ai_set_clump sq_unsc_crv_sbr_center3 CLUMP_SABRES)
)

(script static void crv_spawn_sabre_center_2
	(if debug (print "crv: spawning sabres (count 2)..."))
	(ai_place sq_unsc_crv_sbr_center2/sabre0)
	(sabre_warp_stagger)
	(ai_place sq_unsc_crv_sbr_center2/sabre1)
	(sabre_warp_stagger)
	
	(ai_set_clump sq_unsc_crv_sbr_center2 CLUMP_SABRES)
)

(script static void crv_spawn_sabre_center_1
	(if debug (print "crv: spawning sabre (count 1)..."))
	(ai_place sq_unsc_crv_sbr_center1/sabre0)
	(sabre_warp_stagger)
	
	(ai_set_clump sq_unsc_crv_sbr_center1 CLUMP_SABRES)
)

(script static void crv_replenish_sabres
	(crv_sabre_spawn_immediate (- s_crv_min_sabres (ai_living_count gr_unsc_crv_sabres))))



; =================================================================================================
; BOARDING
; =================================================================================================
(global unit u_crv_player_sabre0 none)
(global unit u_crv_player_sabre1 none)
(global unit u_crv_player_sabre2 none)
(global unit u_crv_player_sabre3 none)

(script dormant brd_encounter
	(if debug (print "encounter: corvette boarding"))
	; set seventh mission segment
	(data_mine_set_mission_segment "m45_07_brd_encounter")
		
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_brd_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(crv_replenish_sabres)
			(md_brd_hol_analyze_entrance)
			(ai_disregard (players) false)
			;(new_mission_objective 11 ct_obj_boarding)
			(wake show_objective_corvette_landing)
			
			(f_blip_flag fl_boarding_land blip_recon)
			; -------------------------------------------------
		
	(sleep_until (volume_test_players tv_boarding_land) 1)
	
			; -------------------------------------------------
			(f_unblip_flag fl_boarding_land)	
			(cinematic_enter 045lc_aftship_landing true)
			
			(set_sabre_respawns false)
			(sound_looping_stop sound\levels\solo\m45\space_loop\space_loop.sound_looping)
			
			(set u_crv_player_sabre0 (unit_get_vehicle player0))
			(set u_crv_player_sabre1 (unit_get_vehicle player1))
			(set u_crv_player_sabre2 (unit_get_vehicle player2))
			(set u_crv_player_sabre3 (unit_get_vehicle player3))
			
			(sleep_forever crv_ejection_killer)
			
			(teleport_players 
				fl_comms_player0 
				fl_comms_player1
				fl_comms_player2 
				fl_comms_player3)
				
			(object_hide player0 TRUE)
			(object_hide player1 TRUE)
			(object_hide player2 TRUE)
			(object_hide player3 TRUE)
			(sleep 1)
			
			(object_destroy u_crv_player_sabre0)
			(object_destroy u_crv_player_sabre1)
			(object_destroy u_crv_player_sabre2)
			(object_destroy u_crv_player_sabre3)
			
			(unit_lower_weapon player0 1)
			(unit_lower_weapon player1 1)
			(unit_lower_weapon player2 1)
			(unit_lower_weapon player3 1)
			(sleep 1)
			
			(ai_erase sq_unsc_crv_sbr_start0)	
			(object_destroy_folder v_corvette_sabres)
			(object_destroy_folder v_landing_sabres)
			
			(garbage_collect_now)
			
			;(m45_cin_corvette_land_on_blockout)
			(f_play_cinematic_advanced 045lc_aftship_landing set_corvettecombat_050_070 set_aftship_050_070)
			;(switch_zone_set set_aftship_050_070)
			;(045lc_aftship_landing)
			; -------------------------------------------------


	(set b_brd_completed TRUE)
)



; =================================================================================================
; COMMUNICATIONS
; =================================================================================================
(global boolean b_repressurization_complete false)
(global real r_corvette_low_gravity 0.23)
; -------------------------------------------------------------------------------------------------
(script dormant com_encounter
	(if debug (print "encounter: comms center"))
	(set s_current_encounter s_com_encounter_index)
	; (data_mine_set_mission_segment "comms")
	(game_insertion_point_unlock 2)
	
	(kill_volume_enable kill_crv_01)
	(kill_volume_enable kill_soft_comms_00)
	(kill_volume_enable kill_soft_comms_01)
	(kill_volume_enable kill_soft_comms_02)
	(kill_volume_enable kill_soft_comms_03)	
	(soft_ceiling_enable soft_ceiling_ship_01 1)
	
	; zone sets
	(set player_respawn_check_airborne 1)
	(ai_disregard (players) false)
	
	; sound scripting
	(sound_class_set_gain amb 0 0)
	(sound_disable_acoustic_palette space_filter_loop)
	
	;(prepare_to_switch_to_zone_set set_hangar_050_070_060)
	(object_create sc_crv_shutters)
	
	
	(sound_start_global_effect space_lopass 1)
	(physics_set_gravity r_corvette_low_gravity)
	
	; object management
	(object_destroy sc_aft_top)
	(object_create_folder sc_comms)	

	(object_cannot_take_damage sc_comms_sabre0)
	(object_cannot_take_damage sc_comms_sabre1)
	(object_cannot_take_damage sc_comms_sabre2)
	(object_cannot_take_damage sc_comms_sabre3)
	
	(object_create_folder bp_aft)
	(object_create_folder wp_aft)
	(object_create_folder wp_aft)
	
	
	(set_sabre_respawns false)
	(ai_lod_full_detail_actors 30)
	
	; savannah
	(com_savannah_chase)
	(if ambient_battle (wake amb_corvette_battle))
	(if ambient_battle (savannah_load_gunners dm_savannah_comms))
		(if debug (print "savannah gunners targeting nothing"))
		
	(ai_erase sq_unsc_sav_gunners/gunner_left_top01)
	(ai_erase sq_unsc_sav_gunners/gunner_left_top02)
	(ai_erase sq_unsc_sav_gunners/gunner_left_top03)
	(ai_erase sq_unsc_sav_gunners/gunner_left_bottom01)
	(ai_erase sq_unsc_sav_gunners/gunner_left_bottom02)
	(ai_erase sq_unsc_sav_gunners/gunner_rear_bottom01)
	
	(ai_set_targeting_group sq_unsc_sav_gunners s_tg_ambient_battle false)
	(ai_set_clump sq_unsc_sav_gunners CLUMP_SABRES)
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_right_top01 cs_amb_savannah_guns_high)
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_right_top02 cs_amb_savannah_guns_high)
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_right_top03 cs_amb_savannah_guns_high)
	
	;(cs_run_command_script sq_unsc_sav_gunners/gunner_right_bottom01 cs_amb_savannah_guns_low)
	(setup_corvette_cannons_comms)
			
	; ai
	
	(fireteam_setup)
	(ai_place sq_unsc_com_pilots/pilot0)
	(ai_place sq_unsc_com_pilots/pilot1)
	(ai_place sq_unsc_com_pilots/pilot2)
	(ai_set_fireteam_absorber sq_unsc_com_pilots true)
	(sleep 1)
	(ai_set_objective gr_unsc_pilots obj_unsc_com)
	(ai_set_objective fireteam_player0 obj_unsc_com)
	
	(ai_place sq_cov_com_elite_jetpacks1) ; top guys
	
	
	
	(ai_place sq_cov_com_jetpack_aft0)
	(thespian_performance_activate thespian_com_elite_terminal0)
	
	(ai_place sq_cov_com_jetpack_aft1)
	(thespian_performance_activate thespian_com_elite_terminal1)
	
	; scripts
	(wake com_completion_control)
	(wake save_com_halfway)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_com_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			;(mus_stop mus_warp)
			(replenish_players)
			;(unit_add_equipment player0 m45_default_profile true false)
			(cinematic_exit_into_title 045lc_aftship_landing true)
			
			; zone set triggers get turned on post-cinematic
			(zone_set_trigger_volume_enable begin_zone_set:set_hangar_050_070_060 true)
			(zone_set_trigger_volume_enable zone_set:set_hangar_050_070_060 true)
			
			(wake show_chapter_title_corvette)
			(game_save)
			(wake md_com_hol_intro)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_com_objcon_010) 1)		
	(if debug (print "objective control: comms 010"))
	(set s_objcon_com 10)
	
	(sleep_until (volume_test_players tv_com_objcon_020) 1)		
	(if debug (print "objective control: comms 020"))
	(set s_objcon_com 20)
	
			; -------------------------------------------------
			(render_weather 0)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_com_objcon_030) 1)		
	(if debug (print "objective control: comms 030"))
	(set s_objcon_com 30)
	
	(sleep_until (volume_test_players tv_com_objcon_040) 1)		
	(if debug (print "objective control: comms 040"))
	(set s_objcon_com 40)	
	
	;(sleep_until b_repressurization_complete)
	
	;(set b_com_completed true)
)

(script static boolean com_terminals_alert
	(or 
		(>= s_objcon_com 30)
		(volume_test_objects tv_com_objcon_030 (ai_actors gr_unsc_pilots))
	)
)

(script static void fireteam_setup
	;(sleep_until (> (player_count) 0))
		(if debug (print "::: global ::: setting up fireteams..."))
		(ai_player_add_fireteam_squad player0 fireteam_player0)
		(ai_player_set_fireteam_max player0 4)
		(ai_player_set_fireteam_max_squad_absorb_distance player0 100)
)

(script dormant com_prepare_hangar_zoneset
	(sleep 300)
	(prepare_to_switch_to_zone_set set_hangar_050_070_060)
)

(script dormant save_com_halfway
	(sleep 30)
	(sleep_until (< (ai_strength gr_cov_com) 0.5))
	(if debug (print "save 50 percent dead"))
	(game_save_no_timeout)
)

; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------
(script dormant com_completion_control
	(sleep_until (> (ai_living_count gr_cov_com) 0))
	;(sleep_until (<= (ai_living_count sq_cov_com_elite_jetpacks0) 0) 30 (* 30 180))
	;(f_blip_ai gr_cov_com blip_neutralize)
	(sleep_until (<= (ai_living_count gr_cov_com) 0) 30 (* 30 240))	
	(sleep 60)
	(game_save)
	(set b_com_completed true)
)

(script command_script cs_com_buggers_exit
	(cs_enable_looking false)
	(cs_enable_targeting false)
	
	(cs_fly_by ps_com_buggers/exit0)
	(cs_fly_by ps_com_buggers/exit1)
	(cs_fly_by ps_com_buggers/erase)
	(ai_erase ai_current_actor) 
)

(script command_script cs_com_jetpacks_start
	;(cs_jump 80 5)
	(cs_enable_looking 0)
	(cs_enable_targeting 0)
	(cs_enable_moving 0)
	(cs_shoot 0)
	
	(sleep (random_range 90 120))
	
	(cs_enable_looking 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(cs_enable_moving 0)
	(cs_go_to_nearest ps_com_jetpacks)
)



; =================================================================================================
; HANGAR
; =================================================================================================
(global short s_hgr_cov_count 0)
(global short s_hgr_bravo_position -1) ; 0 = front left; 1 = front right; 2 = rear
(global boolean b_hgr_cov_follow false)
(global boolean b_hgr_switch_flipped false)
; -------------------------------------------------------------------------------------------------
(script dormant hgr_encounter
	(if debug (print "encounter: hangar"))
	(set s_current_encounter s_hgr_encounter_index)
	; (data_mine_set_mission_segment "hangar")
	;(game_save)	
	(physics_set_gravity r_corvette_low_gravity)
	
	(kill_volume_enable kill_crv_01)
	
	
	;(object_destroy fx_space_junk_huge_01)
	(garbage_collect_now)
	
	(object_create c_hangar_door)
	(device_set_power c_hangar_door 0)
	
	; scripts
	(wake hgr_atmosphere_control)
	(wake hgr_player_teleport_control)
	(wake hgr_follow_control)
	(wake hgr_engineer_escape_control)
	
	
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_hgr_started true)
	; -------------------------------------------------

			; -------------------------------------------------
			(ai_set_objective gr_unsc_pilots obj_unsc_hgr)
			(md_hgr_hol_intro)
			(wake show_objective_go_to_hangar)
				
			(switch_zone_set set_hangar_050_070_060)
			(sleep 5)
			
			(wake save_hgr_start)
			
			(object_create_folder bp_hgr)
			(object_create_folder wp_hgr)
			
			; object management
			(object_create_folder_anew cr_hgr)
			(object_create_folder_anew sc_hgr)
			
			
			; place the ai
			(ai_place gr_cov_hgr)
			
			
			(device_set_position dm_door_comms_exit 1)
			(f_blip_flag fl_hangar_entrance blip_recon)		
			; -------------------------------------------------

	(sleep_until (volume_test_players tv_hangar_objcon_010) 1)
	(if debug (print "objective control: hangar 010"))
	(set s_objcon_hgr 10)
	
			; -------------------------------------------------
			(game_save)
			(wake md_hgr_pl2_on_our_way)
			; -------------------------------------------------
		
	(sleep_until (volume_test_players tv_hangar_objcon_020) 1)
	(if debug (print "objective control: hangar 020"))
	(set s_objcon_hgr 20)
	
	(sleep_until (> (device_get_position dm_door_com_hgr) 0) 1)
	
			; -------------------------------------------------
			(f_unblip_flag fl_hangar_entrance)
			;(ai_place sq_cov_hgr_initial_elites0)
			;(ai_place sq_cov_hgr_initial_grunts0)
			;(ai_place sq_cov_hgr_initial_jackals0)
			(game_save)
			;(ai_place sq_cov_hgr_alpha_elites1)
			
			(set b_hgr_teleport_players_forward true)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_hangar_objcon_030) 1)
	(if debug (print "objective control: hangar 030"))
	(set s_objcon_hgr 30)
	
			; -------------------------------------------------
			(wake save_hgr_halfway)
			; -------------------------------------------------
	(sleep_until  (<= (ai_living_count gr_cov_hgr) 3) 30 (* 30 600))
		
			; bug fix 62390 -----------------------------------
			(sleep 30)
			(f_blip_ai gr_cov_hgr blip_hostile)
			; -------------------------------------------------
			
	(sleep_until (<= (ai_living_count gr_cov_hgr) 0) 30 (* 30 120))

			; -------------------------------------------------
			(sleep 90)
			(set b_hgr_repressurize true)
			(game_save)
			(wake md_hgr_jor_go_for_controls)
			(device_set_power c_hangar_door 1)
			(f_blip_object c_hangar_door blip_interface)
			; -------------------------------------------------
		
	(sleep_until (> (device_group_get dg_hangar) 0))
		
			; -------------------------------------------------
			(sleep 10)
			(if debug (print "hangar: playing pelican cinematic..."))
			(f_unblip_object c_hangar_door)
			(set b_hgr_switch_flipped true)
			
			(cinematic_enter 045le_bomb_delivery true)
			(sleep 30)
			
			;(object_destroy cr_hgr_barrier0)
			;(object_destroy cr_hgr_barrier1)
			;(object_destroy cr_hgr_barrier2)
			
			(object_destroy_folder sc_hgr)
			(object_destroy_folder cr_hgr)
			(object_destroy_folder sc_comms)
			(object_destroy_folder bp_aft)
			(object_destroy_folder wp_aft)
			(object_destroy_folder dm_savannah)
			
			(ai_erase_all)
			(garbage_collect_unsafe)
			;(switch_zone_set set_gunroom_050_060_065)
			;(mus_stop mus_04mart)
			
			; kill the zone set triggers
			(zone_set_trigger_volume_enable begin_zone_set:set_hangar_050_070_060 false)
			(zone_set_trigger_volume_enable zone_set:set_hangar_050_070_060 false)
			
			(f_play_cinematic_advanced 045le_bomb_delivery set_gunroom_050_060_065 set_gunroom_050_060_065)
			
			(teleport_players
				fl_gunroom_player0
				fl_gunroom_player1
				fl_gunroom_player2
				fl_gunroom_player3)
			
			;(object_create sc_final_pelican)
			; -------------------------	------------------------
	
	(set b_hgr_completed TRUE)
)

(script dormant hgr_follow_control
	(sleep_until (>= s_objcon_hgr 30))
	(sleep (random_range (* 30 7) (* 30 12)))
	(set b_hgr_cov_follow true)
)

(global boolean b_hgr_teleport_players_forward false)
(script dormant hgr_player_teleport_control
	(sleep_until b_hgr_teleport_players_forward)
	(teleport_players_not_in_bsp
		11
		fl_hangar_teleport0
		fl_hangar_teleport1
		fl_hangar_teleport2
		fl_hangar_teleport3)
	
	(object_create sc_aft_top)
	(object_destroy sc_crv_shutters)
	
	(soft_ceiling_enable soft_ceiling_ship_01 0)
)

(script dormant save_hgr_initial
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_hgr_wave0
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_hgr_wave1
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_hgr_halfway
	(sleep_until (<= (ai_strength gr_cov_hgr) 0.5))
	(sleep 30)
	(game_save_no_timeout)
)

(script dormant save_hgr_start
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_hangar))
	(sleep 90)
	
	(if debug (print "save hangar start"))
	(game_save_no_timeout)
)


; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------
(global boolean b_hgr_repressurize false)

(script dormant hgr_atmosphere_control
	(sleep_until b_hgr_repressurize)
	
			; -------------------------------------------------
			(sound_stop_global_effect space_lopass)
			(sound_impulse_start sound\levels\solo\m45\airlock\airlock_repressurize.sound NONE 1)
			
			(sleep 45)
			(sound_class_set_gain amb 1.0 90)
			(sound_impulse_start sound\levels\solo\m45\corvette_power_up.sound NONE 1)
			
			(physics_set_gravity 1.0)
			; -------------------------------------------------
			
	
	;*
	(sleep_until
		(and
			(f_ai_is_defeated sq_cov_hgr_breachers0)
			(volume_test_players tv_hgr_entrance_hall_airlock)))
	
			; -------------------------------------------------
			(device_closes_automatically_set dm_door_comms_exit true)
			(device_set_position dm_door_comms_exit 0)
				
			(teleport_players_not_in_volume 
				tv_hgr_entrance_hall
				fl_hgr_hall_player0
				fl_hgr_hall_player1
				fl_hgr_hall_player2
				fl_hgr_hall_player3)
			; -------------------------------------------------
		
	(sleep_until (<= (device_get_position dm_door_comms_exit) 0) 1)
	
			; -------------------------------------------------
			(device_set_power dm_door_comms_exit 0)
			(ai_kill gr_cov_com)
			(sound_stop_global_effect space_lopass)
			(sound_impulse_start sound\levels\solo\m45\airlock\airlock_repressurize.sound NONE 1)
			(physics_set_gravity 1.0)
			
			(device_operates_automatically_set dm_door_com_hgr true)
						
			(object_create_folder_anew cr_hgr)
			(object_create_folder_anew sc_hgr)
			
			(kill_volume_disable kill_soft_comms_00)
			(kill_volume_disable kill_soft_comms_01)
			(kill_volume_disable kill_soft_comms_02)
			(kill_volume_disable kill_soft_comms_03)
			
			;(ai_place sq_cov_hgr_bravo_shade0/shade)
	
			;(hgr_savannah_chase)
			(setup_corvette_cannons_hangar)
			
			(wake md_hgr_tr1_savannah_hitting_hard)
			
			(game_save)
			; -------------------------------------------------
		*;
)

(script static boolean hgr_player_at_front
	(volume_test_players tv_hgr_front))
	
(script static boolean hgr_player_at_rear
	(volume_test_players tv_hgr_rear))
	
(script static boolean hgr_player_at_left
	(volume_test_players tv_hgr_left))
	
(script static boolean hgr_player_at_right
	(volume_test_players tv_hgr_right))
	
(script static boolean hgr_player_on_platform
	(or
		(volume_test_players tv_hgr_platform_rear)
		(volume_test_players tv_hgr_platform_front_left)
		(volume_test_players tv_hgr_platform_front_right)))
		
(script dormant hgr_engineer_escape_control
	(sleep_until (> (ai_spawn_count gr_cov_hgr_engineers) 0))
	
	(sleep_until
		(= 	(ai_living_count gr_cov_hgr) (ai_living_count gr_cov_hgr_engineers)))
		
	(cs_run_command_script gr_cov_hgr_engineers cs_hgr_engineer_despawn)
)	


(script command_script cs_hgr_engineer_despawn
	(cs_fly_by ps_hgr_engineer/exit0)
	(cs_fly_by ps_hgr_engineer/exit1)
	(cs_fly_by ps_hgr_engineer/erase)
	(ai_erase ai_current_actor)
)
; =================================================================================================
; GUNROOM
; =================================================================================================
(global boolean b_grm_hall_elites_flanked false)
(global boolean b_grm_doors_open false)
(global object_list l_pilots (players))

; FIRETEAM
; -------------------------------------------------------------------------------------------------
(script static void (weaken_pilot (short index))
	(if debug (print "pinning pilot's vitality"))
	(unit_set_maximum_vitality (unit (list_get l_pilots index)) .10 0)
	(unit_set_current_vitality (unit (list_get l_pilots index)) .10 0)
)

(script static void (bring_pilot_to_gunroom (short index) (boolean from_hangar))
	(if 
		(and
			(> (object_get_health (list_get l_pilots index)) 0)
			(!= (object_get_bsp (list_get l_pilots index)) 12)
		)
		
		(begin
			(if debug (print "bringing a fireteam member to the gunroom"))
			(if (= from_hangar true)
				(object_teleport (list_get l_pilots index) fl_grm_fireteam_from_hangar)
				(object_teleport (list_get l_pilots index) fl_grm_fireteam_from_bridge)
			)
		)
	)
)



; -------------------------------------------------------------------------------------------------
(script dormant grm_encounter
	(if debug (print "encounter: gunroom"))
	(set s_current_encounter s_grm_encounter_index)
	; set eighth mission segment
	(data_mine_set_mission_segment "m45_08_grm_encounter")
	
	
	; zone sets
	(zone_set_trigger_volume_enable begin_zone_set:set_hangar_050_070_060		false)
	(zone_set_trigger_volume_enable zone_set:set_hangar_050_070_060				false)
	(zone_set_trigger_volume_enable zone_set:set_gunroom_050_060_065			true)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		true)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			true)
	
	; kill volumes
	(kill_volume_enable kill_crv_01)
	(soft_ceiling_enable soft_ceiling_ship_01 0)
	
	; door management
	(device_set_position_immediate dm_door_com_hgr 0)
	(device_one_sided_set dm_door_com_hgr 1)
	(device_set_power dm_door_com_hgr 0)
	
	;(object_create_folder cr_gunroom_weapons)
	(object_create_folder cr_grm)
	(object_create_folder sc_grm)
	(object_create_folder cr_hgr)
	(object_create_folder sc_hgr)
	(setup_hangar_pelican 0)
	(sleep 1)
	
	(object_set_permutation hgr_tower0 "" destroyed)
	(object_set_permutation hgr_tower1 "" destroyed)
	;(object_destroy cr_hgr_barrier0)
	;(object_destroy cr_hgr_barrier1)
	;(object_destroy cr_hgr_barrier2)
			
	; ai

	(fireteam_setup)
	(ai_place sq_unsc_grm_pilots)
	(sleep 1)
	(set l_pilots (ai_actors sq_unsc_grm_pilots))
	(ai_set_fireteam_absorber sq_unsc_grm_pilots true)
	(sleep 1)
	(ai_set_objective gr_unsc_pilots obj_unsc_grm)

	
	; jorge
	(ai_place sq_jorge/grm)
	(sleep 1)
	(ai_set_objective sq_jorge obj_unsc_grm)
	(set ai_jorge sq_jorge)
	(ai_cannot_die ai_jorge true)
	
	; scripts
	;(wake grm_jackal_spawn)
	(wake grm_elites_hall_fallback)
	(wake grm_savannah_moment)
	(wake grm_spawn_control)
	(wake jorge_gunroom_marker_control)
	
	; zonesets and doors
	(wake grm_door_lock_return_to_hangar)
	(wake grm_door_lock_return_to_aftship)
	(wake grm_zoneset_bridge_disable)
	
	(wake save_grm_start)
	(wake amb_gunroom_battle)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_grm_started true)
	; -------------------------------------------------------------------------------------------------
	
			; -------------------------------------------------
			(replenish_players)
			(cinematic_exit 045le_bomb_delivery true)
			(wake md_grm_hol_find_bridge)
			;(new_mission_objective 14 ct_obj_bridge)
			
			
			;(open_hangar_gunroom_doors)
			; -------------------------------------------------
	
	(sleep_until (or
		(volume_test_players tv_objcon_grm_010_left)
		(volume_test_players tv_objcon_grm_010_mid)
		(volume_test_players tv_objcon_grm_010_right)) 1)	
			
	(if debug (print "objective control: gunroom 010"))
	(set s_objcon_grm 10)

	(sleep_until (volume_test_players tv_objcon_grm_020) 1)		
	(if debug (print "objective control: gunroom 020"))
	(set s_objcon_grm 20)
	
			; -------------------------------------------------
			(grm_open_breacher_fallback_door)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_grm_030) 1)		
	(if debug (print "objective control: gunroom 030"))
	(set s_objcon_grm 30)
	
	(sleep_until (volume_test_players tv_objcon_grm_040) 1)		
	(if debug (print "objective control: gunroom 040"))
	(set s_objcon_grm 40)
	
			; -------------------------------------------------
			(game_save)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_grm_050) 1)		
	(if debug (print "objective control: gunroom 050"))
	(set s_objcon_grm 50)
	
			; -------------------------------------------------
			;(grm_savannah_chase)
			;(ai_place sq_grm_cov_grunt0)
			;(ai_place sq_grm_cov_elite0)
			;(ai_place sq_grm_cov_elite1)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_grm_060) 1)		
	(if debug (print "objective control: gunroom 060"))
	(set s_objcon_grm 60)
	
			; -------------------------------------------------
			;(wake md_grm_sav_shields_low)
			;(object_destroy dm_savannah_gunroom)
			; -------------------------------------------------

	(set b_grm_completed TRUE)
)



(script dormant grm_door_lock_return_to_hangar
	(sleep_until (>= (current_zone_set) s_zoneindex_bridge) 1)
	(if debug (print "locking door back to hangar"))
	(device_set_position_immediate dm_door_hgr_grm 0)
	(device_set_power dm_door_hgr_grm 0)
	
	(sleep 1)
	(bring_pilot_to_gunroom 0 true)
	(bring_pilot_to_gunroom 1 true)
	(bring_pilot_to_gunroom 2 true)
	(bring_pilot_to_gunroom 3 true)
)

(script dormant grm_door_lock_return_to_aftship
	(device_set_position_immediate dm_door_comms_exit 0)
	(device_set_power dm_door_comms_exit 0)
)

(script dormant grm_zoneset_bridge_disable
	(sleep_until (>= (current_zone_set) s_zoneindex_bridge) 1)
	(if debug (print "disabling gunroom and bridge zoneset triggers"))
	(zone_set_trigger_volume_enable zone_set:set_gunroom_050_060_065			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		false)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			false)
)

(script dormant save_grm_start
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_gunroom))
	(sleep 90)
	(game_save_no_timeout)
)

; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------


(script dormant grm_spawn_control
	(sleep (random_range (* 30 12) (* 30 14)))
	(if debug (print "grm spawning now..."))
	
	(open_hangar_gunroom_doors)
	
	(set b_grm_doors_open true)
	
	(ai_place sq_cov_grm_hall_breachers0)
	(ai_place sq_cov_grm_hall_elites0)
	
	(wake grm_reset_suppression_control)
	
	(sleep_until (> (device_get_position dm_door_grm_entrance) 0) 1)
	
	(grm_spawn_elites)
)

(script dormant grm_reset_suppression_control
	(sleep_until
		(and
			(> (ai_spawn_count sq_cov_grm_hall_breachers0) 0)
			(> (ai_spawn_count sq_cov_grm_hall_elites0) 0)
		)
	)
	
	(sleep_until
		(and
			(<= (ai_living_count sq_cov_grm_hall_breachers0) 0)
			(<= (ai_living_count sq_cov_grm_hall_elites0) 0)
		)
	)
	
	(sleep 45)
	(if debug (print "-=-=- resetting unsc gunroom objective -=-=-"))
	(ai_reset_objective obj_unsc_grm)
	;*
	(ai_set_targeting_group gr_unsc_pilots 8 false)
	
	(sleep_until
		(or
			(>= (ai_combat_status gr_cov_grm) 5)
			(= b_brg_started true)))
			
	(ai_set_targeting_group gr_unsc_pilots -1 false)
	*;
)

(script static void grm_spawn_elites
	(if (game_is_cooperative)
		; GAME IS COOPERATIVE
		; -------------------------------------------------
		(begin
			(if debug (print "spawning cooperative gunroom elites"))
			(if (>= (game_coop_player_count) 3)
				(begin
					(if debug (print "spawning an elite at terminal 2"))
					(grm_spawn_elite_at_terminal2)
				)
			)
			
			; spawning elites at terminal 0 and 1
			(grm_spawn_elite_at_terminal0)
			(grm_spawn_elite_at_terminal1)
		)
		
		; GAME IS SINGLEPLAYER
		; -------------------------------------------------
		(begin
			(if debug (print "spawning singleplayer gunroom elites"))
			(if (difficulty_is_legendary)
				(begin
					(if debug (print "legendary spawning an elite at the far terminal"))
					(grm_spawn_elite_at_terminal2)
				)
			)
				
			(if debug (print "randomly spawning an elite at terminal 1 or 2"))
			(begin_random_count 1
				(grm_spawn_elite_at_terminal0)
				(grm_spawn_elite_at_terminal1))
		)
	)
)

(script static void grm_spawn_elite_at_terminal0
	(ai_place sq_cov_grm_elites0/elite0)
	(thespian_performance_activate thespian_grm_elite_terminal0)
)

(script static void grm_spawn_elite_at_terminal1
	(ai_place sq_cov_grm_elites0/elite1)
	(thespian_performance_activate thespian_grm_elite_terminal1)
)

(script static void grm_spawn_elite_at_terminal2
	(ai_place sq_cov_grm_elites0/elite2)
	(thespian_performance_activate thespian_grm_elite_terminal2)
)

(script static void open_hangar_gunroom_doors
	(device_set_power dm_gunroom_door_center 1)
	(device_set_position dm_gunroom_door_center 1)
	
	(device_set_power dm_gunroom_door_left 1)
	(device_one_sided_set dm_gunroom_door_left false)
	(device_set_position dm_gunroom_door_left 1)
	;(device_operates_automatically_set dm_gunroom_door_left false)
	(device_closes_automatically_set dm_gunroom_door_left false)
	
	
	(device_set_power dm_gunroom_door_right 1)
	(device_one_sided_set dm_gunroom_door_right false)
	;(device_set_position dm_gunroom_door_right 1)
	
	(device_set_power dm_grm_hall_left 1)
	(device_one_sided_set dm_grm_hall_left false)
	(device_operates_automatically_set dm_grm_hall_left true)
	
	
	(device_set_power dm_grm_hall_right 1)
	(device_one_sided_set dm_grm_hall_right false)
	(device_operates_automatically_set dm_grm_hall_right true)
)

(script static void grm_open_breacher_fallback_door
	(device_operates_automatically_set dm_door_hgr_grm true)
)

(script dormant grm_elites_hall_fallback
	(sleep_until
		(or 
			(>= (device_get_position dm_grm_hall_left) 1.0)
			(>= (device_get_position dm_grm_hall_right) 1.0)
			(>= s_objcon_grm 30)))
			
	(if debug (print "grm: elites granted fallback permission..."))
	(set b_grm_hall_elites_flanked true)
)

(script dormant grm_jackal_spawn
	(sleep_until (>= s_objcon_grm 60))
	
	(sleep_until (<= (ai_living_count gr_cov_grm) 2) 30 (* 30 60))
	
	(ai_place sq_cov_grm_jackals0)
)



; =================================================================================================
; BRIDGE
; =================================================================================================
(script dormant brg_encounter
	(if debug (print "encounter: bridge"))
	(set s_current_encounter s_brg_encounter_index)
	; (data_mine_set_mission_segment "bridge")
	
	; zone sets
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		false)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		true)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			true)
	
	; kill volumes
	(kill_volume_enable kill_crv_01)
	(soft_ceiling_enable soft_ceiling_ship_01 0)
	
	(object_create_folder cr_bridge)
	
	; scripts
	(wake brg_switch_control)
	(wake brg_stealth_control)
	(wake save_brg_specops_defeated)
	(wake save_brg_captain_defeated)
	(wake brg_prop_control)
	
	(wake save_brg_start)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_brg_started true)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			
			;(mus_stop mus_gunroom)
			(ai_set_objective gr_unsc_pilots obj_unsc_brg)
			(wake md_brg_tr5_looks_like_bridge)
			; -------------------------------------------------
	
	
	(sleep_until (volume_test_players tv_objcon_brg_010) 1)		
	(if debug (print "objective control: bridge 010"))
	(set s_objcon_brg 10)
	
			; -------------------------------------------------
			(ai_place sq_cov_brg_grunts0)
			(ai_place sq_cov_brg_captain)
			(if
				(and
					(> (game_coop_player_count) 1)
					(difficulty_is_legendary)
				)
				(ai_place sq_cov_brg_captain2)
			)
			(ai_place sq_cov_brg_specops0)
			(ai_place sq_cov_brg_specops1)
			(ai_place sq_cov_brg_specops2)
			
			(thespian_performance_activate thespian_brg_elite_terminal0)
			(thespian_performance_activate thespian_brg_elite_terminal5)
			;(game_save)
			(ai_magically_see gr_unsc gr_cov_brg)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_brg_020) 1)		
	(if debug (print "objective control: bridge 020"))
	(set s_objcon_brg 20)
	
			; -------------------------------------------------
			(weaken_pilot 0)
			
			;(object_create sc_brg_globe)
			
			;(object_create sc_brg_blocker)
			(sleep 1)
			;(object_cannot_take_damage sc_brg_blocker)
			(lnos_setup_bridge)
			
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_brg_030) 1)		
	(if debug (print "objective control: bridge 030"))
	(set s_objcon_brg 30)
	
	(sleep_until (volume_test_players tv_objcon_brg_040) 1)		
	(if debug (print "objective control: bridge 040"))
	(set s_objcon_brg 40)
	
	(sleep_until (= (device_group_get dg_bridge) 1) 1)
	
			; -------------------------------------------------
			(set b_brg_completed true)
			; -------------------------------------------------
)

(script dormant brg_prop_control
	(sleep_until (> (device_get_position dm_door_bridge_entrance) 0) 1)
	
	(if debug (print "placing bridge props"))
	(object_create_folder sc_brg)
	
)

(script dormant save_brg_start
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_bridge))
	(sleep 60)
	(if debug (print "save bridge start"))
	(game_save_no_timeout)
)

(script dormant save_brg_specops_defeated
	(sleep_until
		(and 
			(> (ai_spawn_count sq_cov_brg_specops0) 0)
			(> (ai_spawn_count sq_cov_brg_specops1) 0)
			(> (ai_spawn_count sq_cov_brg_specops2) 0)
		)
	)
	
	(sleep_until
		(and
			(<= (ai_living_count sq_cov_brg_specops0) 0)
			(<= (ai_living_count sq_cov_brg_specops1) 0)
			(<= (ai_living_count sq_cov_brg_specops2) 0)
		)
	)
	
	(if debug (print "save specops defeated"))
	(game_save_no_timeout)
	
)

(script dormant save_brg_captain_defeated
	(sleep_until (> (ai_spawn_count gr_cov_brg_captain) 0))
	(sleep_until (<= (ai_living_count gr_cov_brg_captain) 0))
	
	(sleep 60)
	(if debug (print "save capatain defeated"))
	(game_save_no_timeout)
)

; ENCOUNTER LOGIC
; -------------------------------------------------------------------------------------------------
(script dormant brg_switch_control
	(sleep_until (> (ai_living_count gr_cov_brg) 0))
	(sleep_until (<= (ai_living_count gr_cov_brg) 2))
	;(f_blip_ai gr_cov_brg blip_neutralize)
	(sleep_until (<= (ai_living_count gr_cov_brg) 0) 30 (* 30 240))
	
			; -------------------------------------------------
			(sleep 120)
			(if debug (print "brg: enemies defeated. blipping the console..."))
			(md_brg_hol_move_lieutenant)
			(sleep 15)
			(wake show_objective_engage_refuel)
			(f_blip_object c_bridge_refuel blip_interface)
			(device_set_power c_bridge_refuel 1.0)
			
			(mus_stop mus_09)
			; -------------------------------------------------

	(sleep_until (> (device_group_get dg_bridge) 0))
	
			; -------------------------------------------------	
			(if debug (print "brg: player has flipped the switch..."))
			
			(f_unblip_object c_bridge_refuel)
			(device_set_power c_bridge_refuel 0)
			(f_unblip_ai gr_cov_brg)
			(lnos_arrive)
			; -------------------------------------------------
)

(script dormant brg_stealth_control
	(sleep_until (> (ai_spawn_count gr_cov_brg) 0))
	(sleep 30)
	(sleep_until 
		(or
			(<= (ai_living_count sq_cov_brg_captain) 0)
			(<= (ai_living_count sq_cov_brg_specops0) 0)
			(<= (ai_living_count sq_cov_brg_specops1) 0)
			(<= (ai_living_count sq_cov_brg_specops2) 0)
		)
	)
	
	(if debug (print "bridge squads have better vision"))
	(ai_remove_cue cue_brg_unaware)
)

(script static boolean (branch_terminal_elite (ai my_actor) (ai group)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) 0)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
        (>= (ai_combat_status group) 5)
        ;(<= (ai_living_count gr_spire_top_cov) 3)
	)
)

(script static boolean (branch_grm_terminal_elite (ai my_actor) (ai group)) 
	(or
		(> (object_get_recent_shield_damage (ai_get_object my_actor)) 0)
		(> (object_get_recent_body_damage (ai_get_object my_actor)) 0)
        (>= (ai_combat_status group) 5)
        (= b_grm_terminals_alert true)
        ;(<= (ai_living_count gr_spire_top_cov) 3)
	)
)

(script command_script cs_brg_captain_patrol
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to ps_brg_elites/captain0)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain1)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain2)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain3)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain4)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain5)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/captain6)
					(captain_delay_before_shift))					
			)
			
		0)
	1)
)

(script command_script cs_brg_globe_patrol
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_push_stance patrol)
	(cs_walk true)
	
	(cs_face true ps_brg_elites/globe_center)
	
	(sleep_until (>= s_objcon_brg 10))
	(sleep (random_range 120 210))
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to ps_brg_elites/globe1)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/globe2)
					(captain_delay_before_shift))
					
				(begin
					(cs_go_to ps_brg_elites/globe3)
					(captain_delay_before_shift))				
			)
			
		0)
	1)
)


(script static void captain_delay_before_shift
	(sleep (random_range 120 400))
)


(script command_script cs_brg_stand_in_place
	;(cs_enable_looking false)
	(cs_stow true)
	(cs_abort_on_alert true)
	(cs_abort_on_damage true)
	(cs_enable_moving false)
	
	(cs_push_stance patrol)
	(sleep_until (>= (ai_combat_status gr_cov_brg) 3))
)


; =================================================================================================
; ESCAPE
; =================================================================================================
(script dormant esc_encounter
	(if debug (print "encounter: escape"))
	(set s_current_encounter s_esc_encounter_index)
	; set ninth mission segment
	(data_mine_set_mission_segment "m45_09_esc_encounter")
	(game_save)
	
	(kill_volume_enable kill_crv_01)
	(soft_ceiling_enable soft_ceiling_ship_01 0)
	
	(teleport_players_not_in_volume
			tv_brg_teleport_safezone
			fl_brg_teleport0
			fl_brg_teleport1
			fl_brg_teleport2
			fl_brg_teleport3)
	
	(sleep 5)
	
	; zone sets
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_050_065_080 		false)
	(zone_set_trigger_volume_enable zone_set:set_bridge_050_065_080 			false)
	(zone_set_trigger_volume_enable begin_zone_set:set_escape_050_065_060 		true)
	(zone_set_trigger_volume_enable zone_set:set_escape_050_065_060 			true)
	
	; ai
	(ai_place sq_cov_esc_breach0)
	;(ai_place sq_cov_esc_halls0)
	;(ai_place sq_cov_esc_gunroom0)
	;(ai_place sq_cov_esc_gunroom1)
	(ai_set_objective gr_unsc_pilots obj_unsc_esc)
	
	(wake esc_door_lock_return_to_bridge)
	(wake esc_door_unlock_return_to_hangar)
	(wake esc_door_unlock_hangar_center)
	
	(set b_esc_started true)
	
			; -------------------------------------------------
			(wake md_esc_hol_well_done)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_esc_020) 1)
	(if debug (print "objective control: escape 020"))
	(set s_objcon_esc 20)
	
			; -------------------------------------------------
			(game_save)
			(weaken_pilot 1)
			; -------------------------------------------------
	
	(sleep_until (volume_test_players tv_objcon_esc_030) 1)
	(if debug (print "objective control: escape 030"))
	(set s_objcon_esc 30)
	
			; -------------------------------------------------
			(ai_place sq_cov_esc_gunroom0)
			(wake md_esc_at_your_earliest)
			; -------------------------------------------------

	
	(set b_esc_completed true)
)

(script dormant esc_door_lock_return_to_bridge
	(sleep_until (>= (current_zone_set) s_zoneindex_escape) 1)
	
	(if debug (print "locking the door back to bridge..."))
	(device_set_position_immediate dm_door_bridge_entrance 0)
	(device_operates_automatically_set dm_door_bridge_entrance 0)
	(sleep 1)
	(device_set_power dm_door_bridge_entrance 0)
	(sleep 1)
	(bring_pilot_to_gunroom 0 false)
	(bring_pilot_to_gunroom 1 false)
	(bring_pilot_to_gunroom 2 false)
	(bring_pilot_to_gunroom 3 false)
	
)

(script dormant esc_door_unlock_return_to_hangar
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_escape) 1)
	(if debug (print "unlocking door back to hangar"))
	(device_set_power dm_door_hgr_grm 1)
	(device_operates_automatically_set dm_door_hgr_grm true)
)

(script dormant esc_door_unlock_hangar_center
	(sleep_until (>= (current_zone_set_fully_active) s_zoneindex_escape) 1)
	(if debug (print "unlocking hangar center_door"))
	(device_set_power dm_gunroom_door_center 1)
	(device_operates_automatically_set dm_gunroom_door_center false)
	(device_set_position dm_gunroom_door_center 1)
)
; =================================================================================================
; FINAL HANGAR ENCOUNTER
; =================================================================================================
(global boolean b_fin_attempt_save false)
(global boolean b_fin_firefight_started false)
(global boolean b_fin_jorge_follow false)
; -------------------------------------------------------------------------------------------------
(script dormant fin_encounter
	(if debug (print "encounter: final"))
	(set s_current_encounter s_fin_encounter_index)
	; set tenth mission segment
	(data_mine_set_mission_segment "m45_10_fin_encounter")
	
	; zone sets
	(zone_set_trigger_volume_enable begin_zone_set:set_escape_050_065_060 		true)
	(zone_set_trigger_volume_enable zone_set:set_escape_050_065_060 			true)
	
	(kill_volume_enable kill_crv_01)
	(soft_ceiling_enable soft_ceiling_ship_01 0)
	
	(device_one_sided_set dm_gunroom_door_right true)
	(device_one_sided_set dm_gunroom_door_left true)
	(device_one_sided_set dm_grm_hall_right true)
	(device_one_sided_set dm_grm_hall_left true)
	
	; ai
	;(ai_place sq_cov_fin_hunters0)
	(ai_place sq_cov_fin_initial0)
	(ai_place sq_cov_fin_initial1)
	
	; jorge
	(ai_erase sq_jorge)
	(ai_place sq_jorge/fin)
	(sleep 1)
	(ai_set_objective sq_jorge obj_unsc_fin)
	(set ai_jorge sq_jorge)
	(ai_cannot_die ai_jorge true)
	
	;(ai_place sq_unsc_fin_jorge)
	;(ai_cannot_die sq_unsc_fin_jorge true)
	(setup_hangar_pelican 1)
	(object_create_folder sc_hgr)
	(object_create_folder cr_hgr)
	(object_create_folder bp_fin)
	(object_set_permutation hgr_tower0 "" destroyed)
	(object_set_permutation hgr_tower1 "" destroyed)
	(object_set_permutation hgr_tower2 "" destroyed)
	
	(wake jorge_final_marker_control)
	
	(object_create dm_door_fin_coms_blocker)
	
	; OBJECTIVE CONTROL
	; -------------------------------------------------------------------------------------------------
	(set b_fin_started TRUE)
	; -------------------------------------------------------------------------------------------------

			; -------------------------------------------------
			(mus_start mus_10)
			(ai_set_objective gr_unsc_pilots obj_unsc_fin)
			;(new_mission_objective 15 ct_obj_final)
			
			(game_save)
			; -------------------------------------------------
			
	(sleep_until (volume_test_players tv_objcon_fin_010) 1)
	(if debug (print "objective control: final 020"))
	(set s_objcon_fin 10)
	
	(sleep_until (<= (ai_living_count gr_cov_fin) 1))
	(wake md_fin_jor_good_of_you)
	(sleep (random_range (* 30 12) (* 30 16)))
			
			; -------------------------------------------------
			
			(fin_firefight)
			; -------------------------------------------------
	
	(sleep_until b_fin_waves_complete)
	(sleep_until (<= (ai_living_count gr_cov_fin) 0))
			; -------------------------------------------------
			(sleep 60)
			(f_unblip_flag fl_fin_slipspace)
			(md_fin_jor_and_stay_down)
			(mus_stop mus_10)
			(sleep 30)
			
			; -------------------------------------------------
	
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_jorge)) 4))

			; -------------------------------------------------
			
			; -------------------------------------------------

	(set b_fin_completed true)
)


; COMBAT
; -------------------------------------------------------------------------------------------------
(global boolean b_fin_wave_fallback false)
(global short s_fin_wave 0)
(global boolean b_fin_waves_complete false)
; -------------------------------------------------------------------------------------------------
(script static void fin_firefight
	(device_operates_automatically_set dm_door_com_hgr true)
	(device_set_power dm_door_com_hgr 1)
	(device_one_sided_set dm_door_com_hgr 1)
	(game_save)
	;(ai_place sq_unsc_fin_jorge)
	;(sleep 1)
	;(ai_cannot_die sq_unsc_fin_jorge true)
	
	(set b_fin_firefight_started true)
	(wake fin_save_control)
	;(object_create_folder_anew sc_hgr)
	;(object_create_folder_anew cr_hgr)
	
			; -------------------------------------------------
			(sound_looping_activate_layer mus_10 1)
			(ai_place sq_cov_fin_wave0_jackals0)
			(ai_place sq_cov_fin_wave0_snipers0)
			; -------------------------------------------------
	
	(sleep_until (<= (ai_task_count obj_cov_fin/gate_wave0) 0))
	
			; -------------------------------------------------
			(sleep (random_range 120 240))
			(set b_fin_attempt_save true)
			(set s_fin_wave 1)
			(ai_place sq_cov_fin_wave1_e1g3)
			(add_recycling_volume tv_hgr_recycle 20 30)
			; -------------------------------------------------
			
	(sleep_until (<= (ai_living_count gr_cov_fin) 0))
	
			; -------------------------------------------------
			(sound_looping_deactivate_layer mus_10 1)
			(sleep (random_range 60 120))
			(set b_fin_attempt_save true)
			(set s_fin_wave 2)
			(ai_place sq_cov_fin_wave2_grunts0)
			; -------------------------------------------------
			
	(sleep_until (<= (ai_task_count obj_cov_fin/gate_wave2) 0))
	
			; -------------------------------------------------
			(sleep (random_range 90 120))
			(set b_fin_attempt_save true)
			(set s_fin_wave 3)
			(ai_place sq_cov_fin_wave3_elites0)
			; -------------------------------------------------
			
	(sleep_until (<= (ai_living_count gr_cov_fin) 0))
	
			; -------------------------------------------------
			(sleep (random_range 90 120))
			(sound_looping_activate_layer mus_10 1)
			(set b_fin_attempt_save true)
			(ai_place gr_cov_fin_boss)
			(sleep 1)
			;(ai_set_targeting_group sq_cov_fin_boss0 7 true)
			; -------------------------------------------------
	;*
	(if debug (print "starting new firefight"))
	(sleep_until
		(begin
			
			; WEAPONS SETUP
			; -------------------------------------------------
			;(object_create_folder_anew c_fin)
			;(object_create_anew dm_fin_weapons0)
			;(object_create_anew dm_fin_weapons1)
			;(object_create_anew dm_fin_weapons2)
			(object_create_anew wp_fin_plasmalauncher0)
			(weaken_pilot 2)
			
			; WAVE 0
			; -------------------------------------------------
			(set b_fin_wave_fallback false)
			(fin_wave0_spawn)
			(sleep_until (<= (ai_living_count gr_cov_fin) 6))
			(fin_wave_fallback_delay)
			(set b_fin_wave_fallback true)
			(sleep_until (<= (ai_living_count gr_cov_fin) 2))
			(fin_wave_exhaust_delay)
			(garbage_collect_now)
			(set b_fin_attempt_save true)
			
			(weaken_pilot 3)
			
			; WAVE 1
			; -------------------------------------------------
			(set b_fin_wave_fallback false)
			(fin_wave1_spawn)
			(sleep_until (<= (ai_living_count gr_cov_fin) 5))
			(fin_wave_fallback_delay) 
			(set b_fin_wave_fallback true)
			(sleep_until (<= (ai_living_count gr_cov_fin) 1))
			(sleep (random_range 180 240))
			(garbage_collect_now)
			(game_save)
			(set b_fin_attempt_save true)
			(set s_fin_wave (+ s_fin_wave 1))
			
		(>= s_fin_wave 1))
	1)
	
	*;
	
	
		
	(sleep_until (<= (ai_living_count gr_cov_fin) 0))
	
	(set b_fin_waves_complete true)
)

(script dormant fin_save_control
	(sleep_until
		(begin
			(sleep_until b_fin_attempt_save)
			(game_save_no_timeout)
			(set b_fin_attempt_save false)
		0)
	1)
)

;*
(script static void fin_wave0_spawn
	(begin_random
		(begin
			(ai_place sq_cov_fin_wave0_inf0)
			(fin_wave_squad_spawn_delay))
			
		
		(begin
			(ai_place sq_cov_fin_wave0_inf1)
			(fin_wave_squad_spawn_delay))
			
		(begin
			;(ai_place sq_cov_fin_wave0_inf2)
			(fin_wave_squad_spawn_delay))
	)
)

(script static void fin_wave1_spawn
	(begin_random
		(begin
			(ai_place sq_cov_fin_wave1_inf0)
			(fin_wave_squad_spawn_delay))
			
		
		(begin
			;(ai_place sq_cov_fin_wave1_inf1)
			(fin_wave_squad_spawn_delay))
			
		(begin
			(ai_place sq_cov_fin_wave1_flak0)
			(fin_wave_squad_spawn_delay))
	)
)



(script static void fin_wave_squad_spawn_delay
	(sleep (random_range 30 90)))
	
(script static void fin_wave_fallback_delay
	(sleep (random_range 150 300)))
	
(script static void fin_wave_exhaust_delay
	(sleep (random_range 240 300)))

*;

(script command_script cs_fin_jorge_pelican
	(cs_go_to ps_fin_jorge/jorge_dest)
	(cs_look_player true)
	(sleep_forever)
)

; =================================================================================================
; UTILITY
; =================================================================================================

(script static void (bring_spartans_forward (real dist))
	(if debug (print "bringing spartans forward..."))
	(ai_bring_forward (ai_get_object sq_jorge) dist)
	(ai_bring_forward (ai_get_object sq_carter) dist)
	(ai_bring_forward (ai_get_object sq_kat) dist)
)

(script static void (set_sabre_respawns (boolean in_vehicle))
	(if in_vehicle
		(begin
			;(player_respawn_check_airborne 0)
			(player_set_respawn_vehicle player0 "objects/vehicles/human/sabre/sabre.vehicle")
			(player_set_respawn_vehicle player1 "objects/vehicles/human/sabre/sabre.vehicle")
			(player_set_respawn_vehicle player2 "objects/vehicles/human/sabre/sabre.vehicle")
			(player_set_respawn_vehicle player3 "objects/vehicles/human/sabre/sabre.vehicle")
		)
		
		(begin
			;(player_respawn_check_airborne 1)
			(player_set_respawn_vehicle player0 none)
			(player_set_respawn_vehicle player1 none)
			(player_set_respawn_vehicle player2 none)
			(player_set_respawn_vehicle player3 none)
		)
	)
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

(script static void branch_abort
	(if debug (print "branch aborting"))
)

(script static void branch_abort_dialogue
	(if debug (print "branch aborting dialogue"))
	(md_stop)
)

(script static void hgr_test
	(object_create_folder sc_hgr)
	(object_create_folder cr_hgr)
)
; CLEANUP
; -------------------------------------------------------------------------------------------------
(script static void nuke_planet
	(if debug (print "*** NUCLEAR LAUNCH DETECTED: CLEANING UP PLANET PROPS ***"))

	
	; destroy objects
	(ai_erase_all)
	(object_destroy_folder cr_beach)
	(object_destroy_folder dm_bch_pods)
	;(object_destroy_folder dm_ambient_pods)
	(object_destroy_folder dm_slo)
	(object_destroy_folder sc_bch)
	(object_destroy_folder sc_lnc)
	(object_destroy_folder sc_fac)
	(object_destroy_folder dm_bch_skybox_pods)
	;(object_destroy_folder cr_fac)

	; disable kill volumes
	(kill_volume_disable kill_silo)
	(kill_volume_disable kill_soft_bch_01)
	(kill_volume_disable kill_soft_bch_02)
	
	; get rid of garbage chunks
	(garbage_collect_unsafe)
)

(script static void nuke_wafer
	(if debug (print "*** NUCLEAR LAUNCH DETECTED: CLEANING UP WAFER ENCOUNTER ***"))
	
	; destroy objects
	(ai_erase_all)
	(object_destroy_folder sc_waf_bays)
	(object_destroy_folder sc_waf_debris)
	;(object_destroy_folder cr_waf_asteroids)
	(object_destroy_folder cr_waf)
	
	; get rid of garbage bits
	(garbage_collect_unsafe)
)

(script static void nuke_corvette_exterior
	(if debug (print "*** NUCLEAR LAUNCH DETECTED: CLEANING UP EXTERIOR CORVETTE ***"))
	
	; destroy objects
	(ai_erase_all)
	(object_destroy_folder dm_crv_pods)
	
	; get rid of garbage bits
	(garbage_collect_unsafe)
)

; MARKING
; -------------------------------------------------------------------------------------------------
(script static void (blip_ai_object (ai actor))
	(f_blip_object (ai_get_object actor) 14))


; WARPING
; -------------------------------------------------------------------------------------------------
(global boolean b_play_warp_sound true)
; -------------------------------------------------------------------------------------------------

(script command_script cs_sabre_warp
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "ai_antenna_center")
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	(object_set_velocity (ai_vehicle_get ai_current_actor) 120)	
)

(script command_script cs_sabre_exit_station
	(ai_set_clump ai_current_actor CLUMP_SABRES)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 20)	
)

(script command_script cs_banshee_warp
	(ai_set_clump ai_current_actor CLUMP_BANSHEES)
	(ai_enable_stuck_flying_kill ai_current_actor true)
	(ai_set_stuck_velocity_threshold ai_current_actor 1)
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	(object_set_velocity (ai_vehicle_get ai_current_actor) 50)	
)

(script command_script cs_seraph_warp
	(ai_set_clump ai_current_actor CLUMP_SERAPHS)
	(ai_enable_stuck_flying_kill ai_current_actor true)
	(ai_set_stuck_velocity_threshold ai_current_actor 1)
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	(object_set_velocity (ai_vehicle_get ai_current_actor) 100)	
)

(script command_script cs_phantom_warp
	(effect_new_on_object_marker fx_warp_flash (ai_vehicle_get ai_current_actor) "fx_warp")
	;(if b_play_warp_sound
		;(sound_impulse_start sfx_warp (ai_vehicle_get ai_current_actor) 1.0))
	(object_set_velocity (ai_vehicle_get ai_current_actor) 40)	
)

(script static void banshee_warp_stagger
	(sleep (random_range 5 15)))

(script static void seraph_warp_stagger
	(sleep (random_range 5 20)))
	
(script static void sabre_station_stagger
	(sleep (random_range 15 25)))
	
(script static void sabre_warp_stagger
	(sleep (random_range 5 20)))
	
	
; TELEPORTING
; -------------------------------------------------------------------------------------------------
(script static void (teleport_players_in_volume
						(trigger_volume v)
						(cutscene_flag teleport0)
						(cutscene_flag teleport1)
						(cutscene_flag teleport2)
						(cutscene_flag teleport3))
						
	(if debug (print "teleporting players in a volume forward..."))
	
	(if (volume_test_object v player0)
		(object_teleport player0 teleport0))
		
	(if (volume_test_object v player1)
		(object_teleport player1 teleport1))
		
	(if (volume_test_object v player2)
		(object_teleport player2 teleport2))
		
	(if (volume_test_object v player3)
		(object_teleport player3 teleport3))
)

(script static void (teleport_players_not_in_volume
						(trigger_volume v)
						(cutscene_flag teleport0)
						(cutscene_flag teleport1)
						(cutscene_flag teleport2)
						(cutscene_flag teleport3))
						
	(if debug (print "teleporting players not in a volume forward..."))
	
	(if (not (volume_test_object v player0))
		(object_teleport player0 teleport0))
		
	(if (not (volume_test_object v player1))
		(object_teleport player1 teleport1))
		
	(if (not (volume_test_object v player2))
		(object_teleport player2 teleport2))
		
	(if (not (volume_test_object v player3))
		(object_teleport player3 teleport3))
)

(script static void (teleport_players
						(cutscene_flag fl0)
						(cutscene_flag fl1)
						(cutscene_flag fl2)
						(cutscene_flag fl3))
	
	(if (unit_in_vehicle player0)
		(unit_exit_vehicle player0))
	(object_teleport player0 fl0)
	
	(if (unit_in_vehicle player1)
		(unit_exit_vehicle player1))
	(object_teleport player1 fl1)
	
	(if (unit_in_vehicle player2)
		(unit_exit_vehicle player2))
	(object_teleport player2 fl2)
	
	(if (unit_in_vehicle player3)
		(unit_exit_vehicle player3))
	(object_teleport player3 fl3)
)

(script static void (teleport_players_not_in_bsp 
					(short bsp_index)
					(cutscene_flag teleport0)
					(cutscene_flag teleport1)
					(cutscene_flag teleport2)
					(cutscene_flag teleport3))
					
	(if (!= (object_get_bsp player0) bsp_index)
		(object_teleport player0 teleport0))
		
	(if (!= (object_get_bsp player1) bsp_index)
		(object_teleport player1 teleport1))
		
	(if (!= (object_get_bsp player2) bsp_index)
		(object_teleport player2 teleport2))
		
	(if (!= (object_get_bsp player3) bsp_index)
		(object_teleport player3 teleport3))
)

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
	
(script static void (f_bring_players_forward (trigger_volume volume) (unit player_name) (cutscene_flag flag))
	 (if 
		(not (volume_test_object volume player_name))
		(object_teleport player_name flag)
	)
)	
	
	
; UTILITY COMMAND SCRIPTS
; -------------------------------------------------------------------------------------------------
(script command_script cs_abort
	(sleep 1))


; HOTKEYS
; -------------------------------------------------------------------------------------------------
;*
(script static void debug_objectives
		(print "toggling objectives")
		(if ai_render_objectives
				(set ai_render_objectives 0)
				(set ai_render_objectives 1)))

(script static void debug_cs
		(print "toggling command scripts")
		(if ai_render_command_scripts
				(set ai_render_command_scripts 0)
				(set ai_render_command_scripts 1)))

(script static void debug_pathfinding
		(print "toggling sector bsps")
		(if ai_render_sector_bsps
				(set ai_render_sector_bsps 0)
				(set ai_render_sector_bsps 1)))
				
*;
; =================================================================================================
; AI TESTS
; =================================================================================================
(global boolean b_ai_test_loop 			true)

(global short s_ai_test_turret			0)
(global short s_ai_test_turret_cov		0)
(global short s_ai_test_turret_unsc		1)

(global short s_ai_test_fighter			0)
(global short s_ai_test_fighter_cov		0)
(global short s_ai_test_fighter_unsc	1)

(global short s_ai_test_distance		0)
(global short s_ai_test_distance_near 	0)
(global short s_ai_test_distance_far	1)
(global short s_ai_test_distance_orbit	2)
(global short s_ai_test_distance_buzz	3)
; -------------------------------------------------------------------------------------------------

;*
(script static void ai_test_stop
	(set b_ai_test_loop false)
	(object_destroy_folder v_test)
	(object_destroy_folder sc_test)
	(ai_erase_all))

(script static void ai_test_start
	(object_teleport player0 fl_ai_test)
)

(script static void ai_test_fly
	(vehicle_unload v_corvette_sabre_player0 "")
	(sleep 30)
	(object_create_anew v_corvette_sabre_player0)
	(vehicle_load_magic v_corvette_sabre_player0 "sabre_d" player0)
)

(script static void ai_test_fly_banshee
	(object_create_anew v_test_space_banshee)
	(vehicle_load_magic v_test_space_banshee "" player0)
)

(script static void ai_test_waf_turret
	(if debug (print "ai: placing test turret on the wafer..."))
	(ai_place sq_unsc_waf_aa/gunner_front_high)
)

(script static void ai_test_waf_screen
	(if debug (print "ai: testing banshee fighter screen..."))
	(ai_erase_all)
	(sleep 1)
	(ai_place gr_cov_waf_banshee)
	(ai_place sq_unsc_waf_aa)
)

(script static void ai_test_phantom_stationary
	(if debug (print "spawning a stationary phantom..."))
	(ai_place sq_test_phantom)
	(sleep 1)
	(cs_run_command_script sq_test_phantom/pilot cs_ai_test_phantom_stationary)
)

(script static void ai_test_phantom_no_gunners
	(if debug (print "spawning a stationary phantom..."))
	(ai_place sq_test_phantom/pilot)
	(sleep 1)
	(cs_run_command_script sq_test_phantom/pilot cs_ai_test_phantom_stationary)
)

(script command_script cs_ai_test_phantom_stationary
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(sleep_forever)
)

(script static void ai_test_waf_phantom_battle
	;(object_create_folder_anew cr_waf_asteroids)
	(physics_set_gravity 0)
	
	(sleep_until
		(begin
			(sleep_until (or
				(<= (ai_living_count gr_unsc_waf_sabres) 0)
				(<= (ai_living_count sq_test_phantom) 0)))
				
			(if (<= (ai_living_count gr_unsc_waf_sabres) 0)
				(waf_replenish_sabres)
				(ai_place sq_test_phantom))
		0)
	1)
)

; TURRET PRACTICE
; -------------------------------------------------------------------------------------------------
(script static void (ai_turret_practice (string turret_type) (string target_type))
	(set b_ai_test_loop true)
	
	
	(if (= turret_type "covenant")
		(begin
			(set s_ai_test_turret s_ai_test_turret_cov)
			(ai_place sq_test_cov_aa/targeting_test_gunner)
		)
	)
	
	(if (= turret_type "unsc")
		(begin
			(set s_ai_test_turret s_ai_test_turret_unsc)
			(ai_place sq_test_unsc_aa/targeting_test_gunner)
		)
	)
	

	(if (= target_type "near")
		(set s_ai_test_distance s_ai_test_distance_near))
		
	(if (= target_type "far")
		(set s_ai_test_distance s_ai_test_distance_far))
		
	(if (= target_type "orbit")
		(set s_ai_test_distance s_ai_test_distance_orbit))
		
	(if (= target_type "buzz")
		(set s_ai_test_distance s_ai_test_distance_buzz))
	
	(sleep_until
		(begin
			(if (= s_ai_test_turret s_ai_test_turret_cov)
				(begin
					(if (= s_ai_test_distance s_ai_test_distance_near)
						(ai_place sq_test_sabre/turret_target_near))
					
					(if (= s_ai_test_distance s_ai_test_distance_far)
						(ai_place sq_test_sabre/turret_target_far))
					
					(if (= s_ai_test_distance s_ai_test_distance_orbit)
						(ai_place sq_test_sabre/turret_target_orbit))
						
					(if (= s_ai_test_distance s_ai_test_distance_buzz)
						(ai_place sq_test_sabre/turret_target_buzz))
					
					(sleep 1)
					(ai_magically_see sq_test_cov_aa sq_test_sabre)
					(sleep_until (<= (ai_living_count sq_test_sabre) 0) 1)
				)
			)
			
			(if (= s_ai_test_turret s_ai_test_turret_unsc)
				(begin
					(if (= s_ai_test_distance s_ai_test_distance_near)
						(ai_place sq_test_seraph/turret_target_near))
					
					(if (= s_ai_test_distance s_ai_test_distance_far)
						(ai_place sq_test_seraph/turret_target_far))
					
					(if (= s_ai_test_distance s_ai_test_distance_orbit)
						(ai_place sq_test_seraph/turret_target_orbit))
						
					(if (= s_ai_test_distance s_ai_test_distance_buzz)
						(ai_place sq_test_seraph/turret_target_buzz))
				
					(sleep 1)
					(ai_magically_see sq_test_unsc_aa sq_test_seraph)
					(sleep_until (<= (ai_living_count sq_test_seraph) 0) 1)
				)
			)
			
			(if debug (print "ai: turret target destroyed... spawning another in 30 ticks..."))
			(sleep 30)
			
		(not b_ai_test_loop))
	1)
)

(script command_script cs_ai_turret_target_near
	(if debug (print "ai: spawning close-range fighter target for turret to shoot down..."))
	(cs_fly_by ps_ai_test/turret_target_dest_near)
	(ai_erase ai_current_squad)	
)

(script command_script cs_ai_turret_target_far
	(if debug (print "ai: spawning long-range fighter target for turret to shoot down..."))
	(cs_fly_by ps_ai_test/turret_target_dest_far)
	(ai_erase ai_current_squad)	
)

(script command_script cs_ai_turret_target_orbit
	(if debug (print "ai: spawning orbiting fighter target for turret to shoot down..."))
	(sleep_until
		(begin
			(cs_fly_by ps_ai_test/turret_target_orbit0)
			(cs_fly_by ps_ai_test/turret_target_orbit1)
			(cs_fly_by ps_ai_test/turret_target_orbit2)
			(cs_fly_by ps_ai_test/turret_target_orbit3)
		0)
	1)
)

(script command_script cs_ai_turret_target_buzz
	(if debug (print "ai: spawning fighter that buzzes the turret..."))
	(cs_fly_by ps_ai_test/turret_target_dest_buzz)
	(ai_erase ai_current_squad)
)	

(script static void (ai_test_turret (string type))
	(if debug (print "ai: spawning turret..."))
	(if (= type "unsc")
		(ai_place sq_test_unsc_aa/targeting_test_gunner))
		
	(if (= type "covenant")
		(ai_place sq_test_cov_aa/targeting_test_gunner))
)

(script static void (ai_test_turret_firing (string type))
	(if debug (print "ai: spawning turret that fires at a single point.."))
	
	(if (= type "unsc")
		(ai_place sq_test_unsc_aa/firing_test_gunner))
		
	(if (= type "covenant")
		(ai_place sq_test_cov_aa/firing_test_gunner))
)

(script command_script cs_test_turret_firing
	(cs_shoot_point true ps_ai_test/firing_target)
	(sleep_forever)
)

(script static void ai_test_engine_defense
	(if debug (print "ai: spawning engine defensive turrets..."))
	(ai_erase_all)
	;(ai_place sq_test_cov_aa/engine_defense0)
	(ai_place sq_test_cov_aa/engine_defense1)
	(ai_place sq_test_cov_aa/engine_defense2)
)

(script static void ai_test_corvette_aa
	(if debug (print "ai: spawning corvette aa defenses..."))
	(ai_place sq_test_cov_aa/engine_defense1)
	(ai_place sq_test_cov_aa/engine_defense2)
	(ai_place sq_test_cov_aa/corvette_defense0)
	(ai_place sq_test_cov_aa/corvette_defense1)
	(ai_place sq_test_cov_aa/corvette_defense2)
	(ai_place sq_test_cov_aa/corvette_defense3)
	
	(ai_disregard (ai_get_object sq_test_cov_aa) true)
)


; DOGFIGHTING
; -------------------------------------------------------------------------------------------------
(script static void ai_dogfight_banshee
	(if debug (print "ai: spawning a banshee dogfighter..."))
	
	(begin_random_count 1
		(ai_place sq_test_banshee/dogfighter0)
		(ai_place sq_test_banshee/dogfighter1)
		(ai_place sq_test_banshee/dogfighter2)
	)
)

(script static void ai_dogfight_banshee_flock
	(if debug (print "ai: spawning a flock of 5 banshee dogfighters..."))
	
	(ai_place sq_test_banshee/dogfighter0)
	(ai_place sq_test_banshee/dogfighter1)
	(ai_place sq_test_banshee/dogfighter2)
	(ai_place sq_test_banshee/dogfighter0)
	(ai_place sq_test_banshee/dogfighter1)
)

(script static void ai_dogfight_seraph
	(if debug (print "ai: spawning a seraph dogfighter..."))
	
	(begin_random_count 1
		(ai_place sq_test_seraph/dogfighter0)
		(ai_place sq_test_seraph/dogfighter1)
		(ai_place sq_test_seraph/dogfighter2)
	)
)

(script static void ai_dogfight_sabre
	(if debug (print "ai: spawning a sabre dogfighter..."))
	
	(begin_random_count 1
		(ai_place sq_test_sabre/dogfighter0)
		(ai_place sq_test_sabre/dogfighter1)
		(ai_place sq_test_sabre/dogfighter2)
	)
)

(script static void ai_dogfight_1v1
	(if debug (print "ai: testing 1v1 dogfight..."))
	
	(ai_erase sq_test_seraph)
	(ai_erase sq_test_sabre)
	
	(ai_dogfight_seraph)
	(ai_dogfight_sabre)
)

(script static void ai_dogfight_2v2
	(if debug (print "ai: testing 2v2 dogfight..."))
	
	(ai_erase sq_test_seraph)
	(ai_erase sq_test_sabre)
	
	(ai_dogfight_seraph)
	(ai_dogfight_seraph)
	(ai_dogfight_sabre)
	(ai_dogfight_sabre)
)

(script static void ai_test_1v1
	(if debug (print "ai: testing 1v1 -- seraph vs sabre..."))
	
	(sleep_until
		(begin
			(ai_erase sq_test_sabre)
			(ai_erase sq_test_seraph)
			
			(sleep 1)
			
			(ai_dogfight_seraph)
			(ai_dogfight_sabre)
			
			(sleep_until (or
				(<= (ai_living_count sq_test_sabre) 0)
				(<= (ai_living_count sq_test_seraph) 0)) 1)
				
			(if (<= (ai_living_count sq_test_sabre) 0)
				(if debug (print "ai: seraph wins!"))
				(if debug (print "ai: sabre wins!")))
				
		(not b_ai_test_loop))
	1)
)

(script static void (ai_test_pursuit_target (string type))
	(if debug (print "ai: spawning a pursuit target on an orbiting path..."))
	(set b_ai_test_loop true)
	
	(if (= type "covenant")
		(set s_ai_test_fighter s_ai_test_fighter_cov))
		
	(if (= type "unsc")
		(set s_ai_test_fighter s_ai_test_fighter_unsc))
	
	(sleep_until
		(begin
			(if (= s_ai_test_fighter s_ai_test_fighter_cov)
				(begin
					(ai_place sq_test_seraph/turret_target_orbit)
					(sleep_until (<= (ai_living_count sq_test_seraph) 0) 1)
				)
			)
			
			(if (= s_ai_test_fighter s_ai_test_fighter_unsc)
				(begin
					(ai_place sq_test_sabre/turret_target_orbit)
					(sleep_until (<= (ai_living_count sq_test_sabre) 0) 1)
				)
			)
		(not b_ai_test_loop))
	1)
)

(script static void (ai_test_pursuit (string type))
	(if debug (print "ai: testing pursuit skills of fighters..."))
	(set b_ai_test_loop true)
	
	(sleep_until
		(begin
			(ai_erase_all)
			
			(if (= type "unsc")
				(begin
					(ai_place sq_test_seraph/turret_target_orbit)
					(ai_dogfight_sabre)
					(sleep_until (<= (ai_living_count sq_test_seraph) 0) 1)
				)
			)
		
			(if (= type "covenant")
				(begin
					(ai_place sq_test_sabre/turret_target_orbit)
					(ai_dogfight_seraph)
					(sleep_until (<= (ai_living_count sq_test_sabre) 0) 1)
				)
			)
			
		(not b_ai_test_loop))
	1)
)


; NAVIGATION PRACTICE
; -------------------------------------------------------------------------------------------------
(script static void (ai_test_navigation (string type))
	(set b_ai_test_loop true)
	
	(sleep_until
		(begin
			(if (= type "sabre")
				(begin
					(ai_place sq_test_sabre/navigation_test)
					(sleep_until (<= (ai_living_count sq_test_sabre) 0) 1)
				)
			)
			
			(if (= type "seraph")
				(begin
					(ai_place sq_test_seraph/navigation_test)
					(sleep_until (<= (ai_living_count sq_test_seraph) 0) 1)
				)
			)
		(not b_ai_test_loop))
	1)
)

(script command_script cs_ai_navigation_test
	(if debug (print "ai: flying at navigation destination on far side of corvette..."))
	(cs_fly_by ps_ai_test/navigation_dest)
	(ai_erase ai_current_squad)
)


; PHYSICAL EXPLOSIONS
; -------------------------------------------------------------------------------------------------
(script static void ai_test_phantom_explosion
	(physics_set_gravity 0)
	
	(sleep_until
		(begin
			(garbage_collect_now)
			;(object_create_folder_anew cr_waf_asteroids)
			(object_create_anew v_test_phantom_explode_00)
			(object_create_anew v_test_phantom_explode_01)
			(object_create_anew v_test_phantom_explode_02)
			(sleep 1)
			
			;(unit_kill (unit v_test_phantom_explode))
			(if debug (print "boom!"))
			(begin_random
			
				(begin
					(object_damage_damage_section v_test_phantom_explode_00 "death" 10000)
					(sleep 20)
				)
			
				(begin
					(object_damage_damage_section v_test_phantom_explode_01 "death" 10000)
					(sleep 20)
				)
				
				(begin
					(object_damage_damage_section v_test_phantom_explode_02 "death" 10000)
					(sleep 20)
				)
			)
			
			(sleep 600)
		0)
	1)

)

*;

; BEACH FIGHT
; -------------------------------------------------------------------------------------------------
(global boolean b_bch_infinite_kill false)

(script static void bch_start_infinite_encounter
	(wake bch_unsc_post_control)
	(wake bch_cov_post_beach_control)
	(wake bch_cov_post_dock_control)
	(wake bch_recycle_bipeds)
	
	
	(ai_fast_and_dumb 1)
	(ai_lod_full_detail_actors 16)
)

(script static void branch_abort_bch_infinite
	(if debug (print "-=-=-=-=- killing the infinite beach encounter -=-=-=-=-"))
	(ai_erase gr_cov_bch)
	(ai_erase gr_cov_bch_counter)
	(ai_erase gr_unsc_bch_post)
	(ai_erase sq_cov_bch_post_beach_fork0)
	(ai_erase sq_cov_bch_post_dock_fork0)
	(ai_erase sq_unsc_bch_reinforce_pelican0)
	
	(ai_fast_and_dumb 0)
	(ai_lod_full_detail_actors 20)
	
	(add_recycling_volume_by_type tv_bch_recycle 0 10 2)
)

(script dormant bch_unsc_post_control
	(branch
		(= b_bch_infinite_kill true) (branch_abort_bch_infinite)
	)
	
	(ai_place sq_unsc_bch_reinforce_pelican0)
	(sleep_until (<= (ai_living_count sq_unsc_bch_reinforce_pelican0) 0))
	
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gr_unsc_bch_post) 1))
			
			(if debug (print "migrating remaining unsc on the bch to holding squad"))
			(ai_migrate gr_unsc_bch_post sq_unsc_bch_reinforce_holding0)
		
			(sleep (random_range 150 300))
			(garbage_collect_now)
			
			(ai_place sq_unsc_bch_reinforce_pelican0)
			
			(sleep_until (= b_bch_post_pelican_enroute true))
			(sleep_until (= b_bch_post_pelican_enroute false))
			(garbage_collect_now)
		0)
	1)
	
)

(script dormant bch_cov_post_beach_control
	(branch
		(= b_bch_infinite_kill true) (branch_abort)
	)
	
	(ai_place sq_cov_bch_post_beach_fork0)
	(sleep_until (<= (ai_living_count sq_cov_bch_post_beach_fork0) 0))
	
	(sleep_until
		(begin
			(sleep_until (<= (ai_task_count obj_cov_bch_post/beach) 1))
			(ai_migrate gr_cov_bch_counter_beach sq_cov_bch_post_beach_holding0)
			
			(sleep (random_range 150 300))
			(garbage_collect_now)
			(ai_place sq_cov_bch_post_beach_fork0)
			
			(sleep_until (= b_bch_post_beach_fork_enroute true))
			(sleep_until (= b_bch_post_beach_fork_enroute false))
			(garbage_collect_now)
		0)
	1)
)

(script dormant bch_cov_post_dock_control
	(branch
		(= b_bch_infinite_kill true) (branch_abort)
	)
	
	(sleep_until (not (bch_wraith_is_alive)) 30 (* 30 180))
	(sleep_until
		(begin
			(if (bch_wraith_is_alive)
				(sleep_until (<= (ai_task_count obj_cov_bch_post/dock) 0))
				(sleep_until (<= (ai_task_count obj_cov_bch_post/dock) 1))
			)
		
			(ai_migrate gr_cov_bch_counter_dock sq_cov_bch_post_dock_holding0)
			
			(garbage_collect_now)
			(sleep (random_range 90 150))
			(ai_place sq_cov_bch_post_dock_fork0)
			
			(sleep_until (= b_bch_post_dock_fork_enroute true))
			(sleep_until (= b_bch_post_dock_fork_enroute false))
			(garbage_collect_now)
		0)
	1)
)


; -------------------------------------------------------------------------------------------------
(global ai ai_bch_post_beach_00 sq_cov_bch_post_beach_inf0)
(global ai ai_bch_post_beach_01 sq_cov_bch_post_beach_inf1)
(global ai ai_bch_post_beach_02 none)
(global ai ai_bch_post_beach_03 none)

(global ai ai_bch_post_beach_heavy sq_cov_bch_post_beach_heavy0)
(global boolean b_bch_post_beach_fork_enroute false)
(global short s_bch_post_heavy_chance 30)


; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_post_beach_fork
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(set s_bch_post_beach_wave (+ s_bch_post_beach_wave 1))
	(set b_bch_post_beach_fork_enroute true)
	
	(cs_ignore_obstacles 1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_post_forks/beach_entry1)
	
	(cs_vehicle_boost 0)
	(cs_vehicle_speed 0.7)
	(cs_fly_by ps_bch_post_forks/beach_entry0)
	
	(cs_vehicle_speed 0.5)
	(cs_fly_to ps_bch_post_forks/beach_hover)
	
	(sleep 45)
	(cs_vehicle_speed 0.3)
	
	(if (and (<= s_bch_post_beach_wave 1) (= b_mendicant_beach true)) ; if first wave and bob is spawning
		; first wave
		(begin
			(if debug (print "spawning beach light"))
			(f_load_fork (ai_vehicle_get ai_current_actor) "right" none ai_bch_post_beach_01 ai_bch_post_beach_02 none)
		)
		
		; not the first wave
		(begin
			(if (<= (random_range 0 100) s_bch_post_heavy_chance)
				(begin
					(if debug (print "spawning beach heavy"))
					(f_load_fork (ai_vehicle_get ai_current_actor) "right" ai_bch_post_beach_heavy ai_bch_post_beach_01 ai_bch_post_beach_02 none)
				)
				
				(begin
					(if debug (print "spawning beach light"))
					(f_load_fork (ai_vehicle_get ai_current_actor) "right" ai_bch_post_beach_00 ai_bch_post_beach_01 ai_bch_post_beach_02 none)
				)
			)
		)
	)
	
	
	
	(set ai_bch_post_beach_02 none) 
	
	(cs_fly_to_and_face ps_bch_post_forks/beach_land ps_bch_post_forks/beach_land_facing 0.25)
	(sleep 30)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "right")
	(set b_bch_post_beach_fork_enroute false)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_bch_post_forks/beach_hover ps_bch_post_forks/beach_land_facing 0.25)
	(sleep 1)
	
	(cS_vehicle_speed 0.8)
	(cs_fly_to ps_bch_post_forks/beach_exit0)
	(cs_vehicle_speed 1.0)
	
	(cs_fly_to ps_bch_post_forks/beach_exit1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 150)
	
	(cs_fly_to ps_bch_post_forks/beach_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
	
)


; -------------------------------------------------------------------------------------------------
(global ai ai_bch_post_dock_00 sq_cov_bch_post_dock_inf0)
(global ai ai_bch_post_dock_01 sq_cov_bch_post_dock_inf1)
(global ai ai_bch_post_dock_heavy sq_cov_bch_post_dock_heavy0)
(global boolean b_bch_post_dock_fork_enroute false)
(global short s_bch_post_dock_wave 0)
(global short s_bch_post_beach_wave 0)
(global short s_bch_post_pelican_wave 0)

(script static boolean bch_wraith_is_alive
	 (> (object_get_health o_bch_wraith) 0)
)

(script dormant bch_wraith_water_kill
	(branch
		(= b_bch_infinite_kill true) (branch_abort)
	)
	
	(sleep_until (volume_test_object tv_bch_wraith_water o_bch_wraith))
	
	(sleep (random_range 30 75))
	
	(damage_object o_bch_wraith "" 10000)
)
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_post_dock_fork
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
	
	(set s_bch_post_dock_wave (+ s_bch_post_dock_wave 1))
	(set b_bch_post_dock_fork_enroute true)
	
	(cs_ignore_obstacles 1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(cs_fly_by ps_bch_post_forks/dock_entry1)
	
	(cs_vehicle_boost 0)
	(cs_vehicle_speed 0.7)
	(cs_fly_by ps_bch_post_forks/dock_entry0)
	
	(cs_vehicle_speed 0.5)
	(cs_fly_to ps_bch_post_forks/dock_hover)
	
	(sleep 45)
	(cs_vehicle_speed 0.3)
	
	(if (bch_wraith_is_alive)
		(begin
			(if debug (print "dock fork -- wraith is alive"))
			(begin_random_count 1
				(f_load_fork (ai_vehicle_get ai_current_actor) "left" sq_cov_bch_post_dock_lite0 none none none)
				(f_load_fork (ai_vehicle_get ai_current_actor) "left" sq_cov_bch_post_dock_lite1 none none none))
		)
		
		(begin
			(if debug (print "dock fork -- wraith is dead"))
			(if (<= (random_range 0 100) s_bch_post_heavy_chance)
				(f_load_fork (ai_vehicle_get ai_current_actor) "left" ai_bch_post_dock_heavy ai_bch_post_dock_01 none none)
				(f_load_fork (ai_vehicle_get ai_current_actor) "left" ai_bch_post_dock_00 ai_bch_post_dock_01 none none)
			)
		)
	)
	
	(cs_fly_to_and_face ps_bch_post_forks/dock_land ps_bch_post_forks/dock_land_facing 0.25)
	(sleep 30)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "left")
	(set b_bch_post_dock_fork_enroute false)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_bch_post_forks/dock_hover ps_bch_post_forks/dock_land_facing 0.25)
	(sleep 1)
	
	(cS_vehicle_speed 0.8)
	(cs_fly_to ps_bch_post_forks/dock_exit0)
	(cs_vehicle_speed 1.0)
	
	(cs_fly_to ps_bch_post_forks/dock_exit1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 150)
	
	(cs_fly_to ps_bch_post_forks/dock_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
	
)

(global boolean b_bch_post_pelican_enroute false)
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_post_pelican
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 90)
	(vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) "" false false)
	(cs_ignore_obstacles 1)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost 1)
	
	(load_pelican (ai_vehicle_get ai_current_actor) "dual" sq_unsc_bch_reinforce0 sq_unsc_bch_reinforce1 sq_unsc_bch_reinforce2 sq_unsc_bch_reinforce3)
	(cs_fly_by ps_bch_post_forks/pelican_entry0)
	
	(cs_vehicle_speed 0.8)
	(cs_vehicle_boost 0)
	
	(cs_fly_to ps_bch_post_forks/pelican_hover)
	(sleep 30)
	(set b_bch_post_pelican_enroute true)
	
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face ps_bch_post_forks/pelican_land ps_bch_post_forks/pelican_land_facing 0.25)
	(unload_pelican_all (ai_vehicle_get ai_current_actor))
	(sleep 60)
	(set b_bch_post_pelican_enroute false)
	(cs_fly_to ps_bch_post_forks/pelican_hover)
	
	(cs_vehicle_speed 0.8)
	(cs_fly_to ps_bch_post_forks/pelican_exit0)
	(cs_fly_to ps_bch_post_forks/pelican_exit1)
	(cs_vehicle_speed 1.0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 270)
	(cs_fly_to ps_bch_post_forks/pelican_erase)
	
	
	(object_destroy (ai_vehicle_get ai_current_actor))
)

; =================================================================================================
; GLOBAL_PELICAN.HSC
; HOW TO USE:
; 	1. Open your scenario in Sapien
;	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
;	3. Point the dialogue to this file: main\data\globals\global_pelican.hsc
; =================================================================================================
(script static void	(load_pelican
								(vehicle pelican)		; phantom to load 
								(string load_side)		; how to load it 
								(ai load_squad_01)		; squads to load 
								(ai load_squad_02)
								(ai load_squad_03)
								(ai load_squad_04)
				)
	; place ai 
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	(ai_place load_squad_03)
	(ai_place load_squad_04)
	;(ai_place load_squad_03)
	;(ai_place load_squad_04)
	(sleep 1)
	
	
	(cond
		; left 
		((= load_side "left")
						(begin
							(if debug (print "load pelican left..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_lf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_ml_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_ml_b")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if debug (print "load pelican right..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_mr_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_mr_b")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if debug (print "load pelican dual..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							(ai_vehicle_enter_immediate load_squad_02 pelican "pelican_p_r")
							(ai_vehicle_enter_immediate load_squad_03 pelican "pelican_p_l")
							(ai_vehicle_enter_immediate load_squad_04 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_lb")
							;(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_rb")
						)
		)
	)			
				
)


(script static void (unload_pelican_all	(vehicle pelican))
	(unit_open pelican)
	(sleep 60)
	(begin
		(begin
			(vehicle_unload pelican "pelican_p_l05")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_r05")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_l04")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_r04")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_l03")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_r03")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_l02")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_r02")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_l01")
			(pelican_unload_seat_delay)
		)
		
		(begin
			(vehicle_unload pelican "pelican_p_r01")
			(pelican_unload_seat_delay)
		)
		
		
		
		
	)
)

(script static void pelican_unload_seat_delay
	(sleep (random_range 2 15)))


	
; SERAPHS
; -------------------------------------------------------------------------------------------------
(global short s_bch_bomber_scale_ticks 90)
; -------------------------------------------------------------------------------------------------
(script dormant bch_seraphs_start
	(bch_seraphs_loop)
)

(script static void bch_seraphs_loop
	(branch
		(or (= b_bch_infinite_kill true) (>= s_objcon_fac 110) (= b_lnc_started true)) (branch_abort_bch_seraphs)
	)
	
	(sleep_until
		(begin
			(cond
				((<= (ai_living_count sq_cov_bch_seraphs/pilot0) 0) (ai_place sq_cov_bch_seraphs/pilot0))
				((<= (ai_living_count sq_cov_bch_seraphs/pilot3) 0) (ai_place sq_cov_bch_seraphs/pilot3))
				((<= (ai_living_count sq_cov_bch_seraphs/pilot2) 0) (ai_place sq_cov_bch_seraphs/pilot2))
				((<= (ai_living_count sq_cov_bch_seraphs/pilot1) 0) (ai_place sq_cov_bch_seraphs/pilot1))
				
			)
			(sleep (random_range 10 60))
		0)
	1)
)



(script static void branch_abort_bch_seraphs
	(ai_erase sq_cov_bch_seraphs)
)

(script static void lnc_seraphs_loop
	(branch
		(= b_lnc_player_in_sabre true) (branch_abort_lnc_seraphs)
	)
	
	(sleep_until
		(begin
			(cond
				;((<= (ai_living_count sq_cov_bch_seraphs/pilot0) 0) (ai_place sq_cov_bch_seraphs/pilot0))
				((<= (ai_living_count sq_cov_bch_seraphs/pilot3) 0) (ai_place sq_cov_bch_seraphs/pilot3))
				((<= (ai_living_count sq_cov_bch_seraphs/pilot2) 0) (ai_place sq_cov_bch_seraphs/pilot2))
				;((<= (ai_living_count sq_cov_bch_seraphs/pilot1) 0) (ai_place sq_cov_bch_seraphs/pilot1))
				
			)
			(sleep (random_range 10 60))
		0)
	1)
)

(script static void branch_abort_lnc_seraphs
	(ai_erase sq_cov_bch_seraphs)
)

(script static void beach_seraph_setup
	;(object_set_function_variable (ai_vehicle_get ai_current_actor) engine_in_atmosphere 1 0)
	(ai_magically_see sq_unsc_bch_aa ai_current_actor)
	(ai_set_clump ai_current_actor CLUMP_GROUND_FLAVOR)
	(ai_set_targeting_group ai_current_actor s_bch_aa_targeting_group)
	(cs_ignore_obstacles ai_current_actor true)
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 s_bch_bomber_scale_ticks)
)
; -------------------------------------------------------------------------------------------------
(script command_script cs_bch_seraph0
	(beach_seraph_setup)
	(cs_vehicle_speed 1.0)
	(ai_set_blind ai_current_actor true)

	(cs_fly_by ps_bch_seraphs/seraph0_00)
	(ai_disregard (ai_actors ai_current_actor) true)
	(cs_fly_by ps_bch_seraphs/seraph0_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
	(cs_fly_by ps_bch_seraphs/seraph0_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_bch_seraph1
	(beach_seraph_setup)
	(cs_vehicle_speed 1.0)
	(ai_set_blind ai_current_actor true)

	(cs_fly_by ps_bch_seraphs/seraph1_00)
	(ai_disregard (ai_actors ai_current_actor) true)
	(cs_fly_by ps_bch_seraphs/seraph1_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 150)
	(cs_fly_by ps_bch_seraphs/seraph1_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_bch_seraph2
	(beach_seraph_setup)
	(cs_vehicle_speed 1.0)
	(ai_set_blind ai_current_actor true)

	(cs_fly_by ps_bch_seraphs/seraph2_00)
	(ai_disregard (ai_actors ai_current_actor) true)
	(cs_fly_by ps_bch_seraphs/seraph2_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 150)
	(cs_fly_by ps_bch_seraphs/seraph2_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_bch_seraph3
	(beach_seraph_setup)
	(cs_vehicle_speed 1.0)
	(ai_set_blind ai_current_actor true)

	(cs_fly_by ps_bch_seraphs/seraph3_00)
	(cs_shoot_point true ps_bch_seraphs/seraph3_target)
	(cs_fly_by ps_bch_seraphs/seraph3_01)
	(cs_shoot 0)
	(ai_disregard (ai_actors ai_current_actor) true)
	(cs_fly_by ps_bch_seraphs/seraph3_02)
	
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 150)
	(cs_fly_by ps_bch_seraphs/seraph3_erase)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

; AA
; -------------------------------------------------------------------------------------------------
(global short s_bch_aa_targeting_group 18)
; -------------------------------------------------------------------------------------------------
(script static void bch_setup_aa
	(object_create_folder sc_bch_turrets)
	(ai_place sq_unsc_bch_aa)
	(sleep 1)
	(ai_set_clump sq_unsc_bch_aa CLUMP_GROUND_AA)
	(ai_designer_clump_perception_range 600)
	(ai_set_targeting_group sq_unsc_bch_aa s_bch_aa_targeting_group)
)

(script static void lnc_setup_aa
	(object_create_folder sc_bch_turrets)
	(ai_place sq_unsc_bch_aa/turret0)
	(sleep 1)
	(ai_set_clump sq_unsc_bch_aa CLUMP_GROUND_AA)
	(ai_designer_clump_perception_range 600)
	(ai_set_targeting_group sq_unsc_bch_aa s_bch_aa_targeting_group)
)

(script dormant bch_recycle_bipeds
	(branch
		(= b_bch_infinite_kill true) (branch_abort)
	)
	
	(sleep_until
		(begin
			(if debug (print "beach recycling bipeds"))
			(add_recycling_volume_by_type tv_bch_recycle 2 10 1)
			(add_recycling_volume tv_bch_recycle 15 15)
			(sleep (* 30 15))
		0)
	1)
)


(script command_script cs_bch_wraith0_shoot_facility
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_bch_wraiths/wraith0_target0)
				(cs_shoot_point true ps_bch_wraiths/wraith0_target1)
				(cs_shoot_point true ps_bch_wraiths/wraith0_target2))
			(sleep 180)
			(cs_go_to ps_bch_wraiths/wraith0_firing_pos)
		0)
	1)
)

(script command_script cs_bch_wraith1_shoot_facility
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point true ps_bch_wraiths/wraith1_target0)
				(cs_shoot_point true ps_bch_wraiths/wraith1_target1)
				(cs_shoot_point true ps_bch_wraiths/wraith1_target2))
			(sleep 210)
			(cs_go_to ps_bch_wraiths/wraith1_firing_pos)
		0)
	1)
)

(script static void (drop_pod (device_name pod_marker) (ai pod_pilot))
	(print "pod drop started...")
	(object_create pod_marker)
	(ai_place pod_pilot)
	(sleep 1)
	(objects_attach pod_marker "" (ai_vehicle_get_from_spawn_point pod_pilot) "")
	(device_set_position_immediate pod_marker 0)
	(sleep 1)
	(device_set_power pod_marker 1)
	(device_set_position pod_marker 1)
	;(device_set_position_track pod_marker "pod_drop_100wu" 0)
	;(device_animate_position pod_marker 1.0 3.5 0.1 0 false)
	(sleep_until (>= (device_get_position pod_marker) 1) 1)
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_medium.effect (ai_vehicle_get_from_spawn_point pod_pilot) "fx_impact")
	(device_set_power pod_marker 0)
	
	
)



(script static void (open_pod (device_name pod_marker) (ai pod_pilot))
	(objects_detach pod_marker (ai_vehicle_get_from_spawn_point pod_pilot))
	(object_destroy pod_marker)
	(object_damage_damage_section  (ai_vehicle_get_from_spawn_point pod_pilot) "body" 100)
	(sleep 45)
	(vehicle_unload (ai_vehicle_get_from_spawn_point pod_pilot) "")
)


; MENDICANT
; -------------------------------------------------------------------------------------------------
(global boolean b_mendicant_beach false)
(script startup mendicant_control
	(if debug (print "mendicant: choose your destiny"))
	(begin_random_count 1
		(wake mendicant_beach_control)
		(wake mendicant_bridge_control)
		(wake mendicant_final_control)
	)
)

(script dormant mendicant_beach_control
	(branch 
		(= b_lnc_started true) (branch_abort)
	)
	(set b_mendicant_beach true)
	(if debug (print "mendicant bias beach"))
	(sleep (* 30 10))
	
	(sleep_until 
		(and
			(> s_bch_post_beach_wave 0)
			(> s_bch_post_dock_wave 0)
		)
	)
	
	(sleep_until
		(and
			(not b_bch_post_beach_fork_enroute)
			(not b_bch_post_dock_fork_enroute)
		)
	)
		
	(sleep (random_range (* 30 2) (* 30 4)))
	
	; randomly drop his pod
	(begin_random_count 1
		; drop mendicant pod 0
		; -------------------------------------------------
		(begin
			(if debug (print "dropping mendicant pod 0"))
			(drop_pod dm_mendicant_pod0 sq_cov_mendicant_beach/bias)
			(open_pod dm_mendicant_pod0 sq_cov_mendicant_beach/bias)
		)
		
		; drop mendicant pod 1
		; -------------------------------------------------
		(begin
			(if debug (print "dropping mendicant pod 1"))
			(drop_pod dm_mendicant_pod1 sq_cov_mendicant_beach/bias)
			(open_pod dm_mendicant_pod1 sq_cov_mendicant_beach/bias)
		)
		
		; drop mendicant pod 2
		; -------------------------------------------------
		(begin
			(if debug (print "dropping mendicant pod 2"))
			(drop_pod dm_mendicant_pod2 sq_cov_mendicant_beach/bias)
			(open_pod dm_mendicant_pod2 sq_cov_mendicant_beach/bias)
		)
	)	
)

(script command_script cs_mendicant_beach
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(ai_disregard ai_current_actor true)
	
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_bch_counter_beach) 4)
			(<= (unit_get_shield ai_current_actor) 0)
			(= b_bch_post_pelican_enroute true)
		)
	30 (* 30 35))
	
	(sleep (random_range 60 120))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
)

(global boolean b_mendicant_bridge_alert false)

(script dormant mendicant_bridge_control
	(if debug (print "mendicant bias bridge"))
	(branch 
		(= b_fin_started true) (branch_abort)
	)
	
	(sleep_until (>= s_objcon_brg 10) 1)
	(ai_place sq_cov_mendicant_bridge)
	(thespian_performance_activate thespian_brg_mendicant)
	
	(sleep_until b_mendicant_bridge_alert)
	(sleep 60)
	(cs_run_command_script sq_cov_mendicant_bridge cs_mendicant_bridge)
)

(script command_script cs_mendicant_bridge
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(ai_disregard ai_current_actor true)
	
	(sleep (random_range (* 30 30) (* 30 45)))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
	
)

(script dormant mendicant_final_control
	(if debug (print "mendicant bias final"))
	(sleep_until (= b_fin_started true) 1)
	(ai_place sq_cov_mendicant_final)
)

(script command_script cs_mendicant_final
	(cs_enable_moving 1)
	(cs_enable_targeting 1)
	(cs_shoot 1)
	(ai_disregard ai_current_actor true)
	
	(sleep (random_range (* 30 30) (* 30 35)))
	
	(if debug (print "camo now"))
	(ai_set_active_camo ai_current_actor true)
	(cs_enable_targeting 0)
	(cs_shoot 0)
    (sleep 30)
    (ai_erase ai_current_actor)
	
)