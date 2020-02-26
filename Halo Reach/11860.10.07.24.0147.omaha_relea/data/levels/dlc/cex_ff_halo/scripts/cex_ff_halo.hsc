; Decompiled with Assembly
; 
; Source file: cex_ff_halo.hsc
; Start time: 2018-02-05 1:04:24 PM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global boolean debug false)
(global boolean debug_bonus_round false)
(global boolean alpha_sync_slayer false)
(global ai gr_survival_phantom none)
(global ai ai_sur_wave_spawns none)
(global ai ai_sur_remaining none)
(global ai ai_sur_fireteam_squad0 none)
(global ai ai_sur_fireteam_squad1 none)
(global ai ai_sur_fireteam_squad2 none)
(global ai ai_sur_fireteam_squad3 none)
(global ai ai_sur_fireteam_squad4 none)
(global ai ai_sur_fireteam_squad5 none)
(global ai ai_obj_survival none)
(global short s_sur_wave_squad_count 4)
(global ai ai_sur_bonus_wave none)
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
(global object_name obj_ammo_crate0 "ammo_crate0")
(global object_name obj_ammo_crate1 "ammo_crate1")
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
(global short k_sur_wave_timer 180)
(global short k_sur_round_timer 150)
(global short k_sur_set_timer 300)
(global short k_sur_bonus_timer 150)
(global short k_sur_wave_timeout 0)
(global boolean b_sur_phantoms_semi_random false)
(global short s_sur_dropship_type 1)
(global short s_sur_dropship_crew_count 2)
(global vehicle v_sur_phantom_01 none)
(global vehicle v_sur_phantom_02 none)
(global vehicle v_sur_phantom_03 none)
(global vehicle v_sur_phantom_04 none)
(global vehicle v_sur_bonus_phantom none)
(global ai ai_sur_phantom_01 none)
(global ai ai_sur_phantom_02 none)
(global ai ai_sur_phantom_03 none)
(global ai ai_sur_phantom_04 none)
(global ai ai_sur_bonus_phantom none)
(global string s_sur_drop_side_01 "dual")
(global string s_sur_drop_side_02 "dual")
(global string s_sur_drop_side_03 "dual")
(global string s_sur_drop_side_04 "dual")
(global string s_sur_drop_side_bonus "dual")
(global boolean b_phantom_spawn true)
(global short b_phantom_spawn_count 0)
(global short k_phantom_spawn_limit 2)
(global short s_survival_wave_complete_count 0)
(global boolean b_survival_human_spawned false)
(global long survival_mode_score_silver 50000)
(global long survival_mode_score_gold 200000)
(global long survival_mode_score_onyx 1000000)
(global long survival_mode_score_mm 15000)
(global boolean b_sur_bonus_round_running false)
(global boolean b_sur_bonus_end false)
(global boolean b_sur_bonus_spawn true)
(global boolean b_sur_bonus_refilling false)
(global boolean b_sur_bonus_phantom_ready false)
(global long l_sur_pre_bonus_points 0)
(global long l_sur_post_bonus_points 0)
(global short s_sur_bonus_count 0)
(global short k_sur_bonus_squad_limit 6)
(global short k_sur_bonus_limit 20)
(global boolean b_survival_bonus_timer_begin false)
(global short k_survival_bonus_timer (* 30 60 1))
(global boolean b_phantom_move_out false)
(global short s_dropship_load_count 1)
(global boolean b_dropship_loaded false)
(global boolean b_survival_new_set true)
(global boolean b_survival_new_round true)
(global boolean b_survival_new_wave true)
(global boolean b_sur_generator_defense_active false)
(global boolean b_sur_generator_defense_fail false)
(global boolean b_sur_generator0_spawned false)
(global boolean b_sur_generator1_spawned false)
(global boolean b_sur_generator2_spawned false)
(global boolean b_sur_generator0_alive false)
(global boolean b_sur_generator1_alive false)
(global boolean b_sur_generator2_alive false)
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
(global looping_sound m_survival_start "firefight\firefight_music\firefight_music01")
(global looping_sound m_new_set "firefight\firefight_music\firefight_music01")
(global looping_sound m_initial_wave "firefight\firefight_music\firefight_music02")
(global looping_sound m_final_wave "firefight\firefight_music\firefight_music20")
(global string string_survival_map_name "none")
(global long l_player0_score 0)
(global long l_player1_score 0)
(global long l_player2_score 0)
(global long l_player3_score 0)
(global boolean b_survival_game_end_condition false)
(global boolean b_survival_entered_sudden_death false)
(global long l_sur_round_timer 0)
(global short g_survival_all_dead_seconds 0)
(global short s_sur_elite_life_monitor 0)
(global long s_sur_gen0_attack_message_cd 0)
(global long s_sur_gen1_attack_message_cd 0)
(global long s_sur_gen2_attack_message_cd 0)
(global boolean b_survival_mode_weapon_drop false)
(global boolean g_survival_bedlam false)
(global boolean g_survival_bedlam_brute true)
(global boolean b_debug_fork true)
(global boolean b_debug_pelican true)
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
(global short s_round 65535)
(global boolean g_timer_var false)
(global boolean b_sur_resupply_waypoint_01 false)
(global boolean b_sur_resupply_waypoint_02 false)
(global boolean b_sur_resupply_waypoint_03 false)
(global boolean b_sur_resupply_waypoint_04 false)
(global boolean b_sur_resupply_waypoint_05 false)
(global vehicle v_sur_drop_01 none)
(global vehicle v_sur_drop_02 none)
(global vehicle v_sur_drop_03 none)
(global vehicle v_sur_drop_04 none)
(global vehicle v_sur_pelican none)
(global vehicle g_callout_phantom none)
(global boolean b_phantom_01 true)
(global boolean b_phantom_02 true)
(global boolean b_phantom_03 true)
(global boolean b_phantom_04 true)
(global boolean b_banshee_flying true)
(global boolean g_sur_drop_spawn true)
(global short g_sur_drop_limit 0)
(global short g_sur_drop_count 0)
(global short g_sur_drop_number 0)
(global short g_sur_resupply_limit 0)

; Scripts
(script static void survival_ai_limit
    (if (difficulty_legendary)
        (begin
            (set k_sur_ai_rand_limit 3)
            (set k_sur_ai_final_limit 3)
            (set k_sur_ai_end_limit 0)
        )
        (if (difficulty_heroic)
            (begin
                (set k_sur_ai_rand_limit 3)
                (set k_sur_ai_final_limit 3)
                (set k_sur_ai_end_limit 0)
            )
            (if true
                (begin
                    (set k_sur_ai_rand_limit 3)
                    (set k_sur_ai_final_limit 3)
                    (set k_sur_ai_end_limit 0)
                )
            )
        )
    )
)

(script static void survival_ai_timeout
    (if (difficulty_legendary)
        (set k_sur_wave_timeout (* 30 10))
        (if (difficulty_heroic)
            (set k_sur_wave_timeout (* 30 20))
            (if true
                (set k_sur_wave_timeout (* 30 30))
            )
        )
    )
)

(script static void survival_wave_timer
    (if (difficulty_legendary)
        (set k_sur_wave_timer (* 30 3))
        (if (difficulty_heroic)
            (set k_sur_wave_timer (* 30 6))
            (if true
                (set k_sur_wave_timer (* 30 9))
            )
        )
    )
)

(script static void survival_round_timer
    (if (difficulty_legendary)
        (set k_sur_round_timer (* 30 5))
        (if (difficulty_heroic)
            (set k_sur_round_timer (* 30 10))
            (if true
                (set k_sur_round_timer (* 30 15))
            )
        )
    )
)

(script static void survival_set_timer
    (if (difficulty_legendary)
        (set k_sur_set_timer (* 30 10))
        (if (difficulty_heroic)
            (set k_sur_set_timer (* 30 20))
            (if true
                (set k_sur_set_timer (* 30 30))
            )
        )
    )
)

(script static void survival_bonus_wait_timer
    (if (difficulty_legendary)
        (set k_sur_bonus_timer (* 30 5))
        (if (difficulty_heroic)
            (set k_sur_bonus_timer (* 30 10))
            (if true
                (set k_sur_bonus_timer (* 30 15))
            )
        )
    )
)

(script dormant void survival_license_plate
    (if (> (survival_mode_generator_count) 0)
        (begin
            (survival_mode_set_elite_license_plate 37 29 "sur_game_name" "sur_cov_gen_desc" "elite_icon")
            (survival_mode_set_spartan_license_plate 37 28 "sur_game_name" "sur_unsc_gen_desc" "spartan_icon")
        )
        (begin
            (survival_mode_set_elite_license_plate 37 29 "sur_game_name" "sur_cov_game_desc" "elite_icon")
            (survival_mode_set_spartan_license_plate 37 28 "sur_game_name" "sur_unsc_game_desc" "spartan_icon")
        )
    )
)

