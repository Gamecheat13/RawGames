(script static boolean beachadvan_0_3
(volume_test_players vol_beach_area02_start))

(script static boolean beachadvan_0_4
(<= (ai_task_count beach_cov_obj/inf_gate) 3))

(script static boolean beachbeach_0_7
(>= (ai_living_count patha_pelican) 1))

(script static boolean beachfirst_0_11
g_tower1)

(script static boolean beachinit__0_13
(not (volume_test_players vol_beach_start)))

(script static boolean beachlink0_0_17
(volume_test_players vol_patha_hoglink01))

(script static boolean beachaa_de_0_18
(<= (ai_task_count beach_cov_obj/wraith_gate) 0))

(script static boolean beachhorne_0_22
(<= (ai_task_count beach_cov_obj/wraith_gate) 0))

(script static boolean beachlink0_0_25
(<= (ai_task_count beach_cov_obj/beach_taken_gate) 0))

(script static boolean beachback__0_27
(volume_test_players vol_patha_hoglink02))

(script static boolean beachback__0_28
(volume_test_players vol_patha_hoglink03))

(script static boolean beach01_ad_0_29
(volume_test_players vol_beach_first_center))

(script static boolean beach01cov_0_30
(<= (ai_task_count beach_cov_obj/inf_init_gate) 0))

(script static boolean beachinit__0_31
(volume_test_players vol_beach_marine_initadv))

(script static boolean beachshade_0_32
(<= (ai_task_count beach_cov_obj/shades) 0))

(script static boolean beachchief_0_33
(<= (ai_living_count beach_inf_cov04/beach_chief) 0))

(script static boolean beachhorne_0_34
(and (volume_test_players vol_cell_b_hornet_pickup) (not (any_players_in_vehicle))))

(script static boolean beachcreek_0_35
 (volume_test_players vol_beach_creekflank02))

(script static boolean beachhill__0_36
 (volume_test_players vol_beach_marine_hilladv))

(script static boolean beachcreek_0_37
(and (volume_test_players vol_beach_creekflank) (= (game_is_cooperative) TRUE)))

(script static boolean beachplaye_0_39
(cell_b_hornet_driver_test))

(script static boolean beachvehic_0_40
(and (volume_test_players vol_cell_b_hornet_pickup) (not (any_players_in_vehicle))))

(script static boolean beachhorne_0_41
(volume_test_players vol_cell_b_hornet_pickup))

(script static boolean beachbeach_0_43
(volume_test_players vol_patha_hoglink02))

(script static boolean beachinf_i_1_0
(not (volume_test_players vol_beach_creekflank)))

(script static boolean beachfirst_1_2
(<= (ai_living_count beach_inf_cov01_lead/first_brute) 0))

(script static boolean beachinf_i_1_3
(not  (volume_test_players vol_beach_area02_start)))

(script static boolean beachinf_i_1_6
(volume_test_players vol_beach_creekflank))

(script static boolean beachinf_i_1_14
(not (volume_test_players vol_beach_start)))

(script static boolean beachbansh_1_15
(volume_test_players vol_beach_area02_start))

(script static boolean beachbansh_1_18
(<= (ai_task_count beach_cov_obj/wraith_gate) 0))

(script static boolean beachbeach_1_20
(>= (ai_living_count patha_pelican) 1))

(script static boolean beachaa_de_1_23
(<= (ai_task_count beach_cov_obj/wraith_gate) 0))

(script static boolean beachshore_1_25
(volume_test_players vol_beach_shoreflank))

(script static boolean beachwrait_1_26
(>= (ai_task_count beach_marines_obj/hornet_gate) 1))

(script static boolean beachnolea_1_29
 (volume_test_players vol_beach_creekflank02))

(script static boolean beachchief_1_34
(not (volume_test_players vol_beach_area03_start)))

(script static boolean beachchief_1_35
(<= (ai_task_count beach_cov_obj/shades) 0))

