; =======================================================================================================================================================================
; =======================================================================================================================================================================
; END MISSION CONDITIONS  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 050_floodvoi_mission_won
	(sleep_until (> (device_group_get dg_cortana) 0))
		
	; set current mission segment 
	(data_mine_set_mission_segment "050lb_shadow_of_intent")

	; clear objectives 
	(objectives_finish_up_to 1)

	; disable all zone swap volumes 
	(gs_disable_zone_volumes)
	
	; fade to black 
	(cinematic_fade_to_black)

	; award mission achievement 
	(game_award_level_complete_achievements)
		
	; erase all ai 
	(ai_erase_all)

	; switch zone sets 
	(switch_zone_set set_cin_outro)
	
	;stop music
	(wake 050_music_085_stop)
	(wake 050_music_09_stop)
	
	; destroy cortana beacon 
	(set g_cortana_flicker TRUE)
	(object_destroy cortana_beacon)
	(object_destroy cortana_light)
	(sleep 1)

		; start intro cinematic (part one) 
		(if g_play_cinematics
			(begin
				(if (cinematic_skip_start)
					(begin
						
						(if debug (print "050la_floodship_intro"))
						(050lb_shadow_of_intent)
	
						; cinematic snap to black 
						(cinematic_snap_to_black)
					
						; cleanup cinematic scripts 
						(050lb_shadow_of_intent_cleanup)
					
						; switch zone sets 
						(switch_zone_set set_hangar)
						
							; start second half of cinematic 
							(if (cinematic_skip_start)
								(begin
									(if debug (print "050lb_hanger_scene"))
									(050lb_hanger_scene)
								)
							)
					)
				)
				(cinematic_skip_stop)
			)
		)

		(sound_class_set_gain "" 0 0)
		
		; cleanup cinematic scripts 
		(050lb_shadow_of_intent_cleanup)
		(050lb_hanger_scene_cleanup)

	(sleep 5)		
	(end_mission)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; primary objectives  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant obj_stop_spread_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Stop the spread of the Flood infestation."))
	(objectives_show_up_to 0)
     (cinematic_set_chud_objective obj_0)
)
(script dormant obj_stop_spread_clear
	(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Stop the spread of the Flood infestation."))
	(objectives_finish_up_to 0)
)

; =======================================================================================================================================================================

(script dormant obj_cortana_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Locate Cortana within the crashed ship."))
	(objectives_finish_up_to 0)
	(objectives_show_up_to 1)
     (cinematic_set_chud_objective obj_1)
)
(script dormant obj_cortana_clear
	(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Locate Cortana within the crashed ship."))
	(objectives_finish_up_to 1)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; chapter titles  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_chapter_home FALSE)
(global boolean chapter_finished FALSE)

(script dormant chapter_home
	; fade to title 
	(cinematic_fade_to_title)
		(sleep 15)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
	
	; allow briefing to progress 
	(set g_chapter_home TRUE)
)

(script dormant chapter_shadow
		(sleep 30)
	(cinematic_set_title title_2)
		(sleep 150)
	(if (= perspective_running FALSE) (chapter_stop))
	(set chapter_finished TRUE)
)

(script dormant chapter_booger
		(sleep 30)
	(chapter_start)
	(cinematic_set_title title_3)
	(sleep 150)
	(chapter_stop)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; nav points   
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;navpoint leads to the workertown encounter :: wake at start of level
(script dormant cs_wt_navpoint_start
	(sleep 900)
	(if (<= g_wt_obj_control 2)
		(begin
			(hud_activate_team_nav_point_flag player nav_workertown_start 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_workertown_start) 1)
					(>= g_wt_obj_control 3)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_workertown_start)
		)
	)
	(wake cs_wt_navpoint_mid)
)

;navpoint leads to the workertown encounter :: wake at start of level
(script dormant cs_wt_navpoint_mid
	(sleep_until (>= g_wt_obj_control 11) 1 1800)
	(if (<= g_wt_obj_control 10)
		(begin
			(hud_activate_team_nav_point_flag player nav_workertown_mid 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_workertown_mid) 1)
					(>= g_wt_obj_control 11)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_workertown_mid)
		)
	)
)

;navpoint leads to the warehouse encounter :: wake when the workertown encounter is dispersed
(script dormant cs_wt_navpoint_end
	(sleep_until (>= g_wh_obj_control 1) 1 600)
	(if (<= g_wh_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_workertown_end 0.55)
			(sleep_until
				(or
					(<= (objects_distance_to_flag (players) nav_workertown_end) 1)
					(>= g_wh_obj_control 1)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_workertown_end)
		)
	)
)

;navpoint leads to the stairs at the end of the warehouse encounter :: wake when the first warehouse disperse is called
(script dormant cs_wh_navpoint_mid
	(sleep_until (>= g_wh_obj_control 5) 1 600)
	(if (<= g_wh_obj_control 4)
		(begin
			(hud_activate_team_nav_point_flag player nav_warehouse_mid 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_warehouse_mid) 1)
					(>= g_wh_obj_control 5)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_warehouse_mid)
		)
	)
)

;navpoint leads to the drop off at the end of the warehouse encounter :: wake when the second warehouse disperse is called
(script dormant cs_wh_navpoint_end
	(sleep_until (>= g_wh_obj_control 11) 1 600)
	(if (<= g_wh_obj_control 10)
		(begin
			(hud_activate_team_nav_point_flag player nav_warehouse_stairs 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_warehouse_stairs) 1)
					(>= g_wh_obj_control 11)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_warehouse_stairs)
		)
	)
	(sleep_until (>= g_wh_obj_control 13) 1 600)
	(if (<= g_wh_obj_control 12)	
		(begin
			(hud_activate_team_nav_point_flag player nav_warehouse_end 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_warehouse_end) 1)
					(>= g_wh_obj_control 13)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_warehouse_end)
			(sleep 1)
			(if (<= g_wh_obj_control 12)	
				(begin
					(hud_activate_team_nav_point_flag player nav_warehouse_drop 0.55)
					(sleep_until 
						(or
							(<= (objects_distance_to_flag (players) nav_warehouse_drop) 1)
							(>= g_wh_obj_control 13)
						)
					1)
					(hud_deactivate_team_nav_point_flag player nav_warehouse_drop)
				)
			)
		)
	)	
)

;navpoint leads to the lakebed_b encounter :: wake during start of trans_a
(script dormant cs_ta_navpoint_end
	(sleep_until (>= g_ta_obj_control 6) 1 900)
	(if (<= g_ta_obj_control 5)
		(begin
			(hud_activate_team_nav_point_flag player nav_trans_a_end 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_trans_a_end) 1)
					(>= g_ta_obj_control 6)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_trans_a_end)
		)
	)
)

