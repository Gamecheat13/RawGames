;*********************************************************************;
;General
;*********************************************************************;

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make a guy do nothing
(script command_script pause_forever
	(sleep_forever)
)

;Script for saves in tough places
(global boolean tough_save_now FALSE)
(script dormant tough_saving
	(sleep_until
		(begin
			(sleep_until (= tough_save_now TRUE))
			(game_save_no_timeout)
			(set tough_save_now FALSE)
			FALSE
		)
	)
)


;*********************************************************************;
;Music
;*********************************************************************;

;Starts ???
;(script dormant 110_music_01_start
;	(print "110_music_01 start")
;	(sound_looping_start "levels\solo\110_hc\music\110_music_01" none 1.0)
;)

;After ???
;(script dormant 110_music_01_start_alt
;	(print "110_music_01 start alt")
;	(sound_looping_set_alternate "levels\solo\110_hc\music\110_music_01" true)
;)

;When ???
;(script dormant 110_music_01_stop
;	(print "110_music_01 stop")
;	(sound_looping_stop "levels\solo\110_hc\music\110_music_01")
;)


;*********************************************************************;
;Chapter Titles
;*********************************************************************;

;"Her Tattered Soul"
(script dormant 110_title1
	(cinematic_fade_from_black_bars)
	(wake objective_1_set)
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(chud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"Nor Hell a Fury..."
(script dormant 110_title2
	(cinematic_fade_from_black_bars)
	(wake objective_1_clear)
	(wake objective_2_set)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(chud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)


;*********************************************************************;
;Objectives
;*********************************************************************;

;first objective
(script dormant objective_1_set
            (sleep 30)
            (print "new objective set:")
            (print "Find Cortana.")
            (objectives_show_up_to 0)
)
(script dormant objective_1_clear
            (print "objective complete:")
            (print "Find Cortana.")
            (objectives_finish_up_to 0)
)

;second objective
(script dormant objective_2_set
            (sleep 30)
            (print "new objective set:")
            (print "Defeat the Gravemind and escape.")
            (objectives_show_up_to 1)
)
(script dormant objective_2_clear
            (print "objective complete:")
            (print "Defeat the Gravemind and escape.")
            (objectives_finish_up_to 1)
)


;*********************************************************************;
;Garbage Collection Volumes
;*********************************************************************;

;garbage collection
(script dormant recycle_volumes
	(sleep_until (= (volume_test_players vol_garbage_colon_1a) TRUE))
	(add_recycling_volume vol_garbage_banshee_ledge 30 30)
	
	(sleep_until (= (volume_test_players vol_garbage_colon_1b) TRUE))
	(add_recycling_volume vol_garbage_banshee_ledge 0 30)
	(add_recycling_volume vol_garbage_colon_1a 30 30)
 
	(sleep_until (= (volume_test_players vol_garbage_maus_bridges) TRUE))
	(add_recycling_volume vol_garbage_colon_1a 0 30)
	(add_recycling_volume vol_garbage_colon_1b 30 30)

	(sleep_until (= (volume_test_players vol_garbage_colon_2a) TRUE))
	(add_recycling_volume vol_garbage_colon_1b 0 30)
	(add_recycling_volume vol_garbage_maus_bridges 30 30)

	(sleep_until (= (volume_test_players vol_garbage_snot_shaft) TRUE))
	(add_recycling_volume vol_garbage_maus_bridges 0 30)
	(add_recycling_volume vol_garbage_colon_2a 30 30)

	(sleep_until (= (volume_test_players vol_garbage_colon_2b) TRUE))
	(add_recycling_volume vol_garbage_colon_2a 0 30)
	(add_recycling_volume vol_garbage_snot_shaft 30 30)

	(sleep_until (= (volume_test_players vol_garbage_lower_quad) TRUE))
	(add_recycling_volume vol_garbage_snot_shaft 0 30)
	(add_recycling_volume vol_garbage_colon_2b 30 30)

	(sleep_until (= (volume_test_players vol_garbage_cortana) TRUE))
	(add_recycling_volume vol_garbage_colon_2b 0 30)
)


;*********************************************************************;
;TEMP
;*********************************************************************;

(script static void corty_test
	(device_set_position_track corty_scarab death_crawl 0)
	(device_animate_position corty_scarab .05 10 0 0 0)
	(print "set 1")
	(sleep_until (= (device_get_position corty_scarab) .05))
	(sleep 30)
	(device_animate_position corty_scarab .1 10 0 0 0)
	(print "set 2")
	(sleep_until (= (device_get_position corty_scarab) .1))
	(sleep 30)
	(device_animate_position corty_scarab .128 10 0 0 0)
	(print "set 3")
	(sleep_until (= (device_get_position corty_scarab) .128))
	(sleep 30)
	(device_animate_position corty_scarab .238 10 0 0 0)
	(print "set 4")
	(sleep_until (= (device_get_position corty_scarab) .238))
	(sleep 30)
	(device_animate_position corty_scarab .341 20 0 0 0)
	(print "set 5")
	(sleep_until (= (device_get_position corty_scarab) .341))
	(sleep 30)
	(device_animate_position corty_scarab .438 20 0 0 0)
	(print "set 6")
	(sleep_until (= (device_get_position corty_scarab) .438))
	(sleep 30)
	(device_animate_position corty_scarab .535 20 0 0 0)
	(print "set 7")
	(sleep_until (= (device_get_position corty_scarab) .535))
	(sleep 30)
	(device_animate_position corty_scarab .572 10 0 0 0)
	(print "set 8")
	(sleep_until (= (device_get_position corty_scarab) .572))
	(sleep 30)
	(device_animate_position corty_scarab .627 10 0 0 0)
	(print "set 9")
	(sleep_until (= (device_get_position corty_scarab) .627))
	(sleep 30)
	(device_animate_position corty_scarab .788 20 0 0 0)
	(print "set 10")
	(sleep_until (= (device_get_position corty_scarab) .788))
	(sleep 30)
	(device_animate_position corty_scarab .841 10 0 0 0)
	(print "set 11")
	(sleep_until (= (device_get_position corty_scarab) .841))
	(sleep 30)
	(device_animate_position corty_scarab .906 10 0 0 0)
	(print "set 12")
	(sleep_until (= (device_get_position corty_scarab) .906))
	(sleep 30)
	(device_animate_position corty_scarab 1 10 0 0 0)
	(print "set 13")
	(sleep_until (= (device_get_position corty_scarab) 1))
)


;*********************************************************************;
;Banshee Ledge
;*********************************************************************;

;command scripts to make infection forms swarm out in all directions
(script command_script banshee_ledge_pos_20
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction 20 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_pos_10
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction 10 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_0
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction 0 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_10
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -10 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_20
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -20 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_30
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -30 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_40
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -40 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_50
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -50 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_60
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -60 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_70
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -70 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_80
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -80 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_90
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -90 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_100
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -100 10 0)
	(sleep 240)
	(cs_move_in_direction -75 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_110
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -110 10 0)
	(sleep 240)
	(cs_move_in_direction -75 10 0)
	(sleep 240)
)
(script command_script banshee_ledge_neg_120
	(cs_abort_on_alert TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_move_in_direction -120 10 0)
	(sleep 240)
)

;staggered spawning of infection forms
(script dormant banshee_ledge_spawn
	(ai_place banshee_ledge_infection_p20)
	(sleep 1)	
	(ai_place banshee_ledge_infection_p10)
	(sleep 1)	
	(ai_place banshee_ledge_infection_0)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n10)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n20)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n30)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n40)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n50)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n60)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n70)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n80)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n90)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n100)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n110)
	(sleep 1)	
	(ai_place banshee_ledge_infection_n120)
)

