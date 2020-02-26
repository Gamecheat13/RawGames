; Decompiled with Assembly
; 
; Source file: 010_jungle.hsc
; Start time: 2018-06-29 7:32:14 AM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global string data_mine_mission_segment "")
(global boolean perspective_running false)
(global boolean perspective_finished false)
(global boolean g_cortana_header false)
(global boolean g_cortana_footer false)
(global boolean g_gravemind_header false)
(global boolean g_gravemind_footer false)
(global boolean g_dam_player_in_pelican false)
(global boolean g_marines_dead false)
(global boolean chapter_finished false)
(global short g_nav_sleep (* 30 60 2))
(global short g_nav_sleep_dam (* 30 60 0.5))
(global real g_nav_offset 0.55)
(global boolean g_nav_cc false)
(global boolean g_nav_jw false)
(global boolean g_nav_gc false)
(global boolean g_nav_pa false)
(global boolean g_nav_ss false)
(global boolean g_nav_pb false)
(global boolean g_nav_ba false)
(global boolean g_nav_dam false)
(global boolean g_music_010_01 false)
(global boolean g_music_010_02 false)
(global boolean g_music_010_03 false)
(global boolean g_music_010_04 false)
(global boolean g_music_010_05 false)
(global boolean g_music_010_06 false)
(global boolean g_music_010_06_alt false)
(global boolean g_music_010_065 false)
(global boolean g_music_010_07 false)
(global boolean g_music_010_075 false)
(global boolean g_music_010_076 false)
(global boolean g_music_010_08 false)
(global boolean g_playing_dialogue false)
(global ai arbiter none)
(global ai tech none)
(global ai pilot_01 none)
(global ai pilot_02 none)
(global ai chieftain none)
(global ai johnson none)
(global ai joh_marine_01 none)
(global ai joh_marine_02 none)
(global ai joh_marine_03 none)
(global ai sarge none)
(global ai marine_01 none)
(global ai marine_02 none)
(global ai marine_03 none)
(global ai marine_04 none)
(global ai sarge_sv none)
(global ai marine_sv_01 none)
(global ai marine_sv_02 none)
(global ai marine_sv_03 none)
(global ai brute_01 none)
(global ai brute_02 none)
(global ai grunt_01 none)
(global ai grunt_02 none)
(global ai grunt_03 none)
(global ai grunt_04 none)
(global object cin_brute_guard none)
(global object dead_brute none)
(global boolean g_md_jw_river false)
(global boolean g_pb_joh_alright false)
(global boolean g_johnson_pile_in false)
(global boolean g_jw_joh_phantom_arb true)
(global boolean g_jw_joh_phantom_joh true)
(global boolean g_jw_joh_phantom_mar true)
(global boolean g_jw_johnson_past false)
(global short g_jw_marines_climbing 0)
(global boolean g_jw_brute01 false)
(global boolean g_jw_grunt_move false)
(global boolean g_jw_phantom_02_drop false)
(global short g_jw_brute_sleep (* 30 50))
(global short g_jw_grunt_sleep (* 30 60))
(global vehicle jw_phantom_01 none)
(global vehicle jw_phantom_02 none)
(global vehicle jw_phantom_04 none)
(global vehicle jw_phantom_05 none)
(global object obj_sarge none)
(global boolean g_ss_banshee_ambush false)
(global vehicle ss_pelican_01 none)
(global vehicle ss_pelican_02 none)
(global vehicle ss_banshee_01 none)
(global vehicle ss_banshee_02 none)
(global boolean g_ss_kill_pelicans false)
(global boolean g_ss_pelican01_hit false)
(global boolean g_ss_pelican02_hit false)
(global boolean g_ba_dumb_apes_continue false)
(global boolean g_ba_phantom_stop false)
(global boolean g_ba_ph01_shoot_loop true)
(global boolean g_ba_ph02_shoot_loop true)
(global boolean g_ba_marine_03 false)
(global unit obj_arbiter none)
(global unit obj_johnson none)
(global unit obj_chieftain none)
(global boolean g_010pb_finished false)
(global boolean g_dam_prisoners_free false)
(global boolean g_dam_prisoners_speak false)
(global boolean g_dam_follow_objective false)
(global boolean g_pa_cortana false)
(global boolean g_pa_cortana_dialogue false)
(global short g_set_all 24)
(global boolean g_ss_insertion_start false)
(global real g_ba_starting_pitch 10)
(global boolean editor false)
(global boolean g_play_cinematics true)
(global boolean g_player_training true)
(global boolean debug false)
(global boolean dialogue true)
(global boolean music true)
(global short g_insertion_index 0)
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
(global short g_player_start_pitch 65520)
(global boolean g_null false)
(global short g_gc_phantom 0)
(global boolean g_gc_jackal_spawn true)
(global short g_gc_jackal_limit 0)
(global short g_gc_jackal_count 0)
(global boolean g_ss_cov_rein_02 false)
(global vehicle ss_phantom_02 none)
(global boolean g_ss_phantom_01 false)
(global boolean g_ss_phantom_02 false)
(global boolean g_ss_phantom_02_placed false)
(global boolean g_ss_phantom_03 false)
(global boolean g_ss_phantom_03_spawn false)
(global boolean g_pb_jackal_spawn true)
(global short g_pb_jackal_limit 0)
(global short g_pb_jackal_count 0)
(global boolean g_ba_johnson_objective false)
(global boolean g_ba_jackal_spawn true)
(global short g_ba_jackal_limit 0)
(global short g_ba_jackal_count 0)
(global boolean g_ba_phantom_flyaway false)
(global boolean g_dam_phantom_02 false)
(global boolean g_dam_place_phantom_03 false)
(global boolean g_dam_phantom_04 false)
(global boolean g_dam_place_phantom_04 false)
(global boolean g_dam_pelican false)
(global boolean g_dam_pelican_arrive false)
(global boolean g_dam_pelican_attack01 false)
(global boolean g_dam_pelican_attack02 false)
(global short g_dam_extraction_location 0)
(global vehicle dam_phantom_01 none)
(global vehicle dam_phantom_02 none)
(global vehicle dam_phantom_03 none)
(global vehicle dam_phantom_04 none)
(global vehicle dam_pelican none)
(global boolean g_dam_pelican_task false)
(global short g_rock_zone_index 0)
(global short g_camera_zone_index 100)

; Scripts
(script static unit player0
    (unit (list_get (players) 0))
)

(script static unit player1
    (unit (list_get (players) 1))
)

(script static unit player2
    (unit (list_get (players) 2))
)

(script static unit player3
    (unit (list_get (players) 3))
)

(script static short player_count
    (list_count (players))
)

(script static void print_difficulty
    (game_save_immediate)
    (if (= (game_difficulty_get_real) easy)
        (print "easy")
        (if (= (game_difficulty_get_real) normal)
            (print "normal")
            (if (= (game_difficulty_get_real) heroic)
                (print "heroic")
                (if (= (game_difficulty_get_real) legendary)
                    (print "legendary")
                )
            )
        )
    )
)

(script static boolean difficulty_legendary
    (= (game_difficulty_get) legendary)
)

(script static boolean difficulty_heroic
    (= (game_difficulty_get) heroic)
)

(script static boolean difficulty_normal
    (= (game_difficulty_get) normal)
)

(script static boolean players_not_in_combat
    (player_action_test_reset)
    (sleep 30)
    (if (and (not (player_action_test_primary_trigger)) (not (player_action_test_grenade_trigger)) (if (= (game_coop_player_count) 4)
        (begin
            (>= (object_get_shield (player0)) 1)
            (>= (object_get_shield (player1)) 1)
            (>= (object_get_shield (player2)) 1)
            (>= (object_get_shield (player3)) 1)
        )
        (if (= (game_coop_player_count) 3)
            (begin
                (>= (object_get_shield (player0)) 1)
                (>= (object_get_shield (player1)) 1)
                (>= (object_get_shield (player2)) 1)
            )
            (if (= (game_coop_player_count) 2)
                (begin
                    (>= (object_get_shield (player0)) 1)
                    (>= (object_get_shield (player1)) 1)
                )
                (if true
                    (begin
                        (>= (object_get_shield (player0)) 1)
                    )
                )
            )
        )
    ))
        true
        false
    )
)

(script static boolean cinematic_skip_start
    (cinematic_skip_start_internal)
    (game_save_cinematic_skip)
    (sleep_until (not (game_saving)) 1)
    (not (game_reverted))
)

(script static void cinematic_skip_stop
    (cinematic_skip_stop_internal)
    (if (not (game_reverted))
        (game_revert)
    )
)

(script static void cinematic_fade_to_black
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (player_control_fade_out_all_input 1)
    (campaign_metagame_time_pause true)
    (unit_lower_weapon (player0) 30)
    (unit_lower_weapon (player1) 30)
    (unit_lower_weapon (player2) 30)
    (unit_lower_weapon (player3) 30)
    (sleep 10)
    (chud_cinematic_fade 0 0.5)
    (cinematic_show_letterbox true)
    (sleep 5)
    (fade_out 0 0 0 30)
    (sleep 30)
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_hide (player2) true)
    (object_hide (player3) true)
    (cinematic_start)
    (camera_control true)
    (player_enable_input false)
    (player_disable_movement false)
    (sleep 1)
    (cinematic_show_letterbox_immediate true)
)

(script static void cinematic_snap_to_black
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (fade_out 0 0 0 0)
    (player_control_fade_out_all_input 0)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_hide (player2) true)
    (object_hide (player3) true)
    (chud_cinematic_fade 0 0)
    (campaign_metagame_time_pause true)
    (sleep 1)
    (cinematic_start)
    (camera_control true)
    (player_enable_input false)
    (player_disable_movement false)
    (sleep 1)
    (cinematic_show_letterbox_immediate true)
    (sleep 1)
)

(script static void cinematic_fade_to_title
    (sleep 15)
    (cinematic_stop)
    (camera_control false)
    (cinematic_show_letterbox_immediate true)
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_hide (player2) false)
    (object_hide (player3) false)
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 1)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (fade_in 0 0 0 15)
    (sleep 15)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
)

(script static void cinematic_fade_to_title_slow
    (cinematic_stop)
    (camera_control false)
    (cinematic_show_letterbox_immediate true)
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_hide (player2) false)
    (object_hide (player3) false)
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 1)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (fade_in 0 0 0 150)
    (sleep 15)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
)

(script static void cinematic_title_to_gameplay
    (sleep 30)
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 1)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (unit_raise_weapon (player0) 30)
    (unit_raise_weapon (player1) 30)
    (unit_raise_weapon (player2) 30)
    (unit_raise_weapon (player3) 30)
    (sleep 10)
    (player_enable_input true)
    (player_control_fade_in_all_input 1)
    (player_disable_movement false)
    (sleep 110)
    (cinematic_show_letterbox false)
    (sleep 15)
    (chud_cinematic_fade 1 1)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (game_save)
)

(script static void cinematic_fade_to_gameplay
    (cinematic_stop)
    (camera_control false)
    (cinematic_show_letterbox_immediate true)
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_hide (player2) false)
    (object_hide (player3) false)
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 1)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (fade_in 0 0 0 15)
    (sleep 15)
    (cinematic_show_letterbox false)
    (chud_cinematic_fade 1 1)
    (unit_raise_weapon (player0) 30)
    (unit_raise_weapon (player1) 30)
    (unit_raise_weapon (player2) 30)
    (unit_raise_weapon (player3) 30)
    (sleep 10)
    (player_enable_input true)
    (player_control_fade_in_all_input 1)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (player_disable_movement false)
    (game_save)
)

(script static void chapter_start
    (chud_cinematic_fade 0 0.5)
    (cinematic_show_letterbox true)
    (sleep 30)
)

(script static void chapter_stop
    (cinematic_show_letterbox false)
    (sleep 15)
    (chud_cinematic_fade 1 0.5)
    (game_save)
)

(script static void perspective_start
    (game_save_cancel)
    (cinematic_skip_start_internal)
    (ai_disregard (player0) true)
    (ai_disregard (player1) true)
    (ai_disregard (player2) true)
    (ai_disregard (player3) true)
    (object_cannot_take_damage (player0))
    (object_cannot_take_damage (player1))
    (object_cannot_take_damage (player2))
    (object_cannot_take_damage (player3))
    (player_control_fade_out_all_input 2)
    (unit_lower_weapon (player0) 30)
    (unit_lower_weapon (player1) 30)
    (unit_lower_weapon (player2) 30)
    (unit_lower_weapon (player3) 30)
    (chud_cinematic_fade 0 0.5)
    (sleep 15)
    (cinematic_show_letterbox true)
    (sleep 5)
    (fade_out 0 0 0 10)
    (sleep 10)
    (camera_control true)
    (cinematic_start)
    (sleep 15)
)

(script static void perspective_stop
    (cinematic_stop)
    (camera_control false)
    (sleep 1)
    (cinematic_show_letterbox_immediate true)
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (player_control_fade_in_all_input 0.5)
    (fade_in 0 0 0 10)
    (sleep 5)
    (cinematic_show_letterbox false)
    (unit_raise_weapon (player0) 30)
    (unit_raise_weapon (player1) 30)
    (unit_raise_weapon (player2) 30)
    (unit_raise_weapon (player3) 30)
    (sleep 10)
    (chud_cinematic_fade 1 0.5)
    (ai_disregard (player0) false)
    (ai_disregard (player1) false)
    (ai_disregard (player2) false)
    (ai_disregard (player3) false)
    (object_can_take_damage (player0))
    (object_can_take_damage (player1))
    (object_can_take_damage (player2))
    (object_can_take_damage (player3))
    (game_save)
)

(script static void perspective_skipped
    (cinematic_stop)
    (camera_control false)
    (ai_disregard (player0) false)
    (ai_disregard (player1) false)
    (ai_disregard (player2) false)
    (ai_disregard (player3) false)
    (object_can_take_damage (player0))
    (object_can_take_damage (player1))
    (object_can_take_damage (player2))
    (object_can_take_damage (player3))
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 5)
    (player_control_fade_in_all_input 1)
    (fade_in 0 0 0 15)
    (sleep 15)
    (unit_raise_weapon (player0) 15)
    (unit_raise_weapon (player1) 15)
    (unit_raise_weapon (player2) 15)
    (unit_raise_weapon (player3) 15)
    (game_save)
)

(script static boolean perspective_skip_start
    (player_action_test_reset)
    (sleep_until (or (not perspective_running) (player_action_test_cinematic_skip)) 1)
    perspective_running
)

(script static void insertion_start
    (fade_out 0 0 0 0)
    (sound_class_set_gain "object" 0 0)
    (sound_class_set_gain "vehicle" 0 0)
    (cinematic_show_letterbox_immediate true)
    (chud_cinematic_fade 0 0)
    (player_disable_movement true)
    (player_enable_input false)
    (campaign_metagame_time_pause true)
    (unit_lower_weapon (player0) 1)
    (unit_lower_weapon (player1) 1)
    (unit_lower_weapon (player2) 1)
    (unit_lower_weapon (player3) 1)
    (sleep 1)
    (sound_class_set_gain "object" 1 30)
    (sound_class_set_gain "vehicle" 1 30)
)

(script dormant void insertion_end
    (sleep 30)
    (fade_in 0 0 0 15)
    (sleep 15)
    (cinematic_show_letterbox false)
    (player_control_fade_in_all_input 1)
    (sleep 15)
    (chud_cinematic_fade 1 1)
    (unit_raise_weapon (player0) 30)
    (unit_raise_weapon (player1) 30)
    (unit_raise_weapon (player2) 30)
    (unit_raise_weapon (player3) 30)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (player_enable_input true)
    (player_disable_movement false)
    (game_save)
)

(script static ai (ai_get_driver (ai vehicle_starting_location))
    (object_get_ai (vehicle_driver (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

(script static ai (ai_get_gunner (ai vehicle_starting_location))
    (object_get_ai (vehicle_gunner (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

(script static boolean any_players_in_vehicle
    (or (unit_in_vehicle (unit (player0))) (unit_in_vehicle (unit (player1))) (unit_in_vehicle (unit (player2))) (unit_in_vehicle (unit (player3))))
)

(script static void (shut_door_forever (device machine_door))
    (device_operates_automatically_set machine_door false)
    (device_set_position machine_door 0)
    (sleep_until (<= (device_get_position machine_door) 0) 30 300)
    (if (> (device_get_position machine_door) 0)
        (device_set_position_immediate machine_door 0)
    )
    (sleep 1)
    (device_set_power machine_door 0)
)

(script static void (shut_door_forever_immediate (device machine_door))
    (device_operates_automatically_set machine_door false)
    (device_set_position_immediate machine_door 0)
    (device_set_power machine_door 0)
)

(script dormant void reset_map_reminder
    (sleep_until 
        (begin
            (print "press a to play again!")
            false
        )
        90
    )
)

(script static void end_segment
    (print "end gameplay segment!  thank you for playing!")
    (sleep 15)
    (print "grab paul or rob to give feedback!")
    (sleep 15)
    (player_action_test_reset)
    (sleep_until 
        (begin
            (print "press the a button to reset!")
            (sleep_until (player_action_test_accept) 1 90)
            (player_action_test_accept)
        )
        1
    )
    (print "reloading map...")
    (sleep 15)
    (chud_cinematic_fade 1 0)
    (fade_in 0 0 0 0)
    (map_reset)
)

(script static void end_mission
    (if global_playtest_mode
        (begin
            (data_mine_set_mission_segment "questionaire")
            (cinematic_fade_to_gameplay)
            (sleep 1)
            (print "end mission!")
            (sleep 15)
            (hud_set_training_text "playtest_raisehand")
            (hud_show_training_text true)
            (sleep 90)
            (player_action_test_reset)
            (sleep_until 
                (begin
                    (sleep_until (player_action_test_accept) 1 90)
                    (player_action_test_accept)
                )
                1
            )
            (hud_show_training_text false)
            (print "loading next mission...")
            (sleep 15)
        )
        (begin
            (fade_out 0 0 0 0)
            (cinematic_stop)
            (camera_control false)
        )
    )
    (game_won)
)

(script startup void beginning_mission_segment
    (data_mine_set_mission_segment "mission_start")
)

(script continuous void gs_cortana_header
    (sleep_until g_cortana_header 1)
    (print "cortana header")
    (game_save_cancel)
    (game_safe_to_respawn false)
    (player_control_scale_all_input 0.15 0.5)
    (ai_dialogue_enable false)
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (damage_players "cinematics\cortana_channel\cortana_effect")
    (gs_hud_flicker_out)
    (set g_cortana_header false)
)

(script continuous void gs_cortana_footer
    (sleep_until g_cortana_footer 1)
    (print "cortana footer")
    (sleep 1)
    (game_safe_to_respawn true)
    (player_control_scale_all_input 1 0.5)
    (ai_dialogue_enable true)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (sleep 1)
    (game_save)
    (chud_cinematic_fade 1 1.5)
    (sound_impulse_start "sound\visual_fx\cortana_hud_on" none 1)
    (set g_cortana_footer false)
)

(script continuous void gs_gravemind_header
    (sleep_until g_gravemind_header 1)
    (print "gravemind header")
    (game_save_cancel)
    (game_safe_to_respawn false)
    (player_control_scale_all_input 0.15 2)
    (ai_dialogue_enable false)
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (sleep 1)
    (set g_gravemind_header false)
)

(script continuous void gs_gravemind_footer
    (sleep_until g_gravemind_footer 1)
    (print "gravemind footer")
    (game_safe_to_respawn true)
    (player_control_scale_all_input 1 1)
    (ai_dialogue_enable true)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (sleep 1)
    (set g_gravemind_footer false)
    (sleep 30)
    (game_save)
)

(script static void gs_hud_flicker_out
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 1 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 1 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 1 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 1 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 1 (real_random_range 0 0.035))
    (sound_impulse_start "sound\visual_fx\sparks_medium" none 1)
    (sleep (random_range 2 5))
    (chud_cinematic_fade 0 (real_random_range 0 0.035))
)

(script static boolean award_skull
    (if (and (>= (game_difficulty_get_real) normal) (= (game_insertion_point_get) 0))
        true
        false
    )
)

(script static void (ai_trickle_via_phantom (ai vehicle_starting_location, ai spawned_squad))
    (ai_place spawned_squad)
    (vehicle_load_magic (ai_vehicle_get_from_starting_location vehicle_starting_location) 0 (ai_actors spawned_squad))
    (sleep 1)
    (object_set_phantom_power (ai_vehicle_get_from_starting_location vehicle_starting_location) true)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 1)
    (sleep 15)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 2)
    (sleep 15)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 3)
    (sleep 60)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 4)
    (sleep 60)
    (object_set_phantom_power (ai_vehicle_get_from_starting_location vehicle_starting_location) false)
)

(script static void (ai_dump_via_phantom (ai vehicle_starting_location, ai spawned_squad))
    (ai_place spawned_squad)
    (vehicle_load_magic (ai_vehicle_get_from_starting_location vehicle_starting_location) 0 (ai_actors spawned_squad))
    (sleep 1)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 0)
)

(script static void (ai_disembark_via_phantom (ai vehicle_starting_location, ai spawned_squad))
    (unit_open (ai_vehicle_get_from_starting_location vehicle_starting_location))
    (sleep 45)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 5)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 6)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 7)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 8)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 9)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 10)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 11)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 12)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 13)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 14)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 15)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 16)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 17)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 18)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 19)
    (vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) 20)
    (sleep 120)
    (unit_close (ai_vehicle_get_from_starting_location vehicle_starting_location))
)

(script dormant void 010_jungle_mission_won
    (sleep_until (or (vehicle_test_seat dam_pelican "" (unit (player0))) (vehicle_test_seat dam_pelican "" (unit (player1))) (vehicle_test_seat dam_pelican "" (unit (player2))) (vehicle_test_seat dam_pelican "" (unit (player3)))) 5)
    (sound_looping_start "sound\cinematics\070_waste\070ld_pelican_pickup\070ld_pelican_glue\070ld_pelican_glue" "dam_pelican_location" 1)
    (sound_class_set_gain "veh" 0 60)
    (sleep 45)
    (data_mine_set_mission_segment "010lb_extraction")
    (gs_nav_off)
    (set g_dam_player_in_pelican true)
    (wake obj_extraction_clear)
    (cinematic_fade_to_black)
    (gs_music_off)
    (game_award_level_complete_achievements)
    (object_teleport (player0) "player0_end_teleport")
    (object_teleport (player1) "player1_end_teleport")
    (object_teleport (player2) "player2_end_teleport")
    (object_teleport (player3) "player3_end_teleport")
    (sleep 1)
    (ai_erase "gr_all")
    (switch_zone_set "set_cin_outro_01")
    (if (= g_play_cinematics true)
        (begin
            (if (cinematic_skip_start)
                (begin
                    (if debug
                        (print "010lb_extraction_01")
                    )
                    (010lb_extraction_01)
                    (cinematic_snap_to_black)
                    (010lb_extraction_01_cleanup)
                    (switch_zone_set "set_cin_outro_02")
                    (if (cinematic_skip_start)
                        (begin
                            (if debug
                                (print "010lb_extraction_02")
                            )
                            (010lb_extraction_02)
                        )
                    )
                )
            )
            (cinematic_skip_stop)
            (010lb_extraction_01_cleanup)
            (010lb_extraction_02_cleanup)
            (sound_class_set_gain "" 0 0)
        )
    )
    (sleep 5)
    (end_mission)
)

(script dormant void obj_substation_set
    (sleep_until (>= g_cc_obj_control 2) 5 300)
    (if debug
        (print "new objective set:")
    )
    (if debug
        (print "make your way back to the sub-station for extraction.")
    )
    (objectives_show_up_to 0)
    (cinematic_set_chud_objective "obj_0")
)

(script dormant void obj_substation_clear
    (sleep 30)
    (if debug
        (print "objective complete:")
    )
    (if debug
        (print "make your way back to the sub-station for extraction.")
    )
    (objectives_finish_up_to 0)
)

(script dormant void obj_locate_pelican_set
    (sleep 120)
    (if debug
        (print "new objective set:")
    )
    (if debug
        (print "search the jungle for johnson's crashed pelican.")
    )
    (objectives_show_up_to 1)
    (cinematic_set_chud_objective "obj_1")
)

(script dormant void obj_locate_pelican_clear
    (sleep_until g_ba_johnson_objective 1)
    (sleep 30)
    (if debug
        (print "objective complete:")
    )
    (if debug
        (print "search the jungle for johnson's crashed pelican.")
    )
    (objectives_finish_up_to 1)
)

(script dormant void obj_get_to_johnson_set
    (sleep_until g_ba_johnson_objective 1)
    (sleep 30)
    (if debug
        (print "new objective set:")
    )
    (if debug
        (print "get to johnson before he's captured.")
    )
    (objectives_show_up_to 2)
    (cinematic_set_chud_objective "obj_2")
)

(script dormant void obj_get_to_johnson_clear
    (sleep 210)
    (if debug
        (print "objective complete:")
    )
    (if debug
        (print "get to johnson before he's captured.")
    )
    (objectives_finish_up_to 2)
)

(script dormant void obj_rescue_johnson_set
    (sleep 210)
    (if debug
        (print "new objective set:")
    )
    (if debug
        (print "free johnson from his prison.")
    )
    (objectives_show_up_to 3)
    (cinematic_set_chud_objective "obj_3")
)

(script dormant void obj_rescue_johnson_clear
    (sleep 30)
    (if debug
        (print "objective complete:")
    )
    (if debug
        (print "free johnson from his prison.")
    )
    (objectives_finish_up_to 3)
)

(script dormant void obj_extraction_set
    (sleep 60)
    (if debug
        (print "new objective set:")
    )
    (if debug
        (print "stay alive! a pelican is on the way.")
    )
    (objectives_show_up_to 4)
    (cinematic_set_chud_objective "obj_4")
)

(script dormant void obj_extraction_clear
    (sleep 30)
    (if debug
        (print "objective complete:")
    )
    (if debug
        (print "stay alive! a pelican is on the way.")
    )
    (objectives_finish_up_to 4)
)

(script dormant void obj_2nd_save_marines
    (sleep 30)
    (if debug
        (print "new secondary objective set:")
    )
    (if debug
        (print "keep all your marines alive.")
    )
    (objectives_secondary_show 0)
    (sleep_until g_null)
)

(script dormant void obj_2nd_unavailable_set
    (sleep 30)
    (if debug
        (print "new secondary objective set:")
    )
    (if debug
        (print "unavailable")
    )
    (objectives_secondary_show 1)
)

(script dormant void obj_2nd_unavailable_unavailable
    (sleep 30)
    (if debug
        (print "secondary objective unavailable:")
    )
    (if debug
        (print "unavailable")
    )
    (objectives_secondary_unavailable 1)
)

(script dormant void chapter_walk
    (sleep 30)
    (cinematic_set_title "title_1")
    (cinematic_title_to_gameplay)
)

(script dormant void chapter_charlie
    (chapter_start)
    (cinematic_set_title "title_2")
    (sleep 150)
    (chapter_stop)
)

(script dormant void chapter_charlie_insert
    (sleep 30)
    (cinematic_set_title "title_2")
    (cinematic_title_to_gameplay)
)

(script dormant void chapter_favor
    (sleep 30)
    (cinematic_set_title "title_3")
    (sleep 150)
    (if (= perspective_running false)
        (chapter_stop)
    )
    (set chapter_finished true)
)

(script dormant void nav_cc
    (sleep_until g_nav_cc)
    (sleep g_nav_sleep)
    (if (<= g_cc_obj_control 2)
        (begin
            (hud_activate_team_nav_point_flag player "nav_cc" g_nav_offset)
            (sleep_until (>= g_cc_obj_control 3) 1)
            (hud_deactivate_team_nav_point_flag player "nav_cc")
        )
    )
)

(script dormant void nav_jw
    (sleep_until (or (and g_nav_jw (<= (ai_living_count "obj_jw_upper_covenant") 0) (<= (ai_living_count "obj_jw_lower_covenant") 0)) (>= g_ta_obj_control 1)))
    (if (<= g_ta_obj_control 0)
        (sleep g_nav_sleep)
    )
    (if (<= g_ta_obj_control 0)
        (begin
            (hud_activate_team_nav_point_flag player "nav_jw" g_nav_offset)
            (sleep_until (>= g_ta_obj_control 1) 1)
            (hud_deactivate_team_nav_point_flag player "nav_jw")
        )
    )
)

(script dormant void nav_gc
    (sleep_until (or (and g_nav_gc (<= (ai_living_count "obj_gc_covenant") 0)) (>= g_pa_obj_control 1)))
    (if (<= g_pa_obj_control 0)
        (sleep g_nav_sleep)
    )
    (if (<= g_pa_obj_control 0)
        (begin
            (hud_activate_team_nav_point_flag player "nav_gc" g_nav_offset)
            (sleep_until (>= g_pa_obj_control 1) 1)
            (hud_deactivate_team_nav_point_flag player "nav_gc")
        )
    )
)

(script dormant void nav_pa
    (sleep_until (or (and g_nav_pa (<= (ai_living_count "obj_pa_covenant") 0)) (>= g_pa_obj_control 5)))
    (if (<= g_pa_obj_control 4)
        (sleep g_nav_sleep)
    )
    (if (<= g_pa_obj_control 4)
        (begin
            (hud_activate_team_nav_point_flag player "nav_pa" g_nav_offset)
            (sleep_until (>= g_pa_obj_control 5) 1)
            (hud_deactivate_team_nav_point_flag player "nav_pa")
        )
    )
)

(script dormant void nav_ss
    (sleep_until (or (and g_nav_ss (<= (ai_living_count "obj_ss_covenant") 0)) (>= g_pb_obj_control 1)))
    (if (<= g_pb_obj_control 0)
        (sleep g_nav_sleep)
    )
    (if (<= g_pb_obj_control 0)
        (begin
            (hud_activate_team_nav_point_flag player "nav_ss" g_nav_offset)
            (sleep_until (>= g_pb_obj_control 1) 1)
            (hud_deactivate_team_nav_point_flag player "nav_ss")
        )
    )
)

(script dormant void nav_pb
    (sleep_until (or (and g_nav_pb (<= (ai_living_count "obj_pb_covenant") 0)) (>= g_ba_obj_control 1)))
    (if (<= g_ba_obj_control 0)
        (sleep g_nav_sleep)
    )
    (if (<= g_ba_obj_control 0)
        (begin
            (hud_activate_team_nav_point_flag player "nav_pb" g_nav_offset)
            (sleep_until (>= g_ba_obj_control 1) 1)
            (hud_deactivate_team_nav_point_flag player "nav_pb")
        )
    )
)

(script dormant void nav_ba
    (sleep_until (or (and g_nav_ba (<= (ai_living_count "obj_ba_covenant") 0)) (>= g_dam_obj_control 1)))
    (if (<= g_dam_obj_control 0)
        (sleep g_nav_sleep)
    )
    (if (<= g_dam_obj_control 0)
        (begin
            (hud_activate_team_nav_point_flag player "nav_ba" g_nav_offset)
            (sleep_until (>= g_tb_obj_control 1) 1)
            (hud_deactivate_team_nav_point_flag player "nav_ba")
        )
    )
)

