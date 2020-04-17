(script startup m35_insertion_stub
	(if debug (print "m35 insertion stub"))
)

;=========================================================================================
; HILL =========================================
;=========================================================================================

(script static void ins_hill
	(print "insertion point : ins_hill")
	(print "switching zone sets...")
	(switch_zone_set set_hill_intro)
	(sleep_until (= (current_zone_set_fully_active) 0) 1)
			
	; set insertion point index 
	(set g_insertion_index 1)
	
)

;=========================================================================================
; TWIN =========================================
;=========================================================================================

(script static void ins_twin
	
	; set insertion point index 
	(set g_insertion_index 2)	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_hill_transition)
	(sleep 1)
	
	; set mission progress accordingly 
	(set g_hill_obj_control 100)
	
	;bfg
	(wake twin_bfg_start)
	
	; sky
	;(wake flocks_start)
	;(wake frigate_setup)
	
	; place allies
	(ai_place sq_hill_allies_01)
	;(ai_place sq_hill_allies_02)
	(ai_place sq_hill_rockethog_01)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) ps_teleports/twin_ins01)
	
	(if (not (game_is_cooperative))
			(begin
				; kat
				(ai_place sq_hill_kat)
				(ai_cannot_die sq_hill_kat TRUE)
				(set obj_kat (ai_get_unit gr_kat))
	
				; spartans waypoints
				(if (not (game_is_cooperative))
					(wake spartan_waypoints_hill)
				)
	
				(ai_vehicle_enter_immediate gr_kat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p")
			)
	)
	
	(ai_set_objective gr_allies obj_twin_allies)
	
	; teleporting players
	(print "teleporting players...")
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" player0)
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g" player1)
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p" player2)
	(object_teleport_to_ai_point (player3) ps_teleports/twin_ins02)
	
	;twin exit bridge: called here for perf reasons
	(wake twin_bridge)
	
	(insertion_fade_to_gameplay)

	(game_save_immediate)			
)

;=========================================================================================
; FACILITY =========================================
;=========================================================================================

(script static void ins_facility
	
	; set insertion point index 
	(set g_insertion_index 3)	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_facility)
	(sleep_until (= (current_zone_set_fully_active) 4) 1)
	(sleep 1)
	
	; starting profiles
	(unit_add_equipment player0 profile_full_health TRUE FALSE)
	(unit_add_equipment player1 profile_full_health TRUE FALSE)
	(unit_add_equipment player2 profile_full_health TRUE FALSE)
	(unit_add_equipment player3 profile_full_health TRUE FALSE)
	
	; set mission progress accordingly 
	(set g_hill_obj_control 100)
	(set g_twin_obj_control 100)
	
	; sky
	(wake flocks_02_start)
	
	(ai_place sq_hill_rockethog_01/no_driver)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) ps_teleports/facility_ins01)
	(sleep 1)
	
	; teleporting players
	(print "teleporting players...")
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" player0)
	
	(if (not (game_is_cooperative))
			(begin
				; kat
				(ai_place sq_hill_kat/facility)
				(ai_cannot_die gr_kat TRUE)
				(set obj_kat (ai_get_unit gr_kat))
				(wake kat_control)
				(sleep 1)
				(ai_set_objective gr_allies obj_facility_allies)
				(sleep 1)
				
				; spartans waypoints
				(if (not (game_is_cooperative))
					(wake spartan_waypoints_hill)
				)
				
				(print "forcing kat into hog turret")
				(ai_vehicle_enter_immediate gr_kat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g")
			)
			
			;if coop
			(begin
				(print "teleporting coop players...")
				(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g" player1)
				(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p" player2)
				(object_teleport_to_ai_point player3 ps_teleports/facility_ins02)
			)
	)
	
	(wake md_facility_intro)
	(set g_bfg01_destroyed TRUE)
	(set g_twin_obj_control 5)
	
	; music
	(wake music_alpha)
	
	(insertion_fade_to_gameplay)

	(game_save_immediate)
	
	(sleep 90)
	(wake obj_02_adv01_start)
	
)

;=========================================================================================
; CANNON =========================================
;=========================================================================================

(script static void ins_cannon
	
	; set insertion point index 
	(set g_insertion_index 4)	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_cannon)
	(sleep 1)
	
	; slam door shut
	(if debug (print "facility blockers"))
	(device_set_position_immediate dm_facility_door_01 1)	
	
	; set mission progress accordingly 
	(set g_hill_obj_control 100)
	(set g_twin_obj_control 100)	
	(set g_facility_obj_control 15)
	
	(ai_place sq_hill_kat/cannon)
	(ai_cannot_die gr_kat TRUE)
	(set obj_kat (ai_get_unit gr_kat))
	(ai_set_objective gr_allies obj_facility_allies)
	(set g_falcon_obj_control 16)
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport (player0) fl_cannon_player0)
	(object_teleport (player1) fl_cannon_player1)
	(object_teleport (player2) fl_cannon_player2)
	(object_teleport (player3) fl_cannon_player3)
	(sleep 1)
	
	;BFG
	(wake cannon_bfg_start)
	
	; placing enemy AI
	(ai_place sq_cannon_ghost_01)
	(ai_place sq_cannon_ghost_02)
	
		(sleep 1)
		
	(ai_vehicle_reserve_seat sq_cannon_ghost_01 "ghost_d" TRUE)
	(ai_vehicle_reserve_seat sq_cannon_ghost_02 "ghost_d" TRUE)
	
	(device_set_position_immediate dm_facility_door_01 0)
	(set g_bfg01_destroyed TRUE)
	
	(insertion_fade_to_gameplay)

	(game_save_immediate)
	
	(sleep_until (volume_test_players tv_facility_16) 1)
	(if debug (print "set objective control 16"))
	(set g_facility_obj_control 16)
		
		(game_save)		
)

