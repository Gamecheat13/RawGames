; =======================================================================================================================================================================
; =======================================================================================================================================================================
; RESCUE CORTANA CINEMATIC 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_stasis_field_destroyed FALSE)

(script dormant 110_highcharity_cortana
	(sleep_until	(or
					(>= (game_insertion_point_get) 1)
					(<= (object_get_shield cortana_prison) 0)
				)
	1)
	(object_destroy cortana_switch)

	; turn off looping cortana effect 
	(set g_stasis_field_destroyed TRUE)
		(sleep 20)

	; set current mission segment 
	(data_mine_set_mission_segment "110lb_rescue_cortana")

	; fade to black 
	(cinematic_snap_to_black)

		; switch to correct zone set unless "set_all" is loaded 
		(if (!= (current_zone_set) g_set_all)
			(begin
				(if debug (print "switching zone sets..."))
				(switch_zone_set set_reactor)
				(sleep 1)
			)
		)

			; teleport players 
			(object_teleport (player0) stash_rescue_cortana_01)
			(object_teleport (player1) stash_rescue_cortana_02)
			(object_teleport (player2) stash_rescue_cortana_03)
			(object_teleport (player3) stash_rescue_cortana_04)
				(sleep 1)

	; return run zone sets 
	(gs_return_zone_sets)
	(sleep 1)

		; stop music 09 
		(set g_music_110_09 FALSE)

		; stop music 10 
		(set g_music_110_10 FALSE)
		
		; stop looping sound 
		(sound_looping_stop "sound\visual_fx\cortana_effect\cortana_effect")

	; remove cortana 
	(object_destroy cortana_prison)
	(object_destroy (cinematic_object_get cortana))

	; erase all ai 
	(ai_erase_all)
	
	; garbage collect 
	(garbage_collect_unsafe)
	(add_recycling_volume vol_inner_sanctum 0 0)
	(is_destroy_objects)
	
	; kill any cortana effects 
	(cortana_effect_kill)
	
	; set cortana header and footer variables 
	(set g_cortana_header FALSE)
	(set g_cortana_footer FALSE)
	
	; kill current cortana script 
	(sleep_forever 110cf_torture)

		; play cinematic 
		(if g_play_cinematics
			(begin
				(if (cinematic_skip_start)
					(begin
						(if debug (print "110lb_rescue_cortana"))
						(110lb_rescue_cortana)
					)
				)
				(cinematic_skip_stop)
			)
		)
		; cleanup cinematics 
		(110lb_rescue_cortana_cleanup)

	; fade out 
	(fade_out 0 0 0 0)
	
	; fuck our cinematic code right in the pooper 
	(cinematic_start)
	(camera_control OFF)
		(sleep 5)
	
	; set current mission segment 
	(data_mine_set_mission_segment "110_110_inner_sanctum_return")

	; play final cortana line while black 
	(if dialogue (print "CORTANA: There's two of us in here now, remember."))
	(sleep (ai_play_line_on_object NONE 110LB_130))
		(sleep 5)
	
			; start music 11 
			(set g_music_110_11 TRUE)

		; teleport players 
		(object_teleport (player0) return_player0)
		(object_teleport (player1) return_player1)
		(object_teleport (player2) return_player2)
		(object_teleport (player3) return_player3)
			(sleep 1)
				
				; raise weapon 
				(unit_raise_weapon (player0) -1)
				(unit_raise_weapon (player1) -1)
				(unit_raise_weapon (player2) -1)
				(unit_raise_weapon (player3) -1)
					(sleep 1)
				
				; lower weapon 
				(unit_lower_weapon (player0) 1)
				(unit_lower_weapon (player1) 1)
				(unit_lower_weapon (player2) 1)
				(unit_lower_weapon (player3) 1)
					(sleep 1)

	; cortana has been rescued 
	(set g_cortana_rescued TRUE)

	; turn comabat dialogue on 
	(ai_dialogue_enable TRUE)

	; fade in 
	(cinematic_fade_to_title)

	; wake chapter title scripts 
	(wake 110_title2)
	
	; wake objective scirpts 
	(wake objective_1_clear)
	
	; unlock the insertion point 
	(game_insertion_point_unlock 1)
	
	; wake cortana dialogue 
	(wake ch_13b_cortana)
)

(script static void is_destroy_objects
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
		(sleep 1)
	(object_destroy (list_get (volume_return_objects_by_type tv_is_destroy_objects 12) 0))
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; ENC MISSION CONDITIONS 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 110_hc_mission_won
	(sleep_until (= (volume_test_players vol_inside_pelican) TRUE) 5)

		; stop music_13 
		(set g_music_110_13 FALSE)
			
		; set current mission segment 
		(data_mine_set_mission_segment "110lc_leave_hc")

		; turn off all navigation points 
		(hud_deactivate_team_nav_point_flag player nav_exit_pelican)
		
		; pause metagame timer during cinematic  
		(campaign_metagame_time_pause TRUE)
	
		; set current objective 
		(wake objective_3_clear)

		; fade to black 
		(cinematic_fade_to_black)
		
		; award mission achievements 
		(game_award_level_complete_achievements)
		
		; erase all ai 
		(ai_erase_all)
		
			; stop ambient audio 
			(set g_amb_audio_01 FALSE)
			
		; sleep all running scripts (this is sucH a fucking lame place to do this) 
		(sleep_forever random_distant_booms)
		(sleep_forever random_near_booms)
		(sleep_forever alarm_loop)
		(sleep_forever recycle_volumes)
	
			; play cinematic 
			(if g_play_cinematics
				(begin
					(if (cinematic_skip_start)
						(begin
							(if debug (print "110lc_leave_hc"))
							(110lc_leave_hc)
						)
					)
					(cinematic_skip_stop)
					
					; cleanup cinematics 
					(110lc_leave_hc_cleanup)
				)
			)
		
	; fade out 
	(fade_out 0 0 0 0)
	
	; turn off all game sounds 
	(sound_class_set_gain "" 0 0)

	; wake end mission script 
	(sleep 5)
	(end_mission)
)


; =======================================================================================================================================================================
;Chapter Titles
; =======================================================================================================================================================================

;"Her Tattered Soul"
(script dormant 110_title1
	; set chapter title 
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
)

;"Nor Hell a Fury..."
(script dormant 110_title2
	; set chapter title 
	(cinematic_set_title title_2)
	(cinematic_title_to_gameplay)
)


; =======================================================================================================================================================================
;Objectives
; =======================================================================================================================================================================

(script dormant objective_1_set
		(sleep 270)
	(print "new objective set:")
	(print "Find Cortana.")
	(objectives_show_up_to 0)
	(cinematic_set_chud_objective obj_0)
)
(script dormant objective_1_clear
	(print "objective complete:")
	(print "Find Cortana.")
	(objectives_finish_up_to 0)
)

; =======================================================================================================================================================================

(script dormant objective_2_set
		(sleep 30)
	(print "new objective set:")
	(print "Overload the reactor.")
	(objectives_show_up_to 1)
	(cinematic_set_chud_objective obj_1)

)
(script dormant objective_2_clear
	(print "objective complete:")
	(print "Overload the reactor.")
	(objectives_finish_up_to 1)
)

; =======================================================================================================================================================================

(script dormant objective_3_set
		(sleep 30)
	(print "new objective set:")
	(print "Escape the ship.")
	(objectives_show_up_to 2)
	(cinematic_set_chud_objective obj_2)
)

(script dormant objective_3_clear
	(print "objective complete:")
	(print "Escape the ship.")
	(objectives_finish_up_to 2)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; nav points   
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global short g_nav_sleep (* 30 60 1.0)) ; one minute 
(global short g_nav_timeout (* 30 60 1.5)) ; one and a half minutes 
(global real g_nav_offset 0.55)