(script dormant void survival_mode
    (wake survival_human_player_has_spawned)
    (ai_allegiance human player)
    (ai_allegiance player human)
    (ai_allegiance covenant covenant_player)
    (ai_allegiance covenant_player covenant)
    (player_set_spartan_loadout (human_player_in_game_get 0))
    (player_set_spartan_loadout (human_player_in_game_get 1))
    (player_set_spartan_loadout (human_player_in_game_get 2))
    (player_set_spartan_loadout (human_player_in_game_get 3))
    (player_set_spartan_loadout (human_player_in_game_get 4))
    (player_set_spartan_loadout (human_player_in_game_get 5))
    (player_set_elite_loadout (elite_player_in_game_get 0))
    (player_set_elite_loadout (elite_player_in_game_get 1))
    (player_set_elite_loadout (elite_player_in_game_get 2))
    (player_set_elite_loadout (elite_player_in_game_get 3))
    (player_set_elite_loadout (elite_player_in_game_get 4))
    (player_set_elite_loadout (elite_player_in_game_get 5))
    (if (not alpha_sync_slayer)
        (sound_looping_start m_survival_start none 1)
    )
    (survival_ai_limit)
    (survival_lives)
    (wake survival_ammo_crate_create)
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
    (if (> (player_count) 0)
        (cinematic_snap_from_black)
    )
    (wake survival_license_plate)
    (sleep (* 30 1))
    (event_welcome)
    (sleep (* 30 2))
    (event_intro)
    (wake survival_lives_announcement)
    (wake survival_award_achievement)
    (wake survival_bonus_round_end)
    (wake survival_end_game)
    (wake survival_elite_manager)
    (wake survival_ammo_crate_waypoint)
    (wake survival_bonus_round_dropship)
    (wake survival_score_attack)
    (wake survival_score_attack_mm)
    (wake survival_health_pack_hud)
    (if alpha_sync_slayer
        (wake survival_slayer_medpack_respawner)
    )
    (sleep (* 30 3))
    (if (survival_mode_weapon_drops_enable)
        (begin
            (set b_survival_mode_weapon_drop true)
        )
    )
    (if (not alpha_sync_slayer)
        (sound_looping_stop m_survival_start)
    )
    (wake survival_all_dead_timer)
    (if (not alpha_sync_slayer)
        (sleep_until 
            (begin
                (if debug
                    (print "beginning new set")
                )
                (survival_mode_begin_new_set)
                (sleep 1)
                (survival_begin_announcer)
                (if debug_bonus_round
                    (survival_bonus_wave_test)
                    (survival_wave_loop)
                )
                (survival_respawn_weapons)
                (survival_mode_replenish_players)
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

(script dormant void survival_human_player_has_spawned
    (sleep_until (> (players_human_living_count) 0))
    (set b_survival_human_spawned true)
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
                    (surival_set_music)
                    (survival_begin_announcer)
                    (sleep 1)
                    (if (> (survival_mode_set_get) 1)
                        (survival_respawn_crates)
                    )
                )
            )
            (survival_wave_spawn)
            (set s_survival_wave_complete_count (+ s_survival_wave_complete_count 1))
            (if (and (> (survival_mode_get_set_count) 0) (>= s_survival_wave_complete_count (survival_mode_get_set_count)))
                (begin
                    (sleep_forever)
                )
            )
            (if (survival_mode_current_wave_is_initial)
                (begin
                    (print "completed an initial wave")
                )
            )
            (if (survival_mode_current_wave_is_boss)
                (begin
                    (set b_survival_new_round true)
                    (survival_vehicle_cleanup)
                    (survival_add_lives)
                    (survival_mode_replenish_players)
                    (if (< (survival_mode_round_get) 2)
                        (begin
                            (survival_respawn_weapons)
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
    (if (and (> (survival_mode_get_set_count) 0) (>= s_survival_wave_complete_count (survival_mode_get_set_count)))
        (begin
            (sleep_forever)
        )
    )
    (survival_add_lives)
)

(script static void survival_bonus_wave_test
    (print "survival_bonus_wave_test")
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (survival_mode_begin_new_wave)
    (sleep 1)
    (set s_survival_wave_complete_count (+ s_survival_wave_complete_count 15))
    (survival_bonus_round)
)

(script continuous void survival_garbage_collector
    (sleep_forever)
    (add_recycling_volume_by_type "tv_sur_garbage_all" 4 20 16371)
    (sleep (* 30 20))
    (add_recycling_volume_by_type "tv_sur_garbage_weapon" 30 10 12)
)

(script static void survival_wave_spawn
    (if debug
        (print "spawn wave...")
    )
    (survival_mode_wave_music_start)
    (wake survival_garbage_collector)
    (survival_begin_announcer)
    (sleep 5)
    (ai_reset_objective ai_obj_survival)
    (if (wave_dropship_enabled)
        (survival_dropship_spawner)
    )
    (if (wave_dropship_enabled)
        (ai_place_wave_in_limbo (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
        (ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns s_sur_wave_squad_count)
    )
    (sleep 1)
    (if (survival_mode_bedlam)
        (survival_mode_set_bedlam_teams)
    )
    (if (wave_dropship_enabled)
        (survival_dropship_loader)
    )
    (set b_phantom_move_out true)
    (sleep 30)
    (survival_wave_end_conditions)
    (ai_migrate_persistent "gr_survival_all" ai_sur_remaining)
    (survival_end_announcer)
    (survival_mode_end_wave)
    (set b_survival_new_wave true)
    (set b_sur_wave_phantom false)
    (set b_phantom_move_out false)
    (set s_dropship_load_count 1)
    (if (and (< (survival_mode_wave_get) k_sur_wave_per_round_limit) (< s_survival_wave_complete_count (- (survival_mode_get_set_count) 1)))
        (sleep k_sur_wave_timer)
    )
    (survival_mode_wave_music_stop)
)

(script static short survival_wave_living_count
    (+ (ai_living_count "gr_survival_all") (ai_living_count "gr_survival_remaining") (max 0 (- (ai_living_count ai_sur_phantom_01) s_sur_dropship_crew_count)) (max 0 (- (ai_living_count ai_sur_phantom_02) s_sur_dropship_crew_count)) (max 0 (- (ai_living_count ai_sur_phantom_03) s_sur_dropship_crew_count)) (max 0 (- (ai_living_count ai_sur_phantom_04) s_sur_dropship_crew_count)))
)

(script static void survival_wave_end_conditions
    (sleep_until (< (survival_wave_living_count) 7))
    (survival_kill_volumes_on)
    (ai_survival_cleanup "gr_survival_all" true true)
    (ai_survival_cleanup "gr_survival_remaining" true true)
    (ai_survival_cleanup "gr_survival_extras" true true)
    (if (= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 2))
        (begin
            (sleep_until (<= (survival_wave_living_count) k_sur_ai_final_limit))
        )
        (if (or (>= (survival_mode_wave_get) (- k_sur_wave_per_round_limit 1)) (and (> (survival_mode_get_set_count) 0) (>= s_survival_wave_complete_count (- (survival_mode_get_set_count) 1))))
            (begin
                (sleep_until (<= (survival_wave_living_count) 5) 1)
                (if (and (<= (survival_wave_living_count) 5) (> (survival_wave_living_count) 2))
                    (begin
                        (event_survival_5_ai_remaining)
                        (f_blip_ai "gr_survival_all" blip_hostile)
                        (f_blip_ai "gr_survival_remaining" blip_hostile)
                    )
                )
                (sound_looping_set_alternate m_final_wave true)
                (sleep_until (<= (survival_wave_living_count) 2) 1)
                (if (= (survival_wave_living_count) 2)
                    (begin
                        (event_survival_2_ai_remaining)
                        (f_blip_ai "gr_survival_all" blip_hostile)
                        (f_blip_ai "gr_survival_remaining" blip_hostile)
                    )
                )
                (sleep_until (<= (survival_wave_living_count) 1) 1)
                (if (= (survival_wave_living_count) 1)
                    (begin
                        (event_survival_1_ai_remaining)
                        (f_blip_ai "gr_survival_all" blip_hostile)
                        (f_blip_ai "gr_survival_remaining" blip_hostile)
                    )
                )
                (sleep_until (<= (survival_wave_living_count) 0))
            )
            (if true
                (begin
                    (sleep_until (<= (survival_wave_living_count) k_sur_ai_rand_limit))
                )
            )
        )
    )
    (survival_kill_volumes_off)
    (ai_survival_cleanup "gr_survival_all" false false)
    (ai_survival_cleanup "gr_survival_remaining" false false)
    (ai_survival_cleanup "gr_survival_extras" false false)
    (sleep_until (and (< (object_get_health v_sur_phantom_01) 0) (< (object_get_health v_sur_phantom_02) 0) (< (object_get_health v_sur_phantom_03) 0) (< (object_get_health v_sur_phantom_04) 0)))
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
    (ai_reset_objective ai_obj_survival)
    (set b_sur_bonus_round_running true)
    (set b_sur_bonus_end false)
    (ai_kill_no_statistics "gr_survival_extras")
    (set l_sur_pre_bonus_points (survival_total_score))
    (survival_mode_begin_new_wave)
    (set k_survival_bonus_timer (* (survival_mode_get_current_wave_time_limit) 30))
    (chud_bonus_round_set_timer (survival_mode_get_current_wave_time_limit))
    (chud_bonus_round_show_timer true)
    (survival_mode_respawn_dead_players)
    (event_survival_bonus_round)
    (sleep 90)
    (if (wave_dropship_enabled)
        (begin
            (ai_place ai_sur_bonus_phantom)
            (ai_squad_enumerate_immigrants ai_sur_bonus_phantom true)
            (sleep 1)
            (f_survival_bonus_spawner true)
            (f_survival_bonus_spawner true)
            (f_survival_bonus_spawner true)
            (f_survival_bonus_spawner true)
        )
    )
    (set b_survival_bonus_timer_begin true)
    (sleep_until 
        (begin
            (sleep_until (or b_sur_bonus_end (<= (survival_mode_bonus_living_count) k_sur_bonus_limit) (survival_players_dead)) 1)
            (if (and (not (survival_players_dead)) (not b_sur_bonus_end))
                (begin
                    (f_survival_bonus_spawner false)
                )
            )
            (or b_sur_bonus_end (survival_players_dead))
        )
        1
    )
    (ai_kill_no_statistics ai_sur_wave_spawns)
    (ai_kill_no_statistics ai_sur_bonus_wave)
    (sleep 90)
    (event_survival_bonus_round_over)
    (skull_enable skull_iron false)
    (survival_mode_respawn_dead_players)
    (sleep 30)
    (survival_mode_end_wave)
    (survival_mode_end_set)
    (set s_survival_wave_complete_count (+ s_survival_wave_complete_count 1))
    (sleep 120)
    (set l_sur_post_bonus_points (survival_total_score))
    (chud_bonus_round_set_timer 0)
    (chud_bonus_round_show_timer false)
    (chud_bonus_round_start_timer false)
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
            (sleep_until (survival_players_dead) 1 k_survival_bonus_timer)
            (set b_sur_bonus_end true)
            (if (survival_players_dead)
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

(script static void (f_survival_bonus_spawner (boolean force_load))
    (if debug
        (print "spawn bonus squad...")
    )
    (if (or force_load (and b_sur_bonus_phantom_ready (wave_dropship_enabled) (= (random_range 0 2) 0)))
        (begin
            (ai_place_wave_in_limbo (survival_mode_get_wave_squad) ai_sur_wave_spawns 1)
            (sleep 1)
            (f_survival_bonus_load_dropship ai_sur_wave_spawns)
        )
        (begin
            (ai_place_wave (survival_mode_get_wave_squad) ai_sur_wave_spawns 1)
            (sleep 1)
            (ai_migrate_persistent ai_sur_wave_spawns ai_sur_bonus_wave)
        )
    )
)

(script static void (f_survival_bonus_load_dropship (ai load_squad))
    (if debug
        (print "loading bonus squad into dropship...")
    )
    (if (= s_sur_dropship_type 1)
        (f_survival_load_phantom v_sur_bonus_phantom s_sur_drop_side_bonus load_squad)
        (f_survival_load_spirit v_sur_bonus_phantom s_sur_drop_side_bonus load_squad)
    )
)

(script dormant void survival_bonus_round_dropship
    (sleep_until 
        (begin
            (sleep_until (or b_sur_bonus_phantom_ready b_sur_bonus_end) 5)
            (if (not b_sur_bonus_end)
                (begin
                    (unit_open v_sur_bonus_phantom)
                    (sleep_until 
                        (begin
                            (if (= s_sur_dropship_type 1)
                                (vehicle_unload v_sur_bonus_phantom 0)
                                (vehicle_unload v_sur_bonus_phantom 1)
                            )
                            (sleep 1)
                            (ai_migrate_persistent ai_sur_wave_spawns ai_sur_bonus_wave)
                            b_sur_bonus_end
                        )
                        30
                    )
                    (unit_close v_sur_bonus_phantom)
                )
            )
            false
        )
    )
)

(script static short survival_mode_bonus_living_count
    (+ (ai_living_count ai_sur_wave_spawns) (ai_living_count ai_sur_bonus_wave) (ai_living_count ai_sur_bonus_phantom))
)

(script static long survival_total_score
    (+ (campaign_metagame_get_player_score (player_human 0)) (campaign_metagame_get_player_score (player_human 1)) (campaign_metagame_get_player_score (player_human 2)) (campaign_metagame_get_player_score (player_human 3)) (campaign_metagame_get_player_score (player_human 4)) (campaign_metagame_get_player_score (player_human 5)))
)

(script dormant void survival_score_attack
    (if debug
        (print "survival_score_attack")
    )
    (sleep_until (>= (survival_total_score) survival_mode_score_silver))
    (if debug
        (print "survival_score_attack silver")
    )
    (submit_incident_for_spartans "score_silver")
    (sleep_until (>= (survival_total_score) survival_mode_score_gold))
    (if debug
        (print "survival_score_attack gold")
    )
    (submit_incident_for_spartans "score_gold")
    (sleep_until (>= (survival_total_score) survival_mode_score_onyx))
    (if debug
        (print "survival_score_attack onyx")
    )
    (submit_incident_for_spartans "score_onyx")
)

(script dormant void survival_score_attack_mm
    (sleep_until (>= (survival_total_score) survival_mode_score_mm))
    (if debug
        (print "survival_score_attack mm_achieve")
    )
    (submit_incident_for_spartans "mm_score_achieve")
)

(script static void survival_dropship_spawner
    (sleep_until 
        (begin
            (if b_sur_phantoms_semi_random
                (begin_random
                    (begin
                        (if b_phantom_spawn
                            (f_survival_dropship_spawner ai_sur_phantom_01)
                        )
                        (if b_phantom_spawn
                            (f_survival_dropship_spawner ai_sur_phantom_02)
                        )
                    )
                    (begin
                        (if b_phantom_spawn
                            (f_survival_dropship_spawner ai_sur_phantom_03)
                        )
                        (if b_phantom_spawn
                            (f_survival_dropship_spawner ai_sur_phantom_04)
                        )
                    )
                )
                (begin_random
                    (if b_phantom_spawn
                        (f_survival_dropship_spawner ai_sur_phantom_01)
                    )
                    (if b_phantom_spawn
                        (f_survival_dropship_spawner ai_sur_phantom_02)
                    )
                    (if b_phantom_spawn
                        (f_survival_dropship_spawner ai_sur_phantom_03)
                    )
                    (if b_phantom_spawn
                        (f_survival_dropship_spawner ai_sur_phantom_04)
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

(script static void survival_spirit_spawner
    (print "foo")
)

(script static void (f_survival_dropship_spawner (ai spawned_phantom))
    (ai_place spawned_phantom)
    (sleep 1)
    (set s_sur_dropship_crew_count (ai_living_count spawned_phantom))
    (ai_force_active spawned_phantom true)
    (if (>= (object_get_health spawned_phantom) 0)
        (begin
            (if debug
                (print "spawn phantom...")
            )
            (set b_phantom_spawn_count (+ b_phantom_spawn_count 1))
            (if (>= b_phantom_spawn_count k_phantom_spawn_limit)
                (set b_phantom_spawn false)
            )
            (if (survival_mode_bedlam)
                (ai_set_team spawned_phantom (survival_mode_get_bedlam_team))
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

(script static boolean (survival_should_load_squad (ai squad))
    (and (> (ai_living_count squad) 0) (not (ai_is_in_fireteam squad)))
)

(script static void survival_dropship_loader
    (if (survival_should_load_squad (wave_squad_get 0))
        (f_survival_dropship_loader (wave_squad_get 0))
    )
    (if (survival_should_load_squad (wave_squad_get 1))
        (f_survival_dropship_loader (wave_squad_get 1))
    )
    (if (survival_should_load_squad (wave_squad_get 2))
        (f_survival_dropship_loader (wave_squad_get 2))
    )
    (if (survival_should_load_squad (wave_squad_get 3))
        (f_survival_dropship_loader (wave_squad_get 3))
    )
    (if (survival_should_load_squad (wave_squad_get 4))
        (f_survival_dropship_loader (wave_squad_get 4))
    )
    (if (survival_should_load_squad (wave_squad_get 5))
        (f_survival_dropship_loader (wave_squad_get 5))
    )
    (if (survival_should_load_squad (wave_squad_get 6))
        (f_survival_dropship_loader (wave_squad_get 6))
    )
    (if (survival_should_load_squad (wave_squad_get 7))
        (f_survival_dropship_loader (wave_squad_get 7))
    )
    (if (survival_should_load_squad (wave_squad_get 8))
        (f_survival_dropship_loader (wave_squad_get 8))
    )
    (if (survival_should_load_squad (wave_squad_get 9))
        (f_survival_dropship_loader (wave_squad_get 9))
    )
    (if (survival_should_load_squad (wave_squad_get 10))
        (f_survival_dropship_loader (wave_squad_get 10))
    )
    (if (survival_should_load_squad (wave_squad_get 11))
        (f_survival_dropship_loader (wave_squad_get 11))
    )
    (if (survival_should_load_squad (wave_squad_get 12))
        (f_survival_dropship_loader (wave_squad_get 12))
    )
    (if (survival_should_load_squad (wave_squad_get 13))
        (f_survival_dropship_loader (wave_squad_get 13))
    )
    (if (survival_should_load_squad (wave_squad_get 14))
        (f_survival_dropship_loader (wave_squad_get 14))
    )
    (if (survival_should_load_squad (wave_squad_get 15))
        (f_survival_dropship_loader (wave_squad_get 15))
    )
    (if (survival_should_load_squad (wave_squad_get 16))
        (f_survival_dropship_loader (wave_squad_get 16))
    )
    (if (survival_should_load_squad (wave_squad_get 17))
        (f_survival_dropship_loader (wave_squad_get 17))
    )
    (if (survival_should_load_squad (wave_squad_get 18))
        (f_survival_dropship_loader (wave_squad_get 18))
    )
    (if (survival_should_load_squad (wave_squad_get 19))
        (f_survival_dropship_loader (wave_squad_get 19))
    )
    (if (survival_should_load_squad (wave_squad_get 20))
        (f_survival_dropship_loader (wave_squad_get 20))
    )
)

(script static void (f_survival_dropship_loader (ai load_squad))
    (sleep_until 
        (begin
            (if (and (= b_dropship_loaded false) (= s_dropship_load_count 1))
                (begin
                    (if (and (>= (object_get_health v_sur_phantom_01) 0) (> (list_count (ai_actors load_squad)) 0))
                        (begin
                            (if debug
                                (print "** load dropship 01 **")
                            )
                            (if (= s_sur_dropship_type 1)
                                (f_survival_load_phantom v_sur_phantom_01 s_sur_drop_side_01 load_squad)
                                (f_survival_load_spirit v_sur_phantom_01 s_sur_drop_side_01 load_squad)
                            )
                        )
                    )
                    (set s_dropship_load_count 2)
                )
            )
            (if (and (= b_dropship_loaded false) (= s_dropship_load_count 2))
                (begin
                    (if (and (>= (object_get_health v_sur_phantom_02) 0) (> (list_count (ai_actors load_squad)) 0))
                        (begin
                            (if debug
                                (print "** load dropship 02 **")
                            )
                            (if (= s_sur_dropship_type 1)
                                (f_survival_load_phantom v_sur_phantom_02 s_sur_drop_side_02 load_squad)
                                (f_survival_load_spirit v_sur_phantom_02 s_sur_drop_side_02 load_squad)
                            )
                        )
                    )
                    (set s_dropship_load_count 3)
                )
            )
            (if (and (= b_dropship_loaded false) (= s_dropship_load_count 3))
                (begin
                    (if (and (>= (object_get_health v_sur_phantom_03) 0) (> (list_count (ai_actors load_squad)) 0))
                        (begin
                            (if debug
                                (print "** load dropship 03 **")
                            )
                            (if (= s_sur_dropship_type 1)
                                (f_survival_load_phantom v_sur_phantom_03 s_sur_drop_side_03 load_squad)
                                (f_survival_load_spirit v_sur_phantom_03 s_sur_drop_side_03 load_squad)
                            )
                        )
                    )
                    (set s_dropship_load_count 4)
                )
            )
            (if (and (= b_dropship_loaded false) (= s_dropship_load_count 4))
                (begin
                    (if (and (>= (object_get_health v_sur_phantom_04) 0) (> (list_count (ai_actors load_squad)) 0))
                        (begin
                            (if debug
                                (print "** load dropship 04 **")
                            )
                            (if (= s_sur_dropship_type 1)
                                (f_survival_load_phantom v_sur_phantom_04 s_sur_drop_side_04 load_squad)
                                (f_survival_load_spirit v_sur_phantom_04 s_sur_drop_side_04 load_squad)
                            )
                        )
                    )
                    (set s_dropship_load_count 1)
                )
            )
            b_dropship_loaded
        )
        1
    )
    (set b_dropship_loaded false)
)

(script static void (f_survival_load_phantom (vehicle dropship, string load_side, ai load_squad))
    (survival_set_hold_task load_squad)
    (ai_exit_limbo load_squad)
    (if (= load_side "left")
        (begin
            (if debug
                (print "load phantom left...")
            )
            (if (= (vehicle_test_seat dropship 2) false)
                (ai_vehicle_enter_immediate load_squad dropship 2)
            )
            (if (= (vehicle_test_seat dropship 3) false)
                (ai_vehicle_enter_immediate load_squad dropship 3)
            )
            (if (= (vehicle_test_seat dropship 4) false)
                (ai_vehicle_enter_immediate load_squad dropship 4)
            )
            (if (= (vehicle_test_seat dropship 5) false)
                (ai_vehicle_enter_immediate load_squad dropship 5)
            )
            (set b_dropship_loaded true)
        )
    )
    (if (= load_side "right")
        (begin
            (if debug
                (print "load phantom right...")
            )
            (if (= (vehicle_test_seat dropship 6) false)
                (ai_vehicle_enter_immediate load_squad dropship 6)
            )
            (if (= (vehicle_test_seat dropship 7) false)
                (ai_vehicle_enter_immediate load_squad dropship 7)
            )
            (if (= (vehicle_test_seat dropship 8) false)
                (ai_vehicle_enter_immediate load_squad dropship 8)
            )
            (if (= (vehicle_test_seat dropship 9) false)
                (ai_vehicle_enter_immediate load_squad dropship 9)
            )
            (set b_dropship_loaded true)
        )
    )
    (if (= load_side "dual")
        (begin
            (if debug
                (print "load phantom dual...")
            )
            (if (= (vehicle_test_seat dropship 3) false)
                (ai_vehicle_enter_immediate load_squad dropship 3)
            )
            (if (= (vehicle_test_seat dropship 7) false)
                (ai_vehicle_enter_immediate load_squad dropship 7)
            )
            (if (= (vehicle_test_seat dropship 2) false)
                (ai_vehicle_enter_immediate load_squad dropship 2)
            )
            (if (= (vehicle_test_seat dropship 6) false)
                (ai_vehicle_enter_immediate load_squad dropship 6)
            )
            (set b_dropship_loaded true)
        )
    )
    (if (= load_side "chute")
        (begin
            (if debug
                (print "load phantom chute...")
            )
            (if (= (vehicle_test_seat dropship 10) false)
                (ai_vehicle_enter_immediate load_squad dropship 10)
            )
            (if (= (vehicle_test_seat dropship 11) false)
                (ai_vehicle_enter_immediate load_squad dropship 11)
            )
            (if (= (vehicle_test_seat dropship 12) false)
                (ai_vehicle_enter_immediate load_squad dropship 12)
            )
            (if (= (vehicle_test_seat dropship 13) false)
                (ai_vehicle_enter_immediate load_squad dropship 13)
            )
            (set b_dropship_loaded true)
        )
    )
)

(script static void (f_survival_load_spirit (vehicle dropship, string load_side, ai load_squad))
    (if debug
        (print "load spirit...")
    )
    (survival_set_hold_task load_squad)
    (ai_exit_limbo load_squad)
    (if (= load_side "left")
        (begin
            (ai_vehicle_enter_immediate load_squad dropship 14)
        )
    )
    (if (= load_side "right")
        (begin
            (ai_vehicle_enter_immediate load_squad dropship 15)
        )
    )
    (if (= load_side "dual")
        (begin
            (ai_vehicle_enter_immediate load_squad dropship 16)
            (ai_vehicle_enter_immediate load_squad dropship 17)
            (ai_vehicle_enter_immediate load_squad dropship 18)
            (ai_vehicle_enter_immediate load_squad dropship 19)
            (ai_vehicle_enter_immediate load_squad dropship 20)
            (ai_vehicle_enter_immediate load_squad dropship 21)
            (ai_vehicle_enter_immediate load_squad dropship 22)
            (ai_vehicle_enter_immediate load_squad dropship 23)
            (ai_vehicle_enter_immediate load_squad dropship 24)
            (ai_vehicle_enter_immediate load_squad dropship 25)
            (ai_vehicle_enter_immediate load_squad dropship 26)
            (ai_vehicle_enter_immediate load_squad dropship 27)
            (ai_vehicle_enter_immediate load_squad dropship 28)
            (ai_vehicle_enter_immediate load_squad dropship 29)
            (ai_vehicle_enter_immediate load_squad dropship 30)
            (ai_vehicle_enter_immediate load_squad dropship 31)
        )
    )
    (ai_vehicle_enter_immediate load_squad dropship 1)
    (set b_dropship_loaded true)
)

(script static void (survival_callout_dropship_internal (object dropship, short time))
    (sound_impulse_start sfx_blip none 1)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 0) dropship 14)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 1) dropship 14)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 2) dropship 14)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 3) dropship 14)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 4) dropship 14)
    (chud_track_object_for_player_with_priority (human_player_in_game_get 5) dropship 14)
    (sleep time)
    (chud_track_object dropship false)
)

(script static void (f_survival_callout_dropship (object dropship))
    (survival_callout_dropship_internal dropship 200)
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
            (survival_countdown_timer)
            (event_survival_new_set)
            (set b_survival_new_set false)
            (set b_survival_new_round false)
            (set b_survival_new_wave false)
        )
        (if b_survival_new_round
            (begin
                (if debug
                    (print "announce new round...")
                )
                (survival_countdown_timer)
                (event_survival_new_round)
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
                            (event_survival_reinforcements)
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
                (event_survival_end_round)
                (sleep (* 30 3))
            )
            (if true
                (begin
                    (sleep (* 30 5))
                    (if debug
                        (print "announce end set...")
                    )
                    (event_survival_end_set)
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
                    (event_survival_5_lives_left)
                )
            )
            (sleep_until (or (<= (survival_mode_lives_get player) 1) (> (survival_mode_lives_get player) 5)) 1)
            (if (= (survival_mode_lives_get player) 1)
                (begin
                    (if debug
                        (print "1 life left...")
                    )
                    (event_survival_1_life_left)
                )
            )
            (sleep_until (or (<= (survival_mode_lives_get player) 0) (> (survival_mode_lives_get player) 1)) 1)
            (if (<= (survival_mode_lives_get player) 0)
                (begin
                    (if debug
                        (print "0 lives left...")
                    )
                    (event_survival_0_lives_left)
                )
            )
            (sleep_until (or (<= (players_human_living_count) 1) (> (survival_mode_lives_get player) 0)) 1)
            (if (and (<= (survival_mode_lives_get player) 0) (= (players_human_living_count) 1))
                (begin
                    (if debug
                        (print "last man standing...")
                    )
                    (event_survival_last_man_standing)
                )
            )
            false
        )
    )
)

(script dormant void survival_mode_generator_defense
    (set b_sur_generator_defense_active true)
    (survival_mode_gd_spawn_generators)
    (sleep 1)
    (wake survival_generator0_management)
    (wake survival_generator1_management)
    (wake survival_generator2_management)
    (if b_sur_generator0_spawned
        (begin
            (ai_object_set_team obj_sur_generator0 player)
            (ai_object_set_targeting_bias obj_sur_generator0 0.85)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator0 false)
            (object_set_allegiance obj_sur_generator0 player)
            (object_immune_to_friendly_damage obj_sur_generator0 true)
            (set b_sur_generator0_alive true)
        )
    )
    (if b_sur_generator1_spawned
        (begin
            (ai_object_set_team obj_sur_generator1 player)
            (ai_object_set_targeting_bias obj_sur_generator1 0.85)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator1 false)
            (object_set_allegiance obj_sur_generator1 player)
            (object_immune_to_friendly_damage obj_sur_generator1 true)
            (set b_sur_generator1_alive true)
        )
    )
    (if b_sur_generator2_spawned
        (begin
            (ai_object_set_team obj_sur_generator2 player)
            (ai_object_set_targeting_bias obj_sur_generator2 0.85)
            (ai_object_enable_targeting_from_vehicle obj_sur_generator2 false)
            (object_set_allegiance obj_sur_generator2 player)
            (object_immune_to_friendly_damage obj_sur_generator2 true)
            (set b_sur_generator2_alive true)
        )
    )
    (sleep_until 
        (begin
            (if (< (object_get_health obj_sur_generator0) r_sur_generator0_health)
                (event_survival_generator0_attacked)
            )
            (if (< (object_get_health obj_sur_generator1) r_sur_generator1_health)
                (event_survival_generator1_attacked)
            )
            (if (< (object_get_health obj_sur_generator2) r_sur_generator2_health)
                (event_survival_generator2_attacked)
            )
            (set r_sur_generator0_health (object_get_health obj_sur_generator0))
            (set r_sur_generator1_health (object_get_health obj_sur_generator1))
            (set r_sur_generator2_health (object_get_health obj_sur_generator2))
            (if (< (survival_mode_gd_generator_count) s_sur_generators_alive)
                (begin
                    (event_survival_generator_died)
                    (submit_incident_for_elites "team_generator_kill")
                )
            )
            (set s_sur_generators_alive (survival_mode_gd_generator_count))
            (not (survival_mode_gd_generators_alive))
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

(script dormant void survival_generator0_management
    (device_set_position_immediate obj_sur_generator0 0)
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator0) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator0 0.85)
                    (if b_survival_entered_sudden_death
                        (survival_generator_switch 0 3)
                        (if (> s_surv_generator0_cooldown 0)
                            (begin
                                (survival_generator_switch 0 2)
                                (sleep s_surv_generator0_cooldown)
                                (set s_surv_generator0_cooldown 0)
                            )
                            (survival_generator_switch 0 1)
                        )
                    )
                )
                (begin
                    (event_survival_generator0_locked)
                    (survival_generator_switch 0 0)
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
        (survival_generator_switch 0 0)
        (ai_object_set_targeting_bias obj_sur_generator0 -1)
        (set b_sur_generator0_alive false)
    )
)

(script dormant void survival_generator1_management
    (device_set_position_immediate obj_sur_generator1 0)
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator1) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator1 0.85)
                    (if b_survival_entered_sudden_death
                        (survival_generator_switch 1 3)
                        (if (> s_surv_generator1_cooldown 0)
                            (begin
                                (survival_generator_switch 1 2)
                                (sleep s_surv_generator1_cooldown)
                                (set s_surv_generator1_cooldown 0)
                            )
                            (survival_generator_switch 1 1)
                        )
                    )
                )
                (begin
                    (event_survival_generator1_locked)
                    (survival_generator_switch 1 0)
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
        (survival_generator_switch 1 0)
        (ai_object_set_targeting_bias obj_sur_generator1 -1)
        (set b_sur_generator1_alive false)
    )
)

(script dormant void survival_generator2_management
    (device_set_position_immediate obj_sur_generator2 0)
    (sleep_until 
        (begin
            (if (<= (device_get_position obj_sur_generator2) 0.1)
                (begin
                    (ai_object_set_targeting_bias obj_sur_generator2 0.85)
                    (if b_survival_entered_sudden_death
                        (survival_generator_switch 2 3)
                        (if (> s_surv_generator2_cooldown 0)
                            (begin
                                (survival_generator_switch 2 2)
                                (sleep s_surv_generator2_cooldown)
                                (set s_surv_generator2_cooldown 0)
                            )
                            (survival_generator_switch 2 1)
                        )
                    )
                )
                (begin
                    (event_survival_generator2_locked)
                    (survival_generator_switch 2 0)
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
        (survival_generator_switch 2 0)
        (ai_object_set_targeting_bias obj_sur_generator2 -1)
        (set b_sur_generator2_alive false)
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
        (>= (survival_mode_gd_generator_count) (survival_mode_generator_count))
        (> (survival_mode_gd_generator_count) 0)
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
    (object_create_folder_anew folder_survival_scenery)
    (object_create_folder_anew folder_survival_crates)
    (object_create_folder_anew folder_survival_vehicles)
    (object_create_folder_anew folder_survival_devices)
    (if (survival_mode_weapon_drops_enable)
        (begin
            (set b_survival_mode_weapon_drop true)
            (event_survival_awarded_weapon)
            (object_create_folder_anew folder_survival_equipment)
            (object_create_folder_anew folder_survival_weapons)
        )
    )
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
    (sleep_until (>= (survival_total_score) 200000))
)

(script static void survival_like_marty_start
    (print "todo fix survival_like_marty_start")
)

(script static void survival_like_marty_award
    (print "todo fix survival_like_marty_award")
)

(script startup void survival_round_timer_counter
    (sleep 300)
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
    (wake survival_mode_end_condition_complete)
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
    (sleep_until (and b_survival_human_spawned (= b_sur_bonus_round_running false) (survival_players_dead) (survival_players_not_respawning)) 10)
    (sleep 30)
    (survival_elites_increment_score)
    (event_survival_elites_win_normal)
    (set b_survival_game_end_condition true)
)

(script dormant void survival_mode_end_condition_generators
    (sleep_until b_sur_generator_defense_fail 10)
    (sleep 30)
    (survival_elites_increment_score)
    (event_survival_elites_win_gen)
    (set b_survival_game_end_condition true)
)

(script dormant void survival_mode_end_condition_time
    (sleep_until (and (= b_sur_bonus_round_running false) (> (survival_mode_get_time_limit) 0) (>= l_sur_round_timer (* (survival_mode_get_time_limit) 60))) 10)
    (if (survival_sudden_death_condition)
        (survival_sudden_death)
    )
    (sleep_forever survival_mode_end_condition_generators)
    (if b_sur_generator_defense_fail
        (begin
            (survival_elites_increment_score)
            (event_survival_elites_win_gen)
        )
        (begin
            (survival_spartans_increment_score)
            (event_survival_spartans_win_gen)
            (submit_incident "survival_mm_game_complete")
        )
    )
    (set b_survival_game_end_condition true)
)

(script dormant void survival_mode_end_condition_complete
    (sleep_until (and (> (survival_mode_get_set_count) 0) (>= s_survival_wave_complete_count (survival_mode_get_set_count))) 10)
    (sleep 30)
    (survival_spartans_increment_score)
    (event_survival_spartans_win_normal)
    (submit_incident "survival_mm_game_complete")
    (set b_survival_game_end_condition true)
)

(script static void survival_sudden_death
    (event_survival_sudden_death)
    (survival_mode_sudden_death true)
    (set b_survival_entered_sudden_death true)
    (device_set_power obj_sur_generator_switch0 0)
    (device_set_power obj_sur_generator_switch1 0)
    (device_set_power obj_sur_generator_switch2 0)
    (sleep_until (not (survival_sudden_death_condition)) 2 1800)
    (event_survival_sudden_death_over)
    (sleep 30)
    (survival_mode_sudden_death false)
    (sleep 150)
)

(script static boolean survival_sudden_death_condition
    (or (and (> (object_get_health "generator0") 0) (> (device_get_position "generator0") 0)) (and (> (object_get_health "generator1") 0) (> (device_get_position "generator1") 0)) (and (> (object_get_health "generator2") 0) (> (device_get_position "generator2") 0)))
)

(script static void survival_spartans_increment_score
    (survival_increment_human_score (human_player_in_game_get 0))
    (survival_increment_human_score (human_player_in_game_get 1))
    (survival_increment_human_score (human_player_in_game_get 2))
    (survival_increment_human_score (human_player_in_game_get 3))
    (survival_increment_human_score (human_player_in_game_get 4))
    (survival_increment_human_score (human_player_in_game_get 5))
)

(script static void survival_elites_increment_score
    (survival_increment_elite_score (elite_player_in_game_get 0))
    (survival_increment_elite_score (elite_player_in_game_get 1))
    (survival_increment_elite_score (elite_player_in_game_get 2))
    (survival_increment_elite_score (elite_player_in_game_get 3))
    (survival_increment_elite_score (elite_player_in_game_get 4))
    (survival_increment_elite_score (elite_player_in_game_get 5))
)

(script static boolean survival_players_dead
    (<= (players_human_living_count) 0)
)

(script static boolean survival_players_not_respawning
    (or (= (survival_mode_lives_get player) 0) (and (survival_mode_team_respawns_on_wave player) (>= g_survival_all_dead_seconds 5)))
)

(script dormant void survival_all_dead_timer
    (if (survival_mode_team_respawns_on_wave player)
        (sleep_until 
            (begin
                (if (survival_players_dead)
                    (set g_survival_all_dead_seconds (+ g_survival_all_dead_seconds 1))
                    (set g_survival_all_dead_seconds 0)
                )
                false
            )
            30
        )
    )
)

(script static void survival_refresh_sleep
    (if (>= (ai_living_count "gr_survival_all") 10)
        (if (difficulty_normal)
            (sleep (* (random_range 20 30) 30))
            (if (difficulty_heroic)
                (sleep (* (random_range 10 20) 30))
                (if (difficulty_legendary)
                    (sleep (* (random_range 5 10) 30))
                )
            )
        )
        (sleep 30)
    )
)

(script dormant void survival_elite_manager
    (sleep_until (> (players_elite_living_count) 0))
    (if debug
        (print "starting elite scripts")
    )
)

(script dormant void survival_elite_life_monitor
    (sleep_until 
        (begin
            (if (< (players_elite_living_count) s_sur_elite_life_monitor)
                (begin
                    (survival_mode_add_human_lives (* (- s_sur_elite_life_monitor (players_elite_living_count)) (survival_mode_bonus_lives_elite_death)))
                )
            )
            (set s_sur_elite_life_monitor (players_elite_living_count))
            false
        )
        1
    )
)

(script static boolean (survival_squad_contains_fireteam (ai squad))
    (and (> (ai_living_count squad) 0) (= (unit_get_team_index (unit (list_get (ai_actors squad) 0))) 65535))
)

(script static void survival_lives
    (if (< (survival_mode_get_shared_team_life_count) 0)
        (survival_mode_lives_set player -1)
        (survival_mode_lives_set player (survival_mode_get_shared_team_life_count))
    )
    (if (< (survival_mode_get_elite_life_count) 0)
        (survival_mode_lives_set covenant_player -1)
        (survival_mode_lives_set covenant_player (survival_mode_get_elite_life_count))
    )
)

(script static void survival_add_lives
    (survival_mode_award_hero_medal)
    (sleep 1)
    (survival_mode_respawn_dead_players)
    (sleep 1)
    (if (and (>= (survival_mode_lives_get player) 0) (< (survival_mode_lives_get player) (survival_mode_max_lives)))
        (begin
            (survival_mode_add_human_lives (survival_mode_player_count_by_team player))
            (event_survival_awarded_lives)
        )
    )
)

(script stub void survival_vehicle_cleanup
    (if debug
        (print "**vehicle cleanup**")
    )
)

(script static boolean wave_dropship_enabled
    (if (!= s_sur_dropship_type 0)
        (survival_mode_current_wave_uses_dropship)
        false
    )
)

(script static short players_human_living_count
    (list_count (players_human))
)

(script static unit (player_human (short index))
    (if (< index (players_human_living_count))
        (unit (list_get (players_human) index))
        none
    )
)

(script static short players_elite_living_count
    (list_count (players_elite))
)

(script static unit (player_elite (short index))
    (if (< index (players_elite_living_count))
        (unit (list_get (players_elite) index))
        none
    )
)

(script static void (survival_mode_add_human_lives (short lives))
    (if (not b_survival_game_end_condition)
        (if (> (survival_mode_max_lives) 0)
            (survival_mode_lives_set player (max (min (survival_mode_max_lives) (+ (survival_mode_lives_get player) lives)) (survival_mode_lives_get player)))
        )
    )
)

(script static void survival_mode_replenish_players
    (unit_set_current_vitality (player_human 0) 80 80)
    (unit_set_current_vitality (player_human 1) 80 80)
    (unit_set_current_vitality (player_human 2) 80 80)
    (unit_set_current_vitality (player_human 3) 80 80)
    (unit_set_current_vitality (player_human 4) 80 80)
    (unit_set_current_vitality (player_human 5) 80 80)
    (unit_set_current_vitality (player_elite 0) 80 80)
    (unit_set_current_vitality (player_elite 1) 80 80)
    (unit_set_current_vitality (player_elite 2) 80 80)
    (unit_set_current_vitality (player_elite 3) 80 80)
    (unit_set_current_vitality (player_elite 4) 80 80)
    (unit_set_current_vitality (player_elite 5) 80 80)
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
    (submit_incident "survival_welcome")
)

(script static void event_intro
    (if debug
        (print "event_intro")
    )
    (if (> (survival_mode_generator_count) 0)
        (begin
            (submit_incident_with_cause_campaign_team "sur_gen_unsc_start" player)
            (submit_incident_with_cause_campaign_team "sur_gen_cov_start" covenant_player)
        )
        (begin
            (submit_incident_with_cause_campaign_team "sur_cla_unsc_start" player)
            (submit_incident_with_cause_campaign_team "sur_cla_cov_start" covenant_player)
        )
    )
)

(script static void event_survival_awarded_lives
    (if debug
        (print "survival_awarded_lives")
    )
    (submit_incident_with_cause_campaign_team "survival_awarded_lives" player)
)

(script static void event_survival_5_ai_remaining
    (if debug
        (print "survival_5_ai_remaining")
    )
    (submit_incident_with_cause_campaign_team "survival_5_ai_remaining" player)
)

(script static void event_survival_2_ai_remaining
    (if debug
        (print "survival_2_ai_remaining")
    )
    (submit_incident_with_cause_campaign_team "survival_2_ai_remaining" player)
)

(script static void event_survival_1_ai_remaining
    (if debug
        (print "survival_1_ai_remaining")
    )
    (submit_incident_with_cause_campaign_team "survival_1_ai_remaining" player)
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
    (submit_incident_with_cause_campaign_team "survival_bonus_lives_awarded" player)
)

(script static void event_survival_better_luck_next_time
    (if debug
        (print "survival_better_luck_next_time")
    )
    (submit_incident_with_cause_campaign_team "survival_better_luck_next_time" player)
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
    (submit_incident_with_cause_campaign_team "survival_5_lives_left" player)
)

(script static void event_survival_1_life_left
    (if debug
        (print "survival_1_life_left")
    )
    (submit_incident_with_cause_campaign_team "survival_1_life_left" player)
)

(script static void event_survival_0_lives_left
    (if debug
        (print "survival_0_lives_left")
    )
    (submit_incident_with_cause_campaign_team "survival_0_lives_left" player)
)

(script static void event_survival_last_man_standing
    (if debug
        (print "survival_last_man_standing")
    )
    (submit_incident_with_cause_campaign_team "survival_last_man_standing" player)
)

(script static void event_survival_awarded_weapon
    (if debug
        (print "survival_awarded_weapon")
    )
    (submit_incident "survival_awarded_weapon")
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
    (submit_incident_with_cause_campaign_team "survival_generator_lost" player)
    (submit_incident_with_cause_campaign_team "survival_generator_destroyed" covenant_player)
)

(script static void event_survival_generator0_attacked
    (if (>= (game_tick_get) s_sur_gen0_attack_message_cd)
        (begin
            (if debug
                (print "event_survival_generator0_attacked")
            )
            (submit_incident_with_cause_campaign_team "survival_alpha_under_attack" player)
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
            (submit_incident_with_cause_campaign_team "survival_bravo_under_attack" player)
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
            (submit_incident_with_cause_campaign_team "survival_charlie_under_attack" player)
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

(script static void event_survival_spartans_win_normal
    (if debug
        (print "event_survival_spartans_win_normal")
    )
    (submit_incident_with_cause_campaign_team "sur_gen_unsc_win" player)
    (submit_incident_with_cause_campaign_team "sur_cla_cov_fail" covenant_player)
)

(script static void event_survival_elites_win_normal
    (if debug
        (print "event_survival_elites_win_normal")
    )
    (submit_incident_with_cause_campaign_team "sur_cla_unsc_fail" player)
    (submit_incident_with_cause_campaign_team "sur_cov_win" covenant_player)
)

(script static void event_survival_spartans_win_gen
    (if debug
        (print "event_survival_spartans_win_gen")
    )
    (submit_incident_with_cause_campaign_team "sur_gen_unsc_win" player)
    (submit_incident_with_cause_campaign_team "sur_gen_cov_fail" covenant_player)
)

(script static void event_survival_elites_win_gen
    (if debug
        (print "event_survival_elites_win_gen")
    )
    (submit_incident_with_cause_campaign_team "sur_gen_unsc_fail" player)
    (submit_incident_with_cause_campaign_team "sur_cov_win" covenant_player)
)

(script static void event_survival_time_up
    (if debug
        (print "event_survival_time_up")
    )
    (submit_incident_with_cause_campaign_team "sur_unsc_timeout" player)
    (submit_incident_with_cause_campaign_team "sur_cov_timeout" covenant_player)
)

(script dormant void survival_ammo_crate_create
    (if (survival_mode_ammo_crates_enable)
        (begin
            (object_create_anew obj_ammo_crate0)
            (object_create_anew obj_ammo_crate1)
        )
    )
)

(script dormant void survival_ammo_crate_waypoint
    (if (survival_mode_ammo_crates_enable)
        (begin
            (object_create_anew obj_ammo_crate0)
            (object_create_anew obj_ammo_crate1)
            (chud_track_object_with_priority obj_ammo_crate0 13)
            (chud_track_object_with_priority obj_ammo_crate1 13)
            (sleep 450)
            (chud_track_object obj_ammo_crate0 false)
            (chud_track_object obj_ammo_crate1 false)
        )
    )
)

(script static void (survival_health_pack_highlight (device_name pack, unit subject))
    (if (or (< (object_get_health pack) 0) (< (object_get_health subject) 0) (> (object_get_health subject) 0.666) (> (objects_distance_to_object pack subject) 3))
        (begin
            (chud_track_object_for_player subject pack false)
        )
        (begin
            (chud_track_object_for_player_with_priority subject pack 21)
        )
    )
)

(script dormant void survival_health_pack_hud
    (sleep_until 
        (begin
            (survival_health_pack_highlight "health_pack0" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack0" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack0" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack0" (human_player_in_game_get 3))
            (survival_health_pack_highlight "health_pack1" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack1" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack1" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack1" (human_player_in_game_get 3))
            (survival_health_pack_highlight "health_pack2" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack2" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack2" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack2" (human_player_in_game_get 3))
            (survival_health_pack_highlight "health_pack3" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack3" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack3" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack3" (human_player_in_game_get 3))
            (survival_health_pack_highlight "health_pack4" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack4" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack4" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack4" (human_player_in_game_get 3))
            (survival_health_pack_highlight "health_pack5" (human_player_in_game_get 0))
            (survival_health_pack_highlight "health_pack5" (human_player_in_game_get 1))
            (survival_health_pack_highlight "health_pack5" (human_player_in_game_get 2))
            (survival_health_pack_highlight "health_pack5" (human_player_in_game_get 3))
            false
        )
        15
    )
)

(script static boolean survival_mode_should_drop_weapon
    (and (survival_mode_weapon_drops_enable) (if b_survival_mode_weapon_drop
        (begin
            (set b_survival_mode_weapon_drop false)
            true
        )
        false
    ))
)

(script command_script void cs_lod
    (ai_force_full_lod ai_current_actor)
)

(script static boolean survival_mode_bedlam
    (= g_survival_bedlam true)
)

(script static team survival_mode_get_bedlam_team
    (if g_survival_bedlam_brute
        (begin
            (set g_survival_bedlam_brute false)
            brute
        )
        (begin
            (set g_survival_bedlam_brute true)
            mule
        )
    )
)

(script static void survival_mode_set_bedlam_teams
    (if (> (wave_squad_get_count 0) 0)
        (ai_set_team (wave_squad_get 0) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 1) 0)
        (ai_set_team (wave_squad_get 1) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 2) 0)
        (ai_set_team (wave_squad_get 2) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 3) 0)
        (ai_set_team (wave_squad_get 3) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 4) 0)
        (ai_set_team (wave_squad_get 4) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 5) 0)
        (ai_set_team (wave_squad_get 5) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 6) 0)
        (ai_set_team (wave_squad_get 6) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 7) 0)
        (ai_set_team (wave_squad_get 7) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 8) 0)
        (ai_set_team (wave_squad_get 8) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 9) 0)
        (ai_set_team (wave_squad_get 9) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 10) 0)
        (ai_set_team (wave_squad_get 10) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 11) 0)
        (ai_set_team (wave_squad_get 11) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 12) 0)
        (ai_set_team (wave_squad_get 12) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 13) 0)
        (ai_set_team (wave_squad_get 13) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 14) 0)
        (ai_set_team (wave_squad_get 14) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 15) 0)
        (ai_set_team (wave_squad_get 15) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 16) 0)
        (ai_set_team (wave_squad_get 16) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 17) 0)
        (ai_set_team (wave_squad_get 17) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 18) 0)
        (ai_set_team (wave_squad_get 18) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 19) 0)
        (ai_set_team (wave_squad_get 19) (survival_mode_get_bedlam_team))
    )
    (if (> (wave_squad_get_count 20) 0)
        (ai_set_team (wave_squad_get 20) (survival_mode_get_bedlam_team))
    )
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
    (campaign_metagame_award_points (player0) 500)
)

