;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================

;=========================================================================================
;====================================== START ============================================
;=========================================================================================


;=========================================================================================
;================================== BEACH ================================================
;=========================================================================================
(script static void ins_beach
	(print "insertion point : beach")
	(fade_out 0 0 0 0)

	; set insertion point index 
	(set g_insertion_index 1)
)

;=========================================================================================
;================================== HORNETS ==============================================
;=========================================================================================
(script static void ins_hornets
	(print "insertion point : hornets")
	

	(print "switching zone sets...")
	(switch_zone_set set_beach)
	
	(unit_add_equipment (player0) chief_1p_respawn TRUE TRUE)
	(unit_add_equipment (player1) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player2) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player3) dervish_respawn TRUE TRUE)
	(sleep 1)
	
	(insertion_start)

	; set insertion point index 
	(set g_insertion_index 6)
	(device_set_power beam_diag_mid 0)
	(device_set_power beam_diag_left 0)
	(device_set_power beam_vert_mid 0)
	(device_set_power beam_vert_mid_crater 0)
	(device_set_power beam_vert_left 0)
	(device_set_power beam_vert_left_crater 0)
	(wake objective_1_clear)
	(wake objective_2_set)
	
	;setup
	(set g_tower1 TRUE)
	
	; placing allies... 
	(wake spawn_air_forces)
	
	; wake musice script 
	(wake music_100_051)
	
	; turn on music 051 
	(set g_music_100_051 TRUE)
	
	; teleport players to the proper location
	(print "teleport players")
	(object_teleport (player0) teleport_cell_b_player0)
	(object_teleport (player1) teleport_cell_b_player1)
	(object_teleport (player2) teleport_cell_b_player2)
	(object_teleport (player3) teleport_cell_b_player3)
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
	(sleep 1)
	(player_disable_movement FALSE)
	(sleep 60)
	
	; wake the chapter title 
	(wake 100_title2)
	(cinematic_fade_to_title)
)

;=========================================================================================
;=================================== CITADEL ADV =========================================
;=========================================================================================
(script static void ins_citadel_adv
	(print "insertion point : citadel adv")

	; set insertion point index 
	(set g_insertion_index 9)

	; switch to correct zone set
	(switch_zone_set set_cell_ice)
	
	(unit_add_equipment (player0) chief_1p_respawn TRUE TRUE)
	(unit_add_equipment (player1) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player2) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player3) dervish_respawn TRUE TRUE)
	(sleep 1)
	
	(insertion_start)

	; place objects
	(object_create_folder crates_cellc)
	(object_create_folder crates_ice)
	(sleep 1)
	
	; wake music scripts 
	(wake music_100_088)
	(wake music_100_089)
	
	; turn on music 
	(set g_music_100_088 TRUE)
	(set g_music_100_089 TRUE)
	
	;setup
	(set g_tower1 TRUE)
	(set g_tower3 TRUE)
	(device_set_power beam_diag_right 0)
	(device_set_power beam_diag_mid 0)
	(device_set_power beam_diag_left 0)
	(device_set_power beam_vert_right 0)
	(device_set_power beam_vert_right_crater 0)
	(device_set_power beam_vert_mid 0)
	(device_set_power beam_vert_mid_crater 0)
	(device_set_power beam_vert_left 0)
	(device_set_power beam_vert_left_crater 0)
	(device_set_power crater_shield 0)
	(wake objective_2_clear)
	(wake objective_3_set)
	(object_destroy cov_capital_ship)
	(zone_set_trigger_volume_enable zone_set:set_cell_c_int FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_cell_c_int:* FALSE)
	(device_operates_automatically_set lock_c_entry_door 0)
	(device_set_position lock_c_entry_door 0)
	(sleep_until (<= (device_get_position lock_c_entry_door) 0))
	(device_set_power lock_c_entry_door 0)
	(ai_place test_cell_c_marines)
	(ai_place lock_c_ext_marines_rl)
	(ai_place tank_marines_scorpion)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_g" FALSE)
	(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) teleport_cell_c_tank)
	(ai_place tank_marines_hog)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_d" TRUE)
	(ai_place tank_marines_goose)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_d" TRUE)
	(device_set_position crater_entry_door 1)
	(ai_vehicle_enter lock_c_ext_marines_rl (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_p")
	(ai_enter_squad_vehicles all_allies)
	(sleep 1)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) teleport_tank_run_player0)
	(object_teleport (player1) teleport_tank_run_player1)
	(object_teleport (player2) teleport_tank_run_player2)
	(object_teleport (player3) teleport_tank_run_player3)
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)

		; set player pitch 
		(player0_set_pitch 10 0)
		(player1_set_pitch 10 0)
		(player2_set_pitch 10 0)
		(player3_set_pitch 10 0)

	(sleep 1)
	(player_disable_movement FALSE)
	
	(sleep 20)
	(wake br_citadel_03)
	
	(wake tank_drop_unreserve)
	
	(wake 100_title3)
	(cinematic_fade_to_title)
)