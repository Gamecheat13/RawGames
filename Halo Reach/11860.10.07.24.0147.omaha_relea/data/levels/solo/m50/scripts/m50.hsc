; Decompiled with Assembly
; 
; Source file: m50.hsc
; Start time: 2018-02-05 12:54:24 PM
; 
; Remember that all script code is property of Bungie/343 Industries.
; You have no rights. Play nice.

; Globals
(global boolean b_debug_fork true)
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
(global boolean debug false)
(global boolean debug_objectives true)
(global boolean editor false)
(global boolean cinematics false)
(global boolean dialogue true)
(global boolean skip_intro false)
(global boolean corvette_fx false)
(global short s_active_insertion_index 0)
(global short objcon_panoptical 65535)
(global short objcon_towers 65535)
(global short objcon_interior 65535)
(global short objcon_canyonview 65535)
(global short objcon_atrium 65535)
(global short objcon_ready 65535)
(global short objcon_jetpack_low 65535)
(global short objcon_jetpack_high 65535)
(global short objcon_trophy 65535)
(global short objcon_ride 65535)
(global short objcon_starport 65535)
(global short g_waypoint_timeout (* 30 90))
(global short s_recycle_interval 120)
(global boolean b_towers_started false)
(global boolean b_interior_started false)
(global boolean b_kamikaze false)
(global boolean b_canyonview_started false)
(global boolean b_cv_counter_started false)
(global boolean b_cv_chieftain_delivered false)
(global boolean b_cv_complete false)
(global boolean b_cv_cinematic_complete false)
(global boolean b_brute_fork_load false)
(global boolean b_brute_taunt false)
(global boolean b_canyonview_timeout false)
(global boolean b_atrium_started false)
(global boolean b_atrium_counterattack_started false)
(global boolean b_atrium_complete false)
(global boolean b_atrium_timeout false)
(global boolean b_md_defend_complete false)
(global short g_atrium_civ_current 65535)
(global short g_atrium_civ_desired 6)
(global short g_atrium_unsc_current 65535)
(global short g_atrium_unsc_desired 4)
(global boolean b_ready_started false)
(global boolean b_ready_complete false)
(global boolean b_ready_player_has_jetpack false)
(global boolean b_jetpack_low_started false)
(global boolean b_jetpack_low_complete false)
(global boolean b_jetpack_low_assault_start false)
(global boolean b_jetpack_complete false)
(global short g_ready_odst_current 65535)
(global short g_ready_odst_desired 4)
(global boolean b_jetpack_high_started false)
(global boolean b_jetpack_high_complete false)
(global short g_jh_civ_current 65535)
(global short g_jh_civ_desired 6)
(global short g_jh_odst_current 65535)
(global short g_jh_odst_desired 2)
(global boolean b_place_jh_hill false)
(global boolean b_jh_phantom0_exit false)
(global boolean b_jh_timeout false)
(global boolean b_trophy_started false)
(global boolean b_trophy_counterattack false)
(global boolean b_trophy_complete false)
(global short g_trophy_civ_current 65535)
(global short g_trophy_civ_desired 8)
(global short g_trophy_odst_current 65535)
(global short g_trophy_odst_desired 2)
(global boolean b_ride_started false)
(global boolean b_ride_complete false)
(global boolean b_ride_falcon_landed false)
(global boolean b_ride_falcon0_landed false)
(global boolean b_ride_player_in_falcon false)
(global boolean b_ride_sync false)
(global boolean b_falcon_sync false)
(global boolean b_falcon0_sync false)
(global vehicle v_ride_falcon none)
(global vehicle v_ride_falcon0 none)
(global boolean b_falcon_evac_hover false)
(global boolean b_falcon0_evac_hover false)
(global boolean b_falcon_goto_load_hover false)
(global boolean b_falcon0_goto_load_hover false)
(global boolean b_falcon_load_hover false)
(global boolean b_falcon0_load_hover false)
(global boolean b_falcon_goto_lz_hover false)
(global boolean b_falcon0_goto_lz_hover false)
(global boolean b_falcon_lz_setup false)
(global boolean b_falcon0_lz_setup false)
(global boolean b_falcon_lz_hover false)
(global boolean b_falcon0_lz_hover false)
(global boolean b_starport_intro false)
(global boolean b_falcon_transport false)
(global boolean b_falcon0_transport false)
(global boolean b_falcon_park false)
(global boolean b_falcon0_park false)
(global boolean b_banshee0_start false)
(global boolean b_rooftop0_start false)
(global boolean b_rooftop1_start false)
(global boolean b_rooftop2_start false)
(global boolean b_rooftop0_finish false)
(global boolean b_rooftop1_finish false)
(global boolean b_rooftop2_finish false)
(global boolean b_falcon_unloaded false)
(global boolean b_falcon0_unloaded false)
(global short g_falcon_vitality 100)
(global boolean b_evac1_landed false)
(global short evac_delay (* 30 10))
(global boolean b_evac1_complete false)
(global boolean b_banshee_attack false)
(global boolean b_starport_started false)
(global boolean b_starport_turret1_ready false)
(global boolean b_starport_turret0_ready false)
(global boolean b_starport_defenses_fired false)
(global boolean b_starport_music_start false)
(global boolean b_starport_music_alt false)
(global boolean b_starport_music_stop false)
(global boolean b_starport_monologue false)
(global vehicle v_starport_falcon0 none)
(global vehicle v_starport_falcon1 none)
(global boolean b_players_all_on_foot false)
(global boolean b_players_any_in_vehicle false)
(global short g_starport_unsc_current 65535)
(global short g_starport_unsc_desired 8)
(global short g_starport_cov_current 65535)
(global short g_starport_cov_desired 12)
(global boolean g_skimishers_loaded false)
(global boolean editor_object_management false)
(global looping_sound snd_city_ambient "sound\levels\040_voi\old_mombasa_quiet\old_mombasa_quiet")
(global looping_sound snd_floodship_creaks "sound\levels\050_floodvoi\sound_scenery\crashed_floodship_hole\crashed_floodship_hole")
(global sound snd_vehicle_destroyed "sound\visual_fx\ambient_vehicle_destroyed")
(global sound snd_vehicle_destroyed_lrg "sound\visual_fx\ambient_vehicle_destroyed_large")
(global sound snd_creak "sound\levels\120_halo\trench_run\island_creak")
(global sound snd_elite_fleet "sound\levels\050_floodvoi\050pb_elite_fleet")
(global sound snd_longsword_leadin "sound\levels\070_waste\070_longsword_crash\longsword_lead_in")
(global sound snd_longsword_crash "sound\levels\070_waste\070_longsword_crash\070_longsword")
(global sound snd_longsword_flyby "sound\device_machines\040vc_longsword\start")
(global sound snd_cap_ship_flyover "sound\levels\030_outskirts\sound_scenery\cap_ship_flyover")
(global sound snd_pelican1_start "sound\levels\010_jungle\010vd_pelican_crash\pelican1_crash")
(global sound snd_pelican1_crash "sound\levels\010_jungle\010vd_pelican_crash\pelican1_crash")
(global sound snd_pelican2_start "sound\levels\010_jungle\010vd_pelican_crash\pelican2_start")
(global sound snd_pelican2_crash "sound\levels\010_jungle\010vd_pelican_crash\pelican2_crash")
(global sound snd_tower_fall "sound\levels\120_halo\trench_run\tower_fall")
(global looping_sound mus_01 "levels\solo\m50\music\m50_music_01.sound_looping")
(global looping_sound mus_02 "levels\solo\m50\music\m50_music_02.sound_looping")
(global looping_sound mus_03 "levels\solo\m50\music\m50_music_03.sound_looping")
(global looping_sound mus_04 "levels\solo\m50\music\m50_music_04.sound_looping")
(global looping_sound mus_05 "levels\solo\m50\music\m50_music_05.sound_looping")
(global looping_sound mus_06 "levels\solo\m50\music\m50_music_06.sound_looping")
(global looping_sound mus_07 "levels\solo\m50\music\m50_music_07.sound_looping")
(global looping_sound mus_08 "levels\solo\m50\music\m50_music_08.sound_looping")
(global looping_sound mus_09 "levels\solo\m50\music\m50_music_09.sound_looping")
(global looping_sound mus_10 "levels\solo\m50\music\m50_music_10.sound_looping")
(global short objective_flash_time 15)
(global short objective_delay (* 30 2))
(global boolean b_md_is_playing false)
(global ai trooper_01 none)
(global ai trooper_02 none)
(global ai trooper_03 none)
(global ai trooper_04 none)
(global ai civilian_01 none)
(global ai civilian_02 none)
(global ai civilian_03 none)
(global ai civilian_04 none)
(global ai odst_01 none)
(global ai odst_02 none)
(global ai odst_03 none)
(global ai odst_04 none)
(global ai duval none)
(global ai air_control none)
(global ai trooper_sgt1 none)
(global ai trooper_sgt2 none)
(global ai trooper1 none)
(global ai trooper2 none)
(global ai trooper3 none)
(global ai trooper4 none)
(global ai trooper5 none)
(global ai trooper3_odst1 none)
(global ai trooper5_odst2 none)
(global ai female_trooper1 none)
(global ai civilian1 none)
(global ai f_civilian1 none)
(global ai atrium_a.i. none)
(global ai pilot1 none)
(global ai pilot2 none)
(global ai female_pilot none)
(global ai stalwart_dawn_actual none)
(global ai civilian_transport_pilot1 none)
(global ai civilian_transport_pilot2 none)
(global object g_location none)
(global short md_atruim_ai 0)
(global short md_atruim_ai_delay 500)
(global ai jp_flourish_ai none)
(global string jp_flourish_text "")
(global ai_line jp_flourish_line none)
(global boolean playmusic true)
(global short s_hud_flash_count 0)
(global point_reference l_point "pts_fx_pan_0/p1")
(global point_reference n_point "pts_fx_pan_0/p1")
(global point_reference o_point "pts_fx_pan_0/p5")
(global short s_min_longsword_flyby_delay 15)
(global short s_max_longsword_flyby_delay 45)
(global short s_current_bomb 0)
(global boolean b_kill_canyon_dropships false)
(global boolean transport_start false)
(global boolean transport_finish false)
(global short s_special_elite 0)
(global boolean b_special false)
(global boolean b_special_win false)
(global short s_special_elite_ticks 600)
(global short s_zoneset_all_index 6)
(global short g_encounter_variant 0)
(global short s_index_panoptical 1)
(global short s_index_towers 2)
(global short s_index_interior 3)
(global short s_index_canyonview 4)
(global short s_index_atrium 5)
(global short s_index_ready 6)
(global short s_index_jetpack_low 7)
(global short s_index_jetpack_high 8)
(global short s_index_trophy 9)
(global short s_index_ride 10)
(global short s_index_starport 11)

; Scripts
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
            (ai_vehicle_enter_immediate load_squad_01 fork 0)
            (ai_vehicle_enter_immediate load_squad_02 fork 0)
            (ai_vehicle_enter_immediate load_squad_03 fork 0)
            (ai_vehicle_enter_immediate load_squad_04 fork 0)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_fork
                    (print "load fork right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 fork 1)
                (ai_vehicle_enter_immediate load_squad_02 fork 1)
                (ai_vehicle_enter_immediate load_squad_03 fork 1)
                (ai_vehicle_enter_immediate load_squad_04 fork 1)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_fork
                        (print "load fork dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 fork 0)
                    (ai_vehicle_enter_immediate load_squad_02 fork 0)
                    (ai_vehicle_enter_immediate load_squad_03 fork 1)
                    (ai_vehicle_enter_immediate load_squad_04 fork 1)
                )
                (if (= load_side "any")
                    (begin
                        (if b_debug_fork
                            (print "load fork any...")
                        )
                        (ai_vehicle_enter_immediate load_squad_01 fork 2)
                        (ai_vehicle_enter_immediate load_squad_02 fork 2)
                        (ai_vehicle_enter_immediate load_squad_03 fork 2)
                        (ai_vehicle_enter_immediate load_squad_04 fork 2)
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
            (vehicle_load_magic fork 3 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_type "small")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (ai_place load_squad_03)
                (sleep 1)
                (vehicle_load_magic fork 4 (ai_vehicle_get_from_squad load_squad_01 0))
                (vehicle_load_magic fork 5 (ai_vehicle_get_from_squad load_squad_02 0))
                (vehicle_load_magic fork 6 (ai_vehicle_get_from_squad load_squad_03 0))
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
            (vehicle_unload fork 7)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 8)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 9)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 10)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 11)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 12)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 13)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 14)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_right (vehicle fork))
    (begin_random
        (begin
            (vehicle_unload fork 15)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 16)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 17)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 18)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 19)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 20)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 21)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 22)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_all (vehicle fork))
    (begin_random
        (begin
            (vehicle_unload fork 7)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 8)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 9)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 10)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 11)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 12)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 13)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 14)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 15)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 16)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 17)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 18)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 19)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 20)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 21)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload fork 22)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_fork_cargo (vehicle fork, string load_type))
    (if (= load_type "large")
        (vehicle_unload fork 3)
        (if (= load_type "small")
            (begin_random
                (begin
                    (vehicle_unload fork 4)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload fork 5)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload fork 6)
                    (sleep (random_range 15 30))
                )
            )
            (if (= load_type "small01")
                (vehicle_unload fork 4)
                (if (= load_type "small02")
                    (vehicle_unload fork 5)
                    (if (= load_type "small03")
                        (vehicle_unload fork 6)
                    )
                )
            )
        )
    )
)

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
            (ai_vehicle_enter_immediate load_squad_01 phantom 23)
            (ai_vehicle_enter_immediate load_squad_02 phantom 24)
            (ai_vehicle_enter_immediate load_squad_03 phantom 25)
            (ai_vehicle_enter_immediate load_squad_04 phantom 26)
        )
        (if (= load_side "right")
            (begin
                (if b_debug_phantom
                    (print "load phantom right...")
                )
                (ai_vehicle_enter_immediate load_squad_01 phantom 27)
                (ai_vehicle_enter_immediate load_squad_02 phantom 28)
                (ai_vehicle_enter_immediate load_squad_03 phantom 29)
                (ai_vehicle_enter_immediate load_squad_04 phantom 30)
            )
            (if (= load_side "dual")
                (begin
                    (if b_debug_phantom
                        (print "load phantom dual...")
                    )
                    (ai_vehicle_enter_immediate load_squad_01 phantom 24)
                    (ai_vehicle_enter_immediate load_squad_02 phantom 28)
                    (ai_vehicle_enter_immediate load_squad_03 phantom 23)
                    (ai_vehicle_enter_immediate load_squad_04 phantom 27)
                )
                (if (= load_side "any")
                    (begin
                        (if b_debug_phantom
                            (print "load phantom any...")
                        )
                        (ai_vehicle_enter_immediate load_squad_01 phantom 31)
                        (ai_vehicle_enter_immediate load_squad_02 phantom 31)
                        (ai_vehicle_enter_immediate load_squad_03 phantom 31)
                        (ai_vehicle_enter_immediate load_squad_04 phantom 31)
                    )
                    (if (= load_side "chute")
                        (begin
                            (if b_debug_phantom
                                (print "load phantom chute...")
                            )
                            (ai_vehicle_enter_immediate load_squad_01 phantom 32)
                            (ai_vehicle_enter_immediate load_squad_02 phantom 33)
                            (ai_vehicle_enter_immediate load_squad_03 phantom 34)
                            (ai_vehicle_enter_immediate load_squad_04 phantom 35)
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
            (vehicle_load_magic phantom 36 (ai_vehicle_get_from_squad load_squad_01 0))
        )
        (if (= load_number "double")
            (begin
                (ai_place load_squad_01)
                (ai_place load_squad_02)
                (sleep 1)
                (vehicle_load_magic phantom 37 (ai_vehicle_get_from_squad load_squad_01 0))
                (vehicle_load_magic phantom 38 (ai_vehicle_get_from_squad load_squad_02 0))
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
            (vehicle_unload phantom 24)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 23)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 28)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 27)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_left (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 25)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 26)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_mid_right (vehicle phantom))
    (begin_random
        (begin
            (vehicle_unload phantom 29)
            (sleep (random_range 0 10))
        )
        (begin
            (vehicle_unload phantom 30)
            (sleep (random_range 0 10))
        )
    )
)

(script static void (f_unload_ph_chute (vehicle phantom))
    (object_set_phantom_power phantom true)
    (if (vehicle_test_seat phantom 32)
        (begin
            (vehicle_unload phantom 32)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 33)
        (begin
            (vehicle_unload phantom 33)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 34)
        (begin
            (vehicle_unload phantom 34)
            (sleep 120)
        )
    )
    (if (vehicle_test_seat phantom 35)
        (begin
            (vehicle_unload phantom 35)
            (sleep 120)
        )
    )
    (object_set_phantom_power phantom false)
)

