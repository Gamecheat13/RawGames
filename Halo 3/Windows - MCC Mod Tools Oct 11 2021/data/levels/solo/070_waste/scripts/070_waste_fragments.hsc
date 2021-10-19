(script static boolean obj_larbit_0_2
(>= s_lz_progression 10))

(script static boolean obj_larbit_0_3
(>= s_lz_progression 20))

(script static boolean obj_ladvan_0_5
(>= s_lz_progression 10))

(script static boolean obj_ladvan_0_6
(>= s_lz_progression 20))

(script static boolean obj_ladvan_0_7
(>= s_lz_progression 30))

(script static boolean obj_ladvan_0_8
(>= s_lz_progression 40))

(script static boolean obj_larbit_0_9
(>= s_lz_progression 30))

(script static boolean obj_bmiddl_1_1
(<= s_b1_progression 40))

(script static boolean obj_bbefor_1_3
(not b_b1_combat_started))

(script static boolean obj_bfront_1_4
(> (ai_task_count obj_b1_cov/front) 0))

(script static boolean obj_bfront_1_5
(and (> (ai_living_count cov_b1_ini_brutes_0) 0) (<= s_b1_progression 35)))

(script static boolean obj_bfront_1_12
(not (volume_test_players vol_b1_down)))

(script static boolean obj_bfront_1_13
(> (ai_task_count obj_b1_cov/front) 0))

(script static boolean obj_bbrute_1_17
(not (volume_test_players vol_b1_down)))

(script static boolean obj_bbrute_1_18
(not (volume_test_players vol_b1_down)))

(script static boolean obj_bbrute_1_21
(and (<= (ai_task_count obj_b1_cov/brutes_advance) 0) (not (volume_test_players vol_b1_rear))))

(script static boolean obj_bbrute_1_23
(and (<= (ai_task_count obj_b1_cov/brutes_advance) 0) (not (volume_test_players vol_b1_rear))))

(script static boolean obj_bsnipe_2_0
(>= s_b1_allies_progression 2))

(script static boolean obj_bsnipe_2_1
(>= s_b1_allies_progression 1))

(script static boolean obj_bsnipe_2_2
(>= s_b1_progression 20))

(script static boolean obj_bmarin_2_4
(>= s_b1_allies_progression 3))

(script static boolean obj_bmarin_2_5
(>= s_b1_allies_progression 2))

(script static boolean obj_ballie_2_8
(>= s_lz_progression 20))

(script static boolean obj_bmarin_2_9
b_b1_combat_started)

(script static boolean obj_bsnipe_2_10
b_b1_finished)

(script static boolean obj_bmarin_2_11
b_b1_finished)

(script static boolean obj_bsnipe_2_13
(>= s_b1_progression 20))

(script static boolean obj_bmiddl_3_1
(and (< s_b2_progression 26) (not b_b2_hunters_placed)))

(script static boolean obj_bback_3_2
(< s_b2_progression 30))

(script static boolean obj_bjacka_3_9
b_b2_elites_charge)

(script static boolean obj_bsnipe_3_13
b_b2_hunters_placed)

(script static boolean obj_btop_r_3_14
b_b2_hunters_dead)

(script static boolean obj_bbotto_3_15
(and b_b2_hunters_dead (<= s_b2_progression 27)))

(script static boolean obj_bfront_3_16
(> (ai_task_count obj_b2_cov/front_face) 0))

(script static boolean obj_bfront_3_17
(< s_b2_progression 26))

(script static boolean obj_bcharg_3_20
(and b_b2_combat_started (volume_test_players vol_b2_charge) (not b_b2_hunters_placed)))

(script static boolean obj_bhunte_3_21
(volume_test_players vol_b2_ramp_0))

(script static boolean obj_biniti_3_22
(not b_b2_hunters_dead))

(script static boolean obj_bback__3_28
(not b_b2_hunters_placed))

(script static boolean obj_bback__3_30
b_b2_hunters_placed)