(script static void test_award_1000
    (campaign_metagame_award_points (player0) 1000)
)

(script static void test_award_5000
    (campaign_metagame_award_points (player0) 5000)
)

(script static void test_award_10000
    (campaign_metagame_award_points (player0) 10000)
)

(script static void test_award_20000
    (campaign_metagame_award_points (player0) 20000)
)

(script static void test_award_30000
    (campaign_metagame_award_points (player0) 30000)
)

(script static void test_4_player
    (set k_sur_squad_per_wave_limit 6)
    (set k_phantom_spawn_limit 2)
)

(script static short (test_wave_template (short index))
    (ai_place_wave index ai_sur_wave_spawns s_sur_wave_squad_count)
    (ai_living_count ai_sur_wave_spawns)
)

(script static void (f_load_fork (vehicle fork, string load_side, ai load_squad_01, ai load_squad_02, ai load_squad_03, ai load_squad_04))
    (ai_place load_squad_01)
    (ai_place load_squad_02)
    (ai_place load_squad_03)
    (ai_place load_squad_04)
    (sleep 1)
    (if (= load_side "left")
        (begin
            (if b_debug_fork
                (print "load fork left...")
            )
            (ai_vehicle_enter_immediate load_squad_01 fork 14)
            (ai_vehicle_enter_immediate load_squad_02 fork 14)
            (ai_vehicle_enter_immediate load_squad_03 fork 14)
            (ai_vehicle_enter_immediate load_squad_04 fork 14)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_fork
                    (print "load fork right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 fork 15)
                (ai_vehicle_enter_immediate load_squad_02 fork 15)
                (ai_vehicle_enter_immediate load_squad_03 fork 15)
                (ai_vehicle_enter_immediate load_squad_04 fork 15)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_fork
                        (print "load fork dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 fork 14)
                    (ai_vehicle_enter_immediate load_squad_02 fork 14)
                    (ai_vehicle_enter_immediate load_squad_03 fork 15)
                    (ai_vehicle_enter_immediate load_squad_04 fork 15)
                )
                (if (= load_side "any")
                    (begin
                        (if b_debug_fork
                            (print "load fork any...")
                        )
                        (ai_vehicle_enter_immediate load_squad_01 fork 1)
                        (ai_vehicle_enter_immediate load_squad_02 fork 1)
                        (ai_vehicle_enter_immediate load_squad_03 fork 1)
                        (ai_vehicle_enter_immediate load_squad_04 fork 1)
                    )
                )
            )
        )
    )
)

