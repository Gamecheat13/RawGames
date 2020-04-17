; =================================================================================================
; m10 INSERTION SCRIPT
; =================================================================================================
(global short zoneset_all 22)


; intro 1stbowl
; =================================================================================================
(script static void ins_1stbowl
	(print "insertion point : 1st bowl")
	(if (or editor_cinematics (not (editor_mode)))
		(begin
			(print "switching zone sets:zoneset_intro_cinematic")
			(switch_zone_set zoneset_intro_cinematic)
			(sleep_until (= (current_zone_set_fully_active) 0) 1)
			;(prepare_to_switch_to_zone_set zoneset_insert)
		)
		(begin
			(print "switching zone sets for editor")
			(switch_zone_set zoneset_insert)
			(sleep_until (= (current_zone_set_fully_active) 1) 1)
		)
	)
	
	(set g_insertion_index 0)

)


; intro barn
; =================================================================================================
(script static void ins_barn
	(print "insertion point : barn")
	(set g_insertion_index 1)
	
	; Snap out
	;(cinematic_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) 3)
		(begin
			(print "switching zone sets...")
			(switch_zone_set zoneset_barn)
			(sleep_until (= (current_zone_set_fully_active) 3) 1)
		)	
	)
	
	(ai_place barn_carter)
	(ai_place barn_kat)
	(ai_place barn_jorge)
	(ai_place barn_emile)
	
	(set obj_carter barn_carter/carter)
	(set obj_kat barn_kat/kat)
	(set obj_jorge barn_jorge/jorge)
	(set obj_emile barn_emile/emile)
	
	(ai_cannot_die group_spartans TRUE)
	(ai_disregard (ai_actors group_jun) TRUE)
		
	; Teleport
	(object_teleport_to_ai_point (player0)  ps_teleports/barn01)
	(object_teleport_to_ai_point (player1)  ps_teleports/barn02)
	(object_teleport_to_ai_point (player2)  ps_teleports/barn03)
	(object_teleport_to_ai_point (player3)  ps_teleports/barn04)
	
	(print "ai placed")
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) pts_1stbowl/air_support00h)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn)
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	
	; weather
	(wake rain_start)
	
	; combat dialog
	(ai_dialogue_enable FALSE)
	
	(cinematic_fade_to_gameplay)
	(wake obj_start)
	(game_save_immediate)
)


; meadow
; =================================================================================================
(script static void ins_meadow
	(print "insertion point : meadow")
	(set g_insertion_index 2)
	
	; Snap out
	;(cinematic_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) zoneset_all)
		(begin
			(print "switching zone sets...")
			(switch_zone_set zoneset_barn_outro)
			(sleep_until (= (current_zone_set_fully_active) 4) 1)
		)	
	)
	
	(ai_place spartan_carter/carter_barn)
	(ai_place spartan_kat/kat_barn)
	(ai_place spartan_emile/emile_barn)
	(ai_place spartan_jorge/jorge_barn)
	
	(set obj_carter (ai_get_unit spartan_carter/carter_barn))
	(set obj_kat (ai_get_unit spartan_kat/kat_barn))
	(set obj_emile (ai_get_unit spartan_emile/emile_barn))
	(set obj_jorge (ai_get_unit spartan_jorge/jorge_barn))
	
	(ai_cannot_die group_spartans TRUE)
	(ai_disregard (ai_actors group_jun) TRUE)

	(ai_set_objective all_humans obj_meadow_hum)
		
	; Teleport
	(object_teleport (player0) flag_teleport_meadow00)
	(object_teleport (player1) flag_teleport_meadow01)
	(object_teleport (player2) flag_teleport_meadow02)
	(object_teleport (player3) flag_teleport_meadow03)
	
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/barn)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) ps_air_meadow/falcon_barn_entry)
	;(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn)
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn_combat_done)
	
	(ai_place barn_skirm02)
	(ai_set_objective barn_skirm02 obj_meadow_cov)
	
	; weather
	(wake rain_barn_start)
	
	(sleep 60)
	(cinematic_fade_to_gameplay)
	
	;(unit_kill v_meadow_hog)
	
	(set g_ui_obj_control 10)
	(wake obj_start)
	(game_save_immediate)
)




; 3kiva
; =================================================================================================
(script static void ins_3kiva
	(print "insertion point : 3kiva")
	(set g_insertion_index 3)
	
	; Snap out
	;(cinematic_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) zoneset_all)
		(begin
			(print "switching zone sets...")
			(switch_zone_set zoneset_barn_outro)
			(sleep_until (= (current_zone_set_fully_active) 4) 1)
		)	
	)
	
	; Teleport
	(object_teleport_to_ai_point (player0)  ps_teleports/3kiva01)
	(object_teleport_to_ai_point (player1)  ps_teleports/3kiva02)
	(object_teleport_to_ai_point (player2)  ps_teleports/3kiva03)
	(object_teleport_to_ai_point (player3)  ps_teleports/3kiva04)
	
	
	(ai_place spartan_carter/3kiva)
	(ai_place spartan_jorge/3kiva)
	(ai_set_objective group_carter obj_3kiva_hum)
	(ai_set_objective group_jorge obj_3kiva_hum)
	
	(ai_cannot_die group_spartans TRUE)
	(ai_disregard (ai_actors group_jun) TRUE)
	
	(set obj_carter (ai_get_unit group_carter))
	(set obj_jorge (ai_get_unit group_jorge))
	
	; spartans waypoints
	(if (not (game_is_cooperative))
		(spartan_waypoints)
	)
	
	; weather
	(wake rain_barn_start)
	
	; falcon
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/3kiva)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	
	; soft ceilings
	(soft_ceiling_enable player_blocker_end TRUE)

	;(cinematic_fade_to_gameplay)
	(insertion_fade_to_gameplay)
	
	(set g_ui_obj_control 20)
	(wake obj_start)
	(wake barn_bodies_door)
	
	; music
	(wake music_alpha)
	
	(game_save_immediate)
)


