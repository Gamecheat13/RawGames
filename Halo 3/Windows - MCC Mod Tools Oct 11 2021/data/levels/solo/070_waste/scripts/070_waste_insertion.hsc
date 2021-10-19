;=========================================================================================
;==================================== GLOBALS  ===========================================
;=========================================================================================

(script static void 070_insertion_intro
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(unit_exit_vehicle (player2))
	(unit_exit_vehicle (player3))
	
	(ai_erase gr_npc)
)

; =======================================================================================================================================================================
(script static void 070_intro_cinematic
	; snap to black 
	(cinematic_snap_to_black)
	(sleep 1)
	
	(if b_cinematic 
		(begin
			(if b_debug (print "070la_waypoint_arrival"))			
			(if (cinematic_skip_start)
				(begin
					(data_mine_set_mission_segment "070_LA_waypoint_arrival")															
					(070la_waypoint_arrival)
				)
			)
			(cinematic_skip_stop)
			(070la_waypoint_arrival_cleanup)
		)
	)
)

;=========================================================================================
;================================== LANDING ZONE =========================================
;=========================================================================================
(script static void ins_landing_zone	
	(070_intro_cinematic)
	
	; player in pelican 
	(fade_out 0 0 0 0)
	(cinematic_stop)
	(camera_control off)
	
	(if b_debug (print "insertion point : landing zone"))	
		
	; set insertion point index 
	(set g_insertion_index 1)
	
	;Avoid the random AI comment at the beginning of the mission
	(ai_dialogue_enable false)
	
	;Background & ambiant action
	(wake background_bowls)
	
	;Place allies
	(ai_place allies_lz_pelican_0)
	(ai_place allies_lz_marines_0)
	(ai_place allies_lz_johnson)
	(ai_place allies_lz_pelican_1)
	(ai_place allies_b1_intro_marine)
	(ai_place allies_lz_marine_1)
	
	(object_cannot_die (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) true)
	(ai_cannot_die allies_lz_pelican_0/pilot true)
	(object_cannot_take_damage (ai_vehicle_get allies_lz_pelican_0/pilot))
	(ai_cannot_die ai_fly_johnson true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) true)
	
	(object_cannot_die (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot) true)
	(object_cannot_take_damage (ai_vehicle_get allies_lz_pelican_1/pilot))
	(ai_cannot_die allies_lz_pelican_1/pilot true)
	
	;Get everybody inside the pelicans!
	;HACK: convert the AI before assigning it to the variable, 
	;because we need to store a pointer to the actual AI,  
	;not to the starting location
	(set ai_fly_johnson (object_get_ai (ai_get_object allies_lz_johnson/johnson)))
	(set ai_fly_pelican_marines_0 (object_get_ai (ai_get_object allies_lz_marines_0/0)))
	(set ai_fly_pelican_marines_1 (object_get_ai (ai_get_object allies_lz_marines_0/1)))
	(set ai_fly_pelican_marines_2 (object_get_ai (ai_get_object allies_lz_marines_0/2)))
	(set ai_fly_pelican_commander (object_get_ai (ai_get_object allies_b1_intro_marine/sniper)))
		
	;Get AIs in pelican 0
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_g" (ai_actors ai_fly_johnson))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_l03" (ai_actors ai_fly_pelican_marines_0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_l04" (ai_actors ai_fly_pelican_marines_1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_l02" (ai_actors allies_lz_marine_1/0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_r02" (ai_actors allies_lz_marine_1/1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_r03" (ai_actors allies_lz_marine_1/2))
	
	;Get players in pelican 0
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_r05" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_0/pilot) "pelican_p_l05" (player1))
	
	;Get the marines in pelican 1
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot) "pelican_p_l03" (ai_actors ai_fly_pelican_commander))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot) "pelican_p_r03" (ai_actors ai_fly_pelican_marines_2))
	
	;And load coop players in that pelican as well
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot) "pelican_p_r05" (player2))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_lz_pelican_1/pilot) "pelican_p_l05" (player3))
	(sleep 1)
	
		; raise weapons 
		(unit_raise_weapon (player0) 1)
		(unit_raise_weapon (player1) 1)
		(unit_raise_weapon (player2) 1)
		(unit_raise_weapon (player3) 1)
		(sleep 1)
			
			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)
			
	; sleep while ai get in the vehicle 	
	(sleep 15)
	
	; fade in player input 
	(player_control_fade_in_all_input 1)

	; enable player input 
	(player_disable_movement TRUE)

	; fade to title 
	(cinematic_fade_to_title)
)