(script static void (f_load_fork_cargo (vehicle fork, string load_type, ai load_squad_01, ai load_squad_02, ai load_squad_03))
    (if (= load_type "large")
        (begin
            (ai_place load_squad_01)
            (sleep 1)
            (vehicle_load_magic fork 32 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_type "small")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (ai_place load_squad_03)
                (sleep 1)
                (vehicle_load_magic fork 33 (ai_vehicle_get_from_squad load_squad_01 0))
                (vehicle_load_magic fork 34 (ai_vehicle_get_from_squad load_squad_02 0))
                (vehicle_load_magic fork 35 (ai_vehicle_get_from_squad load_squad_03 0))
            )
        )
    )
)

(script static void (f_unload_fork (vehicle fork, string drop_side))
    (if b_debug_fork
        (print "opening fork...")
    )
    (unit_open fork)
    (sleep 30)
    (if (= drop_side "left")
        (begin
            (f_unload_fork_left fork)
            (sleep 75)
        )
        (if (= drop_side "right")
            (begin
                (f_unload_fork_right fork)
                (sleep 75)
            )
            (if (= drop_side "dual")
                (begin
                    (f_unload_fork_all fork)
                    (sleep 75)
                )
            )
        )
    )
    (if b_debug_fork
        (print "closing fork...")
    )
    (unit_close fork)
)

