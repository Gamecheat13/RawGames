(script static boolean ff_obhero__0_2
(<= (ai_task_count ff_objective/remaining) 3))

(script static boolean ff_obmain__0_5
(and (<= (ai_task_count ff_objective/hero_follow) 0) (<= (ai_task_count ff_objective/remaining) 3)))

(script static boolean ff_obbonus_0_13
b_sur_bonus_round_running)

(script static boolean ff_obgener_0_15
b_sur_generator_defense_active)

(script static boolean ff_obbedla_0_17
(survival_mode_bedlam))

