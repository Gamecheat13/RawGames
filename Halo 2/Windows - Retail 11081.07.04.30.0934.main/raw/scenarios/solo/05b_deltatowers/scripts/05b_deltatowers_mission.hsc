;05b_DELTATOWERS!
;-------------------------------------------------------------------------------

(script stub void c05_intra1
	(print "hi, joe")
)
(script stub void c05_intra2
	(print "hi, joe")
)
(script stub void c05_outro
	(print "hi, joe")
)


;-------------------------------------------------------------------------------
;Global Scripts

;Global pausing script to fake sleeping and other stationary behaviors
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(sleep_forever)
)
(script command_script forever_pause
	(cs_pause -1)
)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)


;-------------------------------------------------------------------------------
;Chapter Titles

;"Testament"
(script dormant 05b_title0
	(cinematic_fade_from_white_bars)
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"One-Way Ticket"
(script dormant 05b_title1
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"One-Way Ticket"
(script dormant 05b_title1_alt
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_2alt)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"Sorry, Were You in the Middle of Something?"
(script dormant 05b_title2
	(cinematic_fade_from_white_bars)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)


;-------------------------------------------------------------------------------
;Objectives

(script dormant objective_towers_set
            (sleep 30)
            (print "new objective set:")
            (print "Make your way through the first set of towers.")
            (objectives_show_up_to 0)
)
(script dormant objective_towers_clear
            (print "objective complete:")
            (print "Make your way through the first set of towers.")
            (objectives_finish_up_to 0)
)

(script dormant objective_gondola1_set
            (sleep 30)
            (print "new objective set:")
            (print "Ride the gondola to the far towers.")
            (objectives_show_up_to 1)
)
(script dormant objective_gondola1_clear
            (print "objective complete:")
            (print "Ride the gondola to the far towers.")
            (objectives_finish_up_to 1)
)

(script dormant objective_sunken_set
            (sleep 30)
            (print "new objective set:")
            (print "Pass through the submerged structures.")
            (objectives_show_up_to 2)
)
(script dormant objective_sunken_clear
            (print "objective complete:")
            (print "Pass through the submerged structures.")
            (objectives_finish_up_to 2)
)

(script dormant objective_temple_set
            (sleep 30)
            (print "new objective set:")
            (print "Reach the main temple.")
            (objectives_show_up_to 3)
)
(script dormant objective_temple_clear
            (print "objective complete:")
            (print "Reach the main temple.")
            (objectives_finish_up_to 3)
)

(script dormant objective_regret_set
            (sleep 30)
            (print "new objective set:")
            (print "Kill the Prophet of Regret, and escape.")
            (objectives_show_up_to 4)
)
(script dormant objective_regret_clear
            (print "objective complete:")
            (print "Kill the Prophet of Regret, and escape.")
            (objectives_finish_up_to 4)
)


;-------------------------------------------------------------------------------
;Music

(script dormant music_05b_01_start
	;at end of 1st room encounter, or when you leave the room
	(print "music 05b_01 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_01" none 1.0)
)

(script dormant music_05b_01_stop
	;when you get to the room in tower 2
	(print "music 05b_01 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_01")
)

(script dormant music_05b_02_start
	;when you kill the last hunter on the central platform
	(print "music 05b_02 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_02" none 1.0)
)

(script dormant music_05b_02_stop
	;when you push the button to activate the gondola
	(print "music 05b_02 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_02")
)

(script dormant music_05b_03_start
	;when the gondola docks
	(print "music 05b_03 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_03" none 1.0)
)

(script dormant music_05b_03_stop
	;when you push the button to activate the gondola
	(print "music 05b_03 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_03")
)

(script dormant music_05b_04_start
	;when gondola starts moving again after mid-encounter
	(print "music 05b_04 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_04" none 1.0)
)

(script dormant music_05b_04_stop
	;after docking is completed
	(print "music 05b_04 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_04")
)

(script dormant music_05b_05_start
	;when submarine hits the water
	(print "music 05b_05 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_05" none 1.0)
)

(script dormant music_05b_06_start
	;when you reach the 1st sunken tunnel
	(print "music 05b_06 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_06" none 1.0)
)

(script dormant music_05b_06_stop
	;when you enter the sunken chamber
	(print "music 05b_06 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_06")
)

(script dormant music_05b_07_start
	;when you reach the 2nd sunken tunnel
	(print "music 05b_07 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_07" none 1.0)
)

(script dormant music_05b_08_start
	;when the elevator hits the water
	(print "music 05b_08 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_08" none 1.0)
)

(script dormant music_05b_09_start
	;after miranda says "I'll keep you posted"
	(print "music 05b_09 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_09" none 1.0)
)

;9/11
(script dormant music_05b_09_start_alt
	;once gondola 2 resumes moving
	(print "music 05b_09 start alt")
	(sound_looping_set_alternate "scenarios\solo\05b_deltatowers\05b_music\05b_09" true)
)

(script dormant music_05b_09_stop
	;at start of temple cinematic
	(print "music 05b_09 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_09")
)

(script dormant music_05b_10_start
	;after prophet of regret is dead
	(print "music 05b_10 start")
	(sound_looping_start "scenarios\solo\05b_deltatowers\05b_music\05b_10" none 1.0)
)

(script dormant music_05b_10_stop
	;at start of cinematic
	(print "music 05b_10 stop")
	(sound_looping_stop "scenarios\solo\05b_deltatowers\05b_music\05b_10")
)


;-------------------------------------------------------------------------------
;Kill Volumes

;so much simpler
(script dormant kill_volumes
	(kill_volume_disable kill_no_riders_up)
	(kill_volume_disable kill_bsp03)
	(kill_volume_disable kill_temple_wings)
	(sleep_until (= (structure_bsp_index) 2))
	(kill_volume_enable kill_bsp03)
	(kill_volume_enable kill_temple_wings)
	(kill_volume_disable kill_bsp01_01)
	(kill_volume_disable kill_bsp01_02)
)


;-------------------------------------------------------------------------------
;Initializing start of mission

(global boolean tower1_holo_trans FALSE)
(global boolean tower1_holo_chant TRUE)
(script dormant tower1_holo_looper
	(sleep_until
		(begin
			(begin_random
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret01 3000))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret01 3001))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret01 3002))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret01 3003))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret01 3004))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret01 3005))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
				(if (= tower1_holo_trans FALSE)
					(begin
						(set tower1_holo_chant TRUE)
						(custom_animation regret01 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret01 3006))
						(sleep (random_range 240 480))
						(set tower1_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

;Setting up everything before we fade in from white
(script static void prep_return_from_intro
	(object_create_anew in_game_throne)
	(object_create_anew regret01)
	(objects_attach in_game_throne "driver" regret01 "")
	(ai_disregard regret01 TRUE)
	(ai_place initial_allies 2)
	;(scenery_animation_start_loop in_game_prophet objects\characters\prophet\prophet "throne_d:any:idle")
	(object_teleport (player0) tower1_player0)
	(object_teleport (player1) tower1_player1)
)


;-------------------------------------------------------------------------------
;Tower 1 Interior

;Cortana pondering archaeology
(script dormant tower1_cortana_comment
;	(sleep_until (= (ai_trigger_test "done_fighting" tower1_enemies) FALSE))
;	(sleep_until 
;		(OR 
;			(= (ai_trigger_test "done_fighting" tower1_enemies) TRUE)
;			(= (volume_test_objects vol_tower1_exit (players)) TRUE)
;			(= (volume_test_objects vol_tower1_exit_01 (players)) TRUE)
;			(= (volume_test_objects vol_tower1_exit_02 (players)) TRUE)
;		)
;	)
	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower1_exit (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_01 (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_02 (players)) TRUE)
		)
	30 300)
	(ai_dialogue_enable FALSE)
	(sleep 60)	
	(if 
		(AND
			(= (volume_test_objects vol_tower1_exit (players)) FALSE)
			(= (volume_test_objects vol_tower1_exit_01 (players)) FALSE)
			(= (volume_test_objects vol_tower1_exit_02 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(print "CORTANA: 'You know, I think the Forerunners built these new structures...'")
				(print "'...around the old - to protect them, honor them...'")
				(sleep (ai_play_line_on_object NONE 0810))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0810_cor))
				(sleep 30)
				(print "'Pure speculation, mind you. I'd need to make a thorough survey to be sure.'")
				(sleep (ai_play_line_on_object NONE 0820))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0820_cor))
			)
	)
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Overall script for tower 1
(script dormant tower1_start
	(data_mine_set_mission_segment "05b_1_tower1")
	(game_save_immediate)

	(sleep 90)
	(ai_place tower1_buggers_01 4)
	(sleep 90)
	(if (difficulty_legendary)
		(ai_place tower1_elites_01 2)
		(ai_place tower1_elites_01 1)
	)
	
;9/11
	(wake tower1_holo_looper)	
	
	(sleep_until 
		(OR
			(< (ai_living_count tower1_enemies) 3)
			(= (volume_test_objects vol_tower1_upper (players)) TRUE)
			(= (volume_test_objects vol_tower1_upper_right (players)) TRUE)		
		)
	)
	(ai_place tower1_buggers_02 (- 4 (ai_living_count tower1_buggers_01)))

	(sleep_until 
		(OR
			(< (ai_living_count tower1_enemies) 2)
			(= (volume_test_objects vol_tower1_upper_right (players)) TRUE)		
		)
	)
	(if (difficulty_legendary)
		(ai_place tower1_elites_02 (- 2 (ai_living_count tower1_elites_01)))
		(ai_place tower1_elites_02 (- 1 (ai_living_count tower1_elites_01)))
	)
		
	(sleep_until 
		(OR
			(< (ai_living_count tower1_enemies) 1)
			(= (volume_test_objects vol_tower1_exit (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_01 (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_02 (players)) TRUE)
			(= (volume_test_objects vol_tower1_roof (players)) TRUE)
		)
	)
	(game_save)
	(wake tower1_cortana_comment)
	(sleep 60)
	(wake music_05b_01_start)
)


;-------------------------------------------------------------------------------
;Bridges

(script command_script tower1_escape
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest bridges)
)

;Cortana reminding you about where to go
(script dormant cortana_bridge_reminder
	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower2_ext_entry (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_tower2_ext_entry (players)) FALSE)
			(= (volume_test_objects vol_central_platform (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'There's some sort of transport-system on the far side...'")
				(print "'...of that center platform. Let's check it out.'")
				(sleep (ai_play_line_on_object NONE 0860))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0860_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Total snipers placed on bridges and central platform
(global short bridges_sniper_count 3)

;Overall script for bridges
(script dormant bridges_start
	(ai_disposable tower1_enemies TRUE)
	(data_mine_set_mission_segment "05b_2_bridges")
	(ai_renew all_allies)
	(game_save)
	
	(if (difficulty_heroic)
		(set bridges_sniper_count 4)
	)
	(if (difficulty_legendary)
		(set bridges_sniper_count 5)
	)
	
	(begin_random
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_01 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_02 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_03 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_04 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_05 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
		(if (> bridges_sniper_count 0)
			(begin
				(ai_place bridge_jackals_06 1)
				(set bridges_sniper_count (- bridges_sniper_count 1))
			)
		)
	)
	
	(ai_place bridge_elites_01 1)
	(ai_place bridge_elites_02 1)
	(ai_place bridge_grunts_01 2)
	
	(ai_set_orders all_allies tower1_ext_allies)
	(cs_run_command_script all_allies tower1_escape)
	(wake cortana_bridge_reminder)
	
	(sleep_until 
		(OR
			(< (ai_living_count bridge_enemies) 5)
			(= (volume_test_objects vol_bridge (players)) TRUE)		
			(= (volume_test_objects vol_tower2_ext_entry (players)) TRUE)		
		)
	)
	(game_save)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_grunts_02 (- 3 (ai_living_count bridge_grunts_01)))
	)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_elites_03 1)
	)
	
	(sleep_until 
		(OR
			(< (ai_living_count bridge_enemies) 5)
			(= (volume_test_objects vol_tower2_ext_entry (players)) TRUE)		
			(= (volume_test_objects vol_bridge_far_half (players)) TRUE)		
		)
	)	
	(game_save)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_grunts_03 (- 2 (ai_living_count bridge_grunts_02)))
	)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_jackals_07 1)
	)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_bridge (players)) TRUE)
			(= (volume_test_objects vol_tower2_ext_entry (players)) TRUE)
		)
	)		
	(ai_set_orders all_allies bridge_allies)
	
	(sleep_until 
		(OR
			(< (ai_living_count bridge_enemies) 5)
			(= (volume_test_objects vol_tower2_ext_entry (players)) TRUE)		
		)
	)
	(game_save)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_grunts_04 (- 2 (ai_living_count bridge_grunts_03)))
	)
	(if (< (ai_living_count bridge_enemies) 8)
		(ai_place bridge_elites_04 1)
	)
	
	(sleep_until (= (volume_test_objects vol_tower2_ext_entry (players)) TRUE))		
	(game_save)
	(ai_set_orders all_allies tower2_ext_allies_01)
)


;-------------------------------------------------------------------------------
;Tower 2 Interior

;Cortana playing archaeologist again
(script dormant tower2_cortana_comment
;	(sleep_until (= (ai_trigger_test "done_fighting" tower2_enemies) FALSE))
;	(sleep_until 
;		(OR 
;			(= (ai_trigger_test "done_fighting" tower2_enemies) TRUE)
;			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
;			(= (volume_test_objects vol_tower2_ext_exit (players)) TRUE)
;		)
;	)
	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
			(= (volume_test_objects vol_tower2_ext_exit (players)) TRUE)
			(= (volume_test_objects vol_tower2_exit_mid (players)) TRUE)
		)
	30 300)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(if 
		(AND
			(= (volume_test_objects vol_tower2_exit (players)) FALSE)
			(= (volume_test_objects vol_tower2_ext_exit (players)) FALSE)
			(= (volume_test_objects vol_tower2_exit_mid (players)) TRUE)
			(> (player_count) 0)
		)
			(begin
				(print "CORTANA: 'I wish I had time to decipher these inscriptions.'")
				(sleep (ai_play_line_on_object NONE 0870))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0870_cor))
				(sleep 60)
				(print "'The Forerunners revered this place - that much is clear.'")
				(sleep (ai_play_line_on_object NONE 0880))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0880_cor))
				(sleep 60)
				(print "'But was it a temple? A university? I can't say...'")
				(sleep (ai_play_line_on_object NONE 0890))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0890_cor))
			)
	)
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Overall script for tower 2
(script dormant tower2_start
	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower2_entry (players)) TRUE)
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
		)
	)
	(ai_disposable bridge_enemies TRUE)
	(data_mine_set_mission_segment "05b_3_tower2")
	(ai_renew all_allies)
	(wake music_05b_01_stop)
	(game_save)
	
	(ai_place tower2_jackals_01 2)
	(ai_place tower2_grunts_01 2)
	(ai_place tower2_grunts_02 2)

	(sleep_until (= (volume_test_objects vol_in_tower2 (players)) TRUE))
	(ai_set_orders all_allies tower2_allies)
	
	(sleep_until 
		(OR
			(< (ai_living_count tower2_enemies) 3)
			(= (volume_test_objects vol_tower2_by_exit (players)) TRUE)		
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
		)
	)
	(game_save)
	(ai_place tower2_jackals_02 (- 2 (ai_living_count tower2_jackals_01)))
	
	(sleep_until 
		(OR
			(<= (ai_living_count tower2_enemies) 0)
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
		)
	)
	(game_save)
	(wake tower2_cortana_comment)
)


;-------------------------------------------------------------------------------
;Central Platform

;Miranda setting up expectation that there will still be some pelicans
(global boolean miranda_pel_comment_done FALSE)
(script dormant miranda_pelican_comment
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "MIRANDA: 'Cortana? The Covenant's getting nosy.'")
	(print "'I don't want to give away my position,'")
	(print "'so I'm re-routing a few stragglers back to you.'")
	(sleep (ai_play_line_on_object NONE 0830))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0830_mir))
	(sleep 30)
	(print "'I apologize. These Pelicans are all the support you're going to get.'")
	(sleep (ai_play_line_on_object NONE 0840))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0840_mir))
	(sleep 60)
	(print "'Understood, Ma'am.'")
	(sleep (ai_play_line_on_object NONE 0850))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0850_cor))
	(set miranda_pel_comment_done TRUE)
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Cortana pointing out approaching gondola
(script dormant gondola_01_cortana_warn
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'A gondola's launching from the far towers!'")
	(print "'Big surprise: it's full of Covenant reinforcements!'")
	(sleep (ai_play_line_on_object NONE 0900))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0900_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Cortana indicating that the gondola is where to go
(script dormant gondola_01_cortana_comment
	(if 
		(AND
			(= (volume_test_objects vol_gondola_01 (players)) FALSE)
			(> (player_count) 0)
			(= (ai_trigger_test "done_fighting" central_platform_enemies) TRUE)
			(= (ai_trigger_test "done_fighting" gondola_01_enemies) TRUE)
		)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Well, they were nice enough to bring us a ride.'")
			(sleep (ai_play_line_on_object NONE 0910))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0910_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;Cortana reminding you to get on the damn gondola
(script dormant gondola_01_cortana_reminder
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'This gondola won't bring us all the way to the main-temple,'")
	(print "'but it'll get us close. Let's get on-board.'")
	(sleep (ai_play_line_on_object NONE 0950))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0950_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Allies boarding the gondola
(script command_script gondola_01_ally_comment
	(cs_switch ally01)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(print "ALLY_01: 'All aboard!'")
	(cs_play_line 0920)

	(cs_switch ally02)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(sleep 5)
	(print "ALLY_02: 'I'll drive!'")
	(cs_play_line 0930)

	(cs_switch ally01)
	(sleep 15)
	(print "ALLY_01: 'What's to drive? It comes here. It goes there.'")
	(cs_play_line 0940)
)

(script dormant hunter_drop
	(object_set_phantom_power (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) TRUE)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) "phantom_p_a01")
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) "phantom_p_a02")
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) FALSE)
	(ai_set_blind central_platform_hunters FALSE)
)

;Flies the phantom in to drop off the hunters
(script command_script central_platform_dropship
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bsp1_airspace/ph_01_0 10)
	(cs_fly_by bsp1_airspace/ph_01_1 10)
	(cs_vehicle_boost FALSE)
