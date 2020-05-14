(script static boolean obj_1adv_0_0
(not (volume_test_players tv_1stbowl_wildlife02)))

(script static boolean obj_atasks_1_2
(volume_test_players vol_meadow_quartway))

(script static boolean obj_atasks_1_3
(volume_test_players vol_meadow_quartway))

(script static boolean obj_atasks_1_4
(volume_test_players vol_meadow_halfway))

(script static boolean obj_atasks_1_5
(volume_test_players vol_meadow_halfway))

(script static boolean obj_ameado_2_0
(volume_test_players vol_meadow_quartway))

(script static boolean obj_atasks_2_4
(volume_test_players vol_meadow_start02))

(script static boolean obj_1gate__3_0
(volume_test_players vol_1stbowl_kiva01))

(script static boolean obj_1gate__3_2
(>= g_1stbowl_obj_control 30))

(script static boolean obj_1beaco_3_4
(volume_test_players tv_1stbowl_gas))

(script static boolean obj_1gate__3_6
warthog_done)

(script static boolean obj_1gate__3_15
(>= g_1stbowl_obj_control 20))

(script static boolean obj_1gate__3_18
(volume_test_players tv_1stbowl_witnesses))

(script static boolean obj_1tasks_3_20
(volume_test_players tv_1stbowl_adv02))

(script static boolean obj_1tasks_3_21
(volume_test_players tv_1stbowl_adv02))

(script static boolean obj_1tasks_3_22
(volume_test_players tv_1stbowl_adv01))

(script static boolean obj_1tasks_3_23
(volume_test_players tv_1stbowl_adv01))

(script static boolean obj_1tasks_3_24
(volume_test_players tv_1stbowl_adv03))

(script static boolean obj_1gate__3_25
beacon_done)

(script static boolean obj_1gt_wi_3_33
(volume_test_players tv_1stbowl_wildlife))

(script static boolean obj_1side__3_35
(volume_test_players tv_1stbowl_cliffside))

(script static boolean obj_1sprin_3_36
(volume_test_players tv_training_sprint))

(script static boolean obj_1playe_3_38
(= g_1stbowl_obj_control 99))

(script static boolean obj_bspart_5_0
(volume_test_players tv_barn_combat02))

(script static boolean obj_bbodie_5_1
(volume_test_players vol_barn_start))

(script static boolean obj_bbodie_5_2
(volume_test_players vol_barn_start02))

(script static boolean obj_bgate__5_3
(volume_test_players tv_barn_bloodtrail03))

(script static boolean obj_bbarn__5_4
(volume_test_players vol_barn_courtyard))

(script static boolean obj_bgate__5_11
(<= (ai_task_count obj_barn_cov/gate_barn_main) 0))

(script static boolean obj_bspart_5_12
(<= (ai_task_count obj_barn_cov/overlook_inf) 0))

(script static boolean obj_btasks_5_13
(>= (ai_task_count obj_barn_cov/overlook_fallback01) 1))

(script static boolean obj_bemile_5_15
(volume_test_objects tv_barn_window_view obj_emile))

(script static boolean obj_bgate__5_16
(game_is_cooperative))

(script static boolean obj_blower_6_1
(not (volume_test_players vol_barn_lower01)))

(script static boolean obj_bgate__6_2
(volume_test_players tv_barn_combat02))

(script static boolean obj_belite_6_7
(volume_test_players vol_barn_courtyard02))

(script static boolean obj_bgrunt_6_10
(volume_test_players tv_barn_combat02))

(script static boolean obj_belite_6_11
(volume_test_players tv_barn_main))

(script static boolean obj_belite_6_12
(volume_test_players tv_barn_combat02))

(script static boolean obj_boverl_6_13
(not (volume_test_players tv_barn_end)))

(script static boolean obj_bgate__6_15
 (volume_test_players vol_barn_lower01))

(script static boolean obj_boverl_6_18
(not (volume_test_players tv_barn_end)))

