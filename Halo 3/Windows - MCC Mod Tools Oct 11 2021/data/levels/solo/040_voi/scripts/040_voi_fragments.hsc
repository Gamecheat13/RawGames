(script static boolean introarriv_0_2
(volume_test_players vol_drive_intro_end))

(script static boolean introarriv_0_4
(volume_test_players vol_intro_go))

(script static boolean introguard_0_7
(volume_test_players vol_faa))

(script static boolean factotank__1_3
(>= (device_get_position factory_a_middle) .5))

(script static boolean factoadvan_1_5
(>= (ai_living_count factory_a_covenant_obj/big_fallback) 1))

(script static boolean factoadvan_1_6
(<= (ai_task_count factory_a_covenant_obj/big_fallback) 5))

(script static boolean factofollo_1_7
(<= (ai_living_count factory_a_covenant_obj) 0))

(script static boolean factoroom__1_8
(<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 2))

(script static boolean factofinis_1_9
(<= (ai_living_count factory_a_covenant_obj) 0))

(script static boolean factocov_a_1_10
(<= (ai_task_count factory_a_covenant_obj/faa_cov_init) 0))

(script static boolean factoentry_1_11
(> (device_get_position factory_a_entry02) 0))

(script static boolean factofirst_1_12
(<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 0))

(script static boolean factoleft__1_13
(volume_test_players vol_faa_button02))

(script static boolean factotank__2_3
(>= (device_get_position factory_a_middle) .5))

(script static boolean factofacto_2_12
(<= (device_get_position factory_a_entry) .45))

(script static boolean factofaa_c_2_17
(<= (ai_combat_status factory_a_covenant_obj/faa_cov_init) 3))

(script static boolean factofirst_2_20
(<= (device_get_position factory_a_entry02) .9))

(script static boolean factotunne_2_21
(volume_test_players vol_faa_upperflank))

(script static boolean lakebcente_3_2
(<= (ai_living_count lake_a_cov_center) 0))

(script static boolean lakebcente_3_3
(<= (ai_living_count lake_a_cov_center) 2))

(script static boolean lakebgauss_4_4
(or (volume_test_players vol_lakebed_a_high_start)  (volume_test_players  vol_lake_a_bed)))

(script static boolean lakebcente_4_6
(>= (ai_task_status lakebed_a_covenant_obj/center_structure) 4))

(script static boolean lakebwin_g_4_9
(>= (device_get_position factory_b_entry_door) 1))

(script static boolean lakebend_g_4_11
(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0))

(script static boolean lakebwin_v_4_14
(<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0))

(script static boolean lakebgauss_4_16
(volume_test_players vol_lake_a_bed))

(script static boolean lakebgauss_4_17
(> (device_get_position lakebed_a_entry_door) .9))

(script static boolean lakebcente_4_18
(volume_test_players  vol_lake_a_bed))

(script static boolean lakebhog_b_4_19
(and (any_players_in_vehicle) (volume_test_players  vol_lake_a_bed)))

(script static boolean lakebinf_a_4_20
(>= (ai_task_status lakebed_a_covenant_obj/center_flank) ai_task_status_exhausted))

(script static boolean lakebwin_e_4_21
(volume_test_players vol_lakebed_a_end))

(script static boolean lakebhorne_4_25
(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0))

(script static boolean lakebhog_f_4_27
(or (volume_test_players vol_lakebed_a_high_start)  (volume_test_players  vol_lake_a_bed)))

(script static boolean lakebhorne_4_28
(volume_test_players vol_lakebed_a_end))

(script static boolean lakebwrait_5_1
(>= (ai_task_count lakebed_a_allies/hornets_gate) 1))

(script static boolean lakebcente_5_7
(>= (ai_living_count lake_a_cov_end_grunts) 1))

(script static boolean lakebghost_5_15
(volume_test_object vol_lakebed_a_troop_init (ai_vehicle_get_from_starting_location intro_hog/driver)))

(script static boolean lakebghost_5_17
(and (volume_test_players vol_lake_a_bed) (any_players_in_vehicle)))

