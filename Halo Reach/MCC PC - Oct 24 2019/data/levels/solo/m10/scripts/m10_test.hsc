(script static void 0
	(if (= game_speed 0)
		(set game_speed 1)
		(set game_speed 0)
	)
)

(script static void 1
	(if ai_render_sector_bsps
		(set ai_render_sector_bsps 0)
		(set ai_render_sector_bsps 1)
	)
)

(script static void 2
	(if ai_render_objectives
		(set ai_render_objectives 0)
		(set ai_render_objectives 1)
	)
)

(script static void 3
	(if ai_render_decisions
		(set ai_render_decisions 0)
		(set ai_render_decisions 1)
	)
)

(script static void 4
	(if ai_render_command_scripts
		(set ai_render_command_scripts 0)
		(set ai_render_command_scripts 1)
	)
)

(script static void 5
	(if debug_performances
		(set debug_performances 0)
		(set debug_performances 1)
	)
)

(script static void 6
	(if debug_instanced_geometry_cookie_cutters
		(begin
			(set debug_instanced_geometry_cookie_cutters 0)
			(set debug_structure_cookie_cutters 0)
		)
		(begin
			(set debug_instanced_geometry_cookie_cutters 1)
			(set debug_structure_cookie_cutters 1)
		)
	)
)

(script static ai (object_get_squad (object ai_obj))
	(ai_get_squad (object_get_ai ai_obj))
)


;*
(global short g_1stbowl_obj_control 1)
(global short g_barn_obj_control 1)
(global short g_meadow_obj_control 1)
(global short g_3kiva_obj_control 1)
(global short g_outpost_int_obj_control 1)
(global short g_outpost_ext_obj_control 1)

;obj conrol key
1stbowl
dropoff - 20
20 - blastdoor

witnesses - 30



outpost ext
hold em off - 12

we're in - 20
20 - blastdoor

everyone inside - 30

door closed - 40
40 - hack done

let's do this - 50
50 - door opens

kat hack idle?
soft ceiling

*;

; closed
;device_set_position_immediate dm_outpost_blastdoor .4

; 1stbowl falcons ============================================================================================================================================


(script static void test_1stbowl_falcons_start
	(ai_place spartan_carter)
	(ai_place spartan_kat)
	(ai_place spartan_jorge)
	(ai_place spartan_emile)
	(ai_place spartan_jun)
	
	(ai_cannot_die group_spartans TRUE)
	
	(ai_place intro_falcon_01)
	(ai_place intro_falcon_02)
	(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
	(objects_attach dm_falcon02_start "" (ai_vehicle_get_from_squad intro_falcon_02 0) "")
	
	(wake md_1stbowl_hover)
	
	(wake intro_falcon01_anim_start)
	(wake intro_falcon02_anim_start)
	(intro_falcons_setup_start)
	
	;(set b_training_look_done TRUE)
)

(script static void test_1stbowl_falcons_loop
	(ai_place intro_falcon_01)
	(ai_place intro_falcon_02)
	(ai_place spartan_carter)
	(ai_place spartan_kat)
	(ai_place spartan_jorge)
	(ai_place spartan_emile)
	(ai_place spartan_jun)
	
	(ai_cannot_die group_spartans TRUE)
	(intro_falcons_setup_start)
	(sleep_until
		(begin
			(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
			(objects_attach dm_falcon02_start "" (ai_vehicle_get_from_squad intro_falcon_02 0) "")
			
			(device_set_position_track dm_falcon01_start "m10_insert_dropoff_a" 0)
			(device_animate_position dm_falcon01_start 1 50.00 .1 .1 FALSE)	
			(device_set_position_track dm_falcon02_start "m10_insert_dropoff_b" 0)
			(device_animate_position dm_falcon02_start 1 55.00 .1 .1 FALSE)
			
			(sleep_until 
				(and
					(= (device_get_position dm_falcon01_start) 1)
					(= (device_get_position dm_falcon02_start) 1)
				)
			)
			(sleep 90)
			
			(objects_detach dm_falcon01_start (ai_vehicle_get_from_squad intro_falcon_01 0))
			(objects_detach dm_falcon02_start (ai_vehicle_get_from_squad intro_falcon_02 0))
			
			(object_destroy dm_falcon01_start)
			(object_destroy dm_falcon02_start)
			(sleep 1)
			(object_create dm_falcon01_start)
			(object_create dm_falcon02_start)

		0)
	1)
)

;*
(script static void test_1stbowl_falcons_hover_loop
	(ai_place intro_falcons)
	(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcons 0) "")
	;(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcons 1) "")
	(intro_falcons_setup_start)
	(sleep_until
		(begin
			(intro_falcon01_hover_start)
		0)
	1)
)
*;