;	(cs_vehicle_speed .75)
	(cs_fly_by bsp1_airspace/ph_01_2 5)
	(cs_vehicle_speed .5)

	(wake hunter_drop)

	(cs_fly_to bsp1_airspace/ph_01_2 1)
	(sleep_until (< (ai_living_count central_platform_phantom) 2))
	(sleep 60)
	
	(cs_fly_to_and_face bsp1_airspace/ph_01_3 bsp1_airspace/ph_01_1 1)
	(cs_vehicle_speed 1)
	(cs_fly_by bsp1_airspace/ph_01_1 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bsp1_airspace/ph_01_0 20)
	(cs_fly_by bsp1_airspace/ph_01_x 40)
	(ai_erase central_platform_phantom)
)

(global boolean central_plat_pel_arrives FALSE)

;Pelican arrives after hunters are dead to drop new allies
(script command_script central_platform_pelican_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by bsp1_airspace/p0 2)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bsp1_airspace/pel0 20)
	(cs_fly_by bsp1_airspace/pel1 20)
	;(cs_fly_by bsp1_airspace/pel2 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by bsp1_airspace/pel3 10)
	(cs_vehicle_speed .5)
	(cs_fly_by bsp1_airspace/pel4 5)
	(set central_plat_pel_arrives TRUE)
	(cs_vehicle_speed .3)
	(cs_fly_to bsp1_airspace/pel4 1)
	(ai_place central_plat_pelican_allies (- 2 (ai_living_count allies_infantry)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) "pelican_p" (ai_actors central_plat_pelican_allies))
	(cs_fly_to bsp1_airspace/pel5 1)
	(vehicle_unload (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) "pelican_p")

	(sleep_until (< (ai_living_count central_plat_pelican) 4))
	(sleep 60)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face bsp1_airspace/pel4 bsp1_airspace/pel3 1)
	(cs_fly_by bsp1_airspace/pel3 2)
	(cs_vehicle_speed 1)
	(cs_fly_by bsp1_airspace/pel2 2)
	(cs_vehicle_boost TRUE)
	(cs_fly_by bsp1_airspace/pel2 20)
	(cs_fly_by bsp1_airspace/pel1 20)
	(cs_fly_by bsp1_airspace/pel0 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by bsp1_airspace/pelx 5)
	(ai_erase central_plat_pelican)
)

;Loads and launches the pelican
(script dormant central_platform_pelican
	(ai_place central_plat_pelican 1)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) TRUE)
	(cs_run_command_script central_plat_pelican/pilot central_platform_pelican_path)

	(object_create_anew rack)
	(objects_attach (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) "pelican_sc_01" rack "pin")
	(object_create_anew bomb01)
	(objects_attach rack "rack01" bomb01 "pin")
	(object_create_anew bomb02)
	(objects_attach rack "rack02" bomb02 "pin")
	(object_create_anew bomb03)
	(objects_attach rack "rack03" bomb03 "pin")
	(object_create_anew bomb04)
	(objects_attach rack "rack04" bomb04 "pin")
	(object_create_anew bomb05)
	(objects_attach rack "rack05" bomb05 "pin")
	(object_create_anew bomb06)
	(objects_attach rack "rack06" bomb06 "pin")
	
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors initial_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors initial_allies) 0)) 10)
				)
					(object_destroy (list_get (ai_actors initial_allies) 0))
			)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors initial_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors initial_allies) 0)) 10)
				)
					(object_destroy (list_get (ai_actors initial_allies) 0))
			)
			(= central_plat_pel_arrives TRUE)
		)
	)
	
	(begin_random
		(begin
			(objects_detach rack bomb01)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb02)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb03)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb04)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb05)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb06)
			(sleep (random_range 10 30))
		)
	)
)
(script static void short_central_plat_pel
	(ai_place central_plat_pelican 1)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) TRUE)
	(cs_run_command_script central_plat_pelican/pilot central_platform_pelican_path)
	(object_create_anew rack)
	(objects_attach (ai_vehicle_get_from_starting_location central_plat_pelican/pilot) "pelican_sc_01" rack "pin")
	(object_create_anew bomb01)
	(objects_attach rack "rack01" bomb01 "pin")
	(object_create_anew bomb02)
	(objects_attach rack "rack02" bomb02 "pin")
	(object_create_anew bomb03)
	(objects_attach rack "rack03" bomb03 "pin")
	(object_create_anew bomb04)
	(objects_attach rack "rack04" bomb04 "pin")
	(object_create_anew bomb05)
	(objects_attach rack "rack05" bomb05 "pin")
	(object_create_anew bomb06)
	(objects_attach rack "rack06" bomb06 "pin")
	
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors initial_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors initial_allies) 0)) 10)
				)
					(object_destroy (list_get (ai_actors initial_allies) 0))
			)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors initial_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors initial_allies) 0)) 10)
				)
					(object_destroy (list_get (ai_actors initial_allies) 0))
			)
			(= central_plat_pel_arrives TRUE)
		)
	)
	
	(begin_random
		(begin
			(objects_detach rack bomb01)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb02)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb03)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb04)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb05)
			(sleep (random_range 10 30))
		)
		(begin
			(objects_detach rack bomb06)
			(sleep (random_range 10 30))
		)
	)
)

(script dormant central_plat_ph_go
	(ai_place central_platform_hunters 2)
	(ai_place central_platform_phantom 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) "phantom_p_a" (ai_actors central_platform_hunters))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) TRUE)
	(cs_run_command_script central_platform_phantom/pilot central_platform_dropship)

;9/12
	(sleep 4000)
	(object_destroy (ai_vehicle_get_from_starting_location central_platform_phantom/pilot))
)

(global real gondola_01_wake_state 0)
(script dormant gondola_01_wake
	(sleep_until
		(begin
			(if 
				(AND
					(> (device_get_position gondola_01_a) .37)
					(< (device_get_position gondola_01_a) .59)
					(> (device_get_position gondola_01_a) gondola_01_wake_state)
				)
					(begin
						(object_clear_function_variable gondola_01_a "wake_forward")
						(object_clear_function_variable gondola_01_a "wake_backward")
						(object_set_function_variable gondola_01_a "wake_backward" 1 1)
						(object_clear_function_variable gondola_01_b "wake_forward")
						(object_clear_function_variable gondola_01_b "wake_backward")
						(object_set_function_variable gondola_01_b "wake_backward" 1 1)
					)
			)
			(if 
				(AND
					(> (device_get_position gondola_01_a) .37)
					(< (device_get_position gondola_01_a) .59)
					(< (device_get_position gondola_01_a) gondola_01_wake_state)
				)
					(begin
						(object_clear_function_variable gondola_01_a "wake_forward")
						(object_clear_function_variable gondola_01_a "wake_backward")
						(object_set_function_variable gondola_01_a "wake_forward" 1 1)
						(object_clear_function_variable gondola_01_b "wake_forward")
						(object_clear_function_variable gondola_01_b "wake_backward")
						(object_set_function_variable gondola_01_b "wake_forward" 1 1)
					)
			)
			(if 
				(OR
					(= (device_get_position gondola_01_a) gondola_01_wake_state)
					(< (device_get_position gondola_01_a) .37)
					(> (device_get_position gondola_01_a) .59)
				)
					(begin
						(object_clear_function_variable gondola_01_a "wake_forward")
						(object_clear_function_variable gondola_01_a "wake_backward")
						(object_clear_function_variable gondola_01_b "wake_forward")
						(object_clear_function_variable gondola_01_b "wake_backward")
					)
			)
			(set gondola_01_wake_state (device_get_position gondola_01_a))
			(= (device_get_position gondola_01_a) 0)
		)
	)
)

;Overall script for central platform
(script dormant central_platform_start
	(ai_disposable tower2_enemies TRUE)
	(data_mine_set_mission_segment "05b_4_central_platform")
	(ai_renew all_allies)
	(game_save)
	
	(ai_place tower3_turrets 2)
	(objects_attach gondola_01_b control_back gondola_01_switch_front "")
	(objects_attach gondola_01_a control_back gondola_01_switch_back "")
	(device_set_position gondola_01_launch_a 1)
	(device_set_position gondola_01_launch_b 1)
	(device_set_position gondola_01_a .5)
	(device_set_position gondola_01_b .5)

	(ai_place central_platform_elites_01 1)
	(ai_place central_platform_elites_02 1)
	(ai_place central_platform_jackals_01 2)
	(ai_place central_platform_jackals_02 2)
	
	(ai_set_orders all_allies tower2_ext_allies_02)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_near_gondola_01 (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	30 150)
	(wake gondola_01_wake)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_near_gondola_01 (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	)
	(ai_set_orders all_allies central_platform_allies)

	(sleep_until (< (ai_living_count central_platform_enemies) 2) 30 4000)
	(sleep_until (= (ai_trigger_test "done_fighting" central_platform_enemies) TRUE))
	(game_save)

	(wake central_plat_ph_go)
	(sleep 450)
	(game_save)

	(sleep_until 
		(OR
			(> (ai_living_count central_platform_hunters) 0)
			(< (ai_living_count central_platform_phantom) 1)
		)
	)
	(sleep_until (< (ai_living_count central_platform_hunters) 1))
	(sleep 30)
	(wake music_05b_02_start)
	(sleep 60)
	(wake miranda_pelican_comment)
	(sleep_until (= miranda_pel_comment_done TRUE))
	(game_save)
	(wake central_platform_pelican)

	(ai_place gondola_01_elite_riders 2)
	(ai_place gondola_01_grunt_riders 3)
	(device_set_position gondola_01_a 1)
	(device_set_position gondola_01_b 1)
	
	(sleep_until (> (device_get_position gondola_01_a) .75))
	(wake gondola_01_cortana_warn)
		
	(sleep_until (= (device_get_position gondola_01_a) 1))

;9/11
	(object_dynamic_simulation_disable gondola_01_a TRUE)
	(object_dynamic_simulation_disable gondola_01_b TRUE)

	(device_set_position gondola_01_launch_a 0)
	(device_set_position gondola_01_launch_b 0)
	(device_group_change_only_once_more_set gondola_01_switch TRUE)
	(ai_set_orders gondola_01_grunt_riders gondola_01_landing_01)
	(game_save)
	(wake music_05b_03_start)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_near_gondola_01 (players)) TRUE)
			(< (ai_living_count gondola_01_enemies) 3)
		)
	)
	(ai_place gondola_01_jackal_riders 2)
	
	(sleep_until 
		(OR
			(<= (ai_living_count gondola_01_jackal_riders) 0)
			(= (volume_test_objects vol_gondola_01 (players)) TRUE)
		)
	30 4000)
	(ai_set_orders gondola_01_elite_riders gondola_01_landing_03)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_gondola_01 (players)) TRUE)
			(AND
				(<= (ai_living_count gondola_01_enemies) 0)
				(<= (ai_living_count central_platform_enemies) 0)
				(<= (ai_living_count bridge_enemies) 0)
			)
		)
	30 4000)
	(sleep 30)
	(wake gondola_01_cortana_comment)
	(sleep 150)
	(ai_scene gondola_01_allies_scene gondola_01_ally_comment all_allies)
	(ai_set_orders all_allies gondola_01_allies)
	(game_save)
	
	(sleep_until (= (volume_test_objects vol_gondola_01 (players)) TRUE) 30 1800)
	(if 
		(AND
			(= (volume_test_objects vol_gondola_01 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(wake gondola_01_cortana_reminder)
			)
	)	
)

(script static void short_central_plat_ph
	(device_set_position_immediate gondola_01_a .5)
	(device_set_position_immediate gondola_01_b .5)
	(ai_place central_platform_hunters 2)
	(ai_place central_platform_phantom 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) "phantom_p_a" (ai_actors central_platform_hunters))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location central_platform_phantom/pilot) TRUE)
	(cs_run_command_script central_platform_phantom/pilot central_platform_dropship)
	(sleep 4000)
	(object_destroy (ai_vehicle_get_from_starting_location central_platform_phantom/pilot))
)

;-------------------------------------------------------------------------------
;Gondola Ride 1

(script dormant assassin_ice_cream
	(sleep_until (= (volume_test_objects_all vol_assassins (players)) FALSE))
	(object_create assassins)
	(ai_place assassin_elites)
	(ai_set_active_camo assassin_elites TRUE)
	(cs_run_command_script assassin_elites forever_pause)
	(custom_animation_loop (unit (list_get (ai_actors assassin_elites) 0)) objects\characters\elite\elite "combat:sword:berserk" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors assassin_elites) 1)) objects\characters\elite\elite "combat:sword:berserk" TRUE)

	(sleep_until 
		(OR
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 2)
)

(script command_script gondola_01_jumper_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
;	(cs_go_to_and_face gondola_boarders/p1 gondola_boarders/p0)
	(cs_move_in_direction 90 2 0)
	(cs_move_in_direction 45 5.5 0)
	(cs_move_in_direction 95 1 0)
	(cs_jump 45 7)
)
(script command_script gondola_01_jumper_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
;	(cs_go_to_and_face gondola_boarders/p2 gondola_boarders/p0)
	(cs_move_in_direction 90 2.75 0)
	(cs_move_in_direction 45 5.5 0)
	(cs_move_in_direction 90 1 0)
	(cs_jump 45 7.5)
)
(script command_script gondola_01_jumper_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
;	(cs_go_to_and_face gondola_boarders/p3 gondola_boarders/p0)
	(cs_move_in_direction 90 3.5 0)
	(cs_move_in_direction 45 5.5 0)
	(cs_move_in_direction 85 1 0)
	(cs_jump 45 8.0)
)
(script command_script gondola_01_jumper_04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
;	(cs_go_to_and_face gondola_boarders/p4 gondola_boarders/p0)
	(cs_move_in_direction 90 4.25 0)
	(cs_move_in_direction 45 5.5 0)
	(cs_move_in_direction 75 1 0)
	(cs_jump 45 8.5)
)

(script dormant gondola_01_buggers_board
	(sleep 150)
	(ai_place gondola_01_bugs_new 4)
;	(ai_place gondola_01_buggers/1)
;	(cs_run_command_script gondola_01_buggers/1 gondola_01_jumper_01)
;	(sleep 30)
;	(ai_place gondola_01_buggers/2)
;	(cs_run_command_script gondola_01_buggers/2 gondola_01_jumper_02)
;	(sleep 30)
;	(ai_place gondola_01_buggers/3)
;	(cs_run_command_script gondola_01_buggers/3 gondola_01_jumper_03)
;	(sleep 30)
;	(ai_place gondola_01_buggers/4)
;	(cs_run_command_script gondola_01_buggers/4 gondola_01_jumper_04)
)

;Cortana reminds you to activate the gondola, in case you're a dumbass
(script dormant gondola_01_go_reminder
	(sleep_until (> (device_group_get gondola_01_switch) 0) 30 1800)
	(if (= (device_group_get gondola_01_switch) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'If you hit the activation-switch, it should drive itself.'")
			(sleep (ai_play_line_on_object NONE 0960))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0960_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)

	(sleep_until (> (device_group_get gondola_01_switch) 0) 30 900)
	(if (= (device_group_get gondola_01_switch) 0)
		(begin
			(activate_team_nav_point_object default player gondola_01_switch_back 0)
			(sleep_until (< (device_get_position gondola_01_a) 1))
			(deactivate_team_nav_point_object player gondola_01_switch_back)
		)
	)
)

;Ally points out hostile boarders on roof
(script command_script gondola_01_boarders_warn
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Whoa!  We got boarders!'")
	(cs_play_line 0970)
)

;Cortana ponders the creation of the lake during a lull
(script dormant gondola_01_cortana_arch
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'This lake couldn't have been formed by volcanic action -'")
	(print "'which means it was either built this way on purpose,'")
	(print "'or was created by some other cataclysmic event.'")
	(sleep (ai_play_line_on_object NONE 0980))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0980_cor))
	(sleep 30)
	(print "CORTANA: 'Sorry. Were you trying to kill something?'")
	(sleep (ai_play_line_on_object NONE 0990))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0990_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(game_save)
)

;Phantom flies off after depositing guys on roof
(script command_script gondola_01_retreat
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_by bsp1_airspace/ph_02_4 2)
	(cs_fly_to bsp1_airspace/ph_02_x 2)
	(ai_erase gondola_01_phantom)
)

;Phantom unloads guys on gondola roof
(script dormant gondola_01_unload
	(sleep 90)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_a01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_a02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_a03")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_b01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_b02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_b03")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_c01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_c02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p_c03")
	
	(sleep 90)
	(cs_run_command_script gondola_01_phantom/pilot gondola_01_retreat)
)

;Phantom flies in and matches speed/course of gondola
(script command_script gondola_01_flight
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by bsp1_airspace/ph_02_0 2)
	(cs_fly_by bsp1_airspace/ph_02_1 2)
	(cs_fly_to_and_face bsp1_airspace/ph_02_2 bsp1_airspace/ph_02_3)
	(cs_vehicle_speed .3)
	(wake gondola_01_unload)
	(cs_fly_to bsp1_airspace/ph_02_3)
)

;Loads and launches phantom
(script dormant gondola_01_phantom_arrives
	(ai_place gondola_01_elite_boarders 2)
	(ai_place gondola_01_grunt_boarders_01 2)
	(ai_place gondola_01_grunt_boarders_02 2)
	(ai_place gondola_01_phantom 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p" (ai_actors gondola_01_grunt_boarders_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p" (ai_actors gondola_01_elite_boarders))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) "phantom_p" (ai_actors gondola_01_grunt_boarders_02))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location gondola_01_phantom/pilot) TRUE)
	(cs_run_command_script gondola_01_phantom/pilot gondola_01_flight)

	(sleep_until (< (ai_living_count gondola_01_phantom) 2))
	(sleep_until 
		(AND
			(<= (ai_living_count gondola_01_grunt_boarders_01) 0)
			(<= (ai_living_count gondola_01_grunt_boarders_02) 0)
		)
	)
	(ai_set_orders gondola_01_elite_boarders gondola_01_all)
)

;Sends grunts to their turrets
(script command_script tower3_turret_mount_01
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tower3/left)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location tower3_turrets/left))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep 120)
	(if (= (vehicle_test_seat (ai_vehicle_get_from_starting_location tower3_turrets/left) "c_turret_ap_d" (unit (ai_get_object ai_current_actor))) TRUE)
		(cs_set_behavior guard)
	)
)
(script command_script tower3_turret_mount_02
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to tower3/right)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location tower3_turrets/right))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(sleep 120)
	(if (= (vehicle_test_seat (ai_vehicle_get_from_starting_location tower3_turrets/right) "c_turret_ap_d" (unit (ai_get_object ai_current_actor))) TRUE)
		(cs_set_behavior guard)
	)
)

