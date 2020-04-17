(script static boolean obj_ishoot_0_2
(>= objcon_interior 50))

(script static boolean obj_ishoot_0_3
(>= objcon_interior 50))

(script static boolean obj_ishoot_0_4
(>= objcon_interior 20))

(script static boolean obj_ishoot_0_5
(>= objcon_interior 30))

(script static boolean obj_ccount_1_1
(= b_cv_counter_started true))

(script static boolean obj_cgrunt_1_12
(or (>= objcon_canyonview 30) (<= (ai_task_count obj_canyonview_cov/initial_brute_front) 0)))

(script static boolean obj_cmiddl_1_13
(>= objcon_canyonview 10))

(script static boolean obj_ciniti_1_14
(>= objcon_canyonview 30))

(script static boolean obj_cguard_2_2
(>= objcon_canyonview 10))

(script static boolean obj_clower_2_3
(and (>= objcon_canyonview 20) (<= (ai_task_count obj_canyonview_cov/initial_brute_front) 0)))

(script static boolean obj_ccount_2_4
(= b_cv_counter_started true))

(script static boolean obj_ccount_2_5
(= b_cv_complete true))

(script static boolean obj_cescap_2_7
(>= objcon_canyonview 10))

(script static boolean obj_ccover_2_12
(= b_cv_counter_started true))

(script static boolean obj_cescap_2_13
(>= objcon_canyonview 30))

(script static boolean obj_cpost__2_14
(= b_cv_complete true))

(script static boolean obj_cescap_2_15
(and (>= objcon_canyonview 40) (<= (ai_task_count obj_canyonview_cov/gate_main) 3)))

(script static boolean obj_clow_a_2_18
(and (>= objcon_canyonview 30) (<= (ai_task_count obj_canyonview_cov/initial_brute_middle) 0)))

(script static boolean obj_acount_3_2
(or (<= (ai_task_count obj_atrium_cov/gate_counterattack) 3) (f_ai_is_defeated gr_cov_atrium_hunters)))

(script static boolean obj_ainiti_3_17
(or (>= (ai_strength gr_cov_atrium_initial) 0.75) (!= (f_ai_is_defeated atrium_cov_initial_inf5) true)))

(script static boolean obj_abrute_3_18
(or (>= objcon_atrium 40) (<= (ai_strength atrium_cov_initial_inf5) 0.50)))

(script static boolean obj_aflank_3_19
(and (<= (ai_strength gr_cov_atrium_initial) 0.25) (>= objcon_atrium 40)))

(script static boolean obj_aflank_3_20
(volume_test_players tv_atrium_flank_right))

(script static boolean obj_aarch_3_22
(volume_test_players tv_atrium_arch))

(script static boolean obj_agate__3_24
(volume_test_players tv_atrium_terrace))

(script static boolean obj_ainiti_3_28
(or b_atrium_counterattack_started (>= objcon_atrium 60)))

(script static boolean obj_astack_4_2
(>= objcon_atrium 5))

(script static boolean obj_aadvan_4_3
(or (<= (ai_task_count obj_atrium_cov/initial_grunts) 0) (>= objcon_atrium 10)))

(script static boolean obj_aadvan_4_4
(>= objcon_atrium 20))

(script static boolean obj_aadvan_4_5
(and (>= objcon_atrium 30) (<= (ai_strength atrium_cov_initial_inf0) .025)))

(script static boolean obj_aadvan_4_6
(or (>= objcon_atrium 40) (<= (ai_strength gr_cov_atrium_initial) .025)))

(script static boolean obj_acount_4_7
(= b_atrium_counterattack_started true))

(script static boolean obj_acompl_4_8
(= b_atrium_complete true))

(script static boolean obj_aentra_4_13
(>= objcon_atrium 10))

(script static boolean obj_aentra_4_14
(and (>= objcon_atrium 30) (<= (ai_task_count obj_atrium_cov/initial_grunts) 1)(<= (ai_task_count obj_atrium_cov/initial_brutes) 0)))

(script static boolean obj_aterra_4_16
(>= objcon_atrium 40))

(script static boolean obj_aeleva_4_18
(= b_atrium_complete true))

(script static boolean obj_adefen_4_19
(= b_atrium_counterattack_started true))

(script static boolean obj_aconfe_4_21
(>= objcon_atrium 30))

(script static boolean obj_aterra_4_24
(volume_test_players tv_atrium_terrace))

(script static boolean obj_jcrane_6_1
(or (>= objcon_jetpack_low 90) (<= (ai_task_count obj_jetpack_low_cov/gate_ramp) 3)))

