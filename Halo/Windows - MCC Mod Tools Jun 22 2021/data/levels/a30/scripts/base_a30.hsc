;========== Global Variables ==========

(script static void temp
	(object_create foehammer_rubble)
	(object_create jeep3)
	(unit_enter_vehicle jeep3 foehammer_rubble "cargo")

	(object_teleport foehammer_rubble foehammer_rubble_flag)
	(recording_play_and_hover foehammer_rubble foehammer_rubble_in)
		(sleep (recording_time foehammer_rubble))
	(unit_exit_vehicle jeep3)
	)



(global boolean global_mission_won false)
(global boolean global_mission_lost false)
(global boolean global_one_marine_rescued false)
(global boolean global_two_marine_rescued false)
(global boolean global_three_marine_rescued false)
(global boolean global_four_marine_rescued false)
(global boolean global_mission_end_cliff false)
(global boolean global_mission_end_rubble false)
(global boolean global_mission_end_river false)

(global boolean mark_jeep2 false)
(global boolean mark_jeep3 false)

(global boolean mark_evade false)
(global boolean mark_protect false)
(global boolean mark_search false)
(global boolean mark_search2 false)
(global boolean mark_search3 false)

(global long delay_blink (* 30 5))
(global long delay_dawdle (* 30 15))
(global long delay_late (* 30 45))
(global long delay_lost (* 30 90))
(global long delay_fail (* 30 180))
(global long delay_calm (* 30 3))
(global long global_timer 0)

(global boolean global_lz_start false)
(global boolean global_lz_cship_ledge false)

(global boolean global_first_end false)
(global boolean test_first_kill false)
(global boolean global_cave_start false)

(global boolean global_first_wave_1 false)
(global boolean global_first_wave_2 false)
(global boolean global_first_wave_3 false)
(global boolean global_first_wave_4 false)
(global boolean global_first_wave_5 false)
(global boolean global_first_wave_6 false)
(global boolean global_first_wave_1_defend false)
(global boolean global_first_wave_2_defend false)
(global boolean global_first_wave_3_defend false)
(global boolean global_first_wave_4_defend false)
(global boolean global_first_wave_5_defend false)
(global boolean global_first_wave_6_defend false)

(global boolean global_cliff_start false)
(global boolean global_cliff_marine_active false)
(global boolean global_cliff_welcome false)
(global boolean global_cliff_all_killed false)
(global boolean global_cliff_end false)
(global boolean global_cliff_dead false)
(global boolean test_cliff_kill false)
(global boolean test_cliff_right false)

(global boolean global_rubble_start false)
(global boolean global_rubble_welcome false)
(global boolean global_rubble_waves_start false)
(global boolean global_rubble_all_killed false)
(global boolean global_rubble_end false)
(global boolean global_rubble_dead false)
(global boolean test_rubble_kill false)

(global boolean global_rubble_wave_2 false)
(global boolean global_rubble_wave_3 false)
(global boolean global_rubble_wave_4 false)
(global boolean global_rubble_wave_5 false)
(global boolean global_rubble_wave_1_defend false)
(global boolean global_rubble_wave_2_defend false)
(global boolean global_rubble_wave_3_defend false)
(global boolean global_rubble_wave_4_defend false)
(global boolean global_rubble_wave_5_defend false)
(global short global_rubble_count 0)

(global boolean global_river_start false)
(global boolean global_river_welcome false)
(global boolean global_river_marine_active false)
(global boolean global_river_all_killed false)
(global boolean global_river_end false)
(global boolean global_river_dead false)
(global boolean test_river_kill false)

(global boolean global_river_wave_1 false)
(global boolean global_river_wave_2 false)
(global boolean global_river_wave_3 false)
(global boolean global_river_wave_1_defend false)
(global boolean global_river_wave_2_defend false)
(global boolean global_river_wave_3_defend false)

(global boolean global_lifeboat_enter false)
(global boolean global_first_foehammer_waiting false)
(global boolean global_rubble_foehammer_waiting false)
(global boolean global_river_foehammer_waiting false)

(global boolean global_first_marine_rescued false)
(global boolean global_cliff_marine_rescued false)
(global boolean global_rubble_marine_rescued false)
(global boolean global_river_marine_rescued false)

