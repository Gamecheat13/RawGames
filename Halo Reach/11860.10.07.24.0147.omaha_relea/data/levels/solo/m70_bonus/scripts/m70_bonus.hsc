; Decompiled with Assembly
; 
; Source file: m70_bonus.hsc
; Start time: 2018-02-05 12:56:32 PM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global boolean b_debug_phantom false)
(global boolean b_debug_globals false)
(global short player_00 0)
(global short player_01 1)
(global short player_02 2)
(global short player_03 3)
(global short s_md_play_time 0)
(global string data_mine_mission_segment "")
(global boolean b_debug_cinematic_scripts true)
(global boolean b_cinematic_entered false)
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
(global short blip_structure 6)
(global short blip_neutralize_alpha 7)
(global short blip_neutralize_bravo 8)
(global short blip_neutralize_charlie 9)
(global short blip_ammo 13)
(global short blip_hostile_vehicle 14)
(global short blip_hostile 15)
(global short blip_default_a 17)
(global short blip_default_b 18)
(global short blip_default_c 19)
(global short blip_default_d 20)
(global short blip_default 21)
(global short blip_destination 21)
(global boolean b_is_dialogue_playing false)
(global boolean b_debug true)
(global boolean b_breakpoints false)
(global boolean b_md_print true)
(global boolean debug_objectives false)
(global boolean editor (editor_mode))
(global boolean cinematics true)
(global boolean editor_cinematics false)
(global boolean game_emulate false)
(global boolean dialogue false)
(global boolean skip_intro false)
(global short objcon_hill 65535)
(global boolean b_hill_ready false)
(global short g_insertion_index 0)
(global short s_insert_idx_transition 1)
(global short s_insert_idx_hill 2)
(global short s_insert_idx_credits 3)
(global short s_set_hill 0)
(global short s_set_cin_outro 1)
(global short s_set_all 2)
(global short fireteam_max 4)
(global real fireteam_dist 3)
(global boolean g_mission_complete false)
(global short s_wave_spawning 0)
(global short s_waypoint_timer 10)
(global short s_zoneset_last_refreshed 65535)
(global short s_escalation 0)
(global boolean b_bob false)
(global boolean b_wraith false)
(global short s_fade_time 30)
(global short s_crack 0)
(global boolean b_hill_last_crack false)
(global real r_damage_messages 0.4)
(global real r_damage_weapons 0.8)
(global real r_damage_grenades 0.8)
(global real r_damage_crack_1 0.9)
(global real r_damage_motion 1.2)
(global real r_damage_shield 1.4)
(global real r_damage_crack_2 1.6)
(global real r_damage_crosshair 2.4)
(global boolean b_last_player_dead false)
(global short s_players_alive 1)
(global real r_health_min 0.1)
(global boolean b_crack_p0 false)
(global boolean b_crack_p1 false)
(global boolean b_crack_p2 false)
(global boolean b_crack_p3 false)
(global boolean b_debug_scripting true)
(global real r_p0_damage_tracker 0)
(global real r_p0_shield_last 1)
(global real r_p0_health_last 1)
(global real r_p1_damage_tracker 0)
(global real r_p1_shield_last 1)
(global real r_p1_health_last 1)
(global real r_p2_damage_tracker 0)
(global real r_p2_shield_last 1)
(global real r_p2_health_last 1)
(global real r_p3_damage_tracker 0)
(global real r_p3_shield_last 1)
(global real r_p3_health_last 1)
(global boolean b_sq_hill_phantom_init_spawn false)
(global ai ai_phantom_0_1 none)
(global ai ai_phantom_0_2 none)
(global ai ai_phantom_0_3 none)
(global ai ai_phantom_0_4 none)
(global ai ai_phantom_0_5 none)
(global ai ai_phantom_0_v1 none)
(global ai ai_phantom_0_v2 none)
(global boolean b_sq_hill_phantom_0_spawn false)
(global ai ai_phantom_1_1 none)
(global ai ai_phantom_1_2 none)
(global ai ai_phantom_1_3 none)
(global ai ai_phantom_1_4 none)
(global ai ai_phantom_1_5 none)
(global ai ai_phantom_1_v1 none)
(global ai ai_phantom_1_v2 none)
(global boolean b_sq_hill_phantom_1_spawn false)
(global ai ai_phantom_2_1 none)
(global ai ai_phantom_2_2 none)
(global ai ai_phantom_2_3 none)
(global ai ai_phantom_2_4 none)
(global ai ai_phantom_2_5 none)
(global ai ai_phantom_2_v1 none)
(global ai ai_phantom_2_v2 none)
(global boolean b_sq_hill_phantom_2_spawn false)
(global ai ai_phantom_3_1 none)
(global ai ai_phantom_3_2 none)
(global ai ai_phantom_3_3 none)
(global ai ai_phantom_3_4 none)
(global ai ai_phantom_3_5 none)
(global ai ai_phantom_3_v1 none)
(global ai ai_phantom_3_v2 none)
(global boolean b_sq_hill_phantom_3_spawn false)
(global ai ai_phantom_4_1 none)
(global ai ai_phantom_4_2 none)
(global ai ai_phantom_4_3 none)
(global ai ai_phantom_4_4 none)
(global ai ai_phantom_4_5 none)
(global ai ai_phantom_4_v1 none)
(global ai ai_phantom_4_v2 none)
(global boolean b_sq_hill_phantom_4_spawn false)
(global short pose_against_wall_var1 0)
(global short pose_against_wall_var2 1)
(global short pose_against_wall_var3 2)
(global short pose_against_wall_var4 3)
(global short pose_on_back_var1 4)
(global short pose_on_back_var2 5)
(global short pose_on_side_var1 6)
(global short pose_on_side_var2 7)
(global short pose_on_back_var3 8)
(global short pose_face_down_var1 9)
(global short pose_face_down_var2 10)
(global short pose_on_side_var3 11)
(global short pose_on_side_var4 12)
(global short pose_face_down_var3 13)
(global short pose_on_side_var5 14)
(global short s_music_hill 65535)
(global short s_rain_force 65535)
(global short s_rain_force_last 65535)
(global boolean b_tit_hill_done false)
(global boolean g_dialog false)

; Scripts
(script static void f_hud_obj_complete
    (objectives_clear)
    (chud_show_screen_objective "campaign_hud_objcomplete")
    (sleep 160)
    (chud_show_screen_objective "")
)

(script static void (f_load_phantom (vehicle phantom, string load_side, ai load_squad_01, ai load_squad_02, ai load_squad_03, ai load_squad_04))
    (ai_place load_squad_01)
    (ai_place load_squad_02)
    (ai_place load_squad_03)
    (ai_place load_squad_04)
    (sleep 1)
    (if (= load_side "left")
        (begin
            (if b_debug_phantom
                (print "load phantom left...")
            )
            (ai_vehicle_enter_immediate load_squad_01 phantom 0)
            (ai_vehicle_enter_immediate load_squad_02 phantom 1)
            (ai_vehicle_enter_immediate load_squad_03 phantom 2)
            (ai_vehicle_enter_immediate load_squad_04 phantom 3)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_phantom
                    (print "load phantom right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 phantom 4)
                (ai_vehicle_enter_immediate load_squad_02 phantom 5)
                (ai_vehicle_enter_immediate load_squad_03 phantom 6)
                (ai_vehicle_enter_immediate load_squad_04 phantom 7)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_phantom
                        (print "load phantom dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 phantom 1)
                    (ai_vehicle_enter_immediate load_squad_02 phantom 5)
                    (ai_vehicle_enter_immediate load_squad_03 phantom 0)
                    (ai_vehicle_enter_immediate load_squad_04 phantom 4)
                )
                (if (= load_side "any")
                    (begin
                        (if b_debug_phantom
                            (print "load phantom any...")
                        )
                        (ai_vehicle_enter_immediate load_squad_01 phantom 8)
                        (ai_vehicle_enter_immediate load_squad_02 phantom 8)
                        (ai_vehicle_enter_immediate load_squad_03 phantom 8)
                        (ai_vehicle_enter_immediate load_squad_04 phantom 8)
                    )
                    (if (= load_side "chute")
                        (begin
                            (if b_debug_phantom
                                (print "load phantom chute...")
                            )
                            (ai_vehicle_enter_immediate load_squad_01 phantom 9)
                            (ai_vehicle_enter_immediate load_squad_02 phantom 10)
                            (ai_vehicle_enter_immediate load_squad_03 phantom 11)
                            (ai_vehicle_enter_immediate load_squad_04 phantom 12)
                        )
                    )
                )
            )
        )
    )
)

(script static void (f_load_phantom_cargo (vehicle phantom, string load_number, ai load_squad_01, ai load_squad_02))
    (if (= load_number "single")
        (begin
            (ai_place load_squad_01)
            (sleep 1)
            (vehicle_load_magic phantom 13 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_number "double")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (sleep 1)
                (vehicle_load_magic phantom 14 (ai_vehicle_get_from_squad load_squad_01 0))
                (vehicle_load_magic phantom 15 (ai_vehicle_get_from_squad load_squad_02 0))
            )
        )
    )
)

(script static void (f_unload_phantom (vehicle phantom, string drop_side))
    (if b_debug_phantom
        (print "opening phantom...")
    )
    (unit_open phantom)
    (sleep 60)
    (if (= drop_side "left")
        (begin
            (f_unload_ph_left phantom)
            (sleep 45)
            (f_unload_ph_mid_left phantom)
            (sleep 75)
        )
        (if (= drop_side "right")
            (begin
                (f_unload_ph_right phantom)
                (sleep 45)
                (f_unload_ph_mid_right phantom)
                (sleep 75)
            )
            (if (= drop_side "dual")
                (begin
                    (f_unload_ph_left phantom)
                    (f_unload_ph_right phantom)
                    (sleep 75)
                )
                (if (= drop_side "chute")
                    (begin
                        (f_unload_ph_chute phantom)
                        (sleep 75)
                    )
                )
            )
        )
    )
    (if b_debug_phantom
        (print "closing phantom...")
    )
    (unit_close phantom)
)

(script static void (f_unload_ph_left (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 1)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 0)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 5)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 4)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_left (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 2)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 3)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 6)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 7)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_chute (vehicle phantom))
    (object_set_phantom_power phantom true)
    (if (vehicle_test_seat phantom 9)
        (begin
            (vehicle_unload phantom 9)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 10)
        (begin
            (vehicle_unload phantom 10)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 11)
        (begin
            (vehicle_unload phantom 11)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 12)
        (begin
            (vehicle_unload phantom 12)
            (sleep 120)
        )
    )
    (object_set_phantom_power phantom false)
)

(script static void (f_unload_phantom_cargo (vehicle phantom, string load_number))
    (if (= load_number "single")
        (vehicle_unload phantom 13)
        (if (= load_number "double")
            (begin_random
                (begin
                    (vehicle_unload phantom 14)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload phantom 15)
                    (sleep (random_range 15 30))
                )
            )
        )
    )
)

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
    (unit_set_current_vitality player0 80 80)
    (unit_set_current_vitality player1 80 80)
    (unit_set_current_vitality player2 80 80)
    (unit_set_current_vitality player3 80 80)
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
    (or (unit_in_vehicle (unit player0)) (unit_in_vehicle (unit player1)) (unit_in_vehicle (unit player2)) (unit_in_vehicle (unit player3)))
)

(script static void (f_vehicle_scale_destroy (vehicle vehicle_variable))
    (object_set_scale vehicle_variable 0.01 (* 30 5))
    (sleep (* 30 5))
    (object_destroy vehicle_variable)
)

(script static void (f_ai_place_vehicle_deathless (ai squad))
    (ai_place squad)
    (ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) true)
    (object_cannot_die (ai_vehicle_get_from_squad squad 0) true)
)

(script static void (f_ai_place_vehicle_deathless_no_emp (ai squad))
    (ai_place squad)
    (ai_cannot_die (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0))) true)
    (object_cannot_die (ai_vehicle_get_from_squad squad 0) true)
    (object_ignores_emp (ai_vehicle_get_from_squad squad 0) true)
)

(script static short (f_vehicle_rider_number (vehicle v))
    (list_count (vehicle_riders v))
)

(script static boolean (f_all_squad_in_vehicle (ai inf_squad, ai vehicle_squad))
    (and (= (ai_living_count inf_squad) 0) (= (ai_living_count vehicle_squad) (f_vehicle_rider_number (ai_vehicle_get_from_squad vehicle_squad 0))))
)

(script static ai (f_ai_get_vehicle_driver (ai squad))
    (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad squad 0)))
)

(script static void (f_ai_magically_see_players (ai squad))
    (ai_magically_see_object squad player0)
    (ai_magically_see_object squad player1)
    (ai_magically_see_object squad player2)
    (ai_magically_see_object squad player3)
)

