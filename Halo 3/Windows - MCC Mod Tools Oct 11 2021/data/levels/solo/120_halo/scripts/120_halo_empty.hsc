
(script startup test_crashing
	(sleep_until
		(begin
			(object_create_anew meteorite_a)
			(object_teleport_to_ai_point meteorite_a test/p0)
			(scenery_animation_start meteorite_a objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep 15)
			(sleep (scenery_get_animation_time meteorite_a))
			(object_damage_damage_section meteorite_a "main" 1)
		FALSE)
	150)
)

