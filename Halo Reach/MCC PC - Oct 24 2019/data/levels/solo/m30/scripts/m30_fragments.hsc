(script static boolean obj_usteal_1_1
(= b_stealth_training_complete true))

(script static boolean obj_uinser_1_2
(f_ai_is_defeated gr_cov_ovr))

(script static boolean obj_ufollo_1_3
(or (f_ai_is_defeated gr_cov_ovr_high) (>= s_objcon_ovr 50)))

(script static boolean obj_cgate__2_3
(ai_is_alert gr_cov_fkv))

(script static boolean obj_cgate__2_4
(< s_objcon_fkv 50))

(script static boolean obj_cphant_2_6
(and (= b_fkv_ds0_delivery_started false) (not (fkv_ds0_turret_is_alive)) (>= s_objcon_fkv 5)))

(script static boolean obj_chighv_2_13
(>= (ai_strength gr_cov_fkv) 0.45))

(script static boolean obj_cgate__2_19
(not (volume_test_players tv_fkv_approach_00)))

(script static boolean obj_cgate__2_20
(>= (ai_strength gr_cov_fkv_reinforce) 0.3))

(script static boolean obj_cgate__2_23
(not (volume_test_players tv_fkv_approach_01)))

(script static boolean obj_cgarag_2_24
(<= (ai_task_count obj_cov_fkv/gate_reinforce_courtyard_forward) 0))

(script static boolean obj_cgate__2_25
(not (volume_test_players tv_fkv_approach_01)))

(script static boolean obj_ccourt_2_27
(<= (ai_task_count obj_cov_fkv/gate_reinforce_garage_forward) 0))

(script static boolean obj_czeta__2_33
(= b_zeta_escape true))

(script static boolean obj_usnipi_3_2
(< (ai_task_count obj_cov_fkv/gate_main) 8))

(script static boolean obj_uhold__3_3
(and (>= s_objcon_fkv 5) (<= (ai_living_count gr_cov_fkv_hill) 0)))

(script static boolean obj_ufollo_3_4
(and (>= (ai_combat_status gr_cov_fkv) 5) (volume_test_players tv_fkv_approach_00)))

(script static boolean obj_mmules_4_5
(<= (ai_task_count obj_mule_cov/gate_covenant) 0))

(script static boolean obj_mminio_4_6
(<= (ai_task_count obj_mule_cov/gate_covenant) 4))

(script static boolean obj_mminio_4_10
(<= (ai_living_count sq_mule_fld) 0))

(script static boolean obj_mminio_4_11
(<= (ai_living_count sq_mule_fld/low) 0))

(script static boolean obj_call_f_5_5
 (<= (ai_task_count obj_unsc_pmp/gate_defense_low) 0))

(script static boolean obj_cgate__5_7
(= b_pmp_alpha_enroute false))

(script static boolean obj_cgate__5_11
(= b_pmp_bravo_enroute false))

(script static boolean obj_cgate__5_12
(= b_pmp_assault_started true))

(script static boolean obj_cpmp_p_5_13
b_pmp_player_skips_encounter)

(script static boolean obj_ciniti_5_18
(>= (ai_strength gr_cov_pmp) 0.5))

(script static boolean obj_cfinal_5_19
(and (= b_pmp_charlie_delivered true) (<= (ai_task_count obj_cov_pmp/gate_main) 2)))

(script static boolean obj_ciniti_5_22
(>= (ai_strength gr_cov_pmp) 0.5))

(script static boolean obj_ccreek_5_34
(<= (ai_living_count gr_cov_pmp) 3))

(script static boolean obj_czeta__5_40
(= b_zeta_escape 1))

(script static boolean obj_udefen_6_2
(= b_pmp_assault_complete true))

(script static boolean obj_ujun_e_6_4
(>= s_objcon_pmp 10))

(script static boolean obj_ugo_to_6_5
(= b_pmp_go_to_gate true))

(script static boolean obj_ugo_to_6_6
(or (= b_pmp_post_convo_completed true) (= b_pmp_post_convo_goto_river true)))