(script dormant void f_global_health_saves
    (sleep_until (> (player_count) 0))
    (sleep_until 
        (begin
            (sleep_until (< (object_get_health player0) 1))
            (sleep (* 30 7))
            (if (< (object_get_health player0) 1)
                (begin
                    (sleep_until (= (object_get_health player0) 1))
                    (print "global health: health pack aquired")
                    (game_save)
                )
                (print "global health: re-gen")
            )
            false
        )
    )
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

(script static void (cinematic_skip_stop (string_id cinematic_name))
    (cinematic_skip_stop_internal)
    (if (not (game_reverted))
        (begin
            (game_revert)
            (sleep 1)
        )
    )
)

(script static void (cinematic_skip_stop_load_zone (string_id cinematic_name, zone_set z))
    (cinematic_skip_stop_internal)
    (if (not (game_reverted))
        (begin
            (game_revert)
            (sleep 1)
        )
    )
    (switch_zone_set z)
    (sleep 2)
)

(script static void (cinematic_skip_stop_terminal (string_id cinematic_name))
    (cinematic_skip_stop_internal)
    (if (not (game_reverted))
        (begin
            (game_revert)
            (sleep 1)
            (if b_debug_globals
                (print "sleeping forever...")
            )
            (sleep_forever)
        )
    )
)

(script static void test_cinematic_enter_exit
    (sleep 30)
)

(script static void (cinematic_enter (string_id cinematic_name, boolean lower_weapon))
    (set b_cinematic_entered true)
    (cinematic_enter_pre lower_weapon)
    (sleep (cinematic_tag_fade_out_from_game cinematic_name))
    (cinematic_enter_post)
)

(script static void (designer_cinematic_enter (boolean lower_weapon))
    (cinematic_enter_pre lower_weapon)
    (sleep (cinematic_transition_fade_out_from_game "cinematics\transitions\default_intra.cinematic_transition"))
    (cinematic_enter_post)
)

(script static void (cinematic_enter_pre (boolean lower_weapon))
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (player_control_fade_out_all_input 1)
    (if (= lower_weapon true)
        (begin
            (if b_debug_cinematic_scripts
                (print "lowering weapon slowly...")
            )
            (unit_lower_weapon player0 30)
            (unit_lower_weapon player1 30)
            (unit_lower_weapon player2 30)
            (unit_lower_weapon player3 30)
        )
    )
    (campaign_metagame_time_pause true)
    (chud_cinematic_fade 0 0.5)
)

(script static void cinematic_enter_post
    (if b_debug_cinematic_scripts
        (print "hiding players...")
    )
    (object_hide player0 true)
    (object_hide player1 true)
    (object_hide player2 true)
    (object_hide player3 true)
    (player_enable_input false)
    (player_disable_movement true)
    (sleep 1)
    (if b_debug_cinematic_scripts
        (print "camera control on")
    )
    (camera_control true)
    (cinematic_start)
)

(script static void (cinematic_exit (string_id cinematic_name, boolean weapon_starts_lowered))
    (cinematic_exit_pre weapon_starts_lowered)
    (sleep (cinematic_tag_fade_in_to_game cinematic_name))
    (cinematic_exit_post weapon_starts_lowered)
)

(script static void (designer_cinematic_exit (boolean weapon_starts_lowered))
    (cinematic_exit_pre weapon_starts_lowered)
    (sleep (cinematic_transition_fade_in_to_game "cinematics\transitions\default_intra.cinematic_transition"))
    (cinematic_exit_post weapon_starts_lowered)
)

(script static void (cinematic_exit_into_title (string_id cinematic_name, boolean weapon_starts_lowered))
    (cinematic_exit_pre weapon_starts_lowered)
    (chud_cinematic_fade 0 0)
    (sleep (cinematic_tag_fade_in_to_game cinematic_name))
    (cinematic_exit_post_title weapon_starts_lowered)
)

(script static void (cinematic_exit_pre (boolean weapon_starts_lowered))
    (cinematic_stop)
    (camera_control false)
    (object_hide player0 false)
    (object_hide player1 false)
    (object_hide player2 false)
    (object_hide player3 false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "snapping weapon to lowered state...")
            )
            (unit_lower_weapon player0 1)
            (unit_lower_weapon player1 1)
            (unit_lower_weapon player2 1)
            (unit_lower_weapon player3 1)
            (sleep 1)
        )
        (begin
            (unit_raise_weapon player0 1)
            (unit_raise_weapon player1 1)
            (unit_raise_weapon player2 1)
            (unit_raise_weapon player3 1)
            (sleep 1)
        )
    )
    (player_control_unlock_gaze player0)
    (player_control_unlock_gaze player1)
    (player_control_unlock_gaze player2)
    (player_control_unlock_gaze player3)
    (sleep 1)
)

(script static void (cinematic_exit_post (boolean weapon_starts_lowered))
    (cinematic_show_letterbox false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "raising player weapons slowly...")
            )
            (unit_raise_weapon player0 30)
            (unit_raise_weapon player1 30)
            (unit_raise_weapon player2 30)
            (unit_raise_weapon player3 30)
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

(script static void (cinematic_exit_post_title (boolean weapon_starts_lowered))
    (cinematic_show_letterbox false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "raising player weapons slowly...")
            )
            (unit_raise_weapon player0 30)
            (unit_raise_weapon player1 30)
            (unit_raise_weapon player2 30)
            (unit_raise_weapon player3 30)
            (sleep 10)
        )
    )
    (sleep 1)
    (player_enable_input true)
    (player_control_fade_in_all_input 1)
    (campaign_metagame_time_pause false)
    (ai_disregard (players) false)
    (object_can_take_damage (players))
    (player_disable_movement false)
)

(script static void insertion_snap_to_black
    (fade_out 0 0 0 0)
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (player_control_fade_out_all_input 1)
    (unit_lower_weapon player0 0)
    (unit_lower_weapon player1 0)
    (unit_lower_weapon player2 0)
    (unit_lower_weapon player3 0)
    (campaign_metagame_time_pause true)
    (chud_cinematic_fade 0 0)
    (if b_debug_cinematic_scripts
        (print "hiding players...")
    )
    (object_hide player0 true)
    (object_hide player1 true)
    (object_hide player2 true)
    (object_hide player3 true)
    (player_enable_input false)
    (player_disable_movement true)
    (sleep 1)
    (if b_debug_cinematic_scripts
        (print "camera control on")
    )
)

(script static void insertion_fade_to_gameplay
    (designer_fade_in "fade_from_black" true)
)

(script static void (designer_fade_in (string fade_type, boolean weapon_starts_lowered))
    (cinematic_stop)
    (camera_control false)
    (object_hide player0 false)
    (object_hide player1 false)
    (object_hide player2 false)
    (object_hide player3 false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "snapping weapon to lowered state...")
            )
            (unit_lower_weapon player0 1)
            (unit_lower_weapon player1 1)
            (unit_lower_weapon player2 1)
            (unit_lower_weapon player3 1)
            (sleep 1)
        )
    )
    (player_control_unlock_gaze player0)
    (player_control_unlock_gaze player1)
    (player_control_unlock_gaze player2)
    (player_control_unlock_gaze player3)
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
    (cinematic_show_letterbox false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "raising player weapons slowly...")
            )
            (unit_raise_weapon player0 30)
            (unit_raise_weapon player1 30)
            (unit_raise_weapon player2 30)
            (unit_raise_weapon player3 30)
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
    (sleep 0)
)

(script static void cinematic_snap_to_white
    (sleep 0)
)

(script static void cinematic_snap_from_black
    (sleep 0)
)

(script static void cinematic_snap_from_white
    (sleep 0)
)

(script static void cinematic_fade_to_black
    (sleep 0)
)

(script static void cinematic_fade_to_white
    (sleep 0)
)

(script static void cinematic_fade_to_gameplay
    (designer_fade_in "fade_from_black" true)
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

(script static void (f_start_mission (string_id cinematic_name))
    (if (= b_cinematic_entered false)
        (cinematic_enter cinematic_name true)
    )
    (set b_cinematic_entered false)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_cinematic_scripts
                (print "f_start_mission: cinematic_skip_start is true... starting cinematic...")
            )
            (cinematic_show_letterbox_immediate true)
            (cinematic_run_script_by_name cinematic_name)
        )
    )
    (cinematic_skip_stop cinematic_name)
)

(script static void (f_play_cinematic_advanced (string_id cinematic_name, zone_set cinematic_zone_set, zone_set zone_to_load_when_done))
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: calling cinematic_enter")
    )
    (set b_cinematic_entered false)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_globals
                (print "f_play_cinematic: playing cinematic...")
            )
            (cinematic_show_letterbox_immediate true)
            (cinematic_run_script_by_name cinematic_name)
        )
    )
    (cinematic_skip_stop_load_zone cinematic_name zone_to_load_when_done)
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: done with cinematic. resetting audio levels...")
    )
)

(script static void (f_play_cinematic_unskippable (string_id cinematic_name, zone_set cinematic_zone_set))
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: calling cinematic_enter")
    )
    (if (= b_cinematic_entered false)
        (cinematic_enter cinematic_name false)
    )
    (set b_cinematic_entered false)
    (sleep 1)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (begin
        (if b_debug_globals
            (print "f_play_cinematic: playing cinematic...")
        )
        (cinematic_show_letterbox true)
        (sleep 30)
        (cinematic_show_letterbox_immediate true)
        (cinematic_run_script_by_name cinematic_name)
    )
)

(script static void (f_play_cinematic (string_id cinematic_name, zone_set cinematic_zone_set))
    (if b_debug_cinematic_scripts
        (print "f_play_cinematic: calling cinematic_enter")
    )
    (if (= b_cinematic_entered false)
        (cinematic_enter cinematic_name false)
    )
    (set b_cinematic_entered false)
    (sleep 1)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_globals
                (print "f_play_cinematic: playing cinematic...")
            )
            (cinematic_show_letterbox true)
            (sleep 30)
            (cinematic_show_letterbox_immediate true)
            (cinematic_run_script_by_name cinematic_name)
        )
    )
    (cinematic_skip_stop cinematic_name)
)

(script static void (f_end_mission (string_id cinematic_name, zone_set cinematic_zone_set))
    (if (= b_cinematic_entered false)
        (cinematic_enter cinematic_name false)
    )
    (set b_cinematic_entered false)
    (sleep 1)
    (ai_erase_all)
    (garbage_collect_now)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_globals
                (print "play outro cinematic...")
            )
            (cinematic_show_letterbox true)
            (sleep 30)
            (cinematic_show_letterbox_immediate true)
            (cinematic_run_script_by_name cinematic_name)
        )
    )
    (cinematic_skip_stop_internal)
    (fade_out 0 0 0 0)
    (sleep 1)
)