(script static boolean obj_bsnipe_4_0
(<= (ai_task_count obj_b2_cov/middle) 0))

(script static boolean obj_bsnipe_4_1
(<= (ai_task_count obj_b2_cov/front) 0))

(script static boolean obj_bmarin_4_4
(<= (ai_task_count obj_b2_cov/middle) 0))

(script static boolean obj_bmarin_4_5
(<= (ai_task_count obj_b2_cov/front) 0))

(script static boolean obj_bafter_4_7
b_b2_finished)

(script static boolean obj_bbefor_4_8
(not b_b2_combat_started))

(script static boolean obj_bafter_4_10
(>= s_b2_progression 30))

(script static boolean obj_bafter_4_11
(>= s_b2_progression 40))

(script static boolean obj_bafter_4_12
(>= s_b2_progression 27))

(script static boolean obj_bmarin_4_13
(and (> (ai_task_count obj_b2_cov/top_ramp) 0) (>= s_b2_progression 30) b_b2_hunters_dead))

(script static boolean obj_bsnipe_4_14
(and b_b2_hunters_dead (or (>= s_b2_progression 27) (<= (ai_task_count obj_b2_cov/bottom_ramp) 0))))

(script static boolean obj_bmarin_4_15
(and b_b2_hunters_dead (or (>= s_b2_progression 27) (<= (ai_task_count obj_b2_cov/bottom_ramp) 0))))

(script static boolean obj_bsnipe_4_16
b_b2_hunters_dead)

(script static boolean obj_bmarin_4_17
b_b2_hunters_dead)

(script static boolean obj_fmarin_5_1
(>= s_fp_progression 20))

(script static boolean obj_emaule_6_1
b_ex_mauler_charge)

(script static boolean obj_epart__6_8
(>= s_ex_progression 35))

(script static boolean obj_epart__6_11
(volume_test_players vol_ex_corridor))

(script static boolean obj_emaule_6_17
(< s_ex_progression 35))

(script static boolean obj_epart__6_20
(< s_ex_progression 35))

(script static boolean obj_ecave__7_4
(>= s_ex_progression 65))

(script static boolean obj_ecave__7_5
(>= s_ex_progression 60))

(script static boolean obj_ecave__7_7
(and b_sd_finished (volume_test_players vol_ex_before_trench)))

(script static boolean obj_enear__8_1
b_ex_p1_finished)

(script static boolean obj_eafter_8_2
(or b_ex_p1_finished b_ex_part_2_finished))

(script static boolean obj_eafter_8_4
(>= s_ex_progression 27))

(script static boolean obj_eafter_8_5
(and b_ex_part_2_finished (>= s_ex_progression 40)))

(script static boolean obj_eafter_8_6
(AND (volume_test_players vol_ex_sd_encounter) b_sd_warthog_can_go))

(script static boolean obj_eafter_8_7
(>= s_ex_progression 60))

(script static boolean obj_eafter_8_8
(AND (volume_test_players vol_ex_sd_area) (not b_sd_warthog_can_go)))

(script static boolean obj_eafter_8_10
(AND (>= s_ex_progression 50) (not b_sd_warthog_can_go)))

(script static boolean obj_eafter_8_11
(ai_player_any_needs_vehicle))

(script static boolean obj_eafter_8_13
(>= s_ex_progression 55))

(script static boolean obj_eafter_8_14
(>= s_ex_progression 50))

(script static boolean obj_einfan_8_15
(>= s_ex_progression 10))

(script static boolean obj_esd_do_8_16
(> (ai_task_count obj_sd_cov/door_retreat) 0))

(script static boolean obj_esd_fl_8_17
(or (> (ai_task_count obj_sd_cov/flak) 0) (> (ai_task_count obj_sd_cov/bridge_entrance_active) 0)))

(script static boolean obj_esd_ce_8_18
(> (ai_task_count obj_sd_cov/choppers) 0))

(script static boolean obj_einfan_8_19
(= (ai_task_status obj_ex_cov/infantry_front) ai_task_status_exhausted))

