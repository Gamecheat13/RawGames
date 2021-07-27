;	Script: 		Halo Mission C40


; STUB SCRIPTS =================================================================
(script stub void cutscene_insertion
	(print "Joe's stuff")
	)

(script stub void cutscene_extraction
	(print "Joe's stuff")
	)

; OBJECTIVE SCRIPTS ============================================================

;Destroy Pulse Gen #1
(script dormant objective_1
	(hud_set_objective_text dia_1)
	(show_hud_help_text 1)
	(hud_set_help_text obj_1)
	(sleep 120)
	(show_hud_help_text 0)
)

;Move to Canyon B
(script dormant objective_2
	(hud_set_objective_text dia_2)
	(show_hud_help_text 1)
	(hud_set_help_text obj_2)
	(sleep 120)
	(show_hud_help_text 0)
)

;Destroy PUlse Gen #2
(script dormant objective_3
	(hud_set_objective_text dia_3)
	(show_hud_help_text 1)
	(hud_set_help_text obj_3)
	(sleep 120)
	(show_hud_help_text 0)
)

;Move through tunnels to Canyon A
(script dormant objective_4
	(hud_set_objective_text dia_4)
	(show_hud_help_text 1)
	(hud_set_help_text obj_4)
	(sleep 120)
	(show_hud_help_text 0)
)

;Destroy Pulse Gen #3
(script dormant objective_5
	(hud_set_objective_text dia_5)
	(show_hud_help_text 1)
	(hud_set_help_text obj_5)
	(sleep 120)
	(show_hud_help_text 0)
)


;= CHAPTER BREAKS ==============================================================
(script static void chapter_c40_1
	; Switch to letterbox
	(show_hud false)
	(cinematic_show_letterbox true)
	
	; Title break goes here
	(sleep 30)
	(cinematic_set_title chapter_c40_1)
	(sleep 150)
	
	;Switch back to HUD
	(cinematic_show_letterbox false)
	(show_hud true)
)

(script static void chapter_c40_2
; Switch to letterbox
	(show_hud false)
	(cinematic_show_letterbox true)
	
	; Title break goes here
	(sleep 30)
	(cinematic_set_title chapter_c40_2)
	(sleep 150)
	
	;Switch back to HUD
	(cinematic_show_letterbox false)
	(show_hud true)
)	

(script static void chapter_c40_3
; Switch to letterbox
	(show_hud false)
	(cinematic_show_letterbox true)
	
	; Title break goes here
	(sleep 30)
	(cinematic_set_title chapter_c40_3)
	(sleep 150)
	
	;Switch back to HUD
	(cinematic_show_letterbox false)
	(show_hud true)
)	

(script static void chapter_c40_4
; Switch to letterbox
	(show_hud false)
	(cinematic_show_letterbox true)
	
	; Title break goes here
	(sleep 30)
	(cinematic_set_title chapter_c40_4)
	(sleep 150)
	
	;Switch back to HUD
	(cinematic_show_letterbox false)
	(show_hud true)
)	


;= Global Variables ============================================================
(global boolean debug false) ;true = print, false = don't print

;(global boolean plat_1_ban_a false)
;(global boolean plat_1_ban_b false)
 
(global boolean e4_fled false)

(global short one 1)
(global short two 2)

(global short e65_a_limiter 0)
(global short e65_a_total 5)

(global short e66_a_limiter 0)
(global short e66_a_total 5)

(global short e5_landbridge_limiter 0)
(global short e5_landbridge_total 4)

(global boolean play_speech true)


;= Music Scripts ===============================================================
(global boolean play_music_c40_01 false)
(global boolean play_music_c40_01_alt false)

(global boolean play_music_c40_02 false)
(global boolean play_music_c40_02_alt false)

(global boolean play_music_c40_03 false)
(global boolean play_music_c40_03_alt false)

(global boolean play_music_c40_04 false)
(global boolean play_music_c40_04_alt false)

(global boolean play_music_c40_05 false)
(global boolean play_music_c40_05_alt false)

(global boolean play_music_c40_051 false)
(global boolean play_music_c40_051_alt false)

(global boolean play_music_c40_06 false)
(global boolean play_music_c40_06_alt false)

(global boolean play_music_c40_07 false)
(global boolean play_music_c40_07_alt false)

(global boolean play_music_c40_08 false)
(global boolean play_music_c40_08_alt false)

(global boolean play_music_c40_09 false)
(global boolean play_music_c40_09_alt false)

(global boolean play_music_c40_10 false)
(global boolean play_music_c40_10_alt false)

(global boolean play_music_c40_101 false)
(global boolean play_music_c40_101_alt false)

(global boolean play_music_c40_11 false)
(global boolean play_music_c40_11_alt false)

;= Waypoint Control ============================================================

; Highlight the where to land banshee
(script static void waypoint_1
	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint1 0)
)

; Highlight the first pulse gen
(script static void waypoint_2
	; Deactivate last waypoint
	(deactivate_team_nav_point_flag player waypoint1)

	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint2 0)
)

; Highlight the bridge door
(script static void waypoint_3
	; Deactivate last waypoint
	; Placed in script e7_b

	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint3 0)
)

; Hightlight the second landing pad
(script static void waypoint4
	; Deactivate last waypoint
	
	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint4 0)
)

; Hightlight the tunnel
(script static void waypoint5
	; Deactivate last waypoint
	
	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint5 0)
)


; Hightlight the last landing pad
(script static void waypoint6
	; Deactivate last waypoint
	
	; Activate nav point for players
	(activate_team_nav_point_flag "default_red" player waypoint6 0)
)

