; Decompiled with Assembly
; 
; Source file: ff10_prototype.hsc
; Start time: 2018-06-28 4:38:05 PM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global boolean debug false)
(global boolean alpha_sync_slayer false)
(global ai gr_survival_phantom none)
(global ai ai_sur_wave_spawns none)
(global ai ai_sur_fireteam_squad0 none)
(global ai ai_sur_fireteam_squad1 none)
(global ai ai_sur_fireteam_squad2 none)
(global ai ai_sur_fireteam_squad3 none)
(global ai ai_sur_fireteam_squad4 none)
(global short s_sur_wave_squad_count 4)
(global device_name obj_sur_generator0 "generator0")
(global device_name obj_sur_generator1 "generator1")
(global device_name obj_sur_generator2 "generator2")
(global device_name obj_sur_generator_switch0 "generator_switch0")
(global device_name obj_sur_generator_switch1 "generator_switch1")
(global device_name obj_sur_generator_switch2 "generator_switch2")
(global device_name obj_sur_generator_switch_cool0 "generator_switch_cool0")
(global device_name obj_sur_generator_switch_cool1 "generator_switch_cool1")
(global device_name obj_sur_generator_switch_cool2 "generator_switch_cool2")
(global device_name obj_sur_generator_switch_dis0 "generator_switch_disabled0")
(global device_name obj_sur_generator_switch_dis1 "generator_switch_disabled1")
(global device_name obj_sur_generator_switch_dis2 "generator_switch_disabled2")
(global object_name obj_ammo_crate "ammo_crate")
(global short k_sur_ai_rand_limit 0)
(global short k_sur_ai_end_limit 0)
(global short k_sur_ai_final_limit 0)
(global short k_sur_squad_per_wave_limit 6)
(global short s_sur_squad_count 0)
(global boolean b_sur_squad_spawn true)
(global short k_sur_rand_wave_count 0)
(global short k_sur_rand_wave_limit 0)
(global boolean b_sur_rand_wave_spawn true)
(global short s_sq_actor_count 0)
(global boolean b_sur_wave_phantom false)
(global short k_sur_wave_per_round_limit 5)
(global short k_sur_round_per_set_limit 3)
(global short k_sur_wave_timer 0)
(global short k_sur_wave_timeout 0)
(global short k_sur_round_timer 0)
(global short k_sur_set_timer 0)
(global short k_sur_bonus_timer 0)
(global boolean b_sur_phantoms_semi_random false)
(global boolean s_sur_dropship_type true)
(global boolean b_sur_bonus_phantom false)
(global boolean b_sur_bonus_ground false)
(global vehicle v_sur_bonus_phantom none)
(global ai ai_sur_bonus_phantom none)
(global boolean b_sur_bonus_round_running false)
(global boolean b_sur_bonus_end false)
(global boolean b_sur_bonus_spawn true)
(global boolean b_sur_bonus_refilling false)
(global boolean b_sur_bonus_phantom_ready false)
(global long l_sur_pre_bonus_points 0)
(global long l_sur_post_bonus_points 0)
(global long k_sur_bonus_points_award 0)
(global short s_sur_bonus_count 0)
(global short k_sur_bonus_squad_limit 6)
(global short k_sur_bonus_limit 17)
(global boolean b_survival_bonus_timer_begin false)
(global short k_survival_bonus_timer (* 30 60 1))
(global vehicle v_sur_phantom_01 none)
(global vehicle v_sur_phantom_02 none)
(global vehicle v_sur_phantom_03 none)
(global vehicle v_sur_phantom_04 none)
(global ai ai_sur_phantom_01 none)
(global ai ai_sur_phantom_02 none)
(global ai ai_sur_phantom_03 none)
(global ai ai_sur_phantom_04 none)
(global string s_sur_drop_side_01 "dual")
(global string s_sur_drop_side_02 "dual")
(global string s_sur_drop_side_03 "dual")
(global string s_sur_drop_side_04 "dual")
(global boolean b_phantom_spawn true)
(global short b_phantom_spawn_count 0)
(global short k_phantom_spawn_limit 2)
(global boolean b_phantom_move_out false)
(global short s_phantom_load_count 1)
(global boolean b_phantom_loaded false)
(global boolean b_survival_new_set true)
(global boolean b_survival_new_round true)
(global boolean b_survival_new_wave true)
(global boolean b_sur_generator_defense_active false)
(global boolean b_sur_generator_defense_fail false)
(global boolean b_sur_generator0_spawned false)
(global boolean b_sur_generator1_spawned false)
(global boolean b_sur_generator2_spawned false)
(global short s_sur_generators_alive 0)
(global real r_sur_generator0_health -1)
(global real r_sur_generator1_health -1)
(global real r_sur_generator2_health -1)
(global short k_surv_generator_cooldown 90)
(global short s_surv_generator0_cooldown 0)
(global short s_surv_generator1_cooldown 0)
(global short s_surv_generator2_cooldown 0)
(global folder folder_survival_scenery "sc_survival")
(global folder folder_survival_crates "cr_survival")
(global folder folder_survival_vehicles "v_survival")
(global folder folder_survival_equipment "eq_survival")
(global folder folder_survival_weapons "wp_survival")
(global folder folder_survival_devices "dc_survival")
(global boolean b_sur_weapon_drop false)
(global looping_sound m_survival_start "firefight\firefight_music\firefight_music01")
(global looping_sound m_new_set "firefight\firefight_music\firefight_music01")
(global looping_sound m_initial_wave "firefight\firefight_music\firefight_music02")
(global looping_sound m_final_wave "firefight\firefight_music\firefight_music20")
(global looping_sound m_pgcr "firefight\firefight_music\firefight_music30")
(global string string_survival_map_name "none")
(global long l_player0_score 0)
(global long l_player1_score 0)
(global long l_player2_score 0)
(global long l_player3_score 0)
(global boolean b_survival_game_end_condition false)
(global boolean b_survival_entered_sudden_death false)
(global long l_sur_round_timer 0)
(global short s_sur_elite_life_monitor 0)
(global short s_sur_gen0_attack_message_cd 0)
(global short s_sur_gen1_attack_message_cd 0)
(global short s_sur_gen2_attack_message_cd 0)
(global ai ai_obj_survival none)
(global ai ai_sur_remaining none)
(global boolean b_debug_phantom false)
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
(global short s_round 65535)
(global boolean g_timer_var false)
(global boolean b_sur_resupply_waypoint_01 false)
(global boolean b_sur_resupply_waypoint_02 false)
(global boolean b_sur_resupply_waypoint_03 false)
(global boolean b_sur_resupply_waypoint_04 false)
(global boolean b_sur_resupply_waypoint_05 false)
(global boolean b_sur_resupply_waypoint_06 false)
(global boolean b_sur_resupply_waypoint_07 false)
(global boolean b_sur_resupply_waypoint_08 false)
(global boolean b_sur_resupply_waypoint_09 false)
(global vehicle v_sq_sur_wraith_01 none)
(global vehicle v_sq_sur_wraith_02 none)
(global boolean b_load_in_phantom false)
(global short g_sur_resupply_limit 0)

; Scripts
(script static void survival_ai_limit
    (if (cinematic_skip_stop)
        (begin
            (set k_sur_ai_rand_limit 6)
            (set k_sur_ai_final_limit 4)
            (set k_sur_ai_end_limit 0)
        )
        (if (cinematic_skip_stop_terminal)
            (begin
                (set k_sur_ai_rand_limit 4)
                (set k_sur_ai_final_limit 3)
                (set k_sur_ai_end_limit 0)
            )
            (if true
                (begin
                    (set k_sur_ai_rand_limit 4)
                    (set k_sur_ai_final_limit 2)
                    (set k_sur_ai_end_limit 0)
                )
            )
        )
    )
)

(script static void survival_ai_timeout
    (if (cinematic_skip_stop)
        (set k_sur_wave_timeout (* 30 10))
        (if (cinematic_skip_stop_terminal)
            (set k_sur_wave_timeout (* 30 20))
            (if true
                (set k_sur_wave_timeout (* 30 30))
            )
        )
    )
)

(script static void survival_wave_timer
    (if (cinematic_skip_stop)
        (set k_sur_wave_timer (* 30 3))
        (if (cinematic_skip_stop_terminal)
            (set k_sur_wave_timer (* 30 6))
            (if true
                (set k_sur_wave_timer (* 30 9))
            )
        )
    )
)

(script static void survival_round_timer
    (if (cinematic_skip_stop)
        (set k_sur_round_timer (* 30 5))
        (if (cinematic_skip_stop_terminal)
            (set k_sur_round_timer (* 30 10))
            (if true
                (set k_sur_round_timer (* 30 15))
            )
        )
    )
)

(script static void survival_set_timer
    (if (cinematic_skip_stop)
        (set k_sur_set_timer (* 30 10))
        (if (cinematic_skip_stop_terminal)
            (set k_sur_set_timer (* 30 20))
            (if true
                (set k_sur_set_timer (* 30 30))
            )
        )
    )
)

(script static void survival_bonus_wait_timer
    (if (cinematic_skip_stop)
        (set k_sur_bonus_timer (* 30 5))
        (if (cinematic_skip_stop_terminal)
            (set k_sur_bonus_timer (* 30 10))
            (if true
                (set k_sur_bonus_timer (* 30 15))
            )
        )
    )
)

(script dormant void survival_license_plate
    (survival_mode_set_elite_license_plate 23 23 "sur_game_name" "sur_cov_game_desc" "sur_cov_game_desc")
    (survival_mode_set_spartan_license_plate 23 23 "sur_game_name" "sur_unsc_game_desc" "sur_unsc_game_desc")
)

(script dormant void survival_mode
    (ai_allegiance human player)
    (ai_allegiance player human)
    (ai_allegiance covenant covenant_player)
    (ai_allegiance covenant_player covenant)
    (loadout_team_set_loadout_palette player "unsc_firefight")
    (loadout_team_set_loadout_palette covenant_player "covy_firefight")
    (if (not alpha_sync_slayer)
        (sound_looping_start m_survival_start none 1)
    )
    (survival_ai_limit)
    (survival_wave_timer)
    (survival_round_timer)
    (survival_set_timer)
    (survival_bonus_wait_timer)
    (survival_ai_timeout)
    (survival_set_multiplier)
    (if (> (survival_mode_generator_count) 0)
        (wake survival_mode_generator_defense)
    )
    (object_create_folder_anew folder_survival_scenery)
    (object_create_folder_anew folder_survival_crates)
    (object_create_folder_anew folder_survival_vehicles)
    (object_create_folder_anew folder_survival_equipment)
    (sleep 1)
    (garbage_collect_now)
    (sleep (* 30 3))
    (if (> (f_coop_resume_unlocked) 0)
        (f_start_mission)
    )
    (wake survival_license_plate)
    (sleep (* 30 2))
    (event_survival_2_ai_remaining)
    (sleep (* 30 2))
    (wake survival_lives_announcement)
    (wake survival_award_achievement)
    (wake survival_bonus_round_end)
    (wake survival_end_game)
    (wake survival_elite_manager)
    (wake survival_ammo_crate_waypoint)
    (if alpha_sync_slayer
        (wake survival_slayer_medpack_respawner)
    )
    (sleep (* 30 3))
    (if (not alpha_sync_slayer)
        (sound_looping_stop m_survival_start)
    )
    (if (not alpha_sync_slayer)
        (sleep_until 
            (begin
                (if debug
                    (print "beginning new set")
                )
                (survival_mode_begin_new_set)
                (sleep 1)
                (survival_mode_generator_defense)
                (players_human_living_count)
                (survival_wave_loop)
                (survival_mode_wave_music_start)
                (event_welcome)
                (set b_survival_new_set true)
                (sleep k_sur_set_timer)
                false
            )
            1
        )
    )
)

(script dormant void survival_slayer_medpack_respawner
    (sleep_until 
        (begin
            (sleep 1800)
            (object_create_folder folder_survival_devices)
            false
        )
    )
)