;(global boolean mark_final false)
;(global boolean mark_final_banshee false)
;(global boolean mark_final_cliff_waiting false)
;(global boolean mark_final_rubble_waiting false)
;(global boolean mark_final_river_waiting false)

(global boolean mark_lz_banshee false)
(global boolean mark_lz_dropship false)
(global boolean cont_banshee_kill false)

;========== Temporary Scripts ==========

(script continuous con_emitter_death
	(sleep 90)
	(if (volume_test_objects beam_emitter_killer_1 (player0)) (damage_object "effects\damage effects\shock explosion" (player0)))
	(if (volume_test_objects beam_emitter_killer_1 (player1)) (damage_object "effects\damage effects\shock explosion" (player1)))
	(if (volume_test_objects beam_emitter_killer_2 (player0)) (damage_object "effects\damage effects\shock explosion" (player0)))
	(if (volume_test_objects beam_emitter_killer_2 (player1)) (damage_object "effects\damage effects\shock explosion" (player1)))
	)
;*
(script continuous safetosave
	(sleep 120)
	(game_safe_to_save)
	)
*;
;========== Save Point Scripts ==========

;Continuous Saves

(script continuous save_cave_entrance
	(sleep_until (volume_test_objects cave_driving (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects cave_driving (players))) 120)
	(sleep 300)
	)

(script continuous save_cave_exit
	(sleep_until (volume_test_objects cave_exit (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects cave_exit (players))) 120)
	(sleep 300)
	)

(script continuous save_cliff_1
	(sleep_until (volume_test_objects cliff_1 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects cliff_1 (players))) 120)
	(sleep 300)
	)

(script continuous save_cliff_2
	(sleep_until (volume_test_objects cliff_2 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects cliff_2 (players))) 120)
	(sleep 300)
	)

(script continuous save_rubble_1
	(sleep_until (volume_test_objects rubble_1 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects rubble_1 (players))) 120)
	(sleep 300)
	)

(script continuous save_rubble_2
	(sleep_until (volume_test_objects rubble_2 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects rubble_2 (players))) 120)
	(sleep 300)
	)

(script continuous save_river_1
	(sleep_until (volume_test_objects river_1 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects river_1 (players))) 120)
	(sleep 300)
	)

(script continuous save_river_2
	(sleep_until (volume_test_objects river_2 (players)) 15)
	(ai_free_units (vehicle_riders jeep))
	(game_save)
	(sleep_until (not (volume_test_objects river_2 (players))) 120)
	(sleep 300)
	)

;Dormant Saves

(script dormant save_mission_start
	(game_save_totally_unsafe)
	)

(script dormant save_first_arrival
	(game_save)
   (mcc_mission_segment "02_first_arrival")
	)

(script dormant save_first_welcome
	(game_save)
   (mcc_mission_segment "03_first_welcome")
	)

(script dormant save_first_wave_1
	(game_save_no_timeout)
   (mcc_mission_segment "04_first_wave1")
	)

(script dormant save_first_wave_2
	(game_save_no_timeout)
   (mcc_mission_segment "05_first_wave2")
	)

(script dormant save_first_wave_3
	(game_save_no_timeout)
   (mcc_mission_segment "06_first_wave3")
	)

(script dormant save_first_wave_4
	(game_save_no_timeout)
   (mcc_mission_segment "07_first_wave4")
	)

(script dormant save_first_wave_6
	(game_save_no_timeout)
   (mcc_mission_segment "08_first_wave5")
	)

(script dormant save_first_waiting
	(sleep_until (game_safe_to_save) 5)
	(game_save)
   (mcc_mission_segment "09_first_waiting")
	)

(script dormant save_cave_floor_enter
	(game_save)
   (mcc_mission_segment "10_cave_floor_enter")
	)

(script dormant save_cave_bridge
	(game_save_totally_unsafe)
   (mcc_mission_segment "11_cave_bridge")
	)

(script dormant save_cave_floor_exit
	(sleep_until (game_safe_to_save) 5)
	(game_save)
   (mcc_mission_segment "12_cave_floor_exit")
	)

