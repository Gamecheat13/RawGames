; Decompiled with Assembly
; 
; Source file: deadlock.hsc
; Start time: 9/8/2018 1:28:56 AM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global string data_mine_mission_segment "")
(global boolean perspective_running false)

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

(script dormant void reset_map_reminder
    (sleep_until 
        (begin
            (print "press a to play again!")
            false
        )
        90
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

(script static void perspective_start
    (set perspective_running true)
)

(script static void perspective_stop
    (set perspective_running false)
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

(script static void playtest_mission
    (sleep 1)
)

(script static ai (ai_get_driver (ai vehicle_starting_location))
    (object_get_ai (vehicle_driver (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

(script static ai (ai_get_gunner (ai vehicle_starting_location))
    (object_get_ai (vehicle_gunner (ai_vehicle_get_from_starting_location vehicle_starting_location)))
)

; Decompilation finished in ~0.0170009s
