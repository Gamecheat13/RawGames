;======================================================
;========== GLOBAL VARIABLES ==========================
;======================================================
(global short g_set_all 12)

;======================================================
;==========Elevator====================================
;======================================================
(script static void ins_elevator
	(if b_debug (print "inspoint: elevator"))

	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ab)
			(sleep 1)
		)
	)
	(sleep 1)

	(insertion_start)

		; set player pitch 
		(player0_set_pitch -5 0)
		(player1_set_pitch -5 0)
		(player2_set_pitch -5 0)
		(player3_set_pitch -5 0)

	;set insertion point index 
	(set s_insertion_index 1)
)

;======================================================
;==========Cavern======================================
;======================================================
(script static void ins_cavern
	(if b_debug (print "inspoint: cavern"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ab)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 2)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_cavern_ins_mar)
			(ai_place sq_cavern_ins_wart_troop/warttroop)
			
			(object_teleport (player0) player0_cavern)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart_troop/warttroop) "warthog_p" (ai_get_object sq_cavern_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart_troop/warttroop) "warthog_p_l" (ai_get_object sq_cavern_ins_mar/02))		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart_troop/warttroop) "warthog_p_r" (ai_get_object sq_cavern_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart_troop/warttroop) "warthog_p_b" (ai_get_object sq_cavern_ins_mar/04))	
			
			(ai_set_objective sg_allied_vehicles obj_cav_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_cavern_ins_mar/01)
			(ai_place sq_cavern_ins_mar/02)
			(sleep 1)
			(ai_place sq_cavern_ins_wart1/wart1)
			(ai_place sq_cavern_ins_wart2/wart2)
			
			(object_teleport (player0) player0_cavern)
			(object_teleport (player1) player1_cavern)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart1/wart1) "warthog_g" (ai_get_object sq_cavern_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart2/wart2) "warthog_g" (ai_get_object sq_cavern_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_cav_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_cavern_ins_mar/01)
			(sleep 1)
			(ai_place sq_cavern_ins_wart1/wart1)
			(ai_place sq_cavern_ins_wart2/wart2)
			
			(object_teleport (player0) player0_cavern)
			(object_teleport (player1) player1_cavern)
			(object_teleport (player2) player2_cavern)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_cavern_ins_wart2/wart2) "warthog_g" (ai_get_object sq_cavern_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_cav_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_cavern_ins_wart1/wart1)
			(ai_place sq_cavern_ins_wart2/wart2)
			
			(object_teleport (player0) player0_cavern)
			(object_teleport (player1) player1_cavern)
			(object_teleport (player2) player2_cavern)
			(object_teleport (player3) player3_cavern)

			(ai_set_objective sg_allied_vehicles obj_cav_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)

)