(script static void survival_wave_loop
    (if debug
        (print "resetting wave variables...")
    )
    (set b_sur_rand_wave_spawn true)
    (set k_sur_rand_wave_count 0)
    (sleep_until 
        (begin
            (survival_mode_begin_new_wave)
            (if (survival_mode_current_wave_is_initial)
                (begin
                    (survival_award_achievement)
                    (survival_mode_generator_defense)
                    (sleep 1)
                    (if (> (survival_mode_set_get) 1)
                        (survival_mode_wave_music_stop)
                    )
                )
            )
            (survival_wave_spawn)
            (if (survival_mode_current_wave_is_initial)
                (begin
                    (print "completed an initial wave")
                )
            )
            (if (survival_mode_current_wave_is_boss)
                (begin
                    (set b_survival_new_round true)
                    (player_human)
                    (survival_vehicle_cleanup)
                    (event_welcome)
                    (if (< (survival_mode_round_get) k_sur_round_per_set_limit)
                        (begin
                            (survival_mode_wave_music_start)
                            (sleep k_sur_round_timer)
                        )
                    )
                )
            )
            (and (>= (survival_mode_round_get) 2) (>= (survival_mode_wave_get) 4))
        )
        1
    )
    (sleep k_sur_bonus_timer)
    (survival_bonus_round)
)

(script static void survival_wave_spawn
    (if debug
        (print "spawn wave...")
    )
    (survival_like_marty_start)
    (add_recycling_volume "tv_sur_garbage_all" 30 10)
    (survival_mode_generator_defense)
    (sleep 1)
    (ai_reset_objective ai_obj_survival)
    (if (players_elite_living_count)
        (wave_squad_get)
    )
    (ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
    (sleep 1)
    (if (players_elite_living_count)
        (survival_countdown_timer)
    )
    (set b_phantom_move_out true)
    (sleep_until (<= (ai_living_count gr_survival_phantom) (* k_phantom_spawn_limit 4)) 1)
    (survival_wave_end_conditions)
    (ai_migrate "gr_survival_all" ai_sur_remaining)
    (survival_generator_switch)
    (set b_survival_new_wave true)
    (set b_sur_wave_phantom false)
    (set b_phantom_move_out false)
    (set s_phantom_load_count 1)
    (if (< (survival_mode_wave_get) k_sur_wave_per_round_limit)
        (sleep k_sur_wave_timer)
    )
    (survival_like_marty_award)
)

(script static void survival_wave_end_conditions
    (sleep_until (and (<= (object_get_health v_sur_phantom_01) 0) (<= (object_get_health v_sur_phantom_02) 0) (<= (object_get_health v_sur_phantom_03) 0) (<= (object_get_health v_sur_phantom_04) 0)))
    (sleep_until (< (ai_living_count "gr_survival_all") 7))
    (survival_kill_volumes_on)
    (ai_survival_cleanup "gr_survival_all" true true)
    (ai_survival_cleanup "gr_survival_extras" true true)
    (if (= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 2))
        (begin
            (sleep_until (<= (ai_living_count "gr_survival_all") k_sur_ai_final_limit))
        )
        (if (>= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 1))
            (begin
                (sleep_until (<= (ai_living_count "gr_survival_all") 5))
                (if (= (ai_living_count "gr_survival_all") 5)
                    (event_survival_bonus_round)
                    (sleep 30)
                )
                (sound_looping_set_alternate m_final_wave true)
                (sleep_until (<= (ai_living_count "gr_survival_all") 2))
                (if (= (ai_living_count "gr_survival_all") 2)
                    (event_survival_bonus_round_over)
                    (sleep 30)
                )
                (sleep_until (<= (ai_living_count "gr_survival_all") 1))
                (if (= (ai_living_count "gr_survival_all") 1)
                    (event_survival_bonus_lives_awarded)
                    (sleep 30)
                )
                (sleep_until (<= (ai_living_count "gr_survival_all") 0))
            )
            (if true
                (begin
                    (sleep_until (<= (ai_living_count "gr_survival_all") k_sur_ai_rand_limit))
                )
            )
        )
    )
    (survival_kill_volumes_off)
    (ai_survival_cleanup "gr_survival_all" false false)
    (ai_survival_cleanup "gr_survival_extras" false false)
)

(script static void survival_kill_volumes_on
    (kill_volume_enable "kill_sur_room_01")
    (kill_volume_enable "kill_sur_room_02")
    (kill_volume_enable "kill_sur_room_03")
    (kill_volume_enable "kill_sur_room_04")
    (kill_volume_enable "kill_sur_room_05")
    (kill_volume_enable "kill_sur_room_06")
    (kill_volume_enable "kill_sur_room_07")
    (kill_volume_enable "kill_sur_room_08")
)

(script static void survival_kill_volumes_off
    (kill_volume_disable "kill_sur_room_01")
    (kill_volume_disable "kill_sur_room_02")
    (kill_volume_disable "kill_sur_room_03")
    (kill_volume_disable "kill_sur_room_04")
    (kill_volume_disable "kill_sur_room_05")
    (kill_volume_disable "kill_sur_room_06")
    (kill_volume_disable "kill_sur_room_07")
    (kill_volume_disable "kill_sur_room_08")
)