;script makes infection forms ignore player and attack invisible cortana to simulate them swarming back into hallway
(script dormant banshee_ledge_retreat
	(sleep_until 
		(OR
			(> (ai_combat_status banshee_ledge_infection_p20) 1)
			(> (ai_combat_status banshee_ledge_infection_p10) 1)
			(> (ai_combat_status banshee_ledge_infection_0) 1)
			(> (ai_combat_status banshee_ledge_infection_n10) 1)
			(> (ai_combat_status banshee_ledge_infection_n20) 1)
			(> (ai_combat_status banshee_ledge_infection_n30) 1)
			(> (ai_combat_status banshee_ledge_infection_n40) 1)
			(> (ai_combat_status banshee_ledge_infection_n50) 1)
			(> (ai_combat_status banshee_ledge_infection_n60) 1)
			(> (ai_combat_status banshee_ledge_infection_n70) 1)
			(> (ai_combat_status banshee_ledge_infection_n80) 1)
			(> (ai_combat_status banshee_ledge_infection_n90) 1)
			(> (ai_combat_status banshee_ledge_infection_n100) 1)
			(> (ai_combat_status banshee_ledge_infection_n110) 1)
			(> (ai_combat_status banshee_ledge_infection_n120) 1)
		)
	)
	(ai_disregard (players) TRUE)
	(ai_place banshee_ledge_cortana)
	(object_hide banshee_ledge_cortana TRUE)
	(sleep 1)
	(ai_magically_see banshee_ledge_flood banshee_ledge_cortana)
)

;dialogue from Johnson at the start
(script dormant banshee_ledge_dlg
	(sleep 150)
	(print "JOHNSON:  Chief, I'm rounding up all the survivors I can find.")
	;(ai_play_line_on_object NONE ???)
	
	(sleep 10)
	(print "JOHNSON:  We're falling back to the Dawn.")
	;(ai_play_line_on_object NONE ???)

	(sleep 20)
	(if (< (game_coop_player_count) 2)
		(begin
			(print "JOHNSON:  The Arbiter is rallying the Elites.")
			;(ai_play_line_on_object NONE ???)
		)
		(begin
			(print "JOHNSON:  The Elites are rallying as well.")
			;(ai_play_line_on_object NONE ???)
		)
	)
	
	(sleep 10)
	(print "JOHNSON:  But with the forces we have left, we don't stand a chance against the Flood.")
	;(ai_play_line_on_object NONE ???)

	(sleep 20)
	(print "JOHNSON:  I don't know what you think you can do.")
	;(ai_play_line_on_object NONE ???)
	
	(sleep 10)
	(print "JOHNSON:  But if Cortana's still in there, bring her home.")
	;(ai_play_line_on_object NONE ???)
	(wake objective_1_set)
)

;main script for banshee ledge
(script dormant banshee_ledge_start
	(data_mine_set_mission_segment "110_01_banshee_ledge")
	(game_save)	
	(wake banshee_ledge_spawn)
	(wake banshee_ledge_retreat)
	(wake banshee_ledge_dlg)
)

;cleanup script for banshee ledge
(script dormant banshee_ledge_cleanup
	(sleep_until (= (volume_test_players vol_banshee_ledge_clear) FALSE))
	(ai_disposable banshee_ledge_infection_p20 TRUE)
	(ai_disposable banshee_ledge_infection_p10 TRUE)
	(ai_disposable banshee_ledge_infection_0 TRUE)
	(ai_disposable banshee_ledge_infection_n10 TRUE)
	(ai_disposable banshee_ledge_infection_n20 TRUE)
	(ai_disposable banshee_ledge_infection_n30 TRUE)
	(ai_disposable banshee_ledge_infection_n40 TRUE)
	(ai_disposable banshee_ledge_infection_n50 TRUE)
	(ai_disposable banshee_ledge_infection_n60 TRUE)
	(ai_disposable banshee_ledge_infection_n70 TRUE)
	(ai_disposable banshee_ledge_infection_n80 TRUE)
	(ai_disposable banshee_ledge_infection_n90 TRUE)
	(ai_disposable banshee_ledge_infection_n100 TRUE)
	(ai_disposable banshee_ledge_infection_n110 TRUE)
	(ai_disposable banshee_ledge_infection_n120 TRUE)
	(sleep_forever banshee_ledge_start)
	(sleep_forever banshee_ledge_spawn)
	(sleep_forever banshee_ledge_retreat)
	(sleep_forever banshee_ledge_dlg)
)


;*********************************************************************;
;Colon 1a
;*********************************************************************;

(script dormant colon1a_chud_suck
	(sleep_until (= (volume_test_players vol_colon1a_chud_start) TRUE) 1)
	(chud_cortana_suck colon1a_cor_01 TRUE)
	
	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_02) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_01)) 5)
	(chud_cortana_suck colon1a_cor_02 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_03) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_02)) 5)
	(chud_cortana_suck colon1a_cor_03 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_04) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_03)) 5)
	(chud_cortana_suck colon1a_cor_04 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_05) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_04)) 5)
	(chud_cortana_suck colon1a_cor_05 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_06) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_05)) 5)
	(chud_cortana_suck colon1a_cor_06 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_07) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_06)) 5)
	(chud_cortana_suck colon1a_cor_07 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_08) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_07)) 5)
	(chud_cortana_suck colon1a_cor_08 TRUE)

	(sleep_until (< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_09) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_08)) 5)
	(chud_cortana_suck colon1a_cor_09 TRUE)

	(sleep_until 
		(OR
			(< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_10) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_09))
			(< (ai_living_count colon1a_cortana_01) 1)
		)
	5)
	(chud_cortana_suck colon1a_cor_10 TRUE)

	(sleep_until 
		(OR
			(< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_11) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_10))
			(< (ai_living_count colon1a_cortana_01) 1)
		)
	5)
	(chud_cortana_suck colon1a_cor_11 TRUE)

	(sleep_until 
		(OR
			(< (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_12) (objects_distance_to_flag (ai_actors colon1a_cortana_01) colon1a_cor_11))
			(< (ai_living_count colon1a_cortana_01) 1)
		)
	5)
	(chud_cortana_suck colon1a_cor_12 TRUE)
	
	(sleep_until (< (ai_living_count colon1a_cortana_01) 1) 5)
	(chud_cortana_suck colon1a_cor_12 FALSE)
	
	(sleep_until (= (volume_test_players vol_colon1a_03) TRUE) 1)
	(chud_cortana_suck colon1a_cor_13 TRUE)
	
	(sleep_until (> (ai_living_count colon1a_cortana_02) 0) 1)
	(sleep_until (< (ai_living_count colon1a_cortana_02) 1) 1)
	(chud_cortana_suck colon1a_cor_14 TRUE)

	(sleep_until (> (ai_living_count colon1a_cortana_02) 0) 1)
	(sleep_until (< (ai_living_count colon1a_cortana_02) 1) 1)
	(chud_cortana_suck colon1a_cor_14 FALSE)
)

(global ai cortana_vision NONE)
(script dormant colon1a_corty_moment_01
	(sleep_until (= (volume_test_players vol_colon1a_start) TRUE) 1)
	(ai_place colon1a_cortana_01)
	(set cortana_vision colon1a_cortana_01)
	(vs_enable_pathfinding_failsafe cortana_vision TRUE)
	(vs_movement_mode cortana_vision 0)
	(vs_go_to cortana_vision FALSE colon1a_000_pts/p0)
	
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object cortana_vision)) 3) 1 300)  
	(object_teleport (ai_get_object cortana_vision) colon1a_tp_01)	
	(vs_go_to cortana_vision FALSE colon1a_000_pts/p1)

	(sleep_until (< (objects_distance_to_object (players) (ai_get_object cortana_vision)) 3) 1 210)  
	(object_teleport (ai_get_object cortana_vision) colon1a_tp_02)	
	(vs_go_to_and_face cortana_vision TRUE colon1a_010_pts/p2 colon1a_010_pts/p3)
	(vs_face cortana_vision TRUE colon1a_010_pts/p3)
	
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object cortana_vision)) 3) 1 600)  
	(vs_custom_animation cortana_vision FALSE objects\characters\cortana\cortana "combat:unarmed:point" TRUE)

	(sleep_until (< (objects_distance_to_object (players) (ai_get_object cortana_vision)) 1) 1 90)  
	(ai_erase colon1a_cortana_01)
)
(global boolean colon1a_corty_over FALSE)
(script dormant colon1a_corty_moment_02
	(sleep_until (= (volume_test_players vol_colon1a_03) TRUE) 1)
	(ai_place colon1a_cortana_02 1)
	(set cortana_vision colon1a_cortana_02)
	(vs_enable_pathfinding_failsafe cortana_vision TRUE)
	(vs_movement_mode cortana_vision 0)
	(object_teleport (ai_get_object cortana_vision) colon1a_tp_03)	
	(vs_custom_animation cortana_vision FALSE objects\characters\cortana\temp\temp "flood_infectiona" TRUE)

	(sleep_until 
		(OR
			(< (objects_distance_to_object (ai_actors colon1a_cortana_02) (player0)) 2)
			(AND
				(< (objects_distance_to_object (ai_actors colon1a_cortana_02) (player1)) 2)
				(> (game_coop_player_count) 1)	
			)
		)		
	1 100)
	(ai_erase colon1a_cortana_02)

	(sleep_until 
		(OR
			(= (volume_test_players vol_colon1a_05) TRUE)
			(AND
				(OR
					(= (objects_can_see_flag (players) colon1a_tp_04 15) TRUE)
					(= (objects_can_see_flag (players) colon1a_tp_05 15) TRUE)
				)
				(= (volume_test_players vol_colon1a_04) TRUE)
			)
		)
	1)
	(ai_place colon1a_cortana_02)
	(set cortana_vision colon1a_cortana_02)
	(vs_enable_pathfinding_failsafe cortana_vision TRUE)
	(vs_custom_animation cortana_vision FALSE objects\characters\cortana\temp\temp "marine_floodtransformation" TRUE)
	(sleep_until 
		(OR
			(< (objects_distance_to_object (ai_actors colon1a_cortana_02) (player0)) 2)
			(AND
				(< (objects_distance_to_object (ai_actors colon1a_cortana_02) (player1)) 2)
				(> (game_coop_player_count) 1)	
			)
		)		
	1 240)
	(ai_erase colon1a_cortana_02)
	(set colon1a_corty_over TRUE)
)

