;====================================================================================================================================================================================================
; General ==============================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor_cinematics 0)
(global boolean editor_object_management 0)

(global boolean b_player_spotted_beacon FALSE)
(global boolean b_training_look_done FALSE)

(global short 3kiva_bsp 1)
;(global short obj_control 1)

; objective control global shorts
(global short g_1stbowl_obj_control 1)
(global short g_barn_obj_control 1)
(global short g_meadow_obj_control 1)
(global short g_3kiva_obj_control 1)
(global short g_outpost_int_obj_control 1)
(global short g_outpost_ext_obj_control 1)

(global short g_wildlife_control 1)

(global object obj_carter NONE)
(global object obj_kat NONE)
(global object obj_jorge NONE)
(global object obj_emile NONE)
(global object obj_jun NONE)

(global ai squad_carter NONE)
(global ai squad_kat NONE)
(global ai squad_jorge NONE)
(global ai squad_emile NONE)
(global ai squad_jun NONE)

(global object obj_pickup NONE)

(global boolean skirmisher_report FALSE)
(global boolean warthog_done FALSE)
(global boolean beacon_done FALSE)

(global boolean 3kiva01_done FALSE)
(global boolean 3kiva02_done FALSE)
(global boolean 3kiva03_done FALSE)
(global boolean 3kiva01_visited FALSE)
(global boolean 3kiva02_visited FALSE)
(global boolean 3kiva03_visited FALSE)

(global boolean 3kiva_jun_is_obj FALSE)

(global short 3kiva_objective_count 1)
(global short 3kiva_troopers_bsp 0)
(global short 3kiva_jun_bsp 0)

(global boolean 3kiva_troopers_spoted FALSE)
(global boolean 3kiva_troopers_found FALSE)
(global boolean 3kiva_jun_spoted FALSE)
(global boolean 3kiva_jun_found FALSE)

(global boolean 3kiva_done FALSE)

(global short b_waypoint_time (* 30 120))
;(global short b_waypoint_time (* 30 10))

; Insertion
(global short g_insertion_index -1)

(script command_script sleep_cs
	(sleep_forever)
)

(script command_script abort_cs
	(sleep 1)
)

(script static void branch_kill
	(print "branch kill")
)

(script command_script cs_looking_targeting
	(cs_enable_targeting  TRUE)
	(cs_enable_looking TRUE)
	(sleep_forever)
)

(script static void (bring_spartans_forward (short dist))
	(print "bring forward: spartan")
	(ai_bring_forward group_carter dist)
	(ai_bring_forward group_kat dist)
	(ai_bring_forward group_jun dist)
	(ai_bring_forward group_emile dist)
	(ai_bring_forward group_jorge dist)
)


;*********************************************************************;
;Main Script
;*********************************************************************;
(script startup m10	
	(print "M10 go!")
	
	; Snap to black 
	(fade_out 0 0 0 0)
	
	(ai_allegiance human player)
	(ai_allegiance player human)
	
	; coop respawn
	(player_set_profile profile_coop_respawn)
	
	; soft ceilings
	(soft_ceiling_enable soft_ceiling_010 FALSE)
	
	; kill volumes
	(kill_volume_disable kill_tv_outpost)
	(kill_volume_disable kill_tv_outpost_ext)
	
	; achievements
	(wake achievment01_start)
	
	; object control
	(wake object_control)
	
	; soft ceiling control
	(wake ceiling_control)
	
	; global health
	(if (not (game_is_cooperative))
		(wake f_global_health_saves)
	)
	
	; general weapon training- in ambient script
	(if (not (game_is_cooperative))
		(wake m10_weapon_training)
	)
	
	(player_disable_movement FALSE)
	(zone_set_trigger_volume_enable zone_set:zoneset_1stbowl FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:zoneset_outpost_interior FALSE)

	
	(if (and (> (player_count) 0) (not (editor_mode)))
		; if game is allowed to start 
		(start)
			
		; if the game is NOT allowed to start do this 
		(begin 
			(fade_in 0 0 0 0)
			;(wake temp_camera_bounds_off)
		)
	)
	
	
	; INSERTION POINTS
	; ============================================================================================
	
		; ENCOUNTER : 1st bowl
		; =======================================================================================
		(sleep_until (>= g_insertion_index 0) 1)
		(if (<= g_insertion_index 0) (wake 1stbowl_start))
		
		
		; ENCOUNTER : barn
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players vol_barn_start)
				(>= g_insertion_index 1)
			)
		1)
		
		(if (<= g_insertion_index 1) (wake barn_start))
		
		
		; ENCOUNTER : meadow
		; =======================================================================================
		(sleep_until	
			(or
				(= (current_zone_set_fully_active) 4)
				(>= g_insertion_index 2)
			)
		1)
		
		(if (<= g_insertion_index 2) (wake meadow_start))
		
		
		; ENCOUNTER : 3kiva
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_3kiva_start)
				(>= g_insertion_index 3)
			)
		1)
		
		(if (<= g_insertion_index 3) (wake 3kiva_start))
		
		
		; ENCOUNTER : outpost exterior
		; =======================================================================================
		(sleep_until	
			(or
				(= (current_zone_set_fully_active) 6)
				(>= g_insertion_index 4)
			)
		1)
		
		(if (<= g_insertion_index 4) (wake outpost_ext_start))
		
		
		; ENCOUNTER : outpost interior
		; =======================================================================================
		(sleep_until	
			(or
				(= (current_zone_set_fully_active) 7)
				(>= g_insertion_index 5)
			)
		1)
		
		(if (<= g_insertion_index 5) (wake outpost_int_start))
)

; =================================================================================================
; START
; =================================================================================================
(script static void start
	(print "Start!")
	
	; Figure out what insertion point to use
	(cond
		((= (game_insertion_point_get) 0) (ins_1stbowl))
		((= (game_insertion_point_get) 1) (ins_barn))
		((= (game_insertion_point_get) 2) (ins_meadow))
		((= (game_insertion_point_get) 3) (ins_3kiva))
		((= (game_insertion_point_get) 4) (ins_outpost_ext))
		((= (game_insertion_point_get) 5) (ins_outpost_int))
		((= (game_insertion_point_get) 10) (ins_blank))
	)
)


;====================================================================================================================================================================================================
; 1stbowl ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant 1stbowl_start

	; set first mission segment
	(data_mine_set_mission_segment "m10_01_1stbowl")
	
	; Play the intro cinematic
	(if (or editor_cinematics (not (editor_mode))) 
		(begin
			(print "Starting intro cinematic!")
			(f_start_mission 010la_outpost)
		)
	)
	
	(print "1st bowl start")
	(if (not (>= (current_zone_set_fully_active) 1))
		(begin
			(print "pre-loading 1stbowl zoneset in script")
			(switch_zone_set zoneset_insert)
			(sleep_until (>= (current_zone_set_fully_active) 1) 1)
			(prepare_to_switch_to_zone_set zoneset_1stbowl)
		)
	)
	
	(print "placing Spartans")
	(ai_place spartan_carter)
	(ai_place spartan_kat)
	(ai_place spartan_jun)
	(ai_place spartan_emile)
	(sleep 1)
	
	(set obj_carter (ai_get_unit group_carter))
	(set obj_kat (ai_get_unit group_kat))
	(set obj_jun (ai_get_unit group_jun))
	(set obj_emile (ai_get_unit group_emile))
	
	(if (not (game_is_cooperative))
		(begin
			(print "placing Jorge")
			(ai_place spartan_jorge)
			(set obj_jorge (ai_get_unit group_jorge))
		)
		(begin
			(print "coop: not placing Jorge")
			(wake 1stbowl_coop_spartans)
		)
	)
	
	(ai_cannot_die group_spartans TRUE)
	(ai_disregard (ai_actors group_jun) TRUE)
	
	; falcon dropoff dialog
	(wake md_1stbowl_hover)
	
	(wake intro_falcons_start)
	(wake rain_start)
	
	; objectives
	(wake obj_start)
	
	; turn off auto training
	(hud_enable_training FALSE)
	
	(sleep 60)
	
	(cinematic_exit 010la_outpost FALSE)
	
	; music
	(wake music_1stbowl)
	
	; fade out HUD
	(chud_cinematic_fade 0 0)
	
	; set initial menu objective
	(f_hud_start_menu_obj PRIMARY_OBJECTIVE_1_1)
	
	
	(game_save_immediate)
	
	(sleep_until (>= g_1stbowl_obj_control 20) 1)
	(print "player dropoff")
	
	(sleep_until (not (any_players_in_vehicle)) 5)
	
	; zoneset
	(wake 1stbowl_zoneset_control)
	;(zone_set_trigger_volume_enable zone_set:zoneset_1stbowl TRUE)
	;(zone_set_trigger_volume_enable begin_zone_set:zoneset_barn TRUE)
	
	; chapter title
	(wake chapter_01_start)
	(chud_show_motion_sensor FALSE)
	
	; dialog
	(wake md_1stbowl_orders)
	(wake md_1stbowl_next_structure)
	(wake md_1stbowl_house)
	(wake md_1stbowl_stand_down01)
	
	; kivas
	(wake 1stbowl_kiva_start)
	(wake witnesses_start)
	(wake hud_barn_start)
	
	;(ai_dialogue_enable FALSE)
	
	(sleep_until (>= (current_zone_set_fully_active) 2) 5)
	
	; wildlife
	(wake bowl_birds_start)
	(wake 1stbowl_wildlife_start)
	
	; skirmisher
	;(wake 1stbowl_skirm)
	
	; elite
	(if (= (game_difficulty_get) legendary)
		(wake 1stbowl_elite_start)
	)
	
	
	(sleep_until (volume_test_players tv_1stbowl_gas))
	(bring_spartans_forward 15)
	(game_save)
		
	(sleep_until (volume_test_players tv_1stbowl_part2))
	(set beacon_done TRUE)
	(set warthog_done TRUE)
	(set g_music02 TRUE)
	(thespian_performance_kill_by_ai group_spartans)
	(ai_bring_forward group_emile 7)
	
	(sleep_until (volume_test_players tv_1stbowl_cliffside))
	(set g_1stbowl_obj_control 21)
	(thespian_performance_kill_by_ai group_spartans)
	
	(sleep_until (volume_test_players tv_first_bowl_end) 5)
	(set g_1stbowl_obj_control 30)
	(bring_spartans_forward 8)
	(game_save)
	
)

(script dormant 1stbowl_zoneset_control
	(zone_set_trigger_volume_enable zone_set:zoneset_1stbowl TRUE)
	(sleep_until (>= (current_zone_set_fully_active) 2) 5)
	(zone_set_trigger_volume_enable zone_set:zoneset_1stbowl FALSE)
	(sleep 90)
	(game_save)
	(sleep 200)
	(prepare_to_switch_to_zone_set zoneset_barn)
	
)

(script dormant 1stbowl_coop_spartans
	;(sleep_until (volume_test_players tv_1stbowl_witnesses) 1)
	(sleep_until (>= (current_zone_set_fully_active) 2))
	(sleep_until (volume_test_players tv_1stbowl_part2))
	(print "coop: placing Jorge")
	(ai_place spartan_jorge/witnesses)
	(ai_cannot_die group_spartans TRUE)
	(ai_vehicle_enter_immediate group_jorge (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn")
	
)


; 1stbowl Falcons =====================================================================================================================

(script dormant intro_falcons_start
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01)
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_02)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_02 0))
	
	; fake the rotor movement
	;set function value flying to 1 over 120 ticks
	;prop_control
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) prop_control .2 .2)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) prop_control .2 .2)
	
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) flying 1 1)
	(object_set_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) flying 1 1)
	(sleep 1)
	
	(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
	(objects_attach dm_falcon02_start "" (ai_vehicle_get_from_squad intro_falcon_02 0) "")
	(wake intro_falcon01_anim_start)
	(wake intro_falcon02_anim_start)
	
	; audio for rotors
	(wake sound_1stbowl_falcons)
	
	(intro_falcons_setup_start)
)

