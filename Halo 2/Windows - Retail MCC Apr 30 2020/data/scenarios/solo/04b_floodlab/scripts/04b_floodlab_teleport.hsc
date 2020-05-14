;04b_FLOODLAB!

;---

;teleportation scripts

(script static void teleport_silo
	(switch_bsp 3)
	(object_teleport (player0) silo_player0)
	(object_teleport (player1) silo_player1)
	(ai_place allies_elites_03a 1)
	(ai_place allies_elites_03b 1)
	(object_teleport (list_get (ai_actors allies_elites_03a) 0) silo_ally01)
	(object_teleport (list_get (ai_actors allies_elites_03b) 0) silo_ally02)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	
	(wake silo_start)
	(wake to_flood_lab)
	(wake flood_lab_start)
	
	(sleep_until (= (structure_bsp_index) 0))
	(wake bridge_start)
	(wake control_room_start)
	
	(sleep_until (= (structure_bsp_index) 2))
	(wake cable_room_start)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_lab
	(ai_erase_all)
	(switch_bsp 3)
	(object_teleport (player0) lab_player0)
	(object_teleport (player1) lab_player1)
	(ai_place allies_elites_03a 1)
	(object_teleport (list_get (ai_actors allies_elites_03a) 0) lab_ally01)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)

	(wake to_flood_lab)
	(wake flood_lab_start)
	
	(sleep_until (= (structure_bsp_index) 0))
	(wake bridge_start)
	(wake control_room_start)
	
	(sleep_until (= (structure_bsp_index) 2))
	(wake cable_room_start)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_wraparound
	(ai_erase_all)
	(switch_bsp 0)

	(sleep 2)

	(object_teleport (player0) wraparound_player0)
	(object_teleport (player1) wraparound_player1)
	(ai_place allies_elites_03a 1)
	(object_teleport (list_get (ai_actors allies_elites_03a) 0) wraparound_player1)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)

	(wake bridge_start)
	(wake control_room_start)
	
	(sleep_until (= (structure_bsp_index) 2))
	(wake cable_room_start)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_control
	(ai_erase_all)
	(switch_bsp 0)

	(sleep 2)

	(object_teleport (player0) control_entry_player0)
	(object_teleport (player1) control_entry_player1)
	(ai_place allies_elites_04 1)
	(ai_place allies_grunts_04 1)
	(object_teleport (list_get (ai_actors allies_elites_04) 0) control_ally01)
	(object_teleport (list_get (ai_actors allies_grunts_04) 0) control_ally02)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)

	(wake control_room_start)
	
	(sleep_until (= (structure_bsp_index) 2))
	(wake cable_room_start)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_cableroom
	(ai_erase_all)
	(switch_bsp 2)
	
	(sleep 2)
	
	(object_teleport (player0) cableroom_player0)
	(object_teleport (player1) cableroom_player1)
	(device_set_position_immediate elev_control_up 1)
	(device_set_power control_up_switch_02 0)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)

	(wake cable_room_start)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_plummet
	(ai_erase_all)
	(set plummeting TRUE)
	(switch_bsp 1)

	(sleep 2)

	(object_teleport (player0) after_plummet_player0)
	(object_teleport (player1) after_plummet_player1)
	(device_set_position_immediate control_shield_door 1)
	(device_set_position_immediate shield 1)
	(device_set_position_immediate elev_control_up 0)
	(device_set_power control_up_switch_01 0)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)

	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_powercore
	(ai_erase_all)
	(set plummeting TRUE)
	(switch_bsp 1)

	(sleep 2)

	(object_teleport (player0) powercore_player0)
	(object_teleport (player1) powercore_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)
	(sleep_control_return)

	(wake power_core_start)
	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_banshee
	(ai_erase_all)
	(set plummeting TRUE)
	(switch_bsp 1)

	(sleep 2)

	(object_teleport (player0) banshee_player0)
	(object_teleport (player1) banshee_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)
	(sleep_control_return)
	(sleep_powercore)

	(device_operates_automatically_set hl_ledge_ext TRUE)
	(object_create player0_fake_banshee)
	(object_create player1_fake_banshee)
	(object_create hl_fake_banshee)
	(object_cannot_take_damage player0_fake_banshee)
	(object_cannot_take_damage player1_fake_banshee)
	(object_cannot_take_damage hl_fake_banshee)

	(wake dogfight_secondtime_start)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE))
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_bottling_return
	(ai_erase_all)
	(set plummeting TRUE)
	(switch_bsp 1)

	(sleep 2)

	(object_teleport (player0) bottling_return_player0)
	(object_teleport (player1) bottling_return_player1)
	(device_operates_automatically_set viewroom_exit01_bsp0 TRUE)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)
	(sleep_control_return)
	(sleep_powercore)
	(sleep_dogfight)

	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_underhangar_return
	(ai_erase_all)
	(set plummeting TRUE)
	(switch_bsp 5)

	(sleep 2)

	(object_teleport (player0) underhangar_return_player0)
	(object_teleport (player1) underhangar_return_player1)
	
	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)
	(sleep_control_return)
	(sleep_powercore)
	(sleep_dogfight)
	(sleep_bottling_return)

	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)

(script static void teleport_boss
	(ai_erase_all)
	(set plummeting TRUE)

	(switch_bsp 5)

	(sleep 2)

	(object_teleport (player0) boss_player0)
	(object_teleport (player1) boss_player1)

	(sleep_forever mission)
	(sleep_intro)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(sleep_wraparound)
	(sleep_control)
	(sleep_cableroom)
	(sleep_control_return)
	(sleep_powercore)
	(sleep_dogfight)
	(sleep_bottling_return)
	(sleep_underhangar_return)

	(wake hangar_secondtime_start)
)