(script static boolean beachbansh_1_36
(volume_test_players vol_beach_banshee_fight))

(script static boolean beachbansh_1_38
(<= (ai_task_count beach_cov_obj/beach_taken_gate) 0))

(script static boolean beachwrait_1_39
(<= (ai_living_count beach_inf_cov04/beach_chief) 0))

(script static boolean beachwrait_1_40
(volume_test_players vol_beach_area02_start))

(script static boolean cell_cente_3_1
(volume_test_players vol_cell_a_center))

(script static boolean cell_advan_3_3
(<= (ai_task_count cell_a_cov_obj/ground_vehicles) 0))

(script static boolean cell_advan_3_4
(and (<= (ai_task_count cell_a_cov_obj/low_gate) 0) (volume_test_players vol_cell_a_tunnel)))

(script static boolean cell_tower_3_6
g_tower1)

(script static boolean cell_enter_3_8
(and (not (any_players_in_vehicle)) (volume_test_players vol_cell_a_lockstart)))

(script static boolean cell_head__3_10
(any_players_in_vehicle))

(script static boolean cell_picku_3_11
(ai_player_any_needs_vehicle))

(script static boolean cell_not_p_3_16
(volume_test_players vol_cell_a_start))

(script static boolean cell_playe_3_18
(volume_test_players vol_cell_a_all))

(script static boolean cell_playe_3_20
(<= (ai_task_count cell_a_cov_obj/ground_vehicles) 2))

(script static boolean cell_vehic_3_21
(volume_test_players vol_cell_a_vehicle_adv))

(script static boolean cell_ghost_4_0
(not (volume_test_players vol_cell_a_center)))

(script static boolean cell_dumb__4_8
(not (volume_test_players vol_cell_a_start)))

(script static boolean cell_tasks_4_10
(<= (ai_task_count cell_a_cov_obj/wraith) 0))

(script static boolean cell_ghost_4_11
(volume_test_players vol_cell_a_ghostguard))

(script static boolean cell_playe_4_13
(volume_test_players vol_cell_a_tunnel))

(script static boolean cell_vehic_4_14
(<= (ai_task_count cell_a_cov_obj/wraith) 0))

(script static boolean lock_floor_5_0
(volume_test_players vol_lock_a01b_start))

(script static boolean lock_03_5_1
g_tower1)

(script static boolean lock_03_fo_5_2
(volume_test_players vol_lock_a03_follow))

(script static boolean lock_back__5_3
(> (device_get_position tower1_elevator) 0))

(script static boolean lock_right_5_5
(volume_test_players vol_core_a01_right))

(script static boolean lock_left_5_6
(volume_test_players vol_core_a01_left))

(script static boolean lock_end_5_7
(volume_test_players vol_core_a01_end))

(script static boolean lock_back__5_8
(>= (ai_combat_status lock_a_cov_obj) 4))

(script static boolean lock_floor_5_9
(volume_test_players vol_lock_a01b_backhall))

(script static boolean lock_see_y_5_10
(<= (ai_task_count lock_a_cov_obj/floor01b_gate) 0))

(script static boolean lock_left_6_2
(volume_test_players vol_core_a01_left))

(script static boolean lock_right_6_3
(volume_test_players vol_core_a01_right))

(script static boolean lock_core__6_6
(not (or (volume_test_players vol_core_a01_right) (volume_test_players vol_core_a01_left))))

(script static boolean lock_end_6_7
(volume_test_players vol_core_a01_end))

(script static boolean lock_floor_6_13
(volume_test_players vol_lock_a01b_start))

(script static boolean lock_b_lea_6_15
(not (volume_test_players vol_lock_a01b_backhall)))

(script static boolean lock_01b_g_6_16
(not (volume_test_players vol_lock_a01b_backhall)))

(script static boolean lock_snipe_6_18
(volume_test_players vol_core_a01_right))