;======================================================
;==========Drive=======================================
;======================================================
(script static void ins_drive
	(if b_debug (print "inspoint: drive"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set bc)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 3)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)

	;scripts needed to make the section happy	
	(device_set_position_immediate cavern_exit 0.63)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_drive_ins_mar)
			(ai_place sq_drive_ins_wart_troop/warttroop)
			
			(object_teleport (player0) player0_drive)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart_troop/warttroop) "warthog_p" (ai_get_object sq_drive_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart_troop/warttroop) "warthog_p_l" (ai_get_object sq_drive_ins_mar/02))		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart_troop/warttroop) "warthog_p_r" (ai_get_object sq_drive_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart_troop/warttroop) "warthog_p_b" (ai_get_object sq_drive_ins_mar/04))	
			
			(ai_set_objective sg_allied_vehicles obj_drive_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_drive_ins_mar/01)
			(ai_place sq_drive_ins_mar/02)
			(sleep 1)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(object_teleport (player0) player0_drive)
			(object_teleport (player1) player1_drive)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_g" (ai_get_object sq_drive_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (ai_get_object sq_drive_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_drive_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_drive_ins_mar/01)
			(sleep 1)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(object_teleport (player0) player0_drive)
			(object_teleport (player1) player1_drive)
			(object_teleport (player2) player2_drive)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (ai_get_object sq_drive_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_drive_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(object_teleport (player0) player0_drive)
			(object_teleport (player1) player1_drive)
			(object_teleport (player2) player2_drive)
			(object_teleport (player3) player3_drive)

			(ai_set_objective sg_allied_vehicles obj_drive_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)



;======================================================
;==========Pond========================================
;======================================================
(script static void ins_pond
	(if b_debug (print "inspoint: pond"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set cd)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 4)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_pond_ins_mar)
			(ai_place sq_pond_ins_wart_troop/warttroop)
			
			(object_teleport (player0) player0_pond)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart_troop/warttroop) "warthog_p" (ai_get_object sq_pond_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart_troop/warttroop) "warthog_p_l" (ai_get_object sq_pond_ins_mar/02))		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart_troop/warttroop) "warthog_p_r" (ai_get_object sq_pond_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart_troop/warttroop) "warthog_p_b" (ai_get_object sq_pond_ins_mar/04))	
			
			(ai_set_objective sg_allied_vehicles obj_pond_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_pond_ins_mar/01)
			(ai_place sq_pond_ins_mar/02)
			(sleep 1)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(object_teleport (player0) player0_pond)
			(object_teleport (player1) player1_pond)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_g" (ai_get_object sq_pond_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (ai_get_object sq_pond_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_pond_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_pond_ins_mar/01)
			(sleep 1)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(object_teleport (player0) player0_pond)
			(object_teleport (player1) player1_pond)
			(object_teleport (player2) player2_pond)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (ai_get_object sq_pond_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_pond_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(object_teleport (player0) player0_pond)
			(object_teleport (player1) player1_pond)
			(object_teleport (player2) player2_pond)
			(object_teleport (player3) player3_pond)

			(ai_set_objective sg_allied_vehicles obj_pond_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)

;======================================================
;==========Crash=======================================
;======================================================
(script static void ins_crash
	(if b_debug (print "inspoint: crash"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set cd)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 5)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_crash_ins_mar)
			(ai_place sq_crash_ins_wart_troop/warttroop)
			
			(object_teleport (player0) player0_crash)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart_troop/warttroop) "warthog_p" (ai_get_object sq_crash_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart_troop/warttroop) "warthog_p_l" (ai_get_object sq_crash_ins_mar/02))		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart_troop/warttroop) "warthog_p_r" (ai_get_object sq_crash_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart_troop/warttroop) "warthog_p_b" (ai_get_object sq_crash_ins_mar/04))	
			
			(ai_set_objective sg_allied_vehicles obj_crash_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_crash_ins_mar/01)
			(ai_place sq_crash_ins_mar/02)
			(sleep 1)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(object_teleport (player0) player0_crash)
			(object_teleport (player1) player1_crash)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_g" (ai_get_object sq_crash_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (ai_get_object sq_crash_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_crash_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_crash_ins_mar/01)
			(sleep 1)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(object_teleport (player0) player0_crash)
			(object_teleport (player1) player1_crash)
			(object_teleport (player2) player2_crash)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (ai_get_object sq_crash_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_crash_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(object_teleport (player0) player0_crash)
			(object_teleport (player1) player1_crash)
			(object_teleport (player2) player2_crash)
			(object_teleport (player3) player3_crash)

			(ai_set_objective sg_allied_vehicles obj_crash_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)

;======================================================
;==========Bridge======================================
;======================================================
(script static void ins_bridge
	(if b_debug (print "inspoint: bridge"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set de)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 6)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	

	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_bridge_ins_mar)
			(ai_place sq_bridge_ins_wart_troop/warttroop)
			
			(object_teleport (player0) player0_bridge)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart_troop/warttroop) "warthog_p" (ai_get_object sq_bridge_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart_troop/warttroop) "warthog_p_l" (ai_get_object sq_bridge_ins_mar/02))		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart_troop/warttroop) "warthog_p_r" (ai_get_object sq_bridge_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart_troop/warttroop) "warthog_p_b" (ai_get_object sq_bridge_ins_mar/04))	
			
			(ai_set_objective sg_allied_vehicles obj_bridge_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_bridge_ins_mar/01)
			(ai_place sq_bridge_ins_mar/02)
			(sleep 1)
			(ai_place sq_bridge_ins_wart1/wart1)
			(ai_place sq_bridge_ins_wart2/wart2)
			
			(object_teleport (player0) player0_bridge)
			(object_teleport (player1) player1_bridge)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart1/wart1) "warthog_g" (ai_get_object sq_bridge_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart2/wart2) "warthog_g" (ai_get_object sq_bridge_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_bridge_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_bridge_ins_mar/01)
			(sleep 1)
			(ai_place sq_bridge_ins_wart1/wart1)
			(ai_place sq_bridge_ins_wart2/wart2)
			
			(object_teleport (player0) player0_bridge)
			(object_teleport (player1) player1_bridge)
			(object_teleport (player2) player2_bridge)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_bridge_ins_wart2/wart2) "warthog_g" (ai_get_object sq_bridge_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_bridge_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_bridge_ins_wart1/wart1)
			(ai_place sq_bridge_ins_wart2/wart2)
			
			(object_teleport (player0) player0_bridge)
			(object_teleport (player1) player1_bridge)
			(object_teleport (player2) player2_bridge)
			(object_teleport (player3) player3_bridge)

			(ai_set_objective sg_allied_vehicles obj_bridge_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)	
)