(script static boolean obj_einfan_8_20
(= (ai_task_status obj_ex_cov/infantry_middle) ai_task_status_exhausted))

(script static boolean obj_einfan_8_21
(= (ai_task_status obj_ex_cov/infantry_back) ai_task_status_exhausted))

(script static boolean obj_einfan_8_22
b_ex_p1_has_started)

(script static boolean obj_ep1_ve_8_23
b_ex_p1_has_started)

(script static boolean obj_ep2_ve_8_26
(>= s_ex_progression 35))

(script static boolean obj_eafter_9_0
b_ex_cave_finished)

(script static boolean obj_svehic_10_0
(> (ai_task_count obj_sd_cov/choppers) 0))

(script static boolean obj_svehic_10_3
(> (ai_task_count obj_sd_cov/flak) 0))

(script static boolean obj_svehic_10_4
(> (ai_task_count obj_sd_cov/door_retreat) 0))

(script static boolean obj_sretre_11_0
b_sd_grunts_flee)

(script static boolean obj_schopp_11_6
(volume_test_players vol_sd_bridge))

(script static boolean obj_sbridg_11_10
(< s_sd_progression 10))

(script static boolean obj_sclean_12_1
(<= (ai_living_count gr_cov_sd_bridge) 0))

(script static boolean obj_scharg_12_2
b_sd_sentinels_charge)

(script static boolean obj_sexit_12_3
b_ex_cave_finished)

(script static boolean obj_abridg_13_1
(>= (ai_task_count obj_aw_cov/wraith_mortar) 1))

(script static boolean obj_aghost_13_6
(<= (ai_task_count obj_aw_cov/bridge_front) 0))

(script static boolean obj_acave_13_11
(<= s_aw_progression 20))

(script static boolean obj_aghost_13_12
(volume_test_players vol_aw_pass_bridge))

(script static boolean obj_awrait_13_14
(and (not (volume_test_players vol_aw_pass_bridge)) b_aw_wraith_advance))

(script static boolean obj_awrait_13_18
(<= (ai_task_count obj_aw_cov/wraith_up_right) 0))

(script static boolean obj_aghost_13_19
b_aw_wraith_advance)

(script static boolean obj_awrait_13_22
(<= s_aw_progression 20))

(script static boolean obj_ainfan_13_25
(>= s_aw_progression 30))

(script static boolean obj_aghost_13_27
(<= (ai_task_count obj_aw_cov/bridge_front) 0))

(script static boolean obj_awarth_14_2
(AND b_aw_marines_advance (>= s_aw_progression 30)))

(script static boolean obj_abunke_14_3
b_aw_marines_advance)

(script static boolean obj_awarth_14_6
b_aw_marines_advance)

(script static boolean obj_lghost_16_1
(<= s_la_progression 10))

(script static boolean obj_lhunte_16_7
(<= s_la_progression 20))

(script static boolean obj_lwrait_17_5
(<= s_la_progression 40))

(script static boolean obj_lwrait_17_8
(and (<= s_la_progression 50) (>= (unit_get_health cov_la_p2_trench_wraith) 0.9)))

(script static boolean obj_lghost_17_10
(<= s_la_progression 60))

(script static boolean obj_lbansh_17_15
(and (<= s_la_progression 30) (> (ai_living_count gr_cov_la_p2_a) 1)))

(script static boolean obj_lghost_17_19
(and (<= (ai_task_count obj_la_p2_cov/ghosts_trench) 2) (>= s_la_progression 60)))

(script static boolean obj_lghost_17_22
(>= s_la_progression 70))

(script static boolean obj_lwarth_18_3
(<= (ai_task_count obj_la_p1_cov/ghosts) 0))

(script static boolean obj_lwarth_18_7
(<= (ai_task_count obj_la_p1_cov/ghosts) 0))

(script static boolean obj_lscorp_18_8
(>= s_la_progression 10))

(script static boolean obj_lwarth_18_10
(>= s_la_progression 10))

