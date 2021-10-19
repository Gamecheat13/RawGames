;05a_DELTAAPPROACH!

;---

;teleportation scripts

(script static void teleport_bridge
	(ai_erase_all)
	(ai_place LZ_warthog_01)
	(device_set_position da_bridge 0.5)

	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_d" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) "warthog_p" (player1))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location LZ_warthog_02/driver) "warthog_d" (player1))

	(ai_place_in_vehicle allies_lz_ledge LZ_warthog_01)
;	(ai_place_in_vehicle allies_lz_ledge LZ_warthog_02)

	(object_teleport (ai_vehicle_get_from_starting_location LZ_warthog_01/driver) bridge_player0)
;	(object_teleport (ai_vehicle_get_from_starting_location LZ_warthog_02/driver) bridge_player1)

	(sleep_forever mission)
	(sleep_intro)

	(garbage_collect_now)
	(game_save)

	(ai_set_orders LZ_warthog_01 allies_bridge_pause)
	(wake bridges_start)

	(sleep_until (= (volume_test_objects vol_winding_path (players)) TRUE))
	(wake winding_path_start)
	(wake old_temple_entrance_start)
	
	(sleep_until (= (volume_test_objects vol_tunnel_01 (players)) TRUE))
	(wake tunnel_start)
	(wake old_temple_start)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_winding_path
	(ai_erase_all)
	(ai_place bridge_tank)
;	(ai_place lz_warthog_01)
;	(device_set_position_immediate da_bridge 1)

	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_p" (player1))

;	(ai_place_in_vehicle allies_lz_pelican bridge_tank)
;	(ai_place_in_vehicle allies_lz_ledge lz_warthog_01)

	(object_teleport (ai_vehicle_get_from_starting_location bridge_tank/driver) winding_path_player0)
;	(object_teleport (ai_vehicle_get_from_starting_location lz_warthog_01/driver) winding_path_player1)
	
	(ai_set_orders all_allies allies_w_path_follow)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)

	(garbage_collect_now)
	(game_save)

	(wake winding_path_start)
	(wake old_temple_entrance_start)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	
	(sleep_until (= (volume_test_objects vol_tunnel_01 (players)) TRUE))
	(wake tunnel_start)
	(wake old_temple_start)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_temple_ent
	(ai_erase_all)
	(ai_place bridge_tank)
;	(ai_place lz_warthog_01)
;	(device_set_position_immediate da_bridge 1)

	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_p" (player1))

;	(ai_place_in_vehicle allies_lz_pelican bridge_tank)
;	(ai_place_in_vehicle allies_lz_ledge lz_warthog_01)

	(object_teleport (ai_vehicle_get_from_starting_location bridge_tank/driver) temple_ent_player0)
;	(object_teleport (ai_vehicle_get_from_starting_location lz_warthog_01/driver) temple_ent_player1)
	
	(ai_set_orders all_allies temple_ent_all)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)

	(garbage_collect_now)
	(game_save)

	(wake old_temple_entrance_start)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	
	(sleep_until (= (volume_test_objects vol_tunnel_01 (players)) TRUE))
	(wake tunnel_start)
	(wake old_temple_start)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_tunnel
	(ai_erase_all)
	(ai_place bridge_tank)
;	(ai_place lz_warthog_01)
;	(device_set_position_immediate da_bridge 1)

	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_p" (player1))

;	(ai_place_in_vehicle allies_lz_pelican bridge_tank)
;	(ai_place_in_vehicle allies_lz_ledge lz_warthog_01)

	(object_teleport (ai_vehicle_get_from_starting_location bridge_tank/driver) tunnel_player0)
;	(object_teleport (ai_vehicle_get_from_starting_location lz_warthog_01/driver) tunnel_player1)
	
	(ai_set_orders all_allies allies_tunnel_follow)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)
	(sleep_temple_ent)

	(garbage_collect_now)
	(game_save)

	(wake tunnel_start)
	(wake old_temple_start)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_old_temple
	(ai_erase_all)
	(ai_place bridge_tank)
;	(ai_place lz_warthog_01)
;	(device_set_position_immediate da_bridge 1)

	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location bridge_tank/driver) "scorpion_p" (player1))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_d" (player0))
;	(vehicle_load_magic (ai_vehicle_get_from_starting_location lz_warthog_01/driver) "warthog_p" (player1))

;	(ai_place_in_vehicle allies_lz_pelican bridge_tank)
;	(ai_place_in_vehicle allies_lz_ledge lz_warthog_01)

	(object_teleport (ai_vehicle_get_from_starting_location bridge_tank/driver) old_temple_player0)
;	(object_teleport (ai_vehicle_get_from_starting_location lz_warthog_01/driver) old_temple_player1)
	
	(ai_set_orders all_allies allies_old_temple_follow)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)
	(sleep_temple_ent)
	(sleep_tunnel)

	(garbage_collect_now)
	(game_save)

	(wake old_temple_start)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	(sleep 1)
	(wake ally_order_monitor)
	
	(sleep_until (= (volume_test_objects vol_grotto (players)) TRUE))
	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_grotto
	(ai_erase_all)
;	(device_set_position_immediate da_bridge 1)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) grotto_player0)
	(object_teleport (player1) grotto_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)
	(sleep_temple_ent)
	(sleep_tunnel)
	(sleep_old_temple)

	(garbage_collect_now)
	(game_save)

	(wake grotto_start)
	
	(sleep_until (= (volume_test_objects vol_approach (players)) TRUE))
	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_approach
	(ai_erase_all)
;	(device_set_position_immediate da_bridge 1)
	
	(switch_bsp 1)

	(sleep 1)
	
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) approach_player0)
	(object_teleport (player1) approach_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)
	(sleep_temple_ent)
	(sleep_tunnel)
	(sleep_old_temple)
	(sleep_grotto)

	(garbage_collect_now)
	(game_save)

	(wake temple_approach_start)
	(wake tower1_start)	
)

(script static void teleport_tower1
	(ai_erase_all)
;	(device_set_position_immediate da_bridge 1)
	
	(switch_bsp 1)
	
	(sleep 1)
	
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) tower1_player0)
	(object_teleport (player1) tower1_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_bridge)
	(sleep_winding_path)
	(sleep_temple_ent)
	(sleep_tunnel)
	(sleep_old_temple)
	(sleep_grotto)
	(sleep_approach)

	(garbage_collect_now)
	(game_save)

	(wake tower1_start)	
)