(script static void intro_falcons_setup_start
	(unit_lower_weapon player0 0)
	(unit_lower_weapon player1 0)
	
	(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_01 0))
	(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_02 0))
	
	; This thespian performance is Carter's whole falcon ride and unload
	(thespian_performance_setup_and_begin carter_falcon_intro "" 0)
	
	; This thespian performance is Kat's whole falcon ride and unload
	(thespian_performance_setup_and_begin kat_falcon_intro "" 0)
	
	; This thespian performance is Emile's whole falcon ride and unload
	(thespian_performance_setup_and_begin emile_falcon_intro "" 0)
	
	;(ai_vehicle_enter_immediate group_carter (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench")
	;(ai_vehicle_enter_immediate group_kat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench")
	;(ai_vehicle_enter_immediate group_emile (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1")
	(ai_vehicle_enter_immediate group_jorge (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn")
	(ai_vehicle_enter_immediate group_jun (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	
	(sleep 1)
	(unit_enter_vehicle_immediate player0 (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1")
	
	;if coop
	(unit_enter_vehicle_immediate player1 (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2")
	(unit_enter_vehicle_immediate player2 (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2")
	(unit_enter_vehicle_immediate player3 (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2")
	
)

(script dormant intro_falcon01_anim_start
	(intro_falcon01_dropoff_start)
)

(script dormant intro_falcon02_anim_start
	(intro_falcon02_dropoff_start)
)


(script static void intro_falcon01_dropoff_start
	;(print "anim: falcon01_dropoff")
	;(device_set_position_track dm_falcon01_start "m10_insert_dropoff_a" 0)
	;(device_animate_position dm_falcon01_start 1 50.00 .1 .1 FALSE)
	
	; Falcon 01 -- this is the player's falcon
	(device_set_position_track dm_falcon01_start "m10_insert_dropoff_a_leomar" 0)
	(device_animate_position dm_falcon01_start 1 50.00 .1 .1 FALSE)
	
	(player_camera_control FALSE)
	(player_enable_input FALSE)
	(print "lookat_carter")
	(player_control_lock_gaze player0 pts_1stbowl/lookat_carter 40)
	(sleep 30)
	(player_control_unlock_gaze player0)
	(sleep_until (>= (device_get_position dm_falcon01_start) .12) 1)
	(print "lookat_outpost")
	(player_control_lock_gaze player0 pts_1stbowl/lookat_outpost 40)
	(sleep_until (>= (device_get_position dm_falcon01_start) .22) 1)
	
	(sleep_until (>= (device_get_position dm_falcon01_start) .95) 1)
	
	(game_save_immediate)
	(wake md_1stbowl_unload)
	
	(if (not (game_is_cooperative))
		;if single player, train player to exit
		(begin
			(wake ct_training_exit_start)
			;(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" FALSE TRUE)
		)
	)
	
	(intro_falcon01_exit_start)
	
	(if (not (game_is_cooperative))
		;if single player, wait for player to exit
		(begin
			(sleep_until (not (unit_in_vehicle (unit player0))) 1)
			(print "player has exited")
			(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_01 0))
			(unit_raise_weapon player0 30)
		)
	)
	
	(sleep_until (>= (device_get_position dm_falcon01_start) 1) 1)
	(objects_detach dm_falcon01_start (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 .7)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_intro_falcons)
	
	(object_clear_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) flying)
	(object_clear_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_01 0) prop_control)
	
)

(script command_script cs_intro_falcons
	(cs_fly_by pts_1stbowl/air_support00a)
	(cs_face TRUE pts_1stbowl/air_support00_face)
	(cs_vehicle_speed .6)
	(cs_fly_by pts_1stbowl/air_support00b)
	(cs_vehicle_speed .5)
	(sleep_until
		(begin
			(cs_fly_by pts_1stbowl/air_support00b)
			(cs_fly_by pts_1stbowl/air_support00c)
			(cs_fly_by pts_1stbowl/air_support00d)
			(cs_fly_by pts_1stbowl/air_support00e)
			FALSE
		)
	5)
)


(script static void intro_falcon02_dropoff_start
	;(print "anim: falcon02_dropoff")
	;(device_set_position_track dm_falcon02_start "m10_insert_dropoff_b" 0)
	;(device_animate_position dm_falcon02_start 1 50.00 .1 .1 FALSE)
	
	; Falcon 02 -- this is Kat's falcon
	(device_set_position_track dm_falcon02_start "m10_insert_dropoff_b_leomar" 0)
	;(device_animate_position dm_falcon02_start 1 57.00 .1 .1 FALSE)
	(device_animate_position dm_falcon02_start 1 56.00 .1 .1 FALSE)
	
	(sleep_until (>= (device_get_position dm_falcon02_start) .85) 1)
	(print "anim: falcon02_dropoff")
	(intro_falcon02_exit_start)
	
	(sleep_until (>= (device_get_position dm_falcon02_start) .95) 1)
	(objects_detach dm_falcon02_start (ai_vehicle_get_from_squad intro_falcon_02 0))
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_02 0) 2 0 2)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_02) cs_intro_falcons_02)
	
	(object_clear_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) flying)
	(object_clear_cinematic_function_variable (ai_vehicle_get_from_squad intro_falcon_02 0) prop_control)

)

(script command_script cs_intro_falcons_02
	(cs_fly_by pts_1stbowl/air_support01)
	(cs_fly_by pts_1stbowl/air_support02)
	(cs_face TRUE pts_1stbowl/air_support02_face)
	(sleep_until warthog_done)
	(cs_fly_by pts_1stbowl/air_support03)
	(sleep_until (>= g_1stbowl_obj_control 21))
	(cs_vehicle_speed .2)
	(cs_fly_by pts_1stbowl/air_support04 1)
	
	(sleep_until (volume_test_players tv_1stbowl_witnesses) 1)	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn" TRUE)
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn")
	;(ai_place spartan_jorge/witnesses)
	(sleep 200)
	(cs_vehicle_speed .2)
	(cs_fly_by pts_1stbowl/air_support05)
	(cs_face FALSE pts_1stbowl/air_support02_face)
	(cs_vehicle_speed 1)
	(cs_fly_by pts_1stbowl/air_support06)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)


(script static void intro_falcon01_exit_start
	(f_set_falcon_interaction_exit (ai_vehicle_get_from_squad intro_falcon_01 0))
	
	;jun
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn" TRUE)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" TRUE)
	
	;jun
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2")
	(sleep 20)
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench")
	
	; player seats
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1")
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2")
	
	(if (game_is_cooperative)
		;if coop, kick player out
		(begin
			(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_01 0))
			(unit_exit_vehicle player0)
			(unit_raise_weapon player0 30)
		)
	)
	(sleep 7)
	(unit_exit_vehicle player1)
	(unit_raise_weapon player1 30)
	
	; reset objective
	(ai_reset_objective obj_1stbowl_hum)
	(sleep 1)
	
	(set g_1stbowl_obj_control 20)
)

(script static void intro_falcon02_exit_start
	(f_set_falcon_interaction_exit (ai_vehicle_get_from_squad intro_falcon_02 0))
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1" TRUE)
	;jorge
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench_wpn" TRUE)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench" TRUE)
	
	(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_02 0))
	
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1")
	(sleep 7)
	;jorge
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2")
	(sleep 7)
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench")
	
	(unit_exit_vehicle player2)
	(unit_raise_weapon player2 30)
	(sleep 7)
	(unit_exit_vehicle player3)
	(unit_raise_weapon player3 30)
	
	(set g_1stbowl_obj_control 20)
)

(script static void (f_set_falcon_interaction_false (vehicle v))
	(vehicle_set_player_interaction v "falcon_d" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_r1" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_l1" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_r2" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_l2" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_bench" FALSE FALSE)
)

(script static void (f_set_falcon_interaction_exit (vehicle v))
	(vehicle_set_player_interaction v "falcon_d" FALSE FALSE)
	(vehicle_set_player_interaction v "falcon_p_r1" FALSE TRUE)
	(vehicle_set_player_interaction v "falcon_p_l1" FALSE TRUE)
	(vehicle_set_player_interaction v "falcon_p_r2" FALSE TRUE)
	(vehicle_set_player_interaction v "falcon_p_l2" FALSE TRUE)
	(vehicle_set_player_interaction v "falcon_p_bench" FALSE FALSE)
)

; 1stbowl scripts =====================================================================================================================================================================================


(script dormant 1stbowl_wildlife_start
	(ai_place 1stbowl_moah01)
	(ai_disregard (ai_actors 1stbowl_moah01) TRUE)
	
	(sleep_until (= (current_zone_set_fully_active) 4))
	(ai_disposable 1stbowl_moah01 TRUE)
	
)

(script command_script cs_1stbowl_moah01
	(cs_abort_on_damage TRUE)
	(sleep_until (volume_test_players tv_1stbowl_wildlife))
	(sound_impulse_start sound\characters\ambient_life\moa\moa_call_long_bigger (ai_get_object ai_current_actor) 1)
	(cs_go_to ps_1stbowl_moahs/p0)
)

(script command_script cs_1stbowl_moah02
	(cs_abort_on_damage TRUE)
	(sleep_until (volume_test_players tv_1stbowl_wildlife))
	(cs_go_to ps_1stbowl_moahs/p1)
)

(script dormant witnesses_start
	;(device_set_position_immediate dm_kiva01_door .42)
	(sleep_until (volume_test_players tv_1stbowl_witnesses) 1)
	(wake md_1stbowl_civ_heat)
	(wake md_1stbowl_witnesses)
	(wake hud_witnesses)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_witnesses)
	
	(ai_bring_forward group_carter 8)
	(ai_bring_forward group_kat 8)
	
	;*
	(if 
		(and
			(not (volume_test_objects tv_1stbowl_witnesses obj_emile))
			(not (objects_can_see_object (players) obj_emile 30))
			(not (objects_can_see_object (players) sc_emile_teleport_test 30))
		)
		;(ai_teleport group_emile ps_vigs_witnesses/emile_teleport)
		(cs_run_command_script group_emile cs_emile_witnesses_teleport)
	)
	*;
	
	(ai_place 1stbowl_witnesses_dad)
	(ai_place 1stbowl_witnesses_family)
	(ai_disregard (ai_actors group_civilians) TRUE)
	;(ai_actor_dialogue_enable group_civilians FALSE)
	
	;(wake witnesses_player_kills)
	
	(if (not (volume_test_objects tv_1stbowl_witnesses obj_emile))
		(begin
			(wake witnesses_emile_teleport)
			(sleep_until (volume_test_objects tv_1stbowl_witnesses obj_emile))
		)
	)
	
	(sleep 1)
	(thespian_performance_activate "thes_witnesses")
)


(script dormant witnesses_emile_teleport
	(sleep_until
		(or
			(volume_test_objects tv_1stbowl_witnesses obj_emile)
			(and
				(not (objects_can_see_object (players) obj_emile 30))
				(not (objects_can_see_object (players) sc_emile_teleport_test 30))
			)
		)
	1 100)
	(if (not (volume_test_objects tv_1stbowl_witnesses obj_emile))
		(cs_run_command_script group_emile cs_emile_witnesses_teleport)
	)
)


(script command_script cs_emile_witnesses_teleport
	(sleep 10)
	(cs_teleport ps_vigs_witnesses/emile_teleport ps_vigs_witnesses/emile_teleport_face)
)


(script dormant witnesses_player_kills
	;(sleep_until (> (device_get_position dm_kiva01_door) 0))
	(sleep_until
		(or
			(<= (ai_living_count obj_1stbowl_civ) 3)
			;(= (device_get_position dm_kiva01_door) 0)
			(>= g_barn_obj_control 10)
		)
	1)
	
	(if (<= (ai_living_count obj_1stbowl_civ) 3)
		(begin
			(print "player kills")
			(print "scream!")
			(sleep 20)
			(device_set_position dm_kiva01_door 0)
			(set g_1stbowl_obj_control 99)
			
			(ai_allegiance_break human player)
			(ai_allegiance_break player human)
		)
	)
)

(script dormant hud_barn_start
	(wake md_1stbowl_sprint)
	(sleep_until (>= g_1stbowl_obj_control 30))
	(sleep 100)
	(sleep_until (objects_can_see_object player0 sc_hud_barn01 25) 10 (* 15 30))
	(f_hud_flash_object sc_hud_barn01_highlight)
	(f_blip_object sc_hud_barn01 blip_default)
	(sleep_until (volume_test_players vol_barn_start))
	(f_unblip_object sc_hud_barn01)
)


(script dormant bowl_birds_start
	(sleep_until (> 40 (objects_distance_to_object player0 sc_1stbowl_truck)))
	(flock_create "flocks_bowl_birds")
	(sleep_until (> 30 (objects_distance_to_object player0 sc_1stbowl_truck)))
	(flock_create "flocks_bowl_birds02")
	(flock_create "flocks_bowl_birds_skirm")
	
	(sleep_until (>= (current_zone_set) 4))
	(flock_delete "flocks_bowl_birds")
	(flock_delete "flocks_bowl_birds02")
	(flock_delete "flocks_bowl_birds_skirm")
	
)

(script dormant 1stbowl_kiva_start
	(sleep_until (volume_test_players vol_1stbowl_kiva01) 5)
	(game_save)

)

(script dormant 1stbowl_elite_start
	(sleep_until (volume_test_players tv_1stbowl_adv01) 5)
	(print "1stbowl_elite")
	(ai_place 1stbowl_elite)
	(ai_disregard (ai_actors 1stbowl_elite) TRUE)
	(ai_cannot_die 1stbowl_elite TRUE)
	
	(object_create terminal_m10_10)
	(sleep 1)
	(objects_attach (ai_get_object 1stbowl_elite) "backpack" terminal_m10_10 "")
	
	(sleep_until 
		(or
			(<= (object_get_health (ai_get_object 1stbowl_elite)) .1) 
			(< (objects_distance_to_object (players) (ai_get_object 1stbowl_elite)) 1)
		)		
	1)
	(objects_detach (ai_get_object 1stbowl_elite) terminal_m10_10)
	(ai_cannot_die 1stbowl_elite FALSE)
	(sleep 1)
	(if (<= (object_get_health (ai_get_object 1stbowl_elite)) .1) 
		(unit_kill (ai_get_unit 1stbowl_elite))
	)

)

(script command_script cs_1stbowl_elite
	(ai_set_active_camo ai_current_actor TRUE)
	(cs_go_to pts_1stbowl/elite_excape01)
	(cs_go_to pts_1stbowl/elite_excape02)
	(cs_go_to pts_1stbowl/elite_excape03)
	(ai_erase ai_current_actor)
	
)


(script dormant 1stbowl_skirm
	;(sleep 50)
	(ai_place 1stbowl_skirms)

)

(script command_script cs_1stbowl_skirm
	(cs_queue_command_script ai_current_actor cs_1stbowl_skirm_q01)
	(cs_abort_on_damage TRUE)
	;(sleep_until (objects_can_see_flag (players) fl_1stbowl_skirm_cansee 25) 1 100)
	(sleep_until (volume_test_players tv_1stbowl_gas))
	(flock_create "flocks_bowl_birds_skirm")
	(print "jump")
	
)

(script command_script cs_1stbowl_skirm_q01
	;(cs_jump_to_point 8 3)
	(cs_go_to pts_1stbowl/skirm_excape01 10)
	(cs_go_to pts_barn/skirm_excape02)
	(set skirmisher_report TRUE)
	(ai_erase ai_current_actor)
	
)

;====================================================================================================================================================================================================
; Barn ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant barn_start
	(print "barn start")
	(set g_barn_obj_control 1)

	(wake barn_skirm_init_start)
	(ai_disregard (ai_actors barn_skirm_init) TRUE)
	(bring_spartans_forward 15)
	(ai_set_objective group_spartans obj_barn_hum)
	
	; music
	(wake music_barn)
	
	(wake barn_bodies_door)
	;(wake barn_gren_hud)
	;(wake barn_scene_start)
	(wake barn_combat)
	
	; training
	(wake ct_training_melee_start)
	
	; dialog
	(wake md_barn_window)
	
	(game_save)
	
	; player enters barn
	(sleep_until (volume_test_players vol_barn_start) 5)
	(game_save)

	; player enters courtyard
	(sleep_until (volume_test_players vol_barn_courtyard) 5)
	(thespian_performance_kill_by_ai (object_get_ai obj_carter))
	(ai_bring_forward group_carter 8)
	(ai_bring_forward group_spartans 12)
	
	(set g_barn_obj_control 10)
	
	; player enters main barn
	(sleep_until (volume_test_players tv_barn_main) 5)
	(game_save)

	(sleep_until (volume_test_players tv_barn_window_view) 5)
	(bring_spartans_forward 4)
	
	(sleep_until (volume_test_players tv_barn_training_grenades) 5)
	;(bring_spartans_forward 6)
	(wake md_barn_skirm_grenades)
	(ai_bring_forward obj_barn_cov 4)
	(wake ct_training_grenades_start)
	(game_save)
	
	(sleep_until 
		(or
			(<= (ai_living_count obj_barn_cov) 0)
			(volume_test_players vol_meadow_start02)
		)
	)
	
	;(set g_music03 TRUE)
	(sleep (random_range 60 100))
	(wake barn_health_hud)
)


; BARN combat scripts =======================================================================================================================================

(script dormant barn_combat
	; set second mission segment
	(data_mine_set_mission_segment "m10_02_barn")
	;(ai_place barn_skirm_window)
	(ai_place barn_skirm01)
	;(ai_place barn_skirm_basement)
	(ai_place barn_grunts01)
	(ai_place barn_grunts02)
	(ai_place barn_grunts03)
	;(cs_run_command_script barn_skirm_window sleep_cs)
	(cs_run_command_script barn_skirm01 sleep_cs)
	
	(ai_disregard (ai_actors obj_barn_cov) TRUE)
	
	(sleep_until (volume_test_players tv_barn_bloodtrail03) 5)
	(ai_disregard (ai_actors obj_barn_cov) FALSE)
	
	; air combat
	(wake barn_falcon_start)
	(wake meadow_banshees_start)
	
	(sleep 5)
	(set g_barn_obj_control 20)
	(sleep 70)
	
	(sleep_until
		(or
			(and
				(objects_can_see_flag (players) fl_barn_skirm_init02 25)
				(volume_test_players tv_barn_window_view)
			)
			(volume_test_players tv_barn_combat02)
		)
	1)
	
	(print "barn combat triggered")
	(set g_barn_obj_control 30)
	
	; place more skirmishers
	(ai_place barn_skirm02)
	
	(sleep 1)
	(cs_run_command_script barn_skirm01 cs_barn_skirms)
	(cs_run_command_script barn_skirm02 cs_barn_skirms)
	(sleep 10)
	
	; call of the wild
	(thespian_performance_setup_and_begin vig_barn_call "" 0)
	
	; dialog
	(wake md_barn_contact)
	
	(sleep_until (volume_test_players tv_barn_combat02) 30 (random_range 120 130))
	(print "abort barn cov")
	(cs_run_command_script barn_grunts01 abort_cs)
	(cs_run_command_script barn_grunts03 abort_cs)
	
	; combat dialog
	(ai_dialogue_enable TRUE)
	
	(sleep_until (volume_test_players vol_barn_lower01))
	(ai_place barn_grunts_sideflank)
	
	;(sleep 180)
	(sleep_until (volume_test_players vol_meadow_start) 5 180)
	;spawns banshees
	(set g_barn_obj_control 40)
	(ai_bring_forward group_spartans 10)
	
	;(sleep 140)
	(sleep_until (volume_test_players vol_meadow_start) 5 140)
	;retreats falcon
	(set g_barn_obj_control 50)
	
)

(script command_script cs_barn_skirms
	(sleep 50)
	(cs_abort_on_damage TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (volume_test_players tv_barn_combat02) 30 (random_range 300 350))
	(print "skirm shooting")
	
)

(script dormant meadow_banshees_start
	(sleep_until (>= g_barn_obj_control 40) 5)
	(print "meadow_banshees_start")
	
	; dialog
	(wake md_meadow_banshees)
	
	(ai_place meadow_banshees)
	;(ai_magically_see meadow_banshees group_spartans)
	(object_set_scale (ai_vehicle_get_from_squad meadow_banshees 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad meadow_banshees 1) .01 0)
	
	(object_set_scale (ai_vehicle_get_from_squad meadow_banshees 0) 1 90)
	(object_set_scale (ai_vehicle_get_from_squad meadow_banshees 1) 1 90)
	
	(ai_set_targeting_group meadow_banshees 2)
	
	;(game_save)
)

(script command_script cs_meadow_banshees_entry
	(cs_vehicle_boost TRUE)
	(ai_prefer_target_ai ai_current_actor group_spartans TRUE)
	;(sleep (random_range 80 100))
	(sleep 130)
	(print "cs banshees: boost done")
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost FALSE)
	(cs_shoot_secondary_trigger TRUE)
	;*
	(begin_random_count 1
		(cs_shoot_point TRUE ps_air_meadow/banshee_shoot05)
		(cs_shoot_point TRUE ps_air_meadow/banshee_shoot06)
		(cs_shoot_point TRUE ps_air_meadow/banshee_shoot07)
		(cs_shoot_point TRUE ps_air_meadow/banshee_shoot08)
	)
	*;
	(sleep 120)
)


; BARN secondary scripts =======================================================================================================================================

(script dormant barn_skirm_init_start
	(ai_place barn_skirm_init)
	(ai_disregard (ai_actors barn_skirm_init) TRUE)
	(object_set_scale (ai_get_object barn_skirm_init) .1 0)
	(cs_run_command_script barn_skirm_init sleep_cs)
	(sleep_until 
		(or
			(volume_test_players tv_barn01_end)
			(volume_test_players vol_barn_courtyard)
		)		
	1)
	(sound_impulse_start sound\characters\skirmisher\skirmisher_rooftop sc_sound_barn_skirm 1)
	(wake md_motion_tracker)
	;(sleep_until (volume_test_players vol_barn_courtyard) 1)
	;(sleep_until (objects_can_see_object player0 (ai_get_object ai_current_actor) 50) 1 50)
	(cs_run_command_script barn_skirm_init cs_barn_skirm_init)
	(object_set_scale (ai_get_object barn_skirm_init) 1 30)
	
)


(script command_script cs_barn_skirm_init
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to pts_barn/court_skirm01a)
	(cs_go_to pts_barn/court_skirm01b)
	;(cs_go_to pts_barn/court_skirm01a)
	(sleep 40)
	(ai_erase ai_current_actor)
	;(cs_go_to pts_barn/court_skirm01b)
	;(ai_erase ai_current_actor)
)


(script command_script cs_barn_spartan
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_walk TRUE)
	(cs_go_to pts_barn/spartan01 1)
	(cs_look TRUE pts_barn/bloodtrail)
	(cs_go_to pts_barn/spartan02 1)
)

(script command_script cs_barn_spartan02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to pts_barn/spartan02 1)
	(cs_walk TRUE)
	(cs_go_to pts_barn/spartan03 1)
	(sleep_forever)
)

(script command_script cs_barn_spartan04
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_walk TRUE)
	(cs_go_to_and_face pts_barn/spartan02 pts_barn/spartan02_face)
	(cs_enable_targeting TRUE)
	(sleep 200)
)


(script command_script cs_barn_skirms_lower
	(cs_go_to pts_barn/barn_lower)
)