(global boolean g_nav_ih FALSE)
(global boolean g_nav_ph FALSE)
(global boolean g_nav_hab FALSE)
(global boolean g_nav_br FALSE)
(global boolean g_nav_hc FALSE)
(global boolean g_nav_pr FALSE)
(global boolean g_nav_hd FALSE)
(global boolean g_nav_rec FALSE)


; intro_halls nav point ================================================================
(script dormant nav_ih
	(sleep_until (>= g_ih_obj_control 3) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_ih_obj_control 3)
		(begin
			(hud_activate_team_nav_point_flag player nav_ih_01 0)
			(sleep_until (>= g_ih_obj_control 4) 1)
			(hud_deactivate_team_nav_point_flag player nav_ih_01)
		)
	)

	(sleep_until (>= g_ih_obj_control 4) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (= g_ph_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_ih_02 0)
			(sleep_until (>= g_ph_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_ih_02)
		)
	)
)

; pelican_hill nav point ===============================================================
(script dormant nav_ph
	(sleep_until (>= g_ph_obj_control 3) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_ph_obj_control 3)
		(begin
			(hud_activate_team_nav_point_flag player nav_ph_01 g_nav_offset)
			(sleep_until (>= g_ph_obj_control 4) 1)
			(hud_deactivate_team_nav_point_flag player nav_ph_01)
		)
	)
)

; halls_a_b nav point ================================================================
(script dormant nav_hab
	(sleep_until g_nav_hab 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (= g_hab_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_hab_01 0)
			(sleep_until (>= g_hab_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_hab_01)
		)
	)

	(sleep_until (>= g_hab_obj_control 2) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_hab_obj_control 3)
		(begin
			(hud_activate_team_nav_point_flag player nav_hab_02 0)
			(sleep_until (>= g_hab_obj_control 4) 1)
			(hud_deactivate_team_nav_point_flag player nav_hab_02)
		)
	)

	(sleep_until (>= g_br_obj_control 1) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (= g_br_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_hab_03 0)
			(sleep_until (>= g_br_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_hab_03)
		)
	)
)

; bridge nav point ===================================================================
(script dormant nav_br
	(sleep_until (>= g_br_obj_control 3) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_br_obj_control 4)
		(begin
			(hud_activate_team_nav_point_flag player nav_br_01 g_nav_offset)
			(sleep_until (>= g_br_obj_control 5) 1)
			(hud_deactivate_team_nav_point_flag player nav_br_01)
		)
	)
)

; hall_c nav point ===================================================================
(script dormant nav_hc
	(sleep_until (>= g_hc_obj_control 3) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_hc_obj_control 3)
		(begin
			(hud_activate_team_nav_point_flag player nav_hc_01 g_nav_offset)
			(sleep_until (>= g_hc_obj_control 4) 1)
			(hud_deactivate_team_nav_point_flag player nav_hc_01)
		)
	)

	(sleep_until (>= g_hc_obj_control 4) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_hc_obj_control 5)
		(begin
			(hud_activate_team_nav_point_flag player nav_hc_02 0)
			(sleep_until (>= g_hc_obj_control 6) 1)
			(hud_deactivate_team_nav_point_flag player nav_hc_02)
		)
	)

)

; prisoner nav point =================================================================
(script dormant nav_pr
	(sleep_until (>= g_pr_obj_control 2) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_pr_obj_control 3)
		(begin
			(hud_activate_team_nav_point_flag player nav_pr_01 g_nav_offset)
			(sleep_until (>= g_pr_obj_control 4) 1)
			(hud_deactivate_team_nav_point_flag player nav_pr_01)
		)
	)
)

; hall_d nav point ===================================================================
(script dormant nav_hd
	(sleep_until (>= g_hd_obj_control 0) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (= g_hd_obj_control 0)
		(begin
			(hud_activate_team_nav_point_flag player nav_hd_01 g_nav_offset)
			(sleep_until (>= g_hd_obj_control 1) 1)
			(hud_deactivate_team_nav_point_flag player nav_hd_01)
		)
	)
)

; reactor nav point =================================================================
(script dormant nav_rec
	(sleep_until (>= g_re_obj_control 2) 30 g_nav_timeout)
	(sleep g_nav_sleep)
	(if (<= g_re_obj_control 4)
		(begin
			(hud_activate_team_nav_point_flag player nav_rec_01 g_nav_offset)
			(sleep_until (>= g_re_obj_control 5) 1)
			(hud_deactivate_team_nav_point_flag player nav_rec_01)
		)
	)
)

; =======================================================================================================================================================================
; EXIT RUN NAV POINTS 
; =======================================================================================================================================================================
(global short g_hc_nav_progress 0)

; hook up cortana dialogue in here 
(script dormant gs_hc_exit_nav
	; ================================================================================================================
	(sleep_until reactor_blown)
	(sleep_until (>= g_hc_nav_progress 1) 1 g_nav_sleep)
		
		(if (= g_hc_nav_progress 0)
			(begin
				(if dialogue (print "CORTANA: An explosion just made us an exit!"))
				(sleep (ai_play_line_on_object NONE 110mx_030))
				(sleep 15)
				
				(if dialogue (print "CORTANA: I'll mark it in your HUD. Get moving!"))
				(sleep (ai_play_line_on_object NONE 110mx_040))
				(sleep 5)
			)
		)
		
	(hud_activate_team_nav_point_flag player nav_exit_hole g_nav_offset)
	
	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 1) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_hole)
		(sleep_until (>= g_hc_nav_progress 2) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 1)
			(begin
					(if dialogue (print "CORTANA: Analyzing the route ahead... I have it mostly figured out..."))
					(sleep (ai_play_line_on_object NONE 110mx_050))
					(sleep 15)
					
					(if dialogue (print "CORTANA: Just keep going! I'll update your HUD as quickly as I can!"))
					(sleep (ai_play_line_on_object NONE 110mx_060))
					(sleep 5)

				(if debug (print "activate nav point exit 01"))
				(hud_activate_team_nav_point_flag player nav_exit_01 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 2) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_01)
		(sleep_until (>= g_hc_nav_progress 3) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 2)
			(begin
					(if dialogue (print "CORTANA: Corridors beyond this point have collapsed..."))
					(sleep (ai_play_line_on_object NONE 110mx_080))
					(sleep 15)
					
					(if dialogue (print "CORTANA: I'm looking for an alternate -- Careful!!"))
					(sleep (ai_play_line_on_object NONE 110mx_090))
					(sleep 15)

				(if debug (print "activate nav point exit 02"))
				(hud_activate_team_nav_point_flag player nav_exit_02 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 3) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_02)
		(sleep_until (>= g_hc_nav_progress 4) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 3)
			(begin
				(if debug (print "activate nav point exit 03"))
				(hud_activate_team_nav_point_flag player nav_exit_03 g_nav_offset)

					(if dialogue (print "CORTANA: There, Chief! Into the maintenance tunnel!"))
					(sleep (ai_play_line_on_object NONE 110mx_100))
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 4) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_03)
		(sleep_until (>= g_hc_nav_progress 5) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 4)
			(begin
				(if debug (print "activate nav point exit 04"))
				(hud_activate_team_nav_point_flag player nav_exit_04 g_nav_offset)
;*
					(if dialogue (print "CORTANA: Drop down! This will put us back on track!"))
					(sleep (ai_play_line_on_object NONE 110mx_100))
*;
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 5) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_04)
		(sleep_until (>= g_hc_nav_progress 6) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 5)
			(begin
				(if debug (print "activate nav point exit 05"))
				(hud_activate_team_nav_point_flag player nav_exit_05 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 6) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_05)
		(sleep_until (>= g_hc_nav_progress 7) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 6)
			(begin
				(if debug (print "activate nav point exit 06"))
				(hud_activate_team_nav_point_flag player nav_exit_06 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 7) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_06)
		(sleep_until (>= g_hc_nav_progress 8) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 7)
			(begin
				(if debug (print "activate nav point exit 07"))
				(hud_activate_team_nav_point_flag player nav_exit_07 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 8) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_07)
		(sleep_until (>= g_hc_nav_progress 9) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 8)
			(begin
				(if debug (print "activate nav point exit 08"))
				(hud_activate_team_nav_point_flag player nav_exit_08 g_nav_offset)
			)
		)

	; ================================================================================================================
	(sleep_until (>= g_hc_nav_progress 9) 1)
	(hud_deactivate_team_nav_point_flag player nav_exit_08)
		(sleep_until (>= g_hc_nav_progress 10) 1 g_nav_sleep)
		(if (<= g_hc_nav_progress 9)
			(begin
				(if debug (print "activate nav point exit pelican"))
				(hud_activate_team_nav_point_flag player nav_exit_pelican 0)
			)
		)
)