(script static boolean obj_lback_19_9
(>= s_la_progression 30))

(script static boolean obj_lbefor_19_10
(>= s_la_progression 35))

(script static boolean obj_ltrenc_19_11
(<= (ai_living_count gr_cov_la_p2_a) 0))

(script static boolean obj_lafter_19_12
(and (>= s_la_progression 70) (<= (ai_living_count gr_cov_la_p2_b) 0)))

(script static boolean obj_ltrenc_19_13
(>= s_la_progression 50))

(script static boolean obj_ltrenc_19_14
(>= s_la_progression 40))

(script static boolean obj_lfollo_20_1
b_gs_follow_player)

(script static boolean obj_lmiddl_20_2
(>= s_la_progression 10))

(script static boolean obj_lend_20_3
(>= s_la_progression 25))

(script static boolean obj_lnear__20_4
b_fl_070bb_done)

(script static boolean obj_lfollo_21_1
b_gs_follow_player)

(script static boolean obj_lmiddl_21_2
(>= s_la_progression 35))

(script static boolean obj_lbefor_21_3
(>= s_la_progression 40))

(script static boolean obj_lafter_21_4
(>= s_la_progression 50))

(script static boolean obj_lend_21_5
(>= s_la_progression 80))

(script static boolean obj_dtanks_22_3
(<= (ai_task_count obj_dw_cov/wraith_back_left) 0))

(script static boolean obj_dcomba_22_10
(>= s_dw_progression 20))

(script static boolean obj_dafter_22_13
b_dw_combat_finished)

(script static boolean obj_dwarth_22_15
b_dw_reinf_arrived)

(script static boolean obj_dtanks_22_16
(and (<= (ai_living_count gr_cov_dw_wraiths) 2) b_dw_reinf_arrived))

(script static boolean obj_dwarth_22_17
b_dw_reinf_arrived)

(script static boolean obj_dwrait_23_8
(volume_test_players vol_dw_down))

(script static boolean obj_dwrait_23_11
(>= s_dw_progression 40))

(script static boolean obj_dvehic_23_12
(and (<= (ai_task_count obj_dw_cov/wraith_back_left) 0) (not (volume_test_players vol_dw_left))))

(script static boolean obj_dvehic_23_13
(>= s_dw_progression 25))

(script static boolean obj_dvehic_23_14
(volume_test_players vol_dw_down))

(script static boolean obj_dfollo_24_1
b_gs_follow_player)

(script static boolean obj_dmiddl_24_3
(volume_test_players vol_dw_down))

(script static boolean obj_dnear__24_5
(>= s_dw_progression 30))

(script static boolean obj_dafter_24_6
b_dw_reinf_arrived)

(script static boolean obj_dafter_24_7
(>= s_dw_progression 20))

(script static boolean obj_ddoor__24_8
(volume_test_players vol_dw_near_door))

(script static boolean obj_lguilt_25_2
(>= s_lb_progression 40))

(script static boolean obj_lguilt_25_3
(>= s_lb_progression 50))

(script static boolean obj_lguilt_25_4
b_gs_follow_player)

(script static boolean obj_lguilt_25_5
(or b_lb_gs_open_door (>= s_lb_progression 20)))

(script static boolean obj_lguilt_25_6
b_lb_lightbridge_on)

(script static boolean obj_lguilt_25_8
(>= s_lb_progression 10))

(script static boolean obj_lfar_s_25_9
b_lb_lightbridge_on)

(script static boolean obj_lconst_26_1
(= s_lb_constructor_position 1))

(script static boolean obj_lconst_26_2
(= s_lb_constructor_position 2))

(script static boolean obj_lconst_26_3
(= s_lb_constructor_position 3))

(script static boolean obj_lconst_26_4
(= s_lb_constructor_position 4))

(script static boolean obj_lconst_26_11
b_lb_constructors_exit)

(script static boolean obj_lconst_26_12
b_lb_lightbridge_on)

(script static boolean obj_bcanyo_27_0
(<= s_bb_progression 40))