;*
(script dormant trooper_radio_chatter
	(print "trooper radio chatter")
	(sound_looping_start sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping dc_barn_body 1)
	(sleep_until (volume_test_players vol_barn_bloodtrail))
	(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
	(sleep 60)
	(sound_impulse_start sound\prototype\m10_radio_chatter_instruction NONE 1)
	(sleep (sound_impulse_language_time sound\prototype\m10_radio_chatter_instruction))
	(sound_looping_start sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping dc_barn_body 1)
	(sleep_until (>= (device_get_position dc_barn_body) 1) 1)
	(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
)
*;

(script dormant barn_gren_hud
	(sleep_until (< (objects_distance_to_object (players) eq_barn_gren) 3) 5)
	(chud_track_object_with_priority eq_barn_gren 6 "WP_CALLOUT_GREN")
	(sleep_until (volume_test_players vol_meadow_start))
	(chud_track_object eq_barn_gren FALSE)
)

(script dormant barn_health_hud
	(print "barn health HUD: disabled")
	(sleep_forever)
	
	(sleep_until (< (objects_distance_to_object (players) dc_barn_health) 3) 5)
	(if (> 1 (object_get_health (player0)))
		(begin
			(chud_track_object_with_priority dc_barn_health 6 "WP_CALLOUT_HEALTH")
			(sleep_until (>= 12 (objects_distance_to_object (player0) dc_barn_health)))
			(chud_track_object dc_barn_health FALSE)
		)
	)
)

(script dormant barn_bodies_door
	(sleep_until (= (current_zone_set) 4) 1)
	(device_set_power dm_barn_door01 1)
	(device_set_position dm_barn_door01 0)
	(soft_ceiling_enable soft_ceiling_010 1)
	
)


; BARN Falcon scripts =======================================================================================================================================

(script dormant barn_falcon_start
	(if (not (volume_test_object tv_barn_falcon_failsafe (ai_vehicle_get_from_squad intro_falcon_01 0)))
		(begin
			(print "Barn falcon FAILSAFE!!! FILE BUG!")
			(ai_erase intro_falcon_01)
			(sleep 1)
			(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/barn)
			(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
			(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) ps_air_meadow/falcon_barn_entry)
		)
		(print "Barn falcon ARRIVED")
	)
	
	(ai_set_targeting_group intro_falcon_01 2)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn_combat)
	(sleep_until (>= g_barn_obj_control 50) 5)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn_combat_done)

)

(script command_script cs_falcon01_witnesses
	(print "cs_falcon01_witnesses")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by pts_1stbowl/air_support00f)
	(cs_fly_to_and_face pts_1stbowl/air_support00f pts_1stbowl/air_support00_face)
	(sleep_until (>= g_1stbowl_obj_control 30))
	(sleep 60)
	(cs_vehicle_speed .7)
	(cs_fly_by pts_1stbowl/air_support00g)
	(cs_face TRUE pts_1stbowl/air_support00_faceb)
	(cs_fly_by pts_1stbowl/air_support00h)
	(cs_run_command_script ai_current_actor cs_falcon01_barn)
)

(script command_script cs_falcon01_barn
	(print "cs_falcon01_barn")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .3)
	(cs_face TRUE pts_1stbowl/air_support00_faceb)
	(sleep_until
		(begin
			(cs_fly_by pts_1stbowl/air_support00h)
			(cs_fly_by pts_1stbowl/air_support00i)
			(cs_fly_by pts_1stbowl/air_support00j)
			(cs_fly_by pts_1stbowl/air_support00k)
			FALSE
		)
	5)
)

(script command_script cs_falcon01_barn_combat
	(print "cs_falcon01_barn_combat")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_air_meadow/falcon_barn_entry)
	
	(sleep_until (>= g_barn_obj_control 30) 5)
	(cs_fly_by ps_air_meadow/falcon_buzz01)
	;(cs_enable_targeting TRUE)
	(cs_face TRUE ps_air_meadow/falcon_buzz_face)
	;(cs_fly_to_and_face ps_air_meadow/falcon_buzz02 ps_air_meadow/falcon_buzz_face)
	(cs_fly_by ps_air_meadow/falcon_buzz02)
	(cs_shoot_point TRUE ps_air_meadow/falcon_shoot)
	(cs_vehicle_speed .6)
	
	(sleep_until
		(begin
			(cs_fly_by ps_air_meadow/falcon_buzz01)
			(sleep (random_range 60 90))
			
			(if (>= (random_range 0 3) 1)
				(cs_shoot_point TRUE ps_air_meadow/falcon_shoot)
				(cs_shoot_point FALSE ps_air_meadow/falcon_shoot)
			)
			
			(cs_fly_by ps_air_meadow/falcon_buzz02)
			(sleep (random_range 60 90))
			
			(if (>= (random_range 0 3) 1)
				(cs_shoot_point TRUE ps_air_meadow/falcon_shoot)
				(cs_shoot_point FALSE ps_air_meadow/falcon_shoot)
			)
			
			FALSE
		)
	)

)

(script command_script cs_falcon01_barn_combat_done
	(print "cs_falcon01_barn_combat")
	(cs_enable_pathfinding_failsafe TRUE)
	
	(cs_shoot_point TRUE ps_air_meadow/falcon_shoot02)
	(sleep (random_range 40 60))
	(cs_shoot_point FALSE ps_air_meadow/falcon_shoot02)
	
	(cs_fly_by ps_air_meadow/falcon_buzz02)
	
	(cs_face TRUE ps_air_meadow/meadow_drop02)
	(cs_fly_by ps_air_meadow/falcon_circle01d)
	(cs_face FALSE ps_air_meadow/meadow_drop02)
	
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	;(cs_face TRUE ps_air_meadow/falcon_buzz_face)
	(sleep_until
		(begin
			(cs_fly_by ps_air_meadow/falcon_circle01a)
			(cs_fly_by ps_air_meadow/falcon_circle01b)
			(cs_fly_by ps_air_meadow/falcon_circle01c)
			(cs_fly_by ps_air_meadow/falcon_circle01d)
			FALSE
		)
	)

)

;====================================================================================================================================================================================================
; Meadow  ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant meadow_start
	(print "meadow start")
	(wake meadow_cov_air_start)
	
	(sleep_until (volume_test_players vol_meadow_start) 5)
	
	; falcons
	(wake meadow_falcon_start)
	(if (not (game_is_cooperative))
		; if not coop, evac spartans
		(wake meadow_evac)
	)
	
	; if 2 players, bring jorge forward
	(if (game_is_cooperative)
		(begin
			(wake meadow_coop_jorge)
			(ai_erase group_kat)
			(ai_erase group_emile)
		)
	)
	
	; if 3+ players, erase kat and emile
	(if (>= (game_coop_player_count) 3)
		(begin
			(ai_erase group_jorge)
		)
	)
	
	; dialog
	(wake meadow_back_setup)
	
	; training
	(hud_enable_training TRUE)
	
	; waypoints
	(wake meadow_waypoints)
	
	; music
	(wake music_meadow)
	
	; wildlife
	(ai_place meadow_moah01)
	(ai_disregard (ai_actors group_wildlife) TRUE)
	
	; flocks
	;(flock_create "flocks_meadow_fish01")
	
	(game_save)
	
	(sleep_until (volume_test_players vol_meadow_start02))
	(ai_place meadow_skirms01)
	(ai_set_objective obj_barn_cov obj_meadow_cov)
	(ai_set_objective group_spartans obj_meadow_hum)
	(ai_bring_forward group_spartans 10)
	(game_save)
	
	
	(sleep_until (volume_test_players vol_meadow_halfway))
	(ai_bring_forward group_spartans 20)
	(game_save)
	
	(sleep_until (volume_test_players vol_meadow_exit))
	(ai_place meadow_cov_elites)
	(if (= (game_difficulty_get) heroic)
		(begin
			(ai_place meadow_cov_elites02)
			(ai_place meadow_cov_elites03)
		)
	)
	(if (= (game_difficulty_get) legendary)
		(begin
			(ai_place meadow_cov_elites02)
			(ai_place meadow_cov_elite_gold)
		)
	)
	
	(ai_bring_forward group_spartans 10)
	;(game_save)
	
	(sleep_until (<= (ai_living_count obj_meadow_cov) 0))
	;(wake md_meadow_combat_done)
	(ai_bring_forward group_spartans 10)
	(game_save)
)

; Meadow secondary ====================================================================================================================

(script dormant meadow_back_setup
	;(sleep_until (volume_test_players vol_meadow_quartway))
	;(sleep_until (volume_test_objects tv_meadow_part1 (ai_get_object group_cov_meadow)))
	(sleep_until (>= (ai_living_count meadow_fork) 1) 5)
	(sleep_until (<= (ai_living_count meadow_fork) 2) 5)
	(print "cov in part1")
	;(sleep_until (not (volume_test_object tv_meadow_part1 (ai_get_object obj_meadow_cov))))
	(sleep_until 
		(or
			(<= (ai_task_count obj_meadow_cov/gate_meadow_front) 0) 
			(volume_test_players vol_meadow_halfway)
		)		
	5)
	(print "cov dead in part1")
	(sleep (random_range 20 30))
	(wake md_meadow02)
)


(script dormant meadow_cov_air_start
	(sleep_until (volume_test_players vol_meadow_start) 5)
	(sleep_until 
		(or
			(<= (ai_living_count obj_barn_cov) 1)
			(>= (ai_task_count obj_barn_cov/overlook_fallback02) 1)
			(volume_test_players vol_meadow_start02) 
		)		
	5)
	(print "meadow_cov_air_start")
	(ai_place meadow_fork)
	(object_set_scale (ai_vehicle_get_from_squad meadow_fork 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad meadow_fork 0) 1 90)
	(ai_set_targeting_group meadow_fork/driver01 2)
	(ai_magically_see meadow_fork group_spartans)
	
	(sleep 80)
	(wake md_meadow_dropship)
	
	(game_save)
)

(script dormant meadow_coop_jorge
	(print "meadow_coop_jorge")
	(sleep_until (volume_test_players vol_meadow_halfway))
	(if (not (volume_test_object tv_meadow_adv01 obj_jorge))
		(begin
			(sleep_until (not (objects_can_see_object (players) sc_meadow_coop_jorge 30)) 5 200)
			(object_teleport_to_ai_point obj_jorge ps_meadow/coop_jorge)
		)
	)
	
)

; meadow falcons ====================================================================================================================
(script dormant meadow_falcon_start
	(ai_set_objective intro_falcon_01 obj_airsupport_hum)
	(ai_set_targeting_group intro_falcon_01 2)	
	
	(sleep_until (volume_test_players vol_meadow_quartway))
	(print "fork and falcon falling back")
	
	; forks
	(cs_run_command_script meadow_fork/driver01 cs_meadow_fork_fallback)
	(cs_run_command_script meadow_banshees cs_meadow_fork_exit)
	(ai_set_targeting_group meadow_fork 2)
	
	; falcon
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_meadow)
	
	
	(sleep_until (volume_test_players vol_meadow_halfway))
	(print "fork exiting and falcon ready to assist")
	
	; forks
	(cs_run_command_script meadow_fork/driver01 cs_meadow_fork_exit)
	
	
	(sleep_until (volume_test_players vol_meadow_exit))
	(print "falcon assisting")
	(ai_disregard (ai_actors intro_falcon_01) TRUE)
	(if (<= (game_coop_player_count) 2)
		(ai_set_targeting_group intro_falcon_01 -1)
	)
	
	(sleep_until 
		(or
			(<= (ai_task_count obj_meadow_cov/meadow_elite) 2)
			(volume_test_players tv_3kiva_start02)
		)
	)

	(print "falcon leaving")
	(ai_set_targeting_group intro_falcon_01 -1)
	
	; if player in tv_3kiva_start02, let 3kiva scripts handle falcon command scripting
	(if (not (volume_test_players tv_3kiva_start02))
		(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_meadow_exit)
	)
	
)

(script command_script cs_falcon01_meadow
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_face TRUE ps_air_meadow/meadow_face02)
	(sleep_until
		(begin
			(cs_fly_by ps_air_meadow/falcon_circle02a)
			(cs_fly_by ps_air_meadow/falcon_circle02b)
			(cs_fly_by ps_air_meadow/falcon_circle02c)
			FALSE
		)
	)
	
)

(script command_script cs_falcon01_meadow_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_air_meadow/falcon_3kiva_start)
	(sleep_forever)
	
)

(script dormant meadow_evac
	(sleep_until (volume_test_players vol_meadow_halfway))
	
	; dialog
	;(wake md_meadow_evac_request)
	
	; meadow evac falcon
	(sleep_until 
		(or
			(<= (ai_living_count obj_meadow_cov) 0)
			(volume_test_players tv_3kiva_start02)
		)
	)
	(ai_place meadow_falcon02)
	(object_set_scale (ai_vehicle_get_from_squad meadow_falcon02 0) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get_from_squad meadow_falcon02 0) 1 (* 30 10))
	
	; erase spartans just in case
	(sleep_until (>= (current_zone_set) 5) 1)
	(ai_erase group_kat)
	(ai_erase group_emile)
	(ai_erase meadow_falcon02)
	
)

;ai_vehicle_enter group_kat (ai_vehicle_get_from_squad meadow_falcon02 0) "falcon_p_l2"
(script command_script cs_meadow_falcon_evac
	(cs_enable_pathfinding_failsafe TRUE)
	(ai_disregard (ai_vehicle_get ai_current_actor) TRUE)
	(cs_fly_by ps_air_meadow/falcon_goto01)
	(cs_vehicle_speed .5)
	;(sleep 40)
	(cs_fly_to ps_air_meadow/falcon_hover01 1)
	(cs_vehicle_speed .1)
	(cs_fly_to_and_face ps_air_meadow/falcon_land01 ps_air_meadow/falcon_land_face 1)
	
	(ai_vehicle_enter group_emile (ai_vehicle_get ai_current_actor) "falcon_p_r2")
	(ai_vehicle_enter group_kat (ai_vehicle_get ai_current_actor) "falcon_p_l2")
	(if (not (<= (game_coop_player_count) 2))
		(ai_vehicle_enter group_jorge (ai_vehicle_get ai_current_actor) "falcon_p_l1_wpn")
	)
	
	(sleep_until (meadow_falcon_loaded) 30 500)
	(if (not (meadow_falcon_loaded))
		(begin
			(ai_vehicle_enter_immediate group_emile (ai_vehicle_get ai_current_actor) "falcon_p_r1_wpn")
			(ai_vehicle_enter_immediate group_kat (ai_vehicle_get ai_current_actor) "falcon_p_bench_wpn")
			(if (not (<= (game_coop_player_count) 2))
				(ai_vehicle_enter group_jorge (ai_vehicle_get ai_current_actor) "falcon_p_l1_wpn")
			)
		)
	)
	(sleep 40)
	
	(cs_run_command_script ai_current_actor cs_meadow_falcon_evac_exit)
)

(script command_script cs_meadow_falcon_evac_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(print "falcon02 heading to outpost")
	(cs_vehicle_speed 1)
	(cs_fly_by ps_air_meadow/falcon_exit01)
	(cs_fly_by ps_air_meadow/falcon_exit02)
	(cs_fly_by ps_air_meadow/falcon_exit03)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script static boolean meadow_falcon_loaded
	(and
		(vehicle_test_seat (ai_vehicle_get_from_squad meadow_falcon02 0) "falcon_p_r1_wpn")
		(vehicle_test_seat (ai_vehicle_get_from_squad meadow_falcon02 0) "falcon_p_bench_wpn")
		(if (not (<= (game_coop_player_count) 2))
			(vehicle_test_seat (ai_vehicle_get_from_squad meadow_falcon02 0) "falcon_p_l1_wpn")
		)
	)
)



(script command_script cs_meadow_fork_entry
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" meadow_cov03 meadow_cov01 meadow_cov02 none)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_air_meadow/meadow_drop02)
	(cs_fly_to_and_face ps_air_meadow/meadow_drop03 ps_air_meadow/meadow_face 1)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	
	(cs_fly_by ps_air_meadow/meadow_drop06)
)

(script command_script cs_meadow_fork_fallback
	(if (>= (game_coop_player_count) 3)
		;if >= 3 players, spawn skirmishers
		(f_load_fork (ai_vehicle_get ai_current_actor) "dual" meadow_cov_back01 meadow_cov_back_l meadow_cov_back02 none)
		;else don't spawn skirmishers
		(f_load_fork (ai_vehicle_get ai_current_actor) "dual" meadow_cov_back01 meadow_cov_back_l none none)
	)
	(cs_fly_by ps_air_meadow/meadow_drop04)
	(cs_fly_to_and_face ps_air_meadow/meadow_drop05 ps_air_meadow/meadow_face 1)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	
)

(script command_script cs_meadow_fork_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	;(cs_fly_by ps_airsupport/barn_falcon01 5)
	(cs_fly_by ps_air_meadow/meadow_exit01 5)
	(cs_fly_to ps_air_meadow/meadow_exit02)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant meadow_waypoints
	(branch
		(volume_test_players tv_3kiva_start)
		(hud_unblip_all)
	)
	(sleep_until (volume_test_players vol_meadow_quartway) 30 b_waypoint_time)
	(sleep_until (volume_test_players vol_meadow_halfway) 30 b_waypoint_time)
	(sleep_until (volume_test_players tv_3kiva_start) 30 b_waypoint_time)
	(f_blip_object sc_hud_meadow_waypoint01 blip_default)
	(sleep_until (volume_test_players tv_3kiva_start))
	(hud_unblip_all)
)