;navpoint leads to the elite area in the lakebed_b encounter :: wake during start of lakebed b
(script dormant cs_lb_navpoint_start
	(sleep_until (>= g_lb_obj_control 5) 1 600)
	(if (<= g_lb_obj_control 4)
		(begin
			(hud_activate_team_nav_point_flag player nav_lakebed_b_start 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_lakebed_b_start) 1)
					(>= g_lb_obj_control 5)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_lakebed_b_start)
		)
	)
)

;navpoint leads to the factory arm :: wake at disperse of flood
(script dormant cs_lb_navpoint_end
	(sleep_until (>= g_fb_obj_control 1) 1 1800)
	(if (<= g_fb_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_lakebed_b_end 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_lakebed_b_end) 1)
					(>= g_fb_obj_control 1)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_lakebed_b_end)
		)
	)
)

;navpoint leads to the and of the factory arm :: wake at entrance to factory_b
(script dormant cs_fb_navpoint_end
	(sleep_until (>= g_la_obj_control 1) 1 1800)
	(if (<= g_la_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_factory_b_end 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_factory_b_end) 1)
					(>= g_la_obj_control 1)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_factory_b_end)
		)
	)
)

;navpoint leads to the drop off at the end of the warehouse encounter :: call at 
(script dormant cs_fs_navpoint_entrance
	(sleep_until (>= g_la_obj_control 6) 1 1800)
	(if (<= g_fs_obj_control 0)	
		(begin
			(hud_activate_team_nav_point_flag player nav_floodship_start 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) nav_floodship_start) 2)
					(>= g_fs_obj_control 1)
				)
			1)
			(hud_deactivate_team_nav_point_flag player nav_floodship_start)
			(sleep 1)
			(if (<= g_fs_obj_control 1)	
				(begin
					(hud_activate_team_nav_point_flag player nav_floodship_start_bottom 0.55)
					(sleep_until 
						(or
							(<= (objects_distance_to_flag (players) nav_floodship_start_bottom) 1)
							(>= g_fs_obj_control 1)
						)
					1)
					(hud_deactivate_team_nav_point_flag player nav_floodship_start_bottom)
				)
			)
		)
	)	
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; ==========music============================================================================
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant 050_music_01_start
	(print "***MUSIC: 050_music_01 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_01" none 1.0)
)

(script dormant 050_music_01_stop
	(print "***MUSIC: 050_music_01 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_01")
)

(script dormant 050_music_02_start
	(print "***MUSIC: 050_music_02 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_02" none 1.0)
)

(script dormant 050_music_02_stop
	(print "***MUSIC: 050_music_02 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_02")
)

(script dormant 050_music_03_start
	(print "***MUSIC: 050_music_03 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_03" none 1.0)
)

(script dormant 050_music_04_start
	(sleep_until (volume_test_players tv_enc_lakebed_a_01))
	(print "***MUSIC: 050_music_04 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_04" none 1.0)
)

(script dormant 050_music_04_stop
	(print "***MUSIC: 050_music_04 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_04")
)

(script dormant 050_music_05_start
	(print "***MUSIC: 050_music_05 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_05" none 1.0)
)

(script dormant 050_music_05_stop
	(print "***MUSIC: 050_music_05 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_05")
)

(script dormant 050_music_06_start
	(print "***MUSIC: 050_music_06 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_06" none 1.0)
)

(script dormant 050_music_06_stop
	(print "***MUSIC: 050_music_06 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_06")
)

(script dormant 050_music_07_start
	(print "***MUSIC: 050_music_07 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_07" none 1.0)
)

(script dormant 050_music_07_stop
	(print "***MUSIC: 050_music_07 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_07")
)

(script dormant 050_music_08_start
	(print "***MUSIC: 050_music_08 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_08" none 1.0)
)

(script dormant 050_music_08_stop
	(print "***MUSIC: 050_music_08 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_08")
)

(script dormant 050_music_081_start
	(print "***MUSIC: 050_music_081 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_081" none 1.0)
)

(script dormant 050_music_085_start
	(print "***MUSIC: 050_music_085 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_085" none 1.0)
)

(script dormant 050_music_085_stop
	(print "***MUSIC: 050_music_085 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_085")
)

(script dormant 050_music_09_start
	(print "***MUSIC: 050_music_09 start")
	(sound_looping_start "levels\solo\050_floodvoi\music\050_music_09" none 1.0)
)

(script dormant 050_music_09_stop
	(print "***MUSIC: 050_music_09 stop")
	(sound_looping_stop "levels\solo\050_floodvoi\music\050_music_09")
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; mission_dialogue 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global ai arbiter NONE)
(global ai sarge NONE)
(global ai marine01 NONE)
(global ai marine02 NONE)
(global ai marine03 NONE)
(global ai fem_marine01 NONE)

(global ai elite01 NONE)
(global ai elite02 NONE)

(global ai johnson NONE)
(global ai joh_marine01 NONE)
(global ai joh_marine02 NONE)
(global ai joh_marine03 NONE)

(global unit obj_arbiter NONE)
(global unit obj_johnson NONE)

(global boolean g_playing_dialogue FALSE)

; ===================================================================================================================================================

