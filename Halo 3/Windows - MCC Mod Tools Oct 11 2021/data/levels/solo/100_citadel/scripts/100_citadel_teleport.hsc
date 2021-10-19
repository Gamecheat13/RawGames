(script static void teleport_beach
	; set insertion point index 
	(set g_insertion_index 2)

	; switch to correct zone set
	(switch_zone_set set_beach)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_beach_player0)
	(object_teleport (player1) teleport_beach_player1)
	(object_teleport (player2) teleport_beach_player2)
	(object_teleport (player3) teleport_beach_player3)
	
	;spawn enemies
	(ai_place beach_cov_aa)
	(cs_run_command_script beach_cov_aa/driver01 aa_shoot_cs)
	(ai_disregard (ai_actors beach_cov_aa) TRUE)
	(ai_place beach_inf_cov01_lead)
	(ai_place beach_inf_cov02)
	;(ai_place beach_inf_cov03)
	;(ai_place beach_cov_turrets01)
	(ai_place beach_cov_turrets02)
	
	;place allies
	(ai_place beach_inf_marines)
)

(script static void teleport_path_a
	; set insertion point index 
	(set g_insertion_index 3)

	; switch to correct zone set
	(switch_zone_set set_beach)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_path_a_player0)
	(object_teleport (player1) teleport_path_a_player1)
	(object_teleport (player2) teleport_path_a_player2)
	(object_teleport (player3) teleport_path_a_player3)
)

(script static void teleport_cell_a
	; set insertion point index 
	(set g_insertion_index 4)

	; switch to correct zone set
	(switch_zone_set set_beach)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_cell_a_player0)
	(object_teleport (player1) teleport_cell_a_player1)
	(object_teleport (player2) teleport_cell_a_player2)
	(object_teleport (player3) teleport_cell_a_player3)
	(sleep 1)

	;place allies
	(ai_place patha_hog 1)
	(ai_place patha_goose)
	(ai_place test_cell_a_marines)
	(object_teleport (ai_vehicle_get_from_starting_location patha_hog/warthog01) teleport_cell_a_hog)
	(object_teleport (ai_vehicle_get_from_starting_location patha_goose/goose01) teleport_cell_a_goose)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_hog/warthog01) "warthog_g" (ai_get_object test_cell_a_marines/01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location patha_goose/goose01) "mongoose_d" (ai_get_object test_cell_a_marines/02))
	
	(ai_set_objective all_allies cell_a_marines_obj)
)

(script static void teleport_lock_a
	; set insertion point index 
	(set g_insertion_index 5)

	; switch to correct zone set
	(switch_zone_set set_cell_a_int)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(object_create_folder crates_locka)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_lock_a_player0)
	(object_teleport (player1) teleport_lock_a_player1)
	(object_teleport (player2) teleport_lock_a_player2)
	(object_teleport (player3) teleport_lock_a_player3)
	
	;place allies
	(ai_place test_lock_a_marines)
	(ai_place cella_pelicans)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cella_pelicans/driver01) TRUE)
	(cs_run_command_script cella_pelicans/driver01 pelican_arrival_cs)
	
	(ai_set_task_condition cell_a_marines_obj/advance TRUE)
	(flock_start cella_hornets)
	(set g_celltaken TRUE)
	
	(sleep_until (volume_test_players vol_lock_a01_migrate) 5)
	(print "exiting vehicles")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_goose/goose01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location patha_hog/warthog01) TRUE)
	(ai_vehicle_exit ground_allies)
	;(ai_set_objective cell_a_marines_obj/advance_inf lock_a_marines_obj)
	(ai_set_objective ground_allies lock_a_marines_obj)
)

(script static void teleport_plasma

	; switch to correct zone set
	(switch_zone_set set_cell_a_int)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_lock_a_player0)
	(object_teleport (player1) teleport_lock_a_player1)
	(object_teleport (player2) teleport_lock_a_player2)
	(object_teleport (player3) teleport_lock_a_player3)
	
	(ai_place test_plasma)
)

