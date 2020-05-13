
(script dormant flying_brutes
	(ai_place brutes)
	(vs_reserve brutes 0)
	(vs_movement_mode brutes 1)
	(sleep_until
		(begin
			(vs_go_to brutes/brute_01 TRUE jetpack_points/p0)
			(vs_go_to brutes/brute_01 TRUE jetpack_points/p1)
		FALSE
		)
	)

)