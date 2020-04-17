(script static boolean obj_asecto_0_0
 (= b_start_hub true))

(script static boolean obj_asecto_0_1
 (= b_start_hub true))

(script static boolean obj_asecto_0_4
(< (ai_task_count obj_air/sector_c) 4))

(script static boolean obj_afollo_0_5
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon01)))

(script static boolean obj_asecto_0_7
(and (= b_start_hub true) (< (ai_task_count obj_air/sector_a) 4)))

(script static boolean obj_asecto_0_8
(and (= b_start_hub true) (< (ai_task_count obj_air/sector_b) 4)))

(script static boolean obj_asecto_0_9
(< (ai_task_count obj_air/sector_d) 4))

(script static boolean obj_asecto_0_10
(< (ai_task_count obj_air/sector_e) 4))

(script static boolean obj_amissi_0_14
(= mission_obj_gamma_1 true))

(script static boolean obj_amissi_0_15
(= mission_obj_gamma_2 true))

(script static boolean obj_amissi_0_16
(= mission_obj_gamma_3 true))

(script static boolean obj_abansh_0_17
(f_player0_in_banshee))

(script static boolean obj_afollo_0_18
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon02)))

(script static boolean obj_afollo_0_19
(= b_start_hub true))

(script static boolean obj_abansh_0_20
(f_player1_in_banshee))

(script static boolean obj_abansh_0_21
(f_player2_in_banshee))

(script static boolean obj_abansh_0_22
(f_player3_in_banshee))

(script static boolean obj_afollo_0_23
(> (ai_living_count sq_sec_gamma_p01) 1))

(script static boolean obj_afollo_0_24
(> (ai_living_count sq_sec_gamma_p02) 1))

(script static boolean obj_afollo_0_25
(> (ai_living_count sq_sec_gamma_m03a) 1))

(script static boolean obj_amissi_0_26
(= g_delta_enc 3))

(script static boolean obj_amissi_0_27
(= g_delta_enc 2))

(script static boolean obj_amissi_0_28
(= g_delta_enc 1))

(script static boolean obj_afollo_0_29
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon01)))

(script static boolean obj_afollo_0_30
(= s_random_banshee_num0 3))

(script static boolean obj_afollo_0_31
(= s_random_banshee_num0 2))

(script static boolean obj_afollo_0_32
(= s_random_banshee_num0 1))

(script static boolean obj_afollo_0_33
(= s_random_banshee_num1 1))

(script static boolean obj_afollo_0_34
(= s_random_banshee_num1 3))

(script static boolean obj_afollo_0_35
(= s_random_banshee_num1 2))

(script static boolean obj_afollo_0_36
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon02)))

(script static boolean obj_afollo_0_37
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon01_reinf)))

(script static boolean obj_afollo_0_38
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon02_reinf)))

(script static boolean obj_afollo_0_39
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon01_reinf)))

(script static boolean obj_afollo_0_40
(= s_random_banshee_num2 1))

(script static boolean obj_afollo_0_41
(= s_random_banshee_num2 3))

(script static boolean obj_afollo_0_42
(= s_random_banshee_num2 2))

(script static boolean obj_afollo_0_43
(and (>= m_progression 0) (f_players_driving_falcon sq_v_falcon02_reinf)))

(script static boolean obj_afollo_0_44
(= s_random_banshee_num3 1))

(script static boolean obj_afollo_0_45
(= s_random_banshee_num3 3))

(script static boolean obj_afollo_0_46
(= s_random_banshee_num3 2))

(script static boolean obj_abldg__0_48
(and (f_any_hub_check) (= g_mission_unlock 1) ))

(script static boolean obj_abldg__0_49
(and (f_any_hub_check) (= g_mission_unlock 2) ))

(script static boolean obj_abldg__0_50
(and (f_any_hub_check) (= g_mission_unlock 3) ))

(script static boolean obj_asecto_0_51
(< (ai_task_count obj_air/sector_f) 4))

(script static boolean obj_bbridg_1_1
(not (f_objective_complete dm_building_a_objective dc_objective_a_switch)))

(script static boolean obj_bfirst_1_2
(< obj_control_bldg_a 40))

(script static boolean obj_bsecon_1_3
(< obj_control_bldg_a 50))

(script static boolean obj_bbridg_1_5
(< obj_control_bldg_a 20))