(script static void teleport_lock_a2
	(sleep_forever Intro_Start)
	(sleep_forever Beach_Start)
	(ai_erase_all)
	(switch_zone_set set_cell_a_int02)
	(sleep 1)
	(device_group_set_immediate tower1_lift 1)
	(object_teleport (player0) teleport_lock_a02)
	;(device_set_position_immediate tower1_elevator 1)
	(garbage_collect_now)
	(game_save_immediate)
	
	(ai_place lock_a02_cov_lead)
	;(cs_run_command_script lock_a02_cov_lead locka02_init_cs)
	(ai_place lock_a02_cov02)
	;(cs_run_command_script lock_a02_cov02 locka02_init_cs)
	(vs_custom_animation lock_a02_cov_lead/chief01 FALSE objects\characters\brute\brute "combat:hammer:cheer" FALSE)
	(vs_custom_animation lock_a02_cov_lead/bodyguard01 FALSE objects\characters\brute\brute "act_kneel_1:idle" FALSE)
	(vs_custom_animation lock_a02_cov_lead/bodyguard02 FALSE objects\characters\brute\brute "act_kneel_1:idle" FALSE)
	(vs_custom_animation lock_a02_cov02 FALSE objects\characters\brute\brute "act_kneel_1:idle" FALSE)
	;(ai_place lock_a02_cov03)
	(sleep_until (<= (ai_living_count lock_a02_cov_obj) 0))
	(device_set_power tower1_switch 1)
	(device_set_power tower1_holo 1)
	(sleep_until (> (device_get_position tower1_holo) 0))
	(wake objective_1_clear)
	(set g_tower1 TRUE)
	(ai_disposable cella_pelicans TRUE)
	(ai_disposable patha_hog TRUE)
	(ai_disposable patha_goose TRUE)
	
	(if g_play_cinematics
		(begin
			(Camera_control ON)
			(Cinematic_start)
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(100pa_first_tower)
			(object_teleport (player0) pers_towerA_player0)
			(object_teleport (player1) pers_towerA_player0)
			(object_teleport (player2) pers_towerA_player0)
			(object_teleport (player3) pers_towerA_player0)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
			(Cinematic_stop)
			(Camera_control OFF)
		)
	)
	
	(print "good job chief... tower 1 is active")
	(sleep 60)
	(print "Tower 2 is active")
	(sleep 60)
	(print "Tower three is still inactive... report back to the beach")
	(game_save)
	(sleep_until (volume_test_players vol_lock_a03_start))
	(ai_place lock_a03_cov01)
	(ai_place lock_a03_marines01)
	(sleep_until (volume_test_players vol_lock_a03_migrate))
	(ai_set_objective all_allies cell_a_marines_obj)
)

(script static void teleport_cell_b
	; set insertion point index 
	(set g_insertion_index 6)
	
	; switch to correct zone set
	(switch_zone_set set_beach)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(sleep 1)
	
	;setup
	(set g_tower1 TRUE)
	
	;place ai
	(wake spawn_air_forces)
	(sleep 10)
	
	; teleport players to the proper location
	(print "teleport players")
	(object_teleport (player0) teleport_cell_b_player0)
	(object_teleport (player1) teleport_cell_b_player1)
	(object_teleport (player2) teleport_cell_b_player2)
	(object_teleport (player3) teleport_cell_b_player3)
)

(script static void teleport_hornets02
	(set g_insertion_index 7)
	(switch_zone_set set_waterfront)
	(sleep 1)
	
	; place objects
	(object_destroy_folder crates_cellc)
	(object_destroy_folder crates_lockc)
	(object_create_folder crates_crater)
	(sleep 1)
	
	(ai_place test_cell_c_hornets02)
	(ai_place test_cell_c_pelican01)
	(ai_place test_cell_c_pelican02)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location test_cell_c_hornets02/driver01) "hornet_d" (player0))
	
	(sleep_until (not (any_players_in_vehicle)))
	(ai_place test_cell_c_hornets01)
)

