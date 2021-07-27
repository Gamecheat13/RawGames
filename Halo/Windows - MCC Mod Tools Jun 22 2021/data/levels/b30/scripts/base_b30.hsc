
;========== Global Variables ==========
(global boolean global_mission_won false)
(global boolean global_mission_lost false)
(global long global_timer 0)

(global long delay_blink (* 30 3))
(global long delay_dawdle (* 30 10))
(global long delay_late (* 30 45))
(global long delay_lost (* 30 210))
(global long delay_fail (* 30 510))

(global boolean global_beach_jeep false)

(global boolean global_shaftA_start false)
(global boolean global_shaftA_beach_start false)
(global boolean global_shaftA_entrance_start false)
(global boolean global_shaftA_platform_start false)
(global boolean global_shaftA_descent_start false)

(global boolean global_shaftA_exit false)

(global long global_shaftA_beach_delay (* 30 150))
(global long global_shaftA_entrance_delay (* 30 150))
(global long global_shaftA_platform_delay (* 30 150))
(global long global_shaftA_descent_delay (* 30 150))
(global long global_shaftA_switched_delay (* 30 150))
(global long global_shaftA_final_delay (* 30 150))

(global boolean global_shaftB_beach_start false)
(global boolean global_valley_entrance_start false)
(global boolean global_valley_mouth_start false)
(global boolean global_valley_back_start false)
(global boolean global_shaftB_entrance_start false)
(global boolean global_shaftB_wide_start false)
(global boolean global_shaftB_control_start false)
(global boolean global_shaftB_final_start false)
(global boolean global_valley_lid_start false)

(global long global_shaftB_beach_delay (* 30 150))
(global long global_valley_entrance_delay (* 30 150))
(global long global_valley_mouth_delay (* 30 150))
(global long global_valley_back_delay (* 30 150))
(global long global_shaftB_entrance_delay (* 30 150))
(global long global_shaftB_wide_delay (* 30 150))
(global long global_shaftB_control_delay (* 30 150))
(global long global_shaftB_final_delay (* 30 150))

(global long global_again_final_delay (* 30 75))

(global boolean global_shaftA_known_locked false)
(global boolean global_shaftA_unlocked false)
(global boolean global_shaftA_inv_active false)
(global boolean global_shaftA_switched false)

(global boolean global_mission_start false)

(global boolean mark_lz false)
(global boolean mark_map false)
(global boolean mark_activate false)
(global boolean mark_activate_2 false)
(global boolean mark_override false)
(global boolean mark_leave false)

(global boolean mark_beach_ghost_pass false)
(global boolean test_ledge false)

;========== Music Scripts ==========
(global boolean play_music_b30_01 false)
(global boolean play_music_b30_01_alt false)
(global boolean play_music_b30_02 false)
(global boolean play_music_b30_02_alt false)
(global boolean play_music_b30_03 false)
(global boolean play_music_b30_03_alt false)
(global boolean play_music_b30_04 false)
(global boolean play_music_b30_04_alt false)
(global boolean play_music_b30_05 false)
(global boolean play_music_b30_05_alt false)
(global boolean play_music_b30_06 false)
(global boolean play_music_b30_06_alt false)
(global boolean play_music_b30_07 false)
(global boolean play_music_b30_07_alt false)
(global boolean play_music_b30_031 false)
(global boolean play_music_b30_031_alt false)
(global boolean play_music_b30_032 false)
(global boolean play_music_b30_032_alt false)

(script dormant music_b30_01
	(sleep_until play_music_b30_01 1)
	(print "levels\b30\music\b30_01")
	(sound_looping_start "levels\b30\music\b30_01" none 1)

	(sleep_until (or play_music_b30_01_alt
				  (not play_music_b30_01)) 1 global_delay_music)
	(if play_music_b30_01_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_01" 1)
							   (sleep_until (not play_music_b30_01) 1 global_delay_music)
							   (set play_music_b30_01_alt false)
							   ))
	(set play_music_b30_01 false)
	(sound_looping_stop "levels\b30\music\b30_01")
	)

