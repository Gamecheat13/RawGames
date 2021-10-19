;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)
(global boolean g_player_training TRUE)

(global boolean debug FALSE)
(global boolean dialogue TRUE)

; insertion point index 
(global short g_insertion_index 0)

; objective control global shorts
(global short g_wt_obj_control 0)
(global short g_wh_obj_control 0)
(global short g_ta_obj_control 0)
(global short g_lb_obj_control 0)
(global short g_fb_obj_control 0)
(global short g_la_obj_control 0)
(global short g_fs_obj_control 0)

; starting player pitch 
(global short g_player_start_pitch -16)

(global boolean g_null FALSE)
		
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;================================MISSION SCRIPT===============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; if game is allowed to start do this 
	(cond
		((= (game_insertion_point_get) 0) (ins_workertown))
		((= (game_insertion_point_get) 1) (ins_lakebed_b))
	)
)

(script startup mission_floodvoi
	(if debug (print "welcome to the suck!!!!"))
	(print_difficulty)
	
	; snap to black 
	(fade_out 0 0 0 0)
	
	; pause the campaign metagame timer 
	(campaign_metagame_time_pause TRUE)
	
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	
	; wake global scripts 
	(wake gs_lock_doors)
	(wake gs_recycle_volumes)
	(wake gs_disposable_ai)
	(wake gs_award_primary_skull)
	
	;turns off the flame grenade icon
	(chud_show_fire_grenades FALSE)

	
	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		; if game is allowed to start do this 
		(start)
		
		; if the game is NOT allowed to start do this 
		(begin 
			(fade_in 0 0 0 0)
			(wake temp_camera_bounds_off)
		)
	)
	; === INSERTION POINT TEST =====================================================

		;==== begin workertown encounter (insertion 1) 
			(sleep_until (>= g_insertion_index 1) 1)
			(if (<= g_insertion_index 1) (wake enc_workertown))
		
		;==== begin warehouse encounters (insertion 2) 
			(sleep_until	(or
							(volume_test_players tv_enc_warehouse)
							(>= g_insertion_index 2)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 2) (wake enc_warehouse))
		
		;==== begin lakebed b encounters (insertion 3) 
			(sleep_until	(or
							(volume_test_players tv_enc_lakebed_b)
							(>= g_insertion_index 3)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 3) (wake enc_lakebed_b))
		
		;==== begin factory arm b encounters (insertion 4) 
			(sleep_until	(or
							(volume_test_players tv_enc_factory_arm_b)
							(>= g_insertion_index 4)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 4) (wake enc_factory_arm_b))

		;==== begin lakebed a encounters (insertion 5) 
			(sleep_until	(or
							(or	
								(volume_test_players tv_enc_lakebed_a_01)
								(volume_test_players tv_enc_lakebed_a_02)
							)
							(>= g_insertion_index 5)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 5) (wake enc_lakebed_a))
				
		;==== begin floodship encounters (insertion 6) 
			(sleep_until	(or
							(volume_test_players tv_enc_floodship)
							(>= g_insertion_index 6)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 6) (wake enc_floodship))
)



;====================================================================================================================================================================================================
;=====================================WORKERTOWN=====================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_workertown
	(data_mine_set_mission_segment "050_010_workertown")
	(if debug (print "enc_workertown"))
	
		; wake background threads 
		
		; wake mission dialgoue threads 
		(wake md_wt_arb_reminder)
		
		; wake vignette threads 
		(wake vs_wt_sarge_report_in)
		(wake vs_wt_realtime_infection)
		(wake vs_wt_marine_infected)
		
		; wake briefing threads 
		(wake 050ba_flood_ship)

		; un-pause the campaign metagame timer 
		(campaign_metagame_time_pause FALSE)
		
		; place ai script
		(wake sc_wt_ai_placement)
		
		;navpoint script
		(wake cs_wt_navpoint_start)
		
		;bring the noise
		(wake 050_music_01_start)

	(sleep_until (volume_test_players tv_wt_01) 1)
	(if debug (print "set objective control 1"))
		(set g_wt_obj_control 1)
		(game_save)

	(sleep_until (volume_test_players tv_wt_02) 1)
	(if debug (print "set objective control 2"))
		(wake sc_wt_distance)	

	(sleep_until (volume_test_players tv_wt_03) 1)
	(if debug (print "set objective control 3"))
		(set g_wt_obj_control 3)

	(sleep_until (volume_test_players tv_wt_04) 1)
	(if debug (print "set objective control 4"))
		(set g_wt_obj_control 4)

	(sleep_until (volume_test_players tv_wt_05) 1)
	(if debug (print "set objective control 5"))
		(set g_wt_obj_control 5)
		(game_save)
		
	(sleep_until (volume_test_players tv_wt_06) 1)
	(if debug (print "set objective control 6"))
		(set g_wt_obj_control 6)

	(sleep_until (volume_test_players tv_wt_07) 1)
	(if debug (print "set objective control 7"))
		(set g_wt_obj_control 7)
		(game_save)

	(sleep_until (volume_test_players tv_wt_08) 1)
	(if debug (print "set objective control 8"))
		(set g_wt_obj_control 8)

	(sleep_until (volume_test_players tv_wt_09) 1)
	(if debug (print "set objective control 9"))
		(set g_wt_obj_control 9)
		(game_save)

	(sleep_until (volume_test_players tv_wt_10) 1)
	(if debug (print "set objective control 10"))
		(set g_wt_obj_control 10)

	(sleep_until (volume_test_players tv_wt_11) 1)
	(if debug (print "set objective control 11"))
		(set g_wt_obj_control 11)
		
	(sleep_until (volume_test_players tv_wt_12) 1)
	(if debug (print "set objective control 12"))
		(set g_wt_obj_control 12)

	(sleep_until (volume_test_players tv_wt_13) 1)
	(if debug (print "set objective control 13"))
		(set g_wt_obj_control 13)
		(game_save)

	(sleep_until (volume_test_players tv_wt_14) 1)
	(if debug (print "set objective control 14"))
		(set g_wt_obj_control 14)
)

(global boolean g_wt_flood_placed FALSE)