;=========================================================================================
;================================== ALPHA INSERTION ======================================
;=========================================================================================
(script static void ins_alpha
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_011)	
	(sleep 1)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) carbine_profile TRUE TRUE)
	(unit_add_equipment (player2) carbine_profile TRUE TRUE)
	(unit_add_equipment (player3) carbine_profile TRUE TRUE)
	(sleep 1)
	
	(insertion_start)
	
	(070_insertion_intro)
	(if b_debug (print "insertion point : alpha"))

	(object_teleport (player0) flg_la_start_location_p0)
	(object_teleport (player1) flg_la_start_location_p1)
	(object_teleport (player2) flg_la_start_location_p2)
	(object_teleport (player3) flg_la_start_location_p3)	
		
	; set insertion point index 
	(set g_insertion_index 9)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_fl_progression 200)
	
	;*;Clear the objective to destroy the AA wraiths
	(objective_1_clear)
	;Set the objective to get through the forerunner wall
	(objective_2_set)
	;Set the objective to get to the cartographer
	(objective_3_set)*;
	
	(wake 070_chapter_forward)
	
	;Place allies
	(ai_place allies_la_player_scorpion)
	(ai_place allies_la_mar_on_foot)
	(ai_place allies_la_scorpion_0)
	(ai_place allies_la_scorpion_1)
	(ai_place allies_la_warthog_0)
	(place_guilty_spark la_guilty_spark/guilty)
	
	(set obj_fl_scorpion_0 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank))
	(set obj_fl_scorpion_1 (ai_vehicle_get_from_starting_location allies_la_scorpion_0/driver))
	(set obj_fl_scorpion_2 (ai_vehicle_get_from_starting_location allies_la_scorpion_1/driver))
	(set obj_fl_warthog (ai_vehicle_get_from_starting_location allies_la_warthog_0/driver))
			
	(sleep 1)
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 5)
	(set s_gs_talking_dist 7)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)	
	
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/0 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) "scorpion_p_rf")
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/1 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) "scorpion_p_lf")
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/2 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) "scorpion_p_rb")
	
	;Create the frigate
	(fl_create_frigate)
	(fl_replace_elevators)
	(sleep 1)
	(device_set_position_immediate fl_frigate_midshaft 0.755)
	(device_set_position_immediate fl_frigate_frontshaft 0.82)
	(device_set_position_immediate fl_frigate_backshaft 0.8)
	
	;disable the whole elevators area for pathfinding
	(object_create_folder sce_fl_pathfinding)
	
	(object_destroy aw_cov_watch_pod_1)
	
	(unit_kill ex_cave_warthog)
	(unit_kill ex_cave_mongoose)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) "scorpion_d" true)
	
	(wake 070_music_08)
	(wake 070bb_dialog)
	(set b_fl_briefing_finished 1)
	
	;(wake insertion_end)
	(sleep 45)
	(fade_in 0 0 0 15)
)

