(script static void (sleeping_grunts)
	(ai_set_combat_status (performance_get_actor grunt1) 0)
	(performance_play_line "start_sleeping")
	(performance_play_line "block")
	(performance_play_line "sleep_until")
	(sleep_until (> (ai_combat_status (performance_get_actor grunt1)) 5))
)

