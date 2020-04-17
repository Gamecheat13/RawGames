(script static boolean obj_shero__0_2
(<= (ai_task_count obj_survival/remaining) 3))

(script static boolean obj_smain__0_5
(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3)))

(script static boolean obj_sbonus_0_10
b_sur_bonus_round_running)

(script static boolean obj_sgen2_0_12
b_sur_generator2_alive)

(script static boolean obj_sgen0_0_13
b_sur_generator0_alive)

(script static boolean obj_sgen1_0_14
b_sur_generator1_alive)

(script static boolean obj_sgener_0_15
b_sur_generator_defense_active)

(script static boolean obj_swrait_0_23
(volume_test_players tv_wraith_02))

(script static boolean obj_swrait_0_24
(volume_test_players tv_wraith_01))

(script static boolean obj_saddit_0_28
(>= (game_coop_player_count) 4))

(script static boolean obj_sgen0__0_32
(and (> (ai_task_count obj_survival/gen0) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen2__0_33
(and (> (ai_task_count obj_survival/gen2) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen1__0_34
(and (> (ai_task_count obj_survival/gen1) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_swrait_0_35
(= b_wraith_01 FALSE))

(script static boolean obj_swrait_0_36
(= b_wraith_02 FALSE))