;======================================================
;==========Garage======================================
;======================================================
(script static void ins_garage
	(if b_debug (print "inspoint: garage"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ef)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 7)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	
	(set s_bridge_obj_control 100)	

	;spawning players, no warthogs this time
	(if b_debug (print "teleporting players..."))	
	(object_teleport (player0) player0_garage)
	(object_teleport (player1) player1_garage)
	(object_teleport (player2) player2_garage)
	(object_teleport (player3) player3_garage)	

	(sleep 1)
	(player_disable_movement 0)	
)

;======================================================
;==========Gathering Storm=============================
;======================================================
(script static void ins_gathering_storm
	(if b_debug (print "inspoint: gathering storm"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ef)
			(sleep 1)
		)
	)
	(sleep 1)
	
	; start insertion point 
	(insertion_start)
	
	;set insertion point index
	(set s_insertion_index 7)
	
	; start music 
	(wake 030_music_051_start)
	
		;set previous mission progress accordingly 
		(set s_elevator_obj_control 100)
		(set s_cavern_obj_control 100)
		(set s_drive_obj_control 100)
		(set s_pond_obj_control 100)
		(set s_crash_obj_control 100)	
		(set s_bridge_obj_control 5)	
	
	;spawning players, no warthogs this time 
	(object_teleport (player0) player0_gathering)
	(object_teleport (player1) player1_gathering)
	(object_teleport (player2) player2_gathering)
	(object_teleport (player3) player3_gathering)	
	
		; wake secondary threads 
		(wake sc_bridge_brief02_sound)
		(wake sc_bridge_title2_insertion)
		(wake sc_bridge_cruiser)
	
	; fade in 
	(sleep 30)
	(fade_in 0 0 0 15)	
)