(script static void teleport_cell_b_old
	; set insertion point index 
	(set g_insertion_index 6)

	; switch to correct zone set
	(switch_zone_set set_cell_a_int)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(object_create_folder crates_locka)
	(sleep 1)
	
	; teleport players to the proper location
	(print "teleport players")
	(object_teleport (player0) teleport_cell_b_player0x)
	(object_teleport (player1) teleport_cell_b_player1x)
	(object_teleport (player2) teleport_cell_b_player2x)
	(object_teleport (player3) teleport_cell_b_player3x)
	
	(set g_tower1 TRUE)
	(wake br_tower03_02)
	(flock_start cella_hornets)
	
	;place allies
	(wake cell_b_hog_goose)
	(ai_place test_cell_b_marines)
	(object_create_containing "tower1_supplies")
	(ai_place cell_a_pelican_supply)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cell_a_pelican_supply/driver01) TRUE)
	(cs_run_command_script cell_a_pelican_supply/driver01 pause_forever)
	(ai_place cell_a_marine_supply)
	(ai_place cell_a_marine_supply02)
)

(script static void teleport_cell_c
	; set insertion point index 
	(set g_insertion_index 7)

	; switch to correct zone set
	(switch_zone_set set_cell_c_int)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_lockc)
	(object_create_folder crates_ice)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_cell_c_player0)
	(object_teleport (player1) teleport_cell_c_player1)
	(object_teleport (player2) teleport_cell_c_player2)
	(object_teleport (player3) teleport_cell_c_player3)
)

(script static void teleport_lock_c
	; set insertion point index 
	(set g_insertion_index 8)

	; switch to correct zone set
	(switch_zone_set set_cell_c_int)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_cellc)
	(object_create_folder crates_lockc)
	(object_create_folder crates_ice)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_lock_c_player0)
	(object_teleport (player1) teleport_lock_c_player1)
	(object_teleport (player2) teleport_lock_c_player2)
	(object_teleport (player3) teleport_lock_c_player3)

	;place allies
	(ai_place test_lock_c_elites)
	(ai_place test_lock_c_arbiter)
	
	(set g_tower1 TRUE)
)

(script static void teleport_lock_c2
	(switch_zone_set set_cell_c_int02)
	
	(sleep 1)

	(device_set_position_immediate tower3_elevator 1)
	(sleep 1)
	(object_teleport (player0) teleport_lock_c02)
	(garbage_collect_now)
	(game_save_immediate)
	(ai_place lock_c02_cov01)
	(ai_place lock_c02_cov02a)
	(ai_place lock_c02_cov02b)
	(cs_run_command_script lock_c02_cov01 lockc02_init_cs)
	(cs_run_command_script lock_c02_cov02a lockc02_init_cs)
	(cs_run_command_script lock_c02_cov02b lockc02_init_cs)
	;(unit_set_active_camo lock_c02_cov02 TRUE 1)
	(sleep_until (<= (ai_living_count lock_c02_cov_obj) 0))
	(device_set_power tower3_switch 1)
	(device_set_power tower3_holo 1)
	(sleep_until (> (device_get_position tower3_holo) 0))
	(wake objective_2_clear)
	(set g_tower3 TRUE)
	(if g_play_cinematics
		(begin
			(object_hide (player0) TRUE)
			(object_hide (player1) TRUE)
			(object_hide (player2) TRUE)
			(object_hide (player3) TRUE)
			(Camera_control ON)
			(Cinematic_start)
			(100lb_hc_crash)
			(Cinematic_stop)
			(Camera_control OFF)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
		)
		;else
		(begin
			(print "skipping '100lb_hc_crash' cinematic")
		)
	)
	(wake objective_3_set)
	(print "good job chief... tower 3 is active")
	(sleep 60)
	(print "Report back outside to lead assault on the citadel")
	(sleep 60)
	(print "*High Charity crashes*")
	(game_save)
	(ai_place lock_c03_flood01)
	(ai_place lock_c03_flood02)
	(sleep_until (volume_test_players vol_lock_c02_init))
	(ai_place lock_c04_marines)
	(ai_place lock_c04_flood01)
	(wake lock_c04_flood_respawn)
	(sleep_until (volume_test_players vol_lock_c04_exit))
	(ai_place lock_c04_flood03)
)