(global boolean colon1a_halfway FALSE)
(script dormant colon_1a_start
	(sleep_until (= (volume_test_players vol_banshee_ledge_end) TRUE))
	(game_save)
	(wake colon1a_corty_moment_01)
	(wake colon1a_chud_suck)
	(ai_disregard (players) FALSE)
	(ai_erase banshee_ledge_cortana)
	
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon1a_01) TRUE)
			(< (ai_living_count colon1a_cortana_01) 1)
		)
	)
	(data_mine_set_mission_segment "110_02_colon_1a")
	(game_save)
	(sleep 30)
	(ai_place colon1a_cf_00)
	(device_set_power colon1a_door 1)
	(device_set_position colon1a_door 1)
	(wake colon1a_corty_moment_02)
	
	(sleep_until (= (device_get_position colon1a_door) 1))
	(device_set_power colon1a_door 0)
	
	(sleep_until 
		(OR
			(= (volume_test_players vol_colon1a_02) TRUE)
			(< (ai_living_count colon1a_cf_00) 1)
		)
	)
	(game_save)
	(set colon1a_halfway TRUE)
	(ai_place colon1a_cf_01 (- 8 (ai_living_count colon1a_cf_00)))
	(ai_migrate colon1a_cf_00 colon1a_cf_01)
)

(script dormant colon_1a_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_banshee_ledge_clear) FALSE)
		)
	)
	(ai_disposable colon1a_cortana_01 TRUE)
	(ai_disposable colon1a_cortana_02 TRUE)
	(ai_disposable colon1a_cf_00 TRUE)
	(ai_disposable colon1a_cf_01 TRUE)
	(sleep_forever colon_1a_start)
	(sleep_forever colon1a_chud_suck)
	(sleep_forever colon1a_corty_moment_01)
	(sleep_forever colon1a_corty_moment_02)
)


;*********************************************************************;
;Colon 1b
;*********************************************************************;

;Used to make guys move out of tubes easier
(script command_script get_out_the_damn_hole
	(cs_ignore_obstacles TRUE)
	(cs_movement_mode 1)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (= (volume_test_object vol_colon_1_out_tube (ai_get_object ai_current_actor)) TRUE))
	(cs_movement_mode 0)
)

(global short colon1b_section 0)
(global boolean colon1b_xform FALSE)
(script dormant colon_1b_start
	(sleep_until 
		(OR
			(= (volume_test_players vol_colon1b_start) TRUE)
			(= colon1a_corty_over TRUE)
		)
	)
	(data_mine_set_mission_segment "110_03_colon_1b")
	(game_save)
	(ai_place colon1b_pit_infection)
	(ai_place colon1b_pit_pure)
	
	(sleep_until (= (volume_test_players vol_colon1b_inside) TRUE))
	(sleep_until
		(OR
			(< (ai_nonswarm_count colon1b_pit_infection) 4)
			(= (volume_test_players vol_colon1b_01) TRUE)
		)
	30 60)
	(set colon1b_xform TRUE)

	(sleep_until
		(OR
			(< (ai_living_count colon1b_pit_infection) 1)
			(> (ai_living_count colon1b_turned) 4)
			(= (volume_test_players vol_colon1b_01) TRUE)
		)
	)
	(sleep_until
		(OR
			(< (ai_nonswarm_count colon1b_turned) 4)
			(= (volume_test_players vol_colon1b_01) TRUE)
		)
	)
	(if (= (volume_test_players vol_colon1b_01) FALSE)
		(begin
			(game_save)
			(ai_place colon1b_exit_cf_00 (- 6 (ai_nonswarm_count colon1b_pit_infection)))
;			(ai_migrate colon1b_pit_infection colon1b_exit_cf_00)
		)
	)

	(sleep_until
		(OR
			(= (ai_task_status colon1b_obj/middle_reveal) 4)
			(= (volume_test_players vol_colon1b_01) TRUE)
		)
	)
	(set colon1b_section 1)
	(game_save)
	(ai_place colon1b_exit_cf_01 (- 6 (+ (ai_nonswarm_count colon1b_exit_cf_00) (ai_nonswarm_count colon1b_pit_infection))))
	(ai_migrate colon1b_pit_infection colon1b_exit_cf_01)
	(ai_migrate colon1b_exit_cf_00 colon1b_exit_cf_01)
	(ai_place colon1b_exit_pure_01 (- 4 (ai_living_count colon1b_pit_pure)))
	(ai_migrate colon1b_pit_pure colon1b_exit_pure_01)

	(sleep_until
		(OR
			(= (ai_task_status colon1b_obj/exit_01) 4)
			(= (volume_test_players vol_colon1b_02) TRUE)
		)
	)
	(set colon1b_section 2)
	(game_save)
	(ai_place colon1b_exit_pure_02 (- 4 (ai_living_count colon1b_exit_pure_01)))
	(ai_migrate colon1b_exit_pure_01 colon1b_exit_pure_02)

	(sleep_until
		(OR
			(= (ai_task_status colon1b_obj/exit_02) 4)
			(= (volume_test_players vol_colon1b_03) TRUE)
		)
	)
	(set colon1b_section 3)
	(game_save)
	(ai_place colon1b_exit_cf_03 (- 6 (ai_nonswarm_count colon1b_exit_cf_01)))
	(ai_migrate colon1b_exit_cf_01 colon1b_exit_cf_03)
	(ai_place colon1b_exit_pure_03 (- 4 (ai_living_count colon1b_exit_pure_02)))
	(ai_migrate colon1b_exit_pure_02 colon1b_exit_pure_03)
)

(script dormant colon_1b_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_banshee_ledge_clear) FALSE)
		)
	)
	(ai_disposable colon1b_pit_infection TRUE)
	(ai_disposable colon1b_pit_pure TRUE)
	(ai_disposable colon1b_exit_cf_00 TRUE)
	(ai_disposable colon1b_exit_cf_01 TRUE)
	(ai_disposable colon1b_exit_cf_03 TRUE)
	(ai_disposable colon1b_turned TRUE)
	(ai_disposable colon1b_exit_pure_01 TRUE)
	(ai_disposable colon1b_exit_pure_02 TRUE)
	(ai_disposable colon1b_exit_pure_03 TRUE)
	(sleep_forever colon_1b_start)
)


;*********************************************************************;
;Bridge 1
;*********************************************************************;

(script dormant bridge_1_start
	(sleep_until (= (volume_test_players vol_mausbridge1) TRUE))
	(data_mine_set_mission_segment "110_04_mausbridge1")
	(game_save)
	(print "bridge_1")
)

(script dormant bridge_1_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_bridge1_clear) FALSE)
		)
	)
	(ai_disposable bridge_1_cortana TRUE)
	(sleep_forever bridge_1_start)
)


;*********************************************************************;
;Mausoleum
;*********************************************************************;

(global short maus_where_at 0)
(global boolean maus_reset FALSE)

;*

