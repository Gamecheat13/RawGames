; Decompiled with Assembly
; 
; Source file: 20_sword_slayer.hsc
; Start time: 2018-06-28 4:23:08 PM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global boolean b_debug_globals false)
(global short player_00 0)
(global short player_01 1)
(global short player_02 2)
(global short player_03 3)
(global short s_md_play_time 0)
(global string data_mine_mission_segment "")
(global boolean b_debug_cinematic_scripts true)
(global sound sfx_a_button none)
(global sound sfx_b_button none)
(global sound sfx_hud_in none)
(global sound sfx_hud_out none)
(global sound sfx_objective none)
(global sound sfx_tutorial_complete "sound\game_sfx\ui\pda_transition.sound")
(global sound sfx_blip "sound\game_sfx\ui\transition_beeps")
(global object_list l_blip_list (players))
(global boolean b_blip_list_locked false)
(global short s_blip_list_index 0)
(global short blip_neutralize 0)
(global short blip_defend 1)
(global short blip_ordnance 2)
(global short blip_interface 3)
(global short blip_recon 4)
(global short blip_recover 5)
(global short blip_hostile 6)
(global short blip_neutralize_alpha 7)
(global short blip_neutralize_bravo 8)
(global short blip_neutralize_charlie 9)
(global boolean b_is_dialogue_playing false)

; Scripts
(script static unit player0
    (player_get 0)
)

(script static unit player1
    (player_get 1)
)

(script static unit player2
    (player_get 2)
)

(script static unit player3
    (player_get 3)
)

(script static short player_count
    (list_count (players))
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
    (= (game_difficulty_get_real) legendary)
)

(script static boolean difficulty_heroic
    (= (game_difficulty_get_real) heroic)
)

(script static boolean difficulty_normal
    (<= (game_difficulty_get_real) normal)
)

(script static void replenish_players
    (if b_debug_globals
        (print "replenish player health...")
    )
    (unit_set_current_vitality (player0) 80 80)
    (unit_set_current_vitality (player1) 80 80)
    (unit_set_current_vitality (player2) 80 80)
    (unit_set_current_vitality (player3) 80 80)
)

(script static boolean coop_players_2
    (>= (game_coop_player_count) 2)
)

(script static boolean coop_players_3
    (>= (game_coop_player_count) 3)
)

(script static boolean coop_players_4
    (>= (game_coop_player_count) 4)
)

(script static boolean any_players_in_vehicle
    (or (unit_in_vehicle (unit (player0))) (unit_in_vehicle (unit (player1))) (unit_in_vehicle (unit (player2))) (unit_in_vehicle (unit (player3))))
)

(script static void (f_vehicle_scale_destroy (vehicle vehicle_variable))
    (object_set_scale vehicle_variable 0.01 (* 30 5))
    (sleep (* 30 5))
    (object_destroy vehicle_variable)
)

