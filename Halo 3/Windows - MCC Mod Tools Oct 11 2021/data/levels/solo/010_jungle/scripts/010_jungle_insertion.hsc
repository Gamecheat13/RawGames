;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 24)

;=========================================================================================
;================================== CHIEF CRATER =========================================
;=========================================================================================
(script static void ins_chief_crater
	(if debug (print "insertion point : chief_crater_new"))
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_chief_crater)
		)
	)
	(sleep 1)

	; give the chief the proper stating weapons if game is coop 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) chief_initial TRUE TRUE)
	)
		(sleep 1)
	(unit_raise_weapon (player0) -1)
		(sleep 1)
	(unit_lower_weapon (player0) 1)
		(sleep 1)

		; teleport players to the proper locations 
		(object_teleport (player0) player0_cc_start)
		(object_teleport (player1) player1_cc_start)
		(object_teleport (player2) player2_cc_start)
		(object_teleport (player3) player3_cc_start)
		(sleep 1)

			; set player pitch 
			(player0_set_pitch g_player_start_pitch 0)
			(player1_set_pitch g_player_start_pitch 0)
			(player2_set_pitch g_player_start_pitch 0)
			(player3_set_pitch g_player_start_pitch 0)
				(sleep 1)

			
	; the ai can no longer drop grenades
	; this gets turned back on halfway through the substation encounter
	(if (<= (game_difficulty_get) normal) (ai_grenades FALSE))

	; set insertion point index 
	(set g_insertion_index 1)

	; enable HUD training 
	(hud_enable_training TRUE)
	
	; snap to black 
	(cinematic_snap_to_black)
)

;=========================================================================================
;================================== JUNGLE WALK ==========================================
;=========================================================================================
(script static void ins_jungle_walk
	(if debug (print "insertion point : jungle walk"))
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jungle_walk)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 2)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
	
	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_jw_start)
	(object_teleport (player1) player1_jw_start)
	(object_teleport (player2) player2_jw_start)
	(object_teleport (player3) player3_jw_start)
		(sleep 1)
	(player_disable_movement FALSE)

	; placing allies... 
	(if debug (print "placing allies..."))
	(ai_place sq_jw_johnson_marines)
	(ai_place sq_jw_marines)
	(if (not (game_is_cooperative)) (ai_place sq_jw_arbiter))
		(sleep 1)

	; un-pause metagame timer   
	(campaign_metagame_time_pause FALSE)

)

;=========================================================================================
;=================================== GRUNT CAMP ==========================================
;=========================================================================================
(script static void ins_grunt_camp
	(if debug (print "insertion point : grunt camp"))
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_grunt_camp)
			(sleep 1)
		)
	)
	
	(insertion_start)

	; set insertion point index 
	(set g_insertion_index 3)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_gc_start)
	(object_teleport (player1) player1_gc_start)
	(object_teleport (player2) player2_gc_start)
	(object_teleport (player3) player3_gc_start)
		(sleep 1)
	(player_disable_movement FALSE)
	
	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_gc_arbiter))
	(ai_place sq_gc_marines)
		(sleep 1)

	; un-pause metagame timer   
	(campaign_metagame_time_pause FALSE)
	
	(wake insertion_end)
)

;=========================================================================================
;===================================== PATH A ============================================
;=========================================================================================
(script static void ins_path_a
	(if debug (print "insertion point : path a"))

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_path_a)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 4)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)
		(set g_gc_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_pa_start)
	(object_teleport (player1) player1_pa_start)
	(object_teleport (player2) player2_pa_start)
	(object_teleport (player3) player3_pa_start)
		(sleep 1)
	(player_disable_movement FALSE)

	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_pa_arbiter))
	(ai_place sq_pa_marines)
		(sleep 1)

	; un-pause metagame timer   
	(campaign_metagame_time_pause FALSE)
)

;=========================================================================================
;=================================== SUB-STATION =========================================
;=========================================================================================
(global boolean g_ss_insertion_start FALSE)

(script static void ins_substation
	(if debug (print "insertion point : substation"))
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_substation)
			(sleep 1)
		)
	)
	(set g_ss_insertion_start TRUE)

	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) chief_initial TRUE TRUE)
	)
	(sleep 1)

	(insertion_start)
	
			; wake music scripts 
			(wake music_010_05)
			(wake music_010_06)
			
			; start music 05 and 06 
			(set g_music_010_05 TRUE)
			(set g_music_010_06 TRUE)
			
			; set music 06 alternate 
			(set g_music_010_06_alt TRUE)

	(object_create_anew_containing rock_ss_0)

	; set insertion point index 
	(set g_insertion_index 5)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)
		(set g_gc_obj_control 100)
		(set g_pa_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_ss_start)
	(object_teleport (player1) player1_ss_start)
	(object_teleport (player2) player2_ss_start)
	(object_teleport (player3) player3_ss_start)
		(sleep 1)	

	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_ss_arbiter))
		(sleep 1)

	; set the proper mission objective 
	(objectives_show_up_to 0)
	
		; set player pitch 
		(player0_set_pitch -5 0)
		(player1_set_pitch -5 0)
		(player2_set_pitch -5 0)
		(player3_set_pitch -5 0)

	; wake script to set allies free 
	(wake ai_ss_wake_allies)
		(sleep 15)
	(fade_in 0 0 0 15)
)