(script static void teleport_flood
	(sleep_forever Intro_Start)
	(sleep_forever Beach_Start)
	(ai_erase_all)
	(switch_zone_set set_cell_c_int02)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_cellc)
	(object_create_folder crates_lockc)
	(object_create_folder crates_ice)
	(sleep 1)

	(object_teleport (player0) cin_towerC_player0)
	(object_teleport (player1) cin_towerC_player1)
	(object_teleport (player2) cin_towerC_player2)
	(object_teleport (player3) cin_towerC_player3)
	(garbage_collect_now)
	(sleep 1)
	(device_set_position_immediate tower3_elevator 1)
	(game_save_immediate)
	(print "*High Charity crashes*")
	(ai_place lock_c03_flood01)
	(ai_place lock_c03_flood02)
	(sleep_until (volume_test_players vol_lock_c01_start))
	(ai_place lock_c04_flood01)
	(sleep 120)
	(ai_place lock_c04_flood02)
	(game_save)
	(wake TankRun_Start)
)

(script static void teleport_flood02
	(sleep_forever Intro_Start)
	(sleep_forever Beach_Start)
	(ai_erase_all)
	(switch_zone_set set_cell_c_int)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_cellc)
	(object_create_folder crates_lockc)
	(object_create_folder crates_ice)
	(sleep 1)

	(object_teleport (player0) teleport_flood02)
	(set g_tower3 1)
	(set g_insertion_index 9)
	(garbage_collect_now)
	(sleep 1)
	(game_save_immediate)
	(ai_place lock_c04_marines)
	(ai_place lock_c04_flood01)
	(wake lock_c04_flood_respawn)
	(sleep_until (volume_test_players vol_lock_c04_exit))
	(ai_place lock_c04_flood03)
)

(script static void teleport_tank_run
	; set insertion point index 
	(set g_insertion_index 9)

	; switch to correct zone set
	(switch_zone_set set_cell_ice)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_cellc)
	(object_create_folder crates_ice)
	(sleep 1)
	
	;setup
	(set g_tower3 TRUE)
	(zone_set_trigger_volume_enable zone_set:set_cell_c_int FALSE)
	(device_operates_automatically_set lock_c_entry_door 0)
	(device_set_position lock_c_entry_door 0)
	(sleep_until (<= (device_get_position lock_c_entry_door) 0))
	(device_set_power lock_c_entry_door 0)
	(ai_place test_cell_c_marines)
	(ai_place lock_c_ext_marines_rl)
	;(ai_place test_cell_c_tank)
	(ai_place tank_marines_scorpion)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) "scorpion_d" TRUE)
	(object_teleport (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01) teleport_cell_c_tank)
	(ai_place tank_marines_hog)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "warthog_d" TRUE)
	(ai_place tank_marines_goose)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_d" TRUE)
	(device_set_position crater_entry_door 1)
	(ai_vehicle_enter lock_c_ext_marines_rl (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "mongoose_p")
	(ai_enter_squad_vehicles all_allies)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(unit_add_equipment (player0) chief_1p_respawn TRUE TRUE)
	(unit_add_equipment (player1) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player2) dervish_respawn TRUE TRUE)
	(unit_add_equipment (player3) dervish_respawn TRUE TRUE)
	(object_teleport (player0) teleport_tank_run_player0)
	(object_teleport (player1) teleport_tank_run_player1)
	(object_teleport (player2) teleport_tank_run_player2)
	(object_teleport (player3) teleport_tank_run_player3)
	
	(sleep 20)
	(wake br_citadel_03)
	
	(sleep_until (any_players_in_vehicle))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location  tank_marines_scorpion/scorpion01) "" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_goose/driver01) "" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location tank_marines_hog/driver01) "" FALSE)
	(sleep 1)
	(ai_enter_squad_vehicles all_allies)
)

(script static void teleport_crater
	; set insertion point index 
	(set g_insertion_index 10)

	; switch to correct zone set
	(switch_zone_set set_crater)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_ice)
	(object_create_folder crates_lockc)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_crater_player0)
	(object_teleport (player1) teleport_crater_player1)
	(object_teleport (player2) teleport_crater_player2)
	(object_teleport (player3) teleport_crater_player3)
	
	; place allies
	;(ai_place test_crater_hog)
	;(ai_place test_crater_tank)
)