;====================================================================================================================================================================================================
; 3Kiva  ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant 3kiva_start
	(wake 3kiva_waypoints)
	(wake 3kiva_troopers_bsp_start)
	(wake 3kiva_location)
	(wake ct_training_enterexit_start)
	
	; ai cleanup
	(ai_disposable obj_meadow_cov TRUE)
	
	(if (>= (game_coop_player_count) 2)
		(object_create v_3kiva_pickup_init02)
	)
	
	(if (>= (game_coop_player_count) 3)
		(object_teleport_to_ai_point v_3kiva_pickup_left ps_3kiva/4player_pickup)
	)
	
	; coop zoneset check
	(if (game_is_cooperative)
		(wake 3kiva_coop_test)
	)
	
	; chapter title
	(wake chapter_02_start)
	
	; music
	(wake music_3kiva)
	
	; dialog
	(wake md_3kiva_start)
	
	; driving support
	(wake 3kiva_driver)
	
	
	(sleep_until (volume_test_players tv_3kiva_start02))
	(ai_bring_forward group_carter 10)
	(ai_bring_forward group_jorge 10)
	
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon01)
	
	; failsafe
	(if (not (volume_test_object tv_3kiva_falcon_failsafe (ai_vehicle_get_from_squad intro_falcon_01 0)))
		(wake 3kiva_falcon_failsafe)
		(print "3kiva falcon ARRIVED")
	)

	
	(ai_set_objective group_carter obj_3kiva_hum)
	(if (<= (game_coop_player_count) 2)
		(ai_set_objective group_jorge obj_3kiva_hum)
	)
	(game_save)
	
	; unlock insertion
	(game_insertion_point_unlock 3)
	
	; wildlife
	(ai_place 3kiva_moah01)
	(ai_disregard (ai_actors group_wildlife) TRUE)
	
	; ai
	(ai_place 3kiva_perimeter_cov01)
	(ai_place 3kiva_perimeter_cov02)
	
	; flocks
	(wake 3kiva_wildlife)
	
	(sleep_until (volume_test_players tv_3kiva_pickup))
	(ai_vehicle_enter group_carter v_3kiva_pickup_init "warthog_p")
	(ai_vehicle_enter group_jorge v_3kiva_pickup_init "pickup_g")
	
	(sleep_until (volume_test_players vol_3kiva_1bsp))
	(ai_place 3kiva_fork)
	(object_set_scale (ai_vehicle_get_from_squad 3kiva_fork 0) .01 1)
	
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	; failsafe
	(if (volume_test_object tv_3kiva_meadow (ai_vehicle_get_from_squad intro_falcon_01 0))
		(wake 3kiva_falcon_start_failsafe)
		(print "3kiva falcon ARRIVED")
	)
	
	; bob the elite
	(ai_place 3kiva_bob)
	
	(wake 3kiva01_cov_start)
	(wake 3kiva02_cov_start)
	(wake 3kiva03_cov_start)
	
	(ai_place 3kiva_perimeter_cov03)
		(sleep 1)
	(ai_place 3kiva_perimeter_cov04)
	
	(wake 3kiva_carter_catchup01_start)
	(wake 3kiva_carter_catchup02_start)
	
	(sleep 90)
	(game_save)
	
	(sleep_until 3kiva_troopers_spoted)
	(wake rain_3kiva_defend_start)
	(game_save)
	
	(sleep_until 3kiva_troopers_found)
	(wake 3kiva_falcon_ecav_start)
	(game_save)
	
	; blocker zoneset check: using coop script for SP
	(if (not (game_is_cooperative))
		(wake 3kiva_coop_test)
	)
	
	(sleep_until 3kiva_done)
	(game_save)
	

	(sleep_until (volume_test_players tv_cliffside_start))
	(f_unblip_object (ai_vehicle_get_from_squad intro_falcon_01 0))
	(ai_disposable group_3kiva_cov TRUE)
	(ai_disposable group_wildlife TRUE)
	
	(sleep_forever 3kiva01_cov_start)
	(hud_unblip_all)
)


(script dormant 3kiva_falcon_failsafe
	(print "3kiva falcon FAILSAFE!!! FILE BUG!")
	(ai_erase intro_falcon_01)
	(sleep 1)
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/3kiva)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) ps_air_meadow/falcon_3kiva_start)
	(sleep 1)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon01)
	
)

; 3Kiva secondary =======================================================================================================================================

(script dormant 3kiva01_cov_start
	(sleep_until (volume_test_players vol_3kiva01_approach02) 5)
	(print "kiva01 start")
	(set 3kiva01_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	(game_save)
	
	(wake 3kiva01_hud)
	(ai_place 3kiva01c_elite)
	(ai_place 3kiva01c_grunts01)
		(sleep 1)
	(ai_place 3kiva01c_grunts02)
	
	(ai_bring_forward group_carter 25)
	(ai_bring_forward group_jorge 25)
	
	(sleep_until (<= (ai_living_count obj_3kiva01c_cov) 0))
	(set 3kiva01_done TRUE)
	;(wake md_3kiva_jun_kiva01)
	(wake md_3kiva_kiva01_done)
	(game_save)
)

(script dormant 3kiva02_cov_start
	(sleep_until (>= 3kiva_troopers_bsp 2))
	
	(if (= 3kiva_troopers_bsp 2)
	;if troopers here, set was_visited = TRUE
		(begin
			(sleep_until (volume_test_players vol_3kiva02_approach01) 5)
			(set 3kiva02_visited TRUE)
			(set 3kiva_objective_count (+ 3kiva_objective_count 1))
			(game_save)
			(sleep_forever)
		)
	)
	(print "kiva02 cov start")
	
	(ai_place 3kiva_hog_cov02a)
	(ai_place 3kiva_hog_cov02b)
	(ai_place 3kiva_hog_cov02c)
	
	(ai_bring_forward group_carter 25)
	(ai_bring_forward group_jorge 25)
	
	(sleep_until (volume_test_players vol_3kiva02_approach01) 5)
	(set 3kiva02_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	
	; music
	(set g_music03 TRUE)

	(sleep_until (<= (ai_living_count group_3kiva02_hog_cov) 0))
	(print "kiva02 hog done")
	(set 3kiva02_done TRUE)
	(game_save)
)


(script dormant 3kiva03_cov_start
	(sleep_until (>= 3kiva_troopers_bsp 2))
	
	(if (= 3kiva_troopers_bsp 3)
	;if troopers here, set was_visited = TRUE
		(begin
			(sleep_until (volume_test_players vol_3kiva03_approach01) 5)
			(set 3kiva03_visited TRUE)
			(set 3kiva_objective_count (+ 3kiva_objective_count 1))
			(game_save)
			(sleep_forever)
		)
	)
	(print "kiva03 cov start")
	
	(ai_place 3kiva_hog_cov03a)
	(ai_place 3kiva_hog_cov03b)
	(ai_place 3kiva_hog_cov03c)
	
	(ai_bring_forward group_carter 25)
	(ai_bring_forward group_jorge 25)
	
	(sleep_until (volume_test_players vol_3kiva03_approach01) 5)
	(game_save)
	(set 3kiva03_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	
	; music
	(set g_music03 TRUE)

	(sleep_until (<= (ai_living_count group_3kiva03_hog_cov) 0))
	(print "kiva03 hog done")
	(set 3kiva03_done TRUE)
	(game_save)
)

(script dormant 3kiva_coop_test
	(sleep_until (>= (current_zone_set) 5))
	(zone_set_trigger_volume_enable begin_zone_set:zoneset_barn_outro:2 FALSE)
	
	(sleep_until
		(begin
			(sleep_until (volume_test_players begin_zone_set:zoneset_barn_outro:2) 5)
			(cond
				((volume_test_object begin_zone_set:zoneset_barn_outro:2 player0) (object_teleport_to_ai_point player0 ps_3kiva/coop_test))
				((volume_test_object begin_zone_set:zoneset_barn_outro:2 player1) (object_teleport_to_ai_point player1 ps_3kiva/coop_test))
				((volume_test_object begin_zone_set:zoneset_barn_outro:2 player2) (object_teleport_to_ai_point player2 ps_3kiva/coop_test))
				((volume_test_object begin_zone_set:zoneset_barn_outro:2 player3) (object_teleport_to_ai_point player3 ps_3kiva/coop_test))
			)
			FALSE
		)
	)
)




; 3Kiva wildlife =======================================================================================================================================

(script dormant 3kiva_wildlife
	(sleep_until (volume_test_players tv_3kiva_wildlife02) 5)
	(ai_disposable meadow_moah01 TRUE)
	
	(flock_create "flocks_3kiva_init_birds01")
	(flock_create "flocks_3kiva_birds01")
		(sleep 1)
	(flock_create "flocks_3kiva_birds02")
	(flock_create "flocks_3kiva_birds03")
	(flock_create "flocks_3kiva_birds04")
		(sleep 1)
	;(flock_create "flocks_3kiva02_fish")
	;(flock_create "flocks_3kiva02_fish02")
		(sleep 1)
	(if (<= (game_coop_player_count) 2)
		(ai_place 3kiva_moah03)
	)
	(ai_disregard (ai_actors group_wildlife) TRUE)
	
		(sleep 30)
	;(flock_stop "flocks_3kiva02_fish")
	;(flock_stop "flocks_3kiva02_fish02")
	
	(sleep_until (volume_test_players tv_3kiva_wildlife03) 5)
	(if (not (game_is_cooperative))
		(ai_place 3kiva_moah02)
	)
	(ai_disregard (ai_actors group_wildlife) TRUE)
	
	(sleep_until
		(begin
			(set g_wildlife_control 1)
			(sleep 1000)
			(set g_wildlife_control 2)
			(sleep 900)
			3kiva_done
		)
	)
	
	(sleep_until (>= (current_zone_set) 6))
	(flock_delete "flocks_3kiva_init_birds01")
	(flock_delete "flocks_3kiva_birds01")
	(flock_delete "flocks_3kiva_birds02")
	(flock_delete "flocks_3kiva_birds03")
	(flock_delete "flocks_3kiva_birds04")
	;(flock_delete "flocks_3kiva02_fish")
	;(flock_delete "flocks_3kiva02_fish02")
	
)


(script command_script cs_3kiva_perimeter_cov01
	(cs_abort_on_damage TRUE)
	(sleep_until (volume_test_players tv_3kiva_wildlife01) 5)
)

; 3Kiva spartan vehicles =======================================================================================================================================
(global ai v_hog_control NONE)

(script static ai players_vehicle
	(ai_player_get_vehicle_squad player0)
)

(script static boolean players_vehicle_has_driver
	(>= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 1)
)

(script dormant 3kiva_driver
	(branch
		3kiva_done
		(branch_kill)
	)
	
	(sleep_until
		(begin
			(sleep_until (players_vehicle_has_driver) 1)
			(set v_hog_control (players_vehicle))
			(print "hog has driver")
			(if (volume_test_objects tv_3kiva_pickup_start v_hog_control)
				(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) cs_pickup_3kiva_start)
			)
			
			(sleep_until 
				(or
					(not (players_vehicle_has_driver))
					(not (= (players_vehicle) v_hog_control))
				)
			1)
			(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) abort_cs)
			(print "hog has NO driver")
			FALSE
		)
	)
)

(script command_script cs_pickup_3kiva_start
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	(cs_ignore_obstacles TRUE)
	
	(cs_vehicle_speed .7)
	(cs_go_to ps_pickup_3kiva/p0)
	(cs_go_to ps_pickup_3kiva/p1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 8)
	(cs_go_to ps_pickup_3kiva/p2)
)


(script static boolean carter_driving_pickup
	(spartan_driving_pickup (object_get_ai obj_carter))
)

(script static boolean spartans_allowed_in_pickup
	(or
		(and
			(player_driving_pickup)
			(or
				(spartan_in_pickup (object_get_ai obj_carter))
				(spartan_in_pickup (object_get_ai obj_jorge))
			)
		)
		
		(and
			(any_players_in_vehicle)
			(not (and
				(not 3kiva01_done)
				(volume_test_players vol_3kiva01_approach02)
			))
			(not (and
				(not 3kiva02_done)
				(volume_test_players vol_3kiva02_approach02)
			))
			(not (and
				(not 3kiva03_done)
				(volume_test_players vol_3kiva03_approach02)
			))
		)
	)
)

(script static boolean (spartan_driving_pickup (ai spartan))
	(or
		(vehicle_test_seat_unit v_3kiva_pickup_init "warthog_d" (ai_get_unit spartan))
		(vehicle_test_seat_unit v_3kiva_pickup_left "warthog_d" (ai_get_unit spartan))
		
		(if (= (current_zone_set_fully_active) 5)
			(begin
				(or
					(vehicle_test_seat_unit v_3kiva_pickup_kiva02 "warthog_d" (ai_get_unit spartan))
					(vehicle_test_seat_unit v_3kiva_pickup_kiva03 "warthog_d" (ai_get_unit spartan))
				)
			)
		)
		
		(if (>= (game_coop_player_count) 2)
			(vehicle_test_seat_unit v_3kiva_pickup_init02 "warthog_d" (ai_get_unit spartan))
		)
	)
)


(script static boolean (spartan_in_pickup (ai spartan))
	(or
		(vehicle_test_seat_unit v_3kiva_pickup_init "" (ai_get_unit spartan))
		(vehicle_test_seat_unit v_3kiva_pickup_left "" (ai_get_unit spartan))
		
		(if (= (current_zone_set_fully_active) 5)
			(begin
				(vehicle_test_seat_unit v_3kiva_pickup_kiva02 "" (ai_get_unit spartan))
				(vehicle_test_seat_unit v_3kiva_pickup_kiva03 "" (ai_get_unit spartan))
			)
		)
		
		(if (>= (game_coop_player_count) 2)
			(vehicle_test_seat_unit v_3kiva_pickup_init02 "" (ai_get_unit spartan))
		)
	)
)

(script static boolean player_driving_pickup
	(or
		 (vehicle_test_seat_unit_list v_3kiva_pickup_init "warthog_d" (players))
		 (vehicle_test_seat_unit_list v_3kiva_pickup_left "warthog_d" (players))
		 
		 (if (= (current_zone_set_fully_active) 5)
		 	(begin
		 		(vehicle_test_seat_unit_list v_3kiva_pickup_kiva02 "warthog_d" (players))
				(vehicle_test_seat_unit_list v_3kiva_pickup_kiva03 "warthog_d" (players))
		 	)
		 )
		 
		 (if (game_is_cooperative)
		 	(vehicle_test_seat_unit_list v_3kiva_pickup_kiva02 "warthog_d" (players))
		 )
	)
)


; 3Kiva TROOPER =======================================================================================================================================

(script dormant 3kiva_troopers_bsp_start
	; dialog
	;(wake md_3kiva_trooper_distress_start)
	(wake md_trooper_distress_attack)
	(wake md_3kiva_troopers_spoted)
	(wake 3kiva_defend_blip)
	
	(sleep_until
		(begin
			(cond
				((volume_test_players vol_3kiva_2bsp)
				(set 3kiva_troopers_bsp 3))
				((volume_test_players vol_3kiva_3bsp)
				(set 3kiva_troopers_bsp 2))
			)
			(>= 3kiva_troopers_bsp 2)
		)
	)
	
	(cond
		((= 3kiva_troopers_bsp 2)
		(wake 3kiva_troopers_bsp2))
		((= 3kiva_troopers_bsp 3)
		(wake 3kiva_troopers_bsp3))
	)
)

(script dormant 3kiva_troopers_bsp2
	(print "troopers in bsp 2")
	(ai_place 3kiva_troopers_bsp02)
	(ai_cannot_die 3kiva_troopers_bsp02 TRUE)
	(object_create cr_3kiva_hogsite02)
	(wake 3kiva_trooper_crashsite_arrival02)
	
	;(object_create cr_3kiva_crashsite_smoke02)
	;(object_create_folder bi_3kiva_jun02)
	
	;health and weapons
	(object_create_folder w_crashsite02)
	(object_create_folder e_crashsite02)
	;(object_create_folder c_crashsite02)
	(wake 3kiva_dmr_blip)
	
	(game_save)
	
	(sleep_until 3kiva_troopers_found)
	;(object_destroy cr_3kiva_crashsite_smoke02)
	(ai_cannot_die 3kiva_troopers_bsp02 FALSE)
	(ai_renew 3kiva_troopers_bsp02)
	(ai_disposable group_3kiva01_cov TRUE)
	(ai_disposable group_3kiva03_cov TRUE)
	
	(sleep_until (<= (ai_living_count 3kiva_fork_squad01) 3))
	(sleep_until (<= (ai_living_count 3kiva_fork_squad01) 0) 30 (* 30 20))
	
	(wake 3kiva_final_bsp2)
	
)

(script dormant 3kiva_troopers_bsp3
	(print "troopers in bsp 2")
	(ai_place 3kiva_troopers_bsp03)
	(ai_cannot_die 3kiva_troopers_bsp03 TRUE)
	(object_create cr_3kiva_hogsite03)
	(wake 3kiva_trooper_crashsite_arrival03)
	
	;(object_create cr_3kiva_crashsite_smoke03)
	;(object_create_folder bi_3kiva_jun03)
	
	;health and weapons
	(object_create_folder w_crashsite03)
	(object_create_folder e_crashsite03)
	;(object_create_folder c_crashsite03)
	(wake 3kiva_dmr_blip)
	
	(game_save)
	
	(sleep_until 3kiva_troopers_found)
	;(object_destroy cr_3kiva_crashsite_smoke03)
	(ai_cannot_die 3kiva_troopers_bsp03 FALSE)
	(ai_renew 3kiva_troopers_bsp03)
	(ai_disposable group_3kiva01_cov TRUE)
	(ai_disposable group_3kiva03_cov TRUE)
	
	(sleep_until (<= (ai_living_count 3kiva_fork_squad01) 3))
	(sleep_until (<= (ai_living_count 3kiva_fork_squad01) 0) 30 (* 30 20))

	(wake 3kiva_final_bsp3)
	
)

(script dormant 3kiva_trooper_crashsite_arrival02
	(sleep_until (volume_test_players tv_3kiva_jun02))
	
	(set 3kiva_troopers_spoted TRUE)
	(game_save)
	(print "player spotted Troopers in bsp 2")
	;(f_blip_object cr_3kiva_crashsite02 blip_recon)
	;(f_blip_ai (object_get_ai obj_jun) blip_interface)
	(sleep_until (< (objects_distance_to_object (players) cr_3kiva_hogsite02) 10))
	(print "player located Troopers in bsp 2")
	(set 3kiva_troopers_found TRUE)
	;(f_unblip_object cr_3kiva_crashsite02)
	;(f_unblip_ai (object_get_ai obj_jun))
	(ai_set_objective group_spartans obj_3kiva02_spartans)
	(ai_bring_forward group_carter 25)
	(ai_bring_forward group_jorge 25)
)

(script dormant 3kiva_trooper_crashsite_arrival03
	(sleep_until (volume_test_players tv_3kiva_jun03))
	
	(set 3kiva_troopers_spoted TRUE)
	(game_save)
	(print "player spotted Troopers in bsp 3")
	;(f_blip_object cr_3kiva_crashsite03 blip_recon)
	;(f_blip_ai (object_get_ai obj_jun) blip_interface)
	(sleep_until (< (objects_distance_to_object (players) cr_3kiva_hogsite03) 10))
	(print "player located Troopers in bsp 3")
	(set 3kiva_troopers_found TRUE)
	;(f_unblip_object cr_3kiva_crashsite03)
	;(f_unblip_ai (object_get_ai obj_jun))
	(ai_set_objective group_spartans obj_3kiva03_spartans)
	(ai_bring_forward group_carter 25)
	(ai_bring_forward group_jorge 25)
)

(script dormant 3kiva_defend_blip
	(branch
		3kiva_done
		(3kiva_unblip_defend)
	)
	
	(sleep_until 3kiva_troopers_spoted 5)
	(cond
		((= 3kiva_troopers_bsp 2)
		(3kiva_defend_blip sc_hud_3kiva02_defend 3kiva_troopers_bsp02))
		((= 3kiva_troopers_bsp 3)
		(3kiva_defend_blip sc_hud_3kiva03_defend 3kiva_troopers_bsp03))
	)
	
)

(script static void (3kiva_defend_blip (object_name defend_object) (ai troopers))
	(f_blip_ai troopers 5)
	(sleep_until (= g_ui_obj_control 4))
	(f_blip_object defend_object blip_defend)
	(sleep 120)
	
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_object (players) defend_object) 30))
			(f_unblip_object defend_object)
			(f_unblip_ai troopers)
			(sleep_until (> (objects_distance_to_object (players) defend_object) 35))
			(f_blip_ai troopers 5)
			(f_blip_object defend_object blip_defend)
			FALSE
		)
	)
)