(script static void (f_unload_phantom_cargo (vehicle phantom, string load_number))
    (if (= load_number "single")
        (vehicle_unload phantom 36)
        (if (= load_number "double")
            (begin_random
                (begin
                    (vehicle_unload phantom 37)
                    (sleep (random_range 15 30))
                )
                (begin
                    (vehicle_unload phantom 38)
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

(script startup void manassas
    (print_difficulty)
    (if debug
        (print "::: m50 - manassas :::")
    )
    (fade_out 0 0 0 0)
    (wake object_control)
    (wake recycle_control)
    (wake special_elite)
    (if (game_is_cooperative)
        (begin
            (unit_add_equipment player0 "profile_starting" true false)
            (unit_add_equipment player1 "profile_starting" true false)
            (unit_add_equipment player2 "profile_starting" true false)
            (unit_add_equipment player3 "profile_starting" true false)
            (player_set_profile "profile_starting")
        )
    )
    (ai_allegiance human player)
    (ai_allegiance player human)
    (soft_ceiling_enable "low_jetpack_blocker" false)
    (soft_ceiling_enable "rail_blocker_01" true)
    (soft_ceiling_enable "rail_blocker_02" false)
    (soft_ceiling_enable "rail_blocker_03" false)
    (soft_ceiling_enable "rail_blocker_04" true)
    (soft_ceiling_enable "rail_blocker_05" true)
    (soft_ceiling_enable "rail_blocker_06" false)
    (soft_ceiling_enable "rail_blocker_07" false)
    (soft_ceiling_enable "rail_blocker_08" true)
    (if (or (not (editor_mode)) cinematics)
        (start)
        (begin
            (if debug
                (print "editor mode. snapping fade in...")
            )
            (fade_in 0 0 0 0)
        )
    )
    (sleep_until (>= s_active_insertion_index s_index_panoptical) 1)
    (if (<= s_active_insertion_index s_index_panoptical)
        (wake panoptical_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_towers_start") (>= s_active_insertion_index s_index_towers)) 1)
    (if (<= s_active_insertion_index s_index_towers)
        (wake towers_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_interior_start") (>= s_active_insertion_index s_index_interior)) 1)
    (if (<= s_active_insertion_index s_index_interior)
        (wake interior_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_canyonview_start") (>= s_active_insertion_index s_index_canyonview)) 1)
    (if (<= s_active_insertion_index s_index_canyonview)
        (wake canyonview_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_atrium_start") (>= s_active_insertion_index s_index_atrium)) 1)
    (if (<= s_active_insertion_index s_index_atrium)
        (begin
            (sleep_until (= (current_zone_set_fully_active) 3))
            (wake atrium_objective_control)
        )
    )
    (sleep_until (or (volume_test_players "tv_ready_start") (>= s_active_insertion_index s_index_ready)) 1)
    (if (<= s_active_insertion_index s_index_ready)
        (wake ready_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_jetpack_low_start") (>= s_active_insertion_index s_index_jetpack_low)) 1)
    (if (<= s_active_insertion_index s_index_jetpack_low)
        (wake jetpack_low_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_jetpack_high_start") (>= s_active_insertion_index s_index_jetpack_high)) 1)
    (if (<= s_active_insertion_index s_index_jetpack_high)
        (wake jetpack_high_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_trophy_high_start") (volume_test_players "tv_objcon_jetpack_high_060") (>= s_active_insertion_index s_index_trophy)) 1)
    (if (<= s_active_insertion_index s_index_trophy)
        (wake trophy_objective_control)
    )
    (sleep_until (or (= b_jetpack_high_complete true) (>= s_active_insertion_index s_index_ride)) 1)
    (if (<= s_active_insertion_index s_index_ride)
        (wake ride_objective_control)
    )
    (sleep_until (or (volume_test_players "tv_starport_start01") (volume_test_players "tv_starport_start02") (>= s_active_insertion_index s_index_starport)) 1)
    (if (<= s_active_insertion_index s_index_starport)
        (wake starport_objective_control)
    )
)

(script static void start
    (if (= (game_insertion_point_get) 0)
        (ins_panoptical)
        (if (= (game_insertion_point_get) 1)
            (ins_ready)
            (if (= (game_insertion_point_get) 2)
                (ins_ride)
                (if (= (game_insertion_point_get) 3)
                    (ins_starport)
                    (if (= (game_insertion_point_get) 6)
                        (ins_ambient_fx_test_panoptical)
                        (if (= (game_insertion_point_get) 7)
                            (ins_ambient_fx_test_canyonview)
                            (if (= (game_insertion_point_get) 8)
                                (ins_ambient_fx_test_jetpack)
                                (if (= (game_insertion_point_get) 9)
                                    (ins_ambient_fx_test_starport)
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)

(script dormant void recycle_control
    (sleep_until 
        (begin
            (if debug
                (print "recycle interval hit...")
            )
            (if b_towers_started
                (begin
                    (if debug
                        (print "recycle volume activated for panoptical...")
                    )
                    (add_recycling_volume "tv_recycle_panoptical" 10 60)
                )
            )
            (if b_interior_started
                (begin
                    (if debug
                        (print "recycle volume activated for towers...")
                    )
                    (add_recycling_volume "tv_recycle_towers" 10 60)
                )
            )
            (if b_canyonview_started
                (begin
                    (if debug
                        (print "recycle volume activated for interior...")
                    )
                    (add_recycling_volume "tv_recycle_interior" 10 60)
                )
            )
            (if b_atrium_started
                (begin
                    (if debug
                        (print "recycle volume activated for canyonview...")
                    )
                    (add_recycling_volume "tv_recycle_canyonview" 10 60)
                )
            )
            (sleep (* s_recycle_interval 30))
            (or b_ready_started b_jetpack_low_started b_jetpack_high_started b_starport_started)
        )
    )
    (if debug
        (print "player has entered ready room. hardcore cleanup of all earlier encounters...")
    )
    (add_recycling_volume "tv_recycle_panoptical" 0 0)
    (add_recycling_volume "tv_recycle_towers" 0 0)
    (add_recycling_volume "tv_recycle_interior" 0 0)
    (add_recycling_volume "tv_recycle_canyonview" 0 0)
    (add_recycling_volume "tv_recycle_atrium" 0 0)
    (sleep_until 
        (begin
            (if debug
                (print "recycle interval hit...")
            )
            (if b_jetpack_low_started
                (begin
                    (if debug
                        (print "recycle volume activated for ready room...")
                    )
                    (add_recycling_volume "tv_recycle_ready" 10 60)
                )
            )
            (if b_jetpack_high_started
                (begin
                    (if debug
                        (print "recycle volume activated for jetpack low...")
                    )
                    (add_recycling_volume "tv_recycle_jetpack_low" 10 60)
                )
            )
            (if b_ride_started
                (begin
                    (if debug
                        (print "recycle volume activated for jetpack high...")
                    )
                    (add_recycling_volume "tv_recycle_jetpack_high" 10 60)
                )
            )
            (if b_starport_started
                (begin
                    (if debug
                        (print "recycle volume activated for ride...")
                    )
                    (add_recycling_volume "tv_recycle_ride" 10 60)
                )
            )
            (sleep (* s_recycle_interval 30))
            b_starport_started
        )
    )
    (if debug
        (print "player has begun starport. hardcore cleanup of all earlier encounters...")
    )
    (add_recycling_volume "tv_recycle_ready" 0 0)
    (add_recycling_volume "tv_recycle_jetpack_low" 0 0)
    (add_recycling_volume "tv_recycle_jetpack_high" 0 0)
    (add_recycling_volume "tv_recycle_ride" 0 0)
)

(script startup void fireteam_setup
    (sleep_until (> (player_count) 0))
    (if debug
        (print "setting up fireteams...")
    )
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad (player0) "fireteam_player0")
    )
)

(script dormant void panoptical_objective_control
    (if (or (not (editor_mode)) cinematics)
        (begin
            (if debug
                (print "starting with intro cinematic...")
            )
            (f_start_mission "050la_wake")
        )
    )
    (if debug
        (print "encounter start: panoptical")
    )
    (game_save)
    (wake f_corvette_exterior)
    (wake ct_title_act1)
    (wake f_panoptical_fx_ambient)
    (wake panoptical_longsword_cycle)
    (wake md_amb_traxus01)
    (wake md_amb_bombers)
    (wake panoptical_waypoint)
    (wake unperch_panoptical_raven)
    (flock_create "fl_shared_banshee0")
    (flock_create "fl_shared_falcon0")
    (flock_create "fl_shared_banshee1")
    (flock_create "fl_shared_falcon1")
    (flock_create "fl_corvette_phantom1")
    (object_create "sc_door_towers0")
    (object_create "dm_condo_door0")
    (f_ai_place_vehicle_deathless_no_emp "panoptical_falcon0")
    (f_ai_place_vehicle_deathless_no_emp "panoptical_falcon1")
    (cinematic_exit "050la_wake" true)
    (sleep_until b_towers_started)
    (if debug
        (print "cleaning up panoptical...")
    )
)

(script dormant void unperch_panoptical_raven
    (sleep_until (volume_test_players "tv_fl_panoptical_raven0"))
    (flock_create "fl_panoptical_raven0")
)

(script dormant void panoptical_waypoint
    (sleep g_waypoint_timeout)
    (if (not b_towers_started)
        (f_blip_flag "nav_panoptical_exit" blip_default)
    )
    (sleep_until b_towers_started 1)
    (f_unblip_flag "nav_panoptical_exit")
    (flock_stop "fl_panoptical_raven0")
)

(script command_script void cs_panoptical_falcon0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_vehicle_speed_instantaneous 1)
    (cs_vehicle_boost true)
    (cs_attach_to_spline "spline_panoptical_evac0")
    (cs_fly_to "pts_panoptical_evac/f_exit0" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_panoptical_falcon1
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_vehicle_speed_instantaneous 1)
    (cs_vehicle_boost true)
    (cs_attach_to_spline "spline_panoptical_evac1")
    (cs_fly_to "pts_panoptical_evac/f_exit1" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script dormant void towers_objective_control
    (if debug
        (print "encounter start: towers")
    )
    (set b_towers_started true)
    (sleep_forever f_panoptical_fx_ambient)
    (wake f_towers_fx_ambient)
    (wake towers_longsword_cycle)
    (wake md_amb_cruiser01)
    (wake towers_waypoint)
    (ai_place "cov.towers.skirmishers")
    (ai_place "cov.towers.skirmishers1")
    (device_operates_automatically_set "dm_condo_door0" false)
    (device_closes_automatically_set "dm_condo_door0" false)
    (device_set_position "dm_condo_door0" 1)
    (sleep_until b_canyonview_started)
    (if debug
        (print "cleaning up towers...")
    )
    (ai_disposable "gr_cov_towers" true)
)

(script static void towers_skirmisher_escape
    (ai_set_objective "gr_cov_towers" "obj_interior_cov")
    (sleep (* 30 5))
    (device_operates_automatically_set "dm_condo_door0" true)
    (device_closes_automatically_set "dm_condo_door0" true)
    (game_save)
)

(script dormant void towers_waypoint
    (sleep g_waypoint_timeout)
    (if (not b_interior_started)
        (f_blip_flag "nav_towers_exit" blip_default)
    )
    (sleep_until b_interior_started 5)
    (f_unblip_flag "nav_towers_exit")
)

(script dormant void towers_patrol
    (sleep_until (or (volume_test_players "tv_towers_stair_left") (volume_test_players "tv_towers_stair_right")) 5)
    (ai_place "towers_cov_inf0")
)

(script dormant void interior_objective_control
    (if debug
        (print "encounter start: interior")
    )
    (set b_interior_started true)
    (game_save)
    (set objcon_interior 0)
    (ai_disposable "gr_cov_panoptical" true)
    (ai_disposable "unsc.towers.marine" true)
    (sleep_forever panoptical_longsword_cycle)
    (sleep_forever towers_longsword_cycle)
    (sleep_forever f_towers_fx_ambient)
    (object_cinematic_visibility "sc_corvette1" true)
    (flock_create "fl_interior_rats0")
    (wake ct_training_ui_vision)
    (wake interior_spawn_kamikazes)
    (wake interior_waypoint)
    (wake interior_sound_crash)
    (sleep_until (volume_test_players "tv_objcon_interior_10") 1)
    (if debug
        (print "objective control: interior 10")
    )
    (set objcon_interior 10)
    (sleep_until (volume_test_players "tv_objcon_interior_20") 1)
    (if debug
        (print "objective control: interior 20")
    )
    (set objcon_interior 20)
    (mus_start mus_02)
    (sleep_until (volume_test_players "tv_objcon_interior_25") 1)
    (if debug
        (print "objective control: interior 25")
    )
    (set objcon_interior 25)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_interior_30") 1)
    (if debug
        (print "objective control: interior 30")
    )
    (set objcon_interior 30)
    (device_set_position_immediate "dm_condo_door0" 0)
    (sleep 1)
    (device_set_power "dm_condo_door0" 0)
    (sleep_until (volume_test_players "tv_objcon_interior_40") 1)
    (if debug
        (print "objective control: interior 40")
    )
    (set objcon_interior 40)
    (sleep_until (volume_test_players "tv_objcon_interior_50") 1)
    (if debug
        (print "objective control: interior 50")
    )
    (set objcon_interior 50)
    (sleep_until (volume_test_players "tv_objcon_interior_60") 1)
    (if debug
        (print "objective control: interior 60")
    )
    (set objcon_interior 60)
    (wake ambient_spawn_dropships)
    (wake ambient_wraith_shells_a)
    (wake ambient_wraith_shells_b)
    (sleep_until b_canyonview_started)
    (if debug
        (print "cleaning up interior...")
    )
    (ai_disposable "gr_cov_interior" true)
)

(script dormant void interior_spawn_kamikazes
    (ai_place "cov.interior.grunts.1")
    (sleep_until (>= objcon_interior 20) 1)
    (ai_place "cov.interior.grunts.2")
    (sleep_until (>= objcon_interior 30) 1)
    (ai_place "cov.interior.grunts.3a")
    (ai_place "cov.interior.grunts.3b")
    (ai_place "cov.interior.grunts.3c")
    (sleep_until (>= objcon_interior 40) 1)
    (ai_place "cov.interior.grunts.4a")
    (ai_place "cov.interior.grunts.4b")
    (ai_place "cov.interior.grunts.4c")
    (ai_place "cov.interior.grunts.5a")
    (ai_place "cov.interior.grunts.5b")
    (ai_place "cov.interior.grunts.5c")
    (sleep_until (>= objcon_interior 50) 1)
    (ai_place "cov.interior.grunts.phalanx1a")
    (ai_place "cov.interior.grunts.phalanx1b")
    (ai_place "cov.interior.grunts.phalanx1c")
    (ai_place "cov.interior.grunts.phalanx2a")
    (ai_place "cov.interior.grunts.phalanx2b")
    (ai_place "cov.interior.grunts.phalanx2c")
)

(script dormant void interior_sound_crash
    (sleep_until (>= objcon_interior 50))
    (sleep (random_range 30 180))
    (if debug
        (print "longsword incoming...")
    )
    (sleep (random_range 60 120))
    (if (> (random_range 0 100) 25)
        (begin
            (if debug
                (print "longsword bomb...")
            )
            (snd_play "sound\weapons\mac_gun\mac_gun_m50\mac_gun_m50.sound")
            (sleep 66)
            (snd_play "sound\levels\120_halo\trench_run\island_creak.sound")
            (cam_shake 0.2 1 3)
            (interpolator_start "base_bombing")
            (cs_run_command_script "cov.interior.grunts.1" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.2" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.3a" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.3b" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.3c" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.4a" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.4b" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.4c" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.5a" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.5b" cs_wakeup)
            (cs_run_command_script "cov.interior.grunts.5c" cs_wakeup)
        )
        (if debug
            (print "the rng is watching out for you...")
        )
    )
)

(script command_script void cs_wakeup
    (cs_force_combat_status ai_current_actor 2)
)

(script dormant void go_wild
    (sleep_until 
        (begin
            (sleep (* 30 1))
            (ai_place_cue "interior_grunt_kamikaze")
            (sleep 10)
            (ai_remove_cue "interior_grunt_kamikaze")
            false
        )
    )
)

(script dormant void ct_training_ui_vision
    (sleep_until (>= objcon_interior 10))
    (if (not (difficulty_is_legendary))
        (begin
            (f_hud_training player0 "ct_training_vision")
            (f_hud_training player1 "ct_training_vision")
            (f_hud_training player2 "ct_training_vision")
            (f_hud_training player3 "ct_training_vision")
        )
    )
)

(script dormant void interior_waypoint
    (sleep_until 
        (begin
            (sleep g_waypoint_timeout)
            (if (or (volume_test_players "tv_interior_wp_01") (volume_test_players "tv_interior_wp_01a"))
                (begin
                    (f_blip_flag "nav_interior_01" blip_default)
                    (sleep_until (not (or (volume_test_players_all "tv_interior_wp_01") (volume_test_players_all "tv_interior_wp_01a"))) 1)
                    (f_unblip_flag "nav_interior_01")
                )
                (if (volume_test_players "tv_interior_wp_02")
                    (begin
                        (f_blip_flag "nav_interior_02" blip_default)
                        (sleep_until (not (volume_test_players_all "tv_interior_wp_02")) 1)
                        (f_unblip_flag "nav_interior_02")
                    )
                    (if (volume_test_players "tv_interior_wp_03")
                        (begin
                            (f_blip_flag "nav_interior_03" blip_default)
                            (sleep_until (not (volume_test_players_all "tv_interior_wp_03")) 1)
                            (f_unblip_flag "nav_interior_03")
                        )
                        (if (volume_test_players "tv_interior_wp_04")
                            (begin
                                (f_blip_flag "nav_interior_04" blip_default)
                                (sleep_until (not (volume_test_players_all "tv_interior_wp_04")) 1)
                                (f_unblip_flag "nav_interior_04")
                            )
                            (if (volume_test_players "tv_interior_wp_05")
                                (begin
                                    (f_blip_flag "nav_interior_05" blip_default)
                                    (sleep_until (not (volume_test_players_all "tv_interior_wp_05")) 1)
                                    (f_unblip_flag "nav_interior_05")
                                )
                            )
                        )
                    )
                )
            )
            b_canyonview_started
        )
    )
)

(script dormant void canyonview_objective_control
    (if debug
        (print "encounter start: canyon view")
    )
    (set b_canyonview_started true)
    (set objcon_canyonview 0)
    (ai_disposable "towers_cov_inf0" true)
    (ai_set_objective "fireteam_player0" "obj_canyonview_unsc")
    (ai_place "cv_unsc_echo_inf0")
    (sleep 1)
    (ai_cannot_die "cv_unsc_echo_inf0" true)
    (if (not (game_is_cooperative))
        (begin
            (ai_place "cv_unsc_echo_inf1")
            (sleep 1)
            (ai_cannot_die "cv_unsc_echo_inf1" true)
        )
    )
    (ai_place "panoptical_civilians0")
    (sleep 1)
    (ai_force_low_lod "panoptical_civilians0")
    (ai_disregard (ai_get_object "panoptical_civilians0") true)
    (thespian_performance_setup_and_begin "panoptical_injured" "" 0)
    (sleep 1)
    (thespian_folder_activate "th_canyon")
    (wake brute_intro)
    (wake fork_intro)
    (wake canyonview_counterattack)
    (wake canyonview_waypoint)
    (object_create "dm_atrium_ctyd_door2")
    (object_create "sc_atrium_ctyd_door1")
    (object_create "sc_atrium_ctyd_door0")
    (flock_stop "fl_interior_rats0")
    (wake md_cv_trooper_intro)
    (sleep_until (volume_test_players "tv_objcon_canyonview_010") 1)
    (if debug
        (print "objective control: canyonview 010")
    )
    (set objcon_canyonview 10)
    (game_save)
    (mus_stop mus_02)
    (sleep_until (volume_test_players "tv_objcon_canyonview_020") 1)
    (if debug
        (print "objective control: canyonview 020")
    )
    (set objcon_canyonview 20)
    (wake canyonview_zone_set_control)
    (sleep_until (volume_test_players "tv_objcon_canyonview_030") 1)
    (if debug
        (print "objective control: canyonview 030")
    )
    (set objcon_canyonview 30)
    (sleep_until (volume_test_players "tv_objcon_canyonview_040") 1)
    (if debug
        (print "objective control: canyonview 040")
    )
    (set objcon_canyonview 40)
    (sleep_until (volume_test_players "tv_objcon_canyonview_050") 1)
    (if debug
        (print "objective control: canyonview 050")
    )
    (set objcon_canyonview 50)
    (sleep_until (volume_test_players "tv_objcon_canyonview_060") 1)
    (if debug
        (print "objective control: canyonview 060")
    )
    (set objcon_canyonview 60)
    (sleep_until (volume_test_players "tv_objcon_canyonview_070") 1)
    (if debug
        (print "objective control: canyonview 070")
    )
    (set objcon_canyonview 70)
    (sleep_until b_atrium_started)
    (if debug
        (print "cleaning up canyonview...")
    )
    (ai_disposable "gr_cov_cv" true)
    (ai_kill_silent "panoptical_civilians0")
    (thespian_folder_deactivate "th_canyon")
)

(script dormant void canyonview_counterattack
    (sleep 30)
    (sleep_until (f_task_is_empty "obj_canyonview_cov/gate_main"))
    (if debug
        (print "starting counterattack...")
    )
    (game_save)
    (sleep 90)
    (set b_cv_counter_started true)
    (ai_migrate "gr_unsc" "fireteam_player0")
    (ai_set_objective "fireteam_player0" "obj_canyonview_unsc")
    (if (game_is_cooperative)
        (player_set_profile "profile_combat")
    )
    (sleep_until (= (current_zone_set_fully_active) 3))
    (sleep 10)
    (ai_place "cs_counter_inf0")
    (device_set_position "dm_canyonview_door1" 1)
    (sleep 1)
    (sleep_until (f_task_is_empty "obj_canyonview_cov/gate_main"))
    (set b_cv_complete true)
    (sleep (random_range (* 30 3) (* 30 5)))
    (wake md_cv_encounter_complete)
    (if debug
        (print "counterattack complete...")
    )
    (ai_set_objective "fireteam_player0" "obj_atrium_unsc")
)

(script static boolean cv_player_near_troopers
    (and (< (objects_distance_to_object (ai_get_object "gr_unsc") (player0)) 8) (> (objects_distance_to_object (ai_get_object "gr_unsc") (player0)) 0))
)

(script dormant void brute_intro
    (ai_place "cv_civilians_near0")
    (ai_place "cv_civilians_near1")
    (ai_place "cv_civilians_near2")
    (ai_place "cv_civilian0")
    (ai_place "cv_civilian1")
    (ai_place "cv_civilian2")
    (ai_place "cv_cov_brute_intro0")
    (ai_place "cv_cov_brute_intro1")
    (ai_place "cv_cov_brute_intro2")
    (thespian_performance_setup_and_begin "canyonview_brute0" "" 0)
    (thespian_performance_setup_and_begin "canyonview_brute1" "" 0)
    (thespian_performance_setup_and_begin "canyonview_brute2" "" 0)
    (ai_disregard (ai_get_object "cv_civilian0") true)
    (ai_disregard (ai_get_object "cv_civilian1") true)
    (ai_disregard (ai_get_object "cv_civilian2") true)
    (ai_force_low_lod "cv_civilian0")
    (ai_force_low_lod "cv_civilian1")
    (ai_force_low_lod "cv_civilian2")
    (ai_force_low_lod "cv_civilians_near1")
    (ai_force_low_lod "cv_civilians_near2")
    (sleep_until (>= objcon_canyonview 10) 5)
    (wake canyonview_longsword_cycle)
    (wake f_canyon_fx_ambient)
    (wake md_canyonview_civilian_intro)
    (ai_cannot_die "gr_unsc" false)
)

(script static boolean (sleep_brute0 (ai my_actor))
    (or (<= (ai_strength my_actor) 0.5) (volume_test_players "tv_brute0_interupt"))
)

(script static boolean (branch_brute1 (ai my_actor))
    (or (<= (ai_strength my_actor) 0.5) (volume_test_players "tv_brute1_interupt"))
)

(script static boolean (branch_brute2 (ai my_actor))
    (or (> (object_get_recent_shield_damage (ai_get_object my_actor)) 0) (> (object_get_recent_body_damage (ai_get_object my_actor)) 0) (volume_test_players "tv_brute2_interupt") (<= (ai_task_count "obj_canyonview_cov/gate_main") 1))
)

(script static void (brute_interupt (ai ai_civilian))
    (print "kill civilian")
    (ai_kill ai_civilian)
)

(script command_script void cs_canyonview_brute_alert
    (sleep_until (> (ai_combat_status ai_current_actor) 3) 5)
    (ai_set_objective ai_current_actor "obj_canyonview_cov")
)

(script command_script void cs_canyon_civilians_escape
    (cs_enable_targeting false)
    (cs_go_to "canyon_civilians/leap")
    (cs_go_to "canyon_civilians/escape")
    (ai_erase ai_current_actor)
)

(script command_script void cs_canyon_civilians_escape_far
    (cs_enable_targeting false)
    (unit_set_stance (ai_get_unit ai_current_actor) "panic")
    (cs_go_to "canyon_civilians/leap_far")
    (cs_go_to "canyon_civilians/escape_far")
    (ai_erase ai_current_actor)
)

(script dormant void canyon_civilians_far
    (ai_place "cv_brutes_far0")
    (sleep_until 
        (begin
            (ai_place "cv_civilians_far0")
            (ai_force_low_lod "cv_civilians_far0")
            (sleep_until (f_ai_is_defeated "cv_civilians_far0"))
            b_cv_complete
        )
    )
)

(script dormant void fork_intro
    (f_ai_place_vehicle_deathless "fork_brutes")
    (sleep 1)
    (ai_set_blind "fork_brutes/brute4" true)
    (ai_cannot_die "fork_brutes/brute3" true)
    (ai_cannot_die "fork_brutes/brute2" true)
    (ai_cannot_die "fork_brutes/brute1" true)
)

(script command_script void cs_cv_brute_fork1
    (cs_vehicle_speed 1)
    (sleep_until (volume_test_players "tv_cv_brute_intro") 5)
    (set b_brute_fork_load true)
    (print "load_brute_fork")
    (unit_open (ai_vehicle_get_from_spawn_point "fork_brutes/brute4"))
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute1") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l3")
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute2") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l4")
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute3") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l6")
    (cs_fly_to_and_face "pts_cv_brute_fork0/entry0" "pts_cv_brute_fork0/entry_facing")
    (sleep (* 30 2))
    (set b_brute_taunt true)
    (sleep (* 30 2))
    (ai_set_targeting_group "fork_brutes/brute4" 4 false)
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "pts_cv_brute_fork0/hover" "pts_cv_brute_fork0/land_facing" 0.25)
    (sleep 10)
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_cv_brute_fork0/land" "pts_cv_brute_fork0/land_facing" 0.25)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 39)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 40)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 41)
    (sleep 1)
    (ai_cannot_die "fork_brutes/brute3" false)
    (ai_cannot_die "fork_brutes/brute2" false)
    (ai_cannot_die "fork_brutes/brute1" false)
    (ai_erase "fork_brutes/brute1")
    (ai_erase "fork_brutes/brute2")
    (ai_erase "fork_brutes/brute3")
    (sleep 1)
    (ai_place "cv_cov_counter_chieftain")
    (ai_place "cv_cov_counter_guards/bodyguard0")
    (ai_place "cv_cov_counter_guards/bodyguard1")
    (sleep 1)
    (if b_debug_fork
        (print "load fork left...")
    )
    (ai_vehicle_enter_immediate "cv_cov_counter_guards/bodyguard0" (ai_vehicle_get ai_current_actor) 9)
    (ai_vehicle_enter_immediate "cv_cov_counter_chieftain" (ai_vehicle_get ai_current_actor) 10)
    (ai_vehicle_enter_immediate "cv_cov_counter_guards/bodyguard1" (ai_vehicle_get ai_current_actor) 12)
    (sleep 1)
    (f_unload_fork (ai_vehicle_get ai_current_actor) "left")
    (sleep (* 30 1))
    (set b_cv_chieftain_delivered true)
    (cs_fly_to_and_face "pts_cv_brute_fork0/hover" "pts_cv_brute_fork0/land_facing" 0.5)
    (sleep 10)
    (cs_vehicle_speed 1)
    (cs_fly_by "pts_cv_brute_fork0/exit0")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (if (or (volume_test_objects "tv_cv_hack" (ai_actors "cv_cov_counter_chieftain")) (volume_test_objects "tv_cv_hack" (ai_actors "cv_cov_counter_guards")))
        (begin
            (print "killing dudes")
            (ai_kill "cv_cov_counter_chieftain")
            (ai_kill "cv_cov_counter_guards")
        )
    )
    (sleep 1)
    (ai_erase ai_current_squad)
)

(script command_script void cs_cv_brute_fork2
    (sleep (* 30 2))
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "pts_cv_brute_fork0/hover" "pts_cv_brute_fork0/land_facing" 0.25)
    (sleep 10)
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "pts_cv_brute_fork0/land" "pts_cv_brute_fork0/land_facing" 0.25)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 39)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 40)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 41)
    (sleep 1)
    (ai_erase "fork_brutes/brute1")
    (ai_erase "fork_brutes/brute2")
    (ai_erase "fork_brutes/brute3")
    (sleep 1)
    (ai_place "cv_cov_counter_chieftain")
    (ai_place "cv_cov_counter_guards/bodyguard0")
    (ai_place "cv_cov_counter_guards/bodyguard1")
    (sleep 1)
    (if b_debug_fork
        (print "load fork left...")
    )
    (ai_vehicle_enter_immediate "cv_cov_counter_guards/bodyguard0" (ai_vehicle_get ai_current_actor) 9)
    (ai_vehicle_enter_immediate "cv_cov_counter_chieftain" (ai_vehicle_get ai_current_actor) 10)
    (ai_vehicle_enter_immediate "cv_cov_counter_guards/bodyguard1" (ai_vehicle_get ai_current_actor) 12)
    (sleep 1)
    (f_unload_fork (ai_vehicle_get ai_current_actor) "left")
    (sleep (* 30 1))
    (set b_cv_chieftain_delivered true)
    (cs_fly_to_and_face "pts_cv_brute_fork0/hover" "pts_cv_brute_fork0/land_facing" 0.5)
    (sleep 10)
    (cs_vehicle_speed 1)
    (cs_fly_by "pts_cv_brute_fork0/exit0")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script static void load_brute_fork
    (print "load_brute_fork")
    (unit_open (ai_vehicle_get_from_spawn_point "fork_brutes/brute4"))
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute1") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l3")
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute2") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l4")
    (unit_enter_vehicle_immediate (ai_get_unit "fork_brutes/brute3") (ai_vehicle_get_from_spawn_point "fork_brutes/brute4") "m50_tuning_fork_l6")
    (sleep (* 30 2))
    (set b_brute_taunt true)
)

(script dormant void canyonview_zone_set_control
    (device_set_position_immediate "dm_interior_door1" 0)
    (sleep_until (= (device_get_position "dm_interior_door1") 0))
    (teleport_players_not_in_volume "tv_cv_teleport1" "cf_teleport_cv0" "cf_teleport_cv1" "cf_teleport_cv2" "cf_teleport_cv3")
    (prepare_to_switch_to_zone_set "set_atrium_040_050_060")
    (sleep (* 30 12))
    (switch_zone_set "set_atrium_040_050_060")
    (object_cinematic_visibility "sc_corvette1" false)
)

(script dormant void canyonview_waypoint_timeout
    (sleep g_waypoint_timeout)
    (set b_canyonview_timeout true)
)

(script dormant void canyonview_waypoint
    (wake canyonview_waypoint_timeout)
    (sleep_until (and b_canyonview_timeout b_cv_counter_started))
    (if (not b_atrium_started)
        (f_blip_flag "nav_canyonview_exit" blip_default)
    )
    (sleep_until b_atrium_started 5)
    (f_unblip_flag "nav_canyonview_exit")
)

(script command_script void cs_set_stance_panic
    (unit_set_stance (ai_get_unit ai_current_actor) "panic")
)

(script command_script void cs_set_stance_none
    (unit_set_stance (ai_get_unit ai_current_actor) "")
)

(script dormant void atrium_objective_control
    (if debug
        (print "encounter start: atrium")
    )
    (set b_atrium_started true)
    (game_save)
    (set objcon_atrium 0)
    (ai_disposable "gr_civilians_panoptical" true)
    (thespian_folder_activate "th_atrium")
    (ai_set_objective "fireteam_player0" "obj_atrium_unsc")
    (kill_ambient_dropships)
    (ai_place "gr_cov_atrium_initial")
    (sleep 1)
    (wake atrium_combat_progression)
    (wake atrium_civilians)
    (sleep_forever ambient_wraith_shells_a)
    (sleep_forever ambient_wraith_shells_b)
    (sleep_forever f_canyon_fx_ambient)
    (wake md_traxus_ai_elevator)
    (wake md_atrium_elevator_call)
    (wake md_atrium_hunters_arrive)
    (wake md_atrium_hunters_defeated)
    (wake f_atrium_fx_ambient)
    (wake md_info_booth)
    (wake md_atrium_ai_response)
    (wake atrium_waypoint)
    (flock_delete "fl_interior_rats0")
    (sleep_until (volume_test_players "tv_objcon_atrium_005") 1)
    (if debug
        (print "objective control: atrium 005")
    )
    (set objcon_atrium 5)
    (sleep_until (volume_test_players "tv_objcon_atrium_010") 1)
    (if debug
        (print "objective control: atrium 010")
    )
    (set objcon_atrium 10)
    (sleep_until (volume_test_players "tv_objcon_atrium_020") 1)
    (if debug
        (print "objective control: atrium 020")
    )
    (set objcon_atrium 20)
    (sleep_until (volume_test_players "tv_objcon_atrium_030") 1)
    (if debug
        (print "objective control: atrium 030")
    )
    (set objcon_atrium 30)
    (sleep_until (volume_test_players "tv_objcon_atrium_040") 1)
    (if debug
        (print "objective control: atrium 040")
    )
    (set objcon_atrium 40)
    (sleep_until (volume_test_players "tv_objcon_atrium_050") 1)
    (if debug
        (print "objective control: atrium 050")
    )
    (set objcon_atrium 50)
    (sleep_until (volume_test_players "tv_objcon_atrium_060") 1)
    (if debug
        (print "objective control: atrium 060")
    )
    (set objcon_atrium 60)
    (sleep_until (volume_test_players "tv_objcon_atrium_070") 1)
    (if debug
        (print "objective control: atrium 070")
    )
    (set objcon_atrium 70)
    (garbage_collect_unsafe)
    (sleep_until b_ready_started)
    (if debug
        (print "cleaning up atrium...")
    )
    (ai_disposable "gr_cov_atrium" true)
    (ai_disposable "gr_civilians_atrium" true)
    (ai_disposable "atrium_unsc_troopers" true)
    (ai_disposable "atrium_unsc_troopers1" true)
    (ai_erase "gr_cov_atrium")
    (ai_erase "gr_civilians_atrium")
    (ai_erase "gr_civilian_cv")
    (ai_erase "atrium_unsc_troopers")
    (ai_erase "atrium_unsc_troopers1")
    (thespian_folder_deactivate "th_atrium")
)

(script dormant void atrium_combat_progression
    (sleep 10)
    (if (game_is_cooperative)
        (set g_atrium_unsc_desired (- g_atrium_unsc_desired 2))
    )
    (set g_atrium_unsc_current (ai_task_count "obj_atrium_unsc/gate_marines"))
    (if (< g_atrium_unsc_current g_atrium_unsc_desired)
        (ai_place "atrium_unsc_troopers" (- g_atrium_unsc_desired g_atrium_unsc_current))
    )
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad player0 "atrium_unsc_troopers")
    )
    (sleep_until (>= objcon_atrium 40))
    (device_set_power "dm_atrium_ctyd_door2" 1)
    (sleep_until (and (> (device_get_position "atrium_elevator_call") 0) (<= (ai_task_count "obj_atrium_cov/gate_initial") 1)) 1)
    (mus_start mus_03)
    (set g_atrium_civ_current (ai_task_count "obj_atrium_unsc/gate_civilians"))
    (if (< g_atrium_civ_current g_atrium_civ_desired)
        (ai_place "atrium_civilians3" (- g_atrium_civ_desired g_atrium_civ_current))
    )
    (set g_atrium_unsc_current (ai_task_count "obj_atrium_unsc/gate_marines"))
    (if (< g_atrium_unsc_current g_atrium_unsc_desired)
        (ai_place "atrium_unsc_troopers1" (- g_atrium_unsc_desired g_atrium_unsc_current))
    )
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad player0 "atrium_unsc_troopers1")
    )
    (set b_atrium_counterattack_started true)
    (game_save)
    (sleep (* 30 2))
    (sleep (* 30 2))
    (game_save_no_timeout)
    (sleep (* 30 2))
    (wake md_atrium_counterattack)
    (sleep (random_range 30 90))
    (if debug
        (print "sending in right dropship...")
    )
    (f_ai_place_vehicle_deathless "atrium_cov_ds1")
    (sleep 1)
    (game_save)
    (sleep (random_range 30 90))
    (f_ai_place_vehicle_deathless "atrium_cov_ds3")
    (sleep 1)
    (sleep_until (<= (ai_living_count "atrium_cov_ds3") 4) 5)
    (sleep (* 30 6))
    (sleep_until (and (<= (ai_task_count "obj_atrium_cov/gate_main") 1) (<= (ai_task_count "obj_atrium_cov/game_hammer") 0)))
    (set b_atrium_complete true)
    (game_save)
    (sleep 90)
    (ai_place "atrium_unsc_elevator/atrium")
    (device_set_position "dm_atrium_elevator_door0" 1)
    (f_blip_object "atrium_elevator_switch" blip_interface)
    (sleep_until (> (device_get_position "atrium_elevator_switch") 0))
    (device_set_power "atrium_elevator_switch" 0)
    (f_unblip_object "atrium_elevator_switch")
    (if (not (game_is_cooperative))
        (ai_player_remove_fireteam_squad player0 "fireteam_player0")
    )
    (device_set_position_track "atrium_elevator_platform" "position" 0)
    (device_animate_position "atrium_elevator_platform" 0.12 2 0.125 0.125 false)
    (sleep_until (>= (device_get_position "atrium_elevator_platform") 0.12))
    (device_set_position "dm_atrium_elevator_door0" 0)
    (if (not (volume_test_object "tv_md_traxus_elevator" player0))
        (begin
            (object_teleport_to_ai_point player0 "pts_elevator_teleport/p0")
        )
    )
    (if (not (volume_test_object "tv_md_traxus_elevator" player1))
        (begin
            (object_teleport_to_ai_point player1 "pts_elevator_teleport/p1")
        )
    )
    (if (not (volume_test_object "tv_md_traxus_elevator" player2))
        (begin
            (object_teleport_to_ai_point player2 "pts_elevator_teleport/p2")
        )
    )
    (if (not (volume_test_object "tv_md_traxus_elevator" player3))
        (begin
            (object_teleport_to_ai_point player3 "pts_elevator_teleport/p3")
        )
    )
    (sleep 10)
    (mus_stop mus_03)
    (device_animate_position "atrium_elevator_platform" 0.8125 20 1 1 false)
    (wake md_ready_intro)
    (sleep_until (>= (device_get_position "atrium_elevator_platform") 0.8125) 1)
    (device_set_position "dm_atrium_elevator_door1" 1)
    (sleep_until (>= (device_get_position "dm_atrium_elevator_door1") 1) 1)
    (device_animate_position "atrium_elevator_platform" 1 2 0.125 0.125 false)
)

(script command_script void cs_atrium_ds1_deliver
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (ai_place "atrium_cov_captain1")
    (ai_place "atrium_cov_counter_inf2")
    (ai_place "atrium_cov_counter_inf3")
    (sleep 1)
    (if b_debug_phantom
        (print "load phantom right...")
    )
    (ai_vehicle_enter_immediate "atrium_cov_counter_inf3" (ai_vehicle_get ai_current_actor) 27)
    (ai_vehicle_enter_immediate "atrium_cov_counter_inf2" (ai_vehicle_get ai_current_actor) 28)
    (ai_vehicle_enter_immediate "atrium_cov_captain1" (ai_vehicle_get ai_current_actor) 30)
    (cs_fly_by "pts_atrium_dropship1/entry0")
    (cs_vehicle_speed 0.8)
    (cs_fly_to "pts_atrium_dropship1/hover")
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_atrium_dropship1/land" "pts_atrium_dropship1/land_facing" 0.25)
    (sleep 60)
    (unit_open (ai_vehicle_get ai_current_actor))
    (sleep 60)
    (f_unload_ph_right (ai_vehicle_get ai_current_actor))
    (sleep 75)
    (unit_close (ai_vehicle_get ai_current_actor))
    (sleep (* 30 8))
    (unit_open (ai_vehicle_get ai_current_actor))
    (sleep 60)
    (f_unload_ph_mid_right (ai_vehicle_get ai_current_actor))
    (sleep 75)
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_fly_to_and_face "pts_atrium_dropship1/hover" "pts_atrium_dropship1/land_facing")
    (sleep 60)
    (cs_fly_to "pts_atrium_dropship1/exit0")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_atrium_ds3_deliver
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "left" "atrium_cov_captain0" "atrium_cov_counter_inf0" "atrium_cov_counter_inf1" none)
    (cs_fly_by "pts_atrium_dropship4/entry0")
    (cs_vehicle_speed 0.9)
    (cs_fly_to "pts_atrium_dropship4/hover")
    (sleep 30)
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_atrium_dropship4/land" "pts_atrium_dropship4/land_facing" 0.5)
    (sleep 60)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "left")
    (cs_fly_to_and_face "pts_atrium_dropship4/hover" "pts_atrium_dropship4/land_facing")
    (sleep 60)
    (cs_fly_to "pts_atrium_dropship4/exit0")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script dormant void atrium_civilians
    (ai_place "atrium_civilians0")
    (ai_place "atrium_civilians1")
    (sleep 1)
    (ai_set_objective "gr_civilian_cv" "obj_atrium_unsc")
    (ai_force_low_lod "gr_civilian")
    (sleep_until (>= objcon_atrium 40))
    (ai_place "atrium_civilians2")
    (ai_force_low_lod "gr_civilian")
    (sleep_until b_atrium_complete)
    (ai_force_full_lod "gr_civilian")
)

(script command_script void cs_elevator_hack
    (cs_go_to "elevator_hack/p0")
)

(script dormant void atrium_waypoint_timeout
    (sleep g_waypoint_timeout)
    (set b_atrium_timeout true)
)

(script dormant void atrium_waypoint
    (wake atrium_waypoint_timeout)
    (sleep_until (or b_atrium_timeout (volume_test_players "tv_objcon_atrium_060") (<= (ai_task_count "obj_atrium_cov/gate_initial") 1)))
    (if (not b_ready_started)
        (f_blip_object "atrium_elevator_call" blip_interface)
    )
    (sleep_until (or (>= (device_get_position "atrium_elevator_call") 1) b_atrium_counterattack_started) 5)
    (f_unblip_object "atrium_elevator_call")
    (sleep_until b_md_defend_complete)
    (f_blip_flag "nav_atrium_10" blip_defend)
    (sleep_until b_atrium_complete 5)
    (f_unblip_flag "nav_atrium_10")
)

(script command_script void cs_atrium_hunter0_enter
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_go_to "pts_atrium_hunters/hunter0_p0")
    (cs_go_to "pts_atrium_hunters/hunter0_p1")
)

(script command_script void cs_atrium_hunter1_enter
    (cs_abort_on_alert true)
    (cs_abort_on_damage true)
    (cs_go_to "pts_atrium_hunters/hunter1_p0")
    (cs_go_to "pts_atrium_hunters/hunter1_p1")
)

(script command_script void cs_atrium_machinegun1
    (ai_vehicle_enter ai_current_actor "ve_atrium_machinegun1")
)

(script dormant void ready_objective_control
    (if debug
        (print "encounter start: ready room")
    )
    (set b_ready_started true)
    (set objcon_ready 0)
    (ai_place "rr_unsc_inf0")
    (sleep 1)
    (ai_set_targeting_group "rr_unsc_inf0" 1 true)
    (ai_place "rr_unsc_medic0")
    (ai_place "rr_civilians0")
    (sleep 1)
    (thespian_performance_setup_and_begin "ready_injured" "" 0)
    (game_insertion_point_unlock 1)
    (sleep_longswords)
    (sleep_forever panoptical_longsword_cycle)
    (sleep_forever towers_longsword_cycle)
    (sleep_forever md_traxus_evac_loop)
    (sleep_forever f_atrium_fx_ambient)
    (sleep_forever md_info_booth)
    (garbage_collect_now)
    (wake ct_title_act2)
    (wake ready_fork0_main)
    (wake jl_suit_up_sequence)
    (wake th_ready_point)
    (wake ready_waypoint)
    (wake remove_ready_triage)
    (wake migrate_elevator)
    (wake f_jetpack_fx_ambient)
    (wake jetpack_longsword_cycle)
    (m50_terminals)
    (sleep_until (volume_test_players "tv_objcon_ready_010") 1)
    (if debug
        (print "objective control: ready 010")
    )
    (set objcon_ready 10)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_020") 1)
    (if debug
        (print "objective control: ready 020")
    )
    (set objcon_ready 20)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_030") 1)
    (if debug
        (print "objective control: ready 030")
    )
    (set objcon_ready 30)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_040") 1)
    (if debug
        (print "objective control: ready 040")
    )
    (set objcon_ready 40)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_050") 1)
    (if debug
        (print "objective control: ready 050")
    )
    (set objcon_ready 50)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_060") 1)
    (if debug
        (print "objective control: ready 060")
    )
    (set objcon_ready 60)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_ready_070") 1)
    (if debug
        (print "objective control: ready 070")
    )
    (set objcon_ready 70)
    (sleep_until (volume_test_players "tv_objcon_ready_080") 1)
    (if debug
        (print "objective control: ready 080")
    )
    (set objcon_ready 80)
    (game_save)
    (thespian_performance_kill_by_name "ready_odsts_breach")
    (wake md_jp_flourish)
    (sleep_until (volume_test_players "tv_objcon_ready_090") 1)
    (if debug
        (print "objective control: ready 090")
    )
    (set objcon_ready 90)
    (game_save)
    (sleep_until b_jetpack_low_started)
    (if debug
        (print "cleaning up ready room...")
    )
    (object_destroy "sc_ready_civilian_fm1")
    (object_destroy "sc_ready_civilian_fm2")
    (object_destroy "sc_ready_civilian_fm3")
    (object_destroy "sc_ready_civilian_m1")
    (object_destroy "sc_ready_civilian_m2")
    (object_destroy "sc_ready_civilian_m3")
)

(script dormant void migrate_elevator
    (sleep_until (>= (device_get_position "dm_atrium_elevator_door1") 1) 1)
    (ai_set_objective "atrium_unsc_elevator" "obj_readyroom_unsc")
    (ai_set_objective "gr_civilian" "obj_readyroom_unsc")
)

(script dormant void th_ready_point
    (sleep_until (>= objcon_ready 10) 1)
    (vs_cast "rr_unsc_medic0" false 10 "m50_0570")
    (set trooper4 (vs_role 1))
    (thespian_performance_setup_and_begin "ready_point" "" 0)
)

(script dormant void jl_suit_up_sequence
    (if debug
        (print "starting odst suit up vignette...")
    )
    (sleep_until (>= objcon_ready 20) 1)
    (ai_place "unsc_jl_doorman")
    (ai_place "unsc_jl_odsts/ready0")
    (ai_place "unsc_jl_odsts/ready1")
    (if (not (game_is_cooperative))
        (begin
            (ai_place "unsc_jl_odsts1/ready0")
            (ai_place "unsc_jl_odsts1/ready1")
        )
    )
    (sleep_until (>= objcon_ready 50) 1)
    (wake md_ready_odst_intro)
    (sleep_until (>= objcon_ready 60) 1)
    (thespian_performance_setup_and_begin "ready_odsts_suit_up" "" 0)
    (wake md_ready_odst_intro2)
    (wake ready_blip_jetpacks)
    (sleep_until (ready_player_has_jetpack) 1)
    (if (game_is_cooperative)
        (player_set_profile "profile_jetpack")
    )
    (wake md_ready_player_get_jetpack)
    (if debug
        (print "starting odst breach vignette...")
    )
    (thespian_performance_kill_by_name "ready_odsts_suit_up")
    (thespian_performance_setup_and_begin "ready_odsts_breach" "" 0)
    (ai_set_objective "unsc_jl_odsts" "obj_readyroom_unsc")
    (ai_set_targeting_group "gr_unsc_odst" 1 true)
    (sleep_until (>= objcon_ready 70) 1)
    (thespian_performance_setup_and_begin "ready_odsts_wave" "" 0)
    (sleep_until (>= objcon_ready 90) 1)
    (ai_set_objective "gr_unsc_odst" "obj_jetpack_low_unsc")
    (ai_set_targeting_group "gr_unsc_odst" 65535 true)
)

(script command_script void cs_jl_odsts_wave
    (if debug
        (print "waving!")
    )
)

(script dormant void ready_blip_jetpacks
    (f_blip_object_offset "jetpack_rack0" 21 1)
    (f_blip_object_offset "jetpack_rack1" 21 1)
    (sleep_until (ready_player_has_jetpack))
    (f_unblip_object "jetpack_rack0")
    (f_unblip_object "jetpack_rack1")
    (if (not (difficulty_is_legendary))
        (begin
            (if (>= (game_coop_player_count) 4)
                (wake ct_training_ui_jetpack3)
            )
            (if (>= (game_coop_player_count) 3)
                (wake ct_training_ui_jetpack2)
            )
            (if (>= (game_coop_player_count) 2)
                (wake ct_training_ui_jetpack1)
            )
            (if (>= (game_coop_player_count) 1)
                (wake ct_training_ui_jetpack0)
            )
        )
    )
)

(script dormant void ready_spawn_odsts
    (sleep_until (>= objcon_ready 80) 1)
)

(script dormant void ready_fork0_main
    (sleep_until (>= objcon_ready 20) 1)
    (ai_place "rr_cov_banshee01")
    (ai_place "rr_cov_banshee02")
    (ai_place "rr_cov_banshee03")
    (sleep 1)
    (ai_set_targeting_group "rr_cov_banshee01" 1 true)
    (ai_set_targeting_group "rr_cov_banshee02" 1 true)
    (ai_set_targeting_group "rr_cov_banshee03" 1 true)
    (sleep_until (and (<= (ai_living_count "rr_cov_banshee01") 0) (<= (ai_living_count "rr_cov_banshee02") 0) (<= (ai_living_count "rr_cov_banshee03") 0) (sleep_until (>= objcon_ready 50) 1)))
    (ai_place "rr_cov_banshee01")
    (ai_place "rr_cov_banshee02")
    (ai_place "rr_cov_banshee03")
    (sleep 1)
    (ai_set_targeting_group "rr_cov_banshee01" 1 true)
    (ai_set_targeting_group "rr_cov_banshee02" 1 true)
    (ai_set_targeting_group "rr_cov_banshee03" 1 true)
)

(script command_script void cs_rr_fork0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_attach_to_spline "spline_rr_flyby0")
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 0.6)
    (cs_fly_by "pts_rr_fork0/flyby")
    (cs_fly_by "pts_rr_fork0/flyby0")
    (cs_vehicle_speed 0.4)
    (cs_fly_by "pts_rr_fork0/flyby3")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_rr_banshee01
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/enter_01" 10)
    (cs_fly_by "pts_rr_banshees/approach_01" 10)
    (cs_vehicle_boost false)
    (cs_fly_by "pts_rr_banshees/dive_01")
    (cs_vehicle_speed 0.9)
    (cs_fly_by "pts_rr_banshees/turn_01")
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/exit_01")
    (cs_fly_by "pts_rr_banshees/remove_01")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_rr_banshee02
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/enter_02" 10)
    (cs_fly_by "pts_rr_banshees/approach_02" 10)
    (cs_vehicle_boost false)
    (cs_fly_by "pts_rr_banshees/dive_02")
    (cs_vehicle_speed 0.9)
    (cs_fly_by "pts_rr_banshees/turn_02")
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/exit_02")
    (if (and (>= (ai_living_count "rr_cov_banshee01") 0) (>= (ai_living_count "rr_cov_banshee02") 0) (>= (ai_living_count "rr_cov_banshee03") 0) (>= objcon_ready 50))
        (begin
            (cs_vehicle_boost false)
            (cs_fly_by "pts_rr_banshees/split_02" 10)
            (cs_fly_by "pts_rr_banshees/approach_02" 10)
            (cs_fly_by "pts_rr_banshees/dive_02")
            (cs_vehicle_speed 0.9)
            (cs_fly_by "pts_rr_banshees/turn_02")
            (cs_vehicle_boost true)
            (cs_fly_by "pts_rr_banshees/exit_02")
        )
    )
    (cs_fly_by "pts_rr_banshees/remove_02")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_rr_banshee03
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/enter_03" 10)
    (cs_fly_by "pts_rr_banshees/approach_03" 10)
    (cs_vehicle_boost false)
    (cs_fly_by "pts_rr_banshees/dive_03")
    (cs_vehicle_speed 0.9)
    (cs_fly_by "pts_rr_banshees/turn_03")
    (cs_vehicle_boost true)
    (cs_fly_by "pts_rr_banshees/exit_03")
    (if (and (>= (ai_living_count "rr_cov_banshee01") 0) (>= (ai_living_count "rr_cov_banshee02") 0) (>= (ai_living_count "rr_cov_banshee03") 0) (>= objcon_ready 50))
        (begin
            (cs_vehicle_boost false)
            (cs_fly_by "pts_rr_banshees/split_03" 10)
            (cs_fly_by "pts_rr_banshees/approach_03" 10)
            (cs_fly_by "pts_rr_banshees/dive_03")
            (cs_vehicle_speed 0.9)
            (cs_fly_by "pts_rr_banshees/turn_03")
            (cs_vehicle_boost true)
            (cs_fly_by "pts_rr_banshees/exit_03")
        )
    )
    (cs_fly_by "pts_rr_banshees/remove_03")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script static boolean ready_player_has_jetpack
    (or (unit_has_equipment (player0) "objects\equipment\jet_pack\jet_pack.equipment") (unit_has_equipment (player1) "objects\equipment\jet_pack\jet_pack.equipment") (unit_has_equipment (player2) "objects\equipment\jet_pack\jet_pack.equipment") (unit_has_equipment (player3) "objects\equipment\jet_pack\jet_pack.equipment"))
)

(script dormant void unblip_jetpacks
    (f_unblip_object "jetpack_rack0")
    (f_unblip_object "jetpack_rack1")
)

(script dormant void remove_ready_triage
    (sleep_until b_jetpack_low_started)
    (soft_ceiling_enable "low_jetpack_blocker" true)
    (ai_set_objective "unsc_jl_doorman" "obj_readyroom_unsc")
    (ai_disposable "rr_civilians0" true)
    (ai_disposable "rr_unsc_inf0" true)
    (ai_disposable "atrium_unsc_elevator" true)
    (ai_disposable "unsc_jl_doorman" true)
    (ai_disposable "rr_unsc_medic0" true)
    (sleep_until (and (volume_test_object "tv_ready_triage" (ai_get_object "rr_unsc_inf0")) (!= (volume_test_players "tv_ready_triage") true) (= (device_get_position "dm_ready_door0") 0)))
    (device_one_sided_set "dm_ready_door0" true)
    (ai_erase "rr_civilians0")
    (ai_erase "rr_unsc_inf0")
    (ai_erase "atrium_unsc_elevator")
    (ai_erase "rr_unsc_medic0")
)

(script command_script void cs_remove_ready_triage
    (cs_go_to "pts_ready_remove/p0")
    (sleep_until (= (device_get_position "dm_ready_door0") 1))
    (ai_erase ai_current_actor)
)

(script dormant void jl_odst_renew
    (sleep_until 
        (begin
            (ai_renew "unsc_jl_odsts")
            (ai_renew "unsc_jl_odsts1")
            false
        )
        (* 30 10)
    )
)

(script dormant void ready_waypoint
    (sleep g_waypoint_timeout)
    (if (not b_jetpack_low_started)
        (f_blip_flag "nav_ready_10" blip_default)
    )
    (sleep_until (>= objcon_ready 60) 5)
    (f_unblip_flag "nav_ready_10")
)

(script static void m50_terminals
    (if (or (difficulty_is_normal) (difficulty_is_heroic) (difficulty_is_legendary))
        (object_create "terminal_m50")
    )
    (if (difficulty_is_legendary)
        (object_create "terminal_m50_15")
    )
)

(script dormant void jetpack_low_objective_control
    (if debug
        (print "encounter start: jetpack low")
    )
    (set b_jetpack_low_started true)
    (game_save_no_timeout)
    (set objcon_jetpack_low 50)
    (wake jetpack_spawn_control)
    (wake jetpack_elevator_marker)
    (wake jetpack_low_waypoint)
    (wake jetpack_low_music_control)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_060") 1)
    (if debug
        (print "objective control: jetpack 060")
    )
    (set objcon_jetpack_low 60)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_070") 1)
    (if debug
        (print "objective control: jetpack 070")
    )
    (set objcon_jetpack_low 70)
    (game_save)
    (mus_stop mus_09)
    (mus_start mus_04)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_080") 1)
    (if debug
        (print "objective control: jetpack 080")
    )
    (set objcon_jetpack_low 80)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_090") 1)
    (if debug
        (print "objective control: jetpack 090")
    )
    (set objcon_jetpack_low 90)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_100") 1)
    (if debug
        (print "objective control: jetpack 100")
    )
    (set objcon_jetpack_low 100)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_110") 1)
    (if debug
        (print "objective control: jetpack 110")
    )
    (set objcon_jetpack_low 110)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_120") 1)
    (if debug
        (print "objective control: jetpack 120")
    )
    (set objcon_jetpack_low 120)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_130") 1)
    (if debug
        (print "objective control: jetpack 130")
    )
    (set objcon_jetpack_low 130)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_140") 1)
    (if debug
        (print "objective control: jetpack 140")
    )
    (set objcon_jetpack_low 140)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_150") 1)
    (if debug
        (print "objective control: jetpack 150")
    )
    (set objcon_jetpack_low 150)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_160") 1)
    (if debug
        (print "objective control: jetpack 160")
    )
    (set objcon_jetpack_low 160)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_low_170") 1)
    (if debug
        (print "objective control: jetpack 170")
    )
    (set objcon_jetpack_low 170)
    (game_save)
    (sleep_until b_jetpack_high_started)
    (if debug
        (print "cleaning up jetpack low...")
    )
    (ai_disposable "gr_cov_jl" true)
    (ai_set_objective "jl_unsc_inf1c" "obj_jetpack_high_unsc")
)

(script dormant void jetpack_spawn_control
    (ai_place "gr_cov_jl_initial")
    (sleep 1)
    (sleep_until (>= objcon_jetpack_low 110))
    (ai_place "gr_cov_jl_a")
    (if (game_is_cooperative)
        (set g_ready_odst_desired (- g_ready_odst_desired 2))
    )
    (set g_ready_odst_current (ai_task_count "obj_jetpack_low_unsc/gate_odsts"))
    (if (< g_ready_odst_current g_ready_odst_desired)
        (ai_place "jl_odst_inf0" (- g_ready_odst_desired g_ready_odst_current))
    )
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad player0 "jl_odst_inf0")
    )
    (sleep_until (>= objcon_jetpack_low 140))
    (ai_place "gr_unsc_jl_lobby")
    (ai_cannot_die "gr_unsc_jl_lobby" true)
    (sleep_until b_jetpack_high_started)
    (ai_cannot_die "gr_unsc_jl_lobby" false)
    (ai_disposable "unsc_jl_odsts" true)
    (ai_disposable "gr_unsc_jl" true)
)

(script dormant void jetpack_elevator_marker
    (sleep_until (>= objcon_jetpack_low 160))
    (md_jp_take_elevator)
    (mus_stop mus_04)
)

(script dormant void jetpack_low_waypoint
    (sleep g_waypoint_timeout)
    (if (not b_jetpack_high_started)
        (f_blip_flag "nav_jetpack_low_10" blip_default)
    )
    (sleep_until (>= objcon_jetpack_low 150) 5)
    (f_unblip_flag "nav_jetpack_low_10")
    (f_blip_flag "nav_jetpack_low_exit" blip_default)
    (sleep_until b_jetpack_high_started 5)
    (f_unblip_flag "nav_jetpack_low_exit")
)

(script dormant void jetpack_low_music_control
    (sleep_until (or (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 2) (>= objcon_jetpack_low 100)))
    (mus_alt mus_04)
    (sleep_until (>= objcon_jetpack_low 120))
    (mus_start mus_05)
)

(script command_script void cs_jl_a_b0_helper
    (if debug
        (print "helping the odsts across the chasm")
    )
    (cs_enable_pathfinding_failsafe true)
    (cs_go_to "pts_jetpack_infantry/jl_a_b0_helper_start")
    (sleep 90)
    (cs_go_to "pts_jetpack_infantry/jl_a_b0_helper_dest")
)

(script dormant void jetpack_high_objective_control
    (if debug
        (print "encounter start: jetpack high")
    )
    (set b_jetpack_high_started true)
    (game_save)
    (thespian_folder_activate "th_jetpack")
    (soft_ceiling_enable "low_jetpack_blocker" false)
    (set objcon_jetpack_high 0)
    (teleport_players_not_in_volume "tv_jetpack_high_teleport" "spawn_jetpack_high_player0" "spawn_jetpack_high_player1" "spawn_jetpack_high_player2" "spawn_jetpack_high_player3")
    (device_one_sided_set "dm_jh_lobby0" true)
    (device_set_position "dm_jh_lobby0" 0)
    (ai_erase "gr_cov_jl")
    (ai_erase "gr_unsc_ready")
    (ai_erase "gr_unsc_odst")
    (ai_erase "gr_unsc_jl_initial")
    (ai_disposable "gr_unsc_jl" true)
    (objects_manage_4b)
    (garbage_collect_now)
    (wake jh_spawn_control)
    (wake jetpack_high_waypoint)
    (wake md_jp_second_floor)
    (wake md_jp_theres_the_pad)
    (wake jh_senses)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_001") 1)
    (if debug
        (print "objective control: jetpack 001")
    )
    (set objcon_jetpack_high 1)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_005") 1)
    (if debug
        (print "objective control: jetpack 005")
    )
    (set objcon_jetpack_high 5)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_006") 1)
    (if debug
        (print "objective control: jetpack 006")
    )
    (set objcon_jetpack_high 6)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_007") 1)
    (if debug
        (print "objective control: jetpack 007")
    )
    (set objcon_jetpack_high 7)
    (game_save)
    (mus_stop mus_05)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_010") 1)
    (if debug
        (print "objective control: jetpack 010")
    )
    (set objcon_jetpack_high 10)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_020") 1)
    (if debug
        (print "objective control: jetpack 020")
    )
    (set objcon_jetpack_high 20)
    (game_save_no_timeout)
    (sleep_until (volume_test_players "tv_objcon_jetpack_high_030") 1)
    (if debug
        (print "objective control: jetpack 030")
    )
    (set objcon_jetpack_high 30)
    (game_save)
    (if (= s_special_elite 2)
        (begin
            (ai_place "special_elite2")
            (sleep 1)
            (ai_disregard (ai_actors "special_elite2") true)
        )
    )
    (sleep_until (or (volume_test_players "tv_objcon_jetpack_high_040a") (volume_test_players "tv_objcon_jetpack_high_040b") (volume_test_players "tv_objcon_jetpack_high_050") (volume_test_players "tv_objcon_jetpack_high_060") (volume_test_players "tv_jetpack_high_stairs_top")) 1)
    (if debug
        (print "objective control: jetpack 040")
    )
    (set objcon_jetpack_high 40)
    (game_save)
    (sleep_until (or (volume_test_players "tv_objcon_jetpack_high_050") (volume_test_players "tv_objcon_jetpack_high_060") (volume_test_players "tv_jetpack_high_stairs_top")) 1)
    (if debug
        (print "objective control: jetpack 050")
    )
    (set objcon_jetpack_high 50)
    (game_save)
    (sleep_until (or (volume_test_players "tv_objcon_jetpack_high_060") (volume_test_players "tv_jetpack_high_stairs_top")) 1)
    (if debug
        (print "objective control: jetpack 060")
    )
    (set objcon_jetpack_high 60)
    (game_save)
)

(script dormant void jh_spawn_control
    (f_ai_place_vehicle_deathless "cov_jetpack_high_ph0")
    (ai_place "jh_cov_tree_snipers_inf0")
    (ai_place "jh_cov_tree_inf0")
    (sleep 1)
    (ai_cannot_die "jh_cov_tree_snipers_inf0" true)
    (ai_cannot_die "jh_cov_tree_inf0" true)
    (ai_place "jh_unsc_odst_balcony_inf0/sp_jh")
    (ai_place "jh_unsc_odst_tree_inf0/sp_jh")
    (ai_place "jh_unsc_mars_tree_inf0/sf_jh")
    (ai_place "jh_civilians0/sp_jh0")
    (ai_place "jh_civilians0/sp_jh1")
    (ai_place "jh_civilians0/sp_jh2")
    (ai_place "jh_civilians0/sp_jh3")
    (if (not (game_is_cooperative))
        (begin
            (ai_place "jh_unsc_mars_balcony_inf0/sf_jh")
            (ai_place "jh_civilians0/sp_jh4")
            (ai_place "jh_civilians0/sp_jh5")
        )
    )
    (ai_force_low_lod "gr_civilian")
    (ai_lod_full_detail_actors 15)
    (sleep 1)
    (ai_cannot_die "gr_jh_unsc" true)
    (ai_cannot_die "gr_jh_odst" true)
    (ai_cannot_die "gr_jh_civilian" true)
    (sleep_until (>= objcon_jetpack_high 20))
    (set b_place_jh_hill true)
    (ai_place "jh_cov_hill_landing_inf0")
    (ai_place "jh_cov_hill_landing_inf1c")
    (ai_place "jh_cov_hill_landing_inf1b")
    (ai_place "jh_cov_hill_landing_inf1a")
    (ai_place "jh_cov_hill_snipers_inf0")
    (ai_place "jh_cov_hill_stairs_inf0")
    (ai_place "jh_cov_hill_stairs_inf1")
    (ai_place "jh_cov_hill_concussion_inf0")
    (sleep_until (>= objcon_jetpack_high 40))
    (if (game_is_cooperative)
        (begin
            (set g_jh_civ_desired (- g_jh_civ_desired 2))
            (set g_jh_odst_desired (- g_jh_odst_desired 2))
        )
    )
    (set g_jh_civ_current (ai_living_count "gr_jh_civilian"))
    (if (< g_jh_civ_current g_jh_civ_desired)
        (ai_place "jh_civilians1" (- g_jh_civ_desired g_jh_civ_current))
    )
    (set g_jh_odst_current (ai_task_count "obj_jetpack_high_unsc/gate_odst"))
    (if (< g_jh_odst_current g_jh_odst_desired)
        (ai_place "jh_odst_inf0" (- g_jh_odst_desired g_jh_odst_current))
    )
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad player0 "jh_odst_inf0")
    )
    (ai_force_low_lod "gr_civilian")
)

(script static void jetpack_high_migrate_tree_odst
    (if debug
        (print "migrating tree odst to balcony odst")
    )
    (ai_migrate "jh_unsc_odst_tree_inf0" "jh_unsc_odst_balcony_inf0")
)

(script dormant void jh_senses
    (sleep_until (>= objcon_jetpack_high 7) 5)
    (ai_cannot_die "jh_cov_tree_snipers_inf0" false)
    (ai_cannot_die "jh_cov_tree_inf0" false)
    (ai_cannot_die "jh_cov_hill_landing_inf0" false)
    (ai_cannot_die "jh_cov_hill_landing_inf1c" false)
    (ai_cannot_die "jh_cov_hill_landing_inf1b" false)
    (ai_cannot_die "jh_cov_hill_landing_inf1a" false)
    (ai_cannot_die "jh_cov_hill_snipers_inf0" false)
    (ai_cannot_die "jh_cov_hill_stairs_inf0" false)
    (ai_cannot_die "jh_cov_hill_stairs_inf1" false)
    (ai_cannot_die "jh_cov_hill_concussion_inf0" false)
    (sleep_until b_jh_phantom0_exit)
    (ai_cannot_die "gr_jh_unsc" false)
    (ai_cannot_die "gr_jh_odst" false)
    (ai_cannot_die "gr_jh_civilian" false)
)

(script command_script void cs_jetpack_high_phantom0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed_instantaneous 1)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "left" "jh_cov_tree_inf1" none none none)
    (cs_fly_by "pts_jetpack_high_ph0/entry3")
    (cs_fly_by "pts_jetpack_high_ph0/entry2")
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_jetpack_high_ph0/land" "pts_jetpack_high_ph0/land_facing" 0.25)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "left")
    (cs_fly_to_and_face "pts_jetpack_high_ph0/entry1" "pts_jetpack_high_ph0/hover_facing" 0.25)
    (sleep_until (>= objcon_jetpack_high 7) 1)
    (cs_fly_to_and_face "pts_jetpack_high_ph0/exit0" "pts_jetpack_high_ph0/exit1" 0.25)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_jetpack_high_ph0/exit1")
    (set b_jh_phantom0_exit true)
    (cs_fly_by "pts_jetpack_high_ph0/exit2")
    (cs_fly_by "pts_jetpack_high_ph0/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script dormant void jh_waypoint_timeout
    (sleep g_waypoint_timeout)
    (set b_jh_timeout true)
)