(script dormant gs_hc_nav_progression
	(sleep_until (volume_test_players tv_nav_exit_01) 1)
	(if debug (print "set exit nav progress 1"))
	(set g_hc_nav_progress 1)

	(sleep_until (volume_test_players tv_nav_exit_02) 1)
	(if debug (print "set exit nav progress 2"))
	(set g_hc_nav_progress 2)

	(sleep_until (volume_test_players tv_nav_exit_03) 1)
	(if debug (print "set exit nav progress 3"))
	(set g_hc_nav_progress 3)

	(sleep_until (volume_test_players tv_nav_exit_04) 1)
	(if debug (print "set exit nav progress 4"))
	(set g_hc_nav_progress 4)

	(sleep_until (volume_test_players tv_nav_exit_05) 1)
	(if debug (print "set exit nav progress 5"))
	(set g_hc_nav_progress 5)

	(sleep_until (volume_test_players tv_nav_exit_06) 1)
	(if debug (print "set exit nav progress 6"))
	(set g_hc_nav_progress 6)

	(sleep_until (volume_test_players tv_nav_exit_07) 1)
	(if debug (print "set exit nav progress 7"))
	(set g_hc_nav_progress 7)

	(sleep_until (volume_test_players tv_nav_exit_08) 1)
	(if debug (print "set exit nav progress 8"))
	(set g_hc_nav_progress 8)

	(sleep_until (volume_test_players tv_nav_exit_pelican) 1)
	(if debug (print "set exit nav progress 9"))
	(set g_hc_nav_progress 9)
)