(script static boolean obj_bgrunt_1_9
(<= obj_control_bldg_a 10))

(script static boolean obj_bbridg_1_13
(f_objective_complete dm_building_a_objective dc_objective_a_switch))

(script static boolean obj_blobby_1_14
(>= obj_control_bldg_a 80))

(script static boolean obj_bfirst_1_15
(< obj_control_bldg_a 45))

(script static boolean obj_bsecon_1_16
(< obj_control_bldg_a 55))

(script static boolean obj_bretur_1_17
(< obj_control_bldg_a 75))

(script static boolean obj_bjetpa_1_20
(< obj_control_bldg_a 80))

(script static boolean obj_bmarin_1_25
(and (ai_living_count sq_bldg_a_02_return) (>= obj_control_bldg_a 80)))

(script static boolean obj_bunder_1_26
(volume_test_players tv_bldg_a_under_bridge))

(script static boolean obj_blobby_1_27
(b_engineer_hide))

(script static boolean obj_btop_e_1_29
(b_engineer_escape))

(script static boolean obj_blobby_1_31
(< obj_control_bldg_a 30))

(script static boolean obj_bfollo_2_2
(or (g_3coop_mode) (= (game_difficulty_get) legendary)))

(script static boolean obj_blead__2_3
(= (ai_living_count gr_bldg_b) 0))

(script static boolean obj_bfollo_2_11
(<= (ai_living_count gr_bldg_b) 1))

(script static boolean obj_bplaye_4_0
(= (object_get_bsp player0) 4))

(script static boolean obj_bplaye_4_7
(= (object_get_bsp player1) 4))

(script static boolean obj_bplaye_4_8
(= (object_get_bsp player2) 4))

(script static boolean obj_bplaye_4_9
(= (object_get_bsp player3) 4))

(script static boolean obj_bbrute_5_7
(or (= (ai_living_count sq_bldg_c_01) 0) (>= obj_control_bldg_c 50)))

(script static boolean obj_aalpha_6_2
(= g_alpha_enc 1))

(script static boolean obj_aalpha_6_3
(= g_alpha_enc 2))

(script static boolean obj_aalpha_6_7
(= g_alpha_enc 3))

(script static boolean obj_am01_p_6_10
(= g_alpha_1_marine_safe TRUE))

(script static boolean obj_am02_p_6_13
(= g_alpha_2_marine_safe TRUE))

(script static boolean obj_am03_p_6_14
(= g_alpha_3_marine_safe TRUE))

(script static boolean obj_bbeta__7_4
(= g_beta_enc 1))

(script static boolean obj_bbeta__7_5
(= g_beta_enc 3))

(script static boolean obj_bbeta__7_9
(= g_beta_enc 2))

(script static boolean obj_bm02_p_7_11
(= g_beta_2_marine_safe true))

(script static boolean obj_bm03_p_7_12
(= g_beta_3_marine_safe true))

(script static boolean obj_bm01_p_7_13
(= g_beta_1_marine_safe true))

(script static boolean obj_gm02_g_8_1
(= g_gamma_enc 2))

(script static boolean obj_gm03_g_8_2
(= g_gamma_enc 3))

(script static boolean obj_gbansh_8_4
(> (ai_living_count sq_sec_gamma_cd03a) 0))

(script static boolean obj_gm01_g_8_5
(= g_gamma_enc 1))

(script static boolean obj_gm01_i_8_7
(= g_gamma_1_marine_safe TRUE))

(script static boolean obj_gm02_i_8_8
(= g_gamma_2_marine_safe TRUE))

(script static boolean obj_gm03_i_8_11
(= g_gamma_3_marine_safe TRUE))

(script static boolean obj_otasks_9_6
(b_oni_end))

(script static boolean obj_ofollo_9_8
(= (player_is_in_game player0) true))

(script static boolean obj_ofollo_9_10
(= (player_is_in_game player1) true))

(script static boolean obj_ofollo_9_11
(= (player_is_in_game player2) true))

(script static boolean obj_ofollo_9_12
(= (player_is_in_game player3) true))

(script static boolean obj_ddelta_11_3
(= g_delta_enc 1))

(script static boolean obj_ddelta_11_4
(= g_delta_enc 2))

(script static boolean obj_dtasks_11_5
(= g_delta_enc 3))