(script static void 3kiva_unblip_defend
	(f_unblip_object sc_hud_3kiva02_defend)
	(f_unblip_object sc_hud_3kiva03_defend)
	(f_unblip_ai 3kiva_troopers_bsp02)
	(f_unblip_ai 3kiva_troopers_bsp03)
)


(script dormant 3kiva_dmr_blip
	(cond
		((= 3kiva_troopers_bsp 2)
		(f_blip_weapon w_3kiva02_dmr 5 9))
		((= 3kiva_troopers_bsp 3)
		(f_blip_weapon w_3kiva03_dmr 5 9))
	)
	
)


; 3Kiva Final Wave =======================================================================================================================================

(script dormant 3kiva_final_bsp2
	(print "3kiva_final_bsp2")
	(set g_3kiva_obj_control 2)
	(game_save)
	
	(ai_place 3kiva02_fork)
	(ai_set_targeting_group 3kiva02_fork/driver01 2)
	(sleep 700)
	(set g_3kiva_obj_control 3)
	(ai_place 3kiva02_fork02)
	(ai_set_targeting_group 3kiva02_fork02/driver01 2)
	
	(sleep_until (<= (ai_living_count group_3kiva_final02_forks) 0))
	(sleep_until (<= (ai_living_count obj_3kiva02_cov) 2))
	(sleep_until (<= (ai_living_count obj_3kiva02_cov) 1) 30 (* 30 300))
	(sleep_until (<= (ai_living_count obj_3kiva02_cov) 0) 30 (* 30 160))
	(ai_kill obj_3kiva02_cov)
	(ai_kill group_3kiva02_cov)
	(print "3kiva done")
	
	(set 3kiva_done TRUE)
	
	(sleep_until (<= (ai_living_count group_3kiva02_cov) 0))
	(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	(ai_vehicle_enter group_jorge (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")

)


(script dormant 3kiva_final_bsp3
	(print "3kiva_final_bsp3")
	(set g_3kiva_obj_control 2)
	(game_save)
	
	(ai_place 3kiva03_fork)
	(ai_set_targeting_group 3kiva03_fork/driver01 2)
	(sleep 700)
	(set g_3kiva_obj_control 3)
	(ai_place 3kiva03_fork02)
	(ai_set_targeting_group 3kiva03_fork02/driver01 2)
	
	(sleep_until (<= (ai_living_count group_3kiva_final03_forks) 0))
	(sleep_until (<= (ai_living_count obj_3kiva03_cov) 2))
	(sleep_until (<= (ai_living_count obj_3kiva03_cov) 1) 30 (* 30 300))
	(sleep_until (<= (ai_living_count obj_3kiva03_cov) 0) 30 (* 30 160))
	(ai_kill obj_3kiva03_cov)
	(ai_kill group_3kiva03_cov)
	(print "3kiva done")
	
	(set 3kiva_done TRUE)
	
	(sleep_until (<= (ai_living_count group_3kiva03_cov) 0))
	(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	(ai_vehicle_enter group_jorge (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")

)


(script command_script cs_kiva02_fork

	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop01a)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva02_drop01b02 ps_air_3kiva_fork/3kiva02_face01 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" 3kiva02_cov_drop01a 3kiva02_cov_drop01b none 3kiva02_cov_drop01c)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	;(ai_set_objective obj_3kiva02m_cov obj_3kiva02_cov)
	(sleep (random_range 110 140))
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva02_exit01)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_kiva02_fork02

	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop02a)
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop02b)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva02_drop02c ps_air_3kiva_fork/3kiva02_drop02_face 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" 3kiva02_cov_drop02a none 3kiva02_cov_drop02b 3kiva02_cov_drop02c)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	;(ai_set_objective obj_3kiva02m_cov obj_3kiva02_cov)
	(sleep (random_range 110 140))
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva02_exit01)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_kiva03_fork

	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01a)
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01b)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva03_drop01c ps_air_3kiva_fork/3kiva03_face01 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" 3kiva03_cov_drop01a 3kiva03_cov_drop01b none 3kiva03_cov_drop01c)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01d)
	(cs_vehicle_boost TRUE)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01b)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_kiva03_fork02

	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01a)
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01b)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva03_drop01c ps_air_3kiva_fork/3kiva03_face01 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" 3kiva03_cov_drop02c none 3kiva03_cov_drop02b 3kiva03_cov_drop02a)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01d)
	(cs_vehicle_boost TRUE)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01b)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

; 3Kiva location =======================================================================================================================================

(script dormant 3kiva_location
	(sleep_until
		(begin
		(cond
			((volume_test_players tv_3kiva_beginning)
				(begin
					(set 3kiva_bsp 0)
				)
			)
			((volume_test_players vol_3kiva_1bsp)
				(begin
					(set 3kiva_bsp 1)
				)
			)
			((volume_test_players vol_3kiva_2bsp)
				(begin
					(set 3kiva_bsp 2)
				)
			)
			((volume_test_players vol_3kiva_3bsp)
				(begin
					(set 3kiva_bsp 3)
				)
			)
		)
		;FALSE
		;sleep_until outpost_intro is loaded
		(= (current_zone_set_fully_active) 6)
		)
	5)
)


; 3Kiva spartan scripts =======================================================================================================================================

(script dormant 3kiva_carter_catchup01_start
	(sleep_until (>= (objects_distance_to_object (players) (ai_get_object group_carter)) 100))
	(print "carter is lost")
)

(script dormant 3kiva_carter_catchup02_start
	(sleep_until (>= 3kiva_jun_bsp 2))
	(if (>= (objects_distance_to_object (players) (ai_get_object group_carter)) 100)
		(sleep_forever)
	)
	(print "carter is getting vehicle")
)

; 3Kiva Waypoints ==============================================================================================================================================

(script dormant 3kiva_waypoints
	(branch
		3kiva_done
		(hud_unblip_all)
	)
	
	(print "3kiva waypoints")
	(sleep_until (volume_test_players tv_3kiva_pickup) 30 b_waypoint_time)
	(if (not (volume_test_players tv_3kiva_pickup))
		(begin
			(f_blip_object v_3kiva_pickup_init blip_default)
			(sleep_until (volume_test_players tv_3kiva_pickup))
			(hud_unblip_all)
		)
	)
	
	(sleep_until (volume_test_players vol_3kiva_1bsp) 30 b_waypoint_time)
	(if (not (volume_test_players vol_3kiva_1bsp))
		(begin
			(f_blip_object sc_hud_3kiva01 blip_default)
			(sleep_until (volume_test_players vol_3kiva_1bsp))
			(hud_unblip_all)
		)
	)
	
	;checks if player has visited any kivas
	(print "3kiva waypoints: phase 1: player has found 3kiva space")
	(sleep_until 
		(or
			(>= 3kiva_objective_count 2) 
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not (>= 3kiva_objective_count 2))
		(begin
			(3kiva_blip_next_objective)
			(sleep_until (= 3kiva_objective_count 2))
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	
	;checks if player has finished objective or moved on
	(print "3kiva waypoints: phase 2: one objective found")
	(sleep_until 
		(or
			3kiva01_done
			(>= 3kiva_troopers_bsp 2)
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not (or 3kiva01_done (>= 3kiva_troopers_bsp 2)))
		(begin
			(3kiva_blip_next_objective)
			(sleep_until (>= 3kiva_troopers_bsp 2))
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	
	;checks if player has advanced towards 2nd or 3rd kiva
	(print "3kiva waypoints: phase 2: one objective found")
	(sleep_until 
		(or
			(>= 3kiva_troopers_bsp 2)
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not (>= 3kiva_troopers_bsp 2))
		(begin
			(3kiva_blip_next_objective)
			(sleep_until (>= 3kiva_troopers_bsp 2))
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	
	;checks if player has found troopers
	(print "3kiva waypoints: phase 3: troopers are placed")
	(sleep_until 
		(or
			3kiva_troopers_spoted
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not 3kiva_troopers_spoted)
		(begin
			;(3kiva_blip_next_objective)
			(f_blip_object (ai_vehicle_get_from_squad 3kiva_fork 0) blip_hostile_vehicle)
			(sleep_until 3kiva_troopers_spoted)
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	(print "3kiva waypoints: DONE")
)

(script static void 3kiva_blip_next_objective
	(print "blip next obj")
	
	(cond
		((volume_test_objects vol_3kiva_1bsp (ai_vehicle_get_from_squad intro_falcon_01 0)) (wake md_3kiva_waypoint_kiva01))
		((volume_test_objects vol_3kiva_2bsp (ai_vehicle_get_from_squad intro_falcon_01 0)) (wake md_3kiva_waypoint_kiva02))
		((volume_test_objects vol_3kiva_3bsp (ai_vehicle_get_from_squad intro_falcon_01 0)) (wake md_3kiva_waypoint_kiva03))
	)
	(f_blip_object (ai_vehicle_get_from_squad intro_falcon_01 0) blip_default)
	
)


;3kiva banshee  =======================================================================================================================================

(script command_script cs_kiva_jun_banshee
	(cs_vehicle_boost TRUE)
	(cond
		((volume_test_players vol_3kiva_2bsp) (cs_fly_by ps_3kiva_banshee/3kiva02))
		((volume_test_players vol_3kiva_3bsp) (cs_fly_by ps_3kiva_banshee/3kiva03))
	)
)


;3kiva forks  =======================================================================================================================================

(script command_script cs_kiva_jun_fork
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 1)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	(cs_fly_by ps_air_3kiva_fork/3kiva_drop01a 5)
	
	(sleep_until (>= 3kiva_troopers_bsp 2))
	(cond
		((= 3kiva_troopers_bsp 2) (cs_run_command_script ai_current_actor cs_kiva_fork_02))
		((= 3kiva_troopers_bsp 3) (cs_run_command_script ai_current_actor cs_kiva_fork_03))
	)
)


(script command_script cs_kiva_fork_02
	(cs_enable_pathfinding_failsafe TRUE)
	(print "fork flying to kiva02")
	(cs_vehicle_boost TRUE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva02_drop01a ps_air_3kiva_fork/3kiva02_face01 1)
	(cs_vehicle_boost FALSE)
	(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_kiva_fork_02_shoot)
	
	(sleep_until (volume_test_players vol_3kiva02_approach01))
	(cs_fly_by ps_air_3kiva_fork/3kiva02_drop01a)
	(cs_vehicle_speed .8)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva02_drop01b02 ps_air_3kiva_fork/3kiva02_face01 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "right" 3kiva_fork_squad01 none none none)
	
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(ai_set_objective 3kiva_fork_squad01 obj_3kiva02_cov)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva02_drop01a ps_air_3kiva_fork/3kiva02_face01 1)
	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	
	(sleep_until 3kiva_troopers_spoted)
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01a)
	(object_set_scale (ai_vehicle_get ai_current_actor) .1 60)
	(sleep 60)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_kiva_fork_03
	(cs_enable_pathfinding_failsafe TRUE)
	(print "fork flying to kiva03")
	(cs_vehicle_boost TRUE)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva_drop05a ps_air_3kiva_fork/3kiva_drop03_shoot)
	(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_kiva_fork_03_shoot)
	(cs_vehicle_boost FALSE)
	
	(sleep_until (volume_test_players vol_3kiva03_approach01))
	(cs_fly_to ps_air_3kiva_fork/3kiva_drop03a)
	(cs_vehicle_speed .8)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva_drop04a ps_air_3kiva_fork/3kiva03_drop02_face 1)
	
	(f_load_fork (ai_vehicle_get ai_current_actor) "right" 3kiva_fork_squad01 none none none)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(ai_set_objective 3kiva_fork_squad01 obj_3kiva03_cov)
	
	(cs_fly_to ps_air_3kiva_fork/3kiva_drop03a)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva_drop05a ps_air_3kiva_fork/3kiva_drop03_shoot)
	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	
	(sleep_until 3kiva_troopers_spoted)
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_vehicle_speed 1)
	;(cs_fly_by ps_air_3kiva_fork/3kiva03_drop01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva03_exit01a)
	(object_set_scale (ai_vehicle_get ai_current_actor) .1 60)
	(sleep 60)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_kiva_fork_02_shoot
 (cs_shoot_point TRUE ps_air_3kiva_fork/3kiva_drop02_shoot)
 (sleep_until 3kiva_troopers_spoted)
)

(script command_script cs_kiva_fork_03_shoot
 (cs_shoot_point TRUE ps_air_3kiva_fork/3kiva_drop03_shoot)
 (sleep_until 3kiva_troopers_spoted)
)


; 3Kiva Falcon ==============================================================================================================================================
(script dormant 3kiva_falcon_start_failsafe
	(print "3kiva start falcon FAILSAFE!!! FILE BUG!")
	(ai_erase intro_falcon_01)
	(sleep 1)
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/3kiva)
	(sleep 1)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(sleep 1)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon01)
	
)