;script to place the ai
(script dormant sc_wt_ai_placement
	(if (not (game_is_cooperative)) (ai_place sq_wt_arbiter))

	(sleep_until (>= g_wt_obj_control 6) 1)
		(ai_place sq_wt_roof_flood01)
		
	(sleep_until (>= g_wt_obj_control 7) 1)
		(ai_place sq_wt_alley_mar)
		
	(sleep_until (>= g_wt_obj_control 8) 1)
		(ai_place sq_wt_alley_flood)

	(sleep_until (>= g_wt_obj_control 9) 1)		
		(ai_place sq_wt_doomed_mar)
		(ai_place sq_wt_init_mar01)
	
	(sleep_until (>= g_wt_obj_control 12) 1)
	
	(sleep_until (= b_wt_spawn_a 1) 1 300)
		(ai_place sq_wt_init_inf01)
		(ai_place sq_wt_init_inf03)
		
		(if (>= (game_difficulty_get) heroic)
			(begin
				(ai_place sq_wt_second_flood02)
					(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
					(ai_play_line_on_object wt_combat04 050MA_090)
			)
			(begin
				(ai_place sq_wt_second_flood02 3)
					(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
					(ai_play_line_on_object wt_combat04 050MA_090)
			)		
			
		)
	
	(sleep 60)
		(ai_place sq_wt_init_inf02)
		
		(if (>= (game_difficulty_get) heroic)
			(ai_place sq_wt_second_flood03)
			(ai_place sq_wt_second_flood03 3)
		)
		
	(sleep 120)
		(ai_place sq_wt_second_flood01)
		(ai_place sq_wt_init_inf04)
		(wake sc_wt_disperse)

	; allow the arbiter to comment when the flood are near dead 
	(set g_wt_flood_placed TRUE)
		
					
)

;script to disperse the flood at the end of the encoutner
(script dormant sc_wt_disperse
	(sleep_until (<= (ai_task_count obj_wt_flood/main_gate) 5) 5)
		(print "***disperse!!!")
		(ai_flood_disperse gr_wt_flood obj_wh_flood)
		
		;wakes the navpoint script
		(wake cs_wt_navpoint_end)
)

;====================================================================================================================================================================================================
;=====================================WAREHOUSE======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_warehouse
	(data_mine_set_mission_segment "050_020_warehouse")
	(if debug (print "enc_warehouse"))
	
		; wake mission dialogue threads 
		(wake md_wh_marine_chews)
		(wake md_wh_arb_parasite)
		(wake vs_ta_marine_no_no)
		
		; wake corana channel 
		;(wake cortana_warehouse)

		; place ai
		(wake sc_wh_ai_placement_room_a)
		(wake sc_wh_ai_placement_room_b)
		
		(wake sc_wh_music_start)

	(sleep_until (volume_test_players tv_wh_01) 1)
	(if debug (print "set objective control 1"))
		(set g_wh_obj_control 1)
		(game_save)

		; migrate ai into proper objectives 
		(ai_set_objective gr_arbiter obj_wh_allies)
		(ai_set_objective gr_wt_marines obj_wh_allies)

	(sleep_until (volume_test_players tv_wh_02) 1)
	(if debug (print "set objective control 2"))
		(set g_wh_obj_control 2)
	
	(sleep_until (volume_test_players tv_wh_03) 1)
	(if debug (print "set objective control 3"))
		(set g_wh_obj_control 3)
		(game_save)
		
	(sleep_until (volume_test_players tv_wh_04) 1)
	(if debug (print "set objective control 4"))
		(set g_wh_obj_control 4)

	(sleep_until (volume_test_players tv_wh_05) 1)
	(if debug (print "set objective control 5"))
		(set g_wh_obj_control 5)
		(game_save)

	(sleep_until (volume_test_players tv_wh_06) 1)
	(if debug (print "set objective control 6"))
		(set g_wh_obj_control 6)
		(garbage_collect_now)
	
	(sleep_until (volume_test_players tv_wh_07) 1)
	(if debug (print "set objective control 7"))
		(set g_wh_obj_control 7)
		(game_save)
		
	(sleep_until (volume_test_players tv_wh_08) 1)
	(if debug (print "set objective control 8"))
		(set g_wh_obj_control 8)

	(sleep_until (volume_test_players tv_wh_09) 1)
	(if debug (print "set objective control 9"))
		(set g_wh_obj_control 9)
		(game_save)

	(sleep_until (volume_test_players tv_wh_10) 1)
	(if debug (print "set objective control 10"))
		(set g_wh_obj_control 10)
		(wake sc_wh_cortana)
		(wake sc_wh_music_stop)
	
	(sleep_until (volume_test_players tv_wh_11) 1)
	(if debug (print "set objective control 11"))
		(set g_wh_obj_control 11)
		(game_save)

	(sleep_until (volume_test_players tv_wh_12) 1)
	(if debug (print "set objective control 12"))
		(set g_wh_obj_control 12)
		(game_save)

	(sleep_until	(or
					(volume_test_players tv_wh_13a)
					(volume_test_players tv_wh_13b)
				)
	1)
	(if debug (print "set objective control 13"))
		(set g_wh_obj_control 13)
		(game_save)
		
		;fire up the nav point
		(wake cs_ta_navpoint_end)
	
	(sleep_until (volume_test_players tv_ta_01) 1)
	(if debug (print "set objective control 1"))
		(set g_ta_obj_control 1)

		(data_mine_set_mission_segment "050_025_trans_a")

		; migrate ai into proper objectives 
		(ai_set_objective gr_allies obj_ta_allies)
		(ai_place sq_ta_flood01)
		(ai_place sq_ta_flood02)
		(wake cs_ta_abort)
		
	(sleep_until (volume_test_players tv_ta_02) 1)
	(if debug (print "set objective control 2"))
		(set g_ta_obj_control 2)

	(sleep_until (volume_test_players tv_ta_03) 1)
	(if debug (print "set objective control 3"))
		(set g_ta_obj_control 3)
	
	(sleep_until (volume_test_players tv_ta_04) 1)
	(if debug (print "set objective control 4"))
		(set g_ta_obj_control 4)

	(sleep_until (volume_test_players tv_ta_05) 1)
	(if debug (print "set objective control 5"))
		(set g_ta_obj_control 5)
		(wake 050_music_03_start)

	(sleep_until (volume_test_players tv_ta_06) 1)
	(if debug (print "set objective control 6"))
		(set g_ta_obj_control 6)

	(sleep_until (volume_test_players tv_ta_07) 1)
	(if debug (print "set objective control 7"))
		(set g_ta_obj_control 7)
)

;place the ai in warehouse
(script dormant sc_wh_ai_placement_room_a
	(ai_place sq_wh_init_mar01)
	(ai_place sq_wh_init_mar02)
	
	(sleep 1)
		
	(ai_place sq_wh_init_flood01)
		(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
		(ai_play_line_on_object sq_wh_init_flood01 050MA_090)
	
	(sleep 1)
	
	(ai_place sq_wh_init_mar_doomed)
	(ai_place sq_wh_init_inf02)
	
	(if (>= (game_difficulty_get) heroic)
		(begin
			(ai_place sq_wh_init_inf01)
			(ai_place sq_wh_init_inf03)
		)
	)
	
	(sleep 1)
		
	(ai_place sq_wh_init_flood02)
	(ai_place sq_wh_init_flood03)	
		(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
		(ai_play_line_on_object sq_wh_init_flood02 050MA_090)
		(ai_play_line_on_object sq_wh_init_flood03 050MA_090)	

	(sleep_until (<= (ai_task_count obj_wh_flood/room_a_gate) 8) 5)
		(if (<= g_wh_obj_control 3)
			(begin
				(ai_place sq_wh_init_flood04)
				(ai_place sq_wh_init_flood05)		
				(ai_play_line_on_object sq_wh_init_flood04 050MA_090)
				(ai_play_line_on_object sq_wh_init_flood05 050MA_090)	
			)
		)			
	
	(sleep 10)
	
	(sleep_until (<= (ai_task_count obj_wh_flood/room_a_gate) 10) 5)
		(if (<= g_wh_obj_control 3)
			(begin
				(ai_place sq_wh_init_flood04 2)
				(ai_place sq_wh_init_flood05 2)
				(ai_play_line_on_object sq_wh_init_flood04 050MA_090)
				(ai_play_line_on_object sq_wh_init_flood05 050MA_090)	
			)
		)		
	
	(wake sc_wh_disperse_01)
)

;script to disperse the flood at the end of the warehouse room A encounter
(script dormant sc_wh_disperse_01
	(sleep_until (<= (ai_task_count obj_wh_flood/room_a_gate) 8) 5)
		(if (<= g_wh_obj_control 3) 
			(begin
				(print "***disperse!!!")
				(ai_flood_disperse gr_wh_flood obj_wh_flood)
				(wake cs_wh_navpoint_mid)
			)
		)
)

;place the ai in the second room of the warehouse
(script dormant sc_wh_ai_placement_room_b
	(sleep_until (>= g_wh_obj_control 6) 1)
		;(ai_place sq_wh_sec_car01)
		(ai_place sq_wh_sec_car02)
		;(ai_place sq_wh_sec_car03)
		(sleep 1)
		(ai_place sq_wh_sec_doomed)
		(ai_place sq_wh_sec_mar_flame)
		
		(if (<= (ai_task_count obj_wh_flood/main_gate) 12)
			(begin
				(ai_place sq_wh_sec_flood01)
				(ai_place sq_wh_sec_flood02)
				(ai_place sq_wh_sec_flood03)
			)
		)
		
	(sleep_until (= (volume_test_object tv_wh_marine (ai_get_object gr_allies)) 1) 1 300)
		(ai_place sq_wh_sec_inf03)

	(sleep_until (>= g_wh_obj_control 9) 1)
	(sleep 30)

	(wake sc_wh_disperse_02)

)

;script to disperse the flood at the end of the warehouse room C encounter
(script dormant sc_wh_disperse_02
	(sleep_until 
		(and
			(<= (ai_task_count obj_wh_flood/room_c_gate) 4) 
			(<= (ai_task_count obj_wh_flood/room_b_gate) 4)
		)
	5)
		(if (<= g_wh_obj_control 12) 
			(begin
				(print "***disperse!!!")
				(ai_flood_disperse gr_wh_flood obj_wh_flood)
				(wake cs_wh_navpoint_end)
			)
		)
)

;music script
(script dormant sc_wh_music_start
	(sleep_until 
		(or
			(= (ai_living_count sq_wh_init_mar_doomed/doomed) 0)
			(>= g_wh_obj_control 1)
		)
	)
	
	(wake 050_music_02_start)
)

;music stop
(script dormant sc_wh_music_stop
	(sleep_until (= (volume_test_players tv_wh_music) 1) 1)
		(wake 050_music_01_stop) 
		(wake 050_music_02_stop)
)

;====================================================================================================================================================================================================
;=====================================LAKEBED B======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_lakebed_b
	(data_mine_set_mission_segment "050_030_lakebed_b")
	(if debug (print "enc_lakebed_b"))

		; unlock this insertion point 
		(game_insertion_point_unlock 1)

		; migrate ai into proper objectives 
		(ai_set_objective gr_allies obj_lb_allies)
	
		; wake perspective threads 
		(wake 050pb_fleet)
		
		; wake vignette threads 
		(wake vs_lb_fleet_arrival)
				
		; wake mission dialogue threads 
		(wake md_lb_arb_my_brothers)

		; place elite insertion pods 
		(wake ai_lb_elite_ins_pods)
		
		; wake background threads 
		(wake ai_lb_combat_spawn)
		(wake sc_lb_flood_disperse)
		
		;wake the navpoint script
		(wake cs_lb_navpoint_start)
		
		;save game
		(game_save)

	(sleep_until (volume_test_players tv_lb_01) 1)
	(if debug (print "set objective control 1"))
		(set g_lb_obj_control 1)
		(game_save)

	(sleep_until (volume_test_players tv_lb_02) 1)
	(if debug (print "set objective control 2"))
		(set g_lb_obj_control 2)
		
	(sleep_until (volume_test_players tv_lb_03) 1)
	(if debug (print "set objective control 3"))
		(set g_lb_obj_control 3)
		(game_save)

	(sleep_until (volume_test_players tv_lb_04) 1)
	(if debug (print "set objective control 4"))
		(set g_lb_obj_control 4)
		(ai_dialogue_enable TRUE)			

	(sleep_until (volume_test_players tv_lb_05) 1)
	(if debug (print "set objective control 5"))
		(set g_lb_obj_control 5)
		(game_save)


	(sleep_until (volume_test_players tv_lb_06) 1)
	(if debug (print "set objective control 6"))
		(set g_lb_obj_control 6)

	(sleep_until (volume_test_players tv_lb_07) 1)
	(if debug (print "set objective control 7"))
		(set g_lb_obj_control 7)
		(game_save)

	(sleep_until (volume_test_players tv_lb_08) 1)
	(if debug (print "set objective control 8"))
		(set g_lb_obj_control 8)

	(sleep_until (volume_test_players tv_lb_09) 1)
	(if debug (print "set objective control 9"))
		(set g_lb_obj_control 9)
		(game_save)

	(sleep_until (volume_test_players tv_lb_10) 1)
	(if debug (print "set objective control 10"))
		(set g_lb_obj_control 10)
		(game_save)

)

;script to disperse the flood when the player gets down into the lakebed
(script dormant sc_lb_flood_disperse
	(sleep_until (>= g_lb_obj_control 5) 5)
		(print "***disperse")
		(ai_flood_disperse gr_flood obj_lb_flood)
		(sleep 5)
		(ai_flood_disperse gr_flood obj_lb_flood)
		(wake cs_lb_navpoint_end)
		(ai_bring_forward (ai_get_object gr_arbiter) 5)
)

;============================= LAKEBED B SECONDARY SCRIPTS =======================================================================================================================================
(script dormant ai_lb_combat_spawn

		(ai_place sq_lb_init_flood01)
		(ai_place sq_lb_init_flood02)
		(sleep 1)
		(ai_place sq_lb_init_flood03)
		(ai_place sq_lb_init_inf01)

	; wave 02 
	(sleep_until	(and
					(>= g_lb_obj_control 7)
					(<= (ai_task_count obj_lb_flood/gate_combat) 4)
				)
	)
		(if (<= (ai_task_count obj_lb_flood/gate_combat) 10)
			(begin
				(ai_place sq_lb_sec_flood01a)
				(ai_place sq_lb_sec_flood01b)
					(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
					(ai_play_line_on_object lb_combat_wv02a 050MA_090)
					(ai_play_line_on_object lb_combat_wv02b 050MA_090)
			)
		)

	; wave 03 
	(sleep_until	(or
					(>= g_lb_obj_control 8)
					(<= (ai_task_count obj_lb_flood/gate_combat) 4)
				)
	)
		(if (<= (ai_task_count obj_lb_flood/gate_combat) 10)
			(begin
				(ai_place sq_lb_sec_flood02a)
				(ai_place sq_lb_sec_flood02b)
					(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
					(ai_play_line_on_object lb_combat_wv03a 050MA_090)
					(ai_play_line_on_object lb_combat_wv03b 050MA_090)
				(ai_place sq_lb_sec_car01)
			)
		)

	; wave 04 
	(sleep_until	(or
					(>= g_lb_obj_control 9)
					(<= (ai_task_count obj_lb_flood/gate_combat) 4)
				)
	)
		(if (<= (ai_task_count obj_lb_flood/gate_combat) 10)
			(begin
				(ai_place sq_lb_sec_flood03)
					(if dialogue (print "FLOOD (radio, static): (unholy roar)"))
					(ai_play_line_on_object lb_combat_wv04a 050MA_090)
			)
		)
)

(script dormant ai_lb_elite_ins_pods
	(sleep_until g_elite_pods 1)
	(if (= (game_is_cooperative) 0)
		(begin_random
			(begin 
				(ai_place sq_lb_elites/elite01) 
				(ai_cannot_die sq_lb_elites/elite01 TRUE)
				(sleep (random_range 5 20))
			)
			(begin 
				(ai_place sq_lb_elites/elite02) 
				(ai_cannot_die sq_lb_elites/elite02 TRUE)
				(sleep (random_range 5 20))
			)
			(begin 
				(ai_place sq_lb_elites/elite03) 
				(ai_cannot_die sq_lb_elites/elite03 TRUE)
				(sleep (random_range 5 20))
			)
			(begin 
				(ai_place sq_lb_elites/elite04) 
				(ai_cannot_die sq_lb_elites/elite04 TRUE)
				(sleep (random_range 5 20))
			)
		)
		(begin 
			(ai_place sq_lb_elites/elite01) 
			(ai_cannot_die sq_lb_elites/elite01 TRUE)
			(sleep (random_range 5 20))
		)
	)
	(sleep (random_range 10 20))	
	(ai_place sq_lb_elites/commander)
	(ai_cannot_die sq_lb_elites/commander TRUE)
	
	(sleep 600)
	(ai_cannot_die gr_elites FALSE)
	
)

(script command_script cs_lb_ins_pod_comm
	(object_create_anew dm_ent_pod_commander)
		(sleep 1)
	(objects_attach dm_ent_pod_commander "pod_attach" (ai_vehicle_get sq_lb_elites/commander) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_commander 1)
	(sleep_until (>= (device_get_position dm_ent_pod_commander) 1) 1)
	
	(objects_detach dm_ent_pod_commander (ai_vehicle_get sq_lb_elites/commander))
	(object_destroy dm_ent_pod_commander)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/commander) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/commander)	
	(ai_cannot_die sq_lb_elites/commander FALSE)
		(sleep 60)
	(cs_action ps_lb/elite_face ai_action_berserk)
)

(script command_script cs_lb_ins_pod_elite01
	(object_create_anew dm_ent_pod_elite01)
		(sleep 1)
	(objects_attach dm_ent_pod_elite01 "pod_attach" (ai_vehicle_get sq_lb_elites/elite01) "pod_attach")
		(sleep 1)
	
	(device_set_position dm_ent_pod_elite01 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite01) 1) 1)
	
	(objects_detach dm_ent_pod_elite01 (ai_vehicle_get sq_lb_elites/elite01))
	(object_destroy dm_ent_pod_elite01)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite01) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite01)
	(ai_cannot_die sq_lb_elites/elite01 FALSE)
)