(script static void md_cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

(script static void md_cleanup_lakebed_b
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
	
	;raises weapon
	(vs_lower_weapon arbiter FALSE)
	(vs_lower_weapon elite01 FALSE)
			
	; ai disregard these actors 
	(ai_disregard arbiter FALSE)
	(ai_disregard elite01 FALSE)	
	
)

; ===================================================================================================================================================

(script dormant md_wt_arb_reminder
	(sleep_until
				(or
					(and
						g_wt_flood_placed
						(>= g_wt_obj_control 12)
						(<= (ai_task_count obj_wt_flood/main_gate) 4)
					)
					(>= g_wh_obj_control 2)
				)
	)

	(if debug (print "mission_dialogue : warehouse : arbiter : parasite"))

		; cast the actors
		(vs_cast gr_arbiter TRUE 0 "050MC_160")
			(set arbiter (vs_role 1))

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
	(vs_enable_looking gr_arbiter  TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_arbiter TRUE)

	(sleep 1)

		(if dialogue (print "ARBITER: Quickly! Let us find their ship!"))
		(sleep (ai_play_line arbiter 050MC_160))
		(sleep 10)

		(if dialogue (print "ARBITER: Make short work of this abomination!"))
		(sleep (ai_play_line arbiter 050MC_170))
		
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_wh_marine_chews
	(sleep_until	(and
					(>= g_wh_obj_control 2)
					(<= (ai_task_count obj_wh_flood/room_a_gate) 0)
				)
	)

	(if debug (print "mission_dialogue : warehouse : marine : chews"))

		; cast the actors
		(vs_cast gr_marines TRUE 0 "050MC_050" "050MC_070")
			(set marine01 (vs_role 1))
			(set marine02 (vs_role 2))
		(vs_set_cleanup_script md_cleanup)

	(vs_enable_pathfinding_failsafe marine01 TRUE)
	(vs_enable_pathfinding_failsafe marine02 TRUE)
	(vs_enable_looking marine01  TRUE)
	(vs_enable_looking marine02  TRUE)
	(vs_enable_targeting marine01 TRUE)
	(vs_enable_targeting marine02 TRUE)
	(vs_enable_moving marine01 TRUE)
	(vs_enable_moving marine02 TRUE)
	
	(ai_dialogue_enable FALSE)
		(sleep (random_range 15 30))

	(if dialogue (print "MARINE: It gets inside you, chews you up..."))
	(sleep (ai_play_line marine01 050MC_050))
	(sleep 10)
	
	(if dialogue (print "MARINE: We gotta get out of here!"))
	(sleep (ai_play_line marine02 050MC_080))
	(sleep 10)
	
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_wh_arb_parasite
	(sleep_until 
		(and
			(>= g_wh_obj_control 8)
			(<= (ai_task_count obj_wh_flood/room_c_gate) 4)
		)
	)

	(if debug (print "mission_dialogue : warehouse : arbiter : parasite"))

		; cast the actors
		(vs_cast gr_arbiter TRUE 0 "050MC_130")
			(set arbiter (vs_role 1))
		(vs_set_cleanup_script md_cleanup)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
	(vs_enable_looking gr_arbiter  TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_arbiter TRUE)

	(sleep 1)

		(ai_dialogue_enable FALSE)

		(if dialogue (print "ARBITER: Cursed parasite!"))
		(sleep (ai_play_line arbiter 050MC_130))
		(sleep 10)

		(if dialogue (print "ARBITER: Rise up, and I will kill you!"))
		(sleep (ai_play_line arbiter 050MC_140))
		(sleep 10)

		(if dialogue (print "ARBITER: Again! And again!"))
		(sleep (ai_play_line arbiter 050MC_150))
		
		(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lb_arb_my_brothers
	(sleep_until (>= g_lb_obj_control 5))
		(sleep (random_range 30 60))
	
	(if debug (print "mission dialogue:lb:arb:my:brothers"))

	; cast the actors
	(vs_cast gr_arbiter TRUE 5 "050ME_010")
		(set arbiter (vs_role 1))
	
	(if (>= (ai_living_count sq_lb_elites/commander) 1)
		(begin
			(vs_cast sq_lb_elites/commander TRUE 5 "050ME_020")
				(set elite01 (vs_role 1))
		)
		(begin
			(vs_cast sq_lb_elites TRUE 5 "050ME_020")
				(set elite01 (vs_role 1))
		)
	)
	
	(vs_set_cleanup_script md_cleanup_lakebed_b)

	(sleep 1)
;*
	; movement properties
	(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
	(vs_enable_looking gr_arbiter  TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_arbiter TRUE)
		(vs_enable_targeting elite01 TRUE)
*;

	; look at each other 
	(vs_aim_object arbiter TRUE (ai_get_object elite01))
	(vs_aim_object elite01 TRUE (ai_get_object arbiter))
	
	(sleep_until 
		(or
			(volume_test_object tv_lb_05 (ai_get_object gr_arbiter))
			(>= g_lb_obj_control 7)
		)		
	1)
	
	(ai_dialogue_enable FALSE)
	(sleep (random_range 30 60))
	
	(if (volume_test_object tv_lb_05 (ai_get_object gr_arbiter))
		(begin
			
			; lower weapons 
			(vs_lower_weapon arbiter TRUE)
			(vs_lower_weapon elite01 TRUE)
			
			; tell actors to go to point 
			(vs_go_to arbiter FALSE ps_lb/arbiter)
			(vs_go_to elite01 FALSE ps_lb/elite)
			
			; ai disregard these actors 
			(ai_disregard arbiter TRUE)
			(ai_disregard elite01 TRUE)
		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ARBITER: My brothers! I fear you bring bad news... "))
			(vs_play_line arbiter TRUE 050ME_010)
			(sleep 10)
;*		
			(if dialogue (print "ELITE: We could have used your blade, Arbiter"))
			(sleep (ai_play_line elite01 050ME_020))
			(sleep 10)
*;		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ELITE: High Charity has fallen -- become a fetid hive!"))
			(sleep (ai_play_line elite01 050ME_030))
			(sleep 10)
		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ARBITER: And the fleet? Has quarantine been broken?"))
			(sleep (ai_play_line arbiter 050ME_040))
			(sleep 10)
		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ELITE: This single ship broke through our line, and we gave chase."))
			(sleep (ai_play_line elite01 050ME_050))
			(sleep 10)
		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ARBITER: But we had a fleet of hundreds!"))
			(sleep (ai_play_line arbiter 050ME_060))
			(sleep 20)
		
				(if (>= g_lb_obj_control 6)
					(begin
						; look at each other 
						(vs_aim_object arbiter FALSE (ai_get_object elite01))
						(vs_aim_object elite01 FALSE (ai_get_object arbiter))
						
						; elite approaches arbiter 
						(vs_approach_stop elite01)
					)
				)

			(if dialogue (print "ELITE: Alas, brother. The Flood it has evolved."))
			(sleep (ai_play_line elite01 050ME_070))
		)
	)
	
	; lower weapons 
	(vs_lower_weapon arbiter FALSE)
	(vs_lower_weapon elite01 FALSE)
			
	; ai disregard these actors 
	(ai_disregard arbiter FALSE)
	(ai_disregard elite01 FALSE)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fb_elite_flood

	(if debug (print "mission_dialogue : factory_b : elite : flood"))

		; cast the actors
		(vs_cast gr_elites TRUE 0 "050MF_010")
			(set elite01 (vs_role 1))

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties
	(vs_enable_pathfinding_failsafe elite01 TRUE)
	(vs_enable_looking elite01  TRUE)
	(vs_enable_targeting elite01 TRUE)
	(vs_enable_moving elite01 TRUE)

	(sleep 1)

		(if dialogue (print "ELITE: Witness! The true horror of the Flood!"))
		(sleep (ai_play_line elite01 050MF_010))
		(sleep 10)

		(if dialogue (print "ELITE: See how they adapt to our attacks?!"))
		(sleep (ai_play_line elite01 050MF_020))
		(sleep 10)

		(if dialogue (print "ELITE: Draw close, and they become as stone!"))
		(sleep (ai_play_line elite01 050MF_030))
		(sleep 10)

		(if dialogue (print "ELITE: From a distance, they barb and bristle!"))
		(sleep (ai_play_line elite01 050MF_040))
		(sleep 10)

		(if dialogue (print "ELITE: Choose your weapons wisely!"))
		(sleep (ai_play_line elite01 050MF_050))
		
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_la_elite_hurry
	(sleep_until
				(and
					(= g_playing_dialogue FALSE)
					(>= g_la_obj_control 3)
				)
	)
	
	(if debug (print "mission dialogue:la:elite:hurry"))

		; cast the actors 
		(vs_cast gr_elites TRUE 0 "050MG_050")
			(set elite01 (vs_role 1))

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties 
	(vs_enable_pathfinding_failsafe elite01 TRUE)
	(vs_enable_looking elite01  TRUE)
	(vs_enable_targeting elite01 TRUE)
	(vs_enable_moving elite01 TRUE)

	(sleep 1)

		(if dialogue (print "ELITE (radio 3D): Hurry, demon!"))
		(sleep (ai_play_line elite01 050MG_050))
		(sleep 10)

		(if dialogue (print "ELITE (radio 3D): We seek the same prize"))
		(sleep (ai_play_line elite01 050MG_060))
		(sleep 10)

		(if dialogue (print "ELITE (radio 3D): But our Shipmaster will sacrifice all to stop the Flood!"))
		(sleep (ai_play_line elite01 050MG_070))
		(sleep 10)

	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_la_miranda_hurry
	(sleep_until (>= g_la_obj_control 8))
	(if debug (print "mission dialogue:la:miranda:hurry"))

	(sleep 1)

	(ai_dialogue_enable FALSE)

		(if dialogue (print "MIRANDA (radio): Hurry, Chief! Find Cortana!"))
		(sleep (ai_play_line_on_object NONE 050MG_080))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): The Elites are going to glass the city!"))
		(sleep (ai_play_line_on_object NONE 050MG_090))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Whether you're in it or not!"))
		(sleep (ai_play_line_on_object NONE 050MG_100))
		(sleep 10)		

	(ai_dialogue_enable TRUE)		
)

;script telling the player the arbiter is staying behind
(script dormant md_la_arb_staybehind
	(sleep_until (>= g_la_obj_control 9) 1)

	; cast the actors
	(vs_cast gr_arbiter TRUE 0 "050MQ_010")
	(set arbiter (vs_role 1))

	(sleep 1)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)

	; movement properties
	(vs_enable_pathfinding_failsafe gr_arbiter TRUE)
	(vs_enable_looking gr_arbiter  TRUE)
	(vs_enable_targeting gr_arbiter TRUE)
	(vs_enable_moving gr_arbiter TRUE)

	(sleep 1)

	(if dialogue (print "ARBITER: I shall remain here..."))
	(sleep (ai_play_line arbiter 050MQ_010))
	(sleep 10)

	(if dialogue (print "ARBITER: And will let nothing past!"))
	(sleep (ai_play_line arbiter 050MQ_020))
		
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===========================================================================================
; ==========Workertown=======================================================================
; ===========================================================================================

(global boolean g_wt_sarge_report FALSE)
(global boolean b_wt_alley 0)
(global boolean g_wt_marine_infected FALSE)
(global boolean g_wt_bunkered_marines TRUE)
(global boolean b_wt_distance_mar 0)
(global boolean b_wt_spawn_a 0)

(global short s_wt_flood_look 0)

(global object o_doomed_sarge NONE)

(script dormant vs_wt_sarge_report_in
	(sleep_until	(and 
					(not g_playing_dialogue)
					(>= g_wt_obj_control 6)
				)
	)	
	
	(ai_dialogue_enable FALSE)
	
	(if debug (print "mission dialogue : workertown : sarge_report_in"))
	(sleep 5)
		
	(if dialogue (print "SERGEANT (radio, static): All squads! Report!"))
	(sleep (ai_play_line_on_object NONE 050MA_040))
	(sleep 30)

	(if dialogue (print "MARINE (radio, static): Multiple contacts! Unknown hostiles! "))
	(sleep (ai_play_line_on_object NONE 050MA_050))
	(sleep 10)

	(if dialogue (print "MARINE (radio, static): There! Over there! "))
	(sleep (ai_play_line_on_object NONE 050MA_080))
	(sleep 15)

	(if dialogue (print "MARINE (radio, static): We're surrounded, Sergeant!"))
	(ai_play_line_on_object NONE 050MA_070)
	(sleep 30)

	(ai_dialogue_enable TRUE)

	(sleep_until 
		(or
			(= b_wt_alley 1) 
			(>= g_wt_obj_control 10)
		)		
	1)

	(ai_dialogue_enable FALSE)

	(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
	(sleep (ai_play_line_on_object vs_wt_report_flood 050MA_090))
	(sleep 10)
	
	(if dialogue (print "MARINE (radio, static): (scream of agony)"))
	(sleep (ai_play_line_on_object NONE 050MA_120))
	(sleep 10)
		
	(set g_playing_dialogue FALSE)
	(set g_wt_sarge_report TRUE)
	
	(ai_dialogue_enable TRUE)
)

(script dormant vs_wt_realtime_infection
	(sleep_until (>= g_wt_obj_control 11) 1)
	(if debug (print "vignette : workertown : infection"))

	(vs_cast sq_wt_doomed_mar/sarge FALSE 10 "")
		(set sarge (vs_role 1))
	(vs_cast sq_wt_doomed_mar/fem01 FALSE 10 "")
		(set fem_marine01 (vs_role 1))
	(set o_doomed_sarge (ai_get_object sq_wt_doomed_mar/sarge))
	(vs_set_cleanup_script md_cleanup)

	(sleep_until (>= g_wt_obj_control 12) 1)

	(vs_action sarge FALSE ps_wt/sarge ai_action_fallback)
	(vs_action fem_marine01 FALSE ps_wt/sarge ai_action_wave)
		
	(ai_dialogue_enable FALSE)
		
	(if dialogue (print "SERGEANT: Fall back! Fall back!"))
	(sleep (ai_play_line sarge 050MB_010))
	(sleep 25)

	(set b_wt_spawn_a 1)

	(if dialogue (print "MARINE: Sergeant! Come on!"))
	(sleep (ai_play_line fem_marine01 050MB_020))
	(sleep 10)

	(vs_enable_moving fem_marine01 TRUE)
	(vs_enable_targeting fem_marine01 TRUE)

	(sleep 60)
	(if dialogue (print "SERGEANT: (shout of surprise)"))
	(sleep (ai_play_line sarge 050VB_010))
	(sleep 10)
		
	(ai_dialogue_enable TRUE)
	
	(sleep_until 
		(and
			(<= (object_get_health (ai_get_object sq_wt_doomed_mar/sarge)) 0) 
			(> (object_get_health o_doomed_sarge) 0)
		)
	1 300)

	(ai_dialogue_enable FALSE)

	(if 
		(and
			(<= (object_get_health (ai_get_object sq_wt_doomed_mar/sarge)) 0)
			(> (object_get_health o_doomed_sarge) 0)
		)
		(begin
			(if dialogue (print "SERGEANT: No! Nooo!"))
			(sleep (ai_play_line_on_object o_doomed_sarge 050VB_020))
			(sleep 10)
		)
	)
	
	(if 
		(and
			(<= (object_get_health (ai_get_object sq_wt_doomed_mar/sarge)) 0)
			(> (object_get_health o_doomed_sarge) 0)
		)
		(begin
			(if dialogue (print "SERGEANT: (gurgling groan of demonic possession)"))
			(sleep (ai_play_line_on_object o_doomed_sarge 050VB_030))
			(set g_wt_marine_infected TRUE)
		)
	)
	
	(ai_dialogue_enable TRUE)
	
)

(script dormant vs_wt_marine_infected
	(sleep_until (>= g_wt_obj_control 12) 1)
	(if debug (print "mission dialogue : workertown : marine : infected"))

	(vs_cast sq_wt_init_mar01 FALSE 5 "050MB_060")
		(set fem_marine01 (vs_role 1))
	(vs_cast sq_wt_init_mar01 FALSE 5 "050MB_080")
		(set marine01 (vs_role 1))
	(vs_set_cleanup_script md_cleanup)

	(sleep 1)
	(vs_force_combat_status fem_marine01 3)
	(vs_enable_moving fem_marine01 TRUE)
	(vs_enable_targeting fem_marine01 TRUE)
	(vs_force_combat_status marine01 3)
	(vs_enable_moving marine01 TRUE)
	(vs_enable_targeting marine01 TRUE)
	
	(sleep 15)
	(vs_action marine01 TRUE ps_wt/sarge ai_action_point)
	(vs_action marine01 TRUE ps_wt/sarge ai_action_point)

	(sleep_until g_wt_marine_infected 1 300)
	
	(if (= g_wt_marine_infected 1)
		(vs_shoot marine01 TRUE o_doomed_sarge)
	)

	(sleep_until (<= (object_get_health o_doomed_sarge) 0) 1 300)

	(ai_dialogue_enable FALSE)

	(if 
		(and
			(<= (object_get_health o_doomed_sarge) 0)
			(= g_wt_marine_infected 1)
		)
		(begin
			(if dialogue (print "MARINE: What are you doing?!"))
			(sleep (ai_play_line fem_marine01 050MB_060))
			(sleep 10)

			(if dialogue (print "MARINE: That's the Sergeant!"))
			(sleep (ai_play_line fem_marine01 050MB_070))
			(sleep 10)
		
			(if dialogue (print "MARINE: That was the Sergeant, man"))
			(sleep (ai_play_line marine01 050MB_080))
			(sleep 10)
		
			(if dialogue (print "MARINE: It ain't no more!"))
			(sleep (ai_play_line marine01 050MB_090))
		)
	)

	(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
	(ai_play_line_on_object wt_combat02 050MA_090)
	(ai_play_line_on_object wt_combat03 050MA_090)
	
	(ai_dialogue_enable TRUE)
			
	(vs_shoot marine01 FALSE o_doomed_sarge)
	
	(set g_wt_bunkered_marines FALSE)
)

(script dormant sc_wt_distance
	(ai_place sq_wt_distance_mar)
	(sleep 240)
	(ai_place sq_wt_distance_flood)
	(effect_new_on_object_marker objects\weapons\turret\flamethrower\fx\biped_fire (ai_get_object sq_wt_distance_flood/01) "")
	(sleep 10)
	(set b_wt_distance_mar 1)
	(sleep_until (<= (ai_task_count obj_wt_flood/distance_gate) 2) 1)
		(if (> (ai_task_count obj_wt_allies/distance_mar) 0)
			(ai_place sq_wt_distance_flood 4)
		)
)

(script command_script cs_wt_mar_run
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_wt_distance/p2)
	(cs_go_to ps_wt_distance/p3)
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_distance_01
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_berserk ai_current_actor TRUE)
	(cs_go_to ps_wt_distance/p0)
	(cs_go_to ps_wt_distance/p1)
	(sleep 1)
	(cs_jump 33 6)
)

(script command_script cs_wt_distance_mar
	(units_set_current_vitality (ai_get_unit ai_current_actor) 20 0)
	(sleep 1)	
	(units_set_current_vitality (ai_get_unit ai_current_actor) 20 0)
)

(script command_script cs_wt_flood_look
	(cs_enable_moving TRUE)
	(ai_berserk ai_current_actor FALSE)
	(cs_face_player TRUE)
	(sleep (random_range 120 140) )
	
	(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
	(ai_play_line ai_current_actor 050MA_090)
	
	(cs_face_player FALSE)
	(set s_wt_flood_look (random_range 0 4))
	(cond 
		((= s_wt_flood_look 0)
			(cs_go_to ps_wt_distance/p2)
		)
		((= s_wt_flood_look 1)
			(cs_go_to ps_wt_distance/p4)
		)
		((= s_wt_flood_look 2)
			(cs_go_to ps_wt_distance/p5)
		)
		((= s_wt_flood_look 3)
			(cs_go_to ps_wt_distance/p6)
		)
		((= s_wt_flood_look 4)
			(cs_go_to ps_wt_distance/p7)
		)
	)								
	(cs_go_to ps_wt_distance/p3)
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_alley01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
		
	(cs_aim TRUE ps_wt_alley/p4)
	(cs_go_to ps_wt_alley/p0)
	
	(sleep_until (>= g_wt_obj_control 8) 5)
	
	(sleep (random_range 150 165) )
	
	(cs_aim FALSE ps_wt_alley/p4)
	(cs_go_to ps_wt_alley/p1)
	
	(set b_wt_alley 1)
	
	(sleep 60)
	
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_alley02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	
	(sleep (random_range 30 45) )
		
	(cs_aim TRUE ps_wt_alley/p4)
	(cs_go_to ps_wt_alley/p2)
	
	(sleep_until (>= g_wt_obj_control 8) 5)
	
	(sleep (random_range 120 135) )
		
	(cs_go_to ps_wt_alley/p3)
	
	(set b_wt_alley 1)
	
	(sleep 60)
	
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_alley_flood_01
	(sleep 150)
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_berserk ai_current_actor TRUE)
	(cs_go_to ps_wt_alley/p5)
	(ai_erase ai_current_actor)
)

(script command_script cs_wt_alley_flood_02
	(sleep 165)
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_berserk ai_current_actor TRUE)
	(cs_go_to ps_wt_alley/p6)
	(ai_erase ai_current_actor)
)

(script command_script cs_wt_rooftop01
	(cs_enable_pathfinding_failsafe TRUE)
	(unit_set_current_vitality (ai_get_unit sq_wt_roof_flood01/01) 20 0)
	(ai_disregard (ai_get_object sq_wt_roof_flood01/01) TRUE)
	
	(wake sc_wt_rooftop_impulse)
	(wake sc_wt_rooftop_skull_attach)

	(cs_go_to ps_wt_rooftop/p0 0.25)
	(sleep 10)
	(cs_jump 60 7.25)
	(sleep_forever sc_wt_rooftop_impulse)
	(wake sc_wt_rooftop_impulse02)
		
	(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
	(ai_play_line ai_current_actor 050MA_090)
	
	(cs_go_to ps_wt_rooftop/p1)	
	
	(ai_kill ai_current_actor)
)

(script dormant sc_wt_rooftop_skull_attach
	(sleep_until
		(begin
			;(print "attaching")
			(objects_attach (ai_get_object sq_wt_roof_flood01/01) right_hand skull_fog right_hand)
			;(print "detaching")
			(objects_detach sq_wt_roof_flood01/01 skull_fog)			
		(<= (ai_living_count sq_wt_roof_flood01/01) 0))
	1)
)

(script dormant sc_wt_rooftop_impulse
	(sleep_until (<= (ai_living_count sq_wt_roof_flood01/01) 0) 1)
		;(print "set velocity")
		(object_set_velocity skull_fog -4 0 0)
)

(script dormant sc_wt_rooftop_impulse02
	(sleep_until (<= (ai_living_count sq_wt_roof_flood01/01) 0) 1)
		;(print "set velocity")
		(object_set_velocity skull_fog 0 0 0)
)

(script command_script cs_wt_rooftop02
	(cs_enable_pathfinding_failsafe TRUE)
	
	(sleep 60)
	
	(cs_go_to ps_wt_rooftop/p2)
	(cs_jump 40 7)	
	
	(cs_go_to ps_wt_rooftop/p3)	
	
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_rooftop03
	(cs_enable_pathfinding_failsafe TRUE)
	
	(sleep 60)
	
	(cs_go_to ps_wt_rooftop/p4)
	(cs_jump 50 7)	
	
	(cs_go_to ps_wt_rooftop/p5)	
	
	(ai_kill ai_current_actor)
)

(script command_script cs_wt_combat_roofjump
	(sleep (random_range 0 30))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(ai_berserk ai_current_actor TRUE)
	(cs_jump 50 5)
)

(script command_script cs_wt_combat_street
	(sleep (random_range 0 30))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(ai_berserk ai_current_actor TRUE)
	(cs_move_in_direction 0 29 0)
	(cs_jump 60 6)
)

(script command_script cs_wt_infection_swarm
	(cs_swarm_to ps_wt/attractor01 2)
)

(script command_script cs_wt_infection_swarm02
	(cs_swarm_to ps_wt/attractor02 2)
)

(script command_script cs_wt_mar_fodder01
	(sleep_until (>= g_wt_obj_control 12))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_wt/mar01)
	(cs_action ps_wt/mar01_dive ai_action_dive_forward)
		(sleep 90)
	(biped_morph ai_current_actor)
)

(script command_script cs_wt_mar_fodder02
	(sleep_until (>= g_wt_obj_control 12))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_force_combat_status 3)
	(cs_action ps_wt/mar02_dive ai_action_dive_right)
		(sleep 90)
	(biped_morph ai_current_actor)
)