(script dormant void jh_odst_renew
    (sleep_until 
        (begin
            (ai_renew "jh_unsc_odst_balcony_inf0")
            (ai_renew "jh_unsc_odst_tree_inf0")
            (ai_renew "jh_odst_inf0")
            false
        )
        (* 30 10)
    )
)

(script dormant void jetpack_high_waypoint
    (wake jh_waypoint_timeout)
    (if (not b_trophy_started)
        (f_blip_flag "nav_jetpack_high_5" blip_default)
    )
    (sleep_until (>= objcon_jetpack_high 5) 5)
    (f_unblip_flag "nav_jetpack_high_5")
    (wake hud_flash_evac)
    (sleep_until (>= objcon_jetpack_high 6) 5 (* 30 30))
    (f_blip_flag "nav_jetpack_high_6" blip_default)
    (sleep_until (>= objcon_jetpack_high 6) 5)
    (f_unblip_flag "nav_jetpack_high_6")
    (sleep_until (or b_jh_timeout (volume_test_players "tv_objcon_jetpack_high_050") (<= (ai_task_count "obj_jetpack_high_cov/gate_main") 1)))
    (f_blip_flag "nav_jetpack_high_exit" blip_default)
    (sleep_until b_trophy_started 5)
    (f_unblip_flag "nav_jetpack_high_exit")
)

(script dormant void trophy_objective_control
    (if debug
        (print "encounter start: trophy")
    )
    (set b_trophy_started true)
    (game_save)
    (ai_disposable "gr_cov_jh" true)
    (garbage_collect_now)
    (wake trophy_spawn)
    (wake md_jp_clear_the_pad)
    (wake trophy_waypoint)
    (wake trophy_doors)
    (set objcon_trophy 0)
    (sleep_until (or (volume_test_players "tv_objcon_trophy_005") (volume_test_players "tv_pad_entrance_mid") (volume_test_players "tv_pad_entrance_right") (volume_test_players "tv_pad_entrance_left") (volume_test_players "tv_objcon_trophy_030") (volume_test_players "tv_objcon_trophy_040")) 1)
    (if debug
        (print "objective control: jetpack 005")
    )
    (set objcon_trophy 5)
    (game_save)
    (sleep_until (or (volume_test_players "tv_pad_entrance_mid") (volume_test_players "tv_pad_entrance_right") (volume_test_players "tv_pad_entrance_left") (volume_test_players "tv_objcon_trophy_030") (volume_test_players "tv_objcon_trophy_040")) 1)
    (if debug
        (print "objective control: jetpack 010")
    )
    (set objcon_trophy 10)
    (game_save)
    (sleep_until (or (volume_test_players "tv_pad_interior_mid") (volume_test_players "tv_pad_interior_right") (volume_test_players "tv_pad_interior_left") (volume_test_players "tv_objcon_trophy_030") (volume_test_players "tv_objcon_trophy_040")) 1)
    (if debug
        (print "objective control: jetpack 020")
    )
    (set objcon_trophy 20)
    (game_save)
    (sleep_until (or (volume_test_players "tv_objcon_trophy_030") (volume_test_players "tv_objcon_trophy_040")) 1)
    (if debug
        (print "objective control: jetpack 030")
    )
    (set objcon_trophy 30)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_trophy_040") 1)
    (if debug
        (print "objective control: jetpack 040")
    )
    (set objcon_trophy 40)
    (game_save)
)

(script dormant void trophy_spawn
    (ai_lod_full_detail_actors 15)
    (f_ai_place_vehicle_deathless "cov_trophy_ph1")
    (f_ai_place_vehicle_deathless_no_emp "trohpy_dogfight_unsc0")
    (if debug
        (print "loading gunner_right")
    )
    (ai_place "trohpy_dogfight_unsc1/gunner")
    (sleep 10)
    (ai_cannot_die "trohpy_dogfight_unsc1/gunner" true)
    (ai_force_low_lod "trohpy_dogfight_unsc0")
    (vehicle_load_magic (ai_vehicle_get "trohpy_dogfight_unsc0/pilot") 42 (ai_get_object "trohpy_dogfight_unsc1/gunner"))
    (ai_place "trophy_cov_inf0")
    (ai_place "trophy_cov_inf1")
    (ai_place "trophy_cov_inf3")
    (ai_place "trophy_cov_snipers_inf0")
    (ai_place "trophy_cov_snipers_inf1")
    (ai_migrate "gr_jh_odst" "gr_unsc_odst")
    (ai_migrate "gr_jh_odst_reinforce" "gr_unsc_odst")
    (ai_set_objective "gr_jh_unsc" "obj_trophy_unsc")
    (ai_set_objective "gr_jh_odst" "obj_trophy_unsc")
    (ai_migrate "jh_civilians0" "trophy_civilians0")
    (ai_migrate "jh_civilians1" "trophy_civilians0")
    (sleep 1)
    (ai_set_objective "trophy_civilians0" "obj_trophy_unsc")
    (sleep_until (>= objcon_trophy 5))
    (ai_place "jh_cov_pad_inf0")
    (ai_place "trophy_cov_final")
    (sleep_until (>= objcon_trophy 20))
    (f_ai_place_vehicle_deathless "cov_trophy_ph0")
    (sleep_until (<= (ai_living_count "cov_trophy_ph0") 4) 5)
    (sleep_until (f_task_is_empty "obj_trophy_cov/gate_main"))
    (set g_trophy_civ_current (ai_living_count "gr_trophy_civilians"))
    (if (< g_trophy_civ_current g_trophy_civ_desired)
        (ai_place "trophy_civilians1" (- g_trophy_civ_desired g_trophy_civ_current))
    )
    (set g_trophy_odst_current (ai_task_count "obj_trophy_unsc/gate_odst"))
    (if (< g_trophy_odst_current g_trophy_odst_desired)
        (ai_place "trophy_odst_inf0" (- g_trophy_odst_desired g_trophy_odst_current))
    )
    (ai_force_low_lod "gr_civilian")
    (if (not (game_is_cooperative))
        (ai_player_add_fireteam_squad player0 "trophy_odst_inf0")
    )
    (set b_jetpack_high_complete true)
    (f_unblip_flag "objective_traxus_pad")
    (f_unblip_ai "jetpack_high_odsts")
    (unit_set_stance "gr_civilian" "")
    (sleep_until b_starport_started)
    (if debug
        (print "cleaning up jetpack high...")
    )
    (ai_disposable "gr_cov_jh" true)
)

(script command_script void cs_trophy_phantom0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed_instantaneous 1)
    (f_load_phantom (ai_vehicle_get ai_current_actor) "left" "trophy_cov_inf2" "jh_cov_pad_inf1" none none)
    (cs_fly_by "pts_trophy_ph0/entry4" 5)
    (cs_fly_by "pts_trophy_ph0/entry3" 5)
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "pts_trophy_ph0/entry2" "pts_trophy_ph0/land" 0.35)
    (sleep_until (or (<= (ai_living_count "obj_trophy_cov") 4) (>= objcon_trophy 40)))
    (cs_fly_by "pts_trophy_ph0/entry2" 5)
    (cs_fly_by "pts_trophy_ph0/entry1" 5)
    (cs_vehicle_speed 0.35)
    (cs_fly_to_and_face "pts_trophy_ph0/land" "pts_trophy_ph0/land_facing" 0.35)
    (sleep 120)
    (f_unload_phantom (ai_vehicle_get ai_current_actor) "left")
    (set b_trophy_counterattack true)
    (cs_fly_to_and_face "pts_trophy_ph0/hover" "pts_trophy_ph0/hover_facing")
    (sleep 90)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_trophy_ph0/exit0")
    (cs_fly_by "pts_trophy_ph0/exit1")
    (cs_fly_by "pts_trophy_ph0/exit2")
    (cs_fly_by "pts_trophy_ph0/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_trophy_phantom1
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_ignore_obstacles true)
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed_instantaneous 1)
    (ai_place "trophy_cov_shade0")
    (ai_place "trophy_cov_shade1")
    (sleep 1)
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "cov_trophy_ph1/pilot") 37 (ai_vehicle_get_from_starting_location "trophy_cov_shade0/gunner"))
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "cov_trophy_ph1/pilot") 38 (ai_vehicle_get_from_starting_location "trophy_cov_shade1/gunner"))
    (cs_fly_by "pts_trophy_ph1/entry3")
    (cs_fly_by "pts_trophy_ph1/entry2")
    (cs_fly_by "pts_trophy_ph1/entry1")
    (cs_vehicle_speed 0.35)
    (cs_fly_to_and_face "pts_trophy_ph1/land0" "pts_trophy_ph1/land0_facing" 0.25)
    (sleep (* 30 2))
    (vehicle_unload (ai_vehicle_get_from_starting_location "cov_trophy_ph1/pilot") 37)
    (cs_fly_to_and_face "pts_trophy_ph1/land1" "pts_trophy_ph1/land1_facing" 0.25)
    (sleep (* 30 2))
    (vehicle_unload (ai_vehicle_get_from_starting_location "cov_trophy_ph1/pilot") 38)
    (wake shade_kill)
    (cs_fly_to_and_face "pts_trophy_ph1/hover" "pts_trophy_ph1/hover_facing" 0.25)
    (sleep (* 30 1))
    (objects_attach "sc_trophy_shade0" "marker01" (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner") "")
    (objects_attach "sc_trophy_shade1" "marker01" (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner") "")
    (sleep 10)
    (objects_detach "sc_trophy_shade0" (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner"))
    (objects_detach "sc_trophy_shade1" (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner"))
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_trophy_ph1/exit1")
    (cs_fly_by "pts_trophy_ph1/exit2")
    (cs_fly_by "pts_trophy_ph1/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_trohpy_dogfight_unsc0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_fly_by "pts_trophy_dogfight/entry0" 2)
    (cs_fly_by "pts_trophy_dogfight/entry1" 2)
    (cs_fly_to "pts_trophy_dogfight/hover0" 10)
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "pts_trophy_dogfight/hover0" "pts_trophy_dogfight/hover0_facing" 0.5)
    (sleep (* 30 4))
    (cs_fly_to_and_face "pts_trophy_dogfight/hover1" "pts_trophy_dogfight/hover0_facing" 0.5)
    (sleep (* 30 4))
    (cs_fly_to_and_face "pts_trophy_dogfight/hover2" "pts_trophy_dogfight/hover0_facing" 0.5)
    (sleep (* 30 4))
    (cs_fly_to_and_face "pts_trophy_dogfight/hover0" "pts_trophy_dogfight/hover0_facing" 0.5)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "pts_trophy_dogfight/exit0")
    (cs_fly_by "pts_trophy_dogfight/erase0")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script static boolean jetpack_high_rush_pad
    (or (volume_test_players "tv_pad_interior_left") (volume_test_players "tv_pad_interior_mid") (volume_test_players "tv_pad_interior_right"))
)

(script dormant void trophy_doors
    (device_set_position "dm_trophy_door1" 1)
    (sleep_until (= (device_get_position "dm_trophy_door1") 1) 1)
    (device_operates_automatically_set "dm_trophy_door1" false)
    (device_closes_automatically_set "dm_trophy_door1" false)
    (sleep_until b_trophy_complete)
    (device_operates_automatically_set "dm_trophy_door1" true)
    (device_closes_automatically_set "dm_trophy_door1" true)
)

(script dormant void shade_kill
    (sleep_until (or (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade0/gunner") 44)) (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade1/gunner") 44))))
    (if (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade0/gunner") 44))
        (unit_kill (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner"))
    )
    (if (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade1/gunner") 44))
        (unit_kill (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner"))
    )
    (sleep_until (and (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade0/gunner") 44)) (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade1/gunner") 44))))
    (if (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade0/gunner") 44))
        (unit_kill (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner"))
    )
    (if (not (vehicle_test_seat (ai_vehicle_get "trophy_cov_shade1/gunner") 44))
        (unit_kill (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner"))
    )
)

(script dormant void trophy_waypoint
    (sleep g_waypoint_timeout)
    (if (not b_trophy_complete)
        (begin
            (if (>= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner")) 0)
                (f_blip_object (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner") blip_neutralize)
            )
            (if (>= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner")) 0)
                (f_blip_object (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner") blip_neutralize)
            )
        )
    )
    (sleep_until (or (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner")) 0) (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner")) 0)))
    (if (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner")) 0)
        (f_unblip_object (ai_get_object "trophy_cov_shade0"))
    )
    (if (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner")) 0)
        (f_unblip_object (ai_get_object "trophy_cov_shade1"))
    )
    (sleep_until (and (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner")) 0) (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner")) 0)))
    (if (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade0/gunner")) 0)
        (f_unblip_object (ai_get_object "trophy_cov_shade0"))
    )
    (if (<= (object_get_health (ai_vehicle_get_from_spawn_point "trophy_cov_shade1/gunner")) 0)
        (f_unblip_object (ai_get_object "trophy_cov_shade1"))
    )
)

(script dormant void ride_objective_control
    (if debug
        (print "encounter start: ride")
    )
    (set b_trophy_complete true)
    (game_save)
    (set objcon_ride 0)
    (game_insertion_point_unlock 2)
    (sleep_forever f_jetpack_fx_ambient)
    (wake ride_progression)
    (sleep_until (volume_test_players "tv_ride_objcon_010") 1)
    (if debug
        (print "objective control: ride 010")
    )
    (set objcon_ride 10)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_070") 1)
    (if debug
        (print "objective control: ride 070")
    )
    (set objcon_ride 70)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_080") 1)
    (if debug
        (print "objective control: ride 080")
    )
    (set objcon_ride 80)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_085") 1)
    (if debug
        (print "objective control: ride 085")
    )
    (set objcon_ride 85)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_090") 1)
    (if debug
        (print "objective control: ride 090")
    )
    (set objcon_ride 90)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_095") 1)
    (if debug
        (print "objective control: ride 095")
    )
    (set objcon_ride 95)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_100") 1)
    (if debug
        (print "objective control: ride 100")
    )
    (set objcon_ride 100)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_105") 1)
    (if debug
        (print "objective control: ride 105")
    )
    (set objcon_ride 105)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_110") 1)
    (if debug
        (print "objective control: ride 110")
    )
    (set objcon_ride 110)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_115") 1)
    (if debug
        (print "objective control: ride 115")
    )
    (set objcon_ride 115)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_120") 1)
    (if debug
        (print "objective control: ride 120")
    )
    (set objcon_ride 120)
    (game_save)
    (sleep_until (volume_test_players "tv_ride_objcon_130") 1)
    (if debug
        (print "objective control: ride 130")
    )
    (set objcon_ride 130)
    (game_save)
)

(script static void ride_load_passengers
    (ai_vehicle_reserve_seat v_ride_falcon 48 true)
    (ai_vehicle_reserve_seat v_ride_falcon 42 true)
    (ai_vehicle_reserve_seat v_ride_falcon 50 true)
    (ai_vehicle_reserve_seat v_ride_falcon 51 true)
    (ai_vehicle_reserve_seat v_ride_falcon0 48 true)
    (ai_vehicle_reserve_seat v_ride_falcon0 42 true)
    (ai_vehicle_reserve_seat v_ride_falcon0 50 true)
    (ai_vehicle_reserve_seat v_ride_falcon 51 true)
    (vehicle_set_player_interaction v_ride_falcon 52 false false)
    (vehicle_set_player_interaction v_ride_falcon 53 false false)
    (vehicle_set_player_interaction v_ride_falcon 54 false false)
    (vehicle_set_player_interaction v_ride_falcon0 52 false false)
    (vehicle_set_player_interaction v_ride_falcon0 53 false false)
    (vehicle_set_player_interaction v_ride_falcon0 54 false false)
    (vehicle_set_player_interaction v_ride_falcon 48 false false)
    (vehicle_set_player_interaction v_ride_falcon 42 false false)
    (vehicle_set_player_interaction v_ride_falcon0 48 false false)
    (vehicle_set_player_interaction v_ride_falcon0 42 false false)
    (vehicle_set_player_interaction v_ride_falcon 51 false false)
    (vehicle_set_player_interaction v_ride_falcon 50 false false)
    (vehicle_set_player_interaction v_ride_falcon0 51 false false)
    (vehicle_set_player_interaction v_ride_falcon0 50 false false)
    (if (not (game_is_cooperative))
        (begin
            (if debug
                (print "loading passenger_right_1")
            )
            (ai_place "ride_passengers/passenger0")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon 51 (ai_get_object "ride_passengers/passenger0"))
            (if debug
                (print "loading passenger_left_1")
            )
            (ai_place "ride_passengers/passenger1")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon 50 (ai_get_object "ride_passengers/passenger1"))
        )
    )
    (if (not (game_is_cooperative))
        (begin
            (if debug
                (print "loading passenger_right_1")
            )
            (ai_place "ride_passengers0/passenger0")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon0 51 (ai_get_object "ride_passengers0/passenger0"))
            (if debug
                (print "loading passenger_left_1")
            )
            (ai_place "ride_passengers0/passenger1")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon0 50 (ai_get_object "ride_passengers0/passenger1"))
        )
    )
    (if (<= (game_coop_player_count) 3)
        (begin
            (if debug
                (print "loading gunner_right")
            )
            (ai_place "ride_passengers0/passenger2")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon0 42 (ai_get_object "ride_passengers0/passenger2"))
            (vehicle_set_player_interaction v_ride_falcon0 42 false false)
        )
    )
    (if (<= (game_coop_player_count) 2)
        (begin
            (if debug
                (print "loading gunner_right")
            )
            (ai_place "ride_passengers/passenger2")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon 42 (ai_get_object "ride_passengers/passenger2"))
            (vehicle_set_player_interaction v_ride_falcon 42 false false)
        )
    )
    (if (<= (game_coop_player_count) 1)
        (begin
            (if debug
                (print "loading gunner_left")
            )
            (ai_place "ride_passengers/passenger3")
            (sleep 10)
            (vehicle_load_magic v_ride_falcon0 48 (ai_get_object "ride_passengers/passenger3"))
            (vehicle_set_player_interaction v_ride_falcon0 48 false false)
        )
    )
    (ai_force_low_lod "ride_passengers")
    (ai_force_low_lod "ride_passengers0")
)

(script command_script void cs_ride_vehicle_enter
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.8)
    (cs_attach_to_spline "spline_falcon_ride_enter")
    (cs_fly_by "falcon_enter/entry1")
    (cs_vehicle_speed 0.5)
    (cs_fly_by "falcon_enter/entry0")
    (cs_vehicle_speed 0.2)
    (cs_fly_to "falcon_enter/hover")
    (cs_attach_to_spline "")
    (cs_fly_to_and_face "falcon_enter/hover" "falcon_enter/land_facing" 1)
    (sleep 30)
    (cs_vehicle_speed 0.1)
    (cs_fly_to_and_face "falcon_enter/land" "falcon_enter/land_facing" 0.5)
    (set b_ride_falcon_landed true)
)

(script command_script void cs_ride_vehicle0_enter
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (sleep 1)
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.8)
    (cs_attach_to_spline "spline_falcon_ride0_enter")
    (cs_fly_by "falcon0_enter/entry1")
    (cs_vehicle_speed 0.5)
    (cs_fly_by "falcon0_enter/entry0")
    (cs_vehicle_speed 0.2)
    (cs_fly_to "falcon0_enter/hover")
    (cs_attach_to_spline "")
    (cs_fly_to_and_face "falcon0_enter/hover" "falcon0_enter/land_facing" 1)
    (sleep 30)
    (cs_vehicle_speed 0.1)
    (cs_fly_to_and_face "falcon0_enter/land" "falcon0_enter/land_facing" 0.5)
    (set b_ride_falcon0_landed true)
)

(script command_script void cs_ride_vehicle_route
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "falcon_enter/hover" "falcon_enter/land_facing" 1)
    (sleep (* 30 1))
    (cs_fly_to_and_face "falcon_ride/evac" "falcon_ride/evac_facing" 1)
    (sleep (* 30 2))
    (set b_falcon_evac_hover true)
    (sleep_until b_falcon_goto_load_hover)
    (cs_attach_to_spline "spline_falcon_ride")
    (cs_vehicle_speed 0.6)
    (cs_fly_by "falcon_ride/rooftop0_start" 1)
    (set b_rooftop0_start true)
    (cs_vehicle_speed 0.4)
    (cs_fly_by "falcon_ride/rooftop0_finish" 1)
    (set b_rooftop0_finish true)
    (cs_vehicle_speed 0.8)
    (cs_fly_to "falcon_ride/load_zone" 5)
    (cs_vehicle_speed 0.3)
    (set b_falcon_load_hover true)
    (cs_fly_to_and_face "falcon_ride/load_hover" "falcon_ride/load_zone_facing" 1)
    (sleep_until b_falcon_goto_lz_hover)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "falcon_ride/rooftop2_start" 5)
    (set b_rooftop2_start true)
    (cs_fly_by "falcon_ride/transport" 5)
    (set b_falcon_transport true)
    (cs_vehicle_speed 0.9)
    (cs_fly_by "falcon_ride/park" 5)
    (set b_falcon_park true)
    (cs_fly_by "falcon_ride/lz_setup" 5)
    (set b_falcon_lz_setup true)
    (cs_fly_to "falcon_ride/park_detach" 5)
    (cs_attach_to_spline "")
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "falcon_ride/lz_hover" "falcon_ride/lz_hover_facing" 0.5)
    (set b_falcon_lz_hover true)
    (sleep_until b_starport_monologue)
)

(script command_script void cs_ride_vehicle0_route
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "falcon0_enter/hover" "falcon0_enter/land_facing" 1)
    (sleep (* 30 1))
    (cs_fly_to_and_face "falcon0_ride/evac" "falcon0_ride/evac_facing" 1)
    (sleep (* 30 2))
    (set b_falcon0_evac_hover true)
    (sleep_until b_falcon0_goto_load_hover)
    (cs_attach_to_spline "spline_falcon0_ride")
    (cs_vehicle_speed 0.6)
    (cs_fly_by "falcon0_ride/rooftop0_start" 1)
    (set b_rooftop0_start true)
    (cs_vehicle_speed 0.4)
    (cs_fly_by "falcon0_ride/rooftop0_finish" 1)
    (set b_rooftop0_finish true)
    (cs_vehicle_speed 0.8)
    (cs_fly_to "falcon0_ride/load_zone" 5)
    (cs_vehicle_speed 0.3)
    (set b_falcon0_load_hover true)
    (cs_fly_to_and_face "falcon0_ride/load_hover" "falcon0_ride/load_zone_facing" 1)
    (sleep_until b_falcon0_goto_lz_hover)
    (cs_vehicle_speed 0.7)
    (cs_fly_by "falcon0_ride/rooftop2_start" 5)
    (set b_rooftop2_start true)
    (cs_fly_by "falcon0_ride/transport" 5)
    (set b_falcon0_transport true)
    (cs_vehicle_speed 0.9)
    (cs_fly_by "falcon0_ride/park" 5)
    (set b_falcon0_park true)
    (cs_fly_by "falcon0_ride/lz_setup" 5)
    (set b_falcon0_lz_setup true)
    (cs_fly_to "falcon0_ride/park_detach" 5)
    (cs_attach_to_spline "")
    (cs_vehicle_speed 0.3)
    (cs_fly_to_and_face "falcon0_ride/lz_hover" "falcon0_ride/lz_hover_facing" 0.5)
    (set b_falcon0_lz_hover true)
    (sleep_until b_starport_monologue)
)

(script command_script void cs_duvall_falcon
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.1)
    (cs_fly_to_and_face "falcon_ride/hover" "falcon_ride/hover_facing" 0.25)
    (cs_fly_to_and_face "falcon_ride/land" "falcon_ride/land_facing" 0.25)
    (if debug
        (print "unloading falcon...")
    )
    (vehicle_unload (ai_vehicle_get ai_current_actor) 55)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 56)
    (ai_vehicle_reserve v_ride_falcon true)
    (vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) 48 false false)
    (vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) 42 false false)
    (set b_falcon_unloaded true)
)

(script command_script void cs_duvall_falcon0
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.1)
    (cs_fly_to_and_face "falcon0_ride/hover" "falcon0_ride/hover_facing" 0.25)
    (cs_fly_to_and_face "falcon0_ride/land" "falcon0_ride/land_facing" 0.25)
    (if debug
        (print "unloading falcon0...")
    )
    (vehicle_unload (ai_vehicle_get ai_current_actor) 55)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 56)
    (ai_vehicle_reserve v_ride_falcon0 true)
    (vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) 48 false false)
    (vehicle_set_player_interaction (ai_vehicle_get ai_current_actor) 42 false false)
    (set b_falcon0_unloaded true)
)