(script command_script cs_3kiva_falcon01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to ps_air_3kiva_falcon/start01)
	
	(sleep_until
		(or
			(= (current_zone_set) 5)
			(volume_test_players tv_3kiva_pickup) 
		)		
	5)
	(cs_fly_by ps_air_3kiva_falcon/start02)
	(cs_fly_by ps_air_3kiva_falcon/start03)
	
	(sleep_until
		(or
			(volume_test_players vol_3kiva_1bsp)
			(>= 3kiva_troopers_bsp 2)
		)
	)
	(cs_fly_to ps_air_3kiva_falcon/kiva01)
	
	(sleep_until
		(or
			3kiva01_done
			(>= 3kiva_troopers_bsp 2)
		)
	)
	
	(if 3kiva01_done
		(cs_fly_to ps_air_3kiva_falcon/kiva02)
	)
	
	(sleep_until
		(begin
			(cond
				((volume_test_players vol_3kiva_2bsp)
				(cs_fly_to ps_air_3kiva_falcon/kiva02))
				((volume_test_players vol_3kiva_3bsp)
				(cs_fly_to ps_air_3kiva_falcon/kiva03))
			)
			(or
				3kiva02_done
				3kiva03_done
				3kiva_troopers_spoted
			)
		)
	)
	

	(cond
		((= 3kiva_troopers_bsp 2)
		(cs_fly_to ps_air_3kiva_falcon/kiva02))
		((= 3kiva_troopers_bsp 3)
		(cs_fly_to ps_air_3kiva_falcon/kiva03))
	)
	;(sleep_forever)
	
	(sleep_until 3kiva_troopers_spoted)
	(cond
		((= 3kiva_troopers_bsp 2)
		(cs_run_command_script ai_current_actor cs_3kiva_falcon_circle02))
		((= 3kiva_troopers_bsp 3)
		(cs_run_command_script ai_current_actor cs_3kiva_falcon_circle03))
	)
	
)

	
(script dormant 3kiva_falcon_ecav_start
	; clean up as much as you can for object memory
	(ai_erase (object_get_ai obj_jun))
	
	; wait until forks are gone for object memory
	(sleep_until (>= g_3kiva_obj_control 3))
	(sleep_until 
		(and
			(<= (ai_living_count group_3kiva_final02_forks) 0)
			(<= (ai_living_count group_3kiva_final03_forks) 0)
		)
	)
	
	(ai_set_objective intro_falcon_01 obj_3kiva_hum)
	(3kiva_falcon_ecav_jun)
	
	(wake 3kiva_falcon02_start)
	
	(add_recycling_volume tv_recycle_evac02 0 0)
	(add_recycling_volume tv_recycle_evac03 0 0)
	
	
	(sleep_until 3kiva_done)
	(wake 3kiva_falcon_evac_failsafe)
	(cond
		((= 3kiva_troopers_bsp 2)
			(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon_evac02)
		)
		((= 3kiva_troopers_bsp 3)
			(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon_evac03)
		)
	)
	
	(3kiva_falcon_ecav_setup)
	
	(sleep_until (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" (players)))
	
	(set g_3kiva_obj_control 10)
	(wake rain_3kiva_evac_start)
	
	(sleep_until
		(begin
			(print "loading players")
			(load_player_into_falcon player0 intro_falcon_01)
			(load_player_into_falcon player1 intro_falcon_01)
			(load_player_into_falcon player2 intro_falcon_01)
			(load_player_into_falcon player3 intro_falcon_01)

			;sleep until all players loaded
			(and
				(or (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" player0) (not (player_is_in_game player0)))
				(or (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" player1) (not (player_is_in_game player1)))
				(or (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" player2) (not (player_is_in_game player2)))
				(or (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad intro_falcon_01 0) "" player3) (not (player_is_in_game player3)))
			)
		)
	)

	(f_unblip_object (ai_vehicle_get_from_squad intro_falcon_01 0))
	
	; respawn
	;(set respawn_players_into_friendly_vehicle TRUE)
	(game_safe_to_respawn FALSE)

	(if (not (game_is_cooperative))
		(begin
			(print "spartans in seat")
			;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" FALSE)
			(sleep_until
				(and
					(vehicle_test_seat_unit (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" (ai_get_unit (object_get_ai obj_carter)))
					(vehicle_test_seat_unit (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" (ai_get_unit (object_get_ai obj_jorge)))
				)
			5 200)
			
			(if
				(not (and
					(vehicle_test_seat_unit (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" (ai_get_unit (object_get_ai obj_carter)))
					(vehicle_test_seat_unit (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" (ai_get_unit (object_get_ai obj_jorge)))
				))
				(begin
					;(ai_vehicle_enter_immediate (object_get_ai obj_carter) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
					;(ai_vehicle_enter_immediate (object_get_ai obj_jorge) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")
					(unit_enter_vehicle_immediate (ai_get_unit (object_get_ai obj_carter)) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
					(unit_enter_vehicle_immediate (ai_get_unit (object_get_ai obj_jorge)) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")
				)
			)
		)
	)
	
	(if (>= (game_coop_player_count) 3)
		(unit_enter_vehicle_immediate (ai_get_unit (object_get_ai obj_carter)) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench")
	)
	
	(sleep 30)
	
	(cs_run_command_script (object_get_ai (vehicle_driver (ai_vehicle_get_from_squad intro_falcon_01 0))) cs_3kiva_falcon_evac_exit)
	
	(game_save)
	(wake md_outpost_sitrep02)
	
	; set obj early
	;(ai_set_objective group_spartans obj_outpost_ext_hum)
	
	; create bsp cap
	(object_create sc_020_cap)
	(object_create sc_030_cap)
)

(script static void (load_player_into_falcon (unit player_num) (ai falcon_squad))
	(if (not (vehicle_test_seat_unit_list  (ai_vehicle_get_from_squad falcon_squad 0) "" player_num))
	(begin
	
	
	(cond
		((not (vehicle_test_seat (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_r2"))
			(unit_enter_vehicle_immediate player_num (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_r2")
		)
		
		((not (vehicle_test_seat (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_l2"))
			(unit_enter_vehicle_immediate player_num (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_l2")
		)

		((not (vehicle_test_seat (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_r1"))
			(if (>= (game_coop_player_count) 3)
				(unit_enter_vehicle_immediate player_num (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_r1")
			)
		)
		
		((not (vehicle_test_seat (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_l1"))
			(if (>= (game_coop_player_count) 3)
				(unit_enter_vehicle_immediate player_num (ai_vehicle_get_from_squad falcon_squad 0) "falcon_p_l1")
			)
		)
	)
	
	
	)
	)
)

(script static void 3kiva_falcon_ecav_jun
	(print "3kiva_falcon_ecav_jun")
	(if (not (game_is_cooperative))
			(begin
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" FALSE)
				(ai_place spartan_jun/3kiva)
				(set obj_jun (ai_get_unit group_jun))
				(ai_cannot_die group_spartans TRUE)
				(ai_disregard (ai_actors group_jun) TRUE)
				(ai_set_objective group_jun obj_3kiva_hum)
				(sleep 1)
				(ai_vehicle_enter_immediate group_jun (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2")
			)
	)
)

(script static void 3kiva_falcon_ecav_setup
	(print "3kiva_falcon_ecav_setup")
	; reserve non-spartans seats
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" TRUE)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" FALSE)
	
	(wake falcon_weapon_drop_players)
	;(ai_place 3kiva_falcon_evac)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_d" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" FALSE FALSE)
	
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" TRUE FALSE)
	
	(if (game_is_cooperative)
		(begin
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" FALSE FALSE)
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" TRUE FALSE)
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" TRUE FALSE)
		)
	)
	
	(if (>= (game_coop_player_count) 3)
		(begin
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" FALSE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" TRUE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" TRUE)
	
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" TRUE FALSE)
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" TRUE FALSE)
		)
	)
	
)

(script dormant 3kiva_falcon02_start
	(cond
		((<= 3kiva_troopers_bsp 2)
			(begin
				(ai_place 3kiva_falcon02/02)
				(object_set_scale (ai_vehicle_get_from_squad 3kiva_falcon02 0) .01 0)
				(sleep 1)
				;(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_circle02)
				(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_entry02)
				(ai_set_objective 3kiva_falcon02 obj_3kiva02_hum)
			)
		)
		((= 3kiva_troopers_bsp 3)
			(begin
				(ai_place 3kiva_falcon02/03)
				(object_set_scale (ai_vehicle_get_from_squad 3kiva_falcon02 0) .01 0)
				(sleep 1)
				;(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_circle03)
				(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_entry03)
				(ai_set_objective 3kiva_falcon02 obj_3kiva03_hum)
			)
		)
	)
	
	(ai_set_targeting_group 3kiva_falcon02 2)
	(sleep 1)
	(object_set_scale (ai_vehicle_get_from_squad 3kiva_falcon02 0) 1 90)
	
	
	
	(sleep_until 3kiva_done)
	
	(cond
		((= 3kiva_troopers_bsp 2)
			(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_evac02))
		((= 3kiva_troopers_bsp 3)
			(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_falcon02) cs_3kiva_falcon02_evac03))
	)

)


; falcon evav start cs =======================================================================================================================================
(script dormant 3kiva_falcon_evac_failsafe
	(cond
		((= 3kiva_troopers_bsp 2)
			(wake 3kiva_falcon_evac02_failsafe))
		((= 3kiva_troopers_bsp 3)
			(wake 3kiva_falcon_evac03_failsafe))
	)
)


(script command_script cs_3kiva_falcon_evac02
	(cs_enable_pathfinding_failsafe TRUE)
	
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva02a)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva02c)
	(cs_face TRUE ps_air_3kiva_falcon_evac/3kiva02_face)
	(cs_vehicle_speed .1)
	(cs_fly_to ps_air_3kiva_falcon_evac/3kiva02_land02 1)
	(cs_run_command_script ai_current_actor cs_3kiva_falcon_evac_finish)
	
)

(script dormant 3kiva_falcon_evac02_failsafe
	(if (volume_test_object tv_3kiva02_falcon_failsafe (ai_vehicle_get_from_squad intro_falcon_01 0))
		(begin
			(print "Evac Falcon in position")
			(sleep_forever)
		)
	)
	(print "3kiva Evac02 falcon FAILSAFE!!! FILE BUG!")
	(ai_erase intro_falcon_01)
	(sleep 1)
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/3kiva)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0)  ps_air_3kiva_falcon_evac/3kiva02a)
	(sleep 1)
	(3kiva_falcon_ecav_setup)
	(3kiva_falcon_ecav_jun)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon_evac02)
	
)


(script command_script cs_3kiva_falcon_evac03
	(cs_enable_pathfinding_failsafe TRUE)
	
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva03_teleport)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva03_jun01)
	(cs_vehicle_speed .3)
	;(cs_face TRUE ps_air_3kiva_falcon_evac/3kiva03_face)
	(cs_fly_to_and_face ps_air_3kiva_falcon_evac/3kiva03_jun_land ps_air_3kiva_falcon_evac/3kiva03_face 1)
	(cs_run_command_script ai_current_actor cs_3kiva_falcon_evac_finish)
	
)

(script dormant 3kiva_falcon_evac03_failsafe
	(if (volume_test_object tv_3kiva03_falcon_failsafe (ai_vehicle_get_from_squad intro_falcon_01 0))
		(begin
			(print "Evac Falcon in position")
			(sleep_forever)
		)
	)
	
	(print "3kiva Evac03 falcon FAILSAFE!!! FILE BUG!")
	(ai_erase intro_falcon_01)
	(sleep 1)
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/3kiva)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0)  ps_air_3kiva_falcon_evac/3kiva03_teleport)
	(sleep 1)
	(3kiva_falcon_ecav_setup)
	(3kiva_falcon_ecav_jun)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_3kiva_falcon_evac03)
	
)


(script command_script cs_3kiva_falcon_circle02
	(print "cs_3kiva_falcon_circle02")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_3kiva_falcon02_evac02/circle01a)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_face TRUE ps_3kiva_falcon02_evac02/face02)
	(cs_vehicle_speed .7)
	(sleep_until
		(begin
			(cs_fly_by ps_3kiva_falcon02_evac02/circle01a)
			(cs_fly_by ps_3kiva_falcon02_evac02/circle01b)
			(cs_fly_by ps_3kiva_falcon02_evac02/circle01c)
			FALSE
		)
	)
)

(script command_script cs_3kiva_falcon02_entry02
	(print "cs_3kiva_falcon02_entry02")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_3kiva_falcon02_evac02/circle01a)
	(sleep_forever)
)

(script command_script cs_3kiva_falcon02_evac02
	(cs_fly_to ps_3kiva_falcon02_evac02/circle01a)
	(cs_vehicle_speed .6)
	(cs_fly_to ps_3kiva_falcon02_evac02/land)
	
	(if (>= (ai_living_count group_3kiva_troopers) 1)
		(begin
			(wake md_3kiva_troopers_evac)
			(cs_face TRUE ps_3kiva_falcon02_evac02/face01)
			(cs_vehicle_speed .1)
			(cs_fly_to ps_3kiva_falcon02_evac02/land02 1)
			
			(sleep_until
				(begin
					(ai_vehicle_enter 3kiva_troopers_bsp02 (ai_vehicle_get ai_current_actor) "")
					(f_all_squad_in_vehicle group_3kiva_troopers ai_current_squad)
				)
			30 1000)
			
			(sleep 50)
			(ai_vehicle_enter_immediate 3kiva_troopers_bsp02 (ai_vehicle_get ai_current_actor) "")
			(print "troopers loaded")
			(cs_vehicle_speed 1)
			(cs_face FALSE ps_3kiva_falcon02_evac02/face01)
		)
	)
	(cs_fly_by ps_3kiva_falcon02_evac02/flyby02)
	(cs_fly_by ps_3kiva_falcon02_evac02/flyby03)
	(cs_fly_by ps_3kiva_falcon02_evac02/flyby04)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_3kiva_falcon_circle03
	(print "cs_3kiva_falcon_circle03")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_3kiva_falcon02_evac03/circle01a)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_face TRUE ps_3kiva_falcon02_evac03/face01)
	(cs_vehicle_speed .7)
	(sleep_until
		(begin
			(cs_fly_by ps_3kiva_falcon02_evac03/circle01a)
			(cs_fly_by ps_3kiva_falcon02_evac03/circle01b)
			(cs_fly_by ps_3kiva_falcon02_evac03/circle01c)
			FALSE
		)
	)
)

(script command_script cs_3kiva_falcon02_entry03
	(print "cs_3kiva_falcon02_entry03")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_3kiva_falcon02_evac03/circle01a)
	(sleep_forever)
)

(script command_script cs_3kiva_falcon02_evac03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to ps_3kiva_falcon02_evac03/circle01c)
	(cs_vehicle_speed .6)
	(cs_fly_to ps_3kiva_falcon02_evac03/land)
	
	(if (>= (ai_living_count group_3kiva_troopers) 1)
		(begin
			(wake md_3kiva_troopers_evac)
			(cs_face TRUE ps_3kiva_falcon02_evac03/face01)
			(cs_vehicle_speed .1)
			(cs_fly_to ps_3kiva_falcon02_evac03/land02 1)
			
			(sleep_until
				(begin
					(ai_vehicle_enter 3kiva_troopers_bsp03 (ai_vehicle_get ai_current_actor) "")
					(f_all_squad_in_vehicle group_3kiva_troopers ai_current_squad)
				)
			30 1000)
			
			(sleep 50)
			(ai_vehicle_enter_immediate 3kiva_troopers_bsp03 (ai_vehicle_get ai_current_actor) "")
			(print "troopers loaded")
			(cs_vehicle_speed 1)
			(cs_face FALSE ps_3kiva_falcon02_evac03/face01)
		)
	)
	(cs_fly_by ps_3kiva_falcon02_evac03/flyby02)
	(cs_fly_by ps_3kiva_falcon02_evac03/flyby03)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)


(script command_script cs_3kiva_falcon_evac_finish
	(cs_vehicle_speed .1)
	(wake md_3kiva_jun_evac)
	(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	(ai_vehicle_enter group_jorge (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")
	
	(if (>= (game_coop_player_count) 3)
		(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench")
	)
	
	(sleep 60)
	(f_blip_object_offset (ai_vehicle_get ai_current_actor) blip_default 1)
	
	;*
	(sleep_until
		(begin
			(cs_fly_to_and_face ps_air_3kiva_falcon_evac/3kiva03_jun_land ps_air_3kiva_falcon_evac/3kiva03_face 1)
			FALSE
		)
	)
	*;
	(sleep_forever)
)

; falcon evav cs =======================================================================================================================================

(script command_script cs_3kiva_falcon_evac_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .7)
	(cs_face TRUE ps_air_3kiva_falcon_evac/3kiva_exit01)
	
	(cond
		((= 3kiva_bsp 2) (cs_run_command_script ai_current_actor cs_3kiva_falcon_evac_exit_02))
		((= 3kiva_bsp 3) (cs_run_command_script ai_current_actor cs_3kiva_falcon_evac_outpost))
	)
	
)

(script command_script cs_3kiva_falcon_evac_exit_02
	; soft ceiling
	(soft_ceiling_enable all FALSE)
	(soft_ceiling_enable falcon_ride TRUE)
	(print "cs_3kiva_falcon_evac_exit_02")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .7)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva02_evac_exit02)
	(cs_vehicle_speed 1.5)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva02_evac_exit03)
	
	(cs_run_command_script ai_current_actor cs_3kiva_falcon_evac_outpost)
	
)

(script command_script cs_3kiva_falcon_evac_outpost
	(print "cs_3kiva_falcon_evac_outpost")
	
	; soft ceiling
	(soft_ceiling_enable all FALSE)
	(soft_ceiling_enable falcon_ride TRUE)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit 10)
	(cs_face FALSE ps_air_3kiva_falcon_evac/3kiva_exit01)
	
	(cs_attach_to_spline "spline_falcon")
	
	(cs_vehicle_speed .8)
	
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit01)
	
	(cs_attach_to_spline "")
	
	(cs_vehicle_speed 1)
	
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit02)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit03)
	(cs_vehicle_speed .6)
	
	(cs_attach_to_spline "spline_falcon02")
	
	(cs_fly_to ps_air_3kiva_falcon_evac/3kiva_exit04)
	(set g_outpost_ext_obj_control 10)
	(cs_attach_to_spline "")
	(cs_vehicle_speed .1)
	;(cs_face TRUE ps_air_3kiva_falcon_evac/3kiva_exit_face)
	;(cs_fly_to ps_air_3kiva_falcon_evac/3kiva_exit_unload 2)
	(cs_fly_to_and_face ps_air_3kiva_falcon_evac/3kiva_exit_unload ps_air_3kiva_falcon_evac/3kiva_exit_face 1)
	
	; soft ceiling
	(soft_ceiling_enable player_blocker_end TRUE) 
	(soft_ceiling_enable falcon_ride FALSE)
	
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn")
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" TRUE)
	
	
	(ai_set_objective group_carter obj_outpost_ext_hum)
	(ai_set_objective group_jorge obj_outpost_ext_hum)
	(sleep 10)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" FALSE TRUE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" FALSE TRUE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" FALSE TRUE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" FALSE TRUE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" FALSE TRUE)
	
	(if (game_is_cooperative)
		(begin
			(unit_exit_vehicle player0)
			(unit_exit_vehicle player1)
			(unit_exit_vehicle player2)
			(unit_exit_vehicle player3)
		)
	)
	(sleep_until (not (any_players_in_vehicle)) 5)

	(wake rain_outpost_start)
	(game_save)
	
	; TEMP
	(if (not (volume_test_objects vol_outpost_ext (ai_get_object group_carter)))
		(object_teleport_to_ai_point (ai_get_object group_carter) ps_air_3kiva_falcon_evac/3kiva_exit_face)
	)
	(if (not (volume_test_objects vol_outpost_ext (ai_get_object group_emile)))
		(object_teleport_to_ai_point (ai_get_object group_emile) ps_air_3kiva_falcon_evac/3kiva_exit_face)
	)
	
	(sleep 100)
	(wake falcon_weapon_drop_players_end)
	(cs_vehicle_speed .8)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit10 2)
	(cs_face FALSE ps_air_3kiva_falcon_evac/3kiva_exit_face)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_air_3kiva_falcon_evac/3kiva_exit11)
	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)

; falcon weapon drop scripts =======================================================================================================================================

(script dormant falcon_weapon_drop_players
	(wake falcon_weapon_drop_player0)
	(wake falcon_weapon_drop_player1)
	(wake falcon_weapon_drop_player2)
	(wake falcon_weapon_drop_player3)
)

(script dormant falcon_weapon_drop_players_end
	(sleep_forever falcon_weapon_drop_player0)
	(sleep_forever falcon_weapon_drop_player1)
	(sleep_forever falcon_weapon_drop_player2)
	(sleep_forever falcon_weapon_drop_player3)
)

(script dormant falcon_weapon_drop_player0
	(falcon_weapon_drop (ai_vehicle_get_from_squad intro_falcon_01 0) (player0))
)

(script dormant falcon_weapon_drop_player1
	(falcon_weapon_drop (ai_vehicle_get_from_squad intro_falcon_01 0) (player1))
)

(script dormant falcon_weapon_drop_player2
	(falcon_weapon_drop (ai_vehicle_get_from_squad intro_falcon_01 0) (player2))
)

(script dormant falcon_weapon_drop_player3
	(falcon_weapon_drop (ai_vehicle_get_from_squad intro_falcon_01 0) (player3))
)

(script static void (falcon_weapon_drop (vehicle falcon) (unit player_num))
	(sleep_until
		(begin
			;(vehicle_test_seat_list (ai_vehicle_get_from_squad intro_falcon_01 0) "" (player0))
			(sleep_until (vehicle_test_seat_unit_list falcon "" player_num) 1)
			(unit_lower_weapon player_num 30)
			(sleep_until (not (vehicle_test_seat_unit_list falcon "" player_num)) 1)
			(unit_raise_weapon player_num 30)
			FALSE
		)
	)
)



;====================================================================================================================================================================================================
; Outpost Exterior ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant outpost_ext_start
	; set third mission segment
	(data_mine_set_mission_segment "m10_03_outpost_ext")
	(print "outpost_ext start")
	
	; place ai
	(ai_place spartan_kat/outpost)
	(ai_place spartan_emile/outpost)
	(set obj_kat (ai_get_unit spartan_kat/outpost))
	(set obj_emile (ai_get_unit spartan_emile/outpost))
	(ai_cannot_die group_spartans TRUE)
	
	(wake kat_outpost_waypoint)
	(wake emile_outpost_waypoint)
	
	(ai_set_objective group_kat obj_outpost_ext_hum)
	(ai_set_objective group_emile obj_outpost_ext_hum)
	
	;(thespian_performance_setup_and_begin vig_outpost_hack "" 0)
	
	(ai_place outpost_extinit_grunts01)
	(ai_place outpost_extinit_jacks01)
	(ai_place outpost_extinit_jacks02)
	
	; targeting groups for player in falcon
	(ai_set_targeting_group group_outpost_ext_cov 2)
	(ai_set_targeting_group spartan_kat 2)
	(ai_set_targeting_group spartan_emile 2)
	
	; music
	(wake music_outpost_ext)
	
	; door setup
	(device_set_position_immediate dm_outpost_door01 0)
	
	; shitty vehicles
	(vehicle_set_player_interaction v_outpost_civ01 "" FALSE FALSE)
	(object_dynamic_simulation_disable v_outpost_civ01 TRUE)
	(vehicle_set_player_interaction v_outpost_civ02 "" FALSE FALSE)
	(object_dynamic_simulation_disable v_outpost_civ02 TRUE)
	
	(game_save)

	(sleep_until (not (any_players_in_vehicle)) 5)
	
	; respawn
	;(set respawn_players_into_friendly_vehicle FALSE)
	(game_safe_to_respawn TRUE)
	
	; targeting groups for player out of falcon
	(ai_set_targeting_group group_outpost_ext_cov -1)
	(ai_set_targeting_group spartan_kat -1)
	(ai_set_targeting_group spartan_emile -1)
	
	; set ui
	(set g_ui_obj_control 60)
	
	; unlock insertion
	(game_insertion_point_unlock 4)
	
	; reserve civ vehicles
	(ai_vehicle_reserve v_outpost_civ01 TRUE)
	(ai_vehicle_reserve v_outpost_civ02 TRUE)
	
	(game_save)
	
	
	(sleep_until (<= (ai_living_count obj_outpost_ext_cov) 3))
	(sleep_until 
		(or
			(volume_test_players tv_outpost_ext_control) 
			(<= (ai_living_count obj_outpost_ext_cov) 0)
		)		
	5)
	
	;this is to prevent a lull
	(if (volume_test_players tv_outpost_ext_control)
		;if player in control, bring forward
		(begin
			(ai_bring_forward group_carter 10)
			(ai_bring_forward group_jorge 10)
		)
		;if player not in control try to wait for player to arrive
		(sleep_until (volume_test_players tv_outpost_ext_control) 5 100)
	)
	(wake md_outpost_ext01)
	(sleep 100)

	(wake outpost_fork_start)
	(game_save)
	
	(sleep_until (>= g_outpost_ext_obj_control 30))
	
	(sleep_until (<= (device_get_position dm_outpost_blastdoor) .45) 1)
	(set g_outpost_ext_obj_control 40)
	(zone_set_trigger_volume_enable begin_zone_set:zoneset_outpost_interior TRUE)
	
	; kill volume for camera in courtyard
	(kill_volume_enable kill_tv_outpost_ext)
	
	;hack so that spartans and cov stop shooting each other
	(ai_set_targeting_group obj_outpost_ext_cov 2)
	
	(sleep 60)
	(thespian_performance_kill_by_ai group_spartans)
	
	(sleep 20)
	(thespian_performance_setup_and_begin vig_outpost_rally "" 0)
	
	; chapter title
	(wake chapter_03_start)
	
	(ai_disregard (ai_actors obj_outpost_ext_cov) TRUE)
	
	(sleep_until (= (device_get_position dm_outpost_blastdoor) 0))
	(sleep 60)
	(switch_zone_set zoneset_outpost_interior)
	(sleep_until (= (current_zone_set_fully_active) 7) 1)
	
	(sleep_until (>= g_outpost_ext_obj_control 50) 1 200)
	(device_set_position dm_outpost_door01 1)
	(sleep 40)
	(thespian_performance_kill_by_ai group_spartans)
	;(ai_set_objective group_spartans obj_outpost_int_hum)
	(ai_set_objective group_carter obj_outpost_int_hum)
	(ai_set_objective group_kat obj_outpost_int_hum)
	(ai_set_objective group_jorge obj_outpost_int_hum)
	
	(game_save)
	
)

(script dormant outpost_spartans_all_fallback
	(wake outpost_carter_fallback)
	(wake outpost_kat_fallback)
	(wake outpost_emile_fallback)
	(wake outpost_jorge_fallback)

)

(script dormant outpost_carter_fallback
	(outpost_spartan_fallback group_carter)
)

(script dormant outpost_kat_fallback
	(outpost_spartan_fallback group_kat)
)

(script dormant outpost_emile_fallback
	(outpost_spartan_fallback group_emile)
)

(script dormant outpost_jorge_fallback
	(outpost_spartan_fallback group_jorge)
)

(script static void (outpost_spartan_fallback (ai spartan))
	(sleep_until
		(begin
			(sleep_until (not (volume_test_object tv_outpost_ext_control spartan)))
			(if (>= g_outpost_ext_obj_control 40)
				(sleep_forever)
			)
			(ai_set_targeting_group spartan 2)
			(cs_run_command_script spartan cs_outpost_spartan_fallback)
			;(ai_disregard (ai_actors spartan) TRUE)
			(sleep_until (volume_test_object tv_outpost_ext_control spartan))
			(ai_set_targeting_group spartan -1)
			;(ai_disregard (ai_actors spartan) FALSE)
			(>= g_outpost_ext_obj_control 40)
		)
	5)
)

(script command_script cs_outpost_spartan_fallback
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to pts_outpost_ext/spartan_fallback .5)
)

(script dormant outpost_blastdoor_start
	(sleep_until (>= g_outpost_ext_obj_control 20) 30)
	(sleep 140)
	(ai_bring_forward group_carter 10)
	(ai_bring_forward group_emile 10)
	(ai_bring_forward group_jorge 10)
	
	(sleep_until
		(begin
			(sleep_until 
				(and
					(volume_test_object tv_outpost_ext_control obj_carter)
					(volume_test_object tv_outpost_ext_control obj_jorge)
					(volume_test_object tv_outpost_ext_control obj_emile)
				)
			30 500)
			(wake outpost_spartans_all_fallback)
			(print "spartans in volume or timeout")
			(sleep_until (volume_test_players_all tv_outpost_ext_control))
			(print "blastdoor:shutting")
			(device_set_power dm_outpost_blastdoor 1)
			(device_set_position dm_outpost_blastdoor 0)
			(sleep_until 
				(or
					(not (volume_test_players_all tv_outpost_ext_control))
					(<= (device_get_position dm_outpost_blastdoor) .6)
				)	
			1)
			(print "blastdoor:reopen")
			(if (not (<= (device_get_position dm_outpost_blastdoor) .6))
				(device_set_position dm_outpost_blastdoor .8)
				;if player stepped out:
				(wake md_outpost_ext_fallback_b) 
			)
			(<= (device_get_position dm_outpost_blastdoor) .6)
		)
	)
	
	(print "blastdoor:shunt")
	(object_create cr_shunt_outpostdoor)
	
	(sleep_until (<= (device_get_position dm_outpost_blastdoor) .45) 1)
	(sound_impulse_start sound\levels\solo\m10\sound_scenery\blast_doors\blast_door_oneshot\blast_door_close_mono dm_outpost_blastdoor 1)
	(sound_impulse_start sound\levels\solo\m10\sound_scenery\blast_doors\blast_door_oneshot\blast_door_close_surr dm_outpost_blastdoor 1)
	(sound_looping_stop sound\levels\solo\m10\sound_scenery\blast_doors\blast_door_loop\blast_door_loop)
	
	(sleep_until (= (device_get_position dm_outpost_blastdoor) 0) 5)
	(print "door:poweroff")
	(device_set_power dm_outpost_blastdoor 0)
)

(script dormant outpost_fork_start
	(print "outpost_fork")
	(ai_place outpost_fork)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork 0) 1 200)
	;(sleep_until (<= (ai_living_count outpost_fork) 2))
	;(sleep_until (<= (ai_living_count obj_outpost_ext_cov) 6))
	(sleep 750)
	
	(print "outpost_fork02")
	(ai_place outpost_fork02)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork02 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork02 0) 1 200)
	
	(sleep 600)
	(sleep_until (<= (ai_living_count outpost_fork02) 2))
	(sleep_until (<= (ai_living_count obj_outpost_ext_cov) 14))
	
	(print "outpost_fork03")
	(ai_place outpost_fork03)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork03 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad outpost_fork03 0) 1 200)
	
	(sleep 400)
	
	(wake md_outpost_ext_fallback)
	(wake outpost_blastdoor_start)
	
	(sleep 90)
	(ai_place outpost_banshees)
	(object_set_scale (ai_vehicle_get_from_squad outpost_banshees 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad outpost_banshees 1) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad outpost_banshees 0) 1 200)
	(object_set_scale (ai_vehicle_get_from_squad outpost_banshees 1) 1 200)
	
	(sleep_until (<= (ai_living_count obj_outpost_ext_cov) 0))
	(game_save)
)

(script command_script cs_outpost_fork_entry
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" outpost_ext_cov01 none outpost_ext_grunts01 none)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_outpost_ext/fork_entry01aa)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .6)
	(cs_fly_by pts_outpost_ext/fork_entry01a 1)
	(cs_vehicle_speed .4)
	(begin_random_count 1
		(cs_fly_to_and_face pts_outpost_ext/fork_entry01b pts_outpost_ext/face01 1)
		(cs_fly_to_and_face pts_outpost_ext/fork_entry01b pts_outpost_ext/face02 1)
	)
	(cs_fly_to pts_outpost_ext/fork_entry01b 1)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(cs_enable_targeting  TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	;(sleep 200)
	(cs_run_command_script ai_current_actor cs_outpost_fork_exit)
)

(script command_script cs_outpost_fork02_entry
	(f_load_fork (ai_vehicle_get ai_current_actor) "dual" outpost_ext_jacks02 outpost_ext_cov02 outpost_ext_skirms02 outpost_ext_grunts02)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_outpost_ext/fork_entry01aa)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .6)
	(cs_fly_by pts_outpost_ext/fork_entry01a)
	(cs_vehicle_speed .4)
	(begin_random_count 1
		(cs_fly_to_and_face pts_outpost_ext/fork_entry01b pts_outpost_ext/face01 2)
		(cs_fly_to_and_face pts_outpost_ext/fork_entry01b pts_outpost_ext/face02 2)
	)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(cs_enable_targeting  TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (>= (ai_living_count outpost_fork03) 1) 30 400)
	(cs_run_command_script ai_current_actor cs_outpost_fork_exit)
)

(script command_script cs_outpost_fork03_entry
	(if (= (game_difficulty_get) legendary)
		(f_load_fork (ai_vehicle_get ai_current_actor) "dual" outpost_ext_skirms03 outpost_ext_grunts03 outpost_ext_jacks03 outpost_ext_cov03_legendary)
		(f_load_fork (ai_vehicle_get ai_current_actor) "dual" outpost_ext_jacks03 outpost_ext_cov03 outpost_ext_skirms03 outpost_ext_grunts03)
	)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_outpost_ext/fork_entry01aa)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .6)
	(cs_fly_by pts_outpost_ext/fork_entry01a)
	(cs_vehicle_speed .4)
	(cs_fly_to_and_face pts_outpost_ext/fork_entry01b pts_outpost_ext/face01 2)
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(cs_fly_by pts_outpost_ext/fork_hover01)
	(cs_enable_targeting  TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (<= (ai_living_count obj_outpost_ext_cov) 7) 150)
	(cs_run_command_script ai_current_actor cs_outpost_fork_exit)
)

