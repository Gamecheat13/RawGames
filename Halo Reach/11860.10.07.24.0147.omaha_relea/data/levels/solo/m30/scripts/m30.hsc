; Decompiled with Assembly
; 
; Source file: m30.hsc
; Start time: 2018-02-05 12:53:10 PM
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
(global boolean debug true)
(global boolean editor false)
(global boolean cinematics false)
(global boolean dialogue true)
(global boolean skip_intro false)
(global boolean b_mission_complete false)
(global short s_objcon_ovr 0)
(global short s_objcon_fkv 0)
(global short s_objcon_slo 0)
(global short s_objcon_fld 0)
(global short s_objcon_pmp 0)
(global short s_objcon_rvr 0)
(global short s_objcon_set 0)
(global short s_objcon_clf 0)
(global boolean b_ovr_started false)
(global boolean b_fkv_started false)
(global boolean b_slo_started false)
(global boolean b_fld_started false)
(global boolean b_pmp_started false)
(global boolean b_rvr_started false)
(global boolean b_set_started false)
(global boolean b_clf_started false)
(global boolean b_ovr_completed false)
(global boolean b_fkv_completed false)
(global boolean b_slo_completed false)
(global boolean b_fld_completed false)
(global boolean b_pmp_completed false)
(global boolean b_rvr_completed false)
(global boolean b_set_completed false)
(global boolean b_clf_completed false)
(global short s_max_living_militia 4)
(global boolean b_stealth_training_complete false)
(global boolean b_mule_has_roared false)
(global short s_specops_min_scan_time 90)
(global short s_specops_max_scan_time 300)
(global short s_fkv_jetpack_patrol_dest 0)
(global boolean b_fkv_jetpack_patrol_move false)
(global boolean b_fkv_infantry_delivered false)
(global boolean b_fkv_ds0_delivery_started false)
(global boolean b_fkv_phantom_exit false)
(global boolean b_fld_mule_intro_complete false)
(global boolean b_pmp_assault_started false)
(global boolean b_pmp_assault_complete false)
(global boolean b_pmp_cache_discussed false)
(global boolean b_pmp_cache_deployed false)
(global short s_pmp_assault_wave 65535)
(global boolean b_pmp_go_to_gate false)
(global boolean b_pmp_move_to_river false)
(global boolean b_pmp_alpha_enroute false)
(global boolean b_pmp_bravo_enroute false)
(global boolean b_pmp_charlie_enroute false)
(global boolean b_pmp_alpha_delivered false)
(global boolean b_pmp_bravo_delivered false)
(global boolean b_pmp_charlie_delivered false)
(global boolean b_pmp_firefight_start false)
(global boolean b_pmp_player_skips_encounter false)
(global boolean b_pmp_charlie_should_spawn false)
(global boolean b_pmp_assault_start_dropships false)
(global ai ai_pmp_creek_00 "sq_cov_pmp_creek_inf0")
(global ai ai_pmp_creek_01 "sq_cov_pmp_creek_inf1")
(global ai ai_pmp_creek_02 none)
(global ai ai_pmp_creek_03 none)
(global ai ai_pmp_road_00 "sq_cov_pmp_road_grunts0")
(global ai ai_pmp_road_01 "sq_cov_pmp_road_elites0")
(global ai ai_pmp_road_02 "sq_cov_pmp_road_grunts1")
(global ai ai_pmp_road_03 none)
(global ai ai_pmp_lake_00 "sq_cov_pmp_lake_elites0")
(global ai ai_pmp_lake_01 none)
(global ai ai_pmp_lake_02 "sq_cov_pmp_lake_jackals0")
(global ai ai_pmp_lake_03 none)
(global ai ai_stash_militia none)
(global boolean b_pmp_start_dropship_delivered false)
(global boolean b_set_defense_start false)
(global boolean b_set_gate_convo_started false)
(global boolean b_set_gate_open false)
(global boolean b_set_gate_convo_over false)
(global boolean b_set_unsc_advance false)
(global boolean b_set_bridge_should_flank false)
(global boolean b_set_player_front false)
(global short s_set_wave 0)
(global boolean b_set_second_dropship false)
(global boolean b_set_hunters_delivered false)
(global boolean b_clf_gate_opened false)
(global boolean b_cliffside_road_dropoff false)
(global boolean b_cliffside_banshees_overhead false)
(global boolean b_evaluate false)
(global short s_current_blocker_zone 0)
(global short s_current_teleport_zone 0)
(global boolean b_zeta_escape false)
(global sound sound_mule_roar none)
(global looping_sound mus_01 "levels\solo\m30\music\m30_music01.sound_looping")
(global looping_sound mus_02 "levels\solo\m30\music\m30_music02.sound_looping")
(global looping_sound mus_03 "levels\solo\m30\music\m30_music03.sound_looping")
(global looping_sound mus_04 "levels\solo\m30\music\m30_music04.sound_looping")
(global looping_sound mus_05 "levels\solo\m30\music\m30_music05.sound_looping")
(global looping_sound mus_06 "levels\solo\m30\music\m30_music06.sound_looping")
(global looping_sound mus_07 "levels\solo\m30\music\m30_music07.sound_looping")
(global looping_sound mus_08 "levels\solo\m30\music\m30_music08.sound_looping")
(global looping_sound mus_09 "levels\solo\m30\music\m30_music09.sound_looping")
(global looping_sound mus_10 "levels\solo\m30\music\m30_music10.sound_looping")
(global looping_sound mus_11 "levels\solo\m30\music\m30_music11.sound_looping")
(global looping_sound mus_12 "levels\solo\m30\music\m30_music12.sound_looping")
(global looping_sound mus_13 "levels\solo\m30\music\m30_music13.sound_looping")
(global boolean b_dialogue_playing false)
(global short s_md_duration 0)
(global ai ai_jun none)
(global ai ai_cv1 none)
(global ai ai_cv2 none)
(global ai ai_cvf none)
(global boolean b_rvr_dropship_is_overhead false)
(global ai ai_assassination_target none)
(global boolean b_slo_jun_leave false)
(global ai ai_civilian2 none)
(global boolean b_pmp_stash_convo_active false)
(global boolean b_pmp_stash_convo_completed false)
(global boolean b_pmp_post_convo_active false)
(global boolean b_pmp_post_convo_completed false)
(global boolean b_pmp_post_convo_goto_river false)
(global boolean b_weather_debug false)
(global boolean b_rain_is_active false)
(global boolean b_rain_thunderclap false)
(global boolean b_rain_always_on false)
(global boolean b_rain_change_state false)
(global short s_rain_min_on_time 60)
(global short s_rain_max_on_time 180)
(global short s_rain_min_off_time 30)
(global short s_rain_max_off_time 45)
(global short s_rain_min_ramp_up_time 2)
(global short s_rain_max_ramp_up_time 10)
(global short s_rain_min_ramp_down_time 6)
(global short s_rain_max_ramp_down_time 12)
(global short s_rain_min_lightning_delay 5)
(global short s_rain_max_lightning_delay 20)
(global short s_rain_min_thunder_delay 1)
(global short s_rain_max_thunder_delay 3)
(global real r_rain_min_force 1)
(global real r_rain_max_force 1)
(global ai ai_to_deafen none)
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
(global short s_current_insertion_index 65535)
(global short s_insertion_index_start 0)
(global short s_insertion_index_firstkiva 1)
(global short s_insertion_index_silo 2)
(global short s_insertion_index_fields 3)
(global short s_insertion_index_pumpstation 4)
(global short s_insertion_index_river 5)
(global short s_insertion_index_settlement 6)
(global short s_insertion_index_cliffside 7)
(global short s_zone_index_firstkiva 0)
(global short s_zone_index_fields 1)
(global short s_zone_index_canyon 2)
(global short s_zone_index_pumpstation 3)
(global short s_zone_index_river 4)
(global short s_zone_index_settlement 5)
(global short s_zone_index_cliffside 6)
(global short s_bsp_index_010 2)
(global short s_bsp_index_020 3)
(global short s_bsp_index_025 8)
(global short s_bsp_index_028 9)
(global short s_bsp_index_030 4)
(global short s_bsp_index_035 10)
(global short s_bsp_index_040 5)
(global short s_bsp_index_045 6)

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

(script startup void recon_allegiances
    (ai_allegiance human player)
    (ai_allegiance player human)
)

(script static void ping
    (print "ping!")
)

(script startup void recon
    (if debug
        (print "::: m30 - recon :::")
    )
    (objectives_clear)
    (fade_out 0 0 0 0)
    (if (editor_mode)
        (begin
            (if debug
                (print "editor mode -- snapping fade in...")
            )
            (fade_in 0 0 0 0)
        )
        (start)
    )
    (sleep_until (>= s_current_insertion_index 0) 1)
    (if (<= s_current_insertion_index 0)
        (wake ovr_encounter)
    )
    (sleep_until (or (volume_test_players "tv_fkv_start") (>= s_current_insertion_index s_insertion_index_firstkiva)) 1)
    (if (<= s_current_insertion_index s_insertion_index_firstkiva)
        (wake fkv_encounter)
    )
    (sleep_until (or (volume_test_players "tv_silo_start_a") (volume_test_players "tv_silo_start_b") (volume_test_players "tv_silo_start_c") (>= s_current_insertion_index s_insertion_index_silo)) 1)
    (if (<= s_current_insertion_index s_insertion_index_silo)
        (wake silo_encounter)
    )
    (sleep_until (or (volume_test_players "tv_fields_start") (>= s_current_insertion_index s_insertion_index_fields)) 1)
    (if (<= s_current_insertion_index s_insertion_index_fields)
        (wake fld_encounter)
    )
    (sleep_until (or (volume_test_players "tv_pmp_start") (>= s_current_insertion_index s_insertion_index_pumpstation)) 1)
    (if (<= s_current_insertion_index s_insertion_index_pumpstation)
        (wake pmp_encounter)
    )
    (sleep_until (or (volume_test_players "tv_rvr_start") (>= s_current_insertion_index s_insertion_index_river)) 1)
    (if (<= s_current_insertion_index s_insertion_index_river)
        (wake rvr_encounter)
    )
    (sleep_until (or (volume_test_players "tv_set_start") (>= s_current_insertion_index s_insertion_index_settlement)) 1)
    (if (<= s_current_insertion_index s_insertion_index_settlement)
        (wake set_encounter)
    )
    (sleep_until (or (volume_test_players "tv_cliffside_start") b_set_completed (>= s_current_insertion_index s_insertion_index_cliffside)) 1)
    (if (<= s_current_insertion_index s_insertion_index_cliffside)
        (wake clf_encounter)
    )
    (sleep_until (volume_test_players "tv_recon_complete") 1)
    (set b_mission_complete true)
    (f_unblip_flag "fl_clf_exit")
    (if (or (not (editor_mode)) cinematics)
        (begin
            (if debug
                (print "starting the outro cinematic...")
            )
            (zone_set_trigger_volume_enable "zone_set:set_cliffside_035_040_045" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_cliffside_035_040_045" false)
            (f_end_mission "030lb_vista" "set_overlook_040_045_070")
        )
    )
    (game_won)
)

(script static void start
    (print "starting from game insertion...")
    (if (= (game_insertion_point_get) 0)
        (ins_start)
        (if (= (game_insertion_point_get) 1)
            (ins_fields)
            (if (= (game_insertion_point_get) 2)
                (ins_settlement)
                (if (= (game_insertion_point_get) 5)
                    (fade_in 0 0 0 0)
                )
            )
        )
    )
)

(script startup void jun_marker_control
    (if (not (game_is_cooperative))
        (begin
            (sleep_until (> (ai_living_count "unsc_jun") 0) 1)
            (f_hud_spartan_waypoint "unsc_jun" "jun_name" 20)
        )
    )
)

(script startup void player_respawn_profile_control
    (sleep_until (> (game_coop_player_count) 0) 1)
    (if debug
        (print "setting up player profiles...")
    )
    (if (game_is_cooperative)
        (begin
            (if (difficulty_is_easy)
                (begin
                    (if debug
                        (print "easy coop spawn profile")
                    )
                    (force_starting_profile "sp_normal_coop_initial")
                    (player_set_profile "sp_normal_coop_respawn")
                )
            )
            (if (difficulty_is_normal)
                (begin
                    (if debug
                        (print "normal coop spawn profile")
                    )
                    (force_starting_profile "sp_normal_coop_initial")
                    (player_set_profile "sp_normal_coop_respawn")
                )
            )
            (if (difficulty_is_heroic)
                (begin
                    (if debug
                        (print "heroic coop spawn profile")
                    )
                    (force_starting_profile "sp_heroic_coop_initial")
                    (player_set_profile "sp_heroic_coop_respawn")
                )
            )
            (if (difficulty_is_legendary)
                (begin
                    (if debug
                        (print "legendary coop spawn profile")
                    )
                    (force_starting_profile "sp_legendary_coop_initial")
                    (player_set_profile "sp_legendary_coop_respawn")
                )
            )
        )
        (begin
            (if (difficulty_is_easy)
                (begin
                    (if debug
                        (print "easy singleplayer spawn profile")
                    )
                    (force_starting_profile "sp_normal_initial")
                )
            )
            (if (difficulty_is_normal)
                (begin
                    (if debug
                        (print "normal singleplayer spawn profile")
                    )
                    (force_starting_profile "sp_normal_initial")
                )
            )
            (if (difficulty_is_heroic)
                (begin
                    (if debug
                        (print "heroic singleplayer spawn profile")
                    )
                    (force_starting_profile "sp_heroic_initial")
                )
            )
            (if (difficulty_is_legendary)
                (begin
                    (if debug
                        (print "legendary singleplayer spawn profile")
                    )
                    (force_starting_profile "sp_legendary_initial")
                )
            )
        )
    )
)

(script static void (force_starting_profile (starting_profile sp))
    (unit_add_equipment player0 sp true false)
    (unit_add_equipment player1 sp true false)
    (unit_add_equipment player2 sp true false)
    (unit_add_equipment player3 sp true false)
)

(script dormant void ovr_encounter
    (if debug
        (print "::: insertion encounter start")
    )
    (if (or (not (editor_mode)) cinematics)
        (begin
            (if debug
                (print "starting with intro cinematic...")
            )
            (f_start_mission "030la_recon")
            (cinematic_exit_into_title "030la_recon" true)
        )
    )
    (data_mine_set_mission_segment "overlook")
    (garbage_collect_now)
    (ai_place "sq_cov_ovr_high_grunts0")
    (ai_place "sq_cov_ovr_high_elites0")
    (ai_place "sq_cov_fkv_ds0")
    (ai_place "sq_cov_ovr_low_inf1")
    (if (or (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
        (begin
            (ai_place "sq_cov_ovr_low_inf2")
        )
    )
    (if (= (game_difficulty_get) legendary)
        (ai_place "sq_cov_ovr_low_inf0")
    )
    (set ai_to_deafen "gr_cov_ovr")
    (wake start_banshee_control)
    (wake start_jun_main)
    (wake ovr_elite_shift_control)
    (wake save_ovr_defeated)
    (wake fkv_pose_bodies)
    (wake slo_pose_bodies)
    (object_create_folder "cr_ovr")
    (object_create_folder "dm_ovr")
    (object_create_folder "cr_fkv")
    (object_create_folder "dm_fkv")
    (object_create_folder "sc_fkv")
    (object_create_folder "wp_fkv")
    (set b_ovr_started true)
    (game_save)
    (wake chapter_title_start)
    (wake md_start_jun_intro)
    (sleep_until (volume_test_players "tv_objcon_ovr_010") 1)
    (if debug
        (print "::: overlook objective control 010")
    )
    (set s_objcon_ovr 10)
    (sleep_until (volume_test_players "tv_objcon_ovr_020") 1)
    (if debug
        (print "::: overlook objective control 020")
    )
    (set s_objcon_ovr 20)
    (sleep_until (volume_test_players "tv_objcon_ovr_030") 1)
    (if debug
        (print "::: overlook objective control 030")
    )
    (set s_objcon_ovr 30)
    (set ai_assassination_target "sq_cov_ovr_high_elites0")
    (wake md_start_jun_stealth_kill)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ovr_040") 1)
    (if debug
        (print "::: overlook objective control 040")
    )
    (set s_objcon_ovr 40)
    (sleep_until (volume_test_players "tv_objcon_ovr_050") 1)
    (if debug
        (print "::: overlook objective control 050")
    )
    (set s_objcon_ovr 50)
    (sleep_until (volume_test_players "tv_objcon_ovr_060") 1)
    (if debug
        (print "::: overlook objective control 060")
    )
    (set s_objcon_ovr 60)
    (sleep_until (volume_test_players "tv_objcon_ovr_070") 1)
    (if debug
        (print "::: overlook objective control 070")
    )
    (set s_objcon_ovr 70)
    (sleep_until (volume_test_players "tv_objcon_ovr_080") 1)
    (if debug
        (print "::: overlook objective control 080")
    )
    (set s_objcon_ovr 80)
    (sleep_until (volume_test_players "tv_objcon_ovr_090") 1)
    (if debug
        (print "::: overlook objective control 090")
    )
    (set s_objcon_ovr 90)
    (sleep_until (volume_test_players "tv_objcon_ovr_100") 1)
    (if debug
        (print "::: overlook objective control 0100")
    )
    (set s_objcon_ovr 100)
    (sleep_until (volume_test_players "tv_objcon_ovr_110") 1)
    (if debug
        (print "::: overlook objective control 0110")
    )
    (set s_objcon_ovr 110)
    (sleep_until b_fld_started)
    (ovr_cleanup)
)

(script dormant void save_ovr_defeated
    (branch (= b_slo_started true) (branch_abort))
    (sleep_until (<= (ai_living_count "gr_cov_ovr") 0))
    (sleep 60)
    (game_save_no_timeout)
)

(script dormant void start_jun_main
    (if debug
        (print "::: overlook setting up unsc_jun...")
    )
    (ai_erase "unsc_jun")
    (ai_place "unsc_jun/start")
    (sleep 1)
    (set ai_jun "unsc_jun")
    (ai_disregard (ai_get_object ai_jun) true)
    (ai_cannot_die ai_jun true)
    (ai_set_objective ai_jun "obj_unsc_ovr")
    (sleep_until (or (>= s_objcon_ovr 50) (>= (ai_combat_status "gr_cov_ovr") 5)) 1)
    (ai_disregard (ai_get_object ai_jun) false)
)

(script command_script void cs_insertion_banshees
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 30)
    (cs_fly_by "pts_insertion_banshees/flyby0" 10)
    (cs_fly_by "pts_insertion_banshees/flyby1" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 4))
    (cs_fly_by "pts_insertion_banshees/erase" 10)
    (ai_erase ai_current_squad)
)

(script dormant void start_banshee_control
    (sleep_until (>= s_objcon_ovr 20) 1)
    (ai_place "sq_cov_ovr_banshees")
    (ai_disregard (ai_actors "sq_cov_ovr_banshees") true)
)

(script command_script void cs_insertion_kiva_ds0
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost false)
    (cs_vehicle_speed 1)
    (cs_fly_by "pts_insertion_kiva_ds0/p0")
    (cs_fly_by "pts_insertion_kiva_ds0/p1")
    (cs_fly_by "pts_insertion_kiva_ds0/p2")
    (sleep 90)
    (ai_erase ai_current_squad)
)

(script dormant void ovr_elite_shift_control
    (sleep_until (>= s_objcon_ovr 20))
    (sleep_until (or (volume_test_players "tv_ovr_elite_shift") (>= s_objcon_ovr 30)) 1)
    (if (volume_test_players "tv_ovr_elite_shift")
        (cs_run_command_script "sq_cov_ovr_high_elites0" cs_ovr_elite_shift)
    )
)

(script command_script void cs_stand_in_place
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_enable_moving false)
    (cs_push_stance "patrol")
    (sleep_forever)
)

(script command_script void cs_ovr_assassination_start
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_enable_moving false)
    (cs_look true "pts_patrols_insertion/elite_high_look")
    (cs_push_stance "patrol")
    (sleep_forever)
)

(script command_script void cs_ovr_jackal_stand
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_enable_moving false)
    (sleep_until (>= (ai_combat_status "gr_cov_ovr") 5))
)

(script command_script void cs_stand_in_place_fkv
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_enable_moving false)
    (cs_push_stance "patrol")
    (sleep_until (>= (ai_combat_status "gr_cov_fkv") 5))
)

(script command_script void cs_fkv_specops_patrol_silo_roof
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/silo_roof1")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/silo_roof2")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/silo_roof3")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_fkv_specops_patrol_garage_roof
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/garage_roof0")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/garage_roof1")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/garage_roof2")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/garage_roof3")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_fkv_specops_patrol_shed_roof
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/shed_roof0")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/shed_roof1")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/shed_roof2")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/shed_roof3")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
                (begin
                    (ai_set_active_camo ai_current_actor true)
                    (camo_delay_before_moving)
                    (cs_go_to "pts_fkv/shed_roof4")
                    (camo_delay_before_uncloaking)
                    (if (<= (random_range 0 100) 70)
                        (ai_set_active_camo ai_current_actor false)
                    )
                    (sleep (random_range s_specops_min_scan_time s_specops_max_scan_time))
                )
            )
            false
        )
        1
    )
)

(script static void camo_delay_before_moving
    (sleep (random_range 25 40))
)

(script static void camo_delay_before_uncloaking
    (sleep (random_range 30 60))
)

(script command_script void cs_fkv_jetpack_search
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (sleep_until b_fkv_jetpack_patrol_move 1)
    (sleep_until 
        (begin
            (if (= s_fkv_jetpack_patrol_dest 0)
                (begin
                    (if debug
                        (print "jetpacks going to silo")
                    )
                    (begin_random_count
                        1
                        (cs_go_to "pts_fkv_jetpacks/silo_roof0")
                        (cs_go_to "pts_fkv_jetpacks/silo_roof1")
                        (cs_go_to "pts_fkv_jetpacks/silo_roof2")
                    )
                )
                (if (= s_fkv_jetpack_patrol_dest 1)
                    (begin
                        (if debug
                            (print "jetpacks going to garage")
                        )
                        (begin_random_count
                            1
                            (cs_go_to "pts_fkv_jetpacks/garage_roof0")
                            (cs_go_to "pts_fkv_jetpacks/garage_roof1")
                            (cs_go_to "pts_fkv_jetpacks/garage_roof2")
                        )
                    )
                    (if (= s_fkv_jetpack_patrol_dest 2)
                        (begin
                            (if debug
                                (print "jetpacks going to barracks")
                            )
                            (begin_random_count
                                1
                                (cs_go_to "pts_fkv_jetpacks/barracks_roof0")
                                (cs_go_to "pts_fkv_jetpacks/barracks_roof1")
                                (cs_go_to "pts_fkv_jetpacks/barracks_roof2")
                            )
                        )
                        (if (= s_fkv_jetpack_patrol_dest 3)
                            (begin
                                (if debug
                                    (print "jetpacks going to shed")
                                )
                                (begin_random_count
                                    1
                                    (cs_go_to "pts_fkv_jetpacks/shed_roof0")
                                    (cs_go_to "pts_fkv_jetpacks/shed_roof1")
                                    (cs_go_to "pts_fkv_jetpacks/shed_roof2")
                                )
                            )
                        )
                    )
                )
            )
            (sleep_until b_fkv_jetpack_patrol_move (random_range 30 60))
            false
        )
        1
    )
)

(script command_script void cs_fkv_jetpack_search_silo
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (jetpack_delay_before_moving)
    (begin_random_count
        1
        (cs_go_to "pts_fkv_jetpacks/silo_roof0")
        (cs_go_to "pts_fkv_jetpacks/silo_roof1")
        (cs_go_to "pts_fkv_jetpacks/silo_roof2")
    )
    (sleep_forever)
)

(script command_script void cs_fkv_jetpack_search_barracks
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (jetpack_delay_before_moving)
    (begin_random_count
        1
        (cs_go_to "pts_fkv_jetpacks/barracks_roof0")
        (cs_go_to "pts_fkv_jetpacks/barracks_roof1")
        (cs_go_to "pts_fkv_jetpacks/barracks_roof2")
    )
    (sleep_forever)
)

(script command_script void cs_fkv_jetpack_search_shed
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (jetpack_delay_before_moving)
    (begin_random_count
        1
        (cs_go_to "pts_fkv_jetpacks/shed_roof0")
        (cs_go_to "pts_fkv_jetpacks/shed_roof1")
        (cs_go_to "pts_fkv_jetpacks/shed_roof2")
    )
    (sleep_forever)
)

(script command_script void cs_fkv_jetpack_search_garage
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (jetpack_delay_before_moving)
    (begin_random_count
        1
        (cs_go_to "pts_fkv_jetpacks/garage_roof0")
        (cs_go_to "pts_fkv_jetpacks/garage_roof1")
        (cs_go_to "pts_fkv_jetpacks/garage_roof2")
    )
    (sleep_forever)
)

(script dormant void fkv_jetpack_search_control
    (branch (>= (ai_combat_status "gr_cov_fkv") 3) (branch_abort))
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (if debug
                        (print "jetpacks to silo")
                    )
                    (cs_run_command_script "gr_cov_fkv_jetpacks" cs_fkv_jetpack_search_silo)
                    (jetpack_search_delay)
                )
                (begin
                    (if debug
                        (print "jetpacks to garage")
                    )
                    (cs_run_command_script "gr_cov_fkv_jetpacks" cs_fkv_jetpack_search_garage)
                    (jetpack_search_delay)
                )
                (begin
                    (if debug
                        (print "jetpacks to shed")
                    )
                    (cs_run_command_script "gr_cov_fkv_jetpacks" cs_fkv_jetpack_search_shed)
                    (jetpack_search_delay)
                )
            )
            false
        )
        1
    )
)

(script static void jetpack_search_delay
    (sleep (random_range (* 30 30) (* 30 90)))
)

(script static void jetpack_delay_before_moving
    (sleep (random_range 30 90))
)

(script command_script void cs_fkv_highvalue_patrol
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_push_stance "patrol")
    (cs_walk true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_go_to "pts_fkv/cliff0")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/cliff1")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/courtyard0")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/courtyard1")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/courtyard2")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/barracks0")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/barracks1")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/shed_path0")
                    (highvalue_delay_before_shift)
                )
                (begin
                    (cs_go_to "pts_fkv/garage0")
                    (highvalue_delay_before_shift)
                )
            )
            false
        )
        1
    )
)