(script dormant tower3_turret_reman
	(sleep 300)
	(sleep_until
		(begin
			(sleep (random_range 30 90))
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location tower3_turrets/right)) 0)
					(= (volume_test_objects vol_tower3_entry (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count tower3_dock_grunts) 5)
					(< (ai_living_count tower3_dock_grunts) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location tower3_turrets/right) "c_turret_ap_d" (ai_actors all_enemies)) FALSE)
				)
					(begin
						(ai_place tower3_dock_grunts 1)
						(cs_run_command_script tower3_dock_grunts tower3_turret_mount_02)
					)		
			)
			(sleep (random_range 30 90))
			(if 
				(AND
					(> (object_get_health (ai_vehicle_get_from_starting_location tower3_turrets/left)) 0)
					(= (volume_test_objects vol_tower3_entry (players)) FALSE)
					(> (player_count) 0)
					(< (ai_spawn_count tower3_dock_grunts) 5)
					(< (ai_living_count tower3_dock_grunts) 1)
					(= (vehicle_test_seat_list (ai_vehicle_get_from_starting_location tower3_turrets/left) "c_turret_ap_d" (ai_actors all_enemies)) FALSE)
				)
					(begin
						(ai_place tower3_dock_grunts 1)
						(cs_run_command_script tower3_dock_grunts tower3_turret_mount_01)
					)		
			)
			(OR
				(= (volume_test_objects vol_tower3_entry (player0)) TRUE)
				(AND
					(<= (object_get_health (ai_vehicle_get_from_starting_location tower3_turrets/right)) 0)
					(<= (object_get_health (ai_vehicle_get_from_starting_location tower3_turrets/left)) 0)
				)
			)
		)
	)
)

;Reinforces snipers when killed off
(script dormant tower3_dock_above
	(sleep_until 
		(OR
			(<= (ai_living_count tower3_dock_snipers) 0)
			(= (device_get_position gondola_01_a) 0)
		)
	)
	(if (> (device_get_position gondola_01_a) 0)
		(ai_place tower3_dock_snipers 2)
	)
)

(script dormant gondola_01_nuke
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors tower_cluster_enemies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors tower_cluster_enemies) 0)) 30)
				)
					(object_destroy (list_get (ai_actors tower_cluster_enemies) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors tower_cluster_enemies) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors tower_cluster_enemies) 1)) 30)
				)
					(object_destroy (list_get (ai_actors tower_cluster_enemies) 1))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors tower_cluster_enemies) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors tower_cluster_enemies) 2)) 30)
				)
					(object_destroy (list_get (ai_actors tower_cluster_enemies) 2))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(< (device_get_position gondola_01_a) .25)
		)
	)
)

(global real gondola_01_state 0)
(script dormant gondola_01_restarter
	(sleep_until 
		(begin
			(set gondola_01_state (device_get_position gondola_01_a))
			(if 
				(AND
					(= (volume_test_objects_all vol_gondola_01_mid (players)) TRUE)
					(> (player_count) 0)
				)
					(begin
						(device_set_position gondola_01_a 0)
						(device_set_position gondola_01_b 0)			
					)
					(begin
						(device_set_position gondola_01_a gondola_01_state)
						(device_set_position gondola_01_b gondola_01_state)			
					)
			)
			(< (device_get_position gondola_01_a) .4)
		)
	)
)
(script dormant gondola_01_reverser
	(sleep_until 
		(begin
			;(set gondola_01_state (device_get_position gondola_01_a))
			(if 
				(AND
					(= (volume_test_objects_all vol_gondola_01_mid (players)) TRUE)
					(> (player_count) 0)
				)
					(begin
						(device_set_position gondola_01_a 0)
						(device_set_position gondola_01_b 0)			
					)
					(begin
						(device_set_position gondola_01_a .54)
						(device_set_position gondola_01_b .54)			
					)
			)
			(< (device_get_position gondola_01_a) .4)
		)
	)
)

;nukes shit behind you
(script dormant tower_cluster_delete
	(sleep_until (= (objects_can_see_flag (players) tower_cluster 45) FALSE) 30 300)
	(garbage_collect_unsafe)
	(object_destroy_containing "tower_cluster_")
)

;Overall script for first gondola ride
(script dormant gondola_01_start
	(sleep_until (= (volume_test_objects vol_gondola_01 (players)) TRUE))
	(ai_disposable central_platform_enemies TRUE)
	(data_mine_set_mission_segment "05b_5_gondola_01")
	(ai_renew all_allies)
	(wake objective_towers_clear)
	(wake objective_gondola1_set)
	(wake gondola_01_go_reminder)
	(game_save)
	
	(sleep_until (> (device_group_get gondola_01_switch) 0))
	(device_set_power gondola_01_switch_back 0)
;	(device_set_power gondola_01_switch_back 0)
	(wake music_05b_02_stop)
	(wake music_05b_03_stop)
	(wake tower_cluster_delete)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_gondola_01 (players)) TRUE)
			(> (player_count) 0)
		)
	)

;9/11
	(object_dynamic_simulation_disable gondola_01_a FALSE)
	(object_dynamic_simulation_disable gondola_01_b FALSE)

	(wake 05b_title1)
	(device_set_position gondola_01_launch_a 1)
	(device_set_position gondola_01_launch_b 1)
	(device_set_position gondola_01_a .54)
	(device_set_position gondola_01_b .54)
	(game_save)
	(wake gondola_01_buggers_board)
	;(wake gondola_01_phantom_arrives)
	
;	(sleep 180)
		
	(sleep_until (< (device_get_position gondola_01_a) .85))
	(game_save)
	(ai_place gondola_01_b_elites 2)
	(ai_place gondola_01_b_buggers (- 4 (ai_living_count gondola_01_bugs_new)))
	(ai_place tower3_dock_grunts 2)
	(cs_run_command_script tower3_dock_grunts/1 tower3_turret_mount_01)
	(cs_run_command_script tower3_dock_grunts/2 tower3_turret_mount_02)
	(wake gondola_01_nuke)
	(wake tower3_turret_reman)
	
	(sleep_until (< (device_get_position gondola_01_a) .7))
	(wake gondola_01_cortana_arch)
	
;	(sleep_until (< (device_get_position gondola_01_a) .6))
;	(ai_scene gondola_01_boarders_scene gondola_01_boarders_warn all_allies)
	
	(sleep_until (= (device_get_position gondola_01_a) .54))
	(game_save)
	(ai_place tower3_dock_snipers 2)
	(wake tower3_dock_above)
	(ai_set_orders gondola_01_b_buggers gondola_01_all)

;9/11
	(object_dynamic_simulation_disable gondola_01_a TRUE)
	(object_dynamic_simulation_disable gondola_01_b TRUE)

	(sleep_until (< (+ (ai_living_count gondola_01_b_elites) (ai_living_count gondola_01_b_buggers)) 1) 30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" gondola_01_enemies) TRUE) 30 1800)
	(sleep 60)
	(game_save)

;9/11
	(object_dynamic_simulation_disable gondola_01_a FALSE)
	(object_dynamic_simulation_disable gondola_01_b FALSE)
	(wake music_05b_04_start)
	(wake gondola_01_reverser)

	(sleep_until (< (device_get_position gondola_01_a) .25))
	(game_save)
	
	(sleep_until (= (device_get_position gondola_01_a) 0))
	(game_save)
	(device_set_position gondola_01_launch_a 0)
	(device_set_position gondola_01_launch_b 0)
	(ai_place tower3_dock_jackals 2)
	(wake music_05b_04_stop)
	(if (difficulty_legendary)
		(wake assassin_ice_cream)
	)

	(sleep_until 
		(AND
			(= (device_get_position gondola_01_a) 0)
			(= (volume_test_objects_all vol_gondola_01 (players)) FALSE)
			(> (player_count) 0)
		)
	)

;9/11
	(object_dynamic_simulation_disable gondola_01_a TRUE)
	(object_dynamic_simulation_disable gondola_01_b TRUE)

	(ai_set_orders all_allies tower3_allies)
	(game_save)
)


;-------------------------------------------------------------------------------
;Tower 3

(global effect splashy "effects\scenarios\solo\deltatemple\elevator_splash")

(script static void cam_shake
	(player_effect_set_max_rotation 0 2 2)
	(player_effect_set_max_vibration 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1)
)

;for marcus
(script static void godownfast
	(device_set_position_track elev_under transition_1to2 0)
	(device_animate_position elev_under .135 1 1 1 FALSE)
)
(script static void nowcomeup
	(device_animate_position elev_under 0 15 1 1 FALSE)
)
(script static void go1to2
	(device_set_position_track elev_under transition_1to2 0)
	(device_animate_position elev_under .103 10 1 1 FALSE)
	(sleep_until (= (device_get_position elev_under) .103))
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_under (player0)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player0) 1to2_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_under (player1)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player1) 1to2_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	(switch_bsp 3)
	
	(sleep_until (= (structure_bsp_index) 3))
	(device_animate_position elev_under 1 60 1 1 FALSE)

	;(object_clear_all_function_variables elev_under)
	(sleep_until (> (device_get_position elev_under) .122) 1)
	;(object_set_function_variable elev_under "splash_down" 1 1)
	(effect_new splashy splash_01)
	(effect_new splashy splash_02)
	(effect_new splashy splash_03)
	(effect_new splashy splash_04)
	(effect_new splashy splash_05)
	(effect_new splashy splash_06)
	(effect_new splashy splash_07)
	(effect_new splashy splash_08)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_impact_water "none" 1)	
	(object_destroy water_1to2a)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_under) .128) 1)
	(object_create_anew water_1to2a)
	;(object_clear_all_function_variables elev_under)

	(wake music_05b_05_start)
	(sleep 60)
	(ai_erase all_enemies)
		
	(sleep_until
		(begin
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 5)
				(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 5)
				(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 5)
				(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 5)
				(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 5)
				(object_destroy (list_get (ai_actors all_allies) 4))
			)
			(sleep 5)
			(> (device_get_position elev_under) .5)
		)
	)
	
	(sleep_until (> (device_get_position elev_under) .6))
	
	(sleep_until (> (device_get_position elev_under) .866) 1)
	;(object_set_function_variable elev_under "splash_up" 1 1)
	(effect_new splashy splash_09)
	(effect_new splashy splash_10)
	(effect_new splashy splash_11)
	(effect_new splashy splash_12)
	(effect_new splashy splash_13)
	(effect_new splashy splash_14)
	(effect_new splashy splash_15)
	(effect_new splashy splash_16)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_out_of_water "none" 1)	
	(object_destroy water_1to2b)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_under) .874) 1)
	(object_create_anew water_1to2b)
	;(object_clear_all_function_variables elev_under)
)
(script static void sub2doors
	(device_set_position_track elev_up transition_2to3 0)
	(device_animate_position elev_up 0 1 1 1 FALSE)
)
(script static void go2to3
	(device_set_position_track elev_up transition_2to3 0)
	(device_animate_position elev_up .103 10 1 1 FALSE)
	(sleep_until (= (device_get_position elev_up) .103))
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_up (player0)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player0) 2to3_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_up (player1)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player1) 2to3_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	
	(switch_bsp 4)

	(sleep_until (= (structure_bsp_index) 4))
	(device_animate_position elev_up 1 60 1 1 FALSE)

	;(object_clear_all_function_variables elev_up)
	(sleep_until (> (device_get_position elev_up) .134) 1)
	;(object_set_function_variable elev_up "splash_down" 1 1)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_impact_water "none" 1)	
	(object_destroy water_2to3a)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_up) .143) 1)
	(object_create_anew water_2to3a)
	;(object_clear_all_function_variables elev_up)

	(wake music_05b_08_start)
	(sleep 60)
	(ai_erase all_enemies)
	
	(sleep_until
		(begin
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 5)
				(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 5)
				(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 5)
				(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 5)
				(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 5)
				(object_destroy (list_get (ai_actors all_allies) 4))
			)
			(sleep 5)
			(> (device_get_position elev_up) .7)
		)
	)
	
	(sleep_until (> (device_get_position elev_up) .889) 1)
	;(object_set_function_variable elev_up "splash_up" 1 1)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_out_of_water "none" 1)	
	(object_destroy water_2to3b)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_up) .896) 1)
	(object_create_anew water_2to3b)
	;(object_clear_all_function_variables elev_up)
)

;Pelican arrives after the room is clear
(script command_script tower3_pelican_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_by tower3_airspace/pel0 2)
	(cs_vehicle_boost TRUE)
	(cs_fly_by tower3_airspace/peln 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_by tower3_airspace/pel1 5)
	(cs_vehicle_speed .5)	
	(cs_fly_by tower3_airspace/pel1 1)
	(cs_fly_to_and_face tower3_airspace/pel2 tower3_airspace/p0 1)
	(ai_place tower3_pelican_allies (- 2 (ai_living_count allies_infantry)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location tower3_pelican/pilot) "pelican_p" (ai_actors tower3_pelican_allies))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tower3_pelican/pilot) TRUE)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location tower3_pelican/pilot) "pelican_p")

	(sleep_until (< (ai_living_count tower3_pelican) 4))
	(sleep 60)
	(cs_fly_to_and_face tower3_airspace/pel1 tower3_airspace/peln 2)
	(cs_vehicle_speed 1)
	(cs_fly_by tower3_airspace/peln 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_by tower3_airspace/pel0 20)
	(cs_vehicle_boost FALSE)
	(cs_fly_to tower3_airspace/pelx 10)
	(ai_erase tower3_pelican)
)

;Loads and launches the pelican
(script dormant tower3_pelican_arrives
	(ai_place tower3_pelican)
	(cs_run_command_script tower3_pelican/pilot tower3_pelican_path)
)
(script static void short_tower3_pel
	(ai_place tower3_pelican)
	(cs_run_command_script tower3_pelican/pilot tower3_pelican_path)
)

(global boolean tower3_cortana_cont FALSE)
(global boolean tower3_done_blabbing FALSE)
;Cortana comments on where you're going next as you arrive
(script dormant tower3_cortana_comment
	(sleep_until (= (ai_trigger_test "done_fighting" tower3_enemies) TRUE))
;	(sleep 60)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Ah, now I see. There's a submerged section that...'")
	(print "'...connects these towers to the outlying structures.'")
	(sleep (ai_play_line_on_object NONE 1000))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1000_cor))
	(sleep 60)
	(print "'Looks like we're going down.'")
	(sleep (ai_play_line_on_object NONE 1010))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1010_cor))
	(sleep 30)
	(print "'Unless you'd prefer to swim...'")
	(sleep (ai_play_line_on_object NONE 1020))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1020_cor))
	
;	(sleep_until (= tower3_cortana_cont TRUE))
;	(print "CORTANA: 'There should be an elevator...'")
;	(sleep (ai_play_line_on_object NONE 1030))
;	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1030_cor))
;	(sleep 30)
;	(ai_dialogue_enable TRUE)
	
	(set tower3_done_blabbing TRUE)
)

;Ally points out enemies approaching on elevator
(script command_script tower3_ally_warn
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Full car coming up!'")
	(cs_play_line 1040)
)

;Cortana reminds you to take the elevator
(script dormant tower3_cortana_reminder_02
	(sleep_until (> (device_group_get elev_under_switch) 0) 30 3600)
	(if (= (device_group_get elev_under_switch) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'All right. Let's see where this elevator goes...'")
			(sleep (ai_play_line_on_object NONE 1050))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1050_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
	
	(sleep_until (> (device_group_get elev_under_switch) 0) 30 1800)
	(if (= (device_group_get elev_under_switch) 0)
		(begin
			(activate_team_nav_point_object default player elev_under_switch_01 0)
			(sleep_until (> (device_group_get elev_under_switch) 0))
			(deactivate_team_nav_point_object player elev_under_switch_01)
		)
	)
)

;Cortana gives you some background info on the prophet as you progress
(script dormant elev_under_cortana_comment
	(ai_dialogue_enable FALSE)
	(sleep 180)
	(print "CORTANA: 'I've intercepted a secure transmission from Regret's carrier...'")
	(print "'...to something called High Charity. It's seems to be a formal apology - '")
	(print "'to the Prophets of Truth and Mercy.'")
	(sleep (ai_play_line_on_object NONE 2120))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2120_cor))
	(sleep 15)
	(print "CORTANA: 'Apparently, Regret jumped the gun when he attacked Earth.'")
	(print "'He's asking the other Prophets to forgive his premature arrival...'")
	(print "'...arguing that no human presence was foretold.")
	(sleep (ai_play_line_on_object NONE 2130))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2130_cor))
	(print "CORTANA: 'That explains why there were so few ships in his fleet.'")
	(print "'But it's odd a Prophet would have such bad intel about his enemy's home-world.'")
	(sleep (ai_play_line_on_object NONE 2140))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2140_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Tells if an ally has made a comment on elevator ride down
(global boolean elev_under_scene_gone FALSE)

;Random ally comments on descending underwater
(script command_script elev_under_ally_01
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Hey, my ears just popped!'")
	(cs_play_line 1060)
)
(script command_script elev_under_ally_02
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Uh, just exactly how deep are we?'")
	(cs_play_line 1070)
)
(script command_script elev_under_ally_03
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'You think that glass is bulletproof?'")
	(cs_play_line 1080)
)

;Grunt sleeping up in secret nook with flak cannon
(script dormant tower3_sleeper_spawn
	(sleep_until (= (volume_test_objects vol_tower3_upstairs (players)) TRUE))
	(ai_place tower3_sleeper 1)
)

(script dormant elev_under_monitor
	(sleep_until (> (device_group_get elev_under_switch) 0))
	(device_set_power elev_under_switch_01 0)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_inside_elev_under (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(device_set_position_track elev_under transition_1to2 0)
	(device_animate_position elev_under .103 10 1 1 FALSE)
	(sleep_until (= (device_get_position elev_under) .103))
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_under (player0)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player0) 1to2_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_under (player1)) FALSE)
			(> (player_count) 0)
			(= (game_is_cooperative) TRUE)
		)
			(begin
				(object_teleport (player1) 1to2_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player1) "") 
			)
	)
	(switch_bsp 3)
	
	(sleep_until (= (structure_bsp_index) 3))
	(game_can_use_flashlights 1)
	(device_animate_position elev_under 1 60 1 1 FALSE)

	;(object_clear_all_function_variables elev_under)
	(sleep_until (> (device_get_position elev_under) .122) 1)
	;(object_set_function_variable elev_under "splash_down" 1 1)
	(effect_new splashy splash_01)
	(effect_new splashy splash_02)
	(effect_new splashy splash_03)
	(effect_new splashy splash_04)
	(effect_new splashy splash_05)
	(effect_new splashy splash_06)
	(effect_new splashy splash_07)
	(effect_new splashy splash_08)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_impact_water "none" 1)	
	(object_destroy water_1to2a)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_under) .128) 1)
	(object_create_anew water_1to2a)
	(kill_volume_enable kill_no_riders_under)
	;(object_clear_all_function_variables elev_under)

	(wake music_05b_05_start)
	(sleep 60)