;=========================================================================================
;================================== FLOOR 1 ==============================================
;=========================================================================================
(script static void ins_floor_1
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_040_050_071)
	(sleep 1)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) carbine_profile TRUE TRUE)
	(unit_add_equipment (player2) carbine_profile TRUE TRUE)
	(unit_add_equipment (player3) carbine_profile TRUE TRUE)
	(sleep 1)
	
	(insertion_start)
	
	(set b_070_music_12 TRUE)
	
	(070_insertion_intro)
	(if b_debug (print "insertion point : floor 1"))

	(object_teleport (player0) flg_f1_start_location_p0)
	(object_teleport (player1) flg_f1_start_location_p1)
	(object_teleport (player2) flg_f1_start_location_p2)
	(object_teleport (player3) flg_f1_start_location_p3)	
	
	;(unit_raise_weapon (player0) 30)
	;(unit_raise_weapon (player1) 30)
	;(unit_raise_weapon (player2) 30)
	;(unit_raise_weapon (player3) 30)

	; set insertion point index 
	(set g_insertion_index 14)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)
	(set s_abb_progression 200)
	
	;Set the objective to destroy the AA wraiths
	(objective_1_set)
	;Clear the objective to destroy the AA wraiths
	(objective_1_clear)
	;Set the objective to get through the forerunner wall
	(objective_2_set)
	;Clear the objective to get through the forerunner wall
	(objective_2_clear)
	;Set the objective to get to the cartographer
	(objective_3_set)
	
	(place_arbiter allies_f1_arbiter/arbiter)
	(ai_place allies_f1_mar)
	(place_guilty_spark f1_guilty_spark/guilty)	
	(set ai_abb_pelican_marines_0 allies_f1_mar/0)
	(set ai_abb_pelican_marines_1 allies_f1_mar/1)
	
	(wake 070_chapter_real_men)
	
	(sleep 45)
	(fade_in 0 0 0 15)
)

;*
;=========================================================================================
;================================== BOWL 1 ===============================================
;=========================================================================================
(script static void ins_bowl_1
	(070_insertion_intro)
	(if b_debug (print "insertion point : bowl 1"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_000)
	(sleep 1)

	(object_teleport (player0) flg_b1_start_location_p0)
	(object_teleport (player1) flg_b1_start_location_p1)
	(object_teleport (player2) flg_b1_start_location_p2)
	(object_teleport (player3) flg_b1_start_location_p3)

	; set insertion point index 
	(set g_insertion_index 2)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 10)
	
	;Background & ambiant action
	(wake background_bowls)
	
	;Place allies
	(ai_place allies_b1_marines_0)
	(ai_place allies_b1_intro_marine)
)