;=====================================================================
;==========WAREHOUSE==================================================
;=====================================================================
(global object o_morph_marine NONE)

(script command_script cs_wh_infection_swarm
	(cs_swarm_to ps_wh/attractor01 2)
)

(script command_script cs_wh_infection_swarm02
	(cs_swarm_to ps_wh/attractor02 0.5)
)

(script command_script cs_wh_infection_swarm03
	(cs_swarm_to ps_wh/attractor03 2)
)

(script command_script cs_wh_infection_swarm04
	(begin_random
		(cs_swarm_to ps_wh/attractor04 2)
		(cs_swarm_to ps_wh/attractor05 2)
		(cs_swarm_to ps_wh/attractor06 2)
	)
)

(script command_script cs_wh_infection_swarm05
	(cs_swarm_to ps_wh/attractor07 2)
)

(script command_script cs_wh_infection_swarm06
	(cs_swarm_to ps_wh/attractor08 2)
)

(script command_script cs_wh_infection_swarm07
	(cs_swarm_to ps_wh/attractor09 2)
)

(script dormant sc_wh_flame_infection_disperse
	(sleep_until (<= (ai_living_count sq_wh_sec_mar_flame/flame) 0) 1 300)
		(ai_flood_disperse sq_wh_sec_inf04 obj_wh_flood/main_gate)
		(print "disperse")
		(biped_morph (ai_get_object sq_wh_sec_mar_flame/flame))
)