(script static void (f_coop_resume_unlocked (cutscene_title resume_title, short insertion_point))
    (if (game_is_cooperative)
        (begin
            (sound_impulse_start sfx_hud_in none 1)
            (cinematic_set_chud_objective resume_title)
            (game_insertion_point_unlock insertion_point)
        )
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

(script static void cinematic_skip_stop_terminal
    (cinematic_skip_stop_internal)
    (if (not (game_reverted))
        (begin
            (game_revert)
            (if b_debug_globals
                (print "sleeping forever...")
            )
            (sleep_forever)
        )
    )
)

(script static void test_cinematic_enter_exit
    (cinematic_enter "snap_to_white" false)
    (sleep 30)
    (cinematic_exit "fade_from_white" true)
)

(script static void (cinematic_enter (string fade_type, boolean lower_weapon))
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (if (= fade_type "fade_to_black")
        (player_control_fade_out_all_input 1)
        (if (= fade_type "fade_to_white")
            (player_control_fade_out_all_input 1)
            (if (= fade_type "snap_to_black")
                (player_control_fade_out_all_input 0)
                (if (= fade_type "snap_to_white")
                    (player_control_fade_out_all_input 0)
                    (if (= fade_type "no_fade")
                        (player_control_fade_out_all_input 0)
                    )
                )
            )
        )
    )
    (if (= lower_weapon true)
        (begin
            (if (or (= fade_type "fade_to_black") (= fade_type "fade_to_white") (= fade_type "no_fade"))
                (begin
                    (if b_debug_cinematic_scripts
                        (print "lowering weapon slowly...")
                    )
                    (unit_lower_weapon (player0) 30)
                    (unit_lower_weapon (player1) 30)
                    (unit_lower_weapon (player2) 30)
                    (unit_lower_weapon (player3) 30)
                )
            )
        )
    )
    (campaign_metagame_time_pause true)
    (if (= fade_type "fade_to_black")
        (chud_cinematic_fade 0 0.5)
        (if (= fade_type "fade_to_white")
            (chud_cinematic_fade 0 0.5)
            (if (= fade_type "snap_to_black")
                (chud_cinematic_fade 0 0)
                (if (= fade_type "snap_to_white")
                    (chud_cinematic_fade 0 0)
                    (if (= fade_type "no_fade")
                        (chud_cinematic_fade 0 0.5)
                    )
                )
            )
        )
    )
    (if (= fade_type "fade_to_black")
        (begin
            (fade_out 0 0 0 30)
            (sleep 30)
        )
        (if (= fade_type "fade_to_white")
            (begin
                (fade_out 1 1 1 30)
                (sleep 30)
            )
            (if (= fade_type "snap_to_black")
                (fade_out 0 0 0 0)
                (if (= fade_type "snap_to_white")
                    (fade_out 1 1 1 0)
                )
            )
        )
    )
    (if b_debug_cinematic_scripts
        (print "hiding players...")
    )
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_hide (player2) true)
    (object_hide (player3) true)
    (player_enable_input false)
    (player_disable_movement true)
    (sleep 1)
    (if b_debug_cinematic_scripts
        (print "camera control on")
    )
    (camera_control true)
    (cinematic_start)
)

(script static void (cinematic_exit (string fade_type, boolean weapon_starts_lowered))
    (cinematic_stop)
    (camera_control false)
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_hide (player2) false)
    (object_hide (player3) false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "snapping weapon to lowered state...")
            )
            (unit_lower_weapon (player0) 1)
            (unit_lower_weapon (player1) 1)
            (unit_lower_weapon (player2) 1)
            (unit_lower_weapon (player3) 1)
            (sleep 1)
        )
    )
    (player_control_unlock_gaze (player0))
    (player_control_unlock_gaze (player1))
    (player_control_unlock_gaze (player2))
    (player_control_unlock_gaze (player3))
    (sleep 1)
    (if (= fade_type "fade_from_black")
        (begin
            (if b_debug_cinematic_scripts
                (print "fading from black...")
            )
            (fade_in 0 0 0 30)
            (sleep 20)
        )
        (if (= fade_type "fade_from_white")
            (begin
                (if b_debug_cinematic_scripts
                    (print "fading from white...")
                )
                (fade_in 1 1 1 30)
                (sleep 20)
            )
            (if (= fade_type "snap_from_black")
                (begin
                    (if b_debug_cinematic_scripts
                        (print "snapping from black...")
                    )
                    (fade_in 0 0 0 5)
                    (sleep 5)
                )
                (if (= fade_type "snap_from_white")
                    (begin
                        (if b_debug_cinematic_scripts
                            (print "snapping from white...")
                        )
                        (fade_in 1 1 1 5)
                        (sleep 5)
                    )
                    (if (= fade_type "no_fade")
                        (begin
                            (fade_in 1 1 1 0)
                            (sleep 5)
                        )
                    )
                )
            )
        )
    )
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "raising player weapons slowly...")
            )
            (unit_raise_weapon (player0) 30)
            (unit_raise_weapon (player1) 30)
            (unit_raise_weapon (player2) 30)
            (unit_raise_weapon (player3) 30)
            (sleep 10)
        )
    )
    (chud_cinematic_fade 1 1)
    (sleep 1)
    (player_enable_input true)
    (player_control_fade_in_all_input 1)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (player_disable_movement false)
)

(script static void cinematic_snap_to_black
    (cinematic_enter "fade_to_black" false)
)

(script static void cinematic_snap_to_white
    (cinematic_enter "fade_to_white" false)
)