;======================================================
;==========Tether======================================
;======================================================
(script static void ins_tether
	(if b_debug (print "inspoint: tether"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set de)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 8)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	
	(set s_bridge_obj_control 100)	
	(set s_garage_obj_control 100)	

	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_tether_ins_mar)
			(ai_place sq_tether_ins_wart1/wart1)
			(ai_place sq_tether_ins_wart2/wart2)
			
			(object_teleport (player0) player0_tether)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart1/wart1) "warthog_g" (ai_get_object sq_tether_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart1/wart1) "warthog_p" (ai_get_object sq_tether_ins_mar/02))		
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart2/wart2) "warthog_d" (ai_get_object sq_tether_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart2/wart2) "warthog_p" (ai_get_object sq_tether_ins_mar/04))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart2/wart2) "warthog_p_l" (ai_get_object sq_tether_ins_mar/05))	
			
			(ai_set_objective sg_allied_vehicles obj_tether_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_tether_ins_mar/01)
			(ai_place sq_tether_ins_mar/02)
			(sleep 1)
			(ai_place sq_tether_ins_wart1/wart1)
			(ai_place sq_tether_ins_wart3/wart3)
			
			(object_teleport (player0) player0_tether)
			(object_teleport (player1) player1_tether)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart1/wart1) "warthog_g" (ai_get_object sq_tether_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart3/wart3) "warthog_g" (ai_get_object sq_tether_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_tether_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_tether_ins_mar/01)
			(sleep 1)
			(ai_place sq_tether_ins_wart1/wart1)
			(ai_place sq_tether_ins_wart3/wart3)
			
			(object_teleport (player0) player0_tether)
			(object_teleport (player1) player1_tether)
			(object_teleport (player2) player2_tether)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_tether_ins_wart3/wart3) "warthog_g" (ai_get_object sq_tether_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_tether_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_tether_ins_wart1/wart1)
			(ai_place sq_tether_ins_wart2/wart2)
			
			(object_teleport (player0) player0_tether)
			(object_teleport (player1) player1_tether)
			(object_teleport (player2) player2_tether)
			(object_teleport (player3) player3_tether)

			(ai_set_objective sg_allied_vehicles obj_tether_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)

;======================================================
;==========Round=======================================
;======================================================
(script static void ins_round
	(if b_debug (print "inspoint: round"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ef)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 9)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	
	(set s_bridge_obj_control 100)	
	(set s_garage_obj_control 100)	
	(set s_tether_obj_control 100)	

	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_round_ins_mar)
			(ai_place sq_round_ins_wart1/wart1)
			(ai_place sq_round_ins_wart2/wart2)
			
			(object_teleport (player0) player0_round)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart1/wart1) "warthog_g" (ai_get_object sq_round_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart1/wart1) "warthog_p" (ai_get_object sq_round_ins_mar/02))		
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart2/wart2) "warthog_d" (ai_get_object sq_round_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart2/wart2) "warthog_p" (ai_get_object sq_round_ins_mar/04))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart2/wart2) "warthog_p_l" (ai_get_object sq_round_ins_mar/05))	
			
			(ai_set_objective sg_allied_vehicles obj_round_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_round_ins_mar/01)
			(ai_place sq_round_ins_mar/02)
			(sleep 1)
			(ai_place sq_round_ins_wart1/wart1)
			(ai_place sq_round_ins_wart3/wart3)
			
			(object_teleport (player0) player0_round)
			(object_teleport (player1) player1_round)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart1/wart1) "warthog_g" (ai_get_object sq_round_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart3/wart3) "warthog_g" (ai_get_object sq_round_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_round_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_round_ins_mar/01)
			(sleep 1)
			(ai_place sq_round_ins_wart1/wart1)
			(ai_place sq_round_ins_wart3/wart3)
			
			(object_teleport (player0) player0_round)
			(object_teleport (player1) player1_round)
			(object_teleport (player2) player2_round)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_round_ins_wart3/wart3) "warthog_g" (ai_get_object sq_round_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_round_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_round_ins_wart1/wart1)
			(ai_place sq_round_ins_wart2/wart2)
			
			(object_teleport (player0) player0_round)
			(object_teleport (player1) player1_round)
			(object_teleport (player2) player2_round)
			(object_teleport (player3) player3_round)

			(ai_set_objective sg_allied_vehicles obj_round_marine)							
		)
	)

	(sleep 1)
	(player_disable_movement 0)
)