(script static void highvalue_delay_before_shift
    (sleep (random_range 120 400))
)

(script command_script void cs_ovr_elite_shift
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_walk true)
    (cs_go_by "pts_patrols_insertion/elite_shift0_left" "pts_patrols_insertion/elite_shift0_right")
    (cs_go_by "pts_patrols_insertion/elite_shift1_left" "pts_patrols_insertion/elite_shift1_right")
    (cs_go_to "pts_patrols_insertion/elite_shift2")
    (cs_posture_set "patrol" true)
)

(script command_script void cs_insertion_elite0_look
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_aim true "pts_insertion_patrols/elite0_look")
    (sleep_until (volume_test_players "tv_ovr_elite_vision_cone") 1)
)

(script static void ovr_cleanup
    (if debug
        (print "::: overlook cleaning up the encounter...")
    )
    (ai_disposable "gr_cov_ovr" true)
    (object_destroy_folder "cr_ovr")
    (sleep_forever ovr_encounter)
    (object_destroy_folder "dm_ovr")
)

(script dormant void fkv_encounter
    (if debug
        (print "::: firstkiva ::: encounter start")
    )
    (data_mine_set_mission_segment "firstkiva")
    (game_save)
    (recycle_010)
    (set ai_to_deafen "gr_cov_fkv")
    (wake fkv_jun_main)
    (wake fkv_jun_stealth)
    (wake fkv_combat_control)
    (wake fkv_stealth_control)
    (wake fkv_retreat_control)
    (wake fkv_jetpack_search_control)
    (wake fkv_mus02_stop)
    (wake save_fkv_garage)
    (wake save_fkv_jetpacks)
    (wake save_fkv_courtyard)
    (wake save_fkv_encounter)
    (if (or (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
        (begin
            (print "heroic")
        )
    )
    (soft_ceiling_enable "camera_blocker_01" false)
    (ai_disregard (ai_get_object "sq_cov_fkv_ds0") true)
    (set b_fkv_started true)
    (game_save)
    (wake md_fkv_jun_sitrep)
    (sleep_until (volume_test_players "tv_objcon_fkv_005") 1)
    (if debug
        (print "::: firstkiva objective control 005")
    )
    (set s_objcon_fkv 5)
    (sleep_until (volume_test_players "tv_objcon_fkv_010") 1)
    (if debug
        (print "::: firstkiva objective control 010")
    )
    (set s_objcon_fkv 10)
    (sleep_until (volume_test_players "tv_objcon_fkv_020") 1)
    (if debug
        (print "::: firstkiva objective control 020")
    )
    (set s_objcon_fkv 20)
    (bring_jun_forward 15)
    (sleep_until (volume_test_players "tv_objcon_fkv_030") 1)
    (if debug
        (print "::: firstkiva objective control 030")
    )
    (set s_objcon_fkv 30)
    (ai_suppress_combat "unsc_jun" true)
    (sleep_until (volume_test_players "tv_objcon_fkv_040") 1)
    (if debug
        (print "::: firstkiva objective control 040")
    )
    (set s_objcon_fkv 40)
    (sleep_until (volume_test_players "tv_objcon_fkv_050") 1)
    (if debug
        (print "::: firstkiva objective control 050")
    )
    (set s_objcon_fkv 50)
    (sleep_until (volume_test_players "tv_objcon_fkv_060") 1)
    (if debug
        (print "::: firstkiva objective control 060")
    )
    (set s_objcon_fkv 60)
    (sleep_until (volume_test_players "tv_objcon_fkv_070") 1)
    (if debug
        (print "::: firstkiva objective control 070")
    )
    (set s_objcon_fkv 70)
    (sleep_until (volume_test_players "tv_objcon_fkv_080") 1)
    (if debug
        (print "::: firstkiva objective control 080")
    )
    (set s_objcon_fkv 80)
    (sleep_until (volume_test_players "tv_objcon_fkv_090") 1)
    (if debug
        (print "::: firstkiva objective control 090")
    )
    (set s_objcon_fkv 90)
    (sleep_until (volume_test_players "tv_objcon_fkv_100") 1)
    (if debug
        (print "::: firstkiva objective control 100")
    )
    (set s_objcon_fkv 100)
    (bring_jun_forward 10)
    (sleep_until (>= s_objcon_pmp 30))
    (fkv_cleanup)
)

(script dormant void fkv_jun_main
    (if debug
        (print "::: firstkiva ::: setting up unsc_jun...")
    )
    (sleep 1)
    (set ai_jun "unsc_jun")
    (ai_cannot_die "unsc_jun" true)
    (ai_set_objective "unsc_jun" "obj_unsc_fkv")
)

(script dormant void fkv_jun_stealth
    (ai_disregard (ai_get_object ai_jun) true)
    (if debug
        (print "jun is invisible")
    )
    (sleep_until (or b_slo_started (>= (ai_combat_status "gr_cov_ovr") 5) (>= (ai_combat_status "gr_cov_fkv") 5)))
    (if debug
        (print "jun is visible")
    )
    (ai_suppress_combat ai_jun false)
    (ai_disregard (ai_get_object ai_jun) false)
)

(script dormant void save_fkv_hill
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (<= (ai_living_count "sq_cov_fkv_hill_elites0") 0))
    (sleep 30)
    (game_save_no_timeout)
)

(script dormant void save_fkv_center
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (<= (ai_living_count "sq_cov_fkv_grunts0") 0) (<= (ai_living_count "sq_cov_fkv_jackals0") 0)))
    (sleep 30)
    (game_save_no_timeout)
)

(script dormant void save_fkv_jetpacks
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (> (ai_spawn_count "gr_cov_fkv_jetpacks") 0) (<= (ai_living_count "gr_cov_fkv_jetpacks") 0)))
    (game_save_no_timeout)
)

(script dormant void save_fkv_garage
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (> (ai_spawn_count "gr_cov_fkv_reinforce_garage") 0) (<= (ai_living_count "gr_cov_fkv_reinforce_garage") 0)))
    (game_save_no_timeout)
)

(script dormant void save_fkv_courtyard
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (> (ai_spawn_count "gr_cov_fkv_reinforce_courtyard") 0) (<= (ai_living_count "gr_cov_fkv_reinforce_courtyard") 0)))
    (game_save_no_timeout)
)

(script dormant void save_fkv_encounter
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (> (ai_spawn_count "gr_cov_fkv_reinforce") 0) (f_ai_is_defeated "gr_cov_fkv_reinforce") (<= (ai_living_count "gr_cov_fkv") 0)))
    (sleep 90)
    (game_save_no_timeout)
)

(script dormant void save_fkv_buildings
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (and (<= (ai_living_count "sq_cov_fkv_silo") 0) (<= (ai_living_count "sq_cov_fkv_barracks") 0)))
    (sleep 30)
    (game_save_no_timeout)
)

(script dormant void save_fkv_objcon_050
    (sleep_until (>= s_objcon_fkv 50))
    (sleep 30)
    (game_save_no_timeout)
)

(script dormant void fkv_music_control
    (sleep_until (or (ai_is_alert "gr_cov_fkv") (ai_is_alert "gr_cov_slo")))
    (sleep_until (or (and (f_ai_is_defeated "gr_cov_fkv") (f_ai_is_defeated "gr_cov_slo")) (= b_fld_started true)))
)

(script dormant void fkv_mus02_stop
    (sleep_until (> (ai_task_count "obj_cov_fkv/gate_reinforce") 0))
    (sleep_until (or b_slo_started (and (> (ai_spawn_count "gr_cov_fkv_reinforce") 0) (<= (ai_task_count "obj_cov_fkv/gate_main") 0))))
    (if debug
        (print "stopping mus_02")
    )
    (mus_stop mus_02)
    (if debug
        (print "starting exit timer")
    )
)

(script dormant void fkv_exit_helper
    (branch (= b_slo_started true) (branch_fkv_exit_helper))
    (sleep (* 30 120))
    (f_blip_flag "fl_fkv_exit" 21)
)

(script static void branch_fkv_exit_helper
    (f_unblip_flag "fl_fkv_exit")
)

(script dormant void fkv_stealth_control
    (sleep_until (>= (ai_combat_status "gr_cov_fkv") 3))
    (cs_force_combat_status "gr_cov_fkv" 5)
)

(script dormant void fkv_combat_control
    (ai_place "sq_cov_fkv_grunts0")
    (ai_place "sq_cov_fkv_jpe2_fkv0")
    (if (difficulty_is_heroic_or_higher)
        (ai_place "sq_cov_fkv_jpe2_fkv1")
        (ai_place "sq_cov_fkv_elites0" 2)
    )
    (if (difficulty_is_heroic_or_higher)
        (ai_place "sq_cov_fkv_e1g3_highvalue0")
    )
    (if (difficulty_is_legendary)
        (if (game_is_cooperative)
            (ai_place "sq_cov_fkv_specops_snipers0")
            (ai_place "sq_cov_fkv_specops_snipers0" 1)
        )
    )
    (sleep_until (and (<= (ai_strength "gr_cov_fkv") 0.55) (>= (ai_combat_status "gr_cov_fkv") 3)))
    (sleep (random_range (* 30 5) (* 30 10)))
    (ai_place "sq_cov_fkv_phantom_reinforce")
    (sleep 300)
    (wake md_jun_really_pissed_them_off)
)

(script dormant void fkv_retreat_control
    (branch (= b_slo_started true) (branch_abort))
    (sleep_until (and (> (ai_spawn_count "gr_cov_fkv_reinforce") 0) (<= (ai_strength "gr_cov_fkv") 0.2)))
    (sleep_until (volume_test_players "tv_fkv_approach_02"))
    (if debug
        (print "fkv is getting ready to retreat")
    )
    (sleep (random_range (* 30 5) (* 30 12)))
    (if debug
        (print "fkv is retreating!")
    )
    (ai_set_objective "gr_cov_fkv" "obj_cov_slo")
)

(script static void test_new_fkv
    (ai_place "unsc_jun/fkv")
    (sleep 1)
    (ai_cannot_die "unsc_jun" true)
    (ai_set_objective "unsc_jun" "obj_unsc_fkv")
    (set ai_jun "unsc_jun")
)

(script command_script void cs_cov_fkv_highvalue_dropship
    (f_load_phantom (ai_vehicle_get ai_current_actor) "right" "sq_cov_fkv_e1g3_highvalue0" none none none)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
    (sleep 90)
    (ai_erase ai_current_squad)
)

(script command_script void cs_cov_fkv_reinforce_dropship
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_ignore_obstacles true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_fkv_reinforce/entry1")
    (ai_place "sq_cov_fkv_e1j4_reinforce0")
    (ai_place "sq_cov_fkv_e1g6_reinforce0")
    (ai_vehicle_enter_immediate "sq_cov_fkv_e1g6_reinforce0" (ai_vehicle_get ai_current_actor) 16)
    (ai_vehicle_enter_immediate "sq_cov_fkv_e1j4_reinforce0" (ai_vehicle_get ai_current_actor) 17)
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "ps_fkv_reinforce/entry0")
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "ps_fkv_reinforce/hover" "ps_fkv_reinforce/land_facing" 0.7)
    (sleep 30)
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "ps_fkv_reinforce/land" "ps_fkv_reinforce/land_facing" 0.2)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
    (sleep 90)
    (if (= b_slo_started true)
        (ai_set_objective "gr_cov_fkv_reinforce" "obj_cov_slo")
    )
    (cs_fly_to_and_face "ps_fkv_reinforce/hover" "ps_fkv_reinforce/land_facing")
    (sleep 20)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "ps_fkv_reinforce/exit0")
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_fkv_reinforce/exit1")
    (cs_vehicle_boost true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 90)
    (cs_fly_by "ps_fkv_reinforce/erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_cov_fkv_reinforce_left
    (cs_enable_looking true)
    (cs_enable_targeting true)
    (cs_shoot true)
    (cs_go_by "ps_fkv_reinforce/left_dest0" "ps_fkv_reinforce/left_dest0")
)

(script command_script void cs_cov_fkv_highvalue_report
    (cs_stow true)
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_enable_moving false)
    (cs_push_stance "patrol")
    (cs_go_to "ps_fkv_highvalue/highvalue_dest")
    (sleep_forever)
)

(script dormant void fkv_pose_bodies
    (pose_body "sc_fkv_body_00" pose_against_wall_var2)
    (pose_body "sc_fkv_body_01" pose_against_wall_var2)
    (pose_body "sc_fkv_body_02" pose_on_side_var5)
    (pose_body "sc_fkv_body_03" pose_face_down_var3)
    (pose_body "sc_fkv_body_04" pose_against_wall_var1)
    (pose_body "sc_fkv_body_05" pose_on_back_var3)
    (pose_body "sc_fkv_body_06" pose_on_side_var1)
    (pose_body "sc_fkv_body_07" pose_on_side_var2)
    (pose_body "sc_fkv_body_08" pose_against_wall_var3)
    (pose_body "sc_fkv_body_09" pose_face_down_var1)
    (pose_body "sc_fkv_body_10" pose_face_down_var2)
    (sleep_until b_pmp_started)
    (object_destroy_folder "sc_fkv_bodies")
)

(script static void branch_abort_fkv_bodies
    (object_destroy_folder "sc_fkv_bodies")
)

(script dormant void fkv_cov_shed1_spawn_control
    (sleep_until (and (< (ai_strength "gr_cov_fk") 0.15) (>= s_objcon_fkv 50)))
    (ai_place "sq_cov_fkv_shed1")
)

(script static boolean fkv_ds0_turret_is_alive
    (> (unit_get_health (ai_get_turret_ai "sq_cov_fkv_ds0/pilot" 0)) 0)
)

(script command_script void cs_fkv_hill_elite_idle
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (unit_set_stance ai_current_actor "patrol")
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_look true "pts_fkv_hill_patrols/elite_look0")
                    (sleep (random_range 90 210))
                )
                (begin
                    (cs_look true "pts_fkv_hill_patrols/elite_look1")
                    (sleep (random_range 90 210))
                )
                (begin
                    (cs_look true "pts_fkv_hill_patrols/elite_look2")
                    (sleep (random_range 90 210))
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_fk_ds0_gunner_auto
    (if debug
        (print "ds0 turret control disabled...")
    )
)

(script command_script void cs_fkv_ds0_approach
    (cs_vehicle_speed 0.75)
    (cs_fly_by "pts_fkv_ds0/p0")
    (cs_fly_by "pts_fkv_ds0/p1")
    (cs_fly_by "pts_fkv_ds0/p2")
    (cs_fly_by "pts_fkv_ds0/p3")
    (cs_fly_by "pts_fkv_ds0/p4")
    (cs_fly_by "pts_fkv_ds0/p5")
    (cs_queue_command_script ai_current_actor cs_fkv_ds0_exit)
)

(script command_script void cs_fkv_ds0_hover
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_fkv_ds0/hover0" "pts_fkv_ds0/facing" 0.25)
    (cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fkv_ds0_gunner_search_courtyard)
    (cs_vehicle_speed 0.1)
    (sleep_until 
        (begin
            (cs_fly_to_and_face "pts_fkv_ds0/hover0" "pts_fkv_ds0/facing" 0.25)
            (sleep (random_range 90 150))
            (cs_fly_to_and_face "pts_fkv_ds0/hover1" "pts_fkv_ds0/facing" 0.25)
            (sleep (random_range 90 150))
            (cs_fly_to_and_face "pts_fkv_ds0/hover1" "pts_fkv_ds0/facing" 0.25)
            (sleep (random_range 90 150))
            false
        )
        1
    )
)

(script command_script void cs_fkv_ds0_gunner_search_courtyard
    (if debug
        (print "ds0 gunner searching center...")
    )
    (sleep_until 
        (begin
            (cs_aim true "pts_fk_ds0_search_courtyard/target0")
            (if debug
                (print "courtyard target0")
            )
            (sleep 150)
            (cs_aim true "pts_fk_ds0_search_courtyard/target1")
            (if debug
                (print "courtyard target1")
            )
            (sleep 150)
            (cs_aim true "pts_fk_ds0_search_courtyard/target2")
            (if debug
                (print "courtyard target2")
            )
            (sleep 150)
            (cs_aim true "pts_fk_ds0_search_courtyard/target3")
            (if debug
                (print "courtyard target3")
            )
            (sleep 150)
            false
        )
    )
)

(script static void fkv_ds0_exit
    (cs_run_command_script "sq_cov_fkv_ds0/pilot" cs_fkv_ds0_exit)
)

(script command_script void cs_fkv_ds0_exit
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_fk_ds_exit/exit0")
    (cs_fly_by "pts_fk_ds_exit/exit1")
    (cs_fly_by "pts_fk_ds_exit/exit2")
    (cs_vehicle_speed 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (cs_fly_by "pts_fk_ds_exit/erase")
    (ai_erase ai_current_squad)
)

(script static void fkv_ds0_attack_hill
    (cs_run_command_script "sq_cov_fkv_ds0/pilot" cs_fkv_ds0_attack)
)

(script command_script void cs_fkv_ds0_attack
    (cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fk_ds0_gunner_auto)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.4)
    (cs_fly_to "pts_fk_ds0_search_courtyard/hover_hill" 0.5)
    (cs_run_command_script (ai_get_turret_ai ai_current_squad 0) cs_fk_ds0_gunner_auto)
)

(script static void fkv_ds0_dropoff_hill
    (cs_run_command_script "sq_cov_fkv_ds0/pilot" cs_fkv_ds0_dropoff_hill)
)

(script command_script void cs_fkv_ds0_dropoff_hill
    (cs_vehicle_speed 0.4)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "right" "sq_cov_fkv_reinforce_elites0" "sq_cov_fkv_reinforce_grunts0" none none)
    (cs_fly_to_and_face "pts_fk_ds0_search_courtyard/land" "pts_fk_ds0_search_courtyard/land_facing" 0.25)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
    (sleep 30)
    (cs_run_command_script ai_current_actor cs_fkv_ds0_exit)
)

(script static void fkv_cleanup
    (if debug
        (print "::: firstkiva ::: cleaning up encounter...")
    )
    (ai_disposable "gr_cov_fkv" true)
    (object_destroy_folder "cr_fkv")
    (object_destroy_folder "wp_fkv")
    (object_destroy_folder "sc_fkv")
    (object_destroy_folder "cr_ovr")
    (object_destroy_folder "dm_ovr")
    (object_destroy_folder "cr_fkv")
    (object_destroy_folder "dm_fkv")
    (object_destroy_folder "sc_fkv")
    (object_destroy_folder "wp_fkv")
    (sleep_forever fkv_encounter)
)

(script dormant void silo_encounter
    (if debug
        (print "::: silo ::: encounter start")
    )
    (data_mine_set_mission_segment "silo")
    (garbage_collect_now)
    (object_create_folder "wp_slo")
    (object_create_folder "sc_slo")
    (ai_place "gr_cov_slo")
    (soft_ceiling_enable "camera_blocker_02" false)
    (wake slo_jun_main)
    (wake slo_backup_control)
    (wake save_slo_grind)
    (ai_set_objective "gr_cov_fkv" "obj_cov_slo")
    (mus_stop mus_02)
    (mus_stop mus_01)
    (wake slo_save_start)
    (set b_slo_started true)
    (wake show_tutorial_nightvision)
    (f_unblip_flag "fl_fkv_exit")
    (ai_disregard (ai_get_object ai_jun) false)
    (sleep_until (or (volume_test_players "tv_objcon_slo_010a") (volume_test_players "tv_objcon_slo_010b") (volume_test_players "tv_objcon_slo_010c") (volume_test_players "tv_objcon_slo_010d")) 1)
    (if debug
        (print "::: silo ::: objective control 010")
    )
    (set s_objcon_slo 10)
    (bring_jun_forward 10)
    (sleep_until (volume_test_players "tv_objcon_slo_020") 1)
    (if debug
        (print "::: silo ::: objective control 020")
    )
    (set s_objcon_slo 20)
    (wake save_slo_move)
    (sleep_until (volume_test_players "tv_objcon_slo_030") 1)
    (if debug
        (print "::: silo ::: objective control 030")
    )
    (set s_objcon_slo 30)
    (game_save)
    (sleep_until (>= s_objcon_pmp 5))
    (silo_cleanup)
)

(script dormant void slo_save_start
    (sleep_until (>= (current_zone_set_fully_active) s_zone_index_fields))
    (sleep 90)
    (if debug
        (print "save silo start")
    )
    (game_save_no_timeout)
)

(script dormant void save_slo_move
    (branch (= b_fld_started true) (branch_abort))
    (game_save_no_timeout)
)

(script dormant void save_slo_grind
    (branch (= b_fld_started true) (branch_abort))
    (sleep_until (<= (ai_strength "gr_cov_slo") 0.5))
    (if debug
        (print "save silo grind")
    )
    (game_save_no_timeout)
)

(script dormant void slo_jun_main
    (if debug
        (print "::: silo ::: setting up unsc_jun...")
    )
    (ai_cannot_die "unsc_jun" true)
    (ai_set_objective "unsc_jun" "obj_unsc_slo")
)

(script dormant void slo_pose_bodies
    (pose_body "sc_slo_body_00" pose_against_wall_var1)
    (pose_body "sc_slo_body_01" pose_against_wall_var3)
    (pose_body "sc_slo_body_02" pose_on_side_var3)
    (sleep_until b_pmp_started)
    (object_destroy_folder "sc_slo_bodies")
)

(script static void silo_cleanup
    (if debug
        (print "::: silo ::: cleaning up encounter...")
    )
    (ai_disposable "gr_cov_slo" true)
    (object_destroy_folder "wp_slo")
    (object_destroy_folder "sc_slo")
    (sleep_forever silo_encounter)
)

(script dormant void slo_backup_control
    (sleep_until (> s_objcon_slo 10))
    (sleep_until (or (<= (ai_living_count "gr_cov_slo") 2) (>= s_objcon_slo 30)))
    (game_save)
    (ai_place "sq_cov_slo_backup0")
)

(script dormant void fld_encounter
    (if debug
        (print "::: fields ::: encounter start")
    )
    (data_mine_set_mission_segment "mule")
    (recycle_020)
    (object_create_folder "cr_fld")
    (object_create_folder "wp_fld")
    (object_create_folder "eq_fld")
    (object_create_folder "cr_fld_flares")
    (wake fld_jun_main)
    (wake fld_mule_main)
    (wake fld_mule_safezone_control)
    (ai_place "sq_cov_fld_ph0")
    (wake fld_mus05_stop)
    (mus_start mus_03)
    (mus_stop mus_02)
    (set b_fld_started true)
    (game_save)
    (game_insertion_point_unlock 1)
    (ai_erase "gr_cov_ovr")
    (sleep_until (volume_test_players "tv_objcon_fld_010") 1)
    (if debug
        (print "::: fields ::: objective control 010")
    )
    (set s_objcon_fld 10)
    (garbage_collect_now)
    (sleep_until (volume_test_players "tv_objcon_fld_020") 1)
    (if debug
        (print "::: fields ::: objective control 020")
    )
    (set s_objcon_fld 20)
    (wake chapter_title_mule)
    (game_save)
    (ai_place "sq_cov_fld_inf1")
    (wake fld_mule_vitality_control)
    (wake fld_infantry_low_control)
    (wake md_post_mule_convo)
    (soft_ceiling_enable "camera_blocker_03" false)
    (sleep_until (volume_test_players "tv_objcon_fld_030") 1)
    (if debug
        (print "::: fields ::: objective control 030")
    )
    (set s_objcon_fld 30)
    (fld_jun_failsafe)
    (wake md_fld_jun_mule_intro)
    (sleep_until (volume_test_players "tv_objcon_fld_040") 1)
    (if debug
        (print "::: fields ::: objective control 040")
    )
    (set s_objcon_fld 40)
    (mus_start mus_05)
    (bring_jun_forward 10)
    (sleep_until (volume_test_players "tv_objcon_fld_050") 1)
    (if debug
        (print "::: fields ::: objective control 050")
    )
    (set s_objcon_fld 50)
    (sleep_until (volume_test_players "tv_objcon_fld_060") 1)
    (if debug
        (print "::: fields ::: objective control 060")
    )
    (set s_objcon_fld 60)
    (sleep_until (>= s_objcon_pmp 20))
    (fld_cleanup)
)

(script dormant void fld_jun_main
    (if debug
        (print "::: pumpstation ::: setting up unsc_jun...")
    )
    (sleep 1)
    (set ai_jun "unsc_jun")
    (ai_set_objective "unsc_jun" "obj_unsc_fld")
    (ai_cannot_die "unsc_jun" true)
)

(script dormant void fld_mus05_stop
    (sleep_until (and (> (ai_spawn_count "gr_cov_fld") 0) (> (ai_spawn_count "sq_mule_fld") 0)))
    (sleep_until (and (<= (ai_living_count "gr_cov_fld") 0) (<= (ai_living_count "sq_mule_fld") 0)))
    (mus_stop mus_05)
)

(script static void fld_jun_failsafe
    (if (or (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_020) (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_025) (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_028))
        (if debug
            (print "jun is in a safe bsp, won't teleport him")
        )
        (object_teleport (ai_get_object ai_jun) "fl_jun_failsafe_fld")
    )
)

(script dormant void fld_mule_vitality_control
    (sleep_until 
        (begin
            (if debug
                (print "fld: pegging mule vitality...")
            )
            (unit_set_current_vitality (ai_get_unit "sq_mule_fld/low") 250 0)
            (unit_set_current_vitality (ai_get_unit "sq_mule_fld/high") 250 0)
            (sleep (* 30 10))
            (or (<= (ai_living_count "sq_mule_fld") 0) (= b_pmp_started true) (<= (ai_living_count "gr_cov_fld") 0))
        )
        1
        (* 30 90)
    )
    (if debug
        (print "fld: done pegging mule vitality...")
    )
)