(script static void cinematic_preparation
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (player_control_fade_out_all_input 0)
    (object_hide (player0) true)
    (object_hide (player1) true)
    (object_hide (player2) true)
    (object_hide (player3) true)
    (replenish_players)
    (chud_cinematic_fade 0 0)
    (chud_show_messages false)
    (campaign_metagame_time_pause true)
    (player_enable_input false)
    (player_disable_movement false)
    (sleep 1)
    (if (not (campaign_survival_enabled))
        (cinematic_start)
    )
    (camera_control true)
)

(script static void cinematic_snap_from_black
    (cinematic_exit "snap_from_black" false)
)

(script static void cinematic_snap_from_white
    (cinematic_exit "snap_from_white" false)
)

(script static void cinematic_snap_from_pre
    (if (not (campaign_survival_enabled))
        (cinematic_stop)
    )
    (camera_control false)
    (cinematic_show_letterbox_immediate false)
    (cinematic_hud_off)
    (sleep 1)
    (chud_cinematic_fade 1 0)
    (object_hide (player0) false)
    (object_hide (player1) false)
    (object_hide (player2) false)
    (object_hide (player3) false)
)

(script static void cinematic_snap_from_post
    (player_enable_input true)
    (player_control_fade_in_all_input 1)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (player_disable_movement false)
    (chud_show_messages true)
    (if (not (campaign_survival_enabled))
        (game_save)
    )
)

(script static void cinematic_fade_to_black
    (cinematic_enter "fade_to_black" true)
)

(script static void cinematic_fade_to_white
    (cinematic_enter "fade_to_white" true)
)

(script static void cinematic_fade_to_gameplay
    (cinematic_exit "fade_from_black" true)
)

(script static void cinematic_hud_on
    (chud_cinematic_fade 1 0)
    (chud_show_crosshair false)
)

(script static void cinematic_hud_off
    (chud_cinematic_fade 0 0)
    (chud_show_crosshair true)
)

(script static void performance_default_script
    (sleep_until 
        (begin
            (performance_play_line_by_id (+ (performance_get_last_played_line_index) 1))
            (>= (+ (performance_get_last_played_line_index) 1) (performance_get_line_count))
        )
        0
    )
)

(script static void end_mission
    (game_won)
)

(script static void (f_start_mission (script cinematic_intro, string snap_color))
    (if (= snap_color "black")
        (cinematic_enter "snap_to_black" false)
        (if (= snap_color "white")
            (cinematic_enter "snap_to_white" false)
            (if (= snap_color "no_fade")
                (cinematic_enter "no_fade" false)
            )
        )
    )
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_cinematic_scripts
                (print "cinematic_skip_start is true... starting cinematic...")
            )
            (sound_class_set_gain "" 0 0)
            (sound_class_set_gain "mus" 1 0)
            (evaluate cinematic_intro)
        )
        (cinematic_skip_stop)
    )
    (if b_debug_cinematic_scripts
        (print "done with cinematic. resetting audio levels...")
    )
    (sound_class_set_gain "" 1 0)
)

(script static void (f_play_cinematic (script cinematic_outro, zone_set cinematic_zone_set, string fade_type))
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: calling cinematic_enter")
    )
    (if (= fade_type "fade_to_black")
        (cinematic_enter "fade_to_black" true)
        (if (= fade_type "fade_to_white")
            (cinematic_enter "fade_to_white" true)
            (if (= fade_type "snap_to_black")
                (cinematic_enter "snap_to_black" true)
                (if (= fade_type "snap_to_white")
                    (cinematic_enter "snap_to_white" true)
                )
            )
        )
    )
    (sleep 1)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (begin
        (if b_debug_globals
            (print "f_play_cinematic: playing cinematic...")
        )
        (sleep 30)
        (sound_class_set_gain "" 0 0)
        (sound_class_set_gain "mus" 1 0)
        (evaluate cinematic_outro)
    )
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: done with cinematic. resetting audio levels...")
    )
    (sound_class_set_gain "" 1 0)
    (if (= fade_type "fade_to_black")
        (fade_out 0 0 0 0)
        (if (= fade_type "fade_to_white")
            (fade_out 1 1 1 0)
            (if (= fade_type "snap_to_black")
                (fade_out 0 0 0 0)
                (if (= fade_type "snap_to_white")
                    (fade_out 1 1 1 0)
                )
            )
        )
    )
)

