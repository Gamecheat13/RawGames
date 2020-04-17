(script static boolean obj_dgate__0_0
(< objcon_dirt 50))

(script static boolean obj_dgate__0_1
(< objcon_dirt 60))

(script static boolean obj_dgate__0_6
(< objcon_dirt 60))

(script static boolean obj_dgate__0_8
(< objcon_dirt 60))

(script static boolean obj_dgate__0_10
(< objcon_dirt 60))

(script static boolean obj_dconvo_0_13
(f_dirt_convoy_search))

(script static boolean obj_dconvo_0_15
b_ridge_search)

(script static boolean obj_dconvo_0_16
(f_dirt_convoy_search))

(script static boolean obj_dconvo_0_17
(f_dirt_convoy_search))

(script static boolean obj_dgate__0_18
(< objcon_dirt 60))

(script static boolean obj_bgate__2_0
(< objcon_block 50))

(script static boolean obj_bgate__2_15
(>= objcon_block 40))

(script static boolean obj_bgate__2_17
(and (>= objcon_block 50) (= (ai_living_count sq_block_wraith) 0)  ))

(script static boolean obj_bgrunt_2_19
(< objcon_block 20))

(script static boolean obj_bgrunt_2_20
(< objcon_block 17))

(script static boolean obj_cgate__3_0
(< objcon_crane 50))

(script static boolean obj_cgate__3_1
(< objcon_crane 45))

(script static boolean obj_cgate__3_3
(< objcon_crane 50))

(script static boolean obj_clow_p_3_4
(< objcon_crane 40))

(script static boolean obj_cgate__3_7
(< objcon_crane 53))

(script static boolean obj_cunder_3_8
(volume_test_players tv_crane_area_under))

(script static boolean obj_chunte_3_12
(< objcon_crane 60))

(script static boolean obj_cskirm_3_21
(< objcon_crane 60))

(script static boolean obj_ccontr_4_0
(> (ai_task_count obj_crane_cov/gate_high) 1))

(script static boolean obj_clow_l_4_3
(< objcon_crane 45))

(script static boolean obj_cinit_4_5
(< objcon_crane 30))

(script static boolean obj_clow_l_4_6
(> (ai_task_count  obj_crane_cov/gate_low) 2))

(script static boolean obj_chigh_4_7
(> (ai_task_count obj_crane_cov/gate_middle) 1))

(script static boolean obj_cmiddl_4_8
(> (ai_task_count obj_crane_cov/gate_low) 1))

(script static boolean obj_clow_l_4_10
(> (ai_task_count  obj_crane_cov/gate_door) 2))

(script static boolean obj_cadvan_4_12
(< objcon_crane 40))

(script static boolean obj_cadvan_4_13
(< objcon_crane 45))

(script static boolean obj_cadvan_4_14
(< objcon_crane 55))

(script static boolean obj_cadvan_4_16
(< objcon_crane 50))

(script static boolean obj_demile_5_1
(not b_dirt_cov_alerted))

(script static boolean obj_demile_5_2
(> (ai_task_count obj_dirt_cov/gate_infantry) 8))

(script static boolean obj_demile_5_4
(> (ai_task_count obj_dirt_cov/gate_infantry) 12))

(script static boolean obj_demile_5_5
(<= objcon_dirt 10))

(script static boolean obj_demile_5_6
(< objcon_dirt 55))

(script static boolean obj_demile_5_7
(< objcon_dirt 40))

(script static boolean obj_demile_5_8
(< objcon_dirt 50))

(script static boolean obj_demile_5_9
(> (ai_task_count obj_dirt_cov/gate_infantry) 6))

(script static boolean obj_demile_5_10
(> (ai_task_count obj_dirt_cov/gate_infantry) 4))

(script static boolean obj_badvan_7_0
(> (ai_task_count obj_block_cov/gate_infantry) 12))

(script static boolean obj_badvan_7_3
(> (ai_task_count obj_block_cov/gate_infantry) 10))

(script static boolean obj_badvan_7_4
(> (ai_task_count obj_block_cov/gate_infantry) 8))

