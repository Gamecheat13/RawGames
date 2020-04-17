(script static boolean obj_swrait_0_1
(not (volume_test_players tv_wraith)))

(script static boolean obj_swrait_0_2
(not (volume_test_players tv_wraith)))

(script static boolean obj_sghost_0_3
 (> (ai_task_count obj_survival/wraith02) 0))

(script static boolean obj_sbonus_0_6
b_sur_bonus_round_running)

(script static boolean obj_shero__0_10
(<= (ai_task_count obj_survival/remaining) 3))

(script static boolean obj_smain__0_12
(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3)))

(script static boolean obj_sgener_0_22
b_sur_generator_defense_active)

(script static boolean obj_sgen0_0_23
b_sur_generator0_alive)

(script static boolean obj_sgen1_0_24
b_sur_generator1_alive)

(script static boolean obj_sgen2_0_25
b_sur_generator2_alive)

(script static boolean obj_swrait_0_26
(> (ai_task_count obj_survival/wraith01) 0))

(script static boolean obj_sghost_0_27
 (> (ai_task_count obj_survival/wraith01) 0))

(script static boolean obj_sghost_0_28
 (> (ai_task_count obj_survival/wraith02_advance) 0))

(script static boolean obj_swrait_0_32
(not (and b_phantomw_01_1 b_phantomw_02_1 b_phantomw_03_1 b_phantomw_04_1)))

(script static boolean obj_swrait_0_33
(not (and b_phantomw_01_2 b_phantomw_02_2 b_phantomw_03_2 b_phantomw_04_2)))