(script dormant void nav_dam
    (sleep_until (or (and g_nav_dam (<= (ai_living_count "obj_dam_00_04_covenant") 0) (<= (ai_living_count "obj_dam_05_06_covenant") 0) (<= (ai_living_count "obj_dam_07_covenant") 0)) g_dam_prisoners_free))
    (if (not g_dam_prisoners_free)
        (sleep g_nav_sleep_dam)
    )
    (if (not g_dam_prisoners_free)
        (begin
            (hud_activate_team_nav_point_flag player "nav_dam" g_nav_offset)
            (sleep_until g_dam_prisoners_free 1)
            (hud_deactivate_team_nav_point_flag player "nav_dam")
        )
    )
)

(script dormant void nav_dam_pelican
    (sleep_until (>= g_dam_extraction_location 1))
    (sleep g_nav_sleep_dam)
    (hud_activate_team_nav_point_flag player "nav_dam_extract" g_nav_offset)
)

(script static void gs_nav_off
    (hud_deactivate_team_nav_point_flag player "nav_cc")
    (hud_deactivate_team_nav_point_flag player "nav_jw")
    (hud_deactivate_team_nav_point_flag player "nav_gc")
    (hud_deactivate_team_nav_point_flag player "nav_pa")
    (hud_deactivate_team_nav_point_flag player "nav_ss")
    (hud_deactivate_team_nav_point_flag player "nav_pb")
    (hud_deactivate_team_nav_point_flag player "nav_ba")
    (hud_deactivate_team_nav_point_flag player "nav_dam")
    (hud_deactivate_team_nav_point_flag player "nav_dam_extract")
)