(script static void (f_unload_fork_left (vehicle fork))
    (begin_random
        (begin
            (vehicle_unload fork 29)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 25)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 21)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 17)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 19)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 23)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 27)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 31)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_right (vehicle fork))
    (begin_random
        (begin
            (vehicle_unload fork 16)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 18)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 20)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 28)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 24)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 22)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 26)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 30)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_all (vehicle fork))
    (begin_random
        (begin
            (vehicle_unload fork 29)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 25)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 21)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 17)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 19)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 23)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 27)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 31)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 16)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 18)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 20)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 28)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 24)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 22)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 26)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 30)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_cargo (vehicle fork, string load_type))
    (if (= load_type "large")
        (vehicle_unload fork 32)
        (if (= load_type "small")
            (begin_random
                (begin
                    (vehicle_unload fork 33)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload fork 34)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload fork 35)
                    (sleep (random_range 15 30))
                )
            )
            (if (= load_type "small01")
                (vehicle_unload fork 33)
                (if (= load_type "small02")
                    (vehicle_unload fork 34)
                    (if (= load_type "small03")
                        (vehicle_unload fork 35)
                    )
                )
            )
        )
    )
)

(script static void (f_load_pelican (vehicle pelican, string load_side, ai load_squad_01, ai load_squad_02))
    (ai_place load_squad_01)
    (ai_place load_squad_02)
    (sleep 1)
    (if (= load_side "left")
        (begin
            (if b_debug_pelican
                (print "load pelican left...")
            )
            (ai_vehicle_enter_immediate load_squad_01 pelican 36)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_pelican
                    (print "load pelican right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 pelican 37)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_pelican
                        (print "load pelican dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 pelican 36)
                    (ai_vehicle_enter_immediate load_squad_02 pelican 37)
                )
            )
        )
    )
)

