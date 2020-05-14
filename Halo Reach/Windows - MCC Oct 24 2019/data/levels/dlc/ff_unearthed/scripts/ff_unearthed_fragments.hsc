(script static boolean obj_sbonus_0_1
b_sur_bonus_round_running)

(script static boolean obj_shero__0_12
(<= (ai_task_count obj_survival/remaining) 3))

(script static boolean obj_smain__0_14
(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3)))

(script static boolean obj_sgener_0_15
b_sur_generator_defense_active)

(script static boolean obj_sgen0_0_16
b_sur_generator0_alive)

(script static boolean obj_sgen1_0_17
b_sur_generator1_alive)

(script static boolean obj_sgen2_0_18
b_sur_generator2_alive)

(script static boolean obj_sgen0__0_30
(and (> (ai_task_count obj_survival/gen0) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen1__0_31
(and (> (ai_task_count obj_survival/gen1) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen2__0_32
(and (> (ai_task_count obj_survival/gen2) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_swrait_0_34
(not (volume_test_players tv_wraith_02)))

(script static boolean obj_swrait_0_35
(not (volume_test_players tv_wraith_01)))

(script static boolean obj_ssnipe_0_36
(volume_test_object tv_cliff_fall_left (ai_get_object sq_sur_sniper_01/sniper_01)))

(script static boolean obj_swsnip_0_37
(volume_test_object tv_cliff_fall_right (ai_get_object sq_sur_sniper_01/sniper_01)))

(script static boolean obj_ssnipe_0_38
(volume_test_object tv_cliff_fall_left (ai_get_object sq_sur_sniper_02/sniper_02)))

(script static boolean obj_ssnipe_0_39
(volume_test_object tv_cliff_fall_right (ai_get_object sq_sur_sniper_02/sniper_02)))