(script dormant void music_010_01
    (sleep_until g_music_010_01 1)
    (if music
        (print "start music 010_01")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_01" none 1)
    (sleep_until (not g_music_010_01) 1)
    (if music
        (print "stop music 010_01")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_01")
)

(script dormant void music_010_02
    (sleep_until g_music_010_02 1)
    (if music
        (print "start music 010_02")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_02" none 1)
    (sleep_until (not g_music_010_02) 1)
    (if music
        (print "stop music 010_02")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_02")
)

(script dormant void music_010_03
    (sleep_until g_music_010_03 1)
    (if music
        (print "start music 010_03")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_03" none 1)
    (sleep_until (not g_music_010_03) 1)
    (if music
        (print "stop music 010_03")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_03")
)

(script dormant void music_010_04
    (sleep_until g_music_010_04 1)
    (if music
        (print "start music 010_04")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_04" none 1)
    (sleep_until (not g_music_010_04) 1)
    (if music
        (print "stop music 010_04")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_04")
)

(script dormant void music_010_05
    (sleep_until g_music_010_05 1)
    (if music
        (print "start music 010_05")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_05" none 1)
    (sleep_until (not g_music_010_05) 1)
    (if music
        (print "stop music 010_05")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_05")
)

(script dormant void music_010_06
    (sleep_until g_music_010_06 1)
    (if music
        (print "start music 010_06")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_06" none 1)
    (sleep_until g_music_010_06_alt 1)
    (if music
        (print "alternate music 010_06")
    )
    (sound_looping_set_alternate "levels\solo\010_jungle\music\010_music_06" true)
    (sleep_until (not g_music_010_06) 1)
    (if music
        (print "stop music 010_06")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_06")
)

(script dormant void music_010_065
    (sleep_until g_music_010_065 1)
    (if music
        (print "start music 010_065")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_065" none 1)
    (sleep_until (not g_music_010_065) 1)
    (if music
        (print "stop music 010_065")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_065")
)

(script dormant void music_010_07
    (sleep_until g_music_010_07 1)
    (if music
        (print "start music 010_07")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_07" none 1)
    (sleep_until (not g_music_010_07) 1)
    (if music
        (print "stop music 010_07")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_07")
)

(script dormant void music_010_075
    (sleep_until g_music_010_075 1)
    (if music
        (print "start music 010_075")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_075" none 1)
    (sleep_until (not g_music_010_075) 1)
    (if debug
        (print "stop music 010_075")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_075")
)

(script dormant void music_010_076
    (sleep_until g_music_010_076 1)
    (if music
        (print "start music 010_076")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_076" none 1)
    (sleep_until (not g_music_010_076) 1)
    (if music
        (print "stop music 010_076")
    )
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_076")
)

(script dormant void music_010_08
    (sleep_until g_music_010_08 1)
    (if music
        (print "start music 010_08")
    )
    (sound_looping_start "levels\solo\010_jungle\music\010_music_08" none 1)
)

(script static void gs_music_off
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_01")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_02")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_03")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_04")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_05")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_06")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_07")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_075")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_076")
)

(script static void gs_all_music_off
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_01")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_02")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_03")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_04")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_05")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_06")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_07")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_075")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_076")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_08")
)

(script static void md_cleanup
    (set g_playing_dialogue false)
    (ai_dialogue_enable true)
)

(script dormant void md_cc_fade_in
    (sleep 15)
    (if debug
        (print "cinematic_fade_to_title")
    )
    (cinematic_fade_to_title)
)

(script dormant void md_cc_johnson_move_out
    (if debug
        (print "mission_dialogue : chief_crater : johnson : move_out")
    )
    (if debug
        (print "casting call...")
    )
    (if (not (game_is_cooperative))
        (begin
            (vs_cast "gr_arbiter" true 0 "010ma_010")
            (set arbiter (vs_role 1))
        )
    )
    (vs_cast "gr_johnson_marines" true 0 "010ma_030")
    (set johnson (vs_role 1))
    (ai_dialogue_enable false)
    (biped_force_ground_fitting_on johnson true)
    (vs_stow arbiter)
    (vs_stow johnson)
    (vs_look_player johnson true)
    (sleep 5)
    (if debug
        (print "begin talking")
    )
    (if (not (game_is_cooperative))
        (begin
            (vs_movement_mode arbiter 0)
            (vs_go_to arbiter false "ps_cc/arb02")
            (sleep 5)
        )
    )
    (sleep 45)
    (ai_activity_abort johnson)
    (vs_look_player johnson false)
    (sleep 15)
    (vs_custom_animation johnson true "objects\characters\marine\marine" "patrol:rifle:turn180_johnson" true)
    (vs_stop_custom_animation johnson)
    (if dialogue
        (print "johnson: first squad, you're my scouts!")
    )
    (sleep (ai_play_line johnson 010ma_030))
    (vs_action johnson false "ps_cc/1st_squad" ai_action_advance)
    (sleep 10)
    (sleep (random_range 10 20))
    (if debug
        (print "abort marine activities")
    )
    (ai_activity_abort "gr_marines")
    (wake obj_substation_set)
    (wake chapter_walk)
    (if (or (= (game_is_cooperative) true) (= (game_difficulty_get) legendary) (= (campaign_metagame_enabled) true))
        (player_control_scale_all_input 1 0)
        (player_control_scale_all_input 0.775 0)
    )
    (if (>= (game_difficulty_get) heroic)
        (chud_show_grenades true)
    )
    (if (= (game_coop_player_count) 2)
        (begin
            (if dialogue
                (print "johnson: arbiter, watch the chief's back.")
            )
            (vs_play_line johnson true 010ma_050)
            (sleep 15)
        )
        (if (>= (game_coop_player_count) 3)
            (begin
                (if dialogue
                    (print "johnson: as for you...")
                )
                (vs_play_line johnson true 010ma_060)
                (sleep 15)
                (if dialogue
                    (print "johnson: just try not to wreck my planet.")
                )
                (vs_play_line johnson true 010ma_070)
                (sleep 15)
            )
            (if true
                (if debug
                    (print "game is not cooperative")
                )
            )
        )
    )
    (if dialogue
        (print "johnson: move out. quiet as you can!")
    )
    (vs_play_line johnson false 010ma_040)
    (sleep (random_range 10 20))
    (if debug
        (print "release johnson marines")
    )
    (ai_activity_abort "sq_johnson_marines/mar_01")
    (ai_activity_abort "sq_johnson_marines/mar_02")
    (ai_activity_abort "sq_johnson_marines/mar_03")
    (sleep 15)
    (sleep_until (not (vs_running_atom johnson)))
    (if debug
        (print "release johnson")
    )
    (vs_release johnson)
    (vs_go_to arbiter false "ps_cc/arb03")
    (game_save)
    (sleep 15)
    (ai_dialogue_enable true)
    (biped_force_ground_fitting_on johnson false)
    (sleep_until (>= g_cc_obj_control 2))
)

(script dormant void md_cc_johnson_reminder
    (sleep (* 30 25))
    (if (and (not g_playing_dialogue) (<= g_cc_obj_control 1))
        (begin
            (if debug
                (print "mission_dialogue : chief_crater : johnson : reminder")
            )
            (vs_cast "gr_johnson_marines" true 0 "010ma_080")
            (set johnson (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (if debug
                (print "begin talking")
            )
            (vs_face_player johnson true)
            (if dialogue
                (print "johnson: best get moving, chief.")
            )
            (sleep (ai_play_line johnson 010ma_080))
            (sleep 15)
            (set g_cc_obj_control 1)
            (vs_face_player johnson false)
            (vs_enable_moving johnson true)
            (if dialogue
                (print "johnson: come on. i'll lead you out.")
            )
            (sleep (ai_play_line johnson 010ma_090))
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_cc_joh_extract
    (sleep_until (or (and (not g_playing_dialogue) (>= g_cc_obj_control 3)) (>= g_jw_obj_control 1)))
    (sleep_random)
    (if (<= g_cc_obj_control 5)
        (begin
            (if debug
                (print "mission_dialogue : chief_crater : johnson : extract")
            )
            (vs_cast "sq_johnson_marines/johnson" true 0 "010mb_010")
            (set johnson (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_moving johnson true)
            (sleep 1)
            (if dialogue
                (print "johnson (radio): bravo team, this is johnson. we got him.")
            )
            (sleep (ai_play_line johnson 010mb_010))
            (sleep 15)
            (if dialogue
                (print "johnson (radio): fall back to the extraction point, over?")
            )
            (sleep (ai_play_line johnson 010mb_020))
            (sleep 15)
            (if dialogue
                (print "sergeant (radio): roger that, stacker out!")
            )
            (sleep (ai_play_line_on_object none 010mb_030))
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_cc_brute_howl
    (sleep_until (or (and (not g_playing_dialogue) (>= g_cc_obj_control 6)) (>= g_jw_obj_control 1)))
    (sleep_random)
    (if (<= g_cc_obj_control 7)
        (begin
            (if debug
                (print "mission_dialogue : chief_crater : brute_howl")
            )
            (vs_cast "gr_johnson_marines" true 0 "010mb_060" "010mb_070")
            (set marine_01 (vs_role 1))
            (set marine_02 (vs_role 2))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (vs_enable_pathfinding_failsafe marine_02 true)
            (vs_enable_looking marine_02 true)
            (vs_enable_targeting marine_02 true)
            (vs_enable_moving marine_02 true)
            (sleep 1)
            (if dialogue
                (print "brute: (distant howl -- a call)")
            )
            (sleep (ai_play_line_on_object "brute_howl" 010mb_040))
            (sleep 15)
            (if dialogue
                (print "brute: (distant howl -- a response)")
            )
            (sleep (ai_play_line_on_object "brute_howl" 010mb_050))
            (sleep 10)
            (set g_music_010_01 true)
            (if dialogue
                (print "marine: that sounded close")
            )
            (sleep (ai_play_line marine_01 010mb_060))
            (sleep 15)
            (if dialogue
                (print "marine: too close")
            )
            (sleep (ai_play_line marine_02 010mb_070))
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_cc_bravo_advised
    (sleep_until (or (and (not g_playing_dialogue) (>= g_cc_obj_control 9)) (>= g_jw_obj_control 1)))
    (sleep_random)
    (if (<= g_cc_obj_control 10)
        (begin
            (if debug
                (print "mission_dialogue : chief_crater : bravo_advised")
            )
            (vs_cast "gr_johnson_marines" true 0 "010mb_100")
            (set johnson (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe arbiter true)
            (vs_enable_looking arbiter true)
            (vs_enable_targeting arbiter true)
            (vs_enable_moving arbiter true)
            (vs_enable_pathfinding_failsafe johnson true)
            (vs_enable_looking johnson true)
            (vs_enable_targeting johnson true)
            (vs_enable_moving johnson true)
            (sleep 1)
            (if dialogue
                (print "sergeant (radio, static): johnson? be advised. hostiles (are on the move).")
            )
            (sleep (ai_play_line_on_object none 010mb_080))
            (sleep 30)
            (if dialogue
                (print "sergeant (radio): i've got eyes on (a brute pack), over?")
            )
            (sleep (ai_play_line_on_object none 010mb_090))
            (sleep 10)
            (if dialogue
                (print "johnson (radio): say again, gunny? you're breaking up.")
            )
            (sleep (ai_play_line johnson 010mb_100))
            (set g_music_010_02 true)
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_jw_mar_brute
    (sleep_until (or (and g_jw_brute01 (>= g_jw_obj_control 5)) (>= g_jw_obj_control 7)))
    (if (and (<= g_jw_obj_control 6) (<= (ai_combat_status "gr_jw_upper_cov") 4))
        (begin
            (if debug
                (print "mission_dialogue : jungle_walk : marine : brute")
            )
            (vs_cast "gr_marines" true 10 "010mb_210")
            (set marine_01 (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if dialogue
                (print "marine (whisper): up ahead!")
            )
            (sleep (ai_play_line marine_01 010mb_210))
            (sleep 15)
            (if dialogue
                (print "marine (whisper): single brute! plus backup!.")
            )
            (sleep (ai_play_line marine_01 010mb_220))
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_jw_mar_power_armor
    (sleep_until (or (and (>= g_jw_obj_control 4) (>= (ai_combat_status "gr_marines") 4) (>= (ai_combat_status "gr_jw_upper_cov") 4) (< (unit_get_shield "sq_jw_u_cov_01/brute") 1)) (>= g_jw_obj_control 9)))
    (sleep (random_range 30 60))
    (if (and (<= g_jw_obj_control 7) (>= (ai_living_count "sq_jw_u_cov_01/brute") 1))
        (begin
            (if debug
                (print "mission_dialogue : jungle_walk : marine : power armor")
            )
            (vs_cast "gr_marines" true 10 "010mb_210")
            (set marine_01 (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if dialogue
                (print "marine: they've got power-armor, chief!")
            )
            (sleep (ai_play_line marine_01 010mb_230))
            (sleep 15)
            (if (and (>= (ai_living_count "sq_jw_u_cov_01/brute") 1) (> (object_get_shield "sq_jw_u_cov_01/brute") 0))
                (begin
                    (if dialogue
                        (print "marine: take down its shields before you close!")
                    )
                    (sleep (ai_play_line marine_01 010mb_240))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_jw_arb_prophets
    (sleep_until (or (and (>= g_jw_obj_control 5) (<= (ai_living_count "obj_jw_upper_covenant") 0)) (>= g_jw_obj_control 9)))
    (sleep (random_range 15 30))
    (if (<= g_jw_obj_control 7)
        (begin
            (if debug
                (print "mission_dialogue : jungle_walk : arbiter : prophets")
            )
            (vs_cast "gr_arbiter" true 0 "010mb_250")
            (set arbiter (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_approach arbiter false dead_brute 1.5 100 100)
            (sleep 1)
            (sleep_until (not (vs_running_atom arbiter)) 1 (* 30 5))
            (sleep 1)
            (vs_face_object arbiter true dead_brute)
            (sleep 1)
            (if (<= (objects_distance_to_object arbiter dead_brute) 2)
                (begin
                    (if dialogue
                        (print "arbiter: the prophets are liars")
                    )
                    (vs_play_line arbiter true 010mb_250)
                    (sleep 10)
                    (if dialogue
                        (print "arbiter: but you are fools to do their bidding.")
                    )
                    (vs_play_line arbiter true 010mb_260)
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_jw_river
    (sleep_until (or (and (>= g_jw_obj_control 7) (<= (ai_living_count "gr_jw_upper_cov") 0)) (>= g_jw_obj_control 9)))
    (sleep (* 30 20))
    (if (<= g_jw_obj_control 7)
        (begin
            (if debug
                (print "mission_dialogue : jungle_walk : river")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 5 "010mb_270")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 5 "010mb_280")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (if (not (game_is_cooperative))
                (begin
                    (vs_enable_pathfinding_failsafe arbiter true)
                    (vs_enable_looking arbiter true)
                    (vs_enable_targeting arbiter true)
                    (vs_enable_moving arbiter true)
                    (sleep 1)
                    (if dialogue
                        (print "arbiter: come. let us hurry to the river!")
                    )
                    (sleep (ai_play_line arbiter 010mb_270))
                )
                (begin
                    (vs_enable_pathfinding_failsafe marine_01 true)
                    (vs_enable_looking marine_01 true)
                    (vs_enable_targeting marine_01 true)
                    (vs_enable_moving marine_01 true)
                    (sleep 1)
                    (if dialogue
                        (print "marine: come on, chief. river's this way!")
                    )
                    (sleep (ai_play_line marine_01 010mb_280))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (set g_md_jw_river true)
    (game_save)
)

(script dormant void md_jw_phantoms
    (sleep_until (>= g_jw_obj_control 8))
    (sleep 90)
    (if debug
        (print "mission_dialogue : jungle_walk : river")
    )
    (if (not (game_is_cooperative))
        (begin
            (vs_cast "gr_allies" false 10 "010mq_010" "010mq_030")
            (set arbiter (vs_role 1))
            (set marine_01 (vs_role 2))
        )
        (begin
            (vs_cast "gr_marines" false 10 "010mq_050" "010mq_030")
            (set sarge (vs_role 1))
            (set marine_01 (vs_role 2))
        )
    )
    (sleep 1)
    (vs_set_cleanup_script md_cleanup)
    (set g_playing_dialogue true)
    (ai_dialogue_enable false)
    (vs_enable_pathfinding_failsafe arbiter true)
    (vs_enable_looking arbiter true)
    (vs_enable_targeting arbiter true)
    (vs_enable_moving arbiter true)
    (vs_enable_pathfinding_failsafe marine_01 true)
    (vs_enable_looking marine_01 true)
    (vs_enable_targeting marine_01 true)
    (vs_enable_moving marine_01 true)
    (vs_enable_pathfinding_failsafe sarge true)
    (vs_enable_looking sarge true)
    (vs_enable_targeting sarge true)
    (vs_enable_moving sarge true)
    (sleep 1)
    (if (not (game_is_cooperative))
        (begin
            (if dialogue
                (print "marine: phantom inbound!")
            )
            (sleep (ai_play_line marine_01 010mq_030))
        )
        (begin
            (if dialogue
                (print "marine: phantom inbound!")
            )
            (sleep (ai_play_line arbiter 010mq_030))
        )
    )
    (set g_playing_dialogue false)
    (ai_dialogue_enable true)
    (set g_md_jw_river true)
    (game_save)
)

(script dormant void md_jw_post_combat
    (sleep_until (or (and (>= g_jw_obj_control 10) (<= (ai_task_count "obj_jw_lower_covenant/lower_gate_00") 0) (<= (ai_task_count "obj_jw_lower_covenant/lower_gate_01") 0) (<= (ai_task_count "obj_jw_lower_covenant/lower_gate_02") 0) (<= (ai_task_count "obj_jw_lower_covenant/leftover_gate") 0)) (>= g_ta_obj_control 1)))
    (sleep (random_range 60 120))
    (if (= g_ta_obj_control 0)
        (begin
            (if debug
                (print "mission_dialogue : jungle_walk : post_combat")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010mc_050")
                    (set arbiter (vs_role 1))
                    (vs_cast "gr_marines" false 0 "010mc_010" "010mc_030")
                    (set marine_01 (vs_role 1))
                    (set marine_02 (vs_role 2))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010mc_010")
                    (set marine_01 (vs_role 1))
                    (vs_cast "gr_marines" false 0 "010mc_030")
                    (set marine_02 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (vs_enable_pathfinding_failsafe marine_02 true)
            (vs_enable_looking marine_02 true)
            (vs_enable_targeting marine_02 true)
            (vs_enable_moving marine_02 true)
            (sleep 1)
            (if dialogue
                (print "marine a: these brutes are tough")
            )
            (sleep (ai_play_line marine_01 010mc_010))
            (sleep 15)
            (if dialogue
                (print "marine b: grunts ain't no slouches either")
            )
            (sleep (ai_play_line marine_02 010mc_030))
            (sleep 15)
            (if (game_is_cooperative)
                (begin
                    (if dialogue
                        (print "marine b: maybe the brutes put something in their tanks?")
                    )
                    (sleep (ai_play_line marine_02 010mc_040))
                    (sleep 15)
                )
            )
            (if (>= (ai_living_count marine_02) 1)
                (begin
                    (if dialogue
                        (print "arbiter: the grunts' newfound courage is but fear.")
                    )
                    (sleep (ai_play_line arbiter 010mc_050))
                    (sleep 30)
                )
            )
            (if dialogue
                (print "arbiter: when we are victorious")
            )
            (sleep (ai_play_line arbiter 010mc_060))
            (sleep 15)
            (if dialogue
                (print "arbiter: all who serve the prophets will be punished!")
            )
            (sleep (ai_play_line arbiter 010mc_070))
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_gc_mar_sleepers
    (sleep_until (volume_test_players "tv_gc_ini_01"))
    (sleep (* 30 5.5))
    (if debug
        (print "mission_dialogue : grunt_camp : marine : sleepers")
    )
    (vs_cast "gr_marines" true 0 "010md_010")
    (set marine_01 (vs_role 1))
    (sleep 1)
    (vs_set_cleanup_script md_cleanup)
    (set g_playing_dialogue true)
    (ai_dialogue_enable false)
    (vs_enable_pathfinding_failsafe marine_01 true)
    (vs_enable_looking marine_01 true)
    (vs_enable_targeting marine_01 true)
    (vs_enable_moving marine_01 true)
    (sleep 1)
    (sleep_until (or (volume_test_objects "tv_gc_md_sleepers" marine_01) (> g_gc_obj_control 0)) 5)
    (if (and (= g_gc_obj_control 0) (<= (ai_combat_status "gr_gc_covenant") 4))
        (begin
            (if dialogue
                (print "marine: sleepers!")
            )
            (sleep (ai_play_line marine_01 010md_010))
            (sleep 15)
            (if dialogue
                (print "marine: take 'em out. nice and quiet!")
            )
            (sleep (ai_play_line marine_01 010md_020))
            (sleep 90)
        )
    )
    (set g_music_010_04 false)
    (set g_playing_dialogue false)
    (ai_dialogue_enable true)
)

(script dormant void md_gc_mar_jackals
    (sleep_until (or (and (not g_playing_dialogue) (>= g_gc_obj_control 1)) (and (not g_playing_dialogue) (volume_test_players "tv_gc_ini_03")) (>= g_gc_obj_control 4)))
    (if (<= g_gc_obj_control 3)
        (begin
            (if debug
                (print "mission_dialogue : grunt_camp : marine : jackals")
            )
            (vs_cast "gr_marines" true 0 "010md_030")
            (set marine_01 (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (<= (ai_combat_status "gr_gc_covenant") 4)
                (begin
                    (if dialogue
                        (print "marine: jackals! on the ridge!")
                    )
                    (sleep (ai_play_line marine_01 010md_030))
                    (sleep 15)
                    (if dialogue
                        (print "marine: stay low. looks like they've got carbines")
                    )
                    (sleep (ai_play_line marine_01 010md_040))
                    (sleep 15)
                    (sleep_until (>= (ai_combat_status "gr_gc_jackals") 5) 30 (* 30 2))
                    (if (>= (ai_combat_status "gr_gc_jackals") 5)
                        (begin
                            (if dialogue
                                (print "marine: i hate it when i'm right!")
                            )
                            (sleep (ai_play_line marine_01 010md_050))
                        )
                    )
                )
                (begin
                    (if dialogue
                        (print "marine: jackals! on the ridge!")
                    )
                    (sleep (ai_play_line marine_01 010md_060))
                    (sleep 15)
                    (if dialogue
                        (print "marine: they've got carbines!")
                    )
                    (sleep (ai_play_line marine_01 010md_070))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_gc_joh_enroute
    (sleep_until (or (and (not g_playing_dialogue) (>= g_gc_obj_control 6) (<= (ai_living_count "obj_gc_covenant") 0)) (>= g_pa_obj_control 1)))
    (if (= g_pa_obj_control 0)
        (begin
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (sleep (random_range 120 150))
            (if debug
                (print "mission_dialogue : grunt_camp : johnson : enroute")
            )
            (if dialogue
                (print "johnson: pelicans are en route, chief. but i can't raise bravo")
            )
            (sleep (ai_play_line_on_object none 010md_080))
            (sleep 15)
            (set g_music_010_05 true)
            (if dialogue
                (print "johnson: you find 'em? get 'em to the extraction point.")
            )
            (sleep (ai_play_line_on_object none 010md_090))
            (sleep 15)
            (sleep 60)
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_gc_post_combat
    (sleep_until (or (and (not g_playing_dialogue) (>= g_gc_obj_control 7) (<= (ai_living_count "obj_gc_covenant") 0)) (>= g_pa_obj_control 1)))
    (sleep (* 30 10))
    (if (= g_pa_obj_control 0)
        (begin
            (if debug
                (print "mission_dialogue : grunt_camp : post_combat")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010md_110")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010md_120")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (not (game_is_cooperative))
                (begin
                    (if dialogue
                        (print "arbiter: come. the landing zone is this way!")
                    )
                    (sleep (ai_play_line arbiter 010md_110))
                )
                (begin
                    (if dialogue
                        (print "marine: this way to the lz, chief!")
                    )
                    (sleep (ai_play_line marine_01 010md_120))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_pa_joh_company
    (sleep_until (or (and (not g_playing_dialogue) (>= g_pa_obj_control 9)) (>= g_ss_obj_control 1)))
    (sleep (* 30 5))
    (if (= g_ss_obj_control 0)
        (begin
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (if debug
                (print "mission_dialogue : path_a : johnson : company")
            )
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (if dialogue
                (print "johnson: chief? pelicans are at the river!")
            )
            (sleep (ai_play_line_on_object none 010me_010))
            (sleep 15)
            (if dialogue
                (print "johnson: we got company, so hustle up!")
            )
            (sleep (ai_play_line_on_object none 010me_020))
            (sleep 15)
            (set g_music_010_06_alt true)
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_pa_post_combat
    (sleep_until (or (and (not g_playing_dialogue) (>= g_pa_obj_control 4) (<= (ai_living_count "gr_pa_covenant") 0)) (>= g_pa_obj_control 8)))
    (sleep 90)
    (if (<= g_pa_obj_control 5)
        (begin
            (if debug
                (print "mission_dialogue : path_a : post_combat")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010me_040")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010me_050")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (= g_ss_obj_control 0)
                (begin
                    (if (not (game_is_cooperative))
                        (begin
                            (if dialogue
                                (print "arbiter: the river! hurry!")
                            )
                            (sleep (ai_play_line arbiter 010me_040))
                        )
                        (begin
                            (if dialogue
                                (print "marine: we gotta get to the river, chief!")
                            )
                            (sleep (ai_play_line marine_01 010me_050))
                        )
                    )
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_ss_turrets
    (sleep_until (or (and (not g_playing_dialogue) (>= g_ss_obj_control 4) (= (ai_combat_status "gr_ss_turrets") 8)) (>= g_ss_obj_control 8)))
    (if (and (<= g_ss_obj_control 7) (>= (ai_living_count "gr_ss_turrets") 1))
        (begin
            (if debug
                (print "mission_dialogue : substation : turrets")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010mf_050")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010mf_070")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (not (game_is_cooperative))
                (begin
                    (if dialogue
                        (print "arbiter: grunt! with a turret!")
                    )
                    (sleep (ai_play_line arbiter 010mf_050))
                    (sleep 15)
                    (if dialogue
                        (print "arbiter: you flank! i'll draw its fire!")
                    )
                    (sleep (ai_play_line arbiter 010mf_060))
                )
                (begin
                    (if dialogue
                        (print "marine: grunt! dropping a turret!")
                    )
                    (sleep (ai_play_line marine_01 010mf_070))
                    (sleep 15)
                    (if dialogue
                        (print "marine: we'll flank! chief, go right at it!")
                    )
                    (sleep (ai_play_line marine_01 010mf_080))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_ss_post_combat
    (sleep_until (or (and (not g_playing_dialogue) (>= g_ss_obj_control 9) (<= (ai_living_count "obj_ss_covenant") 0)) (>= g_pb_obj_control 1)))
    (if (= g_pb_obj_control 0)
        (begin
            (set g_playing_dialogue true)
            (sleep (random_range 45 75))
            (if debug
                (print "mission_dialogue : substation : post_combat")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010mf_140")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010mf_160")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (not (game_is_cooperative))
                (begin
                    (if dialogue
                        (print "arbiter: the banshees will return")
                    )
                    (sleep (ai_play_line arbiter 010mf_140))
                    (sleep 15)
                    (if dialogue
                        (print "arbiter: hurry! back into the jungle!")
                    )
                    (sleep (ai_play_line arbiter 010mf_150))
                )
                (begin
                    (if dialogue
                        (print "marine: banshees are gonna circle back")
                    )
                    (sleep (ai_play_line marine_01 010mf_160))
                    (sleep 15)
                    (if dialogue
                        (print "marine: let's head into the jungle, sir!")
                    )
                    (sleep (ai_play_line marine_01 010mf_170))
                )
            )
            (set g_music_010_075 true)
            (set g_music_010_065 false)
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (ai_set_objective "gr_allies" "obj_pb_allies")
    (if debug
        (print "set ally objective")
    )
    (game_save)
)

(script dormant void md_pb_move_forward
    (sleep_until (and g_pb_joh_alright (not g_playing_dialogue) (>= g_pb_obj_control 3)))
    (if (<= g_pb_obj_control 5)
        (begin
            (if debug
                (print "mission_dialogue : path_b : move_forward")
            )
            (if (not (game_is_cooperative))
                (begin
                    (vs_cast "gr_arbiter" true 0 "010mg_010")
                    (set arbiter (vs_role 1))
                )
                (begin
                    (vs_cast "gr_marines" true 0 "010mg_030")
                    (set marine_01 (vs_role 1))
                )
            )
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe "gr_arbiter" true)
            (vs_enable_looking "gr_arbiter" true)
            (vs_enable_targeting "gr_arbiter" true)
            (vs_enable_moving "gr_arbiter" true)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep 1)
            (if (not (game_is_cooperative))
                (begin
                    (if dialogue
                        (print "arbiter: let us move forward")
                    )
                    (sleep (ai_play_line arbiter 010mg_010))
                    (sleep 15)
                    (if dialogue
                        (print "arbiter: this ravine will lead us to your sergeant.")
                    )
                    (sleep (ai_play_line arbiter 010mg_020))
                )
                (begin
                    (if dialogue
                        (print "marine: keep going, chief")
                    )
                    (sleep (ai_play_line marine_01 010mg_030))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
    (game_save)
)

(script dormant void md_pb_joh_alright
    (sleep_until (>= g_pb_obj_control 1))
    (sleep (random_range 15 60))
    (if debug
        (print "mission_dialogue : substation : johnson : alright")
    )
    (vs_set_cleanup_script md_cleanup)
    (set g_playing_dialogue true)
    (if dialogue
        (print "johnson: (static) chief? can you hear me?")
    )
    (sleep (ai_play_line_on_object none 010mf_090))
    (sleep 60)
    (if dialogue
        (print "johnson: my bird's down. half a click down river from your position")
    )
    (sleep (ai_play_line_on_object none 010mf_100))
    (sleep 15)
    (set g_playing_dialogue false)
    (set g_pb_joh_alright true)
    (game_save)
)

(script dormant void md_pb_mar_jackals
    (sleep_until (and (not g_playing_dialogue) (>= g_pb_obj_control 2)))
    (if (<= g_pb_obj_control 2)
        (begin
            (if debug
                (print "mission_dialogue : path_b : marine : jackals")
            )
            (vs_cast "gr_marines" true 0 "010md_030")
            (set marine_01 (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (vs_enable_pathfinding_failsafe marine_01 true)
            (vs_enable_looking marine_01 true)
            (vs_enable_targeting marine_01 true)
            (vs_enable_moving marine_01 true)
            (sleep (random_range 30 60))
            (if (<= (ai_combat_status "gr_pb_covenant") 4)
                (begin
                    (if dialogue
                        (print "marine: jackals! on the ridge!")
                    )
                    (sleep (ai_play_line marine_01 010md_030))
                    (sleep 15)
                    (if dialogue
                        (print "marine: stay low. looks like they've got carbines")
                    )
                    (sleep (ai_play_line marine_01 010md_040))
                    (sleep 15)
                )
                (begin
                    (if dialogue
                        (print "marine: jackals! on the ridge!")
                    )
                    (sleep (ai_play_line marine_01 010md_060))
                    (sleep 15)
                    (if dialogue
                        (print "marine: they've got carbines!")
                    )
                    (sleep (ai_play_line marine_01 010md_070))
                )
            )
            (set g_playing_dialogue false)
            (ai_dialogue_enable true)
        )
    )
)

(script dormant void md_ba_pelican
    (sleep_until (volume_test_players "tv_ba_pelican"))
    (if debug
        (print "ambient : brute_ambush : pelican")
    )
    (sleep (random_range 45 75))
    (if dialogue
        (print "marine: echo five-one, this is crows nest!")
    )
    (sleep (ai_play_line_on_object "ba_pelican_radio" 010mx_160))
    (sleep 30)
    (if dialogue
        (print "marine: echo five-one, please respond!")
    )
    (sleep (ai_play_line_on_object "ba_pelican_radio" 010mx_170))
    (sleep 30)
    (if dialogue
        (print "marine: hocus. five-one is down. divert for emergency evac, over?")
    )
    (sleep (ai_play_line_on_object "ba_pelican_radio" 010mx_180))
    (set g_music_010_076 true)
)

(script dormant void md_ba_post_combat
    (sleep_until (or (and (not g_playing_dialogue) (>= g_ba_obj_control 4) (<= (ai_living_count "obj_ba_covenant") 0)) (>= g_dam_obj_control 1)))
    (sleep (random_range 30 90))
    (if (<= g_dam_obj_control 1)
        (begin
            (if debug
                (print "mission_dialogue : brute_ambush : bunkered_down")
            )
            (vs_cast "gr_marines" true 0 "010mx_190")
            (set marine_01 (vs_role 1))
            (sleep 1)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (if dialogue
                (print "marine: sergeant major went this way, chief! through the cave!")
            )
            (sleep (ai_play_line marine_01 010mx_190))
            (sleep 15)
            (ai_dialogue_enable true)
            (set g_playing_dialogue false)
        )
    )
)

(script dormant void md_dam_pelican_attack
    (sleep_until g_dam_pelican_arrive)
    (if debug
        (print "mission_dialogue : dam : pelican_attack")
    )
    (vs_cast "sq_dam_joh_marines" true 10 "010mi_090")
    (set johnson (vs_role 1))
    (sleep 1)
    (vs_enable_pathfinding_failsafe johnson true)
    (vs_enable_looking johnson true)
    (vs_enable_targeting johnson true)
    (vs_enable_moving johnson true)
    (if (or (>= (ai_living_count "sq_dam_phantom_03") 1) (>= (ai_living_count "sq_dam_phantom_04") 1))
        (begin
            (if dialogue
                (print "johnson (radio): hocus! phantom!")
            )
            (sleep (ai_play_line johnson 010mi_090))
            (sleep 10)
            (if dialogue
                (print "hocus (radio): i see him! standby!")
            )
            (sleep (ai_play_line_on_object none 010mi_100))
            (sleep 10)
            (sleep_until g_dam_pelican_attack01 1)
        )
    )
    (if (>= (ai_living_count "sq_dam_phantom_03") 1)
        (begin
            (sleep (random_range 30 45))
            (if dialogue
                (print "hocus (radio): going loud! everyone down!")
            )
            (sleep (ai_play_line_on_object none 010mi_080))
            (sleep 10)
            (sleep_until (<= (ai_living_count "sq_dam_phantom_03") 0) 1)
            (if dialogue
                (print "hocus (radio): scratch one phantom!")
            )
            (sleep (ai_play_line_on_object none 010mi_110))
            (sleep 10)
        )
    )
    (if (>= (ai_living_count "sq_dam_phantom_04") 1)
        (begin
            (sleep_until (<= (ai_living_count "sq_dam_phantom_04") 0) 1)
            (sleep (random_range 30 45))
            (if dialogue
                (print "hocus (radio): scratch two!")
            )
            (sleep (ai_play_line_on_object none 010mi_140))
        )
    )
)

(script dormant void md_dam_joh_pile_in
    (sleep_until g_johnson_pile_in)
    (sleep 90)
    (cs_run_command_script johnson abort)
    (sleep 1)
    (if debug
        (print "mission_dialogue : dam : johnson_pile_in")
    )
    (vs_cast "gr_allies" true 10 "010mi_150")
    (set johnson (vs_role 1))
    (vs_enable_pathfinding_failsafe johnson true)
    (vs_enable_looking johnson true)
    (vs_enable_targeting johnson true)
    (vs_enable_moving johnson true)
    (sleep 1)
    (vs_go_to_vehicle johnson false dam_pelican 21)
    (vs_set_cleanup_script md_cleanup)
    (set g_playing_dialogue true)
    (ai_dialogue_enable false)
    (if dialogue
        (print "johnson: that's the way to do it!")
    )
    (sleep (ai_play_line johnson 010mi_150))
    (sleep 10)
    (if dialogue
        (print "johnson: everyone pile in!")
    )
    (sleep (ai_play_line johnson 010mi_160))
    (sleep 10)
    (ai_dialogue_enable true)
    (cs_run_command_script johnson cs_dam_marines_to_pelican)
)

(script dormant void md_dam_joh_leave
    (sleep_until (or g_johnson_pile_in g_dam_player_in_pelican))
    (sleep (* 30 30))
    (cs_run_command_script johnson abort)
    (sleep 1)
    (if (not g_dam_player_in_pelican)
        (begin
            (if debug
                (print "mission_dialogue : dam : johson_leave")
            )
            (vs_cast "gr_allies" true 10 "010mi_170")
            (set johnson (vs_role 1))
            (vs_enable_pathfinding_failsafe johnson true)
            (vs_enable_looking johnson true)
            (vs_enable_targeting johnson true)
            (vs_enable_moving johnson true)
            (sleep 1)
            (vs_go_to_vehicle johnson false dam_pelican 21)
            (vs_set_cleanup_script md_cleanup)
            (set g_playing_dialogue true)
            (ai_dialogue_enable false)
            (if dialogue
                (print "johnson: come on, chief! commander keyes is waiting!")
            )
            (sleep (ai_play_line johnson 010mi_170))
            (sleep 10)
            (if dialogue
                (print "johnson: don't got no time to sight-see. let's go!")
            )
            (sleep (ai_play_line johnson 010mi_180))
            (sleep 10)
            (cs_run_command_script "gr_allies" cs_dam_marines_to_pelican)
            (sleep (* 30 15))
            (if (not g_dam_player_in_pelican)
                (begin
                    (vs_go_to_vehicle johnson false dam_pelican 21)
                    (if dialogue
                        (print "johnson: earth isn't gonna save itself, chief. step on up!")
                    )
                    (sleep (ai_play_line johnson 010mi_190))
                    (sleep 10)
                    (if dialogue
                        (print "johnson: do you, or do you not want to finish the fight?")
                    )
                    (sleep (ai_play_line johnson 010mi_200))
                    (sleep 10)
                    (cs_run_command_script "gr_allies" cs_dam_marines_to_pelican)
                )
            )
            (ai_dialogue_enable true)
            (cs_run_command_script johnson cs_dam_marines_to_pelican)
        )
    )
)

(script dormant void vs_jw_joh_phantom
    (sleep_until (>= g_jw_obj_control 3))
    (sleep (* 30 3))
    (if debug
        (print "vignette : jungle_walk : johnson : phantom")
    )
    (vs_cast "gr_arbiter" false 10 "")
    (set arbiter (vs_role 1))
    (vs_cast "gr_johnson_marines" false 10 "010mb_130")
    (set johnson (vs_role 1))
    (vs_cast "gr_johnson_marines" false 10 "" "" "")
    (set joh_marine_01 (vs_role 1))
    (set joh_marine_02 (vs_role 2))
    (set joh_marine_03 (vs_role 3))
    (vs_cast "gr_marines" false 10 "")
    (set sarge (vs_role 1))
    (vs_cast "gr_marines" false 10 "010mb_120" "" "")
    (set marine_01 (vs_role 1))
    (set marine_02 (vs_role 2))
    (set marine_03 (vs_role 3))
    (ai_disregard (ai_actors "sq_jw_phantom_01/phantom") true)
    (ai_disregard (ai_actors "sq_jw_phantom_05/phantom") true)
    (vs_enable_moving "gr_marines" true)
    (vs_enable_targeting "gr_marines" true)
    (vs_enable_moving "gr_arbiter" true)
    (vs_enable_targeting "gr_arbiter" true)
    (vs_enable_moving "gr_johnson_marines" true)
    (vs_enable_targeting "gr_johnson_marines" true)
    (if (<= g_jw_obj_control 3)
        (begin
            (if (volume_test_object "tv_jw_03" johnson)
                (vs_crouch johnson true)
            )
            (if (volume_test_object "tv_jw_03" joh_marine_01)
                (vs_crouch joh_marine_01 true)
            )
            (if (volume_test_object "tv_jw_03" joh_marine_02)
                (vs_crouch joh_marine_02 true)
            )
            (if (volume_test_object "tv_jw_03" joh_marine_03)
                (vs_crouch joh_marine_03 true)
            )
            (if (volume_test_object "tv_jw_03" sarge)
                (vs_crouch sarge true)
            )
            (if (volume_test_object "tv_jw_03" marine_01)
                (vs_crouch marine_01 true)
            )
            (if (volume_test_object "tv_jw_03" marine_02)
                (vs_crouch marine_02 true)
            )
            (if (volume_test_object "tv_jw_03" marine_03)
                (vs_crouch johnson true)
            )
            (if dialogue
                (print "marine (whisper): sergeant major! phantom inbound!")
            )
            (sleep (ai_play_line marine_01 010mb_120))
            (set g_music_010_03 true)
            (sleep (* 30 2))
        )
    )
    (if (>= g_jw_obj_control 4)
        (begin
            (vs_crouch "gr_marines" false)
            (vs_crouch "gr_johnson_marines" false)
        )
        (begin
            (if dialogue
                (print "johnson (whisper): we stick together, and we're gonna get spotted.")
            )
            (sleep (ai_play_line johnson 010mb_130))
            (sleep 20)
        )
    )
    (if (<= g_jw_obj_control 3)
        (begin
            (if dialogue
                (print "johnson (whisper): let's split up. meet back at the lz.")
            )
            (ai_play_line johnson 010mb_140)
        )
    )
    (if (<= g_jw_obj_control 3)
        (sleep 30)
    )
    (vs_crouch "gr_marines" false)
    (set g_jw_joh_phantom_mar false)
    (if (<= g_jw_obj_control 3)
        (sleep (* 30 2))
    )
    (if (<= g_jw_obj_control 3)
        (begin
            (vs_crouch johnson false)
            (vs_face_player johnson true)
            (vs_look_player johnson true)
            (sleep 30)
            (if (not (game_is_cooperative))
                (begin
                    (if dialogue
                        (print "johnson (whisper): chief, go with the arbiter. head toward the river.")
                    )
                    (ai_play_line johnson 010mb_150)
                )
                (begin
                    (if dialogue
                        (print "johnson (whisper): chief, you and the arbiter head toward the river.")
                    )
                    (ai_play_line johnson 010mb_160)
                )
            )
        )
    )
    (if (<= g_jw_obj_control 3)
        (sleep 30)
    )
    (set g_jw_joh_phantom_arb false)
    (player_control_scale_all_input 1 3)
    (if (<= g_jw_obj_control 3)
        (sleep 90)
    )
    (if (<= g_jw_obj_control 3)
        (begin
            (if dialogue
                (print "johnson: second squad, you're with me!")
            )
            (ai_play_line johnson 010mb_170)
        )
    )
    (vs_release joh_marine_01)
    (vs_release joh_marine_02)
    (vs_release joh_marine_03)
    (sleep 1)
    (cs_run_command_script joh_marine_01 cs_jw_climb_mar_01)
    (cs_run_command_script joh_marine_02 cs_jw_climb_mar_02)
    (cs_run_command_script joh_marine_03 cs_jw_climb_mar_03)
    (if (<= g_jw_obj_control 3)
        (vs_action johnson false "ps_jw/waterfall_johnson" ai_action_point)
    )
    (if (<= g_jw_obj_control 3)
        (sleep 30)
    )
    (vs_release johnson)
    (cs_run_command_script johnson cs_jw_climb_johnson)
    (set g_jw_joh_phantom_joh false)
)

(script command_script void cs_jw_climb_johnson
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw/joh00")
    (set g_jw_johnson_past true)
    (cs_go_to "ps_jw/mar02")
    (cs_go_to "ps_jw/mar00")
    (cs_go_to "ps_jw/ground_jon")
    (cs_face_player true)
    (sleep_until (>= g_jw_marines_climbing 3))
    (cs_face_player false)
    (sleep (random_range 60 75))
    (cs_go_to "ps_jw/ground_02")
    (cs_stow)
    (sleep 5)
    (biped_force_ground_fitting_on ai_current_actor true)
    (cs_custom_animation "objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall" "010vc_johnson_climb_var2" true "ps_jw/ground_02")
    (cs_stop_custom_animation)
    (biped_force_ground_fitting_on ai_current_actor false)
    (sleep 1)
    (cs_force_combat_status 3)
    (cs_draw)
    (cs_go_to "ps_jw/waterfall_johnson")
    (if (volume_test_players "tv_jw_climb_out")
        (begin
            (cs_face_player true)
            (cs_look_player true)
            (sleep 30)
            (if dialogue
                (print "johnson: keep an eye out for bravo team, chief.")
            )
            (cs_play_line 010mb_180)
            (sleep 10)
            (if dialogue
                (print "johnson: if the brutes do have our scent")
            )
            (cs_play_line 010mb_190)
            (sleep 10)
            (if dialogue
                (print "johnson: those boys are in a lot of trouble.")
            )
            (cs_play_line 010mb_200)
            (sleep 10)
            (cs_face_player false)
            (cs_look_player false)
        )
    )
    (cs_look_player false)
    (cs_go_to "ps_jw/climb_out")
    (ai_erase ai_current_actor)
)

(script command_script void cs_jw_climb_mar_01
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw/mar01")
    (cs_go_to "ps_jw/mar00")
    (cs_go_to "ps_jw/ground_01")
    (cs_stow)
    (sleep 5)
    (set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
    (biped_force_ground_fitting_on ai_current_actor true)
    (cs_custom_animation "objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall" "010vc_johnson_climb:var1" true "ps_jw/ground_01")
    (cs_stop_custom_animation)
    (biped_force_ground_fitting_on ai_current_actor false)
    (sleep 1)
    (cs_force_combat_status 3)
    (cs_draw)
    (cs_go_to "ps_jw/climb_out")
    (ai_erase ai_current_actor)
)

(script command_script void cs_jw_climb_mar_02
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw/mar02")
    (cs_go_to "ps_jw/mar00")
    (cs_go_to "ps_jw/ground_02")
    (cs_stow)
    (sleep 5)
    (set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
    (biped_force_ground_fitting_on ai_current_actor true)
    (cs_custom_animation "objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall" "010vc_johnson_climb_var2" true "ps_jw/ground_02")
    (cs_stop_custom_animation)
    (biped_force_ground_fitting_on ai_current_actor false)
    (sleep 1)
    (cs_force_combat_status 3)
    (cs_draw)
    (cs_go_to "ps_jw/climb_out")
    (ai_erase ai_current_actor)
)

(script command_script void cs_jw_climb_mar_03
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw/mar03")
    (cs_go_to "ps_jw/mar00")
    (cs_go_to "ps_jw/ground_03")
    (cs_stow)
    (sleep 5)
    (set g_jw_marines_climbing (+ g_jw_marines_climbing 1))
    (biped_force_ground_fitting_on ai_current_actor true)
    (cs_custom_animation "objects\characters\marine\cinematics\vignettes\010vc_climbing_wall\010vc_climbing_wall" "010vc_johnson_climb_var3" true "ps_jw/ground_03")
    (cs_stop_custom_animation)
    (biped_force_ground_fitting_on ai_current_actor false)
    (sleep 1)
    (cs_force_combat_status 3)
    (cs_draw)
    (cs_go_to "ps_jw/climb_out")
    (ai_erase ai_current_actor)
)

(script static void test_jw_climb
    (ai_erase_all)
    (sleep 1)
    (ai_place "sq_jw_johnson_marines")
    (sleep 1)
    (vs_cast "gr_johnson_marines" true 0 "010mb_130")
    (set johnson (vs_role 1))
    (vs_cast "gr_johnson_marines" true 0 "" "" "")
    (set joh_marine_01 (vs_role 1))
    (set joh_marine_02 (vs_role 2))
    (set joh_marine_03 (vs_role 3))
    (vs_teleport johnson "ps_jw/test04" "ps_jw/ground_jon")
    (vs_teleport joh_marine_01 "ps_jw/test01" "ps_jw/ground_01")
    (vs_teleport joh_marine_02 "ps_jw/test02" "ps_jw/ground_02")
    (vs_teleport joh_marine_03 "ps_jw/test03" "ps_jw/ground_03")
    (sleep 1)
    (vs_release_all)
    (sleep 1)
    (cs_run_command_script johnson cs_jw_climb_johnson)
    (cs_run_command_script joh_marine_01 cs_jw_climb_mar_01)
    (cs_run_command_script joh_marine_02 cs_jw_climb_mar_02)
    (cs_run_command_script joh_marine_03 cs_jw_climb_mar_03)
)

(script dormant void vs_jw_brute_squad
    (sleep_until (>= g_jw_obj_control 3))
    (vs_cast "sq_jw_u_cov_01/brute" true 10 "010mx_010")
    (set brute_01 (vs_role 1))
    (vs_cast "sq_jw_u_cov_01/grunt01" false 10 "010mx_020")
    (set grunt_01 (vs_role 1))
    (vs_cast "sq_jw_u_cov_01/grunt02" false 10 "")
    (set grunt_02 (vs_role 1))
    (vs_enable_pathfinding_failsafe brute_01 true)
    (vs_enable_pathfinding_failsafe grunt_01 true)
    (vs_enable_pathfinding_failsafe grunt_02 true)
    (vs_abort_on_damage brute_01 true)
    (vs_stow brute_01)
    (vs_posture_set brute_01 "act_guard_1" true)
    (sleep_until (>= g_jw_obj_control 4))
    (sleep_until (>= g_jw_obj_control 5) 5 g_jw_brute_sleep)
    (sleep (random_range 15 30))
    (vs_look_object brute_01 true grunt_01)
    (vs_abort_on_combat_status brute_01 8)
    (set g_jw_grunt_move true)
    (vs_force_combat_status grunt_01 3)
    (vs_force_combat_status grunt_02 3)
    (vs_go_to grunt_01 false "ps_jw_cov/grunt03_01")
    (vs_go_to grunt_02 false "ps_jw_cov/grunt04_01")
    (if dialogue
        (print "brute: spread out you whelps! find them!")
    )
    (sleep (ai_play_line brute_01 010mx_010))
    (sleep 15)
    (cs_run_command_script grunt_01 cs_jw_grunt_04)
    (cs_run_command_script grunt_02 cs_jw_grunt_03)
    (sleep_random)
    (set g_jw_brute01 true)
    (vs_posture_exit brute_01)
    (vs_go_to_and_posture brute_01 true "ps_jw_cov/brute02" "act_kneel_1")
    (vs_abort_on_alert brute_01 false)
    (vs_abort_on_damage brute_01 false)
    (vs_abort_on_combat_status brute_01 100)
    (sleep_until (>= (ai_combat_status "obj_jw_upper_covenant") 4) 1)
    (vs_posture_exit brute_01)
    (sleep 14)
    (vs_face_player brute_01 true)
    (vs_draw brute_01)
    (sleep 15)
    (vs_action_at_player brute_01 true ai_action_point)
)

(script command_script void cs_jw_grunt_01
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (sleep_until (or g_jw_grunt_move (>= g_jw_obj_control 6) (>= (ai_combat_status "sq_jw_u_cov_01/brute") 4)) 5)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt01_01")
    (sleep_random)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (sleep_random)
    (cs_go_to "ps_jw_cov/grunt01_02")
    (sleep_random)
    (sleep_random)
)

(script command_script void cs_jw_grunt_02
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (sleep_until (or g_jw_grunt_move (>= g_jw_obj_control 6) (>= (ai_combat_status "sq_jw_u_cov_01/brute") 4)) 5)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt02_01")
    (sleep_random)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (sleep_random)
    (cs_go_to "ps_jw_cov/grunt02_02")
    (sleep_random)
    (sleep_random)
    (cs_go_to "ps_jw_cov/grunt02_03")
    (sleep_random)
)

(script command_script void cs_jw_grunt_03
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt03_01")
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (sleep_random)
    (if (<= (game_difficulty_get) normal)
        (cs_go_to "ps_jw_cov/grunt03_02")
    )
    (sleep_until g_null)
)

(script command_script void cs_jw_grunt_04
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt04_01")
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (sleep_random)
    (if (<= (game_difficulty_get) normal)
        (cs_go_to "ps_jw_cov/grunt04_02")
    )
    (sleep_until g_null)
)

(script command_script void cs_jw_grunt_05
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (sleep_until (or g_jw_grunt_move (>= g_jw_obj_control 6) (>= (ai_combat_status "sq_jw_u_cov_01/brute") 4)) 5)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt05_01")
    (sleep_random)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (sleep_random)
    (cs_go_to "ps_jw_cov/grunt05_02")
    (sleep_random)
    (sleep_random)
    (cs_go_to "ps_jw_cov/grunt05_03")
    (sleep_random)
)

(script command_script void cs_jw_grunt_06
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (sleep_until (or g_jw_grunt_move (>= g_jw_obj_control 6) (>= (ai_combat_status "sq_jw_u_cov_01/brute") 4)) 5)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt06_01")
    (sleep_random)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_go_to "ps_jw_cov/grunt06_02")
    (sleep_random)
)

(script command_script void cs_jw_grunt_07
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_abort_on_damage true)
    (sleep_until (or g_jw_grunt_move (>= g_jw_obj_control 6) (>= (ai_combat_status "sq_jw_u_cov_01/brute") 4)) 5)
    (cs_abort_on_combat_status 8)
    (cs_go_to "ps_jw_cov/grunt07_01")
    (sleep_random)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_go_to "ps_jw_cov/grunt07_02")
    (sleep_random)
)

(script dormant void vs_pa_brute_slam
    (if debug
        (print "vignette : path_a : brute_slam")
    )
    (if debug
        (print "casting call...")
    )
    (vs_cast "sq_pa_vs_marines/slam" false 0 "010va_030")
    (set sarge (vs_role 1))
    (vs_cast "sq_pa_cov_01/brute" true 0 "010va_010")
    (set brute_01 (vs_role 1))
    (set obj_sarge sarge)
    (ai_cannot_die sarge true)
    (vs_abort_on_damage brute_01 true)
    (vs_set_cleanup_script vs_pa_brute_slam_cleanup)
    (vs_enable_dialogue sarge true)
    (vs_stow brute_01)
    (sleep 1)
    (vs_custom_animation_loop sarge "objects\characters\marine\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine" "010va_vict_idle" false "ps_pa/slam")
    (vs_custom_animation_loop brute_01 "objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine" "010va_exec_idle" false "ps_pa/slam")
    (sleep_until (or (>= g_pa_obj_control 1) (>= (ai_combat_status "obj_pa_covenant") 4)) 5 (* 30 10))
    (if (and (<= g_pa_obj_control 1) (>= (ai_combat_status "obj_pa_covenant") 4))
        (sleep (random_range 30 45))
    )
    (if dialogue
        (print "brute: tell me its location")
    )
    (vs_play_line brute_01 true 010va_010)
    (sleep 15)
    (if dialogue
        (print "sergeant: kiss. my. ass.")
    )
    (vs_play_line sarge true 010va_030)
    (ai_cannot_die sarge false)
    (vs_abort_on_damage brute_01 false)
    (vs_custom_animation_death sarge false "objects\characters\marine\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine" "010va_vict_kill" true "ps_pa/slam")
    (vs_custom_animation brute_01 false "objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine" "010va_exec_kill" true "ps_pa/slam")
    (sleep 5)
    (if dialogue
        (print "brute: (angry roar)")
    )
    (vs_play_line brute_01 false 010md_130)
    (sleep_until (not (vs_running_atom brute_01)) 1)
    (vs_abort_on_damage brute_01 true)
    (vs_custom_animation brute_01 false "objects\characters\brute\cinematics\vignettes\0x0vb_brute_throw_marine\0x0vb_brute_throw_marine" "010va_exec_post_kill" true "ps_pa/slam")
    (if dialogue
        (print "brute: (angry roar)")
    )
    (vs_play_line brute_01 false 010md_130)
    (begin_random
        (begin
            (ai_activity_abort "sq_pa_cov_01/grunt_01")
            (sleep (random_range 0 5))
        )
        (begin
            (ai_activity_abort "sq_pa_cov_01/grunt_02")
            (sleep (random_range 0 5))
        )
        (begin
            (ai_activity_abort "sq_pa_cov_01/grunt_03")
            (sleep (random_range 0 5))
        )
    )
    (sleep_until (not (vs_running_atom brute_01)))
    (vs_stop_custom_animation brute_01)
)

(script static void vs_pa_brute_slam_cleanup
    (if debug
        (print "brute slam cleanup script")
    )
    (vs_stop_custom_animation brute_01)
    (vs_stop_custom_animation sarge)
    (sleep 1)
    (damage_object sarge "" 10)
    (ai_play_line sarge )
    (vs_reserve brute_01 true 0)
    (sleep 1)
    (ai_cannot_die sarge false)
    (vs_draw brute_01)
    (wake md_pa_sarge)
)

(script dormant void md_pa_sarge
    (vs_cast "sq_pa_vs_marines/slam" true 0 "010va_030")
    (set sarge (vs_role 1))
    (vs_enable_pathfinding_failsafe sarge true)
    (vs_force_combat_status sarge 3)
    (vs_go_to sarge true "ps_pa/ar01")
    (vs_crouch sarge true)
    (sleep 15)
    (unit_add_equipment sarge "marine_ar" true true)
    (object_destroy "pa_ar")
    (sleep 5)
    (vs_crouch sarge false)
    (print "disregard")
    (ai_disregard (ai_actors "sq_pa_vs_marines/slam") false)
    (vs_enable_moving sarge true)
    (vs_enable_targeting sarge true)
    (sleep_until (or (>= g_pa_obj_control 3) (and (<= (ai_task_count "obj_pa_covenant/bottom_cov_02") 0) (<= (ai_task_count "obj_pa_covenant/jackal_ini_gate") 0))))
    (if (<= g_pa_obj_control 2)
        (begin
            (sleep (random_range 45 60))
            (vs_aim_player sarge true)
            (vs_approach_player sarge true 3 20 20)
            (if dialogue
                (print "sergeant: brute chieftain. phantom.")
            )
            (vs_play_line sarge true 010md_140)
            (sleep 15)
            (if dialogue
                (print "sergeant: pinned us down. killed my men.")
            )
            (vs_play_line sarge true 010md_150)
            (vs_aim_player sarge false)
        )
    )
)

(script static void test_pa_brute_slam
    (ai_place "sq_pa_cov_01")
    (ai_place "sq_pa_vs_marines")
    (ai_disregard (ai_actors "sq_pa_vs_marines") true)
    (sleep 1)
    (wake vs_pa_brute_slam)
)

(script dormant void vs_ss_banshee_ambush
    (sleep 10)
    (if debug
        (print "vignette : substation : banshee_ambush")
    )
    (set ss_pelican_01 (ai_vehicle_get_from_starting_location "sq_ss_pelican_01/pilot"))
    (set ss_pelican_02 (ai_vehicle_get_from_starting_location "sq_ss_pelican_02/pilot"))
    (sleep 1)
    (ai_cannot_die "sq_ss_pelican_02/johnson" true)
    (custom_animation_relative_loop ss_pelican_01 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican1_loop" false "ss_pelican_anchor")
    (custom_animation_relative_loop ss_pelican_02 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican2_loop" false "ss_pelican_anchor")
    (vs_cast "sq_ss_pelican_02" false 0 "010vb_010")
    (set johnson (vs_role 1))
    (objects_attach (ai_vehicle_get_from_starting_location "sq_ss_pelican_02/pilot") "machinegun_turret" (ai_vehicle_get_from_starting_location "sq_ss_pelican_02/johnson") "")
    (object_cannot_take_damage (ai_vehicle_get_from_starting_location "sq_ss_pelican_02/johnson"))
    (object_cannot_take_damage (ai_get_object "sq_ss_pelican_02/johnson"))
    (vs_enable_targeting johnson true)
    (vs_enable_looking johnson true)
    (sleep_until (>= g_ss_obj_control 1))
    (sleep_until (or (>= g_ss_obj_control 3) (<= (ai_task_count "obj_ss_covenant/d_cov_01") 1)) 5 (* 30 30))
    (ai_place "sq_ss_banshees")
    (if dialogue
        (print "pilot 02: hold on got a contact")
    )
    (sleep (ai_play_line_on_object none 010vb_050))
    (sleep 90)
    (if dialogue
        (print "pilot 02: banshees! fast and low!")
    )
    (sleep (ai_play_line_on_object none 010vb_060))
    (sleep 15)
    (if dialogue
        (print "pilot 01: break-off! now!")
    )
    (ai_play_line_on_object none 010vb_070)
    (sleep_until g_ss_pelican01_hit 1)
    (if debug
        (print "pelican 01 hit animation")
    )
    (custom_animation_relative ss_pelican_01 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican1_1" true "ss_pelican_anchor")
    (wake md_ss_pelican01_hit)
    (sleep_until g_ss_pelican02_hit 1)
    (if debug
        (print "pelican 02 hit animation")
    )
    (custom_animation_relative ss_pelican_02 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican2_1" true "ss_pelican_anchor")
    (set g_music_010_06 false)
    (if dialogue
        (print "pilot 02: lost a thruster! hang on!")
    )
    (sleep (ai_play_line_on_object none 010vb_110))
    (sleep 15)
    (if dialogue
        (print "johnson: get a hold of her!")
    )
    (vs_play_line johnson true 010vb_120)
    (sleep 10)
    (if dialogue
        (print "pilot 02: negative! we're going down!")
    )
    (ai_play_line_on_object none 010vb_130)
    (if (and (>= (game_difficulty_get) heroic) (<= g_ss_obj_control 4))
        (ai_place "sq_ss_phantom_01")
    )
    (sleep (unit_get_custom_animation_time ss_pelican_01))
    (vs_release pilot_01)
    (sleep 1)
    (if debug
        (print "erasing pelican 01")
    )
    (ai_erase "sq_ss_pelican_01")
    (sleep (unit_get_custom_animation_time ss_pelican_02))
    (set g_ss_banshee_ambush true)
    (sleep 1)
    (wake obj_locate_pelican_set)
    (if debug
        (print "erasing pelican 02")
    )
    (ai_erase "sq_ss_pelican_02")
)

(script dormant void md_ss_pelican01_hit
    (sleep 20)
    (if dialogue
        (print "pilot 01: i'm hit! i'm hit!")
    )
    (ai_play_line_on_object none 010vb_080)
    (sleep 15)
    (set g_music_010_05 false)
    (if dialogue
        (print "pilot 01: watch yourself!")
    )
    (ai_play_line_on_object none 010vb_090)
    (sleep 5)
    (if dialogue
        (print "pilot 01: (death scream)")
    )
    (ai_play_line_on_object none 010vb_100)
)

(script command_script void cs_ss_banshee_01
    (set ss_banshee_01 (ai_vehicle_get_from_starting_location "sq_ss_banshees/banshee01"))
    (sleep 1)
    (object_cannot_take_damage ss_banshee_01)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_banshee/b1_0")
    (cs_fly_by "ps_ss_banshee/b1_1")
    (cs_vehicle_boost false)
    (cs_shoot_point true "ps_ss_banshee/b1_shoot")
    (cs_fly_by "ps_ss_banshee/b1_2")
    (cs_shoot_point false "ps_ss_banshee/b1_shoot")
    (sleep 1)
    (cs_shoot_point true "ps_ss_banshee/b1_shoot")
    (cs_shoot_secondary_trigger true)
    (sleep 32)
    (set g_ss_pelican01_hit true)
    (cs_fly_by "ps_ss_banshee/b1_3")
    (cs_shoot_point false "ps_ss_banshee/b1_shoot")
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_banshee/b1_4" 5)
    (cs_fly_by "ps_ss_banshee/b1_5" 5)
    (cs_fly_by "ps_ss_banshee/b1_6" 5)
    (cs_fly_by "ps_ss_banshee/b1_7" 5)
    (cs_fly_by "ps_ss_banshee/b1_erase" 2)
    (ai_erase ai_current_actor)
)

(script command_script void cs_ss_banshee_02
    (set ss_banshee_02 (ai_vehicle_get_from_starting_location "sq_ss_banshees/banshee02"))
    (vehicle_hover ai_current_actor true)
    (sleep 150)
    (vehicle_hover ai_current_actor false)
    (object_cannot_take_damage ss_banshee_02)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_banshee/b2_0")
    (cs_fly_by "ps_ss_banshee/b2_1")
    (cs_vehicle_boost false)
    (cs_shoot_point true "ps_ss_banshee/b2_shoot")
    (cs_fly_by "ps_ss_banshee/b2_2")
    (cs_shoot_point false "ps_ss_banshee/b2_shoot")
    (sleep 1)
    (cs_shoot_point true "ps_ss_banshee/b2_shoot")
    (cs_shoot_secondary_trigger true)
    (sleep 45)
    (set g_ss_pelican02_hit true)
    (cs_fly_by "ps_ss_banshee/b2_3")
    (cs_shoot_point false "ps_ss_banshee/b2_shoot")
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_banshee/b2_4" 5)
    (cs_fly_by "ps_ss_banshee/b2_5" 5)
    (cs_fly_by "ps_ss_banshee/b2_6" 5)
    (cs_fly_by "ps_ss_banshee/b2_7" 5)
    (cs_fly_by "ps_ss_banshee/b2_erase" 2)
    (ai_erase ai_current_actor)
)

(script static void test_ss_banshee_ambush
    (ai_place "sq_ss_pelican_01")
    (ai_place "sq_ss_pelican_02")
    (ai_place "sq_ss_cov_01")
    (ai_place "sq_ss_cov_02")
    (ai_place "sq_ss_cov_03")
    (sleep 1)
    (wake vs_ss_banshee_ambush)
    (set g_ss_obj_control 4)
)

(script static void test_ss_banshees
    (ai_place "sq_ss_banshees/banshee01")
    (ai_place "sq_ss_banshees/banshee02")
    (sleep 1)
    (set ss_banshee_01 (ai_vehicle_get_from_starting_location "sq_ss_banshees/banshee01"))
    (set ss_banshee_02 (ai_vehicle_get_from_starting_location "sq_ss_banshees/banshee02"))
)

(script static void test_ss_pelicans
    (ai_place "sq_ss_pelican_01")
    (ai_place "sq_ss_pelican_02")
    (sleep 1)
    (set ss_pelican_01 (ai_vehicle_get_from_starting_location "sq_ss_pelican_01/pilot"))
    (set ss_pelican_02 (ai_vehicle_get_from_starting_location "sq_ss_pelican_02/pilot"))
    (sleep 10)
    (unit_open ss_pelican_01)
    (unit_open ss_pelican_02)
    (vs_look pilot_01 true "ps_ss_pelican/pel01_look")
    (vs_look pilot_02 true "ps_ss_pelican/pel02_look")
    (vs_enable_moving pilot_01 true)
    (vs_enable_moving pilot_02 true)
    (custom_animation_relative_loop ss_pelican_01 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican1_loop" false "ss_pelican_anchor")
    (custom_animation_relative_loop ss_pelican_02 "objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash" "pelican2_loop" false "ss_pelican_anchor")
)

(script dormant void vs_ba_joh_dumb_apes
    (sleep 5)
    (if debug
        (print "vignette : brute_ambush : johnson : dumb_apes")
    )
    (vs_cast "gr_johnson_marines" true 10 "010mh_010")
    (set johnson (vs_role 1))
    (vs_enable_pathfinding_failsafe "gr_johnson_marines" true)
    (vs_enable_looking "gr_johnson_marines" true)
    (vs_enable_targeting "gr_johnson_marines" true)
    (vs_force_combat_status johnson 3)
    (ai_cannot_die johnson true)
    (vs_aim johnson true "ps_ba/joh_look")
    (sleep_until (volume_test_players "tv_ba_ledge") 1 (* 30 30))
    (set g_ba_dumb_apes_continue true)
    (if dialogue
        (print "johnson: come on, you dumb apes!")
    )
    (ai_play_line johnson 010mh_010)
    (vs_go_to johnson true "ps_ba/joh1")
    (if dialogue
        (print "johnson: you want breakfast, you gotta catch it!")
    )
    (ai_play_line johnson 010mh_020)
    (sleep 15)
    (set g_ba_marine_03 true)
    (vs_aim johnson true "ps_dam_ba/joh_exit")
    (vs_go_to johnson true "ps_ba/joh2")
    (vs_go_to johnson true "ps_ba/joh3")
    (set g_ba_johnson_objective true)
    (vs_go_to johnson true "ps_ba/joh4")
    (set g_ba_phantom_stop true)
    (vs_go_to johnson true "ps_dam_ba/joh_exit")
    (ai_erase johnson)
)

(script command_script void cs_ba_marine_01
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_force_combat_status 3)
    (ai_cannot_die ai_current_actor true)
    (cs_aim true "ps_ba/joh_look")
    (sleep_until g_ba_dumb_apes_continue 5)
    (ai_cannot_die ai_current_actor false)
    (cs_go_to "ps_ba/mar01_02")
    (sleep (random_range 0 15))
    (cs_grenade "ps_ba/gr01" 1)
    (sleep (random_range 0 15))
    (cs_aim true "ps_dam_ba/joh_exit")
    (cs_go_to "ps_ba/joh2")
    (cs_go_to "ps_ba/joh3")
    (cs_go_to "ps_ba/joh4")
    (set g_ba_phantom_stop true)
    (cs_go_to "ps_dam_ba/joh_exit")
    (ai_erase ai_current_actor)
)

(script command_script void cs_ba_marine_02
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_force_combat_status 3)
    (ai_cannot_die ai_current_actor true)
    (cs_aim true "ps_ba/joh_look")
    (sleep_until g_ba_dumb_apes_continue 5)
    (ai_cannot_die ai_current_actor false)
    (cs_go_to "ps_ba/mar02_02")
    (sleep (random_range 0 15))
    (cs_grenade "ps_ba/gr02" 1)
    (sleep (random_range 0 15))
    (cs_aim true "ps_dam_ba/joh_exit")
    (cs_go_to "ps_ba/joh2")
    (cs_go_to "ps_ba/joh3")
    (cs_go_to "ps_ba/joh4")
    (set g_ba_phantom_stop true)
    (cs_go_to "ps_dam_ba/joh_exit")
    (ai_erase ai_current_actor)
)

(script command_script void cs_ba_marine_03
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_enable_moving true)
    (cs_force_combat_status 3)
    (ai_cannot_die ai_current_actor true)
    (cs_crouch true)
    (sleep_until g_ba_marine_03 5)
    (sleep (random_range 5 20))
    (ai_cannot_die ai_current_actor false)
    (cs_crouch false)
    (cs_go_to "ps_ba/joh2")
    (cs_go_to "ps_ba/joh3")
    (cs_go_to "ps_ba/joh4")
    (set g_ba_phantom_stop true)
    (cs_go_to "ps_dam_ba/joh_exit")
    (ai_erase ai_current_actor)
)

(script command_script void cs_ba_joh_brute
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_force_combat_status 3)
    (cs_go_to "ps_ba/br00")
    (sleep_until g_ba_dumb_apes_continue 5)
    (sleep (random_range 30 45))
    (cs_go_to "ps_ba/br01")
    (sleep (random_range 30 45))
    (cs_grenade "ps_ba/br_gr01" 1)
    (sleep 75)
    (cs_go_to "ps_ba/joh1")
    (cs_go_to "ps_ba/joh2")
    (sleep 75)
    (cs_face true "ps_dam_ba/joh_exit")
    (cs_go_to "ps_ba/joh3")
    (cs_go_to "ps_ba/joh4")
)

(script command_script void cs_ba_joh_grunts
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_force_combat_status 3)
    (cs_go_to "ps_ba/gr00")
    (sleep_until g_ba_dumb_apes_continue 5)
    (sleep (random_range 30 45))
    (cs_go_to "ps_ba/joh1")
    (cs_go_to "ps_ba/joh2")
    (cs_go_to "ps_ba/joh3")
    (cs_go_to "ps_ba/joh4")
)

(script command_script void cs_ba_ph01_shoot
    (cs_force_combat_status 3)
    (sleep_until 
        (begin
            (begin_random
                (if g_ba_ph01_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot01")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot01")
                        (set g_ba_ph01_shoot_loop false)
                    )
                )
                (if g_ba_ph01_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot02")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot02")
                        (set g_ba_ph01_shoot_loop false)
                    )
                )
                (if g_ba_ph01_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot03")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot03")
                        (set g_ba_ph01_shoot_loop false)
                    )
                )
                (if g_ba_ph01_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot04")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot04")
                        (set g_ba_ph01_shoot_loop false)
                    )
                )
            )
            (set g_ba_ph01_shoot_loop true)
            g_ba_phantom_stop
        )
    )
)

(script command_script void cs_ba_ph02_shoot
    (cs_force_combat_status 3)
    (sleep_until 
        (begin
            (begin_random
                (if g_ba_ph02_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot01")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot01")
                        (set g_ba_ph02_shoot_loop false)
                    )
                )
                (if g_ba_ph02_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot02")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot02")
                        (set g_ba_ph02_shoot_loop false)
                    )
                )
                (if g_ba_ph02_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot03")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot03")
                        (set g_ba_ph02_shoot_loop false)
                    )
                )
                (if g_ba_ph02_shoot_loop
                    (begin
                        (cs_shoot_point true "ps_ba/ph_shoot04")
                        (sleep (random_range 45 75))
                        (cs_shoot_point false "ps_ba/ph_shoot04")
                        (set g_ba_ph02_shoot_loop false)
                    )
                )
            )
            (set g_ba_ph02_shoot_loop true)
            g_ba_phantom_stop
        )
    )
)

(script static void test_ba_dumb_apes
    (ai_place "sq_ba_johnson_marines")
    (ai_place "sq_ba_cov_01")
    (ai_place "sq_ba_phantom_01")
    (ai_place "sq_ba_phantom_02")
    (sleep 5)
    (wake vs_ba_joh_dumb_apes)
)

(script dormant void 010pb_johnson_captured
    (sleep_until (>= g_dam_obj_control 1) 1)
    (if debug
        (print "perspective : dam : johnson_captured")
    )
    (if (not (game_is_cooperative))
        (begin
            (vs_cast "gr_arbiter" false 10 "")
            (set arbiter (vs_role 1))
        )
    )
    (set obj_arbiter arbiter)
    (cs_run_command_script "gr_marines" cs_dam_marines_approach)
    (ai_set_blind "gr_covenant" true)
    (ai_set_deaf "gr_covenant" true)
    (player_control_lock_gaze (player0) "ps_dam/phantom" 40)
    (player_control_lock_gaze (player1) "ps_dam/phantom" 40)
    (player_control_lock_gaze (player2) "ps_dam/phantom" 40)
    (player_control_lock_gaze (player3) "ps_dam/phantom" 40)
    (player_control_scale_all_input 0.25 0.5)
    (perspective_start)
    (sleep 5)
    (wake chapter_favor)
    (010pa_jail_bait)
    (fade_out 0 0 0 0)
    (set perspective_running false)
    (object_teleport (player0) "010pa_player0")
    (object_teleport (player1) "010pa_player1")
    (object_teleport (player2) "010pa_player2")
    (object_teleport (player3) "010pa_player3")
    (player0_set_pitch g_player_start_pitch 0)
    (player1_set_pitch g_player_start_pitch 0)
    (player2_set_pitch g_player_start_pitch 0)
    (player3_set_pitch g_player_start_pitch 0)
    (sleep 1)
    (prepare_to_switch_to_zone_set "set_dam")
    (vs_teleport arbiter "ps_dam/010pa_arb_teleport" "ps_dam/jail_hover")
    (vs_release "gr_arbiter")
    (ai_set_blind "gr_covenant" false)
    (ai_set_deaf "gr_covenant" false)
    (object_create_containing "eq_dam_cover")
    (if (or perspective_finished chapter_finished)
        (cinematic_fade_to_gameplay)
        (perspective_skipped)
    )
    (wake obj_get_to_johnson_clear)
    (wake obj_rescue_johnson_set)
    (set g_010pb_finished true)
)

(script dormant void vs_dam_jail_bait
    (ai_cannot_die "sq_dam_joh_marines/johnson" true)
    (ai_cannot_die "sq_dam_chieftain/chieftain" true)
    (sleep_until (>= g_dam_obj_control 1) 1)
    (vs_cast "sq_dam_joh_marines/johnson" true 10 "")
    (set johnson (vs_role 1))
    (vs_cast "sq_dam_chieftain/chieftain" true 10 "")
    (set chieftain (vs_role 1))
    (sleep 45)
    (vs_custom_animation chieftain false "objects\characters\brute\cinematics\perspectives\010pa_jail_bait\010pa_jail_bait" "010pa_brute_guard_1" false "ps_dam/010pa_brute")
    (vs_custom_animation johnson true "objects\characters\marine\cinematics\perspectives\010pa_jail_bait\010pa_jail_bait" "010pa_johnson_1" false "ps_dam/010pa_brute")
    (vs_stop_custom_animation chieftain)
    (vs_release chieftain)
    (cs_run_command_script "sq_dam_bodyguards" abort)
    (sleep 1)
    (ai_cannot_die "sq_dam_chieftain/chieftain" false)
    (vs_teleport johnson "ps_dam/johnson" "ps_dam/jail_hover")
    (sleep 5)
    (vs_posture_set johnson "act_captured_kneel" false)
    (sleep 120)
    (device_set_position "dam_jail" 1)
    (sleep 60)
    (device_group_change_only_once_more_set "dg_cov_dam_generator" true)
    (sleep_until (>= g_dam_obj_control 8) 1)
)

(script dormant void vs_dam_jail_rescue
    (sleep_until (>= g_dam_obj_control 8) 1)
    (vs_cast "sq_dam_joh_marines/johnson" true 20 "")
    (set johnson (vs_role 1))
    (sleep (random_range 15 45))
    (if (= (device_group_get "dg_cov_dam_generator") 1)
        (begin
            (if dialogue
                (print "johnson: this isn't as fun as it looks. cut the power!")
            )
            (sleep (ai_play_line johnson 010mx_210))
        )
    )
    (set g_dam_prisoners_speak true)
    (sleep_until (<= (device_group_get "dg_cov_dam_generator") 0) 1)
    (sleep (random_range 5 15))
    (wake obj_rescue_johnson_clear)
    (ai_disregard (ai_actors "sq_dam_joh_marines") false)
    (ai_set_blind "sq_dam_joh_marines" false)
    (ai_set_deaf "sq_dam_joh_marines" false)
    (set g_dam_prisoners_free true)
    (set g_dam_place_phantom_03 true)
    (sleep (random_range 30 45))
    (vs_posture_exit johnson)
    (if dialogue
        (print "johnson: i guess we're even as long as we're only counting today.")
    )
    (ai_play_line johnson 010mi_020)
    (sleep 45)
    (set g_dam_follow_objective true)
    (ai_dialogue_enable false)
    (vs_enable_pathfinding_failsafe johnson true)
    (vs_movement_mode johnson 2)
    (vs_go_to johnson false "ps_dam/joh_00")
    (sleep 90)
    (if dialogue
        (print "johnson (radio): kilo two three, what's your eta?")
    )
    (ai_play_line johnson 010mi_030)
    (vs_go_to johnson true "ps_dam/joh_01")
    (sleep 5)
    (unit_add_equipment johnson "marine_needler" true true)
    (vs_enable_targeting johnson true)
    (vs_enable_moving johnson true)
    (sleep 75)
    (if dialogue
        (print "hocus (radio): imminent, sergeant.")
    )
    (sleep (ai_play_line_on_object none 010mi_040))
    (sleep 10)
    (if dialogue
        (print "hocus (radio): find some cover. gotta clear a path!")
    )
    (sleep (ai_play_line_on_object none 010mi_050))
    (sleep 10)
    (if dialogue
        (print "johnson (radio): roger that, hocus.")
    )
    (sleep (ai_play_line johnson 010mi_060))
    (sleep 10)
    (if dialogue
        (print "johnson: friendly gunship! coming in hot!")
    )
    (sleep (ai_play_line johnson 010mi_070))
    (sleep 10)
    (ai_set_objective "gr_allies" "obj_dam_allies")
    (ai_dialogue_enable true)
    (wake obj_extraction_set)
    (set g_music_010_08 true)
    (game_save)
)

(script command_script void cs_dam_ini_chieftain
    (sleep 1)
    (sleep_until g_null)
)

(script command_script void cs_dam_marines_approach
    (cs_approach_player 5 40 40)
    (cs_face_player true)
    (sleep 5)
    (cs_crouch true)
    (sleep_until g_010pb_finished)
    (cs_run_command_script "gr_marines" abort)
)

(script command_script void cs_dam_mar_01
    (cs_enable_dialogue true)
    (sleep_until g_dam_prisoners_free 1)
    (sleep (random_range 30 90))
    (cs_posture_exit)
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_go_to "ps_dam/fem_01")
    (sleep 5)
    (unit_add_equipment "sq_dam_joh_marines/mar_01" "marine_carbine" true true)
    (sleep 5)
    (cs_face_object false "jail_crate02")
)

(script command_script void cs_dam_mar_02
    (cs_enable_dialogue true)
    (sleep_until g_dam_prisoners_speak 1)
    (sleep (random_range 30 60))
    (if (= (device_group_get "dg_cov_dam_generator") 1)
        (begin
            (if dialogue
                (print "marine: brutes were gonna gut us, sir!")
            )
            (cs_play_line 010mx_230)
            (sleep 15)
        )
    )
    (sleep_until g_dam_prisoners_free 1)
    (sleep (random_range 30 90))
    (cs_posture_exit)
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_go_to "ps_dam/fem_02")
    (sleep 5)
    (unit_add_equipment "sq_dam_joh_marines/mar_02" "marine_spike" true true)
    (sleep 5)
    (cs_face_object false "jail_crate03")
)

(script command_script void cs_dam_mar_03
    (cs_enable_dialogue true)
    (sleep_until g_dam_prisoners_free 1)
    (sleep (random_range 30 90))
    (cs_posture_exit)
    (cs_enable_pathfinding_failsafe true)
    (cs_movement_mode ai_movement_combat)
    (cs_go_to "ps_dam/mar_01")
    (sleep 5)
    (unit_add_equipment "sq_dam_joh_marines/mar_03" "marine_spike" true true)
    (sleep 5)
    (cs_face_object false "jail_crate02")
)

(script command_script void cs_dam_chieftain
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_dam/chief01")
    (cs_go_to "ps_dam/chief02")
)

(script static void test_dam_perspective
    (ai_erase_all)
    (player_disable_movement false)
    (ai_place "sq_dam_arbiter")
    (ai_place "sq_dam_chieftain")
    (ai_place "sq_dam_joh_marines")
    (set g_dam_obj_control 1)
    (sleep 1)
    (ai_disregard (ai_actors "gr_johnson_marines") true)
    (wake vs_dam_jail_bait)
    (wake vs_dam_jail_rescue)
)

(script dormant void cor_path_a
    (sleep_until (volume_test_players "tv_cortana_01") 1)
    (if debug
        (print "cortana : path_a : crazy")
    )
    (set g_pa_cortana true)
    (wake 010ca_sacrifice_me)
)

(script dormant void md_pa_mar_chief_ok
    (sleep_until g_pa_cortana_dialogue)
    (if debug
        (print "cortana : path_a : marine : chief_ok")
    )
    (vs_cast "gr_marines" true 0 "010mx_060" "010mx_150")
    (set marine_01 (vs_role 1))
    (set marine_02 (vs_role 2))
    (vs_cast "gr_arbiter" false 0 "")
    (set arbiter (vs_role 1))
    (vs_cast "gr_allies" false 0 "" "" "")
    (set sarge (vs_role 1))
    (set marine_03 (vs_role 2))
    (set marine_04 (vs_role 3))
    (sleep 1)
    (vs_set_cleanup_script md_cleanup)
    (set g_playing_dialogue true)
    (ai_dialogue_enable false)
    (vs_enable_pathfinding_failsafe marine_01 true)
    (vs_enable_moving marine_01 true)
    (vs_face_player arbiter true)
    (vs_face_player sarge true)
    (vs_face_player marine_01 true)
    (vs_face_player marine_02 true)
    (vs_face_player marine_03 true)
    (vs_face_player marine_04 true)
    (sleep 15)
    (if dialogue
        (print "marine: chief? you ok?")
    )
    (sleep (ai_play_line marine_01 010mx_060))
    (sleep 10)
    (if dialogue
        (print "marine: weird. your vitals just pinged kia...")
    )
    (sleep (ai_play_line marine_02 010mx_150))
    (sleep 30)
    (begin_random
        (begin
            (vs_release arbiter)
            (sleep (random_range 0 5))
        )
        (begin
            (vs_release sarge)
            (sleep (random_range 0 5))
        )
        (begin
            (vs_release marine_02)
            (sleep (random_range 0 5))
        )
        (begin
            (vs_release marine_03)
            (sleep (random_range 0 5))
        )
        (begin
            (vs_release marine_04)
            (sleep (random_range 0 5))
        )
    )
    (set g_playing_dialogue false)
    (ai_dialogue_enable true)
)

(script static void cin_intro_jon_diff
    (if (<= (game_difficulty_get) normal)
        (sleep (ai_play_line_on_object (cinematic_object_get "cin_johnson") 010la2_061))
        (if (<= (game_difficulty_get) heroic)
            (sleep (ai_play_line_on_object (cinematic_object_get "cin_johnson") 010la2_063))
            (if (<= (game_difficulty_get) legendary)
                (sleep (ai_play_line_on_object (cinematic_object_get "cin_johnson") 010la2_064))
            )
        )
    )
    (sleep 15)
)

(script static boolean obj_cgate__0_37
    (>= g_cc_obj_control 1)
)

(script static boolean obj_cgate__0_38
    (>= g_cc_obj_control 2)
)

(script static boolean obj_cgate__0_39
    (>= g_cc_obj_control 3)
)

(script static boolean obj_cgate__0_40
    (>= g_cc_obj_control 4)
)

(script static boolean obj_cgate__0_41
    (>= g_cc_obj_control 5)
)

(script static boolean obj_cgate__0_42
    (>= g_cc_obj_control 6)
)

(script static boolean obj_cgate__0_43
    (>= g_cc_obj_control 7)
)

(script static boolean obj_cgate__0_44
    (>= g_cc_obj_control 8)
)

(script static boolean obj_cgate__0_45
    (>= g_cc_obj_control 9)
)

(script static boolean obj_cgate__0_46
    (>= g_cc_obj_control 10)
)

(script static boolean obj_cgate__0_47
    (>= g_cc_obj_control 11)
)

(script static boolean obj_jmar_n_2_1
    g_jw_johnson_past
)

(script static boolean obj_jmar_p_2_10
    (<= (ai_task_count "obj_jw_upper_covenant/infantry_gate") 0)
)

(script static boolean obj_jgate__2_22
    (>= g_jw_obj_control 1)
)

(script static boolean obj_jgate__2_23
    (>= g_jw_obj_control 2)
)

(script static boolean obj_jgate__2_24
    (>= g_jw_obj_control 3)
)

(script static boolean obj_jgate__2_25
    (>= g_jw_obj_control 4)
)

(script static boolean obj_jgate__2_26
    (>= g_jw_obj_control 5)
)

(script static boolean obj_jgate__2_27
    (>= g_jw_obj_control 6)
)

(script static boolean obj_jgate__2_28
    (>= g_jw_obj_control 7)
)

(script static boolean obj_jgate__2_29
    (>= g_jw_obj_control 8)
)

(script static boolean obj_jarb_p_2_30
    (<= (ai_task_count "obj_jw_upper_covenant/infantry_gate") 0)
)

(script static boolean obj_jjoh_m_2_32
    g_jw_joh_phantom_joh
)

(script static boolean obj_jmar_0_2_33
    g_jw_joh_phantom_mar
)

(script static boolean obj_jarb_0_2_34
    g_jw_joh_phantom_arb
)

(script static boolean obj_jmar_f_2_36
    (<= (ai_task_count "obj_jw_upper_covenant/infantry_gate") 0)
)

(script static boolean obj_jarb_n_2_37
    (and g_md_jw_river (<= (ai_combat_status "obj_jw_upper_allies") 4))
)

(script static boolean obj_jmar_n_2_38
    (and g_md_jw_river (<= (ai_combat_status "obj_jw_upper_allies") 4))
)

(script static boolean obj_jarb_n_2_39
    (and g_md_jw_river (<= (ai_combat_status "obj_jw_upper_allies") 4))
)

(script static boolean obj_jmar_n_2_40
    (and g_md_jw_river (<= (ai_combat_status "obj_jw_upper_allies") 4))
)

(script static boolean obj_jmar_0_2_41
    (>= (ai_combat_status "obj_jw_upper_covenant") 4)
)

(script static boolean obj_jarb_0_2_42
    (>= (ai_combat_status "obj_jw_upper_covenant") 4)
)

(script static boolean obj_jarb_p_2_43
    (<= (ai_task_count "obj_jw_upper_covenant/infantry_gate") 0)
)

(script static boolean obj_jupper_3_0
    (and (> (ai_living_count "sq_jw_u_cov_01/brute") 0) (<= g_jw_obj_control 6))
)

(script static boolean obj_jcov_0_3_6
    (<= g_jw_obj_control 6)
)

(script static boolean obj_jgrunt_3_11
    (<= (ai_combat_status "obj_jw_upper_covenant") 4)
)

(script static boolean obj_jgrunt_3_14
    (<= g_jw_obj_control 6)
)

(script static boolean obj_jgate__4_6
    (>= g_jw_obj_control 9)
)

(script static boolean obj_jgate__4_7
    (>= g_jw_obj_control 10)
)

(script static boolean obj_jgate__4_8
    (>= g_jw_obj_control 11)
)

(script static boolean obj_jgate__4_9
    (>= g_jw_obj_control 12)
)

(script static boolean obj_jarb_1_4_12
    (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 0)
)

(script static boolean obj_jmar_1_4_13
    (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 0)
)

(script static boolean obj_jlower_5_2
    (<= g_jw_obj_control 11)
)

(script static boolean obj_jlower_5_3
    (<= g_jw_obj_control 9)
)

(script static boolean obj_jcov_a_5_5
    (>= (ai_living_count "obj_jw_lower_covenant/cov_b_02") 1)
)

(script static boolean obj_jgrunt_5_7
    (<= (ai_task_count "obj_jw_lower_covenant/cov_b_01") 0)
)

(script static boolean obj_jlefto_5_18
    (<= g_jw_obj_control 11)
)

(script static boolean obj_jlefto_5_19
    (<= g_jw_obj_control 10)
)

(script static boolean obj_jlefto_5_20
    (<= g_jw_obj_control 9)
)

(script static boolean obj_jcov_b_5_22
    (>= (ai_living_count "obj_jw_lower_covenant/cov_a_01") 1)
)

(script static boolean obj_tarb_i_6_0
    (volume_test_players "tv_ta_03")
)

(script static boolean obj_tarb_i_6_1
    (volume_test_players "tv_ta_02")
)

(script static boolean obj_tarb_i_6_2
    (volume_test_players "tv_ta_01")
)

(script static boolean obj_tarb_i_6_4
    (volume_test_players "tv_ta_04")
)

(script static boolean obj_tmar_i_6_5
    (volume_test_players "tv_ta_02")
)

(script static boolean obj_tmar_i_6_7
    (volume_test_players "tv_ta_03")
)

(script static boolean obj_tmar_i_6_8
    (volume_test_players "tv_ta_05")
)

(script static boolean obj_tmar_i_6_9
    (volume_test_players "tv_ta_01")
)

(script static boolean obj_tmar_i_6_10
    (volume_test_players "tv_ta_04")
)

(script static boolean obj_garb_0_7_3
    (<= (ai_task_count "obj_gc_covenant/cov_right_01") 0)
)

(script static boolean obj_garb_0_7_4
    (<= (ai_task_count "obj_gc_covenant/cov_left_01") 0)
)

(script static boolean obj_gmar_0_7_10
    (<= (ai_task_count "obj_gc_covenant/cov_right_01") 0)
)

(script static boolean obj_gmar_0_7_11
    (<= (ai_task_count "obj_gc_covenant/cov_left_01") 0)
)

(script static boolean obj_ggate__7_14
    (>= g_gc_obj_control 1)
)

(script static boolean obj_ggate__7_15
    (and (>= g_gc_obj_control 2) (<= (ai_task_count "obj_gc_covenant/ravine_grunt") 0))
)

(script static boolean obj_ggate__7_16
    (and (>= g_gc_obj_control 2) (<= (ai_task_count "obj_gc_covenant/ravine_grunt") 0))
)

(script static boolean obj_ggate__7_17
    (>= g_gc_obj_control 4)
)

(script static boolean obj_ggate__7_18
    (>= g_gc_obj_control 4)
)

(script static boolean obj_ggate__7_19
    (>= g_gc_obj_control 6)
)

(script static boolean obj_ggate__7_20
    (>= g_gc_obj_control 7)
)

(script static boolean obj_griver_7_21
    (= g_gc_obj_control 3)
)

(script static boolean obj_griver_7_22
    (= g_gc_obj_control 2)
)

(script static boolean obj_ggate__7_24
    (volume_test_players "tv_gc_ini_02")
)

(script static boolean obj_ggate__7_29
    (volume_test_players "tv_gc_ini_03")
)

(script static boolean obj_gmar_0_7_32
    (<= (ai_living_count "obj_gc_covenant") 0)
)

(script static boolean obj_garb_0_7_33
    (<= (ai_living_count "obj_gc_covenant") 0)
)

(script static boolean obj_gmar_0_7_34
    (<= (ai_task_count "obj_gc_covenant/grunt_right_01") 0)
)

(script static boolean obj_garb_0_7_35
    (<= (ai_task_count "obj_gc_covenant/grunt_right_01") 0)
)

(script static boolean obj_gmar_0_7_36
    (<= (ai_task_count "obj_gc_covenant/grunt_left_01") 0)
)

(script static boolean obj_garb_0_7_37
    (<= (ai_task_count "obj_gc_covenant/grunt_left_01") 0)
)

(script static boolean obj_griver_8_0
    (<= g_gc_obj_control 3)
)

(script static boolean obj_ggrunt_8_12
    (<= g_gc_obj_control 5)
)

(script static boolean obj_gcov_l_8_14
    (<= g_gc_obj_control 5)
)

(script static boolean obj_ggrunt_8_16
    (<= g_gc_obj_control 5)
)

(script static boolean obj_gback__8_20
    (<= g_gc_obj_control 6)
)

(script static boolean obj_griver_8_21
    (and (>= (ai_combat_status "obj_gc_covenant") 4) (<= (ai_living_count "obj_gc_covenant/ravine_grunt") 1))
)

(script static boolean obj_gmid_j_8_26
    (<= g_gc_obj_control 5)
)

(script static boolean obj_gcov_b_8_36
    (<= g_gc_obj_control 5)
)

(script static boolean obj_pgate__9_1
    (and (>= g_pa_obj_control 1) (>= (ai_combat_status "obj_pa_covenant") 4))
)

(script static boolean obj_pgate__9_12
    (>= g_pa_obj_control 2)
)

(script static boolean obj_pgate__9_13
    (>= g_pa_obj_control 3)
)

(script static boolean obj_pgate__9_14
    (>= g_pa_obj_control 4)
)

(script static boolean obj_pgate__9_18
    (<= (ai_task_count "obj_pa_covenant/bottom_cov_01") 0)
)

(script static boolean obj_pgate__9_20
    (<= (ai_task_count "obj_pa_covenant/bottom_cov_02") 0)
)

(script static boolean obj_pgate__9_21
    (<= (ai_task_count "obj_pa_covenant/cov_top_01") 0)
)

(script static boolean obj_pgate__9_24
    (>= g_pa_obj_control 5)
)

(script static boolean obj_pgate__9_27
    (>= g_pa_obj_control 6)
)

(script static boolean obj_pgate__9_30
    (>= g_pa_obj_control 7)
)

(script static boolean obj_pgate__9_33
    (>= g_pa_obj_control 8)
)

(script static boolean obj_pgate__9_36
    (>= g_pa_obj_control 9)
)

(script static boolean obj_pcov_t_10_5
    (and (>= (ai_task_count "obj_pa_covenant/jackal_top") 1) (>= (ai_task_count "obj_pa_covenant/top_grunt_02b") 1))
)

(script static boolean obj_pjacka_10_8
    (<= g_pa_obj_control 4)
)

(script static boolean obj_pcov_t_10_9
    (<= g_pa_obj_control 4)
)

(script static boolean obj_pjacka_10_10
    (>= g_pa_obj_control 5)
)

(script static boolean obj_pbotto_10_11
    (<= g_pa_obj_control 2)
)

(script static boolean obj_ptop_g_10_13
    (<= g_pa_obj_control 3)
)

(script static boolean obj_ptop_g_10_14
    (>= (ai_task_count "obj_pa_covenant/jackal_top") 1)
)

(script static boolean obj_sdock__11_2
    (<= g_ss_obj_control 3)
)

(script static boolean obj_sgate__11_3
    (= g_ss_insertion_start false)
)

(script static boolean obj_sgate__11_4
    (>= g_ss_obj_control 1)
)

(script static boolean obj_sgate__11_5
    (>= g_ss_obj_control 2)
)

(script static boolean obj_sgate__11_6
    (>= g_ss_obj_control 3)
)

(script static boolean obj_sgate__11_7
    (>= g_ss_obj_control 4)
)

(script static boolean obj_sgate__11_8
    (= g_ss_obj_control 5)
)

(script static boolean obj_sgate__11_9
    (= g_ss_obj_control 6)
)

(script static boolean obj_sgate__11_10
    (>= g_ss_obj_control 7)
)

(script static boolean obj_sgate__11_11
    (>= g_ss_obj_control 8)
)

(script static boolean obj_sgate__11_12
    (>= g_ss_obj_control 9)
)

(script static boolean obj_sgate__11_13
    (>= g_ss_obj_control 10)
)

(script static boolean obj_sarb_0_11_17
    (<= (ai_task_count "obj_ss_covenant/d_cov_01") 0)
)

(script static boolean obj_sarb_0_11_19
    (<= (ai_task_count "obj_ss_covenant/d_cov_04") 0)
)

(script static boolean obj_smar_0_11_28
    (<= (ai_task_count "obj_ss_covenant/d_cov_01") 0)
)

(script static boolean obj_smar_0_11_30
    (<= (ai_task_count "obj_ss_covenant/d_cov_04") 0)
)

(script static boolean obj_sgate__11_36
    g_ss_insertion_start
)

(script static boolean obj_sdock__12_0
    (<= g_ss_obj_control 4)
)

(script static boolean obj_sjacka_12_3
    (<= g_ss_obj_control 5)
)

(script static boolean obj_sb_cov_12_5
    (<= g_ss_obj_control 8)
)

(script static boolean obj_sb_cov_12_6
    (<= g_ss_obj_control 7)
)

(script static boolean obj_sjacka_12_7
    (<= g_ss_obj_control 8)
)

(script static boolean obj_sjacka_12_9
    (<= g_ss_obj_control 4)
)

(script static boolean obj_sd_cov_12_13
    (<= g_ss_obj_control 3)
)

(script static boolean obj_sb_fro_12_16
    (and (not (volume_test_players "tv_ss_07")) (<= g_ss_obj_control 7))
)

(script static boolean obj_sb_cov_12_26
    (>= g_ss_obj_control 9)
)

(script static boolean obj_sb_gru_12_31
    (<= g_ss_obj_control 7)
)

(script static boolean obj_sb_gru_12_32
    (<= g_ss_obj_control 8)
)

(script static boolean obj_pgate__13_0
    (>= g_pb_obj_control 6)
)

(script static boolean obj_pgate__13_3
    (>= g_pb_obj_control 5)
)

(script static boolean obj_pgate__13_6
    (>= g_pb_obj_control 4)
)

(script static boolean obj_pgate__13_9
    (>= g_pb_obj_control 3)
)

(script static boolean obj_pgate__13_12
    (>= g_pb_obj_control 2)
)

(script static boolean obj_pgate__13_15
    (>= g_pb_obj_control 1)
)

(script static boolean obj_pgate__13_21
    (>= g_pb_obj_control 7)
)

(script static boolean obj_pcov_0_14_17
    (>= g_pb_obj_control 5)
)

(script static boolean obj_pcov_0_14_18
    (>= g_pb_obj_control 4)
)

(script static boolean obj_pcov_0_14_19
    (>= g_pb_obj_control 3)
)

(script static boolean obj_pcov_0_14_20
    (>= g_pb_obj_control 2)
)

(script static boolean obj_pcov_0_14_22
    (>= g_pb_obj_control 6)
)

(script static boolean obj_bgate__15_3
    (>= g_ba_obj_control 1)
)

(script static boolean obj_bgate__15_6
    (>= g_ba_obj_control 2)
)

(script static boolean obj_bgate__15_9
    (>= g_ba_obj_control 4)
)

(script static boolean obj_bgate__15_12
    (>= g_ba_obj_control 3)
)

(script static boolean obj_bgate__15_15
    (>= g_ba_obj_control 5)
)

(script static boolean obj_barb_0_15_18
    (and (<= (ai_task_count "obj_ba_covenant/cov_01b") 0) (<= (ai_task_count "obj_ba_covenant/rein_front_b") 0))
)

(script static boolean obj_bmar_0_15_19
    (and (<= (ai_task_count "obj_ba_covenant/cov_01b") 0) (<= (ai_task_count "obj_ba_covenant/rein_front_a") 0))
)

(script static boolean obj_barb_0_15_21
    (<= (ai_task_count "obj_ba_covenant/cov_02") 0)
)

(script static boolean obj_bmar_0_15_22
    (<= (ai_task_count "obj_ba_covenant/cov_02") 0)
)

(script static boolean obj_barb_0_15_23
    (<= (ai_task_count "obj_ba_covenant/cov_01b") 0)
)

(script static boolean obj_bmar_0_15_24
    (<= (ai_task_count "obj_ba_covenant/cov_01b") 0)
)

(script static boolean obj_barb_n_15_25
    (<= (ai_task_count "obj_ba_covenant/infantry_gate") 0)
)

(script static boolean obj_bmar_n_15_26
    (<= (ai_task_count "obj_ba_covenant/infantry_gate") 0)
)

(script static boolean obj_bcov_g_16_3
    (<= g_ba_obj_control 3)
)

(script static boolean obj_brein__16_7
    (<= g_ba_obj_control 4)
)

(script static boolean obj_brein__16_9
    (and (<= (ai_task_count "obj_ba_covenant/rein_overflow") 0) (<= g_ba_obj_control 4))
)

(script static boolean obj_tgate__17_0
    (or (>= g_tb_obj_control 4) (volume_test_players "tv_tb_04"))
)

(script static boolean obj_tgate__17_3
    (>= g_tb_obj_control 3)
)

(script static boolean obj_tgate__17_6
    (>= g_tb_obj_control 2)
)

(script static boolean obj_dgate__18_1
    (>= g_dam_obj_control 1)
)

(script static boolean obj_dgate__18_2
    (>= g_dam_obj_control 2)
)

(script static boolean obj_dgate__18_3
    (>= g_dam_obj_control 3)
)

(script static boolean obj_dgate__18_4
    (>= g_dam_obj_control 4)
)

(script static boolean obj_dgate__18_5
    (>= g_dam_obj_control 5)
)

(script static boolean obj_dgate__18_6
    (>= g_dam_obj_control 6)
)

(script static boolean obj_dgate__18_21
    (>= g_dam_obj_control 7)
)

(script static boolean obj_dgate__18_24
    (>= g_dam_obj_control 8)
)

(script static boolean obj_dmar_p_18_27
    (volume_test_players "tv_dam_07")
)

(script static boolean obj_dmar_b_18_28
    (or (volume_test_players "tv_dam_04") (volume_test_players "tv_dam_05") (volume_test_players "tv_dam_06"))
)

(script static boolean obj_dmar_s_18_29
    (volume_test_players "tv_dam_02")
)

(script static boolean obj_dgate__18_30
    g_dam_follow_objective
)

(script static boolean obj_dmar_0_18_32
    (<= (ai_living_count "gr_dam_covenant_infantry") 0)
)

(script static boolean obj_darb_0_18_33
    (<= (ai_living_count "gr_dam_covenant_infantry") 0)
)

(script static boolean obj_dmar_n_18_35
    (<= (ai_living_count "gr_dam_covenant_infantry") 0)
)

(script static boolean obj_darb_n_18_36
    (<= (ai_living_count "gr_dam_covenant_infantry") 0)
)

(script static boolean obj_dallie_18_37
    g_dam_pelican_task
)

(script static boolean obj_dini_g_19_8
    (<= g_dam_obj_control 2)
)

(script static boolean obj_dbr_fr_19_11
    (>= (ai_living_count "obj_dam_00_04_covenant/br_back_cov") 1)
)

(script static boolean obj_dini_c_19_14
    (<= g_dam_obj_control 2)
)

(script static boolean obj_dgrunt_19_19
    (volume_test_players "tv_dam_04_bottom")
)

(script static boolean obj_dactiv_19_20
    (<= (ai_combat_status "gr_dam_covenant_infantry") 4)
)

(script static boolean obj_dbr_ja_19_23
    (>= (ai_task_count "obj_dam_00_04_covenant/br_jackal_01") 1)
)

(script static boolean obj_dgate__20_5
    (<= g_dam_obj_control 5)
)

(script static boolean obj_dgrunt_20_15
    (volume_test_players "tv_dam_05_bottom")
)

(script static boolean obj_dgrunt_20_18
    (volume_test_players "tv_dam_04_bottom")
)

(script static boolean obj_dgrunt_20_19
    (volume_test_players "tv_dam_06_bottom")
)

(script static boolean obj_dgrunt_20_27
    (volume_test_players "tv_dam_05_bottom")
)

(script static boolean obj_dgrunt_20_28
    (volume_test_players "tv_dam_06_bottom")
)

(script static boolean obj_dgrunt_21_8
    (volume_test_players "tv_dam_06_bottom")
)

(script static boolean obj_dgate__22_1
    (and g_dam_phantom_04 (volume_test_players "tv_dam_02"))
)

(script static boolean obj_dgate__22_3
    (and g_dam_phantom_04 (volume_test_players "tv_dam_07"))
)

(script static boolean obj_dchief_23_0
    (<= g_dam_obj_control 5)
)

(script static boolean obj_dchief_23_2
    (<= (object_get_shield "sq_dam_chieftain") 0.75)
)

(script static void ins_chief_crater
    (if debug
        (print "insertion point : chief_crater_new")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_chief_crater")
        )
    )
    (sleep 1)
    (if (= (game_is_cooperative) true)
        (unit_add_equipment (player0) "chief_coop_initial" true true)
        (unit_add_equipment (player0) "chief_initial" true true)
    )
    (sleep 1)
    (unit_raise_weapon (player0) 65535)
    (sleep 1)
    (unit_lower_weapon (player0) 1)
    (sleep 1)
    (object_teleport (player0) "player0_cc_start")
    (object_teleport (player1) "player1_cc_start")
    (object_teleport (player2) "player2_cc_start")
    (object_teleport (player3) "player3_cc_start")
    (sleep 1)
    (player0_set_pitch g_player_start_pitch 0)
    (player1_set_pitch g_player_start_pitch 0)
    (player2_set_pitch g_player_start_pitch 0)
    (player3_set_pitch g_player_start_pitch 0)
    (sleep 1)
    (if (<= (game_difficulty_get) normal)
        (ai_grenades false)
    )
    (set g_insertion_index 1)
    (hud_enable_training true)
    (cinematic_snap_to_black)
)

(script static void ins_jungle_walk
    (if debug
        (print "insertion point : jungle walk")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jungle_walk")
            (sleep 1)
        )
    )
    (set g_insertion_index 2)
    (set g_cc_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_jw_start")
    (object_teleport (player1) "player1_jw_start")
    (object_teleport (player2) "player2_jw_start")
    (object_teleport (player3) "player3_jw_start")
    (sleep 1)
    (player_disable_movement false)
    (if debug
        (print "placing allies...")
    )
    (ai_place "sq_jw_johnson_marines")
    (ai_place "sq_jw_marines")
    (if (not (game_is_cooperative))
        (ai_place "sq_jw_arbiter")
    )
    (sleep 1)
    (campaign_metagame_time_pause false)
)

(script static void ins_grunt_camp
    (if debug
        (print "insertion point : grunt camp")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_grunt_camp")
            (sleep 1)
        )
    )
    (insertion_start)
    (set g_insertion_index 3)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_gc_start")
    (object_teleport (player1) "player1_gc_start")
    (object_teleport (player2) "player2_gc_start")
    (object_teleport (player3) "player3_gc_start")
    (sleep 1)
    (player_disable_movement false)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_gc_arbiter")
    )
    (ai_place "sq_gc_marines")
    (sleep 1)
    (campaign_metagame_time_pause false)
    (wake insertion_end)
)

(script static void ins_path_a
    (if debug
        (print "insertion point : path a")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_path_a")
            (sleep 1)
        )
    )
    (set g_insertion_index 4)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (set g_gc_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_pa_start")
    (object_teleport (player1) "player1_pa_start")
    (object_teleport (player2) "player2_pa_start")
    (object_teleport (player3) "player3_pa_start")
    (sleep 1)
    (player_disable_movement false)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_pa_arbiter")
    )
    (ai_place "sq_pa_marines")
    (sleep 1)
    (campaign_metagame_time_pause false)
)

(script static void ins_substation
    (if debug
        (print "insertion point : substation")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_substation")
            (sleep 1)
        )
    )
    (set g_ss_insertion_start true)
    (if (= (game_is_cooperative) true)
        (unit_add_equipment (player0) "chief_coop_initial" true true)
        (unit_add_equipment (player0) "chief_initial" true true)
    )
    (sleep 1)
    (insertion_start)
    (wake music_010_05)
    (wake music_010_06)
    (set g_music_010_05 true)
    (set g_music_010_06 true)
    (set g_music_010_06_alt true)
    (object_create_anew_containing "rock_ss_0")
    (set g_insertion_index 5)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (set g_gc_obj_control 100)
    (set g_pa_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_ss_start")
    (object_teleport (player1) "player1_ss_start")
    (object_teleport (player2) "player2_ss_start")
    (object_teleport (player3) "player3_ss_start")
    (sleep 1)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_ss_arbiter")
    )
    (sleep 1)
    (objectives_show_up_to 0)
    (player0_set_pitch -5 0)
    (player1_set_pitch -5 0)
    (player2_set_pitch -5 0)
    (player3_set_pitch -5 0)
    (wake ai_ss_wake_allies)
    (sleep 15)
    (fade_in 0 0 0 15)
)

(script dormant void ai_ss_wake_allies
    (sleep_until (>= g_ss_obj_control 1) 30 300)
    (ai_activity_abort "sq_ss_arbiter")
    (ai_activity_abort "sq_ss_marines")
)

(script static void ins_path_b
    (if debug
        (print "insertion point : path b")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_path_b")
            (sleep 1)
        )
    )
    (set g_insertion_index 6)
    (ai_grenades true)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (set g_gc_obj_control 100)
    (set g_pa_obj_control 100)
    (set g_ss_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_pb_start")
    (object_teleport (player1) "player1_pb_start")
    (object_teleport (player2) "player2_pb_start")
    (object_teleport (player3) "player3_pb_start")
    (sleep 1)
    (player_disable_movement false)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_pb_arbiter")
    )
    (ai_place "sq_pb_marines")
    (sleep 1)
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_pb_jackal_01")
    )
    (campaign_metagame_time_pause false)
)

(script static void ins_brute_ambush
    (if debug
        (print "insertion point : brute ambush")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_path_c")
            (sleep 1)
        )
    )
    (if (= (game_is_cooperative) true)
        (unit_add_equipment (player0) "chief_coop_initial" true true)
        (unit_add_equipment (player0) "insertion_chief" true true)
    )
    (sleep 1)
    (insertion_start)
    (wake music_010_07)
    (wake music_010_075)
    (set g_music_010_07 true)
    (set g_music_010_075 true)
    (set g_insertion_index 7)
    (ai_grenades true)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (set g_gc_obj_control 100)
    (set g_pa_obj_control 100)
    (set g_ss_obj_control 100)
    (set g_pb_obj_control 100)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_ba_start")
    (object_teleport (player1) "player1_ba_start")
    (object_teleport (player2) "player2_ba_start")
    (object_teleport (player3) "player3_ba_start")
    (sleep 1)
    (player_disable_movement false)
    (player0_set_pitch g_ba_starting_pitch 0)
    (player1_set_pitch g_ba_starting_pitch 0)
    (player2_set_pitch g_ba_starting_pitch 0)
    (player3_set_pitch g_ba_starting_pitch 0)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_ba_arbiter")
    )
    (sleep 15)
    (objectives_show_up_to 1)
    (objectives_finish_up_to 0)
    (wake insertion_end)
)

(script static void ins_dam
    (if debug
        (print "insertion point : dam")
    )
    (if (!= (current_zone_set) g_set_all)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_dam")
            (sleep 1)
        )
    )
    (if (= (game_is_cooperative) true)
        (unit_add_equipment (player0) "chief_coop_initial" true true)
        (unit_add_equipment (player0) "insertion_chief" true true)
    )
    (sleep 1)
    (insertion_start)
    (set g_insertion_index 8)
    (ai_grenades true)
    (set g_cc_obj_control 100)
    (set g_jw_obj_control 100)
    (set g_ta_obj_control 100)
    (set g_gc_obj_control 100)
    (set g_pa_obj_control 100)
    (set g_ss_obj_control 100)
    (set g_pb_obj_control 100)
    (set g_ba_obj_control 100)
    (set g_tb_obj_control 3)
    (if debug
        (print "teleporting players...")
    )
    (object_teleport (player0) "player0_dam_start")
    (object_teleport (player1) "player1_dam_start")
    (object_teleport (player1) "player2_dam_start")
    (object_teleport (player1) "player3_dam_start")
    (sleep 1)
    (player_disable_movement false)
    (player0_set_pitch g_player_start_pitch 0)
    (if debug
        (print "placing allies...")
    )
    (if (not (game_is_cooperative))
        (ai_place "sq_dam_arbiter")
    )
    (ai_place "sq_dam_marines")
    (sleep 1)
    (objectives_show_up_to 2)
    (objectives_finish_up_to 1)
    (wake insertion_end)
)

(script static void start
    (fade_out 0 0 0 0)
    (if (= (game_insertion_point_get) 0)
        (ins_chief_crater)
        (if (= (game_insertion_point_get) 1)
            (ins_substation)
            (if (= (game_insertion_point_get) 2)
                (ins_brute_ambush)
            )
        )
    )
)

(script startup void mission_jungle
    (if debug
        (print "you're in the jungle baby!!!!")
    )
    (print_difficulty)
    (fade_out 0 0 0 0)
    (campaign_metagame_time_pause true)
    (ai_allegiance covenant player)
    (ai_allegiance player covenant)
    (ai_allegiance human player)
    (ai_allegiance player human)
    (ai_allegiance covenant human)
    (ai_allegiance human covenant)
    (wake gs_camera_bounds)
    (wake gs_recycle_volumes)
    (wake gs_disposable_ai)
    (if (and (<= (game_difficulty_get) normal) (= (game_is_cooperative) false) (= (campaign_metagame_enabled) false))
        (ai_grenades false)
    )
    (chud_show_spike_grenades false)
    (chud_show_fire_grenades false)
    (if (and (not editor) (> (player_count) 0))
        (start)
        (begin
            (fade_in 0 0 0 0)
        )
    )
    (sleep_until (>= g_insertion_index 1) 1)
    (if (<= g_insertion_index 1)
        (wake enc_chief_crater)
    )
    (sleep_until (or (volume_test_players "tv_enc_jungle_walk") (>= g_insertion_index 2)) 1)
    (if (<= g_insertion_index 2)
        (wake enc_jungle_walk)
    )
    (sleep_until (or (volume_test_players "tv_enc_grunt_camp") (>= g_insertion_index 3)) 1)
    (if (<= g_insertion_index 3)
        (wake enc_grunt_camp)
    )
    (sleep_until (or (volume_test_players "tv_enc_path_a") (>= g_insertion_index 4)) 1)
    (if (<= g_insertion_index 4)
        (wake enc_path_a)
    )
    (sleep_until (or (volume_test_players "tv_enc_substation") (>= g_insertion_index 5)) 1)
    (if (<= g_insertion_index 5)
        (wake enc_substation)
    )
    (sleep_until (or (volume_test_players "tv_enc_path_b") (>= g_insertion_index 6)) 1)
    (if (<= g_insertion_index 6)
        (wake enc_path_b)
    )
    (sleep_until (or (volume_test_players "tv_enc_brute_ambush") (>= g_insertion_index 7)) 1)
    (if (<= g_insertion_index 7)
        (wake enc_brute_ambush)
    )
    (sleep_until (or (volume_test_players "tv_enc_dam") (>= g_insertion_index 8)) 1)
    (if (<= g_insertion_index 8)
        (wake enc_dam)
    )
)

(script dormant void enc_chief_crater
    (data_mine_set_mission_segment "010_10_chief_crater")
    (if debug
        (print "enc_chief_crater")
    )
    (if debug
        (print "placing allies")
    )
    (ai_place "sq_johnson_marines")
    (if (not (game_is_cooperative))
        (ai_place "sq_arbiter")
    )
    (if (<= (game_coop_player_count) 2)
        (ai_place "sq_marines")
    )
    (wake gs_award_secondary_skull)
    (wake nav_cc)
    (wake md_cc_fade_in)
    (wake md_cc_johnson_move_out)
    (wake md_cc_johnson_reminder)
    (wake md_cc_joh_extract)
    (wake md_cc_brute_howl)
    (wake md_cc_bravo_advised)
    (wake music_010_01)
    (wake music_010_02)
    (if (and (<= (game_difficulty_get) heroic) (not (game_is_cooperative)) (= (campaign_metagame_enabled) false))
        (wake 010tr_jump)
    )
    (set g_nav_cc true)
    (sleep_until (volume_test_players "tv_cc_01") 1)
    (if debug
        (print "set objective control 1")
    )
    (set g_cc_obj_control 1)
    (game_save)
    (sleep_until (volume_test_players "tv_cc_02") 1)
    (if debug
        (print "set objective control 2")
    )
    (set g_cc_obj_control 2)
    (sleep_until (volume_test_players "tv_cc_03") 1)
    (if debug
        (print "set objective control 3")
    )
    (set g_cc_obj_control 3)
    (data_mine_set_mission_segment "010_11_chief_crater_path")
    (sleep_until (volume_test_players "tv_cc_04") 1)
    (if debug
        (print "set objective control 4")
    )
    (set g_cc_obj_control 4)
    (sleep_until (volume_test_players "tv_cc_05") 1)
    (if debug
        (print "set objective control 5")
    )
    (set g_cc_obj_control 5)
    (sleep_until (volume_test_players "tv_cc_06") 1)
    (if debug
        (print "set objective control 6")
    )
    (set g_cc_obj_control 6)
    (sleep_until (volume_test_players "tv_cc_07") 1)
    (if debug
        (print "set objective control 7")
    )
    (set g_cc_obj_control 7)
    (sleep_until (volume_test_players "tv_cc_08") 1)
    (if debug
        (print "set objective control 8")
    )
    (set g_cc_obj_control 8)
    (set g_music_010_01 true)
    (sleep_until (volume_test_players "tv_cc_09") 1)
    (if debug
        (print "set objective control 9")
    )
    (set g_cc_obj_control 9)
    (sleep_until (volume_test_players "tv_cc_10") 1)
    (if debug
        (print "set objective control 10")
    )
    (set g_cc_obj_control 10)
    (game_save)
    (if debug
        (print "migrate allies into the current encounter")
    )
    (ai_set_objective "gr_marines" "obj_jw_upper_allies")
    (ai_set_objective "gr_arbiter" "obj_jw_upper_allies")
    (sleep_until (volume_test_players "tv_cc_11") 1)
    (if debug
        (print "set objective control 11")
    )
    (set g_cc_obj_control 11)
    (set g_music_010_02 true)
)

(script command_script void cs_cc_banshee01
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 2)
    (cs_fly_by "ps_cc_banshee/banshee01_01")
    (cs_fly_by "ps_cc_banshee/banshee01_02")
    (cs_fly_by "ps_cc_banshee/banshee01_03")
    (ai_erase ai_current_squad)
)

(script command_script void cs_cc_banshee02
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 2)
    (cs_fly_by "ps_cc_banshee/banshee02_01")
    (cs_fly_by "ps_cc_banshee/banshee02_02")
    (cs_fly_by "ps_cc_banshee/banshee02_03")
    (ai_erase ai_current_squad)
)

(script command_script void cs_cc_arbiter_jump
    (sleep (random_range 30 45))
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to_and_face "ps_cc/arb_jump01" "ps_cc/arb_jump02")
    (cs_face true "ps_cc/arb_jump02")
    (cs_jump_to_point 1.5 1)
    (cs_face false "ps_cc/arb_jump02")
)

(script dormant void enc_jungle_walk
    (data_mine_set_mission_segment "010_20_jungle_walk")
    (if debug
        (print "enc_jungle_walk")
    )
    (game_save)
    (if debug
        (print "migrate allies into the current encounter")
    )
    (ai_set_objective "gr_allies" "obj_jw_upper_allies")
    (wake nav_jw)
    (wake ai_jw_lower_cov_reins)
    (wake jw_out_of_bounds)
    (wake md_jw_mar_brute)
    (wake md_jw_mar_power_armor)
    (wake md_jw_arb_prophets)
    (wake md_jw_river)
    (wake md_jw_phantoms)
    (wake md_jw_post_combat)
    (wake vs_jw_joh_phantom)
    (wake vs_jw_brute_squad)
    (wake music_010_03)
    (wake music_010_04)
    (sleep_until (volume_test_players "tv_jw_01") 1)
    (if debug
        (print "set objective control 1")
    )
    (set g_jw_obj_control 1)
    (sleep_until (volume_test_players "tv_jw_02") 1)
    (if debug
        (print "set objective control 2")
    )
    (set g_jw_obj_control 2)
    (sleep_until (volume_test_players "tv_jw_03") 1)
    (if debug
        (print "set objective control 3")
    )
    (set g_jw_obj_control 3)
    (ai_place "sq_jw_phantom_01")
    (ai_place "sq_jw_phantom_05")
    (if debug
        (print "placing upper covenant")
    )
    (ai_place "sq_jw_u_cov_01")
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_jw_u_grunts_01")
    )
    (sleep 1)
    (set dead_brute "sq_jw_u_cov_01/brute")
    (ai_disregard (ai_get_object "sq_jw_phantom_05") true)
    (sleep_until (volume_test_players "tv_jw_04") 1)
    (if debug
        (print "set objective control 4")
    )
    (set g_jw_obj_control 4)
    (game_save)
    (data_mine_set_mission_segment "010_21_jungle_walk_upper")
    (player_control_scale_all_input 1 60)
    (set g_music_010_03 true)
    (sleep_until (volume_test_players "tv_jw_05"))
    (if debug
        (print "set objective control 5")
    )
    (set g_jw_obj_control 5)
    (sleep_until (or (volume_test_players "tv_jw_06a") (volume_test_players "tv_jw_06b")) 1)
    (if debug
        (print "set objective control 6")
    )
    (set g_jw_obj_control 6)
    (game_save)
    (sleep_until (volume_test_players "tv_jw_07") 1)
    (if debug
        (print "set objective control 7")
    )
    (set g_jw_obj_control 7)
    (game_save)
    (sleep_until (volume_test_players "tv_jw_08") 1)
    (if debug
        (print "set objective control 8")
    )
    (set g_jw_obj_control 8)
    (data_mine_set_mission_segment "010_22_jungle_walk_lower")
    (ai_place "sq_jw_phantom_02")
    (ai_place "sq_jw_phantom_04")
    (sleep_until (volume_test_players "tv_jw_09") 1)
    (if debug
        (print "set objective control 9")
    )
    (set g_jw_obj_control 9)
    (game_save)
    (ai_set_objective "gr_allies" "obj_jw_lower_allies")
    (ai_set_objective "gr_jw_upper_cov" "obj_jw_lower_covenant")
    (set g_nav_jw true)
    (set g_music_010_04 true)
    (sleep_until (volume_test_players "tv_jw_10") 1)
    (if debug
        (print "set objective control 10")
    )
    (set g_jw_obj_control 10)
    (game_save)
    (set g_music_010_01 false)
    (set g_music_010_02 false)
    (set g_music_010_03 false)
    (sleep_until (volume_test_players "tv_jw_11") 1)
    (if debug
        (print "set objective control 11")
    )
    (set g_jw_obj_control 11)
    (game_save)
    (sleep_until (volume_test_players "tv_jw_12") 1)
    (if debug
        (print "set objective control 12")
    )
    (set g_jw_obj_control 12)
    (game_save)
    (sleep_until (volume_test_players "tv_ta_01") 1)
    (if debug
        (print "set objective control 1")
    )
    (set g_ta_obj_control 1)
    (data_mine_set_mission_segment "010_23_jungle_walk_trans")
    (ai_set_objective "gr_allies" "obj_ta_allies")
    (sleep_until (volume_test_players "tv_ta_02") 1)
    (if debug
        (print "set objective control 2")
    )
    (set g_ta_obj_control 2)
    (game_save)
    (sleep_until (volume_test_players "tv_ta_03") 1)
    (if debug
        (print "set objective control 3")
    )
    (set g_ta_obj_control 3)
    (sleep_until (volume_test_players "tv_ta_04") 1)
    (if debug
        (print "set objective control 4")
    )
    (set g_ta_obj_control 4)
    (sleep_until (volume_test_players "tv_ta_05") 1)
    (if debug
        (print "set objective control 5")
    )
    (set g_ta_obj_control 5)
    (sleep_until (volume_test_players "tv_ta_06") 1)
    (if debug
        (print "set objective control 6")
    )
    (set g_ta_obj_control 6)
)

(script command_script void cs_jw_phantom_01
    (if debug
        (print "jungle walk phantom 01")
    )
    (set jw_phantom_01 (ai_vehicle_get_from_starting_location "sq_jw_phantom_01/phantom"))
    (sleep 120)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 0.85)
    (ai_disregard jw_phantom_01 true)
    (cs_fly_by "ps_jw_phantom/p0")
    (cs_fly_by "ps_jw_phantom/p1")
    (cs_fly_by "ps_jw_phantom/p2")
    (cs_fly_by "ps_jw_phantom/p3")
    (cs_fly_by "ps_jw_phantom/p4")
    (cs_fly_by "ps_jw_phantom/p5")
    (cs_fly_by "ps_jw_phantom/p6")
    (cs_fly_by "ps_jw_phantom/p7")
    (cs_fly_by "ps_jw_phantom/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_jw_phantom_02
    (if debug
        (print "jungle walk phantom 02")
    )
    (set jw_phantom_02 (ai_vehicle_get_from_starting_location "sq_jw_phantom_02/phantom"))
    (if debug
        (print "placing lower covenant")
    )
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_jw_l_cov_01")
    )
    (ai_place "sq_jw_l_cov_02")
    (ai_place "sq_jw_l_grunts_01")
    (sleep 30)
    (ai_vehicle_enter_immediate "sq_jw_l_cov_01" jw_phantom_02 22)
    (ai_vehicle_enter_immediate "sq_jw_l_cov_02" jw_phantom_02 23)
    (ai_vehicle_enter_immediate "sq_jw_l_grunts_01" jw_phantom_02 24)
    (if (<= (game_difficulty_get) normal)
        (begin
            (cs_shoot false)
            (cs_enable_targeting false)
            (cs_enable_looking false)
        )
    )
    (sleep 1)
    (custom_animation_relative jw_phantom_02 "objects\vehicles\phantom\cinematics\vignettes\010pb_chieftain_phantom\010pb_chieftain_phantom" "010pb_chieftain_phantoma_arrival" false "jw_phantom_anchor")
    (sleep 1)
    (sleep (unit_get_custom_animation_time jw_phantom_02))
    (unit_stop_custom_animation jw_phantom_02)
    (sleep 1)
    (cs_fly_to "ps_jw_phantom/ph01_hover")
    (vehicle_hover jw_phantom_02 true)
    (begin_random
        (begin
            (vehicle_unload jw_phantom_02 24)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload jw_phantom_02 23)
            (sleep (random_range 5 15))
        )
    )
    (sleep 45)
    (begin_random
        (begin
            (vehicle_unload jw_phantom_02 22)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload jw_phantom_02 25)
            (sleep (random_range 5 15))
        )
    )
    (cs_run_command_script "sq_jw_l_cov_01" cs_jw_lower_cov_reins)
    (set g_jw_phantom_02_drop true)
    (sleep (* 30 15))
    (cs_enable_pathfinding_failsafe true)
    (vehicle_hover jw_phantom_02 false)
    (cs_fly_to "ps_jw_phantom/ph01_lift" 2)
    (cs_face true "ps_jw_phantom/ph01_look")
    (cs_vehicle_speed 0.5)
    (cs_enable_moving true)
    (cs_enable_looking true)
    (if (<= (game_difficulty_get) normal)
        (sleep (random_range 30 45))
        (if (>= (game_difficulty_get) heroic)
            (sleep_until (or (<= (ai_task_count "obj_jw_lower_covenant/phantom") 4) (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 8) (>= g_jw_obj_control 11)))
        )
    )
    (cs_face false "ps_jw_phantom/ph01_look")
    (cs_fly_by "ps_jw_phantom/p7")
    (cs_fly_by "ps_jw_phantom/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_jw_phantom_03
    (if debug
        (print "phantom 03")
    )
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 5)
    (cs_fly_by "ps_jw_phantom/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_jw_phantom_04
    (if debug
        (print "jungle walk phantom 04")
    )
    (set jw_phantom_04 (ai_vehicle_get_from_starting_location "sq_jw_phantom_04/phantom"))
    (cs_enable_pathfinding_failsafe true)
    (ai_place "sq_jw_l_cov_03")
    (ai_place "sq_jw_l_grunts_02")
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_jw_l_grunts_03")
    )
    (sleep 30)
    (ai_vehicle_enter_immediate "sq_jw_l_cov_03" jw_phantom_04 26)
    (ai_vehicle_enter_immediate "sq_jw_l_grunts_02" jw_phantom_04 27)
    (ai_vehicle_enter_immediate "sq_jw_l_grunts_03" jw_phantom_04 23)
    (if (<= (game_difficulty_get) normal)
        (begin
            (cs_shoot false)
            (cs_enable_targeting false)
            (cs_enable_looking false)
        )
    )
    (sleep 1)
    (custom_animation_relative jw_phantom_04 "objects\vehicles\phantom\cinematics\vignettes\010pb_chieftain_phantom\010pb_chieftain_phantom" "010pb_chieftain_phantomb_arrival" false "jw_phantom04_anchor")
    (sleep 1)
    (sleep (unit_get_custom_animation_time jw_phantom_04))
    (unit_stop_custom_animation jw_phantom_04)
    (vehicle_hover jw_phantom_04 true)
    (set g_music_010_01 false)
    (set g_music_010_02 false)
    (set g_music_010_03 false)
    (set g_music_010_04 true)
    (begin_random
        (begin
            (vehicle_unload jw_phantom_04 26)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload jw_phantom_04 27)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload jw_phantom_04 23)
            (sleep (random_range 5 15))
        )
    )
    (sleep 30)
    (cs_run_command_script "sq_jw_l_cov_03/grunt01" cs_jw_grunt_deploy_01)
    (cs_run_command_script "sq_jw_l_cov_03/grunt02" cs_jw_grunt_deploy_02)
    (sleep 90)
    (unit_close jw_phantom_04)
    (sleep (random_range 120 150))
    (vehicle_hover jw_phantom_04 false)
    (cs_fly_to_and_face "ps_jw_phantom/ph04_hover" "ps_jw_phantom/ph04_face" 2)
    (vehicle_hover jw_phantom_04 true)
    (if (<= (game_difficulty_get) normal)
        (sleep 1)
        (if (>= (game_difficulty_get) heroic)
            (sleep (random_range 300 450))
        )
    )
    (vehicle_hover jw_phantom_04 false)
    (cs_vehicle_speed 0.9)
    (cs_fly_to "ps_jw_phantom/ph04_01")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_jw_phantom/p7")
    (cs_fly_by "ps_jw_phantom/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_jw_phantom_05
    (if debug
        (print "jungle walk phantom 05")
    )
    (cs_enable_pathfinding_failsafe true)
    (set jw_phantom_05 (ai_vehicle_get_from_starting_location "sq_jw_phantom_05/phantom"))
    (sleep 1)
    (ai_disregard jw_phantom_05 true)
    (cs_fly_by "ps_jw_phantom/ph02_00")
    (cs_fly_by "ps_jw_phantom/ph02_01")
    (ai_set_blind "sq_jw_phantom_05" false)
    (ai_set_deaf "sq_jw_phantom_05" false)
    (cs_fly_by "ps_jw_phantom/ph02_02")
    (cs_fly_by "ps_jw_phantom/ph02_03")
    (cs_fly_by "ps_jw_phantom/ph02_04")
    (cs_fly_by "ps_jw_phantom/ph02_05")
    (cs_fly_by "ps_jw_phantom/ph02_06")
    (ai_erase ai_current_squad)
)

(script dormant void ai_jw_lower_cov_reins
    (sleep_until (or (and g_jw_phantom_02_drop (<= (ai_living_count "sq_jw_l_cov_02/brute") 0)) (and g_jw_phantom_02_drop (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 10)) (and g_jw_phantom_02_drop (>= g_jw_obj_control 10) (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 14)) (and g_jw_phantom_02_drop (>= g_jw_obj_control 11) (<= (ai_task_count "obj_jw_lower_covenant/infantry_gate") 18)) (>= g_jw_obj_control 12)) 5)
    (if debug
        (print "releasing covenant reinforcements")
    )
    (cs_run_command_script "gr_jw_lower_cov" abort)
    (ai_force_active "gr_jw_lower_cov" true)
)

(script command_script void cs_jw_lower_cov_reins
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to_and_face "ps_jt_a/jw_hold" "ps_jw_phantom/p5")
    (sleep_until g_null)
)

(script command_script void cs_jw_berserk_brute
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (sleep (random_range 30 60))
    (ai_berserk ai_current_actor true)
    (ai_prefer_target_ai "obj_jw_upper_covenant/brute_00" "gr_marines" true)
    (ai_prefer_target_ai "obj_jw_lower_covenant/brute_01" "gr_marines" true)
    (ai_prefer_target_ai "obj_jw_lower_covenant/brute_02" "gr_marines" true)
)

(script command_script void cs_jw_grunt_deploy_01
    (sleep 120)
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw_lower/grunt01")
    (cs_equipment "ps_jw_lower/cover01")
)

(script command_script void cs_jw_grunt_deploy_02
    (sleep 120)
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "ps_jw_lower/grunt02")
    (cs_equipment "ps_jw_lower/cover02")
)

(script dormant void jw_out_of_bounds
    (sleep_until 
        (begin
            (sleep_until (or (volume_test_players "tv_jw_out_of_bounds") (>= g_gc_obj_control 1)))
            (if (volume_test_object "tv_jw_out_of_bounds" (player0))
                (unit_kill (unit (player0)))
                (if (volume_test_object "tv_jw_out_of_bounds" (player1))
                    (unit_kill (unit (player1)))
                    (if (volume_test_object "tv_jw_out_of_bounds" (player2))
                        (unit_kill (unit (player2)))
                        (if (volume_test_object "tv_jw_out_of_bounds" (player3))
                            (unit_kill (unit (player3)))
                        )
                    )
                )
            )
            (>= g_gc_obj_control 1)
        )
    )
)

(script dormant void enc_grunt_camp
    (data_mine_set_mission_segment "010_30_grunt_camp")
    (if debug
        (print "enc_grunt_camp")
    )
    (game_save)
    (wake nav_gc)
    (if (>= (game_difficulty_get) heroic)
        (object_create_anew_containing "cr_gc_carbines")
    )
    (wake ai_gc_activate_grunts)
    (wake ai_gc_cov_reinforcements)
    (wake ai_gc_jackal_spawn)
    (wake md_gc_mar_sleepers)
    (if (>= (game_difficulty_get) heroic)
        (wake md_gc_mar_jackals)
    )
    (wake md_gc_joh_enroute)
    (wake md_gc_post_combat)
    (wake music_010_05)
    (if debug
        (print "placing initial covenant")
    )
    (ai_place "sq_gc_cov_01")
    (ai_place "sq_gc_grunt_01")
    (ai_place "sq_gc_grunt_02")
    (ai_place "sq_gc_grunt_03")
    (if (>= (game_difficulty_get) heroic)
        (begin
            (ai_place "sq_gc_cov_03")
            (ai_place "sq_gc_jackal_01")
        )
    )
    (sleep 1)
    (ai_set_blind "sq_gc_grunt_01/sleeper" true)
    (ai_disregard (ai_get_object "sq_gc_grunt_01/sleeper") true)
    (ai_prefer_target_ai "gr_allies" "gr_gc_cov_infantry" true)
    (sleep_until (volume_test_players "tv_gc_ini_01") 5)
    (ai_set_objective "gr_allies" "obj_gc_allies")
    (sleep_until (or (volume_test_players "tv_gc_01") (>= (ai_combat_status "obj_gc_covenant") 4)) 5)
    (if debug
        (print "set objective control 1")
    )
    (set g_gc_obj_control 1)
    (game_save)
    (set g_music_010_04 false)
    (sleep_until (or (volume_test_players "tv_gc_02") (volume_test_players "tv_gc_03")) 5)
    (if (volume_test_players "tv_gc_02")
        (begin
            (set g_gc_obj_control 2)
            (if debug
                (print "set objective control 2")
            )
        )
        (if (volume_test_players "tv_gc_03")
            (begin
                (set g_gc_obj_control 3)
                (if debug
                    (print "set objective control 3")
                )
            )
            (if true
                (begin
                    (set g_gc_obj_control 2)
                    (if debug
                        (print "set objective control 2")
                    )
                )
            )
        )
    )
    (game_save)
    (sleep_until (or (volume_test_players "tv_gc_04") (volume_test_players "tv_gc_05")) 5)
    (if (volume_test_players "tv_gc_04")
        (begin
            (set g_gc_obj_control 4)
            (if debug
                (print "set objective control 4")
            )
        )
        (if (volume_test_players "tv_gc_05")
            (begin
                (set g_gc_obj_control 5)
                (if debug
                    (print "set objective control 5")
                )
            )
            (if true
                (begin
                    (set g_gc_obj_control 5)
                    (if debug
                        (print "set objective control 5")
                    )
                )
            )
        )
    )
    (game_save)
    (data_mine_set_mission_segment "010_31_grunt_camp_mid")
    (ai_prefer_target_ai "gr_allies" "gr_gc_cov_infantry" false)
    (sleep_until (or (volume_test_players "tv_gc_06a") (volume_test_players "tv_gc_06b") (volume_test_players "tv_gc_06c")) 5)
    (if debug
        (print "set objective control 6")
    )
    (set g_gc_obj_control 6)
    (game_save)
    (data_mine_set_mission_segment "010_32_grunt_camp_ledge")
    (set g_nav_gc true)
    (sleep_until (or (volume_test_players "tv_gc_07a") (volume_test_players "tv_gc_07b")) 5)
    (if debug
        (print "set objective control 7")
    )
    (set g_gc_obj_control 7)
    (game_save)
)

(script dormant void ai_gc_activate_grunts
    (sleep_until (or (>= g_gc_obj_control 1) (>= (ai_combat_status "gr_marines") ai_combat_status_dangerous) (>= (ai_combat_status "gr_gc_covenant") ai_combat_status_dangerous)))
    (ai_set_blind "sq_gc_grunt_01/sleeper" false)
    (ai_disregard (ai_get_object "sq_gc_grunt_01/sleeper") false)
)

(script dormant void ai_gc_cov_reinforcements
    (sleep_until (or (>= g_gc_obj_control 4) (and (<= (ai_living_count "gr_gc_covenant") 10) (>= g_gc_obj_control 1))))
    (if debug
        (print "testing conditions for reinforcements 01")
    )
    (if (<= (ai_living_count "gr_gc_cov_infantry") 10)
        (begin
            (ai_place "sq_gc_cov_rein_01")
            (ai_place "sq_gc_grunt_rein_01")
            (if debug
                (print "spawning covenant reins")
            )
        )
        (if debug
            (print "no covenant")
        )
    )
    (if (<= (ai_living_count "gr_gc_jackals") 3)
        (begin
            (ai_place "sq_gc_jackal_rein_01")
            (if debug
                (print "spawning jackal reins")
            )
        )
        (if debug
            (print "no jackals")
        )
    )
)

(script dormant void ai_gc_jackal_spawn
    (if (= (game_difficulty_get) normal)
        (set g_gc_jackal_spawn false)
        (if (= (game_difficulty_get) heroic)
            (set g_gc_jackal_limit 2)
            (if (= (game_difficulty_get) legendary)
                (set g_gc_jackal_limit 4)
            )
        )
    )
    (sleep 1)
    (begin_random
        (if g_gc_jackal_spawn
            (ai_gc_jackal "sq_gc_jackal_02")
        )
        (if g_gc_jackal_spawn
            (ai_gc_jackal "sq_gc_jackal_03")
        )
        (if g_gc_jackal_spawn
            (ai_gc_jackal "sq_gc_jackal_04")
        )
        (if g_gc_jackal_spawn
            (ai_gc_jackal "sq_gc_jackal_05")
        )
    )
)

(script static void (ai_gc_jackal (ai spawned_squad))
    (ai_place spawned_squad)
    (set g_gc_jackal_count (+ g_gc_jackal_count 1))
    (if (= g_gc_jackal_limit g_gc_jackal_count)
        (set g_gc_jackal_spawn false)
    )
)

(script dormant void enc_path_a
    (data_mine_set_mission_segment "010_40_path_a")
    (if debug
        (print "enc_path_a")
    )
    (game_save)
    (wake nav_pa)
    (ai_set_objective "gr_allies" "obj_pa_allies")
    (if debug
        (print "set ally objective")
    )
    (wake md_pa_joh_company)
    (wake md_pa_post_combat)
    (wake md_pa_mar_chief_ok)
    (wake vs_pa_brute_slam)
    (wake cor_path_a)
    (wake music_010_06)
    (wake pa_music_start)
    (if debug
        (print "placing initial covenant")
    )
    (ai_place "sq_pa_cov_01")
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_pa_grunt_01")
    )
    (if (>= (game_difficulty_get) heroic)
        (begin
            (ai_place "sq_pa_jackal_01")
            (ai_place "sq_pa_jackal_02")
        )
    )
    (ai_place "sq_pa_vs_marines")
    (ai_disregard (ai_actors "sq_pa_vs_marines") true)
    (sleep 1)
    (ai_prefer_target_ai "gr_allies" "gr_pa_cov_infantry" true)
    (set g_music_010_05 true)
    (sleep_until (volume_test_players "tv_pa_01"))
    (set g_pa_obj_control 1)
    (if debug
        (print "set objective control 1")
    )
    (game_save)
    (sleep_until (volume_test_players "tv_pa_02"))
    (set g_pa_obj_control 2)
    (if debug
        (print "set objective control 2")
    )
    (game_save)
    (sleep_until (volume_test_players "tv_pa_03"))
    (set g_pa_obj_control 3)
    (if debug
        (print "set objective control 3")
    )
    (game_save)
    (data_mine_set_mission_segment "010_41_path_a_upper")
    (ai_place "sq_pa_cov_02")
    (ai_place "sq_pa_jackal_03")
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_pa_grunt_02")
    )
    (set g_nav_pa true)
    (ai_prefer_target_ai "gr_allies" "gr_pa_cov_infantry" false)
    (sleep_until (volume_test_players "tv_pa_04"))
    (set g_pa_obj_control 4)
    (if debug
        (print "set objective control 4")
    )
    (set g_music_010_06 true)
    (sleep_until (volume_test_players "tv_pa_05"))
    (set g_pa_obj_control 5)
    (if debug
        (print "set objective control 5")
    )
    (sleep_until (volume_test_players "tv_pa_06"))
    (set g_pa_obj_control 6)
    (if debug
        (print "set objective control 6")
    )
    (sleep_until (volume_test_players "tv_pa_07"))
    (set g_pa_obj_control 7)
    (if debug
        (print "set objective control 7")
    )
    (sleep_until (volume_test_players "tv_pa_08"))
    (set g_pa_obj_control 8)
    (if debug
        (print "set objective control 8")
    )
    (sleep_until (volume_test_players "tv_pa_09"))
    (set g_pa_obj_control 9)
    (if debug
        (print "set objective control 9")
    )
)

(script dormant void pa_music_start
    (sleep_until (and (>= g_pa_obj_control 3) (or (>= (ai_combat_status "sq_pa_cov_02") ai_combat_status_visible) (>= (ai_combat_status "sq_pa_jackal_03") ai_combat_status_visible) (>= (ai_combat_status "sq_pa_grunt_02") ai_combat_status_visible))))
    (set g_music_010_06 true)
)

(script dormant void enc_substation
    (data_mine_set_mission_segment "010_50_substation")
    (if debug
        (print "enc_substation")
    )
    (game_save)
    (wake nav_ss)
    (game_insertion_point_unlock 1)
    (ai_set_objective "gr_allies" "obj_ss_allies")
    (if debug
        (print "set ally objective")
    )
    (wake ai_ss_initial_cov)
    (wake ai_ss_cov_reins)
    (wake gs_ss_spawn_crates)
    (wake md_ss_turrets)
    (wake md_ss_post_combat)
    (wake vs_ss_banshee_ambush)
    (if (and (not (game_is_cooperative)) (not (campaign_metagame_enabled)))
        (wake 010tr_grenades)
    )
    (wake music_010_065)
    (wake music_010_075)
    (if (= (game_insertion_point_get) 1)
        (wake chapter_charlie_insert)
        (wake chapter_charlie)
    )
    (ai_place "sq_ss_dock_marines")
    (ai_place "sq_ss_pelican_01")
    (ai_place "sq_ss_pelican_02")
    (sleep 1)
    (sleep_until (volume_test_players "tv_ss_01"))
    (set g_ss_obj_control 1)
    (if debug
        (print "set objective control 1")
    )
    (game_save)
    (wake obj_substation_clear)
    (ai_cannot_die "sq_ss_cov_01" false)
    (ai_cannot_die "sq_ss_cov_02" false)
    (ai_cannot_die "sq_ss_cov_03" false)
    (ai_cannot_die "sq_ss_jackals_01" false)
    (ai_cannot_die "sq_ss_jackals_02" false)
    (ai_cannot_die "sq_ss_jackals_03" false)
    (ai_cannot_die "sq_ss_jackals_04" false)
    (ai_cannot_die "sq_ss_jackals_05" false)
    (sleep_until (volume_test_players "tv_ss_02"))
    (set g_ss_obj_control 2)
    (if debug
        (print "set objecitve control 2")
    )
    (game_save)
    (if debug
        (print "ai will now drop and throw grenades")
    )
    (ai_grenades true)
    (set g_music_010_06_alt true)
    (sleep_until (volume_test_players "tv_ss_03"))
    (set g_ss_obj_control 3)
    (if debug
        (print "set objecitve control 3")
    )
    (sleep_until (volume_test_players "tv_ss_04"))
    (set g_ss_obj_control 4)
    (if debug
        (print "set objective control 4")
    )
    (game_save)
    (data_mine_set_mission_segment "010_51_substation_mid")
    (ai_disregard (ai_get_object "sq_ss_jackals_01") false)
    (ai_prefer_target_ai "gr_allies" "gr_ss_cov_infantry" false)
    (set g_music_010_05 false)
    (set g_music_010_06 false)
    (sleep_until (volume_test_players "tv_ss_05"))
    (set g_ss_obj_control 5)
    (if debug
        (print "set objective control 5")
    )
    (game_save)
    (sleep_until (volume_test_players "tv_ss_06"))
    (set g_ss_obj_control 6)
    (if debug
        (print "set objective control 6")
    )
    (game_save)
    (set g_music_010_065 true)
    (sleep_until (volume_test_players "tv_ss_07"))
    (set g_ss_obj_control 7)
    (if debug
        (print "set objective control 7")
    )
    (game_save)
    (data_mine_set_mission_segment "010_52_substation_ridge")
    (set g_nav_ss true)
    (sleep_until (volume_test_players "tv_ss_08"))
    (set g_ss_obj_control 8)
    (if debug
        (print "set objecitve control 8")
    )
    (game_save)
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_pb_jackal_01")
    )
    (sleep_until (volume_test_players "tv_ss_09"))
    (set g_ss_obj_control 9)
    (if debug
        (print "set objecitve control 9")
    )
    (game_save)
    (sleep_until (volume_test_players "tv_ss_10"))
    (set g_ss_obj_control 10)
    (if debug
        (print "set objecitve control 10")
    )
    (game_save)
)

(script dormant void ai_ss_initial_cov
    (sleep 5)
    (ai_place "sq_ss_cov_01")
    (ai_place "sq_ss_cov_02")
    (sleep 5)
    (ai_cannot_die "sq_ss_cov_01" true)
    (ai_cannot_die "sq_ss_cov_02" true)
    (ai_place "sq_ss_cov_03")
    (sleep 5)
    (ai_cannot_die "sq_ss_cov_03" true)
    (if (>= (game_difficulty_get) heroic)
        (begin
            (if (<= (game_difficulty_get) normal)
                (ai_place "sq_ss_jackals_01" 0)
                (if (= (game_difficulty_get) heroic)
                    (ai_place "sq_ss_jackals_01" 1)
                    (if (= (game_difficulty_get) legendary)
                        (ai_place "sq_ss_jackals_01" 2)
                    )
                )
            )
            (sleep 1)
            (ai_place "sq_ss_jackals_02")
            (ai_place "sq_ss_jackals_03")
            (sleep 1)
            (ai_place "sq_ss_jackals_04")
            (ai_place "sq_ss_jackals_05")
        )
    )
    (sleep 1)
    (if (>= (ai_living_count "gr_marines") 5)
        (ai_kill "sq_ss_dock_marines")
    )
    (ai_disregard (ai_get_object "sq_ss_jackals_01") true)
    (ai_prefer_target_ai "gr_allies" "gr_ss_cov_infantry" true)
    (ai_cannot_die "sq_ss_jackals_01" true)
    (ai_cannot_die "sq_ss_jackals_02" true)
    (ai_cannot_die "sq_ss_jackals_03" true)
    (ai_cannot_die "sq_ss_jackals_04" true)
    (ai_cannot_die "sq_ss_jackals_05" true)
)

(script dormant void ai_ss_cov_reins
    (sleep_until (>= g_ss_obj_control 2))
    (sleep_until (or (>= g_ss_obj_control 4) (<= (ai_task_count "obj_ss_covenant/infantry_gate") 6)) 5)
    (if debug
        (print "wave 1 covenant reinforcements")
    )
    (ai_place "sq_ss_back_jackal_01")
    (ai_place "sq_ss_cov_04")
    (ai_place "sq_ss_cov_05")
    (sleep 1)
    (sleep_until (or (and (>= g_ss_obj_control 4) (<= (ai_task_count "obj_ss_covenant/infantry_gate") 14)) (>= g_ss_obj_control 5)) 5)
    (if (and g_ss_banshee_ambush (<= (ai_task_count "obj_ss_covenant/infantry_gate") 18))
        (begin
            (if debug
                (print "wave 2 covenant reinforcements")
            )
            (ai_place "sq_ss_phantom_02")
            (set g_ss_phantom_02_placed true)
        )
    )
    (sleep_until (or (and g_ss_phantom_02 (>= g_ss_obj_control 6) (<= (ai_task_count "obj_ss_covenant/infantry_gate") 0)) (and g_ss_phantom_02 (>= g_ss_obj_control 7) (<= (ai_task_count "obj_ss_covenant/infantry_gate") 5)) (>= g_ss_obj_control 8)) 5)
    (if (<= (ai_task_count "obj_ss_covenant/infantry_gate") 6)
        (begin
            (if debug
                (print "wave 2 covenant reinforcements")
            )
            (ai_place "sq_ss_rein_cov_03")
            (if (= g_ss_phantom_02_placed false)
                (ai_place "sq_ss_rein_cov_04")
            )
        )
    )
)

(script dormant void gs_ss_spawn_crates
    (object_create_folder "foliage_substation")
    (object_create_folder "cr_substation_01")
    (sleep 15)
    (object_create_folder "cr_substation_02")
    (sleep 15)
    (object_create_folder "cr_substation_03")
)

(script command_script void cs_ss_phantom_01
    (if debug
        (print "phantom 01")
    )
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_phantom/p0")
    (cs_vehicle_boost false)
    (cs_fly_by "ps_ss_phantom/p2")
    (cs_fly_by "ps_ss_phantom/p3")
    (cs_vehicle_speed 0.45)
    (cs_fly_by "ps_ss_phantom/p4")
    (cs_fly_to "ps_ss_phantom/p5")
    (sleep_until g_ss_phantom_03 5 (* 30 10))
    (cs_fly_by "ps_ss_phantom/p6")
    (cs_vehicle_speed 0.55)
    (set g_ss_phantom_03_spawn true)
    (cs_fly_by "ps_ss_phantom/p7")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_ss_phantom/p8")
    (cs_fly_by "ps_ss_phantom/p9")
    (ai_erase ai_current_squad)
)

(script command_script void cs_ss_phantom_02
    (if debug
        (print "phantom 02")
    )
    (set ss_phantom_02 (ai_vehicle_get_from_starting_location "sq_ss_phantom_02/phantom"))
    (ai_place "sq_ss_rein_cov_01")
    (ai_place "sq_ss_rein_cov_02")
    (sleep 1)
    (if (<= (ai_task_count "obj_ss_covenant/infantry_gate") 18)
        (begin
            (ai_place "sq_ss_grunt_01")
            (ai_place "sq_ss_grunt_02")
        )
    )
    (sleep 5)
    (ai_vehicle_enter_immediate "sq_ss_rein_cov_01" ss_phantom_02 28)
    (ai_vehicle_enter_immediate "sq_ss_rein_cov_02" ss_phantom_02 29)
    (ai_vehicle_enter_immediate "sq_ss_grunt_01" ss_phantom_02 26)
    (ai_vehicle_enter_immediate "sq_ss_grunt_02" ss_phantom_02 27)
    (sleep 1)
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_phantom/p1")
    (cs_vehicle_boost false)
    (cs_fly_by "ps_ss_phantom/p2")
    (cs_fly_by "ps_ss_phantom/p3")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_ss_phantom/ph_hover" "ps_ss_phantom/ph_face" 1)
    (sleep 30)
    (set g_music_010_065 true)
    (cs_fly_to_and_face "ps_ss_phantom/ph_drop" "ps_ss_phantom/ph_face" 1)
    (sleep 15)
    (begin_random
        (begin
            (vehicle_unload ss_phantom_02 26)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload ss_phantom_02 27)
            (sleep (random_range 5 15))
        )
    )
    (sleep 45)
    (begin_random
        (begin
            (vehicle_unload ss_phantom_02 28)
            (sleep (random_range 5 15))
        )
        (begin
            (vehicle_unload ss_phantom_02 29)
            (sleep (random_range 5 15))
        )
    )
    (sleep 90)
    (unit_close ss_phantom_02)
    (set g_ss_phantom_02 true)
    (if (>= (game_difficulty_get) heroic)
        (sleep (random_range 115 135))
    )
    (cs_fly_to "ps_ss_phantom/ph_hover" 1)
    (if (>= (game_difficulty_get) heroic)
        (sleep (random_range 150 210))
    )
    (set g_ss_phantom_03 true)
    (sleep (random_range 15 45))
    (cs_vehicle_speed 0.75)
    (cs_fly_by "ps_ss_phantom/p4")
    (cs_fly_by "ps_ss_phantom/p5")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_ss_phantom/p6")
    (cs_fly_by "ps_ss_phantom/p7")
    (cs_fly_by "ps_ss_phantom/p8")
    (cs_fly_by "ps_ss_phantom/p9")
    (ai_erase ai_current_squad)
)

(script command_script void cs_ss_phantom_03
    (if debug
        (print "phantom 03")
    )
    (cs_vehicle_boost true)
    (cs_fly_by "ps_ss_phantom/p0")
    (cs_vehicle_boost false)
    (cs_fly_by "ps_ss_phantom/p2")
    (cs_fly_by "ps_ss_phantom/p3")
    (cs_fly_by "ps_ss_phantom/p4")
    (cs_fly_to "ps_ss_phantom/p5")
    (sleep_until g_ss_phantom_03)
    (cs_fly_by "ps_ss_phantom/p6")
    (cs_fly_by "ps_ss_phantom/p7")
    (cs_fly_by "ps_ss_phantom/p8")
    (cs_fly_by "ps_ss_phantom/p9")
    (ai_erase ai_current_squad)
)

(script dormant void enc_path_b
    (data_mine_set_mission_segment "010_60_path_b")
    (if debug
        (print "enc_path_b")
    )
    (game_save)
    (ai_set_objective "gr_allies" "obj_pb_allies")
    (if debug
        (print "set ally objective")
    )
    (wake nav_pb)
    (wake md_pb_joh_alright)
    (if (<= (game_difficulty_get) normal)
        (wake md_pb_mar_jackals)
    )
    (wake music_010_07)
    (if debug
        (print "placing initial covenant")
    )
    (wake ai_pb_jackal_spawn)
    (sleep 1)
    (set g_nav_pb true)
    (set g_music_010_065 false)
    (set g_music_010_075 true)
    (sleep_until (volume_test_players "tv_pb_01"))
    (if debug
        (print "set objective control 1")
    )
    (set g_pb_obj_control 1)
    (game_save)
    (ai_set_objective "gr_ss_covenant" "obj_pb_covenant")
    (sleep_until (volume_test_players "tv_pb_02"))
    (if debug
        (print "set objective control 2")
    )
    (set g_pb_obj_control 2)
    (data_mine_set_mission_segment "010_61_path_b_mid")
    (sleep_until (volume_test_players "tv_pb_03"))
    (if debug
        (print "set objective control 3")
    )
    (set g_pb_obj_control 3)
    (game_save)
    (sleep_until (volume_test_players "tv_pb_04"))
    (if debug
        (print "set objective control 4")
    )
    (set g_pb_obj_control 4)
    (data_mine_set_mission_segment "010_62_path_b_end")
    (sleep_until (volume_test_players "tv_pb_05"))
    (if debug
        (print "set objective control 5")
    )
    (set g_pb_obj_control 5)
    (game_save)
    (sleep_until (volume_test_players "tv_pb_06"))
    (if debug
        (print "set objective control 6")
    )
    (set g_pb_obj_control 6)
    (set g_music_010_07 true)
    (sleep_until (volume_test_players "tv_pb_07"))
    (if debug
        (print "set objective control 7")
    )
    (set g_pb_obj_control 7)
    (game_save)
)

(script dormant void ai_pb_jackal_spawn
    (if (<= (game_difficulty_get) normal)
        (set g_pb_jackal_limit 1)
        (if (= (game_difficulty_get) heroic)
            (set g_pb_jackal_limit 3)
            (if (= (game_difficulty_get) legendary)
                (set g_pb_jackal_limit 5)
            )
        )
    )
    (sleep 1)
    (begin_random
        (if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic))
            (ai_pb_jackal "sq_pb_jackal_02")
        )
        (if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic))
            (ai_pb_jackal "sq_pb_jackal_03")
        )
        (if (and g_pb_jackal_spawn (>= (game_difficulty_get) heroic))
            (ai_pb_jackal "sq_pb_jackal_04")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_05")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_06")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_07")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_08")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_09")
        )
    )
    (sleep 1)
    (set g_pb_jackal_spawn true)
    (set g_pb_jackal_count 0)
    (if (<= (game_difficulty_get) normal)
        (set g_pb_jackal_limit 4)
        (if (= (game_difficulty_get) heroic)
            (set g_pb_jackal_limit 5)
            (if (= (game_difficulty_get) legendary)
                (set g_pb_jackal_limit 6)
            )
        )
    )
    (sleep 1)
    (begin_random
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_10")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_11")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_12")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_13")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_14")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_15")
        )
        (if g_pb_jackal_spawn
            (ai_pb_jackal "sq_pb_jackal_16")
        )
    )
)

(script static void (ai_pb_jackal (ai spawned_squad))
    (ai_place spawned_squad)
    (set g_pb_jackal_count (+ g_pb_jackal_count 1))
    (if (= g_pb_jackal_limit g_pb_jackal_count)
        (set g_pb_jackal_spawn false)
    )
)

(script dormant void enc_brute_ambush
    (data_mine_set_mission_segment "010_70_brute_ambush")
    (if debug
        (print "enc_brute_ambush")
    )
    (game_save)
    (game_insertion_point_unlock 2)
    (wake nav_ba)
    (wake md_ba_pelican)
    (wake md_ba_post_combat)
    (wake vs_ba_joh_dumb_apes)
    (wake ai_ba_cov_reins)
    (wake music_010_076)
    (wake obj_locate_pelican_clear)
    (wake obj_get_to_johnson_set)
    (if debug
        (print "placing initial covenant")
    )
    (ai_place "sq_ba_cov_01")
    (ai_place "sq_ba_cov_02")
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_ba_cov_03")
    )
    (if (>= (game_difficulty_get) heroic)
        (ai_place "sq_ba_cov_04")
    )
    (ai_place "sq_ba_grunt_01")
    (if (<= (game_difficulty_get) normal)
        (ai_place "sq_ba_grunt_02")
    )
    (ai_place "sq_ba_grunt_03")
    (ai_place "sq_ba_phantom_01")
    (wake ai_ba_jackal_spawn)
    (sleep 1)
    (if debug
        (print "placing marines")
    )
    (ai_place "sq_ba_johnson_marines")
    (ai_prefer_target_ai "gr_allies" "gr_ba_cov_infantry" true)
    (sleep_until (or (volume_test_players "tv_ba_01") (volume_test_players "tv_ba_01_02")) 5)
    (if debug
        (print "set objective control 1")
    )
    (game_save)
    (set g_ba_obj_control 1)
    (if debug
        (print "set ally objective")
    )
    (ai_set_objective "gr_allies" "obj_ba_allies")
    (sleep_until (or (volume_test_players "tv_ba_01_02") (volume_test_players "tv_ba_02_03_04") (volume_test_players "tv_ba_02_03_04_05")) 5)
    (if debug
        (print "set objective control 2")
    )
    (game_save)
    (set g_ba_obj_control 2)
    (data_mine_set_mission_segment "010_71_brute_ambush_mid")
    (set g_ba_johnson_objective true)
    (sleep_until (or (volume_test_players "tv_ba_03") (volume_test_players "tv_ba_02_03_04") (volume_test_players "tv_ba_02_03_04_05") (volume_test_players "tv_ba_03_04_05a") (volume_test_players "tv_ba_03_04_05b") (volume_test_players "tv_ba_03_04_05c")) 5)
    (if debug
        (print "set objective control 3")
    )
    (game_save)
    (set g_ba_obj_control 3)
    (data_mine_set_mission_segment "010_72_brute_ambush_end")
    (set g_nav_ba true)
    (sleep_until (or (volume_test_players "tv_ba_02_03_04") (volume_test_players "tv_ba_02_03_04_05") (volume_test_players "tv_ba_03_04_05a") (volume_test_players "tv_ba_03_04_05b") (volume_test_players "tv_ba_03_04_05c")) 5)
    (if debug
        (print "set objective control 4")
    )
    (game_save)
    (set g_ba_obj_control 4)
    (if debug
        (print "music 08 alternate")
    )
    (sound_looping_set_alternate "levels\solo\010_jungle\music\010_music_08" true)
    (ai_prefer_target_ai "gr_allies" "gr_ba_cov_infantry" false)
    (sleep_until (or (volume_test_players "tv_ba_02_03_04_05") (volume_test_players "tv_ba_03_04_05a") (volume_test_players "tv_ba_03_04_05b") (volume_test_players "tv_ba_03_04_05c")) 5)
    (if debug
        (print "set objective control 5")
    )
    (game_save)
    (set g_ba_obj_control 5)
    (set g_music_010_076 true)
    (sleep_until (volume_test_players "tv_tb_01") 1)
    (if debug
        (print "set objective control 1")
    )
    (set g_tb_obj_control 1)
    (ai_set_objective "gr_allies" "obj_tb_allies")
    (if debug
        (print "set ally objective")
    )
    (sleep_until (volume_test_players "tv_tb_02") 1)
    (if debug
        (print "set objective control 2")
    )
    (set g_tb_obj_control 2)
    (game_save)
    (sleep_until (volume_test_players "tv_tb_03") 1)
    (if debug
        (print "set objective control 3")
    )
    (set g_tb_obj_control 3)
    (sleep_until (volume_test_players "tv_tb_04") 1)
    (if debug
        (print "set objective control 4")
    )
    (set g_tb_obj_control 4)
    (game_save)
)

(script dormant void ai_ba_jackal_spawn
    (ai_place "sq_ba_jackal_05")
    (if (<= (game_difficulty_get) normal)
        (set g_ba_jackal_limit 2)
        (if (= (game_difficulty_get) heroic)
            (set g_ba_jackal_limit 4)
            (if (= (game_difficulty_get) legendary)
                (set g_ba_jackal_limit 6)
            )
        )
    )
    (sleep 1)
    (begin_random
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_01")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_02")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_03")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_04")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_06")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_07")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_08")
        )
        (if g_ba_jackal_spawn
            (ai_ba_jackal "sq_ba_jackal_09")
        )
    )
)

(script static void (ai_ba_jackal (ai spawned_squad))
    (ai_place spawned_squad)
    (set g_ba_jackal_count (+ g_ba_jackal_count 1))
    (if (= g_ba_jackal_limit g_ba_jackal_count)
        (set g_ba_jackal_spawn false)
    )
)

(script dormant void ai_ba_cov_reins
    (sleep_until (>= g_ba_obj_control 4))
    (if debug
        (print "placing covenant reinforcements")
    )
    (if (<= (ai_task_count "obj_ba_covenant/infantry_gate") 20)
        (ai_place "sq_ba_cov_rein_01")
    )
    (ai_place "sq_ba_jackal_rein")
    (sleep 1)
    (if (and (>= (game_difficulty_get) heroic) (<= (ai_task_count "obj_ba_covenant/infantry_gate") 10))
        (ai_place "sq_ba_cov_rein_02")
    )
)

(script command_script void cs_ba_phantom_01
    (cs_face true "ps_ba/ph01_face")
    (ai_place "sq_ba_chieftain")
    (ai_vehicle_enter_immediate "sq_ba_chieftain" (ai_vehicle_get_from_starting_location "sq_ba_phantom_01/phantom") 30)
    (cs_force_combat_status 3)
    (sleep_until (>= g_ba_obj_control 2))
    (sleep_until (or g_ba_phantom_flyaway (>= g_ba_obj_control 3) (<= (ai_living_count ai_current_squad) 4)) 5 (* 30 30))
    (set g_ba_phantom_flyaway true)
    (sleep (random_range 60 120))
    (set g_ba_phantom_stop true)
    (cs_enable_pathfinding_failsafe true)
    (cs_face false "ps_ba/ph01_face")
    (cs_fly_by "ps_rc/ba_ph01")
    (cs_fly_by "ps_rc/ba_ph02")
    (cs_fly_to "ps_rc/ss_ph_erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_ba_phantom_02
    (cs_face true "ps_ba/ph02_face")
    (cs_force_combat_status 3)
    (sleep_until (>= g_ba_obj_control 2))
    (sleep_until (or g_ba_phantom_flyaway (>= g_ba_obj_control 3) (<= (ai_living_count ai_current_squad) 3)) 5 (* 30 30))
    (set g_ba_phantom_flyaway true)
    (sleep (random_range 0 30))
    (set g_ba_phantom_stop true)
    (cs_enable_pathfinding_failsafe true)
    (cs_face false "ps_ba/ph02_face")
    (cs_fly_by "ps_rc/ba_ph01")
    (cs_fly_by "ps_rc/ba_ph02")
    (cs_fly_to "ps_rc/ss_ph_erase")
    (ai_erase ai_current_squad)
)

(script dormant void enc_dam
    (data_mine_set_mission_segment "010_80_dam")
    (if debug
        (print "enc_dam")
    )
    (game_save)
    (wake 010_jungle_mission_won)
    (wake gs_award_primary_skull)
    (wake nav_dam)
    (wake nav_dam_pelican)
    (wake ai_dam_cov_reinforcements)
    (wake ai_dam_pelican)
    (wake ai_dam_kill_marines)
    (wake md_dam_pelican_attack)
    (wake md_dam_joh_pile_in)
    (wake md_dam_joh_leave)
    (wake vs_dam_jail_bait)
    (wake vs_dam_jail_rescue)
    (wake 010pb_johnson_captured)
    (wake music_010_08)
    (ai_place "sq_dam_joh_marines")
    (if debug
        (print "placing initial covenant")
    )
    (ai_place "sq_dam_phantom_01")
    (ai_place "sq_dam_chieftain")
    (ai_place "sq_dam_bodyguards")
    (ai_place "sq_dam_ini_cov_01")
    (ai_place "sq_dam_ini_grunt_01")
    (ai_place "sq_dam_ini_grunt_02")
    (ai_place "sq_dam_ini_jackal_01")
    (ai_place "sq_dam_ini_jackal_02")
    (if (>= (game_difficulty_get) heroic)
        (begin
            (ai_place "sq_dam_ini_jackal_03")
            (ai_place "sq_dam_ini_jackal_04")
        )
    )
    (sleep 1)
    (ai_disregard (ai_actors "sq_dam_joh_marines") true)
    (ai_cannot_die "sq_dam_joh_marines/johnson" true)
    (sleep_until (volume_test_players "tv_dam_01") 5)
    (if debug
        (print "set objective control 1")
    )
    (set g_dam_obj_control 1)
    (if debug
        (print "set ally objective")
    )
    (ai_set_objective "gr_marines" "obj_dam_allies")
    (ai_set_objective "gr_arbiter" "obj_dam_allies")
    (set g_music_010_07 false)
    (set g_music_010_075 false)
    (set g_music_010_076 false)
    (sleep_until (volume_test_players "tv_dam_02") 5)
    (if debug
        (print "set objective control 2")
    )
    (set g_dam_obj_control 2)
    (game_save)
    (sleep_until (volume_test_players "tv_dam_03") 5)
    (if debug
        (print "set objective control 3")
    )
    (set g_dam_obj_control 3)
    (game_save)
    (sleep_until (volume_test_players "tv_dam_04") 5)
    (if debug
        (print "set objective control 4")
    )
    (set g_dam_obj_control 4)
    (game_save)
    (sleep_until (volume_test_players "tv_dam_05") 5)
    (if debug
        (print "set objective control 5")
    )
    (set g_dam_obj_control 5)
    (game_save)
    (data_mine_set_mission_segment "010_81_dam_bridge")
    (ai_set_objective "gr_dam_covenant" "obj_dam_05_06_covenant")
    (sleep_until (volume_test_players "tv_dam_06") 5)
    (if debug
        (print "set objective control 6")
    )
    (set g_dam_obj_control 6)
    (game_save)
    (sleep_until (volume_test_players "tv_dam_07") 5)
    (if debug
        (print "set objective control 7")
    )
    (set g_dam_obj_control 7)
    (game_save)
    (data_mine_set_mission_segment "010_82_dam_08_covenant")
    (ai_set_objective "gr_dam_covenant" "obj_dam_07_covenant")
    (set g_nav_dam true)
    (sleep_until (volume_test_players "tv_dam_08") 5)
    (if debug
        (print "set objective control 08")
    )
    (set g_dam_obj_control 8)
    (game_save)
    (ai_set_objective "gr_dam_covenant" "obj_dam_08_evac_covenant")
)

(script dormant void ai_dam_kill_marines
    (sleep_until (>= g_dam_obj_control 1))
    (if (>= (ai_living_count "gr_marines") 3)
        (begin
            (ai_kill_silent "sq_dam_joh_marines/mar_01")
            (ai_kill_silent "sq_dam_joh_marines/mar_02")
            (ai_kill_silent "sq_dam_joh_marines/mar_03")
        )
    )
)

(script dormant void ai_dam_cov_reinforcements
    (sleep_until (or (and (>= g_dam_obj_control 3) (<= (ai_living_count "gr_dam_covenant_infantry") 7)) (and (>= g_dam_obj_control 4) (<= (ai_living_count "gr_dam_covenant_infantry") 15)) (>= g_dam_obj_control 5)) 5)
    (ai_place "sq_dam_phantom_02")
    (if (<= (ai_living_count "gr_dam_covenant_infantry") 10)
        (begin
            (if debug
                (print "placing bridge covenant")
            )
            (ai_place "sq_dam_bridge_cov_01")
            (ai_place "sq_dam_bridge_grunt_01")
        )
    )
    (if (<= (ai_living_count "gr_dam_jackals") 4)
        (ai_place "sq_dam_bridge_jackal_01")
    )
    (if (>= g_dam_obj_control 5)
        (begin
            (if debug
                (print "setting current objective")
            )
            (ai_set_objective "sq_dam_bridge_cov_01" "obj_dam_05_06_covenant")
            (ai_set_objective "sq_dam_bridge_grunt_01" "obj_dam_05_06_covenant")
            (ai_set_objective "sq_dam_bridge_jackal_01" "obj_dam_05_06_covenant")
        )
    )
    (sleep_until g_dam_place_phantom_03 5)
    (ai_place "sq_dam_phantom_03")
    (sleep_until g_dam_place_phantom_04 5)
    (ai_place "sq_dam_phantom_04")
)

(script command_script void cs_dam_ini_brute
    (ai_activity_set ai_current_actor "act_kneel_1")
    (sleep (random_range 200 240))
    (ai_activity_abort ai_current_actor)
)

(script command_script void cs_dam_ini_grunt
    (if (= (random_range 0 2) 0)
        (ai_activity_set ai_current_actor "stand")
        (ai_activity_set ai_current_actor "asleep")
    )
    (sleep (random_range 250 300))
    (ai_activity_abort ai_current_actor)
)

(script command_script void cs_dam_phantom_01
    (set dam_phantom_01 (ai_vehicle_get_from_starting_location "sq_dam_phantom_01/phantom"))
    (if debug
        (print "dam phantom 01")
    )
    (object_cannot_take_damage dam_phantom_01)
    (cs_face true "ps_dam/jail_hover")
    (cs_vehicle_speed 0.35)
    (cs_fly_to "ps_dam/bridge_drop" 1)
    (sleep 5)
    (ai_set_blind "sq_dam_phantom_01" true)
    (ai_set_deaf "sq_dam_phantom_01" true)
    (sleep_until (>= g_dam_obj_control 1))
    (if debug
        (print "placing and dropping covenant")
    )
    (ai_dump_via_phantom "sq_dam_phantom_01/phantom" "sq_dam_ph01_jackal_01")
    (sleep 90)
    (if (<= (ai_combat_status "obj_dam_00_04_covenant") 4)
        (sleep_until (>= (ai_combat_status "obj_dam_00_04_covenant") 5) 30 (* 30 7))
    )
    (if debug
        (print "placing and dropping covenant")
    )
    (ai_dump_via_phantom "sq_dam_phantom_01/phantom" "sq_dam_ph01_cov_01")
    (sleep 60)
    (if debug
        (print "fly away")
    )
    (cs_fly_to "ps_dam/bridge_hover" 1)
    (sleep 60)
    (cs_fly_by "ps_rc/dam_04")
    (cs_face true "ps_rc/dam_02")
    (cs_vehicle_speed 1)
    (sleep 30)
    (cs_face false "ps_rc/dam_02")
    (cs_fly_by "ps_rc/dam_01")
    (cs_fly_by "ps_rc/ph_erase")
    (if debug
        (print "delete phantom")
    )
    (ai_erase ai_current_squad)
)

(script command_script void cs_dam_phantom_02
    (set dam_phantom_02 (ai_vehicle_get_from_starting_location "sq_dam_phantom_02/phantom"))
    (if debug
        (print "dam phantom 02")
    )
    (cs_enable_pathfinding_failsafe true)
    (object_cannot_take_damage dam_phantom_02)
    (cs_fly_by "ps_rc/dam_01")
    (cs_fly_by "ps_rc/dam_02")
    (cs_fly_by "ps_rc/dam_03")
    (cs_fly_by "ps_rc/dam_04")
    (cs_fly_to "ps_dam/jail_hover")
    (sleep 30)
    (cs_vehicle_speed 0.5)
    (cs_fly_to "ps_dam/jail_drop" 1)
    (object_set_phantom_power (ai_vehicle_get_from_starting_location "sq_dam_phantom_02/phantom") true)
    (sleep 30)
    (if debug
        (print "placing and dropping jackals")
    )
    (if (<= (ai_living_count "gr_dam_jackals") 4)
        (ai_dump_via_phantom "sq_dam_phantom_02/phantom" "sq_dam_ph02_jackal_01")
    )
    (sleep 15)
    (if (>= g_dam_obj_control 5)
        (ai_set_objective "sq_dam_ph02_jackal_01" "obj_dam_05_06_covenant")
    )
    (sleep 135)
    (if (<= (ai_living_count "gr_dam_covenant_infantry") 14)
        (begin
            (if debug
                (print "placing and dropping covenant")
            )
            (ai_dump_via_phantom "sq_dam_phantom_02/phantom" "sq_dam_ph02_grunt_01")
            (sleep 15)
            (if (>= g_dam_obj_control 5)
                (ai_set_objective "sq_dam_ph02_grunt_01" "obj_dam_05_06_covenant")
            )
            (sleep 135)
        )
    )
    (if debug
        (print "placing and dropping covenant")
    )
    (ai_dump_via_phantom "sq_dam_phantom_02/phantom" "sq_dam_ph02_cov_01")
    (sleep 15)
    (if (>= g_dam_obj_control 5)
        (ai_set_objective "sq_dam_ph02_cov_01" "obj_dam_05_06_covenant")
    )
    (sleep 135)
    (sleep 30)
    (object_set_phantom_power (ai_vehicle_get_from_starting_location "sq_dam_phantom_02/phantom") false)
    (sleep 30)
    (if debug
        (print "raise")
    )
    (cs_fly_to "ps_dam/jail_hover" 1)
    (sleep 30)
    (cs_vehicle_speed 1)
    (if debug
        (print "fly away")
    )
    (cs_fly_by "ps_dam/ph01")
    (cs_fly_by "ps_dam/bridge_hover")
    (cs_fly_by "ps_rc/dam_03")
    (cs_fly_by "ps_rc/dam_02")
    (cs_fly_by "ps_rc/dam_01")
    (cs_fly_by "ps_rc/ph_erase")
    (if debug
        (print "delete phantom")
    )
    (ai_erase ai_current_squad)
)

(script command_script void cs_dam_phantom_03
    (set dam_phantom_03 (ai_vehicle_get_from_starting_location "sq_dam_phantom_03/phantom"))
    (if debug
        (print "dam phantom 03")
    )
    (object_cannot_take_damage dam_phantom_03)
    (cs_fly_by "ps_rc/dam_01")
    (cs_fly_by "ps_rc/dam_02")
    (cs_fly_by "ps_rc/dam_03")
    (if debug
        (print "place phantom 04")
    )
    (set g_dam_place_phantom_04 true)
    (cs_fly_by "ps_rc/dam_04")
    (cs_fly_by "ps_dam/ph01")
    (cs_fly_by "ps_dam/ph02")
    (cs_fly_to "ps_dam/ph03_hover" 2)
    (cs_face true "ps_dam/ph01")
    (cs_vehicle_speed 0.5)
    (sleep 90)
    (cs_fly_to "ps_dam/ph03_drop" 2)
    (sleep 60)
    (ai_dump_via_phantom "sq_dam_phantom_03/phantom" "sq_dam_ph03_cov_01")
    (sleep 150)
    (ai_dump_via_phantom "sq_dam_phantom_03/phantom" "sq_dam_ph03_grunt_01")
    (sleep 90)
    (cs_fly_to "ps_dam/ph03_hover" 2)
    (cs_face true "ps_dam/phantom_face")
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (object_can_take_damage dam_phantom_03)
    (sleep_until g_null)
)

(script command_script void cs_dam_phantom_04
    (set dam_phantom_04 (ai_vehicle_get_from_starting_location "sq_dam_phantom_04/phantom"))
    (if debug
        (print "dam phantom 04")
    )
    (object_cannot_take_damage dam_phantom_04)
    (cs_fly_by "ps_rc/dam_01")
    (cs_fly_by "ps_rc/dam_02")
    (cs_fly_by "ps_rc/dam_03")
    (cs_fly_by "ps_rc/dam_04")
    (cs_face true "ps_dam/jail_hover")
    (cs_vehicle_speed 0.35)
    (cs_fly_to "ps_dam/bridge_drop" 1)
    (sleep 60)
    (ai_dump_via_phantom "sq_dam_phantom_04/phantom" "sq_dam_ph04_cov_01")
    (sleep 150)
    (ai_dump_via_phantom "sq_dam_phantom_04/phantom" "sq_dam_ph04_grunt_01")
    (sleep 30)
    (set g_dam_pelican true)
    (if debug
        (print "fly away")
    )
    (cs_fly_to "ps_dam/bridge_hover" 1)
    (sleep 5)
    (set g_dam_phantom_04 true)
    (cs_fly_to "ps_rc/dam_04")
    (cs_face true "ps_dam/phantom_face")
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (object_can_take_damage dam_phantom_04)
    (sleep_until g_null)
)

(script dormant void ai_dam_pelican
    (sleep_until (>= g_dam_obj_control 8))
    (sleep 150)
    (sleep_until g_dam_pelican)
    (sleep 150)
    (sleep_until (<= (ai_task_count "obj_dam_08_evac_covenant/infantry_gate") 6) 30 (* 30 60 0.5))
    (prepare_to_switch_to_zone_set "set_cin_outro_01")
    (zone_set_trigger_volume_enable "zone_set:set_dam" false)
    (zone_set_trigger_volume_enable "begin_zone_set:set_dam" false)
    (sleep (random_range 90 150))
    (if debug
        (print "placing the extraction pelican")
    )
    (ai_place "sq_dam_pelican")
    (game_save)
)

(script command_script void cs_dam_pelican
    (if debug
        (print "here comes the pelican!!!")
    )
    (set dam_pelican (ai_vehicle_get_from_starting_location "sq_dam_pelican/pilot"))
    (cs_enable_pathfinding_failsafe true)
    (cs_fly_by "ps_dam_pelican/pel00")
    (cs_fly_by "ps_dam_pelican/pel01")
    (cs_fly_by "ps_dam_pelican/pel02")
    (set g_dam_pelican_arrive true)
    (cs_fly_to_and_face "ps_dam_pelican/pel03" "ps_dam_pelican/mid_face")
    (game_save)
    (if (>= (ai_living_count "sq_dam_phantom_03") 1)
        (begin
            (set g_dam_pelican_attack01 true)
            (sleep (random_range 45 60))
            (cs_shoot true dam_phantom_03)
            (sleep (random_range 120 150))
            (object_damage_damage_section dam_phantom_03 "death" 4000)
            (sleep 15)
            (cs_shoot false dam_phantom_03)
            (sleep 30)
        )
    )
    (if (>= (ai_living_count "sq_dam_phantom_04") 1)
        (begin
            (set g_dam_pelican_attack02 true)
            (sleep (random_range 45 60))
            (cs_shoot true dam_phantom_04)
            (sleep (random_range 120 150))
            (object_damage_damage_section dam_phantom_04 "death" 4000)
            (sleep 15)
            (cs_shoot false dam_phantom_04)
            (sleep (random_range 30 60))
        )
    )
    (game_save)
    (set g_dam_extraction_location 2)
    (cs_run_command_script "sq_dam_pelican/pilot" cs_dam_pelican_mid)
    (set g_dam_pelican_task true)
)

(script command_script void cs_dam_pelican_mid
    (cs_face true "ps_dam_pelican/mid_face")
    (cs_vehicle_speed 0.5)
    (cs_fly_to "ps_dam_pelican/pel04")
    (cs_fly_to "ps_dam_pelican/mid01" 2)
    (cs_vehicle_speed 0.25)
    (sleep 60)
    (cs_fly_to "ps_dam_pelican/mid02" 1)
    (sleep 60)
    (set g_nav_dam true)
    (cs_run_command_script "gr_arbiter" cs_dam_marines_to_pelican)
    (sleep 30)
    (cs_run_command_script "gr_marines" cs_dam_marines_to_pelican)
    (cs_run_command_script "gr_johnson_marines" cs_dam_marines_to_pelican)
    (sleep_until g_null)
)

(script command_script void cs_dam_marines_to_pelican
    (if debug
        (print "tell all allies to get into the pelican")
    )
    (set g_johnson_pile_in true)
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_go_to_vehicle dam_pelican 21)
)

(script dormant void covenant_activated
    (sleep_until (>= (ai_combat_status "gr_covenant") 4))
    (if debug
        (print "====================== covenant have been activated ============================================ covenant have been activated ======================")
    )
    (sleep 30)
    (if debug
        (print "====================== covenant have been activated ============================================ covenant have been activated ======================")
    )
    (sleep 30)
    (if debug
        (print "====================== covenant have been activated ============================================ covenant have been activated ======================")
    )
)

(script command_script void abort
    (ai_activity_abort ai_current_actor)
    (sleep 1)
)

(script static void sleep_random
    (if debug
        (print "sleep random range")
    )
    (sleep (random_range 60 90))
)

(script static void allies_deathless
    (if debug
        (print "allies cannot die")
    )
    (ai_cannot_die "gr_allies" true)
)

(script static void allies_renew
    (if (<= (game_difficulty_get) normal)
        (begin
            (if debug
                (print "renewing allies")
            )
            (ai_renew "gr_allies")
        )
    )
)

(script command_script void cs_ai_erase
    (cs_enable_looking true)
    (cs_enable_moving true)
    (sleep (* 30 15))
    (ai_erase ai_current_actor)
)

(script command_script void cs_force_status_4
    (cs_force_combat_status 3)
)

(script command_script void cs_crouch_walk
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_enable_dialogue true)
    (cs_crouch true)
    (sleep_until g_null)
)

(script command_script void cs_abort_activity
    (sleep (random_range 250 300))
    (ai_activity_abort ai_current_actor)
)

(script command_script void cs_abort_activity_short
    (sleep (random_range 200 240))
    (ai_activity_abort ai_current_actor)
)

(script command_script void cs_berserk_brutes
    (if debug
        (print "play berserk animation")
    )
    (cs_face_player true)
    (sleep 30)
    (ai_berserk ai_current_actor true)
)

(script command_script void cs_sleep_5
    (sleep (* 30 5))
)

(script continuous void gs_create_rocks
    (sleep_until (!= g_rock_zone_index (current_zone_set)) 1)
    (if (= (current_zone_set) 3)
        (begin
            (if debug
                (print "zone set 2 blockers")
            )
            (zone_set_trigger_volume_enable "zone_set:set_jungle_walk" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_jungle_walk" false)
        )
        (if (= (current_zone_set) 5)
            (begin
                (if debug
                    (print "zone set 5 blockers")
                )
                (object_create_anew "rock_trans_a")
                (zone_set_trigger_volume_enable "zone_set:set_grunt_camp" false)
                (zone_set_trigger_volume_enable "begin_zone_set:set_grunt_camp" false)
                (object_destroy_folder "sc_chief_crater")
                (object_destroy_folder "sc_jungle_walk")
                (object_destroy_folder "foliage_chief_crater")
                (object_destroy_folder "foliage_jungle_walk")
                (object_destroy_folder "cr_jungle_walk")
            )
            (if (= (current_zone_set) 7)
                (begin
                    (if debug
                        (print "zone set 7 blockers")
                    )
                    (object_create_anew "rock_path_a")
                    (zone_set_trigger_volume_enable "zone_set:set_substation" false)
                    (zone_set_trigger_volume_enable "begin_zone_set:set_substation" false)
                    (object_destroy_folder "cr_grunt_camp")
                    (object_destroy_folder "bp_path_a")
                    (object_destroy_folder "wp_path_a")
                )
                (if (= (current_zone_set_fully_active) 9)
                    (begin
                        (if debug
                            (print "zone set 9 blockers")
                        )
                        (object_create_anew_containing "rock_ba_0")
                        (soft_ceiling_enable "camera_pb_03" true)
                        (zone_set_trigger_volume_enable "zone_set:set_path_b" false)
                        (zone_set_trigger_volume_enable "begin_zone_set:set_path_b" false)
                        (object_destroy_folder "eq_substation")
                        (object_destroy_folder "wp_substation")
                        (object_destroy_folder "bp_substation")
                        (object_destroy_folder "cr_substation")
                    )
                    (if (= (current_zone_set) 10)
                        (begin
                            (if debug
                                (print "zone set 10 blockers")
                            )
                            (object_create_anew "rock_trans_b")
                            (zone_set_trigger_volume_enable "zone_set:set_path_c" false)
                            (zone_set_trigger_volume_enable "begin_zone_set:set_path_c" false)
                            (object_destroy_folder "eq_brute_ambush")
                            (object_destroy_folder "wp_brute_ambush")
                        )
                    )
                )
            )
        )
    )
    (set g_rock_zone_index (current_zone_set))
)

(script dormant void gs_award_primary_skull
    (if (award_skull)
        (begin
            (object_create "skull_iron")
            (sleep_until (or (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon") (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon") (unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon") (unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")) 5)
            (if debug
                (print "award iron skull")
            )
            (campaign_metagame_award_primary_skull (player0) 0)
            (campaign_metagame_award_primary_skull (player1) 0)
            (campaign_metagame_award_primary_skull (player2) 0)
            (campaign_metagame_award_primary_skull (player3) 0)
        )
    )
)

(script dormant void gs_award_secondary_skull
    (if (award_skull)
        (begin
            (object_create "skull_blind")
            (sleep_until (or (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\secondary_skull.weapon") (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\secondary_skull.weapon") (unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\secondary_skull.weapon") (unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")) 5)
            (if debug
                (print "award blind skull")
            )
            (campaign_metagame_award_secondary_skull (player0) 1)
            (campaign_metagame_award_secondary_skull (player1) 1)
            (campaign_metagame_award_secondary_skull (player2) 1)
            (campaign_metagame_award_secondary_skull (player3) 1)
        )
    )
)

(script dormant void gs_recycle_volumes
    (sleep_until (> g_gc_obj_control 0))
    (add_recycling_volume "tv_rec_cc" 0 30)
    (add_recycling_volume "tv_rec_jw" 30 30)
    (sleep_until (> g_pa_obj_control 0))
    (add_recycling_volume "tv_rec_jw" 0 30)
    (add_recycling_volume "tv_rec_gc" 30 30)
    (sleep_until (> g_ss_obj_control 0))
    (add_recycling_volume "tv_rec_gc" 0 30)
    (add_recycling_volume "tv_rec_pa" 30 30)
    (sleep_until (> g_pb_obj_control 0))
    (add_recycling_volume "tv_rec_pa" 0 30)
    (add_recycling_volume "tv_rec_ss" 30 30)
    (sleep_until (> g_ba_obj_control 0))
    (add_recycling_volume "tv_rec_ss" 0 30)
    (add_recycling_volume "tv_rec_pb" 30 30)
    (sleep_until (> g_dam_obj_control 0))
    (add_recycling_volume "tv_rec_pb" 0 30)
    (add_recycling_volume "tv_rec_ba" 30 30)
    (sleep_until (>= g_dam_obj_control 5))
    (add_recycling_volume "tv_rec_ba" 0 30)
)

(script dormant void gs_disposable_ai
    (sleep_until (> g_gc_obj_control 0))
    (ai_disposable "gr_jw_covenant" true)
    (ai_disposable "sq_johnson_marines" true)
    (sleep_until (> g_pa_obj_control 0))
    (ai_disposable "gr_gc_covenant" true)
    (sleep_until (> g_ss_obj_control 0))
    (ai_disposable "gr_pa_covenant" true)
    (sleep_until (> g_pb_obj_control 0))
    (ai_disposable "gr_ss_covenant" true)
    (sleep_until (> g_ba_obj_control 0))
    (ai_disposable "gr_pb_covenant" true)
    (sleep_until (> g_dam_obj_control 0))
    (ai_disposable "gr_ba_covenant" true)
)

(script dormant void gs_camera_bounds
    (soft_ceiling_enable "camera_pb_03" false)
    (gs_camera_bounds_on)
    (sleep_until (>= g_cc_obj_control 2) 1)
    (soft_ceiling_enable "camera_cc_00" false)
    (sleep_until (>= g_cc_obj_control 4) 1)
    (soft_ceiling_enable "camera_cc_01" false)
    (sleep_until (>= g_cc_obj_control 6) 1)
    (soft_ceiling_enable "camera_cc_02" false)
    (sleep_until (>= g_cc_obj_control 10) 1)
    (soft_ceiling_enable "camera_cc_03" false)
    (sleep_until (>= g_jw_obj_control 1) 1)
    (soft_ceiling_enable "camera_jw_00" false)
    (sleep_until (>= g_jw_obj_control 3) 1)
    (soft_ceiling_enable "camera_jw_01" false)
    (sleep_until (>= g_jw_obj_control 8) 1)
    (soft_ceiling_enable "camera_jw_02" false)
    (sleep_until (>= g_jw_obj_control 11) 1)
    (soft_ceiling_enable "camera_jw_03" false)
    (sleep_until (>= g_ta_obj_control 1) 1)
    (soft_ceiling_enable "camera_ta_01" false)
    (sleep_until (>= g_ta_obj_control 5) 1)
    (soft_ceiling_enable "camera_ta_02" false)
    (sleep_until (>= g_gc_obj_control 2) 1)
    (soft_ceiling_enable "camera_gc_00" false)
    (sleep_until (>= g_gc_obj_control 7) 1)
    (soft_ceiling_enable "camera_gc_01" false)
    (sleep_until (>= g_pa_obj_control 1) 1)
    (soft_ceiling_enable "camera_pa_00" false)
    (sleep_until (>= g_pa_obj_control 2) 1)
    (soft_ceiling_enable "camera_pa_01" false)
    (sleep_until (>= g_pa_obj_control 3) 1)
    (soft_ceiling_enable "camera_pa_02" false)
    (sleep_until (>= g_ss_obj_control 1) 1)
    (soft_ceiling_enable "camera_ss_00" false)
    (sleep_until (>= g_ss_obj_control 4) 1)
    (soft_ceiling_enable "camera_ss_01" false)
    (sleep_until (>= g_ss_obj_control 10) 1)
    (soft_ceiling_enable "camera_ss_02" false)
    (sleep_until (>= g_pb_obj_control 1) 1)
    (soft_ceiling_enable "camera_pb_00" false)
    (sleep_until (>= g_pb_obj_control 2) 1)
    (soft_ceiling_enable "camera_pb_01" false)
    (sleep_until (>= g_pb_obj_control 3) 1)
    (soft_ceiling_enable "camera_pb_02" false)
    (sleep_until (>= g_ba_obj_control 1) 1)
    (soft_ceiling_enable "camera_ba_00" false)
    (sleep_until (>= g_ba_obj_control 4) 1)
    (soft_ceiling_enable "camera_ba_01" false)
    (sleep_until (>= g_dam_obj_control 1) 1)
    (soft_ceiling_enable "camera_dam_00" false)
    (sleep_until (>= g_dam_obj_control 5) 1)
    (soft_ceiling_enable "camera_dam_01" false)
)

(script static void gs_camera_bounds_off
    (if debug
        (print "turn off camera bounds")
    )
    (soft_ceiling_enable "camera_cc_00" false)
    (soft_ceiling_enable "camera_cc_01" false)
    (soft_ceiling_enable "camera_cc_02" false)
    (soft_ceiling_enable "camera_cc_03" false)
    (soft_ceiling_enable "camera_jw_00" false)
    (soft_ceiling_enable "camera_jw_01" false)
    (soft_ceiling_enable "camera_jw_02" false)
    (soft_ceiling_enable "camera_jw_03" false)
    (soft_ceiling_enable "camera_ta_01" false)
    (soft_ceiling_enable "camera_ta_02" false)
    (soft_ceiling_enable "camera_gc_00" false)
    (soft_ceiling_enable "camera_gc_01" false)
    (soft_ceiling_enable "camera_pa_00" false)
    (soft_ceiling_enable "camera_pa_01" false)
    (soft_ceiling_enable "camera_pa_02" false)
    (soft_ceiling_enable "camera_ss_00" false)
    (soft_ceiling_enable "camera_ss_01" false)
    (soft_ceiling_enable "camera_ss_02" false)
    (soft_ceiling_enable "camera_pb_00" false)
    (soft_ceiling_enable "camera_pb_01" false)
    (soft_ceiling_enable "camera_pb_02" false)
    (soft_ceiling_enable "camera_ba_00" false)
    (soft_ceiling_enable "camera_ba_01" false)
    (soft_ceiling_enable "camera_dam_00" false)
    (soft_ceiling_enable "camera_dam_01" false)
)

(script static void gs_camera_bounds_on
    (if debug
        (print "turn on camera bounds")
    )
    (soft_ceiling_enable "camera_cc_00" true)
    (soft_ceiling_enable "camera_cc_01" true)
    (soft_ceiling_enable "camera_cc_02" true)
    (soft_ceiling_enable "camera_cc_03" true)
    (soft_ceiling_enable "camera_jw_00" true)
    (soft_ceiling_enable "camera_jw_01" true)
    (soft_ceiling_enable "camera_jw_02" true)
    (soft_ceiling_enable "camera_jw_03" true)
    (soft_ceiling_enable "camera_ta_01" true)
    (soft_ceiling_enable "camera_ta_02" true)
    (soft_ceiling_enable "camera_gc_00" true)
    (soft_ceiling_enable "camera_gc_01" true)
    (soft_ceiling_enable "camera_pa_00" true)
    (soft_ceiling_enable "camera_pa_01" true)
    (soft_ceiling_enable "camera_pa_02" true)
    (soft_ceiling_enable "camera_ss_00" true)
    (soft_ceiling_enable "camera_ss_01" true)
    (soft_ceiling_enable "camera_ss_02" true)
    (soft_ceiling_enable "camera_pb_00" true)
    (soft_ceiling_enable "camera_pb_01" true)
    (soft_ceiling_enable "camera_pb_02" true)
    (soft_ceiling_enable "camera_ba_00" true)
    (soft_ceiling_enable "camera_ba_01" true)
    (soft_ceiling_enable "camera_dam_00" true)
    (soft_ceiling_enable "camera_dam_01" true)
)

(script dormant void temp_camera_bounds_off
    (gs_camera_bounds_off)
    (sleep_until 
        (begin
            (sleep_until (!= g_camera_zone_index (current_zone_set)))
            (gs_camera_bounds_off)
            (set g_camera_zone_index (current_zone_set))
            false
        )
    )
)

(script dormant void 010tr_jump
    (sleep_until (>= g_cc_obj_control 2) 1)
    (vs_cast "gr_johnson_marines" true 5 "010ma_100")
    (set johnson (vs_role 1))
    (set g_playing_dialogue true)
    (sleep 1)
    (vs_enable_pathfinding_failsafe johnson true)
    (sleep 1)
    (vs_go_to johnson true "ps_cc/jump_tr")
    (vs_aim_player johnson true)
    (if (<= g_cc_obj_control 2)
        (sleep 30)
    )
    (sleep_until (or (volume_test_players "tv_cc_jump_training") (>= g_cc_obj_control 3)) 5)
    (if (<= g_cc_obj_control 2)
        (begin
            (if dialogue
                (print "johnson: up and over, chief!")
            )
            (vs_play_line johnson true 010ma_100)
            (set g_playing_dialogue false)
        )
    )
    (sleep_until (>= g_cc_obj_control 3) 5 (* 30 10))
    (if (<= g_cc_obj_control 2)
        (begin
            (sleep_until (volume_test_players "tv_cc_jump_training") 1)
            (player_action_test_reset)
            (sleep 1)
            (player_training_activate_jump)
            (if dialogue
                (print "johnson: jump! stretch those legs, spartan!")
            )
            (vs_play_line johnson true 010ma_110)
            (set g_playing_dialogue false)
        )
    )
    (sleep_until (>= g_cc_obj_control 3))
    (set g_playing_dialogue false)
)

(script dormant void 010tr_grenades
    (sleep_until (>= g_ss_obj_control 1))
    (chud_show_grenades true)
    (if debug
        (print "010tr : grenades")
    )
    (if (not (game_is_cooperative))
        (begin
            (vs_cast "gr_arbiter" true 0 "010mf_010")
            (set arbiter (vs_role 1))
        )
        (begin
            (vs_cast "gr_marines" true 0 "010mf_020")
            (set marine_01 (vs_role 1))
        )
    )
    (vs_enable_pathfinding_failsafe "gr_arbiter" true)
    (vs_enable_looking "gr_arbiter" true)
    (vs_enable_targeting "gr_arbiter" true)
    (vs_enable_moving "gr_arbiter" true)
    (vs_enable_pathfinding_failsafe "gr_marines" true)
    (vs_enable_looking "gr_marines" true)
    (vs_enable_targeting "gr_marines" true)
    (vs_enable_moving "gr_marines" true)
    (vs_set_cleanup_script md_cleanup)
    (sleep 1)
    (if (not (game_is_cooperative))
        (begin
            (set g_playing_dialogue true)
            (if dialogue
                (print "arbiter: grenades! blow them to bits!")
            )
            (vs_play_line arbiter true 010mf_010)
            (set g_playing_dialogue false)
            (sleep_until (>= g_ss_obj_control 2) (* 30 10))
            (if (<= g_ss_obj_control 1)
                (begin
                    (set g_playing_dialogue true)
                    (if dialogue
                        (print "arbiter: use those grenades! keep them pinned!")
                    )
                    (vs_play_line arbiter true 010mf_030)
                )
            )
        )
        (begin
            (set g_playing_dialogue true)
            (if dialogue
                (print "marine: grenades! let 'em have it!")
            )
            (vs_play_line marine_01 true 010mf_020)
            (set g_playing_dialogue false)
            (sleep_until (>= g_ss_obj_control 2) (* 30 10))
            (if (<= g_ss_obj_control 1)
                (begin
                    (set g_playing_dialogue false)
                    (if dialogue
                        (print "marine: use those grenades! frag 'em!")
                    )
                    (vs_play_line marine_01 true 010mf_040)
                )
            )
        )
    )
    (set g_playing_dialogue false)
)

(script static void !010lb01_takeoff_middle_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0 0) 0 "010lb_anchor_dam")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0 0) 0)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_dam" "010lb_anchor_dam")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 (cinematic_object_get_scenery "cin_pelican") "takeoff_middle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 (cinematic_object_get_unit "cin_pilot") "010lb01_cin_pilot_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 (cinematic_object_get_unit "cin_pilot1") "010lb01_cin_pilot1_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure 0.1 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_down" 1 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_back" 0.15 0)
    (sleep 1)
    (cinematic_scripting_start_music 0 0 0 0)
    (sleep 29)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_back" 1 15)
    (sleep 5)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_down" 0.25 25)
    (sleep 15)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_down" 1 50)
    (sleep 72)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb01_takeoff_middle_sc
    (sound_class_set_gain "amb" 0 60)
    (cinematic_print "beginning scene 1")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0 0) 0)
    (!010lb01_takeoff_middle_sc_sh1)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
    (cinematic_scripting_destroy_object 0 0 0 (cinematic_object_get_scenery "cin_pelican"))
    (cinematic_scripting_destroy_object 0 0 1 (cinematic_object_get_unit "cin_pilot"))
    (cinematic_scripting_destroy_object 0 0 2 (cinematic_object_get_unit "cin_pilot1"))
)

(script static void !010lb02_transition_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0 1) 0 "010lb_anchor_dam")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0 1) 0)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_dam" "010lb_anchor_dam")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 (cinematic_object_get_unit "cin_arbiter") "010lb02_cin_arbiter_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 (cinematic_object_get_unit "cin_johnson") "010lb02_cin_johnson_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 (cinematic_object_get_scenery "cin_pelican") "pelican_010lb02_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 (cinematic_object_get_unit "cin_masterchief") "010lb02_cin_chief_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 (cinematic_object_get_unit "cin_chief") "010lb02_cin_chief_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure 1 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_back" 0.25 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_down" 0.15 0)
    (sleep 180)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_back" 1 30)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican") "thrusters_down" 0.5 45)
    (sleep 176)
    (cinematic_scripting_fade_out 0 0 0 15)
    (sleep 15)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb02_transition_sc
    (cinematic_print "beginning scene 2")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0 1) 0)
    (!010lb02_transition_sc_sh1)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
    (cinematic_scripting_destroy_object 0 1 0 (cinematic_object_get_unit "cin_arbiter"))
    (cinematic_scripting_destroy_object 0 1 1 (cinematic_object_get_unit "cin_johnson"))
    (cinematic_scripting_destroy_object 0 1 2 (cinematic_object_get_scenery "cin_pelican"))
    (cinematic_scripting_destroy_object 0 1 3 (cinematic_object_get_unit "cin_masterchief"))
    (cinematic_scripting_destroy_object 0 1 4 (cinematic_object_get_unit "cin_chief"))
)