(script static boolean lock_03_ga_6_24
g_tower1)

(script static boolean lock_back__6_27
(> (device_get_position tower1_elevator) 0))

(script static boolean lock_01b_j_6_28
(not (volume_test_players vol_lock_a01b_end)))

(script static boolean lock_bypas_6_31
(volume_test_players vol_lock_a01_bypass))

(script static boolean cell_tasks_8_4
(= (current_zone_set) 5))

(script static boolean cell_tasks_8_5
(= (current_zone_set) 5))

(script static boolean cell_horne_8_7
(player_needs_vehicle_on_island))

(script static boolean cell_horne_8_8
(and (ai_player_any_needs_vehicle) (volume_test_players vol_cell_b_island)))

(script static boolean cell_horne_8_9
(and (ai_player_any_needs_vehicle) (volume_test_players vol_cell_b_towerclear)))

(script static boolean cell_bansh_9_6
(not (volume_test_players vol_cell_b_halfway)))

(script static boolean cell_brute_9_12
(or (volume_test_players vol_cell_b_island) (<= (object_get_health (ai_vehicle_get_from_starting_location cell_b_aa01/driver01)) 0)))

(script static boolean cell_bansh_9_13
(player_needs_vehicle_on_island))

(script static boolean cell_tower_10_1
g_tower3)

(script static boolean cell_frien_10_2
(<= (ai_living_count cell_c_cov_obj) 0))

(script static boolean cell_scorp_10_6
(volume_test_objects vol_cell_c_tankvol (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01)))

(script static boolean cell_horne_10_13
(volume_test_players vol_cell_c_airfall))

(script static boolean cell_air_c_10_14
(<= (ai_task_count cell_c_cov_obj/air_gate) 0))

(script static boolean cell_brute_10_17
(>= (ai_task_status cell_c_cov_obj/brute_fallback) ai_task_status_exhausted))

(script static boolean cell_playe_10_18
(not (any_players_in_vehicle)))

(script static boolean cell_speli_10_19
(<= (ai_task_count cell_c_cov_obj/air_gate) 0))

(script static boolean cell_pelic_10_20
(<= (ai_task_count cell_c_cov_obj/air_gate) 0))

(script static boolean cell_marin_10_25
(<= (ai_task_count cell_c_marines_obj/elites_inside) 2))

(script static boolean cell_going_10_26
(volume_test_players vol_cell_c_ext01))

(script static boolean cell_tasks_10_27
(<= (ai_living_count cell_c_aa) 0))

(script static boolean cell_tasks_10_28
(<= (ai_living_count cell_c_aa) 0))

(script static boolean cell_arbit_10_32
(= (current_zone_set) 9))

(script static boolean cell_ext_e_10_33
false)

(script static boolean cell_ext_g_11_0
g_tower3)

(script static boolean cell_bansh_11_13
(volume_test_players vol_cell_c_airfall))

(script static boolean cell_tasks_11_14
(volume_test_players vol_cell_c_airfall))

(script static boolean cell_tasks_11_15
(volume_test_players vol_cell_c_airfall))

(script static boolean cell_ext01_12_1
(volume_test_players vol_cell_c_ext01))

(script static boolean lock_bugge_13_4
(volume_test_players vol_lock_c01_right))

(script static boolean lock_bugge_13_6
(not (volume_test_players vol_lock_c_start)))

(script static boolean lock_hunte_13_7
(volume_test_players vol_lock_c01_right))

(script static boolean lock_hunte_13_10
(volume_test_players vol_lock_c01_back))

(script static boolean lock_bugge_13_13
(volume_test_players vol_lock_c01_left))

(script static boolean lock_grunt_13_15
(volume_test_players vol_lock_c01_back))

(script static boolean lock_hunte_13_16
(volume_test_players vol_lock_c01_left))

(script static boolean lock_c02_g_13_17
(volume_test_players vol_lock_c01b_start))