(script static void test_1stbowl_falcons_dropoff_loop
	(ai_place intro_falcon_01)
	(ai_place intro_falcon_02)
	(sleep_until
		(begin
			(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
			(intro_falcons_setup_start)
			(intro_falcon01_dropoff_start)
			(object_destroy dm_falcon01_start)
			(object_create dm_falcon01_start)
		0)
	1)
)

(script static void test_1stbowl_falcons_startpoints
	(ai_place intro_falcon_01)
	(ai_place intro_falcon_02)
	(objects_attach dm_falcon01_start "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
	(objects_attach dm_falcon02_start "" (ai_vehicle_get_from_squad intro_falcon_02 0) "")
	
	(vehicle_load_magic (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1" player0)
)

(script static void test_1stbowl_falcons_endpoints
	(device_set_position_track dm_falcon01_start "m10_dropoff" 0)
	(device_animate_position dm_falcon01_start .568 .1 .1 .1 FALSE)
)

(script static void test_1stbowl_falcons_end
	(ai_place intro_falcon_01)
	(ai_place intro_falcon_02)
	;(object_create dm_1stbowl_falcon01_end)
	;(object_create dm_1stbowl_falcon02_end)
	;(objects_attach dm_1stbowl_falcon01_end "" v_1stbowl_falcon01_end "")
	;(objects_attach dm_1stbowl_falcon02_end "" v_1stbowl_falcon02_end "")
	(objects_attach sc_falcon01_end "" (ai_vehicle_get_from_squad intro_falcon_01 0) "")
	(objects_attach sc_falcon02_end "" (ai_vehicle_get_from_squad intro_falcon_02 0) "")
	
	(ai_place spartan_carter/carter)
	(ai_place spartan_kat/kat)
	(ai_place spartan_jun/jun)
	(ai_place spartan_emile/emile)
	(ai_place spartan_jorge/jorge)

	(set obj_carter (ai_get_unit spartan_carter/carter))
	(set obj_kat (ai_get_unit spartan_kat/kat))
	(set obj_jun (ai_get_unit spartan_jun/jun))
	(set obj_emile (ai_get_unit spartan_emile/emile))
	(set obj_jorge (ai_get_unit spartan_jorge/jorge))
	
	(ai_vehicle_enter_immediate (object_get_ai obj_carter) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn")
	(ai_vehicle_enter_immediate (object_get_ai obj_jun) (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1_wpn")
	(ai_vehicle_enter_immediate (object_get_ai spartan_kat) (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench_wpn")
	(ai_vehicle_enter_immediate (object_get_ai obj_emile) (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1_wpn")
	(ai_vehicle_enter_immediate (object_get_ai obj_jorge) (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1_wpn")
	
	(vehicle_load_magic (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" player0)
	(unit_lower_weapon player0 0)
	
	(wake md_1stbowl_unload)
	
	(if (not (game_is_cooperative))
		;if single player, train player to exit
		(begin
			(wake ct_training_exit_start)
			(vehicle_set_player_interaction (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" FALSE TRUE)
		)
	)
	
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench_wpn")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1_wpn")
	(test_1stbowl_falcons_end02)
	
	(if (not (game_is_cooperative))
		;if single player, wait for player to exit
		(begin
			(sleep_until (not (unit_in_vehicle (unit player0))) 1)
			(f_set_falcon_interaction_false (ai_vehicle_get_from_squad intro_falcon_01 0))
			(unit_raise_weapon player0 30)
		)
	)
	
	(sleep 60)
	;(object_destroy (ai_vehicle_get_from_squad intro_falcon_01 0))
	;(object_destroy (ai_vehicle_get_from_squad intro_falcon_02 0))
	(objects_detach sc_falcon01_end (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 .7)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_intro_falcons)
	
	(objects_detach sc_falcon02_end (ai_vehicle_get_from_squad intro_falcon_02 0))
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_02 0) 0 0 .7)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_02) cs_intro_falcons_02)
)

(script static void test_1stbowl_falcons_end02
	(print "wtf")
	(set g_1stbowl_obj_control 20)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r1_wpn" TRUE)
	;jorge
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench_wpn" TRUE)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench" TRUE)
	
	;jorge
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l1")
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_r2_wpn")
	;(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_l2_wpn")
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_02 0) "falcon_p_bench_wpn")
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2_wpn" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2_wpn" TRUE)
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench_wpn")
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_l2" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_r2" TRUE)
	(vehicle_unload (ai_vehicle_get_from_squad intro_falcon_01 0) "falcon_p_bench")
	
)

(script static void test_hog_effect
	(effect_new_at_ai_point "fx\fx_library\_placeholder\placeholder_explosion.effect" pts_1stbowl/fx_hog)
)


; 1stbowl beacon ===================================
(script static void test_beacon
	(ai_place spartan_carter)
	(ai_place spartan_kat)
	(ai_place spartan_emile)
	(object_teleport_to_ai_point (object_get_ai spartan_kat) ps_vig_beacon/goto01_kat)
	(object_teleport_to_ai_point (object_get_ai spartan_emile) ps_vig_beacon/goto_emile)
	
	(thespian_performance_activate "vig_beacon")
	
)


; 1stbowl witnesses ===================================
(script static void test_witnesses
	(set g_1stbowl_obj_control 20)
	;(device_set_position_immediate dm_kiva01_door .42)
	(ai_place 1stbowl_witnesses_dad)
	(ai_place 1stbowl_witnesses_family)
	(ai_place spartan_jorge/witnesses)
	(ai_place spartan_emile/witnesses)
	(ai_place spartan_carter)
	(sleep 1)
	(thespian_performance_activate "thes_witnesses")
	;*
	(thespian_performance_test "vig_witnesses")
	(thespian_performance_test "vig_witnesses02")
	(thespian_performance_test "vig_witnesses_jorge")
	(thespian_performance_test "vig_beacon")
	*;
	
	;(wake md_1stbowl_sprint)
	(wake hud_barn_start)
	(wake witnesses_player_kills)
	(wake md_1stbowl_witnesses)
	
	(sleep_until (volume_test_players tv_first_bowl_end) 5)
	(set g_1stbowl_obj_control 30)
	
)

; 1stbowl hack ===================================
(script static void test_hack
	(ai_place spartan_kat/outpost)
	(set obj_kat (ai_get_unit spartan_kat/outpost))
	(ai_set_objective group_spartans obj_outpost_ext_hum)
	
	(sleep 100)
	(print "KAT: Just... about... There!  We're in!")
	(f_md_ai_play 0 group_kat m10_2360)
	(set g_outpost_ext_obj_control 20)
	
	(sleep 400)
	(print "KAT: door shut")
	(set g_outpost_ext_obj_control 40)
	
)

; outpost flare ===================================
(script static void test_flare
	(ai_place spartan_jorge/outpost02)
	(set obj_jorge (ai_get_unit spartan_jorge/outpost))
	(ai_cannot_die group_spartans TRUE)
	(ai_set_objective group_jorge obj_outpost_int_hum)
	(ai_set_task_condition obj_outpost_int_hum/gate_jorge TRUE)
	
)

; 1stbowl spartans ===================================

(script static void test_1stbowl_spartans
	
	; spartans waypoints
	(spartan_waypoints)
	
	(ai_cannot_die group_spartans TRUE)
	
	;(wake spartan_alert_start)
	
	(wake rain_start)
	
	(test_1stbowl_falcons_end)
	;(sleep 60)
	;(test_1stbowl_falcons_end02)
	
	(sleep_until (not (any_players_in_vehicle)) 5)
	
	; zoneset
	(wake 1stbowl_zoneset_control)
	
	; chapter title
	(wake chapter_01_start)
	
	; objectives
	(wake obj_start)
	
	; dialog
	(wake md_1stbowl_orders)
	(wake md_1stbowl_next_structure)
	
	; kivas
	(wake 1stbowl_kiva_start)
	(wake witnesses_start)
	(wake hud_barn_start)
	
	;(wake hud_1stbowl_weapon)
	;(wake hud_1stbowl_beacon)
	;(wake 1stbowl_hog_approach_start)
	;(wake 1stbowl_skirm)
	
	(ai_dialogue_enable FALSE)
	
	(sleep_until (>= (current_zone_set_fully_active) 2) 5)
	(game_save)
	
	; wildlife
	(wake bowl_birds_start)
	(wake 1stbowl_wildlife_start)
	
	; highlight
	;(object_hide sc_hud_barn01_highlight TRUE)
	
	(sleep_until (volume_test_players tv_1stbowl_gas))
	(thespian_performance_kill_by_ai group_spartans)
	(bring_spartans_forward 8)
	;(wake md_1stbowl_beacon_found)
	(game_save)
		
	(sleep_until (volume_test_players tv_1stbowl_part2))
	(set warthog_done TRUE)
	(thespian_performance_kill_by_ai group_spartans)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_witnesses)
	;(sleep_forever hud_1stbowl_weapon)
	
	(sleep_until (volume_test_players tv_first_bowl_end) 5)
	(set g_1stbowl_obj_control 30)
	(bring_spartans_forward 8)
)

(script static void test_barn_call
	(ai_place barn_skirm01)
	(thespian_performance_setup_and_begin vig_barn_call "" 0)
)


(script static void test_1stbowl_kiva01_start
	(switch_zone_set zoneset_1stbowl)
	(sleep_until (= (current_zone_set_fully_active) 2) 1)
	
	(ai_place spartan_carter)
	(ai_place spartan_kat)
	(ai_place spartan_jorge)
	(ai_place spartan_emile)

	(set obj_carter (ai_get_unit spartan_carter/carter))
	(set obj_kat (ai_get_unit spartan_kat/kat))
	(set obj_jorge (ai_get_unit spartan_jorge/jorge))
	(set obj_emile (ai_get_unit spartan_emile/emile))
	
	(object_teleport obj_carter flag_teleport_1stbowl_kiva01)
	(object_teleport obj_kat flag_teleport_1stbowl_kiva02)
	(object_teleport obj_jorge flag_teleport_1stbowl_kiva03)
	(object_teleport obj_emile flag_teleport_1stbowl_kiva04)
	
	(object_teleport (player0) flag_teleport_1stbowl_kiva05)
	
	(sleep_until (volume_test_players vol_barn_start) 5)
	(wake barn_start)
)


; meadow elites ===================================
(script static void test_meadow_elites
	(ai_place meadow_cov_elites)
	
	; falcon
	(f_ai_place_vehicle_deathless_no_emp intro_falcon_01/barn)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) ps_air_meadow/falcon_circle02b)
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_meadowx)
)

(script command_script cs_falcon01_meadowx
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_face TRUE ps_air_meadow/meadow_face02)
	(cs_fly_by ps_air_meadow/falcon_circle02a)
	(cs_face FALSE ps_air_meadow/meadow_face02)
	(sleep_forever)
	(sleep_until
		(begin
			(cs_fly_by ps_air_meadow/falcon_circle02a)
			(cs_fly_by ps_air_meadow/falcon_circle02b)
			(cs_fly_by ps_air_meadow/falcon_circle02c)
			FALSE
		)
	)
	
)


(script static void test_meadow_evac
	(ai_place meadow_falcon02)
	(object_set_scale (ai_vehicle_get_from_squad meadow_falcon02 0) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get_from_squad meadow_falcon02 0) 1 (* 30 10))
	
	(ai_place spartan_kat/kat_barn)
	(ai_place spartan_emile/emile_barn)
	
	(set obj_kat (ai_get_unit spartan_kat/kat_barn))
	(set obj_emile (ai_get_unit spartan_emile/emile_barn))
	
	(ai_cannot_die group_spartans TRUE)

	(ai_set_objective all_humans obj_meadow_hum)
	
	(ai_teleport group_kat ps_teleports/meadow_evac)
	(ai_teleport group_emile ps_teleports/meadow_evac)
)

; 3kiva =======================================================
(script static void test_3kiva_hog
	;(object_teleport_to_ai_point v_3kiva_pickup_init ps_pickup_3kiva02/3kiva01)
	(object_teleport_to_ai_point v_3kiva_pickup_init ps_pickup_3kiva02/3kiva02)
	;(object_teleport_to_ai_point v_3kiva_pickup_init ps_pickup_3kiva/3kiva03)
	
	(ai_place spartan_carter/3kiva)
	(ai_cannot_die spartan_carter TRUE)
	(set obj_carter (ai_get_unit spartan_carter))

	(ai_vehicle_enter_immediate group_carter v_3kiva_pickup_init "warthog_d")
	(vehicle_load_magic v_3kiva_pickup_init "warthog_p" player0)
	
	(wake 3kiva_driver)
	
	(set 3kiva01_done TRUE)
	(set 3kiva02_done TRUE)
	;(set 3kiva03_done TRUE)
	
)


(script static void test_3kiva_jorge
	(ai_place spartan_jorge/3kiva)
	(ai_vehicle_enter_immediate group_jorge v_3kiva_pickup_init "pickup_g")
)

(script static void test_3kiva_loadup
	;(ai_vehicle_enter_immediate group_carter v_3kiva_pickup_init "warthog_p")
	(ai_vehicle_enter_immediate group_jorge v_3kiva_pickup_init "pickup_g")
)

(script static void test_barn_combat_falcon
	(f_ai_place_vehicle_deathless intro_falcon_01/barn)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01 0))
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0) ps_air_meadow/falcon_barn_entry)
	;(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_intro_falcons_barn)
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	(ai_set_objective intro_falcon_01 obj_airsupport_hum)
	(cs_run_command_script (f_ai_get_vehicle_driver intro_falcon_01) cs_falcon01_barn_combat)
	
)