(script static void 010lb_extraction_01_debug
    (cinematic_zone_activate_for_debugging 0)
    (sleep 1)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 2)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
    (fade_in 0 0 0 15)
    (cinematic_outro_start)
    (!010lb01_takeoff_middle_sc)
    (!010lb02_transition_sc)
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 0)
)

(script static void 010lb_extraction_01
    (cinematic_zone_activate 0)
    (sleep 1)
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
    (fade_in 0 0 0 15)
    (cinematic_outro_start)
    (!010lb01_takeoff_middle_sc)
    (!010lb02_transition_sc)
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 010lb_extraction_01_cleanup
    (cinematic_scripting_clean_up 0)
)

(script static void !010lb03_sniper_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1 0) 0 "010lb_anchor_hole")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1 0) 0)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_hole" "010lb_anchor_hole")
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 0 (cinematic_object_get_unit "cin_rocketeer") "010lb03_cin_rocketeer_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 1 (cinematic_object_get_unit "cin_sniper") "010lb03_cin_sniper_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 2 (cinematic_object_get_scenery "cin_scope2") "010lb03_cin_scope_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 (cinematic_object_get_scenery "cin_pelican1") "pelican_010lb03_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 (cinematic_object_get_scenery "cin_rocket_launcher") "010lb03_cin_rocket_launcher_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 (cinematic_object_get_unit "cin_co_pilot") "010lb03_cin_co_pilot_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 (cinematic_object_get_unit "cin_pilot") "010lb03_cin_pilot_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure 0 0)
    (cinematic_scripting_start_music 1 0 0 0)
    (sleep 25)
    (cinematic_scripting_start_dialogue 1 0 0 0 (cinematic_object_get_unit "cin_sniper"))
    (sleep 30)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb03_sniper_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1 0) 1 "010lb_anchor_hole")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1 0) 1)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_hole" "010lb_anchor_hole")
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 0 (cinematic_object_get_unit "cin_rocketeer") "010lb03_cin_rocketeer_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 1 (cinematic_object_get_unit "cin_sniper") "010lb03_cin_sniper_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 2 (cinematic_object_get_scenery "cin_scope2") "010lb03_cin_scope_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 (cinematic_object_get_scenery "cin_pelican1") "pelican_010lb03_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 (cinematic_object_get_scenery "cin_rocket_launcher") "010lb03_cin_rocket_launcher_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 (cinematic_object_get_unit "cin_co_pilot") "010lb03_cin_co_pilot_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 (cinematic_object_get_unit "cin_pilot") "010lb03_cin_pilot_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (render_exposure 0.5 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_down" 0.25 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_back" 0.2 0)
    (sleep 101)
    (cinematic_scripting_start_dialogue 1 0 1 0 none)
    (sleep 70)
    (cinematic_scripting_start_dialogue 1 0 1 1 none)
    (sleep 109)
    (cinematic_scripting_start_dialogue 1 0 1 2 none)
    (sleep 35)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_down" 1 15)
    (sleep 35)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_down" 0 10)
    (sleep 10)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_down" 1 15)
    (sleep 48)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb03_sniper_sc_sh3
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1 0) 2 "010lb_anchor_hole")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1 0) 2)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_hole" "010lb_anchor_hole")
    (object_hide (cinematic_object_get_unit "cin_rocketeer") true)
    (object_hide (cinematic_object_get_unit "cin_sniper") true)
    (object_hide (cinematic_object_get_scenery "cin_scope2") true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 (cinematic_object_get_scenery "cin_pelican1") "pelican_010lb03_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 (cinematic_object_get_scenery "cin_rocket_launcher") "010lb03_cin_rocket_launcher_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 (cinematic_object_get_unit "cin_co_pilot") "010lb03_cin_co_pilot_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 (cinematic_object_get_unit "cin_pilot") "010lb03_cin_pilot_3" true)
    (cinematic_lights_initialize_for_shot 2)
    (cinematic_clips_initialize_for_shot 2)
    (render_exposure 1 0)
    (object_set_function_variable (cinematic_object_get_scenery "cin_pelican1") "thrusters_down" 1 0)
    (sleep 25)
    (cinematic_print "custom script play")
    (sound_looping_stop "levels\solo\010_jungle\music\010_music_08")
    (sleep 129)
    (fade_out 0 0 0 20)
    (cinematic_print "custom script play")
    (sleep 6)
    (cinematic_scripting_fade_out 0 0 0 15)
    (sleep 14)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb03_sniper_sc_sh4
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1 0) 3 "010lb_anchor_hole")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1 0) 3)
    (cinematic_object_create_cinematic_anchor "010lb_anchor_hole" "010lb_anchor_hole")
    (object_hide (cinematic_object_get_unit "cin_rocketeer") true)
    (object_hide (cinematic_object_get_unit "cin_sniper") true)
    (object_hide (cinematic_object_get_scenery "cin_scope2") true)
    (object_hide (cinematic_object_get_scenery "cin_pelican1") true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 (cinematic_object_get_scenery "cin_rocket_launcher") "010lb03_cin_rocket_launcher_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 (cinematic_object_get_unit "cin_co_pilot") "010lb03_cin_co_pilot_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 (cinematic_object_get_unit "cin_pilot") "010lb03_cin_pilot_4" true)
    (cinematic_lights_initialize_for_shot 3)
    (cinematic_clips_initialize_for_shot 3)
    (sleep 1)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010lb03_sniper_sc
    (cinematic_print "beginning scene 1")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1 0) 0)
    (!010lb03_sniper_sc_sh1)
    (!010lb03_sniper_sc_sh2)
    (!010lb03_sniper_sc_sh3)
    (!010lb03_sniper_sc_sh4)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
    (cinematic_scripting_destroy_object 1 0 0 (cinematic_object_get_unit "cin_rocketeer"))
    (cinematic_scripting_destroy_object 1 0 1 (cinematic_object_get_unit "cin_sniper"))
    (cinematic_scripting_destroy_object 1 0 2 (cinematic_object_get_scenery "cin_scope2"))
    (cinematic_scripting_destroy_object 1 0 3 (cinematic_object_get_scenery "cin_pelican1"))
    (cinematic_scripting_destroy_object 1 0 4 (cinematic_object_get_scenery "cin_rocket_launcher"))
    (cinematic_scripting_destroy_object 1 0 5 (cinematic_object_get_unit "cin_co_pilot"))
    (cinematic_scripting_destroy_object 1 0 6 (cinematic_object_get_unit "cin_pilot"))
    (sleep 60)
)