(script static void (f_unload_pelican_all (vehicle pelican))
    (unit_open pelican)
    (sleep 60)
    (begin_random
        (begin
            (vehicle_unload pelican 38)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 39)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 40)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 41)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 42)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 43)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 44)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 45)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 46)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload pelican 47)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_load_pelican_cargo (vehicle pelican, string load_type, ai load_squad_01, ai load_squad_02))
    (if (= load_type "large")
        (begin
            (ai_place load_squad_01)
            (sleep 1)
            (vehicle_load_magic pelican 48 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_type "small")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (sleep 1)
            )
        )
    )
)

(script static void (f_unload_pelican_cargo (vehicle pelican, string load_type))
    (if (= load_type "large")
        (vehicle_unload pelican 48)
        (if (= load_type "small")
            (begin_random
                (begin
                    (sleep (random_range 15 30))
                )
                (begin
                    (sleep (random_range 15 30))
                )
            )
        )
    )
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
            (ai_vehicle_enter_immediate load_squad_01 phantom 2)
            (ai_vehicle_enter_immediate load_squad_02 phantom 3)
            (ai_vehicle_enter_immediate load_squad_03 phantom 4)
            (ai_vehicle_enter_immediate load_squad_04 phantom 5)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_phantom
                    (print "load phantom right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 phantom 6)
                (ai_vehicle_enter_immediate load_squad_02 phantom 7)
                (ai_vehicle_enter_immediate load_squad_03 phantom 8)
                (ai_vehicle_enter_immediate load_squad_04 phantom 9)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_phantom
                        (print "load phantom dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 phantom 3)
                    (ai_vehicle_enter_immediate load_squad_02 phantom 7)
                    (ai_vehicle_enter_immediate load_squad_03 phantom 2)
                    (ai_vehicle_enter_immediate load_squad_04 phantom 6)
                )
                (if (= load_side "any")
                    (begin
                        (if b_debug_phantom
                            (print "load phantom any...")
                        )
                        (ai_vehicle_enter_immediate load_squad_01 phantom 0)
                        (ai_vehicle_enter_immediate load_squad_02 phantom 0)
                        (ai_vehicle_enter_immediate load_squad_03 phantom 0)
                        (ai_vehicle_enter_immediate load_squad_04 phantom 0)
                    )
                    (if (= load_side "chute")
                        (begin
                            (if b_debug_phantom
                                (print "load phantom chute...")
                            )
                            (ai_vehicle_enter_immediate load_squad_01 phantom 10)
                            (ai_vehicle_enter_immediate load_squad_02 phantom 11)
                            (ai_vehicle_enter_immediate load_squad_03 phantom 12)
                            (ai_vehicle_enter_immediate load_squad_04 phantom 13)
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
            (vehicle_load_magic phantom 49 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_number "double")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (sleep 1)
                (vehicle_load_magic phantom 50 (ai_vehicle_get_from_squad load_squad_01 0))
                (vehicle_load_magic phantom 51 (ai_vehicle_get_from_squad load_squad_02 0))
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
            (vehicle_unload phantom 3)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 2)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 7)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 6)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_left (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 4)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 5)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 8)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 9)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_chute (vehicle phantom))
    (object_set_phantom_power phantom true)
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
    (if (vehicle_test_seat phantom 13)
        (begin
            (vehicle_unload phantom 13)
            (sleep 120)
        )
    )
    (object_set_phantom_power phantom false)
)

(script static void (f_unload_phantom_cargo (vehicle phantom, string load_number))
    (if (= load_number "single")
        (vehicle_unload phantom 49)
        (if (= load_number "double")
            (begin_random
                (begin
                    (vehicle_unload phantom 50)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload phantom 51)
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

(script static boolean obj_sbonus_0_2
    b_sur_bonus_round_running
)

(script static boolean obj_shero__0_6
    (<= (ai_task_count "obj_survival/remaining") 3)
)

(script static boolean obj_smain__0_8
    (and (<= (ai_task_count "obj_survival/hero_follow") 0) (<= (ai_task_count "obj_survival/remaining") 3))
)

(script static boolean obj_sgener_0_9
    b_sur_generator_defense_active
)

(script static boolean obj_sgen0_0_10
    b_sur_generator0_alive
)

(script static boolean obj_sgen1_0_11
    b_sur_generator1_alive
)

(script static boolean obj_sgen2_0_12
    b_sur_generator2_alive
)

(script static boolean obj_sgen0__0_13
    (and (> (ai_task_count "obj_survival/gen0") 0) (>= (game_coop_player_count) 3))
)

(script static boolean obj_sgen1__0_14
    (and (> (ai_task_count "obj_survival/gen1") 0) (>= (game_coop_player_count) 3))
)

(script static boolean obj_sgen2__0_15
    (and (> (ai_task_count "obj_survival/gen2") 0) (>= (game_coop_player_count) 3))
)

(script static boolean obj_saddit_0_17
    (>= (game_coop_player_count) 4)
)

(script static boolean obj_mdefen_3_2
    (volume_test_objects "tv_north_deck" (ai_actors "gr_survival_waves"))
)

(script static boolean obj_mdefen_3_3
    (volume_test_objects "tv_west_deck" (ai_actors "gr_survival_waves"))
)

(script static boolean obj_mdefen_3_4
    (volume_test_objects "tv_east_deck" (ai_actors "gr_survival_waves"))
)

(script static boolean obj_mdefen_3_5
    (volume_test_objects "tv_south_deck" (ai_actors "gr_survival_waves"))
)

(script static boolean obj_mplaye_3_15
    (> (game_coop_player_count) 1)
)

(script static boolean obj_mplaye_3_16
    (> (game_coop_player_count) 2)
)

(script static boolean obj_mplaye_3_17
    (> (game_coop_player_count) 3)
)

(script startup void cex_ff_halo
    (ai_allegiance human player)
    (ai_allegiance player human)
    (if (> (player_count) 0)
        (cinematic_snap_to_black)
    )
    (sleep 5)
    (switch_zone_set "set_firefight")
    (set ai_sur_fireteam_squad0 "sq_elite_fireteam_01")
    (set ai_sur_fireteam_squad1 "sq_elite_fireteam_02")
    (set ai_sur_fireteam_squad2 "sq_elite_fireteam_03")
    (set ai_sur_fireteam_squad3 "sq_elite_fireteam_04")
    (set ai_sur_fireteam_squad4 "sq_elite_fireteam_05")
    (set ai_sur_fireteam_squad5 "sq_elite_fireteam_06")
    (set ai_obj_survival "obj_survival")
    (set ai_sur_phantom_01 "sq_sur_phantom_01")
    (set ai_sur_phantom_02 "sq_sur_phantom_02")
    (set ai_sur_phantom_03 "sq_sur_phantom_03")
    (set ai_sur_phantom_04 "sq_sur_phantom_04")
    (set ai_sur_bonus_phantom "sq_ff_bonus")
    (set s_sur_dropship_type 2)
    (set s_sur_drop_side_01 "dual")
    (set s_sur_drop_side_02 "dual")
    (set s_sur_drop_side_03 "dual")
    (set s_sur_drop_side_04 "dual")
    (set s_sur_drop_side_bonus "dual")
    (set k_sur_wave_timer 0)
    (set ai_sur_wave_spawns "gr_survival_waves")
    (set s_sur_wave_squad_count 6)
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
    (set ai_sur_bonus_wave "sq_ff_bonus")
    (set ai_sur_bonus_phantom "sq_sur_bonus_phantom")
    (if (survival_mode_scenario_extras_enable)
        (begin
            (wake survival_drop_spawn)
        )
    )
    (wake survival_banshee_spawn)
    (wake survival_mode)
    (wake survival_resupply_pod_spawn)
    (if (survival_mode_scenario_extras_enable)
        (begin
            (ai_place "sq_marines_01")
            (ai_place "sq_marines_02")
            (ai_place "sq_gs343")
        )
    )
    (ai_vehicle_reserve_seat "warthog01" 52 true)
    (sleep 5)
)

(script static void halo_kill
    (ai_erase_all)
    (kill_active_scripts)
)

(script static void survival_refresh_follow
    (survival_refresh_sleep)
    (ai_reset_objective "obj_survival/main_follow")
)

(script static void survival_refresh_additional_follow
    (survival_refresh_sleep)
    (ai_reset_objective "obj_survival/additional_follow")
)

(script static void survival_refresh_generator
    (survival_refresh_sleep)
    (ai_reset_objective "obj_survival/generator")
)

(script static void survival_hero_refresh_follow
    (survival_refresh_sleep)
    (survival_refresh_sleep)
    (ai_reset_objective "obj_survival/hero_follow")
)

(script static void (survival_set_hold_task (ai squad))
    (ai_set_task squad "obj_survival" "hold_task")
)

(script command_script void cs_gen0
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_go_to "ps_gen/gen0")
)

(script command_script void cs_gen1
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_go_to "ps_gen/gen1")
)

(script command_script void cs_gen2
    (cs_enable_pathfinding_failsafe true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_go_to "ps_gen/gen2")
)

(script static void refresh_gate_marines
    (sleep 5)
    (ai_reset_objective "obj_marines/gate_marines")
)

(script static void refresh_gate_marines_followers
    (sleep 5)
    (ai_reset_objective "obj_marines/gate_marines_followers")
)

(script static void refresh_gate_marines_defenders
    (sleep 5)
    (ai_reset_objective "obj_marines/gate_marines_defenders")
)

(script static void refresh_gate_marines_north_overlook
    (sleep 5)
    (ai_reset_objective "obj_marines/gate_north_overlook")
)

(script static void refresh_gate_marines_south_overlook
    (sleep 5)
    (ai_reset_objective "obj_marines/gate_south_overlook")
)

(script static vehicle players_vehicle
    (if (player_in_vehicle "warthog01")
        (vehicle "warthog01")
    )
    none
)

(script static boolean players_vehicle_has_player
    (not (= (players_vehicle) none))
)

(script command_script void cs_sur_phantom_01
    (set v_sur_phantom_01 (ai_vehicle_get_from_starting_location "sq_sur_phantom_01/phantom"))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_fly_by "ps_sur_phantom_01/run_01")
    (cs_fly_by "ps_sur_phantom_01/run_02")
    (cs_fly_by "ps_sur_phantom_01/run_02b")
    (cs_fly_by "ps_sur_phantom_01/run_02c")
    (cs_fly_by "ps_sur_phantom_01/run_03")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_01/run_04" "ps_sur_phantom_01/face_01" 1)
    (wake phantom_01_blip)
    (f_unload_fork_cargo v_sur_phantom_01 "large")
    (unit_open v_sur_phantom_01)
    (sleep 30)
    (f_unload_fork_all v_sur_phantom_01)
    (sleep 120)
    (unit_close v_sur_phantom_01)
    (sleep 15)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_01/run_03" "ps_sur_phantom_01/face_02" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_sur_phantom_01/run_02c")
    (cs_fly_by "ps_sur_phantom_01/run_02b")
    (cs_fly_by "ps_sur_phantom_01/run_02")
    (cs_fly_by "ps_sur_phantom_01/run_01")
    (cs_fly_by "ps_sur_phantom_01/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_01_blip
    (sleep_forever)
    (print "blipping phantom_01...")
    (f_survival_callout_dropship v_sur_phantom_01)
)

(script command_script void cs_sur_phantom_02
    (set v_sur_phantom_02 (ai_vehicle_get_from_starting_location "sq_sur_phantom_02/phantom"))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_fly_by "ps_sur_phantom_02/run_02")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_02/run_03" "ps_sur_phantom_02/face_01" 1)
    (wake phantom_02_blip)
    (f_unload_fork_cargo v_sur_phantom_02 "large")
    (unit_open v_sur_phantom_02)
    (sleep 30)
    (f_unload_fork_all v_sur_phantom_02)
    (sleep 120)
    (unit_close v_sur_phantom_02)
    (sleep 15)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_02/run_02" "ps_sur_phantom_02/face_02" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_sur_phantom_02/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_02_blip
    (sleep_forever)
    (print "blipping phantom_02...")
    (f_survival_callout_dropship v_sur_phantom_02)
)