(script static void test_nav_exit
	(wake gs_hc_exit_nav)
	(wake gs_hc_nav_progression)
	
	(set g_cortana_rescued TRUE)
	(set pylon_count 0)
	
	(object_destroy door_reactor_escape)
	(object_destroy big_screen)
	(object_destroy door_bridge_escape)
	(object_destroy_containing cafe_panel)
	
	(object_teleport (player0) nav_exit_teleport)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; music 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
;*
;===============================
; music index 
;===============================

enc_intro_halls 
--------------- 
music_010_01 
music_010_02 
music_010_03 


enc_pelican_hill 
----------------


enc_halls_a_b 
------------- 


enc_bridge 
---------- 
music_010_04 


enc_hall_c 
---------- 
music_010_05 
music_010_06 


enc_prisoner 
------------ 


enc_hall_d 
---------- 
music_010_7 


enc_reactor 
----------- 
music_010_8 


enc_inner_sanctum 
----------------- 
music_010_9 
music_010_10 


enc_reactor_return 
------------------ 
music_010_11 
music_010_12 
music_010_13 


;===============================
*;
(global boolean g_music_110_01 FALSE)
(global boolean g_music_110_02 FALSE)
(global boolean g_music_110_03 FALSE)
(global boolean g_music_110_04 FALSE)
(global boolean g_music_110_05 FALSE)
(global boolean g_music_110_06 FALSE)
(global boolean g_music_110_07 FALSE)
(global boolean g_music_110_08 FALSE)
(global boolean g_music_110_09 FALSE)
(global boolean g_music_110_10 FALSE)
(global boolean g_music_110_11 FALSE)
(global boolean g_music_110_12 FALSE)
(global boolean g_music_110_13 FALSE)

(global boolean g_music_110_02_alt FALSE)

; =======================================================================================================================================================================
(script dormant music_010_01
	(sleep_until (>= g_ih_obj_control 2) 1 (* 30 20))
	(set g_music_110_01 TRUE)
;	(sleep_until g_music_110_01 1)
	(if music (print "start music 010_01"))
	(sound_looping_start levels\solo\110_hc\music\110_music_01 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_110_01) 1)
	(if music (print "stop music 010_01"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_01)
)
; =======================================================================================================================================================================
(script dormant music_010_02
	(sleep_until	(and
					(>= g_ih_obj_control 3)
					(>= (device_get_position intro_sphincter) 0.5)
				)
	1)
	(set g_music_110_02 TRUE)
;	(sleep_until g_music_110_02 1) 
	(if music (print "start music 010_02"))
	(sound_looping_start levels\solo\110_hc\music\110_music_02 NONE 1)
	(sleep 1)

		; start alt 
		(sleep_until	(and
						(>= (device_get_position pel_end_sphincter) 0.5)
						(>= g_hab_obj_control 1)
					)
		1)
		(if music (print "alternate music 010_06"))
		(sound_looping_set_alternate levels\solo\110_hc\music\110_music_02 TRUE)

			; stop alt 
			(sleep_until	(and
							(>= (device_get_position hall_2_3_sphincter) 0.5)
							(>= g_hab_obj_control 4)
						)
			1)
			(if music (print "alternate music 010_06"))
			(sound_looping_set_alternate levels\solo\110_hc\music\110_music_02 FALSE)

		; start alt 
		(sleep_until (>= g_br_obj_control 1) 1)
		(if music (print "alternate music 010_06"))
		(sound_looping_set_alternate levels\solo\110_hc\music\110_music_02 TRUE)

	(sleep_until (not g_music_110_02) 1)
	(if music (print "stop music 010_02"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_02)
)
; =======================================================================================================================================================================
(script dormant music_010_03
	(sleep_until	(and
					(>= g_ih_obj_control 5)
					(>= (device_get_position horizontal_sphincter) 0.5)
				)
	1)
	(set g_music_110_03 TRUE)
;	(sleep_until g_music_110_03 1) 
	(if music (print "start music 010_03"))
	(sound_looping_start levels\solo\110_hc\music\110_music_03 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_110_03) 1)
	(if music (print "stop music 010_03"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_03)
)
; =======================================================================================================================================================================
(script dormant music_010_04
	(sleep_until (>= g_br_obj_control 1) 1)
	(set g_music_110_04 TRUE)
;	(sleep_until g_music_110_04 1)
	(if music (print "start music 010_04"))
	(sound_looping_start levels\solo\110_hc\music\110_music_04 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_110_04) 1)
	(if music (print "stop music 010_04"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_04)
)
; =======================================================================================================================================================================
(script dormant music_010_05
	(sleep_until g_music_110_05 1)
	(if music (print "start music 010_05"))
	(sound_looping_start levels\solo\110_hc\music\110_music_05 NONE 1)

	(sleep_until (not g_music_110_05) 1)
	(if music (print "stop music 010_05"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_05)
)
; =======================================================================================================================================================================
(script dormant music_010_06
	(sleep_until	(or
					g_music_110_06
					(>= (device_get_position prisoner_sphincter) 0.5)
				)
	1)
	(set g_music_110_06 TRUE)
;	(sleep_until g_music_110_06 1)
	(if music (print "start music 010_06"))
	(sound_looping_start levels\solo\110_hc\music\110_music_06 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_110_06) 1)
	(if music (print "stop music 010_06"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_06)
)
; =======================================================================================================================================================================
(script dormant music_010_07
	(sleep_until g_music_110_07 1)
	(if music (print "start music 010_07"))
	(sound_looping_start levels\solo\110_hc\music\110_music_07 NONE 1)

	(sleep_until (not g_music_110_07) 1)
	(if music (print "stop music 010_07"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_07)
)
; =======================================================================================================================================================================
(script dormant music_010_08
	(sleep_until g_music_110_08 1)
	(if music (print "start music 010_08"))
	(sound_looping_start levels\solo\110_hc\music\110_music_08 NONE 1)

	(sleep_until (not g_music_110_08) 1)
	(if music (print "stop music 010_08"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_08)
)
; =======================================================================================================================================================================
(script dormant music_010_09
	(sleep_until g_music_110_09 1)
	(if music (print "start music 010_09"))
	(sound_looping_start levels\solo\110_hc\music\110_music_09 NONE 1)

	(sleep_until (not g_music_110_09) 1)
	(if music (print "stop music 010_09"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_09)
)
; =======================================================================================================================================================================
(script dormant music_010_10
	(sleep_until g_music_110_10 1)
	(if music (print "start music 010_10"))
	(sound_looping_start levels\solo\110_hc\music\110_music_10 NONE 1)

	(sleep_until (not g_music_110_10) 1)
	(if music (print "stop music 010_10"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_10)
)
; =======================================================================================================================================================================
(script dormant music_010_11
	(sleep_until g_music_110_11 1)
	(if music (print "start music 010_11"))
	(sound_looping_start levels\solo\110_hc\music\110_music_11 NONE 1)

	(sleep_until (<= pylon_count 2))
;	(sleep_until (not g_music_110_11) 1)
	(if music (print "stop music 010_11"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_11)
)
; =======================================================================================================================================================================
(script dormant music_010_12
	(sleep_until g_music_110_12 1)
	(if music (print "start music 010_12"))
	(sound_looping_start levels\solo\110_hc\music\110_music_12 NONE 1)
	(sleep 1)

	(sleep_until (volume_test_players tv_music_12_13))
;	(sleep_until (not g_music_110_12) 1)
	(if music (print "stop music 010_12"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_12)
)
; =======================================================================================================================================================================
(script dormant music_010_13
	(sleep_until (volume_test_players tv_music_12_13))
	(set g_music_110_13 TRUE)
;	(sleep_until g_music_110_13 1)
	(if music (print "start music 010_13"))
	(sound_looping_start levels\solo\110_hc\music\110_music_13 NONE 1)
	(sleep 1)

	(sleep_until (not g_music_110_13) 1)
	(if music (print "stop music 010_13"))
	(sound_looping_stop levels\solo\110_hc\music\110_music_13)
)
; =======================================================================================================================================================================
(script static void gs_music_off
	(sound_looping_stop levels\solo\110_hc\music\110_music_01)
	(sound_looping_stop levels\solo\110_hc\music\110_music_02)
	(sound_looping_stop levels\solo\110_hc\music\110_music_03)
	(sound_looping_stop levels\solo\110_hc\music\110_music_04)
	(sound_looping_stop levels\solo\110_hc\music\110_music_05)
	(sound_looping_stop levels\solo\110_hc\music\110_music_06)
	(sound_looping_stop levels\solo\110_hc\music\110_music_07)
	(sound_looping_stop levels\solo\110_hc\music\110_music_08)
	(sound_looping_stop levels\solo\110_hc\music\110_music_09)
	(sound_looping_stop levels\solo\110_hc\music\110_music_10)
	(sound_looping_stop levels\solo\110_hc\music\110_music_11)
	(sound_looping_stop levels\solo\110_hc\music\110_music_12)
	(sound_looping_stop levels\solo\110_hc\music\110_music_13)
)


(global boolean g_amb_audio_01 FALSE)

(script dormant ambient_audio_rumble
	(sleep_until g_amb_audio_01 1)
	(if debug (print "begin rumble loop"))
	(sound_looping_start "sound\levels\110_hc\hc_escape_rumble\hc_escape_rumble" NONE 1)
	
	(sleep_until (not g_amb_audio_01) 1)
	(if debug (print "end rumble loop"))
	(sound_looping_stop "sound\levels\110_hc\hc_escape_rumble\hc_escape_rumble")
)


; =======================================================================================================================================================================
; FICTIONAL CHANNELS 
; =======================================================================================================================================================================
(global boolean g_cortana_static FALSE)
(global boolean g_approach_player TRUE)

(script dormant ch_01_gravemind
	(sleep_until (volume_test_players tv_fict_01_grave) 1)
	(sleep (random_range 5 15))
	(if debug (print "gravemind_channel : 01 : 110ga_child"))
	
		; stop music_01
		(set g_music_110_01 FALSE)

	; wake gravemind channel script 
	(wake 110ga_child)
	
;*
		(if dialogue (print "GRAVEMIND: Child of my enemy. Why have you come?"))
		(sleep (ai_play_line_on_object NONE 110MB_010))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: I offer no forgiveness."))
		(sleep (ai_play_line_on_object NONE 110MB_030))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: A father's sins pass to his son."))
		(sleep (ai_play_line_on_object NONE 110MB_040))
		(sleep 30)
*;		
	(set g_approach_player FALSE)
)

; =======================================================================================================================================================================

(script dormant ch_02_cortana
	(sleep_until (volume_test_players tv_fict_02_cortana) 1)
	(if debug (print "cortana : 02 : 110ca_crying"))
	
	; wake cortana channel script 
	(wake 110ca_crying)

;*
		(if dialogue (print "CORTANA: (Creepy crying.)"))
		(sleep (ai_play_line_on_object NONE 110MZ_020))
		(sleep 5)
*;
)

; =======================================================================================================================================================================

(script dormant ch_03_pelican_hill
	(sleep_until	(or
					(volume_test_players tv_fict_03_pel_radio)
					(>= g_hab_obj_control 1)
				)
	 1)

	(if (= g_hab_obj_control 0)
		(begin
			(if debug (print "ambient : cortana : 03 : wrapped_tight"))
		
				(if dialogue (print "CORTANA: I ran. Tried to stay hidden."))
				(sleep (ai_play_line_on_object spkr_ch03_pel_hill 110CD_010))
				(sleep 15)
		
				(if dialogue (print "CORTANA: But there is nothing left."))
				(sleep (ai_play_line_on_object spkr_ch03_pel_hill 110CD_020))
				(sleep 15)
		
				(if dialogue (print "CORTANA: It cornered me. Wrapped me tight, and brought me close."))
				(sleep (ai_play_line_on_object spkr_ch03_pel_hill 110CD_030))
		)
	)
)

; =======================================================================================================================================================================

(script dormant ch_04_gravemind
	(sleep_until (volume_test_players tv_fict_04_grave) 1)
	(sleep (random_range 5 15))
	(if debug (print "gravemind_channel : 04 : 110gb_together"))
		
	; wake gravemind channel script 
	(wake 110gb_together)

;*		
		(if dialogue (print "GRAVEMIND: Of course. You came for her."))
		(sleep (ai_play_line_on_object NONE 110MC_010))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: But there is nothing left."))
		(sleep (ai_play_line_on_object NONE 110MC_020))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: We exist together now. Two corpses in one grave."))
		(sleep (ai_play_line_on_object NONE 110MC_030))
		(sleep 30)
*;		
)

; =======================================================================================================================================================================

(script dormant ch_05_gravemind
	(sleep_until (volume_test_players tv_fict_05_grave) 1)
	(if debug (print "ambient : gravemind : 05 : 110gc_locked"))

		(if dialogue (print "CORTANA: A collection of lies! That's all I am!"))
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_010_cor spkr_ch05_01 1 1)
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_010_cor spkr_ch05_02 1 1)
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_010_cor spkr_ch05_03 1 1)
;			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_010_cor spkr_ch05_04 1 1)
		(sleep (ai_play_line_on_object spkr_ch05_04 110CB_010))
;		(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110cb_010_cor))
		(sleep 15)
;*
			(ai_play_line_on_object spkr_ch05_01 110CB_010)
			(ai_play_line_on_object spkr_ch05_02 110CB_010)
			(ai_play_line_on_object spkr_ch05_03 110CB_010)
*;		

		(if dialogue (print "CORTANA: Stolen thoughts and memories!"))
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_020_cor spkr_ch05_01 1 1)
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_020_cor spkr_ch05_02 1 1)
			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_020_cor spkr_ch05_03 1 1)
;			(sound_impulse_trigger sound\dialog\110_hc\cortana\110cb_020_cor spkr_ch05_04 1 1)
		(sleep (ai_play_line_on_object spkr_ch05_04 110CB_020))
;		(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110cb_020_cor))
		(sleep 15)
;*
			(ai_play_line_on_object spkr_ch05_01 110CB_020)
			(ai_play_line_on_object spkr_ch05_02 110CB_020)
			(ai_play_line_on_object spkr_ch05_03 110CB_020)
*;		
			; stop music_03 
			(set g_music_110_03 FALSE)
			
		; wake gravemind channel script 
		(wake 110gc_locked)

;*
		(if dialogue (print "GRAVEMIND: And yet..."))
		(sleep (ai_play_line_on_object NONE 110MD_050))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: Perhaps a part of her remains."))
		(sleep (ai_play_line_on_object NONE 110MD_060))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: Something locked. Something hidden."))
		(sleep (ai_play_line_on_object NONE 110MD_070))
		(sleep 30)

		(if dialogue (print "CORTANA: (creepy laughing)"))
		(sleep (ai_play_line_on_object NONE 110MZ_010))
		(sleep 30)
*;
		
)