;	(ai_erase all_enemies)
	(wake elev_under_cortana_comment)
		
	(sleep_until
		(begin
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 5)
				(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 5)
				(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 5)
				(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 5)
				(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 5)
				(object_destroy (list_get (ai_actors all_allies) 4))
			)
			(sleep 5)
			(> (device_get_position elev_under) .5)
		)
	)
	
	(sleep_until (> (device_get_position elev_under) .6))
	
;	(begin_random
;		(if (= elev_under_scene_gone FALSE)
;			(begin
;				(ai_scene elev_under_ally_scene_01 elev_under_ally_01 all_allies)
;				(set elev_under_scene_gone TRUE)
;			)
;		)
;		(if (= elev_under_scene_gone FALSE)
;			(begin
;				(ai_scene elev_under_ally_scene_02 elev_under_ally_02 all_allies)
;				(set elev_under_scene_gone TRUE)
;			)
;		)
;		(if (= elev_under_scene_gone FALSE)
;			(begin
;				(ai_scene elev_under_ally_scene_03 elev_under_ally_03 all_allies)
;				(set elev_under_scene_gone TRUE)
;			)
;		)
;	)
	
	(sleep_until (> (device_get_position elev_under) .866) 1)
	;(object_set_function_variable elev_under "splash_up" 1 1)
	(effect_new splashy splash_09)
	(effect_new splashy splash_10)
	(effect_new splashy splash_11)
	(effect_new splashy splash_12)
	(effect_new splashy splash_13)
	(effect_new splashy splash_14)
	(effect_new splashy splash_15)
	(effect_new splashy splash_16)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_out_of_water "none" 1)	
	(object_destroy water_1to2b)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_under) .874) 1)
	(object_create_anew water_1to2b)
	;(object_clear_all_function_variables elev_under)
	(kill_volume_disable kill_no_riders_under)
)

;Overall script for tower 3
(script dormant tower3_start
	(ai_disposable gondola_01_enemies TRUE)
	(data_mine_set_mission_segment "05b_6_tower3")
	(ai_renew all_allies)
	(game_save)
	
	(objects_attach elev_under "switch" elev_under_switch_01 "")
	(device_group_change_only_once_more_set elev_under_switch TRUE)
	(godownfast)

	(wake tower3_sleeper_spawn)
	(wake objective_gondola1_clear)
	(wake objective_sunken_set)	
	(ai_place tower3_jackals_01 4)
	
	(sleep_forever tower3_turret_reman)
	(cs_run_command_script tower3_turrets abort)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower3_mid (players)) TRUE)
			(< (ai_living_count tower3_main) 2)	
		)
	)
	(game_save)
	(ai_place tower3_jackals_02 (- 4 (ai_living_count tower3_jackals_01)))

	(sleep_until (< (ai_living_count tower3_main) 2) 30 3600)
	(game_save)
	(if 
		(AND
			(= (volume_test_objects vol_tower3_upstairs (players)) FALSE)
			(> (player_count) 0)
		)
			(ai_place tower3_buggers_01 3)
	)	
		
	(sleep_until (< (ai_living_count tower3_main) 2) 30 3600)
	(game_save)
	(if 
		(AND
			(= (volume_test_objects vol_tower3_upstairs (players)) FALSE)
			(> (player_count) 0)
		)
			(ai_place tower3_buggers_02 (- 3 (ai_living_count tower3_buggers_01)))
	)
	
	(sleep_until (<= (ai_living_count tower3_main) 0) 30 3600)
	(wake tower3_cortana_comment)
	(if (< (ai_living_count all_allies) 2)
		(wake tower3_pelican_arrives)
	)
	;(set tower3_cortana_cont TRUE)
	
	(sleep_until (= tower3_done_blabbing TRUE))
	(ai_place tower3_jackals_elev 3)
	(sleep 30)
	(game_save)
	(nowcomeup)
	(kill_volume_disable kill_no_riders_under)
	(sleep 150)
	(ai_scene tower3_ally_scene tower3_ally_warn all_allies)
	
	(sleep_until (= (device_get_position elev_under) 0))
	(ai_set_orders tower3_jackals_elev tower3_int_elev_ridge)
	(wake tower3_cortana_reminder_02)
	(wake elev_under_monitor)
	
	(sleep_until 
		(OR
			(<= (ai_living_count tower3_main) 0)
			(AND
				(= (volume_test_objects_all vol_inside_elev_under (players)) TRUE)
				(> (player_count) 0)
			)
		)
	)
	(ai_set_orders all_allies tower3_on_elev)
)


;-------------------------------------------------------------------------------
;Sunken Tunnel 1

;Cortana pointing out sunken ruins
(script dormant tunnel_01_cortana_comment
	(sleep_until 
		(OR 
			(= (ai_trigger_test "done_fighting" tunnel_01_enemies) TRUE)
			(= (volume_test_objects vol_sunken_chamber_entry (players)) TRUE)
		)
	)
	(sleep_until (= (volume_test_objects vol_sunken_chamber_entry (players)) TRUE) 30 300)
	(if 
		(AND
			(= (volume_test_objects vol_sunken_chamber_entry (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Out there...look! More ruins!'")
				(sleep (ai_play_line_on_object NONE 1090))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1090_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Overall script for sunken tunnel 1
(script dormant sunken_tunnel1_start	
	(ai_disposable tower3_enemies TRUE)
	(data_mine_set_mission_segment "05b_7_tunnel1")
	(ai_renew all_allies)
	
	(sleep_until (= (device_get_position elev_under) 1))	
	(game_save)
	(ai_set_orders all_allies tunnel_01_suppress)
	(ai_place tunnel_01_grunts_patrol 2)
	(ai_place tunnel_01_grunts_01 3)
	(ai_place tunnel_01_grunts_02 2)

	(wake music_05b_06_start)
				
	(sleep_until 
		(OR
			(> (ai_combat_status tunnel_01_enemies) ai_combat_status_idle)
			(= (volume_test_objects vol_tunnel_01_mid (players)) TRUE)
		)
	)
	(sleep 60)
	(ai_set_orders all_allies tunnel_01_allies)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_tunnel_01_mid (players)) TRUE)
			(< (ai_living_count tunnel_01_enemies) 5)
		)
	)
	(game_save)
	(ai_place tunnel_01_grunts_03 (- 3 (ai_living_count tunnel_01_grunts_01)))
	
	(sleep_until 
		(OR
			(<= (ai_living_count tunnel_01_enemies) 0)
			(= (volume_test_objects vol_sunken_chamber_entry (players)) TRUE)
		)
	30 1800)
	(game_save)
;	(wake tunnel_01_cortana_comment)
)


;-------------------------------------------------------------------------------
;Sunken Chamber

;Cortana commenting on giant prophet hologram
(script dormant sunken_holo_cortana_comment
	(sleep_until 
		(AND
			(< (objects_distance_to_object (players) regret02) 10)
			(objects_can_see_object (players) regret02 30)
			(= (volume_test_objects vol_sunk_chamber_right (players)) TRUE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'And people say I've got a big head...'")
	(sleep (ai_play_line_on_object NONE 1100))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1100_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Ally reacts to what the prophet just said
(script command_script sunken_holo_ally_react
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Oh, man. He is so dead!'")
	(cs_play_line 1110)
)

(global boolean sunken_holo_trans FALSE)
(global boolean sunken_holo_chant TRUE)
(script dormant sunken_holo_looper
	(object_create_anew sunken_throne)
	(object_create_anew regret02)
	(objects_attach sunken_throne "driver" regret02 "")
	(ai_disregard regret02 TRUE)
	(sleep_until
		(begin
			(begin_random
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret02 3000))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret02 3001))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret02 3002))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret02 3003))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret02 3004))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret02 3005))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
				(if (= sunken_holo_trans FALSE)
					(begin
						(set sunken_holo_chant TRUE)
						(custom_animation regret02 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret02 3006))
						(sleep (random_range 240 480))
						(set sunken_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

;Cortana translates the prophet if you linger near him
(script dormant sunken_holo_translate
	(sleep_until (<= (ai_living_count sunken_chamber_enemies) 0))
	(sleep 150)
	(set sunken_holo_trans TRUE)

	(sleep_until 
		(AND
			(< (objects_distance_to_object (players) regret02) 10)
			(= sunken_holo_chant FALSE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "REGRET: 'Most of those we encountered on our search were compelled...'")
	(print "REGRET: '...to join our union - to take part in a movement that promised...'")
	(print "REGRET: '...freedom for allegiance! Salvation for service!'")
	(custom_animation regret02 objects\characters\prophet\prophet "regret_l05_0140_por" TRUE)
	(sleep (ai_play_line_on_object regret02 0140))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0140_por))
	(sleep 30)
	(print "'But some, like the humans, chose to impede our progress -'")
	(print "'block our access to sacred sites, damage holy relics! For their...'")
	(print "'...transgressions the humans shall be hunted until none remain alive!'")
	(custom_animation regret02 objects\characters\prophet\prophet "regret_l05_0150_por" TRUE)
	(sleep (ai_play_line_on_object regret02 0150))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0150_por))
	(sleep 60)
	(ai_scene sunken_holo_ally_scene sunken_holo_ally_react all_allies)
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 240 480))
	(set sunken_holo_trans FALSE)
)

;Cortana reminds you to keep moving if you are lagging
(script dormant sunken_chamber_reminder
	(sleep_until (= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "CORTANA: 'Keep moving. Let's find our way back to the surface.'")
				(sleep (ai_play_line_on_object NONE 1120))
				;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1120_cor))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Hides and destroys vulnerable guys on opposite side from player
(script dormant hide_rightside_guys
	(sleep_until (> (ai_combat_status sunk_chamber_right_enemies) ai_combat_status_idle))
	(sleep_until 
		(begin
			(sleep_until
				(AND
					(= (volume_test_objects_all vol_sunk_chamber_left (players)) TRUE)
					(> (player_count) 0)
					(> (ai_living_count sunken_rightside_nonsnipers) 0)
				)
			)
			(ai_set_orders sunken_rightside_nonsnipers sunken_rightside_hide)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 0)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_rightside_nonsnipers) 0))
			)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 1)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_rightside_nonsnipers) 1))
			)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_rightside_nonsnipers) 2)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_rightside_nonsnipers) 2))
			)
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE)
		)
	)
)
(script dormant hide_leftside_guys
	(sleep_until (> (ai_combat_status sunk_chamber_left_enemies) ai_combat_status_idle))
	(sleep_until 
		(begin
			(sleep_until
				(AND
					(= (volume_test_objects_all vol_sunk_chamber_right (players)) TRUE)
					(> (player_count) 0)
					(> (ai_living_count sunken_leftside_nonsnipers) 0)
				)
			)
			(ai_set_orders sunken_leftside_nonsnipers sunken_leftside_hide)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 0)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_leftside_nonsnipers) 0))
			)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 1)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_leftside_nonsnipers) 1))
			)
			(if
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sunken_leftside_nonsnipers) 2)) 10)
				)
					(object_destroy (list_get (ai_actors sunken_leftside_nonsnipers) 2))
			)
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE)
		)
	)
)

;Makes jackals focus on the hologram
(script command_script sunken_hologram_focus
	(cs_abort_on_alert TRUE)
	(cs_face_object TRUE regret02)
	(cs_pause -1)
)

(global short sunken_sniper_total 2)
(global short sunken_hg_total 1)
(global short sunken_jacks_total 2)

;Scripts to spawn reinforcements, if the encounter is alerted
(script static void sunken_try_reinforce_R
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_R1a) 0)
			(= (device_get_position sunk_chmbr_spwn_R1b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R1a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R1b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_jack_R_01 (- sunken_jacks_total (ai_living_count sunken_jacks_right)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_hg_R_01 (- sunken_hg_total (ai_living_count sunken_hg_right)))
				)
			)
	)
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_R2a) 0)
			(= (device_get_position sunk_chmbr_spwn_R2b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R2a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R2b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_jack_R_02 (- sunken_jacks_total (ai_living_count sunken_jacks_right)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_hg_R_02 (- sunken_hg_total (ai_living_count sunken_hg_right)))
				)
			)
	)
)
(script static void sunken_try_reinforce_L
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_L1a) 0)
			(= (device_get_position sunk_chmbr_spwn_L1b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L1a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L1b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_jack_L_01 (- sunken_jacks_total (ai_living_count sunken_jacks_left)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_hg_L_01 (- sunken_hg_total (ai_living_count sunken_hg_left)))
				)
			)
	)
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_L2a) 0)
			(= (device_get_position sunk_chmbr_spwn_L2b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L2a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L2b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_jack_L_02 (- sunken_jacks_total (ai_living_count sunken_jacks_left)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_hg_L_02 (- sunken_hg_total (ai_living_count sunken_hg_left)))
				)
			)
	)
)
(script static void sunken_try_js_R1
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_R1a) 0)
			(= (device_get_position sunk_chmbr_spwn_R1b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R1a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R1b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_js_R_01 (- sunken_sniper_total (ai_living_count sunken_rightside_snipers)))
				)
			)
	)
)
(script static void sunken_try_js_R2
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_R2a) 0)
			(= (device_get_position sunk_chmbr_spwn_R2b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R2a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_R2b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_js_R_02 (- sunken_sniper_total (ai_living_count sunken_rightside_snipers)))
				)
			)
	)
)
(script static void sunken_try_js_L1
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_L1a) 0)
			(= (device_get_position sunk_chmbr_spwn_L1b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L1a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L1b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_js_L_01 (- sunken_sniper_total (ai_living_count sunken_leftside_snipers)))
				)
			)
	)
)
(script static void sunken_try_js_L2
	(if
		(AND
			(= (device_get_position sunk_chmbr_spwn_L2a) 0)
			(= (device_get_position sunk_chmbr_spwn_L2b) 0)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L2a (players)) FALSE)
			(= (volume_test_objects vol_sunk_chmbr_spwn_L2b (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_js_L_02 (- sunken_sniper_total (ai_living_count sunken_leftside_snipers)))
				)
			)
	)
)

;Hunters bust on in, if the encounter is alerted
(script dormant sunk_chamber_hunters_enter
	(sleep_until 
		(OR
			(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE)
		)
	)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(device_operates_automatically_set sunk_chamber_hunter_door TRUE)
				(ai_place sunk_chamber_hunters 2)
			)
	)
)

(global boolean sunken_save_again FALSE)
(script dormant sunken_chamber_saves
	(sleep_until
		(begin
			(sleep_until
				(AND
					;(OR
					;	(= (volume_test_objects vol_sunk_chamber_safe_01 (players)) TRUE)
					;	(= (volume_test_objects vol_sunk_chamber_safe_02 (players)) TRUE)
					;)
					(game_safe_to_save)
					(= sunken_save_again TRUE)
				)
			)
			(game_save_immediate)
			(set sunken_save_again FALSE)
			(= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE)
		)
	)
)

;Overall script for sunken chamber
(script dormant sunken_chamber_start
	(sleep_until (= (volume_test_objects vol_sunken_chamber_entry (players)) TRUE))
	(ai_disposable tunnel_01_enemies TRUE)
	(data_mine_set_mission_segment "05b_8_sunken_chamber")
	(ai_renew all_allies)
	(game_save)
	
	(if (difficulty_legendary)
		(begin
			(set sunken_sniper_total 4)
			(set sunken_jacks_total 0)
			(set sunken_hg_total 3)
		)
	)
	(if (difficulty_heroic)
		(begin
			(set sunken_sniper_total 3)
			(set sunken_jacks_total 1)
			(set sunken_hg_total 2)
		)
	)
		
	(ai_place sunk_chamber_init_js_L01 1)
	(ai_place sunk_chamber_init_js_L02 1)
	;(ai_place sunk_chamber_init_js_L03 1)
	;(ai_place sunk_chamber_init_js_L04 1)
	
	(ai_place sunk_chamber_init_js_R01 1)
	(cs_run_command_script sunk_chamber_init_js_R01 sunken_hologram_focus)
	(ai_place sunk_chamber_init_js_R02 1)
	(cs_run_command_script sunk_chamber_init_js_R02 sunken_hologram_focus)
	;(ai_place sunk_chamber_init_js_R03 1)
	;(cs_run_command_script sunk_chamber_init_js_R03 sunken_hologram_focus)
	;(ai_place sunk_chamber_init_js_R04 1)
	;(cs_run_command_script sunk_chamber_init_js_R04 sunken_hologram_focus)
	
	(ai_place sunk_chamber_init_hg_Ra 1)
	;(ai_place sunk_chamber_init_hg_Rb 1)
	(ai_place sunk_chamber_init_hg_La 1)
	;(ai_place sunk_chamber_init_hg_Lb 1)

	;(scenery_animation_start_loop big_head objects\characters\prophet\prophet "throne_d:any:idle")
	(wake sunken_holo_looper)
;	(wake sunken_holo_translate)
	(wake sunken_holo_cortana_comment)
	(wake hide_rightside_guys)
	(wake hide_leftside_guys)
	(wake sunken_chamber_saves)
	(ai_set_orders all_allies sunken_chamber_allies)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_sunk_chamber_near_01 (players)) TRUE)
			(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_uninspected)
		)
	)
	(set sunken_save_again TRUE)
	(wake music_05b_06_stop)

	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_left (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_L_01 4)
				)
				(sunken_try_js_R1)
			)
	)
	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_right (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_R_01 4)
				)
				(sunken_try_js_L1)
			)
	)
	(if
		(AND
			(= (volume_test_objects vol_sunk_chamber_right (players)) TRUE)
			(= (volume_test_objects vol_sunk_chamber_left (players)) TRUE)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_R_01 2)
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_L_01 2)
				)
				(sunken_try_js_R1)
				(sunken_try_js_L1)
			)
	)
	
	(sleep_until (= (volume_test_objects vol_sunk_chamber_near_02 (players)) TRUE))
	(set sunken_save_again TRUE)
	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_left (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(sunken_try_reinforce_L)
				(sunken_try_js_R1)
			)
	)
	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_right (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(sunken_try_reinforce_R)
				(sunken_try_js_L1)
			)
	)
	(if
		(AND
			(= (volume_test_objects vol_sunk_chamber_right (players)) TRUE)
			(= (volume_test_objects vol_sunk_chamber_left (players)) TRUE)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(sunken_try_reinforce_R)
				(sunken_try_reinforce_L)
				(sunken_try_js_R1)
				(sunken_try_js_L1)
			)
	)

	(sleep_until (= (volume_test_objects vol_sunk_chamber_far_01 (players)) TRUE))
	(set sunken_save_again TRUE)
	(wake sunk_chamber_hunters_enter)
	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_left (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_L_02 (- 4 (ai_living_count sunken_bugs)))
				)
				(sunken_try_js_R2)
			)
	)
	(if
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_right (players)) TRUE)
			(> (player_count) 0)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_R_02 (- 4 (ai_living_count sunken_bugs)))
				)
				(sunken_try_js_L2)
			)
	)
	(if
		(AND
			(= (volume_test_objects vol_sunk_chamber_right (players)) TRUE)
			(= (volume_test_objects vol_sunk_chamber_left (players)) TRUE)
	;		(> (ai_combat_status sunken_chamber_enemies) ai_combat_status_idle)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_R_02 (- 2 (ai_living_count sunk_chamber_bugs_R_01)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_bugs_L_02 (- 2 (ai_living_count sunk_chamber_bugs_L_01)))
				)
				(sunken_try_js_L2)
				(sunken_try_js_R2)
			)
	)

	(sleep_until (= (volume_test_objects vol_sunk_chamber_far_02 (players)) TRUE))
	(set sunken_save_again TRUE)
	(wake sunken_chamber_reminder)
	(device_operates_automatically_set sunk_chamber_exit_R TRUE)
	(device_operates_automatically_set sunk_chamber_exit_L TRUE)
	(if 
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_left (players)) TRUE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_j01_L (- 2 (ai_living_count sunken_jacks_left)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_e_L (max 1 (- 2 (ai_living_count sunken_hg_left))))
				)
			)
	)
	(if 
		(AND
			(= (volume_test_objects_all vol_sunk_chamber_right (players)) TRUE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_j01_R (- 2 (ai_living_count sunken_jacks_right)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_e_R (max 1 (- 2 (ai_living_count sunken_hg_right))))
				)
			)
	)
	(if
		(AND
			(= (volume_test_objects vol_sunk_chamber_right (players)) TRUE)
			(= (volume_test_objects vol_sunk_chamber_left (players)) TRUE)
		)
			(begin
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_j01_L (- 2 (ai_living_count sunken_jacks_left)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_j01_R (- 2 (ai_living_count sunken_jacks_right)))
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_e_L 1)
				)
				(if (< (ai_living_count sunken_chamber_enemies) 8)
					(ai_place sunk_chamber_exit_e_R 1)
				)
			)
	)
	(if (< (ai_living_count sunken_chamber_enemies) 8)
		(ai_place sunk_chamber_exit_j02_R 2)
	)
	(if (< (ai_living_count sunken_chamber_enemies) 8)
		(ai_place sunk_chamber_exit_j02_L 2)
	)
	(wake sunken_holo_translate)

	(sleep_until (= (volume_test_objects vol_leaving_sunken_chamber (players)) TRUE))
	(set sunken_save_again TRUE)
	(ai_set_orders all_allies tunnel_02_allies)
)


