(script static boolean obj_ccove__0_28
(> (ai_task_count obj_cov_bch/cove_infantry_jackals_combat) 0))

(script static boolean obj_ccove__0_30
(> (ai_task_count obj_cov_bch/gate_cov_grunts) 0))

(script static boolean obj_ugate__1_9
(>= s_objcon_bch 25))

(script static boolean obj_ugate__1_11
(>= s_objcon_bch 80))

(script static boolean obj_ulandi_1_13
 (<= (ai_task_count obj_cov_bch/gate_landing) 1))

(script static boolean obj_ulandi_1_14
 (<= (ai_task_count obj_cov_bch/gate_landing) 0))

(script static boolean obj_urocks_1_18
(or (<= (ai_task_count obj_cov_bch/gate_rocks_infantry_forward) 0) (> s_objcon_bch 50)))

(script static boolean obj_urocks_1_19
(and (= b_bch_rocks_pods_complete true) (<= (ai_living_count sq_cov_bch_rocks_pods) 0)))

(script static boolean obj_urocks_1_20
(<= (ai_task_count obj_cov_bch/gate_rocks) 0))

(script static boolean obj_ubeach_1_22
(= b_bch_completed true))

(script static boolean obj_uspart_1_24
(= b_bch_counterattack_started true))

(script static boolean obj_uspart_1_25
(and (<= (ai_strength gr_cov_bch_cove) 0.75) (>= s_objcon_bch 100)))

(script static boolean obj_uspart_1_26
(and (<= (ai_strength gr_cov_bch_cove) 0.75) (<= (ai_task_count obj_cov_bch/gate_cove_forward) 0)))

(script static boolean obj_ulead__3_4
(>= s_objcon_fac 10))

(script static boolean obj_ulead__3_5
(>= s_objcon_fac 80))

(script static boolean obj_uspart_3_8
(>= s_objcon_fac 20))

(script static boolean obj_uspart_3_9
(>= s_objcon_fac 80))

(script static boolean obj_uspart_3_11
(>= s_objcon_fac 140))

(script static boolean obj_urocke_3_14
(and b_fac_deadman_jorge_waiting b_fac_deadman_kat_waiting b_fac_deadman_carter_waiting))

(script static boolean obj_cchase_6_3
(<= (ai_task_count obj_cov_waf/gate_main) 3))

(script static boolean obj_cgrunt_10_9
(> (ai_living_count sq_cov_brg_captain) 0))

(script static boolean obj_uadvan_11_2
(and (<= (ai_task_count obj_cov_brg/gate_main) 1) (>= s_objcon_brg 20)))

(script static boolean obj_uattac_11_3
(>= s_objcon_brg 10))

(script static boolean obj_usteal_11_4
(>= s_objcon_brg 10))

(script static boolean obj_ugate__11_5
(< (ai_combat_status gr_cov_brg) 3))

(script static boolean obj_udefea_11_6
(and (>= s_objcon_brg 10) (<= (ai_task_count obj_cov_brg/gate_main) 0)))

(script static boolean obj_cback_12_5
(= b_fin_wave_fallback true))

(script static boolean obj_cflak__12_17
(<= (ai_living_count gr_cov_fin) 3))

(script static boolean obj_cgate__12_20
(<= s_fin_wave 0))

(script static boolean obj_cgate__12_23
(<= s_fin_wave 1))

(script static boolean obj_cgate__12_26
(<= s_fin_wave 2))

(script static boolean obj_cgate__12_28
(<= s_fin_wave 3))

(script static boolean obj_ujorge_13_5
(= b_fin_firefight_started true))

(script static boolean obj_ujorge_13_6
(= b_fin_jorge_follow true))

(script static boolean obj_cfallb_14_2
(<= (ai_task_count obj_cov_com/gate_main) 3))

(script static boolean obj_cgate__14_3
(< s_objcon_com 20))

(script static boolean obj_celite_14_6
(>= s_objcon_com 30))

(script static boolean obj_uhold__15_3
(>= s_objcon_com 20))

(script static boolean obj_ucompl_15_4
(= b_com_completed true))

(script static boolean obj_udown_15_5
(<= (ai_living_count gr_cov_com_top) 0))

(script static boolean obj_cfollo_16_15
(volume_test_players tv_hgr_platform_rear))

(script static boolean obj_cgate__16_16
(= b_hgr_cov_follow true))

(script static boolean obj_cgate__16_23
(<= (ai_task_count obj_cov_hgr/gate_grunts) 3))

(script static boolean obj_chall__17_5
(>= (ai_task_count obj_cov_grm/gate_hall) 2))

(script static boolean obj_ubreac_18_2
(<= (ai_living_count sq_cov_grm_hall_breachers0) 0))

(script static boolean obj_uwait__18_3
(and (>= s_objcon_grm 20) (<= (ai_living_count gr_cov_grm_hall) 0)))

(script static boolean obj_ugunro_18_4
(and (>= s_objcon_grm 60) (<= (ai_task_count obj_cov_grm/gate_main) 0) (= b_grm_hol_finishes_dialogue true)))

(script static boolean obj_uadvan_18_5
(and (<= (ai_living_count sq_cov_grm_hall_breachers0) 0) (<= (ai_task_count obj_cov_grm/hall_elites_bunker) 0)))

(script static boolean obj_uassau_18_6
(>= s_objcon_grm 60))

(script static boolean obj_ugate__18_8
(= b_grm_doors_open true))

(script static boolean obj_ugunro_18_10
(and (>= s_objcon_grm 60) (<= (ai_task_count obj_cov_grm/gate_main) 0)))

(script static boolean obj_uhanga_21_1
(>= s_objcon_hgr 30))

(script static boolean obj_uentra_21_3
(not (f_ai_is_defeated sq_cov_hgr_breachers0)))

(script static boolean obj_uhall__21_4
(and (> (ai_spawn_count sq_cov_hgr_breachers0) 0) (<= (ai_living_count sq_cov_hgr_breachers0) 2)))

(script static boolean obj_uhanga_21_5
(and (>= s_objcon_hgr 30) (<= (ai_living_count gr_cov_hgr) 0)))

(script static boolean obj_uhanga_21_6
(and (<= (ai_task_count obj_cov_hgr/gate_main) 1) (>= (ai_living_count gr_cov_hgr_snipers) 1)))

(script static boolean obj_ufollo_23_1
(>= s_objcon_esc 30))

(script static boolean obj_ubreac_23_3
(<= (ai_task_count obj_cov_esc/breach_forward) 0))

(script static boolean obj_uesc_d_23_4
(and (>= s_objcon_esc 30) (<= (ai_task_count obj_cov_esc/gate_main) 0)))

(script static boolean obj_ubeach_25_1
(> (ai_task_count obj_unsc_bch_post/gate_dock) 0))

(script static boolean obj_ubeach_25_2
(> (ai_task_count obj_unsc_bch_post/gate_dock) 0))

(script static boolean obj_ugate__25_3
(<= (ai_task_count obj_unsc_bch_post/gate_main) 3))

(script static boolean obj_udock__25_6
(>= (ai_task_count obj_unsc_bch_post/gate_dock) 3))

(script static boolean obj_cbeach_26_2
(= b_bch_post_pelican_enroute true))

(script static boolean obj_cdock__26_3
(= b_bch_post_pelican_enroute true))

