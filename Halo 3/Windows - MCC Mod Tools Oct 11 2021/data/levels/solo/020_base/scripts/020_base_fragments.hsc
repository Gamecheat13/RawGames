(script static boolean cave_door__0_1
(= (device_get_position cave_a_door_hallway02) 1))

(script static boolean hangatop_a_1_2
(< var_hangar_a_pos 2))

(script static boolean hangatop_l_1_3
(<= var_hangar_a_pos 1))

(script static boolean hangatop_r_1_6
(<= var_hangar_a_pos 1))

(script static boolean hangafall__1_11
(= var_hangar_a_pos 4))

(script static boolean hangamid_t_2_0
(<= var_hangar_a_pos 1))

(script static boolean hangamiddl_2_2
(= var_hangar_a_pos 2))

(script static boolean hangalower_2_3
(volume_test_players hangar_a_front_fallback_trig))

(script static boolean hangacontr_2_4
(and (= var_hangar_a_pos 0) (>= (ai_living_count hangar_a_cov_assaulting) 1)))

(script static boolean hangacontr_2_5
(and (= var_hangar_a_pos 0) (>= (ai_living_count hangar_a_cov_assaulting) 1)))

(script static boolean hangalandi_2_7
(>= var_hangar_a_pos 3))

(script static boolean evac_evac__3_0
(= landing_pad_start FALSE))

(script static boolean evac_eleva_3_1
(> (device_get_position evac2_elev_switch01) 0))

(script static boolean evac_eleva_3_2
(= (device_get_position evac02_elev_bottom) 1))

(script static boolean evac_landi_3_3
(= landing_pad_start TRUE))

(script static boolean evac_landi_3_4
(= landing_pad_start TRUE))

(script static boolean evac_pelic_3_5
(= var_evac_hangar_pos 3))

(script static boolean evac_eleva_3_6
(> (device_get_position elevator_evac_02) 0))

(script static boolean evac_barra_3_8
(= (device_get_position barracks_evac_hangar_door) 0))

(script static boolean evac_marin_3_9
(<= (ai_living_count evac_hangar_cov_wave01) 2))

(script static boolean evac_init_4_2
(< var_evac_hangar_pos 1))

(script static boolean motorbrute_6_1
(< var_motor_pool_pos 3))

(script static boolean motorup_to_6_4
(volume_test_players motor_pool_upper_trigger))

(script static boolean motorchief_6_5
(= var_motor_pool_pos 4) )

(script static boolean motorbodyg_6_6
(= var_motor_pool_pos 4))

(script static boolean motorchief_6_8
(<= (ai_living_count motor_pool_armor_chieftain) 0))

(script static boolean motorup_to_6_9
(volume_test_players motor_pool_upper_trigger))

(script static boolean sewersecon_7_1
(volume_test_players sewer_obj_trig01))

(script static boolean sewerthird_7_2
(volume_test_players sewer_obj_trig02))

(script static boolean barramarin_8_0
(= (ai_task_status barracks_cov_obj/01_brutes_init) 1))

(script static boolean barramarin_8_8
(= (ai_task_status barracks_cov_obj/02_brutes_attack) 1))

(script static boolean barramarin_8_10
(= (ai_task_status barracks_cov_obj/03_brutes_init) 1))

(script static boolean barramarin_8_11
(= (ai_task_status barracks_cov_obj/04_brutes_attack) 1))

(script static boolean barramarin_8_12
(> (ai_task_status barracks_cov_obj/brute_chieftain) 1))

(script static boolean barramarin_8_13
(= (ai_task_status barracks_cov_obj/05_brutes_init) 1))

(script static boolean barraarbit_8_14
(= (ai_task_status barracks_cov_obj/01_brutes_init) 1))

(script static boolean barraarbit_8_15
(= (ai_task_status barracks_cov_obj/02_brutes_attack) 1))

(script static boolean barraarbit_8_17
(= (ai_task_status barracks_cov_obj/03_brutes_init) 1))

(script static boolean barraarbit_8_18
(= (ai_task_status barracks_cov_obj/04_brutes_attack) 1))

(script static boolean barraarbit_8_19
(= (ai_task_status barracks_cov_obj/05_brutes_init) 1))

(script static boolean barraarbit_8_20
(> (ai_task_status barracks_cov_obj/brute_chieftain) 1))

(script static boolean barramarin_8_21
(= (ai_task_status barracks_cov_obj/brute_chieftain) 1))

(script static boolean barraarbit_8_22
(= (ai_task_status barracks_cov_obj/brute_chieftain) 1))

(script static boolean barraarbit_8_24
(not (volume_test_players barracks_player_vol02)))

(script static boolean barramarin_8_25
(not (volume_test_players barracks_player_vol02)))

(script static boolean barraarbit_8_26
(not (volume_test_players barracks_arbiter_trig)))

(script static boolean barraleg01_9_1
(<= var_barracks_pos 3))

(script static boolean barra01_br_9_2
(<= var_barracks_pos 1))

(script static boolean cortagrunt_10_0
(< var_cortana_highway_pos 3))

(script static boolean cortagrunt_10_2
(< var_cortana_highway_pos 3))

(script static boolean cortagrunt_10_5
(< var_cortana_highway_pos 3))

(script static boolean self_flee_11_6
(> (device_get_position self_destruct_switch) 0))

(script static boolean self_alone_11_7
(= (ai_living_count self_destruct_cov02) 0))

(script static boolean loop0finis_14_1
(volume_test_players loop01_return_marine02_trig))

(script static boolean highw01_15_3
(= (ai_living_count highway_a_cov03/brute) 1))

(script static boolean highwiniti_16_0
(= marine_pos 0))

(script static boolean highwiniti_16_1
(= marine_pos 1))

(script static boolean highwiniti_16_2
(= marine_pos 2))

(script static boolean highwiniti_16_3
(or (= marine_pos 3) (= marine_pos 4)))

(script static boolean highwhighw_16_4
(= (ai_task_status highway_a_obj/initial_grunts) 1))

(script static boolean highwhighw_16_5
(> (ai_task_status highway_a_obj/initial_grunts) 1))

(script static boolean highwhighw_16_6
(> (ai_task_status highway_a_obj/middle) 1))

(script static boolean highwhighw_16_7
(> (ai_task_status highway_a_obj/back) 1))

(script static boolean highwhighw_16_8
(> (ai_task_status highway_a_obj/door_cover) 1))

(script static boolean highwhighw_16_9
(> (ai_task_status highway_a_obj/jack_carbine) 1))

(script static boolean highwbattl_16_10
(= marine_pos 5))

(script static boolean highwexit__16_11
(volume_test_players hangar_a_start_trig))

(script static boolean hangagrunt_18_0
(not (volume_test_players hangar_a_return_mid_trig)))

(script static boolean hangagrunt_18_1
(not (volume_test_players hangar_a_return_mid_trig)))

(script static boolean hangajacka_18_2
(not (volume_test_players hangar_a_return_right_trig)))

(script static boolean hangajacka_18_3
(not (volume_test_players hangar_a_return_left_trig)))

(script static boolean loop0follo_21_0
(volume_test_players highway_a_mid_trig))