(script command_script void cs_sur_phantom_03
    (set v_sur_phantom_03 (ai_vehicle_get_from_starting_location "sq_sur_phantom_03/phantom"))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_fly_by "ps_sur_phantom_03/run_03")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_03/run_04" "ps_sur_phantom_03/face_01" 1)
    (wake phantom_03_blip)
    (f_unload_fork_cargo v_sur_phantom_03 "large")
    (unit_open v_sur_phantom_03)
    (sleep 30)
    (f_unload_fork_all v_sur_phantom_03)
    (sleep 120)
    (unit_close v_sur_phantom_03)
    (sleep 15)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_03/run_03" "ps_sur_phantom_03/face_02" 1)
    (cs_fly_by "ps_sur_phantom_03/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_03_blip
    (sleep_forever)
    (print "blipping phantom_03...")
    (f_survival_callout_dropship v_sur_phantom_03)
)

(script command_script void cs_sur_phantom_04
    (set v_sur_phantom_04 (ai_vehicle_get_from_starting_location "sq_sur_phantom_04/phantom"))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.75)
    (cs_fly_by "ps_sur_phantom_04/run_01")
    (cs_fly_by "ps_sur_phantom_04/run_01b")
    (cs_fly_by "ps_sur_phantom_04/run_01c")
    (cs_fly_by "ps_sur_phantom_04/run_01d")
    (cs_vehicle_speed 0.5)
    (cs_fly_by "ps_sur_phantom_04/run_02")
    (cs_fly_to_and_face "ps_sur_phantom_04/run_03" "ps_sur_phantom_04/face_01" 1)
    (wake phantom_04_blip)
    (f_unload_fork_cargo v_sur_phantom_04 "large")
    (unit_open v_sur_phantom_04)
    (sleep 30)
    (f_unload_fork_all v_sur_phantom_04)
    (sleep 120)
    (unit_close v_sur_phantom_04)
    (sleep 15)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_phantom_04/run_02" "ps_sur_phantom_04/face_02" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "ps_sur_phantom_04/run_01d")
    (cs_fly_by "ps_sur_phantom_04/run_01c")
    (cs_fly_by "ps_sur_phantom_04/run_01b")
    (cs_fly_by "ps_sur_phantom_04/run_01")
    (cs_fly_by "ps_sur_phantom_04/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_04_blip
    (sleep_forever)
    (print "blipping phantom_04...")
    (f_survival_callout_dropship v_sur_phantom_04)
)

(script command_script void cs_sur_bonus_phantom
    (set v_sur_bonus_phantom (ai_vehicle_get_from_spawn_point "sq_sur_bonus_phantom/phantom"))
    (sleep 1)
    (object_cannot_die v_sur_bonus_phantom true)
    (object_set_shadowless v_sur_bonus_phantom true)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_fly_by "ps_sur_bonus_phantom/run_02")
    (cs_fly_by "ps_sur_bonus_phantom/run_03")
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_bonus_phantom/run_04" "ps_sur_bonus_phantom/face_01" 1)
    (sleep 15)
    (wake phantom_bonus_blip)
    (set b_sur_bonus_phantom_ready true)
    (sleep_until b_sur_bonus_end)
    (sleep 45)
    (sleep 15)
    (cs_vehicle_speed 0.5)
    (cs_fly_to_and_face "ps_sur_bonus_phantom/run_03" "ps_sur_bonus_phantom/face_02" 1)
    (cs_fly_by "ps_sur_bonus_phantom/run_02")
    (cs_fly_by "ps_sur_bonus_phantom/erase" 10)
    (ai_erase ai_current_squad)
)

(script continuous void phantom_bonus_blip
    (sleep_forever)
    (print "blipping bonus phantom...")
    (f_survival_callout_dropship v_sur_bonus_phantom)
)

(script dormant void survival_banshee_spawn
    (wake banshee_emp_kill)
    (sleep_until 
        (begin
            (sleep (random_range (* (* 30 60) 2) (* (* 30 60) 3)))
            (if (< (ai_living_count "gr_survival_banshee") 1)
                (begin
                    (sleep_until (and (= b_phantom_01 true) (= b_phantom_02 true) (= b_phantom_03 true) (= b_phantom_04 true) (<= (ai_task_count "obj_survival/main_wave_gate") 10)) 5)
                    (begin
                        (set b_banshee_flying true)
                        (sleep 1)
                        (begin_random_count
                            1
                            (ai_place "sq_sur_banshee_01")
                            (ai_place "sq_sur_banshee_02")
                            (print "spawning banshees")
                        )
                    )
                )
            )
            false
        )
    )
)

(script dormant void banshee_emp_kill
    (sleep_until 
        (begin
            (if (unit_is_emp_stunned (ai_vehicle_get_from_starting_location "sq_sur_banshee_01/driver"))
                (begin
                    (units_set_current_vitality (ai_actors "sq_sur_banshee_01") 0.1 0)
                    (units_set_maximum_vitality (ai_actors "sq_sur_banshee_01") 0.1 0)
                )
            )
            (if (unit_is_emp_stunned (ai_vehicle_get_from_starting_location "sq_sur_banshee_02/driver"))
                (begin
                    (units_set_current_vitality (ai_actors "sq_sur_banshee_02") 0.1 0)
                    (units_set_maximum_vitality (ai_actors "sq_sur_banshee_02") 0.1 0)
                )
            )
            false
        )
        1
    )
)

(script command_script void cs_banshee_01
    (if (= b_banshee_flying true)
        (begin
            (cs_enable_targeting true)
            (cs_enable_looking true)
            (cs_vehicle_boost true)
            (cs_fly_by "ps_banshee_01/run_01")
            (cs_fly_by "ps_banshee_01/run_02")
            (cs_fly_by "ps_banshee_01/run_03")
            (cs_fly_by "ps_banshee_01/run_04")
            (cs_fly_by "ps_banshee_01/run_05")
            (cs_vehicle_boost false)
            (cs_vehicle_speed 1)
            (set b_banshee_flying false)
            (print "banshee is free")
        )
        (sleep 1)
    )
)

(script command_script void cs_banshee_02
    (if (= b_banshee_flying true)
        (begin
            (cs_enable_targeting true)
            (cs_enable_looking true)
            (cs_ignore_obstacles true)
            (cs_vehicle_boost true)
            (cs_fly_by "ps_banshee_02/run_01")
            (cs_fly_by "ps_banshee_02/run_02")
            (cs_fly_by "ps_banshee_02/run_03")
            (cs_fly_by "ps_banshee_02/run_04")
            (cs_ignore_obstacles false)
            (cs_vehicle_boost false)
            (cs_vehicle_speed 1)
            (set b_banshee_flying false)
            (print "banshee is free")
        )
        (sleep 1)
    )
)

(script command_script void cs_gs343_01
    (sleep_until 
        (begin
            (cs_pause 30)
            (cs_fly_to "ps_guilty_spark_343/run_01")
            (cs_fly_to "ps_guilty_spark_343/run_02")
            (cs_fly_to "ps_guilty_spark_343/run_03")
            (cs_pause 3)
            (cs_face true "ps_guilty_spark_343/face_01")
            (cs_pause 3)
            (cs_face true "ps_guilty_spark_343/face_02")
            (cs_pause 3)
            (cs_face true "ps_guilty_spark_343/face_03")
            (cs_pause 10)
            (cs_face true "ps_guilty_spark_343/face_04")
            (cs_fly_by "ps_guilty_spark_343/run_03")
            (cs_fly_by "ps_guilty_spark_343/run_02")
            (cs_fly_by "ps_guilty_spark_343/run_01")
            false
        )
    )
)

(script dormant void survival_drop_spawn
    (if (<= (game_coop_player_count) 4)
        (set g_sur_drop_limit 1)
        (if (>= (game_coop_player_count) 5)
            (set g_sur_drop_limit 2)
        )
    )
    (sleep (* (* 30 60) 2))
    (sleep_until 
        (begin
            (sleep (random_range (* (* 30 60) 2) (* (* 30 60) 3)))
            (sleep_until (and (<= (ai_living_count "gr_survival_waves") 10) (<= (ai_living_count "gr_survival_extras") 0) (= (survival_mode_current_wave_is_boss) false) (= (survival_mode_current_wave_is_initial) false)))
            (print "cleaning up drop pods...")
            (sleep 30)
            (ai_erase "sq_sur_drop_01")
            (ai_erase "sq_sur_drop_02")
            (ai_erase "sq_sur_drop_03")
            (ai_erase "sq_sur_drop_04")
            (begin_random_count
                g_sur_drop_limit
                (if g_sur_drop_spawn
                    (wake drop_pod_01)
                )
                (if g_sur_drop_spawn
                    (wake drop_pod_02)
                )
                (if g_sur_drop_spawn
                    (wake drop_pod_03)
                )
                (if g_sur_drop_spawn
                    (wake drop_pod_04)
                )
            )
            (sleep 1)
            (sleep_until (and (<= (ai_task_count "obj_survival/extras_follow") 0) (<= (ai_task_count "obj_survival/extras_backup") 0)))
            (sleep 1)
            (set g_sur_drop_count 0)
            (set g_sur_drop_spawn true)
            (sleep 1)
            false
        )
    )
)