(script static boolean obj_bcanyo_27_1
(and (<= s_bb_progression 10) (unit_in_vehicle allies_bb_player_warthog/driver)))

(script static boolean obj_bcanyo_27_2
(<= s_bb_progression 20))

(script static boolean obj_bcanyo_27_4
(<= s_bb_progression 30))

(script static boolean obj_bcanyo_27_6
(>= s_bb_progression 40))

(script static boolean obj_bentra_27_7
(<= s_bb_progression 40))

(script static boolean obj_bentra_27_8
(<= s_bb_progression 50))

(script static boolean obj_b3rd_f_27_16
(<= s_bb_progression 70))

(script static boolean obj_b4th_f_27_19
(>= s_bb_progression 70))

(script static boolean obj_bdefen_27_23
(AND (<= s_bb_progression 90) (OR (not bb_scarab_spawned) (>= (ai_living_count cov_bb_scarab) 1))))

(script static boolean obj_bghost_27_29
b_bb_ghosts_escort_wraiths)

(script static boolean obj_bghost_27_30
(volume_test_object vol_bb_bottom_floor_left cov_bb_scarab))

(script static boolean obj_bghost_27_31
(>= (ai_living_count obj_bb_cov/2nd_floor_right) 2))

(script static boolean obj_bghost_27_32
(>= (ai_living_count obj_bb_cov/2nd_floor_left) 2))

(script static boolean obj_bghost_27_33
(<= s_bb_position 2))

(script static boolean obj_bghost_27_34
(>= (ai_living_count obj_bb_cov/1st_floor_right) 2))

(script static boolean obj_bghost_27_35
(>= (ai_living_count obj_bb_cov/1st_floor_left) 2))

(script static boolean obj_bghost_27_36
(<= s_bb_position 1))

(script static boolean obj_bghost_27_37
(not bb_scarab_spawned))

(script static boolean obj_b1st_f_27_39
(not b_bb_player_went_canyon))

(script static boolean obj_bghost_27_41
(volume_test_object vol_bb_bottom_floor_right cov_bb_scarab))

(script static boolean obj_bghost_27_42
(<= s_bb_position 3))

(script static boolean obj_b1st_f_29_0
(AND (<= s_bb_progression 50) (>= (ai_task_count obj_bb_cov/1st_floor) 2)))

(script static boolean obj_b2nd_f_29_1
(AND (<= s_bb_progression 60) (>= (ai_task_count obj_bb_cov/2nd_floor) 2)))

(script static boolean obj_b3rd_f_29_2
(AND (<= s_bb_progression 70) (>= (ai_task_count obj_bb_cov/3rd_floor) 2) b_bb_dropped_3rd_floor))

(script static boolean obj_biniti_29_4
(and (not b_bb_phantom_retreat) (or (<= s_bb_progression 20) (not b_bb_wraith_dropped))))

(script static boolean obj_bcanyo_29_5
(<= s_bb_progression 30))

(script static boolean obj_b1st_f_30_9
(>= s_bb_allies_progression 20))

(script static boolean obj_b2nd_f_30_10
(>= s_bb_allies_progression 30))

(script static boolean obj_bentra_30_11
(and (>= s_bb_progression 40) (<= (ai_task_count obj_bb_cov/entrance_vehicle_1) 2)))

(script static boolean obj_b3rd_f_30_12
(>= s_bb_allies_progression 40))

(script static boolean obj_b4th_f_30_16
(>= s_bb_allies_progression 50))

(script static boolean obj_bbase_30_19
(>= s_bb_allies_progression 60))

(script static boolean obj_b4th_f_30_22
(<= (ai_living_count cov_bb_scarab) 0))

(script static boolean obj_b4th_f_30_23
(<= (ai_living_count cov_bb_scarab) 0))

(script static boolean obj_b4th_f_30_25
(<= (ai_living_count cov_bb_scarab) 0))

(script static boolean obj_bcanyo_30_27
(>= s_bb_allies_progression 10))