(script dormant void allegiance_broken_ride
    (sleep_until 
        (begin
            (if (ai_allegiance_broken player human)
                (begin
                    (vehicle_unload (ai_vehicle_get_from_starting_location "ride_falcon/pilot") 56)
                    (vehicle_unload (ai_vehicle_get_from_starting_location "ride_falcon0/pilot") 56)
                    (unit_add_equipment player0 "profile_starting" true true)
                    (unit_add_equipment player1 "profile_starting" true true)
                    (unit_add_equipment player2 "profile_starting" true true)
                    (unit_add_equipment player3 "profile_starting" true true)
                    (sleep (* 30 3))
                    (unit_kill (unit (player0)))
                    (if (game_is_cooperative)
                        (begin
                            (unit_kill (unit (player1)))
                            (unit_kill (unit (player2)))
                            (unit_kill (unit (player3)))
                        )
                    )
                )
            )
            b_starport_started
        )
    )
)

(script dormant void ride_progression
    (sleep_until b_trophy_complete)
    (wake md_jetpack_complete)
    (f_ai_place_vehicle_deathless "traxus_evac_pelican0")
    (sleep (* 30 2))
    (f_ai_place_vehicle_deathless "traxus_evac_pelican2")
    (sleep (* 30 2))
    (f_ai_place_vehicle_deathless_no_emp "ride_falcon")
    (sleep (* 30 3))
    (f_ai_place_vehicle_deathless_no_emp "ride_falcon0")
    (sleep 1)
    (set v_ride_falcon (ai_vehicle_get "ride_falcon/pilot"))
    (set v_ride_falcon0 (ai_vehicle_get "ride_falcon0/pilot"))
    (sleep 1)
    (ride_load_passengers)
    (sleep_until b_ride_falcon_landed)
    (wake md_ride_start)
    (sleep_until (or b_ride_falcon_landed b_ride_falcon0_landed))
    (vehicle_set_player_interaction v_ride_falcon 48 true false)
    (vehicle_set_player_interaction v_ride_falcon 42 true false)
    (vehicle_set_player_interaction v_ride_falcon0 48 true false)
    (vehicle_set_player_interaction v_ride_falcon0 42 true false)
    (sleep_until (or (player_in_vehicle (ai_vehicle_get "ride_falcon/pilot")) (player_in_vehicle (ai_vehicle_get "ride_falcon0/pilot"))) 5)
    (set b_ride_player_in_falcon true)
    (if debug
        (print "player is in the falcon...")
    )
    (if (game_is_cooperative)
        (begin
            (sleep (* 30 5))
            (sleep_until 
                (begin
                    (if (= (unit_in_vehicle_type player0 20) false)
                        (begin
                            (if (!= (vehicle_test_seat v_ride_falcon 48) true)
                                (unit_enter_vehicle_immediate player0 v_ride_falcon "falcon_g_l")
                                (if (!= (vehicle_test_seat v_ride_falcon0 48) true)
                                    (unit_enter_vehicle_immediate player0 v_ride_falcon0 "falcon_g_l")
                                    (if (!= (vehicle_test_seat v_ride_falcon 42) true)
                                        (unit_enter_vehicle_immediate player0 v_ride_falcon "falcon_g_r")
                                        (if (!= (vehicle_test_seat v_ride_falcon0 42) true)
                                            (unit_enter_vehicle_immediate player0 v_ride_falcon0 "falcon_g_r")
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (if (= (unit_in_vehicle_type player1 20) false)
                        (begin
                            (if (!= (vehicle_test_seat v_ride_falcon 48) true)
                                (unit_enter_vehicle_immediate player1 v_ride_falcon "falcon_g_l")
                                (if (!= (vehicle_test_seat v_ride_falcon0 48) true)
                                    (unit_enter_vehicle_immediate player1 v_ride_falcon0 "falcon_g_l")
                                    (if (!= (vehicle_test_seat v_ride_falcon 42) true)
                                        (unit_enter_vehicle_immediate player1 v_ride_falcon "falcon_g_r")
                                        (if (!= (vehicle_test_seat v_ride_falcon0 42) true)
                                            (unit_enter_vehicle_immediate player1 v_ride_falcon0 "falcon_g_r")
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (if (= (unit_in_vehicle_type player2 20) false)
                        (begin
                            (if (!= (vehicle_test_seat v_ride_falcon 48) true)
                                (unit_enter_vehicle_immediate player2 v_ride_falcon "falcon_g_l")
                                (if (!= (vehicle_test_seat v_ride_falcon0 48) true)
                                    (unit_enter_vehicle_immediate player2 v_ride_falcon0 "falcon_g_l")
                                    (if (!= (vehicle_test_seat v_ride_falcon 42) true)
                                        (unit_enter_vehicle_immediate player2 v_ride_falcon "falcon_g_r")
                                        (if (!= (vehicle_test_seat v_ride_falcon0 42) true)
                                            (unit_enter_vehicle_immediate player2 v_ride_falcon0 "falcon_g_r")
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (if (= (unit_in_vehicle_type player3 20) false)
                        (begin
                            (if (!= (vehicle_test_seat v_ride_falcon 48) true)
                                (unit_enter_vehicle_immediate player3 v_ride_falcon "falcon_g_l")
                                (if (!= (vehicle_test_seat v_ride_falcon0 48) true)
                                    (unit_enter_vehicle_immediate player3 v_ride_falcon0 "falcon_g_l")
                                    (if (!= (vehicle_test_seat v_ride_falcon 42) true)
                                        (unit_enter_vehicle_immediate player3 v_ride_falcon "falcon_g_r")
                                        (if (!= (vehicle_test_seat v_ride_falcon0 42) true)
                                            (unit_enter_vehicle_immediate player3 v_ride_falcon0 "falcon_g_r")
                                        )
                                    )
                                )
                            )
                        )
                    )
                    (and (or (= (unit_in_vehicle_type player0 20) true) (not (player_is_in_game player0))) (or (= (unit_in_vehicle_type player1 20) true) (not (player_is_in_game player1))) (or (= (unit_in_vehicle_type player2 20) true) (not (player_is_in_game player2))) (or (= (unit_in_vehicle_type player3 20) true) (not (player_is_in_game player3))))
                )
            )
        )
    )
    (game_safe_to_respawn false)
    (set b_ride_started true)
    (f_unblip_object (ai_vehicle_get "ride_falcon/pilot"))
    (f_unblip_object (ai_vehicle_get "ride_falcon0/pilot"))
    (soft_ceiling_enable "rail_blocker_01" false)
    (kill_volume_disable "kill_soft_jetpack0")
    (kill_volume_disable "kill_soft_starport0")
    (kill_volume_disable "kill_soft_starport1")
    (wake allegiance_broken_ride)
    (nuke_all_covenant)
    (nuke_all_longswords)
    (thespian_folder_deactivate "th_jetpack")
    (garbage_collect_unsafe)
    (object_destroy_folder "dm_070")
    (object_destroy_folder "dc_070")
    (object_destroy_folder "eq_070")
    (object_destroy_folder "wp_070")
    (object_destroy_folder "sc_070")
    (object_destroy_folder "cr_070")
    (sleep (* 30 2))
    (cs_run_command_script "ride_falcon/pilot" cs_ride_vehicle_route)
    (mus_stop mus_10)
    (mus_start mus_07)
    (sleep (* 30 3))
    (cs_run_command_script "ride_falcon0/pilot" cs_ride_vehicle0_route)
    (wake ct_title_act3)
    (wake md_ride)
    (f_ai_place_vehicle_deathless "traxus_evac_pelican1")
    (sleep_until b_evac1_complete)
    (wake md_ride_chatter1)
    (sleep_until (and b_falcon_evac_hover b_falcon0_evac_hover))
    (cs_run_command_script "traxus_evac_pelican0/pilot" cs_terminal_pelican0_exit)
    (set b_falcon_goto_load_hover true)
    (set b_falcon0_goto_load_hover true)
    (sleep (* 30 1))
    (wake md_ride2)
    (if (= s_special_elite 1)
        (begin
            (ai_place "special_elite1")
            (sleep 1)
            (ai_disregard (ai_actors "special_elite1") true)
        )
    )
    (object_create_folder "cr_rooftop")
    (object_create_folder "sc_rooftop")
    (ai_place "ride_rooftop0_inf0")
    (ai_place "ride_rooftop0_inf1")
    (ai_place "ride_rooftop0_inf2")
    (ai_place "ride_rooftop0_inf3")
    (ai_place "ride_rooftop0_unsc0")
    (ai_place "ride_rooftop0_civ0")
    (ai_place "ride_rooftop0_civ1")
    (sleep 1)
    (ai_set_targeting_group "gr_rooftop0_cov" 1 false)
    (ai_set_targeting_group "gr_rooftop0_unsc" 1 false)
    (ai_set_targeting_group "gr_rooftop0_civilians" 1 false)
    (ai_set_targeting_group "ride_rooftop0_inf0" 1 true)
    (ai_set_targeting_group "ride_rooftop0_inf1" 1 true)
    (ai_force_low_lod "gr_civilian")
    (sleep_until b_banshee0_start)
    (wake ride_banshee_cleanup)
    (ai_place "ride_banshee0")
    (ai_place "ride_banshee00")
    (ai_place "ride_banshee000")
    (sleep 1)
    (ai_set_targeting_group "ride_banshee0" 2 false)
    (ai_set_targeting_group "ride_banshee00" 2 false)
    (ai_set_targeting_group "ride_banshee000" 2 false)
    (ai_set_targeting_group "traxus_evac_pelican0" 2 false)
    (ai_set_clump "ride_banshee0" 14)
    (ai_set_clump "ride_banshee00" 14)
    (ai_set_clump "ride_banshee000" 14)
    (ai_designer_clump_perception_range 500)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee0/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee0/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee00/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee00/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee000/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee000/spawn_points_0") g_falcon_vitality 0)
    (wake md_ride_chatter2)
    (cs_run_command_script "traxus_evac_pelican1/pilot" cs_terminal_pelican1_exit)
    (sleep_until b_rooftop0_start)
    (nuke_all_unsc)
    (flock_stop "fl_shared_banshee0")
    (flock_stop "fl_shared_falcon0")
    (flock_stop "fl_shared_banshee1")
    (flock_stop "fl_shared_falcon1")
    (flock_stop "fl_corvette_phantom1")
    (flock_create "fl_shared_banshee3")
    (flock_create "fl_shared_falcon3")
    (sleep_until b_rooftop0_finish)
    (ai_place "ride_banshee01")
    (ai_place "ride_banshee02")
    (ai_place "ride_banshee03")
    (sleep 1)
    (ai_set_clump "ride_banshee01" 15)
    (ai_set_clump "ride_banshee02" 15)
    (ai_set_clump "ride_banshee03" 15)
    (ai_designer_clump_perception_range 500)
    (ai_set_targeting_group "ride_banshee01" 1 true)
    (ai_set_targeting_group "ride_banshee02" 1 true)
    (ai_set_targeting_group "ride_banshee03" 1 true)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee01/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee01/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee02/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee02/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee03/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee03/spawn_points_0") g_falcon_vitality 0)
    (ai_place "ride_rooftop1_inf0")
    (ai_place "ride_rooftop1_inf1")
    (ai_place "ride_rooftop1_inf2")
    (ai_place "ride_rooftop1_civ1")
    (ai_place "ride_rooftop1_civ0")
    (ai_place "ride_rooftop1_unsc0")
    (ai_force_low_lod "gr_civilian")
    (sleep 1)
    (ai_set_targeting_group "gr_rooftop1_cov" 1 false)
    (ai_set_targeting_group "gr_rooftop1_unsc" 1 false)
    (ai_set_targeting_group "gr_rooftop1_civilians" 1 false)
    (ai_set_targeting_group "ride_rooftop1_inf0" 1 false)
    (sleep_until (and b_falcon_load_hover b_falcon0_load_hover))
    (ai_erase "ride_rooftop0_inf0")
    (ai_erase "ride_rooftop0_inf1")
    (ai_erase "ride_rooftop0_inf2")
    (ai_erase "ride_rooftop0_inf3")
    (ai_erase "ride_rooftop0_unsc0")
    (ai_erase "ride_rooftop0_civ0")
    (ai_erase "ride_rooftop0_civ1")
    (ai_erase "traxus_evac_pelican0")
    (ai_erase "traxus_evac_pelican1")
    (ai_erase "traxus_evac_pelican2")
    (set b_rooftop1_start true)
    (soft_ceiling_enable "rail_blocker_02" true)
    (sleep_until (and b_falcon_load_hover b_falcon0_load_hover))
    (soft_ceiling_enable "rail_blocker_03" true)
    (soft_ceiling_enable "rail_blocker_04" false)
    (prepare_to_switch_to_zone_set "set_starport_090")
    (sleep (* 30 15))
    (if (editor_mode)
        (switch_zone_set "set_starport_090")
    )
    (switch_zone_set "set_starport_090")
    (sleep_until (= (current_zone_set_fully_active) 5))
    (soft_ceiling_enable "rail_blocker_05" false)
    (set b_falcon_goto_lz_hover true)
    (set b_falcon0_goto_lz_hover true)
    (wake md_starport_intro)
    (ai_place "ride_shore_wraith0")
    (ai_place "ride_shore_wraith1")
    (ai_place "ride_shore_warthog0")
    (sleep (* 30 1))
    (ai_place "ride_shore_warthog1")
    (sleep (* 30 1))
    (ai_place "ride_shore_warthog2")
    (sleep 1)
    (ai_set_targeting_group "ride_shore_wraith0" 2 false)
    (ai_set_targeting_group "ride_shore_wraith1" 2 false)
    (ai_set_targeting_group "ride_shore_warthog0" 2 false)
    (ai_set_targeting_group "ride_shore_warthog1" 2 false)
    (ai_set_targeting_group "ride_shore_warthog2" 2 false)
    (flock_stop "fl_shared_banshee3")
    (flock_stop "fl_shared_falcon3")
    (flock_create "fl_shared_banshee2")
    (flock_create "fl_shared_falcon2")
    (flock_create "fl_corvette_phantom2")
    (ai_place "ride_phantom0")
    (sleep_until b_rooftop2_start)
    (ai_erase "ride_rooftop1_inf0")
    (ai_erase "ride_rooftop1_inf1")
    (ai_erase "ride_rooftop1_inf2")
    (ai_erase "ride_rooftop1_civ0")
    (ai_erase "ride_rooftop1_civ1")
    (ai_erase "ride_rooftop1_unsc0")
    (object_destroy_folder "cr_rooftop")
    (object_destroy_folder "sc_rooftop")
    (ai_place "ride_banshee04")
    (ai_place "ride_banshee05")
    (ai_place "ride_banshee06")
    (sleep 1)
    (ai_set_clump "ride_banshee04" 15)
    (ai_set_clump "ride_banshee05" 15)
    (ai_set_clump "ride_banshee06" 15)
    (ai_designer_clump_perception_range 500)
    (ai_set_targeting_group "ride_banshee04" 4 true)
    (ai_set_targeting_group "ride_banshee05" 4 true)
    (ai_set_targeting_group "ride_banshee06" 4 true)
    (ai_set_targeting_group "ride_falcon" 4)
    (ai_set_targeting_group "ride_falcon0" 4)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee04/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee04/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee05/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee05/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee06/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee06/spawn_points_0") g_falcon_vitality 0)
    (wake f_corvette_starport)
    (sleep_until (or b_falcon_transport b_falcon0_transport))
    (soft_ceiling_enable "rail_blocker_06" true)
    (soft_ceiling_enable "rail_blocker_08" false)
    (wake civilian_transport_takeoff)
    (ai_place "ride_banshee07")
    (ai_place "ride_banshee08")
    (ai_place "ride_banshee09")
    (sleep 1)
    (ai_set_clump "ride_banshee07" 15)
    (ai_set_clump "ride_banshee08" 15)
    (ai_set_clump "ride_banshee09" 15)
    (ai_designer_clump_perception_range 500)
    (ai_set_targeting_group "ride_banshee07" 1 true)
    (ai_set_targeting_group "ride_banshee08" 1 true)
    (ai_set_targeting_group "ride_banshee09" 1 true)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee07/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee07/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee08/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee08/spawn_points_0") g_falcon_vitality 0)
    (unit_set_current_vitality (ai_vehicle_get_from_starting_location "ride_banshee09/spawn_points_0") g_falcon_vitality 0)
    (unit_set_maximum_vitality (ai_vehicle_get_from_starting_location "ride_banshee09/spawn_points_0") g_falcon_vitality 0)
    (sleep_until (or b_falcon_park b_falcon0_park))
    (ai_erase "gr_ride_shore")
    (sleep_until (and b_falcon_lz_hover b_falcon0_lz_hover))
    (soft_ceiling_enable "rail_blocker_07" true)
    (flock_delete "fl_shared_banshee3")
    (flock_delete "fl_shared_falcon3")
    (set b_starport_intro true)
    (f_blip_ai "starport_unsc_command" 5)
    (sleep_until b_starport_monologue)
    (f_unblip_ai "starport_unsc_command")
    (ride_banshee789_remove)
    (cs_run_command_script "ride_falcon/pilot" cs_duvall_falcon)
    (cs_run_command_script "ride_falcon0/pilot" cs_duvall_falcon0)
    (wake force_unload)
    (sleep_until (and b_falcon_unloaded b_falcon0_unloaded))
    (kill_volume_enable "kill_soft_jetpack0")
    (kill_volume_enable "kill_soft_starport0")
    (kill_volume_enable "kill_soft_starport1")
    (game_safe_to_respawn true)
    (wake md_starport_objectives)
    (ai_lod_full_detail_actors 20)
    (ai_set_objective "ride_passengers" "obj_starport_unsc")
    (ai_set_objective "ride_passengers0" "obj_starport_unsc")
    (sleep (* 30 3))
    (cs_run_command_script "ride_falcon/pilot" cs_ride_vehicle_exit)
    (cs_run_command_script "test_falcon/pilot" cs_ride_vehicle_exit)
    (sleep (* 30 3))
    (cs_run_command_script "ride_falcon0/pilot" cs_ride_vehicle0_exit)
    (cs_run_command_script "test_falcon0/pilot" cs_ride_vehicle_exit)
)

(script dormant void force_unload
    (sleep (* 30 15))
    (vehicle_unload v_ride_falcon 55)
    (vehicle_unload v_ride_falcon 56)
    (vehicle_unload v_ride_falcon0 55)
    (vehicle_unload v_ride_falcon0 56)
    (set b_falcon_unloaded true)
    (set b_falcon0_unloaded true)
)

(script command_script void cs_ride_vehicle_exit
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "falcon_exit/p0" "falcon_exit/p1" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "falcon_exit/p1" 5)
    (cs_fly_by "falcon_exit/p2" 5)
    (cs_fly_by "falcon_exit/p3" 5)
    (ai_erase ai_current_actor)
)

(script command_script void cs_ride_vehicle0_exit
    (cs_enable_pathfinding_failsafe true)
    (cs_ignore_obstacles true)
    (sleep (* 30 3))
    (cs_vehicle_speed 0.2)
    (cs_fly_to_and_face "falcon0_exit/p0" "falcon0_exit/p1" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "falcon0_exit/p1" 5)
    (cs_fly_by "falcon0_exit/p2" 5)
    (cs_fly_by "falcon0_exit/p3" 5)
    (ai_erase ai_current_actor)
)

(script command_script void cs_terminal_pelican0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_fly_by "000_terminal_pelicans/pelican0_enter_p1" 5)
    (cs_fly_by "000_terminal_pelicans/pelican0_enter_p2a" 5)
    (cs_vehicle_speed 0.8)
    (cs_fly_to "000_terminal_pelicans/pelican0_hover" 1)
    (cs_fly_to_and_face "000_terminal_pelicans/pelican0_land" "000_terminal_pelicans/pelican0_land_facing" 0.25)
)

(script command_script void cs_terminal_pelican0_exit
    (unit_close (ai_vehicle_get ai_current_actor))
    (sleep (* 30 0))
    (cs_vehicle_speed 0.4)
    (cs_fly_by "000_terminal_pelicans/pelican0_hover" 2)
    (cs_vehicle_speed 0.6)
    (cs_fly_by "000_terminal_pelicans/pelican0_p1" 2)
    (cs_vehicle_speed 0.8)
    (set b_banshee0_start true)
    (cs_fly_to "000_terminal_pelicans/pelican0_exit" 2)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_terminal_pelican1
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (set g_trophy_civ_desired 10)
    (set g_trophy_civ_current (ai_living_count "gr_trophy_civilians"))
    (if (< g_trophy_civ_current g_trophy_civ_desired)
        (ai_place "sq_evac1_m1" (- g_trophy_civ_desired g_trophy_civ_current))
    )
    (ai_migrate "gr_trophy_civilians" "sq_evac1_m1")
    (sleep 1)
    (ai_force_full_lod "gr_trophy_civilians")
    (cs_fly_by "000_terminal_pelicans/pelican1_enter_p1")
    (cs_vehicle_speed 0.6)
    (set b_evac1_landed true)
    (cs_fly_to_and_face "000_terminal_pelicans/pelican1_land" "000_terminal_pelicans/pelican1_land_facing" 0.25)
    (f_load_troopers_evac1 "traxus_evac_pelican1/pilot" "traxus_evac_pelican1" evac_delay "sq_evac1_m1")
)

(script command_script void cs_terminal_pelican1_exit
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_vehicle_speed 0.4)
    (cs_fly_by "000_terminal_pelicans/pelican1_hover" 2)
    (cs_vehicle_speed 1)
    (cs_fly_by "000_terminal_pelicans/pelican1_p1" 2)
    (cs_fly_to "000_terminal_pelicans/pelican1_exit" 2)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_terminal_pelican2
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (cs_fly_by "000_terminal_pelicans/pelican2_enter_p1")
    (cs_fly_by "000_terminal_pelicans/pelican2_enter_p2")
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "000_terminal_pelicans/pelican2_land" "000_terminal_pelicans/pelican2_land_facing" 0.25)
)

(script command_script void cs_terminal_pelican2_exit
    (unit_close (ai_vehicle_get ai_current_actor))
    (cs_vehicle_speed 0.4)
    (cs_fly_by "000_terminal_pelicans/pelican2_hover" 2)
    (cs_attach_to_spline "spline_pelican1_exit")
    (cs_vehicle_speed 1)
    (cs_fly_to "000_terminal_pelicans/pelican2_exit" 2)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script static void (f_load_troopers_evac0 (ai driver, ai driver_squad, short delay, ai troopers))
    (if (> (ai_living_count troopers) 0)
        (begin
            (unit_open (ai_vehicle_get driver))
            (vehicle_hover (ai_vehicle_get_from_spawn_point driver) true)
            (sleep (* 30 2))
            (ai_vehicle_enter troopers (ai_vehicle_get_from_spawn_point driver) 60)
            (sleep_until (= (f_all_squad_in_vehicle troopers driver_squad) true) 5 delay)
            (vehicle_hover (ai_vehicle_get_from_spawn_point driver) false)
            (unit_close (ai_vehicle_get driver))
            (sleep 30)
            (vehicle_unload (ai_vehicle_get ai_current_actor) none)
            (ai_erase troopers)
        )
    )
)

(script static void (f_load_troopers_evac1 (ai driver, ai driver_squad, short delay, ai troopers))
    (if (> (ai_living_count troopers) 0)
        (begin
            (unit_open (ai_vehicle_get driver))
            (vehicle_hover (ai_vehicle_get_from_spawn_point driver) true)
            (sleep (* 30 2))
            (ai_vehicle_enter troopers (ai_vehicle_get_from_spawn_point driver) 60)
            (set b_evac1_complete true)
            (sleep_until (= (f_all_squad_in_vehicle troopers driver_squad) true) 5 delay)
            (vehicle_hover (ai_vehicle_get_from_spawn_point driver) false)
            (unit_close (ai_vehicle_get driver))
            (sleep 30)
            (vehicle_unload (ai_vehicle_get ai_current_actor) none)
            (ai_erase troopers)
        )
        (begin
            (sleep (* 30 2))
            (set b_evac1_complete true)
        )
    )
)

(script dormant void ride_banshee_cleanup
    (sleep_until b_rooftop0_finish)
    (ai_kill "ride_banshee0")
    (ai_kill "ride_banshee00")
    (ai_kill "ride_banshee000")
    (sleep_until b_falcon_transport)
    (ai_kill "ride_banshee01")
    (ai_kill "ride_banshee02")
    (ai_kill "ride_banshee03")
    (sleep_until b_starport_started)
    (ai_kill "ride_banshee04")
    (ai_kill "ride_banshee05")
    (ai_kill "ride_banshee06")
    (sleep_until b_starport_monologue)
    (ai_kill "ride_banshee07")
    (ai_kill "ride_banshee08")
    (ai_kill "ride_banshee09")
)

(script command_script void cs_ride_banshee0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_000/enter_01" 10)
)

(script command_script void cs_ride_banshee00
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_000/enter_02" 10)
)

(script command_script void cs_ride_banshee000
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_000/enter_03" 10)
)

(script command_script void cs_ride_banshee01
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/enter_01" 10)
    (cs_fly_by "pts_ride_banshees_123/approach_01")
    (cs_fly_by "pts_ride_banshees_123/dive_01")
)

(script command_script void cs_ride_banshee02
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/enter_02" 10)
    (cs_fly_by "pts_ride_banshees_123/approach_02")
    (cs_fly_by "pts_ride_banshees_123/dive_02")
    (cs_vehicle_speed 0.9)
    (cs_fly_by "pts_ride_banshees_123/turn_02")
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/exit_02")
    (if (or (>= (ai_living_count "ride_banshee01") 0) (>= (ai_living_count "ride_banshee02") 0) (>= (ai_living_count "ride_banshee03") 0))
        (begin
            (cs_fly_by "pts_ride_banshees_123/split_02")
        )
    )
)

(script command_script void cs_ride_banshee03
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/enter_03" 10)
    (cs_fly_by "pts_ride_banshees_123/approach_03")
    (cs_fly_by "pts_ride_banshees_123/dive_03")
    (cs_vehicle_speed 0.9)
    (cs_fly_by "pts_ride_banshees_123/turn_03")
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/exit_03")
    (if (or (>= (ai_living_count "ride_banshee01") 0) (>= (ai_living_count "ride_banshee02") 0) (>= (ai_living_count "ride_banshee03") 0))
        (begin
            (cs_fly_by "pts_ride_banshees_123/split_03")
        )
    )
)

(script command_script void cs_ride_banshee123_swarm1
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/swarm1" 10)
)

(script command_script void cs_ride_banshee123_swarm2
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/exit_01" 10)
    (cs_fly_by "pts_ride_banshees_123/swarm2" 10)
)

(script static void ride_banshee123_remove
    (cs_run_command_script "ride_banshee01" cs_ride_banshee123_remove)
    (cs_run_command_script "ride_banshee02" cs_ride_banshee123_remove)
    (cs_run_command_script "ride_banshee03" cs_ride_banshee123_remove)
)

(script command_script void cs_ride_banshee123_remove
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_123/remove_01" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_ride_banshee04
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/enter_01" 10)
    (cs_fly_by "pts_ride_banshees_456/approach_01" 10)
    (cs_fly_by "pts_ride_banshees_456/dive_01")
)

(script command_script void cs_ride_banshee05
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/enter_02" 10)
    (cs_fly_by "pts_ride_banshees_456/approach_02" 10)
    (cs_fly_by "pts_ride_banshees_456/dive_02")
)

(script command_script void cs_ride_banshee06
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/enter_03" 10)
    (cs_fly_by "pts_ride_banshees_456/approach_03" 10)
    (cs_fly_by "pts_ride_banshees_456/dive_03")
)

(script command_script void cs_ride_banshee456_swarm1
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/enter_01" 10)
    (cs_fly_by "pts_ride_banshees_456/approach_01" 10)
    (cs_fly_by "pts_ride_banshees_456/swarm1" 10)
)

(script command_script void cs_ride_banshee456_swarm2
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/turn_01" 10)
    (cs_fly_by "pts_ride_banshees_456/exit_01" 10)
    (cs_fly_by "pts_ride_banshees_456/split_01" 10)
    (cs_fly_by "pts_ride_banshees_456/swarm2" 10)
)

(script static void ride_banshee456_remove
    (cs_run_command_script "ride_banshee04" cs_ride_banshee456_remove)
    (cs_run_command_script "ride_banshee05" cs_ride_banshee456_remove)
    (cs_run_command_script "ride_banshee06" cs_ride_banshee456_remove)
)

(script command_script void cs_ride_banshee456_remove
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_456/remove_01" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_ride_banshee07
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/enter_01")
    (cs_fly_by "pts_ride_banshees_789/approach_01")
    (cs_fly_by "pts_ride_banshees_789/dive_01")
    (cs_fly_by "pts_ride_banshees_789/swarm1")
)

(script command_script void cs_ride_banshee08
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/enter_01")
    (cs_fly_by "pts_ride_banshees_789/approach_01")
    (cs_fly_by "pts_ride_banshees_789/dive_01")
    (cs_fly_by "pts_ride_banshees_789/swarm1")
)

(script command_script void cs_ride_banshee09
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/enter_01")
    (cs_fly_by "pts_ride_banshees_789/approach_01")
    (cs_fly_by "pts_ride_banshees_789/dive_01")
    (cs_fly_by "pts_ride_banshees_789/swarm1")
)

(script command_script void cs_ride_banshee789_swarm1
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/swarm1" 10)
)

(script command_script void cs_ride_banshee789_swarm2
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/swarm2" 10)
)

(script command_script void cs_ride_banshee789_swarm3
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/swarm3" 10)
)

(script static void ride_banshee789_remove
    (cs_run_command_script "ride_banshee07" cs_ride_banshee789_remove)
    (cs_run_command_script "ride_banshee08" cs_ride_banshee789_remove)
    (cs_run_command_script "ride_banshee09" cs_ride_banshee789_remove)
)

(script command_script void cs_ride_banshee789_remove
    (cs_vehicle_boost true)
    (cs_fly_by "pts_ride_banshees_789/remove_01" 10)
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_ride_phantom0_route
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 0.8)
    (cs_fly_by "phantom0_ride/p0" 5)
    (cs_vehicle_speed 0.4)
    (cs_fly_by "phantom0_ride/p1" 5)
    (cs_fly_by "phantom0_ride/p2" 5)
    (cs_fly_by "phantom0_ride/p3" 5)
    (cs_fly_by "phantom0_ride/p4" 5)
    (ai_erase ai_current_squad)
)

(script command_script void cs_ride_falcon1
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_shoot true)
    (cs_vehicle_speed 0.3)
    (cs_fly_by "falcon1_ride/p0" 5)
    (cs_fly_by "falcon1_ride/p1" 5)
    (ai_erase ai_current_squad)
)

(script command_script void cs_ride_falcon2
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost true)
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_shoot true)
    (cs_vehicle_speed 1)
    (cs_fly_by "falcon2_ride/p0" 5)
    (cs_fly_by "falcon2_ride/p1" 5)
    (ai_erase ai_current_squad)
)

(script dormant void starport_objective_control
    (if debug
        (print "encounter start: starport")
    )
    (set b_starport_started true)
    (game_save)
    (set objcon_starport 0)
    (if debug
        (print "cleaning up ride...")
    )
    (wake f_starport_fx_ambient)
    (wake starport_spawn_control)
    (wake starport_ghosts_spawn_control)
    (wake starport_chief_spawn_control)
    (wake starport_turret0_control)
    (wake starport_turret1_control)
    (wake starport_firing_control)
    (wake starport_wraith0_firing_control)
    (wake starport_pelican0_control)
    (wake starport_pelican1_control)
    (wake starport_wraith0_save_control)
    (wake starport_wraith1_save_control)
    (wake f_player_on_foot)
    (wake starport_waypoint)
    (wake starport_bob)
    (wake md_starport_complete)
    (sleep_until (volume_test_players "tv_objcon_starport_010") 1)
    (if debug
        (print "objective control: starport 010")
    )
    (set objcon_starport 10)
    (ai_enter_squad_vehicles "gr_starport_unsc_initial")
    (sleep_until (volume_test_players "tv_objcon_starport_020") 1)
    (if debug
        (print "objective control: starport 020")
    )
    (set objcon_starport 20)
    (game_save)
    (sleep_until (volume_test_players "tv_objcon_starport_030") 1)
    (if debug
        (print "objective control: starport 030")
    )
    (set objcon_starport 30)
    (sleep_until (volume_test_players "tv_objcon_starport_040") 1)
    (if debug
        (print "objective control: starport 040")
    )
    (set objcon_starport 40)
    (ai_place "starport_unsc_mars1")
    (ai_place "starport_unsc_mong1")
    (sleep_until (and b_starport_turret0_ready b_starport_turret1_ready))
    (game_save)
    (sleep_until b_starport_defenses_fired)
    (sleep 1)
    (cinematic_enter "050lb_reunited" false)
    (sleep objective_delay)
    (flock_delete "fl_shared_banshee2")
    (flock_delete "fl_shared_falcon2")
    (flock_delete "fl_corvette_phantom2")
    (ai_erase "gr_cov")
    (ai_erase "gr_unsc")
    (garbage_collect_now)
    (cin_outro)
    (game_won)
)

(script dormant void starport_pelican0_control
    (sleep_until (volume_test_players "tv_md_starport_battery0"))
    (f_ai_place_vehicle_deathless_no_emp "starport_unsc_m0_pelican")
    (sleep_until b_starport_turret0_ready)
    (cs_run_command_script "starport_unsc_m0_pelican/pilot" cs_starport_m0_pelican_land)
)

(script dormant void starport_pelican1_control
    (sleep_until (volume_test_players "tv_md_starport_battery1"))
    (f_ai_place_vehicle_deathless_no_emp "starport_unsc_m1_pelican")
    (sleep_until b_starport_turret1_ready)
    (cs_run_command_script "starport_unsc_m1_pelican/pilot" cs_starport_m1_pelican_land)
)

(script dormant void starport_spawn_control
    (sleep_until (or b_falcon_lz_setup b_falcon0_lz_setup))
    (ai_place "starport_unsc_mars0")
    (ai_place "starport_unsc_hog0")
    (ai_place "starport_unsc_hog1")
    (ai_place "starport_unsc_mong0")
    (ai_place "starport_unsc_command")
    (sleep 1)
    (thespian_performance_setup_and_begin "starport_intro" "" 0)
    (ai_place "starport_cov_inf0")
    (ai_place "starport_cov_inf1")
    (sleep 1)
    (ai_disregard (ai_actors "starport_unsc_command") true)
    (ai_disregard (players) true)
    (ai_disregard (ai_actors "ride_falcon") true)
    (ai_disregard (ai_actors "ride_falcon0") true)
    (ai_cannot_die "starport_unsc_command" true)
    (sleep_until b_starport_monologue)
    (ai_disregard (ai_actors "starport_unsc_command") false)
    (ai_disregard (players) false)
    (ai_disregard (ai_actors "ride_falcon") false)
    (ai_disregard (ai_actors "ride_falcon0") false)
    (ai_disregard (ai_actors "ride_passengers") false)
    (ai_disregard (ai_actors "ride_passengers0") false)
    (ai_disregard (ai_actors "gr_unsc") false)
    (ai_set_targeting_group "ride_passengers" 65535 true)
    (ai_set_targeting_group "ride_passengers0" 65535 true)
    (ai_place "starport_cov_bridge_inf0")
    (wake starport_wraith1_firing_control)
    (ai_place "starport_cov_mis0_inf0")
    (ai_place "starport_cov_mis0_inf1")
    (ai_place "starport_cov_mis1_inf0")
    (ai_place "starport_cov_mis1_inf1")
    (ai_place "starport_cov_glass_inf0")
    (sleep_until (and b_starport_turret0_ready b_starport_turret1_ready))
    (f_ai_place_vehicle_deathless "starport_phantom0")
    (ai_place "starport_cov_terminal_inf0")
    (ai_place "starport_cov_terminal_inf1")
)

(script dormant void starport_chief_spawn_control
    (sleep_until (or (and b_starport_turret0_ready b_starport_turret1_ready) (volume_test_players "tv_md_starport_terminal")))
    (ai_place "starport_cov_terminal_chief0")
    (ai_place "starport_cov_terminal_chief1")
)

(script dormant void starport_ghosts_spawn_control
    (sleep_until (>= objcon_starport 1))
    (sleep (random_range 150 180))
    (ai_place "starport_cov_ghost0")
    (ai_place "starport_cov_ghost1")
    (sleep 1)
    (wake ghost0_reserve)
    (wake ghost1_reserve)
    (sleep_until (and (<= (ai_task_count "obj_starport_cov_vehicles/gate_ghosts") 0) b_starport_turret0_ready b_starport_turret1_ready))
    (sleep (random_range 90 180))
    (if (< (random_range 0 100) 50)
        (ai_place "starport_cov_ghosts_ds0")
        (ai_place "starport_cov_ghosts_ds1")
    )
    (wake ghost2_reserve)
    (wake ghost3_reserve)
)

(script dormant void ghost0_reserve
    (sleep_until (not (vehicle_test_seat (ai_vehicle_get "starport_cov_ghost0/pilot") 61)))
    (ai_vehicle_reserve (ai_vehicle_get_from_spawn_point "starport_cov_ghost0/pilot") true)
)

(script dormant void ghost1_reserve
    (sleep_until (not (vehicle_test_seat (ai_vehicle_get "starport_cov_ghost1/pilot") 61)))
    (ai_vehicle_reserve (ai_vehicle_get_from_spawn_point "starport_cov_ghost1/pilot") true)
)

(script dormant void ghost2_reserve
    (sleep_until (not (vehicle_test_seat (ai_vehicle_get "starport_cov_ghost2/pilot") 61)))
    (ai_vehicle_reserve (ai_vehicle_get_from_spawn_point "starport_cov_ghost2/pilot") true)
)

(script dormant void ghost3_reserve
    (sleep_until (not (vehicle_test_seat (ai_vehicle_get "starport_cov_ghost3/pilot") 61)))
    (ai_vehicle_reserve (ai_vehicle_get_from_spawn_point "starport_cov_ghost3/pilot") true)
)

(script command_script void cs_starport_ghosts_dropship0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (ai_place "starport_cov_ghost2")
    (ai_place "starport_cov_ghost3")
    (sleep 1)
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds0/pilot") 62 (ai_vehicle_get_from_starting_location "starport_cov_ghost2/pilot"))
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds0/pilot") 62 (ai_vehicle_get_from_starting_location "starport_cov_ghost3/pilot"))
    (cs_fly_by "starport_ghosts_dropship0/entry1")
    (cs_fly_by "starport_ghosts_dropship0/entry0")
    (cs_fly_to "starport_ghosts_dropship0/hover" 5)
    (sleep 30)
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "starport_ghosts_dropship0/land" "starport_ghosts_dropship0/land_facing" 1)
    (sleep 10)
    (vehicle_unload (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds0/pilot") 62)
    (sleep 30)
    (cs_fly_to_and_face "starport_ghosts_dropship0/hover" "starport_ghosts_dropship0/land_facing" 0.25)
    (cs_vehicle_speed 1)
    (cs_fly_by "starport_ghosts_dropship0/exit0")
    (cs_fly_by "starport_ghosts_dropship0/exit1")
    (cs_fly_by "starport_ghosts_dropship0/exit2")
    (cs_fly_by "starport_ghosts_dropship0/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script command_script void cs_starport_ghosts_dropship1
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed 1)
    (ai_place "starport_cov_ghost2")
    (ai_place "starport_cov_ghost3")
    (sleep 1)
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds1/pilot") 62 (ai_vehicle_get_from_starting_location "starport_cov_ghost2/pilot"))
    (vehicle_load_magic (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds1/pilot") 62 (ai_vehicle_get_from_starting_location "starport_cov_ghost3/pilot"))
    (cs_fly_by "starport_ghosts_dropship1/entry1")
    (cs_fly_by "starport_ghosts_dropship1/entry0")
    (cs_fly_to "starport_ghosts_dropship1/hover" 5)
    (sleep 30)
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "starport_ghosts_dropship1/land" "starport_ghosts_dropship1/land_facing" 0.25)
    (sleep 10)
    (vehicle_unload (ai_vehicle_get_from_starting_location "starport_cov_ghosts_ds1/pilot") 62)
    (sleep 30)
    (cs_fly_to_and_face "starport_ghosts_dropship1/hover" "starport_ghosts_dropship1/land_facing" 0.25)
    (cs_vehicle_speed 1)
    (cs_fly_by "starport_ghosts_dropship1/exit0")
    (cs_fly_by "starport_ghosts_dropship1/exit1")
    (cs_fly_by "starport_ghosts_dropship1/exit2")
    (cs_fly_by "starport_ghosts_dropship1/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script dormant void starport_wraith0_save_control
    (sleep_until (f_ai_is_defeated "starport_cov_wraith0"))
    (game_save_no_timeout)
)

(script dormant void starport_wraith1_save_control
    (sleep_until (f_ai_is_defeated "starport_cov_wraith1"))
    (game_save_no_timeout)
)

(script command_script void cs_starport_phantom0
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_boost true)
    (cs_vehicle_speed 1)
    (cs_ignore_obstacles true)
    (f_load_fork (ai_vehicle_get ai_current_actor) "right" "starport_cov_phantom0_inf0" none none none)
    (set g_starport_cov_current (ai_task_count "obj_starport_cov/gate_main"))
    (if (< g_starport_cov_current g_starport_cov_desired)
        (begin
            (f_load_fork (ai_vehicle_get ai_current_actor) "left" "starport_cov_phantom0_inf1" none none none)
            (set g_skimishers_loaded true)
        )
    )
    (cs_fly_by "starport_ph0/entry2")
    (cs_fly_by "starport_ph0/entry1")
    (cs_vehicle_boost false)
    (cs_fly_by "starport_ph0/entry0")
    (cs_vehicle_speed 0.6)
    (cs_fly_to_and_face "starport_ph0/hover" "starport_ph0/hover_facing" 1)
    (cs_vehicle_speed 0.4)
    (cs_fly_to_and_face "starport_ph0/land" "starport_ph0/land_facing" 0.25)
    (f_unload_fork (ai_vehicle_get ai_current_actor) "right")
    (if g_skimishers_loaded
        (f_unload_fork (ai_vehicle_get ai_current_actor) "left")
    )
    (sleep 90)
    (cs_fly_to_and_face "starport_ph0/hover" "starport_ph0/hover_facing" 1)
    (cs_vehicle_speed 1)
    (cs_fly_by "starport_ph0/exit")
    (cs_fly_by "starport_ph0/exit0")
    (cs_fly_by "starport_ph0/exit1")
    (cs_fly_by "starport_ph0/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script dormant void starport_wraith0_firing_control
    (ai_place "starport_cov_wraith0")
    (sleep 1)
    (cs_run_command_script "starport_cov_wraith0/pilot" cs_starport_wraith0_fire_starport)
    (sleep_until (or (<= (object_get_health (ai_vehicle_get "starport_cov_wraith0/pilot")) 0.9) (and (<= (ai_living_count "starport_cov_inf0") 1) (<= (ai_living_count "starport_cov_inf1") 1))))
    (cs_run_command_script "starport_cov_wraith0/pilot" cs_starport_wraith0_fire_shore)
    (sleep_until (>= objcon_starport 30))
    (sleep 150)
    (cs_run_command_script "starport_cov_wraith0/pilot" cs_exit)
)

(script command_script void cs_starport_wraith0_fire_starport
    (sleep_until 
        (begin
            (cs_go_to "090_wraiths/wraith0_starport_fp")
            (begin_random
                (begin
                    (cs_shoot_point true "090_wraiths/wraith0_target0")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/wraith0_target1")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/wraith0_target2")
                    (sleep (random_range 90 150))
                )
            )
            false
        )
    )
)

(script command_script void cs_starport_wraith0_fire_shore
    (cs_shoot_point true "090_wraiths/p7")
    (sleep (random_range 90 150))
    (cs_shoot_point true "090_wraiths/p8")
    (sleep (random_range 90 150))
    (sleep_until 
        (begin
            (cs_go_to "090_wraiths/wraith0_shore_fp")
            (begin_random
                (begin
                    (cs_shoot_point true "090_wraiths/p0")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/p1")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/p2")
                    (sleep (random_range 90 150))
                )
            )
            false
        )
    )
)

(script command_script void cs_starport_wraith0_fire_mound
    (cs_shoot_point true "090_wraiths/p6")
    (sleep (random_range 90 150))
    (cs_shoot_point true "090_wraiths/p6")
    (sleep (random_range 90 150))
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_shoot_point true "090_wraiths/p4")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/p5")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/p6")
                    (sleep (random_range 90 150))
                )
            )
            false
        )
    )
)

(script dormant void starport_wraith1_firing_control
    (ai_place "starport_cov_wraith1")
    (cs_run_command_script "starport_cov_wraith1/pilot" cs_starport_wraith1_fire)
    (sleep_until (>= objcon_starport 30))
    (sleep 150)
    (cs_run_command_script "starport_cov_wraith1/pilot" cs_exit)
)

(script command_script void cs_starport_wraith1_fire
    (sleep_until 
        (begin
            (cs_go_to "090_wraiths/wraith1_starport_fp")
            (begin_random
                (begin
                    (cs_shoot_point true "090_wraiths/wraith1_target0")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/wraith1_target1")
                    (sleep (random_range 90 150))
                )
                (begin
                    (cs_shoot_point true "090_wraiths/wraith1_target2")
                    (sleep (random_range 90 150))
                )
            )
            false
        )
    )
)

(script static void starport_load_m0_falcon
    (vehicle_set_player_interaction v_starport_falcon0 52 false false)
    (vehicle_set_player_interaction v_starport_falcon0 53 false false)
    (vehicle_set_player_interaction v_starport_falcon0 54 false false)
    (vehicle_set_player_interaction v_starport_falcon0 51 false false)
    (vehicle_set_player_interaction v_starport_falcon0 63 false false)
    (vehicle_set_player_interaction v_starport_falcon0 50 false false)
    (vehicle_set_player_interaction v_starport_falcon0 64 false false)
    (ai_vehicle_reserve_seat v_starport_falcon0 50 true)
    (ai_vehicle_reserve_seat v_starport_falcon0 64 true)
    (ai_vehicle_reserve_seat v_starport_falcon0 51 true)
    (ai_vehicle_reserve_seat v_starport_falcon0 63 true)
    (ai_vehicle_reserve_seat v_starport_falcon0 42 true)
    (ai_vehicle_reserve_seat v_starport_falcon0 48 true)
    (if (game_is_cooperative)
        (set g_starport_unsc_desired 6)
    )
    (set g_starport_unsc_current (ai_task_count "obj_starport_unsc/gate_main"))
    (if (< g_starport_unsc_current g_starport_unsc_desired)
        (begin
            (if debug
                (print "loading passenger_left_1")
            )
            (ai_place "starport_unsc_m0_inf0/passenger0")
            (sleep 10)
            (vehicle_load_magic v_starport_falcon0 50 (ai_get_object "starport_unsc_m0_inf0/passenger0"))
            (if debug
                (print "loading passenger_right_1")
            )
            (ai_place "starport_unsc_m0_inf0/passenger2")
            (sleep 10)
            (vehicle_load_magic v_starport_falcon0 51 (ai_get_object "starport_unsc_m0_inf0/passenger2"))
        )
    )
    (if debug
        (print "loading passenger_left_gunner")
    )
    (ai_place "starport_unsc_m0_inf0/passenger1")
    (sleep 10)
    (vehicle_load_magic v_starport_falcon0 48 (ai_get_object "starport_unsc_m0_inf0/passenger1"))
    (if debug
        (print "loading passenger_right_gunner")
    )
    (ai_place "starport_unsc_m0_inf0/passenger3")
    (sleep 10)
    (vehicle_load_magic v_starport_falcon0 42 (ai_get_object "starport_unsc_m0_inf0/passenger3"))
)

(script static void starport_load_m1_falcon
    (vehicle_set_player_interaction v_starport_falcon1 52 false false)
    (vehicle_set_player_interaction v_starport_falcon1 53 false false)
    (vehicle_set_player_interaction v_starport_falcon1 54 false false)
    (vehicle_set_player_interaction v_starport_falcon1 51 false false)
    (vehicle_set_player_interaction v_starport_falcon1 63 false false)
    (vehicle_set_player_interaction v_starport_falcon1 50 false false)
    (vehicle_set_player_interaction v_starport_falcon1 64 false false)
    (ai_vehicle_reserve_seat v_starport_falcon1 50 true)
    (ai_vehicle_reserve_seat v_starport_falcon1 64 true)
    (ai_vehicle_reserve_seat v_starport_falcon1 51 true)
    (ai_vehicle_reserve_seat v_starport_falcon1 63 true)
    (ai_vehicle_reserve_seat v_starport_falcon1 42 true)
    (ai_vehicle_reserve_seat v_starport_falcon1 48 true)
    (if (game_is_cooperative)
        (set g_starport_unsc_desired 6)
    )
    (set g_starport_unsc_current (ai_task_count "obj_starport_unsc/gate_main"))
    (if (< g_starport_unsc_current g_starport_unsc_desired)
        (begin
            (if debug
                (print "loading passenger_left_1")
            )
            (ai_place "starport_unsc_m1_inf0/passenger0")
            (sleep 10)
            (vehicle_load_magic v_starport_falcon1 50 (ai_get_object "starport_unsc_m1_inf0/passenger0"))
            (if debug
                (print "loading passenger_right_1")
            )
            (ai_place "starport_unsc_m1_inf0/passenger2")
            (sleep 10)
            (vehicle_load_magic v_starport_falcon1 51 (ai_get_object "starport_unsc_m1_inf0/passenger2"))
        )
    )
    (if debug
        (print "loading passenger_left_gunner")
    )
    (ai_place "starport_unsc_m1_inf0/passenger1")
    (sleep 10)
    (vehicle_load_magic v_starport_falcon1 48 (ai_get_object "starport_unsc_m1_inf0/passenger1"))
    (if debug
        (print "loading passenger_right_gunner")
    )
    (ai_place "starport_unsc_m1_inf0/passenger3")
    (sleep 10)
    (vehicle_load_magic v_starport_falcon1 42 (ai_get_object "starport_unsc_m1_inf0/passenger3"))
)

(script command_script void cs_starport_m0_pelican_enter
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed_instantaneous 1)
    (set v_starport_falcon0 (ai_vehicle_get_from_starting_location "starport_unsc_m0_pelican/pilot"))
    (starport_load_m0_falcon)
    (cs_fly_by "starport_m0_pelican/entry1")
    (cs_fly_by "starport_m0_pelican/entry0")
    (cs_vehicle_speed 0.4)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_fly_to_and_face "starport_m0_pelican/p0" "starport_m0_pelican/hover")
                    (sleep (* 30 5))
                )
                (begin
                    (cs_fly_to_and_face "starport_m0_pelican/p1" "starport_m0_pelican/hover")
                    (sleep (* 30 5))
                )
                (begin
                    (cs_fly_to_and_face "starport_m0_pelican/p2" "starport_m0_pelican/hover")
                    (sleep (* 30 5))
                )
            )
            false
        )
    )
)