(script dormant music_b30_02
	(sleep_until play_music_b30_02 1)
	(print "levels\b30\music\b30_02")
	(sound_looping_start "levels\b30\music\b30_02" none 1)

	(sleep_until (or play_music_b30_02_alt
				  (not play_music_b30_02)) 1 global_delay_music)
	(if play_music_b30_02_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_02" 1)
							   (sleep_until (not play_music_b30_02) 1 global_delay_music)
							   (set play_music_b30_02_alt false)
							   ))
	(set play_music_b30_02 false)
	(sound_looping_stop "levels\b30\music\b30_02")
	)

(script dormant music_b30_03
	(sleep_until play_music_b30_03 1)
	(print "levels\b30\music\b30_03")
	(sound_looping_start "levels\b30\music\b30_03" none 1)

	(sleep_until (or play_music_b30_03_alt
				  (not play_music_b30_03)) 1 global_delay_music)
	(if play_music_b30_03_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_03" 1)
							   (sleep_until (not play_music_b30_03) 1 global_delay_music)
							   (set play_music_b30_03_alt false)
							   ))
	(set play_music_b30_03 false)
	(sound_looping_stop "levels\b30\music\b30_03")
	)

(script dormant music_b30_031
	(sleep_until play_music_b30_031 1)
	(print "levels\b30\music\b30_031")
	(sound_looping_start "levels\b30\music\b30_031" none 1)

	(sleep_until (or play_music_b30_031_alt
				  (not play_music_b30_031)) 1 global_delay_music)
	(if play_music_b30_031_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_031" 1)
							   (sleep_until (not play_music_b30_031) 1 global_delay_music)
							   (set play_music_b30_031_alt false)
							   ))
	(set play_music_b30_031 false)
	(sound_looping_stop "levels\b30\music\b30_031")
	)

(script dormant music_b30_032
	(sleep_until play_music_b30_032 1)
	(print "levels\b30\music\b30_032")
	(sound_looping_start "levels\b30\music\b30_032" none 1)

	(sleep_until (or play_music_b30_032_alt
				  (not play_music_b30_032)) 1 global_delay_music)
	(if play_music_b30_032_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_032" 1)
							   (sleep_until (not play_music_b30_032) 1 global_delay_music)
							   (set play_music_b30_032_alt false)
							   ))
	(set play_music_b30_032 false)
	(sound_looping_stop "levels\b30\music\b30_032")
	)

(script dormant music_b30_06
	(sleep_until play_music_b30_06 1)
	(print "levels\b30\music\b30_06")
	(sound_looping_start "levels\b30\music\b30_06" none 1)

	(sleep_until (or play_music_b30_06_alt
				  (not play_music_b30_06)) 1 global_delay_music)
	(if play_music_b30_06_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_06" 1)
							   (sleep_until (not play_music_b30_06) 1 global_delay_music)
							   (set play_music_b30_06_alt false)
							   ))
	(set play_music_b30_06 false)
	(sound_looping_stop "levels\b30\music\b30_06")
	)

(script dormant music_b30_05
	(sleep_until play_music_b30_05 1)
	(print "levels\b30\music\b30_05")
	(sound_looping_start "levels\b30\music\b30_05" none 1)

	(sleep_until (or play_music_b30_05_alt
				  (not play_music_b30_05)) 1 global_delay_music)
	(if play_music_b30_05_alt (begin (sound_looping_set_alternate "levels\b30\music\b30_05" 1)
							   (sleep_until (not play_music_b30_05) 1 global_delay_music)
							   (set play_music_b30_05_alt false)
							   ))
	(set play_music_b30_05 false)
	(sound_looping_stop "levels\b30\music\b30_05")
	)