(script command_script cs_lb_ins_pod_elite02
	(object_create_anew dm_ent_pod_elite02)
		(sleep 1)
	(objects_attach dm_ent_pod_elite02 "pod_attach" (ai_vehicle_get sq_lb_elites/elite02) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite02 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite02) 1) 1)
	
	(objects_detach dm_ent_pod_elite02 (ai_vehicle_get sq_lb_elites/elite02))
	(object_destroy dm_ent_pod_elite02)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite02) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite02)
	(ai_cannot_die sq_lb_elites/elite02 FALSE)
)

(script command_script cs_lb_ins_pod_elite03
	(object_create_anew dm_ent_pod_elite03)
		(sleep 1)
	(objects_attach dm_ent_pod_elite03 "pod_attach" (ai_vehicle_get sq_lb_elites/elite03) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite03 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite03) 1) 1)
	
	(objects_detach dm_ent_pod_elite03 (ai_vehicle_get sq_lb_elites/elite03))
	(object_destroy dm_ent_pod_elite03)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite03) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite03)
	(ai_cannot_die sq_lb_elites/elite03 FALSE)
)

(script command_script cs_lb_ins_pod_elite04
	(object_create_anew dm_ent_pod_elite04)
		(sleep 1)
	(objects_attach dm_ent_pod_elite04 "pod_attach" (ai_vehicle_get sq_lb_elites/elite04) "pod_attach")
		(sleep 1)
	(device_set_position dm_ent_pod_elite04 1)
	(sleep_until (>= (device_get_position dm_ent_pod_elite04) 1) 1)
	
	(objects_detach dm_ent_pod_elite04 (ai_vehicle_get sq_lb_elites/elite04))
	(object_destroy dm_ent_pod_elite04)
		(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get sq_lb_elites/elite04) "door" 15)
		(sleep 15)
	(ai_vehicle_exit sq_lb_elites/elite04)
	(ai_cannot_die sq_lb_elites/elite04 FALSE)
)