(script static boolean lock_bugge_13_20
(volume_test_players vol_lock_c01b_bugger_end))

(script static boolean lock_fallb_13_22
(or (volume_test_players vol_lock_c01b_bypass) (volume_test_players vol_lock_c01b_backhall)))

(script static boolean lock_tower_13_23
g_tower3)

(script static boolean lock_1hunt_13_25
(<= (ai_task_count lock_c_cov_obj/hunter_gate) 1))

(script static boolean lock_tasks_14_3
(volume_test_players vol_lock_c02_saves))

(script static boolean lock_follo_17_1
(volume_test_players vol_lock_c04_floor))

(script static boolean lock_tower_17_2
g_tower3)

(script static boolean lock_follo_17_4
(volume_test_players vol_lock_c01b_start))

(script static boolean lock_left_17_5
(not (volume_test_players vol_lock_c01_right)))

(script static boolean lock_right_17_6
(not (volume_test_players vol_lock_c01_left)))

(script static boolean lock_back_17_7
(volume_test_players vol_lock_c01_back))

(script static boolean lock_adv_g_17_8
(volume_test_players vol_lock_c_start))

(script static boolean lock_back__17_9
(> (device_get_position tower3_elevator) 0))

(script static boolean lock_see_y_17_11
(<= (ai_living_count lock_c_cov_obj) 0))

(script static boolean lock_tower_17_12
(volume_test_players vol_lock_c04_floor))

(script static boolean path_ice_m_19_2
(and (volume_test_players vol_ice_middle) (>= (ai_living_count path_b_cov) 1)))

(script static boolean tank_hog_a_20_5
(volume_test_players vol_tankrun_turn02))

(script static boolean tank_hog_a_20_6
(volume_test_players vol_tankrun_turn03))

(script static boolean tank_tank__20_7
(volume_test_players vol_tankrun_turn02))

(script static boolean tank_tank__20_8
(volume_test_players vol_tankrun_turn03))

(script static boolean tank_playe_20_9
(ai_player_any_needs_vehicle))

(script static boolean tank_cov_d_20_11
(and (volume_test_players vol_tankrun_turn03) (<= (ai_task_count tank_cov_obj/wraith_gate) 0)))

(script static boolean tank_playe_20_12
(<= (ai_task_count tank_cov_obj/ghost_gate) 0))

(script static boolean tank_playe_20_13
(<= (object_get_health (ai_vehicle_get_from_starting_location tank_cov_wraiths01/driver01)) 0))

(script static boolean tank_ridge_20_14
(volume_test_players vol_crater_hornet_drop))

(script static boolean tank_tank__20_15
(and (volume_test_object vol_tankrun_turn03 (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01)) (<= (ai_task_count tank_cov_obj/wraith_gate) 0)))

(script static boolean tank_ridge_21_0
(not (volume_test_players vol_tankrun_turn03)))

(script static boolean tank_bansh_21_2
(not (volume_test_players vol_tankrun_turn03)))

(script static boolean tank_phant_21_13
(volume_test_players vol_tankrun_turn03))

(script static boolean tank_ghost_21_16
(not (volume_test_players vol_tankrun_turn02)))

(script static boolean tank_wrait_21_17
(not (volume_test_players vol_tank_wraith_low_cs)))

(script static boolean cratescara_22_8
(>= (ai_task_count scarabs_obj/left) 1))

(script static boolean cratescara_22_9
(>= (ai_task_count scarabs_obj/right) 1))

(script static boolean crateplaye_22_10
(ai_player_any_needs_vehicle))

(script static boolean cratearbit_22_11
(and (> (device_get_position citadel_entry_door01) 0) (volume_test_players vol_crater_end01)))

(script static boolean cratearbit_22_12
(>= (ai_living_count crater_arbiter) 1))

(script static boolean cratehorne_22_13
(crater_hornet_driver_test))