0 = nowhere
1 = l_low_mid
2 = l_low_front
3 = l_low_back
4 = r_low_mid
5 = r_low_front
6 = l_high_mid
7 = l_high_front
8 = l_high_back
9 = r_high_mid
10 = r_high_front
11 = back_door
12 = front_door

*;

(script dormant maus_player_finder
	(sleep_until (> (ai_combat_status maus_flood) 6))
	(sleep_until
		(begin
			(if 
				(AND
					(= (volume_test_players vol_maus_back_door) TRUE)
					(> (ai_combat_status maus_flood) 6)
				)
					(set maus_where_at 11)
			)
			(if 
				(AND
					(= (volume_test_players vol_maus_back_door) TRUE)
					(> (ai_combat_status maus_flood) 6)
				)
					(set maus_where_at 12)
			)
			(if
				(AND
					(> (ai_combat_status maus_flood) 6)
					(OR
						(= (volume_test_players vol_maus_l_low_mid) TRUE)
						(= (volume_test_players vol_maus_l_low_front) TRUE)
						(= (volume_test_players vol_maus_l_low_back) TRUE)
					)
				)
					(begin
						(if 
							(AND
								(= (volume_test_players vol_maus_l_low_mid) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
							(begin
								(set maus_reset TRUE)
								(set maus_where_at 1)
							)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_l_low_front) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 2)
								)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_l_low_back) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 3)
								)
						)
						(set maus_reset FALSE)
					)
			)
			(if
				(AND
					(> (ai_combat_status maus_flood) 6)
					(OR
						(= (volume_test_players vol_maus_r_low_mid) TRUE)
						(= (volume_test_players vol_maus_r_low_front) TRUE)
					)
				)
					(begin
						(if 
							(AND
								(= (volume_test_players vol_maus_r_low_mid) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 4)
								)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_r_low_front) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 5)
								)
						)
						(set maus_reset FALSE)
					)
			)
			(if
				(AND
					(> (ai_combat_status maus_flood) 6)
					(OR
						(= (volume_test_players vol_maus_l_high_mid) TRUE)
						(= (volume_test_players vol_maus_l_high_front) TRUE)
						(= (volume_test_players vol_maus_l_high_back) TRUE)
					)
				)
					(begin
						(if 
							(AND
								(= (volume_test_players vol_maus_l_high_mid) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 6)
								)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_l_high_front) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 7)
								)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_l_high_back) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 8)
								)
						)
						(set maus_reset FALSE)
					)
			)
			(if
				(AND
					(> (ai_combat_status maus_flood) 6)
					(OR
						(= (volume_test_players vol_maus_r_high_mid) TRUE)
						(= (volume_test_players vol_maus_r_high_front) TRUE)
					)
				)
					(begin
						(if 
							(AND
								(= (volume_test_players vol_maus_r_high_mid) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 9)
								)
						)
						(if
							(AND
								(= maus_reset FALSE)
								(= (volume_test_players vol_maus_r_high_front) TRUE)
								(> (ai_combat_status maus_flood) 6)
							)
								(begin
									(set maus_reset TRUE)
									(set maus_where_at 10)
								)
						)
						(set maus_reset FALSE)
					)
			)
			(= maus_endgame TRUE)	
		)
	1)
)

(script dormant maus_doors
	(sleep_until (= (volume_test_players vol_maus_entrance) TRUE))
	(device_operates_automatically_set maus_entry 0)
	(device_set_position maus_entry 0)
	
	(sleep_until (= (device_get_position maus_entry) 0))
	(device_set_power maus_entry 0)
	
	(sleep_until 
		(AND
			(= maus_endgame TRUE)
			(< (ai_nonswarm_count maus_flood) 1)
		)
	)
	(device_set_power maus_exit 1)
	(device_closes_automatically_set maus_exit 0)
	(device_operates_automatically_set maus_exit 0)
	(device_set_position maus_exit 1)
	
	(sleep_until (= (volume_test_players vol_maus_exit) TRUE))
	(device_closes_automatically_set maus_exit 1)
	(device_operates_automatically_set maus_exit 1)
)

(global boolean maus_endgame FALSE)
(script dormant maus_start
	(sleep_until (= (volume_test_players vol_maus_start) TRUE))
	(data_mine_set_mission_segment "110_05_maus")
	(game_save)
	(wake maus_doors)
	(wake maus_player_finder)
	(ai_place maus_flarbs_init_L 3)
	(ai_place maus_flarbs_init_R 3)
	
	(sleep_until (< (ai_nonswarm_count maus_flood) 4))
	(game_save)
	(if (= (volume_test_players vol_maus_right) TRUE)
		(ai_place maus_flarbs_rein_L 3)
		(ai_place maus_flarbs_rein_R 3)
	)

	(sleep_until (< (ai_nonswarm_count maus_flood) 3))
	(game_save)
	(ai_place maus_infection_01)
	
	(sleep_until 
		(OR
			(> (ai_nonswarm_count maus_flood) 4)
			(< (ai_swarm_count maus_infection_01) 3)
		)
	)
	(sleep_until (< (ai_nonswarm_count maus_flood) 3))
	(game_save)
	(if (= (volume_test_players vol_maus_right) TRUE)
		(ai_place maus_flarbs_rein_L 4)
		(ai_place maus_flarbs_rein_R 4)
	)
	
	(sleep_until (< (ai_nonswarm_count maus_flood) 3))
	(game_save)
	(set maus_endgame TRUE)
)

(script dormant maus_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_maus_clear) FALSE)
		)
	)
	(ai_disposable maus_flarbs_init_L TRUE)
	(ai_disposable maus_flarbs_init_R TRUE)
	(ai_disposable maus_flarbs_rein_L TRUE)
	(ai_disposable maus_flarbs_rein_R TRUE)
	(ai_disposable maus_infection_01 TRUE)	
	(sleep_forever bridge_1_start)
	(sleep_forever maus_doors)
	(sleep_forever maus_start)
)


;*********************************************************************;
;Bridge 2
;*********************************************************************;

(script dormant bridge_2_start
	(sleep_until (= maus_endgame TRUE))
	(data_mine_set_mission_segment "110_06_mausbridge2")
	(game_save)
	(ai_place bridge_2_cf_mid_01)
	(ai_place bridge_2_cf_L_01)
	(ai_place bridge_2_cf_R_01)
	
	(sleep_until 
		(OR
			(< (ai_nonswarm_count bridge_2_flood) 3)
			(= (volume_test_players vol_bridge_2_end) TRUE)
		)
	)
	(ai_place bridge_2_infection)
	(device_set_position bridge_2_exit 1)
)

(script dormant bridge_2_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_bridge2_clear) FALSE)
		)
	)
	(ai_disposable bridge_2_cf_mid_01 TRUE)
	(ai_disposable bridge_2_cf_L_01 TRUE)
	(ai_disposable bridge_2_cf_R_01 TRUE)
	(ai_disposable bridge_2_infection TRUE)
	(sleep_forever bridge_2_start)
)


;*********************************************************************;
;Colon 2a
;*********************************************************************;

(script dormant colon_2a_start
	(sleep_until (= (volume_test_players vol_colon_2a_start) TRUE))
	(data_mine_set_mission_segment "110_07_colon_2a")
	(game_save)
	(print "colon_2a")
)

(script dormant colon_2a_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_colon_2a_clear) FALSE)
		)
	)
;	(ai_disposable ??? TRUE)
	(sleep_forever colon_2a_start)
)


;*********************************************************************;
;Snot Shaft
;*********************************************************************;