(script command_script cs_lb_stalker_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	
	(sleep_until (>= g_lb_obj_control 3))
	(if (= (random_range 0 2) 0) (sleep (random_range 0 30)) (sleep (random_range 60 90)))
	(cs_go_to ps_lb_flood/stalker_delete)
	(ai_erase ai_current_actor)
)

(script command_script cs_lb_hold_carriers
	(sleep_until (>= g_lb_obj_control 2))
	(sleep_until (>= g_lb_obj_control 3) 30 (* 30 10))
)

(script command_script cs_lb_combat_jump
	(sleep (random_range 0 90))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
;	(ai_berserk ai_current_actor TRUE)
	(cs_jump 72 12.5)
)
(script command_script cs_lb_combat_jump_02
	(sleep (random_range 0 90))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
;	(ai_berserk ai_current_actor TRUE)
	(cs_jump 70.5 14.25)
)
(script command_script cs_lb_combat_roof
	(sleep (random_range 0 90))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
;	(ai_berserk ai_current_actor TRUE)
	(cs_move_in_direction 90 10 0)
)

;====================================================================================================================================================================================================
;=====================================FACTORY ARM B==================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_factory_arm_b

		; migrate ai into proper objectives 
		(ai_set_objective gr_allies obj_fb_allies)
		
		; wake mission dialogue threads 
		;(wake md_fb_elite_flood)
	
		;wake script to spawn flood
		(wake sc_fb_spawn)
	
	(data_mine_set_mission_segment "050_040_factory_arm_b")
	(if debug (print "enc_factory_arm_b"))

	(sleep_until (volume_test_players tv_fb_01) 1)
	(if debug (print "set objective control 1"))
	(set g_fb_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_fb_02) 1)
	(if debug (print "set objective control 2"))
	(set g_fb_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_fb_03) 1)
	(if debug (print "set objective control 3"))
	(set g_fb_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_fb_04) 1)
	(if debug (print "set objective control 4"))
	(set g_fb_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_fb_05) 1)
	(if debug (print "set objective control 5"))
	(set g_fb_obj_control 5)
	(wake cs_fb_navpoint_end)
	(game_save)

	(sleep_until (volume_test_players tv_fb_06) 1)
	(if debug (print "set objective control 6"))
	(set g_fb_obj_control 6)
	(game_save)

	(sleep_until (volume_test_players tv_fb_07) 1)
	(if debug (print "set objective control 7"))
	(set g_fb_obj_control 7)
	(wake sc_la_flood_spawn)
	(game_save)
	
)

;script to spawn the flood in the factory arm
(script dormant sc_fb_spawn
	(ai_place sq_fb_flood01)
	(ai_place sq_fb_flood02)
	(sleep 1)
	(ai_place sq_fb_flood02b)
	(ai_place sq_fb_flood03)
	(sleep 1)
	(ai_place sq_fb_flood03b)
	
	(sleep_until 
		(and
			(>= g_fb_obj_control 4)
			(<= (ai_task_count obj_fb_flood/main_gate) 4)
		)	
	1)
		(ai_place sq_fb_flood04)
		(ai_place sq_fb_flood05)
		
	(sleep_until (<= (ai_task_count obj_fb_flood/main_gate) 1) 1)
		(ai_place sq_fb_flood06)
		(ai_place sq_fb_flood07)
		(ai_place sq_fb_flood08)
		;(wake 050bb_cortana)
		
	(sleep_until 
		(and
			(= g_fb_obj_control 6)
			(<= (ai_task_count obj_fb_flood/main_gate) 4)
		)	
	1)
		(print "spawning !!!!!")
		;(ai_place sq_fb_flood09)
		;(ai_place sq_fb_flood10)
		;(ai_place sq_fb_flood11)
		;(ai_place sq_fb_flood12)
		(wake 050bb_cortana)		
		
)