(script continuous void drop_pod_01
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "squad pod 01...")
    (object_create "dm_drop_01")
    (ai_place "sq_sur_drop_01")
    (sleep 1)
    (set v_sur_drop_01 (ai_vehicle_get_from_spawn_point "sq_sur_drop_01/driver"))
    (sleep 1)
    (objects_attach "dm_drop_01" "" v_sur_drop_01 "")
    (sleep 1)
    (device_set_position "dm_drop_01" 1)
    (sleep_until (>= (device_get_position "dm_drop_01") 0.85) 1)
    (wake drop_blip_01)
    (unit_open v_sur_drop_01)
    (sleep 30)
    (print "kicking ai out of pod 01...")
    (vehicle_unload v_sur_drop_01 none)
    (sleep_until (>= (device_get_position "dm_drop_01") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_large.effect" "dm_drop_01" "fx_impact")
    (sleep_until (>= (device_get_position "dm_drop_01") 1) 1)
    (sleep 1)
    (objects_detach "dm_drop_01" v_sur_drop_01)
    (object_destroy "dm_drop_01")
    (sleep 1)
    (set g_sur_drop_count (+ g_sur_drop_count 1))
    (if (>= g_sur_drop_count g_sur_drop_limit)
        (set g_sur_drop_spawn false)
    )
)

(script continuous void drop_blip_01
    (sleep_forever)
    (print "blipping drop pod 01...")
    (f_survival_callout_dropship v_sur_drop_01)
)

(script continuous void drop_pod_02
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "squad pod 02...")
    (object_create "dm_drop_02")
    (ai_place "sq_sur_drop_02")
    (sleep 1)
    (set v_sur_drop_02 (ai_vehicle_get_from_spawn_point "sq_sur_drop_02/driver"))
    (sleep 1)
    (objects_attach "dm_drop_02" "" v_sur_drop_02 "")
    (sleep 1)
    (device_set_position "dm_drop_02" 1)
    (sleep_until (>= (device_get_position "dm_drop_02") 0.85) 1)
    (wake drop_blip_02)
    (unit_open v_sur_drop_02)
    (sleep 30)
    (print "kicking ai out of pod 02...")
    (vehicle_unload v_sur_drop_02 none)
    (sleep_until (>= (device_get_position "dm_drop_02") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_large.effect" "dm_drop_02" "fx_impact")
    (sleep_until (>= (device_get_position "dm_drop_02") 1) 1)
    (sleep 1)
    (objects_detach "dm_drop_02" v_sur_drop_02)
    (object_destroy "dm_drop_02")
    (sleep 1)
    (set g_sur_drop_count (+ g_sur_drop_count 1))
    (if (>= g_sur_drop_count g_sur_drop_limit)
        (set g_sur_drop_spawn false)
    )
)

(script continuous void drop_blip_02
    (sleep_forever)
    (print "blipping drop pod 02...")
    (f_survival_callout_dropship v_sur_drop_02)
)

(script continuous void drop_pod_03
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "squad pod 03...")
    (object_create "dm_drop_03")
    (ai_place "sq_sur_drop_03")
    (sleep 1)
    (set v_sur_drop_03 (ai_vehicle_get_from_spawn_point "sq_sur_drop_03/driver"))
    (sleep 1)
    (objects_attach "dm_drop_03" "" v_sur_drop_03 "")
    (sleep 1)
    (device_set_position "dm_drop_03" 1)
    (sleep_until (>= (device_get_position "dm_drop_03") 0.85) 1)
    (wake drop_blip_03)
    (unit_open v_sur_drop_03)
    (sleep 30)
    (print "kicking ai out of pod 03...")
    (vehicle_unload v_sur_drop_03 none)
    (sleep_until (>= (device_get_position "dm_drop_03") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_large.effect" "dm_drop_03" "fx_impact")
    (sleep_until (>= (device_get_position "dm_drop_03") 1) 1)
    (sleep 1)
    (objects_detach "dm_drop_03" v_sur_drop_03)
    (object_destroy "dm_drop_03")
    (sleep 1)
    (set g_sur_drop_count (+ g_sur_drop_count 1))
    (if (>= g_sur_drop_count g_sur_drop_limit)
        (set g_sur_drop_spawn false)
    )
)

(script continuous void drop_blip_03
    (sleep_forever)
    (print "blipping drop pod 03...")
    (f_survival_callout_dropship v_sur_drop_03)
)

(script continuous void drop_pod_04
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "squad pod 04...")
    (object_create "dm_drop_04")
    (ai_place "sq_sur_drop_04")
    (sleep 1)
    (set v_sur_drop_04 (ai_vehicle_get_from_spawn_point "sq_sur_drop_04/driver"))
    (sleep 1)
    (objects_attach "dm_drop_04" "" v_sur_drop_04 "")
    (sleep 1)
    (device_set_position "dm_drop_04" 1)
    (sleep_until (>= (device_get_position "dm_drop_04") 0.85) 1)
    (wake drop_blip_04)
    (unit_open v_sur_drop_04)
    (sleep 30)
    (print "kicking ai out of pod 04...")
    (vehicle_unload v_sur_drop_04 none)
    (sleep_until (>= (device_get_position "dm_drop_04") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_large.effect" "dm_drop_04" "fx_impact")
    (sleep_until (>= (device_get_position "dm_drop_04") 1) 1)
    (sleep 1)
    (objects_detach "dm_drop_04" v_sur_drop_04)
    (object_destroy "dm_drop_04")
    (sleep 1)
    (set g_sur_drop_count (+ g_sur_drop_count 1))
    (if (>= g_sur_drop_count g_sur_drop_limit)
        (set g_sur_drop_spawn false)
    )
)

(script continuous void drop_blip_04
    (sleep_forever)
    (print "blipping drop pod 04...")
    (f_survival_callout_dropship v_sur_drop_04)
)

(script static void ff_halo_respawn_warthog
    (if (= (vehicle_test_seat "warthog01" none) false)
        (begin
            (object_destroy "warthog01")
            (ai_place "sq_sur_pelican")
        )
    )
)

(script command_script void cs_ff_halo_pelican
    (set v_sur_pelican (ai_vehicle_get_from_starting_location "sq_sur_pelican/driver"))
    (sleep 1)
    (print "spawn pelican...")
    (object_cannot_die v_sur_pelican true)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (object_create_anew "warthog01")
    (ai_place "sq_marines_player_followers")
    (unit_enter_vehicle_immediate "sq_marines_player_followers" "warthog01" "warthog_g")
    (vehicle_load_magic (ai_vehicle_get ai_current_actor) 48 "warthog01")
    (print "pelican pathing...")
    (cs_vehicle_boost true)
    (cs_fly_by "ps_sur_pelican/run_01")
    (cs_fly_by "ps_sur_pelican/run_02")
    (cs_fly_by "ps_sur_pelican/run_03")
    (cs_vehicle_boost false)
    (cs_fly_to_and_face "ps_sur_pelican/run_04" "ps_sur_pelican/face_01" 1)
    (wake pelican_blip)
    (cs_vehicle_speed 1)
    (print "dropoff pelican...")
    (vehicle_unload (ai_vehicle_get ai_current_actor) 48)
    (ai_vehicle_reserve_seat "warthog01" 52 true)
    (sleep 100)
    (print "pelican leaves...")
    (sleep 15)
    (cs_vehicle_boost true)
    (cs_fly_by "ps_sur_pelican/run_05")
    (cs_vehicle_speed 3)
    (cs_fly_by "ps_sur_pelican/erase" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script continuous void pelican_blip
    (sleep_forever)
    (print "blipping pelican_01...")
    (f_survival_callout_dropship v_sur_pelican)
)

(script static boolean (resupply_pod_test_weapon (object pod))
    (or (!= (object_at_marker pod "gun_high") none) (!= (object_at_marker pod "gun_mid") none) (!= (object_at_marker pod "gun_lower") none))
)

(script dormant void survival_resupply_pod_spawn
    (if (<= (game_coop_player_count) 2)
        (set g_sur_resupply_limit 1)
        (if (= (game_coop_player_count) 3)
            (set g_sur_resupply_limit 1)
            (if (= (game_coop_player_count) 4)
                (set g_sur_resupply_limit 2)
                (if (>= (game_coop_player_count) 5)
                    (set g_sur_resupply_limit 2)
                )
            )
        )
    )
    (sleep 1)
    (sleep_until 
        (begin
            (sleep_until (survival_mode_should_drop_weapon) 5)
            (sleep 1)
            (print "cleaning up old resupply pods...")
            (sleep 1)
            (object_destroy "sc_resupply_01")
            (object_destroy "sc_resupply_02")
            (object_destroy "sc_resupply_03")
            (object_destroy "sc_resupply_04")
            (object_destroy "sc_resupply_05")
            (object_destroy "sc_target_01")
            (object_destroy "sc_target_02")
            (object_destroy "sc_target_03")
            (sleep 1)
            (print "bringing in longsword...")
            (object_create "dm_longsword_01")
            (print "spawning in grenades...")
            (object_create_folder_anew "cr_grenades")
            (sleep 1)
            (device_set_position_track "dm_longsword_01" "ff10" 0)
            (device_animate_position "dm_longsword_01" 1 10 3 3 false)
            (sleep_until (>= (device_get_position "dm_longsword_01") 0.4) 1)
            (print "dropping off weapons...")
            (begin_random_count
                1
                (wake resupply_target_01)
                (wake resupply_target_02)
                (wake resupply_target_03)
            )
            (begin_random_count
                g_sur_resupply_limit
                (wake resupply_pod_01)
                (wake resupply_pod_02)
                (wake resupply_pod_03)
                (wake resupply_pod_04)
                (wake resupply_pod_05)
            )
            (if (> (survival_mode_wave_get) 0)
                (ff_halo_respawn_warthog)
            )
            (sleep 120)
            (object_destroy "dm_longsword_01")
            false
        )
    )
)

(script continuous void resupply_target_01
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "target 01...")
    (object_create "dm_target_01")
    (begin
        (if (= (airstrike_weapons_exist) false)
            (begin
                (airstrike_set_launches 2)
                (sleep 1)
                (object_create_variant "sc_target_01" "target_laser")
            )
            (begin
                (airstrike_set_launches 2)
                (submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
                (sleep 1)
                (begin_random_count
                    1
                    (object_create_variant "sc_target_01" "laser")
                    (object_create_variant "sc_target_01" "rocket")
                    (object_create_variant "sc_target_01" "sniper")
                )
            )
        )
    )
    (sleep 1)
    (objects_attach "dm_target_01" "" "sc_target_01" "")
    (sleep 1)
    (device_set_position "dm_target_01" 1)
    (sleep_until (>= (device_get_position "dm_target_01") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_target_01" "fx_impact")
    (sleep_until (>= (device_get_position "dm_target_01") 1) 1)
    (sleep 1)
    (objects_detach "dm_target_01" "sc_target_01")
    (object_destroy "dm_target_01")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_target_01" "panel" 100)
    (wake target_waypoint_01)
)

(script continuous void target_waypoint_01
    (sleep_forever)
    (print "placing waypoint on target 01...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_target_01" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_target_01")) 5)
    (f_unblip_object "sc_target_01")
)

(script continuous void resupply_target_02
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "target 02...")
    (object_create "dm_target_02")
    (begin
        (if (= (airstrike_weapons_exist) false)
            (begin
                (airstrike_set_launches 2)
                (sleep 1)
                (object_create_variant "sc_target_02" "target_laser")
            )
            (begin
                (airstrike_set_launches 2)
                (submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
                (sleep 1)
                (begin_random_count
                    1
                    (object_create_variant "sc_target_02" "laser")
                    (object_create_variant "sc_target_02" "rocket")
                    (object_create_variant "sc_target_02" "sniper")
                )
            )
        )
    )
    (sleep 1)
    (objects_attach "dm_target_02" "" "sc_target_02" "")
    (sleep 1)
    (device_set_position "dm_target_02" 1)
    (sleep_until (>= (device_get_position "dm_target_02") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_target_02" "fx_impact")
    (sleep_until (>= (device_get_position "dm_target_02") 1) 1)
    (sleep 1)
    (objects_detach "dm_target_02" "sc_target_02")
    (object_destroy "dm_target_02")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_target_02" "panel" 100)
    (wake target_waypoint_02)
)

(script continuous void target_waypoint_02
    (sleep_forever)
    (print "placing waypoint on target 02...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_target_02" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_target_02")) 5)
    (f_unblip_object "sc_target_02")
)

(script continuous void resupply_target_03
    (sleep_forever)
    (sleep (random_range 5 15))
    (print "target 03...")
    (object_create "dm_target_03")
    (begin
        (if (= (airstrike_weapons_exist) false)
            (begin
                (airstrike_set_launches 2)
                (sleep 1)
                (object_create_variant "sc_target_03" "target_laser")
            )
            (begin
                (airstrike_set_launches 2)
                (submit_incident_with_cause_campaign_team "sur_airstrike_refill" player)
                (sleep 1)
                (begin_random_count
                    1
                    (object_create_variant "sc_target_03" "laser")
                    (object_create_variant "sc_target_03" "rocket")
                    (object_create_variant "sc_target_03" "sniper")
                )
            )
        )
    )
    (sleep 1)
    (objects_attach "dm_target_03" "" "sc_target_03" "")
    (sleep 1)
    (device_set_position "dm_target_03" 1)
    (sleep_until (>= (device_get_position "dm_target_03") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_target_03" "fx_impact")
    (sleep_until (>= (device_get_position "dm_target_03") 1) 1)
    (sleep 1)
    (objects_detach "dm_target_03" "sc_target_03")
    (object_destroy "dm_target_03")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_target_03" "panel" 100)
    (wake target_waypoint_03)
)

(script continuous void target_waypoint_03
    (sleep_forever)
    (print "placing waypoint on target 03...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_target_03" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_target_03")) 5)
    (f_unblip_object "sc_target_03")
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
    (sleep_until (>= (device_get_position "dm_resupply_01") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_resupply_01" "fx_impact")
    (sleep_until (>= (device_get_position "dm_resupply_01") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_01" "sc_resupply_01")
    (object_destroy "dm_resupply_01")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_01" "panel" 100)
    (wake resupply_waypoint_01)
)

(script continuous void resupply_waypoint_01
    (sleep_forever)
    (print "placing waypoint on resupply 01...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_resupply_01" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_resupply_01")) 5)
    (f_unblip_object "sc_resupply_01")
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
    (sleep_until (>= (device_get_position "dm_resupply_02") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_resupply_02" "fx_impact")
    (sleep_until (>= (device_get_position "dm_resupply_02") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_02" "sc_resupply_02")
    (object_destroy "dm_resupply_02")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_02" "panel" 100)
    (wake resupply_waypoint_02)
)

(script continuous void resupply_waypoint_02
    (sleep_forever)
    (print "placing waypoint on resupply 02...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_resupply_02" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_resupply_02")) 5)
    (f_unblip_object "sc_resupply_02")
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
    (sleep_until (>= (device_get_position "dm_resupply_03") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_resupply_03" "fx_impact")
    (sleep_until (>= (device_get_position "dm_resupply_03") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_03" "sc_resupply_03")
    (object_destroy "dm_resupply_03")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_03" "panel" 100)
    (wake resupply_waypoint_03)
)

(script continuous void resupply_waypoint_03
    (sleep_forever)
    (print "placing waypoint on resupply 03...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_resupply_03" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_resupply_03")) 5)
    (f_unblip_object "sc_resupply_03")
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
    (sleep_until (>= (device_get_position "dm_resupply_04") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_resupply_04" "fx_impact")
    (sleep_until (>= (device_get_position "dm_resupply_04") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_04" "sc_resupply_04")
    (object_destroy "dm_resupply_04")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_04" "panel" 100)
    (wake resupply_waypoint_04)
)

(script continuous void resupply_waypoint_04
    (sleep_forever)
    (print "placing waypoint on resupply 04...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_resupply_04" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_resupply_04")) 5)
    (f_unblip_object "sc_resupply_04")
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
    (sleep_until (>= (device_get_position "dm_resupply_05") 0.98) 1)
    (effect_new_on_object_marker "fx\fx_library\pod_impacts\default\pod_impact_default_small.effect" "sc_resupply_05" "fx_impact")
    (sleep_until (>= (device_get_position "dm_resupply_05") 1) 1)
    (sleep 1)
    (objects_detach "dm_resupply_05" "sc_resupply_05")
    (object_destroy "dm_resupply_05")
    (sleep (random_range 8 17))
    (object_damage_damage_section "sc_resupply_05" "panel" 100)
    (wake resupply_waypoint_05)
)

(script continuous void resupply_waypoint_05
    (sleep_forever)
    (print "placing waypoint on resupply 05...")
    (sound_impulse_start sfx_blip none 1)
    (f_blip_object "sc_resupply_05" blip_ordnance)
    (sleep_until (not (resupply_pod_test_weapon "sc_resupply_05")) 5)
    (f_unblip_object "sc_resupply_05")
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

(script static void marines
    (ai_set_combat_status (performance_get_actor "grunt1") 0)
    (performance_play_line "start_sleeping")
    (performance_play_line "block")
    (performance_play_line "sleep_until")
    (sleep_until (> (ai_combat_status (performance_get_actor "grunt1")) 5))
)

; Decompilation finished in ~0.0860826s