(script dormant save_cliff_arrival
	(game_save)
   (mcc_mission_segment "13_cliff_arrival")
	)

(script dormant save_cliff_welcome
	(sleep_until (game_safe_to_save) 5)
	(game_save_no_timeout)
   (mcc_mission_segment "14_cliff_welcome")
	)

(script dormant save_cliff_rescued
	(game_save_no_timeout)
   (mcc_mission_segment "15_cliff_rescued")
	)

(script dormant save_rubble_arrival
	(game_save_no_timeout)
   (mcc_mission_segment "16_rubble_arrival")
	)

(script dormant save_rubble_welcome
	(game_save_no_timeout)
   (mcc_mission_segment "17_rubble_welcome")
	)

(script dormant save_rubble_wave_1
	(game_save_no_timeout)
   (mcc_mission_segment "18_rubble_wave_1")
	)

(script dormant save_rubble_wave_2
	(game_save_no_timeout)
   (mcc_mission_segment "19_rubble_wave_2")
	)

(script dormant save_rubble_wave_3
	(game_save_no_timeout)
   (mcc_mission_segment "20_rubble_wave_3")
	)

(script dormant save_rubble_wave_4
	(game_save_no_timeout)
   (mcc_mission_segment "21_rubble_wave_4")
	)

(script dormant save_rubble_rescued
	(game_save_no_timeout)
   (mcc_mission_segment "22_rubble_rescued")
	)

(script dormant save_river_arrival
	(game_save_no_timeout)
   (mcc_mission_segment "23_river_arrival")
	)

(script dormant save_river_welcome
	(game_save_no_timeout)
   (mcc_mission_segment "24_river_welcome")
	)

(script dormant save_river_wave_1
	(game_save_no_timeout)
   (mcc_mission_segment "25_river_wave_1")
	)

(script dormant save_river_wave_2
	(game_save_no_timeout)
   (mcc_mission_segment "26_river_wave_2")
	)

(script dormant save_river_wave_3
	(game_save_no_timeout)
   (mcc_mission_segment "27_river_wave_3")
	)

(script dormant save_river_wave_4
	(game_save_no_timeout)
   (mcc_mission_segment "28_river_wave_4")
	)

(script dormant save_river_rescued
	(game_save_no_timeout)
   (mcc_mission_segment "29_river_rescued")
	)

;========== Music Scripts ==========
(global boolean play_music_a30_01 false)
(global boolean play_music_a30_01_alt false)
(global boolean play_music_a30_02 false)
(global boolean play_music_a30_02_alt false)
(global boolean play_music_a30_03 false)
(global boolean play_music_a30_03_alt false)
(global boolean play_music_a30_04 false)
(global boolean play_music_a30_04_alt false)
(global boolean play_music_a30_05 false)
(global boolean play_music_a30_05_alt false)
(global boolean play_music_a30_06 false)
(global boolean play_music_a30_06_alt false)
(global boolean play_music_a30_07 false)
(global boolean play_music_a30_07_alt false)

(script static void music_a30_01
	(sound_looping_start "levels\a30\music\a30_01" none 1)

	(sleep_until (or play_music_a30_01_alt
				  (not play_music_a30_01)) 1 global_delay_music)
	(if play_music_a30_01_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_01" 1)
							   (sleep_until (not play_music_a30_01) 1 global_delay_music)
							   (set play_music_a30_01_alt false)
							   ))
	(set play_music_a30_01 false)
	(sound_looping_stop "levels\a30\music\a30_01")
	)

(script static void music_a30_02
	(sound_looping_start "levels\a30\music\a30_02" none 1)

	(sleep_until (or play_music_a30_02_alt
				  (not play_music_a30_02)) 1 global_delay_music)
	(if play_music_a30_02_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_02" 1)
							   (sleep_until (not play_music_a30_02) 1 global_delay_music)
							   (set play_music_a30_02_alt false)
							   ))
	(set play_music_a30_02 false)
	(sound_looping_stop "levels\a30\music\a30_02")
	)