(script static boolean lakebpreve_5_18
 (volume_test_players vol_drive_lakedbed_a_end))

(script static boolean lakebghost_5_24
(>= (ai_task_status lakebed_a_covenant_obj/center_structure) 4))

(script static boolean lakebwrait_5_25
(any_players_in_vehicle))

(script static boolean lakebcente_5_27
(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0))

(script static boolean lakebtasks_5_32
(unleash_ground_wraith))

(script static boolean lakebghost_5_33
(and (volume_test_players vol_lakebed_a_bridge) (not (any_players_in_vehicle))))

(script static boolean lakebbansh_5_34
(>= (ai_task_count lakebed_a_allies/hornets_gate) 1))

(script static boolean factobugge_6_4
(>= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 1))

(script static boolean factowave0_6_5
(>= (device_get_position tank_room_b_exit02) .5))

(script static boolean factotasks_6_8
(<= (ai_task_count factory_b_cov_obj/inf) 0))

(script static boolean factotasks_6_11
(<= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 3))

(script static boolean factohog_a_6_12
(> (device_get_position factory_b_entry02) 0))

(script static boolean factobugge_7_2
(not (volume_test_players vol_factory_b_tunnel_end)))

(script static boolean factowave0_7_5
(volume_test_players vol_factory_b_tunnel))

(script static boolean factomarin_7_7
(<= (ai_living_count factory_b_allies_obj) 0))

(script static boolean factotasks_7_9
(not (volume_test_players vol_factory_b_center)))

(script static boolean factodwind_7_14
(volume_test_players vol_fab_entryroom))

(script static boolean factoplaye_7_15
(any_players_in_vehicle))

(script static boolean factodoor__7_16
(>= (device_get_position factory_b_entry02) 1))

(script static boolean lakebdumb__8_2
(not (volume_test_players vol_lakebed_b_ledge)))

(script static boolean lakebscara_8_3
(>= (ai_living_count scarab) 1))

(script static boolean lakebscara_8_5
g_scarab_dead)

(script static boolean lakebcov_d_8_7
(or (<= (ai_living_count lakebed_b_covenant_obj) 0) (>= (ai_living_count lakebed_b_pelicans01) 1)))

(script static boolean lakebpelic_8_9
(>= (ai_living_count scarab) 1))

(script static boolean lakebend_a_8_13
(volume_test_players vol_lakebed_b_end_advance))

(script static boolean lakebhorne_8_16
(<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0))

(script static boolean lakebhorne_8_17
(>= (ai_task_count lakebed_b_covenant_obj/phantoms) 1))

(script static boolean lakebhorne_8_20
(>= (ai_living_count scarab) 1))

(script static boolean lakebscara_8_22
(>= (object_buckling_magnitude_get scarab_giant) .2))

(script static boolean lakebdumb__9_7
(not (volume_test_players vol_lakebed_b_ledge)))

(script static boolean lakebtasks_9_13
(<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0))

(script static boolean lakebpart1_9_14
(>= (ai_living_count lakebed_b_pelicans01) 1))

(script static boolean lakebbansh_9_16
(>= (ai_living_count scarab) 1))

(script static boolean scaraleade_11_3
(volume_test_players vol_scarab))

(script static boolean scaracore__11_6
(volume_test_players vol_scarab_back))

(script static boolean officstart_12_1
(volume_test_players vol_office_start))

(script static boolean officstart_12_2
(volume_test_players vol_office_start02))

(script static boolean officstart_12_3
(volume_test_players vol_office_start03))

(script static boolean officarbit_12_8
(volume_test_players vol_office_start03))

(script static boolean ware_flank_13_1
(volume_test_players vol_warehouse_brute_flank))

(script static boolean ware_fallb_13_2
(volume_test_players vol_warehouse_brutes01))

(script static boolean ware_fallb_13_9
(not (volume_test_players vol_warehouse_brutes02b)))

(script static boolean ware_brute_13_12
(not (volume_test_players vol_warehouse_brutes01)))