;-------------------------------------------------------------------------------
;Sunken Tunnel 2

(script dormant elev_up_cortana_comment
	(ai_dialogue_enable FALSE)
	(sleep 180)
	(print "CORTANA: 'Regret's carrier just received a response from High Charity.'")
	(print "'A very well-encrypted message from the Prophet of Truth.'")
	(sleep (ai_play_line_on_object NONE 2150))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2150_cor))
	(sleep 15)
	(print "CORTANA: 'Listen to this: Your haste has jeopardized the fulfillment of our Covenant -'")
	(print "'threatened our grand design. That you shall be spared a public display of our contempt...'")
	(print "'...is thanks only to Mercy and his wise counsel.'")
	(sleep (ai_play_line_on_object NONE 2160))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2160_cor))
	(print "CORTANA: 'Truth, Mercy, Regret. Three Prophet Hierarchs.'") 
	(print "'Killing Regret should shake-up the Covenant leadership, but, frankly'") 
	(print "'it sounds like you might be doing Truth a favor.'")
	(sleep (ai_play_line_on_object NONE 2170))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_2170_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

(script dormant elev_up_monitor
	(sleep_until (> (device_group_get elev_up_switch) 0))
	(device_set_power elev_up_switch_01 0)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_inside_elev_up (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(device_animate_position elev_up .103 10 1 1 FALSE)
	(sleep_until (= (device_get_position elev_up) .103))
	(if 
		(AND
			(= (volume_test_object vol_elev_shaft_up (player0)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(object_teleport (player0) 2to3_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player0) "") 
			)
	)
	(if 	
		(AND
			(= (volume_test_object vol_elev_shaft_up (player1)) FALSE)
			(> (player_count) 0)
			(= (game_is_cooperative) TRUE)
		)
			(begin
				(object_teleport (player1) 2to3_teleport)
				(effect_new_on_object_marker "effects\gameplay\coop_teleport" (player1) "") 
			)
	)
	(switch_bsp 4)

	(sleep_until (= (structure_bsp_index) 4))
	(device_animate_position elev_up 1 60 1 1 FALSE)

	;(object_clear_all_function_variables elev_up)
	(sleep_until (> (device_get_position elev_up) .134) 1)
	;(object_set_function_variable elev_up "splash_down" 1 1)
	(effect_new splashy splash_17)
	(effect_new splashy splash_18)
	(effect_new splashy splash_19)
	(effect_new splashy splash_20)
	(effect_new splashy splash_21)
	(effect_new splashy splash_22)
	(effect_new splashy splash_23)
	(effect_new splashy splash_24)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_impact_water "none" 1)	
	(object_destroy water_2to3a)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_up) .143) 1)
	(object_create_anew water_2to3a)
	;(object_clear_all_function_variables elev_up)
	(kill_volume_enable kill_no_riders_up)
	
	(wake music_05b_08_start)
	(sleep 60)
;	(ai_erase all_enemies)
	(wake elev_up_cortana_comment)
	
	(sleep_until
		(begin
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 5)
				(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 5)
				(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 5)
				(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 5)
				(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(sleep 5)
			(if (> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 4)) 5)
				(object_destroy (list_get (ai_actors all_allies) 4))
			)
			(sleep 5)
			(> (device_get_position elev_up) .7)
		)
	)
	
	(sleep_until (> (device_get_position elev_up) .889) 1)
	;(object_set_function_variable elev_up "splash_up" 1 1)
	(effect_new splashy splash_25)
	(effect_new splashy splash_26)
	(effect_new splashy splash_27)
	(effect_new splashy splash_28)
	(effect_new splashy splash_29)
	(effect_new splashy splash_30)
	(effect_new splashy splash_31)
	(effect_new splashy splash_32)
	(sound_impulse_start sound\ambience\device_machines\delta_sub\sub_water_in_out\sub_out_of_water "none" 1)	
	(object_destroy water_2to3b)
	(cam_shake)
	
	(sleep_until (> (device_get_position elev_up) .896) 1)
	(object_create_anew water_2to3b)
	;(object_clear_all_function_variables elev_up)
	(kill_volume_disable kill_no_riders_up)
)

;Overall script for sunken tunnel 2
(script dormant sunken_tunnel2_start
	(sleep_until (= (volume_test_objects vol_tunnel_02_entry (players)) TRUE))
	(ai_disposable sunken_chamber_enemies TRUE)
	(data_mine_set_mission_segment "05b_9_tunnel2")
	(ai_renew all_allies)
	(game_save)

	(objects_attach elev_up "switch" elev_up_switch_01 "")
	(device_group_change_only_once_more_set elev_up_switch TRUE)
	(sub2doors)
	(wake elev_up_monitor)
	
	(ai_place tunnel_02_elites_01 1)
	(ai_place tunnel_02_elites_02 1)
	(ai_set_active_camo tunnel_02_elites_01 1)
	(ai_set_active_camo tunnel_02_elites_02 1)
	(ai_set_orders all_allies tunnel_02_suppress)
	
	(wake music_05b_07_start)
	
;	(ai_place tunnel_02_buggers_01 3)
		
;	(sleep_until 
;		(OR
;			(= (volume_test_objects vol_tunnel_02_mid_01 (players)) TRUE)
;			(< (ai_living_count tunnel_02_enemies) 3)
;		)
;	)
;	(ai_place tunnel_02_buggers_02 3)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_tunnel_02_mid_01 (players)) TRUE)
			(> (ai_combat_status tunnel_02_enemies) ai_combat_status_idle)
			(< (ai_living_count tunnel_02_enemies) 1)
		)
	)
	(game_save)
	(ai_set_orders all_allies tunnel_02_allies)
	
	(ai_place tunnel_02_elites_04 (- 1 (+ (ai_living_count tunnel_02_elites_01) (ai_living_count tunnel_02_elites_02))))
	(ai_set_active_camo tunnel_02_elites_04 1)
	(ai_place tunnel_02_grunts 3)
	(ai_set_active_camo tunnel_02_grunts 1)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_tunnel_02_mid_02 (players)) TRUE)
			(< (ai_living_count tunnel_02_enemies) 1)
		)
	)
	(game_save)
	(ai_place tunnel_02_elites_03 1)
	(ai_set_active_camo tunnel_02_elites_03 1)
	
	(sleep_until (= (volume_test_objects vol_elev_up_dock (players)) TRUE))
	(game_save)
	(ai_set_orders all_allies tunnel_02_on_elev)
)


;-------------------------------------------------------------------------------
;Island Interior

(global boolean island_holo_trans FALSE)
(global boolean island_holo_chant TRUE)
(script dormant island_holo_looper
	(object_create_anew island_throne)
	(object_create_anew regret03)
	(objects_attach island_throne "driver" regret03 "")
	(ai_disregard regret03 TRUE)
	(sleep_until
		(begin
			(begin_random
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant1a" TRUE)
						(sleep (ai_play_line_on_object regret03 3000))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant2b" TRUE)
						(sleep (ai_play_line_on_object regret03 3001))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant2c" TRUE)
						(sleep (ai_play_line_on_object regret03 3002))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant3a" TRUE)
						(sleep (ai_play_line_on_object regret03 3003))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant3c" TRUE)
						(sleep (ai_play_line_on_object regret03 3004))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant5a" TRUE)
						(sleep (ai_play_line_on_object regret03 3005))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
				(if (= island_holo_trans FALSE)
					(begin
						(set island_holo_chant TRUE)
						(custom_animation regret03 objects\characters\prophet\prophet "regret_chant6a" TRUE)
						(sleep (ai_play_line_on_object regret03 3006))
						(sleep (random_range 240 480))
						(set island_holo_chant FALSE)
					)
				)
			)
			FALSE
		)
	)
)

;Cortana translates the prophet if you linger near him
(script dormant island_int_translate
	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_02 (players)) TRUE)
			(<= (ai_living_count island_int_enemies) 0)
		)
	)
	(sleep 150)
	(set island_holo_trans TRUE)
	(sleep_until
		(AND
			(= (volume_test_objects vol_island_int_02 (players)) TRUE)
			(= island_holo_chant FALSE)
		)
	)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "REGRET: 'Every member of the Covenant shall walk the path!'")
	(print "'None will be left behind when our Great Journey begins!'")
	(print "'That is the Prophets' age-old promise! And it shall be fulfilled!'")
	(custom_animation regret03 objects\characters\prophet\prophet "regret_l05_0160_por" TRUE)
	(sleep (ai_play_line_on_object regret03 0160))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0160_por))
	(sleep 30)
	(print "CORTANA: 'Great Journey? Doesn't he know what these rings do?'")
	(sleep (ai_play_line_on_object NONE 1130))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1130_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 240 480))
	(set island_holo_trans FALSE)
)

;Overall script for island interior
(script dormant island_interior_start
	(ai_disposable tunnel_02_enemies TRUE)
	(game_can_use_flashlights 0)
	(wake objective_sunken_clear)
	(wake objective_temple_set)

	(objects_attach gondola_02_a control_front gondola_02_switch_front "")
;	(objects_attach gondola_02_a control_back gondola_02_switch_back "")
	(objects_attach gondola_02_b control_front gondola_02_b_fake "")

	(device_group_change_only_once_more_set gondola_02_switch TRUE)
	(wake island_holo_looper)
	;(scenery_animation_start_loop island_int_prophet objects\characters\prophet\prophet "throne_d:any:idle")

	(data_mine_set_mission_segment "05b_10_island_interior")
	(ai_renew all_allies)
	(game_save)
	
	(ai_set_orders all_allies island_int_allies)
	
	(ai_place island_int_grunts 4)
	(sleep 1)
	(ai_place island_int_hg 2)
	(wake island_int_translate)
)


;-------------------------------------------------------------------------------
;Island Gully

;Pelican says this is the last heap of allies you're gonna get
(script dormant island_pelican_comment
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "PELICAN PILOT: 'This is my last run, Chief. I'm nearly out of fuel.'")
	(sleep (ai_play_line_on_object NONE 1140))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1140_nrl))
	(sleep 30)
	(print "'We've secured the first tower cluster, so I'll set down there.'")
	(sleep (ai_play_line_on_object NONE 1150))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1150_nrl))
	(sleep 30)
	(print "'Call when you're ready for evac.'")
	(sleep (ai_play_line_on_object NONE 1160))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1160_nrl))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(game_save)
)

;Pelican arrives as the player fights up out of the gully
(global boolean island_pelican_arrived FALSE)
(script command_script island_pelican_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by island_airspace/pel0 2)
	(cs_vehicle_boost TRUE)
	(cs_fly_by island_airspace/pel1 10)
	(cs_vehicle_boost FALSE)
	
	(cs_fly_by island_airspace/p2 5)
	(cs_vehicle_speed .5)
	(set island_pelican_arrived TRUE)
	;(cs_fly_to island_airspace/p3 5)
	;(cs_fly_to island_airspace/p3 1)
	;(cs_fly_to_and_face island_airspace/p4 island_airspace/pel3 1)

	;(cs_vehicle_speed .25)
	;(cs_fly_to_and_face island_airspace/pel3 island_airspace/p2 2)

	;(cs_fly_to island_airspace/pel3 1)
	
	(cs_fly_to island_airspace/p5 2)
	(cs_fly_to_and_face island_airspace/p6 island_airspace/p4 2)
	
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_pelican/pilot) "pelican_p")

	(sleep_until (< (ai_living_count island_pelican) 4))
	(sleep 60)

	(cs_fly_to_and_face island_airspace/p5 island_airspace/p3 10)
	(cs_fly_to_and_face island_airspace/p5 island_airspace/pel2 1)

	;(cs_fly_by island_airspace/p0 2)
	(cs_vehicle_speed 1)
	(cs_fly_by island_airspace/pel2 2)
	;(cs_fly_to island_airspace/pel4 2)
	(cs_vehicle_boost TRUE)
	(cs_fly_by island_airspace/pel6 10)
	(cs_vehicle_boost FALSE)
	(cs_fly_to island_airspace/pelx 20)
	(ai_erase island_pelican)
)

;Loads and launches the pelican
(script dormant island_pelican_arrives
	(ai_place island_pelican_allies (- 2 (ai_living_count allies_infantry)))
	(ai_place island_pelican)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location island_pelican/pilot) "pelican_p" (ai_actors island_pelican_allies))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location island_pelican/pilot) TRUE)

	(object_create_anew rack2)
	(objects_attach (ai_vehicle_get_from_starting_location island_pelican/pilot) "pelican_sc_01" rack2 "pin")
	(object_create_anew bomb07)
	(objects_attach rack2 "rack01" bomb07 "pin")
	(object_create_anew bomb08)
	(objects_attach rack2 "rack02" bomb08 "pin")
	(object_create_anew bomb09)
	(objects_attach rack2 "rack03" bomb09 "pin")
	(object_create_anew bomb10)
	(objects_attach rack2 "rack04" bomb10 "pin")
	(object_create_anew bomb11)
	(objects_attach rack2 "rack05" bomb11 "pin")
	(object_create_anew bomb12)
	(objects_attach rack2 "rack06" bomb12 "pin")

	(cs_run_command_script island_pelican/pilot island_pelican_path)
	(sleep 150)
	(wake island_pelican_comment)
	
	(sleep_until (= island_pelican_arrived TRUE))
	(sleep 120)
	(begin_random
		(begin
			(objects_detach rack2 bomb07)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb08)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb09)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb10)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb11)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb12)
			(sleep (random_range 2 10))
		)
	)
)
(script static void short_island_pel
	(ai_place island_pelican_allies (- 2 (ai_living_count allies_infantry)))
	(ai_place island_pelican)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location island_pelican/pilot) "pelican_p" (ai_actors island_pelican_allies))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location island_pelican/pilot) TRUE)

	(object_create_anew rack2)
	(objects_attach (ai_vehicle_get_from_starting_location island_pelican/pilot) "pelican_sc_01" rack2 "pin")
	(object_create_anew bomb07)
	(objects_attach rack2 "rack01" bomb07 "pin")
	(object_create_anew bomb08)
	(objects_attach rack2 "rack02" bomb08 "pin")
	(object_create_anew bomb09)
	(objects_attach rack2 "rack03" bomb09 "pin")
	(object_create_anew bomb10)
	(objects_attach rack2 "rack04" bomb10 "pin")
	(object_create_anew bomb11)
	(objects_attach rack2 "rack05" bomb11 "pin")
	(object_create_anew bomb12)
	(objects_attach rack2 "rack06" bomb12 "pin")

	(cs_run_command_script island_pelican/pilot island_pelican_path)
	(sleep 150)
	(wake island_pelican_comment)

	(sleep_until (= island_pelican_arrived TRUE))
	(sleep 90)
	(begin_random
		(begin
			(objects_detach rack2 bomb07)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb08)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb09)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb10)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb11)
			(sleep (random_range 2 10))
		)
		(begin
			(objects_detach rack2 bomb12)
			(sleep (random_range 2 10))
		)
	)
)

;Overall script for island exterior
(script dormant island_gully_start
	(sleep_until (= (volume_test_objects vol_island_int_exit (players)) TRUE))
	(ai_disposable island_int_enemies TRUE)
	(data_mine_set_mission_segment "05b_11_island_gully")
	(ai_renew all_allies)
	(game_save)

	(ai_set_orders all_allies island_low_allies)
	(ai_place island_gully_buggers_01 4)
	(sleep 1)
	(ai_place island_gully_elites_01 2)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_island_gully_ridge (players)) TRUE)
			(< (ai_living_count island_gully_enemies) 3)
		)
	)
	(game_save)

	(ai_place island_gully_jackals_01 (- 3 (ai_living_count island_gully_buggers_01)))
	(sleep 1)
	(ai_place island_gully_elites_02 (- 2 (ai_living_count island_gully_elites_01)))

;9/11	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_island_ext_start (players)) TRUE)
			(<= (ai_living_count island_gully_enemies) 3)
		)
	)
	(if 
		(AND
			(= (volume_test_objects vol_island_ext_start (players)) FALSE)
			(> (player_count) 0)		
		)
			(wake island_pelican_arrives)
	)
)


;-------------------------------------------------------------------------------
;Island Exterior

;9/12