;======================================================
;==========Exit========================================
;======================================================
(script static void ins_exit
	(if b_debug (print "inspoint: exit"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ef)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 10)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	
	(set s_bridge_obj_control 100)	
	(set s_garage_obj_control 100)	
	(set s_tether_obj_control 100)

	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_exit_ins_mar)
			(ai_place sq_exit_ins_wart1/wart1)
			(ai_place sq_exit_ins_wart2/wart2)
			
			(object_teleport (player0) player0_exit)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart1/wart1) "warthog_g" (ai_get_object sq_exit_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart1/wart1) "warthog_p" (ai_get_object sq_exit_ins_mar/02))		
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart2/wart2) "warthog_d" (ai_get_object sq_exit_ins_mar/03))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart2/wart2) "warthog_p" (ai_get_object sq_exit_ins_mar/04))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart2/wart2) "warthog_p_l" (ai_get_object sq_exit_ins_mar/05))	
			
			(ai_set_objective sg_allied_vehicles obj_exit_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_exit_ins_mar/01)
			(ai_place sq_exit_ins_mar/02)
			(sleep 1)
			(ai_place sq_exit_ins_wart1/wart1)
			(ai_place sq_exit_ins_wart3/wart3)
			
			(object_teleport (player0) player0_exit)
			(object_teleport (player1) player1_exit)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart1/wart1) "warthog_g" (ai_get_object sq_exit_ins_mar/01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart3/wart3) "warthog_g" (ai_get_object sq_exit_ins_mar/02))	
			
			(ai_set_objective sg_allied_vehicles obj_exit_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_exit_ins_mar/01)
			(sleep 1)
			(ai_place sq_exit_ins_wart1/wart1)
			(ai_place sq_exit_ins_wart3/wart3)
			
			(object_teleport (player0) player0_exit)
			(object_teleport (player1) player1_exit)
			(object_teleport (player2) player2_exit)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_ins_wart3/wart3) "warthog_g" (ai_get_object sq_exit_ins_mar/01))
	
			(ai_set_objective sg_allied_vehicles obj_exit_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_exit_ins_wart1/wart1)
			(ai_place sq_exit_ins_wart2/wart2)
			
			(object_teleport (player0) player0_exit)
			(object_teleport (player1) player1_exit)
			(object_teleport (player2) player2_exit)
			(object_teleport (player3) player3_exit)

			(ai_set_objective sg_allied_vehicles obj_exit_marine)							
		)
	)

	(sleep 1)
	(player_disable_movement 0)	
)

;======================================================
;==========Video=======================================
;======================================================
(script static void ins_video
	(if b_debug (print "inspoint: video"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set e)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 7)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	(set s_crash_obj_control 100)	
	(set s_bridge_obj_control 100)	

	;spawning players, no warthogs this time
	(if b_debug (print "teleporting players..."))	
	(object_teleport (player0) player0_garage)
	(object_teleport (player1) player1_garage)
	(object_teleport (player2) player2_garage)
	(object_teleport (player3) player3_garage)	

	(sleep 1)
	(player_disable_movement 0)	
	
)

;======================================================
;==========Old=========================================
;======================================================
(script static void ins_cavern_old
	(if b_debug (print "inspoint: cavern"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set ab)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 2)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_elev_sarge/sarge)
			(ai_place sq_elev_mar/01)
			(ai_place sq_elev_mar/02)
			(ai_place sq_elev_mar/03)
			(ai_place sq_elev_warthog1/warthog1)
			(ai_place sq_elev_warthog2/warthog2)	
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (ai_get_object sq_elev_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (ai_get_object sq_elev_sarge/sarge))
		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (ai_get_object sq_elev_mar/02))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (ai_get_object sq_elev_mar/03))	
			
			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) player0_cavern)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) player1_cavern)			

			(ai_set_objective sg_allied_vehicles obj_cav_marine)
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_elev_sarge/sarge)
			(ai_place sq_elev_mar/01)
			(ai_place sq_elev_mar/02)
			(ai_place sq_elev_mar/03)
			(ai_place sq_elev_warthog1/warthog1)	
			(ai_place sq_elev_warthog2/warthog2)	
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (ai_get_object sq_elev_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (ai_get_object sq_elev_sarge/sarge))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (ai_get_object sq_elev_mar/02))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (ai_get_object sq_elev_mar/03))

			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) player0_cavern)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) player1_cavern)	

			(ai_set_objective sg_allied_vehicles obj_cav_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_elev_sarge/sarge)
			(ai_place sq_elev_mar/01)
			(ai_place sq_elev_mar/02)
			(ai_place sq_elev_warthog1/warthog1)	
			(ai_place sq_elev_warthog2/warthog2)	
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (ai_get_object sq_elev_sarge/sarge))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (ai_get_object sq_elev_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (ai_get_object sq_elev_mar/02))

			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) player0_cavern)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) player1_cavern)		

			(ai_set_objective sg_allied_vehicles obj_cav_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_elev_sarge/sarge)
			(ai_place sq_elev_mar/01)
			(ai_place sq_elev_warthog1/warthog1)	
			(ai_place sq_elev_warthog2/warthog2)	
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (ai_get_object sq_elev_sarge/sarge))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player3))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (ai_get_object sq_elev_mar/01))

			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) player0_cavern)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) player1_cavern)	

			(ai_set_objective sg_allied_vehicles obj_cav_marine)							
		)
	)
	(sleep 1)
	(player_disable_movement 0)

)

