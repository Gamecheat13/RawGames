(script static boolean obj_sbonus_0_2
b_sur_bonus_round_running)

(script static boolean obj_shero__0_6
(<= (ai_task_count obj_survival/remaining) 3))

(script static boolean obj_smain__0_8
(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3)))

(script static boolean obj_sgener_0_9
b_sur_generator_defense_active)

(script static boolean obj_sgen0_0_10
b_sur_generator0_alive)

(script static boolean obj_sgen1_0_11
b_sur_generator1_alive)

(script static boolean obj_sgen2_0_12
b_sur_generator2_alive)

(script static boolean obj_sgen0__0_13
(and (> (ai_task_count obj_survival/gen0) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen1__0_14
(and (> (ai_task_count obj_survival/gen1) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen2__0_15
(and (> (ai_task_count obj_survival/gen2) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_saddit_0_17
(>= (game_coop_player_count) 4))

(script static boolean obj_mdefen_3_2
(volume_test_objects tv_north_deck (ai_actors gr_survival_waves)))

(script static boolean obj_mdefen_3_3
(volume_test_objects tv_west_deck (ai_actors gr_survival_waves)))

(script static boolean obj_mdefen_3_4
(volume_test_objects tv_east_deck (ai_actors gr_survival_waves)))

(script static boolean obj_mdefen_3_5
(volume_test_objects tv_south_deck (ai_actors gr_survival_waves)))

(script static boolean obj_mplaye_3_15
(> (game_coop_player_count) 1))

(script static boolean obj_mplaye_3_16
(> (game_coop_player_count) 2))

(script static boolean obj_mplaye_3_17
(> (game_coop_player_count) 3))