(script static boolean obj_ujun_a_6_9
(= b_pmp_assault_started true))

(script static boolean obj_ugate__6_10
(= b_pmp_assault_started true))

(script static boolean obj_umilit_6_14
(<= (ai_task_count obj_cov_pmp/gate_initial) 0))

(script static boolean obj_ujun_f_6_15
(>= s_objcon_pmp 20))

(script static boolean obj_ugo_do_6_16
(and (= b_pmp_post_convo_completed true) (volume_test_players tv_pmp_exit)))

(script static boolean obj_ugate__6_17
(and (<= (ai_strength gr_cov_pmp) 0.2) (>= s_objcon_pmp 30)))

(script static boolean obj_ujun_a_6_19
(= b_pmp_bravo_enroute true))

(script static boolean obj_ujun_a_6_20
(= b_pmp_alpha_enroute true))

(script static boolean obj_umilit_6_22
(= b_pmp_bravo_enroute true))

(script static boolean obj_umilit_6_23
(= b_pmp_alpha_enroute true))

(script static boolean obj_udefen_6_25
(= b_pmp_bravo_enroute true))

(script static boolean obj_udefen_6_26
(= b_pmp_alpha_enroute true))

(script static boolean obj_uobjco_8_2
(>= s_objcon_rvr 10))

(script static boolean obj_uobjco_8_9
(>= s_objcon_rvr 20))

(script static boolean obj_uobjco_8_10
(>= s_objcon_rvr 30))

(script static boolean obj_uobjco_8_11
(>= s_objcon_rvr 40))

(script static boolean obj_uobjco_8_12
(>= s_objcon_rvr 50))

(script static boolean obj_uobjco_8_13
(>= s_objcon_rvr 60))

(script static boolean obj_umilit_8_16
(>= s_objcon_rvr 10))

(script static boolean obj_umilit_8_17
(>= s_objcon_rvr 20))

(script static boolean obj_umilit_8_18
(>= s_objcon_rvr 60))

(script static boolean obj_umilit_8_19
(>= s_objcon_rvr 50))

(script static boolean obj_umilit_8_20
(>= s_objcon_rvr 40))

(script static boolean obj_umilit_8_21
(>= s_objcon_rvr 30))

(script static boolean obj_cbridg_9_9
(<= (ai_task_count obj_cov_set/gate_bridge) 3))

(script static boolean obj_ciniti_9_12
(= b_set_defense_start true))

(script static boolean obj_cfront_9_17
(= b_set_player_front true))

(script static boolean obj_czeta__9_19
(= b_zeta_escape true))

(script static boolean obj_ccs_fo_10_3
(>= s_objcon_clf 120))

(script static boolean obj_ccs_ro_10_8
(< s_objcon_clf 110))

(script static boolean obj_croad__10_12
(<= (ai_strength gr_cov_clf_road) 0.4))

(script static boolean obj_ccs_ch_10_13
(>= s_objcon_clf 110))

(script static boolean obj_cnest__10_16
(and (>= s_objcon_clf 110) (<= (ai_living_count sq_cov_clf_jetpacks0) 0)))

(script static boolean obj_cnest__10_18
(> (ai_task_count obj_cov_clf/gate_nest_elites) 0))

(script static boolean obj_cnest__10_21
(>= s_objcon_clf 120))

(script static boolean obj_coverl_10_25
(> (ai_strength gr_cov_clf_final) 0.2))

(script static boolean obj_coverl_10_27
(not (f_ai_is_defeated sq_cov_clf_overlook_inf1)))

(script static boolean obj_cfinal_10_28
(<= (ai_living_count gr_cov_clf_final) 1))

(script static boolean obj_ustart_11_1
(>= (device_get_position gate) .6))

(script static boolean obj_uroad__11_2
(and (<= (ai_strength gr_cov_clf_road) 0.4) (= b_cliffside_road_dropoff true)))