;=========================================================================================
;================================== BOWL 2 ===============================================
;=========================================================================================
(script static void ins_bowl_2
	(070_insertion_intro)
	(if b_debug (print "insertion point : bowl 2"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_000_005)
	(sleep 1)

	(object_teleport (player0) flg_b2_start_location_p0)
	(object_teleport (player1) flg_b2_start_location_p1)
	(object_teleport (player2) flg_b2_start_location_p2)
	(object_teleport (player3) flg_b2_start_location_p3)

	; set insertion point index 
	(set g_insertion_index 3)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	
	(set b_b1_finished true)
	
	;Background & ambiant action
	(wake background_bowls)
	
	;Place allies
	(ai_place allies_b2_marines_0)
)

;=========================================================================================
;================================== FORERUNNER PASSAGE ===================================
;=========================================================================================
(script static void ins_forerunner_passage
	(070_insertion_intro)
	(if b_debug (print "insertion point : forerunner passage"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_000_005_010)
	(sleep 1)

	(object_teleport (player0) flg_fp_start_location_p0)
	(object_teleport (player1) flg_fp_start_location_p1)
	(object_teleport (player2) flg_fp_start_location_p2)
	(object_teleport (player3) flg_fp_start_location_p3)

	; set insertion point index 
	(set g_insertion_index 4)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	
	;Place allies
	(ai_place allies_fp_marines_0)
)

;=========================================================================================
;================================== EXPLORATION ==========================================
;=========================================================================================
(script static void ins_exploration
	(070_insertion_intro)
	(if b_debug (print "insertion point : exploration"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_005_010)
	(sleep 1)

	(object_teleport (player0) flg_ex_start_location_p0)
	(object_teleport (player1) flg_ex_start_location_p1)
	(object_teleport (player2) flg_ex_start_location_p2)
	(object_teleport (player3) flg_ex_start_location_p3)

	; set insertion point index 
	(set g_insertion_index 5)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	
	;Place allies
	(ai_place allies_fp_marines_0)
	(ai_place allies_fp_sniper_marine)
)

;=========================================================================================
;================================== SENTINEL DEFENSE =====================================
;=========================================================================================
(script static void ins_sentinel_defense
	(070_insertion_intro)
	(if b_debug (print "insertion point : sentinel defense"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_011)
	(sleep 1)

	(object_teleport (player0) flg_sd_start_location_p0)
	(object_teleport (player1) flg_sd_start_location_p1)
	(object_teleport (player2) flg_sd_start_location_p2)
	(object_teleport (player3) flg_sd_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)	

	; set insertion point index 
	(set g_insertion_index 6)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 40)
	
	;Place allies
	(ai_place allies_sd_warthog)
	(sleep 1)
	(unit_enter_vehicle (player0) (ai_vehicle_get_from_starting_location allies_sd_warthog/gunner) "warthog_d")
)

;=========================================================================================
;================================== ANTIAIR WRAITHS ======================================
;=========================================================================================
(script static void ins_antiair_wraiths
	(070_insertion_intro)
	(if b_debug (print "insertion point : antiair wraiths"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_011)
	(sleep 1)

	(object_teleport (player0) flg_aw_start_location_p0)
	(object_teleport (player1) flg_aw_start_location_p1)
	(object_teleport (player2) flg_aw_start_location_p2)
	(object_teleport (player3) flg_aw_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)	

	; set insertion point index 
	(set g_insertion_index 7)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	
	;Place allies
	(ai_place allies_aw_warthog_0)
	(sleep 1)
	(unit_enter_vehicle (player0) (ai_vehicle_get_from_starting_location allies_aw_warthog_0/gunner) "warthog_d")
)

;=========================================================================================
;================================== FRIGATE LANDING ======================================
;=========================================================================================

(script static void ins_frigate_landing
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_011)
	(sleep 1)
	
	(insertion_start)
	
	(070_insertion_intro)
	(if b_debug (print "insertion point : frigate landing"))

	(object_teleport (player0) flg_fl_start_location_p0)
	(object_teleport (player1) flg_fl_start_location_p1)
	(object_teleport (player2) flg_fl_start_location_p2)
	(object_teleport (player3) flg_fl_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 8)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	
	;Give the objective to destroy the AA wraiths
	(objective_1_set)
	
	;Place allies
	(ai_place allies_fl_extra_warthog)
	(sleep 1)
	(unit_enter_vehicle (player0) (ai_vehicle_get_from_starting_location allies_fl_extra_warthog/gunner) "warthog_d")
	
	(wake insertion_end)
)

;=========================================================================================
;================================== LEAD THE ARMY ========================================
;=========================================================================================
(script static void ins_lead_the_army
	(070_insertion_intro)
	(if b_debug (print "insertion point : lead the army"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_011)
	(sleep 1)

	(object_teleport (player0) flg_la_start_location_p0)
	(object_teleport (player1) flg_la_start_location_p1)
	(object_teleport (player2) flg_la_start_location_p2)
	(object_teleport (player3) flg_la_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 9)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	
	;Place allies
	(ai_place allies_la_player_scorpion)
	(ai_place allies_la_mar_on_foot)
	(ai_place allies_la_scorpion_0)
	(ai_place allies_la_scorpion_1)
	(ai_place allies_la_warthog_0)
	(place_guilty_spark la_guilty_spark/guilty)
	
	(set obj_fl_scorpion_0 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank))
	(set obj_fl_scorpion_1 (ai_vehicle_get_from_starting_location allies_la_scorpion_0/driver))
	(set obj_fl_scorpion_2 (ai_vehicle_get_from_starting_location allies_la_scorpion_1/driver))
	(set obj_fl_warthog (ai_vehicle_get_from_starting_location allies_la_warthog_0/driver))
		
	(sleep 1)
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 5)
	(set s_gs_talking_dist 7)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)	
	
	(unit_enter_vehicle (player0) (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) "scorpion_d")
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/0 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank))
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/1 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank))
	(ai_vehicle_enter_immediate allies_la_mar_on_foot/2 (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank))
)