(script static void test_3kiva_fork03
	(ai_place 3kiva_fork)
	(object_set_scale (ai_vehicle_get_from_squad 3kiva_fork 0) .01 1)
	(cs_run_command_script (f_ai_get_vehicle_driver 3kiva_fork) cs_kiva_test_fork)
	
)

(script command_script cs_kiva_test_fork
	(f_load_fork (ai_vehicle_get ai_current_actor) "right" 3kiva_fork_squad01 none none none)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 1)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	(cs_fly_by ps_air_3kiva_fork/3kiva_drop01a 5)
	
	(cs_run_command_script ai_current_actor cs_kiva_fork_02)

)

(script static void test_evac
	(ai_place intro_falcon_01/3kiva)
	(object_cannot_take_damage (ai_vehicle_get_from_squad intro_falcon_01/3kiva 0))
	(sleep 5)
	(object_set_velocity (ai_vehicle_get_from_squad intro_falcon_01 0) 0 0 10)
	
	(ai_place spartan_carter/3kiva)
	(set obj_carter (ai_get_unit spartan_carter/3kiva))
	(ai_place spartan_jorge/3kiva)
	(set obj_jorge (ai_get_unit spartan_jorge/3kiva))
	
	
	(wake 3kiva_location)
	(set g_3kiva_obj_control 3)
	(set 3kiva_done TRUE)
	
	
	(cond
		((volume_test_players vol_3kiva_2bsp)
			(begin
				;(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0)  ps_air_3kiva_falcon_evac/3kiva02a)
				(ai_teleport group_carter ps_teleports/3kiva_evac2_carter)
				(ai_teleport group_jorge ps_teleports/3kiva_evac2_carter)
				(ai_set_objective group_spartans obj_3kiva02_spartans)
				(object_create cr_3kiva_hogsite02)
				(ai_place 3kiva_troopers_bsp02)
				(set 3kiva_troopers_bsp 2)
			)
		)
		((volume_test_players vol_3kiva_3bsp)
			(begin
				;(object_teleport_to_ai_point (ai_vehicle_get_from_squad intro_falcon_01 0)  ps_air_3kiva_falcon_evac/3kiva03_teleport)
				(ai_teleport group_carter ps_teleports/3kiva_evac3_carter)
				(ai_teleport group_jorge ps_teleports/3kiva_evac3_carter)
				(ai_set_objective group_spartans obj_3kiva03_spartans)
				(object_create cr_3kiva_hogsite03)
				(ai_place 3kiva_troopers_bsp03)
				(set 3kiva_troopers_bsp 3)
			)
		)
	)
	
	(sleep 30)
	(wake 3kiva_falcon_ecav_start)

)


