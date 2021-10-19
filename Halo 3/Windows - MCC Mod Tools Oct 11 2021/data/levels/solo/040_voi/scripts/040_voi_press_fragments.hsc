(script static boolean introarriv_0_2
(volume_test_players vol_drive_intro_end))

(script static boolean introarriv_0_4
(= wave 2))

(script static boolean introhonor_0_6
(= wave 1))

(script static boolean introguard_0_7
(volume_test_players vol_faa))

(script static boolean factotank__1_3
(> (device_get_position factory_a_middle) 0))

(script static boolean factorambo_1_5
(volume_test_players vol_tank_room_a_exit))

(script static boolean factoadvan_1_6
(>= (ai_living_count factory_a_covenant_obj/big_fallback) 1))

(script static boolean factoadvan_1_7
(>= (ai_living_count factory_a_covenant_obj/big_fallback02) 1))

(script static boolean factofollo_1_8
(<= (ai_living_count factory_a_covenant_obj) 0))

(script static boolean factoroom__1_9
(<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 2))

(script static boolean factofinis_1_10
(<= (ai_living_count factory_a_covenant_obj) 0))

(script static boolean factotank__2_3
(>= (device_get_position factory_a_middle) .75))

(script static boolean factofacto_2_10
(>= (device_get_power factory_a_entry02_switch) 1))

(script static boolean factofacto_2_12
(not (volume_test_players vol_faa)))

(script static boolean lakebcente_3_2
(<= (ai_living_count lake_a_cov_center) 0))

(script static boolean lakebcente_3_3
(<= (ai_living_count lake_a_cov_center) 2))

(script static boolean lakebgauss_4_4
(or (volume_test_players vol_lakebed_a_high_start)  (volume_test_players  vol_lake_a_bed)))

(script static boolean lakebcente_4_6
(>= (ai_task_status lakebed_a_covenant_obj/center_structure) 4))

(script static boolean lakebwin_g_4_9
(<= (ai_living_count lakebed_a_covenant_obj) 2))

(script static boolean lakebend_g_4_11
(>= (ai_living_count lakebed_a_end_phantom) 1))

(script static boolean lakebgauss_4_16
(volume_test_players vol_lake_a_bed))

(script static boolean lakebgauss_4_17
(> (device_get_position lakebed_a_entry_door) .9))

(script static boolean lakebphant_5_5
(volume_test_players vol_lakebed_a_end))

(script static boolean lakebwrait_5_7
(volume_test_players vol_lakebed_a_bridge))

(script static boolean lakebwrait_5_9
(or (volume_test_players vol_lakebed_a_end) (<= (ai_task_count lakebed_a_covenant_obj/ghosts02) 1)))

(script static boolean lakebcente_5_10
(>= (ai_task_status lakebed_a_covenant_obj/center_structure) 4))

(script static boolean lakebwaith_5_12
(>= (ai_task_count lakebed_a_covenant_obj/center_cap_ghosts03) 3))

(script static boolean lakebghost_5_20
(volume_test_object vol_lakebed_a_troop_init (ai_vehicle_get_from_starting_location intro_hog/driver)))

(script static boolean lakebghost_5_23
(and (volume_test_players vol_lake_a_bed) (any_players_in_vehicle)))

(script static boolean lakebpreve_5_24
 (volume_test_players vol_drive_lakedbed_a_end))

(script static boolean lakebwrait_5_28
(marine_waste_true))

(script static boolean factowave0_6_3
(= wave 1))

(script static boolean factowave0_6_4
(= wave 2))

(script static boolean factowave0_6_6
(= wave 3))

(script static boolean factowave0_6_8
(= wave 4))

(script static boolean factowave0_6_9
(= wave 5))

(script static boolean factoentry_7_4
(volume_test_players vol_factory_b_center))

(script static boolean factowave0_7_5
(= wave 1))

(script static boolean factowave0_7_6
(= wave 3))

(script static boolean factowave0_7_9
(= wave 5))

(script static boolean factowave0_7_16
(= wave 2))

(script static boolean factowave0_7_21
(= wave 4))

(script static boolean factowave0_7_22
(volume_test_players vol_factory_b_tunnel))

(script static boolean factocomba_7_23
(volume_test_players vol_factory_b_tunnel))

(script static boolean lakeboutsi_8_2
(and (<= (ai_living_count lakebed_b_covenant_obj) 1) (<= (ai_living_count scarab) 1)))

(script static boolean lakebdumb__8_3
(not (volume_test_players vol_lakebed_b_ledge)))

(script static boolean lakebscara_8_4
(>= (ai_living_count scarab) 1))

(script static boolean lakebscara_8_6
(<= (ai_living_count scarab) 0))

(script static boolean lakebdumb__9_7
(not (volume_test_players vol_lakebed_b_ledge)))

(script static boolean lakebback__9_12
(= wave (- waveMax 1)))

(script static boolean lakebback__9_14
(not (volume_test_players vol_scarab_crane_left)))

(script static boolean lakebback__9_15
(not (volume_test_players vol_scarab_crane_right)))

(script static boolean lakebinf_f_9_17
(>= wave waveMax))

(script static boolean ware_cente_11_6
(volume_test_players vol_warehouse_brutes02))

(script static boolean ware_enter_11_9
(volume_test_players vol_warehouse_hunters01))

(script static boolean ware_advan_12_2
(volume_test_players vol_warehouse_brutes02))

(script static boolean ware_hunte_12_3
(volume_test_players vol_warehouse_hunters01))