(script static void 010lb_extraction_02_debug
    (cinematic_zone_activate_for_debugging 1)
    (sleep 1)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 2)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
    (fade_in 0 0 0 15)
    (cinematic_outro_start)
    (!010lb03_sniper_sc)
    (sleep 60)
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 1)
)

(script static void 010lb_extraction_02
    (cinematic_zone_activate 1)
    (sleep 1)
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
    (fade_in 0 0 0 15)
    (cinematic_outro_start)
    (!010lb03_sniper_sc)
    (sleep 60)
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 010lb_extraction_02_cleanup
    (cinematic_scripting_clean_up 1)
)

(script static void !010pa01_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 2 0) 0 "010pa_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 2 0) 0)
    (cinematic_object_create_cinematic_anchor "010pa_anchor" "010pa_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 0 obj_arbiter "010pa_arbiter_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 1 (player0) "010pa_chief_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 2 (player1) "010pa_arbiter_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (sleep 170)
    (cinematic_scripting_start_dialogue 2 0 0 0 obj_arbiter)
    (sleep 130)
    (cinematic_scripting_start_dialogue 2 0 0 1 obj_arbiter)
    (sleep 135)
    (cinematic_scripting_fade_out 0 0 0 10)
    (cinematic_print "waiting for event (set perspective_finished true) which occurs at frame 445, but shot only has 445 frames")
    (sleep 10)
    (set perspective_finished true)
    (cinematic_print "waiting for event (cinematic_print "custom script play") which occurs at frame 445, but shot only has 445 frames")
    (cinematic_print "custom script play")
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010pa01
    (cinematic_print "beginning scene 1")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 2 0) 0)
    (!010pa01_sh1)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
    (cinematic_scripting_destroy_object 2 0 0 obj_arbiter)
    (cinematic_scripting_destroy_object 2 0 1 (player0))
    (cinematic_scripting_destroy_object 2 0 2 (player1))
)