(script dormant music_b30
	(wake music_b30_01)
	(wake music_b30_02)
	(wake music_b30_03)
	(wake music_b30_031)
	(wake music_b30_032)
	(wake music_b30_06)
	(wake music_b30_05)

	(sleep_until play_music_b30_04 1)
	(sound_looping_start "levels\b30\music\b30_04" none 1)
	(print "levels\b30\music\b30_04")
	)

(script dormant obj_mark_lz
	(sleep_until mark_lz 1)
	(hud_set_objective_text dia_lz)
	(show_hud_help_text 1)
	(hud_set_help_text obj_lz)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant obj_mark_map
	(sleep_until mark_map 1)
	(hud_set_objective_text dia_map)
	(show_hud_help_text 1)
	(hud_set_help_text obj_map)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant obj_mark_activate
	(sleep_until mark_activate 1)
	(hud_set_objective_text dia_activate)
	(show_hud_help_text 1)
	(hud_set_help_text obj_activate)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant obj_mark_override
	(sleep_until mark_override 1)
	(hud_set_objective_text dia_override)
	(show_hud_help_text 1)
	(hud_set_help_text obj_override)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant obj_mark_activate_2
	(sleep_until mark_activate_2 1)
	(hud_set_objective_text dia_activate)
	(show_hud_help_text 1)
	(hud_set_help_text obj_activate)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant obj_mark_leave
	(sleep_until mark_leave 1)
	(hud_set_objective_text dia_leave)
	(show_hud_help_text 1)
	(hud_set_help_text obj_leave)
	(sleep 120)
	(show_hud_help_text 0)
	)

(script dormant objectives_b30
	(sleep 1)
	(wake obj_mark_lz)
	(wake obj_mark_map)
	(wake obj_mark_activate)
	(wake obj_mark_override)
	(wake obj_mark_activate_2)
	(wake obj_mark_override)
	(wake obj_mark_leave)
	)


;========== Save Point Scripts ==========
(script continuous save_beach_1
	(sleep_until (and (volume_test_objects beach_1 (players))
				   (= 0 (ai_living_count beach_lz))))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects beach_1 (players))))
	(sleep 300)
	)

(script continuous save_beach_2
	(sleep_until (and (volume_test_objects beach_2 (players))
				   (= 0 (ai_living_count beach_lz))))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects beach_2 (players))))
	(sleep 300)
	)

(script continuous save_beach_3
	(sleep_until (and (volume_test_objects beach_3 (players))
				   (= 0 (ai_living_count beach_pass))))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects beach_3 (players))))
	(sleep 300)
	)

(script continuous save_beach_4
	(sleep_until (volume_test_objects beach_4 (players)))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects beach_4 (players))))
	(sleep 300)
	)

(script continuous save_beach_5
	(sleep_until (volume_test_objects beach_5 (players)))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects beach_5 (players))))
	(sleep 300)
	)

(script continuous save_shaftA_entrance
	(sleep_until (volume_test_objects shaftA_entrance (players)))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects shaftA_entrance (players))))
	(sleep 300)
	)

(script continuous save_shaftB_entrance
	(sleep_until (volume_test_objects shaftB_entrance (players)))
	(set play_music_b30_01 false)
	(game_save)
	(sleep_until (not (volume_test_objects shaftB_entrance (players))))
	(sleep 300)
	)

;Dormant Saves only trigger once, usually right before or right after an
;encounter, obj or cutscene.  Dormant Saves are designed to trigger
;as soon as they wake.

(script dormant save_mission_start
	(game_save_totally_unsafe)
   (mcc_mission_segment "01_start")
	)

(script dormant save_beach_lz
	(game_save_no_timeout)
   (mcc_mission_segment "02_beach_lz")
	)

(script dormant save_beach_crack
	(sleep_until (= 0 (ai_living_count beach_crack)))
	(game_save_no_timeout)
   (mcc_mission_segment "03_beach_crack")
	)