;Cortana points out the second gondola
(script dormant gondola_02_cortana_reminder
	(sleep_until (= (volume_test_objects vol_gondola_02 (players)) TRUE) 30 3600)
	(if (= (volume_test_objects vol_gondola_02 (players)) TRUE)
		(sleep_forever)
	)
	(sleep_until 
		(OR
			(= (objects_can_see_object (players) gondola_02_a 30) TRUE)
			(= (volume_test_objects vol_gondola_02 (players)) TRUE)
		)
	)
	(if (= (volume_test_objects vol_gondola_02 (players)) TRUE)
		(sleep_forever)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'There. Another gondola. Looks like it leads straight to the main-temple.'")
			(sleep (ai_play_line_on_object NONE 1170))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1170_cor))
			(sleep 30)
			(print "'Not much further now...'")
			(sleep (ai_play_line_on_object NONE 1180))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1180_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
	
	(sleep_until (> (device_get_position gondola_02_a) 0) 30 1800)
	(if (> (device_get_position gondola_02_a) 0)
		(begin
			(activate_team_nav_point_object default player gondola_02_switch_front 0)
			(sleep_until (> (device_get_position gondola_02_a) 0))
			(deactivate_team_nav_point_object player gondola_02_switch_front)
		)
	)
)

(script dormant island_drop
	(object_set_phantom_power (ai_vehicle_get_from_starting_location island_phantom/pilot) TRUE)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_a01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_a02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_a03")
	(sleep 45)
	(ai_set_orders island_phantom_jackals island_ext_07)

	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_b01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_b02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_b03")
	(sleep 45)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_c01")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_c02")
	(sleep 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_c03")
	(sleep 60)
	(ai_set_orders island_phantom_elites island_ext_06)
	(ai_set_orders island_phantom_grunts island_ext_06)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location island_phantom/pilot) FALSE)
)

;Phantom flies in with reinforcements
(script command_script island_phantom_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by island_airspace/ph0 10)
	(cs_vehicle_boost FALSE)
	(cs_fly_by island_airspace/ph1 10)
	(cs_vehicle_speed .5)
	
	(if (< (ai_living_count island_all_enemies) 8)
		(ai_place island_phantom_elites (- 2 (+ (ai_living_count island_ext_elites_01) (ai_living_count island_ext_elites_02))))
	)
	(if (< (ai_living_count island_all_enemies) 8)
		(ai_place island_phantom_jackals (- 3 (+ (ai_living_count island_ext_js_01) (ai_living_count island_ext_js_02) (ai_living_count island_ext_js_03) (ai_living_count island_ext_js_04))))
	)
	(if (< (ai_living_count island_all_enemies) 8)
		(ai_place island_phantom_grunts (- 3 (+ (ai_living_count island_ext_grunts_01) (ai_living_count island_ext_grunts_02))))
	)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_c" (ai_actors island_phantom_elites))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p_a" (ai_actors island_phantom_jackals))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location island_phantom/pilot) "phantom_p" (ai_actors island_phantom_grunts))

	(cs_fly_to island_airspace/ph2 5)
	(cs_vehicle_speed .25)
	(wake island_drop)
	(cs_fly_to island_airspace/ph2 2)
	
	(sleep_until (< (ai_living_count island_phantom) 2))
	(sleep 60)
	
	(cs_fly_to_and_face island_airspace/ph1 island_airspace/ph0 2)
	(cs_vehicle_speed 1)
	(cs_fly_by island_airspace/ph0 10)
	(cs_vehicle_boost TRUE)
	(cs_fly_by island_airspace/phx 20)
	(ai_erase island_phantom)
)

;Loads and launches the phantom
(script dormant island_phantom_arrives
	(ai_place island_phantom)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location island_phantom/pilot) TRUE)
	(cs_run_command_script island_phantom/pilot island_phantom_path)
)
(script static void short_island_ph
	(ai_allegiance covenant prophet)
	(ai_place island_phantom)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location island_phantom/pilot) TRUE)
	(cs_run_command_script island_phantom/pilot island_phantom_path)
)

;Overall script for island exterior
(script dormant island_exterior_start
	(sleep_until (= (volume_test_objects vol_island_ext_start (players)) TRUE))
	(ai_disposable island_gully_enemies TRUE)
	(data_mine_set_mission_segment "05b_12_island_exterior")
	(ai_renew all_allies)
	(game_save)

	(ai_set_orders all_allies island_ext_allies)
	(ai_place temple_ent_turrets 2)
	(if (difficulty_legendary)
		(begin
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_elites_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_elites_02 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_02 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_03 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_04 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_02 1)
			)
		)
	)
	(if (difficulty_heroic)
		(begin
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_elites_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_elites_02 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_02 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_03 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_01 2)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_02 1)
			)
		)
	)
	(if (difficulty_normal)
		(begin
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_elites_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_01 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_js_03 1)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_01 2)
			)
			(if (< (ai_living_count island_all_enemies) 8)
				(ai_place island_ext_grunts_02 2)
			)
		)
	)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_island_ext_01 (players)) TRUE)
			(< (ai_living_count island_main_enemies) 3)
		)
	)
	(game_save)
	(wake island_phantom_arrives)
	(wake gondola_02_cortana_reminder)
	
	(sleep_until 
	;	(OR
			(= (volume_test_objects vol_near_gondola_02 (players)) TRUE)
	;		(< (ai_living_count island_main_enemies) 3)
	;	)
	)
	(game_save)

;9/11
	(object_dynamic_simulation_disable gondola_02_a TRUE)
	(object_dynamic_simulation_disable gondola_02_b TRUE)
	
	(if (< (ai_living_count island_all_enemies) 8)
		(ai_place near_gondola_02_jackals (- 2 (ai_living_count island_phantom_jackals)))
	)
	(if (< (ai_living_count island_all_enemies) 8)
		(ai_place near_gondola_02_grunts (- 3 (ai_living_count island_phantom_grunts)))
	)

	(sleep_until 
		(OR
			(<= (ai_living_count island_main_enemies) 0)
			(> (device_get_position gondola_02_a) 0)
		)
	)
	(game_save)
)

	;elite rangers
	;buggers


;-------------------------------------------------------------------------------
;Gondola Ride 2

;Miranda radios as the gondola is about to launch
(script dormant island_miranda_conversation
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "MIRANDA: 'How's it going, you two?'")
	(sleep (ai_play_line_on_object NONE 0170))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0170_mir))
	(sleep 30)
	(print "CORTANA: 'So far, so good. We're nearing the main-temple now.'")
	(sleep (ai_play_line_on_object NONE 0180))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0180_cor))
	(sleep 30)
	(print "MIRANDA: 'Roger that. I'm as close to the Library as I can get.'")
	(print "'There's some sort of barrier...we're trying to find a way around it.'")
	(print "'I'll keep you posted.'")
	(sleep (ai_play_line_on_object NONE 0190))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0190_mir))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(game_save)
	(wake music_05b_09_start)

;9/12

	(sleep 90)
	(ai_set_blind gondola_02_banshees FALSE)
)

;Allies commenting on the second gondola
(script command_script gondola_02_ally_comment
	(cs_switch ally01)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Great. We gotta ride another one of these death-traps?'")
	(cs_play_line 1190)

	(cs_switch ally02)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'If you forget about the Covenant and the fact that we're stuck...'")
	(print "'...on a freaky alien world…it's actually kinda fun.'")
	(cs_play_line 1200)
)

;Gets grunts into turrets
(script command_script temple_ent_turret_01
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location temple_ent_turrets/1))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script temple_ent_turret_02
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location temple_ent_turrets/2))
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

;Banshees boost away before cutscene
(script command_script banshee_retreat
	(cs_vehicle_boost TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_until (= (volume_test_objects vol_banshee_retreat (ai_actors gondola_02_banshees)) TRUE) 30 4000)
	(ai_erase gondola_02_banshees)
)

(script dormant gondola_02_nuke
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors island_all_enemies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors island_all_enemies) 0)) 30)
				)
					(object_destroy (list_get (ai_actors island_all_enemies) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors island_all_enemies) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors island_all_enemies) 1)) 30)
				)
					(object_destroy (list_get (ai_actors island_all_enemies) 1))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors island_all_enemies) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors island_all_enemies) 2)) 30)
				)
					(object_destroy (list_get (ai_actors island_all_enemies) 2))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 5)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 30)
				)
					(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 5)
			(> (device_get_position gondola_02_a) .75)
		)
	)
)

(global real gondola_02_wake_state 0)
(script dormant gondola_02_wake
	(sleep_until
		(begin
			(if 
				(AND
					(> (device_get_position gondola_02_a) .37)
					(< (device_get_position gondola_02_a) .59)
					(> (device_get_position gondola_02_a) gondola_02_wake_state)
				)
					(begin
						(object_clear_function_variable gondola_02_a "wake_forward")
						(object_clear_function_variable gondola_02_a "wake_backward")
						(object_set_function_variable gondola_02_a "wake_backward" 1 1)
						(object_clear_function_variable gondola_02_b "wake_forward")
						(object_clear_function_variable gondola_02_b "wake_backward")
						(object_set_function_variable gondola_02_b "wake_backward" 1 1)
					)
			)
			(if 
				(AND
					(> (device_get_position gondola_02_a) .37)
					(< (device_get_position gondola_02_a) .59)
					(< (device_get_position gondola_02_a) gondola_02_wake_state)
				)
					(begin
						(object_clear_function_variable gondola_02_a "wake_forward")
						(object_clear_function_variable gondola_02_a "wake_backward")
						(object_set_function_variable gondola_02_a "wake_forward" 1 1)
						(object_clear_function_variable gondola_02_b "wake_forward")
						(object_clear_function_variable gondola_02_b "wake_backward")
						(object_set_function_variable gondola_02_b "wake_forward" 1 1)
					)
			)
			(if 
				(OR
					(= (device_get_position gondola_02_a) gondola_02_wake_state)
					(< (device_get_position gondola_02_a) .37)
					(> (device_get_position gondola_02_a) .59)
				)
					(begin
						(object_clear_function_variable gondola_02_a "wake_forward")
						(object_clear_function_variable gondola_02_a "wake_backward")
						(object_clear_function_variable gondola_02_b "wake_forward")
						(object_clear_function_variable gondola_02_b "wake_backward")
					)
			)
			(set gondola_02_wake_state (device_get_position gondola_02_a))
			(= (device_get_position gondola_02_a) 1)
		)
	)
)

(global real gondola_02_state 0)
(script dormant gondola_02_restarter
	(sleep_until 
		(begin
			(set gondola_02_state (device_get_position gondola_02_a))
			(if 
				(AND
					(= (volume_test_objects_all vol_gondola_02_mid (players)) TRUE)
					(> (player_count) 0)
				)
					(begin
						(device_set_position gondola_02_a 0)
						(device_set_position gondola_02_b 0)			
					)
					(begin
						(device_set_position gondola_02_a gondola_02_state)
						(device_set_position gondola_02_b gondola_02_state)			
					)
			)
			(> (device_get_position gondola_02_a) .6)
		)
	)
)
(script dormant gondola_02_reverser
	(sleep_until 
		(begin
			;(set gondola_02_state (device_get_position gondola_02_a))
			(if 
				(AND
					(= (volume_test_objects_all vol_gondola_02_mid (players)) TRUE)
					(> (player_count) 0)
				)
					(begin
						(device_set_position gondola_02_a 1)
						(device_set_position gondola_02_b 1)			
					)
					(begin
						(device_set_position gondola_02_a .54)
						(device_set_position gondola_02_b .54)			
					)
			)
			(> (device_get_position gondola_02_a) .6)
		)
	)
)

;Boost banshees into combat
(script command_script boost_test
	(cs_vehicle_boost TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 30))
)

;jetpack elites boost_to_temple
(script command_script boost_to_temple_01
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
;	(cs_enable_targeting TRUE)
;	(cs_shoot TRUE)
;	(cs_fly_to temple/p1)
	(sleep_forever)
)
(script command_script boost_to_temple_02
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
;	(cs_enable_targeting TRUE)
;	(cs_shoot TRUE)
;	(cs_fly_to temple/p2)
	(sleep_forever)
)

;they flee!
(script command_script panic
	(cs_enable_moving TRUE)
	(cs_movement_mode 3)
	(sleep_forever)
)

;Overall script for second gondola ride
(script dormant gondola_02_start
	(sleep_until (= (volume_test_objects vol_near_gondola_02 (players)) TRUE))
	(ai_disposable island_all_enemies TRUE)

	(sleep_until 
		(OR
			(> (device_group_get gondola_02_switch) 0)
			(< (ai_living_count island_main_enemies) 1)
		)
	)
	(if (> (device_group_get gondola_02_switch) 0)
		(begin
			(ai_set_orders all_allies gondola_02_allies)
			;(ai_scene gondola_02_ally_scene gondola_02_ally_comment all_allies)
		)
		(begin
			(sleep 60)
			(ai_set_orders all_allies gondola_02_allies)
			(ai_scene gondola_02_ally_scene gondola_02_ally_comment all_allies)		
		)
	)

	(data_mine_set_mission_segment "05b_13_gondola_02")
	(ai_renew all_allies)

	(sleep_until (> (device_group_get gondola_02_switch) 0))
	(device_set_power gondola_02_switch_front 0)
;	(device_set_power gondola_02_switch_back 0)
	(wake gondola_02_wake)

;9/11
	(object_dynamic_simulation_disable gondola_02_a FALSE)
	(object_dynamic_simulation_disable gondola_02_b FALSE)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_gondola_02 (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(device_set_position gondola_02_launch_a 1)
	(device_set_position gondola_02_launch_b 1)
	(device_set_position gondola_02_a .54)
	(device_set_position gondola_02_b .54)

	(wake island_miranda_conversation)

	(sleep 300)
	(ai_place gondola_02_banshees 2)
	(cs_run_command_script gondola_02_banshees boost_test)

;9/12

	(sleep_until (>= (device_get_position gondola_02_a) .25))
	(if (difficulty_legendary)
		(ai_place gondola_02_grunts 4)
	)
	(ai_place gondola_02_jetpacks 2)
	
	(sleep_until (>= (device_get_position gondola_02_a) .43))
	(game_save)
	(wake gondola_02_nuke)
	(ai_set_orders gondola_02_jetpacks gondola_02_jets)

	(sleep_until (= (device_get_position gondola_02_a) .54))
;9/11
	(object_dynamic_simulation_disable gondola_02_a TRUE)
	(object_dynamic_simulation_disable gondola_02_b TRUE)

	(sleep_until (< (+ (ai_living_count gondola_02_grunts) (ai_living_count gondola_02_jetpacks)) 1) 30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" gondola_02_enemies) TRUE) 30 1800)
	(game_save)
;9/11
	(object_dynamic_simulation_disable gondola_02_a FALSE)
	(object_dynamic_simulation_disable gondola_02_b FALSE)
	(wake music_05b_09_start_alt)
	(wake gondola_02_reverser)
	
	(sleep_until (> (device_get_position gondola_02_a) .75))
	(ai_set_orders gondola_02_banshees airspace_island)
	(cs_run_command_script gondola_02_banshees banshee_retreat)
	(ai_place temple_ent_grunts 4)
	(cs_run_command_script temple_ent_grunts/1 temple_ent_turret_01)
	(cs_run_command_script temple_ent_grunts/2 temple_ent_turret_02)
	(ai_place temple_ent_jackals 2)

	(sleep_until (> (device_get_position gondola_02_a) .9))
	(ai_set_orders gondola_02_jetpacks jetpacks_temple)
	(cs_run_command_script gondola_02_jetpacks/1 boost_to_temple_01)
	(cs_run_command_script gondola_02_jetpacks/2 boost_to_temple_01)

	(sleep_until (= (device_get_position gondola_02_a) 1))

;9/11
	(object_dynamic_simulation_disable gondola_02_a TRUE)
	(object_dynamic_simulation_disable gondola_02_b TRUE)

	(game_save)
	(ai_vehicle_exit temple_ent_turrets) 
	(ai_set_orders temple_ent_grunts temple_ent_retreat)
	(ai_set_orders temple_ent_jackals temple_ent_retreat)
	(device_set_position gondola_02_launch_a 0)
	(device_set_position gondola_02_launch_b 0)
	(cs_run_command_script temple_ent_grunts panic)
	(sleep 60)
	(cs_run_command_script temple_ent_jackals panic)
)


;-------------------------------------------------------------------------------
;Temple Entry

(script command_script temple_hunker
	(cs_crouch TRUE)
	(sleep_forever)
)

;Ally comments on high charity's arrival
(script command_script high_charity_ally_comment
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(print "ALLY: 'Damn! Look at the size of that thing!'")
	(cs_play_line 1210)
)

;Cortana reminds the Chief to get his ass inside
(script dormant temple_ent_cortana_reminder
	(sleep_until (= (volume_test_objects vol_temple_entry (players)) TRUE) 30 1800)
	(if (= (volume_test_objects vol_temple_entry (players)) FALSE)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep_until (= (volume_test_objects vol_temple_entry (players)) TRUE) 30 60)
			(if (= (volume_test_objects vol_temple_entry (players)) FALSE)
				(begin
					(print "CORTANA: 'There's no time, Chief! Get inside and take care of the Prophet!'")
					(sleep (ai_play_line_on_object NONE 1220))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1220_cor))
				)
			)
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

(script command_script temple_deploy_l
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to temple_turrets/deploy_left)
	(cs_deploy_turret temple_turrets/left)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script temple_deploy_r
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to temple_turrets/deploy_right)
	(cs_deploy_turret temple_turrets/right)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