(script command_script void cs_starport_m1_pelican_enter
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (cs_vehicle_speed_instantaneous 1)
    (set v_starport_falcon1 (ai_vehicle_get_from_starting_location "starport_unsc_m1_pelican/pilot"))
    (starport_load_m1_falcon)
    (cs_fly_by "starport_m1_pelican/entry1")
    (cs_vehicle_boost false)
    (cs_fly_by "starport_m1_pelican/entry0")
    (cs_vehicle_speed 0.4)
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (cs_fly_to_and_face "starport_m1_pelican/p0" "starport_m1_pelican/hover")
                    (sleep (* 30 5))
                )
                (begin
                    (cs_fly_to_and_face "starport_m1_pelican/p1" "starport_m1_pelican/hover")
                    (sleep (* 30 5))
                )
                (begin
                    (cs_fly_to_and_face "starport_m1_pelican/p2" "starport_m1_pelican/hover")
                    (sleep (* 30 5))
                )
            )
            false
        )
    )
)

(script command_script void cs_starport_m0_pelican_land
    (cs_vehicle_speed 0.4)
    (cs_fly_to "starport_m0_pelican/hover" 1)
    (cs_vehicle_speed 0.2)
    (sleep 30)
    (cs_fly_to_and_face "starport_m0_pelican/land" "starport_m0_pelican/land_facing" 0.5)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 55)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 56)
    (sleep 90)
    (thespian_performance_setup_and_begin "starport_turret0_activate" "" 0)
    (cs_fly_to_and_face "starport_m0_pelican/hover" "starport_m0_pelican/exit0" 0.5)
    (cs_vehicle_speed 1)
    (cs_fly_by "starport_m0_pelican/exit0")
    (cs_fly_by "starport_m0_pelican/exit1")
    (cs_fly_by "starport_m0_pelican/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script command_script void cs_starport_m1_pelican_land
    (cs_vehicle_speed 0.4)
    (cs_fly_to "starport_m1_pelican/hover" 1)
    (cs_vehicle_speed 0.2)
    (sleep 30)
    (cs_fly_to_and_face "starport_m1_pelican/land" "starport_m1_pelican/land_facing" 0.5)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 55)
    (vehicle_unload (ai_vehicle_get ai_current_actor) 56)
    (sleep 90)
    (thespian_performance_setup_and_begin "starport_turret1_activate" "" 0)
    (cs_fly_to_and_face "starport_m1_pelican/hover" "starport_m1_pelican/exit0" 0.5)
    (cs_vehicle_speed 1)
    (cs_fly_by "starport_m1_pelican/exit0")
    (cs_fly_by "starport_m1_pelican/exit1")
    (cs_fly_by "starport_m1_pelican/erase")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
    (ai_erase ai_current_squad)
)

(script dormant void starport_turret0_control
    (sleep_until (> (device_get_position "turret0_switch") 0))
    (f_unblip_object "turret0_switch")
    (game_save_no_timeout)
    (set b_starport_turret0_ready true)
)

(script command_script void cs_remove_duvall
    (ai_disposable ai_current_actor true)
)

(script dormant void starport_turret1_control
    (sleep_until (> (device_get_position "turret1_switch") 0))
    (f_unblip_object "turret1_switch")
    (game_save_no_timeout)
    (set b_starport_turret1_ready true)
)

(script dormant void starport_firing_control
    (sleep_until (and b_starport_turret0_ready b_starport_turret1_ready))
    (device_set_power "firing_control_switch" 1)
    (sleep_until (> (device_get_position "firing_control_switch") 0))
    (f_unblip_object "firing_control_switch")
    (set b_starport_defenses_fired true)
)

(script dormant void f_player_on_foot
    (sleep_until 
        (begin
            (if (or (and (= (game_coop_player_count) 1) (= (unit_in_vehicle (player0)) true)) (and (= (game_coop_player_count) 2) (and (= (unit_in_vehicle (player0)) true) (= (unit_in_vehicle (player1)) true))) (and (= (game_coop_player_count) 3) (and (= (unit_in_vehicle (player0)) true) (= (unit_in_vehicle (player1)) true) (= (unit_in_vehicle (player2)) true))) (and (= (game_coop_player_count) 4) (and (= (unit_in_vehicle (player0)) true) (= (unit_in_vehicle (player1)) true) (= (unit_in_vehicle (player2)) true) (= (unit_in_vehicle (player3)) true))))
                (begin
                    (set b_players_all_on_foot false)
                    (set b_players_any_in_vehicle true)
                )
                (begin
                    (set b_players_all_on_foot true)
                    (set b_players_any_in_vehicle false)
                )
            )
            false
        )
    )
)

(script dormant void starport_waypoint
    (sleep_until b_starport_monologue)
    (sleep g_waypoint_timeout)
    (if (!= b_starport_turret0_ready true)
        (f_blip_object "turret0_switch" blip_interface)
    )
    (if (!= b_starport_turret1_ready true)
        (f_blip_object "turret1_switch" blip_interface)
    )
    (sleep_until (and b_starport_turret0_ready b_starport_turret1_ready) 5)
    (sleep (* 30 10))
    (f_blip_object "firing_control_switch" blip_interface)
)

(script command_script void cs_renew
    (cs_enable_moving ai_current_actor true)
    (cs_enable_targeting ai_current_actor true)
    (cs_enable_looking ai_current_actor true)
    (sleep_until 
        (begin
            (ai_renew ai_current_squad)
            false
        )
        15
    )
)

(script static void (teleport_players_in_volume (trigger_volume v, cutscene_flag teleport0, cutscene_flag teleport1, cutscene_flag teleport2, cutscene_flag teleport3))
    (if debug
        (print "teleporting players in a volume forward...")
    )
    (if (volume_test_object v (player0))
        (object_teleport (player0) teleport0)
    )
    (if (volume_test_object v (player1))
        (object_teleport (player1) teleport1)
    )
    (if (volume_test_object v (player2))
        (object_teleport (player2) teleport2)
    )
    (if (volume_test_object v (player3))
        (object_teleport (player3) teleport3)
    )
)

(script static void (teleport_players_not_in_volume (trigger_volume v, cutscene_flag teleport0, cutscene_flag teleport1, cutscene_flag teleport2, cutscene_flag teleport3))
    (if debug
        (print "teleporting players not in a volume forward...")
    )
    (if (not (volume_test_object v (player0)))
        (object_teleport (player0) teleport0)
    )
    (if (not (volume_test_object v (player1)))
        (object_teleport (player1) teleport1)
    )
    (if (not (volume_test_object v (player2)))
        (object_teleport (player2) teleport2)
    )
    (if (not (volume_test_object v (player3)))
        (object_teleport (player3) teleport3)
    )
)

(script static boolean (is_down (ai group))
    (<= (ai_living_count group) 0)
)

(script static void cam_shake_old
    (player_effect_set_max_rotation 2 2 2)
    (player_effect_start 0.5 1)
    (player_effect_stop 3)
)

(script static void sleep_longswords
    (sleep_forever panoptical_longsword_cycle)
    (sleep_forever towers_longsword_cycle)
    (sleep_forever canyonview_longsword_cycle)
)

(script command_script void cs_exit
    (if debug
        (print "exiting command script...")
    )
)

(script static void attempt_save
    (game_save)
)

(script static void nuke_all_covenant
    (ai_erase "gr_cov")
    (kill_ambient_dropships)
)

(script static void nuke_all_longswords
    (sleep_forever panoptical_longsword_cycle)
    (sleep_forever towers_longsword_cycle)
    (sleep_forever canyonview_longsword_cycle)
    (sleep_forever jetpack_longsword_cycle)
)

(script static void nuke_all_unsc
    (ai_erase "gr_unsc_jl")
    (ai_erase "atrium_unsc_elevator")
    (ai_erase "atrium_unsc_troopers")
    (ai_erase "jh_unsc_mars_balcony_inf0")
    (ai_erase "jh_unsc_mars_tree_inf0")
    (ai_erase "jh_unsc_odst_balcony_inf0")
    (ai_erase "jh_unsc_odst_tree_inf0")
)

(script dormant void object_control
    (print "object_control")
    (sleep_until (>= (current_zone_set) 0) 1)
    (sleep 1)
    (if (= (current_zone_set) 0)
        (objects_manage_0)
    )
    (sleep_until (>= (current_zone_set) 1) 1)
    (sleep 1)
    (if (= (current_zone_set) 1)
        (objects_manage_1)
    )
    (sleep_until (>= (current_zone_set) 2) 1)
    (sleep 1)
    (if (= (current_zone_set) 2)
        (objects_manage_2)
    )
    (sleep_until (>= (current_zone_set) 3) 1)
    (sleep 1)
    (if (= (current_zone_set) 3)
        (objects_manage_3)
    )
    (sleep_until (>= (current_zone_set) 4) 1)
    (sleep 1)
    (if (= (current_zone_set) 4)
        (objects_manage_4a)
    )
    (sleep_until (>= (current_zone_set) 5) 1)
    (sleep 1)
    (if (= (current_zone_set) 5)
        (objects_manage_5)
    )
)

(script static void objects_manage_0
    (print "no objects to destroy")
    (object_create_folder "dm_010")
    (object_create_folder "dc_010")
    (object_create_folder "eq_010")
    (object_create_folder "wp_010")
    (object_create_folder "bp_010")
    (object_create_folder "sc_010")
    (object_create_folder "cr_010")
    (object_create_folder "dm_020")
    (object_create_folder "dc_020")
    (object_create_folder "eq_020")
    (object_create_folder "wp_020")
    (object_create_folder "bp_020")
    (object_create_folder "sc_020")
    (object_create_folder "cr_020")
    (sleep 1)
    (setup_010_bodies)
    (setup_020_bodies)
)

(script static void objects_manage_1
    (print "no objects to destroy")
    (sleep_until (= (current_zone_set_fully_active) 1) 1)
    (object_create_folder "dm_030")
    (object_create_folder "dc_030")
    (object_create_folder "eq_030")
    (object_create_folder "wp_030")
    (object_create_folder "bp_030")
    (object_create_folder "sc_030")
    (object_create_folder "cr_030")
    (sleep 1)
    (setup_030_bodies)
)

(script static void objects_manage_2
    (object_destroy_folder "dm_010")
    (object_destroy_folder "dc_010")
    (object_destroy_folder "eq_010")
    (object_destroy_folder "wp_010")
    (object_destroy_folder "bp_010")
    (object_destroy_folder "sc_010")
    (object_destroy_folder "cr_010")
    (object_destroy_folder "dm_020")
    (object_destroy_folder "dc_020")
    (object_destroy_folder "eq_020")
    (object_destroy_folder "wp_020")
    (object_destroy_folder "bp_020")
    (object_destroy_folder "sc_020")
    (object_destroy_folder "cr_020")
    (sleep_until (= (current_zone_set_fully_active) 2) 1)
    (object_create_folder "dm_040")
    (object_create_folder "dc_040")
    (object_create_folder "eq_040")
    (object_create_folder "wp_040")
    (object_create_folder "bp_040")
    (object_create_folder "sc_040")
    (object_create_folder "cr_040")
    (sleep 1)
    (setup_030_bodies)
    (setup_040_bodies)
)

(script static void objects_manage_3
    (object_destroy_folder "dm_030")
    (object_destroy_folder "dc_030")
    (object_destroy_folder "eq_030")
    (object_destroy_folder "wp_030")
    (object_destroy_folder "bp_030")
    (object_destroy_folder "sc_030")
    (object_destroy_folder "cr_030")
    (sleep_until (= (current_zone_set_fully_active) 3) 1)
    (object_create_folder "atrium_elevator")
    (object_create_folder "dm_050")
    (object_create_folder "dc_050")
    (object_create_folder "eq_050")
    (object_create_folder "wp_050")
    (object_create_folder "bp_050")
    (object_create_folder "sc_050")
    (object_create_folder "cr_050")
    (object_create_folder "ve_050")
    (sleep 1)
    (setup_050_bodies)
)

(script static void objects_manage_4a
    (object_destroy_folder "dm_040")
    (object_destroy_folder "dc_040")
    (object_destroy_folder "eq_040")
    (object_destroy_folder "wp_040")
    (object_destroy_folder "bp_040")
    (object_destroy_folder "sc_040")
    (object_destroy_folder "cr_040")
    (object_destroy_folder "dm_050")
    (object_destroy_folder "dc_050")
    (object_destroy_folder "eq_050")
    (object_destroy_folder "wp_050")
    (object_destroy_folder "bp_050")
    (object_destroy_folder "sc_050")
    (object_destroy_folder "cr_050")
    (object_destroy_folder "ve_050")
    (sleep_until (= (current_zone_set_fully_active) 4) 1)
    (object_create_folder "atrium_elevator")
    (object_create_folder "dm_070")
    (object_create_folder "dm_070_lobby")
    (object_create_folder "dc_070")
    (object_create_folder "eq_070")
    (object_create_folder "wp_070")
    (object_create_folder "sc_070")
    (object_create_folder "sc_070_lobby")
    (object_create_folder "cr_070")
    (sleep 1)
    (setup_070_bodies)
)

(script static void objects_manage_4b
    (object_destroy_folder "dm_070")
    (object_destroy_folder "dc_070")
    (object_destroy_folder "eq_070")
    (object_destroy_folder "wp_070")
    (object_destroy_folder "sc_070")
    (object_destroy_folder "cr_070")
    (sleep_until (= (current_zone_set_fully_active) 4) 1)
    (object_create_folder "dm_080")
    (object_create_folder "dc_080")
    (object_create_folder "eq_080")
    (object_create_folder "wp_080")
    (object_create_folder "bp_080")
    (object_create_folder "sc_080")
    (object_create_folder "cr_080")
    (sleep 1)
    (setup_080_bodies)
)

(script static void objects_manage_5
    (object_destroy_folder "dm_070")
    (object_destroy_folder "dc_070")
    (object_destroy_folder "eq_070")
    (object_destroy_folder "wp_070")
    (object_destroy_folder "sc_070")
    (object_destroy_folder "cr_070")
    (object_destroy_folder "dm_080")
    (object_destroy_folder "dc_080")
    (object_destroy_folder "eq_080")
    (object_destroy_folder "wp_080")
    (object_destroy_folder "bp_080")
    (object_destroy_folder "sc_080")
    (object_destroy_folder "cr_080")
    (sleep_until (= (current_zone_set_fully_active) 5) 1)
    (object_create_folder "dm_090")
    (object_create_folder "dc_090")
    (object_create_folder "eq_090")
    (object_create_folder "wp_090")
    (object_create_folder "bp_090")
    (object_create_folder "sc_090")
    (object_create_folder "cr_090")
    (sleep 1)
    (setup_090_bodies)
)

(script static void objects_destroy_all
    (print "destroying all objects")
    (object_destroy_folder "dm_010")
    (object_destroy_folder "dc_010")
    (object_destroy_folder "eq_010")
    (object_destroy_folder "wp_010")
    (object_destroy_folder "bp_010")
    (object_destroy_folder "sc_010")
    (object_destroy_folder "cr_010")
    (object_destroy_folder "dm_020")
    (object_destroy_folder "dc_020")
    (object_destroy_folder "eq_020")
    (object_destroy_folder "wp_020")
    (object_destroy_folder "bp_020")
    (object_destroy_folder "sc_020")
    (object_destroy_folder "cr_020")
    (object_destroy_folder "dm_030")
    (object_destroy_folder "dc_030")
    (object_destroy_folder "eq_030")
    (object_destroy_folder "wp_030")
    (object_destroy_folder "bp_030")
    (object_destroy_folder "sc_030")
    (object_destroy_folder "cr_030")
    (object_destroy_folder "dm_040")
    (object_destroy_folder "dc_040")
    (object_destroy_folder "eq_040")
    (object_destroy_folder "wp_040")
    (object_destroy_folder "bp_040")
    (object_destroy_folder "sc_040")
    (object_destroy_folder "cr_040")
    (object_destroy_folder "dm_050")
    (object_destroy_folder "dc_050")
    (object_destroy_folder "eq_050")
    (object_destroy_folder "wp_050")
    (object_destroy_folder "bp_050")
    (object_destroy_folder "sc_050")
    (object_destroy_folder "cr_050")
    (object_destroy_folder "dm_070")
    (object_destroy_folder "dc_070")
    (object_destroy_folder "eq_070")
    (object_destroy_folder "wp_070")
    (object_destroy_folder "sc_070")
    (object_destroy_folder "cr_070")
    (object_destroy_folder "dm_080")
    (object_destroy_folder "dc_080")
    (object_destroy_folder "eq_080")
    (object_destroy_folder "wp_080")
    (object_destroy_folder "bp_080")
    (object_destroy_folder "sc_080")
    (object_destroy_folder "cr_080")
    (object_destroy_folder "dm_090")
    (object_destroy_folder "dc_090")
    (object_destroy_folder "eq_090")
    (object_destroy_folder "wp_090")
    (object_destroy_folder "bp_090")
    (object_destroy_folder "sc_090")
    (object_destroy_folder "cr_090")
)