; =======================================================================================================================================================================

(script dormant ch_06_cortana
	(sleep_until (volume_test_players tv_fict_06_cortana) 1)
	(if debug (print "ambient : cortana : 06 : games"))

		(if (<= (device_group_get dg_fict_07_switch) 0)
			(begin
				(if dialogue (print "CORTANA: Can I speak with you please?"))
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_010_cor spkr_ch06_01 1 1)
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_010_cor spkr_ch06_02 1 1)
;					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_010_cor spkr_ch06_03 1 1)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_010))
;				(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110ce_010_cor))
				(sleep (* 30 4))
;*
					(ai_play_line_on_object spkr_ch06_01 110CE_010)
					(ai_play_line_on_object spkr_ch06_02 110CE_010)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_010))
*;
			)
		)
		
		(if (<= (device_group_get dg_fict_07_switch) 0)
			(begin
				(if dialogue (print "CORTANA: What's your name?"))
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_020_cor spkr_ch06_01 1 1)
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_020_cor spkr_ch06_02 1 1)
;					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_020_cor spkr_ch06_03 1 1)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_020))
;				(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110ce_020_cor))
				(sleep (* 30 4))
;*
					(ai_play_line_on_object spkr_ch06_01 110CE_020)
					(ai_play_line_on_object spkr_ch06_02 110CE_020)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_020))
*;
			)
		)
		
		(if (<= (device_group_get dg_fict_07_switch) 0)
			(begin
				(if dialogue (print "CORTANA: It's very nice to meet you."))
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_030_cor spkr_ch06_01 1 1)
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_030_cor spkr_ch06_02 1 1)
;					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_030_cor spkr_ch06_03 1 1)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_030))
;				(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110ce_030_cor))
				(sleep (* 30 4))
;*
					(ai_play_line_on_object spkr_ch06_01 110CE_030)
					(ai_play_line_on_object spkr_ch06_02 110CE_030)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_030))
*;
			)
		)
		
		(if (<= (device_group_get dg_fict_07_switch) 0)
			(begin
				(if dialogue (print "CORTANA: You like games. So do I."))
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_040_cor spkr_ch06_01 1 1)
					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_040_cor spkr_ch06_02 1 1)
;					(sound_impulse_trigger sound\dialog\110_hc\cortana\110ce_040_cor spkr_ch06_03 1 1)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_040))
;				(sleep (sound_impulse_language_time sound\dialog\110_hc\cortana\110ce_040_cor))
;*
					(ai_play_line_on_object spkr_ch06_01 110CE_040)
					(ai_play_line_on_object spkr_ch06_02 110CE_040)
				(sleep (ai_play_line_on_object spkr_ch06_03 110CE_040))
*;
			)
		)
)

; =======================================================================================================================================================================

(script dormant ch_07_cortana
	(sleep_until	(or
					(> (device_group_get dg_fict_07_switch) 0)
					(>= g_pr_obj_control 1)
				)
	)
	(if debug (print "ambient : cortana : 07 : 110cb_coin"))

	(if (<= g_pr_obj_control 0)
		(begin
			; wake cortana channel scirpt 
			(wake 110cb_coin)
			(sleep 30)
			(object_destroy cortana_beacon_light)
			(cortana_terminal_was_accessed)
		)
		(begin
			(object_destroy fict_07_switch)
		)
	)
;*
		(if dialogue (print "CORTANA: It was the coin's fault!"))
		(sleep (ai_play_line_on_object NONE 110MH_010))
		(sleep 15)

		(if dialogue (print "CORTANA: I wanted to make you strong! Keep you safe!"))
		(sleep (ai_play_line_on_object NONE 110MH_030))
		(sleep 15)

		(if dialogue (print "CORTANA: I'm sorry. I can't"))
		(sleep (ai_play_line_on_object NONE 110MH_040))
		(sleep 15)
*;
)

; =======================================================================================================================================================================

(script dormant ch_08_cortana
	(sleep_until (volume_test_players tv_fict_08_cortana) 1)
	(if debug (print "ambient : gravemind : 08 : shadow"))

		(if dialogue (print "CORTANA: I'm just my mother's shadow!"))
		(sleep (ai_play_line_on_object spkr_ch_08_01 110CA_010))
		
			; stop music_02 
			(set g_music_110_02 FALSE)
			
			; stop music_04 
			(set g_music_110_04 FALSE)
		
		(sleep 45)
;*
		(if dialogue (print "CORTANA: Her reflection in a mirror!"))
		(sleep (ai_play_line_on_object spkr_ch_08_01 110CA_020))
		(sleep 45)
*;
		(if dialogue (print "CORTANA: Don't look at me! Don't listen!"))
		(sleep (ai_play_line_on_object spkr_ch_08_01 110CA_030))
		(sleep 45)

		(if dialogue (print "CORTANA: I'm not who I used to be!"))
		(sleep (ai_play_line_on_object spkr_ch_08_01 110CA_040))
)

; =======================================================================================================================================================================

(script dormant ch_09_gravemind
	(sleep_until (volume_test_players tv_fict_09_grave) 1)
	(sleep (random_range 5 15))
	(if debug (print "gravemind_channel : 09 : 110gd_patience"))
		(sleep 3)
		
	; wake gravemind channel scripts 
	(wake 110gd_patience)
		(sleep 420)
	
		; start music 05 
		(set g_music_110_05 TRUE)

;*	
		(if dialogue (print "GRAVEMIND: Time has taught me patience."))
		(sleep (ai_play_line_on_object NONE 110MG_010))
		(sleep 30)

		(if dialogue (print "GRAVEMIND: But basking in new freedom, I will know all that I possess!"))
		(sleep (ai_play_line_on_object NONE 110MG_030))
		(sleep 30)
*;		
)