(script static void music_a30_03
	(sound_looping_start "levels\a30\music\a30_03" none 1)

	(sleep_until (or play_music_a30_03_alt
				  (not play_music_a30_03)) 1 global_delay_music)
	(if play_music_a30_03_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_03" 1)
							   (sleep_until (not play_music_a30_03) 1 global_delay_music)
							   (set play_music_a30_03_alt false)
							   ))
	(set play_music_a30_03 false)
	(sound_looping_stop "levels\a30\music\a30_03")
	)

(script static void music_a30_04
	(sound_looping_start "levels\a30\music\a30_04" none 1)

	(sleep_until (or play_music_a30_04_alt
				  (not play_music_a30_04)) 1 global_delay_music)
	(if play_music_a30_04_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_04" 1)
							   (sleep_until (not play_music_a30_04) 1 global_delay_music)
							   (set play_music_a30_04_alt false)
							   ))
	(set play_music_a30_04 false)
	(sound_looping_stop "levels\a30\music\a30_04")
	)

(script static void music_a30_05
	(sound_looping_start "levels\a30\music\a30_05" none 1)

	(sleep_until (or play_music_a30_05_alt
				  (not play_music_a30_05)) 1 global_delay_music)
	(if play_music_a30_05_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_05" 1)
							   (sleep_until (not play_music_a30_05) 1 global_delay_music)
							   (set play_music_a30_05_alt false)
							   ))
	(set play_music_a30_05 false)
	(sound_looping_stop "levels\a30\music\a30_05")
	)

(script static void music_a30_06
	(sound_looping_start "levels\a30\music\a30_06" none 1)

	(sleep_until (or play_music_a30_06_alt
				  (not play_music_a30_06)) 1 global_delay_music)
	(if play_music_a30_06_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_06" 1)
							   (sleep_until (not play_music_a30_06) 1 global_delay_music)
							   (set play_music_a30_06_alt false)
							   ))
	(set play_music_a30_06 false)
	(sound_looping_stop "levels\a30\music\a30_06")
	)

(script static void music_a30_07
	(sound_looping_start "levels\a30\music\a30_07" none 1)

	(sleep_until (or play_music_a30_07_alt
				  (not play_music_a30_07)) 1 global_delay_music)
	(if play_music_a30_07_alt (begin (sound_looping_set_alternate "levels\a30\music\a30_07" 1)
							   (sleep_until (not play_music_a30_07) 1 global_delay_music)
							   (set play_music_a30_07_alt false)
							   ))
	(set play_music_a30_07 false)
	(sound_looping_stop "levels\a30\music\a30_07")
	)

(script dormant music_a30
	(sleep_until play_music_a30_01 1)
	(music_a30_01)
	
	(sleep_until play_music_a30_02 1)
	(music_a30_02)
	
	(sleep_until play_music_a30_03 1)
	(music_a30_03)
	
	(sleep_until play_music_a30_04 1)
	(music_a30_04)
	
	(sleep_until play_music_a30_05 1)
	(music_a30_05)
	
	(sleep_until play_music_a30_06 1)
	(music_a30_06)
	
	(sleep_until play_music_a30_07 1)
	(music_a30_07)
	)

(script dormant objectives_a30
	(sleep_until mark_evade 1)
	(hud_set_objective_text dia_evade)
	(show_hud_help_text 1)
	(hud_set_help_text obj_evade)
	(sleep 120)
	(show_hud_help_text 0)

	(sleep_until mark_protect 1)
	(hud_set_objective_text dia_protect)
	(show_hud_help_text 1)
	(hud_set_help_text obj_protect)
	(sleep 120)
	(show_hud_help_text 0)

	(sleep_until mark_search 1)
	(hud_set_objective_text dia_search1)
	(show_hud_help_text 1)
	(hud_set_help_text obj_search)
	(sleep 120)
	(show_hud_help_text 0)

	(sleep_until mark_search2 1)
	(hud_set_objective_text dia_search2)
	(show_hud_help_text 1)
	(hud_set_help_text obj_search2)
	(sleep 120)
	(show_hud_help_text 0)

	(sleep_until mark_search3 1)
	(hud_set_objective_text dia_search3)
	(show_hud_help_text 1)
	(hud_set_help_text obj_search3)
	(sleep 120)
	(show_hud_help_text 0)
	)