;Overall script for temple entry area
(script dormant temple_entry_start
	(sleep_until
		(OR
			(< (ai_living_count temple_entry_enemies) 1)
			(= (volume_test_objects vol_temple_ent_cutscene (players)) TRUE)
		)
	5)
	(ai_disposable gondola_02_enemies TRUE)

	(wake music_05b_09_stop)

	(cinematic_fade_to_white)	

	(object_teleport (player0) player0_hide_bsp3)
	(object_teleport (player1) player1_hide_bsp3)
	
	(cs_run_command_script all_allies temple_hunker)
			
	;(ai_erase_all)

	(if (cinematic_skip_start)
		(begin
			(c05_intra2)
		)
	)
	(cinematic_skip_stop)
	
	(sleep 2)
	(object_teleport (player0) temple_ext_player0)
	(object_teleport (player1) temple_ext_player1)
	
	(object_create_anew fleet01)
	(object_create_anew fleet02)
	(object_create_anew fleet_high_char)

	(cs_run_command_script temple_ent_grunts abort)
	(cs_run_command_script temple_ent_jackals abort)
	(cs_run_command_script gondola_02_jetpacks abort)
	(cs_run_command_script all_allies abort)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(wake 05b_title2)
	(wake objective_temple_clear)
	(wake objective_regret_set)	
	
	(data_mine_set_mission_segment "05b_14_temple_exterior")
	(ai_renew all_allies)
	(game_save_immediate)
	
	(sleep 30)
	(ai_set_orders all_allies temple_ent_allies)
	(ai_scene temple_ent_ally_scene high_charity_ally_comment all_allies)
	(wake temple_ent_cortana_reminder)
	
	(if (difficulty_legendary)
		(begin
			(ai_place temple_heavies 2)
			(begin_random
				(cs_run_command_script temple_heavies/left temple_deploy_l)
				(cs_run_command_script temple_heavies/right temple_deploy_r)
			)
		)
		(begin
			(ai_place temple_heavies 1)
			(begin_random
				(cs_run_command_script temple_heavies temple_deploy_l)
				(cs_run_command_script temple_heavies temple_deploy_r)
			)
		)
	)
	(sleep 90)
	(if (difficulty_legendary)
		(ai_place temple_halls_jackals_01 (- 2 (ai_living_count temple_ent_jackals)))
		(ai_place temple_halls_jackals_01 (- 3 (ai_living_count temple_ent_jackals)))
	)
	(if (difficulty_legendary)
		(ai_place temple_halls_elites_01 (- 2 (ai_living_count gondola_02_jetpacks)))
		(ai_place temple_halls_elites_01 (- 1 (ai_living_count gondola_02_jetpacks)))
	)
)


;-------------------------------------------------------------------------------
;Temple Halls

(global boolean bossfight_chatter TRUE)

;Cortana warns of impending doom
(script dormant temple_cortana_warn_02
	(sleep_until (= bossfight_chatter TRUE))
	(set bossfight_chatter FALSE)
	(game_save_cancel)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'The Covenant fleet has launched multiple waves of reinforcements!'")
	(print "'Too many for me to track! We don't have much time!'")
	(sleep (ai_play_line_on_object NONE 0210))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0210_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set bossfight_chatter TRUE)
	(game_save_no_timeout)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
)

;Overall script for temple halls
(script dormant temple_foyer_start
	(sleep_until (= (volume_test_objects vol_temple_entry (players)) TRUE))
	(data_mine_set_mission_segment "05b_15_temple_halls")
	(ai_renew all_allies)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)
	(ai_set_orders all_allies temple_halls_allies)
	
	(sleep_until (< (ai_living_count temple_entry_enemies) 3) 30 60)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)
	(if (= (volume_test_objects vol_temple_left (players)) TRUE)
		(begin
			(ai_place temple_halls_jackals_02L (- 4 (ai_living_count temple_halls_jackals_01)))
		)
	)
	(if (= (volume_test_objects vol_temple_right (players)) TRUE)
		(begin
			(ai_place temple_halls_jackals_02R (- 4 (+ (ai_living_count temple_halls_jackals_02L) (ai_living_count temple_halls_jackals_01))))
		)
	)

	(sleep_until
	;	(OR
	;		(< (ai_living_count temple_entry_enemies) 3)
			(= (volume_test_objects vol_temple_foyer (players)) TRUE)
	;	)
	)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)
	(ai_place temple_halls_elites_02 2)
	(wake temple_cortana_warn_02)
)


;-------------------------------------------------------------------------------
;Prophet Boss Fight

;Tells when regret is dead
(global boolean regret_dead FALSE)

;9/11

;Cortana points out the prophet
(script dormant temple_cortana_warn_01
	(sleep_until 
		(AND
			(< (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 15)
			(= (objects_can_see_object (players) (list_get (ai_actors regret) 0) 30) TRUE)
		)
	)
	(sleep_until (= bossfight_chatter TRUE))
	(if (= regret_dead FALSE)
		(begin
			(set bossfight_chatter FALSE)
			(game_save_cancel)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(if (= regret_dead FALSE)
				(begin
					(print "CORTANA: 'There's the target! Take him out!'")
					(sleep (ai_play_line_on_object NONE 0200))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0200_cor))
				)
			)
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(set bossfight_chatter TRUE)
;			(if
;				(AND
;					(= bossfight_chatter TRUE)
;					(= (game_safe_to_save) TRUE)
;				)
;					(game_save_immediate)
;			)
			(game_save_no_timeout)
		)
	)
)

;how many times has regret died?
(global short regret_times_dead 0)

;Now she has even worse news
(script dormant temple_cortana_warn_03
	(sleep_until 
		(OR
			(= regret_dead TRUE)
			(> regret_times_dead 0)
		)		
	30 5100)
	(if (= regret_dead FALSE)
		(begin
			(sleep_until (= bossfight_chatter TRUE))
			(set bossfight_chatter FALSE)
			(game_save_cancel)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "CORTANA: 'Bad news. The reinforcements are turning around -'")
			(print "'the fleet is preparing to fire on our position! We need to get out of here!'")
			(sleep (ai_play_line_on_object NONE 0220))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0220_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(set bossfight_chatter TRUE)
;			(if
;				(AND
;					(= bossfight_chatter TRUE)
;					(= (game_safe_to_save) TRUE)
;				)
;					(game_save_immediate)
;			)
			(game_save_no_timeout)
		)
	)
)

;Reminder in case the player takes forever to leave
(script dormant temple_cortana_reminder
	(sleep_until (= bossfight_chatter TRUE))
	(set bossfight_chatter FALSE)
	(game_save_cancel)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Go! Back out the way we came in!'")
	(sleep (ai_play_line_on_object NONE 1370))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1370_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set bossfight_chatter TRUE)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)
)

;9/11

;Boss fight hints
(script dormant regret_hint_01
	(sleep_until (= bossfight_chatter TRUE))
	(if (= regret_dead FALSE)
		(begin
			(set bossfight_chatter FALSE)
			(ai_dialogue_enable FALSE)
			(sleep_until (game_safe_to_save) 30 600)
			(game_save_cancel)
			(if (= regret_dead FALSE)
				(begin
					(print "CORTANA: 'His throne is shielded!  It's deflecting everything you throw at it!'")
					(sleep (ai_play_line_on_object NONE 1230))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1230_cor))
					(sleep 15)
					(print "CORTANA: 'Get in close, and do whatever you can!'")
					(sleep (ai_play_line_on_object NONE 1240))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1240_cor))
				)
			)
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(set bossfight_chatter TRUE)
;			(if
;				(AND
;					(= bossfight_chatter TRUE)
;					(= (game_safe_to_save) TRUE)
;				)
;					(game_save_immediate)
;			)
			(game_save_no_timeout)
		)
	)
)
(script dormant regret_hint_02
	(sleep_until (= bossfight_chatter TRUE))
	(if (= regret_dead FALSE)
		(begin
			(set bossfight_chatter FALSE)
			(ai_dialogue_enable FALSE)
			(sleep_until (game_safe_to_save) 30 600)
			(game_save_cancel)
			(if (= regret_dead FALSE)
				(begin
					(print "CORTANA: 'You've got to get him out of that throne!'")
					(sleep (ai_play_line_on_object NONE 1250))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1250_cor))
				)
			)
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(set bossfight_chatter TRUE)
;			(if
;				(AND
;					(= bossfight_chatter TRUE)
;					(= (game_safe_to_save) TRUE)
;				)
;					(game_save_immediate)
;			)
			(game_save_no_timeout)
		)
	)
)
(script dormant regret_hint_03
	(sleep_until (= bossfight_chatter TRUE))
	(if (= regret_dead FALSE)
		(begin
			(set bossfight_chatter FALSE)
			(ai_dialogue_enable FALSE)
			(sleep_until (game_safe_to_save) 30 600)
			(game_save_cancel)
			(if (= regret_dead FALSE)
				(begin
					(print "CORTANA: 'Quick! Board his throne!'")
					(sleep (ai_play_line_on_object NONE 1290))
					;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1290_cor))
				)
			)
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(set bossfight_chatter TRUE)
;			(if
;				(AND
;					(= bossfight_chatter TRUE)
;					(= (game_safe_to_save) TRUE)
;				)
;					(game_save_immediate)
;			)
			(game_save_no_timeout)
		)
	)
)
(script dormant regret_teleport_comment
	(sleep_until (= bossfight_chatter TRUE))
	(set bossfight_chatter FALSE)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Phased spatial relocation! The same technology the Monitor used on the first Halo.'") 
	(print "'Seems the Prophets save the best toys for themselves…'")
	(sleep (ai_play_line_on_object NONE 1260))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1260_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set bossfight_chatter TRUE)
)
(script dormant regret_beam_comment
	(sleep_until (>= (ai_combat_status regret) ai_combat_status_clear_los))
	(sleep_until (= bossfight_chatter TRUE))
	(set bossfight_chatter FALSE)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "CORTANA: 'Keep clear of that beam! I don't think you'll survive a direct hit!'")
	(sleep (ai_play_line_on_object NONE 1270))
	;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1270_cor))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set bossfight_chatter TRUE)
)
(script dormant regret_hg_comment
	(sleep_until (>= (ai_combat_status temple_hg_init) ai_combat_status_clear_los))
	(sleep_until (= bossfight_chatter TRUE))
	(set bossfight_chatter FALSE)
	(game_save_cancel)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(if (= regret_dead FALSE)
		(begin
			(print "CORTANA: 'There are Honor-Guards all over this place!  Watch your back!'")
			(sleep (ai_play_line_on_object NONE 1280))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_1280_cor))
		)
	)
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(set bossfight_chatter TRUE)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)
)

;regret's mission dialogue
(script static void regret_taunt_01
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'Warriors! Attack! The demon must die!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:point" TRUE)
	(sleep (ai_play_line regret 1300))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_02
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'You dare to interrupt my sermon?!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:cheer" TRUE)
	(sleep (ai_play_line regret 1310))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_03
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'The Great Journey will not be postponed!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:cheer" TRUE)
	(sleep (ai_play_line regret 1320))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_04
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'Guards! Remove this vermin from my sight!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:point" TRUE)
	(sleep (ai_play_line regret 1330))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_05
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'Human filth! You befoul this holy place!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:taunt" TRUE)
	(sleep (ai_play_line regret 1340))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_06
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'Incompetents! I'll kill it myself!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:taunt" TRUE)
	(sleep (ai_play_line regret 1350))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script static void regret_taunt_07
	(sleep_until 
		(AND
			(= bossfight_chatter TRUE)
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
		)
	)
	(set bossfight_chatter FALSE)
	(print "REGRET: 'Your very existence offends me, Demon!'")
	(custom_animation (unit (ai_get_object regret)) objects\characters\prophet\prophet "combat:any:any:cheer" TRUE)
	(sleep (ai_play_line regret 1360))
	(set bossfight_chatter TRUE)
	(sleep (random_range 300 600))
)
(script dormant regret_taunts
	(begin_random
		(regret_taunt_01)
		(regret_taunt_02)
		(regret_taunt_03)
		(regret_taunt_04)
		(regret_taunt_05)
		(regret_taunt_06)
		(regret_taunt_07)
	)
)

;respawns grunts
(script dormant temple_grunt_spawner
	(sleep_until
		(begin
			(begin_random
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_L_01) 5)
						(= (objects_can_see_flag (players) temple_L_01 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_L/01)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_L_02) 5)
						(= (objects_can_see_flag (players) temple_L_02 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_L/02)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_L_03) 5)
						(= (objects_can_see_flag (players) temple_L_03 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_L/03)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_L_04) 5)
						(= (objects_can_see_flag (players) temple_L_04 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_L/04)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_L_05) 5)
						(= (objects_can_see_flag (players) temple_L_05 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_L/05)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_R_01) 5)
						(= (objects_can_see_flag (players) temple_R_01 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_R/01)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_R_02) 5)
						(= (objects_can_see_flag (players) temple_R_02 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_R/02)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_R_03) 5)
						(= (objects_can_see_flag (players) temple_R_03 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_R/03)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_R_04) 5)
						(= (objects_can_see_flag (players) temple_R_04 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_R/04)
							(sleep (random_range 120 240))
						)
				)
				(if
					(AND
						(< (ai_living_count temple_honor_grunts) 2)
						(> (objects_distance_to_flag (players) temple_R_05) 5)
						(= (objects_can_see_flag (players) temple_R_05 45) FALSE)
					)
						(begin
							(ai_place honor_grunts_new_R/05)
							(sleep (random_range 120 240))
						)
				)			
			)
			(sleep_until 
				(OR 
					(= (ai_vitality_pinned regret) TRUE)
					(= regret_dead TRUE)
					(< (ai_living_count temple_honor_grunts) 2)
				)
			)
			(= regret_dead TRUE)
		)
	)
)

;How many honor guards to have at once
(global short hg_count 2)

;delay between waves of honor guards
(global short hg_delay 600)

;Respawns honor guards over the course of the encounter
(script dormant temple_hg_respawner
	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_living_count temple_hg) hg_count)
						(= (device_get_position temple_spawndoor_01R) 0)
						(= (volume_test_objects vol_temple_spawnroom_01R (players)) FALSE)
						(> (player_count) 0)				
					)
						(begin
							(ai_place temple_hg_01R 1)
							(sleep (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_living_count temple_hg) hg_count)
						(= (device_get_position temple_spawndoor_01L) 0)
						(= (volume_test_objects vol_temple_spawnroom_01L (players)) FALSE)
						(> (player_count) 0)				
					)
						(begin
							(ai_place temple_hg_01L 1)
							(sleep (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_living_count temple_hg) hg_count)
						(= (device_get_position temple_spawndoor_02R) 0)
						(= (volume_test_objects vol_temple_spawnroom_02R (players)) FALSE)
						(> (player_count) 0)				
					)
						(begin
							(ai_place temple_hg_02R 1)
							(sleep (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_living_count temple_hg) hg_count)
						(= (device_get_position temple_spawndoor_02L) 0)
						(= (volume_test_objects vol_temple_spawnroom_02L (players)) FALSE)
						(> (player_count) 0)				
					)
						(begin
							(ai_place temple_hg_02L 1)
							(sleep (random_range 60 120))
						)
				)
			)
			(sleep_until 
				(OR 
					(= (ai_vitality_pinned regret) TRUE)
					(= regret_dead TRUE)
					(< (ai_living_count temple_hg) 1)
				)
			)
			(sleep_until 
				(OR 
					(= (ai_vitality_pinned regret) TRUE)
					(= regret_dead TRUE)
				)
			30 (/ hg_delay (+ regret_times_dead 1)))
;			(if (= (ai_vitality_pinned regret) TRUE)
;				(set hg_delay (/ hg_delay (+ regret_times_dead 1)))
;			)
			(= regret_dead TRUE)
		)
	)
)

;Respawns regret to fake teleporting
(global object regret_corpse none)
(global object regret_throne none)
(global effect regret_teleport "effects\gameplay\regret_teleport")
(global effect regret_blood "effects\contact\collision\blood_aoe\blood_aoe_human")