(script static void survival_bonus_round
    (if debug
        (print "** start bonus round **")
    )
    (set b_sur_bonus_round_running true)
    (ai_kill_no_statistics "gr_survival_extras")
    (set l_sur_pre_bonus_points (f_survival_phantom_spawner))
    (survival_mode_begin_new_wave)
    (survival_bonus_round_limit)
    (chud_bonus_round_set_timer (/ k_survival_bonus_timer 30))
    (chud_bonus_round_show_timer true)
    (event_survival_better_luck_next_time)
    (sleep 150)
    (sleep 60)
    (ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
    (sleep 1)
    (set s_sur_bonus_count 0)
    (set b_sur_bonus_spawn true)
    (set k_sur_bonus_squad_limit 1)
    (set b_survival_bonus_timer_begin true)
    (set b_sur_bonus_refilling true)
    (sleep_until 
        (begin
            (sleep_until (or b_sur_bonus_end (<= (ai_living_count ai_sur_wave_spawns) k_sur_bonus_limit) (survival_elite_life_monitor)) 1)
            (if (and (not (survival_elite_life_monitor)) (not b_sur_bonus_end))
                (begin
                    (ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns 1)
                    (set s_sur_bonus_count 0)
                    (set b_sur_bonus_spawn true)
                )
            )
            (or b_sur_bonus_end (survival_elite_life_monitor))
        )
        1
    )
    (ai_kill_no_statistics ai_sur_wave_spawns)
    (sleep 90)
    (event_survival_new_set)
    (survival_mode_respawn_dead_players)
    (sleep 30)
    (sleep 120)
    (set l_sur_post_bonus_points (f_survival_phantom_spawner))
    (if (>= (- l_sur_post_bonus_points l_sur_pre_bonus_points) k_sur_bonus_points_award)
        (begin
            (event_survival_new_round)
            (wave_dropship_enabled)
        )
        (begin
            (event_survival_reinforcements)
        )
    )
    (chud_bonus_round_set_timer 0)
    (chud_bonus_round_show_timer false)
    (chud_bonus_round_start_timer false)
    (set b_sur_bonus_end false)
    (set k_sur_bonus_squad_limit 6)
    (set b_sur_bonus_phantom_ready false)
    (set b_sur_bonus_refilling false)
    (set b_sur_bonus_round_running false)
)

(script dormant void survival_bonus_round_end
    (sleep_until 
        (begin
            (sleep_until b_survival_bonus_timer_begin 1)
            (chud_bonus_round_start_timer true)
            (sleep_until (survival_elite_life_monitor) 1 k_survival_bonus_timer)
            (set b_sur_bonus_end true)
            (if (survival_elite_life_monitor)
                (begin
                    (chud_bonus_round_start_timer false)
                    (chud_bonus_round_set_timer 0)
                )
            )
            (set b_survival_bonus_timer_begin false)
            false
        )
        1
    )
)

(script static void survival_bonus_round_limit
    (if (cinematic_snap_to_white)
        (begin
            (if (>= (survival_mode_set_get) 5)
                (set k_sur_bonus_points_award 24000)
            )
            (if (= (survival_mode_set_get) 4)
                (set k_sur_bonus_points_award 20000)
            )
            (if (= (survival_mode_set_get) 3)
                (set k_sur_bonus_points_award 16000)
            )
            (if (= (survival_mode_set_get) 2)
                (set k_sur_bonus_points_award 12000)
            )
            (if (<= (survival_mode_set_get) 1)
                (set k_sur_bonus_points_award 8000)
            )
        )
        (if (cinematic_snap_to_black)
            (begin
                (if (>= (survival_mode_set_get) 5)
                    (set k_sur_bonus_points_award 18000)
                )
                (if (= (survival_mode_set_get) 4)
                    (set k_sur_bonus_points_award 15000)
                )
                (if (= (survival_mode_set_get) 3)
                    (set k_sur_bonus_points_award 12000)
                )
                (if (= (survival_mode_set_get) 2)
                    (set k_sur_bonus_points_award 9000)
                )
                (if (<= (survival_mode_set_get) 1)
                    (set k_sur_bonus_points_award 6000)
                )
            )
            (if (cinematic_exit)
                (begin
                    (if (>= (survival_mode_set_get) 5)
                        (set k_sur_bonus_points_award 12000)
                    )
                    (if (= (survival_mode_set_get) 4)
                        (set k_sur_bonus_points_award 10000)
                    )
                    (if (= (survival_mode_set_get) 3)
                        (set k_sur_bonus_points_award 8000)
                    )
                    (if (= (survival_mode_set_get) 2)
                        (set k_sur_bonus_points_award 6000)
                    )
                    (if (<= (survival_mode_set_get) 1)
                        (set k_sur_bonus_points_award 4000)
                    )
                )
                (if true
                    (begin
                        (if (>= (survival_mode_set_get) 5)
                            (set k_sur_bonus_points_award 6000)
                        )
                        (if (= (survival_mode_set_get) 4)
                            (set k_sur_bonus_points_award 5000)
                        )
                        (if (= (survival_mode_set_get) 3)
                            (set k_sur_bonus_points_award 4000)
                        )
                        (if (= (survival_mode_set_get) 2)
                            (set k_sur_bonus_points_award 3000)
                        )
                        (if (<= (survival_mode_set_get) 1)
                            (set k_sur_bonus_points_award 2000)
                        )
                    )
                )
            )
        )
    )
    (sleep 1)
)

(script static void (f_survival_bonus_spawner (ai spawned_squad))
    (ai_place spawned_squad)
    (sleep 1)
    (ai_force_active spawned_squad true)
    (if (> (ai_living_count spawned_squad) 0)
        (begin
            (if debug
                (print "spawn squad...")
            )
            (set s_sur_bonus_count (+ s_sur_bonus_count 1))
            (if (>= s_sur_bonus_count k_sur_bonus_squad_limit)
                (set b_sur_bonus_spawn false)
            )
            (sleep 1)
            (if b_sur_bonus_refilling
                (if (and b_sur_bonus_ground b_sur_bonus_phantom)
                    (if (= (random_range 0 2) 0)
                        (survival_total_score v_sur_bonus_phantom spawned_squad)
                    )
                    (if b_sur_bonus_phantom
                        (survival_total_score v_sur_bonus_phantom spawned_squad)
                    )
                )
                (if b_sur_bonus_phantom
                    (survival_total_score v_sur_bonus_phantom spawned_squad)
                )
            )
        )
    )
)

(script static long survival_total_score
    (+ (campaign_metagame_get_player_score (survival_mode_add_human_lives 0)) (campaign_metagame_get_player_score (survival_mode_add_human_lives 1)) (campaign_metagame_get_player_score (survival_mode_add_human_lives 2)) (campaign_metagame_get_player_score (survival_mode_add_human_lives 3)) (campaign_metagame_get_player_score (survival_mode_add_human_lives 4)) (campaign_metagame_get_player_score (survival_mode_add_human_lives 5)))
)

(script static void survival_phantom_spawner
    (sleep_until 
        (begin
            (if b_sur_phantoms_semi_random
                (begin_random
                    (begin
                        (if b_phantom_spawn
                            (wave_squad_get_count ai_sur_phantom_01)
                        )
                        (if b_phantom_spawn
                            (wave_squad_get_count ai_sur_phantom_02)
                        )
                    )
                    (begin
                        (if b_phantom_spawn
                            (wave_squad_get_count ai_sur_phantom_03)
                        )
                        (if b_phantom_spawn
                            (wave_squad_get_count ai_sur_phantom_04)
                        )
                    )
                )
                (begin_random
                    (if b_phantom_spawn
                        (wave_squad_get_count ai_sur_phantom_01)
                    )
                    (if b_phantom_spawn
                        (wave_squad_get_count ai_sur_phantom_02)
                    )
                    (if b_phantom_spawn
                        (wave_squad_get_count ai_sur_phantom_03)
                    )
                    (if b_phantom_spawn
                        (wave_squad_get_count ai_sur_phantom_04)
                    )
                )
            )
            (= b_phantom_spawn false)
        )
        1
    )
    (set b_phantom_spawn true)
    (set b_phantom_spawn_count 0)
    (sleep 1)
)

(script static void (f_survival_phantom_spawner (ai spawned_phantom))
    (ai_place spawned_phantom)
    (sleep 1)
    (ai_force_active spawned_phantom true)
    (if (> (object_get_health spawned_phantom) 0)
        (begin
            (if debug
                (print "spawn phantom...")
            )
            (set b_phantom_spawn_count (+ b_phantom_spawn_count 1))
            (if (>= b_phantom_spawn_count k_phantom_spawn_limit)
                (set b_phantom_spawn false)
            )
        )
    )
)

(script static ai (wave_squad_get (short index))
    (if (<= index (ai_squad_group_get_squad_count ai_sur_wave_spawns))
        (ai_squad_group_get_squad ai_sur_wave_spawns index)
        none
    )
)

(script static short (wave_squad_get_count (short index))
    (if (<= index (ai_squad_group_get_squad_count ai_sur_wave_spawns))
        (ai_living_count (ai_squad_group_get_squad ai_sur_wave_spawns index))
        0
    )
)

(script static void survival_dropship_loader
    (if (> (f_survival_phantom_loader 0) 0)
        (survival_begin_announcer (survival_dropship_loader 0))
    )
    (if (> (f_survival_phantom_loader 1) 0)
        (survival_begin_announcer (survival_dropship_loader 1))
    )
    (if (> (f_survival_phantom_loader 2) 0)
        (survival_begin_announcer (survival_dropship_loader 2))
    )
    (if (> (f_survival_phantom_loader 3) 0)
        (survival_begin_announcer (survival_dropship_loader 3))
    )
    (if (> (f_survival_phantom_loader 4) 0)
        (survival_begin_announcer (survival_dropship_loader 4))
    )
    (if (> (f_survival_phantom_loader 5) 0)
        (survival_begin_announcer (survival_dropship_loader 5))
    )
    (if (> (f_survival_phantom_loader 6) 0)
        (survival_begin_announcer (survival_dropship_loader 6))
    )
    (if (> (f_survival_phantom_loader 7) 0)
        (survival_begin_announcer (survival_dropship_loader 7))
    )
    (if (> (f_survival_phantom_loader 8) 0)
        (survival_begin_announcer (survival_dropship_loader 8))
    )
    (if (> (f_survival_phantom_loader 9) 0)
        (survival_begin_announcer (survival_dropship_loader 9))
    )
    (if (> (f_survival_phantom_loader 10) 0)
        (survival_begin_announcer (survival_dropship_loader 10))
    )
    (if (> (f_survival_phantom_loader 11) 0)
        (survival_begin_announcer (survival_dropship_loader 11))
    )
)

(script static void (f_survival_phantom_loader (ai load_squad))
    (sleep_until 
        (begin
            (if (and (= b_phantom_loaded false) (= s_phantom_load_count 1))
                (begin
                    (if (> (object_get_health v_sur_phantom_01) 0)
                        (begin
                            (if debug
                                (print "** load phantom 01 **")
                            )
                            (survival_end_announcer v_sur_phantom_01 s_sur_drop_side_01 load_squad)
                        )
                    )
                    (set s_phantom_load_count 2)
                )
            )
            (if (and (= b_phantom_loaded false) (= s_phantom_load_count 2))
                (begin
                    (if (> (object_get_health v_sur_phantom_02) 0)
                        (begin
                            (if debug
                                (print "** load phantom 02 **")
                            )
                            (survival_end_announcer v_sur_phantom_02 s_sur_drop_side_02 load_squad)
                        )
                    )
                    (set s_phantom_load_count 3)
                )
            )
            (if (and (= b_phantom_loaded false) (= s_phantom_load_count 3))
                (begin
                    (if (> (object_get_health v_sur_phantom_03) 0)
                        (begin
                            (if debug
                                (print "** load phantom 03 **")
                            )
                            (survival_end_announcer v_sur_phantom_03 s_sur_drop_side_03 load_squad)
                        )
                    )
                    (set s_phantom_load_count 4)
                )
            )
            (if (and (= b_phantom_loaded false) (= s_phantom_load_count 4))
                (begin
                    (if (> (object_get_health v_sur_phantom_04) 0)
                        (begin
                            (if debug
                                (print "** load phantom 04 **")
                            )
                            (survival_end_announcer v_sur_phantom_04 s_sur_drop_side_04 load_squad)
                        )
                    )
                    (set s_phantom_load_count 1)
                )
            )
            b_phantom_loaded
        )
        1
    )
    (set b_phantom_loaded false)
)

(script static void survival_countdown_timer
    (sound_impulse_start none none 1)
    (sleep 30)
    (sound_impulse_start none none 1)
    (sleep 30)
    (sound_impulse_start none none 1)
    (sleep 30)
    (sound_impulse_start none none 1)
    (sleep 30)
)

(script static void survival_begin_announcer
    (if b_survival_new_set
        (begin
            (if debug
                (print "announce new set...")
            )
            (survival_lives_announcement)
            (event_survival_end_round)
            (set b_survival_new_set false)
            (set b_survival_new_round false)
            (set b_survival_new_wave false)
        )
        (if b_survival_new_round
            (begin
                (if debug
                    (print "announce new round...")
                )
                (survival_lives_announcement)
                (event_survival_end_set)
                (set b_survival_new_round false)
                (set b_survival_new_wave false)
            )
            (if b_survival_new_wave
                (begin
                    (if debug
                        (print "announce new wave...")
                    )
                    (if (> (survival_mode_wave_get) 0)
                        (begin
                            (survival_mode_award_hero_medal)
                            (sleep 1)
                            (event_survival_sudden_death)
                            (survival_mode_respawn_dead_players)
                            (sleep (* (random_range 3 5) 30))
                        )
                    )
                )
            )
        )
    )
    (sleep 5)
)

(script static void survival_end_announcer
    (if (< (survival_mode_wave_get) k_sur_wave_per_round_limit)
        (begin
            (if debug
                (print "announce end wave...")
            )
        )
        (if (< (survival_mode_round_get) k_sur_round_per_set_limit)
            (begin
                (sleep (* 30 5))
                (if debug
                    (print "announce end round...")
                )
                (event_survival_sudden_death_over)
                (sleep (* 30 3))
            )
            (if true
                (begin
                    (sleep (* 30 5))
                    (if debug
                        (print "announce end set...")
                    )
                    (event_survival_5_lives_left)
                    (ai_kill_no_statistics "gr_survival_extras")
                    (sleep (* 30 3))
                )
            )
        )
    )
)

(script dormant void survival_lives_announcement
    (sleep_until 
        (begin
            (sleep_until (> (survival_mode_lives_get player) 0) 1)
            (sleep_until (<= (survival_mode_lives_get player) 5) 1)
            (if (= (survival_mode_lives_get player) 5)
                (begin
                    (if debug
                        (print "5 lives left...")
                    )
                    (event_survival_last_man_standing)
                )
            )
            (sleep_until (or (<= (survival_mode_lives_get player) 1) (> (survival_mode_lives_get player) 5)) 1)
            (if (= (survival_mode_lives_get player) 1)
                (begin
                    (if debug
                        (print "1 life left...")
                    )
                    (event_survival_awarded_weapon)
                )
            )
            (sleep_until (or (<= (survival_mode_lives_get player) 0) (> (survival_mode_lives_get player) 1)) 1)
            (if (<= (survival_mode_lives_get player) 0)
                (begin
                    (if debug
                        (print "0 lives left...")
                    )
                    (event_survival_round_over)
                )
            )
            (sleep_until (or (<= (player_elite) 1) (> (survival_mode_lives_get player) 0)) 1)
            (if (and (<= (survival_mode_lives_get player) 0) (= (player_elite) 1))
                (begin
                    (if debug
                        (print "last man standing...")
                    )
                    (event_survival_game_over)
                )
            )
            false
        )
    )
)

(script dormant void survival_mode_generator_defense
    (set b_sur_generator_defense_active true)
    (survival_respawn_weapons)
    (sleep 1)
    (wake survival_generator0_management)
    (wake survival_generator1_management)
    (wake survival_generator2_management)
    (if b_sur_generator0_spawned
        (begin
            (ai_object_set_team obj_sur_generator0 player)
            (ai_object_set_targeting_bias obj_sur_generator0 0.25)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator0 false)
            (object_set_allegiance obj_sur_generator0 player)
            (object_immune_to_friendly_damage obj_sur_generator0 true)
        )
    )
    (if b_sur_generator1_spawned
        (begin
            (ai_object_set_team obj_sur_generator1 player)
            (ai_object_set_targeting_bias obj_sur_generator1 0.25)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator1 false)
            (object_set_allegiance obj_sur_generator1 player)
            (object_immune_to_friendly_damage obj_sur_generator1 true)
        )
    )
    (if b_sur_generator2_spawned
        (begin
            (ai_object_set_team obj_sur_generator2 player)
            (ai_object_set_targeting_bias obj_sur_generator2 0.25)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator2 false)
            (object_set_allegiance obj_sur_generator2 player)
            (object_immune_to_friendly_damage obj_sur_generator2 true)
        )
    )
    (sleep_until 
        (begin
            (if (< (object_get_health obj_sur_generator0) r_sur_generator0_health)
                (event_survival_generator0_locked)
            )
            (if (< (object_get_health obj_sur_generator1) r_sur_generator1_health)
                (event_survival_generator1_locked)
            )
            (if (< (object_get_health obj_sur_generator2) r_sur_generator2_health)
                (event_survival_generator2_locked)
            )
            (set r_sur_generator0_health (object_get_health obj_sur_generator0))
            (set r_sur_generator1_health (object_get_health obj_sur_generator1))
            (set r_sur_generator2_health (object_get_health obj_sur_generator2))
            (if (< (surival_set_music) s_sur_generators_alive)
                (begin
                    (event_survival_end_time)
                )
            )
            (set s_sur_generators_alive (surival_set_music))
            (not (survival_respawn_crates))
        )
        3
    )
    (set b_sur_generator_defense_fail true)
)

(script static void (survival_generator_switch (short switch, short state))
    (if (= switch 0)
        (if (= state 0)
            (begin
                (device_set_power obj_sur_generator_switch0 0)
                (device_set_power obj_sur_generator_switch_cool0 0)
                (device_set_power obj_sur_generator_switch_dis0 0)
            )
            (if (= state 1)
                (begin
                    (device_set_power obj_sur_generator_switch0 1)
                    (device_set_power obj_sur_generator_switch_cool0 0)
                    (device_set_power obj_sur_generator_switch_dis0 0)
                )
                (if (= state 2)
                    (begin
                        (device_set_power obj_sur_generator_switch0 0)
                        (device_set_power obj_sur_generator_switch_cool0 1)
                        (device_set_power obj_sur_generator_switch_dis0 0)
                    )
                    (if (= state 3)
                        (begin
                            (device_set_power obj_sur_generator_switch0 0)
                            (device_set_power obj_sur_generator_switch_cool0 0)
                            (device_set_power obj_sur_generator_switch_dis0 1)
                        )
                    )
                )
            )
        )
    )
    (if (= switch 1)
        (if (= state 0)
            (begin
                (device_set_power obj_sur_generator_switch1 0)
                (device_set_power obj_sur_generator_switch_cool1 0)
                (device_set_power obj_sur_generator_switch_dis1 0)
            )
            (if (= state 1)
                (begin
                    (device_set_power obj_sur_generator_switch1 1)
                    (device_set_power obj_sur_generator_switch_cool1 0)
                    (device_set_power obj_sur_generator_switch_dis1 0)
                )
                (if (= state 2)
                    (begin
                        (device_set_power obj_sur_generator_switch1 0)
                        (device_set_power obj_sur_generator_switch_cool1 1)
                        (device_set_power obj_sur_generator_switch_dis1 0)
                    )
                    (if (= state 3)
                        (begin
                            (device_set_power obj_sur_generator_switch1 0)
                            (device_set_power obj_sur_generator_switch_cool1 0)
                            (device_set_power obj_sur_generator_switch_dis1 1)
                        )
                    )
                )
            )
        )
    )
    (if (= switch 2)
        (if (= state 0)
            (begin
                (device_set_power obj_sur_generator_switch2 0)
                (device_set_power obj_sur_generator_switch_cool2 0)
                (device_set_power obj_sur_generator_switch_dis2 0)
            )
            (if (= state 1)
                (begin
                    (device_set_power obj_sur_generator_switch2 1)
                    (device_set_power obj_sur_generator_switch_cool2 0)
                    (device_set_power obj_sur_generator_switch_dis2 0)
                )
                (if (= state 2)
                    (begin
                        (device_set_power obj_sur_generator_switch2 0)
                        (device_set_power obj_sur_generator_switch_cool2 1)
                        (device_set_power obj_sur_generator_switch_dis2 0)
                    )
                    (if (= state 3)
                        (begin
                            (device_set_power obj_sur_generator_switch2 0)
                            (device_set_power obj_sur_generator_switch_cool2 0)
                            (device_set_power obj_sur_generator_switch_dis2 1)
                        )
                    )
                )
            )
        )
    )
)