(script static void (f_end_mission_ai (string_id cinematic_name, zone_set cinematic_zone_set))
    (if (= b_cinematic_entered false)
        (cinematic_enter cinematic_name false)
    )
    (set b_cinematic_entered false)
    (sleep 1)
    (ai_disregard player0 true)
    (ai_disregard player1 true)
    (ai_disregard player2 true)
    (ai_disregard player3 true)
    (garbage_collect_now)
    (switch_zone_set cinematic_zone_set)
    (sleep 1)
    (if (cinematic_skip_start)
        (begin
            (if b_debug_globals
                (print "play outro cinematic...")
            )
            (cinematic_show_letterbox true)
            (sleep 30)
            (cinematic_show_letterbox_immediate true)
            (cinematic_run_script_by_name cinematic_name)
        )
    )
    (cinematic_skip_stop_internal)
    (fade_out 0 0 0 0)
    (sleep 1)
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

(script static void (f_sfx_hud_tutorial_complete (player player_to_train))
    (sound_impulse_start sfx_tutorial_complete player_to_train 1)
)

(script static void (f_display_message (short player_short, cutscene_title display_title))
    (chud_show_cinematic_title (player_get player_short) display_title)
    (sleep 5)
)

(script static void (f_tutorial_begin (player player_to_train, string_id display_title))
    (f_hud_training_forever player_to_train display_title)
    (sleep 5)
    (unit_action_test_reset player_to_train)
    (sleep 5)
)

(script static void (f_tutorial_end (player player_to_train))
    (f_sfx_hud_tutorial_complete player_to_train)
    (f_hud_training_clear player_to_train)
    (sleep 30)
)

(script static void (f_tutorial_boost (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep_until (unit_action_test_grenade_trigger player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_tutorial_rotate_weapons (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep_until (unit_action_test_rotate_weapons player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_tutorial_fire_weapon (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep_until (unit_action_test_primary_trigger player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_tutorial_turn (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep 20)
    (sleep_until (unit_action_test_look_relative_all_directions player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_tutorial_throttle (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep 20)
    (sleep_until (unit_action_test_move_relative_all_directions player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_tutorial_tricks (player player_variable, string_id display_title))
    (f_tutorial_begin player_variable display_title)
    (sleep_until (unit_action_test_vehicle_trick_secondary player_variable) 1)
    (f_tutorial_end player_variable)
)

(script static void (f_hud_training (player player_num, string_id string_hud))
    (chud_show_screen_training player_num string_hud)
    (sleep 120)
    (chud_show_screen_training player_num "")
)

(script static void (f_hud_training_forever (player player_num, string_id string_hud))
    (chud_show_screen_training player_num string_hud)
)

(script static void (f_hud_training_clear (player player_num))
    (chud_show_screen_training player_num "")
)

(script static void f_hud_training_new_weapon
    (chud_set_static_hs_variable player0 0 1)
    (chud_set_static_hs_variable player1 0 1)
    (chud_set_static_hs_variable player2 0 1)
    (chud_set_static_hs_variable player3 0 1)
    (sleep 200)
    (chud_clear_hs_variable player0 0)
    (chud_clear_hs_variable player1 0)
    (chud_clear_hs_variable player2 0)
    (chud_clear_hs_variable player3 0)
)

(script static void (f_hud_training_new_weapon_player (player p))
    (chud_set_static_hs_variable p 0 1)
    (sleep 200)
    (chud_clear_hs_variable p 0)
)

(script static void (f_hud_training_new_weapon_player_clear (player p))
    (chud_clear_hs_variable p 0)
)

(script static void (f_hud_training_confirm (player player_num, string_id string_hud, string button_press))
    (if (= (player_is_in_game player_num) false)
        (sleep_forever)
    )
    (chud_show_screen_training player_num string_hud)
    (sleep 10)
    (player_action_test_reset)
    (sleep_until (if (= button_press "primary_trigger")
        (sleep_until (unit_action_test_primary_trigger player_num))
        (if (= button_press "grenade_trigger")
            (sleep_until (unit_action_test_grenade_trigger player_num))
            (if (= button_press "equipment")
                (sleep_until (unit_action_test_equipment player_num))
                (if (= button_press "melee")
                    (sleep_until (unit_action_test_melee player_num))
                    (if (= button_press "jump")
                        (sleep_until (unit_action_test_jump player_num))
                        (if (= button_press "rotate_grenades")
                            (sleep_until (unit_action_test_rotate_grenades player_num))
                            (if (= button_press "rotate_weapons")
                                (sleep_until (unit_action_test_rotate_weapons player_num))
                                (if (= button_press "context_primary")
                                    (sleep_until (unit_action_test_context_primary player_num))
                                    (if (= button_press "vision_trigger")
                                        (sleep_until (or (unit_action_test_vision_trigger player_num) (player_night_vision_on)))
                                        (if (= button_press "back")
                                            (sleep_until (unit_action_test_back player_num))
                                            (if (= button_press "vehicle_trick")
                                                (sleep_until (unit_action_test_vehicle_trick_primary player_num))
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    ) 1 (* 30 10))
    (chud_show_screen_training player_num "")
)

(script static void (f_hud_obj_new (string_id string_hud, string_id string_start))
    (f_hud_start_menu_obj string_start)
    (chud_show_screen_objective string_hud)
    (sleep 160)
    (chud_show_screen_objective "")
)

(script static void (f_hud_obj_repeat (string_id string_hud))
    (chud_show_screen_objective string_hud)
    (sleep 160)
    (chud_show_screen_objective "")
)

(script static void (f_hud_start_menu_obj (string_id reference))
    (objectives_clear)
    (objectives_set_string 0 reference)
    (objectives_show_string reference)
)

(script static void (f_hud_chapter (string_id string_hud))
    (chud_cinematic_fade 0 30)
    (sleep 10)
    (chud_show_screen_chapter_title string_hud)
    (chud_fade_chapter_title_for_player player0 1 30)
    (chud_fade_chapter_title_for_player player1 1 30)
    (chud_fade_chapter_title_for_player player2 1 30)
    (chud_fade_chapter_title_for_player player3 1 30)
    (sleep 120)
    (chud_fade_chapter_title_for_player player0 0 30)
    (chud_fade_chapter_title_for_player player1 0 30)
    (chud_fade_chapter_title_for_player player2 0 30)
    (chud_fade_chapter_title_for_player player3 0 30)
    (chud_show_screen_chapter_title "")
    (sleep 10)
    (chud_cinematic_fade 1 30)
)

(script static void (f_hud_flash_object_fov (object_name hud_object_highlight))
    (sleep_until (or (objects_can_see_object player0 hud_object_highlight 25) (objects_can_see_object player1 hud_object_highlight 25) (objects_can_see_object player2 hud_object_highlight 25) (objects_can_see_object player3 hud_object_highlight 25)) 1)
    (object_create hud_object_highlight)
    (set chud_debug_highlight_object_color_red 1)
    (set chud_debug_highlight_object_color_green 1)
    (set chud_debug_highlight_object_color_blue 0)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
    (object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_object (object_name hud_object_highlight))
    (object_create hud_object_highlight)
    (set chud_debug_highlight_object_color_red 1)
    (set chud_debug_highlight_object_color_green 1)
    (set chud_debug_highlight_object_color_blue 0)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
    (f_hud_flash_single hud_object_highlight)
    (object_destroy hud_object_highlight)
)

(script static void (f_hud_flash_single (object_name hud_object_highlight))
    (object_hide hud_object_highlight false)
    (set chud_debug_highlight_object hud_object_highlight)
    (sleep 4)
    (object_hide hud_object_highlight true)
    (sleep 5)
)

(script static void (f_hud_flash_single_nodestroy (object_name hud_object_highlight))
    (set chud_debug_highlight_object hud_object_highlight)
    (sleep 4)
    (set chud_debug_highlight_object none)
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

(script static void (f_blip_object_offset (object obj, short type, short offset))
    (chud_track_object_with_priority obj type)
    (chud_track_object_set_vertical_offset obj offset)
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

(script static void (f_blip_ai_offset (ai group, short blip_type, short offset))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set s_blip_list_index 0)
    (set l_blip_list (ai_actors group))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_blip_object_offset (list_get l_blip_list s_blip_list_index) blip_type offset)
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

(script static void (f_blip_title (object obj, string_id title))
    (chud_track_object_with_priority obj 6 title)
    (sleep 120)
    (chud_track_object obj false)
)

(script static void (f_blip_weapon (object gun, short dist, short dist2))
    (sleep_until (or (and (<= (objects_distance_to_object player0 gun) dist) (>= (objects_distance_to_object player0 gun) 0.1)) (and (<= (objects_distance_to_object player1 gun) dist) (>= (objects_distance_to_object player1 gun) 0.1)) (and (<= (objects_distance_to_object player2 gun) dist) (>= (objects_distance_to_object player2 gun) 0.1)) (and (<= (objects_distance_to_object player3 gun) dist) (>= (objects_distance_to_object player3 gun) 0.1))) 1)
    (print "blip on")
    (f_blip_object gun blip_ordnance)
    (sleep_until (or (not (object_get_at_rest gun)) (and (>= (objects_distance_to_object player0 gun) dist2) (>= (objects_distance_to_object player0 gun) dist2) (>= (objects_distance_to_object player0 gun) dist2) (>= (objects_distance_to_object player0 gun) dist2))) 1)
    (print "blip off")
    (f_unblip_object gun)
)

(script static void (f_hud_spartan_waypoint (ai spartan, string_id spartan_hud, short max_dist))
    (sleep_until 
        (begin
            (if (< (objects_distance_to_object (ai_get_object spartan) player0) 0.95)
                (begin
                    (chud_track_object spartan false)
                    (sleep 60)
                )
                (if (> (objects_distance_to_object (ai_get_object spartan) player0) max_dist)
                    (begin
                        (chud_track_object spartan false)
                        (sleep 60)
                    )
                    (if (< (objects_distance_to_object (ai_get_object spartan) player0) 3)
                        (begin
                            (chud_track_object_with_priority spartan 22 spartan_hud)
                            (sleep 60)
                        )
                        (if (objects_can_see_object player0 (ai_get_object spartan) 10)
                            (begin
                                (chud_track_object_with_priority spartan 22 spartan_hud)
                                (sleep 60)
                            )
                            (if true
                                (begin
                                    (chud_track_object_with_priority spartan 5 "")
                                )
                            )
                        )
                    )
                )
            )
            false
        )
        30
    )
)

(script static void (f_callout_atom (object obj, short type, short time, short postdelay))
    (chud_track_object_with_priority obj type)
    (sound_impulse_start sfx_blip none 1)
    (sleep time)
    (chud_track_object obj false)
    (sleep postdelay)
)

(script static void (f_callout_flag_atom (cutscene_flag f, short type, short time, short postdelay))
    (chud_track_flag_with_priority f type)
    (sound_impulse_start sfx_blip none 1)
    (sleep time)
    (chud_track_flag f false)
    (sleep postdelay)
)

(script static void (f_callout_object (object obj, short type))
    (f_callout_atom obj type 120 2)
)

(script static void (f_callout_object_fast (object obj, short type))
    (f_callout_atom obj type 20 5)
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

(script static void (f_callout_ai_fast (ai actors, short type))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set l_blip_list (ai_actors actors))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_callout_object_fast (list_get l_blip_list s_blip_list_index) type)
            )
            (set s_blip_list_index (+ s_blip_list_index 1))
            (>= s_blip_list_index (list_count l_blip_list))
        )
        1
    )
    (set s_blip_list_index 0)
    (set b_blip_list_locked false)
)

(script static void (f_callout_and_hold_flag (cutscene_flag f, short type))
    (chud_track_flag_with_priority f type)
    (sound_impulse_start sfx_blip none 1)
    (sleep 10)
)

(script static void (f_md_ai_play (short delay, ai character, ai_line line))
    (set b_is_dialogue_playing true)
    (if (>= (ai_living_count character) 1)
        (begin
            (set s_md_play_time (ai_play_line character line))
            (sleep s_md_play_time)
            (sleep delay)
        )
        (print "this actor does not exist to play f_md_ai_play")
    )
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
    (ai_dialogue_enable true)
)

(script static void f_md_abort_no_combat_dialog
    (f_md_abort)
    (sleep 1)
    (ai_dialogue_enable false)
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

(script static void f_branch_empty01
    (print "branch exit")
)

(script static void f_branch_empty02
    (print "branch exit")
)

(script static void f_branch_empty03
    (print "branch exit")
)

(script command_script void cs_abort
    (sleep 1)
)

(script startup void sundance
    (print_difficulty)
    (dprint "::: m80 - sundance :::")
    (set breakpoints_enabled false)
    (ai_allegiance human player)
    (ai_allegiance player human)
    (set breakpoints_enabled false)
    (wake f_weather_control)
    (wake f_objects_manage)
    (if (or (and (not editor) (> (player_count) 0)) game_emulate)
        (begin
            (start)
        )
        (begin
            (dprint ":::  editor mode  :::")
        )
    )
    (sleep_until (or (>= g_insertion_index s_insert_idx_transition) false) 1)
    (if (<= g_insertion_index s_insert_idx_hill)
        (wake f_hill_objective_control)
    )
)

(script dormant void f_weather_control
    (sleep_until (>= objcon_hill 1))
    (set s_rain_force 2)
    (wake f_rain)
)

(script dormant void f_objects_manage
    (sleep_until 
        (begin
            (if (and (= (current_zone_set_fully_active) s_set_hill) (not (= s_zoneset_last_refreshed s_set_hill)))
                (f_objects_hill_create)
                (set s_zoneset_last_refreshed s_set_hill)
                (if (and (= (current_zone_set_fully_active) s_set_cin_outro) (not (= s_zoneset_last_refreshed s_set_cin_outro)))
                    (f_objects_hill_destroy)
                    (set s_zoneset_last_refreshed s_set_cin_outro)
                )
            )
            false
        )
        3
    )
)

(script static void f_objects_hill_create
    (dprint "creating hill objects")
    (object_create_folder "wp_hill")
    (object_create_folder "sc_hill")
    (if (difficulty_is_legendary)
        (object_create "dt_term_1")
        (object_destroy "dt_term_1")
    )
    (pose_body "sc_hill_marine_04" pose_on_back_var3)
    (pose_body "sc_hill_marine_05" pose_on_side_var1)
    (pose_body "sc_hill_marine_06" pose_face_down_var3)
    (pose_body "sc_hill_marine_08" pose_face_down_var3)
    (pose_body "sc_hill_marine_09" pose_on_side_var4)
    (pose_body "sc_hill_marine_10" pose_on_back_var3)
    (pose_body "sc_hill_marine_11" pose_against_wall_var3)
    (pose_body "sc_hill_marine_13" pose_on_back_var2)
    (pose_body "sc_hill_marine_14" pose_on_side_var2)
    (pose_body "sc_hill_marine_15" pose_face_down_var1)
)

(script static void f_objects_hill_destroy
    (dprint "destroying hill objects")
    (object_destroy_folder "wp_hill")
    (object_destroy_folder "sc_hill")
)

(script static void start
    (if (= (game_insertion_point_get) 0)
        (ins_transition)
        (if (= (game_insertion_point_get) 1)
            (ins_hill)
            (if (= (game_insertion_point_get) 2)
                (ins_credits)
            )
        )
    )
)

(script dormant void sc_spawn_start
    (wake sc_spawn_bottom)
    (sleep 1)
    (wake sc_spawn_left)
    (sleep 1)
    (wake sc_spawn_right)
    (sleep 1)
    (wake sc_spawn_top)
    (sleep 1)
    (wake sc_escalation)
    (wake sc_wraith_top)
    (wake sc_wraith_bottom)
    (wake sc_wraith_right)
    (wake sc_wraith_left)
    (sleep 1)
    (wake sc_fork_bottom)
    (wake sc_fork_right)
    (wake sc_fork_left)
    (wake sc_fork_top)
)

(script dormant void sc_escalation
    (sleep_until (>= (ai_body_count "obj_sundance/main_gate") 8) 1 3600)
    (set s_escalation 1)
    (print "escalation set to 1")
    (sleep_until (>= (ai_body_count "obj_sundance/main_gate") 16) 1 3600)
    (set s_escalation 2)
    (set b_wraith true)
    (print "escalation set to 2")
    (sleep_until (>= (ai_body_count "obj_sundance/main_gate") 24) 1 3600)
    (set s_escalation 3)
    (print "escalation set to 3")
    (sleep_until (>= (ai_body_count "obj_sundance/main_gate") 32) 1 3600)
    (set s_escalation 4)
    (print "escalation set to 4")
)

(script dormant void sc_spawn_bottom
    (sleep_until 
        (begin
            (sleep_until (<= (+ (ai_living_count "sq_bot_01") (ai_living_count "sq_bot_02")) 3) 1)
            (print "spawn bottom 01")
            (sv_bottom01)
            (sleep 30)
            (sleep_until (<= (+ (ai_living_count "sq_bot_01") (ai_living_count "sq_bot_02")) 3) 1)
            (print "spawn bottom 02")
            (sv_bottom02)
            (sleep 30)
            false
        )
        1
    )
)

(script dormant void sc_spawn_left
    (sleep_until 
        (begin
            (sleep_until (<= (+ (ai_living_count "sq_left_01") (ai_living_count "sq_left_02")) 3) 1)
            (print "spawn left 01")
            (sv_left01)
            (sleep 30)
            (sleep_until (<= (+ (ai_living_count "sq_left_01") (ai_living_count "sq_left_02")) 3) 1)
            (print "spawn left 02")
            (sv_left02)
            (sleep 30)
            false
        )
        1
    )
)

(script dormant void sc_spawn_right
    (sleep_until 
        (begin
            (sleep_until (<= (+ (ai_living_count "sq_right_01") (ai_living_count "sq_right_02")) 3) 1)
            (print "spawn right 01")
            (sv_right01)
            (sleep 30)
            (sleep_until (<= (+ (ai_living_count "sq_right_01") (ai_living_count "sq_right_02")) 3) 1)
            (print "spawn right 02")
            (sv_right02)
            (sleep 30)
            false
        )
        1
    )
)

(script dormant void sc_spawn_top
    (sleep_until 
        (begin
            (sleep_until (<= (+ (ai_living_count "sq_top_01") (ai_living_count "sq_top_02")) 3) 1)
            (print "spawn top 01")
            (sv_top01)
            (sleep 30)
            (sleep_until (<= (+ (ai_living_count "sq_top_01") (ai_living_count "sq_top_02")) 3) 1)
            (print "spawn top 02")
            (sv_top02)
            (sleep 30)
            false
        )
        1
    )
)

(script static void sv_bottom01
    (if (= s_escalation 0)
        (begin
            (print "squad bottom01 esc0 01")
            (ai_place "sq_bot_01/esc0_01")
            (ai_place "sq_bot_01/esc0_02")
            (ai_place "sq_bot_01/esc0_03")
            (ai_place "sq_bot_01/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad bottom01 esc1 01")
            (ai_place "sq_bot_01/esc1_01")
            (ai_place "sq_bot_01/esc1_02")
            (ai_place "sq_bot_01/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad bottom01 esc2 01")
            (ai_place "sq_bot_01/esc2_01")
            (ai_place "sq_bot_01/esc2_02")
            (ai_place "sq_bot_01/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad bottom01 esc3 01")
            (ai_place "sq_bot_01/esc3_01")
            (ai_place "sq_bot_01/esc3_02")
            (ai_place "sq_bot_01/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad bottom01 esc4 01")
            (ai_place "sq_bot_01/esc4_01")
            (ai_place "sq_bot_01/esc4_02")
            (if (= b_bob false)
                (begin
                    (print "bob!!!!")
                    (ai_place "sq_bot_01/esc4_03_bob")
                    (set b_bob true)
                )
                (ai_place "sq_bot_01/esc4_03")
            )
        )
    )
)

(script static void sv_bottom02
    (if (= s_escalation 0)
        (begin
            (print "squad bottom02 esc0 01")
            (ai_place "sq_bot_02/esc0_01")
            (ai_place "sq_bot_02/esc0_02")
            (ai_place "sq_bot_02/esc0_03")
            (ai_place "sq_bot_02/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad bottom02 esc1 01")
            (ai_place "sq_bot_02/esc1_01")
            (ai_place "sq_bot_02/esc1_02")
            (ai_place "sq_bot_02/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad bottom02 esc2 01")
            (ai_place "sq_bot_02/esc2_01")
            (ai_place "sq_bot_02/esc2_02")
            (ai_place "sq_bot_02/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad bottom02 esc3 01")
            (ai_place "sq_bot_02/esc3_01")
            (ai_place "sq_bot_02/esc3_02")
            (ai_place "sq_bot_02/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad bottom02 esc4 01")
            (ai_place "sq_bot_02/esc4_01")
            (ai_place "sq_bot_02/esc4_02")
            (ai_place "sq_bot_02/esc4_03")
        )
    )
)

(script static void sv_top01
    (if (= s_escalation 0)
        (begin
            (print "squad top01 esc0 01")
            (ai_place "sq_top_01/esc0_01")
            (ai_place "sq_top_01/esc0_02")
            (ai_place "sq_top_01/esc0_03")
            (ai_place "sq_top_01/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad top01 esc1 01")
            (ai_place "sq_top_01/esc1_01")
            (ai_place "sq_top_01/esc1_02")
            (ai_place "sq_top_01/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad top01 esc2 01")
            (ai_place "sq_top_01/esc2_01")
            (ai_place "sq_top_01/esc2_02")
            (ai_place "sq_top_01/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad top01 esc3 01")
            (ai_place "sq_top_01/esc3_01")
            (ai_place "sq_top_01/esc3_02")
            (ai_place "sq_top_01/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad top01 esc4 01")
            (ai_place "sq_top_01/esc4_01")
            (ai_place "sq_top_01/esc4_02")
            (ai_place "sq_top_01/esc4_03")
        )
    )
)

(script static void sv_top02
    (if (= s_escalation 0)
        (begin
            (print "squad top02 esc0 01")
            (ai_place "sq_top_02/esc0_01")
            (ai_place "sq_top_02/esc0_02")
            (ai_place "sq_top_02/esc0_03")
            (ai_place "sq_top_02/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad top02 esc1 01")
            (ai_place "sq_top_02/esc1_01")
            (ai_place "sq_top_02/esc1_02")
            (ai_place "sq_top_02/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad top02 esc2 01")
            (ai_place "sq_top_02/esc2_01")
            (ai_place "sq_top_02/esc2_02")
            (ai_place "sq_top_02/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad top02 esc3 01")
            (ai_place "sq_top_02/esc3_01")
            (ai_place "sq_top_02/esc3_02")
            (ai_place "sq_top_02/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad top02 esc4 01")
            (ai_place "sq_top_02/esc4_01")
            (ai_place "sq_top_02/esc4_02")
            (ai_place "sq_top_02/esc4_03")
        )
    )
)

(script static void sv_left01
    (if (= s_escalation 0)
        (begin
            (print "squad left01 esc0 01")
            (ai_place "sq_left_01/esc0_01")
            (ai_place "sq_left_01/esc0_02")
            (ai_place "sq_left_01/esc0_03")
            (ai_place "sq_left_01/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad left01 esc1 01")
            (ai_place "sq_left_01/esc1_01")
            (ai_place "sq_left_01/esc1_02")
            (ai_place "sq_left_01/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad left01 esc2 01")
            (ai_place "sq_left_01/esc2_01")
            (ai_place "sq_left_01/esc2_02")
            (ai_place "sq_left_01/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad left01 esc3 01")
            (ai_place "sq_left_01/esc3_01")
            (ai_place "sq_left_01/esc3_02")
            (ai_place "sq_left_01/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad left01 esc4 01")
            (ai_place "sq_left_01/esc4_01")
            (ai_place "sq_left_01/esc4_02")
            (ai_place "sq_left_01/esc4_03")
        )
    )
)

(script static void sv_left02
    (if (= s_escalation 0)
        (begin
            (print "squad left02 esc0 01")
            (ai_place "sq_left_02/esc0_01")
            (ai_place "sq_left_02/esc0_02")
            (ai_place "sq_left_02/esc0_03")
            (ai_place "sq_left_02/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad left02 esc1 01")
            (ai_place "sq_left_02/esc1_01")
            (ai_place "sq_left_02/esc1_02")
            (ai_place "sq_left_02/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad left02 esc2 01")
            (ai_place "sq_left_02/esc2_01")
            (ai_place "sq_left_02/esc2_02")
            (ai_place "sq_left_02/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad left02 esc3 01")
            (ai_place "sq_left_02/esc3_01")
            (ai_place "sq_left_02/esc3_02")
            (ai_place "sq_left_02/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad left02 esc4 01")
            (ai_place "sq_left_02/esc4_01")
            (ai_place "sq_left_02/esc4_02")
            (ai_place "sq_left_02/esc4_03")
        )
    )
)

(script static void sv_right01
    (if (= s_escalation 0)
        (begin
            (print "squad right01 esc0 01")
            (ai_place "sq_right_01/esc0_01")
            (ai_place "sq_right_01/esc0_02")
            (ai_place "sq_right_01/esc0_03")
            (ai_place "sq_right_01/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad right01 esc1 01")
            (ai_place "sq_right_01/esc1_01")
            (ai_place "sq_right_01/esc1_02")
            (ai_place "sq_right_01/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad right01 esc2 01")
            (ai_place "sq_right_01/esc2_01")
            (ai_place "sq_right_01/esc2_02")
            (ai_place "sq_right_01/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad right01 esc3 01")
            (ai_place "sq_right_01/esc3_01")
            (ai_place "sq_right_01/esc3_02")
            (ai_place "sq_right_01/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad right01 esc4 01")
            (ai_place "sq_right_01/esc4_01")
            (ai_place "sq_right_01/esc4_02")
            (ai_place "sq_right_01/esc4_03")
        )
    )
)

(script static void sv_right02
    (if (= s_escalation 0)
        (begin
            (print "squad right02 esc0 01")
            (ai_place "sq_right_02/esc0_01")
            (ai_place "sq_right_02/esc0_02")
            (ai_place "sq_right_02/esc0_03")
            (ai_place "sq_right_02/esc0_04")
        )
    )
    (if (= s_escalation 1)
        (begin
            (print "squad right02 esc1 01")
            (ai_place "sq_right_02/esc1_01")
            (ai_place "sq_right_02/esc1_02")
            (ai_place "sq_right_02/esc1_03")
        )
    )
    (if (= s_escalation 2)
        (begin
            (print "squad right02 esc2 01")
            (ai_place "sq_right_02/esc2_01")
            (ai_place "sq_right_02/esc2_02")
            (ai_place "sq_right_02/esc2_03")
        )
    )
    (if (= s_escalation 3)
        (begin
            (print "squad right02 esc3 01")
            (ai_place "sq_right_02/esc3_01")
            (ai_place "sq_right_02/esc3_02")
            (ai_place "sq_right_02/esc3_03")
        )
    )
    (if (= s_escalation 4)
        (begin
            (print "squad right02 esc4 01")
            (ai_place "sq_right_02/esc4_01")
            (ai_place "sq_right_02/esc4_02")
            (ai_place "sq_right_02/esc4_03")
        )
    )
)

(script dormant void sc_wraith_top
    (sleep_until (= b_wraith true) 1)
    (sleep_until 
        (begin
            (sleep_until (<= (ai_task_count "obj_vehicles/mg_top") 1) 1)
            (ai_place "sq_top_wraith01")
            (sleep 300)
            false
        )
        1
    )
)

(script dormant void sc_wraith_left
    (sleep_until (= b_wraith true) 1)
    (sleep_until 
        (begin
            (sleep_until (<= (ai_task_count "obj_vehicles/mg_left") 1) 1)
            (ai_place "sq_left_wraith01")
            (sleep 300)
            false
        )
        1
    )
)

(script dormant void sc_wraith_right
    (sleep_until (= b_wraith true) 1)
    (sleep_until 
        (begin
            (sleep_until (<= (ai_task_count "obj_vehicles/mg_right") 1) 1)
            (ai_place "sq_right_wraith01")
            (sleep 300)
            false
        )
        1
    )
)

(script dormant void sc_wraith_bottom
    (sleep_until (= b_wraith true) 1)
    (sleep_until 
        (begin
            (sleep_until (<= (ai_task_count "obj_vehicles/mg_bottom") 1) 1)
            (ai_place "sq_bot_wraith01")
            (sleep 300)
            false
        )
        1
    )
)

(script dormant void sc_fork_bottom
    (sleep_until 
        (begin
            (sleep_until (= (ai_living_count "sq_tuningfork_bot") 0) 1)
            (ai_place "sq_tuningfork_bot")
            false
        )
        1
    )
)

(script dormant void sc_fork_right
    (sleep_until 
        (begin
            (sleep_until (= (ai_living_count "sq_tuningfork_right") 0) 1)
            (ai_place "sq_tuningfork_right")
            false
        )
        1
    )
)

(script dormant void sc_fork_left
    (sleep_until 
        (begin
            (sleep_until (= (ai_living_count "sq_tuningfork_left") 0) 1)
            (ai_place "sq_tuningfork_left")
            false
        )
        1
    )
)

(script dormant void sc_fork_top
    (sleep_until 
        (begin
            (sleep_until (= (ai_living_count "sq_tuningfork_top") 0) 1)
            (ai_place "sq_tuningfork_top")
            false
        )
        1
    )
)

(script command_script void cs_fork01
    (cs_fly_to "ps_fork01/p0")
    (cs_fly_to "ps_fork01/p1")
    (cs_fly_to "ps_fork01/p2")
    (cs_fly_to "ps_fork01/p3")
    (cs_fly_to_and_face "ps_fork01/p4" "ps_fork01/p5")
    (sleep 120)
    (cs_fly_to "ps_fork01/p6")
    (cs_fly_to "ps_fork01/p7")
    (cs_fly_to "ps_fork01/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_fork02
    (cs_fly_to "ps_fork02/p0")
    (cs_fly_to "ps_fork02/p1")
    (cs_fly_to "ps_fork02/p2")
    (cs_fly_to "ps_fork02/p3")
    (cs_fly_to_and_face "ps_fork02/p4" "ps_fork02/p5")
    (sleep 120)
    (cs_fly_to "ps_fork02/p6")
    (cs_fly_to "ps_fork02/p7")
    (cs_fly_to "ps_fork02/p8")
    (ai_erase ai_current_squad)
)

(script command_script void cs_fork03
    (cs_fly_to "ps_fork03/p0")
    (cs_fly_to "ps_fork03/p1")
    (cs_fly_to_and_face "ps_fork03/p2" "ps_fork03/p3")
    (sleep 120)
    (cs_fly_to "ps_fork03/p4")
    (cs_fly_to "ps_fork03/p5")
    (cs_fly_to "ps_fork03/p6")
    (ai_erase ai_current_squad)
)

(script command_script void cs_fork04
    (cs_fly_to "ps_fork04/p0")
    (cs_fly_to "ps_fork04/p1")
    (cs_fly_to_and_face "ps_fork04/p2" "ps_fork04/p3")
    (sleep 120)
    (cs_fly_to "ps_fork04/p4")
    (cs_fly_to "ps_fork04/p5")
    (cs_fly_to "ps_fork04/p6")
    (ai_erase ai_current_squad)
)

(script dormant void f_hill_objective_control
    (if (game_is_cooperative)
        (skull_enable skull_iron false)
    )
    (dprint "::: hill encounter :::")
    (f_cin_intro_finish)
    (cinematic_exit "070lb_re_intro" false)
    (game_save_immediate)
    (set b_hill_ready true)
    (wake f_hill_death_control)
    (wake f_hill_title_control)
    (wake f_hill_missionobj_control)
    (wake f_hill_music_control)
    (wake sc_spawn_start)
    (wake f_hill_last_crack)
    (dprint "objective control : hill.1")
    (set objcon_hill 1)
    (flock_create "flock_banshee")
    (sleep_until b_last_player_dead 1)
    (if (not cheat_deathless_player)
        (begin
            (if (cinematic_skip_start)
                (begin
                    (input_suppress_rumble true)
                    (cinematic_enter "080lc_game_over" true)
                    (f_cin_outro_prep)
                    (set b_cinematic_entered false)
                    (if b_debug_globals
                        (print "f_play_cinematic: playing cinematic...")
                    )
                    (cinematic_show_letterbox_immediate true)
                    (cinematic_run_script_by_name "080lc_game_over")
                    (set b_cinematic_entered true)
                    (sleep 1)
                    (f_cin_epilogue_prep)
                    (cinematic_enter "080ld_epilogue" false)
                    (set b_cinematic_entered false)
                    (sleep 1)
                    (ai_erase_all)
                    (garbage_collect_now)
                    (switch_zone_set "set_cin_outro")
                    (if (cinematic_skip_start)
                        (begin
                            (sleep 1)
                            (if b_debug_globals
                                (print "play outro cinematic...")
                            )
                            (cinematic_show_letterbox true)
                            (sleep 30)
                            (cinematic_show_letterbox_immediate true)
                            (cinematic_run_script_by_name "080ld_epilogue")
                            (cinematic_skip_stop_internal)
                        )
                    )
                )
            )
            (fade_out 0 0 0 0)
            (sleep 1)
            (game_won)
            (sleep 0)
        )
    )
)

(script dormant void f_hill_music_control
    (wake music_hill)
)

(script dormant void f_hill_last_crack
    (sleep_until 
        (begin
            (set s_crack 0)
            (if (and (player_is_in_game player0) b_crack_p0)
                (set s_crack (+ s_crack 1))
            )
            (if (and (player_is_in_game player1) b_crack_p1)
                (set s_crack (+ s_crack 1))
            )
            (if (and (player_is_in_game player2) b_crack_p2)
                (set s_crack (+ s_crack 1))
            )
            (if (and (player_is_in_game player3) b_crack_p3)
                (set s_crack (+ s_crack 1))
            )
            (if (= (game_coop_player_count) s_crack)
                (begin
                    (set b_hill_last_crack true)
                )
            )
            b_hill_last_crack
        )
        1
    )
    (dprint "last crack")
    (set s_music_hill 1)
)

(script static void f_cin_intro_finish
    (ai_place "sq_hill_phantom_init")
)

(script static void f_cin_outro_prep
    (object_destroy_type_mask 1039)
    (add_recycling_volume "tv_recycle_hill" 0 0)
    (add_recycling_volume_by_type "tv_recycle_hill" 0 0 1039)
    (flock_delete "flock_banshee")
    (object_destroy "sc_hill_hide_a_rock")
    (ai_erase "sg_covenant")
    (sleep_forever sc_spawn_bottom)
    (sleep_forever sc_spawn_bottom)
    (sleep_forever sc_spawn_left)
    (sleep_forever sc_spawn_right)
    (sleep_forever sc_spawn_top)
    (sleep_forever sc_escalation)
    (sleep_forever sc_wraith_top)
    (sleep_forever sc_wraith_bottom)
    (sleep_forever sc_wraith_right)
    (sleep_forever sc_wraith_left)
    (sleep_forever sc_fork_bottom)
    (sleep_forever sc_fork_right)
    (sleep_forever sc_fork_left)
    (sleep_forever sc_fork_top)
    (object_teleport_to_ai_point (player0) "ps_hill_outro/player0")
    (object_teleport_to_ai_point (player1) "ps_hill_outro/player1")
    (object_teleport_to_ai_point (player2) "ps_hill_outro/player2")
    (object_teleport_to_ai_point (player3) "ps_hill_outro/player3")
    (sleep_until b_tit_hill_done)
)

(script static void f_cin_epilogue_prep
    (sleep_forever f_rain)
    (weather_animate_force "no_rain" 1 0)
)

(script dormant void f_hill_title_control
    (sleep_until (>= objcon_hill 1) 5)
    (wake tit_hill)
)

(script dormant void f_hill_missionobj_control
    (sleep_until (>= objcon_hill 1) 5)
    (sleep 200)
    (wake mo_hill)
)

(script dormant void f_hill_death_control
    (game_safe_to_respawn false)
    (wake f_death_tracker)
    (wake f_hud_weapons)
    (wake f_hud_grenades)
    (wake f_hud_crack_1)
    (wake f_hud_crack_2)
)

(script dormant void f_death_tracker
    (object_cannot_die_except_kill_volumes (player0) true)
    (object_cannot_die_except_kill_volumes (player1) true)
    (object_cannot_die_except_kill_volumes (player2) true)
    (object_cannot_die_except_kill_volumes (player3) true)
    (sleep_until 
        (begin
            (if (and (or (not (player_is_in_game player0)) (<= (unit_get_health (player0)) r_health_min)) (or (not (player_is_in_game player1)) (<= (unit_get_health (player1)) r_health_min)) (or (not (player_is_in_game player2)) (<= (unit_get_health (player2)) r_health_min)) (or (not (player_is_in_game player3)) (<= (unit_get_health (player3)) r_health_min)))
                (begin
                    (set b_last_player_dead true)
                    (sleep_forever)
                )
            )
            (set s_players_alive 0)
            (if (and (player_is_in_game player0) (> (unit_get_health (player0)) 0))
                (begin
                    (set s_players_alive (+ s_players_alive 1))
                )
            )
            (if (and (player_is_in_game player1) (> (unit_get_health (player1)) 0))
                (begin
                    (set s_players_alive (+ s_players_alive 1))
                )
            )
            (if (and (player_is_in_game player2) (> (unit_get_health (player2)) 0))
                (begin
                    (set s_players_alive (+ s_players_alive 1))
                )
            )
            (if (and (player_is_in_game player3) (> (unit_get_health (player3)) 0))
                (begin
                    (set s_players_alive (+ s_players_alive 1))
                )
            )
            (if (> s_players_alive 1)
                (begin
                    (if (and (player_is_in_game player0) (<= (unit_get_health (player0)) r_health_min))
                        (begin
                            (object_cannot_die_except_kill_volumes (player0) false)
                            (tick)
                            (unit_kill (player0))
                        )
                    )
                    (if (and (player_is_in_game player1) (<= (unit_get_health (player1)) r_health_min))
                        (begin
                            (object_cannot_die_except_kill_volumes (player1) false)
                            (tick)
                            (unit_kill (player1))
                        )
                    )
                    (if (and (player_is_in_game player2) (<= (unit_get_health (player2)) r_health_min))
                        (begin
                            (object_cannot_die_except_kill_volumes (player2) false)
                            (tick)
                            (unit_kill (player2))
                        )
                    )
                    (if (and (player_is_in_game player3) (<= (unit_get_health (player3)) r_health_min))
                        (begin
                            (object_cannot_die_except_kill_volumes (player3) false)
                            (tick)
                            (unit_kill (player3))
                        )
                    )
                )
            )
            (if (and (= s_players_alive 1) (and (or (not (player_is_in_game player0)) (<= (unit_get_health (player0)) r_health_min)) (or (not (player_is_in_game player1)) (<= (unit_get_health (player1)) r_health_min)) (or (not (player_is_in_game player2)) (<= (unit_get_health (player2)) r_health_min)) (or (not (player_is_in_game player3)) (<= (unit_get_health (player3)) r_health_min))))
                (set b_last_player_dead true)
            )
            false
        )
        1
    )
)

(script dormant void f_hud_messages
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_messages) false)
                (begin
                    (f_hud_messages_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_messages) false)
                (begin
                    (f_hud_messages_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_messages) false)
                (begin
                    (f_hud_messages_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_messages) false)
                (begin
                    (f_hud_messages_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_messages_player (player p))
    (chud_fade_messages_for_player p 0 30)
)

(script dormant void f_hud_weapons
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_weapons) false)
                (begin
                    (f_hud_weapons_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_weapons) false)
                (begin
                    (f_hud_weapons_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_weapons) false)
                (begin
                    (f_hud_weapons_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_weapons) false)
                (begin
                    (f_hud_weapons_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_weapons_player (player p))
    (chud_fade_weapon_stats_for_player p 0 30)
)

(script dormant void f_hud_grenades
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_grenades) false)
                (begin
                    (f_hud_grenades_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_grenades) false)
                (begin
                    (f_hud_grenades_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_grenades) false)
                (begin
                    (f_hud_grenades_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_grenades) false)
                (begin
                    (f_hud_grenades_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_grenades_player (player p))
    (chud_fade_grenades_for_player p 0 30)
)

(script dormant void f_hud_motion
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_motion) false)
                (begin
                    (f_hud_motion_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_motion) false)
                (begin
                    (f_hud_motion_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_motion) false)
                (begin
                    (f_hud_motion_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_motion) false)
                (begin
                    (f_hud_motion_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_motion_player (player p))
    (chud_fade_motion_sensor_for_player p 0 30)
    (sleep 30)
    (chud_set_static_hs_variable p 4 1)
)

(script dormant void f_hud_shield
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_shield) false)
                (begin
                    (f_hud_shield_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_shield) false)
                (begin
                    (f_hud_shield_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_shield) false)
                (begin
                    (f_hud_shield_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_shield) false)
                (begin
                    (f_hud_shield_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_shield_player (player p))
    (chud_fade_shield_for_player p 0 30)
)

(script dormant void f_hud_crosshair
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_crosshair) false)
                (begin
                    (f_hud_crosshair_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_crosshair) false)
                (begin
                    (f_hud_crosshair_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_crosshair) false)
                (begin
                    (f_hud_crosshair_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_crosshair) false)
                (begin
                    (f_hud_crosshair_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_crosshair_player (player p))
    (chud_fade_crosshair_for_player p 0 30)
)

(script dormant void f_hud_crack_1
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_crack_1) false)
                (begin
                    (f_hud_crack_1_player player0)
                    (set b_crack_p0 true)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_crack_1) false)
                (begin
                    (f_hud_crack_1_player player1)
                    (set b_crack_p1 true)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_crack_1) false)
                (begin
                    (f_hud_crack_1_player player2)
                    (set b_crack_p2 true)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_crack_1) false)
                (begin
                    (f_hud_crack_1_player player3)
                    (set b_crack_p3 true)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_crack_1_player (player p))
    (chud_set_static_hs_variable p 3 1)
)

(script dormant void f_hud_crack_2
    (sleep_until 
        (begin
            (if (or (>= r_p0_damage_tracker r_damage_crack_2) false)
                (begin
                    (f_hud_crack_2_player player0)
                )
            )
            (if (or (>= r_p1_damage_tracker r_damage_crack_2) false)
                (begin
                    (f_hud_crack_2_player player1)
                )
            )
            (if (or (>= r_p2_damage_tracker r_damage_crack_2) false)
                (begin
                    (f_hud_crack_2_player player2)
                )
            )
            (if (or (>= r_p3_damage_tracker r_damage_crack_2) false)
                (begin
                    (f_hud_crack_2_player player3)
                )
            )
            false
        )
        1
    )
)

(script static void (f_hud_crack_2_player (player p))
    (chud_set_static_hs_variable p 2 1)
    (chud_clear_hs_variable p 4)
)

(script static boolean f_phantom_0_not_spawning
    (or (not b_sq_hill_phantom_0_spawn) (<= (object_get_health (ai_vehicle_get_from_squad "sq_hill_phantom_0" 0)) 0))
)

(script static boolean f_phantom_1_not_spawning
    (or (not b_sq_hill_phantom_1_spawn) (<= (object_get_health (ai_vehicle_get_from_squad "sq_hill_phantom_1" 0)) 0))
)

(script static boolean f_phantom_2_not_spawning
    (or (not b_sq_hill_phantom_2_spawn) (<= (object_get_health (ai_vehicle_get_from_squad "sq_hill_phantom_2" 0)) 0))
)

(script static boolean f_phantom_3_not_spawning
    (or (not b_sq_hill_phantom_3_spawn) (<= (object_get_health (ai_vehicle_get_from_squad "sq_hill_phantom_3" 0)) 0))
)

(script static boolean f_phantom_4_not_spawning
    (or (not b_sq_hill_phantom_4_spawn) (<= (object_get_health (ai_vehicle_get_from_squad "sq_hill_phantom_4" 0)) 0))
)

(script static void (dprint (string s))
    (if b_debug
        (print s)
    )
)

(script static void (md_print (string s))
    (if b_md_print
        (print s)
    )
)

(script static void (dbreak (string s))
    (if (or (not (editor_mode)) b_breakpoints)
        (breakpoint s)
    )
)

(script static void f_abort
    (dprint "function aborted")
)

(script static void tick
    (sleep 1)
)

(script command_script void f_cs_draw
    (cs_stow false)
)

(script static boolean difficulty_is_normal_or_higher
    (or (= (game_difficulty_get) normal) (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
)

(script static boolean difficulty_is_heroic_or_higher
    (or (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
)

(script static boolean difficulty_is_legendary
    (= (game_difficulty_get) legendary)
)

(script static void sh
    (if (!= game_speed 0.5)
        (set game_speed 0.5)
        (set game_speed 1)
    )
)

(script static void s0
    (if (!= game_speed 0)
        (set game_speed 0)
        (set game_speed 1)
    )
)

(script static void s5
    (if (!= game_speed 5)
        (set game_speed 5)
        (set game_speed 1)
    )
)

(script static void b
    (if ai_render_sector_bsps
        (begin
            (set ai_render_sector_bsps false)
            (print "ai_render_sector_bsps off")
        )
        (begin
            (set ai_render_sector_bsps true)
            (print "ai_render_sector_bsps on")
        )
    )
)

(script static void o
    (if ai_render_objectives
        (begin
            (set ai_render_objectives false)
            (print "render objectives off")
        )
        (begin
            (set ai_render_objectives true)
            (print "render objectives on")
        )
    )
)

(script static void d
    (if ai_render_decisions
        (begin
            (set ai_render_decisions false)
            (print "ai_render_decisions off")
        )
        (begin
            (set ai_render_decisions true)
            (print "ai_render_decisions on")
        )
    )
)

(script static void c
    (if ai_render_command_scripts
        (begin
            (set ai_render_command_scripts false)
            (print "ai_render_command_scripts off")
        )
        (begin
            (set ai_render_command_scripts true)
            (print "ai_render_command_scripts on")
        )
    )
)

(script static void p
    (if debug_performances
        (begin
            (set debug_performances false)
            (print "debug_performances off")
        )
        (begin
            (set debug_performances true)
            (print "debug_performances on")
        )
    )
)

(script static void s
    (if b_debug_scripting
        (begin
            (debug_scripting false)
            (print "debug_scripting off")
            (set b_debug_scripting false)
        )
        (begin
            (debug_scripting true)
            (print "debug_scripting on")
            (set b_debug_scripting true)
        )
    )
)

(script static void f
    (print "cinematic_fade_to_gameplay")
    (cinematic_fade_to_gameplay)
)

(script static void pr
    (if ai_render_props
        (begin
            (set ai_render_props false)
            (print "ai_render_props off")
        )
        (begin
            (set ai_render_props true)
            (print "ai_render_props on")
        )
    )
)

(script static void be
    (if ai_render_behavior_stack_all
        (begin
            (set ai_render_behavior_stack_all false)
            (print "ai_render_behavior_stack_all off")
        )
        (begin
            (set ai_render_behavior_stack_all true)
            (print "ai_render_behavior_stack_all on")
        )
    )
)

(script static void de
    (if ai_render_decisions
        (begin
            (set ai_render_decisions false)
            (print "ai_render_decisions off")
        )
        (begin
            (set ai_render_decisions true)
            (print "ai_render_decisions on")
        )
    )
)

(script continuous void f_p0_damage_tracker
    (sleep_until (>= objcon_hill 1) 1)
    (sleep_until 
        (begin
            (if (< (unit_get_shield (player0)) r_p0_shield_last)
                (begin
                    (set r_p0_damage_tracker (+ r_p0_damage_tracker (- r_p0_shield_last (unit_get_shield (player0)))))
                )
            )
            (if (< (unit_get_health (player0)) r_p0_health_last)
                (begin
                    (set r_p0_damage_tracker (+ r_p0_damage_tracker (- r_p0_health_last (unit_get_health (player0)))))
                )
            )
            (set r_p0_shield_last (unit_get_shield (player0)))
            (set r_p0_health_last (unit_get_health (player0)))
            (player_is_in_game player0)
        )
        1
    )
)

(script continuous void f_p1_damage_tracker
    (sleep_until (>= objcon_hill 1) 1)
    (sleep_until 
        (begin
            (if (< (unit_get_shield (player1)) r_p1_shield_last)
                (begin
                    (dprint "shield damage done")
                    (set r_p1_damage_tracker (+ r_p1_damage_tracker (- r_p1_shield_last (unit_get_shield (player1)))))
                )
            )
            (if (< (unit_get_health (player1)) r_p1_health_last)
                (begin
                    (dprint "health damage done")
                    (set r_p1_damage_tracker (+ r_p1_damage_tracker (- r_p1_health_last (unit_get_health (player1)))))
                )
            )
            (set r_p1_shield_last (unit_get_shield (player1)))
            (set r_p1_health_last (unit_get_health (player1)))
            (player_is_in_game player1)
        )
        1
    )
)

(script continuous void f_p2_damage_tracker
    (sleep_until (>= objcon_hill 1) 1)
    (sleep_until 
        (begin
            (if (< (unit_get_shield (player2)) r_p2_shield_last)
                (begin
                    (dprint "shield damage done")
                    (set r_p2_damage_tracker (+ r_p2_damage_tracker (- r_p2_shield_last (unit_get_shield (player2)))))
                )
            )
            (if (< (unit_get_health (player2)) r_p2_health_last)
                (begin
                    (dprint "health damage done")
                    (set r_p2_damage_tracker (+ r_p2_damage_tracker (- r_p2_health_last (unit_get_health (player2)))))
                )
            )
            (set r_p2_shield_last (unit_get_shield (player2)))
            (set r_p2_health_last (unit_get_health (player2)))
            (player_is_in_game player2)
        )
        1
    )
)

(script continuous void f_p3_damage_tracker
    (sleep_until (>= objcon_hill 1) 1)
    (debug_scripting_variable "'s_p3_damage_tracker'" true)
    (sleep_until 
        (begin
            (if (< (unit_get_shield (player3)) r_p3_shield_last)
                (begin
                    (dprint "shield damage done")
                    (set r_p3_damage_tracker (+ r_p3_damage_tracker (- r_p3_shield_last (unit_get_shield (player3)))))
                )
            )
            (if (< (unit_get_health (player3)) r_p3_health_last)
                (begin
                    (dprint "health damage done")
                    (set r_p3_damage_tracker (+ r_p3_damage_tracker (- r_p3_health_last (unit_get_health (player3)))))
                )
            )
            (set r_p3_shield_last (unit_get_shield (player3)))
            (set r_p3_health_last (unit_get_health (player3)))
            (player_is_in_game player3)
        )
        1
    )
)

(script command_script void f_cs_hill_phantom_init
    (cs_enable_looking true)
    (cs_enable_targeting true)
    (set b_sq_hill_phantom_0_spawn true)
    (cs_vehicle_speed 0.2)
    (cs_fly_by "ps_hill_phantom_init/hover_out")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_hill_phantom_init/exit_01")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_hill_phantom_init/exit_02")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0 (* 30 5))
    (cs_fly_by "ps_hill_phantom_init/erase")
    (print "drop")
)

(script static void (f_hill_phantom_0 (ai sq_1, ai sq_2, ai sq_3, ai sq_4, ai sq_5, ai sq_v1, ai sq_v2))
    (set ai_phantom_0_1 sq_1)
    (set ai_phantom_0_2 sq_2)
    (set ai_phantom_0_3 sq_3)
    (set ai_phantom_0_4 sq_4)
    (set ai_phantom_0_5 sq_5)
    (set ai_phantom_0_v1 sq_v1)
    (set ai_phantom_0_v2 sq_v2)
    (ai_place "sq_hill_phantom_0")
    (cs_run_command_script "sq_hill_phantom_0/driver" f_cs_sq_hill_phantom_0)
)

(script command_script void f_cs_sq_hill_phantom_0
    (if (and (not (= ai_phantom_0_v1 none)) (= ai_phantom_0_v2 none))
        (begin
            (f_load_phantom_cargo ai_current_squad "single" ai_phantom_0_v1 none)
        )
    )
    (if (and (not (= ai_phantom_0_v1 none)) (not (= ai_phantom_0_v2 none)))
        (begin
            (f_load_phantom_cargo ai_current_squad "double" ai_phantom_0_v1 ai_phantom_0_v2)
        )
    )
    (set b_sq_hill_phantom_0_spawn true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_fly_by "ps_hill_phantom_0/enter_01")
    (cs_fly_by "ps_hill_phantom_0/hover_in")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_hill_phantom_0/drop" "ps_hill_phantom_0/drop_face" 0.25)
    (print "drop")
    (if (and (not (= ai_phantom_0_v1 none)) (= ai_phantom_0_v2 none))
        (begin
            (f_unload_phantom_cargo ai_current_squad "single")
            (sleep 120)
        )
    )
    (if (and (not (= ai_phantom_0_v1 none)) (not (= ai_phantom_0_v2 none)))
        (begin
            (f_unload_phantom_cargo ai_current_squad "double")
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_0_1 none))
        (begin
            (ai_place ai_phantom_0_1)
            (ai_vehicle_enter_immediate ai_phantom_0_1 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_0_2 none))
        (begin
            (ai_place ai_phantom_0_2)
            (ai_vehicle_enter_immediate ai_phantom_0_2 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_0_3 none))
        (begin
            (ai_place ai_phantom_0_3)
            (ai_vehicle_enter_immediate ai_phantom_0_3 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_0_4 none))
        (begin
            (ai_place ai_phantom_0_4)
            (ai_vehicle_enter_immediate ai_phantom_0_4 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_0_5 none))
        (begin
            (ai_place ai_phantom_0_5)
            (ai_vehicle_enter_immediate ai_phantom_0_5 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (set b_sq_hill_phantom_0_spawn false)
    (cs_fly_by "ps_hill_phantom_0/hover_out")
    (cs_fly_by "ps_hill_phantom_0/exit_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "ps_hill_phantom_0/erase")
    (ai_erase ai_current_squad)
)

(script static void (f_hill_phantom_1 (ai sq_1, ai sq_2, ai sq_3, ai sq_4, ai sq_5, ai sq_v1, ai sq_v2))
    (set ai_phantom_1_1 sq_1)
    (set ai_phantom_1_2 sq_2)
    (set ai_phantom_1_3 sq_3)
    (set ai_phantom_1_4 sq_4)
    (set ai_phantom_1_5 sq_5)
    (set ai_phantom_1_v1 sq_v1)
    (set ai_phantom_1_v2 sq_v2)
    (ai_place "sq_hill_phantom_1")
    (cs_run_command_script "sq_hill_phantom_1/driver" f_cs_sq_hill_phantom_1)
)

(script command_script void f_cs_sq_hill_phantom_1
    (if (and (not (= ai_phantom_1_v1 none)) (= ai_phantom_1_v2 none))
        (begin
            (print "load single")
            (f_load_phantom_cargo ai_current_squad "single" ai_phantom_1_v1 none)
        )
    )
    (if (and (not (= ai_phantom_1_v1 none)) (not (= ai_phantom_1_v2 none)))
        (begin
            (print "load double")
            (f_load_phantom_cargo ai_current_squad "double" ai_phantom_1_v1 ai_phantom_1_v2)
        )
    )
    (set b_sq_hill_phantom_1_spawn true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_fly_by "ps_hill_phantom_1/enter_01")
    (cs_fly_by "ps_hill_phantom_1/hover_in")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_hill_phantom_1/drop" "ps_hill_phantom_1/drop_face" 0.25)
    (print "drop")
    (if (and (not (= ai_phantom_1_v1 none)) (= ai_phantom_1_v2 none))
        (begin
            (f_unload_phantom_cargo ai_current_squad "single")
            (sleep 120)
        )
    )
    (if (and (not (= ai_phantom_1_v1 none)) (not (= ai_phantom_1_v2 none)))
        (begin
            (f_unload_phantom_cargo ai_current_squad "double")
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_1_1 none))
        (begin
            (ai_place ai_phantom_1_1)
            (ai_vehicle_enter_immediate ai_phantom_1_1 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_1_2 none))
        (begin
            (ai_place ai_phantom_1_2)
            (ai_vehicle_enter_immediate ai_phantom_1_2 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_1_3 none))
        (begin
            (ai_place ai_phantom_1_3)
            (ai_vehicle_enter_immediate ai_phantom_1_3 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_1_4 none))
        (begin
            (ai_place ai_phantom_1_4)
            (ai_vehicle_enter_immediate ai_phantom_1_4 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_1_5 none))
        (begin
            (ai_place ai_phantom_1_5)
            (ai_vehicle_enter_immediate ai_phantom_1_5 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (set b_sq_hill_phantom_1_spawn false)
    (cs_fly_by "ps_hill_phantom_1/hover_out")
    (cs_fly_by "ps_hill_phantom_1/exit_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "ps_hill_phantom_1/erase")
    (ai_erase ai_current_squad)
)

(script static void (f_hill_phantom_2 (ai sq_1, ai sq_2, ai sq_3, ai sq_4, ai sq_5, ai sq_v1, ai sq_v2))
    (set ai_phantom_2_1 sq_1)
    (set ai_phantom_2_2 sq_2)
    (set ai_phantom_2_3 sq_3)
    (set ai_phantom_2_4 sq_4)
    (set ai_phantom_2_5 sq_5)
    (set ai_phantom_2_v1 sq_v1)
    (set ai_phantom_2_v2 sq_v2)
    (ai_place "sq_hill_phantom_2")
    (cs_run_command_script "sq_hill_phantom_2/driver" f_cs_sq_hill_phantom_2)
)

(script command_script void f_cs_sq_hill_phantom_2
    (if (and (not (= ai_phantom_2_v1 none)) (= ai_phantom_2_v2 none))
        (begin
            (f_load_phantom_cargo ai_current_squad "single" ai_phantom_2_v1 none)
        )
    )
    (if (and (not (= ai_phantom_2_v1 none)) (not (= ai_phantom_2_v2 none)))
        (begin
            (f_load_phantom_cargo ai_current_squad "double" ai_phantom_2_v1 ai_phantom_2_v2)
        )
    )
    (set b_sq_hill_phantom_2_spawn true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_fly_by "ps_hill_phantom_2/enter_01")
    (cs_fly_by "ps_hill_phantom_2/hover_in")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_hill_phantom_2/drop" "ps_hill_phantom_2/drop_face" 0.25)
    (print "drop")
    (if (and (not (= ai_phantom_2_v1 none)) (= ai_phantom_2_v2 none))
        (begin
            (f_unload_phantom_cargo ai_current_squad "single")
            (sleep 120)
        )
    )
    (if (and (not (= ai_phantom_2_v1 none)) (not (= ai_phantom_2_v2 none)))
        (begin
            (f_unload_phantom_cargo ai_current_squad "double")
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_2_1 none))
        (begin
            (ai_place ai_phantom_2_1)
            (ai_vehicle_enter_immediate ai_phantom_2_1 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_2_2 none))
        (begin
            (ai_place ai_phantom_2_2)
            (ai_vehicle_enter_immediate ai_phantom_2_2 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_2_3 none))
        (begin
            (ai_place ai_phantom_2_3)
            (ai_vehicle_enter_immediate ai_phantom_2_3 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_2_4 none))
        (begin
            (ai_place ai_phantom_2_4)
            (ai_vehicle_enter_immediate ai_phantom_2_4 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_2_5 none))
        (begin
            (ai_place ai_phantom_2_5)
            (ai_vehicle_enter_immediate ai_phantom_2_5 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (set b_sq_hill_phantom_2_spawn false)
    (cs_fly_by "ps_hill_phantom_2/hover_out")
    (cs_fly_by "ps_hill_phantom_2/exit_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "ps_hill_phantom_2/erase")
    (ai_erase ai_current_squad)
)

(script static void (f_hill_phantom_3 (ai sq_1, ai sq_2, ai sq_3, ai sq_4, ai sq_5, ai sq_v1, ai sq_v2))
    (set ai_phantom_3_1 sq_1)
    (set ai_phantom_3_2 sq_2)
    (set ai_phantom_3_3 sq_3)
    (set ai_phantom_3_4 sq_4)
    (set ai_phantom_3_5 sq_5)
    (set ai_phantom_3_v1 sq_v1)
    (set ai_phantom_3_v2 sq_v2)
    (ai_place "sq_hill_phantom_3")
    (cs_run_command_script "sq_hill_phantom_3/driver" f_cs_sq_hill_phantom_3)
)

(script command_script void f_cs_sq_hill_phantom_3
    (if (and (not (= ai_phantom_3_v1 none)) (= ai_phantom_3_v2 none))
        (begin
            (print "load single")
            (f_load_phantom_cargo ai_current_squad "single" ai_phantom_3_v1 none)
        )
    )
    (if (and (not (= ai_phantom_3_v1 none)) (not (= ai_phantom_3_v2 none)))
        (begin
            (print "load double")
            (f_load_phantom_cargo ai_current_squad "double" ai_phantom_3_v1 ai_phantom_3_v2)
        )
    )
    (set b_sq_hill_phantom_3_spawn true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_fly_by "ps_hill_phantom_3/enter_01")
    (cs_fly_by "ps_hill_phantom_3/hover_in")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_hill_phantom_3/drop" "ps_hill_phantom_3/drop_face" 0.25)
    (print "drop")
    (if (and (not (= ai_phantom_3_v1 none)) (= ai_phantom_3_v2 none))
        (begin
            (f_unload_phantom_cargo ai_current_squad "single")
            (sleep 120)
        )
    )
    (if (and (not (= ai_phantom_3_v1 none)) (not (= ai_phantom_3_v2 none)))
        (begin
            (f_unload_phantom_cargo ai_current_squad "double")
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_3_1 none))
        (begin
            (print "place 3_1")
            (ai_place ai_phantom_3_1)
            (ai_vehicle_enter_immediate ai_phantom_3_1 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_3_2 none))
        (begin
            (ai_place ai_phantom_3_2)
            (ai_vehicle_enter_immediate ai_phantom_3_2 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_3_3 none))
        (begin
            (ai_place ai_phantom_3_3)
            (ai_vehicle_enter_immediate ai_phantom_3_3 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_3_4 none))
        (begin
            (ai_place ai_phantom_3_4)
            (ai_vehicle_enter_immediate ai_phantom_3_4 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_3_5 none))
        (begin
            (ai_place ai_phantom_3_5)
            (ai_vehicle_enter_immediate ai_phantom_3_5 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (set b_sq_hill_phantom_3_spawn false)
    (cs_fly_by "ps_hill_phantom_3/hover_out")
    (cs_fly_by "ps_hill_phantom_3/exit_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "ps_hill_phantom_3/erase")
    (ai_erase ai_current_squad)
)

(script static void (f_hill_phantom_4 (ai sq_1, ai sq_2, ai sq_3, ai sq_4, ai sq_5, ai sq_v1, ai sq_v2))
    (set ai_phantom_4_1 sq_1)
    (set ai_phantom_4_2 sq_2)
    (set ai_phantom_4_3 sq_3)
    (set ai_phantom_4_4 sq_4)
    (set ai_phantom_4_5 sq_5)
    (set ai_phantom_4_v1 sq_v1)
    (set ai_phantom_4_v2 sq_v2)
    (ai_place "sq_hill_phantom_4")
    (cs_run_command_script "sq_hill_phantom_4/driver" f_cs_sq_hill_phantom_4)
)

(script command_script void f_cs_sq_hill_phantom_4
    (if (and (not (= ai_phantom_4_v1 none)) (= ai_phantom_4_v2 none))
        (begin
            (f_load_phantom_cargo ai_current_squad "single" ai_phantom_4_v1 none)
        )
    )
    (if (and (not (= ai_phantom_4_v1 none)) (not (= ai_phantom_4_v2 none)))
        (begin
            (f_load_phantom_cargo ai_current_squad "double" ai_phantom_4_v1 ai_phantom_4_v2)
        )
    )
    (set b_sq_hill_phantom_4_spawn true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_fly_by "ps_hill_phantom_4/enter_01")
    (cs_fly_by "ps_hill_phantom_4/hover_in")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_hill_phantom_4/drop" "ps_hill_phantom_4/drop_face" 0.25)
    (print "drop")
    (if (and (not (= ai_phantom_4_v1 none)) (= ai_phantom_4_v2 none))
        (begin
            (f_unload_phantom_cargo ai_current_squad "single")
            (sleep 120)
        )
    )
    (if (and (not (= ai_phantom_4_v1 none)) (not (= ai_phantom_4_v2 none)))
        (begin
            (f_unload_phantom_cargo ai_current_squad "double")
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_4_1 none))
        (begin
            (ai_place ai_phantom_4_1)
            (ai_vehicle_enter_immediate ai_phantom_4_1 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_4_2 none))
        (begin
            (ai_place ai_phantom_4_2)
            (ai_vehicle_enter_immediate ai_phantom_4_2 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_4_3 none))
        (begin
            (ai_place ai_phantom_4_3)
            (ai_vehicle_enter_immediate ai_phantom_4_3 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_4_4 none))
        (begin
            (ai_place ai_phantom_4_4)
            (ai_vehicle_enter_immediate ai_phantom_4_4 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (if (not (= ai_phantom_4_5 none))
        (begin
            (ai_place ai_phantom_4_5)
            (ai_vehicle_enter_immediate ai_phantom_4_5 (ai_vehicle_get ai_current_actor) 16)
            (vehicle_unload (ai_vehicle_get ai_current_actor) 16)
            (sleep 120)
        )
    )
    (set b_sq_hill_phantom_4_spawn false)
    (cs_fly_by "ps_hill_phantom_4/hover_out")
    (cs_fly_by "ps_hill_phantom_4/exit_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "ps_hill_phantom_4/erase")
    (ai_erase ai_current_squad)
)

(script static void (pose_body (object_name body_name, short pose))
    (object_create body_name)
    (if (= pose pose_against_wall_var1)
        (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_01")
        (if (= pose pose_against_wall_var2)
            (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_02")
            (if (= pose pose_against_wall_var3)
                (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_03")
                (if (= pose pose_against_wall_var4)
                    (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_04")
                    (if (= pose pose_on_back_var1)
                        (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_05")
                        (if (= pose pose_on_back_var2)
                            (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_06")
                            (if (= pose pose_on_side_var1)
                                (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_07")
                                (if (= pose pose_on_side_var2)
                                    (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_08")
                                    (if (= pose pose_on_back_var3)
                                        (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_09")
                                        (if (= pose pose_face_down_var1)
                                            (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_10")
                                            (if (= pose pose_face_down_var2)
                                                (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_11")
                                                (if (= pose pose_on_side_var3)
                                                    (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_12")
                                                    (if (= pose pose_on_side_var4)
                                                        (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_13")
                                                        (if (= pose pose_face_down_var3)
                                                            (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_14")
                                                            (if (= pose pose_on_side_var5)
                                                                (scenery_animation_start (scenery body_name) "objects\characters\marine\marine" "deadbody_15")
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)

(script dormant void music_hill
    (sleep_until (>= s_music_hill 1))
    (dprint "music hill start")
    (sound_looping_start "levels\solo\m70_bonus\music\m70b_music_01" none 1)
)

(script dormant void f_rain
    (branch (= s_rain_force 0) (f_rain_kill))
    (sleep_until 
        (begin
            (if (not (= s_rain_force s_rain_force_last))
                (begin
                    (dprint "changing rain")
                    (set s_rain_force_last s_rain_force)
                    (if (= s_rain_force 1)
                        (begin
                            (dprint "heavy")
                            (weather_animate_force "heavy_rain" 1 (random_range 10 15))
                        )
                        (if (= s_rain_force 2)
                            (begin
                                (dprint "stop")
                                (weather_animate_force "no_rain" 1 0)
                            )
                        )
                    )
                )
            )
            false
        )
        5
    )
)

(script static void f_rain_kill
    (weather_animate_force "off" 1 0)
)

(script dormant void mo_hill
    (f_hud_obj_new "prompt_hill" "pause_hill")
)

(script dormant void tit_hill
    (f_hud_chapter "ct_hill")
    (dprint "title done")
    (set b_tit_hill_done true)
)

(script dormant void md_hill_line
    (sleep_until (not g_dialog))
    (set g_dialog true)
    (tick)
    (set g_dialog false)
)

(script static void (md_play_debug (short delay, string line))
    (if dialogue
        (print line)
    )
    (sleep delay)
)

(script static void (md_play (short delay, sound line))
    (sound_impulse_start line none 1)
    (sleep (sound_impulse_language_time line))
    (sleep delay)
)

(script static boolean obj_smg_fo_1_10
    (>= (game_coop_player_count) 2)
)

(script static boolean obj_smg_fo_1_11
    (>= (game_coop_player_count) 3)
)

(script static boolean obj_smg_fo_1_12
    (= (game_coop_player_count) 4)
)

(script static boolean obj_smg_es_1_13
    (= s_escalation 0)
)

(script static boolean obj_smg_es_1_14
    (= s_escalation 1)
)

(script static boolean obj_smg_fo_1_16
    (>= (game_coop_player_count) 2)
)

(script static boolean obj_smg_fo_1_17
    (>= (game_coop_player_count) 3)
)

(script static boolean obj_smg_fo_1_18
    (= (game_coop_player_count) 4)
)

(script static boolean obj_smg_es_1_19
    (= s_escalation 2)
)

(script static boolean obj_smg_fo_1_21
    (>= (game_coop_player_count) 2)
)

(script static boolean obj_smg_fo_1_22
    (>= (game_coop_player_count) 3)
)

(script static boolean obj_smg_fo_1_23
    (= (game_coop_player_count) 4)
)

(script static boolean obj_smg_es_1_24
    (= s_escalation 3)
)

(script static boolean obj_smg_fo_1_26
    (>= (game_coop_player_count) 2)
)

(script static boolean obj_smg_fo_1_27
    (>= (game_coop_player_count) 3)
)

(script static boolean obj_smg_fo_1_28
    (= (game_coop_player_count) 4)
)

(script static boolean obj_smg_es_1_29
    (= s_escalation 4)
)

(script static boolean obj_smg_fo_1_31
    (>= (game_coop_player_count) 2)
)

(script static boolean obj_smg_fo_1_32
    (>= (game_coop_player_count) 3)
)

(script static boolean obj_smg_fo_1_33
    (= (game_coop_player_count) 4)
)

(script static boolean obj_smg_bg_1_37
    (>= s_escalation 3)
)

(script static boolean obj_smg_lg_1_38
    (>= s_escalation 3)
)

(script static boolean obj_smg_rg_1_39
    (>= s_escalation 3)
)

(script static boolean obj_smg_tg_1_40
    (>= s_escalation 3)
)

(script static void itr
    (ins_transition)
)

(script static void ins_transition
    (if b_debug
        (print "::: insertion point: transition")
    )
    (set g_insertion_index s_insert_idx_transition)
    (if (or (and cinematics (not editor)) editor_cinematics)
        (begin
            (cinematic_enter "070lb_re_intro" true)
            (f_play_cinematic_advanced "070lb_re_intro" "set_hill" "set_hill")
            (sleep 1)
        )
    )
    (switch_zone_set "set_hill")
    (sleep 1)
    (if b_debug
        (print "::: insertion: waiting for (set_hill) to fully load...")
    )
    (if b_debug
        (print "::: insertion: finished loading (set_hill)")
    )
    (sleep 1)
    (object_teleport_to_ai_point (player0) "ps_hill_spawn/player0")
    (object_teleport_to_ai_point (player1) "ps_hill_spawn/player1")
    (object_teleport_to_ai_point (player2) "ps_hill_spawn/player2")
    (object_teleport_to_ai_point (player3) "ps_hill_spawn/player3")
)

(script static void ihi
    (ins_hill)
)

(script static void ins_hill
    (if b_debug
        (print "::: insertion point: hill")
    )
    (set g_insertion_index s_insert_idx_hill)
    (if (or (and cinematics (not editor)) editor_cinematics)
        (begin
            (cinematic_enter "070lb_re_intro" true)
            (f_play_cinematic_advanced "070lb_re_intro" "set_hill" "set_hill")
            (sleep 1)
        )
    )
    (switch_zone_set "set_hill")
    (sleep 1)
    (if b_debug
        (print "::: insertion: waiting for (set_hill) to fully load...")
    )
    (if b_debug
        (print "::: insertion: finished loading (set_hill)")
    )
    (sleep 1)
    (object_teleport_to_ai_point (player0) "ps_hill_spawn/player0")
    (object_teleport_to_ai_point (player1) "ps_hill_spawn/player1")
    (object_teleport_to_ai_point (player2) "ps_hill_spawn/player2")
    (object_teleport_to_ai_point (player3) "ps_hill_spawn/player3")
)

(script static void icr
    (ins_credits)
)

(script static void ins_credits
    (if b_debug
        (print "::: insertion point: hill")
    )
    (set g_insertion_index s_insert_idx_hill)
    (if (or (and cinematics (not editor)) editor_cinematics)
        (begin
            (cinematic_enter "070lb_re_intro" true)
            (f_play_cinematic_advanced "070lb_re_intro" "set_hill" "set_hill")
            (sleep 1)
        )
    )
    (switch_zone_set "set_hill")
    (sleep 1)
    (if b_debug
        (print "::: insertion: waiting for (set_hill) to fully load...")
    )
    (if b_debug
        (print "::: insertion: finished loading (set_hill)")
    )
    (sleep 1)
    (object_teleport_to_ai_point (player0) "ps_hill_spawn/player0")
    (object_teleport_to_ai_point (player1) "ps_hill_spawn/player1")
    (object_teleport_to_ai_point (player2) "ps_hill_spawn/player2")
    (object_teleport_to_ai_point (player3) "ps_hill_spawn/player3")
)

(script static void 080ld_epilogue_000_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "epilogue_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "epilogue_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "damaged_helmet_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (sleep 2)
    (cinematic_scripting_start_music 0 0 0)
    (cinematic_scripting_start_music 0 0 1)
    (sleep 28)
    (cinematic_print "custom script play")
    (cinematic_set_title "080ld_cine_timestamp_01")
    (sleep 105)
    (cinematic_print "custom script play")
    (cinematic_set_title "080ld_cine_timestamp_02")
    (sleep 17)
    (cinematic_scripting_start_dialogue 0 0 0 none)
    (sleep 237)
    (cinematic_scripting_start_dialogue 0 0 1 none)
    (sleep 508)
    (cinematic_scripting_start_dialogue 0 0 2 none)
    (sleep 368)
    (cinematic_scripting_start_dialogue 0 0 3 none)
    (sleep 84)
    (cinematic_scripting_start_dialogue 0 0 4 none)
    (sleep 82)
    (sleep (cinematic_tag_fade_out_from_cinematic "080ld_epilogue"))
    (sleep 119)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !080ld_epilogue_000_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (080ld_epilogue_000_sc_sh1)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 080ld_epilogue_cleanup
    (cinematic_scripting_clean_up 0)
)

(script static void begin_080ld_epilogue_debug
    (cinematic_zone_activate_for_debugging 0)
    (sleep 2)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 0)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set_debug_mode true)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
)

(script static void end_080ld_epilogue_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 0)
    (fade_in 0 0 0 0)
)

(script static void 080ld_epilogue_debug
    (begin_080ld_epilogue_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "080ld_epilogue"))
    (!080ld_epilogue_000_sc)
    (end_080ld_epilogue_debug)
)

(script static void begin_080ld_epilogue
    (cinematic_zone_activate 0)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
)

(script static void end_080ld_epilogue
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 080ld_epilogue
    (begin_080ld_epilogue)
    (sleep (cinematic_tag_fade_in_to_cinematic "080ld_epilogue"))
    (!080ld_epilogue_000_sc)
    (end_080ld_epilogue)
)

(script static void 080lb_re_intro_000_sc_sh1
    (fade_in 0 0 0 120)
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "080lb_reintro_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "080lb_reintro_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "player_dmr_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "phantom_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "banshee1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "banshee2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 5 "phantom_background_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_start_music 0 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 3) "banshee_speed" 1 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 4) "wingtips" 0.25 0)
    (cinematic_scripting_start_music 0 0 1)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 3) "wingtips" 0.25 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 4) "banshee_speed" 1 0)
    (sleep 130)
    (cinematic_set_title "080lb_cine_timestamp_01")
    (cinematic_print "custom script play")
    (sleep 105)
    (cinematic_set_title "080lb_cine_timestamp_02")
    (cinematic_print "custom script play")
    (sleep 463)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 080lb_re_intro_000_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "080lb_reintro_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "080lb_reintro_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "player_dmr_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 "phantom_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "banshee1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 "banshee2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 5 "phantom_background_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (sleep 356)
    (sleep (cinematic_tag_fade_out_from_cinematic "070lb_re_intro"))
    (sleep 4)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !080lb_re_intro_000_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (080lb_re_intro_000_sc_sh1)
    (080lb_re_intro_000_sc_sh2)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 070lb_re_intro_cleanup
    (cinematic_scripting_clean_up 1)
)

(script static void begin_070lb_re_intro_debug
    (cinematic_zone_activate_for_debugging 1)
    (sleep 2)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 0)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set_debug_mode true)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
)

(script static void end_070lb_re_intro_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 1)
    (fade_in 0 0 0 0)
)

(script static void 070lb_re_intro_debug
    (begin_070lb_re_intro_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "070lb_re_intro"))
    (!080lb_re_intro_000_sc)
    (end_070lb_re_intro_debug)
)

(script static void begin_070lb_re_intro
    (cinematic_zone_activate 1)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
)

(script static void end_070lb_re_intro
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lb_re_intro
    (begin_070lb_re_intro)
    (sleep (cinematic_tag_fade_in_to_cinematic "070lb_re_intro"))
    (!080lb_re_intro_000_sc)
    (end_070lb_re_intro)
)

(script static void 070lk_credits_010_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "halo_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "poa_cruiser_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "fx_slipspace_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "fx_light_marker_1_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_start_music 0 0 0)
    (cinematic_scripting_start_music 0 0 1)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "launch_prep_off" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_small" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_large" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_medium" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "light_volume_fade" 1 0)
    (sleep 30)
    (cinematic_print "custom script play")
    (cinematic_set_title "070lk_cine_timestamp_01")
    (sleep 50)
    (cinematic_scripting_start_effect 0 0 1 (cinematic_object_get "poa_cruiser"))
    (sleep 5)
    (cinematic_scripting_start_effect 0 0 0 (cinematic_object_get "fx_slipspace"))
    (sleep 15)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_small" 1 15)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_medium" 1 15)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_large" 1 15)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "light_volume_fade" 0 15)
    (sleep 532)
    (cinematic_scripting_start_dialogue 0 0 0 none)
    (sleep 127)
    (cinematic_scripting_start_dialogue 0 0 1 none)
    (sleep 241)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_large" 0.25 150)
    (sleep 50)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_medium" 0.5 150)
    (sleep 50)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_small" 0.5 200)
    (cinematic_print "custom script play")
    (play_credits_unskippable)
    (sleep 905)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "halo_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "poa_cruiser_2" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "fx_light_marker_1_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "launch_prep_off" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_small" 0.5 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_large" 0.25 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_medium" 0.5 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "light_volume_fade" 0 0)
    (sleep 100)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "light_volume_fade" 1 600)
    (sleep 100)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_large" 0.1 800)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_medium" 0 800)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 1) "engines_small" 0 800)
    (sleep 1792)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh3
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 2 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 2)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 0 "halo_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 1 "poa_cruiser_3" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 3 "fx_light_marker_1_3" true)
    (cinematic_lights_initialize_for_shot 2)
    (cinematic_clips_initialize_for_shot 2)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh4
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 3 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 3)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 0 "halo_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 1 "poa_cruiser_4" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 3 "fx_light_marker_1_4" true)
    (cinematic_lights_initialize_for_shot 3)
    (cinematic_clips_initialize_for_shot 3)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh5
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 4 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 4)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 0 "halo_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 1 "poa_cruiser_5" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 3 "fx_light_marker_1_5" true)
    (cinematic_lights_initialize_for_shot 4)
    (cinematic_clips_initialize_for_shot 4)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh6
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 5 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 5)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 0 "halo_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 1 "poa_cruiser_6" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 3 "fx_light_marker_1_6" true)
    (cinematic_lights_initialize_for_shot 5)
    (cinematic_clips_initialize_for_shot 5)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh7
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 6 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 6)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 0 "halo_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 1 "poa_cruiser_7" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 3 "fx_light_marker_1_7" true)
    (cinematic_lights_initialize_for_shot 6)
    (cinematic_clips_initialize_for_shot 6)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh8
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 7 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 7)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 0 "halo_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 1 "poa_cruiser_8" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 3 "fx_light_marker_1_8" true)
    (cinematic_lights_initialize_for_shot 7)
    (cinematic_clips_initialize_for_shot 7)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh9
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 8 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 8)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 8 0 "halo_9" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 8 1 "poa_cruiser_9" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 8 3 "fx_light_marker_1_9" true)
    (cinematic_lights_initialize_for_shot 8)
    (cinematic_clips_initialize_for_shot 8)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh10
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 9 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 9)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 9 0 "halo_10" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 9 1 "poa_cruiser_10" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 9 3 "fx_light_marker_1_10" true)
    (cinematic_lights_initialize_for_shot 9)
    (cinematic_clips_initialize_for_shot 9)
    (sleep 999)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits_010_sc_sh11
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 10 "070lk_credits_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 10)
    (cinematic_object_create_cinematic_anchor "070lk_credits_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 10 0 "halo_11" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 10 1 "poa_cruiser_11" true)
    (object_hide (cinematic_scripting_get_object 0 2) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 10 3 "fx_light_marker_1_11" true)
    (cinematic_lights_initialize_for_shot 10)
    (cinematic_clips_initialize_for_shot 10)
    (sleep 427)
    (cinematic_scripting_start_music 0 10 0)
    (sleep 169)
    (sleep (cinematic_tag_fade_out_from_cinematic "070lk_credits"))
    (sleep 4)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !070lk_credits_010_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (070lk_credits_010_sc_sh1)
    (070lk_credits_010_sc_sh2)
    (070lk_credits_010_sc_sh3)
    (070lk_credits_010_sc_sh4)
    (070lk_credits_010_sc_sh5)
    (070lk_credits_010_sc_sh6)
    (070lk_credits_010_sc_sh7)
    (070lk_credits_010_sc_sh8)
    (070lk_credits_010_sc_sh9)
    (070lk_credits_010_sc_sh10)
    (070lk_credits_010_sc_sh11)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 070lk_credits_cleanup
    (cinematic_scripting_clean_up 2)
)

(script static void begin_070lk_credits_debug
    (cinematic_zone_activate_for_debugging 2)
    (sleep 2)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 0)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set_debug_mode true)
    (cinematic_set (cinematic_tag_reference_get_cinematic 2))
)

(script static void end_070lk_credits_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 2)
    (fade_in 0 0 0 0)
)

(script static void 070lk_credits_debug
    (begin_070lk_credits_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "070lk_credits"))
    (cinematic_outro_start)
    (!070lk_credits_010_sc)
    (end_070lk_credits_debug)
)

(script static void begin_070lk_credits
    (cinematic_zone_activate 2)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 2))
)

(script static void end_070lk_credits
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 070lk_credits
    (begin_070lk_credits)
    (sleep (cinematic_tag_fade_in_to_cinematic "070lk_credits"))
    (cinematic_outro_start)
    (!070lk_credits_010_sc)
    (end_070lk_credits)
)

(script static void 080lc_game_over_000_sc_sh1
    (object_destroy "sc_hill_hide_a_rock")
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "080lc_gameover_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "080lc_gameover_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "elite_01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "elite_01_plasma_rifle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "fx_dyn_light_ambient_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "fx_dyn_light_cu_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "fx_dyn_light_elite01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 5 "fx_dyn_light_helmet_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 6 "fx_dyn_light_hero_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 7 "player_fp_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 8 "player_ar_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 9 "player_pistol_1" true)
    (object_hide (cinematic_scripting_get_object 0 10) true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_start_dialogue 0 0 0 none)
    (cinematic_scripting_start_music 0 0 1)
    (begin
        (chud_cinematic_fade 0 0)
        (chud_show_cinematics true)
    )
    (cinematic_print "custom script play")
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 8) "primary_ammunition_ones" 0.2 0)
    (begin
        (chud_set_static_hs_variable player0 2 1)
        (chud_set_static_hs_variable player1 2 1)
        (chud_set_static_hs_variable player2 2 1)
        (chud_set_static_hs_variable player3 2 1)
    )
    (cinematic_print "custom script play")
    (cinematic_scripting_start_music 0 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 8) "primary_ammunition_tens" 0.3 0)
    (begin
        (chud_set_static_hs_variable player0 3 1)
        (chud_set_static_hs_variable player1 3 1)
        (chud_set_static_hs_variable player2 3 1)
        (chud_set_static_hs_variable player3 3 1)
    )
    (cinematic_print "custom script play")
    (cinematic_scripting_stop_music 0 0 2)
    (cinematic_show_letterbox_immediate false)
    (cinematic_print "custom script play")
    (sleep 18)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 17)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 34)
    (cinematic_print "custom script play")
    (fade_out 0 0 0 6)
    (sleep 6)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 080lc_game_over_000_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "080lc_gameover_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "080lc_gameover_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "elite_01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "elite_01_plasma_rifle_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 "fx_dyn_light_ambient_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "fx_dyn_light_cu_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 "fx_dyn_light_elite01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 5 "fx_dyn_light_helmet_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 6 "fx_dyn_light_hero_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 7 "player_fp_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 8 "player_ar_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 9 "player_pistol_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 10 "broke_arse_helmet_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (chud_cinematic_fade 0 0)
    (begin
        (chud_set_static_hs_variable player0 4 0)
        (chud_set_static_hs_variable player1 4 0)
        (chud_set_static_hs_variable player2 4 0)
        (chud_set_static_hs_variable player3 4 0)
    )
    (begin
        (chud_set_static_hs_variable player0 2 0)
        (chud_set_static_hs_variable player1 2 0)
        (chud_set_static_hs_variable player2 2 0)
        (chud_set_static_hs_variable player3 2 0)
    )
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (begin
        (chud_set_static_hs_variable player0 3 0)
        (chud_set_static_hs_variable player1 3 0)
        (chud_set_static_hs_variable player2 3 0)
        (chud_set_static_hs_variable player3 3 0)
    )
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (sleep 9)
    (cinematic_print "custom script play")
    (fade_in 0 0 0 3)
    (sleep 35)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 46)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 26)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !080lc_game_over_000_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (080lc_game_over_000_sc_sh1)
    (080lc_game_over_000_sc_sh2)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 080lc_game_over_010_sc_sh1
    (set shadow_apply_depth_bias -1E-05)
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1) 0 "080lc_gameover_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1) 0)
    (cinematic_object_create_cinematic_anchor "080lc_gameover_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 0 "elite_01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 1 "elite_01_plasma_rifle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 2 "elite_02_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 "elite_02_sword_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 "elite_03_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 "elite_03_plasma_rifle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 "elite_04_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 7 "elite_04_plasma_repeat0r_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 8 "elite_05_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 9 "elite_05_plasma_rifle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 10 "elite_06_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 11 "elite_06_plasma_rifle_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 12 "elite_06_sword_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 13 "elite_07_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 14 "elite_07_sword_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 15 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 16 "player_ar_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 17 "player_pistol_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 18 "fx_dyn_light_hero_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 19 "fx_dyn_light_helmet_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 20 "fx_dyn_light_ambient_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 21 "fx_dyn_light_cu_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 22 "fx_dyn_light_elite01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 23 "damaged_helmet_1" true)
    (object_hide (cinematic_scripting_get_object 1 24) true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure -1 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 16) "primary_ammunition_tens" 0.3 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 16) "primary_ammunition_ones" 0.2 0)
    (begin
        (chud_cinematic_fade 0 0)
        (chud_show_cinematics true)
    )
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_05") false)
        (object_cannot_die (cinematic_object_get "elite_05") true)
    )
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 12) "blade_activate" 0 0)
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_04") false)
        (object_cannot_die (cinematic_object_get "elite_04") true)
    )
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "player") false)
        (object_cannot_die (cinematic_object_get "player") true)
    )
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_03") false)
        (object_cannot_die (cinematic_object_get "elite_03") true)
    )
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 8) "blade_right_on" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 10) "blade_right_on" 0 0)
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_01") false)
        (object_cannot_die (cinematic_object_get "elite_01") true)
    )
    (cinematic_print "custom script play")
    (begin
        (chud_set_static_hs_variable player0 2 1)
        (chud_set_static_hs_variable player1 2 1)
        (chud_set_static_hs_variable player2 2 1)
        (chud_set_static_hs_variable player3 2 1)
    )
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (begin
        (chud_set_static_hs_variable player0 3 1)
        (chud_set_static_hs_variable player1 3 1)
        (chud_set_static_hs_variable player2 3 1)
        (chud_set_static_hs_variable player3 3 1)
    )
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_02") false)
        (object_cannot_die (cinematic_object_get "elite_02") true)
    )
    (cinematic_show_letterbox_immediate false)
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (begin
        (object_cinematic_visibility (cinematic_object_get "elite_06") false)
        (object_cannot_die (cinematic_object_get "elite_06") true)
    )
    (sleep 1)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 14) "blade_activate" 0 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 3) "blade_activate" 1 0)
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 15)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 10)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 6)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (sleep 8)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 9)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 22)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 2)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_01") "body" 80)
    (sleep 8)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (cinematic_print "custom script play")
    (sleep 4)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 5)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (sleep 22)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") true)
    (sleep 4)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_01_plasma_rifle_weapon") false)
    (sleep 13)
    (cinematic_scripting_start_dialogue 1 0 0 none)
    (sleep 17)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_02") "body" 90)
    (sleep 15)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 3) "blade_activate" 0 8)
    (sleep 52)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_02") "body" 90)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") true)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 45)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") true)
    (sleep 25)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (sleep 9)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") false)
    (sleep 23)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") true)
    (sleep 6)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") true)
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (sleep 22)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") false)
    (cinematic_print "custom script play")
    (sleep 10)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") false)
    (sleep 10)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") true)
    (sleep 8)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") true)
    (cinematic_print "custom script play")
    (sleep 5)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (sleep 6)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") false)
    (sleep 5)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") true)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 4)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 12) "blade_activate" 1 12)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (sleep 3)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") false)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (sleep 3)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") true)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") true)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 1)
    (damage_object (cinematic_object_get "elite_03") "body" 90)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (sleep 1)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") false)
    (cinematic_print "custom script play")
    (sleep 3)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") true)
    (cinematic_print "custom script play")
    (sleep 7)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") true)
    (sleep 7)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") true)
    (cinematic_print "custom script play")
    (sleep 3)
    (cinematic_print "custom script play")
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_ar_weapon") false)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_04_plasma_repeat0r_weapon") false)
    (sleep 2)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") false)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 5)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") true)
    (cinematic_print "custom script play")
    (sleep 2)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_04") "body" 90)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 1)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "elite_03_plasma_rifle_weapon") false)
    (sleep 6)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 9)
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (cinematic_print "custom script play")
    (sleep 7)
    (cinematic_print "custom script play")
    (weapon_set_primary_barrel_firing (cinematic_weapon_get "player_pistol_weapon") false)
    (sleep 58)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 8) "blade_right_on" 1 9)
    (sleep 92)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_06") "body" 90)
    (sleep 46)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 12) "blade_activate" 0 8)
    (sleep 52)
    (cinematic_print "custom script play")
    (damage_object (cinematic_object_get "elite_05") "body" 90)
    (sleep 31)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 14) "blade_activate" 1 15)
    (sleep 3)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 1 10) "blade_right_on" 1 9)
    (sleep 24)
    (set shadow_apply_depth_bias -1E-06)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 080lc_game_over_010_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1) 1 "080lc_gameover_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1) 1)
    (cinematic_object_create_cinematic_anchor "080lc_gameover_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 0 "elite_01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 1 "elite_01_plasma_rifle_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 2 "elite_02_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 3 "elite_02_sword_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 4 "elite_03_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 5 "elite_03_plasma_rifle_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 6 "elite_04_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 7 "elite_04_plasma_repeat0r_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 8 "elite_05_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 9 "elite_05_plasma_rifle_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 10 "elite_06_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 11 "elite_06_plasma_rifle_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 12 "elite_06_sword_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 13 "elite_07_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 14 "elite_07_sword_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 15 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 16 "player_ar_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 17 "player_pistol_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 18 "fx_dyn_light_hero_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 19 "fx_dyn_light_helmet_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 20 "fx_dyn_light_ambient_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 21 "fx_dyn_light_cu_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 22 "fx_dyn_light_elite01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 23 "damaged_helmet_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 24 "wisps_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (render_exposure -1 0)
    (begin
        (chud_show_cinematics false)
        (object_destroy "sc_hill_hide_a_rock")
    )
    (cinematic_print "custom script play")
    (sleep 246)
    (sleep (cinematic_tag_fade_out_from_cinematic "080lc_game_over"))
    (sleep 14)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !080lc_game_over_010_sc
    (cinematic_print "beginning scene 2")
    (cinematic_scripting_create_scene 1)
    (080lc_game_over_010_sc_sh1)
    (080lc_game_over_010_sc_sh2)
    (cinematic_scripting_destroy_scene 1)
)