(script static boolean obj_unest_11_3
(and (f_ai_is_defeated sq_cov_clf_skirmishers) (f_ai_is_partially_defeated gr_cov_clf_mid 2) (f_ai_is_defeated sq_cov_clf_nest_shade0)))

(script static boolean obj_ufinal_11_4
(and (f_ai_is_partially_defeated gr_cov_clf_final 2) (>= s_objcon_clf 130)))

(script static boolean obj_umissi_11_5
(and (f_ai_is_defeated sq_cov_clf_overlook_inf0) (f_ai_is_defeated sq_cov_clf_overlook_inf1)))

(script static boolean obj_umiddl_11_6
(f_ai_is_defeated gr_cov_clf_center))

(script static boolean obj_uroad__11_11
(= b_cliffside_road_dropoff true))

(script static boolean obj_ucente_11_12
(and (f_ai_is_defeated sq_cov_clf_center_shade0) (f_ai_is_defeated sq_cov_clf_center_inf0)))

(script static boolean obj_uroad__11_13
(and (f_ai_is_defeated gr_cov_clf_road) (> s_objcon_clf 60)))

(script static boolean obj_uassau_11_14
(and (>= s_objcon_clf 110) (<= (ai_strength gr_cov_clf_nest) 0.3)))

(script static boolean obj_uadvan_11_15
(and (f_ai_is_defeated sq_cov_clf_overlook_inf1) (>= s_objcon_clf 130)))

(script static boolean obj_ufollo_11_16
(>= s_objcon_clf 80))

(script static boolean obj_ujun_f_12_0
(>= s_objcon_fld 30))

(script static boolean obj_ugate__12_2
(and (<= (ai_living_count gr_cov_fld) 0)  (f_ai_is_defeated sq_mule_fld)))

(script static boolean obj_ujun_e_12_3
(volume_test_players tv_fld_exit))

(script static boolean obj_ugate__13_3
(> (ai_combat_status gr_cov_set) 4))

(script static boolean obj_udefen_13_6
(= b_set_defense_start true))

(script static boolean obj_ufollo_13_8
(>= s_objcon_set 10))

(script static boolean obj_uassau_13_9
(>= s_objcon_set 30))

(script static boolean obj_ubridg_13_10
(>= s_objcon_set 20))

(script static boolean obj_umove__13_11
(>= s_objcon_set 12))

(script static boolean obj_ugate_13_12
(= b_set_completed true))

(script static boolean obj_uadvan_13_13
(= b_set_unsc_advance true))

(script static boolean obj_ucross_13_14
(and (>= s_objcon_set 30) (f_ai_is_defeated sq_cov_set_bridge0)))

(script static boolean obj_uassau_13_15
(and (f_ai_is_defeated sq_cov_set_bridge0) (f_ai_is_defeated sq_cov_set_ring_grunts0)))

(script static boolean obj_uassau_13_16
(and (f_ai_is_defeated sq_cov_set_bridge0) (f_ai_is_defeated sq_cov_set_ring_grunts0) (<= (ai_strength sq_cov_set_ring_jackals0) 0.5)))

(script static boolean obj_uassau_13_17
(>= s_objcon_set 40))

(script static boolean obj_ujun_l_15_1
(= b_slo_jun_leave true))

(script static boolean obj_ufollo_15_3
(and (<= (ai_strength gr_cov_slo) .2) (>= s_objcon_slo 30)))

(script static boolean obj_fgate__16_10
(ai_is_alert gr_cov_fkv))

(script static boolean obj_fgate__16_11
(ai_is_alert gr_cov_fkv))

(script static boolean obj_fgate__16_12
(ai_is_alert gr_cov_fkv))

(script static boolean obj_mmoas__19_1
(or (< (ai_strength sq_amb_pmp_moas0) 1) (volume_test_players tv_pmp_moas_scare) (volume_test_object tv_pmp_moas_scare (ai_get_object ai_jun))))

(script static boolean obj_celite_20_13
(>= s_objcon_slo 30))

