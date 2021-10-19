;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 18)

;=========================================================================================
;=================================== WORKERTOWN ==========================================
;=========================================================================================
; insertion point 0 
(script static void ins_workertown
	(if debug (print "insertion point : workertown"))

	; reset door variables 
	(gs_reset_door_variables)

	; disable combat dialogue 
	(ai_dialogue_enable FALSE)
	
		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_workertown)
			)
		)
	
	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) chief_initial TRUE TRUE)
	)
	(sleep 1)

	; teleporting players... to the proper location 
	(object_teleport (player0) player0_wt_start)
	(object_teleport (player1) player1_wt_start)
	(object_teleport (player2) player2_wt_start)
	(object_teleport (player3) player3_wt_start)
	(sleep 1)

		; set player pitch 
		(player0_set_pitch 3 0)
		(player1_set_pitch 3 0)
		(player2_set_pitch 3 0)
		(player3_set_pitch 3 0)
			(sleep 1)

	; cinematic snap to black 
	(cinematic_snap_to_black)
	
	; set insertion point index 
	(set g_insertion_index 1)
	
	; wake chapter title 
	(wake chapter_home)
)

;=========================================================================================
;=================================== WAREHOUSE ==========================================
;=========================================================================================
(script static void ins_warehouse
	(if debug (print "insertion point : warehouse"))
	(gs_reset_door_variables)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_warehouse)
			(sleep 1)
		)
	)
	
	; set insertion point index 
	(set g_insertion_index 2)

	; set mission progress accordingly 
	(set g_wt_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_wh_start)
	(object_teleport (player1) player1_wh_start)
	(object_teleport (player2) player2_wh_start)
	(object_teleport (player3) player3_wh_start)
	(sleep 1)
	(player_disable_movement FALSE)
	
	(if (not (game_is_cooperative)) (ai_place sq_wh_arbiter))
		(sleep 1)
	(ai_cannot_die gr_arbiter TRUE)

	; un-pause the campaign metagame timer 
	(campaign_metagame_time_pause FALSE)
)

;=========================================================================================
;=================================== LAKEBED B ===========================================
;=========================================================================================
; insertion point 1 
(script static void ins_lakebed_b
	(if debug (print "insertion point : lakebed b"))
	(gs_reset_door_variables)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_lakebed_b)
				(sleep 1)
			)
		)
	
	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) chief_initial TRUE TRUE)
	)
	(sleep 1)

		; set mission progress accordingly 
		(set g_wt_obj_control 100)
		(set g_wh_obj_control 100)
	
	; teleporting players... to the proper location 
	(object_teleport (player0) player0_lb_start)
	(object_teleport (player1) player1_lb_start)
	(object_teleport (player2) player2_lb_start)
	(object_teleport (player3) player3_lb_start)

	; place allies 
	(if (not (game_is_cooperative)) (ai_place sq_lb_arbiter))
	
	; set insertion point index 
		(sleep 30)
	(set g_insertion_index 3)
)

;=========================================================================================
(script static void ins_lakebed_b_test
	(if debug (print "insertion point : lakebed b"))
	(gs_reset_door_variables)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_lakebed_b)
				(sleep 1)
			)
		)
	
	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) chief_initial TRUE TRUE)
	)
	(sleep 1)

		; set mission progress accordingly 
		(set g_wt_obj_control 100)
		(set g_wh_obj_control 100)
	
	; teleporting players... to the proper location 
	(object_teleport (player0) test_ins_lakebed_b)

	; place allies 
	(if (not (game_is_cooperative)) (ai_place sq_lb_arbiter))
		(sleep 1)
	(ai_cannot_die gr_arbiter TRUE)	
	
	(wake obj_stop_spread_set)
	
	; set insertion point index 
		(sleep 30)
	(set g_insertion_index 3)
)


;=========================================================================================
;================================== FACTORY ARM B ========================================
;=========================================================================================
(script static void ins_factory_b
	(if debug (print "insertion point : factory arm b"))
	(gs_reset_door_variables)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_factory_arm_b)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 4)

	; set mission progress accordingly 
	(set g_wt_obj_control 100)
	(set g_wh_obj_control 100)
	(set g_lb_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_fb_start)
	(object_teleport (player1) player1_fb_start)
	(object_teleport (player2) player2_fb_start)
	(object_teleport (player3) player3_fb_start)
	(sleep 1)
	(player_disable_movement FALSE)

	(if (not (game_is_cooperative)) (ai_place sq_fb_arbiter))
	(ai_place sq_fb_elites)
		(sleep 1)
	(ai_cannot_die gr_arbiter TRUE)

	; un-pause the campaign metagame timer 
	(campaign_metagame_time_pause FALSE)
)

;=========================================================================================
;=================================== LAKEBED A ===========================================
;=========================================================================================
(script static void ins_lakebed_a
	(if debug (print "insertion point : lakebed a"))
	(gs_reset_door_variables)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_lakebed_a)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 5)

	; set mission progress accordingly 
	(set g_wt_obj_control 100)
	(set g_wh_obj_control 100)
	(set g_lb_obj_control 100)
	(set g_fb_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_la_start)
	(object_teleport (player1) player1_la_start)
	(object_teleport (player2) player2_la_start)
	(object_teleport (player3) player3_la_start)
	(sleep 1)
	(player_disable_movement FALSE)

	(if (not (game_is_cooperative)) (ai_place sq_la_arbiter))
		(sleep 1)
	(ai_cannot_die gr_arbiter TRUE)

	; un-pause the campaign metagame timer 
	(campaign_metagame_time_pause FALSE)
)

;=========================================================================================
;=================================== FLOODSHIP ===========================================
;=========================================================================================
(script static void ins_floodship
	(if debug (print "insertion point : floodship"))
	(gs_reset_door_variables)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_flood_ship)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 6)

	; set mission progress accordingly 
	(set g_wt_obj_control 100)
	(set g_wh_obj_control 100)
	(set g_lb_obj_control 100)
	(set g_fb_obj_control 100)
	(set g_la_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_fs_start)
	(object_teleport (player1) player1_fs_start)
	(object_teleport (player2) player2_fs_start)
	(object_teleport (player3) player3_fs_start)
	(sleep 1)
	(player_disable_movement FALSE)

	; un-pause the campaign metagame timer 
	(campaign_metagame_time_pause FALSE)
)