(script static void ins_drive_old
	(if b_debug (print "inspoint: drive"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set bc)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 3)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)

	;scripts needed to make the section happy	
	(device_set_position_immediate cavern_exit 0.63)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_drive_ins_mar/01)
			(ai_place sq_drive_ins_mar/02)
			(ai_place sq_drive_ins_mar/03)
			(ai_place sq_drive_ins_mar/04)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_g" (ai_get_object sq_drive_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_p" (ai_get_object sq_drive_ins_mar/02))
		
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_d" (ai_get_object sq_drive_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (ai_get_object sq_drive_ins_mar/04))	
			
			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) player0_drive)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) player1_drive)			

			(ai_set_objective sg_allied_vehicles obj_drive_marine)									
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_drive_ins_mar/01)
			(ai_place sq_drive_ins_mar/02)
			(ai_place sq_drive_ins_mar/03)
			(ai_place sq_drive_ins_mar/04)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_g" (ai_get_object sq_drive_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_p" (ai_get_object sq_drive_ins_mar/02))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (ai_get_object sq_drive_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_p" (ai_get_object sq_drive_ins_mar/04))

			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) player0_drive)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) player1_drive)			

			(ai_set_objective sg_allied_vehicles obj_drive_marine)													
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_drive_ins_mar/01)
			(ai_place sq_drive_ins_mar/02)
			(ai_place sq_drive_ins_mar/03)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_p" (ai_get_object sq_drive_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (ai_get_object sq_drive_ins_mar/02))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_p" (ai_get_object sq_drive_ins_mar/03))

			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) player0_drive)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) player1_drive)			

			(ai_set_objective sg_allied_vehicles obj_drive_marine)			
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_drive_ins_mar/01)
			(ai_place sq_drive_ins_mar/02)
			(ai_place sq_drive_ins_wart1/wart1)
			(ai_place sq_drive_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) "warthog_p" (ai_get_object sq_drive_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_g" (player3))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) "warthog_p" (ai_get_object sq_drive_ins_mar/02))

			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart1/wart1) player0_drive)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_drive_ins_wart2/wart2) player1_drive)		

			(ai_set_objective sg_allied_vehicles obj_drive_marine)						
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)

(script static void ins_pond_old
	(if b_debug (print "inspoint: pond"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set cd)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 4)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_pond_ins_mar/01)
			(ai_place sq_pond_ins_mar/02)
			(ai_place sq_pond_ins_mar/03)
			(ai_place sq_pond_ins_mar/04)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_g" (ai_get_object sq_pond_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_p" (ai_get_object sq_pond_ins_mar/02))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_d" (ai_get_object sq_pond_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (ai_get_object sq_pond_ins_mar/04))	
			
			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) player0_pond)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) player1_pond)		

			(ai_set_objective sg_allied_vehicles obj_pond_marine)										
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_pond_ins_mar/01)
			(ai_place sq_pond_ins_mar/02)
			(ai_place sq_pond_ins_mar/03)
			(ai_place sq_pond_ins_mar/04)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_g" (ai_get_object sq_pond_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_p" (ai_get_object sq_pond_ins_mar/02))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (ai_get_object sq_pond_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_p" (ai_get_object sq_pond_ins_mar/04))

			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) player0_pond)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) player1_pond)	

			(ai_set_objective sg_allied_vehicles obj_pond_marine)												
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_pond_ins_mar/01)
			(ai_place sq_pond_ins_mar/02)
			(ai_place sq_pond_ins_mar/03)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_p" (ai_get_object sq_pond_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (ai_get_object sq_pond_ins_mar/02))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_p" (ai_get_object sq_pond_ins_mar/03))

			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) player0_pond)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) player1_pond)		

			(ai_set_objective sg_allied_vehicles obj_pond_marine)	
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_pond_ins_mar/01)
			(ai_place sq_pond_ins_mar/02)
			(ai_place sq_pond_ins_wart1/wart1)
			(ai_place sq_pond_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) "warthog_p" (ai_get_object sq_pond_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_g" (player3))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) "warthog_p" (ai_get_object sq_pond_ins_mar/02))

			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart1/wart1) player0_pond)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_pond_ins_wart2/wart2) player1_pond)	

			(ai_set_objective sg_allied_vehicles obj_pond_marine)				
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)

