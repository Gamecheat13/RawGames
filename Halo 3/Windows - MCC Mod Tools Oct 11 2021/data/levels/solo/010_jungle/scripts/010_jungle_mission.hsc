;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)
(global boolean g_player_training TRUE)

(global boolean debug FALSE)
(global boolean dialogue TRUE)
(global boolean music TRUE)

; insertion point index 
(global short g_insertion_index 0)

; objective control global shorts
(global short g_cc_obj_control 0)
(global short g_jw_obj_control 0)
(global short g_ta_obj_control 0)
(global short g_gc_obj_control 0)
(global short g_pa_obj_control 0)
(global short g_ss_obj_control 0)
(global short g_pb_obj_control 0)
(global short g_ba_obj_control 0)
(global short g_tb_obj_control 0)
(global short g_dam_obj_control 0)

; starting player pitch 
(global short g_player_start_pitch -16)

(global boolean g_null FALSE)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== JUNGLE MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
	(cond
		((= (game_insertion_point_get) 0) (ins_chief_crater))
		((= (game_insertion_point_get) 1) (ins_substation))
		((= (game_insertion_point_get) 2) (ins_brute_ambush))
	)
)

(script startup mission_jungle
	(if debug (print "you're in the jungle baby!!!!"))
	(print_difficulty)
	
	; snap to black 
	(fade_out 0 0 0 0)
	
	; pause metagame timer during cinematic  
	(campaign_metagame_time_pause TRUE)
	
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	
	; wake global scripts 
	(wake gs_camera_bounds)
	(wake gs_recycle_volumes)
	(wake gs_disposable_ai)
	
	; the AI can no longer drop grenades
	; this gets turned back on halfway through the substation encounter
	(if
		(and
			(<= (game_difficulty_get) normal)
			(= (game_is_cooperative) FALSE)
			(= (campaign_metagame_enabled) FALSE)
		)
		(ai_grenades FALSE)
	)
	
	; don't show the HUD for spike grenades and firebombs 
	(chud_show_spike_grenades FALSE)
	(chud_show_fire_grenades FALSE)


	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		; if game is allowed to start 
		(start)
		
		; if game is NOT allowed to start
		(begin 
			(fade_in 0 0 0 0)
;			(wake temp_camera_bounds_off)
		)
	)
	; === INSERTION POINT TEST =====================================================



		;==== begin chief's crater encounter (insertion 1) 
			(sleep_until (>= g_insertion_index 1) 1)
			(if (<= g_insertion_index 1) (wake enc_chief_crater))
		
		;==== begin jungle walk encounters (insertion 2) 
			(sleep_until	(or
							(volume_test_players tv_enc_jungle_walk)
							(>= g_insertion_index 2)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 2) (wake enc_jungle_walk))
			
		;==== begin grunt camp encounters (insertion 3) 
			(sleep_until	(or
							(volume_test_players tv_enc_grunt_camp)
							(>= g_insertion_index 3)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 3) (wake enc_grunt_camp))
		
		;==== begin path_a encounters (insertion 4) 
			(sleep_until	(or
							(volume_test_players tv_enc_path_a)
							(>= g_insertion_index 4)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 4) (wake enc_path_a))
		
		;==== begin sub-station encounters (insertion 5) 
			(sleep_until	(or
							(volume_test_players tv_enc_substation)
							(>= g_insertion_index 5)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 5) (wake enc_substation))
		
		;==== begin path_b encounters (insertion 6) 
			(sleep_until	(or
							(volume_test_players tv_enc_path_b)
							(>= g_insertion_index 6)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 6) (wake enc_path_b))
		
		;==== begin brute camp encounters (insertion 7) 
			(sleep_until	(or
							(volume_test_players tv_enc_brute_ambush)
							(>= g_insertion_index 7)
						)
			1)
				; wake encounter script 
			(if (<= g_insertion_index 7) (wake enc_brute_ambush))
		
		;==== begin dam encounters (insertion 8) 
			(sleep_until	(or
							(volume_test_players tv_enc_dam)
							(>= g_insertion_index 8)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 8) (wake enc_dam))
)

;====================================================================================================================================================================================================
;==================================== CHIEF CRATER ==================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_chief_crater
	(data_mine_set_mission_segment "010_10_chief_crater")
	(if debug (print "enc_chief_crater"))

		; place allies 
		(if debug (print "placing allies"))
		(ai_place sq_johnson_marines)
		
		(if (not (game_is_cooperative)) (ai_place sq_arbiter))
		(if (<= (game_coop_player_count) 2) (ai_place sq_marines))
		
		; wake global scripts 
		(wake gs_award_secondary_skull)

		; wake navigation point scripts 
		(wake nav_cc)
		
		; mission dialogue scripts 
		(wake md_cc_fade_in)
		(wake md_cc_johnson_move_out)
		(wake md_cc_johnson_reminder)
		(wake md_cc_joh_extract)
		(wake md_cc_brute_howl)
		(wake md_cc_bravo_advised)

		; wake vignettes
		
		; wake ai background threads 

		; wake music scripts 
		(wake music_010_01)
		(wake music_010_02)

		; wake training (jump) 
		(if	(and
				(<= (game_difficulty_get) heroic)
				(not (game_is_cooperative))
				(= (campaign_metagame_enabled) FALSE)
			)
			(wake 010tr_jump)
		)
		
		; set nav point global variable  
		(set g_nav_cc TRUE)
		
		; set arbiter deathless 
;		(ai_cannot_die gr_arbiter TRUE)
		
	(sleep_until (volume_test_players tv_cc_01) 1)
	(if debug (print "set objective control 1"))
	(set g_cc_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_cc_02) 1)
	(if debug (print "set objective control 2"))
	(set g_cc_obj_control 2)
	
	; player has jumped over the log 
	(sleep_until (volume_test_players tv_cc_03) 1)
	(if debug (print "set objective control 3"))
	(set g_cc_obj_control 3)
	(data_mine_set_mission_segment "010_11_chief_crater_path")
	
	(sleep_until (volume_test_players tv_cc_04) 1)
	(if debug (print "set objective control 4"))
	(set g_cc_obj_control 4)

	(sleep_until (volume_test_players tv_cc_05) 1)
	(if debug (print "set objective control 5"))
	(set g_cc_obj_control 5)
	
	(sleep_until (volume_test_players tv_cc_06) 1)
	(if debug (print "set objective control 6"))
	(set g_cc_obj_control 6)

	(sleep_until (volume_test_players tv_cc_07) 1)
	(if debug (print "set objective control 7"))
	(set g_cc_obj_control 7)

	(sleep_until (volume_test_players tv_cc_08) 1)
	(if debug (print "set objective control 8"))
	(set g_cc_obj_control 8)

		; start music 01 
		(set g_music_010_01 TRUE)
				
	(sleep_until (volume_test_players tv_cc_09) 1)
	(if debug (print "set objective control 9"))
	(set g_cc_obj_control 9)

	(sleep_until (volume_test_players tv_cc_10) 1)
	(if debug (print "set objective control 10"))
	(set g_cc_obj_control 10)
	(game_save)

		; migrate marines into the current encounter
		(if debug (print "migrate allies into the current encounter"))
		(ai_set_objective gr_marines obj_jw_upper_allies)
		(ai_set_objective gr_arbiter obj_jw_upper_allies)

	(sleep_until (volume_test_players tv_cc_11) 1)
	(if debug (print "set objective control 11"))
	(set g_cc_obj_control 11)

		; start music 02 
		(set g_music_010_02 TRUE)
)

;============================= chief crater secondary scripts =======================================================================================================================================
(script command_script cs_cc_banshee01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 2)
	(cs_fly_by ps_cc_banshee/banshee01_01)
	(cs_fly_by ps_cc_banshee/banshee01_02)
	(cs_fly_by ps_cc_banshee/banshee01_03)
	(ai_erase ai_current_squad)
)

(script command_script cs_cc_banshee02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 2)
	(cs_fly_by ps_cc_banshee/banshee02_01)
	(cs_fly_by ps_cc_banshee/banshee02_02)
	(cs_fly_by ps_cc_banshee/banshee02_03)
	(ai_erase ai_current_squad)
)

(script command_script cs_cc_arbiter_jump
		(sleep (random_range 30 45))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_and_face ps_cc/arb_jump01 ps_cc/arb_jump02)
	(cs_face TRUE ps_cc/arb_jump02)
	(cs_jump_to_point 1.5 1)
	(cs_face FALSE ps_cc/arb_jump02)
)

;====================================================================================================================================================================================================
;==================================== JUNGLE WALK ===================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_jungle_walk
	(data_mine_set_mission_segment "010_20_jungle_walk")
	(if debug (print "enc_jungle_walk"))
	(game_save)
		
		; migrate marines into the current encounter
		(if debug (print "migrate allies into the current encounter"))
		(ai_set_objective gr_allies obj_jw_upper_allies)

		; wake navigation point scripts 
		(wake nav_jw)
		
		; wake background threads 
		(wake ai_jw_lower_cov_reins)
		(wake jw_out_of_bounds)

		; wake mission dialogue 
		(wake md_jw_mar_brute)
		(wake md_jw_mar_power_armor)
		(wake md_jw_arb_prophets)
		(wake md_jw_river)
		(wake md_jw_phantoms)
		(wake md_jw_post_combat)
		
		; wake vignettes 
		(wake vs_jw_joh_phantom)
		(wake vs_jw_brute_squad)
		
		; wake perspective 
;		(wake 010pa_brute_chieftain)
		
		; wake music scripts 
		(wake music_010_03)
		(wake music_010_04)

	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_01) 1)
	(if debug (print "set objective control 1"))
	(set g_jw_obj_control 1)

	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_02) 1)
	(if debug (print "set objective control 2"))
	(set g_jw_obj_control 2)

	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_03) 1)
	(if debug (print "set objective control 3"))
	(set g_jw_obj_control 3)

		; spawn upper phantom 
		(ai_place sq_jw_phantom_01)
		(ai_place sq_jw_phantom_05)

		; spawn upper encounter covenant  
		(if debug (print "placing upper covenant"))
		(ai_place sq_jw_u_cov_01)
		(if (>= (game_difficulty_get) heroic) (ai_place sq_jw_u_grunts_01))

		; set brute as an object 
		(sleep 1)
		(set dead_brute sq_jw_u_cov_01/brute)
		(ai_disregard (ai_get_object sq_jw_phantom_05) TRUE)
		
	; this will time out if player doesn't progress
	(sleep_until (volume_test_players tv_jw_04) 1)
	(if debug (print "set objective control 4"))
	(set g_jw_obj_control 4)
	(game_save)
	(data_mine_set_mission_segment "010_21_jungle_walk_upper")

		; throttle back up player input 
		(player_control_scale_all_input 1.0 60)

		; start music 03 
		(set g_music_010_03 TRUE)

	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_05))
	(if debug (print "set objective control 5"))
	(set g_jw_obj_control 5)
	
	; player moving through encounter 
	(sleep_until	(or
					(volume_test_players tv_jw_06a)
					(volume_test_players tv_jw_06b)
				)
	 1)
	(if debug (print "set objective control 6"))
	(set g_jw_obj_control 6)
	(game_save)

	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_07) 1)
	(if debug (print "set objective control 7"))
	(set g_jw_obj_control 7)
	(game_save)
	
	; player moving through encounter 
	(sleep_until (volume_test_players tv_jw_08) 1)
	(if debug (print "set objective control 8"))
	(set g_jw_obj_control 8)
	(data_mine_set_mission_segment "010_22_jungle_walk_lower")
		
		; place phantoms 
		(ai_place sq_jw_phantom_02)
		(ai_place sq_jw_phantom_04)

	(sleep_until (volume_test_players tv_jw_09) 1)
	(if debug (print "set objective control 9"))
	(set g_jw_obj_control 9)
	(game_save)

		; set the current objectives 
		(ai_set_objective gr_allies obj_jw_lower_allies)
		(ai_set_objective gr_jw_upper_cov obj_jw_lower_covenant)

		; set nav point global variable  
		(set g_nav_jw TRUE)
		
		; start music 04 
		(set g_music_010_04 TRUE)

	(sleep_until (volume_test_players tv_jw_10) 1)
	(if debug (print "set objective control 10"))
	(set g_jw_obj_control 10)
	(game_save)

			; stop music 01 
			(set g_music_010_01 FALSE)

			; stop music 02 
			(set g_music_010_02 FALSE)

			; stop music 03 
			(set g_music_010_03 FALSE)

	(sleep_until (volume_test_players tv_jw_11) 1)
	(if debug (print "set objective control 11"))
	(set g_jw_obj_control 11)
	(game_save)
	
	(sleep_until (volume_test_players tv_jw_12) 1)
	(if debug (print "set objective control 12"))
	(set g_jw_obj_control 12)
	(game_save)
	
	; ========== TRANSITION A OBJECTIVE CONTROL =========
	
	(sleep_until (volume_test_players tv_ta_01) 1)
	(if debug (print "set objective control 1"))
	(set g_ta_obj_control 1)
	(data_mine_set_mission_segment "010_23_jungle_walk_trans")

		; set ally objective 
		(ai_set_objective gr_allies obj_ta_allies)

	(sleep_until (volume_test_players tv_ta_02) 1)
	(if debug (print "set objective control 2"))
	(set g_ta_obj_control 2)
	(game_save)
	
	(sleep_until (volume_test_players tv_ta_03) 1)
	(if debug (print "set objective control 3"))
	(set g_ta_obj_control 3)
	
	(sleep_until (volume_test_players tv_ta_04) 1)
	(if debug (print "set objective control 4"))
	(set g_ta_obj_control 4)
	
	(sleep_until (volume_test_players tv_ta_05) 1)
	(if debug (print "set objective control 5"))
	(set g_ta_obj_control 5)
	
	(sleep_until (volume_test_players tv_ta_06) 1)
	(if debug (print "set objective control 6"))
	(set g_ta_obj_control 6)
)

