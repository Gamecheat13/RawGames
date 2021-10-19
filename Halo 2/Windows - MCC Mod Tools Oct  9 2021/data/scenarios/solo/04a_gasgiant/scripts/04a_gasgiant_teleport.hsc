;04a_GASGIANT!

;---

;teleportation scripts

(script static void teleport_hangar
	(ai_erase_all)
	(ai_place allies_elites_01)
	(ai_place allies_grunts_01 1)
	(ai_place hacker)
	(switch_bsp 3)
	(object_teleport (player0) hangar_top_player0)
	(object_teleport (player1) hangar_top_player1)
	(object_teleport (list_get (ai_actors allies_elites_01) 0) hangar_top_ally01)
	(object_teleport (list_get (ai_actors hacker) 0) hangar_top_ally02)
	(object_teleport (list_get (ai_actors allies_grunts_01) 0) hangar_top_ally03)
;	(object_teleport (list_get (ai_actors allies_grunts_01) 1) hangar_top_ally04)

	(device_set_position_immediate elev_hangar 0)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_rec_center)
	
	(ai_set_orders arm01_allies get_on_hangar_elev)	

	(sleep_until (= (volume_test_objects vol_on_hangar_lift_top (players)) TRUE))
	
	(game_save)
	(wake hangar_firsttime_start)
	(wake to_underhangar_firsttime)
	(device_one_sided_set rec_center_entry_ext TRUE)
	(device_one_sided_set rec_center_entry_int TRUE)

	(sleep_until (= (volume_test_objects vol_underhangar_from_top (players)) TRUE))
	(wake underhangar_firsttime_start)
	(wake to_bottling)
	(sleep_rec_center)
	(sleep_hangar)
	(set recycling_power_on FALSE)
	(set hangar_power_on FALSE)
	(device_one_sided_set hangar_exit TRUE)

	(sleep_until (= (structure_bsp_index) 0))
;	(sleep_until (= (volume_test_objects vol_bottling_enter (players)) TRUE))
	(wake bottling_firsttime_start)
	(wake bottling_plant_end)
	(sleep_first_halls)
	(sleep_underhangar)
	(set underhangar_power_on FALSE)
	(device_one_sided_set underhangar_entry TRUE)
	(device_one_sided_set underhangar_exit TRUE)

	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	)
	(wake dogfight_firsttime_start)
	(wake arm_02_entry_win)
	(sleep_second_halls)
	(sleep_bottling)
	(set bottling_power_on FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_one_sided_set bottling_entry TRUE)
	(device_one_sided_set bottling_midway TRUE)
	(device_one_sided_set viewroom_entry TRUE)
	
	(sleep_until 
		(OR
			(AND
				(unit_in_vehicle (player0))
				(unit_in_vehicle (player1))
			)
			(AND
				(unit_in_vehicle (player0))
				(= (game_is_cooperative) FALSE)
			)
		)
	) 
)

(script static void teleport_underhangar
	(ai_erase_all)
	(ai_place allies_elites_01)
;	(ai_place allies_grunts_01)
	(ai_place hacker)
	(switch_bsp 3)
	(object_teleport (player0) underhangar_player0)
	(object_teleport (player1) underhangar_player1)
	(object_teleport (list_get (ai_actors allies_elites_01) 0) underhangar_ally01)
	(object_teleport (list_get (ai_actors hacker) 0) underhangar_ally02)
;	(object_teleport (list_get (ai_actors allies_grunts_01) 0) underhangar_ally03)
;	(object_teleport (list_get (ai_actors allies_grunts_01) 1) underhangar_ally04)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_rec_center)
	(sleep_first_halls)
	(sleep_hangar)
	(device_one_sided_set rec_center_entry_ext TRUE)
	(device_one_sided_set rec_center_entry_int TRUE)

	(game_save)

	(wake underhangar_firsttime_start)
	(wake to_bottling)
	(set recycling_power_on FALSE)
	(set hangar_power_on FALSE)
	(device_one_sided_set hangar_exit TRUE)

	(sleep_until (= (structure_bsp_index) 0))