(script command_script cs_wh_flood_berserk
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(ai_berserk ai_current_actor TRUE)
	(sleep 120)
	(ai_berserk ai_current_actor FALSE)
)

(script command_script cs_wh_marine_infect
	;(sleep 15)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_dialogue true)
	(set o_morph_marine sq_wh_init_mar_doomed/doomed)
	(units_set_current_vitality ai_current_actor 50 0)
	
	(cs_go_to ps_wh/mar01)
	(cs_go_to ps_wh/mar02)
	(cs_face TRUE ps_wh/mar01)
	;(ai_cannot_die sq_wh_init_mar_doomed/doomed TRUE)
	(sleep_until (= (ai_living_count sq_wh_init_inf02) 0) 1 120)
	
	(if (>= (ai_living_count sq_wh_init_inf02) 1)
		(biped_morph o_morph_marine)
	)
	;(ai_cannot_die sq_wh_init_mar_doomed/doomed FALSE)

)

(script command_script cs_wh_flame_thrower
	(cs_shoot_point TRUE ps_wh/flame_01)	

	(units_set_current_vitality ai_current_actor 20 0)
	(sleep_until (>= g_wh_obj_control 8) 1 450)
	(if (>= (ai_living_count sq_wh_sec_mar_flame/flame) 1)
		(begin
			(ai_place sq_wh_sec_inf04)
			(wake sc_wh_flame_infection_disperse)
			(ai_kill sq_wh_sec_mar_flame/flame)
		)
	)
)