;============================== jungle walk secondary scripts ========================================================================================================================================
(script command_script cs_jw_phantom_01
	(if debug (print "jungle walk phantom 01"))
	(set jw_phantom_01 (ai_vehicle_get_from_starting_location sq_jw_phantom_01/phantom))
		(sleep 120)
	(cs_enable_pathfinding_failsafe TRUE)
	
	(cs_vehicle_speed .85)
	(ai_disregard jw_phantom_01 TRUE)
	(cs_fly_by ps_jw_phantom/p0)
	(cs_fly_by ps_jw_phantom/p1)
	(cs_fly_by ps_jw_phantom/p2)
	(cs_fly_by ps_jw_phantom/p3)
	(cs_fly_by ps_jw_phantom/p4)
	(cs_fly_by ps_jw_phantom/p5)
	(cs_fly_by ps_jw_phantom/p6)
	(cs_fly_by ps_jw_phantom/p7)
	(cs_fly_by ps_jw_phantom/p8)

	(ai_erase ai_current_squad)
)

(script command_script cs_jw_phantom_02
	(if debug (print "jungle walk phantom 02"))
	(set jw_phantom_02 (ai_vehicle_get_from_starting_location sq_jw_phantom_02/phantom))

		; place initial covenant 
		(if debug (print "placing lower covenant"))
		(if (>= (game_difficulty_get) heroic) (ai_place sq_jw_l_cov_01))
		(ai_place sq_jw_l_cov_02)
		(ai_place sq_jw_l_grunts_01)
			(sleep 30)
	(ai_vehicle_enter_immediate sq_jw_l_cov_01 jw_phantom_02 "phantom_p_ml_f")
	(ai_vehicle_enter_immediate sq_jw_l_cov_02 jw_phantom_02 "phantom_p_lb")
	(ai_vehicle_enter_immediate sq_jw_l_grunts_01 jw_phantom_02 "phantom_p_lf")
	
		; disable the chin gun on easy and normal 
		(if (<= (game_difficulty_get) normal)
			(begin
				(cs_shoot FALSE)
				(cs_enable_targeting FALSE)
				(cs_enable_looking FALSE)
			)
		)

		(sleep 1)
	(custom_animation_relative jw_phantom_02 objects\vehicles\phantom\cinematics\vignettes\010pb_chieftain_phantom\010pb_chieftain_phantom "010pb_chieftain_phantoma_arrival" FALSE jw_phantom_anchor)
		(sleep 1)
	(sleep (unit_get_custom_animation_time jw_phantom_02))
	(unit_stop_custom_animation jw_phantom_02)
		(sleep 1)
	(cs_fly_to ps_jw_phantom/ph01_hover)
	(vehicle_hover jw_phantom_02 TRUE)

		(begin_random
			(begin
				(vehicle_unload jw_phantom_02 "phantom_p_lf")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload jw_phantom_02 "phantom_p_lb")
				(sleep (random_range 5 15))
			)
		)
		(sleep 45)
		(begin_random
			(begin
				(vehicle_unload jw_phantom_02 "phantom_p_ml_f")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload jw_phantom_02 "phantom_p_ml_b")
				(sleep (random_range 5 15))
			)
		)
		
	(cs_run_command_script sq_jw_l_cov_01 cs_jw_lower_cov_reins)

	(set g_jw_phantom_02_drop TRUE)
		(sleep (* 30 15))
	(cs_enable_pathfinding_failsafe TRUE)
	(vehicle_hover jw_phantom_02 FALSE)
	(cs_fly_to ps_jw_phantom/ph01_lift 2)
	(cs_face TRUE ps_jw_phantom/ph01_look)
	(cs_vehicle_speed .5)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	
	(cond
		((<= (game_difficulty_get) normal)	(sleep (random_range 30 45)))
		((>= (game_difficulty_get) heroic)	(sleep_until	(or
													(<= (ai_task_count obj_jw_lower_covenant/phantom) 4)
													(<= (ai_task_count obj_jw_lower_covenant/infantry_gate) 8)
													(>= g_jw_obj_control 11)
												)
									)
		)
	)

	(cs_face FALSE ps_jw_phantom/ph01_look)
	(cs_fly_by ps_jw_phantom/p7)
	(cs_fly_by ps_jw_phantom/p8)
	(ai_erase ai_current_squad)
)

; phantom flying in the background 
(script command_script cs_jw_phantom_03
	(if debug (print "phantom 03"))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 5.0)

	(cs_fly_by ps_jw_phantom/p8)
	
	(ai_erase ai_current_squad)
)

(script command_script cs_jw_phantom_04
	(if debug (print "jungle walk phantom 04"))
	(set jw_phantom_04 (ai_vehicle_get_from_starting_location sq_jw_phantom_04/phantom))
	(cs_enable_pathfinding_failsafe TRUE)
	
		(ai_place sq_jw_l_cov_03)
		(ai_place sq_jw_l_grunts_02)
		(if (>= (game_difficulty_get) heroic) (ai_place sq_jw_l_grunts_03))
			(sleep 30)
		(ai_vehicle_enter_immediate sq_jw_l_cov_03 jw_phantom_04 "phantom_p_rf")
		(ai_vehicle_enter_immediate sq_jw_l_grunts_02 jw_phantom_04 "phantom_p_rb")
		(ai_vehicle_enter_immediate sq_jw_l_grunts_03 jw_phantom_04 "phantom_p_lb")

		; disable the chin gun on easy and normal 
		(if (<= (game_difficulty_get) normal)
			(begin
				(cs_shoot FALSE)
				(cs_enable_targeting FALSE)
				(cs_enable_looking FALSE)
			)
		)

			(sleep 1)
	(custom_animation_relative jw_phantom_04 objects\vehicles\phantom\cinematics\vignettes\010pb_chieftain_phantom\010pb_chieftain_phantom "010pb_chieftain_phantomb_arrival" FALSE jw_phantom04_anchor)
		(sleep 1)
		(sleep (unit_get_custom_animation_time jw_phantom_04))
	(unit_stop_custom_animation jw_phantom_04)
	(vehicle_hover jw_phantom_04 TRUE)
	
			; stop music 01 
			(set g_music_010_01 FALSE)

			; stop music 02 
			(set g_music_010_02 FALSE)

			; stop music 03 
			(set g_music_010_03 FALSE)

			; start music 04 
			(set g_music_010_04 TRUE)

		(begin_random
			(begin
				(vehicle_unload jw_phantom_04 "phantom_p_rf")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload jw_phantom_04 "phantom_p_rb")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload jw_phantom_04 "phantom_p_lb")
				(sleep (random_range 5 15))
			)
		)
		(sleep 30)
		
		(cs_run_command_script sq_jw_l_cov_03/grunt01 cs_jw_grunt_deploy_01)
		(cs_run_command_script sq_jw_l_cov_03/grunt02 cs_jw_grunt_deploy_02)
		
		(sleep 90)
	(unit_close jw_phantom_04)
		(sleep (random_range 120 150))
	(vehicle_hover jw_phantom_04 FALSE)
	(cs_fly_to_and_face ps_jw_phantom/ph04_hover ps_jw_phantom/ph04_face 2)
	(vehicle_hover jw_phantom_04 TRUE)
	
	(cond
		((<= (game_difficulty_get) normal) (sleep 1))
		((>= (game_difficulty_get) heroic) (sleep (random_range 300 450)))
	)

	(vehicle_hover jw_phantom_04 FALSE)
	(cs_vehicle_speed 0.9)
	(cs_fly_to ps_jw_phantom/ph04_01)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_jw_phantom/p7)
	(cs_fly_by ps_jw_phantom/p8)
	
	(ai_erase ai_current_squad)
)

(script command_script cs_jw_phantom_05
	(if debug (print "jungle walk phantom 05"))
	(cs_enable_pathfinding_failsafe TRUE)
	(set jw_phantom_05 (ai_vehicle_get_from_starting_location sq_jw_phantom_05/phantom))
	(sleep 1)
	(ai_disregard jw_phantom_05 TRUE)

	(cs_fly_by ps_jw_phantom/ph02_00)
	(cs_fly_by ps_jw_phantom/ph02_01)
		(ai_set_blind sq_jw_phantom_05 FALSE)
		(ai_set_deaf sq_jw_phantom_05 FALSE)
	(cs_fly_by ps_jw_phantom/ph02_02)
	(cs_fly_by ps_jw_phantom/ph02_03)
	(cs_fly_by ps_jw_phantom/ph02_04)
	(cs_fly_by ps_jw_phantom/ph02_05)
	(cs_fly_by ps_jw_phantom/ph02_06)
	(ai_erase ai_current_squad)
)

; controls the brute/grunt squad dropped from the phantom 
(script dormant ai_jw_lower_cov_reins
	(sleep_until	(or
					(and
						g_jw_phantom_02_drop
						(<= (ai_living_count sq_jw_l_cov_02/brute) 0)
					)
					(and
						g_jw_phantom_02_drop
						(<= (ai_task_count obj_jw_lower_covenant/infantry_gate) 10)
					)
					(and
						g_jw_phantom_02_drop
						(>= g_jw_obj_control 10)
						(<= (ai_task_count obj_jw_lower_covenant/infantry_gate) 14)
					)
					(and
						g_jw_phantom_02_drop
						(>= g_jw_obj_control 11)
						(<= (ai_task_count obj_jw_lower_covenant/infantry_gate) 18)
					)
					(>= g_jw_obj_control 12)
				)
	5)
	
	; releases covenant from their command script 
	(if debug (print "releasing covenant reinforcements"))
	(cs_run_command_script gr_jw_lower_cov abort)
	(ai_force_active gr_jw_lower_cov TRUE)
)

; holds the brute/grunt squad in the background until needed 
(script command_script cs_jw_lower_cov_reins
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_and_face ps_jt_a/jw_hold ps_jw_phantom/p5)
	(sleep_until g_null)
)

(script command_script  cs_jw_berserk_brute
		(cs_enable_moving TRUE)
		(cs_enable_targeting TRUE)		
	(sleep (random_range 30 60))
	(ai_berserk ai_current_actor TRUE)
	(ai_prefer_target_ai obj_jw_upper_covenant/brute_00 gr_marines TRUE)
	(ai_prefer_target_ai obj_jw_lower_covenant/brute_01 gr_marines TRUE)
	(ai_prefer_target_ai obj_jw_lower_covenant/brute_02 gr_marines TRUE)
)

(script command_script cs_jw_grunt_deploy_01
	(sleep 120)
		(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw_lower/grunt01)
	(cs_equipment ps_jw_lower/cover01)
)
(script command_script cs_jw_grunt_deploy_02
	(sleep 120)
		(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to ps_jw_lower/grunt02)
	(cs_equipment ps_jw_lower/cover02)
)

(script dormant jw_out_of_bounds
	(sleep_until	
		(begin
			(sleep_until	(or
							(volume_test_players tv_jw_out_of_bounds)
							(>= g_gc_obj_control 1)
						)
			)
			(cond
				((volume_test_object tv_jw_out_of_bounds (player0)) (unit_kill (unit (player0))))
				((volume_test_object tv_jw_out_of_bounds (player1)) (unit_kill (unit (player1))))
				((volume_test_object tv_jw_out_of_bounds (player2)) (unit_kill (unit (player2))))
				((volume_test_object tv_jw_out_of_bounds (player3)) (unit_kill (unit (player3))))
			)
		(>= g_gc_obj_control 1))
	)
)
		
			
			
