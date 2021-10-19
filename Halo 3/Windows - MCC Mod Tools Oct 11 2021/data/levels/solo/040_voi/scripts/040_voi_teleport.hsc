(script static void teleport_factoryA
	; set insertion point index 
	(set g_insertion_index 2)

	; switch to correct zone set
	(switch_zone_set intro_faa)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_intro)
	(object_create_folder crates_intro)
	(object_create_folder scenery_faa)
	(object_create_folder crates_faa)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_factorya_player0)
	(object_teleport (player1) teleport_factorya_player1)
	(object_teleport (player2) teleport_factorya_player2)
	(object_teleport (player3) teleport_factorya_player3)
	(sleep 1)

	; place allies 
	(ai_place intro_hog)
	(ai_place test_factoryA_init_allies 5)
	(sleep 1)
	(object_teleport (ai_vehicle_get_from_starting_location intro_hog/driver) teleport_factoryA_hog)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors test_factoryA_init_allies) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors test_factoryA_init_allies) 0))
)

(script static void teleport_lakebedA
	; set insertion point index
	(set g_insertion_index 3)

	; switch to correct zone set
	(switch_zone_set faa_lakea)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_intro)
	(object_create_folder crates_intro)
	(object_create_folder scenery_faa)
	(object_create_folder crates_faa)
	(object_create_folder scenery_laa)
	(object_create_folder crates_laa)
	(sleep 1)
	
	;setup
	(device_set_power lakebed_a_entry_switch 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_lakebeda_player0)
	(object_teleport (player1) teleport_lakebeda_player1)
	(object_teleport (player2) teleport_lakebeda_player2)
	(object_teleport (player3) teleport_lakebeda_player3)
	(sleep 1)

	; place allies 
	(ai_place intro_hog)
	(ai_place test_lakeA_init_allies 5)
	(ai_place tank_a_cov_ghosts 2)
	(sleep 1)
	(object_teleport (ai_vehicle_get_from_starting_location intro_hog/driver) teleport_lakeA_hog)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors test_lakeA_init_allies) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors test_lakeA_init_allies) 0))
)

(script static void teleport_factoryB
	; set insertion point index 
	(set g_insertion_index 4)

	; switch to correct zone set
	(switch_zone_set faa_lakea_fab)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_faa)
	(object_create_folder crates_faa)
	(object_create_folder scenery_laa)
	(object_create_folder crates_laa)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_factoryb_player0)
	(object_teleport (player1) teleport_factoryb_player1)
	(object_teleport (player2) teleport_factoryb_player2)
	(object_teleport (player3) teleport_factoryb_player3)
	(sleep 1)

	; place allies 
	(ai_place intro_hog)
	(ai_place test_factoryB_init_allies 3)
	(sleep 1)
	(object_teleport (ai_vehicle_get_from_starting_location intro_hog/driver) teleport_factoryb_hog)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors test_factoryB_init_allies) 0))
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors test_factoryB_init_allies) 0))
	
	(device_set_position factory_b_entry_door 1)
)

(script static void teleport_factoryBend
	(fade_in 0 0 0 0)
	(ai_erase_all)
	(switch_zone_set lakea_fab_lakeb)
	
	(sleep 1)
	
	(object_teleport (player0) factoryB_point03)
	(ai_place factory_b_allies01)
	(ai_place factory_b_injured)
	
	(sleep 1)
	(garbage_collect_now)
	(sleep 1)
	
	(sleep_forever intro)
	(sleep_forever intro_flyby)
	(sleep_forever factory_a_start)
	(sleep_forever lakebed_a_start)
	(sleep_forever br_int_01)
	(sleep_forever md_int_dead_01)
	(sleep_forever md_int_dead_02)
	;(sleep_forever md_int_storm)
	(set g_playing_dialogue FALSE)
	
	;open the door forward
	;(device_set_position factory_b_entry_but 1)
	;(device_set_power lakebed_a_entry_switch 0)
	;(device_set_power factory_b_entry_door 1)

	;buggers
	(sleep_until (volume_test_players vol_factory_b_buginit))
	(game_save)
	(wake bugger_spawn)
	(device_set_position tank_room_b_exit02 1)

	;Geese:
	(sleep_until (volume_test_players vol_factory_b_tunnel))
	(print "Mongoose Intro")
	(ai_place factory_b_allies_goose_init)
	(cs_run_command_script factory_b_allies_goose_init pause_forever)
	(ai_place factory_b_allies_goose_pass)
	(sleep_until (volume_test_players vol_factory_b_tunnel_end))
	(device_set_position factory_b_middle 0)
	(sleep_forever bugger_spawn)
	(wake lakebed_b_start)
	
	;dialog
	(wake objective_3_clear)
	(wake md_fab_goose)
	(wake objective_4_set)
	
	(sleep 60)
	(game_save)
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p")
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" TRUE)
)

(script static void teleport_lakebedb
	; set insertion point index 
	(set g_insertion_index 5)

	; switch to correct zone set
	(switch_zone_set fab_lakeb)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_fab)
	(object_create_folder crates_fab)
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	
	(device_group_set_immediate factory_b_middle_buttons 1)
	(device_set_position_immediate lakebed_b_entry_door 1)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_lakebedb_player0)
	(object_teleport (player1) teleport_lakebedb_player1)
	(object_teleport (player2) teleport_lakebedb_player2)
	(object_teleport (player3) teleport_lakebedb_player3)
	(sleep 1)

	; place allies
	(ai_place test_lake_b_hog)
	
	(ai_place factory_b_allies_goose_init)
	(cs_run_command_script factory_b_allies_goose_init pause_forever)
	(cs_run_command_script factory_b_allies_goose_init/goose04 abort)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p" TRUE)
	(ai_place factory_b_allies_goose_pass)
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p")
	
	;dialog
	(wake md_fab_goose)
	
	(game_save)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p" FALSE)
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p")
	;(cs_run_command_script factory_b_allies_goose_pass fab_goose_pass_cs)

)

