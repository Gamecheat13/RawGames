;These functions will spawn, load, and drop AI from a phantom
(script static void (ai_trickle_via_phantom (ai vehicle_starting_location) (ai spawned_squad))
	(ai_place spawned_squad)
;	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc" (ai_actors spawned_squad))
	(sleep 1)

	(object_set_phantom_power (ai_vehicle_get_from_starting_location vehicle_starting_location) TRUE)

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc_1")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc_2")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc_3")

	(sleep 60)

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc_4")

	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location vehicle_starting_location) FALSE)
)

(script static void (ai_dump_via_phantom (ai vehicle_starting_location) (ai spawned_squad))
	(ai_place spawned_squad)

;	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc" (ai_actors spawned_squad))

	(sleep 1)
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_pc")
)

;These functions will spawn, load, and drop AI from a phantom
(script static void (ai_disembark_via_phantom (ai vehicle_starting_location) (ai spawned_squad))
	(unit_open (ai_vehicle_get_from_starting_location vehicle_starting_location))
	(sleep 45)

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lf_small_1")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lf_small_2")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lf_small_3")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lf_main")

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rf_small_1")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rf_small_2")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rf_small_3")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rf_main")

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lb_small_1")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lb_small_2")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lb_small_3")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_lb_main")

	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rb_small_1")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rb_small_2")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rb_small_3")
	(vehicle_unload (ai_vehicle_get_from_starting_location vehicle_starting_location) "phantom_p_rb_main")

	(sleep 120)
	(unit_close (ai_vehicle_get_from_starting_location vehicle_starting_location))
)