;====================================================================================================================================================================================================
;=====================================LAKEBED A======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_lakebed_a

		; migrate ai into proper objectives 
		(ai_set_objective gr_allies obj_la_allies)
		(ai_set_objective gr_flood obj_la_flood)
		
		; wake mission dialogue 
		(wake md_la_elite_hurry)
		
		; place phantoms 
		(if (<= (ai_living_count gr_elites) 0) (ai_place sq_la_phantom_01))
		(ai_place sq_la_phantom_02)
		
		;wake up the disperse script
		(wake sc_la_flood_disperse)
		
		;place the ai
		(wake sc_la_combat_spawn)
		
		; wake briefings 
		;(wake 050bb_cortana)
		
		;set a variable to start the pureforms
		(set b_la_pureform 1)
		
		; start music 04 
		(wake 050_music_04_start)
		(wake sc_la_music_start)

	(data_mine_set_mission_segment "050_050_lakebed_a")
	(if debug (print "enc_lakebed_a"))

	(sleep_until	(or
					(volume_test_players tv_la_01a)
					(volume_test_players tv_la_01b)
					(volume_test_players tv_la_01c)
				)
	1)
	(if debug (print "set objective control 1"))
		(set g_la_obj_control 1)
		(wake 050_music_06_start)
		(wake 050_music_07_start)
	
	(sleep_until (volume_test_players tv_la_02) 1)
	(if debug (print "set objective control 2"))
		(set g_la_obj_control 2)
		(wake sc_la_mid_save01)

		;wake the navpoint
		(wake cs_fs_navpoint_entrance)
		

	(sleep_until (volume_test_players tv_la_03) 1)
	(if debug (print "set objective control 3"))
	(set g_la_obj_control 3)

	(sleep_until (volume_test_players tv_la_04) 1)
	(if debug (print "set objective control 4"))
		(set g_la_obj_control 4)	

	(sleep_until (volume_test_players tv_la_05) 1)
	(if debug (print "set objective control 5"))
		(set g_la_obj_control 5)

	(sleep_until (volume_test_players tv_la_06) 1)
	(if debug (print "set objective control 6"))
		(set g_la_obj_control 6)
		(wake sc_la_mid_save02)
	
	(sleep_until (volume_test_players tv_la_07) 1)
	(if debug (print "set objective control 7"))
		(set g_la_obj_control 7)
		(wake 050_music_04_stop)
		(wake 050_music_05_stop)
		(wake 050_music_06_stop)
		(wake 050_music_08_start)
		(wake md_la_arb_staybehind)
	
	(sleep_until (volume_test_players tv_la_08) 1)
	(if debug (print "set objective control 8"))
	(set g_la_obj_control 8)
	
	(sleep_until (volume_test_players tv_la_09) 1)
	(if debug (print "set objective control 9"))
	(set g_la_obj_control 9)
)

;music start
(script dormant sc_la_music_start
	(sleep_until
		(begin
				(player_action_test_reset)
				(sleep 1)
			(player_action_test_primary_trigger)
			(player_action_test_grenade_trigger)
			(player_action_test_melee)
		)
	1)
	(wake 050_music_05_start)
	(wake 050_music_04_start)
)

;midpoint save
(script dormant sc_la_mid_save01
	(sleep_until (game_safe_to_save) 1)
		(game_save)
)

;midpoint save
(script dormant sc_la_mid_save02
	(sleep_until (game_safe_to_save) 1)
		(game_save)
)

;place the dudes
(script dormant sc_la_flood_spawn
	(ai_place sq_la_pure01_01)
	(sleep 1)
	(ai_place sq_la_init_pure01)
	(ai_place sq_la_init_pure02)
	(sleep 1)
	(ai_place sq_la_init_pure03)
	(ai_place sq_la_init_pure04)
	(sleep 1)
	(ai_place sq_la_combat_01)
	(ai_place sq_la_combat_02)
	(sleep 1)
	(ai_place sq_la_combat_03)
	
	(sleep_until (>= g_la_obj_control 2) 1)
		(if (<= (ai_task_count obj_la_flood/pure_gate) 6)
			(begin
				(ai_place sq_la_pure02_01)
				;(ai_place sq_la_pure02_02)
			)
		)
		
	(sleep_until (>= g_la_obj_control 4) 1)
		(if (<= (ai_task_count obj_la_flood/pure_gate) 6)
			(begin
				(ai_place sq_la_pure04_01)
			)
		)	

	(sleep_until (>= g_la_obj_control 5) 1)	
		(if (<= (ai_task_count obj_la_flood/pure_gate) 6)
			(begin
				(ai_place sq_la_pure05_01)
				(ai_place sq_la_pure06_01)
				(ai_place sq_la_pure06_02)
			)
		)				
)

;add extra combat forms as needed
(script dormant sc_la_combat_spawn
	(sleep_until (>= g_la_obj_control 1) 1)
	(sleep_until (<= (ai_task_count obj_la_flood/combat_gate) 6) 1)
		(ai_place sq_la_combat_04)
		
	(sleep_until (>= g_la_obj_control 2) 1)		
	(sleep_until (<= (ai_task_count obj_la_flood/combat_gate) 6) 1)
		(ai_place sq_la_combat_05)
		
	(sleep_until (>= g_la_obj_control 4) 1)		
	(sleep_until (<= (ai_task_count obj_la_flood/combat_gate) 6) 1)
		(ai_place sq_la_combat_06)
)

;script to disperse the flood when the player finishes the encounter
(script dormant sc_la_flood_disperse
	(sleep_until 
		(and
			(>= g_la_obj_control 5) 
			(<= (ai_task_count obj_la_flood/main_gate) 5)
		)
	5)
		(print "***disperse")
		(ai_flood_disperse gr_la_flood obj_la_flood)
)

;============================= LAKEBED A SECONDARY SCRIPTS =======================================================================================================================================
(global boolean g_la_ini_pure_release FALSE)
(global boolean g_la_briefing_over FALSE)
(global boolean g_la_phantom_01_drop FALSE)
(global boolean b_la_pureform 0)

(global vehicle la_phantom_01 NONE)
(global vehicle la_phantom_02 NONE)