;====================================================================================================================================================================================================
;==================================== GRUNT CAMP ====================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_grunt_camp
	(data_mine_set_mission_segment "010_30_grunt_camp")
	(if debug (print "enc_grunt_camp"))
	(game_save)
	
		; wake navigation point scripts 
		(wake nav_gc)
		
		; create carbine crate 
		(if (>= (game_difficulty_get) heroic) (object_create_anew_containing cr_gc_carbines))
		
		; wake background threads 
		(wake ai_gc_activate_grunts)
		(wake ai_gc_cov_reinforcements)
		(wake ai_gc_jackal_spawn)
	
		; mission dialogue scripts 
		(wake md_gc_mar_sleepers)
		(if (>= (game_difficulty_get) heroic) (wake md_gc_mar_jackals))
		(wake md_gc_joh_enroute)
		(wake md_gc_post_combat)

		; wake music scripts 
		(wake music_010_05)
		
		; place initial enemies
		(if debug (print "placing initial covenant"))
	
		(ai_place sq_gc_cov_01)
		(ai_place sq_gc_grunt_01)
		(ai_place sq_gc_grunt_02)
		(ai_place sq_gc_grunt_03)
	
		(if (>= (game_difficulty_get) heroic)
			(begin
				(ai_place sq_gc_cov_03)
				(ai_place sq_gc_jackal_01)
			)
		)

		(sleep 1)
		(ai_set_blind sq_gc_grunt_01/sleeper TRUE)
		(ai_disregard (ai_get_object sq_gc_grunt_01/sleeper) TRUE)
		(ai_prefer_target_ai gr_allies gr_gc_cov_infantry TRUE)

	(sleep_until (volume_test_players tv_gc_ini_01) 5)
	(ai_set_objective gr_allies obj_gc_allies)
	
	; player moves down to the ravine floor
	(sleep_until	(or
					(volume_test_players tv_gc_01)
					(>= (ai_combat_status obj_gc_covenant) 4)
				)
	5)
	(if debug (print "set objective control 1"))
	(set g_gc_obj_control 1)
	(game_save)

		; stop music 04 
		(set g_music_010_04 FALSE)

	; player moves towards the river (marines go to the opposite side) 
	(sleep_until (or (volume_test_players tv_gc_02) (volume_test_players tv_gc_03)) 5)
	(cond
		((volume_test_players tv_gc_02) (begin (set g_gc_obj_control 2) (if debug (print "set objective control 2"))))
		((volume_test_players tv_gc_03) (begin (set g_gc_obj_control 3) (if debug (print "set objective control 3"))))
		(TRUE (begin (set g_gc_obj_control 2) (if debug (print "set objective control 2"))))
	)
	(game_save)

	; player crosses the river (marines go to the opposite side)
	(sleep_until (or (volume_test_players tv_gc_04) (volume_test_players tv_gc_05)) 5)
	(cond
		((volume_test_players tv_gc_04) (begin (set g_gc_obj_control 4) (if debug (print "set objective control 4"))))
		((volume_test_players tv_gc_05) (begin (set g_gc_obj_control 5) (if debug (print "set objective control 5"))))
		(TRUE (begin (set g_gc_obj_control 5) (if debug (print "set objective control 5"))))
	)
	(game_save)
	(data_mine_set_mission_segment "010_31_grunt_camp_mid")
		
		; allies will no longer only prefer the infantry targets 
		(ai_prefer_target_ai gr_allies gr_gc_cov_infantry FALSE)

	; player moves to exit the ravine 
	(sleep_until	(or
					(volume_test_players tv_gc_06a)
					(volume_test_players tv_gc_06b)
					(volume_test_players tv_gc_06c)
				)
	5)
	(if debug (print "set objective control 6"))
	(set g_gc_obj_control 6)
	(game_save)
	(data_mine_set_mission_segment "010_32_grunt_camp_ledge")

		; set nav point global variable  
		(set g_nav_gc TRUE)
		
	; player moves to exit the ravine 
	(sleep_until	(or
					(volume_test_players tv_gc_07a)
					(volume_test_players tv_gc_07b)
				)
	5)
	(if debug (print "set objective control 7"))
	(set g_gc_obj_control 7)
	(game_save)
)

;============================== grunt camp secondary scripts ========================================================================================================================================

(global short g_gc_phantom 0)

; looks at the allies and covenant and aborts any command scripts being run by your allies
(script dormant ai_gc_activate_grunts
	(sleep_until	(or 
					(>= g_gc_obj_control 1)
					(>= (ai_combat_status gr_marines) ai_combat_status_dangerous)
					(>= (ai_combat_status gr_gc_covenant) ai_combat_status_dangerous)
				)
	)
	(ai_set_blind sq_gc_grunt_01/sleeper FALSE)
	(ai_disregard (ai_get_object sq_gc_grunt_01/sleeper) FALSE)
)

; grunt camp covenant reinforcements
(script dormant ai_gc_cov_reinforcements
	; sleep until the player moves up to the next front or kills all but 2 of the covenant
	(sleep_until	(or
					(>= g_gc_obj_control 4)
					(and
						(<= (ai_living_count gr_gc_covenant) 10)
						(>= g_gc_obj_control 1)
					)
				)
	)
	
	(if debug (print "testing conditions for reinforcements 01"))
	(if (<= (ai_living_count gr_gc_cov_infantry) 10)	(begin
											(ai_place sq_gc_cov_rein_01)
											(ai_place sq_gc_grunt_rein_01)
											(if debug (print "spawning covenant reins")))
										(if debug (print "no covenant"))
	)
	(if (<= (ai_living_count gr_gc_jackals) 3)	(begin
											(ai_place sq_gc_jackal_rein_01)
											(if debug (print "spawning jackal reins")))
										(if debug (print "no jackals"))
	)
)


(global boolean g_gc_jackal_spawn TRUE)
(global short g_gc_jackal_limit 0)
(global short g_gc_jackal_count 0)

(script dormant ai_gc_jackal_spawn
	(cond
		((= (game_difficulty_get) normal) (set g_gc_jackal_spawn FALSE))
		((= (game_difficulty_get) heroic) (set g_gc_jackal_limit 2))
		((= (game_difficulty_get) legendary) (set g_gc_jackal_limit 4))
	)
	(sleep 1)
	(begin_random
		(if g_gc_jackal_spawn (ai_gc_jackal sq_gc_jackal_02))
		(if g_gc_jackal_spawn (ai_gc_jackal sq_gc_jackal_03))
		(if g_gc_jackal_spawn (ai_gc_jackal sq_gc_jackal_04))
		(if g_gc_jackal_spawn (ai_gc_jackal sq_gc_jackal_05))
	)
)

(script static void (ai_gc_jackal (ai spawned_squad))
	(ai_place spawned_squad)
	(set g_gc_jackal_count (+ g_gc_jackal_count 1))
	(if (= g_gc_jackal_limit g_gc_jackal_count) (set g_gc_jackal_spawn FALSE))
)


;====================================================================================================================================================================================================
;===================================== PATH A =======================================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_path_a
	(data_mine_set_mission_segment "010_40_path_a")
	(if debug (print "enc_path_a"))
	(game_save)
		
		; wake navigation point scripts 
		(wake nav_pa)
		
		; put allies in their proper objective
		(ai_set_objective gr_allies obj_pa_allies)
		(if debug (print "set ally objective"))
	
		; mission dialogue scripts 
		(wake md_pa_joh_company)
		(wake md_pa_post_combat)
		(wake md_pa_mar_chief_ok)
		
		;wake vignette scripts 
		(wake vs_pa_brute_slam)
		
		; wake cortana channel 
		(wake cor_path_a)

		; wake music scripts 
		(wake music_010_06)
		(wake pa_music_start)

			; place initial enemies
			(if debug (print "placing initial covenant"))
			(ai_place sq_pa_cov_01)
			(if (>= (game_difficulty_get) heroic) (ai_place sq_pa_grunt_01))
			(if (>= (game_difficulty_get) heroic)
				(begin
					(ai_place sq_pa_jackal_01)
					(ai_place sq_pa_jackal_02)
				)
			)
	
			; placing vignette marine 
			(ai_place sq_pa_vs_marines)
			(ai_disregard (ai_actors sq_pa_vs_marines) TRUE)
			(sleep 1)

		; allies will not prefer to fight jackals 
		(ai_prefer_target_ai gr_allies gr_pa_cov_infantry TRUE)

		; start music 05 
		(set g_music_010_05 TRUE)

	; player rounds the corner in the space  
	(sleep_until (volume_test_players tv_pa_01))
	(set g_pa_obj_control 1)
	(if debug (print "set objective control 1"))
	(game_save)

	(sleep_until (volume_test_players tv_pa_02))
	(set g_pa_obj_control 2)
	(if debug (print "set objective control 2"))
	(game_save)

	; player moves across the fallen tree bridge  
	(sleep_until (volume_test_players tv_pa_03))
	(set g_pa_obj_control 3)
	(if debug (print "set objective control 3"))
	(game_save)
	(data_mine_set_mission_segment "010_41_path_a_upper")

		; place reinforcements 
		(ai_place sq_pa_cov_02)
		(ai_place sq_pa_jackal_03)
		(if (>= (game_difficulty_get) heroic) (ai_place sq_pa_grunt_02))

		; set nav point global variable  
		(set g_nav_pa TRUE)
		
		; allies can now prefer jackals 
		(ai_prefer_target_ai gr_allies gr_pa_cov_infantry FALSE)

	; player enters the exit cave  
	(sleep_until (volume_test_players tv_pa_04))
	(set g_pa_obj_control 4)
	(if debug (print "set objective control 4"))

		; start music 06 
		(set g_music_010_06 TRUE)

	(sleep_until (volume_test_players tv_pa_05))
	(set g_pa_obj_control 5)
	(if debug (print "set objective control 5"))

	(sleep_until (volume_test_players tv_pa_06))
	(set g_pa_obj_control 6)
	(if debug (print "set objective control 6"))

	(sleep_until (volume_test_players tv_pa_07))
	(set g_pa_obj_control 7)
	(if debug (print "set objective control 7"))

	(sleep_until (volume_test_players tv_pa_08))
	(set g_pa_obj_control 8)
	(if debug (print "set objective control 8"))

	(sleep_until (volume_test_players tv_pa_09))
	(set g_pa_obj_control 9)
	(if debug (print "set objective control 9"))
)

;============================== path a secondary scripts ===========================================================================================================================================
(script dormant pa_music_start
	(sleep_until	(and
					(>= g_pa_obj_control 3)
					(or
						(>= (ai_combat_status sq_pa_cov_02) ai_combat_status_visible)
						(>= (ai_combat_status sq_pa_jackal_03) ai_combat_status_visible)
						(>= (ai_combat_status sq_pa_grunt_02) ai_combat_status_visible)
					)
				)
	)

	; start music 06 
	(set g_music_010_06 TRUE)
)

