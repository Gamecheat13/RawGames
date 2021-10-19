(global short g_set_all 14)

;=========================================================================================
;================ INS_INTRO_HALLS ========================================================
;=========================================================================================

(script static void ins_intro_halls
	(if debug (print "insertion point : intro_halls"))

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_intro_halls)
				(sleep 1)
			)
		)
	
	; snap to black 
	(cinematic_snap_to_black)
		(sleep 5)
	
	; set current mission segment 
	(data_mine_set_mission_segment "110la_hc_arrival")

		; play opening cinematic 
		(if g_play_cinematics
			(begin
				; play cinematic 
				(if (cinematic_skip_start)
					(begin
						(if debug (print "110la_hc_arrival"))
						(110la_hc_arrival)
					)
				)
				(cinematic_skip_stop)
				
				; cleanup cinematics 
				(110la_hc_arrival_cleanup)
			)
		)
	; fade_out
	(fade_out 0 0 0 0)
		(sleep 1)

	; cinematic commands 
	(cinematic_stop)
	(camera_control OFF)
		(sleep 1)

	; clear all objectives 
	(objectives_clear)
	
	; teleport players to the proper locations 
	(object_teleport (player0) start_player0)
	(object_teleport (player1) start_player1)
	(object_teleport (player2) start_player2)
	(object_teleport (player3) start_player3)

		; set player pitch 
		(player0_set_pitch -16 0)
		(player1_set_pitch -16 0)
		(player2_set_pitch -16 0)
		(player3_set_pitch -16 0)

	; set insertion point index 
	(set g_insertion_index 1)

	; fade in to title 
	(cinematic_fade_to_title)

	; wake chapter title 
	(wake 110_title1)

	; wake objective script 
	(wake objective_1_set)

)

;=========================================================================================
;================ INS_REACTOR_RETURN =====================================================
;=========================================================================================
(global short ins_random_number 0)

(script static void ins_reactor_return
	(if debug (print "insertion point : reactor_return"))

	; snap to black 
	(cinematic_snap_to_black)
		(sleep 5)

	; return run zone sets 
	(gs_return_zone_sets)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_reactor)
			(sleep 1)
		)
	)
	
	; wake cinematic 
	(wake 110_highcharity_cortana)
	
	; sleep until cinematic is over 
	(sleep_until g_cortana_rescued)
	
	; set insertion point index 
	(set g_insertion_index 10)
)
;=========================================================================================
;================================ TELEPORT SCRIPTS  ======================================
;=========================================================================================

(script static void ins_pelican_hill
	(ai_erase_all)

	(sleep 1)
	(set g_insertion_index 2)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_pelican_hill)
				(sleep 1)
			)
		)

	(sleep 1)
	(object_teleport (player0) pel_hill_p0)
	(object_teleport (player1) pel_hill_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_halls_a_b
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 3)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_bridge)
				(sleep 1)
			)
		)

	(sleep 1)
	(object_teleport (player0) hallway_2_p0)
	(object_teleport (player1) hallway_2_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_bridge
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 4)
	(switch_zone_set set_bridge)
	(sleep 1)
	(object_teleport (player0) bridge_p0)
	(object_teleport (player1) bridge_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_hall_c
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 5)
	(switch_zone_set set_prisoner)
	(sleep 1)
	(object_teleport (player0) hallway_4_p0)
	(object_teleport (player1) hallway_4_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_prisoner
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 6)
	(switch_zone_set set_reactor)
	(sleep 1)
	(object_teleport (player0) prisoner_p0)
	(object_teleport (player1) prisoner_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_hall5
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 7)
	(switch_zone_set set_reactor)
	(sleep 1)
	(object_teleport (player0) hallway_5_p0)
	(object_teleport (player1) hallway_5_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_reactor
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 8)
	(switch_zone_set set_reactor)
	(sleep 1)
	(object_teleport (player0) reactor_p0)
	(object_teleport (player1) reactor_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_inner_sanctum
	(ai_erase_all)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_reactor)
				(sleep 1)
			)
		)
	
	; teleport players 
	(object_teleport (player0) sanctum_p0)
	(object_teleport (player1) sanctum_p1)

		; set player pitch 
		(player0_set_pitch -10 0)
		(player1_set_pitch -10 0)
		(player2_set_pitch -10 0)
		(player3_set_pitch -10 0)

	; set insertion index 
	(set g_insertion_index 9)
	
	; garbage collect unsafe 
	(garbage_collect_unsafe)
)

;=========================================================================================
(script static void ins_hall6_rev
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 10)
	(set g_cortana_rescued TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_reactor)
	(sleep 1)
	(object_teleport (player0) hallway_6_rev_p0)
	(object_teleport (player1) hallway_6_rev_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_reactor_rev
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 11)
	(set g_cortana_rescued TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_reactor)
	(sleep 1)
	(object_teleport (player0) reactor_rev_p0)
	(object_teleport (player1) reactor_rev_p1)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_hall4_rev
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 14)
	(set g_cortana_rescued TRUE)
	(set reactor_blown TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_prisoner)
	(sleep 1)
	(object_teleport (player0) hallway_4_rev_p0)
	(object_teleport (player1) hallway_4_rev_p1)
	(set reactor_blown TRUE)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_bridge_rev
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 12)
	(set g_cortana_rescued TRUE)
	(set reactor_blown TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_bridge_return)
	(sleep 1)
	(object_teleport (player0) bridge_rev_p0)
	(object_teleport (player1) bridge_rev_p1)
	(set reactor_blown TRUE)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_hall3_rev
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 16)
	(set g_cortana_rescued TRUE)
	(set reactor_blown TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_bridge_return)
	(sleep 1)
	(object_teleport (player0) hallway_3_rev_p0)
	(object_teleport (player1) hallway_3_rev_p1)
	(set reactor_blown TRUE)

	(garbage_collect_now)
	(game_save)
)

;=========================================================================================
(script static void ins_pelican_hill_return
	(ai_erase_all)

;	(unit_add_equipment (player0) profile_1 TRUE TRUE)
;	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 1)
	(set g_insertion_index 17)
	(set g_cortana_rescued TRUE)
	(set reactor_blown TRUE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable zone_set:set_bridge FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_bridge_return TRUE)
	(zone_set_trigger_volume_enable zone_set:set_bridge_return TRUE)
	(switch_zone_set set_bridge_return)
	(sleep 1)
	(object_teleport (player0) pel_hill_rev_p0)
	(object_teleport (player1) pel_hill_rev_p1)
	(set reactor_blown TRUE)

	(garbage_collect_now)
	(game_save)
)