(script command_script cs_la_phantom_01
	(set la_phantom_01 (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom))

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to ps_la_phantom/ph01_03)
	(cs_fly_to ps_la_phantom/ph01_04)
	(cs_fly_to_and_face ps_la_phantom/ph01_05 ps_la_phantom/ph01_look)
	(cs_face TRUE ps_la_phantom/ph01_look)
		(sleep (random_range 30 45))
	(cs_fly_to ps_la_phantom/ph01_drop 1)
		(sleep (random_range 30 45))

	(ai_place sq_la_elites_01)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) "phantom_pc" (ai_actors sq_la_elites_01))

	(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) "phantom_pc_1")
	(sleep (random_range 45 60))
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) "phantom_pc_2")
	(sleep (random_range 45 60))
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) "phantom_pc_3")
	(sleep (random_range 60 75))
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) "phantom_pc_4")

	(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_la_phantom_01/phantom) FALSE)

		(sleep (random_range 60 90))
	(set g_la_phantom_01_drop TRUE)
	
	(cs_fly_to ps_la_phantom/ph01_05 1)
		
	(cs_face FALSE ps_la_phantom/ph01_look)
		(sleep (random_range 60 90))
		(set g_la_ini_pure_release TRUE)
	(cs_fly_to ps_la_phantom/ph01_04)
	(cs_fly_to ps_la_phantom/ph01_03)
	(cs_fly_to ps_la_phantom/ph01_02)
	(cs_fly_to ps_la_phantom/ph01_01)
	(cs_fly_to ps_la_phantom/ph_erase)
	(ai_erase ai_current_squad)
)
(script command_script cs_la_phantom_02
	(set la_phantom_02 (ai_vehicle_get_from_starting_location sq_la_phantom_02/phantom))

		(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to ps_la_phantom/ph02_03)
	(cs_fly_to ps_la_phantom/ph02_04)
	(cs_fly_to ps_la_phantom/ph02_05)
	(cs_fly_to_and_face ps_la_phantom/ph02_06 ps_la_phantom/ph02_look)
	(cs_face TRUE ps_la_phantom/ph02_look)
		(sleep (random_range 30 60))
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_la_phantom_02/phantom) TRUE)
		(sleep 30)
	
	(ai_dump_via_phantom sq_la_phantom_02/phantom sq_la_elites_02)

		(sleep (random_range 60 90))
	(cs_face FALSE ps_la_phantom/ph02_look)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_la_phantom_02/phantom) TRUE)
	
	(cs_fly_to ps_la_phantom/ph02_04)
	(cs_fly_to ps_la_phantom/ph02_03)
	(cs_fly_to ps_la_phantom/ph02_02)
	(cs_fly_to ps_la_phantom/ph02_01)
	(cs_fly_to ps_la_phantom/ph_erase)
	(ai_erase ai_current_squad)
)
(script command_script cs_la_elite_floodship
		(cs_enable_moving TRUE)
		(cs_enable_targeting TRUE)
		(cs_enable_pathfinding_failsafe TRUE)
	(sleep (random_range 300 390))
	(cs_go_to ps_la/elite_01)
	(cs_go_to ps_la/elite_02)
		(cs_enable_moving FALSE)
		(cs_enable_targeting FALSE)
		(cs_shoot TRUE)
	(cs_go_to ps_la/elite_03)
	(cs_jump_to_point 3 2.25)
	(sleep 45)
	(ai_erase ai_current_actor)
)	

(script command_script cs_la_roof_jump
	(sleep (random_range 0 90))
	(cs_jump 30 5)
)

(script command_script cs_la_pure_jump_a
		(sleep (random_range 0 90))
	;(ai_cannot_die ai_current_actor TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(cs_jump 68 25.25)
		(sleep 80)
	;(ai_cannot_die ai_current_actor FALSE)
)
(script command_script cs_la_pure_jump_b
		(sleep (random_range 0 90))
	;(ai_cannot_die ai_current_actor TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(cs_jump 70 23)
		(sleep 80)
	;(ai_cannot_die ai_current_actor FALSE)
)
(script command_script cs_la_pure_jump_c
		(sleep (random_range 0 90))
	;(ai_cannot_die ai_current_actor TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(cs_jump_to_point 8 5)
		(sleep 80)
	;(ai_cannot_die ai_current_actor FALSE)
)
(script command_script cs_la_pure_jump_d
		(sleep (random_range 0 90))
	;(ai_cannot_die ai_current_actor TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(cs_jump_to_point 4.25 10)
		(sleep 80)
	;(ai_cannot_die ai_current_actor FALSE)
)

(script command_script cs_la_combat_floodship
	(sleep (random_range 0 90))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 3)
	(ai_berserk ai_current_actor TRUE)
	(cs_jump_to_point 6 7)
)

;====================================================================================================================================================================================================
;=====================================FLOODSHIP======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_floodship
	; wake background threads 
;	(wake fs_cortana_flicker)

	; wake end mission thread 
	(wake 050_floodvoi_mission_won)
	
	(set g_fs_obj_control 1)
	
	; wake chapter title 
	(wake chapter_booger)
	
	; wake gravemind channel 
	(wake fs_gravemind_01)
	(wake fs_gravemind_02)
	
	;wake the music scripts
	(wake sc_fs_music)
	(wake sc_fs_music02)
	
	(set g_fs_obj_control 1)
	
	(game_save)
)

;script to start the music at the start of the floodship
(script dormant sc_fs_music
	(sleep_until (= (volume_test_players tv_enc_floodship) 1) 1)
		(wake 050_music_07_stop)
		(wake 050_music_08_stop)
		(wake 050_music_081_start)
)

;script to start the music in the middle of the floodship
(script dormant sc_fs_music02
	(sleep_until (= (volume_test_players tv_fs_music2) 1) 1)
		(wake 050_music_085_start)
)

;============================= FLOODHIP SECONDARY SCRIPTS =======================================================================================================================================
(global boolean g_cortana_flicker FALSE)

(script dormant fs_cortana_flicker
	(sleep_until
		(begin
			(object_create_anew cortana_light)
			(sleep (random_range 0 5))
			(object_destroy cortana_light)
			(random_range 0 5)
		g_cortana_flicker)
	)
	(object_destroy cortana_light)
)
	

;===================================== general scripts ==============================================================================================================================================
(script static void ai_marine_health_20
	(if debug (print "slam marines health"))
	(units_set_current_vitality (ai_actors gr_marines) 20 0)
		(sleep 1)
	(units_set_maximum_vitality (ai_actors gr_marines) 20 0)
)

(script static void ai_marine_health_50
	(if debug (print "slam marines health"))
	(units_set_current_vitality (ai_actors gr_marines) 50 0)
		(sleep 1)
	(units_set_maximum_vitality (ai_actors gr_marines) 50 0)
)

(script static void sleep_random
	(if debug (print "sleep random range"))
	(sleep (random_range 45 75))
)

(script command_script abort
	(ai_activity_abort ai_current_actor)
)

;====================================================================================================================================================================================================
;===============================SKULLS=========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_award_primary_skull
	(if (award_skull)
		(begin
			(object_create skull_fog)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
			
			(if debug (print "award fog skull"))
			(campaign_metagame_award_primary_skull (player0) 4)
			(campaign_metagame_award_primary_skull (player1) 4)
			(campaign_metagame_award_primary_skull (player2) 4)
			(campaign_metagame_award_primary_skull (player3) 4)
		)
	)
)

;====================================================================================================================================================================================================
;============================== AI DISPOSABLE SCRIPTS ===============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_disposable_ai
	(sleep_until (> g_wh_obj_control 0))
		(ai_disposable gr_wt_flood TRUE)
		(ai_disposable gr_wt_marines TRUE)
	
	(sleep_until (> g_lb_obj_control 0))
		(ai_disposable gr_wh_flood TRUE)
	
	(sleep_until (> g_fb_obj_control 0))
		(ai_disposable gr_lb_flood TRUE)

	(sleep_until (> g_la_obj_control 0))
		(ai_disposable gr_fb_flood TRUE)
	
	(sleep_until (> g_fs_obj_control 0))
		(ai_disposable gr_la_flood TRUE)
)

;====================================================================================================================================================================================================
;=============================== DOOR POSITIONS ======================================================================================================================================================
;====================================================================================================================================================================================================
(global short g_current_zone_set 100)
(global short g_current_zone_set_active 100)