(script command_script cs_wh_carrier
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (volume_test_object tv_wh_carrier (ai_get_object ai_current_actor)) 5)
		(ai_kill ai_current_actor)
)

; ==========TransA=======================================================================

(script dormant vs_ta_marine_no_no
	(sleep_until	(or
					(and
						(>= g_ta_obj_control 1)
						(<= (ai_living_count obj_ta_flood) 0)
					)
					(>= g_ta_obj_control 3)
				)
	)

	(if debug (print "vignette : warehouse : marine : no_no"))

		; placing allies 
		(ai_place sq_ta_marines_01)
		
		(sleep 1)

		; cast the actors
		(vs_cast sq_ta_marines_01 TRUE 5 "050MX_010")
			(set marine01 (vs_role 1))
		(vs_set_cleanup_script md_cleanup)
	(sleep 1)
	
	(vs_posture_set marine01 "act_cower_2" FALSE)
	
	(ai_dialogue_enable FALSE)	
	
		(if dialogue (print "MARINE: I didn't have a choice!"))
		(vs_play_line marine01 TRUE 050MX_010)
		(sleep 15)

		(if dialogue (print "MARINE: The el-tee, the sergeant... They were all infected!"))
		(vs_play_line marine01 TRUE 050MX_020)
		(sleep 90)

	(ai_dialogue_enable TRUE)

	(sleep_until (>= g_ta_obj_control 4))

	(ai_dialogue_enable FALSE)

	(if (<= g_ta_obj_control 6)
		(begin
			(if dialogue (print "MARINE: I could see it crawling -- sliding around beneath their skin!"))
			(vs_play_line marine01 TRUE 050MX_030)
			(sleep 15)
		)
	)

	(if (<= g_ta_obj_control 6)
		(begin
			(if dialogue (print "MARINE: Then they got up... Started to talk.  Oh, God!  Their voices!  Oh God... make it stop..."))
			(vs_play_line marine01 TRUE 050MX_040)
			(sleep 90)
		)
	)
	
	(if (<= g_ta_obj_control 6)
		(begin
			(if dialogue (print "MARINE: I did them a favor.  Yeah.  That's it.  I helped them!"))
			(vs_play_line marine01 TRUE 050MX_045)
			(sleep 90)
		)
	)

	(if (<= g_ta_obj_control 6)
		(begin
			(if dialogue (print "MARINE: Maybe I need to help myself... (breaks down)"))
			(vs_play_line marine01 TRUE 050MX_050)
		)
	)
	
	(vs_posture_set marine01 "act_cower_2" TRUE)
	
	(sleep_until (>= g_lb_obj_control 1) )
	
	(ai_dialogue_enable TRUE)	
	
)

