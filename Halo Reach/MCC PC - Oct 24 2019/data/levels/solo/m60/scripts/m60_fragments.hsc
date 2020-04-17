(script static boolean obj_ikiva_0_3
(and (>= (ai_living_count sq_intro02) 1) (<= intro_obj_control 20)))

(script static boolean obj_itower_0_4
 (< intro_obj_control 30))

(script static boolean obj_iflak__0_9
(and (>= (ai_living_count sq_intro02) 1) (<= intro_obj_control 20)))

(script static boolean obj_icomba_0_10
(< (ai_combat_status gr_intro) 4))

(script static boolean obj_iiniti_0_11
(not (volume_test_players tv_intro_water)))

(script static boolean obj_iend_i_0_14
(or (>= intro_obj_control 30) (<= (ai_living_count gr_intro) 2)))

(script static boolean obj_isnipe_0_19
 (< intro_obj_control 30))

(script static boolean obj_ialert_0_20
(> (ai_combat_status gr_intro) 4))

(script static boolean obj_igrunt_0_22
(> (ai_combat_status gr_intro) 4))

(script static boolean obj_istart_0_23
(volume_test_players tv_intial_odst))

(script static boolean obj_imove__0_24
(and (= intro_obj_control 20) (<= (ai_living_count gr_intro) 5)))

(script static boolean obj_mreven_1_1
(<=  motorpool_obj_control 30))

(script static boolean obj_mghost_1_2
(<=  motorpool_obj_control 20))

(script static boolean obj_mghost_1_7
(<=  motorpool_obj_control 30))

(script static boolean obj_mghost_1_8
(<=  motorpool_obj_control 40))

(script static boolean obj_mghost_1_9
(<=  motorpool_obj_control 50))

(script static boolean obj_mgrunt_1_14
(>= motorpool_obj_control 30))

(script static boolean obj_mrest__1_15
(>= motorpool_obj_control 40))

(script static boolean obj_msfoll_1_16
(>= motorpool_obj_control 20))

(script static boolean obj_mtroop_1_17
(>= motorpool_obj_control 60))

(script static boolean obj_djacka_2_0
(< supply_obj_control 60))

(script static boolean obj_dend_2_1
(and (= g_bfg01_core_destroyed true) (= g_bfg02_core_destroyed true)))

(script static boolean obj_dgun01_2_7
(= g_bfg01_core_destroyed false))

(script static boolean obj_dgun02_2_9
(= g_bfg02_core_destroyed false))

(script static boolean obj_dg_fal_2_11
(and (= g_bfg01_core_destroyed true) (= g_bfg02_core_destroyed true)))

(script static boolean obj_dfalco_2_12
(and (= g_bfg01_core_destroyed true) (= g_bfg02_core_destroyed true)))

(script static boolean obj_dmid_2_14
(< supply_obj_control 70))

(script static boolean obj_dbail__2_18
(or (volume_test_players tv_player_in_bfg01) (volume_test_players tv_player_in_bfg02)))

(script static boolean obj_dfront_2_19
(< supply_obj_control 60))

(script static boolean obj_dtop_a_2_20
(or (< (ai_living_count sq_depot02) 1) (< (ai_living_count sq_depot07) 1) ))

(script static boolean obj_gghost_3_0
(< supply_obj_control 90))

(script static boolean obj_gguard_4_13
(>= gate_obj_control 40))

(script static boolean obj_greven_4_16
(b_fake_battle_gate))

(script static boolean obj_greven_4_17
(b_fake_battle_gate))

(script static boolean obj_greven_4_18
(b_fake_battle_gate))

(script static boolean obj_gshade_4_20
(b_fake_battle_gate))

(script static boolean obj_bjacka_5_0
(> (ai_strength gr_base_assault) 0.40))

(script static boolean obj_biniti_5_7
(> (ai_strength gr_base_assault) 0.75))

(script static boolean obj_b01_ga_5_8
(and (< (ai_strength gr_base_assault) 0.75) (> (ai_strength gr_base_assault) 0.40)))

(script static boolean obj_b01_sp_5_11
(= (ai_task_count obj_base_assault/jackal_initial) 0))

(script static boolean obj_b02_ga_5_13
(< (ai_strength gr_base_assault) 0.40))

(script static boolean obj_b02_sp_5_14
(>= (ai_living_count gr_base_assault) 2))

(script static boolean obj_bend_s_5_16
(or (= assault_obj_control 30) (< (ai_living_count gr_base_assault) 2)))

(script static boolean obj_bsword_5_18
(volume_test_players tv_elevator_bottom))

(script static boolean obj_ispart_6_2
(and (> (ai_task_count obj_interior/bottom_gate) 1) (>= interior_obj_control 10)))

(script static boolean obj_ispart_6_13
(and (> (ai_task_count obj_interior/middle_gate) 1) (>= interior_obj_control 20)))

(script static boolean obj_ispart_6_14
(and (> (ai_task_count obj_interior/top_gate) 1) (>= interior_obj_control 40)))

(script static boolean obj_ispart_6_20
(< interior_obj_control 10))

(script static boolean obj_iend_6_21
(>= interior_obj_control 50))

(script static boolean obj_ispart_6_22
(volume_test_players tv_interior_obj_control_20))

(script static boolean obj_ispart_6_23
(volume_test_players tv_interior_obj_control_40))

(script static boolean obj_ihand__6_24
(>= interior_obj_control 70))

(script static boolean obj_sobj_c_7_2
(<= security_obj_control 10))

(script static boolean obj_sobj_c_7_3
(= security_obj_control 15))

(script static boolean obj_sobj_c_7_4
(>= security_obj_control 20))

(script static boolean obj_sobj_c_7_5
(and (>= security_obj_control 30) (>= (device_get_position dm_oni_interior) 1)))

(script static boolean obj_splaye_7_11
(> (ai_combat_status sq_security01) 7))

(script static boolean obj_sfall__7_12
(or (>= security_obj_control 50) (< (ai_living_count gr_spec_ops) 3)))

(script static boolean obj_sback__7_14
(>= security_obj_control 60))

(script static boolean obj_sattac_7_15
(or (>= security_obj_control 50) (< (ai_living_count gr_spec_ops) 1)))

(script static boolean obj_salead_7_16
(and (< (ai_living_count sq_security03) 1) (>= security_obj_control 60)))

(script static boolean obj_scharg_7_18
(or (>= security_obj_control 50) (< (ai_living_count gr_spec_ops) 1)))

(script static boolean obj_sfollo_7_19
(and (< (ai_living_count sq_security03) 1) (>= security_obj_control 50)))

(script static boolean obj_iwave0_9_10
(= g_ice_wave 4))

(script static boolean obj_iengin_9_11
(< (ai_living_count sq_ice_big_boss_3_elite) 1))

(script static boolean obj_isecon_9_13
(< g_ice_wave 2))

(script static boolean obj_isword_9_22
(< (ai_living_count sq_ice_big_boss_3_elite) 1))

(script static boolean obj_isecon_9_23
(>= g_ice_wave 2))

(script static boolean obj_tstay_10_0
(not (volume_test_players tv_ice_cave_start)))

(script static boolean obj_tspart_10_4
 (volume_test_players tv_ice_cave_start))

(script static boolean obj_iflee0_11_1
(>= g_ice_wave 4))

(script static boolean obj_iflee0_11_2
(>= g_ice_wave 4))