;====================================================================================================================================================================================================
;==================================== SUBSTATION ====================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_substation
	(data_mine_set_mission_segment "010_50_substation")
	(if debug (print "enc_substation"))
	(game_save)
	
		; wake navigation point scripts 
		(wake nav_ss)
		
		; unlock insertion point for all players 
		(game_insertion_point_unlock 1)
		
		; put allies in their proper objective
		(ai_set_objective gr_allies obj_ss_allies)
		(if debug (print "set ally objective"))
	
		; wake background threads 
		(wake ai_ss_initial_cov)
		(wake ai_ss_cov_reins)
		(wake gs_ss_spawn_crates)
		
		; wake mission dialogue 
		(wake md_ss_turrets)
		(wake md_ss_post_combat)
		
		; wake vignettes 
		(wake vs_ss_banshee_ambush)
	
		; wake training (grenade)  
		(if	(and
				(not (game_is_cooperative))
				(not (campaign_metagame_enabled))
			)
			(wake 010tr_grenades)
		)
	
		; wake music scripts 
		(wake music_010_065)
		(wake music_010_075)
		
		; wake chapter title 
		(if (= (game_insertion_point_get) 1)
			(wake chapter_charlie_insert)
			(wake chapter_charlie)
		)
		
		;placing allies (pelicans and marines) 
		(ai_place sq_ss_dock_marines)
		(ai_place sq_ss_pelican_01)
		(ai_place sq_ss_pelican_02)
			(sleep 1)
			
	; encounter control 
	; player jumps down from the lookout ledge 
	(sleep_until (volume_test_players tv_ss_01))
	(set g_ss_obj_control 1)
	(if debug (print "set objective control 1"))
	(game_save)

		; set the current objective as complete 
		(wake obj_substation_clear)
		
		; covenant can now die 
		(ai_cannot_die sq_ss_cov_01 FALSE)
		(ai_cannot_die sq_ss_cov_02 FALSE)
		(ai_cannot_die sq_ss_cov_03 FALSE)
		(ai_cannot_die sq_ss_jackals_01 FALSE)
		(ai_cannot_die sq_ss_jackals_02 FALSE)
		(ai_cannot_die sq_ss_jackals_03 FALSE)
		(ai_cannot_die sq_ss_jackals_04 FALSE)
		(ai_cannot_die sq_ss_jackals_05 FALSE)
		
	; player moves into the pumping huts (marines take the opposite side) 
	(sleep_until (volume_test_players tv_ss_02))
	(set g_ss_obj_control 2)
	(if debug (print "set objecitve control 2"))
	(game_save)

		; the AI can now drop grenades 
		(if debug (print "ai will now drop and throw grenades"))
		(ai_grenades TRUE)

		; set music 06 alternate 
		(set g_music_010_06_alt TRUE)

	(sleep_until (volume_test_players tv_ss_03))
	(set g_ss_obj_control 3)
	(if debug (print "set objecitve control 3"))

	; player approaches the back chokepoint 
	(sleep_until (volume_test_players tv_ss_04))
	(set g_ss_obj_control 4)
	(if debug (print "set objective control 4"))
	(game_save)
	(data_mine_set_mission_segment "010_51_substation_mid")
	
		; ai will now attack sniper on roof 
		(ai_disregard (ai_get_object sq_ss_jackals_01) FALSE)
		(ai_prefer_target_ai gr_allies gr_ss_cov_infantry FALSE)

		; stop music 05 
		(set g_music_010_05 FALSE)

		; stop music 06 
		(set g_music_010_06 FALSE)

	(sleep_until (volume_test_players tv_ss_05))
	(set g_ss_obj_control 5)
	(if debug (print "set objective control 5"))
	(game_save)

	(sleep_until (volume_test_players tv_ss_06))
	(set g_ss_obj_control 6)
	(if debug (print "set objective control 6"))
	(game_save)

		; start music 065 
		(set g_music_010_065 TRUE)

	; player if fighting on the cliff (marines are allowed get up on the cliff) 
	(sleep_until (volume_test_players tv_ss_07))
	(set g_ss_obj_control 7)
	(if debug (print "set objective control 7"))
	(game_save)
	(data_mine_set_mission_segment "010_52_substation_ridge")

		; set nav point global variable  
		(set g_nav_ss TRUE)
		
	; player exits the space (marines move up to the final lookout) 
	(sleep_until (volume_test_players tv_ss_08))
	(set g_ss_obj_control 8)
	(if debug (print "set objecitve control 8"))
	(game_save)
	
		; place first path b jackal
		(if (>= (game_difficulty_get) heroic) (ai_place sq_pb_jackal_01))

	; player exits the space (marines move up to the final lookout) 
	(sleep_until (volume_test_players tv_ss_09))
	(set g_ss_obj_control 9)
	(if debug (print "set objecitve control 9"))
	(game_save)

	; player exits the space (marines move up to the final lookout) 
	(sleep_until (volume_test_players tv_ss_10))
	(set g_ss_obj_control 10)
	(if debug (print "set objecitve control 10"))
	(game_save)
)

;============================== substation secondary scripts ================================================================================================================
(global boolean g_ss_cov_rein_02 FALSE)

; initial covenant 
(script dormant ai_ss_initial_cov
		; stagger ai placement 
		(sleep 5)

	; place covenant 
	(ai_place sq_ss_cov_01)
	(ai_place sq_ss_cov_02)
		(sleep 5)
			(ai_cannot_die sq_ss_cov_01 TRUE)
			(ai_cannot_die sq_ss_cov_02 TRUE)
	(ai_place sq_ss_cov_03)
		(sleep 5)
			(ai_cannot_die sq_ss_cov_03 TRUE)

	(if (>= (game_difficulty_get) heroic)
		(begin
			(cond
				((<= (game_difficulty_get) normal) (ai_place sq_ss_jackals_01 0))
				((= (game_difficulty_get) heroic) (ai_place sq_ss_jackals_01 1))
				((= (game_difficulty_get) legendary) (ai_place sq_ss_jackals_01 2))
			)
				(sleep 1)
			(ai_place sq_ss_jackals_02)
			(ai_place sq_ss_jackals_03)
				(sleep 1)
			(ai_place sq_ss_jackals_04)
			(ai_place sq_ss_jackals_05)
		)
	)
	(sleep 1)
	
	; kill marines if you have too many / don't let allies kill jackals 
	(if (>= (ai_living_count gr_marines) 5) (ai_kill sq_ss_dock_marines))
	(ai_disregard (ai_get_object sq_ss_jackals_01) TRUE)
	(ai_prefer_target_ai gr_allies gr_ss_cov_infantry TRUE)

	; covenant cannot die until the player enters the encounter (so you hear fighting) 
	(ai_cannot_die sq_ss_jackals_01 TRUE)
	(ai_cannot_die sq_ss_jackals_02 TRUE)
	(ai_cannot_die sq_ss_jackals_03 TRUE)
	(ai_cannot_die sq_ss_jackals_04 TRUE)
	(ai_cannot_die sq_ss_jackals_05 TRUE)
)


; covenant reinforcements
(script dormant ai_ss_cov_reins
	; WAVE 1 ==============================================================================
	(sleep_until (>= g_ss_obj_control 2))
	(sleep_until	(or
					(>= g_ss_obj_control 4)
					(<= (ai_task_count obj_ss_covenant/infantry_gate) 6)
				)
	5)
		(if debug (print "wave 1 covenant reinforcements"))
		(ai_place sq_ss_back_jackal_01)
		(ai_place sq_ss_cov_04)
		(ai_place sq_ss_cov_05)
		(sleep 1)

	; WAVE 2 ==============================================================================
	(sleep_until	(or
					(and
						(>= g_ss_obj_control 4)
						(<= (ai_task_count obj_ss_covenant/infantry_gate) 14)
					)
					(>= g_ss_obj_control 5)
				)
	5)
		; spawns reinforcements from phantom if pelican vignette is finished 
		(if	(and
				g_ss_banshee_ambush
				(<= (ai_task_count obj_ss_covenant/infantry_gate) 18)
			)
			(begin
				(if debug (print "wave 2 covenant reinforcements"))
				(ai_place sq_ss_phantom_02)
				(set g_ss_phantom_02_placed TRUE)
			)
		)
;*
		; spawn river phantom (background noise / no infantry) 
		; does not spawn on easy or normal 
		(if	(and
				g_ss_banshee_ambush
				g_ss_phantom_03_spawn
			)
			(ai_place sq_ss_phantom_03)
		)
*;
	; WAVE 3 ==============================================================================
	(sleep_until	(or
					(and
						g_ss_phantom_02
						(>= g_ss_obj_control 6)
						(<= (ai_task_count obj_ss_covenant/infantry_gate) 0)
					)
					(and
						g_ss_phantom_02
						(>= g_ss_obj_control 7)
						(<= (ai_task_count obj_ss_covenant/infantry_gate) 5)
					)
					(>= g_ss_obj_control 8)
				)
	5)
		(if	(<= (ai_task_count obj_ss_covenant/infantry_gate) 6)
			(begin
				(if debug (print "wave 2 covenant reinforcements"))
				(ai_place sq_ss_rein_cov_03)
				(if (= g_ss_phantom_02_placed FALSE) (ai_place sq_ss_rein_cov_04))
			)
		)
)

(script dormant gs_ss_spawn_crates
	(object_create_folder foliage_substation)
	(object_create_folder cr_substation_01)
		(sleep 15)
	(object_create_folder cr_substation_02)
		(sleep 15)
	(object_create_folder cr_substation_03)
)

(global vehicle ss_phantom_02 NONE)
(global boolean g_ss_phantom_01 FALSE)
(global boolean g_ss_phantom_02 FALSE)
(global boolean g_ss_phantom_02_placed FALSE)
(global boolean g_ss_phantom_03 FALSE)
(global boolean g_ss_phantom_03_spawn FALSE)


(script command_script cs_ss_phantom_01
	(if debug (print "phantom 01"))
			(cs_vehicle_boost TRUE)
		(cs_fly_by ps_ss_phantom/p0)
			(cs_vehicle_boost FALSE)
;		(cs_fly_by ps_ss_phantom/p1)
		(cs_fly_by ps_ss_phantom/p2)
		(cs_fly_by ps_ss_phantom/p3)
	(cs_vehicle_speed 0.45)
		(cs_fly_by ps_ss_phantom/p4)
		(cs_fly_to ps_ss_phantom/p5)
	(sleep_until g_ss_phantom_03 5 (* 30 10))
		(cs_fly_by ps_ss_phantom/p6)
	(cs_vehicle_speed 0.55)
	(set g_ss_phantom_03_spawn TRUE)
		(cs_fly_by ps_ss_phantom/p7)
	(cs_vehicle_speed 1.0)
		(cs_fly_by ps_ss_phantom/p8)
		(cs_fly_by ps_ss_phantom/p9)
	(ai_erase ai_current_squad)
)

(script command_script cs_ss_phantom_02
	(if debug (print "phantom 02"))
	(set ss_phantom_02 (ai_vehicle_get_from_starting_location sq_ss_phantom_02/phantom))

		(ai_place sq_ss_rein_cov_01)
		(ai_place sq_ss_rein_cov_02)
		(sleep 1)
		(if	(<= (ai_task_count obj_ss_covenant/infantry_gate) 18)
			(begin
				(ai_place sq_ss_grunt_01)
				(ai_place sq_ss_grunt_02)
			)
		)

;		(ai_place sq_ss_rein_jackal_01)
;		(ai_place sq_ss_rein_jackal_02)
			(sleep 5)
		(ai_vehicle_enter_immediate sq_ss_rein_cov_01 ss_phantom_02 "phantom_p_mr_f")
		(ai_vehicle_enter_immediate sq_ss_rein_cov_02 ss_phantom_02 "phantom_p_mr_b")
		(ai_vehicle_enter_immediate sq_ss_grunt_01 ss_phantom_02 "phantom_p_rf")
		(ai_vehicle_enter_immediate sq_ss_grunt_02 ss_phantom_02 "phantom_p_rb")
	;	(ai_vehicle_enter_immediate sq_ss_rein_jackal_01 ss_phantom_02 "phantom_p_lf")
	;	(ai_vehicle_enter_immediate sq_ss_rein_jackal_02 ss_phantom_02 "phantom_p_lb")
			(sleep 1)

	; start movement 
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_phantom/p1)
		(cs_vehicle_boost FALSE)
;	(cs_fly_by ps_ss_phantom/p1)
	(cs_fly_by ps_ss_phantom/p2)
	(cs_fly_by ps_ss_phantom/p3)
		(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face ps_ss_phantom/ph_hover ps_ss_phantom/ph_face 1)
		(sleep 30)

			; start music 065 
			(set g_music_010_065 TRUE)

	(cs_fly_to_and_face ps_ss_phantom/ph_drop ps_ss_phantom/ph_face 1)
		(sleep 15)
		
		(begin_random
			(begin
				(vehicle_unload ss_phantom_02 "phantom_p_rf")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload ss_phantom_02 "phantom_p_rb")
				(sleep (random_range 5 15))
			)
		)
		(sleep 45)
		(begin_random
			(begin
				(vehicle_unload ss_phantom_02 "phantom_p_mr_f")
				(sleep (random_range 5 15))
			)
			(begin
				(vehicle_unload ss_phantom_02 "phantom_p_mr_b")
				(sleep (random_range 5 15))
			)
		)
	
		(sleep 90)
		(unit_close ss_phantom_02)
	(set g_ss_phantom_02 TRUE)
		(if (>= (game_difficulty_get) heroic) (sleep (random_range 115 135)))
	(cs_fly_to ps_ss_phantom/ph_hover 1)
		(if (>= (game_difficulty_get) heroic) (sleep (random_range 150 210)))
		(set g_ss_phantom_03 TRUE)
		(sleep (random_range 15 45))
		(cs_vehicle_speed 0.75)
	(cs_fly_by ps_ss_phantom/p4)
	(cs_fly_by ps_ss_phantom/p5)
		(cs_vehicle_speed 1.0)
	(cs_fly_by ps_ss_phantom/p6)
	(cs_fly_by ps_ss_phantom/p7)
	(cs_fly_by ps_ss_phantom/p8)
	(cs_fly_by ps_ss_phantom/p9)
	(ai_erase ai_current_squad)
)

