; -------------------------------------------------------------------------------------------------

(global short s_current_insertion_index 		-1)
(global short s_insertion_index_start			0)
(global short s_insertion_index_firstkiva 		1)
(global short s_insertion_index_silo 			2)
(global short s_insertion_index_fields 			3)
(global short s_insertion_index_pumpstation 	4)
(global short s_insertion_index_river 			5)
(global short s_insertion_index_settlement 		6)
(global short s_insertion_index_cliffside 		7)

(global short s_zone_index_firstkiva 	0)
(global short s_zone_index_fields 		1)
(global short s_zone_index_canyon 		2)
(global short s_zone_index_pumpstation 	3)
(global short s_zone_index_river 		4)
(global short s_zone_index_settlement 	5)
(global short s_zone_index_cliffside 	6)

(global short s_bsp_index_010 2)
(global short s_bsp_index_020 3)
(global short s_bsp_index_025 8)
(global short s_bsp_index_028 9)
(global short s_bsp_index_030 4)
(global short s_bsp_index_035 10)
(global short s_bsp_index_040 5)
(global short s_bsp_index_045 6)

; -------------------------------------------------------------------------------------------------
(script static void ins_start
	(if debug (print "insertion point: start"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_insertion_010_020)
	(tick)	
	
	; teleport
	(object_teleport player0 insertion_spawn_player0)
	(object_teleport player1 insertion_spawn_player1)
	(object_teleport player2 insertion_spawn_player2)
	(object_teleport player3 insertion_spawn_player3)
	
	(set s_current_insertion_index s_insertion_index_start)
)

; -------------------------------------------------------------------------------------------------
(script static void ins_firstkiva
	(if debug (print "insertion point: firstkiva"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_insertion_010_020)
	(sleep 1)
	
	; kill previous encounters
	(ovr_cleanup)

	; teleport
	(object_teleport player0 fl_fkv_player0)
	(object_teleport player1 fl_fkv_player1)
	(object_teleport player2 fl_fkv_player2)
	(object_teleport player3 fl_fkv_player3)	
	
	(music_kill_all)
	(ai_place unsc_jun/fkv)
	(sleep 1)
	(set s_current_insertion_index s_insertion_index_firstkiva)
	
	(sleep 1)
	
	;(ai_place sq_cov_fkv_ds0)
)

; -------------------------------------------------------------------------------------------------
(script static void ins_silo
	(if debug (print "insertion point: silo"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_fields_010_020_025)
	(tick)
	
	; kill previous encounters
	(ovr_cleanup)
	;(fkv_cleanup)
	
	; teleport
	(object_teleport player0 silo_spawn_player0)
	(object_teleport player1 silo_spawn_player1)
	(object_teleport player2 silo_spawn_player2)
	(object_teleport player3 silo_spawn_player3)	
	
	(music_kill_all)
	(set s_current_insertion_index s_insertion_index_silo)
)

; -------------------------------------------------------------------------------------------------
(script static void ins_fields
	(insertion_snap_to_black)
	(if debug (print "insertion point: fields"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_canyon_020_025_028)
	(tick)
	
	; kill previous encounters
	;(ovr_cleanup)
	;(fkv_cleanup)
	;(silo_cleanup)

	; teleport
	(object_teleport player0 fields_spawn_player0)
	(object_teleport player1 fields_spawn_player1)
	(object_teleport player2 fields_spawn_player2)
	(object_teleport player3 fields_spawn_player3)	
	
	(music_kill_all)
	(set s_current_insertion_index s_insertion_index_fields)
	
	(sleep 5)
	(wake show_objective_3_insertion)
	(ai_place unsc_jun/fld)
	(sleep 1)
	(set ai_jun unsc_jun)
	
	(insertion_fade_to_gameplay)
)

; -------------------------------------------------------------------------------------------------
(script static void ins_pumpstation
	(if debug (print "insertion point: pumpstation"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_pumpstation_025_028_030)
	(tick)
		
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	
	; teleport
	(object_teleport player0 pumpstation_spawn_player0)
	(object_teleport player1 pumpstation_spawn_player1)
	(object_teleport player2 pumpstation_spawn_player2)
	(object_teleport player3 pumpstation_spawn_player3)	
	
	(music_kill_all)
	(set s_current_insertion_index s_insertion_index_pumpstation)
	
	(ai_erase unsc_jun)
	(ai_place unsc_jun/pumpstation)
	
	(sleep 1)
	
	(set ai_jun unsc_jun)
)

(script static void ins_pumpstation_postcombat
	(if debug (print "insertion point: pumpstation"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_river_028_030_035)
	(tick)
		
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	
	; teleport
	(object_teleport player0 fl_pmp_postcombat_player0)
	
	(music_kill_all)
	;(set s_current_insertion_index s_insertion_index_pumpstation)
	
	(object_create_folder dm_pmp)
	(object_create_folder cr_pmp)
	(object_create_folder sc_pmp)
	
	(ai_place sq_unsc_pmp_militia0)
	(ai_place sq_unsc_pmp_militia1)
	(sleep 1)
	(ai_set_objective gr_militia obj_unsc_pmp)
	(ai_place unsc_jun/pumpstation_postcombat)
	(set ai_jun unsc_jun)
	(ai_set_objective unsc_jun obj_unsc_pmp)
	
	(set b_pmp_assault_complete true)
	(pmp_postcombat_control)	
)

(script static void ins_pumpstation_postcombat_nomilitia
	(if debug (print "insertion point: pumpstation"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_river_028_030_035)
	(tick)
		
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	
	; teleport
	(object_teleport player0 fl_pmp_postcombat_player0)
	
	(music_kill_all)
	;(set s_current_insertion_index s_insertion_index_pumpstation)
	
	(object_create_folder dm_pmp)
	(object_create_folder cr_pmp)
	(object_create_folder sc_pmp)
	
	(ai_place unsc_jun/pumpstation_postcombat)
	(set ai_jun unsc_jun)
	(ai_set_objective unsc_jun obj_unsc_pmp)
	
	(set b_pmp_assault_complete true)
	(pmp_postcombat_control)	
)

; -------------------------------------------------------------------------------------------------
(script static void ins_river
	(if debug (print "insertion point: river"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_river_028_030_035)
	(tick)
	
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	(pmp_cleanup)
		
	; teleport
	(object_teleport player0 river_spawn_player0)
	(object_teleport player1 river_spawn_player1)
	(object_teleport player2 river_spawn_player2)
	(object_teleport player3 river_spawn_player3)	
	
	(music_kill_all)
	
	
	;(fireteam_setup)
	
	;jun
	(ai_erase unsc_jun)
	(ai_place unsc_jun/river)
	(sleep 1)
	(set ai_jun unsc_jun)
	
	; militia
	(ai_erase unsc_militia)
	(ai_place unsc_militia/river)
	
	(set b_pmp_assault_complete true)
	(set s_current_insertion_index s_insertion_index_river)
	
)

; -------------------------------------------------------------------------------------------------
(script static void ins_settlement
	(if debug (print "insertion point: settlement"))
	
	(insertion_snap_to_black)
	
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_settlement_035_040)
	(sleep_until (= (current_zone_set_fully_active) s_zone_index_settlement) 1)
	(tick)
	
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	(pmp_cleanup)
	(rvr_cleanup)
	
	; teleport
	(object_teleport player0 settlement_spawn_player0)
	(object_teleport player1 settlement_spawn_player1)
	(object_teleport player2 settlement_spawn_player2)
	(object_teleport player3 settlement_spawn_player3)
	
	(music_kill_all)
	(set s_current_insertion_index s_insertion_index_settlement)
	
	;(fireteam_setup)
	
	;jun
	(ai_erase unsc_jun)
	(sleep 1)
	(ai_place unsc_jun/set)
	
	; militia
	(ai_erase unsc_militia)
	(ai_erase fireteam_player0)
	(sleep 1)
	;(ai_place unsc_militia/settlement)
	
	(sleep 30)
	(mus_start mus_08)
	(wake show_objective_5_insertion)
	(insertion_fade_to_gameplay)
	
)

; -------------------------------------------------------------------------------------------------
(script static void ins_cliffside
	(if debug (print "insertion point: cliffside"))
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_cliffside_035_040_045)
	(tick)
	
	; kill previous encounters
	(ovr_cleanup)
	(fkv_cleanup)
	(silo_cleanup)
	(fld_cleanup)
	(pmp_cleanup)
	(rvr_cleanup)
	(set_cleanup)
	
	; teleport
	(object_teleport player0 cliffside_spawn_player0)
	(object_teleport player1 cliffside_spawn_player1)
	(object_teleport player2 cliffside_spawn_player2)
	(object_teleport player3 cliffside_spawn_player3)	

	;(unit_add_equipment player0 profile_cliffside_test TRUE TRUE)
	
	(music_kill_all)
	(set s_current_insertion_index s_insertion_index_cliffside)
	
	;(fireteam_setup)
	
	;jun
	(ai_erase unsc_jun)
	(ai_place unsc_jun/cliffside)
	(sleep 1)
	(set ai_jun unsc_jun)
	
	; militia
	(ai_erase unsc_militia)
	(ai_place unsc_militia/cliffside 2)
)


; =================================================================================================
; TEST SCRIPTS
; =================================================================================================
(script static void test_fkv
	(ai_erase_all)
	(garbage_collect_unsafe)
	(sleep 1)
	
	;(ai_place sq_cov_fkv_grunts_needlers)
	(ai_place sq_cov_fkv_grunts_pistols)
	(ai_place sq_cov_fkv_jackals0)
	(ai_place sq_cov_fkv_jackals1)
	(ai_place sq_cov_fkv_elites0)
	(ai_place sq_cov_fkv_roof_shade0)
	
	(ai_place sq_cov_fkv_ds0)
	
	;(ai_place sq_cov_fkv_garage_inf0)
)

(script static void test_fkv_reinforce
	(ai_place sq_cov_fkv_reinforce_elites0)
	(ai_place sq_cov_fkv_reinforce_skirm0)
)

(script static void test_bunkering

	(sleep_until
		(begin
			(ai_erase_all)
			(garbage_collect_unsafe)
			
			(ai_reset_objective obj_cov_pmp)
			(ai_reset_objective obj_unsc_pmp)
			
			(object_create_folder_anew sc_pmp)
			(object_create_folder_anew cr_pmp)
			
			(sleep 1)
			(set b_pmp_assault_started true)
			
			(wake pmp_militia_renew)
			
			(ai_place sq_unsc_pmp_militia0)
			(ai_place sq_unsc_pmp_militia1)
			(ai_place sq_unsc_pmp_militia2)		
			
			(sleep 120)
			
			(ai_place sq_cov_pmp_road_elites0)
			(ai_place sq_cov_pmp_road_grunts0)
			(ai_place sq_cov_pmp_road_grunts1)
			
			(sleep 1)
			
			(sleep_until
				(or
					(<= (ai_living_count gr_militia) 0)
					(<= (ai_living_count gr_cov) 0)))
		0)
	1)

)