(script static void !pm_010pa_jail_bait
    (cinematic_zone_activate 2)
    (sleep 1)
    (!010pa01)
    (cinematic_zone_deactivate 2)
)

(script continuous void !pi_010pa_jail_bait
    (sleep_forever)
    (cinematic_set_early_exit 0)
    (!pm_010pa_jail_bait)
    (cinematic_set_early_exit 1)
)

(script static void 010pa_jail_bait
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 2))
    (wake !pi_010pa_jail_bait)
    (fade_in 0 0 0 10)
    (set perspective_running true)
    (player_action_test_reset)
    (sleep 1)
    (sleep_until (or (not (= (cinematic_get_early_exit) 0)) (player_action_test_cinematic_skip)) 1)
    (cinematic_camera_set_easing_out 0)
    (sleep 0)
    (cinematic_set_early_exit 2)
    (set perspective_running false)
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 010pa_jail_bait_debug
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 2)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set (cinematic_tag_reference_get_cinematic 2))
    (wake !pi_010pa_jail_bait)
    (fade_in 0 0 0 10)
    (set perspective_running true)
    (player_action_test_reset)
    (sleep 1)
    (sleep_until (or (not (= (cinematic_get_early_exit) 0)) (player_action_test_cinematic_skip)) 1)
    (cinematic_camera_set_easing_out 0)
    (sleep 0)
    (cinematic_set_early_exit 2)
    (set perspective_running false)
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
)