(script command_script cs_ss_phantom_03
	(if debug (print "phantom 03"))
			(cs_vehicle_boost TRUE)
		(cs_fly_by ps_ss_phantom/p0)
			(cs_vehicle_boost FALSE)
;		(cs_fly_by ps_ss_phantom/p1)
		(cs_fly_by ps_ss_phantom/p2)
		(cs_fly_by ps_ss_phantom/p3)
		(cs_fly_by ps_ss_phantom/p4)
		(cs_fly_to ps_ss_phantom/p5)
	(sleep_until g_ss_phantom_03)
		(cs_fly_by ps_ss_phantom/p6)
		(cs_fly_by ps_ss_phantom/p7)
		(cs_fly_by ps_ss_phantom/p8)
		(cs_fly_by ps_ss_phantom/p9)
	(ai_erase ai_current_squad)
)


;====================================================================================================================================================================================================
;======================================= PATH B =====================================================================================================================================================
;====================================================================================================================================================================================================

; begin path b encounters
(script dormant enc_path_b
	(data_mine_set_mission_segment "010_60_path_b")
	(if debug (print "enc_path_b"))
	(game_save)
		
		; put allies in their proper objective
		(ai_set_objective gr_allies obj_pb_allies)
		(if debug (print "set ally objective"))
	
		; wake navigation point scripts 
		(wake nav_pb)
		
		; wake mission dialogue 
;		(wake md_pb_move_forward)
		(wake md_pb_joh_alright)
		(if (<= (game_difficulty_get) normal) (wake md_pb_mar_jackals))
		
		; wake music scripts 
		(wake music_010_07)

	
		; place all initial covenant
		(if debug (print "placing initial covenant"))
		(wake ai_pb_jackal_spawn)
			(sleep 1)
		
		; set nav point global variable  
		(set g_nav_pb TRUE)
		
		; stop music 065 
		(set g_music_010_065 FALSE)

		; start music 075 
		(set g_music_010_075 TRUE)

	(sleep_until (volume_test_players tv_pb_01))
	(if debug (print "set objective control 1"))
	(set g_pb_obj_control 1)
	(game_save)

		; migrate covenant from substation 
		(ai_set_objective gr_ss_covenant obj_pb_covenant)

	(sleep_until (volume_test_players tv_pb_02))
	(if debug (print "set objective control 2"))
	(set g_pb_obj_control 2)
	(data_mine_set_mission_segment "010_61_path_b_mid")

	(sleep_until (volume_test_players tv_pb_03))
	(if debug (print "set objective control 3"))
	(set g_pb_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_pb_04))
	(if debug (print "set objective control 4"))
	(set g_pb_obj_control 4)
	(data_mine_set_mission_segment "010_62_path_b_end")

	(sleep_until (volume_test_players tv_pb_05))
	(if debug (print "set objective control 5"))
	(set g_pb_obj_control 5)
	(game_save)

	(sleep_until (volume_test_players tv_pb_06))
	(if debug (print "set objective control 6"))
	(set g_pb_obj_control 6)

		; start music 07 
		(set g_music_010_07 TRUE)

	(sleep_until (volume_test_players tv_pb_07))
	(if debug (print "set objective control 7"))
	(set g_pb_obj_control 7)
	(game_save)
)

;========================== path b secondary scripts ==========================================================================================================================================

(global boolean g_pb_jackal_spawn TRUE)
(global short g_pb_jackal_limit 0)
(global short g_pb_jackal_count 0)

(script dormant ai_pb_jackal_spawn
	(cond
		((<= (game_difficulty_get) normal) (set g_pb_jackal_limit 1))
		((= (game_difficulty_get) heroic) (set g_pb_jackal_limit 3))
		((= (game_difficulty_get) legendary) (set g_pb_jackal_limit 5))
	)
		(sleep 1)
	(begin_random
		(if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic)) (ai_pb_jackal sq_pb_jackal_02))
		(if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic))  (ai_pb_jackal sq_pb_jackal_03))
		(if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic))  (ai_pb_jackal sq_pb_jackal_04))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_05))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_06))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_07))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_08))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_09))
	)
	
		(sleep 1)
	(set g_pb_jackal_spawn TRUE)
	(set g_pb_jackal_count 0)
	(cond
		((<= (game_difficulty_get) normal) (set g_pb_jackal_limit 4))
		((= (game_difficulty_get) heroic) (set g_pb_jackal_limit 5))
		((= (game_difficulty_get) legendary) (set g_pb_jackal_limit 6))
	)
		(sleep 1)
	
	(begin_random
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_10))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_11))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_12))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_13))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_14))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_15))
		(if g_pb_jackal_spawn (ai_pb_jackal sq_pb_jackal_16))
	)
)

(script static void (ai_pb_jackal (ai spawned_squad))
	(ai_place spawned_squad)
	(set g_pb_jackal_count (+ g_pb_jackal_count 1))
	(if (= g_pb_jackal_limit g_pb_jackal_count) (set g_pb_jackal_spawn FALSE))
)

;====================================================================================================================================================================================================
;==================================== BRUTE AMBUSH ==================================================================================================================================================
;====================================================================================================================================================================================================
; begin brute ambush encounters
(script dormant enc_brute_ambush
	(data_mine_set_mission_segment "010_70_brute_ambush")
	(if debug (print "enc_brute_ambush"))
	(game_save)
	
		; unlock insertion point for all players 
		(game_insertion_point_unlock 2)
		
		; wake navigation point scripts 
		(wake nav_ba)
		
		; wake mission dialogue 
		(wake md_ba_pelican)
		(wake md_ba_post_combat)
		
		; wake vignettes
		(wake vs_ba_joh_dumb_apes)
		
		; wake background threads 
		(wake ai_ba_cov_reins)
		
		; wake music scripts 
		(wake music_010_076)
		
		; set the current objective as complete 
		(wake obj_locate_pelican_clear)
		(wake obj_get_to_johnson_set)
		
		; place initial covenant 
		(if debug (print "placing initial covenant"))
		(ai_place sq_ba_cov_01)
		(ai_place sq_ba_cov_02)
		(if (>= (game_difficulty_get) heroic) (ai_place sq_ba_cov_03))
		(if (>= (game_difficulty_get) heroic) (ai_place sq_ba_cov_04))
		(ai_place sq_ba_grunt_01)
		(if (<= (game_difficulty_get) normal) (ai_place sq_ba_grunt_02))
		(ai_place sq_ba_grunt_03)
		(ai_place sq_ba_phantom_01)
;		(ai_place sq_ba_phantom_02)
		
		; place jackals 
		(wake ai_ba_jackal_spawn)
		
		(sleep 1)
		
		; place pinned down marines 
		(if debug (print "placing marines"))
		(ai_place sq_ba_johnson_marines)
		(ai_prefer_target_ai gr_allies gr_ba_cov_infantry TRUE)

	(sleep_until	(or
					(volume_test_players tv_ba_01)
					(volume_test_players tv_ba_01_02)
				)
	5)
	(if debug (print "set objective control 1"))
	(game_save)
	(set g_ba_obj_control 1)
	
		; put allies in their proper objective
		(if debug (print "set ally objective"))
		(ai_set_objective gr_allies obj_ba_allies)
		
	(sleep_until	(or
					(volume_test_players tv_ba_01_02)
					(volume_test_players tv_ba_02_03_04)
					(volume_test_players tv_ba_02_03_04_05)
				)
	5)
	(if debug (print "set objective control 2"))
	(game_save)
	(set g_ba_obj_control 2)
	(data_mine_set_mission_segment "010_71_brute_ambush_mid")
		
		; set objective variable true 
		(set g_ba_johnson_objective TRUE)

	(sleep_until	(or
					(volume_test_players tv_ba_03)
					(volume_test_players tv_ba_02_03_04)
					(volume_test_players tv_ba_02_03_04_05)
					(volume_test_players tv_ba_03_04_05a)
					(volume_test_players tv_ba_03_04_05b)
					(volume_test_players tv_ba_03_04_05c)
				)
	5)
	(if debug (print "set objective control 3"))
	(game_save)
	(set g_ba_obj_control 3)
	(data_mine_set_mission_segment "010_72_brute_ambush_end")

		; set nav point global variable  
		(set g_nav_ba TRUE)
		
	(sleep_until	(or
					(volume_test_players tv_ba_02_03_04)
					(volume_test_players tv_ba_02_03_04_05)
					(volume_test_players tv_ba_03_04_05a)
					(volume_test_players tv_ba_03_04_05b)
					(volume_test_players tv_ba_03_04_05c)
				)
	5)
	(if debug (print "set objective control 4"))
	(game_save)
	(set g_ba_obj_control 4)

		; set music 08 alternate 
		(if debug (print "music 08 alternate"))
		(sound_looping_set_alternate levels\solo\010_jungle\music\010_music_08 TRUE)

		; allies can now target jackals 
		(ai_prefer_target_ai gr_allies gr_ba_cov_infantry FALSE)

	(sleep_until	(or
					(volume_test_players tv_ba_02_03_04_05)
					(volume_test_players tv_ba_03_04_05a)
					(volume_test_players tv_ba_03_04_05b)
					(volume_test_players tv_ba_03_04_05c)
				)
	5)
	(if debug (print "set objective control 5"))
	(game_save)
	(set g_ba_obj_control 5)

		; start music 076 
		(set g_music_010_076 TRUE)

	(sleep_until (volume_test_players tv_tb_01) 1)
	(if debug (print "set objective control 1"))
	(set g_tb_obj_control 1)

		; put allies in their proper objective 
		(ai_set_objective gr_allies obj_tb_allies)
		(if debug (print "set ally objective"))

	(sleep_until (volume_test_players tv_tb_02) 1)
	(if debug (print "set objective control 2"))
	(set g_tb_obj_control 2)
	(game_save)

	(sleep_until (volume_test_players tv_tb_03) 1)
	(if debug (print "set objective control 3"))
	(set g_tb_obj_control 3)

	(sleep_until (volume_test_players tv_tb_04) 1)
	(if debug (print "set objective control 4"))
	(set g_tb_obj_control 4)
	(game_save)


)

;========================== brute ambush secondary scripts ==========================================================================================================================================
(global boolean g_ba_johnson_objective FALSE)

(global boolean g_ba_jackal_spawn TRUE)
(global short g_ba_jackal_limit 0)
(global short g_ba_jackal_count 0)

(script dormant ai_ba_jackal_spawn
	(ai_place sq_ba_jackal_05)
	(cond
		((<= (game_difficulty_get) normal) (set g_ba_jackal_limit 2))
		((= (game_difficulty_get) heroic) (set g_ba_jackal_limit 4))
		((= (game_difficulty_get) legendary) (set g_ba_jackal_limit 6))
	)
	(sleep 1)
	(begin_random
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_01))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_02))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_03))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_04))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_06))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_07))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_08))
		(if g_ba_jackal_spawn (ai_ba_jackal sq_ba_jackal_09))
	)
)

(script static void (ai_ba_jackal (ai spawned_squad))
	(ai_place spawned_squad)
	(set g_ba_jackal_count (+ g_ba_jackal_count 1))
	(if (= g_ba_jackal_limit g_ba_jackal_count) (set g_ba_jackal_spawn FALSE))
)

(script dormant ai_ba_cov_reins
	(sleep_until (>= g_ba_obj_control 4))
	
	(if debug (print "placing covenant reinforcements"))
	(if (<= (ai_task_count obj_ba_covenant/infantry_gate) 20) (ai_place sq_ba_cov_rein_01))
	(ai_place sq_ba_jackal_rein)
	(sleep 1)
	(if
		(and
			(>= (game_difficulty_get) heroic)
			(<= (ai_task_count obj_ba_covenant/infantry_gate) 10)
		)
		(ai_place sq_ba_cov_rein_02)
	)
)

(global boolean g_ba_phantom_flyaway FALSE)