(script static void test_troopers
	(ai_place spartan_carter/3kiva)
	(ai_place spartan_jorge/3kiva)
	(cond
		((volume_test_players vol_3kiva_2bsp)
			(begin
				(set 3kiva_troopers_bsp 2)
				(wake 3kiva_troopers_bsp2)
				(ai_teleport group_carter ps_teleports/3kiva_evac2_carter)
				(ai_teleport group_jorge ps_teleports/3kiva_evac2_carter)
			)
		)
		((volume_test_players vol_3kiva_3bsp)
			(begin
				(set 3kiva_troopers_bsp 3)
				(wake 3kiva_troopers_bsp3)
				(ai_teleport group_carter ps_teleports/3kiva_evac3_carter)
				(ai_teleport group_jorge ps_teleports/3kiva_evac3_carter)
			)
		)
	)
	(set 3kiva_troopers_spoted TRUE)
	(set 3kiva_troopers_found TRUE)
	(wake md_3kiva_troopers_spoted)
	(wake obj_start)
	(wake 3kiva_defend_blip)
	(wake 3kiva_falcon_ecav_start)
	
	(sleep_until	
			(or
				(= (current_zone_set_fully_active) 6)
				(>= g_insertion_index 4)
			)
		1)
		
	(if (<= g_insertion_index 4) (wake outpost_ext_start))
	
)

(script static void test_evac_troopers
	(cond
		((volume_test_players vol_3kiva_2bsp)
			(begin
				(ai_place 3kiva_troopers_bsp02)
				(set 3kiva_troopers_bsp 2)
			)
		)
		((volume_test_players vol_3kiva_3bsp)
			(begin
				(ai_place 3kiva_troopers_bsp03)
				(set 3kiva_troopers_bsp 3)
			)
		)
	)
	
	(ai_place 3kiva_falcon02)
)

(script static void test_falcon_evac
	(switch_zone_set zoneset_3kiva)
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	(object_teleport_to_ai_point player0 ps_teleports/3kiva_evac3_carter)
	(sleep 1)
	(test_evac)

)

(script static void test_forklift_destroy
	(if (any_players_in_vehicle)
		(begin
			(unit_exit_vehicle player0)
			(unit_exit_vehicle player1)
			(unit_exit_vehicle player2)
			(unit_exit_vehicle player3)
			(sleep_until (not (any_players_in_vehicle)) 1)
		)
	)
	(set game_speed 0)
	(object_destroy v_outpost_ext_forklift)
)

(script static void test_outpost_interior_hall01
	(ai_place outpost_int_elites01)
	(ai_place outpost_int_cov01)
	(ai_place outpost_int_cov02)
	(cs_run_command_script outpost_int_cov01 cs_interior_cov_hall01)
	(cs_run_command_script outpost_int_cov02 cs_interior_cov_hall01)
	(cs_run_command_script (object_get_ai obj_jorge) abort_cs)
	
	(sleep_until (volume_test_players vol_outpost_int_back01) 5)
	(ai_place outpost_int_jacks02)
	
	(sleep_until (volume_test_players vol_outpost_int_back02) 5)
	(ai_place outpost_int_cov03)
	
	(sleep_until (volume_test_players vol_outpost_int_back_hall01) 5)
	(game_save)
	(ai_bring_forward obj_jorge 2)
	(wake md_outpost_flush)
	(sleep 100)
	(object_create outpost_flare)
	(sleep_until (volume_test_players vol_outpost_int_rear02) 1)
	(ai_place outpost_int_elites02a)
	(ai_place outpost_final_grunts01)
)

(script static void test_outpost_interior_server
	(ai_place outpost_final_grunts01)
	(ai_place outpost_int_elite_leader)
	(wake outpost_servers)
	(ai_set_task_condition obj_outpost_int_cov/gate_back TRUE)
	
	(sleep 20)
	;(device_set_position dm_outpost_server_door01 1)
)

(script static void test_lockup_elite
	(switch_zone_set zoneset_outpost_interior)
	(sleep_until (= (current_zone_set_fully_active) 9) 1)
	
	(object_create outpost_flare)
	
	(ai_place outpost_jorge)
	(set obj_jorge (ai_get_unit outpost_jorge/jorge))
	(ai_disregard (ai_actors outpost_jorge) TRUE)
	
	(ai_set_task_condition obj_outpost_int_cov/gate_back TRUE)
	(ai_set_task_condition obj_outpost_int_hum/gate_jorge TRUE)
	(ai_set_task_condition obj_outpost_int_hum/fight TRUE)
	
	(object_teleport (player0) fl_tele_lockup_elite)
	(object_teleport obj_jorge fl_tele_lockup_elite)
	
	(sleep_until (volume_test_players vol_outpost_int_rear02) 1)
	(ai_place outpost_final_grunts01)
	(sleep_forever)
	(ai_place outpost_int_elites02a)
)

(script static void test_glowstick
	(object_create cr_outpost_glowstick)
	(object_set_velocity cr_outpost_glowstick 4.5)
)

(script static void test_glowstick02
	(print "replace this bitch")
	(object_create cr_outpost_glowstick02)
	(object_set_velocity cr_outpost_glowstick02 7.5)
)

(script static void test_3kiva_objects
	(object_destroy_folder v_3kiva)
	(object_destroy_folder c_3kiva)
	(object_destroy_folder cr_3kiva)
	(object_destroy_folder cr_3kiva01)
	(object_destroy_folder cr_3kiva02)
	(object_destroy_folder cr_3kiva03)
	(object_destroy_folder sc_windmills02)
	(object_destroy_folder sc_windmills01)
	
	(object_destroy_folder sc_3kiva)
	(object_destroy_folder sc_hud)
	(object_destroy_folder dm_3kiva)
)


;====================================================================================================================================================================================================
; OLDE  ==============================================================================================================================================
;====================================================================================================================================================================================================


