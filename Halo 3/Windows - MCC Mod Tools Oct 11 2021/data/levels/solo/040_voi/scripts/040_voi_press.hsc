(script startup press
	(fade_in 0 0 0 0)
	(set g_play_cinematics FALSE)
	(hud_enable_training FALSE)
	(ai_erase_all)
	
	(sleep 1)
	(switch_zone_set bcd)
	(sleep 1)
	(object_teleport (player0) test)
	(sleep 1)
	
	(ai_place intro_hog)
	(ai_place test_init_allies 2)
	(sleep 1)
	
	(object_teleport (ai_vehicle_get_from_starting_location intro_hog/driver) test)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (ai_actors test_init_allies/passenger))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (ai_actors test_init_allies/gunner))

	(sleep 1)
	(garbage_collect_now)
	(sleep 1)
	
	(sleep_forever intro)
	(sleep_forever intro_flyby)
	(sleep_forever factory_a_start)
	(sleep_forever lakebed_a_start)
	(sleep_forever factory_b_start)
	(sleep_forever lakebed_b_start)
	(sleep_forever breach_start)
	(sleep_forever br_int_01)
	(sleep_forever md_int_dead_01)
	(sleep_forever md_int_dead_02)
	(sleep_forever md_int_storm)
	(set g_playing_dialogue FALSE)

	(ai_set_objective allied_infantry lakebed_a_allies)
	(ai_set_objective allied_vehicles lakebed_a_allies)
	
	(game_save_immediate)
	(ai_place lake_a_def_center 1)
	
	(ai_place lakebed_a_init_phantoms)
	(ai_place lakebed_a_init_phantoms02)
	(ai_place press_choppers)
	(ai_place lakebed_a_wraith_01)
	(sleep 1)
	(cs_run_command_script lakebed_a_init_phantoms/driver01 phantom_init_drop01_press)
	(cs_run_command_script lakebed_a_init_phantoms02/driver01 phantom_init_drop02_press)
	(cs_run_command_script lake_a_def_center/rocket_man rocket_man)
	
	(object_cannot_die (ai_vehicle_get_from_starting_location press_choppers/driver01) TRUE)
	(object_cannot_die (ai_vehicle_get_from_starting_location press_choppers/driver02) TRUE)
	(object_cannot_die (ai_vehicle_get_from_starting_location press_choppers/driver03) TRUE)
	(ai_cannot_die press_choppers TRUE)
	(ai_cannot_die lake_a_def_center TRUE)
	
	(sound_looping_start sound\music\alpha_press\alpha_press NONE 1)
	
	(sleep_until (volume_test_players vol_lakebed_a_end) 1)
	(print "boom")
	(effect_new fx\scenery_fx\explosions\covenant_explosion_large\covenant_explosion_large "boom_flag")
	(sleep 50)
	(ai_place press_banshees)
	(cs_run_command_script press_banshees/driver01 banshee_cs01_press)
	(cs_run_command_script press_banshees/driver02 banshee_cs02_press)
	
)

(script command_script phantom_init_drop01_press
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to lakebed_a/phantom01a)
	(sleep_until
		(begin
			(cs_fly_to lakebed_a/phantom_press)
			(sleep 70)
			(cs_fly_to lakebed_a/phantom01a)
			(sleep 80)
			FALSE
		)
	)
)

(script command_script phantom_init_drop02_press
	(sleep 60)
	(cs_enable_moving TRUE)
	(sleep (* 30 3))
	(cs_enable_moving FALSE)
	(cs_run_command_script ai_current_actor lakea_phantom_exit)
)

(script command_script banshee_cs01_press
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_boost TRUE)
	(sleep_until
		(begin
			(cs_fly_to lakebed_a/banshee01b)
			(cs_fly_to lakebed_a/banshee01)
			FALSE
		)
	)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script banshee_cs02_press
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(sleep_until
		(begin
			(cs_fly_to lakebed_a/banshee02b)
			(cs_fly_to lakebed_a/banshee02)
			FALSE
		)
	)
	(object_destroy (ai_vehicle_get ai_current_actor))
)