;=========================================================================================
; FALCON =========================================
;=========================================================================================

(script static void ins_falcon
	
	; set insertion point index 
	(set g_insertion_index 5)	
	
	; switch to correct zone set
	(print "switching zone sets...")
	(switch_zone_set set_cannon)
	(sleep 1)
	
	; set mission progress accordingly 
	(set g_hill_obj_control 100)
	(set g_twin_obj_control 100)	
	(set g_facility_obj_control 100)
	(set g_cannon_obj_control 100)
	
	; sky
	(wake flocks_03_start)
	
	; dead BFG
	(ai_place sq_cannon_bfg_driver)
	;*
	(sleep 1)
	(object_set_permutation (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) core destroyed)
	(object_set_permutation (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) core_shield destroyed)
	(object_set_permutation (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) gun destroyed)
	(object_set_permutation (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) lower destroyed)
	(object_set_permutation (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) upper destroyed)
	(sleep 1)
	(unit_kill (ai_get_unit sq_cannon_bfg_driver))
	*;

	(unit_kill (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0))
	(ai_place sq_cannon_ins_troopers)
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport (player0) fl_falcon_player0)
	(object_teleport (player1) fl_falcon_player1)
	(object_teleport (player2) fl_falcon_player2)
	(object_teleport (player3) fl_falcon_player3)
	(sleep 1)
	
	; starting profiles
	(unit_add_equipment player0 profile_full_health TRUE FALSE)
	(unit_add_equipment player1 profile_full_health TRUE FALSE)
	(unit_add_equipment player2 profile_full_health TRUE FALSE)
	(unit_add_equipment player3 profile_full_health TRUE FALSE)

	(set g_bfg01_destroyed TRUE)
	(set g_bfg02_destroyed TRUE)
	
	; music
	(wake music_bravo)
	
	(insertion_fade_to_gameplay)

	(game_save_immediate)
	
	(sleep 90)
	(wake md_cannon_end_02)
		
)

;=========================================================================================
; SPIRE =========================================
;=========================================================================================

(script static void ins_spire
	
	; set insertion point index 
	(set g_insertion_index 6)	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_spire)
	(sleep 1)
	
	; set mission progress accordingly 
	(set g_hill_obj_control 100)
	(set g_twin_obj_control 100)	
	(set g_facility_obj_control 100)
	(set g_cannon_obj_control 100)
	(set g_falcon_obj_control 1000)
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport_to_ai_point (player0)  ps_teleports/spire00)
	(object_teleport_to_ai_point (player1)  ps_teleports/spire01)
	(object_teleport_to_ai_point (player2)  ps_teleports/spire02)
	(object_teleport_to_ai_point (player3)  ps_teleports/spire03)
	
	;*
	(object_create cr_falcon_crash_01)
	(object_create cr_falcon_crash_02)
	(object_create c_spire_health_01)
	(object_create c_spire_health_02)
	(object_create eq_spire_frag_01)
	(object_create eq_spire_frag_02)
	(object_create eq_spire_frag_03)
	*;
	
	(set g_bfg01_destroyed TRUE)
	(set g_bfg02_destroyed TRUE)
	
	(object_create sc_spire_crashed_falcon_01)
	(object_create sc_spire_crashed_falcon_02)
	(object_create sc_falcon_chunk01)
	(object_create sc_falcon_chunk02)
	(object_create sc_falcon_chunk03)
	
	(object_create dm_sky_frigate01b)
	(simplify_frigate_turrets_02 dm_sky_frigate01b)
	(frigate01b_load_gunners)
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate_spire)
	
	(insertion_fade_to_gameplay)

	(game_save_immediate)			
)


; blank
; =================================================================================================
(script static void ins_blank
	(print "insertion point : blank")
	(set g_insertion_index 10)
	
	(switch_zone_set set_hill_intro)
	(sleep_until (= (current_zone_set_fully_active) 0) 1)
	(cinematic_fade_to_gameplay)
	(game_save_immediate)
)