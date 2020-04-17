(script static boolean obj_vleft__1_4
(< s_objcon_valley 20))

(script static boolean obj_vwrait_1_7
(<= (ai_task_count obj_valley_cov/gate_wraiths) 2))

(script static boolean obj_vgate__1_8
b_valley_spawn_air)

(script static boolean obj_vgate__1_10
b_valley_spawn_far)

(script static boolean obj_vkat_h_2_3
(not b_gatehouse_delay))

(script static boolean obj_vadvan_2_4
(<= (ai_task_count obj_valley_cov/gate_infantry) 2))

(script static boolean obj_vfoot__2_7
b_players_any_on_foot)

(script static boolean obj_vhouse_2_9
(not b_gatehouse_delay))

(script static boolean obj_vrock_2_10
(> (ai_task_count obj_valley_cov/gate_infantry) 2))

(script static boolean obj_vgate__2_11
(> (ai_living_count obj_valley_cov) 0))

(script static boolean obj_vpeak_2_15
(> (ai_living_count obj_valley_cov) 0))

(script static boolean obj_sgate__3_0
(>= s_objcon_sword 30))

(script static boolean obj_sgate__3_2
(>= s_objcon_sword 35))

(script static boolean obj_sgate__3_5
(>= s_objcon_sword 50))

(script static boolean obj_sgate__3_7
(< s_objcon_sword 25))

(script static boolean obj_s3_hig_3_10
(< s_objcon_sword 50))

(script static boolean obj_s3_con_3_23
(< s_objcon_sword 50))

(script static boolean obj_sboss__3_27
(>= s_objcon_sword 57))

(script static boolean obj_sgate__4_0
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/gate_floor_3) 1))(>= s_objcon_sword 50)))

(script static boolean obj_sgate__4_2
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/2_entry) 2))(>= s_objcon_sword 32)))

(script static boolean obj_sgate__4_5
(or (and (>= s_objcon_sword 50) (<= (ai_task_count obj_sword_cov/gate_floor_4) 0) ) (>= s_objcon_sword 57) ))

(script static boolean obj_sjorge_4_7
(or (<= (ai_task_count obj_sword_cov/gate_floor_0) 1) (>= s_objcon_sword 35) ))

(script static boolean obj_sjorge_4_11
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/gate_floor_2) 0))(>= s_objcon_sword 35)))

(script static boolean obj_sjorge_4_12
(or (and (>= s_objcon_sword 50) (<= (ai_task_count obj_sword_cov/gate_floor_4) 0) ) (>= s_objcon_sword 57) ))

(script static boolean obj_sjorge_4_13
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/gate_floor_3) 1))(>= s_objcon_sword 50)))

(script static boolean obj_skat_l_4_16
(> (ai_task_count obj_sword_cov/lobby_init) 0))

(script static boolean obj_sgate__4_17
(< s_objcon_sword 25))

(script static boolean obj_skat_l_4_18
(> (ai_task_count obj_sword_cov/lobby_fallback) 0))

(script static boolean obj_sjun_i_4_23
(< s_objcon_sword 27))

(script static boolean obj_sjorge_4_28
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/2_entry) 2))(>= s_objcon_sword 32)))

(script static boolean obj_sjorge_4_29
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/3_snipe) 2))(>= s_objcon_sword 50)))

(script static boolean obj_sjun_f_4_30
(or (<= (ai_task_count obj_sword_cov/gate_floor_0) 1) (>= s_objcon_sword 35) ))

(script static boolean obj_sjun_f_4_31
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/2_entry) 2))(>= s_objcon_sword 32)))

(script static boolean obj_sjun_f_4_32
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/gate_floor_2) 0))(>= s_objcon_sword 35)))

(script static boolean obj_sjun_f_4_33
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/3_snipe) 2))(>= s_objcon_sword 50)))

(script static boolean obj_sjun_f_4_34
(or (and (>= s_objcon_sword 50) (<= (ai_task_count obj_sword_cov/gate_floor_4) 0) ) (>= s_objcon_sword 57) ))

(script static boolean obj_skat_f_4_36
(or (<= (ai_task_count obj_sword_cov/gate_floor_0) 1) (>= s_objcon_sword 35) ))

(script static boolean obj_skat_f_4_37
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/2_entry) 2))(>= s_objcon_sword 32)))

(script static boolean obj_skat_f_4_38
(or (and (>= s_objcon_sword 30)(<= (ai_task_count obj_sword_cov/gate_floor_2) 0))(>= s_objcon_sword 35)))

(script static boolean obj_skat_f_4_39
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/3_snipe) 2))(>= s_objcon_sword 50)))

(script static boolean obj_skat_f_4_40
(or (and (>= s_objcon_sword 35)(<= (ai_task_count obj_sword_cov/gate_floor_3) 1))(>= s_objcon_sword 50)))