; =GAME SAVE CHECKPOINTS =======================================================
(script static void save_checkpoint1_1
	(sleep_until (volume_test_objects save_checkpoint1 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.1"))
   (mcc_mission_segment "02")
)

; Save checkpoint 1_2
(script static void save_checkpoint1_2
	(sleep_until (volume_test_objects save_checkpoint2 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.2"))
   (mcc_mission_segment "03")
)

; Save checkpoint 1_2
(script static void save_checkpoint1_2a
	(sleep_until (volume_test_objects save_checkpoint2a (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.2a"))
   (mcc_mission_segment "04")
)

; Save checkpoint 1_3
(script static void save_checkpoint1_3
	(sleep_until (volume_test_objects save_checkpoint3 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.3"))
   (mcc_mission_segment "05")
)

; Save checkpoint 1_3
(script static void save_checkpoint1_3a
	(sleep_until (volume_test_objects save_checkpoint3a (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.3a"))
   (mcc_mission_segment "06")
)

; Save checkpoint 1_4
;(script static void save_checkpoint1_4
;	(sleep_until (volume_test_objects save_checkpoint4 (players)) 10)
;	(game_save_no_timeout)
;	(if debug (print "Saved at Checkpoint 1.4"))
;	(game_save) 
;)

; Save checkpoint 1_5
(script static void save_checkpoint1_5
	(sleep_until (volume_test_objects save_checkpoint5 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.5"))
   (mcc_mission_segment "07")
)

; Save checkpoint 1_6
(script static void save_checkpoint1_6
	(sleep_until (= (device_get_position pulse_gen1) 0))
	(sleep_until (volume_test_objects save_checkpoint6 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at Checkpoint 1.6"))
   (mcc_mission_segment "08")
)

; Save checkpoint 1_7
(script static void save_checkpoint1_7
	(sleep_until (volume_test_objects save_checkpoint7 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 1.7"))
   (mcc_mission_segment "09")
)

; Save checkpoint 1_8
(script static void save_checkpoint1_8
	(sleep_until (volume_test_objects save_checkpoint8 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 1.8"))
   (mcc_mission_segment "10")
)

; Save checkpoint 1_9
(script static void save_checkpoint1_9
	(sleep_until (volume_test_objects save_checkpoint9 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 1.9"))
   (mcc_mission_segment "11")
)

; Save checkpoint 2_0
(script static void save_checkpoint2_0
	(sleep_until (volume_test_objects save_checkpoint20 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.0"))
   (mcc_mission_segment "12")
)

; Save checkpoint 2_1
(script static void save_checkpoint2_1
	(sleep_until (volume_test_objects save_checkpoint21 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.1"))
   (mcc_mission_segment "13")
)

; Save checkpoint 2_2
(script static void save_checkpoint2_2
	(sleep_until (volume_test_objects save_checkpoint22 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.2"))
   (mcc_mission_segment "14")
)

; Save checkpoint 2_3
(script static void save_checkpoint2_3
	(sleep_until (volume_test_objects save_checkpoint23 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.3"))
   (mcc_mission_segment "15")
)

(script static void save_checkpoint2_4
	(sleep_until (volume_test_objects save_checkpoint24 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.4"))
   (mcc_mission_segment "16")
)

(script static void save_checkpoint2_5
	(sleep_until (volume_test_objects save_checkpoint25 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.5"))
   (mcc_mission_segment "17")
)

(script static void save_checkpoint2_6
	(sleep_until (volume_test_objects save_checkpoint26 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.6"))
   (mcc_mission_segment "18")
)

(script static void save_checkpoint2_7
	(sleep_until (volume_test_objects save_checkpoint27 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.7"))
   (mcc_mission_segment "19")
)

;(script static void save_checkpoint2_8
;	(sleep_until (volume_test_objects save_checkpoint28 (players)) 10)
;	(game_save_no_timeout)
;	(if debug (print "Saved at checkpoint 2.8"))
;	(game_save)
;)

(script static void save_checkpoint2_9
	(sleep_until (volume_test_objects save_checkpoint29 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 2.9"))
   (mcc_mission_segment "20")
)

(script static void save_checkpoint3_0
	(sleep_until (= (device_get_position pulse_gen2) 0))
	(sleep_until (volume_test_objects save_checkpoint30 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.0"))
   (mcc_mission_segment "21")
)

(script static void save_checkpoint3_1
	(sleep_until (volume_test_objects save_checkpoint31 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.1"))
   (mcc_mission_segment "22")
)

(script static void save_checkpoint3_2
	(sleep_until (volume_test_objects save_checkpoint32 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.2"))
   (mcc_mission_segment "23")
)

(script static void save_checkpoint3_3
	(sleep_until (volume_test_objects save_checkpoint33 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.3"))
   (mcc_mission_segment "24")
)

(script static void save_checkpoint3_3a
	(sleep_until (volume_test_objects save_checkpoint33a (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.3a"))
   (mcc_mission_segment "25")
)

;(script static void save_checkpoint3_3b
;	(sleep_until (volume_test_objects save_checkpoint33b (players)) 10)
;	(game_save_no_timeout)
;	(if debug (print "Saved at checkpoint 3.3b"))
;	(game_save)
;)

(script static void save_checkpoint3_4
	(sleep_until (volume_test_objects save_checkpoint34 (players)) 10)
	(game_save_no_timeout)
	(if debug (print "Saved at checkpoint 3.4"))
   (mcc_mission_segment "26")
)

; Save checkpoint thread script
(script dormant save_checkpoints
	; Debug text
	(if debug (print "Save Checkpoints Running..."))

	; Checkpoints order. 
	(save_checkpoint1_1)
	(save_checkpoint1_2)
	(save_checkpoint1_2a)
	(save_checkpoint1_3)
	(save_checkpoint1_3a)
;	(save_checkpoint1_4)
	(save_checkpoint1_5)
	(save_checkpoint1_6)
	(save_checkpoint1_7)
	(save_checkpoint1_8)
	(save_checkpoint1_9)
	(save_checkpoint2_0)
	(save_checkpoint2_1)
	(save_checkpoint2_2)
	(save_checkpoint2_3)
	(save_checkpoint2_4)
	(save_checkpoint2_5)
	(save_checkpoint2_6)	
	(save_checkpoint2_7)
;	(save_checkpoint2_8)
	(save_checkpoint2_9)
	(save_checkpoint3_0)
	(save_checkpoint3_1)
	(save_checkpoint3_2)
	(save_checkpoint3_3)
	(save_checkpoint3_3a)
;	(save_checkpoint3_3b)	
	(save_checkpoint3_4)
)


;= CONTINUOUS SCRIPTS ==========================================================

; Banshee Spawner Plat #1


;(script continuous ban_spawn_1
;	(sleep 30)
;	(if debug (print "Banshee's Plat #1 Spawning"))
;
;Respawns Banshee #1
;	(if 
;		(and
;			(volume_test_objects plat_1_check (player0))
;			(not (volume_test_objects plat_1_check ban_plat1_a))
;		)
;		(begin
;			(object_destroy ban_plat1_a)
;			(sleep 1)			
;			(object_create ban_plat1_a)			
;			(sleep 1)
;		)
;	)

;Respawns Banshee #2
;	(if 
;		(and
;			(volume_test_objects plat_1_check (player1))
;			(not (volume_test_objects plat_1_check ban_plat1_a))
;		)
;		(begin
;			(object_destroy ban_plat1_b)
;			(sleep 1)			
;			(object_create ban_plat1_b)			
;			(sleep 1)
;		)
;	)
;)

(script continuous ban_spawn_2
	(sleep 30)
	(if debug (print "Banshee Bottom #2 Spawner"))
	
; Respawn
	(if (<= (unit_get_health e50_a_ban_1) 0)
		(begin
			(sleep 120)
			(object_destroy e50_a_ban_1)
			(if debug (print "ban_1_destroyed"))
			(sleep 30)
			(object_create e50_a_ban_1)
			(if debug (print "create ban_1"))
		)
	)		

	(if 
		(<= (unit_get_health e50_a_ban_2) 0)
		(begin
			(sleep 120)
			(object_destroy e50_a_ban_2)
			(if debug (print "ban_2_destroyed"))
			(sleep 30)	
			(object_create e50_a_ban_2)
			(if debug (print "ban_2_created"))
		)
	)		
)		

; Encounter e66, Spawner
(script continuous e66_a_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(sleep 30)
	(if debug (print "major sentinel spawner"))

	(if 
		(and
			(< (ai_living_count e66_a/sentinel) 5)
			(< e66_a_limiter e66_a_total)
		)
		; Spawn
		(begin
			(if debug (print "+1 Sentinel"))
			(ai_spawn_actor e66_a/sentinel) 
			(sleep 3)

			(ai_magically_see_players e66_a)
			(set e66_a_limiter (+ e66_a_limiter 1))
		)
	)	
)


; Encounter e65, Spawner
(script continuous e65_a_spawner
	; Check if the player is in the spawn area and the limit isn't exceeded
	(sleep 30)
	(if debug (print "sentinel spawner"))

	(if 
		(and
			(< (ai_living_count e65_a/sentinel) 5)
			(< e65_a_limiter e65_a_total)
		)
		; Spawn
		(begin
			(if debug (print "+1 Sentinel"))
			(ai_spawn_actor e65_a/sentinel) 
			(sleep 3)

			(ai_magically_see_players e65_a)
			(set e65_a_limiter (+ e65_a_limiter 1))
		)
	)	
)

; Encounter 5, Flood on the Bridge Spawner
;(script continuous e5_a_spawner
;	; Check if the player is in the spawn area dn the limit isn't exceeded
;	(if debug (print "bridge spawner"))
;	(sleep 30)
;	(if debug (print "bridge spawner"))
;
;	(if 
;		(and
;			(< e5_landbridge_limiter e5_landbridge_total) 
;			(< (ai_living_count c3_flood_landbridge/flood_carrier) 2) 		
;		)
;		(begin 
;			(if debug (print "+1 Flood Carrier"))
;			(ai_spawn_actor c3_flood_landbridge/flood_carrier)
;			(set e5_landbridge_limiter (+ e5_landbridge_limiter 1))
;		)
;	)
;)

; Check for Speech
(script continuous speech_check
	(sleep 60)
	(if 
		(and
			(volume_test_objects speech_210_trigger (players))
			play_speech
		)
		(begin
			(sound_impulse_start sound\dialog\c40\c40_210_Cortana none 1)
			(set play_speech false)
		)
	)	
)

;= TURN OFF CONTINUOUS SCRIPTS =================================================

(script static void kill_all_cont
	; Debug
	(if debug (print "Killing off continuous scripts..."))
	
	; Sleep all continuous
	(sleep -1 e66_a_spawner)
	(sleep -1 ban_spawn_2)
	(sleep -1 e65_a_spawner)
;	(sleep -1 e5_a_spawner)
	(sleep -1 speech_check)
)


;= MISSION SCRIPTS =============================================================

(script dormant end
	(sleep_until (volume_test_objects pulse_3_trigger (players)))

	;Debug
	(damage_object "effects\damage effects\pulsegenerator" (player0))
	(damage_object "effects\damage effects\pulsegenerator" (player1))

	(device_set_position_immediate pulse_gen3 0)
 	(sound_impulse_start sound\sfx\impulse\impacts\c40_generator_overload pulse_gen3 1)
	(sleep 60)
	
	(if debug (print "Cortana says, 'Good job, You've overloaded Generator #3'"))
	(sound_impulse_start sound\dialog\c40\c40_270_Cortana none 1)

	;Place the units and give them sight
	(sleep_until (= (device_get_position pulse_gen3) 0))


; Dan, I hacked this together just so the mission would end. Waiting until all the sentinels are dead
; was very confusing. I killed the sentinels with the reactor so it seems like they go up when you disable halo
; (or whatever you're doing to halo). Maybe have some sentinels at the door to greet the player so you can't
; run in and blow the reactor.

	(ai_kill e66_a)
	(sleep 60)
	(sleep_until (> (list_count (players)) 0) 1)	; TG - Sleep until a player is alive
   
   (if (mcc_mission_segment "cine2_final") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_extraction))
	    (cinematic_skip_stop)
	(game_won)
)

;Final Battle in 3rd Pulse Gen.
(script dormant e66_a
	(sleep_until (volume_test_objects e66_a_trigger (players)))
	
	;debug
	(if debug (print "e66_a active- Need to get Big Sentinels from Jason"))
	
	;Place
	(wake e66_a_spawner)
	(sleep -1 e65_a_spawner)
	(sleep 10)
)

;Turn off the last Waypoint
(script dormant last_waypoint_off
	(sleep_until (volume_test_objects third_lp_trigger (players)))
	
	;debug
	(if debug (print "bye bye waypoint"))
	
	;Place, etc..
	(object_create pulse_gen3)
	(deactivate_team_nav_point_flag player waypoint6)
	(wake e66_a)
)

;Last music check
(script dormant turn_off_music
	(sleep_until (or (and (= (ai_living_count e62_d) 0)
					  (= (ai_living_count e62_e) 0)
					  (= (ai_living_count e65_a) 0))
				  (volume_test_objects e65_a_trigger (players))))
;)
;		(or
;			(vehicle_test_seat_list e62_a_ban_1 b-driver (players))
;			(vehicle_test_seat_list e62_a_ban_2 b-driver (players))
;		)
;	)
	
	(set play_music_c40_11 false)
	(set play_music_c40_11_alt false)
)


;Sentinels fighting you outside of last platform
(script dormant e65_a
	(sleep_until (volume_test_objects e65_a_trigger (players)))
	
	;debug
	(if debug (print "e65_a active"))
	
	;Place, activate, blah, blah...
	(wake e65_a_spawner)
	(sleep 1)
	(wake turn_off_music)
	(sleep 1)
	(wake last_waypoint_off)
)

(script dormant e62_e
	(sleep_until (< (ai_living_count e62_d) 6))
	(if debug (print "3rd wave!!!"))
	
	(ai_place e62_e)
	(sleep 2)
	(set play_music_c40_11_alt true)		
	(wake e65_a)
)

(script dormant e62_d	
	(sleep_until (< (ai_living_count e62_a) 6))
	(if debug (print "2nd Wave!!!"))

	(ai_place e62_d)
	(sleep 2)
	(ai_magically_see_players e62_d)

	(wake e62_e)
)

(script dormant e62_c
	(sleep_until (< (ai_living_count e62_a) 8))
	(if debug (print "Elites!!!"))

	(ai_place e62_c)
	(sleep 2)
	(ai_follow_target_players e62_a)
	(ai_magically_see_players e62_a)
)

(script dormant e62_b
	(sleep_until (volume_test_objects e62_b_trigger (players)))

	;Debug
	(if debug (print "Flood attacking!!!"))
	
	;Place
	(set play_music_c40_11 true)	

	(ai_place e62_b)
	(wake e65_a)
)

;Force Save
(script dormant banshee_save3
	(sleep_until 
		(or	
			(vehicle_test_seat_list e62_a_ban_1 b-driver (players))
			(vehicle_test_seat_list e62_a_ban_2 b-driver (players))))
		
			(game_save_no_timeout)
)

(script dormant e62_a
	(sleep_until (volume_test_objects e62_a_trigger (players)))
	(if debug (print "Main Base placed!!!"))
	
	;deleting stuff now
	(ai_erase e60_e)
	(ai_erase e60_d)	
	(ai_erase e60_a)
	(ai_erase e60_c)
	
	;creating mission now
	(object_create e62_a_wra_1)
	(object_create e62_a_wra_2)
	(object_create	e62_a_tur_1)
	(object_create	e62_a_ban_1)	
	(object_create	e62_a_ban_2)
	(ai_place e62_a)

	(ai_vehicle_enterable_distance e62_a_tur_1 7)
	(ai_vehicle_enterable_actor_type e62_a_tur_1 grunt)
	
	(ai_vehicle_encounter e62_a_wra_1 e62_a/wra_pilot_a)
	(vehicle_load_magic e62_a_wra_1 "driver" (ai_actors e62_a/wra_pilot_a))
	
	(ai_vehicle_encounter e62_a_wra_2 e62_a/wra_pilot_b)
	(vehicle_load_magic e62_a_wra_2 "driver" (ai_actors e62_a/wra_pilot_b))
	
	(sleep 30)			
	(wake banshee_save3)
	(sleep 2)
	(wake e62_b)
	(sleep 2)
	(wake e62_c)
	(sleep 2)
	(wake e62_d)
	(sleep 2)
	(wake end)
)

(script dormant e61_a
	(sleep_until (volume_test_objects e61_a_trigger (players)))
	(ai_place e61_a)
	(ai_place e61_b)

	(wake e62_a)
	(sleep 1)
)

(script dormant e60_e
	(sleep_until (<= (ai_nonswarm_count e60_d) 5))
	
	;Debug
	(if debug (print "e60_e- Here comes more!!!"))
	
	;Do stuff 
	(ai_place e60_e)
	(sleep 10)
	(ai_magically_see_players e60_e)
)

(script dormant e60_d
	(sleep_until (<= (ai_nonswarm_count e60_c) 5))
	
	;Debug
	(if debug (print "e60_d- Here comes the army!"))
	
	;Do stuff
	(ai_place e60_d)
	(sleep 10)
	(ai_magically_see_encounter e60_d e60_a)
	(ai_attack e60_d)
	(wake e60_e)
	(sleep 5)
	(wake e61_a)
	(sleep 5)
)

;Outside Canyon A
(script dormant e60_a
	(sleep_until (volume_test_objects e60_a_trigger (players)))
	
	;debug
	(if debug (print "e60_a active"))
	
	;Place
	(set play_music_c40_101 true)
	(chapter_c40_4)
	(wake objective_5)
	(waypoint6)
	(ai_place e60_a)
	(ai_place e60_banshee)
	
	(sleep 1)
	
	(object_create c_banshee_1)
	(object_create c60_a_1)
	(object_create c60_a_2)
	(object_create c60_a_gho_1)			
	(object_create c60_a_gho_2)

	(sleep 1)

	(ai_vehicle_enterable_distance c60_a_1 7)
	(ai_vehicle_enterable_actor_type c60_a_1 grunt)
	
	(ai_vehicle_enterable_distance c60_a_2 7)
	(ai_vehicle_enterable_actor_type c60_a_2 grunt)

	(ai_vehicle_encounter c_banshee_1 e60_banshee/eli_maj_pilot_a)
	(vehicle_load_magic c_banshee_1 "driver" (ai_actors e60_banshee/eli_maj_pilot_a))
	(unit_set_enterable_by_player c_banshee_1 0)
			
	(sleep 5)
	(ai_place e60_c)
	
	(wake e60_d)

	(object_create_containing object_x)
)

;Flood Canyon 2st Part of Bridge
(script dormant e59_c
	(sleep_until (volume_test_objects e59_c_trigger (players)))
	(ai_place e59_c)
	(wake e60_a)
	
	(sleep 300)
	(set play_music_c40_10 false)	
)

;Flood Canyon 1st Part of Bridge
(script dormant e59_b
	(sleep_until (volume_test_objects e59_b_trigger (players)))
	(ai_place e59_b)
	(wake e59_c)
	(sleep 150)
)

;Tunnel Bridge
(script dormant e59_a
 	(sleep_until (volume_test_objects e59_a_trigger (players)))
 	(ai_place e59_a)
 	(wake e59_b)
 	
	(set play_music_c40_10 true)	 	
	
; Deleting stuff now
	(ai_erase e58_a)
		
	(object_destroy e57_tur_a)
	(object_destroy e51_tur_1)
	(object_destroy e51_tur_2)
	(object_destroy e51_tur_3)
	(object_destroy e51_tur_4)
	(object_destroy e51_ban_1)
	(object_destroy e51_ban_2)
	(object_destroy ban_plat2_a)
	(object_destroy ban_plat2_b)
	(object_destroy e50_a_tur_1)
	(object_destroy e50_a_ban_1)
	(object_destroy e50_a_ban_2)
	(object_destroy e50_b_wra_1)
	(object_destroy e50_b_ban_2)
	(object_destroy e50_b_ban_3)
	(object_destroy pulse_gen2)
	
	(device_set_power door_gen2 0)

)

(script dormant e57_a
	(sleep_until (volume_test_objects tunnel_trigger (players)))
	
	;debug
	(if debug (print "e57_a active"))

	;Delete stuff here
	(ai_erase e51_a)
	
	;Place
	(ai_conversation_stop cortana_230_250)
	(ai_conversation cortana_260)
	
	(wake e59_a)
		
	(object_create e57_tur_a)
	(ai_vehicle_enterable_distance e57_tur_a 7)
	
	(ai_place e57_a)
	(sleep 30)
	
	(ai_place e58_a/guard1)	
	(ai_place e58_a/wave1)
	
	(ai_prefer_target (players) true)
	
	(sleep_until (<= (ai_nonswarm_count e58_a/wave1) 1))
	(ai_place e58_a/wave2a)
	(ai_place e58_a/wave2b)
	(ai_prefer_target (players) true)

	(sleep_until (<= (ai_nonswarm_count e58_a/wave2b) 1))
	(ai_place e58_a/wave3a)
	(ai_place e58_a/wave3b)
	(ai_prefer_target (players) true)
	
	(sleep_until (<= (ai_nonswarm_count e58_a/wave3b) 3))
	(ai_place e58_a/wave4a)
	(ai_place e58_a/wave4b)
	(ai_place e58_a/wave4c)
	(ai_place e58_a/wave4d)
	(ai_prefer_target (players) true)		
)

(script dormant waypoint_off
	(sleep_until (volume_test_objects waypoint5_trigger (players)))
	
	;debug
	(if debug (print "TURN IT OFF"))
	
	(deactivate_team_nav_point_flag player waypoint5)
)

(script dormant c40_230_240_250
	(sleep_until (volume_test_objects c40_230_240_250_trigger (players)))
	
	;debug
	(if debug (print "update...."))
		
	(wake waypoint_off)
	(sleep 1)
	
	(wake e57_a)
	(sleep 1)
	
	(chapter_c40_3)
	(waypoint5)
	(ai_conversation cortana_230_250)	
)

; Pulse Gen #2
(script dormant e53_a
	(sleep_until (volume_test_objects pulse_2_trigger (players)))
	
	(sleep -1 speech_check)
	(sleep -1 ban_spawn_2)
	(ai_place e53_a)
	
	;Debug
	(damage_object "effects\damage effects\pulsegenerator" (player0))
	(damage_object "effects\damage effects\pulsegenerator" (player1))

	(device_set_position_immediate pulse_gen2 0)
 	(sound_impulse_start sound\sfx\impulse\impacts\c40_generator_overload pulse_gen2 1)
	
	(device_set_power tun_garage_1_con_a 1)
	(wake c40_230_240_250)

	(object_create ban_plat2_a)
	(if (game_is_cooperative) (object_create ban_plat2_b))

	(sleep 60)
	(if debug (print "Cortana says, 'Good job, You've overloaded Generator #2'"))
	(sound_impulse_start sound\dialog\c40\c40_220_Cortana none 1)		

	(wake objective_4)

	;Place the units and give them sight
)

(script dormant e52_c
	(sleep_until (volume_test_objects e52_c_trigger (players)))
	
	;Debug
	(if debug (print "lalalalal" ))
	
	;Place
	(ai_place e52_c)
	(wake e53_a)
)

(script dormant force_save_3
	(sleep_until (= (ai_living_count e52_a) 0))
	(game_save_no_timeout)
)

(script dormant e52_a
	(sleep_until (volume_test_objects e52_a_trigger (players)) 15)
	
	(if debug (print "e52_a active"))

	;Place
	(ai_place e52_a)
	(sleep 1)
	(ai_place e52_b)
	
	(sleep 2)
	(wake force_save_3)
	(wake e52_c)
	
)

(script dormant second_lp
	(sleep_until (volume_test_objects second_lp_trigger (players)))

	(object_create pulse_gen2)
	(deactivate_team_nav_point_flag player waypoint4)	
	(set play_music_c40_09 false)	
	;Debug
)

;Fraking top base
(script dormant e51_a
	(sleep_until (volume_test_objects e51_a_trigger (players)) 15)

	;Debug

	;Do stuff
	(wake second_lp)
	(wake e52_a)
	
	(object_create	e51_tur_1)
	(object_create e51_tur_2)
	(object_create e51_tur_3)
	(object_create	e51_tur_4)
	(object_create e51_ban_1)
	(object_create e51_ban_2)
	(object_create ban_mid_a)
	
	(ai_vehicle_enterable_distance e51_tur_1 7)
	(ai_vehicle_enterable_distance e51_tur_2 7)
	(ai_vehicle_enterable_distance e51_tur_3 7)
	(ai_vehicle_enterable_distance e51_tur_4 7)

	(ai_vehicle_enterable_actor_type e51_tur_1 grunt)
	(ai_vehicle_enterable_actor_type e51_tur_2 grunt)
	(ai_vehicle_enterable_actor_type e51_tur_3 grunt)
	(ai_vehicle_enterable_actor_type e51_tur_4 grunt)

	;Place units/wake/etc...
	(ai_place e51_a)
	(ai_place e51_b)

	(ai_vehicle_encounter e51_ban_1 e51_b/eli_maj_pilot_a)
	(ai_go_to_vehicle e51_b/eli_maj_pilot_a e51_ban_1 driver)
	(ai_magically_see_players e51_b)
	
	(sleep 900)
	(if debug (print "backup #1 launched"))
	(ai_vehicle_encounter e51_ban_2 e51_b/eli_maj_pilot_b)
	(ai_go_to_vehicle e51_b/eli_maj_pilot_b e51_ban_2 driver)
	(ai_magically_see_players e51_b)
)

;Base Music
(script dormant banshee_music
	(sleep_until 
		(or
			(vehicle_test_seat_list e50_a_ban_1 b-driver (players))
			(vehicle_test_seat_list e50_a_ban_2 b-driver (players))
		)
	)
	
	(set play_music_c40_09 true)	
)

;Force Save
(script dormant banshee_save2
	(sleep_until 
		(or	
			(vehicle_test_seat_list e50_a_ban_1 b-driver (players))
			(vehicle_test_seat_list e50_a_ban_2 b-driver (players))))
		
			(game_save_no_timeout)
)

;Bottom Base
(script dormant e50_a
	(sleep_until (volume_test_objects e50_a_trigger (players)))

	;Debug
	(if debug (print "e50_a active- BOTTOM BASE"))

	;Deleting stuff
	(object_destroy c2_wra_a)
	(object_destroy c2_ban_a)
	(object_destroy c2_tur_a)
	(object_destroy c2_tur_b)

	;Place units/wake/etc...
	(device_set_power tun_garage_1_con_a 0)
	
	(object_create e50_a_tur_1)

	(object_create e50_a_ban_1)
	(object_create e50_a_ban_2)

	(object_create e50_b_wra_1)
	(object_create e50_b_ban_2)
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (object_create e50_b_ban_3))
	
	(ai_place e50_a)
	(ai_place e50_b/eli_maj_pilot_b)
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (ai_place e50_b/eli_maj_pilot_c))
	(sleep 2)

	(ai_vehicle_enterable_distance e50_a_tur_1 7)
	
	(ai_vehicle_encounter e50_b_wra_1 e50_a/eli_maj_pilot_a)
	(vehicle_load_magic e50_b_wra_1 "driver" (ai_actors e50_a/eli_maj_pilot_a))
	
	(ai_vehicle_encounter e50_b_ban_2 e50_b/eli_maj_pilot_b)
	(vehicle_load_magic e50_b_ban_2 "driver" (ai_actors e50_b/eli_maj_pilot_b))

	(ai_vehicle_encounter e50_b_ban_3 e50_b/eli_maj_pilot_c)
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (vehicle_load_magic e50_b_ban_3 "driver" (ai_actors e50_b/eli_maj_pilot_c)))
	
	(unit_set_enterable_by_player e50_b_ban_2 0)
	(unit_set_enterable_by_player e50_b_ban_3 0)	

	(wake ban_spawn_2)
	
	(wake speech_check)
	(sleep 1)
	(wake banshee_save2)
	(sleep 1)
	(wake banshee_music)
	(sleep 1)
	(wake e51_a)
)

(script dormant e48_a
	(sleep_until (volume_test_objects e48_a_trigger (players)) 15)
	
	;Debug
	(if debug (print "e48_a active"))
	
	;Place units/wake/etc...

	(sleep 1)

	(ai_place e48_a)

	(object_create e48_warthog)
		
	(wake e50_a)
)

;Big first encounter on B(1) coming into canyon B 
(script dormant e46_a
	(sleep_until (volume_test_objects e46_a_trigger (players)))
	
	;Debug
	(if debug (print "e46_canyonb active"))
	;Place units/wake/etc..
	(ai_place e46_a)
	(ai_place e46_b)

	(object_create c2_wra_a)
	(object_create c2_gho_a)
	(object_create c2_gho_b)
	(object_create c2_ghost_c)
	(object_create c2_ban_a)
	(object_create c2_tur_a)
	(object_create c2_tur_b)

	(object_create_containing object_b)

	(sleep 10) 

	(ai_vehicle_enterable_distance c2_tur_a 7)	
	(ai_vehicle_enterable_distance c2_tur_b 7)
	
	(ai_vehicle_enterable_actor_type c2_tur_a grunt)
	(ai_vehicle_enterable_actor_type c2_tur_b grunt)

	(ai_vehicle_encounter c2_wra_a e46_a/eli_maj_pilot_a)
	(vehicle_load_magic c2_wra_a "driver" (ai_actors e46_a/eli_maj_pilot_a))

	(ai_vehicle_encounter c2_gho_b e46_a/eli_maj_pilot_b)
	(vehicle_load_magic c2_gho_b "driver" (ai_actors e46_a/eli_maj_pilot_b))

	(ai_vehicle_encounter c2_ban_a e46_b/eli_maj_pilot_a)
	(vehicle_load_magic c2_ban_a "driver" (ai_actors e46_b/eli_maj_pilot_a))

	(unit_set_enterable_by_player c2_ban_a 0)

;	(ai_vehicle_encounter c2_ban_b e46_b/eli_maj_pilot_b)
;	(vehicle_load_magic c2_ban_b "driver" (ai_actors e46_b/eli_maj_pilot_b))

	(sleep 150)
;	(ai_place e46_c
		
	(wake e48_a)

;	CLEANUP
	(object_destroy e40_a_ban_1)
	(object_destroy e40_a_ban_2)


	(ai_erase e43_c)
	(ai_erase e43_b)
	(ai_erase e43_a)
	(ai_erase e40_a)
	(ai_erase e41_a)
	(ai_erase e41_b)
	(ai_erase e41_c)
	(ai_erase e39_a)
	(ai_erase e38_a)
	(ai_erase e37_a)
	(ai_erase e34_a)
	(ai_erase e35_a)
	(ai_erase e33_b)
	(ai_erase e33_a)
	(ai_erase e31_d)
	(ai_erase e31_c)
	(ai_erase e31_b)
	(ai_erase e30_a)
	(ai_erase e31_a)
	(ai_erase e23_b)
	(ai_erase e22_a)
	(ai_erase e23_a)
	(ai_erase e21_b)
	(ai_erase e21_a)
	(ai_erase e20_a)
	
)

;Cortana
(script dormant e46_speech
	(sleep_until (volume_test_objects e46_speech_trigger (players)))
	(if debug (print "Speaking!"))
	(set play_music_c40_08 false)	
	(set play_music_c40_08_alt false)	

	(sound_impulse_start sound\dialog\c40\c40_200_Cortana none 1)	
	(waypoint4)
	(wake objective_3)
	(ai_place e46_C)
	;Debug
)	

;Bottom of BSP B3(8) 
(script dormant e44_a
	(sleep_until (volume_test_objects e44_a_trigger (players)))
	
	;Debug
	(if debug (print "e44_a active"))
	
	;Place units/wake/etc...
	(set play_music_c40_08_alt true)
	
	(ai_place e44_a)
	(sleep 1)
	(ai_magically_see_players e44_a/ambush)
	(wake e46_speech)
	(wake e46_a)
)

;BSP B3(8) In Elevator Shaft
(script dormant e43_c
	(sleep_until (volume_test_objects e43_c_trigger (players)))
	
	;Debug
	(if debug (print "e43_c_triggered"))
	
	;Place units
	(set play_music_c40_08 true)	

	(ai_place e43_c)
	(sleep 3)
	(ai_magically_see_players e43_c)

	(wake e44_a)
)

;BSP B3(8) Flood they are everywhere man!
(script dormant e43_b
	(sleep_until (volume_test_objects e43_b_trigger (players)))
	
	;Debug
	(if debug (print "e43_b active"))
	
	;Place units
	(effect_new "effects\explosions\medium explosion" glass_b_flag)
	(sleep 2)
	(ai_place e43_b)
	(sleep 2)
	(ai_magically_see_players e43_b/flo_inf)
	(wake e43_c)
)

;BSP B3(8) Top level triggers flavor chomp 
(script dormant e43_a
	(sleep_until (volume_test_objects e43_a_trigger (players)))
	(set play_music_c40_07 false)
	(set play_music_c40_07_alt false)
	
	;Debug
	(if debug (print "e43_a active"))
	
	;Place units/wake/etc..
	(ai_place e43_a)
	(wake e43_b)
)

;Banshee alt music
(script dormant banshee_alt
	(sleep 150)
	(sleep_until (volume_test_objects music_c40_07_alt_trigger (players)))
;	(sleep_until (= (ai_living_count c3_cov_base/eli_maj_pla_pilot_a) 0))
	(set play_music_c40_07_alt true)
)

;Second bridge of the Double B heading towards BSP(8)
(script dormant e40_a
	(sleep_until (volume_test_objects e40_a_trigger (players)))
	
	;Debug
	(if debug (print "e40_a active"))
	
	;Place the units and give them sight
	(wake banshee_alt)
	(set play_music_c40_07 true)
	
	(device_set_power door_b2 1)
	(device_set_power door_b3 1)
	
	(ai_place e40_a/pilot_a)
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (ai_place e40_a/pilot_b))
	(sleep 1)
	(object_create e40_a_ban_1)
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (object_create e40_a_ban_2))

	(sleep 1)
	
;	(ai_vehicle_encounter e40_a_ban_1 e40_a/pilots)
;	(ai_vehicle_encounter e40_a_ban_2 e40_a/pilots)
	
	(vehicle_load_magic e40_a_ban_1 "driver" (ai_actors e40_a/pilot_a))
	(if (or (= (game_difficulty_get) hard) (= (game_difficulty_get) impossible) (game_is_cooperative)) (vehicle_load_magic e40_a_ban_2 "driver" (ai_actors e40_a/pilot_b)))

	(unit_set_enterable_by_player e40_a_ban_1 0)
	(unit_set_enterable_by_player e40_a_ban_2 0)
	
	(ai_place e41_a)
	
	(sleep 2)
	(ai_magically_see_encounter e40_a e41_a)
	
;Place flavor encounter
	(sleep_until (volume_test_objects e41_jump_1_trigger (players)))
	(ai_place e41_b)

;place flavor encounter	
	(sleep_until (volume_test_objects e41_c_trigger (players)))
	
	(ai_place e41_c)
	(sleep 5)
	(ai_magically_see_players e41_c)
	
	(wake e43_a)
)

;flood flavor script
(script dormant e39_a
	(sleep_until (volume_test_objects e39_a_trigger (players)))
	
	;Debug
	(if debug (print "e39_a active"))
	
	;Place the units and give them sight
	(ai_place e39_a)
	(wake e40_a)
)

(script dormant e38_a
	(sleep_until (volume_test_objects e38_a_trigger (players)))
	
	;Debug
	(if debug (print "e38_a active"))
	
	;Place units, blah
	(ai_place e38_a)
	(effect_new "effects\explosions\medium explosion" glass_a_flag)
)	

(script dormant e37_a
	(sleep_until (volume_test_objects e37_a_trigger (players)))
	
	;Debug
	(if debug (print "e37_a active"))
	
	;Place the untis and give them sight
	(ai_place e37_a)
	(wake e38_a)
	(wake e39_a)
)

;Encounter 34, U Connector to 2nd Bridge
(script dormant e34_a
	(sleep_until (volume_test_objects e34_a_trigger (players)))
	
	;Debug
	(if debug (print "e34_a active"))
	
	;Place the units and give them sight
	(ai_place e34_a)
	(ai_place e35_a)
	(wake e37_a)
)

(script dormant e33_b
	(sleep_until (volume_test_objects e33_b_trigger (players)))
	
	;Debug 
	(if debug (print "look down"))
	
	;Place
	(ai_place e33_b)
	(sleep 5)
	(ai_magically_see_players e33_b)
)

(script dormant e33_a
	(sleep_until (volume_test_objects e33_a_trigger (players)))
	
	;Debug
	(if debug (print "e33_a active"))
	
	;Place the units and give them sight
	(ai_place e33_a)
	(wake e33_b)
	(wake e34_a)
)

(script dormant e31_d
	(sleep_until (volume_test_objects jump_3_trigger (players)))
	
	;Debug
	(if debug (print "jumpers #3 active"))

	;Place and blah
	(ai_place e31_d)
	(wake e33_a)
	
	(sleep 210)
	(set play_music_c40_06 false)
)

(script dormant e31_c
	(sleep_until (volume_test_objects jump_2_trigger (players)))
	
	;Debug
	(if debug (print "jumpers #2 active"))

	;Place and blah
	(ai_place e31_c)
	(wake e31_d)
)

(script dormant e31_b
	(sleep_until (volume_test_objects jump_1_trigger (players)))
	
	;Debug
	(if debug (print "jumpers #1 active"))

	;Place and blah
	(ai_place e31_b)
	(wake e31_c)
)

;Encounter 30, Double Bridge in B Major x 2
(script dormant e30_a
	(sleep_until (volume_test_objects e30_a_trigger (players)))
	(set play_music_c40_051 false)
	(sleep 1)	
	;Debug
	(if debug (print "E30_a active"))
	
	;Place the units and give them sight
	(ai_place e30_a)
	(ai_place e31_a)
	(wake e31_b)

	(device_set_power door_b2 0)
	(device_set_power door_b3 0)

	(sleep 60)
	(set play_music_c40_06 true)

;	CLEANUP
	(ai_erase e8_a)
	(ai_erase e7_a)
	(ai_erase e6_a)		
)

;Encounter 23_b; Here Flood, Flood, Flood...
(script dormant e23_b
	(sleep_until (<= (ai_living_count e23_a) 2))
	(ai_place e23_b)
	(if debug (print "Flood Attacking"))
	(sleep 90)
	(sleep_until (= (ai_living_count e23_b) 0))
	(set play_music_c40_051 false)
)

(script dormant force_save_2
	(sleep_until (= (ai_living_count e23_a) 0))
	(game_save_no_timeout)
)

;Encounter 22, Covenant vs. Flood
(script dormant e22_a
	(sleep_until (volume_test_objects e22_a_trigger (players)))
	
	;Debug
	(if debug (print "E22_a active"))
	
	;Place the units and give them sight
	(set play_music_c40_051 true)

	(ai_place e22_a)
	(ai_place e23_a)
	(object_create_containing object_a)

	(sleep 1)
	(wake force_save_2)
	(wake e30_a)
	(wake e23_b)
)

;Encounter 21_b, Grunt vs Grenade
(script dormant e21_b
	(sleep_until (volume_test_objects e21_b_trigger (players)))
	
	;Debug
	(if debug (print "E21_b active"))
	
	;Place/do/blah
	(ai_place e21_b)
	(wake e22_a)
)

;Encounter 21, Interior Connecting Tunnels B5
(script dormant e21_a
	(sleep_until (volume_test_objects e21_a_trigger (players)))
	
	;Debug
	(if debug (print "E21_a active"))
	
	;Place the units and give them sight
	(ai_place e21_a)
	(wake e21_b)
	
	;Deleting a bunch o stuff from C
	(object_destroy control_door_d)
	(object_destroy control_door_c)
	(object_destroy control_door_b)
	(object_destroy control_door_a)
	
	(object_destroy fly_away_1)
	(object_destroy fly_away_2)
	(object_destroy c3_wra_a)
	(object_destroy ban_plat1_a)
	(object_destroy ban_plat2_b)
	
	(object_destroy pulse_gen1)
)

;Encounter 20, Entrance to B5 from Canyon 3 (C)
(script dormant e20_a
	(sleep_until (volume_test_objects e20_a_trigger (players)))

	;Close Door to C Canyon for good
	(device_set_power door_c1 0)
	
	;Debug
	(if debug (print "E20_a active"))
	
	;Place the units and give them sight
	(ai_place e20_a)
	(wake e21_a)
)

(script dormant e8_b
	(sleep_until (volume_test_objects waypoint3_trigger (players)))
	;Debug
	(deactivate_team_nav_point_flag player waypoint3)
	(sound_impulse_start sound\dialog\c40\c40_190_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\c40\c40_190_Cortana))
	;Blah
	(wake e20_a)
)
	
;Encounter 8, Target Practice on the Bridge
(script dormant e8_a
	(sleep_until (volume_test_objects e8_trigger (players)))

	(set play_music_c40_05 false)
	;Debug
	(if debug (print "Targets on the Bridge"))

	;Place the units and give them sight
	(chapter_c40_2)
	
	(sound_impulse_start sound\dialog\c40\c40_180_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\c40\c40_180_Cortana))
	(waypoint_3)
	(ai_place e8_a)
	(wake e8_b)
)

;Encounter 7, Pulse Gen #1
(script dormant e7_c
	(sleep_until (volume_test_objects pulse_1_trigger (players)))
	(wake e8_a)

	;Debug
	(damage_object "effects\damage effects\pulsegenerator" (player0))
	(damage_object "effects\damage effects\pulsegenerator" (player1))


	(device_set_position_immediate pulse_gen1 0)
 	(sound_impulse_start sound\sfx\impulse\impacts\c40_generator_overload pulse_gen1 1)

	;Open door to B
	(device_set_power door_c1 1)

	(if debug (print "Cortana says, 'Good job, You've overloaded Generator #1'"))

	(sleep 120)
	(sound_impulse_start sound\dialog\c40\c40_170_Cortana none 1)
;		(sleep (sound_impulse_time sound\dialog\c40\c40_170_Cortana))
	;Place the units and give them sight

	(sleep 150)
	(wake objective_2)
	
	(object_create ban_plat1_a)
	(if (game_is_cooperative) (object_create ban_plat1_b))
	
)

(script dormant e7_b
	(sleep_until (volume_test_objects e7_trigger_b (players)))
	
	(set play_music_c40_05 true)

	;Debug
	(deactivate_team_nav_point_flag player waypoint2)
	
;	(if debug (print "Sentinels Active!"))
;	(ai_place e7_b)

	(sound_impulse_start sound\dialog\c40\c40_120_Cortana none 1)
		(sleep_until (volume_test_objects pulse_1_trigger (players)) 1 (sound_impulse_time sound\dialog\c40\c40_120_Cortana))
	(sound_impulse_stop sound\dialog\c40\c40_120_Cortana)
	(sound_impulse_start sound\dialog\c40\c40_150_Cortana none 1)
		(sleep_until (volume_test_objects pulse_1_trigger (players)) 1 (sound_impulse_time sound\dialog\c40\c40_150_Cortana))
	(sound_impulse_stop sound\dialog\c40\c40_150_Cortana)
	(sound_impulse_start sound\dialog\c40\c40_160_Cortana none 1)
		(sleep_until (volume_test_objects pulse_1_trigger (players)) 1 (sound_impulse_time sound\dialog\c40\c40_160_Cortana))
	(sound_impulse_stop sound\dialog\c40\c40_160_Cortana)
)

(script dormant e7_a
	(sleep_until (= (device_get_position pulse_gen1) 0))
	
	;Debug
	
	;Place the units and give them sight
	(sleep 90)
	(ai_place e7_a)
	(ai_follow_target_players e7_a)
	(ai_magically_see_players e7_a)
)

; Encounter 6, SENTINELS AT THE DOOR
(script dormant e6_a
	(sleep_until (volume_test_objects e6_trigger (players)))

	(object_create pulse_gen1)
	;Debug
;	(if debug (print "Cortana says, 'Good job SUPER CHUMP, Now find the Generator'"))

	;Place the units and give them sight
	(waypoint_2)
	(set play_music_c40_04 false)
	(ai_place e6_a)
	(ai_magically_see_players e6_a)
;	(wake e6_a_spawner)
	(wake e7_a)
	(sleep 1)
	(wake e7_b)
	(sleep 1)
	(wake e7_c)
)

(script dormant banshee1_save
	(sleep_until 
		(or	
			(vehicle_test_seat_list fly_away_1 b-driver (players))
			(vehicle_test_seat_list fly_away_2 b-driver (players))))
		
			(game_save_no_timeout)
)

(script dormant banshee_help
	(sleep_until (vehicle_test_seat_list fly_away_1 b-driver (players)))

	(set play_music_c40_04 true)
		
	(sound_impulse_start sound\dialog\c40\c40_110_Cortana none 1)
	
	(if (and (not (game_is_cooperative))
		    (= normal (game_difficulty_get)))
	    (if (player0_joystick_set_is_normal) (display_scenario_help 4) (display_scenario_help 5)))
)

(script dormant mortar_dead
	(sleep_until (= (ai_living_count c3_cov_base/eli_maj_pla_pilot_a) 0))
	(set play_music_c40_03 false)
)

; Encounter 5, LOWER CANYON FLOOR
(script dormant e5_a
	(sleep_until (volume_test_objects canyon3_land_trigger (players)))

	;Debug
	(if debug (print "Lower Canyon Encounter 5"))
	(if debug (print "Cortana says, 'Those flood bodies look like the remains of Major. '"))
	(if debug (print "Cortana says, 'Whacker. His team was heavy weapons squad, hopefully'"))
	(if debug (print "Cortana says, 'they had some rocket launchers'"))

	(ai_erase c3_base_tier_2/eli_maj_pla_top_tier)
	(ai_erase c3_base_tier_2/jac_maj_pla_top_tier)
	(ai_erase c3_base_tier_2/gru_maj_nee_top_tier)
	(ai_erase c3_base_tier_2/3_gru_maj_pla_c)	
	(ai_erase c3_base_tier_2/3_jac_maj_pla_c)
	(ai_erase c3_base_tier_2/3_eli_maj_pla_d)	
	(ai_erase c3_base_tier_2/3_jac_maj_pla_c)
				
	(sleep 10)
	
	(ai_migrate c3_base_tier_2/2_eli_maj_pla_g c3_cov_base/cleaners_i)
	(ai_migrate c3_base_tier_2/1_gru_maj_nee_i c3_cov_base/cleaners_i)
	(ai_migrate c3_base_tier_2/1_jac_maj_pla_j c3_cov_base/cleaners_i)
	(ai_migrate c3_base_tier_2/1_eli_maj_pla_k c3_cov_base/cleaners_i)
	(ai_migrate c3_base_tier_2/2_eli_maj_pla_g c3_cov_base/cleaners_i)
	(sleep 1)
	
	(ai_follow_target_players c3_cov_base/cleaners_i)
	(sleep 1)

	(ai_place c3_cov_base)
	
	(set play_music_c40_03 true)

	(vehicle_load_magic c3_wra_a "driver" (ai_actors c3_cov_base/eli_maj_pla_pilot_a))
	(ai_vehicle_encounter c3_wra_a c3_cov_base/eli_maj_pla_pilot_a)
; Replacement line	(ai_go_to_vehicle c3_cov_base/eli_maj_pla_pilot_a c3_wra_a driver)

;	(ai_erase c3_cov_landbridge)
	(wake mortar_dead)
	(sleep 1)	
	(wake banshee_help)
	(sleep 1)
	(wake banshee1_save)
	(sleep 1)
	(wake e6_a)

	(sleep_until (objects_can_see_object (players) fly_away_1 20))
	(ai_conversation cortana_block_3)
)

; Flavor Script, FIGHT AT LANDBRIDGE
;(script dormant e5_b
;	(sleep_until (volume_test_objects m1_cov_vs_flood (players)))
;	(if debug (print "Scripted fight on upper landbridge"))
;	(ai_place c3_cov_landbridge)
;	(wake e5_a_spawner)
;)

; Encounter 4, CANYON 3, BASE STRUCTURE
(script dormant c3_base_tier_2
	; sleep until the trigger
	(sleep_until (volume_test_objects canyon3_base_trigger (players)))
	;debug
	(if debug (print "Cortana says, 'A Pulse Generator is at the top of this canyon.'"))
	(if debug (print "Cortana says, 'Take that Covenant Banshee and get us up there!!'"))

;	Cortana speech
	(set play_music_c40_02 false)
	(ai_conversation cortana_block_2)

	(ai_place c3_base_tier_2)
	
	(ai_erase e2_c)
	(ai_erase e2_b)	
	(ai_erase e2_a)
	
	(wake e5_a)
		
	(waypoint_1)
	(wake objective_1)
	
	(if (game_is_cooperative) (object_create fly_away_2))	
)	
; Force Save
(script dormant force_save_1
	(sleep_until (= (ai_living_count e2_b) 0))
	(game_save_no_timeout)
)

; Encounter 3, OPEN THE DOOR AND TAKE IT BLAM!!!
(script dormant e3_a
	; Sleep until the trigger 
	(sleep_until (volume_test_objects e3_trigger (players)))
	;debug
	(if debug (print "Encounter e3_a"))
	(ai_place e3_a/jac_maj_pla_pis_a)
	(ai_place e3_a/eli_maj_pla_a)

	(sleep_until (= (device_get_position control_door_a_cont_b) 1))
	(ai_place e3_a/gru_maj_pla_a)
	
	(sleep 1)
	(wake force_save_1)
	(sleep 1)
	(wake c3_base_tier_2)
)	
(script dormant door_cover
	(sleep_until (= (device_get_position control_door_a_cont_b) 1) 1)
	(device_set_position control_door_a .8)
	(if debug (print "Door shouldn't open all the way!"))	
)

(script dormant door_green4
	(sleep_until (> (device_get_position control_door_a) 0) 5)
	(device_set_never_appears_locked control_door_a 1)
	(set play_music_c40_02 true)
)

(script dormant door_green3
	(sleep_until (> (device_get_position control_door_b) 0) 5)
	(device_set_never_appears_locked control_door_b 1)
	(ai_erase e1_a)		
)

; Encounter 2, Backup
(script dormant e2_c
	(sleep_until (<= (ai_living_count e2_b) 1))
	(if debug (print "Backup hatched"))
	(ai_place e2_c) 
	(ai_prefer_target (players) true)
)

(script dormant e2_b
	; Sleep until the trigger
	(sleep_until (> (device_get_position control_door_d_cont_b) 0) 5)
	(if debug (print "Door should open"))
	
	(device_set_position control_door_c 1)
	(device_set_never_appears_locked control_door_c 1)	
	(set play_music_c40_01 false)
	
	(if debug (print "Cortana says, 'The Covenant are trying to use Halo,'"))
	(if debug (print "we must not let them have the Key!'"))
	; Place the units and give them sight
	(ai_place e2_b)
	(sleep 1)
	(ai_prefer_target (players) true)
	(wake e2_c)
	(sleep 1)
	(wake door_green3)
	(sleep 1)
	(wake door_green4)
	(sleep 1)
	(wake door_cover)
	(sleep 1)
	(wake e3_a)
)

(script dormant e2_a
	; Sleep until the trigger
	(sleep_until (volume_test_objects e2_trigger_ambush (ai_actors e2_b/gru_maj_nee_o)))
	(ai_prefer_target (ai_actors e2_b) true)
	; Debug
	(if debug (print "Encounter 2...Sentinels Active"))
	; Place the units and give them sight
	;(ai_place e2_a)
)

;Cortana
(script dormant c40_20_30_40
	(sleep_until (= (ai_living_count e1_a) 0))
	(chapter_c40_1)
	(ai_conversation cortana_block_1)
)
	
; Encounter 1, WILD ON SENTINELS!!!
(script dormant e1_a
	; Sleep until player enters trigger volume
;	(sleep_until (volume_test_objects e1_trigger (players)))
	; Debug
	(if debug (print "Cortana says 'LOOK OUT !!!'"))

	(device_set_power door_c1 0)

	(sound_impulse_start sound\dialog\c40\c40_010_Cortana none 1)
;		(sleep (sound_impulse_time sound\dialog\c40\c40_010_Cortana))

	; Place the units and give them sight
	(ai_place e1_a)
	(ai_follow_target_players e1_a)
	(ai_magically_see_players e1_a)
	
;	(if (>= (ai_living_count c3_base_tier_2) 6) (set e4_fled true)) 
	
	; begin next encounter sequence
	(wake c40_20_30_40)
	(sleep 1)
	(wake e2_a)
	(sleep 1)
	(wake e2_b)
)

(script dormant door_green1
	(sleep_until (> (device_get_position control_door_d) 0) 5)
	(device_set_never_appears_locked control_door_d 1)
)
	
(script dormant kill_box_1
	(sleep_until (volume_test_objects kill_box_1 (players)))
	(damage_object "effects\damage effects\guaranteed plummet to untimely death" (player0))
	(damage_object "effects\damage effects\guaranteed plummet to untimely death" (player0))
)

; Section 1, Begin
(script dormant section1 
	; Debug
	(if debug (print "Section 1..."))
	(wake kill_box_1)
	(wake door_green1)
	(wake e1_a)
)

; ???? =========================================================================

;= CHEATS ======================================================================

(script static void s1
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume s1)
)

(script static void s2
	(switch_bsp 2)
	(wake e3_a)
	(volume_teleport_players_not_inside null_volume s2)
)

(script static void s3
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume s3)
	(wake banshee_help)
	(wake e6_a) 
)

(script static void s4
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume s4)
)

(script static void s5
	(switch_bsp 2)
	(volume_teleport_players_not_inside null_volume s5)
	(wake e8_a)
	(ai_erase e8_a)
	(wake e8_b)
)	

(script static void s5a
	(switch_bsp 10)
	(volume_teleport_players_not_inside null_volume s5a)
	(wake e30_a)
)	

(script static void s6
	(switch_bsp 9)
	(volume_teleport_players_not_inside null_volume s6)
	(wake e33_a)
)	

(script static void s7
	(switch_bsp 9)
	(volume_teleport_players_not_inside null_volume s7)
	(wake e34_a)
)	

(script static void s8
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s8)
	(wake e40_a)
)	

(script static void s8a
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s8a)
	(wake e46_speech)
	(wake e46_a)
)	

(script static void s8b
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s8b)
	(wake e48_a)
)	

(script static void s9
	(switch_bsp 1)
	(volume_teleport_players_not_inside null_volume s9)
	
	(wake e51_a)
	(object_create e50_a_ban_1)
)

(script static void s10
	(switch_bsp 0)
	(volume_teleport_players_not_inside null_volume s10)
	
	(wake e57_a)
	(wake e59_a)
	(wake e59_b)
)

(script static void s11
	(switch_bsp 0)
	(volume_teleport_players_not_inside null_volume s11)
	(wake e60_a)
)

;= MUSIC SCRIPTS ===============================================================
(script static void music_c40_01
	(sound_looping_start "levels\c40\music\c40_01" none 1)

	(sleep_until (or play_music_c40_01_alt
				  (not play_music_c40_01)) 1 global_delay_music)
	(if debug (print "MUSIC HAS BEEN CALLED"))
	(if play_music_c40_01_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_01" 1)
							   (sleep_until (not play_music_c40_01) 1 global_delay_music)
							   (set play_music_c40_01_alt false)
							   ))
	(set play_music_c40_01 false)
	(sound_looping_stop "levels\c40\music\c40_01")
)

(script static void music_c40_02
	(sound_looping_start "levels\c40\music\c40_02" none 1)

	(sleep_until (or play_music_c40_02_alt
				  (not play_music_c40_02)) 1 global_delay_music)
	(if play_music_c40_02_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_02" 1)
							   (sleep_until (not play_music_c40_02) 1 global_delay_music)
							   (set play_music_c40_02_alt false)
							   ))
	(set play_music_c40_03 false)
	(sound_looping_stop "levels\c40\music\c40_03")
	)

(script static void music_c40_03
	(sound_looping_start "levels\c40\music\c40_03" none 1)

	(sleep_until (or play_music_c40_03_alt
				  (not play_music_c40_03)) 1 global_delay_music)
	(if play_music_c40_03_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_03" 1)
							   (sleep_until (not play_music_c40_03) 1 global_delay_music)
							   (set play_music_c40_03_alt false)
							   ))
	(set play_music_c40_03 false)
	(sound_looping_stop "levels\c40\music\c40_03")
	)

(script static void music_c40_04
	(sound_looping_start "levels\c40\music\c40_04" none 1)

	(sleep_until (or play_music_c40_04_alt
				  (not play_music_c40_04)) 1 global_delay_music)
	(if play_music_c40_04_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_04" 1)
							   (sleep_until (not play_music_c40_04) 1 global_delay_music)
							   (set play_music_c40_04_alt false)
							   ))
	(set play_music_c40_04 false)
	(sound_looping_stop "levels\c40\music\c40_04")
	)

(script static void music_c40_05
	(sound_looping_start "levels\c40\music\c40_05" none 1)

	(sleep_until (or play_music_c40_05_alt
				  (not play_music_c40_05)) 1 global_delay_music)
	(if play_music_c40_05_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_05" 1)
							   (sleep_until (not play_music_c40_05) 1 global_delay_music)
							   (set play_music_c40_05_alt false)
							   ))
	(set play_music_c40_05 false)
	(sound_looping_stop "levels\c40\music\c40_05")
	)

(script static void music_c40_051
	(sound_looping_start "levels\c40\music\c40_051" none 1)

	(sleep_until (or play_music_c40_051_alt
				  (not play_music_c40_051)) 1 global_delay_music)
	(if play_music_c40_051_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_051" 1)
							   (sleep_until (not play_music_c40_051) 1 global_delay_music)
							   (set play_music_c40_051_alt false)
							   ))
	(set play_music_c40_051 false)
	(sound_looping_stop "levels\c40\music\c40_051")
	)


(script static void music_c40_06
	(sound_looping_start "levels\c40\music\c40_06" none 1)

	(sleep_until (or play_music_c40_06_alt
				  (not play_music_c40_06)) 1 global_delay_music)
	(if play_music_c40_06_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_06" 1)
							   (sleep_until (not play_music_c40_06) 1 global_delay_music)
							   (set play_music_c40_06_alt false)
							   ))
	(set play_music_c40_06 false)
	(sound_looping_stop "levels\c40\music\c40_06")
	)

(script static void music_c40_07
	(sleep_until (> (device_get_position door_b2) 0))
	(sound_looping_start "levels\c40\music\c40_07" none 1)

	(sleep_until (or play_music_c40_07_alt
				  (not play_music_c40_07)) 1 global_delay_music)
	(if play_music_c40_07_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_07" 1)
							   (sleep_until (not play_music_c40_07) 1 global_delay_music)
							   (set play_music_c40_07_alt false)
							   ))
	(set play_music_c40_07 false)
	(sound_looping_stop "levels\c40\music\c40_07")
	)

(script static void music_c40_08
	(sound_looping_start "levels\c40\music\c40_08" none 1)

	(sleep_until (or play_music_c40_08_alt
				  (not play_music_c40_08)) 1 global_delay_music)
	(if play_music_c40_08_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_08" 1)
							   (sleep_until (not play_music_c40_08) 1 global_delay_music)
							   (set play_music_c40_08_alt false)
							   ))
	(set play_music_c40_08 false)
	(sound_looping_stop "levels\c40\music\c40_08")
	)

(script static void music_c40_09
	(sound_looping_start "levels\c40\music\c40_09" none 1)

	(sleep_until (or play_music_c40_09_alt
				  (not play_music_c40_09)) 1 global_delay_music)
	(if play_music_c40_09_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_09" 1)
							   (sleep_until (not play_music_c40_09) 1 global_delay_music)
							   (set play_music_c40_09_alt false)
							   ))
	(set play_music_c40_09 false)
	(sound_looping_stop "levels\c40\music\c40_09")
	)

(script static void music_c40_10
	(sound_looping_start "levels\c40\music\c40_10" none 1)

	(sleep_until (or play_music_c40_10_alt
				  (not play_music_c40_10)) 1 global_delay_music)
	(if play_music_c40_10_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_10" 1)
							   (sleep_until (not play_music_c40_10) 1 global_delay_music)
							   (set play_music_c40_10_alt false)
							   ))
	(set play_music_c40_10 false)
	(sound_looping_stop "levels\c40\music\c40_10")
	)

(script static void music_c40_101
	(sound_looping_start "levels\c40\music\c40_101" none 1)

;	(sleep_until (or play_music_c40_101_alt
;				  (not play_music_c40_101)) 1 global_delay_music)
;	(if play_music_c40_101_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_101" 1)
;							   (sleep_until (not play_music_c40_101) 1 global_delay_music)
;							   (set play_music_c40_101_alt false)
;							   ))
;	(set play_music_c40_101 false)
;	(sound_looping_stop "levels\c40\music\c40_101")

	(sleep (* 30 108))
	(sound_looping_start "levels\c40\music\c40_102" none 1)
	)


(script static void music_c40_11
	(sound_looping_start "levels\c40\music\c40_11" none 1)

	(sleep_until (or play_music_c40_11_alt
				  (not play_music_c40_11)) 1 global_delay_music)
	(if play_music_c40_11_alt (begin (sound_looping_set_alternate "levels\c40\music\c40_11" 1)
							   (sleep_until (not play_music_c40_11) 1 global_delay_music)
							   (set play_music_c40_11_alt false)
							   ))
	(set play_music_c40_11 false)
	(sound_looping_stop "levels\c40\music\c40_11")
)

(script dormant music_c40

	(sleep_until play_music_c40_01 1)
	(music_c40_01)
	
	(sleep_until play_music_c40_02 1)
	(music_c40_02)
	
	(sleep_until play_music_c40_03 1)
	(music_c40_03)
	
	(sleep_until play_music_c40_04 1)
	(music_c40_04)
	
	(sleep_until play_music_c40_05 1)
	(music_c40_05)

	(sleep_until play_music_c40_051 1)
	(music_c40_051)

	(sleep_until play_music_c40_06 1)
	(music_c40_06)

	(sleep_until play_music_c40_07 1)
	(music_c40_07)

	(sleep_until play_music_c40_08 1)
	(music_c40_08)

	(sleep_until play_music_c40_09 1)
	(music_c40_09)

	(sleep_until play_music_c40_10 1)
	(music_c40_10)

	(sleep_until play_music_c40_101 1)
	(music_c40_101)

	(sleep_until play_music_c40_11 1)
	(music_c40_11)
)

;= MAIN SCRIPT =================================================================
(script startup mission_c40
;	(switch_bsp 2)
;	(volume_teleport_players_not_inside null_volume s0)
	(fade_out 0 0 0 0)
	(kill_all_cont)
	
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_insertion))
	(cinematic_skip_stop)
	
	(switch_bsp 2)
	(set play_music_c40_01 true)
	(wake save_checkpoints)
	(wake section1)
	(wake music_c40)
	(fade_in 0 0 0 0)
   
   (mcc_mission_segment "01_start")
)	