(global short snot_section 0)
(script dormant snot_shaft_start
	(sleep_until (= (volume_test_players vol_snot_shaft_start) TRUE))
	(data_mine_set_mission_segment "110_08_snot_shaft")
	(game_save)
	(ai_place snot_shaft_pure_01a)
	(ai_place snot_shaft_cf_01a)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_snot_shaft_01b) TRUE)
			(= (volume_test_players vol_snot_shaft_02a) TRUE)
			(= (volume_test_players vol_snot_shaft_02b) TRUE)
			(= (volume_test_players vol_snot_shaft_03a) TRUE)
			(= (volume_test_players vol_snot_shaft_03b) TRUE)
			(= (ai_task_status snot_shaft_obj/floor_01_a) 4)
		)
	)
	(game_save_no_timeout)
	(set snot_section 1)
	(ai_place snot_shaft_pure_01b (- 4 (ai_nonswarm_count snot_shaft_pure_01a)))
	(ai_place snot_shaft_cf_01b (- 6 (ai_nonswarm_count snot_shaft_cf_01a)))
	(sleep 1)
	(ai_migrate snot_shaft_pure_01a snot_shaft_pure_01b)
	(ai_migrate snot_shaft_cf_01a snot_shaft_cf_01b)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_snot_shaft_02a) TRUE)
			(= (volume_test_players vol_snot_shaft_02b) TRUE)
			(= (volume_test_players vol_snot_shaft_03a) TRUE)
			(= (volume_test_players vol_snot_shaft_03b) TRUE)
			(= (ai_task_status snot_shaft_obj/floor_01_b) 4)
		)
	)
	(game_save_no_timeout)
	(set snot_section 2)
	(ai_place snot_shaft_pure_02a (- 4 (ai_nonswarm_count snot_shaft_pure_01b)))
	(ai_place snot_shaft_cf_02a (- 6 (ai_nonswarm_count snot_shaft_cf_01b)))
	(sleep 1)
	(ai_migrate snot_shaft_pure_01b snot_shaft_pure_02a)
	(ai_migrate snot_shaft_cf_01b snot_shaft_cf_02a)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_snot_shaft_02b) TRUE)
			(= (volume_test_players vol_snot_shaft_03a) TRUE)
			(= (volume_test_players vol_snot_shaft_03b) TRUE)
			(= (ai_task_status snot_shaft_obj/floor_02_a) 4)
		)
	)
	(game_save_no_timeout)
	(set snot_section 3)
	(ai_place snot_shaft_pure_02b (- 4 (ai_nonswarm_count snot_shaft_pure_02a)))
	(ai_place snot_shaft_cf_02b (- 6 (ai_nonswarm_count snot_shaft_cf_02a)))
	(sleep 1)
	(ai_migrate snot_shaft_pure_02a snot_shaft_pure_02b)
	(ai_migrate snot_shaft_cf_02a snot_shaft_cf_02b)

	(sleep_until
		(OR
			(= (volume_test_players vol_snot_shaft_03a) TRUE)
			(= (volume_test_players vol_snot_shaft_03b) TRUE)
			(= (ai_task_status snot_shaft_obj/floor_02_b) 4)
		)
	)
	(game_save_no_timeout)
	(set snot_section 4)
	(ai_place snot_shaft_pure_03a (- 4 (ai_nonswarm_count snot_shaft_pure_02b)))
	(ai_place snot_shaft_cf_03a (- 6 (ai_nonswarm_count snot_shaft_cf_02b)))
	(sleep 1)
	(ai_migrate snot_shaft_pure_02b snot_shaft_pure_03a)
	(ai_migrate snot_shaft_cf_02b snot_shaft_cf_03a)

	(sleep_until
		(OR
			(= (volume_test_players vol_snot_shaft_03b) TRUE)
			(= (ai_task_status snot_shaft_obj/floor_03_a) 4)
		)
	)
	(game_save_no_timeout)
	(set snot_section 5)
	(ai_place snot_shaft_pure_03b (- 4 (ai_nonswarm_count snot_shaft_pure_03a)))
	(ai_place snot_shaft_cf_03b (- 6 (ai_nonswarm_count snot_shaft_cf_03a)))
	(sleep 1)
	(ai_migrate snot_shaft_pure_03a snot_shaft_pure_03b)
	(ai_migrate snot_shaft_cf_03a snot_shaft_cf_03b)
)

(script dormant snot_shaft_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_colon_2a_clear) FALSE)
			(= (volume_test_players vol_snot_shaft_clear) FALSE)
		)
	)
	(ai_disposable snot_shaft_cf_01a TRUE)
	(ai_disposable snot_shaft_cf_01b TRUE)
	(ai_disposable snot_shaft_cf_02a TRUE)
	(ai_disposable snot_shaft_cf_02b TRUE)
	(ai_disposable snot_shaft_cf_03a TRUE)
	(ai_disposable snot_shaft_cf_03b TRUE)
	(ai_disposable snot_shaft_pure_01a TRUE)
	(ai_disposable snot_shaft_pure_01b TRUE)
	(ai_disposable snot_shaft_pure_02a TRUE)
	(ai_disposable snot_shaft_pure_02b TRUE)
	(ai_disposable snot_shaft_pure_03a TRUE)
	(ai_disposable snot_shaft_pure_03b TRUE)
	(sleep_forever colon_2a_start)
	(sleep_forever snot_shaft_start)
)


;*********************************************************************;
;Colon 2b
;*********************************************************************;

(script dormant colon_2b_start
	(sleep_until (= (volume_test_players vol_colon2b_start) TRUE))
	(data_mine_set_mission_segment "110_09_colon_2b")
	(game_save)
	(ai_place colon2b_cf_01)
	
	(sleep_until
		(OR
			(< (ai_nonswarm_count colon2b_flood) 3)
			(= (volume_test_players vol_colon2b_01) TRUE)
		)
	)
	(game_save)
	(if (= (volume_test_players vol_colon2b_01) FALSE)
		(ai_place colon2b_cf_02)
	)

	(sleep_until (= (volume_test_players vol_colon2b_01) TRUE))
	(game_save)
	(ai_place colon2b_cf_03)
)

(script dormant colon_2b_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_colon_2a_clear) FALSE)
			(= (volume_test_players vol_colon_2b_clear) FALSE)
		)
	)
	(sleep_forever colon_2b_start)
	(ai_disposable colon2b_cf_01 TRUE)
	(ai_disposable colon2b_cf_02 TRUE)
	(ai_disposable colon2b_cf_03 TRUE)
)


;*********************************************************************;
;Lower Quadrant
;*********************************************************************;

(global short lower_quad_section 0)
(script dormant lower_quad_pure_spawner
	(ai_place lower_quad_pure_01)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_01) TRUE)
			(= (ai_task_status lower_quad_obj/scarab_side_01_pure) 4)
		)
	)
	(game_save)
	(set lower_quad_section 1)
	(ai_place lower_quad_pure_02 (- 6 (ai_living_count lower_quad_pureforms)))

	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_02) TRUE)
			(= (ai_task_status lower_quad_obj/scarab_side_02_pure) 4)
		)
	)
	(game_save)
	(set lower_quad_section 2)
	(ai_place lower_quad_pure_03 (- 6 (ai_living_count lower_quad_pureforms)))

	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_03) TRUE)
			(= (ai_task_status lower_quad_obj/middle_pure) 4)
		)
	)
	(game_save)
	(set lower_quad_section 3)
	(ai_place lower_quad_pure_04 (- 6 (ai_living_count lower_quad_pureforms)))

	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_04) TRUE)
			(= (ai_task_status lower_quad_obj/pelican_side_01_pure) 4)
		)
	)
	(game_save)
	(set lower_quad_section 4)
	(ai_place lower_quad_pure_05 (- 6 (ai_living_count lower_quad_pureforms)))
)

(script dormant lower_quad_cf_spawner
	(ai_place lower_quad_cf_01)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_01) TRUE)
			(= (ai_task_status lower_quad_obj/scarab_side_01_cf) 4)
		)
	)
	(set lower_quad_section 1)
	(ai_place lower_quad_cf_02 (- 8 (ai_living_count lower_quad_oldskool)))
	
	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_02) TRUE)
			(= (ai_task_status lower_quad_obj/scarab_side_02_cf) 4)
		)
	)
	(set lower_quad_section 2)
	(ai_place lower_quad_cf_03 (- 8 (ai_living_count lower_quad_oldskool)))

	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_03) TRUE)
			(= (ai_task_status lower_quad_obj/middle_cf) 4)
		)
	)
	(set lower_quad_section 3)
	(ai_place lower_quad_cf_04 (- 8 (ai_living_count lower_quad_oldskool)))
	
	(sleep_until
		(OR
			(= (volume_test_players vol_lower_quad_04) TRUE)
			(= (ai_task_status lower_quad_obj/pelican_side_01_cf) 4)
		)
	)
	(set lower_quad_section 4)
	(ai_place lower_quad_cf_05 (- 8 (ai_living_count lower_quad_oldskool)))
)

(global boolean lower_quad_started FALSE)
(script dormant lower_quad_start
	(sleep_until (= (volume_test_players vol_lower_quad_start) TRUE))
	(data_mine_set_mission_segment "110_10_lower_quad")
	(game_save)
	(objects_attach corty_scarab "" corty_tail "")
	(device_set_position_track corty_scarab death_crawl 0)
	(object_cannot_take_damage corty_scarab)
	(set lower_quad_started TRUE)
	(wake lower_quad_pure_spawner)
	(wake lower_quad_cf_spawner)
)