(script dormant void survival_generator0_man_old
    (sleep_until 
        (begin
            (if (> (object_get_health obj_sur_generator0) 0)
                (if (> (device_get_position obj_sur_generator0) 0.1)
                    (begin
                        (event_survival_spartans_win)
                        (survival_generator1_management 0 0)
                        (ai_object_set_targeting_bias obj_sur_generator0 -1)
                        (sleep_until (< (device_get_position obj_sur_generator0) 0.1) 5)
                    )
                    (begin
                        (ai_object_set_targeting_bias obj_sur_generator0 0.75)
                        (survival_generator1_management 0 2)
                        (sleep 90)
                        (if (not b_survival_entered_sudden_death)
                            (survival_generator1_management 0 1)
                            (survival_generator1_management 0 3)
                        )
                        (sleep_until (> (device_get_position obj_sur_generator0) 0.1) 10)
                    )
                )
            )
            (<= (object_get_health obj_sur_generator0) 0)
        )
        5
    )
    (begin
        (object_cannot_take_damage obj_sur_generator0)
        (survival_generator1_management 0 0)
        (ai_object_set_targeting_bias obj_sur_generator0 -1)
    )
)

(script dormant void survival_generator0_management
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator0) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator0 0.75)
                    (if b_survival_entered_sudden_death
                        (survival_generator1_management 0 3)
                        (if (> s_surv_generator0_cooldown 0)
                            (begin
                                (survival_generator1_management 0 2)
                                (sleep s_surv_generator0_cooldown)
                                (set s_surv_generator0_cooldown 0)
                            )
                            (survival_generator1_management 0 1)
                        )
                    )
                )
                (begin
                    (event_survival_spartans_win)
                    (survival_generator1_management 0 0)
                    (ai_object_set_targeting_bias obj_sur_generator0 -1)
                    (sleep_until (< (device_get_position obj_sur_generator0) 0.1) 5)
                    (set s_surv_generator0_cooldown k_surv_generator_cooldown)
                )
            )
            (<= (object_get_health obj_sur_generator0) 0)
        )
        5
    )
    (begin
        (object_cannot_take_damage obj_sur_generator0)
        (survival_generator1_management 0 0)
        (ai_object_set_targeting_bias obj_sur_generator0 -1)
    )
)

(script dormant void survival_generator1_management
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator1) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator1 0.75)
                    (if b_survival_entered_sudden_death
                        (survival_generator1_management 1 3)
                        (if (> s_surv_generator1_cooldown 0)
                            (begin
                                (survival_generator1_management 1 2)
                                (sleep s_surv_generator1_cooldown)
                                (set s_surv_generator1_cooldown 0)
                            )
                            (survival_generator1_management 1 1)
                        )
                    )
                )
                (begin
                    (event_survival_elites_win)
                    (survival_generator1_management 1 0)
                    (ai_object_set_targeting_bias obj_sur_generator1 -1)
                    (sleep_until (< (device_get_position obj_sur_generator1) 0.1) 5)
                    (set s_surv_generator1_cooldown k_surv_generator_cooldown)
                )
            )
            (<= (object_get_health obj_sur_generator1) 0)
        )
        5
    )
    (begin
        (object_cannot_take_damage obj_sur_generator1)
        (survival_generator1_management 1 0)
        (ai_object_set_targeting_bias obj_sur_generator1 -1)
    )
)

(script dormant void survival_generator2_management
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator2) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator2 0.75)
                    (if b_survival_entered_sudden_death
                        (survival_generator1_management 2 3)
                        (if (> s_surv_generator2_cooldown 0)
                            (begin
                                (survival_generator1_management 2 2)
                                (sleep s_surv_generator2_cooldown)
                                (set s_surv_generator2_cooldown 0)
                            )
                            (survival_generator1_management 2 1)
                        )
                    )
                )
                (begin
                    (survival_ammo_crate_waypoint)
                    (survival_generator1_management 2 0)
                    (ai_object_set_targeting_bias obj_sur_generator2 -1)
                    (sleep_until (< (device_get_position obj_sur_generator2) 0.1) 5)
                    (set s_surv_generator2_cooldown k_surv_generator_cooldown)
                )
            )
            (<= (object_get_health obj_sur_generator2) 0)
        )
        5
    )
    (begin
        (object_cannot_take_damage obj_sur_generator2)
        (survival_generator1_management 2 0)
        (ai_object_set_targeting_bias obj_sur_generator2 -1)
    )
)

(script static void survival_mode_gd_spawn_generators
    (if (survival_mode_generator_random_spawn)
        (begin_random_count
            (survival_mode_generator_count)
            (begin
                (object_create_anew obj_sur_generator0)
                (object_create_anew obj_sur_generator_switch0)
                (object_create_anew obj_sur_generator_switch_cool0)
                (object_create_anew obj_sur_generator_switch_dis0)
                (set b_sur_generator0_spawned true)
                (object_can_take_damage obj_sur_generator0)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator0 7)
            )
            (begin
                (object_create_anew obj_sur_generator1)
                (object_create_anew obj_sur_generator_switch1)
                (object_create_anew obj_sur_generator_switch_cool1)
                (object_create_anew obj_sur_generator_switch_dis1)
                (set b_sur_generator1_spawned true)
                (object_can_take_damage obj_sur_generator1)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator1 8)
            )
            (begin
                (object_create_anew obj_sur_generator2)
                (object_create_anew obj_sur_generator_switch2)
                (object_create_anew obj_sur_generator_switch_cool2)
                (object_create_anew obj_sur_generator_switch_dis2)
                (set b_sur_generator2_spawned true)
                (object_can_take_damage obj_sur_generator2)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator2 9)
            )
        )
        (begin_count
            (survival_mode_generator_count)
            (begin
                (object_create_anew obj_sur_generator0)
                (object_create_anew obj_sur_generator_switch0)
                (object_create_anew obj_sur_generator_switch_cool0)
                (object_create_anew obj_sur_generator_switch_dis0)
                (set b_sur_generator0_spawned true)
                (object_can_take_damage obj_sur_generator0)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator0 10)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator0 7)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator0 7)
            )
            (begin
                (object_create_anew obj_sur_generator1)
                (object_create_anew obj_sur_generator_switch1)
                (object_create_anew obj_sur_generator_switch_cool1)
                (object_create_anew obj_sur_generator_switch_dis1)
                (set b_sur_generator1_spawned true)
                (object_can_take_damage obj_sur_generator1)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator1 11)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator1 8)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator1 8)
            )
            (begin
                (object_create_anew obj_sur_generator2)
                (object_create_anew obj_sur_generator_switch2)
                (object_create_anew obj_sur_generator_switch_cool2)
                (object_create_anew obj_sur_generator_switch_dis2)
                (set b_sur_generator2_spawned true)
                (object_can_take_damage obj_sur_generator2)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 0) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 1) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 2) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 3) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 4) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (human_player_in_game_get 5) obj_sur_generator2 12)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 0) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 1) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 2) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 3) obj_sur_generator2 9)
                (chud_track_object_for_player_with_priority (elite_player_in_game_get 4) obj_sur_generator2 9)
            )
        )
    )
)

(script static boolean survival_mode_gd_generators_alive
    (if (survival_mode_generator_defend_all)
        (>= (surival_set_music) (survival_mode_generator_count))
        (> (surival_set_music) 0)
    )
)

(script static short survival_mode_gd_generator_count
    (+ (if (and b_sur_generator0_spawned (> (object_get_health obj_sur_generator0) 0))
        1
        0
    ) (if (and b_sur_generator1_spawned (> (object_get_health obj_sur_generator1) 0))
        1
        0
    ) (if (and b_sur_generator2_spawned (> (object_get_health obj_sur_generator2) 0))
        1
        0
    ))
)

(script static void survival_respawn_weapons
    (if debug
        (print "creating scenery / vehicles / equipment")
    )
    (event_survival_generator_died)
    (set b_sur_weapon_drop true)
    (object_create_folder_anew folder_survival_scenery)
    (object_create_folder_anew folder_survival_crates)
    (object_create_folder_anew folder_survival_vehicles)
    (object_create_folder_anew folder_survival_equipment)
    (object_create_folder_anew folder_survival_weapons)
    (object_create_folder_anew folder_survival_devices)
    (sleep 30)
    (set b_sur_weapon_drop false)
)

(script static void survival_respawn_crates
    (if debug
        (print "respawn crates")
    )
    (object_create_folder_anew folder_survival_crates)
)

(script static void surival_set_music
    (begin_random_count
        1
        (set m_initial_wave "firefight\firefight_music\firefight_music02")
        (set m_initial_wave "firefight\firefight_music\firefight_music03")
        (set m_initial_wave "firefight\firefight_music\firefight_music04")
        (set m_initial_wave "firefight\firefight_music\firefight_music05")
        (set m_initial_wave "firefight\firefight_music\firefight_music06")
    )
    (begin_random_count
        1
        (set m_final_wave "firefight\firefight_music\firefight_music20")
        (set m_final_wave "firefight\firefight_music\firefight_music21")
        (set m_final_wave "firefight\firefight_music\firefight_music22")
        (set m_final_wave "firefight\firefight_music\firefight_music23")
        (set m_final_wave "firefight\firefight_music\firefight_music24")
    )
)

(script static void survival_mode_wave_music_start
    (if (survival_mode_current_wave_is_initial)
        (sound_looping_start m_initial_wave none 1)
        (if (survival_mode_current_wave_is_boss)
            (sound_looping_start m_final_wave none 1)
        )
    )
)

(script static void survival_mode_wave_music_stop
    (if (survival_mode_current_wave_is_initial)
        (sound_looping_stop m_initial_wave)
        (if (survival_mode_current_wave_is_boss)
            (sound_looping_stop m_final_wave)
        )
    )
)

(script dormant void survival_award_achievement
    (sleep_until (>= (f_survival_phantom_spawner) 200000))
)

(script static void survival_like_marty_start
    (print "todo fix survival_like_marty_start")
)

(script static void survival_like_marty_award
    (print "todo fix survival_like_marty_award")
)

(script startup void survival_round_timer_counter
    (sleep_until 
        (begin
            (set l_sur_round_timer (+ l_sur_round_timer 1))
            false
        )
        30
    )
)

(script dormant void survival_end_game
    (wake survival_mode_end_condition_lives)
    (wake survival_mode_end_condition_generators)
    (wake survival_mode_end_condition_time)
    (sleep_until b_survival_game_end_condition 1)
    (object_cannot_take_damage obj_sur_generator0)
    (object_cannot_take_damage obj_sur_generator1)
    (object_cannot_take_damage obj_sur_generator2)
    (sleep_forever survival_mode_end_condition_lives)
    (sleep_forever survival_mode_end_condition_generators)
    (sleep_forever survival_mode_end_condition_time)
    (sleep_forever survival_mode)
    (sleep_forever survival_bonus_round_end)
    (sleep_forever survival_lives_announcement)
    (sleep_forever survival_award_achievement)
    (sleep_forever survival_mode_generator_defense)
    (sound_looping_stop m_final_wave)
    (sleep 30)
    (sleep 90)
    (mp_round_end_with_winning_team none)
)