;script to abort the crazy marine
(script dormant cs_ta_abort
	(sleep_until (>= g_lb_obj_control 1) 1)
		(cs_run_command_script marine01 cs_abort)
		(print "calling command script")
)

;script to abort the crazy marine
(script command_script cs_abort
	(print "aborting")
	(sleep 1)
	(cs_posture_set "act_cower_2" TRUE)	
	(sleep_until (>= g_lb_obj_control 6) )
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_fleet_arrival FALSE)
(global boolean g_elite_pods FALSE)

; main perspective thread 
(script dormant 050pb_fleet
	(sleep_until (>= g_lb_obj_control 2) 1)
	
	(if debug (print "perspective : lakebed b : elite_fleet"))

	; cast the actors 
	(if (not (game_is_cooperative))
			(begin
				(vs_cast gr_arbiter FALSE 10 "")
					(set arbiter (vs_role 1))
			)
	)
	(set obj_arbiter arbiter)
	
	(if (= (volume_test_object tv_lb_01 (player0)) 1)		
		(player_control_lock_gaze (player0) ps_lb/cruisers 45)
	)
	(if (= (volume_test_object tv_lb_01 (player1)) 1)			
		(player_control_lock_gaze (player1) ps_lb/cruisers 45)
	)
	(if (= (volume_test_object tv_lb_01 (player2)) 1)			
		(player_control_lock_gaze (player2) ps_lb/cruisers 45)
	)
	(if (= (volume_test_object tv_lb_01 (player3)) 1)		
		(player_control_lock_gaze (player3) ps_lb/cruisers 45)
	)

	; wake dialogue 
	(wake cs_lb_perpective_dialog)
		(sleep 15)

	; if the game starts at the beginning then call perspective_start otherwise... 
	(if (= (game_insertion_point_get) 0)
		(perspective_start)
		(begin
			(cinematic_snap_to_black)
				(sleep 1)
			; unhide players 
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
			(wake 050_music_03_start)
		)
	)
	
	; allows the perspective to be skipped 
	(cinematic_skip_start_internal)
	
		;kill crazy marine
		(ai_erase sq_ta_marines_01)
		
		;kill the lines of dialog
		(vs_stop_sound marine01 050MX_030_ma3)
		(vs_stop_sound marine01 050MX_040_ma3)
		(vs_stop_sound marine01 050MX_045_ma3)
		(vs_stop_sound marine01 050MX_050_ma3)
	
		; wake chapter title 
		(wake chapter_shadow)
		
		; camera animation 
		(set g_fleet_arrival TRUE)
		
		; camera animation 
		(050pb_elite_fleet)
		
		; cut to black 
		(fade_out 0 0 0 0)

		; set perspective_running false (used for chapter title letterboxes) 
		(set perspective_running FALSE)

	; teleporting players... to the proper location 
	(object_teleport (player0) player0_lb_start)
	(object_teleport (player1) player1_lb_start)
	(object_teleport (player2) player2_lb_start)
	(object_teleport (player3) player3_lb_start)
		(sleep 1)

		; set players pitch 
		(player0_set_pitch -14 0)
		(player1_set_pitch -14 0)
		(player2_set_pitch -14 0)
		(player3_set_pitch -14 0)


	(vs_teleport arbiter ps_lb/050pb_arb_teleport ps_lb/face)
	(ai_force_active arbiter TRUE)
	(vs_release gr_arbiter)
		(sleep 1)
	
		; if perspective ends cinematic_fade... 
		; if player skips while chapter title is up 
		; if player skips after chapter title is done  
		(if	(or
				perspective_finished
				chapter_finished
			)
			(cinematic_fade_to_gameplay)
			(perspective_skipped)
		)

	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)
	
	(if (= g_insertion_index 3)
		(wake obj_stop_spread_set)
	)
)

