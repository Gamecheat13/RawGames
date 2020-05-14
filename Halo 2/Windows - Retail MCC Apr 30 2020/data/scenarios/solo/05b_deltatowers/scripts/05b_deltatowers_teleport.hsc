;05a_DELTAAPPROACH!

;---

;teleportation scripts

(script static void teleport_bridges
	(ai_erase_all)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) bridges_player0)
	(object_teleport (player1) bridges_player1)
	
	(ai_place initial_allies)
	(object_teleport (list_get (ai_actors initial_allies) 0) bridges_ally1)
	(object_teleport (list_get (ai_actors initial_allies) 1) bridges_ally2)
	(ai_set_orders initial_allies tower1_ext_allies)
	
	(sleep_forever mission)
	(sleep_tower1)

	(garbage_collect_now)
	(game_save)

	(wake bridges_start)
	(wake tower2_start)

	(sleep_until 
		(OR 
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	)
	(wake central_platform_start)
	(wake gondola_01_start)

	(sleep_until (= (volume_test_objects vol_tower3_entry (players)) TRUE))
	(wake tower3_start)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)

	(sleep_until (= (volume_test_objects vol_tunnel_01_entry (players)) TRUE))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_tower2
	(ai_erase_all)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) tower2_player0)
	(object_teleport (player1) tower2_player1)
	
	(ai_place initial_allies)
	(object_teleport (list_get (ai_actors initial_allies) 0) tower2_ally1)
	(object_teleport (list_get (ai_actors initial_allies) 1) tower2_ally2)
	(ai_set_orders initial_allies tower2_ext_allies_01)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)

	(garbage_collect_now)
	(game_save)

	(wake tower2_start)

	(sleep_until 
		(OR 
			(= (volume_test_objects vol_tower2_exit (players)) TRUE)
			(= (volume_test_objects vol_central_platform (players)) TRUE)
		)
	)
	(wake central_platform_start)
	(wake gondola_01_start)

	(sleep_until (= (volume_test_objects vol_tower3_entry (players)) TRUE))
	(wake tower3_start)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)

	(sleep_until (= (volume_test_objects vol_tunnel_01_entry (players)) TRUE))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_central_platform
	(ai_erase_all)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) center_plat_player0)
	(object_teleport (player1) center_plat_player1)
	
	(ai_place initial_allies)
	(object_teleport (list_get (ai_actors initial_allies) 0) center_plat_ally1)
	(object_teleport (list_get (ai_actors initial_allies) 1) center_plat_ally2)
	(ai_set_orders initial_allies tower2_ext_allies_02)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)

	(garbage_collect_now)
	(game_save)

	(wake central_platform_start)
	(wake gondola_01_start)

	(sleep_until (= (volume_test_objects vol_tower3_entry (players)) TRUE))
	(wake tower3_start)
	(sleep_central_platform)
	(sleep_gondola_01)

	(sleep_until (= (volume_test_objects vol_tunnel_01_entry (players)) TRUE))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_gondola_01
	(ai_erase_all)
				
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) gondola_01_player0)
	(object_teleport (player1) gondola_01_player1)
	
	(ai_place initial_allies)
	(object_teleport (list_get (ai_actors initial_allies) 0) gondola_01_ally1)
	(object_teleport (list_get (ai_actors initial_allies) 1) gondola_01_ally2)
	(ai_set_orders initial_allies gondola_01_allies)
	(device_set_position_immediate gondola_01_a 1)
	(device_set_position_immediate gondola_01_b 1)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)

	(garbage_collect_now)
	(game_save)

	(wake gondola_01_start)

	(sleep_until (= (volume_test_objects vol_tower3_entry (players)) TRUE))
	(wake tower3_start)
	(sleep_gondola_01)

	(sleep_until (= (volume_test_objects vol_tunnel_01_entry (players)) TRUE))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_tower3
	(ai_erase_all)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	(object_teleport (player0) tower3_player0)
	(object_teleport (player1) tower3_player1)
	
	(ai_place initial_allies)
	(object_teleport (list_get (ai_actors initial_allies) 0) tower3_ally1)
	(object_teleport (list_get (ai_actors initial_allies) 1) tower3_ally2)
	(ai_set_orders initial_allies tower3_allies)
		
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)

	(garbage_collect_now)
	(game_save)

	(wake tower3_start)

	(sleep_until (= (volume_test_objects vol_tunnel_01_entry (players)) TRUE))
	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)
	(sleep_tower3)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_tunnel_01
	(ai_erase_all)

	(ai_place temp_bsp2_allies)

	(switch_bsp 1)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)
	
	(sleep 2)
	
	(object_teleport (player0) tunnel_01_player0)
	(object_teleport (player1) tunnel_01_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 0) tunnel_01_ally1)
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 1) tunnel_01_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)

	(garbage_collect_now)
	(game_save)

	(wake sunken_tunnel1_start)
	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_sunken_chamber
	(ai_erase_all)

	(ai_place temp_bsp2_allies)

	(switch_bsp 1)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) sunken_chamber_player0)
	(object_teleport (player1) sunken_chamber_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 0) sunken_chamber_ally1)
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 1) sunken_chamber_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)

	(garbage_collect_now)
	(game_save)

	(wake sunken_chamber_start)
	(wake sunken_tunnel2_start)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_tunnel_02
	(ai_erase_all)

	(ai_place temp_bsp2_allies)

	(switch_bsp 1)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) tunnel_02_player0)
	(object_teleport (player1) tunnel_02_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 0) tunnel_02_ally1)
	(object_teleport (list_get (ai_actors temp_bsp2_allies) 1) tunnel_02_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)

	(garbage_collect_now)
	(game_save)

	(wake sunken_tunnel2_start)

	(sleep_until 
		(AND
			(= (volume_test_objects vol_island_int_entry (players)) TRUE)
			(= (structure_bsp_index) 2)
		)
	)
	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)
	(sleep_sunken_tunnel_02)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_island
	(ai_erase_all)

	(ai_place temp_bsp3_allies)

	(switch_bsp 2)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) island_player0)
	(object_teleport (player1) island_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 0) island_ally1)
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 1) island_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)

	(garbage_collect_now)
	(game_save)

	(wake island_interior_start)
	(wake island_gully_start)
	(wake island_exterior_start)
	(wake gondola_02_start)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_island_exterior)
	(sleep_gondola_02)
)