(script dormant save_beach_pass
	(sleep_until (= 0 (ai_living_count beach_pass)))
	(game_save_no_timeout)
   (mcc_mission_segment "04_beach_pass")
	)

(script dormant save_beach_slab
	(sleep_until (= 0 (ai_living_count beach_slab)))
	(game_save_no_timeout)
   (mcc_mission_segment "05_beach_slab")
	)

(script dormant save_valley_crack
	(sleep_until (= 0 (ai_living_count valley_crack)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "06_valley_crack")
	)

(script dormant save_valley_lid
	(sleep_until (= 0 (ai_living_count valley_lid)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "07_valley_lid")
	)

(script dormant save_valley_canyon
	(sleep_until (= 0 (ai_living_count valley_canyon)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "08_valley_canyon")
	)

(script dormant save_shaftB_wide
	(sleep_until (= 0 (ai_living_count shaftB_wide)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "09_shaftB_wide")
	)

(script dormant save_shaftA_beam_enter
	(sleep_until (volume_test_objects shaftA_unlocked (players)) 10)
	(sleep_until (not (volume_test_objects shaftA_unlocked (players))) 10)
	(game_save)
   (mcc_mission_segment "10_shaftA_beam_enter")
	)
	
(script dormant save_shaftA_beam
	(sleep_until (= 0 (ai_living_count shaftA_beam)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "11_shaftA_beam")
	)

(script dormant save_shaftA_u_enter
	(sleep_until (volume_test_objects shaftA_u_enter (players)) 10)
	(sleep_until (not (volume_test_objects shaftA_u_enter (players))) 10)
	(game_save)
   (mcc_mission_segment "12_shaftA_u_beam")
	)

(script dormant save_shaftA_u
	(sleep_until (= 0 (ai_living_count shaftA_u)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "13_shaftA_u")
	)

(script dormant save_shaftA_mind_enter
	(sleep_until (volume_test_objects shaftA_jig (players)) 10)
	(sleep_until (not (volume_test_objects shaftA_jig (players))) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "14_shaftA_mind_enter")
	)

(script dormant save_shaftA_mind
	(sleep_until (= 0 (ai_living_count shaftA_mind)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "15_shaftA_mind")
	)

(script dormant save_shaftA_ante_enter
	(sleep_until (volume_test_objects shaftA_mind (players)) 10)
	(sleep_until (not (volume_test_objects shaftA_mind (players))) 10)
	(game_save)
   (mcc_mission_segment "16_shaftA_ante_enter")
	)

(script dormant save_shaftA_ramp_inv
	(sleep_until (= 0 (ai_living_count shaftA_ramp_inv)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "17_shaftA_ramp_inv")
	)

(script dormant save_shaftA_mind_inv
	(sleep_until (= 0 (ai_living_count shaftA_mind_inv)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "18_shaftA_mind_inv")
	)

(script dormant save_shaftA_jig_inv
	(sleep_until (= 0 (ai_living_count shaftA_jig_inv)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "19_shaftA_jig_inv")
	)

(script dormant save_shaftA_u_inv
	(sleep_until (= 0 (ai_living_count shaftA_u_inv)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "20_shaftA_u_inv")
	)

(script dormant save_shaftA_beam_inv
	(sleep_until (= 0 (ai_living_count shaftA_beam_inv)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "21_shaftA_beam_inv")
	)

(script dormant save_shaftA_locked
	(game_save_no_timeout)
   (mcc_mission_segment "22_shaftA_locked")
	)

(script dormant save_shaftA_switched
	(sleep_until (not (volume_test_objects shaftA_switch (players))))
	(game_save_no_timeout)
   (mcc_mission_segment "23_shaftA_switched")
	)

(script dormant save_shaftB_switched
	(sleep_until (volume_test_objects shaftB_control_hall (players)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "24_shaftB_switched")
	)