(script static void (f_end_mission (script cinematic_outro, zone_set cinematic_zone_set, string fade_type))
    (if (= fade_type "fade_to_black")
        (cinematic_fade_to_black)
        (if (= fade_type "fade_to_white")
            (cinematic_fade_to_white)
            (if (= fade_type "snap_to_black")
                (cinematic_snap_to_black)
                (if (= fade_type "snap_to_white")
                    (cinematic_snap_to_white)
                )
            )
        )
    )
    (sleep 1)
    (ai_erase_all)
    (garbage_collect_now)
    (switch_zone_set cinematic_zone_set)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_globals
                (print "play outro cinematic...")
            )
            (sleep 30)
            (evaluate cinematic_outro)
            (sound_class_set_gain "" 0 0)
        )
    )
    (cinematic_skip_stop_internal)
    (sound_class_set_gain "" 0 0)
    (sound_class_set_gain "ui" 1 0)
    (cinematic_snap_to_black)
)

(script static void (f_end_scene (script cinematic_outro, zone_set cinematic_zone_set, string_id scene_boolean, string_id scene_name, string snap_color))
    (if (= snap_color "black")
        (cinematic_snap_to_black)
        (if (= snap_color "white")
            (cinematic_snap_to_white)
        )
    )
    (sleep 1)
    (ai_erase_all)
    (garbage_collect_now)
    (switch_zone_set cinematic_zone_set)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (begin
        (if (cinematic_skip_start)
            (begin
                (if b_debug_globals
                    (print "play outro cinematic...")
                )
                (sleep 30)
                (evaluate cinematic_outro)
                (sound_class_set_gain "" 0 0)
            )
        )
        (cinematic_skip_stop_internal)
    )
    (sound_class_set_gain "" 0 0)
    (sound_class_set_gain "ui" 1 0)
    (cinematic_snap_to_black)
    (if b_debug_globals
        (print "switch to scene...")
    )
)

(script startup void beginning_mission_segment
    (data_mine_set_mission_segment "mission_start")
)

(script static void (f_sfx_a_button (short player_short))
    (sound_impulse_start sfx_a_button (player_get player_short) 1)
)

(script static void (f_sfx_b_button (short player_short))
    (sound_impulse_start sfx_b_button (player_get player_short) 1)
)

(script static void (f_sfx_hud_in (short player_short))
    (sound_impulse_start sfx_hud_in (player_get player_short) 1)
)

(script static void (f_sfx_hud_out (short player_short))
    (sound_impulse_start sfx_hud_out (player_get player_short) 1)
)

(script static void (f_sfx_hud_tutorial_complete (short player_short))
    (sound_impulse_start sfx_tutorial_complete (player_get player_short) 1)
)

(script static void (f_display_message (short player_short, cutscene_title display_title))
    (chud_show_cinematic_title (player_get player_short) display_title)
    (sleep 5)
)

(script static void (f_tutorial_begin (short player_short, cutscene_title display_title))
    (chud_show_cinematic_title (player_get player_short) display_title)
    (sleep 5)
    (unit_action_test_reset (player_get player_short))
    (sleep 5)
)

(script static void (f_tutorial_end (short player_short, cutscene_title blank_title))
    (f_sfx_hud_tutorial_complete player_short)
    (chud_show_cinematic_title (player_get player_short) blank_title)
    (sleep 5)
)

(script static void (f_tutorial_boost (short player_short, cutscene_title display_title, cutscene_title blank_title))
    (f_tutorial_begin player_short display_title)
    (sleep_until (unit_action_test_grenade_trigger (player_get player_short)) 1)
    (f_tutorial_end player_short blank_title)
)

(script static void (f_tutorial_rotate_weapons (short player_short, cutscene_title display_title, cutscene_title blank_title))
    (f_tutorial_begin player_short display_title)
    (sleep_until (unit_action_test_rotate_weapons (player_get player_short)) 1)
    (f_tutorial_end player_short blank_title)
)

(script static void (f_hud_obj_new (cutscene_title title))
    (cinematic_set_chud_objective title)
)