(script command_script cs_outpost_banshee_entry
	(cs_vehicle_boost TRUE)
	(ai_prefer_target_ai ai_current_actor group_spartans TRUE)
	
	;(sleep (random_range 200 220))
	(sleep 230)
	(cs_vehicle_boost FALSE)
	(cs_shoot_secondary_trigger TRUE)
	(sleep 20)

	(begin_random
		(cs_shoot_point TRUE ps_outpost_banshees/p0)
		(cs_shoot_point TRUE ps_outpost_banshees/p1)
		(cs_shoot_point TRUE ps_outpost_banshees/p2)
		(cs_shoot_point TRUE ps_outpost_banshees/p3)
		(cs_shoot_point TRUE ps_outpost_banshees/p4)
	)
	;(sleep (random_range 60 110))
	(sleep 40)

)


(script command_script cs_outpost_fork_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_to pts_outpost_ext/fork_exit01a)
	(cs_fly_to pts_outpost_ext/fork_exit01b)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)



;====================================================================================================================================================================================================
; Outpost Interior ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant outpost_int_start
	; set forth mission segment
	(data_mine_set_mission_segment "m10_04_outpost_int")
	(print "enc:outpost_exterior")

	(sleep_until (volume_test_players vol_outpost_ext_exit) 5)
	(set g_outpost_int_obj_control 10)
	
	; blip body
	(wake outpost_hud_body_start)
	
	; hurt trooper
	(ai_place outpost_int_trooper)
	(thespian_performance_setup_and_begin vig_outpost_trooper "" 0)
	(object_cannot_take_damage (ai_get_object outpost_int_trooper))
	
	; dialog
	(wake md_outpost_nightvision)
	
	; training
	(wake outpost_concussion_training)
	(if (not (game_is_cooperative))
		(wake training_health)
	)
	
	(ai_disposable obj_outpost_ext_cov TRUE)
	(device_set_position_immediate dm_outpost_door03 0)
	(game_save)
	
	
	;(sleep_until (volume_test_players vol_outpost_int_start) 1)
	

	(sleep_until (volume_test_players tv_body_search) 1)
	
	;cinematic
	(cinematic_enter 010lc_bodysearch true)
	
	; in case players are in the forklift
	(if (any_players_in_vehicle)
		(begin
			(unit_exit_vehicle player0)
			(unit_exit_vehicle player1)
			(unit_exit_vehicle player2)
			(unit_exit_vehicle player3)
			(sleep_until (not (any_players_in_vehicle)) 1)
		)
	)
	
	; zoneset
	;(prepare_to_switch_to_zone_set zoneset_end_cinematic)
	
	(object_destroy_folder cr_outpost_ext)
	(object_destroy v_outpost_ext_forklift)
	(object_destroy sc_sorvad)
	(object_destroy sc_sorvads_blood)
	(device_set_position dm_outpost_door02 0)
	
	(object_hide player0 TRUE)
	(object_hide player1 TRUE)
	(object_hide player2 TRUE)
	(object_hide player3 TRUE)
	
	(ai_erase_all)
	
	;cinematics needs a special version
	(object_destroy dm_outpost_door03)
	
	; music
	;(set g_music03 TRUE)
	(sleep 1)
	
	(if (or editor_cinematics (not (editor_mode))) 
		(begin
			(print "cinematic: 010lc_bodysearch")
			(f_play_cinematic_advanced 010lc_bodysearch zoneset_outpost_interior zoneset_end_cinematic)

		)
	)
	
	(object_create dm_outpost_door03)
	(device_set_position_immediate dm_outpost_door03 0)
	
	(object_teleport_to_ai_point player0 ps_teleports/outpost_cin_exit00)
	(object_teleport_to_ai_point player1 ps_teleports/outpost_cin_exit01)
	(object_teleport_to_ai_point player2 ps_teleports/outpost_cin_exit02)
	(object_teleport_to_ai_point player3 ps_teleports/outpost_cin_exit03)
	
	; profile
	(unit_add_equipment player0 profile_outpost TRUE FALSE)
	(unit_add_equipment player1 profile_outpost TRUE FALSE)
	(unit_add_equipment player2 profile_outpost TRUE FALSE)
	(unit_add_equipment player3 profile_outpost TRUE FALSE)
	
	(ai_place spartan_jorge/outpost02)
	(set obj_jorge (ai_get_unit spartan_jorge/outpost))
	(ai_cannot_die group_spartans TRUE)
	
	; zone set
	(switch_zone_set zoneset_end_cinematic)
	
	(cinematic_exit 010lc_bodysearch TRUE)
	
	; music
	(wake music_outpost_int)
	
	(set g_ui_obj_control 90)
	
	(ai_place outpost_int_elites01)
	(ai_place outpost_int_cov01)
	(ai_place outpost_int_cov02)
	(cs_run_command_script outpost_int_cov01 cs_interior_cov_hall01)
	(cs_run_command_script outpost_int_cov02 cs_interior_cov_hall01)
	(cs_run_command_script (object_get_ai obj_jorge) abort_cs)
	
	(game_save_immediate)
	
	
	(sleep_until (volume_test_players vol_outpost_combat) 5)
	(game_save)
	
	(sleep_until (volume_test_players vol_outpost_int_start02))
	(thespian_performance_setup_and_begin vig_outpost_elite_intro "" 0)
	(test_glowstick02)
	
	(sleep_until (volume_test_players vol_outpost_int_back01) 5)
	(ai_place outpost_int_jacks02)
	(ai_place outpost_int_grunts02)
	(game_save)
	
	(set g_music01 TRUE)
	
	(sleep_until (volume_test_players vol_outpost_int_back02) 5)
	(ai_place outpost_int_cov03)
	(game_save)
	
	; servers
	(wake outpost_servers)
	
	(sleep_until (volume_test_players vol_outpost_int_back_hall01) 5)
	(game_save)
	(ai_bring_forward group_jorge 4)
	(wake md_outpost_flush)
	
	(if (>= (game_coop_player_count) 2)
		(ai_place outpost_int_elites02a)
	)
	(ai_place outpost_int_elite_leader)
	(ai_place outpost_final_grunts01)
	(sleep 20)
	
	(wake outpost_server_door_close)
	
	(sleep_until (<= (ai_living_count obj_outpost_int_cov) 0))
	
	; music
	(set g_music03 TRUE)
	
	(wake md_outpost_finished)
	(device_set_power dc_outpost_end 1)
	
	(sleep_until (> (device_get_position dc_outpost_end) 0) 1)
	(wake outpost_servers_end)
	
	(object_destroy sc_outpost_console)
	(object_destroy sc_outpost_computer)
	(if (or editor_cinematics (not (editor_mode)))
		(f_end_mission 010ld_wintercontingency zoneset_end_cinematic02)
	)      
	(game_won)
	
)


