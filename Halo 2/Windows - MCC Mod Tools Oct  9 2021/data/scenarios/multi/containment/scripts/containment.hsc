;*
(script continuous expolosion_0
	(if (<= (object_get_health power_core_0) 0)
		(device_set_position base_machine_0 1)
	)
)

(script continuous expolosion_1
	(if (<= (object_get_health power_core_1) 0)
		(device_set_position base_machine_1 1)
	)
)
*;