(script dormant lower_quad_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_colon_2a_clear) FALSE)
			(= (volume_test_players vol_lower_quad_clear) FALSE)
		)
	)
	(ai_disposable lower_quad_cf_01 TRUE)
	(ai_disposable lower_quad_cf_02 TRUE)
	(ai_disposable lower_quad_cf_03 TRUE)
	(ai_disposable lower_quad_cf_04 TRUE)
	(ai_disposable lower_quad_cf_05 TRUE)
	(ai_disposable lower_quad_pure_01 TRUE)
	(ai_disposable lower_quad_pure_02 TRUE)
	(ai_disposable lower_quad_pure_03 TRUE)
	(ai_disposable lower_quad_pure_04 TRUE)
	(ai_disposable lower_quad_pure_05 TRUE)
	(sleep_forever lower_quad_start)
	(sleep_forever lower_quad_pure_spawner)
	(sleep_forever lower_quad_cf_spawner)
)


;*********************************************************************;
;Colon 3
;*********************************************************************;

(script dormant colon_3_start
	(sleep_until (= (volume_test_players vol_colon_3_start) TRUE))
	(data_mine_set_mission_segment "110_11_save_cortana")
	(game_save)
	(print "colon_3")
)

(script dormant colon_3_cleanup
	(sleep_until 
		(AND
			(= (volume_test_players vol_colon_1b_clear) FALSE)
			(= (volume_test_players vol_colon_1a_clear) FALSE)
			(= (volume_test_players vol_colon_2a_clear) FALSE)
			(= (volume_test_players vol_colon_3_clear) FALSE)
		)
	)
;	(ai_disposable ??? TRUE)
	(sleep_forever colon_3_start)
)


;*********************************************************************;
;Inner Sanctum
;*********************************************************************;

(global boolean cortana_rescued FALSE)
(global short torture_scale 0)
(script dormant torture_cortana
	(object_create tortured_corty)
	(scenery_animation_start_loop tortured_corty objects\characters\cortana\cinematics\letterboxes\110lb_rescue_cortana\110lb_rescue_cortana "110lb01_cin_cortana_3")
	
	(sleep_until
		(begin
			(set torture_scale (random_range 10 60))
			(object_set_scale tortured_corty (real_random_range .75 1.25) torture_scale)
			(sleep_until (= (volume_test_players vol_save_cortana) TRUE) 1 torture_scale)  
			(= (volume_test_players vol_save_cortana) TRUE)
		)
	)
)

(script dormant corty_start
	(sleep_until (= (volume_test_players vol_corty_start) TRUE))
	(wake torture_cortana)
	
	(sleep_until (= (volume_test_players vol_save_cortana) TRUE) 1)
	(cinematic_snap_to_black)
	(sleep 1)
	(object_teleport (player0) hide_player0)
	(object_teleport (player1) hide_player1)
	(object_destroy tortured_corty)

	(if (cinematic_skip_start)
		(begin
			(110lb_rescue_cortana)
		)
	)
	(cinematic_skip_stop)

	(object_teleport (player0) resume_player0)
	(object_teleport (player1) resume_player1)
	(set cortana_rescued TRUE)
	(sleep 1)
;	(cinematic_fade_from_black)
	(wake 110_title2)
)

(script dormant corty_cleanup
	(sleep_until 
		(AND
			(= cortana_rescued TRUE)
			(= (volume_test_players vol_cortana_clear) FALSE)
		)
	)
;	(ai_disposable ??? TRUE)
	(sleep_forever corty_start)
	(sleep_forever torture_cortana)
)


;*********************************************************************;
;Gravemind
;*********************************************************************;

;causes Flood to run until they get within a certain distance
(script command_script slow_down_when_close
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_movement_mode 1)

	(sleep_until (< (objects_distance_to_object (ai_actors gm_fight_cortana) ai_current_actor) 15))
	(cs_movement_mode 0)

	(sleep 30)
)

;respawns Flood into the fight
(script dormant infinite_devil_machine
	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_living_count gvm_cf_low_right) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_low_right_spawn) FALSE)
						(= (device_get_position gvm_low_right_door) 0)
					)
						(begin
							(ai_place gvm_cf_low_right)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_low_mid) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_low_mid_spawn) FALSE)
						(= 
							(AND
								(= (volume_test_object vol_gvm_low_mid_see (player0)) TRUE)
								(= (objects_can_see_flag (player0) flag_gvm_low_mid_spawn 45) TRUE)
							)
						FALSE)
						(= 
							(AND
								(= (volume_test_object vol_gvm_low_mid_see (player1)) TRUE)
								(= (objects_can_see_flag (player1) flag_gvm_low_mid_spawn 45) TRUE)
							)
						FALSE)
						(= 
							(AND
								(= (volume_test_object vol_gvm_low_mid_see (player2)) TRUE)
								(= (objects_can_see_flag (player2) flag_gvm_low_mid_spawn 45) TRUE)
							)
						FALSE)
						(= 
							(AND
								(= (volume_test_object vol_gvm_low_mid_see (player3)) TRUE)
								(= (objects_can_see_flag (player3) flag_gvm_low_mid_spawn 45) TRUE)
							)
						FALSE)
					)
						(begin
							(ai_place gvm_cf_low_mid)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_low_left) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_low_left_spawn) FALSE)
						(= (device_get_position gvm_low_left_door) 0)
					)
						(begin
							(ai_place gvm_cf_low_left)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_near_right) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_near_right_spawn) FALSE)
					)
						(begin
							(ai_place gvm_cf_near_right)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_far_right) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_far_right_spawn) FALSE)
					)
						(begin
							(ai_place gvm_cf_far_right)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_near_left) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_near_left_spawn) FALSE)
					)
						(begin
							(ai_place gvm_cf_near_left)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_far_left) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_far_left_spawn) FALSE)
					)
						(begin
							(ai_place gvm_cf_far_left)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
				(if 
					(AND
						(< (ai_living_count gvm_cf_rear) 1)
						(> (ai_living_count gm_fight_cortana) 0)
						(= (volume_test_players vol_gvm_rear_spawn) FALSE)
					)
						(begin
							(ai_place gvm_cf_rear)
							(sleep_until (< (ai_living_count gm_fight_flood) 15))
						)
				)
			)
			(< (ai_living_count gm_fight_cortana) 1)
		)
	)
)