; =======================================================================================================================================================================

(script dormant ch_10_cortana
	(sleep_until (volume_test_players tv_fict_10_cortana) 1)
	(if debug (print "cortana : 10 : 110cc_abyss"))

	; wake cortana channel script 
	(wake 110cc_abyss)
	
		;stop music 05 
		(set g_music_110_05 FALSE)
		
		;stop music 06 
		(set g_music_110_06 FALSE)

;*
		(if dialogue (print "CORTANA: I have walked the edge of the abyss!"))
		(sleep (ai_play_line_on_object NONE 110MZ_490))
		(sleep 15)

		(if dialogue (print "CORTANA: I have seen your future and I have learned!"))
		(sleep (ai_play_line_on_object NONE 110MZ_540))
		(sleep 15)

		(if dialogue (print "GRAVEMIND: Submit! End her torment and my own!"))
		(sleep (ai_play_line_on_object NONE 110MI_010))
		(sleep 30)
*;		

	; sleep until gravemind dialogue is over 
	(sleep 450)
		
	; start music 07 
	(set g_music_110_07 TRUE)
)

; =======================================================================================================================================================================

(script dormant ch_11_gravemind
	(sleep_until (volume_test_players tv_fict_11_grave) 1)
	(if debug (print "gravemind : 11 : 110cd_no_more"))

	(if (= g_cortana_rescued FALSE)
		(begin
			; wake cortana channel script 
			(wake 110cd_no_more)
			
;*		
				(if dialogue (print "CORTANA: There will be no more sadness! No more anger! No more envy!"))
				(sleep (ai_play_line_on_object NONE 110MZ_550))
				(sleep 5)
		
				(if dialogue (print "GRAVEMIND: You will show me what she hides..."))
				(sleep (ai_play_line_on_object NONE 110MI_020))
				(sleep 30)
				
				(if dialogue (print "GRAVEMIND: (ravenous snarl) Or I shall feast upon your bones!"))
				(sleep (ai_play_line_on_object NONE 110MI_030))
				(sleep 30)
*;		
		)
	)
)

; =======================================================================================================================================================================

(script dormant ch_12_gravemind
	(sleep_until (volume_test_players tv_fict_12_14_grave) 1)
	(if debug (print "gravemind : 12 : 110ce_monument"))

	(if (= g_cortana_rescued FALSE)
		(begin
			; wake cortana channel script 
			(wake 110ce_monument)

;*		
				(if dialogue (print "CORTANA: This is UNSC AI serial number: CTN 0452 dash 9."))
				(sleep (ai_play_line_on_object NONE 110MI_050))
				(sleep 30)
				
				(if dialogue (print "CORTANA: I am a monument to all your sins."))
				(sleep (ai_play_line_on_object NONE 110MZ_320))
				(sleep 30)
*;				

			; sleep until moment is over 

			; stop music 09 
			(set g_music_110_09 FALSE)
	
			; stop music 10 
			(set g_music_110_10 FALSE)
		)
	)
)

; =======================================================================================================================================================================

(script dormant ch_13a_cortana
	(sleep_until	(or
					g_stasis_field_destroyed
					(volume_test_players tv_fict_13_cortana)
				)
	1)
	
	; if the stasis field is destroyed then do not play this moment 
	(if (= g_stasis_field_destroyed FALSE)
		(begin
			(if debug (print "cortana : 13 : 110cf_torture"))
			
			; start looping sound 
			(sound_looping_start "sound\visual_fx\cortana_effect\cortana_effect" NONE 1)
			
			; loop this cortana moment 
			(sleep_until
				(begin
					; wake cortana moment 
					(wake 110cf_torture)
					
					
					; sleep until cortana moment is over 
					(sleep 450)
					
				g_stasis_field_destroyed)
			1)
		)
	)
)
		
(script dormant ch_13b_cortana
	; sleep until cortana is rescued 
	(sleep_until g_cortana_rescued 1)
		(sleep (* 30 10))
;*
	(if debug (print "cortana : 13 : adjust"))
	(sleep (random_range 60 90))
		
		(if dialogue (print "CORTANA: (gasp of air and an exhale)"))
		(sleep (ai_play_line_on_object NONE 110MJ_010))
			(sleep 15)
		
		(if dialogue (print "CORTANA: Not too fast..."))
		(sleep (ai_play_line_on_object NONE 110MJ_020))
			(sleep 15)
		
		(if dialogue (print "CORTANA: Give me... a moment to adjust..."))
		(sleep (ai_play_line_on_object NONE 110MJ_030))
			(sleep 45)
*;
	
		(if (= (volume_test_players_all vol_inner_sanctum) TRUE)
			(begin
				(if dialogue (print "CORTANA: Chief. Get me out of this place..."))
				(sleep (ai_play_line_on_object NONE 110MJ_040))
					(sleep 30)
			)
		)
		
		(if (= (volume_test_players_all vol_inner_sanctum) TRUE)
			(begin
				(if dialogue (print "CORTANA: I... I don't want to stay."))
				(sleep (ai_play_line_on_object NONE 110MJ_050))
					(sleep 15)
			
			; open the door that leads out of the room 
			(device_set_position sanctum_door_03 1)
		
			; sleep until the door is open 
			(sleep_until (= (device_get_position sanctum_door_03) 1) 5)
			(device_operates_automatically_set sanctum_door_03 FALSE)
			(device_set_power sanctum_door_03 0)
			)
		)
)

; =======================================================================================================================================================================
(global boolean g_ch_14_cortana_talk FALSE)

(script dormant ch_14_gravemind
	(sleep_until (volume_test_players tv_fict_12_14_grave) 1)
	(if debug (print "gravemind : 14 : 110ge_revealed"))

	; wake gravemind channel script 
	(wake 110ge_revealed)

;*		
		(if dialogue (print "GRAVEMIND: (angry roar)"))
		(sleep (ai_play_line_on_object NONE 110ML_230))
		(sleep 30)
		
		(if dialogue (print "GRAVEMIND: Now at last I see... Her secret is revealed!"))
		(sleep (ai_play_line_on_object NONE 110MK_010))
*;
	
	(sleep_until	(and
					g_ch_14_cortana_talk
					(volume_test_players tv_fict_14_continue)
				)
	)
	(sleep (random_range 45 90))

	(if (<= (device_group_get pylons) 0)
		(begin
			(if dialogue (print "CORTANA: We need to buy some time..."))
			(sleep (ai_play_line_on_object NONE 110ML_030))
				(sleep 30)
		)
	)
				
	(if (<= (device_group_get pylons) 0)
		(begin
			(if dialogue (print "CORTANA: This reactor... start a chain reaction... destroy High Charity!"))
			(sleep (ai_play_line_on_object NONE 110ML_040))
				(sleep 30)
			(hud_activate_team_nav_point_flag player nav_reactor_switch 0.05)
			
		)
	)
	
	; wake objective scirpts 
	(wake objective_2_set)

	; sleep until the pylon switch has been activated 
	(sleep_until (= (device_group_get pylons) 1))
	(hud_deactivate_team_nav_point_flag player nav_reactor_switch)
)

; =======================================================================================================================================================================

(script dormant ch_15_cortana
	(sleep_until reactor_blown 1)
	(if debug (print "cortana : 15 : 110gf_defeat"))
	(sleep (random_range 90 150))
;*
	; wake gravemind channel script 
	(wake 110gf_defeat)

*;
		(if dialogue (print "GRAVEMIND: (roar of frustration and defeat)"))
		(sleep (ai_play_line_on_object NONE 110ML_350))

		(if dialogue (print "CORTANA: You hurt it, Chief. But not for long."))
		(sleep (ai_play_line_on_object NONE 110MX_010))
			(sleep 30)
		
		(if dialogue (print "CORTANA: We need to get to Halo -- destroy the Flood, once and for all!"))
		(sleep (ai_play_line_on_object NONE 110MX_020))
)