(script static boolean obj_badvan_7_5
(< objcon_block 70))

(script static boolean obj_binit_7_7
(< objcon_block 20))

(script static boolean obj_badvan_7_8
(< objcon_block 30))

(script static boolean obj_badvan_7_9
(< objcon_block 40))

(script static boolean obj_badvan_7_10
(or (and (< objcon_block 70)(> (ai_living_count sq_block_wraith) 1)) (and (< objcon_block 50)(>= (ai_living_count sq_block_wraith) 0))))

(script static boolean obj_badvan_7_11
(or (and (< objcon_block 70)(> (ai_living_count sq_block_wraith) 1)) (and (< objcon_block 60)(>= (ai_living_count sq_block_wraith) 0))))

(script static boolean obj_tbugge_8_4
(> objcon_tunnels 40))

(script static boolean obj_tbugge_8_6
(> objcon_tunnels 40))

(script static boolean obj_tgate__8_9
(< objcon_tunnels 55))

(script static boolean obj_twindo_8_12
(<= objcon_tunnels 40))

(script static boolean obj_tinit_9_0
(< objcon_tunnels 15))

(script static boolean obj_tadvan_9_2
(< objcon_tunnels 30))

(script static boolean obj_tadvan_9_3
(< objcon_tunnels 40))

(script static boolean obj_tadvan_9_4
(< objcon_tunnels 55))

(script static boolean obj_tadvan_9_5
(< objcon_tunnels 60))

(script static boolean obj_tadvan_9_7
(< objcon_tunnels 20))

(script static boolean obj_wleft__10_0
(< objcon_wall 40))

(script static boolean obj_wskirm_10_3
(and (volume_test_players tv_wall_left) (< objcon_wall 40)))

(script static boolean obj_wskirm_10_4
(and (volume_test_players tv_wall_left) (< objcon_wall 40)))

(script static boolean obj_wskirm_10_5
(< objcon_wall 40))

(script static boolean obj_wgate__10_8
(<= (ai_living_count obj_wall_cov) 4))

(script static boolean obj_wwait__10_10
(< objcon_wall 40))

(script static boolean obj_wwait__10_12
(< objcon_wall 40))

(script static boolean obj_wfallb_10_15
(< objcon_wall 60))

(script static boolean obj_wfallb_10_16
(< objcon_wall 50))

(script static boolean obj_wskirm_10_17
(< objcon_wall 40))

(script static boolean obj_wcente_10_18
(< objcon_wall 40))

(script static boolean obj_winit_11_5
(< objcon_wall 15))

(script static boolean obj_wgate__11_6
(and (<= (ai_task_count obj_wall_cov/left_middle) 2) (>= objcon_wall 30)))

(script static boolean obj_wgate__11_7
(and (<= (ai_task_count obj_wall_cov/center_middle) 2) (>= objcon_wall 30)))

(script static boolean obj_wgate__11_10
(and (<= (ai_task_count obj_wall_cov/fallback_crane) 2) (>= objcon_wall 40)))

(script static boolean obj_wgate__11_11
(and (<= (ai_task_count obj_wall_cov/fallback_ship) 2) (>= objcon_wall 50)))

(script static boolean obj_wadvan_11_14
(< objcon_wall 20))

(script static boolean obj_wadvan_11_16
(< objcon_wall 50))

(script static boolean obj_wadvan_11_17
(< objcon_wall 40))

(script static boolean obj_wadvan_11_18
(< objcon_wall 30))

(script static boolean obj_vemile_13_2
(> (ai_in_vehicle_count sq_emile) 0))

(script static boolean obj_fgate__14_6
(>= objcon_factory 30))

(script static boolean obj_fwreck_14_11
(< objcon_factory 25))

(script static boolean obj_fgate__14_15
(< objcon_factory 30))

(script static boolean obj_finit_15_1
(< objcon_factory 20))

(script static boolean obj_fgate__15_6
(<= (ai_task_count obj_factory_cov/wreck_right) 2))

(script static boolean obj_fgate__15_8
(<= (ai_living_count sq_factory_shade_1) 0))