; outpost_intro
; =================================================================================================
(script static void ins_outpost_ext
	(print "insertion point : outpost")
	(set g_insertion_index 4)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) zoneset_all)
		(begin
			(print "switching zone sets...")
			(switch_zone_set zoneset_outpost_intro)
			(sleep_until (= (current_zone_set_fully_active) 6) 1)
		)
	)
	
	; Teleport
	(object_teleport_to_ai_point (player0)  ps_teleports/outpost01)
	(object_teleport_to_ai_point (player1)  ps_teleports/outpost02)
	(object_teleport_to_ai_point (player2)  ps_teleports/outpost03)
	(object_teleport_to_ai_point (player3)  ps_teleports/outpost04)
	
	(ai_place spartan_carter/outpost)
	(set obj_carter (ai_get_unit spartan_carter/outpost))
	(ai_place spartan_jorge/outpost)
	(set obj_jorge (ai_get_unit spartan_jorge/outpost))
	
	(ai_cannot_die group_spartans TRUE)
	
	(ai_set_objective group_carter obj_outpost_ext_hum)
	(ai_set_objective group_jorge obj_outpost_ext_hum)
	
	; spartans waypoints
	(if (not (game_is_cooperative))
		(spartan_waypoints)
	)
	
	; weather
	(wake rain_outpost_start)
	
	; soft ceilings
	(soft_ceiling_enable all FALSE)
	(soft_ceiling_enable player_blocker_end TRUE)
	
	(sleep 30)
	(insertion_fade_to_gameplay)
	(set g_ui_obj_control 60)
	(wake obj_start)
	
	; music
	(wake music_bravo)
	
	(game_save_immediate)
)


; outpost_interior
; =================================================================================================
(script static void ins_outpost_int
	(print "insertion point : outpost")
	(set g_insertion_index 5)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) zoneset_all)
		(begin
			(print "switching zone sets...")
			(switch_zone_set zoneset_outpost_interior)
			(sleep_until (= (current_zone_set_fully_active) 7) 1)
		)
	)
	
	; Teleport
	(object_teleport_to_ai_point (player0)  ps_teleports/outpost_int01)
	(object_teleport_to_ai_point (player1)  ps_teleports/outpost_int02)
	(object_teleport_to_ai_point (player2)  ps_teleports/outpost_int03)
	(object_teleport_to_ai_point (player3)  ps_teleports/outpost_int04)
	
	(set g_outpost_ext_obj_control 30)
	
	(ai_place spartan_carter/outpost_int)
	(ai_place spartan_kat/outpost)
	(ai_place spartan_jorge/outpost_int)
	(ai_place spartan_emile/outpost)
	
	
	(set obj_carter (ai_get_unit spartan_carter/outpost_int))
	(set obj_kat (ai_get_unit spartan_kat/outpost))
	(set obj_jorge (ai_get_unit spartan_jorge/outpost_int))
	(set obj_emile (ai_get_unit spartan_emile/outpost))
	
	(ai_cannot_die group_spartans TRUE)
	
	(ai_set_objective group_spartans obj_outpost_ext_hum)
	(ai_set_objective group_carter obj_outpost_ext_hum)
	(ai_set_objective group_kat obj_outpost_ext_hum)
	(ai_set_objective group_jorge obj_outpost_ext_hum)
	
	(set g_outpost_ext_obj_control 40)
	(set g_ui_obj_control 80)
	(wake obj_start)
	
	; door setup
	(device_set_position_immediate dm_outpost_door01 0)
	
	; soft ceilings
	(soft_ceiling_enable all FALSE)
	(soft_ceiling_enable player_blocker_end TRUE)
	
	(device_set_power dm_outpost_blastdoor 1)
	(sleep 1)
	(device_set_position_immediate dm_outpost_blastdoor .45)
	(sleep 1)
	(device_set_position dm_outpost_blastdoor 0)
	(cinematic_fade_to_gameplay)
	(game_save_immediate)
	
	(sleep 1)
	(thespian_performance_setup_and_begin vig_outpost_rally "" 0)
	
	(sleep_until (= (device_get_position dm_outpost_blastdoor) 0))
	(device_set_power dm_outpost_blastdoor 0)
	(sleep 60)
	
	(sleep_until (>= g_outpost_ext_obj_control 50) 1 200)
	(device_set_position dm_outpost_door01 1)
	(sleep 40)
	(thespian_performance_kill_by_ai group_spartans)
	;(ai_set_objective group_spartans obj_outpost_int_hum)
	(ai_set_objective group_carter obj_outpost_int_hum)
	(ai_set_objective group_kat obj_outpost_int_hum)
	(ai_set_objective group_jorge obj_outpost_int_hum)
	
	(wake ct_training_nightvision02_start)
	
)


; blank
; =================================================================================================
(script static void ins_blank
	(print "insertion point : blank")
	
	;(switch_zone_set zoneset_1stbowl)
	;(sleep_until (= (current_zone_set_fully_active) 2) 1)
	(cinematic_fade_to_gameplay)
	(game_save_immediate)
)