(script static boolean obj_helite_0_5
(<= g_hill_obj_control 2))

(script static boolean obj_hgrunt_0_8
(<= g_hill_obj_control 2))

(script static boolean obj_hjacka_0_9
(<= g_hill_obj_control 2))

(script static boolean obj_hcov_h_0_10
(>= g_hill_obj_control 5))

(script static boolean obj_hrush__0_22
(volume_test_players tv_hill_starting_area))

(script static boolean obj_hkat_f_1_3
(>= g_hill_obj_control 1))

(script static boolean obj_hkat_a_1_4
(>= g_hill_obj_control 2))

(script static boolean obj_hkat_h_1_5
(>= g_hill_obj_control 4))

(script static boolean obj_hkat_w_1_7
(volume_test_players tv_hill_kat))

(script static boolean obj_hdrive_1_10
(any_players_in_vehicle))

(script static boolean obj_htasks_1_12
(volume_test_players tv_hill_leftside))

(script static boolean obj_htasks_1_13
(>= g_hill_obj_control 3))

(script static boolean obj_htasks_1_14
(volume_test_players tv_hill_leftside))

(script static boolean obj_hhog_d_1_15
(volume_test_objects tv_hill_hog_drop (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)))

(script static boolean obj_tskirm_2_8
(< g_twin_obj_control 2))

(script static boolean obj_tskirm_2_9
(< g_twin_obj_control 1))

(script static boolean obj_tlower_2_12
(not (volume_test_players tv_twin_lower)))

(script static boolean obj_tskirm_2_27
(volume_test_players tv_twin_upper_center))

(script static boolean obj_ttwin__2_33
g_bfg01_core_destroyed)

(script static boolean obj_taa_ba_2_36
(not (volume_test_players tv_twin_lower_final)))

(script static boolean obj_ttasks_2_39
(>= g_twin_obj_control 2))

(script static boolean obj_ttasks_2_42
(volume_test_players tv_twin_lower_start))

(script static boolean obj_ttasks_2_43
g_bfg01_core_destroyed)

(script static boolean obj_ttasks_2_44
(not (volume_test_players tv_twin_upper)))

(script static boolean obj_twrait_2_45
(volume_test_players tv_twin_upper_center))

(script static boolean obj_taa_el_2_48
(volume_test_players tv_twin_gun))

(script static boolean obj_tbfg01_3_0
g_bfg01_destroyed)

(script static boolean obj_ttroop_3_5
(volume_test_players tv_twin_lower_start))

(script static boolean obj_ttroop_3_6
(volume_test_players tv_twin_lower_approach))

(script static boolean obj_ttroop_3_7
(volume_test_players tv_twin_lower_siege))

(script static boolean obj_ttroop_3_8
(volume_test_players tv_twin_lower_final))

(script static boolean obj_tvehic_3_11
g_bfg01_destroyed)

(script static boolean obj_tvehic_3_13
(volume_test_players tv_twin_lower_start))

(script static boolean obj_tbfg01_3_14
g_bfg01_core_destroyed)

(script static boolean obj_tvehic_3_15
(<= (ai_living_count sq_twin_wraith_01) 0))

(script static boolean obj_tvehic_3_16
(volume_test_players tv_twin_upper_vehicle))

(script static boolean obj_fjacka_4_1
(< g_facility_obj_control 3))

(script static boolean obj_fskirm_4_5
(< g_facility_obj_control 5))

(script static boolean obj_fskirm_4_7
(< g_facility_obj_control 8))

(script static boolean obj_ffork__4_10
(< g_facility_obj_control 6))

(script static boolean obj_fcov_0_4_15
(< g_facility_obj_control 10))

(script static boolean obj_fcov_0_4_16
(< g_facility_obj_control 11))

(script static boolean obj_fcov_0_4_17
(< g_facility_obj_control 12))

(script static boolean obj_fjacka_4_19
(< g_facility_obj_control 7))

(script static boolean obj_fjacka_4_20
(< g_facility_obj_control 8))

(script static boolean obj_fjacka_4_27
(>= g_facility_obj_control 14))

(script static boolean obj_fgrunt_4_31
(>= g_facility_obj_control 15))

(script static boolean obj_fjacka_4_33
(< g_facility_obj_control 13))

(script static boolean obj_fgrunt_4_34
(>= g_facility_obj_control 8))

(script static boolean obj_fintro_4_38
(< g_facility_obj_control 3))

(script static boolean obj_fgrunt_4_43
(and (>= g_facility_obj_control 12) (not (volume_test_players tv_facility_zealot_01))))

(script static boolean obj_fzealo_4_47
(volume_test_players tv_facility_zealot_01))

(script static boolean obj_fzealo_4_48
(volume_test_players tv_facility_zealot_02))

(script static boolean obj_fjacka_4_49
(volume_test_players tv_facility_final_rush))

(script static boolean obj_fzealo_4_50
(volume_test_players tv_facility_final_rush))

(script static boolean obj_fzealo_4_52
(volume_test_players tv_facility_zealot_03))