;Cortana's initial reaction to the Gravemind
(global short gvm_dlg_pacer 0)
(script dormant gvm_cortana_reaction
	(sleep 60)
	(print "CORTANA:  It's him.  It.  Them.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "CORTANA:  We can't be stopped now.  We won't.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(print "CORTANA:  They're not taking either of us.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(set gvm_dlg_pacer 1)
)

;The Gravemind addresses you
(script dormant gvm_initial_address
	(sleep_until
		(OR
			(= gvm_dlg_pacer 1)
			(= (volume_test_players vol_nearer_gravemind) TRUE)
		)
	)
	(print "GRAVEMIND:  Pitiful creature!")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	
	(print "GRAVEMIND:  That you would come so far...")
	;(ai_play_line_on_object NONE ???)
	(sleep 120)
	(set gvm_dlg_pacer 2)
)

;Cortana tells you to get her on the Scarab
(script dormant gvm_cortana_plan
	(sleep_until
		(OR
			(= gvm_dlg_pacer 2)
			(= (volume_test_players vol_on_scarab_top) TRUE)
			(= (volume_test_players vol_on_scarab_bottom) TRUE)
		)
	)
	(if 
		(AND
			(< (ai_living_count gm_fight_cortana) 1)
			(= (volume_test_players vol_on_scarab_top) FALSE)
			(= (volume_test_players vol_on_scarab_bottom) FALSE)
		)
			(begin
				(print "CORTANA:  The Scarab!")
				;(ai_play_line_on_object NONE ???)
				(sleep 30)
			)
	)
	(if 
		(AND
			(< (ai_living_count gm_fight_cortana) 1)
			(= (volume_test_players vol_on_scarab_top) FALSE)
			(= (volume_test_players vol_on_scarab_bottom) FALSE)
		)
			(begin
				(print "CORTANA:  Get me on board.")
				;(ai_play_line_on_object NONE ???)
				(sleep 60)
			)
	)
	(print "CORTANA:  If these bastards want a fight, we'll give them one.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(set gvm_dlg_pacer 3)
)

;The Gravemind mocks your plan
(script dormant gvm_mock_plan
	(sleep_until 
		(OR
			(= gvm_dlg_pacer 3)
			(> (ai_living_count gm_fight_cortana) 0)
		)
	)
	(print "GRAVEMIND:  And now what can you hope to do?")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  Can this broken toy offer you more than we?")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  Your reunion shall be short-lived.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  We will take you both.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  We will have her, and you will be the bridge.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(sleep_until 
		(OR
			(> gvm_dlg_pacer 3)
			(> (ai_living_count gm_fight_cortana) 0)
		)
	)
	(print "GRAVEMIND:  Lay your lives down before us.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  We are your only end.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "GRAVEMIND:  Accept the truth.  Accept us.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(sleep_until 
		(AND
			(= gm_fight_dlg_mark 5)
			(> (ai_living_count gm_fight_cortana) 0)
		)
	)
	(print "GRAVEMIND:  After all this time, do you really think we would make such a fatal mistake?")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	
	(print "GRAVEMIND:  Entire civilizations have thrown down their lives in futile attempts to destroy us.  Yet here we stand.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	
	(print "GRAVEMIND:  And you.  You are but one man.")
	;(ai_play_line_on_object NONE ???)
	(sleep 120)

	(print "GRAVEMIND:  And we are your only end.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
)

;Cortana tells you to get her on the Scarab
(script dormant gvm_scarab_reminder
	(sleep_until
		(OR
			(= gvm_dlg_pacer 3)
			(> (ai_living_count gm_fight_cortana) 0)
		)
	)
	(sleep_until (> (ai_living_count gm_fight_cortana) 0) 1 600)
	(if 
		(AND
			(< (ai_living_count gm_fight_cortana) 1)
			(= (volume_test_players vol_on_scarab_top) FALSE)
			(= (volume_test_players vol_on_scarab_bottom) FALSE)
		)
			(begin
				(print "CORTANA:  Get me on that Scarab, Chief.")
				;(ai_play_line_on_object NONE ???)
				(sleep 90)
			)
	)
	(set gvm_dlg_pacer 4)

	(if 
		(AND
			(< (ai_living_count gm_fight_cortana) 1)
			(= (volume_test_players vol_power_core) FALSE)
		)
			(begin
				(print "CORTANA:  There should be an access panel near the power core.")
				;(ai_play_line_on_object NONE ???)
				(sleep 120)
			)
	)

	(sleep_until (> (ai_living_count gm_fight_cortana) 0) 1 600)
	(if 
		(AND
			(< (ai_living_count gm_fight_cortana) 1)
			(= (volume_test_players vol_power_core) FALSE)
		)
			(begin
				(print "CORTANA:  Bring me around to the Scarab's power core and plug me in.")
				;(ai_play_line_on_object NONE ???)
				(sleep 150)
			)
	)
)

;Cortana is inserted into the Scarab
(global short gm_fight_dlg_mark 0)
(global sound scarab_start "sound\vehicles\scorpion\scorpion_engine\scorpion_engine\in")
(global sound scarab_move "sound\device_machines\scarab\scarab_walk_move")
(global sound scarab_jitter "sound\device_machines\scarab\scarab_wobble_pieces")
(script dormant gvm_cortana_in_scarab
	(sleep_until (> (ai_living_count gm_fight_cortana) 0))
	(sleep 30)
	(print "CORTANA:  All right.  I'm in.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	
	(print "CORTANA:  Hold tight while I...")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(print "CORTANA:  Damn.  Main cannon is fried.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(print "CORTANA:  Guess we do it the hard way.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(print "CORTANA:  Just like old times.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)

	(print "CORTANA:  They're coming!")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "CORTANA:  Hold them off.  I have an idea.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)

	(sound_impulse_start scarab_start corty_scarab 1)
	(sleep 20)
	(sound_impulse_start scarab_start corty_scarab 1)
	(sleep 20)
	(sound_impulse_start scarab_start corty_scarab 1)
	(sleep 20)
	(sound_impulse_start scarab_start corty_scarab 1)
	(sleep 20)
	(sound_impulse_start scarab_start corty_scarab 1)
	(sleep 20)
	(device_set_power corty_scarab 1)
	(sleep 20)

	(print "CORTANA:  We've got power!")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	
	(print "CORTANA:  This heap isn't as dead as it looks.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)

	(print "CORTANA:  We may not have the main cannon or rear legs, but we've still got a functional fusion reactor.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)

	(print "CORTANA:  When the core is fully charged, we'll detonate it.")
	;(ai_play_line_on_object NONE ???)
	(sleep 120)

	(print "CORTANA:  I'll get us close.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)

	(print "CORTANA:  You just do what you do best.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)

	(print "CORTANA:  Hold on while I get this beast on its feet.")
	;(ai_play_line_on_object NONE ???)
	(set gm_fight_dlg_mark 1)
	(game_save)

	(sleep_until (= (device_get_position corty_scarab) .05))
	(print "CORTANA:  This thing is in worse shape than I thought.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(print "CORTANA:  Going to have to go one leg at a time.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(print "CORTANA:  Starting with the left.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	(game_save)
	(set gm_fight_dlg_mark 2)

	(sleep_until (= (device_get_position corty_scarab) .1))
	(print "CORTANA:  And now the right.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	(game_save)
	(set gm_fight_dlg_mark 3)

	(sleep_until (= (device_get_position corty_scarab) .128))
	(print "CORTANA:  Here comes the bump.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	(game_save)
	(set gm_fight_dlg_mark 4)

	(sleep_until (= (device_get_position corty_scarab) .238))
	(if
		(OR
			(= (volume_test_players vol_on_scarab_top) TRUE)
			(= (volume_test_players vol_on_scarab_bottom) TRUE)
		)
			(begin
				(print "CORTANA:  Sorry about that.")
				;(ai_play_line_on_object NONE ???)
				(sleep 60)
			)
	)
	(sleep 60)
	(print "CORTANA:  I'll need to build up some power for this next one.")
	;(ai_play_line_on_object NONE ???)
	(sleep 300)
	(print "CORTANA:  And...heave!")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	(game_save)
	(set gm_fight_dlg_mark 5)

	(sleep_until (= (device_get_position corty_scarab) .341))
	(game_save)
	(set gm_fight_dlg_mark 6)

	(sleep_until (= (device_get_position corty_scarab) .438))
;	(print "CORTANA:  Watch our backs, Chief.")
	;(ai_play_line_on_object NONE ???)
;	(sleep 90)
;	(print "CORTANA:  They have to know what we're up to.")
	;(ai_play_line_on_object NONE ???)
;	(sleep 210)
	(print "CORTANA:  That put a lot of stress on the joints.")
	;(ai_play_line_on_object NONE ???)
	(sleep 120)
	(print "CORTANA:  Servos are screaming.")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
	(print "CORTANA:  Running what self-repair systems are still operable.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
;	(print "CORTANA:  The left leg is running a little hot, but here goes.")
;	;(ai_play_line_on_object NONE ???)
;	(sleep 120)
	(game_save)
	(set gm_fight_dlg_mark 7)

	(sleep_until (= (device_get_position corty_scarab) .535))
	(print "CORTANA:  Can't last much longer like this.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(game_save)
	(set gm_fight_dlg_mark 8)

	(sleep_until (= (device_get_position corty_scarab) .572))
	(print "CORTANA:  The turrets are about to melt.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(print "CORTANA:  The engine is well past red-lined.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(print "CORTANA:  And the left leg is about to fall off.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(print "CORTANA:  But here goes nothing.")
	;(ai_play_line_on_object NONE ???)
	(sleep 90)
	(game_save)
	(set gm_fight_dlg_mark 9)

	(sleep_until (= (device_get_position corty_scarab) .627))
	(print "CORTANA:  I can't even feel this leg anymore.")
	;(ai_play_line_on_object NONE ???)
	(sleep 120)
	(print "CORTANA:  Strain levels in the servos are through the roof.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(game_save)
	(set gm_fight_dlg_mark 10)

	(sleep_until (= (device_get_position corty_scarab) .788))
	(print "CORTANA:  Just need to get a little closer to the edge.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(game_save)
	(set gm_fight_dlg_mark 11)

	(sleep_until (= (device_get_position corty_scarab) .841))
	(print "CORTANA:  Almost there.")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(game_save)
	(set gm_fight_dlg_mark 12)

	(sleep_until (= (device_get_position corty_scarab) .906))
	(print "CORTANA:  Just one more heave...")
	;(ai_play_line_on_object NONE ???)
	(sleep 150)
	(game_save)
	(set gm_fight_dlg_mark 13)

	(sleep_until (= (device_get_position corty_scarab) 1))
	(if (> (ai_living_count gm_fight_cortana) 0)
		(begin
			(print "CORTANA:  I'm as close as I can get, Chief.")
			;(ai_play_line_on_object NONE ???)
			(sleep 120)
		)
	)
	(if (> (ai_living_count gm_fight_cortana) 0)
		(begin
			(print "CORTANA:  The rest is up to you.")
			;(ai_play_line_on_object NONE ???)
			(sleep 90)
		)
	)
	(if (> (ai_living_count gm_fight_cortana) 0)
		(begin
			(print "CORTANA:  Come pick me up and blow the core.")
			;(ai_play_line_on_object NONE ???)
			(sleep 120)
		)
	)
	(game_save)
	
	(sleep_until (< (ai_living_count gm_fight_cortana) 1))
	(print "CORTANA:  All right.  Let's send this thing to Hell.")
	;(ai_play_line_on_object NONE ???)
	(game_save)
	(object_can_take_damage corty_scarab)

	(sleep_until (<= (object_get_health corty_scarab) 0) 1 300)
	(if (> (object_get_health corty_scarab) 0)
		(begin
			(print "CORTANA:  The core is charged, Chief.  Hit with all you've got.")
			;(ai_play_line_on_object NONE ???)
		)
	)

	(sleep_until (<= (object_get_health corty_scarab) 0) 1 300)
	(if (> (object_get_health corty_scarab) 0)
		(begin
			(print "CORTANA:  Blow the core, Chief!")
			;(ai_play_line_on_object NONE ???)
		)
	)
)

;The Gravemind roars in defeat
(script dormant gvm_defeat_roar
	(print "GRAVEMIND:  (enraged roar of defeat!!!)")
	;(ai_play_line_on_object NONE ???)
	(sleep 60)
)

;controls the scarab during the encounter
(script dormant scarab_mover	
	(sleep_until (= gm_fight_dlg_mark 1))
	(device_animate_position corty_scarab .05 10 0 0 0)
	
	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .05)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 2))
	(device_animate_position corty_scarab .1 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .1)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 3))
	(device_animate_position corty_scarab .128 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .128)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 4))
	(device_animate_position corty_scarab .238 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .238)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 5))
	(device_animate_position corty_scarab .341 20 0 0 0)
	
	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .341)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 6))
	(device_animate_position corty_scarab .438 20 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .438)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 7))
	(device_animate_position corty_scarab .535 20 0 0 0)
	
	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .535)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 8))
	(device_animate_position corty_scarab .572 10 0 0 0)
	
	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .572)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 9))
	(device_animate_position corty_scarab .627 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .627)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 10))
	(device_animate_position corty_scarab .788 20 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .788)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 11))
	(device_animate_position corty_scarab .841 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .841)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 12))
	(device_animate_position corty_scarab .906 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) .906)
		)
	1)
	(sleep_until (= gm_fight_dlg_mark 13))
	(device_animate_position corty_scarab 1 10 0 0 0)

	(sleep_until
		(begin
			(sound_impulse_start scarab_move corty_scarab 1)
			(sleep 60)
			(= (device_get_position corty_scarab) 1)
		)
	1)

	(sleep_until (= (volume_test_players vol_power_core) TRUE) 1)
	(ai_erase gm_fight_cortana)
)