(script dormant void fld_mule_main
    (ai_disregard (ai_actors "sq_cov_fld_ph0") true)
    (sleep_until (>= s_objcon_fld 20) 1)
    (ai_place "sq_mule_fld")
    (sleep 5)
    (ai_disregard (ai_actors "sq_cov_fld_ph0") true)
    (ai_disregard (ai_get_object "unsc_jun") true)
    (thespian_performance_setup_and_begin "p070_mule" "" 0)
    (ai_cannot_die "sq_mule_fld" true)
    (sleep_until (>= s_objcon_fld 40) 30 (* 30 20))
    (ai_cannot_die "sq_mule_fld" false)
)

(script dormant void fld_infantry_low_control
    (ai_place "sq_cov_fld_inf0")
    (ai_set_blind "sq_cov_fld_inf0" true)
    (sleep_until b_fld_mule_intro_complete 1 (* 30 15))
    (ai_set_blind "sq_cov_fld_inf0" false)
)

(script command_script void cs_fld_stand_in_place
    (cs_enable_targeting false)
    (sleep_forever)
)

(script dormant void fld_mule_safezone_control
    (branch (>= s_objcon_pmp 20) (branch_abort))
    (sleep_until 
        (begin
            (sleep_until (not (volume_test_players "tv_fld_mule_safezone")))
            (if debug
                (print "fld ::: player has left the safezone...")
            )
            (if (<= (ai_living_count "gr_cov_fld") 0)
                (begin
                    (cs_run_command_script "sq_mule_fld" cs_fld_mule_backoff)
                )
                (begin
                    (ai_set_targeting_group "gr_cov_fld" 10 true)
                    (ai_set_targeting_group "sq_mule_fld" 10 false)
                )
            )
            (sleep_until (volume_test_players "tv_fld_mule_safezone"))
            (if debug
                (print "fld ::: player has re-entered the safezone...")
            )
            (cs_run_command_script "sq_mule_fld" cs_exit)
            (ai_set_targeting_group "gr_cov_fld" 65535 true)
            (ai_set_targeting_group "sq_mule_fld" 65535 true)
            false
        )
        1
    )
)

(script command_script void cs_fld_mule_backoff
    (begin_random_count
        1
        (cs_go_to_and_face "pts_fields_mule/hide0" "pts_fields_mule/center")
        (cs_go_to_and_face "pts_fields_mule/hide1" "pts_fields_mule/center")
        (cs_go_to_and_face "pts_fields_mule/hide2" "pts_fields_mule/center")
    )
)

(script command_script void cs_fields_ds0_main
    (cs_enable_pathfinding_failsafe true)
    (if debug
        (print "::: fields phantom ::: holding...")
    )
    (cs_vehicle_speed 0.3)
    (cs_fly_by "pts_fields_ds0/entry0")
    (sleep 10)
    (cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_fields_ds0_turret_intro)
    (if debug
        (print "::: fields phantom ::: hovering...")
    )
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "pts_fields_ds0/hover" "pts_fields_ds0/facing" 0.25)
    (sleep_until (> (ai_living_count "sq_mule_fld") 0) 1)
    (sleep 1)
    (cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_fields_ds0_turret)
    (sleep_until (or (and (<= (ai_living_count "gr_cov_fld") 0) (<= (ai_living_count "sq_mule_fld") 0)) b_pmp_started (<= (unit_get_health (ai_get_turret_ai ai_current_actor 0)) 0)))
    (if debug
        (print "::: fields phantom ::: exiting...")
    )
    (cs_fly_by "pts_fields_ds0/exit0")
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_fields_ds0/erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_fields_ds0_turret_intro
    (sleep_until 
        (begin
            (if debug
                (print "aiming at light_target0")
            )
            (cs_aim true "pts_fields_mule/light_target0")
            (sleep (random_range 150 300))
            (if debug
                (print "aiming at light_target1")
            )
            (cs_aim true "pts_fields_mule/light_target1")
            (sleep (random_range 150 300))
            false
        )
    )
)

(script command_script void cs_fields_ds0_turret
    (print "turret active and tracking mules...")
    (sleep_until 
        (begin
            (if (> (object_get_health (ai_get_object "sq_mule_fld/low")) 0)
                (begin
                    (if debug
                        (print "aiming at fields_mule/low")
                    )
                    (cs_aim_object true (ai_get_object "sq_mule_fld/low"))
                    (sleep (random_range 150 300))
                )
            )
            (if (> (object_get_health (ai_get_object "sq_mule_fld/high")) 0)
                (begin
                    (if debug
                        (print "aiming at fields_mule/high")
                    )
                    (cs_aim_object true (ai_get_object "sq_mule_fld/high"))
                    (sleep (random_range 150 300))
                )
            )
            (= (ai_living_count "sq_mule_fld") 0)
        )
    )
    (sleep_forever)
)

(script dormant void md_post_mule_convo
    (sleep_until (or (>= s_objcon_pmp 5) (and (<= (ai_living_count "gr_cov_fld") 0) (<= (ai_living_count "sq_mule_fld") 0))) 1)
    (if (and (<= (ai_living_count "gr_cov_fld") 0) (<= (ai_living_count "sq_mule_fld") 0))
        (wake md_fld_jun_asks_kat_about_mule)
    )
)

(script static void fld_cleanup
    (if debug
        (print "::: fields ::: cleaning up the encounter...")
    )
    (ai_disposable "gr_cov_fld" true)
    (object_destroy_folder "cr_fld")
    (object_destroy_folder "wp_fld")
    (sleep_forever fld_encounter)
    (sleep_forever fld_mule_safezone_control)
)

(script dormant void pmp_encounter
    (if debug
        (print "::: pumpstation ::: encounter start")
    )
    (data_mine_set_mission_segment "pumpstation")
    (game_save)
    (recycle_025)
    (wake pmp_jun_main)
    (wake pmp_assault_main)
    (wake pmp_unsc_militia_spawn)
    (wake pmp_moa_spawn)
    (wake pmp_bird_control)
    (wake pmp_sniper_control)
    (wake md_pmp_jun_sees_militia)
    (wake save_pmp_intro_collapse)
    (mus_stop mus_05)
    (set b_pmp_started true)
    (ai_disregard (ai_actors ai_jun) false)
    (sleep_until (volume_test_players "tv_objcon_pmp_005") 1)
    (if debug
        (print "::: pumpstation ::: objective control 005")
    )
    (set s_objcon_pmp 5)
    (bring_jun_forward 22)
    (sleep_until (volume_test_players "tv_objcon_pmp_010") 1)
    (if debug
        (print "::: pumpstation ::: objective control 10")
    )
    (set s_objcon_pmp 10)
    (garbage_collect_now)
    (game_save)
    (wake md_pmp_jun_magnums)
    (ai_place "sq_cov_pmp_phantom_start")
    (ai_place "sq_cov_pmp_inf0")
    (ai_place "sq_cov_pmp_inf1")
    (ai_place "sq_cov_pmp_inf2")
    (object_create_folder "cr_pmp")
    (object_create_folder "wp_pmp")
    (object_create_folder "dm_pmp")
    (object_create_folder "sc_pmp")
    (wake pmp_pose_bodies)
    (soft_ceiling_enable "camera_blocker_04" false)
    (sleep_until (volume_test_players "tv_objcon_pmp_020") 1)
    (if debug
        (print "::: pumpstation ::: objective control 20")
    )
    (set s_objcon_pmp 20)
    (ai_erase "gr_cov_fld")
    (sleep_until (volume_test_players "tv_objcon_pmp_030") 1)
    (if debug
        (print "::: pumpstation ::: objective control 30")
    )
    (set s_objcon_pmp 30)
    (object_create_folder "cr_rvr_flares")
    (ai_bring_forward ai_jun 15)
    (ai_erase "gr_cov_slo")
    (ai_erase "gr_cov_fkv")
    (ai_erase "gr_cov_ovr")
    (sleep_until b_set_started)
    (pmp_cleanup)
)

(script dormant void save_pmp_intro_collapse
    (sleep_until (and (<= (ai_task_count "obj_cov_pmp/gate_initial_forward") 0) (>= s_objcon_pmp 30)))
    (game_save_no_timeout)
)

(script dormant void pmp_bird_control
    (sleep_until (or (<= (objects_distance_to_flag (ai_actors ai_jun) "fl_pmp_birds0") 5) (<= (objects_distance_to_flag player0 "fl_pmp_birds0") 5)))
    (if debug
        (print "birds!")
    )
    (flock_create "birds_pmp_01")
    (sleep (random_range 5 15))
    (flock_create "birds_pmp_02")
    (sleep (random_range 10 25))
    (flock_create "birds_pmp_03")
)

(script static void pmp_bird_kill
    (flock_delete "birds_pmp_01")
    (flock_delete "birds_pmp_02")
    (flock_create "birds_pmp_03")
)

(script dormant void pmp_pose_bodies
    (pose_body "sc_pmp_body_00" pose_face_down_var3)
    (pose_body "sc_pmp_body_01" pose_against_wall_var2)
    (pose_body "sc_pmp_body_02" pose_on_side_var2)
    (pose_body "sc_pmp_body_03" pose_face_down_var1)
    (pose_body "sc_pmp_body_04" pose_face_down_var1)
    (pose_body "sc_pmp_body_05" pose_against_wall_var1)
    (pose_body "sc_pmp_body_06" pose_against_wall_var3)
    (pose_body "sc_pmp_body_07" pose_against_wall_var2)
    (sleep_until b_set_started)
    (object_destroy_folder "sc_pmp_bodies")
)

(script dormant void pmp_jun_main
    (if debug
        (print "::: pumpstation ::: setting up unsc_jun...")
    )
    (sleep 10)
    (set ai_jun "unsc_jun")
    (ai_set_objective "unsc_jun" "obj_unsc_pmp")
    (ai_cannot_die "unsc_jun" true)
)

(script dormant void pmp_moa_spawn
    (ai_place "sq_amb_pmp_moas0")
    (sleep 10)
    (if debug
        (print "(ai_disregard (ai_actors sq_amb_pmp_moas0) true)")
    )
    (ai_disregard (ai_actors "sq_amb_pmp_moas0") true)
)

(script dormant void pmp_unsc_militia_spawn
    (sleep_until (>= s_objcon_pmp 10) 1)
    (if debug
        (print "::: pumpstation ::: spawning unsc security force...")
    )
    (ai_place "sq_unsc_pmp_militia0")
    (ai_place "sq_unsc_pmp_militia1")
    (wake pmp_militia_renew)
    (ai_magically_see "sq_unsc_pmp_militia0" "gr_cov_pmp")
    (ai_magically_see "gr_cov_pmp" "sq_unsc_pmp_militia0")
    (sleep_until (= b_pmp_assault_complete true))
    (f_unblip_ai "sq_unsc_pmp_militia0")
    (f_unblip_ai "sq_unsc_pmp_militia1")
    (f_unblip_ai "sq_unsc_pmp_militia2")
)

(script dormant void pmp_militia_renew
    (sleep_until 
        (begin
            (ai_renew "gr_militia")
            (sleep (* 30 5))
            b_rvr_started
        )
        1
    )
)

(script static void pmp_jun_failsafe
    (if (or (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_028) (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_030) (= (object_get_bsp (ai_get_object ai_jun)) s_bsp_index_035))
        (if debug
            (print "jun is in a safe bsp, won't teleport him")
        )
        (object_teleport (ai_get_object ai_jun) "fl_jun_failsafe_pmp")
    )
)

(script static void pmp_player_skips_encounter
    (if debug
        (print "pmp: player has skipped this encounter. killing a script...")
    )
    (ai_kill_silent "gr_militia")
    (f_unblip_ai "gr_militia")
    (mus_stop mus_06)
    (mus_stop mus_07)
)

(script dormant void pmp_sniper_control
    (if (and (difficulty_is_legendary) (>= (game_coop_player_count) 3))
        (begin
            (if debug
                (print "placing legendary 3+ sniper")
            )
            (sleep_until (= b_pmp_alpha_enroute true))
            (ai_place "sq_cov_pmp_creek_snipers0")
        )
    )
)

(script command_script void cs_pmp_snipers
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (cs_shoot true)
    (sleep_until (<= (ai_living_count "gr_cov_pmp") 1))
    (sleep (random_range 90 210))
    (cs_enable_moving false)
    (cs_enable_targeting false)
    (cs_shoot false)
    (cs_go_to "ps_pmp_snipers/erase")
    (ai_erase ai_current_actor)
)

(script dormant void pmp_player_stealth_control
    (sleep_until (>= s_objcon_pmp 10) 1)
    (ai_disregard (players) true)
    (ai_disregard (ai_get_object "unsc_jun") true)
    (sleep_until (>= s_objcon_pmp 30) 30 (* 30 25))
    (ai_disregard (players) false)
    (ai_disregard (ai_get_object "unsc_jun") false)
)

(script dormant void pmp_assault_main
    (branch (= b_pmp_player_skips_encounter true) (pmp_player_skips_encounter))
    (sleep_until (>= s_objcon_pmp 20) 1)
    (sleep_until (and (<= (ai_task_count "obj_cov_pmp/gate_initial") 0) (= b_pmp_start_dropship_delivered true)) 30 (* 30 600))
    (game_save)
    (wake pmp_counterattack_control)
    (if (> (ai_living_count "gr_militia") 0)
        (begin
            (cs_run_command_script ai_jun cs_pmp_stash_convo_jun)
            (cs_run_command_script "sq_unsc_pmp_militia0/militia0" cs_pmp_stash_convo_mil0)
            (cs_run_command_script "sq_unsc_pmp_militia0/militia1" cs_pmp_stash_convo_mil1)
            (cs_run_command_script "sq_unsc_pmp_militia1/militia0" cs_pmp_stash_convo_mil2)
            (cs_run_command_script "sq_unsc_pmp_militia1/militia1" cs_pmp_stash_convo_mil3)
            (sleep (random_range (* 30 6) (* 30 8)))
            (wake md_pmp_stash_convo)
            (sleep_until (= b_pmp_stash_convo_completed true) 30 (* 30 30))
        )
        (begin
            (set b_pmp_assault_start_dropships true)
            (sleep 30)
            (set b_pmp_stash_convo_completed true)
        )
    )
    (set b_pmp_assault_start_dropships true)
    (game_save)
    (sleep 30)
    (sleep_until (= b_pmp_assault_complete true))
    (if debug
        (print "::: pumpstation ::: assault complete...")
    )
    (ai_kill_silent "gr_cov_pmp_assault")
    (mus_stop mus_07)
    (pmp_postcombat_control)
)

(script dormant void pmp_counterattack_control
    (sleep_until b_pmp_assault_start_dropships)
    (sleep 120)
    (wake md_pmp_jun_dropship_control)
    (set b_pmp_assault_started true)
    (pmp_wave_lake)
    (game_save)
    (sleep_until (pmp_wave_road_should_spawn))
    (if debug
        (print "spawning road")
    )
    (pmp_wave_road)
    (game_save)
    (sleep_until (pmp_wave_creek_should_spawn))
    (if debug
        (print "spawning creek")
    )
    (pmp_wave_creek)
    (game_save)
    (sleep_until (<= (ai_task_count "obj_cov_pmp/gate_main") 0) 30 (* 30 600))
    (set b_pmp_assault_complete true)
)

(script static void pmp_wave_lake
    (ai_place "sq_cov_pmp_charlie_ds")
    (sleep_until (> (ai_living_count "gr_cov_pmp_lake") 0))
)

(script static boolean pmp_wave_lake_should_spawn
    (= 1 1)
)

(script static void pmp_wave_road
    (ai_place "sq_cov_pmp_bravo_ds")
    (sleep_until (> (ai_living_count "gr_cov_pmp_road") 0))
)

(script static boolean pmp_wave_road_should_spawn
    (and (> (ai_spawn_count "gr_cov_pmp_lake") 0) (= b_pmp_charlie_delivered true) (or (and (< (ai_strength "gr_cov_pmp_lake") 0.6) (<= (ai_living_count "sq_cov_pmp_lake_elites0") 1)) (< (ai_strength "gr_cov_pmp_lake") 0.35)))
)

(script static void pmp_wave_creek
    (ai_place "sq_cov_pmp_alpha_ds")
    (sleep_until (> (ai_living_count "gr_cov_pmp_creek") 0))
)

(script static boolean pmp_wave_creek_should_spawn
    (or (and (> (ai_spawn_count "gr_cov_pmp_road") 0) (> (ai_spawn_count "gr_cov_pmp_lake") 0) (< (ai_strength "gr_cov_pmp_road") 0.5) (< (ai_strength "gr_cov_pmp_lake") 0.5) (= b_pmp_bravo_delivered true)) (= 1 3))
)

(script static void pmp_postcombat_control
    (branch (= b_rvr_started true) (pmp_postcombat_abort))
    (if (> (ai_living_count "gr_militia") 0)
        (begin
            (if debug
                (print "::: beginning postencounter convo with militia...")
            )
            (cs_run_command_script ai_jun cs_pmp_post_convo_jun)
            (cs_run_command_script "sq_unsc_pmp_militia0/militia0" cs_pmp_post_convo_mil0)
            (cs_run_command_script "sq_unsc_pmp_militia0/militia1" cs_pmp_post_convo_mil1)
            (cs_run_command_script "sq_unsc_pmp_militia1/militia0" cs_pmp_post_convo_mil2)
            (cs_run_command_script "sq_unsc_pmp_militia1/militia1" cs_pmp_post_convo_mil3)
            (sleep (random_range (* 30 8) (* 30 10)))
            (wake md_pmp_jun_hydro_civs_alive)
            (sleep_until b_pmp_post_convo_completed (* 30 12))
            (wake pmp_exit_reminder)
            (print "post")
        )
        (begin
            (if debug
                (print "::: beginning postencounter convo without militia...")
            )
            (cs_run_command_script ai_jun cs_pmp_post_convo_jun_nomilitia)
            (sleep (random_range (* 30 3) (* 30 5)))
            (md_pmp_jun_hydro_civs_dead)
        )
    )
    (set b_pmp_post_convo_completed true)
    (set b_pmp_post_convo_active false)
    (wake show_objective_5)
    (mus_start mus_08)
    (game_save)
)

(script static void pmp_postcombat_abort
    (if debug
        (print "player has aborted the postcombat convo...")
    )
    (thespian_performance_kill_by_name "thespian_pmp_post")
    (set b_pmp_post_convo_completed true)
    (set b_pmp_post_convo_active false)
    (md_stop)
)

(script static boolean pmp_militia_should_hold_center
    (or (<= (ai_task_count "obj_unsc_pmp/gate_defense_low") 2) (and (> (ai_task_count "obj_cov_pmp/gate_lake") 0) (> (ai_task_count "obj_cov_pmp/gate_road") 0)))
)

(script command_script void cs_pmp_jun_canyon
    (cs_go_by "pts_jun_pumpstation/p0_l" "pts_jun_pumpstation/p0_r")
    (cs_go_by "pts_jun_pumpstation/p1_l" "pts_jun_pumpstation/p1_r")
    (cs_go_by "pts_jun_pumpstation/p2_l" "pts_jun_pumpstation/p2_r")
    (cs_go_by "pts_jun_pumpstation/p3_l" "pts_jun_pumpstation/p3_r")
    (cs_go_by "pts_jun_pumpstation/p4_l" "pts_jun_pumpstation/p4_r")
    (cs_go_by "pts_jun_pumpstation/p5_l" "pts_jun_pumpstation/p5_r")
    (cs_go_by "pts_jun_pumpstation/p6_l" "pts_jun_pumpstation/p6_r")
    (cs_go_by "pts_jun_pumpstation/p7_l" "pts_jun_pumpstation/p7_r")
)

(script static boolean pmp_militia_alive
    (> (ai_living_count "sq_unsc_pmp_militia0") 0)
)

(script command_script void cs_pmp_phantom_start
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_pmp_phantom_start/entry1")
    (f_load_phantom (ai_vehicle_get ai_current_actor) "right" "sq_cov_pmp_inf3" "sq_cov_pmp_inf4" none none)
    (cs_fly_by "pts_pmp_phantom_start/entry0")
    (cs_vehicle_speed 0.6)
    (cs_vehicle_boost false)
    (cs_fly_to "pts_pmp_phantom_start/hover")
    (sleep 45)
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_pmp_phantom_start/land" "pts_pmp_phantom_start/land_facing" 0.25)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
    (set b_pmp_start_dropship_delivered true)
    (sleep 30)
    (cs_fly_to_and_face "pts_pmp_phantom_start/land" "pts_pmp_phantom_start/hover" 0.25)
    (sleep 30)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "pts_pmp_phantom_start/exit0")
    (cs_fly_by "pts_pmp_phantom_start/exit1")
    (cs_fly_by "pts_pmp_phantom_start/erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_pmp_ds_alpha
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "dual" ai_pmp_creek_00 ai_pmp_creek_01 ai_pmp_creek_02 ai_pmp_creek_03)
    (add_recycling_volume "tv_030_recycle" 30 60)
    (cs_fly_by "pts_pmp_ds_alpha/entry2")
    (set b_pmp_alpha_enroute true)
    (cs_fly_by "pts_pmp_ds_alpha/entry1")
    (set b_pmp_alpha_enroute true)
    (cs_fly_by "pts_pmp_ds_alpha/entry0")
    (set s_pmp_assault_wave 1)
    (cs_vehicle_speed 0.4)
    (cs_vehicle_boost false)
    (cs_fly_to "pts_pmp_ds_alpha/hover")
    (cs_fly_to_and_face "pts_pmp_ds_alpha/land" "pts_pmp_ds_alpha/land_facing" 0.5)
    (sleep 30)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
    (set b_pmp_alpha_delivered true)
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_pmp_ds_alpha/hover" "pts_pmp_ds_alpha/exit0" 1)
    (sleep 45)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_pmp_ds_alpha/exit0")
    (cs_fly_by "pts_pmp_ds_alpha/exit1")
    (cs_fly_by "pts_pmp_ds_alpha/exit2")
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_pmp_ds_alpha/erase")
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_pmp_ds_bravo
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (add_recycling_volume "tv_030_recycle" 30 60)
    (cs_fly_by "pts_pmp_ds_bravo/entry2")
    (set b_pmp_bravo_enroute true)
    (cs_fly_by "pts_pmp_ds_bravo/entry1")
    (cs_vehicle_speed 0.6)
    (cs_vehicle_boost false)
    (cs_fly_by "pts_pmp_ds_bravo/entry0")
    (f_load_phantom (ai_vehicle_get ai_current_actor) "dual" ai_pmp_road_00 ai_pmp_road_01 ai_pmp_road_02 ai_pmp_road_03)
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_pmp_ds_bravo/land" "pts_pmp_ds_bravo/land_facing" 0.5)
    (sleep 30)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
    (set b_pmp_bravo_delivered true)
    (cs_vehicle_speed 0.5)
    (cs_fly_to "pts_pmp_ds_bravo/hover" 1)
    (set s_pmp_assault_wave 2)
    (sleep 30)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "pts_pmp_ds_bravo/exit0")
    (cs_fly_by "pts_pmp_ds_bravo/exit1")
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_pmp_ds_bravo/erase")
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_pmp_ds_charlie
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "right" ai_pmp_lake_00 ai_pmp_lake_01 ai_pmp_lake_02 ai_pmp_lake_03)
    (add_recycling_volume "tv_030_recycle" 30 60)
    (cs_fly_by "pts_pmp_ds_charlie/entry3")
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_pmp_ds_charlie/entry2")
    (set b_pmp_charlie_enroute true)
    (cs_fly_by "pts_pmp_ds_charlie/entry1")
    (cs_vehicle_speed 0.6)
    (cs_vehicle_boost false)
    (cs_fly_by "pts_pmp_ds_charlie/entry0")
    (cs_vehicle_speed 0.3)
    (set s_pmp_assault_wave 3)
    (cs_fly_to_and_face "pts_pmp_ds_charlie/land" "pts_pmp_ds_charlie/land_facing" 0.2)
    (game_save)
    (sleep 30)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
    (set b_pmp_charlie_delivered true)
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "pts_pmp_ds_charlie/hover" "pts_pmp_ds_charlie/exit0" 0.25)
    (sleep 10)
    (cs_vehicle_speed 0.5)
    (cs_fly_by "pts_pmp_ds_charlie/exit0")
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_pmp_ds_charlie/exit1")
    (cs_fly_by "pts_pmp_ds_charlie/erase")
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script static void pmp_ai_test
    (garbage_collect_unsafe)
    (object_create_folder "sc_pmp")
    (object_create_folder "cr_pmp")
    (wake pmp_militia_renew)
    (ai_place "sq_cov_pmp_bravo_ds")
    (ai_place "sq_unsc_pmp_militia0")
    (ai_place "sq_unsc_pmp_militia1")
    (ai_place "sq_unsc_pmp_militia2")
    (sleep_until (> (ai_living_count "gr_cov_pmp_road") 0))
    (sleep_until (< (ai_strength "gr_cov_pmp_road") 0.3))
    (wake pmp_save_wave1_complete)
    (ai_place "sq_cov_pmp_charlie_ds")
    (sleep_until (> (ai_living_count "gr_cov_pmp_lake") 0))
    (sleep_until (< (ai_strength "gr_cov_pmp") 0.3))
    (wake pmp_save_wave2_complete)
    (ai_place "sq_cov_pmp_alpha_ds")
)

(script dormant void pmp_save_wave1_complete
    (game_save_no_timeout)
)

(script dormant void pmp_save_wave2_complete
    (game_save_no_timeout)
)

(script dormant void pmp_save_wave3_complete
    (game_save_no_timeout)
)

(script static void pmp_props
    (object_create_folder "sc_pmp")
    (object_create_folder "cr_pmp")
)

(script dormant void pmp_exit_reminder
    (branch (= b_rvr_started true) (branch_abort_pmp_exit_reminder))
    (sleep (* 30 120))
    (if (not b_rvr_started)
        (f_blip_flag "fl_rvr_entrance" 21)
    )
)

(script static void branch_abort_pmp_exit_reminder
    (f_unblip_flag "fl_rvr_entrance")
)

(script static void pmp_cleanup
    (if debug
        (print "cleaning up the pumpstation encounter...")
    )
    (ai_erase "gr_cov_pmp")
    (object_destroy_folder "wp_pmp")
    (object_destroy_folder "cr_pmp")
    (object_destroy_folder "dm_pmp")
    (object_destroy_folder "c_pmp")
    (object_destroy_folder "sc_pmp")
    (sleep_forever pmp_encounter)
    (pmp_bird_kill)
    (f_unblip_object "dm_pmp_stash0")
    (f_unblip_object "dm_pmp_stash1")
)

