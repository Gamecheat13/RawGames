(script static boolean obj_sbonus_0_4
b_sur_bonus_round_running)

(script static boolean obj_shero__0_8
(<= (ai_task_count obj_survival/remaining) 3))

(script static boolean obj_smain__0_10
(and (<= (ai_task_count obj_survival/hero_follow) 0) (<= (ai_task_count obj_survival/remaining) 3)))

(script static boolean obj_sgener_0_21
b_sur_generator_defense_active)

(script static boolean obj_sgen1_0_22
b_sur_generator1_alive)

(script static boolean obj_sgen0_0_23
b_sur_generator0_alive)

(script static boolean obj_sgen2_0_24
b_sur_generator2_alive)

(script static boolean obj_sgen0__0_29
(and (> (ai_task_count obj_survival/gen0) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen1__0_30
(and (> (ai_task_count obj_survival/gen1) 0) (>= (game_coop_player_count) 3)))

(script static boolean obj_sgen2__0_31
(and (> (ai_task_count obj_survival/gen2) 0) (>= (game_coop_player_count) 3)))