(script static void ins_crash_old
	(if b_debug (print "inspoint: crash"))
	
	;switch to correct zone unless all zones are loaded
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if b_debug (print "switching zone sets..."))
			(switch_zone_set cd)
			(sleep 1)
		)
	)
	
	;set insertion point index
	(set s_insertion_index 5)
	
	;set previous mission progress accordingly
	(set s_elevator_obj_control 100)
	(set s_cavern_obj_control 100)
	(set s_drive_obj_control 100)
	(set s_pond_obj_control 100)
	
	;spawning warthogs, placing player(s) in warthog, and spawning ai to fill warthogs
	(if b_debug (print "teleporting players..."))	
	(cond 
		((= (game_coop_player_count) 1)
			(ai_place sq_crash_ins_mar/01)
			(ai_place sq_crash_ins_mar/02)
			(ai_place sq_crash_ins_mar/03)
			(ai_place sq_crash_ins_mar/04)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_g" (ai_get_object sq_crash_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_p" (ai_get_object sq_crash_ins_mar/02))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_d" (ai_get_object sq_crash_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (ai_get_object sq_crash_ins_mar/04))	
			
			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) player0_crash)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) player1_crash)

			(ai_set_objective sg_allied_vehicles obj_crash_marine)										
		)
		((= (game_coop_player_count) 2)
			(ai_place sq_crash_ins_mar/01)
			(ai_place sq_crash_ins_mar/02)
			(ai_place sq_crash_ins_mar/03)
			(ai_place sq_crash_ins_mar/04)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_g" (ai_get_object sq_crash_ins_mar/01))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_p" (ai_get_object sq_crash_ins_mar/02))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (ai_get_object sq_crash_ins_mar/03))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_p" (ai_get_object sq_crash_ins_mar/04))

			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) player0_crash)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) player1_crash)

			(ai_set_objective sg_allied_vehicles obj_crash_marine)												
		)
		((= (game_coop_player_count) 3)
			(ai_place sq_crash_ins_mar/01)
			(ai_place sq_crash_ins_mar/02)
			(ai_place sq_crash_ins_mar/03)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_p" (ai_get_object sq_crash_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (ai_get_object sq_crash_ins_mar/02))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_p" (ai_get_object sq_crash_ins_mar/03))

			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) player0_crash)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) player1_crash)

			(ai_set_objective sg_allied_vehicles obj_crash_marine)		
		)
		((= (game_coop_player_count) 4)
			(ai_place sq_crash_ins_mar/01)
			(ai_place sq_crash_ins_mar/02)
			(ai_place sq_crash_ins_wart1/wart1)
			(ai_place sq_crash_ins_wart2/wart2)
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_d" (player0))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_g" (player2))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) "warthog_p" (ai_get_object sq_crash_ins_mar/01))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_d" (player1))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_g" (player3))	
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) "warthog_p" (ai_get_object sq_crash_ins_mar/02))

			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart1/wart1) player0_crash)	
			(object_teleport (ai_vehicle_get_from_starting_location sq_crash_ins_wart2/wart2) player1_crash)

			(ai_set_objective sg_allied_vehicles obj_crash_marine)					
		)
	)
	(sleep 1)
	(player_disable_movement 0)
)