(script static boolean crateplaye_22_15
(or (volume_test_players vol_scarab01_top) (volume_test_players vol_scarab02_top)))

(script static boolean cratehorne_22_18
(ai_player_any_needs_vehicle))

(script static boolean cratecrate_22_19
(>= (ai_living_count crater_arbiter) 1))

(script static boolean crateghost_23_3
(>= (ai_living_count scarabs_obj) 2))

(script static boolean crateplaye_23_6
(any_players_in_vehicle))

(script static boolean cratewrait_23_8
(<= (ai_task_count crater_cov_obj/wraith_gate) 2))

(script static boolean cratebansh_23_13
(<= (ai_task_count crater_marines_obj/hornets) 0))

(script static boolean cratebansh_23_15
(<= (ai_living_count scarabs_obj) 0))

(script static boolean cratebansh_23_16
(volume_test_players vol_crater_main))

(script static boolean scara1dead_24_2
(<= (ai_living_count scarabs_obj) 2))

(script static boolean ring_move0_27_1
(volume_test_players vol_ring01_back))

(script static boolean ring_exit_27_2
g_truthdead)

(script static boolean ring_infec_28_0
(volume_test_players vol_ring01_start))

(script static boolean ring_ring0_28_6
(volume_test_players vol_ring01_back))

(script static boolean ring_flood_28_7
(<= (ai_living_count ring_cov_obj) 2))

(script static boolean ring_flood_28_8
(volume_test_players vol_ring01_back))

(script static boolean ring_no_ta_28_9
(>= (ai_task_count ring_cov_obj/part01_fallback02) 1))

(script static boolean ring_truth_28_12
g_truthdead)

(script static boolean ring_tasks_28_14
(volume_test_players vol_ringex01_init))

(script static boolean ring_tasks_28_15
(volume_test_players vol_ringex01_halfway))

(script static boolean ring_leade_29_0
(not (volume_test_players vol_ring01_back)))

(script static boolean ring0comba_30_0
(volume_test_players vol_ringex01_halfway))

(script static boolean ring0tasks_30_4
(volume_test_players vol_ringex01_halfway))

(script static boolean ring0brute_32_1
(volume_test_players vol_ring02_start))

(script static boolean ring0truth_33_1
g_truthdead)

(script static boolean ring0ring0_34_2
(volume_test_players vol_ring02_start))

(script static boolean ring0ring0_34_3
(volume_test_players vol_ring02_middle))

(script static boolean ring0ring0_34_4
(volume_test_players vol_ring02_back))

(script static boolean ring0truth_34_6
g_truthdead)

(script static boolean ring0no_ta_34_13
(>= (ai_task_status ring02_cov_obj/brute_jetpacks_init) ai_task_status_exhausted))

(script static boolean ring0no_ta_34_14
(>= (ai_task_status ring02_cov_obj/brute_jetpacks_init) ai_task_status_exhausted))

(script static boolean ring0tasks_34_15
(volume_test_players vol_ring03_init))

(script static boolean ring0tasks_34_16
(volume_test_players vol_ringex02_halfway))

(script static boolean ring0tasks_34_17
(volume_test_players vol_ringex02_halfway02))

(script static boolean ring0no_ta_34_18
(volume_test_players vol_ring02_middle))

(script static boolean ring0flood_34_19
(volume_test_players vol_ring02_middle))

(script static boolean ring0dumb_35_1
(not (volume_test_players vol_ringex02_init)))

(script static boolean ring0truth_35_2
g_truthdead)

(script static boolean ring0adv_35_3
(volume_test_players vol_ringex02_fore_adv))

(script static boolean ring0truth_36_1
g_truthdead)

(script static boolean ring0tasks_36_2
(volume_test_players vol_ringex03_halfway))

(script static boolean ring0comba_37_1
(volume_test_players vol_ringex03_start))

(script static boolean ring_arbit_41_0
(volume_test_players vol_ringex01_elevator_start))