;main script for the gravemind encounter
(script dormant gravemind_start
	(sleep_until 
		(AND
			(= cortana_rescued TRUE)
			(= (volume_test_players vol_gravemind_start) TRUE)
		)
	)
	(data_mine_set_mission_segment "110_12_gravemind")
	(game_save)
	(if (= lower_quad_started FALSE)
		(begin
			(objects_attach corty_scarab "" corty_tail "")
			(device_set_position_track corty_scarab death_crawl 0)
			(object_cannot_take_damage corty_scarab)
		)
	)
	(object_create gm_01)
	(object_create gm_02)
	(object_create gm_03)
	(wake gvm_cortana_reaction)
	(wake gvm_initial_address)
	(wake gvm_cortana_plan)
	(wake gvm_mock_plan)
	(wake gvm_scarab_reminder)
	(wake gvm_cortana_in_scarab)
	(wake scarab_mover)

	(sleep_until (= (volume_test_players vol_power_core) TRUE) 1)
	(ai_place gm_fight_cortana)
	(objects_attach corty_scarab "cortana" (list_get (ai_actors gm_fight_cortana) 0) "")
	(object_set_scale (list_get (ai_actors gm_fight_cortana) 0) .5 0)
	(sleep 1)
	(wake infinite_devil_machine)

	(sleep_until (<= (object_get_health corty_scarab) 0))
	(wake gvm_defeat_roar)
	(wake objective_2_clear)
	(sleep 60)
	(end_mission)
)
	

;*********************************************************************;
;Main Mission Script
;*********************************************************************;

(global short teleport_number 0)
(script startup mission
	(print_difficulty)
	(cinematic_snap_to_black)
	(ai_allegiance player covenant)
	(ai_allegiance player human)
	(game_can_use_flashlights TRUE)
	(objectives_clear)

	(if (= (volume_test_objects vol_starting_locations (players)) TRUE)
		(begin
			(if (cinematic_skip_start)
				(begin
					;(110la_hc_arrival)
					(print "cinematic goes here")
				)
			)
			(cinematic_skip_stop)
		)
	)
	(object_teleport (player0) start_player0)
	(object_teleport (player1) start_player1)
	(sleep 1)
;	(cinematic_fade_from_black)
	(wake 110_title1)

;	(switch_zone_set ab_start_shell)

	(wake recycle_volumes)
	(wake tough_saving)
	(wake banshee_ledge_start)
	(wake colon_1a_start)

	(sleep_until 
		(OR
			(= (current_zone_set) 1)
			(> teleport_number 0)
		)
	)
;	(if (< teleport_number 2)
;		(wake colon_1a_start)
;	)
	(if (< teleport_number 3)
		(wake colon_1b_start)
	)

	(sleep_until 
		(OR
			(= (current_zone_set) 2)
			(> teleport_number 2)
		)
	)
	(if (< teleport_number 4)
		(begin
			(wake bridge_1_start)
			(wake maus_start)
			(wake bridge_2_start)
		)
	)

	(sleep_until 
		(OR
			(= (current_zone_set) 3)
			(> teleport_number 3)
		)
	)
	(if (< teleport_number 5)
		(wake colon_2a_start)
	)
	(if (< teleport_number 6)
		(wake snot_shaft_start)
	)

	(sleep_until 
		(OR
			(= (current_zone_set) 4)
			(> teleport_number 5)
		)
	)
	(if (< teleport_number 7)
		(wake colon_2b_start)
	)
	(if (< teleport_number 8)
		(wake lower_quad_start)
	)

	(sleep_until 
		(OR
			(= (current_zone_set) 5)
			(> teleport_number 7)
		)
	)
	(if (< teleport_number 9)
		(begin
			(wake colon_3_start)
			(wake corty_start)
		)
	)
	(if (< teleport_number 10)
		(wake gravemind_start)
	)
)


(script command_script pel_cs
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until
		(begin
			(cs_fly_by pel_pts/p0)
			(cs_fly_by pel_pts/p1)
			(cs_fly_by pel_pts/p2)
			(cs_fly_by pel_pts/p3)
			(cs_fly_by pel_pts/p4)
			(cs_fly_by pel_pts/p5)
			(cs_fly_by pel_pts/p6)
			(cs_fly_by pel_pts/p7)
			FALSE
		)
	)
)

(script static void pel_attach
	(ai_place pel)
;	(object_create_anew pel_rack)
	(sleep 1)
;	(objects_attach (ai_vehicle_get_from_starting_location pel/pilot) "pelican_sc_01" horny "latch")
;	(objects_attach (ai_vehicle_get_from_starting_location pel/pilot) "pelican_sc_01" pel_rack "")
)