(script dormant void survival_mode_end_condition_lives
    (sleep_until (and (= (survival_mode_lives_get player) 0) (survival_elite_life_monitor) (= b_sur_bonus_round_running false)) 10)
    (sleep 30)
    (event_survival_completed_rounds)
    (if (> (survival_mode_player_count_by_team covenant_player) 0)
        (survival_elite_manager)
    )
    (set b_survival_game_end_condition true)
)

(script dormant void survival_mode_end_condition_generators
    (sleep_until b_sur_generator_defense_fail 10)
    (sleep 30)
    (event_survival_generator0_attacked)
    (if (> (survival_mode_player_count_by_team covenant_player) 0)
        (survival_elite_manager)
    )
    (set b_survival_game_end_condition true)
)

(script dormant void survival_mode_end_condition_time
    (sleep_until (and (= b_sur_bonus_round_running false) (> (survival_mode_get_time_limit) 0) (>= l_sur_round_timer (survival_mode_get_time_limit))) 10)
    (if (survival_players_dead)
        (survival_elites_win)
    )
    (sleep_forever survival_mode_end_condition_generators)
    (if b_sur_generator_defense_fail
        (if (> (survival_mode_player_count_by_team covenant_player) 0)
            (begin
                (event_survival_generator0_attacked)
                (survival_elite_manager)
            )
        )
        (begin
            (event_survival_generator1_attacked)
            (survival_refresh_sleep)
        )
    )
    (set b_survival_game_end_condition true)
)

(script static void survival_sudden_death
    (event_survival_1_life_left)
    (survival_mode_sudden_death true)
    (set b_survival_entered_sudden_death true)
    (device_set_power obj_sur_generator_switch0 0)
    (device_set_power obj_sur_generator_switch1 0)
    (device_set_power obj_sur_generator_switch2 0)
    (sleep_until (not (survival_players_dead)) 2 1800)
    (event_survival_0_lives_left)
    (sleep 30)
    (survival_mode_sudden_death false)
    (sleep 150)
)

(script static boolean survival_sudden_death_condition
    (or (and (> (object_get_health "generator0") 0) (> (device_get_position "generator0") 0)) (and (> (object_get_health "generator1") 0) (> (device_get_position "generator1") 0)) (and (> (object_get_health "generator2") 0) (> (device_get_position "generator2") 0)))
)

(script static void survival_spartans_win
    (test_ai_erase_fast)
    (survival_increment_human_score (human_player_in_game_get 0))
    (survival_increment_human_score (human_player_in_game_get 1))
    (survival_increment_human_score (human_player_in_game_get 2))
    (survival_increment_human_score (human_player_in_game_get 3))
    (survival_increment_human_score (human_player_in_game_get 4))
    (survival_increment_human_score (human_player_in_game_get 5))
)

(script static void survival_elites_win
    (test_ai_erase)
    (survival_increment_elite_score (elite_player_in_game_get 0))
    (survival_increment_elite_score (elite_player_in_game_get 1))
    (survival_increment_elite_score (elite_player_in_game_get 2))
    (survival_increment_elite_score (elite_player_in_game_get 3))
    (survival_increment_elite_score (elite_player_in_game_get 4))
    (survival_increment_elite_score (elite_player_in_game_get 5))
)

(script static boolean survival_players_dead
    (<= (player_elite) 0)
)

(script static void survival_refresh_sleep
    (if (>= (ai_living_count "gr_survival_all") 10)
        (if (test_cinematic_enter_exit)
            (sleep (* (random_range 20 30) 30))
            (if (cinematic_skip_stop_terminal)
                (sleep (* (random_range 10 20) 30))
                (if (cinematic_skip_stop)
                    (sleep (* (random_range 5 10) 30))
                )
            )
        )
        (sleep 30)
    )
)

(script dormant void survival_elite_manager
    (sleep_until (> (survival_mode_replenish_players) 0))
    (if (> (survival_mode_bonus_lives_elite_death) 0)
        (wake survival_elite_life_monitor)
    )
    (wake survival_elite_fireteams)
)

(script dormant void survival_elite_life_monitor
    (sleep_until 
        (begin
            (if (< (survival_mode_replenish_players) s_sur_elite_life_monitor)
                (begin
                    (submit_incident_for_elites (* (- s_sur_elite_life_monitor (survival_mode_replenish_players)) (survival_mode_bonus_lives_elite_death)))
                )
            )
            (set s_sur_elite_life_monitor (survival_mode_replenish_players))
            false
        )
        1
    )
)

(script dormant void survival_elite_fireteams
    (if (>= (survival_mode_replenish_players) 1)
        (begin
            (ai_set_fireteam_absorber ai_sur_fireteam_squad0 true)
            (ai_player_add_fireteam_squad (submit_incident_for_spartans 0) ai_sur_fireteam_squad0)
            (ai_player_set_fireteam_max (submit_incident_for_spartans 0) (survival_award_bonus_lives))
            (ai_player_set_fireteam_max_squad_absorb_distance (submit_incident_for_spartans 0) 3)
        )
    )
    (if (>= (survival_mode_replenish_players) 2)
        (begin
            (ai_set_fireteam_absorber ai_sur_fireteam_squad1 true)
            (ai_player_add_fireteam_squad (submit_incident_for_spartans 1) ai_sur_fireteam_squad1)
            (ai_player_set_fireteam_max (submit_incident_for_spartans 1) (survival_award_bonus_lives))
            (ai_player_set_fireteam_max_squad_absorb_distance (submit_incident_for_spartans 1) 3)
        )
    )
    (if (>= (survival_mode_replenish_players) 3)
        (begin
            (ai_set_fireteam_absorber ai_sur_fireteam_squad2 true)
            (ai_player_add_fireteam_squad (submit_incident_for_spartans 2) ai_sur_fireteam_squad2)
            (ai_player_set_fireteam_max (submit_incident_for_spartans 2) (survival_award_bonus_lives))
            (ai_player_set_fireteam_max_squad_absorb_distance (submit_incident_for_spartans 2) 3)
        )
    )
    (if (>= (survival_mode_replenish_players) 4)
        (begin
            (ai_set_fireteam_absorber ai_sur_fireteam_squad3 true)
            (ai_player_add_fireteam_squad (submit_incident_for_spartans 3) ai_sur_fireteam_squad3)
            (ai_player_set_fireteam_max (submit_incident_for_spartans 3) (survival_award_bonus_lives))
            (ai_player_set_fireteam_max_squad_absorb_distance (submit_incident_for_spartans 3) 3)
        )
    )
    (if (>= (survival_mode_replenish_players) 5)
        (begin
            (ai_set_fireteam_absorber ai_sur_fireteam_squad4 true)
            (ai_player_add_fireteam_squad (submit_incident_for_spartans 4) ai_sur_fireteam_squad4)
            (ai_player_set_fireteam_max (submit_incident_for_spartans 4) (survival_award_bonus_lives))
            (ai_player_set_fireteam_max_squad_absorb_distance (submit_incident_for_spartans 4) 3)
        )
    )
)

(script static short survival_elite_fireteam_size
    (if (<= (survival_mode_replenish_players) 1)
        5
        (if (<= (survival_mode_replenish_players) 2)
            3
            (if (<= (survival_mode_replenish_players) 3)
                2
                (if (<= (survival_mode_replenish_players) 4)
                    1
                    (if (<= (survival_mode_replenish_players) 5)
                        1
                    )
                )
            )
        )
    )
)

(script static void survival_lives
    (if (<= (survival_mode_get_shared_team_life_count) 0)
        (survival_mode_lives_set player -1)
        (survival_mode_lives_set player (survival_mode_get_shared_team_life_count))
    )
    (if (<= (survival_mode_get_elite_life_count) 0)
        (survival_mode_lives_set covenant_player -1)
        (survival_mode_lives_set covenant_player (survival_mode_get_elite_life_count))
    )
)

(script static void survival_add_lives
    (survival_mode_award_hero_medal)
    (sleep 1)
    (survival_mode_respawn_dead_players)
    (sleep 1)
    (submit_incident_for_elites (survival_mode_player_count_by_team player))
    (event_survival_1_ai_remaining)
)

(script static void survival_award_bonus_lives
    (submit_incident_for_elites (survival_mode_player_count_by_team player))
)

(script static void survival_set_multiplier
    (if (>= (survival_mode_set_get) 9)
        (survival_mode_set_multiplier_set 5)
        (if (>= (survival_mode_set_get) 8)
            (survival_mode_set_multiplier_set 4.5)
            (if (>= (survival_mode_set_get) 7)
                (survival_mode_set_multiplier_set 4)
                (if (>= (survival_mode_set_get) 6)
                    (survival_mode_set_multiplier_set 3.5)
                    (if (>= (survival_mode_set_get) 5)
                        (survival_mode_set_multiplier_set 3)
                        (if (>= (survival_mode_set_get) 4)
                            (survival_mode_set_multiplier_set 2.5)
                            (if (>= (survival_mode_set_get) 3)
                                (survival_mode_set_multiplier_set 2)
                                (if (>= (survival_mode_set_get) 2)
                                    (survival_mode_set_multiplier_set 1.5)
                                    (if (>= (survival_mode_set_get) 1)
                                        (survival_mode_set_multiplier_set 1)
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

(script stub void survival_vehicle_cleanup
    (if debug
        (print "**vehicle cleanup**")
    )
)

(script static boolean wave_dropship_enabled
    (if (!= s_sur_dropship_type false)
        (survival_mode_current_wave_uses_dropship)
        false
    )
)

(script static short players_human_living_count
    (list_count (players_human))
)

(script static unit (player_human (short index))
    (if (< index (player_elite))
        (unit (list_get (players_human) index))
        none
    )
)

(script static short players_elite_living_count
    (list_count (players_elite))
)

(script static unit (player_elite (short index))
    (if (< index (survival_mode_replenish_players))
        (unit (list_get (players_elite) index))
        none
    )
)

(script static void (survival_mode_add_human_lives (short lives))
    (if (> (survival_mode_max_lives) 0)
        (survival_mode_lives_set player (min (survival_mode_max_lives) (+ (survival_mode_lives_get player) lives)))
        (survival_mode_lives_set player (+ (survival_mode_lives_get player) lives))
    )
)

(script static void survival_mode_replenish_players
    (unit_set_current_vitality (survival_mode_add_human_lives 0) 80 80)
    (unit_set_current_vitality (survival_mode_add_human_lives 1) 80 80)
    (unit_set_current_vitality (survival_mode_add_human_lives 2) 80 80)
    (unit_set_current_vitality (survival_mode_add_human_lives 3) 80 80)
    (unit_set_current_vitality (survival_mode_add_human_lives 4) 80 80)
    (unit_set_current_vitality (survival_mode_add_human_lives 5) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 0) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 1) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 2) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 3) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 4) 80 80)
    (unit_set_current_vitality (submit_incident_for_spartans 5) 80 80)
)

(script static void (submit_incident_for_spartans (string_id incident))
    (submit_incident_with_cause_player incident (human_player_in_game_get 0))
    (submit_incident_with_cause_player incident (human_player_in_game_get 1))
    (submit_incident_with_cause_player incident (human_player_in_game_get 2))
    (submit_incident_with_cause_player incident (human_player_in_game_get 3))
    (submit_incident_with_cause_player incident (human_player_in_game_get 4))
    (submit_incident_with_cause_player incident (human_player_in_game_get 5))
)

(script static void (submit_incident_for_elites (string_id incident))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 0))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 1))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 2))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 3))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 4))
    (submit_incident_with_cause_player incident (elite_player_in_game_get 5))
)

(script static void event_welcome
    (if debug
        (print "event_welcome")
    )
    (if (> (survival_mode_generator_count) 0)
        (begin
            (event_survival_awarded_lives "sur_gen_unsc_start")
            (event_survival_5_ai_remaining "sur_gen_cov_start")
        )
        (begin
            (event_survival_awarded_lives "sur_cla_unsc_start")
            (event_survival_5_ai_remaining "sur_cla_cov_start")
        )
    )
)

(script static void event_survival_awarded_lives
    (if debug
        (print "survival_awarded_lives")
    )
    (event_survival_awarded_lives "survival_awarded_lives")
)