(script dormant void rvr_encounter
    (if debug
        (print "::: river ::: encounter start")
    )
    (data_mine_set_mission_segment "river")
    (soft_ceiling_enable "camera_blocker_05" false)
    (game_save)
    (recycle_030)
    (if (difficulty_is_legendary)
        (object_create "loki")
    )
    (wake rvr_jun_main)
    (wake rvr_militia_main)
    (wake rvr_phantom_control)
    (ai_place "sq_amb_rvr_moas")
    (sleep 1)
    (ai_disregard (ai_actors "sq_amb_rvr_moas") true)
    (set b_rvr_started true)
    (ai_disposable "sq_amb_pmp_moas0" true)
    (f_unblip_ai "sq_unsc_pmp_militia0")
    (f_unblip_ai "sq_unsc_pmp_militia1")
    (f_unblip_flag "fl_rvr_entrance")
    (sleep_until (volume_test_players "tv_objcon_rvr_010") 1)
    (if debug
        (print "::: river objective control 010")
    )
    (set s_objcon_rvr 10)
    (f_unblip_flag "fl_rvr_entrance")
    (wake md_rvr_jun_settlement_history)
    (sleep_until (volume_test_players "tv_objcon_rvr_020") 1)
    (if debug
        (print "::: river objective control 020")
    )
    (set s_objcon_rvr 20)
    (garbage_collect_now)
    (sleep_until (volume_test_players "tv_objcon_rvr_030") 1)
    (if debug
        (print "::: river objective control 030")
    )
    (set s_objcon_rvr 30)
    (if (not b_pmp_assault_complete)
        (begin
            (set b_pmp_player_skips_encounter true)
            (object_teleport (ai_get_object ai_jun) "fl_rvr_jun_teleport")
            (f_unblip_ai "gr_militia")
        )
    )
    (ai_bring_forward (ai_get_object ai_jun) 15)
    (sleep_until (volume_test_players "tv_objcon_rvr_040") 1)
    (if debug
        (print "::: river objective control 040")
    )
    (set s_objcon_rvr 40)
    (sleep_until (volume_test_players "tv_objcon_rvr_050") 1)
    (if debug
        (print "::: river objective control 050")
    )
    (set s_objcon_rvr 50)
    (sleep_until (volume_test_players "tv_objcon_rvr_060") 1)
    (if debug
        (print "::: river objective control 060")
    )
    (set s_objcon_rvr 60)
    (ai_bring_forward (ai_get_object "gr_militia") 10)
    (ai_bring_forward (ai_get_object ai_jun) 6)
    (game_save)
    (sleep_until b_set_completed)
    (rvr_cleanup)
)

(script dormant void rvr_jun_main
    (if debug
        (print "::: river ::: setting up unsc_jun...")
    )
    (set ai_jun "unsc_jun")
    (ai_cannot_die "unsc_jun" true)
    (ai_set_objective "unsc_jun" "obj_unsc_rvr")
)

(script dormant void rvr_militia_main
    (if b_pmp_assault_complete
        (begin
            (if debug
                (print "::: river ::: setting up unsc_militia...")
            )
            (ai_set_objective "gr_militia" "obj_unsc_rvr")
            (ai_set_objective "fireteam_player0" "obj_unsc_rvr")
        )
    )
)

(script dormant void rvr_save_after_specops
    (sleep_until (f_ai_is_defeated "sq_cov_rvr_specops0"))
    (game_save)
)

(script command_script void cs_rvr_moas_flee
    (begin_random_count
        1
        (cs_go_by "pts_rvr_moas/p0_a" "pts_rvr_moas/p0_a")
        (cs_go_by "pts_rvr_moas/p0_b" "pts_rvr_moas/p0_b")
        (cs_go_by "pts_rvr_moas/p0_c" "pts_rvr_moas/p0_c")
    )
    (begin_random_count
        1
        (cs_go_by "pts_rvr_moas/p1_a" "pts_rvr_moas/p1_a")
        (cs_go_by "pts_rvr_moas/p1_b" "pts_rvr_moas/p1_b")
        (cs_go_by "pts_rvr_moas/p1_c" "pts_rvr_moas/p1_c")
    )
    (begin_random_count
        1
        (cs_go_by "pts_rvr_moas/p2_a" "pts_rvr_moas/p2_a")
        (cs_go_by "pts_rvr_moas/p2_b" "pts_rvr_moas/p2_b")
        (cs_go_by "pts_rvr_moas/p2_c" "pts_rvr_moas/p2_c")
    )
)

(script command_script void cs_rvr_phantom
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_rvr_phantom0/p1")
    (cs_fly_by "ps_rvr_phantom0/p2")
    (cs_fly_by "ps_rvr_phantom0/p3")
    (cs_fly_by "ps_rvr_phantom0/p4")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (cs_fly_by "ps_rvr_phantom0/erase")
    (ai_erase ai_current_squad)
)

(script dormant void rvr_phantom_control
    (sleep_until (>= s_objcon_rvr 30))
    (ai_place "sq_cov_rvr_phantom0")
    (wake md_jun_dropship_overhead_1)
    (sleep 30)
)

(script static void rvr_cleanup
    (if debug
        (print "::: river ::: cleaning up the encounter...")
    )
    (ai_disposable "gr_cov_river" true)
    (ai_disposable "sq_amb_pmp_moas0" true)
    (sleep_forever rvr_encounter)
)

(script dormant void set_encounter
    (if debug
        (print "::: settlement ::: encounter start")
    )
    (data_mine_set_mission_segment "settlement")
    (garbage_collect_now)
    (object_create_folder "cr_set")
    (object_create_folder "wp_set")
    (object_create_folder "sc_set")
    (object_create_folder "v_set")
    (object_create_folder "eq_set")
    (set ai_to_deafen "gr_cov_set")
    (wake set_militia_main)
    (wake set_unsc_jun)
    (wake set_assault)
    (wake set_defense)
    (wake set_bridge_flank_control)
    (wake md_set_jun_kat_you_seeing)
    (wake set_save_bridge)
    (wake set_save_hill_dead)
    (wake set_save_initial_dead)
    (wake set_save_left)
    (set_pose_bodies)
    (sleep_until (= (current_zone_set_fully_active) 5))
    (ai_place "sq_cov_set_pylon_gunners0")
    (ai_place "sq_cov_set_officer0")
    (ai_place "sq_cov_set_left_grunts0")
    (ai_place "sq_cov_set_left_grunts1")
    (ai_place "sq_cov_set_skirmishers0")
    (ai_place "sq_cov_set_bridge_elite0")
    (ai_place "sq_cov_set_bridge_grunts0")
    (ai_place "sq_cov_set_hill0")
    (set b_set_started true)
    (game_insertion_point_unlock 2)
    (ai_disposable "sq_amb_rvr_moas" true)
    (sleep_until (volume_test_players "tv_objcon_set_005") 1)
    (if debug
        (print "::: settlement ::: objective control 005")
    )
    (set s_objcon_set 5)
    (soft_ceiling_enable "camera_blocker_06" false)
    (wake chapter_title_settlement)
    (bring_jun_forward 15)
    (sleep_until (volume_test_players "tv_objcon_set_010") 1)
    (if debug
        (print "::: settlement ::: objective control 010")
    )
    (set s_objcon_set 10)
    (if (not (difficulty_is_legendary))
        (thespian_performance_setup_and_begin "thespian_set_elites" "" 0)
    )
    (sleep_until (volume_test_players "tv_objcon_set_012") 1)
    (if debug
        (print "::: settlement ::: objective control 012")
    )
    (set s_objcon_set 12)
    (sleep_until (volume_test_players "tv_objcon_set_015") 1)
    (if debug
        (print "::: settlement ::: objective control 015")
    )
    (set s_objcon_set 15)
    (sleep_until (volume_test_players "tv_objcon_set_018") 1)
    (if debug
        (print "::: settlement ::: objective control 018")
    )
    (set s_objcon_set 18)
    (sleep_until (volume_test_players "tv_objcon_set_020") 1)
    (if debug
        (print "::: settlement ::: objective control 020")
    )
    (set s_objcon_set 20)
    (sleep_until (volume_test_players "tv_objcon_set_030") 1)
    (if debug
        (print "::: settlement ::: objective control 030")
    )
    (set s_objcon_set 30)
    (sleep_until (volume_test_players "tv_objcon_set_040") 1)
    (if debug
        (print "::: settlement ::: objective control 040")
    )
    (set s_objcon_set 40)
    (sleep_until b_clf_started)
    (set_cleanup)
)

(script dormant void set_save_bridge
    (branch (= b_clf_started true) (branch_abort))
    (sleep_until (>= s_objcon_set 40))
    (if debug
        (print "saving crossing bridge")
    )
    (game_save_no_timeout)
)

(script dormant void set_save_hill_dead
    (branch (= b_clf_started true) (branch_abort))
    (sleep_until (> (ai_spawn_count "sq_cov_set_hill0") 0))
    (sleep_until (<= (ai_living_count "sq_cov_set_hill0") 0))
    (if debug
        (print "saving hill")
    )
    (game_save_no_timeout)
)

(script dormant void set_save_initial_dead
    (branch (= b_clf_started true) (branch_abort))
    (sleep_until (and (<= (ai_living_count "sq_cov_set_hill0") 0) (<= (ai_living_count "sq_cov_set_pylon_gunners0") 0) (<= (ai_living_count "sq_cov_set_officer0") 0) (<= (ai_living_count "sq_cov_set_left_grunts0") 0) (<= (ai_living_count "sq_cov_set_left_grunts1") 0) (<= (ai_living_count "sq_cov_set_skirmishers0") 0) (<= (ai_living_count "sq_cov_set_bridge_elite0") 0) (<= (ai_living_count "sq_cov_set_bridge_grunts0") 0) (<= (ai_living_count "sq_cov_set_hill0") 0)))
    (if debug
        (print "saving initial_dead")
    )
    (game_save_no_timeout)
)

(script dormant void set_save_left
    (branch (= b_clf_started true) (branch_abort))
    (sleep_until (and (<= (ai_living_count "sq_cov_set_officer0") 0) (<= (ai_living_count "sq_cov_set_left_grunts0") 0) (<= (ai_living_count "sq_cov_set_left_grunts1") 0)))
    (if debug
        (print "saving left dead")
    )
    (game_save_no_timeout)
)

(script dormant void set_militia_main
    (if debug
        (print "::: settlement ::: setting up unsc_militia...")
    )
    (ai_set_objective "gr_militia" "obj_unsc_set")
    (ai_set_objective "fireteam_player0" "obj_unsc_set")
)

(script dormant void set_unsc_jun
    (if debug
        (print "::: settlement ::: setting up unsc_jun")
    )
    (set ai_jun "unsc_jun")
    (ai_set_objective "unsc_jun" "obj_unsc_set")
    (ai_cannot_die "unsc_jun" true)
)

(script static void set_pose_bodies
    (pose_body "sc_set_body_00" pose_against_wall_var1)
    (pose_body "sc_set_body_01" pose_face_down_var1)
    (pose_body "sc_set_body_02" pose_on_back_var3)
    (pose_body "sc_set_body_03" pose_against_wall_var3)
    (pose_body "sc_set_body_04" pose_on_side_var3)
    (pose_body "sc_set_body_05" pose_on_side_var5)
    (pose_body "sc_set_body_06" pose_against_wall_var2)
    (pose_body "sc_set_body_07" pose_face_down_var2)
    (pose_body "sc_set_body_08" pose_on_side_var2)
    (pose_body "sc_set_body_09" pose_on_back_var1)
    (pose_body "sc_set_body_10" pose_against_wall_var4)
    (pose_body "sc_set_body_11" pose_face_down_var3)
)

(script command_script void cs_set_bridge_patrol
    (cs_push_stance "patrol")
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_walk true)
    (cs_stow true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_go_to "pts_settlement_patrols/p15")
                    (sleep (random_range 160 450))
                )
                (begin
                    (cs_go_to "pts_settlement_patrols/p16")
                    (sleep (random_range 160 450))
                )
                (begin
                    (cs_go_to "pts_settlement_patrols/p17")
                    (sleep (random_range 160 450))
                )
            )
            false
        )
        1
    )
)

(script dormant void set_bridge_flank_control
    (sleep_until (> (ai_combat_status "gr_cov_set") 3) 1)
    (sleep_until (>= s_objcon_set 20) 30 (* 30 25))
    (if (>= (ai_living_count "gr_cov_set_bridge") 2)
        (set b_set_bridge_should_flank true)
    )
)

(script dormant void set_assault
    (if debug
        (print "::: settlement ::: starting assault...")
    )
    (sleep_until (> (ai_task_count "obj_cov_set/gate_main") 0))
    (sleep_until (< (ai_strength "gr_cov_set") 0.35))
    (game_save)
    (set b_set_player_front true)
    (sleep_until (< (ai_strength "gr_cov_set") 0.1))
    (set b_set_defense_start true)
    (add_recycling_volume_by_type "tv_040_recycle" 4 45 1)
)

(script dormant void set_defense
    (sleep_until b_set_defense_start)
    (if debug
        (print "::: settlement ::: starting defense...")
    )
    (md_set_jun_cover_me)
    (game_save)
    (sleep 30)
    (f_blip_flag "fl_set_defend" blip_defend)
    (cs_run_command_script ai_jun cs_set_jun_go_to_plant)
    (thespian_performance_setup_and_begin "p120_set_jun_plant" "" 0)
    (sleep (random_range 150 300))
    (ai_place "sq_cov_set_phantom0")
    (if (or (game_is_cooperative) (difficulty_is_heroic_or_higher))
        (begin
            (set b_set_second_dropship true)
            (ai_place "sq_cov_set_ds1")
        )
    )
    (sleep 1)
    (sleep_until b_set_hunters_delivered)
    (if b_set_second_dropship
        (sleep_until (> (ai_spawn_count "gr_cov_set_specops") 0))
    )
    (sleep 60)
    (sleep_until (<= (ai_living_count "gr_cov_set") 0) 30 (* 30 360))
    (f_unblip_flag "fl_set_defend")
    (thespian_performance_kill_by_name "p120_set_jun_plant")
    (sleep 120)
    (md_set_jun_charge_placed)
    (set b_set_completed true)
    (set b_set_gate_open true)
)

(script command_script void cs_set_jun_go_to_plant
    (cs_go_to "pts_p120/plant_start")
)

(script command_script void cs_cov_set_ds0
    (cs_ignore_obstacles true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (cs_fly_by "pts_set_ds0/entry1")
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_set_ds0/entry0")
    (cs_vehicle_speed 0.4)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "left" "sq_cov_set_hunters0/hunter0" "sq_cov_set_hunters1/hunter0" none none)
    (cs_fly_to "pts_set_ds0/hover" 0.25)
    (sleep 30)
    (cs_vehicle_speed 0.25)
    (cs_fly_to_and_face "pts_set_ds0/land" "pts_set_ds0/land_facing" 0.25)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "left")
    (set b_set_hunters_delivered true)
    (sleep 60)
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_set_ds0/hover" "pts_set_ds0/exit0" 0.25)
    (sleep 30)
    (cs_vehicle_speed 0.6)
    (cs_fly_by "pts_set_ds0/exit0")
    (cs_vehicle_speed 1)
    (cs_fly_by "pts_set_ds0/exit1")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 7))
    (cs_fly_by "pts_set_ds0/erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_cov_set_ds1
    (if debug
        (print "phantom2 payload en route...")
    )
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 150)
    (if (game_is_cooperative)
        (begin
            (if debug
                (print "dropping full squad of specops")
            )
            (f_load_phantom (ai_vehicle_get ai_current_actor) "right" "sq_cov_set_specops0" "sq_cov_set_specops1" none none)
        )
        (begin
            (if debug
                (print "dropping half squad of specops")
            )
            (f_load_phantom (ai_vehicle_get ai_current_actor) "right" "sq_cov_set_specops0" none none none)
        )
    )
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "ps_set_ds1/entry2")
    (cs_vehicle_speed 0.6)
    (cs_fly_by "ps_set_ds1/entry1")
    (cs_vehicle_speed 0.5)
    (cs_fly_by "ps_set_ds1/entry0")
    (cs_vehicle_boost false)
    (cs_vehicle_speed 0.4)
    (cs_fly_to "ps_set_ds1/hover" 0.25)
    (sleep 30)
    (cs_fly_to_and_face "ps_set_ds1/land" "ps_set_ds1/land_facing" 0.25)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
    (sleep 30)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_set_ds1/hover" "ps_set_ds1/land_facing" 0.25)
    (sleep 30)
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_set_ds1/exit0")
    (cs_fly_by "ps_set_ds1/exit1")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (cs_fly_by "ps_set_ds1/erase")
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script static void set_cleanup
    (if debug
        (print "::: settlement ::: cleaning up the encounter...")
    )
    (ai_disposable "gr_cov_set" true)
    (sleep_forever set_encounter)
)

(script static void set_teleport_jun
    (ai_teleport "unsc_jun" "pts_settlement_teleports/jun")
)

(script dormant void clf_encounter
    (if debug
        (print "::: cliffside encounter :::")
    )
    (data_mine_set_mission_segment "cliffside")
    (game_save)
    (garbage_collect_now)
    (object_create_folder "cr_clf")
    (object_create_folder "sc_clf")
    (object_create_folder "wp_clf")
    (object_create_folder "c_clf")
    (object_create_folder "dm_clf")
    (object_create_folder "eq_clf")
    (object_destroy_folder "cr_rvr_flares")
    (object_create_folder "sc_staging")
    (wake clf_jun_main)
    (wake clf_militia_main)
    (wake clf_banshee_flock_control)
    (wake clf_gate_sequence)
    (wake clf_music_control)
    (wake save_clf_road_defeated)
    (wake save_clf_center_defeated)
    (wake save_clf_nest_defeated)
    (wake save_clf_final_defeated)
    (wake save_clf_objcon_050)
    (wake clf_garbage_loop)
    (clf_pose_bodies)
    (set b_clf_started true)
    (ai_place "sq_cov_clf_road_ds0")
    (ai_set_objective "gr_militia" "obj_unsc_clf")
    (ai_set_objective "unsc_jun" "obj_unsc_clf")
    (sleep_until (volume_test_players "tv_objcon_clf_010") 1)
    (if debug
        (print "::: cliffside ::: objective control 010")
    )
    (set s_objcon_clf 10)
    (sleep_until (volume_test_players "tv_objcon_clf_020") 1)
    (if debug
        (print "::: cliffside ::: objective control 020")
    )
    (set s_objcon_clf 20)
    (garbage_collect_now)
    (sleep_until (volume_test_players "tv_objcon_clf_030") 1)
    (if debug
        (print "::: cliffside ::: objective control 030")
    )
    (set s_objcon_clf 30)
    (ai_place "sq_cov_clf_center_rocks0")
    (ai_place "sq_cov_clf_center_shade0")
    (ai_place "sq_cov_clf_center_inf0")
    (soft_ceiling_enable "camera_blocker_07" false)
    (sleep_until (volume_test_players "tv_objcon_clf_040") 1)
    (if debug
        (print "::: cliffside ::: objective control 040")
    )
    (set s_objcon_clf 40)
    (sleep_until (volume_test_players "tv_objcon_clf_050") 1)
    (if debug
        (print "::: cliffside ::: objective control 050")
    )
    (set s_objcon_clf 50)
    (sleep_until (volume_test_players "tv_objcon_clf_060") 1)
    (if debug
        (print "::: cliffside ::: objective control 060")
    )
    (set s_objcon_clf 60)
    (sleep_until (volume_test_players "tv_objcon_clf_070") 1)
    (if debug
        (print "::: cliffside ::: objective control 070")
    )
    (set s_objcon_clf 70)
    (sleep_until (volume_test_players "tv_objcon_clf_080") 1)
    (if debug
        (print "::: cliffside ::: objective control 080")
    )
    (set s_objcon_clf 80)
    (wake md_clf_jun_shade)
    (sleep_until (volume_test_players "tv_objcon_clf_090") 1)
    (if debug
        (print "::: cliffside ::: objective control 090")
    )
    (set s_objcon_clf 90)
    (add_recycling_volume_by_type "tv_045_recycle" 5 15 1)
    (wake md_clf_jun_lotta_air_traffic)
    (sleep_until (volume_test_players "tv_objcon_clf_100") 1)
    (if debug
        (print "::: cliffside ::: objective control 100")
    )
    (set s_objcon_clf 100)
    (wake clf_mus11_stop)
    (ai_place "gr_cov_clf_final")
    (ai_place "sq_cov_clf_nest_elite0")
    (ai_place "sq_cov_clf_nest_elite1")
    (ai_place "sq_cov_clf_nest_jackals0")
    (ai_place "sq_cov_clf_nest_shade0")
    (sleep_until (volume_test_players "tv_objcon_clf_110") 1)
    (if debug
        (print "::: cliffside ::: objective control 110")
    )
    (set s_objcon_clf 110)
    (if (game_is_cooperative)
        (begin
            (ai_place "sq_cov_clf_jetpacks0")
        )
        (begin
            (if (difficulty_is_heroic)
                (ai_place "sq_cov_clf_jetpacks0" 1)
            )
            (if (difficulty_is_legendary)
                (ai_place "sq_cov_clf_jetpacks0" 2)
            )
        )
    )
    (sleep_until (volume_test_players "tv_objcon_clf_120") 1)
    (if debug
        (print "::: cliffside ::: objective control 120")
    )
    (set s_objcon_clf 120)
    (sleep_until (volume_test_players "tv_objcon_clf_130") 1)
    (if debug
        (print "::: cliffside ::: objective control 130")
    )
    (set s_objcon_clf 130)
    (ai_place "sq_cov_clf_overlook_inf0")
    (ai_place "sq_cov_clf_overlook_inf1")
    (sleep_until (volume_test_players "tv_objcon_clf_140") 1)
    (if debug
        (print "::: cliffside ::: objective control 140")
    )
    (set s_objcon_clf 140)
    (mus_stop mus_11)
    (wake md_clf_jun_eyes_on_capital_ship)
    (sleep_until (volume_test_players "tv_objcon_clf_145") 1)
    (if debug
        (print "::: cliffside ::: objective control 145")
    )
    (set s_objcon_clf 145)
    (mus_start mus_12)
    (sleep_until (volume_test_players "tv_objcon_clf_150") 1)
    (if debug
        (print "::: cliffside ::: objective control 150")
    )
    (set s_objcon_clf 150)
    (wake clf_exit_helper)
    (sleep_until b_mission_complete)
    (clf_cleanup)
)

(script dormant void clf_garbage_loop
    (sleep_until 
        (begin
            (add_recycling_volume "tv_045_recycle" 10 45)
            (sleep (* 30 60))
            false
        )
        1
    )
)

(script dormant void clf_mus11_stop
    (sleep_until (> (ai_spawn_count "gr_cov_clf_final") 0))
    (sleep 30)
    (sleep_until (<= (ai_strength "gr_cov_clf_final") 0.35))
    (if debug
        (print "stopping mus 11")
    )
    (mus_stop mus_11)
)

(script dormant void save_clf_center_defeated
    (sleep_until (> (ai_spawn_count "gr_cov_clf_center") 0))
    (sleep_until (<= (ai_living_count "gr_cov_clf_center") 0))
    (game_save_no_timeout)
)

(script dormant void save_clf_road_defeated
    (sleep_until (> (ai_spawn_count "sq_cov_clf_road_inf0") 0))
    (sleep_until (<= (ai_living_count "sq_cov_clf_road_inf0") 0))
    (game_save_no_timeout)
)

(script dormant void save_clf_nest_defeated
    (sleep_until (> (ai_spawn_count "gr_cov_clf_nest") 0))
    (sleep_until (<= (ai_living_count "gr_cov_clf_nest") 0))
    (game_save_no_timeout)
)

(script dormant void save_clf_final_defeated
    (sleep_until (> (ai_spawn_count "gr_cov_clf_final") 0))
    (sleep_until (<= (ai_living_count "gr_cov_clf_final") 0))
    (game_save_no_timeout)
)

(script dormant void save_clf_objcon_050
    (sleep_until (>= s_objcon_clf 50))
    (game_save_no_timeout)
)

(script dormant void clf_jun_main
    (if debug
        (print "::: cliffside ::: setting up unsc_jun...")
    )
    (set ai_jun "unsc_jun")
    (ai_cannot_die "unsc_jun" true)
    (ai_set_objective "unsc_jun" "obj_unsc_clf")
)

(script dormant void clf_militia_main
    (if debug
        (print "::: cliffside ::: setting up unsc_militia...")
    )
    (ai_set_objective "gr_militia" "obj_unsc_clf")
    (ai_set_objective "fireteam_player0" "obj_unsc_clf")
)

(script dormant void clf_gate_sequence
    (if debug
        (print "clf: opening gate...")
    )
    (md_clf_jun_gate)
    (sleep_until b_clf_gate_opened 30 (* 30 40))
    (f_unblip_flag "fl_clf_gate")
    (switch_zone_set "set_cliffside_035_040_045")
    (device_set_power "gate" 1)
    (device_set_position "gate" 1)
    (sleep_until (>= (current_zone_set_fully_active) s_zone_index_cliffside))
    (sleep 90)
    (game_save_no_timeout)
)

(script dormant void clf_music_control
    (sleep_until (>= s_objcon_clf 130))
    (sleep_until (<= (ai_living_count "gr_cov_clf") 0))
    (mus_stop mus_11)
)

(script static void clf_pose_bodies
    (pose_body "sc_clf_body_00" pose_against_wall_var1)
    (pose_body "sc_clf_body_01" pose_face_down_var1)
    (pose_body "sc_clf_body_02" pose_against_wall_var4)
    (pose_body "sc_clf_body_03" pose_on_side_var3)
    (pose_body "sc_clf_body_04" pose_on_side_var3)
    (pose_body "sc_clf_body_05" pose_on_side_var5)
    (pose_body "sc_clf_body_06" pose_against_wall_var2)
    (pose_body "sc_clf_body_07" pose_on_side_var1)
    (pose_body "sc_clf_body_08" pose_on_side_var2)
    (pose_body "sc_clf_body_09" pose_on_back_var1)
    (pose_body "sc_clf_body_10" pose_against_wall_var4)
    (pose_body "sc_clf_body_11" pose_face_down_var3)
    (pose_body "sc_clf_body_12" pose_face_down_var3)
)