(script static boolean obj_bsidef_6_22
 (volume_test_players tv_barn_lower_sideflank))

(script static boolean obj_mplaye_7_1
(volume_test_players vol_meadow_exit))

(script static boolean obj_mlead_7_2
(volume_test_players tv_meadow_river01))

(script static boolean obj_mlead__7_3
(volume_test_players vol_meadow_quartway))

(script static boolean obj_mlead__7_4
(volume_test_players vol_meadow_halfway))

(script static boolean obj_mlead__7_5
(<= (ai_task_count obj_meadow_cov/gate_meadow_front) 0))

(script static boolean obj_mcarte_7_6
(<= (ai_living_count obj_meadow_cov) 0))

(script static boolean obj_mjorge_7_7
(<= (ai_living_count obj_meadow_cov) 0))

(script static boolean obj_mkat_e_7_10
(>= (ai_living_count meadow_falcon02) 1))

(script static boolean obj_memile_7_11
(>= (ai_living_count meadow_falcon02) 1))

(script static boolean obj_mjorge_7_12
(and (>= (ai_living_count meadow_falcon02) 1) (not (<= (game_coop_player_count) 3))))

(script static boolean obj_melite_7_13
(>= (ai_task_status obj_meadow_cov/meadow_elite_init) ai_task_status_exhausted))

(script static boolean obj_mcov01_8_0
(not (volume_test_players vol_meadow_quartway)))

(script static boolean obj_mtasks_8_3
(< (ai_combat_status obj_meadow_cov)  ai_combat_status_definite))

(script static boolean obj_mfinal_8_5
(<= (ai_task_count obj_meadow_cov/gate_meadow_front) 3))

(script static boolean obj_mcov_f_8_6
(volume_test_players tv_meadow_cov_fallback))

(script static boolean obj_mbackl_8_11
(volume_test_players tv_meadow_backleft))

(script static boolean obj_mfront_8_12
(volume_test_players tv_meadow_middleright))

(script static boolean obj_mback__8_13
(volume_test_players tv_meadow_middleright))

(script static boolean obj_mmeado_8_15
(volume_test_players vol_meadow_exit))

(script static boolean obj_mcov_i_8_17
(not (volume_test_players tv_meadow_adv01)))

(script static boolean obj_mmeado_8_21
(volume_test_players tv_meadow_middleright))

(script static boolean obj_mfreak_9_0
(volume_test_players tv_wildlife_meadow))

(script static boolean obj_3vehic_10_1
(spartans_allowed_in_pickup))

(script static boolean obj_3picku_10_2
(volume_test_players_all tv_3kiva_start02))

(script static boolean obj_3carte_10_3
(and (not 3kiva01_done) (< 3kiva_troopers_bsp 2)))

(script static boolean obj_3gate__10_4
(carter_driving_pickup))

(script static boolean obj_3carte_10_5
(not 3kiva02_done))

(script static boolean obj_3carte_10_6
(not 3kiva03_done))

(script static boolean obj_3foot__10_7
(and (volume_test_object vol_3kiva01_approach02 obj_carter) 3kiva01_done))

(script static boolean obj_33kiva_10_8
(volume_test_objects tv_3kiva_pickup_start obj_carter))

(script static boolean obj_3perim_11_3
(not (= 3kiva_troopers_bsp 3)))

(script static boolean obj_33kiva_11_4
(not (volume_test_players tv_3kiva_cov01)))

(script static boolean obj_33kiva_11_7
(not 3kiva01_done))

(script static boolean obj_33kiva_11_8
(not (volume_test_players tv_3kiva_cov02)))

(script static boolean obj_3tasks_11_11
 3kiva01_done)

(script static boolean obj_3bob02_11_13
(volume_test_players vol_3kiva_2bsp))

(script static boolean obj_3bob03_11_14
(volume_test_players vol_3kiva_3bsp))

(script static boolean obj_3bob01_11_15
(volume_test_players vol_3kiva01_entry_right))