(script command_script cs_ba_phantom_01
	(cs_face TRUE ps_ba/ph01_face)
	(ai_place sq_ba_chieftain)
	(ai_vehicle_enter_immediate sq_ba_chieftain (ai_vehicle_get_from_starting_location sq_ba_phantom_01/phantom) "phantom_pr_rf")
	(cs_force_combat_status 3)

	(sleep_until (>= g_ba_obj_control 2))
	(sleep_until	(or
					g_ba_phantom_flyaway
					(>= g_ba_obj_control 3)
					(<= (ai_living_count ai_current_squad) 4)
				)
	5 (* 30 30))
	(set g_ba_phantom_flyaway TRUE)
	(sleep (random_range 60 120))
	(set g_ba_phantom_stop TRUE)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_face FALSE ps_ba/ph01_face)
	(cs_fly_by ps_rc/ba_ph01)
	(cs_fly_by ps_rc/ba_ph02)
	(cs_fly_to ps_rc/ss_ph_erase)
	(ai_erase ai_current_squad)
)
	
(script command_script cs_ba_phantom_02
	(cs_face TRUE ps_ba/ph02_face)
	(cs_force_combat_status 3)

	(sleep_until (>= g_ba_obj_control 2))
	(sleep_until	(or
					g_ba_phantom_flyaway
					(>= g_ba_obj_control 3)
					(<= (ai_living_count ai_current_squad) 3)
				)
	5 (* 30 30))
	(set g_ba_phantom_flyaway TRUE)
	(sleep (random_range 0 30))
	(set g_ba_phantom_stop TRUE)

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_face FALSE ps_ba/ph02_face)
	(cs_fly_by ps_rc/ba_ph01)
	(cs_fly_by ps_rc/ba_ph02)
	(cs_fly_to ps_rc/ss_ph_erase)
	(ai_erase ai_current_squad)
)

;====================================================================================================================================================================================================
;======================================= DAM ========================================================================================================================================================
;====================================================================================================================================================================================================

; begin path b encounters 
(script dormant enc_dam
	(data_mine_set_mission_segment "010_80_dam")
	(if debug (print "enc_dam"))
	(game_save)

		; wake the mission won script 
		(wake 010_jungle_mission_won)
		
		; wake global scripts 
		(wake gs_award_primary_skull)

		; wake navigation point scripts 
		(wake nav_dam)
		(wake nav_dam_pelican)
		
		; wake background threads  
		(wake ai_dam_cov_reinforcements)
		(wake ai_dam_pelican)
		(wake ai_dam_kill_marines)

		; wake mission dialogue 
		(wake md_dam_pelican_attack)
		(wake md_dam_joh_pile_in)
		(wake md_dam_joh_leave)

		; wake vignettes
		(wake vs_dam_jail_bait)
		(wake vs_dam_jail_rescue)
	
		; wake perspectives
		(wake 010pb_johnson_captured)

		; wake music scripts 
		(wake music_010_08)

		; placing johnson marines
		(ai_place sq_dam_joh_marines)

		; place intitial covenant
		(if debug (print "placing initial covenant"))
		(ai_place sq_dam_phantom_01)
		(ai_place sq_dam_chieftain)
		(ai_place sq_dam_bodyguards)
		(ai_place sq_dam_ini_cov_01)
		(ai_place sq_dam_ini_grunt_01)
		(ai_place sq_dam_ini_grunt_02)
;		(ai_place sq_dam_ini_grunt_03)
		(ai_place sq_dam_ini_jackal_01)
		(ai_place sq_dam_ini_jackal_02)

		(if (>= (game_difficulty_get) heroic)
			(begin
				(ai_place sq_dam_ini_jackal_03)
				(ai_place sq_dam_ini_jackal_04)
			)
		)
		
		(sleep 1)
		
		; ugly hackey ai stuff 
		(ai_disregard (ai_actors sq_dam_joh_marines) TRUE)
		(ai_cannot_die sq_dam_joh_marines/johnson TRUE)

	; main encounter thread 
	; player is on the approach ledge 
	(sleep_until (volume_test_players tv_dam_01) 5)
	(if debug (print "set objective control 1"))
	(set g_dam_obj_control 1)
	
		; put allies in their proper objective 
		(if debug (print "set ally objective"))
		(ai_set_objective gr_marines obj_dam_allies)
		(ai_set_objective gr_arbiter obj_dam_allies)

		; stop music 07 
		(set g_music_010_07 FALSE)
	
		; stop music 075 
		(set g_music_010_075 FALSE)
	
		; stop music 076 
		(set g_music_010_076 FALSE)
		
	; player has dropped down 
	(sleep_until (volume_test_players tv_dam_02) 5)
	(if debug (print "set objective control 2"))
	(set g_dam_obj_control 2)
	(game_save)
	
	; player has dropped down 
	(sleep_until (volume_test_players tv_dam_03) 5)
	(if debug (print "set objective control 3"))
	(set g_dam_obj_control 3)
	(game_save)

	; player has entered the building leading up to the dam (top or bottom) 
	(sleep_until (volume_test_players tv_dam_04) 5)
	(if debug (print "set objective control 4"))
	(set g_dam_obj_control 4)
	(game_save)

	; player is crossing the dam (top or bottom) 
	(sleep_until (volume_test_players tv_dam_05) 5)
	(if debug (print "set objective control 5"))
	(set g_dam_obj_control 5)
	(game_save)
	(data_mine_set_mission_segment "010_81_dam_bridge")
	
		; set covenant objective 
		(ai_set_objective gr_dam_covenant obj_dam_05_06_covenant)

	; player is in the building on the opposite side of the dam 
	(sleep_until (volume_test_players tv_dam_06) 5)
	(if debug (print "set objective control 6"))
	(set g_dam_obj_control 6)
	(game_save)

	; player is approaching the marine holding pen 
	(sleep_until (volume_test_players tv_dam_07) 5)
	(if debug (print "set objective control 7"))
	(set g_dam_obj_control 7)
	(game_save)
	(data_mine_set_mission_segment "010_82_dam_08_covenant")

		; set covenant objective 
		(ai_set_objective gr_dam_covenant obj_dam_07_covenant)

		; set nav point global variable  
		(set g_nav_dam TRUE)
		
	; player has saved the marines 
	(sleep_until (volume_test_players tv_dam_08) 5)
	(if debug (print "set objective control 08"))
	(set g_dam_obj_control 08)
	(game_save)

		; set covenant objective 
		(ai_set_objective gr_dam_covenant obj_dam_08_evac_covenant)
)

;================================ dam secondary scripts =============================================================================================================================================
(global boolean g_dam_phantom_02 FALSE)
(global boolean g_dam_place_phantom_03 FALSE)
(global boolean g_dam_phantom_04 FALSE)
(global boolean g_dam_place_phantom_04 FALSE)
(global boolean g_dam_pelican FALSE)
(global boolean g_dam_pelican_arrive FALSE)
(global boolean g_dam_pelican_attack01 FALSE)
(global boolean g_dam_pelican_attack02 FALSE)

(global short g_dam_extraction_location 0)

(global vehicle dam_phantom_01 NONE)
(global vehicle dam_phantom_02 NONE)
(global vehicle dam_phantom_03 NONE)
(global vehicle dam_phantom_04 NONE)
(global vehicle dam_pelican NONE)

(script dormant ai_dam_kill_marines
	(sleep_until (>= g_dam_obj_control 1))
	(if (>= (ai_living_count gr_marines) 3)
		(begin
			(ai_kill_silent sq_dam_joh_marines/mar_01)
			(ai_kill_silent sq_dam_joh_marines/mar_02)
			(ai_kill_silent sq_dam_joh_marines/mar_03)
		)
	)
)


; covenant reinforcements 
(script dormant ai_dam_cov_reinforcements
	(sleep_until	(or
					(and
						(>= g_dam_obj_control 3)
						(<= (ai_living_count gr_dam_covenant_infantry) 7)
					)
					(and
						(>= g_dam_obj_control 4)
						(<= (ai_living_count gr_dam_covenant_infantry) 15)
					)
					(>= g_dam_obj_control 5)
				)
	5)
	
		; attempt to place covenant reinforcements  
		(ai_place sq_dam_phantom_02)
		
		(if (<= (ai_living_count gr_dam_covenant_infantry) 10)
			(begin
				(if debug (print "placing bridge covenant"))
				(ai_place sq_dam_bridge_cov_01)
				(ai_place sq_dam_bridge_grunt_01)
			)
		)
		(if (<= (ai_living_count gr_dam_jackals) 4) (ai_place sq_dam_bridge_jackal_01))
		
	(if (>= g_dam_obj_control 5)
		(begin
			(if debug (print "setting current objective"))
			(ai_set_objective sq_dam_bridge_cov_01 obj_dam_05_06_covenant)
			(ai_set_objective sq_dam_bridge_grunt_01 obj_dam_05_06_covenant)
			(ai_set_objective sq_dam_bridge_jackal_01 obj_dam_05_06_covenant)
		)
	)
				
	(sleep_until g_dam_place_phantom_03 5)
		(ai_place sq_dam_phantom_03)
	(sleep_until g_dam_place_phantom_04 5)
		(ai_place sq_dam_phantom_04)
)

(script command_script cs_dam_ini_brute
	(ai_activity_set ai_current_actor "act_kneel_1")
	(sleep (random_range 200 240))
	(ai_activity_abort ai_current_actor)
)

(script command_script cs_dam_ini_grunt
	(if (= (random_range 0 2) 0)
		(ai_activity_set ai_current_actor "stand")
		(ai_activity_set ai_current_actor "asleep")
	)
	(sleep (random_range 250 300))
	(ai_activity_abort ai_current_actor)
)


; command script for the initial phantom that is in the space when the player enters
(script command_script cs_dam_phantom_01
	(set dam_phantom_01 (ai_vehicle_get_from_starting_location sq_dam_phantom_01/phantom))
	(if debug (print "dam phantom 01"))
	
	; phantom cannot take damage 
	(object_cannot_take_damage dam_phantom_01)
	
	(cs_face TRUE ps_dam/jail_hover)
		(cs_vehicle_speed 0.35)
	(cs_fly_to ps_dam/bridge_drop 1)
	(sleep 5)
	
	(ai_set_blind sq_dam_phantom_01 TRUE)
	(ai_set_deaf sq_dam_phantom_01 TRUE)

	(sleep_until (>= g_dam_obj_control 1))

		(if debug (print "placing and dropping covenant"))
		(ai_dump_via_phantom sq_dam_phantom_01/phantom sq_dam_ph01_jackal_01)
		(sleep 90)

	(if (<= (ai_combat_status obj_dam_00_04_covenant) 4) (sleep_until (>= (ai_combat_status obj_dam_00_04_covenant) 5) 30 (* 30 7)))

		(if debug (print "placing and dropping covenant"))
		(ai_dump_via_phantom sq_dam_phantom_01/phantom sq_dam_ph01_cov_01)
		(sleep 60)
	
		(if debug (print "fly away"))
	(cs_fly_to ps_dam/bridge_hover 1)
		(sleep 60)
	(cs_fly_by ps_rc/dam_04)
		(cs_face TRUE ps_rc/dam_02)
		(cs_vehicle_speed 1.00)
;	(cs_fly_by ps_rc/dam_03)
		(sleep 30)
		(cs_face FALSE ps_rc/dam_02)
;	(cs_fly_by ps_rc/dam_02)
	(cs_fly_by ps_rc/dam_01)
	(cs_fly_by ps_rc/ph_erase)
		(if debug (print "delete phantom"))
		(ai_erase ai_current_squad)
)