(script static boolean obj_jhigh__6_7
(>= objcon_jetpack_low 130))

(script static boolean obj_jramp__6_8
(or (>= objcon_jetpack_low 90) (<= (ai_task_count obj_jetpack_low_cov/gate_ramp) 7)))

(script static boolean obj_jiniti_6_10
(>= objcon_jetpack_low 120))

(script static boolean obj_jcrane_6_22
(or (>= objcon_jetpack_low 100) (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 5)))

(script static boolean obj_jcrane_6_23
(or (>= objcon_jetpack_low 110) (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 3)))

(script static boolean obj_jhallw_6_24
(volume_test_players tv_jetpack_low_hallway))

(script static boolean obj_jgate__7_1
 (>= objcon_jetpack_low 50))

(script static boolean obj_jmars__7_6
(>= objcon_jetpack_low 80))

(script static boolean obj_jodst__7_7
(<= (ai_task_count obj_jetpack_low_cov/ramp_low) 0))

(script static boolean obj_jodst__7_8
(or (<= (ai_task_count obj_jetpack_low_cov/gate_ramp) 2) (>= objcon_jetpack_low 90)))

(script static boolean obj_jmars__7_9
(<= (ai_task_count obj_jetpack_low_cov/gate_ramp) 2))

(script static boolean obj_jodst__7_10
(or (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 2) (>= objcon_jetpack_low 100)))

(script static boolean obj_jmars__7_11
(or (<= (ai_task_count obj_jetpack_low_cov/gate_ramp) 0) (>= objcon_jetpack_low 110)))

(script static boolean obj_jd_def_7_12
(<= (ai_task_count obj_jetpack_low_cov/gate_main) 1))

(script static boolean obj_jupper_7_13
(or (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 2) (>= objcon_jetpack_low 120)))

(script static boolean obj_jstand_7_14
(and (<= (ai_task_count obj_jetpack_low_cov/gate_main) 2) (>= objcon_jetpack_low 130)))

(script static boolean obj_jlobby_7_19
b_jetpack_high_started)

(script static boolean obj_jlobby_7_20
 (>= objcon_jetpack_low 160))

(script static boolean obj_jodst__7_22
(or (>= objcon_jetpack_low 120) (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 2)))

(script static boolean obj_jodst__7_24
(or (>= objcon_jetpack_low 120) (<= (ai_task_count obj_jetpack_low_cov/gate_crane) 2)))

(script static boolean obj_jlobby_7_26
b_jetpack_high_started)

(script static boolean obj_jtree__8_8
(>= objcon_jetpack_high 10))

(script static boolean obj_jhill__8_10
(or (<= (ai_strength jh_cov_hill_concussion_inf0) 0.5) (volume_test_players tv_jetpack_high_stairs_top)))

(script static boolean obj_jtree__8_13
(or (<= (ai_task_count obj_jetpack_high_cov/gate_tree) 4) (>= objcon_jetpack_high 20)))

(script static boolean obj_jhill__8_17
(>= objcon_jetpack_high 30))

(script static boolean obj_jhill__8_20
(>= objcon_jetpack_high 30))

(script static boolean obj_jhill__8_21
(>= objcon_jetpack_high 40))

(script static boolean obj_jtree__8_22
(>= objcon_jetpack_high 30))

(script static boolean obj_jhill__8_28
(<= (ai_strength jh_cov_hill_concussion_inf0) 0.25))

(script static boolean obj_jmarin_9_2
(and (<= (ai_strength gr_cov_jh_hill) 0.5) (>= objcon_jetpack_high 30)))

(script static boolean obj_jmarin_9_3
(and (<= (ai_task_count obj_jetpack_high_cov/tree_initial) 2) (>= objcon_jetpack_high 20)))

(script static boolean obj_jodst__9_5
(and (or (<= (ai_task_count obj_jetpack_high_cov/tree_initial) 3) (>= objcon_jetpack_high 20)(<= (ai_living_count jh_cov_tree_inf0) 0))(>= objcon_jetpack_high 10)))

(script static boolean obj_jmarin_9_7
(and (f_ai_is_partially_defeated jh_cov_hill_stairs_inf0 2) (f_ai_is_partially_defeated jh_cov_hill_stairs_inf1 2)))

(script static boolean obj_jodsts_9_8
(and (or (<= (ai_strength gr_cov_jh_hill) 0.45) (>= objcon_jetpack_high 30)) b_place_jh_hill))

(script static boolean obj_jodsts_9_9
(and (or (<= (ai_strength gr_cov_jh_hill) 0.10) (>= objcon_jetpack_high 40)) b_place_jh_hill))