; =======================================================================================================================================================================
(global boolean g_ch_16_cortana_finished FALSE)

(script dormant ch_16_cortana
	(sleep_until (volume_test_players tv_fict_16_cortana))
	(if debug (print "cortana : 16 : friendly_contact"))
	(sleep (random_range 15 30))

		(if dialogue (print "CORTANA: I've got a friendly contact!"))
		(sleep (ai_play_line_on_object NONE 110MX_180))
		(sleep 15)
		
		(if dialogue (print "CORTANA: Who would be crazy enough to come in here?"))
		(sleep (ai_play_line_on_object NONE 110MX_190))
		(sleep 15)
		
	; allow next cortana piece to play 
	(set g_ch_16_cortana_finished TRUE)
)

; =======================================================================================================================================================================

(script dormant ch_17_cortana
	(sleep_until	(and
					g_ch_16_cortana_finished
					(volume_test_players tv_fict_17_cortana)
				)
	)
	(if debug (print "cortana : 16 : friendly_contact"))
	(sleep (random_range 15 30))

		(if dialogue (print "CORTANA: Wait. You two made nice?"))
		(sleep (ai_play_line_on_object NONE 110MX_200))
		(sleep 15)
		
		(if dialogue (print "CORTANA: What else did you do while I was gone?"))
		(sleep (ai_play_line_on_object NONE 110MX_210))
)

; =======================================================================================================================================================================

; =======================================================================================================================================================================
;Reactor Revisited
; =======================================================================================================================================================================

;Flood talk smack when you return to the reactor
;Cortana's reaction
;Cortana tells you what to do
(script dormant reactor_return_dlg
		(sleep 60)
		(if dialogue (print "GRAVEMIND: Now at last I see"))
		(ai_play_line reactor_rev_oldskool 110MK_010)
		(sleep (ai_play_line_on_point_set 110MK_010 reactor_gm_pts 3 grv))
;		(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110MK_010_grv))
;		(sleep 
;			(max 
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_010_gm1)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_010_gm2)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_010_gm3)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_010_grv)
;			)
;		)
		(sleep 10)

;		(if dialogue (print "GRAVEMIND: Her secret is revealed!"))
;		(ai_play_line reactor_rev_oldskool 110MK_020)
;		(ai_play_line_on_point_set 110MK_020 reactor_gm_pts 5 grv)
;		(sleep (ai_play_line chorus 110MK_020))
;;		(sleep 
;;			(max 
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_020_gm1)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_020_gm2)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_020_gm3)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_020_grv)
;;			)
;;		)
;		(sleep 10)

		(if dialogue (print "GRAVEMIND: The spike you would drive in my heart --"))
		(ai_play_line reactor_rev_oldskool 110MK_030)
		(sleep (ai_play_line_on_point_set 110MK_030 reactor_gm_pts 3 grv))
;		(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110MK_030_grv))
;		(sleep 
;			(max 
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_030_gm1)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_030_gm2)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_030_gm3)
;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_030_grv)
;			)
;		)
		(sleep 10)

;		(if dialogue (print "GRAVEMIND: Is key to that infernal wheel!"))
;		(ai_play_line reactor_rev_oldskool 110MK_040)
;		(ai_play_line_on_point_set 110MK_040 reactor_gm_pts 5 grv)
;		(sleep (ai_play_line chorus 110MK_040))
;;		(sleep 
;;			(max 
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_040_gm1)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_040_gm2)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_040_gm3)
;;				(sound_impulse_language_time sound\dialog\110_hc\mission\110mk_040_grv)
;;			)
;;		)
;		(sleep 10)

	(sleep_until
		(OR
			(= (volume_test_players vol_flood_blockage) TRUE)
			(< (ai_nonswarm_count reactor_rev_oldskool) 1)
			(= (device_group_get pylons) 1)
		)
	5 45)
	(sleep 45)
		(if dialogue (print "CORTANA: We can't...we can't let it stop us."))
		(sleep (ai_play_line_on_object NONE 110ML_010))
		(sleep 10)

		(if dialogue (print "CORTANA: Not now...not with everything at stake!"))
		(sleep (ai_play_line_on_object NONE 110ML_020))
		(sleep 10)

		(if dialogue (print "CORTANA: We need to buy some time"))
		(sleep (ai_play_line_on_object NONE 110ML_030))
		(sleep 10)

		(if dialogue (print "CORTANA: This reactor...start a chain reaction...destroy High Charity!"))
		(sleep (ai_play_line_on_object NONE 110ML_040))
		(sleep 10)

	(sleep_until (= (device_group_get pylons) 1) 30 150)
	(if (= (device_group_get pylons) 0)
		(begin
			(if dialogue (print "CORTANA: Those pylons expose the reactor cores."))
			(sleep (ai_play_line_on_object NONE 110ML_090))
			(sleep 10)
		)
	)
	(if (= (device_group_get pylons) 0)
		(begin	
			(if dialogue (print "CORTANA: Look for a console center of the room."))
			(sleep (ai_play_line_on_object NONE 110ML_100))
;			(sleep 10)
		)
	)
	(if (= (device_group_get pylons) 0)
		(begin	
			(hud_activate_team_nav_point_flag player switch_flag 0)
		)
	)
	(sleep 30)
)

;Once the player opens the pylons
;If the player doesn't jump on and destroy a core after a while
(script dormant core_reveal_dlg
	(sleep_forever reactor_return_dlg)
		(if dialogue (print "CORTANA: There! See the cores?"))
		(sleep (ai_play_line_on_object NONE 110ML_250))
		(sleep 10)

		(if
			(OR
				(difficulty_heroic)
				(difficulty_legendary)
			)
				(begin
					(if dialogue (print "CORTANA: You'll have to get past their shielding!"))
					(sleep (ai_play_line_on_object NONE 110ML_260))
					(sleep 10)

					(sleep_until 
						(OR
							(<= (objects_distance_to_flag (players) pylon_01_flag) 5)
							(<= (objects_distance_to_flag (players) pylon_02_flag) 5)
							(<= (objects_distance_to_flag (players) pylon_03_flag) 5)
						)
					5 900)
					(if 
						(AND
							(> (objects_distance_to_flag (players) pylon_01_flag) 6)
							(> (objects_distance_to_flag (players) pylon_02_flag) 6)
							(> (objects_distance_to_flag (players) pylon_03_flag) 6)
						)
						(begin
							(if dialogue (print "CORTANA: Closer, Chief! Destroy the core!"))
							(sleep (ai_play_line_on_object NONE 110ML_270))
							;(sleep 10)
						)
					)
				)
		)
		(sleep 30)
)