; first wave of covenant reinforcements 
; lands by the jail building 
(script command_script cs_dam_phantom_02
	(set dam_phantom_02 (ai_vehicle_get_from_starting_location sq_dam_phantom_02/phantom))
	(if debug (print "dam phantom 02"))
	(cs_enable_pathfinding_failsafe TRUE)
	
	; phantom cannot take damage 
	(object_cannot_take_damage dam_phantom_02)
	
	(cs_fly_by ps_rc/dam_01)
	(cs_fly_by ps_rc/dam_02)
	(cs_fly_by ps_rc/dam_03)
	(cs_fly_by ps_rc/dam_04)
	(cs_fly_to ps_dam/jail_hover)
		(sleep 30)
		(cs_vehicle_speed 0.5)
	(cs_fly_to ps_dam/jail_drop 1)

		; turn on the phantom gravity lift
		(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_dam_phantom_02/phantom) TRUE)
		(sleep 30)
	
			; test to see if it's ok to drop a squad of covenant 
					(if debug (print "placing and dropping jackals"))
					(if (<= (ai_living_count gr_dam_jackals) 4) (ai_dump_via_phantom sq_dam_phantom_02/phantom sq_dam_ph02_jackal_01))
					(sleep 15)
					(if (>= g_dam_obj_control 5) (ai_set_objective sq_dam_ph02_jackal_01 obj_dam_05_06_covenant))
					(sleep 135)

			(if (<= (ai_living_count gr_dam_covenant_infantry) 14)
				(begin
					(if debug (print "placing and dropping covenant"))
					(ai_dump_via_phantom sq_dam_phantom_02/phantom sq_dam_ph02_grunt_01)
					(sleep 15)
					(if (>= g_dam_obj_control 5) (ai_set_objective sq_dam_ph02_grunt_01 obj_dam_05_06_covenant))
					(sleep 135)
				)
			)
					
					(if debug (print "placing and dropping covenant"))
					(ai_dump_via_phantom sq_dam_phantom_02/phantom sq_dam_ph02_cov_01)
					(sleep 15)
					(if (>= g_dam_obj_control 5) (ai_set_objective sq_dam_ph02_cov_01 obj_dam_05_06_covenant))
					(sleep 135)
			
		; turn off the phantom gravity lift 
		(sleep 30)
		(object_set_phantom_power (ai_vehicle_get_from_starting_location sq_dam_phantom_02/phantom) FALSE)
		(sleep 30)
		

	
	; fly away! 
	(if debug (print "raise"))
	(cs_fly_to ps_dam/jail_hover 1)
		(sleep 30)
	(cs_vehicle_speed 1.0)

	(if debug (print "fly away"))
	(cs_fly_by ps_dam/ph01)
	(cs_fly_by ps_dam/bridge_hover)
	(cs_fly_by ps_rc/dam_03)
	(cs_fly_by ps_rc/dam_02)
	(cs_fly_by ps_rc/dam_01)
	(cs_fly_by ps_rc/ph_erase)

	(if debug (print "delete phantom"))
	(ai_erase ai_current_squad)
)


; final covenant reinforcements that land on the bridge 
(script command_script cs_dam_phantom_03
	(set dam_phantom_03 (ai_vehicle_get_from_starting_location sq_dam_phantom_03/phantom))
	(if debug (print "dam phantom 03"))

	; phantom cannot take damage 
	(object_cannot_take_damage dam_phantom_03)
	
	; move through initial set of points (fly to the dam) 
	(cs_fly_by ps_rc/dam_01)
	(cs_fly_by ps_rc/dam_02)
	(cs_fly_by ps_rc/dam_03)

		; allow phantom 04 to spawn 
		(if debug (print "place phantom 04"))
		(set g_dam_place_phantom_04 TRUE)

	(cs_fly_by ps_rc/dam_04)
	(cs_fly_by ps_dam/ph01)
	(cs_fly_by ps_dam/ph02)

	(cs_fly_to ps_dam/ph03_hover 2)
	(cs_face TRUE ps_dam/ph01)
		(cs_vehicle_speed 0.5)
		(sleep 90)
	(cs_fly_to ps_dam/ph03_drop 2)
		(sleep 60)

	(ai_dump_via_phantom sq_dam_phantom_03/phantom sq_dam_ph03_cov_01)
		(sleep 150)
	(ai_dump_via_phantom sq_dam_phantom_03/phantom sq_dam_ph03_grunt_01)
		(sleep 90)

	(cs_fly_to ps_dam/ph03_hover 2)

	(cs_face TRUE ps_dam/phantom_face)
		(cs_enable_moving TRUE)
		(cs_enable_targeting TRUE)

	; phantom can take damage 
	(object_can_take_damage dam_phantom_03)
	
	(sleep_until g_null)
)


(script command_script cs_dam_phantom_04
	(set dam_phantom_04 (ai_vehicle_get_from_starting_location sq_dam_phantom_04/phantom))
	(if debug (print "dam phantom 04"))

	; phantom cannot take damage 
	(object_cannot_take_damage dam_phantom_04)
	
	; move through initial set of points (fly to the dam) 
	(cs_fly_by ps_rc/dam_01)
	(cs_fly_by ps_rc/dam_02)
	(cs_fly_by ps_rc/dam_03)
	(cs_fly_by ps_rc/dam_04)
	
	(cs_face TRUE ps_dam/jail_hover)
		(cs_vehicle_speed 0.35)
	(cs_fly_to ps_dam/bridge_drop 1)
		(sleep 60)

	(ai_dump_via_phantom sq_dam_phantom_04/phantom sq_dam_ph04_cov_01)
		(sleep 150)
	(ai_dump_via_phantom sq_dam_phantom_04/phantom sq_dam_ph04_grunt_01)
		(sleep 30)

	; allow the pelican to fly in (it will wait for this variable to be set to true)  
	(set g_dam_pelican TRUE)

		(if debug (print "fly away"))
	(cs_fly_to ps_dam/bridge_hover 1)
		(sleep 5)
		(set g_dam_phantom_04 TRUE)
	(cs_fly_to ps_rc/dam_04)
	(cs_face TRUE ps_dam/phantom_face)
		(cs_enable_moving TRUE)
		(cs_enable_targeting TRUE)

	; phantom can take damage 
	(object_can_take_damage dam_phantom_04)
	
	(sleep_until g_null)
)

; this script calls the extraction pelican 
(script dormant ai_dam_pelican
	; sleep until player enters building 
	(sleep_until (>= g_dam_obj_control 8))
		(sleep 150)
	
	; sleep until phantom drops off guys 
	(sleep_until g_dam_pelican)
		(sleep 150)
	
	; sleep until most of the covenant are dead (this script times out after 30 seconds) 
	(sleep_until (<= (ai_task_count obj_dam_08_evac_covenant/infantry_gate) 6) 30 (* 30 60 0.5))
	
		; prepare to switch to the cinematic zone set 
		(prepare_to_switch_to_zone_set set_cin_outro_01)
	
		; disable set_dam trigger volumes 
		(zone_set_trigger_volume_enable zone_set:set_dam FALSE)
		(zone_set_trigger_volume_enable begin_zone_set:set_dam FALSE)
			(sleep (random_range 90 150))
	
	(if debug (print "placing the extraction pelican"))
	(ai_place sq_dam_pelican)
	
	; game save 
	(game_save)
)

(global boolean g_dam_pelican_task FALSE)

; dam pelican command script 
(script command_script cs_dam_pelican
	(if debug (print "here comes the pelican!!!"))
	(set dam_pelican (ai_vehicle_get_from_starting_location sq_dam_pelican/pilot))

	; fly into position over the broken bridge 
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_dam_pelican/pel00)
	(cs_fly_by ps_dam_pelican/pel01)

	(cs_fly_by ps_dam_pelican/pel02)
	(set g_dam_pelican_arrive TRUE)
	(cs_fly_to_and_face ps_dam_pelican/pel03 ps_dam_pelican/mid_face)
	
		; game save 
		(game_save)
	
	; if near phantom is alive then shoot at it  
	(if (>= (ai_living_count sq_dam_phantom_03) 1)
		(begin
			; shoot at phantom 03 
			(set g_dam_pelican_attack01 TRUE)
				(sleep (random_range 45 60))
			(cs_shoot TRUE dam_phantom_03)
				(sleep (random_range 120 150))
			(object_damage_damage_section dam_phantom_03 "death" 4000)
				(sleep 15)
			(cs_shoot FALSE dam_phantom_03)
				(sleep 30)
		)
	)
		
	; if far phantom is alive then shoot at it  
	(if (>= (ai_living_count sq_dam_phantom_04) 1)
		(begin
			; shoot at phantom 04 
			(set g_dam_pelican_attack02 TRUE)
				(sleep (random_range 45 60))
			(cs_shoot TRUE dam_phantom_04)
				(sleep (random_range 120 150))
			(object_damage_damage_section dam_phantom_04 "death" 4000)
				(sleep 15)
			(cs_shoot FALSE dam_phantom_04)
			
			(sleep (random_range 30 60))
		)
	)
	
	; game save 
	(game_save)

	; move the pelican close to the player 
	(set g_dam_extraction_location 2)
	(cs_run_command_script sq_dam_pelican/pilot cs_dam_pelican_mid)
	
	; give allies a task near the pelican 
	(set g_dam_pelican_task TRUE)
)

(script command_script cs_dam_pelican_mid
	(cs_face TRUE ps_dam_pelican/mid_face)
	(cs_vehicle_speed .5)
	(cs_fly_to ps_dam_pelican/pel04)
	(cs_fly_to ps_dam_pelican/mid01 2)
	(cs_vehicle_speed .25)
		(sleep 60)
	(cs_fly_to ps_dam_pelican/mid02 1)
		(sleep 60)
	
		; set nav point global variable  
		(set g_nav_dam TRUE)
		
	(cs_run_command_script gr_arbiter cs_dam_marines_to_pelican)
		(sleep 30)
	(cs_run_command_script gr_marines cs_dam_marines_to_pelican)
	(cs_run_command_script gr_johnson_marines cs_dam_marines_to_pelican)
	(sleep_until g_null)
)

(script command_script cs_dam_marines_to_pelican
	(if debug (print "tell all allies to get into the pelican"))
		(set g_johnson_pile_in TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	
	(cs_go_to_vehicle dam_pelican "pelican_p")
)

;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;===================================== general scripts ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

; notifies when covenant are activated
(script dormant covenant_activated
	(sleep_until (>= (ai_combat_status gr_covenant) 4))
	(if debug (print "====================== covenant have been activated ============================================ covenant have been activated ======================"))
	(sleep 30)
	(if debug (print "====================== covenant have been activated ============================================ covenant have been activated ======================"))
	(sleep 30)
	(if debug (print "====================== covenant have been activated ============================================ covenant have been activated ======================"))
)
	
; generic script to abort any command script 
(script command_script abort
	(ai_activity_abort ai_current_actor)
	(sleep 1)
)

(script static void sleep_random
	(if debug (print "sleep random range"))
	(sleep (random_range 60 90))
)

; makes all allies deathless (for testing allied ai movement) 
(script static void allies_deathless
	(if debug (print "allies cannot die"))
	(ai_cannot_die gr_allies TRUE)
)

(script static void allies_renew
	(if (<= (game_difficulty_get) normal)
		(begin
			(if debug (print "renewing allies"))
			(ai_renew gr_allies)
		)
	)
)

(script command_script cs_ai_erase
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep (* 30 15))
	(ai_erase ai_current_actor)
)

(script command_script cs_force_status_4
	(cs_force_combat_status 3)
)

(script command_script cs_crouch_walk
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_dialogue TRUE)
	
	(cs_crouch TRUE)
	
	(sleep_until g_null)
)

(script command_script cs_abort_activity
	(sleep (random_range 250 300))
	(ai_activity_abort ai_current_actor)
)

(script command_script cs_abort_activity_short
	(sleep (random_range 200 240))
	(ai_activity_abort ai_current_actor)
)

(script command_script  cs_berserk_brutes
	(if debug (print "play berserk animation"))
	(cs_face_player TRUE)
	(sleep 30)
	(ai_berserk ai_current_actor TRUE)
)

(script command_script cs_sleep_5
	(sleep (* 30 5))
)

;====================================================================================================================================================================================================
;============================== ROCK CREATION SCRIPT ===============================================================================================================================================
;====================================================================================================================================================================================================
(global short g_rock_zone_index 0)