(global boolean g_lock_doors_01 FALSE)
(global boolean g_lock_doors_02 FALSE)
(global boolean g_lock_doors_03 FALSE)
(global boolean g_lock_doors_04 FALSE)
(global boolean g_lock_doors_05 FALSE)
(global boolean g_lock_doors_06 FALSE)
(global boolean g_lock_doors_07 FALSE)

(script continuous gs_door_positions
	(sleep_until (!= (current_zone_set_fully_active) g_current_zone_set_active) 1)
	
	(cond
		; set_workertown 
		((= (current_zone_set_fully_active) 0)	(begin
											(if debug (print "zone set 1 doors"))
											(set g_lock_doors_01 TRUE)
											(gs_wt_doors)
											(gs_wh_doors)
										)
		)
		; set_warehouse 
		((= (current_zone_set_fully_active) 1)	(begin
											(if debug (print "zone set 2 doors"))
											(set g_lock_doors_02 TRUE)
											(gs_wt_doors)
											(gs_wh_doors)
											(gs_tr_doors)
										)
		)
		; set_trans_a 
		((= (current_zone_set_fully_active) 2)	(begin
											(if debug (print "zone set 3 doors"))
											(set g_lock_doors_03 TRUE)
											(gs_wt_doors)
											(gs_wh_doors)
											(gs_tr_doors)
											(gs_lb_doors)
										)
		)
		; set_lakebed_b 
		((= (current_zone_set_fully_active) 3)	(begin
											(if debug (print "zone set 4 doors"))
											(set g_lock_doors_04 TRUE)
											(gs_wh_doors)
											(gs_tr_doors)
											(gs_lb_doors)
											(gs_fb_doors)
											(gs_la_doors)
										)
		)
		; set_factory_arm_b 
		((= (current_zone_set_fully_active) 4)	(begin
											(if debug (print "zone set 5 doors"))
											(set g_lock_doors_05 TRUE)
											(gs_lb_doors)
											(gs_fb_doors)
											(gs_la_doors)
										)
		)
		; set_lakebed_a 
		((= (current_zone_set_fully_active) 5)	(begin
											(if debug (print "zone set 6 doors"))
											(set g_lock_doors_05 TRUE)
											(gs_fb_doors)
											(gs_la_doors)
										)
		)
		; set_flood_ship 
		((= (current_zone_set_fully_active) 6)	(begin
											(if debug (print "zone set 7 doors"))
											(set g_lock_doors_07 TRUE)
											(gs_fb_doors)
											(gs_la_doors)
										)
		)
		; set_all 
		((= (current_zone_set_fully_active) g_set_all)
										(begin
											(if debug (print "zone set all doors"))
											(gs_wt_doors)
											(gs_wh_doors)
											(gs_tr_doors)
											(gs_lb_doors)
											(gs_fb_doors)
											(gs_la_doors)
										)
		)
	)
	(set g_current_zone_set_active (current_zone_set_fully_active))
)

(script static void gs_wt_doors
	(if debug (print "worker town doors"))
	(device_set_position_immediate door_sm_wt01 0.875)
	(device_set_position_immediate door_lg_wt01 0.0)
)

(script static void gs_wh_doors
	(if debug (print "warehouse doors"))
	(device_set_position_immediate door_sm_wh01 1.0)
	(device_set_position_immediate door_sm_wh02 0.0)
	(device_set_position_immediate door_sm_wh03 0.0)
	(device_set_position_immediate door_sm_wh04 0.0)
	(device_set_position_immediate door_sm_wh05 0.0)
	(device_set_position_immediate door_sm_wh06 1.0)
	(device_set_position_immediate door_sm_wh07 1.0)
	(device_set_position_immediate door_sm_wh09 1.0)
	
	(device_set_position_immediate door_lg_wh01 0.0)
	(device_set_position_immediate door_lg_wh02 0.75)
	(device_set_position_immediate door_lg_wh03 0.85)
	(device_set_position_immediate door_lg_wh04 0.0)
	(device_set_position_immediate door_lg_wh05 0.0)
	(device_set_position_immediate door_lg_wh06 0.0)
)

(script static void gs_tr_doors
	(if debug (print "transition a doors"))
	(device_set_position_immediate door_sm_tr01 1.0)
	(device_set_position_immediate door_sm_tr02 1.0)
)

(script static void gs_lb_doors
	(if debug (print "lakebed b doors"))
)
	
(script static void gs_fb_doors 
	(if debug (print "factory arm b doors"))
	(device_set_position_immediate door_sm_ab01 1.0)
	(device_set_position_immediate door_sm_ab02 0.0)
	(device_set_position_immediate door_sm_ab03 0.0)
	(device_set_position_immediate door_sm_ab04 0.0)
	(device_set_position_immediate door_sm_ab05 1.0)
	(device_set_position_immediate door_sm_ab06 0.0)
	(device_set_position_immediate door_sm_ab07 0.0)
	(device_set_position_immediate door_sm_ab08 1.0)
	(device_set_position_immediate door_lg_ab02 0.85)
	(device_set_position_immediate door_lg_ab03 0.75)
	(device_set_position_immediate door_lg_ab04 0.0)
)

(script static void gs_la_doors
	(if debug (print "lakebed a doors"))
	(device_set_position_immediate door_lg_la01 0.0)
	(device_set_position_immediate door_lg_la02 0.0)	
)
	
(script static void gs_reset_door_variables
	(if debug (print "door variables reset"))
	(set g_lock_doors_01 FALSE)
	(set g_lock_doors_02 FALSE)
	(set g_lock_doors_03 FALSE)
	(set g_lock_doors_04 FALSE)
	(set g_lock_doors_05 FALSE)
	(set g_lock_doors_06 FALSE)
	(set g_lock_doors_07 FALSE)
)