(script static void (f_hud_flash_object (object_name hud_object_highlight))
    (set chud_debug_highlight_object_color_red 1)
    (set chud_debug_highlight_object_color_green 1)
    (set chud_debug_highlight_object_color_blue 0)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
)

(script static void (f_hud_flash_single (object_name hud_object_highlight))
    (object_create hud_object_highlight)
    (set chud_debug_highlight_object hud_object_highlight)
    (sleep 4)
    (object_destroy hud_object_highlight)
    (sleep 5)
)

(script static void (f_blip_internal (object obj, short icon_disappear_time, short final_delay))
    (chud_track_object obj true)
    (sound_impulse_start sfx_blip none 1)
    (sleep icon_disappear_time)
    (chud_track_object obj false)
    (sleep final_delay)
)

(script static void (f_blip_flag_internal (cutscene_flag f, short icon_disappear_time, short final_delay))
    (chud_track_flag f true)
    (sound_impulse_start sfx_blip none 1)
    (sleep icon_disappear_time)
    (chud_track_flag f false)
    (sleep final_delay)
)

(script static void (f_blip_flag (cutscene_flag f, short type))
    (chud_track_flag_with_priority f type)
)

(script static void (f_blip_flag_forever (cutscene_flag f))
    (print "f_blip_flag_forever is going away. please use f_blip_flag")
    (f_blip_flag f blip_neutralize)
)

(script static void (f_unblip_flag (cutscene_flag f))
    (chud_track_flag f false)
)

(script static void (f_blip_object (object obj, short type))
    (chud_track_object_with_priority obj type)
)

(script static void (f_blip_object_forever (object obj))
    (print "f_blip_object_forever is going away. please use f_blip_object")
    (chud_track_object obj true)
)

(script static void (f_unblip_object (object obj))
    (chud_track_object obj false)
)

(script static void (f_blip_object_until_dead (object obj))
    (chud_track_object obj true)
    (sleep_until (<= (object_get_health obj) 0))
    (chud_track_object obj false)
)

(script static void (f_blip_ai (ai group, short blip_type))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set s_blip_list_index 0)
    (set l_blip_list (ai_actors group))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_blip_object (list_get l_blip_list s_blip_list_index) blip_type)
            )
            (set s_blip_list_index (+ s_blip_list_index 1))
            (>= s_blip_list_index (list_count l_blip_list))
        )
        1
    )
    (set b_blip_list_locked false)
)

(script static void (f_blip_ai_forever (ai group))
    (print "f_blip_ai_forever is going away. please use f_blip_ai")
    (f_blip_ai group 0)
)

(script static void (f_blip_ai_until_dead (ai char))
    (print "f_blip_ai_until_dead will be rolled into the new f_blip_ai command. consider using that instead.")
    (f_blip_ai_forever char)
    (sleep_until (<= (object_get_health (ai_get_object char)) 0))
    (f_unblip_ai char)
)

(script static void (f_unblip_ai (ai group))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set s_blip_list_index 0)
    (set l_blip_list (ai_actors group))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_unblip_object (list_get l_blip_list s_blip_list_index))
            )
            (set s_blip_list_index (+ s_blip_list_index 1))
            (>= s_blip_list_index (list_count l_blip_list))
        )
        1
    )
    (set b_blip_list_locked false)
)

(script static void (f_callout_object (object obj, short type))
    (f_callout_atom obj type 10 2)
    (f_callout_atom obj type 10 2)
    (f_callout_atom obj type 10 2)
    (f_callout_atom obj type 100 2)
)

(script static void (f_callout_ai (ai actors, short type))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set l_blip_list (ai_actors actors))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_callout_object (list_get l_blip_list s_blip_list_index) type)
            )
            (set s_blip_list_index (+ s_blip_list_index 1))
            (>= s_blip_list_index (list_count l_blip_list))
        )
        1
    )
    (set s_blip_list_index 0)
    (set b_blip_list_locked false)
)

(script static void (f_callout_atom (object obj, short type, short time, short postdelay))
    (chud_track_object_with_priority obj type)
    (sound_impulse_start sfx_blip none 1)
    (sleep time)
    (chud_track_object obj false)
    (sleep postdelay)
)