(script dormant cs_lb_perpective_dialog
	(ai_dialogue_enable FALSE)
	
	(print "Hail, humans, and take heed:")
	(sleep (ai_play_line_on_object none 050PA_010))
		(sleep 15)

	(print "This is the carrier, Shadow of Intent...")
	(sleep (ai_play_line_on_object none 050PA_020))
		(sleep 85)

	(print "Clear this sector...")
	(sleep (ai_play_line_on_object none 050PA_030))
		(sleep 5)

	(print "While we deal with the flood!")
	(sleep (ai_play_line_on_object none 050PA_040))

	(ai_dialogue_enable TRUE)
)

(script dormant vs_lb_fleet_arrival
	(if (= (campaign_metagame_enabled) TRUE)
		(sleep_until (>= g_lb_obj_control 2) 1)
		(sleep_until g_fleet_arrival 1)
	)
	(set g_elite_pods TRUE)
	;(sleep 45)
	(object_create_anew cov_cruiser_01)
	(object_create_anew cov_cruiser_02)
	(object_create_anew cov_capital_ship)
		(sleep 1)
	(object_set_always_active cov_cruiser_01 TRUE)
	(object_set_always_active cov_cruiser_02 TRUE)
	(object_set_always_active cov_capital_ship TRUE)
		(sleep 1)
	(scenery_animation_start cov_capital_ship objects\vehicles\cov_capital_ship\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_capital_ship1_1")
	(scenery_animation_start cov_cruiser_01 objects\vehicles\cov_cruiser\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_cov_cruiser1_1")
	(scenery_animation_start cov_cruiser_01 objects\vehicles\cov_cruiser\cinematics\perspectives\050pb_elite_fleet\050pb_elite_fleet "050pb_cin_cov_cruiser2_1")
)

(script static void test_lb_perspective
	(fade_out 0 0 0 0)
	(switch_zone_set set_lakebed_b)
	(ai_place sq_lb_arbiter)
	(sleep 10)
	(wake 050pb_fleet)
	(wake vs_lb_fleet_arrival)
	(wake ai_lb_elite_ins_pods)
	(set g_lb_obj_control 1)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; briefings  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant 050ba_back_into_voi
	(sleep_until (>= g_wt_obj_control 1))
	(sleep 270)
	
	(if debug (print "briefing : 050ba : back_into_voi"))

	(ai_dialogue_enable FALSE)

		(if dialogue (print "MIRANDA (radio): Chief, you know how bad this is."))
		(sleep (ai_play_line_on_object NONE 050BA_010))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Head back into town. Save the ones you can"))
		(sleep (ai_play_line_on_object NONE 050BA_020))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
;*
		(if dialogue (print "MIRANDA (radio): Kill the ones you can't."))
		(sleep (ai_play_line_on_object NONE 050BA_030))
*;
)

; ===================================================================================================================================================
(script dormant 050ba_flood_ship
	(sleep_until g_chapter_home)
		(sleep 60)

	(if debug (print "briefing : 050ba : flood_ship"))
;*
		(if dialogue (print "HOOD (radio): What's happening down there, Commander?!"))
		(sleep (ai_play_line_on_object NONE 050BB_010))
		(sleep 10)
*;

	(ai_dialogue_enable FALSE)

		(if dialogue (print "MIRANDA (radio): The Flood. It's spreading all over the city!"))
		(sleep (ai_play_line_on_object NONE 050BB_020))
		(sleep 10)

		(if dialogue (print "HOOD (radio): How do we contain it?"))
		(sleep (ai_play_line_on_object NONE 050BB_030))
		(sleep 10)
;*
		(if dialogue (print "MIRANDA (radio): We can't, sir. We need to wipe it out."))
		(sleep (ai_play_line_on_object NONE 050BB_040))
		(sleep 10)

		(if dialogue (print "HOOD (radio): What exactly are you suggesting, Commander?"))
		(sleep (ai_play_line_on_object NONE 050BB_050))
		(sleep 10)
*;
		(if dialogue (print "MIRANDA (radio): Find the crashed Flood ship. Overload its engine core."))
		(sleep (ai_play_line_on_object NONE 050BB_060))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): We either destroy this city or risk losing the entire planet."))
		(sleep (ai_play_line_on_object NONE 050BB_070))
		(sleep 10)

		(if dialogue (print "HOOD (radio): Do it. "))
		(sleep (ai_play_line_on_object NONE 050BB_080))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Chief? Make your way to the crash site"))
		(sleep (ai_play_line_on_object NONE 050BB_090))
		(sleep 10)
;*
		(if dialogue (print "MIRANDA (radio): I'm sorry. I wish there was another way."))
		(sleep (ai_play_line_on_object NONE 050BB_100))
		(sleep 10)
*;

	(ai_dialogue_enable TRUE)

		; set primary objective 
		(wake obj_stop_spread_set)

)

; ===================================================================================================================================================
(script dormant 050bb_cortana
	(sleep 60)

	(if debug (print "briefing : 050bb : cortana"))

	(ai_dialogue_enable FALSE)

		(if dialogue (print "MIRANDA (radio): Chief? The Elites are looking for something"))
		(sleep (ai_play_line_on_object NONE 050BC_010))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): We didn't believe them when they told us"))
		(sleep (ai_play_line_on_object NONE 050BC_020))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio): It's Cortana, Chief! She's on that ship!"))
		(sleep (ai_play_line_on_object NONE 050MX_060))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)

		
		;set second objective
		(wake obj_stop_spread_clear)
		(wake obj_cortana_set)
		
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; cortana moment  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_pa_cortana FALSE)
(global boolean g_pa_cortana_dialogue FALSE)

(script dormant cortana_warehouse

	(wake 050ca_transmission)
	
)

(script dormant cor_static
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_in 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 7))
	(fade_out 74 105 255 (random_range 7 12))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
)

(script static void hud_flicker_out
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 1 (real_random_range 0 0.05))
	(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
		(sleep (random_range 2 5))
	(chud_cinematic_fade 0 (real_random_range 0 0.05))
)



; =======================================================================================================================================================================
; =======================================================================================================================================================================
; gravemind channel   
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant fs_gravemind_01
	(sleep_until (volume_test_players tv_gravemind_01) 1)
	(if debug (print "gravemind_channel : flood_ship : salvation"))
	
	(wake 050_gr01_salvation)
)

; ===================================================================================================================================================

(script dormant fs_gravemind_02
	(sleep_until (volume_test_players tv_gravemind_02) 1)
	(if debug (print "mission_dialogue : factory_b : gravemind : timeless"))

	(wake 050_gr02_timeless)
	(wake 050_music_09_start)
)

; ===================================================================================================================================================

; =======================================================================================================================================================================
; ==========cortana channel
; =======================================================================================================================================================================
(script dormant sc_wh_cortana
	(sleep_until (volume_test_players tv_cortana_01) 1)
	(if debug (print "cortana_channel : warehouse"))	
	(wake 050ca_transmission)
)