(script static boolean introearly_0_1
(>= g_ih_obj_control 2))

(script static boolean pelicstalk_3_2
g_ph_stalker_retreat)

(script static boolean pelictop_g_3_4
(<= g_ph_obj_control 6))

(script static boolean pelicpure__3_9
(<= (ai_task_count pelican_hill_obj/combat_top_01) 0))

(script static boolean pelicbotto_3_16
(<= g_ph_obj_control 5))

(script static boolean pelicbotto_3_17
(<= g_ph_obj_control 5))

(script static boolean peliccarri_3_18
(>= g_ph_obj_control 4))

(script static boolean peliccarri_3_19
(>= g_ph_obj_control 3))

(script static boolean pelicupper_3_22
(>= g_ph_obj_control 4))

(script static boolean pelicbotto_3_25
(<= g_ph_obj_control 3))

(script static boolean peliccomba_3_30
(<= g_ph_obj_control 5))

(script static boolean peliccomba_3_31
(<= g_ph_obj_control 6))

(script static boolean cafettank__6_13
(>= g_br_obj_control 3))

(script static boolean cafetgate__6_14
(<= g_br_obj_control 1))

(script static boolean hallwpure__7_7
(>= (ai_combat_status hallway_4_obj) 5))

(script static boolean hallwmid_p_7_8
(<= g_hc_obj_control 3))

(script static boolean hallwini_p_7_9
(<= g_hc_obj_control 2))

(script static boolean hallwpuref_7_11
(>= g_hc_obj_control 5))

(script static boolean hallwcomba_7_12
(>= g_hc_obj_control 5))

(script static boolean hallwcomba_7_13
(>= (ai_task_count hallway_4_obj/combat_01) 0))

(script static boolean prisofloor_8_6
(<= g_pr_obj_control 1))

(script static boolean prisofloor_8_7
(<= g_pr_obj_control 2))

(script static boolean prisopuref_8_10
(<= g_pr_obj_control 1))

(script static boolean prisopuref_8_11
(<= g_pr_obj_control 2))

(script static boolean reactini_p_10_4
(<= g_re_obj_control 4))

(script static boolean reactini_p_10_5
(<= g_re_obj_control 4))

(script static boolean reactini_p_10_6
(<= g_re_obj_control 3))

(script static boolean reactini_c_10_8
(<= g_re_obj_control 5))

(script static boolean reactini_c_10_9
(<= g_re_obj_control 3))

(script static boolean reactini_p_10_16
(<= g_re_obj_control 4))

(script static boolean reactini_p_10_18
(<= g_re_obj_control 4))

(script static boolean reactold_p_12_0
(AND (< (objects_distance_to_flag (players) pylon_03_flag) 10) (= (device_group_get pylons) 1)))

(script static boolean reactold_p_12_1
(AND (< (objects_distance_to_flag (players) pylon_02_flag) 10) (= (device_group_get pylons) 1)))

(script static boolean reactold_p_12_2
(AND (< (objects_distance_to_flag (players) pylon_01_flag) 10) (= (device_group_get pylons) 1)))

(script static boolean reactoldsk_12_3
(= reactor_blown FALSE))

(script static boolean reactpure__12_7
(not reactor_blown))

(script static boolean reactpure__12_8
(not reactor_blown))

(script static boolean hall4retre_13_1
(<= g_hcr_obj_control 1))

(script static boolean hall4retre_13_2
(<= g_hcr_obj_control 2))

(script static boolean hall4poke_13_4
(<= g_hcr_obj_control 5))

(script static boolean cafe_jumpe_14_3
(>= g_brr_obj_control 4))

(script static boolean hallsretre_15_1
(>= g_habr_obj_control 3))

(script static boolean pel_hattac_16_1
(= (volume_test_players vol_pel_rev_right) TRUE))

(script static boolean pel_hattac_16_2
(= (volume_test_players vol_pel_rev_left) TRUE))

(script static boolean pel_hretre_16_6
(= (volume_test_players vol_pel_hill_rev_01) FALSE))

(script static boolean pel_harbit_16_10
(volume_test_players vol_pel_hill_rev_top))

(script static boolean pel_harbit_16_11
(volume_test_players vol_pel_hill_rev_board))

(script static boolean pel_harbit_16_12
(volume_test_players vol_pelican_ledge))