(script static boolean obj_bcanyo_30_28
(= (ai_task_status  obj_bb_cov/canyon_ghost_1) ai_task_status_exhausted))

(script static boolean obj_bcanyo_30_30
(= (ai_task_status  obj_bb_cov/canyon_ghost_0) ai_task_status_exhausted))

(script static boolean obj_bcanyo_30_31
(<= (ai_task_count  obj_bb_cov/canyon_vehicle_only) 1))

(script static boolean obj_bcanyo_30_35
(>= s_bb_allies_progression 15))

(script static boolean obj_bbase__31_0
(AND (<= (ai_living_count cov_bb_scarab) 0) bb_scarab_spawned))

(script static boolean obj_b4th_f_31_1
(and (<= (ai_task_count obj_bb_cov/3rd_floor) 1) b_bb_dropped_3rd_floor (>= (ai_living_count cov_bb_scarab) 0)))

(script static boolean obj_b3rd_f_31_2
(<= (ai_task_count obj_bb_cov/2nd_floor) 1))

(script static boolean obj_b2nd_f_31_3
(and (<= (ai_task_count obj_bb_cov/1st_floor) 1) (>= (ai_living_count obj_bb_cov/2nd_floor_left) 1)))

(script static boolean obj_b1st_f_31_4
(and (<= (ai_task_count obj_bb_cov/entrance) 1) (>= (ai_living_count obj_bb_cov/1st_floor_left) 1)))

(script static boolean obj_bentra_31_5
(>= s_bb_progression 40))

(script static boolean obj_bcanyo_31_7
(>= s_bb_progression 30))

(script static boolean obj_b1st_f_31_8
(and (<= (ai_task_count obj_bb_cov/entrance) 1) (>= (ai_living_count obj_bb_cov/1st_floor_right) 1)))

(script static boolean obj_b2nd_f_31_9
(and (<= (ai_task_count obj_bb_cov/1st_floor) 1) (>= (ai_living_count obj_bb_cov/2nd_floor_right) 1)))

(script static boolean obj_b4th_f_31_10
(and (<= (ai_task_count obj_bb_cov/3rd_floor) 1) b_bb_dropped_3rd_floor (>= (ai_living_count cov_bb_scarab) 0)))

(script static boolean obj_bscara_32_2
(volume_test_players vol_bb_scarab_top))

(script static boolean obj_bscara_33_1
(volume_test_players vol_bb_base_back))

(script static boolean obj_bscara_33_2
(volume_test_players vol_bb_higher_floors))

(script static boolean obj_bbase__34_2
(<= (ai_living_count cov_bb_scarab) 0))

(script static boolean obj_aentra_35_1
(<= s_abb_progression 5))

(script static boolean obj_atop_a_35_15
(volume_test_players vol_abb_near_top))

(script static boolean obj_aentra_36_1
(and (<= (ai_task_count obj_abb_cov/entrance_front) 0) (>= s_abb_progression 2)))

(script static boolean obj_aentra_36_2
(and (<= (ai_task_count obj_abb_cov/entrance_middle) 0) (>= s_abb_progression 5)))

(script static boolean obj_aramp_36_4
(and (<= (ai_task_count obj_abb_cov/entrance_back) 0) (>= s_abb_progression 5)))

(script static boolean obj_aramp__36_5
(and (>= s_abb_progression 10) (<= (ai_living_count gr_cov_bb_base) 0)))

(script static boolean obj_aramp__36_6
(and (>= s_abb_progression 7) (<= (ai_task_count obj_abb_cov/jackals_middle) 0) (<= (ai_task_count obj_abb_cov/middle) 0)))

(script static boolean obj_aramp__36_7
(<= (ai_task_count obj_abb_cov/jackals_front) 0))

(script static boolean obj_apelic_36_9
b_abb_pelican_marines_moving)

(script static boolean obj_aarbit_36_12
b_abb_pelican_marines_moving)

(script static boolean obj_afollo_38_1
b_gs_follow_player)