(script static void setup_010_bodies
    (print "setup_010_bodies")
    (scenery_animation_start "sc_panoptical_civilian_fm1" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm2" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm3" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_fm4" "objects\characters\civilian_female\civilian_female" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_fm5" "objects\characters\civilian_female\civilian_female" "deadbody_09")
    (scenery_animation_start "sc_panoptical_civilian_fm6" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm7" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_fm8" "objects\characters\civilian_female\civilian_female" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_fm9" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm10" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm11" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_fm12" "objects\characters\civilian_female\civilian_female" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_fm13" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm14" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm15" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_fm16" "objects\characters\civilian_female\civilian_female" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_fm17" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm18" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm19" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_fm20" "objects\characters\civilian_female\civilian_female" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_fm21" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm22" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_fm23" "objects\characters\civilian_female\civilian_female" "deadbody_10")
    (scenery_animation_start "sc_panoptical_civilian_fm24" "objects\characters\civilian_female\civilian_female" "deadbody_06")
    (scenery_animation_start "sc_panoptical_civilian_fm25" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_fm26" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_m1" "objects\characters\marine\marine" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_m2" "objects\characters\marine\marine" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_m3" "objects\characters\marine\marine" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_m4" "objects\characters\marine\marine" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_m5" "objects\characters\marine\marine" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_m6" "objects\characters\marine\marine" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_m7" "objects\characters\marine\marine" "deadbody_12")
    (scenery_animation_start "sc_panoptical_civilian_m8" "objects\characters\marine\marine" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_m9" "objects\characters\marine\marine" "deadbody_10")
    (scenery_animation_start "sc_panoptical_civilian_m10" "objects\characters\marine\marine" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_m11" "objects\characters\marine\marine" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_m12" "objects\characters\marine\marine" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_m13" "objects\characters\marine\marine" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_m14" "objects\characters\marine\marine" "deadbody_02")
    (scenery_animation_start "sc_panoptical_civilian_m16" "objects\characters\marine\marine" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_m17" "objects\characters\marine\marine" "deadbody_09")
    (scenery_animation_start "sc_panoptical_civilian_m18" "objects\characters\marine\marine" "deadbody_14")
    (scenery_animation_start "sc_panoptical_civilian_m19" "objects\characters\marine\marine" "deadbody_03")
    (scenery_animation_start "sc_panoptical_civilian_m20" "objects\characters\marine\marine" "deadbody_05")
    (scenery_animation_start "sc_panoptical_civilian_m21" "objects\characters\marine\marine" "deadbody_01")
    (scenery_animation_start "sc_panoptical_civilian_m22" "objects\characters\marine\marine" "deadbody_13")
    (scenery_animation_start "sc_panoptical_civilian_m23" "objects\characters\marine\marine" "deadbody_08")
    (scenery_animation_start "sc_panoptical_civilian_m24" "objects\characters\marine\marine" "deadbody_04")
    (scenery_animation_start "sc_panoptical_civilian_m25" "objects\characters\marine\marine" "deadbody_15")
)

(script static void setup_020_bodies
    (print "setup_020_bodies")
    (scenery_animation_start "sc_towers_civilian_fm1" "objects\characters\civilian_female\civilian_female" "deadbody_09")
    (scenery_animation_start "sc_towers_civilian_m0" "objects\characters\marine\marine" "e3_deadbody_02")
)

(script static void setup_030_bodies
    (print "setup_030_bodies")
)

(script static void setup_040_bodies
    (print "setup_040_bodies")
)

(script static void setup_050_bodies
    (print "setup_050_bodies")
)

(script static void setup_070_bodies
    (print "setup_070_bodies")
    (scenery_animation_start "sc_ready_civilian_fm1" "objects\characters\civilian_female\civilian_female" "deadbody_01")
    (scenery_animation_start "sc_ready_civilian_fm2" "objects\characters\civilian_female\civilian_female" "deadbody_02")
    (scenery_animation_start "sc_ready_civilian_fm3" "objects\characters\civilian_female\civilian_female" "deadbody_03")
    (scenery_animation_start "sc_ready_civilian_m1" "objects\characters\marine\marine" "deadbody_01")
    (scenery_animation_start "sc_ready_civilian_m2" "objects\characters\marine\marine" "deadbody_02")
    (scenery_animation_start "sc_ready_civilian_m3" "objects\characters\marine\marine" "deadbody_03")
    (scenery_animation_start "sc_ready_civilian_m4" "objects\characters\marine\marine" "deadbody_04")
)

(script static void setup_080_bodies
    (print "setup_080_bodies")
)

(script static void setup_090_bodies
    (print "setup_090_bodies")
)

(script static void create_all
    (object_create_folder "dm_010")
    (object_create_folder "dc_010")
    (object_create_folder "eq_010")
    (object_create_folder "wp_010")
    (object_create_folder "bp_010")
    (object_create_folder "sc_010")
    (object_create_folder "cr_010")
    (object_create_folder "dm_020")
    (object_create_folder "dc_020")
    (object_create_folder "eq_020")
    (object_create_folder "wp_020")
    (object_create_folder "bp_020")
    (object_create_folder "sc_020")
    (object_create_folder "cr_020")
    (object_create_folder "dm_030")
    (object_create_folder "dc_030")
    (object_create_folder "eq_030")
    (object_create_folder "wp_030")
    (object_create_folder "bp_030")
    (object_create_folder "sc_030")
    (object_create_folder "cr_030")
    (object_create_folder "dm_040")
    (object_create_folder "dc_040")
    (object_create_folder "eq_040")
    (object_create_folder "wp_040")
    (object_create_folder "bp_040")
    (object_create_folder "sc_040")
    (object_create_folder "cr_040")
    (object_create_folder "dm_070")
    (object_create_folder "dc_070")
    (object_create_folder "eq_070")
    (object_create_folder "wp_070")
    (object_create_folder "sc_070")
    (object_create_folder "cr_070")
    (object_create_folder "dm_080")
    (object_create_folder "dc_080")
    (object_create_folder "eq_080")
    (object_create_folder "wp_080")
    (object_create_folder "bp_080")
    (object_create_folder "sc_080")
    (object_create_folder "cr_080")
    (object_create_folder "dm_090")
    (object_create_folder "dc_090")
    (object_create_folder "eq_090")
    (object_create_folder "wp_090")
    (object_create_folder "bp_090")
    (object_create_folder "sc_090")
    (object_create_folder "cr_090")
    (setup_010_bodies)
    (setup_020_bodies)
    (setup_030_bodies)
    (setup_040_bodies)
    (setup_050_bodies)
    (setup_070_bodies)
    (setup_080_bodies)
    (setup_090_bodies)
    (setup_090_bodies)
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

(script static void 1
    (if ai_render_sector_bsps
        (set ai_render_sector_bsps false)
        (set ai_render_sector_bsps true)
    )
)

(script static void 2
    (if ai_render_objectives
        (set ai_render_objectives false)
        (set ai_render_objectives true)
    )
)

(script static void 3
    (if ai_render_decisions
        (set ai_render_decisions false)
        (set ai_render_decisions true)
    )
)

(script static void 4
    (if ai_render_command_scripts
        (set ai_render_command_scripts false)
        (set ai_render_command_scripts true)
    )
)

(script static void 5
    (if debug_performances
        (set debug_performances false)
        (set debug_performances true)
    )
)

(script static void 6
    (if debug_instanced_geometry_cookie_cutters
        (set debug_instanced_geometry_cookie_cutters false)
        (set debug_instanced_geometry_cookie_cutters true)
    )
)

(script static void cin_outro
    (f_end_mission "050lb_reunited" "cin_outro_reunited")
)

(script dormant void ct_title_act1
    (sleep (* 30 2))
    (f_hud_chapter "ct_act1")
)

(script dormant void ct_title_act2
    (sleep_until (>= objcon_ready 40))
    (f_hud_chapter "ct_act2")
)

(script dormant void ct_title_act3
    (sleep_until (or (player_in_vehicle (ai_vehicle_get "ride_falcon/pilot")) (player_in_vehicle (ai_vehicle_get "ride_falcon0/pilot"))) 5)
    (sleep (* 30 5))
    (f_hud_chapter "ct_act3")
)

(script dormant void ct_objective_link_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_link_up" "primary_objective_1")
)

(script dormant void ct_objective_link_complete
    (sleep objective_delay)
    (f_hud_start_menu_obj "primary_objective_1")
)

(script dormant void ct_objective_traxus_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_traxus" "primary_objective_2")
)

(script dormant void ct_objective_elevator_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_advance_atrium" "primary_objective_3")
)

(script dormant void ct_objective_defend_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_defend_atrium" "primary_objective_4")
)

(script dormant void ct_objective_defend_complete
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_activate_elevator" "primary_objective_5")
)

(script dormant void ct_objective_elevator_complete
    (sleep objective_delay)
    (f_hud_start_menu_obj "primary_objective_2")
)

(script dormant void ct_objective_jetpack_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_jetpack" "primary_objective_6")
)

(script dormant void ct_objective_cargo_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_cargo" "primary_objective_7")
)

(script dormant void ct_training_ui_jetpack3
    (sleep_until (unit_has_equipment (player3) "objects\equipment\jet_pack\jet_pack.equipment"))
    (f_hud_training_confirm player3 "ct_training_jetpack" "equipment")
)

(script dormant void ct_training_ui_jetpack2
    (sleep_until (unit_has_equipment (player2) "objects\equipment\jet_pack\jet_pack.equipment"))
    (f_hud_training_confirm player2 "ct_training_jetpack" "equipment")
)

(script dormant void ct_training_ui_jetpack1
    (sleep_until (unit_has_equipment (player1) "objects\equipment\jet_pack\jet_pack.equipment"))
    (f_hud_training_confirm player1 "ct_training_jetpack" "equipment")
)

(script dormant void ct_training_ui_jetpack0
    (sleep_until (unit_has_equipment (player0) "objects\equipment\jet_pack\jet_pack.equipment"))
    (f_hud_training_confirm player0 "ct_training_jetpack" "equipment")
)

(script dormant void ct_objective_tower_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_advance_traxus" "primary_objective_8")
)

(script dormant void ct_objective_capture_pad
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_landing_pad" "primary_objective_9")
)

(script dormant void ct_objective_capture_pad_complete
    (sleep objective_delay)
    (f_hud_obj_complete)
)

(script dormant void ct_objective_traxus_complete
    (sleep objective_delay)
    (f_hud_obj_complete)
)

(script dormant void ct_objective_transport_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_transports" "primary_objective_10")
)

(script dormant void ct_objective_missiles_start
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_arm_missiles" "primary_objective_11")
)

(script dormant void ct_objective_arm_complete
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_fire_missiles" "primary_objective_12")
)

(script dormant void ct_objective_missiles_complete
    (sleep objective_delay)
    (mus_stop mus_08)
    (f_hud_obj_complete)
)

(script dormant void hud_flash_tower
    (f_blip_object "highlight_tower_box" blip_destination)
    (sleep_until (objects_can_see_object player0 "highlight_tower_box" 10) 5 (* 30 15))
    (f_hud_flash_object "sc_ui_highlight_tower")
    (f_unblip_object "highlight_tower_box")
)

(script dormant void hud_flash_evac
    (f_blip_object "highlight_evac_box" blip_destination)
    (sleep_until (objects_can_see_object player0 "highlight_evac_box" 10) 5 (* 30 30))
    (f_hud_flash_object "sc_ui_highlight_evac")
    (f_unblip_object "highlight_evac_box")
)

(script dormant void hud_flash_evac0
    (f_blip_object "highlight_evac0_box" blip_destination)
    (sleep_until (objects_can_see_object player0 "highlight_evac0_box" 10) 5 (* 30 30))
    (f_hud_flash_object "sc_ui_highlight_evac")
    (f_unblip_object "highlight_evac0_box")
)

(script static void (md_play_debug (short delay, string line))
    (if dialogue
        (print line)
    )
    (sleep delay)
)

(script static void (md_print (string line))
    (if dialogue
        (print line)
    )
)

(script static void md_prep
    (sleep_until (not b_md_is_playing) 1)
    (set b_md_is_playing true)
)

(script static void md_finished
    (set b_md_is_playing false)
)

(script dormant void md_amb_traxus01
    (md_prep)
    (sleep (random_range (* 30 2) (* 30 3)))
    (md_print "this is kilo dispatch.  all available teams advance to traxus tower.  evacuation will commence a-sap.")
    (f_md_object_play 0 none m50_0010)
    (md_print "copy, dispatch.  what's the status of the tower pad?")
    (f_md_object_play 30 none m50_0020)
    (md_print "tower pad is green.  let's move these civilians before it changes.")
    (f_md_object_play 30 none m50_0030)
    (md_print "solid copy, dispatch.  four zero out.")
    (f_md_object_play 30 none m50_0040)
    (md_finished)
    (wake hud_flash_tower)
    (wake ct_objective_link_start)
)

(script dormant void md_amb_bombers
    (sleep_until (volume_test_players "tv_md_bombers") 1)
    (md_prep)
    (md_print "romeo company, be advised we have reports of covenant suicide squads.")
    (f_md_object_play 0 none m50_0050)
    (md_print "you gotta be kiddin' me...")
    (f_md_object_play 30 none m50_0060)
    (md_print "negative.  keep your eyes open, troopers.")
    (f_md_object_play 30 none m50_0070)
    (md_finished)
    (mus_stop mus_01)
)

(script dormant void md_amb_cruiser01
    (sleep_until (volume_test_players "tv_md_cruiser_start"))
    (md_prep)
    (md_print "kilo two six, this is kilo four zero.  covenant corvette's raining hell on us.  final protective fire one, danger close, my command, over.")
    (f_md_object_play 0 none m50_0080)
    (md_print "copy, kilo four zero.  firing fpf one at your command.")
    (f_md_object_play 30 none m50_0090)
    (md_finished)
    (sleep_until (volume_test_players "tv_md_cruiser_shot01") 1)
    (md_prep)
    (md_print "fire fpf one, over.")
    (f_md_object_play 0 none m50_0100)
    (md_print "firing fpf one... shot...")
    (f_md_object_play 30 none m50_0110)
    (md_print "hold onto your helmets --")
    (f_md_object_play 30 none m50_0120)
    (md_finished)
    (snd_play "sound\weapons\mac_gun\mac_gun_m50\mac_gun_m50.sound")
    (sleep 66)
    (snd_play "sound\levels\120_halo\trench_run\island_creak.sound")
    (cam_shake 0.2 1 3)
    (interpolator_start "base_bombing")
    (cs_run_command_script "cov.interior.grunts.1" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.2" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3c" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4c" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5c" cs_wakeup)
    (sleep_until (volume_test_players "tv_md_cruiser_shot02") 1)
    (md_prep)
    (md_print "kilo four zero, request fpf sitrep!")
    (f_md_object_play 0 none m50_0130)
    (md_print "negative, two six -- corvette's still coming!")
    (f_md_object_play 30 none m50_0140)
    (md_print "copy, four zero, firing fpf two... shot")
    (f_md_object_play 30 none m50_0150)
    (md_finished)
    (snd_play "sound\weapons\mac_gun\mac_gun_m50\mac_gun_m50.sound")
    (sleep 66)
    (snd_play "sound\levels\120_halo\trench_run\island_creak.sound")
    (cam_shake 0.2 1 3)
    (interpolator_start "base_bombing")
    (cs_run_command_script "cov.interior.grunts.1" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.2" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.3c" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.4c" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5a" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5b" cs_wakeup)
    (cs_run_command_script "cov.interior.grunts.5c" cs_wakeup)
    (sleep (random_range 150 210))
    (md_prep)
    (md_print "damn it, how do you stop that thing...?")
    (f_md_object_play 0 none m50_0160)
    (md_finished)
)

(script dormant void md_canyonview_civilian_intro
    (vs_cast "cv_civilians_near0" false 10 "m50_0170" "m50_0180")
    (set civilian1 (vs_role 1))
    (set f_civilian1 (vs_role 2))
    (vs_cast "cv_unsc_echo_inf0" false 10 "m50_0190")
    (set trooper4 (vs_role 1))
    (md_prep)
    (md_print "help!  somebody help us!")
    (f_md_ai_play 0 civilian1 m50_0170)
    (md_print "they're coming!  they're after us!")
    (f_md_ai_play 30 f_civilian1 m50_0180)
    (md_print "come on, lets go!")
    (f_md_ai_play 30 trooper4 m50_0190)
    (md_print "what are those things?!?")
    (f_md_ai_play 30 civilian1 m50_0200)
    (md_print "brutes! move to cover!")
    (f_md_ai_play 30 trooper4 m50_0210)
    (md_finished)
)

(script dormant void md_canyonview_marine_intro
    (vs_cast "cv_unsc_echo_inf1" false 10 "m50_0220")
    (set trooper1 (vs_role 1))
    (md_prep)
    (md_print "evac team seven to kilo two six.  we have eyes on traxus tower.")
    (f_md_ai_play 0 trooper1 m50_0220)
    (md_print "copy, evac seven.  move to assist the evac, over.")
    (f_md_object_play 30 none m50_0230)
    (md_finished)
    (wake ct_objective_traxus_start)
)

(script dormant void md_cv_trooper_intro
    (sleep_until (or (cv_player_near_troopers) (>= objcon_canyonview 40)))
    (vs_cast "cv_unsc_echo_inf0" false 10 "m50_0270")
    (set female_trooper1 (vs_role 1))
    (md_prep)
    (md_print "picked up a friendly!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 0 trooper1 m50_0250)
        (f_md_object_play 0 none m50_0250)
    )
    (if (player_has_female_voice player0)
        (begin
            (md_print "a spartan?  where the hell'd she come from?")
            (if (>= (ai_living_count female_trooper1) 1)
                (f_md_ai_play 0 female_trooper1 m50_0270)
                (f_md_object_play 30 none m50_0270)
            )
        )
        (begin
            (md_print "a spartan?  where the hell'd he come from?")
            (if (>= (ai_living_count female_trooper1) 1)
                (f_md_ai_play 0 female_trooper1 m50_0260)
                (f_md_object_play 0 none m50_0260)
            )
        )
    )
    (md_print "who cares? spartan, assist!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 0 trooper1 m50_0280)
        (f_md_object_play 0 none m50_0280)
    )
    (md_finished)
    (if (not (game_is_cooperative))
        (begin
            (ai_player_add_fireteam_squad player0 "cv_unsc_echo_inf0")
            (ai_player_add_fireteam_squad player0 "cv_unsc_echo_inf1")
        )
    )
    (wake ct_objective_link_complete)
    (wake md_canyonview_marine_intro)
    (wake md_cv_how_to)
)

(script dormant void md_cv_how_to
    (sleep_until (or (<= (ai_task_count "obj_canyonview_cov/gate_main") 0) (= b_cv_counter_started true)))
    (sleep (* 30 2))
    (md_prep)
    (md_print "how do we get to the tower?")
    (if (>= (ai_living_count female_trooper1) 1)
        (f_md_ai_play 0 female_trooper1 m50_0290)
        (f_md_object_play 0 none m50_0290)
    )
    (md_print "elevator in the atrium goes down to the cargo port; cargo port goes to the tower!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 30 trooper1 m50_0300)
        (f_md_object_play 30 none m50_0300)
    )
    (md_print "gotta get in there...")
    (if (>= (ai_living_count female_trooper1) 1)
        (f_md_ai_play 0 female_trooper1 m50_0330)
        (f_md_object_play 0 none m50_0330)
    )
    (sleep 60)
    (md_print "whoa!  contacts!  from the west!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 0 trooper1 m50_0240)
        (f_md_object_play 0 none m50_0240)
    )
    (md_finished)
)

(script dormant void md_cv_encounter_complete
    (md_prep)
    (md_print "okay, let's move in and find that elevator!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 0 trooper1 m50_0340)
        (f_md_object_play 0 none m50_0340)
    )
    (md_finished)
    (wake ct_objective_elevator_start)
)

(script dormant void md_atrium_elevator_call
    (sleep_until (> (device_get_position "atrium_elevator_call") 0) 1)
    (sleep (random_range (* 30 4) (* 30 6)))
    (begin
        (vs_cast "atrium_unsc_troopers" false 10 "m50_0460")
        (set trooper1 (vs_role 1))
        (md_prep)
        (md_print "what the hell's taking this thing so long?")
        (if (>= (ai_living_count trooper1) 1)
            (f_md_ai_play 0 trooper1 m50_0460)
            (f_md_object_play 0 none m50_0460)
        )
    )
    (md_print "we're evacuating a group civilians on the floor below you.  soon as they reach the cargo port, i'll send the elevator back up.")
    (f_md_object_play 30 none m50_0470)
    (md_finished)
    (sleep_until b_atrium_counterattack_started)
    (begin
        (md_prep)
        (md_print "ok, everyone find some cover, stay sharp.  we need to hold this position!")
        (if (>= (ai_living_count trooper1) 1)
            (f_md_ai_play 30 trooper1 m50_0490)
            (f_md_object_play 30 none m50_0490)
        )
        (md_finished)
        (sleep (* 30 2))
        (wake ct_objective_defend_start)
        (set b_md_defend_complete true)
    )
)

(script dormant void md_atrium_counterattack
    (sleep_until (> (ai_task_count "obj_atrium_cov/gate_counterattack") 0) 1)
    (if (and (> (ai_task_count "obj_atrium_unsc/gate_main") 0) (not b_atrium_complete))
        (begin
            (sleep (* 30 7))
            (md_prep)
            (md_print "dropships!  deploying to the courtyards!  watch your flanks!")
            (if (>= (ai_living_count trooper1) 1)
                (f_md_ai_play 0 trooper1 m50_0510)
                (f_md_object_play 0 none m50_0510)
            )
            (md_finished)
        )
    )
)

(script dormant void md_atrium_hunters_arrive
    (sleep_until (or (volume_test_object "tv_music_atrium0" "atrium_cov_captain0") (volume_test_object "tv_music_atrium0" "atrium_cov_captain1") (>= (ai_combat_status "atrium_cov_captain0") 8) (>= (ai_combat_status "atrium_cov_captain1") 8)) 5)
    (mus_layer_start mus_03 1)
)

(script dormant void md_atrium_hunters_defeated
    (sleep_until (= b_atrium_complete true))
    (wake ct_objective_defend_complete)
    (md_prep)
    (md_print "damn, lieutenant -- glad you're on our side!  let's hop that elevator and get to the tower!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 30 trooper1 m50_0530)
        (f_md_object_play 30 none m50_0530)
    )
    (md_finished)
)

(script dormant void md_traxus_ai01
    (sleep_until (volume_test_players "tv_md_traxus_entrance") 1)
    (md_prep)
    (md_print "welcome -- to traxus heavy industries.  traxus: getting you there is half the battle.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0410_tra" none 1)
    (md_finished)
)

(script dormant void md_traxus_ai02
    (md_prep)
    (md_print "welcome -- to traxus heavy industries.  traxus: the sky's no limit.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0420_tra" none 1)
    (md_finished)
)

(script dormant void md_traxus_evac_loop
    (sleep_until (volume_test_players "tv_md_traxus_evac_start") 1)
    (sleep_until 
        (begin
            (md_traxus_evac)
            (sleep (* 30 180))
            b_ready_started
        )
    )
)

(script static void md_traxus_evac
    (md_prep)
    (md_print "evacuation in process.  please move to the nearest exit.  thank you for your cooperation.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0430_tra" none 1)
    (md_finished)
)

(script dormant void md_traxus_ai04
    (md_prep)
    (md_print "traxus directory.  wherever you're going, traxus takes you there.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0450_tra" none 1)
    (md_finished)
)

(script dormant void md_traxus_ai_elevator
    (sleep_until (volume_test_players "tv_md_traxus_elevator") 1)
    (md_prep)
    (md_print "going down. cargo port and traxus tower.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0500_tra" none 1)
    (md_finished)
)

(script static void md_play_info_booth
    (md_prep)
    (md_print "traxus directory.  wherever you're going, traxus takes you there.")
    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0450_tra" none 1)
    (md_finished)
    (set md_atruim_ai (+ md_atruim_ai 1))
)

(script dormant void md_atrium_ai_response
    (sleep_until (and (not b_atrium_counterattack_started) (>= md_atruim_ai 3)) 5)
    (md_prep)
    (md_print "somebody shut that damn thing off!")
    (if (>= (ai_living_count trooper1) 1)
        (f_md_ai_play 0 trooper1 m50_0440)
        (f_md_object_play 0 none m50_0440)
    )
    (md_finished)
    (set md_atruim_ai_delay (+ md_atruim_ai_delay 500))
)

(script dormant void md_info_booth
    (sleep_until 
        (begin
            (if (and (volume_test_players "tv_info_screen_02") (>= (object_get_health "sc_info_booth_02") 1))
                (begin
                    (set g_location "sc_info_booth_02")
                    (md_play_info_booth)
                    (sleep md_atruim_ai_delay)
                )
                (if (and (volume_test_players "tv_info_screen_03") (>= (object_get_health "sc_info_booth_03") 1))
                    (begin
                        (set g_location "sc_info_booth_03")
                        (md_play_info_booth)
                        (sleep md_atruim_ai_delay)
                    )
                    (if (and (volume_test_players "tv_info_screen_04") (>= (object_get_health "sc_info_booth_04") 1))
                        (begin
                            (set g_location "sc_info_booth_04")
                            (md_play_info_booth)
                            (sleep md_atruim_ai_delay)
                        )
                        (if (and (volume_test_players "tv_info_screen_05") (>= (object_get_health "sc_info_booth_05") 1))
                            (begin
                                (set g_location "sc_info_booth_05")
                                (md_play_info_booth)
                                (sleep md_atruim_ai_delay)
                            )
                            (if (and (volume_test_players "tv_info_screen_06") (>= (object_get_health "sc_info_booth_06") 1))
                                (begin
                                    (set g_location "sc_info_booth_06")
                                    (md_play_info_booth)
                                    (sleep md_atruim_ai_delay)
                                )
                                (if (and (volume_test_players "tv_info_screen_07") (>= (object_get_health "sc_info_booth_07") 1))
                                    (begin
                                        (set g_location "sc_info_booth_07")
                                        (md_play_info_booth)
                                        (sleep md_atruim_ai_delay)
                                    )
                                    (if (not b_atrium_complete)
                                        (begin
                                            (if (<= md_atruim_ai 0)
                                                (begin
                                                    (md_prep)
                                                    (md_print "welcome -- to traxus heavy industries.  traxus: getting you there is half the battle.")
                                                    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0410_tra" none 1)
                                                    (set md_atruim_ai (+ md_atruim_ai 1))
                                                    (md_finished)
                                                    (sleep md_atruim_ai_delay)
                                                )
                                                (begin
                                                    (md_prep)
                                                    (md_print "evacuation in process.  please move to the nearest exit.  thank you for your cooperation.")
                                                    (sound_impulse_start "sound\dialog\levels\m50\mission\m50_0430_tra" none 1)
                                                    (set md_atruim_ai (+ md_atruim_ai 1))
                                                    (md_finished)
                                                    (sleep md_atruim_ai_delay)
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
            b_atrium_counterattack_started
        )
    )
)

(script dormant void md_ready_intro
    (wake ct_objective_elevator_complete)
    (vs_cast "atrium_unsc_elevator" false 10 "m50_0540")
    (set trooper_sgt1 (vs_role 1))
    (md_prep)
    (md_print "if you're trying to get to the tower, you're too late, lieutenant -- corvette over the starport pounded the hell out of the place.  cargo port is impassable on foot; rooftop evac's a wash.")
    (f_md_object_play 0 none m50_0540)
    (md_print "we could use the executive landing pad except there's no easy way to get there.")
    (f_md_object_play 30 none m50_0550)
    (md_print "a group of odst specialists are working a plan. they might appreciate some back-up.")
    (f_md_object_play 30 none m50_0560)
    (md_finished)
)

(script dormant void md_ready_outside_door
    (md_prep)
    (md_print "other side of the hall there, lieutenant -- right through triage.")
    (if (>= (ai_living_count trooper4) 1)
        (f_md_ai_play 0 trooper4 m50_0570)
        (f_md_object_play 0 none m50_0570)
    )
    (md_finished)
)

(script dormant void md_ready_odst_intro
    (md_prep)
    (if (player_has_female_voice player0)
        (begin
            (vs_cast "unsc_jl_odsts" false 10 "m50_0600")
            (set trooper5_odst2 (vs_role 1))
            (md_print "there she is -- the one they were talking about")
            (if (>= (ai_living_count trooper5_odst2) 1)
                (f_md_ai_play 0 trooper5_odst2 m50_0600)
            )
        )
        (begin
            (vs_cast "unsc_jl_odsts" false 10 "m50_0590")
            (set trooper5_odst2 (vs_role 1))
            (md_print "there he is -- the one they were talking about")
            (if (>= (ai_living_count trooper5_odst2) 1)
                (f_md_ai_play 0 trooper5_odst2 m50_0590)
            )
        )
    )
    (md_finished)
)

(script dormant void md_ready_odst_intro2
    (vs_cast "unsc_jl_odsts" false 10 "m50_0610")
    (set trooper3_odst1 (vs_role 1))
    (md_prep)
    (md_print "radio's buzzing about you, spartan.  you feel like jumping?")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0610)
    )
    (device_set_position "dm_ready_door1" 1)
    (device_set_position "dm_ready_door2" 1)
    (md_print "we've got an extra jetpack")
    (if (>= (ai_living_count trooper5_odst2) 1)
        (f_md_ai_play 30 trooper5_odst2 m50_0640)
    )
    (md_print "go ahead. try it on, spartan.")
    (if (>= (ai_living_count trooper5_odst2) 1)
        (f_md_ai_play 30 trooper5_odst2 m50_0650)
    )
    (md_finished)
    (wake ct_objective_jetpack_start)
)

(script dormant void md_ready_player_get_jetpack
    (md_prep)
    (md_print "welcome to the bullfrogs!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0700)
        (f_md_object_play 0 none m50_0700)
    )
    (md_finished)
    (wake ct_objective_cargo_start)
    (if (not (game_is_cooperative))
        (begin
            (ai_player_add_fireteam_squad player0 "unsc_jl_odsts")
            (ai_player_add_fireteam_squad player0 "unsc_jl_odsts1")
        )
    )
)

(script dormant void md_jp_doors_open
    (md_prep)
    (md_print "other side, on my mark.  three!  two!  one!  jump!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0710)
    )
    (md_finished)
)

(script dormant void md_jp_other_side
    (md_prep)
    (md_print "we gotta get to the other side of the cargo port!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0890)
        (f_md_object_play 0 none m50_0890)
    )
    (md_finished)
)

(script dormant void md_jp_player_crosses
    (md_prep)
    (md_print "we're gonna capture the landing pad on the executive wing, so the evac birds can land!  try and keep up, spartan!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0720)
        (f_md_object_play 0 none m50_0720)
    )
    (md_finished)
    (wake hud_flash_evac0)
)

(script dormant void md_jp_keep_moving01
    (md_prep)
    (md_print "keep it moving toward that pad!  ")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0830)
        (f_md_object_play 0 none m50_0830)
    )
    (md_finished)
)

(script dormant void md_jp_keep_moving02
    (md_prep)
    (md_print "keep jumping!  go, go, go!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0840)
        (f_md_ai_play 0 none m50_0840)
    )
    (md_finished)
)

(script static void md_jp_take_elevator
    (md_prep)
    (md_print "head up to the roof level, spartan!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0870)
        (f_md_object_play 0 none m50_0870)
    )
    (md_finished)
    (if (not (game_is_cooperative))
        (ai_player_remove_fireteam_squad player0 "unsc_jl_odsts")
    )
    (wake ct_objective_tower_start)
)

(script dormant void md_jp_theres_the_pad
    (sleep_until (>= objcon_jetpack_high 5) 5)
    (vs_cast "jh_unsc_mars_balcony_inf0" false 10 "m50_0900" "m50_0910")
    (set trooper3_odst1 (vs_role 1))
    (set trooper5_odst2 (vs_role 2))
    (md_prep)
    (md_print "there's the pad -- east end of that tower!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0900)
        (f_md_object_play 0 none m50_0900)
    )
    (md_print "entrance on the other side!")
    (if (>= (ai_living_count trooper5_odst2) 1)
        (f_md_ai_play 30 trooper5_odst2 m50_0910)
        (f_md_object_play 30 none m50_0910)
    )
    (md_finished)
)

(script dormant void md_jp_second_floor
    (sleep_until (>= objcon_jetpack_high 7) 5)
    (md_prep)
    (md_print "over here, spartan!")
    (if (>= (ai_living_count trooper5_odst2) 1)
        (f_md_ai_play 0 trooper5_odst2 m50_0880)
        (f_md_object_play 0 none m50_0880)
    )
    (md_finished)
    (if (not (game_is_cooperative))
        (begin
            (ai_player_add_fireteam_squad player0 "jh_unsc_odst_tree_inf0")
            (ai_player_add_fireteam_squad player0 "jh_unsc_odst_balcony_inf0")
        )
    )
)

(script dormant void md_jp_clear_the_pad
    (sleep_until (>= objcon_trophy 20) 5)
    (md_prep)
    (md_print "clear that pad, spartan!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0920)
        (f_md_object_play 0 none m50_0920)
    )
    (md_finished)
    (wake ct_objective_capture_pad)
    (mus_start mus_06)
)

(script dormant void md_jetpack_complete
    (sleep (random_range objective_delay (* objective_delay 2)))
    (md_prep)
    (md_print "yankee niner to echo dispatch: landing pad is clear!  send in the evac birds!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0930)
        (f_md_object_play 0 none m50_0930)
    )
    (md_print "copy, yankee niner.  birds away.")
    (f_md_object_play 30 none m50_0940)
    (md_finished)
    (wake ct_objective_transport_start)
    (mus_stop mus_06)
)

(script dormant void md_jp_flourish
    (sleep_until 
        (begin
            (sleep (random_range (* 30 15) (* 30 60)))
            (sleep_until (cv_player_jumping))
            (begin_random_count
                10
                (begin
                    (set jp_flourish_ai trooper3_odst1)
                    (set jp_flourish_text "death from above!")
                    (set jp_flourish_line m50_0730)
                )
                (begin
                    (set jp_flourish_ai trooper3_odst1)
                    (set jp_flourish_text "bullfrogs incoming!")
                    (set jp_flourish_line m50_0740)
                )
                (begin
                    (set jp_flourish_ai trooper3_odst1)
                    (set jp_flourish_text "keep your arc up!")
                    (set jp_flourish_line m50_0750)
                )
                (begin
                    (set jp_flourish_ai trooper3_odst1)
                    (set jp_flourish_text "bounce it high!")
                    (set jp_flourish_line m50_0760)
                )
                (begin
                    (set jp_flourish_ai trooper3_odst1)
                    (set jp_flourish_text "watch your angle!")
                    (set jp_flourish_line m50_0770)
                )
                (begin
                    (set jp_flourish_ai trooper5_odst2)
                    (set jp_flourish_text "death from above!")
                    (set jp_flourish_line m50_0780)
                )
                (begin
                    (set jp_flourish_ai trooper5_odst2)
                    (set jp_flourish_text "nice arc!")
                    (set jp_flourish_line m50_0790)
                )
                (begin
                    (set jp_flourish_ai trooper5_odst2)
                    (set jp_flourish_text "here come the bullfrogs!")
                    (set jp_flourish_line m50_0800)
                )
                (begin
                    (set jp_flourish_ai trooper5_odst2)
                    (set jp_flourish_text "easy down!")
                    (set jp_flourish_line m50_0810)
                )
                (begin
                    (set jp_flourish_ai trooper5_odst2)
                    (set jp_flourish_text "hang time!")
                    (set jp_flourish_line m50_0820)
                )
            )
            (md_flourish_play jp_flourish_text jp_flourish_ai jp_flourish_line)
            false
        )
    )
)

(script static void (md_flourish_play (string text, ai squad, ai_line line))
    (md_prep)
    (md_print text)
    (if (>= (ai_living_count squad) 1)
        (f_md_ai_play 0 squad line)
        (f_md_object_play 0 none line)
    )
    (md_finished)
)

(script static boolean cv_player_jumping
    (or (volume_test_players "tv_flourish_ready0") (volume_test_players "tv_flourish_ready1") (volume_test_players "tv_flourish_ready2") (volume_test_players "tv_flourish_ready3") (volume_test_players "tv_flourish_low0") (volume_test_players "tv_flourish_low1") (volume_test_players "tv_flourish_high0") (volume_test_players "tv_flourish_high1") (volume_test_players "tv_flourish_high2") (volume_test_players "tv_flourish_high3") (volume_test_players "tv_flourish_high4"))
)

(script dormant void md_ride_start
    (md_prep)
    (thespian_performance_setup_and_begin "trophy_odst_salute" "" 0)
    (md_print "pleasure jumping with you, spartan.")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0950)
        (f_md_object_play 0 none m50_0950)
    )
    (md_print "we'll hold this location.  you get on that falcon, and make sure those transports make it out in one piece!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 30 trooper3_odst1 m50_0960)
        (f_md_object_play 30 none m50_0960)
    )
    (md_finished)
    (if (not (game_is_cooperative))
        (begin
            (ai_player_remove_fireteam_squad player0 "jh_unsc_odst_tree_inf0")
            (ai_player_remove_fireteam_squad player0 "jh_unsc_odst_balcony_inf0")
            (ai_player_remove_fireteam_squad player0 "jh_odst_inf0")
            (ai_player_remove_fireteam_squad player0 "trophy_odst_inf0")
        )
    )
    (sleep_until b_ride_falcon_landed 1)
    (md_prep)
    (md_print "this is your ride, spartan!")
    (if (>= (ai_living_count trooper3_odst1) 1)
        (f_md_ai_play 0 trooper3_odst1 m50_0970)
        (f_md_object_play 0 none m50_0970)
    )
    (md_finished)
    (sleep objective_delay)
    (if (not (or (player_in_vehicle (ai_vehicle_get "ride_falcon/pilot")) (player_in_vehicle (ai_vehicle_get "ride_falcon0/pilot"))))
        (begin
            (chud_track_object_with_priority (ai_vehicle_get "ride_falcon/pilot") 21)
            (if (game_is_cooperative)
                (chud_track_object_with_priority (ai_vehicle_get "ride_falcon0/pilot") 21)
            )
            (wake md_ride_pilot_master)
        )
    )
)

(script dormant void md_ride
    (md_prep)
    (md_print "city's been under siege for the last five days.  thought we had it in hand -- and then those corvettes showed up.")
    (f_md_object_play 0 none m50_1050)
    (md_print "our fleet's scattered, pulling back.  hell, we've all got orders to evacuate... guess some of us just don't like leaving a job half-finished.")
    (f_md_object_play 0 none m50_1060)
    (md_finished)
)

(script dormant void md_ride2
    (md_prep)
    (md_print "midtown airspace is way too hot.  gonna take an alternate route.")
    (f_md_object_play 0 none m50_1040)
    (md_finished)
)

(script dormant void md_ride_pilot_ready
    (sleep (random_range (* 30 5) (* 30 10)))
    (md_prep)
    (md_print "get on board, lieutenant!  we've got civilians that need immediate assistance!")
    (f_md_object_play 0 none m50_0980)
    (md_finished)
)

(script dormant void md_ride_pilot_master
    (sleep_until 
        (begin
            (wake md_ride_pilot_ready)
            b_ride_player_in_falcon
        )
    )
)

(script dormant void md_ride_chatter1
    (md_prep)
    (md_print "evac transport delta one five to evac dispatch.  loaded up, ready to go.")
    (f_md_object_play 0 none m50_0990)
    (md_print "delta one five, this is evac dispatch.  copy that.  proceed at your discretion.")
    (f_md_object_play 0 none m50_1000)
    (md_finished)
)

(script dormant void md_ride_chatter2
    (md_prep)
    (md_print "delta one five to dispatch!  banshee squadron on my tail!  taking fire!")
    (f_md_object_play 0 none m50_1010)
    (md_print "copy, delta one five.  can you --")
    (f_md_object_play 0 none m50_1020)
    (md_print "mayday!  port engine's hit!  we're going in!  i'm gonna try to set her down!")
    (f_md_object_play 0 none m50_1030)
    (md_finished)
)

(script dormant void md_starport_intro
    (md_prep)
    (md_print "fox actual to unsc frigate stalwart dawn.  request immediate air strike on covenant corvette over starport.")
    (f_md_object_play 0 none m50_1070)
    (md_print "solid copy, fox actual.  longswords unavailable at this time, over.")
    (f_md_object_play 0 none m50_1080)
    (md_print "this is civilian transport six echo two.  i need to go now, sergeant major!")
    (f_md_object_play 0 none m50_1090)
    (md_print "hold on, echo two -- stalwart dawn, i have multiple commercial craft loaded with civilians, and i have got to get them out of the city!  i need air support now!")
    (f_md_object_play 0 none m50_1100)
    (md_print "as soon as something frees up, you'll be the first to --")
    (f_md_object_play 0 none m50_1110)
    (md_print "not good enough!")
    (f_md_object_play 0 none m50_1120)
    (md_print "i've got six hundred souls onboard, sergeant major -- i can't wait any longer!")
    (f_md_object_play 0 none m50_1130)
    (md_print "negative, echo two, i can't cover you!  do not take off!")
    (f_md_object_play 0 none m50_1140)
    (md_print "dammit!")
    (f_md_object_play 0 none m50_1150)
    (md_finished)
)

(script dormant void md_starport_transport
    (sleep (* 30 2))
    (md_prep)
    (md_print "oh, my god...!")
    (f_md_object_play 0 none m50_1160)
    (md_print "mayday!  mayday!")
    (f_md_object_play 0 none m50_1170)
    (md_print "six echo two, can you maintain altitude?")
    (f_md_object_play 0 none m50_1180)
    (md_print "negative!  we're going down!")
    (f_md_object_play 0 none m50_1190)
    (md_print "son of a bitch --")
    (f_md_object_play 0 none m50_1230)
    (md_print "i can't watch this.")
    (f_md_object_play 0 none m50_1260)
    (md_print "fox actual, should we send search-and-rescue birds?")
    (f_md_object_play 30 none m50_1270)
    (md_print "negative, dispatch... no point.")
    (f_md_object_play 30 none m50_1280)
    (md_finished)
)

(script command_script void cs_stow_weapon
    (cs_stow ai_current_actor true)
)

(script dormant void md_commander_dialogue
    (vs_cast "starport_unsc_command" false 10 "m50_1360")
    (set trooper_sgt2 (vs_role 1))
    (sleep 71)
    (md_prep)
    (md_print "spartan? sergeant major duval. awful day so far -- let's keep it from getting any worse!")
    (f_md_object_play 0 none m50_1360)
    (sleep 19)
    (md_print "coveys are all over my missile batteries, and i got five thousand civilians across the bay waiting for passage out!")
    (f_md_object_play 0 none m50_1370)
    (sleep 18)
    (md_print "i need you to arm those batteries, and then fire the missiles from the central terminal.  understood?")
    (f_md_object_play 0 none m50_1380)
    (set b_starport_monologue true)
    (sleep 21)
    (md_print "corvette's been a pain in my ass too damn long.  give it hell, spartan!")
    (f_md_object_play 0 none m50_1390)
    (sleep 42)
    (md_print "troopers! let's get these split-jaws off our beach!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 0 trooper_sgt2 m50_1400)
        (f_md_object_play 0 none m50_1400)
    )
    (md_finished)
    (set b_starport_monologue true)
)

(script dormant void md_starport_objectives
    (sleep_until b_starport_monologue)
    (wake ct_objective_missiles_start)
    (ai_dialogue_enable true)
    (ai_set_task "starport_unsc_command" "obj_starport_unsc" "start")
    (ai_disregard (players) false)
    (ai_cannot_die "starport_unsc_mars0" false)
    (set b_starport_music_start true)
    (game_save)
    (wake md_starport_tension_master)
)

(script dormant void md_starport_tension_master
    (sleep_until (>= objcon_starport 30) 5)
    (md_prep)
    (md_print "civilian transport seven echo three to fox actual.  my engines are hot; waiting for your go.")
    (f_md_object_play 0 none m50_1410)
    (md_print "copy, seven echo three.  we're working on it!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 0 trooper_sgt2 m50_1420)
        (f_md_object_play 30 none m50_1420)
    )
    (md_finished)
    (sleep_until (or (volume_test_players "tv_md_starport_battery0") (volume_test_players "tv_md_starport_battery1")))
    (md_print "that's the first missile battery, lieutenant!  get it armed!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 0 trooper_sgt2 m50_1430)
        (f_md_object_play 0 none m50_1430)
    )
    (sleep_until (or b_starport_turret0_ready b_starport_turret1_ready))
    (sleep (random_range 30 60))
    (if b_starport_turret0_ready
        (begin
            (md_prep)
            (md_print "first battery's online!  other one's to your north!")
            (if (>= (ai_living_count trooper_sgt2) 1)
                (f_md_ai_play 0 trooper_sgt2 m50_1440)
                (f_md_object_play 0 none m50_1440)
            )
            (md_finished)
        )
        (if b_starport_turret1_ready
            (begin
                (md_prep)
                (md_print "first battery's online!  other one's to your south!")
                (if (>= (ai_living_count trooper_sgt2) 1)
                    (f_md_ai_play 0 trooper_sgt2 m50_1450)
                    (f_md_object_play 0 none m50_1450)
                )
                (md_finished)
            )
        )
    )
    (md_prep)
    (md_print "sergeant major, covenant are banging on my bay door,  i got families and wounded on board -- i gotta get airborne!")
    (f_md_object_play 0 none m50_1460)
    (md_print "easy, seven echo three. spartan's gonna clear the skies!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 30 trooper_sgt2 m50_1470)
        (f_md_object_play 30 none m50_1470)
    )
    (md_finished)
    (mus_start mus_08)
    (sleep_until (and b_starport_turret0_ready b_starport_turret1_ready))
    (sleep (* 30 3))
    (md_prep)
    (md_print "batteries primed!  now get over to the east complex and fire those missiles!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 0 trooper_sgt2 m50_1480)
        (f_md_object_play 0 none m50_1480)
    )
    (wake ct_objective_arm_complete)
    (md_print "sergeant major, the coveys are almost through my door!")
    (f_md_object_play 30 none m50_1490)
    (md_print "steady, echo three; that corvette's still up there.")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 30 trooper_sgt2 m50_1500)
        (f_md_object_play 30 none m50_1500)
    )
    (md_finished)
    (mus_layer_start mus_08 1)
    (sleep_until (volume_test_players "tv_md_starport_terminal") 5)
    (md_prep)
    (md_print "that's it!  they've breached the landing bay!")
    (f_md_object_play 0 none m50_1510)
    (md_print "copy that!  now or never, spartan!")
    (if (>= (ai_living_count trooper_sgt2) 1)
        (f_md_ai_play 30 trooper_sgt2 m50_1520)
        (f_md_object_play 30 none m50_1520)
    )
    (md_finished)
)

(script dormant void md_starport_complete
    (sleep_until (= b_starport_defenses_fired true))
    (wake ct_objective_missiles_complete)
    (md_prep)
    (md_print "missile defense online!  all evac transports: you are cleared for take off!  repeat, you are cleared for take off! go! now!")
    (f_md_object_play 0 none m50_1530)
    (md_finished)
)

(script static void (snd_loop (looping_sound s))
    (sound_looping_start s none 1)
)

(script static void (snd_stop (looping_sound s))
    (sound_looping_stop s)
)

(script static void (snd_stop_now (looping_sound s))
    (sound_looping_stop_immediately s)
)

(script static void (snd_play (sound s))
    (sound_impulse_start s (player0) 1)
)

(script static void (snd_play_all (sound s))
    (sound_impulse_start s none 1)
    (sleep (sound_impulse_language_time s))
)

(script static void (mus_play (looping_sound s))
    (if debug
        (print "starting new music loop...")
    )
    (sound_looping_start s none 1)
)

(script static void (mus_stop_immediate (looping_sound s))
    (if debug
        (print "killing music loop...")
    )
    (sound_looping_stop_immediately s)
)

(script static void (cam_shake (real attack, real intensity, real decay))
    (player_effect_set_max_rotation 2 2 2)
    (player_effect_start intensity attack)
    (player_effect_stop decay)
)

(script static void (mus_start (looping_sound s))
    (if playmusic
        (sound_looping_start s none 1)
    )
)

(script static void (mus_stop (looping_sound s))
    (sound_looping_stop s)
)

(script static void (mus_alt (looping_sound s))
    (sound_looping_set_alternate s true)
)

(script static void (mus_layer_start (looping_sound s, long l))
    (sound_looping_activate_layer s l)
)

(script static void (mus_layer_stop (looping_sound s, long l))
    (sound_looping_deactivate_layer s l)
)

(script static void hud_malfunction_loop
    (sleep_until 
        (begin
            false
        )
    )
)

(script static void (hud_flash_message (cutscene_title t, short count, short delay))
    (snd_play none)
    (set s_hud_flash_count 0)
    (sleep_until 
        (begin
            (cinematic_set_title t)
            (set s_hud_flash_count (+ s_hud_flash_count 1))
            (sleep delay)
            (>= s_hud_flash_count (- count 1))
        )
        1
    )
)

(script static void (f_fx_ambient (short fx_type))
    (if (= fx_type 0)
        (begin
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" n_point)
            (sleep (random_range 0 15))
        )
        (if (= fx_type 1)
            (begin
                (effect_new_random "levels\solo\m50\fx\explosion_building.effect" n_point)
                (sleep (random_range 0 15))
            )
        )
    )
)

(script dormant void f_panoptical_fx_ambient
    (sleep_until 
        (begin
            (begin_random_count
                1
                (begin
                    (if debug
                        (print "pts_fx_pan_0 pts_fx_ambient_a")
                    )
                    (set n_point "pts_fx_ambient_a")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_pan_0 pts_fx_ambient_b")
                    )
                    (set n_point "pts_fx_ambient_b")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_pan_0 pts_fx_ambient_c")
                    )
                    (set n_point "pts_fx_ambient_c")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_pan_0 pts_fx_ambient_d")
                    )
                    (set n_point "pts_fx_ambient_d")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
            )
            false
        )
        60
    )
)

(script dormant void f_towers_fx_ambient
    (sleep_until 
        (begin
            (begin_random_count
                1
                (begin
                    (if debug
                        (print "pts_fx_master_tow_0 pts_fx_ambient_b")
                    )
                    (set n_point "pts_fx_ambient_b")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_tow_0 pts_fx_ambient_c")
                    )
                    (set n_point "pts_fx_ambient_c")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
            )
            false
        )
        60
    )
)

(script dormant void f_canyon_fx_ambient
    (sleep_until 
        (begin
            (begin_random_count
                1
                (begin
                    (if debug
                        (print "pts_fx_master_can_0 pts_fx_ambient_a")
                    )
                    (set n_point "pts_fx_ambient_a")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_can_0 pts_fx_ambient_b")
                    )
                    (set n_point "pts_fx_ambient_b")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_can_0 pts_fx_ambient_c")
                    )
                    (set n_point "pts_fx_ambient_c")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_can_0 pts_fx_ambient_d")
                    )
                    (set n_point "pts_fx_ambient_d")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_can_0 pts_fx_ambient_e")
                    )
                    (set n_point "pts_fx_ambient_e")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
            )
            false
        )
        60
    )
)

(script dormant void f_atrium_fx_ambient
    (sleep_until 
        (begin
            (begin
                (if debug
                    (print "pts_fx_master_atr_0 pts_fx_ambient_c")
                )
                (set n_point "pts_fx_ambient_c")
                (begin_random_count
                    1
                    (f_fx_ambient 0)
                    (f_fx_ambient 0)
                    (f_fx_ambient 0)
                    (f_fx_ambient 0)
                    (f_fx_ambient 0)
                )
            )
            false
        )
        60
    )
)

(script dormant void f_jetpack_fx_ambient
    (sleep_until 
        (begin
            (begin_random_count
                1
                (begin
                    (if debug
                        (print "pts_fx_master_jet_0 pts_fx_ambient_a")
                    )
                    (set n_point "pts_fx_ambient_a")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_jet_0 pts_fx_ambient_d")
                    )
                    (set n_point "pts_fx_ambient_d")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_jet_0 pts_fx_ambient_e")
                    )
                    (set n_point "pts_fx_ambient_e")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
            )
            false
        )
        60
    )
)

(script dormant void f_starport_fx_ambient
    (sleep_until 
        (begin
            (begin_random_count
                1
                (begin
                    (if debug
                        (print "pts_fx_master_star_0 pts_fx_ambient_b")
                    )
                    (set n_point "pts_fx_ambient_b")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_star_0 pts_fx_ambient_e")
                    )
                    (set n_point "pts_fx_ambient_e")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
                (begin
                    (if debug
                        (print "pts_fx_star_0 pts_fx_ambient_f")
                    )
                    (set n_point "pts_fx_ambient_f")
                    (begin_random_count
                        1
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                        (f_fx_ambient 0)
                    )
                )
            )
            false
        )
        60
    )
)

(script dormant void ambient_wraith_shells_a
    (sleep_until 
        (begin
            (effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" "000_ambient_shells_a" 5 5)
            (sleep (random_range 5 60))
            false
        )
    )
)

(script dormant void ambient_wraith_shells_b
    (sleep_until 
        (begin
            (effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" "000_ambient_shells_b" 5 5)
            (sleep (random_range 5 60))
            false
        )
    )
)

(script dormant void panoptical_corvette_attack
    (sleep_until 
        (begin
            (effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" "000_ambient_shells_a" 5 5)
            (sleep (random_range 5 60))
            false
        )
    )
)

(script dormant void f_corvette_exterior
    (sleep_until 
        (begin
            (begin
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_01_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_02_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_03_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_04_01" "")
            )
            (sleep (random_range (* 30 5) (* 30 7)))
            b_interior_started
        )
    )
    (sleep_until (>= objcon_canyonview 10))
    (sleep_until 
        (begin
            (begin
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_01_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_02_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_03_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_panoptical_04_01" "")
            )
            (sleep (random_range (* 30 5) (* 30 7)))
            b_atrium_complete
        )
    )
)

(script dormant void f_corvette_starport
    (sleep_until 
        (begin
            (begin
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_starport_01_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_starport_02_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_starport_03_01" "")
                (sleep (random_range (* 30 0) (* 30 1)))
                (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "fx_starport_04_01" "")
            )
            (sleep (random_range (* 30 5) (* 30 7)))
            b_starport_defenses_fired
        )
    )
)

(script static void (ls_flyby (device_name d))
    (object_create d)
    (device_animate_position d 0 0 0 0 true)
    (device_set_position_immediate d 0)
    (device_set_power d 0)
    (sleep 1)
    (device_set_position_track d "device:m50" 0)
    (device_animate_position d 0.5 7 0.1 0.1 true)
    (sleep_until (>= (device_get_position d) 0.5))
    (object_destroy d)
)

(script static void ls_flyby_sound
    (sound_impulse_start snd_longsword_flyby none 1)
)

(script static void ls_flyby_delay
    (sleep (random_range (* 30 s_min_longsword_flyby_delay) (* 30 s_max_longsword_flyby_delay)))
)

(script dormant void panoptical_longsword_cycle
    (sleep (random_range 30 150))
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ls_flyby "ls_panoptical_01")
                    (sleep 10)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_panoptical_02")
                    (sleep 10)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_panoptical_03")
                    (sleep 10)
                    (ls_flyby_delay)
                )
            )
            false
        )
    )
)

