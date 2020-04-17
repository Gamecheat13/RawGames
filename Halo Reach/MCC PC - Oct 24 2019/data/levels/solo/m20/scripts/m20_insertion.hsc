; =================================================================================================
; COURTYARD
; =================================================================================================
(script static void ico (ins_court))
(script static void ins_court
	(if b_debug (print "*** INSERTION POINT: COURTYARD ***"))

	(set s_insertion_index s_court_ins_idx)
	(wake f_objects_manage)

	; Play the intro cinematic	
	(if 
		(or
			(and b_cinematics (not b_editor))
			(= b_editor_cinematics TRUE)
		)
			(begin
				(switch_zone_set zoneset_intro_cinematic)
				(cinematic_enter 020la_sword TRUE)
				(f_cin_intro_prep)
				(f_start_mission 020la_sword)
				(object_destroy sc_cin_terrain_blocker)
				(ai_erase sq_intro_cov_1)
				(ai_erase sq_intro_cov_2)
			)
	)

	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_courtyard)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (s_zoneset_courtyard_valley) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_courtyard) 1)
	(if b_debug (print "::: INSERTION: Finished loading (s_zoneset_courtyard_valley)"))
	(sleep 1)

	; Bookkeeping
	(soft_ceiling_enable soft_ceiling_interior 0)
	(wake f_corvette_exterior)

	;Kat Setup
	(f_kat_spawn sq_kat/court_ins obj_court_hum)
	(tick)
	(wake f_kat_nanny)

	;Marines Setup

	; Teleport
	(object_teleport_to_ai_point (player0) ps_courtyard_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_courtyard_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_courtyard_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_courtyard_spawn/player3)

	(set b_mission_started TRUE)
	(set b_landed TRUE)

)

; =================================================================================================
; VALLEY
; =================================================================================================
(global boolean b_valley_ins FALSE)
(script static void iva (ins_valley))
(script static void ins_valley
	(if b_debug (print "*** INSERTION POINT: VALLEY ***"))
	
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)
	(set b_valley_ins TRUE)

	(set s_insertion_index s_valley_ins_idx)

	(f_court_cleanup)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_courtyard_valley)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_courtyard_valley) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_courtyard_valley) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_courtyard_valley)"))
	(sleep 1)
	
	; Bookkeeping
	(set b_court_defended TRUE)
	(wake f_gatehouse_door_control)
	(wake f_train_targetlaser)
	(wake f_corvette_exterior)
	(wake f_objects_manage)
	(f_objects_court_init_create)

	(sleep 1)

	(if (not (game_is_cooperative) ) (ai_place sq_valley_marines_ins_1) )
	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)
	
	; Kat Setup
	(f_kat_spawn sq_kat/valley_ins obj_valley_hum)
	(tick)
	(wake f_kat_nanny)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_valley_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_valley_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_valley_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_valley_spawn/player3)

)


; =================================================================================================
; FARAGATE
; =================================================================================================
(script static void ifa (ins_faragate))
(script static void ins_faragate
	(if b_debug (print "*** INSERTION POINT: FARAGATE ***"))
	
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(set s_insertion_index s_valley_ins_idx)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)

	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_exterior)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_exterior) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_exterior) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_exterior)"))
	(sleep 1)
	
	; Bookkeeping

	;(wake courtyard_wraith_faragate_fx)

	(device_set_position_immediate dm_valley_door_large 0)
	(device_set_position_immediate dm_valley_door_small 0)
	(f_md_exterior_increment)
	(wake f_corvette_exterior)
	(wake f_objects_manage)

	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_air_defended TRUE)
	(set b_air_spawn_done TRUE)
	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)

	; Kat Setup
	(f_kat_spawn sq_kat/far_ins obj_far_hum)
	(tick)
	(wake f_kat_nanny)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_far_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_far_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_far_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_far_spawn/player3)

	(ai_place sq_far_warthog_ins)
	(ai_squad_enumerate_immigrants sq_far_warthog_ins TRUE)	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_far_warthog_ins/driver01) "warthog_d" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_far_warthog_ins/driver01) "warthog_p" o_kat)
	(f_vehicle_goto_set vehicle_far)	

)


; =================================================================================================
; AIRVIEW
; =================================================================================================
(script static void iai (ins_airview))
(script static void ins_airview
	(if b_debug (print "*** INSERTION POINT: AIRVIEW ***"))
	
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(set s_insertion_index s_valley_ins_idx)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_far_cleanup)

	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_exterior)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_exterior) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_exterior) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_exterior)"))
	(sleep 1)
	
	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_far_defended TRUE)
	(set b_far_spawn_done TRUE)
	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)
	(wake f_objects_manage)

	(device_set_position_immediate dm_valley_door_large 0)
	(device_set_position_immediate dm_valley_door_small 0)
	(f_md_exterior_increment)
	(wake f_corvette_exterior)

	; Kat Setup
	(f_kat_spawn sq_kat/air_ins obj_air_hum)
	(tick)
	(wake f_kat_nanny)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_air_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_air_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_air_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_air_spawn/player3)
	
	(ai_place sq_air_warthog_ins)
	(ai_squad_enumerate_immigrants sq_air_warthog_ins TRUE)	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_air_warthog_ins/driver01) "warthog_d" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_air_warthog_ins/driver01) "warthog_g" ai_kat)
	(f_vehicle_goto_set vehicle_air)

)