(script static boolean obj_jmarin_9_10
(and (<= (ai_task_count obj_jetpack_high_cov/gate_hill) 2) (>= objcon_jetpack_high 40)))

(script static boolean obj_jodst__9_11
(volume_test_players tv_jetpack_high_stairs_top))

(script static boolean obj_jmarin_9_12
(and (volume_test_players tv_jetpack_high_stairs_top) (<= (ai_task_count obj_jetpack_high_cov/gate_hill) 1)))

(script static boolean obj_jodst__9_13
(and (or (<= (ai_task_count obj_jetpack_high_cov/gate_hill) 0) (= b_trophy_started true)) b_place_jh_hill))

(script static boolean obj_jmarin_9_14
(<= (ai_task_count obj_jetpack_high_cov/gate_main) 0))

(script static boolean obj_jodst__9_26
(and (<= (ai_task_count obj_jetpack_high_cov/hill_stairs_low) 0) b_place_jh_hill))

(script static boolean obj_rattac_10_2
(>= objcon_ready 20))

(script static boolean obj_rlast__10_6
(>= objcon_ready 90))

(script static boolean obj_rcross_10_9
(>= objcon_ready 30))

(script static boolean obj_rcs_re_10_10
(>= objcon_ready 80))

(script static boolean obj_rdoorm_10_12
(>= objcon_ready 50))

(script static boolean obj_rpad_o_10_14
(>= objcon_ready 50))

(script static boolean obj_radvan_10_16
(>= objcon_ready 80))

(script static boolean obj_radvan_10_17
(>= objcon_ready 70))

(script static boolean obj_radvan_10_18
(>= objcon_ready 40))

(script static boolean obj_tbugge_11_4
(>= objcon_trophy 20))

(script static boolean obj_tbalco_11_11
(>= objcon_trophy 10))

(script static boolean obj_tbalco_11_12
(>= objcon_trophy 40))

(script static boolean obj_tentra_11_13
(>= objcon_trophy 5))

(script static boolean obj_tgate__11_16
b_trophy_counterattack)

(script static boolean obj_tentra_11_17
(>= objcon_trophy 10))

(script static boolean obj_tentra_11_20
(<= (ai_task_count obj_trophy_cov/gate_entrance) 3))

(script static boolean obj_sm0_in_12_22
(volume_test_players tv_starport_bridge))

(script static boolean obj_sfallb_12_30
(and b_starport_turret0_ready b_starport_turret1_ready))

(script static boolean obj_sintro_12_31
(not b_starport_monologue))

(script static boolean obj_sm1_in_12_32
(f_ai_is_defeated starport_cov_mis1_inf0))

(script static boolean obj_sadvan_14_2
(and (<= (ai_living_count starport_cov_inf0) 0) (<= (ai_living_count starport_cov_inf1) 0) b_falcon_unloaded))

(script static boolean obj_sgate__14_3
b_falcon_unloaded)

(script static boolean obj_sgate__14_6
b_falcon_unloaded)

(script static boolean obj_sadvan_14_8
(and b_starport_turret0_ready b_starport_turret1_ready))

(script static boolean obj_sm0_as_14_9
(and (f_ai_is_defeated starport_cov_bridge_inf0) (f_task_is_empty obj_starport_cov/gate_missile0)))

(script static boolean obj_sm1_as_14_10
(and (f_ai_is_defeated starport_cov_bridge_inf0) (f_task_is_empty obj_starport_cov/gate_missile1)))

(script static boolean obj_sadvan_14_16
(and (>= objcon_starport 30) b_falcon_unloaded))

(script static boolean obj_sadvan_14_21
(and (<= (ai_living_count obj_starport_cov/gate_main) 8) (volume_test_players tv_starport_c0)))

(script static boolean obj_shold_14_25
b_falcon_unloaded)

(script static boolean obj_shold__14_26
(f_task_is_empty obj_starport_cov/gate_missile1))

(script static boolean obj_shold__14_27
(f_task_is_empty obj_starport_cov/gate_missile0))

(script static boolean obj_shold__14_28
(f_task_is_empty obj_starport_cov/gate_glass_canopy))

(script static boolean obj_sduval_14_30
(and (<= (ai_living_count starport_cov_inf0) 0) (<= (ai_living_count starport_cov_inf1) 0) b_falcon_unloaded))

(script static boolean obj_sgate__14_31
b_falcon_unloaded)

(script static boolean obj_svehic_14_39
b_players_all_on_foot)