(script static void event_survival_5_ai_remaining
    (if debug
        (print "survival_5_ai_remaining")
    )
    (event_survival_awarded_lives "survival_5_ai_remaining")
)

(script static void event_survival_2_ai_remaining
    (if debug
        (print "survival_2_ai_remaining")
    )
    (event_survival_awarded_lives "survival_2_ai_remaining")
)

(script static void event_survival_1_ai_remaining
    (if debug
        (print "survival_1_ai_remaining")
    )
    (event_survival_awarded_lives "survival_1_ai_remaining")
)

(script static void event_survival_bonus_round
    (if debug
        (print "survival_bonus_round")
    )
    (submit_incident "survival_bonus_round")
)

(script static void event_survival_bonus_round_over
    (if debug
        (print "survival_bonus_round_over")
    )
    (submit_incident "survival_bonus_round_over")
)

(script static void event_survival_bonus_lives_awarded
    (if debug
        (print "survival_bonus_lives_awarded")
    )
    (event_survival_awarded_lives "survival_bonus_lives_awarded")
)

(script static void event_survival_better_luck_next_time
    (if debug
        (print "survival_better_luck_next_time")
    )
    (event_survival_awarded_lives "survival_better_luck_next_time")
)

(script static void event_survival_new_set
    (if debug
        (print "survival_new_set")
    )
    (submit_incident "survival_new_set")
)

(script static void event_survival_new_round
    (if debug
        (print "survival_new_round")
    )
    (submit_incident "survival_new_round")
)

(script static void event_survival_reinforcements
    (if debug
        (print "survival_reinforcements")
    )
    (submit_incident "survival_reinforcements")
)

(script static void event_survival_end_round
    (if debug
        (print "survival_end_round")
    )
    (submit_incident "survival_end_round")
)

(script static void event_survival_end_set
    (if debug
        (print "survival_end_set")
    )
    (submit_incident "survival_end_set")
)

(script static void event_survival_sudden_death
    (if debug
        (print "sudden_death")
    )
    (submit_incident "sudden_death")
)

(script static void event_survival_sudden_death_over
    (if debug
        (print "survival_sudden_death_over")
    )
    (submit_incident "survival_sudden_death_over")
)

(script static void event_survival_5_lives_left
    (if debug
        (print "survival_5_lives_left")
    )
    (event_survival_awarded_lives "survival_5_lives_left")
)

(script static void event_survival_1_life_left
    (if debug
        (print "survival_1_life_left")
    )
    (event_survival_awarded_lives "survival_1_life_left")
)

(script static void event_survival_0_lives_left
    (if debug
        (print "survival_0_lives_left")
    )
    (event_survival_awarded_lives "survival_0_lives_left")
)

(script static void event_survival_last_man_standing
    (if debug
        (print "survival_last_man_standing")
    )
    (event_survival_awarded_lives "survival_last_man_standing")
)

(script static void event_survival_awarded_weapon
    (if debug
        (print "survival_awarded_weapon")
    )
    (event_survival_awarded_lives "survival_awarded_weapon")
    (event_survival_5_ai_remaining "survival_awarded_weapon")
)

(script static void event_survival_round_over
    (if debug
        (print "event_survival_round_over")
    )
    (submit_incident "round_over")
)

(script static void event_survival_game_over
    (if debug
        (print "event_survival_game_over")
    )
    (submit_incident "survival_game_over")
)

(script static void event_survival_generator_died
    (if debug
        (print "event_survival_generator_died")
    )
    (event_survival_awarded_lives "survival_generator_lost")
    (event_survival_5_ai_remaining "survival_generator_destroyed")
)

(script static void event_survival_end_lives
    (if debug
        (print "event_survival_end_condition_lives")
    )
    (event_survival_awarded_lives "survival_out_of_lives")
    (event_survival_5_ai_remaining "survival_obj_complete")
)

(script static void event_survival_end_generators
    (if debug
        (print "event_survival_end_generators")
    )
    (event_survival_awarded_lives "survival_obj_failed")
    (event_survival_5_ai_remaining "survival_obj_complete")
)

(script static void event_survival_end_time
    (if debug
        (print "event_survival_end_time")
    )
    (event_survival_awarded_lives "survival_obj_complete")
    (event_survival_5_ai_remaining "survival_obj_failed")
)

(script static void event_survival_completed_rounds
    (if debug
        (print "event_survival_completed_rounds")
    )
    (event_survival_awarded_lives "survival_obj_complete")
    (event_survival_5_ai_remaining "survival_obj_failed")
)

(script static void event_survival_generator0_attacked
    (if (>= (game_tick_get) s_sur_gen0_attack_message_cd)
        (begin
            (if debug
                (print "event_survival_generator0_attacked")
            )
            (event_survival_awarded_lives "survival_alpha_under_attack")
            (set s_sur_gen0_attack_message_cd (+ (game_tick_get) 450))
        )
    )
)

(script static void event_survival_generator1_attacked
    (if (>= (game_tick_get) s_sur_gen1_attack_message_cd)
        (begin
            (if debug
                (print "event_survival_generator1_attacked")
            )
            (event_survival_awarded_lives "survival_bravo_under_attack")
            (set s_sur_gen1_attack_message_cd (+ (game_tick_get) 450))
        )
    )
)

(script static void event_survival_generator2_attacked
    (if (>= (game_tick_get) s_sur_gen2_attack_message_cd)
        (begin
            (if debug
                (print "event_survival_generator2_attacked")
            )
            (event_survival_awarded_lives "survival_charlie_under_attack")
            (set s_sur_gen2_attack_message_cd (+ (game_tick_get) 450))
        )
    )
)

(script static void event_survival_generator0_locked
    (if debug
        (print "event_survival_generator0_locked")
    )
    (submit_incident "gen_alpha_locked")
)

(script static void event_survival_generator1_locked
    (if debug
        (print "event_survival_generator1_locked")
    )
    (submit_incident "gen_bravo_locked")
)

(script static void event_survival_generator2_locked
    (if debug
        (print "event_survival_generator2_locked")
    )
    (submit_incident "gen_charlie_locked")
)

(script static void event_survival_spartans_win
    (if debug
        (print "event_survival_spartans_win")
    )
    (submit_incident "survival_spartans_win")
)

(script static void event_survival_elites_win
    (if debug
        (print "event_survival_elites_win")
    )
    (submit_incident "survival_elites_win")
)

(script dormant void survival_ammo_crate_waypoint
    (chud_track_object_with_priority "ammo_crate" 13)
    (sleep 450)
    (chud_track_object "ammo_crate" false)
)

(script dormant void test_ai_erase_fast
    (sleep_until 
        (begin
            (sleep_until (>= (ai_living_count "gr_survival_all") 1) 1)
            (sleep 5)
            (ai_erase_all)
            false
        )
        1
    )
)

(script dormant void test_ai_erase
    (sleep_until 
        (begin
            (sleep_until (>= (ai_living_count "gr_survival_all") 1) 1)
            (sleep 30)
            (ai_erase_all)
            false
        )
        1
    )
)

(script dormant void test_ai_erase_slow
    (sleep_until 
        (begin
            (sleep_until (>= (ai_living_count "gr_survival_all") 1) 1)
            (sleep 150)
            (ai_erase_all)
            false
        )
        1
    )
)

(script static void test_award_500
    (campaign_metagame_award_points (coop_players_3) 500)
)

(script static void test_award_1000
    (campaign_metagame_award_points (coop_players_3) 1000)
)

(script static void test_award_5000
    (campaign_metagame_award_points (coop_players_3) 5000)
)

(script static void test_award_10000
    (campaign_metagame_award_points (coop_players_3) 10000)
)

(script static void test_award_20000
    (campaign_metagame_award_points (coop_players_3) 20000)
)

(script static void test_award_30000
    (campaign_metagame_award_points (coop_players_3) 30000)
)

(script static void test_4_player
    (set k_sur_squad_per_wave_limit 6)
    (set k_phantom_spawn_limit 2)
)