(script static void teleport_gondola_02
	(ai_erase_all)

	(ai_place temp_bsp3_allies)

	(switch_bsp 2)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) gondola_02_player0)
	(object_teleport (player1) gondola_02_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 0) gondola_02_ally1)
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 1) gondola_02_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)
	(sleep_island_exterior)

	(garbage_collect_now)
	(game_save)

	(wake gondola_02_start)

	(sleep_until (= (volume_test_objects vol_temple_ext (players)) TRUE))
	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
	(sleep_gondola_02)
)

(script static void teleport_temple_ext
	(ai_erase_all)

	(ai_place temp_bsp3_allies)

	(switch_bsp 2)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) temple_ext_player0)
	(object_teleport (player1) temple_ext_player1)
	
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 0) temple_ext_ally1)
	(object_teleport (list_get (ai_actors temp_bsp3_allies) 1) temple_ext_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)
	(sleep_island_exterior)
	(sleep_gondola_02)

	(garbage_collect_now)
	(game_save)

	(wake temple_entry_start)
	(wake temple_foyer_start)
	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
)

(script static void teleport_temple_int
	(ai_erase_all)

	(switch_bsp 2)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) temple_int_player0)
	(object_teleport (player1) temple_int_player1)
	
;	(ai_place temp_bsp3_allies)
;	(object_teleport (list_get (ai_actors temp_bsp3_allies) 0) temple_int_ally1)
;	(object_teleport (list_get (ai_actors temp_bsp3_allies) 1) temple_int_ally2)
	
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)
	(sleep_island_exterior)
	(sleep_gondola_02)
	(sleep_temple_entry)

	(garbage_collect_now)
	(game_save)

	(wake temple_center_start)
	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
)

(script static void teleport_temple_retreat
	(ai_erase_all)

	(switch_bsp 2)
		
	(unit_add_equipment (player0) profile_1 TRUE TRUE)
	(unit_add_equipment (player1) profile_1 TRUE TRUE)

	(sleep 2)

	(object_teleport (player0) temple_return_player0)
	(object_teleport (player1) temple_return_player1)
		
	(sleep_forever mission)
	(sleep_tower1)
	(sleep_bridges)
	(sleep_tower2)
	(sleep_central_platform)
	(sleep_gondola_01)
	(sleep_tower3)
	(sleep_sunken_tunnel_01)
	(sleep_sunken_chamber)
	(sleep_sunken_tunnel_02)
	(sleep_island_exterior)
	(sleep_gondola_02)
	(sleep_temple_entry)
	(sleep_boss_fight)

	(garbage_collect_now)
	(game_save)

	(device_one_sided_set door_main FALSE)
	(device_one_sided_set temple_retreat_exit FALSE)

	(wake temple_foyer_retreat)
	(wake temple_entry_retreat)
)