;*
;slow paced marines
(script dormant 3kiva01b_start
	(sleep_until (volume_test_players vol_3kiva01_approach02) 5)
	;place marines
	(game_save)
	(sleep 90)
	
	(sleep_until (<= (ai_living_count obj_3kiva01b_cov) 0))
	(sleep (random_range 60 90))
	(wake md_3kiva01_get_out)
	(print "3kiva01 done")
	(sleep_until 3kiva01_done 5 60)
	(set 3kiva01_done TRUE)
	(game_save)
	;(wake md_3kiva01_get_out)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(wake ct_objective_outpost_start)
)

;fast paced marines

(script dormant 3kiva01c_start
	(sleep_until (volume_test_players vol_3kiva01_approach01) 5)
	(ai_place 3kiva01_grunts01)
	(ai_place 3kiva01_grunts01b)
	(ai_place 3kiva01_cov01)
	(ai_place 3kiva01_marines)
	
	(sleep_until (volume_test_players vol_3kiva01_approach02) 5)
	;(set g_music01 TRUE)
	
	(sleep_until (<= (ai_living_count obj_3kiva01_cov) 7))
	(ai_place 3kiva01_skirms01)
	(sleep 90)
	
	(sleep_until (<= (ai_living_count obj_3kiva01_cov) 0))
	(wake 3kiva01_falcon_evac)
	
	(sleep_until (<= (ai_living_count 3kiva01_marines) 0))
	(print "3kiva01 done")
	(set 3kiva01_done TRUE)
	(ct_objective_complete_go)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
)

(script dormant 3kiva01b_fork_start
	(sleep_until 3kiva01_fork_called 1)
	;(cs_run_command_script obj_3kiva01b_cov abort_cs)
	;(hud_unmark_object (ai_get_object obj_3kiva01b_cov))
	(print "backup called!!!")
	;(ai_place 3kiva01b_fork)
	(ai_place 3kiva01b_skirms01)
	(wake md_3kiva01_fork_coming)
	;place fork
	(sleep 60)
)

(global short g_ai_list_index01 0)
(global short g_ai_list_index02 0)
(script static void 3kiva01b_fork_call_upper
	(sleep_forever)
	(print "3kiva01b_fork_call_upper")
	(sleep_until
		(begin
			(print "running cs")
			(cs_run_command_script (object_get_ai (list_get (ai_actors obj_3kiva01b_cov/upper_alert) g_ai_list_index01)) cs_kiva01_forkcall)
			;(hud_mark (list_get (ai_actors obj_3kiva01b_cov/upper_alert) g_ai_list_index01) 70)
			(sleep_until (not (cs_command_script_running (object_get_ai (list_get (ai_actors obj_3kiva01b_cov/upper_alert) g_ai_list_index01)) cs_kiva01_forkcall)))
			(set g_ai_list_index01 (+ g_ai_list_index01 1))
			(or
				3kiva01_fork_called
				(>= g_ai_list_index01 (list_count (ai_actors obj_3kiva01b_cov)))
			)
		)
	)
)

(script static void 3kiva01b_fork_call_lower
	(sleep_forever)
	(print "3kiva01b_fork_call_upper")
	(sleep_until
		(begin
			(print "running cs")
			(cs_run_command_script (object_get_ai (list_get (ai_actors obj_3kiva01b_cov/lower_alert) g_ai_list_index02)) cs_kiva01_forkcall)
			;(hud_mark (list_get (ai_actors obj_3kiva01b_cov/lower_alert) g_ai_list_index02) 70)
			(sleep_until (not (cs_command_script_running (object_get_ai (list_get (ai_actors obj_3kiva01b_cov/lower_alert) g_ai_list_index02)) cs_kiva01_forkcall)))
			(set g_ai_list_index02 (+ g_ai_list_index02 1))
			(or
				3kiva01_fork_called
				(>= g_ai_list_index02 (list_count (ai_actors obj_3kiva01b_cov)))
			)
		)
	)
)


(script command_script cs_kiva01_forkcall
	;(cs_custom_animation_loop objects\characters\grunt\grunt "combat:pistol:call_reinforcements" TRUE)
	;(sleep 80)
	(set 3kiva01_fork_called TRUE)
)

(script dormant 3kiva01_falcon_evac
	(object_create scenery_3kiva01_falcon)
	(if (>= 3kiva_objective_count 3)
		(begin
			(ai_place 3kiva_hogs/kiva01)
			(hud_mark (ai_vehicle_get_from_starting_location 3kiva_hogs/kiva01) 90)
		)
	)
	
	;(sleep_until (not (volume_test_players vol_3kiva01_approach02)) 5)
	(sleep 200)
	(object_destroy scenery_3kiva01_falcon)
	;(ai_erase 3kiva01_marines)
	
	(sleep_until (<= (ai_living_count obj_3kiva01_cov) 0))
	(if (volume_test_players vol_3kiva01_approach01)
		(begin
			(sleep 90)
			(print "Carter: motion tracker clear...")
			(sound_impulse_start sound\prototype\spartans\mission\400ma_270_car NONE 1)
			(game_save)
		)
	)
)

(script dormant 3kiva_objective_count_start
	(sleep_until (>= 3kiva_objective_count 1))
	(if 3kiva02_done
		(wake ct_objective_remaining_start)
	)
	;(md_3kiva_directions)
	(set g_music02 TRUE)
	
	(sleep_until (>= 3kiva_objective_count 2))
	(if 3kiva02_done
		(wake ct_objective_remaining_start)
	)
	;(md_3kiva_directions)
	(set g_music03 TRUE)
)

(script dormant 3kiva03_falcon_evac
	(object_create scenery_3kiva03_falcon)
	(if (>= 3kiva_objective_count 2)
		(begin
			(ai_place 3kiva_hogs/kiva03)
			(hud_mark (ai_vehicle_get_from_starting_location 3kiva_hogs/kiva03) (* 30 3))))
			
	;(sleep_until (not (volume_test_players vol_3kiva03_approach02)) 5)
	;(ai_place 3kiva02_skirms01)
	;(ai_place 3kiva02_skirms02)
	(sleep 200)
	;(sleep_until (volume_test_object vol_3kiva02_approach01 (list_get (ai_actors 3kiva02_marines) 0)))
	(object_destroy scenery_3kiva03_falcon)
	(ai_erase 3kiva03_marines)
	
	(sleep_until (<= (ai_living_count obj_3kiva03_cov) 0))
	(if (volume_test_players vol_3kiva01_approach01)
		(begin
			(sleep 90)
			(print "3kiva03 done")
			(print "Carter: motion tracker clear...")
			(sound_impulse_start sound\prototype\spartans\mission\400ma_270_car NONE 1)
			(game_save)
		)
	)
)