(script dormant void towers_longsword_cycle
    (sleep_forever panoptical_longsword_cycle)
    (sleep (random_range 30 150))
    (sleep_until 
        (begin
            (ls_flyby "ls_towers_01")
            (sleep (* 30 1))
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_tow_0/p0")
            (sleep (* 30 0.125))
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_tow_0/p1")
            (ls_flyby "ls_towers_02")
            (ls_flyby "ls_towers_03")
            (sleep (* 30 1))
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_tow_0/p2")
            (sleep (* 30 0.125))
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_tow_0/p3")
            (sleep (* 30 0.125))
            (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_tow_0/p4")
            (ls_flyby_delay)
            false
        )
    )
)

(script dormant void canyonview_longsword_cycle
    (sleep_forever towers_longsword_cycle)
    (sleep (random_range 30 150))
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ls_flyby "ls_canyonview_02")
                    (ls_flyby "ls_canyonview_03")
                    (ls_flyby "ls_canyonview_04")
                    (sleep (* 30 1))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p0")
                    (sleep (* 30 0.125))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p1")
                    (sleep (* 30 0.125))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p2")
                    (sleep (* 30 0.125))
                    (sleep 20)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_canyonview_01")
                    (sleep 10)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_canyonview_05")
                    (ls_flyby "ls_canyonview_06")
                    (ls_flyby "ls_canyonview_07")
                    (sleep (* 30 1))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p3")
                    (sleep (* 30 0.125))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p4")
                    (sleep (* 30 0.125))
                    (effect_new_random "levels\solo\m50\fx\explosion_building.effect" "pts_fx_can_0/p5")
                    (sleep (* 30 0.125))
                    (sleep 5)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_canyonview_08")
                    (ls_flyby "ls_canyonview_09")
                    (sleep 5)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_canyonview_10")
                    (sleep 5)
                    (ls_flyby_delay)
                )
            )
            false
        )
    )
)

(script dormant void jetpack_longsword_cycle
    (sleep (random_range 30 150))
    (object_create "ls_jetpack_01")
    (object_create "ls_jetpack_02")
    (object_create "ls_jetpack_03")
    (sleep_until 
        (begin
            (begin_random
                (begin
                    (ls_flyby "ls_jetpack_01")
                    (sleep 10)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_jetpack_02")
                    (sleep 10)
                    (ls_flyby_delay)
                )
                (begin
                    (ls_flyby "ls_jetpack_03")
                    (sleep 10)
                    (ls_flyby_delay)
                )
            )
            false
        )
    )
)

(script static void (flyby_bomb (point_reference p, short count, short delay))
    (set s_current_bomb 0)
    (sleep_until 
        (begin
            (print "boom")
            (effect_new_at_point_set_point "fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large" p s_current_bomb)
            (set s_current_bomb (+ s_current_bomb 1))
            (sleep delay)
            (>= s_current_bomb count)
        )
        1
    )
)

(script command_script void cs_ambient_dropship_1
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (sleep_until 
        (begin
            (sleep (random_range 0 240))
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_1/entry0")
            (cs_vehicle_boost false)
            (cs_vehicle_speed 0.8)
            (cs_fly_to "000_ambient_dropship_1/hover" 0.5)
            (cs_vehicle_speed 0.4)
            (sleep (random_range 30 60))
            (cs_fly_to_and_face "000_ambient_dropship_1/land" "000_ambient_dropship_1/land_facing" 0.5)
            (cs_vehicle_speed 0.6)
            (sleep (random_range 90 150))
            (cs_fly_to_and_face "000_ambient_dropship_1/hover" "000_ambient_dropship_1/land_facing" 0.5)
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_1/entry0")
            (cs_fly_to "000_ambient_dropship_1/start" 0.5)
            b_kill_canyon_dropships
        )
    )
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_ambient_dropship_2
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (sleep_until 
        (begin
            (sleep (random_range 0 240))
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_2/entry0")
            (cs_vehicle_boost false)
            (cs_vehicle_speed 0.8)
            (cs_fly_to "000_ambient_dropship_2/hover" 0.5)
            (cs_vehicle_speed 0.4)
            (sleep (random_range 30 60))
            (cs_fly_to_and_face "000_ambient_dropship_2/land" "000_ambient_dropship_2/land_facing" 0.5)
            (cs_vehicle_speed 0.6)
            (sleep (random_range 90 150))
            (cs_fly_to_and_face "000_ambient_dropship_2/hover" "000_ambient_dropship_2/land_facing" 0.5)
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_2/entry0")
            (cs_fly_to "000_ambient_dropship_2/start" 0.5)
            b_kill_canyon_dropships
        )
    )
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
    (sleep (* 30 5))
    (ai_erase ai_current_squad)
)

(script command_script void cs_ambient_dropship_3
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_pathfinding_failsafe true)
    (sleep (random_range 0 240))
    (sleep_until 
        (begin
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_3/entry0")
            (cs_vehicle_boost false)
            (cs_vehicle_speed 0.8)
            (cs_fly_to "000_ambient_dropship_3/hover" 0.5)
            (cs_vehicle_speed 0.4)
            (sleep (random_range 30 60))
            (cs_fly_to_and_face "000_ambient_dropship_3/land" "000_ambient_dropship_3/land_facing" 0.5)
            (cs_vehicle_speed 0.6)
            (sleep (random_range 90 150))
            (cs_fly_to_and_face "000_ambient_dropship_3/hover" "000_ambient_dropship_3/land_facing" 0.5)
            (cs_vehicle_speed 1)
            (cs_fly_by "000_ambient_dropship_3/entry0")
            (cs_fly_to "000_ambient_dropship_3/start" 0.5)
            (sleep (random_range 60 240))
            b_kill_canyon_dropships
        )
    )
)

(script dormant void ambient_spawn_dropships
    (f_ai_place_vehicle_deathless "cov.ambient.dropship.1")
    (f_ai_place_vehicle_deathless "cov.ambient.dropship.2")
    (ai_set_clump "cov.ambient.dropship.1" 2)
    (ai_set_clump "cov.ambient.dropship.2" 2)
)

(script static void kill_ambient_dropships
    (set b_kill_canyon_dropships true)
)

(script dormant void civilian_transport_takeoff
    (device_set_position_track "dm_civilian_transport" "m50_starport_escape" 0)
    (sleep (* 30 8))
    (device_animate_position "dm_civilian_transport" 1 33.33 0.1 0.1 false)
    (sleep_until (>= (device_get_position "dm_civilian_transport") 0.307273) 1)
    (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\covenant_weapon_fire\covenant_weapon_fire" "civilian_ship_hit" "")
    (wake md_starport_transport)
    (sleep_until (>= (device_get_position "dm_civilian_transport") 0.54) 1)
    (effect_new_on_object_marker "levels\solo\m50\fx\civilian_ship_crash\water_impact\civilian_ship_water_impact" "civilian_ship_crash" "")
)

(script dormant void ambient_fx_test
    (wake f_panoptical_fx_ambient)
    (wake f_towers_fx_ambient)
    (wake f_canyon_fx_ambient)
    (wake f_atrium_fx_ambient)
    (wake f_jetpack_fx_ambient)
    (wake f_starport_fx_ambient)
)

(script static void ins_ambient_fx_test_panoptical
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_panoptical_010_020")
            (sleep 1)
        )
    )
    (object_teleport_to_ai_point (player0) "pts_teleport/panoptical")
    (cinematic_fade_to_gameplay)
    (sleep 1)
    (wake f_panoptical_fx_ambient)
    (wake f_towers_fx_ambient)
    (fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_canyonview
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_atrium_040_050_060")
            (sleep 1)
        )
    )
    (object_teleport_to_ai_point (player0) "pts_teleport/canyonview")
    (cinematic_fade_to_gameplay)
    (sleep 1)
    (device_set_position "dm_canyonview_door1" 1)
    (wake f_canyon_fx_ambient)
    (wake f_atrium_fx_ambient)
    (fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_jetpack
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (object_teleport_to_ai_point (player0) "pts_teleport/jetpack")
    (cinematic_fade_to_gameplay)
    (sleep 1)
    (wake f_jetpack_fx_ambient)
    (fade_in 0 0 0 0)
)

(script static void ins_ambient_fx_test_starport
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_starport_090")
            (sleep 1)
        )
    )
    (object_teleport_to_ai_point (player0) "pts_teleport/starport")
    (cinematic_fade_to_gameplay)
    (sleep 1)
    (wake f_starport_fx_ambient)
    (fade_in 0 0 0 0)
)

(script dormant void special_elite
    (if (= s_special_elite 0)
        (begin_random_count
            1
            (set s_special_elite 1)
            (set s_special_elite 2)
            (set s_special_elite 3)
        )
    )
    (sleep_until (> (ai_living_count "gr_special_elite") 0) 1)
    (sleep_until (and (< (ai_living_count "gr_special_elite") 1) (= b_special_win true)) 1)
    (set b_special true)
    (submit_incident "kill_elite_bob")
    (print "special win!")
)

(script command_script void cs_special_elite1
    (set b_special_win true)
    (print "special start")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_bob/ready_enter" 10)
    (cs_fly_by "pts_bob/ready_dive" 10)
    (cs_fly_by "pts_bob/ready_turn")
    (cs_fly_by "pts_bob/ready_exit")
    (cs_fly_by "pts_bob/ready_remove")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (set b_special_win false)
    (print "special fail")
    (sleep 1)
    (ai_erase ai_current_actor)
)

(script command_script void cs_special_elite2
    (set b_special_win true)
    (print "special start")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_fly_by "pts_bob/jetpack_enter" 10)
    (cs_fly_by "pts_bob/jetpack_dive" 10)
    (cs_fly_by "pts_bob/jetpack_turn")
    (cs_fly_by "pts_bob/jetpack_exit")
    (cs_fly_by "pts_bob/jetpack_remove")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (set b_special_win false)
    (print "special fail")
    (sleep 1)
    (ai_erase ai_current_actor)
)

(script command_script void cs_special_elite3
    (set b_special_win true)
    (print "special start")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
    (sleep 1)
    (object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
    (cs_enable_targeting true)
    (cs_enable_looking true)
    (cs_vehicle_boost true)
    (cs_shoot true)
    (cs_fly_by "pts_bob/starport_enter" 10)
    (cs_fly_by "pts_bob/starport_dive" 10)
    (cs_fly_by "pts_bob/starport_turn")
    (cs_fly_by "pts_bob/starport_exit")
    (cs_fly_by "pts_bob/starport_remove")
    (object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 2.5))
    (sleep (* 30 2.5))
    (set b_special_win false)
    (print "special fail")
    (sleep 1)
    (ai_erase ai_current_actor)
)

(script dormant void starport_bob
    (sleep_until (volume_test_players "tv_starport_bridge") 5)
    (if (= s_special_elite 3)
        (begin
            (ai_place "special_elite3")
            (sleep 1)
            (ai_disregard (ai_actors "special_elite3") true)
        )
    )
)

(script dormant void music_memory_test
    (sound_looping_stop "levels\solo\m50\music\m50_music_01")
    (sound_looping_stop "levels\solo\m50\music\m50_music_02")
    (sound_looping_stop "levels\solo\m50\music\m50_music_03")
    (sound_looping_stop "levels\solo\m50\music\m50_music_04")
    (sound_looping_stop "levels\solo\m50\music\m50_music_05")
    (sound_looping_stop "levels\solo\m50\music\m50_music_06")
    (sound_looping_stop "levels\solo\m50\music\m50_music_07")
    (sound_looping_stop "levels\solo\m50\music\m50_music_08")
    (sound_looping_stop "levels\solo\m50\music\m50_music_09")
    (sound_looping_stop "levels\solo\m50\music\m50_music_10")
    (sound_looping_stop "levels\solo\m50\music\m50_music_11")
    (sound_looping_stop "levels\solo\m50\music\m50_music_12")
    (sound_looping_stop "levels\solo\m50\music\m50_music_13")
)

(script static boolean obj_ishoot_0_2
    (>= objcon_interior 50)
)

(script static boolean obj_ishoot_0_3
    (>= objcon_interior 50)
)

(script static boolean obj_ishoot_0_4
    (>= objcon_interior 20)
)

(script static boolean obj_ishoot_0_5
    (>= objcon_interior 30)
)

(script static boolean obj_ccount_1_1
    (= b_cv_counter_started true)
)

(script static boolean obj_cgrunt_1_12
    (or (>= objcon_canyonview 30) (<= (ai_task_count "obj_canyonview_cov/initial_brute_front") 0))
)

(script static boolean obj_cmiddl_1_13
    (>= objcon_canyonview 10)
)

(script static boolean obj_ciniti_1_14
    (>= objcon_canyonview 30)
)

(script static boolean obj_cguard_2_2
    (>= objcon_canyonview 10)
)

(script static boolean obj_clower_2_3
    (and (>= objcon_canyonview 20) (<= (ai_task_count "obj_canyonview_cov/initial_brute_front") 0))
)

(script static boolean obj_ccount_2_4
    (= b_cv_counter_started true)
)

(script static boolean obj_ccount_2_5
    (= b_cv_complete true)
)

(script static boolean obj_cescap_2_7
    (>= objcon_canyonview 10)
)

(script static boolean obj_ccover_2_12
    (= b_cv_counter_started true)
)

(script static boolean obj_cescap_2_13
    (>= objcon_canyonview 30)
)

(script static boolean obj_cpost__2_14
    (= b_cv_complete true)
)

(script static boolean obj_cescap_2_15
    (and (>= objcon_canyonview 40) (<= (ai_task_count "obj_canyonview_cov/gate_main") 3))
)

(script static boolean obj_clow_a_2_18
    (and (>= objcon_canyonview 30) (<= (ai_task_count "obj_canyonview_cov/initial_brute_middle") 0))
)

(script static boolean obj_acount_3_2
    (or (<= (ai_task_count "obj_atrium_cov/gate_counterattack") 3) (f_ai_is_defeated "gr_cov_atrium_hunters"))
)

(script static boolean obj_ainiti_3_17
    (or (>= (ai_strength "gr_cov_atrium_initial") 0.75) (!= (f_ai_is_defeated "atrium_cov_initial_inf5") true))
)

(script static boolean obj_abrute_3_18
    (or (>= objcon_atrium 40) (<= (ai_strength "atrium_cov_initial_inf5") 0.5))
)

(script static boolean obj_aflank_3_19
    (and (<= (ai_strength "gr_cov_atrium_initial") 0.25) (>= objcon_atrium 40))
)

(script static boolean obj_aflank_3_20
    (volume_test_players "tv_atrium_flank_right")
)

(script static boolean obj_aarch_3_22
    (volume_test_players "tv_atrium_arch")
)

(script static boolean obj_agate__3_24
    (volume_test_players "tv_atrium_terrace")
)

(script static boolean obj_ainiti_3_28
    (or b_atrium_counterattack_started (>= objcon_atrium 60))
)

(script static boolean obj_astack_4_2
    (>= objcon_atrium 5)
)

(script static boolean obj_aadvan_4_3
    (or (<= (ai_task_count "obj_atrium_cov/initial_grunts") 0) (>= objcon_atrium 10))
)

(script static boolean obj_aadvan_4_4
    (>= objcon_atrium 20)
)

(script static boolean obj_aadvan_4_5
    (and (>= objcon_atrium 30) (<= (ai_strength "atrium_cov_initial_inf0") 0.025))
)

(script static boolean obj_aadvan_4_6
    (or (>= objcon_atrium 40) (<= (ai_strength "gr_cov_atrium_initial") 0.025))
)

(script static boolean obj_acount_4_7
    (= b_atrium_counterattack_started true)
)

(script static boolean obj_acompl_4_8
    (= b_atrium_complete true)
)

(script static boolean obj_aentra_4_13
    (>= objcon_atrium 10)
)

(script static boolean obj_aentra_4_14
    (and (>= objcon_atrium 30) (<= (ai_task_count "obj_atrium_cov/initial_grunts") 1) (<= (ai_task_count "obj_atrium_cov/initial_brutes") 0))
)

(script static boolean obj_aterra_4_16
    (>= objcon_atrium 40)
)

(script static boolean obj_aeleva_4_18
    (= b_atrium_complete true)
)

(script static boolean obj_adefen_4_19
    (= b_atrium_counterattack_started true)
)

(script static boolean obj_aconfe_4_21
    (>= objcon_atrium 30)
)

(script static boolean obj_aterra_4_24
    (volume_test_players "tv_atrium_terrace")
)

(script static boolean obj_jcrane_6_1
    (or (>= objcon_jetpack_low 90) (<= (ai_task_count "obj_jetpack_low_cov/gate_ramp") 3))
)

(script static boolean obj_jhigh__6_7
    (>= objcon_jetpack_low 130)
)

(script static boolean obj_jramp__6_8
    (or (>= objcon_jetpack_low 90) (<= (ai_task_count "obj_jetpack_low_cov/gate_ramp") 7))
)

(script static boolean obj_jiniti_6_10
    (>= objcon_jetpack_low 120)
)

(script static boolean obj_jcrane_6_22
    (or (>= objcon_jetpack_low 100) (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 5))
)

(script static boolean obj_jcrane_6_23
    (or (>= objcon_jetpack_low 110) (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 3))
)

(script static boolean obj_jhallw_6_24
    (volume_test_players "tv_jetpack_low_hallway")
)

(script static boolean obj_jgate__7_1
    (>= objcon_jetpack_low 50)
)

(script static boolean obj_jmars__7_6
    (>= objcon_jetpack_low 80)
)

(script static boolean obj_jodst__7_7
    (<= (ai_task_count "obj_jetpack_low_cov/ramp_low") 0)
)

(script static boolean obj_jodst__7_8
    (or (<= (ai_task_count "obj_jetpack_low_cov/gate_ramp") 2) (>= objcon_jetpack_low 90))
)

(script static boolean obj_jmars__7_9
    (<= (ai_task_count "obj_jetpack_low_cov/gate_ramp") 2)
)

(script static boolean obj_jodst__7_10
    (or (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 2) (>= objcon_jetpack_low 100))
)

(script static boolean obj_jmars__7_11
    (or (<= (ai_task_count "obj_jetpack_low_cov/gate_ramp") 0) (>= objcon_jetpack_low 110))
)

(script static boolean obj_jd_def_7_12
    (<= (ai_task_count "obj_jetpack_low_cov/gate_main") 1)
)

(script static boolean obj_jupper_7_13
    (or (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 2) (>= objcon_jetpack_low 120))
)

(script static boolean obj_jstand_7_14
    (and (<= (ai_task_count "obj_jetpack_low_cov/gate_main") 2) (>= objcon_jetpack_low 130))
)

(script static boolean obj_jlobby_7_19
    b_jetpack_high_started
)

(script static boolean obj_jlobby_7_20
    (>= objcon_jetpack_low 160)
)

(script static boolean obj_jodst__7_22
    (or (>= objcon_jetpack_low 120) (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 2))
)

(script static boolean obj_jodst__7_24
    (or (>= objcon_jetpack_low 120) (<= (ai_task_count "obj_jetpack_low_cov/gate_crane") 2))
)

(script static boolean obj_jlobby_7_26
    b_jetpack_high_started
)

(script static boolean obj_jtree__8_8
    (>= objcon_jetpack_high 10)
)

(script static boolean obj_jhill__8_10
    (or (<= (ai_strength "jh_cov_hill_concussion_inf0") 0.5) (volume_test_players "tv_jetpack_high_stairs_top"))
)

(script static boolean obj_jtree__8_13
    (or (<= (ai_task_count "obj_jetpack_high_cov/gate_tree") 4) (>= objcon_jetpack_high 20))
)

(script static boolean obj_jhill__8_17
    (>= objcon_jetpack_high 30)
)

(script static boolean obj_jhill__8_20
    (>= objcon_jetpack_high 30)
)

(script static boolean obj_jhill__8_21
    (>= objcon_jetpack_high 40)
)

(script static boolean obj_jtree__8_22
    (>= objcon_jetpack_high 30)
)

(script static boolean obj_jhill__8_28
    (<= (ai_strength "jh_cov_hill_concussion_inf0") 0.25)
)

(script static boolean obj_jmarin_9_2
    (and (<= (ai_strength "gr_cov_jh_hill") 0.5) (>= objcon_jetpack_high 30))
)

(script static boolean obj_jmarin_9_3
    (and (<= (ai_task_count "obj_jetpack_high_cov/tree_initial") 2) (>= objcon_jetpack_high 20))
)

(script static boolean obj_jodst__9_5
    (and (or (<= (ai_task_count "obj_jetpack_high_cov/tree_initial") 3) (>= objcon_jetpack_high 20) (<= (ai_living_count "jh_cov_tree_inf0") 0)) (>= objcon_jetpack_high 10))
)

(script static boolean obj_jmarin_9_7
    (and (f_ai_is_partially_defeated "jh_cov_hill_stairs_inf0" 2) (f_ai_is_partially_defeated "jh_cov_hill_stairs_inf1" 2))
)

(script static boolean obj_jodsts_9_8
    (and (or (<= (ai_strength "gr_cov_jh_hill") 0.45) (>= objcon_jetpack_high 30)) b_place_jh_hill)
)

(script static boolean obj_jodsts_9_9
    (and (or (<= (ai_strength "gr_cov_jh_hill") 0.1) (>= objcon_jetpack_high 40)) b_place_jh_hill)
)

(script static boolean obj_jmarin_9_10
    (and (<= (ai_task_count "obj_jetpack_high_cov/gate_hill") 2) (>= objcon_jetpack_high 40))
)

(script static boolean obj_jodst__9_11
    (volume_test_players "tv_jetpack_high_stairs_top")
)

(script static boolean obj_jmarin_9_12
    (and (volume_test_players "tv_jetpack_high_stairs_top") (<= (ai_task_count "obj_jetpack_high_cov/gate_hill") 1))
)

(script static boolean obj_jodst__9_13
    (and (or (<= (ai_task_count "obj_jetpack_high_cov/gate_hill") 0) (= b_trophy_started true)) b_place_jh_hill)
)

(script static boolean obj_jmarin_9_14
    (<= (ai_task_count "obj_jetpack_high_cov/gate_main") 0)
)

(script static boolean obj_jodst__9_26
    (and (<= (ai_task_count "obj_jetpack_high_cov/hill_stairs_low") 0) b_place_jh_hill)
)

(script static boolean obj_rattac_10_2
    (>= objcon_ready 20)
)

(script static boolean obj_rlast__10_6
    (>= objcon_ready 90)
)

(script static boolean obj_rcross_10_9
    (>= objcon_ready 30)
)

(script static boolean obj_rcs_re_10_10
    (>= objcon_ready 80)
)

(script static boolean obj_rdoorm_10_12
    (>= objcon_ready 50)
)

(script static boolean obj_rpad_o_10_14
    (>= objcon_ready 50)
)

(script static boolean obj_radvan_10_16
    (>= objcon_ready 80)
)

(script static boolean obj_radvan_10_17
    (>= objcon_ready 70)
)

(script static boolean obj_radvan_10_18
    (>= objcon_ready 40)
)

(script static boolean obj_tbugge_11_4
    (>= objcon_trophy 20)
)

(script static boolean obj_tbalco_11_11
    (>= objcon_trophy 10)
)

(script static boolean obj_tbalco_11_12
    (>= objcon_trophy 40)
)

(script static boolean obj_tentra_11_13
    (>= objcon_trophy 5)
)

(script static boolean obj_tgate__11_16
    b_trophy_counterattack
)

(script static boolean obj_tentra_11_17
    (>= objcon_trophy 10)
)

(script static boolean obj_tentra_11_20
    (<= (ai_task_count "obj_trophy_cov/gate_entrance") 3)
)