(script static void !010ca_sacrifice_me_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 3 0) 0 "cortana_flag")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 3 0) 0)
    (cinematic_object_create_cinematic_anchor "cortana_flag" "cortana_flag")
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 0 (cinematic_object_get_unit "cin_cortana") "010ca_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_play_cortana_effect 3 0 0 0)
    (sleep 1)
    (cinematic_scripting_start_dialogue 3 0 0 0 none)
    (sleep 252)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !010ca_sacrifice_me_sc
    (cinematic_print "beginning scene 1")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 3 0) 0)
    (!010ca_sacrifice_me_sc_sh1)
    (cinematic_lights_destroy)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
    (cinematic_scripting_destroy_object 3 0 0 (cinematic_object_get_unit "cin_cortana"))
)

(script continuous void 010ca_sacrifice_me
    (sleep_forever)
    (cinematic_zone_activate 3)
    (sleep 1)
    (cinematic_set (cinematic_tag_reference_get_cinematic 3))
    (set g_cortana_header true)
    (camera_set_cinematic)
    (camera_set_briefing true)
    (!010ca_sacrifice_me_sc)
    (begin
        (set g_cortana_footer true)
        (set g_pa_cortana_dialogue true)
    )
    (cinematic_scripting_destroy_cortana_effect_cinematic)
    (cinematic_zone_deactivate 3)
)

(script static void cortana_effect_010la09_corfx
    (play_cortana_effect "010la09_corfx")
    (texture_camera_on)
)

(script static void cortana_effect_010la01_corfx
    (play_cortana_effect "010la01_corfx")
    (texture_camera_on)
)

; Decompilation finished in ~0.2742631s