(script static void teleport_scarab
	; set insertion point index 
	(set g_insertion_index 6)

	; switch to correct zone set
	(switch_zone_set scarab)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	
	(wake lakeb_BFG_go)
	(device_set_position_immediate lakebed_b_entry_door 0)
	(wake crane_ctrl)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_scarab_player0)
	(object_teleport (player1) teleport_scarab_player1)
	(object_teleport (player2) teleport_scarab_player2)
	(object_teleport (player3) teleport_scarab_player3)
	(sleep 1)
)

(script static void warp_left
	(object_teleport (player0) scarab_start_left)
	(cs_run_command_script scarab/driver01 scarab_present_left)
)

(script static void warp_right
	(object_teleport (player0) scarab_start_right)
	(cs_run_command_script scarab/driver01 scarab_present_right)
)

(script static void teleport_office
	; set insertion point index 
	(set g_insertion_index 7)

	; switch to correct zone set
	(switch_zone_set scarab)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_office_player0)
	(object_teleport (player1) teleport_office_player1)
	(object_teleport (player2) teleport_office_player2)
	(object_teleport (player3) teleport_office_player3)
	(sleep 1)

	(device_set_position_immediate lakebed_b_entry_door 0)
	(wake crane_ctrl)
)

(script static void teleport_warehouse
	; set insertion point index 
	(set g_insertion_index 8)

	; switch to correct zone set
	(switch_zone_set ware)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(object_create_folder scenery_worker)
	(object_create_folder crates_worker)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_warehouse_player0)
	(object_teleport (player1) teleport_warehouse_player1)
	(object_teleport (player2) teleport_warehouse_player2)
	(object_teleport (player3) teleport_warehouse_player3)
	(sleep 1)
	
	; place allies
	(ai_place test_ware_arbiter)
)

(script static void teleport_hunters
	(fade_in 0 0 0 0)
	(ai_erase_all)
	(switch_zone_set ware_worker)

	(sleep 1)

	(object_teleport (player0) teleport_hunters)

	(sleep 1)

	(garbage_collect_now)
	(game_save_immediate)

	(sleep 1)
	
	(sleep_forever intro)
	(sleep_forever intro_flyby)
	(sleep_forever factory_a_start)
	(sleep_forever lakebed_a_start)
	(sleep_forever br_int_01)
	(sleep_forever md_int_dead_01)
	(sleep_forever md_int_dead_02)
	;(sleep_forever md_int_storm)
	(set g_playing_dialogue FALSE)
	
	(wake warehouse_marine_spawner)
	(ai_place ware_cov_brutes02/chief)
	(sleep_until (volume_test_players vol_warehouse_hunters01))
	(ai_set_objective all_enemies worker_cov_obj)
	(sleep 1)
	(print "hunters")
	;(ai_place ware_cov_hunters)
	(sleep 60)
	(cs_run_command_script ware_cov_brutes02/chief warehouse_chieftain_cs)
	(game_save)
	(sleep_until (volume_test_players vol_worker_start))
	(wake worker_start)
	(sleep_until (<= (ai_living_count ware_cov_hunters) 0))
	(game_save)
)

(script static void teleport_worker
	; set insertion point index 
	(set g_insertion_index 9)

	; switch to correct zone set
	(switch_zone_set ware_worker)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(object_create_folder scenery_worker)
	(object_create_folder crates_worker)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_worker_player0)
	(object_teleport (player1) teleport_worker_player1)
	(object_teleport (player2) teleport_worker_player2)
	(object_teleport (player3) teleport_worker_player3)
	(sleep 1)
)

(script static void teleport_bfg
	; switch to correct zone set
	(switch_zone_set ware_worker)
	(sleep 1)
	
	; place objects
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(object_create_folder scenery_worker)
	(object_create_folder crates_worker)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_bfg_player0)
	(object_teleport (player1) teleport_bfg_player1)
	(object_teleport (player2) teleport_bfg_player2)
	(object_teleport (player3) teleport_bfg_player3)
	(sleep 1)
	
	; place allies
	(ai_place bfg_marines01)
	
	;BFG control
	(wake BFG_go)
	
	(sleep_until (= (current_zone_set_fully_active) 9) 1)
	; set insertion point index 
	(set g_insertion_index 10)
)

(script static void glass_test
	; switch to correct zone set
	(switch_zone_set faa_lakea_fab)
	(sleep 1)
	
	(object_teleport (player0) teleport_glass_test)
	(object_create bugger_glass_break)
)

(script static void objects
	(print "placing all objects")
	(object_create_folder scenery_intro)
	(object_create_folder crates_intro)
	(object_create_folder scenery_faa)
	(object_create_folder crates_faa)
	(object_create_folder scenery_laa)
	(object_create_folder crates_laa)
	(object_create_folder scenery_fab)
	(object_create_folder crates_fab)
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	(object_create_folder scenery_office)
	(object_create_folder crates_office)
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(object_create_folder scenery_worker)
	(object_create_folder crates_worker)
)