; =================================================================================================
; RETURN
; =================================================================================================
(global boolean b_ins_return FALSE)
(global boolean b_ins_return_objects FALSE)
(script static void ire (ins_return))
(script static void ins_return
	(if b_debug (print "*** INSERTION POINT: RETURN ***"))
	
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(set s_insertion_index s_return_ins_idx)
	(set b_ins_return TRUE)
	(set b_ins_return_objects TRUE)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_objects_court_init_destroy)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_exterior)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_exterior) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_exterior) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_exterior)"))
	(sleep 1)
	
	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_far_defended TRUE)
	(set b_air_defended TRUE)
	(set b_far_spawn_done TRUE)
	(set b_air_spawn_done TRUE)
	(f_air_cannon_place)
	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)
	(wake f_corvette_exterior)
	(wake f_objects_manage)

	(device_set_position_immediate dm_valley_door_large 0)
	(device_set_position_immediate dm_valley_door_small 0)

	; Kat Setup
	(f_kat_spawn sq_kat/return_ins obj_return_hum)
	(tick)
	(wake f_kat_nanny)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_return_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_return_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_return_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_return_spawn/player3)

	(ai_place sq_return_warthog_ins)

	(if (>= (game_coop_player_count) 3)	(ai_place sq_far_warthog/driver02) )

	(ai_squad_enumerate_immigrants sq_return_warthog_ins TRUE)	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_return_warthog_ins/driver01) "warthog_d" (player0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_return_warthog_ins/driver01) "warthog_p" o_kat)
	(f_vehicle_goto_set vehicle_return)

)

; =================================================================================================
; GARAGE
; =================================================================================================

(script static void iga (ins_garage))
(script static void ins_garage
	(if b_debug (print "*** INSERTION POINT: GARAGE ***"))
	
	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(set s_insertion_index s_garage_ins_idx)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_return_cleanup)
	(f_objects_court_init_destroy)

	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_courtyard_valley_return)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_courtyard_valley_return) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_courtyard_valley_re) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_courtyard_valley_return)"))
	(sleep 1)
		
	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_far_defended TRUE)
	(set b_air_defended TRUE)
	(set b_garage_ready TRUE)
	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)
	(wake f_corvette_exterior)
	(ai_place sq_garage_marine_ins)
	(wake f_objects_manage)

	; Kat Setup
	(f_kat_spawn sq_kat/garage_ins obj_garage_hum)
	(tick)
	(wake f_kat_nanny)

	(f_zoneset_direction direction_inward)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_garage_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_garage_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_garage_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_garage_spawn/player3)
	
)

; =================================================================================================
; SWORD
; =================================================================================================
(script static void isw (ins_sword))
(script static void ins_sword
	(if b_debug (print "*** INSERTION POINT: SWORDBASE ***"))

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(set s_insertion_index s_sword_ins_idx)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_return_cleanup)
	(f_garage_cleanup)

	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_interior)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_interior) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_interior) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_interior)"))
	(sleep 1)

	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_air_defended TRUE)
	(set b_far_defended TRUE)
	(set b_sword_ready TRUE)
	(flock_create flock_interior_phantom_01)
	(flock_create flock_interior_banshee_01)
	(flock_create flock_interior_falcon_01)
	(wake f_corvette_exterior)
	(soft_ceiling_enable default 0)	
	(wake f_objects_manage)

	(device_set_position_immediate dm_garage_elevator 1)
	
	; Kat Setup
	(f_kat_spawn sq_kat/sword_ins obj_sword_hum)
	(tick)
	(wake f_kat_nanny)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_sword_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_sword_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_sword_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_sword_spawn/player3)

)


; =================================================================================================
; ROOF
; =================================================================================================

(script static void iro (ins_roof))
(script static void ins_roof
	(if b_debug (print "*** INSERTION POINT: ROOF ***"))

	(insertion_snap_to_black)
	(wake f_insertion_fade_in)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_return_cleanup)
	(f_garage_cleanup)
	(f_sword_cleanup)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(switch_zone_set zoneset_interior)
	(sleep 1)
	(if b_debug (print "::: INSERTION: Waiting for (zoneset_interior) to fully load..."))
	(sleep_until (= (current_zone_set_fully_active) s_zoneset_interior) 1)
	(if b_debug (print "::: INSERTION: Finished loading (zoneset_interior)"))
	(sleep 1)
	
	; Bookkeeping
	(set b_court_defended TRUE)
	(set b_air_defended TRUE)
	(set b_far_defended TRUE)
	(soft_ceiling_enable default 0)
	(soft_ceiling_enable camera_blocker_07 0)
	(soft_ceiling_enable camera_blocker_08 0)
	(soft_ceiling_enable camera_blocker_09 0)	
	(wake f_objects_manage)
	
	; Jorge Setup
	(f_jorge_spawn sq_jorge/roof obj_roof_hum)
	
	; Teleport
	(object_teleport_to_ai_point (player0) ps_roof_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_roof_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_roof_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_roof_spawn/player3)

)