(script static void 080lc_game_over_cleanup
    (cinematic_scripting_clean_up 3)
)

(script static void begin_080lc_game_over_debug
    (cinematic_zone_activate_for_debugging 3)
    (sleep 2)
    (camera_control true)
    (cinematic_start)
    (set cinematic_letterbox_style 0)
    (cinematic_show_letterbox_immediate true)
    (camera_set_cinematic)
    (cinematic_set_debug_mode true)
    (cinematic_set (cinematic_tag_reference_get_cinematic 3))
)

(script static void end_080lc_game_over_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 3)
    (fade_in 0 0 0 0)
)

(script static void 080lc_game_over_debug
    (begin_080lc_game_over_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "080lc_game_over"))
    (!080lc_game_over_000_sc)
    (!080lc_game_over_010_sc)
    (end_080lc_game_over_debug)
)

(script static void begin_080lc_game_over
    (cinematic_zone_activate 3)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 3))
)

(script static void end_080lc_game_over
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 080lc_game_over
    (begin_080lc_game_over)
    (sleep (cinematic_tag_fade_in_to_cinematic "080lc_game_over"))
    (!080lc_game_over_000_sc)
    (!080lc_game_over_010_sc)
    (end_080lc_game_over)
)

(script static void f_rain_to_f_rain_kill
    (= s_rain_force 0)
    (f_rain_kill)
)

; Decompilation finished in ~0.0795759s