(script static boolean obj_3kiva0_12_2
(volume_test_players vol_3kiva_2bsp))

(script static boolean obj_3kiva0_12_3
(volume_test_players vol_3kiva_3bsp))

(script static boolean obj_3gate__12_4
3kiva_done)

(script static boolean obj_3kiva0_12_5
(volume_test_players vol_3kiva_1bsp))

(script static boolean obj_3kiva0_12_6
(volume_test_players vol_3kiva_2bsp))

(script static boolean obj_3kiva0_12_7
(volume_test_players vol_3kiva_3bsp))

(script static boolean obj_33kiva_12_8
(vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" (players)))

(script static boolean obj_3tasks_13_1
(volume_test_players vol_3kiva_1bsp))

(script static boolean obj_3tasks_13_2
(or (volume_test_players vol_3kiva_2bsp) (volume_test_players vol_3kiva_3bsp)))

(script static boolean obj_3tasks_13_4
(volume_test_players tv_3kiva_exit_area))

(script static boolean obj_3tasks_13_5
(volume_test_players vol_3kiva_2bsp))

(script static boolean obj_3tasks_13_6
(volume_test_players vol_3kiva_3bsp))

(script static boolean obj_33kiva_13_8
(= 3kiva_troopers_bsp 2))

(script static boolean obj_3tasks_13_9
(= 3kiva_troopers_bsp 3))

(script static boolean obj_33kiva_13_10
(volume_test_players vol_3kiva_2bsp))

(script static boolean obj_3tasks_13_12
(= 3kiva_jun_bsp 2))

(script static boolean obj_3tasks_13_13
(= 3kiva_jun_bsp 3))

(script static boolean obj_3tasks_14_3
(<= (ai_living_count obj_3kiva01c_cov) 3))

(script static boolean obj_3tasks_15_0
3kiva_troopers_spoted)

(script static boolean obj_3tasks_15_2
3kiva_done)

(script static boolean obj_3meet_15_3
(= g_3kiva_obj_control 2))

(script static boolean obj_3tasks_16_1
(<= (ai_living_count obj_3kiva02_cov) 5))

(script static boolean obj_3tasks_16_5
(not (volume_test_players vol_3kiva02_approach02)))

(script static boolean obj_3tasks_16_10
3kiva_troopers_spoted)

(script static boolean obj_3perim_16_13
3kiva_done)

(script static boolean obj_3playe_17_1
(any_players_in_vehicle))

(script static boolean obj_3evac_17_2
3kiva_done)

(script static boolean obj_3carte_17_3
(<= (objects_distance_to_object cr_3kiva_hogsite02 (ai_get_object group_carter)) 12))

(script static boolean obj_3gate__17_4
3kiva_troopers_found)

(script static boolean obj_3jorge_17_5
(<= (objects_distance_to_object cr_3kiva_hogsite02 (ai_get_object group_jorge)) 12))

(script static boolean obj_3clean_17_6
(and (<= (ai_living_count obj_3kiva02_cov) 5) (>= g_3kiva_obj_control 3)))

(script static boolean obj_3playe_18_0
3kiva_troopers_spoted)

(script static boolean obj_3evac_18_2
3kiva_done)

(script static boolean obj_3meet_18_3
(= g_3kiva_obj_control 2))

(script static boolean obj_3inf02_19_1
(<= (ai_living_count obj_3kiva03_cov) 5))

(script static boolean obj_3perim_19_11
3kiva_done)

(script static boolean obj_3playe_20_1
(any_players_in_vehicle))

(script static boolean obj_3evac_20_2
3kiva_done)

(script static boolean obj_3gate__20_3
3kiva_troopers_found)

(script static boolean obj_3carte_20_4
(<= (objects_distance_to_object cr_3kiva_hogsite03 (ai_get_object group_carter)) 12))

(script static boolean obj_3jorge_20_5
(<= (objects_distance_to_object cr_3kiva_hogsite03 (ai_get_object group_jorge)) 12))

(script static boolean obj_3clean_20_6
(and (<= (ai_living_count obj_3kiva03_cov) 5) (>= g_3kiva_obj_control 3)))

(script static boolean obj_ofallt_21_4
(<= (ai_task_count obj_outpost_ext_cov/gate_inf) 4))

(script static boolean obj_ogate__21_5
(volume_test_players tv_outpost_ext_control))

(script static boolean obj_odoor__21_7
(<= (device_get_position dm_outpost_blastdoor) .6))

(script static boolean obj_oplaye_21_13
(unit_in_vehicle_type player0 20))

(script static boolean obj_ounder_21_14
(volume_test_players tv_outpost_ext_underside))

(script static boolean obj_ospart_22_0
(>= g_outpost_ext_obj_control 20))

(script static boolean obj_ojorge_22_2
(>= g_outpost_ext_obj_control 12))

(script static boolean obj_ocarte_22_4
(>= g_outpost_ext_obj_control 12))

(script static boolean obj_ospart_22_6
(>= g_outpost_ext_obj_control 12))

(script static boolean obj_ospart_22_8
(>= g_outpost_ext_obj_control 40))

(script static boolean obj_ocarte_22_9
(volume_test_players vol_outpost_ext_advance))

(script static boolean obj_ojorge_22_10
(volume_test_players vol_outpost_ext_advance))

(script static boolean obj_ogate__23_1
(volume_test_players vol_outpost_int_back02))

(script static boolean obj_oelite_23_4
(not (volume_test_players vol_outpost_int_start02)))

(script static boolean obj_oelite_23_5
(volume_test_players vol_outpost_int_rear))

(script static boolean obj_ogate__23_6
(volume_test_players vol_outpost_int_back01))

(script static boolean obj_oinit__23_14
(not (volume_test_players vol_outpost_int_rear02)))

(script static boolean obj_obackh_23_16
(volume_test_players tv_outpost_int_back03))

(script static boolean obj_oelite_23_17
(outpost_int_elite_back_prep))

(script static boolean obj_osidef_23_20
(volume_test_players_all tv_outpost_int_sideflank))

(script static boolean obj_ofight_24_1
(volume_test_players vol_outpost_int_back_hall01))

(script static boolean obj_oadv01_24_2
(>= (ai_task_status obj_outpost_int_cov/fallback2) ai_task_status_exhausted))

(script static boolean obj_oadv02_24_3
(volume_test_players vol_outpost_int_back01))

(script static boolean obj_otasks_24_4
(<= (ai_living_count obj_outpost_int_cov) 3))

(script static boolean obj_oserve_24_5
(volume_test_players vol_outpost_int_server01))

(script static boolean obj_oadv03_24_6
(<= (ai_task_count obj_outpost_int_cov/gate_back_hall) 0))

(script static boolean obj_ogate__24_7
(volume_test_players vol_outpost_combat))

(script static boolean obj_3adv01_26_1
(volume_test_players tv_3kiva_wildlife01))

(script static boolean obj_3tasks_26_4
(volume_test_players tv_3kiva_wildlife05))

(script static boolean obj_3tasks_26_5
(volume_test_players tv_3kiva_wildlife02))

(script static boolean obj_3tasks_26_6
(volume_test_players tv_3kiva_wildlife05b))

(script static boolean obj_3troop_26_7
(and (= 3kiva_troopers_bsp 3) 3kiva_troopers_spoted))

(script static boolean obj_3troop_26_8
(and (= 3kiva_troopers_bsp 2) 3kiva_troopers_spoted))

(script static boolean obj_3troop_26_9
(= g_wildlife_control 2))

(script static boolean obj_3troop_26_10
(= g_wildlife_control 2))

(script static boolean obj_3tasks_26_14
(volume_test_players tv_3kiva_wildlife04b))

(script static boolean obj_3tasks_26_15
(volume_test_players tv_3kiva_wildlife04))

(script static boolean obj_1go_in_27_3
(>= g_1stbowl_obj_control 3))

