; Decompiled with Assembly
; 
; Source file: mainmenu.hsc
; Start time: 9/8/2018 1:29:28 AM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global string data_mine_mission_segment "")
(global boolean perspective_running false)
(global short ui_location 65535)
(global real mainmenu_offset 0)
(global long wait_ticks 0)
(global short ui_location_clock_start 65535)

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
                (>= (object_get_shield (player3)) 1)
            )
            (if (= (game_coop_player_count) 2)
                (begin
                    (>= (object_get_shield (player0)) 1)
                    (>= (object_get_shield (player1)) 1)
                    (>= (object_get_shield (player2)) 1)
                    (>= (object_get_shield (player3)) 1)
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

(script static void print_difficulty
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

(script static void cinematic_fade_to_white
    (player_enable_input false)
    (player_camera_control false)
    (chud_cinematic_fade 0 0.5)
    (cinematic_start)
    (fade_out 1 1 1 30)
    (sleep 30)
    (camera_control true)
)

(script static void cinematic_fade_from_white
    (chud_cinematic_fade 1 0.5)
    (cinematic_stop)
    (camera_control false)
    (fade_in 1 1 1 15)
    (sleep 15)
    (player_enable_input true)
    (player_camera_control true)
)

(script static void cinematic_fade_from_white_bars
    (cinematic_stop)
    (cinematic_show_letterbox_immediate true)
    (camera_control false)
    (fade_in 1 1 1 15)
    (sleep 15)
    (player_enable_input true)
    (player_camera_control true)
)

(script static void cinematic_fade_from_black_bars
    (cinematic_stop)
    (cinematic_show_letterbox_immediate true)
    (camera_control false)
    (fade_in 0 0 0 15)
    (sleep 15)
    (player_enable_input true)
    (player_camera_control true)
)

(script static void cinematic_fade_to_black
    (player_enable_input false)
    (player_camera_control false)
    (chud_cinematic_fade 0 0.5)
    (cinematic_start)
    (fade_out 0 0 0 30)
    (sleep 30)
    (camera_control true)
)

(script static void cinematic_fade_from_black
    (chud_cinematic_fade 1 0.5)
    (cinematic_stop)
    (camera_control false)
    (fade_in 0 0 0 15)
    (sleep 15)
    (player_enable_input true)
    (player_camera_control true)
)

(script static void cinematic_snap_to_black
    (player_enable_input false)
    (player_camera_control false)
    (fade_out 0 0 0 0)
    (chud_cinematic_fade 0 0)
    (cinematic_start)
    (cinematic_show_letterbox_immediate true)
    (camera_control true)
)

(script static void cinematic_snap_to_white
    (player_enable_input false)
    (player_camera_control false)
    (fade_out 1 1 1 0)
    (chud_cinematic_fade 0 0)
    (cinematic_start)
    (cinematic_show_letterbox_immediate true)
    (camera_control true)
)

(script static void perspective_start
    (set perspective_running true)
)

(script static void perspective_stop
    (set perspective_running false)
)

(script static boolean perspective_skip_start
    (player_action_test_reset)
    (sleep_until (or (not perspective_running) (player_action_test_cinematic_skip)) 1)
    perspective_running
)

(script static void cinematic_start_perspective
    (player_disable_movement true)
    (player_camera_control false)
    (chud_cinematic_fade 0 0.5)
    (cinematic_show_letterbox true)
    (fade_out 1 1 1 15)
    (sleep 15)
    (camera_control true)
)

(script static void cinematic_to_perspective
    (fade_in 1 1 1 15)
    (sleep 15)
)

(script static void cinematic_from_perspective
    (cinematic_show_letterbox false)
    (fade_out 1 1 1 15)
    (sleep 15)
)

(script static void cinematic_stop_perspective
    (camera_control false)
    (chud_cinematic_fade 1 0.5)
    (fade_in 1 1 1 15)
    (sleep 15)
    (player_disable_movement false)
    (player_camera_control true)
)

(script static void cinematic_stash_players
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_cannot_take_damage (players))
)

(script static void cinematic_unstash_players
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_can_take_damage (players))
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
    (data_mine_set_mission_segment "questionaire")
    (fade_in 0 0 0 0)
    (hud_enable_training true)
    (sleep 30)
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
    (game_won)
)

(script dormant void scarab_death
    (print "dead scarab event")
    (object_cannot_take_damage (players))
    (fade_out 1 1 1 1)
    (sleep 45)
    (fade_in 1 1 1 120)
    (object_can_take_damage (players))
)

(script startup void beginning_mission_segment
    (data_mine_set_mission_segment "mission_start")
)

(script static void (sleep_ui (long timer_ticks))
    (print "sleep ui script")
    (set ui_location_clock_start ui_location)
    (set wait_ticks 0)
    (sleep_until 
        (begin
            (set wait_ticks (+ wait_ticks 1))
            (if (!= ui_location ui_location_clock_start)
                (set wait_ticks timer_ticks)
            )
            (>= wait_ticks timer_ticks)
        )
        1
    )
)

(script static void (set_ui_location (short location))
    (set ui_location location)
    (sleep 1)
)

(script static void kill_camera_scripts
    (print "kill camera scripts")
    (kill_active_scripts)
    (if (!= ui_location 0)
        (sleep_forever mainmenu_cam)
    )
    (if (!= ui_location 1)
        (sleep_forever campaign_cam)
    )
    (if (!= ui_location 2)
        (sleep_forever matchmaking_cam)
    )
    (if (!= ui_location 3)
        (sleep_forever custom_cam)
    )
    (if (!= ui_location 4)
        (sleep_forever editor_cam)
    )
    (if (!= ui_location 5)
        (sleep_forever theater_cam)
    )
)

(script startup void mainmenu
    (print "mainmenu statup script")
    (fade_in 0 0 0 30)
    (set ui_location 65535)
    (cinematic_lighting_initialize)
    (cinematic_light_object (ai_get_object "custom/mc1") custom_games 1 1)
    (cinematic_light_object (ai_get_object "custom/mc2") custom_games 1 1)
    (cinematic_light_object (ai_get_object "custom/mc3") custom_games 1 1)
    (cinematic_light_object "editorifle" editor 1 1)
    (cinematic_light_object "earth" matchmaking 1 1)
    (cinematic_light_object "pelicampaign" campaign 1 1)
    (camera_control true)
    (ai_place "custom")
    (sleep_ui 1)
    (pvs_set_object (ai_get_object "custom"))
    (ai_place "appearance")
    (sleep_ui 1)
    (cinematic_light_object (ai_get_object "appearance/chief") appearance 1 1)
    (cinematic_light_object (ai_get_object "appearance/elite") appearance 1 1)
)

(script static void mainmenu_cam
    (print "mainmenu camera")
    (set_ui_location 0)
    (kill_camera_scripts)
    (render_depth_of_field_enable false)
    (set render_postprocess_saturation 0.4)
    (set render_postprocess_red_filter 0.15)
    (set render_postprocess_green_filter 0.25)
    (set render_postprocess_blue_filter 0.5)
    (camera_set_animation_relative_with_speed_loop_offset "objects\characters\cinematic_camera\ui\valhalla\valhalla" "camera_path1" none "xxxanchorxxx" 0.5 true mainmenu_offset)
    (set mainmenu_offset (real_random_range 0 1))
    (sleep_forever)
)

(script static void campaign_cam
    (print "campaign camera")
    (set_ui_location 1)
    (kill_camera_scripts)
    (render_postprocess_color_tweaking_reset)
    (camera_set "campaign" 1)
    (render_depth_of_field_enable true)
    (render_depth_of_field 0 5 5.6 0)
    (sleep_forever)
)

(script static void matchmaking_cam
    (print "matchmaking camera")
    (set_ui_location 2)
    (kill_camera_scripts)
    (render_postprocess_color_tweaking_reset)
    (camera_set "matchmaking" 1)
    (render_depth_of_field_enable true)
    (render_depth_of_field 0 3.2 3.4 0)
    (sleep_forever)
)

(script static void custom_cam
    (print "custom camera")
    (set_ui_location 3)
    (kill_camera_scripts)
    (render_postprocess_color_tweaking_reset)
    (camera_set "custom_games" 1)
    (render_depth_of_field_enable true)
    (render_depth_of_field 0 0.2 1.2 0)
    (sleep_forever)
)

(script static void editor_cam
    (print "editor camera")
    (set_ui_location 4)
    (kill_camera_scripts)
    (render_postprocess_color_tweaking_reset)
    (camera_set "editor" 1)
    (render_depth_of_field_enable true)
    (render_depth_of_field 0 0.08 0.09 0)
    (sleep_forever)
)

(script static void theater_cam
    (print "theater camera")
    (set_ui_location 5)
    (kill_camera_scripts)
    (render_postprocess_color_tweaking_reset)
    (camera_set "theater" 1)
    (render_depth_of_field_enable true)
    (render_depth_of_field 0 2 1 0)
    (sleep_forever)
)

; Decompilation finished in ~0.0090005s