(script static void teleport_ring
	; switch to correct zone set
	(switch_zone_set set_citadel_tapestry)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_ring)
	(object_create_folder scenery_ring)
	(sleep 1)
	
	(cinematic_fade_to_black)
	(ai_erase crater_arbiter)
	(sleep 1)
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	(ai_allegiance flood player)
	(ai_allegiance player flood)
	(ai_allegiance flood human)
	(ai_allegiance human flood)
	(ai_allegiance flood covenant)
	(ai_allegiance covenant flood)
	(object_destroy rind_elevator_start)
	(object_destroy truth_flood)
	
	(set g_cinematic_running TRUE)
	
	; set insertion point index 
	(set g_insertion_index 11)
	
	(print "Segment:Cinematic:100lc_miranda")
	(data_mine_set_mission_segment "100lc_Miranda")
	
	(if g_play_cinematics
		(begin
			(if (cinematic_skip_start)
				(begin
					; snap to black 
					(cinematic_snap_to_black)
					
					(if debug (print "100lc_miranda"))
					(100lc_miranda)
	
					; prepare to switch to set_chief_crater 
					(prepare_to_switch_to_zone_set set_citadel_ring)
					
						(if (cinematic_skip_start)
							(begin
								(if debug (print "100lc_miranda_part2"))
								(100lc_miranda_part2)
								
								; switch to set_chief_crater 
								(switch_zone_set set_citadel_ring)
								(sleep 1)
								
									(if (cinematic_skip_start)
										(begin
											(if debug (print "100lc_miranda_part3"))
											(100lc_miranda_part3)
										)
									)
							)
						)
				)
			)
			(cinematic_skip_stop)
			(object_teleport (player0) teleport_ring_player0)
			(object_teleport (player1) teleport_ring_player1)
			(object_teleport (player2) teleport_ring_player2)
			(object_teleport (player3) teleport_ring_player3)
			(object_hide (player0) FALSE)
			(object_hide (player1) FALSE)
			(object_hide (player2) FALSE)
			(object_hide (player3) FALSE)
		)
		;else
		(begin
			(print "skipping '100lc_miranda' cinematic")
			(object_teleport (player0) teleport_ring_player0)
			(object_teleport (player1) teleport_ring_player1)
			(object_teleport (player2) teleport_ring_player2)
			(object_teleport (player3) teleport_ring_player3)
		)
	)
	
	(switch_zone_set set_citadel_ring)
	(sleep 1)
	(object_set_region_state rose_window window destroyed)
	
	(print "design:lighting rings")
	(object_set_function_variable haloring_alpha bloom .3 0)
	(object_set_function_variable haloring_beta bloom .3 0)
	(object_set_function_variable haloring_gamma bloom .3 0)
	(object_set_function_variable haloring_delta bloom .3 0)
	(object_set_function_variable haloring_epsilon bloom .3 0)
	(object_set_function_variable haloring_eta bloom .3 0)
	(object_set_function_variable haloring_zeta bloom .3 0)
	
	(set g_cinematic_running FALSE)
	(game_save_immediate)
	(cinematic_fade_to_title)
)

(script static void teleport_ring02
	(switch_zone_set set_citadel_ring)	
	(sleep 1)
	
	; place objects
	(object_create_folder crates_ring)
	(object_create_folder scenery_ring)
	(sleep 1)
	
	(object_teleport (player0) teleport_ring02)
	(ai_place ring_arbiter)
	(ai_cannot_die ring_arbiter TRUE)
	(ai_teleport ring_arbiter citadel_pts/teleport_ring02b)
	(ai_set_objective ring_arbiter ring02_marines_obj)
	(ai_allegiance flood player)
	(ai_allegiance player flood)
	(ai_allegiance flood human)
	(ai_allegiance human flood)
	(ai_allegiance flood covenant)
	(ai_allegiance covenant flood)
	(garbage_collect_now)
	(wake ring02_start)
	(game_save_immediate)
)

(script static void teleport_ring03
	(sleep_forever Intro_Start)
	(sleep_forever Beach_Start)
	(wake Beach_cleanup)
	(ai_erase_all)
	(switch_zone_set set_citadel_ring)	
	(sleep 1)
	
	; place objects
	(object_create_folder crates_ring)
	(object_create_folder scenery_ring)
	(sleep 1)
	
	(object_teleport (player0) teleport_ring03)
	(ai_place ring_arbiter)
	(ai_cannot_die ring_arbiter TRUE)
	(ai_teleport ring_arbiter citadel_pts/teleport_ring03b)
	(ai_allegiance flood player)
	(ai_allegiance player flood)
	(ai_allegiance flood human)
	(ai_allegiance human flood)
	(ai_allegiance flood covenant)
	(ai_allegiance covenant flood)
	(garbage_collect_now)
	(wake ring03_start)
	(game_save_immediate)
)