(script static boolean obj_sm0_in_12_22
    (volume_test_players "tv_starport_bridge")
)

(script static boolean obj_sfallb_12_30
    (and b_starport_turret0_ready b_starport_turret1_ready)
)

(script static boolean obj_sintro_12_31
    (not b_starport_monologue)
)

(script static boolean obj_sm1_in_12_32
    (f_ai_is_defeated "starport_cov_mis1_inf0")
)

(script static boolean obj_sadvan_14_2
    (and (<= (ai_living_count "starport_cov_inf0") 0) (<= (ai_living_count "starport_cov_inf1") 0) b_falcon_unloaded)
)

(script static boolean obj_sgate__14_3
    b_falcon_unloaded
)

(script static boolean obj_sgate__14_6
    b_falcon_unloaded
)

(script static boolean obj_sadvan_14_8
    (and b_starport_turret0_ready b_starport_turret1_ready)
)

(script static boolean obj_sm0_as_14_9
    (and (f_ai_is_defeated "starport_cov_bridge_inf0") (f_task_is_empty "obj_starport_cov/gate_missile0"))
)

(script static boolean obj_sm1_as_14_10
    (and (f_ai_is_defeated "starport_cov_bridge_inf0") (f_task_is_empty "obj_starport_cov/gate_missile1"))
)

(script static boolean obj_sadvan_14_16
    (and (>= objcon_starport 30) b_falcon_unloaded)
)

(script static boolean obj_sadvan_14_21
    (and (<= (ai_living_count "obj_starport_cov/gate_main") 8) (volume_test_players "tv_starport_c0"))
)

(script static boolean obj_shold_14_25
    b_falcon_unloaded
)

(script static boolean obj_shold__14_26
    (f_task_is_empty "obj_starport_cov/gate_missile1")
)

(script static boolean obj_shold__14_27
    (f_task_is_empty "obj_starport_cov/gate_missile0")
)

(script static boolean obj_shold__14_28
    (f_task_is_empty "obj_starport_cov/gate_glass_canopy")
)

(script static boolean obj_sduval_14_30
    (and (<= (ai_living_count "starport_cov_inf0") 0) (<= (ai_living_count "starport_cov_inf1") 0) b_falcon_unloaded)
)

(script static boolean obj_sgate__14_31
    b_falcon_unloaded
)

(script static boolean obj_svehic_14_39
    b_players_all_on_foot
)

(script static boolean obj_svehic_14_40
    b_players_any_in_vehicle
)

(script static boolean obj_swarth_14_42
    (and b_starport_turret0_ready b_starport_turret1_ready)
)

(script static boolean obj_swarth_14_43
    (or (> (ai_task_count "obj_starport_cov/gate_missile1") 0) (not b_starport_turret1_ready))
)

(script static boolean obj_swarth_14_44
    (or (> (ai_task_count "obj_starport_cov/gate_missile0") 0) (not b_starport_turret0_ready))
)

(script static boolean obj_smongo_14_45
    (and b_starport_turret0_ready b_starport_turret1_ready)
)

(script static boolean obj_smongo_14_46
    (and (> (ai_task_count "obj_starport_cov/gate_missile1") 0) (not b_starport_turret1_ready))
)

(script static boolean obj_smongo_14_47
    (and (> (ai_task_count "obj_starport_cov/gate_missile0") 0) (not b_starport_turret0_ready))
)

(script static boolean obj_smong__14_48
    (volume_test_players "tv_starport_right")
)

(script static boolean obj_smong__14_49
    (volume_test_players "tv_starport_left")
)

(script static boolean obj_smong__14_50
    (volume_test_players "tv_starport_center")
)

(script static boolean obj_swarth_14_51
    (volume_test_players "tv_starport_right")
)

(script static boolean obj_swarth_14_52
    (volume_test_players "tv_starport_left")
)

(script static boolean obj_swarth_14_53
    (volume_test_players "tv_starport_center")
)

(script static boolean obj_swarth_14_54
    (> (ai_task_count "obj_starport_cov_vehicles/wraith_main") 0)
)

(script static boolean obj_swarth_14_55
    (> (ai_task_count "obj_starport_cov_vehicles/wraith_backup") 0)
)

(script static boolean obj_swarth_14_56
    (> (ai_task_count "obj_starport_cov_vehicles/wraith_main") 0)
)

(script static boolean obj_sduval_14_57
    (and b_starport_turret0_ready b_starport_turret1_ready)
)

(script static boolean obj_sduval_14_58
    (<= (ai_living_count "gr_unsc") 1)
)

(script static boolean obj_r789_d_15_7
    (<= objcon_ride 105)
)

(script static boolean obj_r456_d_15_8
    (<= objcon_ride 95)
)

(script static boolean obj_radvan_15_12
    b_rooftop0_start
)

(script static boolean obj_radvan_15_13
    b_rooftop0_start
)

(script static boolean obj_rrun_c_15_14
    b_rooftop0_start
)

(script static boolean obj_radvan_15_19
    b_rooftop0_start
)

(script static boolean obj_radvan_15_21
    b_rooftop0_start
)

(script static boolean obj_radvan_15_23
    b_rooftop1_start
)

(script static boolean obj_rrun_c_15_25
    b_rooftop1_start
)

(script static boolean obj_radvan_15_27
    b_rooftop1_start
)

(script static boolean obj_radvan_15_29
    b_rooftop1_start
)

(script static boolean obj_radvan_15_31
    b_rooftop1_start
)

(script static boolean obj_r123_d_15_33
    (<= objcon_ride 70)
)

(script static boolean obj_r789_s_15_40
    (<= objcon_ride 110)
)

(script static boolean obj_todst__17_5
    (>= objcon_trophy 20)
)

(script static boolean obj_todst__17_6
    (= b_trophy_complete true)
)

(script static boolean obj_ttroop_17_8
    (= b_trophy_complete true)
)

(script static boolean obj_todst__17_10
    (<= (ai_task_count "obj_trophy_cov/gate_entrance") 3)
)

(script static boolean obj_ttroop_17_12
    (<= (ai_task_count "obj_trophy_cov/gate_entrance") 1)
)

(script static boolean obj_todst__17_13
    (and (= b_trophy_counterattack true) (<= (ai_task_count "obj_trophy_cov/gate_interior") 3))
)

(script static boolean obj_ttroop_17_14
    (and (= b_trophy_counterattack true) (<= (ai_task_count "obj_trophy_cov/gate_interior") 1))
)

(script static boolean obj_tcivil_17_16
    (= b_ride_falcon_landed true)
)

(script static boolean obj_tcivil_17_17
    (= b_ride_falcon_landed true)
)

(script static boolean obj_tcivil_17_21
    (= b_evac1_landed true)
)

(script static boolean obj_todst__17_22
    (volume_test_players "tv_pad_entrance_mid")
)

(script static boolean obj_ttroop_17_23
    (volume_test_players "tv_pad_entrance_mid")
)

(script static boolean obj_todst__17_24
    (and (<= (ai_task_count "obj_trophy_cov/balcony_entrance") 0) (volume_test_players "tv_balcony_entrance"))
)

(script static boolean obj_tbreak_17_25
    (ai_allegiance_broken player human)
)

(script static boolean obj_tremov_17_26
    b_falcon_goto_load_hover
)

(script static void ins_panoptical
    (if debug
        (print "::: insertion point: panoptical")
    )
    (set s_active_insertion_index s_index_panoptical)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_panoptical_010_020")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_panoptical_player0")
    (object_teleport (player1) "spawn_panoptical_player1")
    (object_teleport (player2) "spawn_panoptical_player2")
    (object_teleport (player3) "spawn_panoptical_player3")
    (if (editor_mode)
        (insertion_fade_to_gameplay)
    )
)

(script static void ins_towers
    (if debug
        (print "::: insertion point: towers")
    )
    (set s_active_insertion_index s_index_towers)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_interior_010_020_030")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_towers_player0")
    (object_teleport (player1) "spawn_towers_player1")
    (object_teleport (player2) "spawn_towers_player2")
    (object_teleport (player3) "spawn_towers_player3")
    (insertion_fade_to_gameplay)
)

(script static void ins_interior
    (if debug
        (print "::: insertion point: interior")
    )
    (set s_active_insertion_index s_index_interior)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_interior_010_020_030")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_interior_player0")
    (object_teleport (player1) "spawn_interior_player1")
    (object_teleport (player2) "spawn_interior_player2")
    (object_teleport (player3) "spawn_interior_player3")
    (wake md_amb_cruiser01)
    (insertion_fade_to_gameplay)
)

(script static void ins_canyonview
    (if debug
        (print "::: insertion point: canyon view")
    )
    (set s_active_insertion_index s_index_canyonview)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_canyonview_030_040")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_canyonview_player0")
    (object_teleport (player1) "spawn_canyonview_player1")
    (object_teleport (player2) "spawn_canyonview_player2")
    (object_teleport (player3) "spawn_canyonview_player3")
    (sleep 1)
    (wake ambient_spawn_dropships)
    (wake ambient_wraith_shells_a)
    (wake ambient_wraith_shells_b)
    (player_set_profile "profile_combat")
    (insertion_fade_to_gameplay)
)

(script static void ins_atrium
    (if debug
        (print "::: insertion point: atrium")
    )
    (set s_active_insertion_index s_index_atrium)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_atrium_040_050_060")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_atrium_player0")
    (object_teleport (player1) "spawn_atrium_player1")
    (object_teleport (player2) "spawn_atrium_player2")
    (object_teleport (player3) "spawn_atrium_player3")
    (ai_place "atrium_unsc_troopers")
    (device_set_position "dm_canyonview_door1" 1)
    (player_set_profile "profile_combat")
    (insertion_fade_to_gameplay)
)

(script static void ins_ready
    (if debug
        (print "::: insertion point: ready room")
    )
    (set s_active_insertion_index s_index_ready)
    (fade_out 0 0 0 0)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_ready_player0")
    (object_teleport (player1) "spawn_ready_player1")
    (object_teleport (player2) "spawn_ready_player2")
    (object_teleport (player3) "spawn_ready_player3")
    (wake alpha_insertion_objective)
    (sleep 5)
    (player_set_profile "profile_combat")
    (fade_in 0 0 0 30)
    (mus_start mus_09)
)

(script dormant void alpha_insertion_objective
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_jetpack" "primary_objective_6")
)

(script static void ins_jetpack_low
    (if debug
        (print "::: insertion point: jetpack low")
    )
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_jetpack_low_player0")
    (object_teleport (player1) "spawn_jetpack_low_player1")
    (object_teleport (player2) "spawn_jetpack_low_player2")
    (object_teleport (player3) "spawn_jetpack_low_player3")
    (ai_place "unsc_jl_odsts/low0")
    (ai_place "unsc_jl_odsts/low1")
    (ai_place "unsc_jl_odsts1/low0")
    (ai_place "unsc_jl_odsts1/low1")
    (if (not (game_is_cooperative))
        (begin
            (ai_player_add_fireteam_squad player0 "unsc_jl_odsts")
            (ai_player_add_fireteam_squad player0 "unsc_jl_odsts1")
        )
    )
    (sleep 1)
    (ai_set_objective "unsc_jl_odsts" "obj_jetpack_low_unsc")
    (ai_set_objective "unsc_jl_odsts1" "obj_jetpack_low_unsc")
    (wake jl_odst_renew)
    (player_set_profile "profile_jetpack")
    (jp)
    (set s_active_insertion_index s_index_jetpack_low)
    (insertion_fade_to_gameplay)
    (sleep 1)
)

(script static void ins_jetpack_high
    (if debug
        (print "::: insertion point: jetpack high")
    )
    (set s_active_insertion_index s_index_jetpack_high)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (objects_manage_4b)
    (object_teleport (player0) "spawn_jetpack_high_player0")
    (object_teleport (player1) "spawn_jetpack_high_player1")
    (object_teleport (player2) "spawn_jetpack_high_player2")
    (object_teleport (player3) "spawn_jetpack_high_player3")
    (player_set_profile "profile_jetpack")
    (jp)
    (insertion_fade_to_gameplay)
    (sleep 1)
)

(script static void ins_trophy
    (if debug
        (print "::: insertion point: trophy")
    )
    (set s_active_insertion_index s_index_trophy)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (objects_manage_4b)
    (soft_ceiling_enable "low_jetpack_blocker" false)
    (object_teleport (player0) "spawn_trophy_player0")
    (object_teleport (player1) "spawn_trophy_player1")
    (object_teleport (player2) "spawn_trophy_player2")
    (object_teleport (player3) "spawn_trophy_player3")
    (ai_place "jh_unsc_mars_tree_inf0/sf_trophy")
    (ai_place "jh_unsc_mars_balcony_inf0/sf_trophy")
    (ai_place "jh_unsc_odst_balcony_inf0/sp_trophy")
    (ai_place "jh_unsc_odst_tree_inf0/sp_trophy")
    (ai_place "jh_civilians0/sf_trophy")
    (wake jh_odst_renew)
    (player_set_profile "profile_jetpack")
    (jp)
    (insertion_fade_to_gameplay)
    (sleep 1)
)

(script static void ins_ride
    (if debug
        (print "::: insertion point: ride")
    )
    (set s_active_insertion_index s_index_ride)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_jetpack_060_070_080")
            (sleep 1)
        )
    )
    (objects_manage_4b)
    (soft_ceiling_enable "low_jetpack_blocker" false)
    (object_teleport (player0) "spawn_ride_player0")
    (object_teleport (player1) "spawn_ride_player1")
    (object_teleport (player2) "spawn_ride_player2")
    (object_teleport (player3) "spawn_ride_player3")
    (set b_trophy_complete true)
    (ai_place "sq_evac1_m1" 10)
    (ai_place "jh_unsc_odst_balcony_inf0/sp_ride")
    (ai_place "jh_unsc_odst_tree_inf0/sp_ride")
    (ai_place "jh_unsc_mars_balcony_inf0/sp_ride" 3)
    (sleep 1)
    (ai_force_full_lod "gr_civilian")
    (ai_lod_full_detail_actors 15)
    (ai_set_objective "jh_unsc_odst_balcony_inf0" "obj_trophy_unsc")
    (ai_set_objective "jh_unsc_odst_tree_inf0" "obj_trophy_unsc")
    (ai_set_objective "jh_unsc_mars_balcony_inf0" "obj_trophy_unsc")
    (flock_create "fl_shared_banshee0")
    (flock_create "fl_shared_falcon0")
    (flock_create "fl_shared_banshee1")
    (flock_create "fl_shared_falcon1")
    (flock_create "fl_corvette_phantom1")
    (player_set_profile "profile_jetpack")
    (jp)
    (insertion_fade_to_gameplay)
    (mus_start mus_10)
    (wake bravo_insertion_objective)
    (set b_jetpack_complete true)
)

(script dormant void bravo_insertion_objective
    (sleep objective_delay)
    (f_hud_obj_new "ct_objective_transports" "primary_objective_10")
)

(script static void ins_starport
    (if debug
        (print "::: insertion point: starport")
    )
    (set s_active_insertion_index s_index_starport)
    (insertion_snap_to_black)
    (if (!= (current_zone_set) s_zoneset_all_index)
        (begin
            (if debug
                (print "switching zone sets...")
            )
            (switch_zone_set "set_starport_090")
            (sleep 1)
        )
    )
    (object_teleport (player0) "spawn_starport_player0")
    (object_teleport (player1) "spawn_starport_player1")
    (object_teleport (player2) "spawn_starport_player2")
    (object_teleport (player3) "spawn_starport_player3")
    (ai_place "starport_insertion_unsc")
    (ai_place "starport_insertion0_unsc")
    (flock_create "fl_shared_banshee2")
    (flock_create "fl_shared_falcon2")
    (flock_create "fl_corvette_phantom2")
    (object_destroy "dm_civilian_transport")
    (set b_starport_monologue true)
    (set b_starport_intro true)
    (set b_falcon_unloaded true)
    (set b_falcon_lz_setup true)
    (player_set_profile "profile_jetpack")
    (jp)
    (sleep 1)
    (insertion_fade_to_gameplay)
)

(script static void test_starport
    (ins_starport)
    (sleep 1)
    (jp)
)

(script static void jp
    (unit_add_equipment (player0) "profile_jetpack" true true)
    (unit_add_equipment (player1) "profile_jetpack" true true)
    (unit_add_equipment (player2) "profile_jetpack" true true)
    (unit_add_equipment (player3) "profile_jetpack" true true)
)

(script static void duck_and_cover_canyon0
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void canyonview_brute0
    (performance_play_line "teleport_brute")
    (performance_play_line "teleport_civilian")
    (performance_play_line "brute_sync")
    (sleep_until (sleep_brute0 (performance_get_actor "brute_0")))
    (performance_play_line "conditional_sleep")
    (performance_play_line "brute_exit")
    (performance_play_line "wait")
    (ai_kill_silent (performance_get_actor "civilian_0"))
    (performance_play_line "kill_civilian")
    (performance_play_line "block")
)

(script static void canyonview_brute1
    (performance_play_line "teleport_brute")
    (performance_play_line "teleport_civilian")
    (performance_play_line "brute_sync")
    (sleep_until (branch_brute1 (performance_get_actor "brute_1")))
    (performance_play_line "conditional_sleep")
    (performance_play_line "brute_exit")
    (performance_play_line "wait")
    (ai_kill_silent (performance_get_actor "civilian_1"))
    (performance_play_line "kill_civilian")
    (performance_play_line "block")
)

(script static void canyonview_brute2
    (performance_play_line "teleport_brute")
    (performance_play_line "teleport_civilian")
    (performance_play_line "brute_sync")
    (sleep_until (branch_brute2 (performance_get_actor "brute_2")))
    (performance_play_line "conditional_sleep")
    (performance_play_line "brute_exit")
    (performance_play_line "wait")
    (ai_kill_silent (performance_get_actor "civilian_2"))
    (performance_play_line "kill_civilian")
    (performance_play_line "block")
)

(script static void ready_odsts_suit_up
    (performance_play_line "odst0_goto_readyup")
    (performance_play_line "odst0_pose_readyup")
    (performance_play_line "odst0_align")
    (performance_play_line "odst1_goto_readyup")
    (performance_play_line "sleep1")
    (performance_play_line "odst1_pose_readyup")
    (performance_play_line "block")
)

(script static void ready_odsts_breach
    (performance_play_line "odst1_rush")
    (wake md_jp_doors_open)
    (performance_play_line "odst0_salute")
    (performance_play_line "wait_to_rush")
    (performance_play_line "odst0_rush")
    (performance_play_line "block")
)

(script static void ready_odsts_wave
    (wake md_jp_player_crosses)
    (performance_play_line "odst0_goto_readyup")
    (performance_play_line "odst0_pose_wave")
)

(script static void starport_intro
    (cs_stow (performance_get_actor "commander") true)
    (performance_play_line "stow")
    (sleep_until b_starport_intro 1)
    (performance_play_line "conditional_sleep")
    (performance_play_line "commander_goto")
    (performance_play_line "commander_align")
    (wake md_commander_dialogue)
    (performance_play_line "commander_animate")
)

(script static void starport_turret0_activate
    (performance_play_line "tech_goto_terminal")
    (performance_play_line "tech_enter_code")
)

(script static void starport_turret1_activate
    (performance_play_line "tech_goto_terminal")
    (performance_play_line "tech_enter_code")
)

(script static void panoptical_injured
    (performance_play_line "civilian0_spawn")
    (performance_play_line "civilian2_spawn")
    (performance_play_line "civilian3_spawn")
    (performance_play_line "civilian0_animate")
    (performance_play_line "civilian2_animate")
    (performance_play_line "civilian3_animate")
    (performance_play_line "block")
)

(script static void ready_injured
    (performance_play_line "spawn0")
    (performance_play_line "spawn1")
    (performance_play_line "spawn2")
    (performance_play_line "spawn3")
    (performance_play_line "animate0")
    (performance_play_line "animate1")
    (performance_play_line "animate2")
    (performance_play_line "animate3")
    (performance_play_line "block")
)

(script static void ready_point
    (performance_play_line "goto")
    (performance_play_line "sleep")
    (wake md_ready_outside_door)
    (performance_play_line "animate")
)

(script static void duck_and_cover_atrium0
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium1
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium2
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium3
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium4
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium5
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_atrium6
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon1
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon3
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon5
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon6
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon7
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon12
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_canyon14
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack0
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack1
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack2
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack3
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack4
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack5
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack6
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack7
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack8
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void duck_and_cover_jetpack9
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void trophy_odst_salute
    (performance_play_line "odst0_goto")
    (performance_play_line "odst0_animate")
    (performance_play_line "odst1_goto")
    (performance_play_line "sleep1")
    (performance_play_line "odst1_animate")
)

(script static void duck_and_cover_atrium7
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon1
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon2
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon4
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon5
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon6
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon7
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon8
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon9
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon10
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon11
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon12
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon14
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon18
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon21
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void bunker_unarmed_canyon29
    (branch (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0) (f_branch_empty01))
    (performance_play_line "branch")
    (performance_play_line "move_to_center")
    (performance_play_line "animate_enter")
    (performance_play_line "animate_idle")
    (performance_play_line "animate_exit")
)

(script static void 050la_wake_010_sc_sh1
    (fade_in 0 0 0 0)
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "050la_wake_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "050la_wake_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "light_marker_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "fx_dyn_light_pack_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "real_magnum_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "re_entry_pack_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 5 "fx_dyn_light_ground_1" true)
    (cinematic_scripting_create_and_animate_object_no_animation 0 0 6 true)
    (cinematic_scripting_create_and_animate_object_no_animation 0 0 7 true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure 0.5 0)
    (cinematic_scripting_start_effect 0 0 0 "sky_streaks")
    (cinematic_scripting_start_music 0 0 0)
    (cinematic_scripting_start_effect 0 0 1 "distant_sky_streaks")
    (cinematic_scripting_start_screen_effect 0 0 0)
    (cinematic_scripting_start_music 0 0 1)
    (sleep 1520)
    (fade_out 0 0 0 65)
    (cinematic_print "custom script play")
    (sleep 72)
    (cinematic_scripting_stop_screen_effect 0 0 0)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !050la_wake_010_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (050la_wake_010_sc_sh1)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 050la_wake_030_sc_sh1
    (begin
        (fade_out 0 0 0 0)
        (object_destroy "sc_corvette1")
        (object_destroy "sc_corvette2")
        (object_destroy "sc_corvette3")
        (object_destroy "sc_corvette4")
        (object_destroy "sc_corvette2_no_turrets")
    )
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1) 0 "050la_wake_030_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1) 0)
    (cinematic_object_create_cinematic_anchor "050la_wake_030_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 0 "magnum_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 1 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 2 "dogtags_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 3 "fx_dyn_light_ridge_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 4 "fx_dyn_light_start_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 5 "fx_dyn_light_hill_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 6 "corvette_01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 7 "corvette_02_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 8 "corvette_03_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 9 "fx_light_marker_1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 10 "fx_dyn_light_ridge2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 11 "fx_light_marker_overhead_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 0 12 "city_clouds_blocker_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure -1 0)
    (sleep 120)
    (fade_in 0 0 0 60)
    (cinematic_print "custom script play")
    (sleep 440)
    (cinematic_set_title "050la_cine_timestamp_01")
    (cinematic_print "custom script play")
    (sleep 135)
    (cinematic_print "custom script play")
    (cinematic_set_title "050la_cine_timestamp_02")
    (sleep 113)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050la_wake_030_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 1) 1 "050la_wake_030_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 1) 1)
    (cinematic_object_create_cinematic_anchor "050la_wake_030_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 0 "magnum_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 1 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 2 "dogtags_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 3 "fx_dyn_light_ridge_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 4 "fx_dyn_light_start_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 5 "fx_dyn_light_hill_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 6 "corvette_01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 7 "corvette_02_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 8 "corvette_03_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 9 "fx_light_marker_1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 10 "fx_dyn_light_ridge2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 11 "fx_light_marker_overhead_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 1 1 12 "city_clouds_blocker_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (render_exposure -1 0)
    (sleep 150)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !050la_wake_030_sc
    (cinematic_print "beginning scene 2")
    (cinematic_scripting_create_scene 1)
    (050la_wake_030_sc_sh1)
    (050la_wake_030_sc_sh2)
    (cinematic_scripting_destroy_scene 1)
)

(script static void 050la_wake_040_sc_sh1
    (fade_in 1 1 1 0)
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 2) 0 "050la_wake_040_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 2) 0)
    (cinematic_object_create_cinematic_anchor "050la_wake_040_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 0 "player_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 1 "magnum_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 2 "fx_dyn_light_sun01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 3 "fx_light_marker_1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 0 4 "fx_light_marker_2_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (render_exposure -0.1 0)
    (sleep 413)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050la_wake_040_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 2) 1 "050la_wake_040_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 2) 1)
    (cinematic_object_create_cinematic_anchor "050la_wake_040_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 2 1 0 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 1 1 "magnum_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 1 2 "fx_dyn_light_sun01_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 1 3 "fx_light_marker_1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 2 1 4 "fx_light_marker_2_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (cinematic_scripting_start_music 2 1 0)
    (sleep 506)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !050la_wake_040_sc
    (cinematic_print "beginning scene 3")
    (cinematic_scripting_create_scene 2)
    (050la_wake_040_sc_sh1)
    (050la_wake_040_sc_sh2)
    (cinematic_scripting_destroy_scene 2)
)

(script static void 050la_wake_050_sc_sh1
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 3) 0 "050la_wake_040_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 3) 0)
    (cinematic_object_create_cinematic_anchor "050la_wake_040_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 0 "fx_dyn_light_sun01_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 1 "fx_light_marker_1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 2 "fx_light_marker_2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 3 "magnum_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 3 0 4 "player_fp_1" true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_show_letterbox_immediate false)
    (cinematic_print "custom script play")
    (sleep 162)
    (sleep (cinematic_tag_fade_out_from_cinematic "050la_wake"))
    (sleep 4)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !050la_wake_050_sc
    (cinematic_print "beginning scene 4")
    (cinematic_scripting_create_scene 3)
    (050la_wake_050_sc_sh1)
    (cinematic_scripting_destroy_scene 3)
)

(script static void 050la_wake_cleanup
    (cinematic_scripting_clean_up 0)
)

(script static void begin_050la_wake_debug
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

(script static void end_050la_wake_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 0)
    (fade_in 0 0 0 0)
)

(script static void 050la_wake_debug
    (begin_050la_wake_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "050la_wake"))
    (!050la_wake_010_sc)
    (!050la_wake_030_sc)
    (!050la_wake_040_sc)
    (!050la_wake_050_sc)
    (end_050la_wake_debug)
)

(script static void begin_050la_wake
    (cinematic_zone_activate 0)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 0))
)

(script static void end_050la_wake
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050la_wake
    (begin_050la_wake)
    (sleep (cinematic_tag_fade_in_to_cinematic "050la_wake"))
    (!050la_wake_010_sc)
    (!050la_wake_030_sc)
    (!050la_wake_040_sc)
    (!050la_wake_050_sc)
    (end_050la_wake)
)

(script static void 050lb_reunited_010_sc_sh1
    (object_destroy "sc_corvette2")
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 0 "050lb_reunited_010_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 0)
    (cinematic_object_create_cinematic_anchor "050lb_reunited_010_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 0 "civilianship_transport_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 1 "corvette_1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 2 "impact_fx_marker1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 3 "impact_fx_marker2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 4 "impact_fx_marker3_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 5 "impact_fx_marker4_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 6 "impact_fx_marker5_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 7 "impact_fx_marker6_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 8 "missile_1_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 9 "missile_2_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 10 "missile_3_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 11 "missile_4_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 12 "missile_5_1" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 13 "missile_6_1" true)
    (object_hide (cinematic_scripting_get_object 0 14) true)
    (object_hide (cinematic_scripting_get_object 0 15) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 0 16 "fx_dyn_light_player_1" true)
    (object_hide (cinematic_scripting_get_object 0 17) true)
    (object_hide (cinematic_scripting_get_object 0 18) true)
    (object_hide (cinematic_scripting_get_object 0 19) true)
    (cinematic_lights_initialize_for_shot 0)
    (cinematic_clips_initialize_for_shot 0)
    (cinematic_scripting_start_effect 0 0 0 (cinematic_object_get "missile_1"))
    (cinematic_scripting_start_effect 0 0 3 (cinematic_object_get "missile_4"))
    (cinematic_scripting_start_effect 0 0 4 (cinematic_object_get "missile_5"))
    (cinematic_scripting_start_effect 0 0 1 (cinematic_object_get "missile_2"))
    (cinematic_scripting_start_effect 0 0 2 (cinematic_object_get "missile_3"))
    (cinematic_scripting_start_effect 0 0 5 (cinematic_object_get "missile_6"))
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 0) "thrusters" 1 0)
    (cinematic_scripting_start_music 0 0 0)
    (sleep 125)
    (cinematic_print "custom script play")
    (cinematic_object_destroy "missile_1")
    (cinematic_scripting_start_effect 0 0 6 (cinematic_object_get "impact_fx_marker1"))
    (sleep 3)
    (cinematic_print "custom script play")
    (cinematic_object_destroy "missile_2")
    (cinematic_scripting_start_effect 0 0 7 (cinematic_object_get "impact_fx_marker2"))
    (sleep 2)
    (cinematic_scripting_start_effect 0 0 12 (cinematic_object_get "impact_fx_marker3"))
    (cinematic_print "custom script play")
    (cinematic_object_destroy "missile_3")
    (cinematic_scripting_start_effect 0 0 8 (cinematic_object_get "impact_fx_marker3"))
    (sleep 5)
    (cinematic_print "custom script play")
    (cinematic_scripting_start_effect 0 0 9 (cinematic_object_get "impact_fx_marker4"))
    (cinematic_object_destroy "missile_4")
    (sleep 5)
    (cinematic_print "custom script play")
    (cinematic_object_destroy "missile_5")
    (cinematic_scripting_start_effect 0 0 10 (cinematic_object_get "impact_fx_marker5"))
    (sleep 5)
    (cinematic_scripting_start_effect 0 0 13 (cinematic_object_get "impact_fx_marker6"))
    (cinematic_object_destroy "missile_6")
    (cinematic_print "custom script play")
    (cinematic_scripting_start_effect 0 0 11 (cinematic_object_get "impact_fx_marker6"))
    (sleep 114)
    (cinematic_scripting_start_dialogue 0 0 0 none)
    (sleep 75)
    (cinematic_scripting_start_dialogue 0 0 1 none)
    (sleep 16)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050lb_reunited_010_sc_sh2
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 1 "050lb_reunited_010_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 1)
    (cinematic_object_create_cinematic_anchor "050lb_reunited_010_anchor")
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 0 "civilianship_transport_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 1 "corvette_1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 2 "impact_fx_marker1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 3 "impact_fx_marker2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 4 "impact_fx_marker3_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 5 "impact_fx_marker4_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 6 "impact_fx_marker5_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 7 "impact_fx_marker6_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 8 "missile_1_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 9 "missile_2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 10 "missile_3_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 11 "missile_4_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 12 "missile_5_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 13 "missile_6_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 14 "player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 15 "player_ar_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 16 "fx_dyn_light_player_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 17 "civilianship_transport_2_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 18 "civilianship_transport_3_2" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 1 19 "flare_1_2" true)
    (cinematic_lights_initialize_for_shot 1)
    (cinematic_clips_initialize_for_shot 1)
    (render_exposure -0.2 0)
    (cinematic_scripting_start_music 0 1 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 17) "thrusters" 1 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 18) "thrusters" 1 0)
    (object_set_cinematic_function_variable (cinematic_scripting_get_object 0 0) "thrusters" 1 0)
    (sleep 92)
    (cinematic_scripting_start_dialogue 0 1 0 none)
    (sleep 164)
    (cinematic_scripting_start_dialogue 0 1 1 none)
    (sleep 70)
    (cinematic_scripting_start_dialogue 0 1 2 none)
    (sleep 288)
    (cinematic_scripting_start_dialogue 0 1 3 (cinematic_scripting_get_object 0 14))
    (sleep 68)
    (cinematic_scripting_start_dialogue 0 1 4 none)
    (sleep 59)
    (cinematic_scripting_start_dialogue 0 1 5 none)
    (sleep 74)
    (cinematic_scripting_start_dialogue 0 1 6 none)
    (sleep 46)
    (cinematic_scripting_start_dialogue 0 1 7 none)
    (sleep 214)
    (cinematic_scripting_start_effect 0 1 0 (cinematic_object_get "flare_1"))
    (sleep 202)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050lb_reunited_010_sc_sh3
    (camera_set_cinematic_scene (cinematic_tag_reference_get_scene 0) 2 "050lb_reunited_010_anchor")
    (cinematic_set_shot (cinematic_tag_reference_get_scene 0) 2)
    (cinematic_object_create_cinematic_anchor "050lb_reunited_010_anchor")
    (object_hide (cinematic_scripting_get_object 0 0) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 1 "corvette_1_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 2 "impact_fx_marker1_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 3 "impact_fx_marker2_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 4 "impact_fx_marker3_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 5 "impact_fx_marker4_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 6 "impact_fx_marker5_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 7 "impact_fx_marker6_3" true)
    (object_hide (cinematic_scripting_get_object 0 8) true)
    (object_hide (cinematic_scripting_get_object 0 9) true)
    (object_hide (cinematic_scripting_get_object 0 10) true)
    (object_hide (cinematic_scripting_get_object 0 11) true)
    (object_hide (cinematic_scripting_get_object 0 12) true)
    (object_hide (cinematic_scripting_get_object 0 13) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 14 "player_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 15 "player_ar_3" true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 16 "fx_dyn_light_player_3" true)
    (object_hide (cinematic_scripting_get_object 0 17) true)
    (object_hide (cinematic_scripting_get_object 0 18) true)
    (cinematic_scripting_create_and_animate_cinematic_object 0 2 19 "flare_1_3" true)
    (cinematic_lights_initialize_for_shot 2)
    (cinematic_clips_initialize_for_shot 2)
    (render_exposure 0.2 0)
    (cinematic_scripting_start_effect 0 2 0 (cinematic_object_get "impact_fx_marker3"))
    (cinematic_scripting_start_effect 0 2 1 (cinematic_object_get "impact_fx_marker6"))
    (sleep 203)
    (sleep (cinematic_tag_fade_out_from_cinematic "050lb_reunited"))
    (sleep 14)
    (cinematic_lights_destroy_shot)
    (cinematic_clips_destroy)
    (render_exposure_fade_out 0)
)

(script static void !050lb_reunited_010_sc
    (cinematic_print "beginning scene 1")
    (cinematic_scripting_create_scene 0)
    (050lb_reunited_010_sc_sh1)
    (050lb_reunited_010_sc_sh2)
    (050lb_reunited_010_sc_sh3)
    (cinematic_scripting_destroy_scene 0)
)

(script static void 050lb_reunited_cleanup
    (cinematic_scripting_clean_up 1)
)

(script static void begin_050lb_reunited_debug
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

(script static void end_050lb_reunited_debug
    (cinematic_destroy)
    (cinematic_stop)
    (camera_control false)
    (render_exposure_fade_out 0)
    (cinematic_zone_deactivate 1)
    (fade_in 0 0 0 0)
)

(script static void 050lb_reunited_debug
    (begin_050lb_reunited_debug)
    (sleep (cinematic_tag_fade_in_to_cinematic "050lb_reunited"))
    (cinematic_outro_start)
    (!050lb_reunited_010_sc)
    (end_050lb_reunited_debug)
)

(script static void begin_050lb_reunited
    (cinematic_zone_activate 1)
    (sleep 2)
    (camera_set_cinematic)
    (cinematic_set_debug_mode false)
    (cinematic_set (cinematic_tag_reference_get_cinematic 1))
)

(script static void end_050lb_reunited
    (cinematic_destroy)
    (render_exposure_fade_out 0)
)

(script static void 050lb_reunited
    (begin_050lb_reunited)
    (sleep (cinematic_tag_fade_in_to_cinematic "050lb_reunited"))
    (cinematic_outro_start)
    (!050lb_reunited_010_sc)
    (end_050lb_reunited)
)

(script static void duck_and_cover_canyon0_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium0_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium1_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium2_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium3_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium4_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium5_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium6_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon1_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon3_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon5_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon6_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon7_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon12_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_canyon14_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack0_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack1_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack2_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack3_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack4_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack5_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack6_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack7_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack8_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_jetpack9_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void duck_and_cover_atrium7_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon1_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon2_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon4_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon5_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon6_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon7_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon8_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon9_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon10_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon11_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon12_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon14_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon18_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon21_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

(script static void bunker_unarmed_canyon29_to_f_branch_empty01
    (> (object_get_recent_body_damage (ai_get_object (performance_get_actor "civilian"))) 0)
    (f_branch_empty01)
)

; Decompilation finished in ~0.1796722s