(script static boolean obj_awork__38_2
(>= s_abb_progression 1))

(script static boolean obj_fbefor_39_2
(not b_f1_combat_started))

(script static boolean obj_fleft_40_0
(volume_test_players vol_f1_right))

(script static boolean obj_fwait_40_2
b_f1_allies_wait)

(script static boolean obj_fway_b_40_3
b_f1_prepare_to_combat)

(script static boolean obj_froom_40_4
(AND b_f1_combat_started (>= s_f1_progression 10)))

(script static boolean obj_farbit_40_5
(AND b_f1_prepare_to_combat (>= (ai_living_count gr_cov_f1) 1) (>= (ai_living_count allies_f1_mar) 1)))

(script static boolean obj_ffollo_40_6
(>= s_f1_progression 30))

(script static boolean obj_fafter_40_7
(<= (ai_living_count gr_cov_f1) 0))

(script static boolean obj_fright_40_8
(volume_test_players vol_f1_left))

(script static boolean obj_finsid_41_1
b_f1_gs_advance)

(script static boolean obj_fpost__41_3
(AND (> (device_get_power f1_entrance_door) 0.5) (<= (ai_living_count gr_cov_f1) 0)))

(script static boolean obj_fstair_41_4
(>= s_f1_progression 20))

(script static boolean obj_ffollo_41_5
b_gs_follow_player)

(script static boolean obj_ffollo_42_0
(volume_test_players vol_f2_advance_2))

(script static boolean obj_ffollo_42_1
(or (volume_test_players vol_f2_advance_3) (volume_test_players vol_f2_advance_4)))

(script static boolean obj_ffollo_42_2
(volume_test_players vol_f2_advance_5))

(script static boolean obj_ffollo_42_3
(volume_test_players vol_f2_end_1st_floor))

(script static boolean obj_ffollo_42_4
b_f2_combat_started)

(script static boolean obj_farbit_42_6
(<= (ai_combat_status cov_f2_grt_pack) 1))

(script static boolean obj_farbit_42_7
(>= s_f2_progression 20))

(script static boolean obj_farbit_42_8
(>= s_f2_progression 40))

(script static boolean obj_farbit_42_9
(>= s_f2_progression 50))

(script static boolean obj_ftemp__42_10
(>= s_f2_progression 30))

(script static boolean obj_farbit_42_12
(<= (ai_task_count obj_f2_cov/front) 0))

(script static boolean obj_ffront_42_14
(and b_f2_combat_started (<= (ai_task_count obj_f2_cov/front) 0)))

(script static boolean obj_fafter_42_15
(<= (ai_living_count cov_f2_grt_pack) 0))

(script static boolean obj_ffront_43_1
(OR (<= s_f2_progression 30) (<= (ai_combat_status cov_f2_grt_pack) 1)))

(script static boolean obj_fnot_i_43_4
(<= (ai_combat_status cov_f2_grt_pack) 2))

(script static boolean obj_ffollo_44_1
b_gs_follow_player)

(script static boolean obj_froom__44_3
(>= s_f2_progression 40))

(script static boolean obj_froom__44_4
(>= s_f2_progression 30))

(script static boolean obj_froom__44_5
(and (>= s_f2_progression 40) b_f2_combat_started))

(script static boolean obj_fstair_44_6
(>= s_f2_progression 50))

(script static boolean obj_ftermi_44_7
(and (>= s_f2_progression 20) b_f2_gs_terminal))

(script static boolean obj_fpatro_45_0
(<= (ai_combat_status cov_f3_brt_pack) ai_combat_status_active))

(script static boolean obj_fjacka_45_5
(< s_f3_p1_progression 17))

(script static boolean obj_fjacka_45_7
(> (ai_living_count cov_f3_brt_pack) 1))

(script static boolean obj_fwait__46_1
(< s_f3_p1_progression 30))

(script static boolean obj_fback_47_5
(<= (ai_living_count cov_f3_brt_pack) 2))

(script static boolean obj_fafter_47_10
(>= s_f3_p1_progression 30))