(script static boolean obj_skat_f_4_41
(or (and (>= s_objcon_sword 50) (<= (ai_task_count obj_sword_cov/gate_floor_4) 0) ) (>= s_objcon_sword 57) ))

(script static boolean obj_ghunte_5_3
(>= s_objcon_garage 5))

(script static boolean obj_ggate__5_5
(< s_objcon_garage 10))

(script static boolean obj_goffic_5_8
(>= s_objcon_garage 20))

(script static boolean obj_gbarri_5_14
(>= s_objcon_garage 3))

(script static boolean obj_gbob_f_5_16
(< s_objcon_garage 4))

(script static boolean obj_gtarge_5_18
(volume_test_players tv_garage_security))

(script static boolean obj_gelbow_6_2
(< s_objcon_garage 10))

(script static boolean obj_ggarag_6_4
(< s_objcon_garage 20))

(script static boolean obj_celbow_11_9
(or (< (ai_task_count obj_court_cov/gate_rear) 2) (< s_objcon_court 40)))

(script static boolean obj_cledge_11_11
(volume_test_players tv_court_ledge_side))

(script static boolean obj_cledge_11_12
(volume_test_players tv_court_ledge_rear))

(script static boolean obj_cbridg_11_13
(volume_test_players tv_court_bridge_left))

(script static boolean obj_cbridg_11_14
(volume_test_players tv_court_bridge_right))

(script static boolean obj_cgate__11_16
(< s_objcon_court 10))

(script static boolean obj_cgate__11_17
(< s_objcon_court 30))

(script static boolean obj_cgate__11_18
(< s_objcon_court 40))

(script static boolean obj_cgate__11_21
(< s_objcon_court 20))

(script static boolean obj_cmiddl_11_24
(or (< s_objcon_court 20) (< (ai_task_count obj_court_cov/gate_middle) 0)))

(script static boolean obj_crear_11_25
(< s_objcon_court 40))

(script static boolean obj_cgate__12_4
(or (> (ai_task_count obj_court_cov/gate_init) 0) (< s_objcon_court 5)))

(script static boolean obj_cgate__12_5
(or (> (ai_task_count obj_court_cov/gate_middle) 0) (< s_objcon_court 20)))

(script static boolean obj_cgate__12_7
(> (ai_task_count obj_court_cov/elbow_mid) 0))

(script static boolean obj_ckat_i_12_12
(or (> (ai_task_count obj_court_cov/gate_init) 0) (< s_objcon_court 5)))

(script static boolean obj_ckat_b_12_13
(or (> (ai_task_count obj_court_cov/gate_middle) 0) (< s_objcon_court 20)))

(script static boolean obj_ckat_b_12_14
(or (> (ai_task_count obj_court_cov/gate_rear) 0) (< s_objcon_court 30)))

(script static boolean obj_ckat_e_12_15
(or (> (ai_task_count obj_court_cov/elbow_mid) 0) (< s_objcon_court 40)))

(script static boolean obj_cgate__12_17
(> (ai_task_count obj_court_cov/gate_rear) 0))

(script static boolean obj_ckat_e_12_20
(or (> (ai_task_count obj_court_cov/elbow_rear) 0) (< s_objcon_court 45)))

(script static boolean obj_agate__14_17
(>= s_air_wave_count 2))

(script static boolean obj_agate__14_20
(<= (ai_task_count obj_air_cov/gate_infantry) 3))

(script static boolean obj_agate__14_24
(volume_test_players tv_air_garage_roof))

(script static boolean obj_aregro_15_7
b_air_kat_regroup)

(script static boolean obj_rbansh_17_0
(not b_roof_phantom_w1_spawn))

(script static boolean obj_rgate__17_2
(volume_test_players tv_roof_corvette_start))

(script static boolean obj_rcover_17_5
(>= s_objcon_roof 15))

(script static boolean obj_rregro_18_6
b_return_kat_regroup)

(script static boolean obj_finner_19_0
b_players_any_on_foot)

(script static boolean obj_freven_19_5
b_players_any_on_foot)

(script static boolean obj_fgate__19_9
(>= s_objcon_far 15))

(script static boolean obj_fgate__19_16
(>= s_objcon_far 20))

(script static boolean obj_ftop_l_19_22
(volume_test_players tv_far_cabin_top))

(script static boolean obj_fregro_20_6
b_far_kat_regroup)

(script static boolean obj_sgate__24_7
(< s_objcon_sword 25))

(script static boolean obj_sflak__24_17
(< s_objcon_sword 30))

(script static boolean obj_sflak__24_19
(< s_objcon_sword 32))

(script static boolean obj_sflak__24_20
(< s_objcon_sword 40))