(script static void (f_unload_phantom (vehicle phantom, string drop_side))
    (if b_debug_phantom
        (print "opening phantom...")
    )
    (unit_open phantom)
    (sleep 30)
    (if (= drop_side "left")
        (begin
            (player_count phantom)
            (sleep 45)
            (difficulty_legendary phantom)
            (sleep 75)
        )
        (if (= drop_side "right")
            (begin
                (print_difficulty phantom)
                (sleep 45)
                (difficulty_heroic phantom)
                (sleep 75)
            )
            (if (= drop_side "dual")
                (begin
                    (player_count phantom)
                    (print_difficulty phantom)
                    (sleep 75)
                )
                (if (= drop_side "chute")
                    (begin
                        (difficulty_normal phantom)
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

(script static void (f_load_pelican (vehicle pelican, string load_side, ai load_squad_01, ai load_squad_02))
    (ai_place load_squad_01)
    (ai_place load_squad_02)
    (sleep 1)
    (if (= load_side "left")
        (begin
            (if b_debug_phantom
                (print "load phantom left...")
            )
        )
        (if (= load_side "right")
            (begin
                (if b_debug_phantom
                    (print "load phantom right...")
                )
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_phantom
                        (print "load phantom dual...")
                    )
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
    (unit_set_current_vitality (coop_players_3) 80 80)
    (unit_set_current_vitality (coop_players_4) 80 80)
    (unit_set_current_vitality (any_players_in_vehicle) 80 80)
    (unit_set_current_vitality (f_vehicle_scale_destroy) 80 80)
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
    (or (unit_in_vehicle (unit (coop_players_3))) (unit_in_vehicle (unit (coop_players_4))) (unit_in_vehicle (unit (any_players_in_vehicle))) (unit_in_vehicle (unit (f_vehicle_scale_destroy))))
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
    (cinematic_fade_to_gameplay "snap_to_white" false)
    (sleep 30)
    (cinematic_hud_on "fade_from_white" true)
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
                    (unit_lower_weapon (coop_players_3) 30)
                    (unit_lower_weapon (coop_players_4) 30)
                    (unit_lower_weapon (any_players_in_vehicle) 30)
                    (unit_lower_weapon (f_vehicle_scale_destroy) 30)
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
    (object_hide (coop_players_3) true)
    (object_hide (coop_players_4) true)
    (object_hide (any_players_in_vehicle) true)
    (object_hide (f_vehicle_scale_destroy) true)
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
    (object_hide (coop_players_3) false)
    (object_hide (coop_players_4) false)
    (object_hide (any_players_in_vehicle) false)
    (object_hide (f_vehicle_scale_destroy) false)
    (if (= weapon_starts_lowered true)
        (begin
            (if b_debug_cinematic_scripts
                (print "snapping weapon to lowered state...")
            )
            (unit_lower_weapon (coop_players_3) 1)
            (unit_lower_weapon (coop_players_4) 1)
            (unit_lower_weapon (any_players_in_vehicle) 1)
            (unit_lower_weapon (f_vehicle_scale_destroy) 1)
            (sleep 1)
        )
    )
    (player_control_unlock_gaze (coop_players_3))
    (player_control_unlock_gaze (coop_players_4))
    (player_control_unlock_gaze (any_players_in_vehicle))
    (player_control_unlock_gaze (f_vehicle_scale_destroy))
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
            (unit_raise_weapon (coop_players_3) 30)
            (unit_raise_weapon (coop_players_4) 30)
            (unit_raise_weapon (any_players_in_vehicle) 30)
            (unit_raise_weapon (f_vehicle_scale_destroy) 30)
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
    (cinematic_fade_to_gameplay "fade_to_black" false)
)

(script static void cinematic_snap_to_white
    (cinematic_fade_to_gameplay "fade_to_white" false)
)

(script static void cinematic_preparation
    (ai_disregard (players) true)
    (object_cannot_take_damage (players))
    (player_control_fade_out_all_input 0)
    (object_hide (coop_players_3) true)
    (object_hide (coop_players_4) true)
    (object_hide (any_players_in_vehicle) true)
    (object_hide (f_vehicle_scale_destroy) true)
    (cinematic_enter)
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
    (cinematic_hud_on "snap_from_black" false)
)

(script static void cinematic_snap_from_white
    (cinematic_hud_on "snap_from_white" false)
)

(script static void cinematic_snap_from_pre
    (if (not (campaign_survival_enabled))
        (cinematic_stop)
    )
    (camera_control false)
    (cinematic_show_letterbox_immediate false)
    (f_sfx_hud_out)
    (sleep 1)
    (chud_cinematic_fade 1 0)
    (object_hide (coop_players_3) false)
    (object_hide (coop_players_4) false)
    (object_hide (any_players_in_vehicle) false)
    (object_hide (f_vehicle_scale_destroy) false)
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
    (cinematic_fade_to_gameplay "fade_to_black" true)
)

(script static void cinematic_fade_to_white
    (cinematic_fade_to_gameplay "fade_to_white" true)
)

(script static void cinematic_fade_to_gameplay
    (cinematic_hud_on "fade_from_black" true)
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
        (cinematic_fade_to_gameplay "snap_to_black" false)
        (if (= snap_color "white")
            (cinematic_fade_to_gameplay "snap_to_white" false)
            (if (= snap_color "no_fade")
                (cinematic_fade_to_gameplay "no_fade" false)
            )
        )
    )
    (sleep 1)
    (if (cinematic_snap_from_pre)
        (begin
            (if b_debug_cinematic_scripts
                (print "cinematic_skip_start is true... starting cinematic...")
            )
            (sound_class_set_gain "" 0 0)
            (sound_class_set_gain "mus" 1 0)
            (evaluate cinematic_intro)
        )
        (cinematic_snap_from_post)
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
        (cinematic_fade_to_gameplay "fade_to_black" true)
        (if (= fade_type "fade_to_white")
            (cinematic_fade_to_gameplay "fade_to_white" true)
            (if (= fade_type "snap_to_black")
                (cinematic_fade_to_gameplay "snap_to_black" true)
                (if (= fade_type "snap_to_white")
                    (cinematic_fade_to_gameplay "snap_to_white" true)
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
        (beginning_mission_segment)
        (if (= fade_type "fade_to_white")
            (f_sfx_a_button)
            (if (= fade_type "snap_to_black")
                (cinematic_hud_off)
                (if (= fade_type "snap_to_white")
                    (performance_default_script)
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
    (if (cinematic_snap_from_pre)
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
    (cinematic_hud_off)
)

(script static void (f_end_scene (script cinematic_outro, zone_set cinematic_zone_set, string_id scene_boolean, string_id scene_name, string snap_color))
    (if (= snap_color "black")
        (cinematic_hud_off)
        (if (= snap_color "white")
            (performance_default_script)
        )
    )
    (sleep 1)
    (ai_erase_all)
    (garbage_collect_now)
    (switch_zone_set cinematic_zone_set)
    (sound_suppress_ambience_update_on_revert)
    (sleep 1)
    (begin
        (if (cinematic_snap_from_pre)
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
    (cinematic_hud_off)
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
    (f_blip_flag player_short)
    (chud_show_cinematic_title (player_get player_short) blank_title)
    (sleep 5)
)

(script static void (f_tutorial_boost (short player_short, cutscene_title display_title, cutscene_title blank_title))
    (f_unblip_flag player_short display_title)
    (sleep_until (unit_action_test_grenade_trigger (player_get player_short)) 1)
    (f_blip_object player_short blank_title)
)

(script static void (f_tutorial_rotate_weapons (short player_short, cutscene_title display_title, cutscene_title blank_title))
    (f_unblip_flag player_short display_title)
    (sleep_until (unit_action_test_rotate_weapons (player_get player_short)) 1)
    (f_blip_object player_short blank_title)
)

(script static void (f_hud_obj_new (cutscene_title title))
    (cinematic_set_chud_objective title)
)

(script static void (f_hud_flash_object (object_name hud_object_highlight))
    (set chud_debug_highlight_object_color_red 1)
    (set chud_debug_highlight_object_color_green 1)
    (set chud_debug_highlight_object_color_blue 0)
    (f_blip_ai_forever hud_object_highlight)
    (f_blip_ai_forever hud_object_highlight)
    (f_blip_ai_forever hud_object_highlight)
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
    (f_callout_object f blip_neutralize)
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
    (set l_blip_list (ai_actors group))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_md_ai_play (list_get l_blip_list s_blip_list_index) blip_type)
            )
            (set s_blip_list_index (+ s_blip_list_index 1))
            (>= s_blip_list_index (list_count l_blip_list))
        )
        1
    )
    (set s_blip_list_index 0)
    (set b_blip_list_locked false)
)

(script static void (f_blip_ai_forever (ai group))
    (print "f_blip_ai_forever is going away. please use f_blip_ai")
    (f_md_abort group 0)
)

(script static void (f_blip_ai_until_dead (ai char))
    (print "f_blip_ai_until_dead will be rolled into the new f_blip_ai command. consider using that instead.")
    (f_md_play char)
    (sleep_until (<= (object_get_health (ai_get_object char)) 0))
    (f_ai_has_spawned char)
)

(script static void (f_unblip_ai (ai char))
    (f_md_ai_play_cutoff (ai_get_object char))
)

(script static void (f_callout_object (object obj, short type))
    (f_task_is_empty obj type 10 2)
    (f_task_is_empty obj type 10 2)
    (f_task_is_empty obj type 10 2)
    (f_task_is_empty obj type 100 2)
)

(script static void (f_callout_ai (ai actors, short type))
    (sleep_until (= b_blip_list_locked false) 1)
    (set b_blip_list_locked true)
    (set l_blip_list (ai_actors actors))
    (sleep_until 
        (begin
            (if (> (object_get_health (list_get l_blip_list s_blip_list_index)) 0)
                (f_ai_is_defeated (list_get l_blip_list s_blip_list_index) type)
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

(script startup void ff10_prototype
    (set alpha_sync_slayer true)
    (ai_allegiance human player)
    (ai_allegiance player human)
    (if (> (f_coop_resume_unlocked) 0)
        (cinematic_hud_off)
    )
    (sleep 5)
    (switch_zone_set "set_firefight")
    (wake sur_kill_vol_disable)
    (set ai_sur_fireteam_squad0 "sur_fireteam_01")
    (set ai_sur_fireteam_squad1 "sur_fireteam_02")
    (set ai_sur_fireteam_squad2 "sur_fireteam_03")
    (set ai_sur_fireteam_squad3 "sur_fireteam_04")
    (set ai_sur_fireteam_squad4 "sur_fireteam_05")
    (set ai_obj_survival "obj_survival")
    (set ai_sur_phantom_01 "sq_sur_phantom_01")
    (set ai_sur_phantom_02 "sq_sur_phantom_02")
    (set ai_sur_phantom_03 "sq_sur_phantom_03")
    (set ai_sur_phantom_04 "sq_sur_phantom_04")
    (set s_sur_drop_side_01 "right")
    (set s_sur_drop_side_02 "left")
    (set s_sur_drop_side_03 "dual")
    (set s_sur_drop_side_04 "dual")
    (set ai_sur_wave_spawns "gr_survival_waves")
    (set s_sur_wave_squad_count 8)
    (set obj_sur_generator0 "generator0")
    (set obj_sur_generator1 "generator1")
    (set obj_sur_generator2 "generator2")
    (set obj_sur_generator_switch0 "generator_switch0")
    (set obj_sur_generator_switch1 "generator_switch1")
    (set obj_sur_generator_switch2 "generator_switch2")
    (set obj_sur_generator_switch_cool0 "generator_switch_cool0")
    (set obj_sur_generator_switch_cool1 "generator_switch_cool1")
    (set obj_sur_generator_switch_cool2 "generator_switch_cool2")
    (set obj_sur_generator_switch_dis0 "generator_switch_disabled0")
    (set obj_sur_generator_switch_dis1 "generator_switch_disabled1")
    (set obj_sur_generator_switch_dis2 "generator_switch_disabled2")
    (set ai_sur_remaining "sq_sur_remaining")
    (set ai_sur_bonus_phantom "sq_sur_bonus_phantom")
    (wake survival_mode)
    (wake survival_recycle)
    (wake survival_resupply_pod_spawn)
    (sleep 91)
    (wake survival_initial_pod_drop)
    (sleep 5)
)

(script static void survival_refresh_follow
    (survival_elite_fireteams)
    (ai_reset_objective "obj_survival/main_follow")
)

(script static void survival_refresh_generator
    (survival_elite_fireteams)
    (ai_reset_objective "obj_survival/generator")
)

(script static void survival_hero_refresh_follow
    (survival_elite_fireteams)
    (survival_elite_fireteams)
    (ai_reset_objective "obj_survival/hero_follow")
)

(script continuous void phantom_01_blip
    (sleep_forever)
    (print "blipping phantom_01...")
    (f_ai_is_defeated v_sur_phantom_01 14)
)

(script continuous void phantom_02_blip
    (sleep_forever)
    (print "blipping phantom_02...")
    (f_ai_is_defeated v_sur_phantom_02 14)
)

(script continuous void phantom_03_blip
    (sleep_forever)
    (print "blipping phantom_03...")
    (f_ai_is_defeated v_sur_phantom_03 14)
)

(script continuous void phantom_04_blip
    (sleep_forever)
    (print "blipping phantom_04...")
    (f_ai_is_defeated v_sur_phantom_04 14)
)

(script command_script void cs_sur_bonus_phantom
    (set v_sur_bonus_phantom (ai_vehicle_get_from_spawn_point "sq_sur_bonus_phantom/phantom"))
    (set b_load_in_phantom true)
    (sleep 1)
    (object_set_shadowless v_sur_bonus_phantom true)
    (cs_enable_pathfinding_failsafe true)
    (cs_fly_by "ps_sur_bonus_phantom/p0")
    (cs_fly_by "ps_sur_bonus_phantom/p1")
    (cs_fly_by "ps_sur_bonus_phantom/p2")
    (cs_fly_to_and_face "ps_sur_bonus_phantom/drop" "ps_sur_bonus_phantom/face" 1)
    (sleep 15)
    (unit_open v_sur_bonus_phantom)
    (wake phantom_bonus_blip)
    (set b_load_in_phantom false)
    (set b_sur_bonus_phantom_ready true)
    (survival_phantom_spawner v_sur_bonus_phantom)
    (sleep 150)
    (unit_close v_sur_bonus_phantom)
    (sleep_until b_sur_bonus_end)
    (sleep 45)
    (sleep 15)
    (cs_fly_by "ps_sur_bonus_phantom/p2")
    (cs_fly_by "ps_sur_bonus_phantom/p1")
    (cs_fly_by "ps_sur_bonus_phantom/p0")
    (cs_fly_by "ps_sur_bonus_phantom/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_bonus_blip
    (sleep_forever)
    (print "blipping bonus phantom...")
    (f_ai_is_defeated v_sur_bonus_phantom 14)
)

(script static boolean (resupply_pod_test_weapon (object pod))
    (or (!= (object_at_marker pod "gun_high") none) (!= (object_at_marker pod "gun_mid") none) (!= (object_at_marker pod "gun_lower") none))
)

(script dormant void survival_resupply_pod_spawn
    (if (<= (game_coop_player_count) 2)
        (set g_sur_resupply_limit 1)
        (if (= (game_coop_player_count) 3)
            (set g_sur_resupply_limit 2)
            (if (= (game_coop_player_count) 4)
                (set g_sur_resupply_limit 2)
                (if (>= (game_coop_player_count) 5)
                    (set g_sur_resupply_limit 3)
                )
            )
        )
    )
    (sleep 1)
    (sleep_until 
        (begin
            (sleep_until b_sur_weapon_drop)
            (sleep 1)
            (print "cleaning up old resupply pods...")
            (sleep 1)
            (object_destroy "sc_resupply_01")
            (object_destroy "sc_resupply_02")
            (object_destroy "sc_resupply_03")
            (object_destroy "sc_resupply_04")
            (object_destroy "sc_resupply_05")
            (object_destroy "sc_resupply_06")
            (object_destroy "sc_resupply_07")
            (object_destroy "sc_resupply_08")
            (object_destroy "sc_resupply_09")
            (sleep 1)
            (print "bringing in longsword...")
            (object_create "dm_longsword_01")
            (sleep 1)
            (device_set_position_track "dm_longsword_01" "ff10" 0)
            (device_animate_position "dm_longsword_01" 1 10 3 3 false)
            (sleep_until (>= (device_get_position "dm_longsword_01") 0.4) 1)
            (print "dropping off weapons...")
            (begin_random_count
                g_sur_resupply_limit
                (wake resupply_pod_01)
                (wake resupply_pod_02)
                (wake resupply_pod_03)
                (wake resupply_pod_04)
                (wake resupply_pod_05)
                (wake resupply_pod_06)
                (wake resupply_pod_07)
                (wake resupply_pod_08)
                (wake resupply_pod_09)
            )
            (sleep 120)
            (object_destroy "dm_longsword_01")
            false
        )
    )
)

(script dormant void survival_initial_pod_drop
    (print "cleaning up old resupply pods...")
    (sleep 1)
    (object_destroy "sc_resupply_01")
    (object_destroy "sc_resupply_02")
    (object_destroy "sc_resupply_03")
    (object_destroy "sc_resupply_04")
    (object_destroy "sc_resupply_05")
    (object_destroy "sc_resupply_06")
    (object_destroy "sc_resupply_07")
    (object_destroy "sc_resupply_08")
    (object_destroy "sc_resupply_09")
    (sleep 300)
    (print "bringing in longsword...")
    (event_survival_generator_died)
    (object_create "dm_longsword_01")
    (sleep 1)
    (device_set_position_track "dm_longsword_01" "ff10" 0)
    (device_animate_position "dm_longsword_01" 1 10 3 3 false)
    (sleep_until (>= (device_get_position "dm_longsword_01") 0.4) 1)
    (print "dropping off weapons...")
    (begin_random_count
        g_sur_resupply_limit
        (wake resupply_pod_01)
        (wake resupply_pod_02)
        (wake resupply_pod_03)
        (wake resupply_pod_04)
        (wake resupply_pod_05)
        (wake resupply_pod_06)
        (wake resupply_pod_07)
        (wake resupply_pod_08)
        (wake resupply_pod_09)
    )
    (sleep 120)
    (object_destroy "dm_longsword_01")
)

(script continuous void resupply_pod_01
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 01...")
    (object_create "dm_resupply_01")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_01" "laser")
        (object_create_variant "sc_resupply_01" "rocket")
        (object_create_variant "sc_resupply_01" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_01" "" "sc_resupply_01" "")
    (sleep 1)
    (device_set_position "dm_resupply_01" 1)
    (sleep_until (>= (device_get_position "dm_resupply_01") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_01" "sc_resupply_01")
    (object_destroy "dm_resupply_01")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_01" "panel" 100)
    (set b_sur_resupply_waypoint_01 true)
    (wake resupply_waypoint_01)
)

(script dormant void resupply_waypoint_01
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_01 true)
                (begin
                    (print "placing waypoint on resupply 01...")
                    (f_ai_is_defeated "sc_resupply_01" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_01"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_01 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_02
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 02...")
    (object_create "dm_resupply_02")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_02" "laser")
        (object_create_variant "sc_resupply_02" "rocket")
        (object_create_variant "sc_resupply_02" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_02" "" "sc_resupply_02" "")
    (sleep 1)
    (device_set_position "dm_resupply_02" 1)
    (sleep_until (>= (device_get_position "dm_resupply_02") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_02" "sc_resupply_02")
    (object_destroy "dm_resupply_02")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_02" "panel" 100)
    (set b_sur_resupply_waypoint_02 true)
    (wake resupply_waypoint_02)
)

(script dormant void resupply_waypoint_02
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_02 true)
                (begin
                    (print "placing waypoint on resupply 02...")
                    (f_ai_is_defeated "sc_resupply_02" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_02"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_02 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_03
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 03...")
    (object_create "dm_resupply_03")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_03" "laser")
        (object_create_variant "sc_resupply_03" "rocket")
        (object_create_variant "sc_resupply_03" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_03" "" "sc_resupply_03" "")
    (sleep 1)
    (device_set_position "dm_resupply_03" 1)
    (sleep_until (>= (device_get_position "dm_resupply_03") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_03" "sc_resupply_03")
    (object_destroy "dm_resupply_03")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_03" "panel" 100)
    (set b_sur_resupply_waypoint_03 true)
    (wake resupply_waypoint_03)
)

(script dormant void resupply_waypoint_03
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_03 true)
                (begin
                    (print "placing waypoint on resupply 03...")
                    (f_ai_is_defeated "sc_resupply_03" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_03"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_03 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_04
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 04...")
    (object_create "dm_resupply_04")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_04" "laser")
        (object_create_variant "sc_resupply_04" "rocket")
        (object_create_variant "sc_resupply_04" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_04" "" "sc_resupply_04" "")
    (sleep 1)
    (device_set_position "dm_resupply_04" 1)
    (sleep_until (>= (device_get_position "dm_resupply_04") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_04" "sc_resupply_04")
    (object_destroy "dm_resupply_04")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_04" "panel" 100)
    (set b_sur_resupply_waypoint_04 true)
    (wake resupply_waypoint_04)
)

(script dormant void resupply_waypoint_04
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_04 true)
                (begin
                    (print "placing waypoint on resupply 04...")
                    (f_ai_is_defeated "sc_resupply_04" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_04"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_04 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_05
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 05...")
    (object_create "dm_resupply_05")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_05" "laser")
        (object_create_variant "sc_resupply_05" "rocket")
        (object_create_variant "sc_resupply_05" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_05" "" "sc_resupply_05" "")
    (sleep 1)
    (device_set_position "dm_resupply_05" 1)
    (sleep_until (>= (device_get_position "dm_resupply_05") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_05" "sc_resupply_05")
    (object_destroy "dm_resupply_05")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_05" "panel" 100)
    (set b_sur_resupply_waypoint_05 true)
    (wake resupply_waypoint_05)
)

(script dormant void resupply_waypoint_05
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_05 true)
                (begin
                    (print "placing waypoint on resupply 05...")
                    (f_ai_is_defeated "sc_resupply_05" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_05"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_05 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_06
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 06...")
    (object_create "dm_resupply_06")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_06" "laser")
        (object_create_variant "sc_resupply_06" "rocket")
        (object_create_variant "sc_resupply_06" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_06" "" "sc_resupply_06" "")
    (sleep 1)
    (device_set_position "dm_resupply_06" 1)
    (sleep_until (>= (device_get_position "dm_resupply_06") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_06" "sc_resupply_06")
    (object_destroy "dm_resupply_06")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_06" "panel" 100)
    (set b_sur_resupply_waypoint_06 true)
    (wake resupply_waypoint_06)
)

(script dormant void resupply_waypoint_06
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_06 true)
                (begin
                    (print "placing waypoint on resupply 06...")
                    (f_ai_is_defeated "sc_resupply_06" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_06"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_06 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_07
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 07...")
    (object_create "dm_resupply_07")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_07" "laser")
        (object_create_variant "sc_resupply_07" "rocket")
        (object_create_variant "sc_resupply_07" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_07" "" "sc_resupply_07" "")
    (sleep 1)
    (device_set_position "dm_resupply_07" 1)
    (sleep_until (>= (device_get_position "dm_resupply_07") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_07" "sc_resupply_07")
    (object_destroy "dm_resupply_07")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_07" "panel" 100)
    (set b_sur_resupply_waypoint_07 true)
    (wake resupply_waypoint_07)
)

(script dormant void resupply_waypoint_07
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_07 true)
                (begin
                    (print "placing waypoint on resupply 07...")
                    (f_ai_is_defeated "sc_resupply_07" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_07"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_07 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_08
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 08...")
    (object_create "dm_resupply_08")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_08" "laser")
        (object_create_variant "sc_resupply_08" "rocket")
        (object_create_variant "sc_resupply_08" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_08" "" "sc_resupply_08" "")
    (sleep 1)
    (device_set_position "dm_resupply_08" 1)
    (sleep_until (>= (device_get_position "dm_resupply_08") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_08" "sc_resupply_08")
    (object_destroy "dm_resupply_08")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_08" "panel" 100)
    (set b_sur_resupply_waypoint_08 true)
    (wake resupply_waypoint_08)
)

(script dormant void resupply_waypoint_08
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_08 true)
                (begin
                    (print "placing waypoint on resupply 08...")
                    (f_ai_is_defeated "sc_resupply_08" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_08"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_08 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script continuous void resupply_pod_09
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 09...")
    (object_create "dm_resupply_09")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_09" "laser")
        (object_create_variant "sc_resupply_09" "rocket")
        (object_create_variant "sc_resupply_09" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_09" "" "sc_resupply_09" "")
    (sleep 1)
    (device_set_position "dm_resupply_09" 1)
    (sleep_until (>= (device_get_position "dm_resupply_09") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_09" "sc_resupply_09")
    (object_destroy "dm_resupply_09")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_09" "panel" 100)
    (set b_sur_resupply_waypoint_09 true)
    (wake resupply_waypoint_09)
)

(script dormant void resupply_waypoint_09
    (sleep_until 
        (begin
            (if (= b_sur_resupply_waypoint_09 true)
                (begin
                    (print "placing waypoint on resupply 09...")
                    (f_ai_is_defeated "sc_resupply_09" blip_ordnance)
                    (sleep (random_range 1350 1800))
                    (if (not (resupply_pod_08 "sc_resupply_09"))
                        (begin
                            (print "turing off waypoint...")
                            (set b_sur_resupply_waypoint_09 false)
                        )
                    )
                )
                (begin
                    (sleep 1)
                )
            )
            false
        )
        5
    )
)

(script dormant void survival_recycle
    (sleep_until 
        (begin
            (add_recycling_volume "tv_sur_garbage_all" 60 60)
            (sleep 1500)
            false
        )
        1
    )
)

(script dormant void sur_kill_vol_disable
    (kill_volume_disable "kill_sur_room_01")
    (kill_volume_disable "kill_sur_room_02")
    (kill_volume_disable "kill_sur_room_03")
    (kill_volume_disable "kill_sur_room_04")
    (kill_volume_disable "kill_sur_room_05")
    (kill_volume_disable "kill_sur_room_06")
    (kill_volume_disable "kill_sur_room_07")
    (kill_volume_disable "kill_sur_room_08")
    (print "disabling kill_volumes")
)

(script static void test_longsword_drop
    (print "cleaning up old resupply pods...")
    (sleep 1)
    (object_destroy "sc_resupply_01")
    (object_destroy "sc_resupply_02")
    (object_destroy "sc_resupply_03")
    (object_destroy "sc_resupply_04")
    (object_destroy "sc_resupply_05")
    (object_destroy "sc_resupply_06")
    (object_destroy "sc_resupply_07")
    (object_destroy "sc_resupply_08")
    (object_destroy "sc_resupply_09")
    (sleep 1)
    (print "bringing in longsword...")
    (object_create "dm_longsword_01")
    (sleep 1)
    (device_set_position_track "dm_longsword_01" "ff10" 0)
    (device_animate_position "dm_longsword_01" 1 10 3 3 false)
    (sleep_until (>= (device_get_position "dm_longsword_01") 0.4) 1)
    (print "dropping off weapons...")
    (wake test_resupply)
    (sleep 120)
    (object_destroy "dm_longsword_01")
)

(script continuous void test_resupply
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "resupply pod 01...")
    (object_create "dm_resupply_01")
    (begin_random_count
        1
        (object_create_variant "sc_resupply_01" "laser")
        (object_create_variant "sc_resupply_01" "rocket")
        (object_create_variant "sc_resupply_01" "sniper")
    )
    (sleep 1)
    (objects_attach "dm_resupply_01" "" "sc_resupply_01" "")
    (sleep 1)
    (device_set_position "dm_resupply_01" 1)
    (sleep_until (>= (device_get_position "dm_resupply_01") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_01" "sc_resupply_01")
    (object_destroy "dm_resupply_01")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_01" "panel" 100)
)

(script static boolean obj_smain__0_2
    (and (<= (ai_task_count "obj_survival/hero_follow") 0) (<= (ai_task_count "obj_survival/remaining") 3))
)

(script static boolean obj_shero__0_12
    (<= (ai_task_count "obj_survival/remaining") 3)
)

(script static boolean obj_sbonus_0_17
    b_sur_bonus_round_running
)

(script static boolean obj_sgener_0_26
    b_sur_generator_defense_active
)

(script static boolean obj_sgen0_0_27
    (> (object_get_health "generator0") 0)
)

(script static boolean obj_sgen1_0_28
    (> (object_get_health "generator1") 0)
)

(script static boolean obj_sgen2_0_29
    (> (object_get_health "generator2") 0)
)

; Decompilation finished in ~0.0800768s