(script static void teleport_ring_exit
	; set insertion point index 
	(set g_insertion_index 12)

	; switch to correct zone set
	(switch_zone_set set_citadel_ring)
	(sleep 1)
	
	; place objects
	(object_create_folder crates_ring)
	(object_create_folder scenery_ring)
	(sleep 1)
	
	(object_destroy holo_truth01right)
	(object_destroy holo_truth01left)
	(object_destroy holo_throne01right)
	(object_destroy holo_throne01left)
	(object_destroy holo_truth02right)
	(object_destroy holo_truth02left)
	(object_destroy holo_throne02right)
	(object_destroy holo_throne02left)
	(object_create lightbridge_ringroom)
	(set g_truthdead TRUE)
	(device_set_power ring_door03a 1)
	(device_set_position_immediate citadel_dias 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_ring_exit_player0)
	(object_teleport (player1) teleport_ring_exit_player1)
	(object_teleport (player2) teleport_ring_exit_player2)
	(object_teleport (player3) teleport_ring_exit_player3)
	
	(device_set_position_immediate citadel_elevator_sm_01 1)
)

(script static void cellapelican
	(set g_celltaken TRUE)
	(ai_place cella_pelicans)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cella_pelicans/driver01) TRUE)
	(cs_run_command_script cella_pelicans/driver01 pelican_arrival_cs)
	(object_create cell_a_rack)
	(objects_attach (ai_vehicle_get_from_starting_location cella_pelicans/driver01) "pelican_sc_01" cell_a_rack "pin")
	(object_create cell_a_capsule01)
	(objects_attach cell_a_rack "rack01" cell_a_capsule01 "pelican_attach")
	(object_create cell_a_capsule02)
	(objects_attach cell_a_rack "rack02" cell_a_capsule02 "pelican_attach")
	(object_create cell_a_capsule03)
	(objects_attach cell_a_rack "rack03" cell_a_capsule03 "pelican_attach")
	(object_create cell_a_capsule04)
	(objects_attach cell_a_rack "rack04" cell_a_capsule04 "pelican_attach")
)

(script static void orbital_test
	; switch to correct zone set
	(switch_zone_set set_crater)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_crater_player0)
	
	(sleep_until
		(begin
			(ai_place crater_cov_scarab01)
			(vs_custom_animation crater_cov_scarab01/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_b_1" FALSE)
			(ai_place crater_cov_scarab02)
			(vs_custom_animation crater_cov_scarab02/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_a_1" FALSE)
			(sleep (unit_get_custom_animation_time (ai_get_unit crater_cov_scarab02/driver01)))
			(vs_stop_custom_animation crater_cov_scarab02/driver01)
			(ai_force_active crater_cov_scarab02/driver01 TRUE)
			(sleep 10)
			(print "killing all ai")
			(ai_erase_all)
			FALSE
		)
	)
)

(script static void 100pa_test
	(switch_zone_set set_cell_a_int02)
	(sleep 1)
	
	(object_teleport (player0) 100pa_teleport)
	(sleep 30)
	
	(perspective_start)
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	(100pa_first_tower)
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
	(perspective_stop)
)

(script static void objects
	(print "placing all objects")
	(object_create_folder scenery_beach)
	(object_create_folder crates_beach)
	(object_create_folder crates_patha)
	(object_create_folder scenery_cella)
	(object_create_folder crates_cella)
	(object_create_folder crates_locka)
	(object_create_folder crates_cellc)
	(object_destroy_folder crates_cellb_covdrop)
	(object_create_folder crates_lockc)
	(object_create_folder crates_ice)
	(object_create_folder crates_crater)
	(object_create_folder scenery_ring)
	(object_create_folder crates_ring)
)

(script static void undumb
	(ai_set_task_condition cell_a_cov_obj/dumb_init FALSE)
)