(script static void branch_kill_vignette
    (if debug
        (print "killing vignette...")
    )
)

(script dormant void clf_banshee_flock_control
    (sleep_until (>= s_objcon_clf 70))
    (set b_cliffside_banshees_overhead true)
)

(script dormant void clf_exit_helper
    (sleep_until (not (volume_test_players "tv_clf_exit_helper")))
    (md_clf_jun_cave_ahead)
    (f_blip_flag "fl_clf_exit" blip_destination)
)

(script dormant void clf_airtraffic_control
    (branch (= b_mission_complete true) (branch_abort))
    (sleep_until 
        (begin
            (if (<= (ai_living_count "sq_cov_clf_airtraffic0") 6)
                (ai_place "sq_cov_clf_airtraffic0")
            )
            (sleep (random_range 60 90))
            false
        )
        1
    )
)

(script command_script void cs_fkv_airtraffic0
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (object_ignores_emp (ai_vehicle_get ai_current_actor) true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_clf_airtraffic/air0_0")
    (cs_fly_by "ps_clf_airtraffic/air0_1")
    (cs_fly_by "ps_clf_airtraffic/air0_erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_fkv_airtraffic1
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (object_ignores_emp (ai_vehicle_get ai_current_actor) true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_clf_airtraffic/air1_0")
    (cs_fly_by "ps_clf_airtraffic/air1_1")
    (cs_fly_by "ps_clf_airtraffic/air1_erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_fkv_airtraffic2
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (object_ignores_emp (ai_vehicle_get ai_current_actor) true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_clf_airtraffic/air2_0")
    (cs_fly_by "ps_clf_airtraffic/air2_1")
    (cs_fly_by "ps_clf_airtraffic/air2_erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_fkv_airtraffic3
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (object_ignores_emp (ai_vehicle_get ai_current_actor) true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_clf_airtraffic/air3_0")
    (cs_fly_by "ps_clf_airtraffic/air3_1")
    (cs_fly_by "ps_clf_airtraffic/air3_erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script void cs_fkv_airtraffic4
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (object_ignores_emp (ai_vehicle_get ai_current_actor) true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 60)
    (cs_fly_by "ps_clf_airtraffic/air4_0")
    (cs_fly_by "ps_clf_airtraffic/air4_1")
    (cs_fly_by "ps_clf_airtraffic/air4_erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 120)
    (object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant void clf_overlook_spawn
    (sleep_until (>= s_objcon_clf 130))
    (if debug
        (print "spawning overlook crew...")
    )
    (ai_place "sq_cov_clf_overlook_inf0")
    (ai_place "sq_cov_clf_overlook_inf1")
)

(script dormant void clf_skirmishers_spawn
    (sleep_until (or (and (f_ai_is_partially_defeated "gr_cov_clf_mid" 3) (<= s_objcon_clf 120)) (>= s_objcon_clf 130) (f_ai_is_partially_defeated "gr_cov_clf_mid" 1)))
    (if debug
        (print "spawning skirmishers...")
    )
    (ai_place "sq_cov_clf_skirmishers")
    (sleep_until (f_ai_is_defeated "sq_cov_clf_skirmishers"))
    (game_save)
)

(script command_script void cs_cliffside_road_ds0
    (cs_enable_pathfinding_failsafe true)
    (object_cannot_die (ai_vehicle_get ai_current_actor) true)
    (cs_vehicle_speed 0.5)
    (cs_ignore_obstacles true)
    (cs_vehicle_boost false)
    (f_load_phantom (ai_vehicle_get_from_starting_location "sq_cov_clf_road_ds0/pilot") "left" "sq_cov_clf_road_inf0" none none none)
    (sleep_until (> (device_get_position "gate") 0))
    (cs_fly_to_and_face "pts_cliffside_road_ds0/land" "pts_cliffside_road_ds0/land_facing" 0.35)
    (wake md_clf_jun_phantom_too_close)
    (sleep 30)
    (f_unload_phantom (ai_vehicle_get_from_starting_location "sq_cov_clf_road_ds0/pilot") "left")
    (set b_cliffside_road_dropoff true)
    (cs_fly_to_and_face "pts_cliffside_road_ds0/hover" "pts_cliffside_road_ds0/land_facing")
    (sleep 60)
    (cs_fly_by "pts_cliffside_road_ds0/exit0")
    (cs_fly_by "pts_cliffside_road_ds0/exit1")
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_cliffside_road_ds0/erase")
    (ai_erase ai_current_squad)
)

(script command_script void cs_cliffside_overlook_ds0
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 0.9)
    (cs_vehicle_boost false)
    (f_load_phantom (ai_vehicle_get_from_starting_location "sq_cov_clf_overlook_ds0/pilot") "left" "sq_cov_clf_overlook_ds0_inf0" none none "sq_cov_clf_overlook_ds0_inf1")
    (cs_fly_by "pts_cliffside_overlook_ds0/entry1")
    (cs_fly_by "pts_cliffside_overlook_ds0/entry0")
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_cliffside_overlook_ds0/land" "pts_cliffside_overlook_ds0/land_facing" 0.3)
    (sleep 30)
    (f_unload_phantom (ai_vehicle_get_from_starting_location "sq_cov_clf_overlook_ds0/pilot") "left")
    (cs_fly_to_and_face "pts_cliffside_overlook_ds0/hover" "pts_cliffside_overlook_ds0/land_facing")
    (sleep 60)
    (cs_vehicle_speed 1)
    (cs_vehicle_boost true)
    (ai_erase ai_current_squad)
)

(script static void clf_cleanup
    (if debug
        (print "cleaning up the cliffside encounter...")
    )
    (ai_erase "gr_cov_clf")
    (sleep_forever clf_encounter)
)

(script static void countdown
    (sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep" none 1)
    (if debug
        (print "::: 3 :::")
    )
    (sleep 30)
    (sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep" none 1)
    (if debug
        (print "::: 2 :::")
    )
    (sleep 30)
    (sound_impulse_start "sound\game_sfx\multiplayer\player_timer_beep" none 1)
    (if debug
        (print "::: 1 :::")
    )
    (sleep 30)
    (sound_impulse_start "sound\game_sfx\multiplayer\countdown_timer" none 1)
    (if debug
        (print "::: 0 :::")
    )
)

(script static void kill_script
    (if debug
        (print "*** script has been killed via branch condition ***")
    )
)

(script static void fireteam_setup
    (if debug
        (print "::: global ::: setting up fireteams...")
    )
    (ai_player_add_fireteam_squad player0 "fireteam_player0")
    (ai_player_set_fireteam_max player0 4)
    (ai_player_set_fireteam_max_squad_absorb_distance player0 6)
)

(script static boolean difficulty_is_heroic_or_higher
    (or (= (game_difficulty_get) heroic) (= (game_difficulty_get) legendary))
)

(script static boolean difficulty_is_easy
    (= (game_difficulty_get) easy)
)

(script static boolean difficulty_is_normal
    (= (game_difficulty_get) normal)
)

(script static boolean difficulty_is_heroic
    (= (game_difficulty_get) heroic)
)

(script static boolean difficulty_is_legendary
    (= (game_difficulty_get) legendary)
)

(script static boolean difficulty_is_easy_or_normal
    (or (= (game_difficulty_get) easy) (= (game_difficulty_get) normal))
)

(script static void (bring_jun_forward (real dist))
    (ai_bring_forward (ai_get_object ai_jun) dist)
)

(script static void branch_abort
    (if debug
        (print "branch aborting")
    )
)

(script static void show_staging
    (if debug
        (print "showing all staging area props...")
    )
    (object_create_folder "sc_staging")
)

(script static boolean player_has_sniper_rifle
    (unit_has_weapon (player0) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
)

(script command_script void cs_exit
    (if debug
        (print "cs_exit")
    )
)

(script command_script void cs_disable_movement
    (cs_enable_moving false)
)

(script command_script void cs_drawweapon
    (cs_stow false)
)

(script command_script void cs_abortactivity
    (ai_activity_abort ai_current_actor)
)

(script static boolean (ai_exists (ai group))
    (> (ai_living_count group) 0)
)

(script command_script void cs_kill_silent
    (ai_kill_silent ai_current_actor)
)

(script static void set_jun_invisible
    (if debug
        (print "jun is now invisible to ai")
    )
    (ai_disregard (ai_actors "unsc_jun") true)
    (ai_suppress_combat "unsc_jun" true)
)

(script static void set_jun_visible
    (if debug
        (print "jun is now visible to ai")
    )
    (ai_disregard (ai_actors "unsc_jun") false)
    (ai_suppress_combat "unsc_jun" false)
)

(script static boolean (ai_is_alert (ai actors))
    (> (ai_combat_status actors) 3)
)

(script static boolean angry_halo
    (ai_allegiance_broken human player)
)

(script static void tick
    (sleep 1)
)

(script static void eval
    (if (= b_evaluate false)
        (begin
            (set ai_render_evaluations true)
            (set ai_render_evaluations_detailed true)
            (set ai_render_evaluations_text true)
            (set ai_render_firing_position_statistics true)
            (set ai_render_decisions true)
            (set ai_render_behavior_stack true)
            (set b_evaluate true)
        )
        (begin
            (set ai_render_evaluations false)
            (set ai_render_evaluations_detailed false)
            (set ai_render_evaluations_text false)
            (set ai_render_firing_position_statistics false)
            (set ai_render_decisions false)
            (set ai_render_behavior_stack false)
            (set b_evaluate false)
        )
    )
)

(script startup void zone_control
    (if (not (> (game_coop_player_count) 1))
        (sleep_forever)
    )
    (sleep_until (>= (current_zone_set) s_zone_index_canyon) 1)
    (if (= (current_zone_set) s_zone_index_canyon)
        (begin
            (wake zone_slo_regression_blocker)
            (zone_set_trigger_volume_enable "zone_set:set_fields_010_020_025" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_fields_010_020_025" false)
        )
    )
    (sleep_until (>= (current_zone_set_fully_active) s_zone_index_canyon) 1)
    (if (= (current_zone_set_fully_active) s_zone_index_canyon)
        (begin
            (if debug
                (print "zone_teleport_control: turning off canyon triggers...")
            )
            (zone_set_trigger_volume_enable "begin_zone_set:set_canyon_020_025_028" false)
            (zone_set_trigger_volume_enable "zone_set:set_canyon_020_025_028" false)
            (sleep_until (volume_test_players "tv_teleport_can") 1)
            (if debug
                (print "zone_teleport_control: bringing players forward to canyon entrance...")
            )
            (volume_teleport_players_not_inside "tv_teleport_can_safezone" "fl_teleport_can")
            (sleep 1)
            (object_create_folder "sc_blockers_fld_entrance")
        )
    )
    (sleep_until (>= (current_zone_set) s_zone_index_river) 1)
    (if (= (current_zone_set) s_zone_index_river)
        (begin
            (sleep_until (volume_test_players "tv_teleport_rvr") 1)
            (if debug
                (print "zone_teleport_control: bringing players forward to pumpstation...")
            )
            (volume_teleport_players_not_inside "tv_teleport_rvr_safezone" "fl_teleport_rvr")
            (sleep 5)
            (object_create_folder "sc_blockers_can_entrance")
            (zone_set_trigger_volume_enable "begin_zone_set:set_canyon_020_025_028" false)
            (zone_set_trigger_volume_enable "zone_set:set_canyon_020_025_028" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_pumpstation_025_028_030" false)
            (zone_set_trigger_volume_enable "zone_set:set_pumpstation_025_028_030" false)
        )
    )
    (sleep_until (>= (current_zone_set) s_zone_index_settlement) 1)
    (if (= (current_zone_set) s_zone_index_settlement)
        (begin
            (if debug
                (print "zone_teleport_control: bringing players forward to river...")
            )
            (zone_set_trigger_volume_enable "begin_zone_set:set_canyon_020_025_028" false)
            (zone_set_trigger_volume_enable "zone_set:set_canyon_020_025_028" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_pumpstation_025_028_030" false)
            (zone_set_trigger_volume_enable "zone_set:set_pumpstation_025_028_030" false)
            (zone_set_trigger_volume_enable "begin_zone_set:set_river_028_030_035" false)
            (zone_set_trigger_volume_enable "zone_set:set_river_028_030_035" false)
            (sleep 1)
            (volume_teleport_players_not_inside "tv_teleport_set_safezone" "fl_teleport_set")
            (sleep 3)
            (if (volume_test_object "tv_rvr_blockers" (ai_get_object ai_jun))
                (object_teleport (ai_get_object ai_jun) "fl_rvr_jun_teleport")
            )
            (object_create_folder "sc_blockers_rvr_entrance")
        )
    )
)

(script startup void zone_setup_post_settlement
    (zone_set_trigger_volume_enable "begin_zone_set:set_cliffside_035_040_045" false)
    (sleep_until (= b_set_completed true) 1)
    (if debug
        (print "zone control: blocking player regression back to pumpstation...")
    )
    (volume_teleport_players_not_inside "tv_teleport_clf_safezone" "fl_teleport_clf")
    (sleep 5)
    (object_create_folder "sc_blockers_rvr_entrance")
    (zone_set_trigger_volume_enable "begin_zone_set:set_settlement_035_040" false)
    (zone_set_trigger_volume_enable "zone_set:set_settlement_035_040" false)
    (zone_set_trigger_volume_enable "begin_zone_set:set_river_028_030_035" false)
    (zone_set_trigger_volume_enable "zone_set:set_river_028_030_035" false)
    (sleep 1)
    (zone_set_trigger_volume_enable "begin_zone_set:set_cliffside_035_040_045" true)
)

(script dormant void zone_slo_regression_blocker
    (sleep_until 
        (begin
            (if (volume_test_object "tv_slo_coop_regression_blocker" player0)
                (object_teleport player0 "fields_spawn_player0")
                (if (volume_test_object "tv_slo_coop_regression_blocker" player1)
                    (object_teleport player1 "fields_spawn_player1")
                    (if (volume_test_object "tv_slo_coop_regression_blocker" player2)
                        (object_teleport player2 "fields_spawn_player2")
                        (if (volume_test_object "tv_slo_coop_regression_blocker" player3)
                            (object_teleport player3 "fields_spawn_player3")
                        )
                    )
                )
            )
            false
        )
        10
    )
)

(script static void zone_setup_firstkiva
    (if debug
        (print "::: zone manager: first kiva setup")
    )
)

(script static void recycle_010
    (add_recycling_volume "tv_010_recycle" 5 30)
)

(script static void recycle_020
    (add_recycling_volume "tv_020_recycle" 5 30)
)

(script static void recycle_025
    (add_recycling_volume "tv_025_recycle" 5 30)
)

(script static void recycle_030
    (add_recycling_volume "tv_030_recycle" 5 30)
)

(script static void recycle_040
    (add_recycling_volume "tv_040_recycle" 5 30)
)

(script static void recycle_045
    (add_recycling_volume "tv_045_recycle" 5 30)
)

(script startup void zeta_control
    (begin_random_count
        1
        (wake zeta_fkv)
        (wake zeta_pumpstation)
        (wake zeta_settlement)
    )
)

(script dormant void zeta_fkv
    (if debug
        (print "zeta detected at first kiva")
    )
    (sleep_until b_fkv_started)
    (ai_place "sq_cov_zeta_fkv")
    (sleep 5)
    (sleep_until (>= (ai_combat_status "gr_cov_fkv") 5) 1)
    (sleep 30)
    (cs_run_command_script "sq_cov_zeta_fkv" cs_zeta_fkv_active)
)

(script command_script void cs_zeta_fkv_patrol
    (cs_push_stance "patrol")
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_walk true)
    (cs_stow true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_go_to "pts_zeta_fkv/p0")
                    (sleep (random_range 120 300))
                )
                (begin
                    (cs_go_to "pts_zeta_fkv/p1")
                    (sleep (random_range 120 300))
                )
                (begin
                    (cs_go_to "pts_zeta_fkv/p2")
                    (sleep (random_range 120 300))
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_zeta_fkv_active
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (cs_shoot true)
    (if debug
        (print "zeta fkv active.")
    )
    (sleep (random_range (* 30 30) (* 30 30)))
    (set b_zeta_escape true)
    (sleep (random_range (* 30 6) (* 30 10)))
    (if debug
        (print "camo now")
    )
    (ai_set_active_camo ai_current_actor true)
    (cs_enable_targeting false)
    (cs_shoot false)
    (sleep 30)
    (ai_erase ai_current_actor)
)

(script dormant void zeta_pumpstation
    (if debug
        (print "rampancy detected at pumpstation")
    )
    (sleep_until (>= s_objcon_pmp 10) 1)
    (ai_place "sq_cov_zeta_pmp")
)

(script command_script void cs_zeta_pmp_active
    (ai_disregard ai_current_actor true)
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (cs_shoot true)
    (if debug
        (print "zeta set active.")
    )
    (sleep (random_range (* 30 30) (* 30 30)))
    (set b_zeta_escape true)
    (sleep_until (< (unit_get_shield ai_current_actor) 0.5) 30 (random_range (* 30 6) (* 30 10)))
    (if debug
        (print "camo now")
    )
    (ai_set_active_camo ai_current_actor true)
    (cs_enable_targeting false)
    (cs_shoot false)
    (sleep 30)
    (ai_erase ai_current_actor)
)

(script dormant void zeta_settlement
    (if debug
        (print "rampancy detected at settlement")
    )
    (sleep_until b_set_started)
    (ai_place "sq_cov_zeta_set")
    (sleep 5)
    (sleep_until (>= (ai_combat_status "gr_cov_set") 5) 1)
    (sleep 30)
    (cs_run_command_script "sq_cov_zeta_set" cs_zeta_set_active)
)

(script command_script void cs_zeta_set_patrol
    (cs_push_stance "patrol")
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_walk true)
    (cs_stow true)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_go_to "pts_zeta_set/p0")
                    (sleep (random_range 120 300))
                )
                (begin
                    (cs_go_to "pts_zeta_set/p1")
                    (sleep (random_range 120 300))
                )
                (begin
                    (cs_go_to "pts_zeta_set/p2")
                    (sleep (random_range 120 300))
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_zeta_set_active
    (cs_enable_moving true)
    (cs_enable_targeting true)
    (cs_shoot true)
    (if debug
        (print "zeta set active.")
    )
    (sleep (random_range (* 30 30) (* 30 30)))
    (set b_zeta_escape true)
    (sleep (random_range (* 30 6) (* 30 10)))
    (if debug
        (print "camo now")
    )
    (ai_set_active_camo ai_current_actor true)
    (cs_enable_targeting false)
    (cs_shoot false)
    (sleep 30)
    (ai_erase ai_current_actor)
)

(script static void (mus_start (looping_sound s))
    (sound_looping_start s none 1)
)

(script static void (mus_stop (looping_sound s))
    (sound_looping_stop s)
)

(script static void music_kill_all
    (sound_looping_stop_immediately mus_01)
    (sound_looping_stop_immediately mus_02)
    (sound_looping_stop_immediately mus_03)
    (sound_looping_stop_immediately mus_04)
    (sound_looping_stop_immediately mus_05)
    (sound_looping_stop_immediately mus_06)
    (sound_looping_stop_immediately mus_07)
    (sound_looping_stop_immediately mus_08)
    (sound_looping_stop_immediately mus_09)
    (sound_looping_stop_immediately mus_10)
    (sound_looping_stop_immediately mus_11)
    (sound_looping_stop_immediately mus_12)
    (sound_looping_stop_immediately mus_13)
)

(script static void (new_mission_objective (string_id screen, string_id start_menu))
    (sound_impulse_start "sound\game_sfx\fireteam\issue_directive.sound" none 1)
    (f_hud_obj_new screen start_menu)
)

(script static void clear_mission_objectives
    (objectives_clear)
)

(script dormant void show_objective_1
    (new_mission_objective "ct_primary_objective_1" "primary_objective_1")
)

(script dormant void show_objective_2
    (new_mission_objective "ct_primary_objective_2" "primary_objective_2")
)

(script dormant void show_objective_3
    (new_mission_objective "ct_primary_objective_3" "primary_objective_3")
)

(script dormant void show_objective_3_insertion
    (sleep 90)
    (new_mission_objective "ct_primary_objective_3" "primary_objective_3")
)

(script dormant void show_objective_4
    (new_mission_objective "ct_primary_objective_4" "primary_objective_4")
)

(script dormant void show_objective_5
    (new_mission_objective "ct_primary_objective_5" "primary_objective_5")
)

(script dormant void show_objective_5_insertion
    (sleep 90)
    (new_mission_objective "ct_primary_objective_5" "primary_objective_5")
)

(script dormant void show_objective_6
    (new_mission_objective "ct_primary_objective_6" "primary_objective_6")
)

(script dormant void show_objective_7
    (new_mission_objective "ct_primary_objective_7" "primary_objective_7")
)

(script dormant void show_objective_8
    (new_mission_objective "ct_primary_objective_8" "primary_objective_8")
)

(script dormant void show_tutorial_nightvision
    (if (not (difficulty_is_heroic_or_higher))
        (begin
            (f_hud_training player0 "tutorial_nightvision")
            (f_hud_training player1 "tutorial_nightvision")
            (f_hud_training player2 "tutorial_nightvision")
            (f_hud_training player3 "tutorial_nightvision")
        )
    )
)

(script dormant void show_tutorial_assassination
    (if (not (difficulty_is_heroic_or_higher))
        (begin
            (f_hud_training player0 "tutorial_assassination")
            (f_hud_training player1 "tutorial_assassination")
            (f_hud_training player2 "tutorial_assassination")
            (f_hud_training player3 "tutorial_assassination")
        )
    )
)

(script dormant void chapter_title_start
    (f_hud_chapter "ct_quiet")
)

(script dormant void chapter_title_mule
    (f_hud_chapter "ct_mule")
)

(script dormant void chapter_title_settlement
    (f_hud_chapter "ct_settlement")
)

(script static void (md_play (short delay, sound line))
    (sleep delay)
    (sound_impulse_start line none 1)
    (sleep (sound_impulse_language_time line))
)

(script static void (md_print (string line))
    (if dialogue
        (print line)
    )
)

(script static void md_start
    (sleep_until (not b_dialogue_playing) 1)
    (ai_dialogue_enable false)
    (set b_dialogue_playing true)
)

(script static void md_stop
    (ai_dialogue_enable true)
    (set b_dialogue_playing false)
)

(script static void (md_ai_play (short delay, ai char, ai_line line))
    (set s_md_duration (ai_play_line char line))
    (sleep s_md_duration)
    (sleep delay)
)

(script static void (md_object_play (short delay, object obj, ai_line line))
    (set s_md_duration (ai_play_line_on_object obj line))
    (sleep s_md_duration)
    (sleep delay)
)

(script static void md_abort
    (sleep s_md_duration)
    (if debug
        (print "!!! mission dialogue aborted !!!")
    )
    (set b_dialogue_playing false)
)

(script dormant void md_jun_mule_roar_1
    (sleep_until (= b_mule_has_roared true))
    (md_start)
    (md_print "jun: the hell is that?")
    (md_ai_play 0 ai_jun m30_0050)
    (md_stop)
    (set b_mule_has_roared false)
    (wake md_jun_mule_roar_2)
)

(script dormant void md_jun_mule_roar_2
    (sleep_until (= b_mule_has_roared true))
    (md_start)
    (md_print "jun: sounds big, whatever it is...")
    (md_ai_play 0 ai_jun m30_0060)
    (md_stop)
)

(script dormant void md_jun_stay_outta_sight
    (md_start)
    (md_print "jun: stay outta sight, six. watch those lights.")
    (md_ai_play 0 ai_jun m30_0070)
    (md_stop)
)

(script dormant void md_jun_dead_civilians
    (md_start)
    (md_print "jun: kat, we've got dead civilians... for farmers they're pretty well armed.")
    (md_ai_play 0 ai_jun m30_0220)
    (md_print "kat: sounds like militia. weapons shipments routinely go missing and turn up in rebel hands on reach.")
    (md_object_play 0 none m30_0230)
    (md_print "kat: you see something you like, take it.")
    (md_object_play 0 none m30_0240)
    (md_stop)
)

(script dormant void md_jun_really_pissed_them_off
    (branch (= b_slo_started true) (md_abort))
    (ai_dialogue_enable false)
    (sleep 30)
    (md_start)
    (md_print "jun: incoming. looks like you really pissed them off.")
    (md_ai_play 0 ai_jun m30_0250)
    (md_stop)
    (mus_stop mus_01)
    (mus_start mus_02)
    (f_callout_object (ai_vehicle_get "sq_cov_fkv_phantom_reinforce/pilot") blip_hostile_vehicle)
)

(script dormant void md_jun_shoot_light_1
    (md_start)
    (md_print "jun: six, take out the searchlight on that dropship!")
    (md_ai_play 0 ai_jun m30_0260)
    (md_stop)
)

(script dormant void md_jun_shoot_light_2
    (md_start)
    (md_print "jun: take out that phantom light, six!")
    (md_ai_play 0 ai_jun m30_0270)
    (md_stop)
)

(script dormant void md_jun_shoot_light_3
    (md_start)
    (md_print "jun: shoot the searchlight!")
    (md_ai_play 0 ai_jun m30_0280)
    (md_stop)
)

(script dormant void md_jun_shoot_light_success_1
    (md_start)
    (md_print "jun: they're blind and bugging out!")
    (md_ai_play 0 ai_jun m30_0290)
    (md_stop)
)

(script dormant void md_jun_shoot_light_success_2
    (md_start)
    (md_print "jun: let's see how they do without air support! re-engaging!")
    (md_ai_play 0 ai_jun m30_0300)
    (md_stop)
)

(script dormant void md_jun_shoot_light_success_3
    (md_start)
    (md_print "jun: always hated the spotlight...")
    (md_ai_play 0 ai_jun m30_0310)
    (md_stop)
)

(script dormant void md_kat_stealth_training
    (md_start)
    (md_print "kat: six, that's an unidentified piece of covenant gear. go ahead and activate it so i can get more data.")
    (md_object_play 0 none m30_0110)
    (md_stop)
    (md_start)
    (md_print "dot: how very interesting. armor diagnostics show negative light refraction from noble six's shields.")
    (md_object_play 0 none m30_0130)
    (md_print "jun: active camo? the next one's mine.")
    (md_object_play 0 ai_jun m30_0140)
    (md_stop)
)

(script dormant void md_jun_dropship_overhead_1
    (sleep_until (<= (objects_distance_to_object (ai_actors "sq_cov_rvr_phantom0") (player0)) 50))
    (md_start)
    (sleep 20)
    (set b_rvr_dropship_is_overhead true)
    (cs_run_command_script "gr_militia" cs_rvr_dropship_overhead)
    (cs_run_command_script ai_jun cs_rvr_dropship_overhead)
    (md_print "jun: hold up! covey dropship! take cover!")
    (md_ai_play 0 ai_jun m30_0880)
    (sleep_until (> (objects_distance_to_object (ai_actors "sq_cov_rvr_phantom0") (player0)) 30))
    (md_print "jun: okay, clear! let's move.")
    (md_ai_play 0 ai_jun m30_0910)
    (set b_rvr_dropship_is_overhead false)
    (md_stop)
)

(script command_script void cs_rvr_dropship_overhead
    (cs_enable_moving true)
    (cs_enable_looking true)
    (cs_enable_targeting true)
    (sleep (random_range 15 30))
    (cs_crouch true)
    (cs_enable_moving true)
    (cs_aim_object true (ai_vehicle_get "sq_cov_rvr_phantom0/pilot"))
    (sleep_until (or (>= s_objcon_rvr 60) (= b_rvr_dropship_is_overhead false)))
    (sleep (random_range 15 45))
)

(script dormant void md_jun_dropship_overhead_2
    (md_start)
    (md_print "jun: dropship overhead! stay out of sight!")
    (md_ai_play 0 ai_jun m30_0890)
    (md_stop)
)

(script dormant void md_jun_dropship_overhead_3
    (md_start)
    (md_print "jun: we got another dropship! stick to the shadows!")
    (md_ai_play 0 ai_jun m30_0900)
    (md_stop)
)

(script dormant void md_jun_dropship_clear_1
    (md_start)
    (md_print "jun: okay, clear! let's move.")
    (md_ai_play 0 ai_jun m30_0910)
    (md_stop)
)

(script dormant void md_jun_dropship_clear_2
    (md_start)
    (md_print "jun: dropship's gone. move out.")
    (md_ai_play 0 ai_jun m30_0920)
    (md_stop)
)

(script dormant void md_jun_dropship_clear_3
    (md_start)
    (md_print "jun: we're clear! hit the trail!")
    (md_ai_play 0 ai_jun m30_0930)
    (md_stop)
)

(script dormant void md_start_jun_intro
    (ai_dialogue_enable false)
    (sleep 90)
    (md_start)
    (md_print "kat: recon bravo: the sector ahead is dark to electronic surveillance.")
    (md_object_play 20 none m30_0010)
    (md_print "jun: covenant can block our instruments?")
    (md_ai_play 15 ai_jun m30_0020)
    (md_print "kat: so it would seem.  and command wants to know what they're hiding.")
    (md_object_play 0 none m30_0030)
    (wake show_objective_1)
    (md_stop)
)

(script dormant void md_start_jun_stealth_kill
    (sleep_until (>= s_objcon_ovr 30) 1)
    (if (and (> (ai_living_count ai_assassination_target) 0) (< (ai_combat_status "gr_cov_ovr") 4))
        (begin
            (md_start)
            (md_print "jun: elite. he's yours. do it quiet.")
            (md_ai_play 0 ai_jun m30_0080)
            (wake show_tutorial_assassination)
            (f_callout_ai ai_assassination_target blip_neutralize)
            (md_stop)
            (sleep_until (or (<= (ai_living_count ai_assassination_target) 0) (> s_objcon_fkv 40) (> (ai_combat_status "gr_cov_ovr") 3)))
            (if (and (< (ai_combat_status "gr_cov_ovr") 4) (<= (ai_living_count ai_assassination_target) 0))
                (begin
                    (sleep 30)
                    (md_start)
                    (md_print "jun: not bad.")
                    (md_ai_play 0 ai_jun m30_0090)
                    (md_stop)
                )
            )
        )
    )
)

(script dormant void md_fkv_jun_sitrep
    (sleep_until (or (volume_test_object "tv_fkv_jun_start_sitrep" (ai_get_object ai_jun)) (volume_test_players "tv_fkv_jun_start_sitrep")))
    (ai_dialogue_enable false)
    (sleep 45)
    (md_start)
    (md_print "jun: recon bravo to noble two.  stand by for contact report.")
    (md_ai_play 0 ai_jun m30_0150)
    (md_print "kat: standing by to copy, over.")
    (md_object_play 0 none m30_0160)
    (md_print "jun: we have eyes on multiple hostiles patrolling a settlement. this what we're looking for, kat?")
    (md_ai_play 0 ai_jun m30_0170)
    (md_print "kat: negative. too small, and you're not in the dark zone yet. engage at your discretion, but keep moving.")
    (md_object_play 0 none m30_0180)
    (if (>= (ai_combat_status "gr_cov_fkv") 3)
        (begin
            (md_print "jun: already engaged!")
            (md_ai_play 0 ai_jun m30_0200)
        )
        (begin
            (md_print "jun: you heard her, six. drop those tangos. stay away from the lights.")
            (md_ai_play 0 ai_jun m30_0190)
        )
    )
    (md_stop)
)

(script dormant void fkv_blip_enemies
    (sleep 90)
    (f_callout_ai_fast "gr_cov_fkv_jetpacks" blip_hostile)
    (f_callout_ai_fast "gr_cov_fkv_highvalue" blip_hostile)
)

(script dormant void md_fkv_jun_player_spotted
    (md_start)
    (md_print "jun: now you've done it!")
    (md_ai_play 0 ai_jun m30_0210)
    (md_stop)
)

(script dormant void md_slo_jun_use_gate
    (sleep_until (<= (ai_task_count "obj_cov_slo/gate_main") 0))
    (md_start)
    (md_print "jun: there's a path to the southeast; i'm gonna head that way. use the gate and meet me on the other side.")
    (md_ai_play 0 ai_jun m30_0320)
    (md_stop)
    (set b_slo_jun_leave true)
)

(script dormant void md_fld_jun_mule_intro
    (sleep_until (>= s_objcon_fld 1))
    (md_start)
    (md_print "jun: look at that...")
    (md_ai_play 60 ai_jun m30_0330)
    (md_stop)
    (mus_start mus_04)
)

(script dormant void md_fld_jun_stay_outta_sight
    (md_start)
    (md_print "jun: might wanna stay outta sight, six.")
    (md_ai_play 0 ai_jun m30_0340)
    (md_print "jun: looks like the coveys are having some personnel issues.")
    (md_print "jun: what the hell are those things? and and the hell are they doing to 'em?")
    (md_ai_play 0 ai_jun m30_0350)
    (md_stop)
)

(script dormant void md_fld_jun_mule_dies
    (md_start)
    (md_print "jun: aww, that ain't right.")
    (md_ai_play 0 ai_jun m30_0360)
    (md_stop)
)

(script dormant void md_fld_jun_dont_do_anything
    (md_start)
    (md_print "jun: easy! don't do anything to set it off!")
    (md_ai_play 0 ai_jun m30_0370)
    (md_stop)
)

(script dormant void md_fld_jun_put_that_thing_down
    (md_start)
    (md_print "jun: no choice; you gotta put that thing down!")
    (md_ai_play 0 ai_jun m30_0380)
    (md_stop)
)

(script dormant void md_fld_jun_headshot_six
    (md_start)
    (md_print "jun: headshot, six! go for the head!")
    (md_ai_play 0 ai_jun m30_0390)
    (md_stop)
)

(script dormant void md_fld_jun_just_walk_away
    (md_start)
    (md_print "jun: that's right, big fella. just walk away...")
    (md_ai_play 0 ai_jun m30_0400)
    (md_stop)
)

(script dormant void md_fld_jun_asks_kat_about_mule
    (ai_dialogue_enable false)
    (sleep 90)
    (md_start)
    (md_print "jun: kat, you pick any of that up?")
    (md_ai_play 35 ai_jun m30_0410)
    (md_print "kat: affirmative, recon bravo. it's an indigenous creature called a gueta.")
    (md_object_play 15 none m30_0420)
    (md_stop)
    (sleep 60)
    (if (not b_pmp_started)
        (wake md_fld_jun_trail_up_ahead)
    )
)

(script dormant void md_fld_jun_trail_up_ahead
    (ai_dialogue_enable false)
    (sleep 30)
    (md_start)
    (md_print "jun: six, there's a trail up ahead, through the rocks. let's take it.")
    (md_ai_play 0 ai_jun m30_0450)
    (md_stop)
    (ai_dialogue_enable true)
)

(script static void md_pmp_kill_dialogue
    (if debug
        (print "pmp: killing a mission dialogue script...")
    )
    (md_stop)
    (sleep 60)
)

(script dormant void sfx_pmp_magnum_burst
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum0" 1)
    (sleep 5)
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum0" 1)
    (sleep 8)
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum0" 1)
    (sleep 12)
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum1" 1)
    (sleep 9)
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum1" 1)
    (sleep 15)
    (if debug
        (print "bang!")
    )
    (sound_impulse_start "sound\weapons\magnum\magnum_fire.sound" "sfx_magnum0" 1)
)

(script dormant void md_pmp_jun_magnums
    (pmp_jun_failsafe)
    (sound_impulse_start "sound\levels\solo\m30\magnums_in_distance.sound" "sfx_magnum0" 1)
    (sleep (random_range 20 40))
    (md_start)
    (md_print "jun: gunfire! magnums -- security sidearms, standard issue...")
    (md_ai_play 0 ai_jun m30_0470)
    (md_stop)
    (mus_stop mus_03)
)

(script dormant void md_pmp_jun_sees_militia
    (sleep_until (>= s_objcon_pmp 10))
    (sleep_until (or (>= s_objcon_pmp 20) (volume_test_object "tv_pmp_jun_sees_militia" (ai_get_object ai_jun))) 30 (* 30 20))
    (ai_dialogue_enable false)
    (sleep 30)
    (md_start)
    (md_print "jun: noble 2, we're at some sort of pump station. got eyes on civilians -- i'm thinking more local militia. they've engaged hostiles.")
    (md_ai_play 0 ai_jun m30_0480)
    (md_print "kat: move to assist; they may have intel we need.")
    (md_object_play 20 none m30_0490)
    (md_print "jun: you heard her, six. keep those civilians alive!")
    (md_ai_play 30 ai_jun m30_0500)
    (md_stop)
    (mus_start mus_06)
    (wake show_objective_4)
    (f_blip_ai "sq_unsc_pmp_militia0" 5)
    (f_blip_ai "sq_unsc_pmp_militia1" 5)
    (f_blip_ai "sq_unsc_pmp_militia2" 5)
    (wake md_pmp_lost_civilians)
    (wake md_pmp_cv1_give_us_a_hand)
)

(script dormant void md_pmp_jun_dropship_another
    (md_start)
    (md_print "jun: another dropship coming in!")
    (md_ai_play 0 ai_jun m30_0510)
    (md_stop)
)

(script dormant void md_pmp_jun_dropship_two_more
    (md_start)
    (md_print "jun: two more covenant dropships inbound!")
    (md_ai_play 0 ai_jun m30_0520)
    (md_stop)
)

(script dormant void md_pmp_jun_dropship_three_inbound
    (md_start)
    (md_print "jun: i make three dropships coming in!")
    (md_ai_play 0 ai_jun m30_0530)
    (md_stop)
)

(script dormant void md_pmp_cv1_give_us_a_hand
    (branch (or (<= (ai_living_count "gr_militia") 0) (= b_pmp_assault_started true) (= b_rvr_started true)) (md_abort))
    (sleep_until (or (< (objects_distance_to_object (ai_actors "gr_militia") (player0)) 5) (< (objects_distance_to_object (ai_actors "gr_militia") (player1)) 5) (< (objects_distance_to_object (ai_actors "gr_militia") (player2)) 5) (< (objects_distance_to_object (ai_actors "gr_militia") (player3)) 5)))
    (vs_cast "gr_militia" true 10 "m30_0540")
    (set ai_cv1 (vs_role 1))
    (md_start)
    (md_print "civilian 1: give us a hand! bastards just keep coming!")
    (md_ai_play 0 ai_cv1 m30_0540)
    (md_stop)
)

(script dormant void md_pmp_cv2_give_us_a_hand
    (md_start)
    (md_print "civilian 2: give us a hand! bastards just keep coming!")
    (md_object_play 0 none m30_0550)
    (md_stop)
)

(script dormant void md_pmp_cvf_give_us_a_hand
    (md_start)
    (md_print "civilian female: give us a hand! bastards just keep coming!")
    (md_ai_play 0 ai_cvf m30_0560)
    (md_stop)
)

(script dormant void md_pmp_lost_civilians
    (sleep_until (<= (ai_living_count "gr_militia") 0))
    (sleep 45)
    (md_start)
    (md_print "jun: recon bravo to noble two. we lost the civilians.")
    (md_ai_play 0 ai_jun m30_0580)
    (md_stop)
)

(script dormant void md_pmp_stash_convo
    (md_start)
    (if debug
        (print "::: starting pumpstation initial postcombat conversation...")
    )
    (vs_cast "gr_militia" true 10 "m30_0600")
    (set ai_civilian2 (vs_role 1))
    (branch (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0)) (md_pmp_kill_stash_dialogue))
    (if debug
        (print "we're now past the branch...")
    )
    (md_print "civilian 2: little more action than we're used to. you spartans are good in a fight.")
    (md_ai_play 20 ai_civilian2 m30_0600)
    (md_print "jun: what are you doing here? whole area's supposed to be evacuated.")
    (md_ai_play 25 ai_jun m30_0610)
    (md_print "civilian 2: didn't like leaving it to someone else to protect our home.")
    (md_ai_play 0 ai_civilian2 m30_0620)
    (set b_pmp_assault_start_dropships true)
    (md_print "civilian 2: so we came back... for this.")
    (md_ai_play 30 ai_civilian2 m30_0630)
    (device_set_position "dm_pmp_stash0" 1)
    (device_set_position "dm_pmp_stash1" 1)
    (wake pmp_callout_stash)
    (md_print "civilian 2: we have them hidden all over the territory.")
    (md_ai_play 0 ai_civilian2 m30_0640)
    (md_print "jun: you know this stuff is stolen.")
    (md_ai_play 10 ai_jun m30_0650)
    (md_print "civilian 2: you going to arrest me?")
    (md_ai_play 30 ai_civilian2 m30_0660)
    (md_print "jun: no. gonna steal it back.")
    (md_ai_play 10 ai_jun m30_0670)
    (set b_pmp_stash_convo_active false)
    (set b_pmp_stash_convo_completed true)
    (md_stop)
)

(script command_script void cs_pmp_stash_convo_mil0
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_stash/mil0_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until b_pmp_stash_convo_completed)
)

(script command_script void cs_pmp_stash_convo_mil1
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_stash/mil1_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until b_pmp_stash_convo_completed)
)

(script command_script void cs_pmp_stash_convo_mil2
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_stash/mil2_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until b_pmp_stash_convo_completed)
)

(script command_script void cs_pmp_stash_convo_mil3
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_stash/mil3_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until b_pmp_stash_convo_completed)
)

(script command_script void cs_pmp_stash_convo_jun
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_stash/jun_dest")
    (cs_face true "pts_thespian_pmp_stash/jun_face")
    (sleep_until b_pmp_stash_convo_completed)
)

(script dormant void md_pmp_jun_dropship_control
    (sleep_until b_pmp_charlie_enroute)
    (md_pmp_jun_another_dropship)
    (mus_stop mus_06)
    (f_callout_object (ai_vehicle_get "sq_cov_pmp_charlie_ds/pilot") blip_hostile_vehicle)
    (sleep_until b_pmp_bravo_enroute)
    (md_pmp_jun_dropship_got_company)
    (f_callout_object (ai_vehicle_get "sq_cov_pmp_bravo_ds/pilot") blip_hostile_vehicle)
    (sleep_until b_pmp_alpha_enroute)
    (md_set_jun_dropship_more_inbound)
    (mus_start mus_07)
    (f_callout_object (ai_vehicle_get "sq_cov_pmp_alpha_ds/pilot") blip_hostile_vehicle)
)

(script static void md_pmp_jun_another_dropship
    (md_start)
    (md_print "jun: another dropship coming in!")
    (md_ai_play 0 ai_jun m30_0510)
    (md_stop)
)

(script static void md_pmp_jun_dropship_got_company
    (md_start)
    (md_print "jun: we got company!")
    (md_ai_play 0 ai_jun m30_1050)
    (md_stop)
)

(script static void md_set_jun_dropship_more_inbound
    (md_start)
    (md_print "jun: more inbound!")
    (md_ai_play 0 ai_jun m30_1060)
    (md_stop)
)

(script static void md_pmp_kill_stash_dialogue
    (if debug
        (print "pmp: killing a stash dialogue script...")
    )
    (set b_pmp_stash_convo_active false)
    (set b_pmp_stash_convo_completed true)
    (set b_pmp_assault_start_dropships true)
    (md_stop)
    (sleep 60)
)

(script dormant void pmp_callout_stash
    (f_callout_object "dm_pmp_stash0" blip_ordnance)
    (f_callout_object "dm_pmp_stash1" blip_ordnance)
)

(script dormant void md_pmp_jun_hydro_civs_alive
    (md_start)
    (vs_cast "gr_militia" true 10 "m30_0710")
    (set ai_civilian2 (vs_role 1))
    (branch (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0) (angry_halo)) (pmp_postcombat_abort))
    (md_print "jun: nothing here but that lake.")
    (md_ai_play 30 ai_jun m30_0700)
    (md_print "civilian 2: road leads to a hydroelectric plant, but the gate doesn't work.")
    (md_ai_play 25 ai_civilian2 m30_0710)
    (md_print "jun: alternate route?")
    (md_ai_play 15 ai_jun m30_0720)
    (md_print "civilian 2: we use the riverbed to smuggle rations, weapons...")
    (md_ai_play 10 ai_civilian2 m30_0730)
    (md_print "jun: basically, anything the unsc considers contraband.")
    (md_ai_play 35 ai_jun m30_0740)
    (md_print "civilian 2: basically.")
    (md_ai_play 35 ai_civilian2 m30_0750)
    (md_print "jun: show us.")
    (md_ai_play 30 ai_jun m30_0760)
    (fireteam_setup)
    (set b_pmp_post_convo_goto_river true)
    (ai_set_fireteam_absorber "sq_unsc_pmp_militia0" true)
    (ai_set_fireteam_absorber "sq_unsc_pmp_militia1" true)
    (ai_set_fireteam_absorber "sq_unsc_pmp_militia2" true)
    (ai_set_objective "fireteam_player0" "obj_unsc_pmp")
    (wake md_pmp_jun_theres_the_riverbed)
    (set b_pmp_post_convo_completed true)
    (set b_pmp_post_convo_active false)
    (md_stop)
    (game_save)
)

(script command_script void cs_pmp_post_convo_mil0
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/mil0_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script command_script void cs_pmp_post_convo_mil1
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/mil1_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script command_script void cs_pmp_post_convo_mil2
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/mil2_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script command_script void cs_pmp_post_convo_mil3
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/mil3_dest")
    (cs_face_object true (ai_get_object ai_jun))
    (cs_look_object true (ai_get_object ai_jun))
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script command_script void cs_pmp_post_convo_jun
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/jun_dest")
    (cs_face true "pts_thespian_pmp_postencounter/jun_face")
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script command_script void cs_pmp_post_convo_jun_nomilitia
    (cs_push_stance "alert")
    (cs_go_to "pts_thespian_pmp_postencounter/jun_dest_nomilitia")
    (cs_face true "pts_thespian_pmp_postencounter/jun_face_nomilitia")
    (cs_look true "pts_thespian_pmp_postencounter/jun_face_nomilitia")
    (sleep_until (or b_pmp_post_convo_completed (volume_test_players "tv_pmp_players_move_to_exit")))
)

(script static void md_pmp_jun_hydro_civs_dead
    (branch (= b_pmp_player_skips_encounter true) (md_pmp_postcombat_abort))
    (set b_pmp_post_convo_goto_river true)
    (md_start)
    (md_print "jun: no movement. nothing else alive, human or covenant.")
    (md_ai_play 90 ai_jun m30_0570)
    (md_print "jun: nothing here but that lake... kat, where we going?")
    (md_ai_play 0 ai_jun m30_0810)
    (md_print "kat: should be a hydroelectric plant nearby.")
    (md_object_play 30 none m30_0820)
    (md_print "jun: front gate looks locked... is there another way in?")
    (md_ai_play 15 ai_jun m30_0830)
    (md_print "kat: stand by; i'll check with recon alpha.")
    (md_object_play (* 30 6) none m30_0840)
    (md_print "kat: jorge said settlers dammed a nearby river. was a few years back. dry riverbed might be your best route.")
    (md_object_play 30 none m30_0850)
    (md_print "jun: copy, thanks.")
    (md_ai_play 10 ai_jun m30_0860)
    (md_stop)
    (set b_pmp_post_convo_completed true)
    (set b_pmp_post_convo_active false)
    (set b_pmp_move_to_river true)
    (game_save)
    (wake pmp_exit_reminder)
    (wake md_pmp_jun_theres_the_riverbed)
)

(script static void md_pmp_postcombat_abort
    (set b_pmp_post_convo_completed true)
)

(script dormant void md_pmp_jun_theres_the_riverbed
    (branch (= b_rvr_started true) (md_abort))
    (sleep_until (volume_test_object "tv_rvr_jun_reaches_riverbed" (ai_get_object ai_jun)))
    (if (not (= b_rvr_started true))
        (begin
            (md_start)
            (md_print "jun: there's the riverbed, six. let's see where it goes.")
            (md_ai_play 30 ai_jun m30_0870)
            (md_stop)
            (if (and (not (= b_rvr_started true)) (not (volume_test_players "tv_rvr_jun_reaches_riverbed")))
                (f_blip_flag "fl_rvr_entrance" 21)
            )
        )
    )
)

(script dormant void md_rvr_jun_where_does_riverbed_lead
    (md_start)
    (vs_cast "gr_militia" true 10 "m30_0780")
    (set ai_civilian2 (vs_role 1))
    (branch (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0)) (md_pmp_kill_dialogue))
    (md_print "jun: where does this riverbed lead?")
    (md_ai_play 20 ai_jun m30_0770)
    (md_print "civilian 2: straight to the hydro plant. we dammed this river up 45 years ago. plant powers every settlement in the territory.")
    (md_ai_play 15 ai_civilian2 m30_0780)
    (md_print "civilian 2: shame if it all gets wasted.")
    (md_ai_play 40 ai_civilian2 m30_0790)
    (md_print "jun: doing what we can.")
    (md_ai_play 0 ai_jun m30_0800)
    (md_stop)
)

(script dormant void md_rvr_jun_settlement_history
    (if (and (> (ai_living_count "gr_militia") 0) (> (ai_task_count "obj_unsc_rvr/gate_militia") 0))
        (wake md_rvr_jun_where_does_riverbed_lead)
    )
)

(script dormant void md_set_jun_kat_you_seeing
    (sleep_until (or (volume_test_object "tv_set_jun_sees_pylon" (ai_get_object ai_jun)) (>= s_objcon_set 10)))
    (ai_dialogue_enable false)
    (sleep 60)
    (md_start)
    (md_print "jun: kat, are you seeing this")
    (md_ai_play 40 ai_jun m30_0940)
    (md_print "jun: covenant structure. some kind of big pylon -- heavily fortified.")
    (md_ai_play 25 ai_jun m30_0960)
    (md_print "kat: that's the source of our dark zone.")
    (md_object_play 15 none m30_0970)
    (set b_set_unsc_advance true)
    (md_print "jun: okay. consider it gone...")
    (md_ai_play 0 ai_jun m30_0980)
    (md_print "kat: negative. stick a remote det charge on it. command is planning something big. they say the pylon dies at dawn.")
    (md_object_play 0 none m30_0990)
    (md_stop)
    (if (and (> (ai_living_count "gr_militia") 0) (<= (ai_combat_status "gr_cov_set") 2))
        (md_set_cv2_we_gonna_blow_it)
    )
    (wake set_save_postintro)
    (wake show_objective_6)
    (mus_stop mus_08)
)

(script static void md_set_cv2_we_gonna_blow_it
    (sleep 90)
    (md_start)
    (vs_cast "gr_militia" false 10 "m30_1010")
    (set ai_civilian2 (vs_role 1))
    (md_print "civilian 2: we gonna blow it?")
    (md_ai_play 30 ai_civilian2 m30_1010)
    (md_print "jun: we're gonna clear the area, then i'm gonna plant a remote det-charge. you wanna provide some cover, go right ahead.")
    (md_ai_play 0 ai_jun m30_1020)
    (md_stop)
)

(script dormant void set_save_postintro
    (game_save_no_timeout)
)

(script static void md_set_jun_cover_me
    (md_start)
    (md_print "jun: all clear, six. cover me while i plant the charge.")
    (md_ai_play 30 ai_jun m30_1030)
    (md_print "jun: this is gonna take a minute. keep your eyes peeled!")
    (md_ai_play 0 ai_jun m30_1040)
    (wake show_objective_7)
    (mus_start mus_09)
    (md_stop)
)

(script dormant void md_set_jun_dropship_callout_1
    (md_start)
    (md_print "jun: we got company!")
    (md_ai_play 0 ai_jun m30_1050)
    (md_stop)
)

(script dormant void md_set_jun_dropship_callout_2
    (md_start)
    (md_print "jun: more inbound!")
    (md_ai_play 0 ai_jun m30_1060)
    (md_stop)
)

(script dormant void md_set_jun_dropship_callout_3
    (md_start)
    (md_print "jun: here they come!")
    (md_ai_play 0 ai_jun m30_1070)
    (md_stop)
)

(script dormant void md_set_jun_dropship_callout_4
    (md_start)
    (md_print "jun: fun never ends!")
    (md_ai_play 0 ai_jun m30_1080)
    (md_stop)
)

(script dormant void md_set_jun_dropship_callout_5
    (md_start)
    (md_print "jun: coveys inbound!")
    (md_ai_play 0 ai_jun m30_1090)
    (md_stop)
)

(script dormant void md_set_jun_still_working_1
    (md_start)
    (md_print "jun: keep me covered...")
    (md_ai_play 0 ai_jun m30_1100)
    (md_stop)
)

(script dormant void md_set_jun_still_working_2
    (md_start)
    (md_print "jun: still working...")
    (md_ai_play 0 ai_jun m30_1110)
    (md_stop)
)

(script dormant void md_set_jun_still_working_3
    (md_start)
    (md_print "jun: need a little more time...")
    (md_ai_play 0 ai_jun m30_1120)
    (md_stop)
)

(script dormant void md_set_jun_still_working_4
    (md_start)
    (md_print "jun: almost finished...")
    (md_ai_play 0 ai_jun m30_1130)
    (md_stop)
)

(script dormant void md_set_jun_finished
    (md_start)
    (md_print "jun: done! charge planted!")
    (md_ai_play 0 ai_jun m30_1140)
    (md_stop)
)

(script static void md_set_jun_charge_placed
    (md_start)
    (md_print "jun: recon bravo to noble 2, charge placed.")
    (md_ai_play 15 ai_jun m30_1150)
    (md_print "kat: somewhere inconspicuous, i hope.")
    (md_object_play 10 none m30_1160)
    (md_print "jun: stuck it inside the pylon's power supply. they'll never know it's there.")
    (md_ai_play 35 ai_jun m30_1170)
    (md_print "kat: all right, keep pushing into the dark zone. command wants to know what the covenant are hiding.")
    (md_object_play 0 none m30_1180)
    (wake show_objective_8)
    (md_stop)
)

(script static void md_clf_jun_gate
    (md_start)
    (md_print "jun: there's a gate to the southeast of the hydro plant.")
    (md_ai_play 0 ai_jun m30_1190)
    (f_blip_flag "fl_clf_gate" blip_recon)
    (md_print "kat: copy. uploading security codes to you now.")
    (md_object_play 0 none m30_1200)
    (mus_stop mus_09)
    (mus_start mus_10)
    (md_stop)
)

(script dormant void md_clf_jun_opens_gate
    (sleep 30)
    (md_start)
    (f_unblip_flag "fl_clf_gate")
    (md_print "jun: okay, got 'em. unlocking the gate...")
    (md_ai_play 0 ai_jun m30_1210)
    (md_stop)
    (md_clf_kat_gate_open)
)

(script static void md_clf_kat_gate_open
    (md_start)
    (md_print "kat: recon bravo, you're heading into the dark zone now.")
    (md_object_play 0 none m30_1220)
    (md_print "jun: understood.")
    (md_ai_play 0 ai_jun m30_1230)
    (md_stop)
)

(script dormant void md_clf_jun_phantom_too_close
    (md_start)
    (md_print "jun: phantom! little too close for comfort!")
    (md_ai_play 0 ai_jun m30_1240)
    (md_stop)
)

(script dormant void md_clf_jun_shade
    (md_start)
    (if (> (ai_living_count "sq_cov_clf_center_shade0") 0)
        (begin
            (md_print "jun: shade! fire and maneuver, six! hit'em from the side!")
            (md_ai_play 0 ai_jun m30_1250)
        )
    )
    (md_stop)
    (mus_stop mus_10)
    (mus_start mus_11)
)

(script dormant void md_clf_jun_beckon_1
    (md_start)
    (md_print "jun: come on, six!")
    (md_ai_play 0 ai_jun m30_1260)
    (md_stop)
)

(script dormant void md_clf_jun_beckon_2
    (md_start)
    (md_print "jun: noble six, on me!")
    (md_ai_play 0 ai_jun m30_1270)
    (md_stop)
)

(script dormant void md_clf_jun_beckon_3
    (md_start)
    (md_print "jun: stay with me, lieutenant!")
    (md_ai_play 0 ai_jun m30_1280)
    (md_stop)
)

(script dormant void md_clf_jun_lotta_air_traffic
    (sleep_until (or (<= (ai_living_count "gr_cov_clf_center") 0) (>= s_objcon_clf 110)))
    (wake clf_airtraffic_control)
    (sleep (random_range 150 210))
    (md_start)
    (md_print "jun: lotta air traffic around here, six. i think we're getting warm.")
    (md_ai_play 0 ai_jun m30_1290)
    (md_stop)
)

(script dormant void md_clf_jun_eyes_on_capital_ship
    (if (> (ai_living_count "gr_cov_clf") 0)
        (wake md_clf_jun_eyes_on_combat)
        (wake md_clf_jun_eyes_on_postcombat)
    )
)

(script dormant void md_clf_jun_eyes_on_postcombat
    (md_start)
    (md_print "jun: noble 2, we have eyes on at least one covenant ship...")
    (md_ai_play 0 ai_jun m30_1300)
    (md_clf_kat_solid_copy)
    (md_stop)
)

(script dormant void md_clf_jun_eyes_on_combat
    (md_start)
    (md_print "jun: noble 2, we have eyes on at least one covenant ship...")
    (md_ai_play 0 ai_jun m30_1310)
    (md_clf_kat_solid_copy)
    (md_stop)
)

(script static void md_clf_kat_solid_copy
    (md_print "kat: solid copy. don't stop now.")
    (md_object_play 0 none m30_1320)
)

(script static void md_clf_jun_cave_ahead
    (md_start)
    (md_print "jun: cave ahead. good cover, better view. meet you inside.")
    (md_ai_play 0 ai_jun m30_1320)
    (md_stop)
)

(script static void weather_set_theme_default
    (if debug
        (print "weather: default theme starting")
    )
    (set b_rain_thunderclap false)
    (set s_rain_min_on_time 60)
    (set s_rain_max_on_time 180)
    (set s_rain_min_off_time 30)
    (set s_rain_max_off_time 45)
    (set s_rain_min_ramp_up_time 2)
    (set s_rain_max_ramp_up_time 10)
    (set s_rain_min_ramp_down_time 6)
    (set s_rain_max_ramp_down_time 12)
    (set s_rain_min_lightning_delay 5)
    (set s_rain_max_lightning_delay 20)
    (set s_rain_min_thunder_delay 1)
    (set s_rain_max_thunder_delay 3)
    (set r_rain_min_force 1)
    (set r_rain_max_force 1)
)

(script static void weather_set_theme_storm
    (if debug
        (print "weather: storm theme starting")
    )
    (set b_rain_thunderclap true)
    (set s_rain_min_on_time 300)
    (set s_rain_max_on_time 600)
    (set s_rain_min_off_time 60)
    (set s_rain_max_off_time 120)
    (set s_rain_min_ramp_up_time 15)
    (set s_rain_max_ramp_up_time 45)
    (set s_rain_min_ramp_down_time 50)
    (set s_rain_max_ramp_down_time 120)
    (set s_rain_min_lightning_delay 3)
    (set s_rain_max_lightning_delay 15)
    (set s_rain_min_thunder_delay 1)
    (set s_rain_max_thunder_delay 2)
    (set r_rain_min_force 1)
    (set r_rain_max_force 1)
)

(script static void weather_set_theme_light
    (if debug
        (print "weather: light rain theme starting")
    )
    (set b_rain_thunderclap false)
    (set s_rain_min_on_time 80)
    (set s_rain_max_on_time 180)
    (set s_rain_min_off_time 120)
    (set s_rain_max_off_time 120)
    (set s_rain_min_ramp_up_time 15)
    (set s_rain_max_ramp_up_time 45)
    (set s_rain_min_ramp_down_time 50)
    (set s_rain_max_ramp_down_time 80)
    (set s_rain_min_lightning_delay 20)
    (set s_rain_max_lightning_delay 45)
    (set s_rain_min_thunder_delay 3)
    (set s_rain_max_thunder_delay 6)
    (set r_rain_min_force 0.2)
    (set r_rain_max_force 0.6)
)

(script startup void weather_rain
    (weather_animate_force "off" 1 0)
    (sleep_until 
        (begin
            (sleep_range_seconds s_rain_min_off_time s_rain_max_off_time)
            (weather_rain_start)
            (sleep_range_seconds s_rain_min_on_time s_rain_max_on_time)
            (weather_rain_stop)
            false
        )
        1
    )
)

(script static void weather_rain_start
    (if b_weather_debug
        (print "weather: rain starting...")
    )
    (weather_animate_force "light_rain" (real_random_range r_rain_min_force r_rain_max_force) (random_range s_rain_min_ramp_up_time s_rain_max_ramp_up_time))
    (set b_rain_is_active true)
)

(script static void weather_rain_stop
    (if b_weather_debug
        (print "weather: rain stopping...")
    )
    (weather_animate_force "off" 1 (random_range s_rain_min_ramp_down_time s_rain_max_ramp_down_time))
    (set b_rain_is_active false)
)

(script startup void weather_lightning
    (branch (= b_mission_complete true) (branch_abort))
    (weather_lightning_flash)
    (sleep_until (= b_ovr_started true))
    (sleep_until 
        (begin
            (sleep_range_seconds s_rain_min_lightning_delay s_rain_max_lightning_delay)
            (weather_lightning_flash)
            (sleep_range_seconds s_rain_min_thunder_delay s_rain_max_thunder_delay)
            (weather_thunder_clap)
            false
        )
        60
    )
)

(script static void weather_lightning_flash
    (if b_weather_debug
        (print "weather: flash!")
    )
    (interpolator_start "lightning")
)

(script static void weather_thunder_clap
    (if b_rain_thunderclap
        (begin
            (if b_weather_debug
                (print "weather: thunder clap!")
            )
            (sound_impulse_start "sound\levels\solo\weather\thunder_claps.sound" none 1)
            (ai_thunder_deafen ai_to_deafen true)
            (sleep (* 30 2.5))
            (ai_thunder_deafen ai_to_deafen false)
        )
        (begin
            (if b_weather_debug
                (print "weather: rolling thunder...")
            )
            (sound_impulse_start "sound\levels\solo\weather\rain\details\thunder.sound" none 1)
        )
    )
)

(script static void (ai_thunder_deafen (ai actors, boolean deafen))
    (if deafen
        (begin
            (if (< (ai_combat_status actors) 4)
                (begin
                    (if b_weather_debug
                        (print "deafening the ai...")
                    )
                    (ai_set_blind actors true)
                    (ai_set_deaf actors true)
                )
            )
        )
        (begin
            (if b_weather_debug
                (print "ai now have their vision and hearing again...")
            )
            (ai_set_blind actors false)
            (ai_set_deaf actors false)
        )
    )
)

(script static void (sleep_range_seconds (short minsleep, short maxsleep))
    (sleep (random_range (* 30 minsleep) (* 30 maxsleep)))
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

(script static boolean obj_usteal_1_1
    (= b_stealth_training_complete true)
)

(script static boolean obj_uinser_1_2
    (f_ai_is_defeated "gr_cov_ovr")
)

(script static boolean obj_ufollo_1_3
    (or (f_ai_is_defeated "gr_cov_ovr_high") (>= s_objcon_ovr 50))
)

(script static boolean obj_cgate__2_3
    (ai_is_alert "gr_cov_fkv")
)

(script static boolean obj_cgate__2_4
    (< s_objcon_fkv 50)
)

(script static boolean obj_cphant_2_6
    (and (= b_fkv_ds0_delivery_started false) (not (fkv_ds0_turret_is_alive)) (>= s_objcon_fkv 5))
)

(script static boolean obj_chighv_2_13
    (>= (ai_strength "gr_cov_fkv") 0.45)
)

(script static boolean obj_cgate__2_19
    (not (volume_test_players "tv_fkv_approach_00"))
)

(script static boolean obj_cgate__2_20
    (>= (ai_strength "gr_cov_fkv_reinforce") 0.3)
)

(script static boolean obj_cgate__2_23
    (not (volume_test_players "tv_fkv_approach_01"))
)

(script static boolean obj_cgarag_2_24
    (<= (ai_task_count "obj_cov_fkv/gate_reinforce_courtyard_forward") 0)
)

(script static boolean obj_cgate__2_25
    (not (volume_test_players "tv_fkv_approach_01"))
)

(script static boolean obj_ccourt_2_27
    (<= (ai_task_count "obj_cov_fkv/gate_reinforce_garage_forward") 0)
)

(script static boolean obj_czeta__2_33
    (= b_zeta_escape true)
)

(script static boolean obj_usnipi_3_2
    (< (ai_task_count "obj_cov_fkv/gate_main") 8)
)

(script static boolean obj_uhold__3_3
    (and (>= s_objcon_fkv 5) (<= (ai_living_count "gr_cov_fkv_hill") 0))
)

(script static boolean obj_ufollo_3_4
    (and (>= (ai_combat_status "gr_cov_fkv") 5) (volume_test_players "tv_fkv_approach_00"))
)

(script static boolean obj_mmules_4_5
    (<= (ai_task_count "obj_mule_cov/gate_covenant") 0)
)

(script static boolean obj_mminio_4_6
    (<= (ai_task_count "obj_mule_cov/gate_covenant") 4)
)

(script static boolean obj_mminio_4_10
    (<= (ai_living_count "sq_mule_fld") 0)
)

(script static boolean obj_mminio_4_11
    (<= (ai_living_count "sq_mule_fld/low") 0)
)

(script static boolean obj_call_f_5_5
    (<= (ai_task_count "obj_unsc_pmp/gate_defense_low") 0)
)

(script static boolean obj_cgate__5_7
    (= b_pmp_alpha_enroute false)
)

(script static boolean obj_cgate__5_11
    (= b_pmp_bravo_enroute false)
)

(script static boolean obj_cgate__5_12
    (= b_pmp_assault_started true)
)

(script static boolean obj_cpmp_p_5_13
    b_pmp_player_skips_encounter
)

(script static boolean obj_ciniti_5_18
    (>= (ai_strength "gr_cov_pmp") 0.5)
)

(script static boolean obj_cfinal_5_19
    (and (= b_pmp_charlie_delivered true) (<= (ai_task_count "obj_cov_pmp/gate_main") 2))
)

(script static boolean obj_ciniti_5_22
    (>= (ai_strength "gr_cov_pmp") 0.5)
)

(script static boolean obj_ccreek_5_34
    (<= (ai_living_count "gr_cov_pmp") 3)
)

(script static boolean obj_czeta__5_40
    (= b_zeta_escape true)
)

(script static boolean obj_udefen_6_2
    (= b_pmp_assault_complete true)
)

(script static boolean obj_ujun_e_6_4
    (>= s_objcon_pmp 10)
)

(script static boolean obj_ugo_to_6_5
    (= b_pmp_go_to_gate true)
)

(script static boolean obj_ugo_to_6_6
    (or (= b_pmp_post_convo_completed true) (= b_pmp_post_convo_goto_river true))
)

(script static boolean obj_ujun_a_6_9
    (= b_pmp_assault_started true)
)

(script static boolean obj_ugate__6_10
    (= b_pmp_assault_started true)
)

(script static boolean obj_umilit_6_14
    (<= (ai_task_count "obj_cov_pmp/gate_initial") 0)
)

(script static boolean obj_ujun_f_6_15
    (>= s_objcon_pmp 20)
)

(script static boolean obj_ugo_do_6_16
    (and (= b_pmp_post_convo_completed true) (volume_test_players "tv_pmp_exit"))
)

(script static boolean obj_ugate__6_17
    (and (<= (ai_strength "gr_cov_pmp") 0.2) (>= s_objcon_pmp 30))
)

(script static boolean obj_ujun_a_6_19
    (= b_pmp_bravo_enroute true)
)

(script static boolean obj_ujun_a_6_20
    (= b_pmp_alpha_enroute true)
)

(script static boolean obj_umilit_6_22
    (= b_pmp_bravo_enroute true)
)

(script static boolean obj_umilit_6_23
    (= b_pmp_alpha_enroute true)
)

(script static boolean obj_udefen_6_25
    (= b_pmp_bravo_enroute true)
)

(script static boolean obj_udefen_6_26
    (= b_pmp_alpha_enroute true)
)

(script static boolean obj_uobjco_8_2
    (>= s_objcon_rvr 10)
)

(script static boolean obj_uobjco_8_9
    (>= s_objcon_rvr 20)
)

(script static boolean obj_uobjco_8_10
    (>= s_objcon_rvr 30)
)

(script static boolean obj_uobjco_8_11
    (>= s_objcon_rvr 40)
)

(script static boolean obj_uobjco_8_12
    (>= s_objcon_rvr 50)
)

(script static boolean obj_uobjco_8_13
    (>= s_objcon_rvr 60)
)

(script static boolean obj_umilit_8_16
    (>= s_objcon_rvr 10)
)

(script static boolean obj_umilit_8_17
    (>= s_objcon_rvr 20)
)

(script static boolean obj_umilit_8_18
    (>= s_objcon_rvr 60)
)

(script static boolean obj_umilit_8_19
    (>= s_objcon_rvr 50)
)

(script static boolean obj_umilit_8_20
    (>= s_objcon_rvr 40)
)

(script static boolean obj_umilit_8_21
    (>= s_objcon_rvr 30)
)

(script static boolean obj_cbridg_9_9
    (<= (ai_task_count "obj_cov_set/gate_bridge") 3)
)

(script static boolean obj_ciniti_9_12
    (= b_set_defense_start true)
)

(script static boolean obj_cfront_9_17
    (= b_set_player_front true)
)

(script static boolean obj_czeta__9_19
    (= b_zeta_escape true)
)

(script static boolean obj_ccs_fo_10_3
    (>= s_objcon_clf 120)
)

(script static boolean obj_ccs_ro_10_8
    (< s_objcon_clf 110)
)

(script static boolean obj_croad__10_12
    (<= (ai_strength "gr_cov_clf_road") 0.4)
)

(script static boolean obj_ccs_ch_10_13
    (>= s_objcon_clf 110)
)

(script static boolean obj_cnest__10_16
    (and (>= s_objcon_clf 110) (<= (ai_living_count "sq_cov_clf_jetpacks0") 0))
)

(script static boolean obj_cnest__10_18
    (> (ai_task_count "obj_cov_clf/gate_nest_elites") 0)
)

(script static boolean obj_cnest__10_21
    (>= s_objcon_clf 120)
)

(script static boolean obj_coverl_10_25
    (> (ai_strength "gr_cov_clf_final") 0.2)
)

(script static boolean obj_coverl_10_27
    (not (f_ai_is_defeated "sq_cov_clf_overlook_inf1"))
)

(script static boolean obj_cfinal_10_28
    (<= (ai_living_count "gr_cov_clf_final") 1)
)

(script static boolean obj_ustart_11_1
    (>= (device_get_position "gate") 0.6)
)

(script static boolean obj_uroad__11_2
    (and (<= (ai_strength "gr_cov_clf_road") 0.4) (= b_cliffside_road_dropoff true))
)

(script static boolean obj_unest_11_3
    (and (f_ai_is_defeated "sq_cov_clf_skirmishers") (f_ai_is_partially_defeated "gr_cov_clf_mid" 2) (f_ai_is_defeated "sq_cov_clf_nest_shade0"))
)

(script static boolean obj_ufinal_11_4
    (and (f_ai_is_partially_defeated "gr_cov_clf_final" 2) (>= s_objcon_clf 130))
)

(script static boolean obj_umissi_11_5
    (and (f_ai_is_defeated "sq_cov_clf_overlook_inf0") (f_ai_is_defeated "sq_cov_clf_overlook_inf1"))
)

(script static boolean obj_umiddl_11_6
    (f_ai_is_defeated "gr_cov_clf_center")
)

(script static boolean obj_uroad__11_11
    (= b_cliffside_road_dropoff true)
)

(script static boolean obj_ucente_11_12
    (and (f_ai_is_defeated "sq_cov_clf_center_shade0") (f_ai_is_defeated "sq_cov_clf_center_inf0"))
)

(script static boolean obj_uroad__11_13
    (and (f_ai_is_defeated "gr_cov_clf_road") (> s_objcon_clf 60))
)

(script static boolean obj_uassau_11_14
    (and (>= s_objcon_clf 110) (<= (ai_strength "gr_cov_clf_nest") 0.3))
)

(script static boolean obj_uadvan_11_15
    (and (f_ai_is_defeated "sq_cov_clf_overlook_inf1") (>= s_objcon_clf 130))
)

(script static boolean obj_ufollo_11_16
    (>= s_objcon_clf 80)
)

(script static boolean obj_ujun_f_12_0
    (>= s_objcon_fld 30)
)

(script static boolean obj_ugate__12_2
    (and (<= (ai_living_count "gr_cov_fld") 0) (f_ai_is_defeated "sq_mule_fld"))
)

(script static boolean obj_ujun_e_12_3
    (volume_test_players "tv_fld_exit")
)

(script static boolean obj_ugate__13_3
    (> (ai_combat_status "gr_cov_set") 4)
)

(script static boolean obj_udefen_13_6
    (= b_set_defense_start true)
)

(script static boolean obj_ufollo_13_8
    (>= s_objcon_set 10)
)

(script static boolean obj_uassau_13_9
    (>= s_objcon_set 30)
)

(script static boolean obj_ubridg_13_10
    (>= s_objcon_set 20)
)

(script static boolean obj_umove__13_11
    (>= s_objcon_set 12)
)

(script static boolean obj_ugate_13_12
    (= b_set_completed true)
)

(script static boolean obj_uadvan_13_13
    (= b_set_unsc_advance true)
)

(script static boolean obj_ucross_13_14
    (and (>= s_objcon_set 30) (f_ai_is_defeated "sq_cov_set_bridge0"))
)

(script static boolean obj_uassau_13_15
    (and (f_ai_is_defeated "sq_cov_set_bridge0") (f_ai_is_defeated "sq_cov_set_ring_grunts0"))
)

(script static boolean obj_uassau_13_16
    (and (f_ai_is_defeated "sq_cov_set_bridge0") (f_ai_is_defeated "sq_cov_set_ring_grunts0") (<= (ai_strength "sq_cov_set_ring_jackals0") 0.5))
)

(script static boolean obj_uassau_13_17
    (>= s_objcon_set 40)
)

(script static boolean obj_ujun_l_15_1
    (= b_slo_jun_leave true)
)

(script static boolean obj_ufollo_15_3
    (and (<= (ai_strength "gr_cov_slo") 0.2) (>= s_objcon_slo 30))
)

(script static boolean obj_fgate__16_10
    (ai_is_alert "gr_cov_fkv")
)

(script static boolean obj_fgate__16_11
    (ai_is_alert "gr_cov_fkv")
)

(script static boolean obj_fgate__16_12
    (ai_is_alert "gr_cov_fkv")
)

(script static boolean obj_mmoas__19_1
    (or (< (ai_strength "sq_amb_pmp_moas0") 1) (volume_test_players "tv_pmp_moas_scare") (volume_test_object "tv_pmp_moas_scare" (ai_get_object ai_jun)))
)

(script static boolean obj_celite_20_13
    (>= s_objcon_slo 30)
)

(script static void ins_start
    (if debug
        (print "insertion point: start")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_insertion_010_020")
    (tick)
    (object_teleport player0 "insertion_spawn_player0")
    (object_teleport player1 "insertion_spawn_player1")
    (object_teleport player2 "insertion_spawn_player2")
    (object_teleport player3 "insertion_spawn_player3")
    (set s_current_insertion_index s_insertion_index_start)
)

(script static void ins_firstkiva
    (if debug
        (print "insertion point: firstkiva")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_insertion_010_020")
    (sleep 1)
    (ovr_cleanup)
    (object_teleport player0 "fl_fkv_player0")
    (object_teleport player1 "fl_fkv_player1")
    (object_teleport player2 "fl_fkv_player2")
    (object_teleport player3 "fl_fkv_player3")
    (music_kill_all)
    (ai_place "unsc_jun/fkv")
    (sleep 1)
    (set s_current_insertion_index s_insertion_index_firstkiva)
    (sleep 1)
)

(script static void ins_silo
    (if debug
        (print "insertion point: silo")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_fields_010_020_025")
    (tick)
    (ovr_cleanup)
    (object_teleport player0 "silo_spawn_player0")
    (object_teleport player1 "silo_spawn_player1")
    (object_teleport player2 "silo_spawn_player2")
    (object_teleport player3 "silo_spawn_player3")
    (music_kill_all)
    (set s_current_insertion_index s_insertion_index_silo)
)

(script static void ins_fields
    (insertion_snap_to_black)
    (if debug
        (print "insertion point: fields")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_canyon_020_025_028")
    (tick)
    (object_teleport player0 "fields_spawn_player0")
    (object_teleport player1 "fields_spawn_player1")
    (object_teleport player2 "fields_spawn_player2")
    (object_teleport player3 "fields_spawn_player3")
    (music_kill_all)
    (set s_current_insertion_index s_insertion_index_fields)
    (sleep 5)
    (wake show_objective_3_insertion)
    (ai_place "unsc_jun/fld")
    (sleep 1)
    (set ai_jun "unsc_jun")
    (insertion_fade_to_gameplay)
)

(script static void ins_pumpstation
    (if debug
        (print "insertion point: pumpstation")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_pumpstation_025_028_030")
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (object_teleport player0 "pumpstation_spawn_player0")
    (object_teleport player1 "pumpstation_spawn_player1")
    (object_teleport player2 "pumpstation_spawn_player2")
    (object_teleport player3 "pumpstation_spawn_player3")
    (music_kill_all)
    (set s_current_insertion_index s_insertion_index_pumpstation)
    (ai_erase "unsc_jun")
    (ai_place "unsc_jun/pumpstation")
    (sleep 1)
    (set ai_jun "unsc_jun")
)

(script static void ins_pumpstation_postcombat
    (if debug
        (print "insertion point: pumpstation")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_river_028_030_035")
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (object_teleport player0 "fl_pmp_postcombat_player0")
    (music_kill_all)
    (object_create_folder "dm_pmp")
    (object_create_folder "cr_pmp")
    (object_create_folder "sc_pmp")
    (ai_place "sq_unsc_pmp_militia0")
    (ai_place "sq_unsc_pmp_militia1")
    (sleep 1)
    (ai_set_objective "gr_militia" "obj_unsc_pmp")
    (ai_place "unsc_jun/pumpstation_postcombat")
    (set ai_jun "unsc_jun")
    (ai_set_objective "unsc_jun" "obj_unsc_pmp")
    (set b_pmp_assault_complete true)
    (pmp_postcombat_control)
)

(script static void ins_pumpstation_postcombat_nomilitia
    (if debug
        (print "insertion point: pumpstation")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_river_028_030_035")
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (object_teleport player0 "fl_pmp_postcombat_player0")
    (music_kill_all)
    (object_create_folder "dm_pmp")
    (object_create_folder "cr_pmp")
    (object_create_folder "sc_pmp")
    (ai_place "unsc_jun/pumpstation_postcombat")
    (set ai_jun "unsc_jun")
    (ai_set_objective "unsc_jun" "obj_unsc_pmp")
    (set b_pmp_assault_complete true)
    (pmp_postcombat_control)
)

(script static void ins_river
    (if debug
        (print "insertion point: river")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_river_028_030_035")
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (pmp_cleanup)
    (object_teleport player0 "river_spawn_player0")
    (object_teleport player1 "river_spawn_player1")
    (object_teleport player2 "river_spawn_player2")
    (object_teleport player3 "river_spawn_player3")
    (music_kill_all)
    (ai_erase "unsc_jun")
    (ai_place "unsc_jun/river")
    (sleep 1)
    (set ai_jun "unsc_jun")
    (ai_erase "unsc_militia")
    (ai_place "unsc_militia/river")
    (set b_pmp_assault_complete true)
    (set s_current_insertion_index s_insertion_index_river)
)

(script static void ins_settlement
    (if debug
        (print "insertion point: settlement")
    )
    (insertion_snap_to_black)
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_settlement_035_040")
    (sleep_until (= (current_zone_set_fully_active) s_zone_index_settlement) 1)
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (pmp_cleanup)
    (rvr_cleanup)
    (object_teleport player0 "settlement_spawn_player0")
    (object_teleport player1 "settlement_spawn_player1")
    (object_teleport player2 "settlement_spawn_player2")
    (object_teleport player3 "settlement_spawn_player3")
    (music_kill_all)
    (set s_current_insertion_index s_insertion_index_settlement)
    (ai_erase "unsc_jun")
    (sleep 1)
    (ai_place "unsc_jun/set")
    (ai_erase "unsc_militia")
    (ai_erase "fireteam_player0")
    (sleep 1)
    (sleep 30)
    (mus_start mus_08)
    (wake show_objective_5_insertion)
    (insertion_fade_to_gameplay)
)

(script static void ins_cliffside
    (if debug
        (print "insertion point: cliffside")
    )
    (if debug
        (print "switching zone sets...")
    )
    (switch_zone_set "set_cliffside_035_040_045")
    (tick)
    (ovr_cleanup)
    (fkv_cleanup)
    (silo_cleanup)
    (fld_cleanup)
    (pmp_cleanup)
    (rvr_cleanup)
    (set_cleanup)
    (object_teleport player0 "cliffside_spawn_player0")
    (object_teleport player1 "cliffside_spawn_player1")
    (object_teleport player2 "cliffside_spawn_player2")
    (object_teleport player3 "cliffside_spawn_player3")
    (music_kill_all)
    (set s_current_insertion_index s_insertion_index_cliffside)
    (ai_erase "unsc_jun")
    (ai_place "unsc_jun/cliffside")
    (sleep 1)
    (set ai_jun "unsc_jun")
    (ai_erase "unsc_militia")
    (ai_place "unsc_militia/cliffside" 2)
)

(script static void test_fkv
    (ai_erase_all)
    (garbage_collect_unsafe)
    (sleep 1)
    (ai_place "sq_cov_fkv_grunts_pistols")
    (ai_place "sq_cov_fkv_jackals0")
    (ai_place "sq_cov_fkv_jackals1")
    (ai_place "sq_cov_fkv_elites0")
    (ai_place "sq_cov_fkv_roof_shade0")
    (ai_place "sq_cov_fkv_ds0")
)

(script static void test_fkv_reinforce
    (ai_place "sq_cov_fkv_reinforce_elites0")
    (ai_place "sq_cov_fkv_reinforce_skirm0")
)

(script static void test_bunkering
    (sleep_until 
        (begin
            (ai_erase_all)
            (garbage_collect_unsafe)
            (ai_reset_objective "obj_cov_pmp")
            (ai_reset_objective "obj_unsc_pmp")
            (object_create_folder_anew "sc_pmp")
            (object_create_folder_anew "cr_pmp")
            (sleep 1)
            (set b_pmp_assault_started true)
            (wake pmp_militia_renew)
            (ai_place "sq_unsc_pmp_militia0")
            (ai_place "sq_unsc_pmp_militia1")
            (ai_place "sq_unsc_pmp_militia2")
            (sleep 120)
            (ai_place "sq_cov_pmp_road_elites0")
            (ai_place "sq_cov_pmp_road_grunts0")
            (ai_place "sq_cov_pmp_road_grunts1")
            (sleep 1)
            (sleep_until (or (<= (ai_living_count "gr_militia") 0) (<= (ai_living_count "gr_cov") 0)))
            false
        )
        1
    )
)

(script static void p010_ins_camp
    (performance_play_line "elite1_goto_ridge")
    (performance_play_line "elite0_goto_ridge")
    (performance_play_line "elite0_talk")
    (performance_play_line "elite1_talk")
)

(script static void p020_ins_mule_ridge
    (performance_play_line "mule_goto_overlook")
    (performance_play_line "mule_roar")
    (performance_play_line "elite_surprise")
    (performance_play_line "elite_goto_ridge")
    (performance_play_line "elite_point_at_mule_0")
    (performance_play_line "elite_shoot_at_mule")
    (performance_play_line "wait_for_dropship")
    (performance_play_line "elite_point_at_mule_1")
    (performance_play_line "mule_run_away")
)

(script static void p030_jun_callout_camp
    (performance_play_line "jun_goto_ridge0")
    (performance_play_line "jun_goto_ridge1")
    (performance_play_line "jun_goto_callout")
    (performance_play_line "jun_play_callout_animation")
)

(script static void p050_jun_callout_kiva
    (performance_play_line "jun_goto_overlook")
    (performance_play_line "jun_play_animation")
)

(script static void p070_mule
    (performance_play_line "mule_goto_start")
    (performance_play_line "elite_goto_start")
    (performance_play_line "jackal_goto_start")
    (performance_play_line "sync_action")
    (set b_fld_mule_intro_complete true)
    (performance_play_line "script_fragment")
)

(script static void p120_set_jun_plant
    (object_create "charges")
    (object_hide "charges" true)
    (performance_play_line "charge_setup")
    (performance_play_line "jun_plant_charges_enters")
    (object_hide "charges" false)
    (performance_play_line "jun_plants_charges_deploy")
    (performance_play_line "jun_plants_charges_loop")
    (performance_play_line "jun_plants_charges_exit")
    (object_destroy "charges")
    (object_create "charges_activated")
    (performance_play_line "swap_charges")
)

(script static void p130_set_gate_breach
    (performance_play_line "jun_move_to_prestack")
    (performance_play_line "jun_move_to_stack")
    (performance_play_line "wait_for_player")
    (sleep_until (volume_test_players "tv_clf_gate"))
    (wake md_clf_jun_opens_gate)
    (performance_play_line "script_jun_dialogue")
    (performance_play_line "jun_open_gate_idle")
    (set b_clf_gate_opened true)
    (performance_play_line "script_gate_open")
    (performance_play_line "lines_8")
)

(script static void thespian_pmp_stash
    (performance_play_line "jun_alert_stance")
    (performance_play_line "jun_goto_stash")
    (performance_play_line "mil0_alert_stance")
    (performance_play_line "mil0_goto_stash")
    (performance_play_line "mil0_look_jun")
    (performance_play_line "script_convo_start")
    (set b_pmp_stash_convo_active true)
    (vs_cast (performance_get_actor "mil0") false 10 "m30_0600")
    (performance_play_line "m30_0600_cv2")
    (performance_play_line "m30_0610_jun")
    (performance_play_line "m30_0620_cv2")
    (sleep_until (not b_pmp_stash_convo_active))
    (performance_play_line "script_wait_for_convo")
)

(script static void thespian_pmp_post
    (performance_play_line "mil0_goto_bridge")
    (performance_play_line "mil1_goto_bridge")
    (performance_play_line "mil2_goto_bridge")
    (performance_play_line "mil3_goto_bridge")
    (performance_play_line "jun_goto_bridge")
    (performance_play_line "mil0_alert_stance")
    (performance_play_line "mil1_alert_stance")
    (performance_play_line "mil2_alert_stance")
    (performance_play_line "mil3_alert_stance")
    (performance_play_line "jun_alert_stance")
    (set b_pmp_post_convo_active true)
    (performance_play_line "script_start_convo")
    (sleep_until (not b_pmp_post_convo_active))
    (performance_play_line "script_sleep_convo_completed")
)

(script static void thespian_pmp_post_nomilitia
    (performance_play_line "jun_goto_bridge")
    (performance_play_line "jun_alert_stance")
    (performance_play_line "jun_idle")
    (set b_pmp_post_convo_active true)
    (performance_play_line "script_start_convo")
    (sleep_until (not b_pmp_post_convo_active))
    (performance_play_line "script_sleep_convo_completed")
)

(script static void thespian_set_elites
    (performance_play_line "elite0_stance_change")
    (performance_play_line "elite1_stance_change")
    (performance_play_line "elite0_goto_dest")
    (performance_play_line "elite1_goto_dest")
    (performance_play_line "elite0_anim_idle")
    (performance_play_line "elite1_anim_idle")
    (sleep_until (and (>= (ai_combat_status "gr_cov_set") 3) (not (thespian_performance_is_blocked))) 1)
    (performance_play_line "sleep_until_alert")
)

(script static void thespian_fkv_general
    (print "thespian performance (thespian_fkv_general) is empty!")
)

(script static void grunt_sleep
    (ai_set_combat_status (performance_get_actor "grunt1") 0)
    (performance_play_line "start_sleeping")
    (performance_play_line "block")
    (performance_play_line "sleep_until")
    (sleep_until (> (ai_combat_status (performance_get_actor "grunt1")) 5))
)

(script static void 030la_recon_010_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "jun_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "sniper_rifle2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "sniper_rifle3_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "phant_1" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 6 "fx_phantom_light_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 7 "sniper_bullet_01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 8 "sniper_bullet_02_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 9 "fx_bro_slide_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 10 "fx_dyn_light_ammo_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 11 "fx_dyn_light_laterz_1" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (object_hide (cinematic_scripting_get_object 0 13) true)
    (object_hide (cinematic_scripting_get_object 0 14) true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_start_effect 0 0 0 (cinematic_object_get "fx_phantom_light"))
    (cinematic_scripting_start_music 0 0 1)
    (sleep 150)
    (cinematic_print "custom script play")
    (cinematic_set_title "030la_cine_timestamp_01")
    (sleep 221)
    (cinematic_scripting_start_music 0 0 0)
    (sleep 77)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "jun_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 "sniper_rifle2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "sniper_rifle3_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 "phant_2" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 6 "fx_phantom_light_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 7 "sniper_bullet_01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 8 "sniper_bullet_02_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 9 "fx_bro_slide_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 10 "fx_dyn_light_ammo_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 11 "fx_dyn_light_laterz_2" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (object_hide (cinematic_scripting_get_object 0 13) true)
    (object_hide (cinematic_scripting_get_object 0 14) true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (cinematic_scripting_start_effect 0 1 0 (cinematic_object_get "fx_phantom_light"))
    (sleep 319)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh3
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 2 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 2)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 0 "jun_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 1 "player_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 2 "sniper_rifle2_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 3 "sniper_rifle3_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 4 "phant_3" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 6 "fx_phantom_light_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 7 "sniper_bullet_01_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 8 "sniper_bullet_02_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 9 "fx_bro_slide_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 10 "fx_dyn_light_ammo_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 11 "fx_dyn_light_laterz_3" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (object_hide (cinematic_scripting_get_object 0 13) true)
    (object_hide (cinematic_scripting_get_object 0 14) true)
    (cinematic_lights_initialize_for_shot 2)
    (cinematic_clips_initialize_for_shot 2)
    (sleep 411)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh4
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 3 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 3)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 0 "jun_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 1 "player_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 2 "sniper_rifle2_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 3 "sniper_rifle3_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 4 "phant_4" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (object_hide (cinematic_scripting_get_object 0 6) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 7 "sniper_bullet_01_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 8 "sniper_bullet_02_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 9 "fx_bro_slide_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 10 "fx_dyn_light_ammo_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 11 "fx_dyn_light_laterz_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 12 "fx_bro_pebbles_4" true)
    (object_hide (cinematic_scripting_get_object 0 13) true)
    (object_hide (cinematic_scripting_get_object 0 14) true)
    (cinematic_lights_initialize_for_shot 3)
    (cinematic_clips_initialize_for_shot 3)
    (sleep 317)
    (cinematic_scripting_start_dialogue 0 3 0 none)
    (sleep 181)
    (cinematic_scripting_start_effect 0 3 0 (cinematic_object_get "fx_bro_pebbles"))
    (sleep 2)
    (cinematic_scripting_start_dialogue 0 3 1 none)
    (sleep 126)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh5
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 4 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 4)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 0 "jun_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 1 "player_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 2 "sniper_rifle2_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 3 "sniper_rifle3_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 4 "phant_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 5 "sniper_mag_5" true)
    (object_hide (cinematic_scripting_get_object 0 6) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 7 "sniper_bullet_01_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 8 "sniper_bullet_02_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 9 "fx_bro_slide_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 10 "fx_dyn_light_ammo_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 11 "fx_dyn_light_laterz_5" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 13 "fx_bropebbles_jun_climb_5" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 4 14 "fx_bropebbles_player_cliff_5" true)
    (cinematic_lights_initialize_for_shot 4)
    (cinematic_clips_initialize_for_shot 4)
    (sleep 49)
    (cinematic_scripting_start_dialogue 0 4 0 none)
    (sleep 46)
    (cinematic_scripting_start_dialogue 0 4 1 none)
    (sleep 170)
    (cinematic_scripting_start_dialogue 0 4 2 none)
    (sleep 179)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh6
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 5 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 5)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 0 "jun_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 1 "player_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 2 "sniper_rifle2_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 3 "sniper_rifle3_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 4 "phant_6" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (object_hide (cinematic_scripting_get_object 0 6) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 7 "sniper_bullet_01_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 8 "sniper_bullet_02_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 9 "fx_bro_slide_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 10 "fx_dyn_light_ammo_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 11 "fx_dyn_light_laterz_6" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 13 "fx_bropebbles_jun_climb_6" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 5 14 "fx_bropebbles_player_cliff_6" true)
    (cinematic_lights_initialize_for_shot 5)
    (cinematic_clips_initialize_for_shot 5)
    (sleep 83)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh7
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 6 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 6)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 0 "jun_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 1 "player_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 2 "sniper_rifle2_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 3 "sniper_rifle3_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 4 "phant_7" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (object_hide (cinematic_scripting_get_object 0 6) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 7 "sniper_bullet_01_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 8 "sniper_bullet_02_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 9 "fx_bro_slide_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 10 "fx_dyn_light_ammo_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 11 "fx_dyn_light_laterz_7" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 13 "fx_bropebbles_jun_climb_7" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 6 14 "fx_bropebbles_player_cliff_7" true)
    (cinematic_lights_initialize_for_shot 6)
    (cinematic_clips_initialize_for_shot 6)
    (sleep 295)
    (cinematic_scripting_start_dialogue 0 6 0 none)
    (sleep 30)
    (cinematic_scripting_start_effect 0 6 2 (cinematic_object_get "fx_bropebbles_player_cliff"))
    (sleep 15)
    (cinematic_scripting_start_effect 0 6 1 (cinematic_object_get "fx_bropebbles_jun_climb"))
    (sleep 25)
    (cinematic_scripting_start_effect 0 6 0 (cinematic_object_get "player"))
    (sleep 16)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon_010_sc_sh8
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 7 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 7)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 0 "jun_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 1 "player_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 2 "sniper_rifle2_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 3 "sniper_rifle3_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 4 "phant_8" true)
    (object_hide (cinematic_scripting_get_object 0 5) true)
    (object_hide (cinematic_scripting_get_object 0 6) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 7 "sniper_bullet_01_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 8 "sniper_bullet_02_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 9 "fx_bro_slide_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 10 "fx_dyn_light_ammo_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 11 "fx_dyn_light_laterz_8" true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 13 "fx_bropebbles_jun_climb_8" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 7 14 "fx_bropebbles_player_cliff_8" true)
    (cinematic_lights_initialize_for_shot 7)
    (cinematic_clips_initialize_for_shot 7)
    (cinematic_scripting_start_effect 0 7 0 (cinematic_object_get "fx_bro_slide"))
    (sleep 62)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !030la_recon_010_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (030la_recon_010_sc_sh1)
    (030la_recon_010_sc_sh2)
    (030la_recon_010_sc_sh3)
    (030la_recon_010_sc_sh4)
    (030la_recon_010_sc_sh5)
    (030la_recon_010_sc_sh6)
    (030la_recon_010_sc_sh7)
    (030la_recon_010_sc_sh8)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 030la_recon_020_sc_sh1
    (cinematic_show_letterbox_immediate false)
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1) 0 "030la_reconwjun_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1) 0)
    (cinematic_object_create_cinematic_anchor "030la_reconwjun_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 0 "fx_bro_slide_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 1 "fx_dyn_light_ammo_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 2 "fx_dyn_light_laterz_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 "fx_phantom_light_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 "jun_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 "phant_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 "player_fp_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 7 "sniper_rifle2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 8 "sniper_rifle3_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 9 "sniper_bullet_01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 10 "sniper_bullet_02_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 11 "sniper_mag_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (sleep 21)
    (cinematic_scripting_start_effect 1 0 0 (cinematic_object_get "player_fp"))
    (sleep 55)
    (sleep (cinematic_tag_fade_out_from_cinematic "030la_recon"))
    (sleep 4)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !030la_recon_020_sc
    (cinematic_print "beginning scene 2")
    (cinematic_scripting_create_scene 1)
    (030la_recon_020_sc_sh1)
    (cinematic_scripting_destroy_scene 1)
)

(script static void 030la_recon_cleanup
    (cinematic_scripting_clean_up 0)
)

(script static void begin_030la_recon_debug
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

(script static void end_030la_recon_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 0)
    (fade_in 0 0 0 0)
)

(script static void 030la_recon_debug
    (begin_030la_recon_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "030la_recon"))
    (!030la_recon_010_sc)
    (!030la_recon_020_sc)
    (end_030la_recon_debug)
)

(script static void begin_030la_recon
    (cinematic_zone_activate 0)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
)

(script static void end_030la_recon
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030la_recon
    (begin_030la_recon)
    (sleep (cinematic_tag_fade_in_to_cinematic "030la_recon"))
    (!030la_recon_010_sc)
    (!030la_recon_020_sc)
    (end_030la_recon)
)

(script static void m30_vista_010_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "030lb_vista_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "030lb_vista_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "jun_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "player_ar1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "sni_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "fx_dyn_light_ledge_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 5 "fx_dyn_light_ambient_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 6 "overlook_army_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 7 "phantom01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 8 "phantom02_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure 1 0)
    (sleep 3)
    (cinematic_scripting_start_music 0 0 0)
    (sleep 208)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void m30_vista_010_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "030lb_vista_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "030lb_vista_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "jun_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 "player_ar1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "sni_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 "fx_dyn_light_ledge_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 5 "fx_dyn_light_ambient_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 6 "overlook_army_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 7 "phantom01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 8 "phantom02_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (render_exposure 1 0)
    (sleep 237)
    (cinematic_scripting_start_music 0 1 0)
    (sleep 12)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void m30_vista_010_sc_sh3
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 2 "030lb_vista_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 2)
    (cinematic_object_create_cinematic_anchor "030lb_vista_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 0 "jun_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 1 "player_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 2 "player_ar1_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 3 "sni_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 4 "fx_dyn_light_ledge_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 5 "fx_dyn_light_ambient_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 6 "overlook_army_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 7 "phantom01_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 8 "phantom02_3" true)
    (cinematic_lights_initialize_for_shot 2)
    (cinematic_clips_initialize_for_shot 2)
    (render_exposure 1 0)
    (sleep 177)
    (cinematic_scripting_start_dialogue 0 2 0 none)
    (sleep 51)
    (cinematic_scripting_start_dialogue 0 2 1 none)
    (sleep 42)
    (cinematic_scripting_start_dialogue 0 2 2 none)
    (sleep 45)
    (cinematic_scripting_start_dialogue 0 2 3 none)
    (sleep 27)
    (cinematic_scripting_start_dialogue 0 2 4 none)
    (sleep 117)
    (cinematic_scripting_start_dialogue 0 2 5 none)
    (sleep 176)
    (cinematic_scripting_start_dialogue 0 2 6 none)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void m30_vista_010_sc_sh4
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 3 "030lb_vista_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 3)
    (cinematic_object_create_cinematic_anchor "030lb_vista_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 0 "jun_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 1 "player_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 2 "player_ar1_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 3 "sni_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 4 "fx_dyn_light_ledge_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 5 "fx_dyn_light_ambient_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 6 "overlook_army_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 7 "phantom01_4" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 3 8 "phantom02_4" true)
    (cinematic_lights_initialize_for_shot 3)
    (cinematic_clips_initialize_for_shot 3)
    (render_exposure 1 0)
    (sleep 116)
    (cinematic_scripting_stop_music 0 3 0)
    (sleep 6)
    (cinematic_scripting_start_dialogue 0 3 0 none)
    (sleep 159)
    (sleep (cinematic_tag_fade_out_from_cinematic "030lb_vista"))
    (sleep 14)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !m30_vista_010_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (m30_vista_010_sc_sh1)
    (m30_vista_010_sc_sh2)
    (m30_vista_010_sc_sh3)
    (m30_vista_010_sc_sh4)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 030lb_vista_cleanup
    (cinematic_scripting_clean_up 1)
)

(script static void begin_030lb_vista_debug
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

(script static void end_030lb_vista_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 1)
    (fade_in 0 0 0 0)
)

(script static void 030lb_vista_debug
    (begin_030lb_vista_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "030lb_vista"))
    (cinematic_outro_start)
    (!m30_vista_010_sc)
    (end_030lb_vista_debug)
)

(script static void begin_030lb_vista
    (cinematic_zone_activate 1)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
)

(script static void end_030lb_vista
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 030lb_vista
    (begin_030lb_vista)
    (sleep (cinematic_tag_fade_in_to_cinematic "030lb_vista"))
    (cinematic_outro_start)
    (!m30_vista_010_sc)
    (end_030lb_vista)
)

(script static void save_ovr_defeated_to_branch_abort
    (= b_slo_started true)
    (branch_abort)
)

(script static void fkv_jetpack_search_control_to_branch_abort
    (>= (ai_combat_status "gr_cov_fkv") 3)
    (branch_abort)
)

(script static void save_fkv_hill_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_center_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_jetpacks_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_garage_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_courtyard_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_encounter_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_fkv_buildings_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void fkv_exit_helper_to_branch_fkv_exit_helper
    (= b_slo_started true)
    (branch_fkv_exit_helper)
)

(script static void fkv_retreat_control_to_branch_abort
    (= b_slo_started true)
    (branch_abort)
)

(script static void save_slo_move_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void save_slo_grind_to_branch_abort
    (= b_fld_started true)
    (branch_abort)
)

(script static void fld_mule_safezone_control_to_branch_abort
    (>= s_objcon_pmp 20)
    (branch_abort)
)

(script static void pmp_assault_main_to_pmp_player_skips_encounter
    (= b_pmp_player_skips_encounter true)
    (pmp_player_skips_encounter)
)

(script static void pmp_postcombat_control_to_pmp_postcombat_abort
    (= b_rvr_started true)
    (pmp_postcombat_abort)
)

(script static void pmp_exit_reminder_to_branch_abort_pmp_exit_reminder
    (= b_rvr_started true)
    (branch_abort_pmp_exit_reminder)
)

(script static void set_save_bridge_to_branch_abort
    (= b_clf_started true)
    (branch_abort)
)

(script static void set_save_hill_dead_to_branch_abort
    (= b_clf_started true)
    (branch_abort)
)

(script static void set_save_initial_dead_to_branch_abort
    (= b_clf_started true)
    (branch_abort)
)

(script static void set_save_left_to_branch_abort
    (= b_clf_started true)
    (branch_abort)
)

(script static void clf_airtraffic_control_to_branch_abort
    (= b_mission_complete true)
    (branch_abort)
)

(script static void md_jun_really_pissed_them_off_to_md_abort
    (= b_slo_started true)
    (md_abort)
)

(script static void md_pmp_cv1_give_us_a_hand_to_md_abort
    (or (<= (ai_living_count "gr_militia") 0) (= b_pmp_assault_started true) (= b_rvr_started true))
    (md_abort)
)

(script static void md_pmp_stash_convo_to_md_pmp_kill_stash_dialogue
    (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0))
    (md_pmp_kill_stash_dialogue)
)

(script static void md_pmp_jun_hydro_civs_alive_to_pmp_postcombat_abort
    (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0) (angry_halo))
    (pmp_postcombat_abort)
)

(script static void md_pmp_jun_hydro_civs_dead_to_md_pmp_postcombat_abort
    (= b_pmp_player_skips_encounter true)
    (md_pmp_postcombat_abort)
)

(script static void md_pmp_jun_theres_the_riverbed_to_md_abort
    (= b_rvr_started true)
    (md_abort)
)

(script static void md_rvr_jun_where_does_riverbed_lead_to_md_pmp_kill_dialogue
    (or (= b_pmp_player_skips_encounter true) (<= (object_get_health (ai_get_object ai_civilian2)) 0))
    (md_pmp_kill_dialogue)
)

(script static void weather_lightning_to_branch_abort
    (= b_mission_complete true)
    (branch_abort)
)

; Decompilation finished in ~0.1316258s