(script static boolean obj_fafter_47_11
(>= s_f3_p1_progression 20))

(script static boolean obj_fafter_47_13
b_f3_p1_int_combat_finished)

(script static boolean obj_fexit__48_1
(or (<= (ai_task_count obj_f3_cov_p1/back) 0) (>= s_f3_p1_progression 20)))

(script static boolean obj_ffollo_48_2
b_gs_follow_player)

(script static boolean obj_fpart__48_3
b_f3_p2_started)

(script static boolean obj_fnear__48_4
b_f3_p2_combat_finished)

(script static boolean obj_fstair_48_5
(>= s_f3_p2_progression 50))

(script static boolean obj_fbefor_49_0
(<= s_f3_p1_progression 30))

(script static boolean obj_fnear__49_1
(<= s_f3_p2_progression 0))

(script static boolean obj_fnear__49_2
b_f3_p2_gs_guide)

(script static boolean obj_fpart__49_4
b_f3_p2_started)

(script static boolean obj_ffollo_49_5
b_gs_follow_player)

(script static boolean obj_fbrt_c_51_0
(<= s_f3_p2_progression 40))

(script static boolean obj_fright_51_8
(volume_test_players vol_f3_right))

(script static boolean obj_fleft_53_1
(= true (volume_test_players vol_f3_right)))

(script static boolean obj_fright_53_2
(= true (volume_test_players vol_f3_left)))

(script static boolean obj_fcomba_53_3
b_f3_p2_combat_finished)

(script static boolean obj_fback_54_0
b_f3_p2_take_combat_outside)

(script static boolean obj_ffront_55_1
(and (<= (ai_living_count cov_f4_brt_ambush) 0) (>= s_f4_progression 30)))

(script static boolean obj_fafter_55_2
b_f4_fight_finished)

(script static boolean obj_fbrute_56_0
b_f4_enable_left)

(script static boolean obj_fbrute_56_1
b_f4_enable_right)

(script static boolean obj_fprepa_56_3
(OR (volume_test_players vol_f4_right_room) (< (ai_combat_status cov_f4_brt_ambush) 4)))

(script static boolean obj_fbrute_56_9
(and b_f4_enable_top b_f4_enable_right))

(script static boolean obj_fbrute_56_10
(and b_f4_enable_top b_f4_enable_left))

(script static boolean obj_ffollo_58_0
b_gs_follow_player)

(script static boolean obj_fafter_58_4
b_f4_fight_finished)

(script static boolean obj_fjetpa_59_1
(volume_test_players vol_f5_right))

(script static boolean obj_fjetpa_59_2
(volume_test_players vol_f5_left))

(script static boolean obj_fchief_59_6
b_f5_chieftain_charge)

(script static boolean obj_fjetpa_59_8
(>= s_f5_progression 15))

(script static boolean obj_fjetpa_59_9
(volume_test_players vol_f5_right))

(script static boolean obj_fjetpa_59_10
(volume_test_players vol_f5_left))

(script static boolean obj_fjetpa_59_12
(volume_test_players vol_f5_left))

(script static boolean obj_fjetpa_59_13
(volume_test_players vol_f5_right))

(script static boolean obj_fjetpa_59_14
(<= (ai_task_count obj_f5_cov/jetpack_combat_started) 0))

(script static boolean obj_fback_60_0
(and b_f5_chieftain_charge (> (ai_living_count cov_f5_brt_chieftain) 0)))

(script static boolean obj_fafter_60_2
b_f5_combat_finished)

(script static boolean obj_fbefor_60_3
(< s_f5_progression 15))

(script static boolean obj_ffollo_61_0
b_gs_follow_player)

(script static boolean obj_fafter_61_1
b_f5_combat_finished)

(script static boolean obj_fleft_61_2
(volume_test_players vol_f5_left))

(script static boolean obj_fright_61_3
(volume_test_players vol_f5_right))

(script static boolean obj_ffollo_61_4
b_gs_follow_player)