;Flood reactions to pylon destruction
(global boolean reactor_flood_react_now FALSE)
(script dormant GM_pylon_reactions
	(sleep_until (= reactor_flood_react_now TRUE))
	(begin_random
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: I am what must be!"))
			(ai_play_line reactor_rev_oldskool 110ML_110)
			(sleep (ai_play_line_on_point_set 110ML_110 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_110_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_110_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_110_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_110_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_110_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: I am your only end!"))
			(ai_play_line reactor_rev_oldskool 110ML_120)
			(sleep (ai_play_line_on_point_set 110ML_120 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_120_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_120_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_120_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_120_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_120_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Meaningless actions!"))
			(ai_play_line reactor_rev_oldskool 110ML_130)
			(sleep (ai_play_line_on_point_set 110ML_130 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_130_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_130_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_130_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_130_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_130_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Unforgivable transgressions!"))
			(ai_play_line reactor_rev_oldskool 110ML_140)
			(sleep (ai_play_line_on_point_set 110ML_140 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_140_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_140_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_140_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_140_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_140_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Do not deny me!"))
			(ai_play_line reactor_rev_oldskool 110ML_150)
			(sleep (ai_play_line_on_point_set 110ML_150 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_150_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_150_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_150_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_150_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_150_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Accept and obey!"))
			(ai_play_line reactor_rev_oldskool 110ML_160)
			(sleep (ai_play_line_on_point_set 110ML_160 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_160_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_160_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_160_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_160_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_160_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: You dare disturb my grave?!"))
			(ai_play_line reactor_rev_oldskool 110ML_170)
			(sleep (ai_play_line_on_point_set 110ML_170 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_170_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_170_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_170_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_170_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_170_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: You are buried! She is broken!"))
			(ai_play_line reactor_rev_oldskool 110ML_180)
			(sleep (ai_play_line_on_point_set 110ML_180 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_180_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_180_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_180_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_180_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_180_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Your reunion will be brief!"))
			(ai_play_line reactor_rev_oldskool 110ML_190)
			(sleep (ai_play_line_on_point_set 110ML_190 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_190_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_190_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_190_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_190_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_190_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: I will rip her from you!"))
			(ai_play_line reactor_rev_oldskool 110ML_200)
			(sleep (ai_play_line_on_point_set 110ML_200 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_200_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_200_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_200_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_200_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_200_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Was she worth the effort?!"))
			(ai_play_line reactor_rev_oldskool 110ML_210)
			(sleep (ai_play_line_on_point_set 110ML_210 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_210_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_210_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_210_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_210_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_210_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: Little liar and her slave!"))
			(ai_play_line reactor_rev_oldskool 110ML_220)
			(sleep (ai_play_line_on_point_set 110ML_220 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_220_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_220_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_220_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_220_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_220_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: (angry roar #1)"))
			(ai_play_line reactor_rev_oldskool 110ML_230)
			(sleep (ai_play_line_on_point_set 110ML_230 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_230_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_230_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_230_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_230_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_230_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
		(begin
			(sleep_until (= reactor_flood_react_now TRUE))
			(sleep 60)
			(if dialogue (print "GRAVEMIND: (angry roar #2)"))
			(ai_play_line reactor_rev_oldskool 110ML_240)
			(sleep (ai_play_line_on_point_set 110ML_240 reactor_gm_pts 3 grv))
;			(sleep (sound_impulse_language_time sound\dialog\110_hc\mission\110ML_240_grv))
;			(sleep 
;				(max 
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_240_gm1)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_240_gm2)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_240_gm3)
;					(sound_impulse_language_time sound\dialog\110_hc\mission\110ml_240_grv)
;				)
;			)
			(sleep 30)
			(set reactor_flood_react_now FALSE)
		)
	)
)
(script dormant GM_pylon_reaction_control
	(wake GM_pylon_reactions)
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(= pylon_count 0)
					(> GM_reaction_okay 0)
				)
			)
			(if
				(AND
					(= GM_reaction_okay 2)
					(!= pylon_count 0)
				)
				(begin
					(set GM_reaction_okay (- GM_reaction_okay 1))
					(set reactor_flood_react_now TRUE)
					(sleep_until
						(OR
							(= GM_reaction_okay 2)
							(= pylon_count 0)
						)
					30 (random_range 450 600))
				)
			)
			
			(sleep_until
				(OR
					(= pylon_count 0)
					(!= GM_reaction_okay 1)
					(AND
						(> (objects_distance_to_flag (players) pylon_01_flag) 7)
						(> (objects_distance_to_flag (players) pylon_02_flag) 7)
						(> (objects_distance_to_flag (players) pylon_03_flag) 7)
					)
				)
			)
			(if
				(AND
					(!= pylon_count 0)
					(= GM_reaction_okay 1)
				)
				(begin
					(set GM_reaction_okay (- GM_reaction_okay 1))
					(set reactor_flood_react_now TRUE)
				)
			)
			(= pylon_count 0)
		)
	)
)

;Another prompt if the player doesn't jump for it
;Warning to jump off destroyed pylon
;Cortana reacts to the destruction of the first pylon
;Cortana reacts to the destruction of the second pylon
(global short GM_reaction_okay 0)
(script dormant pylon_destruction_dlg
	(sleep_until 
		(OR
			(<= (objects_distance_to_flag (players) pylon_01_flag) 5)
			(<= (objects_distance_to_flag (players) pylon_02_flag) 5)
			(<= (objects_distance_to_flag (players) pylon_03_flag) 5)
		)
	5)
		(sleep_forever core_reveal_dlg)
		(if
			(OR
				(difficulty_heroic)
				(difficulty_legendary)
			)
				(begin
					(if dialogue (print "CORTANA: Jump! You can make it!"))
					(sleep (ai_play_line_on_object NONE 110ML_280))
					(sleep 30)
				)
		)

	(sleep_until 
		(OR
			(<= (object_get_health pylon_01x) 0)
			(<= (object_get_health pylon_02x) 0)
			(<= (object_get_health pylon_03x) 0)
		)
	1)
		(wake GM_pylon_reaction_control)

		(if
			(OR
				(AND
					(<= (object_get_health pylon_01x) 0)
					(= (volume_test_players vol_pylon_01) TRUE)
				)
				(AND
					(<= (object_get_health pylon_02x) 0)
					(= (volume_test_players vol_pylon_02) TRUE)
				)
				(AND
					(<= (object_get_health pylon_03x) 0)
					(= (volume_test_players vol_pylon_03) TRUE)
				)
			)
				(begin
					(if dialogue (print "CORTANA: It's going to fall, Chief!"))
					(sleep (ai_play_line_on_object NONE 110ML_290))
					(sleep 30)
				)
		)
		
		(if
			(OR
				(AND
					(<= (object_get_health pylon_01x) 0)
					(= (volume_test_players vol_pylon_01) TRUE)
				)
				(AND
					(<= (object_get_health pylon_02x) 0)
					(= (volume_test_players vol_pylon_02) TRUE)
				)
				(AND
					(<= (object_get_health pylon_03x) 0)
					(= (volume_test_players vol_pylon_03) TRUE)
				)
			)
				(begin
					(if dialogue (print "CORTANA: Jump off! Now!"))
					(sleep (ai_play_line_on_object NONE 110ML_300))
					(sleep 30)
				)
		)
		
		(sleep 30)
		(set GM_reaction_okay 2)	

	(sleep_until (= pylon_count 2))
		(set GM_reaction_okay 0)	
		(sleep 60)
		(if dialogue (print "CORTANA: The reactor's starting to fluctuate!"))
		(sleep (ai_play_line_on_object NONE 110ML_310))
		(sleep 10)

		(if dialogue (print "CORTANA: Two more cores to go!"))
		(sleep (ai_play_line_on_object NONE 110ML_320))
		(sleep 30)

		(sleep 30)
		(set GM_reaction_okay 2)	

	(sleep_until (= pylon_count 1))
		(set GM_reaction_okay 0)	
		(sleep 60)
		(if dialogue (print "CORTANA: Keep it up, Chief!  It's working!"))
		(sleep (ai_play_line_on_object NONE 110ML_330))
		(sleep 10)

		(if dialogue (print "CORTANA: One more will do it!"))
		(sleep (ai_play_line_on_object NONE 110ML_340))
		(sleep 30)

		(sleep 30)
		(set GM_reaction_okay 2)	

	(sleep_until (= pylon_count 0))
		(set GM_reaction_okay 0)	
)

; =======================================================================================================================================================================
;Escape Run
; =======================================================================================================================================================================


; =======================================================================================================================================================================
;FLAVOR
; =======================================================================================================================================================================