(script static void (f_md_ai_play (short delay, ai character, ai_line line))
    (set b_is_dialogue_playing true)
    (set s_md_play_time (ai_play_line character line))
    (sleep s_md_play_time)
    (sleep delay)
    (set b_is_dialogue_playing false)
)

(script static void (f_md_object_play (short delay, object obj, ai_line line))
    (set b_is_dialogue_playing true)
    (set s_md_play_time (ai_play_line_on_object obj line))
    (sleep s_md_play_time)
    (sleep delay)
    (set b_is_dialogue_playing false)
)

(script static void (f_md_ai_play_cutoff (short cutoff_time, ai character, ai_line line))
    (set b_is_dialogue_playing true)
    (set s_md_play_time (- (ai_play_line character line) cutoff_time))
    (sleep s_md_play_time)
    (set b_is_dialogue_playing false)
)

(script static void (f_md_object_play_cutoff (short cutoff_time, object obj, ai_line line))
    (set b_is_dialogue_playing true)
    (set s_md_play_time (- (ai_play_line_on_object obj line) cutoff_time))
    (sleep s_md_play_time)
    (set b_is_dialogue_playing false)
)

(script static void f_md_abort
    (sleep s_md_play_time)
    (print "dialog script aborted!")
    (set b_is_dialogue_playing false)
)

(script static void (f_md_play (short delay, sound line))
    (set b_is_dialogue_playing true)
    (set s_md_play_time (sound_impulse_language_time line))
    (sound_impulse_start line none 1)
    (sleep (sound_impulse_language_time line))
    (sleep delay)
    (set s_md_play_time 0)
    (set b_is_dialogue_playing false)
)

(script static boolean f_is_dialogue_playing
    b_is_dialogue_playing
)

(script static boolean (f_ai_has_spawned (ai actors))
    (> (ai_spawn_count actors) 0)
)

(script static boolean (f_ai_is_defeated (ai actors))
    (and (> (ai_spawn_count actors) 0) (<= (ai_living_count actors) 0))
)

(script static boolean (f_ai_is_partially_defeated (ai actors, short count))
    (and (>= (ai_spawn_count actors) count) (<= (ai_living_count actors) count))
)

(script static boolean (f_task_is_empty (ai task))
    (<= (ai_task_count task) 0)
)

(script static boolean (f_task_has_actors (ai task))
    (> (ai_task_count task) 0)
)

(script static ai (f_object_get_squad (object ai_obj))
    (ai_get_squad (object_get_ai ai_obj))
)

(script static void debug_toggle_cookie_cutters
    (if (= debug_instanced_geometry false)
        (begin
            (set debug_objects_collision_models false)
            (set debug_objects_physics_models false)
            (set debug_objects_bounding_spheres false)
            (set debug_objects_cookie_cutters true)
            (set debug_objects true)
            (set debug_instanced_geometry_collision_geometry false)
            (set debug_instanced_geometry_cookie_cutters true)
            (set debug_instanced_geometry true)
        )
        (begin
            (set debug_objects_cookie_cutters false)
            (set debug_objects false)
            (set debug_instanced_geometry_cookie_cutters false)
            (set debug_instanced_geometry false)
        )
    )
)

(script static void debug_toggle_pathfinding_collisions
    (if (= collision_debug false)
        (begin
            (set collision_debug true)
            (set collision_debug_flag_ignore_invisible_surfaces false)
        )
        (begin
            (set collision_debug false)
            (set collision_debug_flag_ignore_invisible_surfaces true)
        )
    )
)

(script startup void swordslayer_main
    (vehicle_auto_turret "#_security_camera_interior_01" "trigger_camera01" 3 3 3)
    (vehicle_auto_turret "#_security_camera_interior_02" "trigger_camera02" 3 3 3)
    (vehicle_auto_turret "#_security_camera_interior_03" "trigger_camera03" 3 3 3)
    (vehicle_auto_turret "#_security_camera_interior_04" "trigger_camera04" 3 3 3)
)

(script continuous void swordslayer_all
    (add_recycling_volume "garbage_collection" 10 50)
    (sleep 300)
)

; Decompilation finished in ~0.0180173s