(script static boolean obj_fbridg_5_4
(>= g_facility_obj_control 2))

(script static boolean obj_fkat_i_5_6
(>= g_facility_obj_control 3))

(script static boolean obj_ffiret_5_7
(>= g_facility_obj_control 3))

(script static boolean obj_ftasks_5_8
(>= g_facility_obj_control 4))

(script static boolean obj_fkat_i_5_9
(>= g_facility_obj_control 14))

(script static boolean obj_fkat_i_5_10
(>= g_facility_obj_control 6))

(script static boolean obj_fkat_i_5_11
(>= g_facility_obj_control 12))

(script static boolean obj_fkat_i_5_12
(>= g_facility_obj_control 8))

(script static boolean obj_fkat_i_5_13
(>= g_facility_obj_control 16))

(script static boolean obj_fvehic_5_14
(b_facility_hog_control))

(script static boolean obj_fkat_i_5_15
(>= g_facility_obj_control 4))

(script static boolean obj_fvehic_5_16
(< g_facility_obj_control 2))

(script static boolean obj_finiti_5_17
(= (current_zone_set_fully_active) 4))

(script static boolean obj_finiti_5_18
(<= (ai_task_count obj_facility_cov/gt_cov_intro) 0))

(script static boolean obj_cjacka_6_5
(< g_cannon_obj_control 2))

(script static boolean obj_cghost_6_8
(and (< g_facility_obj_control 16) (> (ai_task_count obj_cannon_cov/gt_ghost_01) 1)))

(script static boolean obj_cghost_6_11
(and (< g_facility_obj_control 16) (> (ai_task_count obj_cannon_cov/gt_ghost_01) 1)))

(script static boolean obj_cskirm_6_16
(volume_test_players tv_cannon_main))

(script static boolean obj_cskirm_6_17
(and (> (ai_task_count obj_cannon_cov/gt_wraith) 2) (not (volume_test_players tv_cannon_05))))

(script static boolean obj_cphant_6_23
(or (> (ai_task_count obj_cannon_cov/gt_wraith) 2) (not (volume_test_players tv_cannon_05))))

(script static boolean obj_ccov_0_6_25
(and (> (ai_task_count obj_cannon_cov/gt_wraith) 2) (not (volume_test_players tv_cannon_05))))

(script static boolean obj_chunte_6_34
(volume_test_players tv_cannon_05))

(script static boolean obj_ctasks_6_35
(and (> (ai_task_count obj_cannon_cov/gt_wraith) 2) (not (volume_test_players tv_cannon_05))))

(script static boolean obj_cgt_fi_6_39
g_bfg02_core_destroyed)

(script static boolean obj_cwrait_6_42
(volume_test_players_all tv_cannon_backtrack))

(script static boolean obj_cwrait_6_43
(volume_test_players_all tv_cannon_backtrack))

(script static boolean obj_cwarth_7_5
g_bfg02_destroyed)

(script static boolean obj_callie_7_6
(<= (ai_task_count obj_cannon_cov/final_retreat_cov) 5))

(script static boolean obj_callie_7_7
(<= (ai_task_count obj_cannon_cov/final_retreat_cov) 0))

(script static boolean obj_ctasks_7_13
(>= g_cannon_obj_control 3))

(script static boolean obj_cupper_7_14
(>= (ai_task_count obj_cannon_cov/gt_canyon_connection) 1))

(script static boolean obj_cdropd_7_15
(< g_cannon_obj_control 3))

(script static boolean obj_cvehic_7_16
(volume_test_players tv_cannon_main))

(script static boolean obj_cdropd_7_17
(not (= (current_zone_set_fully_active) 5)))

(script static boolean obj_fwrait_8_0
(< g_falcon_obj_control 40))

(script static boolean obj_fwrait_8_15
(< g_falcon_obj_control 40))

(script static boolean obj_fspire_8_17
(>= g_falcon_obj_control 40))

(script static boolean obj_fex_02_8_21
(>= (ai_living_count sq_falcon_ex_02_left_shade_01) 1))

(script static boolean obj_scov_r_10_9
(>= g_spire_obj_control 5))

(script static boolean obj_sgrunt_10_11
(volume_test_players tv_spire_control))

(script static boolean obj_sgrunt_10_13
(volume_test_players tv_spire_upper))

(script static boolean obj_sjacka_10_16
(<= g_spire_obj_control 0))

(script static boolean obj_scov_0_10_20
(volume_test_players tv_spire_base_left))

(script static boolean obj_sskirm_10_23
(<= g_spire_obj_control 1))

(script static boolean obj_sgrunt_10_29
(<= g_spire_obj_control 1))

(script static boolean obj_sgrunt_10_33
(<= g_spire_obj_control 1))

(script static boolean obj_stasks_10_34
(<= g_spire_obj_control 0))

(script static boolean obj_scov_0_10_35
(volume_test_players tv_spire_base_right))

(script static boolean obj_stasks_10_38
(volume_test_players tv_spire_03))

(script static boolean obj_sgrunt_10_39
(<= (ai_living_count gr_spire_top_cov) 3))