;=========================================================================================
;================================== DEFEND WALL ==========================================
;=========================================================================================
(script static void ins_defend_wall
	(070_insertion_intro)
	(if b_debug (print "insertion point : defend_wall"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_010_020)
	(sleep 1)

	(object_teleport (player0) flg_dw_start_location_p0)
	(object_teleport (player1) flg_dw_start_location_p1)
	(object_teleport (player2) flg_dw_start_location_p2)
	(object_teleport (player3) flg_dw_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 10)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 90)
	
	;Place allies
	(ai_place allies_dw_player_scorpion)
	(ai_place allies_dw_scorpion_0)
	(ai_place allies_dw_scorpion_1)
	(ai_place allies_dw_warthog_0)
	(place_guilty_spark dw_guilty_spark/guilty)
	(sleep 1)
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 5)
	(set s_gs_talking_dist 7)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(unit_enter_vehicle (player0) (ai_vehicle_get_from_starting_location allies_dw_player_scorpion/tank) "scorpion_d")
)

;=========================================================================================
;================================== LIGHTBRIDGE ==========================================
;=========================================================================================
(script static void ins_lightbridge
	(070_insertion_intro)
	(if b_debug (print "insertion point : lightbridge"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_020_030)
	(sleep 1)

	(object_teleport (player0) flg_lb_start_location_p0)
	(object_teleport (player1) flg_lb_start_location_p1)
	(object_teleport (player2) flg_lb_start_location_p2)
	(object_teleport (player3) flg_lb_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 11)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	
	(set b_dw_combat_finished 1)
	(set b_dw_gs_open_door 1)
	
	;Place allies
	(place_guilty_spark lb_guilty_spark/guilty)
	
	(wake dw_manage_guilty)
)

;=========================================================================================
;================================== BIG BATTLE ===========================================
;=========================================================================================
(script static void ins_big_battle
	(070_insertion_intro)
	(if b_debug (print "insertion point : big battle"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_020_030)
	(sleep 1)

	(object_teleport (player0) flg_bb_start_location_p0)
	(object_teleport (player1) flg_bb_start_location_p1)
	(object_teleport (player2) flg_bb_start_location_p2)
	(object_teleport (player3) flg_bb_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 12)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	
	;Place allies
	(place_guilty_spark bb_guilty_spark/guilty)
	
	(device_set_power bb_player_door 1.0)
)

;=========================================================================================
;================================== AFTER BIG BATTLE =====================================
;=========================================================================================
(script static void ins_after_big_battle
	(070_insertion_intro)
	(if b_debug (print "insertion point : after big battle"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_030_040)
	(sleep 1)

	(object_teleport (player0) flg_abb_start_location_p0)
	(object_teleport (player1) flg_abb_start_location_p1)
	(object_teleport (player2) flg_abb_start_location_p2)
	(object_teleport (player3) flg_abb_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 13)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)

	(ai_place allies_bb_player_warthog_sb)
	(ai_place allies_bb_scorpion_0_sb)
	(ai_place allies_bb_scorpion_1_sb)
	(ai_place allies_bb_scorpion_2_sb)

	(place_guilty_spark abb_guilty_spark/guilty)
	
	(wake bb_manage_base_defense)
	
	(wake md_abb_scarab_dead)
	
	;Advance player progression to the 4th floor
	(set s_bb_skip_progression 80)
	(set b_bb_warthog_spawned 1)
	(set b_bb_wraith_dropped 1)
	(set b_bb_dropped_cache_defense 1)
	(set b_bb_dropped_3rd_floor 1)
	(set b_bb_ghosts_escort_wraiths 1)
	(set bb_scarab_spawned 1)
)

;=========================================================================================
;================================== FLOOR 2 ==============================================
;=========================================================================================
(script static void ins_floor_2
	(070_insertion_intro)
	(if b_debug (print "insertion point : floor 2"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_040_050_071)
	(sleep 1)

	(object_teleport (player0) flg_f2_start_location_p0)
	(object_teleport (player1) flg_f2_start_location_p1)
	(object_teleport (player2) flg_f2_start_location_p2)
	(object_teleport (player3) flg_f2_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 15)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)
	(set s_abb_progression 200)
	(set s_f1_progression 200)
	
	(ai_place allies_f2_mar)
	(place_arbiter allies_f2_arbiter/arbiter)	
	(place_guilty_spark f2_guilty_spark/guilty)
)

;=========================================================================================
;================================== FLOOR 3 ==============================================
;=========================================================================================
(script static void ins_floor_3
	(070_insertion_intro)
	(if b_debug (print "insertion point : floor 3"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_050_060_080_071)
	(sleep 1)

	(object_teleport (player0) flg_f3_start_location_p0)
	(object_teleport (player1) flg_f3_start_location_p1)
	(object_teleport (player2) flg_f3_start_location_p2)
	(object_teleport (player3) flg_f3_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 16)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)
	(set s_abb_progression 200)
	(set s_f1_progression 200)
	(set s_f2_progression 200)
	
	(place_guilty_spark f3_p1_guilty_spark/guilty)
	(ai_place allies_f3_p1_mar_0)
	(ai_place allies_f3_p1_mar_1)
	(place_arbiter allies_f3_arbiter_follow/arbiter)	
)

;=========================================================================================
;================================== FLOOR 4 ==============================================
;=========================================================================================
(script static void ins_floor_4
	(070_insertion_intro)
	(if b_debug (print "insertion point : floor 4"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_060_070_080_071)
	(sleep 1)

	(object_teleport (player0) flg_f4_start_location_p0)
	(object_teleport (player1) flg_f4_start_location_p1)
	(object_teleport (player2) flg_f4_start_location_p2)
	(object_teleport (player3) flg_f4_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 17)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)
	(set s_abb_progression 200)
	(set s_f1_progression 200)
	(set s_f2_progression 200)
	(set s_f3_p1_progression 200)
	(set s_f3_p2_progression 200)
	
	(set b_f3_p2_started 1)
	
	(wake f3_manage_kill_volumes)
	
	(place_guilty_spark f4_guilty_spark/guilty)
	(ai_place allies_f4_marines)
)

;=========================================================================================
;================================== FLOOR 5 ==============================================
;=========================================================================================
(script static void ins_floor_5
	(070_insertion_intro)
	(if b_debug (print "insertion point : floor 5"))
	
	; switch to correct zone set
	(if b_debug (print "switching zone sets..."))
	(switch_zone_set 070_060_070_080_071)
	(sleep 1)

	(object_teleport (player0) flg_f5_start_location_p0)
	(object_teleport (player1) flg_f5_start_location_p1)
	(object_teleport (player2) flg_f5_start_location_p2)
	(object_teleport (player3) flg_f5_start_location_p3)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)
	(unit_add_equipment (player2) br_profile TRUE TRUE)
	(unit_add_equipment (player3) br_profile TRUE TRUE)

	; set insertion point index 
	(set g_insertion_index 18)
	
	;Advance mission progress
	(set s_lz_progression 200)
	(set s_b1_progression 200)
	(set s_b2_progression 200)
	(set s_fp_progression 200)
	(set s_ex_progression 200)
	(set s_sd_progression 200)
	(set s_aw_progression 200)
	(set s_la_progression 200)
	(set s_dw_progression 200)
	(set s_lb_progression 200)
	(set s_bb_progression 200)
	(set s_abb_progression 200)
	(set s_f1_progression 200)
	(set s_f2_progression 200)
	(set s_f3_p1_progression 200)
	(set s_f3_p2_progression 200)
	(set s_f4_progression 200)
	
	(set b_f3_p2_started 1)
	
	(place_guilty_spark f5_guilty_spark/guilty)
	(ai_place allies_f5_marines)
)
*;