(script dormant gs_lock_doors
	; if current zone set is a debug zone set then turn this script off 
	(if (>= (current_zone_set) 9) (sleep_forever))
	
	; set_workertown begins to load ====================================================
	(sleep_until (>= (current_zone_set) 0) 1)
	(if debug (print "set_workertown begins loading"))
		(device_set_position_immediate door_sm_wt02 0.75)

	; set_workertown fully active 
	(sleep_until (>= (current_zone_set_fully_active) 0) 1)
	(if debug (print "set_workertown fully active"))
		(device_set_position_immediate door_sm_wt02 0.75)

	; set_warehouse begins to load =====================================================
	(sleep_until (>= (current_zone_set) 1) 1)
	(if debug (print "set_warehouse begins loading"))
		(device_set_position_immediate door_sm_wt02 0.75)

	; set_warehouse fully active 
	(sleep_until (>= (current_zone_set_fully_active) 1) 1)
	(if debug (print "set_warehouse fully active"))
		;(device_set_position_immediate door_sm_wh08 1.0)
		(device_set_position_immediate door_sm_lb01 0.0)

	; set_trans_a begins to load =======================================================
	(sleep_until (>= (current_zone_set) 2) 1)
	(if debug (print "set_trans_a begins loading"))
		(device_set_position_immediate door_sm_wt02 0.0)
		;(device_set_position_immediate door_sm_wh08 1.0)
		(device_set_position_immediate door_sm_lb01 0.0)
		(device_set_position_immediate door_sm_tr03 1.0)	

		(zone_set_trigger_volume_enable zone_set:set_warehouse FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_warehouse FALSE)
			(object_destroy_folder bp_workertown)
			(object_destroy_folder sc_workertown)
			(object_destroy_folder cr_workertown)

	; set_trans_a fully active 
	(sleep_until (>= (current_zone_set_fully_active) 2) 1)
	(if debug (print "set_trans_a fully active"))

	; set_lakebed_b begins to load =====================================================
	(sleep_until (>= (current_zone_set) 3) 1)
	(if debug (print "set_lakebed_b begins loading"))
		(device_set_position_immediate door_sm_lb01 0.0)
		(device_set_position_immediate door_sm_tr03 0.0)

		(zone_set_trigger_volume_enable zone_set:set_trans_a FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_trans_a FALSE)
			(object_destroy_folder bp_warehouse)
			(object_destroy_folder sc_warehouse)
			(object_destroy_folder cr_warehouse)
	
	; set_lakebed_b fully active 
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	(if debug (print "set_lakebed_b fully active"))
		(device_set_position_immediate door_sm_lb01 1.0)
		(device_set_position_immediate door_lg_ab01 0.85)
		(device_set_position_immediate door_lg_ab05 0.0)

	; set_factory_arm_b begins to load =================================================
	(sleep_until (>= (current_zone_set) 4) 1)
	(if debug (print "set_factory_arm_b begins loading"))
		(device_set_position_immediate door_sm_lb01 0.0)
		(device_set_position_immediate door_lg_ab01 0.85)
		(device_set_position_immediate door_lg_ab05 0.0)

		(zone_set_trigger_volume_enable zone_set:set_lakebed_b FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_lakebed_b FALSE)
			(object_destroy_folder sc_trans_a)
			(object_destroy_folder cr_trans_a)
	
	; set_factory_arm_b fully active 
	(sleep_until (>= (current_zone_set_fully_active) 4) 1)
	(if debug (print "set_factory_arm_b fully active"))

	; set_lakebed_a begins to load =====================================================
	(sleep_until (>= (current_zone_set) 5) 1)
	(if debug (print "set_lakebed_a begins loading"))
		(device_set_position_immediate door_lg_ab01 0.0)

		(zone_set_trigger_volume_enable zone_set:set_factory_arm_b FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_factory_arm_b FALSE)
			(object_destroy_folder sc_lakebed_b)
			(object_destroy_folder cr_lakebed_b)
	
	; set_lakebed_a fully active 
	(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	(if debug (print "set_lakebed_a fully active"))
		(device_set_position_immediate door_lg_ab05 0.65)

	; set_flood_ship begins to load ===================================================
	(sleep_until (>= (current_zone_set) 6) 1)
	(if debug (print "set_flood_ship begins loading"))
		(device_set_position_immediate door_lg_ab05 0.0)

		(zone_set_trigger_volume_enable zone_set:set_lakebed_a FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_lakebed_a FALSE)
			(object_destroy_folder cr_factory_arm_b)

	; set_flood_ship fully active 
	(sleep_until (>= (current_zone_set_fully_active) 6) 1)
	(if debug (print "set_flood_ship fully active"))

	; set_cin_outro begins to load ===================================================
	(sleep_until (>= (current_zone_set) 7) 1)
	(if debug (print "set_flood_ship begins loading"))
		(object_create_anew floodship_blocker)

		(zone_set_trigger_volume_enable zone_set:set_flood_ship FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_flood_ship FALSE)
			(object_destroy_folder cr_lakebed_a)
			(object_destroy_folder sc_lakebed_a)

	; set_cin_outro fully active 
	(sleep_until (>= (current_zone_set_fully_active) 7) 1)
	(if debug (print "set_flood_ship fully active"))

		(zone_set_trigger_volume_enable zone_set:set_cin_outro FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_cin_outro FALSE)
)

(script static void gs_disable_zone_volumes
	(sleep 1)
)

;====================================================================================================================================================================================================
;=============================== CAMERA BOUNDS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant temp_camera_bounds_off
	(sleep 1)
)
	
;====================================================================================================================================================================================================
;=============================== LAKEBED KILL SCRIPTS ======================================================================================================================================================
;====================================================================================================================================================================================================

(script continuous gs_lb_kill_player
	(sleep_until (volume_test_players volume_lakebed_b) 1)
	(cond
		((volume_test_objects volume_lakebed_b (player0)) (unit_kill (unit (player0))))
		((volume_test_objects volume_lakebed_b (player1)) (unit_kill (unit (player1))))
		((volume_test_objects volume_lakebed_b (player2)) (unit_kill (unit (player2))))
		((volume_test_objects volume_lakebed_b (player3)) (unit_kill (unit (player3))))
	)
)

(script continuous gs_la_kill_player
	(sleep_until (volume_test_players volume_lakebed_a) 1)
	(cond
		((volume_test_objects volume_lakebed_a (player0)) (unit_kill (unit (player0))))
		((volume_test_objects volume_lakebed_a (player1)) (unit_kill (unit (player1))))
		((volume_test_objects volume_lakebed_a (player2)) (unit_kill (unit (player2))))
		((volume_test_objects volume_lakebed_a (player3)) (unit_kill (unit (player3))))
	)
)

;====================================================================================================================================================================================================
;=============================== RECYCLE VOLUME SCRIPTS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_recycle_volumes
	(sleep_until (>= g_wh_obj_control 1))
		(add_recycling_volume tv_rec_wt 0 30)

	(sleep_until (>= g_wh_obj_control 4))
		(add_recycling_volume tv_rec_wt 0 0)
		(add_recycling_volume tv_rec_wh_01 0 30)

	(sleep_until (>= g_wh_obj_control 7))
		(add_recycling_volume tv_rec_wh_01 0 0)
		
	(sleep_until (>= g_wh_obj_control 8))
		(add_recycling_volume tv_rec_wh_02 0 30)

	(sleep_until (>= g_wh_obj_control 12))
		(add_recycling_volume tv_rec_wh_02 0 0)
		(add_recycling_volume tv_rec_wh_03 0 30)

	(sleep_until (>= g_lb_obj_control 1))
		(add_recycling_volume tv_rec_wh_03 0 0)
		(add_recycling_volume tv_rec_wh_04 0 30)

	(sleep_until (>= g_lb_obj_control 4))
		(add_recycling_volume tv_rec_wh_04 0 0)
		(add_recycling_volume tv_rec_lb_01 0 30)

	(sleep_until (>= g_lb_obj_control 5))
		(add_recycling_volume tv_rec_lb_01 0 0)
		(add_recycling_volume tv_rec_lb_02 0 30)

	(sleep_until (>= g_lb_obj_control 7))
		(add_recycling_volume tv_rec_lb_02 0 0)
		(add_recycling_volume tv_rec_lb_03 0 30)

	(sleep_until (>= g_lb_obj_control 9))
		(add_recycling_volume tv_rec_lb_03 0 0)
		(add_recycling_volume tv_rec_lb_04 0 30)

	(sleep_until (>= g_fb_obj_control 2))
		(add_recycling_volume tv_rec_lb_04 0 0)

	(sleep_until (>= g_la_obj_control 1))
		(add_recycling_volume tv_rec_fb 0 30)

	(sleep_until (>= g_la_obj_control 3))
		(add_recycling_volume tv_rec_la_01 0 30)

	(sleep_until (>= g_la_obj_control 5))
		(add_recycling_volume tv_rec_la_01 0 0)
		(add_recycling_volume tv_rec_la_02 0 30)

	(sleep_until (>= g_la_obj_control 7))
		(add_recycling_volume tv_rec_la_02 0 0)
		(add_recycling_volume tv_rec_la_03 0 30)

	(sleep_until (>= g_fs_obj_control 1))
		(add_recycling_volume tv_rec_la_03 0 0)
)