(script static boolean ware_hunte_14_0
(volume_test_players vol_warehouse_hunters02))

(script static boolean ware_advan_14_3
(>= (ai_task_status ware_cov_obj/start) ai_task_status_exhausted))

(script static boolean ware_advan_14_4
(volume_test_players vol_warehouse_brutes02b))

(script static boolean ware_hunte_14_7
(<= (ai_living_count ware_cov_obj) 0))

(script static boolean ware_civ_h_14_9
(<= (device_get_position ware_exit_door) .5))

(script static boolean ware_civ_b_14_10
(<= (ai_task_count ware_cov_obj/ware_brute_gate) 0))

(script static boolean ware_comeb_14_11
(volume_test_players vol_warehouse_hunters01))

(script static boolean ware_comeb_14_13
(volume_test_players vol_warehouse_brutes02b))

(script static boolean ware_civ_3_14_14
(volume_test_players vol_warehouse_brutes02))

(script static boolean ware_low_i_14_15
(not (volume_test_players vol_warehouse_brutes01)))

(script static boolean ware_arbit_14_18
(>= (ai_task_status ware_cov_obj/start) ai_task_status_exhausted))

(script static boolean ware_arb_h_14_23
(<= (ai_living_count ware_cov_obj) 0))

(script static boolean workegrunt_15_1
(volume_test_players vol_worker_entry_side))

(script static boolean workefallb_15_2
(not (volume_test_players vol_worker_middle_start)))

(script static boolean workechief_15_4
(not (>= (ai_task_status worker_cov_obj/grunts) ai_task_status_exhausted)))

(script static boolean workechief_15_11
(or (<= (ai_strength work_cov_chief/chief) .5) (<= (ai_task_count worker_cov_obj/cov_inf) 3)))

(script static boolean workeadv01_16_1
(volume_test_players vol_worker_middle_start))

(script static boolean workecov_d_16_3
(<= (ai_living_count worker_cov_obj) 0))

(script static boolean workemiddl_16_4
(volume_test_players vol_worker_middle_start))

(script static boolean worketruth_16_5
(>= (object_get_health gravity_throne_worker) 1))

(script static boolean workecotan_16_6
(volume_test_players tv_cortana_03))

(script static boolean bfg_cgrunt_17_1
(volume_test_players vol_bfg_cov_left))

(script static boolean bfg_cgrunt_17_2
(volume_test_players vol_bfg_cov_right))

(script static boolean bfg_cphant_17_6
(volume_test_players vol_BFG_advance))

(script static boolean bfg_cbfg_d_17_8
(<= (object_get_health bfg_base) 0))

(script static boolean bfg_cinit_17_10
(not (volume_test_players vol_bfg_entry)))

(script static boolean bfg_cgrunt_17_15
(volume_test_players vol_bfg_cov_right02))

(script static boolean bfg_cgrunt_17_19
(not (volume_test_players vol_bfg_middle_hill)))

(script static boolean bfg_cbfg_d_17_26
(<= (object_get_health bfg_base) .3))

(script static boolean bfg_cbrute_17_28
(not (volume_test_players vol_bfg_brutes01)))

(script static boolean bfg_madvan_18_1
(volume_test_players vol_BFG_advance))

(script static boolean bfg_mgo_fo_18_2
(<= (ai_task_count bfg_cov_obj/inf_gate) 2))

(script static boolean bfg_msnipe_18_3
(volume_test_players vol_bfg_sniperstart))

(script static boolean bfg_msnipe_18_4
(>= (ai_task_status bfg_cov_obj/grunt_hill_front) ai_task_status_exhausted))

(script static boolean bfg_msnipe_18_5
(>= (ai_task_status bfg_cov_obj/grunt_hill) ai_task_status_exhausted))

(script static boolean bfg_mhill__18_6
(volume_test_players vol_bfg_middle_hill))

(script static boolean bfg_mshoot_18_8
(<= (ai_living_count bfg_cov01/chief) 0))

(script static boolean bfg_mdont__18_9
(<= (object_get_health bfg_base) .2))