(script dormant regret_respawner
	(sleep_until
		(begin
			(sleep_until (= (ai_vitality_pinned regret) TRUE))
			(effect_new_on_object_marker regret_teleport regret_corpse "body") 
			;(object_cannot_take_damage (ai_actors regret))
			;(player_enable_input FALSE)
			;(unit_set_enterable_by_player (ai_vehicle_get regret) FALSE)
			(unit_exit_vehicle (player0) 1)
			(unit_exit_vehicle (player1) 1)
			(sleep_until 
				(AND
					(= (unit_in_vehicle (player0)) FALSE)
					(= (unit_in_vehicle (player1)) FALSE)
				)
			)
			;(player_enable_input TRUE)
			;(effect_new_on_object_marker regret_teleport regret_corpse "body") 
			(object_destroy regret_corpse)
			(object_destroy regret_throne)
			(sleep 60)
			(ai_place regret 1)
			(ai_cannot_die regret TRUE)
			;(object_can_take_damage (ai_actors regret))
			(set regret_corpse (list_get (ai_actors regret) 0))
			(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
			(effect_new_on_object_marker regret_teleport regret_corpse "body") 
			(object_set_function_variable regret_throne "effects" 1 1)
			;(unit_set_enterable_by_player (ai_vehicle_get regret) TRUE)
			(set regret_times_dead (+ regret_times_dead 1))
			(= regret_times_dead 4)
		)
	)
)

(script command_script reserve_throne
	(sleep 2)
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(sleep 2)
)
(script command_script regret_pause
	(cs_abort_on_damage TRUE)
	(sleep_until
		(AND
			(= (volume_test_objects vol_temple_02 (players)) TRUE)
			(OR
				(= (objects_can_see_object (ai_actors regret) (player0) 45) TRUE)
				(= (objects_can_see_object (ai_actors regret) (player1) 45) TRUE)
			)
		)
	)
)

(global short regret_lives 0)
(script dormant regret_retreat
	(if (difficulty_legendary)
		(set regret_lives 4)
	)
	(if (difficulty_heroic)
		(set regret_lives 2)
	)
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5))
			(sleep_until 
				(OR
					(= (unit_in_vehicle (player0)) TRUE)
					(= (unit_in_vehicle (player1)) TRUE)
					(> (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5)
				)
			30 150)
			
			(if 
				(OR
					(= (unit_in_vehicle (player0)) TRUE)
					(= (unit_in_vehicle (player1)) TRUE)
				)
					(begin
						(sleep_until (= (ai_vitality_pinned regret) TRUE) 30 150)
						(if (= (ai_vitality_pinned regret) FALSE)
							(begin
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(sleep 30)
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								(sleep_until 
									(AND
										(= (unit_in_vehicle (player0)) FALSE)
										(= (unit_in_vehicle (player1)) FALSE)
									)
								)
								(object_destroy regret_corpse)
								(object_destroy regret_throne)
								(sleep 60)
								(ai_place regret 1)
								(ai_cannot_die regret TRUE)
								(if 
									(OR
										(= regret_times_dead 1)
										(= regret_times_dead 2)
									)
										(ai_set_orders regret regret_02)
								)
								(if (> regret_times_dead 2)
									(ai_set_orders regret regret_03)
								)
								(set regret_corpse (list_get (ai_actors regret) 0))
								(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(object_set_function_variable regret_throne "effects" 1 1)
								(unit_set_enterable_by_player (unit regret_throne) TRUE)
							)
							(begin
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(sleep 30)
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								(sleep_until 
									(AND
										(= (unit_in_vehicle (player0)) FALSE)
										(= (unit_in_vehicle (player1)) FALSE)
									)
								)
								(object_destroy regret_corpse)
								(object_destroy regret_throne)
								(sleep 60)
								(game_save)
								(ai_place regret 1)
								(ai_cannot_die regret TRUE)
								(if 
									(OR
										(= regret_times_dead 1)
										(= regret_times_dead 2)
									)
										(ai_set_orders regret regret_02)
								)
								(if (> regret_times_dead 2)
									(ai_set_orders regret regret_03)
								)
								(set regret_corpse (list_get (ai_actors regret) 0))
								(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
								(effect_new_on_object_marker regret_teleport regret_corpse "body") 
								(object_set_function_variable regret_throne "effects" 1 1)
								(set regret_times_dead (+ regret_times_dead 1))
								(unit_set_enterable_by_player (unit regret_throne) TRUE)
							)
						)
					)
					(begin
						(if (< (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5)
							(begin
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(sleep 30)
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								(sleep_until 
									(AND
										(= (unit_in_vehicle (player0)) FALSE)
										(= (unit_in_vehicle (player1)) FALSE)
									)
								)
								(object_destroy regret_corpse)
								(object_destroy regret_throne)
								(sleep 60)
								(ai_place regret 1)
								(ai_cannot_die regret TRUE)
								(if 
									(OR
										(= regret_times_dead 1)
										(= regret_times_dead 2)
									)
										(ai_set_orders regret regret_02)
								)
								(if (> regret_times_dead 2)
									(ai_set_orders regret regret_03)
								)
								(set regret_corpse (list_get (ai_actors regret) 0))
								(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(object_set_function_variable regret_throne "effects" 1 1)
								(unit_set_enterable_by_player (unit regret_throne) TRUE)
							)
							(begin
								(print "do nothing")
							)
						)
					)
			)
			(= regret_times_dead regret_lives)
		)
	)
)
(script dormant regret_death
	(object_create_anew fake_corpse)
	(sleep 2)
	(object_cannot_take_damage fake_corpse)
	(object_hide fake_corpse TRUE)
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5))
			(sleep_until 
				(OR
					(= (unit_in_vehicle (player0)) TRUE)
					(= (unit_in_vehicle (player1)) TRUE)
					(> (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5)
				)
			30 150)
			
			(if 
				(OR
					(= (unit_in_vehicle (player0)) TRUE)
					(= (unit_in_vehicle (player1)) TRUE)
				)
					(begin
						(sleep_until (= (ai_vitality_pinned regret) TRUE) 30 150)
						(if (= (ai_vitality_pinned regret) FALSE)
							(begin
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(sleep 30)
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								(sleep_until 
									(AND
										(= (unit_in_vehicle (player0)) FALSE)
										(= (unit_in_vehicle (player1)) FALSE)
									)
								)
								(object_destroy regret_corpse)
								(object_destroy regret_throne)
								(sleep 60)
								(ai_place regret 1)
								(ai_cannot_die regret TRUE)
								(cs_run_command_script regret reserve_throne)
								(if 
									(OR
										(= regret_times_dead 1)
										(= regret_times_dead 2)
									)
										(ai_set_orders regret regret_02)
								)
								(if (> regret_times_dead 2)
									(ai_set_orders regret regret_03)
								)
								(set regret_corpse (list_get (ai_actors regret) 0))
								(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(object_set_function_variable regret_throne "effects" 1 1)
								(unit_set_enterable_by_player (unit regret_throne) TRUE)
							)
							(begin
								(set regret_dead TRUE)
								(objects_attach regret_throne "driver" fake_corpse "")
								(sleep 2)
							;	(object_cannot_take_damage fake_corpse)
								(object_hide fake_corpse FALSE)
								(object_hide regret_corpse TRUE)
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(custom_animation_loop fake_corpse objects\characters\prophet\prophet "throne_d:dead" TRUE)
;								(effect_new_on_object_marker "effects\objects\characters\prophet\regret_death" regret_throne "")
								(ai_play_line_on_object fake_corpse 1380)
								(sleep 60)
								(effect_new_on_object_marker "effects\objects\characters\prophet\regret_death" fake_corpse "body")
								(effect_new_on_object_marker "effects\objects\characters\prophet\regret_death" regret_throne "")
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								
								(ai_cannot_die regret FALSE)
								(object_hide regret_corpse TRUE)
								(ai_kill regret)
								(sleep 1)
								(object_hide regret_corpse TRUE)
								;(objects_detach regret_throne regret_corpse)
								;(object_destroy regret_corpse)
								;(sleep 30)
								(object_clear_all_function_variables regret_throne)
								;(sleep 30)
;								(set regret_dead TRUE)
								
								(sleep 150)
								(sound_impulse_start sound\vehicles\damage_effects\cov_damage_large regret_throne 1)
								
					;			(sleep_until
					;				(begin
					;					(effect_new_on_object_marker regret_blood regret_throne "")
					;					(sleep (random_range 1 10))
					;					FALSE
					;				)
					;			)
							)
						)
					)
					(begin
						(if (< (objects_distance_to_object (players) (list_get (ai_actors regret) 0)) 5)
							(begin
								(unit_set_enterable_by_player (unit regret_throne) FALSE)
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(sleep 30)
								(unit_exit_vehicle (player0) 1)
								(unit_exit_vehicle (player1) 1)
								(sleep_until 
									(AND
										(= (unit_in_vehicle (player0)) FALSE)
										(= (unit_in_vehicle (player1)) FALSE)
									)
								)
								(object_destroy regret_corpse)
								(object_destroy regret_throne)
								(sleep 60)
								(ai_place regret 1)
								(ai_cannot_die regret TRUE)
								(cs_run_command_script regret reserve_throne)
								(if 
									(OR
										(= regret_times_dead 1)
										(= regret_times_dead 2)
									)
										(ai_set_orders regret regret_02)
								)
								(if (> regret_times_dead 2)
									(ai_set_orders regret regret_03)
								)
								(set regret_corpse (list_get (ai_actors regret) 0))
								(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
								(effect_new_on_object_marker regret_teleport regret_corpse "body")
								(object_set_function_variable regret_throne "effects" 1 1)
								(unit_set_enterable_by_player (unit regret_throne) TRUE)
							)
							(begin
								(print "do nothing")
							)
						)
					)
			)
			(= regret_dead TRUE)
		)
	)
)

(script static void regret_test
	(ai_place regret/1)
	(sleep 60)
	(set regret_corpse (list_get (ai_actors regret) 0))
	(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
	(object_create_anew regret03)
	(print "destroy him")
	(object_destroy regret_corpse)
	(print "attach him")
	(objects_attach regret_throne "driver" regret03 "")
	(print "animate him")
	(custom_animation_loop regret03 objects\characters\prophet\prophet "combat:any:any:cheer" TRUE)
)

(script command_script regret_dead_retreat
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_forever)
)

;Overall script for the Prophet boss battle
(script dormant temple_center_start
	(sleep_until (= (volume_test_objects vol_temple_foyer (players)) TRUE))
	(ai_disposable temple_entry_enemies TRUE)
	(data_mine_set_mission_segment "05b_16_temple_center")
	(ai_renew all_allies)
;	(if
;		(AND
;			(= bossfight_chatter TRUE)
;			(= (game_safe_to_save) TRUE)
;		)
;			(game_save_immediate)
;	)
	(game_save_no_timeout)

	(ai_place regret/1)
	(ai_cannot_die regret TRUE)
	(cs_run_command_script regret regret_pause)
	;(unit_set_enterable_by_player (ai_vehicle_get regret) TRUE)
	(set regret_corpse (set regret_corpse (list_get (ai_actors regret) 0)))
	(set regret_throne (object_get_parent (list_get (ai_actors regret) 0)))
	(object_set_function_variable regret_throne "effects" 1 1)

	(ai_place temple_hg_init 2)
	(wake regret_hg_comment)
	(wake temple_hg_respawner)

	(ai_place honor_grunts_init_R 2)
	(ai_place honor_grunts_init_L 2)
	(wake temple_grunt_spawner)
	;(wake regret_respawner)
	(if 
		(OR
			(difficulty_legendary)
			(difficulty_heroic)
		)
			(wake regret_retreat)
			(wake regret_death)
	)
	
	(sleep_until (= (volume_test_objects vol_temple_02 (players)) TRUE))
	(ai_set_orders all_allies temple_left_allies)
	(wake temple_cortana_warn_01)
;	(wake temple_cortana_warn_03)
	(wake regret_taunts)
	
;	(sleep 45)
;	(wake regret_beam_comment)
	
	(sleep_until 
		(OR
			(= regret_times_dead 1)
			(= regret_dead TRUE)
		)		
	30 3600)
	(if 
		(AND
			(= regret_times_dead 0)
			(= regret_dead FALSE)
		)
			(wake regret_hint_01)
	)
	
	(sleep_until 
		(OR
			(= regret_times_dead 1)
			(= regret_dead TRUE)
		)			
	30 3600)
	(if 
		(AND
			(= regret_times_dead 0)
			(= regret_dead FALSE)
		)
			(wake regret_hint_02)
	)

	(sleep_until 
		(OR
			(= regret_times_dead 1)
			(= regret_dead TRUE)
		)			
	30 1800)
	(if 
		(AND
			(= regret_times_dead 0)
			(= regret_dead FALSE)
		)
			(wake regret_hint_03)
	)
	
;	(sleep_until (= regret_times_dead 1))
;	(wake regret_teleport_comment)

	(sleep_until 
		(OR
			(= regret_times_dead 1)
			(= regret_dead TRUE)
		)			
	)
	(if (difficulty_heroic)
		(begin
			(set hg_count 3)

			(sleep_until (= regret_times_dead 2))
			(wake regret_death)
		)
	)
	(if (difficulty_legendary)
		(begin
			(set hg_count 3)

			(sleep_until (= regret_times_dead 3))
			(set hg_count 4)

			(sleep_until (= regret_times_dead 4))
			(wake regret_death)
		)
	)
	
	(sleep_until (= regret_dead TRUE))
	(sleep_forever regret_taunts)
	
	(ai_set_orders all_enemies everyone_retreat)
	(ai_set_blind all_enemies TRUE)
	(ai_set_deaf all_enemies TRUE)
	(cs_run_command_script all_enemies regret_dead_retreat) 

;9/13
			(sleep 60)
			(set bossfight_chatter FALSE)
			(ai_dialogue_enable FALSE)
;			(print "CORTANA: 'And that is the end of that.'")
;			(sleep (ai_play_line_on_object NONE 4000))
			(sleep 60)
			(print "CORTANA: 'Bad news. The reinforcements are turning around -'")
			(print "'the fleet is preparing to fire on our position! We need to get out of here!'")
			(sleep (ai_play_line_on_object NONE 0220))
			;(sleep (sound_impulse_time sound\dialog\levels\05_deltatemple\mission\L05_0220_cor))
			(sleep 30)
			(ai_dialogue_enable TRUE)
;	(sleep 60)
	(cinematic_fade_to_white)

	(kill_volume_disable kill_temple_wings)
	(wake music_05b_10_stop)
				
	(object_teleport (player0) player0_hide_bsp3)
	(object_teleport (player1) player1_hide_bsp3)
			
	(ai_kill_silent all_enemies)
			
	(if (cinematic_skip_start)
		(begin
			(c05_outro)
		)
	)
	(cinematic_skip_stop)

;	(sleep 2)
;	(cinematic_fade_from_white)

	(sleep 2)
	(playtest_mission)
	(sleep 2)
	(game_won)

;9/12

;	(game_save_no_timeout)
;	(wake temple_cortana_warn_03)
;*	(wake music_05b_10_start)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_temple_retreat_01 (players)) TRUE)
			(= (volume_test_objects vol_temple_retreat_02 (players)) TRUE)
		)
	30 1800)
	(if 
		(AND
			(= (volume_test_objects vol_temple_retreat_01 (players)) FALSE)
			(= (volume_test_objects vol_temple_retreat_02 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(wake temple_cortana_reminder)
			)
	)
*;
)


;-------------------------------------------------------------------------------
;Temple Halls Retreat

;Overall script for the retreat back through the temple halls
(script dormant temple_foyer_retreat
	(sleep_until (= regret_dead TRUE))
	(data_mine_set_mission_segment "05b_17_temple_retreat")
	(ai_renew all_allies)
	(game_save)
	(device_operates_automatically_set temple_retreat_exit TRUE)
	(ai_place temple_exit_elites_01 (- 2 (ai_living_count temple_hg)))
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_temple_retreat_01 (players)) TRUE)
			(= (volume_test_objects vol_temple_retreat_02 (players)) TRUE)
			(< (+ (ai_living_count temple_hg) (ai_living_count temple_exit_elites_01)) 2)
		)
	)
	(game_save)
	(ai_set_orders all_allies temple_retreat_allies)
	(ai_place temple_exit_grunts_01 4)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_temple_foyer (players)) TRUE)
			(< (ai_living_count temple_escape_enemies) 3)
		)
	)
	(game_save)
	(ai_place temple_exit_jackals_02 2)
	(ai_place temple_exit_elites_02 (- 2 (ai_living_count temple_exit_elites_01)))

;	(sleep_until 
;		(OR
;			(= (volume_test_objects vol_temple_entry (players)) TRUE)
;			(< (ai_living_count temple_escape_enemies) 4)
;		)
;	)
;	(ai_place temple_exit_jackals_03 (- 3 (ai_living_count temple_exit_jackals_02)))
)


;-------------------------------------------------------------------------------
;Temple Entry Retreat

;Overall script for the retreat back through the temple entry area
(script dormant temple_entry_retreat
	(sleep_until 
		(AND
			(= (volume_test_objects vol_temple_entry (players)) TRUE)
			(= regret_dead TRUE)
		)
	)
	;(game_save)
	;(ai_place temple_exit_hg_04 2)
	;(ai_place temple_exit_elites_04 2)
	
	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	
	(cinematic_fade_to_white)

	(kill_volume_disable kill_temple_wings)
	(wake music_05b_10_stop)
				
	(object_teleport (player0) player0_hide_bsp3)
	(object_teleport (player1) player1_hide_bsp3)
			
	(ai_kill_silent all_enemies)
			
	(if (cinematic_skip_start)
		(begin
			(c05_outro)
		)
	)
	(cinematic_skip_stop)

	(sleep 2)
	(cinematic_fade_from_white)

	(sleep 2)
	(playtest_mission)
	(sleep 2)
	(game_won)
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;Sleeping old stuff once past

(script static void sleep_tower1
	(sleep_forever tower1_start)
	(sleep_forever tower1_holo_looper)
	(sleep_forever tower1_cortana_comment)
)

(script static void sleep_bridges
	(sleep_forever bridges_start)
	(sleep_forever cortana_bridge_reminder)
)

(script static void sleep_tower2
	(sleep_forever tower2_start)
	(sleep_forever tower2_cortana_comment)
)

(script static void sleep_central_platform
	(sleep_forever central_platform_start)
	(sleep_forever central_platform_pelican)
)

(script static void sleep_gondola_01
	(sleep_forever gondola_01_start)
	(sleep_forever tower3_dock_above)
	(sleep_forever gondola_01_nuke)
	(sleep_forever gondola_01_restarter)
	(sleep_forever gondola_01_reverser)
	(sleep_forever gondola_01_go_reminder)
	(sleep_forever gondola_01_phantom_arrives)
	(sleep_forever tower3_turret_reman)
	(sleep_forever tower3_cortana_comment)
	(sleep_forever gondola_01_wake)
	(sleep_forever tower_cluster_delete)
)

(script static void sleep_tower3
	(sleep_forever tower3_start)
	(sleep_forever tower3_sleeper_spawn)
	(sleep_forever tower3_cortana_reminder_02)
	(sleep_forever elev_under_monitor)
	(sleep_forever assassin_ice_cream)
)

(script static void sleep_sunken_tunnel_01
	(sleep_forever sunken_tunnel1_start)
)

(script static void sleep_sunken_chamber
	(sleep_forever sunken_chamber_start)
	(sleep_forever sunken_holo_cortana_comment)
	(sleep_forever sunken_holo_looper)
	(sleep_forever sunken_holo_translate)
	(sleep_forever sunken_chamber_reminder)
	(sleep_forever hide_rightside_guys)
	(sleep_forever hide_leftside_guys)
	(sleep_forever sunk_chamber_hunters_enter)
	(sleep_forever sunken_chamber_saves)
)

(script static void sleep_sunken_tunnel_02
	(sleep_forever sunken_tunnel2_start)
)

(script static void sleep_island_exterior
	(sleep_forever island_interior_start)
	(sleep_forever island_gully_start)
	(sleep_forever island_exterior_start)
	(sleep_forever elev_up_monitor)
	(sleep_forever island_holo_looper)
	(sleep_forever island_int_translate)
	(sleep_forever island_pelican_arrives)
)

(script static void sleep_gondola_02
	(sleep_forever gondola_02_start)
	(sleep_forever gondola_02_cortana_reminder)
	(sleep_forever gondola_02_nuke)
	(sleep_forever gondola_02_restarter)
	(sleep_forever gondola_02_reverser)
	(sleep_forever gondola_02_wake)
)

(script static void sleep_temple_entry
	(sleep_forever temple_entry_start)
	(sleep_forever temple_foyer_start)
	(sleep_forever temple_ent_cortana_reminder)
)

(script static void sleep_boss_fight
	(sleep_forever temple_center_start)
	(sleep_forever temple_hg_respawner)
	(sleep_forever regret_respawner)
	(sleep_forever regret_retreat)
	(sleep_forever regret_beam_comment)
	(sleep_forever regret_hg_comment)
	(sleep_forever temple_cortana_warn_01)
	(sleep_forever regret_taunts)
)


;Startup scripts
(script startup mission	

;Cutscene stuff

	(cinematic_snap_to_white)
		
	(if (= (volume_test_objects vol_starting_locations (players)) TRUE)
		(begin
			
			(if (cinematic_skip_start)
				(begin
					(c05_intra1)
				)
			)
			(cinematic_skip_stop)
		)
	)

	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)

	(sleep 2)
	(switch_bsp 0)	
	(sleep 2)
	
;Mission stuff

	(ai_allegiance covenant prophet)
	(ai_allegiance player human)	
	(objectives_clear)
	(sleep 2)

	(prep_return_from_intro)		

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(wake 05b_title0)
	(wake objective_towers_set)
	(wake kill_volumes)

	(wake tower1_start)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_tower1_exit (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_01 (players)) TRUE)
			(= (volume_test_objects vol_tower1_exit_02 (players)) TRUE)
			(= (volume_test_objects vol_tower1_roof (players)) TRUE)
		)
	)
	(wake bridges_start)
	(wake tower2_start)

	(sleep_until 
		(OR 
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	)
	(wake central_platform_start)
	(wake gondola_01_start)

	(sleep_until (= (volume_test_objects vol_tower3_entry (players)) TRUE))
	(wake tower3_start)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)

	(sleep_until (= (structure_bsp_index) 1))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
;	(wake temple_foyer_retreat)
;	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)