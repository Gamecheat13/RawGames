(script dormant m52_insertion_stub
	(if debug (print "m52 insertion stub"))
)

;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 4)

;=========================================================================================
;================================== LEVEL START =========================================
;=========================================================================================



(script static void ins_secondary_objectives

	; set insertion point index 
	(set g_insertion_index 1)
	(set g_secondary_test 1)
	(wake m52_mission)
	(fade_in 0 0 0 0)
)


(script static void ins_building_a

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set m52_010_a)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 2)
	(set g_secondary_test 2)
;	(object_teleport (player0) ins_building_a_player_00)
;	(object_teleport (player1) ins_building_a_player_01)
;	(object_teleport (player2) ins_building_a_player_02)
;	(object_teleport (player3) ins_building_a_player_03)
	(wake m52_mission)
)
(script static void ins_building_b

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
;			(switch_zone_set set_060)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 2)
	(set g_secondary_test 3)

	(wake m52_mission)
)
(script static void ins_building_c

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
;			(switch_zone_set set_060)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 2)
	(set g_secondary_test 4)

	(wake m52_mission)
)
(script static void ins_oni

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
;			(switch_zone_set set_060)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 2)
	(set g_secondary_test 5)
	(set m_progression 0)
	(wake m52_mission)
)

(script static void fx_m52_mission
	(fade_in 0 0 0 0)

)
;*
(script dormant m52_covenant_cruiser_loop
	(sleep_until
		(begin
			(print "cruiser 1 event")
			(object_create vig_cruiser01)
			(device_set_position_track vig_cruiser01 m52_initial_start 0)	
			(device_animate_position vig_cruiser01 0.50 15 0 0 TRUE)	
			
			(object_create vig_cruiser02)
			(device_set_position_track vig_cruiser02 m52_mid 0)	
			(device_animate_position vig_cruiser02 0.5 15 0 0 TRUE)
				
			(sleep_until (>= (device_get_position vig_cruiser02) 0.50)5)
			
			(print "cruiser 3 event")
			(device_animate_position vig_cruiser01 1 30 0 0 TRUE)		
			(device_animate_position vig_cruiser02 1 30 0 0 TRUE)
			
			(sleep_until 
				(and
					(>= (device_get_position vig_cruiser01) 1)
					(>= (device_get_position vig_cruiser02) 1)
				)
			5)
			(object_destroy vig_cruiser01)
			(object_destroy vig_cruiser02)
		FALSE)
	)
)
*;
(script static void m52_covenant_cruiser_test
	;(print "cruiser 1 event")
	(wake m52_vig_cruiser01_progress)
	(object_create vig_cruiser01)
	(device_set_position_track vig_cruiser01 m52_initial_start 0)
	(device_animate_position vig_cruiser01 0 -1 0 0 FALSE)				
	(device_animate_position vig_cruiser01 0.81 30 5 5 FALSE)		
	(sleep_until (>= (device_get_position vig_cruiser01) 0.81)5)
	(interpolator_start glassing_glow_01)	
	(sleep 150)
	;(print "cruiser 2 event")
	(object_create vig_cruiser02)
	(device_set_position_track vig_cruiser02 m52_mid 0)
	(wake m52_vig_cruiser02_progress)		
	(device_animate_position vig_cruiser02 0.81 30 5 5 TRUE)
	(sleep_until (>= (device_get_position vig_cruiser02) 0.81)5)
	(interpolator_start glassing_glow_02)
	(sleep 150)
	;(print "cruiser 3 event")
	(device_animate_position vig_cruiser01 1 30 0 0 TRUE)		
	(device_animate_position vig_cruiser02 1 30 0 0 TRUE)	
	(cam_shake 5 0.05 7 10)
	(sleep 150)
	(object_destroy vig_cruiser01)
	(object_destroy vig_cruiser02)
)
;*
(script static void	m52_building_fall_test
	(object_create dm_building_fall)
	(sleep 90)
	(print "building fall")
	(device_set_position dm_building_fall 1)
	(sleep_until (>= (device_get_position dm_building_fall) 1))
	(sleep 60)
	(object_destroy dm_building_fall)
)

(script dormant	m52_building_fall_loop
	(sleep_until
		(begin
			(object_create dm_building_fall)
			(sleep 90)
			(print "building fall")			
			(device_set_position dm_building_fall 1)
			(sleep_until (>= (device_get_position dm_building_fall) 1))
			(sleep 60)
			(object_destroy dm_building_fall)
		false)
	)
)
*;