(script dormant ai_ss_wake_allies
	; set the arbiter free 
	(sleep_until (>= g_ss_obj_control 1) 30 300)
	(ai_activity_abort sq_ss_arbiter)
	(ai_activity_abort sq_ss_marines)
)

;=========================================================================================
;===================================== PATH B ============================================
;=========================================================================================
(script static void ins_path_b
	(if debug (print "insertion point : path b"))

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_path_b)
			(sleep 1)
		)
	)

	; set insertion point index 
	(set g_insertion_index 6)
	
	; ai can use grenades 
	(ai_grenades TRUE)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)
		(set g_gc_obj_control 100)
		(set g_pa_obj_control 100)
		(set g_ss_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_pb_start)
	(object_teleport (player1) player1_pb_start)
	(object_teleport (player2) player2_pb_start)
	(object_teleport (player3) player3_pb_start)
		(sleep 1)
	(player_disable_movement FALSE)
	
	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_pb_arbiter))
	(ai_place sq_pb_marines)
		(sleep 1)

		; place first path b jackal
		(if (>= (game_difficulty_get) heroic) (ai_place sq_pb_jackal_01))

	; un-pause metagame timer   
	(campaign_metagame_time_pause FALSE)
)

;=========================================================================================
;================================== BRUTE AMBUSH =========================================
;=========================================================================================
(global real g_ba_starting_pitch 10)

(script static void ins_brute_ambush
	(if debug (print "insertion point : brute ambush"))

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_path_c)
			(sleep 1)
		)
	)
	
	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) insertion_chief TRUE TRUE)
	)
	(sleep 1)

	(insertion_start)
	
		; wake music scripts 
		(wake music_010_07)
		(wake music_010_075)
		
		; start music 05 and 06 
		(set g_music_010_07 TRUE)
		(set g_music_010_075 TRUE)

	; set insertion point index 
	(set g_insertion_index 7)

	; ai can use grenades 
	(ai_grenades TRUE)

		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)
		(set g_gc_obj_control 100)
		(set g_pa_obj_control 100)
		(set g_ss_obj_control 100)
		(set g_pb_obj_control 100)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_ba_start)
	(object_teleport (player1) player1_ba_start)
	(object_teleport (player2) player2_ba_start)
	(object_teleport (player3) player3_ba_start)
		(sleep 1)
	(player_disable_movement FALSE)
	
		; set initial pitch 
		(player0_set_pitch g_ba_starting_pitch 0)
		(player1_set_pitch g_ba_starting_pitch 0)
		(player2_set_pitch g_ba_starting_pitch 0)
		(player3_set_pitch g_ba_starting_pitch 0)


	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_ba_arbiter))
		(sleep 15)

	; set the proper mission objective 
	(objectives_show_up_to 1)
	(objectives_finish_up_to 0)
	
	(wake insertion_end)
)

;=========================================================================================
;====================================== DAM ==============================================
;=========================================================================================
(script static void ins_dam
	(if debug (print "insertion point : dam"))

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_dam)
			(sleep 1)
		)
	)

	; set starting profile 
	(if (= (game_is_cooperative) TRUE)
		(unit_add_equipment (player0) chief_coop_initial TRUE TRUE)
		(unit_add_equipment (player0) insertion_chief TRUE TRUE)
	)
	(sleep 1)

	(insertion_start)

	; set insertion point index 
	(set g_insertion_index 8)

	; ai can use grenades 
	(ai_grenades TRUE)
	
		; set mission progress accordingly 
		(set g_cc_obj_control 100)
		(set g_jw_obj_control 100)
		(set g_ta_obj_control 100)
		(set g_gc_obj_control 100)
		(set g_pa_obj_control 100)
		(set g_ss_obj_control 100)
		(set g_pb_obj_control 100)
		(set g_ba_obj_control 100)
		(set g_tb_obj_control 3)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) player0_dam_start)
	(object_teleport (player1) player1_dam_start)
	(object_teleport (player1) player2_dam_start)
	(object_teleport (player1) player3_dam_start)
		(sleep 1)
	(player_disable_movement FALSE)
	(player0_set_pitch g_player_start_pitch 0)

	; placing allies... 
	(if debug (print "placing allies..."))
	(if (not (game_is_cooperative)) (ai_place sq_dam_arbiter))
	(ai_place sq_dam_marines)
		(sleep 1)

	; set the proper mission objective 
	(objectives_show_up_to 2)
	(objectives_finish_up_to 1)

	(wake insertion_end)
)

;*
=========================================================================================
================================== COMMENTS AND JUNK ====================================
=========================================================================================


Objects per frame		characters	vehicles	weapons	scenery	crates/garbage/items 
						28			12		30		50		60 



*;