(script dormant outpost_server_door_close
	(sleep_until (volume_test_players vol_outpost_int_rear02) 5)
	(device_set_power dm_outpost_server_door_init 1)
	(device_set_position dm_outpost_server_door_init 0)
	(sleep_until (= (device_get_position dm_outpost_server_door_init) 0))
	
	(if (volume_test_object kill_tv_outpost player0)
		(object_teleport_to_ai_point player0 ps_teleports/outpost_server00)
	)
	(if (volume_test_object kill_tv_outpost player1)
		(object_teleport_to_ai_point player1 ps_teleports/outpost_server01)
	)
	(if (volume_test_object kill_tv_outpost player2)
		(object_teleport_to_ai_point player2 ps_teleports/outpost_server02)
	)
	(if (volume_test_object kill_tv_outpost player3)
		(object_teleport_to_ai_point player3 ps_teleports/outpost_server03)
	)
	
	; kill volumes
	(kill_volume_enable kill_tv_outpost)
)


(script dormant outpost_hud_body_start
	(branch
		(volume_test_players tv_body_search)
		(hud_unblip_all)
	)
	
	(sleep_until (volume_test_players vol_outpost_int_bodyblip) 5)
	(sleep_until 
		(or
			(objects_can_see_object player0 sc_hud_outpost_body 25)
			(objects_can_see_object player1 sc_hud_outpost_body 25)
			(objects_can_see_object player2 sc_hud_outpost_body 25)
			(objects_can_see_object player3 sc_hud_outpost_body 25)
			
		)
	1)
	
	(wake md_outpost_search)
	(f_blip_object sc_hud_outpost_body blip_default)
	
)


(script dormant outpost_concussion_training
	(sleep_until
		(or
			(unit_has_weapon player0 objects\weapons\rifle\concussion_rifle\concussion_rifle.weapon)
			(unit_has_weapon player1 objects\weapons\rifle\concussion_rifle\concussion_rifle.weapon)
			(unit_has_weapon player2 objects\weapons\rifle\concussion_rifle\concussion_rifle.weapon)
			(unit_has_weapon player3 objects\weapons\rifle\concussion_rifle\concussion_rifle.weapon)
	   )
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)

(script static void outpost_elite_berserk
	(ai_berserk obj_outpost_int_cov/elite_last TRUE)
)

(script command_script cs_elite01
	(cs_abort_on_damage TRUE)
	;(sleep_until (volume_test_players vol_outpost_int_back01) 1)
	(sleep_until (volume_test_players vol_outpost_int_start02) 1)
	;(cs_go_to pts_outpost_int/eltie01_goto01a)
	;(cs_go_to pts_outpost_int/eltie01_goto01b)
)


(script command_script cs_interior_cov_hall01
	;(cs_abort_on_damage TRUE)
	(sleep_until (volume_test_players vol_outpost_int_start02) 1)
	(sleep 40)
)

;*
(script command_script cs_int_elite_leader
	(cs_abort_on_damage TRUE)
	(sleep_until 
		(or
			;(volume_test_players vol_outpost_int_start02)
			FALSE
			(<= (ai_living_count outpost_int_elites01) 0)
		)
	)
	
)
*;

(script command_script cs_interior_cov_hall01_queue
	(print "queued cs go")
)

;*
(script command_script cs_final_grunt_kam
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (< (objects_distance_to_object (ai_get_object ai_current_actor) player0) (random_range 1 4)) 5)
	(ai_grunt_kamikaze ai_current_actor)
)
*;


(script static boolean outpost_int_elite_back_prep
	(and
		(>= (object_get_shield (object_get_ai outpost_int_elites01)) .7)
		(>= (ai_task_count obj_outpost_int_cov/gate_front) 5)
	)
)

(script dormant outpost_servers
	(device_set_position dm_server04 .1)
	(device_set_position dm_server02 .3)
	(device_set_position dm_server03 0)
	(device_set_position dm_server06 .2)
	
	(sleep_until (volume_test_players vol_outpost_int_back_hall01) 5)
	(device_set_position dm_server06 0)
	(sleep 10)
	(device_set_position dm_server07 0)
	(sleep 14)
	(device_set_position dm_server11 .3)
	(sleep 9)
	(device_set_position dm_server13 .3)
	(sleep 35)
	(device_set_position dm_server02 1)
	(sleep 3)
	(device_set_position dm_server03 1)
	(sleep 9)
	(device_set_position dm_server04 1)
	(sleep 9)
	(device_set_position dm_server06 .1)
	
	(sleep 170)
	(sleep_until
		(begin
			(begin_random_count 1
				(device_set_position dm_server06 (real_random_range 0 .3))
				(device_set_position dm_server07 (real_random_range 0 .3))
				;(device_set_position dm_server07 1)
				;(device_set_position dm_server08 (real_random_range 0 .3))
				;(device_set_position dm_server08 1)
				(device_set_position dm_server10 0)
				(device_set_position dm_server10 1)
				(device_set_position dm_server11 (real_random_range 0 .3))
				;(device_set_position dm_server11 1)
			)
			(sleep (random_range 20 50))
		0)
	)
)

(script dormant outpost_servers_end
	(sleep_forever outpost_servers)
	;(sleep_until (volume_test_players vol_outpost_int_rear02) 5 90)
	(device_set_position dm_server01 1)
	(device_set_position dm_server02 1)
	(device_set_position dm_server03 1)
	(device_set_position dm_server04 1)
	(device_set_position dm_server05 1)
	(device_set_position dm_server06 1)
	(device_set_position dm_server07 1)
	(device_set_position dm_server08 1)
	(device_set_position dm_server09 1)
	(device_set_position dm_server10 1)
	(device_set_position dm_server11 1)
	(device_set_position dm_server12 1)
	(device_set_position dm_server13 1)
	(device_set_position dm_server14 1)
	(device_set_position dm_server15 1)
	(device_set_position dm_server16 1)
)


;==================================================================================================================
; Bob the Elite =========================================================================
;==================================================================================================================

(script command_script cs_bob_elite           
	(sleep_until
		(or
			(bob_will_run_from_player player0 ai_current_actor)
			(bob_will_run_from_player player1 ai_current_actor)
			(bob_will_run_from_player player2 ai_current_actor)
			(bob_will_run_from_player player3 ai_current_actor)
			(>= 3kiva_troopers_bsp 2)
		)
	)
	
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_dialogue TRUE)          
	(print "SPECIAL ELITE SPOTTED")                               
	(sleep (* 30 35))
	(ai_set_active_camo ai_current_actor TRUE)
	(sleep 90)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script static boolean (bob_will_run_from_player (player player_num) (ai bob))
	(and
		(or
			(or
				(> (object_get_recent_shield_damage (ai_get_object bob)) 0)
				(> (object_get_recent_body_damage (ai_get_object bob)) 0)
			)
			(< (objects_distance_to_object player_num bob) 25)
		)
		(= (player_is_in_game player_num) TRUE)
	)
)


;==================================================================================================================
; Recycling Scripts =========================================================================
;==================================================================================================================
(script continuous recycle_all_continuous
	(sleep_until
		(begin
			(if (volume_test_players vol_recycle_barn)
				(recycle_barn_lite_go)
				(recycle_barn_go)
			)
			
			(if (volume_test_players vol_recycle_meadow)
				(recycle_meadow_lite_go)
				(recycle_meadow_go)
			)
			
			(if (volume_test_players vol_recycle_3kiva)
				(recycle_3kiva_lite_go)
				(recycle_3kiva_go)
			)
			
			(if (volume_test_players vol_recycle_3kiva01)
				(recycle_3kiva01_lite_go)
				(recycle_3kiva01_go)
			)
			
			(if (volume_test_players vol_recycle_3kiva02)
				(recycle_3kiva02_lite_go)
				(recycle_3kiva02_go)
			)
			
			(if (volume_test_players vol_recycle_3kiva03)
				(recycle_3kiva03_lite_go)
				(recycle_3kiva03_go)
			)
			
			(if (volume_test_players vol_recycle_cliffside)
				(recycle_cliffside_lite_go)
				(recycle_cliffside_go)
			)
			
			(if (volume_test_players vol_recycle_outpost)
				(recycle_outpost_lite_go)
				(recycle_outpost_go)
			)
			
			FALSE
		)
	400)
)
 
(script static void recycle_barn_lite_go
	;(print "recycle:barn lite")
	(add_recycling_volume vol_recycle_barn 20 5)
)

(script static void recycle_barn_go
	;(print "recycle:barn")
	(add_recycling_volume vol_recycle_barn 0 0)
)


(script static void recycle_meadow_lite_go
	;(print "recycle:meadow lite")
	(add_recycling_volume vol_recycle_meadow 20 5)
)

(script static void recycle_meadow_go
	;(print "recycle:meadow")
	(add_recycling_volume vol_recycle_meadow 0 0)
)


(script static void recycle_3kiva_lite_go
	;(print "recycle:3kiva lite")
	(add_recycling_volume vol_recycle_3kiva 30 5)
)

(script static void recycle_3kiva_go
	;(print "recycle:3kiva")
	(add_recycling_volume vol_recycle_3kiva 0 0)
)


(script static void recycle_3kiva01_lite_go
	;(print "recycle:3kiva lite")
	(add_recycling_volume vol_recycle_3kiva01 20 5)
)

(script static void recycle_3kiva01_go
	;(print "recycle:3kiva")
	(add_recycling_volume vol_recycle_3kiva01 0 0)
)


(script static void recycle_3kiva02_lite_go
	;(print "recycle:3kiva lite")
	(add_recycling_volume vol_recycle_3kiva02 20 5)
)

(script static void recycle_3kiva02_go
	;(print "recycle:3kiva")
	(add_recycling_volume vol_recycle_3kiva02 0 0)
)


(script static void recycle_3kiva03_lite_go
	;(print "recycle:3kiva lite")
	(add_recycling_volume vol_recycle_3kiva03 20 5)
)

(script static void recycle_3kiva03_go
	;(print "recycle:3kiva")
	(add_recycling_volume vol_recycle_3kiva03 0 0)
)


(script static void recycle_cliffside_lite_go
	;(print "recycle:cliffside lite")
	(add_recycling_volume vol_recycle_3kiva 20 5)
)

(script static void recycle_cliffside_go
	;(print "recycle:cliffside")
	(add_recycling_volume vol_recycle_cliffside 0 0)
)


(script static void recycle_outpost_lite_go
	;(print "recycle:outpost lite")
	(add_recycling_volume vol_recycle_outpost 20 5)
)

(script static void recycle_outpost_go
	;(print "recycle:outpost")
	(add_recycling_volume vol_recycle_outpost 0 0)
)


;==================================================================================================================
; object control =========================================================================
;==================================================================================================================
(script dormant object_control
	;if in editor, create all objects
	(if (and (editor_mode) (not editor_object_management))
		(begin
			(print "(sleep_forever object_control)")
			(sleep_forever)
		)
	)
	
	(print "object_control")
	(objects_destroy_all)
			
	(if (= (current_zone_set) 0) (objects_manage_0))
	
	(sleep_until (>= (current_zone_set_fully_active) 1) 1)
	(objects_manage_1)
	
	(sleep_until (>= (current_zone_set_fully_active) 2) 1)
	(objects_manage_2)
	
	
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	(objects_manage_3)
	
	(sleep_until (>= (current_zone_set_fully_active) 4) 1)
	(objects_manage_4)
	
	(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	(objects_manage_5)
	
	(sleep_until (>= (current_zone_set_fully_active) 6) 1)
	(objects_manage_6)
	
	(sleep_until (>= (current_zone_set_fully_active) 7) 1)
	(objects_manage_7)
	
	(sleep_until (>= (current_zone_set_fully_active) 8) 1)
	(objects_manage_8)

)

(script static void objects_manage_0
	(object_create_folder sc_windmills01)
	(print "no objects to destroy")
)

(script static void objects_manage_1
	(object_create_folder sc_1stbowl)
	(object_create_folder cr_1stbowl)
	(print "no objects to destroy")
)

(script static void objects_manage_2
	(object_create_folder sc_barn)
	(object_create_folder cr_barn)
	(sleep 1)
	(print "no objects to destroy")
	(setup_barn_bodies)
)


(script static void objects_manage_3
	(print "no objects to create")
	(print "no objects to destroy")
)

(script static void objects_manage_4
	(object_destroy_folder sc_1stbowl)
	(object_destroy_folder cr_1stbowl)
	(sleep 1)
	(object_create_folder sc_3kiva)
	(object_create_folder cr_3kiva)
	(object_create_folder sc_windmills02)
)

(script static void objects_manage_5
	(object_destroy_folder sc_barn)
	(object_destroy_folder cr_barn)
	(object_destroy_folder sc_windmills01)
	(sleep 1)
	(object_create_folder sc_3kiva02)
	(object_create_folder cr_3kiva01)
	(object_create_folder cr_3kiva02)
	(if (not (>= (game_coop_player_count) 3))
		(object_create_folder cr_3kiva02_no3coop)
		(object_destroy_folder cr_3kiva02_no3coop)
	)
	(object_create_folder cr_3kiva03)
	(sleep 1)
	(setup_3kiva_bodies)
)

(script static void objects_manage_6
	(object_destroy_folder cr_3kiva01)
	(object_destroy_folder cr_3kiva02)
	(object_destroy_folder cr_3kiva02_no3coop)
	(object_destroy_folder cr_3kiva03)
	(object_destroy_folder sc_windmills02)
	(sleep 1)
	(object_create_folder sc_outpost)
	(object_create_folder cr_outpost)
	(object_create_folder cr_outpost_ext)
	(object_create_folder v_outpost)
	(object_create_folder sc_windmills01)
	(sleep 1)
	
)

(script static void objects_manage_7
	(object_create_folder sc_outpost02)
)

(script static void objects_manage_8
	(object_create_folder sc_outpost03)
	(sleep 1)
	(setup_outpost_bodies)
)

(script static void objects_destroy_all
	(print "destroying all objects")
	(object_destroy_folder sc_1stbowl)
	(object_destroy_folder cr_1stbowl)
	(object_destroy_folder sc_barn)
	(object_destroy_folder cr_barn)
	(object_destroy_folder sc_windmills01)
	(object_destroy_folder sc_windmills02)
	(object_destroy_folder sc_3kiva)
	(object_destroy_folder sc_3kiva02)
	(object_destroy_folder cr_3kiva)
	(object_destroy_folder cr_3kiva01)
	(object_destroy_folder cr_3kiva02)
	(object_destroy_folder cr_3kiva02_no3coop)
	(object_destroy_folder cr_3kiva03)
	(object_destroy_folder sc_outpost)
	(object_destroy_folder sc_outpost02)
	(object_destroy_folder sc_outpost03)
	(object_destroy_folder cr_outpost)
	(object_destroy_folder cr_outpost_ext)
	(object_destroy_folder v_outpost)
	(object_destroy_folder bi_outpost)

)


(script static void setup_barn_bodies
	(print "setup_barn_bodies")
	(scenery_animation_start sc_barn_deadmarine05 objects\characters\marine\marine death_pose_2:idle:var1)
	(scenery_animation_start sc_barn_deadmarine01 objects\characters\marine\marine deadbody_02)
	(scenery_animation_start sc_barn_deadmarine03 objects\characters\marine\marine deadbody_09)
	;(scenery_animation_start sc_barn_deadmarine04 objects\characters\marine\marine deadbody_14)
	
	(scenery_animation_start sc_barn_deadciv01 objects\characters\marine\marine deadbody_01)
	(scenery_animation_start sc_barn_deadciv02 objects\characters\marine\marine deadbody_02)
	(scenery_animation_start sc_barn_deadciv03 objects\characters\marine\marine deadbody_03)
	
	(scenery_animation_start sc_barn_deadciv04 objects\characters\civilian_female\civilian_female deadbody_01)
	(scenery_animation_start sc_barn_deadciv05 objects\characters\civilian_female\civilian_female deadbody_02)
	(scenery_animation_start sc_barn_deadciv06 objects\characters\civilian_female\civilian_female deadbody_03)

)


(script static void setup_3kiva_bodies
	(scenery_animation_start sc_3kiva_deadciv01a objects\characters\civilian_female\civilian_female deadbody_02)
	(scenery_animation_start sc_3kiva_deadciv01b objects\characters\marine\marine deadbody_01)
	(scenery_animation_start sc_3kiva_deadciv01c objects\characters\marine\marine deadbody_02)
	
	(scenery_animation_start sc_3kiva_deadciv02a objects\characters\marine\marine deadbody_01)
	
	(scenery_animation_start sc_3kiva_deadciv03a objects\characters\marine\marine deadbody_02)
	(scenery_animation_start sc_3kiva_deadciv03b objects\characters\civilian_female\civilian_female deadbody_02)
	(scenery_animation_start sc_3kiva_deadciv03c objects\characters\civilian_female\civilian_female deadbody_03)
	
	(scenery_animation_start sc_3kiva_deadmarine01 objects\characters\marine\marine deadbody_11)
	(scenery_animation_start sc_3kiva_deadmarine02 objects\characters\marine\marine deadbody_14)
	(scenery_animation_start sc_3kiva_deadmarine03 objects\characters\marine\marine deadbody_15)

)

(script static void setup_outpost_bodies
	(scenery_animation_start sc_outpost_deadmarine01 objects\characters\marine\marine deadbody_04)
	(scenery_animation_start sc_outpost_deadmarine02 objects\characters\marine\marine deadbody_08)
	(scenery_animation_start sc_outpost_deadmarine03 objects\characters\marine\marine deadbody_06)
	(scenery_animation_start sc_outpost_deadmarine04 objects\characters\marine\marine deadbody_07)

)