;====================================================================================================================================================================================================
; 3Kiva OLDE  ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant 3kiva_start
	(wake 3kiva_location)
	(wake 3kiva_waypoints)
	(object_set_persistent v_meadow_hog FALSE)
	(ai_disposable obj_meadow_cov TRUE)
	
	;(wake 3kiva_chatter)
	(wake music_3kiva)
	(ai_place 3kiva_air_support)
	(ai_cannot_die 3kiva_air_support TRUE)
	(object_cannot_take_damage (ai_vehicle_get_from_squad 3kiva_air_support 0))
	;(ai_place 3kiva_cov_init)
	
	(sleep_until (volume_test_players tv_3kiva_pickup))
	;(wake md_3kiva_pickup)
	
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	(wake 3kiva01_start)
	(wake 3kiva02_start)
	(wake 3kiva03_start)
	
	(ai_place 3kiva_cov01)
	(ai_place 3kiva_cov02)
	(ai_place 3kiva_cov03)
	
	;(ai_set_objective group_spartans obj_3kiva_hum)
	;(ai_bring_forward obj_carter 6)
	(game_save)
	
	(sleep_until 3kiva_done)
	(sleep_forever 3kiva_waypoints)
	(set g_music04 TRUE)
	(hud_unblip_all)
	
	(wake 3kiva_falcon_ecav_start)
	(sleep_until (volume_test_players tv_cliffside_start))
	(f_unblip_object (ai_vehicle_get_from_squad 3kiva_air_support 0))
	(ai_disposable group_3kiva_cov TRUE)
)

(script dormant 3kiva_blip_carter
	(f_blip_ai (object_get_ai obj_carter) blip_interface)
	(sleep_until (volume_test_players tv_3kiva_start02))
	(f_unblip_ai (object_get_ai obj_carter))
)

(script command_script cs_kiva_fork
	(f_load_fork (ai_vehicle_get ai_current_actor) "left" 3kiva_fork_squad01 none none none)
	;(f_load_fork (ai_vehicle_get ai_current_actor) "right" 3kiva03_cov_drop04 none none none)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) .01 0)
	(sleep 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))
	(cs_fly_by ps_air_3kiva_fork/3kiva_drop01a 5)
	
	(cond
		((= 3kiva_marine_bsp 2) (cs_run_command_script ai_current_actor cs_kiva_fork_02))
		((= 3kiva_marine_bsp 3) (cs_run_command_script ai_current_actor cs_kiva_fork_03))
	)
)