(script static boolean obj_fgate__15_10
(<= (ai_task_count obj_factory_cov/gate_factory_ent) 2))

(script static boolean obj_fadvan_15_12
(< objcon_factory 25))

(script static boolean obj_fadvan_15_13
(< objcon_factory 30))

(script static boolean obj_fadvan_15_14
(< objcon_factory 40))

(script static boolean obj_fadvan_15_15
(< objcon_factory 50))

(script static boolean obj_cgate__16_2
(< objcon_catwalk 40))

(script static boolean obj_cgate__16_4
(< objcon_catwalk 35))

(script static boolean obj_celite_16_10
(< objcon_catwalk 40))

(script static boolean obj_celite_16_12
(< objcon_catwalk 30))

(script static boolean obj_cgate__16_13
(< objcon_catwalk 40))

(script static boolean obj_cinit_17_2
(< objcon_catwalk 20))

(script static boolean obj_cbecko_17_4
(and (< objcon_catwalk 1) (<= (ai_living_count gr_crane_cov_hunters) 0) (<= (ai_living_count sq_crane_skirmishers_1) 0) (<= (ai_living_count sq_crane_skirmishers_2) 0) ))

(script static boolean obj_cadvan_17_5
(< objcon_catwalk 30))

(script static boolean obj_cadvan_17_6
(< objcon_catwalk 40))

(script static boolean obj_cadvan_17_7
(< objcon_catwalk 60))

(script static boolean obj_zledge_18_5
(and (< objcon_zealot 40) (> (unit_get_health sq_zealot_elite_zealot) .8 )))

(script static boolean obj_zbay_r_18_7
(volume_test_players tv_zealot_bayright))

(script static boolean obj_zbay_l_18_9
(volume_test_players tv_zealot_bayleft))

(script static boolean obj_zstep__18_13
(< objcon_zealot 45))

(script static boolean obj_zgate__18_16
(< objcon_zealot 25))

(script static boolean obj_zelite_18_17
(< objcon_zealot 40))

(script static boolean obj_zengin_18_24
 (> (unit_get_health sq_zealot_engineer_1) .6 ))

(script static boolean obj_punder_19_0
(volume_test_players tv_platform_area_under))

(script static boolean obj_ptower_19_1
(volume_test_players tv_platform_area_towerlow))

(script static boolean obj_ptower_19_2
(volume_test_players tv_platform_area_towerroof))

(script static boolean obj_pledge_19_3
(volume_test_players tv_platform_area_ledge))

(script static boolean obj_pgate__19_4
(>= s_platform_wave 1))

(script static boolean obj_pgate__19_8
(< objcon_platform 40))

(script static boolean obj_pgate__19_10
(>= s_platform_wave 2))

(script static boolean obj_pgate__19_13
(>= s_platform_wave 0))

(script static boolean obj_psafer_19_15
(volume_test_players tv_platform_area_saferoom))

(script static boolean obj_pwave__19_17
(not b_platform_bezerk))

(script static boolean obj_pwave__19_18
(<= (ai_living_count obj_platform_cov) 9))

(script static boolean obj_pwave__19_23
b_platform_bezerk)

(script static boolean obj_pledge_20_2
(< s_platform_wave 1))

(script static boolean obj_proof_20_3
(< s_platform_wave 2))

(script static boolean obj_pgate__20_4
(< objcon_platform 30))

(script static boolean obj_pwindo_20_8
(<= (ai_task_count obj_platform_cov/gate_interior) 0))

(script static boolean obj_ptarge_20_9
b_platform_emile_split_done)

(script static boolean obj_padvan_20_10
(< objcon_platform 10))

(script static boolean obj_gbansh_25_3
(>= objcon_goose 17))

(script static boolean obj_gbansh_25_4
(>= objcon_goose 20))

(script static boolean obj_gbansh_25_5
(>= objcon_drop 20))

(script static boolean obj_gbansh_25_6
(>= objcon_drop 35))

(script static boolean obj_gbansh_25_7
(>= objcon_drop 45))