(script continuous gs_create_rocks
	(sleep_until (!= g_rock_zone_index (current_zone_set)) 1)
	(cond
		; transa zone set 
		((= (current_zone_set) 3)	(begin
									(if debug (print "zone set 2 blockers"))
										(zone_set_trigger_volume_enable zone_set:set_jungle_walk FALSE)
										(zone_set_trigger_volume_enable begin_zone_set:set_jungle_walk FALSE)
								)
		)
		; path_a zone set 
		((= (current_zone_set) 5)	(begin
									(if debug (print "zone set 5 blockers"))
									(object_create_anew rock_trans_a)
										(zone_set_trigger_volume_enable zone_set:set_grunt_camp FALSE)
										(zone_set_trigger_volume_enable begin_zone_set:set_grunt_camp FALSE)
											(object_destroy_folder sc_chief_crater)
											(object_destroy_folder sc_jungle_walk)
											(object_destroy_folder foliage_chief_crater)
											(object_destroy_folder foliage_jungle_walk)
											(object_destroy_folder cr_jungle_walk)
								)
		)
		; path_b zone set 
		((= (current_zone_set) 7)	(begin
									(if debug (print "zone set 7 blockers"))
									(object_create_anew rock_path_a)
										(zone_set_trigger_volume_enable zone_set:set_substation FALSE)
										(zone_set_trigger_volume_enable begin_zone_set:set_substation FALSE)
											(object_destroy_folder cr_grunt_camp)
											(object_destroy_folder bp_path_a)
											(object_destroy_folder wp_path_a)
								)
		)
		; path_c zone set 
		((= (current_zone_set_fully_active) 9)	(begin
											(if debug (print "zone set 9 blockers"))
											(object_create_anew_containing rock_ba_0)
											(soft_ceiling_enable camera_pb_03 TRUE)
												(zone_set_trigger_volume_enable zone_set:set_path_b FALSE)
												(zone_set_trigger_volume_enable begin_zone_set:set_path_b FALSE)
													(object_destroy_folder eq_substation)
													(object_destroy_folder wp_substation)
													(object_destroy_folder bp_substation)
													(object_destroy_folder cr_substation)
										)
		)
		; dam zone set 
		((= (current_zone_set) 10)	(begin
									(if debug (print "zone set 10 blockers"))
									(object_create_anew rock_trans_b)
										(zone_set_trigger_volume_enable zone_set:set_path_c FALSE)
										(zone_set_trigger_volume_enable begin_zone_set:set_path_c FALSE)
											(object_destroy_folder eq_brute_ambush)
											(object_destroy_folder wp_brute_ambush)
								)
		)
	)
	(set g_rock_zone_index (current_zone_set))
)

;====================================================================================================================================================================================================
;============================== AWARD SKULLS ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_award_primary_skull
	(if (award_skull)
		(begin
			(object_create skull_iron)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
			
			(if debug (print "award iron skull"))
			(campaign_metagame_award_primary_skull (player0) 0)
			(campaign_metagame_award_primary_skull (player1) 0)
			(campaign_metagame_award_primary_skull (player2) 0)
			(campaign_metagame_award_primary_skull (player3) 0)
		)
	)
)

(script dormant gs_award_secondary_skull
	(if (award_skull)
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
			
			(if debug (print "award blind skull"))
			(campaign_metagame_award_secondary_skull (player0) 1)
			(campaign_metagame_award_secondary_skull (player1) 1)
			(campaign_metagame_award_secondary_skull (player2) 1)
			(campaign_metagame_award_secondary_skull (player3) 1)
		)
	)
)
		
;====================================================================================================================================================================================================
;============================== GARBAGE COLLECTION SCRIPTS ==========================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_recycle_volumes
	(sleep_until (> g_gc_obj_control 0))
		(add_recycling_volume tv_rec_cc 0 30)
		(add_recycling_volume tv_rec_jw 30 30)
	
	(sleep_until (> g_pa_obj_control 0))
		(add_recycling_volume tv_rec_jw 0 30)
		(add_recycling_volume tv_rec_gc 30 30)
	
	(sleep_until (> g_ss_obj_control 0))
		(add_recycling_volume tv_rec_gc 0 30)
		(add_recycling_volume tv_rec_pa 30 30)

	(sleep_until (> g_pb_obj_control 0))
		(add_recycling_volume tv_rec_pa 0 30)
		(add_recycling_volume tv_rec_ss 30 30)
	
	(sleep_until (> g_ba_obj_control 0))
		(add_recycling_volume tv_rec_ss 0 30)
		(add_recycling_volume tv_rec_pb 30 30)
	
	(sleep_until (> g_dam_obj_control 0))
		(add_recycling_volume tv_rec_pb 0 30)
		(add_recycling_volume tv_rec_ba 30 30)
	
	(sleep_until (>= g_dam_obj_control 5))
		(add_recycling_volume tv_rec_ba 0 30)
)

;====================================================================================================================================================================================================
;============================== AI DISPOSABLE SCRIPTS ===============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_disposable_ai
	(sleep_until (> g_gc_obj_control 0))
		(ai_disposable gr_jw_covenant TRUE)
		(ai_disposable sq_johnson_marines TRUE)
	
	(sleep_until (> g_pa_obj_control 0))
		(ai_disposable gr_gc_covenant TRUE)
	
	(sleep_until (> g_ss_obj_control 0))
		(ai_disposable gr_pa_covenant TRUE)

	(sleep_until (> g_pb_obj_control 0))
		(ai_disposable gr_ss_covenant TRUE)
	
	(sleep_until (> g_ba_obj_control 0))
		(ai_disposable gr_pb_covenant TRUE)
	
	(sleep_until (> g_dam_obj_control 0))
		(ai_disposable gr_ba_covenant TRUE)
)

;====================================================================================================================================================================================================
;=============================== CAMERA BOUNDS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_camera_bounds
	; turn off soft ceiling in path_b 
	; turn back on if ins_brute_ambush is launched 
	(soft_ceiling_enable camera_pb_03 FALSE)
	
	; turn on all camera bounds 
	(gs_camera_bounds_on)
	
	; chief crater 
	(sleep_until (>= g_cc_obj_control 2) 1)
		(soft_ceiling_enable camera_cc_00 FALSE)
	(sleep_until (>= g_cc_obj_control 4) 1)
		(soft_ceiling_enable camera_cc_01 FALSE)
	(sleep_until (>= g_cc_obj_control 6) 1)
		(soft_ceiling_enable camera_cc_02 FALSE)
	(sleep_until (>= g_cc_obj_control 10) 1)
		(soft_ceiling_enable camera_cc_03 FALSE)

	; jungle walk 
	(sleep_until (>= g_jw_obj_control 1) 1)
		(soft_ceiling_enable camera_jw_00 FALSE)
	(sleep_until (>= g_jw_obj_control 3) 1)
		(soft_ceiling_enable camera_jw_01 FALSE)
	(sleep_until (>= g_jw_obj_control 8) 1)
		(soft_ceiling_enable camera_jw_02 FALSE)
	(sleep_until (>= g_jw_obj_control 11) 1)
		(soft_ceiling_enable camera_jw_03 FALSE)

	; transition a 
	(sleep_until (>= g_ta_obj_control 1) 1)
		(soft_ceiling_enable camera_ta_01 FALSE)
	(sleep_until (>= g_ta_obj_control 5) 1)
		(soft_ceiling_enable camera_ta_02 FALSE)

	; grunt camp 
	(sleep_until (>= g_gc_obj_control 2) 1)
		(soft_ceiling_enable camera_gc_00 FALSE)
	(sleep_until (>= g_gc_obj_control 7) 1)
		(soft_ceiling_enable camera_gc_01 FALSE)

	; path a 
	(sleep_until (>= g_pa_obj_control 1) 1)
		(soft_ceiling_enable camera_pa_00 FALSE)
	(sleep_until (>= g_pa_obj_control 2) 1)
		(soft_ceiling_enable camera_pa_01 FALSE)
	(sleep_until (>= g_pa_obj_control 3) 1)
		(soft_ceiling_enable camera_pa_02 FALSE)

	; substation 
	(sleep_until (>= g_ss_obj_control 1) 1)
		(soft_ceiling_enable camera_ss_00 FALSE)
	(sleep_until (>= g_ss_obj_control 4) 1)
		(soft_ceiling_enable camera_ss_01 FALSE)
	(sleep_until (>= g_ss_obj_control 10) 1)
		(soft_ceiling_enable camera_ss_02 FALSE)
		
	; path b 
	(sleep_until (>= g_pb_obj_control 1) 1)
		(soft_ceiling_enable camera_pb_00 FALSE)
	(sleep_until (>= g_pb_obj_control 2) 1)
		(soft_ceiling_enable camera_pb_01 FALSE)
	(sleep_until (>= g_pb_obj_control 3) 1)
		(soft_ceiling_enable camera_pb_02 FALSE)
		
	; brute ambush 
	(sleep_until (>= g_ba_obj_control 1) 1)
		(soft_ceiling_enable camera_ba_00 FALSE)
	(sleep_until (>= g_ba_obj_control 4) 1)
		(soft_ceiling_enable camera_ba_01 FALSE)
		
	; dam 
	(sleep_until (>= g_dam_obj_control 1) 1)
		(soft_ceiling_enable camera_dam_00 FALSE)
	(sleep_until (>= g_dam_obj_control 5) 1)
		(soft_ceiling_enable camera_dam_01 FALSE)
)		
		
(script static void gs_camera_bounds_off		
	(if debug (print "turn off camera bounds"))

	; chief crater 
	(soft_ceiling_enable camera_cc_00 FALSE)
	(soft_ceiling_enable camera_cc_01 FALSE)
	(soft_ceiling_enable camera_cc_02 FALSE)
	(soft_ceiling_enable camera_cc_03 FALSE)

	; jungle walk 
	(soft_ceiling_enable camera_jw_00 FALSE)
	(soft_ceiling_enable camera_jw_01 FALSE)
	(soft_ceiling_enable camera_jw_02 FALSE)
	(soft_ceiling_enable camera_jw_03 FALSE)

	; transition a 
	(soft_ceiling_enable camera_ta_01 FALSE)
	(soft_ceiling_enable camera_ta_02 FALSE)
	
	; grunt camp 
	(soft_ceiling_enable camera_gc_00 FALSE)
	(soft_ceiling_enable camera_gc_01 FALSE)

	; path a 
	(soft_ceiling_enable camera_pa_00 FALSE)
	(soft_ceiling_enable camera_pa_01 FALSE)
	(soft_ceiling_enable camera_pa_02 FALSE)

	; substation 
	(soft_ceiling_enable camera_ss_00 FALSE)
	(soft_ceiling_enable camera_ss_01 FALSE)
	(soft_ceiling_enable camera_ss_02 FALSE)
		
	; path b 
	(soft_ceiling_enable camera_pb_00 FALSE)
	(soft_ceiling_enable camera_pb_01 FALSE)
	(soft_ceiling_enable camera_pb_02 FALSE)
		
	; brute ambush 
	(soft_ceiling_enable camera_ba_00 FALSE)
	(soft_ceiling_enable camera_ba_01 FALSE)
		
	; dam 
	(soft_ceiling_enable camera_dam_00 FALSE)
	(soft_ceiling_enable camera_dam_01 FALSE)
)		

(script static void gs_camera_bounds_on		
	(if debug (print "turn on camera bounds"))

	; chief crater 
	(soft_ceiling_enable camera_cc_00 TRUE)
	(soft_ceiling_enable camera_cc_01 TRUE)
	(soft_ceiling_enable camera_cc_02 TRUE)
	(soft_ceiling_enable camera_cc_03 TRUE)

	; jungle walk 
	(soft_ceiling_enable camera_jw_00 TRUE)
	(soft_ceiling_enable camera_jw_01 TRUE)
	(soft_ceiling_enable camera_jw_02 TRUE)
	(soft_ceiling_enable camera_jw_03 TRUE)

	; transition a 
	(soft_ceiling_enable camera_ta_01 TRUE)
	(soft_ceiling_enable camera_ta_02 TRUE)

	; grunt camp 
	(soft_ceiling_enable camera_gc_00 TRUE)
	(soft_ceiling_enable camera_gc_01 TRUE)

	; path a 
	(soft_ceiling_enable camera_pa_00 TRUE)
	(soft_ceiling_enable camera_pa_01 TRUE)
	(soft_ceiling_enable camera_pa_02 TRUE)

	; substation 
	(soft_ceiling_enable camera_ss_00 TRUE)
	(soft_ceiling_enable camera_ss_01 TRUE)
	(soft_ceiling_enable camera_ss_02 TRUE)
		
	; path b 
	(soft_ceiling_enable camera_pb_00 TRUE)
	(soft_ceiling_enable camera_pb_01 TRUE)
	(soft_ceiling_enable camera_pb_02 TRUE)
		
	; brute ambush 
	(soft_ceiling_enable camera_ba_00 TRUE)
	(soft_ceiling_enable camera_ba_01 TRUE)
		
	; dam 
	(soft_ceiling_enable camera_dam_00 TRUE)
	(soft_ceiling_enable camera_dam_01 TRUE)
)

(global short g_camera_zone_index 100)

(script dormant temp_camera_bounds_off
	(gs_camera_bounds_off)
	
	(sleep_until
		(begin
			(sleep_until (!= g_camera_zone_index (current_zone_set)))
			(gs_camera_bounds_off)
			(set g_camera_zone_index (current_zone_set))
		FALSE)
	)
)

;*
=====================================================================================================================================================================================================
================================== COMMENTS AND JUNK ================================================================================================================================================
=====================================================================================================================================================================================================


Objects per frame		characters	vehicles	weapons	scenery	crates/garbage/items
						28			12		30		50		60 



*;