(script dormant 3kiva_chatter
	(print "chatter calm")
	(sound_impulse_start sound\prototype\m10_radio_chatter_instruction NONE 1)
	(sleep (- (sound_impulse_language_time sound\prototype\m10_radio_chatter_instruction) 30))
	;(wake md_3kiva01_start)
	(sound_looping_start sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping NONE 1)
	
	(sleep_until 3kiva01_done)
	(wake md_3kiva01_done)
	(print "3kiva01 done chatter calm... sleep 200")
	(sleep (random_range 150 200))
	;(sound_impulse_start sound\prototype\m10_radio_chatter_instruction NONE 1)
	;(sleep (- (sound_impulse_language_time sound\prototype\m10_radio_chatter_instruction) 60))
	(sound_looping_start sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping NONE 1)
	(sleep 90)
	(wake md_3kiva01_done02)
	
	;(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
)

(script dormant 3kiva_chatter_underfire
	(print "chatter under fire... sleep 200")
	(sleep (random_range 70 100))
	(set g_music01 TRUE)
	(sound_impulse_start sound\prototype\m10_radio_under_attack NONE 1)
	(sleep (- (sound_impulse_language_time sound\prototype\m10_radio_under_attack) 60))
	(sound_impulse_start sound\prototype\m10_radio_under_attack NONE 1)
	(wake md_3kiva_distress_response)
	;(wake ct_objective_marines_start02)
	;(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
)


(script static boolean f_3kiva_spawn_marines
	(cond
		((= 3kiva_objective_count 1)
			(begin
				(print "obj_count 1  1:15 chance")
				;(if (>= 1 (random_range 0 15))
				(if FALSE
					TRUE
				)
			)
		)

		((= 3kiva_objective_count 2) 
			TRUE
		)
	)
)

(script dormant 3kiva_waypoints
	(print "3kiva waypoints")
	(sleep_until (volume_test_players tv_3kiva_pickup) 30 b_waypoint_time)
	(if (not (volume_test_players tv_3kiva_pickup))
		(begin
			(f_blip_object v_3kiva_pickup_init blip_interface)
			(sleep_until (volume_test_players tv_3kiva_pickup))
			(hud_unblip_all)
		)
	)
	
	(sleep_until (volume_test_players vol_3kiva_1bsp) 30 b_waypoint_time)
	(if (not (volume_test_players vol_3kiva_1bsp))
		(begin
			(f_blip_object sc_hud_3kiva01 blip_recon)
			(sleep_until (volume_test_players vol_3kiva_1bsp))
			(hud_unblip_all)
		)
	)
	
	(print "3kiva waypoints: phase 1: player has found 3kiva space")
	(sleep_until 
		(or
			(= 3kiva_objective_count 2) 
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not (= 3kiva_objective_count 2))
		(begin
			(3kiva_blip_next_objective)
			(sleep_until (= 3kiva_objective_count 2))
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	

	(print "3kiva waypoints: phase 2: one objective found")
	(sleep_until 
		(or
			(>= 3kiva_jun_bsp 2)
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not (>= 3kiva_jun_bsp 2))
		(begin
			(3kiva_blip_next_objective)
			(sleep_until (>= 3kiva_jun_bsp 2))
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	
	
	(print "3kiva waypoints: phase 3: jun is placed")
	(sleep_until 
		(or
			3kiva_jun_spoted
			(volume_test_players tv_3kiva_beginning)
		)
	30 b_waypoint_time)
	
	(if (not 3kiva_jun_spoted)
		(begin
			(3kiva_blip_next_objective)
			(sleep_until 3kiva_jun_spoted)
			(hud_unblip_all)
		)
		(print "else: player doesn't need waypoint help")
	)
	(print "3kiva waypoints: DONE")
)

(script static void 3kiva_blip_next_objective
	(print "blip next obj")
	(if (and (not 3kiva01_visited) (not (>= 3kiva_jun_bsp 2)))
		(f_blip_object sc_hud_3kiva01 blip_recon)
	)
	(if (not 3kiva02_visited)
		(f_blip_object sc_hud_3kiva02 blip_recon)
	)
	(if (not 3kiva03_visited)
		(f_blip_object sc_hud_3kiva03 blip_recon)
	)
)

;============
(script dormant 3kiva01_start
	(sleep_until (volume_test_players vol_3kiva01_approach02) 5)
	(print "kiva01 start")
	(set 3kiva01_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
	
	(wake 3kiva01c_start)
	(sleep_until 3kiva01_done 5)
	;(set 3kiva_objective_count (+ 3kiva_objective_count 1))
)

;slow paced grunts
(script dormant 3kiva01c_start
	(print "kiva01 cov")
	(wake 3kiva01c_cov_start)
	(game_save)
	(sleep 90)
	
	(sleep_until 
		(or
			(<= (ai_living_count obj_3kiva01c_cov) 0)
			(not (= 3kiva_bsp 1))
		)
	)
	(if (= 3kiva_bsp 1)
		(begin
			(sleep (random_range 60 90))
			;(wake md_3kiva01_done)
			(sleep_until 3kiva01_done 5 60)
			;(wake md_3kiva01_get_out)
		)
	)
	
	(print "3kiva01 done")
	(set 3kiva01_done TRUE)
	(game_save)
)

(script dormant 3kiva01c_cov_start
	(if b_kiva_jun
		;if 3kiva jun
		(sleep_until (volume_test_players vol_3kiva01_approach02) 5)
		;if 3kiva marines
		(begin
			(wake md_3kiva01_briefing)
			(wake 3kiva01_hud)
		)
	)
	
	;(if (= 3kiva_objective_count 1)
	(if TRUE
		(begin
			(ai_place 3kiva01c_grunts01)
			(ai_place 3kiva01c_grunts02)
			(sleep_forever)
		)
	)
	
	(ai_place 3kiva01c_jacks01)
	(ai_place 3kiva01c_grunts01)
	(ai_place 3kiva01c_grunts02)
	(sleep_until (>= (ai_combat_status obj_3kiva01c_cov) ai_combat_status_certain))
	(sleep_until (<= (ai_living_count obj_3kiva01c_cov) 4))
	(ai_place 3kiva01c_skirms01)
)

;slow paced marines
(script dormant 3kiva01m_start
	(print "kiva01 marines")
	(wake 3kiva01_marines_start)
	(set 3kiva_marines_located TRUE)
	(game_save)
	
	(sleep_until (volume_test_players vol_3kiva01_approach04) 5)
	(wake md_3kiva_marines)
	(game_save)
	
	(ai_place 3kiva01_fork)
	(ai_set_objective 3kiva_cov03 obj_3kiva01m_cov)
	
	(sleep_until (<= (ai_living_count group_3kiva01_cov) 0) 30 (* 3 90))
	(sleep (random_range 60 90))
	
	(print "3kiva01 done")
	(wake md_3kiva_evac)
	(set 3kiva01_done TRUE)
	(set 3kiva_done TRUE)
	(game_save)
)

(script dormant 3kiva01_marines_start
	(wake md_3kiva01_briefing)
	(object_create w_kiva01_dmr)
	(object_create w_kiva01_ar)
	(ai_place 3kiva01_marines)
	(wake 3kiva01_hud)
	;(hud_mark_multiple 3kiva01_marines)
)

(script command_script cs_kiva01_fork
	(f_load_fork (ai_vehicle_get ai_current_actor) "left" 3kiva01_cov_drop01 3kiva01_cov_drop02 none none)
	(f_load_fork (ai_vehicle_get ai_current_actor) "right" 3kiva01_cov_drop03 none none none)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_air_3kiva_fork/3kiva01_drop01a)
	(cs_vehicle_speed .8)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva01_drop01b ps_air_3kiva_fork/3kiva01_face01b 1)
	
	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(sleep 60)
	(cs_vehicle_speed .1)
	(cs_fly_to_and_face ps_air_3kiva_fork/3kiva01_drop01c ps_air_3kiva_fork/3kiva01_face01c 1)
	(sleep 200)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_air_3kiva_fork/3kiva01_drop01a)
	(cs_fly_to ps_air_3kiva_fork/3kiva01_exit01a)
	(object_destroy (ai_vehicle_get ai_current_actor))
)


;============
(script dormant 3kiva02_start
	(sleep_until (volume_test_players vol_3kiva02_approach02) 5)
	(print "kiva02 start")
	(set 3kiva02_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
	
	(if (= 3kiva_marine_bsp 2)
		;spawn marines
		(wake 3kiva02m_start)
		;spawn cov
		(wake 3kiva02c_start)
	)
	
	(sleep_until 3kiva02_done 5)
	;(set 3kiva_objective_count (+ 3kiva_objective_count 1))
)

;slow paced grunts
(script dormant 3kiva02c_start
	(print "kiva02 cov")
	(wake 3kiva02c_cov_start)
	(set 3kiva_marine_bsp 3)
	(game_save)
	(sleep 90)
	(ai_place 3kiva_fork)
	;(wake 3kiva_fork_start)

	(sleep_until 
		(or
			(<= (ai_living_count obj_3kiva02c_cov) 0)
			(not (= 3kiva_bsp 2))
		)
	)
	(if (= 3kiva_bsp 2)
		(begin
			(sleep (random_range 60 90))
			(sleep_until 3kiva02_done 5 60)
		)
	)
	
	(print "3kiva02 done")
	(set 3kiva02_done TRUE)
	(game_save)
	
	(sleep_until (not (= 3kiva_bsp 2)))
	(game_save)
)

(script dormant 3kiva02c_cov_start
	(if b_kiva_jun
		;if 3kiva jun
		(sleep_until (volume_test_players vol_3kiva02_approach02) 5)
		;if 3kiva marines
		(begin
			(wake md_3kiva02_briefing)
			(wake 3kiva02_hud)
		)
	)
	
	(ai_place 3kiva02c_grunts01)
	(if (= 3kiva_objective_count 1)
		(begin
			(ai_place 3kiva02c_grunts02)
			(sleep_forever)
		)
	)
	
	;if (= 3kiva_objective_count 2)
	(ai_place 3kiva02c_jacks01)
	(ai_place 3kiva02c_grunts02)
	(sleep_until (>= (ai_combat_status obj_3kiva02c_cov) ai_combat_status_certain))
	(sleep_until (<= (ai_living_count obj_3kiva02c_cov) 4))
	(ai_place 3kiva02c_skirms01)
)

;slow paced marines
(script dormant 3kiva02m_start
	(print "kiva02 marines")
	(wake 3kiva02_marines_start)
	(set 3kiva_marines_located TRUE)
	(game_save)
	
	(sleep_until (volume_test_players vol_3kiva02_approach04) 5)
	(wake md_3kiva_marines)

	(game_save)
	(sleep 200)
	
	(ai_place 3kiva02_fork)
	(ai_set_objective 3kiva_cov03 obj_3kiva02c_cov)
	
	(sleep_until (<= (ai_living_count group_3kiva02_cov) 7))
	(sleep_until (<= (ai_living_count group_3kiva02_cov) 0) 30 (* 3 90))
	(sleep (random_range 60 90))
	
	(print "3kiva done")
	;(wake evac_start)
	(wake md_3kiva_evac)
	(set 3kiva02_done TRUE)
	(set 3kiva_done TRUE)
	(game_save)
	
	(sleep_until (<= (ai_living_count group_3kiva02_cov) 0))
	(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad 3kiva_air_support 0) "falcon_p_r1")
	(set g_music05 TRUE)
	(game_save)
)

(script dormant 3kiva02_marines_start
	;(wake md_3kiva02_briefing)
	(object_create w_kiva02_dmr)
	(object_create w_kiva02_ar)
	(object_create 3kiva02_dead_marine)
	(ai_place 3kiva02_marines)
	;(wake 3kiva02_hud)
)




;============
(script dormant 3kiva03_start
	(sleep_until (volume_test_players vol_3kiva03_approach02) 5)
	(print "kiva03 start")
	(set 3kiva03_visited TRUE)
	(set 3kiva_objective_count (+ 3kiva_objective_count 1))
	(hud_unblip_all)
	(sound_looping_stop sound\prototype\m10_radio_chatter_looping\m10_radio_chatter_looping)
	
	(if (= 3kiva_marine_bsp 3)
		;spawn marines
		(wake 3kiva03m_start)
		;spawn cov
		(wake 3kiva03c_start)
	)
	
	(sleep_until 3kiva03_done 5)
	;(set 3kiva_objective_count (+ 3kiva_objective_count 1))
)

;slow paced grunts
(script dormant 3kiva03c_start
	(print "kiva03 cov")
	(wake 3kiva03c_cov_start)
	(set 3kiva_marine_bsp 2)
	(game_save)
	(sleep 90)
	(ai_place 3kiva_fork)
	;(wake 3kiva_fork_start)
	
	(sleep_until 
		(or
			(<= (ai_living_count obj_3kiva03c_cov) 0)
			(not (= 3kiva_bsp 3))
		)
	)
	(if (= 3kiva_bsp 3)
		(begin
			(sleep (random_range 60 90))
			(sleep_until 3kiva03_done 5 60)
		)
	)
	
	(print "3kiva03 done")
	(set 3kiva03_done TRUE)
	(game_save)
	
	(sleep_until (not (= 3kiva_bsp 3)))
	(game_save)
)

(script dormant 3kiva03c_cov_start
	(if b_kiva_jun
		;if 3kiva jun
		(sleep_until (volume_test_players vol_3kiva03_approach02) 5)
		;if 3kiva marines
		(begin
			(wake md_3kiva03_briefing)
			(wake 3kiva03_hud)
		)
	)
	
	(ai_place 3kiva03c_grunts01)
	(if (= 3kiva_objective_count 1)
		(begin
			(ai_place 3kiva03c_grunts02)
			(sleep_forever)
		)
	)
	
	;(if (= 3kiva_objective_count 2)
	(ai_place 3kiva03c_jacks01)
	(ai_place 3kiva03c_grunts02)
	(ai_place 3kiva03c_marine)
	(sleep_until (>= (ai_combat_status obj_3kiva03c_cov) ai_combat_status_certain))
	(sleep_until (<= (ai_living_count obj_3kiva03c_cov) 4))
	(ai_place 3kiva03c_skirms01)
)

;slow paced marines
(script dormant 3kiva03m_start
	(print "kiva03 marines")
	(wake 3kiva03_marines_start)
	(set 3kiva_marines_located TRUE)
	(game_save)
	
	(sleep_until (volume_test_players vol_3kiva03_approach04) 5)
	(wake md_3kiva_marines)
	(game_save)
	
	(ai_place 3kiva03_fork)
	(ai_set_objective 3kiva_cov03 obj_3kiva03m_cov)
	
	(sleep_until (<= (ai_living_count group_3kiva03_cov) 7))
	(sleep_until (<= (ai_living_count group_3kiva03_cov) 0) 30 (* 3 90))
	(sleep (random_range 60 90))
	
	(print "3kiva03 done")
	;(wake evac_start)
	(wake md_3kiva_evac)
	(set 3kiva03_done TRUE)
	(set 3kiva_done TRUE)
	(game_save)
	
	(sleep_until (<= (ai_living_count group_3kiva03_cov) 0))
	(ai_vehicle_enter group_carter (ai_vehicle_get_from_squad 3kiva_air_support 0) "falcon_p_r1")
	(set g_music05 TRUE)
	(game_save)
)

(script dormant 3kiva03_marines_start
	;(wake md_3kiva03_briefing)
	(object_create w_kiva03_dmr)
	(object_create w_kiva03_ar)
	(ai_place 3kiva03_marines)
	;(wake 3kiva03_hud)
)

(script command_script cs_3kiva03_marine
	(sleep_until
		(begin
			;(cs_custom_animation objects\characters\marine\marine "any:any:sync_marine_desecration" TRUE)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
			(volume_test_players vol_3kiva03_2ndfloor)
		)
	)
	(ai_kill_silent ai_current_actor)
)

(script command_script cs_3kiva03_skirm01
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(cs_custom_animation objects\characters\jackal\jackal "any:any:sync_marine_desecration_a" TRUE)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
			(volume_test_players vol_3kiva03_2ndfloor)
		)
	)
	(cs_run_command_script ai_current_actor cs_3kiva03_skirm_exit)
)

(script command_script cs_3kiva03_skirm02
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(cs_custom_animation objects\characters\jackal\jackal "any:any:sync_marine_desecration_b" TRUE)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
			(volume_test_players vol_3kiva03_2ndfloor)
		)
	)
	(cs_run_command_script ai_current_actor cs_3kiva03_skirm_exit)
)

(script command_script cs_3kiva03_skirm03
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(cs_custom_animation objects\characters\jackal\jackal "any:any:sync_marine_desecration_c" TRUE)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
			(volume_test_players vol_3kiva03_2ndfloor)
		)
	)
	(cs_run_command_script ai_current_actor cs_3kiva03_skirm_exit)
)

(script command_script cs_3kiva03_skirm_exit
	(cs_abort_on_damage TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_abort_on_alert TRUE)
	;(cs_abort_on_combat_status ai_combat_status_certain)
	(sleep_forever)
)

(script dormant 3kiva_fork_hud
	(cond
		((= 3kiva_marine_bsp 2) (sleep_until (not (volume_test_players vol_3kiva03_approach02))))
		((= 3kiva_marine_bsp 3) (sleep_until (not (volume_test_players vol_3kiva02_approach02))))
	)
	
	(f_blip_object (ai_vehicle_get_from_squad 3kiva_fork 0) blip_neutralize)
	(cond
		((= 3kiva_marine_bsp 2) (sleep_until (volume_test_players vol_3kiva02_approach02)))
		((= 3kiva_marine_bsp 3) (sleep_until (volume_test_players vol_3kiva03_approach02)))
	)
	
	(f_unblip_object (ai_vehicle_get_from_squad 3kiva_fork 0))
)
*;