(script static boolean obj_svehic_14_40
b_players_any_in_vehicle)

(script static boolean obj_swarth_14_42
(and b_starport_turret0_ready b_starport_turret1_ready))

(script static boolean obj_swarth_14_43
(or (> (ai_task_count obj_starport_cov/gate_missile1) 0) (not b_starport_turret1_ready)))

(script static boolean obj_swarth_14_44
(or (> (ai_task_count obj_starport_cov/gate_missile0) 0) (not b_starport_turret0_ready)))

(script static boolean obj_smongo_14_45
(and b_starport_turret0_ready b_starport_turret1_ready))

(script static boolean obj_smongo_14_46
(and (> (ai_task_count obj_starport_cov/gate_missile1) 0) (not b_starport_turret1_ready)))

(script static boolean obj_smongo_14_47
(and (> (ai_task_count obj_starport_cov/gate_missile0) 0) (not b_starport_turret0_ready)))

(script static boolean obj_smong__14_48
(volume_test_players tv_starport_right))

(script static boolean obj_smong__14_49
(volume_test_players tv_starport_left))

(script static boolean obj_smong__14_50
(volume_test_players tv_starport_center))

(script static boolean obj_swarth_14_51
(volume_test_players tv_starport_right))

(script static boolean obj_swarth_14_52
(volume_test_players tv_starport_left))

(script static boolean obj_swarth_14_53
(volume_test_players tv_starport_center))

(script static boolean obj_swarth_14_54
(> (ai_task_count obj_starport_cov_vehicles/wraith_main) 0))

(script static boolean obj_swarth_14_55
(> (ai_task_count obj_starport_cov_vehicles/wraith_backup) 0))

(script static boolean obj_swarth_14_56
(> (ai_task_count obj_starport_cov_vehicles/wraith_main) 0))

(script static boolean obj_sduval_14_57
(and b_starport_turret0_ready b_starport_turret1_ready))

(script static boolean obj_sduval_14_58
(<= (ai_living_count gr_unsc) 1))

(script static boolean obj_r789_d_15_7
(<= objcon_ride 105))

(script static boolean obj_r456_d_15_8
(<= objcon_ride 95))

(script static boolean obj_radvan_15_12
b_rooftop0_start)

(script static boolean obj_radvan_15_13
b_rooftop0_start)

(script static boolean obj_rrun_c_15_14
b_rooftop0_start)

(script static boolean obj_radvan_15_19
b_rooftop0_start)

(script static boolean obj_radvan_15_21
b_rooftop0_start)

(script static boolean obj_radvan_15_23
b_rooftop1_start)

(script static boolean obj_rrun_c_15_25
b_rooftop1_start)

(script static boolean obj_radvan_15_27
b_rooftop1_start)

(script static boolean obj_radvan_15_29
b_rooftop1_start)

(script static boolean obj_radvan_15_31
b_rooftop1_start)

(script static boolean obj_r123_d_15_33
(<= objcon_ride 70))

(script static boolean obj_r789_s_15_40
(<= objcon_ride 110))

(script static boolean obj_todst__17_5
(>= objcon_trophy 20))

(script static boolean obj_todst__17_6
(= b_trophy_complete true))

(script static boolean obj_ttroop_17_8
(= b_trophy_complete true))

(script static boolean obj_todst__17_10
(<= (ai_task_count obj_trophy_cov/gate_entrance) 3))

(script static boolean obj_ttroop_17_12
(<= (ai_task_count obj_trophy_cov/gate_entrance) 1))

(script static boolean obj_todst__17_13
(and (= b_trophy_counterattack true)(<= (ai_task_count obj_trophy_cov/gate_interior) 3)))

(script static boolean obj_ttroop_17_14
(and (= b_trophy_counterattack true)(<= (ai_task_count obj_trophy_cov/gate_interior) 1)))

(script static boolean obj_tcivil_17_16
(= b_ride_falcon_landed true))

(script static boolean obj_tcivil_17_17
(= b_ride_falcon_landed true))

(script static boolean obj_tcivil_17_21
(= b_evac1_landed true))

(script static boolean obj_todst__17_22
(volume_test_players tv_pad_entrance_mid))

(script static boolean obj_ttroop_17_23
(volume_test_players tv_pad_entrance_mid))

(script static boolean obj_todst__17_24
(and (<= (ai_task_count obj_trophy_cov/balcony_entrance) 0) (volume_test_players tv_balcony_entrance)))

(script static boolean obj_tbreak_17_25
(ai_allegiance_broken player human))

(script static boolean obj_tremov_17_26
b_falcon_goto_load_hover)