;	(sleep_until (= (volume_test_objects vol_bottling_enter (players)) TRUE))
	(wake bottling_firsttime_start)
	(wake bottling_plant_end)
	(sleep_first_halls)
	(sleep_underhangar)
	(set underhangar_power_on FALSE)
	(device_one_sided_set underhangar_entry TRUE)
	(device_one_sided_set underhangar_exit TRUE)

	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	)
	(wake dogfight_firsttime_start)
	(wake arm_02_entry_win)
	(sleep_second_halls)
	(sleep_bottling)
	(set bottling_power_on FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_one_sided_set bottling_entry TRUE)
	(device_one_sided_set bottling_midway TRUE)
	(device_one_sided_set viewroom_entry TRUE)
	
	(sleep_until 
		(OR
			(AND
				(unit_in_vehicle (player0))
				(unit_in_vehicle (player1))
			)
			(AND
				(unit_in_vehicle (player0))
				(= (game_is_cooperative) FALSE)
			)
		)
	) 
)

(script static void teleport_bottling
	(ai_erase_all)
	(ai_place allies_elites_01)
;	(ai_place allies_grunts_01)
;	(ai_place hacker)
	(switch_bsp 0)
	(object_teleport (player0) bottling_player0)
	(object_teleport (player1) bottling_player1)
	(object_teleport (list_get (ai_actors allies_elites_01) 0) bottling_ally01)
;	(object_teleport (list_get (ai_actors hacker) 0) bottling_ally02)
;	(object_teleport (list_get (ai_actors allies_grunts_01) 0) bottling_ally03)
;	(object_teleport (list_get (ai_actors allies_grunts_01) 1) bottling_ally04)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_rec_center)
	(sleep_hangar)
	(sleep_first_halls)
	(sleep_underhangar)
	(sleep_second_halls)
	(device_one_sided_set rec_center_entry_ext TRUE)
	(device_one_sided_set rec_center_entry_int TRUE)
	(device_one_sided_set hangar_exit TRUE)

	(game_save)

	(wake bottling_firsttime_start)
	(wake bottling_plant_end)
	(sleep_first_halls)
	(sleep_underhangar)
	(set underhangar_power_on FALSE)
	(device_one_sided_set underhangar_entry TRUE)
	(device_one_sided_set underhangar_exit TRUE)

	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	)
	(wake dogfight_firsttime_start)
	(wake arm_02_entry_win)
	(sleep_second_halls)
	(sleep_bottling)
	(set bottling_power_on FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_one_sided_set bottling_entry TRUE)
	(device_one_sided_set bottling_midway TRUE)
	(device_one_sided_set viewroom_entry TRUE)
	
	(sleep_until 
		(OR
			(AND
				(unit_in_vehicle (player0))
				(unit_in_vehicle (player1))
			)
			(AND
				(unit_in_vehicle (player0))
				(= (game_is_cooperative) FALSE)
			)
		)
	) 
)

(script static void teleport_banshee
	(ai_erase_all)
	(switch_bsp 0)
	(ai_place ledge_banshees_01/left)
	(ai_place ledge_banshees_01/right)
	(ai_place dog_turrets_01)
	(object_teleport (player0) banshee_ledge_player0)
	(object_teleport (player1) banshee_ledge_player1)
	(wake bring_in_da_phantom)
	(sleep_forever mission)
	(sleep_intro)
	(sleep_rec_center)
	(sleep_hangar)
	(sleep_first_halls)
	(sleep_underhangar)
	(sleep_second_halls)
	(sleep_bottling)
	(device_one_sided_set rec_center_entry_ext TRUE)
	(device_one_sided_set rec_center_entry_int TRUE)
	(device_one_sided_set hangar_exit TRUE)
	(device_one_sided_set underhangar_entry TRUE)
	(device_one_sided_set underhangar_exit TRUE)
	(wake bring_in_da_phantom)

	(game_save)
	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	)
	(wake dogfight_firsttime_start)
	(wake arm_02_entry_win)
	(sleep_second_halls)
	(sleep_bottling)
	(set bottling_power_on FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_one_sided_set bottling_entry TRUE)
	(device_one_sided_set bottling_midway TRUE)
	(device_one_sided_set viewroom_entry TRUE)
	
	(sleep_until 
		(OR
			(AND
				(unit_in_vehicle (player0))
				(unit_in_vehicle (player1))
			)
			(AND
				(unit_in_vehicle (player0))
				(= (game_is_cooperative) FALSE)
			)
		)
	) 
)